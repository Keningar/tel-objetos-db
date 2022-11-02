/*
 * Debe ejecutarse en esquema Public de SSO
 * @author David De La Cruz <ddelacruz@telconet.ec>
 * @version 1.0 02-08-2022 - Versión Inicial.
 */

/** Creación de secuencias del modelo de datos para Autorizador **/

CREATE SEQUENCE seq_admi_empresa
  INCREMENT BY 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1;

CREATE SEQUENCE seq_admi_aplicacion
  INCREMENT BY 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1;

CREATE SEQUENCE seq_admi_rol
  INCREMENT BY 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1;

CREATE SEQUENCE seq_admi_operacion
  INCREMENT BY 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1;

CREATE SEQUENCE seq_info_usuario
  INCREMENT BY 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1;

CREATE SEQUENCE seq_info_recurso
  INCREMENT BY 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1;

CREATE SEQUENCE seq_info_permiso
  INCREMENT BY 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1;

CREATE SEQUENCE seq_info_rol_permiso
  INCREMENT BY 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1;

CREATE SEQUENCE seq_info_contexto
  INCREMENT BY 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1;

CREATE SEQUENCE seq_info_delegacion
  INCREMENT BY 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1;

/** Creación de tablas del modelo de datos para Autorizador **/

CREATE TABLE admi_empresa
(
  id_empresa INT NOT NULL ,
  codigo VARCHAR (36) NOT NULL,
  nombre VARCHAR (255) NOT NULL,
  estado VARCHAR (15) NOT NULL,
  usr_creacion VARCHAR (100) NOT NULL,
  fe_creacion TIMESTAMP NOT NULL,
  ip_creacion VARCHAR (70) NOT NULL,
  usr_ult_mod VARCHAR (100),
  fe_ult_mod TIMESTAMP,
  ip_ult_mod VARCHAR (70),
  CONSTRAINT admi_empresa_pk PRIMARY KEY (id_empresa)
);

COMMENT ON COLUMN admi_empresa.id_empresa IS 'Identificador secuencial de la empresa del grupo Telcos';
COMMENT ON COLUMN admi_empresa.codigo IS 'Identificador UUID de la empresa del grupo Telcos';
COMMENT ON COLUMN admi_empresa.nombre IS 'Nombre de la empresa del grupo Telcos';
COMMENT ON COLUMN admi_empresa.estado IS 'Estado de la empresa del grupo Telcos';
COMMENT ON COLUMN admi_empresa.usr_creacion IS 'Usuario de creación de la empresa del grupo Telcos';
COMMENT ON COLUMN admi_empresa.fe_creacion IS 'Fecha de creación de la empresa del grupo Telcos';
COMMENT ON COLUMN admi_empresa.ip_creacion IS 'Ip de creación de la empresa del grupo Telcos';
COMMENT ON COLUMN admi_empresa.usr_ult_mod IS 'Usuario de la última modificación de la empresa del grupo Telcos';
COMMENT ON COLUMN admi_empresa.fe_ult_mod IS 'Fecha de la última modificación de la empresa del grupo Telcos';
COMMENT ON COLUMN admi_empresa.ip_ult_mod IS 'Ip de la última modificación de la empresa del grupo Telcos';

CREATE TABLE admi_aplicacion
(
  id_aplicacion INT NOT NULL,
  codigo VARCHAR (36) NOT NULL,
  empresa_id INT NOT NULL,
  nombre VARCHAR (255) NOT NULL,
  url_dominio VARCHAR (255) NOT NULL,
  estado VARCHAR (15) NOT NULL,
  usr_creacion VARCHAR (100) NOT NULL,
  fe_creacion TIMESTAMP NOT NULL,
  ip_creacion VARCHAR (70) NOT NULL,
  usr_ult_mod VARCHAR (100),
  fe_ult_mod TIMESTAMP,
  ip_ult_mod VARCHAR (70),
  CONSTRAINT admi_aplicacion_pk PRIMARY KEY (id_aplicacion),
  CONSTRAINT admi_aplicacion_fk_1 FOREIGN KEY (empresa_id) REFERENCES admi_empresa (id_empresa)
);

