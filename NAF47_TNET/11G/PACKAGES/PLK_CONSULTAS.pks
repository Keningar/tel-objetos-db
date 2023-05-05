CREATE OR REPLACE PACKAGE            PLK_CONSULTAS AS
  --Procedimiento que recupera el registro del empleado
  PROCEDURE PLP_REG_EMPLEADO(Pv_IdEmpresa    IN VARCHAR2,
                             Pv_IdEmpleado   IN VARCHAR2,
                             Pv_Usuario      IN VARCHAR2,
                             Pr_RegEmpleado  OUT ARPLME%ROWTYPE,
                             Pv_CodigoError  OUT VARCHAR2,
                             Pv_MensajeError OUT VARCHAR2);
  --
  FUNCTION PLF_NOMBRE_EMPLEADO(Pv_IdEmpresa  IN VARCHAR2,
                               Pv_IdEmpleado IN VARCHAR2) RETURN VARCHAR2;
  --
  PROCEDURE CONSULTA_REEMPLAZO(Pv_IdEmpresa    IN VARCHAR2,
                               Pv_IdEmpleado   IN VARCHAR2,
                               Pr_Reemplazo    OUT TAPHISTORICO_REEMPLAZOS%ROWTYPE,
                               Pv_CodigoError  OUT VARCHAR2,
                               Pv_MensajeError OUT VARCHAR2);

  PROCEDURE CONSULTA_EMPLEADO(Pv_IdEmpresa    IN VARCHAR2,
                              Pv_IdEmpleado   IN VARCHAR2,
                              Pr_Reemplazo    OUT TAPHISTORICO_REEMPLAZOS%ROWTYPE,
                              Pv_CodigoError  OUT VARCHAR2,
                              Pv_MensajeError OUT VARCHAR2);

END PLK_CONSULTAS;
/


