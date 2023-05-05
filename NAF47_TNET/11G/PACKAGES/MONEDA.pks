CREATE OR REPLACE PACKAGE            Moneda AS
   -- ---
   --
   PROCEDURE Inicializa(pCia  Varchar2);
   PROCEDURE Inicializa_Datos_Redondeo(pCia Varchar2);
   PROCEDURE Obtiene_datos(pMoneda   IN  Varchar2,
                           pRedondeo OUT Number,
                           pNumDeci  OUT Number);
   FUNCTION  Redondeo(pnumero in Number,
                      pMoneda in Varchar2) RETURN number;
   FUNCTION  Redondea_prorrateo(pnumero in Number,
                                pMoneda in Varchar2,
                                pPrecision_acum in out number) RETURN number;
   FUNCTION  Obtiene_Mascara(pLargo   in number,
                             pnumdeci in number) RETURN varchar2;
   --
   FUNCTION  Simbolo(pCia    in varchar2,
                     pMoneda in varchar2) RETURN varchar2;
   FUNCTION  Nombre(pCia     in varchar2,
                    pMoneda  in varchar2) RETURN varchar2;
   --
   -- ---
   -- Define restricciones de procedimientos y funciones
   --    WNDS = Writes No Database State
   --    RNDS = Reads  No Database State
   --    WNPS = Writes No Package State
   --    RNPS = Reads  No Package State
   PRAGMA RESTRICT_REFERENCES(inicializa, WNDS);
   PRAGMA RESTRICT_REFERENCES(inicializa_Datos_redondeo, WNDS);
   PRAGMA RESTRICT_REFERENCES(simbolo, WNDS);
   PRAGMA RESTRICT_REFERENCES(nombre, WNDS);
   PRAGMA RESTRICT_REFERENCES(redondeo, WNDS);
END moneda;
/


