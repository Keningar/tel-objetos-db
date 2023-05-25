/**
 * Scripts para la configuracion de los nombres tecnicos del producto Safe Entry y la nueva caracteristica visible para comercial 
 *
 * @author Leonardo Mero <lemero@telconet.ec>
 * @version 1.0 09-12-2022
 */


--DB_COMERCIAL
--Se cambia el nombre tecnico del producto SAFE ENTRY
UPDATE DB_COMERCIAL.ADMI_PRODUCTO
SET NOMBRE_TECNICO = 'SAFE ENTRY'
WHERE ID_PRODUCTO  =
  (SELECT ID_PRODUCTO
  FROM DB_COMERCIAL.ADMI_PRODUCTO
  WHERE DESCRIPCION_PRODUCTO = 'SAFE ENTRY'
  AND ESTADO                 = 'Activo'
  );
-- Agregar la caracteristica CODIGO PUNTO SGI
INSERT
INTO DB_COMERCIAL.ADMI_CARACTERISTICA VALUES
  (
    DB_COMERCIAL.SEQ_ADMI_CARACTERISTICA.NEXTVAL,
    'CODIGO PUNTO SGI',
    'N',
    'Activo',
    SYSDATE,
    'lemero',
    NULL,
    NULL,
    'COMERCIAL',
    'Codigo del punto creado por Cajamarca SGI.'
  ); 
  
-- Agregar la caracteristica NOMBRE TORRE SAFE ENTRY
INSERT
INTO DB_COMERCIAL.ADMI_CARACTERISTICA VALUES
  (
    DB_COMERCIAL.SEQ_ADMI_CARACTERISTICA.NEXTVAL,
    'NOMBRE TORRE SAFE ENTRY',
    'T',
    'Activo',
    SYSDATE,
    'lemero',
    NULL,
    NULL,
    'COMERCIAL',
    'Nombre de la torre Safe Entry.'
  ); 
  
--Relacionar la caracteristica CODIGO PUNTO SGI con el servicio SAFE ENTRY
INSERT
INTO DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA VALUES
  (
     DB_COMERCIAL.SEQ_ADMI_PRODUCTO_CARAC.NEXTVAL,
    (SELECT ID_PRODUCTO
    FROM DB_COMERCIAL.ADMI_PRODUCTO
    WHERE ADMI_PRODUCTO.NOMBRE_TECNICO = 'SAFE ENTRY'
    AND ESTADO                         ='Activo'
    ),
    (SELECT DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA
    FROM DB_COMERCIAL.ADMI_CARACTERISTICA
    WHERE DESCRIPCION_CARACTERISTICA = 'CODIGO PUNTO SGI'
    AND ESTADO                       ='Activo'
    AND ROWNUM = 1
    ),
    SYSDATE,
    NULL,
    'lemero',
    NULL,
    'Activo',
    'SI'
  );

--Relacionar la caracteristica NOMBRE TORRE SAFE ENTRY con el servicio SAFE ENTRY
INSERT
INTO DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA VALUES
  (
     DB_COMERCIAL.SEQ_ADMI_PRODUCTO_CARAC.NEXTVAL,
    (SELECT ID_PRODUCTO
    FROM DB_COMERCIAL.ADMI_PRODUCTO
    WHERE ADMI_PRODUCTO.NOMBRE_TECNICO = 'SAFE ENTRY'
    AND ESTADO                         ='Activo'
    ),
    (SELECT DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA
    FROM DB_COMERCIAL.ADMI_CARACTERISTICA
    WHERE DESCRIPCION_CARACTERISTICA = 'NOMBRE TORRE SAFE ENTRY'
    AND ESTADO                       ='Activo'
    AND ROWNUM = 1
    ),
    SYSDATE,
    NULL,
    'lemero',
    NULL,
    'Activo',
    'SI'
  );

COMMIT;
/
