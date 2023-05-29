CREATE PACKAGE NAF47_TNET.FAK_PROCESOS
IS
  -- Author  : SFERNANDEZ
  -- Created : 02/08/2016 14:01:48
  -- Purpose :
TYPE TYPREC_DETALLEFACT
IS
  RECORD
  (
    NO_ARTI ARFAFL.NO_ARTI%TYPE,
    CANTIDAD ARFAFL.PEDIDO%TYPE,
    BODEGA_DET ARFAFL.BODEGA%TYPE );
  LTYPE_DETALLE TYPREC_DETALLEFACT;
  PROCEDURE P_CREA_FACTURA(
      Pv_NoCia            IN VARCHAR2,
      Pv_Centro           IN VARCHAR2,
      Pv_Cedula           IN VARCHAR2,
      Pv_TipoIdTributacio IN VARCHAR2,
      Pv_Grupo            IN VARCHAR2,
      Pv_TipoCliente      IN VARCHAR2,
      Pv_Vendedor         IN VARCHAR2,
      Pv_Division         IN VARCHAR2,
      Pv_TipoDoc          IN VARCHAR2,
      Pv_Ruta             IN VARCHAR2,
      Pv_AfectaSaldo      IN VARCHAR2,
      Pv_Observ1          IN VARCHAR2,
      Pv_porcDesc         IN VARCHAR2,
      Pv_BodegaCab        IN VARCHAR2,
      Pv_FormaPagoSri     IN VARCHAR2,
      Pv_Usuario          IN VARCHAR2,
      Pclob_ListPedido    IN CLOB,
      Pv_Salida OUT VARCHAR2,
      Pv_Mensaje OUT VARCHAR2,
      Pv_NumeroFactura OUT VARCHAR2,
      Pclob_XmlFactura OUT CLOB);
  PROCEDURE P_INSERTA_ARFAFE(
      Pv_NoCia            IN VARCHAR2,
      Pv_Centro           IN VARCHAR2,
      Pv_Cedula           IN VARCHAR2,
      Pv_TipoIdTributacio IN VARCHAR2,
      Pv_AfectaSaldo      IN VARCHAR2,
      Pv_Ruta             IN VARCHAR2,
      Pv_TipoDoc          IN VARCHAR2,
      Pv_BodegaCab        IN VARCHAR2,
      Pv_FormaPagoSri     IN VARCHAR2,
      Pv_Usuario          IN VARCHAR2,
      Pv_Division         IN VARCHAR2,
      Pv_Observ1          IN VARCHAR2,
      Pv_Vendedor         IN VARCHAR2,
      Pv_TipoCliente      IN VARCHAR2,
      Pv_Grupo            IN VARCHAR2,
      Pv_NoFactu OUT VARCHAR2,
      Pv_Periodo OUT VARCHAR2,
      Pv_Moneda OUT VARCHAR2,
      Pv_TipoPrecio OUT VARCHAR2,
      Pv_MonedaD OUT VARCHAR2,
      Pv_Salida OUT VARCHAR2,
      Pv_Mensaje OUT VARCHAR2,
      Pd_Fecha OUT DATE);
  PROCEDURE P_INSERTA_ARFAFL(
      Pv_NoCia      IN VARCHAR2,
      Pv_Centro     IN VARCHAR2,
      Pv_TipoDoc    IN VARCHAR2,
      Pv_Periodo    IN VARCHAR2,
      Pv_Ruta       IN VARCHAR2,
      Lv_NoFactu    IN VARCHAR2,
      Pv_NoLinea    IN VARCHAR2,
      Pv_NoArti     IN VARCHAR2,
      Pn_Canti      IN NUMBER,
      Pv_BodegaDet  IN VARCHAR2,
      Pv_porcDesc   IN VARCHAR2,
      Pv_Moneda     IN VARCHAR2,
      Pv_TipoPrecio IN VARCHAR2,
      Pv_MonedaD    IN VARCHAR2,
      Pd_Fecha      IN DATE,
      Pv_Grupo      IN VARCHAR2,
      Pv_Salida OUT VARCHAR2,
      Pv_Mensaje OUT VARCHAR2);
  PROCEDURE P_INSERTA_ARFAFLI(
      Pv_NoCia     IN VARCHAR2,
      Pv_TipoDoc   IN VARCHAR2,
      Pv_NoFactu   IN VARCHAR2,
      Pv_NoLinea   IN VARCHAR2,
      Pv_NoArti    IN VARCHAR2,
      Pv_IndIva    IN VARCHAR2,
      Pv_Grupo     IN VARCHAR2,
      Pv_NoCliente IN VARCHAR2,
      Pv_BodegaDet IN VARCHAR2,
      Pv_Centro    IN VARCHAR2,
      Pn_ValorIva  IN NUMBER,
      Pn_Total     IN NUMBER,
      Pv_Salida OUT VARCHAR2,
      Pv_Mensaje OUT VARCHAR2);
  PROCEDURE P_ACTUALIZA_ARFAFE(
      Pv_NoCia   IN VARCHAR2,
      Pv_Centro  IN VARCHAR2,
      Pv_TipoDoc IN VARCHAR2,
      Pv_Ruta    IN VARCHAR2,
      Lv_NoFactu IN VARCHAR2,
      Pv_Salida OUT VARCHAR2,
      Pv_Mensaje OUT VARCHAR2);
  PROCEDURE P_XML_FACTURA(
      Pv_NoCia   IN VARCHAR2,
      Pv_Centro  IN VARCHAR2,
      Pv_TipoDoc IN VARCHAR2,
      Pv_NoFactu IN VARCHAR2,
      Pv_Salida OUT VARCHAR2,
      Pv_Mensaje OUT VARCHAR2,
      Pv_NumeroFactura OUT VARCHAR2,
      Pclob_XmlFactura OUT CLOB);
  PROCEDURE P_JOB_FAACTUALIZA;
END FAK_PROCESOS;
/

CREATE OR REPLACE PACKAGE BODY NAF47_TNET.FAK_PROCESOS
IS
/**
* Documentacion para el procedimiento P_CREA_FACTURA
* Procedimiento que realiza el llamado a los procedimientos que insertan cabecera, detalle y generacion de xml
* se realiza validacion de stock de los articulos, si alguno de ellos no posee stock, no se genera la factura
* @author Sofia Fernandez <sfernandez@telconet.ec>
* @version 1.0 19-09-2016
* @author Sofia Fernandez <sfernandez@telconet.ec>
* @version 1.1 20-09-2016 Se agrega cursor de cliente para enviar como parametro el Grupo de acuerdo 
* al tipo de identificacion y numero
*/
PROCEDURE P_CREA_FACTURA(
    Pv_NoCia            IN VARCHAR2,
    Pv_Centro           IN VARCHAR2,
    Pv_Cedula           IN VARCHAR2,
    Pv_TipoIdTributacio IN VARCHAR2,
    Pv_Grupo            IN VARCHAR2,
    Pv_TipoCliente      IN VARCHAR2,
    Pv_Vendedor         IN VARCHAR2,
    Pv_Division         IN VARCHAR2,
    Pv_TipoDoc          IN VARCHAR2,
    Pv_Ruta             IN VARCHAR2,
    Pv_AfectASaldo      IN VARCHAR2,
    Pv_Observ1          IN VARCHAR2,
    Pv_porcDesc         IN VARCHAR2,
    Pv_BodegaCab        IN VARCHAR2,
    Pv_FormaPagoSri     IN VARCHAR2,
    Pv_Usuario          IN VARCHAR2,
    Pclob_ListPedido    IN CLOB,
    Pv_Salida OUT VARCHAR2,
    Pv_Mensaje OUT VARCHAR2,
    Pv_NumeroFactura OUT VARCHAR2,
    Pclob_XmlFactura OUT CLOB)
IS
  CURSOR C_CLIENTE
  IS
    SELECT *
    FROM ARCCMC
    WHERE NO_CIA           = Pv_NoCia
    AND CEDULA             = Pv_Cedula
    AND TIPO_ID_TRIBUTARIO = Pv_TipoIdTributacio;

  Lx_xml XMLTYPE;
  Le_Error     EXCEPTION;
  Ln_Contador1 NUMBER                  :=0;
  Ln_Linea     NUMBER                  :=0;
  Ln_Stock     NUMBER                  :=0;
  Ln_Pendientes NUMBER                 :=0;
  Ln_pendiente_real NUMBER             :=0;
  Ln_disponible NUMBER                 :=0;
  Lv_NoFactu ARFAFE.NO_FACTU%TYPE      := NULL;
  Lv_Periodo ARINCD.Ano_Proce_Fact%TYPE:= NULL;
  Lv_Moneda ARCCMC.MONEDA_LIMITE%TYPE  := NULL;
  Lv_TipoPrecio ARCCMC.Tipoprecio%TYPE := NULL;
  Lv_MonedaD ARFAFE.MONEDA%TYPE        := NULL;
  Ld_Fecha ARFAFE.Fecha%TYPE           := NULL;
  Lr_Clientes C_CLIENTE%ROWTYPE               := NULL;
  --
  --
