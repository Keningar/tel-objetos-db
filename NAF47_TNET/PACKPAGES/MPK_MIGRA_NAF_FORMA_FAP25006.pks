CREATE OR REPLACE package            MPK_MIGRA_NAF_FORMA_FAP25006 is

  -- Author  : JOHNNY
  -- Created : 23/02/2023 11:40:12
  -- Purpose :

    procedure GCP_FAP25006_POSTQUERY_UNO(
pv_nosolic_origen              in         TAPORDEE.nosolic_origen%type,
pv_Moneda                      in         TAPORDEE.Moneda%type,
pv_No_Cia                      in         TAPORDEE.No_Cia%type,
pv_no_prove                    in         TAPORDEE.No_Prove%type,
pv_No_Orden                    in         TAPORDEE.No_Orden%Type,
pv_adjudicador                 in         TAPORDEE.Adjudicador%type,
pv_Bodega                      in         TAPORDEE.Bodega%type,
pv_ID_TIPO_FRECUENCIA_PAGO     in         TAPORDEE.Id_Tipo_Frecuencia_Pago%type,
pn_PEDIDO_DETALLE_ID           in         TAPORDEE.Pedido_Detalle_Id%type,
pv_TIPO_DISTRIBUCION_COSTO     in         TAPORDEE.Tipo_Distribucion_Costo%type,
pv_ID_TIPO_TRANSACCION         in         TAPORDEE.ID_TIPO_TRANSACCION%type,
pv_no_solic                    out        varchar2,
pv_nombre_moneda               out        varchar2,
pv_nombre_empleado             out        varchar2,
pv_desc_bodega                 out        varchar2,
pv_W_DESCRIPCION_FRECUENCIA    out        varchar2,
pv_W_ID_JEFE_EMPLEADO          out        varchar2,
pv_W_DESC_NOMBRE_EMPLEADO_JEFE out        varchar2,
pn_W_PEDIDO_ID                 out        TAPORDEE.Id_Pedido%type,
pv_W_ASIGNA_ARBOL_COSTO        out        varchar2,
pv_W_INGRESA_MONTO             out        varchar2,
pn_error                       out        number,
pv_error                       out        varchar2
);


    procedure GCP_FAP25006_PRE_INSERT_UNO(
                                      pv_No_Cia                      in         TAPORDEE.No_Cia%type,
                                      pv_no_prove                    in         TAPORDEE.No_Prove%type,
                                      pv_no_orden                    in out        TAPORDEE.No_Orden%type,
                                      pn_Tipo_cambio                 out           arcgal.tipo_cambio%TYPE,
                                      pn_error                       out        number,
                                      pv_error                       out        varchar2                                      
    );

    procedure GCP_FAP25006_POSTQUERY_DOS(
                                      pv_No_Cia                      in         TAPORDEE.No_Cia%type,
                                      pv_no_arti                     in         TAPORDED.No_Arti%type,
                                      pv_ind_no_inv                  in         TAPORDEE.Ind_No_Inv%type,
                                      pv_bodega                      in         TAPORDEE.Bodega%type,
                                      pv_codigo_ni                   in         TAPORDED.Codigo_Ni%type,
                                      pn_cantidad                    in         TAPORDED.Cantidad%type,
                                      pn_costo_uni                   in         TAPORDED.Costo_Uni%type,
                                      pn_descuento                   in         TAPORDED.Descuento%type,
                                      pn_valor_dscto                 out        number,
                                      pn_monto_compra                out        number,
                                      pn_stock                       out        number,
                                      pn_factor                      out        number, 
                                      pv_unidad_prov                 out        arinda.unidad_prov%type, 
                                      pv_w_modelo                    out        arinda.modelo%type,
                                      pv_medida_prov                 out        varchar2,
                                      pn_error                       out        number,
                                      pv_error                       out        varchar2
     );

    PROCEDURE CALCULA_COSTO_UNI(
                            pn_cantidad                    in                      TAPORDED.Cantidad%type,
                            pn_costo_uni                   in                      TAPORDED.Costo_Uni%type,
                            pn_monto_compra                out                     number
    );

    PROCEDURE CALCULA_VALOR_DSCTO(
                            pn_cantidad                    in                      TAPORDED.Cantidad%type,
                            pn_costo_uni                   in                      TAPORDED.Costo_Uni%type,
                            pn_descuento                   in                      TAPORDED.Descuento%type,
                            pn_valor_dscto                 out                     number
    );

    PROCEDURE PU_P_VALIDA_PRODUCTO(       pv_No_Cia                      in         TAPORDEE.No_Cia%type,
                                      pv_ind_no_inv                  in         TAPORDEE.Ind_No_Inv%type,
                                      pv_No_Orden                    in         TAPORDEE.No_Orden%type,                                      
                                      pn_error                       out        number,                                      
                                      pv_error                       out        varchar2
    );

    PROCEDURE PU_P_PROCESAR_ORDEN(        pv_No_Cia                      in         TAPORDEE.No_Cia%type,
                                      pv_No_Orden                    in         TAPORDEE.No_Orden%type,
                                      pv_ID_TIPO_TRANSACCION         in         TAPORDEE.Id_Tipo_Transaccion%type,                                      
                                      pn_error                       out        number,                                      
                                      pv_error                       out        varchar2



     );

