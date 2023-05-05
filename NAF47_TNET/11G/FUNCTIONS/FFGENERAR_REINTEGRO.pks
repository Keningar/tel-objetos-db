create or replace FUNCTION            FFGENERAR_REINTEGRO
 (
  pNo_Cia               in varchar2,
  pCod_Caja             in varchar2,
  pMensaje              in out varchar,
  vSecuencia_ck_nominal out varchar2,
  vSecuencia_ck_dolares out varchar2,
  pFecha_reintegro      in date,
  pAno_proce            in number,
  pMes_proce            in number,
  pno_comprobante_i     in number,
  pno_comprobante_f     in number
)Return Boolean IS
/**
* Documentacion para NAF47_TNET.FFGENERAR_REINTEGRO
* Funcion que procesa los comprobantes en Reintegros y genera Cheque en Modulo de Bancos para el respectivo Pago de la caja chica.
* @author yoveri <yoveri@yoveri.com>
* @version 1.0 01/01/2007
* @author Luis Lindao Rodriguez <llindao@telconet.ec>
* @version 1.1 21/11/2016 - Se modifica para validar si existen comprobantes sin distribucion contable no se genere el reintegro.
*
* @Param  pNo_cia               IN VARCHAR      Recibe codigo de compania
* @Param  pCod_Caja             IN VARCHAR2     Recibe codigo de Caja Chica
* @Param  pMensaje              IN OUT VARCHAR2 Devuelve mensajes de errores
* @Param  vSecuencia_ck_nominal OUT VARCHAR2    Devuelve transaccion numero generado en bancos en moneda nominal
* @Param  vSecuencia_ck_dolares OUT VARCHAR2    Devuelve transaccion numero generado en bancos en moneda dolares
* @Param  pFecha_reintegro      IN DATE         Recibe fecha generacion de reintegro
* @Param  pAno_proce            IN NUMBER       Recibe anio proceso
* @Param  pMes_proce            IN NUMBER       Recibe mes proceso
* @Param  pno_comprobante_i     IN NUMBER       Recibe rango inicial de numero comprobante
* @Param  pno_comprobante_f     IN NUMBER       Recibe rango final de numero comprobante
* @return BOOLEAN Retorna si el proceso fue satisfactorio o no.
*/ 


  -- cursor que recupera documentos sin distribucion contable
  CURSOR c_sinDistContable IS
    SELECT no_comprobante
    FROM taffmm
    WHERE no_cia = pNo_Cia
    AND cod_caja = pCod_Caja
    AND tipo_mov = 'CO'
    AND ((saldo_nom = 0 AND nvl(no_cheque_nom, 0) = 0) OR
         (saldo_dol = 0 AND nvl(no_cheque_dol, 0) = 0))
    AND nvl(ind_anulado, 'N') = 'N'
    AND estado = 'A'
    AND to_number(no_comprobante) >= pno_comprobante_i
    AND to_number(no_comprobante) <= pno_comprobante_f
    AND NOT EXISTS ( SELECT NULL 
                       FROM taffdc
                      WHERE taffdc.Transa_Id = taffmm.transa_id
                        AND taffdc.no_cia = taffmm.no_cia);
    --
    pMonto_ck_Nom         number(17,2);
    pMonto_ck_Dol         number(17,2);
    vNo_cta_Bco_Nominal   ARCKMC.no_cta%TYPE;
    vNo_cta_Bco_Dolares   ARCKMC.no_cta%TYPE;
    vCuenta_Bco_Nom       ARCGMS.Cuenta%TYPE;
    vCuenta_Bco_Dol       ARCGMS.Cuenta%TYPE;
    vResponsable          TAFFMC.Nombre_Responsable%TYPE;
    vMsg                  varchar2(512);
    pFecha_doc            arckce.fecha%type;

-- ========================================================================= --
-- Revisa si existe algun cmprobante pendiente de reintegrar, o sea que su   --
-- saldo este en cero y que no tenga asociado un No. de cheque (o solicitud) --
-- ========================================================================= --
Function Existen_Pendientes (pCompania in Varchar2, pCod_Caja in Varchar2) Return Boolean IS
  vpendientes number:=0;
BEGIN
  Select count(*)
    into vpendientes
   from taffmm
   Where no_cia   = pCompania
     and cod_caja = pCod_caja
     and tipo_mov = 'CO'
     and ((saldo_nom = 0 and nvl(no_cheque_nom,0)=0)  or
         (saldo_dol  = 0 and nvl(no_cheque_dol,0)=0))
     and  nvl(ind_anulado,'N')='N'
     and estado = 'A'
     and to_number(no_comprobante) between pno_comprobante_i and pno_comprobante_f;
  -- Si no existen comprobantes pendientes, los vi!!!
  Return (Nvl(vpendientes,0)>0);
