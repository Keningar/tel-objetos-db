create or replace PROCEDURE                       PKG_TMP_AFECTADOS_CASOS IS

--Se obtiene los casos
CURSOR cu_casos
IS
  SELECT *
  FROM db_soporte.info_caso x
  WHERE x.FE_CREACION>TRUNC(sysdate-16)
  AND x.EMPRESA_COD  =18
  AND x.FE_CIERRE   IS NULL;


--Se obtiene el detalle por caso
CURSOR cu_obtener_detalle_caso(cn_id_caso NUMBER)
IS
  SELECT MIN(id_detalle)
  FROM db_soporte.info_detalle
  WHERE detalle_hipotesis_id =
    (SELECT min(id_detalle_hipotesis)
    FROM db_soporte.info_detalle_hipotesis
    WHERE caso_id = cn_id_caso
    );

--Se obtiene el login afectado
CURSOR cu_obtener_login_x_caso(cn_id_detalle NUMBER)
IS
  SELECT AFECTADO_ID,AFECTADO_NOMBRE
  FROM db_soporte.info_parte_afectada
  WHERE ID_PARTE_AFECTADA =
    (SELECT MIN(id_parte_afectada)
    FROM db_soporte.info_parte_afectada
    WHERE tipo_afectado = 'Cliente'
    AND detalle_id      = cn_id_detalle
    );


--Se obtiene el servicio de Internet Dedicado
CURSOR cu_obtener_servicio_int(cn_id_punto NUMBER) IS
select min(c.ID_SERVICIO)
from db_soporte.admi_producto a,db_soporte.info_plan_det b,db_soporte.info_servicio c
where a.id_producto = b.PRODUCTO_ID
and b.PLAN_ID = c.PLAN_ID
and a.descripcion_producto = 'INTERNET DEDICADO' and a.empresa_cod = '18'
and c.PUNTO_ID = cn_id_punto;


--Se obtiene criterio afectado
CURSOR cu_existe_criterio(cn_detalle_id NUMBER)
IS
  SELECT COUNT(id_criterio_afectado)
  FROM db_soporte.INFO_CRITERIO_AFECTADO
  WHERE id_criterio_Afectado = 2
  AND detalle_id             = cn_detalle_id;
  

  

ln_id_detalle      number       := 0;
lv_numero_caso     varchar2(50) :='';
ln_id_punto        number       := 0;
lv_nombre_login    varchar2(50) :='';
ln_id_servicio     number       := 0;
ln_existe_criterio number       := 0;
ln_contador        number       := 0;
 
BEGIN

for i in cu_casos loop


--Se obtiene el id_detalle x caso
open cu_obtener_detalle_caso(i.id_caso);
fetch cu_obtener_detalle_caso into ln_id_detalle;
close cu_obtener_detalle_caso;

--Se obtiene el punto afectado
open cu_obtener_login_x_caso(ln_id_detalle);
fetch cu_obtener_login_x_caso into ln_id_punto,lv_nombre_login;
close cu_obtener_login_x_caso;

--Se obtiene el servicio de Internet Dedicado
open cu_obtener_servicio_int(ln_id_punto);
fetch cu_obtener_servicio_int into ln_id_servicio;
close cu_obtener_servicio_int;


--validar que no exista el criterio afectado
open cu_existe_criterio(ln_id_detalle);
fetch cu_existe_criterio into ln_existe_criterio;
close cu_existe_criterio;



if(ln_existe_criterio = 0) then
ln_contador := ln_contador +1;
-----------------------Registrar el criterio afectado---------------------------

    insert into db_soporte.info_criterio_afectado 
    values(2,ln_id_detalle,'Servicio','Servicio: INTERNET DEDICADO | OPCION: Servicios','telcos',sysdate,'127.0.0.1');
    
    insert into db_soporte.INFO_PARTE_AFECTADA
    values(db_soporte.SEQ_info_parte_afectada.nextval,2,ln_id_detalle,ln_id_servicio,'Servicio',
    'INTERNET DEDICADO','INTERNET DEDICADO',sysdate,null,'telcos',sysdate,'127.0.0.1',null);

-----------------------Registrar el criterio afectado---------------------------

DBMS_OUTPUT.PUT_LINE(ln_contador||'.-  Caso Actualizado: '||i.numero_caso||
                                           ' @@ Login Afectado: '||lv_nombre_login||
                                           ' @@ Id Detalle: '||ln_id_detalle ||
                                           ' @@ Servicio Afecado: '||ln_id_servicio);

end if;


end loop;

COMMIT;

DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE('Casos Actualizados: '||ln_contador);
DBMS_OUTPUT.PUT_LINE('Proceso realizado con exito!');

EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Error: '||SUBSTR(SQLERRM, 1 , 200));
ROLLBACK;



END;