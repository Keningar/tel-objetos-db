CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_CATALOGOS_MOBILE
AS
    /**
      * Documentación para el procedimiento P_GENERA_JSON_CATALOGOS
      *
      * Método que se encarga de generar el JSON de cada uno de los catálogos y cargalos en la tabla
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 07-08-2018
      *
      * @author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.1 16-16-2019 - Se modifica el procedimiento para que solo puedan enviar los productos que utiliza el TM-COMERCIAL
      *
      */
    PROCEDURE P_GENERA_JSON_CATALOGOS(Pv_Empresa     IN  VARCHAR2,
                                      Pv_Descripcion IN  VARCHAR2,
                                      Pv_Error       OUT VARCHAR2);

    /**
      * Función que se encarga de generar el JSON de catalogo de productos
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 07-08-2018
      *
      * @author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.1 16-10-2019 - Se modifica el procedimiento par aque solo se puedan enviar los productos
      *                           que se encuentren especificados en admi_parametros
      */
    FUNCTION F_GENERA_JSON_PRODUCTOS(Pv_Empresa     IN  VARCHAR2,
                                     Pv_Descripcion IN  VARCHAR2,
                                     Pv_Error       IN  VARCHAR2)
    RETURN CLOB;

    /**
      * Función que se encarga de generar el JSON de catalogo de puntos de cobertura
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 03-10-2018
      */
    FUNCTION F_GENERA_JSON_COBERTURA(Fv_Empresa     IN  VARCHAR2,
                                     Fv_Descripcion IN  VARCHAR2,
                                     Fv_Error       IN  VARCHAR2)
    RETURN CLOB;

    /**
      * Función que se encarga de generar el JSON de los canales de venta
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 14-02-2019
      *
      * author Edgar Holguin <eholguin@telconet.ec>
      * @version 1.1 24-07-2019 Se unifican cursores por medio del uso de sentencia JOIN. Se agregan validaciones para obtener el json original.
      */
    FUNCTION F_GENERA_JSON_CANALES(Fv_Empresa     IN  VARCHAR2,
                                   Fv_Descripcion IN  VARCHAR2,
                                   Fv_Error       IN  VARCHAR2)
    RETURN CLOB;

    /**
      * Función que se encarga de generar el JSON de los TIPO DE CUENTA/BANCOS
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 18-02-2019
      *
      * author Edgar Holguin <eholguin@telconet.ec>
      * @version 1.1 24-07-2019 Se unifican cursores por medio del uso de sentencia JOIN.Se agregan validaciones para obtener el json original.
      */
    FUNCTION F_GENERA_JSON_TIPO_CUENTA(Fv_Empresa     IN  VARCHAR2,
                                       Fv_Descripcion IN  VARCHAR2,
                                       Fv_Error       IN  VARCHAR2)
    RETURN CLOB;

    /**
      * Función que se encarga de generar el JSON de los TIPO DE NEGOCIO
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 19-02-2019
      */
    FUNCTION F_GENERA_JSON_TIPO_NEGOCIO(Fv_Empresa     IN  VARCHAR2,
                                        Fv_Descripcion IN  VARCHAR2,
                                        Fv_Error       IN  VARCHAR2)
    RETURN CLOB;

    /**
      * Función que se encarga de generar el JSON de los TIPO DE CONTRATO
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 19-02-2019
      */
    FUNCTION F_GENERA_JSON_TIPO_CONTRATO(Fv_Empresa     IN  VARCHAR2,
                                         Fv_Descripcion IN  VARCHAR2,
                                         Fv_Error       IN  VARCHAR2)
    RETURN CLOB;

    /**
      * Función que se encarga de generar el JSON de los DOCUMENTOS OBLIGATORIOS
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 24-04-2019
      *
      * author Christian Jaramillo Espinoza <cjaramilloe@telconet.ec>
      * @version 1.1 20-06-2020 Adición de consultas de documentos obligatorios para persona jurídica
      */
    FUNCTION F_GENERA_JSON_DOC_OBLIGATORIOS(Fv_Empresa     IN  VARCHAR2,
                                            Fv_Descripcion IN  VARCHAR2,
                                            Fv_Error       IN  VARCHAR2)
    RETURN CLOB;

    /**
      * Función que se encarga de generar el JSON de elemento por empresa y tipo.
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Holguin <eholguin@telconet.ec>
      * @version 1.0 19-07-2019
      *
      * Se agrega condicion para la empresa ecuanet obtenga edicios de mega
      * author Carlos Caguana <ccaguana@telconet.ec>
      * @version 1.1 10-03-2023
      */

    FUNCTION F_GENERA_JSON_ELEMENTOS (Fv_Empresa  IN  VARCHAR2)
    RETURN CLOB;

    /**
   * Documentacion para la funcion F_GET_VARCHAR_CLEAN
   * Funcion que limpia ciertos caracteres especiales de lña cadena enviada cono parámetro.
   * @param Fv_Cadena IN VARCHAR2   Recibe la cadena a limpiar
   * @return             VARCHAR2   Retorna cadena sin caracteres especiales
   *
   * @author Edgar Holguin <eholguin@telconet.ec>
   * @version 1.0 31-07-2019
   */
  FUNCTION F_GET_VARCHAR_CLEAN(
      Fv_Cadena IN VARCHAR2)
    RETURN VARCHAR2;

    /**
      * Función que se encarga de generar el JSON de catálogo de productos que se presentarán por empresa
      *
      * Costo Del Query C_Productos:       11
      * Costo Del Query C_Caracteristica:  25
      *
      * @author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 16-10-2019
      *
      * @author Christian Jaramillo Espinoza <cjaramilloe@telconet.ec>
      * @version 1.1 05-04-2020 Implementación para obtener información de servicios adicionales parametrizados.
      *
      */
    FUNCTION F_GENERA_JSON_PRODUCTOS_DISP(Pv_Empresa     IN  VARCHAR2,
                                          Pv_Descripcion IN  VARCHAR2,
                                          Pv_Error       IN  VARCHAR2)
    RETURN CLOB;

    /**
      * Función que se encarga de generar el JSON de catalogo de productos que se presentaran por empresa
      *
      * @author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 16-10-2019
      */
    FUNCTION F_GENERA_JSON_PARAMETROS(Pv_Empresa     IN  VARCHAR2,
                                      Pv_Descripcion IN  VARCHAR2,
                                      Pv_Error       IN  VARCHAR2)
    RETURN CLOB;

    /**
      * Función que se encarga de generar el JSON de los tipos de promociones aplicables para planes y productos adicionales
      *
      * @author Christian Jaramillo Espinoza <cjaramilloe@telconet.ec>
      * @version 1.0 26-11-2020
      */
    FUNCTION F_GENERA_JSON_PROMOCIONES(Pv_Empresa     IN  VARCHAR2,
                                       Pv_Descripcion IN  VARCHAR2,
                                       Pv_Error       IN  VARCHAR2)
    RETURN CLOB;
    
    /**
      * Función que se encarga de obtener los estados de los puntos
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Walther Joao Gaibor C. <wgaibor@telconet.ec>
      * @version 1.0 07-10-2021
      */
    FUNCTION F_GENERA_JSON_ESTADOS_PUNTO
    RETURN CLOB;
    
    /**
      * Función que se encarga de obtener la última milla
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Walther Joao Gaibor C. <wgaibor@telconet.ec>
      * @version 1.0 07-10-2021
      */
    FUNCTION F_GENERA_JSON_ULTIMA_MILLA
    RETURN CLOB;
    
    /**
      * Función que se encarga de obtener los estados del servicio
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Walther Joao Gaibor C. <wgaibor@telconet.ec>
      * @version 1.0 07-10-2021
      */
    FUNCTION F_GENERA_JSON_ESTADOS_SERVICIO
    RETURN CLOB;
    
    /**
      * Función que se encarga de obtener los estados del servicio
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Walther Joao Gaibor C. <wgaibor@telconet.ec>
      * @version 1.0 07-10-2021
      */
    FUNCTION F_GENERA_JSON_TIPO_SOLICITUD
    RETURN CLOB;

    /**
      * Función que se encarga de obtener los motivos hal
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Walther Joao Gaibor C. <wgaibor@telconet.ec>
      * @version 1.0 07-10-2021
      */
    FUNCTION F_GENERA_JSON_MOTIVO_HAL
    RETURN CLOB;

END CMKG_CATALOGOS_MOBILE;

