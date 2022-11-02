  
 CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_CRS_TRANSACCION AS
  /**
    * Documentación para P_REVERSAR_CRS
    * se creo un reverso de la siguiente funcion 
    * ruta :src/telconet/comercialBundle/Controller/ClienteController.php 
    * funcion base :cambiarRazonSocialAction
    * Procedimiento para reversar el cambio de razon social
    *
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    * @author Jefferson Carrillo <jacarrillo@telconet.ec>
    * @version 1.0 27/09/2021

    * @author Jefferson Carrillo <jacarrillo@telconet.ec>
    * @version 1.2 28-01-2022 - Se modifico cursor, se elimino filtrado de estados en updates de  puntos y servicios, se agrego historial de empresa rol a cliente destino 
    * @since 1.0
    */
    PROCEDURE P_REVERSAR_CRS(Pcl_Request IN CLOB,Pv_Mensaje OUT VARCHAR2,Pv_Status OUT VARCHAR2,Pcl_Response  OUT SYS_REFCURSOR);

END CMKG_CRS_TRANSACCION;

/
 
create or replace PACKAGE BODY  DB_COMERCIAL.CMKG_CRS_TRANSACCION AS

    PROCEDURE   P_REVERSAR_CRS(Pcl_Request IN CLOB,Pv_Mensaje OUT VARCHAR2,Pv_Status OUT VARCHAR2,Pcl_Response OUT SYS_REFCURSOR)AS 
       Lv_CodEmpresa VARCHAR2(100);
       Ln_IdEmpresa  NUMBER;
       Ln_OficinaId  NUMBER;      
       Lv_PrefijoEmpresa VARCHAR2(100);
       Lv_UsrCreacion VARCHAR2(100);
       Lv_ClientIp VARCHAR2(100);

       Lv_DataTemp VARCHAR2(100);
       Lv_EstadoActivo VARCHAR2(100);
       Lv_EstadoEliminado VARCHAR2(100);
       Lv_EstadoCancelado VARCHAR2(100);
       Lv_EstadoInactivo VARCHAR2(100);
       Lv_EstadoPendiente  VARCHAR2(100); 

       Ln_IdPersonaEmpresaRolDestino  NUMBER;  
       Lv_YaExiste      VARCHAR2(100); 
       Lv_MotivoReverso VARCHAR2(3000); 



      CURSOR C_GetPersonaEmpRol( Cn_IdPersonaEmpRol NUMERIC,   Cv_CodigoEmpresa VARCHAR2) IS       
        SELECT  * FROM (
        SELECT 
        ip.IDENTIFICACION_CLIENTE,
        ip.ID_PERSONA,     
        iper.ID_PERSONA_ROL,
        ier.ID_EMPRESA_ROL,
        ip.TIPO_TRIBUTARIO, 
        iper.PERSONA_EMPRESA_ROL_ID AS ID_PERSONA_ROL_ORIGEN,         
        NULL ID_CONTRATO , 
        NULL REPRESENTANTE_EMPRESA_ROL_ID
        FROM 
        DB_COMERCIAL.INFO_PERSONA ip ,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL  iper,
        DB_COMERCIAL.INFO_EMPRESA_ROL  ier,
        DB_GENERAL.ADMI_ROL ar,
        DB_GENERAL.ADMI_TIPO_ROL atr 
        WHERE iper.PERSONA_ID            = ip.ID_PERSONA 
        AND   iper.EMPRESA_ROL_ID        = ier.ID_EMPRESA_ROL 
        AND   ier.ROL_ID                 = ar.ID_ROL 
        AND   ar.TIPO_ROL_ID             = atr.ID_TIPO_ROL  
        AND   atr.DESCRIPCION_TIPO_ROL   = 'Cliente' 
        AND   ier.EMPRESA_COD            = Cv_CodigoEmpresa   
        AND   iper.ID_PERSONA_ROL        = Cn_IdPersonaEmpRol
        ORDER BY   iper.ID_PERSONA_ROL DESC )   
        WHERE ROWNUM =1;   

     CURSOR C_GetVerificarCRS(Cn_IdPersonaEmpRol NUMERIC,   Cv_CodigoEmpresa VARCHAR2) IS
        SELECT 
        iper.ID_PERSONA_ROL 
        FROM 
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper,
        DB_COMERCIAL.INFO_EMPRESA_ROL  ier
        WHERE  iper.PERSONA_EMPRESA_ROL_ID  IS NOT NULL  
        AND    iper.EMPRESA_ROL_ID = ier.ID_EMPRESA_ROL 
        AND    ier.EMPRESA_COD     = Cv_CodigoEmpresa   
        AND    iper.ID_PERSONA_ROL = Cn_IdPersonaEmpRol
        AND    iper.ESTADO         = 'Activo';  

     CURSOR C_GetPersonaContacto(Cn_IdPersonaEmpRol NUMERIC) IS
        SELECT ipc.* FROM DB_COMERCIAL.INFO_PERSONA_CONTACTO ipc 
        WHERE ipc.PERSONA_EMPRESA_ROL_ID =  Cn_IdPersonaEmpRol 
        AND   ipc. ESTADO= 'Activo';

     CURSOR C_GetPunto(Cn_IdPersonaDestino NUMBER) IS
        SELECT  ip.* FROM DB_COMERCIAL.INFO_PUNTO ip 
            WHERE ip.PERSONA_EMPRESA_ROL_ID IN (SELECT IPER.ID_PERSONA_ROL FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
                WHERE IPER.PERSONA_ID = Cn_IdPersonaDestino) 
            AND ip.ESTADO != 'Eliminado' ;

    CURSOR C_GetPuntoComparar(Cn_IdPersonaRol NUMBER, Cn_PuntoCoberturaId NUMBER, Cn_TipoNegocio NUMBER, Cn_TipoUbicacion  NUMBER, Cn_SectorId  NUMBER, Cv_Direccion VARCHAR2,  Cv_Latitud VARCHAR2, Cv_Longitud VARCHAR2) IS
        SELECT  ip.* FROM DB_COMERCIAL.INFO_PUNTO ip 
        WHERE ip.PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaRol
         AND  ip.PUNTO_COBERTURA_ID = Cn_PuntoCoberturaId
         AND  ip.TIPO_NEGOCIO_ID = Cn_TipoNegocio
         AND  ip.TIPO_UBICACION_ID = Cn_TipoUbicacion
         AND  ip.SECTOR_ID = Cn_SectorId
         AND  ip.DIRECCION = Cv_Direccion; 

     CURSOR C_GetServicio(Cn_IdPunto VARCHAR2) IS
       SELECT  is2.* FROM DB_COMERCIAL.INFO_SERVICIO is2 
       WHERE is2.PUNTO_ID = Cn_IdPunto;  

    CURSOR C_GetServicioComparar(Cv_IdServicioOrigen VARCHAR2) IS
       SELECT  is2.* FROM DB_COMERCIAL.INFO_SERVICIO is2 
       WHERE is2.ID_SERVICIO like Cv_IdServicioOrigen;  

    CURSOR C_GetServicioCaracteristica(Cn_IdServicio NUMBER) IS
       SELECT isc .* FROM DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA isc 
       WHERE isc.SERVICIO_ID = Cn_IdServicio
       AND isc.ESTADO   IN (  'Activo' );

     CURSOR C_GetServicioProdCaract(Cn_IdServicio NUMBER) IS
       SELECT ispc.* FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ispc 
       WHERE  ispc.SERVICIO_ID = Cn_IdServicio; 

    CURSOR C_GetServicioComisionCaract(Cn_IdServicio NUMBER) IS
       SELECT isc.* FROM INFO_SERVICIO_COMISION isc 
       WHERE isc.SERVICIO_ID = Cn_IdServicio
       AND  isc.ESTADO  IN ('Activo'); 

     CURSOR C_GetSolicitudes(Cn_IdPunto NUMBER) IS
        SELECT 
        ids.ID_DETALLE_SOLICITUD ,
        ids.SERVICIO_ID, 
        idsc.ID_SOLICITUD_CARACTERISTICA , 
        idsc.CARACTERISTICA_ID , 
        ids.ESTADO AS ESTADO_CAB,
        idsc.ESTADO  AS ESTADO_DET
        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD ids 
        INNER JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT idsc  
        ON  ids.ID_DETALLE_SOLICITUD  =  idsc.DETALLE_SOLICITUD_ID  
        INNER JOIN DB_COMERCIAL.INFO_SERVICIO is2  
        ON  is2.ID_SERVICIO = ids.SERVICIO_ID 
        WHERE is2.PUNTO_ID = Cn_IdPunto; 

     CURSOR C_GetSolicitudesCompare(Cn_IdPunto NUMBER, Cn_IdCaracteristica NUMBER) IS
        SELECT 
        ids.ID_DETALLE_SOLICITUD ,
        ids.SERVICIO_ID, 
        idsc.ID_SOLICITUD_CARACTERISTICA , 
        idsc.CARACTERISTICA_ID , 
        ids.ESTADO AS ESTADO_CAB,
        idsc.ESTADO  AS ESTADO_DET
        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD ids 
        INNER JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT idsc  
        ON  ids.ID_DETALLE_SOLICITUD  =  idsc.DETALLE_SOLICITUD_ID  
        INNER JOIN DB_COMERCIAL.INFO_SERVICIO is2  
        ON  is2.ID_SERVICIO = ids.SERVICIO_ID 
        WHERE is2.PUNTO_ID = Cn_IdPunto
        AND  idsc.CARACTERISTICA_ID = Cn_IdCaracteristica;   
         

    CURSOR C_GetRepresentanteLegal(Cn_PersonaId NUMBER) IS
       SELECT
        ipre.id_persona_representante FROM DB_COMERCIAL.info_persona_representante ipre
        where ipre.persona_empresa_rol_id in (SELECT
                                                    id_persona_rol 
                                                    FROM DB_COMERCIAL.info_persona_empresa_rol iper
                                                    where iper.persona_id = Cn_PersonaId)
        and ipre.estado = 'Activo'; 

       Pcl_ClienteOrigen        C_GetPersonaEmpRol%ROWTYPE;
       Pcl_ClienteDestino       C_GetPersonaEmpRol%ROWTYPE;
       Pcl_RepresentanteLegal   C_GetRepresentanteLegal%ROWTYPE;

       Pcl_PuntoHisto          DB_COMERCIAL.INFO_PUNTO_HISTORIAL%ROWTYPE;  
       Pcl_ServicioHisto       DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
       Pcl_ServiComiHisto      DB_COMERCIAL.INFO_SERVICIO_COMISION_HISTO%ROWTYPE;
       Pcl_PersonaEmpRolHisto  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO%ROWTYPE;



       BEGIN 
       Lv_EstadoActivo     := 'Activo';
       Lv_EstadoEliminado  := 'Eliminado';
       Lv_EstadoCancelado  := 'Cancelado';
       Lv_EstadoInactivo   := 'Inactivo';
       Lv_EstadoPendiente  := 'Pendiente';


       APEX_JSON.PARSE(Pcl_Request); 

       Lv_CodEmpresa             := APEX_JSON.get_varchar2(p_path => 'strCodEmpresa');   
       Lv_PrefijoEmpresa         := APEX_JSON.get_varchar2(p_path => 'strPrefijoEmpresa');  
       Lv_UsrCreacion            := APEX_JSON.get_varchar2(p_path => 'strUsrCreacion'); 
       Lv_ClientIp               := APEX_JSON.get_varchar2(p_path => 'strClientIp');         
       Lv_YaExiste               := APEX_JSON.get_varchar2(p_path => 'strYaExiste');   
       Lv_MotivoReverso          := APEX_JSON.get_varchar2(p_path => 'strMotivoReverso');    
       Ln_IdPersonaEmpresaRolDestino := APEX_JSON.get_varchar2(p_path => 'intIdPersonaEmpresaRolDestino');
       Lv_MotivoReverso          := 'Se reverso el servicio por fallo en CRS: '|| SUBSTR(Lv_MotivoReverso,0,2000); 

 --1.- VALIDAR QUE EL EXISTE UN CAMBIO DE RAZON SOCIAL
       Lv_DataTemp :=NULL; 
       OPEN   C_GetVerificarCRS( Ln_IdPersonaEmpresaRolDestino , Lv_CodEmpresa);
       FETCH  C_GetVerificarCRS INTO  Lv_DataTemp;  
       CLOSE  C_GetVerificarCRS;    

      IF (Lv_DataTemp IS   NULL)  THEN 
             Pv_Mensaje := 'NO EXISTE CAMBIO DE RAZON SOCIAL.';
             dbms_output.put_line( Pv_Mensaje );  
             RAISE_APPLICATION_ERROR(-20101,Pv_Mensaje);
      END IF; 

 --2.- VALIDAR INFO DE CLIENTE DESTINO  
       OPEN  C_GetPersonaEmpRol(Ln_IdPersonaEmpresaRolDestino, Lv_CodEmpresa); 
       FETCH C_GetPersonaEmpRol INTO  Pcl_ClienteDestino;  
       CLOSE C_GetPersonaEmpRol;  

       IF (Pcl_ClienteDestino.ID_PERSONA IS  NULL)  THEN 
             Pv_Mensaje := 'CLIENTE DESTINO CON ID_PERSONA_ROL : '||Ln_IdPersonaEmpresaRolDestino||' NO EXISTE PARA CRS.';
             dbms_output.put_line( Pv_Mensaje );  
             RAISE_APPLICATION_ERROR(-20101,Pv_Mensaje);
       END IF; 


