--Creación del tipo para datos de tarjeta
CREATE OR REPLACE TYPE DB_COMERCIAL.DATOS_TARJETA_TYPE AS OBJECT (
    Pn_TipoCuentaId         INTEGER,
    Pn_BancoTipoCuentaId    INTEGER,
    Pv_NumeroCuentaTarj     VARCHAR2(800),
    Pv_CodigoVerificacion   VARCHAR2(800),
    Pn_CodigoEmpresa        INTEGER
);

/

--Creación del tipo para datos de la secuencia contrato/adendum
CREATE OR REPLACE TYPE DB_COMERCIAL.DATOS_SECUENCIA AS OBJECT (
    Pv_codigoNumeracionVe   VARCHAR2(800),
	Pn_CodEmpresa           INTEGER,
	Pn_IdOficina            INTEGER,
    Pn_ContrAdend           INTEGER
);

/


CREATE OR REPLACE TYPE DB_COMERCIAL.Pcl_AdendumsEncontrado_Type IS TABLE OF INTEGER;
/

--Creación del tipo para datos de forma de pago
CREATE OR REPLACE TYPE DB_COMERCIAL.FORMA_PAGO_TYPE AS OBJECT (
	Pn_FormaPagoId          INTEGER,
	Pn_TipoCuentaID         INTEGER,
    Pn_BancoTipoCuentaId    INTEGER,
    Pv_NumeroCtaTarjeta     VARCHAR2(800),
    Pv_CodigoVerificacion   VARCHAR2(400),
    Pn_CodEmpresa           INTEGER,
    Pv_AnioVencimiento      VARCHAR2(400),
    Pv_TitularCuenta        VARCHAR2(400),
    Pn_IdContrato           INTEGER,
    Pv_MesVencimiento       VARCHAR2(400),
    Pv_UsrCreacion          VARCHAR2(400),
    Pv_ClienteIp            VARCHAR2(400),
    Pn_PuntoId              INTEGER,
    Pv_Servicio             VARCHAR2(1000),
	Pv_CambioTarjeta        VARCHAR2(10),
    Pn_ContrAdend           INTEGER,
    Pv_Tipo                 VARCHAR2(10),
    Pv_EstadoAdendum        VARCHAR2(400),
    Pv_NumeroAdendum        VARCHAR2(400),
    Pv_cambioRazonSocial    VARCHAR2(400),
    Pn_Adendums             Pcl_AdendumsEncontrado_Type
);

/

CREATE OR REPLACE TYPE DB_COMERCIAL.Pcl_ServEncontrado_Type IS TABLE OF INTEGER;
/

CREATE OR REPLACE TYPE  DB_COMERCIAL.DATOS_APROBAR_ADENDUM_TYPE AS OBJECT (
    Pv_Servicios              Pcl_ServEncontrado_Type,
    Pv_UsrCreacion            VARCHAR2(400),
    Pv_IpCreacion             VARCHAR2(400),
    Pv_PrefijoEmpresa         VARCHAR2(400),
    Pv_Origen                 VARCHAR2(400),
    Pv_ObservacionHistorial   VARCHAR2(200),
    Pv_EmpresaCod             INTEGER,
    Pn_PersonaEmpresaRolId    INTEGER
);

/