PROCEDURE PU_WHEN_CREATERECORD_UNO(      pv_No_Cia                             in         TAPORDEE.No_Cia%type,
                                      Pv_IdUsuario                             in         varchar2,
                                      pv_ID_TIPO_TRANSACCION                   in         varchar2,
                                      pp_ID_ORDEN                              in         varchar2,
                                      pp_TIPO_DISTRIBUCION_COSTO               in         varchar2,
                                      pp_ESTADO_ACTIVO                         in         varchar2,
                                      pp_CONTROL_PRESUPUESTO                   in         varchar2,
                                      Pv_IdEmpleado                            out        varchar2,
                                      Pv_nombre_empleado                       out        varchar2,
                                      pv_W_ID_JEFE_EMPLEADO                    out        varchar2,
                                      pv_W_DESC_NOMBRE_EMPLEADO_JEFE           out        varchar2,
                                      pv_TIPO_DISTRIBUCION_COSTO               out        varchar2,
                                      pn_error                                 out        number,                                      
                                      pv_error                                 out        varchar2
  );

     procedure GCP_FAP25006_BT_EMITIR_UNO(
                                      pv_No_Cia                      in         TAPORDEE.No_Cia%type,                                     
                                      pv_ADJUDICADOR                 in         TAPORDEE.Adjudicador%type,
                                      pn_PEDIDO_DETALLE_ID           in         TAPORDEE.Pedido_Detalle_Id%type,
                                      pv_ind_no_inv                  in         TAPORDEE.Ind_No_Inv%type,
                                      pv_No_Orden                    in         TAPORDEE.No_Orden%type,
                                      pv_ID_TIPO_TRANSACCION         in         TAPORDEE.Id_Tipo_Transaccion%type,                                     
                                      pv_W_ID_JEFE_EMPLEADO          in         varchar2,
                                      pn_error                       out        number,                                      
                                      pv_error                       out        varchar2
     );


    PROCEDURE PU_REG_EMPLEADO (Pv_IdEmpresa    IN VARCHAR2,
                               Pv_IdEmpleado   IN VARCHAR2,
                               Pv_Usuario      IN VARCHAR2,
                               Pr_RegEmpleado  OUT ARPLME%ROWTYPE,
                               Pv_CodigoError  OUT VARCHAR2,
                               Pv_MensajeError OUT VARCHAR2);

     PROCEDURE PU_CONSULTA_EMPLEADO(Pv_IdEmpresa    IN VARCHAR2,
                                    Pv_IdEmpleado   IN VARCHAR2,
                                    Pr_Reemplazo    OUT TAPHISTORICO_REEMPLAZOS%ROWTYPE,
                                    Pv_CodigoError  OUT VARCHAR2,
                                    Pv_MensajeError OUT VARCHAR2);


    PROCEDURE PU_P_INICIALIZA_FORMA(  pv_No_Cia                      in         TAPORDEE.No_Cia%type,
                                      --Pv_GrupoParametro              in         varchar2,
                                      --Pv_IdAplicacion                in         varchar2,
                                      --Pv_IdParametro                 in         varchar2,
                                      Pv_IdTipoTransaccion           in         varchar2,
                                      Pv_user                        in         varchar2,

                                      Pv_IdEmpleado                  OUT        TASGUSUARIO.ID_EMPLEADO%TYPE,
                                      Pv_Usuario                     out        varchar2,
                                      pn_error                       out        number,                                      
                                      pv_error                       out        varchar2
  );
end MPK_MIGRA_NAF_FORMA_FAP25006;

/


CREATE OR REPLACE package body            MPK_MIGRA_NAF_FORMA_FAP25006 is


procedure GCP_FAP25006_POSTQUERY_UNO(
pv_nosolic_origen              in         TAPORDEE.nosolic_origen%type,
pv_Moneda                      in         TAPORDEE.Moneda%type,
pv_No_Cia                      in         TAPORDEE.No_Cia%type,
pv_no_prove                    in         TAPORDEE.No_Prove%type,
pv_No_Orden                    in         TAPORDEE.No_Orden%Type,
pv_adjudicador                 in         TAPORDEE.Adjudicador%type,
pv_Bodega                      in         TAPORDEE.Bodega%type,
pv_ID_TIPO_FRECUENCIA_PAGO     in         TAPORDEE.Id_Tipo_Frecuencia_Pago%type,
pn_PEDIDO_DETALLE_ID           in         TAPORDEE.Pedido_Detalle_Id%type,
pv_TIPO_DISTRIBUCION_COSTO     in         TAPORDEE.Tipo_Distribucion_Costo%type,
pv_ID_TIPO_TRANSACCION         in         TAPORDEE.ID_TIPO_TRANSACCION%type,
pv_no_solic                    out        varchar2,
pv_nombre_moneda               out        varchar2,
pv_nombre_empleado             out        varchar2,
pv_desc_bodega                 out        varchar2,
pv_W_DESCRIPCION_FRECUENCIA    out        varchar2,
pv_W_ID_JEFE_EMPLEADO          out        varchar2,
pv_W_DESC_NOMBRE_EMPLEADO_JEFE out        varchar2,
pn_W_PEDIDO_ID                 out        TAPORDEE.Id_Pedido%type,
pv_W_ASIGNA_ARBOL_COSTO        out        varchar2,
pv_W_INGRESA_MONTO             out        varchar2,
pn_error                       out        number,
pv_error                       out        varchar2
) is

lp_TIPODISTRIBUCION_COSTO      varchar2(30):='TIPO-DISTRIBUCION-COSTO';
lp_CONTROL_PRESUPUESTO          varchar2(30):='CONTROL_PRESUPUESTO';

  CURSOR c_solic IS
  SELECT DISTINCT d.no_solic
    FROM tapsoldoc d, tapbiene e
   WHERE d.no_cia   = pv_No_Cia
     AND e.no_cia   = d.no_cia
     AND e.no_solic = d.no_solic
     AND d.no_docu  = pv_No_Orden
     AND e.estado  <> 'E'
     AND d.tipo     = 'O';
  --
  CURSOR C_LeeTipoFrecuencia(Cv_IdEmpresa        IN VARCHAR2,
                             Cv_IdTipoFrecuencia IN VARCHAR2) IS
   SELECT DESCRIPCION
     FROM CO_TIPOS_FRECUENCIAS_PAGOS
    WHERE ID_TIPO_FRECUENCIA=Cv_IdTipoFrecuencia
      AND ID_EMPRESA=Cv_IdEmpresa;

  CURSOR C_PEDIDO IS
    SELECT PEDIDO_ID
    FROM DB_COMPRAS.INFO_PEDIDO_DETALLE
    WHERE ID_PEDIDO_DETALLE = pn_PEDIDO_DETALLE_ID;

  CURSOR DATOS_TIPO_DISTRIBUCION IS
    SELECT APD.VALOR4 AS ASIGNA_ARBOL_COSTO,
           APD.VALOR5 AS INGRESA_MONTO
    FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
    WHERE APD.VALOR2 = pv_TIPO_DISTRIBUCION_COSTO--:UNO.TIPO_DISTRIBUCION_COSTO
    AND APD.DESCRIPCION = lp_TIPODISTRIBUCION_COSTO
    AND APD.VALOR1 = pv_ID_TIPO_TRANSACCION--:UNO.ID_TIPO_TRANSACCION
    AND APD.EMPRESA_COD = pv_No_Cia
    AND EXISTS (SELECT NULL
                FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                WHERE APC.NOMBRE_PARAMETRO = lp_CONTROL_PRESUPUESTO
                AND APC.ID_PARAMETRO = APD.PARAMETRO_ID);

lv_No_Orden                     TAPORDEE.No_Orden%Type;

lv_no_prove                     TAPORDEE.No_Prove%type;
lv_nomprov                      varchar2(100);
lv_adjudicador                  TAPORDEE.Adjudicador%type;
lv_Bodega                       TAPORDEE.Bodega%type;
le_error                        exception;
lv_error                        varchar2(250);
vReg_prove                      proveedor.datos_r;


--Salida


lv_nombre_empleado                    varchar2(100);
lv_desc_bodega                        varchar2(100);