END Existen_Pendientes;


-- =================================================================================== --
-- Genera la(s) correspondiente solicitud de cheque por el monto correspondiente a     --
-- reintegrar.                                                                         --
-- =================================================================================== --
Function genera_cheque
(
 pNo_cia                in Varchar2,
 pCod_Caja              in Varchar2,
 pNombre_Responsable   out Varchar2,
 pMonto_ck_Nom          in out Number,
 pMonto_ck_Dol          in out Number,
 pNo_cta_Bco_nominal   in out Varchar2,
 pNo_cta_Bco_Dolares   in out Varchar2,
 pCuenta_bco_nom        in out Varchar2,
 pCuenta_bco_Dol        in out Varchar2,
 pSecuencia_ck_nominal out number,
 pSecuencia_ck_dolares out number,
 pMensaje              in out Varchar2
 ) return Boolean IS

 Cursor Comprobantes_Nom Is
   Select transa_id, monto_nom, monto_dol
     from taffmm
    Where no_cia    = pno_cia
      and cod_caja  = pcod_caja
      and tipo_mov  = 'CO'
      and saldo_nom = 0
      and nvl(no_cheque_nom,0)=0
      and to_number(no_comprobante) between pno_comprobante_i and pno_comprobante_f
      and estado    = 'A'
  For update of no_cheque_nom, no_cta_nom;

 Cursor Comprobantes_Dol Is
   Select transa_id, monto_dol, monto_nom
     from taffmm
    Where no_cia    = pno_cia
      and cod_caja  = pcod_caja
      and tipo_mov  = 'CO'
      and saldo_dol = 0
      and nvl(no_cheque_dol,0)=0
      and to_number(no_comprobante) between pno_comprobante_i and pno_comprobante_f
       and estado    = 'A'
  For update of no_cheque_dol, no_cta_dol;


 Cursor Devoluciones (pTransa_id Varchar2, pMoneda Varchar2) Is
  Select Nvl(Sum(Monto),0)
    from taffdd
   Where no_cia    = pno_cia
     and transa_id = pTransa_id
     and moneda    = pMoneda
     and cod_gasto = 'DEVOL';

  --Obtiene los dias de vencimiento de la cuenta dada como parametro
  CURSOR c_dias_vencimiento(pCuenta varchar2) IS
    SELECT dias_vencimiento
      FROM arckmc
     WHERE no_cia   = pNo_cia
       AND no_cta   = pCuenta;


  v_moneda_cta_nom         arckmc.moneda%TYPE;
  v_moneda_cta_dol         arckmc.moneda%TYPE;
  v_Monto_nom               arckce.monto%TYPE;
  v_Monto_dol               arckce.monto%TYPE;
  vDevoluciones             number(17,2);
  vMto_nom_en_dol           number(17,2);
  vMto_dol_en_nom          number(17,2);
  vFecha_nom               date;
  vFecha_dol               date;
  vFecha_Cambio             date;
  vMsg                     varchar2(512);
  vCta_caja_chica_nominal  varchar2(15);
  vCta_caja_chica_dolares  varchar2(15);
  vTipo_cambio             arcgtc.tipo_cambio%TYPE;
  vClase_cambio            taffmc.clase_cambio%TYPE;
  vAno                     number(4);
  vNo_mes                  number(2);
  vcc                      taffdc.centro_costo%TYPE;
  vDias_vencimiento_nom    arckmc.dias_vencimiento%type;
  vDias_vencimiento_dol    arckmc.dias_vencimiento%type;
  vTipo_docu               taffmc.tipo_docu%type;
  
-- =================================================================================== --
-- Devuelve el No. de la siguiente solicitud y la fecha en que debe generarse.         --
-- =================================================================================== --
FUNCTION Siguiente_Cheque
(
  pNo_cia     in varchar2,
  pNo_cta_bco in Varchar2,
  pMonto      in Number,
  pCuenta     out Varchar2,
  pMoneda     out Varchar2,
  pFecha      in out date,
  pAno_proce  in number,
  pMes_proce  in number,
  pMensaje    in out Varchar2
) RETURN number IS

  vAno_proce_ck   arckmc.ano_proc%type;
  vMes_proce_ck   arckmc.mes_proc%type;
  v_secuencia      arckce.no_secuencia%type;
  vDia_cierre     arckmc.dia_cierre%type;
  vDummy          varchar2(1);

