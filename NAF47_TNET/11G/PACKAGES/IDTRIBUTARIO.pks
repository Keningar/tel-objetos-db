CREATE OR REPLACE PACKAGE            idtributario AS
    -- ---
    --   El paquete idtributario contiene una serie de procedimientos y
    -- funciones que facilitan el manejo del identificador tributario.
    --
    --   Posee funciones que permiten ocultar las caracteristicas
    -- del id. tributario, como por ejemplo, la longitud y el formato.
    --
    --
    -- ***
    --
    PROCEDURE inicializa;
    -- ---
    -- Inicializa el paquete, cargando informacion sobre el ID.tributario
    --
    PROCEDURE inicializa(pTipo in varchar2);
    --
    -- --
    -- Devuelve la mascara para utilizar en el forms
    FUNCTION  mascara(pTipo  in varchar2) RETURN VARCHAR2;
    --
    -- --
    -- Valida la Existencia del Tipo de Identificacion
    FUNCTION  Existe_Tipo(pTipo  in varchar2) RETURN BOOLEAN;
    --
    -- --
    -- Recibe un id.tributario y lo devuelve separados por "-"
    FUNCTION  formatea( pTipo           in varchar2,
                        pIdTributario   in varchar2) RETURN VARCHAR2;
    --
    -- --
    -- Devuelve la etiquitea para el id tributario
    FUNCTION etiqueta(pTipo      in varchar2) RETURN VARCHAR2;
    --
    -- --
    -- valida el digito verificador del id-tributario
    FUNCTION valida_digito( pTipo           in varchar2,
                            pId_Tributario  in varchar2
    ) RETURN BOOLEAN;
    --
    --
    -- --
    -- Devuelve laa descripcion del ultimo error ocurrido
    FUNCTION  ultimo_error RETURN VARCHAR2;
    --
    error           EXCEPTION;
    PRAGMA          EXCEPTION_INIT(error, -20021);
    kNum_error      NUMBER := -20021;
    -- ---
    -- Define restricciones de procedimientos y funciones
    --    WNDS = Writes No Database State
    --    RNDS = Reads  No Database State
    --    WNPS = Writes No Package State
    --    RNPS = Reads  No Package State
    PRAGMA RESTRICT_REFERENCES(inicializa,   WNDS);
    PRAGMA RESTRICT_REFERENCES(formatea,     WNDS);
    PRAGMA RESTRICT_REFERENCES(etiqueta,     WNDS);
END; -- idtributario;
/


CREATE OR REPLACE PACKAGE BODY            idtributario AS
    /*******[ PARTE: PRIVADA ]
    * Declaracion de Procedimientos o funciones PRIVADOS
    *
    */
    gtipo                   argetid.codigo%type;
    gnom_id_tributario      argetid.etiqueta%type;
    gformato_id             argetid.formato%type;
    gtiene_dv               argetid.Digito_Verif%type;
    gposicion_dv            number(2);
   	gmascara                varchar2(50);
    --
    vMensaje_error          VARCHAR2(160);
    --
    --
    PROCEDURE limpia_error IS
    BEGIN
      vMensaje_error := NULL;
    END;
    --
    --
    PROCEDURE genera_error(msj_error IN VARCHAR2)IS
    BEGIN
      vMensaje_error := msj_error;
      RAISE_APPLICATION_ERROR(kNum_error, msj_error);
    END;
    --
    -- --
    -- Valida si el paquete ya fue inicializado
    FUNCTION inicializado(pTipo  in varchar2) RETURN BOOLEAN IS
    BEGIN
      RETURN ( nvl(gTipo,'*NULO*') = pTipo);
    END inicializado;
    --
    -- ---
    -- Transforma
    FUNCTION transforma(pdato   IN VARCHAR2,
                        pmask   IN VARCHAR2
    ) RETURN VARCHAR2
    IS
      i          NUMBER(3);
      p          NUMBER(3);
      vcant      NUMBER(3);
      vlg_dato   NUMBER(3);
      vdato_aux  VARCHAR2(30);
      vdato_cnv  VARCHAR2(40);
    BEGIN
      vlg_dato   := nvl(length(pdato), 0);
      vdato_aux  := pdato;
      IF vlg_dato < 1 THEN
        vdato_cnv := vdato_aux;
      ELSE
        vdato_cnv := NULL;
        i         := 1;
        LOOP
          p  :=  instr(pmask, '-', i, 1);
          EXIT WHEN nvl(p,0) < 1;
          --
          vcant  := p - i;
          IF i <= 1 THEN
             vdato_cnv := substr(vdato_aux, 1, vcant);
          ELSE
             vdato_cnv := vdato_cnv ||'-'||substr(vdato_aux, 1, vcant);
          END IF;
          vdato_aux := substr(vdato_aux, vcant + 1, vlg_dato);
          i         := p + 1;
        END LOOP;

        IF vdato_aux IS NOT NULL THEN
        	IF vdato_cnv IS NULL THEN
            vdato_cnv := vdato_aux;
        	ELSE
            vdato_cnv := vdato_cnv ||'-'||vdato_aux;
          END IF;
        END IF;

      END IF;

      RETURN (vdato_cnv);
    END;
    --
    --
