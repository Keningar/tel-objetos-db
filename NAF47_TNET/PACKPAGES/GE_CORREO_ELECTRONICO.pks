CREATE EDITIONABLE PACKAGE	           GE_CORREO_ELECTRONICO is

  -- Author  : LLINDAO
  -- Created : 16/06/2011 15:18:49

  -- Public type declarations
  TYPE R_DATOS_CORREO IS RECORD
    ( SERVIDOR_SMTP VARCHAR2(500),
     REMITENTE     VARCHAR2(32767),
     DESTINATARIO  VARCHAR2(32767),
     COPIA_CARBON  VARCHAR2(32767),
     COPIA_OCULTA  VARCHAR2(32767),
     ASUNTO        LONG,
     CUERPO_CORREO LONG
    );

  --Pv_NombreServidor CONSTANT  VARCHAR2(100) := 'sissmtp-int.telconet.net';
  Pn_Port           NUMBER := 25; /*  Numero de Puerto por el cual se envia correo */

  ------------------------------------------------------------
  -- Procedimiento principal que envia correos electronicos --
  ------------------------------------------------------------
  PROCEDURE GEP_ENVIAR_CORREO( Pr_DatosCorreos IN GE_CORREO_ELECTRONICO.R_DATOS_CORREO,
                               Pv_MensajeError IN OUT VARCHAR2);

  ----------------------------------------------------------
  -- Funcion que suprime los caracteres especiales que se --
  -- hayan agregado a las lista de correos electronicos   --
  ----------------------------------------------------------
  FUNCTION GEF_PREPARAR_LISTADO_CORREOS(Pv_Cadena VARCHAR2) RETURN VARCHAR2;

  ----------------------------------------------------------------
  -- Funcion que retorna un correo electronico de un listado de --
  -- correos electronicos concatenados en una cadena            --
  ----------------------------------------------------------------
  FUNCTION GEF_OBTIENE_DIRECCION(Pv_ListaEmail IN OUT VARCHAR2) RETURN VARCHAR2;
  
  PROCEDURE GEP_ENVIA_NOTIFICACION (Pv_CodPla IN VARCHAR2,
                                    Pv_DesCodPla IN VARCHAR2,
                                    Pv_NoCia IN Varchar2,
                                    Pv_MensajeError OUT VARCHAR2);
                                    
    /**
    * P_ENVIA_MAIL, procedimiento que realiza envio de correo adjunto pdf que se genera en el despacho de pedidos.
    *
    * @author Andr�s Astudillo <aastudillo@telconet.ec>
    * @version 25-03-2020
    * @since 1.0
    *
    * @param Pv_From            IN   VARCHAR2,
    * @param Pv_To              IN   VARCHAR2,
    * @param Pv_Subject         IN   VARCHAR2,
    * @param Pv_Body            IN   VARCHAR2,
    * @param Pv_Dir             IN   VARCHAR2,
    * @param Pv_NameFile        IN   VARCHAR2,
    * @param Pv_MensajeError    OUT  VARCHAR2
    */

    PROCEDURE P_ENVIA_MAIL_DESPACHO( Pv_From         IN  VARCHAR2,
                                     Pv_To           IN  VARCHAR2,
                                     Pv_Subject      IN  VARCHAR2,
                                     Pv_Body         IN  VARCHAR2,
                                     Pv_Dir          IN  VARCHAR2,
                                     Pv_NameFile     IN  VARCHAR2,
                                     Pv_MensajeError OUT VARCHAR2);

END GE_CORREO_ELECTRONICO;
/

