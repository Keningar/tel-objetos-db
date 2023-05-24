CREATE OR REPLACE procedure NAF47_TNET.PINV_GEN_SERIE_AUTOMATICA(pv_no_arti          in    varchar2,
                                                      pv_bodega           in    varchar2,
                                                      pv_cia              in    varchar2,
                                                      pv_ubicacion        in    varchar2,
                                                      pn_cantidad         in    number,
                                                      pn_error            out   number,
                                                      pv_error            out   varchar2) is
PRAGMA AUTONOMOUS_TRANSACTION;
lv_error   varchar2(4000);
le_error   exception;
BEGIN
       NAF47_TNET.INKG_GENERACION_SERIE.P_PROCESA_SERIE(Pv_NoCia => pv_cia,
                                        Pv_NoArticulo => pv_no_arti,
                                        Pv_IdBodega => pv_bodega,
                                        Pv_Ubicacion => pv_ubicacion,
                                        Pv_CantidadSeries => pn_cantidad,
                                        Pv_Error => lv_error);  

       if(lv_error is not null)then
        raise le_error;
       else
         pn_error := 0;
         pv_error := lv_error;
         commit;
       end if;	
EXCEPTION
  WHEN LE_ERROR THEN
    pn_error := -2;
    pv_error := 'ERROR EN PINV_GEN_SERIE_AUTOMATICA ::'||lv_error;
    ROLLBACK;
  WHEN OTHERS THEN
    pn_error := -1;
    pv_error := 'ERROR EN PINV_GEN_SERIE_AUTOMATICA ::'||substr(sqlerrm,1,250);
    ROLLBACK;
end PINV_GEN_SERIE_AUTOMATICA;
/