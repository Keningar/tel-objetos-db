create or replace procedure            CPSALDO_FECHA(pCia        arcgae.no_cia%type,
                                         pNombreCia   arcgmc.nombre%type,
                                         pNombreGrupo arcpgr.descripcion%type,
                                         pConsulta    VARCHAR2,
                                         pDesde       arcpmp.no_prove%type,
                                         pHasta       arcpmp.no_prove%type,
                                         pFechaCorte  DATE,
                                         pGrupo       arcpmp.grupo%type,
                                         pMsg_error   OUT VARCHAR2    ) IS

  -- OBTENER TODOS LOS DOCUMENTOS ANTERIORES A LA FECHA INDICADA Y EL GRUPO. 
  CURSOR C_MOVIMIENTOS_PROVEEDORES IS        
    SELECT P.NO_PROVE, P.NOMBRE, M.TIPO_DOC, M.NO_DOCU, M.IND_ACT, M.NO_FISICO, M.SERIE_FISICO, 
           M.FECHA, M.MONTO, M.SALDO, M.ANULADO, M.FECHA_ANULA, M.N_DOCU_A, M.DETALLE
    FROM ARCPTD D, ARCPMD M, ARCPMP P 
    WHERE D.NO_CIA= pCia   AND D.TIPO_MOV='C' AND (D.DOCUMENTO NOT IN ('R','O') OR D.TIPO_DOC='ND')  
    AND m.no_prove BETWEEN pDesde AND pHasta
    AND D.NO_CIA=M.NO_CIA AND D.TIPO_DOC=M.TIPO_DOC AND M.IND_ACT <> 'P' AND FECHA <= pFechaCorte
    AND M.NO_CIA=P.NO_CIA AND M.NO_PROVE=P.NO_PROVE AND P.GRUPO=pGrupo  ORDER BY P.NOMBRE, FECHA;   


  -- TENER EN CUENTA SI EL DOCUMENTO ESTA ANULADO Y EN QUE FECHA SE ANULO, SI ESTA ANULADO ANTES DE LA FECHA INDICADA NO LO PRESENTO,
  -- CASO CONTRARIO BUSCO TODOS LOS VALORES APLICADOS AL DOCUMENTO.
  CURSOR C_ANULADO (P_NO_DOCU VARCHAR2) IS  
    SELECT M.FECHA --M.TIPO_DOC, M.NO_DOCU, M.IND_ACT, M.FECHA, M.MONTO, M.ANULADO, M.FECHA_ANULA, M.N_DOCU_A, M.DETALLE
    FROM  ARCPMD M
    WHERE M.NO_CIA=pCia AND M.N_DOCU_A = P_NO_DOCU;

  -- YA QUE EL DOCUMENTO NO TIENE UNA ANULACION ASOCIADA ANTERIOR A LA FECHA INDICADA PROCEDO A OBTENER LA SUMA 
  -- DE DOCUMENTOS APLICADOS A FAVOR ANTERIORES A LA FECHA INDICADA DE ARCPRD
  CURSOR C_APLICACIONES_CP (P_NO_DOCU_REFE VARCHAR2) IS  
    SELECT SUM(NVL(MONTO,0)) FROM ARCPRD R
    WHERE R.NO_CIA=pCia AND R.IND_PROCESADO='S' AND R.TIPO_DOC NOT IN ('CK','TR')
    AND R.NO_REFE=P_NO_DOCU_REFE AND FEC_APLIC <= pFechaCorte;

  -- DOCUMENTOS REACIONADOS EN ARCKRD Y DE LOS CUALES DEBO DETERMINAR SI ESTAN ANULADOS 
  CURSOR C_APLICACIONES_CK (P_NO_DOCU_REFE VARCHAR2) IS  
    SELECT TIPO_DOCU, NO_SECUENCIA, MONTO FROM ARCKRD R
    WHERE R.NO_CIA=pCia AND R.NO_REFE= P_NO_DOCU_REFE;

  -- SE REQUIERE PARA LOS 3 CASOS DE DUPLICIDAD 
  CURSOR C_DUPLICIDAD_REFERENCIA_CP (P_NO_DOCU_CP VARCHAR2, P_NO_DOCU_CK VARCHAR2) IS    
    SELECT NO_REFE REFE_CP,  NO_DOCU REFE_CK,  FEC_APLIC,  MONTO FROM ARCPRD 
    WHERE NO_CIA=pCia AND TIPO_REFE <> 'AO' AND NO_REFE = P_NO_DOCU_CP AND NO_DOCU= P_NO_DOCU_CK;
    --SELECT NO_DOCU,NO_REFE,COUNT(*) FROM ARCPRD WHERE NO_CIA=10 GROUP BY NO_DOCU,NO_REFE HAVING COUNT(*) > 1;
    
  -- PREGUNTO SI EXISTE EN ARCPRD Y SACO LA FECHA PARA DETERMINAR SI ACUMULO, SE AUMENTA PARAMETRO DE FECHA 
  CURSOR C_VALIDA_APLICACION_CP (P_NO_DOCU_CP VARCHAR2, P_NO_DOCU_CK VARCHAR2, P_MONTO VARCHAR2) IS--(P_NO_DOCU_CP VARCHAR2, P_NO_DOCU_CK VARCHAR2) IS    
    SELECT FEC_APLIC, MONTO FROM ARCPRD 
    WHERE NO_CIA=pCia AND TIPO_REFE <> 'AO' AND NO_REFE = P_NO_DOCU_CP 
    AND NO_DOCU= P_NO_DOCU_CK AND MONTO=P_MONTO;
  
  -- SI NO LO ENCUENTRO LO BUSCO CON RELACION A UN DOCUMENTO DE ANULACION
  CURSOR C_VALIDA_APLICACION_ANUL (P_NO_DOCU_REFE VARCHAR2, P_NO_DOCU_CK VARCHAR2) IS    
    --SELECT FECHA, MONTO  FROM ARCPMD WHERE NO_CIA=pCia AND N_DOCU_A = P_NO_DOCU_CK;
    SELECT M.FECHA, R.MONTO  FROM  ARCKRD R, ARCPMD M
    WHERE R.NO_CIA=pCia AND R.NO_REFE= P_NO_DOCU_REFE AND R.NO_SECUENCIA= P_NO_DOCU_CK
    AND R.NO_CIA=M.NO_CIA AND TO_CHAR(R.NO_SECUENCIA)=M.N_DOCU_A;

  -- Declaraciones de variables
  Lv_Parametros       VARCHAR2(4000);
  Linea_Registro      VARCHAR2(4000);
  Ln_secuencia        NUMBER := 0;
  Ld_fecha_doc_anul   date;
  Ln_aplicado_CP      Number(17,2);
  Ln_aplicado_CK      Number(17,2);  
  Ln_saldo_actual     Number(17,2); 
  Ld_FEC_APLIC_CP     date;
  Ln_MONTO_CP         Number(17,2);
  Ld_FEC_APLIC_ANUL   date;
  Ln_MONTO_ANUL       Number(17,2);
  Ln_aplicado         Number(17,2);
 
