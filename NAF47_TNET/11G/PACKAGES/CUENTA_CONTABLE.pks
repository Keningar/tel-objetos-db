CREATE OR REPLACE PACKAGE            cuenta_contable AS
   -- ---
   -- El paquete cuenta contable contiene una serie de procedimientos y
   -- funciones que facilitan el manejo de las cuentas contables.
   --
   -- Posee funciones que validan la existencia de una cuenta contable,
   -- asi como tambien los permisos sobre la misma.
   --
   -- Ademas, posee funciones que permiten ocultar las caracteristicas
   -- de la cuenta contable, como por ejemplo, la longitud y el formato.
   -- ---
   -- TIPO Registro para devuelver informacion general sobre la cuenta
   -- una variable de este tipo es devuelta por la funcion trae_datos
   --
   TYPE datos_r IS RECORD(
     descripcion    arcgms.descri%type,
     clase          arcgms.clase%type,
     moneda         arcgms.moneda%type,
     acepta_cc      arcgms.acepta_cc%type,
     ind_mov        arcgms.ind_mov%type,
     ind_presup     arcgms.ind_presup%type,
     ind_tercero    arcgms.ind_tercero%type,
     ajustable      arcgms.ajustable%type,
     activa         arcgms.activa%type,
     padre          arcgms.padre%type,
     nivel          arcgms.nivel%type,
     usado_en       arcgms.usado_en%type,
     tipo           arcgms.tipo%type
   );
   -- ---
   --* ACEPTA_Ajuste
   --  Devuelve verdadero si la cuenta es ajustable por inflacion
   --
   --* ACEPTA_CC
   --  Devuelve verdadero si la cuenta acepta centro de costo
   --
   --* ACEPTA_MOV
   --  Devuelve verdadero si la cuenta acepta movimientos
   --
   --* ACEPTA_TERCERO
   --  Devuelve verdadero si la cuenta acepta definicion de tercero
   --
   --* ACEPTA_PRESUP
   --  Devuelve verdadero si la cuenta acepta presupuesto
   --
   --* CALCULA_PADRE:
   --  Realiza las operaciones adecuadas para determinar el codigo de
   --  la cuenta padre dada una cuenta (Para Mantenimiento de Cuentas)
   --
   --* DESCRIPCION
   --  Devuelve el nombre de una cuenta
   --
   --* EXISTE
   --  Busca la cuenta contable que recibe como parametro,
   --  validando primero si ya la tiene en memoria.
   --
   --* EXISTE_PADRE
   --  Busca la cuenta contable que recibe como parametro,
   --  validando primero si ya la tiene en memoria.
   --
   --* FORMATEA:
   --  Recibe una cuenta y devuelve un string  con niveles separados por "-"
   --
   --* GRABA_DUENO
   --  Actualiza el dueno de una cuenta contable,
   --
   --* INICIALIZA:
   --  Inicializa el paquete, cargando informacion sobre la cuenta contable
   --
   --* LLENA_NIVEL:
   --  Devuelve el valor del nivel de la cuenta contable relleno de ceros
   --  a la izquierda, de acuerdo al tama?o del nivel correspondiente
   --
   --* MASCARA:
   --  Devuelve la mascara para utilizar en el forms
   --
   --* NIVEL:
   --  Devuelve el nivel de la cuenta contable
   --
   --* ULTIMO_NIVEL:
   --  Devuelve true si la cuenta contable es de ultimo nivel, en caso contrario
   --  retorna false.
   --
   --* ES_ULTIMO_NIVEL:
   --  Devuelve "S" si la cuenta contable es de ultimo nivel, en caso contrario
   --  retorna "N".
   --
   --* MAXIMO_NIVEL:
   --  Devuelve la cantidad de niveles que tiene las cuentas contables de una compa?ia
   --
   --* NUEVA_HIJA:
   --  Devuelve una cuenta contable hija de la cuenta dada con el
   --  con el valor como siguiente nivel de la cuenta
   --
   --* PADRE:
   --  Devuelve la cuenta padre de la cuenta dada
   --
   --* PERMITE_REGISTRO_MANUAL
   --  Valida que la cuenta no este parametrizada (que no vaya a
   --  afectar un auxiliar) o este compartida (pueda ser utilizada
   --  en varios auxiliares)
   --
   --* PERMITIDA
   --  Valida el permiso de un auxiliar sobre una cuenta
   --
   --* PERMITE_MANEJO
   --  Valida el permiso de un auxiliar sobre cuentas, sin tomar en cuenta si
   --  la cuenta recibe movimientos
   --
   --* RELLENAD
   --  Recibe una cuenta y la rellena con 0's a la derecha
   --
   --* TRAE_DATOS
   --  Devuelve un registro con la informacion de la cuenta indicada.
   --  valida primero si ya la cuenta esta en memoria
   --
   --* TRIMD
   --  Devuelve la cuenta dada, luego de eliminar los ceros a la derecha
   --  de acuerdo al nivel de la cuenta
   --
   -- * PERIODO_INICIO
   --  Devuelve el ano y mes en que se registro la cuenta contable en el sistema
   PROCEDURE inicializa(pCia varchar2);
   --
   FUNCTION  mascara(pCia varchar2) RETURN VARCHAR2;
   --
   FUNCTION  formatea(pCia     varchar2,
                      pCuenta  varchar2) RETURN VARCHAR2;
   --
   FUNCTION TrimD(pCia varchar2, pCta Varchar2) RETURN VARCHAR2;
   --
   FUNCTION  rellenad(pCia     varchar2,
                      pCuenta  varchar2) RETURN VARCHAR2;
   --
   FUNCTION  llena_nivel(pCia         varchar2,
                         pValor_Nivel varchar2,
                         pNivelCta    Number,
                         pRelleno     Varchar2 DEFAULT '0') RETURN VARCHAR2;
   --
   FUNCTION  nueva_hija(pCia         varchar2,
                        pCuenta      varchar2,
                        pValor_Nivel varchar2) RETURN VARCHAR2;
   --
   FUNCTION  calcula_padre(pCia     varchar2,
                           pCuenta  varchar2) RETURN VARCHAR2;
   --
   FUNCTION  calcula_Nivel(pCia     varchar2,
                           pCuenta  varchar2) RETURN NUMBER;
   --
   FUNCTION  padre(pCia     varchar2,
                   pCuenta  varchar2) RETURN VARCHAR2;
   --
   FUNCTION  nivel(pCia     varchar2,
                   pCuenta  varchar2) RETURN NUMBER;
   --
   --
   FUNCTION ultimo_nivel(pCia       VARCHAR2,
                         pCuenta    VARCHAR2) RETURN BOOLEAN;
   --
   FUNCTION es_ultimo_nivel(pCia varchar2,
                            pCuenta varchar2) RETURN VARCHAR2;
   --
   FUNCTION maximo_nivel(pCia varchar2) RETURN NUMBER;
   --
   FUNCTION existe(pCia       varchar2,
                   pCuenta    varchar2) RETURN BOOLEAN;
   --
   FUNCTION existe_padre(pCia       varchar2,
                         pCuenta    varchar2) RETURN BOOLEAN;
   --
   FUNCTION trae_datos(pCia     varchar2,
                       pCuenta  varchar2) RETURN datos_r;
   --
   FUNCTION descripcion(pCia    varchar2,
                        pCuenta varchar2) RETURN VARCHAR2;
   --
   FUNCTION acepta_mov(pCia     varchar2,
                       pCuenta  varchar2 ) RETURN BOOLEAN;
   --
   FUNCTION acepta_presup(pCia     varchar2,
                          pCuenta  varchar2 ) RETURN BOOLEAN;
   --
   FUNCTION acepta_cc(pCia     varchar2,
                      pCuenta  varchar2 ) RETURN BOOLEAN;
   --
   FUNCTION acepta_ajuste(pCia     varchar2,
                          pCuenta  varchar2 ) RETURN BOOLEAN;
   --
   FUNCTION acepta_tercero(pCia     varchar2,
                           pCuenta  varchar2 ) RETURN BOOLEAN;
   --
   FUNCTION permitida(pCia    varchar2,
                      pCuenta varchar2,
                      pDueno  varchar2) RETURN BOOLEAN;
   --
   FUNCTION permite_registro_manual(pCia    varchar2,
                                    pCuenta varchar2,
                                    pDueno  varchar2) RETURN BOOLEAN;
   --
   FUNCTION permiso(pDueno      VARCHAR2,
                    ppermiso    VARCHAR2,
                    pusado_en   VARCHAR2,
                    pcompartido VARCHAR2,
                    pind_mov    VARCHAR2) RETURN VARCHAR2;
   --
   PROCEDURE graba_dueno(pcia      varchar2,
                         pcta_ant  varchar2,
                         pcta_nue  varchar2,
                         pdueno    varchar2);
   --
   PROCEDURE periodo_inicio( pCia         in varchar2,
	                           pCuenta      in varchar2,
	                           pAno_inicio  out number,
	                           pMes_inicio  out number);
   --
   --
   FUNCTION  ultimo_error RETURN VARCHAR2;
   FUNCTION  ultimo_mensaje RETURN VARCHAR2;
   --
   error           EXCEPTION;
   PRAGMA          EXCEPTION_INIT(error, -20020);
   kNum_error      NUMBER := -20020;
   -- Define restricciones de procedimientos y funciones
   --    WNDS = Writes No Database State
   --    RNDS = Reads  No Database State
   --    WNPS = Writes No Package State
   --    RNPS = Reads  No Package State
   PRAGMA RESTRICT_REFERENCES(inicializa, WNDS);
   PRAGMA RESTRICT_REFERENCES(formatea, WNDS);
   PRAGMA RESTRICT_REFERENCES(existe, WNDS);
   PRAGMA RESTRICT_REFERENCES(acepta_mov, WNDS);
   PRAGMA RESTRICT_REFERENCES(permitida, WNDS);
   PRAGMA RESTRICT_REFERENCES(permiso, WNDS, WNPS);
   PRAGMA RESTRICT_REFERENCES(calcula_padre, WNDS);
   PRAGMA RESTRICT_REFERENCES(calcula_nivel, WNDS);
   PRAGMA RESTRICT_REFERENCES(rellenad, WNDS);
   PRAGMA RESTRICT_REFERENCES(trimd, WNDS);
   PRAGMA RESTRICT_REFERENCES(descripcion, WNDS);
   --