COMMENT ON COLUMN admi_aplicacion.id_aplicacion IS 'Identificador secuencial de la aplicación a controlar con token de autorización';
COMMENT ON COLUMN admi_aplicacion.codigo IS 'Identificador UUID de la aplicación';
COMMENT ON COLUMN admi_aplicacion.empresa_id IS 'Id de la empresa del grupo Telcos al que pertenece la aplicación';
COMMENT ON COLUMN admi_aplicacion.nombre IS 'Nombre de la aplicación';
COMMENT ON COLUMN admi_aplicacion.url_dominio IS 'Url del dominio que identifica a la aplicación, es el serviceTarget en las configuraciones de Gateway con CAS';
COMMENT ON COLUMN admi_aplicacion.estado IS 'Estado de la aplicación';
COMMENT ON COLUMN admi_aplicacion.usr_creacion IS 'Usuario de creación de la aplicación';
COMMENT ON COLUMN admi_aplicacion.fe_creacion IS 'Fecha de creación de la aplicación';
COMMENT ON COLUMN admi_aplicacion.ip_creacion IS 'Ip de creación de la aplicación';
COMMENT ON COLUMN admi_aplicacion.usr_ult_mod IS 'Usuario de la última modificación de la aplicación';
COMMENT ON COLUMN admi_aplicacion.fe_ult_mod IS 'Fecha de la última modificación de la aplicación';
COMMENT ON COLUMN admi_aplicacion.ip_ult_mod IS 'Ip de la última modificación de la aplicación';

CREATE TABLE admi_rol
(
  id_rol INT NOT NULL,
  codigo VARCHAR (36) NOT NULL,
  aplicacion_id INT NOT NULL,
  rol_id INT,
  nombre VARCHAR (255) NOT NULL,
  descripcion VARCHAR (255) NOT NULL,
  valida_contexto VARCHAR (1) NOT NULL,
  estado VARCHAR (15) NOT NULL,
  usr_creacion VARCHAR (100) NOT NULL,
  fe_creacion TIMESTAMP NOT NULL,
  ip_creacion VARCHAR (70) NOT NULL,
  usr_ult_mod VARCHAR (100),
  fe_ult_mod TIMESTAMP,
  ip_ult_mod VARCHAR (70),
  CONSTRAINT admi_rol_pk PRIMARY KEY (id_rol),
  CONSTRAINT admi_rol_fk_1 FOREIGN KEY (aplicacion_id) REFERENCES admi_aplicacion (id_aplicacion),
  CONSTRAINT admi_rol_fk_2 FOREIGN KEY (rol_id) REFERENCES admi_rol (id_rol)
);

COMMENT ON COLUMN admi_rol.id_rol IS 'Identificador secuencial del rol';
COMMENT ON COLUMN admi_rol.codigo IS 'Identificador UUID del rol';
COMMENT ON COLUMN admi_rol.aplicacion_id IS 'Identificador de la aplicación al cual pertenece el rol';
COMMENT ON COLUMN admi_rol.rol_id IS 'Identificador del rol padre, solo aplica para roles anidados';
COMMENT ON COLUMN admi_rol.nombre IS 'Nombre del rol';
COMMENT ON COLUMN admi_rol.descripcion IS 'Descripción del rol';
COMMENT ON COLUMN admi_rol.valida_contexto IS 'Indica si con el rol de la aplicación, el token de autorización debe validar el valor del contexto, S o N';
COMMENT ON COLUMN admi_rol.estado IS 'Estado del rol';
COMMENT ON COLUMN admi_rol.usr_creacion IS 'Usuario de creación del rol';
COMMENT ON COLUMN admi_rol.fe_creacion IS 'Fecha de creación del rol';
COMMENT ON COLUMN admi_rol.ip_creacion IS 'Ip de creación del rol';
COMMENT ON COLUMN admi_rol.usr_ult_mod IS 'Usuario de la última modificación del rol';
COMMENT ON COLUMN admi_rol.fe_ult_mod IS 'Fecha de la última modificación del rol';
COMMENT ON COLUMN admi_rol.ip_ult_mod IS 'Ip de la última modificación del rol';

