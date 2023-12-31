/**
 *
 * Nuevas plantillas para ecuanet
 *
 * @author Alex Gómez <algomez@telconet.ec>
 * @version 1.0 23-02-2023 
 *
 * Generación de plantillas para nueva empresa
 **/

SET DEFINE OFF;
SET SERVEROUTPUT ON;

DECLARE
   
BEGIN

INSERT
INTO DB_FIRMAELECT.ADM_EMPRESA
  (
    ID_EMPRESA,
    NOMBRE,
    RAZON_SOCIAL,
    RUC,
    ESTADO,
    REFERENCIA_EMPRESA
  )
  VALUES
  (
    DB_FIRMAELECT.SEQ_ADM_EMPRESA.NEXTVAL,
    'Ecuanet',
    'ECUANET',
    '1791287541001',
    'Activo',
    '33'
  );
 
---============CONTRATO SECURITY DATA
INSERT
	INTO
	DB_FIRMAELECT.ADM_EMPRESA_PARAMETRO
  (
    ID_EMPRESA_PARAMETRO,
	EMPRESA_ID,
	CLAVE,
	VALOR,
	DESCRIPCION,
	ES_CONFIG,
	ES_DEFAULT,
	ENVIA_POR_MAIL
  )
VALUES
  (
    DB_FIRMAELECT.SEQ_ADM_EMPRESA_PARAMETRO.NEXTVAL,
    (
SELECT
	ae.ID_EMPRESA
FROM
	DB_FIRMAELECT.ADM_EMPRESA ae
WHERE
	ae.RAZON_SOCIAL = 'ECUANET'),
    'contratoSD',
    'contratoSecurityData',
    'Plantilla utilizada para crear el contrato con SecurityData, necesario para documentar cada certificado',
'S',
'N',
'S'
  );
 
 INSERT
	INTO
	DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA
(ID_EMPRESA_PLANTILLA,
	COD_PLANTILLA,
	EMPRESA_ID,
	DESCRIPCION,
	HTML,
	ESTADO,
	PROPIEDADES)
VALUES(DB_FIRMAELECT.SEQ_ADM_EMPRESA_PLANTILLA.NEXTVAL,
'contratoSecurityData',
(
SELECT
	ae.ID_EMPRESA
FROM
	DB_FIRMAELECT.ADM_EMPRESA ae
WHERE
	ae.RAZON_SOCIAL = 'ECUANET'),
'Contrato SecurityData',
'<!DOCTYPE html>',
'Activo',
'{
    "pageFormat": "A4",
    "marginTop": "8",
    "marginLeft": "4",
    "marginRight": "8"
}');

INSERT
	INTO
	DB_FIRMAELECT.ADM_EMP_PLANT_CERT
(ID_EMP_PLANT_CERT,
	PLANTILLA_ID,
	CERTIFICADO_ID,
	PROPIEDADES,
	TIPO,
	CODIGO)
VALUES(DB_FIRMAELECT.SEQ_ADM_EMP_PLANT_CERT.NEXTVAL,
(
SELECT
	aep.ID_EMPRESA_PLANTILLA 
FROM
	DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA aep
WHERE
	AEP.COD_PLANTILLA = 'contratoSecurityData'
	AND AEP.EMPRESA_ID = (
	SELECT
		ae.ID_EMPRESA
	FROM
		DB_FIRMAELECT.ADM_EMPRESA ae
	WHERE
		ae.RAZON_SOCIAL = 'ECUANET')),
2,
'{"llx":"-160","lly":"15","urx":"100","ury":"35","pagina":"3","textSignature":"","modoPresentacion":"1", "firma":"SI"}',
'empresa',
'FIRMA_CONT_SD_EMPRESA');

INSERT
	INTO
	DB_FIRMAELECT.ADM_EMP_PLANT_CERT
(ID_EMP_PLANT_CERT,
	PLANTILLA_ID,
	CERTIFICADO_ID,
	PROPIEDADES,
	TIPO,
	CODIGO)
