CREATE OR REPLACE PACKAGE DB_INFRAESTRUCTURA.INFRK_DML
AS
  /**
  * INFRP_INSERT_DETALLE_ELEMENTO
  *
  * PROCEDIMIENTO QUE INSERTA EN LA TABLA INFO_DETALLE_ELEMENTO
  *
  * @author John Vera            <javera@telconet.ec>
  * @version 1.0 03/10/2014
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.1 20/06/2019 Se agrega en el INSERT el campo del estado del detalle elemento
  *
  * @author Karen Rodr�guez V. kyrodriguez@telconet.ec>
  * @version 1.1 20/06/2020 Se agrega validacion NVL para la secuencia de la tabla.
  *
  * @param string Pr_detalleElemento
  *
  * @return string Lv_MensaError
  */
  PROCEDURE INFRP_INSERT_DETALLE_ELEMENTO(
      Pr_detalleElemento IN INFO_DETALLE_ELEMENTO%ROWTYPE,
      Lv_MensaError OUT VARCHAR2);
  /**
  * INFRP_INSERT_DETALLE_CARACT
  *
  * PROCEDIMIENTO QUE INSERTA EN LA TABLA INFO_DETALLE_CARACTERISTICA
  *
  * @author John Vera            <javera@telconet.ec>
  * @version 1.0 03/10/2014
  * @param string Pr_detalleCaracteristica
  *
  * @return string Lv_MensaError
  */
  PROCEDURE INFRP_INSERT_DETALLE_CARACT(
      Pr_detalleCaracteristica IN INFO_DETALLE_CARACTERISTICA%ROWTYPE,
      Lv_MensaError OUT VARCHAR2);
  /**
  * INFRP_INSERT_HISTORIAL_ELEMENT
  *
  * PROCEDIMIENTO QUE INSERTA EN LA TABLA INFO_HISTORIAL_ELEMENTO
  *
  * @author John Vera            <javera@telconet.ec>
  * @version 1.0 03/10/2014
  * @param string Pr_HistorialElemento
  *
  * @return string Lv_MensaError
  */
  PROCEDURE INFRP_INSERT_HISTORIAL_ELEMENT(
      Pr_HistorialElemento IN INFO_HISTORIAL_ELEMENTO%ROWTYPE,
      Lv_MensaError OUT VARCHAR2);
  /**
  * INFRP_INSERT_ENLACE
  *
  * PROCEDIMIENTO QUE INSERTA EN LA TABLA INFO_ENLACE
  *
  * @author John Vera            <javera@telconet.ec>
  * @version 1.0 03/10/2014
  * @param string Pr_Enlace
  *
  * @return string Lv_MensaError
  */
  PROCEDURE INFRP_INSERT_ENLACE(
      Pr_Enlace IN INFO_ENLACE%ROWTYPE,
      Lv_MensaError OUT VARCHAR2);
  /**
  * INFRP_INSERT_RELACION_ELEMENTO
  *
  * PROCEDIMIENTO QUE INSERTA EN LA TABLA INFO_RELACION_ELEMENTO
  *
  * @author John Vera            <javera@telconet.ec>
  * @version 1.0 03/10/2014
  * @param string Pr_RelacionElemento
  *
  * @author Karen Rodr�guez V. kyrodriguez@telconet.ec>
  * @version 1.1 20/06/2020 Se agrega validacion NVL para la secuencia de la tabla.
  *
  * @author Antonio Ayala  <afayala@telconet.ec>
  * @version 1.2 10/05/2021 Se elimina validacion NVL para la secuencia de la tabla.
  *
  * @return string Lv_MensaError
  */
  PROCEDURE INFRP_INSERT_RELACION_ELEMENTO(
      Pr_RelacionElemento IN INFO_RELACION_ELEMENTO%ROWTYPE,
      Lv_MensaError OUT VARCHAR2);
  /**
  * INFRP_INSERT_INTERFACE_ELEMENT
  *
  * PROCEDIMIENTO QUE INSERTA EN LA TABLA INFO_INTERFACE_ELEMENTO
  *
  * @author John Vera            <javera@telconet.ec>
  * @version 1.0 03/10/2014
  * @param string Pr_InterfaceElemento
  *
  * @return string Lv_MensaError
  */
  PROCEDURE INFRP_INSERT_INTERFACE_ELEMENT(
      Pr_InterfaceElemento IN INFO_INTERFACE_ELEMENTO%ROWTYPE,
      Lv_MensaError OUT VARCHAR2);
  /**
  * INFRP_INSERT_EMPR_ELEMENT_UBIC
  *
  * PROCEDIMIENTO QUE INSERTA EN LA TABLA INFO_EMPRESA_ELEMENTO_UBICA
  *
  * @author John Vera            <javera@telconet.ec>
  * @version 1.0 03/10/2014
  * @param string Pr_EmprElementUbica
  *
  * @author Karen Rodr�guez V. kyrodriguez@telconet.ec>
  * @version 1.1 20/06/2020 Se agrega validacion NVL para la secuencia de la tabla.
  *
  * @return string Lv_MensaError
  */
  PROCEDURE INFRP_INSERT_EMPR_ELEMENT_UBIC(
      Pr_EmprElementUbica IN INFO_EMPRESA_ELEMENTO_UBICA%ROWTYPE,
      Lv_MensaError OUT VARCHAR2);
  /**
  * INFRP_INSERT_EMPRESA_ELEMENTO
  *
  * PROCEDIMIENTO QUE INSERTA EN LA TABLA INFO_EMPRESA_ELEMENTO
  *
  * @author John Vera            <javera@telconet.ec>
  * @version 1.0 03/10/2014
  * @param string Pr_EmpresaElemento
  *
  * @author Karen Rodr�guez V. kyrodriguez@telconet.ec>
  * @version 1.1 20/06/2020 Se agrega validacion NVL para la secuencia de la tabla.
  *
  * @return string Lv_MensaError
  */
  PROCEDURE INFRP_INSERT_EMPRESA_ELEMENTO(
      Pr_EmpresaElemento IN INFO_EMPRESA_ELEMENTO%ROWTYPE,
      Lv_MensaError OUT VARCHAR2);

  /**
   * P_UPDATE_INFO_DETALLE_ELEMENTO
   * Procedimiento que actualiza el registro asociado a la tabla INFO_DETALLE_ELEMENTO
   * 
   * @param Pr_InfoDetalleElemento  IN DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO%ROWTYPE Registro de la tabla INFO_DETALLE_ELEMENTO
   * @param Pv_Mensaje              OUT VARCHAR2 Mensaje de la ejecuci�n del procedimiento
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 04-12-2019
   *
   * @author Karen Rodr�guez V. kyrodriguez@telconet.ec>
   * @version 1.1 20-06-2020 Se agrega validacion NVL para la secuencia de la tabla.
   *
   */
  PROCEDURE P_UPDATE_INFO_DETALLE_ELEMENTO(
    Pr_InfoDetalleElemento  IN DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO%ROWTYPE,
    Pv_Mensaje              OUT VARCHAR2);

  /**
  * INFRP_INSERT_ADMI_POLICY
  *
  * PROCEDIMIENTO QUE INSERTA EN LA TABLA ADMI_POLICY
  *
  * @author Antonio Ayala <afayala@telconet.ec>
  * @version 1.0 04-03-2021
  *
  * @param string Pr_AdmiPolicy
  *
  * @return string Lv_MensaError
  */
  PROCEDURE INFRP_INSERT_ADMI_POLICY(
      Pr_AdmiPolicy IN DB_INFRAESTRUCTURA.ADMI_POLICY%ROWTYPE,
      Lv_MensaError OUT VARCHAR2);  
      
  /**
  * INFRP_INSERT_INFO_SUBRED
  *
  * PROCEDIMIENTO QUE INSERTA EN LA TABLA INFO_SUBRED
  *
  * @author Antonio Ayala <afayala@telconet.ec>
  * @version 1.0 04-03-2021
  *
  * @param string Pr_InfoSubred
  *
  * @return string Lv_MensaError
  */
  PROCEDURE INFRP_INSERT_INFO_SUBRED(
      Pr_InfoSubred IN DB_INFRAESTRUCTURA.INFO_SUBRED%ROWTYPE,
      Lv_MensaError OUT VARCHAR2);  
      
  /**
  * INFRP_INSERT_INFO_SUBRED_TAG
  *
  * PROCEDIMIENTO QUE INSERTA EN LA TABLA INFO_SUBRED_TAG
  *
  * @author Antonio Ayala <afayala@telconet.ec>
  * @version 1.0 04-03-2021
  *
  * @param string Pr_InfoSubredTag
  *
  * @return string Lv_MensaError
  */
  PROCEDURE INFRP_INSERT_INFO_SUBRED_TAG(
      Pr_InfoSubredTag IN DB_INFRAESTRUCTURA.INFO_SUBRED_TAG%ROWTYPE,
      Lv_MensaError    OUT VARCHAR2);

  /**
  * GET_ELEMENTO_FILTER_DETALLE
  *
  * Funcion que sirve para obtener el elemento padre o interface, filtrando por el detalle del elemento a buscar.
  *
  * @author Felix Caicedo <facaicedo@telconet.ec>
  * @version 1.0
  *
  * @param Pn_idInterfaceIngreso (idInterfaceElemento)
  * @param Pv_TipoParametroIngreso (ELEMENTO, INTERFACE, MISMO_ID, BUSCAR)
  * @param Pv_DetalleNombre (DETALLE NOMBRE ELEMENTO)
  * @param Pv_DetalleValor (DETALLE VALOR ELEMENTO)
  * @return NUMBER
  */
  FUNCTION GET_ELEMENTO_FILTER_DETALLE(
    Pn_idInterfaceIngreso   IN NUMBER,
    Pv_TipoParametroIngreso IN VARCHAR2,
    Pv_DetalleNombre        IN VARCHAR2,
    Pv_DetalleValor         IN VARCHAR2)
  RETURN NUMBER;