--3.- VALIDAR INFO DE CLIENTE ORIGEN 
       OPEN  C_GetPersonaEmpRol(Pcl_ClienteDestino.ID_PERSONA_ROL_ORIGEN, Lv_CodEmpresa); 
       FETCH C_GetPersonaEmpRol INTO  Pcl_ClienteOrigen;  
       CLOSE C_GetPersonaEmpRol;  

       IF (Pcl_ClienteOrigen.ID_PERSONA IS NULL)  THEN 
             Pv_Mensaje := 'CLIENTE ORIGEN CON ID_PERSONA_ROL : '||Pcl_ClienteDestino.ID_PERSONA_ROL_ORIGEN||' NO EXISTE PARA CRS.';
             dbms_output.put_line( Pv_Mensaje );  
             RAISE_APPLICATION_ERROR(-20101,Pv_Mensaje);
       END IF;

 --4.- REVERSO EN INFO_PERSONA 

           UPDATE DB_COMERCIAL.INFO_PERSONA ip SET 
           ip.ESTADO = Lv_EstadoActivo  
           WHERE ip.ID_PERSONA = Pcl_ClienteOrigen.ID_PERSONA  
           AND   ip.ESTADO  IN ( Lv_EstadoCancelado); 
           COMMIT;  
           dbms_output.put_line( 'INFO_PERSONA ORIGEN QUEDO ACTIVO ID_PERSONA=>'||Pcl_ClienteOrigen.ID_PERSONA );   

       IF  Lv_YaExiste  != 'S' THEN       
           UPDATE DB_COMERCIAL.INFO_PERSONA ip SET 
           ip.ESTADO = Lv_EstadoPendiente
           WHERE ip.ID_PERSONA = Pcl_ClienteDestino.ID_PERSONA   ; 
           COMMIT;  
           dbms_output.put_line( 'INFO_PERSONA DESTINO QUEDO PENDIENTE ID_PERSONA=>'||Pcl_ClienteDestino.ID_PERSONA );

          Pcl_PersonaEmpRolHisto                              := NULL;
          Pcl_PersonaEmpRolHisto.ID_PERSONA_EMPRESA_ROL_HISTO := DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL_H.NEXTVAL;
          Pcl_PersonaEmpRolHisto.USR_CREACION                 := Lv_UsrCreacion ;
          Pcl_PersonaEmpRolHisto.FE_CREACION                  := SYSDATE;        
          Pcl_PersonaEmpRolHisto.IP_CREACION                  := Lv_ClientIp;
          Pcl_PersonaEmpRolHisto.ESTADO                       := Lv_EstadoPendiente;   
          Pcl_PersonaEmpRolHisto.PERSONA_EMPRESA_ROL_ID       := Pcl_ClienteDestino.ID_PERSONA_ROL;
          Pcl_PersonaEmpRolHisto.OBSERVACION                  := Lv_MotivoReverso;    
          INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO VALUES Pcl_PersonaEmpRolHisto; 
          dbms_output.put_line('INFO_PERSONA_EMPRESA_ROL_HISTO   EN DESTINO  CREADO ID_PERSONA_EMPRESA_ROL_HISTO=>' || Pcl_PersonaEmpRolHisto.ID_PERSONA_EMPRESA_ROL_HISTO );
          COMMIT;  
           
       ELSE 
           UPDATE DB_COMERCIAL.INFO_PERSONA ip SET 
           ip.ESTADO = Lv_EstadoActivo  
           WHERE ip.ID_PERSONA = Pcl_ClienteDestino.ID_PERSONA   ; 
           COMMIT;  
           dbms_output.put_line( 'INFO_PERSONA DESTINO QUEDO ACTIVO ID_PERSONA=>'||Pcl_ClienteDestino.ID_PERSONA );   

          Pcl_PersonaEmpRolHisto                              := NULL;
          Pcl_PersonaEmpRolHisto.ID_PERSONA_EMPRESA_ROL_HISTO := DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL_H.NEXTVAL;
          Pcl_PersonaEmpRolHisto.USR_CREACION                 := Lv_UsrCreacion ;
          Pcl_PersonaEmpRolHisto.FE_CREACION                  := SYSDATE;        
          Pcl_PersonaEmpRolHisto.IP_CREACION                  := Lv_ClientIp;
          Pcl_PersonaEmpRolHisto.ESTADO                       := Lv_EstadoActivo;   
          Pcl_PersonaEmpRolHisto.PERSONA_EMPRESA_ROL_ID       := Pcl_ClienteDestino.ID_PERSONA_ROL;
          Pcl_PersonaEmpRolHisto.OBSERVACION                  := Lv_MotivoReverso;    
          INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO VALUES Pcl_PersonaEmpRolHisto; 
          dbms_output.put_line('INFO_PERSONA_EMPRESA_ROL_HISTO  EN DESTINO CREADO ID_PERSONA_EMPRESA_ROL_HISTO=>' || Pcl_PersonaEmpRolHisto.ID_PERSONA_EMPRESA_ROL_HISTO );
          COMMIT;  
           

       END IF ; 

 --5.- REVERSO EN INFO_PERSONA_EMPRESA_ROL 
           UPDATE DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper SET 
           iper.ESTADO =  Lv_EstadoActivo
           WHERE iper.PERSONA_ID      = Pcl_ClienteOrigen.ID_PERSONA 
           AND   iper.ID_PERSONA_ROL  = Pcl_ClienteOrigen.ID_PERSONA_ROL
           AND   iper.ESTADO IN (Lv_EstadoCancelado);
           COMMIT; 
           dbms_output.put_line( 'INFO_PERSONA_EMPRESA_ROL ORIGEN  QUEDO ACTIVO ID_PERSONA_ROL=>' ||Pcl_ClienteOrigen.ID_PERSONA_ROL);

       IF  Lv_YaExiste  != 'S' THEN     
           UPDATE DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper SET
           iper.ESTADO = Lv_EstadoEliminado --??
           WHERE iper.PERSONA_ID      = Pcl_ClienteDestino.ID_PERSONA
           AND   iper.ID_PERSONA_ROL  = Pcl_ClienteDestino.ID_PERSONA_ROL
           AND   iper.ESTADO IN (Lv_EstadoActivo);
           COMMIT;        
           dbms_output.put_line( 'INFO_PERSONA_EMPRESA_ROL DESTINO QUEDO ELIMINADO ID_PERSONA_ROL=>' ||Pcl_ClienteDestino.ID_PERSONA_ROL);
        END IF ; 
