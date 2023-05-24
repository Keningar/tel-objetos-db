CREATE OR REPLACE package NAF47_TNET.MPK_MIGRA_NAF_FORMA_PIN277 is

  -- Author  : JOHNNY
  -- Created : 23/02/2023 11:40:12
  -- Purpose :

    procedure GCP_POSTQUERY_BL_SOLICITUDES(
                                            pv_No_Cia                                 in         TAPORDEE.No_Cia%type,
                                            pv_TXT_TECNICO                            in         varchar2,
                                            pn_ID_DETALLE_SOLICITUD                   in         number,
                                            pv_TXT_CED_ASIGNADO_RESPONSABL         in         varchar2,

                                            pv_REF_ASIGNADO_ID                        out        varchar2,
                                            pn_error                                  out        number,
                                            pv_error                                  out        varchar2
    );



end MPK_MIGRA_NAF_FORMA_PIN277;
/

/
CREATE OR REPLACE package body NAF47_TNET.MPK_MIGRA_NAF_FORMA_PIN277 is


procedure GCP_POSTQUERY_BL_SOLICITUDES(
                                        pv_No_Cia                                 in         TAPORDEE.No_Cia%type,
                                        pv_TXT_TECNICO                            in         varchar2,
                                        pn_ID_DETALLE_SOLICITUD                   in         number,
                                        pv_TXT_CED_ASIGNADO_RESPONSABL         in         varchar2,
                                        
                                        pv_REF_ASIGNADO_ID                        out        varchar2,
                                        pn_error                                  out        number,
                                        pv_error                                  out        varchar2
) is