CREATE TABLE admi_operacion
(
  id_operacion INT NOT NULL,
  codigo VARCHAR (36) NOT NULL,
  descripcion VARCHAR (255) NOT NULL,
  estado VARCHAR (15) NOT NULL,
  usr_creacion VARCHAR (100) NOT NULL,
  fe_creacion TIMESTAMP NOT NULL,
  ip_creacion VARCHAR (70) NOT NULL,
  usr_ult_mod VARCHAR (100),
  fe_ult_mod TIMESTAMP,
  ip_ult_mod VARCHAR (70),
  CONSTRAINT admi_operacion_pk PRIMARY KEY (id_operacion)
);

COMMENT ON COLUMN admi_operacion.id_operacion IS 'Identificador secuencial de la operación';
COMMENT ON COLUMN admi_operacion.codigo IS 'Identificador UUID de la operación';
COMMENT ON COLUMN admi_operacion.descripcion IS 'Descripción de la operación, es el nombre de una acción que podrá asociarse a un recurso';
COMMENT ON COLUMN admi_operacion.estado IS 'Estado de la operación';
COMMENT ON COLUMN admi_operacion.usr_creacion IS 'Usuario de creación de la operación';
COMMENT ON COLUMN admi_operacion.fe_creacion IS 'Fecha de creación de la operación';
COMMENT ON COLUMN admi_operacion.ip_creacion IS 'Ip de creación de la operación';
COMMENT ON COLUMN admi_operacion.usr_ult_mod IS 'Usuario de la última modificación de la operación';
COMMENT ON COLUMN admi_operacion.fe_ult_mod IS 'Fecha de la última modificación de la operación';
COMMENT ON COLUMN admi_operacion.ip_ult_mod IS 'Ip de la última modificación de la operación';

CREATE TABLE info_usuario
(
  id_usuario INT NOT NULL,
  codigo VARCHAR (36) NOT NULL,
  nombre VARCHAR (255) NOT NULL,
  apellido VARCHAR (255) NOT NULL,
  identificador_usuario VARCHAR (100) NOT NULL,
  clave VARCHAR (100),
  descripcion VARCHAR (255),
  estado VARCHAR (15) NOT NULL,
  usr_creacion VARCHAR (100) NOT NULL,
  fe_creacion TIMESTAMP NOT NULL,
  ip_creacion VARCHAR (70) NOT NULL,
  usr_ult_mod VARCHAR (100),
  fe_ult_mod TIMESTAMP,
  ip_ult_mod VARCHAR (70),
  CONSTRAINT info_usuario_pk PRIMARY KEY (id_usuario)
);

COMMENT ON COLUMN info_usuario.id_usuario IS 'Identificador secuencial del usuario';
COMMENT ON COLUMN info_usuario.codigo IS 'Identificador UUID del usuario';
COMMENT ON COLUMN info_usuario.nombre IS 'Nombre del usuario';
COMMENT ON COLUMN info_usuario.apellido IS 'Apellido del usuario';
COMMENT ON COLUMN info_usuario.identificador_usuario IS 'Identificador del usuario para autenticación, es decir, login, username, etc';
COMMENT ON COLUMN info_usuario.clave IS 'Password del usaurio para autenticación, aplica para usuarios que no se crean en LDAPs';
COMMENT ON COLUMN info_usuario.descripcion IS 'Descripción del usuario, detalles adicionales sobre el usuario';
COMMENT ON COLUMN info_usuario.estado IS 'Estado del usuario';
COMMENT ON COLUMN info_usuario.usr_creacion IS 'Usuario de creación del usuario';
COMMENT ON COLUMN info_usuario.fe_creacion IS 'Fecha de creación del usuario';
COMMENT ON COLUMN info_usuario.ip_creacion IS 'Ip de creación del usuario';
COMMENT ON COLUMN info_usuario.usr_ult_mod IS 'Usuario de la última modificación del usuario';
COMMENT ON COLUMN info_usuario.fe_ult_mod IS 'Fecha de la última modificación del usuario';
COMMENT ON COLUMN info_usuario.ip_ult_mod IS 'Ip de la última modificación del usuario';

