CREATE or replace PACKAGE NAF47_TNET.Conciliacion IS
  -- ---
  --  Este paquete contiene un conjunto de procedimientos utilizados en el proceso
  --  de conciliacion bancaria (conciliar y desconciliar documentos)
  --
  --  En general las funciones reciben la compa?ia, cuenta bancaria, a?o y el mes
  --  para el cual se ejecutara un proceso
  --
  PROCEDURE Concilia (cia_p       varchar2,  cta_p      varchar2, ano_p number,  mes_p number,
                      ano_ini_p   number,    mes_ini_p  number, pactual_cia out number,
                      pactual_bco out number,pbco_saldo number, observ_p        varchar2);
  --
  PROCEDURE Desconcilia_documento (p_cia  varchar2, p_cta  varchar2, p_proce varchar2,
                                   p_tipo varchar2, p_docu number);
  --
  PROCEDURE Desconcilia_Saldo_Periodo (ciap varchar2, ctap varchar2, anop number, mesp number);
  --
  PROCEDURE Cierra_Periodo (cia_p        varchar2, cta_p varchar2, ano_conc_p number,
                            mes_conc_p   number,   ano_proc_p number,   mes_proc_p number,
                            actual_cia_p number,   actual_bco_p number,   che_p      number,
                            depo_p       number,   t_bancos_p number,   t_libros_p number,
                            nct_p        number,   ndt_p number,   ncr_p      number,
                            ndb_p        number,   ckb_p number,   dpb_p      number,
                            ajdb_p       number,   ajcr_p number,   dife_p     number);
  --
  PROCEDURE Abre_Periodo (p_cia varchar2, p_cta varchar2, p_ano number, p_mes number);
  --
  FUNCTION ultimo_error RETURN VARCHAR2 ;
  --
  error           EXCEPTION;
  PRAGMA          EXCEPTION_INIT(error, -20035);
  kNum_error      NUMBER := -20035;
END;  -- conciliacion
/