VALUES(DB_FIRMAELECT.SEQ_ADM_EMP_PLANT_CERT.NEXTVAL,
(
SELECT
	aep.ID_EMPRESA_PLANTILLA 
FROM
	DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA aep
WHERE
	AEP.COD_PLANTILLA = 'contratoSecurityData'
	AND AEP.EMPRESA_ID = (
	SELECT
		ae.ID_EMPRESA
	FROM
		DB_FIRMAELECT.ADM_EMPRESA ae
	WHERE
		ae.RAZON_SOCIAL = 'ECUANET')),
1,
'{"llx":"-80","lly":"15","urx":"150","ury":"35","pagina":"3","textSignature":"","modoPresentacion":"1", "firma":"SI"}',
'cliente',
'FIRMA_CONT_SD_CLIENTE');



 DBMS_OUTPUT.put_line('CONTRATO SD - OK');
 
---============FORMULARIO SECURITY DATA
INSERT
	INTO
	DB_FIRMAELECT.ADM_EMPRESA_PARAMETRO
  (
    ID_EMPRESA_PARAMETRO,
	EMPRESA_ID,
	CLAVE,
	VALOR,
	DESCRIPCION,
	ES_CONFIG,
	ES_DEFAULT,
	ENVIA_POR_MAIL
  )
VALUES
 (DB_FIRMAELECT.SEQ_ADM_EMPRESA_PARAMETRO.NEXTVAL,
(
SELECT
	ae.ID_EMPRESA
FROM
	DB_FIRMAELECT.ADM_EMPRESA ae
WHERE
	ae.RAZON_SOCIAL = 'ECUANET'),
'formularioSD',
'formularioSecurityData',
'Plantilla utilizada para crear el formulario con SecurityData, necesario para documentar cada certificado',
'S',
'N',
'S');
  
 INSERT
	INTO
	DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA
(ID_EMPRESA_PLANTILLA,
	COD_PLANTILLA,
	EMPRESA_ID,
	DESCRIPCION,
	HTML,
	ESTADO,
	PROPIEDADES)
VALUES(DB_FIRMAELECT.SEQ_ADM_EMPRESA_PLANTILLA.NEXTVAL,
'formularioSecurityData',
(
SELECT
	ae.ID_EMPRESA
FROM
	DB_FIRMAELECT.ADM_EMPRESA ae
WHERE
	ae.RAZON_SOCIAL = 'ECUANET'),
'Formulario SecurityData',
'<!DOCTYPE html>',
'Activo',
'{
    "pageFormat": "A4",
    "marginTop": "8",
    "marginLeft": "4",
    "marginRight": "8"
}');


INSERT
	INTO
	DB_FIRMAELECT.ADM_EMP_PLANT_CERT
(ID_EMP_PLANT_CERT,
	PLANTILLA_ID,
	CERTIFICADO_ID,
	PROPIEDADES,
	TIPO,
	CODIGO)
VALUES(DB_FIRMAELECT.SEQ_ADM_EMP_PLANT_CERT.NEXTVAL,
(
SELECT
	aep.ID_EMPRESA_PLANTILLA 
FROM
	DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA aep
WHERE
	AEP.COD_PLANTILLA = 'formularioSecurityData'
	AND AEP.EMPRESA_ID = (
	SELECT
		ae.ID_EMPRESA
	FROM
		DB_FIRMAELECT.ADM_EMPRESA ae
	WHERE
		ae.RAZON_SOCIAL = 'ECUANET')),
1,
'{"llx":"-70","lly":"-30","urx":"200","ury":"-20","pagina":"1","textSignature":"","modoPresentacion":"1", "firma":"SI"}',
'cliente',
'FIRMA_FORM_SD_CLIENTE');

DBMS_OUTPUT.put_line('FORMULARIO SD - OK');