END INFRK_DML;
/


CREATE OR REPLACE PACKAGE BODY DB_INFRAESTRUCTURA.INFRK_DML
AS
PROCEDURE INFRP_INSERT_DETALLE_ELEMENTO(
    Pr_detalleElemento IN INFO_DETALLE_ELEMENTO%ROWTYPE,
    Lv_MensaError OUT VARCHAR2)
AS
BEGIN
  INSERT
  INTO INFO_DETALLE_ELEMENTO
    (
      ID_DETALLE_ELEMENTO,
      ELEMENTO_ID,
      DETALLE_NOMBRE,
      DETALLE_VALOR,
      DETALLE_DESCRIPCION,
      USR_CREACION,
      FE_CREACION,
      IP_CREACION,
      REF_DETALLE_ELEMENTO_ID,
      ESTADO
    )
    VALUES
    (
      NVL(Pr_detalleElemento.ID_DETALLE_ELEMENTO,SEQ_INFO_DETALLE_ELEMENTO.NEXTVAL),
      Pr_detalleElemento.ELEMENTO_ID,
      Pr_detalleElemento.DETALLE_NOMBRE,
      Pr_detalleElemento.DETALLE_VALOR,
      Pr_detalleElemento.DETALLE_DESCRIPCION,
      Pr_detalleElemento.USR_CREACION,
      SYSDATE,
      Pr_detalleElemento.IP_CREACION,
      Pr_detalleElemento.REF_DETALLE_ELEMENTO_ID,
      Pr_detalleElemento.ESTADO
    );
