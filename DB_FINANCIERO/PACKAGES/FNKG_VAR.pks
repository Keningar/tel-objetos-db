CREATE OR REPLACE package               FNKG_VAR is
  /**
  * Documentacion para Packages FNKG_VAR
  * Packages que contendar todas las constantes que se requiera usar para evitar usar c¿digo fijo en los querys
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 21-06-2018
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 27-09-2018 - Se agregan constantes para proceso de contabilización retenciones individuales.
  *
  */

  TYPE TypeTiposEstados IS RECORD 
     ( ACTIVO    VARCHAR2(30) := 'Activo',
       CERRADO   VARCHAR2(30) := 'Cerrado',
       ANULADO   VARCHAR2(30) := 'Anulado',
       ELIMINADO VARCHAR2(30) := 'Eliminado',
       RECHAZADO VARCHAR2(30) := 'Rechazado');
  --
  TYPE TypeSesion IS RECORD ( 
    USERENV   VARCHAR2(13):= 'USERENV',
    HOST      VARCHAR2(14):= 'HOST',
    IP_ADRESS VARCHAR2(14):= 'IP_ADDRESS'
  );
  --
  Gr_Estado TypeTiposEstados;
  Gr_Sesion TypeSesion;
  --
  Gv_ValidaProcesoContable CONSTANT DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'VALIDACIONES_PROCESOS_CONTABLES';
  Gv_ProcesoPagoRet        CONSTANT DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'FNKG_CONTABILIZAR_PAGOS_RET';
  Gv_ParFormaPago          CONSTANT DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'CODIGO_FORMA_PAGO';
  Gv_ParEstadoPago         CONSTANT DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'ESTADO_PAGO';
  Gv_ParTipoDocPago        CONSTANT DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'CODIGO_TIPO_DOCUMENTO';
  --
  Gv_ParDocumentoDetProduc CONSTANT DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'DOCUMENTOS_DETALLE_PRODUCTOS';
  Gv_FechaContabilizacion  CONSTANT DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'FECHA_CONTABILIZACION';
  Gv_ParEstadoDocumento    CONSTANT DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'ESTADO FACTURA';
  Gv_ParTipoDocfacturacion CONSTANT DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'TIPO DOC FACTURACION';
  Gv_ParFechaContabiliza   CONSTANT DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'FECHA_CONTABILIZACION';
  Gv_FechaEmision          CONSTANT VARCHAR2(30) := 'FECHA_EMISION';
  Gv_FechaAutoriza         CONSTANT VARCHAR2(30) := 'FECHA_AUTORIZA';
  --
  Gv_HoraIniDia            CONSTANT VARCHAR2(10) := ' 00:00:00';
  Gv_HoraFinDia            CONSTANT VARCHAR2(10) := ' 23:59:59';
  Gv_FmtFechaTime          CONSTANT VARCHAR2(22) := 'DD/MM/RRRR HH24:MI:SS';
  Gv_FmtFechaDate          CONSTANT VARCHAR2(22) := 'DD/MM/YYYY HH24:MI:SS';
  Gv_FmtFechaTimeR         CONSTANT VARCHAR2(22) := 'RRRR/MM/DD HH24:MI:SS';
  Gv_FmtFechaDateR         CONSTANT VARCHAR2(22) := 'YYYY/MM/DD HH24:MI:SS';
  --
  Gv_ProcesoSaldosCartera  CONSTANT DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'PROCESO_SALDOS_CARTERA';
  Gv_ParDocumentosPagos    CONSTANT DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'DOCUMENTOS_PAGOS';
  Gv_ParDocCruceAnticipo   CONSTANT DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'DOC_CRUCE_ANTICIPOS';

end FNKG_VAR;

/


CREATE OR REPLACE package body               FNKG_VAR is
  
end FNKG_VAR;

/
