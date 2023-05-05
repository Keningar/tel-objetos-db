create or replace PROCEDURE            PL_NOTIFICA_FINALIZACION_CONTR IS

  CURSOR C_NOTIFICACION_CONTRATOS (Cv_NoCia VARCHAR2) IS
    SELECT A.NO_EMPLE,
           A.NOMBRE,
           A.F_INGRESO,
           A.F_FIN_CONTRATO,
           A.CONDICION,
           A.ESTADO,
           A.TIPO
      FROM (-- Contrato Prueba Legal se envia correo:
            -- 15 dias antes de cumplir 90 dias calendarios
            -- 45 dias antes de cumplir contrato
            SELECT NO_EMPLE, NOMBRE, F_INGRESO, F_FIN_CONTRATO,
                   'PRUEBA LEGAL' CONDICION, ESTADO,
                   DECODE(DECODE((F_INGRESO+75), TRUNC(SYSDATE), 15, 0),0,DECODE((F_FIN_CONTRATO-45), TRUNC(SYSDATE), 45, 0)) TIPO
              FROM ARPLME
             WHERE ESTADO = 'A'
               AND CONDICION = 'L'
               AND NO_CIA = Cv_NoCia
             UNION
            -- Contrato Fijo se envia correo:
            -- 45 dias antes de cumplir contrato
            SELECT NO_EMPLE, NOMBRE, F_INGRESO, F_FIN_CONTRATO, 'FIJO' CONDICION, ESTADO,
                   DECODE((F_FIN_CONTRATO-45), TRUNC(SYSDATE), 45, 0) TIPO

              FROM ARPLME
             WHERE ESTADO = 'A'
               AND CONDICION = 'C'
               AND NO_CIA = Cv_NoCia
             UNION
            -- Contrato Eventual se envia correo:
            -- eventual 30 dias,  7 dias antes de cumplir contrato
            SELECT NO_EMPLE, NOMBRE, F_INGRESO, F_FIN_CONTRATO,
                   'TEMPORAL 30 DIAS' CONDICION, ESTADO,
                   DECODE((F_FIN_CONTRATO-7), TRUNC(SYSDATE), 7, 0) TIPO
              FROM ARPLME
             WHERE ESTADO = 'A'
               AND CONDICION = 'T'
               AND NO_CIA = Cv_NoCia
               AND ABS(F_FIN_CONTRATO - ADD_MONTHS(F_INGRESO,1)) <= 5 /* fecha fin real puede caer fin de semana o feriado max de 5 dias*/
             UNION
            -- Contrato Eventual se envia correo:
            -- eventual 60 dias, 15 dias antes de cumplir contrato
            SELECT NO_EMPLE, NOMBRE, F_INGRESO, F_FIN_CONTRATO,
                   'TEMPORAL 60 DIAS' CONDICION,
                   ESTADO,
                   DECODE((F_FIN_CONTRATO-15), TRUNC(SYSDATE), 15, 0) TIPO
              FROM ARPLME
             WHERE ESTADO = 'A'
               AND CONDICION = 'T'
               AND NO_CIA = Cv_NoCia
               AND ABS(F_FIN_CONTRATO - ADD_MONTHS(F_INGRESO,2)) <= 5 ) A /* fecha fin real puede caer fin de semana o feriado max de 5 dias*/
   WHERE A.TIPO != 0
   ORDER BY A.TIPO;
  --
  CURSOR C_REGISTROS_SIN_FECHAFIN (Cv_NoCia VARCHAR2) IS
    SELECT NO_EMPLE,
           NOMBRE,
           F_INGRESO,
           F_FIN_CONTRATO,
           DECODE(CONDICION, 'C','FIJO','T','TEMPORAL','L','PRUEBA LEGAL') CONDICION,
           ESTADO
      FROM ARPLME
     WHERE ESTADO = 'A'
       AND CONDICION IN ('C','T','L')
       AND F_FIN_CONTRATO IS NULL
       AND NO_CIA = Cv_NoCia
     ORDER BY CONDICION, NO_EMPLE;
  --
  CURSOR C_REGISTROS_FFIN_VENCIDO (Cv_NoCia VARCHAR2) IS
    SELECT NO_EMPLE,
           NOMBRE,
           F_INGRESO,
           F_FIN_CONTRATO,
           DECODE(CONDICION, 'C','FIJO','T','TEMPORAL','L','PRUEBA LEGAL') CONDICION,
           ESTADO
      FROM ARPLME
     WHERE ESTADO = 'A'
       AND CONDICION IN ('C','T','L')
       AND F_FIN_CONTRATO > TRUNC(SYSDATE)
       AND NO_CIA = Cv_NoCia;

  --
  Lr_DatosCorreo  GE_CORREO_ELECTRONICO.R_DATOS_CORREO := NULL;
  Lv_CuerpoCorreo LONG := NULL;
  Ln_Tipo         NUMBER(3) := 0;
  Ln_SinFechaFin  NUMBER(6) := 0;
  Ln_FFinVencido  NUMBER(6) := 0;
  Lv_MensajeError VARCHAR2(3000) := NULL;
  --
  Le_ErrorProceso EXCEPTION;
  --
  Pv_NoCia        ARPLME.NO_CIA%TYPE := '10'; --solo se ejecutara para empresa Telconet
