CREATE OR REPLACE PACKAGE            inclasificacion AS
  --
  -- Paquete especial con una serie de procedimientos para facilitar el manejo de
  -- la definicion de clasificaciones. Trabaja basicamente sobre tres tablas:
  -- arintcl, arinccl y arincl. No incluye las funciones de insercion de datos
  -- si no que sirve para trabajar sobre datos ya existentes.
  -- ---
  --
  TYPE datos_tipo_clasif_r IS RECORD(
     descripcion          arintcl.descripcion%type,
     ind_jerarquico       arintcl.ind_jerarquico%type,
     ind_mov_ultimo_nivel arintcl.ind_mov_ultimo_nivel%type
   );
  --
  -- Las funciones que incluye son las siguientes:

  /*

    - descripcion_tipo: Devuelve la descripcion dado el tipo de clasificacion.
                           indica error si el tipo no existe.

    - mascara:  	A partir del tipo de clasificacion, devuelve la mascara para ser
                    utilizada en el forms. Error si no existe el tipo dado.

    - rellenad:   Rellena con ceros un codigo de clasificacion dado, de acuerdo al
                  largo determinado por el tipo de clasificacion tambien dado como
                  parametro.

    - jerarquico: Devuelve "S" o "N" dependiendo de si el tipo de clasificacion dado
                     es jerarquico. Devuelve error si no existe.

    - Ultimo_nivel:    Devuelve verdadero si el indicador de ultimo nivel asociado al
                       codigo de clasificacion dado como parametro indica "S", falso
                       en caso contrario. (resultado es boolean por compatibilidad con
                       otros paquetes).

    - Acepta_mov_ult_nivel: Dado el tipo_clasif, devuelve "S" si:

                      - La clasificacion no es gerarquica o, si es gerarquica y solo
                        acepta mov. a ultimo nivel.

                       Devuelve "N" si la clasificacion es gerarquica, pero acepta mov.
                       a distintos niveles.
                       Devuelve error si el tipo dado no existe.

   -  Acepta_mov_sn:   Dado un tipo de clasificacion y un codigo, devuelve "S" si:
                       - la clasificacion no es jerarquica, o bien
                       - si siendo jerarquica, el codigo dado es de ultimo nivel o
                       - el codigo de clasificacion acepta movimientos a niveles
                         diferentes del ultimo.

                       Devuelve "N" en otros casos.

   -  formatea:   Dado un string que tiene un codigo, devuelve el mismo formateado
                       segun su tipo_clasif.

                       -  Genera error si el string no se puede adecuar al formato.

   -  clasif_padre: Devuelve el codigo de clasificacion del padre, del codigo dado
                       como parametro; si la clasificacion sigue un orden jerarquico.
                       Devuelve error si no es jerarquico. Devuelve Null, si el parametro
                       es el primer nivel en la jerarquia.

   -  nivel:        Dado un codigo de clasificacion, devuelve su nivel dentro de la
                       jerarquia. ( o cero si no es jerarquizado).

   -  calcula_nivel:       Dado un tipo de clasificacion y un codigo, determina el nivel,
                           de acuerdo a la mascara asociada al tipo de clasificacion.

   -  descripcion_clasif:  Dado un codigo de clasificacion y un tipo, devuelve la
                              descripcion asociada o error si no existe.

   -  ultimo_nivel:        A partir del tipo de clasificacion y el codigo devuelve TRUE si
                           dicho codigo no esta como padre de otros, False si no.
                           Si la clasificacion no es jerarquizada devuelve true.

   -  existe_clasif:       Dado un tipo de clasificacion, codigo de clasificacion,
                              numero de articulo y de compa?ia, devuelve true si existe
                              la relacion respectiva la relacion respectiva,false en caso
                              contrario.

   -  existe_cod_clasif:   Dado un codigo de clasificacion y un tipo, devuelve verdadero o
                           falso dependiende de si existe un registro que los relacione o no.

   -  valida_mascara:      Verifica que el formato dado solo tenga caracteres validos
                              y devuelve una mascara valida para el forms.

   ------------------------------------------------------------------------------------------

  */
   --
   --
   FUNCTION ultimo_error RETURN VARCHAR2;
   --
   FUNCTION ultimo_mensaje RETURN VARCHAR2;
   --
   FUNCTION existe_tipo_clasif( ptipo_clasif in varchar2 ) RETURN BOOLEAN;
   --
   FUNCTION existe_cod_clasif(
     ptipo_clasif in varchar2,
     pcod_clasif  in varchar2
   ) RETURN BOOLEAN;
   --
   FUNCTION existe_clasif(
     pno_cia      in varchar2,
     pno_arti     in varchar2,
     ptipo_clasif in varchar2,
     pcod_clasif  in varchar2
   ) RETURN BOOLEAN;
   --
   FUNCTION descripcion_tipo(
               ptipo_clasif in varchar2)
               RETURN varchar2 ;
   --
   FUNCTION descripcion_clasif( ptipo_clasif in varchar2,
                                pcod_clasif  in varchar2
                               ) RETURN varchar2 ;

   --
   FUNCTION clasif_padre(ptipo_clasif in varchar2,
                        pcod_clasif  in varchar2
                        ) RETURN varchar2 ;
   --
   FUNCTION calcula_nivel(
     ptipo_clasif in varchar2,
     pcod_clasif  in varchar2
   ) RETURN number;
   --
   FUNCTION calcula_padre(
     ptipo_clasif in varchar2,
     pcod_clasif  in varchar2
   ) RETURN varchar2;
   --
   FUNCTION nivel(ptipo_clasif in varchar2,
                  pcod_clasif  in varchar2
                  ) RETURN number ;
   --
   FUNCTION acepta_mov_sn(ptipo_clasif in varchar2,
                          pcod_clasif  in varchar2 ) RETURN varchar2;

   --
   FUNCTION Jerarquico(
               ptipo_clasif in varchar2)
               RETURN varchar2;
   --
   FUNCTION ultimo_nivel( ptipo_clasif in varchar2,
                          pcod_clasif  in varchar2
                         ) RETURN boolean ;
   --
   FUNCTION Acepta_Mov_Ult_Nivel(
               ptipo_clasif in varchar2)
               RETURN varchar2;
   --
   FUNCTION mascara( ptipo_clasif in varchar2  ) RETURN varchar2;
   --
   FUNCTION  rellenad(
              ptipo_clasif in varchar2,
              pcod_clasif  in varchar2) RETURN VARCHAR2;
   --
   FUNCTION Valida_Mascara(
              pformato     in varchar2
              ) RETURN varchar2;
   --
    FUNCTION formatea(
     ptipo_clasif in varchar2,
     pcod_clasif  in varchar2
   ) RETURN varchar2 ;
   --

   FUNCTION  TrimD(pCia         varchar2,
                   ptipo_clasif varchar2,
                   pcod_clasif  varchar2) RETURN VARCHAR2;
   --
   error           EXCEPTION;
   PRAGMA          EXCEPTION_INIT(error, -20053);
   kNum_error      NUMBER := -20053;
   -- Define restricciones de procedimientos y funciones
   --    WNDS = Writes No Database State
   --    RNDS = Reads  No Database State
   --    WNPS = Writes No Package State
   --    RNPS = Reads  No Package State
   --
   PRAGMA RESTRICT_REFERENCES(existe_tipo_clasif, WNDS);
   PRAGMA RESTRICT_REFERENCES(rellenad, WNDS);
   PRAGMA RESTRICT_REFERENCES(trimd, WNDS);
   PRAGMA RESTRICT_REFERENCES(jerarquico, WNDS);
   PRAGMA RESTRICT_REFERENCES(existe_cod_clasif, WNDS);
   PRAGMA RESTRICT_REFERENCES(Acepta_Mov_Ult_Nivel, WNDS);