CREATE TABLE info_recurso
(
  id_recurso INT NOT NULL,
  codigo VARCHAR (36) NOT NULL,
  descripcion VARCHAR (255) NOT NULL,
  ruta TEXT NOT NULL,
  tipo_recurso VARCHAR (10) NOT NULL,
  recurso_id INT,
  tipo_componente VARCHAR (255),
  id_componente VARCHAR (255),
  icono varchar(100),
  orden INT DEFAULT 0,
  estado VARCHAR (15) NOT NULL,
  usr_creacion VARCHAR (100) NOT NULL,
  fe_creacion TIMESTAMP NOT NULL,
  ip_creacion VARCHAR (70) NOT NULL,
  usr_ult_mod VARCHAR (100),
  fe_ult_mod TIMESTAMP,
  ip_ult_mod VARCHAR (70),
  CONSTRAINT info_recurso_pk PRIMARY KEY (id_recurso),
  CONSTRAINT info_recurso_fk_1 FOREIGN KEY (recurso_id) REFERENCES info_recurso (id_recurso)
);

COMMENT ON COLUMN info_recurso.id_recurso IS 'Identificador secuencial del recurso';
COMMENT ON COLUMN info_recurso.codigo IS 'Identificador UUID del recurso';
COMMENT ON COLUMN info_recurso.descripcion IS 'Descripción del recurso';
COMMENT ON COLUMN info_recurso.ruta IS 'Ruta o Path del recurso';
COMMENT ON COLUMN info_recurso.tipo_recurso IS 'Tipo de recurso, API o WEB';
COMMENT ON COLUMN info_recurso.recurso_id IS 'Identificador del recurso padre, solo aplica para recursos de tipo WEB que se encuentren anidados';
COMMENT ON COLUMN info_recurso.tipo_componente IS 'Tipo del componente WEB, solo aplica para recursos de tipo WEB';
COMMENT ON COLUMN info_recurso.id_componente IS 'Id del componente WEB, identificador que puede utilizarse en el front de la aplicación, solo aplica para recursos de tipo WEB';
COMMENT ON COLUMN info_recurso.icono IS 'Icono del componente WEB en casos de requerirse, solo aplica para recursos de tipo WEB';
COMMENT ON COLUMN info_recurso.orden IS 'Orden del componente WEB para mostrarse en el aplicativo Front, solo aplica para recursos de tipo WEB, por defecto es con valor 0';
COMMENT ON COLUMN info_recurso.estado IS 'Estado del recurso';
COMMENT ON COLUMN info_recurso.usr_creacion IS 'Usuario de creación del recurso';
COMMENT ON COLUMN info_recurso.fe_creacion IS 'Fecha de creación del recurso';
COMMENT ON COLUMN info_recurso.ip_creacion IS 'Ip de creación del recurso';
COMMENT ON COLUMN info_recurso.usr_ult_mod IS 'Usuario de la última modificación del recurso';
COMMENT ON COLUMN info_recurso.fe_ult_mod IS 'Fecha de la última modificación del recurso';
COMMENT ON COLUMN info_recurso.ip_ult_mod IS 'Ip de la última modificación del recurso';