BEGIN
  If Nvl(pMonto,0) > 0 Then
    -- Utiliza la funcion Consecutivos para obtener la secuencia del cheque
    BEGIN
      v_Secuencia := transa_id.CK(pNo_Cia);
    EXCEPTION
      WHEN transa_id.error THEN
        pMensaje:=transa_id.ultimo_error;
    END;
    Begin
      select no_cuenta, moneda, ano_proc, mes_proc, dia_cierre
        into pCuenta, pMoneda, vAno_proce_ck, vMes_proce_ck, vDia_cierre
        from arckmc
       where no_cia = pno_cia
         and no_cta = pNo_cta_bco;

       --Si la fecha de la cuenta bancaria es mayor a la fecha en proceso de la caja chica
       --toma la fecha de la cuenta bancaria, sino toma la fecha de reintegro
       IF to_date('01'||to_char(vMes_proce_ck,'00')||to_char(vAno_proce_ck,'9999'),'ddmmyyyy') >
          to_date('01'||to_char(pMes_proce,'00')||to_char(pAno_proce,'9999'),'ddmmyyyy') THEN
          pFecha := vDia_cierre;
       ELSE
          pFecha  := pFecha_reintegro;
       END IF;

    Exception
      When no_data_found Then
        pMensaje := 'No se logro obtener la inf. en la cuenta bancaria '||pNo_Cta_Bco;
    End;
    Return v_Secuencia;
  Else
    Return null;
  End If;
END Siguiente_Cheque;


