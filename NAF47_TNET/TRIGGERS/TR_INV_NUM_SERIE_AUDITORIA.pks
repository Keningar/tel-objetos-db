CREATE OR REPLACE TRIGGER NAF47_TNET.TR_INV_NUM_SERIE_AUDITORIA
  before insert or update or delete
  on "NAF47_TNET"."INV_NUMERO_SERIE"
  for each row
declare
  -- local variables here
begin
  IF deleting THEN
    INSERT INTO "NAF47_TNET".taauditoria
       VALUES ('INV_NUMERO_SERIE', 'DELETE', user, sysdate,
               'COMPANIA = '|| :old.COMPANIA||' --> ' ||'NO_ARTICULO = '|| :old.NO_ARTICULO ||' --> ' 
               || 'SERIE = '|| :old.SERIE ||' --> '|| '<eol>'
               ,'ID_BODEGA = '|| :old.ID_BODEGA ||' --> '|| 'ESTADO = '|| :old.ESTADO ||' --> '|| 'USUARIO_CREA = '|| :old.USUARIO_CREA ||' --> '||
               'FECHA_CREA = '|| :old.FECHA_CREA ||' --> '|| 'USUARIO_MODIFICA = '|| :old.USUARIO_MODIFICA ||' --> '||
               'FECHA_MODIFICA = '|| :old.FECHA_MODIFICA || ' --> ' || 'MAC = '|| :old.MAC ||' --> '|| 'ORIGEN = '|| :old.ORIGEN ||' --> '||
               'UBICACION = '|| :old.UBICACION ||' --> '|| 'UNIDADES = '|| :old.UNIDADES ||' --> '|| 
               'SERIE_ANTERIOR = '|| :old.SERIE_ANTERIOR ||' --> '|| 'CANTIDAD_SEGMENTO = '|| :old.CANTIDAD_SEGMENTO ||' --> '|| '<eol>');

  ELSIF inserting THEN
    INSERT INTO "NAF47_TNET".taauditoria
       VALUES ('INV_NUMERO_SERIE','INSERT', user, sysdate,
              'COMPANIA = '|| :new.COMPANIA||' --> ' ||'NO_ARTICULO = '|| :new.NO_ARTICULO ||' --> ' || 'SERIE = '|| :new.SERIE ||' --> '|| '<eol>'
               ,'ID_BODEGA = '|| :new.ID_BODEGA ||' --> '|| 'ESTADO = '|| :new.ESTADO ||' --> '|| 'USUARIO_CREA = '|| :new.USUARIO_CREA ||' --> '||
               'FECHA_CREA = '|| :new.FECHA_CREA ||' --> '|| 'USUARIO_MODIFICA = '|| :new.USUARIO_MODIFICA ||' --> '|| 
               'FECHA_MODIFICA = '|| :new.FECHA_MODIFICA || ' --> ' || 'MAC = '|| :new.MAC ||' --> '||
               'ORIGEN = '|| :new.ORIGEN ||' --> '|| 'UBICACION = '|| :new.UBICACION ||' --> '||
               'UNIDADES = '|| :new.UNIDADES ||' --> '|| 'SERIE_ANTERIOR = '|| :new.SERIE_ANTERIOR ||' --> '||
               'CANTIDAD_SEGMENTO = '|| :new.CANTIDAD_SEGMENTO ||' --> '|| '<eol>');

  ELSIF updating THEN
    INSERT INTO "NAF47_TNET".taauditoria
       VALUES ('INV_NUMERO_SERIE','UPDATE', user, sysdate,
               'COMPANIA = '|| :old.COMPANIA ||' --> ' ||'NO_ARTICULO = '|| :old.NO_ARTICULO ||' --> '
               || 'SERIE = '|| :old.SERIE ||' --> '|| '<eol>'
               ,'ID_BODEGA = '|| :old.ID_BODEGA ||' --> '|| 'ESTADO = '|| :old.ESTADO ||' --> '||
               'USUARIO_CREA = '|| :old.USUARIO_CREA ||' --> '|| 'FECHA_CREA = '|| :old.FECHA_CREA ||' --> '||
               'USUARIO_MODIFICA = '|| :old.USUARIO_MODIFICA ||' --> '|| 'FECHA_MODIFICA = '|| :old.FECHA_MODIFICA ||' --> '||
               'MAC = '|| :old.MAC ||' --> '|| 'ORIGEN = '|| :old.ORIGEN ||' --> '||
               'UBICACION = '|| :old.UBICACION ||' --> '|| 'UNIDADES = '|| :old.UNIDADES ||' --> '||
               'SERIE_ANTERIOR = '|| :old.SERIE_ANTERIOR ||' --> '|| 'CANTIDAD_SEGMENTO = '|| :old.CANTIDAD_SEGMENTO ||' --> '|| '<eol>');

  END IF;

end TR_INV_NUM_SERIE_AUDITORIA;


/