

--ELIMINAR NUEVA CARACTERISTICA DE MANERA LOGICA
UPDATE DB_COMERCIAL.ADMI_CARACTERISTICA  ac SET 
ac.ESTADO  = 'Eliminado'
WHERE  ac.DESCRIPCION_CARACTERISTICA = 'EQUIFAX_RECOMENDACION'; 

 COMMIT;
/