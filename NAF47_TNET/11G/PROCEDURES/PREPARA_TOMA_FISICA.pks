create or replace PROCEDURE            PREPARA_TOMA_FISICA (cia_p          varchar2,
                                                 centro_p       varchar2,
                                                 PARTII         varchar2,
                                                 PARTIF         varchar2,
                                                 bod_ini_p      varchar2,
                                                 PMARCA         varchar2,
                                                 PACTIVO        varchar2,
                                                 PPUBLICIDAD    varchar2,
                                                 PCLASE         Varchar2,
                                                 PCATEGORIA     Varchar2,
                                                 pcuenta    out number) IS

  -- Este procedimiento se encarga preparar los articulos para la
  -- toma fisica, esto es en el campo EXIST_PREP deja el saldo actual,
  -- en COSTO_PREP el costo unitario y el indicador PROCESO_TOMA en 'S'
  -- Toma los articulos que se prepararon para la toma fisica y los almacena
  -- en la tabla ARINTF y los que poseen lotes en la tabla ARINTFLO
  --
 -- vtipo_bodega   arinbo.tipoBodega%type   := 'A';
  vgrp_conta     arinda.grupo%type;
  vcosto         arinma.costo_uni%type;
  --
  CURSOR c_arti_prep IS
  SELECT a.no_cia, a.bodega, D.clase, D.categoria, a.no_arti, d.grupo grupo_contable
    FROM arinbo b, arinda d, arinma a
   WHERE b.centro     = centro_p
     AND b.tipobodega = 'A'
     AND d.marca LIKE (NVL(Pmarca,'%'))
     AND (d.NO_aRTI between  NVL(PARTII,'0')
     and NVL(PARTIF,'ZZZZZZZZZZ'))
     AND D.CLASE LIKE NVL(PCLASE,'%')
     AND D.CATEGORIA LIKE NVL(PCATEGORIA,'%')
     AND a.no_cia    = cia_p
     AND a.bodega   = bod_ini_p
     AND b.no_cia    = a.no_cia
     AND b.codigo    = a.bodega
     AND d.no_cia    = a.no_cia
     AND d.no_arti   = a.no_arti
     AND d.ind_activo = pactivo
     AND nvl(a.proceso_toma,'N') = 'N'
     AND ACTIVO = 'S';


 CURSOR c_arti_prepP IS
      SELECT a.no_cia, a.bodega, D.clase, D.categoria, a.no_arti,
                      d.grupo grupo_contable
      FROM arinbo b, arinda d, arinma a
      WHERE b.centro     = centro_p
      AND b.tipobodega = 'A'
       AND (d.NO_aRTI between NVL(PARTII,'0') and NVL(PARTIF,'ZZZZZZZZZ'))
       AND a.no_cia    = cia_p
       AND a.bodega   = bod_ini_p
       AND b.no_cia    = a.no_cia
       AND b.codigo    = a.bodega
       AND d.no_cia    = a.no_cia
       AND d.no_arti   = a.no_arti
       AND nvl(a.proceso_toma,'N') = 'N';

CURSOR c_tot IS
SELECT count(a.no_arti)
  FROM arinbo b, arinda d, arinma a
 WHERE b.centro     = centro_p
   AND b.tipobodega = 'A'
   AND (d.NO_aRTI between   NVL(PARTII,'0') and  NVL(PARTIF,'ZZZZZZZZZ'))
   AND a.no_cia    = cia_p
   AND a.bodega   = bod_ini_p
   AND b.no_cia    = a.no_cia
   AND b.codigo    = a.bodega
   AND d.no_cia    = a.no_cia
   AND d.no_arti   = a.no_arti
   AND d.ind_activo = pactivo
   AND nvl(a.proceso_toma,'N') = 'N';

 CURSOR c_totp IS
 SELECT count(a.no_arti)
   FROM arinbo b, arinda d, arinma a
  WHERE b.centro     = centro_p
    AND b.tipobodega = 'A'
    AND (d.no_arti between   NVL(PARTII,'0')
    AND nvl(partif , 'ZZZZZZZZZ'))
    AND a.no_cia    = cia_p
    AND a.bodega   = bod_ini_p
    AND b.no_cia    = a.no_cia
    AND b.codigo    = a.bodega
    AND d.no_cia    = a.no_cia
    AND d.no_arti   = a.no_arti
    AND d.ind_activo = pactivo
    AND nvl(a.proceso_toma,'N') = 'N';

  CURSOR C_ULT_MOV IS
  SELECT MAX(NO_DOCU)
    FROM ARINMN
   WHERE FECHA IN (SELECT MAX(FECHA)
                     FROM ARINMN
                    WHERE NO_CIA = CIA_P);



  ERROR_ARINMA    Exception;
  BODEGA          Varchar2(6);
  ULT_MOV         Varchar2(12);
  CUENTA          Number:=0;
  total           Number:=0;
  ln_costo2       Number(17,2):=0;