--
  SOLICITUD_NODO CONSTANT VARCHAR2(14) := 'SOLICITUD NODO';
  --
  CURSOR C_ASIGNADO(Cv_IdDetalleSolicitud Varchar2)IS
   SELECT IDA.REF_ASIGNADO_ID
     FROM DB_SOPORTE.INFO_DETALLE_ASIGNACION IDA
    WHERE IDA.ID_DETALLE_ASIGNACION IN (SELECT  MAX(IDA.ID_DETALLE_ASIGNACION) 
                                          FROM DB_SOPORTE.INFO_DETALLE IDE,
                                               DB_SOPORTE.INFO_DETALLE_ASIGNACION    IDA
                                          WHERE IDA.DETALLE_ID = IDE.ID_DETALLE
                                            AND IDE.DETALLE_SOLICITUD_ID = Cv_IdDetalleSolicitud)
    UNION
    SELECT IDA.REF_ASIGNADO_ID
    FROM DB_SOPORTE.INFO_DETALLE_ASIGNACION IDA,
         DB_SOPORTE.INFO_TAREA_CARACTERISTICA ITC 
    WHERE ITC.VALOR = Cv_IdDetalleSolicitud
    AND EXISTS (SELECT NULL 
                FROM DB_COMERCIAL.ADMI_CARACTERISTICA AC
                WHERE AC.DESCRIPCION_CARACTERISTICA = SOLICITUD_NODO -- usado para determinar tarea y con eso determinar empleado asignado y empresa
                AND AC.ID_CARACTERISTICA = ITC.CARACTERISTICA_ID)
    AND ITC.DETALLE_ID = IDA.DETALLE_ID
    ORDER BY 1 DESC;


    CURSOR C_REGION IS
    SELECT E.IND_REGION 
      FROM TASGUSUARIO U, ARPLME E 
      WHERE U.NO_CIA = E.NO_CIA
        AND U.ID_EMPLEADO = E.NO_EMPLE
        AND U.USUARIO = USER;   


    CURSOR C_PARAMETROS(Cv_Estado Varchar2, Cv_IdGrupoPArametro Varchar2, Cv_IdAplicacion Varchar2, Cv_Parametro Varchar2) IS
      SELECT P.DESCRIPCION
        FROM GE_GRUPOS_PARAMETROS G, GE_PARAMETROS P
         WHERE G.ID_EMPRESA = P.ID_EMPRESA
          AND G.ID_APLICACION = P.ID_APLICACION
          AND G.ID_GRUPO_PARAMETRO = P.ID_GRUPO_PARAMETRO
          AND G.ID_EMPRESA = pv_No_Cia
          AND G.ID_APLICACION =  Cv_IdAplicacion
          AND G.ID_GRUPO_PARAMETRO = Cv_IdGrupoPArametro
          AND G.ESTADO = Cv_Estado
          AND P.ESTADO = Cv_Estado
          AND P.PARAMETRO = Cv_Parametro; 

    CURSOR C_AREA(Cv_Descri Varchar2) IS
    SELECT AREA 
     FROM ARPLAR  
    WHERE NO_CIA = pv_No_Cia
      AND DESCRI = Cv_Descri;  

    CURSOR C_DEPTO(Cv_Area Varchar2, Cv_Descri Varchar2)IS
    SELECT DEPA 
      FROM ARPLDP  
     WHERE NO_CIA = pv_No_Cia  
       AND AREA = Cv_Area 
       AND DESCRI = Cv_Descri;

    CURSOR C_PUESTO(Cv_Descri Varchar2)IS
    SELECT PUESTO 
      FROM ARPLMP  
     WHERE NO_CIA = pv_No_Cia 
       AND DESCRI = Cv_Descri;

    CURSOR C_CEDULA (Cv_Estado Varchar2, Cv_IdArea Varchar2, Cv_IdDepto Varchar2, Cv_IdPuesto Varchar2, Cv_IdRegion Varchar2)IS
     SELECT CEDULA 
       FROM ARPLME 
      WHERE NO_CIA = pv_No_Cia 
        AND ESTADO = Cv_Estado 
        AND AREA = Cv_IdArea
        AND DEPTO = Cv_IdDepto
        AND PUESTO = Cv_IdPuesto 
        AND IND_REGION = Cv_IdRegion;


    CURSOR C_ID_PERSONA (Cv_IdentifCliente Varchar2)IS
        SELECT ID_PERSONA 
          FROM DB_COMERCIAL.INFO_PERSONA
          WHERE IDENTIFICACION_CLIENTE =Cv_IdentifCliente;

      CURSOR C_LOGIN (Cn_IdPersona Number)IS
        SELECT LOGIN 
          FROM DB_COMERCIAL.INFO_PERSONA
          WHERE ID_PERSONA =Cn_IdPersona;


    CURSOR C_PERSONA(Cv_Login Varchar2)IS
     SELECT 
                    PERSONA.ID_PERSONA ID_PERSONA, 
                    PERSONA.NOMBRES NOMBRES, 
                    PERSONA.APELLIDOS APELLIDOS, 
                    PERSONA.ESTADO ESTADO_PERSONA, 
                    DEP.ID_DEPARTAMENTO ID_DEPARTAMENTO, 
                    DEP.NOMBRE_DEPARTAMENTO NOMBRE_DEPARTAMENTO, 
                    IER.EMPRESA_COD EMPRESA_COD,
                    IPER.ID_PERSONA_ROL ID_PERSONA_EMPRESA_ROL,
                    OFICINA.ID_OFICINA,
                    CANTON.NOMBRE_CANTON,
                    CANTON.ID_CANTON,
                    PERSONA.IDENTIFICACION_CLIENTE IDENTIFICACION_CLIENTE
                FROM 
                    DB_COMERCIAL.INFO_PERSONA PERSONA,
                    DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
                    DB_GENERAL.ADMI_DEPARTAMENTO DEP,
                    DB_COMERCIAL.INFO_EMPRESA_ROL IER,
                    DB_COMERCIAL.INFO_OFICINA_GRUPO OFICINA,
                    DB_GENERAL.ADMI_CANTON CANTON
                WHERE 
                    PERSONA.ID_PERSONA = IPER.PERSONA_ID
                AND IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL
                AND IPER.DEPARTAMENTO_ID = DEP.ID_DEPARTAMENTO
                AND IPER.OFICINA_ID = OFICINA.ID_OFICINA
                AND OFICINA.CANTON_ID = CANTON.ID_CANTON
                AND IER.EMPRESA_COD = pv_No_Cia
                AND PERSONA.LOGIN = Cv_Login
                AND IPER.ESTADO = 'Activo';

   CURSOR C_EXISTE_PERSONA (Cv_Cedula Varchar2)IS
   SELECT ID_PERSONA 
     FROM DB_COMERCIAL.INFO_PERSONA
    WHERE IDENTIFICACION_CLIENTE = Cv_Cedula;

  Lv_RefAsignadoId    Varchar2(30);
  Lv_LoginEmple       Varchar2(30);
  Lr_Persona          C_PERSONA%ROWTYPE;
  Lv_Cedula           ARPLME.CEDULA%TYPE;
  Lv_Estado           Varchar2(1):= 'A';
  Lv_IdGrupoPArametro Varchar2(30):='SAC_RECIBE_EQUIPO';
  Lv_IdAplicacion     Varchar2(2):= 'IN';
  Lv_NoCia            Varchar2(2);
  Lv_Region           Varchar2(1);
  Lv_Area             ARPLAR.DESCRI%TYPE;
  Lv_IdArea           ARPLAR.AREA%TYPE;
  Lv_Departamento     ARPLDP.DESCRI%TYPE;
  Lv_IdDepto          ARPLDP.DEPA%TYPE;
  Lv_Puesto           ARPLMP.DESCRI%TYPE;
  Lv_IdPuesto         ARPLMP.PUESTO%TYPE;

