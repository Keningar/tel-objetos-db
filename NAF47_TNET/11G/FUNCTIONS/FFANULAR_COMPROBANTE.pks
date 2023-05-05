create or replace FUNCTION            FFANULAR_COMPROBANTE
  (PNO_CIA  IN  VARCHAR2
  ,PTRANSA_ID  IN  VARCHAR2
  ,PMENSAJE  IN  OUT  VARCHAR2
  )
  RETURN  BOOLEAN
  IS
 -- PL/SQL Specification
-- PL/SQL Specification
Cursor  Comprobante  is
   Select  mm.beneficiario,  mm.fecha,  mm.monto_nom,  mm.monto_dol,
          mm.saldo_nom,  mm.saldo_dol,  mm.no_prove,  mm.no_cliente,  mm.ind_anulado,
          mm.grupo,  mm.transa_id,  mm.no_comprobante,  mm.no_cia,  mm.cod_caja,
          mc.ano_proce,  mc.mes_proce,  mc.Clase_Cambio
     from  taffmm  mm,  taffmc  mc
    Where  mm.no_cia     =  pNo_cia
      and  mm.transa_id  =  pTransa_id
      and  mc.no_cia     =  mm.no_cia
      and  mc.cod_caja   =  mm.cod_caja;
 
  CURSOR  c_ruta  (pcia  varchar2,  pgrupo  varchar2,  pcliente  varchar2)IS
       SELECT  ruta
        FROM  arccar
      WHERE  no_cia      =    pcia
        AND  grupo       =    pgrupo
        AND  no_cliente  =    pcliente;
 

  vComp_cxc_Nom 		      Number(17,2):=0;
   vComp_Cxp_Nom 		      Number(17,2):=0;
   vComprobante_nom 	    Number(17,2):=0;
   vComp_cxc_Dol 		      Number(17,2):=0;
   vComp_Cxp_Dol 		      Number(17,2):=0;
   vComprobante_Dol      	Number(17,2):=0;
   vFecha_Cambio          Date;
   vTipo_Cambio           Number(17,2);
   vcc                    taffdc.centro_costo%type;
   uno                    Comprobante%rowtype;
   vMensaje_Error         Varchar2(512);
 
PROCEDURE  Anula_Conta  IS
 BEGIN
  -- Si ya fue generado contablemente entonces lo reversa y si no ha sido generado
  -- entonces asigna 'ANULAD' como No. de asiento para aparentar que ya se genero.
  Update TAFFDC
     set no_asiento = Decode(no_asiento,null,'ANULAD',null),
         ano_conta  = Decode(no_asiento,null,Uno.ano_proce,null),
         mes_conta  = Decode(no_asiento,null,Uno.mes_proce,null),
         naturaleza = Decode(no_asiento,null,naturaleza,Decode(naturaleza,'D','C','D'))
   Where no_cia         = Uno.no_cia and
         transa_id      = Uno.Transa_id;
END Anula_Conta; 

Function  Reversa_cxc  Return  Boolean  IS
 -- -------------------------------------------------------------------------------- --
-- Este procedimiento aplica la suma de esta liquidacion al saldo del cliente en la --
-- moneda correspondiente (la del cliente). Se genera ademas el documento de liqui- --
-- dacion (Parametrizado en la inf. de la caja) y la referencia correspondiente al  --
-- comprobante como tal.                                                            --
-- -------------------------------------------------------------------------------- --

  CURSOR  c_fecha_comprobante  IS
 	  SELECT  fecha
 	  FROM  taffmm
 	  WHERE  no_cia         =  uno.no_cia
 	   AND  cod_caja        =  uno.cod_caja
 	   AND  no_comprobante  =  uno.no_comprobante;
 
   tipo_C                     arcgtc.tipo_cambio%type;
   tipo_M                     arccmc.moneda_limite%type;
   vcentro                    arccmc.centro%type;
   vruta                      arccar.ruta%type;
   vPERIODO                   arccMD.PERIODO%type;
   monto_al_tipo_moneda       arccmc.saldo_ante%type;
   vfecha                     date;
   vTipo_doc_comprobante_cxc  taffmc.tipo_doc_comprobante_cxc%TYPE;
   vtipo_doc_liquidacion_cxc  taffmc.tipo_doc_liquidacion_cxc%TYPE;
   vtipo_doc_anulacion_cxc    taffmc.tipo_doc_anulacion_cxc%TYPE;
   vAno_CxC                   ARINCD.Ano_proce_CxC%TYPE;
   vMes_CxC                   ARINCD.Mes_proce_CxC%TYPE;
   vSemana_CxC                ARINCD.Semana_proce_CxC%TYPE;
   vtransa_id                 arccmd.NO_DOCU%TYPE;
   vfecha_c                   taffmm.fecha%TYPE;
 
