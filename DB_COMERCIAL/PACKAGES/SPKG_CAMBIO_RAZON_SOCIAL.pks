CREATE OR REPLACE PACKAGE DB_COMERCIAL.SPKG_CAMBIO_RAZON_SOCIAL
AS
/**
    * Documentaci�n para la funci�n P_NOTIFICACION_PENDIENTE_CRS
    * Procedimiento que env�a correo de CRS pendientes.
    *
    * @param  Pv_Usuario - Usuario de creaci�n
    *
    * @author N�stor Naula <nnaulal@telconet.ec>
    * @version 1.0 05-09-2022
    *
    */
    PROCEDURE P_NOTIFICACION_PENDIENTE_CRS(Pv_Usuario IN  VARCHAR2);
    END SPKG_CAMBIO_RAZON_SOCIAL;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.SPKG_CAMBIO_RAZON_SOCIAL
AS
    PROCEDURE P_NOTIFICACION_PENDIENTE_CRS(Pv_Usuario IN  VARCHAR2)
    IS
        Lv_NombreParam      VARCHAR2(4000) := 'ENVIO_CORREO_CRS_CD_PENDIENTE';
        Lv_DescripParam     VARCHAR2(4000) := 'ENVIO DE CORREO PROCESO CRS CD PENDIENTES';
        Lv_Encabezado       VARCHAR2(4000);
        Lv_EstadoPreActivo  VARCHAR2(4000);
        Lv_CuerpoMensaje    CLOB;
        Ln_Contador         NUMBER         := 1;
        Lv_TypeMime         VARCHAR2(4000) := 'text/html; charset=UTF-8';
        Lv_EstiloTabla      VARCHAR2(4000);
        Lv_EstiloEncab      VARCHAR2(4000);
        Lv_EstiloRegis      VARCHAR2(4000);
        Lv_Asunto           VARCHAR2(4000);
        Lv_Remitente        VARCHAR2(4000);
        Lv_Destinatario     VARCHAR2(4000);
        Lv_MensajeNotifica  VARCHAR2(4000);
        
        CURSOR C_GET_NOPROCESADOS_CRS(Cv_Estado VARCHAR2)
        IS
            SELECT ipu.login,to_char(ipu.fe_creacion,'dd-mm-yyyy hh24:mi:ss') as fe_creacion,ipu.usr_creacion
            FROM
            (   SELECT ipu.id_punto
                FROM db_comercial.info_servicio ise
                INNER JOIN db_comercial.info_punto ipu on ise.punto_id=ipu.id_punto
                WHERE ise.estado = Cv_Estado
                GROUP BY ipu.id_punto) T1
            INNER JOIN db_comercial.info_punto ipu on ipu.id_punto=T1.id_punto;
            
        CURSOR C_GET_PARAMETROS(Cv_NombreParametro VARCHAR2,Cv_DescripcionParametro VARCHAR2)
        IS
          SELECT   APD.VALOR1  AS REMITENTE,
                   APD.VALOR2  AS DESTINATARIO,
                   APD.VALOR3  AS ASUNTO,
                   APD.VALOR4  AS MENSAJE,
                   APD.VALOR5  AS ESTILO1,
                   APD.VALOR6  AS ESTILO2,
                   APD.VALOR7  AS ESTILO3,
                   OBSERVACION AS ESTADO
          FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
          WHERE APD.parametro_id =
            (SELECT APC.id_parametro
            FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
            WHERE APC.nombre_parametro = Cv_NombreParametro
            )
        AND APD.descripcion = Cv_DescripcionParametro;
        
    BEGIN
    
        OPEN C_GET_PARAMETROS(Lv_NombreParam,Lv_DescripParam);
        FETCH C_GET_PARAMETROS into Lv_Remitente,
                                    Lv_Destinatario,
                                    Lv_Asunto,
                                    Lv_MensajeNotifica,
                                    Lv_EstiloRegis,
                                    Lv_EstiloEncab,
                                    Lv_EstiloTabla,
                                    Lv_EstadoPreActivo;
        CLOSE C_GET_PARAMETROS;
        FOR i IN C_GET_NOPROCESADOS_CRS(Lv_EstadoPreActivo)
        LOOP   
             Lv_CuerpoMensaje := Lv_CuerpoMensaje || 
                             '<tr>
                                <td style="'||Lv_EstiloRegis||'">'|| Ln_Contador ||'</td>
                                <td style="'||Lv_EstiloRegis||'">'|| i.login ||'</td>
                                <td style="'||Lv_EstiloRegis||'">'|| i.fe_creacion ||'</td>
                                <td style="'||Lv_EstiloRegis||'">'|| i.usr_creacion ||'</td>
                                <td style="'||Lv_EstiloRegis||'">'|| Lv_EstadoPreActivo ||'</td>
                              </tr>';
             Ln_Contador := Ln_Contador +1;
        END LOOP;
        
        Lv_Encabezado := '<table style="'|| Lv_EstiloTabla ||'">
                          <tr>
                            <th style="'||Lv_EstiloEncab||'">#</th>
                            <th style="'||Lv_EstiloEncab||'">Login</th>
                            <th style="'||Lv_EstiloEncab||'">Fecha</th>
                            <th style="'||Lv_EstiloEncab||'">Usuario</th>
                            <th style="'||Lv_EstiloEncab||'">Estado</th>
                          </tr>';
                          
        Lv_CuerpoMensaje := Lv_MensajeNotifica ||
                            Lv_Encabezado || 
                            Lv_CuerpoMensaje || 
                            '</table>';
    
        UTL_MAIL.SEND ( sender     =>  Lv_Remitente, 
                        recipients =>  Lv_Destinatario,
                        subject    =>  Lv_Asunto, 
                        MESSAGE    =>  Lv_CuerpoMensaje, 
                        mime_type  =>  Lv_TypeMime );
    EXCEPTION 
    WHEN OTHERS THEN  
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CRS',
                                            'DB_COMERCIAL.SPKG_CAMBIO_RAZON_SOCIAL.P_NOTIFICACION_PENDIENTE_CRS',
                                            SQLCODE || ' - ERROR_STACK:'||
                                            DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||           
                                            DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            Pv_Usuario,
                                            SYSDATE,
                                            '127.0.0.1'); 
                    
    END P_NOTIFICACION_PENDIENTE_CRS;
END SPKG_CAMBIO_RAZON_SOCIAL;
/
