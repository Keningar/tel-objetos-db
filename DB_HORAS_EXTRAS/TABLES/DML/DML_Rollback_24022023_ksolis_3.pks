          
          UPDATE DB_GENERAL.admi_parametro_det 
          SET VALOR2 = '18', USR_ULT_MOD = NULL, FE_ULT_MOD = NULL, IP_ULT_MOD = NULL
          WHERE ESTADO = 'Activo' AND VALOR1 = '10' AND VALOR6 = '13' AND VALOR7 = '01'AND USR_ULT_MOD = 'ksolis';

          --------SANTA ELENA
          UPDATE DB_GENERAL.admi_parametro_det 
          SET VALOR2 = '6', USR_ULT_MOD = NULL, FE_ULT_MOD = NULL, IP_ULT_MOD = NULL
          WHERE  ESTADO = 'Activo' AND VALOR1 = '11' AND VALOR6 = '24' AND VALOR7 is null AND USR_ULT_MOD = 'ksolis';

          -------Tungurahua - AMBATO
          UPDATE DB_GENERAL.admi_parametro_det 
          SET VALOR7 = NULL, USR_ULT_MOD = NULL, FE_ULT_MOD = NULL, IP_ULT_MOD = NULL
          WHERE ESTADO = 'Activo' AND VALOR2 = '12' AND VALOR1 = '11' AND VALOR6 = '18' AND VALOR7 is NOT null AND USR_ULT_MOD = 'ksolis';

          -------PICHINCHA - QUITO
          UPDATE DB_GENERAL.admi_parametro_det 
          SET VALOR2 = '4', VALOR3 = '2023', USR_ULT_MOD = NULL, FE_ULT_MOD = NULL, IP_ULT_MOD = NULL
          WHERE ESTADO = 'Activo' AND VALOR1 = '12' AND VALOR6 = '17' AND VALOR7 = '01' AND USR_ULT_MOD = 'ksolis';   
          
          
          UPDATE DB_GENERAL.admi_parametro_det 
          SET ESTADO = 'Activo', USR_ULT_MOD = NULL, FE_ULT_MOD = NULL , IP_ULT_MOD = NULL
          WHERE ESTADO = 'Inactivo' and USR_CREACION = 'kportugal' AND VALOR1 = '12' AND VALOR2 = '26' AND VALOR3 = '2022';


          commit;

          /