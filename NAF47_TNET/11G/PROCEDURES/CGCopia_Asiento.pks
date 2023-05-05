create or replace PROCEDURE            CGCopia_Asiento (
  pCia        in arcgae.no_Cia%type,
  pAsiento    in arcgae.No_Asiento%type,
  pmsg_error  in out varchar2
) IS
/**
* Documentacion para procedure CGCopia_Asiento 
* Procedimiento realiza copia de asiento contable para anulación o reverso de mayorización.
* @author yoveri <yoveri@yoveri.com>
* @version 1.0 01/01/2007
*
* @author llindao <llindao@telconet.ec>
* @version 1.1 31/08/2020 -  Se modifica para considerar nuevo campo que asocia la distribución de costo con el asiento contable.
*
* @param pCia       IN     arcgae.no_Cia%type     Recibe Identificación de compañía
* @param pAsiento   IN     arcgae.No_Asiento%type Recibe Identificación de asiento contable
* @param pmsg_error IN OUT VARCHAR2               Retorna mensaje de error 
*/

  vno_asiento     arcgae.no_asiento%type;

BEGIN
   --
   vno_asiento := TRANSA_ID.CG(pCia);
   --
   INSERT into ARCGAE (no_cia,           ano,            mes,
                       no_asiento,       impreso,        fecha,
                       descri1,          estado,         autorizado,
                       origen,           t_debitos,      t_creditos,
                       cod_diario,       t_camb_c_v,     tipo_cambio,
                       tipo_comprobante, no_comprobante, anulado)
         SELECT no_cia,           ano,            mes,
                vno_asiento,      'N',            fecha,
                descri1,          'P',            'N',
                origen,           t_debitos,      t_creditos,
                cod_diario,       t_camb_c_v,     tipo_cambio,
                tipo_comprobante, 0,              'N'
           FROM arcgae
          WHERE no_cia     = pCia
            AND no_asiento = pAsiento;
   --
   -- crea lineas del nuevo asiento
   INSERT into ARCGAL(no_cia,     ano,       mes,           no_asiento,
                      no_linea,   descri,    cuenta,        no_docu,
                      cod_diario, moneda,    tipo_cambio,   fecha,
                      monto,      cc_1,      cc_2,          cc_3,
                      tipo,       monto_dol, codigo_tercero, No_Distribucion)
             SELECT no_cia,     ano,       mes,            vno_asiento,
                    no_linea,   descri,    cuenta,         no_docu,
                    cod_diario, moneda,    tipo_cambio,    fecha,
                    monto,      cc_1,      cc_2,           cc_3,
                    tipo,       monto_dol, codigo_tercero, No_Distribucion
               FROM arcgal
              WHERE no_cia                 = pCia
                AND no_asiento             = pAsiento
                AND linea_ajuste_precision = 'N';
    --
    -- Si existe detalle distribucion de costos tambien debe replicarse
    --
    INSERT INTO NAF47_TNET.PR_DOCUMENTO_DISTRIBUCION
      ( ID_DOC_DISTRIBUCION,
        NO_CIA,
        NO_DOCU,
        TIPO_CCOSTO_ID,
        TIPO_CCOSTO_DESCRIPCION,
        REFERENCIA_ID,
        REFERENCIA_DESCRIPCION,
        ORIGEN,
        ESTADO,
        USR_CREACION,
        FE_CREACION,
        REFERENCIA_PADRE_ID,
        DETALLE_DISTRIBUCION_ID )
    SELECT NAF47_TNET.SEQ_PR_DOCUMENTO_DISTRIBUCION.NEXTVAL,
           NO_CIA,
           vno_asiento,
           TIPO_CCOSTO_ID,
           TIPO_CCOSTO_DESCRIPCION,
           REFERENCIA_ID,
           REFERENCIA_DESCRIPCION,
           ORIGEN,
           ESTADO,
           USER,
           SYSDATE,
           REFERENCIA_PADRE_ID,
           DETALLE_DISTRIBUCION_ID
    FROM NAF47_TNET.PR_DOCUMENTO_DISTRIBUCION PCD
    WHERE PCD.NO_DOCU = pAsiento
    AND PCD.NO_CIA = pCia;
    --
EXCEPTION
  WHEN transa_id.error THEN
     pmsg_error := nvl(transa_id.ultimo_error,'Copia_asiento: Error por transa_id');
  WHEN others THEN
     pmsg_error := nvl(sqlerrm,'copia_asiento: Error desconocido');
END;