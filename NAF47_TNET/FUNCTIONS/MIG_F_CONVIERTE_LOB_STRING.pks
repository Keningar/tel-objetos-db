create or replace function            MIG_F_CONVIERTE_LOB_STRING(Pv_ConsultaSql IN VARCHAR2) return varchar2 is
/**
* Documentacion para NAF47_TNET.MIG_F_CONVIERTE_LOB_STRING
* Función implmenetada para convertir el contenido de un campo LOB en string para pasar por parametro.
* @author llindao <llindao@telconet.ec>
* @version 1.0 04/04/2022
*
*/
  --
  Lv_CampoLob VARCHAR2(32767);
  Lt_Resultado SYS_REFCURSOR;
  --
BEGIN
  --
  OPEN Lt_Resultado FOR Pv_ConsultaSql;
  FETCH Lt_Resultado INTO Lv_CampoLob;
  CLOSE Lt_Resultado;
  --
  RETURN Lv_CampoLob;
  --
end MIG_F_CONVIERTE_LOB_STRING;