BEGIN
  Lx_xml := XMLTYPE.createXML(Pclob_ListPedido);
   --Clientes
  IF C_CLIENTE%ISOPEN THEN
    CLOSE C_CLIENTE;
  END IF;
  OPEN C_CLIENTE;
  FETCH C_CLIENTE INTO Lr_Clientes;
  CLOSE C_CLIENTE;
  FOR C IN
  (SELECT no_arti,
          cantidad,
          bodega_det
    FROM xmltable ('//producto' pASsing Lx_xml columns no_arti VARCHAR2(100) PATH './no_arti',
    cantidad VARCHAR2(100) PATH './pedido',
    bodega_det VARCHAR2(100) PATH './bodega_det')
    )
    LOOP
      ARTICULO.DESGLOSE_EXISTENCIAS(Pv_NoCia,c.no_arti,c.bodega_det, Ln_Stock, Ln_pendientes);  
      Ln_pendiente_real := nvl(Ln_pendientes,0) - nvl(C.cantidad,0);
      IF Ln_pendiente_real < 0 THEN
        Ln_pendiente_real := 0;
      END IF;
      Ln_disponible := Ln_stock - nvl(articulo.Cant_Picking (Pv_NoCia,c.no_arti,c.bodega_det),0) - Ln_pendiente_real; 
      IF c.bodega_det != '0000' THEN
  	    IF Ln_Stock < C.cantidad THEN
         RAISE Le_Error;
        END IF;
        IF Ln_disponible < C.cantidad THEN
         RAISE Le_Error;
        END IF;
      END IF;
   END LOOP;


  FOR C  IN
  (SELECT *
  FROM xmltable ('//articulo' pASsing Lx_xml columns articulo1 VARCHAR2(100) PATH './articulos')
  )
  LOOP
    Ln_Contador1:= Ln_Contador1 +1;
    P_INSERTA_ARFAFE (Pv_NoCia, 
                      Pv_Centro, 
                      Pv_Cedula, 
                      Pv_TipoIdTributacio, 
                      Pv_AfectASaldo, 
                      Pv_Ruta, 
                      Pv_TipoDoc, 
                      Pv_BodegaCab, 
                      Pv_FormaPagoSri, 
                      Pv_Usuario,
                      Pv_Division, 
                      Pv_Observ1, 
                      Pv_Vendedor, 
                      Pv_TipoCliente, 
                      Lr_Clientes.Grupo, 
                      Lv_NoFactu, 
                      Lv_Periodo, 
                      Lv_Moneda, 
                      Lv_TipoPrecio, 
                      Lv_MonedaD, 
                      Pv_Salida, 
                      Pv_Mensaje, 
                      Ld_Fecha);
    FOR C IN
    (SELECT no_arti,
      cantidad,
      bodega_det
    FROM xmltable ('//producto' pASsing Lx_xml columns no_arti VARCHAR2(100) PATH './no_arti', 
                                                       cantidad VARCHAR2(100) PATH './pedido', 
                                                       bodega_det VARCHAR2(100) PATH './bodega_det')
    )
    LOOP
      Ln_Linea                 := Ln_Linea +1;
      Ltype_Detalle.no_arti    := c.no_arti;
      Ltype_Detalle.cantidad   := c.cantidad;
      Ltype_Detalle.bodega_det := c.bodega_det;
      P_INSERTA_ARFAFL (Pv_NoCia, 
                        Pv_Centro, 
                        Pv_TipoDoc, 
                        Lv_Periodo, 
                        Pv_Ruta, 
                        Lv_NoFactu, 
                        Ln_Linea, 
                        Ltype_Detalle.no_arti, 
                        Ltype_Detalle.cantidad, 
                        Ltype_Detalle.bodega_det, 
                        Pv_porcDesc, 
                        Lv_Moneda, 
                        Lv_TipoPrecio, 
                        Lv_MonedaD, 
                        Ld_Fecha, 
                        Lr_Clientes.Grupo, 
                        Pv_Salida, 
                        Pv_Mensaje);
    END LOOP;
  END LOOP;

  P_ACTUALIZA_ARFAFE (Pv_NoCia, 
                      Pv_Centro, 
                      Pv_TipoDoc, 
                      Pv_Ruta, 
                      Lv_NoFactu, 
                      Pv_Salida, 
                      Pv_Mensaje);
  P_XML_FACTURA (Pv_NoCia, 
                 Pv_Centro, 
                 Pv_TipoDoc, 
                 Lv_NoFactu, 
                 Pv_Salida, 
                 Pv_Mensaje, 
                 Pv_NumeroFactura,
                 Pclob_XmlFactura);
EXCEPTION
WHEN Le_Error THEN
  Pv_Salida  := '403';
  Pv_Mensaje := 'Error';
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('API-NAF', 
                                       'FAK_PROCESOS.P_CREA_FACTURA', 
                                       'Error Le_Error - P_CREA_FACTURA: Stock no disponible:'||SQLERRM, 
                                       NVL(SYS_CONTEXT('USERENV','HOST'), USER), 
                                       SYSDATE,
                                       NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), 
                                       '127.0.0.1'));
  ROLLBACK;
WHEN OTHERS THEN
  Pv_Salida  := '403';
  Pv_Mensaje := 'Error';
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('API-NAF', 
                                       'FAK_PROCESOS.P_CREA_FACTURA', 
                                       'Error en Otros - P_CREA_FACTURA: '||SQLERRM, 
                                       NVL(SYS_CONTEXT('USERENV','HOST'), USER), 
                                       SYSDATE, 
                                       NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), 
                                       '127.0.0.1'));
  ROLLBACK;
END P_CREA_FACTURA;
/**
* Documentacion para el procedimiento P_INSERTA_ARFAFE
* Procedimiento que realiza la insercion de la cabecera de la factura, con origen WS- WebService
* @author Sofia Fernandez <sfernandez@telconet.ec>
* @version 1.0 19-09-2016
* @author Sofia Fernandez <sfernandez@telconet.ec>
* @version 1.1 30-09-2016 Se consideran 9 digitos para numero fisico de la factura
* @author Sofia Fernandez <sfernandez@telconet.ec>
* @version 1.2 24-10-2016 Se setea en mayuscula el usuario, para que el usuario pueda visualizarlo en pantalla.
*/
PROCEDURE P_INSERTA_ARFAFE(
    Pv_NoCia            IN VARCHAR2,
    Pv_Centro           IN VARCHAR2,
    Pv_Cedula           IN VARCHAR2,
    Pv_TipoIdTributacio IN VARCHAR2,
    Pv_AfectASaldo      IN VARCHAR2,
    Pv_Ruta             IN VARCHAR2,
    Pv_TipoDoc          IN VARCHAR2,
    Pv_BodegaCab        IN VARCHAR2,
    Pv_FormaPagoSri     IN VARCHAR2,
    Pv_Usuario          IN VARCHAR2,
    Pv_Division         IN VARCHAR2,
    Pv_Observ1          IN VARCHAR2,
    Pv_Vendedor         IN VARCHAR2,
    Pv_TipoCliente      IN VARCHAR2,
    Pv_Grupo            IN VARCHAR2,
    Pv_NoFactu OUT VARCHAR2,
    Pv_Periodo OUT VARCHAR2,
    Pv_Moneda OUT VARCHAR2,
    Pv_TipoPrecio OUT VARCHAR2,
    Pv_MonedaD OUT VARCHAR2,
    Pv_Salida OUT VARCHAR2,
    Pv_Mensaje OUT VARCHAR2,
    Pd_Fecha OUT DATE)