EXCEPTION
WHEN OTHERS THEN
  Lv_MensaError := 'INFRK_DML.INFRP_INSERT_DETALLE_ELEMENTO '||SQLERRM;
END INFRP_INSERT_DETALLE_ELEMENTO;
--
--
PROCEDURE INFRP_INSERT_DETALLE_CARACT
  (
    Pr_detalleCaracteristica IN INFO_DETALLE_CARACTERISTICA%ROWTYPE,
    Lv_MensaError OUT VARCHAR2
  )
AS
BEGIN
  INSERT
  INTO INFO_DETALLE_CARACTERISTICA
    (
      ID_DETALLE_CARACTERISTICA,
      DETALLE_ELEMENTO_ID,
      CARACTERISTICA_ID,
      DESCRIPCION_CARACTERISTICA,
      VALOR_CARACTERISTICA,
      ESTADO,
      USR_CREACION,
      FE_CREACION,
      IP_CREACION
    )
    VALUES
    (
      SEQ_INFO_DETALLE_CARACT.NEXTVAL,
      Pr_detalleCaracteristica.DETALLE_ELEMENTO_ID,
      Pr_detalleCaracteristica.CARACTERISTICA_ID,
      Pr_detalleCaracteristica.DESCRIPCION_CARACTERISTICA,
      Pr_detalleCaracteristica.VALOR_CARACTERISTICA,
      Pr_detalleCaracteristica.ESTADO,
      Pr_detalleCaracteristica.USR_CREACION,
      SYSDATE,
      Pr_detalleCaracteristica.IP_CREACION
    );
