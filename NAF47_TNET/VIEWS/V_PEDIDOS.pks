CREATE    OR REPLACE VIEW "NAF47_TNET"."V_PEDIDOS" ("TIPO_PEDIDO", "TIPO_PEDIDO_INV", "ID_PEDIDO", "FECHA_AUTORIZA", "USR_CREACION", "USR_CREACION_ID", "NOMBRE_USR_CREACION", "USR_JEFE_ID", "NOMBRE_JEFE", "USR_AUTORIZA_ID", "NOMBRE_USR_AUTORIZA", "DEPARTAMENTO_ID", "NOMBRE_DEPARTAMENTO", "CIUDAD", "ID_PROVINCIA", "PROVINCIA", "OBSERVACION", "ID_EMPRESA", "ESTADO", "USR_ASIGNADO_TIPO", "FE_CREACION") AS 
  SELECT P.PEDIDO_TIPO TIPO_PEDIDO,
         DECODE(P.PEDIDO_TIPO, 'Ins', 'Ins', 'Sol') TIPO_PEDIDO_INV,
         P.ID_PEDIDO,
         TO_DATE(TO_CHAR((SELECT NVL(MAX(FE_CREACION),P.FE_CREACION)
                  FROM DB_COMPRAS.INFO_PEDIDO_ESTADO EP
                  WHERE EP.PEDIDO_ID = P.ID_PEDIDO
                  AND EP.ESTADO = 'Autorizado'),'DD/MM/YYYY HH24:MI:SS'),'DD/MM/YYYY HH24:MI:SS') FECHA_AUTORIZA,
         --
         P.USR_CREACION,
         P.USR_CREACION_ID,
         --
         (SELECT VE.NOMBRE
            FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS VE
           WHERE VE.NO_EMPLE = P.USR_CREACION_ID
             AND VE.NO_CIA = E.CODIGO) NOMBRE_USR_CREACION,
         --
         P.USR_JEFE_ID,
         (SELECT VE.NOMBRE
            FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS VE
           WHERE VE.NO_EMPLE = P.USR_JEFE_ID
             AND VE.NO_CIA = E.CODIGO) NOMBRE_JEFE,
         --
         P.USR_AUTORIZA_ID,
         (SELECT VE.NOMBRE
            FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS VE
           WHERE VE.NO_EMPLE = P.USR_AUTORIZA_ID
             AND VE.NO_CIA = E.CODIGO) NOMBRE_USR_AUTORIZA,
         --
         P.DEPARTAMENTO_ID,
         D.NOMBRE NOMBRE_DEPARTAMENTO,
         --
         (SELECT C.NOMBRE_CANTON
            FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS VE,
                 DB_COMERCIAL.INFO_OFICINA_GRUPO O,
                 DB_GENERAL.ADMI_CANTON C
           WHERE VE.NO_EMPLE = P.USR_CREACION_ID
             AND VE.NO_CIA = E.CODIGO
             AND VE.OFICINA = O.ID_OFICINA
             AND O.CANTON_ID = C.ID_CANTON) CIUDAD,
         --
         (SELECT C.PROVINCIA_ID
            FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS VE,
                 DB_COMERCIAL.INFO_OFICINA_GRUPO O,
                 DB_GENERAL.ADMI_CANTON C
           WHERE VE.NO_EMPLE = P.USR_JEFE_ID
             AND VE.NO_CIA = E.CODIGO
             AND VE.OFICINA = O.ID_OFICINA
             AND O.CANTON_ID = C.ID_CANTON) ID_PROVINCIA,
         --
         (SELECT V.NOMBRE_PROVINCIA
            FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS VE,
                 DB_COMERCIAL.INFO_OFICINA_GRUPO O,
                 DB_GENERAL.ADMI_CANTON C,
                 DB_GENERAL.ADMI_PROVINCIA V
           WHERE VE.NO_EMPLE = P.USR_CREACION_ID 
             AND VE.NO_CIA = E.CODIGO
             AND VE.OFICINA = O.ID_OFICINA
             AND O.CANTON_ID = C.ID_CANTON
             AND C.PROVINCIA_ID = V.ID_PROVINCIA) PROVINCIA,
         --
         P.OBSERVACION,
         E.CODIGO ID_EMPRESA,
         P.ESTADO,
         DECODE(P.USR_ASIGNADO_TIPO, 'EMP', 'EMPLEADO', 'CON', 'CONTRATISTA') USR_ASIGNADO_TIPO,
         P.FE_CREACION
    FROM DB_COMPRAS.INFO_PEDIDO P,
         DB_COMPRAS.ADMI_DEPARTAMENTO D,
         DB_COMPRAS.ADMI_EMPRESA E
   WHERE P.DEPARTAMENTO_ID = D.ID_DEPARTAMENTO
     AND D.EMPRESA_ID = E.ID_EMPRESA
     AND P.PEDIDO_TIPO IN ('Sol','Ins', 'Epp', 'Pro')
     and P.ESTADO NOT IN ('Ingresado','Pendiente')
     AND EXISTS (SELECT NULL
                   FROM DB_COMPRAS.INFO_PEDIDO_DETALLE PD
                  WHERE PD.PEDIDO_ID = P.ID_PEDIDO
                    AND PD.ESTADO NOT IN ('Ingresado','Pendiente','Rechazado')
                    );