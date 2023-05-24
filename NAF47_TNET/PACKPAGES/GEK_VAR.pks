CREATE OR REPLACE package NAF47_TNET.GEK_VAR is

  /**
  * Documentacion para NAF47_TNET.GEK_VAR
  * Paquete que contiene constantes a ser usadas en los diferentes procesos de NAF.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 22/05/2018
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 09/03/2019 - se agregan constantes para identificacion de parametros de estados de devoluciones.
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.2 23/09/2019 - se agregan constantes para identificacion los tipos de actividades
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.3 28/02/2020 - se agregan variables Gd_FechaDesde, Gd_FechaHasta para usar como parametros en vista V_ARTICULOS_CUSTODIOS
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.4 06/02/2022 - se agregan nuevos estados Autorizado, Automatico y Asignado para proceso Pedidos Masivos
  *  
  * @author llindao <llindao@telconet.ec>
  * @version 1.5 17/01/2021 - se agregan estados a variable registro de estados para el uso de proceso control custodio nodos
  */


  TYPE TypeSesion IS RECORD ( 
    USERENV   VARCHAR2(13):= 'USERENV',
    HOST      VARCHAR2(14):= 'HOST',
    IP_ADRESS VARCHAR2(14):= 'IP_ADDRESS'
  );
  --
  TYPE TypePrefijoModulo IS RECORD 
     ( INVENTARIO      VARCHAR2(2) := 'IN',
       CONTABILIDAD    VARCHAR2(2) := 'CG',
       CUENTAS_X_PAGAR VARCHAR2(2) := 'CP',
       BANCOS          VARCHAR2(2) := 'CK',
       FONDO_FIJO      VARCHAR2(2) := 'FF',
       DEVOLUCIONES    VARCHAR2(2) := 'DE');
  --
  TYPE TypeIndicadorSimple IS RECORD 
     ( SI    VARCHAR2(1) := 'S',
       NO    VARCHAR2(1) := 'N');

  TYPE TypePrefijoNAF IS RECORD 
     ( ENTRADA    VARCHAR2(01) := 'E',
       SALIDA     VARCHAR2(01) := 'S');

  TYPE TypeTiposEstadosNAF IS RECORD 
     ( PENDIENTE          VARCHAR2(01) := 'P',
       EN_BODEGA          VARCHAR2(02) := 'EB',
       FUERA_BODEGA       VARCHAR2(02) := 'FB',
       INSTALADO          VARCHAR2(02) := 'IN',
       PENDIENTE_INSTALAR VARCHAR2(02) := 'PI',
       RETIRADO           VARCHAR2(02) := 'RE',
       ACTIVO             VARCHAR2(01) := 'A',
       INACTIVO           VARCHAR2(01) := 'I',
       ANULADO            VARCHAR2(01) := 'A',
       CIERRE_MES         VARCHAR2(01) := 'M',
       CIERRE_ANIO        VARCHAR2(01) := 'A',
       ENTRADA            VARCHAR2(01) := 'E',
       SALIDA             VARCHAR2(01) := 'S');

  TYPE TypeTiposEstados IS RECORD 
     ( ACTIVO       VARCHAR2(06) := 'Activo',
       INACTIVO     VARCHAR2(08) := 'Inactivo',
       PENDIENTE    VARCHAR2(09) := 'Pendiente',
       PROCESADO    VARCHAR2(09) := 'Procesado',
       DESPACHADO   VARCHAR2(10) := 'Despachado',
       POR_DEVOLVER VARCHAR2(11) := 'PorDevolver',
       DEVUELTO     VARCHAR2(08) := 'Devuelto',
       AUTORIZADO   VARCHAR2(10) := 'Autorizado',
       AUTOMATICO   VARCHAR2(10) := 'Automatico',
       SI           VARCHAR2(02) := 'SI',
       NO           VARCHAR2(02) := 'NO',
       ASIGNADO     VARCHAR2(08) := 'Asignado');

  TYPE TypeTiposPersonas IS RECORD 
     ( EMPLEADO    VARCHAR2(30) := 'Empleado',
       CONTRATISTA VARCHAR2(30) := 'Contratista',
       CLIENTE     VARCHAR2(30) := 'Cliente');
  --
  Gr_Estado      TypeTiposEstados;
  Gr_EstadoNAF   TypeTiposEstadosNAF;
  Gr_TipoPersona TypeTiposPersonas;
  Gr_Sesion      TypeSesion;
  Gr_Prefijos    TypePrefijoModulo;
  Gr_IndSimple   TypeIndicadorSimple;
  Gr_PrefijoNAF  TypePrefijoNAF;  
  --
  --Parametros Generales
  Gv_ParamEstadoDevolProcesada  CONSTANT VARCHAR2(19) := 'EST_DEVOL_PROCESADA';
  Gv_ParamDevolEquipoNuevo      CONSTANT VARCHAR2(19) := 'MOTIVO_DEV_EQ_NUEVO';
  --
  -- Parametros Devoluciones Pedidos
  Gv_ParamEstadoDevolPendientes  CONSTANT VARCHAR2(20) := 'ESTADO_DEV_PENDIENTE';
  --
  -- Constantes proceso Control Articulos
  Gc_BajaArticulo     CONSTANT VARCHAR2(12) := 'BajaArticulo'; 
  Gc_DevolucionBodega CONSTANT VARCHAR2(16) := 'DevolucionBodega';
  Gc_IngresoBodega    CONSTANT VARCHAR2(16) := 'IngresoBodega';
  Gc_Instalacion      CONSTANT VARCHAR2(16) := 'Instalacion';
  Gc_Regularizacion   CONSTANT VARCHAR2(16) := 'Regularizacion';
  Gc_Soporte          CONSTANT VARCHAR2(16) := 'Soporte';
  Gc_Empleado         CONSTANT VARCHAR2(16) := 'Empleado';
  Gc_Cliente          CONSTANT VARCHAR2(16) := 'Cliente';
  --
  -- Variable globales usadas en querys dinamicos
  Gd_FechaDesde       DATE := TRUNC(SYSDATE);
  Gd_FechaHasta       DATE := TRUNC(SYSDATE);
  Gv_NoArticulo       NAF47_TNET.ARINDA.NO_ARTI%TYPE;
  Gv_NoCompania       NAF47_TNET.ARCGMC.NO_CIA%TYPE;
  Gv_NumeroSerie      NAF47_TNET.INV_NUMERO_SERIE.SERIE%TYPE;
  --
 /**
  * Documentacion para P_SET_FECHA_DESDE
  * Procedure que asigna fecha ingresada por el usuario desde la forma a la variable GEK_VAR.Gd_FechaDesde
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 28/02/2020
  *
  * @param Pd_Fecha IN DATE Recibe fecha ingresada por usuario desde forma de consulta
  */  
  PROCEDURE P_SET_FECHA_DESDE (Pd_Fecha IN DATE);

 /**
  * Documentacion para P_SET_FECHA_HASTA
  * Procedure que asigna fecha ingresada por el usuario desde la forma a la variable GEK_VAR.Gd_FechaHasta
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 28/02/2020
  *
  * @param Pd_Fecha IN DATE Recibe fecha ingresada por usuario desde forma de consulta
  */
  PROCEDURE P_SET_FECHA_HASTA (Pd_Fecha IN DATE);
  --
  --
 /**
  * Documentacion para P_SET_COMPANIA_ID
  * Procedure que asigna el valor de la variable GEK_VAR.Gv_NoCompania desde los procesos que invoquen a generaci�n autom�tica de n�meros series
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 28/02/2020
  *
  */  
  PROCEDURE P_SET_COMPANIA_ID (Pv_NoCompania IN VARCHAR2);
  --
  --
 /**
  * Documentacion para P_SET_ARTICULO_ID
  * Procedure que asigna el valor de la variable GEK_VAR.Gv_NoArticulo desde los procesos que invoquen a generaci�n autom�tica de n�meros series
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 28/02/2020
  *
  */  
  PROCEDURE P_SET_ARTICULO_ID (Pv_NoArticulo IN VARCHAR2);
  --
  --
 /**
  * Documentacion para P_SET_NUMERO_SERIE
  * Procedure que asigna el valor de la variable GEK_VAR.Gv_NumeroSerie desde los procesos que invoquen a generaci�n autom�tica de n�meros series
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 28/02/2020
  *
  */  
  PROCEDURE P_SET_NUMERO_SERIE (Pv_NumeroSerie IN VARCHAR2);


 /**
  * Documentacion para F_GET_FECHA_DESDE
  * Funcion que retorna el valor de la variable GEK_VAR.Gd_FechaDesde que es usada como filtro en la vista V_ARTICULO_CUSTODIO
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 28/02/2020
  *
  */  
  FUNCTION F_GET_FECHA_DESDE RETURN DATE;

 /**
  * Documentacion para F_GET_FECHA_HASTA
  * Funcion que retorna el valor de la variable GEK_VAR.Gd_FechaHasta que es usada como filtro en la vista V_ARTICULO_CUSTODIO
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 28/02/2020
  *
  */  
  FUNCTION F_GET_FECHA_HASTA RETURN DATE;
  --
  --
 /**
  * Documentacion para F_GET_COMPANIA_ID
  * Funcion que retorna el valor de la variable GEK_VAR.Gv_NoCompania que es usada como parametro en proceso genera serie autom�tica
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 30/07/2021
  *
  */  
  FUNCTION F_GET_COMPANIA_ID RETURN VARCHAR2;
  --
  --
   /**
  * Documentacion para F_GET_ARTICULO_ID
  * Funcion que retorna el valor de la variable GEK_VAR.Gv_NoArticulo que es usada como parametro en proceso genera serie autom�tica
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 30/07/2021
  *
  */  
  FUNCTION F_GET_ARTICULO_ID RETURN VARCHAR2;
  --
  --
   /**
  * Documentacion para F_GET_NUMERO_SERIE
  * Funcion que retorna el valor de la variable GEK_VAR.Gv_NumeroSerie que es usada como parametro en proceso genera serie autom�tica
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 30/07/2021
  *
  */  
  FUNCTION F_GET_NUMERO_SERIE RETURN VARCHAR2;  
  --
  --