IS
  CURSOR C_PERIODO_PROCESO
  IS
    SELECT ANO_PROCE_FACT,
      MES_PROCE_FACT,
      SEMANA_PROCE_FACT,
      INDICADOR_SEM_FACT,
      DIA_PROCESO_FACT,
      NVL((ANO_PROCE     *100) + MES_PROCE,1)ANIO_MES_P,
      NVL((ANO_PROCE_FACT*100) + MES_PROCE_FACT,2)ANIO_MES_F,
      NVL((ANO_PROCE_CXC *100) + MES_PROCE_CXC,3)ANIO_MES_C,
      SEMANA_PROCE
    FROM ARINCD
    WHERE NO_CIA = Pv_NoCia
    AND CENTRO   = Pv_Centro;
  --
  CURSOR C_CALENDARIO(Cv_Anio VARCHAR2, Cv_Semana VARCHAR2, Cv_Indicador VARCHAR2)
  IS
    SELECT FECHA1,
      FECHA2
    FROM CALENDARIO
    WHERE NO_CIA  = Pv_NoCia
    AND ANO       = Cv_Anio
    AND SEMANA    = Cv_Semana
    AND INDICADOR = Cv_Indicador;
  CURSOR C_CLIENTE
  IS
    SELECT *
    FROM ARCCMC
    WHERE NO_CIA           = Pv_NoCia
    AND CEDULA             = Pv_Cedula
    AND TIPO_ID_TRIBUTARIO = Pv_TipoIdTributacio;
  CURSOR C_FECHA
  IS
    SELECT TRUNC(SYSDATE) FROM DUAL;
  CURSOR C_TIPO_DOC_FACT
  IS
    SELECT TIPO TIPO_DOC,
      AFECTA_SALDO,
      TIPO_MOV,
      MAX_LINEA,
      TIPO_DOC_CXC,
      TIPO_DOC_INVE
    FROM ARFACT
    WHERE NO_CIA     = Pv_NoCia
    AND AFECTA_SALDO = Pv_AfectASaldo
    AND ANULA_FACTU  = 'N'
    AND IND_FAC_DEV  = 'F'
    AND PEDIDO       = 'S';
  CURSOR C_TIPO_DOC_INV (Cv_TipoM VARCHAR2)
  IS
    SELECT TIPO_M
    FROM ARINVTM
    WHERE NO_CIA = Pv_NoCia
    AND TIPO_M   = Cv_TipoM
    AND MOVIMI   = 'S';
  CURSOR C_TIPO_DOC_CXC (Cv_Tipo VARCHAR2, Cv_TipoM VARCHAR2)
  IS
    SELECT 'X'
    FROM ARCCTD
    WHERE NO_CIA = Pv_NoCia
    AND TIPO     = Cv_Tipo
    AND TIPO_MOV = Cv_TipoM;
  --
  Lr_PeriodoProceso C_PERIODO_PROCESO%ROWTYPE := NULL;
  Lr_Clientes C_CLIENTE%ROWTYPE               := NULL;
  Lr_Calendario C_CALENDARIO%ROWTYPE          := NULL;
  Lr_TipoDocFac C_TIPO_DOC_FACT%ROWTYPE       := NULL;
  Lv_NoFactu ARFAFE.NO_FACTU%TYPE             :=NULL;
  Ld_Fecha DATE                               :=NULL;
  Lv_TipoM ARINVTM.TIPO_M%TYPE                :=NULL;
  Lv_NoFisico ARFAFE.NO_FISICO%TYPE           :=NULL;
  Lv_SerieFisico ARFAFE.SERIE_FISICO%TYPE     :=NULL;
  Ln_NoCtrl ARFAFE.NUMERO_CTRL%TYPE           :=NULL;
  Lv_MonedaD ARFAFE.Moneda%TYPE               :=NULL;
  Le_Error EXCEPTION;
BEGIN
  Lv_NoFactu := Transa_id.fa(Pv_NoCia);
  Pv_NoFactu := Lv_NoFactu;
  IF C_PERIODO_PROCESO%ISOPEN THEN
    CLOSE C_PERIODO_PROCESO;
  END IF;
  OPEN C_PERIODO_PROCESO;
  FETCH C_PERIODO_PROCESO INTO Lr_PeriodoProceso;
  CLOSE C_PERIODO_PROCESO;
  Pv_Periodo := Lr_PeriodoProceso.Ano_Proce_Fact;
  Ld_Fecha   := TRUNC(SYSDATE);
  Pd_Fecha   := Ld_Fecha;
  --Calendario
  IF C_CALENDARIO%ISOPEN THEN
    CLOSE C_CALENDARIO;
  END IF;
  OPEN C_CALENDARIO (Lr_PeriodoProceso.Ano_Proce_Fact, 
                     Lr_PeriodoProceso.Semana_Proce_Fact, 
                     Lr_PeriodoProceso.Indicador_Sem_Fact);
  FETCH C_CALENDARIO INTO Lr_Calendario;
  CLOSE C_CALENDARIO;
  --Clientes
  IF C_CLIENTE%ISOPEN THEN
    CLOSE C_CLIENTE;
  END IF;
  OPEN C_CLIENTE;
  FETCH C_CLIENTE INTO Lr_Clientes;
  CLOSE C_CLIENTE;
  Pv_Moneda     := Lr_Clientes.Moneda_Limite;
  Lv_MonedaD    := Lr_Clientes.Moneda_Limite;
  Pv_MonedaD    := Lv_MonedaD;
  Pv_TipoPrecio := Lr_Clientes.Tipoprecio;
  --Fecha
  IF C_FECHA%ISOPEN THEN
    CLOSE C_FECHA;
  END IF;
  OPEN C_FECHA;
  FETCH C_FECHA INTO Ld_Fecha;
  CLOSE C_FECHA;
  --Tipo Doc Factura
  IF C_TIPO_DOC_FACT%ISOPEN THEN
    CLOSE C_TIPO_DOC_FACT;
  END IF;
  OPEN C_TIPO_DOC_FACT;
  FETCH C_TIPO_DOC_FACT INTO Lr_TipoDocFac;
  CLOSE C_TIPO_DOC_FACT;
  -- Validaciones de Fechas
  IF (Ld_Fecha < Lr_PeriodoProceso.Dia_Proceso_Fact) THEN
    RAISE Le_Error;
  END IF;
  IF NOT(Ld_Fecha BETWEEN TRUNC(Lr_Calendario.Fecha1) AND TRUNC(Lr_Calendario.Fecha2)) THEN
    RAISE Le_Error;
  END IF;
  IF Lr_PeriodoProceso.Anio_Mes_f != Lr_PeriodoProceso.Anio_Mes_p THEN
    RAISE Le_Error;
  ELSIF Lr_PeriodoProceso.Semana_Proce_Fact != Lr_PeriodoProceso.Semana_Proce THEN
    RAISE Le_Error;
  ELSIF Pv_AfectASaldo = 'S' AND Lr_PeriodoProceso.Anio_Mes_f < Lr_PeriodoProceso.Anio_Mes_c THEN
    RAISE Le_Error;
  END IF;
  -- Validacion de tipo documento de facturacion
  IF Lr_TipoDocFac.tipo_doc IS NOT NULL THEN
    IF C_TIPO_DOC_INV%ISOPEN THEN
      CLOSE C_TIPO_DOC_INV;
    END IF;
    OPEN C_TIPO_DOC_INV(Lr_TipoDocFac.Tipo_Doc_Inve);
    FETCH C_TIPO_DOC_INV INTO Lv_TipoM;
    IF Lv_TipoM IS NULL OR C_TIPO_DOC_INV%NOTFOUND THEN
      RAISE Le_Error;
    END IF;
    CLOSE C_TIPO_DOC_INV;
    IF C_TIPO_DOC_CXC%ISOPEN THEN
      CLOSE C_TIPO_DOC_CXC;
    END IF;
    OPEN C_TIPO_DOC_CXC (Lr_TipoDocFac.Tipo_Doc_Cxc, Lr_TipoDocFac.Tipo_Mov);
    FETCH C_TIPO_DOC_CXC INTO Lv_TipoM;
    IF Lv_TipoM IS NULL OR C_TIPO_DOC_CXC%NOTFOUND THEN
      RAISE Le_Error;
    END IF;
    CLOSE C_TIPO_DOC_CXC;
  END IF;
  -- Numero Fisico
  Lv_NoFisico    := Consecutivo.FA(Pv_NoCia, 
                                   Lr_PeriodoProceso.Ano_Proce_Fact, 
                                   Lr_PeriodoProceso.Mes_Proce_Fact, 
                                   Pv_Centro, 
                                   Pv_Ruta, 
                                   Pv_TipoDoc, 
                                   'NUMERO');
  Lv_SerieFisico := Consecutivo.FA(Pv_NoCia, 
                                   Lr_PeriodoProceso.Ano_Proce_Fact, 
                                   Lr_PeriodoProceso.Mes_Proce_Fact, 
                                   Pv_Centro, 
                                   Pv_Ruta, 
                                   Pv_TipoDoc, 
                                   'SERIE');
  Ln_NoCtrl      := Consecutivo.FA(Pv_NoCia, 
                                   Lr_PeriodoProceso.Ano_Proce_Fact, 
                                   Lr_PeriodoProceso.Mes_Proce_Fact, 
                                   Pv_Centro, 
                                   Pv_Ruta, 
                                   Pv_TipoDoc, 
                                   'SECUENCIA');
  Lv_NoFisico    := LPAD(Lv_NoFisico, 9, '0');
  INSERT
  INTO ARFAFE
    (
      NO_CIA,
      CENTROD,
      TIPO_DOC,
      PERIODO,
      RUTA,
      NO_FACTU,
      AFECTA_SALDO,
      GRUPO,
      NO_CLIENTE,
      TIPO_CLIENTE,
      NBR_CLIENTE,
      DIRECCION,
      FECHA,
      TIPO_CAMBIO,
      NO_VENDEDOR,
      PLAZO,
      OBSERV1,
      TOT_LIN,
      SUB_TOTAL,
      DESCUENTO,
      IMPUESTO,
      TOTAL,
      ESTADO,
      IMP_SINO,
      TIPO_FACTURA,
      PORC_DESC,
      NO_FISICO,
      SERIE_FISICO,
      MONEDA,
      MONTO_BIENES,
      MONTO_SERV,
      ORIGEN,
      CODIGO_PLAZO,
      DESCUENTO1,
      DESCUENTO2,
      USUARIO,
      TSTAMP,
      SUBCLIENTE,
      DIVISION_COMERCIAL,
      FECHA_CREACION,
      GRAVADA,
      EXENTO,
      DESCUENTO_GRAVADO,
      DESCUENTO_EXENTO,
      BODEGA,
      APRUEBA_FACT_DIRECTA,
      ESTADO_SRI,
      FORMA_PAGO_SRI,
      NUMERO_CTRL
    )
    VALUES
    (
      Pv_NoCia,
      Pv_Centro,
      Pv_TipoDoc,
      Lr_PeriodoProceso.Ano_Proce_Fact,
      Pv_Ruta,
      Lv_NoFactu,
      Pv_AfectASaldo,
      Pv_Grupo,
      Lr_Clientes.No_Cliente,
      Pv_TipoCliente,
      Lr_Clientes.Nombre,
      Lr_Clientes.Direccion,
      Ld_Fecha,
      1,
      Pv_Vendedor,
      1,
      Pv_Observ1,
      0,
      0,
      0,
      0,0,
      'P',
      Lr_Clientes.Excento_Imp,
      'P',
      Lr_Clientes.Porc_Desc,
      Lv_NoFisico,
      Lv_SerieFisico,
      Lv_MonedaD ,
      0,0,
      'WS',
      '1',
      0,0,
      UPPER(Pv_Usuario),
      SYSDATE,
      Lr_Clientes.No_Cliente,
      Pv_Division,
      SYSDATE,
      0,0,0,
      0,
      Pv_BodegaCab,
      'S',
      'P',
      Pv_FormaPagoSri,
      Ln_NoCtrl
    );
