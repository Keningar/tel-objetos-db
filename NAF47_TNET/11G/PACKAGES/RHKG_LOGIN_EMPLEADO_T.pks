CREATE OR REPLACE PACKAGE            RHKG_LOGIN_EMPLEADO_T AS 

    /**
     * Inserta un registro en LOGIN_EMPLEADO
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @since 1.0 28-10-2018 
     **/
    PROCEDURE P_INSERT_LOGIN_EMPLEADO (
        Pr_LoginEmpleado   IN                 LOGIN_EMPLEADO%ROWTYPE,
        Pv_Status          OUT                VARCHAR2,
        Pv_Code            OUT                VARCHAR2,
        Pv_Msn             OUT                VARCHAR2
    );

    /**
     * Actualiza un registro en LOGIN_EMPLEADO
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @since 1.0 28-10-2018 
     **/

    PROCEDURE P_UPDATE_LOGIN_EMPLEADO (
        Pr_LoginEmpleado   IN                 LOGIN_EMPLEADO%ROWTYPE,
        Pv_Status          OUT                VARCHAR2,
        Pv_Code            OUT                VARCHAR2,
        Pv_Msn             OUT                VARCHAR2
    );

END RHKG_LOGIN_EMPLEADO_T;
/


CREATE OR REPLACE PACKAGE BODY            RHKG_LOGIN_EMPLEADO_T AS

    PROCEDURE P_INSERT_LOGIN_EMPLEADO (
        Pr_LoginEmpleado   IN                 LOGIN_EMPLEADO%ROWTYPE,
        Pv_Status          OUT                VARCHAR2,
        Pv_Code            OUT                VARCHAR2,
        Pv_Msn             OUT                VARCHAR2
    ) AS
    BEGIN
        INSERT INTO LOGIN_EMPLEADO (
            NO_CIA,
            NO_EMPLE,
            CEDULA,
            LOGIN,
            PASSWORD
        ) VALUES (
            Pr_LoginEmpleado.NO_CIA,
            Pr_LoginEmpleado.NO_EMPLE,
            Pr_LoginEmpleado.CEDULA,
            Pr_LoginEmpleado.LOGIN,
            Pr_LoginEmpleado.PASSWORD
        );

        Pv_Status := GEKG_TYPE.GENERATED_STATUS;
        Pv_Code := GEKG_TYPE.GENERATED_CODE;
        Pv_Msn := 'Instancia generada';
    EXCEPTION
        WHEN OTHERS THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_INSERT_LOGIN_EMPLEADO;

    PROCEDURE P_UPDATE_LOGIN_EMPLEADO (
        Pr_LoginEmpleado   IN                 LOGIN_EMPLEADO%ROWTYPE,
        Pv_Status          OUT                VARCHAR2,
        Pv_Code            OUT                VARCHAR2,
        Pv_Msn             OUT                VARCHAR2
    ) AS
    BEGIN
        UPDATE LOGIN_EMPLEADO
        SET
            CEDULA = Pr_LoginEmpleado.CEDULA,
            LOGIN = Pr_LoginEmpleado.LOGIN,
            PASSWORD = Pr_LoginEmpleado.PASSWORD
        WHERE
            NO_CIA = Pr_LoginEmpleado.NO_CIA
            AND NO_EMPLE = Pr_LoginEmpleado.NO_EMPLE;

        Pv_Status := GEKG_TYPE.GENERATED_STATUS;
        Pv_Code := GEKG_TYPE.GENERATED_CODE;
        Pv_Msn := 'Instancia generada';
    EXCEPTION
        WHEN OTHERS THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_UPDATE_LOGIN_EMPLEADO;

END RHKG_LOGIN_EMPLEADO_T;
/
