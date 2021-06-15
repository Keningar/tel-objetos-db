-- Creación del tipo para objeto de contrato
CREATE OR REPLACE TYPE DB_COMERCIAL.DATOS_CONTRATO_TYPE AS OBJECT (
  Pn_IdContrato                  NUMBER,
  Pv_ObservacionHistorial        VARCHAR2(200),
  Pv_IpCreacion                  VARCHAR2(30),
  Pv_Origen                      VARCHAR2(30),
  Pv_UsrCreacion		         VARCHAR2(100)
);
/

create or replace TYPE  DB_COMERCIAL.DATOS_APROBAR_CONTRATO_TYPE AS OBJECT (
  Pv_Servicios              Pcl_ServEncontrado_Type,
  Pv_UsrCreacion            VARCHAR2(400),
  Pv_IpCreacion             VARCHAR2(400),
  Pv_PrefijoEmpresa         VARCHAR2(400),
  Pv_Origen                 VARCHAR2(400),
  Pv_ObservacionHistorial   VARCHAR2(200),
  Pv_EmpresaCod             INTEGER,
  Pn_PersonaEmpresaRolId    INTEGER,
  Pn_ContratoId             INTEGER,
  Pn_FormaPagoId            INTEGER
);
/

CREATE OR REPLACE TYPE  DB_COMERCIAL.DATOS_GENERAR_OT_TYPE AS OBJECT (
  Pn_IdPunto                INTEGER,
  Pn_Producto               VARCHAR2(400),
  Pn_IdServicio             INTEGER,
  Pv_Observacion            VARCHAR2(400),
  Pv_Caracteristica         VARCHAR2(400),
  Pv_UsrCreacion            VARCHAR2(400),
  Pv_IpCreacion             VARCHAR2(400),
  Pn_EmpresaCod             INTEGER,
  Pn_IdOficina              INTEGER,
  Pv_EstadoServicio         VARCHAR2(400),
  Pv_Solicitud              VARCHAR2(400),
  Pv_NuevoServicio          VARCHAR2(400)
);
/
