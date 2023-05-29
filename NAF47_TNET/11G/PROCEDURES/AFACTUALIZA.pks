CREATE OR REPLACE PROCEDURE NAF47_TNET.AFACTUALIZA ( pCia             arcgae.no_cia%type,
                                                     pAno_proce       arcgae.ano%type,
                                                     pMes_proce       arcgae.mes%type,
                                                     pMsg_error       out VARCHAR2  	) IS

 /**
  * Documentacion para NAF47_TNET.AFACTUALIZA
  * Paquete que contiene los procesos para la actualizacion de Activos Fijos
  * @author NN 
  * @version 1.0 NN
  *
  * @author Elvis Muñoz emunoz@telconet.net 
  * Se procede al cambio de la funcion GEK_CONSULTA.F_RECUPERA_LOGIN por la sentencoa LOWER(USER)
  * @version 1.1 15/01/2023
  */

 CURSOR c_movimientos IS
    SELECT m.no_acti, m.fecha, m.hora, m.tipo_m, m.no_docu, m.no_cia,
           NVL(monto, 0) monto,
           nvl(monto1,0) monto1,
           ano, mes,
           area_a, no_depa_a, no_empl_a,
           m.ctacred, a.f_ingre, a.duracion,
           m.cc_act, m.tipo_cambio,
           a.mejoras,
           a.mejoras_dol,
           a.rev_tecs,
           a.rev_tecs_dol,
           a.metodo_dep,
           nvl(a.depacum_mejoras_ant,0) depacum_mejoras_ant,
           nvl(a.depacum_revtecs_ant,0) depacum_revtecs_ant,
           nvl(a.depacum_mejoras_ant_dol,0) depacum_mejoras_ant_dol,
           nvl(a.depacum_revtecs_ant_dol,0) depacum_revtecs_ant_dol,
           a.vida_util_residual,
           a.fecha_inicio_dep,
           m.vida_util_adicional,
           m.tipo_traslado,
           m.grupo_cliente_ant, m.grupo_cliente_act,
           m.cliente_ant, m.cliente_act,
           a.serie
     FROM arafma a, arafmm m
    WHERE m.no_cia  = pCia
      AND m.estado  = 'P'
      AND m.no_cia  = a.no_cia
      AND m.no_acti = a.no_acti;

   CURSOR c_activo_hd(pNo_acti arafhd.no_acti%type) IS
     SELECT 'x'
     FROM arafhd
     WHERE no_cia  = pCia
       AND no_acti = pNo_acti
       AND ano     = pAno_proce
       AND mes     = pMes_proce;

  CURSOR c_cuadre(pNo_docu varchar2,
									pTipo    varchar2,
									pFecha   DATE 	)IS
     SELECT sum(decode (tipo, 'D', monto, 0)) debito,
            sum(decode (tipo, 'C', monto, 0)) credito
       FROM ARAFDC
      WHERE no_cia      = pCia
        AND no_docu     = pNo_docu
        AND tipo_m      = pTipo
        AND fecha       = pFecha
      GROUP BY no_cia, no_docu, tipo_m, fecha;
  --
  CURSOR C_DATOS_RESPONSABLE (Cv_LoginEmpleado VARCHAR2) IS
    SELECT VEE.NOMBRE, VEE.OFICINA
    FROM V_EMPLEADOS_EMPRESAS VEE
    WHERE VEE.LOGIN_EMPLE = Cv_LoginEmpleado;
  --
  vMonto		      	      arafmm.monto%type;
  vMonto1		      	      arafmm.monto1%type;
  vF_fin                  arafmm.fecha%type;
  vF_actual               arafmm.fecha%type;
  vMeses_util             arafma.vida_util_residual%type;
  vM_mej_dol              arafma.mejoras%type;
  vM_revtec_dol           arafma.rev_tecs%type;
  vM_depacum_revtec_dol   arafma.depacum_revtecs%type;
  vNeto_RevTecs           arafma.rev_tecs%type;
  vNeto_RevTecs_Dol       arafma.rev_tecs_dol%type;
  vNeto_Mejoras           arafma.mejoras%type;
  vNeto_Mejoras_Dol       arafma.mejoras_dol%type;
  vDebitos                arcgae.t_debitos%type;
  vCreditos               arcgae.t_creditos%type;
  vActivo_hd              varchar(1);
  F_asiento               varchar2(6);
  F_proceso	              varchar2(6);
  error_proceso           exception;
  --
  Lr_InfoElementoTrazabilidad DB_INFRAESTRUCTURA.INFO_ELEMENTO_TRAZABILIDAD%ROWTYPE;
  --Lv_LoginEmpleado            NAF47_TNET.LOGIN_EMPLEADO.LOGIN%TYPE := NAF47_TNET.GEK_CONSULTA.F_RECUPERA_LOGIN;--emunoz 11012023
  Lv_LoginEmpleado            VARCHAR2(30) :=LOWER(USER);
  Lr_DatosResponsable         C_DATOS_RESPONSABLE%ROWTYPE := NULL;
  --

