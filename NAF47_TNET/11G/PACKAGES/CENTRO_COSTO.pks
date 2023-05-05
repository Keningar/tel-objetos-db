CREATE OR REPLACE PACKAGE            centro_costo AS
   -- ---
   --   El paquete centro de costo contiene una serie de procedimientos y
   --   funciones que facilitan el manejo de los centros de costo.
   --
   --   Posee funciones que validan la existencia de un centro de costo.
   --
   --   Ademas, posee funciones que permiten ocultar las caracteristicas
   --   del centro de costo, como por ejemplo, la longitud y el formato.
   --
   --
   --
   --
   -- ---
   -- TIPO Registro para devuelver informacion general sobre el centro de costo
   -- una variable de este tipo es devuelta por la funcion trae_datos
   TYPE datos_r IS RECORD(
      descripcion    arcgceco.descrip_cc%type,
      encargado      arcgceco.encargado_cc%type,
      ultimo_nivel   arcgceco.ultimo_nivel%type
   );
   -- ---
   --* INICIALIZA:
   --  Inicializa el paquete, cargando informacion sobre el centro de costo
   --
   --* MASCARA:
   --  Devuelve la mascara para utilizar en el forms
   --
   --* FORMATEA:
   --  Recibe un centro de costo y devuelve un string  con niveles separados por "-"
   --
   --* RELLENAD
   --  Recibe un centro de costo y la rellena con 0's a la derecha
   --
   --* EXISTE
   --  Busca el centro de que recibe como parametro,
   --  validando primero si ya la tiene en memoria.
   --
   --* TRAE_DATOS
   --  Devuelve un registro con la informacion del centro de costo indicado.
   --  valida primero si ya el centro de costo esta en memoria
   --
   --* DESCRIPCION
   --  Devuelve el nombre de una cuenta
   --
   --* ACEPTA_MOV
   --  Valida si el centro de costo acepta movimientos
   --
   --
   --
   PROCEDURE inicializa(pCia varchar2);
   --
   FUNCTION  mascara(pCia varchar2) RETURN VARCHAR2;
   --
   FUNCTION  formatea(pCia     varchar2,
                      pCentro  varchar2) RETURN VARCHAR2;
   --
   FUNCTION  rellenad(pCia     varchar2,
                      pCentro  varchar2) RETURN VARCHAR2;
   --
   FUNCTION existe(pCia       varchar2,
                   pCentro    varchar2) RETURN BOOLEAN;
   --
   FUNCTION acepta_mov(pCia       varchar2,
                       pCentro    varchar2,
                       pCuenta    varchar2 ) RETURN BOOLEAN;
   --
   FUNCTION trae_datos(pCia     varchar2,
                       pCentro  varchar2) RETURN datos_r;
   --
   FUNCTION descripcion(pCia    varchar2,
                        pCentro varchar2) RETURN VARCHAR2;
   --
   --
   --
   FUNCTION  ultimo_error RETURN VARCHAR2;
   FUNCTION  ultimo_mensaje RETURN VARCHAR2;
   --
   error           EXCEPTION;
   PRAGMA          EXCEPTION_INIT(error, -20022);
   kNum_error      NUMBER := -20022;
   -- Define restricciones de procedimientos y funciones
   --    WNDS = Writes No Database State
   --    RNDS = Reads  No Database State
   --    WNPS = Writes No Package State
   --    RNPS = Reads  No Package State
   PRAGMA RESTRICT_REFERENCES(inicializa, WNDS);
   PRAGMA RESTRICT_REFERENCES(formatea, WNDS);
   PRAGMA RESTRICT_REFERENCES(existe, WNDS);
END; -- centro_costo;
/