/*    FUNCTION CALCULA_DIGITO_V(pTipo IN VARCHAR2,
                              pidtributario IN VARCHAR2) RETURN varchar2
    IS
      --
      -- Calcula el digito verificador que corresponda al id enviado
      --
      p_suma     integer;
      p_factor   integer;
      p_elemento integer;
      p_largo    integer;
      p_resto    integer;
      p_digcal   char;
    BEGIN
      p_suma   := 0;
      p_resto  := 0;
      p_factor := 2;
      p_largo  := NVL(0, length(pIdTributario));
      LOOP
        p_elemento := to_number(substr(ltrim(pIdTributario), p_largo, 1));
        p_suma     := p_suma + (p_elemento * p_factor);
        p_largo    := p_largo - 1;
        EXIT WHEN p_largo < 1;
        p_factor := p_factor + 1;
        if p_factor > 7 then
           p_factor := 2;
        end if;
      END LOOP;
      p_resto := 11 - (p_suma - ( trunc(p_suma /11) * 11 ));
      IF p_resto = 10 THEN
         p_digcal := 'K';
      ELSIF p_resto = 11 THEN
         p_digcal := '0';
      ELSE
         p_digcal := to_char(p_resto);
      END IF;
      RETURN (p_digcal);
    EXCEPTION
      WHEN OTHERS THEN
         genera_error( 'Error en IDTRIBUTARIO.CALCULA_DIGITO_V ');
    END;
	*/
    FUNCTION CALCULA_DIGITO_V(
      pTipo         IN VARCHAR2,
      pidtributario IN VARCHAR2
    ) RETURN varchar2 IS
      --
      -- Calcula el digito verificador que corresponda al id enviado
      --
      Suma     NUMBER:= 0;
      Cociente NUMBER;
      Digito   NUMBER;
      contador NUMBER:= 1;
      Type  numeros_verificacion is table of number
            index by binary_integer;
      numeros numeros_verificacion;

    BEGIN
      numeros(9) :=  41;
      numeros(8) :=  37;
      numeros(7) :=  29;
      numeros(6) :=  23;
      numeros(5) :=  19;
      numeros(4) :=  17;
      numeros(3) :=  13;
      numeros(2) :=  7;
      numeros(1) :=  3;
      contador := 1;

      FOR num IN reverse 1..length(pIdtributario) LOOP

        Suma :=nvl( Suma + (TO_NUMBER(SUBSTR(pIdtributario,contador,1)) * numeros(num)),0);
        contador := contador +1;

      END LOOP;


      Cociente := FLOOR(MOD(Suma,11));
      IF Cociente = 0 THEN
        Digito := 0;
      ELSIF Cociente = 1 THEN
        Digito := 1;
      ELSE
        Digito := 11 - Cociente;
      END IF;
      RETURN(to_char(Digito));
    END;

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
	  --
    PROCEDURE inicializa IS
    BEGIN
      limpia_error;
      gTipo    := null;
      gmascara := null;
    END;
    --
    --
    PROCEDURE inicializa(pTipo in varchar2) IS
      CURSOR c_param is
         select etiqueta nom_id_tributario,
                formato,
                Digito_Verif
         from argetid
         where codigo = pTipo;
    BEGIN
      limpia_error;
      gTipo  := pTipo;
      Open c_param;
      Fetch c_param into gnom_id_tributario, gformato_id, gtiene_dv;
      IF c_Param%NOTFOUND THEN
         Close c_Param;
         Genera_Error('El tipo de identificacion no ha sido definido');
      ELSE
         Close c_Param;
      END IF;
      gmascara  := 'FM'||LTRIM( replace(gFormato_ID, '-', '"-"'),'FM');
	  IF gtiene_dv = 2 THEN
   	     gposicion_dv := Length(replace(gFormato_ID, '-', NULL));
	  ELSE
	     gposicion_dv := gtiene_dv;
      END IF;
    END inicializa;
    --
    --
    FUNCTION  mascara(pTipo in varchar2) RETURN VARCHAR2 IS
    BEGIN
      if not inicializado(pTipo) then
        inicializa(pTipo);
      end if;
      RETURN (gMascara);
    END mascara;
    --
    FUNCTION  Existe_Tipo(pTipo  in varchar2) RETURN BOOLEAN IS
      CURSOR c_param is
         select etiqueta nom_id_tributario,
                formato,
                Digito_Verif
         from argetid
         where codigo = pTipo;
    BEGIN
      OPEN c_param;
      FETCH c_param into gnom_id_tributario,
                         gformato_id,
                         gtiene_dv;
      IF c_Param%NOTFOUND THEN
         CLOSE c_param;
     RETURN(FALSE);
    ELSE
         CLOSE c_param;
     RETURN(TRUE);
    END IF;
    END;
    --
    FUNCTION  formatea( pTipo           in varchar2,
                        pIdTributario   in varchar2
    ) RETURN VARCHAR2
    IS
     vid_fmt  varchar2(30);
    BEGIN
      limpia_error;
      if not inicializado(pTipo) then
        inicializa(pTipo);
      end if;
      vid_fmt := transforma(pidtributario, gformato_id);
      RETURN( vid_fmt );
    END formatea;
    --
    --
    FUNCTION etiqueta(pTipo     IN varchar2 ) RETURN VARCHAR2
    IS
    BEGIN
      if not inicializado(pTipo) then
        inicializa(pTipo);
      end if;
      RETURN (gnom_id_tributario);
    END etiqueta;
    --
    --
    FUNCTION valida_digito(
      pTipo           in varchar2,
      pId_Tributario  in varchar2
    ) RETURN BOOLEAN  IS
      --
      vok           Boolean;
      vDig_reg      Varchar2(1);
      vDig_calc     Varchar2(1);
      vpos_dv       Number;
      vId_SinDigito ARGEMT.id_tributario%type;
    BEGIN
      limpia_error;
      if not inicializado(pTipo) then
         inicializa(pTipo);
      end if;
      vok     := true;
      IF gtiene_dv = 2 then
      -- El digito verificador esta al final
         vDig_reg  := substr(pId_Tributario, length(pId_Tributario), 1);
         vDig_calc := CALCULA_DIGITO_V(pTipo, substr(pId_Tributario,1,length(pId_Tributario)-1));
         vok       := (vDig_calc = vDig_reg);
      end if;
      IF gtiene_dv = 1 then
      -- El digito verificador esta al comienzo
         vDig_reg  := substr(pId_Tributario, 1, 1);
         vDig_calc := CALCULA_DIGITO_V(pTipo, substr(pId_Tributario,2,length(pId_Tributario)));
         vok       := (vDig_calc = vDig_reg);
      end if;
      IF gtiene_dv = 0 then
      -- No tiene digito verificador
         vok       := TRUE;
      end if;
      RETURN (vok);
    END;
    --
END;   -- BODY idtributario
/
