/**
 * DEBE EJECUTARSE EN DB_SOPORTE
 * Script para replicar arbol de hipotesis de MEGADATOS a ECUANET
 * @author Javier Hidalgo <jihidalgo@telconet.ec>
 * @version 1.0 10-03-2023 - Versión Inicial.
 */

DECLARE

    Vn_idHipEcuanetPadre   NUMBER;
    Vn_idHipEcuanetDos     NUMBER;
    Vn_idHipEcuanetTres    NUMBER;

    CURSOR c_getdata IS
    SELECT
       a.*
    FROM
        db_soporte.admi_hipotesis a
    WHERE
        a.empresa_cod = 18
    ORDER BY a.hipotesis_id desc;
    
    CURSOR c_getdatanivelada(cn_idpadre number) IS
    SELECT
       b.*
    FROM
        db_soporte.admi_hipotesis b
    WHERE
        b.hipotesis_id = cn_idpadre;
        
    CURSOR c_getdataniveladatres(cn_idpadre number) IS
    SELECT
       b.*
    FROM
        db_soporte.admi_hipotesis b
    WHERE
        b.hipotesis_id = cn_idpadre;
        
    Lr_AdmiHipotesis        DB_SOPORTE.ADMI_HIPOTESIS%ROWTYPE;
    Lr_AdmiHipotesisDos     DB_SOPORTE.ADMI_HIPOTESIS%ROWTYPE;
    Lr_AdmiHipotesisTres    DB_SOPORTE.ADMI_HIPOTESIS%ROWTYPE;

   
BEGIN
    
    IF c_getdata%ISOPEN THEN
        CLOSE c_getdata;
    END IF;
    
    FOR Lr_AdmiHipotesis IN c_getdata
    LOOP       
    
        IF Lr_AdmiHipotesis.hipotesis_id IS NULL or Lr_AdmiHipotesis.hipotesis_id = 0 THEN
    
            Vn_idHipEcuanetPadre := DB_SOPORTE.SEQ_ADMI_HIPOTESIS.NEXTVAL;
            
            INSERT INTO DB_SOPORTE.ADMI_HIPOTESIS VALUES (
                Vn_idHipEcuanetPadre,
                Lr_AdmiHipotesis.NOMBRE_HIPOTESIS,
                Lr_AdmiHipotesis.DESCRIPCION_HIPOTESIS,
                Lr_AdmiHipotesis.ESTADO,
                Lr_AdmiHipotesis.USR_CREACION,
                Lr_AdmiHipotesis.FE_CREACION,
                Lr_AdmiHipotesis.USR_ULT_MOD,
                Lr_AdmiHipotesis.FE_ULT_MOD,
                '33',
                Lr_AdmiHipotesis.TIPO_CASO_ID,
                Lr_AdmiHipotesis.HIPOTESIS_ID   
            );
            
            IF c_getdatanivelada%ISOPEN THEN
                CLOSE c_getdatanivelada;
            END IF;
                
            FOR Lr_AdmiHipotesisDos IN c_getdatanivelada(Lr_AdmiHipotesis.id_hipotesis)
            LOOP
                
                Vn_idHipEcuanetDos := DB_SOPORTE.SEQ_ADMI_HIPOTESIS.NEXTVAL;
                
                INSERT INTO DB_SOPORTE.ADMI_HIPOTESIS VALUES (
                Vn_idHipEcuanetDos,
                Lr_AdmiHipotesisDos.NOMBRE_HIPOTESIS,
                Lr_AdmiHipotesisDos.DESCRIPCION_HIPOTESIS,
                Lr_AdmiHipotesisDos.ESTADO,
                Lr_AdmiHipotesisDos.USR_CREACION,
                Lr_AdmiHipotesisDos.FE_CREACION,
                Lr_AdmiHipotesisDos.USR_ULT_MOD,
                Lr_AdmiHipotesisDos.FE_ULT_MOD,
                '33',
                Lr_AdmiHipotesisDos.TIPO_CASO_ID,
                Vn_idHipEcuanetPadre   
            );    
            
                IF c_getdataniveladatres%ISOPEN THEN
                    CLOSE c_getdataniveladatres;
                END IF;
    
                FOR Lr_AdmiHipotesisTres IN c_getdataniveladatres(Lr_AdmiHipotesisDos.id_hipotesis)
                LOOP
                    
                    Vn_idHipEcuanetTres := DB_SOPORTE.SEQ_ADMI_HIPOTESIS.NEXTVAL;
                    
                    INSERT INTO DB_SOPORTE.ADMI_HIPOTESIS VALUES (
                    Vn_idHipEcuanetTres,
                    Lr_AdmiHipotesisTres.NOMBRE_HIPOTESIS,
                    Lr_AdmiHipotesisTres.DESCRIPCION_HIPOTESIS,
                    Lr_AdmiHipotesisTres.ESTADO,
                    Lr_AdmiHipotesisTres.USR_CREACION,
                    Lr_AdmiHipotesisTres.FE_CREACION,
                    Lr_AdmiHipotesisTres.USR_ULT_MOD,
                    Lr_AdmiHipotesisTres.FE_ULT_MOD,
                    '33',
                    Lr_AdmiHipotesisTres.TIPO_CASO_ID,
                    Vn_idHipEcuanetDos   
                );
                
                END LOOP;
                
                IF c_getdataniveladatres%ISOPEN THEN
                    CLOSE c_getdataniveladatres;
                END IF;
                
                    
            END LOOP;  
            
            IF c_getdatanivelada%ISOPEN THEN
                CLOSE c_getdatanivelada;
            END IF;
            
        END IF;            
            
    END LOOP;
    
    IF c_getdata%ISOPEN THEN
        CLOSE c_getdata;
    END IF;

    COMMIT;

END;
/