lv_W_ASIGNA_ARBOL_COSTO               varchar2(30);
lv_W_INGRESA_MONTO                    varchar2(30);
begin
      if pv_nosolic_origen is null then
         OPEN  c_solic;
         FETCH c_solic INTO pv_no_solic;
         Close c_solic;
      else
         pv_no_solic := pv_nosolic_origen;
      end if;
      pv_nombre_moneda := moneda.nombre(pv_No_Cia, pv_Moneda);
      --

      --valida_proveedor;
      --Inicio
      BEGIN
        vReg_prove := proveedor.trae_datos(pv_No_Cia, lv_no_prove);
        IF vReg_prove.ind_nacional = 'N' THEN
           lv_error:='Proveedor debe ser Nacional...';
           --RAISE le_error;
        ELSE
           lv_nomprov := vReg_prove.nombre;
        END IF;
      EXCEPTION
        WHEN proveedor.error THEN
          lv_error:=proveedor.ultimo_error;
          --RAISE le_error;
      END;
      --Fin
      --valida_proveedor;

      --valida_empleado;
      --Inicio
      declare
      CURSOR c_empl IS
        SELECT nombre
          FROM arplme
         WHERE no_cia   = pv_No_Cia
           AND no_emple = pv_adjudicador;
        lb_existe BOOLEAN;
        lv_nombre VARCHAR2(100);
      BEGIN
        IF pv_adjudicador IS NOT NULL THEN
          OPEN  c_empl;
          FETCH c_empl INTO lv_nombre;
          lb_existe := c_empl%found;
          CLOSE c_empl;
          IF NOT lb_existe THEN
            lv_error:='Empleado no existe ...';
            --RAISE le_error;
          ELSE
             pv_nombre_empleado := lv_nombre;
          END IF;
        END IF;
      END;
      --Fin
      --valida_empleado;
      IF pv_bodega IS NOT NULL THEN
         --valida_bodega;
         --Inicio
            DECLARE
                 Lv_DescBodega arinbo.descripcion%TYPE;
            BEGIN
              SELECT descripcion
                INTO Lv_DescBodega
                FROM arinbo
               WHERE no_cia = pv_No_Cia
                 AND codigo = pv_bodega
                 AND (NVL(administracion,'N') = 'S' OR NVL(principal,'N') = 'S')
                 /*AND centro IN
                     (select centro from arincd where no_cia = :uno.no_cia and nvl(matriz_centro,'N') = 'S')*/;
              pv_desc_bodega := Lv_DescBodega;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  --MESSAGE('La bodega del centro de distribución Matriz, no está definida en inventario');
                  --SYNCHRONIZE;
                  --RAISE FORM_TRIGGER_FAILURE;
                  lv_error:='La bodega del centro de distribución Matriz, no está definida en inventario';
                  --RAISE le_error;
            END;
         --Fin
         --valida_bodega;
      END IF;



      IF pv_ID_TIPO_FRECUENCIA_PAGO IS NOT NULL THEN
        IF C_LeeTipoFrecuencia%ISOPEN THEN CLOSE C_LeeTipoFrecuencia; END IF;
        OPEN C_LeeTipoFrecuencia(pv_No_Cia,pv_ID_TIPO_FRECUENCIA_PAGO);
        FETCH C_LeeTipoFrecuencia INTO pv_W_DESCRIPCION_FRECUENCIA;
        CLOSE C_LeeTipoFrecuencia;
      END IF;

      --PU_P_LEE_JEFE_EMPLEADO
      --Inicio
      declare
              CURSOR C_LeeNombreJefe IS
          SELECT J.NO_EMPLE, J.NOMBRE
            FROM ARPLME E,
                 ARPLME J
           WHERE E.ID_JEFE = J.NO_EMPLE
             AND E.NO_CIA = J.NO_CIA
             AND E.NO_EMPLE =pv_adjudicador
             AND E.NO_CIA=pv_No_Cia--Pv_IdEmpresa
             ;
      BEGIN
        IF C_LeeNombreJefe%ISOPEN THEN CLOSE C_LeeNombreJefe; END IF;
        OPEN C_LeeNombreJefe;
        FETCH C_LeeNombreJefe INTO pv_W_ID_JEFE_EMPLEADO,--
                                   pv_W_DESC_NOMBRE_EMPLEADO_JEFE;
        CLOSE C_LeeNombreJefe;
      END;
      --Fin
      --PU_P_LEE_JEFE_EMPLEADO
        IF pn_PEDIDO_DETALLE_ID IS NOT NULL THEN
          --
          OPEN C_PEDIDO;
          FETCH C_PEDIDO INTO pn_W_PEDIDO_ID;
          CLOSE C_PEDIDO;
          --
        END IF;
        --
        OPEN DATOS_TIPO_DISTRIBUCION;
        FETCH DATOS_TIPO_DISTRIBUCION INTO pv_W_ASIGNA_ARBOL_COSTO, pv_W_INGRESA_MONTO;
        CLOSE DATOS_TIPO_DISTRIBUCION;
        --

      pn_error := 0;
      pv_error := null;
exception
  when le_error then
    pn_error := 1;
    pv_error := lv_error;
  when others then
    pn_error := 99;
    pv_error := 'Error en GCP_FAP25006_POSTQUERY_UNO -'||substr(sqlerrm,1,250);
end;


procedure GCP_FAP25006_PRE_INSERT_UNO(
                                      pv_No_Cia                      in         TAPORDEE.No_Cia%type,
                                      pv_no_prove                    in         TAPORDEE.No_Prove%type,
                                      pv_no_orden                    in out        TAPORDEE.No_Orden%type,
                                      pn_Tipo_cambio                 out           arcgal.tipo_cambio%TYPE,
                                      pn_error                       out        number,
                                      pv_error                       out        varchar2                                      
)is
  prove       tapordee.no_prove%TYPE;
  vReg_prove  proveedor.datos_r;

    --  Clase cambio
  CURSOR clase IS
    SELECT clase_cambio
      FROM tapcia
     WHERE no_cia = pv_No_Cia;

  CURSOR C_LeeSecuencia IS
    SELECT NVL(MAX(TO_NUMBER(NO_ORDEN)),0) + 1
      FROM TAPORDEE
      WHERE NO_CIA=pv_No_Cia;

    Lv_Clase        tapcia.clase_cambio%TYPE;
    Lv_Moneda_lim   arcpmp.moneda_limite%TYPE;  
    Ld_Fecha_ret    DATE;
    Ln_Tipo_cambio  arcgal.tipo_cambio%TYPE;
    le_error        exception;
    lv_error        varchar2(2000); 
begin
   -- clase de cambio
  OPEN  clase;
  FETCH clase INTO Lv_Clase; 
  CLOSE clase;
  Prove := pv_no_prove; 
  -- Obtiene el siguiente numero de orden de compra
  IF pv_no_orden IS NULL THEN
     IF C_LeeSecuencia%ISOPEN THEN CLOSE C_LeeSecuencia; END IF;
     OPEN C_LeeSecuencia;
     FETCH C_LeeSecuencia INTO pv_no_orden;
     CLOSE C_LeeSecuencia;
  END IF; 

  -- Determina el tipo de cambio de la orden según el proveedor
  vReg_prove    := proveedor.trae_datos(pv_No_Cia, pv_no_prove );
  Lv_Moneda_lim := vReg_prove.moneda_limite;   

  IF Lv_Moneda_lim = 'D' THEN
     pn_Tipo_cambio := Tipo_cambio(Lv_Clase, SYSDATE, Ld_Fecha_ret, 'C');
  ELSE  
     pn_Tipo_cambio := 1;
  END IF;  

