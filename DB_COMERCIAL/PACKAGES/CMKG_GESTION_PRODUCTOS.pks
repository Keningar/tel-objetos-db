CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_GESTION_PRODUCTOS AS

  /**
  * Documentacion para P_CONSULTAR_PRODUCTO_POR
  * SP que lista productos.
  * @author lardila <lardila@telconet.ec>
  * @version 1.0 31/05/2022
  *
  * @param Pd_request   IN CLOB          JSON REQUEST 
  * @param Pv_status        OUT VARCHAR2          Codigo estado
  * @param Pv_mensaje        OUT VARCHAR2          Mensaje resultado
  * @param Pd_response  OUT CLOB      Retorna JSON con resultados

  */

    PROCEDURE P_CONSULTAR_PRODUCTO_POR(
                        Pd_request in CLOB,
                        Pv_status out varchar2,
                        Pv_mensaje out varchar2,
                        Pd_response out CLOB
                     );

END CMKG_GESTION_PRODUCTOS;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_GESTION_PRODUCTOS AS

        
    PROCEDURE P_CONSULTAR_PRODUCTO_POR(
                        Pd_request in CLOB,
                        Pv_status out varchar2,
                        Pv_mensaje out varchar2,
                        Pd_response out CLOB
                     ) AS
                        
                        lv_Jason          CLOB := NULL;
                        ln_Linea          NUMBER;
                        Ln_BreakPoint     NUMBER := 0;
                        Lv_JasonAux       CLOB := NULL;
                        Lv_RegJSon        CLOB := NULL;
                        ln_id_apu         NUMBER;


                        lv_id_producto    VARCHAR2(10);
                        lv_companyCode    VARCHAR2(2);
                        lv_technicalName  VARCHAR2(40);
                        lv_group          VARCHAR2(50);
                        lv_descripcion          VARCHAR2(50);
                        lv_status          VARCHAR2(50);

                        ln_check_id     number := 0;
                        ln_check_companyCode     number := 0;
                        ln_check_technicalName   number := 0;
                        ln_check_group           number := 0;
                        ln_check_status          number := 0;
                        ln_check_description     number := 0;

                        lv_cod number;
                        CURSOR C_PRODUCT_LIST(lv_status VARCHAR2,
                                              lv_descripcion VARCHAR2,
                                              ln_group VARCHAR2,
                                              lv_technicalName VARCHAR2,
                                              lv_companyCode VARCHAR2) is 
                                SELECT
                                    admprod.id_producto,
                                    admprod.descripcion_producto description,
                                    admprod.empresa_cod companyCode,
                                    admprod.nombre_tecnico technicalName,
                                    admprod.grupo grupo,
                                    admprod.subgrupo subgroup,
                                    admprod.linea_negocio businessLine,
                                    admprod.estado status
                                    FROM 
                                        DB_COMERCIAL.admi_producto admprod
                                    WHERE 
                                        admprod.estado = lv_status
                                        and (admprod.empresa_cod = lv_companyCode OR 1 = ln_check_companyCode)           
                                        and (admprod.nombre_tecnico LIKE '%'||lv_technicalName||'%' OR 1 = ln_check_technicalName)
                                        and (admprod.descripcion_producto LIKE '%'||lv_descripcion||'%' OR 1 = ln_check_description)
                                        and (admprod.grupo LIKE '%'||lv_group||'%' OR 1 = ln_check_group)
                                        and (admprod.id_producto = lv_id_producto OR 1 = ln_check_id);


                     BEGIN
                        Pv_Status     := 'OK';
                        Pv_Mensaje    := 'Transaccion exitosa';
                        Pd_response := NULL;

                        APEX_JSON.PARSE(Pd_request);

                        lv_id_producto  := APEX_JSON.get_varchar2(p_path => 'id');
                        lv_companyCode := APEX_JSON.get_varchar2(p_path => 'companyCode');
                        lv_technicalName := APEX_JSON.get_varchar2(p_path => 'technicalName');
                        lv_group := APEX_JSON.get_varchar2(p_path => 'group');
                        lv_descripcion := APEX_JSON.get_varchar2(p_path => 'description');

                        IF lv_descripcion IS NULL
                        THEN
                            ln_check_description := 1;
                        END IF;

                        IF lv_id_producto IS NULL
                        THEN
                            ln_check_id := 1;
                        END IF;
                        IF lv_companyCode is null
                        THEN
                            ln_check_companyCode := 1;
                        END IF;

                        IF lv_technicalName is null
                        THEN
                            ln_check_technicalName := 1;
                        END IF;

                        IF lv_group is null
                        THEN
                            ln_check_group := 1;
                        END IF;

                        IF lv_status is null
                        THEN
                            lv_status:= 'Activo';
                        END IF;

                         Ln_Linea    := 0;
                         lv_Jason := '[';

                        FOR Lr_Datos in C_PRODUCT_LIST(lv_status,
                                                       lv_descripcion,
                                                       lv_group,
                                                       lv_technicalName,
                                                       lv_companyCode) LOOP

                                   IF Ln_Linea > 0 THEN
                                         Lv_JasonAux := Lv_JasonAux||',';
                                   END IF;            
                                   Lv_RegJSon := '{'
                                                  ||'"id":"'||Lr_Datos.id_producto||'",'
                                                  ||'"description":"'||Lr_Datos.description||'",'
                                                  ||'"companyCode":"'||Lr_Datos.companyCode||'",'
                                                  ||'"technicalName":"'||Lr_Datos.technicalName||'",'
                                                  ||'"group":"'||Lr_Datos.grupo||'",'
                                                  ||'"subGroup":"'||Lr_Datos.subGroup||'",'
                                                  ||'"businessLine":"'||Lr_Datos.businessLine||'",'
                                                  ||'"status":"'||Lr_Datos.status||'"'
                                                  ||'}';
                                 Lv_Jason := Lv_Jason || Lv_JasonAux;
                                 Lv_JasonAux := Lv_RegJSon;
                                 Ln_Linea := Ln_Linea + 1;
                            END LOOP;
                        Lv_Jason := Lv_Jason || Lv_JasonAux;
                         IF Ln_Linea = 0 THEN
                              Pv_Status  := '404';
                              Pv_Mensaje := 'No se encontraron Productos ';
                        END IF;
                        Lv_Jason := Lv_Jason||']';
                        Pd_response   :=  Lv_Jason;                        
                        Pv_Status     := 'OK';
                        Pv_Mensaje    := 'Transaccion exitosa';

    END;
END CMKG_GESTION_PRODUCTOS;
/
