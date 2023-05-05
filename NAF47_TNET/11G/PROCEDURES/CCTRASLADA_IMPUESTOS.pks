create or replace PROCEDURE            CCTRASLADA_IMPUESTOS
 (PCIA IN VARCHAR2
 ,PNO_TRANSA IN VARCHAR2
 ,PERROR IN OUT VARCHAR2
 )
 IS
-- PL/SQL Specification
Cursor c_Fecha IS
   Select fecha
     From arccmd
    Where No_Cia = pCia
      And No_Docu = pNo_Transa;
Cursor c_Sectores IS
   Select distinct Id_Sec, Clave
     From arccti
    Where No_Cia = pCia
      And No_Docu = pNo_Transa
      And Id_Sec IS NOT NULL;
Cursor c_Ubica (pclave Varchar2, pId_sec Varchar2) IS
   Select pais,     provincia, canton,
          sector,   actividad
     from arcgdisec
    where no_cia = pCia
      and clave  = pClave
      and id_sec = pId_Sec;
--
----
--
vFecha         arccmd.fecha%type;
vReg_Ubica     c_Ubica%rowtype;
vExiste        Boolean;
Error_Proceso  Exception;
--

-- PL/SQL Block
BEGIN
   Open c_Fecha;
   Fetch c_Fecha INTO vFecha;
   vExiste := c_Fecha%FOUND;
   Close c_Fecha;
   IF NOT vExiste THEN
      pError := 'ERROR : CC_Traslada_Impuesto - Documento no localizado';
      Raise  Error_Proceso;
   END IF;
   Insert into arcglimp (No_Cia,         No_Transa,   Codigo_Tercero,
                         Clave,          Id_Sec,      Porcentaje,
                         Base,           Fecha,       Monto,
                         No_Refe,        Ind_Imp_Ret, Aplica_Cred_Fiscal,
                         Comportamiento)
                 (Select pCia,           pNo_Transa,  Codigo_Tercero,
                         Clave,          Id_Sec,      Porcentaje,
                         Base,           vFecha,      Monto,
                         No_Refe,        Ind_Imp_Ret, Aplica_Cred_Fiscal,
                         Comportamiento
                    From arccti
                   Where no_cia = pcia
                     And no_docu = pNo_Transa);
   --
   For vSec IN c_Sectores LOOP
      Open  c_Ubica (vSec.clave, vSec.Id_Sec);
      Fetch c_Ubica INTO vReg_Ubica;
      vExiste := c_Ubica%FOUND;
      Close c_Ubica;
      IF NOT vExiste THEN
         pError := 'ERROR : CC_Traslada_Impuesto - Sectorizacion no localizada';
         Raise  Error_Proceso;
      ELSE
         Update arcglimp
            set pais      = vReg_Ubica.pais,
                provincia = vReg_Ubica.provincia,
                canton    = vReg_Ubica.canton,
                sector    = vReg_Ubica.sector,
                actividad = vReg_Ubica.actividad
           Where no_cia    = pCia
             And No_Transa = pNo_Transa
             And clave     = vSec.clave
             And Id_Sec    = vSec.id_Sec;
      END IF;
   END LOOP;
   --
EXCEPTION
  WHEN Error_Proceso THEN
     pError := nvl(pError, 'ERROR : CC_Traslada_Impuesto - '||SQLERRM);
  WHEN OTHERS THEN
     pError := 'ERROR : CC_Traslada_Impuesto - '||SQLERRM;
END;