create or replace PROCEDURE            CGcrea_Cta_Utilidades (
   pCia       in Varchar2,
   pAno       in Varchar2,
   pMes       in Varchar2,
   pmsg_error in out Varchar2
) IS
   -- --
   -- La cuenta de utilidad/perdida que utiliza el sistema se compone
   -- de una cuenta de mayor y 2 cuentas hijas.
   -- -.La primer cuenta se utiliza para el resultado de "netear" las cuentas
   -- de ingresos y egresos sin incluir las que reciben los ajustes por
   -- inflacion.
   -- -.Mientras que la segunda se utiliza para el neto de las cuentas de
   -- ajuste por inflacion
   -- Por ejemplo.
   --             UU-000-000  mayor de utilidades
   --             UU-001-000  sub-cuenta1 de utilidades
   --             UU-002-000  sub-cuenta2
   --
   cNewLine      varchar2(2) := CHR(10);
   --
   vExiste       boolean;
   vProcesando   varchar2(150);
   vtipo         arcgti.tipo%type;
   vcta          arcgms.cuenta%type;
   vcta_padre    arcgms.cuenta%type;
   rCta          arcgms%rowtype;
   --
   CURSOR c_Tipo IS
     SELECT min(tipo)
       FROM arcgti
      WHERE clase = 'C';
   --
   Error_Proceso   Exception;
BEGIN
  vProcesando := 'Obteniendo tipo';
  --
  OPEN  c_tipo;
  FETCH c_tipo INTO vtipo;
  vExiste := nvl(c_tipo%FOUND, FALSE);
  CLOSE c_Tipo;

  IF not vexiste or vtipo is null THEN
    vProcesando := 'Error Debe declarar algun tipo de cuenta que sea Capital';
    RAISE Error_Proceso;
  END IF;
  --
  vProcesando := 'Llenando datos de cuenta';
  -- Crea el nivel 1 de la cuenta con U's relleno de U's
  vCta                := Cuenta_Contable.LLena_Nivel(pCia, 'U', 1, 'U');
  vCta                := Cuenta_Contable.Rellenad(pCia, vCta);
  vCta_Padre          := NULL;
  rcta.no_cia         := pcia;
  rcta.cuenta         := vcta;
  rcta.descri         := 'UTILIDAD O PERDIDA DEL MES';
  rcta.tipo           := vtipo;
  rcta.clase          := '9';  -- Clase 9
  rcta.ind_mov        := 'N';
  rcta.ind_presup     := 'N';
  rcta.presup_cambio  := 'N';
  rcta.descri_larga   :=  rcta.descri;
  rcta.moneda         := 'P';
  rcta.activa         := 'S';
  rcta.f_inactiva     := NULL;
  rcta.permiso_con    := 'N';
  rcta.permiso_che    := 'N';
  rcta.permiso_cxp    := 'N';
  rcta.permiso_pla    := 'N';
  rcta.permiso_afijo  := 'N';
  rcta.permiso_inv    := 'N';
  rcta.permiso_aprov  := 'N';
  rcta.permiso_fact   := 'N';
  rcta.permiso_cxc    := 'N';
  rcta.permiso_cch    := 'N';
  rcta.monetaria      := 'N';
  rcta.ajustable      := 'N';
  rcta.acepta_cc      := 'N';
  rcta.usado_en       := NULL;
  rcta.compartido           := 'N';
  rcta.tcambio_conversion   := 'P';
  rcta.padre                := vCta_Padre;
  rcta.nivel                := 1;
  rcta.ind_tercero          := 'N';
  rcta.cta_ajuste_inflacion := NULL;
  rcta.cta_correccion       := NULL;
  rcta.cod_ajuste           := NULL;
  rcta.naturaleza           := 'A';
  --
  rcta.descri_1 := 'Esta cuenta fue creada automaticamente al crear la compa?ia.'|| cNewLine||
                   'La funcion de esta cuenta es llevar la utilidad o perdida del mes' ||cNewLine||
                   'cada vez que se utilice el programa de calculo de utilidades.'|| cNewLine||
                   'Es importante mencionar que no es una cuenta que pertenezca al'|| cNewLine||
                   'catalogo contable, es solo para uso interno de la aplicacion y'|| cNewLine||
                   'cada vez que se cierre periodo fiscal, esta cuenta sera limpiada'|| cNewLine||
                   'para el siguiente periodo.';
  --
  -- Crea la cuenta de mayor de utilidades
  vProcesando := NULL;
  CGCrea_Cta(pCia, pAno, pMes, rcta, pmsg_error);
  IF pmsg_error IS NOT NULL THEN
     Raise Error_Proceso;
  END IF;
  --
  -- --
  -- Define las caracteristicas generales de las cuentas detalle de utilidades
  vProcesando := 'Llenando datos generales de las cuentas hijas ';
  rCta.Padre := vCta;
  rCta.Nivel := 2;
  --
  -- Define la primer cuenta hija
  vProcesando := 'Llenando datos de la cuenta de utilidades sin ajustes';
  vCta   := Cuenta_Contable.Nueva_Hija(pCia, rcta.padre, '1');
  rcta.cuenta       := vcta;
  rcta.descri       := 'UTIL./PERD. SIN AJUSTE';
  rcta.descri_larga := 'Utilidad o Perdida sin Ajuste Inflacionario';
  vProcesando := NULL;
  CGCrea_Cta(pCia, pAno, pMes, rcta, pmsg_error);
  IF pmsg_error IS NOT NULL THEN
    Raise Error_Proceso;
  END IF;
  --
  -- Defino la segunda cuenta hija
  vProcesando := 'Llenando datos de la cuenta de utilidades con ajustes';
  vCta   := Cuenta_Contable.Nueva_Hija(pCia, rcta.padre, '2');
  rcta.cuenta       := vcta;
  rcta.ajustable    := 'S';
  rcta.descri       := 'UTIL./PERD. CON AJUSTE';
  rcta.descri_larga := 'Utilidad o Perdida con Ajuste Inflacionario';
  vProcesando := NULL;
  CGCrea_Cta(pCia, pAno, pMes, rcta, pmsg_error);
  IF pmsg_error IS NOT NULL THEN
     raise Error_Proceso;
  END IF;
EXCEPTION
  WHEN CUENTA_CONTABLE.ERROR THEN
     pmsg_error := nvl(CUenta_contable.ultimo_Error, 'CGcrea_cta_utilidades:'|| vprocesando);
  WHEN Error_Proceso THEN
     pmsg_error := nvl(pmsg_error, 'CGcrea_cta_utilidades:'|| vprocesando);
  WHEN OTHERS THEN
     pmsg_error := nvl(pmsg_error, 'CGCrea_Cta_Utilidades:'|| vprocesando);
END;