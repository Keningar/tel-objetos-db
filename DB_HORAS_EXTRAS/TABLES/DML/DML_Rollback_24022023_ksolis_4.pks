          DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET 
          WHERE DESCRIPCION = 'MES_DIAS_FERIADO' 
                AND TO_CHAR(FE_CREACION, 'MM-YYYY') = TO_CHAR (TO_DATE('24-02-2023'), 'MM-YYYY')
                AND VALOR3 = TO_CHAR(SYSDATE,'YYYY')
                AND ESTADO = 'Activo'
                AND VALOR5 IS NOT NULL
                AND USR_CREACION = 'ksolis';


COMMIT;

/