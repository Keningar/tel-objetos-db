CREATE OR REPLACE package              MIG_LEE_CAMPOS_LOB is

/**
* Documentacion para DB_COMERCIAL.MIG_LEE_CAMPOS_LOB
* Función implmenetada para convertir el contenido de un campo LOB en string para pasar por parametro.
* @author llindao <llindao@telconet.ec>
* @version 1.0 04/04/2022
*
*/

  FUNCTION F_INFO_SERVICIO_OBSERVACION (Pn_ServicioId IN NUMBER) RETURN CLOB;
    
  
end MIG_LEE_CAMPOS_LOB;
/


CREATE OR REPLACE package body              MIG_LEE_CAMPOS_LOB is
  --
  --
  FUNCTION F_INFO_SERVICIO_OBSERVACION (Pn_ServicioId IN NUMBER) RETURN CLOB IS
    --
    Lv_ConsultaSql  VARCHAR2(4000);
    Lv_ResultadoLob CLOB;
    --
    Lv_Hilera       VARCHAR2 (32767);
    Ln_Inicio       PLS_INTEGER := 1;
    Ln_Buffer       PLS_INTEGER := 32767;
    --
  BEGIN
    --
    dbms_lob.createtemporary(Lv_ResultadoLob,true);
    --
    LOOP
      --
      Lv_ConsultaSql := 'SELECT UTL_RAW.CAST_TO_VARCHAR2(UTL_RAW.CONVERT(DBMS_LOB.SUBSTR(OBSERVACION,'||Ln_Buffer||','||Ln_Inicio||'),';
      Lv_ConsultaSql := Lv_ConsultaSql ||CHR(39)||'AMERICAN_THE NETHERLANDS.UTF8'||CHR(39)||',';
      Lv_ConsultaSql := Lv_ConsultaSql ||CHR(39)||'AMERICAN_THE NETHERLANDS.UTF8'||CHR(39)||'))';
      Lv_ConsultaSql := Lv_ConsultaSql ||' FROM DB_COMERCIAL.INFO_SERVICIO WHERE ID_SERVICIO  = '||Pn_ServicioId;
      --
      BEGIN 
        Lv_Hilera:= NAF47_TNET.MIG_F_CONVIERTE_LOB_STRING@GPOETNET(Lv_ConsultaSql); 
      EXCEPTION
        WHEN OTHERS THEN
          Lv_Hilera:= NULL;
      END;
      --
      IF Lv_Hilera IS NOT NULL THEN
        Ln_Inicio:= Ln_Inicio+ Ln_Buffer;
        dbms_lob.append(Lv_ResultadoLob, to_clob(Lv_Hilera));
      END IF;
      EXIT WHEN Lv_Hilera IS NULL;
    END LOOP;
    --
    RETURN Lv_ResultadoLob;
    --
  END F_INFO_SERVICIO_OBSERVACION;
  --
  --
end MIG_LEE_CAMPOS_LOB;
/
