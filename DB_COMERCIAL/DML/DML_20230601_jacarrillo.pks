/**
 * Creación de porceso para regularización de formaContrato en adendums para md en unrango de fechas
 *
 *
 * @author Jefferson Carrillo<jacarrillo@telconet.ec>
 * @version 1.0 01-06-2023
 */ 

SET DEFINE OFF;
SET SERVEROUTPUT ON ;
  DECLARE  
  
  TYPE Ln_Ids IS TABLE OF NUMBER  INDEX BY PLS_INTEGER; 
  Lv_FechaIni VARCHAR2(100);
  Lv_FechaFin VARCHAR2(100);  
  V_IdsAdendumDig  Ln_Ids;
  V_IdsAdendumFis  Ln_Ids;
  Lv_TipoFisco   VARCHAR2(500):='FISICO';
  Lv_TipoDigital VARCHAR2(500):='DIGITAL';
  Lv_UsrCreacion VARCHAR2(500):='RegulaFirma'; 
  
    CURSOR C_getAdendumRegula  ( Cv_FechaIni  VARCHAR2,  Cv_FechaFin VARCHAR2)   IS   
        SELECT 
        null useformaContrato, 
        adem.id_adendum,
        adem.contrato_id, 
        adem.numero, 
        adem.tipo
        FROM DB_COMERCIAL.info_adendum adem
        inner join  DB_COMERCIAL.info_contrato ico on ico.id_contrato = adem.contrato_id
        inner join  DB_COMERCIAL.info_persona_empresa_rol iper on iper.id_persona_rol = ico.persona_empresa_rol_id
        inner join  DB_COMERCIAL.info_empresa_rol ier on ier.id_empresa_rol = iper.empresa_rol_id
        WHERE   ier.empresa_cod = '18'
        AND (adem.estado = 'Activo') 
        AND adem.forma_contrato is null  
        AND adem.fe_creacion BETWEEN TO_TIMESTAMP(Cv_FechaIni||' 00:00:00','DD-MM-YYYY HH24:MI:SS') 
        AND TO_TIMESTAMP(Cv_FechaFin ||' 23:59:59','DD-MM-YYYY HH24:MI:SS'); 
    
    CURSOR C_getVerificaCarcteristica ( Cn_IdContrato Integer) IS     
        select  VALOR1 from DB_COMERCIAL.info_contrato_caracteristica cara
        where cara.caracteristica_id  in (1639,1638 )
        and  cara.estado= 'Activo' and  ROWNUM = 1 
        and  cara.contrato_id = Cn_IdContrato; 
    
   CURSOR C_getVerificaDocumentoSecurity ( Cn_IdContrato Integer) IS     
      select count(*) from DB_COMERCIAL.info_documento  indo
      inner join DB_COMERCIAL.info_documento_relacion  indr  on indr.documento_id = indo.id_documento
      where ( INSTR(indo.UBICACION_LOGICA_DOCUMENTO ,'contratoSecurityData')  > 0) 
      and   indo.contrato_id  =  Cn_IdContrato;  
           
          

BEGIN

    Lv_FechaIni :='17/02/2023'; 
    Lv_FechaFin :='20/04/2023';  
    
    FOR I IN C_getAdendumRegula( Lv_FechaIni , Lv_FechaFin ) LOOP
 
           OPEN  C_getVerificaCarcteristica (I.contrato_id); 
           FETCH C_getVerificaCarcteristica  INTO  I.useformaContrato;  
           CLOSE C_getVerificaCarcteristica  ;  
           
            IF  Lv_TipoFisco =  I.useformaContrato THEN      
              V_IdsAdendumFis(V_IdsAdendumFis.COUNT +1) := I.id_adendum ;
            ELSIF Lv_TipoDigital =  I.useformaContrato THEN
              V_IdsAdendumDig(V_IdsAdendumDig.COUNT +1) := I.id_adendum ;
            ELSE  
                                         
               OPEN   C_getVerificaDocumentoSecurity (I.contrato_id); 
               FETCH  C_getVerificaDocumentoSecurity  INTO  I.useformaContrato;  
               CLOSE  C_getVerificaDocumentoSecurity  ;                 
              
                   IF   TO_NUMBER(I.useformaContrato) >  0 THEN  --SI TIENE DOCUMENTOS SECURITY ES DIGITAL   
                       V_IdsAdendumDig(V_IdsAdendumDig.COUNT +1) := I.id_adendum ;
                    ELSE 
                       V_IdsAdendumFis(V_IdsAdendumFis.COUNT +1) := I.id_adendum ; 
                   END IF ; 
                
            END IF ;
            
                       
     
      END LOOP; 
        
        
          
          IF  V_IdsAdendumFis.COUNT  <> 0 THEN            
            FOR i IN 1.. V_IdsAdendumFis.COUNT  LOOP  
                UPDATE DB_COMERCIAL.info_adendum ADEN
                SET ADEN.FORMA_CONTRATO   = Lv_TipoFisco ,
                ADEN.FE_MODIFICA          = SYSDATE,  
                ADEN.USR_MODIFICA         = Lv_UsrCreacion    
                WHERE ADEN.ID_ADENDUM     = V_IdsAdendumFis(i);              
            END LOOP; 
            COMMIT;  
           DBMS_OUTPUT.PUT_LINE( V_IdsAdendumFis.COUNT ||' ADENDUM '|| Lv_TipoFisco ||' REGULARIZADOS' );  
          END IF;             
    
     
           IF  V_IdsAdendumDig.COUNT  <> 0 THEN            
            FOR i IN 1.. V_IdsAdendumDig.COUNT  LOOP  
                UPDATE DB_COMERCIAL.info_adendum ADEN
                SET ADEN.FORMA_CONTRATO   = Lv_TipoDigital ,
                ADEN.FE_MODIFICA          = SYSDATE,  
                ADEN.USR_MODIFICA         = Lv_UsrCreacion    
                WHERE ADEN.ID_ADENDUM     = V_IdsAdendumDig(i);              
            END LOOP; 
            COMMIT;
            DBMS_OUTPUT.PUT_LINE( V_IdsAdendumDig.COUNT ||' ADENDUM '|| Lv_TipoDigital ||' REGULARIZADOS' );  
           END IF;             
     
             
        DBMS_OUTPUT.PUT_LINE( 'FIN DEL PROCESO'); 
            
EXCEPTION
  WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.put_line(SUBSTR(SQLERRM, 1, 2000));
END;