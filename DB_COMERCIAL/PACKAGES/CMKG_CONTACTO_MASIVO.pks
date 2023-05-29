CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_CONTACTO_MASIVO AS

    /**
     * Documentación Para CMKG_CONTACTO_MASIVO
     * Paquete que contiene procedimientos y funciones para la administración masiva de contactos
     *
     * @Author Christian Jaramillo Espinoza <cjaramilloe@telconet.ec>
     * @Version 1.0 18/10/2019
    */

    /*
    *  Types Del Paquete
    */
    TYPE T_Array_Id IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
    TYPE T_Array_Ip IS TABLE OF DB_COMERCIAL.INFO_PERSONA%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE T_Array_Ipun IS TABLE OF DB_COMERCIAL.INFO_PUNTO%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE T_Array_Iper IS TABLE OF DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE T_Array_Iperh IS TABLE OF DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE T_Array_Iperc IS TABLE OF DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE T_Array_Ipercont IS TABLE OF DB_COMERCIAL.INFO_PERSONA_CONTACTO%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE T_Array_Ipuncont IS TABLE OF DB_COMERCIAL.INFO_PUNTO_CONTACTO%ROWTYPE INDEX BY BINARY_INTEGER;

    /**
     *
     * Procedimiento que realiza la creación masiva de contactos a nivel puntos y/o cliente
     *
     * Costo Del Query C_GetDescripcionRol: 3
     * Costo Del Query C_GetCaracPorDesc:   2
     *
     * @Author Christian Jaramillo Espinoza <cjaramilloe@telconet.ec>
     * @Version 1.0 18/10/2019
     *
     * @Author David León <mdleon@telconet.ec>
     * @Version 1.1 07/07/2022 - Se modifica el proceso para guardar una sola vez en la tabla de INFO_PERSONA_EMPRESA_ROL.
     *
     * @PARAM Pcl_Idroles           IN CLOB     Id De Roles Del Contacto Concatenados
     * @PARAM Pcl_Idpuntos          IN CLOB     Id De Puntos Concatenados
     * @PARAM Pcl_Extraparams       IN CLOB     Parámetros extras
     **** @PARAM intIdOficina          NUMBER   Id De Oficina
     **** @PARAM strCodEmpresa         VARCHAR2 Id De Empresa
     **** @PARAM strUsuario            VARCHAR2 Usuario Creador
     **** @PARAM strIp                 VARCHAR2 Ip Creador
     **** @PARAM strDescripcionRol1    VARCHAR2 Parámetro Adicional, Descripción De Rol
     **** @PARAM strDescripcionCarac1  VARCHAR2 Parámetro Adicional, Descripción De Característica
     **** @PARAM strDescripcionCarac2  VARCHAR2 Parámetro Adicional, Descripción De Característica
     * @PARAM Pn_Idcliente          IN NUMBER   Id Del Cliente
     * @PARAM Pn_Idpersona          IN NUMBER   Id Del Contacto
     * @PARAM Pn_Nivel_Cliente      IN NUMBER   Flag Que Indica Si Se Debe Crear A Nivel Cliente
     * @PARAM Pv_Msgerror           OUT VARCHAR2 Mensaje De Error General Si Existiese
     *
     **/

    PROCEDURE P_CREAR_MASIVO(Pcl_Idroles       IN CLOB,
                             Pcl_Idpuntos      IN CLOB,
                             Pcl_Extraparams   IN CLOB,
                             Pn_Idcliente      IN NUMBER,
                             Pn_Idpersona      IN NUMBER,
                             Pn_Nivel_Cliente  IN NUMBER,
                             Pv_Msgerror       OUT VARCHAR2);

    /**
     * Procedimiento que realiza la asignación masiva de roles de contacto a nivel puntos y/o cliente
     *
     * Costo Del Query C_GetDescripcionRol:      2
     * Costo Del Query C_GetPuntosPorEmpresaRol: 1414
     * Costo Del Query C_GetCaracPorDesc:        2
     *
     * @Author Christian Jaramillo Espinoza <cjaramilloe@telconet.ec>
     * @Version 1.0 23/10/2019
     *
     * @Author David León <mdleon@telconet.ec>
     * @Version 1.1 07/07/2022 - Se modifica el proceso para guardar una sola vez en la tabla de INFO_PERSONA_EMPRESA_ROL.
     *
     * @PARAM Pcl_Idroles            IN CLOB     Id De Roles Del Contacto Concatenados
     * @PARAM Pcl_Extraparams        IN CLOB     Parámetros extras
     **** @PARAM intIdOficina          NUMBER   Id De Oficina
     **** @PARAM strCodEmpresa         VARCHAR2 Id De Empresa
     **** @PARAM strUsuario            VARCHAR2 Usuario Creador
     **** @PARAM strIp                 VARCHAR2 Ip Creador
     **** @PARAM strDescripcionRol1    VARCHAR2 Parámetro Adicional, Descripción De Rol
     **** @PARAM strDescripcionCarac1  VARCHAR2 Parámetro Adicional, Descripción De Característica
     **** @PARAM strDescripcionCarac2  VARCHAR2 Parámetro Adicional, Descripción De Característica
     * @PARAM Pn_Idcliente          IN NUMBER   Id Del Cliente
     * @PARAM Pn_Idpersona          IN NUMBER   Id Del Contacto
     * @PARAM Pn_Asigna_Cliente     IN NUMBER   Flag Que Indica Si Se Debe Asginar Rol A Nivel Cliente
     * @PARAM Pv_Msgerror           OUT VARCHAR2 Mensaje De Error General Si Existiese
     *
     **/

    PROCEDURE P_ASIGNAR_TIPO_MASIVO(Pcl_Idroles        IN CLOB,
                                    Pcl_Extraparams    IN CLOB,
                                    Pn_Idcliente       IN NUMBER,
                                    Pn_Idpersona       IN NUMBER,
                                    Pn_Asigna_Cliente  IN NUMBER,
                                    Pv_Msgerror        OUT VARCHAR2);

     /**
     * Procedimiento que realiza la eliminación masiva de roles de contacto a nivel puntos y/o cliente
     *
     * @Author Christian Jaramillo Espinoza <cjaramilloe@telconet.ec>
     * @Version 1.0 24/10/2019
     *
     * Costo Del Query C_GetIpersonacPorIpr: 147
     * Costo Del Query C_GetIpuntocPorIpr:   888
     * Costo Del Query C_GetIdCaracPorDesc:  7
     * Costo Del Query C_GetDescripcionRol:  3
     * Costo Del Query C_GetIpercPorIper:    5
     * Costo Del Query C_GetIpersonacPorId:  2
     * Costo Del Query C_GetIpuntocPorId:    3
     * Costo Del Query C_GetIperPorId:       3
     * Costo Del Query C_GetCaracPorDesc:    3

     * @PARAM Pcl_Idroles            IN CLOB     Id De Roles Del Contacto Concatenados
     * @PARAM Pcl_Extraparams        IN CLOB     Parámetros extras
     **** @PARAM intIdOficina          NUMBER   Id De Oficina
     **** @PARAM strCodEmpresa         VARCHAR2 Id De Empresa
     **** @PARAM strUsuario            VARCHAR2 Usuario Creador
     **** @PARAM strIp                 VARCHAR2 Ip Creador
     **** @PARAM strDescripcionRol1    VARCHAR2 Parámetro Adicional, Descripción De Rol
     **** @PARAM strDescripcionCarac1  VARCHAR2 Parámetro Adicional, Descripción De Característica
     **** @PARAM strDescripcionCarac2  VARCHAR2 Parámetro Adicional, Descripción De Característica
     * @PARAM Pn_Idcliente          IN NUMBER   Id Del Cliente
     * @PARAM Pn_Idpersona          IN NUMBER   Id Del Contacto
     * @PARAM Pn_Elimina_Cliente    IN NUMBER   Flag Que Indica Si Se Debe Eliminar Rol A Nivel Cliente
     * @PARAM Pv_Msgerror           OUT VARCHAR2 Mensaje De Error General Si Existiese
     *
     **/
    PROCEDURE P_ELIMINAR_TIPO_MASIVO(Pcl_Idroles        IN CLOB,
                                     Pcl_Extraparams    IN CLOB,
                                     Pn_Idcliente       IN NUMBER,
                                     Pn_Idpersona       IN NUMBER,
                                     Pn_Elimina_Cliente IN VARCHAR2,
                                     Pv_Msgerror        OUT VARCHAR2);

    /**
     * Procedimiento que realiza la eliminación de contacto a nivel puntos y/o cliente
     *
     * @Author Christian Jaramillo Espinoza <cjaramilloe@telconet.ec>
     * @Version 1.0 24/10/2019
     *
     * Costo Del Query C_GetPersona:          31
     * Costo Del Query C_GetIperPorPersona:   31
     * Costo Del Query C_GetIPersonaContacto: 14
     * Costo Del Query C_GetIPuntoContacto:   17

     * @PARAM Pn_Idcliente          IN NUMBER   Id Del Cliente
     * @PARAM Pn_Idpersona          IN NUMBER   Id Del Contacto
     * @PARAM Pcl_Extraparams       IN CLOB     Parámetros extras
     **** @PARAM intIdOficina          NUMBER   Id De Oficina
     **** @PARAM strCodEmpresa         VARCHAR2 Id De Empresa
     **** @PARAM strUsuario            VARCHAR2 Usuario Creador
     **** @PARAM strIp                 VARCHAR2 Ip Creador
     * @PARAM Pv_Msgerror           OUT VARCHAR2 Mensaje De Error General Si Existiese
     *
     **/
    PROCEDURE P_ELIMINAR_MASIVO(Pn_Idcliente       IN NUMBER,
                                Pn_Idpersona       IN NUMBER,
                                Pcl_Extraparams    IN CLOB,
                                Pv_Msgerror        OUT VARCHAR2);

    /**
     * Procedimiento que realiza la duplicación masiva de contacto y roles a nivel de puntos y/o cliente
     *
     * @Author Christian Jaramillo Espinoza <cjaramilloe@telconet.ec>
     * @Version 1.0 22/10/2019
     *
     * @Author David León <mdleon@telconet.ec>
     * @Version 1.1 07/07/2022 - Se modifica el proceso para guardar una sola vez en la tabla de INFO_PERSONA_EMPRESA_ROL.
     *
     * @Author David León <mdleon@telconet.ec>
     * @Version 1.2 12/10/2022 - Se realiza consulta para reutilizar los datos de INFO_PERSONA_EMPRESA_ROL.
     *
     * Costo Del Query C_GetDescripcionRol: 3
     * Costo Del Query C_GetIdempresarol:   2
     * Costo Del Query C_GetCaracPorDesc:   2
     * Costo Del Query C_GetCountIpuntoc:   4
     * Costo Del Query C_GetCountIpersonac: 2
     * Costo Del Query C_GetLogin:          3
     *
     * @PARAM Pcl_Idroles            IN CLOB     Id De Roles Del Contacto Concatenados
     * @PARAM Pcl_Idpuntos           IN CLOB     Id De Puntos Concatenados
     * @PARAM Pcl_Extraparams        IN CLOB     Parámetros extras
     **** @PARAM intIdOficina          NUMBER   Id De Oficina
     **** @PARAM intLoginLimite        NUMBER   Cantidad límite de logines repetidos en mensaje de salida
     **** @PARAM strCodEmpresa         VARCHAR2 Id De Empresa
     **** @PARAM strUsuario            VARCHAR2 Usuario Creador
     **** @PARAM strIp                 VARCHAR2 Ip Creador
     **** @PARAM strDescripcionRol1    VARCHAR2 Parámetro Adicional, Descripción De Rol
     **** @PARAM strDescripcionCarac1  VARCHAR2 Parámetro Adicional, Descripción De Característica
     **** @PARAM strDescripcionCarac2  VARCHAR2 Parámetro Adicional, Descripción De Característica
     * @PARAM Pn_Idcliente          IN NUMBER   Id Del Cliente
     * @PARAM Pn_Idpersona          IN NUMBER   Id Del Contacto
     * @PARAM Pn_Duplica_Cliente    IN NUMBER   Flag Que Indica Si Se Debe Duplicar Contacto A Nivel Cliente
     * @PARAM Pn_Login_Repetidos    OUT NUMBER   Cantidad de logines repetidos
     * @PARAM Pv_Login_Repetidos    OUT VARCHAR2 Logines Concatenados En Donde El Contacto Ya Exista
     * @PARAM Pv_Msg_Nivel_Cliente  OUT VARCHAR2 Mensaje De Error A Nivel Cliente Si Existiese
     * @PARAM Pv_Msgerror           OUT VARCHAR2 Mensaje De Error General Si Existiese
     *
     **/
    PROCEDURE P_DUPLICAR_MASIVO(Pcl_Idroles             IN CLOB,
                                Pcl_Idpuntos            IN CLOB,
                                Pcl_Extraparams         IN CLOB,
                                Pn_Idcliente            IN NUMBER,
                                Pn_Idpersona            IN NUMBER,
                                Pn_Duplica_Cliente      IN NUMBER,
                                Pn_Login_Repetidos      OUT NUMBER,
                                Pv_Login_Repetidos      OUT VARCHAR2,
                                Pv_Msg_Nivel_Cliente    OUT VARCHAR2,
                                Pv_Msgerror             OUT VARCHAR2);

    /**
     * Función que devuelve un array de ids de un string con ids concatenados
     *
     * @Author Sean D. Stuber
     * @Adapted By Christian Jaramillo Espinoza <cjaramilloe@telconet.ec>
     * @Version 1.0 18/10/2019
     *
     * @PARAM Pcl_Text     IN CLOB     Identificadores Concatenados Con Un Delimitador
     * @PARAM Pv_Delimiter IN VARCHAR2 Delimitador Para Parseo De Identificadores
     *
     * @Return T_Array_Id Ids Parseados
     *
     **/
    Function F_SPLIT_CLOB(Fcl_Text     IN CLOB,
                          Fv_Delimiter IN VARCHAR2)
        Return T_Array_Id;

