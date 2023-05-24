CREATE OR REPLACE package NAF47_TNET.MPK_MIGRA_NAF_FORMA_PIN277 is

  -- Author  : JOHNNY
  -- Created : 23/02/2023 11:40:12
  -- Purpose :

   procedure GCP_POSTQUERY_BL_SOLICITUDES(
                                            pv_No_Cia                                 in         TAPORDEE.No_Cia%type,
                                            pv_TXT_TECNICO                            in         varchar2,
                                            pn_ID_DETALLE_SOLICITUD                   in         number,
                                            pv_TXT_CED_ASIGNADO_RESPONSABL         in         varchar2,

                                            pv_REF_ASIGNADO_ID                        out        varchar2,
                                            pn_error                                  out        number,
                                            pv_error                                  out        varchar2
    );



end MPK_MIGRA_NAF_FORMA_PIN277;
/

CREATE OR REPLACE package body NAF47_TNET.MPK_MIGRA_NAF_FORMA_PIN277 is


procedure GCP_POSTQUERY_BL_SOLICITUDES(
                                        pv_No_Cia                                 in         TAPORDEE.No_Cia%type,
                                        pv_TXT_TECNICO                            in         varchar2,
                                        pn_ID_DETALLE_SOLICITUD                   in         number,
                                        pv_TXT_CED_ASIGNADO_RESPONSABL         in         varchar2,
                                            
                                        pv_REF_ASIGNADO_ID                        out        varchar2,
                                        pn_error                                  out        number,
                                        pv_error                                  out        varchar2
)is


begin
  -- Call the procedure
  MPK_MIGRA_NAF_FORMA_PIN277.GCP_POSTQUERY_BL_SOLICITUDES@GPOETNET(pv_No_Cia => pv_No_Cia,
                                                          pv_TXT_TECNICO => pv_TXT_TECNICO,
                                                          pn_ID_DETALLE_SOLICITUD => pn_ID_DETALLE_SOLICITUD,
                                                          pv_TXT_CED_ASIGNADO_RESPONSABL => pv_TXT_CED_ASIGNADO_RESPONSABL,
                                                          pv_REF_ASIGNADO_ID => pv_REF_ASIGNADO_ID,
                                                          pn_error => pn_error,
                                                          pv_error => pv_error);
end;


end MPK_MIGRA_NAF_FORMA_PIN277;
/
