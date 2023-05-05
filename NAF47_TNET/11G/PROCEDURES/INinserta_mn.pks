create or replace PROCEDURE            INinserta_mn(pNo_cia       IN varchar2,
                                         pCentro       IN varchar2,
                                         pTipo_doc     IN varchar2,
                                         pNo_docu      IN varchar2,
                                         pAno          IN varchar2,
                                         pMes          IN number,
                                         pSemana       IN number,
                                         pind_sem      IN varchar2,
                                         pRuta         IN varchar2,
                                         pNo_linea     IN number,
                                         pBodega       IN varchar2,
                                         pNo_arti      IN varchar2,
                                         pFecha        IN date,
                                         pUnidades     IN number,
                                         pMonto        IN number,
                                         pDescuento    IN number,
                                         pTipo_refe    IN varchar2,
                                         pNo_refe      IN varchar2,
                                         pNo_prove     IN varchar2,
                                         pCosto        IN number,
                                         pTime_stamp   IN date,
                                         pcc           IN varchar2 DEFAULT '000000000',
                                         pind_oferta   IN varchar2 DEFAULT 'N',
                                         p_preciov     in number,
                                         p_monto2      in number,
                                         p_costo2      in number) Is

  vCosto_unit       number;
  vperiodo_proce    arinmn.periodo_proce%type;
  vcc               arinmn.centro_costo%type;
  vcosto_2          arinmn.costo2%type;

Begin
   --
	 vcc := pcc;
   --
   If pind_oferta is null then
    null;
   End If;

	 If pcc is Null Then
	 	 vcc := centro_costo.rellenad(pNo_cia, '0');
	 End If;
   --

      vcosto_unit := pCosto;
      vcosto_2    := p_costo2;

   --
   vperiodo_proce := to_char((to_number(pano) * 100) + psemana) || pind_sem;
   --

   --
   Insert Into arinmn ( No_cia,     Centro,     Tipo_doc,   Ano,
                        Ruta,       No_docu,    No_linea,   Bodega,
                        No_arti,    Costo_uni,
                        Fecha,      Unidades,   Monto,
                        Descuento,
                        Tipo_refe,  No_refe,    No_prove,
                        Time_stamp, centro_costo,
                        mes,        semana,
                        periodo_proce,  precio_venta,
                        monto2,     costo2)

               values(  pno_cia,    pCentro,    pTipo_doc,   pano,
                        pruta,      pno_docu,   pno_linea,   pbodega,
                        pno_arti,   vCosto_unit,
                        pfecha,     punidades,  pmonto,
                        pdescuento,
                        ptipo_refe, pno_refe,   pno_prove,
                        nvl(pTime_stamp,sysdate), vcc,
                        pmes,       psemana,
                        vperiodo_proce,p_preciov,
                        p_monto2,   vcosto_2) ;
   --
End;