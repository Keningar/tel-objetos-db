CREATE OR REPLACE PACKAGE            consecutivo AS
  -- ---
  --  Este paquete contiene un conjunto de funciones que generan
  -- un numero de documento y serie.
  --
  --  En general las funciones reciben la compa?ia, el a?o y el mes
  -- para el cual se requiere el numero.  Ademas, es necesario indicar
  -- al llamar la funcion el TIPO DE CONSECUTIVO (TipoConsec) que debe
  -- generarse.
  --
  --  Ejemplo, para facturacion el llamado podria ser:
  --        declare
  --           vnum_factu     arfafe.no_fisico%type
  --           vserie_factu   arfafe.serie_fisico%type;
  --        begin
  --           vnum_factu   := consecutivo.fa(:no_cia, :ano, :mes, :centrod, :tipo_doc, 'NUMERO');
  --           vserie_factu := consecutivo.fa(:no_cia, :ano, :mes, :centrod, :tipo_doc, 'SERIE')
  --        exception
  --           when consecutivo.error then
  --                 message( consecutivo.ultimo_error );
  --                 synchronize;
  --                 raise form_trigger_failure;
  --        end;
  --
  -- RESTRICCIONES:
  --  1. Un numero de documento (o consecutivo) deberia obtenerse justo antes
  --     de grabar la transaccion, ya que cualquier otro usuario que requiere
  --     un numero del mismo tipo, seria bloqueado.
  --
  -- ***
  --
  -- ---
  -- Consecutivos para CONTABILIDAD GENERAL
  -- * pTipoDoc    IN ('I','E','T')
  -- * pTipoConsec IN ('COMPROBANTE')
  FUNCTION  cg(pCia     varchar2,
               pAno     number,
               pMes     number,
               pTipoDoc       varchar2,
               pTipoConsec    varchar2 ) RETURN VARCHAR2;
  -- ---
  -- consecutivos para CHEQUES Y CONCILIACIONES
  -- * pTipoConsec IN ('NUMERO')
  FUNCTION  ck(pCia     varchar2,
               pAno     number,
               pMes     number,
               pCta     varchar2,
               pTipoDoc varchar2,
               pTipoConsec     varchar2 ) RETURN VARCHAR2;
  -- ---
  -- consecutivos para CUENTAS POR PAGAR
  -- * pTipoConsec IN ('ARCHIVO')
  FUNCTION  cp(pCia     varchar2,
               pAno     number,
               pMes     number,
               pTipoDoc varchar2,
               pTipoConsec     varchar2 ) RETURN VARCHAR2;
  -- ---
  -- consecutivos para CUENTAS POR COBRAR
  -- * pTipoConsec IN ('NUMERO','SERIE')
  FUNCTION  cc(pCia     varchar2,
               pAno     number,
               pMes     number,
               pCentrod varchar2,
               pTipoDoc varchar2,
               pTipoConsec     varchar2 ) RETURN VARCHAR2;
  -- ---
  -- consecutivos para FACTURACION
  -- * pTipoConsec IN ('NUMERO','SERIE')
  FUNCTION  fa(pCia     varchar2,
               pAno     number,
               pMes     number,
               pCentrod varchar2,
               pCentrof varchar2,
               pTipoDoc varchar2,
               pTipoConsec     varchar2 ) RETURN VARCHAR2;
  -- ---
  -- consecutivos para INVENTARIO
  FUNCTION  inv(pCia     varchar2,
               pAno     number,
               pMes     number,
               pCentrod varchar2,
               pTipoDoc varchar2,
               pTipoConsec     varchar2 ) RETURN VARCHAR2;
  -- consecutivos para COMPRAS
  FUNCTION  co (pCia         varchar2,
                pAno         number,
                pMes         number,
                pTipoMov     varchar2,
                pTipoConsec  varchar2 ) RETURN VARCHAR2;
  --
  FUNCTION  ch( pCia    varchar2,
               pAno     number,
               pMes     number,
               pCod_Caja      varchar2,
               pTipoConsec    varchar2) RETURN VARCHAR2;
  -- consecutivo de fonfo fijo
  FUNCTION  ff( pCia    varchar2,
                pAno     number,
                pMes     number,
                pCod_Caja      varchar2,
                pTipoConsec    varchar2) RETURN VARCHAR2;
                
   FUNCTION  imp(pCia     varchar2,
                 pano      number,
                 pmes      number,
                 pTipoConsec varchar2)  RETURN VARCHAR2;               
                
  -- --
  -- Devuelve laa descripcion del ultimo error ocurrido
  FUNCTION  ultimo_error RETURN VARCHAR2;
  --
  error           EXCEPTION;
  PRAGMA          EXCEPTION_INIT(error, -20011);
  kNum_error      NUMBER := -20011;
  -------------
     FUNCTION  consulta_sgte(
      pCia         varchar2,
      pAno         number,
      pMes         number,
      pFormulario  varchar2,
      pTipoConsec  varchar2,
      pconsec      in out number,
      pserie       in out varchar2
   ) RETURN Boolean;

  