exception
  when le_error then
    pn_error := 1;
    pv_error := lv_error;
  when others then
    pn_error := 99;
    pv_error := 'Error en GCP_FAP25006_PRE-INSERT_UNO -'||substr(sqlerrm,1,250);
end;



procedure GCP_FAP25006_POSTQUERY_DOS(
                                      pv_No_Cia                      in         TAPORDEE.No_Cia%type,
                                      pv_no_arti                     in         TAPORDED.No_Arti%type,
                                      pv_ind_no_inv                  in         TAPORDEE.Ind_No_Inv%type,
                                      pv_bodega                      in         TAPORDEE.Bodega%type,
                                      pv_codigo_ni                   in         TAPORDED.Codigo_Ni%type,
                                      pn_cantidad                    in         TAPORDED.Cantidad%type,
                                      pn_costo_uni                   in         TAPORDED.Costo_Uni%type,
                                      pn_descuento                   in         TAPORDED.Descuento%type,
                                      pn_valor_dscto                 out        number,
                                      pn_monto_compra                out        number,
                                      pn_stock                       out        number,
                                      pn_factor                      out        number, 
                                      pv_unidad_prov                 out        arinda.unidad_prov%type, 
                                      pv_w_modelo                    out        arinda.modelo%type,
                                      pv_medida_prov                 out        varchar2,
                                      pn_error                       out        number,
                                      pv_error                       out        varchar2
) is
  Cursor C_arinda is
   select factor, unidad_prov, modelo
   from   arinda
   where  no_cia = pv_No_Cia
   and    no_arti = pv_no_arti;

  Cursor C_Unid_prov (lv_unidad Varchar2) is
   select nom
   from   arinum
   where  no_cia = pv_No_Cia
   and    unidad = lv_unidad
   and    tipo = 'A';

  Cursor C_Modelo (Lv_Articulo Varchar2)IS
   SELECT DA.MODELO 
     FROM ARINDA DA 
    WHERE DA.NO_CIA= pv_No_Cia
      AND DA.NO_ARTI= Lv_Articulo;   

   lv_unidad_prov arinum.unidad%type;

   Lb_Found BOOLEAN;   
begin
  IF nvl(pv_ind_no_inv,'N') = 'N' THEN
     --PCK_VALIDA_ARTICULO.INSERTA_ARTICULO(pv_no_arti, '1', NULL);       
     CALCULA_COSTO_UNI(pn_cantidad,pn_costo_uni, pn_monto_compra);
     CALCULA_VALOR_DSCTO(pn_cantidad, pn_costo_uni, pn_descuento, pn_valor_dscto);
     pn_stock := articulo.existencia(pv_No_Cia, pv_no_arti, pv_bodega);
  ELSE
     --PCK_VALIDA_ARTICULO.INSERTA_ARTICULO(pv_codigo_ni, '1', NULL);       
     CALCULA_COSTO_UNI(pn_cantidad,pn_costo_uni, pn_monto_compra);
     CALCULA_VALOR_DSCTO(pn_cantidad, pn_costo_uni, pn_descuento, pn_valor_dscto);
  END IF;   

  Open C_arinda;
  Fetch C_arinda into pn_factor, Lv_unidad_prov, pv_w_modelo;
  Close C_arinda;
  pv_unidad_prov := Lv_unidad_prov;

  If lv_unidad_prov is not null Then
    Open C_Unid_prov (lv_unidad_prov);
    Fetch  C_Unid_prov into pv_medida_prov;
    close C_Unid_prov;
  end if;


EXCEPTION
  WHEN NO_DATA_FOUND THEN
       NULL;
  WHEN OTHERS THEN
    pn_error := 99;
    pv_error := 'GCP_FAP25006_POSTQUERY_DOS '||substr(sqlerrm, 1, 200);
    --MESSAGE('Error-->'||SQLERRM);
end;


procedure GCP_FAP25006_BT_EMITIR_UNO(
                                      pv_No_Cia                      in         TAPORDEE.No_Cia%type,                                     
                                      pv_ADJUDICADOR                 in         TAPORDEE.Adjudicador%type,
                                      pn_PEDIDO_DETALLE_ID           in         TAPORDEE.Pedido_Detalle_Id%type,
                                      pv_ind_no_inv                  in         TAPORDEE.Ind_No_Inv%type,
                                      pv_No_Orden                    in         TAPORDEE.No_Orden%type,
                                      pv_ID_TIPO_TRANSACCION         in         TAPORDEE.Id_Tipo_Transaccion%type,                                     
                                      pv_W_ID_JEFE_EMPLEADO          in         varchar2,
                                      pn_error                       out        number,                                      
                                      pv_error                       out        varchar2
) is

  CURSOR C_LeeEmplGerente(Cv_IdEmpresa IN VARCHAR2) IS
    SELECT PARAMETRO_ALTERNO
    FROM GE_PARAMETROS
    WHERE ID_APLICACION = 'GE'
    AND ID_GRUPO_PARAMETRO = 'GER_GEN'
    AND PARAMETRO = 'GERENTE'
    AND ID_EMPRESA = Cv_IdEmpresa;
  --
  Lv_IdGerenteGer GE_PARAMETROS.PARAMETRO_ALTERNO%TYPE:=NULL;
  Lv_CodigoError  VARCHAR2(30):=NULL;
  Le_Error     EXCEPTION;
  --
  Lv_MensajeError VARCHAR2(3000);
  ln_error        number;
  --