end GEK_VAR;
/

CREATE OR REPLACE package body NAF47_TNET.GEK_VAR is
  --
  PROCEDURE P_SET_FECHA_DESDE (Pd_Fecha IN DATE) IS
  BEGIN
    Gd_FechaDesde := Pd_Fecha;
  END;
  --
  PROCEDURE P_SET_FECHA_HASTA (Pd_Fecha IN DATE) IS
  BEGIN
    Gd_FechaHasta := Pd_Fecha;
  END;
  --
  --
  --
  PROCEDURE P_SET_COMPANIA_ID (Pv_NoCompania IN VARCHAR2) IS
  BEGIN
    Gv_NoCompania := Pv_NoCompania;
  END;
  --
  PROCEDURE P_SET_ARTICULO_ID (Pv_NoArticulo IN VARCHAR2) IS
  BEGIN
    Gv_NoArticulo := Pv_NoArticulo;
  END;
  --
  PROCEDURE P_SET_NUMERO_SERIE (Pv_NumeroSerie IN VARCHAR2) IS
  BEGIN
    Gv_NumeroSerie := Pv_NumeroSerie;
  END;  
  --
  --
  --
  FUNCTION F_GET_FECHA_DESDE RETURN DATE IS
  BEGIN
    RETURN Gd_FechaDesde;
  END;
  --
  FUNCTION F_GET_FECHA_HASTA RETURN DATE IS
  BEGIN
    RETURN Gd_FechaHasta;
  END;
  --
  --
  --
  FUNCTION F_GET_COMPANIA_ID RETURN VARCHAR2 IS
  BEGIN
    RETURN Gv_NoCompania;
  END;
  --
  FUNCTION F_GET_ARTICULO_ID RETURN VARCHAR2 IS
  BEGIN
    RETURN Gv_NoArticulo;
  END;
  --
  FUNCTION F_GET_NUMERO_SERIE RETURN VARCHAR2 IS
  BEGIN
    RETURN Gv_NumeroSerie;
  END;
  --

  --
end GEK_VAR;
/
