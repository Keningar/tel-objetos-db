create or replace FUNCTION            imp(
     pCia     varchar2,
     pano      number,
     pmes      number,
     pTipoConsec varchar2


   ) RETURN VARCHAR2 IS
      vperiodo     number;
      vformulario  arcctd.formulario%type;
      vconsec      varchar2(20);
      vfound       boolean;
      -- Obtenemos el formulario para la cuenta bancaria
      cursor c_formulario is
        select DECODE(pTipoConsec,'NUMERO',formulario_pedido,'ORDEN',FORMULARIO_ORDEN,'ESTIMADO',FORMULARIO_ESTIMADO, 'PROFORMA', FORMULARIO_PROFORMA)
        from arimco
        where no_cia = pCia
         ;
--
   vMensaje_error  VARCHAR2(160);
   kNum_error      VARCHAR2(160);
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
--
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