---============TERMINOS Y CONDICIONES ECUANET
INSERT
	INTO
	DB_FIRMAELECT.ADM_EMPRESA_PARAMETRO
  (
    ID_EMPRESA_PARAMETRO,
	EMPRESA_ID,
	CLAVE,
	VALOR,
	DESCRIPCION,
	ES_CONFIG,
	ES_DEFAULT,
	ENVIA_POR_MAIL
  )
VALUES
 (DB_FIRMAELECT.SEQ_ADM_EMPRESA_PARAMETRO.NEXTVAL,
(
SELECT
	ae.ID_EMPRESA
FROM
	DB_FIRMAELECT.ADM_EMPRESA ae
WHERE
	ae.RAZON_SOCIAL = 'ECUANET'),
'terminosCondicionesEcuanet',
'terminosCondicionesEcuanet',
'Plantilla utilizada para crear los Terminos y Condiciones Ecuanet',
'S',
'N',
'S');

 INSERT
	INTO
	DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA
(ID_EMPRESA_PLANTILLA,
	COD_PLANTILLA,
	EMPRESA_ID,
	DESCRIPCION,
	HTML,
	ESTADO,
	PROPIEDADES)
VALUES(DB_FIRMAELECT.SEQ_ADM_EMPRESA_PLANTILLA.NEXTVAL,
'terminosCondicionesEcuanet',
(
SELECT
	ae.ID_EMPRESA
FROM
	DB_FIRMAELECT.ADM_EMPRESA ae
WHERE
	ae.RAZON_SOCIAL = 'ECUANET'),
'Plantilla Terminos y Condiciones',
'<!DOCTYPE html>',
'Activo',
'{
    "pageFormat": "A4",
    "marginTop": "8",
    "marginLeft": "4",
    "marginRight": "8",
    "soportaPaginacion":"S"
}');

INSERT
	INTO
	DB_FIRMAELECT.ADM_EMP_PLANT_CERT
(ID_EMP_PLANT_CERT,
	PLANTILLA_ID,
	CERTIFICADO_ID,
	PROPIEDADES,
	TIPO,
	CODIGO)
VALUES(DB_FIRMAELECT.SEQ_ADM_EMP_PLANT_CERT.NEXTVAL,
(
SELECT
	aep.ID_EMPRESA_PLANTILLA 
FROM
	DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA aep
WHERE
	AEP.COD_PLANTILLA = 'terminosCondicionesEcuanet'
	AND AEP.EMPRESA_ID = (
	SELECT
		ae.ID_EMPRESA
	FROM
		DB_FIRMAELECT.ADM_EMPRESA ae
	WHERE
		ae.RAZON_SOCIAL = 'ECUANET')),
1,
'{"llx":"-100","lly":"20","urx":"100","ury":"-28","pagina":"3","textSignature":"","modoPresentacion":"1","firma":"SI"}',
'cliente',
'FIRMA_TERMINOS_MD_CLIENTE');

INSERT
	INTO
	DB_FIRMAELECT.ADM_EMP_PLANT_CERT
(ID_EMP_PLANT_CERT,
	PLANTILLA_ID,
	CERTIFICADO_ID,
	PROPIEDADES,
	TIPO,
	CODIGO)
VALUES(DB_FIRMAELECT.SEQ_ADM_EMP_PLANT_CERT.NEXTVAL,
(
SELECT
	aep.ID_EMPRESA_PLANTILLA 
FROM
	DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA aep
WHERE
	AEP.COD_PLANTILLA = 'terminosCondicionesEcuanet'
	AND AEP.EMPRESA_ID = (
	SELECT
		ae.ID_EMPRESA
	FROM
		DB_FIRMAELECT.ADM_EMPRESA ae
	WHERE
		ae.RAZON_SOCIAL = 'ECUANET')),
2,
'{"llx":"-100","lly":"20","urx":"100","ury":"-28","pagina":"3","textSignature":"","modoPresentacion":"1","firma":"SI"}',
'empresa',
'FIRMA_TERMINOS_MD_EMPRESA');



