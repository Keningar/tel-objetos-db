create or replace PROCEDURE            IMGenera_Conta (
  cia_p                    varchar2,
  ano_p                    number,
  mes_p                    number,
  fecha_p                  date,
  num_asientos_p    IN OUT number,
  pError            IN OUT varchar2
) IS
  --
  -- Genera asientos en forma detallada, hacia el modulo de Contabilidad General.
  -- Esto lo hace para los movimientos del periodo dado (ano_p, mes_p) y para
  -- el pedido digitado.
  -- Devuelve en num_asientos_p la cantidad de asientos que genero hacia Contabilidad.
  -- En caso de error, retorna el mismo en el parametro pError.

  -- Datos del periodo en proceso de la compa?ia en Contabilidad
  CURSOR c_conta IS
    SELECT ano_proce, mes_proce
      FROM arcgmc
     WHERE no_cia = cia_p;

  CURSOR c_impo IS
    SELECT ano_proc, mes_proc , cod_diario
      FROM arimco
     WHERE no_cia = cia_p;

  -- Movimientos pendientes de contabilizar.
  CURSOR c_mov IS
    SELECT dc.cod_cont,       dc.tipo_mov,     NVL(dc.monto,0) M1,
           dc.no_docu,        dc.tipo_cambio,  '000000000' centro_costo,
           dc.Monto_dol,      dc.moneda,       dc.rowid rowid_dc,tipo_doc,
           SUBSTR((tipo_doc||'/'||dc.no_docu), 1,30) descri
     FROM arimdc dc
     WHERE dc.no_cia           = cia_p
       AND dc.ind_con          = 'P' and NVL(MONTO,0) != 0;

  --
  vano_proc       arimco.ano_proc%TYPE;
  vmes_proc       arimco.mes_proc%TYPE;
  vcod_diario     arimco.cod_diario%TYPE;
  vmonto_al       arcgal.monto%TYPE;
  vmonto_dal      arcgal.monto_dol%TYPE;
  vtot_db         arcgae.t_debitos%TYPE;
  vtot_cr         arcgae.t_creditos%TYPE;
  vno_asiento     arcgae.no_asiento%TYPE;
  vano_cg         arcgmc.ano_proce%TYPE;
  vmes_cg         arcgmc.mes_proce%TYPE;
  vestado         arcgae.estado%TYPE;
  vno_comprobante arcgae.no_comprobante%TYPE;
  vfecha          date;
  vcontador       number;
  error_proceso   exception;
  votros_meses    varchar2(1) ;
  vCuenta_lineas  number := 0;

  -- *   Funciones Internas
  --
  FUNCTION Asiento_Pendiente (pcia varchar2, pano number, pmes number) RETURN boolean IS

    --* Devuelve TRUE si existen movimientos pendientes de generar
    --* contablemente y FALSE sino.

    vtmp         varchar2(1);
    vencontro_doc boolean;

    --
    -- Documentos pendientes de contabilizar.
    CURSOR c_documentos IS
     SELECT 'x'
       FROM arimdc dc
      WHERE dc.no_cia   = pcia
        AND dc.ind_con  = 'P'
        AND ROWNUM      = 1;

  BEGIN  -- Asiento_Pendiente
    --* Busca documentos pendientes de contabilizar
    OPEN  c_documentos;
    FETCH c_documentos INTO vtmp;
    vencontro_doc := c_documentos%FOUND;
    CLOSE c_documentos;

    RETURN(vencontro_doc);

  END;  -- Asiento_Pendiente


