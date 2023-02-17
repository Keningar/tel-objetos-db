/**
 * DEBE EJECUTARSE EN DB_COMERCIAL
 * Script crear configuraciones adicionales proceso derecho legal(eliminacion)
 * @author William Sanchez <wdsanchez@telconet.ec>
 * @version 1.0 
 * @since 2023-01-22 - Versión Inicial.
 */

INSERT INTO DB_COMERCIAL.INFO_PERSONA (ID_PERSONA, 
                                       TITULO_ID,
                                       ORIGEN_PROSPECTO,
                                       TIPO_IDENTIFICACION,
                                       IDENTIFICACION_CLIENTE,
                                       TIPO_EMPRESA,
                                       TIPO_TRIBUTARIO,
                                       NOMBRES,
                                       APELLIDOS,
                                       RAZON_SOCIAL,
                                       REPRESENTANTE_LEGAL,
                                       NACIONALIDAD,
                                       DIRECCION,
                                       LOGIN,
                                       CARGO,
                                       DIRECCION_TRIBUTARIA,
                                       GENERO,
                                       ESTADO,
                                       FE_CREACION,
                                       USR_CREACION,
                                       IP_CREACION,
                                       ESTADO_CIVIL,
                                       FECHA_NACIMIENTO,
                                       CALIFICACION_CREDITICIA,
                                       ORIGEN_INGRESOS,
                                       ORIGEN_WEB,
                                       CONTRIBUYENTE_ESPECIAL,
                                       PAGA_IVA,
                                       NUMERO_CONADIS,
                                       PAIS_ID) 
            VALUES 
            (DB_COMERCIAL.SEQ_INFO_PERSONA.NEXTVAL,
            1,
            'N',
            'CED',
            'ESTO NO ES UNA IDENTIFICACION',
            null,
            'NAT',
            'Usuario Genérico',
            'Bloqueado LOPDP', 
            NULL,
            NULL,
            'NAC',
            'No disponible',
            'login',
            'Usuario cifrado LOPDP',
            'No disponible',
            'M',
            'Inactivo',
            to_date(sysdate,'dd-mm-yyyy'),
            'emontenegro',
            '127.0.0.1',
            'V',
            sysdate,
            null,
            null,
            null,
            'N',
            null,
            null,
            1);

INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL (ID_PERSONA_ROL,
                                                   PERSONA_ID,
                                                   EMPRESA_ROL_ID,
                                                   OFICINA_ID,
                                                   DEPARTAMENTO_ID,
                                                   ESTADO,
                                                   USR_CREACION,
                                                   FE_CREACION,
                                                   IP_CREACION,
                                                   CUADRILLA_ID,
                                                   PERSONA_EMPRESA_ROL_ID,
                                                   PERSONA_EMPRESA_ROL_ID_TTCO,
                                                   REPORTA_PERSONA_EMPRESA_ROL_ID,
                                                   ES_PREPAGO,
                                                   USR_ULT_MOD,
                                                   FE_ULT_MOD)
VALUES(DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL.NEXTVAL,
       (SELECT ID_PERSONA FROM DB_COMERCIAL.INFO_PERSONA ipe WHERE ipe.identificacion_cliente = 'ESTO NO ES UNA IDENTIFICACION'),
       813,
       58,
       359,
       'Inactivo',
       'emontenegro',
       sysdate,
       '127.0.0.1',
       null,
       null,
       null,
       null,
       null,
       null,
       null
);


INSERT INTO DB_COMERCIAL.ADMI_FORMA_PAGO(ID_FORMA_PAGO,
                                         CODIGO_FORMA_PAGO,
                                         DESCRIPCION_FORMA_PAGO,
                                         ES_DEPOSITABLE,
                                         ES_MONETARIO,
                                         ES_PAGO_PARA_CONTRATO,
                                         ESTADO,
                                         USR_CREACION,
                                         FE_CREACION) VALUES (
                                            210,
                                            'NHQV',
                                            'No disponible LOPDP',
                                            'N',
                                            'N',
                                            'N',
                                            'Inactivo',
                                            'emontengro',
                                            sysdate
);


insert into DB_COMERCIAL.ADMI_CARACTERISTICA
   (
   id_caracteristica,
   descripcion_caracteristica,
   tipo_ingreso,
   estado,
   fe_creacion,
   usr_creacion,
   fe_ult_mod,
   usr_ult_mod,
   tipo,
   detalle_caracteristica
   )
   values
   (
   DB_COMERCIAL.seq_admi_caracteristica.NEXTVAL,
   'CLIENTE CIFRADO',
   'C',
   'Activo',
   sysdate, 
   'wdsanchez',
   sysdate,
   'wdsanchez',
   'SEGURIDAD',
   null
   );


COMMIT;

/
