/**
 * Creación de la tabla 'INFO_PROCESO_PROMO', encargada de almacenar
 * todos los clientes que aplican o pierden una promoción.
 */
CREATE TABLE DB_EXTERNO.INFO_PROCESO_PROMO
(
  ID_PROCESO_PROMO        NUMBER,
  MODELO_ELEMENTO         VARCHAR2(100),
  FE_INI_MAPEO            DATE           NOT NULL,
  FE_FIN_MAPEO            DATE           NOT NULL,
  LOGIN_PUNTO             VARCHAR2(60)   NOT NULL,
  SERVICIO_ID             NUMBER   	 NOT NULL,
  ESTADO_SERVICIO         VARCHAR2(30)   NOT NULL,
  EMPRESA_COD		  VARCHAR2(2)    NOT NULL,
  SERIE                   VARCHAR2(40),
  MAC                     VARCHAR2(4000),
  NOMBRE_OLT              VARCHAR2(500),
  PUERTO                  VARCHAR2(20),
  SERVICE_PORT            VARCHAR2(4000),
  ONT_ID                  VARCHAR2(4000),
  TRAFFIC_PROMO           VARCHAR2(4000),
  GEMPORT_PROMO           VARCHAR2(4000),
  LINE_PROFILE_PROMO      VARCHAR2(4000),
  NUM_IPS_FIJAS           NUMBER,
  CAPACIDAD_DOWN_PROMO    VARCHAR2(4000),
  CAPACIDAD_UP_PROMO      VARCHAR2(4000),
  TIPO_NEGOCIO            VARCHAR2(60)   NOT NULL,
  TRAFFIC_ORIGIN          VARCHAR2(4000),
  GEMPORT_ORIGIN          VARCHAR2(4000),
  LINE_PROFILE_ORIGIN     VARCHAR2(4000),
  VLAN_ORIGIN             VARCHAR2(4000),
  SERVICE_PROFILE         VARCHAR2(4000),
  CAPACIDAD_DOWN_ORIGIN   VARCHAR2(4000),
  CAPACIDAD_UP_ORIGIN     VARCHAR2(4000),
  DETALLE_MAPEO_ID	  NUMBER,
  TIPO_PROCESO            VARCHAR2(20)   NOT NULL,
  TIPO_PROMO              VARCHAR2(15)   NOT NULL,
  ESTADO                  VARCHAR2(20)   NOT NULL,
  FE_CREACION             TIMESTAMP      NOT NULL,
  USR_CREACION            VARCHAR2(20)   NOT NULL,
  IP_CREACION             VARCHAR2(20)   NOT NULL,
  FE_MODIFICACION         TIMESTAMP,
  USR_MODIFICACION        VARCHAR2(20),
  IP_MODIFICACION         VARCHAR2(20),
  CONSTRAINT PROCESO_PROMO_PK PRIMARY KEY (ID_PROCESO_PROMO)
);

/* 
  Comentario de la tabla 'INFO_PROCESO_PROMO'.
*/
COMMENT ON TABLE DB_EXTERNO.INFO_PROCESO_PROMO
    IS 'TABLA QUE ALMACENA TODO LOS SERVICIOS DE UN CLIENTE QUE APLICA O PIERDE UNA PROMOCION';