BEGIN

  FOR i IN c_movimientos LOOP

     --Obtiene fechas para el calculo de los factores de depreciacion
	   vF_fin     := add_months(i.fecha_inicio_dep, i.vida_util_residual);
	   vF_actual  := to_date(lpad(to_char(pMes_proce),2,'0')||to_char(pAno_proce),'MMYYYY');

	   vmeses_util   := trunc(months_between(vF_fin, vF_actual));

    -- Se valida fecha en periodo en proceso, y que este cuadrado en nominal.
    -- No se valida tipo de unicidad del cambio debido a que se almacena en
    -- el encabezado, por lo que es unico
    OPEN  c_cuadre(i.no_docu, i.Tipo_m, i.fecha);
    FETCH c_cuadre INTO vDebitos, vCreditos;
    CLOSE c_cuadre;

    F_asiento := to_char(i.fecha, 'yyyymm');
    F_proceso := to_char(pAno_proce*100 + pMes_proce);

    IF NOT (F_asiento <= F_proceso) THEN
       pMsg_error := 'El movimiento tipo '||i.tipo_m||' sobre el activo '||i.no_acti ||' presenta inconsistencias en la fecha';
       RAISE error_proceso;

    ELSIF NOT (nvl(vDebitos,0) = nvl(vCreditos,0)) THEN
       pMsg_error := 'El movimiento tipo '||i.tipo_m||' sobre el activo '||i.no_acti ||' presenta inconsistencias en el cuadre contable';
       RAISE error_proceso;
    ELSE
       IF i.tipo_m = 'S' THEN    		-- Salida o Retiro
          UPDATE arafma
             SET f_egre = i.fecha
           WHERE no_cia  = i.no_cia
             AND no_acti = i.no_acti;

       ELSIF i.tipo_m = 'T' THEN		-- Traslados
       	 --- ANR 29-11-2010
       	 IF i.tipo_traslado = 'E' Then --- traslado por empleado
          UPDATE ARAFMA
             SET    no_depa       = i.no_depa_a,
                    no_emple      = i.no_empl_a,
                    area          = i.area_a,
                    centro_costo  =  i.cc_act,
                    grupo_cliente = null,
                    cliente    = null
           WHERE no_cia  = i.no_cia
             AND no_acti = i.no_acti;

         ELSIF i.tipo_traslado = 'C' Then --- traslado por cliente
          UPDATE ARAFMA --- queda el registro del area pero ya no es encargado el empleado
             SET    no_depa        = i.no_depa_a,
                    no_emple       = null,
                    area           = i.area_a,
                    grupo_cliente  = i.grupo_cliente_act,
                    cliente     = i.cliente_act,
                    centro_costo  =  i.cc_act
            WHERE no_cia  = i.no_cia
             AND no_acti = i.no_acti;
          END IF;

       ELSIF i.tipo_m = 'M' THEN		-- Mejoras
          vM_mej_dol := moneda.redondeo(i.monto/i.tipo_cambio,'D');
          UPDATE arafma
             SET mejoras     = nvl(mejoras,0)     + i.monto,
                 mejoras_dol = nvl(mejoras_dol,0) + vM_mej_dol
           WHERE no_cia  = i.no_cia
             AND no_acti = i.no_acti;

        ELSIF i.tipo_m = 'V' THEN		-- Mejoras y aumento de vida util
          vM_mej_dol := moneda.redondeo(i.monto/i.tipo_cambio,'D');
          UPDATE arafma
             SET mejoras     = nvl(mejoras,0)     + i.monto,
                 mejoras_dol = nvl(mejoras_dol,0) + vM_mej_dol,
                 duracion    = duracion + nvl(i.vida_util_adicional,0)
           WHERE no_cia  = i.no_cia
             AND no_acti = i.no_acti;

       ELSIF i.tipo_m = 'R' THEN			-- Revaloraciones
         vM_revtec_dol          := moneda.redondeo(nvl(i.monto,0)/i.tipo_cambio,'D');
         vM_depacum_revtec_dol  := moneda.redondeo(nvl(i.monto1,0)/i.tipo_cambio,'D');

         UPDATE arafma
            SET rev_tecs              = nvl(rev_tecs,0)            + nvl(i.monto,0),
                depacum_revtecs_ant   = nvl(depacum_revtecs_ant,0) + nvl(i.monto1,0),
								depacum_revtecs       = nvl(depacum_revtecs,0)  + nvl(i.monto1,0),
								depre_ejer_revtec     = nvl(depre_ejer_revtec,0)+ nvl(i.monto1,0),

								rev_tecs_dol            = nvl(rev_tecs_dol,0)            + vm_revtec_dol,
								depacum_revtecs_ant_dol = nvl(depacum_revtecs_ant_dol,0) + vm_depacum_revtec_dol,
								depacum_revtecs_dol     = nvl(depacum_revtecs_dol,0)  + vm_depacum_revtec_dol,
								depre_ejer_revtec_dol   = nvl(depre_ejer_revtec_dol,0)+ vm_depacum_revtec_dol
           WHERE no_cia  = i.no_cia
             AND no_acti = i.no_acti;

           --Registra la depreciacion acumulada
           OPEN c_activo_hd(i.no_acti);
           FETCH c_activo_hd INTO vActivo_hd;
           IF c_activo_hd%notfound THEN
               CLOSE c_activo_hd;

               INSERT INTO arafhd (no_cia, no_acti, ano, mes, tipo_dep,
                                   dep_revtecs,depacum_revtecs,
                                   dep_revtecs_dol,depacum_revtecs_dol )
						               VALUES (pCia, i.no_acti, pAno_proce, pMes_proce, 'N',
						                       i.monto, i.monto1,
						                       nvl(vM_revtec_dol,0), nvl(vM_depacum_revtec_dol,0));
           ELSE
           	   CLOSE c_activo_hd;

           	   UPDATE arafhd
           	   SET  dep_revtecs        = nvl(dep_revtecs,0) + i.monto,
           	        depacum_revtecs    = nvl(depacum_revtecs,0) + i.monto1,
                    dep_revtecs_dol    = nvl(dep_revtecs_dol,0) + vm_revtec_dol,
                    depacum_revtecs_dol= nvl(depacum_revtecs_dol,0) + vm_depacum_revtec_dol,
                    rev_tecs_acum      = nvl(rev_tecs_acum,0) + i.monto,
                    rev_tecs_acum_dol  = nvl(rev_tecs_acum_dol,0) + vm_revtec_dol
               WHERE no_cia  = pCia
                 AND no_acti = i.no_acti
                 AND ano     = pAno_proce
                 AND mes     = pMes_proce;
           END IF;

       END IF;
       --
       vMonto     := moneda.redondeo(i.monto,'P');
       vMonto1    := moneda.redondeo(i.monto1,'P');

       -- PARA TODOS LOS MOVIMIENTOS
       -- Insercion del movimiento en ARAFHM
       INSERT INTO arafhm( no_cia, no_acti, fecha, hora,
                          tipo_m, no_docu, monto, monto1,
		                      ano, mes, tipo_cambio,
		                      no_depa, no_empl, area,
		                      centro_costo, vida_util_adicional,
                          grupo_cliente, cliente)
		               VALUES( pCia, i.no_acti, i.fecha, i.hora,
		                       i.tipo_m, i.no_docu,vMonto, vMonto1,
			                     i.ano, i.mes, i.tipo_cambio,
			                     i.no_depa_a, i.no_empl_a, i.area_a,
			                     i.cc_act, i.vida_util_adicional,
                           i.grupo_cliente_act, i.cliente_act );

       -- -------------------------------------------------
       -- Actualiza el registro de la distribucion contable
       -- indicando que el movimiento fue actualizado
         UPDATE arafdc
            SET ind_con = 'A'
          WHERE no_cia  = pCia
            AND no_docu = i.no_docu
            AND tipo_m  = i.tipo_m;

       -- -------------------------------
       -- Cambia el estado del movimiento
       -- -------------------------------
         UPDATE arafmm
            SET estado = 'A'
          WHERE no_cia  = pCia
            AND no_docu = i.no_docu
            AND estado  = 'P';
       --
       -- se registra baja en la trazibilidad 
       IF i.tipo_m = 'S' THEN    		-- Salida o Retiro
         --
         IF C_DATOS_RESPONSABLE%ISOPEN THEN
           CLOSE C_DATOS_RESPONSABLE;
         END IF;
         --
         OPEN C_DATOS_RESPONSABLE (Lv_LoginEmpleado);
         FETCH C_DATOS_RESPONSABLE INTO Lr_DatosResponsable;
         IF C_DATOS_RESPONSABLE%NOTFOUND THEN
           Lr_DatosResponsable := NULL;
         END IF;
         CLOSE C_DATOS_RESPONSABLE;
         --
         Lr_InfoElementoTrazabilidad.Login           := 'N/A';
         Lr_InfoElementoTrazabilidad.Responsable     := NVL(Lr_DatosResponsable.Nombre,'N/A'); 
         Lr_InfoElementoTrazabilidad.Oficina_Id      := NVL(Lr_DatosResponsable.Oficina,0); 
         Lr_InfoElementoTrazabilidad.Usr_Creacion    := Lv_LoginEmpleado;
         Lr_InfoElementoTrazabilidad.Fe_Creacion_Naf := SYSDATE;
         Lr_InfoElementoTrazabilidad.Fe_Creacion     := SYSDATE;
         Lr_InfoElementoTrazabilidad.Ip_Creacion     := GEK_CONSULTA.F_RECUPERA_IP;
         Lr_InfoElementoTrazabilidad.Cod_Empresa     := i.No_Cia;
         Lr_InfoElementoTrazabilidad.Estado_Naf      := 'Fuera de Bodega';
         Lr_InfoElementoTrazabilidad.Estado_Activo   := 'Da?ado';
         Lr_InfoElementoTrazabilidad.Estado_Telcos   := 'Eliminado';
         Lr_InfoElementoTrazabilidad.Ubicacion       := 'Fuera de bodega';
         Lr_InfoElementoTrazabilidad.Transaccion     := 'Despacho de equipos da?ados';--Lr_DocumentoInv.Accion;               
         Lr_InfoElementoTrazabilidad.Observacion     := 'Baja de equipo';
         Lr_InfoElementoTrazabilidad.Numero_Serie    := i.serie;
         --
         NAF47_TNET.INKG_TRANSACCION.P_INSERTA_INFO_ELE_TRAZAB( Lr_InfoElementoTrazabilidad,
                                                                pMsg_error); 
         --
         IF pMsg_error IS NOT NULL THEN
           RAISE error_proceso;
         END IF;             
         --
       END IF;


    END IF;

  END LOOP;

EXCEPTION
  WHEN error_proceso THEN
     pMsg_error := 'AFACTUALIZA :'||pMsg_error;
     ROLLBACK;
     RETURN;

  WHEN OTHERS THEN
     pMsg_error := 'AFACTUALIZA :'||sqlerrm;
     ROLLBACK;
     RETURN;

END;
/