CREATE OR REPLACE PACKAGE BODY            PLK_CONSULTAS IS
  --Procedimiento que recupera el registro del empleado
  PROCEDURE PLP_REG_EMPLEADO(Pv_IdEmpresa    IN VARCHAR2,
                             Pv_IdEmpleado   IN VARCHAR2,
                             Pv_Usuario      IN VARCHAR2,
                             Pr_RegEmpleado  OUT ARPLME%ROWTYPE,
                             Pv_CodigoError  OUT VARCHAR2,
                             Pv_MensajeError OUT VARCHAR2) IS
  
    CURSOR C_LeeEmpleadoCodigo IS
      SELECT E.NO_CIA,
             E.CEDULA,
             E.APE_PAT,
             E.APE_MAT,
             E.NOMBRE_PILA,
             E.NOMBRE_SEGUNDO,
             E.NOMBRE,
             E.NO_EMPLE,
             E.MAIL_CIA
        FROM ARPLME E
       WHERE E.NO_CIA = Pv_IdEmpresa
         AND E.NO_EMPLE = Pv_IdEmpleado;
    --
  
    CURSOR C_LeeEmpleadoUsuario IS
      SELECT E.NO_CIA,
             E.CEDULA,
             E.APE_PAT,
             E.APE_MAT,
             E.NOMBRE_PILA,
             E.NOMBRE_SEGUNDO,
             E.NOMBRE,
             E.NO_EMPLE,
             E.MAIL_CIA   
        FROM SEG47_TNET.TASGUSUARIO LE,
             ARPLME                 E
       WHERE LE.NO_CIA = E.NO_CIA
         AND LE.ID_EMPLEADO = E.NO_EMPLE
         AND E.NO_CIA = Pv_IdEmpresa
         AND LE.USUARIO = Pv_Usuario;
    --
    Lr_Empleado C_LeeEmpleadoCodigo%ROWTYPE := NULL;
    Le_Error EXCEPTION;
  BEGIN
    IF Pv_IdEmpresa IS NULL THEN
      Pv_MensajeError := 'El código de Empresa no puede ser Vacio.';
      RAISE Le_Error;
    END IF;
    --
    IF Pv_IdEmpleado IS NULL AND Pv_Usuario IS NULL THEN
      Pv_MensajeError := 'Debe de Registrar un Criterio de Consulta.';
      RAISE Le_Error;
    END IF;
    --
    IF Pv_IdEmpleado IS NOT NULL THEN
      IF C_LeeEmpleadoCodigo%ISOPEN THEN
        CLOSE C_LeeEmpleadoCodigo;
      END IF;
      OPEN C_LeeEmpleadoCodigo;
      FETCH C_LeeEmpleadoCodigo
        INTO Lr_Empleado; --Pr_RegEmpleado;
      CLOSE C_LeeEmpleadoCodigo;
    END IF;
    --
    IF Pv_Usuario IS NOT NULL THEN
      IF C_LeeEmpleadoUsuario%ISOPEN THEN
        CLOSE C_LeeEmpleadoUsuario;
      END IF;
      OPEN C_LeeEmpleadoUsuario;
      FETCH C_LeeEmpleadoUsuario
        INTO Lr_Empleado; --Pr_RegEmpleado;
      CLOSE C_LeeEmpleadoUsuario;
    END IF;
    --
    Pr_RegEmpleado.No_Cia := Lr_Empleado.No_Cia;
    Pr_RegEmpleado.CEDULA         := Lr_Empleado.CEDULA;
    Pr_RegEmpleado.APE_PAT        := Lr_Empleado.APE_PAT;
    Pr_RegEmpleado.NOMBRE_PILA    := Lr_Empleado.NOMBRE_PILA;
    Pr_RegEmpleado.NOMBRE_SEGUNDO := Lr_Empleado.NOMBRE_SEGUNDO;
    Pr_RegEmpleado.NOMBRE         := Lr_Empleado.NOMBRE;
    Pr_RegEmpleado.NO_EMPLE       := Lr_Empleado.NO_EMPLE;
    Pr_RegEmpleado.Mail_Cia       := Lr_Empleado.Mail_Cia;
    --
  EXCEPTION
    WHEN Le_Error THEN
      RETURN;
    WHEN OTHERS THEN
      Pv_CodigoError  := SQLCODE;
      Pv_MensajeError := 'Error No Contgrolado en PLP_REG_EMPLEADO ' || Pv_CodigoError || ' - ' || SQLERRM;
      RETURN;
  END PLP_REG_EMPLEADO;
  --
  FUNCTION PLF_NOMBRE_EMPLEADO(Pv_IdEmpresa  IN VARCHAR2,
                               Pv_IdEmpleado IN VARCHAR2) RETURN VARCHAR2 IS
    CURSOR C_LeeNombre IS
      SELECT NOMBRE
        FROM ARPLME
       WHERE NO_CIA = Pv_IdEmpresa
         AND NO_EMPLE = Pv_IdEmpleado;
    Lv_Nombre ARPLME.NOMBRE%TYPE := NULL;
  BEGIN
    IF C_LeeNombre%ISOPEN THEN
      CLOSE C_LeeNombre;
    END IF;
    OPEN C_LeeNombre;
    FETCH C_LeeNombre
      INTO Lv_Nombre;
    CLOSE C_LeeNombre;
    RETURN Lv_Nombre;
  END PLF_NOMBRE_EMPLEADO;
  --
  --
  PROCEDURE CONSULTA_REEMPLAZO(Pv_IdEmpresa    IN VARCHAR2,
                               Pv_IdEmpleado   IN VARCHAR2,
                               Pr_Reemplazo    OUT TAPHISTORICO_REEMPLAZOS%ROWTYPE,
                               Pv_CodigoError  OUT VARCHAR2,
                               Pv_MensajeError OUT VARCHAR2) IS
  
    --Lee el empleado reemplazo
    CURSOR C_LeeReemplazo(Cv_IdEmpresa  IN VARCHAR2,
                          Cv_IdEmpleado IN VARCHAR2) IS
      SELECT R.NO_EMPLE_REEMP
        FROM TAPHISTORICO_REEMPLAZOS R
       WHERE R.NO_CIA = Cv_IdEmpresa
         AND R.ACTIVO = 'A'
         AND TRUNC(SYSDATE) >= R.FECHA_DESDE
         AND TRUNC(SYSDATE) <= R.FECHA_HASTA
         AND R.NO_EMPLE = Cv_IdEmpleado;
    Le_Error EXCEPTION;
  BEGIN
    IF Pv_IdEmpresa IS NULL THEN
      Pv_MensajeError := 'El código de la empresa no puede ser nulo.';
      RAISE Le_Error;
    END IF;
    IF Pv_IdEmpleado IS NULL THEN
      Pv_MensajeError := 'El código del empleado no puede ser nulo.';
      RAISE Le_Error;
    END IF;
    --
    IF C_LeeReemplazo%ISOPEN THEN
      CLOSE C_LeeReemplazo;
    END IF;
    OPEN C_LeeReemplazo(Pv_IdEmpresa, Pv_IdEmpleado);
    FETCH C_LeeReemplazo
      INTO Pr_Reemplazo.NO_EMPLE_REEMP; --Pr_Reemplazo;
    CLOSE C_LeeReemplazo;
    --
    --
  EXCEPTION
    WHEN Le_Error THEN
      RETURN;
    WHEN OTHERS THEN
      Pv_CodigoError  := SQLCODE;
      Pv_MensajeError := 'Error No Controlado en PLK_CONSULTAS.CONSULTA_REEMPLAZO ' || Pv_CodigoError || ' - ' || SQLERRM;
      RETURN;
  END CONSULTA_REEMPLAZO;
  --
  PROCEDURE CONSULTA_EMPLEADO(Pv_IdEmpresa    IN VARCHAR2,
                              Pv_IdEmpleado   IN VARCHAR2,
                              Pr_Reemplazo    OUT TAPHISTORICO_REEMPLAZOS%ROWTYPE,
                              Pv_CodigoError  OUT VARCHAR2,
                              Pv_MensajeError OUT VARCHAR2) IS
  
    --Lee el empleado que esta siendo reemplazado
    CURSOR C_LeeEmpleado(Cv_IdEmpresa  IN VARCHAR2,
                         Cv_IdEmpleado IN VARCHAR2) IS
      SELECT R.NO_EMPLE
        FROM TAPHISTORICO_REEMPLAZOS R
       WHERE R.NO_CIA = Cv_IdEmpresa
         AND R.ACTIVO = 'A'
         AND TRUNC(SYSDATE) >= R.FECHA_DESDE
         AND TRUNC(SYSDATE) <= R.FECHA_HASTA
         AND R.NO_EMPLE_REEMP = Cv_IdEmpleado;
    Le_Error EXCEPTION;
  BEGIN
    IF Pv_IdEmpresa IS NULL THEN
      Pv_MensajeError := 'El código de la empresa no puede ser nulo.';
      RAISE Le_Error;
    END IF;
    IF Pv_IdEmpleado IS NULL THEN
      Pv_MensajeError := 'El código del empleado no puede ser nulo.';
      RAISE Le_Error;
    END IF;
    --
    IF C_LeeEmpleado%ISOPEN THEN
      CLOSE C_LeeEmpleado;
    END IF;
    OPEN C_LeeEmpleado(Pv_IdEmpresa, Pv_IdEmpleado);
    FETCH C_LeeEmpleado
      INTO Pr_Reemplazo.NO_EMPLE;
    CLOSE C_LeeEmpleado;
    --
  EXCEPTION
    WHEN Le_Error THEN
      RETURN;
    WHEN OTHERS THEN
      Pv_CodigoError  := SQLCODE;
      Pv_MensajeError := 'Error No Controlado en PLK_CONSULTAS.CONSULTA_EMPLEADO ' || Pv_CodigoError || ' - ' || SQLERRM;
      RETURN;
  END CONSULTA_EMPLEADO;
END PLK_CONSULTAS;
/
