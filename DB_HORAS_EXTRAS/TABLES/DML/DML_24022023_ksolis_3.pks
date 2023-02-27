          --------UPDATE DE LAS FECHAS DE LOS FERIADOS LOCALES-------
          
          --------ACTUALIZACION MANABI - PORTOVIEJO
          UPDATE DB_GENERAL.admi_parametro_det 
          SET VALOR2 = '20', USR_ULT_MOD = 'ksolis', FE_ULT_MOD = sysdate, IP_ULT_MOD = '127.0.0.1'
          WHERE  
          --ID_PARAMETRO_DET = 31617 AND 
          ESTADO = 'Activo' AND VALOR2 = '18' AND VALOR1 = '10' AND VALOR6 = '13' AND VALOR7 = '01'AND USR_CREACION = 'ksolis';
          --------ACTUALIZACION SANTA ELENA
          UPDATE DB_GENERAL.admi_parametro_det 
          SET VALOR2 = '7', USR_ULT_MOD = 'ksolis', FE_ULT_MOD = sysdate, IP_ULT_MOD = '127.0.0.1'
          WHERE  ESTADO = 'Activo' AND VALOR2 = '6' AND VALOR1 = '11' AND VALOR6 = '24' AND VALOR7 is null AND USR_CREACION = 'ksolis';
          -------Tungurahua - AMBATO
          UPDATE DB_GENERAL.admi_parametro_det 
          SET VALOR7 = '01', USR_ULT_MOD = 'ksolis', FE_ULT_MOD = sysdate, IP_ULT_MOD = '127.0.0.1'
          WHERE ESTADO = 'Activo' AND VALOR2 = '12' AND VALOR1 = '11' AND VALOR6 = '18' AND VALOR7 is null AND USR_CREACION = 'ksolis';
          -------PICHINCHA - QUITO
          UPDATE DB_GENERAL.admi_parametro_det 
          SET VALOR2 = '8', VALOR3 = '2023', USR_ULT_MOD = 'ksolis', FE_ULT_MOD = sysdate, IP_ULT_MOD = '127.0.0.1'
          WHERE ESTADO = 'Activo' AND VALOR1 = '12' AND VALOR6 = '17' AND VALOR7 = '01' AND USR_CREACION = 'ksolis';
          
          -------Actualizacion de feriados del ano pasado
          UPDATE DB_GENERAL.admi_parametro_det 
          SET ESTADO = 'Inactivo', USR_ULT_MOD = 'ksolis', FE_ULT_MOD = sysdate, IP_ULT_MOD = '127.0.0.1'
          WHERE ESTADO = 'Activo' and USR_CREACION = 'kportugal' AND VALOR1 = '12' AND VALOR2 = '26' AND VALOR3 = '2022';


          COMMIT;

          /