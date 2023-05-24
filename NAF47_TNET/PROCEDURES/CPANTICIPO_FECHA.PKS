CREATE OR REPLACE procedure NAF47_TNET.CPANTICIPO_FECHA  (pCia         arcgae.no_cia%type,
                                               pNombreCia   arcgmc.nombre%type,
                                               pNombreGrupo arcpgr.descripcion%type,
                                               pConsulta    VARCHAR2,
                                               pDesde       arcpmp.no_prove%type,
                                               pHasta       arcpmp.no_prove%type,
                                               pFechaCorte  DATE,
                                               pGrupo       arcpmp.grupo%type,
                                               pMsg_error   OUT VARCHAR2    ) IS

  -- OBTENER TODOS LOS DOCUMENTOS ANTERIORES A LA FECHA INDICADA Y EL GRUPO. 
  CURSOR C_PAGOS_ANTICIPOS_PROVEEDORES IS        
    SELECT P.NO_PROVE, P.NOMBRE, M.TIPO_DOC, M.NO_DOCU, M.IND_ACT, M.NO_FISICO, M.SERIE_FISICO, 
           M.FECHA, M.MONTO, M.SALDO, M.ANULADO, M.FECHA_ANULA, M.N_DOCU_A
    FROM ARCPMD M, ARCPMP P
    WHERE M.NO_CIA = pCia AND M.TIPO_DOC IN ('CK','TR','CI')  
    AND m.no_prove BETWEEN pDesde AND pHasta
    AND M.IND_ACT<>'P' AND M.FECHA <= pFechaCorte
    AND M.NO_CIA=P.NO_CIA AND M.NO_PROVE=P.NO_PROVE AND P.GRUPO=pGrupo ORDER BY P.NOMBRE, M.FECHA; 

  -- TENER EN CUENTA SI EL DOCUMENTO ESTA ANULADO Y EN QUE FECHA SE ANULO, SI ESTA ANULADO ANTES DE LA FECHA INDICADA NO LO PRESENTO,
  -- CASO CONTRARIO BUSCO TODOS LOS VALORES APLICADOS AL DOCUMENTO.
  CURSOR C_ANULADO (P_NO_DOCU VARCHAR2) IS  
    SELECT M.FECHA --M.TIPO_DOC, M.NO_DOCU, M.IND_ACT, M.FECHA, M.MONTO, M.ANULADO, M.FECHA_ANULA, M.N_DOCU_A, M.DETALLE
    FROM  ARCPMD M
    WHERE M.NO_CIA=pCia AND M.N_DOCU_A = P_NO_DOCU;

  -- YA QUE EL DOCUMENTO NO TIENE UNA ANULACION ASOCIADA PROCEDO A OBTENER LA SUMA 
  -- DE DOCUMENTOS APLICADOS ANTERIORES A LA FECHA INDICADA DE ARCPRD
  CURSOR C_APLICACIONES_CP (P_NO_DOCU_REFE VARCHAR2) IS  
    SELECT SUM(NVL(MONTO,0)) 
    FROM ARCPRD R     
    WHERE R.NO_CIA = pCia AND R.IND_PROCESADO='S' 
    AND R.NO_DOCU = P_NO_DOCU_REFE  AND FEC_APLIC <= pFechaCorte;    

  -- DOCUMENTOS REACIONADOS EN ARCKRD Y DE LOS CUALES DEBO DETERMINAR SI ESTAN ANULADOS O NO
  CURSOR C_APLICACIONES_CK (P_NO_DOCU_CK VARCHAR2) IS  
    SELECT NO_REFE, MONTO --, TIPO_REFE 
    FROM ARCKRD R
    WHERE R.NO_CIA = pCia AND R.NO_SECUENCIA = P_NO_DOCU_CK; 
  
  -- BUSCO ANIO Y MES EN EL POSIBLE ASIENTO CONTABLE GENERADO EN LA APLICACION DE SALDOS
  CURSOR C_DC_DE_APLICACION (P_NO_DOCU_CK VARCHAR2, P_MONTO NUMBER) IS  
    SELECT ANO, MES FROM ARCPDC 
    WHERE NO_CIA = pCia  AND TIPO='D' AND NO_DOCU= P_NO_DOCU_CK AND MONTO = P_MONTO;

  -- FECHA EN QUE SE INGRESO LA FACTURA Y ASUME QUE SE APLICA EN LA FECHA DEL REGISTRO
  CURSOR C_FECHA_DOC_CP (P_NO_DOCU_CP VARCHAR2) IS      
    SELECT FECHA FROM ARCPMD 
    WHERE NO_CIA = pCia  AND NO_DOCU = P_NO_DOCU_CP;  

  -- COMENTARIO DEL DOCUMENTO 
  CURSOR C_DESCRIPCION_DOCUMENTO (P_NO_DOCU_CK VARCHAR2) IS          
    SELECT COM FROM ARCKCE WHERE NO_CIA = pCia AND NO_SECUENCIA=P_NO_DOCU_CK
    UNION
    SELECT DETALLE FROM ARCPMD WHERE NO_CIA = pCia AND NO_DOCU=P_NO_DOCU_CK AND DETALLE IS NOT NULL;

  -- Declaraciones de variables
  Linea_Registro      VARCHAR2(4000);
  Lv_Parametros       VARCHAR2(4000);
  Ln_secuencia        NUMBER := 0;
  Ld_fecha_doc_anul   date;
  Ln_aplicado_CP      Number(17,2);
  Ln_saldo_actual     Number(17,2); 
  Ln_aplicado         Number(17,2);
  Ln_anio_dc          Number(17,2);  
  Ln_mes_dc           Number(17,2);  
  Ld_fecha_cp         arcpmd.fecha%type;
  Lv_descripcion      VARCHAR2(240);
  
