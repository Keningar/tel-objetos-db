create or replace TRIGGER NAF47_TNET.TR_MGCGAL_VALIDACIONES
  BEFORE INSERT OR UPDATE OF cuenta, centro_costo, codigo_tercero
  ON MIGRA_ARCGAL FOR EACH ROW
  /**
  * Documentacion para trigger TR_MGCGAL_VALIDACIONES
  * Trigger que validará la consistencia entre cuentas contables y centros de costos 
  * al registrar en repositorio migración modulo contable
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 01-09-2017
  */

BEGIN

  --
  -- validar que la cuenta contable acepte movimientos
  IF not cuenta_contable.acepta_mov(:new.no_cia, :new.cuenta) THEN
    Raise_Application_Error('-20002', 'La Cuenta Contable '||cuenta_contable.formatea(:new.no_cia, :new.cuenta)||
                                      ' no acepta movimientos');
  END IF;

  --
  -- si la cuenta acepta centro de costo, debe validar que el centro de costo acepte movimientos
  IF cuenta_contable.acepta_cc(:new.no_cia, :new.cuenta) THEN
    IF :new.centro_costo is null THEN
      IF not centro_costo.acepta_mov(:new.no_cia, :new.cc_1||:new.cc_2||:new.cc_3, null) THEN
        Raise_Application_Error('-20002', 'El Centro de Costos '||centro_costo.formatea(:new.no_cia, :new.cc_1||:new.cc_2||:new.cc_3)||
                                          ' no acepta movimientos con la cuenta '||cuenta_contable.formatea(:new.no_cia, :new.cuenta));
      END IF;
    ELSE
      IF not centro_costo.acepta_mov(:new.no_cia, :new.centro_costo, null) THEN
        Raise_Application_Error('-20002', 'El Centro de Costos '||centro_costo.formatea(:new.no_cia, :new.centro_costo)||
                                          ' no acepta movimientos con la cuenta '||cuenta_contable.formatea(:new.no_cia, :new.cuenta));
      END IF;
    END IF;
  ELSE  -- la cuenta no acepta centro de costo
    IF :new.cc_1 != '000' or :new.centro_costo != centro_costo.rellenad(:new.no_cia, '0') THEN
      Raise_Application_Error('-20002', 'La cuenta '||cuenta_contable.formatea(:new.no_cia, :new.cuenta)||
                                        ' no puede registrar movimientos al Centro de Costos '||centro_costo.formatea(:new.no_cia, :new.centro_costo));

    END IF;
  END IF;

  --
  -- si la cuenta acepta tercero, debe validar que el tercero no sea nulo.
  IF cuenta_contable.acepta_tercero(:new.no_cia, :new.cuenta) THEN
    IF :new.codigo_tercero is null THEN
      Raise_Application_Error('-20002', 'La Cuenta Contable '||cuenta_contable.formatea(:new.no_cia, :new.cuenta)||
                                        ' requiere codigo de tercero');
    END IF;
  END IF;

EXCEPTION
  WHEN cuenta_contable.error THEN
       Raise_Application_Error('-20002', 'TR_CGAL_VALIDACIONES: '||cuenta_contable.ultimo_error);
  WHEN centro_costo.error THEN
       Raise_Application_Error('-20002', 'TR_CGAL_VALIDACIONES: '||centro_costo.ultimo_error);
END;