EXCEPTION
WHEN OTHERS THEN
  Lv_MensaError := 'INFRK_DML.INFRP_INSERT_DETALLE_CARACT '||SQLERRM;
END INFRP_INSERT_DETALLE_CARACT;
--
--
PROCEDURE INFRP_INSERT_HISTORIAL_ELEMENT
  (
    Pr_HistorialElemento IN INFO_HISTORIAL_ELEMENTO%ROWTYPE,
    Lv_MensaError OUT VARCHAR2
  )
AS
BEGIN
  INSERT
  INTO INFO_HISTORIAL_ELEMENTO
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
      SEQ_INFO_HISTORIAL_ELEMENTO.NEXTVAL,
      Pr_HistorialElemento.ELEMENTO_ID,
      Pr_HistorialElemento.ESTADO_ELEMENTO,
      Pr_HistorialElemento.CAPACIDAD,
      Pr_HistorialElemento.OBSERVACION,
      Pr_HistorialElemento.USR_CREACION,
      SYSDATE,
      Pr_HistorialElemento.IP_CREACION
    );
EXCEPTION
WHEN OTHERS THEN
  Lv_MensaError := 'INFRK_DML.INFRP_INSERT_HISTORIAL_ELEMENT '||SQLERRM;
END INFRP_INSERT_HISTORIAL_ELEMENT;
--
--
PROCEDURE INFRP_INSERT_ENLACE
  (
    Pr_Enlace IN INFO_ENLACE%ROWTYPE,
    Lv_MensaError OUT VARCHAR2
  )
AS
BEGIN
  INSERT
  INTO INFO_ENLACE
    (
      ID_ENLACE,
      INTERFACE_ELEMENTO_INI_ID,
      INTERFACE_ELEMENTO_FIN_ID,
      TIPO_MEDIO_ID,
      CAPACIDAD_INPUT,
      UNIDAD_MEDIDA_INPUT,
      CAPACIDAD_OUTPUT,
      UNIDAD_MEDIDA_OUTPUT,
      CAPACIDAD_INI_FIN,
      UNIDAD_MEDIDA_UP,
      CAPACIDAD_FIN_INI,
      UNIDAD_MEDIDA_DOWN,
      TIPO_ENLACE,
      ESTADO,
      USR_CREACION,
      FE_CREACION,
      IP_CREACION
    )
    VALUES
    (
      SEQ_INFO_ENLACE.NEXTVAL,
      Pr_Enlace.INTERFACE_ELEMENTO_INI_ID,
      Pr_Enlace.INTERFACE_ELEMENTO_FIN_ID,
      Pr_Enlace.TIPO_MEDIO_ID,
      Pr_Enlace.CAPACIDAD_INPUT,
      Pr_Enlace.UNIDAD_MEDIDA_INPUT,
      Pr_Enlace.CAPACIDAD_OUTPUT,
      Pr_Enlace.UNIDAD_MEDIDA_OUTPUT,
      Pr_Enlace.CAPACIDAD_INI_FIN,
      Pr_Enlace.UNIDAD_MEDIDA_UP,
      Pr_Enlace.CAPACIDAD_FIN_INI,
      Pr_Enlace.UNIDAD_MEDIDA_DOWN,
      Pr_Enlace.TIPO_ENLACE,
      Pr_Enlace.ESTADO,
      Pr_Enlace.USR_CREACION,
      SYSDATE,
      Pr_Enlace.IP_CREACION
    );
