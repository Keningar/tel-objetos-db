CREATE OR REPLACE VIEW "DB_INFRAESTRUCTURA"."VISTA_UPS_OID" ("ID_ELEMENTO", "IP", "MARCA_UPS", "COMMUNITY", "ID_OID", "NOMBRE_OID", "OID") AS 
  SELECT ie.ID_ELEMENTO, 
           ii.IP, 
           amre.NOMBRE_MARCA_ELEMENTO as MARCA_UPS,
           (
               SELECT asnmp.SNMP_COMMUNITY
               FROM DB_INFRAESTRUCTURA.INFO_SNMP_ELEMENTO ise
               JOIN DB_INFRAESTRUCTURA.ADMI_SNMP asnmp
               ON ise.SNMP_ID = asnmp.ID_SNMP
               WHERE ise.ELEMENTO_ID = ie.ID_ELEMENTO
            ) as COMMUNITY, 
            ao.ID_OID, 
            ao.NOMBRE_OID, 
            ao.OID
    FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO ie
    JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO ame
    ON ie.MODELO_ELEMENTO_ID = ame.ID_MODELO_ELEMENTO
    JOIN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO amre
    ON amre.ID_MARCA_ELEMENTO = ame.MARCA_ELEMENTO_ID
    JOIN DB_INFRAESTRUCTURA.ADMI_OID ao
    ON ao.MARCA_ELEMENTO_ID = amre.ID_MARCA_ELEMENTO
    JOIN DB_INFRAESTRUCTURA.INFO_IP ii
    ON ii.ELEMENTO_ID = ie.ID_ELEMENTO
    WHERE ie.ESTADO = 'Activo'
    AND ame.ESTADO = 'Activo'
    AND amre.ESTADO = 'Activo'
    AND ao.ESTADO != 'Eliminado'
    AND ii.ESTADO = 'Activo'
    AND ame.TIPO_ELEMENTO_ID = (
                                   SELECT ate.ID_TIPO_ELEMENTO
                                   FROM DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO ate
                                   WHERE ate.ESTADO = 'Activo'
                                     AND ate.NOMBRE_TIPO_ELEMENTO = 'UPS'
                               );