CREATE EDITIONABLE PACKAGE BODY		                                                       GE_CORREO_ELECTRONICO IS

  -- Private type declarations
  --type <TypeName> is <Datatype>;

  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --<VariableName> <Datatype>;

  -- Function and procedure implementations
  PROCEDURE GEP_ENVIAR_CORREO( Pr_DatosCorreos IN GE_CORREO_ELECTRONICO.R_DATOS_CORREO,
                               Pv_MensajeError IN OUT VARCHAR2) IS

    Lv_Cabecera    VARCHAR2(4000) := NULL;
    Lv_Conexion    UTL_SMTP.CONNECTION;
    Lv_Crlf        VARCHAR2(2) := UTL_TCP.CRLF;
    Lr_DatosCorreo GE_CORREO_ELECTRONICO.R_DATOS_CORREO := NULL;
    --
    Le_ErrorProceso EXCEPTION;

  BEGIN
    IF Pr_DatosCorreos.REMITENTE IS NULL THEN
      Pv_MensajeError := 'No se ha ingresado remitente para envio de este correo.';
      RAISE Le_ErrorProceso;
    ELSIF Pr_DatosCorreos.DESTINATARIO IS NULL THEN
      Pv_MensajeError := 'No se ha ingresado Destinatario para envio de este correo.';
      RAISE Le_ErrorProceso;
    END IF;

    -- se quita los caracteres especiales del listado de correos electronicos
    IF Pr_DatosCorreos.REMITENTE IS NOT NULL THEN
      Lr_DatosCorreo.REMITENTE := GE_CORREO_ELECTRONICO.GEF_PREPARAR_LISTADO_CORREOS(Pr_DatosCorreos.REMITENTE);
    END IF;
    IF Pr_DatosCorreos.DESTINATARIO IS NOT NULL THEN
      Lr_DatosCorreo.DESTINATARIO := GE_CORREO_ELECTRONICO.GEF_PREPARAR_LISTADO_CORREOS(Pr_DatosCorreos.DESTINATARIO);
    END IF;
    IF Pr_DatosCorreos.COPIA_CARBON IS NOT NULL THEN
      Lr_DatosCorreo.COPIA_CARBON := GE_CORREO_ELECTRONICO.GEF_PREPARAR_LISTADO_CORREOS(Pr_DatosCorreos.COPIA_CARBON);
    END IF;
    IF Pr_DatosCorreos.COPIA_OCULTA IS NOT NULL THEN
      Lr_DatosCorreo.COPIA_OCULTA := GE_CORREO_ELECTRONICO.GEF_PREPARAR_LISTADO_CORREOS(Pr_DatosCorreos.COPIA_OCULTA);
    END IF;


    -- Abre Conexion
    Lv_Conexion := UTL_SMTP.OPEN_CONNECTION(Pr_DatosCorreos.SERVIDOR_SMTP, Pn_Port);

    Lv_Cabecera := 'MIME-Version: 1.0' || Lv_Crlf || --
                   'Content-type: text/html' || Lv_Crlf || --
                   'From:' || Lr_DatosCorreo.REMITENTE || Lv_Crlf || --
                   'Subject: ' || Pr_DatosCorreos.ASUNTO || Lv_Crlf || --
                   'To: ' || Lr_DatosCorreo.DESTINATARIO || Lv_Crlf || --
                   'CC: ' || Lr_DatosCorreo.COPIA_CARBON || Lv_Crlf || --
                   'CCO: ' || Lr_DatosCorreo.COPIA_OCULTA || Lv_Crlf || Lv_Crlf;

    UTL_SMTP.HELO(Lv_Conexion, Pr_DatosCorreos.SERVIDOR_SMTP);

    -- Configura Envia y Recibe con UTL_STMP
    WHILE (Lr_DatosCorreo.REMITENTE IS NOT NULL) LOOP
      UTL_SMTP.MAIL(Lv_Conexion, GE_CORREO_ELECTRONICO.GEF_OBTIENE_DIRECCION(Lr_DatosCorreo.REMITENTE));
    END LOOP;

    WHILE (Lr_DatosCorreo.DESTINATARIO IS NOT NULL) LOOP
      UTL_SMTP.RCPT(Lv_Conexion, GE_CORREO_ELECTRONICO.GEF_OBTIENE_DIRECCION(Lr_DatosCorreo.DESTINATARIO));
    END LOOP;

    WHILE (Lr_DatosCorreo.COPIA_CARBON IS NOT NULL) LOOP
      UTL_SMTP.RCPT(Lv_Conexion, GE_CORREO_ELECTRONICO.GEF_OBTIENE_DIRECCION(Lr_DatosCorreo.COPIA_CARBON));
    END LOOP;

    WHILE (Lr_DatosCorreo.COPIA_OCULTA IS NOT NULL) LOOP
      UTL_SMTP.RCPT(Lv_Conexion, GE_CORREO_ELECTRONICO.GEF_OBTIENE_DIRECCION(Lr_DatosCorreo.COPIA_OCULTA));
    END LOOP;

    UTL_SMTP.DATA(Lv_Conexion, Lv_Cabecera || Pr_DatosCorreos.CUERPO_CORREO);
    DBMS_OUTPUT.PUT_LINE('Envio correo');

    /* Cierra Conexion */
    UTL_SMTP.QUIT(Lv_Conexion);

  EXCEPTION
    WHEN Le_ErrorProceso THEN
      UTL_SMTP.QUIT(Lv_Conexion);
    WHEN UTL_SMTP.INVALID_OPERATION THEN
      Pv_MensajeError := SUBSTR('Error en GE_CORREO_ELECTRONICO.P_ENVIAR_CORREO. '||SQLCODE || '-1-' || SQLERRM, 1, 4000);
      UTL_SMTP.QUIT(Lv_Conexion);
    WHEN UTL_SMTP.TRANSIENT_ERROR THEN
      Pv_MensajeError := SUBSTR(SQLCODE || '-2-' || SQLERRM, 1, 4000);
      UTL_SMTP.QUIT(Lv_Conexion);
    WHEN UTL_SMTP.PERMANENT_ERROR THEN
      Pv_MensajeError := SUBSTR(SQLCODE || '-3-' || SQLERRM, 1, 4000);
      UTL_SMTP.QUIT(Lv_Conexion);
    WHEN OTHERS THEN
      Pv_MensajeError := SUBSTR(SQLCODE || '-4-' || SQLERRM, 1, 4000);
      UTL_SMTP.QUIT(Lv_Conexion);
  END GEP_ENVIAR_CORREO;

  ----------------------------------------------------------
  -- Funcion que suprime los caracteres especiales que se --
  -- hayan agregado a las lista de correos electronicos   --
  ----------------------------------------------------------
  FUNCTION GEF_PREPARAR_LISTADO_CORREOS(Pv_Cadena VARCHAR2) RETURN VARCHAR2 IS

    Lv_Cadena  VARCHAR2(32767) := NULL;
  BEGIN

    Lv_Cadena := REPLACE(Pv_Cadena, ' ', '');
    Lv_Cadena := REPLACE(Lv_Cadena, '''', '');
    Lv_Cadena := REPLACE(Lv_Cadena, '"', '');
    Lv_Cadena := REPLACE(Lv_Cadena, ',', ';');

    FOR I IN 1 .. 5 LOOP
      Lv_Cadena := REPLACE(Lv_Cadena, ';;', ';');
    END LOOP;

    IF SUBSTR(Lv_Cadena, 1, 1) = ';' THEN
      Lv_Cadena := SUBSTR(Lv_Cadena, 2, LENGTH(Lv_Cadena));
    END IF;

    IF SUBSTR(Lv_Cadena, LENGTH(Lv_Cadena), 1) = ';' THEN
      Lv_Cadena := SUBSTR(Lv_Cadena, 1, LENGTH(Lv_Cadena) - 1);
    END IF;

    RETURN(Lv_Cadena);
  END GEF_PREPARAR_LISTADO_CORREOS;

  ----------------------------------------------------------------
  -- Funcion que retorna un correo electronico de un listado de --
  -- correos electronicos concatenados en una cadena            --
  ----------------------------------------------------------------
  FUNCTION GEF_OBTIENE_DIRECCION(Pv_ListaEmail IN OUT VARCHAR2) RETURN VARCHAR2 IS

    Lv_Email  VARCHAR2(256);
    Li_Numero PLS_INTEGER;

    FUNCTION GEF_BUSCA_CARACTER(Lv_Cadena IN VARCHAR2,
                                  Lv_Valor  IN VARCHAR2) RETURN PLS_INTEGER AS
      Lv_Caracter  VARCHAR2(5);
      Li_Numero    PLS_INTEGER;
      Li_Longitud  PLS_INTEGER;
      inside_quote BOOLEAN;
    BEGIN
      inside_quote := FALSE;
      Li_Numero    := 1;
      Li_Longitud  := LENGTH(Lv_Cadena);
      WHILE (Li_Numero <= Li_Longitud) LOOP

        Lv_Caracter := SUBSTR(Lv_Cadena, Li_Numero, 1);

        IF (inside_quote) THEN
          IF (Lv_Caracter = '"') THEN
            inside_quote := FALSE;
          ELSIF (Lv_Caracter = '\') THEN
            Li_Numero := Li_Numero + 1; -- Skip the quote character
          END IF;
          GOTO next_char;
        END IF;

        IF (Lv_Caracter = '"') THEN
          inside_quote := TRUE;
          GOTO next_char;
        END IF;

        IF (instr(Lv_Valor, Lv_Caracter) >= 1) THEN
          RETURN Li_Numero;
        END IF;

        <<next_char>>
        Li_Numero := Li_Numero + 1;

      END LOOP;

      RETURN 0;

    END;

  BEGIN

    Pv_ListaEmail := LTRIM(Pv_ListaEmail);
    Li_Numero     := GEF_BUSCA_CARACTER(Pv_ListaEmail, ',;');
    IF (Li_Numero >= 1) THEN
      Lv_Email      := SUBSTR(Pv_ListaEmail, 1, Li_Numero - 1);
      Pv_ListaEmail := SUBSTR(Pv_ListaEmail, Li_Numero + 1);
    ELSE
      Lv_Email      := Pv_ListaEmail;
      Pv_ListaEmail := '';
    END IF;

    Li_Numero := GEF_BUSCA_CARACTER(Lv_Email, '<');
    IF (Li_Numero >= 1) THEN
      Lv_Email  := SUBSTR(Lv_Email, Li_Numero + 1);
      Li_Numero := GEF_BUSCA_CARACTER(Lv_Email, '>');
      IF (Li_Numero >= 1) THEN
        Lv_Email := SUBSTR(Lv_Email, 1, Li_Numero - 1);
      END IF;
    END IF;

    RETURN Lv_Email;
  END GEF_OBTIENE_DIRECCION;
--
PROCEDURE GEP_ENVIA_NOTIFICACION (Pv_CodPla IN Varchar2,
                                  Pv_DesCodPla IN Varchar2,
                                  Pv_NoCia  IN Varchar2,
                                  Pv_MensajeError OUT Varchar2)IS
  
    --Lee la hora para el saludo personalizado
    CURSOR C_LeeHora IS
      SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'HH24')) HORA
        FROM DUAL;
        
     CURSOR C_DESTINATARIO IS
      SELECT PA.DESCRIPCION
            FROM NAF47_TNET.GE_GRUPOS_PARAMETROS GP,
                 NAF47_TNET.GE_PARAMETROS        PA
           WHERE GP.ID_EMPRESA = PA.ID_EMPRESA
             AND GP.ID_GRUPO_PARAMETRO = PA.ID_GRUPO_PARAMETRO
             AND GP.ID_APLICACION='PL'
             AND GP.ID_GRUPO_PARAMETRO='CORREO_CALIDAD'
             AND GP.ESTADO='A'
             AND PA.ESTADO='A'
             AND PA.PARAMETRO='MAIL_CALI'
         AND PA.ID_EMPRESA= Pv_NoCia;

        
     Ln_Hora    NUMBER(10) := 0;
     Lv_Saludo  VARCHAR2(100) := NULL;
     Lv_Para    GE_PARAMETROS.DESCRIPCION%TYPE:=NULL;     
     Lv_Mensaje CLOB;   
        
  
  BEGIN
    
      IF C_LeeHora%ISOPEN THEN CLOSE C_LeeHora; END IF;
       OPEN C_LeeHora;
      FETCH C_LeeHora
       INTO Ln_Hora;
      CLOSE C_LeeHora;
      IF Ln_Hora >= 0 AND Ln_Hora < 12 THEN
        --DIAS
        Lv_Saludo := 'Buenos D�as';
      END IF;
      IF Ln_Hora >= 12 AND Ln_Hora < 19 THEN
        --TARDES
        Lv_Saludo := 'Buenas Tardes';
      END IF;
      IF Ln_Hora >= 19 AND Ln_Hora < 23 THEN
        --NOCHES
        Lv_Saludo := 'Buenas Noches';
      END IF;
      --
      IF C_DESTINATARIO%ISOPEN THEN CLOSE C_DESTINATARIO; END IF;
      OPEN C_DESTINATARIO;
      FETCH C_DESTINATARIO INTO Lv_Para;
      CLOSE C_DESTINATARIO;
      
      Lv_Mensaje:='<html>
                    <head>
                        
                      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
                        
                    </head>
                    <body>
                       
                       <div >
                        <p> <br>' || Lv_Saludo ||','|| '                          
                        <br><br>  Se ha procedido con el cierre de la Planilla de pagos: <b>'|| Pv_CodPla || ' - '||Pv_DesCodPla ||'</b>, por lo que deber� ingresar la observacion 
                        de Remunerracion Variable(KPI) manualmente en el modulo de Nomina, Opcion Procesos/ Movimiento de Nomina / Carga Masiva desglose KPI.
                        <br><br>
                        Sistema NAF.
                        </p>
                       </div>

                    </body>
                    </html>';
    
  
   sys.utl_mail.send(sender     => 'NAF@TELCONET.EC',
                     recipients =>  Lv_Para,--Lv_Destinos, --Envia al autorizador o a su reemplazo
                     CC         => 'NAF@TELCONET.EC',--Lv_Copias,
                     subject    => 'SISTEMA NAF: NOMINA CERRADA, NO SE CARG� OBSERVACION KPI',
                     mime_type  => 'text/html; charset=us-ascii',
                     MESSAGE    => Lv_Mensaje);
     EXCEPTION
                     
  WHEN OTHERS THEN
    Pv_MensajeError := 'Error en GEP_ENVIA_NOTIFICACION: '|| SQLCODE || SQLERRM;
  END GEP_ENVIA_NOTIFICACION;

  PROCEDURE P_ENVIA_MAIL_DESPACHO( Pv_From         IN VARCHAR2,
                                   Pv_To           IN VARCHAR2,
                                   Pv_Subject      IN VARCHAR2,
                                   Pv_Body         IN VARCHAR2,
                                   Pv_Dir          IN VARCHAR2,
                                   Pv_NameFile     IN VARCHAR2,
                                   Pv_MensajeError OUT VARCHAR2) IS
                                   
    Lv_MensajeError    Varchar2(200) := NULL;
    Lv_Directorio      VARCHAR2(100) := NULL;
    Lv_NombreArchivo   VARCHAR2(100) := NULL;
    Lv_Remitente       VARCHAR2(100) := NULL;
    Lv_Destinatario    VARCHAR2(100) := NULL;
    Lv_Asunto          VARCHAR2(300) := NULL;
    Lv_Cuerpo          CLOB          := NULL;
    Lfile_Archivo      utl_file.file_type;
    Le_Error Exception;

  BEGIN
    
    Lv_Remitente     := Pv_From;
    Lv_Destinatario  := Pv_To||',';
    Lv_Asunto        := Pv_Subject;
    Lv_Cuerpo        := Pv_Body;
    Lv_Directorio    := Pv_Dir;
    Lv_NombreArchivo := Pv_NameFile;
    
    Lv_Cuerpo := REPLACE(Lv_Cuerpo, '�', chr(38)||'aacute;');
    Lv_Cuerpo := REPLACE(Lv_Cuerpo, '�', chr(38)||'eacute;');
    Lv_Cuerpo := REPLACE(Lv_Cuerpo, '�', chr(38)||'iacute;');
    Lv_Cuerpo := REPLACE(Lv_Cuerpo, '�', chr(38)||'oacute;');
    Lv_Cuerpo := REPLACE(Lv_Cuerpo, '�', chr(38)||'ntilde;');
        
    
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                                 'GE_CORREO_ELECTRONICO.P_ENVIA_MAIL_DESPACHO: ',
                                                 'Lv_Remitente: ' || Lv_Remitente ||
                                                 ' Lv_Destinatario:' || Lv_Destinatario||
                                                 ' Lv_Asunto: '||Lv_Asunto ||
                                                 ' Lv_Directorio' || Lv_Directorio ||
                                                 ' Lv_NombreArchivo: '|| Lv_NombreArchivo,
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));    
                 
    DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                              Lv_Destinatario,
                                              Lv_Asunto, 
                                              Lv_Cuerpo, 
                                              Lv_Directorio,
                                              Lv_NombreArchivo);
                                              
                                              
                                                             
   -- UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivo);

    EXCEPTION
        WHEN OTHERS THEN
            Pv_MensajeError := 'Error'|| SQLERRM || ' ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                                 'GE_CORREO_ELECTRONICO.P_ENVIA_MAIL_DESPACHO: ',
                                                 'Error en P_ENVIA_MAIL_DESPACHO: ' || SQLERRM || ' ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                 NVL(SYS_CONTEXT('USERENV', 'HOST'), USER),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
  END P_ENVIA_MAIL_DESPACHO;

END GE_CORREO_ELECTRONICO;
/