EXCEPTION
WHEN Le_Error THEN
  Pv_Salida  := '403';
  Pv_Mensaje := 'Error ';
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('API-NAF', 
                                       'FAK_PROCESOS.P_INSERTA_ARFAFE', 
                                       'Error Le_Error -  P_INSERTA_ARFAFE: '||SQLERRM, 
                                       NVL(SYS_CONTEXT('USERENV','HOST'), USER), 
                                       SYSDATE, 
                                       NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), 
                                       '127.0.0.1'));
  ROLLBACK;
WHEN OTHERS THEN
  Pv_Salida  := '403';
  Pv_Mensaje := 'Error';
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('API-NAF', 
                                       'FAK_PROCESOS.P_INSERTA_ARFAFE', 
                                       'Error Otros - P_INSERTA_ARFAFE: '||SQLERRM, 
                                       NVL(SYS_CONTEXT('USERENV','HOST'), USER), 
                                       SYSDATE, 
                                       NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), 
                                       '127.0.0.1'));
  ROLLBACK;
END P_INSERTA_ARFAFE;
/**
* Documentacion para el procedimiento P_INSERTA_ARFAFL
* Procedimiento que realiza la insercion del detalle de la factura
* @author Sofia Fernandez <sfernandez@telconet.ec>
* @version 1.0 19-09-2016
*/
PROCEDURE P_INSERTA_ARFAFL
  (
    Pv_NoCia      IN VARCHAR2,
    Pv_Centro     IN VARCHAR2,
    Pv_TipoDoc    IN VARCHAR2,
    Pv_Periodo    IN VARCHAR2,
    Pv_Ruta       IN VARCHAR2,
    Lv_NoFactu    IN VARCHAR2,
    Pv_NoLinea    IN VARCHAR2,
    Pv_NoArti     IN VARCHAR2,
    Pn_Canti      IN NUMBER,
    Pv_BodegaDet  IN VARCHAR2,
    Pv_porcDesc   IN VARCHAR2,
    Pv_Moneda     IN VARCHAR2,
    Pv_TipoPrecio IN VARCHAR2,
    Pv_MonedaD    IN VARCHAR2,
    Pd_Fecha      IN DATE,
    Pv_Grupo      IN VARCHAR2,
    Pv_Salida OUT VARCHAR2,
    Pv_Mensaje OUT VARCHAR2
  )
IS
  CURSOR C_CIA_RELACIONADO
  IS
    SELECT 'X'
    FROM ARCCGR
    WHERE NO_CIA                            = Pv_NoCia
    AND GRUPO                               = Pv_Grupo
    AND NVL(IND_MARGEN_CIA_RELACIONADO,'N') = 'S';
  CURSOR C_DATOS
  IS
    SELECT FA.PORC_DESC,
      NVL(FA.IND_OFERTA,'S'),
      CG.CLASE_CAMBIO,
      FA.IND_MANEJA_RUTAS
    FROM ARFAMC FA,
      ARCGMC CG
    WHERE FA.NO_CIA = Pv_NoCia
    AND FA.NO_CIA   = CG.NO_CIA;
  CURSOR C_IVA
  IS
   SELECT IA.*, IMP.PORCENTAJE
   FROM ARINIA IA, ARCGIMP IMP
   WHERE IA.NO_CIA       = Pv_NoCia
   AND IA.NO_ARTI      = Pv_NoArti
   AND IA.AFECTA_VENTA = 'S'  
   AND IA.NO_CIA = IMP.NO_CIA
   AND IA.CLAVE = IMP.CLAVE  
   AND NVL(IMP.PRINCIPAL,'N') = 'S';
  CURSOR C_CANT_BONIF(Cv_NoFactu VARCHAR2, Cn_NoLinea NUMBER)
  IS
    SELECT NVL(PEDIDO,0) CANTIDAD_BONIFICACION
    FROM ARFAFL
    WHERE NO_CIA            = Pv_NoCia
    AND NO_FACTU            = Cv_NoFactu
    AND LINEA_ART_PROMOCION = Cn_NoLinea;
  CURSOR C_FACTURA
  IS
    SELECT *
    FROM ARFAFE
    WHERE NO_CIA = Pv_NoCia
    AND CENTROD  = Pv_Centro
    AND TIPO_DOC = Pv_TipoDoc
    AND NO_FACTU = Lv_NoFactu
    AND RUTA     = Pv_Ruta;
  Lr_Arti ARTICULO.DATOS_R;
  Lr_Datos C_DATOS%ROWTYPE      :=NULL;
  Ln_Costo ARINMA.COSTO_UNI%TYPE:=0;
  Ln_Costo2 ARINMA.COSTO2%TYPE  :=0;
  Ln_Precio ARINTP.PRECIO%TYPE  :=0;
  Ld_Aux    DATE;
  Lv_Existe VARCHAR2(1)                       :=NULL;
  Lv_IndIva VARCHAR2(1)                       :='S';
  Lr_Iva C_IVA%ROWTYPE      :=NULL;
  Ln_ValorIva ARFAFL.I_VEN_N%TYPE             :=0;
  Ln_Subtotal ARFAFL.TOTAL%TYPE               :=0;
  Lv_TipoCambio ARFAFE.TIPO_CAMBIO%TYPE       :=0;
  Ln_Total ARFAFL.TOTAL%TYPE                  :=0;
  Ln_Descuento ARFAFL.DESCUENTO%TYPE          :=0;
  Ln_MargenValorFl ARFAFL.Margen_Valor_Fl%TYPE:=0;
  Ln_MargenPorcFl ARFAFL.Margen_Porc_Fl%TYPE  :=0;
  Ln_LineaArtPromocion ARFAFL.LINEA_ART_PROMOCION%TYPE;
  Lr_Factura C_FACTURA%ROWTYPE := NULL;
  Ln_MargenMinimo ARFAFL.Margen_Minimo%TYPE;
  Ln_MargenObjetivo ARFAFL.Margen_Objetivo%TYPE;
  Ln_Valor    NUMBER;
  Ln_Valor2   NUMBER;
  Ln_PorcDesc NUMBER;
  Lv_ErrorM   VARCHAR2(500);
  Le_Error    EXCEPTION;
