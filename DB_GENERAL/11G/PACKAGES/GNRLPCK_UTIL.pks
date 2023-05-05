CREATE OR REPLACE PACKAGE            GNRLPCK_UTIL
AS

  --
  /**
  * Realiza envio de correo con archivo adjunto ZIP
  *
  * @author Juan Martinez<jfmartinez@telconet.ec>
  * @version 1.0 18-08-2016
  *
  * @author Alejandro Domínguez Vargas <adominguez@telconet.ec> 
  * @version 1.1 29-09-2016 - Se agrega el parámetro p_mime_type_body por defecto "text/html" para soporte de contenido HTML del cuerpo del email.
  *                         - Se agrega el parámetro p_mime_type_attach por defecto "application/octet-stream" para el archivo adjunto.
  *
  * @param p_from_name IN VARCHAR2,
  * @param p_to_name   IN VARCHAR2,
  * @param p_subject IN VARCHAR2,
  * @param p_message  IN VARCHAR2,
  * @param p_oracle_directory   IN VARCHAR2,
  * @param p_binary_file   IN VARCHAR2
  *
  */
  PROCEDURE send_email_attach(p_from_name        VARCHAR2,
                              p_to_name          VARCHAR2,
                              p_subject          VARCHAR2,
                              p_message          VARCHAR2,
                              p_oracle_directory VARCHAR2,
                              p_binary_file      VARCHAR2, 
                              p_mime_type_body   VARCHAR2 DEFAULT 'text/html',
                              p_mime_type_attach VARCHAR2 DEFAULT 'application/octet-stream');


  PROCEDURE INSERT_ERROR(
      Pv_Aplicacion   IN INFO_ERROR.APLICACION%TYPE,
      Pv_Proceso      IN INFO_ERROR.PROCESO%TYPE,
      Pv_DetalleError IN INFO_ERROR.DETALLE_ERROR%TYPE,
      Pv_UsrCreacion  IN INFO_ERROR.USR_CREACION%TYPE,
      Pd_FeCreacion   IN INFO_ERROR.FE_CREACION%TYPE,
      Pv_IpCreacion   IN INFO_ERROR.IP_CREACION%TYPE);

 
END GNRLPCK_UTIL;

/


CREATE OR REPLACE PACKAGE BODY            GNRLPCK_UTIL
AS
PROCEDURE send_email_attach(p_from_name        VARCHAR2,
                            p_to_name          VARCHAR2,
                            p_subject          VARCHAR2,
                            p_message          VARCHAR2,
                            p_oracle_directory VARCHAR2,
                            p_binary_file      VARCHAR2, 
                            p_mime_type_body   VARCHAR2 DEFAULT 'text/html',
                            p_mime_type_attach VARCHAR2 DEFAULT 'application/octet-stream')
IS
-- encoded in Base64
-- this procedure uses the following nested functions:
--     binary_attachment - calls:
--     begin_attachment - calls:
--     write_boundary
--     write_mime_header
-- 
--     end attachment - calls;
--     write_boundary

  -- change the following line to refer to your mail server
  v_smtp_server VARCHAR2(100) := 'sissmtp-int.telconet.net';
  v_smtp_server_port NUMBER := 25;
  v_directory_name VARCHAR2(100);
  v_file_name VARCHAR2(100);
  v_mesg VARCHAR2(32767);
  v_conn UTL_SMTP.CONNECTION;
    --------------
  lw_lenght_line NUMBER;
  lw_pos_start   NUMBER;
  lw_pos_char    NUMBER;
  v_recipient    VARCHAR2(5000);
    --------------
-- 

  PROCEDURE write_mime_header(p_conn in out nocopy utl_smtp.connection,
    p_name in varchar2,
    p_value in varchar2)
  IS
  BEGIN
    UTL_SMTP.WRITE_RAW_DATA(
      p_conn,
      UTL_RAW.CAST_TO_RAW( p_name || ': ' || p_value || UTL_TCP.CRLF)
    );
  END write_mime_header;