CREATE OR REPLACE PACKAGE BODY            Moneda IS
   /*******[ PARTE: PRIVADA ]
   * Declaracion de Procedimientos o funciones PRIVADOS
   *
   */
   gno_cia              ARCGMC.NO_CIA%TYPE;
   vFactor_Redondeo_MR  NUMBER;
   vFactor_Redondeo_OM  NUMBER;
   vQdecimales_MR       NUMBER;
   vQdecimales_OM       NUMBER;
   vSimbolo_MP          VARCHAR2(3);          -- Simbolo Moneda "P"
   vNombre_MP           VARCHAR2(15);         -- Nombre Moneda "P"
   --
   -- --
   -- Valida si el paquete ya fue inicializado
   FUNCTION inicializado(pCia varchar2) RETURN BOOLEAN IS
   BEGIN
      RETURN ( nvl(gno_cia,'*NULO*') = pCia);
   END inicializado;
   --
   -- --
   PROCEDURE trae_datos_moneda(
     pNo_Cia   IN  Varchar2,
     pMoneda   IN  Varchar2,
     pRedondeo OUT Number,
     pNumDeci  OUT Number
   ) IS
     vRedondeo     monedas.redondeo%type;
     vdecimal      varchar2(4);
     vdesc_moneda  monedas.desc_moneda%type;
     vSimbolo      monedas.signo%type;
     CURSOR trae_factor IS
       SELECT mo.redondeo, substr(to_char(mo.redondeo,'000.00'),-2),
              mo.desc_moneda, mo.signo
         FROM monedas mo, arcgmc mc
        WHERE mc.no_cia    = pno_cia
          AND mo.id_moneda = mc.mon_reg_cont;
   BEGIN
     IF pMoneda = 'P' THEN
        OPEN trae_factor;
        FETCH trae_factor into vredondeo, vdecimal, vDesc_moneda, vSimbolo;
        CLOSE trae_factor;
        IF substr(vdecimal,2,1) <> '0' then
           pnumdeci := 2;
        ELSIF substr(vdecimal,1,1) <> '0' then
           pnumdeci := 1;
        ELSE
           pnumdeci := 0;
        END IF;
        pRedondeo   := vRedondeo;
        vSimbolo_MP := vSimbolo;
        vNombre_MP  := Substr(vDesc_moneda,1,15);
     ELSE
        -- Dolares
        pRedondeo := 0.01;
        pNumDeci  := 2;
     END IF;
   END;
   --
   --
   /*******[ PARTE: PUBLICA ]
   * Declaracion de Procedimientos o funciones PUBLICAS
   *
   */
   -- ---
   -- Sube la informacion sobre la moneda de la compa?ia indicada
   PROCEDURE Inicializa(pCia Varchar2)IS
   BEGIN
      gNo_cia := pCia;
      trae_datos_moneda(pCia, 'D', vFactor_Redondeo_OM, vQdecimales_OM);
      trae_datos_moneda(pCia, 'P', vFactor_Redondeo_MR, vQdecimales_MR);
   END;
   --
   -- ---
   -- Llama al procedimiento inicializa
   PROCEDURE Inicializa_Datos_redondeo (pCia Varchar2)IS
   BEGIN
      Inicializa(pCia);
   END;
   --
   -- --
   -- Devuelve el factor de redondeo y la cant. de decimales de la moneda
   -- REQUIERE: Que el paquete haya sido inicializado
   PROCEDURE obtiene_datos(
     pMoneda   IN  Varchar2,
     pRedondeo OUT Number,
     pNumDeci  OUT Number
   ) IS
   BEGIN
     IF pMoneda = 'D' THEN
        pRedondeo := vFactor_Redondeo_OM;
        pNumDeci  := vQdecimales_OM;
     ELSE
        pRedondeo := vFactor_Redondeo_MR;
        pNumDeci  := vQdecimales_MR;
     END IF;
   END;
   --
   -- --
   FUNCTION Redondeo(pNumero IN Number,
                     pMoneda IN Varchar2
   ) RETURN number
   IS
     vResultado   Number;
     vFactor      Number;
   BEGIN
     IF pMoneda = 'D' THEN
        vFactor := vFactor_Redondeo_OM;
     ELSE
        vFactor := vFactor_Redondeo_MR;
     END IF;
     IF NVL(vFactor,0) = 0 then
        return( nvl(pnumero,0) );
     ELSE
        vResultado := round(pNumero/vFactor,0) * vfactor;
        RETURN( nvl(vresultado,0) );
     END IF;
   END;
   --
   -- --
   FUNCTION Redondea_prorrateo(
     pNumero          IN Number,
     pMoneda          IN Varchar2,
     pPrecision_acum  IN OUT Number
   ) RETURN number
   IS
     -- --
     -- El funcion maneja el problema de la perdida de decimales por precision,
     -- que se presenta comunmente en prorrateo de un monto global, entre las
     -- lineas que compone un detalle.
     -- Para cumplir con ese objetivo se lleva un acumulado de los decimales
     -- perdidos o tomados de mas, de forma que cuando el redondeo del acumulado
     -- alcance el factor de redondeo, se le suma o resta al monto
     -- que se esta redondeando.
     --
     -- ejemplo:
     -- Prorrateo del descuento global de una compra entre las lineas de la factura
     -- precision: de 0.01 (2 decimales)
     -- descuento general del 10.00
     -- DETALLE:
     --
     --  Precision           |             -- prorrateo --       decimales   decimales
     --  acum.Anter redondeo | linea monto sin Red. Redond.      perdidos    acumulados
     --  ---------- -------- | ----- ----- -------- --------     ----------  ----------
     --   0           0.00   |  [1]   100   3.33333   3.33        0.00333..   0.00333..
     --   0.00333..   0.00   |  [2]   100   3.33333   3.33        0.00333..   0.00666..
     --   0.00666..   0.01   |  [3]   100   3.33333   3.33+0.01  -0.00667..  -0.00001..
     --
     --
     vResultado   Number;
     vResiduo     Number;
     vAjuste      Number;
     vFactor      Number;
   BEGIN

     IF pMoneda = 'D' THEN
        vFactor := vFactor_Redondeo_OM;
     ELSE
        vFactor := vFactor_Redondeo_MR;
     END IF;
     IF vFactor  = 0 then
        return(pnumero);
     ELSE
        vResultado  := nvl(round(pNumero/vFactor,0) * vfactor, 0);
        vAjuste     := nvl(round(pPrecision_acum/vFactor,0) * vFactor, 0);
        if vAjuste != 0 then
           vResultado  := vResultado + vAjuste;
        end if;
        vResiduo        := nvl(pNumero - vResultado,0);
        pPrecision_acum := nvl(pPrecision_acum, 0) + vResiduo;
        RETURN(vresultado);
     END IF;
   END;
   --
   --
   FUNCTION Obtiene_mascara (
     pLargo   in number,
     pnumdeci in number
   ) RETURN varchar2
   IS
      vformato    varchar2(25);
      vLargoAux   number       := pLargo;
   BEGIN
      IF pNumDeci = 0 THEN
         vFormato := substr('999G999G999G999G999G999', -vLargoAux, vLargoAux);
      ELSIF pNumDeci > 0 THEN
         vLargoAux := vLargoAux - (pNumDeci + 1);
         vFormato  := substr('999G999G999G999G999G999', -vLargoAux, vLargoAux); -- enteros
         vFormato  := vFormato ||'D'|| SUBSTR('999999',1,pNumDeci);      -- decimales
      END IF;
      -- Quita la G si es el primer caracter en el formato
      vFormato := ltrim(vFormato,'G');
      Return(vformato);
   END;
   --
   --
   FUNCTION  Simbolo(
     pCia    in varchar2,
     pMoneda in varchar2
   ) RETURN varchar2
   IS
   BEGIN
     if not inicializado(pCia) then
        inicializa(pCia);
     end if;
     if pMoneda = 'P' then
        return( vSimbolo_MP);
     else
        return( '$us' );
     end if;
   END;
   --
   --
   FUNCTION  Nombre(
     pCia     in varchar2,
     pMoneda  in varchar2
   ) RETURN varchar2
   IS
   BEGIN
     if not inicializado(pCia) then
        inicializa(pCia);
     end if;
     if pMoneda = 'P' then
        return( InitCap(vNombre_MP) );
     else
        return( 'Dolares' );
     end if;
   END;
END moneda;
/
