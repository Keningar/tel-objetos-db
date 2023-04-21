           
 /**
 * Insert de parámetros de remitente
 *
 * @author Carlos Caguana <ccaguana@telconet.ec>
 *
 * @version 1.0
 */

DECLARE 
Lcl_Request CLOB;
Lv_Mensaje  VARCHAR2(500);
Lv_Status   VARCHAR2(500);
Pcl_Response SYS_REFCURSOR;
BEGIN
Lcl_Request:='{"dias":180}';
DB_COMERCIAL.CMKG_REGULARIZACIONES.P_ROLES_ENUNCIADOS(Lcl_Request, Lv_Mensaje, Lv_Status,Pcl_Response);  
 dbms_output.put_line('MENSAJE=>'||Lv_Mensaje ||', STATUS=>'||Lv_Status );   
END;
/