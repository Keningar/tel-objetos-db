create or replace PROCEDURE            GENERA_DEPOSITO_CC(PV_CIA        IN VARCHAR2,
                                               PV_CENTRO     IN VARCHAR2,
                                               PV_NOCTA_BCO  IN VARCHAR2,
                                               PN_MONTO      IN NUMBER,
                                               PV_MONEDA     IN VARCHAR2,
                                               PV_CTACREDITO IN VARCHAR2,
                                               PV_FISICO     IN VARCHAR2,
                                               PD_FECHA      IN DATE, --- Este parametro hay que enviar del dia de proceso de CxC ANR 23/07/2009
                                               PD_FECHA_DEP  IN DATE,
                                               PV_DOCU_COBRO IN VARCHAR2 default null,
                                               PV_DIVISION   IN VARCHAR2 default null,
                                               PV_USUARIO    IN VARCHAR2 default null,
                                               PV_FORMAPAGO  IN VARCHAR2 default null,
                                               PN_NO_DOCU    OUT NUMBER,
                                               PV_ERROR      OUT VARCHAR2)IS

-- Declaracion de Cursores locales
 CURSOR c_datos_bco(CV_CIA       VARCHAR2,
                    CV_NOCTA_BCO VARCHAR2
                   ) IS
  SELECT ano_proc,
         mes_proc,
         no_cuenta
   FROM arckmc
   WHERE no_cia = CV_CIA
   AND no_cta = CV_NOCTA_BCO;
 --
 CURSOR c_no_fisico_req(CV_CIA VARCHAR2
                       )IS
  SELECT no_fisico_requerido
  FROM arcktd
  WHERE no_cia = CV_CIA
  AND tipo_doc = 'DP';
 --
/* CURSOR C_MES_PROCESO(CV_CIA    VARCHAR2,
                      CV_CENTRO VARCHAR2
                     )IS
  SELECT cd.ano_proce_cxc,
         cd.mes_proce_cxc
   FROM arincd cd
   WHERE cd.no_cia = CV_CIA
   AND  cd.centro = CV_CENTRO;*/

Cursor C_Division (CV_CIA    VARCHAR2,
                   CV_CENTRO VARCHAR2) Is
 select descripcion, centro_costo
 from   arfa_div_comercial
 where  no_cia = cv_cia
 and    centro = cv_centro
 and    division = pv_division;

-- Declaracion de variables locales
 vcc             arckml.centro_costo%TYPE;
 vAno            arckmc.ano_proc%TYPE;
 vMes            arckmc.mes_proc%TYPE;
 vCuenta_debito  arcgms.cuenta%TYPE;
 vNo_dep         arckmm.no_fisico%TYPE;
 vSerie          arckmm.serie_fisico%TYPE;
 vMonto          arckml.monto%type;
 vMonto_dol      arckml.monto_dol%type;
 vMonto_dc       arckml.monto_dc%type;
 vOtros_meses    arckmm.ind_otros_meses%type;
 ln_mes_proceso  number;
 ln_anio_proceso number;
 ln_noDocu       number;
 vEncontro       boolean;
-- vExiste         boolean;
 le_error        exception;
 lv_error        varchar2(200);
 lv_noFisico_req varchar2(1);
 Lv_Referencia   Varchar2(250);
 --
 lv_glosa        VARCHAR2(100);

 Lv_desc_division Arfa_div_comercial.descripcion%type;
 Lv_cc_division   Arfa_div_comercial.centro_costo%type;

---
BEGIN

 --- Llena el centro de costo
 vcc       := centro_costo.rellenad(PV_CIA,'0');
 ln_noDocu := transa_id.ck(PV_CIA);

 --- Obtiene informacion general de la cuenta bancaria
 OPEN  c_datos_bco(PV_CIA,PV_NOCTA_BCO);
 FETCH c_datos_bco INTO vAno, vMes, vCuenta_debito;
 vEncontro := c_datos_bco%found;
 CLOSE c_datos_bco;

 IF NOT vEncontro THEN
   lv_error := 'No se puede accesar la informacion de la cuenta bancaria '||PV_NOCTA_BCO||
              ' para registrar el deposito.';
   RAISE le_error;
 END IF;
 --
 OPEN c_no_fisico_req(PV_CIA);
 FETCH c_no_fisico_req INTO lv_noFisico_req;
 IF c_no_fisico_req%NOTFOUND THEN
  CLOSE c_no_fisico_req;
  lv_error := 'El documento tipo DP no esta definido';
  RAISE le_error;
 END IF;
 CLOSE c_no_fisico_req;
 --
 IF PV_MONEDA = 'P' THEN
  IF lv_noFisico_req = 'S' THEN
    vNo_dep := PV_FISICO;
    vSerie  := 0;
  ELSE
    vNo_dep := NULL;
    vSerie  := 0;
  END IF;
  --
  vMonto     := PN_MONTO;
  vMonto     := moneda.redondeo(vMonto,'P');
  -- Preguntar si esta bien asignar monto_dol y monto_dc
  vMonto_dol := vMonto;
  vMonto_dc  := vMonto;
  --
 END IF;
 --
