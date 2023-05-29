/** 
 * @author Alex Arreaga <atarreaga@telconet.ec>
 * @version 1.0 
 * @since 20-02-2023
 * Se crea DDL para numeraciones en financiero.
 */

DECLARE
  --
  
  CURSOR C_RegistrosProcesar(Cn_CodEmpresa NUMBER)
  IS
    select 
        ID_OFICINA                ,
        EMPRESA_ID                ,
        CANTON_ID                 ,
        NOMBRE_OFICINA           
    from db_comercial.info_oficina_grupo 
    WHERE empresa_id = Cn_CodEmpresa
    --AND ID_OFICINA = 229
    ORDER BY nombre_oficina DESC;
    
    CURSOR C_RegistrosOficinaEcNet (Cn_CodEmpresa     NUMBER,
                                    Cv_NombreOficina  VARCHAR2,
                                    Cn_IdCanton       NUMBER)
    IS
    select 
        ID_OFICINA                ,
        EMPRESA_ID                ,
        CANTON_ID                 ,
        NOMBRE_OFICINA           
    from db_comercial.info_oficina_grupo 
    WHERE empresa_id = Cn_CodEmpresa
    AND   canton_id  = Cn_IdCanton
    AND REPLACE(UPPER(nombre_oficina),'ECUANET','MEGADATOS') = Cv_NombreOficina
    ORDER BY nombre_oficina DESC;
        
  CURSOR C_GetAdmiNumeracion (Cn_CodEmpresa  NUMBER,
                              Cn_OficinaId   NUMBER)
    IS
      SELECT 
        ID_NUMERACION        ,   
        EMPRESA_ID           ,
        OFICINA_ID           ,      
        DESCRIPCION          ,
        CODIGO               , 
        NUMERACION_UNO       ,  
        NUMERACION_DOS       ,  
        SECUENCIA            ,     
        FE_CREACION          , 
        USR_CREACION         ,
        FE_ULT_MOD           , 
        USR_ULT_MOD          ,
        TABLA                , 
        ESTADO               ,
        NUMERO_AUTORIZACION  ,
        PROCESOS_AUTOMATICOS ,
        TIPO_ID                   
      FROM DB_COMERCIAL.admi_numeracion 
      WHERE empresa_id = Cn_CodEmpresa 
      AND oficina_id = Cn_OficinaId 
      AND estado = 'Activo';      
    
  Lv_EstadoActivo    VARCHAR2(15) := 'Activo';
  Lv_MsjException    VARCHAR2(4000); 
  Le_Exception       EXCEPTION;

  --MD
  Ln_IdEmpresaMD        NUMBER;
  Ln_IdCantonMD         NUMBER;
  Ln_IdOficinaMD        NUMBER;
  Lv_NombreOficinaMD    VARCHAR2(100);
  
  --EN
  Ln_IdEmpresaEN            NUMBER := 33;
  Ln_IdCantonEN             NUMBER;
  Lc_RegistrosOficinaEcNet  C_RegistrosOficinaEcNet%ROWTYPE;
  Lv_DescripcionNumEN       VARCHAR2(100) := '33';
  Ln_ContadorNum            NUMBER := 0;
  Ln_ContadorReg            NUMBER := 0;
  --        