BEGIN
  -- carga las cuenta de caja chica x pagar.
  Select cta_caja_chica_x_pagar_nominal, cta_caja_chica_x_pagar_dolares,
         nombre_responsable, Clase_Cambio, ano_proce, mes_proce,
         No_Cta_Bco_Nominal, No_Cta_Bco_Dolares, TIPO_DOCU
    into vCta_caja_chica_nominal, vCta_caja_chica_dolares,
         pNombre_responsable, vClase_Cambio, vAno, vNo_mes,
         pNo_Cta_Bco_Nominal, pNo_Cta_Bco_Dolares, vTipo_docu
    from taffmc
   Where no_cia = pno_cia
     and cod_caja = pcod_caja;

  -- Obtiene el tipo de cambio del dia.
  vTipo_cambio := Tipo_cambio (vClase_cambio, sysdate, vFecha_cambio, 'V');

  -- Calcula los montos del reintegro.
  vmsg:='Calcula monto a reintegrar';
  pmonto_ck_nom := 0;
  pmonto_ck_dol := 0;

  For c in Comprobantes_Nom Loop
    -- Calcula si se realizo una devolucion de dinero en ese comprobante.
    Open Devoluciones (c.Transa_id, 'P');
    Fetch Devoluciones into vDevoluciones;
    If Devoluciones%NotFound Then
      vDevoluciones := 0;
    End If;
    Close Devoluciones;

    pmonto_ck_nom := pmonto_ck_nom + c.monto_nom - Nvl(vDevoluciones,0);

    Update TAFFMM
       set no_cheque_nom = -9998,
           no_cta_dol = Decode(c.monto_dol,0,'NO APLICA',no_cta_dol),
           no_cheque_dol = Decode(c.monto_dol,0,0,no_cheque_dol)
     Where current of Comprobantes_nom;
  End Loop;

  For c in Comprobantes_Dol Loop
    -- Calcula si se realizo una devolucion de dinero en ese comprobante.
    Open Devoluciones (c.Transa_id, 'D');
    Fetch Devoluciones into vDevoluciones;
    If Devoluciones%NotFound Then
      vDevoluciones := 0;
    End If;
    Close Devoluciones;

    pmonto_ck_dol := pmonto_ck_dol + c.monto_dol - Nvl(vDevoluciones,0);

    Update TAFFMM
      set no_cheque_dol = -9997,
           no_cta_nom = Decode(c.monto_nom,0,'NO APLICA',no_cta_nom),
           no_cheque_nom = Decode(c.monto_nom,0,0,no_cheque_nom)
     Where current of Comprobantes_dol;
  End Loop;

  -- Asigna el siguiente consecutivo de cheques (secuencia).
  pSecuencia_ck_nominal := Siguiente_cheque( pNo_Cia, pNo_cta_bco_nominal,
                                             pmonto_ck_nom, pcuenta_bco_nom,
                                             v_moneda_cta_nom, pFecha_doc,
                                             pAno_proce, pMes_proce,
                                             pMensaje);
  If pMensaje is not null Then
    Return False;
  End If;
  pSecuencia_ck_dolares := Siguiente_cheque( pNo_Cia, pNo_cta_bco_dolares,
                                             pmonto_ck_dol, pcuenta_bco_dol,
                                             v_moneda_cta_dol,pFecha_doc,
                                             pAno_proce, pMes_proce,
                                             pMensaje);
  If pMensaje is not null Then
    Return False;
  End If;
  -- Si existe reintegro en nominal entonces se genera el cheque correspondiente a la
  -- cuenta bancaria definida para tal efecto en la informacion de la caja chica.
  -- Si la moneda de la cuenta bancaria es distinta a la del pago es necesario hacer conversion
  If v_Moneda_cta_nom = 'P' Then
    v_monto_nom := Moneda.redondeo(pmonto_ck_nom, 'P');
  Else -- Cuenta en dolares
    v_Monto_nom := Moneda.redondeo(pmonto_ck_nom / vTipo_cambio, 'D');
  End If;

  If pmonto_ck_nom > 0 Then
    vcc := centro_costo.rellenad(pno_cia,'0');
    vMto_Nom_en_Dol := Moneda.redondeo(pmonto_ck_nom/vTipo_cambio,'D');
    vmsg:='Solicita el cheque en nominal '||to_char(pmonto_ck_nom)||'.';

    OPEN  c_dias_vencimiento(pNo_cta_bco_nominal);
    FETCH c_dias_vencimiento INTO vDias_vencimiento_nom;
    CLOSE c_dias_vencimiento;

    If  vTipo_Docu = 'CK'  Then
      INSERT INTO ARCKCE (no_cia, no_cta, tipo_docu, no_secuencia,
                      cheque,fecha,monto,
                      beneficiario,ind_act, com,
                      ind_con, emitido, tot_ref, tot_dife_cam,
                      tot_db ,tot_cr, saldo,
                      moneda_cta, tipo_cambio, monto_nominal,
                      saldo_nominal,autoriza,origen,
                      t_camb_c_v, fecha_vence)
                      
             VALUES  (pno_cia, pno_cta_bco_nominal,  vTipo_Docu, --'CK',
                      pSecuencia_ck_nominal,
                      NULL, pFecha_doc, v_Monto_nom,
                      -- MNA 22/07/2006 SE COMENTAREO ESTA LINEA PARA QUE NO SE ASIGNE EL SECUENCIAL AL no. DEL CHEQUE.
                     --pSecuencia_ck_nominal, pFecha_doc, v_Monto_nom,  -- SENTENCIA ORIGINAL
                     pNombre_responsable,'P','REINTEGRO DE CAJA CHICA '||pCod_caja,
                     'P','N',0,0,
                     v_Monto_nom, v_Monto_nom, 0,
                     v_Moneda_cta_nom, vtipo_cambio, pmonto_ck_nom,
                     0, 'N','FF',
                     'V', (pFecha_doc + nvl(vDias_vencimiento_nom,0) ) );
    Else
        INSERT INTO ARCKCE (no_cia, no_cta, tipo_docu, no_secuencia,
                            cheque,fecha,monto,
                            beneficiario,ind_act, com,
                            ind_con, emitido, tot_ref, tot_dife_cam,
                            tot_db ,tot_cr, saldo,
                            moneda_cta, tipo_cambio, monto_nominal,
                            saldo_nominal, autoriza, origen,
                            t_camb_c_v, fecha_vence, 
                            tipo_transfe, tipo_d)
                   VALUES  (pno_cia, pno_cta_bco_nominal,  vTipo_Docu, 
                            pSecuencia_ck_nominal,
                            NULL, pFecha_doc, v_Monto_nom,
                            pNombre_responsable,'P','REINTEGRO DE CAJA CHICA '||pCod_caja,
                            'P','S',0,0,
                            v_Monto_nom, v_Monto_nom, 0,
                            v_Moneda_cta_nom, vtipo_cambio, pmonto_ck_nom,
                            0,  'N' , 'FF',
                            'V',  (pFecha_doc + nvl(vDias_vencimiento_nom,0)), 
                            'U','S' );
    End if;
    vmsg:='Debita caja chica por pagar nominal';

    INSERT INTO ARCKCL ( no_cia, centro_costo, tipo_docu,
                         cod_cont, tipo_mov, monto,
                         monto_dol,moneda, no_secuencia,
                          tipo_cambio, monto_dc,
                          modificable)
               VALUES  (pno_cia, vcc, vTipo_Docu, --'CK',
                        vCta_caja_chica_nominal,'D', pmonto_ck_nom,
                        vMto_nom_en_dol, v_Moneda_cta_nom,pSecuencia_ck_nominal,
                        vtipo_cambio, pmonto_ck_nom,
                        'N' ) ;

    vmsg:='Acredita el banco';
    INSERT INTO arckcl ( no_cia, centro_costo, tipo_docu,
                         cod_cont, tipo_mov, monto,
                         monto_dol,moneda, no_secuencia,
                          tipo_cambio, monto_dc,
                          modificable)
               VALUES  (pno_cia, vcc, vTipo_Docu, --'CK',
                        pCuenta_bco_nom,'C', pmonto_ck_nom,
                        vMTo_Nom_en_Dol, v_Moneda_cta_nom,pSecuencia_ck_nominal,
                        vTipo_cambio,pmonto_ck_nom,
                        'N');

   -- Registra la solicitud en el historico de transacciones a Cheques.
    vmsg:='Actualiza el historico de transacciones realizadas al sistema de cheques';
    INSERT  INTO taffck (no_cia, cod_caja,ano,
                        mes, no_cta, tipo_doc,
                        no_secuencia, no_docu, fecha,
                        ind_anulado, monto, moneda,
                        detalle, origen, monto_ck)
                VALUES (pno_cia, pcod_caja, pAno_proce,
                        pMes_proce, pNo_Cta_Bco_Nominal, vTipo_Docu, --'CK',
                        pSecuencia_ck_nominal, pSecuencia_ck_nominal,pFecha_doc,
                        'P', pmonto_ck_nom, 'P',
                        'Reintegro de la caja en moneda nominal','RE',pmonto_ck_nom);
  END IF;


  --***********************************************
  -- Se revisa igual para la cuenta en dolares
  --***********************************************
  If v_Moneda_cta_dol = 'D' Then
    v_monto_dol := Moneda.redondeo(pmonto_ck_dol,'D');
  Else -- cuenta en nominal
    v_Monto_dol := Moneda.redondeo(pmonto_ck_dol * vTipo_cambio,'P');
  End If;

  If pmonto_ck_dol > 0 Then
    vcc := centro_costo.rellenad(pno_cia,'0');
    vmsg:='Solicita el cheque en Dolares por '||to_char(pmonto_ck_dol)||'.';
    vMto_Dol_en_Nom := Moneda.redondeo(pMonto_ck_Dol*vTipo_Cambio,'P');

    OPEN  c_dias_vencimiento(pNo_cta_bco_dolares);
    FETCH c_dias_vencimiento INTO vDias_vencimiento_dol;
    CLOSE c_dias_vencimiento;

    If  vTipo_Docu = 'CK'  Then
         insert INTO ARCKCE (no_cia, no_cta, tipo_docu, no_secuencia,
                            cheque,fecha,monto,
                            beneficiario,ind_act, com,
                            ind_con, emitido, tot_ref, tot_dife_cam,
                            tot_db ,tot_cr, saldo,
                            moneda_cta, tipo_cambio, monto_nominal,
                            saldo_nominal,autoriza,origen,
                            t_camb_c_v, fecha_vence)
                   values  (pno_cia, pno_cta_bco_dolares, vTipo_Docu, --'CK',
                            pSecuencia_ck_dolares,
                            pSecuencia_ck_dolares, pFecha_doc, v_Monto_dol,
                            pNombre_responsable,'P','REINTEGRO DE CAJA CHICA '||pCod_caja,
                            'P', 'N',0,0,
                            v_Monto_dol, v_Monto_dol, 0,
                            v_Moneda_cta_dol,  vTipo_cambio,
                            vMto_dol_en_Nom, 0, 'N',
                            'FF', 'V',
                            (pFecha_doc + nvl(vDias_vencimiento_dol,0)) );
     Else  
         insert INTO ARCKCE (no_cia, no_cta, tipo_docu, no_secuencia,
                            cheque,fecha,monto,
                            beneficiario,ind_act, com,
                            ind_con, emitido, tot_ref, tot_dife_cam,
                            tot_db ,tot_cr, saldo,
                            moneda_cta, tipo_cambio, monto_nominal,
                            saldo_nominal,autoriza,origen,
                            t_camb_c_v, fecha_vence,
                            tipo_transfe, tipo_d)
                            
                   values  (pno_cia, pno_cta_bco_dolares, vTipo_Docu, --'CK',
                            pSecuencia_ck_dolares,
                            pSecuencia_ck_dolares, pFecha_doc, v_Monto_dol,
                            pNombre_responsable,'P','REINTEGRO DE CAJA CHICA '||pCod_caja,
                            'P', 'S',0,0,
                            v_Monto_dol, v_Monto_dol, 0,
                            v_Moneda_cta_dol,  vTipo_cambio, vMto_dol_en_Nom, 
                            0, 'N', 'FF', 
                            'V', (pFecha_doc + nvl(vDias_vencimiento_dol,0)), 
                            'U',  'S' );
     End if;     
     
    vmsg:='Debita caja chica por pagar dolares ('||vCTA_CAJA_CHICA_DOLARES||').';
    INSERT INTO arckcl ( no_cia, centro_costo, tipo_docu,
                         cod_cont, tipo_mov, monto,
                         monto_dol,moneda, no_secuencia,
                          tipo_cambio, monto_dc)
               VALUES  (pno_cia, vcc, vTipo_Docu, --'CK',
                        vCta_caja_chica_dolares,'D',vMto_Dol_en_Nom,
                        pmonto_ck_dol, v_Moneda_cta_dol,pSecuencia_ck_dolares,
                        vTipo_cambio, pmonto_ck_dol ) ;

    vmsg:='Acredita la cuenta del banco dolares ('||pCuenta_bco_Dol||').';
     INSERT INTO arckcl ( no_cia, centro_costo, tipo_docu,
                         cod_cont, tipo_mov, monto,
                         monto_dol,moneda, no_secuencia,
                          tipo_cambio, monto_dc)
               VALUES  (pno_cia, vcc, vTipo_Docu, --'CK',
                        pCuenta_bco_dol,'C', vMto_Dol_en_Nom,
                        pmonto_ck_dol, v_Moneda_cta_dol, pSecuencia_ck_dolares,
                        vTipo_cambio, pmonto_ck_dol ) ;

    -- Registra la solicitud en el historico de transacciones a Cheques.
    vmsg:='Actualiza el historico de transacciones realizadas al sistema de cheques';
    INSERT  INTO taffck (no_cia, cod_caja,ano,
                        mes, no_cta, tipo_doc,
                        no_secuencia, no_docu, fecha,
                        ind_anulado, monto, moneda,
                        detalle, origen, monto_ck)
                values (pno_cia, pCod_caja, pAno_proce,
                        pMes_proce, pNo_Cta_Bco_Dolares, vTipo_Docu, --'CK',
                        pSecuencia_ck_dolares, pSecuencia_ck_dolares, pFecha_doc,
                        'P', pmonto_ck_dol, 'D',
                        'Reintegro de la caja en Dolares','RE',pmonto_ck_dol);
  End If;
  -- Actualiza el No. de solicitud en los comprobantes.
  Update TAFFMM
     set no_cheque_nom = pSecuencia_ck_nominal,
         no_cta_nom = pno_cta_bco_nominal
   Where nvl(no_cheque_nom,0) = -9998;
  Update TAFFMM
     set no_cheque_dol = pSecuencia_ck_dolares,
         no_cta_dol = pno_cta_bco_dolares
   Where nvl(no_cheque_dol,0) = -9997;
  pMensaje:=Null;
  Return TRUE;
