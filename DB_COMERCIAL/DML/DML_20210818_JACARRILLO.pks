
--INSERTAR NUEVA CARACTERISTICA PARA DATA DE RECOMENDACIONES EQUIFAX
INSERT INTO DB_COMERCIAL.ADMI_CARACTERISTICA 
(
ID_CARACTERISTICA,
DESCRIPCION_CARACTERISTICA ,                     
TIPO_INGRESO,
ESTADO   ,
FE_CREACION    ,    
USR_CREACION  , 
FE_ULT_MOD   ,      
USR_ULT_MOD  ,
TIPO      ,
DETALLE_CARACTERISTICA
)VALUES (
 DB_COMERCIAL.SEQ_ADMI_CARACTERISTICA.NEXTVAL, 
 'EQUIFAX_RECOMENDACION', 
 'A', 
 'Activo',
  SYSDATE ,
 'jacarrillo',
  SYSDATE ,
 'jacarrillo',
 'COMERCIAL', 
 'Data json de equifax' 
);

 COMMIT;
/
 