BEGIN
  --
  IF C_RegistrosProcesar%ISOPEN THEN
    CLOSE C_RegistrosProcesar;
  END IF;
  
  IF C_RegistrosOficinaEcNet%ISOPEN THEN
    CLOSE C_RegistrosOficinaEcNet;
  END IF;
  
  IF C_GetAdmiNumeracion%ISOPEN THEN
    CLOSE C_GetAdmiNumeracion;
  END IF;
  --
  DBMS_OUTPUT.PUT_LINE('Inicia iteración registros.'); 
  
  FOR Lc_RegistrosProcesar IN C_RegistrosProcesar(18)
  LOOP
  --
    BEGIN

      --
      Ln_IdOficinaMD     := Lc_RegistrosProcesar.ID_OFICINA;
      Lv_NombreOficinaMD := Lc_RegistrosProcesar.NOMBRE_OFICINA;
      Ln_IdCantonMD      := Lc_RegistrosProcesar.CANTON_ID;
      Ln_IdEmpresaMD     := Lc_RegistrosProcesar.EMPRESA_ID;
      
      DBMS_OUTPUT.PUT_LINE('----------------------------------------------'); 
      DBMS_OUTPUT.PUT_LINE('MD_ID_OFICINA: '||Ln_IdOficinaMD || '- MD_NOMBRE_OFICINA: '||Lv_NombreOficinaMD || ' - MD_IDCANTON: '||Ln_IdCantonMD); 
      
      Lc_RegistrosOficinaEcNet := NULL;
      
      OPEN C_RegistrosOficinaEcNet(Ln_IdEmpresaEN,Lv_NombreOficinaMD,Ln_IdCantonMD);
      FETCH C_RegistrosOficinaEcNet INTO Lc_RegistrosOficinaEcNet;
      CLOSE C_RegistrosOficinaEcNet;
      
      IF Lc_RegistrosOficinaEcNet.NOMBRE_OFICINA IS NULL THEN 
        Lv_MsjException := 'No se encontro oficina de MegaDatos en la empresa Ecuanet. NombreOficinaMD: '||Lv_NombreOficinaMD;
        RAISE Le_Exception;
      END IF;
    
      Ln_ContadorNum      := 0;
      
      FOR Lc_RegistrosAdmiNum IN C_GetAdmiNumeracion(Ln_IdEmpresaMD,Ln_IdOficinaMD)
      LOOP 
        
        Lv_DescripcionNumEN := '';
        Lv_DescripcionNumEN := REPLACE(Lc_RegistrosAdmiNum.DESCRIPCION,'MEGADATOS','ECUANET');
        
        --logica de inserta ADMI_NUMERACION
        INSERT INTO DB_COMERCIAL.ADMI_NUMERACION (ID_NUMERACION, EMPRESA_ID, OFICINA_ID, DESCRIPCION, CODIGO, NUMERACION_UNO, NUMERACION_DOS, SECUENCIA, FE_CREACION, USR_CREACION, TABLA, ESTADO, PROCESOS_AUTOMATICOS) 
        VALUES (
            DB_COMERCIAL.SEQ_ADMI_NUMERACION.NEXTVAL, 
            Ln_IdEmpresaEN, 
            Lc_RegistrosOficinaEcNet.ID_OFICINA, 
            Lv_DescripcionNumEN, 
            Lc_RegistrosAdmiNum.CODIGO, 
            Lc_RegistrosAdmiNum.NUMERACION_UNO, 
            Lc_RegistrosAdmiNum.NUMERACION_DOS, 
            1, --Lc_RegistrosAdmiNum.SECUENCIA,
            SYSDATE, 
            'atarreaga', 
            Lc_RegistrosAdmiNum.TABLA, 
            Lc_RegistrosAdmiNum.ESTADO, 
            Lc_RegistrosAdmiNum.PROCESOS_AUTOMATICOS
        );  
        --
        Ln_ContadorNum := Ln_ContadorNum + 1;
      END LOOP;

      DBMS_OUTPUT.PUT_LINE('EN_ID_OFICINA: '||Lc_RegistrosOficinaEcNet.ID_OFICINA || ' - EN_NOMBRE_OFICINA: '||Lc_RegistrosOficinaEcNet.NOMBRE_OFICINA || ' - Numeraciones insertadas: '||Ln_ContadorNum);

      COMMIT; 
      
      
     EXCEPTION  
     WHEN Le_Exception THEN
         DBMS_OUTPUT.PUT_LINE(Lv_MsjException);
       
     END;
     --
     Ln_ContadorReg := Ln_ContadorReg + 1;
  END LOOP;
  
  DBMS_OUTPUT.PUT_LINE('Finaliza iteración registros.'); 
  DBMS_OUTPUT.PUT_LINE('Registros oficinas regularizadas: '||Ln_ContadorReg);
  --   

EXCEPTION
WHEN OTHERS THEN
  --
  DBMS_OUTPUT.PUT_LINE(SQLCODE||' - ERROR_STACK:'||DBMS_UTILITY.FORMAT_ERROR_STACK || 
                                        ' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  ROLLBACK;
  DBMS_OUTPUT.PUT_LINE('El proceso dio error, por favor verificar el error en la INFO_ERROR de DB_GENERAL.');
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'SCRIPT_REGULA_NUMERACION',
                                        'SCRIPT_REGULA_NUMERACION',
                                        SQLCODE||' - ERROR_STACK:'||DBMS_UTILITY.FORMAT_ERROR_STACK || 
                                        ' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                        'DB_COMERCIAL',
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
END;