CREATE OR REPLACE PACKAGE BODY            centro_costo AS
   /*******[ PARTE: PRIVADA ]
   * Declaracion de Procedimientos o funciones PRIVADOS
   *
   */
   gno_cia              arcgmc.no_cia%type;
   gMascara             varchar2(30);
   gLargo_centro        number(3);
   gcc_cualquier_nivel  arcgmc.cc_cualquier_nivel%type;
   gTStamp              Number;
   --
   CURSOR c_datos_centro(pno_cia varchar2, pcentro varchar2) IS
      SELECT no_cia,       centro
           , descrip_cc    descripcion
           , encargado_cc  encargado
           , ultimo_nivel
      FROM arcgceco
      WHERE no_cia  = pno_cia
        AND centro  = pcentro;
   --
   RegCC            c_datos_centro%ROWTYPE;
   vMensaje_error   VARCHAR2(160);
   vMensaje         VARCHAR2(160);
   --
   PROCEDURE genera_error(msj_error IN VARCHAR2)IS
   BEGIN
      vMensaje_error := msj_error;
      vMensaje       := msj_error;
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
   PROCEDURE inicializa(pCia varchar2) IS
     cursor c_param is
       select nvl(cc_cualquier_nivel,'S')
       from   arcgmc
       where  no_cia = pCia;
   BEGIN
      gno_cia       := pCia;
      gMascara      := 'FM999"-"999"-"999';
      gLargo_centro := 9;
      --
      -- Este Campo Tiene 'S', si el  centro de Costo acepta
      -- movimiento a cualquier nivel.
      open c_param;
      fetch c_param into gcc_cualquier_nivel;
      close c_param;
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
       pCentro    varchar2
   ) RETURN VARCHAR2
   IS
     vCentro  varchar2(20);
     vCto_fmt varchar2(30);
   BEGIN
     if not inicializado(pCia) then
        inicializa(pCia);
     end if;
     vCentro  := pCentro;
     if nvl(length(vCentro),0) between 1 and gLargo_centro then
        vCto_fmt := substr(vCentro, 1,3)||'-'||
                    substr(vCentro, 4,3)||'-'||
                    substr(vCentro, 7,3);
     end if;
     RETURN( vCto_fmt );
   END formatea;
   --
   --
   FUNCTION  rellenad(pCia varchar2, pCentro   varchar2) RETURN VARCHAR2
   IS
     vCto_fmt   varchar2(30);
   BEGIN
     if not inicializado(pCia) then
        inicializa(pCia);
     end if;
     RETURN ( RPAD(Ltrim(rtrim(pCentro)), gLargo_centro, '0') );
   END rellenad;
   --
   --
   FUNCTION existe(pCia varchar2, pCentro varchar2) RETURN BOOLEAN
   IS
      vFound    BOOLEAN;
	  vtstamp   NUMBER;
   BEGIN
      if not inicializado(pCia) then
         inicializa(pCia);
      end if;
      vFound  := FALSE;
      vtstamp := TO_CHAR(sysdate, 'SSSSS');
      if (gTstamp is null OR ABS(vtstamp - gTstamp) > 2) OR
      	 (RegCC.no_cia is null OR RegCC.centro is null) OR
         (RegCC.no_cia != pCia OR RegCC.centro != pCentro) then
         RegCC.no_cia  := NULL;
         RegCC.centro  := NULL;
         --
         OPEN c_datos_centro(pCia, pCentro);
         FETCH c_datos_centro INTO RegCC;
         vfound := c_datos_centro%FOUND;
         CLOSE c_datos_centro;
         gTstamp := TO_CHAR(sysdate, 'SSSSS');
      else
         vFound := TRUE;
      end if;
      return ( vFound );
   END existe;
   --
   --
   FUNCTION acepta_mov(pCia varchar2, pCentro varchar2, pCuenta varchar2) RETURN BOOLEAN
   IS
      vacepta_mov  BOOLEAN;
      -- NOTA: La cuenta puede ser utilizada en futuras versiones y puede venir null
      -- Por ejemplo, cuando se parametriza cuando no hay cuentas contables
   BEGIN
      vacepta_mov := FALSE;
      if existe(pCia, pCentro) then
         if gcc_cualquier_nivel = 'S' then
            -- acepta movim. a cualquier nivel
            vacepta_mov  := TRUE;
         else
            -- acepta movimiento solo al ultimo nivel. Debe validar que si
            -- la cuenta acepta centro pero este es el default, no permitir
            -- la transaccion, pues descuadraria el catalogo por centro.
            if pCuenta is null then
              vacepta_mov  := ((RegCC.ultimo_nivel = 'S') and
                               (pCentro != centro_costo.rellenad(pCia, '0')));
            elsif cuenta_contable.acepta_cc(pCia, pCuenta) and
	            pCentro = centro_costo.rellenad(pCia, '0') then
              vacepta_mov  := FALSE;
            elsif cuenta_contable.acepta_cc(pCia, pCuenta) then
              vacepta_mov  := (RegCC.ultimo_nivel = 'S');
            elsif not cuenta_contable.acepta_cc(pCia, pCuenta) then
              vacepta_mov  := (pCentro = centro_costo.rellenad(pCia, '0'));
            end if;
         end if;
      end if;
      return ( vacepta_mov  );
   END acepta_mov;
   --
   --
   FUNCTION trae_datos(
      pCia     varchar2,
      pCentro  varchar2
   ) RETURN datos_r
   IS
      vreg_cta     datos_r;
   BEGIN
      if existe(pCia, pCentro) then
         vreg_cta.descripcion := RegCC.descripcion;
         vreg_cta.encargado   := RegCC.encargado;
         vreg_cta.ultimo_nivel  := RegCC.ultimo_nivel;
      else
         genera_error('NO EXISTE CENTRO DE COSTO: '||pCentro);
      end if;
      RETURN (vreg_cta);
   END trae_datos;
   --
   --
   FUNCTION descripcion(
     pCia     varchar2,
     pCentro  varchar2
   ) RETURN VARCHAR2 IS
     vtof     BOOLEAN;
   BEGIN
      if pCentro is null then
         return(' ');
      elsif existe(pCia, pCentro) then
         return( RegCC.descripcion );
      else
         return( '!! CENTRO DE COSTO NO ENCONTRADO' );
      end if;
   END descripcion;
   --
   --
END;   -- BODY centro_costo
/
