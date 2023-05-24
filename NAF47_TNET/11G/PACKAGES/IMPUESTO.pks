CREATE OR REPLACE PACKAGE NAF47_TNET.IMPUESTO AS
   TYPE datos_r IS RECORD(
      descripcion               arcgimp.descripcion%type,
      sectorizable              arcgimp.sectorizable%type,
      columna                   arcgimp.columna%type,
      ind_retencion             arcgimp.ind_retencion%type,
      certificado               arcgimp.certificado%type,
      dias_cred_fiscal          arcgimp.dias_cred_fiscal%type,
      base_minima               arcgimp.base_minima%type,
      porcentaje                arcgimp.porcentaje%type,
      incluido                  arcgimp.incluido%type,
      especial                  arcgimp.especial%type,
      cuenta                    arcgms.cuenta%type,
      pais                      argepai.pais%type,
      provincia                 argepro.provincia%type,
      canton                    argecan.canton%type,
      actividad                 argeac.actividad%type,
      sector                    argesec.codigo%type,
      id_sec                    arcgdisec.id_sec%type,
      ind_aplica_compras        arcgimp.ind_aplica_compras%type,
      ind_aplica_servicios    arcgimp.ind_aplica_servicios%type,
      ind_aplica_import            arcgimp.ind_aplica_compras%type,
      ind_aplica_exportac        arcgimp.ind_aplica_exportac%type
   );
   --
   --
   FUNCTION existe(pCia         arcgmc.no_cia%type,
                   pClave       arcgimp.clave%type,
                   pFec_doc     arcgimp.fec_desde%type default null) RETURN BOOLEAN;
   --
   FUNCTION existe(pCia         arcgmc.no_cia%type,
                   pClave       arcgimp.clave%type,
                   pId_sec      arcgdisec.id_sec%type,
                   pFec_doc     arcgimp.fec_desde%type default null) RETURN BOOLEAN;
   --
   FUNCTION descripcion(pCia   arcgmc.no_cia%type,
                        pClave arcgimp.clave%type) RETURN VARCHAR2;
   --
   FUNCTION columna(pCia   arcgmc.no_cia%type,
                    pClave arcgimp.clave%type) RETURN VARCHAR2;
   --
   FUNCTION sectorizable(pCia   arcgmc.no_cia%type,
                         pClave arcgimp.clave%type) RETURN BOOLEAN;
   --
   FUNCTION incluido(pCia   arcgmc.no_cia%type,
                     pClave arcgimp.clave%type) RETURN BOOLEAN;
   --
   FUNCTION comportamiento(pCia   arcgmc.no_cia%type,
                           pClave arcgimp.clave%type) RETURN Varchar2;
   --
   FUNCTION EsRetencion(pCia   arcgmc.no_cia%type,
                        pClave arcgimp.clave%type) RETURN BOOLEAN;
   --
   FUNCTION porcentaje(pCia         arcgmc.no_cia%type,
                       pClave       arcgimp.clave%type,
                       pId_Sec      arcgdisec.id_sec%type,
                       pFec_doc     arcgimp.fec_desde%type default null) RETURN NUMBER;
   --
   --
  FUNCTION  calcula(pCia             arcgmc.no_cia%type,
                     pClave           arcgimp.clave%type,
                     pMto_Gravado     number,
                     pId_Sec          arcgdisec.id_sec%type,
                     pFactor          number,
                     pfec_doc         arcgimp.fec_desde%type) RETURN NUMBER;
   --
   --
   FUNCTION  calcula(pCia             arcgmc.no_cia%type,
                     pClave           arcgimp.clave%type,
                     pMto_Gravado     number,
                     pId_Sec          arcgdisec.id_sec%type,
                     pFactor          number,
                     pPorcentaje      Number,
                     pfec_doc         arcgimp.fec_desde%type ) RETURN NUMBER;
   --
   --
   FUNCTION  trae_datos(pCia         arcgmc.no_cia%type,
                        pClave       arcgimp.clave%type,
                        pId_Sec      arcgdisec.id_sec%type,
                        pfec_doc     arcgimp.fec_desde%type default null) RETURN datos_r;
   --
   --
   FUNCTION vencido (pCia        arcgimp.no_cia%type,
                     pClave      arcgimp.clave%type,
                     pFecha_Doc  date,
                     pFecha_Cont date)  RETURN  BOOLEAN;
   --
   FUNCTION  cta_contable(pCia         arcgmc.no_cia%type,
                          pClave       arcgimp.clave%type,
                          pId_Sec      arcgdisec.id_sec%type) RETURN VARCHAR2;

   FUNCTION  calcula_base(pCia             arcgmc.no_cia%type,
                                 pClave           arcgimp.clave%type,
                                 pMto_Gravado     number,
                                 pMto_bienes      number,
                                 pMto_servicios   number,
                                 pMto_importacion number,
                                 pMto_exportacion number,
                                 pId_Sec          arcgdisec.id_sec%type,
                                 pfec_doc         arcgimp.fec_desde%type) RETURN NUMBER;
   --
   FUNCTION  ultimo_error RETURN VARCHAR2;
   FUNCTION  ultimo_mensaje RETURN VARCHAR2;
   --
   error           EXCEPTION;
   PRAGMA          EXCEPTION_INIT(error, -20026);
   kNum_error      NUMBER := -20026;
   -- Define restricciones de procedimientos y funciones
   --    WNDS = Writes No Database State
   --    RNDS = Reads  No Database State
   --    WNPS = Writes No Package State
   --    RNPS = Reads  No Package State
   --