CREATE TABLE info_permiso
(
  id_permiso INT NOT NULL,
  codigo VARCHAR (36) NOT NULL,
  operacion_id INT NOT NULL,
  recurso_id INT NOT NULL,
  nombre VARCHAR (255) NOT NULL,
  estado VARCHAR (15) NOT NULL,
  usr_creacion VARCHAR (100) NOT NULL,
  fe_creacion TIMESTAMP NOT NULL,
  ip_creacion VARCHAR (70) NOT NULL,
  usr_ult_mod VARCHAR (100),
  fe_ult_mod TIMESTAMP,
  ip_ult_mod VARCHAR (70),
  CONSTRAINT info_permiso_pk PRIMARY KEY (id_permiso),
  CONSTRAINT info_permiso_fk_1 FOREIGN KEY (operacion_id) REFERENCES admi_operacion (id_operacion),
  CONSTRAINT info_permiso_fk_2 FOREIGN KEY (recurso_id) REFERENCES info_recurso (id_recurso)
);

COMMENT ON COLUMN info_permiso.id_permiso IS 'Identificador secuencial del permiso';
COMMENT ON COLUMN info_permiso.codigo IS 'Identificador UUID del permiso';
COMMENT ON COLUMN info_permiso.operacion_id IS 'Identificador de la operación que se habilitará como permiso para el recurso';
COMMENT ON COLUMN info_permiso.recurso_id IS 'Identificador del recurso al que se habilitará el permiso';
COMMENT ON COLUMN info_permiso.nombre IS 'Nombre o descripción del permiso';
COMMENT ON COLUMN info_permiso.estado IS 'Estado del permiso';
COMMENT ON COLUMN info_permiso.usr_creacion IS 'Usuario de creación del permiso';
COMMENT ON COLUMN info_permiso.fe_creacion IS 'Fecha de creación del permiso';
COMMENT ON COLUMN info_permiso.ip_creacion IS 'Ip de creación del permiso';
COMMENT ON COLUMN info_permiso.usr_ult_mod IS 'Usuario de la última modificación del permiso';
COMMENT ON COLUMN info_permiso.fe_ult_mod IS 'Fecha de la última modificación del permiso';
COMMENT ON COLUMN info_permiso.ip_ult_mod IS 'Ip de la última modificación del permiso';

CREATE TABLE info_rol_permiso
(
  id_rol_permiso INT NOT NULL,
  rol_id INT NOT NULL,
  permiso_id INT NOT NULL,
  estado VARCHAR (15) NOT NULL,
  usr_creacion VARCHAR (100) NOT NULL,
  fe_creacion TIMESTAMP NOT NULL,
  ip_creacion VARCHAR (70) NOT NULL,
  usr_ult_mod VARCHAR (100),
  fe_ult_mod TIMESTAMP,
  ip_ult_mod VARCHAR (70),
  CONSTRAINT info_rol_permiso_pk PRIMARY KEY (id_rol_permiso),
  CONSTRAINT info_rol_permiso_fk_1 FOREIGN KEY (rol_id) REFERENCES admi_rol (id_rol),
  CONSTRAINT info_rol_permiso_fk_2 FOREIGN KEY (permiso_id) REFERENCES info_permiso (id_permiso)
);

COMMENT ON COLUMN info_rol_permiso.id_rol_permiso IS 'Identificador secuencial de la asignación del rol con el permiso';
COMMENT ON COLUMN info_rol_permiso.rol_id IS 'Identificador del rol que se asigna con el permiso';
COMMENT ON COLUMN info_rol_permiso.permiso_id IS 'Identificador del permiso que se asigna con el rol';
COMMENT ON COLUMN info_rol_permiso.estado IS 'Estado de la asignación del rol con el permiso';
COMMENT ON COLUMN info_rol_permiso.usr_creacion IS 'Usuario de creación de la asignación del rol con el permiso';
COMMENT ON COLUMN info_rol_permiso.fe_creacion IS 'Fecha de creación de la asignación del rol con el permiso';
COMMENT ON COLUMN info_rol_permiso.ip_creacion IS 'Ip de creación de la asignación del rol con el permiso';
COMMENT ON COLUMN info_rol_permiso.usr_ult_mod IS 'Usuario de la última modificación de la asignación del rol con el permiso';
COMMENT ON COLUMN info_rol_permiso.fe_ult_mod IS 'Fecha de la última modificación de la asignación del rol con el permiso';
COMMENT ON COLUMN info_rol_permiso.ip_ult_mod IS 'Ip de la última modificación de la asignación del rol con el permiso';