/* OPEN C_MES_PROCESO(PV_CIA,PV_CENTRO);
 FETCH C_MES_PROCESO INTO ln_anio_proceso,ln_mes_proceso;
 vExiste := C_MES_PROCESO%notfound;
 CLOSE C_MES_PROCESO;
 --
 IF vExiste THEN
  lv_error := 'No se encontro el mes y el anio de Proceso';
  RAISE le_error;
 END IF;*/

 Ln_anio_proceso := to_number(to_char(Pd_fecha_dep,'YYYY'));
 Ln_mes_proceso := to_number(to_char(Pd_fecha_dep,'MM'));

 --Si la fecha de la cuenta bancaria es mayor a la fecha en proceso del documento
 --Si la fecha de la cuenta bancaria es mayor a la fecha en proceso del modulo de Cuentas por Cobrar (esto no va)
 --pone el indicador de Otros meses en "S" de otra manera pone "N"
 IF to_date('01'||to_char(vMes,'00')||to_char(vAno,'9999'),'ddmmyyyy') > to_date('01'||to_char(ln_mes_proceso,'00')||to_char(ln_anio_proceso,'9999'),'ddmmyyyy') THEN
     vOtros_meses := 'S';
 ELSE
     vOtros_meses := 'N';
 END IF;
 --
 If Pv_docu_cobro is not null Then
  Lv_Referencia :=  ' TRANS. COBRO: '||PV_DOCU_COBRO;
 else
  Lv_Referencia := Null;
 end if;

 --- Desde  el proceso ccactuliza siempre se debera enviar una division ANR 22/10/2009

 Open C_Division (PV_CIA,PV_CENTRO);
 Fetch C_Division into Lv_desc_division, Lv_cc_division;
 If C_Division%notfound then
  Close C_Division;
    Lv_error := 'No se encontro la division para el centro: '||pv_centro||' division: '||pv_division;
    Raise le_error;
 else
  Close C_Division;
 end if;

 --
 IF PV_FORMAPAGO IS NOT NULL AND PV_USUARIO IS NOT NULL THEN
  lv_glosa := SUBSTR('Dep del Dia '||PD_FECHA_DEP||' por '||PV_FORMAPAGO||' de '||Lv_desc_division||' generado por '||PV_USUARIO,1,100);
 ELSE
  lv_glosa := 'DEP. GENERADO DESDE CXC.'||Lv_Referencia;
 END IF;
 --

 Begin
   Insert into arckmm (no_cia,       no_cta,          procedencia,
                       tipo_doc,     no_docu,         fecha,
                       fecha_doc,    comentario,      moneda_cta,
                       monto,        estado,          conciliado,
                       mes,          ano,             ind_con,
                       ind_borrado,  ind_otromov,     tipo_cambio,
                       t_camb_c_v,   ind_otros_meses, no_fisico,
                       serie_fisico, origen,          usuario_creacion)
               VALUES (PV_CIA,       PV_NOCTA_BCO,    'C',
                       'DP',         ln_noDocu,      -- trunc(PD_FECHA), --- No debe ir fecha y hora ANR 23/07/2009
                       PD_FECHA_DEP, ---  va la misma fecha de registro del documento
                       PD_FECHA_DEP, lv_glosa,      PV_MONEDA,
                       vMonto,       'P',             'N',
                       ln_mes_proceso,ln_anio_proceso, 'P',
                       'N',           'S',             1,
                       'V',           vOtros_meses,    vNo_dep,
                       vSerie,        'CC',            upper(user));
 Exception
  When Others then
    Lv_error := substr('Error al crear registro de Movimiento mensual Historico '||SQLERRM,1,190);
    Raise le_error;
 End;

 -- Incluye la distribucion contable del deposito.
 -- En el caso de que sea una sola division se genera un solo registro,
 -- caso contrario debe enviar generarse varias lineas por cada division del cliente ANR 22/10/2009

   Begin
     Insert into arckml (no_cia, procedencia, tipo_doc,
                         no_docu, cod_cont,tipo_mov,
                         monto, monto_dol,  monto_dc,
                         moneda, tipo_cambio,
                         centro_costo, modificable, glosa)
                 Values (PV_CIA,  'C', 'DP',
                         ln_noDocu, PV_CTACREDITO, 'C',
                         vMonto, vMonto_dol, vMonto_dc,
                         PV_MONEDA,1,
                         Lv_cc_division,'N', lv_glosa);
   Exception
    When Others Then
      LV_ERROR := SUBSTR('Error al crear registro de la distribucion Contable '||SQLERRM,1,190);
      Raise le_error;
   End;


 --  Asiento contable para la cuenta de bancos

 BEGIN
   INSERT INTO arckml (no_cia, procedencia, tipo_doc,
                       no_docu, cod_cont,tipo_mov,
                       monto, monto_dol,  monto_dc,
                       moneda, tipo_cambio,
                       centro_costo, modificable, glosa)
              VALUES  (PV_CIA,  'C', 'DP',
                       ln_noDocu, vCuenta_debito, 'D',
                       vMonto, vMonto_dol, vMonto_dc,
                       PV_MONEDA,1,
                       vcc,'N',lv_glosa);
 EXCEPTION
  WHEN Others THEN
    LV_ERROR := SUBSTR('Error al crear registro de la distribucion Contable '||SQLERRM,1,190);
    RAISE le_error;
 END;

 -- Llamar al ckactualiza;
 ckactualiza(pno_cia       => PV_CIA,
             ptipo_docu    => 'DP',
             pno_secuencia => ln_noDocu,
             pno_cta       => PV_NOCTA_BCO,
             msg_error_p   => LV_ERROR);

 IF LV_ERROR IS NOT NULL THEN
   raise le_error;
 ELSE
  PV_ERROR := null;
  PN_NO_DOCU := ln_noDocu;
 END IF;
 --
EXCEPTION
 WHEN le_error THEN
  PV_ERROR := LV_ERROR;
 WHEN OTHERS THEN
  PV_ERROR := SUBSTR('Error al generar deposito: '||SQLERRM,1,100);
END GENERA_DEPOSITO_CC;