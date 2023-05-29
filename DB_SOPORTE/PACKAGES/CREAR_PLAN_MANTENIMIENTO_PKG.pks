CREATE OR REPLACE PACKAGE DB_SOPORTE.CREAR_PLAN_MANTENIMIENTO_PKG
AS
    TYPE nombresarray IS VARRAY(300) OF VARCHAR2(100);

    PROCEDURE CREAR_PLAN_MANTENIMIENTO(pm_nombre varchar2,pm_empresa_cod varchar2,l_id_plan_mantenimiento OUT NUMBER);

    PROCEDURE CREAR_MANTENIMIENTO_Y_TAREAS(l_id_plan_mantenimiento NUMBER,nombre_plan_mantenimiento VARCHAR2,l_prefijo_empresa VARCHAR2, frecuencia VARCHAR2,tipoFrecuencia VARCHAR2,tareas nombresarray);

    FUNCTION DEVUELVE_TAREA_ID_X_NOMBRE(l_nombre_tarea VARCHAR2) return NUMBER;

END CREAR_PLAN_MANTENIMIENTO_PKG;
/

CREATE OR REPLACE PACKAGE BODY DB_SOPORTE.CREAR_PLAN_MANTENIMIENTO_PKG
AS
    /*
    * Documentación para PROCEDIMIENTO 'CREAR_PLAN_MANTENIMIENTO'.
    * PROCEDIMIENTO QUE CREA UN NUEVO PLAN DE MANTENIMIENTO
    * EL PROCEDIMIENTO RECIBE LOS PARAMETROS:
    * @Param pm_nombre          (nombre del nuevo plan de mantenimiento)
    * @Param pm_empresa_cod     (id de la empresa)
    * 
    */
    PROCEDURE CREAR_PLAN_MANTENIMIENTO(pm_nombre varchar2,pm_empresa_cod varchar2,l_id_plan_mantenimiento OUT NUMBER) is
        --Cursor para verificar si el plan de mantenimiento ya existe
            cursor lc_existePlanMantenimiento(c_nombre varchar2, c_empresa_cod varchar2) is    
            SELECT pm.ID_PROCESO as idPlanMantenimiento
            FROM DB_SOPORTE.ADMI_PROCESO pm
            join DB_SOPORTE.ADMI_PROCESO_EMPRESA pme on pm.ID_PROCESO=pme.PROCESO_ID 
            where pm.NOMBRE_PROCESO=trim(c_nombre) 
            and pme.EMPRESA_COD=c_empresa_cod
            and pm.ESTADO='Activo' AND ROWNUM=1;

        lr_existePlanMantenimiento lc_existePlanMantenimiento%ROWTYPE;
        BEGIN       
            OPEN lc_existePlanMantenimiento(pm_nombre,pm_empresa_cod);
            FETCH lc_existePlanMantenimiento INTO lr_existePlanMantenimiento;
            IF(lc_existePlanMantenimiento%found) THEN
                l_id_plan_mantenimiento := lr_existePlanMantenimiento.idPlanMantenimiento;
            else
            --INSERTANDO PLAN DE MANTENIMIENTO
                l_id_plan_mantenimiento := DB_SOPORTE.SEQ_ADMI_PROCESO.NEXTVAL;    
                      Insert into DB_SOPORTE.ADMI_PROCESO
                       (ID_PROCESO,NOMBRE_PROCESO,DESCRIPCION_PROCESO,VISIBLE,APLICA_ESTADO,PLANMANTENIMIENTO,ESTADO,
                FE_CREACION,USR_CREACION,FE_ULT_MOD,USR_ULT_MOD)
                       values 
                       (l_id_plan_mantenimiento,pm_nombre,pm_nombre,'NO','N','S','Activo',SYSDATE,'mlcruz',SYSDATE,'mlcruz'); 

                 Insert into DB_SOPORTE.ADMI_PROCESO_EMPRESA
                       (ID_PROCESO_EMPRESA,ESTADO,USR_CREACION,FE_CREACION,EMPRESA_COD,PROCESO_ID)
                       values 
                       (DB_SOPORTE.SEQ_ADMI_PROCESO_EMPRESA.NEXTVAL,'Activo','mlcruz',
                TO_CHAR(CURRENT_TIMESTAMP,'YYYY-MM-DD HH24:MI:SS'),pm_empresa_cod,l_id_plan_mantenimiento); 
            END IF;
            CLOSE lc_existePlanMantenimiento;
          exception     
            WHEN OTHERS THEN
                  if (lc_existePlanMantenimiento%isopen) then close lc_existePlanMantenimiento; end if;
            l_id_plan_mantenimiento:=0;
        END;

    /*
    * Documentación para FUNCION 'DEVUELVE_TAREA_ID_X_NOMBRE'.
    * FUNCION QUE OBTIENE EL ID DE LA TAREA DE ACUERDO AL NOMBRE DE LA MISMA
    * PARAMETROS:
    * @Param varchar2 l_nombre_tarea    (nombre de la tarea)
    * @return NUMBER l_id_tarea         (es el id de la tarea)
    */
    FUNCTION DEVUELVE_TAREA_ID_X_NOMBRE(l_nombre_tarea VARCHAR2)
    return NUMBER is  
            --Cursor para obtener id de la tarea en base al nombre de la tarea
        cursor lc_obtenerTareaXNombre(l_nombre_tarea VARCHAR2) is
        SELECT tarea.ID_TAREA
        FROM DB_SOPORTE.ADMI_TAREA tarea
        where TRIM(tarea.NOMBRE_TAREA)=TRIM(l_nombre_tarea)
        AND tarea.ESTADO = 'Activo';

        lr_obtenerTareaXNombre lc_obtenerTareaXNombre%ROWTYPE;         
         
        l_id_tarea number := 0;      
        errorProcedure exception;
        begin       
            OPEN lc_obtenerTareaXNombre(l_nombre_tarea);
            FETCH lc_obtenerTareaXNombre INTO lr_obtenerTareaXNombre;
            IF(lc_obtenerTareaXNombre%found) THEN
                l_id_tarea := lr_obtenerTareaXNombre.ID_TAREA;   
            END IF;
            CLOSE lc_obtenerTareaXNombre;
            return l_id_tarea;
        END;

    /*
    * Documentación para PROCEDIMIENTO 'CREAR_MANTENIMIENTO_Y_TAREAS'.
    * PROCEDIMIENTO QUE CREA LOS MANTENIMIENTOS QUE PERTENECEN A UN PLAN DE MANTENIMIENTO Y LA ASOCIACIÓN CON LAS RESPECTIVAS TAREAS
    * EL PROCEDIMIENTO RECIBE LOS PARAMETROS:
    * @Param l_id_plan_mantenimiento    (id del plan de mantenimiento)
    * @Param nombre_plan_mantenimiento  (nombre del plan de mantenimiento)
    * @Param l_prefijo_empresa          (id de la empresa)
    * @Param frecuencia                 (frecuencia del mantenimiento)
    * @Param tipoFrecuencia             (unidad de medida del mantenimiento)
    * @Param tareas                     (listado de tareas que pertenecen al mantenimiento)
    */
    PROCEDURE CREAR_MANTENIMIENTO_Y_TAREAS(l_id_plan_mantenimiento NUMBER,nombre_plan_mantenimiento VARCHAR2,l_prefijo_empresa VARCHAR2, frecuencia VARCHAR2,tipoFrecuencia VARCHAR2,tareas nombresarray) is
        l_id_mantenimiento_c NUMBER;
        l_id_tarea_c NUMBER;
        LN_PROCESO_ID NUMBER;

        nombre_parametro_fecuencias VARCHAR2(100);
        nombreMantenimiento VARCHAR2(80);
        descripcionMantenimiento VARCHAR2(1500);

        BEGIN   

            nombreMantenimiento := nombre_plan_mantenimiento || ' ' || frecuencia || ' ' || tipoFrecuencia;
            descripcionMantenimiento := 'Plan de Mantenimiento: ' || nombre_plan_mantenimiento 
                        || ' Frecuencia: ' || frecuencia 
                        || ' Tipo de Frecuencia: ' || ' ' || tipoFrecuencia;
            l_id_mantenimiento_c := DB_SOPORTE.SEQ_ADMI_PROCESO.NEXTVAL;
            Insert into DB_SOPORTE.ADMI_PROCESO
               (ID_PROCESO,NOMBRE_PROCESO,PROCESO_PADRE_ID,DESCRIPCION_PROCESO,
            VISIBLE,APLICA_ESTADO,PLANMANTENIMIENTO,ESTADO,FE_CREACION,USR_CREACION,FE_ULT_MOD,USR_ULT_MOD)
               values 
               (l_id_mantenimiento_c,nombreMantenimiento,l_id_plan_mantenimiento,descripcionMantenimiento,
            'NO','N','N','Activo',SYSDATE,'mlcruz',SYSDATE,'mlcruz'); 


            Insert into DB_SOPORTE.ADMI_PROCESO_EMPRESA
               (ID_PROCESO_EMPRESA,ESTADO,USR_CREACION,FE_CREACION,EMPRESA_COD,PROCESO_ID)
               values
                   (DB_SOPORTE.SEQ_ADMI_PROCESO_EMPRESA.NEXTVAL,'Activo','mlcruz',
                TO_CHAR(CURRENT_TIMESTAMP,'YYYY-MM-DD HH24:MI:SS'),
                l_prefijo_empresa,l_id_mantenimiento_c);


            FOR i in 1 .. tareas.COUNT LOOP
                l_id_tarea_c := DEVUELVE_TAREA_ID_X_NOMBRE(tareas(i));

                IF(l_id_tarea_c=0) THEN 
                    --Crear Tarea
                    SELECT ID_PROCESO INTO LN_PROCESO_ID FROM DB_SOPORTE.ADMI_PROCESO WHERE NOMBRE_PROCESO='PROCESO TAREAS MANTENIMIENTOS';
                    Insert into DB_SOPORTE.ADMI_TAREA(ID_TAREA,PROCESO_ID,NOMBRE_TAREA,DESCRIPCION_TAREA,ESTADO,
                    USR_CREACION,FE_CREACION,USR_ULT_MOD,FE_ULT_MOD) 
                    values (DB_SOPORTE.SEQ_ADMI_TAREA.NEXTVAL,
                    LN_PROCESO_ID,TRIM(tareas(i)),TRIM(tareas(i)),'Activo',
                    'mlcruz',SYSDATE,'mlcruz',SYSDATE);

                    l_id_tarea_c := DEVUELVE_TAREA_ID_X_NOMBRE(tareas(i));
                END IF;
                
                --Crear Tareas del mantenimiento
                Insert into DB_SOPORTE.INFO_MANTENIMIENTO_TAREA
                (ID_MANTENIMIENTO_TAREA,MANTENIMIENTO_ID,TAREA_ID,FRECUENCIA,TIPO_FRECUENCIA,
                ESTADO,USR_CREACION,FE_CREACION,IP_CREACION)
                values(DB_SOPORTE.SEQ_INFO_MANTENIMIENTO_TAREA.NEXTVAL,l_id_mantenimiento_c,l_id_tarea_c,
                frecuencia,tipoFrecuencia,'Activo','mlcruz',SYSDATE,'127.0.0.1'); 
            END LOOP;

            exception     
                WHEN OTHERS THEN 
                ROLLBACK; 
            END;

END CREAR_PLAN_MANTENIMIENTO_PKG;
/