CREATE OR REPLACE procedure NAF47_TNET.GCP_FAP25006_POSTQUERY_UNO(
pv_nosolic_origen              in         TAPORDEE.nosolic_origen%type,
pv_Moneda                      in         TAPORDEE.Moneda%type,
pv_No_Cia                      in         TAPORDEE.No_Cia%type,
pv_no_prove                    in         TAPORDEE.No_Prove%type,
pv_No_Orden                    in         TAPORDEE.No_Orden%Type,
pv_adjudicador                 in         TAPORDEE.Adjudicador%type,
pv_Bodega                      in         TAPORDEE.Bodega%type,
pv_ID_TIPO_FRECUENCIA_PAGO     in         TAPORDEE.Id_Tipo_Frecuencia_Pago%type,
pn_PEDIDO_DETALLE_ID           in         TAPORDEE.Pedido_Detalle_Id%type,

pv_no_solic                    out        varchar2,
pv_nombre_moneda               out        varchar2,
pv_nombre_empleado             out        varchar2,
pv_desc_bodega                 out        varchar2,
pv_W_DESCRIPCION_FRECUENCIA    out        varchar2,
pv_W_ID_JEFE_EMPLEADO          out        varchar2,
pv_W_DESC_NOMBRE_EMPLEADO_JEFE out        varchar2,

pn_error                       out        number,
pv_error                       out        varchar2
) is

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

lv_No_Orden                     TAPORDEE.No_Orden%Type;

lv_no_prove                     TAPORDEE.No_Prove%type;
lv_nomprov                      varchar2(100);
lv_adjudicador                  TAPORDEE.Adjudicador%type;
lv_Bodega                       TAPORDEE.Bodega%type;
le_error                        exception;
lv_error                        varchar2(250);
vReg_prove                      proveedor.datos_r;

lv_TIPO_DISTRIBUCION_COSTO      TAPORDEE.Tipo_Distribucion_Costo%type;
lp_TIPO_DISTRIBUCION_COSTO      varchar2(30):='TIPO-DISTRIBUCION-COSTO';
lv_ID_TIPO_TRANSACCION          TAPORDEE.ID_TIPO_TRANSACCION%type;
lp_CONTROL_PRESUPUESTO          varchar2(30):='CONTROL_PRESUPUESTO';


--Salida                 


lv_nombre_empleado                    varchar2(100);
lv_desc_bodega                        varchar2(100);


ln_W_PEDIDO_ID                        TAPORDEE.Id_Pedido%type;   
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
           RAISE le_error;
        ELSE	
           lv_nomprov := vReg_prove.nombre;
        END IF;
      EXCEPTION
        WHEN proveedor.error THEN
          lv_error:=proveedor.ultimo_error;
          RAISE le_error;
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
            RAISE le_error;
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
                  --MESSAGE('La bodega del centro de distribuci�n Matriz, no est� definida en inventario');
                  --SYNCHRONIZE;
                  --RAISE FORM_TRIGGER_FAILURE;
                  lv_error:='La bodega del centro de distribuci�n Matriz, no est� definida en inventario';
                  RAISE le_error;
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
/