END;
/


CREATE OR REPLACE PACKAGE BODY            inclasificacion IS

   /*******[ PARTE: PRIVADA ]
   * Declaracion de Procedimientos o funciones PRIVADOS
   *
   */
   TYPE def_nivel_r IS RECORD(
      inicio       number(2),      -- posicion en la que inicia el nivel
      largo        number(1),      -- cantidad de largo   del nivel
      largo_tot    number(2)       -- cantidad de largo   hasta este nivel
   );
   TYPE def_niveles_t IS TABLE OF def_nivel_r
     INDEX BY BINARY_INTEGER;
   --
   --
   gMensaje_error   VARCHAR2(160);
   gMensaje         VARCHAR2(160);
   gtstampt         number;
   gtstampc         number;
   gtstampcl        number;
   gCant_niveles    number(3);
   gLargo_codigo    number(3);
   --
   CURSOR c_datos_tipo_clasif(ptipo_clasif varchar2) IS
       select tipo_clasif, descripcion, mascara, ind_jerarquico,
              ind_mov_ultimo_nivel
       from arintcl
       where tipo_clasif = ptipo_clasif;
   --
   CURSOR c_datos_cod_clasif(ptipo_clasif varchar2,
                             pcod_clasif  varchar2) is
       select tipo_clasif, cod_clasif, cod_clasif_padre, nivel,
              descripcion, ultimo_nivel
       from arinccl
       where tipo_clasif = ptipo_clasif
         and cod_clasif  = pcod_clasif;
   --
   CURSOR c_datos_clasif(pno_cia      varchar2,
                         pno_arti     varchar2,
                         ptipo_clasif varchar2,
                         pcod_clasif  varchar2) is
       select no_cia,no_arti,tipo_clasif,cod_clasif,tstamp
       from arincl
       where no_cia      = pno_cia
         and no_arti     = pno_arti
         and tipo_clasif = ptipo_clasif
         and cod_clasif  = pcod_clasif;
  --
   gTdef_nivel  def_niveles_t;
   gRegtc       c_datos_tipo_clasif%ROWTYPE;
   gRegcc       c_datos_cod_clasif%ROWTYPE;
   gRegcl       c_datos_clasif%ROWTYPE;
   --
   -- --
   --

   PROCEDURE genera_error(msj_error IN VARCHAR2)IS
   BEGIN
      gMensaje_error := substr(msj_error, 1, 160);
      gMensaje       := gMensaje_Error;
      RAISE_APPLICATION_ERROR(kNum_error, msj_error);
   END;
   --
   PROCEDURE mensaje(msj IN VARCHAR2) IS
   BEGIN
      gMensaje  := msj;
   END;
   --
   --
   PROCEDURE Llenar_Clasif_Niveles(
     pMascara      in varchar2
   ) IS
     -- --
     -- llenar la clasificacion de niveles de acuerdo a la definicion de la
     -- mascara para el tipo de clasificacion dada. Asume que la mascara es valida
     --
     i         number;
     j         number;
     niv       number;
     vlargo    number;

   BEGIN
     -- Determina la definicion de cada nivel (inicio,largo, largo_tot)
     -- nota: Si formato es #-###-###, la cuenta es 1123105
     --       definicion de nivel 1 es (1, 1)   largo 1, largo_tot 1
     --            de nivel 2 es (2, 3)   largo 3, largo_tot 4
     --      de nivel 3 es (5, 3)   largo 3, largo_tot 7
     gCant_niveles := 0;
     gLargo_codigo := 0;
     i     := 1;
     niv   := 0;
     LOOP
       j  :=  INSTR(pMascara||'-', '-', i, 1);
       EXIT WHEN nvl(j,0) < 1;
       --
       if j > i then
         niv      := nvl( niv, 0) + 1;
         vlargo   := nvl(j - i,0);
         gtdef_nivel(niv).inicio     := nvl(gLargo_codigo,0) + 1;
         gtdef_nivel(niv).largo      := vlargo  ;
         gtdef_nivel(niv).largo_tot  := nvl(gLargo_codigo,0) + vlargo  ;
         --
         gCant_niveles  := niv;
         gLargo_codigo  := gtdef_nivel(niv).largo_tot     ;
       end if;
       i    := j + 1;
     END LOOP;
   END; -- Llenar_Clasif_Niveles

   --
   --
   /*******[ PARTE: PUBLICA ]
   * Declaracion de Procedimientos o funciones PUBLICAS
   *
   */
   --
   --
   FUNCTION ultimo_error RETURN VARCHAR2 IS
   BEGIN
     RETURN(gMensaje_error);
   END;
   --
   FUNCTION ultimo_mensaje RETURN VARCHAR2 IS
   BEGIN
     RETURN(gMensaje);
   END;
   --
   FUNCTION existe_tipo_clasif(
     ptipo_clasif in varchar2
   ) RETURN BOOLEAN
   IS
     vts          number;
     vencontrado  boolean;
   BEGIN
   	  vts  := to_char(sysdate,'sssss');
   	  if gtstampt = 0 OR ABS(vts - gtstampt) > 2 OR
   	  	 gRegtc.tipo_clasif is null OR gRegtc.tipo_clasif != ptipo_clasif then
   	  	 --
   	  	 OPEN c_datos_tipo_clasif(ptipo_clasif);
   	  	 FETCH c_datos_tipo_clasif into gRegtc;
   	  	 vencontrado := c_datos_tipo_clasif%FOUND;
   	  	 CLOSE c_datos_tipo_clasif;
   	  	 --
   	  	 llenar_clasif_niveles(gRegtc.mascara);
   	  	 gtstampt := vts;
      else
         vencontrado := (ptipo_clasif is not null AND gRegtc.tipo_clasif = ptipo_clasif);
      end if;
      return (vencontrado);
   END;
   --
   FUNCTION existe_cod_clasif(
     ptipo_clasif in varchar2,
     pcod_clasif  in varchar2
   ) RETURN BOOLEAN
   IS
     vts          number;
     vencontrado  boolean;
   BEGIN
   	  vts  := to_char(sysdate,'sssss');
   	  if    gtstampc = 0 OR ABS(vts - gtstampc) > 1 OR
   	  	    gRegcc.cod_clasif is null               OR
   	  	    gRegcc.tipo_clasif is null               OR
   	  	    gregcc.tipo_clasif != ptipo_clasif      OR
   	  	    gRegcc.cod_clasif  != pcod_clasif     then
   	  	 --
   	  	 OPEN c_datos_cod_clasif(ptipo_clasif,pcod_clasif);
   	  	 FETCH c_datos_cod_clasif into gRegcc;
   	  	 vencontrado := c_datos_cod_clasif%FOUND;
   	  	 CLOSE c_datos_cod_clasif;
   	  	 gtstampc := vts;
      else
         vencontrado := (ptipo_clasif is not null          AND
                         pcod_clasif  is not null          AND
                         gRegcc.tipo_clasif = ptipo_clasif AND
                         gRegcc.cod_clasif  = pcod_clasif
                         );
      end if;
      return (vencontrado);
   END;
   --
   --
   FUNCTION existe_clasif(
     pno_cia      in varchar2,
     pno_arti     in varchar2,
     ptipo_clasif in varchar2,
     pcod_clasif  in varchar2
   ) RETURN BOOLEAN
   IS
     vts          number;
     vencontrado  boolean;
   BEGIN
   	  vts  := to_char(sysdate,'sssss');
   	  if    gtstampcl = 0 OR ABS(vts - gtstampcl) > 1  OR
   	  	    gRegcl.no_cia      is null                 OR
   	  	    gRegcl.no_arti     is null                 OR
   	  	    gRegcl.cod_clasif  is null                 OR
   	  	    gRegcl.tipo_clasif is null                 OR
   	  	    gRegcl.no_cia      != pno_cia              OR
   	  	    gRegcl.no_arti     != pno_arti             OR
   	  	    gregcl.tipo_clasif != ptipo_clasif         OR
   	  	    gRegcl.cod_clasif  != pcod_clasif         then
   	  	 --
   	  	 OPEN c_datos_clasif(pno_cia,pno_arti,ptipo_clasif,pcod_clasif);
   	  	 FETCH c_datos_clasif into gRegcl;
   	  	 vencontrado := c_datos_clasif%FOUND;
   	  	 CLOSE c_datos_clasif;
   	  	 gtstampcl := vts;
      else
         vencontrado := (pno_cia      is not null          AND
                         pno_arti     is not null          AND
                         ptipo_clasif is not null          AND
                         pcod_clasif  is not null          AND
                         gRegcl.no_cia      = pno_cia      AND
                         gRegcl.no_arti     = pno_arti     AND
                         gRegcl.tipo_clasif = ptipo_clasif AND
                         gRegcl.cod_clasif  = pcod_clasif
                         );
      end if;
      return (vencontrado);
   END;
   --
   --
   FUNCTION mascara(
     ptipo_clasif in varchar2
   ) RETURN varchar2
   IS
   BEGIN
   	 if NOT existe_tipo_clasif(ptipo_clasif) then
   	 	  genera_error('No existe tipo de clasificacion: '||ptipo_clasif);
   	 end if;
     return( gRegtc.mascara);
   END;
   --
   FUNCTION  rellenad(
      ptipo_clasif in varchar2,
      pcod_clasif  in varchar2) RETURN VARCHAR2
   IS
     vcodigo   varchar2(30);
   BEGIN
     if NOT existe_tipo_clasif(ptipo_clasif) then
   	 	  genera_error('No existe tipo de clasificacion: '||ptipo_clasif);
     end if;

     RETURN ( RPAD(Ltrim(rtrim(pCod_clasif)), gLargo_codigo, '0') );
   END rellenad;
   --
   --
   FUNCTION formatea(
     ptipo_clasif in varchar2,
     pcod_clasif  in varchar2
   ) RETURN varchar2
   IS
     vMascara          arintcl.mascara%type;
     vMask_SinGuiones  arintcl.mascara%type;
     vCod_fmt          varchar2(30);
     vTextoNivel       varchar2(30);
     vLgCod            number;
   BEGIN
     vMascara:=' ';
 	   if NOT existe_tipo_clasif(ptipo_clasif) then
 	 	    genera_error('No existe tipo de clasificacion: '||ptipo_clasif);
 	   end if;

     vmascara := gRegtc.mascara;
     vLgCod   := nvl(length(pCod_clasif),0);

     if vLgCod < 1 then
     	  vcod_fmt := NULL;

     elsif (vLgCod > gLargo_codigo) then
	    	genera_error('Cantidad de Digitos del Codigo: '||pcod_clasif||' no Corresponde con Mascara: '||vMascara);

     else
       	-- buscar errores por # asignados a letras
   	    vMask_SinGuiones := translate(vmascara,'X#-','X#');
   	    for k in 1..gLargo_Codigo loop
  	  	  if ( substr(vMask_SinGuiones,k,1) = '#'
               and instr('0123456789',substr(pcod_clasif,k,1)) < 1 )  then
 	    	     genera_error('Caracter no Numerico en posicion de un digito #');
  	 	    end if;
   	    end loop;
   	    --
   	    -- formatea el codigo de clasificacion asignado
        vCod_fmt := null;
        FOR n IN 1..gCant_niveles LOOP
          if n < 2 then
             vCod_fmt := substr(pcod_clasif, 1, gtdef_nivel(n).largo  );
          else
          	 vTextoNivel:=substr(pcod_clasif, gtdef_nivel(n).inicio, gtdef_nivel(n).largo);
             vCod_fmt := vCod_fmt ||'-'||vTextoNivel;
          end if;
          IF gtdef_nivel(n).largo_tot >= vLgcod THEN
            Exit;
          END IF;
        END LOOP;
     end if;
     return(vcod_fmt);
   END;   /* formatea */
   --
   --
   FUNCTION calcula_nivel(
     ptipo_clasif in varchar2,
     pcod_clasif  in varchar2
   ) RETURN number
   IS
     vMascara          arintcl.mascara%type;
     vMask_SinGuiones  arintcl.mascara%type;
     vTextoNivel       varchar2(30);
     vLgCod            number;
     vnivel            arinccl.nivel%type;
   BEGIN
   	 vnivel:=0;
     vMascara:=' ';
 	   if NOT existe_tipo_clasif(ptipo_clasif) then
 	 	    genera_error('No existe tipo de clasificacion: '||ptipo_clasif);
 	   end if;

     vmascara := gRegtc.mascara;
     vLgCod   := nvl(length(pCod_clasif),0);

     if (vLgCod > gLargo_codigo) then
	    	genera_error('Cantidad de Digitos del Codigo: '||pcod_clasif||' no Corresponde con Mascara: '||vMascara);

     else
       	-- buscar errores por # asignados a letras
   	    vMask_SinGuiones := translate(vmascara,'X#-','X#');
   	    for k in 1..gLargo_Codigo loop
  	  	  if ( substr(vMask_SinGuiones,k,1) = '#'
               and instr('0123456789',substr(pcod_clasif,k,1)) < 1 )  then
 	    	     genera_error('Caracter no Numerico en posicion de un digito #');
  	 	    end if;
   	    end loop;
   	    --
   	    -- revisa el codigo de clasificacion asignado
        FOR n IN 1..gCant_niveles LOOP
          	 vTextoNivel:=substr(pcod_clasif, gtdef_nivel(n).inicio, gtdef_nivel(n).largo);
          if length(rtrim(translate(vTextoNivel,'0',' '))) <> 0 then
            vNivel:=n;
          end if;
          IF gtdef_nivel(n).largo_tot >= vLgcod THEN
            Exit;
          END IF;
        END LOOP;
     end if;
     return(vNivel);
   END;   /*calcula_nivel */
   --
   --
   FUNCTION codigo_nivel(
     pMascara     in varchar2,
     pCod_clasif  in varchar2,
     pNivel       in number
   ) RETURN varchar2
   IS
     vMask_SinGuiones  arintcl.mascara%type;
     vCod_Nivel          varchar2(30);
     vTextoNivel       varchar2(30);
     vLgCod            number;
   BEGIN
     vLgCod   := nvl(length(pCod_clasif),0);

     if vLgCod < 1 then
     	  vcod_nivel := NULL;
     else
     	  llenar_clasif_niveles(pMascara);
   	    --
   	    -- formatea el codigo de clasificacion asignado
        vCod_nivel := null;
        FOR n IN 1..pNivel LOOP
          if n < 2 then
             vCod_nivel := substr(pcod_clasif, 1, gtdef_nivel(n).largo  );
          else
          	 vTextoNivel:=substr(pcod_clasif, gtdef_nivel(n).inicio, gtdef_nivel(n).largo);
             vCod_nivel := vCod_nivel || vTextoNivel;
          end if;
          IF gtdef_nivel(n).largo_tot >= vLgcod THEN
            Exit;
          END IF;
        END LOOP;
     end if;
     return(vcod_nivel);
   END;   /* codigo_nivel */
   --
   --
   FUNCTION calcula_padre(
     ptipo_clasif in varchar2,
     pcod_clasif  in varchar2
   ) RETURN varchar2
   IS
      vNivel number;
      vCodPadre arinccl.cod_clasif_padre%type;
   BEGIN
   	   vNivel:=calcula_nivel(ptipo_clasif,pcod_clasif);
    	 if vNivel > 1 then
 	        vCodPadre:= codigo_nivel(gRegtc.mascara,pcod_clasif,vNivel-1);
 	        vCodPadre:=rellenad(ptipo_clasif,vCodPadre);
   	   else
   		 	  vCodPadre:=null;
     	 end if;
 	     return(vCodPadre);
   END;   /*calcula_padre */
   --
   --
   FUNCTION descripcion_tipo(
       ptipo_clasif in varchar2
   ) RETURN varchar2 IS
   BEGIN
   	 if NOT existe_tipo_clasif(ptipo_clasif) then
   	 	  genera_error('No existe tipo de clasificacion: '||ptipo_clasif);
   	 end if;
     return( gRegtc.descripcion);
  END;
 --
  FUNCTION Jerarquico(
    ptipo_clasif in varchar2
  ) RETURN varchar2
  IS
  BEGIN
   	 if NOT existe_tipo_clasif(ptipo_clasif) then
   	 	  genera_error('No existe tipo de clasificacion: '||ptipo_clasif);
   	 end if;
     return( gRegtc.ind_jerarquico);
  END;
  --
  FUNCTION Acepta_Mov_Ult_Nivel(
    ptipo_clasif in varchar2
  ) RETURN varchar2
  IS
    vResul varchar2(1);
  BEGIN
   	 if NOT existe_tipo_clasif(ptipo_clasif) then
   	 	  genera_error('No existe tipo de clasificacion: '||ptipo_clasif);
   	 end if;
     if gRegtc.ind_jerarquico='N' then
   	  	 vResul:='S';
   	 elsif gRegtc.ind_mov_ultimo_nivel='S' then
   	  	 vResul:='S';
     else
      	 vResul:='N';
   	 end if;
   	 return(vResul);
  END;
  --
  FUNCTION Valida_Mascara(
    pformato     in varchar2
  ) RETURN varchar2
  IS
    vmascara varchar2(30);
  BEGIN
	   vmascara:=' ';
     -- verifica que el formato solo tenga caracteres validos,
     --
     if nvl(length(ltrim(translate(pformato,'#-X','   '))),0)  <> 0 then
       genera_error('El formato de la mascara contiene caracteres dif. a "#" , "-" o "X"');
     elsif instr(pformato,'--') <> 0 then
        -- No deben existir dos guiones seguidos
        genera_error('La definicion del formato de mascara contiene guiones consecutivos');
     elsif (substr(pformato,1,1)='-') or (substr(pformato,length(pformato),1)='-') then
   	    -- Ni el inicio ni el final del formato debe ser guiones.
   	    genera_error('Existe guion al inicio o al final del formato de mascara');
     end if;
     vMascara   := 'FM'||replace(pformato,'#','9');
     vMascara   := replace(vMascara,'-','"-"');
     return(vmascara);
  END;
  ---
  FUNCTION clasif_padre(ptipo_clasif in varchar2,
                        pcod_clasif  in varchar2
                        ) RETURN varchar2 IS

   vJerarquico arintcl.ind_jerarquico%type;
   BEGIN
      if NOT existe_cod_clasif(ptipo_clasif,pcod_clasif) then
   	 	   genera_error ('Codigo De Clasificacion No Existe: '||pcod_clasif);
   	     vJerarquico:=Jerarquico(ptipo_clasif);
   	     if vJerarquico='N' then
   	        genera_error('Clasificacion no es Jerarquica '||pcod_clasif);
   	     end if;
      end if;
      return(gRegcc.cod_clasif_padre);
   END;
   --
   FUNCTION nivel(ptipo_clasif in varchar2,
                  pcod_clasif  in varchar2
                  ) RETURN number IS

     vNivel      arinccl.nivel%type;
     vJerarquico arintcl.ind_jerarquico%type;
   BEGIN
      if NOT existe_cod_clasif(ptipo_clasif,pcod_clasif) then
   	 	   genera_error ('Codigo De Clasificacion No Existe: '||pcod_clasif);
   	 	else
   	     vJerarquico := Jerarquico(ptipo_clasif);
   	     if vJerarquico = 'N' then
   	        vNivel := 1;
   	     else
   	     	  vNivel := gRegcc.nivel;
   	     end if;
      end if;
      return(vNivel);
   END;
   --
   FUNCTION descripcion_clasif( ptipo_clasif in varchar2,
                                pcod_clasif  in varchar2
                               ) RETURN varchar2 IS

   BEGIN
      if NOT existe_cod_clasif(ptipo_clasif,pcod_clasif) then
   	 	   genera_error ('Codigo De Clasificacion No Existe: '||pcod_clasif);
      end if;
      return(gRegcc.descripcion);
   END;
   --
   FUNCTION ultimo_nivel( ptipo_clasif in varchar2,
                          pcod_clasif  in varchar2
                         ) RETURN boolean IS
   BEGIN
      if NOT existe_cod_clasif(ptipo_clasif,pcod_clasif) then
   	 	   genera_error ('Codigo De Clasificacion No Existe: '||pcod_clasif);
      end if;
      return(gRegcc.ultimo_nivel='S');
   END;
   --
   FUNCTION acepta_mov_sn(
     ptipo_clasif in varchar2,
     pcod_clasif  in varchar2
   ) RETURN varchar2
   IS
     vacepta_mov   varchar2(2);
   BEGIN
      if NOT existe_cod_clasif(ptipo_clasif, pcod_clasif) then
   	 	   genera_error ('Codigo De Clasificacion No Existe: '||pcod_clasif);
   	 	else
   	     if Jerarquico(ptipo_clasif)='N' then
   	        vacepta_mov := 'S';
   	     elsif gRegcc.ultimo_nivel='S' then
   	     	    vacepta_mov := 'S';
   	     elsif Acepta_Mov_Ult_Nivel(ptipo_clasif)='S' then
   	     	    vacepta_mov:= 'N';
   	     else
   	     	   vacepta_mov:='S';
   	     end if;
      end if;
      return(vacepta_mov);
   END;
   --
   --

   FUNCTION  TrimD(pCia         varchar2,
                   ptipo_clasif varchar2,
                   pcod_clasif  varchar2) RETURN VARCHAR2 IS

     vcod_clasif    arinccl.cod_clasif%type;
     vLgCod         number(2);
   BEGIN
   	 if NOT existe_tipo_clasif(ptipo_clasif) then
   	 	  genera_error('No existe tipo de clasificacion: '||ptipo_clasif);
     ELSE
       if NOT existe_cod_clasif(ptipo_clasif, pcod_clasif) then
   	 	     genera_error ('Codigo De Clasificacion No Existe: '||ptipo_clasif);
       ELSE
          vLgCod      := gTdef_nivel(gRegcc.nivel).largo_tot;
          vcod_clasif := SUBSTR(pcod_clasif, 1, vLgCod);
       END IF;
       RETURN(vcod_clasif);
     END IF;
   END TrimD;
 END;

 /* *************** */
/