BEGIN
 --Encabezado
  Lv_Parametros := 'COMPANIA:' || ';' || pNombreCia;
  Ln_secuencia := Ln_secuencia + 1;
  INSERT INTO ARCPREPORTE_SALDOS_ANTICIPOS (no_cia, usuario, consulta, secuencia,  dato)
                                    VALUES (pCia,   user, pConsulta, Ln_secuencia, Lv_Parametros);
  --
  Lv_Parametros := 'REPORTE DE MONTOS POR PAGAR :' || ';' || pNombreGrupo;
  Ln_secuencia := Ln_secuencia + 1;
  INSERT INTO ARCPREPORTE_SALDOS_ANTICIPOS (no_cia, usuario, consulta, secuencia,  dato)
                                    VALUES (pCia,   user, pConsulta, Ln_secuencia, Lv_Parametros);
  --
  Lv_Parametros := 'CORTE AL :'|| to_char(pFechaCorte,'DD/MM/YYYY');
  Ln_secuencia := Ln_secuencia + 1;
  INSERT INTO ARCPREPORTE_SALDOS_ANTICIPOS (no_cia, usuario, consulta, secuencia,  dato)
                                    VALUES (pCia,   user, pConsulta, Ln_secuencia, Lv_Parametros);
  --
  Lv_Parametros := 'DESDE EL PROVEEDOR :' || ';' || pDesde || ';' || 'HASTA EL PROVEEDOR :' || ';' || pHasta ;
  Ln_secuencia := Ln_secuencia + 1;
  INSERT INTO ARCPREPORTE_SALDOS_ANTICIPOS (no_cia, usuario, consulta, secuencia,  dato)
                                    VALUES (pCia,   user, pConsulta, Ln_secuencia, Lv_Parametros);
    --     
  Lv_Parametros := 'PROVEEDOR'||';'||'NOMBRE'||';'||'TIPO'||';'||'TRANSACCION'||';'||'NO.FISICO'||';'||
                    'SERIE'||';'||'FECHA'||';'||'MONTO'||';'||'APLICADO'||';'||'SALDO'||';'||'DETALLE';
  Ln_secuencia := Ln_secuencia + 1;
  INSERT INTO ARCPREPORTE_SALDOS_ANTICIPOS (no_cia, usuario, consulta, secuencia,  dato)
                                    VALUES (pCia,   user, pConsulta, Ln_secuencia, Lv_Parametros);

  -- OBTENER TODOS LOS DOCUMENTOS ANTERIORES A LA FECHA INDICADA Y EL GRUPO. 
  For p in C_MOVIMIENTOS_PROVEEDORES loop
      --
      Ln_aplicado     := 0; 
      Ln_saldo_actual := 0;  -- acumulo por documento de proveedor
       Ln_aplicado_CP := 0;
       Ln_aplicado_CK := 0;
      --
      -- TENER EN CUENTA SI EL DOCUMENTO ESTA ANULADO Y EN QUE FECHA SE ANULO, SI ESTA ANULADO ANTES DE LA FECHA INDICADA NO LO PRESENTO,
      -- CASO CONTRARIO BUSCO TODOS LOS VALORES APLICADOS AL DOCUMENTO.             
       IF C_ANULADO%ISOPEN THEN CLOSE C_ANULADO; END IF;
       OPEN  C_ANULADO (p.no_docu);
       FETCH C_ANULADO INTO Ld_fecha_doc_anul;
       --
       If C_ANULADO%Found  and Ld_fecha_doc_anul <= pFechaCorte Then
         CLOSE C_ANULADO;
             --- Al estar anulado el documento no realiza ningun calculo
             Ln_saldo_actual := 0;
             null;         
       Else  
             --- Al NO estar anulado el documento se realiza calculo            
         CLOSE C_ANULADO;
         --
         --****************************************************************
           -- APLICADO DESDE CUENTAS POR PAGAR (ARCPRD) 
           --****************************************************************
           --Ln_aplicado_CP := 0;           
          IF C_APLICACIONES_CP%ISOPEN THEN CLOSE C_APLICACIONES_CP;  END IF;
          OPEN  C_APLICACIONES_CP (p.no_docu);
          FETCH C_APLICACIONES_CP INTO Ln_aplicado_CP; 
          CLOSE C_APLICACIONES_CP;  
         --
         --****************************************************************
           -- APLICADO DESDE CxP (SALDO A FAVOR) Y EN BANCOS (ARCKRD) 
           --****************************************************************       
           -- DOCUMENTOS REACIONADOS EN ARCKRD Y DE LOS CUALES DEBO DETERMINAR SI ESTAN ANULADOS   
           Ln_aplicado_CK := 0;

          For b in C_APLICACIONES_CK (p.no_docu)  Loop
            --
            Ln_MONTO_ANUL := 0;
            Ln_MONTO_CP   := 0;
            --
            -- PARA CASOS DE 2 REGISTROS DE LA MISMA FACTURA CON EL MISMO CHEQUE EN ARCPRD
            For O in C_DUPLICIDAD_REFERENCIA_CP (p.no_docu, b.no_secuencia) Loop
                -- NO_REFE REFE_CP,  NO_DOCU REFE_CK,  FEC_APLIC,  MONTO,  FEC_APLIC 
                  --
                  -- PREGUNTO SI EXISTE EN ARCPRD Y SACO LA FECHA PARA DETERMINAR SI ACUMULO 
                  Open  C_VALIDA_APLICACION_CP (O.REFE_CP,  O.REFE_CK, O.MONTO);--(p.no_docu, b.no_secuencia);
                  Fetch C_VALIDA_APLICACION_CP into Ld_FEC_APLIC_CP, Ln_MONTO_CP;
    
                  If C_VALIDA_APLICACION_CP%found  and  Ld_FEC_APLIC_CP <= pFechaCorte  Then
                   Close C_VALIDA_APLICACION_CP;
                   Ln_aplicado_CK := nvl(Ln_aplicado_CK,0) + nvl(Ln_MONTO_CP,0);
                 else  
                   Close C_VALIDA_APLICACION_CP;
                 
                  -- SI NO LO ENCUENTRO LO BUSCO CON RELACION A UN DOCUMENTO DE ANULACION
                  Open  C_VALIDA_APLICACION_ANUL (O.REFE_CP,  O.REFE_CK); --(p.no_docu, b.no_secuencia); 
                  Fetch C_VALIDA_APLICACION_ANUL into Ld_FEC_APLIC_ANUL, Ln_MONTO_ANUL;
                  --
                  If C_VALIDA_APLICACION_ANUL%FOUND  and  Ld_FEC_APLIC_ANUL <= pFechaCorte  Then
                    Close C_VALIDA_APLICACION_ANUL;                               
                    
                  else             
                     Close C_VALIDA_APLICACION_ANUL; 
                     Ln_aplicado_CK := nvl(Ln_aplicado_CK,0) + nvl(Ln_MONTO_ANUL,0);   
                    
                   End if;                 
                 End if;
              End Loop;  -- C_DUPLICIDAD_REFERENCIA_CP
          End Loop;  -- C_APLICACIONES_CK         
          --
          Ln_aplicado     := nvl(Ln_aplicado_CP,0) + nvl(Ln_aplicado_CK,0);  
          Ln_saldo_actual := NVL(P.MONTO,0) - NVL(Ln_aplicado,0); 
          --
          If Ln_saldo_actual <> 0 Then
            
             Linea_Registro := ''''||P.NO_PROVE||';'||P.NOMBRE||';'||P.TIPO_DOC||';'||P.NO_DOCU||';'||P.NO_FISICO||';'||
                               P.SERIE_FISICO||';'||to_char(P.FECHA,'DD/MM/YYYY')||';'||P.MONTO||';'||Ln_aplicado||';'||Ln_saldo_actual||';'||
                               RTRIM( REPLACE (REPLACE( REPLACE(REPLACE(REPLACE(P.DETALLE,'.','') ,CHR(10) ,'') ,CHR(13),''),',',''),'"','' )  );                                
             Ln_secuencia := Ln_secuencia + 1;
             INSERT INTO ARCPREPORTE_SALDOS_ANTICIPOS (no_cia, usuario, consulta, secuencia,  dato)
                                               VALUES (pCia,   user, pConsulta, Ln_secuencia, Linea_Registro);                                 
         End if;
         --       
      End if;
      --
    End loop;  -- C_MOVIMIENTOS_PROVEEDORES
end CPSALDO_FECHA;