CREATE OR REPLACE FUNCTION NAF47_TNET.FFGENERA_CONTA( pNo_cia   in varchar2,
                                           pCod_Caja in varchar2,
                                           pFecha    in date,
                                           pMensaje  in out varchar2 ) Return Boolean IS
/**
* Documentacion para NAF47_TNET.FFGENERA_CONTA
* Funcion que envia la distribucion contable de los documentos Caja Chica a Contabilidad
* @author yoveri <yoveri@yoveri.com>
* @version 1.0 01/01/2007
* @author Luis Lindao Rodriguez <llindao@telconet.ec>
* @version 1.1 21/11/2016 - Se modifica para validar que si existen documentos sin distribucion contable no se permita generar asiento contable.
*
* @Param  pNo_cia   IN VARCHAR      Recibe codigo de compania
* @Param  pCod_Caja IN VARCHAR2     Recibe codigo de Caja Chica
* @Param  pFecha    IN DATE         Recibe fecha de generacion de asiento
* @Param  pMensaje  IN OUT VARCHAR2 Devuelve mensajes de errores
* @return BOOLEAN Retorna si el proceso fue satisfactorio o no.
*/ 
  -- tipo de asiento que se debe generar
  CURSOR c_ind_tipo_asientos IS
    SELECT ind_tipo_asientos
      FROM taffpc
     WHERE no_cia = pNo_cia;

  CURSOR c_meses IS
    SELECT distinct ano_proce ano, mes_proce mes
      FROM taffdc dc, taffmm mm
     WHERE mm.no_cia    = pNo_cia
       AND mm.cod_caja  = pCod_caja
       AND mm.no_cia    = dc.no_cia
       AND mm.transa_id = dc.transa_id
       AND dc.no_asiento IS NULL;

 --Genera un asiento contable resumido
 CURSOR c_cuentas (pAno number, pMes number) IS
    SELECT cta_contable, naturaleza tipo_mov,
           decode(moneda,'D','D','P') moneda,
           nvl(dc.tipo_cambio,1) tipo_cambio,
           NVL(dc.centro_costo,'000000000') centro_costo,
           nvl(sum(dc.monto),0) monto,
           decode(naturaleza,'C',-1,1) signo
      FROM taffmm mm, taffdc dc
     WHERE mm.no_cia    = pno_cia
       AND mm.cod_caja  = pcod_caja
       AND mm.ano_proce = pAno
       AND mm.mes_proce = pMes
       AND dc.estado    = 'A'
       AND dc.no_asiento IS NULL
       AND dc.no_cia    = mm.no_cia
       AND dc.transa_id = mm.transa_id
    GROUP BY cta_contable, naturaleza, dc.centro_costo,
             moneda, dc.tipo_cambio;

 --Genera un asiento contable detallado
 CURSOR c_cuentas_det (pAno number, pMes number) IS
    SELECT cta_contable, naturaleza tipo_mov,
           decode(moneda,'D','D','P') moneda,
           nvl(dc.tipo_cambio,1) tipo_cambio,
           dc.centro_costo,
           dc.monto,
           decode(naturaleza,'C',-1,1) signo,
           dc.glosa descri
      FROM taffmm mm, taffdc dc
     WHERE mm.no_cia    = pno_cia
       AND mm.cod_caja  = pcod_caja
       AND mm.ano_proce = pAno
       AND mm.mes_proce = pMes
       AND dc.estado    = 'A'
       AND dc.no_asiento IS NULL
       AND dc.no_cia    = mm.no_cia
       AND dc.transa_id = mm.transa_id
    ORDER BY cta_contable, naturaleza, dc.centro_costo,
             moneda, dc.tipo_cambio;

  -- Selecciona la informacion necesaria en la caja y la compania.
  CURSOR c_info_general IS
    SELECT mc.cod_diario, mc.clase_cambio,
           mc.ano_proce ano, mc.mes_proce no_mes,
           m.nom_mes mes, mc.nombre_responsable,
           conta.ano_proce ano_conta,
           conta.mes_proce mes_conta,
           descripcion desc_caja
      FROM taffmc mc, meses m, arcgmc conta
     WHERE mc.no_cia    = pNo_cia
       AND mc.cod_caja  = pCod_caja
       AND conta.no_cia = mc.no_cia
       AND m.no_mes     = mc.mes_proce;

  --
  -- recupera numero de comprobantes sin distribucion contable.
  CURSOR C_COMP_SIN_DIST_CONTABLE IS
    SELECT COUNT(A.TRANSA_ID) CANTIDAD
      FROM TAFFMM A,
           TAFFMC B
      WHERE A.COD_CAJA = B.COD_CAJA
        AND A.NO_CIA = B.NO_CIA
        AND A.MES_PROCE = B.MES_PROCE
        AND A.ANO_PROCE = B.ANO_PROCE
        AND A.COD_CAJA = pCod_caja
        AND A.NO_CIA = pNo_cia
        AND A.TIPO_MOV = 'CO'
        AND NOT EXISTS (SELECT NULL
                          FROM TAFFDC C
                         WHERE C.TRANSA_ID = A.TRANSA_ID
                           AND C.NO_CIA = A.NO_CIA);
  --
  vNo_linea                 arcgal.no_linea%type;
  vTotal_db                 arcgae.t_debitos%type:=0;
  vTotal_cr                 arcgae.t_creditos%type:=0;
  vMonto_nominal            arcgal.monto%type;
  vFecha_cambio             date;
  vAsiento                  arcgae.no_asiento%type;
  vTipo_cambio              arcgal.tipo_cambio%type;
  Reg_info                  c_info_general%rowtype;
  vAutorizado               arcgae.autorizado%type;
  vAsiento_meses_anteriores varchar2(2):= 'P';
  vFound                    boolean;
  vTipo_asientos            taffpc.ind_tipo_asientos%type;
  vDescripcion              arcgae.descri1%type;
  vMensaje_pend             varchar2(512);
  -- Variables
  Ln_SinDistContable        NUMBER(3) := 0;
  --

