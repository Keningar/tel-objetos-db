create or replace Procedure            CGBorra_Cta (
  pCia       in Arcgms.No_Cia%type,
  pCta       in Arcgms.cuenta%type,
  pmsg_error in out varchar2
) IS
  --
  CURSOR c_parametizada IS
	   SELECT 'x'
	     FROM arcgatl
	    WHERE no_cia = pCia
	      AND cuenta = pCta;

  vSubCta       varchar2(30);
  vExiste       varchar2(1);
  vEncontro     boolean;
  error_proceso exception;

begin

    OPEN  c_parametizada;
    FETCH c_parametizada INTO vExiste;
    vEncontro := c_parametizada%found;
    CLOSE c_parametizada;
    IF vEncontro THEN
    	RAISE error_proceso;
    END IF;

    vSubCta     := Cuenta_Contable.TrimD(pCia, pCta);
    vSubCta     := vSubCta ||'%';
    --  Borra la cuenta del historico ajustes por PCGA's
    delete from arcgpga
           where no_cia  = pCia
             and cuenta  like vSubCta;
    --  Borra la cuenta del historico de terceros
    delete from arcghc_t
           where no_cia  = pCia
             and cuenta  like vSubCta;
    --  Borra la cuenta del historico por centro de costo
    delete from arcghc_c
           where no_cia  = pCia
             and cuenta  like vSubCta;
    --  Borra la cuenta del maestro de saldos por centro de costo
    delete from arcgms_c
           where no_cia  = pCia
             and cuenta  like vSubCta;
    --  Borra la cuenta del historico de saldos por cuenta
    delete from arcghc
           where no_cia  = pCia
             and cuenta  like vSubCta;
    --  Borra la cuenta del maestro de movimientos contables
    delete from arcgmm
           where no_cia  = pCia
             and cuenta  like vSubCta;
    --  Borra la cuenta de la definicion de distribucion de cuentas por centro de costo
    delete from arcgd_cc
           where no_cia  = pCia
             and cuenta  like vSubCta;
    --  Borra la cuenta del maestro de saldos
    delete from arcgms
           where no_cia  = pCia
             and cuenta  like vSubCta;

EXCEPTION
  WHEN error_proceso THEN
   	 pmsg_error := 'No se puede borrar la cuenta porque esta parametrizada en Asientos Fijos';
  WHEN others THEN
     pmsg_error := nvl(sqlerrm, 'CGBorra_cta');
END;