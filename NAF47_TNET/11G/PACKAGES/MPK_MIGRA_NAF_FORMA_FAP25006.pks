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


begin
  -- Call the procedure

  MPK_MIGRA_NAF_FORMA_FAP25006.GCP_FAP25006_POSTQUERY_UNO@GPOETNET (pv_nosolic_origen => pv_nosolic_origen,
                                                                     pv_Moneda => pv_Moneda,
                                                                     pv_No_Cia => pv_No_Cia,
                                                                     pv_no_prove => pv_no_prove,
                                                                     pv_No_Orden => pv_No_Orden,
                                                                     pv_adjudicador => pv_adjudicador,
                                                                     pv_Bodega => pv_Bodega,
                                                                     pv_ID_TIPO_FRECUENCIA_PAGO => pv_ID_TIPO_FRECUENCIA_PAGO,
                                                                     pn_PEDIDO_DETALLE_ID => pn_PEDIDO_DETALLE_ID,
                                                                     pv_TIPO_DISTRIBUCION_COSTO => pv_TIPO_DISTRIBUCION_COSTO,
                                                                     pv_ID_TIPO_TRANSACCION => pv_ID_TIPO_TRANSACCION,
                                                                     pv_no_solic => pv_no_solic,
                                                                     pv_nombre_moneda => pv_nombre_moneda,
                                                                     pv_nombre_empleado => pv_nombre_empleado,
                                                                     pv_desc_bodega => pv_desc_bodega,
                                                                     pv_W_DESCRIPCION_FRECUENCIA => pv_W_DESCRIPCION_FRECUENCIA,
                                                                     pv_W_ID_JEFE_EMPLEADO => pv_W_ID_JEFE_EMPLEADO,
                                                                     pv_W_DESC_NOMBRE_EMPLEADO_JEFE => pv_W_DESC_NOMBRE_EMPLEADO_JEFE,
                                                                     pn_W_PEDIDO_ID => pn_W_PEDIDO_ID,
                                                                     pv_W_ASIGNA_ARBOL_COSTO => pv_W_ASIGNA_ARBOL_COSTO,
                                                                     pv_W_INGRESA_MONTO => pv_W_INGRESA_MONTO,
                                                                     pn_error => pn_error,
                                                                     pv_error => pv_error);
end;

procedure GCP_FAP25006_PRE_INSERT_UNO(
                                      pv_No_Cia                      in         TAPORDEE.No_Cia%type,
                                      pv_no_prove                    in         TAPORDEE.No_Prove%type,
                                      pv_no_orden                    in out        TAPORDEE.No_Orden%type,
                                      pn_Tipo_cambio                 out           arcgal.tipo_cambio%TYPE,
                                      pn_error                       out        number,
                                      pv_error                       out        varchar2                                      
)is

begin
  MPK_MIGRA_NAF_FORMA_FAP25006.GCP_FAP25006_PRE_INSERT_UNO@GPOETNET( pv_No_Cia => pv_No_Cia,
                                                                     pv_no_prove => pv_no_prove,
                                                                     pv_No_Orden => pv_No_Orden,
                                                                     pn_Tipo_cambio => pn_Tipo_cambio,
                                                                     pn_error => pn_error,
                                                                     pv_error => pv_error);  

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