begin
  -- Call the procedure
  IF C_PARAMETROS%ISOPEN THEN CLOSE C_PARAMETROS; END IF;
    OPEN C_PARAMETROS(Lv_Estado, Lv_IdGrupoPArametro, Lv_IdAplicacion,'NO_CIA');
    FETCH C_PARAMETROS INTO Lv_NoCia;
    CLOSE C_PARAMETROS;

    IF C_AREA%ISOPEN THEN CLOSE C_AREA; END IF;
    OPEN C_AREA(Lv_Area);
    FETCH C_AREA INTO Lv_IdArea;
    CLOSE C_AREA;

    IF C_PARAMETROS%ISOPEN THEN CLOSE C_PARAMETROS; END IF;
    OPEN C_PARAMETROS(Lv_Estado, Lv_IdGrupoPArametro, Lv_IdAplicacion,'DEPTO');
    FETCH C_PARAMETROS INTO Lv_Departamento;
    CLOSE C_PARAMETROS;

    --    
    IF C_DEPTO%ISOPEN THEN CLOSE C_DEPTO; END IF;
    OPEN C_DEPTO(Lv_IdArea,Lv_Departamento );
    FETCH C_DEPTO INTO Lv_IdDepto;
    CLOSE C_DEPTO;
    --
    IF C_PARAMETROS%ISOPEN THEN CLOSE C_PARAMETROS; END IF;
    OPEN C_PARAMETROS(Lv_Estado, Lv_IdGrupoPArametro, Lv_IdAplicacion,'PUESTO');
    FETCH C_PARAMETROS INTO Lv_Puesto;
    CLOSE C_PARAMETROS;

    IF C_PUESTO%ISOPEN THEN CLOSE C_PUESTO; END IF;
    OPEN C_PUESTO(Lv_Puesto);
    FETCH C_PUESTO INTO Lv_IdPuesto;
    CLOSE C_PUESTO;

    IF C_REGION%ISOPEN THEN CLOSE C_REGION; END IF;
    OPEN C_REGION;
    FETCH C_REGION INTO Lv_Region;
    CLOSE C_REGION;

    IF pv_TXT_TECNICO IS NULL THEN
      IF C_ASIGNADO%ISOPEN THEN CLOSE C_ASIGNADO; END IF;
      OPEN C_ASIGNADO (pn_ID_DETALLE_SOLICITUD);
      FETCH C_ASIGNADO INTO Lv_RefAsignadoId;
      --
      --
      IF (C_ASIGNADO%NOTFOUND OR Lv_RefAsignadoId IS NULL OR Lv_RefAsignadoId = 0)  THEN
        IF  pv_No_Cia = Lv_NoCia THEN 
          IF C_CEDULA%ISOPEN THEN CLOSE C_CEDULA; END IF;
          OPEN C_CEDULA(Lv_Estado,Lv_IdArea, Lv_IdDepto, Lv_IdPuesto , Lv_Region );
          FETCH C_CEDULA INTO Lv_Cedula;
          CLOSE C_CEDULA;

          IF C_ID_PERSONA%ISOPEN THEN CLOSE C_ID_PERSONA; END IF;
          OPEN C_ID_PERSONA(Lv_Cedula);
          FETCH C_ID_PERSONA INTO Lv_RefAsignadoId;
          CLOSE C_ID_PERSONA;

      ELSE
          IF C_EXISTE_PERSONA%ISOPEN THEN CLOSE C_EXISTE_PERSONA; END IF;
          OPEN C_EXISTE_PERSONA(pv_TXT_CED_ASIGNADO_RESPONSABL);--:BL_ELEMENTOS.TXT_CEDULA_ASIGNADO_RESPONSABL);
          FETCH C_EXISTE_PERSONA INTO Lv_RefAsignadoId;
          CLOSE C_EXISTE_PERSONA;
        END IF;       
      END IF;
      CLOSE C_ASIGNADO;             
    ELSE  
      Lv_RefAsignadoId := pv_TXT_TECNICO;--:BL_FILTROS.TXT_TECNICO ;
    END IF;
    --
    IF C_LOGIN%ISOPEN THEN CLOSE C_LOGIN; END IF;
    OPEN C_LOGIN(Lv_RefAsignadoId);
    FETCH C_LOGIN INTO Lv_LoginEmple;
      IF C_PERSONA%ISOPEN THEN CLOSE C_PERSONA; END IF;
      OPEN C_PERSONA(Lv_LoginEmple);
      FETCH C_PERSONA INTO Lr_Persona;
        IF C_PERSONA%NOTFOUND THEN
          IF pv_No_Cia = Lv_NoCia THEN
            --
            IF C_CEDULA%ISOPEN THEN CLOSE C_CEDULA; END IF;
            OPEN C_CEDULA(Lv_Estado,Lv_IdArea, Lv_IdDepto, Lv_IdPuesto , Lv_Region );
            FETCH C_CEDULA INTO Lv_Cedula;
            CLOSE C_CEDULA;

            IF C_ID_PERSONA%ISOPEN THEN CLOSE C_ID_PERSONA; END IF;
            OPEN C_ID_PERSONA(Lv_Cedula);
            FETCH C_ID_PERSONA INTO Lv_RefAsignadoId;
            CLOSE C_ID_PERSONA;
            pv_REF_ASIGNADO_ID--:BL_SOLICITUDES.REF_ASIGNADO_ID
            :=Lv_RefAsignadoId;
                --
          ELSE
              IF C_EXISTE_PERSONA%ISOPEN THEN CLOSE C_EXISTE_PERSONA; END IF;
              OPEN C_EXISTE_PERSONA(pv_TXT_CED_ASIGNADO_RESPONSABL);--:BL_ELEMENTOS.TXT_CEDULA_ASIGNADO_RESPONSABL);
              FETCH C_EXISTE_PERSONA INTO pv_REF_ASIGNADO_ID;--:BL_SOLICITUDES.REF_ASIGNADO_ID;
              CLOSE C_EXISTE_PERSONA;
          END IF;
        ELSE
            pv_REF_ASIGNADO_ID--:BL_SOLICITUDES.REF_ASIGNADO_ID
            :=Lv_RefAsignadoId;          
        END IF;
      CLOSE C_PERSONA;
    CLOSE C_LOGIN;  

  EXCEPTION
    WHEN OTHERS THEN
       --MSG_AVISO ('Error en PostQuery Bl_Solicitudes: '|| SQLERRM);
     pn_error := 99;
     pv_error := 'Error en PostQuery Bl_Solicitudes: '|| substr(SQLERRM,1,250);
END;     



end MPK_MIGRA_NAF_FORMA_PIN277;
/