FUNCTION Hay_Pendientes (pNo_cia in varchar2, pCod_Caja in varchar2,
                         pError out varchar2)
RETURN Boolean IS

  CURSOR c_pendientes IS
      SELECT dc.transa_id
        FROM taffdc dc, taffmm mm
       WHERE mm.no_cia    = pno_cia
         AND mm.cod_caja  = pcod_caja
         AND dc.no_cia    = mm.no_cia
         AND dc.transa_id = mm.transa_id
         AND dc.no_asiento is null
         AND rownum < 2;

    vComprobante  taffdc.transa_id%type:=Null;
    vEncontro     boolean;

BEGIN
  OPEN  c_pendientes;
  FETCH c_pendientes INTO vComprobante;
  vEncontro := c_pendientes%found;
  CLOSE c_pendientes;
  IF vEncontro THEN
     Return TRUE;
  ELSE
    pError :='No existen documentos pendientes de enviar a Contabilidad';
    Return FALSE;
  END IF;
END Hay_Pendientes;


BEGIN --principal

  moneda.inicializa(pNo_cia);
  
  -- Se valida comprobantes sin distribucion contable
  IF C_COMP_SIN_DIST_CONTABLE%ISOPEN THEN
    CLOSE C_COMP_SIN_DIST_CONTABLE;
  END IF;
  OPEN C_COMP_SIN_DIST_CONTABLE;
  FETCH C_COMP_SIN_DIST_CONTABLE INTO Ln_SinDistContable;
  IF C_COMP_SIN_DIST_CONTABLE%NOTFOUND THEN
    Ln_SinDistContable := 0;
  END IF;
  CLOSE C_COMP_SIN_DIST_CONTABLE;
  --
  IF Ln_SinDistContable > 0 THEN
    pMensaje := 'Existen '||to_char(Ln_SinDistContable)||' documento(s) sin distribucion contable, favor corregir!!!';
    RETURN FALSE;
  END IF;
  
  -- Valida si existen doc. pendientes de registrar contablemente
  IF NOT Hay_Pendientes(pNo_cia, pCod_Caja, vMensaje_pend) THEN
      pMensaje := vMensaje_pend;
    RETURN FALSE;
  END IF;


  -- Obtiene informacion general
  OPEN  c_info_general;
  FETCH c_info_general INTO Reg_info;
  vFound := c_info_general%found;
  CLOSE c_info_general;
  IF NOT vFound THEN
    pMensaje := 'No se pudo obtener la informacion general necesaria para la Generacion del Asiento';
    RETURN FALSE;
  END IF;

  OPEN  c_ind_tipo_asientos;
  FETCH c_ind_tipo_asientos INTO  vTipo_asientos;
  CLOSE c_ind_tipo_asientos;
  IF nvl(vTipo_asientos,'X') = 'R' THEN
      vDescripcion := 'ASIENTO RESUMIDO DEL MODULO DE FONDO FIJO. CAJA '||Reg_info.desc_caja;
  ELSE
      vDescripcion := 'ASIENTO DETALLADO DEL MODULO DE FONDO FIJO. CAJA '||Reg_info.desc_caja;
  END IF;

  -- Obtiene el tipo de cambio del dia
  vTipo_cambio := Tipo_cambio (Reg_info.Clase_cambio, pFecha, vFecha_cambio, 'C');

  -- Determina si el asiento se debe generar en meses anteriores
  IF Reg_info.ano_conta*100+Reg_info.mes_conta > Reg_info.ano*100+Reg_info.no_mes THEN
    vAsiento_meses_anteriores := 'O';
    vAutorizado               := 'S';
  ELSE
    vAsiento_meses_anteriores := 'P';
    vAutorizado               := 'N';
  END IF;


  FOR Periodo IN c_meses LOOP
    vTotal_db := 0;
    vTotal_cr := 0;
    -- Obtiene el consecutivo del asiento
    vAsiento := transa_id.cg(pNo_cia);

    -- Inserta el encabezado del asiento
    INSERT INTO arcgae (no_cia, ano, mes, no_asiento,
                        impreso, fecha, descri1,
                        estado, autorizado, origen,
                        t_debitos ,t_creditos,cod_diario,
                        t_camb_c_v, tipo_comprobante, no_comprobante, anulado,
                                                USUARIO_CREACION, FECHA_INGRESA)
                                VALUES (pNo_cia, Reg_info.ano, Reg_info.no_mes, vAsiento,
                                                'N', pFecha, substr(vDescripcion,1,230),
                                                vAsiento_meses_anteriores,'N', 'FF',
                                                0, 0, Reg_info.cod_diario,
                                                'V', 'E', 0, 'N',
                                                USER, SYSDATE);

    -- Inserta las lineas del asiento
    vNo_linea := 1;

    IF nvl(vTipo_asientos,'X') = 'R' THEN --Asiento resumido (R)

         FOR cta IN c_cuentas (Periodo.ano, Periodo.mes) LOOP

          IF cta.moneda = 'D' THEN
            vMonto_nominal := moneda.redondeo(cta.monto * cta.tipo_cambio,'P');
          ELSE
            vMonto_nominal := moneda.redondeo(cta.monto,'D');
          END IF;

           INSERT INTO arcgal( no_cia, ano, mes, no_asiento,
                               no_linea, descri,
                               cuenta, no_docu, cod_diario,
                               moneda, tipo_cambio, fecha,
                               monto, centro_costo, tipo,
                               monto_dol)
                      VALUES ( pNo_cia, Reg_info.ano, Reg_info.no_mes, vAsiento,
                               vNo_linea,  'GENERADO POR MOD. DE FF',
                               cta.cta_contable, vAsiento, Reg_info.cod_diario,
                               cta.moneda, cta.tipo_cambio,pFecha,
                               cta.signo*vMonto_nominal, cta.centro_costo, cta.tipo_mov,
                               decode(cta.moneda,'D',moneda.redondeo(cta.monto*cta.signo,'D'),
                                   moneda.redondeo(cta.signo*(cta.monto/cta.tipo_cambio),'D')));
          vNo_linea := vNo_linea+1;

          IF cta.tipo_mov = 'D' THEN
            vTotal_db := vTotal_db + nvl(vMonto_nominal,0);
          ELSE
            vTotal_cr := vTotal_cr + nvl(vMonto_nominal,0);
          END IF;

         END LOOP; -- For c_cuentas (asiento resumido)

   ELSE  --Asiento detallado  (D)

        FOR cta IN c_cuentas_det (Periodo.ano, Periodo.mes) LOOP

              IF cta.moneda = 'D' THEN
                vMonto_nominal := moneda.redondeo(cta.monto * cta.tipo_cambio,'P');
              ELSE
                vMonto_nominal := moneda.redondeo(cta.monto,'D');
              END IF;

               INSERT INTO arcgal( no_cia, ano, mes, no_asiento,
                                   no_linea, descri,
                                   cuenta, no_docu, cod_diario,
                                   moneda, tipo_cambio, fecha,
                                   monto, centro_costo, tipo,
                                   monto_dol)
                          VALUES ( pNo_cia, Reg_info.ano, Reg_info.no_mes, vAsiento,
                                   vNo_linea, substr(cta.descri,1,50),
                                   cta.cta_contable, vAsiento, Reg_info.cod_diario,
                                   cta.moneda, cta.tipo_cambio,pFecha,
                                   cta.signo*vMonto_nominal, cta.centro_costo, cta.tipo_mov,
                                   decode(cta.moneda,'D',moneda.redondeo(cta.monto*cta.signo,'D'),
                                       moneda.redondeo(cta.signo*(cta.monto/cta.tipo_cambio),'D')));
              vNo_linea := vNo_linea+1;

              IF cta.tipo_mov = 'D' THEN
                vTotal_db := vTotal_db + nvl(vMonto_nominal,0);
              ELSE
                vTotal_cr := vTotal_cr + nvl(vMonto_nominal,0);
              END IF;

          END LOOP; -- For c_cuentas_det (asiento detallado)

      END IF; --vTipo_asiento (R/D)

      -- Actualiza el no. de asiento y el ano y mes contable de los documentos
      UPDATE taffdc dc
         SET no_asiento = vAsiento,
             mes_conta  = Reg_info.no_mes,
             ano_conta  = Reg_info.ano
       WHERE no_cia   = pNo_cia
         AND no_asiento IS NULL
         AND estado = 'A'
         AND transa_id IN (SELECT transa_id
                             FROM taffmm mm
                            WHERE mm.no_cia    = pNo_cia
                              AND mm.cod_caja  = pCod_caja
                              AND mm.transa_id = dc.transa_id
                              AND mm.ano_proce = periodo.ano
                              AND mm.mes_proce = periodo.mes);

    -- Actualiza el total de debitos y creditos en el encabezado del asiento
    IF vTotal_db = 0 THEN

      DELETE arcgae
       WHERE no_cia     = pNo_cia
         AND ano        = Reg_info.ano
         AND mes        = Reg_info.no_mes
         AND no_asiento = vAsiento;
    ELSE
      UPDATE arcgae
         SET t_debitos  = vTotal_db,
             t_creditos = vTotal_cr,
             autorizado = vAutorizado
       WHERE no_cia     = pNo_cia
         AND ano        = Reg_info.ano
         AND mes        = Reg_info.no_mes
         AND no_asiento = vAsiento;
    END IF;
 END LOOP;

  RETURN TRUE;

EXCEPTION
  WHEN transa_id.error THEN
    pMensaje:='Error generando asiento: '||transa_id.ultimo_error;
    RETURN FALSE;

  WHEN Others THEN
    pMensaje:='FFGENERA_CONTA: '||sqlerrm;
    RETURN FALSE;
END;
/