DBMS_OUTPUT.put_line('TERMINOS Y CONDICIONES ECUANET - OK');

---============ADENDUM ECUANET

INSERT
	INTO
	DB_FIRMAELECT.ADM_EMPRESA_PARAMETRO
  (
    ID_EMPRESA_PARAMETRO,
	EMPRESA_ID,
	CLAVE,
	VALOR,
	DESCRIPCION,
	ES_CONFIG,
	ES_DEFAULT,
	ENVIA_POR_MAIL
  )
VALUES
 (DB_FIRMAELECT.SEQ_ADM_EMPRESA_PARAMETRO.NEXTVAL,
(
SELECT
	ae.ID_EMPRESA
FROM
	DB_FIRMAELECT.ADM_EMPRESA ae
WHERE
	ae.RAZON_SOCIAL = 'ECUANET'),
'adendumEcuanet',
'adendumEcuanet',
'Plantilla utilizada para crear los adendums Ecuanet',
'S',
'N',
'S');


INSERT
	INTO
	DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA
(ID_EMPRESA_PLANTILLA,
	COD_PLANTILLA,
	EMPRESA_ID,
	DESCRIPCION,
	HTML,
	ESTADO,
	PROPIEDADES)
VALUES(DB_FIRMAELECT.SEQ_ADM_EMPRESA_PLANTILLA.NEXTVAL,
'adendumEcuanet',
(
SELECT
	ae.ID_EMPRESA
FROM
	DB_FIRMAELECT.ADM_EMPRESA ae
WHERE
	ae.RAZON_SOCIAL = 'ECUANET'),
'Plantilla de adendum',
'<!DOCTYPE html>',
'Activo',
'{
    "pageFormat": "A4",
    "marginTop": "8",
    "marginLeft": "4",
    "marginRight": "8",
    "soportaPaginacion":"S"
}');

INSERT
	INTO
	DB_FIRMAELECT.ADM_EMP_PLANT_CERT
(ID_EMP_PLANT_CERT,
	PLANTILLA_ID,
	CERTIFICADO_ID,
	PROPIEDADES,
	TIPO,
	CODIGO)
VALUES(DB_FIRMAELECT.SEQ_ADM_EMP_PLANT_CERT.NEXTVAL,
(
SELECT
	aep.ID_EMPRESA_PLANTILLA 
FROM
	DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA aep
WHERE
	AEP.COD_PLANTILLA = 'adendumEcuanet'
	AND AEP.EMPRESA_ID = (
	SELECT
		ae.ID_EMPRESA
	FROM
		DB_FIRMAELECT.ADM_EMPRESA ae
	WHERE
		ae.RAZON_SOCIAL = 'ECUANET')),
1,
'{"llx":"-120","lly":"-8","urx":"190","ury":"-3","pagina":"4","textSignature":"","modoPresentacion": "1","firma":"SI"}',
'cliente',
'FIRMA_ADEN_MD_CLIENTE');

INSERT
	INTO
	DB_FIRMAELECT.ADM_EMP_PLANT_CERT
(ID_EMP_PLANT_CERT,
	PLANTILLA_ID,
	CERTIFICADO_ID,
	PROPIEDADES,
	TIPO,
	CODIGO)
VALUES(DB_FIRMAELECT.SEQ_ADM_EMP_PLANT_CERT.NEXTVAL,
(
SELECT
	aep.ID_EMPRESA_PLANTILLA 
FROM
	DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA aep
WHERE
	AEP.COD_PLANTILLA = 'adendumEcuanet'
	AND AEP.EMPRESA_ID = (
	SELECT
		ae.ID_EMPRESA
	FROM
		DB_FIRMAELECT.ADM_EMPRESA ae
	WHERE
		ae.RAZON_SOCIAL = 'ECUANET')),
2,
'{"llx":"-110","lly":"-8","urx":"160","ury":"-3","pagina":"2","textSignature":"","modoPresentacion":"1", "firma":"SI"}',
'empresa',
'FIRMA_ADEN_MD_EMPRESA');