CREATE OR REPLACE PACKAGE BODY NAF47_TNET.Conciliacion IS
   /*******[ PARTE: PRIVADA ]  ****************
   * Declaracion de Procedimientos o funciones PRIVADOS
   */
   vMensaje_error       VARCHAR2(160);
   PROCEDURE limpia_error IS
   BEGIN
      vMensaje_error := NULL;
   END;
   --
   PROCEDURE genera_error(msj_error IN VARCHAR2)IS
   BEGIN
      vMensaje_error := substr(msj_error,1,160);
      RAISE_APPLICATION_ERROR(kNum_error, msj_error);
   END;
   --
   PROCEDURE Guarda_No_Conciliado (ciap  varchar2, ctap    varchar2, procep   varchar2,
                                   tipop varchar2, docup   number, fechap   date,
                                   benep varchar2, montop  number, msgp     varchar2,
                                   detallep varchar2, montobcop number, difep number) IS
   -- Almacena los documentos que no fue posible conciliar de ninguna de las formas
   -- posibles de conciliar : Por ajustes especiales, por tipo y numero de documento o
   -- por tipo y monto.
   -- El procedimiento lo busca primero para verificar que no haya sido insertado
   -- como no conciliado por algun otro proceso. En caso de no encontrarlo, entonces
   -- lo inserta.
   -- Los valores en caso de no conciliar para el parametro msgp son :
   --
   -- TR  = Documento en Transito
   -- PR  = Documento pendiente de registro en la Cia.
   -- DIF = Documentos con diferencia en sus montos.
   -- NA  = Documento de Ajuste NO Aplicado a otro documento.
   BEGIN
     -- Si ya esta en la tabla, entonces lo mantiene.
     UPDATE arckcnc
        SET mensaje     = mensaje
      WHERE no_cia      = ciap
        AND no_cta      = ctap
        AND procedencia = procep
        AND tipo_doc    = tipop
        AND no_docu     = docup;
     -- si no esta en la tabla, lo inserta.
     IF sql%rowcount = 0 THEN
       INSERT INTO arckcnc (no_cia,       no_cta,    procedencia,
                   tipo_doc,     no_docu,   fecha,
                   beneficiario, monto,     cod_msg, mensaje,
                   monto_bco,    difere)
            VALUES(ciap,  ctap,  procep,   tipop,    docup, fechap,
                   benep, montop,msgp,     detallep, montobcop, difep);
     END IF;
   END; -- Guarda_NO_Conciliado
   --
   PROCEDURE Graba_HC (cia_p     varchar2, cta_p     varchar2, ano_p number,   mes_p number,
                       ano_ini_p number,   mes_ini_p number, actual_bco_p    number) IS
       -- Actualiza en el historico de cuentas, el saldo del banco para el
     -- mes y a?o que se concilia y el indicador de que el saldo del periodo
     -- ya esta conciliado.
   BEGIN
     UPDATE arckhc
        SET saldo_fin_b = actual_bco_p,
            saldo_conciliado = 'S'
      WHERE no_cia      = cia_p
        AND no_cta      = cta_p
        AND ano         = ano_p
        AND mes         = mes_p;
   END;  -- Graba_HC
   PROCEDURE verifica_saldo_sigte (pno_cia    varchar2, pno_cta varchar2,
                                   pano       number,   pmes number,
                                   psaldo_cia number ) IS
     -- Este proceso es util para verificar cualquier tipo de inconsistencia
     -- en los saldos de arranque de la compa?ia y los de arranque de la conciliacion
     -- Si se esta cerrando el periodo inmediatamente anterior al de arranque
     -- del sistema (ano_ini, mes_ini), se debe validar que el saldo de la
     -- compania luego de conciliar, sea igual al de arranque del sistema (sal_cia_ini)
     --
     CURSOR c_conciliado IS
       SELECT NVL(saldo_conciliado, 'N')
         FROM arckhc
        WHERE no_cia = pno_cia
          AND no_cta = pno_cta
          AND ano    = pano
          AND mes    = pmes;
     --
     CURSOR c_datos_cta IS
       SELECT ano_ini, mes_ini, sal_cia_ini
         FROM arckmc
        WHERE no_cia = pno_cia
          AND no_cta = pno_cta;
     vsal_cia_ini     arckmc.sal_cia_ini%TYPE;
     vano_sig         arckmm.ano%TYPE;
     vmes_sig         arckmm.mes%TYPE;
     vsaldo_con       arckhc.saldo_conciliado%TYPE;
     vencontro        boolean;
     vano_ini         arckmc.ano_ini%TYPE;
     vmes_ini         arckmc.mes_ini%TYPE;
   BEGIN
     OPEN  c_datos_cta ;
       FETCH c_datos_cta INTO vano_ini, vmes_ini, vsal_cia_ini;
       vencontro := c_datos_cta%FOUND;
       CLOSE c_datos_cta;
       IF NOT vencontro THEN
            Genera_Error('Cuenta Bancaria no definida');
       END IF;
       IF NVL(vano_ini,0) = 0 OR NVL(vmes_ini, 0) = 0 THEN
            Genera_Error('ERROR en datos de arranque de la Cta Bancaria : A?o y Mes de arranque no definidos');
       END IF;
     OPEN  c_conciliado ;
       FETCH c_conciliado INTO vsaldo_con;
       vencontro := c_conciliado%FOUND;
       CLOSE c_conciliado;
       IF NOT vencontro THEN
            Genera_Error('El registro para el mes a cerrar no esta en el historico. Debe correr el proceso de conciliacion para el mes a cerrar ');
       END IF;
       -- si el saldo_conciliado es N indica que el proceso de conciliacion aun no se ha corrido
       -- o que se ingreso algun ajuste para el periodo y no se ha vuelto a correr la conciliacion.
       IF vsaldo_con = 'N' THEN
            Genera_Error('Se han ingresado documentos nuevos o ajustes para el periodo a cerrar. Debe correr nuevamente el proceso de conciliacion');
       END IF;
       IF pmes = 12 THEN
           vano_sig := pano + 1;
           vmes_sig := 1;
       ELSE
           vano_sig := pano;
           vmes_sig := pmes + 1;
     END IF;
     IF (vano_sig*100) + vmes_sig = (vano_ini*100) + vmes_ini THEN
         -- esta validacion se realiza solo si el siguiente periodo a conciliar
         -- es el mismo de arranque del sistema.
       IF NVL(psaldo_cia,0) <> NVL(vsal_cia_ini,0) THEN
            Genera_Error('El saldo final del mes a cerrar presenta una diferencia de '||TO_CHAR(NVL(psaldo_cia,0) - NVL(vsal_cia_ini,0), '999,999,990.00')||
                        ' con el saldo de arranque de la compa?ia para el mes siguiente. Ajustelo antes de cerrarlo ');
       END IF;
     END IF;
   END;  -- verifica_saldo_sigte
   --
   PROCEDURE Pone_Conciliado (p_cia  varchar2, p_cta  varchar2, p_ano  number, p_mes number,
                             p_proc varchar2, p_tipo varchar2, p_docu number) IS
   BEGIN
     -- pone el estado conciliado = S y el a?o y mes de la conciliacion para el documento
     -- pasado como parametro.
     UPDATE arckmm
        SET conciliado = 'S',
            ano_conciliado = p_ano,
            mes_conciliado = p_mes
      WHERE no_cia      = p_cia
        AND no_cta      = p_cta
        AND procedencia = p_proc
        AND tipo_doc    = p_tipo
        AND no_docu     = p_docu;
   END;  -- Pone_Conciliado
   --
   PROCEDURE Concilia_Ajustes_Especiales (cia_p varchar2, cta_p varchar2, ano_p number, mes_p number) IS
     -- Concilia los documentos que fueron ajustados mediante la opcion
     -- de Ajustes especiales y que hayan sido registrados en el mismo
     -- mes y a?o que se esta conciliando.
     CURSOR c_ajustes_esp IS
       SELECT ae.proce, ae.tipo_doc, ae.no_docu
         FROM arckcaee ae, arckmm mm
        WHERE ae.no_cia = cia_p
          AND ae.no_cta = cta_p
          AND ae.ano    = ano_p
          AND ae.mes    = mes_p
          AND mm.no_cia = ae.no_cia
          AND mm.no_cta = ae.no_cta
          AND mm.procedencia = ae.proce
          AND mm.tipo_doc    = ae.tipo_doc
          AND mm.no_docu     = ae.no_docu
          AND mm.conciliado  = 'N';
     CURSOR c_ajustes_esp_ref (ptipo_doc varchar2, pno_docu number, pproce varchar2) IS
       SELECT procedencia_r, tipo_doc_r, no_docu_r
         FROM arckcaed
        WHERE no_cia    = cia_p
          AND no_cta    = cta_p
          AND proce     = pproce
          AND tipo_doc  = ptipo_doc
          AND no_docu   = pno_docu;
   BEGIN
     FOR aju IN c_ajustes_esp LOOP
       FOR aju_ref IN c_ajustes_esp_ref(aju.tipo_doc, aju.no_docu, aju.proce) LOOP
         -- recorre referencias del ajuste y las concilia
         Pone_Conciliado (cia_p, cta_p, ano_p, mes_p,
                          aju_ref.procedencia_r, aju_ref.tipo_doc_r, aju_ref.no_docu_r);
         -- Guarda detalle de los documentos que concilian
         IF aju.proce = 'C' THEN
           INSERT INTO arckcc (NO_CIA, NO_CTA, PROCE, TIPO_DOC, NO_DOCU,
                       PROCEDENCIA_R, TIPO_DOC_R, NO_DOCU_R, ANO, MES)
                VALUES (cia_p, cta_p, aju.proce, aju.tipo_doc, aju.no_docu,
                       aju_ref.procedencia_r, aju_ref.tipo_doc_r, aju_ref.no_docu_r,
                       ano_p, mes_p);
         ELSE  -- aju.proce = 'B'
           INSERT INTO arckcc (NO_CIA, NO_CTA, PROCE, TIPO_DOC, NO_DOCU,
                       PROCEDENCIA_R, TIPO_DOC_R, NO_DOCU_R, ANO, MES)
                VALUES (cia_p, cta_p, aju_ref.procedencia_r, aju_ref.tipo_doc_r, aju_ref.no_docu_r,
                       aju.proce, aju.tipo_doc, aju.no_docu, ano_p, mes_p);
         END IF;
       END LOOP;
       -- pone como conciliado el documento principal
       Pone_Conciliado (cia_p, cta_p, ano_p, mes_p,
                        aju.proce, aju.tipo_doc, aju.no_docu);
     END LOOP;
   END;  --  Concilia_Ajustes_Especiales
   --
   PROCEDURE Calcula (p_cia  varchar2, p_cta   varchar2,  p_ano number,  p_mes number,
                      p_docu varchar2, p_proce varchar2,  p_total out number) IS
     -- Este procedimiento obtiene el monto total de movimientos de tipo p_tipo_doc
     -- de la compa?ia o el banco (parametro p_proc) para el a?o y mes dados como
     -- parametros
     --
     -- Obtiene monto total para un movimiento de los predefinidos (CK, TR, DP)
     CURSOR movs_ck_dp_tr IS
       SELECT SUM(NVL(monto,0))
         FROM arckmm
        WHERE no_cia      = p_cia
          AND no_cta      = p_cta
          AND procedencia = p_proce
          AND tipo_doc    = p_docu
          AND estado      != 'P'     -- que no este pendiente ni anulado en periodos menores o iguales al actual
          AND (estado     != 'A' or
               to_number(to_char(fecha_anulado,'RRRRMM')) > to_number(to_char(p_ano)||ltrim(to_char(p_mes,'00'))))
          AND mes         = p_mes
          AND ano         = p_ano;
     -- Obtiene monto total para documentos de tipo Debito o Credito (p_doc) que no
     -- sean los predefinidos.
     CURSOR otros_movs IS
       SELECT SUM(NVL(mm.monto,0))
         FROM arckmm mm, arcktd td
        WHERE mm.no_cia      = p_cia
          AND mm.no_cia      = td.no_cia
          AND mm.tipo_doc    = td.tipo_doc
          AND mm.no_cta      = p_cta
          AND mm.tipo_doc    NOT IN ('DP','CK','TR')
          AND td.tipo_mov    = p_docu
          AND mm.procedencia = p_proce
          AND mm.estado      NOT IN ('A', 'P') -- documento no debe estar anulado ni pendiente
          AND mm.ano         = p_ano
          AND mm.mes         = p_mes;
     v_encontro boolean;
   BEGIN
     IF p_docu IN ('CK','DP','TR') THEN
       OPEN  movs_ck_dp_tr;
       FETCH movs_ck_dp_tr INTO p_total;
       v_encontro := movs_ck_dp_tr%FOUND;
       CLOSE movs_ck_dp_tr;
     ELSE
       OPEN  otros_movs;
       FETCH otros_movs INTO p_total;
       v_encontro := otros_movs%FOUND;
       CLOSE otros_movs;
     END IF;
     p_total := NVL(p_total,0);
   END;  -- Calcula
   --
   PROCEDURE Obtiene_Saldos (cia_p varchar2, cta_p varchar2, ano_p number, mes_p number,
                    ptot_dep_c   out number, ptot_dep_b   out number, ptot_deb_c out number,
                    ptot_deb_b   out number, ptot_che_c   out number, ptot_che_b out number,
                    ptot_cre_c   out number, ptot_cre_b   out number,
                    psaldo_act_c out number, psaldo_ant_c out number, psaldo_ant_b out number) IS
     -- Carga los montos totales en depositos y cheques, asi como de otros
     -- movimientos de debitos y creditos tanto para la compa?ia como para
     -- el banco. Tambien carga los saldos de la compa?ia y el del banco.
     --
     -- Saldo anterior del banco y la compa?ia para el periodo anterior al
     -- que se va a conciliar
     CURSOR  saldos_bco_cia IS
       SELECT NVL(saldo_fin_b,0), NVL(saldo_fin_c,0)
         FROM arckhc
        WHERE no_cia = cia_p
          AND no_cta = cta_p
          AND ano    = DECODE(mes_p,1,ano_p-1,ano_p)
          AND mes    = DECODE(mes_p,1,12,mes_p-1);
     --
     -- Saldo de la compa?ia para el periodo que se va a conciliar
     CURSOR saldo_cia IS
       SELECT NVL(saldo_fin_c,0), nvl(che_anulmesant,0)
         FROM arckhc
        WHERE no_cia = cia_p
          AND no_cta = cta_p
          AND ano    = ano_p
          AND mes    = mes_p;
     --
     vChe_anul    number;
     vtot_aux     number;
     vencontro    boolean;
   BEGIN
     -- Obtiene montos por depositos, cheques y transferencias del banco
     Calcula(cia_p, cta_p, ano_p, mes_p, 'DP', 'B', ptot_dep_b);
     Calcula(cia_p, cta_p, ano_p, mes_p, 'CK', 'B', ptot_che_b);
     vtot_aux := NVL(ptot_che_b,0);
     Calcula(cia_p, cta_p, ano_p, mes_p, 'TR', 'B', ptot_che_b);
     ptot_che_b := NVL(ptot_che_b,0) + NVL(vtot_aux,0);
     -- Obtiene montos por depositos, cheques y transferencias de la compania
     Calcula(cia_p, cta_p, ano_p, mes_p, 'DP', 'C', ptot_dep_c);
     Calcula(cia_p, cta_p, ano_p, mes_p, 'CK', 'C', ptot_che_c);
     vtot_aux := NVL(ptot_che_c,0);
     Calcula(cia_p, cta_p, ano_p, mes_p, 'TR', 'C', ptot_che_c);
     ptot_che_c := NVL(ptot_che_c,0) + NVL(vtot_aux,0);
     -- Obtiene montos para otros movimientos de debito y credito que no
     -- sean Depositos, Cheques o Transferencias para la compa?ia y para el banco
     Calcula(cia_p, cta_p, ano_p, mes_p, 'D', 'C', ptot_deb_c);
     Calcula(cia_p, cta_p, ano_p, mes_p, 'D', 'B', ptot_deb_b);
     Calcula(cia_p, cta_p, ano_p, mes_p, 'C', 'C', ptot_cre_c);
     Calcula(cia_p, cta_p, ano_p, mes_p, 'C', 'B', ptot_cre_b);
     -- Saca el saldo del banco para reconstruccion de saldos
     psaldo_ant_c := 0;
     psaldo_ant_b := 0;
     OPEN  saldos_bco_cia;
     FETCH saldos_bco_cia INTO psaldo_ant_b, psaldo_ant_c;
     CLOSE saldos_bco_cia;
     --
     -- Obtiene el saldo de la compa?ia para el mes y a?o que se va a conciliar.
     -- Este saldo es el mismo que se acaba de calcular, cuando el mes y a?o a
     -- conciliar es anterior al de arranque del Sistema
     OPEN  saldo_cia;
     FETCH saldo_cia INTO psaldo_act_c, vChe_anul;
     CLOSE saldo_cia;

     pTot_che_c := nvl(pTot_che_c,0) - nvl(vChe_anul,0);

   END;  -- Obtiene_Saldos
   --
   --
   PROCEDURE Concilia_por_Monto (p_cia varchar2,  p_cta varchar2, p_ano number, p_mes number) IS
     -- Concilia documentos por su tipo y monto
     -- El procedimiento es el siguiente :
     -- 1. Para cada movimiento en la compa?ia junto con sus ajustes (ARCKRA) lo busca
     --    en el banco, por tipo de movimiento y monto.
     --    SI lo encuentra, concilia ambos y todos lo ajustes asociados
     --    SINO lo encuentra, lo inserta en ARCKCNC como EN TRANSITO
     -- 2. Recorre movimientos del banco sin conciliar y los inserta en ARCKCNC
     --    como PENDIENTES DE REGISTRO.
     -- Busca un documento en el banco con el ptipo_mov y pmonto_mov
     CURSOR c_busca_monto_tipo (ptipo_mov   varchar2, pmonto_mov number) IS
       SELECT mm.conciliado, mm.procedencia, mm.tipo_doc, mm.no_docu,  mm.rowid
         FROM arckmm mm, arcktd td
        WHERE mm.no_cia      = p_cia
          AND mm.no_cta      = p_cta
          AND mm.procedencia = 'B'
          AND mm.tipo_doc    = td.tipo_doc
          AND mm.conciliado  = 'N'
          AND mm.no_cia      = td.no_cia
          AND td.tipo_mov    = ptipo_mov
          AND mm.monto       = pmonto_mov
          AND mm.estado NOT IN ('A', 'P')
          AND TO_NUMBER(TO_CHAR(ano)||LPAD(TO_CHAR(mes),2,'0')) <=
              TO_NUMBER(TO_CHAR(p_ano)||LPAD(TO_CHAR(p_mes),2,'0'));
     -- Busca todos los movimientos del banco o de la compa?ia (segun parametro pproce)
     CURSOR c_movimientos_monto (pproce VARCHAR2) IS
       SELECT mm.procedencia,  mm.tipo_doc,  mm.no_docu, mm.no_fisico, mm.serie_fisico,
              nvl(mm.fecha_doc,mm.fecha) fecha,        mm.monto, mm.beneficiario, mm.ano,       mm.mes,
              td.tipo_mov,     mm.rowid
         FROM arckmm mm, arcktd td
        WHERE mm.no_cia       = p_cia
          AND td.no_cia       = mm.no_cia
          AND mm.no_cta       = p_cta
          AND mm.procedencia  = pproce
          AND mm.tipo_doc     = td.tipo_doc
          AND mm.conciliado   = 'N'
          AND mm.tipo_doc NOT IN ('AD', 'AC')  -- no toma en cuenta documentos de ajuste
          AND mm.estado       != 'P'    -- documento no es pendiente
          AND (mm.estado      != 'A'    -- documento no anulado
                 OR  TO_NUMBER(TO_CHAR(mm.fecha_anulado,'RRRRMM')) >
TO_NUMBER(TO_CHAR(p_ano)||LTRIM(TO_CHAR(p_mes,'00')))
               )
          AND TO_NUMBER(TO_CHAR(mm.ano)||LPAD(TO_CHAR(mm.mes),2,'0')) <=
              TO_NUMBER(TO_CHAR(p_ano)||LTRIM(TO_CHAR(p_mes,'00')))
          AND mm.tipo_doc IN (SELECT db.tipo_docc     -- documentos que concilian por tipo y monto
                                FROM arckdb db, arckmc mc
                               WHERE mc.no_cia = mm.no_cia
                                 AND mc.no_cta = mm.no_cta
                                 AND db.no_cia = mc.no_cia
                                 AND db.banco  = mc.banco
                                 AND db.forma_conciliacion = 2);
     -- Movimientos de ajuste de la compa?ia (pues no existen ajustes del banco)
     CURSOR c_ajustes (ptipo_doc varchar2, pno_docu  number) IS
       SELECT ra.tipo_doc, ra.no_docu, ra.monto_ajuste, ra.procedencia, ra.rowid
         FROM arckra ra, arckmm mm
        WHERE ra.no_cia      = p_cia
          AND ra.no_cta      = p_cta
          AND ra.procedencia = 'C'
          AND ra.tipo_refe   = ptipo_doc
          AND ra.no_refe     = pno_docu
          AND ra.ano_ajuste  = p_ano
          AND ra.mes_ajuste  = p_mes
          AND mm.no_cia      = ra.no_cia
          AND mm.no_cta      = ra.no_cta
          AND mm.procedencia = ra.procedencia
          AND mm.tipo_doc    = ra.tipo_doc
          AND mm.no_docu     = ra.no_docu
          AND mm.estado      NOT IN ('A', 'P');  -- documento de ajuste no debe estar anulado ni pendiente
     -- variables utilizadas
     vdife        arckcnc.difere%TYPE;
     vdetalle     arckcnc.mensaje%TYPE;
     vcod_msg     arckcnc.cod_msg%TYPE;
     vregistro    varchar2(30);
     vajustes     boolean;
     vtipo_a      arckmm.tipo_doc%TYPE;
     vproce_a     arckmm.procedencia%TYPE;
     vdocu_a      arckmm.no_docu%TYPE;
   BEGIN
     --
     -- Busca los movimientos que estan en la compania y no en el BCO
     FOR cia IN c_movimientos_monto('C') LOOP
       vcod_msg  := Null;
       vdetalle  := Null;
       vregistro := Null;
       vajustes  := FALSE;
       -- Busca ajustes para el documento de la compania
       FOR aju IN c_ajustes(cia.tipo_doc, cia.no_docu) LOOP
         IF (cia.tipo_mov = 'C' AND aju.tipo_doc = 'AD') OR
            (cia.tipo_mov = 'D' AND aju.tipo_doc = 'AC') THEN
           cia.monto := cia.monto - aju.monto_ajuste;
         ELSIF (cia.tipo_mov = 'D' AND aju.tipo_doc = 'AD') OR
               (cia.tipo_mov = 'C' AND aju.tipo_doc = 'AC') THEN
           cia.monto := cia.monto + aju.monto_ajuste;
         END IF;
         vajustes := TRUE;
       END LOOP;
       -- Busca algun movimiento en el banco con el mismo tipo de movimiento y monto
       FOR banco1 IN c_busca_monto_tipo(cia.tipo_mov, cia.monto) LOOP
         IF cia.tipo_doc = banco1.tipo_doc THEN
           -- Al primero que encuentre, guarda datos del documento encontrado y aborta el ciclo
           vregistro := banco1.rowid;
           vtipo_a   := banco1.tipo_doc;
           vproce_a  := banco1.procedencia;
           vdocu_a   := banco1.no_docu;
           EXIT;
         END IF;
       END LOOP;
       IF vregistro IS NOT NULL THEN
         -- Luego concilia el documento de la compania.
         Pone_Conciliado (p_cia, p_cta, p_ano, p_mes,
                          cia.procedencia, cia.tipo_doc, cia.no_docu);
         -- si encontro documento en el banco lo concilia
         Pone_Conciliado (p_cia, p_cta, p_ano, p_mes,
                          vproce_a, vtipo_a, vdocu_a);
         -- Guarda detalle de los documentos que concilian
         INSERT INTO arckcc (NO_CIA, NO_CTA, PROCE, TIPO_DOC, NO_DOCU,
                     PROCEDENCIA_R, TIPO_DOC_R, NO_DOCU_R, ANO, MES)
              VALUES (p_cia, p_cta, cia.procedencia, cia.tipo_doc, cia.no_docu,
                     vproce_a, vtipo_a, vdocu_a, p_ano, p_mes);
         -- Concilia todos los ajustes a ese documento de la compania
         IF vajustes THEN
           FOR aju IN c_ajustes(cia.tipo_doc, cia.no_docu) LOOP
             -- concilia cada ajuste
             Pone_Conciliado (p_cia, p_cta, p_ano, p_mes,
                              aju.procedencia, aju.tipo_doc, aju.no_docu);
             -- Guarda detalle de los ajustes que siervieron para conciliar el documento
             INSERT INTO arckcc (NO_CIA, NO_CTA, PROCE, TIPO_DOC, NO_DOCU,
                         PROCEDENCIA_R, TIPO_DOC_R, NO_DOCU_R, ANO, MES)
                  VALUES (p_cia, p_cta, aju.procedencia, aju.tipo_doc, aju.no_docu,
                         vproce_a, vtipo_a, vdocu_a, p_ano, p_mes);
           END LOOP;  -- conciliacion de los ajustes
         END IF;  -- si hubo ajustes al documento
       ELSE   -- si vregistro is null indica que no encontro algun doc. con el mismo monto
         vcod_msg := 'TR';
         vdetalle := 'TRANSITO';
         -- Almacena en tabla de documentos NO conciliados
         Guarda_No_Conciliado(p_cia, p_cta, 'C', cia.tipo_doc, cia.no_docu, cia.fecha,
                              cia.beneficiario, cia.monto, vcod_msg, vdetalle, 0, 0);
       END IF;
     END LOOP;   -- movs. cia.
     --
     -- Recorre movimientos del banco sin conciliar
     FOR bco IN c_movimientos_monto('B') LOOP
       --
       -- Si documento esta en el banco, indica que no concilio con ninguno de la
       -- compania, por lo que se debe registrar en la tabla arckcnc
       vcod_msg := 'PR';
       vdetalle := 'PENDIENTE REGISTRO';
       Guarda_No_Conciliado(p_cia, p_cta, bco.procedencia, bco.tipo_doc, bco.no_docu,
                            bco.fecha, bco.beneficiario, 0, vcod_msg, vdetalle, bco.monto, 0);
     END LOOP;
   EXCEPTION
     WHEN others THEN
       Genera_Error('CONCILIA_POR_MONTO : '||sqlerrm);
   END;  -- Concilia_por_Monto
   --
   PROCEDURE Concilia_por_documento (p_cia varchar2,  p_cta varchar2, p_ano number,  p_mes number) IS
     -- Procedimiento de Conciliacion segun tipo y numero de documento.
     -- El procedimiento es el siguiente :
     -- 1. Busca los movimientos de la compa?ia en el extracto bancario (por NO_FISICO, SERIE_FISICO)
     --    SI los encuentra
     --       SI los montos son iguales, concilia ambos
     --       SINO aplica al monto de la compania los montos de los ajustes
     --            SI con los ajustes el monto es el mismo, concilia ambos y concilia ajustes
     --            SINO inserta en ARCKCNC documento con diferencia de montos
     --    SINO los inserta en ARCKCNC con estado en TRANSITO.
     --
     -- 2. Busca los movimientos del extracto en la compa?ia que esten sin conciliar
     --    y los inserta en ARCKCNC con estado PENDIENTE DE REGISTRO.
     -- Cursor que obtiene todos los documentos del banco o de la compa?ia (p_proce)
     -- que tengan el indicador de conciliar por documento
     CURSOR c_movimientos (pproce VARCHAR2) IS
       SELECT mm.procedencia,  mm.tipo_doc,  mm.no_docu, mm.no_fisico, mm.serie_fisico,
              nvl(mm.fecha_doc,mm.fecha) fecha,  mm.monto, mm.beneficiario, mm.ano, mm.mes, mm.rowid, td.tipo_mov
         FROM arckmm mm, arcktd td
        WHERE mm.no_cia       = p_cia
          AND mm.no_cta       = p_cta
          AND mm.estado       != 'P'
          AND (mm.estado      != 'A'
           OR TO_NUMBER(TO_CHAR(mm.fecha_anulado,'RRRRMM')) >
              TO_NUMBER(replace(TO_CHAR(p_ano)||TO_CHAR(p_mes, '00'),' ')))
          AND mm.procedencia  = pproce
          AND mm.conciliado   = 'N'
          AND mm.tipo_doc NOT IN ('AD', 'AC')
          AND TO_NUMBER(TO_CHAR(mm.ano)||LPAD(TO_CHAR(mm.mes),2,'0')) <=
              TO_NUMBER(TO_CHAR(p_ano)||LPAD(TO_CHAR(p_mes),2,'0'))
          AND mm.no_cia      = td.no_cia
          AND mm.tipo_doc    = td.tipo_doc
          AND mm.tipo_doc IN (SELECT db.tipo_docc     -- documentos que concilian por tipo y numero
                                FROM arckdb db, arckmc mc
                               WHERE mc.no_cia = mm.no_cia
                                 AND mc.no_cta = mm.no_cta
                                 AND db.no_cia = mc.no_cia
                                 AND db.banco  = mc.banco
                                 AND db.forma_conciliacion = 1);
     -- Movimientos de Ajuste de la Compa?ia
     CURSOR c_ajustes (ptipo_doc varchar2,  pno_doc  number) IS
       SELECT ra.tipo_doc, ra.no_docu, ra.monto_ajuste, ra.procedencia, ra.rowid
         FROM arckra ra, arckmm mm
        WHERE ra.no_cia      = p_cia
          AND ra.no_cta      = p_cta
          AND ra.tipo_refe   = ptipo_doc
          AND ra.no_refe     = pno_doc
          AND ra.ano_ajuste  = p_ano
          AND ra.mes_ajuste  = p_mes
          AND mm.no_cia      = ra.no_cia
          AND mm.no_cta      = ra.no_cta
          AND mm.procedencia = ra.procedencia
          AND mm.tipo_doc    = ra.tipo_doc
          AND mm.no_docu     = ra.no_docu
          AND mm.estado      NOT IN ('A', 'P');  -- documento de ajuste no debe estar anulado ni pendiente
     -- Documento en el banco
     CURSOR doc_existe (ptipo_doc varchar2, pno_fisico varchar2, pserie_fisico varchar2,
                        pproce    varchar2, pdigitos   number) IS
       SELECT mm.procedencia, mm.tipo_doc, mm.no_docu, mm.monto, td.tipo_mov, mm.conciliado, mm.rowid
         FROM arckmm mm, arcktd td
        WHERE mm.no_cia      = p_cia
          AND mm.no_cta      = p_cta
          AND mm.procedencia = pproce
          AND mm.tipo_doc    = ptipo_doc
          -- Concilia los ultimos n digitos del numero fisico, esto segun el parametro de digitos
          -- a conciliar definido a nivel del banco. El default 0 indica que concilia todos.
          AND SUBSTR(mm.no_fisico, -(LEAST(LENGTH(mm.no_fisico), pdigitos))) =
              SUBSTR(pno_fisico, -(LEAST(LENGTH(pno_fisico), pdigitos)))
          AND mm.serie_fisico= pserie_fisico
          AND mm.conciliado  = 'N'
          AND mm.no_cia      = td.no_cia
          AND mm.tipo_doc    = td.tipo_doc
          AND mm.estado  NOT IN ('A', 'P')
          AND TO_NUMBER(TO_CHAR(ano)||LPAD(TO_CHAR(mes),2,'0')) <=
              TO_NUMBER(TO_CHAR(p_ano)||LPAD(TO_CHAR(p_mes),2,'0'));
     --
     CURSOR c_digitos_bco IS
       SELECT NVL(tb.digitos_conciliar,0)
         FROM arcktb tb, arckmc mc
        WHERE mc.no_cia = p_cia
          AND mc.no_cta = p_cta
          AND tb.banco  = mc.banco;
      -- variables utilizadas
      vdife        arckcnc.difere%TYPE;
      vdetalle     arckcnc.mensaje%TYPE;
      vcod_msg     arckcnc.cod_msg%TYPE;
      reg_mov      doc_existe%ROWTYPE;
      vencontro    boolean;
      vmonto_orig  arckmm.monto%TYPE;
      vdigitos     number;
   BEGIN
        OPEN  c_digitos_bco ;
        FETCH c_digitos_bco INTO vdigitos;
        vencontro := c_digitos_bco%FOUND;
        CLOSE c_digitos_bco ;
        IF NOT vencontro THEN
          Desconcilia_Saldo_Periodo(p_cia, p_cta, p_ano, p_mes);
             Genera_Error('El codigo de Banco asociado a la cuenta '||p_cta ||' no esta definido');
        END IF;
     --
     -- Recorre movimientos no conciliados de la Compania.
     FOR cia in c_movimientos('C') LOOP
       -- Busca el documento en el banco
       OPEN  doc_existe(cia.tipo_doc, cia.no_fisico, cia.serie_fisico,'B', vdigitos);
       FETCH doc_existe INTO reg_mov;
       vencontro := doc_existe%FOUND;
       CLOSE doc_existe;
       IF vencontro THEN
         IF (reg_mov.monto = cia.monto) THEN
             -- Si lo encuentra y el monto es el mismo, lo pone como conciliado en
             -- el la Compania y en el banco.
           Pone_Conciliado (p_cia, p_cta, p_ano, p_mes,
                            cia.procedencia, cia.tipo_doc, cia.no_docu);
           -- Concilia el documento del banco
           Pone_Conciliado (p_cia, p_cta, p_ano, p_mes,
                            reg_mov.procedencia, reg_mov.tipo_doc, reg_mov.no_docu);
           -- Guarda detalle de los documentos conciliados
           INSERT INTO arckcc (NO_CIA, NO_CTA, PROCE, TIPO_DOC, NO_DOCU,
                       PROCEDENCIA_R, TIPO_DOC_R, NO_DOCU_R, ANO, MES)
                VALUES (p_cia, p_cta, cia.procedencia, cia.tipo_doc, cia.no_docu,
                        reg_mov.procedencia, reg_mov.tipo_doc, reg_mov.no_docu,
                        p_ano, p_mes);
         ELSE   -- lo encontro en el banco pero con monto distinto
           -- Le aplica los ajustes al monto del doc. de la Cia para ver si suman el mismo
           -- monto pero antes, guarda el monto original del doc. de la compania
           vmonto_orig := NVL(cia.monto,0);
           -- Busca ajustes para el documento de la compania
           FOR aju IN c_ajustes(cia.tipo_doc, cia.no_docu) LOOP
             IF (cia.tipo_mov = 'C' AND aju.tipo_doc = 'AD') OR
                (cia.tipo_mov = 'D' AND aju.tipo_doc = 'AC') THEN
               cia.monto := NVL(cia.monto,0) - NVL(aju.monto_ajuste,0);
             ELSIF (cia.tipo_mov = 'D' AND aju.tipo_doc = 'AD') OR
                   (cia.tipo_mov = 'C' AND aju.tipo_doc = 'AC') THEN
               cia.monto := NVL(cia.monto,0) + NVL(aju.monto_ajuste,0);
             END IF;
           END LOOP;
           -- Verifica si el documento de la compania con los ajustes concilia con el
           -- monto del documento encontrado en el banco.
           IF reg_mov.monto = cia.monto THEN
             -- Concilia documento de la compania
             Pone_Conciliado (p_cia, p_cta, p_ano, p_mes,
                              cia.procedencia, cia.tipo_doc, cia.no_docu);
             -- Concilia documento del banco
             Pone_Conciliado (p_cia, p_cta, p_ano, p_mes,
                              reg_mov.procedencia, reg_mov.tipo_doc, reg_mov.no_docu);
             -- Guarda detalle de los documentos conciliados
             INSERT INTO arckcc (NO_CIA, NO_CTA, PROCE, TIPO_DOC, NO_DOCU,
                         PROCEDENCIA_R, TIPO_DOC_R, NO_DOCU_R, ANO, MES)
                  VALUES (p_cia, p_cta, cia.procedencia, cia.tipo_doc, cia.no_docu,
                         reg_mov.procedencia, reg_mov.tipo_doc, reg_mov.no_docu, p_ano, p_mes);
             -- Luego debe conciliar todos los documentos de ajuste aplicados
             FOR aju IN c_ajustes(cia.tipo_doc, cia.no_docu) LOOP
               Pone_Conciliado (p_cia, p_cta, p_ano, p_mes,
                                aju.procedencia, aju.tipo_doc, aju.no_docu);
               -- Guarda detalle del documento de ajuste que ayudo a conciliar el del banco
               INSERT INTO arckcc (NO_CIA, NO_CTA, PROCE, TIPO_DOC, NO_DOCU,
                           PROCEDENCIA_R, TIPO_DOC_R, NO_DOCU_R, ANO, MES)
                    VALUES (p_cia, p_cta, aju.procedencia, aju.tipo_doc, aju.no_docu,
                            reg_mov.procedencia, reg_mov.tipo_doc, reg_mov.no_docu, p_ano, p_mes);
             END LOOP;  -- Conciliacion de los ajustes
           ELSE  -- si aun con los ajustes los montos son distintos
             -- Recupera el monto original del movimiento (es decir descarta los ajustes)
             cia.monto := vmonto_orig;
             -- Lo inserta en ARCKCNC con estado DIFERENCIA
             vdife := NVL(cia.monto,0) - NVL(reg_mov.monto,0);
             vcod_msg := 'DIF';
               vdetalle := 'DIFERENCIA';
             UPDATE arckcnc
                SET monto_bco = reg_mov.monto,
                    Mensaje   = vdetalle,
                    cod_msg   = vcod_msg,
                    Difere    = vdife
              WHERE No_Cia    = p_cia
                AND no_cta    = p_cta
                AND tipo_doc  = cia.tipo_doc
                AND no_docu   = cia.no_docu
                AND monto     = cia.monto;
             IF sql%RowCount = 0 THEN
               Guarda_No_Conciliado(p_cia, p_cta, Null, cia.tipo_doc, cia.no_docu,
                                    cia.fecha, cia.beneficiario, cia.monto, vcod_msg, vdetalle,
                                    reg_mov.monto, vdife);
             END IF;  -- sql%rowcount = 0
           END IF;  -- monto cia + ajustes = monto bco.
         END IF;  -- regmov.monto = cia.monto
       ELSE  -- no encontro el documento de la Cia, en el extracto bancario
           -- Lo inserta como no conciliado con indicador de que esta en TRANSITO.
         vcod_msg := 'TR';
         vdetalle := 'TRANSITO';
         Guarda_No_Conciliado(p_cia, p_cta, 'C', cia.tipo_doc, cia.no_docu,
                              cia.fecha, cia.beneficiario, cia.monto, vcod_msg, vdetalle,
                              0, 0);
       END IF;  -- doc_existe%FOUND
     END LOOP;  -- documentos de la compa?ia
     FOR bco in c_movimientos('B') LOOP
       -- Recorre los movimientos del banco que quedaron sin conciliar y los inserta como
       -- PEDIENTES DE REGISTRAR en la compania.
       OPEN  doc_existe(bco.tipo_doc, bco.no_fisico, bco.serie_fisico,'C', vdigitos);
       FETCH doc_existe INTO reg_mov;
       IF doc_existe%NOTFOUND THEN
            -- solo inserta documentos del banco como no conciliados cuando no lo encontro
            -- en la compa?ia, pues si lo encuentra ya fue insertado por el LOOP anterior
            -- (movs de la Cia) ya sea como conciliado o como no conciliado con diferencia.
         vcod_msg := 'PR';
         vdetalle := 'PENDIENTE REGISTRO';
         Guarda_No_Conciliado(p_cia, p_cta, bco.procedencia, bco.tipo_doc, bco.no_docu,
                              bco.fecha, bco.beneficiario, 0, vcod_msg, vdetalle, bco.monto, 0);
       END IF;
       CLOSE doc_existe;
     END LOOP;  -- documentos del banco
   EXCEPTION
       WHEN others THEN
            Genera_Error('CONCILIA_POR_DOCUMENTO : '||sqlerrm);
   END;  -- Concilia_por_documento
   --
   --
   PROCEDURE Concilia_por_transaccion (p_cia varchar2,  p_cta varchar2, p_ano number,  p_mes number) IS
     -- Procedimiento de Conciliacion segun tipo y numero de documento.
     -- El procedimiento es el siguiente :
     -- 1. Busca los movimientos de la compa?ia en el extracto bancario (por NO_FISICO, SERIE_FISICO)
     --    SI los encuentra Concilia ambos
     --    SINO los inserta en ARCKCNC con estado en TRANSITO.
     --
     -- 2. Busca los movimientos del extracto en la compania que esten sin conciliar
     --    y los inserta en ARCKCNC con estado PENDIENTE DE REGISTRO.
     --
     -- Cursor que obtiene todos los documentos del banco o de la compa?ia (p_proce)
     CURSOR c_movimientos (pproce VARCHAR2) IS
       SELECT mm.procedencia,  mm.tipo_doc,  mm.no_docu, mm.no_fisico, mm.serie_fisico,
              nvl(mm.fecha_doc,mm.fecha) fecha,  mm.monto, mm.beneficiario, mm.ano, mm.mes, mm.rowid, td.tipo_mov
         FROM arckmm mm, arcktd td
        WHERE mm.no_cia       = p_cia
          AND mm.no_cta       = p_cta
          AND mm.estado       != 'P'
          AND (mm.estado      != 'A'
           OR TO_NUMBER(TO_CHAR(mm.fecha_anulado,'RRRRMM')) > TO_NUMBER(replace(TO_CHAR(p_ano)||TO_CHAR(p_mes, '00'),' ')))
          AND mm.procedencia  = pproce
          AND mm.conciliado   = 'N'
          AND mm.tipo_doc NOT IN ('AD', 'AC')
          AND TO_NUMBER(TO_CHAR(mm.ano)||LPAD(TO_CHAR(mm.mes),2,'0')) <= TO_NUMBER(TO_CHAR(p_ano)||LPAD(TO_CHAR(p_mes),2,'0'))
          AND mm.no_cia      = td.no_cia
          AND mm.tipo_doc    = td.tipo_doc
          AND mm.tipo_doc IN (SELECT db.tipo_docc     -- documentos que concilian por tipo y numero
                                FROM arckdb db, arckmc mc
                               WHERE mc.no_cia = mm.no_cia
                                 AND mc.no_cta = mm.no_cta
                                 AND db.no_cia = mc.no_cia
                                 AND db.banco  = mc.banco
                                 AND db.forma_conciliacion = 3);

     CURSOR doc_existe (ptipo_doc varchar2, pno_fisico varchar2, pserie_fisico varchar2,
                        pproce    varchar2, pno_refe   number) IS
       SELECT mm.procedencia, mm.tipo_doc, mm.no_docu, mm.monto, td.tipo_mov, mm.conciliado, mm.rowid
         FROM arckmm mm, arcktd td
        WHERE mm.no_cia      = p_cia
          AND mm.no_cta      = p_cta
          AND mm.procedencia = pproce
          AND mm.tipo_doc    = ptipo_doc
          AND mm.no_refe     = pno_refe;  -- Relacion de doc de Cia con Banco

     -- Documento en el banco
     CURSOR doc_no_conciliado (ptipo_doc varchar2, pno_fisico varchar2, pserie_fisico varchar2,
                               pproce    varchar2, pdigitos   number) IS
       SELECT mm.procedencia, mm.tipo_doc, mm.no_docu, mm.monto, td.tipo_mov, mm.conciliado, mm.rowid
         FROM arckmm mm, arcktd td
        WHERE mm.no_cia      = p_cia
          AND mm.no_cta      = p_cta
          AND mm.procedencia = pproce
          AND mm.tipo_doc    = ptipo_doc
          AND SUBSTR(mm.no_fisico, -(LEAST(LENGTH(mm.no_fisico), pdigitos))) = SUBSTR(pno_fisico, -(LEAST(LENGTH(pno_fisico), pdigitos)))
          AND mm.serie_fisico= pserie_fisico
          AND mm.conciliado  = 'N'
          AND mm.no_cia      = td.no_cia
          AND mm.tipo_doc    = td.tipo_doc
          AND mm.estado  NOT IN ('A', 'P')
          AND TO_NUMBER(TO_CHAR(ano)||LPAD(TO_CHAR(mes),2,'0')) <= TO_NUMBER(TO_CHAR(p_ano)||LPAD(TO_CHAR(p_mes),2,'0'));
     --
     CURSOR c_digitos_bco IS
       SELECT NVL(tb.digitos_conciliar,0)
         FROM arcktb tb, arckmc mc
        WHERE mc.no_cia = p_cia
          AND mc.no_cta = p_cta
          AND tb.banco  = mc.banco;

      -- variables utilizadas
      vdigitos     number;
      vencontro    boolean;
      reg_mov      doc_existe%ROWTYPE;
      vcod_msg     arckcnc.cod_msg%TYPE;
      vdetalle     arckcnc.mensaje%TYPE;

   BEGIN
        OPEN  c_digitos_bco ;
        FETCH c_digitos_bco INTO vdigitos;
        vencontro := c_digitos_bco%FOUND;
        CLOSE c_digitos_bco ;
        IF NOT vencontro THEN
          Desconcilia_Saldo_Periodo(p_cia, p_cta, p_ano, p_mes);
             Genera_Error('El codigo de Banco asociado a la cuenta '||p_cta ||' no esta definido');
        END IF;
     --
     FOR cia in c_movimientos('C') LOOP   -- Recorre movimientos no conciliados de la Compania
       -- Busca el documento en el banco
       OPEN  doc_existe(cia.tipo_doc, cia.no_fisico, cia.serie_fisico,'B', cia.no_docu);
       FETCH doc_existe INTO reg_mov;
       vencontro := doc_existe%FOUND;
       CLOSE doc_existe;
       IF vencontro THEN
             -- Si lo encuentra y el monto es el mismo, lo pone como conciliado en el la Compania y en el banco.
           Pone_Conciliado (p_cia, p_cta, p_ano, p_mes, cia.procedencia, cia.tipo_doc, cia.no_docu);
           -- Concilia el documento del banco
           Pone_Conciliado (p_cia, p_cta, p_ano, p_mes, reg_mov.procedencia, reg_mov.tipo_doc, reg_mov.no_docu);

           -- Guarda detalle de los documentos conciliados
           INSERT INTO arckcc (NO_CIA, NO_CTA, PROCE, TIPO_DOC, NO_DOCU,
                       PROCEDENCIA_R, TIPO_DOC_R, NO_DOCU_R, ANO, MES)
                VALUES (p_cia, p_cta, cia.procedencia, cia.tipo_doc, cia.no_docu,
                        reg_mov.procedencia, reg_mov.tipo_doc, reg_mov.no_docu, p_ano, p_mes);
       ELSE  -- no encontro el documento de la Cia, en el extracto bancario
               -- Lo inserta como no conciliado con indicador de que esta en TRANSITO.
         vcod_msg := 'TR';
         vdetalle := 'TRANSITO';
         Guarda_No_Conciliado(p_cia, p_cta, 'C', cia.tipo_doc, cia.no_docu, cia.fecha,
                              cia.beneficiario, cia.monto, vcod_msg, vdetalle, 0, 0);
       END IF;
     END LOOP;  -- documentos de la compania
     --
     FOR bco in c_movimientos('B') LOOP    -- Recorre movimientos no conciliados del Banco
       -- Recorre los movimientos del banco que quedaron sin conciliar y los inserta como
       -- PEDIENTES DE REGISTRAR en la compania.
       OPEN  doc_no_conciliado(bco.tipo_doc, bco.no_fisico, bco.serie_fisico,'C', vdigitos);
       FETCH doc_no_conciliado INTO reg_mov;
       IF doc_no_conciliado%NOTFOUND THEN
         vcod_msg := 'PR';
         vdetalle := 'PENDIENTE REGISTRO';
         Guarda_No_Conciliado(p_cia, p_cta, bco.procedencia, bco.tipo_doc, bco.no_docu,
                              bco.fecha, bco.beneficiario, 0, vcod_msg, vdetalle, bco.monto, 0);
       END IF;
       CLOSE doc_no_conciliado;
     END LOOP;
     --
   EXCEPTION
       WHEN others THEN
            Genera_Error('CONCILIA_POR_TRANSACCION : '||sqlerrm);
   END;  -- Concilia_por_transaccion
   --
   --
   PROCEDURE Inserta_Ajustes (cia_p varchar2, cta_p varchar2, ano_p number,  mes_p number) IS
     -- Inserta en ARCKCNC todos los documentos de ajustes registrados y que no esten
     -- conciliados.
   BEGIN
     --
     -- Debe insertarse todos los ajustes que se dieron en el mes para que sean
     -- reflejados en el reporte resumen de la conciliacion.
     INSERT INTO arckcnc  (no_cia,   no_cta,   procedencia, tipo_doc,
                 no_docu,   fecha,    monto,    beneficiario, monto_bco, difere,
                 cod_msg, mensaje )
          SELECT m.no_cia,  m.no_cta, m.procedencia,   m.tipo_doc,
                 m.no_docu, nvl(m.fecha_doc,m.fecha) fecha, m.monto,