BEGIN
  --Trae el tipo de moneda y calcula el saldo en la moneda del cliente
  Begin
    select moneda_limite, centro
      into tipo_M, vcentro
      from arccmc
     where no_cia      =   Uno.no_cia
       and grupo       =   Uno.grupo
       and no_cliente  =   Uno.no_cliente;
  exception when no_data_found  then
    pMensaje := 'El codigo de cliente indicado en el comprobante no existe.';
    Return False;
  END;
  
  
  -- Obtiene el periodo en proceso de CxC
  Begin
    Select ano_proce_cxc, mes_proce_cxc, semana_proce_cxc
      into vAno_CxC, vMes_CxC, vSemana_CxC
      from arincd
     Where no_cia = Uno.no_cia
       and centro = vCentro;
  Exception
    When no_data_found Then
      pMensaje := 'Problemas para accesar la informacion del centro: '||vcentro||'.';
      Return FALSE;
  End;
  -- se calcula el monto a aplicar en la moneda del cliente
  if tipo_M = 'P' then
     monto_al_tipo_moneda:=Moneda.Redondeo(nvl(Uno.Monto_nom,0)  + (nvl(Uno.Monto_dol,0)*vTipo_Cambio),'P');
  else
     monto_al_tipo_moneda:=Moneda.Redondeo(nvl(Uno.Monto_dol,0) + (nvl(Uno.Monto_nom,0)/vTipo_Cambio),'D');
  end if;
  --Trae la ruta asignada al cliente
  Begin
    OPEN c_ruta(uno.no_cia, uno.grupo, uno.no_cliente);
    FETCH c_ruta INTO vruta;
    IF c_ruta%NOTFOUND THEN
      vruta:='0000';
    	pmensaje := 'El cliente no tiene una ruta asignada';
      
    END IF;
    CLOSE c_ruta;
  END;

  -- Obtiene los tipos de doc. para afectar CxC
  Begin
  Select tipo_doc_comprobante_cxc,tipo_doc_liquidacion_cxc, tipo_doc_anulacion_cxc
    into vtipo_doc_comprobante_cxc, vtipo_doc_liquidacion_cxc, vtipo_doc_anulacion_cxc
    from taffmc
   where no_cia   = Uno.no_cia
     and cod_caja = Uno.cod_caja;
  Exception
    When no_data_found then
      pMensaje := 'No se puede obtener la informacion para la Compa?ia y Caja seleccionada.';
      Return FALSE;
  End;
  --Actualiza el maestro de clientes
 begin
  update arccmc
    set creditos   = nvl(creditos,0) + monto_al_tipo_moneda
  where no_cia     =   Uno.no_cia
    and grupo      =   Uno.grupo
    and no_cliente =   Uno.no_cliente;
  exception when others then
    pMensaje := 'Actualizando la cuenta del Cliente : '||sqlerrm;
    Return FALSE;
  END;
  --Actualiza el maestro de documentos
  begin
    SELECT PERIODO
    INTO VPERIODO
      FROM ARCCMD
     where  no_cia     =   Uno.no_cia
       and  no_docu    =   Uno.Transa_id;
  exception when others then
     pMensaje := 'Actualizando el maestro de documentos del Cliente ('||Uno.Grupo||'-'||
            Uno.No_Cliente||') : '||sqlerrm;
     Return FALSE;
  END;

  -- Incluye el doc. de liquidacion en el estado de cuenta del cliente.
  --Obtiene otro numero de documento
  vtransa_id := transa_id.ff(pNo_cia);

  --Obtiene la fecha del comprobante
  OPEN c_fecha_comprobante;
  FETCH c_fecha_comprobante INTO vfecha_c;
  IF c_fecha_comprobante%NOTFOUND THEN
    pmensaje := 'El comprobante no tiene fecha asociada';
  END IF;
  CLOSE c_fecha_comprobante;
  
  insert into arccmd
    					(NO_CIA, CENTRO, TIPO_DOC, PERIODO,
     					RUTA, NO_DOCU, GRUPO, NO_CLIENTE,
     					FECHA, FECHA_VENCE, FECHA_VENCE_ORIGINAL, FECHA_DIGITACION,
     					CANT_PRORROGAS,NO_AGENTE, COBRADOR, SUBTOTAL,
     					EXENTO, M_ORIGINAL, SALDO, DESCUENTO,
				      TOTAL_REF, ESTADO, TOTAL_DB, TOTAL_CR,
				      INTERESES,CONCEPTO, PERI_LIQ, NO_LIQ,
				      ORIGEN, ANO, MES, SEMANA,
     					NO_FISICO, SERIE_FISICO,
     					FECHA_DOCUMENTO, ANULADO)
  values
		    (Uno.no_cia, vcentro, vtipo_doc_anulacion_cxc, TO_CHAR(Uno.FECHA,'YYYY'),
		     vruta, vtransa_id, uno.grupo, uno.no_cliente,
		     uno.fecha, uno.fecha, Uno.Fecha, SYSDATE,
		     0, null, null, monto_al_tipo_moneda,
		     monto_al_tipo_moneda, monto_al_tipo_moneda, -1* (monto_al_tipo_moneda), 0,
		     monto_al_tipo_moneda, 'P', 0, 0,
		     0, NULL, NULL, NULL,
		     'FF', vAno_CxC, vMes_CxC, vSemana_CxC,
		     Uno.no_Comprobante, 0,
		     Uno.Fecha,'N');


  -- Incluye la referencia
  BEGIN
    insert into arccrd
					      (NO_CIA, 
					       TIPO_DOC, PERIODO,RUTA, NO_DOCU,
					       TIPO_REFE, PERI_REFE, RUTA_REFE, NO_REFE,
					       SALDO_ANTERIOR, FECHA_VENCE, PROCEDENCIA,
					       MONTO, DESCUENTO, FECHA)
    values
		      (Uno.no_cia,
		       vtipo_doc_anulacion_cxc, TO_CHAR(uno.fecha,'RRRR'),vruta, vtransa_id,
		       vTipo_doc_comprobante_cxc, vperiodo , vruta, uno.Transa_id,
		       monto_al_tipo_moneda, uno.fecha, NULL,
		       monto_al_tipo_moneda, 0, uno.fecha )  ;

   --Actualiza el documento en CxC
   ccActualiza(pNo_cia, vtipo_doc_anulacion_cxc, vtransa_id, vMensaje_Error);
   If vMensaje_Error is not null Then
     pMensaje := 'Actulizando el documento en Cxc: '||sqlerrm;
   End If;

  exception when others then
    pMensaje := 'Insertando en el maestro de referencias de Cxc: '||sqlerrm;
    Return False;
  END;
  Return TRUE;
