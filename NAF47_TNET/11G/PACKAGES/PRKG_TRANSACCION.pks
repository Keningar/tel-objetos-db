CREATE OR REPLACE PACKAGE            "PRKG_TRANSACCION" is
/**
    * Documentación para el paquete PRKG_TRANSACCION
    * Paquete que contiene funciones para transacciones.
    * desde el sistema Api Naf.
    *
    * @author David León <mdleon@telconet.ec>
    * @version 1.0 17-06-2022
    */

  /**
    * Documentación para la función 'F_CREA_PROYECTO'.
    * Función encargada de crear el proyecto si cumple los parametros.
    *
    * @author David León <mdleon@telconet.ec>
    * @version 1.0 17-06-2022
    *
    *
  */
FUNCTION F_CREA_PROYECTO ( Pv_NombreProyecto VARCHAR2,
                       Pv_TipoCont    VARCHAR2,
                       Pv_CostoProy   VARCHAR2,
                       Pv_Responsable VARCHAR2,
                       Pv_NoCia	      VARCHAR2,
                       Pv_UsrCreacion VARCHAR2,
                       Pv_Estado	    VARCHAR2,
                       Pv_Status  OUT VARCHAR2,
                       Pv_Tipo    OUT VARCHAR2,
                       Pv_IdProyecto OUT VARCHAR2,
                       Pv_LoginCont  OUT VARCHAR2,
                       Pv_Departamento OUT VARCHAR2,
                       Pv_NombreProces OUT VARCHAR2,
                       Pv_NombreTarea  OUT VARCHAR2,
                       Pv_Observacion  OUT VARCHAR2,
                       Pv_Mensaje OUT VARCHAR2) RETURN VARCHAR2 ;
end PRKG_TRANSACCION;
/


