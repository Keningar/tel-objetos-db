create or replace procedure            inserta_arfadc (
  no_cia_p       IN    VARCHAR2,
  centrod_p      IN    VARCHAR2,
  ano_p          IN    NUMBER,
  mes_p          IN    NUMBER,
  tipo_p         IN    VARCHAR2,
  peri_p         IN    VARCHAR2,
  ruta_p         IN    VARCHAR2,
  factu_p        IN    VARCHAR2,
  moneda_monto_p IN    VARCHAR2,
  codigo_p       IN    VARCHAR2,
  monto_p        IN    NUMBER,
  camb_p         IN    NUMBER,
  cc1_p          IN    VARCHAR2,
  tcta_p         IN    VARCHAR2,
  tipo_mov_p     IN    VARCHAR2,    -- tipo de mov. contable (debito / credito)
  tercero_p      IN    VARCHAR2     -- Codigo de tercero del cliente
) IS


  /***
  *  En la moneda del detalle contable se registra la moneda del monto
  *
  */
  -- --
  -- Centro de Costos
  vcc_1 	ArInCC.centro_costo%TYPE;
  --
  vMonto_nomi  arfadc.monto%TYPE;
  vMonto_dol   arfadc.monto_dol%TYPE;

BEGIN

  IF cuenta_contable.acepta_cc(no_cia_p, codigo_p) THEN
     vcc_1 := cc1_p;
  ELSE
     vcc_1 := centro_costo.rellenad(no_cia_p, '0');
  END IF;
  --
  IF moneda_monto_p = 'P' THEN
    vMonto_nomi := monto_p;
    vMonto_dol  := Moneda.Redondeo(monto_p / camb_p, 'D');
  ELSE
    vMonto_nomi := Moneda.Redondeo(monto_p * camb_p, 'P');
    vMonto_dol  := monto_p;
  END IF;

  UPDATE arfadc
     SET monto     = nvl(monto, 0)     + vMonto_nomi,
         monto_dol = nvl(monto_dol, 0) + vMonto_dol
   WHERE no_cia                   = no_cia_p
     AND no_docu                  = factu_p
     AND codigo                   = codigo_p
     AND centro_costo             = vcc_1
     AND ((codigo_tercero IS NULL AND tercero_p IS NULL) OR
          (codigo_tercero = tercero_p))
     AND tipo_mov                 = tipo_mov_p
     AND moneda                   = moneda_monto_p;


  IF (sql%rowcount = 0) THEN
    INSERT INTO  arfadc( no_cia,       centrod,       ano,        mes,
                         tipo_doc,     periodo,       ruta,       no_docu,
                         codigo,       tipo_mov,      monto,      ind_gen,
                         tipo_cta,     tipo_cambio,   monto_dol,  moneda,
                         centro_costo, codigo_tercero)
                 VALUES( no_cia_p,     centrod_p,     ano_p,      mes_p,
                         tipo_p,       peri_p,        ruta_p,     factu_p,
                         codigo_p,     tipo_mov_p,    vMonto_nomi,'P',
                         tcta_p,       camb_p,        vMonto_dol, moneda_monto_p,
                         vcc_1,        tercero_p);
  END IF;
  --
END;