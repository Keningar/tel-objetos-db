create or replace procedure            CALCULA_ARANCEL(Pv_NoCia        IN VARCHAR2,
                                            Pv_NoEmbarque   IN VARCHAR2,
                                            Pn_MontoFlete   IN NUMBER,
                                            Pn_MontoSeguro  IN NUMBER,
                                            Pn_TotalCIF     OUT NUMBER,
                                            Pn_TotalArancel OUT NUMBER,
                                            Pn_TotalFodInfa OUT NUMBER,
                                            Pn_TotalIva     OUT NUMBER)  IS

  CURSOR C_CALCULO_ARANCEL IS
     Select  --*********************
             --VALOR CIF
             --*********************
             SUM( nvl
              --flete
             ( (((a.cantidad_pedida * a.precio)*Pn_MontoFlete)/y.stotalfob) +
             --seguro
             (((a.cantidad_pedida * a.precio)*Pn_MontoSeguro)/y.stotalfob)+(a.cantidad_pedida * a.precio),0))   SUMVALORCIF,

             --*********************
             -- VALOR ARANCEL
             --*********************
             SUM( nvl(
             --flete
             ((((((a.cantidad_pedida* a.precio)*Pn_MontoFlete)/y.stotalfob) +
             --seguro
             (((a.cantidad_pedida* a.precio)*Pn_MontoSeguro)/y.stotalfob)+(a.cantidad_pedida * a.precio))
             *d.por_arancel)/100),0))                                               SUMtarancel ,
             --*********************
             --VALOR FODINFA
             --*********************
             SUM(NVL(
             --flete
             (((((a.cantidad_pedida* a.precio)*Pn_MontoFlete)/y.stotalfob) +
             --seguro
             (((a.cantidad_pedida* a.precio)*Pn_MontoSeguro)/y.stotalfob)+(a.cantidad_pedida* a.precio)) *
             --fodinfa
             d.fodinfa)/100, 0))                                                   SUMTFODINFA,

             --*********************
             -- TOTAL IVA
             --*********************
             SUM(  NVL(((
             --TOTA CIF
             (   nvl
             --flete
             ((((a.cantidad_pedida* a.precio)*Pn_MontoFlete)/y.stotalfob) +
             --seguro
             (((a.cantidad_pedida* a.precio)*Pn_MontoSeguro)/y.stotalfob)+(a.cantidad_pedida* a.precio),0))
             +
             --TOTAL ARANCEL
             (nvl(
             --flete
             ((((((a.cantidad_pedida* a.precio)*Pn_MontoFlete)/y.stotalfob) +
             --seguro
             (((a.cantidad_pedida* a.precio)*Pn_MontoSeguro)/y.stotalfob)+(a.cantidad_pedida * a.precio))

             *d.por_arancel)/100),0))
             +
             --VALOR FODINFA
             (NVL(
             --flete
             (((((a.cantidad_pedida * a.precio)*Pn_MontoFlete)/y.stotalfob) +
             --seguro
             (((a.cantidad_pedida* a.precio)*Pn_MontoSeguro)/y.stotalfob)+(a.cantidad_pedida * a.precio)) *
             --fodinfa
              d.fodinfa)/100, 0))) *
              d.porc_iva)/100 , 0)) SUMTIVA

         From arimencfacturas b, 
              arimdetfacturas a, 
              arimencorden c, 
              arimarancel d, 
              arinda n,

              (Select SUM(a.cantidad_pedida * a.precio) STOTALfob
                 from arimencfacturas b, arimdetfacturas a, arimencorden c
                where b.no_cia   = Pv_NoCia
                  and c.no_cia   = b.no_cia
                  and c.no_orden = b.no_orden
                  and c.no_cia   = a.no_cia
                  and b.num_fac  = a.num_fac
                  and c.no_embarque = Pv_NoEmbarque) Y
        Where b.no_cia = c.no_cia
          and b.no_orden = c.no_orden
          and b.no_cia = a.no_cia
          and b.num_fac = a.num_fac
          and a.no_cia = n.no_cia
          and a.no_arti = n.no_arti
          and n.codigo_arancel = d.cod_arancel
          and n.no_cia = d.no_cia
          --and b.imp_dav = 'S'
          and b.no_cia   = Pv_NoCia
          and c.no_embarque = Pv_NoEmbarque;

BEGIN
  -- Inicializacion
  Pn_TotalCIF     := 0;  
  Pn_TotalArancel := 0;  
  Pn_TotalFodInfa := 0;
  Pn_TotalIva     := 0;
              
  IF C_CALCULO_ARANCEL%ISOPEN THEN CLOSE C_CALCULO_ARANCEL; END IF;
  OPEN C_CALCULO_ARANCEL;
  FETCH C_CALCULO_ARANCEL INTO Pn_TotalCIF,  
                               Pn_TotalArancel,  
                               Pn_TotalFodInfa,  
                               Pn_TotalIva;
  CLOSE C_CALCULO_ARANCEL;
  
END CALCULA_ARANCEL;