-- 

  PROCEDURE write_boundary(p_conn IN OUT NOCOPY UTL_SMTP.CONNECTION,
    p_last IN BOOLEAN DEFAULT false)
  IS
  BEGIN
    IF (p_last) THEN
      UTL_SMTP.WRITE_DATA(p_conn, '--DMW.Boundary.605592468--'||UTL_TCP.CRLF);
    ELSE
      UTL_SMTP.WRITE_DATA(p_conn, '--DMW.Boundary.605592468'||UTL_TCP.CRLF);
    END IF;
  END write_boundary;

-- 

  PROCEDURE end_attachment(p_conn IN OUT NOCOPY UTL_SMTP.CONNECTION,
                           p_last IN BOOLEAN DEFAULT TRUE)
  IS
  BEGIN
    UTL_SMTP.WRITE_DATA(p_conn, UTL_TCP.CRLF);
    IF (p_last) THEN
      write_boundary(p_conn, p_last);
    END IF;
  END end_attachment;

-- 

  PROCEDURE begin_attachment(p_conn IN OUT NOCOPY UTL_SMTP.CONNECTION,
                             p_mime_type IN VARCHAR2 DEFAULT 'text/plain',
                             p_inline IN BOOLEAN DEFAULT false,
                             p_filename IN VARCHAR2 DEFAULT null,
                             p_transfer_enc in VARCHAR2 DEFAULT null)
  IS
  BEGIN
    write_boundary(p_conn);
    IF (p_transfer_enc IS NOT NULL) THEN
      write_mime_header(p_conn, 'Content-Transfer-Encoding',p_transfer_enc);
    END IF;
    write_mime_header(p_conn, 'Content-Type', p_mime_type);
    IF (p_filename IS NOT NULL) THEN
      IF (p_inline) THEN
        write_mime_header(
          p_conn,
          'Content-Disposition', 'inline; filename="' || p_filename || '"'
        );
      ELSE
        write_mime_header(
          p_conn,
          'Content-Disposition', 'attachment; filename="' || p_filename || '"'
        );
      END IF;
    END IF;
    UTL_SMTP.WRITE_DATA(p_conn, UTL_TCP.CRLF);
  END begin_attachment;

-- 

  PROCEDURE binary_attachment(p_conn IN OUT UTL_SMTP.CONNECTION,
                              p_file_name IN VARCHAR2,
                              p_mime_type in VARCHAR2)
  IS
    c_max_line_width CONSTANT PLS_INTEGER DEFAULT 54;
    v_amt BINARY_INTEGER := 672 * 3; /* ensures proper format; 2016 */
    v_bfile BFILE;
    v_file_length PLS_INTEGER;
    v_buf RAW(2100);
    v_modulo PLS_INTEGER;
    v_pieces PLS_INTEGER;
    v_file_pos pls_integer := 1;

  BEGIN
    begin_attachment(
      p_conn => p_conn,
      p_mime_type => p_mime_type,
      p_inline => TRUE,
      p_filename => p_file_name,
      p_transfer_enc => 'base64');
    BEGIN
      v_bfile := BFILENAME(p_oracle_directory, p_file_name);
      -- Get the size of the file to be attached
      v_file_length := DBMS_LOB.GETLENGTH(v_bfile);
      -- Calculate the number of pieces the file will be split up into
      v_pieces := TRUNC(v_file_length / v_amt);
      -- Calculate the remainder after dividing the file into v_amt chunks
      v_modulo := MOD(v_file_length, v_amt);
      IF (v_modulo <> 0) THEN
      -- Since the file does not devide equally
      -- we need to go round the loop an extra time to write the last
      -- few bytes - so add one to the loop counter.
        v_pieces := v_pieces + 1;
      END IF;
      DBMS_LOB.FILEOPEN(v_bfile, DBMS_LOB.FILE_READONLY);
      FOR i IN 1 .. v_pieces LOOP
      -- we can read at the beginning of the loop as we have already calculated
      -- how many iterations we will take and so do not need to check
      -- end of file inside the loop.
        v_buf := NULL;
        DBMS_LOB.READ(v_bfile, v_amt, v_file_pos, v_buf);
        v_file_pos := I * v_amt + 1;
        UTL_SMTP.WRITE_RAW_DATA(p_conn, UTL_ENCODE.BASE64_ENCODE(v_buf));
      END LOOP;
    END;
    DBMS_LOB.FILECLOSE(v_bfile);
    end_attachment(p_conn => p_conn);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      end_attachment(p_conn => p_conn);
      DBMS_LOB.FILECLOSE(v_bfile);
  END binary_attachment;

