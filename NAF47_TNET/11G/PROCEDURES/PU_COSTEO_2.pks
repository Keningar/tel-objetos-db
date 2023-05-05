create or replace procedure            PU_COSTEO_2 (Pv_cia        in varchar2,
                                         Pv_embarque   in varchar2) is

--Recupero todos los articulos para el costeo.
  Cursor C_articulos Is
   Select a.num_fac, a.no_arti, a.cantidad_pedida, a.precio, a.cant_fact
      From arimdetfacturas a, arimencfacturas b
      Where b.no_embarque = Pv_embarque
        And a.no_cia      = Pv_cia
        And a.num_fac     =  b.num_fac
        And b.terminado   = 'S'
      Order By 2;

Cursor C_descrip (Cv_cia in varchar2,
									Cv_art in varchar2) Is
 Select a.codigo_arancel
    From arinda a
    Where a.no_cia  = Cv_cia
      and a.no_arti = Cv_art
      and rownum  = '1';

Lv_partida        arinda.codigo_arancel%type;
Begin
   --Borro la tabla para poder N veces el proceso
   delete from temp_recosteo;

   --Inserto los articulos que voy a procesar
   For i in C_articulos loop
       --Recupero la partida arancelaria del Articulo
       Open C_descrip(Pv_cia, i.no_arti);
       Fetch C_descrip into Lv_partida;
       Close C_descrip;

       insert into temp_recosteo (no_cia, no_embarque, no_arti, partida, cant_ped, cant_rec, fob)
       values (Pv_cia, Pv_embarque, i.no_arti, Lv_partida, i.cantidad_pedida, i.cant_fact, i.precio);
   End loop;

End pu_costeo_2;