/
CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_CATALOGOS_MOBILE AS
  PROCEDURE P_GENERA_JSON_CATALOGOS(Pv_Empresa     IN  VARCHAR2,
                                    Pv_Descripcion IN  VARCHAR2,
                                    Pv_Error       OUT VARCHAR2) AS

    Lcl_Json CLOB ;
  BEGIN
  Lcl_Json :=  Lcl_Json || '{"response":{';

  --Lleno el Json object productos
  DBMS_LOB.APPEND(Lcl_Json, F_GENERA_JSON_PRODUCTOS (Pv_Empresa,
                                                    Pv_Descripcion,
                                                    Pv_Error));
  DBMS_LOB.APPEND(Lcl_Json, ',');

  --Lleno el Json object productos disponibles
  DBMS_LOB.APPEND(Lcl_Json, F_GENERA_JSON_PRODUCTOS_DISP (Pv_Empresa,
                                                          Pv_Descripcion,
                                                          Pv_Error));


  DBMS_LOB.APPEND(Lcl_Json, ',');
  --Lleno el Json object puntoCobertura
  DBMS_LOB.APPEND(Lcl_Json, F_GENERA_JSON_COBERTURA (Pv_Empresa,
                                                    Pv_Descripcion,
                                                    Pv_Error));
  DBMS_LOB.APPEND(Lcl_Json, ',');
  --Lleno el Json object Canales
  DBMS_LOB.APPEND(Lcl_Json, F_GENERA_JSON_CANALES (Pv_Empresa,
                                                  Pv_Descripcion,
                                                  Pv_Error));
  DBMS_LOB.APPEND(Lcl_Json, ',');
  --Lleno el Json object Tipo Negocio
  DBMS_LOB.APPEND(Lcl_Json, F_GENERA_JSON_TIPO_NEGOCIO (Pv_Empresa,
                                                       Pv_Descripcion,
                                                       Pv_Error));
  DBMS_LOB.APPEND(Lcl_Json, ',');
  --Lleno el Json object Tipo Negocio
  DBMS_LOB.APPEND(Lcl_Json, F_GENERA_JSON_TIPO_CONTRATO (Pv_Empresa,
                                                        Pv_Descripcion,
                                                        Pv_Error));
  DBMS_LOB.APPEND(Lcl_Json, ',');
  --Lleno el Json object Tipo Negocio
  DBMS_LOB.APPEND(Lcl_Json, F_GENERA_JSON_ELEMENTOS (Pv_Empresa));

  DBMS_LOB.APPEND(Lcl_Json, ',');
  --Lleno el Json object Tipo Negocio
  DBMS_LOB.APPEND(Lcl_Json, F_GENERA_JSON_DOC_OBLIGATORIOS (Pv_Empresa,
                                                           Pv_Descripcion,
                                                           Pv_Error));
  DBMS_LOB.APPEND(Lcl_Json, ',');
  --Lleno el Json object Tipo Negocio
  DBMS_LOB.APPEND(Lcl_Json, F_GENERA_JSON_PARAMETROS (Pv_Empresa,
                                                      Pv_Descripcion,
                                                      Pv_Error));

  DBMS_LOB.APPEND(Lcl_Json, ',');
  --LLeno los tipos de codigos promocionales aplicables
  DBMS_LOB.APPEND(Lcl_Json, F_GENERA_JSON_PROMOCIONES(Pv_Empresa,
                                                      Pv_Descripcion,
                                                      Pv_Error));
  DBMS_LOB.APPEND(Lcl_Json, ',');
  --LLeno los estados de puntos
  DBMS_LOB.APPEND(Lcl_Json, F_GENERA_JSON_ESTADOS_PUNTO);
  DBMS_LOB.APPEND(Lcl_Json, ',');
  --LLeno los estados de puntos
  DBMS_LOB.APPEND(Lcl_Json, F_GENERA_JSON_ULTIMA_MILLA);
  DBMS_LOB.APPEND(Lcl_Json, ',');
  --LLeno los estados de servicio
  DBMS_LOB.APPEND(Lcl_Json, F_GENERA_JSON_ESTADOS_SERVICIO);
  DBMS_LOB.APPEND(Lcl_Json, ',');
  --LLeno los tipos solicitud
  DBMS_LOB.APPEND(Lcl_Json, F_GENERA_JSON_TIPO_SOLICITUD);
  DBMS_LOB.APPEND(Lcl_Json, ',');
  --LLeno los tipos solicitud
  DBMS_LOB.APPEND(Lcl_Json, F_GENERA_JSON_MOTIVO_HAL);
  DBMS_LOB.APPEND(Lcl_Json, '},');
  DBMS_LOB.APPEND(Lcl_Json, '"status": "200",');
  DBMS_LOB.APPEND(Lcl_Json, '"message": "OK",');
  DBMS_LOB.APPEND(Lcl_Json, '"success": true,');
  DBMS_LOB.APPEND(Lcl_Json, '"token": false');
  DBMS_LOB.APPEND(Lcl_Json, '}');


  UPDATE DB_COMERCIAL.ADMI_CATALOGOS
     SET JSON_CATALOGO = Lcl_Json
  WHERE COD_EMPRESA = Pv_Empresa
    AND TIPO = 'CATALOGOEMPRESA';
  COMMIT;

    END P_GENERA_JSON_CATALOGOS;

  FUNCTION F_GENERA_JSON_PRODUCTOS(Pv_Empresa     IN  VARCHAR2,
                                   Pv_Descripcion IN  VARCHAR2,
                                   Pv_Error       IN  VARCHAR2)
  RETURN CLOB
    IS Lcl_Json CLOB;
    CURSOR C_Productos(Cv_Estado VARCHAR2, Cv_NombreTecnico VARCHAR2, Cv_EmpresaCod VARCHAR2) IS
        SELECT PRO.*, CASE  WHEN NVL(IMP.PORCENTAJE_IMPUESTO, 0) >0 THEN 'S' ELSE 'N' END AS PORCENTAJE_IMPUESTO
        FROM DB_COMERCIAL.ADMI_PRODUCTO PRO
        LEFT JOIN DB_COMERCIAL.INFO_PRODUCTO_IMPUESTO IMP
          ON PRO.ID_PRODUCTO = IMP.PRODUCTO_ID
         AND IMP.IMPUESTO_ID = 1
         AND IMP.ESTADO = 'Activo'
        WHERE PRO.ESTADO = Cv_Estado
        AND PRO.nombre_Tecnico <> Cv_NombreTecnico
        AND PRO.es_Concentrador <> 'SI'
        AND PRO.EMPRESA_COD = Cv_EmpresaCod
        ORDER BY PRO.DESCRIPCION_PRODUCTO ASC;

   CURSOR C_Caracteristica(Cn_IdProducto NUMBER, Cv_Estado VARCHAR2) IS
       SELECT PCA.ID_PRODUCTO_CARACTERISITICA, CAR.DESCRIPCION_CARACTERISTICA
       FROM DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA PCA
       LEFT JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CAR
         ON PCA.CARACTERISTICA_ID = CAR.ID_CARACTERISTICA
       WHERE PCA.PRODUCTO_ID = Cn_IdProducto
       AND PCA.ESTADO = Cv_Estado
       AND PCA.VISIBLE_COMERCIAL = 'SI';

  BEGIN
      Lcl_Json := '"productos": [ ';
      FOR I IN C_Productos('Activo', 'FINANCIERO', Pv_Empresa) LOOP
          DBMS_LOB.APPEND(Lcl_Json, '{');
          DBMS_LOB.APPEND(Lcl_Json, '"k": ' || I.ID_PRODUCTO || ',');
          DBMS_LOB.APPEND(Lcl_Json, '"v": "' || I.DESCRIPCION_PRODUCTO || '",');
          DBMS_LOB.APPEND(Lcl_Json, '"f": "' || REPLACE(I.FUNCION_PRECIO,'"','\"') || '",');
          DBMS_LOB.APPEND(Lcl_Json, '"t": "' || I.NOMBRE_TECNICO || '",');
          DBMS_LOB.APPEND(Lcl_Json, '"i": "' || 'S' || '",');
          DBMS_LOB.APPEND(Lcl_Json, '"g": "' || I.GRUPO || '",');
          --Inserto las caracteristicas
          DBMS_LOB.APPEND(Lcl_Json, '"c": [ ');
          FOR I1 IN C_Caracteristica(I.ID_PRODUCTO, I.ESTADO) LOOP
              DBMS_LOB.APPEND(Lcl_Json, '{');
              DBMS_LOB.APPEND(Lcl_Json, '"k": ' || I1.ID_PRODUCTO_CARACTERISITICA || ',');
              DBMS_LOB.APPEND(Lcl_Json, '"v": "' || I1.DESCRIPCION_CARACTERISTICA || '"');
              DBMS_LOB.APPEND(Lcl_Json, '},');
          END LOOP;
          Lcl_Json := SUBSTR(Lcl_Json, 0, LENGTH(Lcl_Json) - 1);
          DBMS_LOB.APPEND(Lcl_Json, ']');
          DBMS_LOB.APPEND(Lcl_Json, '},');
      END LOOP;
      Lcl_Json := SUBSTR(Lcl_Json, 0, LENGTH(Lcl_Json) - 1);
      DBMS_LOB.APPEND(Lcl_Json, ']');
      RETURN(Lcl_Json);
  END F_GENERA_JSON_PRODUCTOS;

  FUNCTION F_GENERA_JSON_COBERTURA(Fv_Empresa     IN  VARCHAR2,
                                   Fv_Descripcion IN  VARCHAR2,
                                   Fv_Error       IN  VARCHAR2)
  RETURN CLOB
    IS Lcl_Json CLOB;

    CURSOR C_Jurisdiccion(Cv_EmpresaCod VARCHAR2) IS
        SELECT jur.ID_JURISDICCION, jur.NOMBRE_JURISDICCION
        FROM DB_COMERCIAL.ADMI_JURISDICCION jur
        LEFT JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO ofi
          on jur.OFICINA_ID = ofi.ID_OFICINA
        WHERE ofi.EMPRESA_ID = Cv_EmpresaCod
        AND jur.estado in ('Activo','Modificado');

    CURSOR C_Cantones(Cn_Jurisdiccion NUMBER) IS
        SELECT can.ID_CANTON, can.NOMBRE_CANTON
        FROM DB_COMERCIAL.ADMI_CANTON can
        LEFT JOIN DB_COMERCIAL.ADMI_CANTON_JURISDICCION jur
          on can.id_canton = jur.canton_id
        WHERE jur.jurisdiccion_id = Cn_Jurisdiccion
          AND jur.ESTADO = 'Activo';

    CURSOR C_Parroquias(Cn_Canton NUMBER) IS
        SELECT ID_PARROQUIA, NOMBRE_PARROQUIA
        FROM DB_COMERCIAL.ADMI_PARROQUIA
        WHERE CANTON_ID = Cn_Canton
          AND ESTADO = 'Activo'
        ORDER BY NOMBRE_PARROQUIA ASC;

    CURSOR C_Sectores(Cn_Parroquia NUMBER, Cv_EmpresaCod VARCHAR2) IS
        SELECT ID_SECTOR, NOMBRE_SECTOR
        FROM  DB_GENERAL.ADMI_SECTOR
        WHERE PARROQUIA_ID = Cn_Parroquia
          AND ESTADO = 'Activo'
          and EMPRESA_COD = Cv_EmpresaCod;


  BEGIN
      Lcl_Json := '"puntoCobertura": [ ';
      FOR I IN C_Jurisdiccion(Fv_Empresa) LOOP
          DBMS_LOB.APPEND(Lcl_Json, '{');
          DBMS_LOB.APPEND(Lcl_Json, '"k": ' || I.ID_JURISDICCION || ',');
          DBMS_LOB.APPEND(Lcl_Json, '"v": "' || I.NOMBRE_JURISDICCION || '",');
          --Inserto los cantones
          DBMS_LOB.APPEND(Lcl_Json, '"items": [ ');
          FOR I1 IN C_Cantones(I.ID_JURISDICCION) LOOP
              DBMS_LOB.APPEND(Lcl_Json, '{');
              DBMS_LOB.APPEND(Lcl_Json, '"k": ' || I1.ID_CANTON || ',');
              DBMS_LOB.APPEND(Lcl_Json, '"v": "' || I1.NOMBRE_CANTON || '",');
              DBMS_LOB.APPEND(Lcl_Json, '"items": [ ');
              FOR I2 IN C_Parroquias(I1.ID_CANTON) LOOP
                  DBMS_LOB.APPEND(Lcl_Json, '{');
                  DBMS_LOB.APPEND(Lcl_Json, '"k": ' || I2.ID_PARROQUIA || ',');
                  DBMS_LOB.APPEND(Lcl_Json, '"v": "' || I2.NOMBRE_PARROQUIA || '",');
                  DBMS_LOB.APPEND(Lcl_Json, '"items": [ ');
                  FOR I3 IN C_Sectores(I2.ID_PARROQUIA, Fv_Empresa) LOOP
                      DBMS_LOB.APPEND(Lcl_Json, '{');
                      DBMS_LOB.APPEND(Lcl_Json, '"k": ' || I3.ID_SECTOR || ',');
                      DBMS_LOB.APPEND(Lcl_Json, '"v": "' || I3.NOMBRE_SECTOR || '"');
                      DBMS_LOB.APPEND(Lcl_Json, '},');
                  END LOOP;
                  Lcl_Json := SUBSTR(Lcl_Json, 0, LENGTH(Lcl_Json) - 1);
                  DBMS_LOB.APPEND(Lcl_Json, ']');
                  DBMS_LOB.APPEND(Lcl_Json, '},');
              END LOOP;
              Lcl_Json := SUBSTR(Lcl_Json, 0, LENGTH(Lcl_Json) - 1);
              DBMS_LOB.APPEND(Lcl_Json, ']');
              DBMS_LOB.APPEND(Lcl_Json, '},');
          END LOOP;
          Lcl_Json := SUBSTR(Lcl_Json, 0, LENGTH(Lcl_Json) - 1);
          DBMS_LOB.APPEND(Lcl_Json, ']');
          DBMS_LOB.APPEND(Lcl_Json, '},');
      END LOOP;
      Lcl_Json := SUBSTR(Lcl_Json, 0, LENGTH(Lcl_Json) - 1);
      DBMS_LOB.APPEND(Lcl_Json, ']');
      RETURN(Lcl_Json);
  END F_GENERA_JSON_COBERTURA;

  FUNCTION F_GENERA_JSON_CANALES(Fv_Empresa     IN  VARCHAR2,
                                 Fv_Descripcion IN  VARCHAR2,
                                 Fv_Error       IN  VARCHAR2)
  RETURN CLOB
      IS Lcl_Json CLOB;

    CURSOR C_Canales(Cv_Empresa VARCHAR2, Cv_Nombre VARCHAR2, Cv_Modulo VARCHAR2, Cv_Valor VARCHAR2)
    IS
      SELECT    DET.VALOR1 AS VALOR1, DET.VALOR2 AS VALOR2, DETH.VALOR1 AS VALOR3, DETH.VALOR2 AS VALOR4
      FROM      DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      LEFT JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET  ON  CAB.ID_PARAMETRO = DET.PARAMETRO_ID
      LEFT JOIN DB_GENERAL.ADMI_PARAMETRO_DET DETH ON  DETH.VALOR3      = DET.VALOR1
      WHERE CAB.NOMBRE_PARAMETRO = Cv_Nombre
      AND CAB.MODULO             = Cv_Modulo
      AND DET.EMPRESA_COD        = Cv_Empresa
      AND DET.VALOR3             = Cv_Valor
      AND CAB.ESTADO             = 'Activo'
      AND DET.ESTADO             = 'Activo'
      ORDER BY DET.VALOR1 ASC ,DET.VALOR2 ASC ;

  Lv_Canal VARCHAR2(25) := ' ';

  BEGIN
      Lcl_Json := '"canales": [ ';
      FOR Lr_Canal IN C_Canales(Fv_Empresa, 'CANALES_PUNTO_VENTA', 'COMERCIAL', 'CANAL') LOOP

          IF Lv_Canal <> Lr_Canal.VALOR1 THEN
             IF Lv_Canal <> ' ' THEN
                Lcl_Json := SUBSTR(Lcl_Json, 0, LENGTH(Lcl_Json) - 1);
                DBMS_LOB.APPEND(Lcl_Json, ']');
                DBMS_LOB.APPEND(Lcl_Json, '},');
             END IF;
            --
            DBMS_LOB.APPEND(Lcl_Json, '{');
            DBMS_LOB.APPEND(Lcl_Json, '"k": "' || Lr_Canal.VALOR1 || '",');
            DBMS_LOB.APPEND(Lcl_Json, '"v": "' || Lr_Canal.VALOR2 || '",');
            --Inserto los cantones
            DBMS_LOB.APPEND(Lcl_Json, '"items": [ ');

            DBMS_LOB.APPEND(Lcl_Json, '{');
            DBMS_LOB.APPEND(Lcl_Json, '"k": "' || Lr_Canal.VALOR3 || '",');
            DBMS_LOB.APPEND(Lcl_Json, '"v": "' || NVL(F_GET_VARCHAR_CLEAN(TRIM(
                                                  REPLACE(
                                                  REPLACE(
                                                  REPLACE(
                                                    Lr_Canal.VALOR4, Chr(9), ' '), Chr(10), ' '),
                                                    Chr(13), ' '))), '')|| '"');
            DBMS_LOB.APPEND(Lcl_Json, '},');

            Lv_Canal := Lr_Canal.VALOR1;
            --
          ELSE
            --
            DBMS_LOB.APPEND(Lcl_Json, '{');
            DBMS_LOB.APPEND(Lcl_Json, '"k": "' || Lr_Canal.VALOR3 || '",');
            DBMS_LOB.APPEND(Lcl_Json, '"v": "' || NVL(F_GET_VARCHAR_CLEAN(TRIM(
                                                  REPLACE(
                                                  REPLACE(
                                                  REPLACE(
                                                    Lr_Canal.VALOR4, Chr(9), ' '), Chr(10), ' '),
                                                    Chr(13), ' '))), '')|| '"');
            DBMS_LOB.APPEND(Lcl_Json, '},');
            --
          END IF;
      END LOOP;

      Lcl_Json := SUBSTR(Lcl_Json, 0, LENGTH(Lcl_Json) - 1);
      DBMS_LOB.APPEND(Lcl_Json, ']');
      DBMS_LOB.APPEND(Lcl_Json, '},');

      Lcl_Json := SUBSTR(Lcl_Json, 0, LENGTH(Lcl_Json) - 1);
      DBMS_LOB.APPEND(Lcl_Json, ']');

      RETURN(Lcl_Json);

 END F_GENERA_JSON_CANALES;

  FUNCTION F_GENERA_JSON_TIPO_CUENTA(Fv_Empresa     IN  VARCHAR2,
                                     Fv_Descripcion IN  VARCHAR2,
                                     Fv_Error       IN  VARCHAR2)
  RETURN CLOB
      IS Lcl_Json CLOB;

    Ln_Banco NUMBER := 0;

    CURSOR C_TipoCuenta
    IS
      SELECT TIPO.ID_TIPO_CUENTA       AS ID_TIPO_CUENTA,
             TIPO.DESCRIPCION_CUENTA   AS DESCRIPCION_CUENTA,
             ABTC.ID_BANCO_TIPO_CUENTA AS ID_BANCO_TIPO_CUENTA,
             BAN.ID_BANCO              AS ID_BANCO,
             BAN.DESCRIPCION_BANCO     AS DESCRIPCION_BANCO
      FROM  DB_GENERAL.ADMI_TIPO_CUENTA  TIPO
      LEFT JOIN DB_GENERAL.ADMI_BANCO_TIPO_CUENTA ABTC ON ABTC.TIPO_CUENTA_ID = TIPO.ID_TIPO_CUENTA
      LEFT JOIN DB_GENERAL.ADMI_BANCO             BAN  ON ABTC.BANCO_ID       = BAN.ID_BANCO
      WHERE (   (ABTC.ES_TARJETA <> 'S' AND BAN.GENERA_DEBITO_BANCARIO = 'S')
             OR  ABTC.ES_TARJETA =  'S' AND ABTC.ESTADO IN ('Activo', 'Activo-debitos'))
     ORDER BY TIPO.ID_TIPO_CUENTA ASC, BAN.DESCRIPCION_BANCO  ASC;
  BEGIN
      Lcl_Json := '"tiposCuenta": [ ';
      FOR I IN C_TipoCuenta() LOOP
        IF Ln_Banco <> I.ID_TIPO_CUENTA THEN
             IF Ln_Banco <> 0 THEN
                Lcl_Json := SUBSTR(Lcl_Json, 0, LENGTH(Lcl_Json) - 1);
                DBMS_LOB.APPEND(Lcl_Json, ']');
                DBMS_LOB.APPEND(Lcl_Json, '},');
             END IF;

          DBMS_LOB.APPEND(Lcl_Json, '{');
          DBMS_LOB.APPEND(Lcl_Json, '"k": ' || I.ID_TIPO_CUENTA || ',');
          DBMS_LOB.APPEND(Lcl_Json, '"v": "' || I.DESCRIPCION_CUENTA || '",');
          --Inserto los cantones
          DBMS_LOB.APPEND(Lcl_Json, '"items": [ ');
          DBMS_LOB.APPEND(Lcl_Json, '{');
          DBMS_LOB.APPEND(Lcl_Json, '"k": "' || I.ID_BANCO_TIPO_CUENTA || '",');
          DBMS_LOB.APPEND(Lcl_Json, '"v": "' || I.DESCRIPCION_BANCO || '"');
          DBMS_LOB.APPEND(Lcl_Json, '},');

          Ln_Banco := I.ID_TIPO_CUENTA;

          ELSE
            --
            DBMS_LOB.APPEND(Lcl_Json, '{');
            DBMS_LOB.APPEND(Lcl_Json, '"k": "' || I.ID_BANCO_TIPO_CUENTA || '",');
            DBMS_LOB.APPEND(Lcl_Json, '"v": "' || I.DESCRIPCION_BANCO || '"');
            DBMS_LOB.APPEND(Lcl_Json, '},');
            --
          END IF;
      END LOOP;
      Lcl_Json := SUBSTR(Lcl_Json, 0, LENGTH(Lcl_Json) - 1);
      DBMS_LOB.APPEND(Lcl_Json, ']');
      DBMS_LOB.APPEND(Lcl_Json, '},');

      Lcl_Json := SUBSTR(Lcl_Json, 0, LENGTH(Lcl_Json) - 1);
      DBMS_LOB.APPEND(Lcl_Json, ']');
      RETURN(Lcl_Json);

 END F_GENERA_JSON_TIPO_CUENTA;

 FUNCTION F_GENERA_JSON_TIPO_NEGOCIO(Fv_Empresa     IN  VARCHAR2,
                                     Fv_Descripcion IN  VARCHAR2,
                                     Fv_Error       IN  VARCHAR2)
 RETURN CLOB
      IS Lcl_Json CLOB;

    CURSOR C_TIPO_NEGOCIO(Cv_Empresa VARCHAR2)
      IS
        SELECT ID_TIPO_NEGOCIO, NOMBRE_TIPO_NEGOCIO
        FROM  ADMI_TIPO_NEGOCIO
        WHERE EMPRESA_COD = Cv_Empresa
        AND   ESTADO      = 'Activo';

  BEGIN
      Lcl_Json := '"tipoNegocio": [ ';
      FOR I IN C_TIPO_NEGOCIO(Fv_Empresa) LOOP
          DBMS_LOB.APPEND(Lcl_Json, '{');
          DBMS_LOB.APPEND(Lcl_Json, '"k": "' || I.ID_TIPO_NEGOCIO || '",');
          DBMS_LOB.APPEND(Lcl_Json, '"v": "' || I.NOMBRE_TIPO_NEGOCIO || '"');
          DBMS_LOB.APPEND(Lcl_Json, '},');
      END LOOP;
      Lcl_Json := SUBSTR(Lcl_Json, 0, LENGTH(Lcl_Json) - 1);
      DBMS_LOB.APPEND(Lcl_Json, ']');
      RETURN(Lcl_Json);

 END F_GENERA_JSON_TIPO_NEGOCIO;

 FUNCTION F_GENERA_JSON_TIPO_CONTRATO(Fv_Empresa     IN  VARCHAR2,
                                      Fv_Descripcion IN  VARCHAR2,
                                      Fv_Error       IN  VARCHAR2)
 RETURN CLOB
      IS Lcl_Json CLOB;

    CURSOR C_TipoContrato(Cv_Empresa VARCHAR2)
    IS
      SELECT ID_TIPO_CONTRATO, DESCRIPCION_TIPO_CONTRATO
      FROM ADMI_TIPO_CONTRATO
      WHERE EMPRESA_COD = Cv_Empresa
      AND   ESTADO      = 'Activo';

  BEGIN
      Lcl_Json := '"tipoContrato": [ ';
      FOR I IN C_TipoContrato(Fv_Empresa) LOOP
          DBMS_LOB.APPEND(Lcl_Json, '{');
          DBMS_LOB.APPEND(Lcl_Json, '"k": "' || I.ID_TIPO_CONTRATO || '",');
          DBMS_LOB.APPEND(Lcl_Json, '"v": "' || I.DESCRIPCION_TIPO_CONTRATO || '"');
          DBMS_LOB.APPEND(Lcl_Json, '},');
      END LOOP;
      Lcl_Json := SUBSTR(Lcl_Json, 0, LENGTH(Lcl_Json) - 1);
      DBMS_LOB.APPEND(Lcl_Json, ']');
      RETURN(Lcl_Json);

 END F_GENERA_JSON_TIPO_CONTRATO;

 FUNCTION F_GENERA_JSON_DOC_OBLIGATORIOS(Fv_Empresa     IN  VARCHAR2,
                                         Fv_Descripcion IN  VARCHAR2,
                                         Fv_Error       IN  VARCHAR2)
 RETURN CLOB
      IS Lcl_Json CLOB;

    CURSOR C_DOC_OBLIGATORIO(Cv_Empresa VARCHAR2, Cv_Tipo VARCHAR2)
      IS
        SELECT DET.ID_PARAMETRO_DET, DET.DESCRIPCION, DET.VALOR1 AS TIPO_TRIBUTARIO, DET.VALOR3
        FROM   DB_GENERAL.ADMI_PARAMETRO_DET DET
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB CAB
          ON DET.PARAMETRO_ID = CAB.ID_PARAMETRO
        WHERE CAB.NOMBRE_PARAMETRO = 'DOCUMENTOS_OBLIGATORIO'
          AND DET.VALOR1           = Cv_Tipo
          AND DET.VALOR2           = Cv_Empresa
          AND CAB.ESTADO           = 'Activo'
          AND DET.ESTADO           = 'Activo'
        ORDER BY TIPO_TRIBUTARIO ASC, DET.DESCRIPCION ASC;
 BEGIN
     
    apex_json.initialize_clob_output;
      
    apex_json.open_array('documentosObligatorio');
  
    apex_json.open_object();
    apex_json.write('k', 'NAT');
    apex_json.write('v', 'PERSONA NATURAL'); 
    apex_json.open_array('items');
    
    FOR I IN C_DOC_OBLIGATORIO(Fv_Empresa, 'NAT') LOOP
        apex_json.open_object();
        apex_json.write('k', I.VALOR3);
        apex_json.write('v', I.DESCRIPCION);
        apex_json.close_object();
    END LOOP;
    
    apex_json.close_array();
    apex_json.close_object();
  
    apex_json.open_object();
    apex_json.write('k', 'JUR');
    apex_json.write('v', 'PERSONA JURIDICA'); 
    apex_json.open_array('items');
    
    FOR I IN C_DOC_OBLIGATORIO(Fv_Empresa, 'JUR') LOOP
        apex_json.open_object();
        apex_json.write('k', I.VALOR3);
        apex_json.write('v', I.DESCRIPCION);
        apex_json.close_object();
    END LOOP;

    apex_json.close_array();
    apex_json.close_object();

    apex_json.close_array();
    
    Lcl_Json := apex_json.get_clob_output;
    apex_json.free_output;

    RETURN(Lcl_Json);

 END F_GENERA_JSON_DOC_OBLIGATORIOS;


 FUNCTION F_GENERA_JSON_ELEMENTOS (Fv_Empresa  IN  VARCHAR2)
 RETURN CLOB
      IS Lcl_Json CLOB;

    CURSOR C_GetElementos(Cv_Empresa VARCHAR2, Cv_TipoElemento VARCHAR2)
    IS
      SELECT ID_ELEMENTO, NOMBRE_ELEMENTO, ID_CANTON, NOMBRE_CANTON
      FROM   DB_INFRAESTRUCTURA.VISTA_ELEMENTOS
      WHERE  EMPRESA_COD          = Cv_Empresa
      AND    NOMBRE_TIPO_ELEMENTO = Cv_TipoElemento;

    Lv_TipoElemento  VARCHAR2(20) := 'EDIFICACION';
    Lv_Empresa       VARCHAR2(20) := '';
   
  BEGIN
      Lcl_Json := '"puntoEdificio": [ ';

      Lv_Empresa:=Fv_Empresa;
     
      IF Lv_Empresa='33' 
      THEN
      Lv_Empresa:='18';
      END IF;

      FOR I IN C_GetElementos(Lv_Empresa,Lv_TipoElemento) LOOP
          DBMS_LOB.APPEND(Lcl_Json, '{');
          DBMS_LOB.APPEND(Lcl_Json, '"k": "' || I.ID_ELEMENTO || '",');
          DBMS_LOB.APPEND(Lcl_Json, '"v": "' || NVL(F_GET_VARCHAR_CLEAN(TRIM(
                                                REPLACE(
                                                REPLACE(
                                                REPLACE(
                                                  I.NOMBRE_ELEMENTO, Chr(9), ' '), Chr(10), ' '),
                                                  Chr(13), ' '))), '')|| '",');
          DBMS_LOB.APPEND(Lcl_Json, '"items": [ ');
          DBMS_LOB.APPEND(Lcl_Json, '{');
          DBMS_LOB.APPEND(Lcl_Json, '"k": "' || I.ID_CANTON || '",');
          DBMS_LOB.APPEND(Lcl_Json, '"v": "' || NVL(F_GET_VARCHAR_CLEAN(TRIM(
                                                REPLACE(
                                                REPLACE(
                                                REPLACE(
                                                  I.NOMBRE_CANTON, Chr(9), ' '), Chr(10), ' '),
                                                  Chr(13), ' '))), '')|| '"');
          DBMS_LOB.APPEND(Lcl_Json, '}');
          DBMS_LOB.APPEND(Lcl_Json, ']');
          DBMS_LOB.APPEND(Lcl_Json, '},');
      END LOOP;
      Lcl_Json := SUBSTR(Lcl_Json, 0, LENGTH(Lcl_Json) - 1);
      DBMS_LOB.APPEND(Lcl_Json, ']');
      RETURN(Lcl_Json);
  EXCEPTION
  WHEN OTHERS THEN

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'TelcosMobile',
                                          'CMKG_CATALOGOS_MOBILE.F_GENERA_JSON_ELEMENTOS',
                                          'Error al obtener listado de elemntos' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    RETURN NULL;

 END F_GENERA_JSON_ELEMENTOS;

 FUNCTION F_GET_VARCHAR_CLEAN(
         Fv_Cadena IN VARCHAR2)
     RETURN VARCHAR2
  IS
  BEGIN
      RETURN TRIM(
              REPLACE(
              REPLACE(
              REPLACE(
              REPLACE(
              TRANSLATE(
              REGEXP_REPLACE(
              REGEXP_REPLACE(Fv_Cadena,'^[^A-Z|^a-z|^0-9]|[?|¿|<|>|/|;|,|.|%|"]|[)]+$', ' ')
              ,'[^A-Za-z0-9ÁÉÍÓÚáéíóúÑñ&()-_ ]' ,' ')
              ,'ÁÉÍÓÚÑ,áéíóúñ', 'AEIOUN aeioun')
              , Chr(9), ' ')
              , Chr(10), ' ')
              , Chr(13), ' ')
              , Chr(59), ' '));
      --

  END F_GET_VARCHAR_CLEAN;


  FUNCTION F_GENERA_JSON_PRODUCTOS_DISP(Pv_Empresa     IN  VARCHAR2,
                                        Pv_Descripcion IN  VARCHAR2,
                                        Pv_Error       IN  VARCHAR2)
  RETURN CLOB
    IS Lcl_Json CLOB;
    CURSOR C_Productos(Cv_Estado VARCHAR2, Cv_NombreTecnico VARCHAR2, Cv_EmpresaCod VARCHAR2) IS
        SELECT
            PRO.ID_PRODUCTO,
            PRO.EMPRESA_COD,
            PRO.CODIGO_PRODUCTO,
            DET.DESCRIPCION AS DESCRIPCION_PRODUCTO,
            PRO.FUNCION_COSTO,
            PRO.INSTALACION,
            PRO.ESTADO,
            PRO.FE_CREACION,
            PRO.USR_CREACION,
            PRO.IP_CREACION,
            PRO.CTA_CONTABLE_PROD,
            PRO.CTA_CONTABLE_PROD_NC,
            PRO.ES_PREFERENCIA,
            PRO.ES_ENLACE,
            PRO.REQUIERE_PLANIFICACION,
            PRO.REQUIERE_INFO_TECNICA,
            PRO.NOMBRE_TECNICO,
            PRO.CTA_CONTABLE_DESC,
            PRO.TIPO,
            PRO.ES_CONCENTRADOR,
            PRO.FUNCION_PRECIO,
            PRO.SOPORTE_MASIVO,
            PRO.ESTADO_INICIAL,
            PRO.GRUPO,
            PRO.COMISION_VENTA,
            PRO.COMISION_MANTENIMIENTO,
            PRO.USR_GERENTE,
            PRO.CLASIFICACION,
            PRO.REQUIERE_COMISIONAR,
            PRO.SUBGRUPO,
            PRO.LINEA_NEGOCIO,
            DET.VALOR4 AS VISIBLE,
            DET.VALOR5 AS EDITABLE,
            DET.VALOR6 AS POR_DEFECTO,
            CASE
                    WHEN NVL(IMP.PORCENTAJE_IMPUESTO, 0) > 0 THEN 'S' ELSE 'N'
            END AS PORCENTAJE_IMPUESTO
        FROM
            DB_COMERCIAL.ADMI_PRODUCTO PRO
        INNER JOIN DB_COMERCIAL.INFO_PRODUCTO_IMPUESTO IMP ON
            PRO.ID_PRODUCTO = IMP.PRODUCTO_ID
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET ON
            DET.VALOR1 = PRO.CODIGO_PRODUCTO
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB CAB ON
            DET.PARAMETRO_ID = CAB.ID_PARAMETRO
        WHERE
            CAB.NOMBRE_PARAMETRO = 'PRODUCTOS_TM_COMERCIAL'
            AND DET.ESTADO = Cv_Estado
            AND DET.EMPRESA_COD = Cv_EmpresaCod
            AND IMP.IMPUESTO_ID = 1
            AND IMP.ESTADO = Cv_Estado
            AND PRO.ESTADO = Cv_Estado
            AND PRO.NOMBRE_TECNICO <> Cv_NombreTecnico
            AND PRO.ES_CONCENTRADOR <> 'SI'
            AND PRO.EMPRESA_COD = Cv_EmpresaCod
        ORDER BY
            DET.DESCRIPCION ASC;

    CURSOR C_Caracteristica(Cn_IdProducto NUMBER, Cv_Estado VARCHAR2) IS
        SELECT
        APROC.ID_PRODUCTO_CARACTERISITICA AS ID_PRODUCTO_CARACTERISTICA,
        AC.DESCRIPCION_CARACTERISTICA AS DESCRIPCION_CARACTERISTICA,
        AP.CODIGO_PRODUCTO AS CODIGO_PRODUCTO,
        'NO' AS VISIBLE,
        'NO' AS EDITABLE,
        NULL AS OPCIONES,
        NULL AS POR_DEFECTO,
        NULL AS TIPO_ENTRADA
            FROM DB_COMERCIAL.ADMI_PRODUCTO AP
            INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APROC ON AP.ID_PRODUCTO = APROC.PRODUCTO_ID
            INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA AC ON AC.ID_CARACTERISTICA = APROC.CARACTERISTICA_ID
            WHERE AP.ID_PRODUCTO = Cn_IdProducto
                AND AP.ESTADO = Cv_Estado
               AND APROC.VISIBLE_COMERCIAL = 'SI'
               AND APROC.ESTADO = Cv_Estado
               AND AC.ESTADO = Cv_Estado
               AND AP.EMPRESA_COD = '18'
               AND APROC.ID_PRODUCTO_CARACTERISITICA NOT IN
               (
                    SELECT TO_NUMBER(TRIM(APD.VALOR2))
                        FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                            INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ON APC.ID_PARAMETRO = APD.PARAMETRO_ID
                            WHERE APD.ESTADO = Cv_Estado
                                AND APC.ESTADO = Cv_Estado
                                AND APD.EMPRESA_COD = '18'
                                AND APC.NOMBRE_PARAMETRO = 'CARACTERISTICAS_PROD_ADICIONALES_TM_COMERCIAL'
               )
               AND AC.ID_CARACTERISTICA NOT IN
               (
                    SELECT TO_NUMBER(TRIM(APD2.VALOR1))
                        FROM DB_GENERAL.ADMI_PARAMETRO_DET APD2
                            INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC2 ON APC2.ID_PARAMETRO = APD2.PARAMETRO_ID
                            WHERE APD2.ESTADO = Cv_Estado
                                AND APC2.ESTADO = Cv_Estado
                                AND APD2.EMPRESA_COD = '18'
                                AND APC2.NOMBRE_PARAMETRO = 'CARACTERISTICAS_IGNORADAS_TM_COMERCIAL'
               )
        UNION
        SELECT
           APROC.ID_PRODUCTO_CARACTERISITICA AS ID_PRODUCTO_CARACTERISTICA,
           AC.DESCRIPCION_CARACTERISTICA ,
           APD.VALOR1 AS CODIGO_PRODUCTO,
           APD.VALOR3 AS VISIBLE,
           APD.VALOR4 AS EDITABLE,
           APD.VALOR5 AS OPCIONES,
           APD.VALOR6 AS POR_DEFECTO,
           APD.VALOR7 AS TIPO_ENTRADA
        FROM DB_COMERCIAL.ADMI_PRODUCTO AP
        INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APROC ON AP.ID_PRODUCTO = APROC.PRODUCTO_ID
        INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA AC ON AC.ID_CARACTERISTICA = APROC.CARACTERISTICA_ID
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD ON TRIM(APD.VALOR1) = TRIM(AP.CODIGO_PRODUCTO)
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ON APC.ID_PARAMETRO = APD.PARAMETRO_ID
           WHERE AP.ID_PRODUCTO = Cn_IdProducto
           AND TO_NUMBER(TRIM(APD.VALOR2)) = APROC.ID_PRODUCTO_CARACTERISITICA
           AND AP.ESTADO = Cv_Estado
           AND APROC.VISIBLE_COMERCIAL = 'SI'
           AND APROC.ESTADO = Cv_Estado
           AND AC.ESTADO = Cv_Estado
           AND APD.ESTADO = Cv_Estado
           AND APC.NOMBRE_PARAMETRO  = 'CARACTERISTICAS_PROD_ADICIONALES_TM_COMERCIAL'
           AND APC.ESTADO = Cv_Estado
           AND AP.EMPRESA_COD = APD.EMPRESA_COD
           ORDER BY ID_PRODUCTO_CARACTERISTICA;

    CURSOR C_GetPromocionesAplicables(Cv_NombreParametro VARCHAR2, Cv_Modulo VARCHAR2, Cv_Estado VARCHAR2, Cv_TipoProducto VARCHAR2, Cv_EmpresaCod VARCHAR2) IS
        SELECT
            DET.DESCRIPCION AS DESCRIPCION,
            DET.VALOR1 AS ID_PRODUCTOS,
            DET.VALOR2 AS OPERACION,
            DET.VALOR4 AS DESCRIPCION_MOVIL,
            DET.VALOR4 AS DESCRIPCION_MOVIL_USUARIO
        FROM
            DB_GENERAL.ADMI_PARAMETRO_CAB CAB
        INNER JOIN
            DB_GENERAL.ADMI_PARAMETRO_DET DET ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID
        AND CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
        AND CAB.MODULO = Cv_Modulo
        AND CAB.ESTADO = Cv_Estado
        AND DET.ESTADO = Cv_Estado
        AND DET.VALOR3 = Cv_TipoProducto
        AND DET.EMPRESA_COD = Cv_EmpresaCod
        ORDER BY DET.VALOR7 ASC;

    -- Genero una tabla de los indices de los productos adicionales y busco el indice del producto actual
    CURSOR C_FindIdProducto(Cv_Id_productos VARCHAR2, Cv_Actual_Id VARCHAR2) IS
        SELECT NVL(t.TOKEN, '')
        FROM (
                SELECT REGEXP_SUBSTR(TRIM(Cv_Id_productos), '[^;]+', 1, LEVEL) TOKEN
                FROM DUAL CONNECT BY REGEXP_SUBSTR(TRIM(Cv_Id_productos), '[^;]+', 1, LEVEL) IS NOT NULL
             ) T
        WHERE T.TOKEN = Cv_Actual_Id;

    TYPE T_Array_Promo IS TABLE OF C_GetPromocionesAplicables%ROWTYPE INDEX BY BINARY_INTEGER;

    Lt_tipos_promo T_Array_Promo;
    Lv_Token VARCHAR2(4000);
    Ln_Indx NUMBER;

    BEGIN

      OPEN C_GetPromocionesAplicables('PROMOCIONES_APLICABLES_TM_COMERCIAL', 'COMERCIAL', 'Activo', 'PROD_SERV_ADICIONAL', '18');
        FETCH C_GetPromocionesAplicables BULK COLLECT INTO Lt_tipos_promo LIMIT 100000;
      CLOSE C_GetPromocionesAplicables;

      apex_json.initialize_clob_output;

      apex_json.open_array('productosDisponibles');

      FOR I IN C_Productos('Activo', 'FINANCIERO', Pv_Empresa) LOOP

          --Inserto las caracteristicas

            apex_json.open_object();
            apex_json.write('k', I.ID_PRODUCTO);
            apex_json.write('v', I.DESCRIPCION_PRODUCTO);
            apex_json.write('f', REGEXP_REPLACE(I.FUNCION_PRECIO,'\s+',' '));
            apex_json.write('t', I.NOMBRE_TECNICO);
            apex_json.write('i', 'S');
            apex_json.write('g', I.GRUPO);

            apex_json.open_array('c');

            FOR I1 IN C_Caracteristica(I.ID_PRODUCTO, I.ESTADO) LOOP
                apex_json.open_object();
                apex_json.write('k', I1.ID_PRODUCTO_CARACTERISTICA);
                apex_json.write('v', I1.DESCRIPCION_CARACTERISTICA);
                apex_json.open_array('items');

                apex_json.open_object();
                apex_json.write('k', 'VISIBLE');
                apex_json.write('v',  I1.VISIBLE);
                apex_json.close_object();

                apex_json.open_object();
                apex_json.write('k', 'EDITABLE');
                apex_json.write('v', I1.EDITABLE);
                apex_json.close_object();

                apex_json.open_object();
                apex_json.write('k', 'TIPO_ENTRADA');
                apex_json.write('v', I1.TIPO_ENTRADA);
                apex_json.close_object();

                apex_json.open_object();
                apex_json.write('k', 'POR_DEFECTO');
                apex_json.write('v', I1.POR_DEFECTO);
                apex_json.close_object();

                IF I1.OPCIONES IS NOT NULL AND LENGTH(TRIM(I1.OPCIONES)) > 0 THEN
                    apex_json.open_object();
                    apex_json.write('k', 'OPCIONES');
                    apex_json.open_array('items');

                    FOR I2 IN (SELECT REGEXP_SUBSTR(TRIM(I1.OPCIONES), '[^;]+', 1, LEVEL) OPCION
                        FROM DUAL CONNECT BY REGEXP_SUBSTR(TRIM(I1.OPCIONES), '[^;]+', 1, LEVEL) IS NOT NULL) LOOP
                       apex_json.open_object();
                       apex_json.write('k', I2.OPCION);
                       apex_json.write('v', I2.OPCION);
                       apex_json.close_object();
                    END LOOP;

                    apex_json.close_array();
                    apex_json.close_object();
                END IF;
                apex_json.close_array();
                apex_json.close_object();
            END LOOP;

            apex_json.close_array();

            apex_json.open_array('pr');
            
            Ln_Indx := Lt_tipos_promo.FIRST;

            WHILE(Ln_Indx <= Lt_tipos_promo.LAST) LOOP

                OPEN C_FindIdProducto(Lt_tipos_promo(Ln_Indx).ID_PRODUCTOS, I.ID_PRODUCTO);
                    FETCH C_FindIdProducto INTO Lv_Token;
                CLOSE C_FindIdProducto;

                IF Lt_tipos_promo(Ln_Indx).OPERACION = 'INCLUIR_SOLO' THEN
                    apex_json.open_object();
                    apex_json.write('k', Lt_tipos_promo(Ln_Indx).DESCRIPCION_MOVIL);
                    apex_json.write('w', Lt_tipos_promo(Ln_Indx).DESCRIPCION);

                    IF Lv_Token IS NOT NULL AND LENGTH(Lv_Token) > 0 THEN
                        apex_json.write('v', '1');
                    ELSE
                        apex_json.write('v', '0');
                    END IF;

                    apex_json.close_object();

                ELSIF Lt_tipos_promo(Ln_Indx).OPERACION = 'EXCLUIR_SOLO' THEN
                    apex_json.open_object();
                    apex_json.write('k', Lt_tipos_promo(Ln_Indx).DESCRIPCION_MOVIL);
                    apex_json.write('w', Lt_tipos_promo(Ln_Indx).DESCRIPCION);

                    IF Lv_Token IS NOT NULL AND LENGTH(Lv_Token) > 0 THEN
                        apex_json.write('v', '0');
                    ELSE
                        apex_json.write('v', '1');
                    END IF;

                    apex_json.close_object();
                ELSIF Lt_tipos_promo(Ln_Indx).OPERACION IS NULL OR LENGTH(Lt_tipos_promo(Ln_Indx).OPERACION) = 0 THEN
                    apex_json.open_object();
                    apex_json.write('k', Lt_tipos_promo(Ln_Indx).DESCRIPCION_MOVIL);
                    apex_json.write('w', Lt_tipos_promo(Ln_Indx).DESCRIPCION);
                    apex_json.write('v', '1');
                    apex_json.close_object();
                ELSE
                    apex_json.open_object();
                    apex_json.write('k', Lt_tipos_promo(Ln_Indx).DESCRIPCION_MOVIL);
                    apex_json.write('w', Lt_tipos_promo(Ln_Indx).DESCRIPCION);
                    apex_json.write('v', '0');
                    apex_json.close_object();
                END IF;
                Ln_Indx := Ln_Indx + 1;
            END LOOP;

            apex_json.close_array();
            apex_json.close_object();
            

      END LOOP;

      apex_json.close_array();
      Lcl_Json := apex_json.get_clob_output;
      apex_json.free_output;

      RETURN(Lcl_Json);
  END F_GENERA_JSON_PRODUCTOS_DISP;

  FUNCTION F_GENERA_JSON_PARAMETROS(Pv_Empresa     IN  VARCHAR2,
                                    Pv_Descripcion IN  VARCHAR2,
                                    Pv_Error       IN  VARCHAR2)
  RETURN CLOB
    IS Lcl_Json CLOB;

  BEGIN
      Lcl_Json := '"parametrosEmpresa": [{"k":"fechaLimitePuntoWeb", "v" : null}, {"k":"procesarPuntoWeb", "v": "S"}]';
      RETURN(Lcl_Json);
  END F_GENERA_JSON_PARAMETROS;

  FUNCTION F_GENERA_JSON_PROMOCIONES(Pv_Empresa     IN  VARCHAR2,
                                     Pv_Descripcion IN  VARCHAR2,
                                     Pv_Error       IN  VARCHAR2)
    RETURN CLOB IS

    CURSOR C_GetTiposProducto(Cv_NombreParametro VARCHAR2, Cv_Modulo VARCHAR2, Cv_Estado VARCHAR2) IS
        SELECT
            DISTINCT DET.VALOR3 AS TIPO_PRODUCTO,
            DET.VALOR6 AS NOMBRE
        FROM
            DB_GENERAL.ADMI_PARAMETRO_CAB CAB
        INNER JOIN
            DB_GENERAL.ADMI_PARAMETRO_DET DET
        ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID
        AND CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
        AND CAB.MODULO = Cv_Modulo
        AND CAB.ESTADO = Cv_Estado
        AND DET.ESTADO = Cv_Estado
        AND DET.EMPRESA_COD = Pv_Empresa;

    CURSOR C_GetPromocionesAplicables(Cv_TipoProducto VARCHAR2, Cv_Modulo VARCHAR2, Cv_Estado VARCHAR2) IS
        SELECT
            DET.DESCRIPCION AS DESCRIPCION,
            DET.VALOR4 AS DESCRIPCION_MOVIL,
            DET.VALOR5 AS DESCRIPCION_MOVIL_USUARIO
        FROM
            DB_GENERAL.ADMI_PARAMETRO_CAB CAB
        INNER JOIN
            DB_GENERAL.ADMI_PARAMETRO_DET DET ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID
        AND CAB.MODULO = Cv_Modulo
        AND CAB.ESTADO = Cv_Estado
        AND DET.ESTADO = Cv_Estado
        AND DET.VALOR3 = Cv_TipoProducto
        AND DET.EMPRESA_COD = Pv_Empresa
        ORDER BY DET.VALOR7 ASC;

        TYPE T_Array_Promo IS TABLE OF C_GetPromocionesAplicables%ROWTYPE INDEX BY BINARY_INTEGER;
        TYPE T_Array_TipoProd IS TABLE OF C_GetTiposProducto%ROWTYPE INDEX BY BINARY_INTEGER;

        Lcl_Json          CLOB;
        Lt_tipos_promo    T_Array_Promo;
        Lt_tipos_producto T_Array_TipoProd;
        Ln_IndxP          NUMBER;
        Ln_IndxT          NUMBER;
    BEGIN
        OPEN C_GetTiposProducto('PROMOCIONES_APLICABLES_TM_COMERCIAL', 'COMERCIAL', 'Activo');
            FETCH C_GetTiposProducto BULK COLLECT INTO Lt_tipos_producto LIMIT 100000;
        CLOSE C_GetTiposProducto;

        apex_json.initialize_clob_output;
        apex_json.open_array('promociones');
        Ln_IndxT := Lt_tipos_producto.FIRST;

        WHILE (Ln_IndxT <= Lt_tipos_producto.LAST) LOOP
            apex_json.open_object();
            apex_json.write('k', Lt_tipos_producto(Ln_IndxT).NOMBRE);
            apex_json.write('v', Lt_tipos_producto(Ln_IndxT).TIPO_PRODUCTO);
            apex_json.open_array('items');

            OPEN C_GetPromocionesAplicables(Lt_tipos_producto(Ln_IndxT).TIPO_PRODUCTO, 'COMERCIAL', 'Activo');
                FETCH C_GetPromocionesAplicables BULK COLLECT INTO Lt_tipos_promo LIMIT 100000;
            CLOSE C_GetPromocionesAplicables;
            Ln_IndxP := Lt_tipos_promo.FIRST;

            WHILE (Ln_IndxP <= Lt_tipos_promo.LAST) LOOP
                apex_json.open_object(); 
                apex_json.write('k', Lt_tipos_promo(Ln_IndxP).DESCRIPCION_MOVIL);
                apex_json.write('v', Lt_tipos_promo(Ln_IndxP).DESCRIPCION);
                apex_json.write('w', Lt_tipos_promo(Ln_IndxP).DESCRIPCION_MOVIL_USUARIO);
                apex_json.close_object();
                Ln_IndxP := Ln_IndxP + 1;
            END LOOP;
            Ln_IndxT := Ln_IndxT +1;
            apex_json.close_array();
            apex_json.close_object();
        END LOOP;

        apex_json.close_array();

        Lcl_Json := apex_json.get_clob_output;
        apex_json.free_output;

      RETURN(Lcl_Json);
  END F_GENERA_JSON_PROMOCIONES;

 FUNCTION F_GENERA_JSON_ESTADOS_PUNTO
 RETURN CLOB
      IS Lcl_Json CLOB;

    CURSOR C_GetEstadoPunto
    IS
      SELECT 'Todos' as ESTADO
      FROM dual
      UNION
      SELECT DISTINCT(ESTADO) 
      FROM DB_COMERCIAL.INFO_PUNTO;

  BEGIN
      Lcl_Json := '"estadoPunto": [ ';
      FOR I IN C_GetEstadoPunto LOOP
          DBMS_LOB.APPEND(Lcl_Json, '"'||I.ESTADO|| '",');
      END LOOP;
      Lcl_Json := SUBSTR(Lcl_Json, 0, LENGTH(Lcl_Json) - 1);
      DBMS_LOB.APPEND(Lcl_Json, ']');
      RETURN(Lcl_Json);
  EXCEPTION
  WHEN OTHERS THEN

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'TelcosMobile',
                                          'CMKG_CATALOGOS_MOBILE.F_GENERA_JSON_ESTADOS_PUNTO',
                                          'Error al obtener listado de estados puntos' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    RETURN NULL;

 END F_GENERA_JSON_ESTADOS_PUNTO;
 
 FUNCTION F_GENERA_JSON_ULTIMA_MILLA
 RETURN CLOB
      IS Lcl_Json CLOB;

    CURSOR C_TipoMedio
    IS
      SELECT
        ID_TIPO_MEDIO, NOMBRE_TIPO_MEDIO 
      FROM DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO
        WHERE ESTADO = 'Activo';

  BEGIN
      Lcl_Json := '"ultimaMilla": [ ';
      FOR I IN C_TipoMedio LOOP
          DBMS_LOB.APPEND(Lcl_Json, '{');
          DBMS_LOB.APPEND(Lcl_Json, '"k": "' || I.ID_TIPO_MEDIO || '",');
          DBMS_LOB.APPEND(Lcl_Json, '"v": "' || I.NOMBRE_TIPO_MEDIO || '"');
          DBMS_LOB.APPEND(Lcl_Json, '},');
      END LOOP;
      Lcl_Json := SUBSTR(Lcl_Json, 0, LENGTH(Lcl_Json) - 1);
      DBMS_LOB.APPEND(Lcl_Json, ']');
      RETURN(Lcl_Json);
  EXCEPTION
  WHEN OTHERS THEN

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'TelcosMobile',
                                          'CMKG_CATALOGOS_MOBILE.F_GENERA_JSON_ULTIMA_MILLA',
                                          'Error al obtener listado de última milla' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    RETURN NULL;
 END F_GENERA_JSON_ULTIMA_MILLA;
 
 FUNCTION F_GENERA_JSON_ESTADOS_SERVICIO
 RETURN CLOB
      IS Lcl_Json CLOB;

    CURSOR C_GetEstadoPunto
    IS
      SELECT DET.VALOR1 AS VALOR1
        FROM   DB_GENERAL.ADMI_PARAMETRO_DET DET
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB CAB
          ON DET.PARAMETRO_ID = CAB.ID_PARAMETRO
        WHERE CAB.NOMBRE_PARAMETRO = 'PLANIFICACION_ESTADOS'
          AND CAB.ESTADO           = 'Activo'
          AND DET.ESTADO           = 'Activo'
        ORDER BY DET.ID_PARAMETRO_DET ASC;

  BEGIN
      Lcl_Json := '"estado": [ ';
      FOR I IN C_GetEstadoPunto LOOP
          DBMS_LOB.APPEND(Lcl_Json, '"'||I.VALOR1|| '",');
      END LOOP;
      Lcl_Json := SUBSTR(Lcl_Json, 0, LENGTH(Lcl_Json) - 1);
      DBMS_LOB.APPEND(Lcl_Json, ']');
      RETURN(Lcl_Json);
  EXCEPTION
  WHEN OTHERS THEN

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'TelcosMobile',
                                          'CMKG_CATALOGOS_MOBILE.F_GENERA_JSON_ESTADOS_SERVICIO',
                                          'Error al obtener listado de estados servicio' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    RETURN NULL;

 END F_GENERA_JSON_ESTADOS_SERVICIO;
 
 FUNCTION F_GENERA_JSON_TIPO_SOLICITUD
 RETURN CLOB
      IS Lcl_Json CLOB;

    CURSOR C_GetEstadoPunto
    IS
      SELECT DET.VALOR1 AS VALOR1
        FROM   DB_GENERAL.ADMI_PARAMETRO_DET DET
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB CAB
          ON DET.PARAMETRO_ID = CAB.ID_PARAMETRO
        WHERE CAB.NOMBRE_PARAMETRO = 'PLANIFICACION_TIPOS'
          AND CAB.ESTADO           = 'Activo'
          AND DET.ESTADO           = 'Activo'
        ORDER BY DET.ID_PARAMETRO_DET ASC;

  BEGIN
      Lcl_Json := '"tipoSolicitud": [ ';
      FOR I IN C_GetEstadoPunto LOOP
          DBMS_LOB.APPEND(Lcl_Json, '"'||I.VALOR1|| '",');
      END LOOP;
      Lcl_Json := SUBSTR(Lcl_Json, 0, LENGTH(Lcl_Json) - 1);
      DBMS_LOB.APPEND(Lcl_Json, ']');
      RETURN(Lcl_Json);
  EXCEPTION
  WHEN OTHERS THEN

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'TelcosMobile',
                                          'CMKG_CATALOGOS_MOBILE.F_GENERA_JSON_TIPO_SOLICITUD',
                                          'Error al obtener listado de tipos solicitudes' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    RETURN NULL;

 END F_GENERA_JSON_TIPO_SOLICITUD;

 FUNCTION F_GENERA_JSON_MOTIVO_HAL
 RETURN CLOB
      IS Lcl_Json CLOB;

    CURSOR C_GetMotivoHal
    IS
      SELECT
            admo.id_motivo,
            admo.nombre_motivo
      FROM
            db_general.admi_motivo admo
      WHERE
            id_motivo IN (
                SELECT DISTINCT
                    TRIM(regexp_substr(motivos.valor1, '[^,]+', 1, level)) AS q
                FROM
                    (
                        SELECT
                            apde.valor1
                        FROM
                            db_general.admi_parametro_det apde
                        WHERE
                            parametro_id = (
                                SELECT
                                    apca.id_parametro
                                FROM
                                    db_general.admi_parametro_cab apca
                                WHERE
                                    apca.nombre_parametro = 'PROGRAMAR_MOTIVO_HAL'
                                and
                                    apca.estado = 'Activo'
                            )
                    ) motivos
                CONNECT BY
                    regexp_substr(motivos.valor1, '[^,]+', 1, level) IS NOT NULL
            );

  BEGIN
      Lcl_Json := '"motivoHal": [ ';
      FOR I IN C_GetMotivoHal LOOP
          DBMS_LOB.APPEND(Lcl_Json, '{');
          DBMS_LOB.APPEND(Lcl_Json, '"k": "' || I.id_motivo || '",');
          DBMS_LOB.APPEND(Lcl_Json, '"v": "' || I.nombre_motivo || '"');
          DBMS_LOB.APPEND(Lcl_Json, '},');
      END LOOP;
      Lcl_Json := SUBSTR(Lcl_Json, 0, LENGTH(Lcl_Json) - 1);
      DBMS_LOB.APPEND(Lcl_Json, ']');
      RETURN(Lcl_Json);
  EXCEPTION
  WHEN OTHERS THEN

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'TelcosMobile',
                                          'CMKG_CATALOGOS_MOBILE.F_GENERA_JSON_MOTIVO_HAL',
                                          'Error al obtener listado de motivos hal ' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    RETURN NULL;

 END F_GENERA_JSON_MOTIVO_HAL;

END CMKG_CATALOGOS_MOBILE;
/