--6.- REVERSO INFO_PERSONA_REFERIDO
       IF  Lv_YaExiste  != 'S' THEN 
           UPDATE DB_COMERCIAL.INFO_PERSONA_REFERIDO iper SET 
           iper.ESTADO = Lv_EstadoActivo
           WHERE iper.PERSONA_EMPRESA_ROL_ID = Pcl_ClienteOrigen.ID_PERSONA_ROL
           AND   iper.ESTADO IN ( Lv_EstadoInactivo);            
           COMMIT;
           dbms_output.put_line( 'INFO_PERSONA_REFERIDO ORIGEN  QUEDO ACTIVO ID_PERSONA_ROL=>' ||Pcl_ClienteOrigen.ID_PERSONA_ROL );          

           UPDATE DB_COMERCIAL.INFO_PERSONA_REFERIDO iper SET 
           iper.ESTADO = Lv_EstadoEliminado
           WHERE iper.PERSONA_EMPRESA_ROL_ID = Pcl_ClienteDestino.ID_PERSONA_ROL 
           AND   iper.ESTADO IN (Lv_EstadoActivo);      
           COMMIT;         
           dbms_output.put_line( 'INFO_PERSONA_REFERIDO DESTINO QUEDO ELIMINADO ID_PERSONA_ROL=>' ||Pcl_ClienteDestino.ID_PERSONA_ROL  );
       END IF ; 
