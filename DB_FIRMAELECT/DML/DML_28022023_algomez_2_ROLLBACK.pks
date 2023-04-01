/**
 *
 * Nuevas plantillas para ecuanet
 *
 * @author Alex Gómez <algomez@telconet.ec>
 * @version 1.0 23-02-2023 
 *
 * Generación de plantillas para nueva empresa
 **/

DELETE
FROM
	DB_FIRMAELECT.ADM_EMP_PLANT_CERT aepc
WHERE
	aepc.PLANTILLA_ID IN
 (
	SELECT
		aep.ID_EMPRESA_PLANTILLA
	FROM
		DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA aep
	WHERE
		aep.COD_PLANTILLA IN ('contratoSecurityData', 'formularioSecurityData', 'terminosCondicionesEcuanet', 'adendumEcuanet', 'contratoEcuanet')
			AND
	    aep.EMPRESA_ID = 
	    (
			SELECT
				ae.ID_EMPRESA
			FROM
				DB_FIRMAELECT.ADM_EMPRESA ae
			WHERE
				ae.RAZON_SOCIAL = 'ECUANET'
	    )
 );
 
 
----

DELETE
	FROM
		DB_FIRMAELECT.ADM_EMPRESA_PLANTILLA aep
	WHERE
		aep.COD_PLANTILLA IN ('contratoSecurityData', 'formularioSecurityData', 'terminosCondicionesEcuanet', 'adendumEcuanet', 'contratoEcuanet')
			AND
	    aep.EMPRESA_ID = 
	    (
			SELECT
				ae.ID_EMPRESA
			FROM
				DB_FIRMAELECT.ADM_EMPRESA ae
			WHERE
				ae.RAZON_SOCIAL = 'ECUANET'
	    );

--------

DELETE
	FROM
		DB_FIRMAELECT.ADM_EMPRESA_PARAMETRO aep
	WHERE
		aep.VALOR IN ('contratoSecurityData', 'formularioSecurityData', 'terminosCondicionesEcuanet', 'adendumEcuanet', 'contratoEcuanet')
			AND
	    aep.EMPRESA_ID = 
	    (
			SELECT
				ae.ID_EMPRESA
			FROM
				DB_FIRMAELECT.ADM_EMPRESA ae
			WHERE
				ae.RAZON_SOCIAL = 'ECUANET'
	    );	 

--------
DELETE
FROM
	DB_FIRMAELECT.INFO_TRANSACCION it
WHERE
  it.CERTIFICADO_ID  IN
  (
  SELECT ic.ID_CERTIFICADO
FROM
	DB_FIRMAELECT.INFO_CERTIFICADO ic
WHERE
  ic.EMPRESA_ID = 
	    (
			SELECT
				ae.ID_EMPRESA
			FROM
				DB_FIRMAELECT.ADM_EMPRESA ae
			WHERE
				ae.RAZON_SOCIAL = 'ECUANET'
	    )
  );
  
  --------
  DELETE
FROM
	DB_FIRMAELECT.INFO_CERTIFICADO_DOCUMENTO it
WHERE
  it.CERTIFICADO_ID  IN
  (
  SELECT ic.ID_CERTIFICADO
FROM
	DB_FIRMAELECT.INFO_CERTIFICADO ic
WHERE
  ic.EMPRESA_ID = 
	    (
			SELECT
				ae.ID_EMPRESA
			FROM
				DB_FIRMAELECT.ADM_EMPRESA ae
			WHERE
				ae.RAZON_SOCIAL = 'ECUANET'
	    )
  );


----------
DELETE
FROM
	DB_FIRMAELECT.INFO_CERTIFICADO ic
WHERE
  ic.EMPRESA_ID = 
	    (
			SELECT
				ae.ID_EMPRESA
			FROM
				DB_FIRMAELECT.ADM_EMPRESA ae
			WHERE
				ae.RAZON_SOCIAL = 'ECUANET'
	    );




------
DELETE
FROM
	DB_FIRMAELECT.ADM_EMPRESA ae
WHERE
	ae.RAZON_SOCIAL = 'ECUANET';
				
/
COMMIT; 
                
                 