DBMS_OUTPUT.put_line('ADENDUM ECUANET - OK');


---============CONTRATO ECUANET

INSERT
	INTO
	DB_FIRMAELECT.ADM_EMPRESA_PARAMETRO
  (
    ID_EMPRESA_PARAMETRO,
	EMPRESA_ID,
	CLAVE,
	VALOR,
	DESCRIPCION,
	ES_CONFIG,
	ES_DEFAULT,
	ENVIA_POR_MAIL
  )
VALUES
 (DB_FIRMAELECT.SEQ_ADM_EMPRESA_PARAMETRO.NEXTVAL,
(
SELECT
	ae.ID_EMPRESA
FROM
	DB_FIRMAELECT.ADM_EMPRESA ae
WHERE
	ae.RAZON_SOCIAL = 'ECUANET'),
'contratoEMP',
'contratoEcuanet',
'Plantilla utilizada para crear el contrato con MegaDatos, necesario para documentar cada certificado',
'S',
'N',
'S');


INSERT
	INTO
	DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA
(ID_EMPRESA_PLANTILLA,
	COD_PLANTILLA,
	EMPRESA_ID,
	DESCRIPCION,
	HTML,
	ESTADO,
	PROPIEDADES)
VALUES(DB_FIRMAELECT.SEQ_ADM_EMPRESA_PLANTILLA.NEXTVAL,
'contratoEcuanet',
(
SELECT
	ae.ID_EMPRESA
FROM
	DB_FIRMAELECT.ADM_EMPRESA ae
WHERE
	ae.RAZON_SOCIAL = 'ECUANET'),
'Plantilla de Contrato Empresa',
'<!DOCTYPE html>',
'Activo',
'{
    "pageFormat": "A4",
    "marginTop": "8",
    "marginLeft": "4",
    "marginRight": "8",
    "soportaPaginacion":"S"
}');

INSERT
	INTO
	DB_FIRMAELECT.ADM_EMP_PLANT_CERT
(ID_EMP_PLANT_CERT,
	PLANTILLA_ID,
	CERTIFICADO_ID,
	PROPIEDADES,
	TIPO,
	CODIGO)
VALUES(DB_FIRMAELECT.SEQ_ADM_EMP_PLANT_CERT.NEXTVAL,
(
SELECT
	aep.ID_EMPRESA_PLANTILLA 
FROM
	DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA aep
WHERE
	AEP.COD_PLANTILLA = 'contratoEcuanet'
	AND AEP.EMPRESA_ID = (
	SELECT
		ae.ID_EMPRESA
	FROM
		DB_FIRMAELECT.ADM_EMPRESA ae
	WHERE
		ae.RAZON_SOCIAL = 'ECUANET')),
1,
'{"llx":"-35","lly":"0","urx":"210","ury":"50","pagina":"3","textSignature":"","modoPresentacion":"1","firma":"SI"}',
'cliente',
'FIRMA_CONT_MD_AUT_DEBITO');

INSERT
	INTO
	DB_FIRMAELECT.ADM_EMP_PLANT_CERT
(ID_EMP_PLANT_CERT,
	PLANTILLA_ID,
	CERTIFICADO_ID,
	PROPIEDADES,
	TIPO,
	CODIGO)
VALUES(DB_FIRMAELECT.SEQ_ADM_EMP_PLANT_CERT.NEXTVAL,
(
SELECT
	aep.ID_EMPRESA_PLANTILLA 
FROM
	DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA aep
WHERE
	AEP.COD_PLANTILLA = 'contratoEcuanet'
	AND AEP.EMPRESA_ID = (
	SELECT
		ae.ID_EMPRESA
	FROM
		DB_FIRMAELECT.ADM_EMPRESA ae
	WHERE
		ae.RAZON_SOCIAL = 'ECUANET')),
1,
'{"llx":"-150","lly":"-5","urx":"100","ury":"60","pagina":"3","textSignature":"","modoPresentacion":"1","firma":"SI"}',
'empresa',
'FIRMA_CONT_MD_FINAL_EMPRESA');