BEGIN
  --Encabezado
  Lv_Parametros := 'COMPANIA:' || ';' || pNombreCia;
  Ln_secuencia := Ln_secuencia + 1;
  INSERT INTO ARCPREPORTE_SALDOS_ANTICIPOS (no_cia, usuario, consulta, secuencia,  dato)
                                    VALUES (pCia,   user, pConsulta, Ln_secuencia, Lv_Parametros);
  --
  Lv_Parametros := 'REPORTE DE MONTOS NO APLICADOS :' || ';' || pNombreGrupo;
  Ln_secuencia := Ln_secuencia + 1;
  INSERT INTO ARCPREPORTE_SALDOS_ANTICIPOS (no_cia, usuario, consulta, secuencia,  dato)
                                    VALUES (pCia,   user, pConsulta, Ln_secuencia, Lv_Parametros);
  --
  Lv_Parametros := 'CORTE AL :'|| to_char(pFechaCorte,'DD/MM/YYYY');
  Ln_secuencia := Ln_secuencia + 1;
  INSERT INTO ARCPREPORTE_SALDOS_ANTICIPOS (no_cia, usuario, consulta, secuencia,  dato)
                                    VALUES (pCia,   user, pConsulta, Ln_secuencia, Lv_Parametros);
  --   
  Lv_Parametros := 'PROVEEDOR'||';'||'NOMBRE'||';'||'TIPO'||';'||'TRANSACCION'||';'||'NO.FISICO'||';'||
                    'SERIE'||';'||'FECHA'||';'||'MONTO'||';'||'APLICADO'||';'||'SALDO'||';'||'DETALLE'; 
  Ln_secuencia := Ln_secuencia + 1;
  INSERT INTO ARCPREPORTE_SALDOS_ANTICIPOS (no_cia, usuario, consulta, secuencia,  dato)
                                    VALUES (pCia,   user, pConsulta, Ln_secuencia, Lv_Parametros);
   --
  -- OBTENER TODOS LOS DOCUMENTOS ANTERIORES A LA FECHA INDICADA Y EL GRUPO. 
  For p in C_PAGOS_ANTICIPOS_PROVEEDORES loop
      --
      Ln_aplicado    := 0; 
      Ln_aplicado_CP := 0;
      --
      -- TENER EN CUENTA SI EL DOCUMENTO ESTA ANULADO Y EN QUE FECHA SE ANULO, SI ESTA ANULADO ANTES DE LA FECHA INDICADA NO LO PRESENTO,
      -- CASO CONTRARIO BUSCO TODOS LOS VALORES APLICADOS AL DOCUMENTO.             
       IF C_ANULADO%ISOPEN THEN CLOSE C_ANULADO; END IF;
       OPEN  C_ANULADO (p.no_docu);
       FETCH C_ANULADO INTO Ld_fecha_doc_anul;  
       --
       If C_ANULADO%Found  and Ld_fecha_doc_anul <= pFechaCorte Then
         CLOSE C_ANULADO;
             -- Al estar anulado el documento antes de la fecha indicada entonces NO realiza ningun calculo
             -- (todas sus referencias estan borradas), CK/TR = 0, no se presenta en el reporte
             Ln_aplicado := 0;
             Ln_saldo_actual  := 0;
             null;    
    
       Elsif C_ANULADO%Found  and Ld_fecha_doc_anul >= pFechaCorte Then
           CLOSE C_ANULADO;
           -- La fecha de borrado es superior a lo fecha indicada, entonces la referencia en ARCPRD se elimino y no 
           -- tengo la fecha de referencia de cuando se cruzaron los documentos. Por lo pronto nos apegaremos a lo
           -- acordado con BMontero y en este caso asumiremos que apenas llego la factura o se creo el CK/TR estos se saldaron.
           --
           -- No hay registros en ARCPRD por lo cual tengo que ir a ARCKRD pero alli no tengo fecha de aplicacion, por cada
           -- documento a revisar tengo 2 opciones:
           For b in C_APLICACIONES_CK (p.no_docu)  Loop
               --
               Ln_aplicado := 0;
               --
               -- Hacia el pasado que documentos fueron aplicados al CK/TR
               -- 1.- Por monto buscar en la DC del CK/TR, si lo encuentro me traigo el mes y anio
               OPEN C_DC_DE_APLICACION (p.no_docu, p.monto);
               FETCH C_DC_DE_APLICACION INTO Ln_anio_dc, Ln_mes_dc;   -- SON NUMBER
               --
               If C_DC_DE_APLICACION%Found  Then
                    CLOSE C_DC_DE_APLICACION; 
                    --
                    -- Si la fecha encontrada en DC es inferior a la fecha del filtro, debo de sumarizar
                    If last_day(to_date(to_char(Ln_mes_dc,'FM00')||to_char(Ln_anio_dc,'FM0000'), 'MMYYYY')) <= pFechaCorte  Then
                        Ln_aplicado := Ln_aplicado + nvl(b.monto,0);                        
                    else
                         -- la fecha es superior a la indicada por el usuario, no sumarizo.                       
                         null;
                    End if;               
                ELSE              
                    CLOSE C_DC_DE_APLICACION; 
                    -- 2.- Si lo no localizo en la DC asumire que el documento se aplico en el mes y anio de su registro
                    -- tener en cuenta si la fecha del CK/TR es menor o mayor a la factura.
                    OPEN C_FECHA_DOC_CP (b.no_refe);
                    FETCH C_FECHA_DOC_CP INTO Ld_fecha_cp; 
                    CLOSE C_FECHA_DOC_CP;
                    --
                    If p.fecha >= Ld_fecha_cp  Then --fecha del CK/TR es mayor al de la factura, para comparar cojo la fecha del CK/TR 
                       --
                       If p.fecha <= pFechaCorte  Then
                             Ln_aplicado := Ln_aplicado + nvl(b.monto,0);                        
                       else
                             -- la fecha es superior a la indicada por el usuario, no sumarizo                       
                             null;
                       End if;     
                       --
                    else
                       -- fecha del CK/TR es menor al de la factura, para comparar cojo la fecha de la facturaR 
                       If Ld_fecha_cp <= pFechaCorte  Then
                             Ln_aplicado := Ln_aplicado + nvl(b.monto,0);                        
                       else
                             -- la fecha es superior a la indicada por el usuario, no sumarizo                       
                             null;
                       End if;     
                       --                    
                    End if;
                   --     
               End if;
              --      
           End Loop;
         --
       else   -- NO TIENE ANULACION RELACIONADA EN NINGUN MOMENTO  
         CLOSE C_ANULADO;
          -- Al no haber "ningun anulacion" entonces leemos ARCPRD en donde tenemos la fecha de Aplicacion con la 
          -- cual podemos identificar en que momento se afecto el CK/TR
         --****************************************************************
           -- APLICADO DESDE CUENTAS POR PAGAR (ARCPRD) 
           --****************************************************************
           --Ln_aplicado_CP := 0;
          IF C_APLICACIONES_CP%ISOPEN THEN CLOSE C_APLICACIONES_CP;  END IF;
          OPEN  C_APLICACIONES_CP (p.no_docu);
          FETCH C_APLICACIONES_CP INTO Ln_aplicado;
          CLOSE C_APLICACIONES_CP;   
          --
          Ln_saldo_actual := NVL(P.MONTO,0) - NVL(Ln_aplicado,0);                       
          --
       End if; 
       --
         OPEN  C_DESCRIPCION_DOCUMENTO (p.no_docu);
           FETCH C_DESCRIPCION_DOCUMENTO into Lv_descripcion;
           CLOSE C_DESCRIPCION_DOCUMENTO;
           --
            If Ln_saldo_actual <> 0 Then
                      Linea_Registro := ''''||P.NO_PROVE||';'||P.NOMBRE||';'||P.TIPO_DOC||';'||P.NO_DOCU||';'||P.NO_FISICO||';'||
                                        P.SERIE_FISICO||';'||to_char(P.FECHA,'DD/MM/YYYY')||';'||P.MONTO||';'||Ln_aplicado||';'||Ln_saldo_actual||';'||
                                        RTRIM( REPLACE( REPLACE( REPLACE(REPLACE(REPLACE(Lv_descripcion,'.','') ,CHR(10) ,'') ,CHR(13),''),',','') ,'"','') );   
                 Ln_secuencia := Ln_secuencia + 1;
           INSERT INTO ARCPREPORTE_SALDOS_ANTICIPOS (no_cia, usuario, consulta, secuencia,  dato)
                                             VALUES (pCia,   user, pConsulta, Ln_secuencia, Linea_Registro);
       End if;            
            --
    End Loop;           
  
end CPANTICIPO_FECHA;
/