END CMKG_CONTACTO_MASIVO;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_CONTACTO_MASIVO AS

    PROCEDURE P_CREAR_MASIVO (Pcl_Idroles       IN CLOB,
                            Pcl_Idpuntos      IN CLOB,
                            Pcl_Extraparams   IN CLOB,
                            Pn_Idcliente      IN NUMBER,
                            Pn_Idpersona      IN NUMBER,
                            Pn_Nivel_Cliente  IN NUMBER,
                            Pv_Msgerror       OUT VARCHAR2) AS

    CURSOR C_GetDescripcionRol(Ln_Idempresarol NUMBER, Lv_Empresacod VARCHAR2 ) IS
      SELECT NVL(Ar.Descripcion_Rol,'')
        FROM DB_COMERCIAL.Admi_Rol Ar
        WHERE Ar.Id_Rol IN (
          SELECT MAX(Ar.Id_Rol)
              FROM DB_COMERCIAL.Admi_Rol Ar
              INNER JOIN DB_COMERCIAL.Info_Empresa_Rol Ier ON Ar.Id_Rol = Ier.Rol_Id
              WHERE Ier.Id_Empresa_Rol = Ln_Idempresarol
              AND Ier.Empresa_Cod      = Lv_Empresacod
              AND Ar.Estado            = 'Activo'
              AND Ier.Estado           = 'Activo'
          );

    CURSOR C_GetCaracPorDesc(Lv_Desc VARCHAR2 ) IS
      SELECT NVL(Ac.Id_Caracteristica,0)
      FROM DB_COMERCIAL.Admi_caracteristica Ac
      WHERE Ac.Id_Caracteristica IN (
          SELECT MAX(Ac.Id_Caracteristica)
              FROM DB_COMERCIAL.Admi_Caracteristica Ac
              WHERE Ac.Descripcion_Caracteristica = Lv_Desc
              AND Ac.Estado                       = 'Activo'
          );
          
      CURSOR C_ValidaEmpresa_rol(Lv_Usuario varchar2, Lv_Empresa Varchar2, Lv_Oficina varchar2, Lv_Persona varchar2) IS
        SELECT COUNT(*)
          FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL
         where persona_id=Lv_Persona and EMPRESA_ROL_ID=Lv_Empresa  and  
         OFICINA_ID=Lv_Oficina  and ESTADO in ('Pendiente','Activo') and USR_CREACION=Lv_Usuario;
         
   
    Ln_Id_Rol                       NUMBER := 0;
    Ln_Id_Punto                     NUMBER := 0;
    Ln_Id_Punto_Duplicado           NUMBER := 0;
    Ln_Indice2                      NUMBER := 0;
    Ln_Indice_Rol                   NUMBER := 0;
    Ln_Indice_Punto                 NUMBER := 0;
    Ln_Persona_Empresa_Rol_Id       NUMBER := 0;
    Ln_Id_Escalabilidad             NUMBER := 0;
    Ln_Id_Horario                   NUMBER := 0;
    Ln_Idoficina                    NUMBER := 0;
    Lv_Codempresa                   VARCHAR2(32767);
    Lv_Usuario                      VARCHAR2(32767);
    Lv_Ip                           VARCHAR2(32767);
    Lv_Descripcion_Rol              VARCHAR2(32767);
    Lv_Descripcion_Carac1           VARCHAR2(32767);
    Lv_Descripcion_Carac2           VARCHAR2(32767);
    Lv_Descripcion_Rol_Actual       VARCHAR2(32767);
    Lv_Escalabilidad                VARCHAR2(32767);
    Lv_Horario                      VARCHAR2(32767);
    Lv_Msgerror                     VARCHAR2(32767);
    Lv_Separador                    VARCHAR2(1) := ',';
    T_Idroles                       T_Array_Id;
    T_Idpuntos                      T_Array_Id;
    Lr_Infopersonaempresarol        DB_COMERCIAL.Info_Persona_Empresa_Rol%ROWTYPE;
    Lr_Infopersonaempresarolhisto   DB_COMERCIAL.Info_Persona_Empresa_Rol_Histo%ROWTYPE;
    Lr_Infopersonaempresarolcarac   DB_COMERCIAL.Info_Persona_Empresa_Rol_Carac%ROWTYPE;
    Lr_Infopersonacontacto          DB_COMERCIAL.Info_Persona_Contacto%ROWTYPE;
    Lr_Infopuntocontacto            DB_COMERCIAL.Info_Punto_Contacto%ROWTYPE;
    Lt_Infopersonaempresarol        T_Array_Iper;
    Lt_Infopersonaempresarolhisto   T_Array_Iperh;
    Lt_Infopersonaempresarolcarac   T_Array_Iperc;
    Lt_Infopersonacontacto          T_Array_Ipercont;
    Lt_Infopuntocontacto            T_Array_Ipuncont;

  BEGIN

    APEX_JSON.PARSE(Pcl_Extraparams);
    Ln_Idoficina          := APEX_JSON.GET_NUMBER('intIdOficina');
    Lv_Codempresa         := APEX_JSON.GET_VARCHAR2('strCodEmpresa');
    Lv_Usuario            := APEX_JSON.GET_VARCHAR2('strUsuario');
    Lv_Ip                 := APEX_JSON.GET_VARCHAR2('strIp');
    Lv_Descripcion_Rol    := APEX_JSON.GET_VARCHAR2('strDescripcionRol1');
    Lv_Descripcion_Carac1 := APEX_JSON.GET_VARCHAR2('strDescripcionCarac1');
    Lv_Descripcion_Carac2 := APEX_JSON.GET_VARCHAR2('strDescripcionCarac2');
    Lv_Escalabilidad      := APEX_JSON.GET_VARCHAR2('strEscalabilidad');
    Lv_Horario            := APEX_JSON.GET_VARCHAR2('strHorario');

    T_Idroles  := F_SPLIT_CLOB(Pcl_Idroles,Lv_Separador);
    T_Idpuntos := F_SPLIT_CLOB(Pcl_Idpuntos,Lv_Separador);

    WHILE Ln_Indice_Rol < T_Idroles.COUNT LOOP
      IF NOT T_Idroles.EXISTS(Ln_Indice_Rol) OR T_Idroles(Ln_Indice_Rol) IS NULL OR T_Idroles(Ln_Indice_Rol) <= 0 THEN
        Ln_Indice_Rol := Ln_Indice_Rol + 1;
        CONTINUE;
      END IF;
      Ln_Id_Punto_Duplicado := 0;
      Ln_Id_Rol := T_Idroles(Ln_Indice_Rol);

      OPEN C_GetDescripcionRol(Ln_Id_Rol,Lv_Codempresa);
        FETCH C_GetDescripcionRol INTO Lv_Descripcion_Rol_Actual;
        CLOSE C_GetDescripcionRol;

      Ln_Persona_Empresa_Rol_Id := DB_COMERCIAL.Seq_Info_Persona_Empresa_Rol.NEXTVAL;

      Lr_Infopersonaempresarol.Id_Persona_Rol                 := Ln_Persona_Empresa_Rol_Id;
      Lr_Infopersonaempresarol.Persona_Id                     := Pn_Idpersona;
      Lr_Infopersonaempresarol.Empresa_Rol_Id                 := Ln_Id_Rol;
      Lr_Infopersonaempresarol.Oficina_Id                     := Ln_Idoficina;
      Lr_Infopersonaempresarol.Estado                         := 'Activo';
      Lr_Infopersonaempresarol.Usr_Creacion                   := Lv_Usuario;
      Lr_Infopersonaempresarol.Fe_Creacion                    := SYSDATE;
      Lr_Infopersonaempresarol.Ip_Creacion                    := Lv_Ip;
      Lr_Infopersonaempresarol.Usr_Ult_Mod                    := Lv_Usuario;
      Lr_Infopersonaempresarol.Fe_Ult_Mod                     := SYSDATE;
      
      Lr_Infopersonaempresarolhisto.Id_Persona_Empresa_Rol_Histo   := DB_COMERCIAL.Seq_Info_Persona_Empresa_Rol_H.NEXTVAL;
      Lr_Infopersonaempresarolhisto.Usr_Creacion                   := Lv_Usuario;
      Lr_Infopersonaempresarolhisto.Fe_Creacion                    := SYSDATE;
      Lr_Infopersonaempresarolhisto.Ip_Creacion                    := Lv_Ip;
      Lr_Infopersonaempresarolhisto.Estado                         := 'Activo';
      Lr_Infopersonaempresarolhisto.Persona_Empresa_Rol_Id         := Ln_Persona_Empresa_Rol_Id;
      Lr_Infopersonaempresarolhisto.Oficina_Id                     := Ln_Idoficina;

      Lt_Infopersonaempresarol(Lt_Infopersonaempresarol.COUNT)           := Lr_Infopersonaempresarol;
      Lt_Infopersonaempresarolhisto(Lt_Infopersonaempresarolhisto.COUNT) := Lr_Infopersonaempresarolhisto;


      IF NVL(Pn_Nivel_Cliente,0) = 1  THEN
       /* Ln_Persona_Empresa_Rol_Id := DB_COMERCIAL.Seq_Info_Persona_Empresa_Rol.NEXTVAL;

        Lr_Infopersonaempresarol.Id_Persona_Rol                 := Ln_Persona_Empresa_Rol_Id;
        Lr_Infopersonaempresarol.Persona_Id                     := Pn_Idpersona;
        Lr_Infopersonaempresarol.Empresa_Rol_Id                 := Ln_Id_Rol;
        Lr_Infopersonaempresarol.Oficina_Id                     := Ln_Idoficina;
        Lr_Infopersonaempresarol.Estado                         := 'Activo';
        Lr_Infopersonaempresarol.Usr_Creacion                   := Lv_Usuario;
        Lr_Infopersonaempresarol.Fe_Creacion                    := SYSDATE;
        Lr_Infopersonaempresarol.Ip_Creacion                    := Lv_Ip;
        Lr_Infopersonaempresarol.Usr_Ult_Mod                    := Lv_Usuario;
        Lr_Infopersonaempresarol.Fe_Ult_Mod                     := SYSDATE;

        Lr_Infopersonaempresarolhisto.Id_Persona_Empresa_Rol_Histo   := DB_COMERCIAL.Seq_Info_Persona_Empresa_Rol_H.NEXTVAL;
        Lr_Infopersonaempresarolhisto.Usr_Creacion                   := Lv_Usuario;
        Lr_Infopersonaempresarolhisto.Fe_Creacion                    := SYSDATE;
        Lr_Infopersonaempresarolhisto.Ip_Creacion                    := Lv_Ip;
        Lr_Infopersonaempresarolhisto.Estado                         := 'Activo';
        Lr_Infopersonaempresarolhisto.Persona_Empresa_Rol_Id         := Ln_Persona_Empresa_Rol_Id;
        Lr_Infopersonaempresarolhisto.Oficina_Id                     := Ln_Idoficina;*/

        Lr_Infopersonacontacto.Id_Persona_Contacto    := DB_COMERCIAL.Seq_Info_Persona_Contacto.NEXTVAL;
        Lr_Infopersonacontacto.Contacto_Id            := Pn_Idpersona;
        Lr_Infopersonacontacto.Estado                 := 'Activo';
        Lr_Infopersonacontacto.Fe_Creacion            := SYSDATE;
        Lr_Infopersonacontacto.Usr_Creacion           := Lv_Usuario;
        Lr_Infopersonacontacto.Ip_Creacion            := Lv_Ip;
        Lr_Infopersonacontacto.Persona_Empresa_Rol_Id := Pn_Idcliente;
        Lr_Infopersonacontacto.Persona_Rol_Id         := Ln_Persona_Empresa_Rol_Id;

        --Lt_Infopersonaempresarol(Lt_Infopersonaempresarol.COUNT)           := Lr_Infopersonaempresarol;
        --Lt_Infopersonaempresarolhisto(Lt_Infopersonaempresarolhisto.COUNT) := Lr_Infopersonaempresarolhisto;
        Lt_Infopersonacontacto(Lt_Infopersonacontacto.COUNT)               := Lr_Infopersonacontacto;

        IF UPPER(Lv_Descripcion_Rol) = UPPER(Lv_Descripcion_Rol_Actual) THEN
          OPEN C_GetCaracPorDesc(Lv_Descripcion_Carac1);
            FETCH C_GetCaracPorDesc INTO Ln_Id_Escalabilidad;
          CLOSE C_GetCaracPorDesc;

          OPEN C_GetCaracPorDesc(Lv_Descripcion_Carac2);
            FETCH C_GetCaracPorDesc INTO Ln_Id_Horario;
          CLOSE C_GetCaracPorDesc;

          Lr_Infopersonaempresarolcarac.Id_Persona_Empresa_Rol_Caract := DB_COMERCIAL.Seq_Info_Persona_Emp_Rol_Carac.NEXTVAL;
          Lr_Infopersonaempresarolcarac.Persona_Empresa_Rol_Id        := Ln_Persona_Empresa_Rol_Id;
          Lr_Infopersonaempresarolcarac.Caracteristica_Id             := Ln_Id_Escalabilidad;
          Lr_Infopersonaempresarolcarac.Valor                         := Lv_Escalabilidad;
          Lr_Infopersonaempresarolcarac.Fe_Creacion                   := SYSDATE;
          Lr_Infopersonaempresarolcarac.Fe_Ult_Mod                    := SYSDATE;
          Lr_Infopersonaempresarolcarac.Usr_Creacion                  := Lv_Usuario;
          Lr_Infopersonaempresarolcarac.Usr_Ult_Mod                   := Lv_Usuario;
          Lr_Infopersonaempresarolcarac.Ip_Creacion                   := Lv_Ip;
          Lr_Infopersonaempresarolcarac.Estado                        := 'Activo';

          Lt_Infopersonaempresarolcarac(Lt_Infopersonaempresarolcarac.COUNT) := Lr_Infopersonaempresarolcarac;

          Lr_Infopersonaempresarolcarac.Id_Persona_Empresa_Rol_Caract := DB_COMERCIAL.Seq_Info_Persona_Emp_Rol_Carac.NEXTVAL;
          Lr_Infopersonaempresarolcarac.Persona_Empresa_Rol_Id        := Ln_Persona_Empresa_Rol_Id;
          Lr_Infopersonaempresarolcarac.Caracteristica_Id             := Ln_Id_Horario;
          Lr_Infopersonaempresarolcarac.Valor                         := Lv_Horario;
          Lr_Infopersonaempresarolcarac.Fe_Creacion                   := SYSDATE;
          Lr_Infopersonaempresarolcarac.Fe_Ult_Mod                    := SYSDATE;
          Lr_Infopersonaempresarolcarac.Usr_Creacion                  := Lv_Usuario;
          Lr_Infopersonaempresarolcarac.Usr_Ult_Mod                   := Lv_Usuario;
          Lr_Infopersonaempresarolcarac.Ip_Creacion                   := Lv_Ip;
          Lr_Infopersonaempresarolcarac.Estado                        := 'Activo';

          Lt_Infopersonaempresarolcarac(Lt_Infopersonaempresarolcarac.COUNT) := Lr_Infopersonaempresarolcarac;
        END IF;
      END IF;

        
      WHILE Ln_Indice_Punto < T_Idpuntos.COUNT  LOOP
        IF NOT T_Idpuntos.EXISTS(Ln_Indice_Punto) OR T_Idpuntos(Ln_Indice_Punto) IS NULL OR T_Idpuntos(Ln_Indice_Punto) <= 0 THEN
          Ln_Indice_Punto := Ln_Indice_Punto + 1;
          CONTINUE;
        END IF;

        Ln_Id_Punto := T_Idpuntos(Ln_Indice_Punto);

       /* Ln_Persona_Empresa_Rol_Id := DB_COMERCIAL.Seq_Info_Persona_Empresa_Rol.NEXTVAL;

        Lr_Infopersonaempresarol.Id_Persona_Rol                 := Ln_Persona_Empresa_Rol_Id;
        Lr_Infopersonaempresarol.Persona_Id                     := Pn_Idpersona;
        Lr_Infopersonaempresarol.Empresa_Rol_Id                 := Ln_Id_Rol;
        Lr_Infopersonaempresarol.Oficina_Id                     := Ln_Idoficina;
        Lr_Infopersonaempresarol.Estado                         := 'Activo';
        Lr_Infopersonaempresarol.Usr_Creacion                   := Lv_Usuario;
        Lr_Infopersonaempresarol.Fe_Creacion                    := SYSDATE;
        Lr_Infopersonaempresarol.Ip_Creacion                    := Lv_Ip;
        Lr_Infopersonaempresarol.Usr_Ult_Mod                    := Lv_Usuario;
        Lr_Infopersonaempresarol.Fe_Ult_Mod                     := SYSDATE;

        Lr_Infopersonaempresarolhisto.Id_Persona_Empresa_Rol_Histo   := DB_COMERCIAL.Seq_Info_Persona_Empresa_Rol_H.NEXTVAL;
        Lr_Infopersonaempresarolhisto.Usr_Creacion                   := Lv_Usuario;
        Lr_Infopersonaempresarolhisto.Fe_Creacion                    := SYSDATE;
        Lr_Infopersonaempresarolhisto.Ip_Creacion                    := Lv_Ip;
        Lr_Infopersonaempresarolhisto.Estado                         := 'Activo';
        Lr_Infopersonaempresarolhisto.Persona_Empresa_Rol_Id         := Ln_Persona_Empresa_Rol_Id;
        Lr_Infopersonaempresarolhisto.Oficina_Id                     := Ln_Idoficina;*/

        Lr_Infopuntocontacto.Id_Punto_Contacto      := DB_COMERCIAL.Seq_Info_Punto_Contacto.NEXTVAL;
        Lr_Infopuntocontacto.Contacto_Id            := Pn_Idpersona;
        Lr_Infopuntocontacto.Estado                 := 'Activo';
        Lr_Infopuntocontacto.Fe_Creacion            := SYSDATE;
        Lr_Infopuntocontacto.Usr_Creacion           := Lv_Usuario;
        Lr_Infopuntocontacto.Ip_Creacion            := Lv_Ip;
        Lr_Infopuntocontacto.Punto_Id               := Ln_Id_Punto;
        Lr_Infopuntocontacto.Persona_Empresa_Rol_Id := Ln_Persona_Empresa_Rol_Id;

        --Lt_Infopersonaempresarol(Lt_Infopersonaempresarol.COUNT)           := Lr_Infopersonaempresarol;
        --Lt_Infopersonaempresarolhisto(Lt_Infopersonaempresarolhisto.COUNT) := Lr_Infopersonaempresarolhisto;
        Lt_Infopuntocontacto(Lt_Infopuntocontacto.COUNT)                   := Lr_Infopuntocontacto;

        IF UPPER(Lv_Descripcion_Rol) = UPPER(Lv_Descripcion_Rol_Actual) THEN
          OPEN C_GetCaracPorDesc(Lv_Descripcion_Carac1);
            FETCH C_GetCaracPorDesc INTO Ln_Id_Escalabilidad;
          CLOSE C_GetCaracPorDesc;

          OPEN C_GetCaracPorDesc(Lv_Descripcion_Carac2);
            FETCH C_GetCaracPorDesc INTO Ln_Id_Horario;
          CLOSE C_GetCaracPorDesc;

          Lr_Infopersonaempresarolcarac.Id_Persona_Empresa_Rol_Caract := DB_COMERCIAL.Seq_Info_Persona_Emp_Rol_Carac.NEXTVAL;
          Lr_Infopersonaempresarolcarac.Persona_Empresa_Rol_Id        := Ln_Persona_Empresa_Rol_Id;
          Lr_Infopersonaempresarolcarac.Caracteristica_Id             := Ln_Id_Escalabilidad;
          Lr_Infopersonaempresarolcarac.Valor                         := Lv_Escalabilidad;
          Lr_Infopersonaempresarolcarac.Fe_Creacion                   := SYSDATE;
          Lr_Infopersonaempresarolcarac.Fe_Ult_Mod                    := SYSDATE;
          Lr_Infopersonaempresarolcarac.Usr_Creacion                  := Lv_Usuario;
          Lr_Infopersonaempresarolcarac.Usr_Ult_Mod                   := Lv_Usuario;
          Lr_Infopersonaempresarolcarac.Ip_Creacion                   := Lv_Ip;
          Lr_Infopersonaempresarolcarac.Estado                        := 'Activo';

          Lt_Infopersonaempresarolcarac(Lt_Infopersonaempresarolcarac.COUNT) := Lr_Infopersonaempresarolcarac;

          Lr_Infopersonaempresarolcarac.Id_Persona_Empresa_Rol_Caract := DB_COMERCIAL.Seq_Info_Persona_Emp_Rol_Carac.NEXTVAL;
          Lr_Infopersonaempresarolcarac.Persona_Empresa_Rol_Id        := Ln_Persona_Empresa_Rol_Id;
          Lr_Infopersonaempresarolcarac.Caracteristica_Id             := Ln_Id_Horario;
          Lr_Infopersonaempresarolcarac.Valor                         := Lv_Horario;
          Lr_Infopersonaempresarolcarac.Fe_Creacion                   := SYSDATE;
          Lr_Infopersonaempresarolcarac.Fe_Ult_Mod                    := SYSDATE;
          Lr_Infopersonaempresarolcarac.Usr_Creacion                  := Lv_Usuario;
          Lr_Infopersonaempresarolcarac.Usr_Ult_Mod                   := Lv_Usuario;
          Lr_Infopersonaempresarolcarac.Ip_Creacion                   := Lv_Ip;
          Lr_Infopersonaempresarolcarac.Estado                        := 'Activo';

          Lt_Infopersonaempresarolcarac(Lt_Infopersonaempresarolcarac.COUNT) := Lr_Infopersonaempresarolcarac;
        END IF;

        Ln_Indice_Punto := Ln_Indice_Punto + 1;
      END LOOP;

      Ln_Indice_Rol := Ln_Indice_Rol + 1;
      Ln_Indice_Punto := 0;
    END LOOP;


    IF Lt_Infopersonaempresarol.COUNT > 0 THEN
    Ln_Indice2 :=0;
      WHILE Ln_Indice2 < Lt_Infopersonaempresarol.COUNT loop
      --FOR Ln_Indice IN Lt_Infopersonaempresarol.FIRST .. Lt_Infopersonaempresarol.LAST loop 
        INSERT INTO DB_COMERCIAL.Info_Persona_Empresa_Rol VALUES Lt_Infopersonaempresarol ( Ln_Indice2 );
        Ln_Indice2 := Ln_Indice2+1;
      end loop;
    END IF;
    
    IF Lt_Infopersonaempresarolhisto.COUNT > 0 THEN
      FORALL Ln_Indice IN Lt_Infopersonaempresarolhisto.FIRST .. Lt_Infopersonaempresarolhisto.LAST SAVE EXCEPTIONS
        INSERT INTO DB_COMERCIAL.Info_Persona_Empresa_Rol_Histo VALUES Lt_Infopersonaempresarolhisto ( Ln_Indice );
    END IF;

    IF Lt_Infopersonaempresarolcarac.COUNT > 0 THEN
      FORALL Ln_Indice IN Lt_Infopersonaempresarolcarac.FIRST .. Lt_Infopersonaempresarolcarac.LAST SAVE EXCEPTIONS
        INSERT INTO DB_COMERCIAL.Info_Persona_Empresa_Rol_Carac VALUES Lt_Infopersonaempresarolcarac ( Ln_Indice );
    END IF;

    IF Lt_Infopersonacontacto.COUNT > 0 THEN
      FORALL Ln_Indice IN Lt_Infopersonacontacto.FIRST .. Lt_Infopersonacontacto.LAST SAVE EXCEPTIONS
        INSERT INTO DB_COMERCIAL.Info_Persona_Contacto VALUES Lt_Infopersonacontacto ( Ln_Indice );
    END IF;

    IF Lt_Infopuntocontacto.COUNT > 0 THEN
      FORALL Ln_Indice IN Lt_Infopuntocontacto.FIRST .. Lt_Infopuntocontacto.LAST SAVE EXCEPTIONS
        INSERT INTO DB_COMERCIAL.Info_Punto_Contacto VALUES Lt_Infopuntocontacto ( Ln_Indice );
    END IF;

    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      Lv_Msgerror := 'Ha ocurrido un error inesperado: ' || SQLCODE || ' -ERROR- '  || Substr(SQLERRM,1,1000);
      Pv_Msgerror := Lv_Msgerror;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'TELCOS+',
                                            'CMKG_CONTACTO_MASIVO.P_CREAR_MASIVO',
                                            Pv_Msgerror,
                                            Lv_Usuario,
                                            SYSDATE,
                                            Lv_Ip );

  END P_CREAR_MASIVO;

  PROCEDURE P_ASIGNAR_TIPO_MASIVO(Pcl_Idroles        IN CLOB,
                                  Pcl_Extraparams    IN CLOB,
                                  Pn_Idcliente       IN NUMBER,
                                  Pn_Idpersona       IN NUMBER,
                                  Pn_Asigna_Cliente  IN NUMBER,
                                  Pv_Msgerror        OUT VARCHAR2) AS

    CURSOR C_GetDescripcionRol(Ln_Idempresarol NUMBER, Lv_Empresacod VARCHAR2) IS
      SELECT NVL(Ar.Descripcion_Rol,'')
          FROM DB_COMERCIAL.Admi_Rol Ar
          WHERE Ar.Id_Rol IN (
            SELECT MAX(Ar.Id_Rol)
                FROM DB_COMERCIAL.Admi_Rol Ar
                INNER JOIN DB_COMERCIAL.Info_Empresa_Rol Ier ON Ar.Id_Rol = Ier.Rol_Id
                WHERE Ier.Id_Empresa_Rol = Ln_Idempresarol
                AND Ier.Empresa_Cod      = Lv_Empresacod
                AND Ar.Estado            = 'Activo'
                AND Ier.Estado           = 'Activo'
          );

    CURSOR C_GetPuntosPorEmpresaRol(Ln_IperCliente NUMBER, Ln_IdPersona NUMBER, Ln_EmpresaRolId NUMBER) IS
      SELECT DISTINCT Ip.* FROM DB_COMERCIAL.Info_Punto Ip
      INNER JOIN DB_COMERCIAL.Info_Punto_Contacto Ipc On Ipc.Punto_Id = Ip.Id_Punto
      WHERE Ip.Persona_Empresa_Rol_Id = Ln_IperCliente
      AND Ipc.Contacto_Id             = Ln_IdPersona
      AND Ip.Id_Punto NOT IN (
        SELECT DISTINCT Ipc.PUNTO_ID
        FROM DB_COMERCIAL.Info_Persona_Empresa_Rol Iper1
        INNER JOIN DB_COMERCIAL.Info_Persona_Empresa_Rol Iper2
        ON Iper1.Persona_Id = Iper2.Persona_Id
        INNER JOIN DB_COMERCIAL.Info_Punto_Contacto Ipc
        ON Ipc.Persona_Empresa_Rol_Id = Iper1.Id_Persona_Rol
        WHERE Iper2.Persona_Id   = Ln_IdPersona
        AND Iper2.Empresa_Rol_Id = Ln_EmpresaRolId
      );

    CURSOR C_GetCaracPorDesc(Lv_Desc VARCHAR2) IS
      SELECT NVL(Ac.Id_Caracteristica,0)
      FROM DB_COMERCIAL.Admi_caracteristica Ac
      WHERE Ac.Id_Caracteristica IN (
          SELECT MAX(Ac.Id_Caracteristica)
              FROM DB_COMERCIAL.Admi_Caracteristica Ac
              WHERE Ac.Descripcion_Caracteristica = Lv_Desc
              AND Ac.Estado                       = 'Activo'
          );

    Ln_Id_Rol                      NUMBER := 0;
    Ln_Indice_Rol                  NUMBER := 0;
    Ln_Indice_Punto                NUMBER := 1;
    Ln_Indice2                     NUMBER := 0;
    Ln_Persona_Empresa_Rol_Id      NUMBER := 0;
    Ln_Id_Escalabilidad            NUMBER := 0;
    Ln_Id_Horario                  NUMBER := 0;
    Ln_Idoficina                   NUMBER := 0;
    Lv_Separador                   VARCHAR2(1) := ',';
    Lv_Codempresa                  VARCHAR2(32767);
    Lv_Usuario                     VARCHAR2(32767);
    Lv_Ip                          VARCHAR2(32767);
    Lv_Descripcion_Rol             VARCHAR2(32767);
    Lv_Descripcion_Carac1          VARCHAR2(32767);
    Lv_Descripcion_Carac2          VARCHAR2(32767);
    Lv_Descripcion_Rol_Actual      VARCHAR2(32767);
    Lv_Escalabilidad               VARCHAR2(32767);
    Lv_Horario                     VARCHAR2(32767);
    Lv_Msgerror                    VARCHAR2(32767);
    Lr_Infopersonaempresarol       DB_COMERCIAL.Info_Persona_Empresa_Rol%ROWTYPE;
    Lr_Infopersonaempresarolhisto  DB_COMERCIAL.Info_Persona_Empresa_Rol_Histo%ROWTYPE;
    Lr_Infopersonaempresarolcarac  DB_COMERCIAL.Info_Persona_Empresa_Rol_Carac%ROWTYPE;
    Lr_Infopersonacontacto         DB_COMERCIAL.Info_Persona_Contacto%ROWTYPE;
    Lr_Infopuntocontacto           DB_COMERCIAL.Info_Punto_Contacto%ROWTYPE;
    T_Idroles                      T_Array_Id;
    Lt_Infopunto                   T_Array_Ipun;
    Lt_Infopersonaempresarol       T_Array_Iper;
    Lt_Infopersonaempresarolhisto  T_Array_Iperh;
    Lt_Infopersonaempresarolcarac  T_Array_Iperc;
    Lt_Infopersonacontacto         T_Array_Ipercont;
    Lt_Infopuntocontacto           T_Array_Ipuncont;

  BEGIN

    APEX_JSON.PARSE(Pcl_Extraparams);
    Ln_Idoficina          := APEX_JSON.GET_NUMBER('intIdOficina');
    Lv_Codempresa         := APEX_JSON.GET_VARCHAR2('strCodEmpresa');
    Lv_Usuario            := APEX_JSON.GET_VARCHAR2('strUsuario');
    Lv_Ip                 := APEX_JSON.GET_VARCHAR2('strIp');
    Lv_Descripcion_Rol    := APEX_JSON.GET_VARCHAR2('strDescripcionRol1');
    Lv_Descripcion_Carac1 := APEX_JSON.GET_VARCHAR2('strDescripcionCarac1');
    Lv_Descripcion_Carac2 := APEX_JSON.GET_VARCHAR2('strDescripcionCarac2');
    Lv_Escalabilidad      := APEX_JSON.GET_VARCHAR2('strEscalabilidad');
    Lv_Horario            := APEX_JSON.GET_VARCHAR2('strHorario');

    OPEN C_GetCaracPorDesc(Lv_Descripcion_Carac1);
      FETCH C_GetCaracPorDesc INTO Ln_Id_Escalabilidad;
    CLOSE C_GetCaracPorDesc;

    OPEN C_GetCaracPorDesc(Lv_Descripcion_Carac2);
      FETCH C_GetCaracPorDesc INTO Ln_Id_Horario;
    CLOSE C_GetCaracPorDesc;

    T_Idroles := F_SPLIT_CLOB(Pcl_Idroles,Lv_Separador);

    WHILE Ln_Indice_Rol < T_Idroles.COUNT LOOP
      IF NOT T_Idroles.EXISTS(Ln_Indice_Rol) OR T_Idroles(Ln_Indice_Rol) IS NULL OR T_Idroles(Ln_Indice_Rol) <= 0 THEN
        Ln_Indice_Rol := Ln_Indice_Rol + 1;
        CONTINUE;
      END IF;

      Ln_Id_Rol := T_Idroles(Ln_Indice_Rol);

      OPEN C_GetDescripcionRol(Ln_Id_Rol,Lv_Codempresa);
        FETCH C_GetDescripcionRol INTO Lv_Descripcion_Rol_Actual;
      CLOSE C_GetDescripcionRol;
      
      Ln_Persona_Empresa_Rol_Id := DB_COMERCIAL.Seq_Info_Persona_Empresa_Rol.NEXTVAL;

        Lr_Infopersonaempresarol.Id_Persona_Rol                 := Ln_Persona_Empresa_Rol_Id;
        Lr_Infopersonaempresarol.Persona_Id                     := Pn_Idpersona;
        Lr_Infopersonaempresarol.Empresa_Rol_Id                 := Ln_Id_Rol;
        Lr_Infopersonaempresarol.Oficina_Id                     := Ln_Idoficina;
        Lr_Infopersonaempresarol.Estado                         := 'Activo';
        Lr_Infopersonaempresarol.Usr_Creacion                   := Lv_Usuario;
        Lr_Infopersonaempresarol.Fe_Creacion                    := SYSDATE;
        Lr_Infopersonaempresarol.Ip_Creacion                    := Lv_Ip;
        Lr_Infopersonaempresarol.Usr_Ult_Mod                    := Lv_Usuario;
        Lr_Infopersonaempresarol.Fe_Ult_Mod                     := SYSDATE;
        
        Lr_Infopersonaempresarolhisto.Id_Persona_Empresa_Rol_Histo   := DB_COMERCIAL.Seq_Info_Persona_Empresa_Rol_H.NEXTVAL;
        Lr_Infopersonaempresarolhisto.Usr_Creacion                   := Lv_Usuario;
        Lr_Infopersonaempresarolhisto.Fe_Creacion                    := SYSDATE;
        Lr_Infopersonaempresarolhisto.Ip_Creacion                    := Lv_Ip;
        Lr_Infopersonaempresarolhisto.Estado                         := 'Activo';
        Lr_Infopersonaempresarolhisto.Persona_Empresa_Rol_Id         := Ln_Persona_Empresa_Rol_Id;
        Lr_Infopersonaempresarolhisto.Oficina_Id                     := Ln_Idoficina;

        Lt_Infopersonaempresarol(Lt_Infopersonaempresarol.COUNT)           := Lr_Infopersonaempresarol;
        Lt_Infopersonaempresarolhisto(Lt_Infopersonaempresarolhisto.COUNT) := Lr_Infopersonaempresarolhisto;


      IF NVL(Pn_Asigna_Cliente,0) = 1 THEN
        /*Ln_Persona_Empresa_Rol_Id := DB_COMERCIAL.Seq_Info_Persona_Empresa_Rol.NEXTVAL;

        Lr_Infopersonaempresarol.Id_Persona_Rol                 := Ln_Persona_Empresa_Rol_Id;
        Lr_Infopersonaempresarol.Persona_Id                     := Pn_Idpersona;
        Lr_Infopersonaempresarol.Empresa_Rol_Id                 := Ln_Id_Rol;
        Lr_Infopersonaempresarol.Oficina_Id                     := Ln_Idoficina;
        Lr_Infopersonaempresarol.Estado                         := 'Activo';
        Lr_Infopersonaempresarol.Usr_Creacion                   := Lv_Usuario;
        Lr_Infopersonaempresarol.Fe_Creacion                    := SYSDATE;
        Lr_Infopersonaempresarol.Ip_Creacion                    := Lv_Ip;
        Lr_Infopersonaempresarol.Usr_Ult_Mod                    := Lv_Usuario;
        Lr_Infopersonaempresarol.Fe_Ult_Mod                     := SYSDATE;

        Lr_Infopersonaempresarolhisto.Id_Persona_Empresa_Rol_Histo   := DB_COMERCIAL.Seq_Info_Persona_Empresa_Rol_H.NEXTVAL;
        Lr_Infopersonaempresarolhisto.Usr_Creacion                   := Lv_Usuario;
        Lr_Infopersonaempresarolhisto.Fe_Creacion                    := SYSDATE;
        Lr_Infopersonaempresarolhisto.Ip_Creacion                    := Lv_Ip;
        Lr_Infopersonaempresarolhisto.Estado                         := 'Activo';
        Lr_Infopersonaempresarolhisto.Persona_Empresa_Rol_Id         := Ln_Persona_Empresa_Rol_Id;
        Lr_Infopersonaempresarolhisto.Oficina_Id                     := Ln_Idoficina;*/

        Lr_Infopersonacontacto.Id_Persona_Contacto    := DB_COMERCIAL.Seq_Info_Persona_Contacto.NEXTVAL;
        Lr_Infopersonacontacto.Contacto_Id            := Pn_Idpersona;
        Lr_Infopersonacontacto.Estado                 := 'Activo';
        Lr_Infopersonacontacto.Fe_Creacion            := SYSDATE;
        Lr_Infopersonacontacto.Usr_Creacion           := Lv_Usuario;
        Lr_Infopersonacontacto.Ip_Creacion            := Lv_Ip;
        Lr_Infopersonacontacto.Persona_Empresa_Rol_Id := Pn_Idcliente;
        Lr_Infopersonacontacto.Persona_Rol_Id         := Ln_Persona_Empresa_Rol_Id;

        --Lt_Infopersonaempresarol(Lt_Infopersonaempresarol.COUNT)           := Lr_Infopersonaempresarol;
        --Lt_Infopersonaempresarolhisto(Lt_Infopersonaempresarolhisto.COUNT) := Lr_Infopersonaempresarolhisto;
        Lt_Infopersonacontacto(Lt_Infopersonacontacto.COUNT)               := Lr_Infopersonacontacto;

        IF UPPER(Lv_Descripcion_Rol) = UPPER(Lv_Descripcion_Rol_Actual) THEN
          OPEN C_GetCaracPorDesc(Lv_Descripcion_Carac1);
            FETCH C_GetCaracPorDesc INTO Ln_Id_Escalabilidad;
          CLOSE C_GetCaracPorDesc;

          OPEN C_GetCaracPorDesc(Lv_Descripcion_Carac2);
            FETCH C_GetCaracPorDesc INTO Ln_Id_Horario;
          CLOSE C_GetCaracPorDesc;

          Lr_Infopersonaempresarolcarac.Id_Persona_Empresa_Rol_Caract := DB_COMERCIAL.Seq_Info_Persona_Emp_Rol_Carac.NEXTVAL;
          Lr_Infopersonaempresarolcarac.Persona_Empresa_Rol_Id        := Ln_Persona_Empresa_Rol_Id;
          Lr_Infopersonaempresarolcarac.Caracteristica_Id             := Ln_Id_Escalabilidad;
          Lr_Infopersonaempresarolcarac.Valor                         := Lv_Escalabilidad;
          Lr_Infopersonaempresarolcarac.Fe_Creacion                   := SYSDATE;
          Lr_Infopersonaempresarolcarac.Fe_Ult_Mod                    := SYSDATE;
          Lr_Infopersonaempresarolcarac.Usr_Creacion                  := Lv_Usuario;
          Lr_Infopersonaempresarolcarac.Usr_Ult_Mod                   := Lv_Usuario;
          Lr_Infopersonaempresarolcarac.Ip_Creacion                   := Lv_Ip;
          Lr_Infopersonaempresarolcarac.Estado                        := 'Activo';

          Lt_Infopersonaempresarolcarac(Lt_Infopersonaempresarolcarac.COUNT) := Lr_Infopersonaempresarolcarac;

          Lr_Infopersonaempresarolcarac.Id_Persona_Empresa_Rol_Caract := DB_COMERCIAL.Seq_Info_Persona_Emp_Rol_Carac.NEXTVAL;
          Lr_Infopersonaempresarolcarac.Persona_Empresa_Rol_Id        := Ln_Persona_Empresa_Rol_Id;
          Lr_Infopersonaempresarolcarac.Caracteristica_Id             := Ln_Id_Horario;
          Lr_Infopersonaempresarolcarac.Valor                         := Lv_Horario;
          Lr_Infopersonaempresarolcarac.Fe_Creacion                   := SYSDATE;
          Lr_Infopersonaempresarolcarac.Fe_Ult_Mod                    := SYSDATE;
          Lr_Infopersonaempresarolcarac.Usr_Creacion                  := Lv_Usuario;
          Lr_Infopersonaempresarolcarac.Usr_Ult_Mod                   := Lv_Usuario;
          Lr_Infopersonaempresarolcarac.Ip_Creacion                   := Lv_Ip;
          Lr_Infopersonaempresarolcarac.Estado                        := 'Activo';

          Lt_Infopersonaempresarolcarac(Lt_Infopersonaempresarolcarac.COUNT) := Lr_Infopersonaempresarolcarac;
        END IF;

      END IF;

      OPEN C_GetPuntosPorEmpresaRol(Pn_Idcliente, Pn_Idpersona, Ln_Id_Rol);
        FETCH C_GetPuntosPorEmpresaRol BULK COLLECT INTO Lt_Infopunto LIMIT 100000;
      CLOSE C_GetPuntosPorEmpresaRol;

      WHILE Ln_Indice_Punto <= Lt_Infopunto.COUNT LOOP
        /*Ln_Persona_Empresa_Rol_Id := DB_COMERCIAL.Seq_Info_Persona_Empresa_Rol.NEXTVAL;

        Lr_Infopersonaempresarol.Id_Persona_Rol := Ln_Persona_Empresa_Rol_Id;
        Lr_Infopersonaempresarol.Persona_Id     := Pn_Idpersona;
        Lr_Infopersonaempresarol.Empresa_Rol_Id := Ln_Id_Rol;
        Lr_Infopersonaempresarol.Oficina_Id     := Ln_Idoficina;
        Lr_Infopersonaempresarol.Estado         := 'Activo';
        Lr_Infopersonaempresarol.Usr_Creacion   := Lv_Usuario;
        Lr_Infopersonaempresarol.Fe_Creacion    := SYSDATE;
        Lr_Infopersonaempresarol.Ip_Creacion    := Lv_Ip;
        Lr_Infopersonaempresarol.Usr_Ult_Mod    := Lv_Usuario;
        Lr_Infopersonaempresarol.Fe_Ult_Mod     := SYSDATE;

        Lr_Infopersonaempresarolhisto.Id_Persona_Empresa_Rol_Histo := DB_COMERCIAL.Seq_Info_Persona_Empresa_Rol_H.NEXTVAL;
        Lr_Infopersonaempresarolhisto.Usr_Creacion                 := Lv_Usuario;
        Lr_Infopersonaempresarolhisto.Fe_Creacion                  := SYSDATE;
        Lr_Infopersonaempresarolhisto.Ip_Creacion                  := Lv_Ip;
        Lr_Infopersonaempresarolhisto.Estado                       := 'Activo';
        Lr_Infopersonaempresarolhisto.Persona_Empresa_Rol_Id       := Ln_Persona_Empresa_Rol_Id;
        Lr_Infopersonaempresarolhisto.Oficina_Id                   := Ln_Idoficina;*/

        Lr_Infopuntocontacto.Id_Punto_Contacto      := DB_COMERCIAL.Seq_Info_Punto_Contacto.NEXTVAL;
        Lr_Infopuntocontacto.Contacto_Id            := Pn_Idpersona;
        Lr_Infopuntocontacto.Estado                 := 'Activo';
        Lr_Infopuntocontacto.Fe_Creacion            := SYSDATE;
        Lr_Infopuntocontacto.Usr_Creacion           := Lv_Usuario;
        Lr_Infopuntocontacto.Ip_Creacion            := Lv_Ip;
        Lr_Infopuntocontacto.Punto_Id               := Lt_Infopunto(Ln_Indice_Punto).Id_Punto;
        Lr_Infopuntocontacto.Persona_Empresa_Rol_Id := Ln_Persona_Empresa_Rol_Id;

       -- Lt_Infopersonaempresarol(Lt_Infopersonaempresarol.COUNT)           := Lr_Infopersonaempresarol;
       -- Lt_Infopersonaempresarolhisto(Lt_Infopersonaempresarolhisto.COUNT) := Lr_Infopersonaempresarolhisto;
        Lt_Infopuntocontacto(Lt_Infopuntocontacto.COUNT)                   := Lr_Infopuntocontacto;

        IF UPPER(Lv_Descripcion_Rol) = UPPER(Lv_Descripcion_Rol_Actual) THEN
          Lr_Infopersonaempresarolcarac.Id_Persona_Empresa_Rol_Caract := DB_COMERCIAL.Seq_Info_Persona_Emp_Rol_Carac.NEXTVAL;
          Lr_Infopersonaempresarolcarac.Persona_Empresa_Rol_Id        := Ln_Persona_Empresa_Rol_Id;
          Lr_Infopersonaempresarolcarac.Caracteristica_Id             := Ln_Id_Escalabilidad;
          Lr_Infopersonaempresarolcarac.Valor                         := Lv_Escalabilidad;
          Lr_Infopersonaempresarolcarac.Fe_Creacion                   := SYSDATE;
          Lr_Infopersonaempresarolcarac.Fe_Ult_Mod                    := SYSDATE;
          Lr_Infopersonaempresarolcarac.Usr_Creacion                  := Lv_Usuario;
          Lr_Infopersonaempresarolcarac.Usr_Ult_Mod                   := Lv_Usuario;
          Lr_Infopersonaempresarolcarac.Ip_Creacion                   := Lv_Ip;
          Lr_Infopersonaempresarolcarac.Estado                        := 'Activo';

          Lt_Infopersonaempresarolcarac(Lt_Infopersonaempresarolcarac.COUNT) := Lr_Infopersonaempresarolcarac;

          Lr_Infopersonaempresarolcarac.Id_Persona_Empresa_Rol_Caract := DB_COMERCIAL.Seq_Info_Persona_Emp_Rol_Carac.NEXTVAL;
          Lr_Infopersonaempresarolcarac.Persona_Empresa_Rol_Id        := Ln_Persona_Empresa_Rol_Id;
          Lr_Infopersonaempresarolcarac.Caracteristica_Id             := Ln_Id_Horario;
          Lr_Infopersonaempresarolcarac.Valor                         := Lv_Horario;
          Lr_Infopersonaempresarolcarac.Fe_Creacion                   := SYSDATE;
          Lr_Infopersonaempresarolcarac.Fe_Ult_Mod                    := SYSDATE;
          Lr_Infopersonaempresarolcarac.Usr_Creacion                  := Lv_Usuario;
          Lr_Infopersonaempresarolcarac.Usr_Ult_Mod                   := Lv_Usuario;
          Lr_Infopersonaempresarolcarac.Ip_Creacion                   := Lv_Ip;
          Lr_Infopersonaempresarolcarac.Estado                        := 'Activo';

          Lt_Infopersonaempresarolcarac(Lt_Infopersonaempresarolcarac.COUNT) := Lr_Infopersonaempresarolcarac;
        END IF;

        Ln_Indice_Punto := Ln_Indice_Punto + 1;
      END LOOP;

      Ln_Indice_Rol := Ln_Indice_Rol + 1;
      Ln_Indice_Punto := 1;
    END LOOP;

    IF Lt_Infopersonaempresarol.COUNT > 0 THEN
    Ln_Indice2 :=0;
      WHILE Ln_Indice2 < Lt_Infopersonaempresarol.COUNT loop
      --FOR Ln_Indice IN Lt_Infopersonaempresarol.FIRST .. Lt_Infopersonaempresarol.LAST loop 
        INSERT INTO DB_COMERCIAL.Info_Persona_Empresa_Rol VALUES Lt_Infopersonaempresarol ( Ln_Indice2 );
        Ln_Indice2 := Ln_Indice2+1;
      end loop;
    END IF;

    IF Lt_Infopersonaempresarolhisto.COUNT > 0 THEN
      FORALL Ln_Indice IN Lt_Infopersonaempresarolhisto.FIRST .. Lt_Infopersonaempresarolhisto.LAST SAVE EXCEPTIONS
        INSERT INTO DB_COMERCIAL.Info_Persona_Empresa_Rol_Histo VALUES Lt_Infopersonaempresarolhisto ( Ln_Indice );
    END IF;

    IF Lt_Infopersonaempresarolcarac.COUNT > 0 THEN
      FORALL Ln_Indice IN Lt_Infopersonaempresarolcarac.FIRST .. Lt_Infopersonaempresarolcarac.LAST SAVE EXCEPTIONS
        INSERT INTO DB_COMERCIAL.Info_Persona_Empresa_Rol_Carac VALUES Lt_Infopersonaempresarolcarac ( Ln_Indice );
    END IF;

    IF Lt_Infopersonacontacto.COUNT > 0 THEN
      FORALL Ln_Indice IN Lt_Infopersonacontacto.FIRST .. Lt_Infopersonacontacto.LAST SAVE EXCEPTIONS
        INSERT INTO DB_COMERCIAL.Info_Persona_Contacto VALUES Lt_Infopersonacontacto ( Ln_Indice );
    END IF;

    IF Lt_Infopuntocontacto.COUNT > 0 THEN
      FORALL Ln_Indice IN Lt_Infopuntocontacto.FIRST .. Lt_Infopuntocontacto.LAST SAVE EXCEPTIONS
        INSERT INTO DB_COMERCIAL.Info_Punto_Contacto VALUES Lt_Infopuntocontacto ( Ln_Indice );
    END IF;

    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;

      IF C_GetPuntosPorEmpresaRol%ISOPEN THEN
        CLOSE C_GetPuntosPorEmpresaRol;
      END IF;

      Lv_Msgerror := 'Ha ocurrido un error inesperado: ' || SQLCODE || ' -ERROR- ' || Substr(SQLERRM,1,1000);
      Pv_Msgerror := Lv_Msgerror;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('TELCOS+',
                                           'CMKG_CONTACTO_MASIVO.P_ASIGNAR_TIPO_MASIVO',
                                           Pv_Msgerror,
                                           Lv_Usuario,
                                           SYSDATE,
                                           Lv_Ip);

  END P_ASIGNAR_TIPO_MASIVO;

  PROCEDURE P_ELIMINAR_TIPO_MASIVO (Pcl_Idroles        IN CLOB,
                                    Pcl_Extraparams    IN CLOB,
                                    Pn_Idcliente       IN NUMBER,
                                    Pn_Idpersona       IN NUMBER,
                                    Pn_Elimina_Cliente IN VARCHAR2,
                                    Pv_Msgerror        OUT VARCHAR2) AS

    CURSOR C_GetIpersonacPorIpr(Ln_Id NUMBER) IS
      SELECT Ipc.*
      FROM DB_COMERCIAL.Info_Persona_Contacto Ipc
      WHERE Ipc.Persona_Rol_Id IN (
        SELECT Iper2.Id_Persona_Rol
        FROM DB_COMERCIAL.Info_Persona_Empresa_Rol Iper1
        INNER JOIN DB_COMERCIAL.Info_Persona_Empresa_Rol Iper2
        ON Iper1.Persona_Id = Iper2.Persona_Id
        WHERE Iper1.Id_Persona_Rol = Ln_Id
        AND Iper2.Empresa_Rol_Id   = Iper1.Empresa_Rol_Id
        AND Iper1.Estado           = 'Activo'
        AND Iper2.Estado           = 'Activo')
      AND Ipc.Estado = 'Activo';

    CURSOR C_GetIpuntocPorIpr(Ln_Id NUMBER) IS
      SELECT Ipc.*
        FROM DB_COMERCIAL.Info_Persona_Empresa_Rol Iper1
        INNER JOIN DB_COMERCIAL.Info_Persona_Empresa_Rol Iper2
        ON Iper1.Persona_Id = Iper2.Persona_Id
        INNER JOIN DB_COMERCIAL.Info_Punto_Contacto Ipc
        ON Iper2.Id_Persona_Rol = Ipc.Persona_Empresa_Rol_Id
        WHERE Iper1.Id_Persona_Rol = Ln_Id
        AND Iper2.Empresa_Rol_Id   = Iper1.Empresa_Rol_Id
        AND Iper1.Estado           = 'Activo'
        AND Iper2.Estado           = 'Activo';

    CURSOR C_GetIdCaracPorDesc(Ln_Id NUMBER, Lv_Carac1 VARCHAR2, Lv_Carac2 VARCHAR2) IS
      SELECT NVL(Iperc.Id_Persona_Empresa_Rol_Caract,0)
      FROM DB_COMERCIAL.Info_Persona_Empresa_Rol_Carac Iperc
      INNER JOIN DB_COMERCIAL.Admi_Caracteristica Ac
      ON Iperc.Caracteristica_Id = Ac.Id_Caracteristica
      WHERE Iperc.Persona_Empresa_Rol_Id = Ln_Id
      AND Iperc.Estado                   = 'Activo'
      AND Ac.Descripcion_Caracteristica IN (Lv_Carac1, Lv_Carac2);

    CURSOR C_GetDescripcionRol(Ln_Idiper NUMBER, Lv_Empresacod VARCHAR2) IS
      SELECT NVL(Ar.Descripcion_Rol,'')
      FROM DB_COMERCIAL.Admi_Rol Ar
      WHERE Ar.Id_Rol IN(
          SELECT MAX(Ar.Id_Rol)
          FROM DB_COMERCIAL.Admi_Rol Ar
          INNER JOIN DB_COMERCIAL.Info_Empresa_Rol Ier
          ON Ar.Id_Rol = Ier.Rol_Id
          INNER JOIN DB_COMERCIAL.Info_Persona_Empresa_Rol Iper
          ON Iper.Empresa_Rol_Id = Ier.Id_Empresa_Rol
          WHERE Iper.Id_Persona_Rol = Ln_Idiper
          AND Ier.Empresa_Cod       = Lv_Empresacod
          AND Ar.Estado             = 'Activo'
          AND Ier.Estado            = 'Activo'
          AND Iper.Estado           = 'Activo'
        );

    CURSOR C_GetIpercPorIper(Ln_Id NUMBER) IS
      SELECT Iperc.*
      FROM DB_COMERCIAL.Info_Persona_Empresa_Rol_Carac Iperc
      WHERE Iperc.Persona_Empresa_Rol_Id = Ln_Id;

    CURSOR C_GetIpersonacPorId(Ln_Id NUMBER) IS
      SELECT Ipc.*
      FROM DB_COMERCIAL.Info_Persona_Contacto Ipc
      WHERE Ipc.id_Persona_Contacto = Ln_Id;

    CURSOR C_GetIpuntocPorId(Ln_Id NUMBER) IS
      SELECT Ipc.*
      FROM DB_COMERCIAL.Info_Punto_Contacto Ipc
      WHERE Ipc.id_Punto_Contacto = Ln_Id;

    CURSOR C_GetIperPorId(Ln_Id NUMBER) IS
      SELECT Iper.*
      FROM DB_COMERCIAL.Info_Persona_Empresa_rol Iper
      WHERE Iper.id_Persona_Rol = Ln_Id;

    CURSOR C_GetCaracPorDesc(Lv_Desc VARCHAR2) IS
      SELECT NVL(Ac.Id_Caracteristica,0)
      FROM DB_COMERCIAL.Admi_caracteristica Ac
      WHERE Ac.Id_Caracteristica IN (
          SELECT MAX(Ac.Id_Caracteristica)
              FROM DB_COMERCIAL.Admi_Caracteristica Ac
              WHERE Ac.Descripcion_Caracteristica = Lv_Desc
              AND Ac.Estado                       = 'Activo'
          );

    Ln_Id_Rol                      NUMBER := 0;
    Ln_Indice_Rol                  NUMBER := 0;
    Ln_Indice_Ipersonac            NUMBER := 1;
    Ln_Indice_Ipuntoc              NUMBER := 1;
    Ln_Idoficina                   NUMBER := 0;
    Lv_Separador                   VARCHAR2(1) := ',';
    Lv_Codempresa                  VARCHAR2(32767);
    Lv_Usuario                     VARCHAR2(32767);
    Lv_Ip                          VARCHAR2(32767);
    Lv_Descripcion_Rol             VARCHAR2(32767);
    Lv_Descripcion_Carac1          VARCHAR2(32767);
    Lv_Descripcion_Carac2          VARCHAR2(32767);
    Lv_Descripcion_Rol_Actual      VARCHAR2(32767);
    Lv_Msgerror                    VARCHAR2(32767);
    Lr_Infopersonaempresarol       DB_COMERCIAL.Info_Persona_Empresa_Rol%ROWTYPE;
    Lr_Infopersonaempresarolhisto  DB_COMERCIAL.Info_Persona_Empresa_Rol_Histo%ROWTYPE;
    T_Idroles                      T_Array_Id;
    Lt_Infopersonaempresarol       T_Array_Iper;
    Lt_Infopersonaempresarolhisto  T_Array_Iperh;
    Lt_Infopersonaempresarolcarac  T_Array_Iperc;
    Lt_Infopersonacontacto         T_Array_Ipercont;
    Lt_Infopuntocontacto           T_Array_Ipuncont;

  BEGIN
    APEX_JSON.PARSE(Pcl_Extraparams);
    Ln_Idoficina          := APEX_JSON.GET_NUMBER('intIdOficina');
    Lv_Codempresa         := APEX_JSON.GET_VARCHAR2('strCodEmpresa');
    Lv_Usuario            := APEX_JSON.GET_VARCHAR2('strUsuario');
    Lv_Ip                 := APEX_JSON.GET_VARCHAR2('strIp');
    Lv_Descripcion_Rol    := APEX_JSON.GET_VARCHAR2('strDescripcionRol1');
    Lv_Descripcion_Carac1 := APEX_JSON.GET_VARCHAR2('strDescripcionCarac1');
    Lv_Descripcion_Carac2 := APEX_JSON.GET_VARCHAR2('strDescripcionCarac2');

    T_Idroles := F_SPLIT_CLOB(Pcl_Idroles, Lv_Separador);

    WHILE Ln_Indice_Rol < T_Idroles.COUNT LOOP
      IF NOT T_Idroles.EXISTS(Ln_Indice_Rol) OR T_Idroles(Ln_Indice_Rol) IS NULL OR T_Idroles(Ln_Indice_Rol) <= 0 THEN
        CONTINUE;
      END IF;

      Ln_Id_Rol := T_Idroles(Ln_Indice_Rol);

      IF NVL(Pn_Elimina_Cliente,0) = 1 THEN
        OPEN C_GetIpersonacPorIpr(Ln_Id_Rol);
          FETCH C_GetIpersonacPorIpr BULK COLLECT INTO Lt_Infopersonacontacto LIMIT 100000;
        CLOSE C_GetIpersonacPorIpr;

        WHILE Ln_Indice_Ipersonac <= Lt_Infopersonacontacto.COUNT LOOP
          Lr_Infopersonaempresarolhisto.Id_Persona_Empresa_Rol_Histo := DB_COMERCIAL.Seq_Info_Persona_Empresa_Rol_H.NEXTVAL;
          Lr_Infopersonaempresarolhisto.Usr_Creacion                 := Lv_Usuario;
          Lr_Infopersonaempresarolhisto.Fe_Creacion                  := SYSDATE;
          Lr_Infopersonaempresarolhisto.Ip_Creacion                  := Lv_Ip;
          Lr_Infopersonaempresarolhisto.Estado                       := 'Eliminado';
          Lr_Infopersonaempresarolhisto.Persona_Empresa_Rol_Id       := Lt_Infopersonacontacto(Ln_Indice_Ipersonac).Persona_Rol_Id;
          Lr_Infopersonaempresarolhisto.Oficina_Id                   := Ln_Idoficina;

          Lt_Infopersonaempresarolhisto(Lt_Infopersonaempresarolhisto.COUNT) := Lr_Infopersonaempresarolhisto;

          OPEN C_GetIperPorId(Lt_Infopersonacontacto(Ln_Indice_Ipersonac).Persona_Rol_Id);
            FETCH C_GetIperPorId INTO Lr_Infopersonaempresarol;
          CLOSE C_GetIperPorId;

          Lt_Infopersonaempresarol(Lt_Infopersonaempresarol.COUNT) := Lr_Infopersonaempresarol;

          OPEN C_GetDescripcionRol(Lt_Infopersonacontacto(Ln_Indice_Ipersonac).Persona_Rol_Id,Lv_Codempresa);
            FETCH C_GetDescripcionRol INTO Lv_Descripcion_Rol_Actual;
          CLOSE C_GetDescripcionRol;

          IF UPPER(Lv_Descripcion_Rol) = UPPER(Lv_Descripcion_Rol_Actual) THEN
            OPEN C_GetIpercPorIper(Lt_Infopersonacontacto(Ln_Indice_Ipersonac).Persona_Rol_Id);
              FETCH C_GetIpercPorIper BULK COLLECT INTO Lt_Infopersonaempresarolcarac LIMIT 1000000;
            CLOSE C_GetIpercPorIper;
          END IF;

          Ln_Indice_Ipersonac := Ln_Indice_Ipersonac + 1;
        END LOOP;

        IF Lt_Infopersonacontacto.COUNT > 0 THEN
          FORALL Ln_Indice IN Lt_Infopersonacontacto.FIRST .. Lt_Infopersonacontacto.LAST SAVE EXCEPTIONS
            UPDATE DB_COMERCIAL.Info_Persona_Contacto Ipc
            SET Ipc.Estado = 'Eliminado'
            WHERE Ipc.Id_Persona_Contacto = Lt_Infopersonacontacto(Ln_Indice).Id_Persona_Contacto;
        END IF;

      Ln_Indice_Ipersonac := 1;

      END IF;

      OPEN C_GetIpuntocPorIpr(Ln_Id_Rol);
        FETCH C_GetIpuntocPorIpr BULK COLLECT INTO Lt_Infopuntocontacto LIMIT 100000;
      CLOSE C_GetIpuntocPorIpr;

       WHILE Ln_Indice_Ipuntoc <= Lt_Infopuntocontacto.COUNT LOOP
          Lr_Infopersonaempresarolhisto.Id_Persona_Empresa_Rol_Histo := DB_COMERCIAL.Seq_Info_Persona_Empresa_Rol_H.NEXTVAL;
          Lr_Infopersonaempresarolhisto.Usr_Creacion                 := Lv_Usuario;
          Lr_Infopersonaempresarolhisto.Fe_Creacion                  := SYSDATE;
          Lr_Infopersonaempresarolhisto.Ip_Creacion                  := Lv_Ip;
          Lr_Infopersonaempresarolhisto.Estado                       := 'Eliminado';
          Lr_Infopersonaempresarolhisto.Persona_Empresa_Rol_Id       := Lt_Infopuntocontacto(Ln_Indice_Ipuntoc).Persona_Empresa_Rol_Id;
          Lr_Infopersonaempresarolhisto.Oficina_Id                   := Ln_Idoficina;

          Lt_Infopersonaempresarolhisto(Lt_Infopersonaempresarolhisto.COUNT) := Lr_Infopersonaempresarolhisto;

          OPEN C_GetIperPorId(Lt_Infopuntocontacto(Ln_Indice_Ipuntoc).Persona_Empresa_Rol_Id);
            FETCH C_GetIperPorId INTO Lr_Infopersonaempresarol;
          CLOSE C_GetIperPorId;

          Lt_Infopersonaempresarol(Lt_Infopersonaempresarol.COUNT) := Lr_Infopersonaempresarol;

          OPEN C_GetDescripcionRol(Lt_Infopuntocontacto(Ln_Indice_Ipuntoc).Persona_Empresa_Rol_Id,Lv_Codempresa);
            FETCH C_GetDescripcionRol INTO Lv_Descripcion_Rol_Actual;
          CLOSE C_GetDescripcionRol;

          IF UPPER(Lv_Descripcion_Rol) = UPPER(Lv_Descripcion_Rol_Actual) THEN
            OPEN C_GetIpercPorIper(Lt_Infopuntocontacto(Ln_Indice_Ipuntoc).Persona_Empresa_Rol_Id);
              FETCH C_GetIpercPorIper BULK COLLECT INTO Lt_Infopersonaempresarolcarac LIMIT 1000000;
            CLOSE C_GetIpercPorIper;
          END IF;

        Ln_Indice_Ipuntoc := Ln_Indice_Ipuntoc + 1;
      END LOOP;

      IF Lt_Infopuntocontacto.COUNT > 0 THEN
        FORALL Ln_Indice IN Lt_Infopuntocontacto.FIRST .. Lt_Infopuntocontacto.LAST SAVE EXCEPTIONS
          UPDATE DB_COMERCIAL.Info_Punto_Contacto Ipc
          SET Ipc.Estado = 'Eliminado'
          WHERE Ipc.Id_Punto_Contacto = Lt_Infopuntocontacto(Ln_Indice).Id_Punto_Contacto;
      END IF;

      Ln_Indice_Rol := Ln_Indice_Rol + 1;
      Ln_Indice_Ipuntoc := 1;
    END LOOP;

    IF Lt_Infopersonaempresarolhisto.COUNT > 0 THEN
      FORALL Ln_Indice IN Lt_Infopersonaempresarolhisto.FIRST .. Lt_Infopersonaempresarolhisto.LAST SAVE EXCEPTIONS
        INSERT INTO DB_COMERCIAL.Info_Persona_Empresa_Rol_Histo VALUES Lt_Infopersonaempresarolhisto(Ln_Indice);
    END IF;

    IF Lt_Infopersonaempresarol.COUNT > 0 THEN
      FORALL Ln_Indice IN Lt_Infopersonaempresarol.FIRST .. Lt_Infopersonaempresarol.LAST SAVE EXCEPTIONS
        UPDATE DB_COMERCIAL.Info_Persona_Empresa_Rol Iper
        SET Iper.Estado = 'Eliminado',
            Iper.Fe_Ult_Mod = SYSDATE
        WHERE Iper.Id_Persona_Rol = Lt_Infopersonaempresarol(Ln_Indice).Id_Persona_Rol;
    END IF;

    IF Lt_Infopersonaempresarolcarac.COUNT > 0 THEN
      FORALL Ln_Indice IN Lt_Infopersonaempresarolcarac.FIRST .. Lt_Infopersonaempresarolcarac.LAST SAVE EXCEPTIONS
        UPDATE DB_COMERCIAL.Info_Persona_Empresa_Rol_Carac Iperc
        SET Iperc.Estado = 'Eliminado',
            Iperc.Fe_Ult_Mod = SYSDATE
        WHERE Iperc.Id_Persona_Empresa_Rol_Caract = Lt_Infopersonaempresarolcarac(Ln_Indice).Id_Persona_Empresa_Rol_Caract;
    END IF;

    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      Lv_Msgerror := 'Ha ocurrido un error inesperado: ' || SQLCODE || ' -ERROR- ' || Substr(SQLERRM,1,1000);
      Pv_Msgerror := Lv_Msgerror;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('TELCOS+',
                                           'CMKG_CONTACTO_MASIVO.P_ELIMINAR_TIPO_MASIVO',
                                           Pv_Msgerror,
                                           Lv_Usuario,
                                           SYSDATE,
                                           Lv_Ip);

  END P_ELIMINAR_TIPO_MASIVO;

  PROCEDURE P_ELIMINAR_MASIVO(Pn_Idcliente       IN NUMBER,
                              Pn_Idpersona       IN NUMBER,
                              Pcl_Extraparams    IN CLOB,
                              Pv_Msgerror        OUT VARCHAR2) AS

    CURSOR C_GetPersona(Ln_IdCliente NUMBER, Ln_IdPersona NUMBER, Lv_Codempresa VARCHAR2) IS
      SELECT DISTINCT Ip.* FROM (
        SELECT Ipb.*
        FROM DB_COMERCIAL.Info_Persona Ipa, DB_COMERCIAL.Info_Persona Ipb
        INNER JOIN DB_COMERCIAL.Info_Persona_Empresa_Rol Iper ON Iper.Persona_Id = Ipb.Id_Persona
        INNER JOIN DB_COMERCIAL.Info_Persona_Contacto Ipc ON Ipc.Contacto_Id = Ipb.Id_Persona
        INNER JOIN DB_COMERCIAL.Info_Empresa_Rol Ipr ON Iper.Empresa_Rol_Id = Ipr.Id_Empresa_Rol
        WHERE Ipc.Persona_Empresa_Rol_Id             = Ln_IdCliente
        AND Ipa.Id_Persona                           = Ln_IdPersona
        AND UPPER(Ipb.Nombres)                       = UPPER(Ipa.Nombres)
        AND UPPER(Ipb.Apellidos)                     = UPPER(Ipa.Apellidos)
        AND NVL(UPPER(Ipb.Tipo_Identificacion), '0') = NVL(UPPER(Ipa.Tipo_Identificacion), '0')
        AND NVL(Ipb.Identificacion_Cliente, '0')     = NVL(Ipa.Identificacion_Cliente, '0')
        AND Ipa.Origen_Prospecto                     = 'N'
        AND Ipr.Empresa_Cod                          = Lv_Codempresa
        AND Ipa.Estado                               <> 'Eliminado'
        AND Ipc.Estado                               <> 'Eliminado'
        AND Ipr.Estado                               <> 'Eliminado'
        UNION
        SELECT Ipb.*
        FROM DB_COMERCIAL.Info_Persona Ipa, DB_COMERCIAL.Info_Persona Ipb
        INNER JOIN DB_COMERCIAL.Info_Persona_Empresa_Rol Iper ON Iper.Persona_Id = Ipb.Id_Persona
        INNER JOIN DB_COMERCIAL.Info_Punto_Contacto Iptc ON Iptc.Contacto_Id = Iper.Persona_Id
        INNER JOIN DB_COMERCIAL.Info_Punto Ipt ON Ipt.Id_Punto = Iptc.Punto_Id
        INNER JOIN DB_COMERCIAL.Info_Empresa_Rol Ipr ON Iper.Empresa_Rol_Id = Ipr.Id_Empresa_Rol
        WHERE ipt.Persona_Empresa_Rol_Id             = Ln_IdCliente
        AND Ipa.Id_Persona                           = Ln_IdPersona
        AND UPPER(Ipb.Nombres)                       = UPPER(Ipa.Nombres)
        AND UPPER(Ipb.Apellidos)                     = UPPER(Ipa.Apellidos)
        AND NVL(UPPER(Ipb.Tipo_Identificacion), '0') = NVL(UPPER(Ipa.Tipo_Identificacion), '0')
        AND NVL(Ipb.Identificacion_Cliente, '0')     = NVL(Ipa.Identificacion_Cliente, '0')
        AND Ipa.Origen_Prospecto                     = 'N'
        AND Ipr.Empresa_Cod                          = Lv_Codempresa
        AND Ipa.Estado                               <> 'Eliminado'
        AND Iptc.Estado                              <> 'Eliminado'
        AND Ipr.Estado                               <> 'Eliminado'
      ) Ip;

    CURSOR C_GetIperPorPersona(Ln_IdCliente NUMBER, Ln_IdPersona NUMBER, Lv_Codempresa VARCHAR2) IS
      SELECT DISTINCT Iper.* FROM (
        SELECT Iper.*
          FROM DB_COMERCIAL.Info_Persona Ipa, DB_COMERCIAL.Info_Persona Ipb
          INNER JOIN DB_COMERCIAL.Info_Persona_Empresa_Rol Iper ON Iper.Persona_Id = Ipb.Id_Persona
          INNER JOIN DB_COMERCIAL.Info_Persona_Contacto Ipc ON Ipc.Contacto_Id = Ipb.Id_Persona
          INNER JOIN DB_COMERCIAL.Info_Empresa_Rol Ipr ON Iper.Empresa_Rol_Id = Ipr.Id_Empresa_Rol
          WHERE Ipc.Persona_Empresa_Rol_Id             = Ln_IdCliente
          AND Ipa.Id_Persona                           = Ln_IdPersona
          AND UPPER(Ipb.Nombres)                       = UPPER(Ipa.Nombres)
          AND UPPER(Ipb.Apellidos)                     = UPPER(Ipa.Apellidos)
          AND NVL(UPPER(Ipb.Tipo_Identificacion), '0') = NVL(UPPER(Ipa.Tipo_Identificacion), '0')
          AND NVL(Ipb.Identificacion_Cliente, '0')     = NVL(Ipa.Identificacion_Cliente, '0')
          AND Ipa.Origen_Prospecto                     = 'N'
          AND Ipr.Empresa_Cod                          = Lv_Codempresa
          AND Ipa.Estado                               <> 'Eliminado'
          AND Ipc.Estado                               <> 'Eliminado'
          AND Ipr.Estado                               <> 'Eliminado'
          UNION
          SELECT Iper.*
          FROM DB_COMERCIAL.Info_Persona Ipa, DB_COMERCIAL.Info_Persona Ipb
          INNER JOIN DB_COMERCIAL.Info_Persona_Empresa_Rol Iper ON Iper.Persona_Id = Ipb.Id_Persona
          INNER JOIN DB_COMERCIAL.Info_Punto_Contacto Iptc ON Iptc.Contacto_Id = Iper.Persona_Id
          INNER JOIN DB_COMERCIAL.Info_Punto Ipt ON Ipt.Id_Punto = Iptc.Punto_Id
          INNER JOIN DB_COMERCIAL.Info_Empresa_Rol Ipr ON Iper.Empresa_Rol_Id = Ipr.Id_Empresa_Rol
          WHERE Ipt.Persona_Empresa_Rol_Id             = Ln_IdCliente
          AND Ipa.Id_Persona                           = Ln_IdPersona
          AND UPPER(Ipb.Nombres)                       = UPPER(Ipa.Nombres)
          AND UPPER(Ipb.Apellidos)                     = UPPER(Ipa.Apellidos)
          AND NVL(UPPER(Ipb.Tipo_Identificacion), '0') = NVL(UPPER(Ipa.Tipo_Identificacion), '0')
          AND NVL(Ipb.Identificacion_Cliente, '0')     = NVL(Ipa.Identificacion_Cliente, '0')
          AND Ipa.Origen_Prospecto                     = 'N'
          AND Ipr.Empresa_Cod                          = Lv_Codempresa
          AND Ipa.Estado                               <> 'Eliminado'
          AND Iptc.Estado                              <> 'Eliminado'
          AND Ipr.Estado                               <> 'Eliminado'
        ) Iper;

   CURSOR C_GetIPersonaContacto(Ln_IdCliente NUMBER, Ln_IdPersona NUMBER, Lv_Codempresa VARCHAR2) IS
      SELECT DISTINCT Ipc.*
        FROM DB_COMERCIAL.Info_Persona Ipa, DB_COMERCIAL.Info_Persona Ipb
        INNER JOIN DB_COMERCIAL.Info_Persona_Empresa_Rol Iper ON Iper.Persona_Id = Ipb.Id_Persona
        INNER JOIN DB_COMERCIAL.Info_Persona_Contacto Ipc ON Ipc.Contacto_Id = Ipb.Id_Persona
        INNER JOIN DB_COMERCIAL.Info_Empresa_Rol Ipr ON Iper.Empresa_Rol_Id = Ipr.Id_Empresa_Rol
        WHERE Ipc.Persona_Empresa_Rol_Id             = Ln_IdCliente
        AND Ipa.Id_Persona                           = Ln_IdPersona
        AND UPPER(Ipb.Nombres)                       = UPPER(Ipa.Nombres)
        AND UPPER(Ipb.Apellidos)                     = UPPER(Ipa.Apellidos)
        AND NVL(UPPER(Ipb.Tipo_Identificacion), '0') = NVL(UPPER(Ipa.Tipo_Identificacion), '0')
        AND NVL(Ipb.Identificacion_Cliente, '0')     = NVL(Ipa.Identificacion_Cliente, '0')
        AND Ipa.Origen_Prospecto                     = 'N'
        AND Ipr.Empresa_Cod                          = Lv_Codempresa
        AND Ipa.Estado                               <> 'Eliminado'
        AND Ipc.Estado                               <> 'Eliminado'
        AND Ipr.Estado                               <> 'Eliminado';

    CURSOR C_GetIPuntoContacto(Ln_IdCliente NUMBER, Ln_IdPersona NUMBER, Lv_Codempresa VARCHAR2) IS
      SELECT DISTINCT Iptc.*
        FROM DB_COMERCIAL.Info_Persona Ipa, DB_COMERCIAL.Info_Persona Ipb
        INNER JOIN DB_COMERCIAL.Info_Persona_Empresa_Rol Iper ON Iper.Persona_Id = Ipb.Id_Persona
        INNER JOIN DB_COMERCIAL.Info_Punto_Contacto Iptc ON Iptc.Contacto_Id = Iper.Persona_Id
        INNER JOIN DB_COMERCIAL.Info_Punto Ipt ON Ipt.Id_Punto = Iptc.Punto_Id
        INNER JOIN DB_COMERCIAL.Info_Empresa_Rol Ipr ON Iper.Empresa_Rol_Id = Ipr.Id_Empresa_Rol
        WHERE Ipt.Persona_Empresa_Rol_Id             = Ln_IdCliente
        AND Ipa.Id_Persona                           = Ln_IdPersona
        AND UPPER(Ipb.Nombres)                       = UPPER(Ipa.Nombres)
        AND UPPER(Ipb.Apellidos)                     = UPPER(Ipa.Apellidos)
        AND NVL(UPPER(Ipb.Tipo_Identificacion), '0') = NVL(UPPER(Ipa.Tipo_Identificacion), '0')
        AND NVL(Ipb.Identificacion_Cliente, '0')     = NVL(Ipa.Identificacion_Cliente, '0')
        AND Ipa.Origen_Prospecto                     = 'N'
        AND Ipr.Empresa_Cod                          = Lv_Codempresa
        AND Ipa.Estado                               <> 'Eliminado'
        AND Iptc.Estado                              <> 'Eliminado'
        AND Ipr.Estado                               <> 'Eliminado';

    Ln_Indice_Iper                 NUMBER := 1;
    Ln_Idoficina                   NUMBER := 0;
    Lv_Codempresa                  VARCHAR2(32767);
    Lv_Usuario                     VARCHAR2(32767);
    Lv_Ip                          VARCHAR2(32767);
    Lv_Msgerror                    VARCHAR2(32767);
    Lr_Infopersonaempresarolhisto  DB_COMERCIAL.Info_Persona_Empresa_Rol_Histo%ROWTYPE;
    Lt_Infopersonaempresarol       T_Array_Iper;
    Lt_Infopersonaempresarolhisto  T_Array_Iperh;
    Lt_Infopersonacontacto         T_Array_Ipercont;
    Lt_Infopuntocontacto           T_Array_Ipuncont;
    Lt_Infopersona                 T_Array_Ip;

  BEGIN
    APEX_JSON.PARSE(Pcl_Extraparams);
    Ln_Idoficina          := APEX_JSON.GET_NUMBER('intIdOficina');
    Lv_Codempresa         := APEX_JSON.GET_VARCHAR2('strCodEmpresa');
    Lv_Usuario            := APEX_JSON.GET_VARCHAR2('strUsuario');
    Lv_Ip                 := APEX_JSON.GET_VARCHAR2('strIp');

    OPEN C_GetPersona(Pn_Idcliente, Pn_Idpersona, Lv_Codempresa);
      FETCH C_GetPersona BULK COLLECT INTO Lt_Infopersona LIMIT 100000;
    CLOSE C_GetPersona;

    OPEN C_GetIperPorPersona(Pn_Idcliente, Pn_Idpersona, Lv_Codempresa);
      FETCH C_GetIperPorPersona BULK COLLECT INTO Lt_Infopersonaempresarol LIMIT 100000;
    CLOSE C_GetIperPorPersona;

    OPEN C_GetIPersonaContacto(Pn_Idcliente, Pn_Idpersona, Lv_Codempresa);
      FETCH C_GetIPersonaContacto BULK COLLECT INTO Lt_Infopersonacontacto LIMIT 100000;
    CLOSE C_GetIPersonaContacto;

    OPEN C_GetIPuntoContacto(Pn_Idcliente, Pn_Idpersona, Lv_Codempresa);
      FETCH C_GetIPuntoContacto BULK COLLECT INTO Lt_Infopuntocontacto LIMIT 100000;
    CLOSE C_GetIPuntoContacto;

    WHILE Ln_Indice_Iper <= Lt_Infopersonaempresarol.COUNT LOOP
          Lr_Infopersonaempresarolhisto.Id_Persona_Empresa_Rol_Histo := DB_COMERCIAL.Seq_Info_Persona_Empresa_Rol_H.NEXTVAL;
          Lr_Infopersonaempresarolhisto.Usr_Creacion                 := Lv_Usuario;
          Lr_Infopersonaempresarolhisto.Fe_Creacion                  := SYSDATE;
          Lr_Infopersonaempresarolhisto.Ip_Creacion                  := Lv_Ip;
          Lr_Infopersonaempresarolhisto.Estado                       := 'Eliminado';
          Lr_Infopersonaempresarolhisto.Persona_Empresa_Rol_Id       := Lt_Infopersonaempresarol(Ln_Indice_Iper).Id_Persona_Rol;
          Lr_Infopersonaempresarolhisto.Oficina_Id                   := Ln_Idoficina;

          Lt_Infopersonaempresarolhisto(Lt_Infopersonaempresarolhisto.COUNT) := Lr_Infopersonaempresarolhisto;

          Ln_Indice_Iper := Ln_Indice_Iper + 1;
    END LOOP;

    IF Lt_Infopersonaempresarolhisto.COUNT > 0 THEN
      FORALL Ln_Indice IN Lt_Infopersonaempresarolhisto.FIRST .. Lt_Infopersonaempresarolhisto.LAST SAVE EXCEPTIONS
        INSERT INTO DB_COMERCIAL.Info_Persona_Empresa_Rol_Histo VALUES Lt_Infopersonaempresarolhisto(Ln_Indice);
    END IF;

    IF Lt_Infopersonacontacto.COUNT > 0 THEN
      FORALL Ln_Indice IN Lt_Infopersonacontacto.FIRST .. Lt_Infopersonacontacto.LAST SAVE EXCEPTIONS
        UPDATE DB_COMERCIAL.Info_Persona_Contacto Ipc
        SET Ipc.Estado = 'Eliminado'
        WHERE Ipc.Id_Persona_Contacto = Lt_Infopersonacontacto(Ln_Indice).Id_Persona_Contacto;
    END IF;

    IF Lt_Infopuntocontacto.COUNT > 0 THEN
      FORALL Ln_Indice IN Lt_Infopuntocontacto.FIRST .. Lt_Infopuntocontacto.LAST SAVE EXCEPTIONS
        UPDATE DB_COMERCIAL.Info_Punto_Contacto Ipc
        SET Ipc.Estado = 'Eliminado'
        WHERE Ipc.Id_Punto_Contacto = Lt_Infopuntocontacto(Ln_Indice).Id_Punto_Contacto;
    END IF;

    IF Lt_Infopersonaempresarol.COUNT > 0 THEN
      FORALL Ln_Indice IN Lt_Infopersonaempresarol.FIRST .. Lt_Infopersonaempresarol.LAST SAVE EXCEPTIONS
        UPDATE DB_COMERCIAL.Info_Persona_Empresa_Rol Iper
        SET Iper.Estado = 'Eliminado',
            Iper.Fe_Ult_Mod = SYSDATE
        WHERE Iper.Id_Persona_Rol = Lt_Infopersonaempresarol(Ln_Indice).Id_Persona_Rol;
    END IF;

    IF Lt_Infopersona.COUNT > 0 THEN
      FORALL Ln_Indice IN Lt_Infopersona.FIRST .. Lt_Infopersona.LAST SAVE EXCEPTIONS
        UPDATE DB_COMERCIAL.Info_Persona Ip
        SET Ip.Estado = 'Eliminado'
        WHERE Ip.Id_Persona = Lt_Infopersona(Ln_Indice).Id_Persona;
    END IF;



    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      Lv_Msgerror := 'Ha ocurrido un error inesperado: ' || SQLCODE || ' -ERROR- ' || Substr(SQLERRM,1,1000);
      Pv_Msgerror := Lv_Msgerror;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('TELCOS+',
                                           'CMKG_CONTACTO_MASIVO.P_ELIMINAR_MASIVO',
                                           Pv_Msgerror,
                                           Lv_Usuario,
                                           SYSDATE,
                                           Lv_Ip);
   END P_ELIMINAR_MASIVO;

  PROCEDURE P_DUPLICAR_MASIVO(Pcl_Idroles             IN CLOB,
                              Pcl_Idpuntos            IN CLOB,
                              Pcl_Extraparams         IN CLOB,
                              Pn_Idcliente            IN NUMBER,
                              Pn_Idpersona            IN NUMBER,
                              Pn_Duplica_Cliente      IN NUMBER,
                              Pn_Login_Repetidos      OUT NUMBER,
                              Pv_Login_Repetidos      OUT VARCHAR2,
                              Pv_Msg_Nivel_Cliente    OUT VARCHAR2,
                              Pv_Msgerror             OUT VARCHAR2) AS

    CURSOR C_GetDescripcionRol(Ln_Idempresarol NUMBER, Lv_Empresacod VARCHAR2 ) IS
      SELECT NVL(Ar.Descripcion_Rol,'')
        FROM DB_COMERCIAL.Admi_Rol Ar
        WHERE Ar.Id_Rol IN (
          SELECT MAX(Ar.Id_Rol)
              FROM DB_COMERCIAL.Admi_Rol Ar
              INNER JOIN DB_COMERCIAL.Info_Empresa_Rol Ier ON Ar.Id_Rol = Ier.Rol_Id
              WHERE Ier.Id_Empresa_Rol = Ln_Idempresarol
              AND Ier.Empresa_Cod      = Lv_Empresacod
              AND Ar.Estado            = 'Activo'
              AND Ier.Estado           = 'Activo'
          );

    CURSOR C_GetIdempresarol(Ln_Id_Rol NUMBER, Lv_Codempresa VARCHAR2) IS
      SELECT NVL(Ier.Id_Empresa_Rol,0)
        FROM DB_COMERCIAL.Info_Empresa_Rol Ier
        WHERE Ier.Id_Empresa_Rol IN (
            SELECT MAX(Ier.Id_Empresa_Rol)
            FROM DB_COMERCIAL.Info_Empresa_Rol Ier
            WHERE Ier.Rol_Id    = Ln_Id_Rol
            AND Ier.Empresa_Cod = Lv_Codempresa
            AND Ier.Estado      = 'Activo'
        );

    CURSOR C_GetCaracPorDesc(Lv_Desc VARCHAR2) IS
      SELECT NVL(Ac.Id_Caracteristica,0)
        FROM DB_COMERCIAL.Admi_caracteristica Ac
        WHERE Ac.Id_Caracteristica IN (
            SELECT MAX(Ac.Id_Caracteristica)
                FROM DB_COMERCIAL.Admi_Caracteristica Ac
                WHERE Ac.Descripcion_Caracteristica = Lv_Desc
                AND Ac.Estado                       = 'Activo'
            );

    CURSOR C_GetCountIpuntoc(Ln_Idpersona NUMBER, Ln_Id_Punto NUMBER) IS
      SELECT COUNT(Ipc.Id_Punto_Contacto)
      FROM DB_COMERCIAL.Info_Punto_Contacto Ipc
      WHERE Ipc.Contacto_Id = Ln_Idpersona
      AND Ipc.Punto_Id      = Ln_Id_Punto
      AND Ipc.Estado        = 'Activo';

    CURSOR C_GetCountIpersonac(Ln_Idpersona NUMBER, Ln_Idcliente NUMBER) IS
      SELECT NVL(COUNT(Ipc.Id_Persona_Contacto), 0)
      FROM DB_COMERCIAL.Info_Persona_Contacto Ipc
      WHERE Ipc.Contacto_Id          = Ln_Idpersona
      AND Ipc.Persona_Empresa_Rol_Id = Ln_Idcliente
      AND Ipc.Estado                 = 'Activo';

    CURSOR C_GetLogin(Ln_Id_Punto NUMBER) IS
      SELECT NVL(Ip.Login,'')
      FROM DB_COMERCIAL.Info_Punto Ip
      WHERE Ip.Id_Punto = Ln_Id_Punto;

    CURSOR C_GetEmpleadoRol(Ln_Idpersona NUMBER, Ln_Id_Rol NUMBER) IS
      SELECT id_persona_rol
      FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL Iper
      WHERE Iper.Persona_id = Ln_Idpersona 
      AND   Iper.Empresa_Rol_Id = Ln_Id_Rol;

    Ln_Id_Rol                      NUMBER := 0;
    Ln_Id_Punto                    NUMBER := 0;
    Ln_Cantidad_Ipersonac          NUMBER := 0;
    Ln_Indice2                     NUMBER := 0;
    Ln_Cantidad_Ipuntoc            NUMBER := 0;
    Ln_Persona_Empresa_Rol_Id      NUMBER := 0;
    Ln_Id_Empresa_Rol              NUMBER := 0;
    Ln_Contador_Login              NUMBER := 0;
    Ln_Contador_Aux                NUMBER := 0;
    Ln_Indice_Rol                  NUMBER := 0;
    Ln_Indice_Punto                NUMBER := 0;
    Ln_Duplica_Cliente             NUMBER := 0;
    Ln_Primera_Iteracion_Rol       NUMBER := 1;
    Ln_Id_Escalabilidad            NUMBER := 0;
    Ln_Id_Horario                  NUMBER := 0;
    Ln_Idoficina                   NUMBER := 0;
    Ln_Limite_Login                NUMBER := 0;
    Lv_Separador                   VARCHAR2(1) := ',';
    Lv_Codempresa                  VARCHAR2(32767);
    Lv_Usuario                     VARCHAR2(32767);
    Lv_Ip                          VARCHAR2(32767);
    Lv_Descripcion_Rol             VARCHAR2(32767);
    Lv_Descripcion_Carac1          VARCHAR2(32767);
    Lv_Descripcion_Carac2          VARCHAR2(32767);
    Lv_Descripcion_Rol_Actual      VARCHAR2(32767);
    Lv_Escalabilidad               VARCHAR2(32767);
    Lv_Horario                     VARCHAR2(32767);
    Lv_Msgerror                    VARCHAR2(32767);
    Lv_Login_Actual                VARCHAR2(32767);
    Lv_Login_Repetidos             VARCHAR2(32767);
    T_Idroles                      T_Array_Id;
    T_Idpuntos                     T_Array_Id;
    Lr_Infopersonaempresarol       DB_COMERCIAL.Info_Persona_Empresa_Rol%ROWTYPE;
    Lr_Infopersonaempresarolhisto  DB_COMERCIAL.Info_Persona_Empresa_Rol_Histo%ROWTYPE;
    Lr_Infopersonaempresarolcarac  DB_COMERCIAL.Info_Persona_Empresa_Rol_Carac%ROWTYPE;
    Lr_Infopersonacontacto         DB_COMERCIAL.Info_Persona_Contacto%ROWTYPE;
    Lr_Infopuntocontacto           DB_COMERCIAL.Info_Punto_Contacto%ROWTYPE;
    Lt_Infopersonaempresarol       T_Array_Iper;
    Lt_Infopersonaempresarolhisto  T_Array_Iperh;
    Lt_Infopersonaempresarolcarac  T_Array_Iperc;
    Lt_Infopersonacontacto         T_Array_Ipercont;
    Lt_Infopuntocontacto           T_Array_Ipuncont;
    Ln_Duplicar                    NUMBER := 0;


  BEGIN

    APEX_JSON.PARSE(Pcl_Extraparams);
    Ln_Idoficina          := APEX_JSON.GET_NUMBER('intIdOficina');
    Ln_Limite_Login       := APEX_JSON.GET_NUMBER('intLoginLimite');
    Lv_Codempresa         := APEX_JSON.GET_VARCHAR2('strCodEmpresa');
    Lv_Usuario            := APEX_JSON.GET_VARCHAR2('strUsuario');
    Lv_Ip                 := APEX_JSON.GET_VARCHAR2('strIp');
    Lv_Descripcion_Rol    := APEX_JSON.GET_VARCHAR2('strDescripcionRol1');
    Lv_Descripcion_Carac1 := APEX_JSON.GET_VARCHAR2('strDescripcionCarac1');
    Lv_Descripcion_Carac2 := APEX_JSON.GET_VARCHAR2('strDescripcionCarac2');
    Lv_Escalabilidad      := APEX_JSON.GET_VARCHAR2('strEscalabilidad');
    Lv_Horario            := APEX_JSON.GET_VARCHAR2('strHorario');

    Ln_Duplica_Cliente := NVL(Pn_Duplica_Cliente,0);

    IF Ln_Duplica_Cliente = 1 THEN
      OPEN C_GetCountIpersonac(Pn_Idpersona,Pn_Idcliente);
        FETCH C_GetCountIpersonac INTO Ln_Cantidad_Ipersonac;
      CLOSE C_GetCountIpersonac;

      IF Ln_Cantidad_Ipersonac > 0 THEN
        Pv_Msg_Nivel_Cliente := 'Contacto ya existente a nivel cliente.';
      END IF;
    END IF;

    OPEN C_GetCaracPorDesc(Lv_Descripcion_Carac1);
      FETCH C_GetCaracPorDesc INTO Ln_Id_Escalabilidad;
    CLOSE C_GetCaracPorDesc;

    OPEN C_GetCaracPorDesc(Lv_Descripcion_Carac2);
      FETCH C_GetCaracPorDesc INTO Ln_Id_Horario;
    CLOSE C_GetCaracPorDesc;

    T_Idroles  := F_SPLIT_CLOB(Pcl_Idroles,Lv_Separador);
    T_Idpuntos := F_SPLIT_CLOB(Pcl_Idpuntos,Lv_Separador);

    WHILE Ln_Indice_Rol < T_Idroles.COUNT LOOP
      IF NOT T_Idroles.EXISTS(Ln_Indice_Rol) OR T_Idroles(Ln_Indice_Rol) IS NULL OR T_Idroles(Ln_Indice_Rol) <= 0 THEN
        Ln_Indice_Rol := Ln_Indice_Rol + 1;
        CONTINUE;
      END IF;

      Ln_Id_Rol := T_Idroles(Ln_Indice_Rol);

      OPEN C_GetIdempresarol(Ln_Id_Rol,Lv_Codempresa);
        FETCH C_GetIdempresarol INTO Ln_Id_Empresa_Rol;
      CLOSE C_GetIdempresarol;

      IF Ln_Id_Empresa_Rol <= 0 THEN
        CONTINUE;
      END IF;

      OPEN C_GetEmpleadoRol(Pn_Idpersona,Ln_Id_Rol);
        FETCH C_GetEmpleadoRol INTO Ln_Persona_Empresa_Rol_Id;
      CLOSE C_GetEmpleadoRol;
      Ln_Duplicar := 0;

      IF Ln_Persona_Empresa_Rol_Id IS NULL THEN
        Ln_Duplicar := 1;
        Ln_Persona_Empresa_Rol_Id := DB_COMERCIAL.Seq_Info_Persona_Empresa_Rol.NEXTVAL;
  
        Lr_Infopersonaempresarol.Id_Persona_Rol                 := Ln_Persona_Empresa_Rol_Id;
        Lr_Infopersonaempresarol.Persona_Id                     := Pn_Idpersona;
        Lr_Infopersonaempresarol.Empresa_Rol_Id                 := Ln_Id_Rol;
        Lr_Infopersonaempresarol.Oficina_Id                     := Ln_Idoficina;
        Lr_Infopersonaempresarol.Estado                         := 'Activo';
        Lr_Infopersonaempresarol.Usr_Creacion                   := Lv_Usuario;
        Lr_Infopersonaempresarol.Fe_Creacion                    := SYSDATE;
        Lr_Infopersonaempresarol.Ip_Creacion                    := Lv_Ip;
        Lr_Infopersonaempresarol.Usr_Ult_Mod                    := Lv_Usuario;
        Lr_Infopersonaempresarol.Fe_Ult_Mod                     := SYSDATE;
  
        Lr_Infopersonaempresarolhisto.Id_Persona_Empresa_Rol_Histo   := DB_COMERCIAL.Seq_Info_Persona_Empresa_Rol_H.NEXTVAL;
        Lr_Infopersonaempresarolhisto.Usr_Creacion                   := Lv_Usuario;
        Lr_Infopersonaempresarolhisto.Fe_Creacion                    := SYSDATE;
        Lr_Infopersonaempresarolhisto.Ip_Creacion                    := Lv_Ip;
        Lr_Infopersonaempresarolhisto.Estado                         := 'Activo';
        Lr_Infopersonaempresarolhisto.Persona_Empresa_Rol_Id         := Ln_Persona_Empresa_Rol_Id;
        Lr_Infopersonaempresarolhisto.Oficina_Id                     := Ln_Idoficina;
  
        Lt_Infopersonaempresarol(Lt_Infopersonaempresarol.COUNT)           := Lr_Infopersonaempresarol;
        Lt_Infopersonaempresarolhisto(Lt_Infopersonaempresarolhisto.COUNT) := Lr_Infopersonaempresarolhisto;
      END IF;


      IF Ln_Duplica_Cliente = 1 AND Ln_Cantidad_Ipersonac = 0 THEN
        /*Ln_Persona_Empresa_Rol_Id := DB_COMERCIAL.Seq_Info_Persona_Empresa_Rol.NEXTVAL;

        Lr_Infopersonaempresarol.Id_Persona_Rol := Ln_Persona_Empresa_Rol_Id;
        Lr_Infopersonaempresarol.Persona_Id     := Pn_Idpersona;
        Lr_Infopersonaempresarol.Empresa_Rol_Id := Ln_Id_Empresa_Rol;
        Lr_Infopersonaempresarol.Oficina_Id     := Ln_Idoficina;
        Lr_Infopersonaempresarol.Estado         := 'Activo';
        Lr_Infopersonaempresarol.Usr_Creacion   := Lv_Usuario;
        Lr_Infopersonaempresarol.Fe_Creacion    := SYSDATE;
        Lr_Infopersonaempresarol.Ip_Creacion    := Lv_Ip;
        Lr_Infopersonaempresarol.Usr_Ult_Mod    := Lv_Usuario;
        Lr_Infopersonaempresarol.Fe_Ult_Mod     := SYSDATE;

        Lr_Infopersonaempresarolhisto.Id_Persona_Empresa_Rol_Histo := DB_COMERCIAL.Seq_Info_Persona_Empresa_Rol_H.NEXTVAL;
        Lr_Infopersonaempresarolhisto.Usr_Creacion                 := Lv_Usuario;
        Lr_Infopersonaempresarolhisto.Fe_Creacion                  := SYSDATE;
        Lr_Infopersonaempresarolhisto.Ip_Creacion                  := Lv_Ip;
        Lr_Infopersonaempresarolhisto.Estado                       := 'Activo';
        Lr_Infopersonaempresarolhisto.Persona_Empresa_Rol_Id       := Ln_Persona_Empresa_Rol_Id;
        Lr_Infopersonaempresarolhisto.Oficina_Id                   := Ln_Idoficina;*/

        Lr_Infopersonacontacto.Id_Persona_Contacto    := DB_COMERCIAL.Seq_Info_Persona_Contacto.NEXTVAL;
        Lr_Infopersonacontacto.Contacto_Id            := Pn_Idpersona;
        Lr_Infopersonacontacto.Estado                 := 'Activo';
        Lr_Infopersonacontacto.Fe_Creacion            := SYSDATE;
        Lr_Infopersonacontacto.Usr_Creacion           := Lv_Usuario;
        Lr_Infopersonacontacto.Ip_Creacion            := Lv_Ip;
        Lr_Infopersonacontacto.Persona_Empresa_Rol_Id := Pn_Idcliente;
        Lr_Infopersonacontacto.Persona_Rol_Id         := Ln_Persona_Empresa_Rol_Id;

        --Lt_Infopersonaempresarol(Lt_Infopersonaempresarol.COUNT)           := Lr_Infopersonaempresarol;
        --Lt_Infopersonaempresarolhisto(Lt_Infopersonaempresarolhisto.COUNT) := Lr_Infopersonaempresarolhisto;
        Lt_Infopersonacontacto(Lt_Infopersonacontacto.COUNT)               := Lr_Infopersonacontacto;

        OPEN C_GetDescripcionRol(Ln_Id_Rol,Lv_Codempresa);
          FETCH C_GetDescripcionRol INTO Lv_Descripcion_Rol_Actual;
        CLOSE C_GetDescripcionRol;

        IF UPPER(Lv_Descripcion_Rol) = UPPER(Lv_Descripcion_Rol_Actual) THEN
          Lr_Infopersonaempresarolcarac.Id_Persona_Empresa_Rol_Caract := DB_COMERCIAL.Seq_Info_Persona_Emp_Rol_Carac.NEXTVAL;
          Lr_Infopersonaempresarolcarac.Persona_Empresa_Rol_Id        := Ln_Persona_Empresa_Rol_Id;
          Lr_Infopersonaempresarolcarac.Caracteristica_Id             := Ln_Id_Escalabilidad;
          Lr_Infopersonaempresarolcarac.Valor                         := Lv_Escalabilidad;
          Lr_Infopersonaempresarolcarac.Fe_Creacion                   := SYSDATE;
          Lr_Infopersonaempresarolcarac.Fe_Ult_Mod                    := SYSDATE;
          Lr_Infopersonaempresarolcarac.Usr_Creacion                  := Lv_Usuario;
          Lr_Infopersonaempresarolcarac.Usr_Ult_Mod                   := Lv_Usuario;
          Lr_Infopersonaempresarolcarac.Ip_Creacion                   := Lv_Ip;
          Lr_Infopersonaempresarolcarac.Estado                        := 'Activo';

          Lt_Infopersonaempresarolcarac(Lt_Infopersonaempresarolcarac.COUNT) := Lr_Infopersonaempresarolcarac;

          Lr_Infopersonaempresarolcarac.Id_Persona_Empresa_Rol_Caract := DB_COMERCIAL.Seq_Info_Persona_Emp_Rol_Carac.NEXTVAL;
          Lr_Infopersonaempresarolcarac.Persona_Empresa_Rol_Id        := Ln_Persona_Empresa_Rol_Id;
          Lr_Infopersonaempresarolcarac.Caracteristica_Id             := Ln_Id_Horario;
          Lr_Infopersonaempresarolcarac.Valor                         := Lv_Horario;
          Lr_Infopersonaempresarolcarac.Fe_Creacion                   := SYSDATE;
          Lr_Infopersonaempresarolcarac.Fe_Ult_Mod                    := SYSDATE;
          Lr_Infopersonaempresarolcarac.Usr_Creacion                  := Lv_Usuario;
          Lr_Infopersonaempresarolcarac.Usr_Ult_Mod                   := Lv_Usuario;
          Lr_Infopersonaempresarolcarac.Ip_Creacion                   := Lv_Ip;
          Lr_Infopersonaempresarolcarac.Estado                        := 'Activo';

          Lt_Infopersonaempresarolcarac(Lt_Infopersonaempresarolcarac.COUNT) := Lr_Infopersonaempresarolcarac;
        END IF;
      END IF;

      IF T_Idpuntos.COUNT > 0 THEN
        WHILE Ln_Indice_Punto < T_Idpuntos.COUNT LOOP
          IF NOT T_Idpuntos.EXISTS(Ln_Indice_Punto) OR T_Idpuntos(Ln_Indice_Punto) IS NULL OR T_Idpuntos(Ln_Indice_Punto) <= 0 THEN
            Ln_Indice_Punto := Ln_Indice_Punto + 1;
            CONTINUE;
          END IF;

          Ln_Id_Punto := T_Idpuntos(Ln_Indice_Punto);

          OPEN C_GetCountIpuntoc(Pn_Idpersona, Ln_Id_Punto);
            FETCH C_GetCountIpuntoc INTO Ln_Cantidad_Ipuntoc;
          CLOSE C_GetCountIpuntoc;

          IF Ln_Cantidad_Ipuntoc > 0 AND Ln_Primera_Iteracion_Rol = 1 THEN
            Ln_Contador_Login := Ln_Contador_Login + 1;

            OPEN C_GetLogin(Ln_Id_Punto);
              FETCH C_GetLogin INTO Lv_Login_Actual;
            CLOSE C_GetLogin;

            IF Ln_Contador_Aux = 0 OR ( Ln_Contador_Aux < Ln_Limite_Login AND Instr(Lv_Login_Repetidos,Lv_Login_Actual || ',') <= 0 ) THEN
              Lv_Login_Repetidos := Lv_Login_Repetidos || Lv_Login_Actual || ',';
              Ln_Contador_Aux := Ln_Contador_Aux + 1;
              END IF;
          END IF;

          IF Ln_Cantidad_Ipuntoc <= 0 THEN
            /*Ln_Persona_Empresa_Rol_Id := DB_COMERCIAL.Seq_Info_Persona_Empresa_Rol.NEXTVAL;

            Lr_Infopersonaempresarol.Id_Persona_Rol                 := Ln_Persona_Empresa_Rol_Id;
            Lr_Infopersonaempresarol.Persona_Id                     := Pn_Idpersona;
            Lr_Infopersonaempresarol.Empresa_Rol_Id                 := Ln_Id_Empresa_Rol;
            Lr_Infopersonaempresarol.Oficina_Id                     := Ln_Idoficina;
            Lr_Infopersonaempresarol.Estado                         := 'Activo';
            Lr_Infopersonaempresarol.Usr_Creacion                   := Lv_Usuario;
            Lr_Infopersonaempresarol.Fe_Creacion                    := SYSDATE;
            Lr_Infopersonaempresarol.Ip_Creacion                    := Lv_Ip;
            Lr_Infopersonaempresarol.Usr_Ult_Mod                    := Lv_Usuario;
            Lr_Infopersonaempresarol.Fe_Ult_Mod                     := SYSDATE;

            Lr_Infopersonaempresarolhisto.Id_Persona_Empresa_Rol_Histo   := DB_COMERCIAL.Seq_Info_Persona_Empresa_Rol_H.NEXTVAL;
            Lr_Infopersonaempresarolhisto.Usr_Creacion                   := Lv_Usuario;
            Lr_Infopersonaempresarolhisto.Fe_Creacion                    := SYSDATE;
            Lr_Infopersonaempresarolhisto.Ip_Creacion                    := Lv_Ip;
            Lr_Infopersonaempresarolhisto.Estado                         := 'Activo';
            Lr_Infopersonaempresarolhisto.Persona_Empresa_Rol_Id         := Ln_Persona_Empresa_Rol_Id;
            Lr_Infopersonaempresarolhisto.Oficina_Id                     := Ln_Idoficina;*/

            Lr_Infopuntocontacto.Id_Punto_Contacto      := DB_COMERCIAL.Seq_Info_Punto_Contacto.NEXTVAL;
            Lr_Infopuntocontacto.Contacto_Id            := Pn_Idpersona;
            Lr_Infopuntocontacto.Estado                 := 'Activo';
            Lr_Infopuntocontacto.Fe_Creacion            := SYSDATE;
            Lr_Infopuntocontacto.Usr_Creacion           := Lv_Usuario;
            Lr_Infopuntocontacto.Ip_Creacion            := Lv_Ip;
            Lr_Infopuntocontacto.Punto_Id               := Ln_Id_Punto;
            Lr_Infopuntocontacto.Persona_Empresa_Rol_Id := Ln_Persona_Empresa_Rol_Id;

           -- Lt_Infopersonaempresarol(Lt_Infopersonaempresarol.COUNT)           := Lr_Infopersonaempresarol;
           -- Lt_Infopersonaempresarolhisto(Lt_Infopersonaempresarolhisto.COUNT) := Lr_Infopersonaempresarolhisto;
            Lt_Infopuntocontacto(Lt_Infopuntocontacto.COUNT)                   := Lr_Infopuntocontacto;
          END IF;

          OPEN C_GetDescripcionRol(Ln_Id_Rol,Lv_Codempresa);
            FETCH C_GetDescripcionRol INTO Lv_Descripcion_Rol_Actual;
          CLOSE C_GetDescripcionRol;

          IF UPPER(Lv_Descripcion_Rol) = UPPER(Lv_Descripcion_Rol_Actual) THEN
            Lr_Infopersonaempresarolcarac.Id_Persona_Empresa_Rol_Caract := DB_COMERCIAL.Seq_Info_Persona_Emp_Rol_Carac.NEXTVAL;
            Lr_Infopersonaempresarolcarac.Persona_Empresa_Rol_Id        := Ln_Persona_Empresa_Rol_Id;
            Lr_Infopersonaempresarolcarac.Caracteristica_Id             := Ln_Id_Escalabilidad;
            Lr_Infopersonaempresarolcarac.Valor                         := Lv_Escalabilidad;
            Lr_Infopersonaempresarolcarac.Fe_Creacion                   := SYSDATE;
            Lr_Infopersonaempresarolcarac.Fe_Ult_Mod                    := SYSDATE;
            Lr_Infopersonaempresarolcarac.Usr_Creacion                  := Lv_Usuario;
            Lr_Infopersonaempresarolcarac.Usr_Ult_Mod                   := Lv_Usuario;
            Lr_Infopersonaempresarolcarac.Ip_Creacion                   := Lv_Ip;
            Lr_Infopersonaempresarolcarac.Estado                        := 'Activo';

            Lt_Infopersonaempresarolcarac(Lt_Infopersonaempresarolcarac.COUNT) := Lr_Infopersonaempresarolcarac;

            Lr_Infopersonaempresarolcarac.Id_Persona_Empresa_Rol_Caract := DB_COMERCIAL.Seq_Info_Persona_Emp_Rol_Carac.NEXTVAL;
            Lr_Infopersonaempresarolcarac.Persona_Empresa_Rol_Id        := Ln_Persona_Empresa_Rol_Id;
            Lr_Infopersonaempresarolcarac.Caracteristica_Id             := Ln_Id_Horario;
            Lr_Infopersonaempresarolcarac.Valor                         := Lv_Horario;
            Lr_Infopersonaempresarolcarac.Fe_Creacion                   := SYSDATE;
            Lr_Infopersonaempresarolcarac.Fe_Ult_Mod                    := SYSDATE;
            Lr_Infopersonaempresarolcarac.Usr_Creacion                  := Lv_Usuario;
            Lr_Infopersonaempresarolcarac.Usr_Ult_Mod                   := Lv_Usuario;
            Lr_Infopersonaempresarolcarac.Ip_Creacion                   := Lv_Ip;
            Lr_Infopersonaempresarolcarac.Estado                        := 'Activo';

            Lt_Infopersonaempresarolcarac(Lt_Infopersonaempresarolcarac.COUNT) := Lr_Infopersonaempresarolcarac;
          END IF;

          Ln_Indice_Punto := Ln_Indice_Punto + 1;

        END LOOP;
      END IF;

      Ln_Primera_Iteracion_Rol := 0;
      Ln_Indice_Rol            := Ln_Indice_Rol + 1;
      Ln_Indice_Punto          := 0;

    END LOOP;

    IF Ln_Duplicar = 1 THEN
      IF Lt_Infopersonaempresarol.COUNT > 0 THEN
        Ln_Indice2 :=0;
        WHILE Ln_Indice2 < Lt_Infopersonaempresarol.COUNT loop
        --FOR Ln_Indice IN Lt_Infopersonaempresarol.FIRST .. Lt_Infopersonaempresarol.LAST loop 
          INSERT INTO DB_COMERCIAL.Info_Persona_Empresa_Rol VALUES Lt_Infopersonaempresarol ( Ln_Indice2 );
          Ln_Indice2 := Ln_Indice2+1;
        end loop;
      END IF;
  
      IF Lt_Infopersonaempresarolhisto.COUNT > 0 THEN
        FORALL Ln_Indice IN Lt_Infopersonaempresarolhisto.FIRST .. Lt_Infopersonaempresarolhisto.LAST SAVE EXCEPTIONS
          INSERT INTO DB_COMERCIAL.Info_Persona_Empresa_Rol_Histo VALUES Lt_Infopersonaempresarolhisto(Ln_Indice);
      END IF;
    END IF;

    IF Lt_Infopersonaempresarolcarac.COUNT > 0 THEN
      FORALL Ln_Indice IN Lt_Infopersonaempresarolcarac.FIRST .. Lt_Infopersonaempresarolcarac.LAST SAVE EXCEPTIONS
        INSERT INTO DB_COMERCIAL.Info_Persona_Empresa_Rol_Carac VALUES Lt_Infopersonaempresarolcarac(Ln_Indice);
    END IF;

    IF Lt_Infopersonacontacto.COUNT > 0 THEN
      FORALL Ln_Indice IN Lt_Infopersonacontacto.FIRST .. Lt_Infopersonacontacto.LAST SAVE EXCEPTIONS
        INSERT INTO DB_COMERCIAL.Info_Persona_Contacto VALUES Lt_Infopersonacontacto(Ln_Indice);
    END IF;

    IF Lt_Infopuntocontacto.COUNT > 0 THEN
      FORALL Ln_Indice IN Lt_Infopuntocontacto.FIRST .. Lt_Infopuntocontacto.LAST SAVE EXCEPTIONS
        INSERT INTO DB_COMERCIAL.Info_Punto_Contacto VALUES Lt_Infopuntocontacto(Ln_Indice);
    END IF;

    COMMIT;

    Pn_login_repetidos := Ln_Contador_Login;
    Pv_Login_Repetidos := Lv_Login_Repetidos;
    Pv_Msgerror        := Lv_Msgerror;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      Lv_Msgerror := 'Ha ocurrido un error inesperado: ' || SQLCODE || ' -ERROR- ' || Substr(SQLERRM,1,1000);
      Pv_Msgerror := Lv_Msgerror;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('TELCOS+',
                                           'CMKG_CONTACTO_MASIVO.P_DUPLICAR_MASIVO',
                                           Pv_Msgerror,
                                           Lv_Usuario,
                                           SYSDATE,
                                           Lv_Ip);

  END P_DUPLICAR_MASIVO;

  FUNCTION F_SPLIT_CLOB(Fcl_Text      IN CLOB,
                        Fv_Delimiter  IN VARCHAR2) RETURN T_Array_Id IS

    Lcn_Chunk_Limit   CONSTANT NUMBER := 32767;
    Lv_Clob_Length    NUMBER := DBMS_LOB.Getlength(Fcl_Text);
    Lv_Clob_Index     NUMBER;
    Lv_Chunk          VARCHAR2(32767);
    Lv_Msgerror       VARCHAR2(32767);
    Lv_Chunk_End      NUMBER;
    Lv_Chunk_Length   NUMBER;
    Lv_Chunk_Index    NUMBER;
    Lv_Delim_Len      NUMBER := Length(Fv_Delimiter);
    Lv_Line_End       NUMBER;
    Lt_Id             T_Array_Id;
  BEGIN
    Lv_Clob_Length := DBMS_LOB.Getlength(Fcl_Text);
    Lv_Clob_Index := 1;

    WHILE Lv_Clob_Index <= Lv_Clob_Length LOOP
      Lv_Chunk := DBMS_LOB.Substr(Fcl_Text,Lcn_Chunk_Limit,Lv_Clob_Index);
      IF Lv_Clob_Index > Lv_Clob_Length - Lcn_Chunk_Limit THEN
        Lv_Clob_Index := Lv_Clob_Length + 1;
      ELSE
        Lv_Chunk_End := Instr(Lv_Chunk,Fv_Delimiter,-1);
        IF Lv_Chunk_End = 0 THEN
          RETURN Lt_Id;
        END IF;
        Lv_Chunk := Substr(Lv_Chunk,1,Lv_Chunk_End);
        Lv_Clob_Index := Lv_Clob_Index + Lv_Chunk_End + Lv_Delim_Len - 1;
      END IF;

      Lv_Chunk_Index := 1;
      Lv_Chunk_Length := NVL(Length(Lv_Chunk),0);
      WHILE Lv_Chunk_Index <= Lv_Chunk_Length LOOP
        Lv_Line_End := Instr(Lv_Chunk,Fv_Delimiter,Lv_Chunk_Index);
        IF Lv_Line_End = 0 OR ( Lv_Line_End - Lv_Chunk_Index ) > 4000 THEN
          Lt_Id(Lt_Id.COUNT) := TO_NUMBER(TRIM(Substr(Lv_Chunk,Lv_Chunk_Index,4000)));

          Lv_Chunk_Index := Lv_Chunk_Index + 4000;
        ELSE
          Lt_Id(Lt_Id.COUNT) := TO_NUMBER(TRIM(Substr(Lv_Chunk,Lv_Chunk_Index,Lv_Line_End - Lv_Chunk_Index)));

          Lv_Chunk_Index := Lv_Line_End + Lv_Delim_Len;
        END IF;
      END LOOP;
    END LOOP;

    RETURN Lt_Id;
  EXCEPTION
    WHEN OTHERS THEN
      Lv_Msgerror := 'Ha ocurrido un error inesperado: ' || SQLCODE || ' -ERROR- ' || Substr(SQLERRM,1,1000);

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('TELCOS+',
                                           'CMKG_CONTACTO_MASIVO.F_SPLIT_CLOB',
                                           Lv_Msgerror,NVL(SYS_CONTEXT('USERENV','HOST'),'TELCOS+'),
                                           SYSDATE,NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1'));

  END F_SPLIT_CLOB;

END CMKG_CONTACTO_MASIVO;
/