INSERT
	INTO
	DB_FIRMAELECT.ADM_EMP_PLANT_CERT
(ID_EMP_PLANT_CERT,
	PLANTILLA_ID,
	CERTIFICADO_ID,
	PROPIEDADES,
	TIPO,
	CODIGO)
VALUES(DB_FIRMAELECT.SEQ_ADM_EMP_PLANT_CERT.NEXTVAL,
(
SELECT
	aep.ID_EMPRESA_PLANTILLA 
FROM
	DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA aep
WHERE
	AEP.COD_PLANTILLA = 'contratoEcuanet'
	AND AEP.EMPRESA_ID = (
	SELECT
		ae.ID_EMPRESA
	FROM
		DB_FIRMAELECT.ADM_EMPRESA ae
	WHERE
		ae.RAZON_SOCIAL = 'ECUANET')),
1,
'{"llx":"5","lly":"-3","urx":"-200","ury":"60","pagina":"3","textSignature":"","modoPresentacion":"1","firma":"SI"}',
'cliente',
'FIRMA_CONT_MD_FINAL_CLIENTE');

INSERT
	INTO
	DB_FIRMAELECT.ADM_EMP_PLANT_CERT
(ID_EMP_PLANT_CERT,
	PLANTILLA_ID,
	CERTIFICADO_ID,
	PROPIEDADES,
	TIPO,
	CODIGO)
VALUES(DB_FIRMAELECT.SEQ_ADM_EMP_PLANT_CERT.NEXTVAL,
(
SELECT
	aep.ID_EMPRESA_PLANTILLA 
FROM
	DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA aep
WHERE
	AEP.COD_PLANTILLA = 'contratoEcuanet'
	AND AEP.EMPRESA_ID = (
	SELECT
		ae.ID_EMPRESA
	FROM
		DB_FIRMAELECT.ADM_EMPRESA ae
	WHERE
		ae.RAZON_SOCIAL = 'ECUANET')),
1,
'{"llx":"-90","lly":"-5","urx":"130","ury":"60","pagina":"4","textSignature":"","modoPresentacion": "1","firma":"SI"}',
'cliente',
'FIRMA_CONT_MD_FORMA_PAGO');


INSERT
	INTO
	DB_FIRMAELECT.ADM_EMP_PLANT_CERT
(ID_EMP_PLANT_CERT,
	PLANTILLA_ID,
	CERTIFICADO_ID,
	PROPIEDADES,
	TIPO,
	CODIGO)
VALUES(DB_FIRMAELECT.SEQ_ADM_EMP_PLANT_CERT.NEXTVAL,
(
SELECT
	aep.ID_EMPRESA_PLANTILLA 
FROM
	DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA aep
WHERE
	AEP.COD_PLANTILLA = 'contratoEcuanet'
	AND AEP.EMPRESA_ID = (
	SELECT
		ae.ID_EMPRESA
	FROM
		DB_FIRMAELECT.ADM_EMPRESA ae
	WHERE
		ae.RAZON_SOCIAL = 'ECUANET')),
1,
'{"llx":"-35","lly":"0","urx":"210","ury":"50","pagina":"3","textSignature":"","modoPresentacion":"1","firma":"SI"}',
'cliente',
'FIRMA_CONT_MD_AUT_DEBITO');

    COMMIT;
    DBMS_OUTPUT.put_line('-OK-');
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.put_line ('ROLLBACK ' || DBMS_UTILITY.format_error_backtrace);   
        DBMS_OUTPUT.put_line ('ROLLBACK ' || sqlerrm);   
END;

/