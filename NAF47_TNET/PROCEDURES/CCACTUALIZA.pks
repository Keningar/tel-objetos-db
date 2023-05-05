create or replace PROCEDURE            CCACTUALIZA( Pno_Cia   IN Arccmd.No_Cia%TYPE,
                                                    Ptipo_Doc IN Arccmd.Tipo_Doc%TYPE,
                                                    Pno_Docu  IN Arccmd.No_Docu%TYPE,
                                                    Perror    IN OUT VARCHAR2) IS
  -- PL/SQL Specification
  /*
  * Actualiza un documento por cobrar, aumentando o disminuyendo
  * la cuenta por cobrar del cliente al que pertenece el documento.
  *
  * Si el a?o y mes del documento es superior al periodo en proceso
  * del modulo de CxC, entonces lo deja en estado pendiente.
  *
  *
  */

  /*
  * Modificado por banton@telconet.ec
  * version 1.1
  * se agrega validacion para ajustes de inventario solo para Notas de credito NC
  * Fecha : 10/09/2020 
  */

  /****************************

  1) Cuando es un documento de debito con dividendos, se deben bajar los dividendos, para eso utiliza el proceso CCACTUALIZA_DIVIDENDOS
  2) Si la forma de pago es un cheque postfechado se debe crear un nuevo documento en arccmd.
  3) Si la forma de pago es deposito se genera el deposito en el modulo de bancos.

  ******************************/
  --
  CURSOR c_Periodo_Cxc(Pcia Arincd.No_Cia%TYPE, Pcentro Arincd.Centro%TYPE) IS
    SELECT Ano_Proce_Cxc, Mes_Proce_Cxc, Semana_Proce_Cxc, Dia_Proceso_Cxc
      FROM Arincd
     WHERE No_Cia = Pcia
       AND Centro = Pcentro;
  --
  CURSOR c_Documento IS
    SELECT m.Centro,
           m.Tipo_Doc,
           m.No_Docu,
           m.Grupo,
           m.No_Cliente,
           m.Saldo,
           m.Total_Ref,
           m.Fecha,
           m.m_Original,
           m.No_Docu_Refe,
           m.Ano Ano_Doc,
           m.Mes Mes_Doc,
           Td.Formulario_Ctrl,
           m.Tot_Imp,
           m.Rowid Rowid_Md,
           m.Tot_Ret,
           m.Moneda,
           m.Tipo_Cambio,
           m.Serie_Fisico_Refe,
           m.Sub_Cliente,
           m.No_Agente,
           m.Ruta,
           m.Ind_Cobro,
           Nvl(Td.Cks_Dev, 'N') Cks_Dev,
           m.Fecha_Vence,
           m.Cobrador,
           Td.Tipo_Mov,
           m.Origen,
           Td.Formulario,
           m.Serie_Fisico,
           m.No_Fisico,
           m.Fecha_Documento,
           Td.Codigo_Tipo_Comprobante,
           Td.Factura
      FROM Arccmd m, Arcctd Td
     WHERE m.No_Cia = Pno_Cia
       AND m.No_Docu = Pno_Docu
       AND m.Estado = 'P'
       AND m.No_Cia = Td.No_Cia
       AND m.Tipo_Doc = Td.Tipo;
  --
  CURSOR c_Referencias(Pno_Cia VARCHAR2, Pno_Docu VARCHAR2) IS
    SELECT r.Tipo_Refe,
           r.No_Refe,
           r.Monto,
           r.Ano,
           r.Mes,
           r.No_Docu,
           r.Tipo_Doc
      FROM Arccrd r
     WHERE r.No_Cia = Pno_Cia
       AND r.No_Docu = Pno_Docu;

  --- Verifica los dividendos aplicados manualmente en la pantalla de ingreso de cobros ANR 04/11/2009
  CURSOR c_Div_Manual(Lv_No_Refe VARCHAR2) IS
    SELECT Nvl(SUM(Nvl(Monto_Refe, 0)), 0) Monto_Refe
      FROM Arccrd_Dividendos_Manual
     WHERE No_Cia = Pno_Cia
       AND No_Docu = Pno_Docu
       AND No_Refe = Lv_No_Refe;

  --- Verifica las papeletas de deposito  ANR 22/07/2009
  CURSOR c_Papeletas_Deposito IS
    SELECT b.Ref_Fecha,
           b.Valor,
           b.Cod_Bco_Cia,
           b.Campo_Deposito,
           c.Cuenta_Contable,
           b.Autorizacion,
           b.Linea,
           b.Id_Forma_Pago
      FROM Arccfpagos b, Arccforma_Pago c
     WHERE b.No_Cia = Pno_Cia
       AND b.No_Docu = Pno_Docu
       AND (Nvl(c.Papeleta, 'N') = 'S' OR Nvl(c.Transferencia, 'N') = 'S') --- Se anaden transferencias para que se generen al modulo de bancos ANR 12/02/2010
       AND Nvl(c.Ind_Transito, 'N') = 'N' --- Agregado ANR 09/02/2010
       AND b.No_Cia = c.No_Cia
       AND b.Id_Forma_Pago = c.Forma_Pago;
  --- Depositos en transito no debe generar transaccion en bancos ANR 09/02/2010

  --- Verifica pagos con cheques postfechados  ANR 22/07/2009
  CURSOR c_Cheques_Postfechados IS
    SELECT b.Ref_Cheque, b.Valor, b.Ref_Fecha, b.Linea, b.Id_Forma_Pago
      FROM Arccfpagos b, Arccforma_Pago c
     WHERE b.No_Cia = Pno_Cia
       AND b.No_Docu = Pno_Docu
       AND Nvl(c.Ind_Ck_Postf, 'N') = 'S'
       AND b.No_Cia = c.No_Cia
       AND b.Id_Forma_Pago = c.Forma_Pago;

  --
  -- Datos del tipo de documento
  CURSOR c_Tipo_Doc(Pcia VARCHAR2, Ptipo_Doc VARCHAR2) IS
    SELECT Td.Tipo_Mov,
           Td.Cks_Dev,
           Nvl(Td.Afecta_Libro, 'X'),
           Nvl(Td.Factura, 'N')
      FROM Arcctd Td
     WHERE Td.No_Cia = Pcia
       AND Td.Tipo = Ptipo_Doc;

  --Recupera el saldo actual del documento a actualizar IRQS 2003-02-14
  CURSOR c_Saldo_Doc(Cv_Nodocu VARCHAR2) IS
    SELECT Saldo
      FROM Arccmd
     WHERE No_Cia = Pno_Cia
       AND No_Docu = Cv_Nodocu;

  --- Recupera el documento para cheques postfechados ANR 23/07/2009
  CURSOR c_Tipo_Cheque_Postfechado IS
    SELECT Tipo, Cod_Diario
      FROM Arcctd
     WHERE No_Cia = Pno_Cia
       AND Tipo_Mov = 'D'
       AND Nvl(Tipo_Cheque, 'N') = 'S';

  CURSOR c_Dividendos_Cxc IS
    SELECT No_Cia,
           Centrod,
           Tipo_Doc,
           No_Factu,
           Dividendo,
           Valor,
           Fecha_Vence
      FROM Arfadividendos
     WHERE No_Cia = Pno_Cia
       AND No_Factu = Pno_Docu;

  --- Se agrega validaciones para la retencion ANR 19/10/2009

  CURSOR c_Forma_Pago_Retencion IS
    SELECT Nvl(SUM(b.Valor), 0) Valor
      FROM Arccforma_Pago a, Arccfpagos b
     WHERE a.No_Cia = Pno_Cia
       AND b.No_Docu = Pno_Docu
       AND Nvl(a.Retencion, 'N') = 'S'
       AND a.No_Cia = b.No_Cia
       AND a.Forma_Pago = b.Id_Forma_Pago;

  CURSOR c_Total_Retenciones IS
    SELECT Nvl(SUM(Monto), 0) Monto
      FROM Arccti
     WHERE No_Cia = Pno_Cia
       AND Tipo_Doc = Ptipo_Doc
       AND No_Docu = Pno_Docu
       AND Nvl(Ind_Imp_Ret, 'X') = 'R';

  CURSOR c_Total_Impuesto IS
    SELECT Nvl(SUM(Monto), 0) Monto
      FROM Arccti
     WHERE No_Cia = Pno_Cia
       AND Tipo_Doc = Ptipo_Doc
       AND No_Docu = Pno_Docu
       AND Nvl(Ind_Imp_Ret, 'X') = 'I';

  CURSOR c_Div_Comercial(Lv_Grupo      VARCHAR2,
                         Lv_Cliente    VARCHAR2,
                         Lv_Subcliente VARCHAR2) IS
    SELECT Div_Comercial
      FROM Arcclocales_Clientes
     WHERE No_Cia = Pno_Cia
       AND Grupo = Lv_Grupo
       AND No_Cliente = Lv_Cliente
       AND No_Sub_Cliente = Lv_Subcliente;

  --- Se agrega validacion de cuenta contable que cuadre debe y haber y que se genere el asiento contable ANR 10/12/2009

  CURSOR c_Existe_Conta IS
    SELECT 'X'
      FROM Arccdc
     WHERE No_Cia = Pno_Cia
       AND No_Docu = Pno_Docu;

  CURSOR c_Valida_Conta IS
    SELECT Nvl(SUM(Decode(Tipo, 'C', Monto)), 0) -
           Nvl(SUM(Decode(Tipo, 'D', Monto)), 0) Dif
      FROM Arccdc
     WHERE No_Cia = Pno_Cia
       AND No_Docu = Pno_Docu;
  --add mlopez 28/05/2010
  --para verificar si el documento es una devolucion
  CURSOR c_Es_Dev(Cv_Tipo VARCHAR2) IS
    SELECT x.Ind_Fac_Dev
      FROM Arfact x
     WHERE x.No_Cia = Pno_Cia
       AND x.Tipo = Cv_Tipo;

  Lc_Es_Dev c_Es_Dev%ROWTYPE;

  CURSOR c_Ctas_Default(Cv_Grupo VARCHAR2, Cv_Tipo VARCHAR2) IS
    SELECT g.No_Cia,
           g.Grupo,
           t.Tipo Tipo_Doc,
           g.Cta_Cliente,
           g.Cta_Dpp,
           t.Cta_Contrapartida,
           g.Cta_Diferencia
      FROM Arccgr g, Arcctd t
     WHERE g.No_Cia = Pno_Cia
       AND g.Grupo = Cv_Grupo
       AND g.No_Cia = t.No_Cia
       AND t.Tipo = Cv_Tipo;

  Lc_Ctas_Default c_Ctas_Default%ROWTYPE;
  --fin add mlopez 28/05/2010
  r                 c_Documento%ROWTYPE;
  Vnumero_Ctrl      Arccmd.Numero_Ctrl%TYPE;
  Ln_Saldo          Arccmd.Saldo%TYPE;
  Ln_Docu           Arckmm.No_Docu%TYPE;
  Vcta_Cliente      Arccdc.Codigo%TYPE;
  Lv_Error          VARCHAR2(500);
  Vfound            BOOLEAN;
  Vtipo_Mov         Arcctd.Tipo_Mov%TYPE;
  Vcks_Dev          Arcctd.Cks_Dev%TYPE;
  Vtot_Ref          NUMBER;
  Vsaldo_Doc        Arccmd.Saldo%TYPE;
  Vano_Proce_Cxc    Arincd.Ano_Proce_Cxc%TYPE;
  Vmes_Proce_Cxc    Arincd.Mes_Proce_Cxc%TYPE;
  Vsemana_Proce_Cxc Arincd.Mes_Proce_Cxc%TYPE;
  Vdia_Proceso_Cxc  Arincd.Dia_Proceso_Cxc%TYPE;
  --
  Vcod_Estado Arccte.Cod_Estado%TYPE;
  Vlibro      Arcctd.Afecta_Libro%TYPE;
  Vfactura    Arcctd.Factura%TYPE;
  Td_Cxc      Arcctd.Tipo%TYPE;
  Vdiario     Arcctd.Cod_Diario%TYPE;
  No_Cxc_p    Arccmd.No_Docu%TYPE;
  Rcta        Arccctd%ROWTYPE;

  Ln_Total_Fpago_Retencion Arccti.Monto%TYPE := 0;
  Ln_Total_Retenciones     Arccti.Monto%TYPE := 0;
  Ln_Total_Impuestos       Arccti.Monto%TYPE := 0;

  Lv_Resultado VARCHAR2(1);

  Lv_Division Arfa_Div_Comercial.Division%TYPE;

  Ln_Monto_Refe Arccrd_Dividendos_Manual.Monto_Refe%TYPE;

  Error_Proceso EXCEPTION;

  Lv_Dummy VARCHAR2(1);
  Ln_Dif   NUMBER;

  Lv_Cc           Arcgceco.Centro%TYPE;
  Lv_Centro_Costo Arcgceco.Centro%TYPE;

  -- PL/SQL Block
