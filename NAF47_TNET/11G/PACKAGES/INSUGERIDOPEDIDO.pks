CREATE OR REPLACE package            InSugeridoPedido is

  -- Author  : MARCIA
  -- Created : 16/06/2006 17:11:43
  -- Purpose :

  -- Public type declarations

  -- Public constant declarations
--  <ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  --<VariableName> <Datatype>;

  -- Public function and procedure declarations
PROCEDURE Proye_Inserta(pcia                   arinda.no_cia%type,
                        pmarca                varchar2,
                        pdivision              varchar2,
                        psubdivision           varchar2,
                        pprove                 varchar2,
                        msg_error              out varchar2,
                        pContador              out number);

PROCEDURE Proye_Consumo( pcia                   arinda.no_cia%type,
                           pArticulo     arinda.no_arti%type,
                           pTipo_periodo varchar2,
                           pConsumo      out arimproyeccion.consumo%type,
                           pan_proce              number,
                           pmes_proce             number,
                           pperiodos              number,
                           pdia_proce             number,
                           psem_proce             number
                        );


PROCEDURE Proye_Consumo_c( pcia                   arinda.no_cia%type,
                           pArticulo     arinda.no_arti%type,
                           pTipo_periodo varchar2,
                           pConsumo      out arimproyeccion.consumo%type,
                           pan_proce              number,
                           pmes_proce             number,
                           pperiodos              number,
                           pdia_proce             number,
                           psem_proce             number
                        );

 PROCEDURE Proye_Consumo_Periodo_C(pcia                   arinda.no_cia%type,
                                pArticulo     arinda.no_arti%type,
                                pTipo_periodo varchar2,
                                pConsumo      out arimproyeccion.consumo%type,
                                pdia_proce             number,
                                pperiodos              number,
                                pmes_proce             number,
                                pan_proce              number,
                                vSem_aCTUAL   out number);

PROCEDURE Proye_Existencia(pcia                   arinda.no_cia%type,
                             arti        varchar2,
                             pExistencia OUT number);

  PROCEDURE Proye_Transito(pcia      arinda.no_cia%type,
                          arti      Varchar2,
                          pTransito OUT number);
 PROCEDURE Proye_Consumo_Periodo(pcia                   arinda.no_cia%type,
                                pArticulo     arinda.no_arti%type,
                                pTipo_periodo varchar2,
                                pConsumo      out arimproyeccion.consumo%type,
                                pdia_proce             number,
                                pperiodos              number,
                                pmes_proce             number,
                                pan_proce              number,
                                vSem_aCTUAL   out number);

  PROCEDURE Proye_Etiqueta_Periodo(pcia                   arinda.no_cia%type,

--                                 pArticulo      arinda.no_arti%type,
                                 pTipo_periodo  varchar2,
                                 petiqueta      out arimproyeccion.etiqueta%type,
                                 pan_proce              number,
                                 pmes_proce             number,
                                 pdia_proce             number,
                                 pPeriodo       number);


procedure Asigna_Numero(
                        pcia       varchar2,
                        vno_fisico out number,
                        msg_error  out varchar2);

PROCEDURE Proye_Compra_Local(pcia                   arinda.no_cia%type,
                        pprove                 varchar2,
                        msg_error              out varchar2,
                        pContador              out number);

/**** Procedimientos agregados para uso del punto de ventas en forma FPV2060
      ANR 13/04/2010 ***/


PROCEDURE Proye_Pvpedidos_c(pcia          arinda.no_cia%type,
                            pcentro                Varchar2, --- para punto de ventas el centro de distribucion es el local
                            pArticulo     arinda.no_arti%type,
                            pTipo_periodo varchar2,
                            pConsumo      out number,
                            pan_proce     number,
                            pmes_proce    number,
                            pperiodos     number,
                            pdia_proce    number,
                            psem_proce    number
                        );


 PROCEDURE Proye_Pvpedidos_Periodo_C(pcia          arinda.no_cia%type,
                                     pcentro                Varchar2, --- para punto de ventas el centro de distribucion es el local
                                     pArticulo     arinda.no_arti%type,
                                     pTipo_periodo varchar2,
                                     pConsumo      out number,
                                     pdia_proce    number,
                                     pperiodos     number,
                                     pmes_proce    number,
                                     pan_proce     number,
                                     vSem_aCTUAL   out number);

  PROCEDURE Proye_PvExistencia(pcia        arinda.no_cia%type,
                               pbodega     varchar2,
                               arti        varchar2,
                               pExistencia OUT number);

end InSugeridoPedido;
/



/