----------------------------------
BEGIN
  ---
  OPEN C_ULT_MOV;
  FETCH C_ULT_MOV INTO ULT_MOV;
  CLOSE C_ULT_MOV;
  ---
  IF Ppublicidad != 'P' THEN
    FOR c IN c_arti_prep LOOP
   	    	CUENTA:=CUENTA+1;

     IF vgrp_conta is null or vgrp_conta != c.grupo_contable THEN
        -- Obtiene el metodo de costeo para el grupo del articulo actual.
        vcosto := articulo.costo(c.no_cia, c.no_arti, c.bodega);
        Ln_costo2 := articulo.costo2(c.no_cia, c.no_arti, c.bodega);
        --
        BEGIN

        UPDATE arinma
           SET exist_prep   = NVL(SAL_ANT_UN,0) + NVL(COMP_UN,0)+ NVL(OTRS_UN,0)-
                              NVL(VENT_UN,0)    - NVL(CONS_UN,0),
               costo_prep   = vcosto,
               proceso_toma = 'S'
         WHERE no_cia    = c.no_cia
           AND bodega    = c.bodega
           AND no_arti   = c.no_arti;

         END;
         --
        --Inserta los articulos preparados para la toma fisica en la tabla ARINTF
        INSERT INTO arintf (no_cia, no_toma, bodega, no_arti,  tom_fisic)--,ult_movimiento)--,usuario)
         values (c.no_cia,1,c.bodega,c.no_arti,null);--,ult_mov);--,user);
      END IF;
    END LOOP;
  ELSE
  FOR c IN c_arti_prepP LOOP


  	CUENTA:=CUENTA+1;

      IF vgrp_conta is null or vgrp_conta != c.grupo_contable THEN
        -- Obtiene el metodo de costeo para el grupo del articulo actual.
        vcosto := articulo.costo(c.no_cia, c.no_arti, c.bodega);
        Ln_costo2 := articulo.costo2(c.no_cia, c.no_arti, c.bodega); --FEM
        --
        UPDATE arinma
           SET exist_prep   = NVL(SAL_ANT_UN,0) + NVL(COMP_UN,0)+ NVL(OTRS_UN,0)-
                              NVL(VENT_UN,0)    - NVL(CONS_UN,0),
               costo_prep   = vcosto,
               proceso_toma = 'S'
         WHERE no_cia    = c.no_cia
           AND bodega    = c.bodega
           AND no_arti   = c.no_arti;

         --
        --Inserta los articulos preparados para la toma fisica en la tabla ARINTF


        INSERT INTO arintf (no_cia, no_toma, bodega, no_arti, tom_fisic)--,ult_movimiento,usuario)
             values (c.no_cia,1,c.bodega,c.no_arti,null);--,ult_mov,user);
        --
        UPDATE arinlo
           SET exist_prep   = saldo_unidad,
               costo_prep   = vcosto,
               proceso_toma = 'S'
         WHERE no_cia    = cia_p
           AND bodega    = c.bodega
           AND no_arti   = c.no_arti;
        --
        --Inserta los articulos con lotes preparados para la toma fisica en la tabla ARINTFLO
        INSERT INTO arintflo (no_cia, no_toma, bodega, no_arti, no_lote, tom_fisic)
             SELECT no_cia, 1, bodega, no_arti, no_lote, null
               FROM arinlo
              WHERE no_cia    = c.no_cia
                AND bodega    = c.bodega
                AND no_arti   = c.no_arti;
        --
      END IF;
    END LOOP;
    END IF;
       pcuenta:=cuenta;
 EXCEPTION
 WHEN articulo.error THEN
       ROLLBACK;
  WHEN OTHERS THEN
       ROLLBACK;
END;