EXCEPTION
WHEN OTHERS THEN
  Lv_MensaError := 'INFRK_DML.INFRP_INSERT_ENLACE '||SQLERRM;
END INFRP_INSERT_ENLACE;
--
--
--
--
   PROCEDURE INFRP_INSERT_RELACION_ELEMENTO
   (    Pr_RelacionElemento IN INFO_RELACION_ELEMENTO%ROWTYPE,
        Lv_MensaError OUT VARCHAR2)
AS
BEGIN
  INSERT
  INTO INFO_RELACION_ELEMENTO
    (
      ID_RELACION_ELEMENTO,
      ELEMENTO_ID_A,
      ELEMENTO_ID_B,
      TIPO_RELACION,
      POSICION_X,
      POSICION_Y,
      POSICION_Z,
      OBSERVACION,
      ESTADO,
      USR_CREACION,
      FE_CREACION,
      IP_CREACION
    )
    VALUES
    (
      SEQ_INFO_RELACION_ELEMENTO.NEXTVAL,
      Pr_RelacionElemento.ELEMENTO_ID_A,
      Pr_RelacionElemento.ELEMENTO_ID_B,
      Pr_RelacionElemento.TIPO_RELACION,
      Pr_RelacionElemento.POSICION_X,
      Pr_RelacionElemento.POSICION_Y,
      Pr_RelacionElemento.POSICION_Z,
      Pr_RelacionElemento.OBSERVACION,
      Pr_RelacionElemento.ESTADO,
      Pr_RelacionElemento.USR_CREACION,
      SYSDATE,
      Pr_RelacionElemento.IP_CREACION
    );
EXCEPTION
WHEN OTHERS THEN
  Lv_MensaError := 'INFRK_DML.INFRP_INSERT_RELACION_ELEMENTO '||SQLERRM;
END INFRP_INSERT_RELACION_ELEMENTO;
--
--
--

PROCEDURE INFRP_INSERT_INTERFACE_ELEMENT(
        Pr_InterfaceElemento IN INFO_INTERFACE_ELEMENTO%ROWTYPE,
        Lv_MensaError OUT VARCHAR2) 
        AS
BEGIN
  INSERT
  INTO INFO_INTERFACE_ELEMENTO
    (
      ID_INTERFACE_ELEMENTO,
      ELEMENTO_ID,
      NOMBRE_INTERFACE_ELEMENTO,
      DESCRIPCION_INTERFACE_ELEMENTO,
      CAPACIDAD_UTILIZADA,
      UNIDAD_MEDIDA_UTILIZADA,
      NUMERO_SERIE,
      ESTADO,
      USR_CREACION,
      FE_CREACION,
      IP_CREACION
    )
    VALUES
    (
      SEQ_INFO_INTERFACE_ELEMENTO.NEXTVAL,
      Pr_InterfaceElemento.ELEMENTO_ID,
      Pr_InterfaceElemento.NOMBRE_INTERFACE_ELEMENTO,
      Pr_InterfaceElemento.DESCRIPCION_INTERFACE_ELEMENTO,
      Pr_InterfaceElemento.CAPACIDAD_UTILIZADA,
      Pr_InterfaceElemento.UNIDAD_MEDIDA_UTILIZADA,
      Pr_InterfaceElemento.NUMERO_SERIE,
      Pr_InterfaceElemento.ESTADO,
      Pr_InterfaceElemento.USR_CREACION,
      SYSDATE,
      Pr_InterfaceElemento.IP_CREACION
    );
EXCEPTION
WHEN OTHERS THEN
  Lv_MensaError := 'INFRK_DML.INFRP_INSERT_INTERFACE_ELEMENT '||SQLERRM;
END INFRP_INSERT_INTERFACE_ELEMENT;
--
--
PROCEDURE INFRP_INSERT_EMPR_ELEMENT_UBIC(
    Pr_EmprElementUbica IN INFO_EMPRESA_ELEMENTO_UBICA%ROWTYPE,
    Lv_MensaError OUT VARCHAR2)