exception when others then
  pMensaje := 'Actualizando la cuenta por Cobrar : '||sqlerrm;
  Return FALSE;
END Reversa_CxC; 


---No se utiliza en esta version
Function  Reversa_CxP  Return  Boolean  IS
   vMoneda_Proveedor            	Varchar2(1);
   vTot_CxP 	                number(14,2);
   vAno_cxp 	                ARCPCT.ano_proc%TYPE;
   vMes_cxp 	                ARCPCT.mes_proc%TYPE;
   vFecha_doc 	            	Date:=sysdate;
   vTipo_doc_CxP 		          TAFFMC.tipo_doc_pago_cxp%TYPE;
   vTipo_doc_Anulacion_CxP 	  TAFFMC.tipo_doc_pago_cxp%TYPE;
   vNo_doc_cxp 		            ARCPMD.no_docu%TYPE;
 BEGIN
  -- Inicializa acumuladores.
  vTot_cxp := 0;
  vNo_doc_CxP := Transa_id.ff(Uno.no_cia);
  -- Busca el tipo de doc. de pago utilizado en cxp.
  Begin
    Select Tipo_Doc_Pago_CxP, tipo_doc_anulacion_cxp
      into vTipo_doc_CxP, vTipo_doc_anulacion_cxp
     from TAFFMC
     where no_cia = Uno.no_cia
       and cod_caja = Uno.cod_caja
       and Tipo_Doc_Pago_CxP is not null
       and Tipo_doc_Anulacion_CxP is not null;
  Exception
    when no_data_found Then
      pMensaje := 'Problema para determinar el tipo de documento con el cual se '||
            'registro el pago en CxP. En la caja '||Uno.cod_caja||
            ' en la compa?ia '||Uno.no_cia;
      Return False;
  End;
  --Trae el tipo de moneda y calcula el monto en la moneda del proveedor
  Begin
    select mp.moneda_limite, ano_proc, mes_proc
      into vMoneda_Proveedor, vAno_cxp, vMes_cxp
      from arcpmp mp, arcpct mc
     where mp.no_cia     =   Uno.no_cia
       and mp.no_prove   =   Uno.no_prove
       and mc.no_cia     =   mp.no_cia;
  exception when no_data_found  then
    pMensaje := 'El codigo de proveedor indicado en el comprobante no existe.';
    Return False;
  END;
  -- se calcula el monto a aplicar en la moneda del cliente
  if vMoneda_Proveedor = 'D' then
     vTot_Cxp:=moneda.Redondeo(nvl(Uno.Monto_dol,0) + (nvl(Uno.Monto_nom,0)/vtipo_Cambio),'D');
  else
     vTot_CxP:=Moneda.Redondeo(nvl(Uno.Monto_nom,0)  + (nvl(Uno.Monto_dol,0)*vtipo_Cambio),'P');
  end if;
  -- Valida que la fecha del doc. este en el mes en eproceso.
  If to_number(to_char(vFecha_doc,'rrrrmm')) != vAno_cxp*100+vMes_cxp Then
    vfecha_doc := Last_day(to_date('01'||to_char(vMes_cxp,'00')||to_char(vAno_cxp),'ddmmyyyy'));
  End If;
  -- Incluye una NC en el proveedor por la anulacion del comprobante.
  Loop
    Begin
      Insert into ARCPMD (NO_CIA, NO_PROVE, TIPO_DOC, NO_DOCU,
                          IND_ACT, NO_FISICO, SERIE_FISICO, IND_OTROMOV,
                          FECHA, SUBTOTAL, MONTO, SALDO,
                          EXCENTOS, DESCUENTO, TOT_REFER,  TOT_DB,
                          TOT_CR,  DESC_C, NO_ORDEN, DESC_P,
                          PLAZO_C, PLAZO_P, BLOQUEADO, MOTIVO,
                          MONEDA, TIPO_CAMBIO, TIPO_HIST, MONTO_NOMINAL,
                          SALDO_NOMINAL, NO_CTA, NO_SECUENCIA, T_CAMB_C_V,
                          DETALLE,
                          IND_OTROS_MESES, FECHA_DOCUMENTO,FECHA_VENCE_ORIGINAL,
                          CANT_PRORROGAS, ORIGEN, ANULADO, USUARIO_ANULA)
                 Values(Uno.no_cia, Uno.no_prove, vTipo_doc_Anulacion_CxP, vNo_Doc_CxP,
                        'D', Uno.No_Comprobante, '0', 'N',
                        vFecha_doc, vTot_CxP, vTot_CxP, 0, 0,
                        0, vTot_CxP, 0,0,
                        0,null,0, 0,
                        0,'N', null,
												vMoneda_Proveedor, vtipo_cambio, vTipo_cambio, Decode(vMoneda_proveedor,'D', Moneda.Redondeo(vTot_CxP*vTipo_cambio,'P'), vTot_CxP),
                        0, null, null, 'C',
                        'Anulacion de comprobante caja chica',
                        'N', vFecha_Doc, vFecha_Doc,
                         0, 'FF', 'N', null);
      Exit when TRUE;
    Exception
      When dup_val_on_index Then
        vNo_doc_CxP := Transa_id.ff(Uno.no_cia);
    End;
  End Loop;
  -- Actualiza el saldo del documento.
      Update ARCPMD
         set saldo = saldo + vTot_CxP,
             saldo_nominal = saldo_nominal +
                             Decode(vMoneda_Proveedor,'D',Moneda.Redondeo(vTot_CxP*vTipo_cambio,'D'),vTot_CxP),
             tot_refer = tot_refer + vTot_CxP
       Where no_cia   = Uno.no_cia and
             tipo_doc = vTipo_doc_CxP  and
             no_docu  = Uno.Transa_id;
    -- Incluye la referencia.
    Begin
    Insert into ARCPRD (NO_CIA, NO_PROVE, TIPO_DOC,
                        NO_DOCU, TIPO_REFE, NO_REFE,
                        MONTO, PROCEDENCIA,DIF_CAMBIARIO)
                 values(Uno.no_cia, Uno.no_prove, vTipo_doc_CxP,
                        Uno.Transa_id, vTipo_Doc_Anulacion_CxP, vNo_doc_CxP,
                        vTot_CxP,null, 0);
    Exception
      When Others Then
        pMensaje := 'Error al registrar la referencia en Cxp: '||sqlerrm;
        Return False;
    End;
    -- Actualiza el saldo del proveedor.
    Update ARCPMP
       set creditos = Nvl(Creditos,0) + vTot_CxP
     Where no_cia = Uno.no_cia and
           no_prove = Uno.no_prove;
  Return True;
