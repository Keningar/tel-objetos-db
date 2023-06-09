/**
 * Actualizando el estado de las tablets, para solo dejar activas las siguientes:
 * - SM-T285
 * - SM-T295
 * - SM-T225
 * - GALAXY A33
 * - GALAXY A13
 * - GALAXY A03
 * 
 * Tambien se crearon las siguientes tablets.
 * - FOLD 4
 * - S22 ULTRA
 *
 * @author Kenth Encalada <kencalada@telconet.ec>
 * @version 1.0 09-06-2023
 */
UPDATE
  DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO AME
SET
  AME.ESTADO        = 'Inactivo',
  AME.USR_ULT_MOD   = 'kencalada',
  AME.FE_ULT_MOD    = SYSDATE
WHERE
  AME.TIPO_ELEMENTO_ID = '231'
  AND AME.ID_MODELO_ELEMENTO NOT IN ('2358', '2405', '3215', '3098', '3099', '2669');

INSERT INTO
  DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO AME (
    AME.ID_MODELO_ELEMENTO,
    AME.MARCA_ELEMENTO_ID,
    AME.TIPO_ELEMENTO_ID,
    AME.USR_CREACION,
    AME.USR_ULT_MOD,
    AME.FE_CREACION,
    AME.FE_ULT_MOD,
    AME.ESTADO,
    AME.NOMBRE_MODELO_ELEMENTO,
    AME.DESCRIPCION_MODELO_ELEMENTO
  )
VALUES
  (
    DB_INFRAESTRUCTURA.SEQ_ADMI_MODELO_ELEMENTO.NEXTVAL,
    '4661',
    '231',
    'kencalada',
    'kencalada',
    SYSDATE,
    SYSDATE,
    'Activo',
    'SM-F936B',
    'Celular Samsung Galaxy Fold 4'
  );

INSERT INTO
  DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO AME (
    AME.ID_MODELO_ELEMENTO,
    AME.MARCA_ELEMENTO_ID,
    AME.TIPO_ELEMENTO_ID,
    AME.USR_CREACION,
    AME.USR_ULT_MOD,
    AME.FE_CREACION,
    AME.FE_ULT_MOD,
    AME.ESTADO,
    AME.NOMBRE_MODELO_ELEMENTO,
    AME.DESCRIPCION_MODELO_ELEMENTO
  )
VALUES
  (
    DB_INFRAESTRUCTURA.SEQ_ADMI_MODELO_ELEMENTO.NEXTVAL,
    '4661',
    '231',
    'kencalada',
    'kencalada',
    SYSDATE,
    SYSDATE,
    'Activo',
    'SM-S908B',
    'Celular Samsung Galaxy S22 Ultra'
  );

COMMIT;

/