--7.- REVERSO INFO_PERSONA_CONTACTO 

        FOR Pcl_PersContOrigen IN  C_GetPersonaContacto(Pcl_ClienteOrigen.ID_PERSONA_ROL)  LOOP  

           UPDATE DB_COMERCIAL.INFO_PERSONA_CONTACTO ipc SET 
           ipc.ESTADO =  Lv_EstadoEliminado 
           WHERE ipc.PERSONA_EMPRESA_ROL_ID = Pcl_ClienteDestino.ID_PERSONA_ROL
           AND   ipc.CONTACTO_ID = Pcl_PersContOrigen.CONTACTO_ID
           AND   ipc.ESTADO  IN (Lv_EstadoActivo);
           COMMIT; 
          dbms_output.put_line( 'INFO_PERSONA_CONTACTO DESTINO QUEDO ELIMINADO CONTACTO_ID=>' ||Pcl_PersContOrigen.CONTACTO_ID );

        END LOOP; 

--8.- REVERSO INFO_PERSONA_FORMA_CONTACTO         
       --EN ESTA TABLA NO SE REALIZA CAMBIOS POR QUE LAS FORMAS DE PAGO SON LAS ASIGNADAS AL CLIENTE POR FORMULARIO

--9.- REVERSO INFO_CONTRATO SI ES FISICO O ES DIFERENTE DE MD
     IF  Lv_YaExiste  != 'S' THEN 
       UPDATE DB_COMERCIAL.INFO_CONTRATO ic  SET  
       ic.ESTADO = Lv_EstadoEliminado
       WHERE ic.PERSONA_EMPRESA_ROL_ID = Pcl_ClienteDestino.ID_PERSONA_ROL
       AND ic.ESTADO IN (Lv_EstadoActivo, Lv_EstadoPendiente)
       RETURNING  ic.ID_CONTRATO  INTO  Pcl_ClienteDestino.ID_CONTRATO; 
       COMMIT; 
       dbms_output.put_line( 'INFO_CONTRATO EN DESTINO ID_CONTRATO =>'|| Pcl_ClienteDestino.ID_CONTRATO); 
     END IF ;  



       UPDATE DB_COMERCIAL.INFO_CONTRATO ic  SET  
       ic.ESTADO = Lv_EstadoActivo
       WHERE ic.PERSONA_EMPRESA_ROL_ID = Pcl_ClienteOrigen.ID_PERSONA_ROL
       AND ic.ESTADO IN (Lv_EstadoCancelado)
       RETURNING  ic.ID_CONTRATO  INTO  Pcl_ClienteOrigen.ID_CONTRATO; 
       COMMIT; 
       dbms_output.put_line( 'INFO_CONTRATO EN ORIGEN ID_CONTRATO =>'|| Pcl_ClienteOrigen.ID_CONTRATO); 


 --10.- REVERSO INFO_CONTRATO_FORMA_PAGO


        IF Lv_YaExiste  != 'S' AND Pcl_ClienteDestino.ID_CONTRATO IS NOT NULL THEN 
          UPDATE  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO icfp SET 
          icfp.ESTADO  =  Lv_EstadoEliminado
          WHERE  icfp.CONTRATO_ID = Pcl_ClienteDestino.ID_CONTRATO  
          AND  icfp.ESTADO IN (Lv_EstadoActivo);
          COMMIT;
          dbms_output.put_line( 'INFO_CONTRATO_FORMA_PAGO EN DESTINO CONTRATO_ID =>'|| Pcl_ClienteDestino.ID_CONTRATO); 
        END IF;    


        IF  Pcl_ClienteOrigen.ID_CONTRATO IS NOT NULL THEN 
          UPDATE  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO icfp SET 
          icfp.ESTADO  = Lv_EstadoActivo
          WHERE  icfp.CONTRATO_ID = Pcl_ClienteOrigen.ID_CONTRATO  
          AND  icfp.ESTADO IN (Lv_EstadoCancelado);
          COMMIT;
          dbms_output.put_line( 'INFO_CONTRATO_FORMA_PAGO EN ORIGEN CONTRATO_ID =>'|| Pcl_ClienteOrigen.ID_CONTRATO); 
        END IF;   

--11.- RESTAURAR INFO_PERSONA_REPRESENTANTE
      IF (Lv_PrefijoEmpresa ='MD' AND  Pcl_ClienteOrigen.TIPO_TRIBUTARIO  =  'JUR' )THEN 

             UPDATE  DB_COMERCIAL.INFO_PERSONA_REPRESENTANTE ipr  SET 
             ipr.ESTADO = Lv_EstadoActivo  
             WHERE ipr.PERSONA_EMPRESA_ROL_ID = Pcl_ClienteOrigen.ID_PERSONA_ROL  
             AND   ipr.ESTADO  IN (Lv_EstadoEliminado)
             RETURNING  ipr.REPRESENTANTE_EMPRESA_ROL_ID  INTO  Pcl_ClienteOrigen.REPRESENTANTE_EMPRESA_ROL_ID ;
             COMMIT; 
             dbms_output.put_line( 'INFO_PERSONA_REPRESENTANTE EN ORIGEN REPRESENTANTE_EMPRESA_ROL_ID =>'|| Pcl_ClienteOrigen.REPRESENTANTE_EMPRESA_ROL_ID); 

             IF Pcl_ClienteOrigen.REPRESENTANTE_EMPRESA_ROL_ID is  NOT NULL THEN 
               UPDATE  INFO_PERSONA_EMPRESA_ROL iper SET 
               iper.ESTADO = Lv_EstadoActivo
               WHERE  iper.ID_PERSONA_ROL =   Pcl_ClienteOrigen.REPRESENTANTE_EMPRESA_ROL_ID
               AND    iper.ESTADO  IN (Lv_EstadoEliminado);
               COMMIT; 
               dbms_output.put_line( 'INFO_PERSONA_EMPRESA_ROL DE REPRESENTANTE EN ORIGEN ID_PERSONA_ROL =>'|| Pcl_ClienteOrigen.REPRESENTANTE_EMPRESA_ROL_ID); 
             END IF ;

             UPDATE  DB_COMERCIAL.INFO_PERSONA_REPRESENTANTE ipr  SET 
             ipr.ESTADO = Lv_EstadoEliminado
             WHERE ipr.PERSONA_EMPRESA_ROL_ID = Pcl_ClienteDestino.ID_PERSONA_ROL  
             AND  ipr.ESTADO IN (Lv_EstadoActivo)
             RETURNING  ipr.REPRESENTANTE_EMPRESA_ROL_ID  INTO  Pcl_ClienteDestino.REPRESENTANTE_EMPRESA_ROL_ID ;
             COMMIT;
             dbms_output.put_line('INFO_PERSONA_REPRESENTANTE EN DESTINO REPRESENTANTE_EMPRESA_ROL_ID =>'|| Pcl_ClienteDestino.REPRESENTANTE_EMPRESA_ROL_ID);

             IF Pcl_ClienteDestino.REPRESENTANTE_EMPRESA_ROL_ID IS  NOT NULL THEN 
               UPDATE  INFO_PERSONA_EMPRESA_ROL iper SET 
               iper.ESTADO = Lv_EstadoEliminado
               WHERE  iper.ID_PERSONA_ROL =   Pcl_ClienteDestino.REPRESENTANTE_EMPRESA_ROL_ID
               AND    iper.ESTADO  IN (Lv_EstadoActivo);
               COMMIT; 
               dbms_output.put_line( 'INFO_PERSONA_EMPRESA_ROL DE REPRESENTANTE EN DESTINO ID_PERSONA_ROL =>'|| Pcl_ClienteDestino.REPRESENTANTE_EMPRESA_ROL_ID); 

             END IF ; 
         END IF; 
         
       IF (Lv_PrefijoEmpresa ='MD' AND  Pcl_ClienteDestino.TIPO_TRIBUTARIO  =  'JUR' )THEN 
           --11.1 .- Se inactiva el representante legal del destino.
           OPEN  C_GetRepresentanteLegal(Pcl_ClienteDestino.ID_PERSONA); 
           FETCH C_GetRepresentanteLegal INTO  Pcl_RepresentanteLegal;  
           CLOSE C_GetRepresentanteLegal;

           IF (Pcl_RepresentanteLegal.ID_PERSONA_REPRESENTANTE IS NOT NULL)  THEN 
                 UPDATE info_persona_representante  SET
                    estado = Lv_EstadoEliminado,
                    usr_ult_mod = Lv_UsrCreacion
                  WHERE ID_PERSONA_REPRESENTANTE = Pcl_RepresentanteLegal.ID_PERSONA_REPRESENTANTE;
                 COMMIT;
           END IF; 
       END IF; 

 