AS
BEGIN
  INSERT
  INTO INFO_EMPRESA_ELEMENTO_UBICA
    (
      ID_EMPRESA_ELEMENTO_UBICACION,
      EMPRESA_COD,
      ELEMENTO_ID,
      UBICACION_ID,
      USR_CREACION,
      FE_CREACION,
      IP_CREACION
    )
    VALUES
    (
      NVL(Pr_EmprElementUbica.ID_EMPRESA_ELEMENTO_UBICACION,SEQ_INFO_EMPRESA_ELEMENTO_UBI.NEXTVAL),
      Pr_EmprElementUbica.EMPRESA_COD,
      Pr_EmprElementUbica.ELEMENTO_ID,
      Pr_EmprElementUbica.UBICACION_ID,
      Pr_EmprElementUbica.USR_CREACION,
      SYSDATE,
      Pr_EmprElementUbica.IP_CREACION
    );
EXCEPTION
WHEN OTHERS THEN
  Lv_MensaError := 'INFRK_DML.INFRP_INSERT_EMPR_ELEMENT_UBIC '||SQLERRM;
END INFRP_INSERT_EMPR_ELEMENT_UBIC;
--
--
--
    PROCEDURE INFRP_INSERT_EMPRESA_ELEMENTO(
        Pr_EmpresaElemento IN INFO_EMPRESA_ELEMENTO%ROWTYPE,
        Lv_MensaError OUT VARCHAR2)
AS
BEGIN
  INSERT
  INTO INFO_EMPRESA_ELEMENTO
    (
      ID_EMPRESA_ELEMENTO,
      EMPRESA_COD,
      ELEMENTO_ID,
      OBSERVACION,
      ESTADO,
      USR_CREACION,
      FE_CREACION,
      IP_CREACION
    )
    VALUES
    (
      SEQ_INFO_EMPRESA_ELEMENTO.NEXTVAL,
      Pr_EmpresaElemento.EMPRESA_COD,
      Pr_EmpresaElemento.ELEMENTO_ID,
      Pr_EmpresaElemento.OBSERVACION,
      Pr_EmpresaElemento.ESTADO,
      Pr_EmpresaElemento.USR_CREACION,
      SYSDATE,
      Pr_EmpresaElemento.IP_CREACION
    );
EXCEPTION
WHEN OTHERS THEN
  Lv_MensaError := 'INFRK_DML.INFRP_INSERT_EMPRESA_ELEMENTO '||SQLERRM;
END INFRP_INSERT_EMPRESA_ELEMENTO;
--
  PROCEDURE P_UPDATE_INFO_DETALLE_ELEMENTO(
    Pr_InfoDetalleElemento  IN DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO%ROWTYPE,
    Pv_Mensaje              OUT VARCHAR2)
  AS
  BEGIN
    UPDATE DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
    SET DETALLE_VALOR   = NVL(Pr_InfoDetalleElemento.DETALLE_VALOR         , DETALLE_DESCRIPCION),
    DETALLE_DESCRIPCION = NVL(Pr_InfoDetalleElemento.DETALLE_DESCRIPCION   , DETALLE_DESCRIPCION),
    USR_CREACION        = NVL(Pr_InfoDetalleElemento.USR_CREACION          , USR_CREACION),
    FE_CREACION         = NVL(Pr_InfoDetalleElemento.FE_CREACION           , FE_CREACION),
    IP_CREACION         = NVL(Pr_InfoDetalleElemento.IP_CREACION           , IP_CREACION)
    WHERE ID_DETALLE_ELEMENTO = Pr_InfoDetalleElemento.ID_DETALLE_ELEMENTO;
  EXCEPTION
  WHEN OTHERS THEN
    Pv_Mensaje := 'Error en P_UPDATE_INFO_DETALLE_ELEMENTO - ' || SQLCODE ||
                  ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || 
                  ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  END P_UPDATE_INFO_DETALLE_ELEMENTO;

  PROCEDURE INFRP_INSERT_ADMI_POLICY(
    Pr_AdmiPolicy IN DB_INFRAESTRUCTURA.ADMI_POLICY%ROWTYPE,
    Lv_MensaError OUT VARCHAR2)
    AS
    BEGIN
      INSERT
        INTO ADMI_POLICY
      ( 
        ID_POLICY,
        NOMBRE_POLICY,
        LEASE_TIME,
        MASCARA,
        DNS_NAME,
        DNS_SERVERS,
        ESTADO,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        GATEWAY
      )
      VALUES
      (
        Pr_AdmiPolicy.ID_POLICY,
        Pr_AdmiPolicy.NOMBRE_POLICY,
        Pr_AdmiPolicy.LEASE_TIME,
        Pr_AdmiPolicy.MASCARA,
        Pr_AdmiPolicy.DNS_NAME,
        Pr_AdmiPolicy.DNS_SERVERS,
        Pr_AdmiPolicy.ESTADO,
        Pr_AdmiPolicy.USR_CREACION,
        SYSDATE,
        Pr_AdmiPolicy.IP_CREACION,
        Pr_AdmiPolicy.GATEWAY
      );
  EXCEPTION
  WHEN OTHERS THEN
    Lv_MensaError := 'INFRK_DML.INFRP_INSERT_ADMI_POLICY '||SQLERRM;