BEGIN
  Lr_Arti:= ARTICULO.TRAE_DATOS(Pv_NoCia, Pv_NoArti);
  --Precio
  Ln_Precio    := precio_venta(Pv_NoCia, Pv_TipoPrecio, Pv_NoArti);
  IF Ln_Precio IS NULL THEN
    RAISE Le_Error;
  END IF;
  IF C_DATOS%ISOPEN THEN
    CLOSE C_DATOS;
  END IF;
  OPEN C_DATOS;
  FETCH C_DATOS INTO Lr_Datos;
  CLOSE C_DATOS;
  Lv_TipoCambio           := TIPO_CAMBIO(Lr_Datos.ClASe_Cambio, Pd_Fecha, Ld_Aux, 'C');
  IF NVL(Lv_TipoCambio,0) <= 0 THEN
    RAISE Le_Error;
  END IF;
  IF Pv_MonedaD = 'D' AND Pv_Moneda = 'P' THEN
    -- CONVIERTE PRECIO A DOLARES
    Ln_Precio     := Ln_Precio / Lv_TipoCambio;
  ELSIF Pv_MonedaD = 'P' AND Pv_Moneda = 'D' THEN
    -- COVIERTE PRECIO A NOMINAL
    Ln_Precio := Ln_Precio * Lv_TipoCambio;
  END IF;
  OPEN C_CIA_RELACIONADO;
  FETCH C_CIA_RELACIONADO INTO Lv_Existe;
  IF C_CIA_RELACIONADO%FOUND OR Lv_Existe IS NOT NULL THEN
    CLOSE C_CIA_RELACIONADO;
    Ln_Precio := FA_PRECIO_CIA_RELACIONADA(Pv_NoCia, Pv_Grupo, Ln_Costo2);
  END IF;
  IF NVL(Ln_Precio, 0) <= 0 THEN
    RAISE Le_Error;
  END IF;
  Ln_Total      := NVL((Pn_Canti*Ln_Precio),0);
  IF Pv_porcDesc = 0 THEN
    Ln_Descuento:=0;
  ELSE
    Ln_Descuento := NVL ( (Pv_porcDesc/100)*Ln_Total ,0);
  END IF;
  IF C_IVA%ISOPEN THEN
    CLOSE C_IVA;
  END IF;
  OPEN C_IVA;
  FETCH C_IVA INTO Lr_Iva;
  CLOSE C_IVA;
  Ln_Subtotal               := NVL((Ln_Total - Ln_Descuento),0);
  Ln_ValorIva               := ROUND(NVL(((Lr_Iva.Porcentaje /100)*Ln_Subtotal),0),2);
  IF Pv_BodegaDet           <> '0000' THEN
    Ln_Costo                := NVL(ARTICULO.COSTO(Pv_NoCia, Pv_NoArti, Pv_BodegaDet),0);
    Ln_Costo2               := NVL(ARTICULO.COSTO2(Pv_NoCia, Pv_NoArti, Pv_BodegaDet),0);
    IF Ln_LineaArtPromocion IS NULL THEN
      Ln_MargenValorFl      :=(Ln_Subtotal)-(NVL(Ln_Costo2,0) * (NVL(Pn_Canti,0) + NVL(Ln_Valor2,0)));
      IF Ln_Subtotal         = 0 THEN
        Ln_MargenPorcFl     :=(NVL(Ln_MargenValorFl,0)/1)*100;
      ELSE
        Ln_MargenPorcFl:= (NVL(Ln_MargenValorFl,0)/(Ln_Subtotal))*100;
      END IF;
    END IF;
  ELSE
    Ln_MargenValorFl:=0;
    Ln_MargenPorcFl :=0;
    Ln_Costo        := 0;
    Ln_Costo2       := 0;
  END IF;
  --
  --Clientes
  IF C_FACTURA%ISOPEN THEN
    CLOSE C_FACTURA;
  END IF;
  OPEN C_FACTURA;
  FETCH C_FACTURA INTO Lr_Factura;
  CLOSE C_FACTURA;
  PU_DEVUELVE_MARGEN(Pv_NoCia, 
                     Pv_Centro, 
                     Lr_Factura.Division_Comercial, 
                     Lr_Factura.Tipo_Cliente, 
                     Pv_Grupo, 
                     Lr_Factura.No_Cliente, 
                     Lr_Factura.Subcliente, 
                     Lr_Arti.division, 
                     Lr_Arti.subdivision, 
                     Pv_NoArti, 
                     Ln_MargenMinimo, 
                     Ln_MargenObjetivo, 
                     Ln_PorcDesc, 
                     'S', 
                     Lv_ErrorM) ;
  IF Lv_ErrorM IS NOT NULL THEN
    RAISE Le_Error;
  END IF;
  --
  --
  IF C_CANT_BONIF%ISOPEN THEN
    CLOSE C_CANT_BONIF;
  END IF;
  OPEN C_CANT_BONIF(Lv_NoFactu,Pv_NoLinea);
  FETCH C_CANT_BONIF INTO Ln_Valor;
  IF C_CANT_BONIF%NOTFOUND THEN
    CLOSE C_CANT_BONIF;
    Ln_Valor2:=0;
  ELSE
    Ln_Valor2:=Ln_Valor;
  END IF;
  INSERT
  INTO ARFAFL
    (
      NO_CIA,
      CENTROD,
      TIPO_DOC,
      PERIODO,
      RUTA,
      NO_FACTU,
      NO_LINEA,
      BODEGA,
      CLASE,
      CATEGORIA,
      NO_ARTI,
      PEDIDO,
      PORC_DESC,
      COSTO,
      PRECIO,
      DESCUENTO,
      TOTAL,
      I_VEN,
      I_VEN_N,
      TIPO_PRECIO,
      COSTO2,
      DIVISION,
      SUBDIVISION,
      TSTAMP,
      UN_DEVOL,
      IMP_INCLUIDO,
      IMP_ESPECIAL,
      MARGEN_VALOR_FL,
      MARGEN_PORC_FL,
      MARGEN_MINIMO,
      MARGEN_OBJETIVO
    )
    VALUES
    (
      Pv_NoCia,
      Pv_Centro,
      Pv_TipoDoc,
      Pv_Periodo,
      Pv_Ruta,
      Lv_NoFactu,
      Pv_NoLinea,
      Pv_BodegaDet,
      Lr_Arti.clASe,
      Lr_Arti.categoria,
      Pv_NoArti,
      Pn_Canti,
      Pv_porcDesc,
      Ln_Costo,
      Ln_Precio,
      Ln_Descuento,
      Ln_Total,
      Lr_Arti.imp_ven,
      Ln_ValorIva,
      Pv_TipoPrecio,
      Ln_Costo2,
      Lr_Arti.division,
      Lr_Arti.subdivision,
      SYSDATE,
      0,0,0,
      Ln_MargenValorFl,
      Ln_MargenPorcFl,
      Ln_MargenMinimo,
      Ln_MargenObjetivo
    );
  P_INSERTA_ARFAFLI(Pv_NoCia, 
                    Pv_TipoDoc, 
                    Lv_NoFactu, 
                    Pv_NoLinea, 
                    Pv_NoArti, 
                    Lv_IndIva, 
                    Pv_Grupo, 
                    Lr_Factura.No_Cliente, 
                    Pv_BodegaDet, 
                    Pv_Centro, 
                    Ln_ValorIva, 
                    Ln_Total, 
                    Pv_Salida, 
                    Pv_Mensaje);
EXCEPTION
WHEN Le_Error THEN
  Pv_Salida  := '403';
  Pv_Mensaje := 'Error';
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('API-NAF', 
                                       'FAK_PROCESOS.P_INSERTA_ARFAFL', 
                                       'Error Le_Error - P_INSERTA_ARFAFL: '||SQLERRM, 
                                       NVL(SYS_CONTEXT('USERENV','HOST'), USER), 
                                       SYSDATE, 
                                       NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), 
                                       '127.0.0.1'));
  ROLLBACK;
WHEN OTHERS THEN
  Pv_Salida  := '403';
  Pv_Mensaje := 'Error';
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('API-NAF', 
                                       'FAK_PROCESOS.P_INSERTA_ARFAFL', 
                                       'Error Otros - P_INSERTA_ARFAFL: '||SQLERRM, 
                                       NVL(SYS_CONTEXT('USERENV','HOST'), USER), 
                                       SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), 
                                       '127.0.0.1'));
  ROLLBACK;
END P_INSERTA_ARFAFL;
/**
* Documentacion para el procedimiento P_INSERTA_ARFAFLI
* Procedimiento que inserta detalle de impuesto de la factura
* @author Sofia Fernandez <sfernandez@telconet.ec>
* @version 1.0 19-09-2016
*/
PROCEDURE P_INSERTA_ARFAFLI
  (
    Pv_NoCia     IN VARCHAR2,
    Pv_TipoDoc   IN VARCHAR2,
    Pv_NoFactu   IN VARCHAR2,
    Pv_NoLinea   IN VARCHAR2,
    Pv_NoArti    IN VARCHAR2,
    Pv_IndIva    IN VARCHAR2,
    Pv_Grupo     IN VARCHAR2,
    Pv_NoCliente IN VARCHAR2,
    Pv_BodegaDet IN VARCHAR2,
    Pv_Centro    IN VARCHAR2,
    Pn_ValorIva  IN NUMBER,
    Pn_Total     IN NUMBER,
    Pv_Salida OUT VARCHAR2,
    Pv_Mensaje OUT VARCHAR2
  )
