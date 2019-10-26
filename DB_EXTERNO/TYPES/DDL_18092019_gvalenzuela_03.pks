/*
 * Creación de los TYPE OBJECT y TABLE para la actualización masiva de los procesos de promoción. 
 */

CREATE OR REPLACE TYPE DB_EXTERNO.Gr_Promocion IS OBJECT(
    ID_PROCESO_PROMO NUMBER,
    DETALLE_MAPEO_ID NUMBER,
    ESTADO           VARCHAR2(20),
    OBSERVACION      VARCHAR2(4000),
    OPCION_PROCESO   VARCHAR2(20),
    AB_PROMO         VARCHAR2(50)
);
/

CREATE OR REPLACE TYPE DB_EXTERNO.Gtl_Promociones AS TABLE OF DB_EXTERNO.Gr_Promocion;
/
