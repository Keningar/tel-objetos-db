DELETE FROM DB_COMPROBANTES.INFO_CAMPO_ADICIONAL WHERE USR_CREACION ='emontenegro' AND CODIGO ='fmaxPago'  AND ETIQUETA = 'Fecha Máxima de pago';

UPDATE DB_COMPROBANTES.INFO_NOTIFICACION SET MENSAJE_ADICIONAL = 'Para consultas o requerimientos puede contactarse a nuestro Centro de Atenci'||chr(38)||'oacute;n a nivel nacional al $empresa_telefono. Para la atenci'||chr(38)||'oacute;n de reclamos NO resueltos por el prestador, ingrese su reclamo al link: http://reclamoconsumidor.arcotel.gob.ec/osTicket, o para mayor informaci'||chr(38)||'oacute;n comun'||chr(38)||'iacute;quese con el n'||chr(38)||'uacute;mero telef'||chr(38)||'oacute;nico 1800 567 567', USR_ULT_MOD='rsalgado',FE_ULT_MOD='19-AUG-20' WHERE ID_NOTIFICACION=1 AND USR_ULT_MOD='emontenegro';
/