begin
    MPK_MIGRA_NAF_FORMA_FAP25006.GCP_FAP25006_POSTQUERY_DOS@GPOETNET(pv_No_Cia => pv_No_Cia,
                                                                      pv_no_arti => pv_no_arti,
                                                                      pv_ind_no_inv => pv_ind_no_inv,
                                                                      pv_Bodega => pv_Bodega,
                                                                      pv_codigo_ni => pv_codigo_ni,
                                                                      pn_cantidad => pn_cantidad,
                                                                      pn_costo_uni => pn_costo_uni,
                                                                      pn_descuento => pn_descuento,
                                                                      pn_valor_dscto => pn_valor_dscto,
                                                                      pn_monto_compra => pn_monto_compra,
                                                                      pn_stock => pn_stock,
                                                                      pn_factor => pn_factor,
                                                                      pv_unidad_prov => pv_unidad_prov,
                                                                      pv_w_modelo => pv_w_modelo,
                                                                      pv_medida_prov => pv_medida_prov,
                                                                      pn_error => pn_error,
                                                                      pv_error => pv_error);
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
     )is
 begin
   MPK_MIGRA_NAF_FORMA_FAP25006.GCP_FAP25006_BT_EMITIR_UNO@GPOETNET(pv_No_Cia => pv_No_Cia,
                                                                    pv_adjudicador => pv_adjudicador,
                                                                    pn_PEDIDO_DETALLE_ID => pn_PEDIDO_DETALLE_ID,
                                                                    pv_ind_no_inv => pv_ind_no_inv,
                                                                    pv_No_Orden => pv_No_Orden,
                                                                    pv_ID_TIPO_TRANSACCION => pv_ID_TIPO_TRANSACCION,
                                                                    pv_W_ID_JEFE_EMPLEADO => pv_W_ID_JEFE_EMPLEADO,
                                                                    pn_error => pn_error,
                                                                    pv_error => pv_error);
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

  begin

    MPK_MIGRA_NAF_FORMA_FAP25006.PU_WHEN_CREATERECORD_UNO@GPOETNET(pv_No_Cia => pv_No_Cia,
                                                                    Pv_IdUsuario => Pv_IdUsuario,
                                                                    pv_ID_TIPO_TRANSACCION => pv_ID_TIPO_TRANSACCION,
                                                                    pp_ID_ORDEN => pp_ID_ORDEN,
                                                                    pp_TIPO_DISTRIBUCION_COSTO => pp_TIPO_DISTRIBUCION_COSTO,
                                                                    pp_ESTADO_ACTIVO => pp_ESTADO_ACTIVO,
                                                                    pp_CONTROL_PRESUPUESTO => pp_CONTROL_PRESUPUESTO,
                                                                    Pv_IdEmpleado => Pv_IdEmpleado,
                                                                    pv_nombre_empleado => pv_nombre_empleado,
                                                                    pv_W_ID_JEFE_EMPLEADO => pv_W_ID_JEFE_EMPLEADO,
                                                                    pv_W_DESC_NOMBRE_EMPLEADO_JEFE => pv_W_DESC_NOMBRE_EMPLEADO_JEFE,
                                                                    pv_TIPO_DISTRIBUCION_COSTO => pv_TIPO_DISTRIBUCION_COSTO,
                                                                    pn_error => pn_error,
                                                                    pv_error => pv_error);
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

  Lv_CodigoError   VARCHAR2(30):=NULL;
  Lv_MensajeError  VARCHAR2(3000):=NULL;
  Le_Error         EXCEPTION;
BEGIN

  MPK_MIGRA_NAF_FORMA_FAP25006.PU_P_INICIALIZA_FORMA@GPOETNET(pv_No_Cia => pv_No_Cia,
                                                               --Pv_GrupoParametro => Pv_GrupoParametro,
                                                               --Pv_IdAplicacion => Pv_IdAplicacion,
                                                               --Pv_IdParametro => Pv_IdParametro,
                                                               Pv_IdTipoTransaccion => Pv_IdTipoTransaccion,
                                                               Pv_user => Pv_user,
                                                               Pv_IdEmpleado => Pv_IdEmpleado,
                                                               Pv_Usuario => Pv_Usuario,
                                                               pn_error => pn_error,
                                                               pv_error => pv_error);

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
      Pv_MensajeError := 'El c\F3digo de Empresa no puede ser Vacio.';
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
      Pv_MensajeError := 'El c\F3digo de la empresa no puede ser nulo.';
      RAISE Le_Error;
    END IF;
    IF Pv_IdEmpleado IS NULL THEN
      Pv_MensajeError := 'El c\F3digo del empleado no puede ser nulo.';
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