IS
  CURSOR C_IMPUESTOS
  IS
    SELECT IA.*
    FROM ARINIA IA,
      ARCGIMP IMP
    WHERE IA.NO_CIA            = Pv_NoCia
    AND IA.NO_ARTI             = Pv_NoArti
    AND IA.AFECTA_VENTA        = 'S'
    AND IA.NO_CIA              = IMP.NO_CIA
    AND IA.CLAVE               = IMP.CLAVE
    AND NVL(IMP.PRINCIPAL,'N') = Pv_IndIva;
  CURSOR C_CLIENTE
  IS
    SELECT *
    FROM ARCCMC
    WHERE NO_CIA                   = Pv_NoCia
    AND CENTRO                     = Pv_Centro
    AND NO_CLIENTE                 = Pv_NoCliente;

  Lr_Impuestos C_IMPUESTOS%ROWTYPE:= NULL;
  Lv_IdSec ARCGDISEC.ID_SEC%TYPE;
  Ln_Imp ARFAFLI.Monto_Imp%TYPE;
  Lr_Clientes C_CLIENTE%ROWTYPE := NULL;
  Ln_PorcImp ARFAFLI.PORC_IMP%TYPE;
  Lv_ColImp ARFAFLI.COLUMNA%TYPE;
  Lv_CompImp ARFAFLI.COMPORTAMIENTO%TYPE;
  Ln_ImpLinea ARFAFLI.Monto_Imp%TYPE;
  Ln_BASe         NUMBER       :=0;
  Ln_MontoBienes  NUMBER       :=0;
  Ln_MontoServic  NUMBER       :=0;
  Lv_MensajeError VARCHAR2(500):=NULL;
  Le_Error        EXCEPTION;
BEGIN
  IF C_CLIENTE%ISOPEN THEN
    CLOSE C_CLIENTE;
  END IF;
  OPEN C_CLIENTE;
  FETCH C_CLIENTE INTO Lr_Clientes;
  CLOSE C_CLIENTE;
  IF C_IMPUESTOS%ISOPEN THEN
    CLOSE C_IMPUESTOS;
  END IF;
  OPEN C_IMPUESTOS;
  FETCH C_IMPUESTOS INTO Lr_Impuestos;
  CLOSE C_IMPUESTOS;
  FOR Lr_Impuestos IN C_IMPUESTOS
  LOOP
    Lv_IdSec           := CCSector_impuesto(Pv_NoCia, Pv_Grupo, Pv_NoCliente, Lr_Impuestos.Clave, Lv_MensajeError);
    IF Lv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;
    IF NOT IMPUESTO.ESRETENCION (Pv_NoCia,Lr_Impuestos.Clave) THEN
      --
      -- calcula el monto base sobre el que se aplicara el impuesto.
      IF Pv_BodegaDet <> '0000' THEN
        Ln_MontoBienes:= Pn_Total;
      ELSE
        Ln_MontoServic:= Pn_Total;
      END IF;
      Ln_BASe         := IMPUESTO.CALCULA_BASE(Pv_NoCia, 
                                               Lr_Impuestos.Clave, 
                                               Pn_Total, NVL(Ln_MontoBienes,0), 
                                               NVL(Ln_MontoServic,0), 
                                               0, 
                                               0, 
                                               Lv_IdSec, 
                                               TRUNC(SYSDATE));
      Ln_Imp          :=Pn_ValorIva;
      Ln_Imp          := MONEDA.REDONDEO(Ln_Imp, Lr_Clientes.Moneda_Limite);
      Ln_PorcImp      := IMPUESTO.PORCENTAJE(Pv_NoCia, Lr_Impuestos.Clave, Lv_IdSec, TRUNC(SYSDATE));
      Lv_CompImp      := IMPUESTO.COMPORTAMIENTO(Pv_NoCia, Lr_Impuestos.Clave);
      Lv_ColImp       := IMPUESTO.COLUMNA(Pv_NoCia, Lr_Impuestos.Clave);
      IF NVL(Ln_Imp,0) > 0 THEN
        ---
        Ln_ImpLinea := NVL(Ln_ImpLinea,0) + Ln_Imp;
        ---
        INSERT
        INTO ARFAFLI
          (
            NO_CIA,
            NO_FACTU,
            TIPO_DOC,
            NO_LINEA,
            CLAVE,
            PORC_IMP,
            MONTO_IMP,
            COLUMNA,
            BASE,
            COMPORTAMIENTO,
            APLICA_CRED_FISCAL,
            ID_SEC
          )
          VALUES
          (
            Pv_NoCia,
            Pv_NoFactu,
            Pv_TipoDoc,
            Pv_NoLinea,
            Lr_Impuestos.Clave,
            Ln_PorcImp,
            Ln_Imp,
            Lv_ColImp,
            Ln_BASe,
            Lv_CompImp,
            'S',
            Lv_IdSec
          );
        ---
      END IF;
    END IF;
  END LOOP;
EXCEPTION
WHEN Le_Error THEN
  Pv_Salida  := '403';
  Pv_Mensaje := 'Error';
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('API-NAF', 
                                       'FAK_PROCESOS.P_INSERTA_ARFAFLI', 
                                       'Error Le_Error - P_INSERTA_ARFAFLI: '||SQLERRM, 
                                       NVL(SYS_CONTEXT('USERENV','HOST'), USER), 
                                       SYSDATE, 
                                       NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), 
                                       '127.0.0.1'));
  ROLLBACK;
WHEN OTHERS THEN
  Pv_Salida  := '403';
  Pv_Mensaje := 'Error';
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('API-NAF', 
                                       'FAK_PROCESOS.P_INSERTA_ARFAFLI', 
                                       'Error Otros - P_INSERTA_ARFAFLI: '||SQLERRM, 
                                       NVL(SYS_CONTEXT('USERENV','HOST'), USER),
                                       SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), 
                                       '127.0.0.1'));
  ROLLBACK;
END P_INSERTA_ARFAFLI;
/**
* Documentacion para el procedimiento P_ACTUALIZA_ARFAFE
* Procedimiento que realiza la actualizacion de la factura
* @author Sofia Fernandez <sfernandez@telconet.ec>
* @version 1.0 19-09-2016
*/
PROCEDURE P_ACTUALIZA_ARFAFE
  (
    Pv_NoCia   IN VARCHAR2,
    Pv_Centro  IN VARCHAR2,
    Pv_TipoDoc IN VARCHAR2,
    Pv_Ruta    IN VARCHAR2,
    Lv_NoFactu IN VARCHAR2,
    Pv_Salida OUT VARCHAR2,
    Pv_Mensaje OUT VARCHAR2
  )
IS
  CURSOR C_FACTURA
  IS
    SELECT *
    FROM ARFAFE
    WHERE NO_CIA = Pv_NoCia
    AND CENTROD  = Pv_Centro
    AND TIPO_DOC = Pv_TipoDoc
    AND NO_FACTU = Lv_NoFactu
    AND RUTA     = Pv_Ruta;
  CURSOR C_DET_FACTURA
  IS
    SELECT *
    FROM ARFAFL
    WHERE NO_CIA               = Pv_NoCia
    AND CENTROD                = Pv_Centro
    AND TIPO_DOC               = Pv_TipoDoc
    AND NO_FACTU               = Lv_NoFactu
    AND RUTA                   = Pv_Ruta;
  Lr_Factura C_FACTURA%ROWTYPE:= NULL;
  Ln_TotLinea     NUMBER          :=0;
  Ln_TotImp       NUMBER          :=0;
  Ln_TotBienes    NUMBER          :=0;
  Ln_TotServicios NUMBER          :=0;
  Ln_Total        NUMBER          :=0;
  Le_Error        EXCEPTION;
BEGIN
  IF C_FACTURA%ISOPEN THEN
    CLOSE C_FACTURA;
  END IF;
  IF C_DET_FACTURA%ISOPEN THEN
    CLOSE C_DET_FACTURA;
  END IF;
  OPEN C_FACTURA;
  FETCH C_FACTURA INTO Lr_Factura;
  IF C_FACTURA%NOTFOUND OR Lr_Factura.No_Factu IS NULL THEN
    RAISE Le_Error;
  ELSE
    FOR I IN C_DET_FACTURA
    LOOP
      Ln_TotLinea      := Ln_TotLinea+ I.TOTAL;
      Ln_TotImp        := Ln_TotImp  + I.I_VEN_N;
      IF I.BODEGA       = '0000' THEN
        Ln_TotServicios:= Ln_TotServicios+ I.TOTAL;
      ELSE
        Ln_TotBienes:= Ln_TotBienes +I.TOTAL;
      END IF;
    END LOOP;
    Ln_Total:=Ln_TotLinea+Ln_TotImp;
    UPDATE ARFAFE
    SET TOT_LIN    = NVL(Ln_TotLinea,0),
      SUB_TOTAL    = NVL(Ln_TotLinea,0),
      IMPUESTO     = NVL(Ln_TotImp,0),
      TOTAL        = NVL(Ln_Total,0),
      MONTO_BIENES = NVL(Ln_TotBienes,0),
      MONTO_SERV   = NVL(Ln_TotServicios,0),
      GRAVADA      =0 ,
      EXENTO       =0
    WHERE NO_CIA   = Pv_NoCia
    AND CENTROD    = Pv_Centro
    AND TIPO_DOC   = Pv_TipoDoc
    AND RUTA       = Pv_Ruta
    AND NO_FACTU   = Lv_NoFactu;
  END IF;
  CLOSE C_FACTURA;
