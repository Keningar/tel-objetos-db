CREATE OR REPLACE TRIGGER NAF47_TNET.AFTER_DML_ADMI_PROYECTO
  after INSERT on NAF47_TNET.ADMI_PROYECTO 
  for each row
declare
/**
  * Documentacion para trigger AFTER_DML_ADMI_PROYECTO
  * Trigger que asigna registros relacion entre Proyectos-Region y Proyectos-Cuentas Contables
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 28-06-2021
  * @since 1.0
  */
  --
  CONTROL_PRESUPUESTO CONSTANT VARCHAR2(19) := 'CONTROL_PRESUPUESTO';
  DIVISION_REGIONAL   CONSTANT VARCHAR2(17) := 'DIVISION_REGIONAL';
  LINEA_NEGOCIO       CONSTANT VARCHAR2(13) := 'LINEA_NEGOCIO';
  --
  -- local variables here
  CURSOR C_REGIONES (Cv_EmpresaId VARCHAR2) IS
    SELECT APD.ID_PARAMETRO_DET
    FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
    WHERE APD.DESCRIPCION = DIVISION_REGIONAL
    AND APD.EMPRESA_COD = Cv_EmpresaId
    AND APD.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
    AND EXISTS (SELECT NULL
                FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                WHERE APC.NOMBRE_PARAMETRO = CONTROL_PRESUPUESTO
                AND APC.ID_PARAMETRO = APD.PARAMETRO_ID);
  --

BEGIN
  --
  FOR Lr_Region IN C_REGIONES(:NEW.NO_CIA) LOOP
    --
    INSERT INTO NAF47_TNET.ADMI_PROYECTO_REGION
         (ID_PROYECTO_REGION, 
          PROYECTO_ID, 
          REGION_ID, 
          ESTADO )
    VALUES
         (NAF47_TNET.SEQ_ADMI_PROYECTO_REGION.NEXTVAL,
          :NEW.ID_PROYECTO,
          Lr_Region.ID_PARAMETRO_DET,
          NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO);
    --
  END LOOP;
  --
  --
  INSERT INTO  NAF47_TNET.ADMI_PROYECTO_CUENTA
       ( ID_PROYECTO_CUENTA,
         VERTICAL_ID,
         PROYECTO_ID,
         NO_CIA_CUENTA,
         ESTADO )
  SELECT NAF47_TNET.SEQ_ADMI_PROYECTO_CUENTA.NEXTVAL,
         APD.ID_PARAMETRO_DET,
         :NEW.ID_PROYECTO,
         :NEW.NO_CIA,
         NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
  FROM ADMI_PARAMETRO_DET APD
  WHERE APD.EMPRESA_COD = :NEW.NO_CIA
  AND APD.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
  AND EXISTS (SELECT NULL
              FROM ADMI_PARAMETRO_CAB APC
              WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
              AND APC.DESCRIPCION = LINEA_NEGOCIO
              );
  --
end AFTER_DML_ADMI_PROYECTO;

/