/*
  Comentarios de las columnas de la tabla 'INFO_PROCESO_PROMO'.
*/
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.ID_PROCESO_PROMO        IS 'ID DE LA TABLA';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.MODELO_ELEMENTO         IS 'NOMBRE DEL ELEMENTO';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.FE_INI_MAPEO            IS 'FECHA INICIO DE MAPEO DE LA PROMOCION';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.FE_FIN_MAPEO            IS 'FECHA FIN DE MAPEO DE LA PROMOCION';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.LOGIN_PUNTO             IS 'LOGIN DEL PUNTO CLIENTE';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.SERVICIO_ID         	IS 'ID DEL SERVICIO DEL PUNTO CLIENTE';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.ESTADO_SERVICIO         IS 'ESTADO DEL SERVICIO DEL PUNTO CLIENTE';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.SERIE                   IS 'NUMERO DE SERIE';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.MAC                     IS 'MAC';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.NOMBRE_OLT              IS 'NOMBRE DEL OLT';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.PUERTO                  IS 'PUERTO';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.SERVICE_PORT            IS 'SERVICE_PORT';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.ONT_ID                  IS 'ONT_ID';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.TRAFFIC_PROMO           IS 'PARAMETRO TRAFFIC_PROMO DE CONFIGURACION DEL OLT';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.GEMPORT_PROMO           IS 'PARAMETRO GEMPORT_PROMO DE CONFIGURACION DEL OLT';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.LINE_PROFILE_PROMO      IS 'PARAMETRO LINE_PROFILE_PROMO DE CONFIGURACION DEL OLT';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.NUM_IPS_FIJAS           IS 'NUMERO DE IP’S FIJAS';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.CAPACIDAD_DOWN_PROMO    IS 'PARAMETRO CAPACIDAD_DOWN_PROMO DE CONFIGURACION DEL OLT';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.CAPACIDAD_UP_PROMO      IS 'PARAMETRO CAPACIDAD_UP_PROMO DE CONFIGURACION DEL OLT';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.TIPO_NEGOCIO            IS 'TIPO NEGOCIO DEL CLIENTE';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.TRAFFIC_ORIGIN          IS 'PARAMETRO TRAFFIC_ORIGIN DE CONFIGURACION DEL OLT';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.GEMPORT_ORIGIN          IS 'PARAMETRO GEMPORT_ORIGIN DE CONFIGURACION DEL OLT';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.LINE_PROFILE_ORIGIN     IS 'PARAMETRO LINE_PROFILE_ORIGIN DE CONFIGURACION DEL OLT';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.VLAN_ORIGIN             IS 'PARAMETRO VLAN_ORIGIN DE CONFIGURACION DEL OLT';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.SERVICE_PROFILE         IS 'PARAMETRO SERVICE_PROFILE DE CONFIGURACION DEL OLT';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.CAPACIDAD_DOWN_ORIGIN   IS 'PARAMETRO CAPACIDAD_DOWN_ORIGIN DE CONFIGURACION DEL OLT';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.CAPACIDAD_UP_ORIGIN     IS 'PARAMETRO CAPACIDAD_UP_ORIGIN DE CONFIGURACION DEL OLT';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.DETALLE_MAPEO_ID        IS 'ID DEL MAPEO DE LA PROMOCION QUE APLICO EL CLIENTE';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.TIPO_PROCESO            IS 'TIPO DE PROCESO';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.TIPO_PROMO              IS 'TIPO DE PROMOCION';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.ESTADO                  IS 'ESTADO DEL PROCESO';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.FE_CREACION             IS 'FECHA DE CREACION DEL PROCESO';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.USR_CREACION            IS 'USUARIO DE CREACION DEL PROCESO';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.IP_CREACION             IS 'IP DE CREACION DEL PROCESO';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.FE_MODIFICACION         IS 'FECHA DE MODIFICACION DEL PROCESO';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.USR_MODIFICACION        IS 'USUARIO DE MODIFICACION DEL PROCESO';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO.IP_MODIFICACION         IS 'IP DE MODIFICACION DEL PROCESO';

/*
  Creación de indices para mayor agilidad en la consulta de la tabla 'INFO_PROCESO_PROMO'.
*/
CREATE INDEX DB_EXTERNO.IDX_FE_CREACION     ON DB_EXTERNO.INFO_PROCESO_PROMO (FE_CREACION ASC);
CREATE INDEX DB_EXTERNO.IDX_USR_CREACION    ON DB_EXTERNO.INFO_PROCESO_PROMO (USR_CREACION);
CREATE INDEX DB_EXTERNO.IDX_ESTADO          ON DB_EXTERNO.INFO_PROCESO_PROMO (ESTADO);
CREATE INDEX DB_EXTERNO.IDX_LOGIN_PUNTO     ON DB_EXTERNO.INFO_PROCESO_PROMO (LOGIN_PUNTO);
CREATE INDEX DB_EXTERNO.IDX_TIPO_PROCESO    ON DB_EXTERNO.INFO_PROCESO_PROMO (TIPO_PROCESO);
CREATE INDEX DB_EXTERNO.IDX_TIPO_PROMO      ON DB_EXTERNO.INFO_PROCESO_PROMO (TIPO_PROMO);
CREATE INDEX DB_EXTERNO.IDX_ESTADO_FEC      ON DB_EXTERNO.INFO_PROCESO_PROMO (ESTADO,FE_CREACION);
CREATE INDEX DB_EXTERNO.IDX_PROCE_PROMO_FEC ON DB_EXTERNO.INFO_PROCESO_PROMO (TIPO_PROCESO,TIPO_PROMO,FE_CREACION);
CREATE INDEX DB_EXTERNO.IDX_PPEF            ON DB_EXTERNO.INFO_PROCESO_PROMO (TIPO_PROCESO,TIPO_PROMO,ESTADO,FE_CREACION);
CREATE INDEX DB_EXTERNO.IDX_LOGIN_FEC       ON DB_EXTERNO.INFO_PROCESO_PROMO (LOGIN_PUNTO,FE_CREACION);
CREATE INDEX DB_EXTERNO.IDX_LFPP            ON DB_EXTERNO.INFO_PROCESO_PROMO (LOGIN_PUNTO,FE_CREACION,TIPO_PROCESO,TIPO_PROMO);