BEGIN

  --

  --
  Lv_MensajeError :=NULL;
  --
  --PU_P_VALIDA_PRODUCTO(Lv_MensajeError);
  --Inicio
    MPK_MIGRA_NAF_FORMA_FAP25006.PU_P_VALIDA_PRODUCTO(pv_No_Cia => pv_No_Cia,
                                                      pv_ind_no_inv => pv_ind_no_inv,
                                                      pv_No_Orden => pv_No_Orden,
                                                      pn_error => ln_error,
                                                      pv_error => Lv_MensajeError);
  --Fin
  --PU_P_VALIDA_PRODUCTO(Lv_MensajeError);
  --
  IF Lv_MensajeError IS NOT NULL THEN
    Lv_MensajeError := 'Existe Un Producto Repetido en el Detalle de la Orden';
    RAISE Le_Error;
  END IF;
  --
  --
  IF C_LeeEmplGerente%ISOPEN THEN 
    CLOSE C_LeeEmplGerente; 
  END IF;
  --
  OPEN C_LeeEmplGerente(pv_No_Cia);
  FETCH C_LeeEmplGerente INTO Lv_IdGerenteGer;
  CLOSE C_LeeEmplGerente;
  --
  --
  IF pv_ADJUDICADOR <> NVL(Lv_IdGerenteGer,'X') AND NVL(pn_PEDIDO_DETALLE_ID,0) = 0 THEN-- Solo Valida que el Gerente Genera Sea el Unico que no tenga Jefe
    --
    IF pv_W_ID_JEFE_EMPLEADO IS NULL THEN
      --
      Lv_MensajeError := 'No Existe Jefe de Solicitante';
      RAISE Le_Error;
      --
    ELSE
      --
      --PU_P_PROCESAR_ORDEN (Lv_MensajeError);
      --Inicio
      PU_P_PROCESAR_ORDEN(pv_No_Cia,
                          pv_No_Orden,
                          pv_ID_TIPO_TRANSACCION,                                      
                          ln_error,
                          Lv_MensajeError);
      --Fin
      --PU_P_PROCESAR_ORDEN (Lv_MensajeError);
      --
      IF Lv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      --
    END IF;
    --
  END IF;
  --
  --:system.message_level := 5;
  commit;
  --:system.message_level := 0;
  --
  /*
  IF :system.form_status IN ('QUERY','NEW') THEN
    --
    IF :UNO.ADJUDICADOR = NVL(Lv_IdGerenteGer,'X') OR NVL(:UNO.PEDIDO_DETALLE_ID,0) != 0 THEN
      PU_P_IMPRIME_OC_AUTORIZADA;
      PROCESO_CONCLUIDO('Orden Compra '||:uno.no_orden||' fue autorizada con éxito'); 
    ELSE
    	PROCESO_CONCLUIDO('Orden Compra '||:uno.no_orden||' se envió a autorizar con éxito');
    END IF;
    --
    GO_BLOCK('UNO');
    CLEAR_BLOCK(NO_VALIDATE);
    EXECUTE_QUERY;
    --
  END IF;  
  */

EXCEPTION
  WHEN Le_Error THEN
    --MSG_AVISO(Lv_MensajeError);
    --ISSUE_ROLLBACK(NULL);
    pv_error := Lv_MensajeError;
    pn_error := 1;
  WHEN OTHERS THEN
    --MSG_AVISO(SQLERRM);
    --ISSUE_ROLLBACK(NULL);
    pv_error := 'Error GCP_FAP25006_BT_EMITIR_UNO-'||substr(sqlerrm,1,200);
    pn_error := 99;
end;

PROCEDURE PU_WHEN_CREATERECORD_UNO(      pv_No_Cia                             in         TAPORDEE.No_Cia%type,
                                      Pv_IdUsuario                             in         varchar2,
                                      pv_ID_TIPO_TRANSACCION                   in         varchar2,
                                      pp_ID_ORDEN                              in         varchar2,
                                      pp_TIPO_DISTRIBUCION_COSTO               in         varchar2,
                                      pp_ESTADO_ACTIVO                         in         varchar2,
                                      pp_CONTROL_PRESUPUESTO                   in         varchar2,
                                      Pv_IdEmpleado                            out        varchar2,
                                      Pv_nombre_empleado                       out        varchar2,
                                      pv_W_ID_JEFE_EMPLEADO                    out        varchar2,
                                      pv_W_DESC_NOMBRE_EMPLEADO_JEFE           out        varchar2,
                                      pv_TIPO_DISTRIBUCION_COSTO               out        varchar2,
                                      pn_error                                 out        number,                                      
                                      pv_error                                 out        varchar2
  )IS
    CURSOR C_TIPO_DIST_DEFAULT IS
    SELECT APD.VALOR2
    FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
    WHERE APD.DESCRIPCION = pp_TIPO_DISTRIBUCION_COSTO--:PARAMETER.TIPO_DISTRIBUCION_COSTO
    AND APD.VALOR1 = pv_ID_TIPO_TRANSACCION--:UNO.ID_TIPO_TRANSACCION
    AND APD.EMPRESA_COD = pv_No_Cia--:GLOBAL.compania
    AND APD.VALOR3 = 'DEFAULT'
    AND APD.ESTADO = pp_ESTADO_ACTIVO--:PARAMETER.ESTADO_ACTIVO
    AND EXISTS (SELECT NULL
                FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                WHERE APC.NOMBRE_PARAMETRO = pp_CONTROL_PRESUPUESTO--:PARAMETER.CONTROL_PRESUPUESTO
                AND APC.ID_PARAMETRO = APD.PARAMETRO_ID
                AND APC.ESTADO = pp_ESTADO_ACTIVO--:PARAMETER.ESTADO_ACTIVO
                );

    CURSOR C_LeeEmpleadoSesion(Cv_IdEmpresa IN VARCHAR2, --
                          Cv_IdUsuario IN VARCHAR2) IS
    SELECT ID_EMPLEADO
      FROM TASGUSUARIO
     WHERE USUARIO = Cv_IdUsuario
       AND NO_CIA = Cv_IdEmpresa;

      CURSOR C_LeeNombreJefe IS
    SELECT J.NO_EMPLE, J.NOMBRE
      FROM ARPLME E,
           ARPLME J
     WHERE E.ID_JEFE = J.NO_EMPLE
       AND E.NO_CIA = J.NO_CIA
       AND E.NO_EMPLE =Pv_IdEmpleado
       AND E.NO_CIA=pv_No_Cia;

      CURSOR c_empl IS
  SELECT nombre 
    FROM arplme
   WHERE no_cia   = pv_No_Cia
     AND no_emple = Pv_IdEmpleado;
  lb_existe BOOLEAN;
  lv_nombre VARCHAR2(100); 

  Lv_CodigoError   VARCHAR2(30):=NULL;
  Lv_MensajeError  VARCHAR2(3000):=NULL;
  Le_Error         EXCEPTION;
begin

  IF C_LeeEmpleadoSesion%ISOPEN THEN CLOSE C_LeeEmpleadoSesion; END IF;
	OPEN C_LeeEmpleadoSesion(pv_No_Cia,Pv_IdUsuario);
	FETCH C_LeeEmpleadoSesion INTO Pv_IdEmpleado;
	CLOSE C_LeeEmpleadoSesion; 


  IF Pv_IdEmpleado IS NOT NULL THEN
    IF C_LeeNombreJefe%ISOPEN THEN CLOSE C_LeeNombreJefe; END IF;
    OPEN C_LeeNombreJefe;
    FETCH C_LeeNombreJefe INTO pv_W_ID_JEFE_EMPLEADO,--:UNO.W_ID_JEFE_EMPLEADO,--
                               pv_W_DESC_NOMBRE_EMPLEADO_JEFE--:UNO.W_DESC_NOMBRE_EMPLEADO_JEFE
                               ;
    CLOSE C_LeeNombreJefe;
  END IF;


  IF pp_ID_ORDEN IS NOT NULL THEN
    --
    RETURN;
    --
  END IF;
    IF Pv_IdEmpleado IS NOT NULL THEN
      OPEN  c_empl;
      FETCH c_empl INTO lv_nombre;
      lb_existe := c_empl%found;  
      CLOSE c_empl;
      IF NOT lb_existe THEN
         --msg_aviso('Empleado no existe ...');
         Lv_MensajeError := 'Empleado no existe ...';
         RAISE Le_Error;
      ELSE  
         --:uno.nombre_empleado 
         Pv_nombre_empleado := lv_nombre;
      END IF;      
    END IF;

  IF C_TIPO_DIST_DEFAULT%ISOPEN THEN
    CLOSE C_TIPO_DIST_DEFAULT;
  END IF;
  --
  OPEN C_TIPO_DIST_DEFAULT;
  FETCH C_TIPO_DIST_DEFAULT INTO pv_TIPO_DISTRIBUCION_COSTO;--:UNO.TIPO_DISTRIBUCION_COSTO;
  IF C_TIPO_DIST_DEFAULT%NOTFOUND THEN
    Lv_MensajeError := 'No se ha definido tipo de distribución costos ['||pp_TIPO_DISTRIBUCION_COSTO||'] dentro del parametro ['||pp_CONTROL_PRESUPUESTO||'] para la empresa '||pv_No_Cia;
    RAISE Le_Error;
  END IF;
  CLOSE C_TIPO_DIST_DEFAULT;