END INFRP_INSERT_ADMI_POLICY;

PROCEDURE INFRP_INSERT_INFO_SUBRED(
    Pr_InfoSubred IN DB_INFRAESTRUCTURA.INFO_SUBRED%ROWTYPE,
    Lv_MensaError OUT VARCHAR2)
    AS
    BEGIN
      INSERT
        INTO INFO_SUBRED
      ( 
        ID_SUBRED,
        RED_ID,
        SUBRED,
        IP_INICIAL,
        IP_FINAL,
        ESTADO,
        FE_CREACION,
        USR_CREACION,
        IP_CREACION,
        MASCARA,
        NOTIFICACION,
        ELEMENTO_ID
      )
      VALUES
      (
        Pr_InfoSubred.ID_SUBRED,
        Pr_InfoSubred.RED_ID,
        Pr_InfoSubred.SUBRED,
        Pr_InfoSubred.IP_INICIAL,
        Pr_InfoSubred.IP_FINAL,
        Pr_InfoSubred.ESTADO,
        SYSDATE,
        Pr_InfoSubred.USR_CREACION,
        Pr_InfoSubred.IP_CREACION,
        Pr_InfoSubred.MASCARA,
        Pr_InfoSubred.NOTIFICACION,
        Pr_InfoSubred.ELEMENTO_ID
      );
  EXCEPTION
  WHEN OTHERS THEN
    Lv_MensaError := 'INFRK_DML.INFRP_INSERT_INFO_SUBRED '||SQLERRM;
END INFRP_INSERT_INFO_SUBRED;

PROCEDURE INFRP_INSERT_INFO_SUBRED_TAG(
    Pr_InfoSubredTag IN DB_INFRAESTRUCTURA.INFO_SUBRED_TAG%ROWTYPE,
    Lv_MensaError    OUT VARCHAR2)
    AS
    BEGIN
      INSERT
        INTO INFO_SUBRED_TAG
      ( 
        ID_SUBRED_TAG,
        SUBRED_ID,
        TAG_ID,
        USR_CREACION,
        FE_CREACION,
        ESTADO
      )
      VALUES
      (
        SEQ_INFO_SUBRED_TAG.NEXTVAL,
        Pr_InfoSubredTag.SUBRED_ID,
        Pr_InfoSubredTag.TAG_ID,
        Pr_InfoSubredTag.USR_CREACION,
        SYSDATE,
        Pr_InfoSubredTag.ESTADO
      );
  EXCEPTION
  WHEN OTHERS THEN
    Lv_MensaError := 'INFRK_DML.INFRP_INSERT_INFO_SUBRED_TAG '||SQLERRM;
END INFRP_INSERT_INFO_SUBRED_TAG;

FUNCTION GET_ELEMENTO_FILTER_DETALLE (
    Pn_idInterfaceIngreso   IN NUMBER,
    Pv_TipoParametroIngreso IN VARCHAR2,
    Pv_DetalleNombre        IN VARCHAR2,
    Pv_DetalleValor         IN VARCHAR2)
  RETURN NUMBER