--12.- REVERSO INFO_PUNTO
       FOR Pcl_PuntoDestino IN C_GetPunto(Pcl_ClienteDestino.ID_PERSONA)  LOOP 

              FOR Pcl_PuntoOrigen IN C_GetPuntoComparar(    Pcl_ClienteOrigen.ID_PERSONA_ROL, 
                                                            Pcl_PuntoDestino.PUNTO_COBERTURA_ID,
                                                            Pcl_PuntoDestino.TIPO_NEGOCIO_ID,
                                                            Pcl_PuntoDestino.TIPO_UBICACION_ID,
                                                            Pcl_PuntoDestino.SECTOR_ID,
                                                            Pcl_PuntoDestino.DIRECCION,
                                                            Pcl_PuntoDestino.LATITUD,
                                                            Pcl_PuntoDestino.LONGITUD)  LOOP 

--13.- REVERSO INFO_PUNTO
                   UPDATE  DB_COMERCIAL.INFO_PUNTO ip SET 
                   ip.LOGIN          = NULL, --??
                   ip.ESTADO         = Lv_EstadoEliminado
                   WHERE ip.ID_PUNTO = Pcl_PuntoDestino.ID_PUNTO; 
                   COMMIT;       

                   Pcl_PuntoHisto                    := NULL; 
                   Pcl_PuntoHisto.ID_PUNTO_HISTORIAL := DB_COMERCIAL.SEQ_INFO_PUNTO_HISTORIAL.NEXTVAL;
                   Pcl_PuntoHisto.PUNTO_ID           := Pcl_PuntoDestino.ID_PUNTO ; 
                   Pcl_PuntoHisto.VALOR              := Lv_MotivoReverso; 
                   Pcl_PuntoHisto.USR_CREACION       := Lv_UsrCreacion;   
                   Pcl_PuntoHisto.FE_CREACION        := SYSDATE;         
                   Pcl_PuntoHisto.IP_CREACION        := Lv_ClientIp ;  
                   INSERT INTO DB_COMERCIAL.INFO_PUNTO_HISTORIAL  VALUES Pcl_PuntoHisto;
                   COMMIT;
                   dbms_output.put_line('PUNTO EN  DESTINO ELIMINADO ID_PUNTO=>'||Pcl_PuntoDestino.ID_PUNTO );                                          

                  IF Pcl_PuntoDestino.ESTADO = 'Pendiente' THEN
                   UPDATE  DB_COMERCIAL.INFO_PUNTO ip SET  
                   ip.ESTADO          = Lv_EstadoActivo
                   WHERE ip.ID_PUNTO  = Pcl_PuntoOrigen.ID_PUNTO;              
                   COMMIT;
                  ELSE
                   UPDATE  DB_COMERCIAL.INFO_PUNTO ip SET  
                   ip.ESTADO          = Pcl_PuntoDestino.ESTADO
                   WHERE ip.ID_PUNTO  = Pcl_PuntoOrigen.ID_PUNTO;              
                   COMMIT;
                  END IF;

                   Pcl_PuntoHisto                    := NULL; 
                   Pcl_PuntoHisto.ID_PUNTO_HISTORIAL := DB_COMERCIAL.SEQ_INFO_PUNTO_HISTORIAL.NEXTVAL;
                   Pcl_PuntoHisto.PUNTO_ID           := Pcl_PuntoOrigen.ID_PUNTO; 
                   Pcl_PuntoHisto.VALOR              := Lv_MotivoReverso ; 
                   Pcl_PuntoHisto.USR_CREACION       := Lv_UsrCreacion ;   
                   Pcl_PuntoHisto.FE_CREACION        := SYSDATE;         
                   Pcl_PuntoHisto.IP_CREACION        := Lv_ClientIp ;  
                   INSERT INTO DB_COMERCIAL.INFO_PUNTO_HISTORIAL  VALUES  Pcl_PuntoHisto;
                   COMMIT;
                   dbms_output.put_line('PUNTO  EN ORIGEN '||Pcl_PuntoDestino.ESTADO||' ID_PUNTO=>'||Pcl_PuntoOrigen.ID_PUNTO );                                          