Exception
 When others Then
   pMensaje:='Se produjo el siguiente error generando la solicitud de cheque: '||sqlerrm;
   Return FALSE;
END Genera_Cheque;

-- ============================================================================== --
-- Genera el correspondiente movimiento de reintegro en el maestro de movimientos --
-- de la caja.                                                                    --
-- ============================================================================== --
Function Genera_Movimiento
(
 pNo_Cia                in Varchar2,
 pCod_Caja              in Varchar2,
 pNombre_Responsable   in Varchar2,
 pMonto_ck_nom          in out Number,
 pMonto_ck_dol          in out Number,
 pNo_Cta_Bco_Nominal   in out Varchar2,
 pNo_Cta_Bco_Dolares   in out Varchar2,
 pCuenta_bco_Nom        in out Varchar2,
 pCuenta_bco_Dol        in out Varchar2,
 pSecuencia_ck_nominal in Number,
 pSecuencia_ck_dolares in Number,
 pMensaje              in out Varchar2
 ) Return Boolean IS

  vTransa_id       TAFFMM.Transa_id%TYPE;
  vNo_Comprobante  TAFFMM.No_Comprobante%TYPE;
  vClase_Cambio    TAFFMC.Clase_CAmbio%TYPE;
  vTipo_Cambio     ARCGTC.Tipo_Cambio%TYPE;
  vFecha_Cambio    Date;
  vAno             taffmm.ano_proce %type;
  vNo_mes          taffmm.mes_proce %type;
  vcc              taffdc.centro_costo%TYPE;

