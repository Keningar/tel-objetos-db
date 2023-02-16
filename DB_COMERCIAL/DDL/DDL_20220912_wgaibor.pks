/*
* Se solicita crear un nuevo campo en la tabla de INFO_ADENDUM
* @author Walther Joao Gaibor C <wgaibor@telconet.ec>
* @version 1.0 15-09-2022
*/
ALTER TABLE  DB_COMERCIAL.INFO_ADENDUM ADD (FORMA_CONTRATO VARCHAR2(30));
ALTER TABLE  DB_COMERCIAL.INFO_ADENDUM ADD (ORIGEN VARCHAR2(30));

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
    Pn_Adendums             Pcl_AdendumsEncontrado_Type,
    Pv_FormaContrato        VARCHAR2(40),
    Pv_Origen               VARCHAR2(40)
);

/
COMMIT;