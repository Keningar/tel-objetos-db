CREATE SEQUENCE SEQ_ADMI_SERVICIO_SSO
  INCREMENT BY 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1;

CREATE SEQUENCE SEQ_REGX_REGIS_SERVICE
  INCREMENT BY 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1;

CREATE TABLE admi_servicio_sso
(
  id_servicio_sso INT NOT NULL,
  nombre_servicio VARCHAR (255) NOT NULL,
  service_target VARCHAR (255) NOT NULL,
  descripcion VARCHAR (255) NOT NULL,
  tipo_autenticacion VARCHAR (100) NOT NULL,
  departamento_responsable VARCHAR (255) NOT NULL,
  nombre_responsable VARCHAR (255) NOT NULL,
  correo_responsable VARCHAR (255) NOT NULL,
  autorizar_cas BOOLEAN NOT NULL,
  estado VARCHAR (100) NOT NULL,
  usr_creacion VARCHAR (100) NOT NULL,
  fe_creacion TIMESTAMP NOT NULL,
  ip_creacion VARCHAR (100) NOT NULL,
  usr_ult_mod VARCHAR (100),
  fe_ult_mod TIMESTAMP,
  ip_ult_mod VARCHAR (100),
  CONSTRAINT id_servicio_sso_pkey PRIMARY KEY (id_servicio_sso)
);

/