CREATE TABLE info_contexto
(
  id_contexto INT NOT NULL,
  codigo VARCHAR (36) NOT NULL,
  usuario_id INT NOT NULL,
  aplicacion_id INT NOT NULL,
  rol_id INT NOT NULL,
  nombre VARCHAR (255) NOT NULL,
  valor VARCHAR (255) NOT NULL,
  token TEXT,
  firma TEXT,
  estado VARCHAR (15) NOT NULL,
  usr_creacion VARCHAR (100) NOT NULL,
  fe_creacion TIMESTAMP NOT NULL,
  ip_creacion VARCHAR (70) NOT NULL,
  usr_ult_mod VARCHAR (100),
  fe_ult_mod TIMESTAMP,
  ip_ult_mod VARCHAR (70),
  CONSTRAINT info_contexto_pk PRIMARY KEY (id_contexto),
  CONSTRAINT info_contexto_fk_1 FOREIGN KEY (usuario_id) REFERENCES info_usuario (id_usuario),
  CONSTRAINT info_contexto_fk_2 FOREIGN KEY (aplicacion_id) REFERENCES admi_aplicacion (id_aplicacion),
  CONSTRAINT info_contexto_fk_3 FOREIGN KEY (rol_id) REFERENCES admi_rol (id_rol)
);

COMMENT ON COLUMN info_contexto.id_contexto IS 'Identificador secuencial del contexto';
COMMENT ON COLUMN info_contexto.codigo IS 'Identificador UUID del contexto';
COMMENT ON COLUMN info_contexto.usuario_id IS 'Identificador del usuario que se asigna a un contexto';
COMMENT ON COLUMN info_contexto.aplicacion_id IS 'Identificador de la aplicación que se asigna a un contexto';
COMMENT ON COLUMN info_contexto.rol_id IS 'Identificador del rol que se asigna a un contexto';
COMMENT ON COLUMN info_contexto.nombre IS 'Nombre del contexto, puede ser cliente, dispositivo, empleado, etc, según el control que se requiere en la aplicación con el token de autorización';
COMMENT ON COLUMN info_contexto.valor IS 'Valor del contexto, según el nombre';
COMMENT ON COLUMN info_contexto.token IS 'Token de autorización creado según el contexto';
COMMENT ON COLUMN info_contexto.firma IS 'Firma o SALT del token de autorización';
COMMENT ON COLUMN info_contexto.estado IS 'Estado del contexto';
COMMENT ON COLUMN info_contexto.usr_creacion IS 'Usuario de creación del contexto';
COMMENT ON COLUMN info_contexto.fe_creacion IS 'Fecha de creación del contexto';
COMMENT ON COLUMN info_contexto.ip_creacion IS 'Ip de creación del contexto';
COMMENT ON COLUMN info_contexto.usr_ult_mod IS 'Usuario de la última modificación del contexto';
COMMENT ON COLUMN info_contexto.fe_ult_mod IS 'Fecha de la última modificación del contexto';
COMMENT ON COLUMN info_contexto.ip_ult_mod IS 'Ip de la última modificación del contexto';

CREATE TABLE info_delegacion
(
  id_delegacion INT NOT NULL,
  codigo VARCHAR (36) NOT NULL,
  usuario_id INT NOT NULL,
  contexto_id INT NOT NULL,
  descripcion VARCHAR (255) NOT NULL,
  usuario_id_delegador INT NOT NULL,
  fecha_inicio TIMESTAMP NOT NULL,
  fecha_fin TIMESTAMP NOT NULL,
  estado VARCHAR (15) NOT NULL,
  usr_creacion VARCHAR (100) NOT NULL,
  fe_creacion TIMESTAMP NOT NULL,
  ip_creacion VARCHAR (70) NOT NULL,
  usr_ult_mod VARCHAR (100),
  fe_ult_mod TIMESTAMP,
  ip_ult_mod VARCHAR (70),
  CONSTRAINT info_delegacion_pk PRIMARY KEY (id_delegacion),
  CONSTRAINT info_delegacion_fk_1 FOREIGN KEY (usuario_id) REFERENCES info_usuario (id_usuario),
  CONSTRAINT info_delegacion_fk_2 FOREIGN KEY (contexto_id) REFERENCES info_contexto (id_contexto)
);

