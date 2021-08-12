--Regresar al PIN anterior

UPDATE DB_GENERAL.admi_parametro_det
 set valor1 ='Gracias por Elegir a Netlife como su proveedor de Internet.\n El codigo Netlife para validar su firma digital es: ' 
 where id_parametro_det= 9793;

 COMMIT;
/