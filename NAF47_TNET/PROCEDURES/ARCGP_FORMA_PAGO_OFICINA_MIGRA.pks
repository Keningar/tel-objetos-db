create or replace procedure            ARCGP_FORMA_PAGO_OFICINA_MIGRA (Pd_FechaInicio  IN DATE,
                                                            Pv_NoCia        IN VARCHAR2,
                                                            Pv_MensajeError IN OUT VARCHAR2 ) is
/**
* Documentacion para NAF47_TNET.ARCGP_FORMA_PAGO_OFICINA_MIGRA
* Procedimiento que asigna los codigos de formas de pagos y oficinas a los registros que se encuentran
* migrados en las estructuras de NAF, proceso que se ejecutara hasta que TELCOS lo incluya en su proceso
*
* @author llindao <llindao@telconet.ec>
* @version 1.0 10/02/2016
*/
  -- cursor recupera formato de documentos masivos de telcos que se encuentra configurado en parametros
  CURSOR C_TRANSACCIONES_MASIVAS IS
    SELECT A.PARAMETRO ID_FORMA_PAGO, A.DESCRIPCION FORMATO
      FROM NAF47_TNET.GE_PARAMETROS A
     WHERE A.ID_GRUPO_PARAMETRO = 'TRX_MASIVAS_TELCOS'
       AND A.ID_APLICACION = 'CG'
       AND A.ID_EMPRESA = Pv_NoCia
       AND A.ESTADO = 'A';
  -- cursor que recupera las oficinas registradas en TELCOS
  CURSOR C_OFICINA IS
    SELECT A.ID_OFICINA CODIGO, 
           UPPER(A.NOMBRE_OFICINA) DESCRIPCION
      FROM DB_COMERCIAL.INFO_OFICINA_GRUPO A
     WHERE A.EMPRESA_ID = Pv_NoCia
       AND A.ESTADO = 'Activo'
       AND A.REF_OFICINA_ID IS NULL;
  -- cursor que recupera las formas de pagos registradas en TELCOS
  CURSOR C_FORMA_PAGO IS   
    SELECT ID_FORMA_PAGO CODIGO,
           DESCRIPCION_FORMA_PAGO DESCRIPCION
      FROM DB_GENERAL.ADMI_FORMA_PAGO
     ORDER BY LENGTH(DESCRIPCION_FORMA_PAGO) DESC;
  --
  
begin
  
  
  -- Se recupera configuracion y formato de documentos masivos para asignarlos
  FOR Li_Trx IN C_TRANSACCIONES_MASIVAS LOOP
    -- se asigna codigo segun lo configurado en parametros en migracion de bancos
    UPDATE NAF47_TNET.MIGRA_ARCKMM A
    SET A.ID_FORMA_PAGO = (SELECT ID_FORMA_PAGO 
                           FROM DB_GENERAL.ADMI_FORMA_PAGO 
                           WHERE DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO =  Li_Trx.Id_Forma_Pago)
    WHERE NO_CIA = Pv_NoCia
    AND TRUNC(FECHA_DOC) >= Pd_FechaInicio
    AND UPPER(COMENTARIO) like Li_Trx.Formato
    AND A.ID_FORMA_PAGO IS NULL;
    -- se asigna codigo segun lo configurado en parametros en migracion de contabilidad
    UPDATE NAF47_TNET.MIGRA_ARCGAE A
    SET A.ID_FORMA_PAGO = (SELECT ID_FORMA_PAGO 
                           FROM DB_GENERAL.ADMI_FORMA_PAGO 
                           WHERE DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO =  Li_Trx.Id_Forma_Pago)
    WHERE NO_CIA = Pv_NoCia
    AND TRUNC(FECHA) >= Pd_FechaInicio
    AND upper(DESCRI1) like Li_Trx.Formato
    AND A.ID_FORMA_PAGO IS NULL;
  END LOOP;
  
  -- Se recupera codigos de oficina y descripcion 
  FOR oficina IN C_OFICINA LOOP
    -- asigna codigo de oficinas a registros migracion bancos que en comentario encuentra nombre de oficina
    UPDATE NAF47_TNET.MIGRA_ARCKMM A
    SET A.ID_OFICINA_FACTURACION = oficina.CODIGO
    WHERE NO_CIA = Pv_NoCia
    AND TRUNC(FECHA_DOC) >= Pd_FechaInicio
    AND INSTR(upper(COMENTARIO), oficina.DESCRIPCION) > 0
    AND A.ID_OFICINA_FACTURACION IS NULL;
       
    -- asigna codigo de forma pago a registros migracion contabilidad que en comentario encuentra nombre de oficina
    UPDATE NAF47_TNET.MIGRA_ARCGAE A
    SET A.ID_OFICINA_FACTURACION = oficina.CODIGO
    WHERE NO_CIA = Pv_NoCia
    AND TRUNC(FECHA) >= Pd_FechaInicio
    AND INSTR(upper(DESCRI1), oficina.DESCRIPCION) > 0
    AND A.ID_OFICINA_FACTURACION IS NULL;
    --
    DBMS_OUTPUT.PUT_LINE ('Actualizando NAF47_TNET.MIGRA_ARCGAE. '||oficina.DESCRIPCION||'. '||SQL%ROWCOUNT);
    --
  END LOOP;
  
  -- Se recupera codigos de formas de pago de Telcos
  FOR formaPago IN C_FORMA_PAGO LOOP
    -- asigna codigo forma Pago a registros migracion bancos que en comentario encuentra descripcion forma pago
    UPDATE NAF47_TNET.MIGRA_ARCKMM A
    SET A.ID_FORMA_PAGO = formaPago.CODIGO
    WHERE NO_CIA = Pv_NoCia
    AND FECHA >= Pd_FechaInicio
    AND INSTR(upper(COMENTARIO), formaPago.DESCRIPCION) > 0
    AND A.ID_FORMA_PAGO IS NULL;
       
    -- asigna codigo forma Pago a registros migracion contabilidad que en comentario encuentra descripcion forma pago
    UPDATE NAF47_TNET.MIGRA_ARCGAE A
    SET A.ID_FORMA_PAGO = formaPago.CODIGO
    WHERE NO_CIA = Pv_NoCia
    AND FECHA >= Pd_FechaInicio
    AND INSTR(upper(DESCRI1), formaPago.DESCRIPCION) > 0
    AND A.ID_FORMA_PAGO IS NULL;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    Pv_MensajeError := 'Error en ARCGP_FORMA_PAGO_OFICINA_MIGRA. '||SQLERRM;
    ROLLBACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'MIGRACION TELCOS-NAF',
                                          'NAF47_TNET.ARCGP_FORMA_PAGO_OFICINA_MIGRA',
                                          SQLERRM,
                                          USER,
                                          SYSDATE, 
                                          NAF47_TNET.GEK_CONSULTA.F_RECUPERA_IP);
    COMMIT;
end ARCGP_FORMA_PAGO_OFICINA_MIGRA;