IS
    Lv_BanderaSalir       VARCHAR2(2) :='NO';
    Ln_IdParametroIngreso NUMBER;
    Ln_IdElementoRetornar NUMBER;
    Ln_IdIntarfeInicio    NUMBER;
    Ln_IdElemento         NUMBER;
    Lv_EstadoActivo       VARCHAR2(10) := 'Activo';
    Ln_IdCantidadLoop     NUMBER := 50;
    Ln_IntContador        NUMBER := 0;
    Ln_EncontroRetornar   NUMBER := 0;
BEGIN
    IF Pn_idInterfaceIngreso > 0 THEN
        Ln_IdParametroIngreso := Pn_idInterfaceIngreso;
        WHILE Lv_BanderaSalir = 'NO'
        LOOP
            --contador
            Ln_IntContador := Ln_IntContador + 1;
            --obtener interface inicio
            BEGIN
                SELECT INTERFACE_ELEMENTO_INI_ID
                INTO Ln_IdIntarfeInicio
                FROM DB_INFRAESTRUCTURA.INFO_ENLACE
                WHERE INTERFACE_ELEMENTO_FIN_ID = Ln_IdParametroIngreso
                AND ESTADO = Lv_EstadoActivo;
            EXCEPTION
            WHEN OTHERS THEN
                Ln_IdIntarfeInicio := 0;
            END;
            --verificar interface
            IF Ln_IdIntarfeInicio IS NOT NULL AND Ln_IdIntarfeInicio > 0 THEN
                Ln_IdParametroIngreso := Ln_IdIntarfeInicio;
                --obtener elemento
                BEGIN
                      SELECT INT.ELEMENTO_ID
                      INTO Ln_IdElemento
                      FROM DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO INT
                        INNER JOIN DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO DET ON DET.ELEMENTO_ID = INT.ELEMENTO_ID
                      WHERE INT.ID_INTERFACE_ELEMENTO = Ln_IdParametroIngreso
                      AND DET.DETALLE_NOMBRE = Pv_DetalleNombre AND DET.DETALLE_VALOR = Pv_DetalleValor AND DET.ESTADO = Lv_EstadoActivo
                      GROUP BY INT.ELEMENTO_ID;
                EXCEPTION
                WHEN OTHERS THEN
                    Ln_IdElemento := 0;
                END;
                --verificar elemento
                IF Ln_IdElemento IS NOT NULL AND Ln_IdElemento > 0 THEN
                    --salir while
                    Lv_BanderaSalir := 'SI';
                    --si encontro
                    Ln_EncontroRetornar := 1;
                    IF Pv_TipoParametroIngreso = 'MISMO_ID' THEN
                        Ln_IdElementoRetornar := Pn_idInterfaceIngreso;
                    ELSIF Pv_TipoParametroIngreso = 'ELEMENTO' THEN
                        Ln_IdElementoRetornar := Ln_IdElemento;
                    ELSE
                        Ln_IdElementoRetornar := Ln_IdIntarfeInicio;
                    END IF;
                END IF;
            ELSE
                --salir while
                Lv_BanderaSalir := 'SI';
                Ln_IdElementoRetornar := NULL;
                --no encontro
                Ln_EncontroRetornar := 0;
            END IF;
            --validar iteraciones
            IF Ln_IntContador >= Ln_IdCantidadLoop THEN
                --salir while
                Lv_BanderaSalir := 'SI';
                Ln_IdElementoRetornar := NULL;
                --no encontro
                Ln_EncontroRetornar := 0;
            END IF;
        END LOOP;
    END IF;
    IF Pv_TipoParametroIngreso = 'BUSCAR' THEN
        RETURN(Ln_EncontroRetornar);
    ELSE
        RETURN(Ln_IdElementoRetornar);
    END IF;
EXCEPTION
WHEN OTHERS THEN
  Ln_IdElementoRetornar := NULL;
END GET_ELEMENTO_FILTER_DETALLE;

END INFRK_DML;
/