EXCEPTION
  WHEN Le_Error THEN
    --MSG_AVISO('Error En PU_P_PROCESAR_ORDEN '||Lv_CodigoError||' - '||Pv_MensajeError);  
    pn_error := 1;                                    
    pv_error := 'Error En PU_P_INICIALIZA_FORMA '||Lv_CodigoError||' - '||Lv_MensajeError;
  WHEN OTHERS THEN
    --Pv_MensajeError := 'Error En PU_P_PROCESAR_ORDEN '||SQLERRM;
    --MSG_AVISO(Pv_MensajeError);
    pn_error := 99;                                    
    pv_error := 'Error En PU_P_INICIALIZA_FORMA '||SQLERRM;   
end;

PROCEDURE PU_P_INICIALIZA_FORMA(      pv_No_Cia                      in         TAPORDEE.No_Cia%type,
                                      --Pv_GrupoParametro              in         varchar2,
                                      --Pv_IdAplicacion                in         varchar2,
                                      --Pv_IdParametro                 in         varchar2,
                                      Pv_IdTipoTransaccion           in         varchar2,
                                      Pv_user                        in         varchar2,

                                      Pv_IdEmpleado                  OUT        TASGUSUARIO.ID_EMPLEADO%TYPE,
                                      Pv_Usuario                     out        varchar2,
                                      pn_error                       out        number,                                      
                                      pv_error                       out        varchar2
  )IS

    CURSOR C_ValidaSolicitante(Cv_IdEmpresa      IN VARCHAR2, 
                             Cv_GrupoParametro IN VARCHAR2,
                             Cv_IdAplicacion   IN VARCHAR2, 
                             Cv_IdParametro    IN VARCHAR2) IS
      SELECT P.*
        FROM GE_PARAMETROS        P,
             GE_GRUPOS_PARAMETROS GP
       WHERE P.ID_EMPRESA = GP.ID_EMPRESA
         AND P.ID_APLICACION = GP.ID_APLICACION
         AND P.ID_GRUPO_PARAMETRO = GP.ID_GRUPO_PARAMETRO
         AND P.PARAMETRO = Cv_IdParametro
         AND GP.ID_GRUPO_PARAMETRO = Cv_GrupoParametro
         AND GP.ID_APLICACION = Cv_IdAplicacion
         AND GP.ESTADO='A'
         AND P.ESTADO='A'
         AND GP.ID_EMPRESA = Cv_IdEmpresa;

     CURSOR C_LeeEmpleadoSesion(Cv_IdEmpresa IN VARCHAR2, --
                            Cv_IdUsuario IN VARCHAR2) IS
      SELECT ID_EMPLEADO
        FROM TASGUSUARIO
       WHERE USUARIO = Cv_IdUsuario
         AND NO_CIA = Cv_IdEmpresa;

     CURSOR C_LeeEmpleadoUser(Cv_IdEmpresa IN VARCHAR2, Cv_IdEmplado IN VARCHAR2) IS
      SELECT USUARIO
        FROM SEG47_TNET.TASGUSUARIO
       WHERE NO_CIA=Cv_IdEmpresa
         AND ID_EMPLEADO=Cv_IdEmplado;

  --
  Lr_Solicitante C_ValidaSolicitante%ROWTYPE:=NULL;  
  Lv_Sentencia Varchar2(1000) := null;
  Lr_RegEmpleado 	ARPLME%ROWTYPE:=NULL;
  Lr_Reemplazo    TAPHISTORICO_REEMPLAZOS%ROWTYPE:=NULL;
  Lv_Usuario      SEG47_TNET.TASGUSUARIO.USUARIO%TYPE:=NULL;

  Lv_CodigoError   VARCHAR2(30):=NULL;
  Lv_MensajeError  VARCHAR2(3000):=NULL;
  Le_Error         EXCEPTION;
BEGIN

	IF C_ValidaSolicitante%ISOPEN THEN CLOSE C_ValidaSolicitante; END IF;
  OPEN C_ValidaSolicitante(pv_No_Cia,'SOLICITA_ORDEN_'||Pv_IdTipoTransaccion,'CO',USER);
  FETCH C_ValidaSolicitante INTO Lr_Solicitante;
  CLOSE C_ValidaSolicitante;

  --PU_P_LEE_SOLICITANTE(:GLOBAL.compania,USER,Lr_Solicitante.PARAMETRO_ALTERNO);
  /*
  IF C_LeeEmpleadoSesion%ISOPEN THEN CLOSE C_LeeEmpleadoSesion; END IF;
	OPEN C_LeeEmpleadoSesion(pv_No_Cia,Pv_user);
	FETCH C_LeeEmpleadoSesion INTO Pv_IdEmpleado;
	CLOSE C_LeeEmpleadoSesion;  */


  --PU_F_LEE_REEMPLAZO
  --Inicio
   PU_REG_EMPLEADO(pv_No_Cia,
                               'X',--Codigo Empleado
                               Pv_USER,--Codiho Emplado
                               Lr_RegEmpleado,
                               Lv_CodigoError,
                               Lv_MensajeError);

  IF Lv_CodigoError IS NOT NULL OR Lv_MensajeError IS NOT NULL THEN
    --Message(Lv_CodigoError||' '||Lv_MensajeError);
    --Message(Lv_CodigoError||' '||Lv_MensajeError);
    RAISE Le_Error;
  END IF;

  PU_CONSULTA_EMPLEADO(pv_No_Cia,
                       Lr_RegEmpleado.NO_EMPLE,
                       Lr_Reemplazo,
                       Lv_CodigoError,
                       Lv_MensajeError);

  IF Lv_CodigoError IS NOT NULL OR Lv_MensajeError IS NOT NULL THEN
    --Message(Lv_CodigoError||' '||Lv_MensajeError);
    --Message(Lv_CodigoError||' '||Lv_MensajeError);
    RAISE Le_Error;
  END IF;  

  --Fin
  --PU_F_LEE_REEMPLAZO

   IF C_LeeEmpleadoUser%ISOPEN THEN CLOSE C_LeeEmpleadoUser; END IF;
 OPEN C_LeeEmpleadoUser(pv_No_Cia,Lr_Reemplazo.NO_EMPLE);
 FETCH C_LeeEmpleadoUser INTO Lv_Usuario;
 CLOSE C_LeeEmpleadoUser;
 --RETURN Lv_Usuario;
 Pv_Usuario := Lv_Usuario;

