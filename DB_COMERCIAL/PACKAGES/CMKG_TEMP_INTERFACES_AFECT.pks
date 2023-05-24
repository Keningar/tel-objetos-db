CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_TEMP_INTERFACES_AFECT AS 
   
/**
* Documentaci�n para CMKG_TEMP_INTERFACES_AFECT
* Paquete que contiene procedimientos relacionadas a la tabla temporal INFO_INTERFACES_AFECTATADAS
* 
* @author Richard Cabrera <rcabrera@telconet.ec>
* @version 1.0 28-10-2016
*/


/**
* Documentaci�n para P_CARGA_TMP_INTERFACES_AFECT
* Procedimiento que sirve para cargar la tabla temporal INFO_INTERFACES_AFECTATADAS
* 
* @author Richard Cabrera <rcabrera@telconet.ec>
* @version 1.0 28-10-2016
* 
* @param PCL_INTERFACES IN CLOB Cadena con la lista de interfaces consultadas en el momento
* @param PN_PROCESO_ID OUT NUMBER Retorna el numero del proceso que esta asociado a las interfaces temporales
*/   
PROCEDURE P_CARGA_TMP_INTERFACES_AFECT(PCL_INTERFACES IN CLOB,
                                       PN_PROCESO_ID OUT NUMBER);
      


/**
* Documentaci�n para P_BORRA_TMP_INTERFACES_AFECT
* Procedimiento que sirve para eliminar registros de la tabla temporal INFO_INTERFACES_AFECTATADAS
* relacionados a un proceso_id en particular
* 
* @author Richard Cabrera <rcabrera@telconet.ec>
* @version 1.0 28-10-2016
* 
* @param PN_ID_PROCESO IN NUMBER Proceso_id a eliminar
* @param PV_MSG OUT VARCHAR2 Mensaje de error
*/     
PROCEDURE P_BORRA_TMP_INTERFACES_AFECT(PN_ID_PROCESO IN NUMBER,
                                       PV_MSG OUT VARCHAR2);

END CMKG_TEMP_INTERFACES_AFECT;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_TEMP_INTERFACES_AFECT as

  
PROCEDURE P_CARGA_TMP_INTERFACES_AFECT(PCL_INTERFACES IN CLOB,PN_PROCESO_ID OUT NUMBER) IS

ARRAY_INTERFACE_ID DB_INFRAESTRUCTURA.INFRK_TRANSACCIONES.T_ARRAY;
LN_PROCESO_ID      NUMBER;
LV_MSG_ERROR       VARCHAR2(50);

BEGIN

LN_PROCESO_ID := DB_COMERCIAL.SEQ_PROC_TMP_INTERFACES.NEXTVAL;

ARRAY_INTERFACE_ID := DB_INFRAESTRUCTURA.INFRK_TRANSACCIONES.split(PCL_INTERFACES,',');

--Se inserta la tabla temporal con las interfaces a consultar en el momento de la operacion
--de agregar los afectados
FOR I IN 1 .. ARRAY_INTERFACE_ID.COUNT LOOP

  INSERT INTO DB_COMERCIAL.INFO_INTERFACES_AFECTADAS(ID_INTERFACE_TMP,INTERFACE_ID,PROCESO_ID)  
  VALUES (DB_COMERCIAL.SEQ_INFO_INTERFACES_AFECTADAS.NEXTVAL,ARRAY_INTERFACE_ID(I),LN_PROCESO_ID);
  
END LOOP;

COMMIT;

PN_PROCESO_ID := LN_PROCESO_ID;

EXCEPTION
WHEN OTHERS THEN
ROLLBACK;
PN_PROCESO_ID   := 0;
LV_MSG_ERROR    := 'Error al cargar la tabla DB_COMERCIAL.INFO_INTERFACES_AFECTATADAS';

DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                   'CMKG_TEMP_INTERFACES_AFECT.P_CARGA_TMP_INTERFACES_AFECT',
                   LV_MSG_ERROR || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                   NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                   sysdate,
                   NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

END;




PROCEDURE P_BORRA_TMP_INTERFACES_AFECT(PN_ID_PROCESO IN NUMBER,PV_MSG OUT VARCHAR2) IS

LV_MSG_ERROR       VARCHAR2(50);

BEGIN

--Elimino los registros de la tabla remporal
DELETE FROM DB_COMERCIAL.INFO_INTERFACES_AFECTADAS WHERE PROCESO_ID = PN_ID_PROCESO;

COMMIT;

PV_MSG := 'S';

EXCEPTION
WHEN OTHERS THEN
ROLLBACK;
PV_MSG := 'N';
LV_MSG_ERROR    := 'Error al borrar la tabla DB_COMERCIAL.INFO_INTERFACES_AFECTATADAS';

DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                   'CMKG_TEMP_INTERFACES_AFECT.P_BORRA_TMP_INTERFACES_AFECT',
                   LV_MSG_ERROR || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                   NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                   sysdate,
                   NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

END;

END CMKG_TEMP_INTERFACES_AFECT;
/
