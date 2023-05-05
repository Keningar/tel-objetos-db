CREATE OR REPLACE PACKAGE            tercero AS
   -- ---
   -- El paquete tercer contiene una serie de procedimientos y
   -- funciones que facilitan el manejo de los terceros.
   --
   --
   -- ---
   -- TIPO Registro para devuelver informacion general sobre el centro de costo
   -- una variable de este tipo es devuelta por la funcion trae_datos
   --
   TYPE datos_r IS RECORD(
      codigo_tercero         argemt.codigo_tercero%type,
      tipo_identificacion    argemt.tipo_identificacion%type,
      id_tributario          argemt.id_tributario%type,
      razon_social           argemt.razon_social%type,
      condicion_tributaria   argemt.condicion_tributaria%type,
      sector                 argemt.sector%type,
      actividad              argemt.actividad%type,
      pais                   argemt.pais%type,
      provincia              argemt.provincia%type,
      canton                 argemt.canton%type,
      distrito               argemt.distrito%type,
      barrio                 argemt.barrio%type,
      direccion              argemt.direccion%type,
      telefono               argemt.telefono%type,
      fax                    argemt.fax%type
   );
   --
   --* DESCRIPCION
   --  Devuelve el nombre de un tercero
   --
   --* EXISTE
   --  Busca la tercero que recibe como parametro, validando primero si ya
   --  la tiene en memoria.
   --
   --* TRAE_DATOS
   --  Devuelve un registro con la informacion del tercero indicada.
   --  valida primero si la informacion ya esta en memoria
   --
   FUNCTION descripcion(pCodigo varchar2) RETURN VARCHAR2;
   --
   FUNCTION identificacion(pCodigo varchar2) RETURN VARCHAR2;
   --
   FUNCTION tipo_id(pCodigo varchar2) RETURN VARCHAR2;
   --
   FUNCTION existe(pCodigo varchar2) RETURN BOOLEAN;
   --
   FUNCTION trae_datos(pCodigo varchar2) RETURN datos_r;
   --
   FUNCTION ultimo_error RETURN VARCHAR2;
   --
   error           EXCEPTION;
   PRAGMA          EXCEPTION_INIT(error, -20024);
   kNum_error      NUMBER := -20024;
   -- Define restricciones de procedimientos y funciones
   --    WNDS = Writes No Database State
   --    RNDS = Reads  No Database State
   --    WNPS = Writes No Package State
   --    RNPS = Reads  No Package State
   --
   PRAGMA RESTRICT_REFERENCES(existe, WNDS);
   PRAGMA RESTRICT_REFERENCES(tipo_id, WNDS);
   PRAGMA RESTRICT_REFERENCES(identificacion, WNDS);
   PRAGMA RESTRICT_REFERENCES(descripcion, WNDS);
END; -- tercero;
/


CREATE OR REPLACE PACKAGE BODY            tercero AS
   /*******[ PARTE: PRIVADA ]
   * Declaracion de Procedimientos o funciones PRIVADOS
   *
   */
   gcodigo          argemt.codigo_tercero%type;
   RegTercero       datos_r;
   vMensaje_error   VARCHAR2(160);
   vMensaje         VARCHAR2(160);
   --
   Cursor c_Datos_Tercero (pcod_3ro Varchar2) IS
      SELECT codigo_tercero,
             tipo_identificacion, id_tributario,
             razon_social, condicion_tributaria,
             sector, actividad,
             pais, provincia, canton, distrito, barrio,
             direccion, telefono, fax
      From argemt
      Where codigo_tercero = pcod_3ro;
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
   FUNCTION inicializado(pCodigo varchar2) RETURN BOOLEAN
   IS
   BEGIN
      RETURN ( nvl(gcodigo,'*NULO*') = pCodigo);
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
   --
   --
   FUNCTION existe(pCodigo varchar2) RETURN BOOLEAN IS
      vexiste  boolean;
      vr       datos_r;
   BEGIN
      vExiste := FALSE;
      if (RegTercero.codigo_tercero is null OR
         RegTercero.codigo_tercero != pCodigo) then
         --
         Open c_Datos_Tercero(pCodigo);
         Fetch c_Datos_Tercero INTO vr.codigo_tercero,
                                    vr.tipo_identificacion,
                                    vr.id_tributario,
                                    vr.razon_social,
                                    vr.condicion_tributaria,
                                    vr.sector,
                                    vr.actividad,
                                    vr.pais,
                                    vr.provincia,
                                    vr.canton,
                                    vr.distrito,
                                    vr.barrio,
                                    vr.direccion,
                                    vr.telefono,
                                    vr.fax;
         vexiste    := c_datos_tercero%found;
         Close c_Datos_Tercero;
         RegTercero := vr;
      end if;
      vExiste := (RegTercero.codigo_tercero IS NOT NULL AND
	              RegTercero.codigo_tercero = pCodigo);
      return (vExiste);
   END existe;
   --
   --
   FUNCTION trae_datos(pCodigo varchar2) RETURN datos_r IS
   BEGIN
      if existe(pCodigo) then
         return( RegTercero );
      else
         genera_error('No existe tercero: '||pCodigo);
      end if;
   END trae_datos;
   --
   --
   FUNCTION descripcion(pCodigo varchar2) RETURN VARCHAR2 IS
   BEGIN
      if pCodigo is null then
         return(' ');
      elsif existe(pCodigo) then
         return( RegTercero.razon_social );
      else
         Genera_Error( 'No existe tercero '|| pCodigo );
      end if;
   END descripcion;
   --
   --
   FUNCTION identificacion(pCodigo varchar2) RETURN VARCHAR2
   IS
   BEGIN
      if pCodigo is null then
         return(' ');
      elsif existe(pCodigo) then
         return( RegTercero.id_tributario );
      else
         Genera_Error( 'No existe tercero '|| pCodigo );
      end if;
   END identificacion;
   --
   --
   FUNCTION Tipo_Id(pCodigo varchar2) RETURN VARCHAR2
   IS
   BEGIN
      if pCodigo is null then
         return(' ');
      elsif existe(pCodigo) then
         return( RegTercero.tipo_identificacion );
      else
         Genera_Error( 'No existe tercero '|| pCodigo );
      end if;
   END tipo_id;
   --
END;   -- BODY tercero
/