--15.- ELIMINAR INFO_PUNTO_CONTACTO DE PUNTO DESTINO

                   UPDATE DB_COMERCIAL.INFO_PUNTO_CONTACTO ipc  SET
                   ipc.ESTADO         = Lv_EstadoEliminado
                   WHERE ipc.PUNTO_ID = Pcl_PuntoDestino.ID_PUNTO;  
                   COMMIT;  
                   dbms_output.put_line('REGISTROS DE INFO_PUNTO_CONTACTO EN DESTINO ELIMINADOS PUNTO_ID =>'||Pcl_PuntoDestino.ID_PUNTO  );

                    dbms_output.put_line('SERVICIO PUNTO_ID =>'||Pcl_PuntoDestino.ID_PUNTO );
                    FOR Pcl_ServicioDestino IN C_GetServicio( Pcl_PuntoDestino.ID_PUNTO)  LOOP             
                        dbms_output.put_line('SERVICIO  OBSERVACION=>'|| Pcl_ServicioDestino.OBSERVACION); 
                         FOR Pcl_ServicioOrigen IN C_GetServicioComparar(Pcl_ServicioDestino.OBSERVACION)  LOOP 

        --16.- REVERSO INFO_SERVICIO 
                                IF Pcl_ServicioDestino.ESTADO = 'PreActivo' THEN
                                UPDATE DB_COMERCIAL.INFO_SERVICIO is2 SET  
                                is2.ESTADO               = Lv_EstadoActivo 
                                WHERE   is2.ID_SERVICIO  = Pcl_ServicioOrigen.ID_SERVICIO;
                                ELSE
                                UPDATE DB_COMERCIAL.INFO_SERVICIO is2 SET  
                                is2.ESTADO               = Pcl_ServicioDestino.ESTADO 
                                WHERE   is2.ID_SERVICIO  = Pcl_ServicioOrigen.ID_SERVICIO;
                                END IF;
                                COMMIT;  
                                dbms_output.put_line('INFO_SERVICIO EN ORIGEN '||Pcl_ServicioDestino.ESTADO ||' ID_SERVICIO=>' ||Pcl_ServicioOrigen.ID_SERVICIO);

                                UPDATE DB_COMERCIAL.INFO_SERVICIO is2 SET  
                                is2.ESTADO               = Lv_EstadoEliminado
                                WHERE   is2.ID_SERVICIO  = Pcl_ServicioDestino.ID_SERVICIO; 
                                COMMIT;  
                                dbms_output.put_line('INFO_SERVICIO EN DESTINO '||Lv_EstadoEliminado ||' ID_SERVICIO=>' ||Pcl_ServicioDestino.ID_SERVICIO);

        --17.- REVERSO INFO_SERVICIO_CARACTERISTICA  
                                UPDATE DB_INFRAESTRUCTURA.INFO_IP ii SET 
                                ii.ESTADO = Lv_EstadoActivo 
                                WHERE ii.SERVICIO_ID = Pcl_ServicioOrigen.ID_SERVICIO
                                AND ii.ESTADO  IN (Lv_EstadoCancelado)  ; 
                                COMMIT;  
                                dbms_output.put_line('INFO_IP EN ORIGEN  ACTIVADO SERVICIO_ID=>' ||Pcl_ServicioOrigen.ID_SERVICIO);


        --18.- REVERSO INFO_SERVICIO_CARACTERISTICA                     
                                    FOR Pcl_ServicioCaractDestino IN  C_GetServicioCaracteristica( Pcl_ServicioDestino.ID_SERVICIO)  LOOP 


                                           UPDATE  DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA isc SET
                                           isc.ESTADO = Lv_EstadoEliminado
                                           WHERE isc.CARACTERISTICA_ID          = Pcl_ServicioCaractDestino.CARACTERISTICA_ID  
                                           AND   isc.ID_SERVICIO_CARACTERISTICA = Pcl_ServicioCaractDestino.ID_SERVICIO_CARACTERISTICA
                                           AND   isc.SERVICIO_ID = Pcl_ServicioCaractDestino.SERVICIO_ID; 
                                           COMMIT ;
                                           dbms_output.put_line('INFO_SERVICIO_CARACTERISTICA EN DESTINO '||Lv_EstadoEliminado ||' ID_SERVICIO_CARACTERISTICA=>' ||Pcl_ServicioCaractDestino.ID_SERVICIO_CARACTERISTICA);

                                           UPDATE DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA isc SET  
                                            isc.ESTADO         = Pcl_ServicioCaractDestino.ESTADO,  
                                            isc.VALOR          = Pcl_ServicioCaractDestino.VALOR,   
                                            isc.FE_FACTURACION = Pcl_ServicioCaractDestino.FE_FACTURACION,
                                            isc.CICLO_ORIGEN_ID= Pcl_ServicioCaractDestino.CICLO_ORIGEN_ID, 
                                            isc.OBSERVACION    = Pcl_ServicioCaractDestino.OBSERVACION,                                                                                                                                
                                            isc.USR_CREACION   = Pcl_ServicioCaractDestino.USR_CREACION,   
                                            isc.IP_CREACION    = Pcl_ServicioCaractDestino.IP_CREACION, 
                                            isc.FE_CREACION    = Pcl_ServicioCaractDestino.FE_CREACION,        
                                            isc.USR_ULT_MOD    = Lv_UsrCreacion,    
                                            isc.IP_ULT_MOD     = Lv_ClientIp,  
                                            isc.FE_ULT_MOD     = SYSDATE,        
                                            isc.REF_ID_SERVICIO_CARACTERISTICA  = Pcl_ServicioCaractDestino.REF_ID_SERVICIO_CARACTERISTICA
                                           WHERE  isc.CARACTERISTICA_ID         = Pcl_ServicioCaractDestino.CARACTERISTICA_ID  
                                           AND    isc.SERVICIO_ID               = Pcl_ServicioOrigen.ID_SERVICIO; 
                                           COMMIT ;
                                           dbms_output.put_line('INFO_SERVICIO_CARACTERISTICA EN ORIGEN  RESTAURADA ID_SERVICIO=>' ||Pcl_ServicioOrigen.ID_SERVICIO);

                                    END LOOP; 

        --19.- REVERSO INFO_SERVICIO_PROD_CARACT

                                    FOR Pcl_ServicioProdCaractDestino IN  C_GetServicioProdCaract( Pcl_ServicioDestino.ID_SERVICIO)  LOOP 



                                           UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ispc  SET
                                           ispc.ESTADO = Lv_EstadoEliminado
                                           WHERE  ispc.ID_SERVICIO_PROD_CARACT      = Pcl_ServicioProdCaractDestino.ID_SERVICIO_PROD_CARACT
                                           AND    ispc.SERVICIO_ID                  = Pcl_ServicioProdCaractDestino.SERVICIO_ID; 
                                           COMMIT ;
                                           dbms_output.put_line('INFO_SERVICIO_PROD_CARACT EN DESTINO '||Lv_EstadoEliminado ||' ID_SERVICIO_PROD_CARACT=>' ||Pcl_ServicioProdCaractDestino.ID_SERVICIO_PROD_CARACT);

                                            UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT  isc SET  
                                           isc.ESTADO                      = Pcl_ServicioProdCaractDestino.ESTADO,  
                                           isc.VALOR                       = Pcl_ServicioProdCaractDestino.VALOR,   
                                           isc.REF_SERVICIO_PROD_CARACT_ID = Pcl_ServicioProdCaractDestino.REF_SERVICIO_PROD_CARACT_ID,         
                                           isc.USR_ULT_MOD                 = Lv_UsrCreacion,   
                                           isc.FE_ULT_MOD                  = SYSDATE   
                                           WHERE  isc.PRODUCTO_CARACTERISITICA_ID =  Pcl_ServicioProdCaractDestino.PRODUCTO_CARACTERISITICA_ID
                                           AND    isc.SERVICIO_ID                 =  Pcl_ServicioOrigen.ID_SERVICIO ; 
                                           COMMIT ;
                                           dbms_output.put_line('INFO_SERVICIO_PROD_CARACT EN ORIGEN  RESTAURADAS' );

                                    END LOOP; 

        --20 REVERSAR INFO_SERVICIO_COMISION                         

                                    FOR Pcl_ServicioComisionDestino IN  C_GetServicioComisionCaract(Pcl_ServicioDestino.ID_SERVICIO) LOOP

                                     
                                         UPDATE DB_COMERCIAL.INFO_SERVICIO_COMISION isc SET
                                         isc.ESTADO        = Lv_EstadoEliminado,
                                         isc.FE_ULT_MOD    = SYSDATE ,
                                         isc.USR_CREACION  = Lv_UsrCreacion,
                                         isc.IP_ULT_MOD    = Lv_ClientIp
                                         WHERE isc.ID_SERVICIO_COMISION    = Pcl_ServicioComisionDestino.ID_SERVICIO_COMISION 
                                         AND   isc.SERVICIO_ID             = Pcl_ServicioDestino.ID_SERVICIO
                                         AND   isc.PERSONA_EMPRESA_ROL_ID  = Pcl_ClienteDestino.ID_PERSONA_ROL; 
                                         COMMIT ;
                                         dbms_output.put_line('INFO_SERVICIO_COMISION  EN DESTINO ELIMINADA ID_SERVICIO_COMISION=>' || Pcl_ServicioComisionDestino.ID_SERVICIO_COMISION);

                                       
                                         Pcl_ServiComiHisto                            := NULL; 
                                         Pcl_ServiComiHisto.ID_SERVICIO_COMISION_HISTO := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL;
                                         Pcl_ServiComiHisto.SERVICIO_COMISION_ID       := Pcl_ServicioComisionDestino.ID_SERVICIO_COMISION ; 
                                         Pcl_ServiComiHisto.SERVICIO_ID                := Pcl_ServicioDestino.ID_SERVICIO; 
                                         Pcl_ServiComiHisto.COMISION_DET_ID            := Pcl_ServicioComisionDestino.COMISION_DET_ID ; 
                                         Pcl_ServiComiHisto.PERSONA_EMPRESA_ROL_ID     := Pcl_ClienteDestino.ID_PERSONA_ROL;
                                         Pcl_ServiComiHisto.COMISION_VENTA             := Pcl_ServicioComisionDestino.COMISION_VENTA;
                                         Pcl_ServiComiHisto.COMISION_MANTENIMIENTO     := Pcl_ServicioComisionDestino.COMISION_MANTENIMIENTO;
                                         Pcl_ServiComiHisto.ESTADO                     := Lv_EstadoActivo; 
                                         Pcl_ServiComiHisto.OBSERVACION                := Lv_MotivoReverso ;                                                   
                                         Pcl_ServiComiHisto.USR_CREACION               := Lv_UsrCreacion;
                                         Pcl_ServiComiHisto.FE_CREACION                := SYSDATE;     
                                         Pcl_ServiComiHisto.IP_CREACION                := Lv_ClientIp;
                                         INSERT INTO   DB_COMERCIAL.INFO_SERVICIO_COMISION_HISTO  VALUES Pcl_ServiComiHisto;
                                         COMMIT ;
                                         dbms_output.put_line('INFO_SERVICIO_COMISION_HISTO CREO EN DESTINO ID_SERVICIO_COMISION_HISTO =>' || Pcl_ServiComiHisto.ID_SERVICIO_COMISION_HISTO);
                                      

                                         UPDATE DB_COMERCIAL.INFO_SERVICIO_COMISION isc SET
                                         isc.ESTADO        = Pcl_ServicioComisionDestino.ESTADO,
                                         isc.FE_ULT_MOD    = SYSDATE ,
                                         isc.USR_CREACION  = Lv_UsrCreacion,
                                         isc.IP_ULT_MOD    = Lv_ClientIp
                                         WHERE isc.COMISION_DET_ID         = Pcl_ServicioComisionDestino.COMISION_DET_ID
                                         AND   isc.COMISION_VENTA          = Pcl_ServicioComisionDestino.COMISION_VENTA
                                         AND   isc.COMISION_MANTENIMIENTO  = Pcl_ServicioComisionDestino.COMISION_MANTENIMIENTO
                                         AND   isc.SERVICIO_ID             = Pcl_ServicioOrigen.ID_SERVICIO
                                         AND   isc.PERSONA_EMPRESA_ROL_ID  = Pcl_ClienteOrigen.ID_PERSONA_ROL;
                                         COMMIT ;
                                         dbms_output.put_line('INFO_SERVICIO_COMISION  EN ORIGEN  '||Pcl_ServicioComisionDestino.ESTADO||'ID_SERVICIO=>' ||  Pcl_ServicioOrigen.ID_SERVICIO);
 
                                         Pcl_ServiComiHisto                            := NULL; 
                                         Pcl_ServiComiHisto.ID_SERVICIO_COMISION_HISTO := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL;
                                         Pcl_ServiComiHisto.SERVICIO_COMISION_ID       := Pcl_ServicioComisionDestino.ID_SERVICIO_COMISION ; 
                                         Pcl_ServiComiHisto.SERVICIO_ID                := Pcl_ServicioOrigen.ID_SERVICIO; 
                                         Pcl_ServiComiHisto.COMISION_DET_ID            := Pcl_ServicioComisionDestino.COMISION_DET_ID ; 
                                         Pcl_ServiComiHisto.PERSONA_EMPRESA_ROL_ID     := Pcl_ClienteOrigen.ID_PERSONA_ROL;
                                         Pcl_ServiComiHisto.COMISION_VENTA             := Pcl_ServicioComisionDestino.COMISION_VENTA;
                                         Pcl_ServiComiHisto.COMISION_MANTENIMIENTO     := Pcl_ServicioComisionDestino.COMISION_MANTENIMIENTO;
                                         Pcl_ServiComiHisto.ESTADO                     := Lv_EstadoActivo; 
                                         Pcl_ServiComiHisto.OBSERVACION                := Lv_MotivoReverso ;                                                   
                                         Pcl_ServiComiHisto.USR_CREACION               := Lv_UsrCreacion;
                                         Pcl_ServiComiHisto.FE_CREACION                := SYSDATE;     
                                         Pcl_ServiComiHisto.IP_CREACION                := Lv_ClientIp;
                                         INSERT INTO   DB_COMERCIAL.INFO_SERVICIO_COMISION_HISTO  VALUES Pcl_ServiComiHisto;
                                         COMMIT ;
                                         dbms_output.put_line('INFO_SERVICIO_COMISION_HISTO CREO EN Origen ID_SERVICIO_COMISION_HISTO =>' || Pcl_ServiComiHisto.ID_SERVICIO_COMISION_HISTO);
                                         

                                    END LOOP; 

        --21.- REVERSAR INFO_DETALLE_SOL_CARACT

                                        FOR Pcl_SolicitudDestino IN  C_GetSolicitudes(Pcl_PuntoDestino.ID_PUNTO) LOOP

                                                 UPDATE  DB_COMERCIAL.INFO_DETALLE_SOLICITUD ids SET
                                                 ids.ESTADO  = Lv_EstadoEliminado
                                                 WHERE         ids.ID_DETALLE_SOLICITUD  = Pcl_SolicitudDestino.ID_DETALLE_SOLICITUD;
                                                 dbms_output.put_line('INFO_DETALLE_SOLICITUD EN DESTINO ELIMINADA  ID_DETALLE_SOLICITUD> '||Pcl_SolicitudDestino.ID_DETALLE_SOLICITUD );

                                                 UPDATE DB_COMERCIAL.INFO_DETALLE_SOL_CARACT idsc SET  
                                                 idsc.ESTADO      = Lv_EstadoEliminado,
                                                 idsc.USR_ULT_MOD = Lv_UsrCreacion,  
                                                 idsc.FE_ULT_MOD  = SYSDATE                 
                                                 WHERE idsc.ID_SOLICITUD_CARACTERISTICA =  Pcl_SolicitudDestino.ID_SOLICITUD_CARACTERISTICA;
                                                 dbms_output.put_line('INFO_DETALLE_SOL_CARACT EN DESTINO ELIMINADA  ID_SOLICITUD_CARACTERISTICA=> '||Pcl_SolicitudDestino.ID_SOLICITUD_CARACTERISTICA );


                                             FOR Pcl_SolicitudOrigen IN  C_GetSolicitudesCompare(Pcl_PuntoOrigen.ID_PUNTO,  Pcl_SolicitudDestino.CARACTERISTICA_ID) LOOP          
  
                                                 UPDATE  DB_COMERCIAL.INFO_DETALLE_SOLICITUD ids SET
                                                 ids.ESTADO  = Pcl_SolicitudDestino.ESTADO_CAB
                                                 WHERE         ids.ID_DETALLE_SOLICITUD  =  Pcl_SolicitudOrigen.ID_DETALLE_SOLICITUD;
                                                 dbms_output.put_line('INFO_DETALLE_SOLICITUD EN ORIGEN ELIMINADA  ID_DETALLE_SOLICITUD> '|| Pcl_SolicitudOrigen.ID_DETALLE_SOLICITUD );
 
                                                
                                                 UPDATE DB_COMERCIAL.INFO_DETALLE_SOL_CARACT idsc SET  
                                                 idsc.ESTADO      = Pcl_SolicitudDestino.ESTADO_DET,
                                                 idsc.USR_ULT_MOD = Lv_UsrCreacion,  
                                                 idsc.FE_ULT_MOD  = SYSDATE
                                                 WHERE idsc.ID_SOLICITUD_CARACTERISTICA =  Pcl_SolicitudOrigen.ID_SOLICITUD_CARACTERISTICA;
                                                 dbms_output.put_line('INFO_DETALLE_SOL_CARACT EN ORIGEN '||Pcl_SolicitudDestino.ESTADO_DET||'  ID_SOLICITUD_CARACTERISTICA=> '||Pcl_SolicitudOrigen.ID_SOLICITUD_CARACTERISTICA);
               
                                           END LOOP;           
                                      END LOOP;      

        --22.-CREAR HISTORIAL 

                            Pcl_ServicioHisto                       := NULL;   
                            Pcl_ServicioHisto.ID_SERVICIO_HISTORIAL := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL;
                            Pcl_ServicioHisto.SERVICIO_ID           := Pcl_ServicioOrigen.ID_SERVICIO; 
                            Pcl_ServicioHisto.USR_CREACION          := Lv_UsrCreacion ;   
                            Pcl_ServicioHisto.FE_CREACION           := SYSDATE;
                            Pcl_ServicioHisto.IP_CREACION           := Lv_ClientIp ;  
                            Pcl_ServicioHisto.ESTADO                := Lv_EstadoActivo;
                            Pcl_ServicioHisto.OBSERVACION           := Lv_MotivoReverso;  
                            INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL VALUES  Pcl_ServicioHisto ; 
                            dbms_output.put_line('INFO_SERVICIO_HISTORIAL EN ORIGEN CREADO ID_SERVICIO_HISTORIAL=>' ||Pcl_ServicioHisto.ID_SERVICIO_HISTORIAL  );

                            Pcl_ServicioHisto                       := NULL;   
                            Pcl_ServicioHisto.ID_SERVICIO_HISTORIAL := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL;
                            Pcl_ServicioHisto.SERVICIO_ID           := Pcl_ServicioDestino.ID_SERVICIO; 
                            Pcl_ServicioHisto.USR_CREACION          := Lv_UsrCreacion ;   
                            Pcl_ServicioHisto.FE_CREACION           := SYSDATE;
                            Pcl_ServicioHisto.IP_CREACION           := Lv_ClientIp ;  
                            Pcl_ServicioHisto.ESTADO                := Lv_EstadoEliminado;
                            Pcl_ServicioHisto.OBSERVACION           := Lv_MotivoReverso;  
                            INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL VALUES  Pcl_ServicioHisto ; 
                            dbms_output.put_line('INFO_SERVICIO_HISTORIAL EN ORIGEN CREADO ID_SERVICIO_HISTORIAL=>' ||Pcl_ServicioHisto.ID_SERVICIO_HISTORIAL  );


                              END LOOP; 

                    END LOOP;  

            END LOOP; 

       END LOOP; 