BEGIN
  --
  Perror := NULL;
  --
  OPEN c_Documento;
  FETCH c_Documento
    INTO r;
  Vfound := Nvl(c_Documento%FOUND, FALSE);
  CLOSE c_Documento;

  IF NOT Vfound THEN
    Perror := 'No se localiza en CxC, el documento para actualizar (' ||
              Pno_Docu || ')';
    RAISE Error_Proceso;
  END IF;
  --

  --- Para todos los documentos debe validar que se haya generado el asiento contable, a excepcion
  --- de los documentos que vienen de facturacion que la contabilidad se genera desde el mismo
  --- modulo de facturacion ANR 10/12/2009
  --- Para el caso del POS, tambien hay que considerar que la contabilizacion se genera en el POS ANR 27-09-2010

  IF Nvl(r.Factura, 'N') = 'N' AND r.Origen NOT IN ('FA', 'PV') THEN

    OPEN c_Existe_Conta;
    FETCH c_Existe_Conta
      INTO Lv_Dummy;
    IF c_Existe_Conta%NOTFOUND THEN
      CLOSE c_Existe_Conta;
      Perror := 'Es obligatorio el asiento contable, revisar el documento: ' ||
                Pno_Docu;
      RAISE Error_Proceso;
    ELSE
      CLOSE c_Existe_Conta;
    END IF;

    OPEN c_Valida_Conta;
    FETCH c_Valida_Conta
      INTO Ln_Dif;
    IF c_Valida_Conta%NOTFOUND THEN
      CLOSE c_Valida_Conta;
    ELSE
      CLOSE c_Valida_Conta;
    END IF;

    IF Ln_Dif != 0 THEN
      Perror := 'Asiento contble descuadrado con: ' || Ln_Dif ||
                ' , revisar el documento: ' || Pno_Docu;
      RAISE Error_Proceso;
    END IF;

  END IF;

  --- Valida las retenciones registradas ANR 19/10/2009

  OPEN c_Forma_Pago_Retencion;
  FETCH c_Forma_Pago_Retencion
    INTO Ln_Total_Fpago_Retencion;
  CLOSE c_Forma_Pago_Retencion;

  OPEN c_Total_Retenciones;
  FETCH c_Total_Retenciones
    INTO Ln_Total_Retenciones;
  CLOSE c_Total_Retenciones;

  --- Si tiene forma de pago de retencion, quiere decir que debe tener registros en ARCCTI y en ARCCMD (TOT_RET)
  IF Ln_Total_Fpago_Retencion > 0 THEN

    IF Ln_Total_Fpago_Retencion != Ln_Total_Retenciones THEN
      Perror := 'El total de forma de pago de retenciones: ' ||
                Ln_Total_Fpago_Retencion ||
                ' debe ser igual al total de retenciones ingresadas por factura: ' ||
                Ln_Total_Retenciones || ' para el documento: ' || Pno_Docu;
      RAISE Error_Proceso;
    END IF;

    IF Ln_Total_Retenciones != r.Tot_Ret THEN
      Perror := 'El total de retenciones registradas por factura: ' ||
                Ln_Total_Retenciones ||
                ' debe ser igual al total de retencion: ' || r.Tot_Ret ||
                ' registrada en el documento: ' || Pno_Docu;
      RAISE Error_Proceso;
    END IF;

  END IF;

  OPEN c_Total_Impuesto;
  FETCH c_Total_Impuesto
    INTO Ln_Total_Impuestos;
  CLOSE c_Total_Impuesto;

  --- Valido los impuestos registrados que sean los correctos ANR 19/10/2009

  IF Ln_Total_Impuestos > 0 AND r.Tot_Imp = 0 THEN
    Perror := 'El documento: ' || Pno_Docu ||
              ' tiene registrado impuestos por: ' || Ln_Total_Impuestos ||
              ' debe tener el mismo valor de impuestos: ' || r.Tot_Imp ||
              ' en el documento.';
    RAISE Error_Proceso;
  ELSIF Ln_Total_Impuestos = 0 AND r.Tot_Imp > 0 THEN
    Perror := 'El documento: ' || Pno_Docu ||
              ' no tiene registrado el detalle de impuestos, verifique por favor';
    RAISE Error_Proceso;
  END IF;

  OPEN c_Periodo_Cxc(Pno_Cia, r.Centro);
  FETCH c_Periodo_Cxc
    INTO Vano_Proce_Cxc,
         Vmes_Proce_Cxc,
         Vsemana_Proce_Cxc,
         Vdia_Proceso_Cxc;
  CLOSE c_Periodo_Cxc;
  --
  IF Vano_Proce_Cxc IS NULL OR Vmes_Proce_Cxc IS NULL THEN
    Perror := 'Falta periodo en proceso de CxC para el centro: ' ||
              r.Centro;
    RAISE Error_Proceso;
  END IF;
  -- --
  -- Actualiza el documento si su periodo es menor o igual al de proceso
  --
  IF (Nvl(r.Ano_Doc, Vano_Proce_Cxc) <= Vano_Proce_Cxc AND
     Nvl(r.Mes_Doc, Vmes_Proce_Cxc) <= Vmes_Proce_Cxc) THEN
    --
    -- busca el tipo de movimiento del documento (D o C)
    Vtipo_Mov := NULL;
    Vcks_Dev  := NULL;
    OPEN c_Tipo_Doc(Pno_Cia, r.Tipo_Doc);
    FETCH c_Tipo_Doc
      INTO Vtipo_Mov, Vcks_Dev, Vlibro, Vfactura;
    CLOSE c_Tipo_Doc;
    --
    IF Vtipo_Mov IS NULL THEN
      Perror := 'TIPO DE MOVIMIENTO DEL DOCUMENTO: ' || r.Tipo_Doc ||
                ', ES INCORRECTO ';
      RAISE Error_Proceso;
    END IF;
    --
    IF Vlibro = 'V' AND Vfactura = 'N' THEN
      -- registra la factura en el libro de ventas, si no es factura ya que facturacion se encarga de ello
      Cclibro_Ventas(Pno_Cia, Ptipo_Doc, Pno_Docu, Perror);
    END IF;

    --
    Vsaldo_Doc := NULL;
    Vtot_Ref   := 0;

    IF Vtipo_Mov = 'C' THEN
      -- Aumenta los creditos del clientes
      UPDATE Arccmc
         SET Creditos   = Nvl(Creditos, 0) + Nvl(r.m_Original, 0),
             f_Ult_Pago = Greatest(r.Fecha, Nvl(f_Ult_Pago, r.Fecha))
       WHERE No_Cia = Pno_Cia
         AND Grupo = r.Grupo
         AND No_Cliente = r.No_Cliente;
    ELSIF Vtipo_Mov = 'D' THEN
      -- Aumenta los debitos del cliente
      IF r.No_Docu_Refe IS NOT NULL THEN
        -- es un documento de pago (debito cancelando otro debito)
        Vtot_Ref := r.Total_Ref;
      ELSE
        Vtot_Ref := 0;
      END IF;
      UPDATE Arccmc
         SET Creditos  = Nvl(Creditos, 0) + Nvl(Vtot_Ref, 0),
             Debitos   = Nvl(Debitos, 0) + Nvl(r.m_Original, 0),
             Fecha_Max = Decode(Sign(Nvl(Saldo_Max, 0) -
                                     (Nvl(Saldo_Ante, 0) + Nvl(Debitos, 0) -
                                      Nvl(Creditos, 0) +
                                      Nvl(r.m_Original, 0))),
                                -1,
                                r.Fecha,
                                Fecha_Max),
             Saldo_Max = Greatest(Nvl(Saldo_Max, 0),
                                  Nvl(Saldo_Ante, 0) + Nvl(Debitos, 0) -
                                  Nvl(Creditos, 0) + Nvl(r.m_Original, 0)),
             Cks_Dev   = Decode(Vcks_Dev, 'S', Nvl(Cks_Dev, 0) + 1, Cks_Dev),
             f_Ult_Com = Greatest(r.Fecha, Nvl(f_Ult_Com, r.Fecha))
       WHERE No_Cia = Pno_Cia
         AND Grupo = r.Grupo
         AND No_Cliente = r.No_Cliente;
    END IF;
    --
    -- procesa referencias
    Vtot_Ref := 0;
    FOR j IN c_Referencias(Pno_Cia, r.No_Docu) LOOP

      OPEN c_Saldo_Doc(j.No_Refe);
      FETCH c_Saldo_Doc
        INTO Ln_Saldo;
      CLOSE c_Saldo_Doc;
      --Verifica el saldo antes de actualizar para no dejarlo en negativo
      IF Round(Ln_Saldo, 2) < j.Monto THEN
        Perror := 'ERROR: El saldo actual del documento :' || j.No_Refe ||
                  ', (' || Ln_Saldo || ' <> ' || j.Monto ||
                  ') es menor que la referencia a aplicar y no puede quedar negativo ';
        RAISE Error_Proceso;
      END IF;

      --- Solo para documentos de ind. cobro se valida esta parte de registros manuales de dividendos ANR 04/11/2009

      IF Nvl(r.Ind_Cobro, 'N') = 'S' THEN

        --- verifica si concuerda las referencias con el total de dividendos referenciados ANR 04/11/2009
        OPEN c_Div_Manual(j.No_Refe);
        FETCH c_Div_Manual
          INTO Ln_Monto_Refe;
        IF c_Div_Manual%NOTFOUND THEN
          CLOSE c_Div_Manual;
          Ln_Monto_Refe := 0;
        ELSE
          CLOSE c_Div_Manual;
        END IF;

        IF Ln_Monto_Refe != j.Monto THEN
          Perror := 'Para el documento: ' || j.Tipo_Refe || ' ' ||
                    j.No_Refe || ' el total referenciado por dividendos: ' ||
                    Ln_Monto_Refe ||
                    ' debe ser igual al valor referenciado por documento:  ' ||
                    j.Monto;
          RAISE Error_Proceso;
        END IF;

      END IF;

      -- actualiza saldo del documento referenciado solo si el
      UPDATE Arccmd
         SET Saldo              = Nvl(Saldo, 0) - Nvl(j.Monto, 0),
             Ind_Estado_Vencido = Decode(Nvl(Saldo, 0) - Nvl(j.Monto, 0),
                                         0,
                                         Decode(Ind_Estado_Vencido, 'S', 'X'),
                                         Ind_Estado_Vencido),
             Tstamp             = SYSDATE
       WHERE No_Cia = Pno_Cia
         AND No_Docu = j.No_Refe;
      --
      Vtot_Ref := Nvl(Vtot_Ref, 0) + Nvl(j.Monto, 0);

      --- Debe marcar como procesado ya que esto sirve para que estas referencias no sean modificadas
      --- a aplicacion ANR 05/08/2009

      UPDATE Arccrd
         SET Ind_Procesado = 'S',
             Tstamp        = SYSDATE
       WHERE No_Cia = Pno_Cia
         AND Tipo_Doc = j.Tipo_Doc
         AND No_Docu = j.No_Docu
         AND Tipo_Refe = j.Tipo_Refe
         AND No_Refe = j.No_Refe
         AND Ano = j.Ano
         AND Mes = j.Mes;

      --
      -- registra estado final
      Ccregistra_Estado(Pno_Cia, j.No_Refe, j.Tipo_Refe, 'F', Vcod_Estado);
    END LOOP;
    --
    IF Nvl(r.Total_Ref, 0) != Nvl(Vtot_Ref, 0) THEN
      Perror := 'ERROR: El total referencia del documento no iguala al detalle en RD ' ||
                Nvl(r.Total_Ref, 0) || ' tot ' || Vtot_Ref || ' Cliente ' ||
                r.No_Cliente;
      RAISE Error_Proceso;
    END IF;
    -- ---
    -- Calcula el saldo que debe quedar en el documento, que en el caso
    -- de creditos, es negativo si no se aplica todo el monto
    IF Vtipo_Mov = 'C' THEN
      Vsaldo_Doc := - (Nvl(r.m_Original, 0) - Nvl(Vtot_Ref, 0));
    ELSIF Vtipo_Mov = 'D' THEN
      Vsaldo_Doc := Nvl(r.Saldo, 0);
    END IF;
    IF r.Formulario_Ctrl IS NULL THEN
      Vnumero_Ctrl := NULL;
    ELSE
      Vnumero_Ctrl := Consecutivo.Cc(Pno_Cia,
                                     r.Ano_Doc,
                                     r.Mes_Doc,
                                     NULL,
                                     r.Tipo_Doc,
                                     'SECUENCIA');
    END IF;

    ---- Generacion de dividendos ANR 12/08/2009

    IF Vtipo_Mov = 'D' THEN
      --- debo generar un dividendo cuando sean documentos de debito ANR 07/08/2009
      ---- para documentos de anulacion como no tienen fecha de vencimiento se agrega la misma fecha ANR 26/10/2009

      IF Vfactura = 'N' THEN
        ---- para movimientos que son realizados en CxC
        BEGIN
          INSERT INTO Arcc_Dividendos
            (No_Cia,
             Centro,
             Tipo_Doc,
             No_Docu,
             Dividendo,
             Valor,
             Saldo,
             Fecha_Vence,
             Valor_Aplica)
          VALUES
            (Pno_Cia,
             r.Centro,
             Ptipo_Doc,
             Pno_Docu,
             1,
             r.m_Original,
             r.m_Original,
             Nvl(r.Fecha_Vence, r.Fecha),
             0);
        EXCEPTION
          WHEN OTHERS THEN
            Perror := 'Error al crear dividendos que provienen de CxC ' ||
                      Pno_Docu || ' Dividendo: ' || 1 || ' ' || SQLERRM;
            RAISE Error_Proceso;
        END;

      ELSIF Vfactura = 'S' THEN
        --- Genera dividendos a CxC que proviene de facturacion

        FOR j IN c_Dividendos_Cxc LOOP
          BEGIN
            INSERT INTO Arcc_Dividendos
              (No_Cia,
               Centro,
               Tipo_Doc,
               No_Docu,
               Dividendo,
               Valor,
               Saldo,
               Fecha_Vence,
               Valor_Aplica)
            VALUES
              (j.No_Cia,
               j.Centrod,
               Ptipo_Doc,
               Pno_Docu,
               j.Dividendo,
               j.Valor,
               j.Valor,
               j.Fecha_Vence,
               0);
          EXCEPTION
            WHEN OTHERS THEN
              Perror := 'Error al crear dividendos que provienen de FACTURACION ' ||
                        Pno_Docu || ' Dividendo: ' || j.Dividendo || ' ' ||
                        SQLERRM;
              RAISE Error_Proceso;
          END;
        END LOOP;

      END IF;

    END IF;

    --- Actualiza el valor de los dividendos ANR 24/06/2009

    IF Nvl(r.Ind_Cobro, 'N') = 'S' THEN

      --- Este proceso se aumento lo de referencias manuales ANR 04/11/2009

      Ccactualiza_Dividendos_Manual(Pno_Cia,
                                    r.No_Docu,
                                    r.Tipo_Doc,
                                    Vdia_Proceso_Cxc,
                                    Perror);
      IF Perror IS NOT NULL THEN
        RAISE Error_Proceso;
      END IF;

    ELSE

      Ccactualiza_Dividendos(Pno_Cia,
                             r.No_Docu,
                             r.Tipo_Doc,
                             Vdia_Proceso_Cxc,
                             Perror);
      IF Perror IS NOT NULL THEN
        RAISE Error_Proceso;
      END IF;

    END IF;

    --- Cuando sean documentos de cobro ANR 12/08/2009
    --- Debe hacer lo siguiente:
    /*Verificar si el cliente esta suspendido por vencimiento de
    facturas y el cobro se registra en el plazo adicional considerado por la
    compa?ia (7 dias, mantenimiento de compa?ias) el cliente debe ser
    activado. */

    IF Nvl(r.Ind_Cobro, 'N') = 'S' THEN
      Ccacciones_Clientes.Cc_Pabono(Pno_Cia,
                                    r.Centro,
                                    r.No_Cliente,
                                    r.Sub_Cliente,
                                    r.Grupo,
                                    r.No_Docu,
                                    'AFACT', --- Se envia el id del motivo por concepto de abono de facturas
                                    Lv_Resultado, --- Indica si se ejecuto la accion
                                    Perror);

      IF Perror IS NOT NULL THEN
        RAISE Error_Proceso;
      END IF;

    END IF;

    FOR i IN c_Papeletas_Deposito LOOP

      --- Generar el deposito en el modulo de bancos por las papeletas de deposito registradas en el cobro ANR 21/07/2009

      OPEN c_Div_Comercial(r.Grupo, r.No_Cliente, r.Sub_Cliente);
      FETCH c_Div_Comercial
        INTO Lv_Division;
      IF c_Div_Comercial%NOTFOUND THEN
        CLOSE c_Div_Comercial;
        Perror := 'No existe division comercial para cliente: ' || r.Grupo || ' ' ||
                  r.No_Cliente || ' subcliente: ' || r.Sub_Cliente;
        RAISE Error_Proceso;
      ELSE
        CLOSE c_Div_Comercial;

        IF Lv_Division IS NULL THEN
          Perror := 'Es obligatorio que tenga una division comercial configurada por cliente: ' ||
                    r.Grupo || ' ' || r.No_Cliente || ' subcliente: ' ||
                    r.Sub_Cliente || ' para poder procesar el deposito';
          RAISE Error_Proceso;
        END IF;

      END IF;

      Genera_Deposito_Cc(Pno_Cia,
                         r.Centro,
                         i.Campo_Deposito,
                         i.Valor,
                         r.Moneda,
                         i.Cuenta_Contable, --- Las cuentas contables de la forma de pago
                         i.Autorizacion,
                         Vdia_Proceso_Cxc, --- Se envia el dia de proceso de CxC ANR 23/07/2009
                         i.Ref_Fecha,
                         Pno_Docu, --- Numero de transaccion de CxC para agregarlo a la glosa
                         Lv_Division,
                         USER,
                         i.Id_Forma_Pago,
                         Ln_Docu,
                         Lv_Error);

      IF Lv_Error IS NOT NULL THEN
        Perror := Lv_Error;
        RAISE Error_Proceso;
      ELSE
        UPDATE Arccfpagos ---- actualiza el detalle de forma de pago con el numero de transaccion de bancos
           SET No_Docu_Deposito = Ln_Docu
         WHERE No_Cia = Pno_Cia
           AND No_Docu = Pno_Docu
           AND Linea = i.Linea
           AND Id_Forma_Pago = i.Id_Forma_Pago;
      END IF;

    END LOOP;

    --- Generar el cheque a fecha como otra deuda ANR 23/07/2009

    -- Genera el documento en Cuentas x Cobrar con el mismo de no de factura

    FOR i IN c_Cheques_Postfechados LOOP

      OPEN c_Tipo_Cheque_Postfechado;
      FETCH c_Tipo_Cheque_Postfechado
        INTO Td_Cxc, Vdiario;
      IF c_Tipo_Cheque_Postfechado%NOTFOUND THEN
        CLOSE c_Tipo_Cheque_Postfechado;
        Perror := 'No existe documento configurado en CxC para los cheques postfechados';
        RAISE Error_Proceso;
      ELSE
        CLOSE c_Tipo_Cheque_Postfechado;
      END IF;

      No_Cxc_p := Transa_Id.Cc(Pno_Cia);

      IF Nvl(r.Tipo_Cambio, 0) = 0 THEN
        r.Tipo_Cambio := 1;
      END IF;

      BEGIN
        INSERT INTO Arccmd
          (No_Cia,
           Centro,
           Tipo_Doc,
           Periodo,
           Ruta,
           No_Docu,
           Grupo,
           No_Cliente,
           Moneda,
           Fecha,
           Fecha_Vence,
           Fecha_Documento,
           m_Original,
           Descuento,
           Saldo,
           Tipo_Venta,
           Gravado,
           Exento,
           Monto_Bienes,
           Monto_Serv,
           Monto_Exportac,
           No_Agente,
           Estado,
           Tipo_Cambio,
           Total_Ref,
           Total_Db,
           Total_Cr,
           Origen,
           Ano,
           Mes,
           Semana,
           No_Fisico,
           Serie_Fisico,
           Cod_Diario,
           No_Docu_Refe,
           Usuario,
           Sub_Cliente,
           Tstamp,
           Detalle,
           Fecha_Vence_Original,
           Estado_Cheque,
           Cobrador,
           Linea_Forma_Pago,
           Id_Forma_Pago)
        VALUES
          (Pno_Cia,
           r.Centro,
           Td_Cxc,
           Vano_Proce_Cxc,
           r.Ruta,
           No_Cxc_p,
           r.Grupo,
           r.No_Cliente,
           r.Moneda,
           Vdia_Proceso_Cxc,
           i.Ref_Fecha,
           i.Ref_Fecha,
           i.Valor,
           0,
           i.Valor,
           'V',
           0,
           i.Valor,
           0,
           0,
           0,
           r.No_Agente,
           'P',
           r.Tipo_Cambio,
           0,
           i.Valor,
           i.Valor,
           'CC',
           Vano_Proce_Cxc,
           Vmes_Proce_Cxc,
           Vsemana_Proce_Cxc,
           i.Ref_Cheque,
           '0',
           Vdiario,
           Pno_Docu,
           USER,
           r.Sub_Cliente,
           SYSDATE,
           'CHEQUE POSTFECHADO GENERADO EN PROCESO DE COBRO. TRANS. COBRO: ' ||
           Pno_Docu,
           i.Ref_Fecha,
           'D',
           r.Cobrador,
           i.Linea,
           i.Id_Forma_Pago);

      EXCEPTION
        WHEN OTHERS THEN
          Perror := 'Error al crear deuda para cheque postfechado';
          RAISE Error_Proceso;
      END;

      IF NOT
          Cclib.Trae_Cuentas_Conta(Pno_Cia, r.Grupo, Td_Cxc, r.Moneda, Rcta) THEN
        Perror := 'No existe la cuenta de clientes para el documento: ' ||
                  Td_Cxc || ' moneda ' || r.Moneda;
        RAISE Error_Proceso;
      END IF;

      Vcta_Cliente := Rcta.Cta_Cliente;

      IF Cuenta_Contable.Acepta_Cc(Pno_Cia, Vcta_Cliente) THEN
        Lv_Cc := Cc_Ccosto_Subcliente(Pno_Cia,
                                      r.Grupo,
                                      r.No_Cliente,
                                      r.Sub_Cliente);
        IF Lv_Cc IS NULL THEN
          Perror := 'El cliente: ' || r.Grupo || ' ' || r.No_Cliente ||
                    ' subcliente: ' || r.Sub_Cliente ||
                    ' no tiene configurado centro de costos';
          RAISE Error_Proceso;
        ELSE
          Lv_Centro_Costo := Lv_Cc;
        END IF;
      ELSE
        Lv_Centro_Costo := Centro_Costo.Rellenad(Pno_Cia, '0');
      END IF;

      --- El asiento contable del cheque postfechado es cliente contra cliente
      --- ANR 24/07/2009
      --- Crea la contabilizacion del documento cheque postfechado
      BEGIN
        INSERT INTO Arccdc
          (No_Cia,
           Centro,
           Tipo_Doc,
           Periodo,
           Ruta,
           No_Docu,
           Grupo,
           No_Cliente,
           Codigo,
           Tipo,
           Monto,
           Monto_Dol,
           Tipo_Cambio,
           Moneda,
           Ind_Con,
           Centro_Costo,
           Modificable,
           Monto_Dc,
           Glosa)
        VALUES
          (Pno_Cia,
           r.Centro,
           Td_Cxc,
           Vano_Proce_Cxc,
           r.Ruta,
           No_Cxc_p,
           r.Grupo,
           r.No_Cliente,
           Vcta_Cliente,
           'D',
           i.Valor,
           i.Valor / r.Tipo_Cambio,
           r.Tipo_Cambio,
           r.Moneda,
           'P',
           Lv_Centro_Costo,
           'N',
           i.Valor,
           r.No_Cliente || ' - ' || Td_Cxc || ' - ' || i.Ref_Cheque ||
           ' TRANS. COBRO: ' || Pno_Docu);

      EXCEPTION
        WHEN OTHERS THEN
          Perror := 'Error al crear asiento contable del cliente para el cheque postfechado';
          RAISE Error_Proceso;
      END;

      --- Crea la contabilizacion del documento cheque postfechado
      BEGIN
        INSERT INTO Arccdc
          (No_Cia,
           Centro,
           Tipo_Doc,
           Periodo,
           Ruta,
           No_Docu,
           Grupo,
           No_Cliente,
           Codigo,
           Tipo,
           Monto,
           Monto_Dol,
           Tipo_Cambio,
           Moneda,
           Ind_Con,
           Centro_Costo,
           Modificable,
           Monto_Dc,
           Glosa)
        VALUES
          (Pno_Cia,
           r.Centro,
           Td_Cxc,
           Vano_Proce_Cxc,
           r.Ruta,
           No_Cxc_p,
           r.Grupo,
           r.No_Cliente,
           Vcta_Cliente, ---i.cuenta_contable,
           'C',
           i.Valor,
           i.Valor / r.Tipo_Cambio,
           r.Tipo_Cambio,
           r.Moneda,
           'P',
           Lv_Centro_Costo,
           'N',
           i.Valor,
           r.No_Cliente || ' - ' || Td_Cxc || ' - ' || i.Ref_Cheque ||
           ' TRANS. COBRO: ' || Pno_Docu);

      EXCEPTION
        WHEN OTHERS THEN
          Perror := 'Error al crear asiento contable para el cheque postfechado';
          RAISE Error_Proceso;
      END;

      Ccactualiza(Pno_Cia, Td_Cxc, No_Cxc_p, Lv_Error);

      IF Lv_Error IS NOT NULL THEN
        Perror := Lv_Error;
        RAISE Error_Proceso;
      END IF;

    END LOOP;

    -- Coloca como actualizado  el documento
    UPDATE Arccmd
       SET Saldo                = Nvl(Vsaldo_Doc, Saldo),
           Estado               = 'D',
           Fecha_Vence_Original = Fecha_Vence,
           Numero_Ctrl          = Vnumero_Ctrl,
           Tstamp               = SYSDATE
     WHERE No_Cia = Pno_Cia
       AND No_Docu = Pno_Docu;

    -- --
    -- Determina si el tipo de documento posee un Estado inicial
    Vcod_Estado := NULL;
    Ccregistra_Estado(Pno_Cia, r.No_Docu, r.Tipo_Doc, 'I', Vcod_Estado);

    IF Vsaldo_Doc = 0 THEN
      Ccregistra_Estado(Pno_Cia, r.No_Docu, r.Tipo_Doc, 'F', Vcod_Estado);
    END IF;
    -- --
    --  Traslada los impuestos al modulo de contabilidad para emision de libro de impuestos

    Perror := NULL;
    Cctraslada_Impuestos(Pno_Cia, Pno_Docu, Perror);
    IF Perror IS NOT NULL THEN
      RAISE Error_Proceso;
    END IF;
    --
    --add mlopez 28/05/2010
    --cuando queda pendiente un saldo por aplicar de la devolucion
    --se crea asiento por la diferencia pendiente
    OPEN c_Es_Dev(r.Tipo_Doc);
    FETCH c_Es_Dev
      INTO Lc_Es_Dev;
    CLOSE c_Es_Dev;

    IF Nvl(Vsaldo_Doc, 0) < 0 AND Nvl(r.Factura, 'N') = 'S' AND
       r.Tipo_Mov = 'C' AND Nvl(Lc_Es_Dev.Ind_Fac_Dev, '') = 'D' THEN
      --creo asientos
      IF NOT Cclib.Trae_Cuentas_Conta(Pno_Cia,
                                      r.Grupo,
                                      r.Tipo_Doc,
                                      r.Moneda,
                                      Rcta) THEN
        Perror := 'No existe la cuenta de clientes para el documento: ' ||
                  r.Tipo_Doc || ' moneda ' || r.Moneda;
        RAISE Error_Proceso;
      END IF;

      Vcta_Cliente := Rcta.Cta_Cliente;

      IF Cuenta_Contable.Acepta_Cc(Pno_Cia, Vcta_Cliente) THEN
        Lv_Cc := Cc_Ccosto_Subcliente(Pno_Cia,
                                      r.Grupo,
                                      r.No_Cliente,
                                      r.Sub_Cliente);

        IF Lv_Cc IS NULL THEN
          Perror := 'El cliente: ' || r.Grupo || ' ' || r.No_Cliente ||
                    ' subcliente: ' || r.Sub_Cliente ||
                    ' no tiene configurado centro de costos';
          RAISE Error_Proceso;
        ELSE
          Lv_Centro_Costo := Lpad(r.Centro, 3, '0') || Substr(Lv_Cc, 4, 6);
        END IF;
      ELSE
        Lv_Centro_Costo := Centro_Costo.Rellenad(Pno_Cia, '0');
      END IF;

      OPEN c_Ctas_Default(r.Grupo, r.Tipo_Doc);
      FETCH c_Ctas_Default
        INTO Lc_Ctas_Default;
      CLOSE c_Ctas_Default;

      BEGIN
        INSERT INTO Arccdc
          (No_Cia,
           Centro,
           Tipo_Doc,
           Periodo,
           Ruta,
           No_Docu,
           Grupo,
           No_Cliente,
           Codigo,
           Tipo,
           Monto,
           Monto_Dol,
           Tipo_Cambio,
           Moneda,
           Ind_Con,
           Centro_Costo,
           Modificable,
           Monto_Dc,
           Glosa)
        VALUES
          (Pno_Cia,
           r.Centro,
           r.Tipo_Doc,
           Vano_Proce_Cxc,
           r.Ruta,
           r.No_Docu,
           r.Grupo,
           r.No_Cliente,
           Vcta_Cliente,
           'D',
           Abs(Nvl(Vsaldo_Doc, 0)),
           Abs(Nvl(Vsaldo_Doc, 0)) / r.Tipo_Cambio,
           r.Tipo_Cambio,
           r.Moneda,
           'P',
           Lv_Centro_Costo,
           'N',
           Abs(Nvl(Vsaldo_Doc, 0)),
           r.No_Cliente || ' - ' || r.Tipo_Doc || ': ' || r.No_Docu ||
           ' no aplicado a: ' || Nvl(r.No_Docu_Refe, r.Serie_Fisico_Refe));
      EXCEPTION
        WHEN OTHERS THEN
          Perror := 'Error al crear asiento contable del cliente para la devolucion';
          RAISE Error_Proceso;
      END;

      BEGIN
        INSERT INTO Arccdc
          (No_Cia,
           Centro,
           Tipo_Doc,
           Periodo,
           Ruta,
           No_Docu,
           Grupo,
           No_Cliente,
           Codigo,
           Tipo,
           Monto,
           Monto_Dol,
           Tipo_Cambio,
           Moneda,
           Ind_Con,
           Centro_Costo,
           Modificable,
           Monto_Dc,
           Glosa)
        VALUES
          (Pno_Cia,
           r.Centro,
           r.Tipo_Doc,
           Vano_Proce_Cxc,
           r.Ruta,
           r.No_Docu,
           r.Grupo,
           r.No_Cliente,
           Lc_Ctas_Default.Cta_Diferencia,
           'C',
           Abs(Nvl(Vsaldo_Doc, 0)),
           Abs(Nvl(Vsaldo_Doc, 0)) / r.Tipo_Cambio,
           r.Tipo_Cambio,
           r.Moneda,
           'P',
           Lv_Centro_Costo,
           'N',
           Abs(Nvl(Vsaldo_Doc, 0)),
           r.No_Cliente || ' - ' || r.Tipo_Doc || ': ' || r.No_Docu ||
           ' no aplicado a: ' || Nvl(r.No_Docu_Refe, r.Serie_Fisico_Refe));

      EXCEPTION
        WHEN OTHERS THEN
          Perror := 'Error al crear asiento contable del cliente para la devolucion';
          RAISE Error_Proceso;
      END;
    END IF;
    --fin add mlopez 28/05/2010

    -- Actualiza saldo actual del cliente en la moneda dada 03/08/2009
    --

    Ccactualiza_Saldo_Cliente(Pno_Cia,
                              r.Grupo,
                              r.No_Cliente,
                              r.Sub_Cliente,
                              NULL,
                              r.Moneda,
                              NULL,
                              NULL,
                              NULL,
                              NULL,
                              NULL,
                              Perror);

    IF Perror IS NOT NULL THEN
      RAISE Error_Proceso;
    END IF;


    IF  Ptipo_Doc = Cc_Trx_Portal.f_Parametro(Pno_Cia,'TDOC_NCRED') THEN
      --Integración con Inventario. Edgar Muñoz (YOVERI). 10-julio-2020
      cc_trx_portal.cc_p_genera_ingreso_inv(pv_no_cia      => Pno_Cia,
                                            pv_no_docu_nc  => Pno_Docu,
                                            pv_msgerror    => Perror);

      IF Perror IS NOT NULL THEN
         RAISE Error_Proceso;
      END IF;
    END IF;

  END IF;

EXCEPTION
  WHEN Error_Proceso THEN
    Perror := Nvl(Perror, 'CC_ACTUALIZA: Error no descrito');
  WHEN Consecutivo.Error THEN
    Perror := Nvl(Consecutivo.Ultimo_Error,
                  'CC_ACTUALIZA: Generando consecutivo');
  WHEN OTHERS THEN
    Perror := Nvl(SQLERRM, 'Exception en CC_ACTUALIZA');

END Ccactualiza;