END;  -- consecutivo
/


CREATE OR REPLACE PACKAGE BODY            consecutivo AS
   /*******[ PARTE: PRIVADA ]
   * Declaracion de Procedimientos o funciones PRIVADOS
   *
   */
   -- ---
   -- TIPOS
   --
   vMensaje_error       VARCHAR2(160);
   vdatos_form          formulario.datos_formulario;
   --
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
   FUNCTION  cg(
      pCia     varchar2,
      pAno     number,
      pMes     number,
      pTipoDoc       varchar2,
      pTipoConsec    varchar2
   ) RETURN VARCHAR2 IS
      vformulario  control_formu.formulario%type;
      vconsec      varchar2(20);
      -- Obtenemos el formulario para el tipo de comprobante
      cursor c_formulario (pno_cia           in char,
                           ptipo_comprobante in char) is
        select decode(ptipo_comprobante,'I',form_ingreso,
                                        'E',form_egreso,
                                        'T',form_traspaso)
        from arcgmc
        where no_cia = pno_cia;
   BEGIN
      limpia_error;
      vConsec  := NULL;
      if pTipoConsec = 'COMPROBANTE' then
         open c_formulario (pCia, pTipoDoc);
         fetch c_formulario into vformulario;
         if c_formulario%NotFound OR vFormulario IS NULL then
            close c_formulario;
            genera_error( 'Error en asignacion del formulario ' );
         end if;
         close c_formulario;
         begin
           vconsec := formulario.siguiente(pCia, vformulario, (pAno*100)+pMes);
         exception
           when formulario.error then
              genera_error( formulario.ultimo_error );
           when others then
              genera_error( 'Error desconocido, '|| sqlerrm);
         end;
         if vconsec is null then
            genera_error( 'Siguiente formulario un valor NULL');
         end if;
         RETURN ( vconsec );
      else
         genera_error('Tipo de consecutivo: '||pTipoConsec||', no manejado');
      end if;
      RETURN ( vconsec );
   END; -- CG
   --
   --
   FUNCTION  ff(
      pCia     varchar2,
      pAno     number,
      pMes     number,
      pCod_Caja      varchar2,
      pTipoConsec    varchar2
   ) RETURN VARCHAR2 IS
      vformulario  control_formu.formulario%type;
      vconsec      varchar2(20);
	    vfound       boolean;
      -- Obtenemos el formulario para el tipo de comprobante
      cursor c_formulario  is
        select formulario
        from taffmc
        where no_cia   = pCia
		  and cod_caja = pCod_caja;
   BEGIN
      limpia_error;
      vConsec  := NULL;
      if pTipoConsec = 'COMPROBANTE' then
         open c_formulario;
         fetch c_formulario into vformulario;
         vfound := c_formulario%found;
         close c_formulario;
		 if not vfound then
			genera_error('Formulario indicado para la caja chija '||pCod_caja||
			             ' no existe');
         elsif vformulario is null then
		    genera_error('Falta definir formulario para la caja chica '||pCod_caja);
	     else
            begin
              vconsec := formulario.siguiente(pCia, vformulario, (pAno*100)+pMes);
            exception
              when formulario.error then
                 genera_error( formulario.ultimo_error );
              when others then
                genera_error( 'Error desconocido, '|| sqlerrm);
            end;
            if vconsec > 99999999 then
               genera_error( 'El numero generado excede el tama?o maximo');
            end if;
		 end if;
      else
         genera_error('Tipo de consecutivo: '||pTipoConsec||', no manejado');
      end if;
      if vconsec is null then
         genera_error( 'El valor de '||pTipoConsec||' obtenido es NULL');
      end if;
      RETURN ( vConsec );
   END; -- FF
   --
   --
   FUNCTION  ck(
     pCia      varchar2,
     pAno      number,
     pMes      number,
     pCta      varchar2,
     pTipoDoc  varchar2,
     pTipoConsec     varchar2
   ) RETURN VARCHAR2 IS
      vformulario  control_formu.formulario%type;
      vconsec      varchar2(20);
      vfound       boolean;
      -- Obtenemos el formulario para la cuenta bancaria
      cursor c_formulario (ptipo varchar2) is
        select DECODE(ptipo, 'CK', formulario, formulario_tr)
        from arckmc
        where no_cia = pCia
          and no_cta = pCta;
      --
      cursor c_formulario_tipo_docu is
        select formulario_ctrl
        from   arcktd
        where  no_cia   = pCia
        and    tipo_doc = pTipoDoc;
   BEGIN
      limpia_error;
      vConsec     := NULL;
      vformulario := NULL;
      if pTipoConsec = 'NUMERO' then
         open c_formulario (pTipoDoc);
         fetch c_formulario into vformulario;
         vfound := c_formulario%found;
         close c_formulario;
         if not vfound then
            genera_error( 'Formulario no existe para la cuenta Bancaria:'||pCta);
         elsif vformulario is null then
            genera_error( 'Falta definir formulario para la cuenta Bancaria:'||pCta);
         else
           begin
              vconsec := formulario.siguiente(pCia, vformulario, (pAno*100)+pMes);
            exception
              when formulario.error then
                 genera_error( formulario.ultimo_error );
              when others then
                 genera_error( 'Error desconocido, '|| sqlerrm);
            end;
            if vconsec > 99999999 then
               genera_error( 'El numero generado excede el tama?o maximo');
            end if;
         end if;
      elsif pTipoConsec = 'SECUENCIA' then
         open c_formulario_tipo_docu;
         fetch c_formulario_tipo_docu into vformulario;
         vfound := c_formulario_tipo_docu%found;
         close c_formulario_tipo_docu;
         if not vfound then
            genera_error( 'No existe el tipo de documento:'||pCta);
         elsif vformulario is null then
            -- Si se quiere que el formulario sea obligatorio por tipo de documento
            -- se debe habilitar la siguiente linea de codigo
            -- genera_error( 'Falta definir formulario para el Tipo de Documento:'||pCta);
            null;
         else
            begin
              vconsec := formulario.siguiente(pCia, vformulario, (pAno*100)+pMes);
            exception
              when formulario.error then
                 genera_error( formulario.ultimo_error );
              when others then
                 genera_error( 'Error desconocido, '|| sqlerrm);
            end;
            if vconsec > 99999999 then
               genera_error( 'El numero generado excede el tama?o maximo');
            end if;
         end if;
      else
         genera_error('Tipo de consecutivo: '||pTipoConsec||', no manejado');
      end if;
      if vconsec is null and vformulario is not null then
         genera_error( 'El numero obtenido es NULL');
      end if;
      RETURN ( vConsec );
   END; -- CK
   --
   --
   FUNCTION  cp(
     pCia     varchar2,
     pAno     number,
     pMes     number,
     pTipoDoc varchar2,
     pTipoConsec     varchar2
   ) RETURN VARCHAR2
   IS
    vformulario  control_formu.formulario%type;
    vconsec      varchar2(20);
    vfound       boolean;
    -- Obtenemos el formulario para la compa?ia
    cursor c_formulario_tipo_docu is
        select formulario_ctrl
        from arcptd
        where no_cia   = pCia
        and   tipo_doc = pTipodoc;
   BEGIN
    limpia_error;
    vConsec     := NULL;
    vformulario := NULL;
    if pTipoConsec = 'SECUENCIA' then
      open c_formulario_tipo_docu;
      fetch c_formulario_tipo_docu into vformulario;
      vfound := c_formulario_tipo_docu%found;
      close c_formulario_tipo_docu;
      if not vfound then
        genera_error( 'No existe el tipo de documento:'||pTipodoc);
      elsif vformulario is null then
        -- Si se quiere que el formulario sea obligatorio por tipo de documento
        -- se debe habilitar la siguiente linea de codigo
         genera_error( 'Falta definir formulario para el Tipo de Documento:'||pTipodoc);
        null;
      else
        begin
          vconsec := formulario.siguiente(pCia, vformulario, (pAno*100)+pMes);
          exception
          when formulario.error then
            genera_error( formulario.ultimo_error );
          when others then
            genera_error( 'Error desconocido, '|| sqlerrm);
        end;
        if vconsec > 99999999 then
          genera_error( 'El numero generado excede el tamaño maximo');
        end if;
      end if;
    else
         genera_error('Tipo de consecutivo: '||pTipoConsec||', no manejado');
    end if;
    if vconsec is null then
      --null;
      genera_error( 'El numero obtenido es NULL');
    end if;
    RETURN ( vConsec );
   END; -- cp
   --
   --
   FUNCTION  cc(
     pCia     varchar2,
     pAno     number,
     pMes     number,
     pCentrod varchar2,
     pTipoDoc varchar2,
     pTipoConsec     varchar2
   ) RETURN VARCHAR2 IS
      vperiodo     number;
      vformulario  arcctd.formulario%type;
      vconsec      varchar2(20);
      vfound       boolean;
      -- Obtenemos el formulario para la cuenta bancaria
      cursor c_formulario is
        select formulario
        from arcctd
        where no_cia = pCia
          and tipo   = ptipoDoc;
      cursor c_formulario_tipo_docu is
        select formulario_ctrl
        from arcctd
        where no_cia   = pCia
        and   tipo     = pTipodoc;
   BEGIN
      limpia_error;
      vperiodo := (pAno*100)+pMes;
      vConsec  := NULL;
      vFormulario := NULL;
      vfound   := FALSE;
      IF pTipoConsec IN ('NUMERO','SERIE') THEN
         open c_formulario;
         fetch c_formulario into vformulario;
         vfound := c_formulario%found;
         close c_formulario;
         if not vfound then
            genera_error( 'Formulario no existe para el tipo documento:'||ptipoDoc);
         end if;
         if vformulario is null then
            genera_error( 'Falta definir formulario, para el tipo de documento: '||ptipoDoc);
         end if;
       ELSIF   pTipoConsec = 'SECUENCIA' then
         open c_formulario_tipo_docu;
         fetch c_formulario_tipo_docu into vformulario;
         vfound := c_formulario_tipo_docu%found;
         close c_formulario_tipo_docu;
         if not vfound then
            genera_error( 'No existe el tipo de documento:'||pTIPODOC);
         elsif vformulario is null then
         	  -- Si se quiere que el formulario sea obligatorio por tipo de documento
         	  -- se debe habilitar la siguiente linea de codigo
            -- genera_error( 'Falta definir formulario para el Tipo de Documento:'||pCta);
            null;
         end if;
      ELSE
         genera_error('Tipo de consecutivo: '||pTipoConsec||', no manejado');
      END IF;
      --
      IF vfound THEN
         IF pTipoConsec = 'NUMERO' THEN
           begin
              vconsec := formulario.siguiente(pCia, vformulario, vperiodo);
            exception
              when formulario.error then
                 genera_error( formulario.ultimo_error );
              when others then
                 genera_error( 'Error desconocido, '|| sqlerrm);
            end;
            if vconsec > 99999999 then
               genera_error( 'El numero generado excede el tama?o maximo');
            end if;
         ELSIF pTipoConsec = 'SERIE' THEN
            begin
               vdatos_form := formulario.datos(pCia, vFormulario);
               vconsec     := NVL(vdatos_form.serie,'0');
            exception
              when formulario.error then
                 genera_error( formulario.ultimo_error );
              when others then
                 genera_error( 'Error desconocido, '|| sqlerrm);
            end;
         ELSIF pTipoConsec = 'SECUENCIA' THEN
            begin
              vconsec := formulario.siguiente(pCia, vformulario, (pAno*100)+pMes);
            exception
              when formulario.error then
                 genera_error( formulario.ultimo_error );
              when others then
                 genera_error( 'Error desconocido, '|| sqlerrm);
            end;
            if vconsec > 99999999 then
               genera_error( 'El numero generado excede el tama?o maximo');
            end if;
         END IF;
      END IF;
      if vconsec is null and vformulario is not null then
         genera_error( 'El valor de '||pTipoConsec||' obtenido es NULL');
      end if;
      RETURN ( vConsec );
   END; -- cc
   --
   --
   FUNCTION  fa(
     pCia         varchar2,
     pAno         number,
     pMes         number,
     pCentrod     varchar2,
     pCentrof     varchar2,
     pTipoDoc     varchar2,
     pTipoConsec  varchar2
   ) RETURN VARCHAR2 IS
      vperiodo     number;
      vformulario  arfaft.formulario%type;
      vconsec      varchar2(20);
      vfound       boolean;
      -- Obtenemos el formulario para el tipo de documento en
	  -- el centro de facturacion correspondiente
      cursor c_formulario is
        select formulario
        from arfaft
        where no_cia   = pCia
          and centrod  = pcentrod
          and centrof  = pcentrof
          and tipo_doc = ptipoDoc;
      -- Obtenemos el formulario (control) para el tipo de documento
      cursor c_formulario_tipo_docu is
        select formulario_ctrl
        from arfact
        where no_cia   = pCia
          and tipo     = ptipoDoc;
   BEGIN
      limpia_error;
      vperiodo := (pAno*100)+pMes;
      vConsec     := NULL;
      vfound      := FALSE;
      vformulario := NULL;
      IF pTipoConsec IN ('NUMERO','SERIE') THEN
         open   c_formulario;
         fetch  c_formulario into vformulario;
         vfound := (c_formulario%found and vformulario is not null);
         close  c_formulario;
         if vformulario is null then
            genera_error( 'Falta definir formulario, para el centro de facturacion:'||pcentrof||
                          ', tipo doc: '||ptipoDoc);
         end if;
      ELSIF   pTipoConsec = 'SECUENCIA' then
         open c_formulario_tipo_docu;
         fetch c_formulario_tipo_docu into vformulario;
         vfound := c_formulario_tipo_docu%found;
         close c_formulario_tipo_docu;
         if not vfound then
            genera_error( 'No existe el tipo de documento:'||pTIPODOC);
         elsif vformulario is null then
         	  -- Si se quiere que el formulario sea obligatorio por tipo de documento
         	  -- se debe habilitar la siguiente linea de codigo
            -- genera_error( 'Falta definir formulario para el Tipo de Documento:'||pCta);
            RETURN(null);
         end if;
      ELSE
        genera_error('Tipo de consecutivo: '||pTipoConsec||', no manejado');
      END IF;
      IF vfound THEN
         IF pTipoConsec IN  ('NUMERO', 'SECUENCIA') THEN
           begin
              vconsec := formulario.siguiente(pCia, vformulario, vperiodo);
            exception
              when formulario.error then
                 genera_error( vformulario || formulario.ultimo_error );
              when others then
                 genera_error( 'Error desconocido, '|| sqlerrm);
            end;
            if vconsec > 99999999 then
               genera_error( 'El numero generado excede el tama?o maximo');
            end if;
         ELSIF pTipoConsec = 'SERIE' THEN
            begin
               vdatos_form := formulario.datos(pCia, vFormulario);
               vconsec     := NVL(vdatos_form.serie,'0');
            exception
              when formulario.error then
                 genera_error( vformulario || formulario.ultimo_error );
              when others then
                 genera_error( 'Error desconocido, '|| sqlerrm);
            end;
         END IF;
      END IF;
      if vconsec is null AND vformulario is not null then
         genera_error( 'El valor de '||pTipoConsec||' obtenido es NULL');
      end if;
      RETURN ( vConsec );
   END; -- fa
   -- ---
   -- consecutivo de INVENTARIO
   FUNCTION  inv(
     pCia     varchar2,
     pAno     number,
     pMes     number,
     pCentrod varchar2,
     pTipoDoc varchar2,
     pTipoConsec     varchar2
   ) RETURN VARCHAR2 IS
      vperiodo     number;
      vformulario  arcctd.formulario%type;
      vconsec      varchar2(20);
      vfound       boolean;
      -- Obtenemos el formulario para la cuenta bancaria
      cursor c_formulario is
        select formulario
        from arinvtm
        where no_cia  = pCia
          and tipo_m  = ptipoDoc;
   BEGIN
      limpia_error;
      vperiodo := (pAno*100)+pMes;
      vConsec  := NULL;
      vfound   := FALSE;
      IF pTipoConsec IN ('NUMERO','SERIE') THEN
         open c_formulario;
         fetch c_formulario into vformulario;
         vfound := c_formulario%found;
         close c_formulario;
         if not vfound then
            genera_error( 'Formulario no existe para el tipo documento:'||ptipoDoc);
         end if;
         if vformulario is null then
            genera_error( 'Falta definir formulario, para el tipo de documento: '||ptipoDoc);
         end if;
      END IF;
      --
      IF vfound THEN
         IF pTipoConsec = 'NUMERO' THEN
           begin
              vconsec := formulario.siguiente(pCia, vformulario, vperiodo);
            exception
              when formulario.error then
                 genera_error( formulario.ultimo_error );
              when others then
                 genera_error( 'Error desconocido, '|| sqlerrm);
            end;
            if vconsec > 99999999 then
               genera_error( 'El numero generado excede el tama?o maximo');
            end if;
         ELSIF pTipoConsec = 'SERIE' THEN
            begin
               vdatos_form := formulario.datos(pCia, vFormulario);
               vconsec     := NVL(vdatos_form.serie,'0');
            exception
              when formulario.error then
                 genera_error( formulario.ultimo_error );
              when others then
                 genera_error( 'Error desconocido, '|| sqlerrm);
            end;
         END IF;
      END IF;
      if vconsec is null then
         genera_error( 'El valor de '||pTipoConsec||' obtenido es NULL');
      end if;
      RETURN ( vConsec );
   END; -- in
   --
   FUNCTION  ch(
      pCia     varchar2,
      pAno     number,
      pMes     number,
      pCod_Caja      varchar2,
      pTipoConsec    varchar2
   ) RETURN VARCHAR2 IS
      vformulario  control_formu.formulario%type;
      vconsec      varchar2(20);
  	  vfound       boolean;
   BEGIN
      RETURN ( vConsec );
   END; -- CH
   --
   FUNCTION  co(
      pCia          varchar2,
      pAno          number,
      pMes          number,
      pTipoMov      varchar2,
      pTipoConsec   varchar2
   ) RETURN VARCHAR2 IS
      vformulario  control_formu.formulario%type;
      vconsec      varchar2(20);
      -- Obtenemos el formulario para el tipo de movimiento
      -- S de solicitud
      -- C de Cotizacion
      -- O de Orden de Compra
      cursor c_formulario (pno_cia     in char,
                           ptipo_mov   in char) is
        select decode(ptipo_mov,'SOLICITUD',formulario_solic,
                                'COTIZACION',formulario_cotiz,
                                'ORDEN',formulario_orden)
        from tapcia
        where no_cia = pno_cia;
   BEGIN
      limpia_error;
      vConsec  := NULL;
      if pTipoConsec = 'NUMERO' then
         open c_formulario (pCia, pTipoMov);
         fetch c_formulario into vformulario;
         if c_formulario%NotFound OR vFormulario IS NULL then
            close c_formulario;
            genera_error( 'Error en asignacion del formulario ' );
         end if;
         close c_formulario;
         begin
           vconsec := formulario.siguiente(pCia, vformulario, (pAno*100)+pMes);
         exception
           when formulario.error then
              genera_error( formulario.ultimo_error );
           when others then
              genera_error( 'Error desconocido, '|| sqlerrm);
         end;
         if vconsec is null then
            genera_error( 'Siguiente formulario un valor NULL');
         end if;
        --- RETURN ( lpad(vconsec,6,'0') );
        RETURN (vconsec );
      else
         genera_error('Tipo de consecutivo: '||pTipoConsec||', no manejado');
      end if;
      RETURN ( vconsec );
   END; -- CO
   --
   FUNCTION  consulta_sgte(
      pCia         varchar2,
      pAno         number,
      pMes         number,
      pformulario  varchar2,
      pTipoConsec  varchar2,
      pconsec      in out number,
      pserie       in out varchar2
   ) RETURN Boolean IS
      vformulario  control_formu.formulario%type;
      vok       Boolean := False;
   BEGIN
     limpia_error;
   	 BEGIN
       formulario.obtiene_siguiente(pCia, pformulario, (pAno*100)+pMes,pconsec,pserie);
       vok := True;
     EXCEPTION
       WHEN formulario.error THEN
            genera_error( formulario.ultimo_error );
       WHEN others THEN
            genera_error( 'Error desconocido, '|| sqlerrm);
     END;
     IF pconsec is null THEN

       genera_error( 'Siguiente formulario un valor NULL');
     END IF;
     return ( vok );
   END; -- CG
   --
   --
   

   FUNCTION  imp(
                 pCia     varchar2,
                 pano      number,
                 pmes      number,
                 pTipoConsec varchar2     ) RETURN VARCHAR2 IS
                                            vperiodo     number;
                                            vformulario  arcctd.formulario%type;
                                            vconsec      varchar2(20);
                                            vfound       boolean;

      -- Obtenemos el formulario para la cuenta bancaria
      cursor c_formulario is
        select  DECODE(pTipoConsec,'NUMERO',formulario_pedido,'ORDEN',FORMULARIO_ORDEN,'ESTIMADO',FORMULARIO_ESTIMADO, 'PROFORMA', FORMULARIO_PROFORMA)
        from arimco
        where no_cia = pCia;

   BEGIN
      limpia_error;
      vperiodo := (pAno*100)+pMes;
      vConsec  := NULL;
      vFormulario := NULL;
      vfound   := FALSE;

         open c_formulario;
         fetch c_formulario into vformulario;
         vfound := c_formulario%found;
         close c_formulario;
         if not vfound then
            genera_error( 'Formulario no existe. Definalo ');
         end if;
         if vformulario is null then
            genera_error( 'Falta definir formulario, para el tipo de documento: ');
         end if;

      --
      IF vfound THEN

           begin
              vconsec := formulario.siguiente(pCia, vformulario, vperiodo);
            exception
              when formulario.error then
                 genera_error( formulario.ultimo_error );
              when others then
                 genera_error( 'Error desconocido, '|| sqlerrm);
            end;
            if vconsec > 99999999 then
               genera_error( 'El numero generado excede el tama?o maximo');
            end if;

      END IF;
      if vconsec is null and vformulario is not null then
         genera_error( 'El valor de '||pTipoConsec||' obtenido es NULL');
      end if;
      RETURN ( vConsec );
   END; -- imp
   
END;  --consecutivo
/
