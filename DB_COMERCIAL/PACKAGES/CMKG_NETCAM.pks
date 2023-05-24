CREATE OR REPLACE package DB_COMERCIAL.CMKG_NETCAM is
  /**
  * Documentaci�n para la funci�n F_GENERATE_TOKEN
  *
  * Funci�n encargada para generar un token en el portal 3dEYE
  *
  * @param Fv_Username        IN  VARCHAR2 Recibe usuario del customer
  * @param Fv_Password        IN  VARCHAR2 Recibe password del customer
  * @param Fv_ApiKey          IN  VARCHAR2 Recibe api-key del customer
  * RETURN                    OUT VARCHAR2 Retorna token del customer
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  */
  FUNCTION F_GENERATE_TOKEN(Fv_Username IN VARCHAR2,
                            Fv_Password IN VARCHAR2,
                            Fv_ApiKey   IN VARCHAR2)
  RETURN VARCHAR2;
  
  /**
  * Documentaci�n para el procedimiento P_CORTE_SERVICIO_NETCAM
  *
  * M�todo encargado de cortar el servicio netcam
  *
  * @param Pn_IdServicio       IN  NUMBER   Recibe id del servicio
  * @param Pn_IdAccion         IN  NUMBER   Recibe id de la acci�n
  * @param Pv_User             IN  VARCHAR2 Recibe usuario logeado
  * @param Pv_Status           OUT VARCHAR2 Retorna estado de la transacci�n
  * @param Pv_Mensaje          OUT VARCHAR2 Retorna mensaje de la transacci�n
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  */
  PROCEDURE P_CORTE_SERVICIO_NETCAM(Pn_IdServicio IN  NUMBER,
                                    Pn_IdAccion   IN  NUMBER,
                                    Pv_User       IN  VARCHAR2,
                                    Pv_Status     OUT VARCHAR2,
                                    Pv_Mensaje    OUT VARCHAR2);
  
  /**
  * Documentaci�n para el procedimiento P_ROLLBACK_CORTE_NETCAM
  *
  * M�todo encargado de hacer el roolback del proceso cortar servicio netcam
  *
  * @param Pv_IdCam       IN  VARCHAR2 Recibe id de la c�mara
  * @param Pv_IdRol       IN  VARCHAR2 Recibe id del rol
  * @param Pv_ApiKey      IN  VARCHAR2 Recibe api-key del customer
  * @param Pv_Token       IN  VARCHAR2 Recibe token del customer
  * @param Pv_User        IN  VARCHAR2 Recibe usuario logeado
  * @param Pv_Status      OUT VARCHAR2 Retorna estado de la transacci�n
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  */
  PROCEDURE P_ROLLBACK_CORTE_NETCAM(Pv_IdCam   IN  VARCHAR2,
                                    Pv_IdRol   IN  VARCHAR2,
                                    Pv_ApiKey  IN  VARCHAR2,
                                    Pv_Token   IN  VARCHAR2,
                                    Pv_User    IN  VARCHAR2,
                                    Pv_Status  OUT VARCHAR2);
  
  /**
  * Documentaci�n para la funci�n F_REMOVER_CAM_ROL
  *
  * Funci�n encargada de remover una c�mara de un rol en el portal 3dEYE
  *
  * @param Fv_IdCam        IN  VARCHAR2 Recibe id de la c�mara
  * @param Fv_IdRol        IN  VARCHAR2 Recibe id del rol
  * @param Fv_ApiKey       IN  VARCHAR2 Recibe api-key del customer
  * @param Fv_Token        IN  VARCHAR2 Recibe token del customer
  * RETURN                 OUT BOOLEAN  Retorna TRUE/FALSE seg�n su �xito
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  */                                  
  FUNCTION F_REMOVER_CAM_ROL(Fv_IdCam  IN VARCHAR2,
                             Fv_IdRol  IN VARCHAR2,
                             Fv_ApiKey IN VARCHAR2,
                             Fv_Token  IN VARCHAR2)
  RETURN BOOLEAN;
  
  /**
  * Documentaci�n para la funci�n F_REMOVER_USER_ROL
  *
  * Funci�n encargada de remover un usuario de un rol en el portal 3dEYE
  *
  * @param Fv_IdUser       IN  VARCHAR2 Recibe id del usuario
  * @param Fv_IdRol        IN  VARCHAR2 Recibe id del rol
  * @param Fv_ApiKey       IN  VARCHAR2 Recibe api-key del customer
  * @param Fv_Token        IN  VARCHAR2 Recibe token del customer
  * RETURN                 OUT BOOLEAN  Retorna TRUE/FALSE seg�n su �xito
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  */  
  FUNCTION F_REMOVER_USER_ROL(Fv_IdUser IN VARCHAR2,
                              Fv_IdRol  IN VARCHAR2,
                              Fv_ApiKey IN VARCHAR2,
                              Fv_Token  IN VARCHAR2)
  RETURN BOOLEAN;
  
  /**
  * Documentaci�n para la funci�n F_ASIGNAR_CAM_ROL
  *
  * Funci�n encargada de asignar una c�mara a un rol en el portal 3dEYE
  *
  * @param Fv_IdCam        IN  VARCHAR2 Recibe id de la c�mara
  * @param Fv_IdRol        IN  VARCHAR2 Recibe id del rol
  * @param Fv_ApiKey       IN  VARCHAR2 Recibe api-key del customer
  * @param Fv_Token        IN  VARCHAR2 Recibe token del customer
  * RETURN                 OUT BOOLEAN  Retorna TRUE/FALSE seg�n su �xito
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  */ 
  FUNCTION F_ASIGNAR_CAM_ROL(Fv_IdCam  IN VARCHAR2,
                             Fv_IdRol  IN VARCHAR2,
                             Fv_ApiKey IN VARCHAR2,
                             Fv_Token  IN VARCHAR2)
  RETURN BOOLEAN;
  
  /**
  * Documentaci�n para la funci�n F_ASIGNAR_USER_ROL
  *
  * Funci�n encargada de asignar un usuario a un rol en el portal 3dEYE
  *
  * @param Fv_IdUser       IN  VARCHAR2 Recibe id del usuario
  * @param Fv_IdRol        IN  VARCHAR2 Recibe id del rol
  * @param Fv_ApiKey       IN  VARCHAR2 Recibe api-key del customer
  * @param Fv_Token        IN  VARCHAR2 Recibe token del customer
  * RETURN                 OUT BOOLEAN  Retorna TRUE/FALSE seg�n su �xito
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  */ 
  FUNCTION F_ASIGNAR_USER_ROL(Fv_IdUser IN VARCHAR2,
                              Fv_IdRol  IN VARCHAR2,
                              Fv_ApiKey IN VARCHAR2,
                              Fv_Token  IN VARCHAR2)
  RETURN BOOLEAN;
  
  /**
  * Documentaci�n para la funci�n F_ELIMINAR_CAM
  *
  * Funci�n encargada de eliminar una c�mara en el portal 3dEYE
  *
  * @param Fv_IdCam        IN  VARCHAR2 Recibe id de la c�mara
  * @param Fv_ApiKey       IN  VARCHAR2 Recibe api-key del customer
  * @param Fv_Token        IN  VARCHAR2 Recibe token del customer
  * RETURN                 OUT BOOLEAN  Retorna TRUE/FALSE seg�n su �xito
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  */
  FUNCTION F_ELIMINAR_CAM(Fv_IdCam  IN VARCHAR2,
                          Fv_ApiKey IN VARCHAR2,
                          Fv_Token  IN VARCHAR2)
  RETURN BOOLEAN;
  
  /**
  * Documentaci�n para la funci�n F_ELIMINAR_USER
  *
  * Funci�n encargada de eliminar un  en el portal 3dEYE
  *
  * @param Fv_IdUser       IN  VARCHAR2 Recibe id del usuario
  * @param Fv_ApiKey       IN  VARCHAR2 Recibe api-key del customer
  * @param Fv_Token        IN  VARCHAR2 Recibe token del customer
  * RETURN                 OUT BOOLEAN  Retorna TRUE/FALSE seg�n su �xito
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  */
  FUNCTION F_ELIMINAR_USER(Fv_IdUser  IN VARCHAR2,
                           Fv_ApiKey  IN VARCHAR2,
                           Fv_Token   IN VARCHAR2)
  RETURN BOOLEAN;
  
  /**
  * Documentaci�n para la funci�n F_VALIDAR_ESTADO_CAM
  *
  * Funci�n encargada de validar el estado de una c�mara en el portal 3dEYE
  *
  * @param Fv_IdCam              IN  VARCHAR2 Recibe id de la c�mara
  * @param Fv_TipoActivacion     IN  VARCHAR2 Recibe el tipo de activaci�n
  * @param Fv_ApiKey             IN  VARCHAR2 Recibe api-key del customer
  * @param Fv_Token              IN  VARCHAR2 Recibe token del customer
  * RETURN                       OUT BOOLEAN  Retorna TRUE/FALSE seg�n su �xito
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  */
  FUNCTION F_VALIDAR_ESTADO_CAM(Fv_IdCam          IN VARCHAR2,
                                Fv_TipoActivacion IN VARCHAR2,
                                Fv_ApiKey         IN VARCHAR2,
                                Fv_Token          IN VARCHAR2)
  RETURN BOOLEAN;
  
  /**
  * Documentaci�n para la funci�n F_ELIMINAR_ROL
  *
  * Funci�n encargada de eliminar un rol en el portal 3dEYE
  *
  * @param Fv_IdRol        IN  VARCHAR2 Recibe id del rol
  * @param Fv_ApiKey       IN  VARCHAR2 Recibe api-key del customer
  * @param Fv_Token        IN  VARCHAR2 Recibe token del customer
  * RETURN                 OUT BOOLEAN  Retorna TRUE/FALSE seg�n su �xito
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  */
  FUNCTION F_ELIMINAR_ROL(Fv_IdRol  IN VARCHAR2,
                          Fv_ApiKey IN VARCHAR2,
                          Fv_Token  IN VARCHAR2)
  RETURN BOOLEAN;
  
  /**
  * Documentaci�n para el procedimiento P_CREAR_CAM_P2P
  *
  * M�todo encargado para crear una c�mara P2P
  *
  * @param Pv_NombreCam      IN  VARCHAR2 Recibe nombre de la c�mara
  * @param Pv_CodigoPush     IN  VARCHAR2 Recibe c�digo push
  * @param Pv_AdminUser      IN  VARCHAR2 Recibe usuario de la c�mara
  * @param Pv_AdminPass      IN  VARCHAR2 Recibe pass de la c�mara
  * @param Pv_ApiKey         IN  VARCHAR2 Recibe api-key del customer
  * @param Pv_Token          IN  VARCHAR2 Recibe token del customer
  * @param Pv_Status         OUT VARCHAR2 Retorna estatus de la transacci�n
  * @param Pv_Mensaje        OUT VARCHAR2 Retorna mensaje de la transacci�n
  * @param Pcl_Data          OUT CLOB     Retorna data de la transacci�n
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  */
  PROCEDURE P_CREAR_CAM_P2P(Pv_NombreCam  IN  VARCHAR2,
                            Pv_CodigoPush IN  VARCHAR2,
                            Pv_AdminUser  IN  VARCHAR2,
                            Pv_AdminPass  IN  VARCHAR2,
                            Pv_ApiKey     IN  VARCHAR2,
                            Pv_Token      IN  VARCHAR2,
                            Pv_Status     OUT VARCHAR2,
                            Pv_Mensaje    OUT VARCHAR2,
                            Pcl_Data      OUT CLOB);
  
  /**
  * Documentaci�n para el procedimiento P_CREAR_CAM_ONVIF
  *
  * M�todo encargado para crear una c�mara ONVIF
  *
  * @param Pcl_DatosONVIF         JSON REQUEST
  * {
  *  @param Pv_NombreCam      IN  VARCHAR2 Recibe nombre de la c�mara
  *  @param Pv_UrlHTTP        IN  VARCHAR2 Recibe url HTTP de la c�mara
  *  @param Pn_PuertoHTTP     IN  NUMBER   Recibe puerto HTTP de la c�mara
  *  @param Pn_PuertoRTSP     IN  NUMBER   Recibe puerto RTSP de la c�mara
  *  @param Pv_AdminUser      IN  VARCHAR2 Recibe usuario de la c�mara
  *  @param Pv_AdminPass      IN  VARCHAR2 Recibe pass de la c�mara
  *  }
  * @param Pv_ApiKey         IN  VARCHAR2 Recibe api-key del customer
  * @param Pv_Token          IN  VARCHAR2 Recibe token del customer
  * @param Pv_Status         OUT VARCHAR2 Retorna estatus de la transacci�n
  * @param Pv_Mensaje        OUT VARCHAR2 Retorna mensaje de la transacci�n
  * @param Pcl_Data          OUT CLOB     Retorna data de la transacci�n
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  */                         
  PROCEDURE P_CREAR_CAM_ONVIF(Pcl_DatosONVIF  IN  CLOB,
                              Pv_ApiKey       IN  VARCHAR2,
                              Pv_Token        IN  VARCHAR2,
                              Pv_Status       OUT VARCHAR2,
                              Pv_Mensaje      OUT VARCHAR2,
                              Pcl_Data        OUT CLOB);
  
  /**
  * Documentaci�n para el procedimiento P_CREAR_CAM_GENERIC
  *
  * M�todo encargado para crear una c�mara GENERIC
  *
  * @param Pcl_DatosGENERIC       JSON REQUEST
  * {
  *  @param Pv_NombreCam      IN  VARCHAR2 Recibe nombre de la c�mara
  *  @param Pv_UrlHTTP        IN  VARCHAR2 Recibe url HTTP de la c�mara
  *  @param Pn_PuertoHTTP     IN  NUMBER   Recibe puerto HTTP de la c�mara
  *  @param Pv_UrlRTSP        IN  VARCHAR2 Recibe url RTSP de la c�mara
  *  @param Pn_PuertoRTSP     IN  NUMBER   Recibe puerto RTSP de la c�mara
  *  @param Pv_DeviceBrand    IN  VARCHAR2 Recibe fabricante de la c�mara
  *  @param Pv_AdminUser      IN  VARCHAR2 Recibe usuario de la c�mara
  *  @param Pv_AdminPass      IN  VARCHAR2 Recibe pass de la c�mara
  *  }
  * @param Pv_ApiKey         IN  VARCHAR2 Recibe api-key del customer
  * @param Pv_Token          IN  VARCHAR2 Recibe token del customer
  * @param Pv_Status         OUT VARCHAR2 Retorna estatus de la transacci�n
  * @param Pv_Mensaje        OUT VARCHAR2 Retorna mensaje de la transacci�n
  * @param Pcl_Data          OUT CLOB     Retorna data de la transacci�n
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  */                           
  PROCEDURE P_CREAR_CAM_GENERIC(Pcl_DatosGENERIC IN  CLOB,
                                Pv_ApiKey        IN  VARCHAR2,
                                Pv_Token         IN  VARCHAR2,
                                Pv_Status        OUT VARCHAR2,
                                Pv_Mensaje       OUT VARCHAR2,
                                Pcl_Data         OUT CLOB);
  
  /**
  * Documentaci�n para el procedimiento P_CREAR_ROL
  *
  * M�todo encargado para crear un rol en el portal 3dEYE
  *
  * @param Pv_NombreRol      IN  VARCHAR2 Recibe nombre del rol
  * @param Pv_Descripcion    IN  VARCHAR2 Recibe descripci�n del rol
  * @param Pv_Type           IN  VARCHAR2 Recibe tipo de rol
  * @param Pv_ApiKey         IN  VARCHAR2 Recibe api-key del customer
  * @param Pv_Token          IN  VARCHAR2 Recibe token del customer
  * @param Pv_Status         OUT VARCHAR2 Retorna estatus de la transacci�n
  * @param Pv_Mensaje        OUT VARCHAR2 Retorna mensaje de la transacci�n
  * @param Pcl_Data          OUT CLOB     Retorna data de la transacci�n
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  */                          
  PROCEDURE P_CREAR_ROL(Pv_NombreRol   IN  VARCHAR2,
                        Pv_Descripcion IN  VARCHAR2,
                        Pv_Type        IN  VARCHAR2,
                        Pv_ApiKey      IN  VARCHAR2,
                        Pv_Token       IN  VARCHAR2,
                        Pv_Status      OUT VARCHAR2,
                        Pv_Mensaje     OUT VARCHAR2,
                        Pcl_Data       OUT CLOB);
  
  /**
  * Documentaci�n para el procedimiento P_LISTA_USERS_BY_ROL
  *
  * M�todo encargado de listar los usuarios de un rol en el portal 3dEYE
  *
  * @param Pn_IdRol          IN  VARCHAR2 Recibe id del rol
  * @param Pv_ApiKey         IN  VARCHAR2 Recibe api-key del customer
  * @param Pv_Token          IN  VARCHAR2 Recibe token del customer
  * @param Pv_Status         OUT VARCHAR2 Retorna estatus de la transacci�n
  * @param Pv_Mensaje        OUT VARCHAR2 Retorna mensaje de la transacci�n
  * @param Pcl_Data          OUT CLOB     Retorna data de la transacci�n
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  */                     
  PROCEDURE P_LISTA_USERS_BY_ROL(Pn_IdRol   IN  VARCHAR2,
                                 Pv_ApiKey  IN  VARCHAR2,
                                 Pv_Token   IN  VARCHAR2,
                                 Pv_Status  OUT VARCHAR2,
                                 Pv_Mensaje OUT VARCHAR2,
                                 Pcl_Data   OUT CLOB);
  
  /**
  * Documentaci�n para el procedimiento P_VALIDAR_ROL
  *
  * M�todo encargado de validar un rol en el portal 3dEYE
  *
  * @param Pv_NombreRol      IN  VARCHAR2 Recibe nombre del rol
  * @param Pv_ApiKey         IN  VARCHAR2 Recibe api-key del customer
  * @param Pv_Token          IN  VARCHAR2 Recibe token del customer
  * @param Pv_Status         OUT VARCHAR2 Retorna estatus de la transacci�n
  * @param Pv_Mensaje        OUT VARCHAR2 Retorna mensaje de la transacci�n
  * @param Pn_IdRol          OUT NUMBER   Retorna id del rol
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  */                              
  PROCEDURE P_VALIDAR_ROL(Pv_NombreRol IN  VARCHAR2,
                          Pv_ApiKey    IN  VARCHAR2,
                          Pv_Token     IN  VARCHAR2,
                          Pv_Status    OUT VARCHAR2,
                          Pv_Mensaje   OUT VARCHAR2,
                          Pn_IdRol     OUT NUMBER);
                          
  /**
  * Documentaci�n para el procedimiento P_VALIDAR_CAM
  *
  * M�todo encargado de validar una c�mara en el portal 3dEYE
  *
  * @param Pv_NombreCam      IN  VARCHAR2 Recibe nombre de la c�mara
  * @param Pv_ApiKey         IN  VARCHAR2 Recibe api-key del customer
  * @param Pv_Token          IN  VARCHAR2 Recibe token del customer
  * @param Pv_Status         OUT VARCHAR2 Retorna estatus de la transacci�n
  * @param Pv_Mensaje        OUT VARCHAR2 Retorna mensaje de la transacci�n
  * @param Pn_IdCam          OUT NUMBER   Retorna id de la c�mara
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  */                              
  PROCEDURE P_VALIDAR_CAM(Pv_NombreCam IN  VARCHAR2,
                          Pv_ApiKey    IN  VARCHAR2,
                          Pv_Token     IN  VARCHAR2,
                          Pv_Status    OUT VARCHAR2,
                          Pv_Mensaje   OUT VARCHAR2,
                          Pn_IdCam     OUT NUMBER);
  
  /**
  * Documentaci�n para el procedimiento P_REACTIVACION_SERVICIO_NETCAM
  *
  * M�todo encargado de reconectar el servicio netcam
  *
  * @param Pn_IdServicio       IN  NUMBER   Recibe id del servicio
  * @param Pn_IdAccion         IN  NUMBER   Recibe id de la acci�n
  * @param Pv_User             IN  VARCHAR2 Recibe usuario logeado
  * @param Pv_Status           OUT VARCHAR2 Retorna estado de la transacci�n
  * @param Pv_Mensaje          OUT VARCHAR2 Retorna mensaje de la transacci�n
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  */
  PROCEDURE P_REACTIVACION_SERVICIO_NETCAM(Pn_IdServicio IN  NUMBER,
                                           Pn_IdAccion   IN  NUMBER,
                                           Pv_User       IN  VARCHAR2,
                                           Pv_Status     OUT VARCHAR2,
                                           Pv_Mensaje    OUT VARCHAR2);
  
  /**
  * Documentaci�n para el procedimiento P_ROLLBACK_REACTIVACION_NETCAM
  *
  * M�todo encargado de hacer el roolback del proceso reconectar servicio netcam
  *
  * @param Pv_IdCam       IN  VARCHAR2 Recibe id de la c�mara
  * @param Pv_IdRol       IN  VARCHAR2 Recibe id del rol
  * @param Pv_ApiKey      IN  VARCHAR2 Recibe api-key del customer
  * @param Pv_Token       IN  VARCHAR2 Recibe token del customer
  * @param Pv_User        IN  VARCHAR2 Recibe usuario logeado
  * @param Pv_Status      OUT VARCHAR2 Retorna estado de la transacci�n
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  */                                        
  PROCEDURE P_ROLLBACK_REACTIVACION_NETCAM(Pv_IdCam   IN  VARCHAR2,
                                           Pv_IdRol   IN  VARCHAR2,
                                           Pv_ApiKey  IN  VARCHAR2,
                                           Pv_Token   IN  VARCHAR2,
                                           Pv_User    IN  VARCHAR2,
                                           Pv_Status  OUT VARCHAR2);
  
  /**
  * Documentaci�n para el procedimiento P_CANCELACION_SERVICIO_NETCAM
  *
  * M�todo encargado de cancelar el servicio netcam
  *
  * @param Pn_IdServicio       IN  NUMBER   Recibe id del servicio
  * @param Pn_IdAccion         IN  NUMBER   Recibe id de la acci�n
  * @param Pv_EsMasivo         IN  VARCHAR2 S = Si es masivo, N = No es masivo
  * @param Pv_User             IN  VARCHAR2 Recibe usuario logeado
  * @param Pv_Status           OUT VARCHAR2 Retorna estado de la transacci�n
  * @param Pv_Mensaje          OUT VARCHAR2 Retorna mensaje de la transacci�n
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  */                                         
  PROCEDURE P_CANCELACION_SERVICIO_NETCAM(Pn_IdServicio IN  NUMBER,
                                          Pn_IdAccion   IN  NUMBER,
                                          Pv_EsMasivo   IN  VARCHAR2,
                                          Pv_User       IN  VARCHAR2,
                                          Pv_Status     OUT VARCHAR2,
                                          Pv_Mensaje    OUT VARCHAR2);
  
  /**
  * Documentaci�n para el procedimiento P_CAMBIO_SERVICIO_ESTADO
  *
  * M�todo encargado de cambiar el estado del servicio
  *
  * @param Pn_IdServicio       IN  NUMBER   Recibe id del servicio
  * @param Pn_IdAccion         IN  NUMBER   Recibe id de la acci�n
  * @param Pv_CambiarEstado    IN  VARCHAR2 Recibe tipo del cambio de estado
  * @param Pv_ObservCambio     IN  VARCHAR2 Recibe observaci�n del cambio de estado
  * @param Pv_EsMasivo         IN  VARCHAR2 S = Si es masivo, N = No es masivo
  * @param Pv_User             IN  VARCHAR2 Recibe usuario logeado
  * @param Pv_Status           OUT VARCHAR2 Retorna estado de la transacci�n
  * @param Pv_Mensaje          OUT VARCHAR2 Retorna mensaje de la transacci�n
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 23-12-2019
  */ 
  PROCEDURE P_CAMBIO_SERVICIO_ESTADO(Pn_IdServicio    IN  NUMBER,
                                     Pn_IdAccion      IN  NUMBER,
                                     Pv_CambiarEstado IN  VARCHAR2,
                                     Pv_ObservCambio  IN  VARCHAR2,
                                     Pv_EsMasivo      IN  VARCHAR2,
                                     Pv_User          IN  VARCHAR2,
                                     Pv_Status        OUT VARCHAR2,
                                     Pv_Mensaje       OUT VARCHAR2); 