END Reversa_CxP; 

-- PL/SQL Block

-- PL/SQL Block
BEGIN
  -- Obtiene la informacion del comprobante
  Open Comprobante;
  Fetch Comprobante into Uno;
  If Comprobante%NotFound Then
    Close Comprobante;
    pMensaje := 'El comprobante indicado no existe.';
    Return FALSE;
  End If;
  Close Comprobante;

  -- Obtiene el tipo de cambio correspondiente.
  vTipo_Cambio := Tipo_Cambio(Uno.Clase_Cambio,Uno.Fecha, vFecha_Cambio, 'C');

  -- Reversa la aplicacion contable.
  Anula_Conta;

  -- Identifica que tipo de comprobante es (CxC, Cxp, Normal)
  If Uno.no_prove is not null then
    vComp_Cxp_Nom := Nvl(Uno.Monto_Nom,0);
    vComp_Cxp_Dol := Nvl(Uno.Monto_Dol,0);
    If Not Reversa_Cxp Then
      Return False;
    End If;
  Elsif Uno.no_cliente is not null then
    vComp_Cxc_Nom := Nvl(Uno.Monto_Nom,0);
    vComp_Cxp_Dol := Nvl(Uno.Monto_Dol,0);
    If Not Reversa_Cxc Then
      Return False;
    End If;
  Else
    vComprobante_Nom := Nvl(Uno.Monto_Nom,0);
    vComprobante_Dol := Nvl(Uno.Monto_Dol,0);
  End If;
  -- Marca el comprobante como anulado.
  Update TAFFMM
     set ind_anulado = 'S'
   Where no_cia         = Uno.no_cia
     and transa_id      = Uno.Transa_id;
  Update TAFFMC
     set saldo_nominal       = Nvl(saldo_nominal,0) + Nvl(Uno.monto_nom,0),
         saldo_dolares       = Nvl(saldo_dolares,0) + Nvl(Uno.monto_dol,0),
         comprobante_nominal = Nvl(comprobante_nominal,0) - vComprobante_Nom,
         comprobante_dolares = Nvl(comprobante_dolares,0) - vComprobante_Dol,
         comp_cxc_nominal    = Nvl(comp_cxc_nominal,0) - vComp_Cxc_Nom,
         comp_cxc_dolares    = Nvl(comp_cxc_dolares,0) - vComp_Cxc_Dol,
         comp_cxp_nominal    = Nvl(comp_cxp_nominal,0) - vComp_cxp_Nom,
         comp_cxp_dolares    = Nvl(comp_cxp_dolares,0) - vComp_cxp_Dol
   Where no_cia   = Uno.No_cia
     and cod_caja = Uno.cod_caja;
  Return TRUE;
END;


--create or replace function FF_ANULAR_COMPROBANTE return  is
 /* Result ;
begin
  
  return(Result);
end FF_ANULAR_COMPROBANTE;*/