-- 
-- Main Routine
-- 
BEGIN
-- 
-- Connect and set up header information:
-- 
  v_conn:= UTL_SMTP.OPEN_CONNECTION( v_smtp_server, v_smtp_server_port );
  UTL_SMTP.HELO( v_conn, v_smtp_server );
  UTL_SMTP.MAIL( v_conn, p_from_name );
  --UTL_SMTP.RCPT( v_conn, p_to_name );
  ----------
    lw_lenght_line := length(p_to_name);
    lw_pos_start   := 1;
    <<loopinterno>>
    LOOP
      lw_pos_char  := INSTR(p_to_name, ',', lw_pos_start);
      v_recipient := substr(p_to_name,
                             lw_pos_start,
                             lw_pos_char - lw_pos_start);
      utl_smtp.rcpt(v_conn, v_recipient);
      EXIT loopinterno WHEN lw_pos_char = lw_lenght_line;
      lw_pos_start := lw_pos_char + 1;
    END LOOP;
  -------------------
  UTL_SMTP.OPEN_DATA ( v_conn );
  UTL_SMTP.WRITE_DATA(v_conn, 'Subject: '||p_subject||UTL_TCP.CRLF);
-- 
  v_mesg:= 'Content-Transfer-Encoding: 7bit' || UTL_TCP.CRLF ||
    'Content-Type: multipart/mixed;boundary="DMW.Boundary.605592468"' || UTL_TCP.CRLF ||
    'Mime-Version: 1.0' || UTL_TCP.CRLF ||
    '--DMW.Boundary.605592468' || UTL_TCP.CRLF ||
    'Content-Transfer-Encoding: binary'||UTL_TCP.CRLF||
    'Content-Type: ' || p_mime_type_body ||UTL_TCP.CRLF ||
    UTL_TCP.CRLF || p_message || UTL_TCP.CRLF ;
-- 
  UTL_SMTP.write_data(v_conn, 'To: ' || p_to_name || UTL_TCP.crlf);



  UTL_SMTP.WRITE_RAW_DATA ( v_conn, UTL_RAW.CAST_TO_RAW(v_mesg) );
  --
  -- Add the Attachment
  --
  binary_attachment(
    p_conn => v_conn,
    p_file_name => p_binary_file,
    -- Modify the mime type at the beginning of this line depending
    -- on the type of file being loaded.
    p_mime_type => p_mime_type_attach || '; name="' || p_binary_file|| '"'
  );
  --
  -- Send the email
  --
  UTL_SMTP.CLOSE_DATA( v_conn );
  UTL_SMTP.QUIT( v_conn );

END send_email_attach;
 --
  PROCEDURE INSERT_ERROR(
      Pv_Aplicacion   IN INFO_ERROR.APLICACION%TYPE,
      Pv_Proceso      IN INFO_ERROR.PROCESO%TYPE,
      Pv_DetalleError IN INFO_ERROR.DETALLE_ERROR%TYPE,
      Pv_UsrCreacion  IN INFO_ERROR.USR_CREACION%TYPE,
      Pd_FeCreacion   IN INFO_ERROR.FE_CREACION%TYPE,
      Pv_IpCreacion   IN INFO_ERROR.IP_CREACION%TYPE)
  AS
    --
    PRAGMA AUTONOMOUS_TRANSACTION;
    ln_secuencia number;
    --
  BEGIN
    --
    select DB_GENERAL.MIG_SECUENCIA.SEQ_INFO_ERROR into ln_secuencia from dual;
    INSERT
    INTO DB_GENERAL.INFO_ERROR@GPOETNET
      (
        ID_ERROR,
        APLICACION,
        PROCESO,
        DETALLE_ERROR,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION
      )
      VALUES
      (
        --DB_GENERAL.SEQ_INFO_ERROR@GPOETNET.NEXTVAL,
        ln_secuencia,
        Pv_Aplicacion,
        Pv_Proceso,
        Pv_DetalleError,
        Pv_UsrCreacion,
        Pd_FeCreacion,
        Pv_IpCreacion
      );
    --
    COMMIT;
    --
  END INSERT_ERROR;
--

END GNRLPCK_UTIL;

/
