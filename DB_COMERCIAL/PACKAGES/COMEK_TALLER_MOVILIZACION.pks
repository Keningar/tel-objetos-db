CREATE OR REPLACE PACKAGE DB_COMERCIAL.COMEK_TALLER_MOVILIZACION
AS
/**
* COMEKP_FIN_CHOFER_PROVISIONAL
*
* PROCEDIMIENTO QUE FINALIZA LAS ASIGNACIONES PROVISIONALES DE CHOFERES QUE YA HAN CUMPLIDO CON SU RESPECTIVO TIEMPO DE ASIGNACIÓN
*
* @author Lizbeth Cruz <mlcruz@telconet.ec>
* @version 1.0 01/08/2016
* @author Modificado: Lizbeth Cruz <mlcruz@telconet.ec>
* @version 1.1 28/08/2016 Se incluye nuevo detalle con el id de la solicitud que también deberá ser eliminada cuando la asignación
* cumpla con el tiempo que el usuario asignó
*
*/
PROCEDURE COMEKP_FIN_CHOFER_PROVISIONAL(Lv_MsjError OUT VARCHAR2); 
--
END COMEK_TALLER_MOVILIZACION;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.COMEK_TALLER_MOVILIZACION 
AS

PROCEDURE COMEKP_FIN_CHOFER_PROVISIONAL(Lv_MsjError OUT VARCHAR2)
AS
  --Obtiene las asignaciones de chofer provisional que se encuentran con estado pendiente y que ya han cumplido con 
  --su tiempo de asignación respecto al tiempo actual
  CURSOR C_getSolChoferProv 
  IS
    SELECT DISTINCT sol.ID_DETALLE_SOLICITUD,solHist.FE_INI_PLAN,solHist.FE_FIN_PLAN, sol.ELEMENTO_ID
    FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD sol
    INNER JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD tipoSol 
    ON sol.TIPO_SOLICITUD_ID=tipoSol.ID_TIPO_SOLICITUD
    INNER JOIN DB_COMERCIAL.INFO_DETALLE_SOL_HIST solHist
    ON solHist.DETALLE_SOLICITUD_ID=sol.ID_DETALLE_SOLICITUD
    WHERE tipoSol.DESCRIPCION_SOLICITUD='SOLICITUD CHOFER PROVISIONAL' 
    AND solHist.ID_SOLICITUD_HISTORIAL=
    (
    SELECT MAX (solHistorialMax.ID_SOLICITUD_HISTORIAL) 
    FROM  DB_COMERCIAL.INFO_DETALLE_SOL_HIST solHistorialMax
    WHERE solHistorialMax.DETALLE_SOLICITUD_ID=solHist.DETALLE_SOLICITUD_ID
    )
    AND solHist.ESTADO = 'Pendiente'
    AND
    TO_TIMESTAMP( to_char(solHist.FE_FIN_PLAN,'DD/MM/YYYY HH24:MI:SS') ,'DD/MM/YYYY HH24:MI:SS' ) < 
    TO_TIMESTAMP( to_char(current_timestamp,'DD/MM/YYYY HH24:MI:SS'),'DD/MM/YYYY HH24:MI:SS' );
  TYPE t_getSolChoferProv
			IS
			TABLE OF c_getSolChoferProv%ROWTYPE INDEX BY PLS_INTEGER;
			v_getSolChoferProv t_getSolChoferProv;

  limit_in PLS_INTEGER := 500;
  id_motivo number;

  --

BEGIN
  --si existen asignaciones provisionales de chofer que ya hayan concluido con su tiempo de asignación, se les actualiza el estado
  --de Pendiente a Finalizado en la solicitud y de Activo a Eliminado en el detalle del elemento
  
  SELECT motivo.ID_MOTIVO INTO id_motivo
  FROM DB_GENERAL.ADMI_MOTIVO motivo
  WHERE motivo.NOMBRE_MOTIVO='Se finaliza asignacion provisional del chofer automaticamente por el sistema'
  AND motivo.ESTADO='Activo';

  OPEN C_getSolChoferProv;
    LOOP
      FETCH C_getSolChoferProv BULK COLLECT INTO v_getSolChoferProv limit limit_in;
      EXIT WHEN v_getSolChoferProv.COUNT = 0 ;

      FOR indx IN 1 .. v_getSolChoferProv.COUNT LOOP
          INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST(ID_SOLICITUD_HISTORIAL,DETALLE_SOLICITUD_ID,
            ESTADO,FE_INI_PLAN,FE_FIN_PLAN,MOTIVO_ID)

          VALUES(DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,
            v_getSolChoferProv(indx).ID_DETALLE_SOLICITUD,'Finalizado',
            v_getSolChoferProv(indx).FE_INI_PLAN,v_getSolChoferProv(indx).FE_FIN_PLAN,id_motivo);

          UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD
          SET ESTADO = 'Finalizado', MOTIVO_ID=id_motivo
          WHERE ID_DETALLE_SOLICITUD = v_getSolChoferProv(indx).ID_DETALLE_SOLICITUD;

          UPDATE DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO 
          SET ESTADO = 'Eliminado'
          WHERE ELEMENTO_ID = v_getSolChoferProv(indx).ELEMENTO_ID
              AND DETALLE_NOMBRE IN (
              'ASIGNACION_PROVISIONAL_CHOFER',
              'ASIGNACION_PROVISIONAL_CHOFER_FECHA_INICIO',
              'ASIGNACION_PROVISIONAL_CHOFER_FECHA_FIN',
              'ASIGNACION_PROVISIONAL_CHOFER_HORA_INICIO',
              'ASIGNACION_PROVISIONAL_CHOFER_HORA_FIN',
              'ASIGNACION_PROVISIONAL_CHOFER_MOTIVO',
              'ASIGNACION_PROVISIONAL_ID_SOLICITUD_PREDEF'
              )
              AND ESTADO='Activo';
        COMMIT;
      END LOOP;
    END LOOP;
  CLOSE C_getSolChoferProv;
  
  --
  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    IF (C_getSolChoferProv%isopen) THEN CLOSE C_getSolChoferProv; END IF;
    Lv_MsjError := 'ERROR AL ELIMINAR ASIGNACIÓN PROVISIONAL DE CHOFER';
  END COMEKP_FIN_CHOFER_PROVISIONAL;
    
--
END COMEK_TALLER_MOVILIZACION;
/