end CMKG_NETCAM;
/

CREATE OR REPLACE package body DB_COMERCIAL.CMKG_NETCAM is
  FUNCTION F_GENERATE_TOKEN(Fv_Username IN VARCHAR2,
                            Fv_Password IN VARCHAR2,
                            Fv_ApiKey   IN VARCHAR2) RETURN VARCHAR2 AS

    CURSOR C_ParametrosPortal3DEYE(Cn_NombreParametro  VARCHAR2)
    IS
      SELECT APD.*
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
        AND APC.NOMBRE_PARAMETRO = Cn_NombreParametro
        AND APC.ESTADO = 'Activo';

    Lv_Token        VARCHAR2(3000);
    Lcl_Headers     CLOB;
    Lv_Content      VARCHAR2(3000);
    Ln_Code         NUMBER;
    Lv_Mensaje      VARCHAR2(4000);
    Lcl_Data        CLOB;
    Lv_Error        VARCHAR2(1000);
    Ln_CountErrors  NUMBER := 0;
    Lv_CodeError    VARCHAR2(1000);
    Lv_MsgError     VARCHAR2(1000);
    Lv_MsgErrors    VARCHAR2(4000);
    Lc_Params3DEYE  C_ParametrosPortal3DEYE%rowtype;
    Le_Errors       EXCEPTION;
  BEGIN
    OPEN  C_ParametrosPortal3DEYE('PORTAL 3DEYE');
    FETCH C_ParametrosPortal3DEYE INTO Lc_Params3DEYE;
    CLOSE C_ParametrosPortal3DEYE;
  
    -- CREO EL JSON HEADERS
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.OPEN_OBJECT('headers');
    APEX_JSON.WRITE('Content-Type', 'application/x-www-form-urlencoded');
    APEX_JSON.WRITE('x-api-key', Fv_ApiKey);
    APEX_JSON.CLOSE_OBJECT;
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Headers := APEX_JSON.GET_CLOB_OUTPUT;
    
    -- CREO EL CONTENIDO
    Lv_Content := 'grant_type=password&'||
                  'client_id=ExternalApi&'||
                  'username='||Fv_Username||'&'||
                  'password='||Fv_Password;
    
    DB_GENERAL.GNKG_WEB_SERVICE.P_POST(Lc_Params3DEYE.Valor4,
                                       Lcl_Headers,
                                       Lv_Content,
                                       Ln_Code,
                                       Lv_Mensaje,
                                       Lcl_Data);
    IF Ln_Code = 0 THEN
      APEX_JSON.PARSE(Lcl_Data);
      Lv_Error       := APEX_JSON.get_varchar2(p_path => 'error');
      Ln_CountErrors := APEX_JSON.GET_COUNT(P_PATH => 'errors');
      -- REGISTRO ERROR DEL PROVEEDOR
      IF Lv_Error IS NOT NULL THEN
        Lv_Mensaje := APEX_JSON.get_varchar2(p_path => 'error_description');
        RAISE Le_Errors;
      END IF;
      -- REGISTRO ERRORES DEL PROVEEDOR
      IF Ln_CountErrors > 0 THEN
        FOR I IN 1 .. Ln_CountErrors LOOP
          APEX_JSON.PARSE(Lcl_Data);
          Lv_CodeError := APEX_JSON.get_varchar2(p_path => 'errors[%d].code',  p0 => I);
          Lv_MsgError  := APEX_JSON.get_varchar2(p_path => 'errors[%d].message',  p0 => I);
          Lv_MsgErrors := Lv_CodeError||' - '||Lv_MsgError||'| '||Lv_MsgErrors;
        END LOOP;
        Lv_Mensaje := Lv_MsgErrors;
        RAISE Le_Errors;
      END IF;
      Lv_Token := APEX_JSON.get_varchar2(p_path => 'access_token');
    ELSE
      RAISE Le_Errors;
    END IF;
                                
    RETURN Lv_Token;
  EXCEPTION
    WHEN Le_Errors THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.F_GENERATE_TOKEN',
                                           Lv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));  
      RETURN Lv_Token;
    WHEN OTHERS THEN 
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.F_GENERATE_TOKEN',
                                           SQLERRM,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
      RETURN Lv_Token;
  END F_GENERATE_TOKEN;
  
  FUNCTION F_REMOVER_CAM_ROL(Fv_IdCam  IN VARCHAR2,
                             Fv_IdRol  IN VARCHAR2,
                             Fv_ApiKey IN VARCHAR2,
                             Fv_Token  IN VARCHAR2) RETURN BOOLEAN AS
  
    CURSOR C_ParametrosPortal3DEYE(Cn_NombreParametro  VARCHAR2)
    IS
      SELECT APD.*
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
        AND APC.NOMBRE_PARAMETRO = Cn_NombreParametro
        AND APC.ESTADO = 'Activo';
  
    Lb_RemoveCamRol         BOOLEAN := FALSE;
    Lcl_Headers             CLOB;
    Lv_UrlFinal             VARCHAR2(4000);
    Ln_Code                 NUMBER;
    Lv_Mensaje              VARCHAR2(4000);
    Lcl_Data                CLOB;
    Lv_Error                VARCHAR2(1000);
    Ln_CountErrors          NUMBER := 0;
    Lv_CodeError            VARCHAR2(1000);
    Lv_MsgError             VARCHAR2(1000);
    Lv_MsgErrors            VARCHAR2(4000);
    Lc_ParamsRutasRol3DEYE  C_ParametrosPortal3DEYE%rowtype;
    Le_Errors               EXCEPTION;
  BEGIN
    OPEN  C_ParametrosPortal3DEYE('ENDPOINT ROL 3DEYE');
    FETCH C_ParametrosPortal3DEYE INTO Lc_ParamsRutasRol3DEYE;
    CLOSE C_ParametrosPortal3DEYE;
    
    -- CREO EL JSON HEADERS
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.OPEN_OBJECT('headers');
    APEX_JSON.WRITE('Content-Type', 'application/json');
    APEX_JSON.WRITE('Accept', 'application/json');
    APEX_JSON.WRITE('Authorization', Fv_Token);
    APEX_JSON.WRITE('x-api-key', Fv_ApiKey);
    APEX_JSON.CLOSE_OBJECT;
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Headers := APEX_JSON.GET_CLOB_OUTPUT;
    
    Lv_UrlFinal := REPLACE(Lc_ParamsRutasRol3DEYE.Valor5, 'roleId', Fv_IdRol);
    Lv_UrlFinal := REPLACE(Lv_UrlFinal, 'cameraId', Fv_IdCam);

    DB_GENERAL.GNKG_WEB_SERVICE.P_DELETE(Lv_UrlFinal,
                                         Lcl_Headers,
                                         NULL,
                                         Ln_Code,
                                         Lv_Mensaje,
                                         Lcl_Data);
    IF Ln_Code = 0 THEN
      APEX_JSON.PARSE(Lcl_Data);
      Lv_Error       := APEX_JSON.get_varchar2(p_path => 'error');
      Ln_CountErrors := APEX_JSON.GET_COUNT(P_PATH => 'errors');
      -- REGISTRO ERROR DEL PROVEEDOR
      IF Lv_Error IS NOT NULL THEN
        Lv_Mensaje := APEX_JSON.get_varchar2(p_path => 'error_description');
        RAISE Le_Errors;
      END IF;
      -- REGISTRO ERRORES DEL PROVEEDOR
      IF Ln_CountErrors > 0 THEN
        FOR I IN 1 .. Ln_CountErrors LOOP
          APEX_JSON.PARSE(Lcl_Data);
          Lv_CodeError := APEX_JSON.get_varchar2(p_path => 'errors[%d].code',  p0 => I);
          Lv_MsgError  := APEX_JSON.get_varchar2(p_path => 'errors[%d].message',  p0 => I);
          Lv_MsgErrors := Lv_CodeError||' - '||Lv_MsgError||'| '||Lv_MsgErrors;
        END LOOP;
        Lv_Mensaje := Lv_MsgErrors;
        RAISE Le_Errors;
      END IF;
      Lb_RemoveCamRol := TRUE;
    ELSE
      RAISE Le_Errors;
    END IF;

    RETURN Lb_RemoveCamRol;
  EXCEPTION
    WHEN Le_Errors THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.F_REMOVER_CAM_ROL',
                                           Lv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));  
      RETURN Lb_RemoveCamRol;
    WHEN OTHERS THEN 
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.F_REMOVER_CAM_ROL',
                                           SQLERRM,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
      RETURN Lb_RemoveCamRol;                     
  END F_REMOVER_CAM_ROL;

  FUNCTION F_REMOVER_USER_ROL(Fv_IdUser IN VARCHAR2,
                              Fv_IdRol  IN VARCHAR2,
                              Fv_ApiKey IN VARCHAR2,
                              Fv_Token  IN VARCHAR2) RETURN BOOLEAN AS
  
    CURSOR C_ParametrosPortal3DEYE(Cn_NombreParametro  VARCHAR2)
    IS
      SELECT APD.*
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
        AND APC.NOMBRE_PARAMETRO = Cn_NombreParametro
        AND APC.ESTADO = 'Activo';
        
    Lb_RemoveUserRol        BOOLEAN := FALSE;
    Lcl_Headers             CLOB;
    Lv_UrlFinal             VARCHAR2(4000);
    Ln_Code                 NUMBER;
    Lv_Mensaje              VARCHAR2(4000);
    Lcl_Data                CLOB;
    Lv_Error                VARCHAR2(1000);
    Ln_CountErrors          NUMBER := 0;
    Lv_CodeError            VARCHAR2(1000);
    Lv_MsgError             VARCHAR2(1000);
    Lv_MsgErrors            VARCHAR2(4000);
    Lc_ParamsRutasRol3DEYE  C_ParametrosPortal3DEYE%rowtype;
    Le_Errors               EXCEPTION;
  BEGIN
    OPEN  C_ParametrosPortal3DEYE('ENDPOINT ROL 3DEYE');
    FETCH C_ParametrosPortal3DEYE INTO Lc_ParamsRutasRol3DEYE;
    CLOSE C_ParametrosPortal3DEYE;
    
    -- CREO EL JSON HEADERS
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.OPEN_OBJECT('headers');
    APEX_JSON.WRITE('Content-Type', 'application/json');
    APEX_JSON.WRITE('Accept', 'application/json');
    APEX_JSON.WRITE('Authorization', Fv_Token);
    APEX_JSON.WRITE('x-api-key', Fv_ApiKey);
    APEX_JSON.CLOSE_OBJECT;
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Headers := APEX_JSON.GET_CLOB_OUTPUT;
    
    Lv_UrlFinal := REPLACE(Lc_ParamsRutasRol3DEYE.Valor4, 'roleId', Fv_IdRol);
    Lv_UrlFinal := REPLACE(Lv_UrlFinal, 'userId', Fv_IdUser);

    DB_GENERAL.GNKG_WEB_SERVICE.P_DELETE(Lv_UrlFinal,
                                         Lcl_Headers,
                                         NULL,
                                         Ln_Code,
                                         Lv_Mensaje,
                                         Lcl_Data);
    IF Ln_Code = 0 THEN
      APEX_JSON.PARSE(Lcl_Data);
      Lv_Error       := APEX_JSON.get_varchar2(p_path => 'error');
      Ln_CountErrors := APEX_JSON.GET_COUNT(P_PATH => 'errors');
      -- REGISTRO ERROR DEL PROVEEDOR
      IF Lv_Error IS NOT NULL THEN
        Lv_Mensaje := APEX_JSON.get_varchar2(p_path => 'error_description');
        RAISE Le_Errors;
      END IF;
      -- REGISTRO ERRORES DEL PROVEEDOR
      IF Ln_CountErrors > 0 THEN
        FOR I IN 1 .. Ln_CountErrors LOOP
          APEX_JSON.PARSE(Lcl_Data);
          Lv_CodeError := APEX_JSON.get_varchar2(p_path => 'errors[%d].code',  p0 => I);
          Lv_MsgError  := APEX_JSON.get_varchar2(p_path => 'errors[%d].message',  p0 => I);
          Lv_MsgErrors := Lv_CodeError||' - '||Lv_MsgError||'| '||Lv_MsgErrors;
        END LOOP;
        Lv_Mensaje := Lv_MsgErrors;
        RAISE Le_Errors;
      END IF;
      Lb_RemoveUserRol := TRUE;
    ELSE
      RAISE Le_Errors;
    END IF;

    RETURN Lb_RemoveUserRol;
  EXCEPTION
    WHEN Le_Errors THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.F_REMOVER_USER_ROL',
                                           Lv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));  
      RETURN Lb_RemoveUserRol;
    WHEN OTHERS THEN 
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.F_REMOVER_USER_ROL',
                                           SQLERRM,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
      RETURN Lb_RemoveUserRol;                     
  END F_REMOVER_USER_ROL;

  FUNCTION F_ASIGNAR_CAM_ROL(Fv_IdCam  IN VARCHAR2,
                             Fv_IdRol  IN VARCHAR2,
                             Fv_ApiKey IN VARCHAR2,
                             Fv_Token  IN VARCHAR2) RETURN BOOLEAN AS
  
    CURSOR C_ParametrosPortal3DEYE(Cn_NombreParametro  VARCHAR2)
    IS
      SELECT APD.*
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
        AND APC.NOMBRE_PARAMETRO = Cn_NombreParametro
        AND APC.ESTADO = 'Activo';
  
    Lb_AsignarCamRol        BOOLEAN := FALSE;
    Lcl_Headers             CLOB;
    Lcl_Contenido           CLOB;
    Lv_UrlFinal             VARCHAR2(4000);
    Ln_Code                 NUMBER;
    Lv_Mensaje              VARCHAR2(4000);
    Lcl_Data                CLOB;
    Lv_Error                VARCHAR2(1000);
    Ln_CountErrors          NUMBER := 0;
    Lv_CodeError            VARCHAR2(1000);
    Lv_MsgError             VARCHAR2(1000);
    Lv_MsgErrors            VARCHAR2(4000);
    Lc_ParamsRutasRol3DEYE  C_ParametrosPortal3DEYE%rowtype;
    Le_Errors               EXCEPTION;
  BEGIN
    OPEN  C_ParametrosPortal3DEYE('ENDPOINT ROL 3DEYE');
    FETCH C_ParametrosPortal3DEYE INTO Lc_ParamsRutasRol3DEYE;
    CLOSE C_ParametrosPortal3DEYE;
    
    -- CREO EL JSON HEADERS
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.OPEN_OBJECT('headers');
    APEX_JSON.WRITE('Content-Type', 'application/json');
    APEX_JSON.WRITE('Accept', 'application/json');
    APEX_JSON.WRITE('Authorization', Fv_Token);
    APEX_JSON.WRITE('x-api-key', Fv_ApiKey);
    APEX_JSON.CLOSE_OBJECT;
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Headers := APEX_JSON.GET_CLOB_OUTPUT;
    
    -- CREO EL CONTENIDO
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.OPEN_ARRAY('permissions');
    APEX_JSON.WRITE('View');
    APEX_JSON.WRITE('SaveClip');
    APEX_JSON.WRITE('Share');
    APEX_JSON.WRITE('Ptz');
    APEX_JSON.WRITE('EditSettings');   
    APEX_JSON.CLOSE_ARRAY;
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Contenido := APEX_JSON.GET_CLOB_OUTPUT;
    
    Lv_UrlFinal := REPLACE(Lc_ParamsRutasRol3DEYE.Valor5, 'roleId', Fv_IdRol);
    Lv_UrlFinal := REPLACE(Lv_UrlFinal, 'cameraId', Fv_IdCam);

    DB_GENERAL.GNKG_WEB_SERVICE.P_PUT(Lv_UrlFinal,
                                      Lcl_Headers,
                                      Lcl_Contenido,
                                      Ln_Code,
                                      Lv_Mensaje,
                                      Lcl_Data);
    IF Ln_Code = 0 THEN
      APEX_JSON.PARSE(Lcl_Data);
      Lv_Error       := APEX_JSON.get_varchar2(p_path => 'error');
      Ln_CountErrors := APEX_JSON.GET_COUNT(P_PATH => 'errors');
      -- REGISTRO ERROR DEL PROVEEDOR
      IF Lv_Error IS NOT NULL THEN
        Lv_Mensaje := APEX_JSON.get_varchar2(p_path => 'error_description');
        RAISE Le_Errors;
      END IF;
      -- REGISTRO ERRORES DEL PROVEEDOR
      IF Ln_CountErrors > 0 THEN
        FOR I IN 1 .. Ln_CountErrors LOOP
          APEX_JSON.PARSE(Lcl_Data);
          Lv_CodeError := APEX_JSON.get_varchar2(p_path => 'errors[%d].code',  p0 => I);
          Lv_MsgError  := APEX_JSON.get_varchar2(p_path => 'errors[%d].message',  p0 => I);
          Lv_MsgErrors := Lv_CodeError||' - '||Lv_MsgError||'| '||Lv_MsgErrors;
        END LOOP;
        Lv_Mensaje := Lv_MsgErrors;
        RAISE Le_Errors;
      END IF;
      Lb_AsignarCamRol := TRUE;
    ELSE
      RAISE Le_Errors;
    END IF;

    RETURN Lb_AsignarCamRol;
  EXCEPTION
    WHEN Le_Errors THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.F_ASIGNAR_CAM_ROL',
                                           Lv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));  
      RETURN Lb_AsignarCamRol;
    WHEN OTHERS THEN 
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.F_ASIGNAR_CAM_ROL',
                                           SQLERRM,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
      RETURN Lb_AsignarCamRol;                     
  END F_ASIGNAR_CAM_ROL;

  FUNCTION F_ASIGNAR_USER_ROL(Fv_IdUser IN VARCHAR2,
                              Fv_IdRol  IN VARCHAR2,
                              Fv_ApiKey IN VARCHAR2,
                              Fv_Token  IN VARCHAR2) RETURN BOOLEAN AS
  
    CURSOR C_ParametrosPortal3DEYE(Cn_NombreParametro  VARCHAR2)
    IS
      SELECT APD.*
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
        AND APC.NOMBRE_PARAMETRO = Cn_NombreParametro
        AND APC.ESTADO = 'Activo';
    
    Lb_AsignarUserRol       BOOLEAN := FALSE;
    Lcl_Headers             CLOB;
    Lv_UrlFinal             VARCHAR2(4000);
    Ln_Code                 NUMBER;
    Lv_Mensaje              VARCHAR2(4000);
    Lcl_Data                CLOB;
    Lv_Error                VARCHAR2(1000);
    Ln_CountErrors          NUMBER := 0;
    Lv_CodeError            VARCHAR2(1000);
    Lv_MsgError             VARCHAR2(1000);
    Lv_MsgErrors            VARCHAR2(4000);
    Lc_ParamsRutasRol3DEYE  C_ParametrosPortal3DEYE%rowtype;
    Le_Errors               EXCEPTION;
  BEGIN
    OPEN  C_ParametrosPortal3DEYE('ENDPOINT ROL 3DEYE');
    FETCH C_ParametrosPortal3DEYE INTO Lc_ParamsRutasRol3DEYE;
    CLOSE C_ParametrosPortal3DEYE;
    
    -- CREO EL JSON HEADERS
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.OPEN_OBJECT('headers');
    APEX_JSON.WRITE('Content-Type', 'application/json');
    APEX_JSON.WRITE('Accept', 'application/json');
    APEX_JSON.WRITE('Authorization', Fv_Token);
    APEX_JSON.WRITE('x-api-key', Fv_ApiKey);
    APEX_JSON.CLOSE_OBJECT;
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Headers := APEX_JSON.GET_CLOB_OUTPUT;
    
    Lv_UrlFinal := REPLACE(Lc_ParamsRutasRol3DEYE.Valor4, 'roleId', Fv_IdRol);
    Lv_UrlFinal := REPLACE(Lv_UrlFinal, 'userId', Fv_IdUser);

    DB_GENERAL.GNKG_WEB_SERVICE.P_PUT(Lv_UrlFinal,
                                      Lcl_Headers,
                                      NULL,
                                      Ln_Code,
                                      Lv_Mensaje,
                                      Lcl_Data);
    IF Ln_Code = 0 THEN
      APEX_JSON.PARSE(Lcl_Data);
      Lv_Error       := APEX_JSON.get_varchar2(p_path => 'error');
      Ln_CountErrors := APEX_JSON.GET_COUNT(P_PATH => 'errors');
      -- REGISTRO ERROR DEL PROVEEDOR
      IF Lv_Error IS NOT NULL THEN
        Lv_Mensaje := APEX_JSON.get_varchar2(p_path => 'error_description');
        RAISE Le_Errors;
      END IF;
      -- REGISTRO ERRORES DEL PROVEEDOR
      IF Ln_CountErrors > 0 THEN
        FOR I IN 1 .. Ln_CountErrors LOOP
          APEX_JSON.PARSE(Lcl_Data);
          Lv_CodeError := APEX_JSON.get_varchar2(p_path => 'errors[%d].code',  p0 => I);
          Lv_MsgError  := APEX_JSON.get_varchar2(p_path => 'errors[%d].message',  p0 => I);
          Lv_MsgErrors := Lv_CodeError||' - '||Lv_MsgError||'| '||Lv_MsgErrors;
        END LOOP;
        Lv_Mensaje := Lv_MsgErrors;
        RAISE Le_Errors;
      END IF;
      Lb_AsignarUserRol := TRUE;
    ELSE
      RAISE Le_Errors;
    END IF;

    RETURN Lb_AsignarUserRol;
  EXCEPTION
    WHEN Le_Errors THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.F_ASIGNAR_USER_ROL',
                                           Lv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));  
      RETURN Lb_AsignarUserRol;
    WHEN OTHERS THEN 
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.F_ASIGNAR_USER_ROL',
                                           SQLERRM,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
      RETURN Lb_AsignarUserRol;                     
  END F_ASIGNAR_USER_ROL;

  FUNCTION F_ELIMINAR_CAM(Fv_IdCam  IN VARCHAR2,
                          Fv_ApiKey IN VARCHAR2,
                          Fv_Token  IN VARCHAR2) RETURN BOOLEAN AS
  
    CURSOR C_ParametrosPortal3DEYE(Cn_NombreParametro  VARCHAR2)
    IS
      SELECT APD.*
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
        AND APC.NOMBRE_PARAMETRO = Cn_NombreParametro
        AND APC.ESTADO = 'Activo';
  
    Lb_EliminarCam          BOOLEAN := FALSE;
    Lcl_Headers             CLOB;
    Lv_UrlFinal             VARCHAR2(4000);
    Ln_Code                 NUMBER;
    Lv_Mensaje              VARCHAR2(4000);
    Lcl_Data                CLOB;
    Lv_Error                VARCHAR2(1000);
    Ln_CountErrors          NUMBER := 0;
    Lv_CodeError            VARCHAR2(1000);
    Lv_MsgError             VARCHAR2(1000);
    Lv_MsgErrors            VARCHAR2(4000);
    Lc_ParamsRutasCam3DEYE  C_ParametrosPortal3DEYE%rowtype;
    Le_Errors               EXCEPTION;
  BEGIN
    OPEN  C_ParametrosPortal3DEYE('ENDPOINT CAMARA 3DEYE');
    FETCH C_ParametrosPortal3DEYE INTO Lc_ParamsRutasCam3DEYE;
    CLOSE C_ParametrosPortal3DEYE;
  
    -- CREO EL JSON HEADERS
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.OPEN_OBJECT('headers');
    APEX_JSON.WRITE('Content-Type', 'application/json');
    APEX_JSON.WRITE('Accept', 'application/json');
    APEX_JSON.WRITE('Authorization', Fv_Token);
    APEX_JSON.WRITE('x-api-key', Fv_ApiKey);
    APEX_JSON.CLOSE_OBJECT;
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Headers := APEX_JSON.GET_CLOB_OUTPUT;
    
    Lv_UrlFinal := REPLACE(Lc_ParamsRutasCam3DEYE.Valor2, 'cameraId', Fv_IdCam);

    DB_GENERAL.GNKG_WEB_SERVICE.P_DELETE(Lv_UrlFinal,
                                         Lcl_Headers,
                                         NULL,
                                         Ln_Code,
                                         Lv_Mensaje,
                                         Lcl_Data);
    IF Ln_Code = 0 THEN
      APEX_JSON.PARSE(Lcl_Data);
      Lv_Error       := APEX_JSON.get_varchar2(p_path => 'error');
      Ln_CountErrors := APEX_JSON.GET_COUNT(P_PATH => 'errors');
      -- REGISTRO ERROR DEL PROVEEDOR
      IF Lv_Error IS NOT NULL THEN
        Lv_Mensaje := APEX_JSON.get_varchar2(p_path => 'error_description');
        RAISE Le_Errors;
      END IF;
      -- REGISTRO ERRORES DEL PROVEEDOR
      IF Ln_CountErrors > 0 THEN
        FOR I IN 1 .. Ln_CountErrors LOOP
          APEX_JSON.PARSE(Lcl_Data);
          Lv_CodeError := APEX_JSON.get_varchar2(p_path => 'errors[%d].code',  p0 => I);
          Lv_MsgError  := APEX_JSON.get_varchar2(p_path => 'errors[%d].message',  p0 => I);
          Lv_MsgErrors := Lv_CodeError||' - '||Lv_MsgError||'| '||Lv_MsgErrors;
        END LOOP;
        Lv_Mensaje := Lv_MsgErrors;
        RAISE Le_Errors;
      END IF;
      Lb_EliminarCam := TRUE;
    ELSE
      RAISE Le_Errors;
    END IF;

    RETURN Lb_EliminarCam;
  EXCEPTION
    WHEN Le_Errors THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.F_ELIMINAR_CAM',
                                           Lv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));  
      RETURN Lb_EliminarCam;
    WHEN OTHERS THEN 
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.F_ELIMINAR_CAM',
                                           SQLERRM,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
      RETURN Lb_EliminarCam;                     
  END F_ELIMINAR_CAM;

  FUNCTION F_ELIMINAR_USER(Fv_IdUser  IN VARCHAR2,
                           Fv_ApiKey  IN VARCHAR2,
                           Fv_Token   IN VARCHAR2) RETURN BOOLEAN AS
  
    CURSOR C_ParametrosPortal3DEYE(Cn_NombreParametro  VARCHAR2)
    IS
      SELECT APD.*
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
        AND APC.NOMBRE_PARAMETRO = Cn_NombreParametro
        AND APC.ESTADO = 'Activo';
  
    Lb_EliminarUser         BOOLEAN := FALSE;
    Lcl_Headers             CLOB;
    Lv_UrlFinal             VARCHAR2(4000);
    Ln_Code                 NUMBER;
    Lv_Mensaje              VARCHAR2(4000);
    Lcl_Data                CLOB;
    Lv_Error                VARCHAR2(1000);
    Ln_CountErrors          NUMBER := 0;
    Lv_CodeError            VARCHAR2(1000);
    Lv_MsgError             VARCHAR2(1000);
    Lv_MsgErrors            VARCHAR2(4000);
    Lc_ParamsRutasUser3DEYE C_ParametrosPortal3DEYE%rowtype;
    Le_Errors               EXCEPTION;
  BEGIN
    OPEN  C_ParametrosPortal3DEYE('ENDPOINT USER 3DEYE');
    FETCH C_ParametrosPortal3DEYE INTO Lc_ParamsRutasUser3DEYE;
    CLOSE C_ParametrosPortal3DEYE;
  
    -- CREO EL JSON HEADERS
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.OPEN_OBJECT('headers');
    APEX_JSON.WRITE('Content-Type', 'application/json');
    APEX_JSON.WRITE('Accept', 'application/json');
    APEX_JSON.WRITE('Authorization', Fv_Token);
    APEX_JSON.WRITE('x-api-key', Fv_ApiKey);
    APEX_JSON.CLOSE_OBJECT;
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Headers := APEX_JSON.GET_CLOB_OUTPUT;
    
    Lv_UrlFinal := REPLACE(Lc_ParamsRutasUser3DEYE.Valor5, 'userId', Fv_IdUser);

    DB_GENERAL.GNKG_WEB_SERVICE.P_DELETE(Lv_UrlFinal,
                                         Lcl_Headers,
                                         NULL,
                                         Ln_Code,
                                         Lv_Mensaje,
                                         Lcl_Data);
    IF Ln_Code = 0 THEN
      APEX_JSON.PARSE(Lcl_Data);
      Lv_Error       := APEX_JSON.get_varchar2(p_path => 'error');
      Ln_CountErrors := APEX_JSON.GET_COUNT(P_PATH => 'errors');
      -- REGISTRO ERROR DEL PROVEEDOR
      IF Lv_Error IS NOT NULL THEN
        Lv_Mensaje := APEX_JSON.get_varchar2(p_path => 'error_description');
        RAISE Le_Errors;
      END IF;
      -- REGISTRO ERRORES DEL PROVEEDOR
      IF Ln_CountErrors > 0 THEN
        FOR I IN 1 .. Ln_CountErrors LOOP
          APEX_JSON.PARSE(Lcl_Data);
          Lv_CodeError := APEX_JSON.get_varchar2(p_path => 'errors[%d].code',  p0 => I);
          Lv_MsgError  := APEX_JSON.get_varchar2(p_path => 'errors[%d].message',  p0 => I);
          Lv_MsgErrors := Lv_CodeError||' - '||Lv_MsgError||'| '||Lv_MsgErrors;
        END LOOP;
        Lv_Mensaje := Lv_MsgErrors;
        RAISE Le_Errors;
      END IF;
      Lb_EliminarUser := TRUE;
    ELSE
      RAISE Le_Errors;
    END IF;

    RETURN Lb_EliminarUser;
  EXCEPTION
    WHEN Le_Errors THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.F_ELIMINAR_USER',
                                           Lv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));  
      RETURN Lb_EliminarUser;
    WHEN OTHERS THEN 
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.F_ELIMINAR_USER',
                                           SQLERRM,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
      RETURN Lb_EliminarUser;                     
  END F_ELIMINAR_USER;

  FUNCTION F_ELIMINAR_ROL(Fv_IdRol  IN VARCHAR2,
                          Fv_ApiKey IN VARCHAR2,
                          Fv_Token  IN VARCHAR2) RETURN BOOLEAN AS
  
    CURSOR C_ParametrosPortal3DEYE(Cn_NombreParametro  VARCHAR2)
    IS
      SELECT APD.*
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
        AND APC.NOMBRE_PARAMETRO = Cn_NombreParametro
        AND APC.ESTADO = 'Activo';
        
    Lb_EliminarRol          BOOLEAN := FALSE;
    Lcl_Headers             CLOB;
    Lv_UrlFinal             VARCHAR2(4000);
    Ln_Code                 NUMBER;
    Lv_Mensaje              VARCHAR2(4000);
    Lcl_Data                CLOB;
    Lv_Error                VARCHAR2(1000);
    Ln_CountErrors          NUMBER := 0;
    Lv_CodeError            VARCHAR2(1000);
    Lv_MsgError             VARCHAR2(1000);
    Lv_MsgErrors            VARCHAR2(4000);
    Lc_ParamsRutasRol3DEYE  C_ParametrosPortal3DEYE%rowtype;
    Le_Errors               EXCEPTION;
  BEGIN
    OPEN  C_ParametrosPortal3DEYE('ENDPOINT ROL 3DEYE');
    FETCH C_ParametrosPortal3DEYE INTO Lc_ParamsRutasRol3DEYE;
    CLOSE C_ParametrosPortal3DEYE;
  
    -- CREO EL JSON HEADERS
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.OPEN_OBJECT('headers');
    APEX_JSON.WRITE('Content-Type', 'application/json');
    APEX_JSON.WRITE('Accept', 'application/json');
    APEX_JSON.WRITE('Authorization', Fv_Token);
    APEX_JSON.WRITE('x-api-key', Fv_ApiKey);
    APEX_JSON.CLOSE_OBJECT;
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Headers := APEX_JSON.GET_CLOB_OUTPUT;
    
    Lv_UrlFinal := REPLACE(Lc_ParamsRutasRol3DEYE.Valor2, 'roleId', Fv_IdRol);

    DB_GENERAL.GNKG_WEB_SERVICE.P_DELETE(Lv_UrlFinal,
                                         Lcl_Headers,
                                         NULL,
                                         Ln_Code,
                                         Lv_Mensaje,
                                         Lcl_Data);
    IF Ln_Code = 0 THEN
      APEX_JSON.PARSE(Lcl_Data);
      Lv_Error       := APEX_JSON.get_varchar2(p_path => 'error');
      Ln_CountErrors := APEX_JSON.GET_COUNT(P_PATH => 'errors');
      -- REGISTRO ERROR DEL PROVEEDOR
      IF Lv_Error IS NOT NULL THEN
        Lv_Mensaje := APEX_JSON.get_varchar2(p_path => 'error_description');
        RAISE Le_Errors;
      END IF;
      -- REGISTRO ERRORES DEL PROVEEDOR
      IF Ln_CountErrors > 0 THEN
        FOR I IN 1 .. Ln_CountErrors LOOP
          APEX_JSON.PARSE(Lcl_Data);
          Lv_CodeError := APEX_JSON.get_varchar2(p_path => 'errors[%d].code',  p0 => I);
          Lv_MsgError  := APEX_JSON.get_varchar2(p_path => 'errors[%d].message',  p0 => I);
          Lv_MsgErrors := Lv_CodeError||' - '||Lv_MsgError||'| '||Lv_MsgErrors;
        END LOOP;
        Lv_Mensaje := Lv_MsgErrors;
        RAISE Le_Errors;
      END IF;
      Lb_EliminarRol := TRUE;
    ELSE
      RAISE Le_Errors;
    END IF;

    RETURN Lb_EliminarRol;
  EXCEPTION
    WHEN Le_Errors THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.F_ELIMINAR_ROL',
                                           Lv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));  
      RETURN Lb_EliminarRol;
    WHEN OTHERS THEN 
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.F_ELIMINAR_ROL',
                                           SQLERRM,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
      RETURN Lb_EliminarRol;                     
  END F_ELIMINAR_ROL;

  FUNCTION F_VALIDAR_ESTADO_CAM(Fv_IdCam          IN VARCHAR2,
                                Fv_TipoActivacion IN VARCHAR2,
                                Fv_ApiKey         IN VARCHAR2,
                                Fv_Token          IN VARCHAR2) RETURN BOOLEAN AS
  
    CURSOR C_ParametrosPortal3DEYE(Cn_NombreParametro  VARCHAR2)
    IS
      SELECT APD.*
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
        AND APC.NOMBRE_PARAMETRO = Cn_NombreParametro
        AND APC.ESTADO = 'Activo';
  
    Lb_ValidEstadoCam       BOOLEAN := FALSE;
    Lb_ValidateRtsp         BOOLEAN := FALSE;
    Lb_ValidateOnvif        BOOLEAN := FALSE;
    Lcl_Headers             CLOB;
    Lv_UrlFinal             VARCHAR2(4000);
    Ln_Code                 NUMBER;
    Lv_Mensaje              VARCHAR2(4000);
    Lcl_Data                CLOB;
    Lv_Error                VARCHAR2(1000);
    Ln_CountErrors          NUMBER := 0;
    Lv_CodeError            VARCHAR2(1000);
    Lv_MsgError             VARCHAR2(1000);
    Lv_MsgErrors            VARCHAR2(4000);
    Lc_ParamsRutasCam3DEYE  C_ParametrosPortal3DEYE%rowtype;
    Le_Errors               EXCEPTION;
  BEGIN
    OPEN  C_ParametrosPortal3DEYE('ENDPOINT CAMARA 3DEYE');
    FETCH C_ParametrosPortal3DEYE INTO Lc_ParamsRutasCam3DEYE;
    CLOSE C_ParametrosPortal3DEYE;
  
    -- CREO EL JSON HEADERS
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.OPEN_OBJECT('headers');
    APEX_JSON.WRITE('Content-Type', 'application/json');
    APEX_JSON.WRITE('Accept', 'application/json');
    APEX_JSON.WRITE('Authorization', Fv_Token);
    APEX_JSON.WRITE('x-api-key', Fv_ApiKey);
    APEX_JSON.CLOSE_OBJECT;
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Headers := APEX_JSON.GET_CLOB_OUTPUT;
    
    Lv_UrlFinal := REPLACE(Lc_ParamsRutasCam3DEYE.Valor3, 'cameraId', Fv_IdCam);

    DB_GENERAL.GNKG_WEB_SERVICE.P_GET(Lv_UrlFinal,
                                      Lcl_Headers,
                                      Ln_Code,
                                      Lv_Mensaje,
                                      Lcl_Data);
    IF Ln_Code = 0 THEN
      APEX_JSON.PARSE(Lcl_Data);
      Lv_Error       := APEX_JSON.get_varchar2(p_path => 'error');
      Ln_CountErrors := APEX_JSON.GET_COUNT(P_PATH => 'errors');
      -- REGISTRO ERROR DEL PROVEEDOR
      IF Lv_Error IS NOT NULL THEN
        Lv_Mensaje := APEX_JSON.get_varchar2(p_path => 'error_description');
        RAISE Le_Errors;
      END IF;
      -- REGISTRO ERRORES DEL PROVEEDOR
      IF Ln_CountErrors > 0 THEN
        FOR I IN 1 .. Ln_CountErrors LOOP
          APEX_JSON.PARSE(Lcl_Data);
          Lv_CodeError := APEX_JSON.get_varchar2(p_path => 'errors[%d].code',  p0 => I);
          Lv_MsgError  := APEX_JSON.get_varchar2(p_path => 'errors[%d].message',  p0 => I);
          Lv_MsgErrors := Lv_CodeError||' - '||Lv_MsgError||'| '||Lv_MsgErrors;
        END LOOP;
        Lv_Mensaje := Lv_MsgErrors;
        RAISE Le_Errors;
      END IF;
      IF Fv_TipoActivacion = 'P2P' THEN
        APEX_JSON.PARSE(Lcl_Data);
        Lb_ValidateRtsp  := APEX_JSON.get_boolean(p_path => 'rtspState.isAvailable');
        Lb_ValidateOnvif := APEX_JSON.get_boolean(p_path => 'onvifState.isAvailable');
        IF Lb_ValidateRtsp AND Lb_ValidateOnvif THEN
          Lb_ValidEstadoCam := TRUE;
        END IF;
      ELSIF Fv_TipoActivacion = 'ONVIF' THEN
        Lb_ValidateOnvif := APEX_JSON.get_boolean(p_path => 'onvifState.isAvailable');
        IF Lb_ValidateOnvif THEN
          Lb_ValidEstadoCam := TRUE;
        END IF;
      ELSIF Fv_TipoActivacion = 'GENERIC' THEN
        Lb_ValidateRtsp  := APEX_JSON.get_boolean(p_path => 'rtspState.isAvailable');
        IF Lb_ValidateRtsp THEN
          Lb_ValidEstadoCam := TRUE;
        END IF;
      END IF;
    ELSE
      RAISE Le_Errors;
    END IF;

    RETURN Lb_ValidEstadoCam;
  EXCEPTION
    WHEN Le_Errors THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.F_VALIDAR_ESTADO_CAM',
                                           Lv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));  
      RETURN Lb_ValidEstadoCam;
    WHEN OTHERS THEN 
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.F_VALIDAR_ESTADO_CAM',
                                           SQLERRM,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
      RETURN Lb_ValidEstadoCam;                     
  END F_VALIDAR_ESTADO_CAM;

  PROCEDURE P_CREAR_CAM_P2P(Pv_NombreCam  IN  VARCHAR2,
                            Pv_CodigoPush IN  VARCHAR2,
                            Pv_AdminUser  IN  VARCHAR2,
                            Pv_AdminPass  IN  VARCHAR2,
                            Pv_ApiKey     IN  VARCHAR2,
                            Pv_Token      IN  VARCHAR2,
                            Pv_Status     OUT VARCHAR2,
                            Pv_Mensaje    OUT VARCHAR2,
                            Pcl_Data      OUT CLOB)
  AS
  
    CURSOR C_ParametrosPortal3DEYE(Cn_NombreParametro  VARCHAR2)
    IS
      SELECT APD.*
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
        AND APC.NOMBRE_PARAMETRO = Cn_NombreParametro
        AND APC.ESTADO = 'Activo';
        
    Lcl_Headers             CLOB;
    Lv_UrlFinal             VARCHAR2(4000);
    Lcl_Contenido           CLOB;
    Ln_Code                 NUMBER;
    Lv_Mensaje              VARCHAR2(4000);
    Lcl_Data                CLOB;
    Lv_Error                VARCHAR2(1000);
    Ln_CountErrors          NUMBER := 0;
    Lv_CodeError            VARCHAR2(1000);
    Lv_MsgError             VARCHAR2(1000);
    Lv_MsgErrors            VARCHAR2(4000);
    Lc_ParamsRutasCam3DEYE  C_ParametrosPortal3DEYE%rowtype;
    Le_Errors               EXCEPTION;
  BEGIN
    OPEN  C_ParametrosPortal3DEYE('ENDPOINT CAMARA 3DEYE');
    FETCH C_ParametrosPortal3DEYE INTO Lc_ParamsRutasCam3DEYE;
    CLOSE C_ParametrosPortal3DEYE;
    
    -- CREO EL JSON HEADERS
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.OPEN_OBJECT('headers');
    APEX_JSON.WRITE('Content-Type', 'application/json');
    APEX_JSON.WRITE('Accept', 'application/json');
    APEX_JSON.WRITE('Authorization', Pv_Token);
    APEX_JSON.WRITE('x-api-key', Pv_ApiKey);
    APEX_JSON.CLOSE_OBJECT;
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Headers := APEX_JSON.GET_CLOB_OUTPUT;
  
    -- CREO EL CONTENIDO
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('name', Pv_NombreCam);
    APEX_JSON.WRITE('registrationCode', Pv_CodigoPush);
    APEX_JSON.WRITE('adminName', Pv_AdminUser);
    APEX_JSON.WRITE('adminPassword', Pv_AdminPass);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Contenido := APEX_JSON.GET_CLOB_OUTPUT;
    
    Lv_UrlFinal := Lc_ParamsRutasCam3DEYE.Valor4;

    DB_GENERAL.GNKG_WEB_SERVICE.P_POST(Lv_UrlFinal,
                                       Lcl_Headers,
                                       Lcl_Contenido,
                                       Ln_Code,
                                       Lv_Mensaje,
                                       Lcl_Data);
                                       
    IF Ln_Code = 0 THEN
      APEX_JSON.PARSE(Lcl_Data);
      Lv_Error       := APEX_JSON.get_varchar2(p_path => 'error');
      Ln_CountErrors := APEX_JSON.GET_COUNT(P_PATH => 'errors');
      -- REGISTRO ERROR DEL PROVEEDOR
      IF Lv_Error IS NOT NULL THEN
        Lv_Mensaje := APEX_JSON.get_varchar2(p_path => 'error_description');
        RAISE Le_Errors;
      END IF;
      -- REGISTRO ERRORES DEL PROVEEDOR
      IF Ln_CountErrors > 0 THEN
        FOR I IN 1 .. Ln_CountErrors LOOP
          APEX_JSON.PARSE(Lcl_Data);
          Lv_CodeError := APEX_JSON.get_varchar2(p_path => 'errors[%d].code',  p0 => I);
          Lv_MsgError  := APEX_JSON.get_varchar2(p_path => 'errors[%d].message',  p0 => I);
          Lv_MsgErrors := Lv_CodeError||' - '||Lv_MsgError||'| '||Lv_MsgErrors;
        END LOOP;
        Lv_Mensaje := Lv_MsgErrors;
        RAISE Le_Errors;
      END IF;
      Pv_Status  := 'OK';
      Pcl_Data   := Lcl_Data;
    ELSE
      RAISE Le_Errors;
    END IF;
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := Lv_Mensaje;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.P_CREAR_CAM_P2P',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));  
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.P_CREAR_CAM_P2P',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));       
  END P_CREAR_CAM_P2P;

  PROCEDURE P_CREAR_CAM_ONVIF(Pcl_DatosONVIF  IN  CLOB,
                              Pv_ApiKey       IN  VARCHAR2,
                              Pv_Token        IN  VARCHAR2,
                              Pv_Status       OUT VARCHAR2,
                              Pv_Mensaje      OUT VARCHAR2,
                              Pcl_Data        OUT CLOB)
  AS
  
    CURSOR C_ParametrosPortal3DEYE(Cn_NombreParametro  VARCHAR2)
    IS
      SELECT APD.*
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
        AND APC.NOMBRE_PARAMETRO = Cn_NombreParametro
        AND APC.ESTADO = 'Activo';
  
    Lcl_Headers             CLOB;
    Lv_UrlFinal             VARCHAR2(4000);
    Lcl_Contenido           CLOB;
    Ln_Code                 NUMBER;
    Lv_Mensaje              VARCHAR2(4000);
    Lcl_Data                CLOB;
    Lv_Error                VARCHAR2(1000);
    Ln_CountErrors          NUMBER := 0;
    Lv_CodeError            VARCHAR2(1000);
    Lv_MsgError             VARCHAR2(1000);
    Lv_MsgErrors            VARCHAR2(4000);
    Lv_NombreCam            VARCHAR2(1000);
    Lv_UrlHTTP              VARCHAR2(1000);
    Ln_PuertoHTTP           NUMBER;
    Ln_PuertoRTSP           NUMBER;
    Lv_AdminUser            VARCHAR2(1000);
    Lv_AdminPass            VARCHAR2(1000);
    Lc_ParamsRutasCam3DEYE  C_ParametrosPortal3DEYE%rowtype;
    Le_Errors               EXCEPTION;
  BEGIN
    OPEN  C_ParametrosPortal3DEYE('ENDPOINT CAMARA 3DEYE');
    FETCH C_ParametrosPortal3DEYE INTO Lc_ParamsRutasCam3DEYE;
    CLOSE C_ParametrosPortal3DEYE;
  
    -- RETORNO LAS VARIABLES DE LA CAMARA
    APEX_JSON.PARSE(Pcl_DatosONVIF);
    Lv_NombreCam  := APEX_JSON.get_varchar2(p_path => 'Pv_NombreCam');
    Lv_UrlHTTP    := APEX_JSON.get_varchar2(p_path => 'Pv_UrlHTTP');
    Ln_PuertoHTTP := APEX_JSON.get_number(p_path => 'Pn_PuertoHTTP');
    Ln_PuertoRTSP := APEX_JSON.get_number(p_path => 'Pn_PuertoRTSP');
    Lv_AdminUser  := APEX_JSON.get_varchar2(p_path => 'Pv_AdminUser');
    Lv_AdminPass  := APEX_JSON.get_varchar2(p_path => 'Pv_AdminPass');
    
    -- CREO EL JSON HEADERS
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.OPEN_OBJECT('headers');
    APEX_JSON.WRITE('Content-Type', 'application/json');
    APEX_JSON.WRITE('Accept', 'application/json');
    APEX_JSON.WRITE('Authorization', Pv_Token);
    APEX_JSON.WRITE('x-api-key', Pv_ApiKey);
    APEX_JSON.CLOSE_OBJECT;
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Headers := APEX_JSON.GET_CLOB_OUTPUT;
  
    -- CREO EL CONTENIDO
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('name', Lv_NombreCam);
    APEX_JSON.WRITE('httpAccessUrl', Lv_UrlHTTP||':'||Ln_PuertoHTTP);
    APEX_JSON.WRITE('adminName', Lv_AdminUser);
    APEX_JSON.WRITE('adminPassword', Lv_AdminPass);
    APEX_JSON.WRITE('rtspPort', Ln_PuertoRTSP);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Contenido := APEX_JSON.GET_CLOB_OUTPUT;
    
    Lv_UrlFinal := Lc_ParamsRutasCam3DEYE.Valor5;

    DB_GENERAL.GNKG_WEB_SERVICE.P_POST(Lv_UrlFinal,
                                       Lcl_Headers,
                                       Lcl_Contenido,
                                       Ln_Code,
                                       Lv_Mensaje,
                                       Lcl_Data);
                                       
    IF Ln_Code = 0 THEN
      APEX_JSON.PARSE(Lcl_Data);
      Lv_Error       := APEX_JSON.get_varchar2(p_path => 'error');
      Ln_CountErrors := APEX_JSON.GET_COUNT(P_PATH => 'errors');
      -- REGISTRO ERROR DEL PROVEEDOR
      IF Lv_Error IS NOT NULL THEN
        Lv_Mensaje := APEX_JSON.get_varchar2(p_path => 'error_description');
        RAISE Le_Errors;
      END IF;
      -- REGISTRO ERRORES DEL PROVEEDOR
      IF Ln_CountErrors > 0 THEN
        FOR I IN 1 .. Ln_CountErrors LOOP
          APEX_JSON.PARSE(Lcl_Data);
          Lv_CodeError := APEX_JSON.get_varchar2(p_path => 'errors[%d].code',  p0 => I);
          Lv_MsgError  := APEX_JSON.get_varchar2(p_path => 'errors[%d].message',  p0 => I);
          Lv_MsgErrors := Lv_CodeError||' - '||Lv_MsgError||'| '||Lv_MsgErrors;
        END LOOP;
        Lv_Mensaje := Lv_MsgErrors;
        RAISE Le_Errors;
      END IF;
      Pv_Status  := 'OK';
      Pcl_Data   := Lcl_Data;
    ELSE
      RAISE Le_Errors;
    END IF;
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := Lv_Mensaje;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.P_CREAR_CAM_ONVIF',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));  
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.P_CREAR_CAM_ONVIF',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));       
  END P_CREAR_CAM_ONVIF;

  PROCEDURE P_CREAR_CAM_GENERIC(Pcl_DatosGENERIC IN  CLOB,
                                Pv_ApiKey        IN  VARCHAR2,
                                Pv_Token         IN  VARCHAR2,
                                Pv_Status        OUT VARCHAR2,
                                Pv_Mensaje       OUT VARCHAR2,
                                Pcl_Data         OUT CLOB)
  AS
  
    CURSOR C_ParametrosPortal3DEYE(Cn_NombreParametro  VARCHAR2)
    IS
      SELECT APD.*
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
        AND APC.NOMBRE_PARAMETRO = Cn_NombreParametro
        AND APC.ESTADO = 'Activo';
  
    Lcl_Headers             CLOB;
    Lv_UrlFinal             VARCHAR2(4000);
    Lcl_Contenido           CLOB;
    Ln_Code                 NUMBER;
    Lv_Mensaje              VARCHAR2(4000);
    Lcl_Data                CLOB;
    Lv_Error                VARCHAR2(1000);
    Ln_CountErrors          NUMBER := 0;
    Lv_CodeError            VARCHAR2(1000);
    Lv_MsgError             VARCHAR2(1000);
    Lv_MsgErrors            VARCHAR2(4000);
    Lv_NombreCam            VARCHAR2(1000);
    Lv_UrlHTTP              VARCHAR2(1000);
    Ln_PuertoHTTP           NUMBER;
    Lv_UrlRTSP              VARCHAR2(1000);
    Ln_PuertoRTSP           NUMBER;
    Lv_DeviceBrand          VARCHAR2(1000);
    Lv_AdminUser            VARCHAR2(1000);
    Lv_AdminPass            VARCHAR2(1000);
    Lc_ParamsRutasCam3DEYE  C_ParametrosPortal3DEYE%rowtype;
    Le_Errors               EXCEPTION;
  BEGIN
    OPEN  C_ParametrosPortal3DEYE('ENDPOINT CAMARA 3DEYE');
    FETCH C_ParametrosPortal3DEYE INTO Lc_ParamsRutasCam3DEYE;
    CLOSE C_ParametrosPortal3DEYE;
  
    -- RETORNO LAS VARIABLES DE LA CAMARA
    APEX_JSON.PARSE(Pcl_DatosGENERIC);
    Lv_NombreCam     := APEX_JSON.get_varchar2(p_path => 'Pv_NombreCam');
    Lv_UrlHTTP       := APEX_JSON.get_varchar2(p_path => 'Pv_UrlHTTP');
    Ln_PuertoHTTP    := APEX_JSON.get_number(p_path => 'Pn_PuertoHTTP');
    Lv_UrlRTSP       := APEX_JSON.get_varchar2(p_path => 'Pv_UrlRTSP');
    Ln_PuertoRTSP    := APEX_JSON.get_number(p_path => 'Pn_PuertoRTSP');
    Lv_DeviceBrand   := APEX_JSON.get_varchar2(p_path => 'Pv_DeviceBrand');
    Lv_AdminUser     := APEX_JSON.get_varchar2(p_path => 'Pv_AdminUser');
    Lv_AdminPass     := APEX_JSON.get_varchar2(p_path => 'Pv_AdminPass');
  
    -- CREO EL JSON HEADERS
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.OPEN_OBJECT('headers');
    APEX_JSON.WRITE('Content-Type', 'application/json');
    APEX_JSON.WRITE('Accept', 'application/json');
    APEX_JSON.WRITE('Authorization', Pv_Token);
    APEX_JSON.WRITE('x-api-key', Pv_ApiKey);
    APEX_JSON.CLOSE_OBJECT;
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Headers := APEX_JSON.GET_CLOB_OUTPUT;
  
    -- CREO EL CONTENIDO
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('name', Lv_NombreCam);
    APEX_JSON.WRITE('httpAccessUrl', Lv_UrlHTTP||':'||Ln_PuertoHTTP);
    APEX_JSON.WRITE('rtspAccessUrl', Lv_UrlRTSP||':'||Ln_PuertoRTSP);
    APEX_JSON.WRITE('adminName', Lv_AdminUser);
    APEX_JSON.WRITE('adminPassword', Lv_AdminPass);
    APEX_JSON.WRITE('deviceBrand', Lv_DeviceBrand);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Contenido := APEX_JSON.GET_CLOB_OUTPUT;
    
    Lv_UrlFinal := Lc_ParamsRutasCam3DEYE.Valor6;

    DB_GENERAL.GNKG_WEB_SERVICE.P_POST(Lv_UrlFinal,
                                       Lcl_Headers,
                                       Lcl_Contenido,
                                       Ln_Code,
                                       Lv_Mensaje,
                                       Lcl_Data);
                                       
    IF Ln_Code = 0 THEN
      APEX_JSON.PARSE(Lcl_Data);
      Lv_Error       := APEX_JSON.get_varchar2(p_path => 'error');
      Ln_CountErrors := APEX_JSON.GET_COUNT(P_PATH => 'errors');
      -- REGISTRO ERROR DEL PROVEEDOR
      IF Lv_Error IS NOT NULL THEN
        Lv_Mensaje := APEX_JSON.get_varchar2(p_path => 'error_description');
        RAISE Le_Errors;
      END IF;
      -- REGISTRO ERRORES DEL PROVEEDOR
      IF Ln_CountErrors > 0 THEN
        FOR I IN 1 .. Ln_CountErrors LOOP
          APEX_JSON.PARSE(Lcl_Data);
          Lv_CodeError := APEX_JSON.get_varchar2(p_path => 'errors[%d].code',  p0 => I);
          Lv_MsgError  := APEX_JSON.get_varchar2(p_path => 'errors[%d].message',  p0 => I);
          Lv_MsgErrors := Lv_CodeError||' - '||Lv_MsgError||'| '||Lv_MsgErrors;
        END LOOP;
        Lv_Mensaje := Lv_MsgErrors;
        RAISE Le_Errors;
      END IF;
      Pv_Status  := 'OK';
      Pcl_Data   := Lcl_Data;
    ELSE
      RAISE Le_Errors;
    END IF;
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := Lv_Mensaje;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.P_CREAR_CAM_GENERIC',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));  
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.P_CREAR_CAM_GENERIC',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));       
  END P_CREAR_CAM_GENERIC;

  PROCEDURE P_CREAR_ROL(Pv_NombreRol   IN  VARCHAR2,
                        Pv_Descripcion IN  VARCHAR2,
                        Pv_Type        IN  VARCHAR2,
                        Pv_ApiKey      IN  VARCHAR2,
                        Pv_Token       IN  VARCHAR2,
                        Pv_Status      OUT VARCHAR2,
                        Pv_Mensaje     OUT VARCHAR2,
                        Pcl_Data       OUT CLOB)
  AS

    CURSOR C_ParametrosPortal3DEYE(Cn_NombreParametro  VARCHAR2)
    IS
      SELECT APD.*
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
        AND APC.NOMBRE_PARAMETRO = Cn_NombreParametro
        AND APC.ESTADO = 'Activo';
        
    Lcl_Headers             CLOB;
    Lv_UrlFinal             VARCHAR2(4000);
    Lcl_Contenido           CLOB;
    Ln_Code                 NUMBER;
    Lv_Mensaje              VARCHAR2(4000);
    Lcl_Data                CLOB;
    Lv_Error                VARCHAR2(1000);
    Ln_CountErrors          NUMBER := 0;
    Lv_CodeError            VARCHAR2(1000);
    Lv_MsgError             VARCHAR2(1000);
    Lv_MsgErrors            VARCHAR2(4000);
    Ln_IdRol                NUMBER;
    Lv_Status               VARCHAR2(100);
    Lc_ParamsRutasRol3DEYE  C_ParametrosPortal3DEYE%rowtype;
    Le_Errors               EXCEPTION;
  BEGIN
    OPEN  C_ParametrosPortal3DEYE('ENDPOINT ROL 3DEYE');
    FETCH C_ParametrosPortal3DEYE INTO Lc_ParamsRutasRol3DEYE;
    CLOSE C_ParametrosPortal3DEYE;
    
    -- CREO EL JSON HEADERS
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.OPEN_OBJECT('headers');
    APEX_JSON.WRITE('Content-Type', 'application/json');
    APEX_JSON.WRITE('Accept', 'application/json');
    APEX_JSON.WRITE('Authorization', Pv_Token);
    APEX_JSON.WRITE('x-api-key', Pv_ApiKey);
    APEX_JSON.CLOSE_OBJECT;
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Headers := APEX_JSON.GET_CLOB_OUTPUT;
  
    -- CREO EL CONTENIDO
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('name', Pv_NombreRol);
    APEX_JSON.WRITE('description', Pv_Descripcion);
    APEX_JSON.WRITE('type', Pv_Type);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Contenido := APEX_JSON.GET_CLOB_OUTPUT;
    
    -- VALIDAR SI EXISTE EL ROL CASO CONTRARIO SE PROCEDE A CREAR ROL
    DB_COMERCIAL.CMKG_NETCAM.P_VALIDAR_ROL(Pv_NombreRol,
                                           Pv_ApiKey,
                                           Pv_Token,
                                           Lv_Status,
                                           Lv_Mensaje,
                                           Ln_IdRol);
    IF Lv_Status = 'OK' THEN
      IF Ln_IdRol != 0 THEN
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.WRITE('id', Ln_IdRol);
        APEX_JSON.CLOSE_OBJECT;
        Pv_Status := 'OK';
        Pcl_Data  := APEX_JSON.GET_CLOB_OUTPUT;
      ELSE
        Lv_UrlFinal := Lc_ParamsRutasRol3DEYE.Valor1;
        DB_GENERAL.GNKG_WEB_SERVICE.P_POST(Lv_UrlFinal,
                                           Lcl_Headers,
                                           Lcl_Contenido,
                                           Ln_Code,
                                           Lv_Mensaje,
                                           Lcl_Data);
                                           
        IF Ln_Code = 0 THEN
          APEX_JSON.PARSE(Lcl_Data);
          Lv_Error       := APEX_JSON.get_varchar2(p_path => 'error');
          Ln_CountErrors := APEX_JSON.GET_COUNT(P_PATH => 'errors');
          -- REGISTRO ERROR DEL PROVEEDOR
          IF Lv_Error IS NOT NULL THEN
            Lv_Mensaje := APEX_JSON.get_varchar2(p_path => 'error_description');
            RAISE Le_Errors;
          END IF;
          -- REGISTRO ERRORES DEL PROVEEDOR
          IF Ln_CountErrors > 0 THEN
            FOR I IN 1 .. Ln_CountErrors LOOP
              APEX_JSON.PARSE(Lcl_Data);
              Lv_CodeError := APEX_JSON.get_varchar2(p_path => 'errors[%d].code',  p0 => I);
              Lv_MsgError  := APEX_JSON.get_varchar2(p_path => 'errors[%d].message',  p0 => I);
              Lv_MsgErrors := Lv_CodeError||' - '||Lv_MsgError||'| '||Lv_MsgErrors;
            END LOOP;
            Lv_Mensaje := Lv_MsgErrors;
            RAISE Le_Errors;
          END IF;
          Pv_Status  := 'OK';
          Pcl_Data   := Lcl_Data;
        ELSE
          RAISE Le_Errors;
        END IF;
      END IF;
    ELSE
      RAISE Le_Errors;
    END IF;
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := Lv_Mensaje;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.P_CREAR_ROL',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));  
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.P_CREAR_ROL',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));       
  END P_CREAR_ROL;

  PROCEDURE P_LISTA_USERS_BY_ROL(Pn_IdRol   IN  VARCHAR2,
                                 Pv_ApiKey  IN  VARCHAR2,
                                 Pv_Token   IN  VARCHAR2,
                                 Pv_Status  OUT VARCHAR2,
                                 Pv_Mensaje OUT VARCHAR2,
                                 Pcl_Data   OUT CLOB)
  AS
  
    CURSOR C_ParametrosPortal3DEYE(Cn_NombreParametro  VARCHAR2)
    IS
      SELECT APD.*
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
        AND APC.NOMBRE_PARAMETRO = Cn_NombreParametro
        AND APC.ESTADO = 'Activo';
        
    Lcl_Headers             CLOB;
    Lv_UrlFinal             VARCHAR2(4000);
    Ln_Code                 NUMBER;
    Lv_Mensaje              VARCHAR2(4000);
    Lcl_Data                CLOB;
    Lv_Error                VARCHAR2(1000);
    Ln_CountErrors          NUMBER := 0;
    Lv_CodeError            VARCHAR2(1000);
    Lv_MsgError             VARCHAR2(1000);
    Lv_MsgErrors            VARCHAR2(4000);
    Lc_ParamsRutasRol3DEYE  C_ParametrosPortal3DEYE%rowtype;
    Le_Errors               EXCEPTION;
  BEGIN
    OPEN  C_ParametrosPortal3DEYE('ENDPOINT ROL 3DEYE');
    FETCH C_ParametrosPortal3DEYE INTO Lc_ParamsRutasRol3DEYE;
    CLOSE C_ParametrosPortal3DEYE;
    
    -- CREO EL JSON HEADERS
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.OPEN_OBJECT('headers');
    APEX_JSON.WRITE('Content-Type', 'application/json');
    APEX_JSON.WRITE('Accept', 'application/json');
    APEX_JSON.WRITE('Authorization', Pv_Token);
    APEX_JSON.WRITE('x-api-key', Pv_ApiKey);
    APEX_JSON.CLOSE_OBJECT;
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Headers := APEX_JSON.GET_CLOB_OUTPUT;
    
    Lv_UrlFinal := REPLACE(Lc_ParamsRutasRol3DEYE.Valor3, 'roleId', Pn_IdRol);

    DB_GENERAL.GNKG_WEB_SERVICE.P_GET(Lv_UrlFinal,
                                      Lcl_Headers,
                                      Ln_Code,
                                      Lv_Mensaje,
                                      Lcl_Data);
                                       
    IF Ln_Code = 0 THEN
      APEX_JSON.PARSE(Lcl_Data);
      Lv_Error       := APEX_JSON.get_varchar2(p_path => 'error');
      Ln_CountErrors := APEX_JSON.GET_COUNT(P_PATH => 'errors');
      -- REGISTRO ERROR DEL PROVEEDOR
      IF Lv_Error IS NOT NULL THEN
        Lv_Mensaje := APEX_JSON.get_varchar2(p_path => 'error_description');
        RAISE Le_Errors;
      END IF;
      -- REGISTRO ERRORES DEL PROVEEDOR
      IF Ln_CountErrors > 0 THEN
        FOR I IN 1 .. Ln_CountErrors LOOP
          APEX_JSON.PARSE(Lcl_Data);
          Lv_CodeError := APEX_JSON.get_varchar2(p_path => 'errors[%d].code',  p0 => I);
          Lv_MsgError  := APEX_JSON.get_varchar2(p_path => 'errors[%d].message',  p0 => I);
          Lv_MsgErrors := Lv_CodeError||' - '||Lv_MsgError||'| '||Lv_MsgErrors;
        END LOOP;
        Lv_Mensaje := Lv_MsgErrors;
        RAISE Le_Errors;
      END IF;
      Pv_Status  := 'OK';
      Pcl_Data   := Lcl_Data;
    ELSE
      RAISE Le_Errors;
    END IF;
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := Lv_Mensaje;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.P_LISTA_USERS_BY_ROL',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));  
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.P_LISTA_USERS_BY_ROL',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));       
  END P_LISTA_USERS_BY_ROL;

  PROCEDURE P_VALIDAR_ROL(Pv_NombreRol IN  VARCHAR2,
                          Pv_ApiKey    IN  VARCHAR2,
                          Pv_Token     IN  VARCHAR2,
                          Pv_Status    OUT VARCHAR2,
                          Pv_Mensaje   OUT VARCHAR2,
                          Pn_IdRol     OUT NUMBER)
  AS
  
    CURSOR C_ParametrosPortal3DEYE(Cn_NombreParametro  VARCHAR2)
    IS
      SELECT APD.*
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
        AND APC.NOMBRE_PARAMETRO = Cn_NombreParametro
        AND APC.ESTADO = 'Activo';
        
    Lcl_Headers             CLOB;
    Lv_UrlFinal             VARCHAR2(4000);
    Ln_Code                 NUMBER;
    Lv_Mensaje              VARCHAR2(4000);
    Lcl_Data                CLOB;
    Lv_Error                VARCHAR2(1000);
    Ln_CountErrors          NUMBER := 0;
    Ln_CountRoles           NUMBER := 0;
    Lv_CodeError            VARCHAR2(1000);
    Lv_MsgError             VARCHAR2(1000);
    Lv_MsgErrors            VARCHAR2(4000);
    Lv_NombreRolLoop        VARCHAR2(1000);
    Ln_count                PLS_INTEGER;
    Lb_RolEncontrado        BOOLEAN;
    Lc_ParamsRutasRol3DEYE  C_ParametrosPortal3DEYE%rowtype;
    Le_Errors               EXCEPTION;
  BEGIN
    OPEN  C_ParametrosPortal3DEYE('ENDPOINT ROL 3DEYE');
    FETCH C_ParametrosPortal3DEYE INTO Lc_ParamsRutasRol3DEYE;
    CLOSE C_ParametrosPortal3DEYE;
  
    -- CREO EL JSON HEADERS
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.OPEN_OBJECT('headers');
    APEX_JSON.WRITE('Content-Type', 'application/json');
    APEX_JSON.WRITE('Accept', 'application/json');
    APEX_JSON.WRITE('Authorization', Pv_Token);
    APEX_JSON.WRITE('x-api-key', Pv_ApiKey);
    APEX_JSON.CLOSE_OBJECT;
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Headers := APEX_JSON.GET_CLOB_OUTPUT;
    
    Lv_UrlFinal := Lc_ParamsRutasRol3DEYE.Valor1;

    DB_GENERAL.GNKG_WEB_SERVICE.P_GET(Lv_UrlFinal,
                                      Lcl_Headers,
                                      Ln_Code,
                                      Lv_Mensaje,
                                      Lcl_Data);
                                       
    IF Ln_Code = 0 THEN
      APEX_JSON.PARSE(Lcl_Data);
      Lv_Error       := APEX_JSON.get_varchar2(p_path => 'error');
      Ln_CountErrors := APEX_JSON.GET_COUNT(P_PATH => 'errors');
      -- REGISTRO ERROR DEL PROVEEDOR
      IF Lv_Error IS NOT NULL THEN
        Lv_Mensaje := APEX_JSON.get_varchar2(p_path => 'error_description');
        RAISE Le_Errors;
      END IF;
      -- REGISTRO ERRORES DEL PROVEEDOR
      IF Ln_CountErrors > 0 THEN
        FOR I IN 1 .. Ln_CountErrors LOOP
          APEX_JSON.PARSE(Lcl_Data);
          Lv_CodeError := APEX_JSON.get_varchar2(p_path => 'errors[%d].code',  p0 => I);
          Lv_MsgError  := APEX_JSON.get_varchar2(p_path => 'errors[%d].message',  p0 => I);
          Lv_MsgErrors := Lv_CodeError||' - '||Lv_MsgError||'| '||Lv_MsgErrors;
        END LOOP;
        Lv_Mensaje := Lv_MsgErrors;
        RAISE Le_Errors;
      END IF;
      Pv_Status := 'OK';
      Pn_IdRol  := 0;
      Ln_CountRoles := APEX_JSON.GET_COUNT(P_PATH => 'roles');
      Ln_count := 1;
      WHILE (Ln_count <= Ln_CountRoles AND Ln_CountRoles IS NOT NULL) 
        OR NOT Lb_RolEncontrado LOOP
        APEX_JSON.PARSE(Lcl_Data);
        Lv_NombreRolLoop := APEX_JSON.get_varchar2(p_path => 'roles[%d].name',  p0 => Ln_count);
        IF Pv_NombreRol = Lv_NombreRolLoop THEN
          Pn_IdRol := APEX_JSON.get_number(p_path => 'roles[%d].id',  p0 => Ln_count);
          Lb_RolEncontrado := TRUE;
        END IF;
        Ln_count := Ln_count + 1;
      END LOOP;
    ELSE
      RAISE Le_Errors;
    END IF;
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := Lv_Mensaje;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.P_VALIDAR_ROL',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));  
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.P_VALIDAR_ROL',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));       
  END P_VALIDAR_ROL;

  PROCEDURE P_VALIDAR_CAM(Pv_NombreCam IN  VARCHAR2,
                          Pv_ApiKey    IN  VARCHAR2,
                          Pv_Token     IN  VARCHAR2,
                          Pv_Status    OUT VARCHAR2,
                          Pv_Mensaje   OUT VARCHAR2,
                          Pn_IdCam     OUT NUMBER)
  AS
  
    CURSOR C_ParametrosPortal3DEYE(Cn_NombreParametro  VARCHAR2)
    IS
      SELECT APD.*
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
        AND APC.NOMBRE_PARAMETRO = Cn_NombreParametro
        AND APC.ESTADO = 'Activo';
        
    Lcl_Headers             CLOB;
    Lv_UrlFinal             VARCHAR2(4000);
    Ln_Code                 NUMBER;
    Lv_Mensaje              VARCHAR2(4000);
    Lcl_Data                CLOB;
    Lv_Error                VARCHAR2(1000);
    Ln_CountErrors          NUMBER := 0;
    Ln_CountCamaras         NUMBER := 0;
    Lv_CodeError            VARCHAR2(1000);
    Lv_MsgError             VARCHAR2(1000);
    Lv_MsgErrors            VARCHAR2(4000);
    Lv_NombreCamLoop        VARCHAR2(1000);
    Ln_count                PLS_INTEGER;
    Lb_CamEncontrado        BOOLEAN;
    Lc_ParamsRutasCam3DEYE  C_ParametrosPortal3DEYE%rowtype;
    Le_Errors               EXCEPTION;
  BEGIN
    OPEN  C_ParametrosPortal3DEYE('ENDPOINT CAMARA 3DEYE');
    FETCH C_ParametrosPortal3DEYE INTO Lc_ParamsRutasCam3DEYE;
    CLOSE C_ParametrosPortal3DEYE;
  
    -- CREO EL JSON HEADERS
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.OPEN_OBJECT('headers');
    APEX_JSON.WRITE('Content-Type', 'application/json');
    APEX_JSON.WRITE('Accept', 'application/json');
    APEX_JSON.WRITE('Authorization', Pv_Token);
    APEX_JSON.WRITE('x-api-key', Pv_ApiKey);
    APEX_JSON.CLOSE_OBJECT;
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Headers := APEX_JSON.GET_CLOB_OUTPUT;
    
    Lv_UrlFinal := Lc_ParamsRutasCam3DEYE.Valor1;

    DB_GENERAL.GNKG_WEB_SERVICE.P_GET(Lv_UrlFinal,
                                      Lcl_Headers,
                                      Ln_Code,
                                      Lv_Mensaje,
                                      Lcl_Data);
                                       
    IF Ln_Code = 0 THEN
      APEX_JSON.PARSE(Lcl_Data);
      Lv_Error       := APEX_JSON.get_varchar2(p_path => 'error');
      Ln_CountErrors := APEX_JSON.GET_COUNT(P_PATH => 'errors');
      -- REGISTRO ERROR DEL PROVEEDOR
      IF Lv_Error IS NOT NULL THEN
        Lv_Mensaje := APEX_JSON.get_varchar2(p_path => 'error_description');
        RAISE Le_Errors;
      END IF;
      -- REGISTRO ERRORES DEL PROVEEDOR
      IF Ln_CountErrors > 0 THEN
        FOR I IN 1 .. Ln_CountErrors LOOP
          APEX_JSON.PARSE(Lcl_Data);
          Lv_CodeError := APEX_JSON.get_varchar2(p_path => 'errors[%d].code',  p0 => I);
          Lv_MsgError  := APEX_JSON.get_varchar2(p_path => 'errors[%d].message',  p0 => I);
          Lv_MsgErrors := Lv_CodeError||' - '||Lv_MsgError||'| '||Lv_MsgErrors;
        END LOOP;
        Lv_Mensaje := Lv_MsgErrors;
        RAISE Le_Errors;
      END IF;
      Pv_Status := 'OK';
      Pn_IdCam  := 0;
      Ln_CountCamaras := APEX_JSON.GET_COUNT(P_PATH => 'cameras');
      Ln_count := 1;
      WHILE (Ln_count <= Ln_CountCamaras AND Ln_CountCamaras IS NOT NULL) 
        OR NOT Lb_CamEncontrado LOOP
        APEX_JSON.PARSE(Lcl_Data);
        Lv_NombreCamLoop := APEX_JSON.get_varchar2(p_path => 'cameras[%d].name',  p0 => Ln_count);
        IF Pv_NombreCam = Lv_NombreCamLoop THEN
          Pn_IdCam := APEX_JSON.get_number(p_path => 'cameras[%d].id',  p0 => Ln_count);
          Lb_CamEncontrado := TRUE;
        END IF;
        Ln_count := Ln_count + 1;
      END LOOP;
    ELSE
      RAISE Le_Errors;
    END IF;
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := Lv_Mensaje;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.P_VALIDAR_CAM',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));  
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONSUMO PROVEEDOR 3DEYE', 
                                           'CMKG_NETCAM.P_VALIDAR_CAM',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));       
  END P_VALIDAR_CAM;

  PROCEDURE P_CORTE_SERVICIO_NETCAM(Pn_IdServicio IN  NUMBER,
                                    Pn_IdAccion   IN  NUMBER,
                                    Pv_User       IN  VARCHAR2,
                                    Pv_Status     OUT VARCHAR2,
                                    Pv_Mensaje    OUT VARCHAR2)
  AS
    
    CURSOR C_ParametrosPortal3DEYE
    IS
      SELECT APD.VALOR1 AS USERNAME, APD.VALOR2 AS PASSWORD, APD.VALOR3 AS API_KEY
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
        AND APC.NOMBRE_PARAMETRO = 'PORTAL 3DEYE'
        AND APC.ESTADO = 'Activo';
  
    CURSOR C_ValidarServicio(Cn_IdServicio  NUMBER,
                             Cv_Estado      VARCHAR2 DEFAULT 'Activo')
    IS
      SELECT ISE.*
      FROM DB_COMERCIAL.INFO_SERVICIO ISE
      WHERE ISE.ID_SERVICIO = Cn_IdServicio
        AND ISE.ESTADO = Cv_Estado;
        
    CURSOR C_ValidarAccion(Cn_IdAccion  NUMBER,
                           Cv_Estado    VARCHAR2 DEFAULT 'Activo')
    IS
      SELECT SA.*
      FROM DB_SEGURIDAD.SIST_ACCION SA
      WHERE SA.ID_ACCION = Cn_IdAccion
        AND SA.ESTADO = Cv_Estado;
   
    CURSOR C_CaracteristicaServicio3dEYE(Cn_IdServicio   NUMBER,
                                         Cv_Caract3DEYE  VARCHAR2,
                                         Cv_Estado       VARCHAR2 DEFAULT 'Activo')
    IS
      SELECT ISPC.ID_SERVICIO_PROD_CARACT AS ID_PROD_CARACT, ISPC.VALOR AS VALOR_PROD_CARACT
      FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC,
           DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
           DB_COMERCIAL.ADMI_CARACTERISTICA AC,
           DB_COMERCIAL.ADMI_PRODUCTO AP
      WHERE ISPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
        AND APC.CARACTERISTICA_ID = AC.ID_CARACTERISTICA
        AND APC.PRODUCTO_ID = AP.ID_PRODUCTO
        AND AP.NOMBRE_TECNICO = 'CAMARA IP'
        AND AC.DESCRIPCION_CARACTERISTICA = Cv_Caract3DEYE
        AND ISPC.ESTADO = Cv_Estado
        AND ISPC.SERVICIO_ID = Cn_IdServicio;
    
    Lc_ParametrosPortal3DEYE  C_ParametrosPortal3DEYE%ROWTYPE;
    Lc_Rol3DEYE               C_CaracteristicaServicio3dEYE%ROWTYPE;
    Lc_Camara3DEYE            C_CaracteristicaServicio3dEYE%ROWTYPE;
    Lc_ServicioActivo         C_ValidarServicio%ROWTYPE;
    Lc_Accion                 C_ValidarAccion%ROWTYPE;
    Lv_Token3DEYE             VARCHAR2(4000);
    Lb_RemoveCamRol           BOOLEAN;
    Le_Errors                 EXCEPTION;
  BEGIN
    -- INICIO VALIDACIONES GLOBALES
    OPEN  C_ParametrosPortal3DEYE;
    FETCH C_ParametrosPortal3DEYE INTO Lc_ParametrosPortal3DEYE;
    CLOSE C_ParametrosPortal3DEYE;
    
    IF Lc_ParametrosPortal3DEYE.USERNAME IS NULL OR 
       Lc_ParametrosPortal3DEYE.PASSWORD IS NULL OR
       Lc_ParametrosPortal3DEYE.API_KEY IS NULL THEN
      Pv_Mensaje := 'No se encuentran completos los par�metros del customer del portal 3dEYE';
      RAISE Le_Errors;  
    END IF;
    
    IF Pn_IdServicio IS NULL THEN
      Pv_Mensaje := 'El campo Pn_IdServicio esta vac�o';
      RAISE Le_Errors;
    END IF;
    
    OPEN  C_ValidarServicio(Pn_IdServicio);
    FETCH C_ValidarServicio INTO Lc_ServicioActivo;
    CLOSE C_ValidarServicio;
    
    IF Lc_ServicioActivo.Id_Servicio IS NULL THEN
      Pv_Mensaje := 'El servicio '||Pn_IdServicio||' no existe o no se encuentra Activo';
      RAISE Le_Errors;
    END IF;
    
    IF Pn_IdAccion IS NULL THEN
      Pv_Mensaje := 'El campo Pn_IdAccion esta vac�o';
      RAISE Le_Errors;
    END IF;
    
    OPEN  C_ValidarAccion(Pn_IdAccion);
    FETCH C_ValidarAccion INTO Lc_Accion;
    CLOSE C_ValidarAccion;
    
    IF Lc_Accion.ID_ACCION IS NULL THEN
      Pv_Mensaje := 'La acci�n '||Pn_IdAccion||' no existe o no se encuentra Activo';
      RAISE Le_Errors;
    END IF;
    
    IF Lc_Accion.Nombre_Accion != 'cortarCliente' THEN
      Pv_Mensaje := 'La acci�n '||Pn_IdAccion||' no esta relacionada con cortarCliente';
      RAISE Le_Errors;
    END IF;
    -- FIN VALIDACIONES GLOBALES
    -- OBTENGO EL ID ROL 3DEYE
    OPEN  C_CaracteristicaServicio3dEYE(Pn_IdServicio,
                                        'ROL 3DEYE');
    FETCH C_CaracteristicaServicio3dEYE INTO Lc_Rol3DEYE;
    CLOSE C_CaracteristicaServicio3dEYE;
    
    IF Lc_Rol3DEYE.VALOR_PROD_CARACT IS NULL THEN
      Pv_Mensaje := 'No existe el ROL 3dEYE del servicio '||Pn_IdServicio;
      RAISE Le_Errors;
    END IF;
    
    -- OBTENGO EL ID CAMARA 3DEYE
    OPEN  C_CaracteristicaServicio3dEYE(Pn_IdServicio,
                                        'CAMARA 3DEYE');
    FETCH C_CaracteristicaServicio3dEYE INTO Lc_Camara3DEYE;
    CLOSE C_CaracteristicaServicio3dEYE;
    
    IF Lc_Camara3DEYE.VALOR_PROD_CARACT IS NULL THEN
      Pv_Mensaje := 'No existe la CAMARA 3dEYE del servicio '||Pn_IdServicio;
      RAISE Le_Errors;
    END IF;
    
    -- OBTENGO EL TOKEN PARA LAS TRANSACCIONES
    Lv_Token3DEYE := DB_COMERCIAL.CMKG_NETCAM.F_GENERATE_TOKEN(Lc_ParametrosPortal3DEYE.USERNAME,
                                                               Lc_ParametrosPortal3DEYE.PASSWORD,
                                                               Lc_ParametrosPortal3DEYE.API_KEY);
    IF Lv_Token3DEYE IS NULL THEN
      Pv_Mensaje := 'Existe un problema al generar el token en el portal 3dEYE';
      RAISE Le_Errors;
    END IF;
    
    Lv_Token3DEYE := 'Bearer '||Lv_Token3DEYE;
    
    -- REMOVER LA CAMARA DEL ROL
    Lb_RemoveCamRol := DB_COMERCIAL.CMKG_NETCAM.F_REMOVER_CAM_ROL(Lc_Camara3DEYE.VALOR_PROD_CARACT,
                                                                  Lc_Rol3DEYE.VALOR_PROD_CARACT,
                                                                  Lc_ParametrosPortal3DEYE.API_KEY,
                                                                  Lv_Token3DEYE);
    IF NOT Lb_RemoveCamRol THEN
      Pv_Mensaje := 'No se pudo remover la c�mara del rol en el portal 3dEYE';
      RAISE Le_Errors;
    END IF;
    
    -- ACTUALIZAR SERVICIO EN TELCOS
    DB_COMERCIAL.CMKG_NETCAM.P_CAMBIO_SERVICIO_ESTADO(Pn_IdServicio,
                                                      Pn_IdAccion,
                                                      'CORTE',
                                                      NULL,
                                                      'N',
                                                      Pv_User,
                                                      Pv_Status,
                                                      Pv_Mensaje);
    
    IF Pv_Status != 'OK' THEN
      Pv_Mensaje := 'Ha ocurrido un problema. Por favor notifique a Sistemas!';
      RAISE Le_Errors;
    END IF;
    
    COMMIT;
    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transacci�n exitosa';
  EXCEPTION
    WHEN Le_Errors THEN
      -- ROLLBACK 3DEYE
      IF Lc_Camara3DEYE.VALOR_PROD_CARACT IS NOT NULL AND 
         Lc_Rol3DEYE.VALOR_PROD_CARACT IS NOT NULL AND
         Lb_RemoveCamRol THEN
        DB_COMERCIAL.CMKG_NETCAM.P_ROLLBACK_CORTE_NETCAM(Lc_Camara3DEYE.VALOR_PROD_CARACT,
                                                         Lc_Rol3DEYE.VALOR_PROD_CARACT,
                                                         Lc_ParametrosPortal3DEYE.API_KEY,
                                                         Lv_Token3DEYE,
                                                         Pv_User,
                                                         Pv_Status);
        IF Pv_Status != 'OK' THEN
          Pv_Mensaje := 'No se pudo realizar el respectivo rollback en el portal 3dEYE, comunicarse con Sistemas!';
        END IF;
      END IF;
      
      Pv_Status := 'ERROR';
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CORTE SERVICIO NETCAM', 
                                           'CMKG_NETCAM.P_CORTE_SERVICIO_NETCAM',
                                           Pv_Mensaje,
                                           NVL(Pv_User, 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
    WHEN OTHERS THEN
      -- ROLLBACK 3DEYE
      Pv_Mensaje := SQLERRM;
      IF Lc_Camara3DEYE.VALOR_PROD_CARACT IS NOT NULL AND 
         Lc_Rol3DEYE.VALOR_PROD_CARACT IS NOT NULL AND
         Lb_RemoveCamRol THEN
        DB_COMERCIAL.CMKG_NETCAM.P_ROLLBACK_CORTE_NETCAM(Lc_Camara3DEYE.VALOR_PROD_CARACT,
                                                         Lc_Rol3DEYE.VALOR_PROD_CARACT,
                                                         Lc_ParametrosPortal3DEYE.API_KEY,
                                                         Lv_Token3DEYE,
                                                         Pv_User,
                                                         Pv_Status);
        IF Pv_Status != 'OK' THEN
          Pv_Mensaje := 'No se pudo realizar el respectivo rollback en el portal 3dEYE, comunicarse con Sistemas!';
        END IF;
      END IF;
      
      Pv_Status := 'ERROR';
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CORTE SERVICIO NETCAM', 
                                           'CMKG_NETCAM.P_CORTE_SERVICIO_NETCAM',
                                           Pv_Mensaje,
                                           NVL(Pv_User, 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
           
  END P_CORTE_SERVICIO_NETCAM;

  PROCEDURE P_ROLLBACK_CORTE_NETCAM(Pv_IdCam   IN  VARCHAR2,
                                    Pv_IdRol   IN  VARCHAR2,
                                    Pv_ApiKey  IN  VARCHAR2,
                                    Pv_Token   IN  VARCHAR2,
                                    Pv_User    IN  VARCHAR2,
                                    Pv_Status  OUT VARCHAR2)
  AS
    
    Lb_AsignarCamRol  BOOLEAN;
    Lv_Mensaje        VARCHAR2(4000);
    Le_Errors         EXCEPTION;
  BEGIN
    -- ASIGNAR LA CAMARA AL ROL
    Lb_AsignarCamRol := DB_COMERCIAL.CMKG_NETCAM.F_ASIGNAR_CAM_ROL(Pv_IdCam,
                                                                   Pv_IdRol,
                                                                   Pv_ApiKey,
                                                                   Pv_Token);
    IF NOT Lb_AsignarCamRol THEN
      Lv_Mensaje := 'Rollback: No se pudo asignar la c�mara '||Pv_IdCam||' al rol '||Pv_IdRol||' en el portal 3dEYE';
      RAISE Le_Errors;
    END IF;
    
    Pv_Status  := 'OK';
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status := 'ERROR';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CORTE SERVICIO NETCAM', 
                                           'CMKG_NETCAM.P_ROLLBACK_CORTE_NETCAM',
                                           Lv_Mensaje,
                                           NVL(Pv_User, 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CORTE SERVICIO NETCAM', 
                                           'CMKG_NETCAM.P_ROLLBACK_CORTE_NETCAM',
                                           SQLERRM,
                                           NVL(Pv_User, 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
           
  END P_ROLLBACK_CORTE_NETCAM;

  PROCEDURE P_CAMBIO_SERVICIO_ESTADO(Pn_IdServicio    IN  NUMBER,
                                     Pn_IdAccion      IN  NUMBER,
                                     Pv_CambiarEstado IN  VARCHAR2,
                                     Pv_ObservCambio  IN  VARCHAR2,
                                     Pv_EsMasivo      IN  VARCHAR2,
                                     Pv_User          IN  VARCHAR2,
                                     Pv_Status        OUT VARCHAR2,
                                     Pv_Mensaje       OUT VARCHAR2)
  AS
  
    CURSOR C_ValidarServicio(Cn_IdServicio  NUMBER)
    IS
      SELECT ISE.*
      FROM DB_COMERCIAL.INFO_SERVICIO ISE
      WHERE ISE.ID_SERVICIO = Cn_IdServicio;
      
    CURSOR C_ValidarAccion(Cn_IdAccion  NUMBER,
                           Cv_Estado    VARCHAR2 DEFAULT 'Activo')
    IS
      SELECT SA.*
      FROM DB_SEGURIDAD.SIST_ACCION SA
      WHERE SA.ID_ACCION = Cn_IdAccion
        AND SA.ESTADO = Cv_Estado;
    
    CURSOR C_InfoGeneral(Cn_IdServicio  NUMBER)
    IS
      SELECT IP.ID_PUNTO             AS ID_PUNTO,
             IP.LOGIN,
             IPE.PERSONA_ID,
             IP.PERSONA_EMPRESA_ROL_ID,
             IST.ELEMENTO_CLIENTE_ID AS ID_ELEMENTO,
             IE.NOMBRE_ELEMENTO,
             IC.ID_CONTRATO
      FROM DB_COMERCIAL.INFO_PUNTO IP,
           DB_COMERCIAL.INFO_SERVICIO INS,
           DB_COMERCIAL.INFO_SERVICIO_TECNICO IST,
           DB_INFRAESTRUCTURA.INFO_ELEMENTO IE,
           DB_COMERCIAL.INFO_CONTRATO IC,
           DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPE
      WHERE IP.ID_PUNTO = INS.PUNTO_ID
        AND IST.ELEMENTO_CLIENTE_ID = IE.ID_ELEMENTO
        AND INS.ID_SERVICIO = IST.SERVICIO_ID
        AND IP.PERSONA_EMPRESA_ROL_ID = IC.PERSONA_EMPRESA_ROL_ID
        AND IP.PERSONA_EMPRESA_ROL_ID = IPE.ID_PERSONA_ROL
        AND INS.ID_SERVICIO = Cn_IdServicio;
    
    CURSOR C_InfoPunto(Cn_IdPunto  NUMBER)
    IS
      SELECT IP.*
      FROM DB_COMERCIAL.INFO_PUNTO IP
      WHERE IP.ID_PUNTO = Cn_IdPunto;
    
    CURSOR C_DetalleElemento(Cn_IdElemento  NUMBER)
    IS
      SELECT IDE.*
      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO IDE
      WHERE IDE.ELEMENTO_ID = Cn_IdElemento
      AND IDE.ESTADO = 'Activo';
    
    CURSOR C_CaracteristicasServicio(Cn_IdServicio  NUMBER)
    IS
      SELECT ISPC.*
      FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC
      WHERE ISPC.SERVICIO_ID = Cn_IdServicio
        AND ISPC.ESTADO = 'Activo';
        
    CURSOR C_NumServiciosSinCancel(Cn_IdPunto  NUMBER)
    IS
      SELECT COUNT(INS.ID_SERVICIO)
      FROM DB_COMERCIAL.INFO_SERVICIO INS
      WHERE INS.PUNTO_ID = Cn_IdPunto
        AND INS.ESTADO NOT IN ('Cancel', 'Cancel-SinEje', 'Anulado', 'Anulada', 'Eliminado',
                               'Eliminada', 'Eliminado-Migra', 'Rechazada', 'Trasladado');
                               
    CURSOR C_NumPuntosSinCancel(Cn_IdPersonaEmpresaRol  NUMBER)
    IS
      SELECT COUNT(IP.ID_PUNTO)
      FROM DB_COMERCIAL.INFO_PUNTO IP
      WHERE IP.PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaEmpresaRol
        AND IP.ESTADO NOT IN ('Cancelado');
        
    
    Lc_Servicio                C_ValidarServicio%rowtype;
    Lc_Accion                  C_ValidarAccion%rowtype;
    Lc_InfoGeneral             C_InfoGeneral%rowtype;
    Lc_InfoPunto               C_InfoPunto%rowtype;
    Ln_IdDetalleSolic          NUMBER;
    Ln_NumServiciosSinCancel   NUMBER;
    Ln_NumPuntosSinCancel      NUMBER;
    Le_Errors                  EXCEPTION;
    TYPE t_CaracteristicasServ IS TABLE OF DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT%rowtype;
    Lt_CaracteristicasServ     t_CaracteristicasServ;
    TYPE t_DetElementoServ IS TABLE OF DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO%rowtype;
    Lt_DetElementoServ        t_DetElementoServ;
  BEGIN
    -- INICIO VALIDACIONES GLOBALES
    IF Pn_IdServicio IS NULL THEN
      Pv_Mensaje := 'El campo Pn_IdServicio esta vac�o';
      RAISE Le_Errors;
    END IF;
    
    OPEN  C_ValidarServicio(Pn_IdServicio);
    FETCH C_ValidarServicio INTO Lc_Servicio;
    CLOSE C_ValidarServicio;
    
    IF Lc_Servicio.Id_Servicio IS NULL THEN
      Pv_Mensaje := 'El servicio '||Pn_IdServicio||' no existe';
      RAISE Le_Errors;
    END IF;
    
    IF Pn_IdAccion IS NULL THEN
      Pv_Mensaje := 'El campo Pn_IdAccion esta vac�o';
      RAISE Le_Errors;
    END IF;
    
    OPEN  C_ValidarAccion(Pn_IdAccion);
    FETCH C_ValidarAccion INTO Lc_Accion;
    CLOSE C_ValidarAccion;
    
    IF Lc_Accion.ID_ACCION IS NULL THEN
      Pv_Mensaje := 'La acci�n '||Pn_IdAccion||' no existe o no se encuentra Activo';
      RAISE Le_Errors;
    END IF;
    -- FIN VALIDACIONES GLOBALES
    -- OBTENGO INFORMACION GENERAL
    OPEN  C_InfoGeneral(Pn_IdServicio);
    FETCH C_InfoGeneral INTO Lc_InfoGeneral;
    CLOSE C_InfoGeneral;
    
    -- OBTENGO INFORMACION DEL PUNTO
    OPEN  C_InfoPunto(Lc_InfoGeneral.Id_Punto);
    FETCH C_InfoPunto INTO Lc_InfoPunto;
    CLOSE C_InfoPunto;
    
    -- LOGICA CORTE
    IF UPPER(Pv_CambiarEstado) = 'CORTE' THEN
      -- ACTUALIZAR INFO_SERVICIO
      UPDATE DB_COMERCIAL.INFO_SERVICIO IFS
      SET
        IFS.ESTADO = 'In-Corte'
      WHERE IFS.ID_SERVICIO = Pn_IdServicio;
      
      -- AGREGAR HISTORIAL DEL SERVICIO
      INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
        (
          ID_SERVICIO_HISTORIAL,
          SERVICIO_ID,
          USR_CREACION,
          FE_CREACION,
          IP_CREACION,
          ESTADO,
          MOTIVO_ID,
          OBSERVACION,
          ACCION
        )
      VALUES
        (
          DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
          Pn_IdServicio,
          NVL(Pv_User, 'telcos'),
          SYSDATE,
          NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'),
          'In-Corte',
          NULL,
          NVL(Pv_ObservCambio, TO_CLOB('Se cort� el servicio')),
          Lc_Accion.NOMBRE_ACCION
        );
    -- LOGICA REACTIVACION
    ELSIF UPPER(Pv_CambiarEstado) = 'REACTIVACION' THEN
      -- ACTUALIZAR INFO_SERVICIO
      UPDATE DB_COMERCIAL.INFO_SERVICIO IFS
      SET
        IFS.ESTADO = 'Activo'
      WHERE IFS.ID_SERVICIO = Pn_IdServicio;
      
      -- AGREGAR HISTORIAL DEL SERVICIO
      INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
        (
          ID_SERVICIO_HISTORIAL,
          SERVICIO_ID,
          USR_CREACION,
          FE_CREACION,
          IP_CREACION,
          ESTADO,
          MOTIVO_ID,
          OBSERVACION,
          ACCION
        )
      VALUES
        (
          DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
          Pn_IdServicio,
          NVL(Pv_User, 'telcos'),
          SYSDATE,
          NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'),
          'Activo',
          NULL,
          NVL(Pv_ObservCambio, TO_CLOB('Se reactiv� el servicio')),
          Lc_Accion.NOMBRE_ACCION
        );
    -- LOGICA CANCELACION
    ELSIF UPPER(Pv_CambiarEstado) = 'CANCELACION' THEN
      -- ACTUALIZAR INFO_SERVICIO
      UPDATE DB_COMERCIAL.INFO_SERVICIO IFS
      SET
        IFS.ESTADO = 'Cancel'
      WHERE IFS.ID_SERVICIO = Pn_IdServicio;
      
      -- AGREGAR HISTORIAL DEL SERVICIO
      INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
        (
          ID_SERVICIO_HISTORIAL,
          SERVICIO_ID,
          USR_CREACION,
          FE_CREACION,
          IP_CREACION,
          ESTADO,
          MOTIVO_ID,
          OBSERVACION,
          ACCION
        )
      VALUES
        (
          DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
          Pn_IdServicio,
          NVL(Pv_User, 'telcos'),
          SYSDATE,
          NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'),
          'Cancel',
          NULL,
          NVL(Pv_ObservCambio, TO_CLOB('Se cancelo el servicio')),
          Lc_Accion.NOMBRE_ACCION
        ); 
        
      -- ELIMINA LAS CARACTERISTICA DEL SERVICIO
      OPEN C_CaracteristicasServicio(Pn_IdServicio);
      LOOP
        FETCH C_CaracteristicasServicio BULK COLLECT INTO Lt_CaracteristicasServ LIMIT 1000;
        EXIT WHEN Lt_CaracteristicasServ.COUNT = 0;
        FORALL I IN Lt_CaracteristicasServ.FIRST .. Lt_CaracteristicasServ.LAST SAVE EXCEPTIONS
          UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC
          SET
            ISPC.ESTADO = 'Eliminado',
            ISPC.USR_ULT_MOD = NVL(Pv_User, 'telcos'),
            ISPC.FE_ULT_MOD = SYSDATE
          WHERE ISPC.ID_SERVICIO_PROD_CARACT = Lt_CaracteristicasServ(I).Id_Servicio_Prod_Caract;
      END LOOP;
      CLOSE C_CaracteristicasServicio;
    
      -- VERIFICO SI ES EL ULTIMO SERVICIO EN EL PUNTO
      OPEN  C_NumServiciosSinCancel(Lc_Servicio.Punto_Id);
      FETCH C_NumServiciosSinCancel INTO Ln_NumServiciosSinCancel;
      CLOSE C_NumServiciosSinCancel;

      IF Ln_NumServiciosSinCancel = 0 AND Pv_EsMasivo = 'N' THEN
        UPDATE DB_COMERCIAL.INFO_PUNTO IP
        SET
          IP.ESTADO = 'Cancelado',
          IP.USR_ULT_MOD = NVL(Pv_User, 'telcos'),
          IP.FE_ULT_MOD = SYSDATE
        WHERE IP.ID_PUNTO = Lc_Servicio.Punto_Id;
      END IF;
    
      -- VERIFICO SI ES EL ULTIMO PUNTO DEL CLIENTE
      OPEN  C_NumPuntosSinCancel(Lc_InfoGeneral.Persona_Empresa_Rol_Id);
      FETCH C_NumPuntosSinCancel INTO Ln_NumPuntosSinCancel;
      CLOSE C_NumPuntosSinCancel;

      IF Ln_NumPuntosSinCancel = 0 AND Pv_EsMasivo = 'N' THEN
        -- SE CANCELA EL CONTRATO
        UPDATE DB_COMERCIAL.INFO_CONTRATO IC
        SET
          IC.ESTADO = 'Cancelado'
        WHERE IC.ID_CONTRATO = Lc_InfoGeneral.Id_Contrato;
        -- SE CANCELA LA PERSONA_EMPRESA_ROL
        UPDATE DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPE
        SET
          IPE.ESTADO = 'Cancelado',
          IPE.USR_ULT_MOD = NVL(Pv_User, 'telcos'),
          IPE.FE_ULT_MOD = SYSDATE
        WHERE IPE.ID_PERSONA_ROL = Lc_InfoGeneral.Persona_Empresa_Rol_Id;
        -- SE INGRESA UN REGISTRO EN EL HISTORIAL EMPRESA PERSONA ROL
        INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO
          (
            ID_PERSONA_EMPRESA_ROL_HISTO,
            USR_CREACION,
            FE_CREACION,
            IP_CREACION,
            ESTADO,
            PERSONA_EMPRESA_ROL_ID,
            OBSERVACION,
            MOTIVO_ID,
            EMPRESA_ROL_ID,
            OFICINA_ID,
            DEPARTAMENTO_ID,
            CUADRILLA_ID,
            REPORTA_PERSONA_EMPRESA_ROL_ID,
            ES_PREPAGO
          )
        VALUES
          (
            DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL_H.NEXTVAL,
            NVL(Pv_User, 'telcos'),
            SYSDATE,
            NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'),
            'Cancelado',
            Lc_InfoGeneral.Persona_Empresa_Rol_Id,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL
          );
        -- SE CANCELA EL CLIENTE
        UPDATE DB_COMERCIAL.INFO_PERSONA IP
        SET
          IP.ESTADO = 'Cancelado'
        WHERE IP.ID_PERSONA = Lc_InfoGeneral.Persona_Id;
      END IF;
      
      -- ELIMINAR EL ELEMENTO DEL SERVICIO
      UPDATE DB_INFRAESTRUCTURA.INFO_ELEMENTO IE
      SET
        IE.ESTADO = 'Eliminado'
      WHERE IE.ID_ELEMENTO = Lc_InfoGeneral.Id_Elemento;
      
      -- ELIMINAR LOS ELEMENTOS DE LA CAMARA
      OPEN C_DetalleElemento(Lc_InfoGeneral.Id_Elemento);
      LOOP
        FETCH C_DetalleElemento BULK COLLECT INTO Lt_DetElementoServ LIMIT 1000;
        EXIT WHEN Lt_DetElementoServ.COUNT = 0;
        FORALL I IN Lt_DetElementoServ.FIRST .. Lt_DetElementoServ.LAST SAVE EXCEPTIONS
          UPDATE DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO IDE
          SET
            IDE.ESTADO = 'Eliminado'
          WHERE IDE.ID_DETALLE_ELEMENTO = Lt_DetElementoServ(I).Id_Detalle_Elemento;
      END LOOP;
      CLOSE C_DetalleElemento;
      
      -- REGISTRAR HISTORIAL DEL ELEMENTO
      INSERT INTO DB_INFRAESTRUCTURA.INFO_HISTORIAL_ELEMENTO
        (
          ID_HISTORIAL,
          ELEMENTO_ID,
          ESTADO_ELEMENTO,
          CAPACIDAD,
          OBSERVACION,
          USR_CREACION,
          FE_CREACION,
          IP_CREACION
        )
      VALUES
        (
          DB_INFRAESTRUCTURA.SEQ_INFO_HISTORIAL_ELEMENTO.NEXTVAL,
          Lc_InfoGeneral.Id_Elemento,
          'Eliminado',
          NULL,
          'Se elimino por cancelaci�n de Servicio',
          NVL(Pv_User, 'telcos'),
          SYSDATE,
          NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1')
        );
      -- CREO SOLICITUD DE RETIRO DE EQUIPO
      INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOLICITUD
        (
          ID_DETALLE_SOLICITUD,
          SERVICIO_ID,
          TIPO_SOLICITUD_ID,
          MOTIVO_ID,
          USR_CREACION,
          FE_CREACION,
          PRECIO_DESCUENTO,
          PORCENTAJE_DESCUENTO,
          TIPO_DOCUMENTO,
          OBSERVACION,
          ESTADO,
          USR_RECHAZO,
          FE_RECHAZO,
          DETALLE_PROCESO_ID,
          FE_EJECUCION,
          ELEMENTO_ID
        )
      VALUES
        (
          DB_COMERCIAL.SEQ_INFO_DETALLE_SOLICITUD.NEXTVAL,
          Pn_IdServicio,
          (SELECT ATS.ID_TIPO_SOLICITUD
          FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
          WHERE ATS.DESCRIPCION_SOLICITUD = 'SOLICITUD RETIRO EQUIPO'
            AND ATS.ESTADO = 'Activo'),
          NULL,
          NVL(Pv_User, 'telcos'),
          SYSDATE,
          NULL,
          NULL,
          NULL,
          'SOLICITA RETIRO DE EQUIPO POR CANCELACION DEL SERVICIO',
          'AsignadoTarea',
          NULL,
          NULL,
          NULL,
          NULL,
          Lc_InfoGeneral.Id_Elemento
        ) RETURNING ID_DETALLE_SOLICITUD INTO Ln_IdDetalleSolic;
      -- AGREGAR CARACTERISTICA A LA SOLICITUD DE RETIRO DE EQUIPO 
      INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_CARACT
        (
          ID_SOLICITUD_CARACTERISTICA,
          CARACTERISTICA_ID,
          VALOR,
          DETALLE_SOLICITUD_ID,
          ESTADO,
          USR_CREACION,
          USR_ULT_MOD,
          FE_CREACION,
          FE_ULT_MOD,
          DETALLE_SOL_CARACT_ID
        )
      VALUES
        (
          DB_COMERCIAL.SEQ_INFO_DET_SOL_CARACT.NEXTVAL,
          (SELECT AC.ID_CARACTERISTICA
          FROM DB_COMERCIAL.ADMI_CARACTERISTICA AC
          WHERE AC.DESCRIPCION_CARACTERISTICA = 'ELEMENTO CLIENTE'
           AND AC.ESTADO = 'Activo'),
          Lc_InfoGeneral.Id_Elemento,
          Ln_IdDetalleSolic,
          'AsignadoTarea',
          NVL(Pv_User, 'telcos'),
          NULL,
          SYSDATE,
          NULL,
          NULL
        );
      -- CREAR HISTORIAL PARA LA SOLICITUD
      INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST
        (
          ID_SOLICITUD_HISTORIAL,
          DETALLE_SOLICITUD_ID,
          ESTADO,
          FE_INI_PLAN,
          FE_FIN_PLAN,
          OBSERVACION,
          USR_CREACION,
          FE_CREACION,
          IP_CREACION,
          MOTIVO_ID
        )
      VALUES
        (
          DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,
          Ln_IdDetalleSolic,
          'AsignadoTarea',
          NULL,
          NULL,
          'GENERACION AUTOMATICA DE SOLICITUD RETIRO DE EQUIPO POR CANCELACION DEL SERIVICIO',
          NVL(Pv_User, 'telcos'),
          SYSDATE,
          NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'),
          NULL
        );
    ELSE
      Pv_Mensaje := 'La acci�n '||Pv_CambiarEstado||' no existe o no se encuentra configurado
      actualmente existe CORTE, REACTIVACION y CANCELACION';
      RAISE Le_Errors;
    END IF;
    
    Pv_Status := 'OK';
    Pv_Mensaje := 'Transacci�n exitosa';
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status := 'ERROR';
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CAMBIO SERVICIO NETCAM', 
                                           'CMKG_NETCAM.P_CAMBIO_SERVICIO_ESTADO',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CAMBIO SERVICIO NETCAM', 
                                           'CMKG_NETCAM.P_CAMBIO_SERVICIO_ESTADO',
                                           Pv_Mensaje,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
  END P_CAMBIO_SERVICIO_ESTADO;

  PROCEDURE P_REACTIVACION_SERVICIO_NETCAM(Pn_IdServicio IN  NUMBER,
                                           Pn_IdAccion   IN  NUMBER,
                                           Pv_User       IN  VARCHAR2,
                                           Pv_Status     OUT VARCHAR2,
                                           Pv_Mensaje    OUT VARCHAR2)
  AS
    
    CURSOR C_ParametrosPortal3DEYE
    IS
      SELECT APD.VALOR1 AS USERNAME, APD.VALOR2 AS PASSWORD, APD.VALOR3 AS API_KEY
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
        AND APC.NOMBRE_PARAMETRO = 'PORTAL 3DEYE'
        AND APC.ESTADO = 'Activo';
  
    CURSOR C_ValidarServicio(Cn_IdServicio  NUMBER,
                             Cv_Estado      VARCHAR2 DEFAULT 'Activo')
    IS
      SELECT ISE.*
      FROM DB_COMERCIAL.INFO_SERVICIO ISE
      WHERE ISE.ID_SERVICIO = Cn_IdServicio
        AND ISE.ESTADO = Cv_Estado;
        
    CURSOR C_ValidarAccion(Cn_IdAccion  NUMBER,
                           Cv_Estado    VARCHAR2 DEFAULT 'Activo')
    IS
      SELECT SA.*
      FROM DB_SEGURIDAD.SIST_ACCION SA
      WHERE SA.ID_ACCION = Cn_IdAccion
        AND SA.ESTADO = Cv_Estado;
   
    CURSOR C_CaracteristicaServicio3dEYE(Cn_IdServicio   NUMBER,
                                         Cv_Caract3DEYE  VARCHAR2,
                                         Cv_Estado       VARCHAR2 DEFAULT 'Activo')
    IS
      SELECT ISPC.ID_SERVICIO_PROD_CARACT AS ID_PROD_CARACT, ISPC.VALOR AS VALOR_PROD_CARACT
      FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC,
           DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
           DB_COMERCIAL.ADMI_CARACTERISTICA AC,
           DB_COMERCIAL.ADMI_PRODUCTO AP
      WHERE ISPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
        AND APC.CARACTERISTICA_ID = AC.ID_CARACTERISTICA
        AND APC.PRODUCTO_ID = AP.ID_PRODUCTO
        AND AP.NOMBRE_TECNICO = 'CAMARA IP'
        AND AC.DESCRIPCION_CARACTERISTICA = Cv_Caract3DEYE
        AND ISPC.ESTADO = Cv_Estado
        AND ISPC.SERVICIO_ID = Cn_IdServicio;
    
    Lc_ParametrosPortal3DEYE  C_ParametrosPortal3DEYE%rowtype;
    Lc_Rol3DEYE               C_CaracteristicaServicio3dEYE%rowtype;
    Lc_Camara3DEYE            C_CaracteristicaServicio3dEYE%rowtype;
    Lc_ServicioInCorte        C_ValidarServicio%rowtype;
    Lc_Accion                 C_ValidarAccion%rowtype;
    Lv_Token3DEYE             VARCHAR2(4000);
    Lb_AsignarCamRol          BOOLEAN;
    Le_Errors                 EXCEPTION;
  BEGIN
    -- INICIO VALIDACIONES GLOBALES
    OPEN  C_ParametrosPortal3DEYE;
    FETCH C_ParametrosPortal3DEYE INTO Lc_ParametrosPortal3DEYE;
    CLOSE C_ParametrosPortal3DEYE;
    
    IF Lc_ParametrosPortal3DEYE.USERNAME IS NULL OR 
       Lc_ParametrosPortal3DEYE.PASSWORD IS NULL OR
       Lc_ParametrosPortal3DEYE.API_KEY IS NULL THEN
      Pv_Mensaje := 'No se encuentran completos los par�metros del customer del portal 3dEYE';
      RAISE Le_Errors;  
    END IF;
    
    IF Pn_IdServicio IS NULL THEN
      Pv_Mensaje := 'El campo Pn_IdServicio esta vac�o';
      RAISE Le_Errors;
    END IF;
    
    OPEN  C_ValidarServicio(Pn_IdServicio,
                            'In-Corte');
    FETCH C_ValidarServicio INTO Lc_ServicioInCorte;
    CLOSE C_ValidarServicio;
    
    IF Lc_ServicioInCorte.Id_Servicio IS NULL THEN
      Pv_Mensaje := 'El servicio '||Pn_IdServicio||' no existe o no se encuentra In-Corte';
      RAISE Le_Errors;
    END IF;
    
    IF Pn_IdAccion IS NULL THEN
      Pv_Mensaje := 'El campo Pn_IdAccion esta vac�o';
      RAISE Le_Errors;
    END IF;
    
    OPEN  C_ValidarAccion(Pn_IdAccion);
    FETCH C_ValidarAccion INTO Lc_Accion;
    CLOSE C_ValidarAccion;
    
    IF Lc_Accion.ID_ACCION IS NULL THEN
      Pv_Mensaje := 'La acci�n '||Pn_IdAccion||' no existe o no se encuentra Activo';
      RAISE Le_Errors;
    END IF;
    
    IF Lc_Accion.Nombre_Accion != 'reconectarCliente' THEN
      Pv_Mensaje := 'La acci�n '||Pn_IdAccion||' no esta relacionada con reconectarCliente';
      RAISE Le_Errors;
    END IF;
    -- FIN VALIDACIONES GLOBALES
    -- OBTENGO EL ID ROL 3DEYE
    OPEN  C_CaracteristicaServicio3dEYE(Pn_IdServicio,
                                        'ROL 3DEYE');
    FETCH C_CaracteristicaServicio3dEYE INTO Lc_Rol3DEYE;
    CLOSE C_CaracteristicaServicio3dEYE;
    
    IF Lc_Rol3DEYE.VALOR_PROD_CARACT IS NULL THEN
      Pv_Mensaje := 'No existe el ROL 3dEYE del servicio '||Pn_IdServicio;
      RAISE Le_Errors;
    END IF;
    
    -- OBTENGO EL ID CAMARA 3DEYE
    OPEN  C_CaracteristicaServicio3dEYE(Pn_IdServicio,
                                        'CAMARA 3DEYE');
    FETCH C_CaracteristicaServicio3dEYE INTO Lc_Camara3DEYE;
    CLOSE C_CaracteristicaServicio3dEYE;
    
    IF Lc_Camara3DEYE.VALOR_PROD_CARACT IS NULL THEN
      Pv_Mensaje := 'No existe la CAMARA 3dEYE del servicio '||Pn_IdServicio;
      RAISE Le_Errors;
    END IF;
  
    -- OBTENGO EL TOKEN PARA LAS TRANSACCIONES
    Lv_Token3DEYE := DB_COMERCIAL.CMKG_NETCAM.F_GENERATE_TOKEN(Lc_ParametrosPortal3DEYE.USERNAME,
                                                               Lc_ParametrosPortal3DEYE.PASSWORD,
                                                               Lc_ParametrosPortal3DEYE.API_KEY);
    IF Lv_Token3DEYE IS NULL THEN
      Pv_Mensaje := 'Existe un problema al generar el token en el portal 3dEYE';
      RAISE Le_Errors;
    END IF;
    
    Lv_Token3DEYE := 'Bearer '||Lv_Token3DEYE;
    
    -- ASIGNAR LA CAMARA AL ROL
    Lb_AsignarCamRol := DB_COMERCIAL.CMKG_NETCAM.F_ASIGNAR_CAM_ROL(Lc_Camara3DEYE.VALOR_PROD_CARACT,
                                                                   Lc_Rol3DEYE.VALOR_PROD_CARACT,
                                                                   Lc_ParametrosPortal3DEYE.API_KEY,
                                                                   Lv_Token3DEYE);
    IF NOT Lb_AsignarCamRol THEN
      Pv_Mensaje := 'No se pudo asignar la c�mara al rol en el portal 3dEYE';
      RAISE Le_Errors;
    END IF;
  
    -- ACTUALIZAR SERVICIO EN TELCOS
    DB_COMERCIAL.CMKG_NETCAM.P_CAMBIO_SERVICIO_ESTADO(Pn_IdServicio,
                                                      Pn_IdAccion,
                                                      'REACTIVACION',
                                                      NULL,
                                                      'N',
                                                      Pv_User,
                                                      Pv_Status,
                                                      Pv_Mensaje);
    
    IF Pv_Status != 'OK' THEN
      Pv_Mensaje := 'Ha ocurrido un problema. Por favor notifique a Sistemas!';
      RAISE Le_Errors;
    END IF;
    
    COMMIT;
    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transacci�n exitosa';
  EXCEPTION
    WHEN Le_Errors THEN
      -- ROLLBACK 3DEYE
      IF Lc_Camara3DEYE.VALOR_PROD_CARACT IS NOT NULL AND 
         Lc_Rol3DEYE.VALOR_PROD_CARACT IS NOT NULL AND
         Lb_AsignarCamRol THEN
        DB_COMERCIAL.CMKG_NETCAM.P_ROLLBACK_REACTIVACION_NETCAM(Lc_Camara3DEYE.VALOR_PROD_CARACT,
                                                                Lc_Rol3DEYE.VALOR_PROD_CARACT,
                                                                Lc_ParametrosPortal3DEYE.API_KEY,
                                                                Lv_Token3DEYE,
                                                                Pv_User,
                                                                Pv_Status);
        IF Pv_Status != 'OK' THEN
          Pv_Mensaje := 'No se pudo realizar el respectivo rollback en el portal 3dEYE, comunicarse con Sistemas!';
        END IF;
      END IF;
      
      Pv_Status := 'ERROR';
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('REACTIVACION SERVICIO NETCAM', 
                                           'CMKG_NETCAM.P_REACTIVACION_SERVICIO_NETCAM',
                                           Pv_Mensaje,
                                           NVL(Pv_User, 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
    WHEN OTHERS THEN
      -- ROLLBACK 3DEYE
      Pv_Mensaje := SQLERRM;
      IF Lc_Camara3DEYE.VALOR_PROD_CARACT IS NOT NULL AND 
         Lc_Rol3DEYE.VALOR_PROD_CARACT IS NOT NULL AND
         Lb_AsignarCamRol THEN
        DB_COMERCIAL.CMKG_NETCAM.P_ROLLBACK_REACTIVACION_NETCAM(Lc_Camara3DEYE.VALOR_PROD_CARACT,
                                                                Lc_Rol3DEYE.VALOR_PROD_CARACT,
                                                                Lc_ParametrosPortal3DEYE.API_KEY,
                                                                Lv_Token3DEYE,
                                                                Pv_User,
                                                                Pv_Status);
        IF Pv_Status != 'OK' THEN
          Pv_Mensaje := 'No se pudo realizar el respectivo rollback en el portal 3dEYE, comunicarse con Sistemas!';
        END IF;
      END IF;
      
      Pv_Status := 'ERROR';
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('REACTIVACION SERVICIO NETCAM', 
                                           'CMKG_NETCAM.P_REACTIVACION_SERVICIO_NETCAM',
                                           Pv_Mensaje,
                                           NVL(Pv_User, 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
  
  END P_REACTIVACION_SERVICIO_NETCAM;

  PROCEDURE P_ROLLBACK_REACTIVACION_NETCAM(Pv_IdCam   IN  VARCHAR2,
                                           Pv_IdRol   IN  VARCHAR2,
                                           Pv_ApiKey  IN  VARCHAR2,
                                           Pv_Token   IN  VARCHAR2,
                                           Pv_User    IN  VARCHAR2,
                                           Pv_Status  OUT VARCHAR2)
  AS
    
    Lb_RemoverCamRol  BOOLEAN;
    Lv_Mensaje        VARCHAR2(4000);
    Le_Errors         EXCEPTION;
  BEGIN
    -- REMOVER LA CAMARA AL ROL
    Lb_RemoverCamRol := DB_COMERCIAL.CMKG_NETCAM.F_REMOVER_CAM_ROL(Pv_IdCam,
                                                                   Pv_IdRol,
                                                                   Pv_ApiKey,
                                                                   Pv_Token);
    IF NOT Lb_RemoverCamRol THEN
      Lv_Mensaje := 'Rollback: No se pudo remover la c�mara '||Pv_IdCam||' del rol '||Pv_IdRol||' en el portal 3dEYE';
      RAISE Le_Errors;
    END IF;
    
    Pv_Status  := 'OK';
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status := 'ERROR';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('REACTIVACION SERVICIO NETCAM', 
                                           'CMKG_NETCAM.P_ROLLBACK_REACTIVACION_NETCAM',
                                           Lv_Mensaje,
                                           NVL(Pv_User, 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('REACTIVACION SERVICIO NETCAM', 
                                           'CMKG_NETCAM.P_ROLLBACK_REACTIVACION_NETCAM',
                                           SQLERRM,
                                           NVL(Pv_User, 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
           
  END P_ROLLBACK_REACTIVACION_NETCAM;

  PROCEDURE P_CANCELACION_SERVICIO_NETCAM(Pn_IdServicio IN  NUMBER,
                                          Pn_IdAccion   IN  NUMBER,
                                          Pv_EsMasivo   IN  VARCHAR2,
                                          Pv_User       IN  VARCHAR2,
                                          Pv_Status     OUT VARCHAR2,
                                          Pv_Mensaje    OUT VARCHAR2)
  AS
    
    CURSOR C_ParametrosPortal3DEYE
    IS
      SELECT APD.VALOR1 AS USERNAME, APD.VALOR2 AS PASSWORD, APD.VALOR3 AS API_KEY
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
        AND APC.NOMBRE_PARAMETRO = 'PORTAL 3DEYE'
        AND APC.ESTADO = 'Activo';
  
    CURSOR C_ValidarServicio(Cn_IdServicio  NUMBER)
    IS
      SELECT ISE.*
      FROM DB_COMERCIAL.INFO_SERVICIO ISE
      WHERE ISE.ID_SERVICIO = Cn_IdServicio
      AND ISE.ESTADO NOT IN ('Anulado', 'Eliminado', 'Cancel', 'Trasladado',
                             'Rechazada', 'Inactivo', 'AnuladoMigra', 'Reubicado',
                             'Eliminado-Migra', 'AnuladoMigra', 'migracion_ttco');
      
    CURSOR C_InfoGeneralCancelacion(Cn_IdServicio  NUMBER)
    IS
      SELECT IP.ID_PUNTO             AS ID_PUNTO,
             IP.LOGIN,
             IP.PERSONA_EMPRESA_ROL_ID,
             IST.ELEMENTO_CLIENTE_ID AS ID_ELEMENTO,
             IE.NOMBRE_ELEMENTO
      FROM DB_COMERCIAL.INFO_PUNTO IP,
           DB_COMERCIAL.INFO_SERVICIO INS,
           DB_COMERCIAL.INFO_SERVICIO_TECNICO IST,
           DB_INFRAESTRUCTURA.INFO_ELEMENTO IE
      WHERE IP.ID_PUNTO = INS.PUNTO_ID
        AND IST.ELEMENTO_CLIENTE_ID = IE.ID_ELEMENTO
        AND INS.ID_SERVICIO = IST.SERVICIO_ID
        AND INS.ID_SERVICIO = Cn_IdServicio;

    CURSOR C_CountServiceNetCamPunto(Cn_IdPunto  NUMBER)
    IS
      SELECT COUNT(INS.ID_SERVICIO)
      FROM DB_COMERCIAL.INFO_SERVICIO INS
      WHERE INS.PLAN_ID IN (SELECT IPT.PLAN_ID
                            FROM DB_COMERCIAL.INFO_PLAN_CAB IPC, DB_COMERCIAL.INFO_PLAN_DET IPT, DB_COMERCIAL.ADMI_PRODUCTO AP
                            WHERE IPC.ID_PLAN = IPT.PLAN_ID
                              AND IPT.PRODUCTO_ID = AP.ID_PRODUCTO
                              AND AP.NOMBRE_TECNICO = 'CAMARA IP'
                              AND IPC.ESTADO = 'Activo'
                           )
        AND INS.ESTADO <> 'Cancel'
        AND INS.PUNTO_ID = Cn_IdPunto; 
        
    CURSOR C_DetalleElemento(Cn_IdElemento  NUMBER)
    IS
      SELECT IDE.*
      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO IDE
      WHERE IDE.ELEMENTO_ID = Cn_IdElemento
      AND IDE.ESTADO = 'Activo';
        
    CURSOR C_ValidarAccion(Cn_IdAccion  NUMBER,
                           Cv_Estado    VARCHAR2 DEFAULT 'Activo')
    IS
      SELECT SA.*
      FROM DB_SEGURIDAD.SIST_ACCION SA
      WHERE SA.ID_ACCION = Cn_IdAccion
        AND SA.ESTADO = Cv_Estado;
   
    CURSOR C_CaracteristicaServicio3dEYE(Cn_IdServicio   NUMBER,
                                         Cv_Caract3DEYE  VARCHAR2,
                                         Cv_Estado       VARCHAR2 DEFAULT 'Activo')
    IS
      SELECT ISPC.ID_SERVICIO_PROD_CARACT AS ID_PROD_CARACT, ISPC.VALOR AS VALOR_PROD_CARACT
      FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC,
           DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
           DB_COMERCIAL.ADMI_CARACTERISTICA AC,
           DB_COMERCIAL.ADMI_PRODUCTO AP
      WHERE ISPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
        AND APC.CARACTERISTICA_ID = AC.ID_CARACTERISTICA
        AND APC.PRODUCTO_ID = AP.ID_PRODUCTO
        AND AP.NOMBRE_TECNICO = 'CAMARA IP'
        AND AC.DESCRIPCION_CARACTERISTICA = Cv_Caract3DEYE
        AND ISPC.ESTADO = Cv_Estado
        AND ISPC.SERVICIO_ID = Cn_IdServicio;
        
    CURSOR C_CaracteristicaPunto3dEYE(Cn_IdPunto      NUMBER,
                                      Cv_Caract3DEYE  VARCHAR2,
                                      Cv_Estado       VARCHAR2 DEFAULT 'Activo')
    IS
      SELECT IPC.ID_PUNTO_CARACTERISTICA AS ID_CARACT_PUNTO, IPC.VALOR AS VALOR_CARACT_PUNTO
      FROM DB_COMERCIAL.INFO_PUNTO_CARACTERISTICA IPC, DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE IPC.CARACTERISTICA_ID = AC.ID_CARACTERISTICA
        AND AC.DESCRIPCION_CARACTERISTICA = Cv_Caract3DEYE
        AND IPC.PUNTO_ID = Cn_IdPunto
        AND IPC.ESTADO = Cv_Estado;
    
    Lc_ParametrosPortal3DEYE  C_ParametrosPortal3DEYE%ROWTYPE;
    Lc_Usuario3DEYE           C_CaracteristicaServicio3dEYE%ROWTYPE;
    Lc_Rol3DEYE               C_CaracteristicaServicio3dEYE%ROWTYPE;
    Lc_Camara3DEYE            C_CaracteristicaServicio3dEYE%ROWTYPE;
    Lc_Rol3DEYEPunto          C_CaracteristicaPunto3dEYE%Rowtype;
    Lc_Servicio               C_ValidarServicio%ROWTYPE;
    Lc_Accion                 C_ValidarAccion%ROWTYPE;
    Lv_Token3DEYE             VARCHAR2(4000);
    ln_NumServiciosNetCam     NUMBER;
    Lc_InfoGeneralCancel      C_InfoGeneralCancelacion%ROWTYPE;
    Lb_EliminarCam            BOOLEAN;
    Lb_EliminarRol            BOOLEAN;
    Lcl_RollAgregarCam        CLOB;
    Lcl_RollAgregarRol        CLOB;
    Lcl_ListaUsersByRol       CLOB;
    Lv_MacCamara              VARCHAR2(2000);
    Lv_TipoActivacion         VARCHAR2(2000);
    Lv_CodigoPush             VARCHAR2(2000);
    Lv_UrlHTTP                VARCHAR2(2000);
    Ln_PuertoHTTP             NUMBER;
    Ln_PuertoRTSP             NUMBER;
    Lv_UrlRTSP                VARCHAR2(2000);
    Lv_DeviceBrand            VARCHAR2(500);
    Lv_AdminUser              VARCHAR2(500);
    Lv_AdminPass              VARCHAR2(500);
    Lv_Status                 VARCHAR2(100);
    Lv_Mensaje                VARCHAR2(1000);
    Ln_IdNuevaCamaraRoll      NUMBER;
    Ln_IdNuevoRolRoll         NUMBER;
    Lb_RollAsignarCamRol      BOOLEAN;
    Lb_RollAsignarUserRol     BOOLEAN;
    Ln_CountUsers             NUMBER;
    Lv_IdUserRol              VARCHAR2(3000);
    Lar_ListaUsers            DBMS_SQL.Varchar2_Table;
    Lb_RemoverUserRol         BOOLEAN;
    Ln_count                  PLS_INTEGER;
    Lcl_DatosCamara           CLOB;
    Ln_IdCam                  NUMBER;
    Ln_IdRol                  NUMBER;
    Le_Errors                 EXCEPTION;
  BEGIN
    -- INICIO VALIDACIONES GLOBALES
    OPEN  C_ParametrosPortal3DEYE;
    FETCH C_ParametrosPortal3DEYE INTO Lc_ParametrosPortal3DEYE;
    CLOSE C_ParametrosPortal3DEYE;
    
    IF Lc_ParametrosPortal3DEYE.USERNAME IS NULL OR 
        Lc_ParametrosPortal3DEYE.PASSWORD IS NULL OR
        Lc_ParametrosPortal3DEYE.API_KEY IS NULL THEN
      Pv_Mensaje := 'No se encuentran completos los par�metros del customer del portal 3dEYE';
      RAISE Le_Errors;  
    END IF;
    
    IF Pn_IdServicio IS NULL THEN
      Pv_Mensaje := 'El campo Pn_IdServicio esta vac�o';
      RAISE Le_Errors;
    END IF;
    
    OPEN  C_ValidarServicio(Pn_IdServicio);
    FETCH C_ValidarServicio INTO Lc_Servicio;
    CLOSE C_ValidarServicio;
    
    IF Lc_Servicio.Id_Servicio IS NULL THEN
      Pv_Mensaje := 'El servicio '||Pn_IdServicio||' no existe o no se puede cancelar';
      RAISE Le_Errors;
    END IF;
    
    IF Pn_IdAccion IS NULL THEN
      Pv_Mensaje := 'El campo Pn_IdAccion esta vac�o';
      RAISE Le_Errors;
    END IF;
    
    OPEN  C_ValidarAccion(Pn_IdAccion);
    FETCH C_ValidarAccion INTO Lc_Accion;
    CLOSE C_ValidarAccion;
    
    IF Lc_Accion.ID_ACCION IS NULL THEN
      Pv_Mensaje := 'La acci�n '||Pn_IdAccion||' no existe o no se encuentra Activo';
      RAISE Le_Errors;
    END IF;
    
    IF Lc_Accion.Nombre_Accion != 'cancelarCliente' THEN
      Pv_Mensaje := 'La acci�n '||Pn_IdAccion||' no esta relacionada con cancelarCliente';
      RAISE Le_Errors;
    END IF;
    -- FIN VALIDACIONES GLOBALES
    -- OBTENGO EL ID USUARIO 3DEYE
    OPEN  C_CaracteristicaServicio3dEYE(Pn_IdServicio,
                                   'USER 3DEYE');
    FETCH C_CaracteristicaServicio3dEYE INTO Lc_Usuario3DEYE;
    CLOSE C_CaracteristicaServicio3dEYE;
    
    IF Lc_Usuario3DEYE.VALOR_PROD_CARACT IS NULL THEN
      Pv_Mensaje := 'No existe el USER 3dEYE del servicio '||Pn_IdServicio;
      RAISE Le_Errors;
    END IF;
    
    -- OBTENGO EL ID ROL 3DEYE SERVICIO
    OPEN  C_CaracteristicaServicio3dEYE(Pn_IdServicio,
                                   'ROL 3DEYE');
    FETCH C_CaracteristicaServicio3dEYE INTO Lc_Rol3DEYE;
    CLOSE C_CaracteristicaServicio3dEYE;
    
    IF Lc_Rol3DEYE.VALOR_PROD_CARACT IS NULL THEN
      Pv_Mensaje := 'No existe el ROL 3dEYE del servicio '||Pn_IdServicio;
      RAISE Le_Errors;
    END IF;
    
    -- OBTENGO EL ID CAMARA 3DEYE
    OPEN  C_CaracteristicaServicio3dEYE(Pn_IdServicio,
                                   'CAMARA 3DEYE');
    FETCH C_CaracteristicaServicio3dEYE INTO Lc_Camara3DEYE;
    CLOSE C_CaracteristicaServicio3dEYE;
    
    IF Lc_Camara3DEYE.VALOR_PROD_CARACT IS NULL THEN
      Pv_Mensaje := 'No existe la CAMARA 3dEYE del servicio '||Pn_IdServicio;
      RAISE Le_Errors;
    END IF;
  
    -- OBTENGO INFORMACION GENERAL PARA LA CANCELACION
    OPEN  C_InfoGeneralCancelacion(Pn_IdServicio);
    FETCH C_InfoGeneralCancelacion INTO Lc_InfoGeneralCancel;
    CLOSE C_InfoGeneralCancelacion;
    
    IF Lc_InfoGeneralCancel.Id_Punto IS NULL THEN
      Pv_Mensaje := 'No se encuentra el punto del servicio';
      RAISE Le_Errors;
    END IF;
    
    -- OBTENGO EL ID ROL 3DEYE PUNTO
    OPEN  C_CaracteristicaPunto3dEYE(Lc_InfoGeneralCancel.Id_Punto,
                                     'ROL 3DEYE');
    FETCH C_CaracteristicaPunto3dEYE INTO Lc_Rol3DEYEPunto;
    CLOSE C_CaracteristicaPunto3dEYE;
    
    IF Lc_Rol3DEYEPunto.Valor_Caract_Punto IS NULL THEN
      Pv_Mensaje := 'No existe el ROL 3dEYE en el punto '||Lc_InfoGeneralCancel.Id_Punto;
      RAISE Le_Errors;
    END IF;
    
    -- OBTENGO NUMERO DE SERVICIOS NETCAM DEL PUNTO
    OPEN  C_CountServiceNetCamPunto(Lc_InfoGeneralCancel.Id_Punto);
    FETCH C_CountServiceNetCamPunto INTO ln_NumServiciosNetCam;
    CLOSE C_CountServiceNetCamPunto;
    
    -- OBTENGO LA INFORMACION DE LA CAMARA
    FOR detalle IN C_DetalleElemento(Lc_InfoGeneralCancel.Id_Elemento) LOOP
      -- PROCESAMIENTO PARA RECUPERAR VARIABLES DE LA CAMARA TIPO_ACTIVACION_CAMARA*/
      CASE detalle.detalle_nombre
        WHEN 'MAC_CAMARA' THEN
          Lv_MacCamara      := detalle.detalle_valor;
        WHEN 'TIPO_ACTIVACION_CAMARA' THEN
          Lv_TipoActivacion := detalle.detalle_valor;
        WHEN 'USER_CAMARA' THEN
          Lv_AdminUser      := detalle.detalle_valor;
        WHEN 'PASS_CAMARA' THEN
          Lv_AdminPass      := detalle.detalle_valor;
        WHEN 'CODIGO_PUSH_CAMARA' THEN
          Lv_CodigoPush     := detalle.detalle_valor;
        WHEN 'DDNS_CAMARA' THEN
          Lv_UrlHTTP        := detalle.detalle_valor;
        WHEN 'PUERTO_HTTP_CAMARA' THEN
          Ln_PuertoHTTP     := detalle.detalle_valor;
        WHEN 'PUERTO_RTSP_CAMARA' THEN
          Ln_PuertoRTSP     := detalle.detalle_valor; 
        WHEN 'RTSP_CAMARA' THEN
          Lv_UrlRTSP        := detalle.detalle_valor;
        WHEN 'FABRICANTE_CAMARA' THEN
          Lv_DeviceBrand    := detalle.detalle_valor;
        ELSE
          Pv_Mensaje := 'No se encuentra definido el detalle '||detalle.detalle_nombre;
          RAISE Le_Errors;
      END CASE;
    END LOOP;
    
    -- OBTENGO EL TOKEN PARA LAS TRANSACCIONES
    Lv_Token3DEYE := DB_COMERCIAL.CMKG_NETCAM.F_GENERATE_TOKEN(Lc_ParametrosPortal3DEYE.USERNAME,
                                                               Lc_ParametrosPortal3DEYE.PASSWORD,
                                                               Lc_ParametrosPortal3DEYE.API_KEY);
    IF Lv_Token3DEYE IS NULL THEN
      Pv_Mensaje := 'Existe un problema al generar el token en el portal 3dEYE';
      RAISE Le_Errors;
    END IF;
    
    Lv_Token3DEYE := 'Bearer '||Lv_Token3DEYE;
    
    /* PROCESO DE CANCELACION EN EL PORTAL 3DEYE, SI ES 1 ELIMINA LA CAMARA Y ROL, SI ES MAYOR
    A 1 SE ELIMINA LA CAMARA */
    IF ln_NumServiciosNetCam = 1 THEN
      -- ELIMINO LA CAMARA
      Lb_EliminarCam := DB_COMERCIAL.CMKG_NETCAM.F_ELIMINAR_CAM(Lc_Camara3DEYE.VALOR_PROD_CARACT,
                                                                Lc_ParametrosPortal3DEYE.API_KEY,
                                                                Lv_Token3DEYE);                                                         
      IF NOT Lb_EliminarCam THEN
        -- VALIDAR SI EXISTE LA CAMARA
        DB_COMERCIAL.CMKG_NETCAM.P_VALIDAR_CAM(Lc_InfoGeneralCancel.Nombre_Elemento,
                                               Lc_ParametrosPortal3DEYE.Api_Key,
                                               Lv_Token3DEYE,
                                               Lv_Status,
                                               Lv_Mensaje,
                                               Ln_IdCam);
        IF Ln_IdCam = 0 OR Ln_IdCam IS NULL THEN
          Lb_EliminarCam := TRUE; 
        END IF;                                              
        Pv_Mensaje := 'No se pudo eliminar la c�mara en el portal 3dEYE';
        RAISE Le_Errors;
      END IF;
      -- REMOVER LOS USUARIOS DEL ROL
      DB_COMERCIAL.CMKG_NETCAM.P_LISTA_USERS_BY_ROL(Lc_Rol3DEYE.VALOR_PROD_CARACT,
                                                    Lc_ParametrosPortal3DEYE.Api_Key,
                                                    Lv_Token3DEYE,
                                                    Lv_Status,
                                                    Lv_Mensaje,
                                                    Lcl_ListaUsersByRol);                                              
      IF Lv_Status = 'OK' THEN
        APEX_JSON.PARSE(Lcl_ListaUsersByRol);
        Ln_CountUsers := APEX_JSON.GET_COUNT(P_PATH => 'users');
        IF Ln_CountUsers > 0 THEN
          FOR I IN 1 .. Ln_CountUsers LOOP
            APEX_JSON.PARSE(Lcl_ListaUsersByRol);
            Lv_IdUserRol := APEX_JSON.get_varchar2(p_path => 'users[%d].id',  p0 => I);
            Lb_RemoverUserRol := DB_COMERCIAL.CMKG_NETCAM.F_REMOVER_USER_ROL(Lv_IdUserRol,
                                                                             Lc_Rol3DEYE.VALOR_PROD_CARACT,
                                                                             Lc_ParametrosPortal3DEYE.API_KEY,
                                                                             Lv_Token3DEYE);
            IF NOT Lb_RemoverUserRol THEN
              Pv_Status := 'ERROR';
              Pv_Mensaje := 'No se pudo remover el usuario del rol en el portal 3dEYE';
              RAISE Le_Errors;
            END IF;
            Lar_ListaUsers(I) := Lv_IdUserRol;
          END LOOP;
        END IF;
        -- ELIMINO LA CARACTERISTICA ROL 3DEYE EN EL PUNTO
        UPDATE DB_COMERCIAL.INFO_PUNTO_CARACTERISTICA IPC
        SET
          IPC.ESTADO = 'Eliminado',
          IPC.FE_ULT_MOD = SYSDATE,
          IPC.USR_ULT_MOD = NVL(Pv_User, 'telcos')
        WHERE IPC.ID_PUNTO_CARACTERISTICA = Lc_Rol3DEYEPunto.Id_Caract_Punto;
      ELSE
        RAISE Le_Errors;
      END IF;
       
      -- ELIMINO EL ROL
      Lb_EliminarRol := DB_COMERCIAL.CMKG_NETCAM.F_ELIMINAR_ROL(Lc_Rol3DEYE.VALOR_PROD_CARACT,
                                                                Lc_ParametrosPortal3DEYE.API_KEY,
                                                                Lv_Token3DEYE);                                                         
      IF NOT Lb_EliminarRol THEN
        -- VALIDAR SI EXISTE EL ROL
        DB_COMERCIAL.CMKG_NETCAM.P_VALIDAR_ROL(Lc_InfoGeneralCancel.Login,
                                               Lc_ParametrosPortal3DEYE.Api_Key,
                                               Lv_Token3DEYE,
                                               Lv_Status,
                                               Lv_Mensaje,
                                               Ln_IdRol);
        IF Ln_IdRol = 0 OR Ln_IdRol IS NULL THEN
          Lb_EliminarRol := TRUE; 
        END IF;   
        Pv_Mensaje := 'No se pudo eliminar el rol en el portal 3dEYE';
        RAISE Le_Errors;
      END IF;
    ELSIF ln_NumServiciosNetCam > 1 THEN
      -- ELIMINO LA CAMARA
      Lb_EliminarCam := DB_COMERCIAL.CMKG_NETCAM.F_ELIMINAR_CAM(Lc_Camara3DEYE.VALOR_PROD_CARACT,
                                                                Lc_ParametrosPortal3DEYE.API_KEY,
                                                                Lv_Token3DEYE);                                                         
      IF NOT Lb_EliminarCam THEN
        -- VALIDAR SI EXISTE LA CAMARA
        DB_COMERCIAL.CMKG_NETCAM.P_VALIDAR_CAM(Lc_InfoGeneralCancel.Nombre_Elemento,
                                               Lc_ParametrosPortal3DEYE.Api_Key,
                                               Lv_Token3DEYE,
                                               Lv_Status,
                                               Lv_Mensaje,
                                               Ln_IdCam);
        IF Ln_IdCam = 0 OR Ln_IdCam IS NULL THEN
          Lb_EliminarCam := TRUE; 
        END IF;
        Pv_Mensaje := 'No se pudo eliminar la c�mara en el portal 3dEYE';
        RAISE Le_Errors;
      END IF;
    ELSE 
      Pv_Mensaje := 'No existen servicios NetCam en el punto '||Lc_InfoGeneralCancel.Id_Punto;
      RAISE Le_Errors;
    END IF;
    
    -- ACTUALIZAR SERVICIO EN TELCOS
    DB_COMERCIAL.CMKG_NETCAM.P_CAMBIO_SERVICIO_ESTADO(Pn_IdServicio,
                                                      Pn_IdAccion,
                                                      'CANCELACION',
                                                      NULL,
                                                      Pv_EsMasivo,
                                                      Pv_User,
                                                      Pv_Status,
                                                      Pv_Mensaje);
    
    IF Pv_Status != 'OK' THEN
      Pv_Mensaje := 'Ha ocurrido un problema. Por favor notifique a Sistemas!';
      RAISE Le_Errors;
    END IF;
  
    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transacci�n exitosa';
    COMMIT;
  EXCEPTION
    WHEN Le_Errors THEN
      ROLLBACK;
      -- ROLLBACK 3DEYE
      Pv_Status := 'ERROR';
      -- ROLLBACK CAM
      IF Lv_Token3DEYE IS NOT NULL AND Lv_TipoActivacion IS NOT NULL THEN
        IF Lb_EliminarCam THEN
          IF Lv_TipoActivacion = 'P2P' THEN
            DB_COMERCIAL.CMKG_NETCAM.P_CREAR_CAM_P2P(Lc_InfoGeneralCancel.Nombre_Elemento,
                                                     Lv_CodigoPush,
                                                     Lv_AdminUser,
                                                     Lv_AdminPass,
                                                     Lc_ParametrosPortal3DEYE.Api_Key,
                                                     Lv_Token3DEYE,
                                                     Lv_Status,
                                                     Lv_Mensaje,
                                                     Lcl_RollAgregarCam);     
          ELSIF Lv_TipoActivacion = 'ONVIF' THEN
            APEX_JSON.INITIALIZE_CLOB_OUTPUT;
            APEX_JSON.OPEN_OBJECT;
            APEX_JSON.WRITE('Pv_NombreCam', Lc_InfoGeneralCancel.Nombre_Elemento);
            APEX_JSON.WRITE('Pv_UrlHTTP', Lv_UrlHTTP);
            APEX_JSON.WRITE('Pn_PuertoHTTP', Ln_PuertoHTTP);
            APEX_JSON.WRITE('Pn_PuertoRTSP', Ln_PuertoRTSP);
            APEX_JSON.WRITE('Pv_AdminUser', Lv_AdminUser);
            APEX_JSON.WRITE('Pv_AdminPass', Lv_AdminPass);
            APEX_JSON.CLOSE_OBJECT;
            Lcl_DatosCamara := APEX_JSON.GET_CLOB_OUTPUT;
            DB_COMERCIAL.CMKG_NETCAM.P_CREAR_CAM_ONVIF(Lcl_DatosCamara,
                                                       Lc_ParametrosPortal3DEYE.Api_Key,
                                                       Lv_Token3DEYE,
                                                       Lv_Status,
                                                       Lv_Mensaje,
                                                       Lcl_RollAgregarCam); 
          ELSE
            APEX_JSON.INITIALIZE_CLOB_OUTPUT;
            APEX_JSON.OPEN_OBJECT;
            APEX_JSON.WRITE('Pv_NombreCam', Lc_InfoGeneralCancel.Nombre_Elemento);
            APEX_JSON.WRITE('Pv_UrlHTTP', Lv_UrlHTTP);
            APEX_JSON.WRITE('Pn_PuertoHTTP', Ln_PuertoHTTP);
            APEX_JSON.WRITE('Pv_UrlRTSP', Lv_UrlRTSP);
            APEX_JSON.WRITE('Pn_PuertoRTSP', Ln_PuertoRTSP);
            APEX_JSON.WRITE('Pv_DeviceBrand', Lv_DeviceBrand);
            APEX_JSON.WRITE('Pv_AdminUser', Lv_AdminUser);
            APEX_JSON.WRITE('Pv_AdminPass', Lv_AdminPass);
            APEX_JSON.CLOSE_OBJECT;
            Lcl_DatosCamara := APEX_JSON.GET_CLOB_OUTPUT; 
            DB_COMERCIAL.CMKG_NETCAM.P_CREAR_CAM_GENERIC(Lcl_DatosCamara,
                                                         Lc_ParametrosPortal3DEYE.Api_Key,
                                                         Lv_Token3DEYE,
                                                         Lv_Status,
                                                         Lv_Mensaje,
                                                         Lcl_RollAgregarCam);
          END IF;
          
          IF Lv_Status = 'OK' THEN
            APEX_JSON.PARSE(Lcl_RollAgregarCam);
            Ln_IdNuevaCamaraRoll  := APEX_JSON.get_number(p_path => 'id');
            UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC
            SET
              ISPC.VALOR       = LN_IDNUEVACAMARAROLL,
              ISPC.USR_ULT_MOD = NVL(PV_USER, 'telcos'),
              ISPC.FE_ULT_MOD  = SYSDATE
            WHERE ISPC.ID_SERVICIO_PROD_CARACT = LC_CAMARA3DEYE.ID_PROD_CARACT;
            Lc_Camara3DEYE.Valor_Prod_Caract := Ln_IdNuevaCamaraRoll;
            
            IF ln_NumServiciosNetCam = 1 AND Lb_EliminarRol THEN
              -- ROLLBACK ROL
              DB_COMERCIAL.CMKG_NETCAM.P_CREAR_ROL(Lc_InfoGeneralCancel.Login,
                                                   'Contenedor de c�maras del login '||Lc_InfoGeneralCancel.Login,
                                                   'Guard',
                                                   Lc_ParametrosPortal3DEYE.Api_Key,
                                                   Lv_Token3DEYE,
                                                   Lv_Status,
                                                   Lv_Mensaje,
                                                   Lcl_RollAgregarRol); 
              
              IF Lv_Status = 'OK' THEN
                APEX_JSON.PARSE(Lcl_RollAgregarRol);
                Ln_IdNuevoRolRoll  := APEX_JSON.get_number(p_path => 'id');
                UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC
                SET
                  ISPC.VALOR = Ln_IdNuevoRolRoll,
                  ISPC.USR_ULT_MOD = NVL(Pv_User, 'telcos'),
                  ISPC.FE_ULT_MOD = SYSDATE
                WHERE ISPC.ID_SERVICIO_PROD_CARACT = Lc_Rol3DEYE.Id_Prod_Caract;
                Lc_Rol3DEYE.VALOR_PROD_CARACT := Ln_IdNuevoRolRoll;
              ELSE
                Pv_Mensaje  := 'No se pudo realizar el respectivo rollback en el portal 3dEYE, comunicarse con Sistemas!';
              END IF;
            END IF;
            
            IF Lar_ListaUsers.COUNT > 0 THEN
              Ln_count := Lar_ListaUsers.FIRST;
              WHILE (Ln_count IS NOT NULL) LOOP
                -- ROLLBACK ASIGNAR USUARIOS AL ROL
                Lb_RollAsignarUserRol := DB_COMERCIAL.CMKG_NETCAM.F_ASIGNAR_USER_ROL(Lar_ListaUsers(Ln_count),
                                                                                     Lc_Rol3DEYE.VALOR_PROD_CARACT,
                                                                                     Lc_ParametrosPortal3DEYE.API_KEY,
                                                                                     Lv_Token3DEYE);
                IF NOT Lb_RollAsignarUserRol THEN
                  Pv_Mensaje  := 'No se pudo realizar el respectivo rollback en el portal 3dEYE, comunicarse con Sistemas!';
                END IF;
                Ln_count := Lar_ListaUsers.NEXT(Ln_count);
              END LOOP;
            END IF;   
          ELSE
            Pv_Mensaje  := 'No se pudo realizar el respectivo rollback en el portal 3dEYE, comunicarse con Sistemas!';
          END IF;
        END IF;   
            
        IF Lc_Servicio.Estado = 'Activo' THEN
          Lb_RollAsignarCamRol := DB_COMERCIAL.CMKG_NETCAM.F_ASIGNAR_CAM_ROL(Lc_Camara3DEYE.Valor_Prod_Caract,
                                                                             Lc_Rol3DEYE.VALOR_PROD_CARACT,
                                                                             Lc_ParametrosPortal3DEYE.API_KEY,
                                                                             Lv_Token3DEYE);
          IF NOT Lb_RollAsignarCamRol THEN
            Pv_Mensaje  := 'No se pudo realizar el respectivo rollback en el portal 3dEYE, comunicarse con Sistemas!';
          END IF;
        END IF;          
        COMMIT;          
      END IF;
      
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CANCELACION SERVICIO NETCAM', 
                                           'CMKG_NETCAM.P_CANCELACION_SERVICIO_NETCAM',
                                           Pv_Mensaje,
                                           NVL(Pv_User, 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
    WHEN OTHERS THEN
      ROLLBACK;
      -- ROLLBACK 3DEYE
      Pv_Status := 'ERROR';
      -- ROLLBACK CAM
      IF Lv_Token3DEYE IS NOT NULL AND Lv_TipoActivacion IS NOT NULL THEN
        IF Lb_EliminarCam THEN
          IF Lv_TipoActivacion = 'P2P' THEN
            DB_COMERCIAL.CMKG_NETCAM.P_CREAR_CAM_P2P(Lc_InfoGeneralCancel.Nombre_Elemento,
                                                     Lv_CodigoPush,
                                                     Lv_AdminUser,
                                                     Lv_AdminPass,
                                                     Lc_ParametrosPortal3DEYE.Api_Key,
                                                     Lv_Token3DEYE,
                                                     Lv_Status,
                                                     Lv_Mensaje,
                                                     Lcl_RollAgregarCam);     
          ELSIF Lv_TipoActivacion = 'ONVIF' THEN
            APEX_JSON.INITIALIZE_CLOB_OUTPUT;
            APEX_JSON.OPEN_OBJECT;
            APEX_JSON.WRITE('Pv_NombreCam', Lc_InfoGeneralCancel.Nombre_Elemento);
            APEX_JSON.WRITE('Pv_UrlHTTP', Lv_UrlHTTP);
            APEX_JSON.WRITE('Pn_PuertoHTTP', Ln_PuertoHTTP);
            APEX_JSON.WRITE('Pn_PuertoRTSP', Ln_PuertoRTSP);
            APEX_JSON.WRITE('Pv_AdminUser', Lv_AdminUser);
            APEX_JSON.WRITE('Pv_AdminPass', Lv_AdminPass);
            APEX_JSON.CLOSE_OBJECT;
            Lcl_DatosCamara := APEX_JSON.GET_CLOB_OUTPUT;
            DB_COMERCIAL.CMKG_NETCAM.P_CREAR_CAM_ONVIF(Lcl_DatosCamara,
                                                       Lc_ParametrosPortal3DEYE.Api_Key,
                                                       Lv_Token3DEYE,
                                                       Lv_Status,
                                                       Lv_Mensaje,
                                                       Lcl_RollAgregarCam); 
          ELSE
            APEX_JSON.INITIALIZE_CLOB_OUTPUT;
            APEX_JSON.OPEN_OBJECT;
            APEX_JSON.WRITE('Pv_NombreCam', Lc_InfoGeneralCancel.Nombre_Elemento);
            APEX_JSON.WRITE('Pv_UrlHTTP', Lv_UrlHTTP);
            APEX_JSON.WRITE('Pn_PuertoHTTP', Ln_PuertoHTTP);
            APEX_JSON.WRITE('Pv_UrlRTSP', Lv_UrlRTSP);
            APEX_JSON.WRITE('Pn_PuertoRTSP', Ln_PuertoRTSP);
            APEX_JSON.WRITE('Pv_DeviceBrand', Lv_DeviceBrand);
            APEX_JSON.WRITE('Pv_AdminUser', Lv_AdminUser);
            APEX_JSON.WRITE('Pv_AdminPass', Lv_AdminPass);
            APEX_JSON.CLOSE_OBJECT;
            Lcl_DatosCamara := APEX_JSON.GET_CLOB_OUTPUT; 
            DB_COMERCIAL.CMKG_NETCAM.P_CREAR_CAM_GENERIC(Lcl_DatosCamara,
                                                         Lc_ParametrosPortal3DEYE.Api_Key,
                                                         Lv_Token3DEYE,
                                                         Lv_Status,
                                                         Lv_Mensaje,
                                                         Lcl_RollAgregarCam);
          END IF;

          IF Lv_Status = 'OK' THEN
            APEX_JSON.PARSE(Lcl_RollAgregarCam);
            Ln_IdNuevaCamaraRoll  := APEX_JSON.get_number(p_path => 'id');
            UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC
            SET
              ISPC.VALOR       = LN_IDNUEVACAMARAROLL,
              ISPC.USR_ULT_MOD = NVL(PV_USER, 'telcos'),
              ISPC.FE_ULT_MOD  = SYSDATE
            WHERE ISPC.ID_SERVICIO_PROD_CARACT = LC_CAMARA3DEYE.ID_PROD_CARACT;
            Lc_Camara3DEYE.Valor_Prod_Caract := Ln_IdNuevaCamaraRoll;
            
            IF ln_NumServiciosNetCam = 1 AND Lb_EliminarRol THEN
              -- ROLLBACK ROL
              DB_COMERCIAL.CMKG_NETCAM.P_CREAR_ROL(Lc_InfoGeneralCancel.Login,
                                                   'Contenedor de c�maras del login '||Lc_InfoGeneralCancel.Login,
                                                   'Guard',
                                                   Lc_ParametrosPortal3DEYE.Api_Key,
                                                   Lv_Token3DEYE,
                                                   Lv_Status,
                                                   Lv_Mensaje,
                                                   Lcl_RollAgregarRol); 
              
              IF Lv_Status = 'OK' THEN
                APEX_JSON.PARSE(Lcl_RollAgregarRol);
                Ln_IdNuevoRolRoll  := APEX_JSON.get_number(p_path => 'id');
                UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC
                SET
                  ISPC.VALOR = Ln_IdNuevoRolRoll,
                  ISPC.USR_ULT_MOD = NVL(Pv_User, 'telcos'),
                  ISPC.FE_ULT_MOD = SYSDATE
                WHERE ISPC.ID_SERVICIO_PROD_CARACT = Lc_Rol3DEYE.Id_Prod_Caract;
                Lc_Rol3DEYE.VALOR_PROD_CARACT := Ln_IdNuevoRolRoll;
              ELSE
                Pv_Mensaje  := 'No se pudo realizar el respectivo rollback en el portal 3dEYE, comunicarse con Sistemas!';
              END IF;
            END IF;
            
            IF Lar_ListaUsers.COUNT > 0 THEN
              Ln_count := Lar_ListaUsers.FIRST;
              WHILE (Ln_count IS NOT NULL) LOOP
                -- ROLLBACK ASIGNAR USUARIOS AL ROL
                Lb_RollAsignarUserRol := DB_COMERCIAL.CMKG_NETCAM.F_ASIGNAR_USER_ROL(Lar_ListaUsers(Ln_count),
                                                                                     Lc_Rol3DEYE.VALOR_PROD_CARACT,
                                                                                     Lc_ParametrosPortal3DEYE.API_KEY,
                                                                                     Lv_Token3DEYE);
                IF NOT Lb_RollAsignarUserRol THEN
                  Pv_Mensaje  := 'No se pudo realizar el respectivo rollback en el portal 3dEYE, comunicarse con Sistemas!';
                END IF;
                Ln_count := Lar_ListaUsers.NEXT(Ln_count);
              END LOOP;
            END IF;    
          ELSE
            Pv_Mensaje  := 'No se pudo realizar el respectivo rollback en el portal 3dEYE, comunicarse con Sistemas!';
          END IF;
        END IF;   
            
        IF Lc_Servicio.Estado = 'Activo' THEN
          Lb_RollAsignarCamRol := DB_COMERCIAL.CMKG_NETCAM.F_ASIGNAR_CAM_ROL(Lc_Camara3DEYE.Valor_Prod_Caract,
                                                                             Lc_Rol3DEYE.VALOR_PROD_CARACT,
                                                                             Lc_ParametrosPortal3DEYE.API_KEY,
                                                                             Lv_Token3DEYE);
          IF NOT Lb_RollAsignarCamRol THEN
            Pv_Mensaje  := 'No se pudo realizar el respectivo rollback en el portal 3dEYE, comunicarse con Sistemas!';
          END IF;
        END IF;          
        COMMIT;          
      END IF;
      
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CANCELACION SERVICIO NETCAM', 
                                           'CMKG_NETCAM.P_CANCELACION_SERVICIO_NETCAM',
                                           SQLERRM,
                                           NVL(Pv_User, 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
  
  END P_CANCELACION_SERVICIO_NETCAM;
  
end CMKG_NETCAM;
/