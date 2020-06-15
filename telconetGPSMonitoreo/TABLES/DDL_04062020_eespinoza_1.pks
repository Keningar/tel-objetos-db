/*
 * Creación de la tabla 'admi_parametro', encargada de
 * almacenar los admi_parametro de gps.
 */
CREATE TABLE telconetGPSMonitoreo.admi_parametro
(
  id_parametro          INT AUTO_INCREMENT NOT NULL    COMMENT 'ID DE LA TABLA',
  detalle               VARCHAR(30)                    COMMENT 'NOMBRE DEL DETALLE DEL PARAMETRO',
  valor                 VARCHAR(50)                    COMMENT 'VALOR DEL DETALLE DEL PARAMETRO',
  usr_creacion          VARCHAR(30)   NOT NULL         COMMENT 'USUARIO DE CREACION',
  fe_creacion           DATETIME                       COMMENT 'FECHA DE CREACION',
  ip_creacion           VARCHAR(30)   NOT NULL         COMMENT 'IP DE CREACION',
  usr_modificacion      VARCHAR(30)                    COMMENT 'USUARIO DE MODIFICACION',
  fe_modificacion       DATETIME                       COMMENT 'FECHA DE MODIFICACION',
  ip_modificacion       VARCHAR(30)                    COMMENT 'IP DE MODIFICACION',
  estado                VARCHAR(30)   NOT NULL         COMMENT 'ESTADO DEL PARAMETRO',
  PRIMARY KEY pk_id_parametro (id_parametro)
) comment='TABLA QUE ALMACENA LOS PARAMETROS EN EL ESQUEMA DE GPS';