DECODE(a.tipo_refe,Null,m.tipo_doc,a.tipo_refe)||'-'||
TO_CHAR(DECODE(a.no_refe,Null,m.no_docu,a.no_refe)), 0, 0,
                 'NA', 'NO APLICADO'
            FROM arckmm m,arckra a
           WHERE m.no_cia       = cia_p
             AND m.no_cta       = cta_p
             AND m.tipo_doc     IN ('AD','AC')
             AND m.ano*100+m.mes <= ano_p*100 + mes_p
             AND m.estado       NOT IN ('P', 'A')
             AND NVL(m.conciliado, 'N') = 'N'
             -- Outer Join de Movimientos y referencias
             AND m.no_cia       = a.no_cia     (+)
             AND m.no_cta       = a.no_cta     (+)
             AND m.procedencia  = a.procedencia(+)
             AND m.tipo_doc     = a.tipo_doc   (+)
             AND m.no_docu      = a.no_docu    (+);
   END;  -- Inserta Ajustes
   /*******[ PARTE: PUBLICA ] *************************
   * Declaracion de Procedimientos o funciones PUBLICAS
   *
   */
   --
   FUNCTION ultimo_error RETURN VARCHAR2 IS
   BEGIN
     RETURN(vMensaje_error);
   END ultimo_error;
   --
   --
   --
   PROCEDURE Concilia (cia_p           varchar2,  cta_p varchar2, ano_p number,  mes_p number,
                       ano_ini_p       number,    mes_ini_p number,   pactual_cia out number,
                       pactual_bco out number,    pbco_saldo number,
                       observ_p        varchar2) IS
     -- Efectua el calculo de la conciliacion bancaria. Primero efectua los ajustes
     -- especiales, luego realiza los ajustes de los documentos que concilian por tipo
     -- y numero y finalmente los documentos que concilian por tipo y monto
     --
     CURSOR c_ajustes_pend IS
       SELECT 'x'
         FROM arckmm
        WHERE no_cia      = cia_p
          AND no_cta      = cta_p
          AND procedencia = 'C'
          AND estado      = 'P'
          AND ano         = ano_p
          AND mes         = mes_p;
     -- variables utilizadas
     vtot_dep_c    number;  -- depositos compania
     vtot_dep_b    number;  -- depositos banco
     vtot_che_c    number;  -- cheques compania
     vtot_che_b    number;  -- cheques banco
     vtot_deb_c    number;  -- otros debitos compania
     vtot_deb_b    number;  -- otros debitos banco
     vtot_cre_c    number;  -- otros creditos compania
     vtot_cre_b    number;  -- otros creditos banco
     vsaldo_act_c  number;  -- saldo compania actual
     vsaldo_ant_c  number;  -- saldo compania periodo anterior
     vsaldo_ant_b  number;  -- saldo banco periodo anterior
     vsaldo_cia   number;
     vsaldo_bco   number;
     vtmp         varchar2(1);
     vencontro    boolean;

     Ln_dif       number; --- guarda diferencia

   BEGIN
     -- ----------------------------------------------------------------
     -- Borra registros generados por el proceso de conciliacion en las
     -- tablas temporales
     -- ----------------------------------------------------------------
     DELETE FROM arckcr
      WHERE no_cia = cia_p
        AND no_cta = cta_p;
     DELETE FROM arckcnc
      WHERE no_cia = cia_p
        AND no_cta = cta_p;
     OPEN  c_ajustes_pend;
     FETCH c_ajustes_pend INTO vtmp;
     vencontro := c_ajustes_pend%FOUND;
     CLOSE c_ajustes_pend;
     IF vencontro THEN
          Desconcilia_Saldo_Periodo(cia_p, cta_p, ano_p, mes_p);
          Genera_Error('Existen documentos pendientes de actualizar para el mes y a?o a conciliar.');
     END IF;
     --
     -- Siempre debe conciliar los ajustes especiales que se han registrado.
     Conciliacion.Concilia_Ajustes_Especiales (cia_p, cta_p, ano_p, mes_p) ;
     --
     -- Obtiene los saldos segun bancos y compa?ia
     Conciliacion.Obtiene_Saldos (cia_p,       cta_p, ano_p, mes_p,        vtot_dep_c, vtot_dep_b,
                     vtot_deb_c,  vtot_deb_b,  vtot_che_c, vtot_che_b,
                     vtot_cre_c,  vtot_cre_b,  vsaldo_act_c, vsaldo_ant_c, vsaldo_ant_b);
     vsaldo_cia  := NVL(vsaldo_act_c,0);
     pactual_cia := NVL(vsaldo_ant_c,0) - NVL(vtot_che_c,0) - NVL(vtot_cre_c,0) +
                         NVL(vtot_dep_c,0) + NVL(vtot_deb_c,0);
     vsaldo_bco  := NVL(vsaldo_ant_b,0) + NVL(vtot_dep_b,0) + NVL(vtot_deb_b,0) -
                    NVL(vtot_che_b,0)- NVL(vtot_cre_b,0);
     pactual_bco := NVL(vsaldo_bco,0);
     -- Valida que el saldo del banco digitado por el usuario sea igual
     -- al saldo obtenido del sistema.

     Ln_dif := pbco_saldo - pactual_bco; --- variable agregada por ANR 23/08/2010

     IF NVL(pbco_saldo,0) <> NVL(pactual_bco,0) THEN
          Desconcilia_Saldo_Periodo(cia_p, cta_p, ano_p, mes_p);
          Genera_Error('Saldo registrado distinto al calculado por diferencia '||Ln_dif||' S. ant: '||NVL(vsaldo_ant_b,0)||' Dp: '|| NVL(vtot_dep_b,0)||' Db: '||NVL(vtot_deb_b,0)||' Ch: '||NVL(vtot_che_b,0)||' Cr: '||NVL(vtot_cre_b,0));
     END IF;
       -- Actualiza saldo de la compania para el periodo actual, siempre y cuando no
       -- sea mayor o igual que el periodo de arranque del sistema.
       IF (ano_p*100)+mes_p < (ano_ini_p*100)+mes_ini_p  THEN
            UPDATE arckhc
               SET saldo_fin_c = NVL(vsaldo_ant_c,0) - NVL(vtot_che_c,0) - NVL(vtot_cre_c,0)
                               + NVL(vtot_dep_c,0) + NVL(vtot_deb_c,0)
             WHERE no_cia = cia_p
               AND no_cta = cta_p
               AND ano    = ano_p
               AND mes    = mes_p;
       END IF;

     -- Concilia primero por tipo y numero de documento
     Conciliacion.Concilia_por_documento(cia_p, cta_p, ano_p, mes_p);

     -- Concilia por montos y tipo de documento
     Conciliacion.Concilia_por_Monto(cia_p, cta_p, ano_p, mes_p);

     -- Concilia por montos y tipo de documento
     Conciliacion.Concilia_por_Transaccion(cia_p, cta_p, ano_p, mes_p);

     -- Inserta ajustes AD y AC en ARCKCONC
     Conciliacion.Inserta_ajustes(cia_p, cta_p, ano_p, mes_p);

     -- Inserta resumen de saldos en ARCKCR
     INSERT INTO arckcr (NO_CIA, NO_CTA, ACTUAL_CIA, ACTUAL_BCO, MONTO_CIA,
                 MONTO_BCO, SAL_ANT, SAL_ANT_B, DEP_C, DEP_B, CHE_C, CHE_B,
                 CRE_C, CRE_B, DEB_C, DEB_B,
                 OBSERV)
          VALUES (cia_p, cta_p, pactual_cia,
                 pactual_bco,pactual_cia,vsaldo_bco,
                 vsaldo_ant_c, vsaldo_ant_b, vtot_dep_c, vtot_dep_b, vtot_che_c,
                 vtot_che_b, vtot_cre_c, vtot_cre_b, vtot_deb_c, vtot_deb_b,
                 observ_p);
     --
     -- Graba saldo del banco luego de la conciliacion
     Conciliacion.Graba_HC(cia_p, cta_p, ano_p, mes_p, ano_ini_p, mes_ini_p, pactual_bco);
   END;  --  Concilia
   --
   PROCEDURE Cierra_Periodo (cia_p        varchar2, cta_p varchar2, ano_conc_p number,
                             mes_conc_p   number,   ano_proc_p number,   mes_proc_p number,
                             actual_cia_p number,   actual_bco_p number,   che_p      number,
                             depo_p       number,   t_bancos_p number,   t_libros_p number,
                             nct_p        number,   ndt_p number,   ncr_p      number,
                             ndb_p        number,   ckb_p number,   dpb_p      number,
                             ajdb_p       number,   ajcr_p number,   dife_p     number)  IS
     -- Efectua la aprobacion y cierre del periodo conciliado. Este proceso consiste
     -- en los siguientes pasos :
     -- 1. Validar que el saldo de la compa?ia para el siguiente periodo sea igual
     --    al saldo actual ± movimientos del mes siguiente.
     -- 2. Poner indicador de conciliado en ARCKHC en S para el periodo que se cierra.
     -- 3. Actualizar saldo de bancos en ARCKMC para el periodo que se cierra.
     -- 4. Actualizar en ARCKMC el ultimo ano y mes conciliado.
     -- 5. Guardar un historico (resumen y detalle) de la conciliacion.
     -- obtiene montos calculados en la conciliacion
     CURSOR c_con2 IS
       SELECT actual_cia, sal_ant_b,
              dep_b,  che_b,  cre_b,  deb_b,
              observ
         FROM arckcr
        WHERE no_cia = cia_p
          AND no_cta = cta_p;
     -- variables a utilizar
     vsaldo_ant_b   arckcr.sal_ant_b%TYPE := 0;
     vtot_dep_b     arckcr.dep_b%TYPE     := 0;
     vtot_deb_b     arckcr.deb_b%TYPE     := 0;
     vtot_che_b     arckcr.che_b%TYPE     := 0;
     vtot_cre_b     arckcr.cre_b%TYPE     := 0;
     vactual_cia    arckcr.actual_bco%TYPE:= 0;
     vobserv        arckcr.observ%TYPE;
   BEGIN
     IF (ano_conc_p*100)+mes_conc_p >= (ano_proc_p*100+mes_proc_p) THEN
          Genera_Error('NO puede cerrar mes igual o mayor al mes en proceso de la cuenta bancaria ');
     END IF;
     OPEN  c_con2 ;
     FETCH c_con2 INTO vactual_cia, vsaldo_ant_b, vtot_dep_b,
                       vtot_che_b, vtot_cre_b, vtot_deb_b,
                       vobserv;
     CLOSE c_con2 ;
     -- valida consistencia de saldo conciliado de la cia para el mes a cerrar con
     -- el saldo de arranque de la cia para el siguiente periodo.
     Conciliacion.Verifica_saldo_sigte(cia_p, cta_p, ano_conc_p, mes_conc_p, vactual_cia);
     -- Pone el periodo con estado de conciliado en sus saldos.
     UPDATE arckhc
        SET saldo_conciliado = 'S'
      WHERE no_cia = cia_p
        AND no_cta = cta_p
        AND ano    = ano_conc_p
        AND mes    = mes_conc_p;
     -- Actualiza ano y mes asi como montos en ARCKMC para el periodo que se cierra
     UPDATE arckmc
        SET ult_ano_concil    = ano_conc_p,
            ult_mes_concil    = mes_conc_p,
            sal_mes_ant_b = NVL(vsaldo_ant_b,0),
            dep_mes_b     = NVL(vtot_dep_b,0),
            deb_mes_b     = NVL(vtot_deb_b,0),
            che_mes_b     = NVL(vtot_che_b,0),
            cre_mes_b     = NVL(vtot_cre_b,0)
      WHERE no_cia        = cia_p
        AND no_cta        = cta_p;
     -- Llena el historico de la conciliacion (detalle)
     INSERT INTO arckcnch (NO_CIA, NO_CTA, ANO, MES, PROCEDENCIA, TIPO_DOC,
                 NO_DOCU, FECHA, BENEFICIARIO, MONTO, COD_MSG, MENSAJE,
                 MONTO_BCO, DIFERE)
          SELECT NO_CIA, NO_CTA, ano_conc_p, mes_conc_p, PROCEDENCIA, TIPO_DOC,
                 NO_DOCU, FECHA, BENEFICIARIO, MONTO, COD_MSG, MENSAJE,
                 MONTO_BCO, DIFERE
            FROM arckcnc
           WHERE no_cia = cia_p
             AND no_cta = cta_p;
     -- Llena el historico de la conciliacion (resumen)
     INSERT INTO arckcrh (NO_CIA, NO_CTA, ANO, MES, ACT_CIA,
                 ACT_BCO, CHE_TR, DEP_TR, SAL_BANCO, CRE_TR, DEB_TR,
                 CRE_PR, DEB_PR, CHE_PR, DEP_PR, ADEB, ACRE, DIFE, SAL_CIA,
                 OBSERV)
          VALUES (cia_p, cta_p, ano_conc_p, mes_conc_p, actual_cia_p,
                 actual_bco_p,  che_p, depo_p, t_bancos_p, nct_p, ndt_p,
                 ncr_p, ndb_p,  ckb_p, dpb_p,  ajdb_p,  ajcr_p, dife_p, t_libros_p,
                 vobserv );
     -- Borra tablas temporales de conciliacion
     DELETE arckcnc
      WHERE no_cia = cia_p
        AND no_cta = cta_p;
     DELETE arckcr
      WHERE no_cia = cia_p
        AND no_cta = cta_p;
   EXCEPTION
       WHEN others THEN
         Genera_Error('CIERRA_PERIODO : '||sqlerrm);
   END;  -- Cierra_Periodo
   --
   PROCEDURE Abre_Periodo (p_cia varchar2, p_cta varchar2, p_ano number, p_mes number) IS
     -- Reabre la conciliacion a partir del ano y mes dados hacia adelante.
     -- Este proceso implica lo siguiente :
     -- 1. Actualiza monto bco, cheques, depositos, debitos y creditos del banco en
     --    ARCKMC con los datos del historico ARCKHC.
     -- 2. Desconcilia todos los documentos conciliados en periodos posteriores
     --    o iguales al periodo dado por el usuario.
     -- 3. Pone como ultimo mes y a?o conciliado el periodo inmediatamente anterior
     --    al dado por el usuario.
     -- 4. Pone en 0 los saldos del banco en ARCKHC para periodos posteriores o iguales
     --    al dado. Tambien pone en N el indicador de saldo_conciliado.
     -- 5. Borra los historicos de conciliacion ARCKCRH, ARCKCNCH para los periodos
     --    posteriores o iguales al dado por el usuario.
     -- Obtiene documentos que fueron conciliados en periodos posteriores
     -- o iguales al que se desea reabrir.
     CURSOR c_movs_conciliados IS
       SELECT *
         FROM arckmm
        WHERE no_cia      = p_cia
          AND no_cta      = p_cta
          AND conciliado  = 'S'
          AND (ano_conciliado*100) + mes_conciliado >= (p_ano*100) + p_mes;
     -- Obtiene datos de la compania
     CURSOR c_cia IS
       SELECT ult_ano_concil, ult_mes_concil
         FROM arckmc
        WHERE no_cia   = p_cia
          AND no_cta   = p_cta;
     --
     CURSOR c_saldo_ant (pano number, pmes number) IS
       SELECT saldo_fin_b
         FROM arckhc
        WHERE no_cia = p_cia
          AND no_cta = p_cta
          AND ano    = pano
          AND mes    = pmes;
     vtmp        varchar2(1);
     vencontro   boolean;
     vano_ant    arckmm.ano%TYPE;
     vmes_ant    arckmm.mes%TYPE;
     vactual_bco arckcrh.act_bco%TYPE := 0;
     vobserv     arckcrh.observ%TYPE;
     vano_conc   arckmc.ult_ano_concil%TYPE;
     vmes_conc   arckmc.ult_mes_concil%TYPE;
   BEGIN
     -- obtiene datos de la compania para validar que no se trate de reabrir
     -- un periodo que aun no ha sido conciliado.
     OPEN  c_cia;
     FETCH c_cia INTO vano_conc, vmes_conc;
     CLOSE c_cia;
     IF (p_ano*100)+p_mes > (vano_conc*100)+vmes_conc THEN
         Genera_Error('No puede revertir un periodo aun no conciliado');
     END IF;
     -- Actualiza datos del banco en ARCKMC con base en los datos del historico
     -- de conciliacion anterior al periodo a partir del cual se esta reabriendo.
     -- Pone como ultimo a?o y mes conciliado el periodo anterior al que se esta
     -- desconciliando.
     IF p_mes = 1 THEN
         vano_ant := p_ano - 1;
         vmes_ant := 12;
     ELSE
         vano_ant := p_ano;
       vmes_ant := p_mes - 1;
     END IF;
     -- obtiene saldos del historico para la ultima conciliacion antes del
     -- periodo a partir del cual se reabrira la conciliacion
       OPEN  c_saldo_ant (vano_ant, vmes_ant) ;
        FETCH c_saldo_ant INTO vactual_bco;
        CLOSE c_saldo_ant ;
     UPDATE arckmc
        SET ult_ano_concil = vano_ant,
            ult_mes_concil = vmes_ant,
            sal_mes_ant_b  = NVL(vactual_bco,0),
            che_mes_b      = 0,
            dep_mes_b      = 0,
            deb_mes_b      = 0,
            cre_mes_b      = 0
      WHERE no_cia = p_cia
        AND no_cta = p_cta;
     FOR movs IN c_movs_conciliados LOOP
       -- Desconcilia cada uno de los documentos de la compa?ia que estan conciliados.
         Conciliacion.Desconcilia_documento(p_cia, p_cta,
                                            movs.procedencia, movs.tipo_doc, movs.no_docu);
     END LOOP;
     -- Anula saldos bancarios en ARCKHC
     UPDATE arckhc
        SET saldo_fin_b = 0,
            saldo_conciliado = 'N'
      WHERE no_cia = p_cia
        AND no_cta = p_cta
        AND (ano*100) + mes >= (p_ano*100) + p_mes;
     -- Borra historicos y temporales de conciliacion
      -- temporal de resumen
      DELETE FROM arckcr
      WHERE no_cia = p_cia
        AND no_cta = p_cta;
     -- temporal de no conciliados
     DELETE FROM arckcnc
      WHERE no_cia = p_cia
        AND no_cta = p_cta;
     -- resumen historico
     DELETE arckcrh
      WHERE no_cia = p_cia
        AND no_cta = p_cta
        AND (ano*100) + mes >= (p_ano*100) + p_mes;
     -- detalle historico
     DELETE arckcnch
      WHERE no_cia = p_cia
        AND no_cta = p_cta
        AND (ano*100) + mes >= (p_ano*100) + p_mes;
   EXCEPTION
     WHEN others THEN
            Genera_Error('ABRE_PERIODO : '||sqlerrm);
   END;  -- Abre_Periodo
   --
   PROCEDURE Desconcilia_documento (p_cia  varchar2, p_cta varchar2, p_proce varchar2,
                                    p_tipo varchar2, p_docu number) IS
     -- ---
     -- Desconcilia el documento pasado como parametro. Esto incluye cambiar indicador de
     -- conciliado, anular el a?o y mes de conciliacion (tanto para el documento como para
     -- el o los documentos contra los que concilio y luego borrar el historico de documentos
     -- conciliados.
     --
     -- Obtiene datos de la compania
     CURSOR c_cia IS
       SELECT ult_ano_concil, ult_mes_concil
         FROM arckmc
        WHERE no_cia   = p_cia
          AND no_cta   = p_cta;
     -- Obtiene a?o y mes en que se concilio el documento asi como su estado CONCILIADO
     CURSOR c_doc IS
       SELECT ano_conciliado, mes_conciliado, NVL(conciliado, 'N')
         FROM arckmm
        WHERE no_cia      = p_cia
          AND no_cta      = p_cta
          AND procedencia = p_proce
          AND tipo_doc    = p_tipo
          AND no_docu     = p_docu;
     -- obtiene los documentos del banco contra los cuales se concilio el de la
     -- compania (parametros)
     CURSOR c_arckcc_cia (pproc varchar2, ptipo varchar2, pdocu number) IS
       SELECT c.procedencia_r, c.tipo_doc_r, c.no_docu_r
         FROM arckcc c
        WHERE c.no_cia   = p_cia
          AND c.no_cta   = p_cta
          AND c.proce    = pproc
          AND c.tipo_doc = ptipo
          AND c.no_docu  = pdocu;
     -- obtiene el documento de la compania que referencio al documento del banco
     -- dado por los parametros p_proce, p_tipo, p_docu
     CURSOR c_arckcc_bco (pproc varchar2, ptipo varchar2, pdocu number) IS
       SELECT proce, tipo_doc, no_docu
         FROM arckcc
        WHERE no_cia        = p_cia
          AND no_cta        = p_cta
          AND procedencia_r = pproc
          AND tipo_doc_r    = ptipo
          AND no_docu_r     = pdocu;
     vencontro boolean  := FALSE;
     vregmov   c_arckcc_bco%ROWTYPE;
     vano_doc  arckmm.ano%TYPE;
     vmes_doc  arckmm.mes%TYPE;
     vano_conc arckmc.ult_ano_concil%TYPE;
     vmes_conc arckmc.ult_mes_concil%TYPE;
     vconc     arckmm.conciliado%TYPE;
   BEGIN
     -- obtiene datos del documento
     OPEN  c_doc ;
     FETCH c_doc INTO vano_doc, vmes_doc, vconc;
     CLOSE c_doc ;
     IF vconc = 'S' THEN -- solo hace el proceso cuando el documento realmente ya fue conciliado
       -- obtiene datos de la compania
       OPEN  c_cia;
       FETCH c_cia INTO vano_conc, vmes_conc;
       CLOSE c_cia;
       IF (vano_doc*100)+vmes_doc <= (vano_conc*100)+vmes_conc THEN
            Genera_Error('La transaccion '||p_tipo||'-'||p_docu||' no puede desconciliarse pues se concilio en un periodo cuya conciliacion ya se cerro');
       END IF;
       -- busca todos los documentos usados para conciliar el documento dado
       -- como parametro.
       FOR concil IN c_arckcc_cia (p_proce, p_tipo, p_docu) LOOP
         -- desconcilia cada uno de los documentos del banco con quien fue conciliado el original
         UPDATE arckmm
            SET conciliado     = 'N',
                ano_conciliado = Null,
                mes_conciliado = Null
          WHERE no_cia       = p_cia
            AND no_cta       = p_cta
            AND procedencia  = concil.procedencia_r
            AND tipo_doc     = concil.tipo_doc_r
            AND no_docu      = concil.no_docu_r;
         -- borra la referencia del detalle
         DELETE arckcc
          WHERE no_cia        = p_cia
            AND no_cta        = p_cta
            AND procedencia_r = concil.procedencia_r
            AND tipo_doc_r    = concil.tipo_doc_r
            AND no_docu_r     = concil.no_docu_r ;
         vencontro := TRUE;
       END LOOP;
       -- Pone el estado en NO conciliado para el documento original.
       UPDATE arckmm
          SET conciliado = 'N',
              ano_conciliado = Null,
              mes_conciliado = Null
        WHERE no_cia      = p_cia
          AND no_cta      = p_cta
          AND procedencia = p_proce
          AND tipo_doc    = p_tipo
          AND no_docu     = p_docu;
      IF NOT vencontro THEN
           -- Obtiene documento de la Cia o del banco banco que lo referencio
         OPEN  c_arckcc_bco (p_proce, p_tipo, p_docu);
         FETCH c_arckcc_bco INTO vregmov;
         CLOSE c_arckcc_bco ;
         FOR concil2 IN c_arckcc_cia (vregmov.proce, vregmov.tipo_doc, vregmov.no_docu) LOOP
           -- desconcilia cada uno de los documentos con quien fue conciliado el original
           UPDATE arckmm
              SET conciliado = 'N',
                  ano_conciliado = Null,
                  mes_conciliado = Null
            WHERE no_cia      = p_cia
              AND no_cta      = p_cta
              AND procedencia = concil2.procedencia_r
              AND tipo_doc    = concil2.tipo_doc_r
              AND no_docu     = concil2.no_docu_r;
           -- borra del historico de conciliacion el registro con el documento referenciado
           DELETE arckcc
            WHERE no_cia        = p_cia
              AND no_cta        = p_cta
              AND procedencia_r = concil2.procedencia_r
              AND tipo_doc_r    = concil2.tipo_doc_r
              AND no_docu_r     = concil2.no_docu_r ;
         END LOOP;
         -- Pone el estado en NO conciliado para el documento.
         UPDATE arckmm
            SET conciliado = 'N',
                ano_conciliado = Null,
                mes_conciliado = Null
          WHERE no_cia      = p_cia
            AND no_cta      = p_cta
            AND procedencia = vregmov.proce
            AND tipo_doc    = vregmov.tipo_doc
            AND no_docu     = vregmov.no_docu;
       END IF;
       -- Pone el saldo del mes como no conciliado, para forzar la ejecucion
       -- del proceso de conciliacion.
       Desconcilia_Saldo_Periodo(p_cia, p_cta, vano_doc, vmes_doc);
     END IF; -- si vconc = S
   EXCEPTION
     WHEN others THEN
          Genera_Error(sqlerrm);
   END;  -- Desconcilia documento
   --
   PROCEDURE Desconcilia_Saldo_Periodo (ciap varchar2, ctap varchar2, anop number, mesp number) IS
   -- Pone el indicador de saldo conciliado en N para el periodo dado. Esto
   -- para ser usado por procesos de Anulacion, Reversion, etc para obligar al
   -- usuario a volver a ejecutar el proceso de Conciliacion para ese periodo.
   -- Obtiene datos de la compania
   CURSOR c_cia IS
     SELECT ult_ano_concil, ult_mes_concil
       FROM arckmc
      WHERE no_cia   = ciap
        AND no_cta   = ctap;
   vult_ano_c arckmc.ult_ano_concil%TYPE;
   vult_mes_c arckmc.ult_mes_concil%TYPE;
   BEGIN
        -- valida que no trate de desconciliar saldos de un periodo cuya conciliacion
        -- ya fue cerrada.
        OPEN  c_cia;
        FETCH c_cia INTO vult_ano_c, vult_mes_c;
        CLOSE c_cia;
        IF (anop*100)+mesp <= (vult_ano_c*100)+vult_mes_c THEN
             Genera_Error('Se trata de desconciliar saldos para un periodo que ya fue conciliado');
        END IF;
        -- Inicializa saldo del banco y estado de saldos conciliados para el periodo
     UPDATE arckhc
        SET saldo_fin_b = 0,
            saldo_conciliado = 'N'
      WHERE no_cia = ciap
        AND no_cta = ctap
        AND (ano*100) + mes = (anop*100)+mesp;
   END;  -- Desconcilia_saldo_periodo
END;  -- Conciliacion BODY
/