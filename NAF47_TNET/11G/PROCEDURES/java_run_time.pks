create or replace PROCEDURE            java_run_time AS

    pv_nocia      VARCHAR2(10) := '10';
    lv_noemple    VARCHAR2(10) := '2215';
    lv_ejecutar   VARCHAR2(32767);
    lv_entorno    VARCHAR2(50) := 'production';
BEGIN
    db_general.gnrlpck_util.insert_error('SARH','GEK_MIGRACION.P_MIGRACION_ww ','BEGIN ',user,SYSDATE,'127.0.0.1');

    lv_ejecutar := javaruncommand('/opt/ibm-java-ppc64-71/jre/bin/java -Denviroment='
                                    || lv_entorno
                                    || ' -jar /home/oracle/scripts/execJarTmp.jar /home/oracle/scripts/ssosync-1.1.jar '
                                    || pv_nocia
                                    || ' '
                                    || lv_noemple 
                                    );
            
     db_general.gnrlpck_util.insert_error('SARH','GEK_MIGRACION.P_MIGRACION_ww ', lv_ejecutar,user,SYSDATE,'127.0.0.1');
END java_run_time;