-- ---
-- Cuerpo principal del procedimiento
--
BEGIN -- IMGenera_Conta

  num_asientos_p  := 0;

  OPEN  c_conta;
  FETCH c_conta INTO vano_cg, vmes_cg;
  CLOSE c_conta;

  IF (ano_p*100)+mes_p < (vano_cg*100)+vmes_cg THEN
    -- si el periodo a generar del asiento es menor que el de proceso de la Conta,
    -- el estado sera de otros meses.
    votros_meses := 'S';
    vestado := 'O';
  ELSE
    votros_meses  := 'N';
    vestado := 'P';
  END IF;

  OPEN  c_impo;
  FETCH c_impo INTO vano_proc, vmes_proc, vcod_diario;
  CLOSE c_impo;

  vfecha  := NVL(fecha_p, sysdate);
  IF TO_CHAR(vfecha, 'RRRRMM') > TO_CHAR((vano_cg*100)+vmes_cg) THEN
    vfecha  := TO_DATE('01'||TO_CHAR(vmes_cg,'00')||TO_CHAR(vano_cg),'DDMMRRRR');
    vfecha  := LAST_DAY(vfecha);
  ELSIF TO_CHAR(vfecha, 'RRRRMM') < TO_CHAR((vano_cg*100)+vmes_cg)  THEN
    vfecha  := TO_DATE('01'||TO_CHAR(vmes_cg,'00')||TO_CHAR(vano_cg),'DDMMRRRR');
  ELSE
     -- si la fecha esta en el periodo, entonces no la calcula sino que la deja como default.
    vfecha := vfecha;
  END IF;

  IF Asiento_Pendiente (cia_p, ano_p ,mes_p) THEN
		-- si existen movimientos por contabilizar.
		-- Inicializar los valores de las variables que se utilizan
		--

		vcontador    := 1;
		vtot_db      := 0;
		vtot_cr      := 0;
		vno_asiento  := NULL;
		-- ---
		-- Inserta las lineas del asiento para los movimientos generados
		-- por los documentos pendientes, solo cuando el asiento no es de movimientos
		-- de otros meses, pues los documentos solo se hacen para el
		-- periodo en proceso
		--

		IF votros_meses  = 'N' THEN

			vno_asiento    := transa_id.cg(cia_p);
			num_asientos_p := num_asientos_p + 1;
			-- -------------------------------------------------------------------
			-- Crea el Encabezado del Asiento, posteriormente le pone el total
			-- de debitos y creditos del mismo.
			--
			INSERT INTO arcgae (NO_CIA,     ANO,                MES,
			            NO_ASIENTO,         FECHA,              ESTADO,
			            AUTORIZADO,         ANULADO,            COD_DIARIO,
			            ORIGEN,             TIPO_COMPROBANTE,   NO_COMPROBANTE,
			            DESCRI1)
			     VALUES (cia_p,             ano_p,              mes_p,
			            vno_asiento,        vfecha,             vestado,
			            'N',                'N',                vcod_diario,
			            'IM',               'T',                0,
			            ' ASIENTO GENERADO DESDE COMPRAS E IMPORTACIONES');

			FOR fila IN c_mov LOOP

				vmonto_al := 0;
				IF (fila.TIPO_MOV = 'C') then
				  vmonto_al   := -1*fila.M1;
				  vmonto_dal  := -1*nvl(fila.monto_dol,0);
				  vtot_cr     := NVL(vtot_cr,0)+nvl(fila.M1,0);
				ELSE
				  vmonto_al   := fila.M1;
				  vmonto_dal  := nvl(fila.monto_dol,0);
				  vtot_db     := NVL(vtot_db,0)+nvl(fila.M1,0);
				END IF;

				INSERT INTO ARCGAL (NO_CIA,        ANO,          MES,
				                    NO_ASIENTO,    NO_LINEA,     CUENTA,
				                    MONTO,         TIPO,         DESCRI,
				                    NO_DOCU,       COD_DIARIO,   MONEDA,
				                    TIPO_CAMBIO,   CENTRO_COSTO, MONTO_DOL,
				                    CODIGO_TERCERO)
				     VALUES (cia_p,               ano_p,             mes_p,
				             vno_asiento,         vcontador,         fila.cod_cont,
				             vmonto_al,           fila.tipo_mov,     fila.descri,
				             fila.no_docu,        vcod_diario,       fila.moneda,
				             fila.tipo_cambio,    fila.centro_costo, vmonto_dal,
				             NULL);

				vcontador := NVL(vcontador,0) + 1;

		    -- Actualiza no_asiento para la linea del documento procesado --
		    UPDATE arimdc
		       SET ind_con    = 'G',
		           ano_proce  = ano_p,
		           mes_proce  = mes_p,
		           no_asiento = vno_asiento
		     WHERE rowid = fila.rowid_dc;

/*		  -- actualiza con el numero de asiento  generado a inventarios--

        -- En la version 4.7. no se replican las DC hacia CxP e Inventarios, por
        -- consistencia y estandar con otros modulos.                  rgarro 01/10/02
        --

		    UPDATE arindc
		     set no_asiento =vno_asiento,
		          ano = ano_p,
		          mes  = mes_p
		     where no_cia   =:uno.no_cia and
		           no_docu  =fila.no_docu and
		           no_asiento is null;

		    --actualiza con el numero de asiento  generado a cxp--
		     update arcpdc
		     set no_asiento =vno_asiento,
		          ano = ano_p,
		          mes  = mes_p
		     where no_cia   =:uno.no_cia and
		           no_docu  =fila.no_docu and
		           no_asiento is null;       */

		  END LOOP;   -- de movimientos
		END IF; -- de votros_meses = 'N'


    IF nvl(vContador, 0) > 0 THEN
      -- ----------------------------------------------------------------
      --
      -- --
      -- Actualiza el total de debitos y creditos del encabezado del asiento
      --
      IF vno_asiento IS NOT NULL THEN
          IF vestado = 'O' THEN
          	-- obtiene numero de comprobante, cuando el asiento generado corresponde
          	-- es de un periodo ya cerrado en Contabilidad.
            vno_comprobante := Consecutivo.cg(cia_p,ano_p,mes_p,'T','COMPROBANTE');
          ELSE
            vno_comprobante := 0;
          END IF;

          -- Actualiza datos del encabezado del asiento generado
          UPDATE arcgae
             SET t_debitos      = vtot_db,
                 t_creditos     = vtot_cr,
                 t_camb_c_v     = 'V',
                 no_comprobante = vno_comprobante
           WHERE no_cia     = cia_p
             AND no_asiento = vno_asiento
             AND ano        = ano_p
             AND mes        = mes_p;

        END IF;
      ELSE
      	DELETE FROM arcgae
         WHERE no_cia     = cia_p
           AND no_asiento = vno_asiento
	         AND ano        = ano_p
	         AND mes        = mes_p;

      END IF;

    END IF;  -- de asientos_pendientes

EXCEPTION
	WHEN error_proceso THEN
       pError := 'ERROR en IMGENERA_CONTA : '||pError;
	WHEN transa_id.error THEN
       pError := transa_id.ultimo_error;
	WHEN consecutivo.error THEN
       pError := consecutivo.ultimo_error;
	WHEN others THEN
       pError := 'ERROR en IMGENERA_CONTA : '||sqlerrm;
END; -- IMGenera_Conta