FUNCTION Siguiente_Comprobante
(
 pNo_cia in Varchar2,
 pCod_Caja in Varchar2,
 pAno in Number,
 pMes in Number,
 pMensaje in out Varchar2
 ) RETURN Varchar2 IS

   vSiguiente_Consec  TAFFMM.No_Comprobante%TYPE;
BEGIN
  vSiguiente_consec := CONSECUTIVO.ff(pNo_Cia, pano, pMes,pCod_Caja,'COMPROBANTE');
  pMensaje := null;
  Return (vSiguiente_Consec);
EXCEPTION
  WHEN CONSECUTIVO.error THEN
    pMensaje:=CONSECUTIVO.ultimo_error;
END;

BEGIN
  -- Obtiene La clase de cambio
  Begin
    Select Clase_Cambio
      Into vClase_Cambio
      From taffmc
     Where no_cia = pno_cia and
           cod_caja = pcod_caja;
  Exception
    When Others Then
      pMensaje :='No se puede determinar la informacion necesaria para esta caja ('
             ||pcod_caja||') en la cia. '||pNo_cia;
      Return False;
  End;
  -- Obtiene el tipo de cambio del dia.
  vTipo_cambio := Tipo_cambio (vClase_cambio, sysdate, vFecha_cambio, 'V');

  -- Inserta un movimiento de Reintegro (Tipo 'RE') en la tabla de movientos.
  vTransa_id := Transa_id.ff(pNo_Cia);

  vNo_comprobante := Siguiente_Comprobante (pNo_cia, pCod_Caja, pAno_proce, pMes_proce,
                                            pMensaje);
  If pMensaje is not null Then
    Return False;
  End If;

  -- Se genera el movimiento para el monto en NOMINAL
  If pmonto_ck_nom > 0 then
    -- Inserta el encabezado del movimiento.
    Begin
      Insert into TAFFMM (NO_CIA, TRANSA_ID, COD_CAJA, NO_COMPROBANTE, TIPO_MOV,
                          FECHA, BENEFICIARIO, RETIRADO_POR,
                          DETALLE, MONTO_DOL,
                          MONTO_NOM, SALDO_DOL, SALDO_NOM, AUTORIZADO_POR, NO_CTA_NOM,
                          NO_CHEQUE_NOM, IND_ANULADO, FECHA_DIGITADO, USUARIO, ANO_PROCE,
                          MES_PROCE,  USUARIO_AUTORIZA)
          values (pNo_Cia, vTransa_id, pCod_caja, vNo_comprobante, 'RE',
                  pFecha_doc, pnombre_responsable, pnombre_responsable,
                  'Reintegro de Caja Chica '||pCod_Caja, 0,
                  pmonto_ck_nom, 0, 0, null, pno_cta_bco_nominal,
                  pSecuencia_ck_nominal, 'P', SYSDATE, Upper(user), pAno_proce,
                  pMes_proce, Upper(User));
    Exception
      When others Then
        pMensaje := 'Error de Procesamiento inserta encabezado de Mov.: '||sqlerrm;
        Return FALSE;
    End;
    -- Inserta el detalle.
    Begin
      Insert into TAFFDD (NO_CIA, TRANSA_ID, NO_LINEA, NO_DOCU,
                          NO_SERIE, FECHA_DOCU,
                          DETALLE, MONEDA,
                          TIPO_CAMBIO, MONTO, CUENTA,
                          CENTRO_COSTO, EXCENTO, GRABADO)
           values (pno_cia, vTransa_id, 1, pSecuencia_ck_nominal,
                   '0',  pFecha_doc,
                    'Cheque para reintegro '|| 'de la caja chica Cod. '||pcod_caja,'P',
                    vTipo_cambio, pmonto_ck_nom, pcuenta_bco_nom,
                    vcc, pmonto_ck_nom, 0);
    Exception
      When others Then
        pMensaje:='Error de Procesamiento insertando detalle de Mov.: '||sqlerrm;
        Return FALSE;
    End;
  End If;

  -- Se genera el movimiento para el monto en dolares.
  If pmonto_ck_dol > 0 then
    vTransa_id := Transa_id.ff(pNo_Cia);
    vNo_comprobante:=siguiente_Comprobante(pNo_cia, pCod_Caja, pAno_proce, pMes_proce, pMensaje);
    If pMensaje is not null Then
      Return False;
    End If;
    -- Inserta el encabezado del movimiento.
    Begin
      INSERT INTO taffmm (no_cia, transa_id, cod_caja, no_comprobante,
                          tipo_mov, fecha, beneficiario, retirado_por,
                          detalle,
                          monto_dol, monto_nom, saldo_nom,saldo_dol,
                          autorizado_por, no_cta_dol, no_cheque_dol, ind_anulado,
                          fecha_digitado, usuario, ano_proce, mes_proce,
                          usuario_autoriza)
          VALUES (pNo_cia, vTransa_id, pCod_caja, vNo_comprobante,
                  'RE',  pFecha_doc, pnombre_responsable, pnombre_responsable,
                  'Reintegro de caja chica '||pCod_Caja,
                   pmonto_ck_dol,0, 0, 0, null,
                   pno_cta_bco_dolares, psecuencia_ck_dolares, 'P',
                   SYSDATE, Upper(user), pAno_proce, pMes_proce, Upper(User));
    Exception
      When others Then
        pMensaje:='Error de Procesamiento inserta encabezado de Mov. Dolares: '||sqlerrm;
        Return FALSE;
    End;
    -- Inserta el detalle.
    Begin
      INSERT INTO taffdd (no_cia, transa_id, no_linea, no_docu,
                          no_serie,fecha_docu,
                          detalle, moneda,
                          tipo_cambio, monto, cuenta,
                          centro_costo, excento, grabado)
           VALUES (pno_cia, vTransa_id, 1, pSecuencia_ck_dolares,
                   '0',  pFecha_doc,
                   'Cheque por reintegro '||'de la caja chica Cod. '||pcod_caja, 'D',
                   vTipo_cambio, pmonto_ck_dol, pCuenta_bco_dol,
                   vcc, pMonto_ck_Dol,0);
    Exception
      When others Then
        pMensaje:='Error de Procesamiento insertando detalle de Mov. Dolares: '||sqlerrm;
        Return FALSE;
    End;
  End If;
  pMensaje := Null;
  Return TRUE;