EXCEPTION
  WHEN Le_Error THEN
    --MSG_AVISO('Error En PU_P_PROCESAR_ORDEN '||Lv_CodigoError||' - '||Pv_MensajeError);  
    pn_error := 1;                                    
    pv_error := 'Error En PU_P_INICIALIZA_FORMA '||Lv_CodigoError||' - '||Lv_MensajeError;
  WHEN OTHERS THEN
    --Pv_MensajeError := 'Error En PU_P_PROCESAR_ORDEN '||SQLERRM;
    --MSG_AVISO(Pv_MensajeError);
    pn_error := 99;                                    
    pv_error := 'Error En PU_P_INICIALIZA_FORMA '||SQLERRM;  
END;


PROCEDURE PU_REG_EMPLEADO (Pv_IdEmpresa    IN VARCHAR2,
                             Pv_IdEmpleado   IN VARCHAR2,
                             Pv_Usuario      IN VARCHAR2,
                             Pr_RegEmpleado  OUT ARPLME%ROWTYPE,
                             Pv_CodigoError  OUT VARCHAR2,
                             Pv_MensajeError OUT VARCHAR2) IS

    CURSOR C_LeeEmpleadoCodigo IS
      SELECT E.NO_CIA,
             E.CEDULA,
             E.APE_PAT,
             E.APE_MAT,
             E.NOMBRE_PILA,
             E.NOMBRE_SEGUNDO,
             E.NOMBRE,
             E.NO_EMPLE,
             E.MAIL_CIA
        FROM ARPLME E
       WHERE E.NO_CIA = Pv_IdEmpresa
         AND E.NO_EMPLE = Pv_IdEmpleado;
    --

    CURSOR C_LeeEmpleadoUsuario IS
      SELECT E.NO_CIA,
             E.CEDULA,
             E.APE_PAT,
             E.APE_MAT,
             E.NOMBRE_PILA,
             E.NOMBRE_SEGUNDO,
             E.NOMBRE,
             E.NO_EMPLE,
             E.MAIL_CIA   
        FROM SEG47_TNET.TASGUSUARIO LE,
             ARPLME                 E
       WHERE LE.NO_CIA = E.NO_CIA
         AND LE.ID_EMPLEADO = E.NO_EMPLE
         AND E.NO_CIA = Pv_IdEmpresa
         AND lower(LE.USUARIO) = lower(Pv_Usuario);
    --
    Lr_Empleado C_LeeEmpleadoCodigo%ROWTYPE := NULL;
    Le_Error EXCEPTION;
  BEGIN
    IF Pv_IdEmpresa IS NULL THEN
      Pv_MensajeError := 'El código de Empresa no puede ser Vacio.';
      RAISE Le_Error;
    END IF;
    --
    IF Pv_IdEmpleado IS NULL AND Pv_Usuario IS NULL THEN
      Pv_MensajeError := 'Debe de Registrar un Criterio de Consulta.';
      RAISE Le_Error;
    END IF;
    --
    IF Pv_IdEmpleado IS NOT NULL THEN
      IF C_LeeEmpleadoCodigo%ISOPEN THEN
        CLOSE C_LeeEmpleadoCodigo;
      END IF;
      OPEN C_LeeEmpleadoCodigo;
      FETCH C_LeeEmpleadoCodigo
        INTO Lr_Empleado; --Pr_RegEmpleado;
      CLOSE C_LeeEmpleadoCodigo;
    END IF;
    --
    IF Pv_Usuario IS NOT NULL THEN
      IF C_LeeEmpleadoUsuario%ISOPEN THEN
        CLOSE C_LeeEmpleadoUsuario;
      END IF;
      OPEN C_LeeEmpleadoUsuario;
      FETCH C_LeeEmpleadoUsuario
        INTO Lr_Empleado; --Pr_RegEmpleado;
      CLOSE C_LeeEmpleadoUsuario;
    END IF;
    --
    Pr_RegEmpleado.No_Cia         := Lr_Empleado.No_Cia;
    Pr_RegEmpleado.CEDULA         := Lr_Empleado.CEDULA;
    Pr_RegEmpleado.APE_PAT        := Lr_Empleado.APE_PAT;
    Pr_RegEmpleado.NOMBRE_PILA    := Lr_Empleado.NOMBRE_PILA;
    Pr_RegEmpleado.NOMBRE_SEGUNDO := Lr_Empleado.NOMBRE_SEGUNDO;
    Pr_RegEmpleado.NOMBRE         := Lr_Empleado.NOMBRE;
    Pr_RegEmpleado.NO_EMPLE       := Lr_Empleado.NO_EMPLE;
    Pr_RegEmpleado.Mail_Cia       := Lr_Empleado.Mail_Cia;
    --
  EXCEPTION
    WHEN Le_Error THEN
      RETURN;
    WHEN OTHERS THEN
      Pv_CodigoError  := SQLCODE;
      Pv_MensajeError := 'Error No Contgrolado en PLP_REG_EMPLEADO ' || Pv_CodigoError || ' - ' || SQLERRM;
      RETURN;
  END;

  PROCEDURE PU_CONSULTA_EMPLEADO(Pv_IdEmpresa    IN VARCHAR2,
                              Pv_IdEmpleado   IN VARCHAR2,
                              Pr_Reemplazo    OUT TAPHISTORICO_REEMPLAZOS%ROWTYPE,
                              Pv_CodigoError  OUT VARCHAR2,
                              Pv_MensajeError OUT VARCHAR2) IS

    --Lee el empleado que esta siendo reemplazado
    CURSOR C_LeeEmpleado(Cv_IdEmpresa  IN VARCHAR2,
                         Cv_IdEmpleado IN VARCHAR2) IS
      SELECT R.NO_EMPLE
        FROM TAPHISTORICO_REEMPLAZOS R
       WHERE R.NO_CIA = Cv_IdEmpresa
         AND R.ACTIVO = 'A'
         AND TRUNC(SYSDATE) >= R.FECHA_DESDE
         AND TRUNC(SYSDATE) <= R.FECHA_HASTA
         AND R.NO_EMPLE_REEMP = Cv_IdEmpleado;
    Le_Error EXCEPTION;

  BEGIN
    IF Pv_IdEmpresa IS NULL THEN
      Pv_MensajeError := 'El código de la empresa no puede ser nulo.';
      RAISE Le_Error;
    END IF;
    IF Pv_IdEmpleado IS NULL THEN
      Pv_MensajeError := 'El código del empleado no puede ser nulo.';
      RAISE Le_Error;
    END IF;
    --
    IF C_LeeEmpleado%ISOPEN THEN
      CLOSE C_LeeEmpleado;
    END IF;
    OPEN C_LeeEmpleado(Pv_IdEmpresa, Pv_IdEmpleado);
    FETCH C_LeeEmpleado
      INTO Pr_Reemplazo.NO_EMPLE;
    CLOSE C_LeeEmpleado;
    --
  EXCEPTION
    WHEN Le_Error THEN
      RETURN;
    WHEN OTHERS THEN
      Pv_CodigoError  := SQLCODE;
      Pv_MensajeError := 'Error No Controlado en PU_CONSULTA_EMPLEADO ' || Pv_CodigoError || ' - ' || SQLERRM;
      RETURN;
  END;

