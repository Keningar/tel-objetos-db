DELETE FROM db_general.admi_parametro_det pardet
    WHERE pardet.descripcion = 'DEP. ADM. (ATENCION INTERNA) PARA JOB BARRIDO DE TAREA Y GENERACION DE HORAS EXTRAS'
    AND pardet.estado = 'Activo'
    AND pardet.valor1 = 'NOC';
    
DELETE FROM db_general.admi_parametro_det pardet
    WHERE pardet.descripcion = 'DEP. ADM. (ATENCION INTERNA) PARA JOB BARRIDO DE TAREA Y GENERACION DE HORAS EXTRAS'
    AND pardet.estado = 'Activo'
    AND pardet.valor1 = 'IPCCL1';


DELETE FROM db_general.admi_parametro_det
    WHERE DESCRIPCION='NUMERO_MES_BARRIDO_TAREAS_HE';


DELETE
    FROM db_general.admi_parametro_Cab
    WHERE nombre_parametro='NUMERO_MES_BARRIDO_TAREAS_HE';

DELETE 
    FROM db_general.admi_parametro_det
    WHERE DESCRIPCION='DIA_DE_CORTE_MES_VENCIDO';

DELETE  
    FROM db_general.admi_parametro_Cab
    WHERE nombre_parametro='DIA_DE_CORTE_MES_VENCIDO';

DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET 
    WHERE DESCRIPCION = 'MES_DIAS_FERIADO' 
          AND VALOR3 = TO_CHAR(SYSDATE,'YYYY')
          AND ESTADO = 'Activo'
          AND VALOR5 IS NOT NULL
          AND USR_CREACION = 'ksolis';
          
COMMIT;
    /