END Genera_Movimiento;


---*****  BEGIN  PRINCIPAL  *********************
BEGIN
  -- Revisa si hay comprobantes pendientes.
  vmsg:='Revisa si hay comprobantes pendientes';
  If Not Existen_Pendientes (pNo_Cia, pCod_Caja) Then
    pMensaje := 'No existen comprobantes pendientes de generar.';
    Return False;
  End if;
  --
  -- Revisa si existen documentos sin distribucion contable
  FOR I_SinDistCont IN c_sinDistContable LOOP
    IF pMensaje IS NULL THEN
      pMensaje := I_SinDistCont.No_Comprobante;
    ELSE
      pMensaje := pMensaje || ',' || I_SinDistCont.No_Comprobante;
    END IF;
  END LOOP;
  --
  -- Si pMensaje retorna datos entonces existen documentos inconsistentes --
  IF pMensaje IS NOT NULL THEN
    pMensaje := 'Los siguientes comprobantes se encuentran sin Distribucion contable: '||chr(10)||pMensaje;
    RETURN FALSE;
  END IF;
  --
-- Genera el cheque correspondiente.
  vmsg:='Genera el cheque correspondiente';
  If Not Genera_cheque (pNo_cia, pCod_Caja, vResponsable, pMonto_ck_Nom, pMonto_ck_Dol,
                 vNo_Cta_Bco_Nominal, vNo_Cta_Bco_Dolares, vCuenta_bco_nom,
                 vCuenta_Bco_Dol, vSecuencia_ck_nominal, vSecuencia_ck_dolares,
                 pMensaje) Then
    Return False;
  End If;
-- Genera el movimiento correspondiente en la caja.
  vmsg:='Genera el movimiento de reintegro';
  If Not Genera_movimiento (pNo_cia, pCod_Caja, vResponsable, pMonto_ck_nom, pMonto_ck_Dol,
                       vNo_Cta_Bco_Nominal, vNo_Cta_Bco_Dolares, vCuenta_Bco_Nom,
                       vCuenta_Bco_Dol, vSecuencia_ck_nominal, vSecuencia_ck_dolares,
                       pMensaje) Then
    Return False;
  End If;

  Return TRUE;
END;