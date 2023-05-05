create or replace PROCEDURE            INCrea_Articulo(
  pcia          IN varchar2,
  pbodega       IN varchar2,
  pno_arti      IN varchar2,
  pafecta_costo IN varchar2,
  pmsg_error    IN OUT varchar2
) IS
  --
  -- Crea un articulo en una bodega especifica.
  -- El default de saldos es 0, pues para modificar estos, se debe usar el
  -- stored procedure INACTUALIZA_SALDOS_ARTICULO.
  --
  CURSOR c_datos_arti IS
    SELECT clase, categoria, costo_unitario, ultimo_costo, costo2_unitario, ultimo_costo2
      FROM arinda
     WHERE no_cia  = pCia
       AND no_arti = pNo_arti;
  --
  CURSOR c_existe IS
    SELECT 'x'
      FROM arinma
     WHERE no_cia  = pCia
       AND bodega  = pBodega
       AND no_arti = pNo_arti;
  --
  vencontro  boolean;
  vtmp       varchar2(1);
  vclase     arinda.clase%type;
  vcategoria arinda.categoria%type;
  --

  ncosto_unitario   arinda.costo_unitario%type;
  nultimo_costo     arinda.ultimo_costo%type;
  ncosto2_unitario  arinda.costo2_unitario%type;
  nultimo_costo2    arinda.ultimo_costo2%type;

  error_proceso exception;
BEGIN

	--
	-- verifica si el articulo ya existe
	OPEN  c_existe;
	FETCH c_existe INTO vtmp;
	vencontro := c_existe%found;
	CLOSE c_existe;

	--
	-- sino existe lo inserta.
	IF not vencontro THEN

		OPEN  c_datos_arti;
		FETCH c_datos_arti INTO vclase, vcategoria, ncosto_unitario, nultimo_costo, ncosto2_unitario, nultimo_costo2;
		vencontro := c_datos_arti%found;
		CLOSE c_datos_arti;

		IF not vencontro THEN
			pmsg_error := 'El articulo '||pNo_arti||' no ha sido definido';
			RAISE error_proceso;
		END IF;

    INSERT INTO arinma(no_cia, bodega, no_arti,
                       sal_ant_un, comp_un, otrs_un, vent_un, cons_un,
                       sal_ant_mo, comp_mon, otrs_mon, vent_mon, cons_mon,
                       costo_uni, ult_costo, afecta_costo, proceso_toma, proceso_soli,
                       costo2, ult_costo2 )
                VALUES(pCia, pBodega,  pNo_arti,
                       0,    0,       0,      0,          0,
                       0,    0,       0,      0,          0,
                       ncosto_unitario, nultimo_costo,       pAfecta_costo,      'N',      'N',
                       ncosto2_unitario, nultimo_costo2);
	END IF;

EXCEPTION
  WHEN error_proceso THEN
       return;
  WHEN others THEN
       pmsg_error := 'INCREA_ARTICULO : '||sqlerrm;
       return;
END;