END; -- cuenta_contable;
/


CREATE OR REPLACE PACKAGE BODY            cuenta_contable AS
   /*******[ PARTE: PRIVADA ]
   * Declaracion de Procedimientos o funciones PRIVADOS
   *
   */
   gno_cia           arcgmc.no_cia%type;
   gFormato          varchar2(30);      -- eje. '##-###-###'
   gMascara          varchar2(40);      -- eje. 'FM99"-"999"-"999'
   gCant_niveles     number(2);
   gLargo_cuenta     number(2);
   gTstamp           number;
   --
   CURSOR c_datos_cuenta(pno_cia varchar2,
                         pcuenta varchar2) IS
      SELECT no_cia,    cuenta,    descri descripcion,
            clase,      moneda,    usado_en,
            compartido, padre,     nivel,
            ind_mov,    activa,    ind_presup,
            tipo,
            nvl(ajustable, 'N')     ajustable,
            nvl(ind_tercero, 'N')   ind_tercero,
            nvl(acepta_cc,'N')      acepta_cc,
            nvl(permiso_con,'N')    permiso_con,
            nvl(permiso_che,'N')    permiso_che,
            nvl(permiso_cxp,'N')    permiso_cxp,
            nvl(permiso_pla,'N')    permiso_pla,
            nvl(permiso_afijo,'N')  permiso_afijo,
            nvl(permiso_inv,'N')    permiso_inv,
            nvl(permiso_aprov, 'N') permiso_aprov,
            nvl(permiso_fact,'N')   permiso_fact,
            nvl(permiso_cxc,'N')    permiso_cxc,
            nvl(permiso_cch,'N')    permiso_ch,
            nvl(permiso_tpm_com,'N')    permiso_tpm_com,
            nvl(permiso_tpm_inv,'N')    permiso_tpm_inv,
            nvl(permiso_tpm_c2p,'N')    permiso_tpm_c2p
      FROM arcgms
      WHERE no_cia  = pno_cia
        AND cuenta  = pcuenta;
   --
   TYPE def_nivel_r IS RECORD(
      inicio       number(2),      -- posicion en la que inicia el nivel
      largo        number(1),      -- cantidad de largo   del nivel
      largo_tot    number(2)       -- cantidad de largo   hasta este nivel
   );
   TYPE def_niveles_t IS TABLE OF def_nivel_r
     INDEX BY BINARY_INTEGER;
   RegCta           c_datos_cuenta%ROWTYPE;
   tdef_nivel       def_niveles_t;
   vMensaje_error   VARCHAR2(160);
   vMensaje         VARCHAR2(160);
   --
   PROCEDURE genera_error(msj_error IN VARCHAR2)IS
   BEGIN
      vMensaje_error := substr(msj_error, 1, 160);
      vMensaje       := vMensaje_Error;
      RAISE_APPLICATION_ERROR(kNum_error, msj_error);
   END;
   --
   PROCEDURE mensaje(msj IN VARCHAR2) IS
   BEGIN
      vMensaje  := msj;
   END;
   --
   -- --
   -- Valida si el paquete ya fue inicializado
   FUNCTION inicializado(pCia varchar2) RETURN BOOLEAN
   IS
   BEGIN
      RETURN ( nvl(gno_cia,'*NULO*') = pCia);
   END inicializado;
   --
   --
   FUNCTION permiso_modulo(pmodulo varchar2) RETURN VARCHAR2
   IS
      vPermiso     arcgms.permiso_con%type;
   BEGIN
     SELECT DECODE(pModulo, 'CG', regCta.permiso_con,
                            'CK', regCta.permiso_che,
                            'CP', regCta.permiso_cxp,
                            'PL', regCta.permiso_pla,
                            'AF', regCta.permiso_afijo,
                            'IN', regCta.permiso_INV,
                            'CO', regCta.permiso_aprov,
                            'IM', regCta.permiso_aprov,
                            'FA', regCta.permiso_fact,
                            'CC', regCta.permiso_cxc,
                            'IT', regCta.permiso_tpm_inv,  -- Inventario TPM
                            'CT', regCta.permiso_tpm_com,  -- Compras TPM
                            'C2', regCta.permiso_tpm_c2p,  -- C2P TPM
                            'FF', regCta.permiso_ch,   'N')
         INTO vPermiso
         FROM DUAL;
      RETURN (vpermiso);
   END;
   --
   --
   /*******[ PARTE: PUBLICA ]
   * Declaracion de Procedimientos o funciones PUBLICAS
   *
   */
   --
   FUNCTION ultimo_error RETURN VARCHAR2 IS
   BEGIN
     RETURN(vMensaje_error);
   END ultimo_error;
   --
   FUNCTION ultimo_mensaje RETURN VARCHAR2 IS
   BEGIN
     RETURN(vMensaje);
   END ultimo_mensaje;
   --
   PROCEDURE inicializa(pCia varchar2)
   IS
     i         number;
     j         number;
     niv       number;
     vlargo    number;
   Cursor c_Cia IS
      Select Formato_Cta
      From arcgmc
     Where No_cia = pCia;
   BEGIN
      Open c_cia;
      Fetch c_cia INTO gformato;
      IF c_Cia%NOTFOUND THEN
         Close c_Cia;
         Genera_Error('La compa?ia no ha sido registrada');
      ELSE
         Close c_Cia;
      END IF;
      --
      -- verifica que el formato solo tenga caracteres validos,
      --
      if length( translate(gformato, '#-', '') ) > 0 then
         genera_error('La definicion del formato de la cuenta contiene caracteres dif. a "#" o "-"');
      end if;
      -- Determina la definicion de cada nivel (inicio,largo, largo_tot)
      -- nota: Si formato es #-###-###, la cuenta es 1123105
      --       definicion de nivel 1 es (1, 1)   largo 1, largo_tot f1
      --            de nivel 2 es (2, 3)   largo 3, largo_tot 4
      --      de nivel 3 es (5, 3)   largo 3, largo_tot 7
      gCant_niveles := 0;
      gLargo_cuenta := 0;
      i     := 1;
      niv   := 0;
      LOOP
         j  :=  INSTR(gFormato||'-', '-', i, 1);
         EXIT WHEN nvl(j,0) < 1;
         --
         if j > i then
            niv      := nvl( niv, 0) + 1;
            vlargo   := nvl(j - i,0);
            tdef_nivel(niv).inicio     := nvl(gLargo_cuenta,0) + 1;
            tdef_nivel(niv).largo      := vlargo  ;
            tdef_nivel(niv).largo_tot  := nvl(gLargo_cuenta,0) + vlargo  ;
            --
            gCant_niveles  := niv;
            gLargo_cuenta  := tdef_nivel(niv).largo_tot     ;
         end if;
         i    := j + 1;
      END LOOP;
      --
      gno_cia    := pCia;
      gMascara   := 'FM'||replace(gformato,'#','9');
      gMascara   := replace(gMascara,'-','"-"');
   END inicializa;
   --
   --
   FUNCTION  mascara(pCia varchar2) RETURN VARCHAR2 IS
   BEGIN
     if not inicializado(pCia) then
        inicializa(pCia);
     end if;
     RETURN (gMascara);
   END mascara;
   --
   --
   FUNCTION  formatea(
       pCia       varchar2,
       pCuenta    varchar2
   ) RETURN VARCHAR2
   IS
     vCuenta  varchar2(20);
     vCta_fmt varchar2(30);
     n        number;
     vLgCta   number;
   BEGIN
     if not inicializado(pCia) then
        inicializa(pCia);
     end if;
     vCuenta  := pCuenta;
     vLgCta   := nvl(length(vCuenta),0);
     if  vLgCta between 1 and gLargo_cuenta then
        vCta_fmt := null;
        FOR n IN 1..gCant_niveles LOOP
          if n < 2 then
             vCta_fmt := substr(vcuenta, 1, tdef_nivel(n).largo  );
          else
             vCta_fmt := vCta_fmt ||'-'||
                         substr(vcuenta, tdef_nivel(n).inicio, tdef_nivel(n).largo);
          end if;
          IF tdef_nivel(n).largo_tot >= vLgCta THEN
            Exit;
          END IF;
        END LOOP;
     end if;
     RETURN( vCta_fmt );
   END formatea;
   --
   --
   --
   FUNCTION  rellenad(pCia varchar2, pCuenta    varchar2) RETURN VARCHAR2
   IS
     vcuenta   varchar2(30);
	 vsub_cta  varchar2(30);
     n         number;
   BEGIN
     if not inicializado(pCia) then
        inicializa(pCia);
     end if;
     RETURN ( RPAD(Ltrim(rtrim(pCuenta)), gLargo_cuenta, '0') );
   END rellenad;
   --
   --
   FUNCTION  llena_nivel(pCia         varchar2,
                         pValor_Nivel varchar2,
                         pNivelCta    Number,
             pRelleno     Varchar2 DEFAULT '0' ) RETURN VARCHAR2 IS
   BEGIN
     if not inicializado(pCia) THEN
        inicializa(pCia);
     end if;
     RETURN ( LPAD(Ltrim(rtrim(pValor_Nivel)), tdef_nivel(pNivelCta).largo, pRelleno) );

   END llena_nivel;
   --
   --
   FUNCTION  nueva_hija(pCia         varchar2,
                        pCuenta      varchar2,
                        pValor_Nivel varchar2) RETURN VARCHAR2 IS
      vHija         Arcgms.Cuenta%type;
      vLargo_Padre  Number(2);
      vSgte_Nivel   Arcgms.cuenta%type;
   BEGIN
      if not inicializado(pCia) THEN
         inicializa(pCia);
      end if;
      if Existe (pCia, pCuenta) then
         vLargo_Padre := tdef_nivel(RegCta.nivel).largo_tot;
         vHija        := Substr(RegCta.Cuenta, 1, vLargo_Padre);
         vSgte_Nivel  := Llena_Nivel(pCia, pValor_Nivel, RegCta.Nivel+1);
         vHija        := Rellenad(pCia, vHija||vSgte_Nivel);
         Return(vHija);
      ELSE
         Genera_Error('Error generando cuenta hija');
      end if;
   END;
   --
   FUNCTION  calcula_padre(pCia varchar2, pCuenta    varchar2) RETURN VARCHAR2
   IS
     vCuenta_Tmp   ARCGMS.cuenta%type;
     vCta_padre    ARCGMS.cuenta%type;
     vlargo_Cta    Number(2);
     niv           Number(2);
   BEGIN
     if not inicializado(pCia) then
        inicializa(pCia);
     end if;
     vCuenta_Tmp := RTRIM(pCuenta, '0');
     vLargo_Cta  := LENGTH(vCuenta_Tmp);
     niv         := 1;
     vCta_Padre := NULL;
     LOOP
       If vLargo_Cta <= tdef_nivel(1).largo_tot THEN
         Exit;
       ELSIF niv = gcant_niveles OR vLargo_Cta <= tdef_nivel(niv).largo_tot THEN
         Exit;
       END IF;
       vCta_Padre := substr(pCuenta, 1,tdef_nivel(niv).largo_tot);
       niv        := niv + 1;
     END LOOP;
     IF vCta_Padre IS NOT NULL THEN
        vCta_Padre := Rellenad(pCia, vCta_Padre);
     END IF;
     RETURN(vCta_Padre);
   END calcula_padre;
   --
   --
   FUNCTION  calcula_nivel(pCia varchar2, pCuenta    varchar2) RETURN NUMBER
   IS
     vCuenta_Tmp   ARCGMS.cuenta%type;
     vlargo_Cta    Number(2);
     vnivel        Number(2);
   BEGIN
     if not inicializado(pCia) then
        inicializa(pCia);
     end if;
     vCuenta_Tmp := RTRIM(pCuenta, '0');
     vLargo_Cta  := LENGTH(vCuenta_Tmp);
     vNivel      := 1;
     IF vLargo_Cta = 0 THEN
        genera_error('La cuenta es invalida, solo contiene caracteres "0" ');
     END IF;
     LOOP
       If vLargo_Cta <= tdef_nivel(1).largo_tot THEN
          Exit;
       ELSIF vNivel = gcant_niveles OR vLargo_Cta <= tdef_nivel(vNivel).largo_tot THEN
          Exit;
       END IF;
       vNivel  := vNivel + 1;
     END LOOP;
     RETURN(vNivel);
   END calcula_nivel;
   --
   --
   FUNCTION  TrimD(pCia varchar2, pCta Varchar2) RETURN VARCHAR2 IS
     vCta    ARCGMS.cuenta%type;
     vLgCta  Number(2);
   BEGIN
     if not inicializado(pCia) then
        inicializa(pCia);
     end if;
     IF NOT Existe(pCia, pCta) THEN
        Genera_error('La cuenta contable no se ha registrado');
     ELSE
        vLgCta  := tdef_nivel(RegCta.nivel).largo_tot;
        vCta    := SUBSTR(pCta, 1, vLgCta);
     END IF;
     RETURN(vCta);
   END TrimD;
   --
   --
   FUNCTION  padre(pCia varchar2, pCuenta    varchar2) RETURN VARCHAR2
   IS
   BEGIN
     if existe_padre(pCia, pCuenta) then
        RETURN ( RegCta.Padre);
     end if;
   END padre;
   --
   --
   FUNCTION  nivel(pCia varchar2, pCuenta    varchar2) RETURN NUMBER
   IS
   BEGIN
     if existe_padre(pCia, pCuenta) then
        RETURN ( RegCta.Nivel);
     end if;
   END Nivel;
   --
   --
   FUNCTION ultimo_nivel(pCia       VARCHAR2,
                         pCuenta    VARCHAR2
   ) RETURN BOOLEAN
   IS
      vValidacion  BOOLEAN;
      --
   BEGIN
      IF NOT inicializado(pCia) THEN
         inicializa(pCia);
      END IF;
      IF existe(pCia, pCuenta) THEN
         vValidacion := RegCta.nivel = gCant_niveles;
      ELSE
		  	genera_error('Error determinado si cuenta es de ultimo nivel');
      END IF;
      RETURN (vValidacion);
   END ultimo_nivel;


   --
   FUNCTION es_ultimo_nivel(pCia varchar2, pCuenta varchar2) RETURN VARCHAR2 IS

   BEGIN
      IF NOT inicializado(pCia) THEN
         inicializa(pCia);
      END IF;

      IF ultimo_nivel(pCia, pCuenta) THEN
	  RETURN('S');
      ELSE
	  RETURN('N');
      END IF;

    END es_ultimo_nivel;
   --
   --
   FUNCTION maximo_nivel(pCia varchar2) RETURN NUMBER IS

   BEGIN
      IF NOT inicializado(pCia) THEN
         inicializa(pCia);
      END IF;
	 RETURN(gCant_niveles);

   END maximo_nivel;
   --
   --
   FUNCTION existe(pCia varchar2, pCuenta varchar2) RETURN BOOLEAN
   IS
      vFound    BOOLEAN;
	  vtstamp   NUMBER;
   BEGIN
      vFound := FALSE;
      vtstamp := TO_CHAR(sysdate, 'SSSSS');
      if (gTstamp is null OR ABS(vtstamp - gTstamp) > 1) OR
      	 (RegCta.no_cia is null OR RegCta.cuenta is null) OR
         (RegCta.no_cia != pCia OR RegCta.cuenta != pCuenta) then
         RegCta.no_cia  := NULL;
         RegCta.cuenta  := NULL;
         OPEN  c_datos_cuenta(pCia, pCuenta);
         FETCH c_datos_cuenta INTO RegCta;
         vFound := c_datos_cuenta%FOUND;
         CLOSE c_datos_cuenta;
         gTstamp := TO_CHAR(sysdate, 'SSSSS');
      else
         vFound := (RegCta.no_cia = pCia AND RegCta.cuenta = pCuenta);
      end if;
      return (vFound);
   END existe;
   --
   --
   FUNCTION existe_padre(pCia varchar2, pCuenta varchar2) RETURN BOOLEAN
   IS
      vFound    BOOLEAN;
   BEGIN
      vFound  := existe(pCia, pCuenta);
      return (vFound);
   END existe_padre;
   --
   --
   FUNCTION trae_datos(
      pCia     varchar2,
      pCuenta  varchar2
   ) RETURN datos_r
   IS
      vreg_cta     datos_r;
   BEGIN
      if existe(pCia, pCuenta) then
         vreg_cta.descripcion := RegCta.descripcion;
         vreg_cta.clase       := RegCta.clase;
         vreg_cta.moneda      := RegCta.moneda;
         vreg_cta.acepta_cc   := RegCta.acepta_cc;
         vreg_cta.usado_en    := RegCta.usado_en;
         vreg_cta.activa      := RegCta.activa;
         vReg_cta.ind_mov     := RegCta.ind_mov;
         vReg_cta.padre       := RegCta.padre;
         vReg_cta.nivel       := RegCta.nivel;
         vReg_Cta.tipo        := RegCta.tipo;
         vreg_cta.ajustable   := regcta.ajustable;
         vreg_Cta.Ind_tercero := regcta.ind_tercero;
      else
         genera_error('La cuenta contable '||pCuenta||' no existe');
      end if;
      RETURN (vreg_cta);
   END trae_datos;
   --
   --
   FUNCTION descripcion(
     pCia     varchar2,
     pCuenta  varchar2
   ) RETURN VARCHAR2 IS
     vtof     BOOLEAN;
   BEGIN
      if pCuenta is null then
         return(' ');
      elsif existe(pCia, pCuenta) then
         return( RegCta.descripcion );
      else
         genera_error('La cuenta contable '||pCuenta||' no existe');
      end if;
   END descripcion;
   --
   --
   FUNCTION acepta_mov(
     pCia     varchar2,
     pCuenta  varchar2
   ) RETURN BOOLEAN IS
     vtof     BOOLEAN;
   BEGIN
      if pCuenta is null then
         return (FALSE);
      elsif existe(pCia, pCuenta) then
         return( (RegCta.ind_mov = 'S')and RegCta.activa = 'S' );
      else
         genera_error('La cuenta contable '||pCuenta||' no existe');
         return (FALSE);
      end if;
   END acepta_mov;
   --
   --
   FUNCTION acepta_presup(
     pCia     varchar2,
     pCuenta  varchar2
   ) RETURN BOOLEAN IS
     vtof     BOOLEAN;
   BEGIN
      if pCuenta is null then
         return (FALSE);
      elsif acepta_mov(pCia, pCuenta) then
         return( (RegCta.ind_presup = 'S') );
      else
         genera_error('La cuenta contable '||pCuenta ||' no recibe movimientos' );
         return (FALSE);
      end if;
   END acepta_presup;
   --
   --
   FUNCTION acepta_cc(
     pCia     varchar2,
     pCuenta  varchar2
   ) RETURN BOOLEAN IS
     vtof     BOOLEAN;
   BEGIN
      if pCuenta is null then
         return (FALSE);
      elsif acepta_mov(pCia, pCuenta) then
         return( (RegCta.acepta_cc = 'S') );
      else
         genera_error('La cuenta contable '||pCuenta ||' no recibe movimientos' );
         return (FALSE);
      end if;
   END acepta_cc;
   --
   --
   FUNCTION acepta_ajuste(
     pCia     varchar2,
     pCuenta  varchar2
   ) RETURN BOOLEAN IS
     vtof     BOOLEAN;
   BEGIN
      if pCuenta is null then
         return (FALSE);
      elsif acepta_mov(pCia, pCuenta) then
         return( (RegCta.ajustable = 'S') );
      else
         genera_error('La cuenta contable '||pCuenta ||' no recibe movimientos' );
         return (FALSE);
      end if;
   END acepta_ajuste;
   --
   --
   FUNCTION acepta_tercero(
     pCia     varchar2,
     pCuenta  varchar2
   ) RETURN BOOLEAN IS
     vtof     BOOLEAN;
   BEGIN
      if pCuenta is null then
         return (FALSE);
      elsif acepta_mov(pCia, pCuenta) then
         return( (RegCta.ind_tercero = 'S') );
      else
         genera_error('La cuenta contable '||pCuenta ||' no recibe movimientos' );
         return (FALSE);
      end if;
   END acepta_tercero;
   --
   --
   FUNCTION permitida(pCia       VARCHAR2,
                      pCuenta    VARCHAR2,
                      pDueno     VARCHAR2
   ) RETURN BOOLEAN
   IS
      vValidacion  BOOLEAN;
      vPermiso     ARCGMS.permiso_con%type;
      --
   BEGIN
      vValidacion  := FALSE;
      if acepta_mov (pCia, pCuenta) then
         vpermiso    := permiso_modulo(pDueno);
         vValidacion := (NVL(RegCta.Ind_mov, 'N') = 'S') AND
                        ((NVL(RegCta.usado_en,'NADIE') = pDueno) OR
                         (vPermiso = 'S' AND (RegCta.usado_en is NULL OR NVL(RegCta.compartido,'N') = 'S'))
                        );
      end if;
      return (vValidacion);
   END permitida;
   --
   --
   --
   FUNCTION permite_registro_manual(pCia       VARCHAR2,
                                    pCuenta    VARCHAR2,
                                    pDueno     VARCHAR2
   ) RETURN BOOLEAN
   IS
      vValidacion  BOOLEAN;
      vPermiso     ARCGMS.permiso_con%type;
      --
   BEGIN
      vValidacion  := FALSE;
      if acepta_mov(pCia, pCuenta) then
         vpermiso    := permiso_modulo(pDueno);
         vValidacion := ((RegCta.usado_en IS NULL) OR  NVL(RegCta.compartido,'N') = 'S')
                         AND vPermiso = 'S';
      end if;
      return (vValidacion);
   END permite_registro_manual;
   --
   --
   FUNCTION permiso(
     pDueno      VARCHAR2,
     ppermiso    VARCHAR2,
     pusado_en   VARCHAR2,
     pcompartido VARCHAR2,
     pind_mov    VARCHAR2
   ) RETURN VARCHAR2
   IS
      vValidacion  BOOLEAN;
   BEGIN
      vValidacion := (NVL(pInd_mov, 'N') = 'S') AND
                     ((NVL(pUsado_en,'NADIE') = pDueno) OR
                      (pPermiso = 'S' AND (pUsado_en is NULL OR NVL(pCompartido,'N') = 'S'))
                      );
      if vValidacion then
      	 return ('S');
      else
      	 return ('N');
      end if;
   END;
   --
   --
   --
   PROCEDURE graba_dueno(
      pcia      varchar2,
      pcta_ant  varchar2,
      pcta_nue  varchar2,
      pdueno    varchar2
   )IS
   BEGIN
      -- Limpia USADO_EN de la cuenta anterior
      IF pCta_ant IS NOT NULL AND (pCta_nue IS NULL OR pCta_ant != pCta_nue) THEN
         UPDATE arcgms
            SET usado_en = NULL
            WHERE no_cia    = pcia
              AND cuenta    = pcta_ant
              AND usado_en  = pdueno;
      END IF;
      -- Registra USADO_EN de la nueva cuenta
      IF pCta_nue IS NOT NULL AND (pCta_ant IS NULL OR pCta_ant != pCta_nue) THEN
         UPDATE arcgms
            SET usado_en      = pDueno/*,--Pedido por AAVILA segun YOVERI 13-08-2012
                compartido    = 'N',
                permiso_con   = 'N',
                permiso_che   = 'N',
                permiso_cxp   = 'N',
                permiso_inv   = 'N',
                permiso_fact  = 'N',
                permiso_cxc   = 'N',
                permiso_aprov = 'N',
                permiso_afijo = 'N',
                permiso_pla   = 'N',
                permiso_cch   = 'N',
                permiso_tpm_inv  = 'N',
                permiso_tpm_com  = 'N',
                permiso_tpm_c2p  = 'N'*/
            WHERE no_cia    = pcia
              AND cuenta    = pcta_nue
              AND usado_en  IS NULL;
      END IF;
   END graba_dueno;

   --
   --
   PROCEDURE periodo_inicio(
	   pCia        in varchar2,
	   pCuenta     in varchar2,
	   pAno_inicio out number,
	   pMes_inicio out number
   )
   IS
   vAno      arcghc.ano%type;
   vMes      arcghc.mes%type;
   vEncontro boolean;

   CURSOR c_periodo IS
      SELECT min(ano), min(mes)
        FROM arcghc
       WHERE no_cia = pCia
         AND cuenta = pCuenta;
   BEGIN
      OPEN c_periodo;
      FETCH c_periodo INTO vAno, vMes;
      vEncontro := c_periodo%found;
      CLOSE c_periodo;
      IF NOT vEncontro THEN
         Genera_Error('La cuenta no se ha definido en el historico de cuentas');
      END IF;
      pAno_inicio := vAno;
      pMes_inicio := vMes;
   END periodo_inicio;
   --
   --

END;   -- BODY cuenta_contable
/
