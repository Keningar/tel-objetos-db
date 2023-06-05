create or replace package PKG_IMPORT_APRUEBA_TRAMITE is

  -- Author  : JOHNNY
  -- Created : 22/05/2023 9:51:00
  -- Purpose : 



PROCEDURE actualiza_desalmacenaje(pv_no_cia               in      varchar2,
                                  pn_no_embarque          in      number,
                                  pn_no_docu              in      number,
                                  pv_tipodoc              in      varchar2,
                                  pv_formulario           in      varchar2,
                                  pn_ano_fis              in      number,
                                  pn_mes                  in      number,
                                  pn_tipo_cambio          in      number,
                                  pd_hora_ent             in      date,
                                  pv_centro               in      varchar2,
                                  pv_ind_antipo           in      varchar2,
                                  pv_ind_costeo           in      varchar2,
                                  pn_error  out     number,
                                  pv_error  out     varchar2
                                  ) ;  

                          

end PKG_IMPORT_APRUEBA_TRAMITE;
/
create or replace package body PKG_IMPORT_APRUEBA_TRAMITE is

       lv_package varchar2(200) := 'PKG_IMPORT_APRUEBA_TRAMITE';

PROCEDURE actualiza_desalmacenaje(pv_no_cia               in      varchar2,
                                  pn_no_embarque          in      number,
                                  pn_no_docu              in      number,
                                  pv_tipodoc              in      varchar2,
                                  pv_formulario           in      varchar2,
                                  pn_ano_fis              in      number,
                                  pn_mes                  in      number,
                                  pn_tipo_cambio          in      number,
                                  pd_hora_ent             in      date,
                                  pv_centro               in      varchar2,
                                  pv_ind_antipo           in      varchar2,
                                  pv_ind_costeo           in      varchar2,
                                  pn_error  out     number,
                                  pv_error  out     varchar2
                                  ) IS

  lv_proceso varchar2(200) := 'actualiza_desalmacenaje11G';
  le_error   exception;
  ln_error   number;
  lv_error   varchar2(4000);
Begin
  ---
    PKG_IMPORT_APRUEBA_TRAMITE.actualiza_desalmacenaje@gpoetnet(pv_no_cia => pv_no_cia,
                                                                 pn_no_embarque => pn_no_embarque,
                                                                 pn_no_docu => pn_no_docu,
                                                                 pv_tipodoc => pv_tipodoc,
                                                                 pv_formulario => pv_formulario,
                                                                 pn_ano_fis => pn_ano_fis,
                                                                 pn_mes => pn_mes,
                                                                 pn_tipo_cambio => pn_tipo_cambio,
                                                                 pd_hora_ent => pd_hora_ent,
                                                                 pv_centro => pv_centro,
                                                                 pv_ind_antipo => pv_ind_antipo,
                                                                 pv_ind_costeo => pv_ind_costeo,
                                                                 pn_error => ln_error,
                                                                 pv_error => lv_error);
                                                                 
  if (pn_error is not null) then
    raise le_error;  
  end if;                                                                 
  
  pn_error := ln_error;
  pv_error := lv_error;
  commit;
Exception
  When le_error then
    pn_error := ln_error;
    pv_error := lv_error;
    rollback;
  When Others Then
    pn_error := 999;
    pv_error := lv_package||'.'||lv_proceso||'::'||'error'||sqlerrm;
    rollback;
End; -- DE ACTUALIZA_DESALMACENAJE



end PKG_IMPORT_APRUEBA_TRAMITE;
/