PROCEDURE PU_P_PROCESAR_ORDEN(        pv_No_Cia                      in         TAPORDEE.No_Cia%type,
                                      pv_No_Orden                    in         TAPORDEE.No_Orden%type,
                                      pv_ID_TIPO_TRANSACCION         in         TAPORDEE.Id_Tipo_Transaccion%type,                                      
                                      pn_error                       out        number,                                      
                                      pv_error                       out        varchar2



  ) IS
 --  
  Lv_CodigoError   VARCHAR2(30):=NULL;
  Lv_MensajeError  VARCHAR2(3000):=NULL;
  Le_Error         EXCEPTION;
    --
BEGIN
  --
  COK_ORDENES_COMPRAS.COP_GENERA_FLUJO_APROBACION(pv_No_Cia,
                                                  pv_No_Orden,
                                                  Lv_CodigoError,
                                                  Lv_MensajeError);
  IF Lv_CodigoError IS NOT NULL OR Lv_MensajeError IS NOT NULL THEN
    RAISE Le_Error;
  END IF;
  --
  --PU_P_REGISTRA_APROBADOR(Lv_MensajeError);

  IF Lv_CodigoError IS NOT NULL OR Lv_MensajeError IS NOT NULL THEN
    RAISE Le_Error;
  END IF;
  --
  --
  --
  CORREO_ORDEN.SIGUIENTE_APROBADOR(pv_No_Cia,
                                   pv_No_Orden,
                                   pv_ID_TIPO_TRANSACCION,
                                   Lv_CodigoError,
                                   Lv_MensajeError);
  IF Lv_CodigoError IS NOT NULL OR Lv_MensajeError IS NOT NULL THEN
    RAISE Le_Error;
  END IF;
  --
  --:UNO.ESTADO :='P';
  --

EXCEPTION
  WHEN Le_Error THEN
    --MSG_AVISO('Error En PU_P_PROCESAR_ORDEN '||Lv_CodigoError||' - '||Pv_MensajeError);  
    pn_error := 1;                                    
    pv_error := 'Error En PU_P_PROCESAR_ORDEN '||Lv_CodigoError||' - '||Lv_MensajeError;
  WHEN OTHERS THEN
    --Pv_MensajeError := 'Error En PU_P_PROCESAR_ORDEN '||SQLERRM;
    --MSG_AVISO(Pv_MensajeError);
    pn_error := 99;                                    
    pv_error := 'Error En PU_P_PROCESAR_ORDEN '||SQLERRM;
END;

PROCEDURE PU_P_VALIDA_PRODUCTO(       pv_No_Cia                      in         TAPORDEE.No_Cia%type,
                                      pv_ind_no_inv                  in         TAPORDEE.Ind_No_Inv%type,
                                      pv_No_Orden                    in         TAPORDEE.No_Orden%type,                                      
                                      pn_error                       out        number,                                      
                                      pv_error                       out        varchar2
  ) IS

  CURSOR C_LeeServiciosOrden(Cv_IdEmpresa IN VARCHAR2,Cv_IdOrden IN VARCHAR2) IS
    SELECT CODIGO_NI,
           COUNT(*) CANTIDAD
      FROM TAPORDED
     WHERE NO_ORDEN=Cv_IdOrden
       AND NO_CIA=Cv_IdEmpresa
     GROUP BY CODIGO_NI;

  CURSOR C_LeeProductoOrden(Cv_IdEmpresa IN VARCHAR2,Cv_IdOrden IN VARCHAR2) IS
    SELECT NO_ARTI,
           COUNT(*) CANTIDAD
      FROM TAPORDED
     WHERE NO_ORDEN=Cv_IdOrden
       AND NO_CIA=Cv_IdEmpresa
     GROUP BY NO_ARTI;

  Lb_ExisteRepetido BOOLEAN:=FALSE;
  le_error          exception;
  lv_error          varchar2(2000);
  ln_error          number;
begin
  IF pv_ind_no_inv = 'N' THEN --INVENTARIOS
    FOR A IN C_LeeProductoOrden(pv_No_Cia,pv_No_Orden) LOOP
       IF A.CANTIDAD > 1 THEN
         Lb_ExisteRepetido :=TRUE;
       END IF;
    END LOOP;
  ELSE -- SERVICIOS
    FOR A IN C_LeeServiciosOrden(pv_No_Cia,pv_No_Orden) LOOP
       IF A.CANTIDAD > 1 THEN
         Lb_ExisteRepetido :=TRUE;
       END IF;
    END LOOP;
  END IF;     

  IF Lb_ExisteRepetido THEN
    lv_error :='Existe Un Producto/Servicio Repetido en el Detalle de la Orden';
    RAISE le_error;
  END IF;
  EXCEPTION 
    WHEN le_error THEN
       pn_error := 1;
       pv_error := lv_error;
    when others then
       pn_error := 99;
       pv_error := 'Error PU_P_VALIDA_PRODUCTO-'||substr(sqlerrm,1,200);       

end;  

PROCEDURE CALCULA_COSTO_UNI(
                            pn_cantidad                    in                      TAPORDED.Cantidad%type,
                            pn_costo_uni                   in                      TAPORDED.Costo_Uni%type,
                            pn_monto_compra                out                     number
  ) IS
	 Ln_Valorcom  NUMBER;
	 Ln_CompraTot NUMBER;
BEGIN
  pn_monto_compra := ROUND(NVL(pn_cantidad,0) * NVL(pn_costo_uni,0),2);--EMUNOZ 23012013
END;


PROCEDURE CALCULA_VALOR_DSCTO(
                            pn_cantidad                    in                      TAPORDED.Cantidad%type,
                            pn_costo_uni                   in                      TAPORDED.Costo_Uni%type,
                            pn_descuento                   in                      TAPORDED.Descuento%type,
                            pn_valor_dscto                 out                     number
  ) IS
  Ln_Monto Number;
BEGIN
	Ln_monto := nvl(pn_cantidad,0) * nvl(pn_costo_uni,0);    
  pn_valor_dscto := ROUND(Ln_Monto * (pn_descuento/100),2);--EMUNOZ 23012013
END;

end MPK_MIGRA_NAF_FORMA_FAP25006;

/