END;
/

CREATE OR REPLACE PACKAGE BODY NAF47_TNET.IMPUESTO AS
   /*******[ PARTE: PRIVADA ]
   * Declaracion de Procedimientos o funciones PRIVADOS
   *
   */
   gno_cia           arcgmc.no_cia%type;
   gclave            arcgimp.clave%type;
   gdummy            varchar2(2);
   gTstamp           number;
   --
   vMensaje          Varchar2(200);
   vMensaje_Error    Varchar2(200);
   --
   RegImp            ArcgImp%RowType;
   RegImpSec         ArcgDISec%RowType;
   RegHimp                   ArcgHimp%Rowtype;
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
   --
   FUNCTION  calculo_general(
     pCia         ARCGMC.no_cia%type,
     pClave       ARCGIMP.clave%type,
     pMto_Gravado Number,
     pPorcentaje  Number
   ) RETURN number IS

      vPorcentaje    arcgimp.porcentaje%type;
      vMto_aplicado  Number;
      vBase          arcgimp.base_minima%type;
      vCalculo       number;

   BEGIN
      vCalculo := 0;
      IF RegImp.Sectorizable = 'S' THEN
         vPorcentaje := RegImpSec.Porcentaje;
         vBase       := RegImpSec.Base_Minima;
      ELSE
         vPorcentaje := RegImp.Porcentaje ;
         vBase       := RegImp.Base_Minima;
      END IF;
      -- si se necesita calcular el impuesto con un porcentaje diferente
      -- al actualmente registrado el pPorcentaje es no nulo.
      vPorcentaje := NVL(pPorcentaje, vPorcentaje) / 100;
      
      IF vPorcentaje = 0 THEN
        --Genera_Error('El porcentaje no puede ser cero');
        vCalculo := 0;
      ELSE
        -- Valida si debe aplicar el impuesto
        IF vBase <= ABS(pMto_Gravado) THEN
           IF  nvl(RegImp.Incluido,'N') = 'S' THEN
              -- IF (Comportamiento(pCia, pClave) = 'I' ) THEN
              -- El impuesto es incluido
              vMto_Aplicado := pMto_Gravado / (1 + vPorcentaje);
              vCalculo      := (pMto_Gravado - vMto_Aplicado);
           ELSE
              -- El impuesto es excluido o de comportamiento especial
              vCalculo   := pMto_Gravado * vPorcentaje;
           END IF;
        END IF;
      END IF;

      Return ( vCalculo );
   END;
   -- --
   -- Valida si el paquete ya fue inicializado
   FUNCTION inicializado(
     pCia   arcgmc.no_cia%type,
     pClave arcgimp.clave%type
   ) RETURN boolean IS
   BEGIN
      RETURN (     nvl(gno_cia, '*NULO*') = pCia
               AND nvl(gclave, '*NULO*')  = pClave);
   END inicializado;
   --
   ---
   --
   /*******[ PARTE: PUBLICA ]
   * Declaracion de Procedimientos o funciones PUBLICAS
   */
   --
   --
   FUNCTION ultimo_error RETURN VARCHAR2 IS
   BEGIN
     RETURN(vMensaje_error);
   END ultimo_error;
   --
   --
   FUNCTION ultimo_mensaje RETURN VARCHAR2 IS
   BEGIN
     RETURN(vMensaje);
   END ultimo_mensaje;
   --
   --
   --
   FUNCTION  Existe(
     pCia       arcgmc.no_cia%type,
     pClave     arcgimp.clave%type,
     pfec_doc   arcgimp.fec_desde%type default null
   ) RETURN boolean IS
     --
     vExiste   Boolean;
     vRegImp   ArcgImp%RowType;
     vRegSec   ArcgDISec%RowType;
     vTstamp   number;

     --
     CURSOR c_imp IS
       SELECT *
         FROM arcgimp
        WHERE no_cia = pCia
          AND clave  = pClave;
     --
     CURSOR c_imp_aplica IS
          SELECT *
              FROM arcghimp
          WHERE no_cia     = pCia
          AND clave      = pClave
          AND id_sec     = '00000'
          AND fec_desde  = (SELECT max(fec_desde)
                              FROM arcghimp
                             WHERE no_cia     = pCia
                               AND clave      = pClave
                               AND id_sec     = '00000'
                               AND fec_desde  <= pfec_doc);

   BEGIN

     vExiste := TRUE;
     vtstamp := TO_CHAR(sysdate, 'SSSSS');

     IF (gTstamp is null OR ABS(vtstamp - gTstamp) > 2) or
           (RegImp.no_cia IS NULL OR RegImp.clave IS NULL) or
        (RegImp.no_cia != pCia OR RegImp.clave != pClave or
        (RegImp.fec_desde != pfec_doc) ) THEN
       OPEN  c_Imp;
       FETCH c_Imp INTO vRegImp;
       vExiste := c_imp%FOUND;
       CLOSE c_Imp;
       RegImp  := vRegImp;

       IF RegImp.sectorizable = 'N' THEN
         IF pfec_doc is not null THEN
           -- Verifica que exista elimpuesto de acuerdo a la fecha dada
              OPEN  c_imp_aplica;
              FETCH c_imp_aplica INTO RegHimp;
              vExiste := c_imp_aplica%FOUND;
              CLOSE c_imp_aplica;

           RegImp.fec_desde  := RegHimp.fec_desde;
           RegImp.porcentaje := RegHimp.porcentaje;

         END IF;--pfec_doc
       END IF; -- sectorizable
       gTstamp := TO_CHAR(sysdate, 'SSSSS');
       IF vExiste AND RegImp.Sectorizable = 'S' THEN
         -- Hace NULL la imformacion por sector
         RegImpSec := vRegSec;
       END IF; -- vexiste
     END IF;
     return (vExiste);
   END;
   --
   FUNCTION  Existe(
     pCia       arcgmc.no_cia%type,
     pClave     arcgimp.clave%type,
     pId_sec    arcgdisec.id_sec%type,
     pfec_doc   arcgimp.fec_desde%type default null
   ) RETURN boolean IS
      vExiste   boolean;
      vRegSec   arcgDISec%RowType;
      vRegHimp  arcghimp%RowType;
      vTstamp   number;
      --
      CURSOR c_impSec IS
        SELECT *
          FROM arcgDiSec
         WHERE no_cia = pCia
           AND clave  = pClave
           AND id_sec = pid_sec;
      --
     CURSOR c_imp_aplica IS
          SELECT *
              FROM arcghimp
          WHERE no_cia     = pCia
          AND clave      = pClave
          AND id_sec     = pId_Sec
          AND fec_desde  = (SELECT max(fec_desde)
                              FROM arcghimp
                             WHERE no_cia     = pCia
                               AND clave      = pClave
                               AND id_sec     = pId_Sec
                               AND fec_desde  <= pfec_doc);

   BEGIN
      vExiste := Existe(pCia, pClave, pfec_doc);

      IF vExiste then
         if (RegImpSec.no_cia IS NULL or RegImpSec.clave  IS NULL or
                RegImpSec.id_sec IS NULL ) or (RegImpSec.no_cia != pCia or
                RegImpSec.clave != pClave OR RegImpSec.id_sec != pid_sec or
                (RegImp.fec_desde != pfec_doc) ) then
            --
            Open c_ImpSec;
            Fetch c_ImpSec INTO vRegSec;
            vExiste := c_impSec%FOUND;
            Close c_ImpSec;
            RegImpSec := vRegSec;
            if pfec_doc is not null then
                      -- Obtiene el impuesto que aplica de acuerdo a
                     -- la fecha del documento
                   open c_imp_aplica;
                      fetch c_imp_aplica into RegHimp;
                   vExiste := c_imp_aplica%FOUND;
                      close c_imp_aplica;

              IF RegImp.sectorizable = 'S' THEN
                        RegImpSec.fec_desde  := RegHimp.fec_desde;
                  RegImpSec.porcentaje := RegHimp.porcentaje;
                END IF;
                 end if;--pfec_doc
         end if;
      end if;
      RETURN (vExiste);
   END;
   --
   FUNCTION descripcion(
     pcia   arcgmc.no_cia%type,
     pclave arcgimp.clave%type
   ) RETURN varchar2 IS
   BEGIN
     IF NOT existe(pCia, pClave) THEN
        genera_error('No existe impuesto codigo: '||pClave);
     END IF;
     Return(RegImp.Descripcion);
   END;
   --
   --
   FUNCTION columna(
     pCia    arcgmc.no_cia%type,
     pClave  arcgimp.clave%type
   ) RETURN varchar2 IS
   BEGIN
     IF NOT existe(pCia, pClave) THEN
        genera_error('No existe impuesto codigo: '||pClave);
     END IF;
     Return(RegImp.Columna);
   END;
   --
   --
   FUNCTION sectorizable(
     pCia   arcgmc.no_cia%type,
     pClave arcgimp.clave%type
   ) RETURN boolean IS
   BEGIN
     IF NOT existe(pCia, pClave) THEN
        genera_error('No existe impuesto codigo: '||pClave);
     END IF;
     Return(NVL(RegImp.Sectorizable, 'N') = 'S');
   END;
   --
   --
   FUNCTION sectorizable(
     pCia     arcgmc.no_cia%type,
     pClave   arcgimp.clave%type,
     pFec_doc arcgimp.fec_desde%type
   ) RETURN boolean IS
   BEGIN
     IF NOT existe(pCia, pClave, pFec_doc) THEN
        genera_error('No existe impuesto codigo: '||pClave);
     END IF;
     Return(NVL(RegImp.Sectorizable, 'N') = 'S');
   END;
   --
   --
   FUNCTION incluido(pCia   ARCGMC.no_cia%type,
                     pClave ARCGIMP.clave%type) RETURN BOOLEAN IS
   BEGIN
     IF NOT existe(pCia, pClave) THEN
        genera_error('No existe impuesto codigo: '||pClave);
     END IF;
     Return(NVL(RegImp.Incluido, 'N') = 'S');
   END;
   --
   --
   FUNCTION comportamiento(
     pCia   arcgmc.no_cia%type,
     pClave arcgimp.clave%type
   ) RETURN varchar2 IS
   BEGIN
     IF NOT existe(pCia, pClave) THEN
        genera_error('No existe impuesto codigo: '||pClave);
     END IF;
     IF (NVL(RegImp.Incluido, 'N') = 'N') THEN
       Return('E'); -- El impuesto es excluido
     ELSIF (NVL(RegImp.Incluido, 'N') = 'S' AND Nvl(RegImp.Especial, 'N') = 'N') THEN
       Return('I'); -- El impuesto es incluido
     ELSIF (Nvl(RegImp.Especial, 'N') = 'S') THEN
       Return('B'); -- El impuesto es incluido
     ELSE
       Genera_Error('No se puede determinar comportamiento del impuesto');
     END IF;
   END;
   --
   --
   FUNCTION EsRetencion(pCia   ARCGMC.no_cia%type,
                        pClave ARCGIMP.clave%type) RETURN BOOLEAN IS
   BEGIN
     IF NOT existe(pCia, pClave) THEN
        genera_error('No existe impuesto codigo: '||pClave);
     END IF;
     Return(NVL(RegImp.Ind_Retencion, 'N') = 'S');
   END;
   --
   --
   FUNCTION porcentaje(
     pCia         arcgmc.no_cia%type,
     pClave       arcgimp.clave%type,
     pId_Sec      arcgdisec.id_sec%type,
     pfec_doc     arcgimp.fec_desde%type default null
   ) RETURN number IS
     --
     -- Devuelve el porcentaje de impuesto asociado a la clave dada.
     -- La fecha se utiliza para determinar el % de impuesto en el historico.
     -- En caso de que la fecha sea nula, devuelve el % vigente.
     --
     vporcentaje   arcgimp.porcentaje%type;
     vExiste       Boolean;

     CURSOR c_imp_aplica IS
          SELECT *
              FROM arcghimp
          WHERE no_cia     = pCia
          AND clave      = pClave
          AND id_sec     = nvl(pId_Sec,'00000')
          AND fec_desde  = (SELECT max(fec_desde)
                              FROM arcghimp
                             WHERE no_cia     = pCia
                               AND clave      = pClave
                               AND id_sec     = nvl(pId_Sec,'00000')
                               AND fec_desde  <= pfec_doc);

   BEGIN
     IF NOT Existe(pCia, pClave,pfec_doc) THEN
        genera_error('No existe impuesto codigo: '||pClave);
     END IF;
     IF sectorizable(pCia, pClave, pfec_doc) THEN
        IF pid_sec IS NULL THEN
           genera_error('Impuesto: '||pClave||' requiere codigo de sectorizacion');
        ELSIF NOT Existe(pCia, pClave, pId_Sec, pfec_doc) THEN
           Genera_Error('No se han registrado datos para la sectorizacion: '||pid_sec);
        /*
        ELSIF nvl(RegImpSec.porcentaje,0) = 0 THEN
           Genera_Error('El porcentaje de impuesto es cero');*/
        END IF;
        vporcentaje := RegImpSec.porcentaje;
     ELSE
        /*IF nvl(RegImp.porcentaje,0) = 0 THEN
           Genera_Error('El porcentaje de impuesto es cero');
        END IF;*/
        vporcentaje := RegImp.porcentaje;
     END IF;

     if pfec_doc is not null then
       -- Obtiene el impuesto que aplica de acuerdo a
       -- la fecha del documento
         open c_imp_aplica;
         fetch c_imp_aplica into RegHimp;
         vExiste := c_imp_aplica%FOUND;
         close c_imp_aplica;
         if vExiste then
              -- Pasa los valores de porcentaje y fecha vigentes a la
              -- la fecha del documento
                 If RegImp.sectorizable = 'S' then
                      RegImpSec.fec_desde  := RegHimp.fec_desde;
                     RegImpSec.porcentaje := RegHimp.porcentaje;
                     vporcentaje := RegImpSec.porcentaje;
                 Else
                     RegImp.fec_desde  := RegHimp.fec_desde;
                     RegImp.porcentaje := RegHimp.porcentaje;
                     vporcentaje := RegHimp.porcentaje;
                 End if;
         end if; --existe
     end if;--pfec_doc
     RETURN (vporcentaje);
   END;
   --
   -- Funcion polimorfica

   FUNCTION  calcula(
     pCia             arcgmc.no_cia%type,
     pClave           arcgimp.clave%type,
     pMto_Gravado     number,
     pId_Sec          arcgdisec.id_sec%type,
     pFactor          number,
     pfec_doc         arcgimp.fec_desde%type
   ) RETURN number IS
     --
     -- Funcion que calcula el impuesto correspondiente a un monto dado (pMto_gravado). Todos
     -- los montos y calculos, se deben hacer en moneda nominal. Para eso se envia el parametro
     -- pFactor, el cual contiene 1 cuando el monto gravado viene en nominal o contiene un tipo de cambio
     -- cuanto el monto gravado viene en dolares.
     -- Al finalizar los calculos, el monto resultante debe convertirse a ese mismo factor, para
     -- regresarlo a la moneda original.
     --
     vPorcentaje      arcgimp.porcentaje%type;
     vCalculo         number;
   BEGIN
     IF NOT existe(pCia, pClave,pfec_doc) THEN
        genera_error('No existe el Impuesto o Retencion con codigo '||pClave);
     END IF;
     
     IF nvl(pFactor,0) <= 0 THEN
       genera_error('El factor dado para el calculo del impuesto, no puede ser cero o menor');
     END IF;

     IF sectorizable(pCia, pClave) THEN
       IF pid_sec IS NULL THEN
         genera_error('El Impuesto '||pClave||' requiere codigo de sectorizacion');
       ELSIF NOT Existe(pCia, pClave, pId_Sec) THEN
         genera_Error('No se han registrado datos para la sectorizacion '||pid_sec);
       END IF;
     END IF;
     vporcentaje := porcentaje(pCia, pClave, pId_Sec, pfec_doc);

     --
     
     if vporcentaje > 0 then
       -- calcula el impuesto en moneda nominal
       vCalculo    := calculo_general(pCia, pClave, pmto_gravado * pFactor, vPorcentaje);
       --
       -- segun el factor dado, convierte el impuesto calculado a la moneda original del monto gravado.
       vCalculo    := nvl(vCalculo, 0) / pFactor;
     else
       vCalculo    := 0;
     END IF;

     RETURN(vCalculo);
   END;
   --
   -- Funcion polimorfica
   FUNCTION  calcula(
     pCia               arcgmc.no_cia%type,
     pClave             arcgimp.clave%type,
     pMto_Gravado       number,
     pId_Sec            arcgdisec.id_sec%type,
     pFactor            number,
     pPorcentaje        number,  -- parametro con el porcentaje que se desea calcular el impuesto
     pfec_doc           arcgimp.fec_desde%type
   ) RETURN number IS
     --
     -- Funcion que calcula el impuesto correspondiente a un monto dado (pMto_gravado). Todos
     -- los montos y calculos, se deben hacer en moneda nominal. Para eso se envia el parametro
     -- pFactor, el cual contiene 1 cuando el monto gravado viene en nominal o contiene un tipo de cambio
     -- cuanto el monto gravado viene en dolares.
     -- Al finalizar los calculos, el monto resultante debe convertirse a ese mismo factor, para
     -- regresarlo a la moneda original.
     --
     vCalculo   number;
   BEGIN
     IF NOT existe(pCia, pClave,pfec_doc) THEN
       genera_error('No existe impuesto codigo: '||pClave);
     END IF;

     IF nvl(pFactor,0) <= 0 THEN
       genera_error('El factor dado para el calculo del impuesto, no puede ser cero o menor');
     END IF;

     IF sectorizable(pCia, pClave) THEN
       IF pid_sec IS NULL THEN
         genera_error('El Impuesto '||pClave||' requiere codigo de sectorizacion');
       ELSIF NOT Existe(pCia, pClave, pId_Sec) THEN
         genera_Error('No se han registrado datos para la sectorizacion '||pid_sec);
       END IF;
     END IF;

     --
     -- calcula el impuesto en moneda nominal
     vCalculo    := calculo_general(pCia, pClave, pmto_gravado * pFactor, pPorcentaje);

     --
     -- segun el factor dado, convierte el impuesto calculado a la moneda original del monto gravado.
     vCalculo    := nvl(vCalculo, 0) / pFactor;

     RETURN(vCalculo);
   END;
   --
   --
   FUNCTION  Trae_Datos(
     pCia         arcgmc.no_cia%type,
     pClave       arcgimp.clave%type,
     pId_Sec      arcgdisec.id_sec%type,
     pfec_doc     arcgimp.fec_desde%type default null
   ) RETURN datos_r IS
     rImpuestos    datos_r;
   BEGIN
     IF not existe(pCia, pClave, pfec_doc) THEN
        genera_error('No existe impuesto codigo: '||pClave);
     END IF;
     IF sectorizable(pCia, pClave, pfec_doc) THEN
        IF pid_sec IS NULL THEN
           genera_error('Impuesto: '||pClave||' requiere codigo de sectorizacion');
        ELSIF NOT Existe(pCia, pClave, pId_Sec) THEN
           genera_Error('No se han registrado datos para la sectorizacion: '||pid_sec);
        END IF;
     END IF;
     --
     rImpuestos.descripcion              := RegImp.Descripcion;
     rImpuestos.sectorizable            := RegImp.Sectorizable;
     rImpuestos.Columna             := RegImp.Columna;
     rImpuestos.Ind_Retencion       := RegImp.Ind_Retencion;
     rImpuestos.Certificado         := RegImp.Certificado;
     rImpuestos.Dias_Cred_Fiscal    := RegImp.Dias_Cred_Fiscal;
     rImpuestos.Base_Minima         := RegImp.Base_Minima;
     rImpuestos.Incluido            := RegImp.Incluido;
     rImpuestos.Especial            := RegImp.Especial;
     rImpuestos.ind_aplica_compras  := RegImp.ind_aplica_compras;
         rImpuestos.ind_aplica_servicios:= RegImp.ind_aplica_servicios;
         rImpuestos.ind_aplica_import   := RegImp.ind_aplica_import;
         rImpuestos.ind_aplica_exportac := RegImp.ind_aplica_exportac;
     --
     IF RegImp.Sectorizable = 'S' THEN
         rImpuestos.Porcentaje   := RegImpSec.Porcentaje;
         rImpuestos.Cuenta       := RegImpSec.Cuenta_contable;
         rImpuestos.Pais         := RegImpSec.Pais;
         rImpuestos.Provincia    := RegImpSec.Provincia;
         rImpuestos.Canton       := RegImpSec.Canton;
         rImpuestos.Sector       := RegImpSec.Sector;
         rImpuestos.Actividad    := RegImpSec.Actividad;
         rImpuestos.Id_Sec       := RegImpSec.Id_Sec;
     ELSE
         rImpuestos.Porcentaje   := RegImp.Porcentaje;
         rImpuestos.Cuenta       := RegImp.Cuenta;
         rImpuestos.Pais         := NULL;
         rImpuestos.Provincia    := NULL;
         rImpuestos.Canton       := NULL;
         rImpuestos.Sector       := NULL;
         rImpuestos.Actividad    := NULL;
         rImpuestos.Id_Sec       := NULL;
      END If;
      Return ( rImpuestos );
   END;
   --
   --
   FUNCTION vencido (
     pCia         arcgimp.no_cia%type,
     pClave       arcgimp.clave%type,
     pFecha_Doc   date,
     pFecha_Cont  date
   ) RETURN boolean IS
     -- --
     --   Para el mes en proceso Se tiene:
     --   Si Fecha_Contabilizacion)-Ultimo_Dia(Fecha_Factura) <= Parametro      APLICA
     --   Si Fecha_Contabilizacion)-Ultimo_Dia(Fecha_Factura)  > Parametro   NO APLICA
   BEGIN
     IF NOT existe(pCia, pClave) THEN
        genera_error('No existe impuesto codigo: '||pClave);
     END IF;
     IF (pFecha_Cont - Last_Day(pFecha_Doc)) <= nvl(RegImp.Dias_Cred_Fiscal, 999) THEN
         RETURN(FALSE);
     ELSE
         RETURN(TRUE);
     END IF;
   END;
   --
   FUNCTION  cta_contable(
     pCia         arcgmc.no_cia%type,
     pClave       arcgimp.clave%type,
     pId_Sec      arcgdisec.id_sec%type
   ) RETURN varchar2 IS
     vCta_conta    arcgimp.cuenta%type;
   BEGIN
     IF NOT existe(pCia, pClave) THEN
        genera_error('No existe impuesto codigo: '||pClave);
     END IF;
     IF NOT sectorizable(pCia, pClave) THEN
       vcta_conta := RegImp.cuenta;
     ELSE
        IF pid_sec IS NULL THEN
           genera_error('Impuesto: '||pClave||' requiere codigo de sectorizacion');
        ELSIF NOT Existe(pCia, pClave, pId_Sec) THEN
           genera_Error('No se han registrado datos para la sectorizacion: '||pid_sec);
        END IF;
        vcta_conta := RegImpSec.cuenta_contable;
     END IF;
     Return( vcta_conta);
   END;
   --

   FUNCTION  calcula_base(pCia             arcgmc.no_cia%type,
                                 pClave           arcgimp.clave%type,
                                 pMto_Gravado     number,
                                 pMto_bienes      number,
                                 pMto_servicios   number,
                                 pMto_importacion number,
                                 pMto_exportacion number,
                                 pId_Sec          arcgdisec.id_sec%type,
                                 pfec_doc         arcgimp.fec_desde%type) RETURN NUMBER IS
   --
   vbase number :=0;

   BEGIN

       IF NOT existe(pCia, pClave,pfec_doc) THEN
        genera_error('No existe impuesto codigo: '||pClave);
    END IF;

    IF sectorizable(pCia, pClave) THEN
      IF pid_sec IS NULL THEN
        genera_error('Impuesto: '||pClave||' requiere codigo de sectorizacion');
      ELSIF NOT Existe(pCia, pClave, pId_Sec) THEN
        genera_Error('No se han registrado datos para la sectorizacion: '||pid_sec);
      END IF;
    END IF;

    IF nvl(pMto_bienes,0)      = 0    AND  nvl(pMto_servicios,0)  = 0 AND
         nvl(pMto_importacion,0) = 0  AND  nvl(pMto_exportacion,0)= 0 THEN

         return(NVL(pMto_Gravado,0));

    ELSE

        IF RegImp.ind_aplica_compras = 'S' THEN
       vbase:=     vbase + nvl(pMto_bienes,0);
        END IF;

        IF RegImp.ind_aplica_servicios = 'S' THEN
       vbase:=     vbase + nvl(pMto_Servicios,0);
        END IF;

        IF RegImp.ind_aplica_import = 'S' THEN
       vbase:=     vbase + nvl(pMto_Importacion,0);
        END IF;

        IF RegImp.ind_aplica_exportac = 'S' THEN
       vbase:=     vbase + nvl(pMto_exportacion,0);
        END IF;

        RETURN(vbase);

    END IF;

   END;
END;   -- BODY impuesto
/