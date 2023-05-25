/**
 * Scripts para el reverso de los nombres tecnicos de los productos
 *
 * @author Leonardo Mero <lemero@telconet.ec>
 * @version 1.0 09-12-2022
 */


--DB_COMERCIAL
--Se reversa el cambio del nombre tecnico del producto SAFE ENTRY y eliminar la caracteristica SGI
UPDATE DB_COMERCIAL.ADMI_PRODUCTO
SET NOMBRE_TECNICO = 'OTROS'
WHERE ID_PRODUCTO  =
  (SELECT ID_PRODUCTO
  FROM DB_COMERCIAL.ADMI_PRODUCTO
  WHERE DESCRIPCION_PRODUCTO = 'SAFE ENTRY'
  AND ESTADO                 = 'Activo'
  );
 --Eliminar la caracteristica producto CODIGO PUNTO SGI
DELETE
FROM DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA
WHERE CARACTERISTICA_ID IN
  (SELECT ID_CARACTERISTICA
  FROM DB_COMERCIAL.ADMI_CARACTERISTICA
  WHERE DESCRIPCION_CARACTERISTICA = 'CODIGO PUNTO SGI'
  AND ESTADO                       = 'Activo'
  ); 
  

--Elimina la caracteristica CODIGO PUNTO SGI
DELETE
FROM DB_COMERCIAL.ADMI_CARACTERISTICA
WHERE ID_CARACTERISTICA IN
  (SELECT ID_CARACTERISTICA
  FROM DB_COMERCIAL.ADMI_CARACTERISTICA
  WHERE DESCRIPCION_CARACTERISTICA = 'CODIGO PUNTO SGI'
  AND ESTADO                       = 'Activo'
  ); 

--Eliminar la caracteristica producto 'NOMBRE TORRE SAFE ENTRY'
DELETE
FROM DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA
WHERE CARACTERISTICA_ID IN
  (SELECT ID_CARACTERISTICA
  FROM DB_COMERCIAL.ADMI_CARACTERISTICA
  WHERE DESCRIPCION_CARACTERISTICA = 'NOMBRE TORRE SAFE ENTRY'
  AND ESTADO                       = 'Activo'
  ); 
  

--Elimina la caracteristica 'NOMBRE TORRE SAFE ENTRY'
DELETE
FROM DB_COMERCIAL.ADMI_CARACTERISTICA
WHERE ID_CARACTERISTICA IN
  (SELECT ID_CARACTERISTICA
  FROM DB_COMERCIAL.ADMI_CARACTERISTICA
  WHERE DESCRIPCION_CARACTERISTICA = 'NOMBRE TORRE SAFE ENTRY'
  AND ESTADO                       = 'Activo'
  ); 
COMMIT;
/