EXCEPTION
WHEN OTHERS THEN
  Pv_Salida  := '403';
  Pv_Mensaje := 'Error';
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('API-NAF', 
                                       'FAK_PROCESOS.P_ACTUALIZA_ARFAFE', 
                                       'Error Otros - P_ACTUALIZA_ARFAFE: '||SQLERRM, 
                                       NVL(SYS_CONTEXT('USERENV','HOST'), USER), 
                                       SYSDATE, 
                                       NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), 
                                       '127.0.0.1'));
  ROLLBACK;
END P_ACTUALIZA_ARFAFE;
/**
* Documentacion para el procedimiento P_XML_FACTURA
* Procedimiento que realiza la generacion la factura a xml
* @author Sofia Fernandez <sfernandez@telconet.ec>
* @version 1.0 19-09-2016
*
* @author Luis Lindao <sfernandez@telconet.ec>
* @version 1.1 25-06-2020 - Se modifica para dar formato de valores a los campos montos del archivo xml. 
*
*/
PROCEDURE P_XML_FACTURA(
    Pv_NoCia   IN VARCHAR2,
    Pv_Centro  IN VARCHAR2,
    Pv_TipoDoc IN VARCHAR2,
    Pv_NoFactu IN VARCHAR2,
    Pv_Salida OUT VARCHAR2,
    Pv_Mensaje OUT VARCHAR2,
    Pv_NumeroFactura OUT VARCHAR2,
    Pclob_XmlFactura OUT CLOB)