CREATE OR REPLACE PACKAGE BODY            "PRKG_TRANSACCION"
AS
FUNCTION F_CREA_PROYECTO ( Pv_NombreProyecto VARCHAR2,
                           Pv_TipoCont    VARCHAR2,
                           Pv_CostoProy   VARCHAR2,
                           Pv_Responsable VARCHAR2,
                           Pv_NoCia	      VARCHAR2,
                           Pv_UsrCreacion VARCHAR2,
                           Pv_Estado	    VARCHAR2,
                           Pv_Status  OUT VARCHAR2,
                           Pv_Tipo    OUT VARCHAR2,
                           Pv_IdProyecto OUT VARCHAR2,
                           Pv_LoginCont  OUT VARCHAR2,
                           Pv_Departamento OUT VARCHAR2,
                           Pv_NombreProces OUT VARCHAR2,
                           Pv_NombreTarea  OUT VARCHAR2,
                           Pv_Observacion  OUT VARCHAR2,
                           Pv_Mensaje OUT VARCHAR2) RETURN VARCHAR2 IS
    --
    CURSOR C_PROYECTOS IS
    SELECT
        PROYECTO.NOMBRE      AS NOMBRE
    FROM
        NAF47_TNET.ADMI_PROYECTO   PROYECTO
    WHERE
        PROYECTO.NOMBRE       = Pv_NombreProyecto AND
        PROYECTO.ESTADO NOT IN ('Eliminado','Cancelado','Finalizado');
        
    CURSOR C_PERSONA IS
    SELECT
        PERSONA.ID_PERSONA      AS ID_PERSONA
    FROM
        DB_COMERCIAL.INFO_PERSONA   PERSONA
    WHERE
        PERSONA.LOGIN       = Pv_Responsable ;  
        
    CURSOR C_VALIDA_PROYECTO IS   
    Select apd.valor1 as Proyecto,
           apd.valor2 as Contable
    From DB_GENERAL.ADMI_PARAMETRO_DET apd
    Where apd.parametro_id=(SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'VALIDA_VALOR_PROYECTO_NAF' AND ESTADO = 'Activo');
    
    CURSOR C_DATOS_CONTADOR IS   
    Select apd.valor1 as Login,
           apd.valor2 as Departamento,
           apd.valor3 as NombreProceso,
           apd.valor4 as NombreTarea,
           apd.valor5 as Observacion
    From DB_GENERAL.ADMI_PARAMETRO_DET apd
    Where apd.parametro_id=(SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'DATOS_TAREA_CONTADOR' AND ESTADO = 'Activo');
        --
    Lv_Nombre       VARCHAR2(2000) := NULL;
    Ln_Persona      NUMBER := 0;
    Lr_AdmiProyecto  NAF47_TNET.ADMI_PROYECTO%ROWTYPE;
    Lv_Proyecto     NUMBER := 0;
    Lv_Contable     NUMBER := 0;
    Lv_TipoCont     VARCHAR2(50) := NULL;
    Lv_LoginCont    VARCHAR2(50) := NULL;
    Lv_DepartCont   VARCHAR2(50) := NULL;
    Lv_NombreProces VARCHAR2(250) := NULL;
    Lv_NombreTarea  VARCHAR2(150) := NULL;
    Lv_Observacion  VARCHAR2(350) := NULL;
    Lv_Jason          CLOB := NULL;
    --
  BEGIN
    --
    Pv_Status  := '200';
    Pv_Mensaje := 'Transacción realizada con éxito';
    Lv_Jason := '{'||chr(10);
    Lv_Jason := Lv_Jason||LPAD(' ',3, ' ')||'"articulos":[]}';
    --
    OPEN C_PROYECTOS;
    FETCH C_PROYECTOS INTO Lv_Nombre;
    CLOSE C_PROYECTOS;	
    --
    IF Lv_Nombre IS NULL THEN
    
    OPEN C_PERSONA;
    FETCH C_PERSONA INTO Ln_Persona;
    CLOSE C_PERSONA;
    
    OPEN C_VALIDA_PROYECTO;
    FETCH C_VALIDA_PROYECTO INTO Lv_Proyecto,Lv_Contable;
    CLOSE C_VALIDA_PROYECTO;
    
      IF Pv_CostoProy > Lv_Proyecto THEN 
          IF Pv_CostoProy > Lv_Contable THEN
              Lv_TipoCont := 'Detallado';
          ELSE
              Lv_TipoCont := 'Individual';
          END IF;
      
          Lr_AdmiProyecto.ID_PROYECTO 		  := NAF47_TNET.SEQ_ADMI_PROYECTO.NEXTVAL@GPOETNET;
          Lr_AdmiProyecto.NOMBRE			      := Pv_NombreProyecto;
          Lr_AdmiProyecto.RESPONSABLE_ID		:= Ln_Persona;
          Lr_AdmiProyecto.TIPO_CONTABILIDAD	:= Lv_TipoCont;
          Lr_AdmiProyecto.NO_CIA			      := Pv_NoCia;
          --Lr_AdmiProyecto.CUENTA_ID
          Lr_AdmiProyecto.FE_INICIO		      := sysdate;
          --Lr_AdmiProyecto.FE_FIN			      := sysdate+30;
          Lr_AdmiProyecto.FE_CREACION		    := SYSDATE;
          Lr_AdmiProyecto.ESTADO			      := Pv_Estado;
          Lr_AdmiProyecto.USR_CREACION		  := Pv_UsrCreacion;
  
          INSERT INTO NAF47_TNET.ADMI_PROYECTO VALUES Lr_AdmiProyecto;
          commit;
    
          Pv_Tipo       := Lv_TipoCont;
          Pv_IdProyecto := Lr_AdmiProyecto.ID_PROYECTO;
          
          IF Lv_TipoCont = 'Detallado' THEN
            OPEN C_DATOS_CONTADOR;
            FETCH C_DATOS_CONTADOR INTO Lv_LoginCont,Lv_DepartCont,Lv_NombreProces,Lv_NombreTarea,Lv_Observacion;
            CLOSE C_DATOS_CONTADOR;
            
          END IF;
          
          Pv_LoginCont     := Lv_LoginCont;
          Pv_Departamento  := Lv_DepartCont;
          Pv_NombreProces  := Lv_NombreProces;
          Pv_NombreTarea   := Lv_NombreTarea;
          Pv_Observacion   := Lv_Observacion;
      END IF;
    ELSE
        Pv_Mensaje := 'Ya existe un Proyecto con ese Nombre favor revisar';
    END IF;

    --
    RETURN Pv_Mensaje;
    --
  END F_CREA_PROYECTO;
END PRKG_TRANSACCION;
/