BEGIN
  -- Se setan los valores fijos para este envio de correo
  Lr_DatosCorreo.SERVIDOR_SMTP := 'sissmtp-int.telconet.net';
  Lr_DatosCorreo.REMITENTE := 'rrhh@telconet.net';-- en desarrollo queda configurado la cuenta llindao
  Lr_DatosCorreo.DESTINATARIO := 'rrhh@telconet.net';-- en desarrollo queda configurado la cuenta llindao
  Lr_DatosCorreo.COPIA_OCULTA := 'llindao@telconet.net';-- temporal hasta que este estabilizado.
  Lr_DatosCorreo.ASUNTO := 'NAF - Vencimientos de Contratos Laborales';
  -- Ingreso del Cuerpo del Correo
  Lv_CuerpoCorreo := '<html><head>';
  Lv_CuerpoCorreo := Lv_CuerpoCorreo || '<style type="text/css"> ';
  Lv_CuerpoCorreo := Lv_CuerpoCorreo || '<!-- ';
  Lv_CuerpoCorreo := Lv_CuerpoCorreo || '.Estilo10 {font-size: 12pt;  font-family:calibri;} ';
  Lv_CuerpoCorreo := Lv_CuerpoCorreo || '.Estilo11 {font-size: 10pt;  font-family:verdana; font-weight: bold; } ';
  Lv_CuerpoCorreo := Lv_CuerpoCorreo || '.Estilo13 {font-size: 11pt; font-family: calibri; font-weight: bold; color: #000000; } ';
  Lv_CuerpoCorreo := Lv_CuerpoCorreo || '.Estilo14 {font-family: calibri; font-weight: bold; font-size: 12pt;} ';
  Lv_CuerpoCorreo := Lv_CuerpoCorreo || '.Estilo12 {font-family: Arial; font-weight: bold; font-size: 14px;} ';
  Lv_CuerpoCorreo := Lv_CuerpoCorreo || '--> ';
  Lv_CuerpoCorreo := Lv_CuerpoCorreo || '</style> ';
  Lv_CuerpoCorreo := Lv_CuerpoCorreo || '</head> ';
  Lv_CuerpoCorreo := Lv_CuerpoCorreo || '<body> ';
  Lv_CuerpoCorreo := Lv_CuerpoCorreo || '<p class="Estilo10">Se informa que esta por  vencer los contratos de los siguientes empleados en las fechas indicadas: </p> ';

  FOR Lr_ContVencidos IN C_NOTIFICACION_CONTRATOS (Pv_NoCia) LOOP
    IF Ln_Tipo != Lr_ContVencidos.TIPO THEN

      IF Ln_Tipo != 0 THEN -- por primera vez no debe ejecutarse esto
        Lv_CuerpoCorreo := Lv_CuerpoCorreo || '</table> ';
        Lv_CuerpoCorreo := Lv_CuerpoCorreo || '<p>;</p> ';
      END IF;

      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '<span class="Estilo11">Por vencer en '||Lr_ContVencidos.TIPO||' dias</span> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '<table width="688" border="1" bordercolor="#FFFFFF" bgcolor="#00CCFF"> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '  <tr> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th width="66" rowspan="2" align="center" bordercolor="#000000" class="Estilo12" scope="col">C;DIGO</th> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th width="366" rowspan="2" align="center" bordercolor="#000000" class="Estilo12" scope="col">NOMBRE</th> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th width="150" rowspan="2" align="center" bordercolor="#000000" class="Estilo12" scope="col">CONDICION CONTRATO </th> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th colspan="2" align="center" bordercolor="#000000" class="Estilo12" scope="col">FECHAS</th> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '  </tr> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '  <tr> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th width="90" align="center" bordercolor="#000000" class="Estilo12" scope="col">INGRESO</th> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th width="110" align="center" bordercolor="#000000" class="Estilo12" scope="col">FIN CONTRATO </th> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '  </tr> ';
      Ln_Tipo := Lr_ContVencidos.TIPO;
    END IF;
    --
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '  <tr bordercolor="#000000" bgcolor="#FFFFFF"> ';
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th align="center" class="Estilo13" scope="col">'||Lr_ContVencidos.NO_EMPLE||'</th> ';
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th align="left" class="Estilo13" scope="col">'||Lr_ContVencidos.NOMBRE||'</th> ';
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th align="center" class="Estilo13" scope="col">'||Lr_ContVencidos.CONDICION||'</th> ';
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <td align="center" class="Estilo13">'||TRIM(TO_CHAR(Lr_ContVencidos.F_INGRESO,'YYYY/MM/DD'))||'</td> ';
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <td align="center" class="Estilo13">'||TRIM(TO_CHAR(Lr_ContVencidos.F_FIN_CONTRATO,'YYYY/MM/DD'))||'</td> ';
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '  </tr> ';
  END LOOP; -- fin contratos por vencer

  IF Ln_Tipo != 0 THEN -- se presentaron registros
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '</table> ';
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '<p>;</p> ';
  END IF;

  -- se buscan registros inconsistentes sin fecha fin contrato
  FOR Lr_SinFechaFin IN C_REGISTROS_SIN_FECHAFIN (Pv_NoCia) LOOP
    IF Ln_SinFechaFin = 0 THEN --Primer registro, se imprimen Etiquetas
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '<span class="Estilo11">Empleados sin Fecha Final de Contrato</span> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '<table width="688" border="1" bordercolor="#FFFFFF" bgcolor="#00CCFF"> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '  <tr> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th width="66" rowspan="2" align="center" bordercolor="#000000" class="Estilo12" scope="col">C;DIGO</th> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th width="366" rowspan="2" align="center" bordercolor="#000000" class="Estilo12" scope="col">NOMBRE</th> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th width="150" rowspan="2" align="center" bordercolor="#000000" class="Estilo12" scope="col">CONDICION CONTRATO </th> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th colspan="2" align="center" bordercolor="#000000" class="Estilo12" scope="col">FECHAS</th> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '  </tr> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '  <tr> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th width="90" align="center" bordercolor="#000000" class="Estilo12" scope="col">INGRESO</th> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th width="110" align="center" bordercolor="#000000" class="Estilo12" scope="col">FIN CONTRATO </th> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '  </tr> ';
    END IF;
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '  <tr bordercolor="#000000" bgcolor="#FFFFFF"> ';
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th align="center" class="Estilo13" scope="col">'||Lr_SinFechaFin.NO_EMPLE||'</th> ';
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th align="left" class="Estilo13" scope="col">'||Lr_SinFechaFin.NOMBRE||'</th> ';
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th align="center" class="Estilo13" scope="col">'||Lr_SinFechaFin.CONDICION||'</th> ';
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <td align="center" class="Estilo13">'||TRIM(TO_CHAR(Lr_SinFechaFin.F_INGRESO,'YYYY/MM/DD'))||'</td> ';
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <td align="center" class="Estilo13">'||TRIM(TO_CHAR(Lr_SinFechaFin.F_FIN_CONTRATO,'YYYY/MM/DD'))||'</td> ';
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '  </tr> ';
    Ln_SinFechaFin := Ln_SinFechaFin  + 1; -- control de registros presentados
  END LOOP; -- fin empleados sin fecha fin contrato

  IF Ln_SinFechaFin != 0 THEN -- se presentaron registros
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '</table> ';
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '<p>;</p> ';
  END IF;

  -- se buscan registros inconsistentes sin fecha fin contrato
  FOR Lr_FFinVencido IN C_REGISTROS_FFIN_VENCIDO (Pv_NoCia) LOOP
    IF Ln_FFinVencido = 0 THEN --Primer registro, se imprimen Etiquetas
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '<span class="Estilo11">Empleados con Fecha Final de Contrato vencido</span> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '<table width="688" border="1" bordercolor="#FFFFFF" bgcolor="#00CCFF"> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '  <tr> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th width="66" rowspan="2" align="center" bordercolor="#000000" class="Estilo12" scope="col">C;DIGO</th> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th width="366" rowspan="2" align="center" bordercolor="#000000" class="Estilo12" scope="col">NOMBRE</th> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th width="150" rowspan="2" align="center" bordercolor="#000000" class="Estilo12" scope="col">CONDICION CONTRATO </th> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th colspan="2" align="center" bordercolor="#000000" class="Estilo12" scope="col">FECHAS</th> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '  </tr> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '  <tr> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th width="90" align="center" bordercolor="#000000" class="Estilo12" scope="col">INGRESO</th> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th width="110" align="center" bordercolor="#000000" class="Estilo12" scope="col">FIN CONTRATO </th> ';
      Lv_CuerpoCorreo := Lv_CuerpoCorreo || '  </tr> ';
    END IF;
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '  <tr bordercolor="#000000" bgcolor="#FFFFFF"> ';
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th align="center" class="Estilo13" scope="col">'||Lr_FFinVencido.NO_EMPLE||'</th> ';
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th align="left" class="Estilo13" scope="col">'||Lr_FFinVencido.NOMBRE||'</th> ';
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <th align="center" class="Estilo13" scope="col">'||Lr_FFinVencido.CONDICION||'</th> ';
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <td align="center" class="Estilo13">'||TRIM(TO_CHAR(Lr_FFinVencido.F_INGRESO,'YYYY/MM/DD'))||'</td> ';
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '    <td align="center" class="Estilo13">'||TRIM(TO_CHAR(Lr_FFinVencido.F_FIN_CONTRATO,'YYYY/MM/DD'))||'</td> ';
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '  </tr> ';
    Ln_FFinVencido := Ln_FFinVencido + 1;
  END LOOP; -- fin empleados sin fecha fin contrato

  IF Ln_FFinVencido != 0 THEN -- se presentaron registros
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '</table> ';
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '<p>;</p> ';
  END IF;

  IF Ln_Tipo != 0 OR
    Ln_SinFechaFin != 0 OR
    Ln_FFinVencido != 0 THEN
    -- fin de correo
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '<p class="Estilo14">Este correo ha sido  generado autom;ticamente por el sistema NAF desde el M;dulo de N;mina.</p> ';
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '</body> ';
    Lv_CuerpoCorreo := Lv_CuerpoCorreo || '</html> ';

    Lr_DatosCorreo.CUERPO_CORREO := Lv_CuerpoCorreo;
    GE_CORREO_ELECTRONICO.GEP_ENVIAR_CORREO (Lr_DatosCorreo, Lv_MensajeError);
    IF Lv_MensajeError IS NOT NULL THEN
      RAISE Le_ErrorProceso;
    END IF;
  ELSE
    DBMS_OUTPUT.PUT_LINE ('No hubo datos que enviar por correo');
  END IF;

EXCEPTION
  WHEN Le_ErrorProceso THEN
    DBMS_OUTPUT.PUT_LINE (Lv_MensajeError);
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE ('Error en PL_NOTIFICA_FINALIZACION_CONTRATOS. '||SQLERRM);
END PL_NOTIFICA_FINALIZACION_CONTR;