IS
  CURSOR C_XML
  IS


 SELECT XMLROOT(XMLElement("factura", XMLAttributes('1.0.0' AS "version",'comprobante' AS "id"),
                                 XMLElement("infoTributaria", XMLElement("razonSocial",gek_consulta.gef_elimina_caracter_esp(c.razon_social)),
                                                              XMLElement("nombreComercial",gek_consulta.gef_elimina_caracter_esp(c.razon_social)),
                                                              XMLElement("ruc",c.id_tributario),
                                                              XMLElement("codDoc",'01'),
                                                              XMLElement("estab",Substr(a.serie_fisico, 1, 3)),
                                                              XMLElement("ptoEmi",Substr(a.serie_fisico,4,3)), 
                                                              XMLElement("secuencial",lpad(a.no_fisico , 9, '0')),
                                                              XMLElement("dirMatriz",gek_consulta.gef_elimina_caracter_esp(c.direccion))
                                            ),
                    XMLElement("infoFactura", XMLElement("fechaEmision",to_char(a.fecha,'dd/mm/yyyy')),
                                              XMLElement("dirEstablecimiento",gek_consulta.gef_elimina_caracter_esp(c.direccion)),
                                              (SELECT XMLElement("contribuyenteEspecial", X.parametro) 
                                                 FROM ge_parametros x, ge_grupos_parametros y
                                                WHERE x.id_grupo_parametro = y.id_grupo_parametro
                                                  AND x.id_aplicacion = y.id_aplicacion
                                                  AND x.id_empresa = y.id_empresa
                                                  AND x.id_grupo_parametro = 'ES_CONTRIB_ESPECIAL'
                                                  AND x.id_aplicacion = 'CP'
                                                  AND x.id_empresa = a.no_cia
                                                  AND x.estado = 'A'
                                                  AND y.estado = 'A'),
                                              XMLElement("obligadoContabilidad",'SI'),
                                              (SELECT XMLElement("tipoIdentificacionComprador", w.codigo)
                                                  FROM sri_secuenciales_transacciones w 
                                                 WHERE w.codigo_identificacion = b.tipo_id_tributario
                                                   AND w.codigo_tipo_trans = 2),
                                              XMLElement("razonSocialComprador",gek_consulta.gef_elimina_caracter_esp(b.razon_social)),
                                              XMLElement("identificacionComprador",b.cedula),
                                              (SELECT XMLForest (TRIM(TO_CHAR(sum(d.total - nvl(a.descuento,0)),'999999999990.90')) AS "totalSinImpuestos",
                                                                TRIM(TO_CHAR(sum(nvl(d.descuento,0)),'999999999990.90')) AS "totalDescuento")
                                                 FROM arfafl d
                                                WHERE d.no_cia = a.no_cia
                                                  AND d.no_factu = a.no_factu),
                           (SELECT XMLElement("totalConImpuestos",
                                              XMLElement("totalImpuesto",
                                                         XMLForest ( '2' AS "codigo",
                                                                     i.sri_codigo_iva AS "codigoPorcentaje",
                                                                     TRIM(TO_CHAR(sum(mi.base),'999999999990.90')) AS "baseImponible",
                                                                     TRIM(TO_CHAR(sum(mi.Monto_Imp),'999999999990.90')) AS "valor")))
                              FROM arfafli mi,
                                   arcgimp i
                             WHERE mi.clave = i.clave
                               AND mi.no_cia = i.no_cia
                               AND mi.no_factu = a.no_factu
                               AND mi.tipo_doc = a.tipo_doc
                               AND mi.no_cia = a.no_cia
                             group by i.sri_codigo_iva, mi.Porc_Imp),
                            (SELECT XMLForest ('0.00' AS "propina",
                                               TRIM(TO_CHAR(sum(nvl(xy.total,0) + nvl(xy.i_ven_n,0) - nvl(xy.descuento,0)),'999999999990.90')) AS "importeTotal",
                                               'DOLAR' AS "moneda" )
                              FROM arfafl xy
                             WHERE xy.no_cia = a.no_cia
                               AND xy.no_factu = a.no_factu),
                             --
                               ( XMLElement("pagos",
                                              XMLElement("pago",
                                                         (SELECT XMLForest( a.forma_pago_sri AS "formaPago",
                                                                 TRIM(TO_CHAR(sum(nvl(ff.total,0) + nvl(ff.i_ven_n,0) - nvl(ff.descuento,0)),'999999999990.90')) AS "total")
                                                FROM arfafl ff
                                                WHERE ff.no_cia = a.no_cia
                                                  AND ff.no_factu = a.no_factu
                                                         ),

                                                         (SELECT XMLForest (cp.plazo AS "plazo")
                                                                       From arccplazos cp 
                                                                       WHERE cp.no_cia = a.no_cia
                                                                         AND cp.codigo = a.codigo_plazo),

                                                         XMLElement ("unidadTiempo", 'dias')

                                                         )

                                                 )
                                                 )
                             --  




                             ),                                                                               
                            XMLElement("detalles",(SELECT XMLAgg(
                                                      XMLElement("detalle",
                                                        XMLForest 
                                                           ( r.no_arti AS "codigoPrincipal",
                                                             n.descripcion AS "descripcion",
                                                             r.pedido AS "cantidad",
                                                             TRIM(TO_CHAR(nvl(r.precio,0),'999999999990.90')) AS "precioUnitario",
                                                             TRIM(TO_CHAR(nvl(r.descuento,0),'999999999990.90')) AS "descuento",
                                                             TRIM(TO_CHAR((( nvl(r.pedido,0) * nvl(r.precio,0)) - nvl(r.descuento,0)),'999999999990.90')) AS "precioTotalSinImpuesto"
                                                            ),
                                                             (SELECT XMLElement("impuestos",
                                                              XMLElement("impuesto",
                                                                         XMLForest('2' AS "codigo",
                                                                                   sri_codigo_iva AS "codigoPorcentaje",
                                                                                   a.porcentaje AS "tarifa"
                                                                                   ),
                                                                                   XMLElement("baseImponible", TRIM(TO_CHAR((nvl(r.total,0) - nvl(r.descuento,0)),'999999999990.90'))),
                                                                                   XMLElement("valor", TRIM(TO_CHAR(nvl(r.i_ven_n,0),'999999999990.90')) )
                                                                                   ))
                                                                                   FROM arcgimp a
                                                                                   WHERE no_cia = a.no_cia
                                                                                     AND afecta = 'V'
                                                                                     AND ind_retencion = 'N'
                                                                                     AND grupo = 'IVA' 
                                                                                     AND clave in (SELECT DISTINCT(CLAVE) CLAVE 
                                                                                                     FROM ARFAFLI 
                                                                                                    WHERE NO_CIA = a.no_cia
                                                                                                      AND NO_FACTU = a.no_factu
                                                                                                      AND ROWNUM=1)

                                                            )
                                                            ))                                                           

                                                FROM arfafl r,
                                                     arinda n
                                               WHERE r.no_arti = n.no_arti
                                                 AND r.no_cia = n.no_cia
                                                 AND r.no_cia = a.no_cia
                                                 AND r.no_factu = a.no_factu)),
                    XMLElement("infoAdicional", XMLElement("campoAdicional", XMLAttributes('emailCliente' AS "nombre"),b.email1),
                                                XMLElement("campoAdicional", XMLAttributes('dirCliente' AS "nombre"),
                                                           gek_consulta.gef_elimina_caracter_esp(b.direccion)),
                                                XMLElement("campoAdicional", XMLAttributes('telfCliente' AS "nombre"),
                                                           gek_consulta.gef_elimina_caracter_esp(b.telefono)),
                                                (SELECT XMLElement("campoAdicional", XMLAttributes('ciudadCliente' AS "nombre"),
                                                                   gek_consulta.gef_elimina_caracter_esp(t.descripcion))
                                                     FROM argecan t
                                                     WHERE t.canton = b.canton
                                                       AND t.provincia = b.provincia
                                                       AND t.pais = b.pais),
                                                XMLElement("campoAdicional", XMLAttributes('numeroCliente' AS "nombre"), b.grupo||'-'||b.no_cliente),
                                                XMLElement("campoAdicional", XMLAttributes('observacion' AS "nombre"),
                                                           gek_consulta.gef_elimina_caracter_esp(a.observ1))
                                                    )     
                     ), VERSION '1.0" encoding="UTF-8') xml_factura
      FROM arfafe a,
           arccmc b,
           arcgmc c
     WHERE a.no_cia = c.no_cia
       AND a.no_cliente = b.no_cliente
       AND a.grupo = b.grupo
       AND a.no_cia = b.no_cia
    AND a.no_factu   = Pv_NoFactu
    AND a.no_cia     = Pv_NoCia
    AND a.centrod    = Pv_Centro
    AND a.tipo_doc   = Pv_TipoDoc;




    CURSOR C_Factura
    IS
      SELECT SUBSTR(a.serie_fisico, 1, 3) Establecimiento,
        SUBSTR(a.serie_fisico, 4, 3) PuntoEmision,
        Lpad(a.no_fisico, 9, '0') Secuencia,
        a.fecha,
        b.tipo_id_tributario,
        b.razon_social,
        b.cedula,
        b.email1 emailCliente,
        b.direccion dirCliente,
        b.telefono telfCliente,
        b.pais,
        b.provincia,
        b.canton,
        b.grupo
        ||'-'
        ||b.no_cliente numeroCliente,
        a.observ1,
        a.numero_envio_sri
      FROM arfafe a,
        arccmc b
      WHERE a.no_cliente = b.no_cliente
      AND a.grupo        = b.grupo
      AND a.no_cia       = b.no_cia
      AND a.no_factu     = Pv_NoFactu
      AND a.no_cia       = Pv_NoCia;
    LXML_Factura XMLTYPE;
    Lr_Factura C_Factura%RowType := NULL;
    Lv_NombreArchivo VARCHAR2(1000);
    Lv_MensajeError  VARCHAR2(1000);
    Le_ErrorXml      EXCEPTION;
  BEGIN
    IF C_XML%ISOPEN THEN
      CLOSE C_XML;
    END IF;
    OPEN C_XML;
    FETCH C_XML INTO LXML_Factura;
    IF C_XML%NOTFOUND THEN
      RAISE Le_ErrorXml;
    END IF;
    CLOSE C_XML;
    --
    -- datos de Factura
    IF C_FACTURA%ISOPEN THEN
      CLOSE C_FACTURA;
    END IF;
    OPEN C_FACTURA;
    FETCH C_FACTURA INTO LR_FACTURA;
    IF C_FACTURA%NOTFOUND THEN
      RAISE Le_ErrorXml;
    END IF;
    CLOSE C_FACTURA;
    IF LXML_Factura                IS NOT NULL THEN
      Pclob_XmlFactura             := REPLACE(REPLACE(LXML_Factura.GETCLOBVAL(), 'ñ', 'n'), 'Ñ', 'N');
      IF Lr_Factura.Numero_Envio_Sri= 0 THEN
        Lv_NombreArchivo           := 'FACTURA_'|| Lr_Factura.Establecimiento ||'-'|| Lr_Factura.PuntoEmision ||'-'|| Lr_Factura.Secuencia ||'.xml';
      ELSE
        Lv_NombreArchivo := 'FACTURA_'|| Lr_Factura.Establecimiento ||'-'|| 
                                         Lr_Factura.PuntoEmision ||'-'|| 
                                         Lr_Factura.Secuencia ||'-'|| 
                                         TO_CHAR(Lr_Factura.fecha,'dd') ||'-'|| 
                                         TO_CHAR(sysdate,'hh24') ||'-'|| 
                                         TO_CHAR(sysdate,'mi') ||'-'|| TO_CHAR(sysdate,'ss') ||'.xml';
      END IF;

      UPDATE Arfafe
      SET estado_sri     = '1',                        
        numero_envio_sri = NVL(numero_envio_sri,0) + 1, 
        nombre_archivo   = Lv_NombreArchivo,  
        tstamp           = SYSDATE           
      WHERE no_cia       = Pv_NoCia
      AND no_factu       = Pv_NoFactu;

      IF Lv_MensajeError IS NOT NULL THEN
        RAISE Le_ErrorXml;
      END IF;
      Pv_Salida := '200';
      Pv_Mensaje:= 'Transacción Realizada Correctamente';
    ELSE
      Lv_MensajeError:= 'LXML_Factura Vacio';
      RAISE Le_ErrorXml;
    END IF;
    Pv_NumeroFactura:= Lr_Factura.Establecimiento || Lr_Factura.PuntoEmision || Lr_Factura.Secuencia;
  EXCEPTION
  WHEN Le_ErrorXml THEN
    Pv_Salida := '403';
    Pv_Mensaje:= 'Error';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('API-NAF', 
                                         'FAK_PROCESOS.P_XML_FACTURA', 
                                         'Error Le_ErrorXml - P_XML_FACTURA: '||Lv_MensajeError || ' - '|| SQLERRM, 
                                         NVL(SYS_CONTEXT('USERENV','HOST'), USER), 
                                         SYSDATE, 
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), 
                                         '127.0.0.1'));
    ROLLBACK;
  WHEN OTHERS THEN
    Pv_Salida  := '403';
    Pv_Mensaje := 'Error';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('API-NAF', 
                                         'FAK_PROCESOS.P_XML_FACTURA', 
                                         'Error Otros - P_XML_FACTURA: '||SQLERRM, 
                                         NVL(SYS_CONTEXT('USERENV','HOST'), USER), 
                                         SYSDATE, 
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), 
                                         '127.0.0.1'));
    ROLLBACK;
  END P_XML_FACTURA;
  /**
* Documentacion para el procedimiento P_JOB_FAACTUALIZA
* Procedimiento que verifica las transacciones pendientes de actualizar, actualiza el orgen a FA
* @author Sofia Fernandez <sfernandez@telconet.ec>
* @version 1.0 26-09-2016
* @author Sofia Fernandez <sfernandez@telconet.ec>
* @version 1.1 24-10-2016 Se elimina la variable Lr_Transaccion debido a que no se está utilizando
* @author Luis Lindao <llindao@telconet.ec>
* @version 1.2 30-12-2016 Se modifica query principal agregar comillas simples al filtro del campo ESTADO_SRI porque es Texto 
*/
  PROCEDURE P_JOB_FAACTUALIZA
  IS
  CURSOR C_TRANSACCIONES IS
    SELECT NO_CIA, CENTROD, TIPO_DOC, NO_FACTU
    FROM ARFAFE
    WHERE ORIGEN = 'WS'
    AND ESTADO = 'P'
    AND ESTADO_SRI = '5'
    AND CLAVE_ACCESO IS NOT NULL
    AND NO_AUTORIZACION IS NOT NULL;

  Lv_MensajeError Varchar2(500):= NULL;
  Le_error Exception;

  BEGIN
    IF C_TRANSACCIONES%ISOPEN THEN CLOSE C_TRANSACCIONES; END IF;
    FOR I IN C_TRANSACCIONES LOOP
    UPDATE ARFAFE
    SET ORIGEN    = 'FA'
    WHERE NO_CIA   = I.NO_CIA
    AND TIPO_DOC   = I.TIPO_DOC
    AND NO_FACTU   = I.NO_FACTU;
    FAActualiza(I.NO_CIA, I.TIPO_DOC, I.NO_FACTU, Lv_MensajeError);
    IF Lv_MensajeError IS NOT NULL THEN
      RAISE Le_error;
    END IF;
    END LOOP;
   EXCEPTION
  WHEN Le_error THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('API-NAF', 
                                         'FAK_PROCESOS.P_JOB_FAACTUALIZA', 
                                         'Error Le_ErrorXml - P_JOB_FAACTUALIZA: '||Lv_MensajeError || ' - '|| SQLERRM, 
                                         NVL(SYS_CONTEXT('USERENV','HOST'), USER), 
                                         SYSDATE, 
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), 
                                         '127.0.0.1'));
    ROLLBACK;
  WHEN OTHERS THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('API-NAF', 
                                         'FAK_PROCESOS.P_JOB_FAACTUALIZA', 
                                         'Error Otros - P_JOB_FAACTUALIZA: '||SQLERRM, 
                                         NVL(SYS_CONTEXT('USERENV','HOST'), USER), 
                                         SYSDATE, 
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), 
                                         '127.0.0.1'));
    ROLLBACK;
  END P_JOB_FAACTUALIZA;

END FAK_PROCESOS;
/
