CREATE OR REPLACE package NAF47_TNET.PRKG_CONSULTA is


  /**
  * Documentacion para F_DESCRIPCION_INDIVIDUAL 
  * Función que retorna la descripción del tipo de centro de costos.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 09/09/2020
  *
  * @param Pn_TipoCCosto   IN NUMBER Recibe código de tipo de centro de costo a consultar
  * @param Pv_ReferenciaId IN VARCHAR2 Recibe Código de referencia a consultar
  * @param Pv_RefEmpresaId IN VARCHAR2 Recibe Código de empresa a consultar
  */
  FUNCTION F_DESCRIPCION_INDIVIDUAL (Pn_TipoCCosto   IN NUMBER,
                                     Pv_ReferenciaId IN VARCHAR2,
                                     Pv_RefEmpresaId IN VARCHAR2) RETURN VARCHAR2;
  --
  /**
  * Documentacion para F_DESCRIPCION_CCOSTO 
  * Función que retorna la descripción del tipo de centro de costos y las concatena.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 09/09/2020
  *
  * @param Pn_CCostoId IN NUMBER Recibe código centro de costo a consultar
  */
  FUNCTION F_DESCRIPCION_CCOSTO (Pn_CCostoId IN NUMBER) RETURN VARCHAR2;
  --
end PRKG_CONSULTA;
/

CREATE OR REPLACE package body NAF47_TNET.PRKG_CONSULTA is

  FUNCTION F_DESCRIPCION_INDIVIDUAL (Pn_TipoCCosto   IN NUMBER,
                                     Pv_ReferenciaId IN VARCHAR2,
                                     Pv_RefEmpresaId IN VARCHAR2) RETURN VARCHAR2 IS
    --
    CURSOR C_TIPO_CENTRO_COSTO IS
      SELECT APD.ID_PARAMETRO_DET AS ID_TIPO_CCOSTO,
             APD.VALOR2 AS DESCRIPCION,
             APD.VALOR3 AS NIVEL,
             APD.VALOR4 AS GENERA_COSTO,
             APD.EMPRESA_COD,
             (SELECT VALOR1
              FROM DB_GENERAL.ADMI_PARAMETRO_DET DS
              WHERE DS.DESCRIPCION = 'DETALLE_SENTENCIA'
              AND DS.VALOR3 = 'CONSULTA_INDIVIDUAL'
              AND EXISTS (SELECT NULL 
                          FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                          WHERE APC.NOMBRE_PARAMETRO = 'CONTROL_PRESUPUESTO'
                          AND APC.ID_PARAMETRO = APD.PARAMETRO_ID)
              AND DS.VALOR2 = TO_CHAR(APD.ID_PARAMETRO_DET)) AS SENTENCIA_PROCESA_DATOS
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.ID_PARAMETRO_DET = Pn_TipoCCosto;
    --
    Lr_TipoCentroCosto C_TIPO_CENTRO_COSTO%ROWTYPE;
    Lv_Descripcion     VARCHAR2(3000) := NULL;
    Lc_Datos           SYS_REFCURSOR;
    --
  BEGIN
    IF C_TIPO_CENTRO_COSTO%ISOPEN THEN
      CLOSE C_TIPO_CENTRO_COSTO;
    END IF;
    OPEN C_TIPO_CENTRO_COSTO;
    FETCH C_TIPO_CENTRO_COSTO INTO Lr_TipoCentroCosto;
    IF C_TIPO_CENTRO_COSTO%NOTFOUND THEN
      Lr_TipoCentroCosto := NULL;
    END IF;
    CLOSE C_TIPO_CENTRO_COSTO;
    --
    IF Lr_TipoCentroCosto.Sentencia_Procesa_Datos IS NULL THEN
      Lv_Descripcion := 'No se ha definido sentencia de consulta para proceso de datos, favor revisar!!!';
      RETURN Lv_Descripcion;
    END IF;
    --
    --
    OPEN Lc_Datos FOR Lr_TipoCentroCosto.Sentencia_Procesa_Datos 
      USING Pv_ReferenciaId,
            Pv_RefEmpresaId;
    --
    FETCH Lc_Datos into Lv_Descripcion;
    CLOSE Lc_Datos;
    --
    RETURN Lv_Descripcion;
    --
  END;
  --
  --
  FUNCTION F_DESCRIPCION_CCOSTO (Pn_CCostoId IN NUMBER) RETURN VARCHAR2 IS
    --
    CURSOR C_DETALLE_CCOSTO IS
      SELECT PCCD.TIPO_CENTRO_COSTO,
             PCCD.REFERENCIA_ID,
             PCCD.EMPRESA_REFERENCIA_ID
      FROM PR_CENTRO_COSTO_DETALLE PCCD
      WHERE PCCD.CENTRO_COSTO_ID = Pn_CCostoId;
    --
    Lv_Descripcion  VARCHAR2(3000);
    --
  BEGIN
    --
    FOR Lr_DetCCosto IN C_DETALLE_CCOSTO LOOP
      --
      IF Lv_Descripcion IS NULL THEN
        Lv_Descripcion := NAF47_TNET.PRKG_CONSULTA.F_DESCRIPCION_INDIVIDUAL( Lr_DetCCosto.TIPO_CENTRO_COSTO,
                                                                             Lr_DetCCosto.REFERENCIA_ID,
                                                                             Lr_DetCCosto.EMPRESA_REFERENCIA_ID );
      ELSE
        Lv_Descripcion := Lv_Descripcion ||' - '|| 
                          NAF47_TNET.PRKG_CONSULTA.F_DESCRIPCION_INDIVIDUAL( Lr_DetCCosto.TIPO_CENTRO_COSTO,
                                                                             Lr_DetCCosto.REFERENCIA_ID,
                                                                             Lr_DetCCosto.EMPRESA_REFERENCIA_ID );
      END IF;
      --
    END LOOP;
    --
    RETURN Lv_Descripcion;
    --
  END;
  
end PRKG_CONSULTA;
/