COMMENT ON COLUMN info_delegacion.id_delegacion IS 'Identificador secuencial de la delegación';
COMMENT ON COLUMN info_delegacion.codigo IS 'Identificador UUID de la delegación';
COMMENT ON COLUMN info_delegacion.usuario_id IS 'Identificador del usuario a quien se delega un contexto';
COMMENT ON COLUMN info_delegacion.contexto_id IS 'Identificador del contexto delegado';
COMMENT ON COLUMN info_delegacion.descripcion IS 'Descripción de la delegación, detalles adicionales';
COMMENT ON COLUMN info_delegacion.usuario_id_delegador IS 'Identificador del usuario quién delega el contexto';
COMMENT ON COLUMN info_delegacion.fecha_inicio IS 'Fecha de inicio de la delegación, para controlar la vigencia';
COMMENT ON COLUMN info_delegacion.fecha_fin IS 'Fecha fin de la delegación, para controlar la vigencia';
COMMENT ON COLUMN info_delegacion.estado IS 'Estado de la delegación';
COMMENT ON COLUMN info_delegacion.usr_creacion IS 'Usuario de creación de la delegación';
COMMENT ON COLUMN info_delegacion.fe_creacion IS 'Fecha de creación de la delegación';
COMMENT ON COLUMN info_delegacion.ip_creacion IS 'Ip de creación de la delegación';
COMMENT ON COLUMN info_delegacion.usr_ult_mod IS 'Usuario de la última modificación de la delegación';
COMMENT ON COLUMN info_delegacion.fe_ult_mod IS 'Fecha de la última modificación de la delegación';
COMMENT ON COLUMN info_delegacion.ip_ult_mod IS 'Ip de la última modificación de la delegación';

create table shedlock
(
  name VARCHAR(64) not null,
  lock_until TIMESTAMP not null,
  locked_at TIMESTAMP not null,
  locked_by VARCHAR(255) not null,
  primary key (name)
);

COMMENT ON COLUMN shedlock.name IS 'Nombre del componente bloqueado';
COMMENT ON COLUMN shedlock.lock_until IS 'Fecha fin del bloqueo';
COMMENT ON COLUMN shedlock.locked_at IS 'Fecha inicio del bloqueo';
COMMENT ON COLUMN shedlock.locked_by IS 'Identificador de donde se realiza el bloqueo';

CREATE UNIQUE INDEX admi_empresa_uidx_1
ON admi_empresa(codigo);

CREATE UNIQUE INDEX admi_aplicacion_uidx_1
ON admi_aplicacion(codigo);

CREATE INDEX admi_aplicacion_idx_1
ON admi_aplicacion(url_dominio);

CREATE UNIQUE INDEX admi_operacion_uidx_1
ON admi_operacion(codigo);

CREATE UNIQUE INDEX info_recurso_uidx_1
ON info_recurso(codigo);

CREATE INDEX info_recurso_idx_1
ON info_recurso(ruta);

CREATE UNIQUE INDEX info_permiso_uidx_1
ON info_permiso(codigo);

CREATE UNIQUE INDEX admi_rol_uidx_1
ON admi_rol(codigo);

CREATE UNIQUE INDEX info_usuario_uidx_1
ON info_usuario(codigo);

CREATE INDEX info_usuario_idx_1
ON info_usuario(identificador_usuario);

CREATE UNIQUE INDEX info_contexto_uidx_1
ON info_contexto(codigo);

CREATE UNIQUE INDEX info_delegacion_uidx_1
ON info_delegacion(codigo);

CREATE INDEX info_contexto_idx_1
ON info_contexto(token);