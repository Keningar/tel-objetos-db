create or replace PROCEDURE            CPTraslada_Impuestos (
  pCia       IN     Varchar2,
  pNo_Transa IN     Varchar2,
  pError     IN OUT Varchar2
) IS
  --
  -- Carga o actualiza el libro de impuestos.

  --
  CURSOR c_datos_doc IS
    SELECT md.fecha, td.tipo_mov,
           cplib.comportamiento_imp(td.no_cia, td.tipo_doc) comportamiento_imp,
           md.moneda, md.tipo_cambio
      FROM arcpmd md, arcptd td
     WHERE md.no_Cia   = pCia
       AND md.no_docu  = pNo_Transa
       AND td.no_cia   = md.no_cia
       AND td.tipo_doc = md.tipo_doc;

   CURSOR c_datos_imp IS
     SELECT distinct no_transa no_transa
       FROM arcglimp imp
       where no_cia=pCia
       and No_transa = pNo_Transa;
  --
  CURSOR c_Sectores IS
    SELECT DISTINCT Id_Sec, Clave
      FROM arcpti
     WHERE No_Cia = pCia
       AND No_Docu = pNo_Transa
       AND Id_Sec IS NOT NULL;
  --
  CURSOR c_Ubica (pclave Varchar2, pId_sec Varchar2) IS
    SELECT pais,     provincia, canton,
           sector,   actividad
      FROM arcgdisec
     WHERE no_cia = pCia
       AND clave  = pClave
       AND id_sec = pId_Sec;
  --
  --
  vFecha          arcpmd.fecha%type;
  vReg_Ubica      c_Ubica%rowtype;
  vExiste         boolean;
  vExisteimp      boolean;
  error_proceso   exception;
  vMoneda         arcglimp.moneda%type;
  vTipo_cambio    arcglimp.tipo_cambio%type;
  --
  vtipo_mov       arcptd.tipo_mov%type;
  vcomport_imp    VARCHAR2(1);
  vsigno          number;
  vtransa       arcglimp.no_transa%type;
  --
BEGIN
   OPEN  c_datos_doc;
   FETCH c_datos_doc INTO vFecha, vtipo_mov, vcomport_imp, vMoneda, vTipo_cambio;
   vExiste := c_datos_doc%FOUND;
   CLOSE c_datos_doc;

   IF not vExiste THEN
      pError := 'ERROR : CP_Traslada_Impuesto - Documento no localizado';
      RAISE  Error_Proceso;
   END IF;

   --
   -- Determina el comportamiento de los impuestos y retenciones en el documento
   vsigno := 1;
   IF (vtipo_mov = 'D' and vcomport_imp = 'S') OR
      (vtipo_mov = 'C' and vcomport_imp = 'R') THEN
     --
     -- En estos casos indican que el tipo de documento es utilizado para reversion por lo que
     -- los montos se trasladan negativo al libro de impuestos.
     vsigno := -1;
   END IF;

   OPEN c_datos_imp;
    FETCH c_datos_imp INTO vtransa;
    vExisteimp := c_datos_imp%FOUND;
   CLOSE c_datos_imp;
   If vexisteimp then
    Delete arcglimp where no_Cia= pCia and no_transa=pno_Transa;
   End if;
   INSERT INTO arcglimp (No_Cia,         No_Transa,   Codigo_Tercero,
                         Clave,          Id_Sec,      Porcentaje,
                         Base,           Fecha,       Monto,       moneda, tipo_cambio,
                         No_Refe,        Ind_Imp_Ret, Aplica_Cred_Fiscal,
                         Comportamiento)
                 (SELECT pCia,           pNo_Transa,  Codigo_Tercero,
                         Clave,          Id_Sec,      Porcentaje,
                         Base,           vFecha,      (Monto * vsigno), vMoneda, vTipo_cambio,
                         No_Refe,        Ind_Imp_Ret, Aplica_Cred_Fiscal,
                         Comportamiento
                    FROM arcpti
                   WHERE no_cia = pcia
                     AND no_docu = pNo_Transa);

   --
   FOR vSec IN c_Sectores LOOP
     OPEN  c_Ubica (vSec.clave, vSec.Id_Sec);
     FETCH c_Ubica INTO vReg_Ubica;
     vExiste := c_Ubica%FOUND;
     CLOSE c_Ubica;

     IF not vExiste THEN
       pError := 'ERROR : CP_Traslada_Impuesto - Sectorizacion no localizada';
       RAISE  Error_Proceso;
     ELSE
       --
       -- Actualiza datos del sector.
       UPDATE arcglimp
          SET pais      = vReg_Ubica.pais,
              provincia = vReg_Ubica.provincia,
              canton    = vReg_Ubica.canton,
              sector    = vReg_Ubica.sector,
              actividad = vReg_Ubica.actividad
        WHERE no_cia    = pCia
          AND No_Transa = pNo_Transa
          AND clave     = vSec.clave
          AND Id_Sec    = vSec.id_Sec;
      END IF;
   END LOOP;
   --
EXCEPTION
  WHEN Error_Proceso THEN
     pError := nvl(pError, 'ERROR : CP_Traslada_Impuesto - '||SQLERRM);
  WHEN OTHERS THEN
     pError := 'ERROR : CP_Traslada_Impuesto - '||SQLERRM;
END;