--23.- SE DEBE CREAR REGISTRO EN INFO_PERSONA_EMPRESA_ROL_HISTO 

    Pcl_PersonaEmpRolHisto                              := NULL;
    Pcl_PersonaEmpRolHisto.ID_PERSONA_EMPRESA_ROL_HISTO := DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL_H.NEXTVAL;
    Pcl_PersonaEmpRolHisto.USR_CREACION                 := Lv_UsrCreacion ;
    Pcl_PersonaEmpRolHisto.FE_CREACION                  := SYSDATE;        
    Pcl_PersonaEmpRolHisto.IP_CREACION                  := Lv_ClientIp;
    Pcl_PersonaEmpRolHisto.ESTADO                       := Lv_EstadoActivo;   
    Pcl_PersonaEmpRolHisto.PERSONA_EMPRESA_ROL_ID       := Pcl_ClienteOrigen.ID_PERSONA_ROL;
    Pcl_PersonaEmpRolHisto.OBSERVACION                  := Lv_MotivoReverso;    
    INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO VALUES Pcl_PersonaEmpRolHisto; 
   dbms_output.put_line('INFO_PERSONA_EMPRESA_ROL_HISTO  EN ORIGEN CREADO ID_PERSONA_EMPRESA_ROL_HISTO=>' || Pcl_PersonaEmpRolHisto.ID_PERSONA_EMPRESA_ROL_HISTO );


        OPEN Pcl_Response FOR  
        SELECT
        Pcl_ClienteOrigen.IDENTIFICACION_CLIENTE AS IDENTIFICACION_ORI,
        Pcl_ClienteOrigen.ID_PERSONA AS ID_PERSONA_OR,     
        Pcl_ClienteOrigen.ID_PERSONA_ROL AS ID_PERSONA_ROL_ORI,
        Pcl_ClienteOrigen.ID_EMPRESA_ROL AS ID_EMPRESA_ROL_ORI,
        Pcl_ClienteOrigen.TIPO_TRIBUTARIO AS TIPO_TRIBUTARIO_ORI,  
        Pcl_ClienteOrigen.ID_CONTRATO AS ID_CONTRATO_ORI ,

        Pcl_ClienteDestino.IDENTIFICACION_CLIENTE AS IDENTIFICACION_DES,
        Pcl_ClienteDestino.ID_PERSONA AS ID_PERSONA_DES,     
        Pcl_ClienteDestino.ID_PERSONA_ROL AS ID_PERSONA_ROL_DES,
        Pcl_ClienteDestino.ID_EMPRESA_ROL AS ID_EMPRESA_ROL_DES,
        Pcl_ClienteDestino.TIPO_TRIBUTARIO AS TIPO_TRIBUTARIO_DES,  
        Pcl_ClienteDestino.ID_CONTRATO AS ID_CONTRATO_DES 
        FROM DUAL; 

       Pv_Mensaje   := Lv_MotivoReverso;
       Pv_Status    := 'OK';
       dbms_output.put_line(Pv_Mensaje );  
       EXCEPTION
           WHEN OTHERS THEN
           ROLLBACK;
           Pv_Status     := 'ERROR'; 
           Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
           DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
           'REVERSAR CAMBIO RAZON SOCIAL',
           'DB_COMERCIAL.CMKG_CRS_TRANSACCION.P_REVERSAR_CRS',
           'Error: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
           'telcos',
           SYSDATE,
           '127.0.0.1');

    END P_REVERSAR_CRS;   
END CMKG_CRS_TRANSACCION;       
/