/**
 * Creación de la tabla 'INFO_PROCESO_PROMO_HIST', encargada de almacenar
 * el historial del proceso de promociones.
 */
CREATE TABLE DB_EXTERNO.INFO_PROCESO_PROMO_HIST
(
    ID_PROCESO_PROMO_HIST   NUMBER,
    PROCESO_PROMO_ID        NUMBER,
    ESTADO                  VARCHAR2(20)  NOT NULL,
    OBSERVACION             VARCHAR2(4000),
    FE_CREACION             TIMESTAMP     NOT NULL,
    USR_CREACION            VARCHAR2(20)  NOT NULL,
    IP_CREACION             VARCHAR2(20)  NOT NULL,
    CONSTRAINT PROCESO_PROMO_HIST_PK PRIMARY KEY (ID_PROCESO_PROMO_HIST),
    CONSTRAINT PROCESO_PROMO_HIST_FK FOREIGN KEY (PROCESO_PROMO_ID)
        REFERENCES DB_EXTERNO.INFO_PROCESO_PROMO (ID_PROCESO_PROMO)
);

/*
  Comentario de la tabla 'INFO_PROCESO_PROMO_HIST'.
*/
COMMENT ON TABLE DB_EXTERNO.INFO_PROCESO_PROMO_HIST  IS 'TABLA QUE ALMACENA EL HISTORIAL DEL PROCESO DE PROMOCIONES';

/*
  Comentarios de las columnas de la tabla 'INFO_PROCESO_PROMO_HIST'.
*/
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO_HIST.ID_PROCESO_PROMO_HIST IS 'ID DE LA TABLA';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO_HIST.PROCESO_PROMO_ID      IS 'ID DE REFERENCIA DE LA TABLA INFO_PROCESO_PROMO';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO_HIST.ESTADO                IS 'ESTADO DEL HISTORIAL';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO_HIST.OBSERVACION           IS 'OBSERVACION';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO_HIST.FE_CREACION           IS 'FECHA DE CREACION DEL PROCESO';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO_HIST.USR_CREACION          IS 'USUARIO DE CREACION DEL PROCESO';
COMMENT ON COLUMN DB_EXTERNO.INFO_PROCESO_PROMO_HIST.IP_CREACION           IS 'IP DE CREACION DEL PROCESO';

/*
  Creación de indices para mayor agilidad en la consulta de la tabla 'INFO_PROCESO_PROMO_HIST'.
*/
CREATE INDEX DB_EXTERNO.IDX_HIST_PROCESO_PROMO_ID ON DB_EXTERNO.INFO_PROCESO_PROMO_HIST (PROCESO_PROMO_ID);
CREATE INDEX DB_EXTERNO.IDX_HIST_FE_CREACION      ON DB_EXTERNO.INFO_PROCESO_PROMO_HIST (FE_CREACION ASC);
CREATE INDEX DB_EXTERNO.IDX_HIST_USR_CREACION     ON DB_EXTERNO.INFO_PROCESO_PROMO_HIST (USR_CREACION);
CREATE INDEX DB_EXTERNO.IDX_HIST_ESTADO           ON DB_EXTERNO.INFO_PROCESO_PROMO_HIST (ESTADO);
CREATE INDEX DB_EXTERNO.IDX_HIST_ESTADO_FEC       ON DB_EXTERNO.INFO_PROCESO_PROMO_HIST (ESTADO,FE_CREACION);
CREATE INDEX DB_EXTERNO.IDX_HIST_FEC_USR          ON DB_EXTERNO.INFO_PROCESO_PROMO_HIST (FE_CREACION,USR_CREACION);
CREATE INDEX DB_EXTERNO.IDX_HIST_ESTADO_FEC_USR   ON DB_EXTERNO.INFO_PROCESO_PROMO_HIST (ESTADO,FE_CREACION,USR_CREACION);
/
