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

FUNCTION IMmovimiento_valido (
    pcia         in varchar2,
    ptipo_doc    in varchar2,
    pno_docu     in varchar2,
    msg_error_p  in out varchar2
) RETURN BOOLEAN;



PROCEDURE Imcrea_encabezado_h(pmes         in number,
                              psemana      in number,
                              pind_sem     in varchar2,
                              vno_docu     in varchar2,
                              vfisico      in varchar2,
                              vserie       in varchar2,
                              dia_proceso  in date,
                              pn_no_embarque  in number,
                              pv_no_cia       in varchar2,
                              pn_error  out     number,
                              pv_error  out     varchar2);
                              
                              

procedure INinserta_conta(
  cia_p     in varchar2,
  cen_p     in varchar2,      -- centro
  tip_p     in varchar2,      -- tipo documento
  doc_p     in varchar2,      -- num. transacción
  mov_p     in varchar2,      -- tipo de movimiento contable
  pcta      in varchar2,      -- cuenta contable
  tot_p     in number,        -- monto
  cc        in varchar2,
  tot_d     in number,        -- monto en dolares
  tipo_c    in number,
  tercero_p in varchar2 ,      -- Código de tercero
  pano      NUMBER  , 
  pmes      NUMBER,
  pn_error  out     number,
  pv_error  out     varchar2
);


PROCEDURE borra_actualiza_tablas(vno_docu                         in                  varchar2, 
                                 Ld_dia_proceso                   in                  date,
                                 Ln_monto                         in                  number,
                                 pv_no_cia                        in                  varchar2,
                                 pv_centro                        in                  varchar2,
                                 pn_no_embarque                   in                  number,
                                 pn_no_docu                       in                  number,
                                 pn_tipo_cambio                   in                  number,
                                 pv_ind_antipo                    in                  varchar2,
                                 pv_ind_costeo                    in                  varchar2,
                                 pn_error  out     number,
                                 pv_error  out     varchar2);                              

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



  --
  -- Ano y mes en proceso para la compañía y centro de distribución.
  Cursor ano_mes (Lv_centro Varchar2) Is
    Select ano_proce, mes_proce, dia_proceso, semana_proce,indicador_sem
      From arincd
     Where no_cia = pv_no_cia
       And centro = Lv_centro;
  --    
  Cursor c_Cabdesalm ( pDocu varchar2,
                       pTipo_d varchar2) Is
    Select centro
     From arimencdoc a 
    Where a.no_cia  = pv_no_cia
      And no_docu   = pDocu
      And tipo_doc  = pTipo_d;
  
  --- Se separa un cursor para items que vienen una sola vez en la importacion ANR 26/04/2010  
  Cursor c_lineasdesalm ( pDocu varchar2, 
                          pTipo_d varchar2) Is
    Select periodo,ruta,linea,linea_ext linea_ext,bodega,a.no_arti,grupo,
           unidades cantidad, nvl(monto,0)/ unidades costo_nomi,
           tipo_cambio tipo_cambio,
           nvl(monto,0) total_lin,
           costo_estandar costo_estandar,
           ind_serv, a.pvp,
           nvl((monto2),0) monto2
      From arimdetdoc a, arinda b
     Where a.no_cia  = pv_no_cia
       And a.no_cia  = b.no_cia
       And a.no_arti = b.no_arti
       And no_docu   = pDocu
       And tipo_doc  = pTipo_d    
       And a.no_arti in ( select no_arti from arimdetdoc
                           where no_cia = pv_no_cia
                             and no_docu = pDocu
                           group by no_arti 
                          having count(*) = 1);

  --- En otro cursor se separa items que vienen mas de una vez en la importacion ANR 26/04/2010
  Cursor c_lineasdesalm_varios_arti ( pDocu varchar2, 
                                      pTipo_d varchar2) Is
    Select periodo,ruta,bodega,a.no_arti,grupo,
           sum(unidades) cantidad, 
           tipo_cambio tipo_cambio,
           sum(nvl(a.monto,0)) total_lin,
           a.pvp,
           sum(nvl(a.monto2,0)) monto2
      From arimdetdoc a, arinda b
     Where a.no_cia  = pv_no_cia
       And a.no_cia  = b.no_cia
       And a.no_arti = b.no_arti
       And no_docu   = pDocu
       And tipo_doc  = pTipo_d    
       And a.no_arti in (select no_arti from arimdetdoc
                          where no_cia = pv_no_cia
                            and no_docu = pDocu
                          group by no_arti 
                         having count(*) > 1)
    group by a.periodo, ruta, bodega, a.no_arti,grupo,tipo_cambio, a.pvp;

  -- 
  Cursor c_Linea_arti ( pDocu varchar2,
                        pTipo_d varchar2,
                        Pv_arti varchar2) Is
    Select a.linea
      From arimdetdoc a, arinda b
     Where a.no_cia    = pv_no_cia
       And a.no_cia    = b.no_cia
       And a.no_arti   = b.no_arti
       And no_docu     = pDocu
       And tipo_doc    = pTipo_d
       And a.no_arti   = Pv_arti    
       And a.no_arti in (select no_arti from arimdetdoc
                          where no_cia = pv_no_cia
                            and no_docu = pDocu
                          group by no_arti 
                         having count(*) > 1); 
  -- lotes
  Cursor c_lotes (cia_c varchar2,  tip_c  varchar2,  doc_c varchar2,
                  lin_c number) Is
    Select no_lote, nvl(unidades,0) unidades,
           nvl(monto,0) monto,
           ubicacion, fecha_vence, tipo_doc, no_docu, periodo, ruta, linea
      From arimlotes
     Where no_cia    = cia_c  
       And no_docu  = doc_c  
       And tipo_doc = tip_c  
       And linea    = lin_c; 
  --                   
  Cursor c_grupo_contable(pno_cia  grupos.no_cia%type, pgrupo  grupos.grupo%type ) Is
    Select grupo, metodo_costo
      From grupos
     Where no_cia  = pno_cia
       And grupo   = pgrupo;
  --       
  -- Obtiene la cta de i Mercancias en Transito
  Cursor Cta_InvenMercTrans Is
    Select decode(pn_no_embarque,'000000000000',CTA_INV_NACIONAL,Cta_Inv_Tmp),
           decode(pn_no_embarque,'000000000000',CTA_imp_N,Cta_gast_imp)
      From arimco
     Where no_cia = pv_no_cia;
  --
  -- Obtiene la cuenta de inventario.
  Cursor cta_invent(p_gru  Varchar2, p_bod Varchar2) Is
    Select cta_inventario, centro_costo
      From arincc
     Where no_cia  = pv_no_cia
       And grupo   = p_gru
       And bodega  = p_bod;
  --       
  --cuersor para el proveedor
  cursor provedor_docu is 
    SELECT a.no_prove, nombre
      FROM arimencdoc a, arcpmp b
     WHERE a.no_cia     = pv_no_cia 
       AND a.no_docu    = pn_no_docu
       AND a.no_cia     = b.no_cia
       AND a.no_prove   = b.no_prove;
  --
  Cursor C_fecha is
    select sysdate
      from dual;
   
  Cursor C_Arinma (Lv_Bodega Varchar2, Lv_Arti Varchar2) Is
    Select 'X' 
      From Arinma 
     where no_cia  = pv_no_cia
       And bodega  = Lv_Bodega
       And no_arti = Lv_Arti; 
   
  Cursor C_Arindc (Lv_docu Varchar2) Is  --- Verifica que se haya generado un asiento contable ANR 02/09/2009
    Select 'X'
     From Arindc
    Where no_cia = pv_no_cia
      And no_docu = Lv_docu;   

  provedor_r          arimencdoc.no_prove%type;
  Lv_nombre_proveedor arcpmp.nombre%type;
  --
  -- Variables para cuentas contables a utilizar
  CtaInvMercTran   arimco.cta_inv_tmp%type;
  CtaProv          arcpgr.cta_prove%type;
  CtaInventario    arincc.cta_inventario%type;
  Cta_Imp          arincc.cta_inventario%type;  

  -- Variables para datos del articulo
  grupo            arinda.grupo%type;
  No_Art           arinda.no_arti%type;
  vcc_contrap      arindc.centro_costo%type; 
  vcc_inven        arindc.centro_costo%type;  

  -- Variables para el la fecha de la compania y centro
  anoproc          arincd.ano_proce%type;
  mesproc          arincd.mes_proce%type;
  diaproc          arincd.dia_proceso%TYPE;
  semaproc         arincd.semana_proce%type;
  indproc          arincd.indicador_sem%type;
  
  -- Otras variables
  es_de_Inv        varchar2(1);
  contador         number;
  encontro         Boolean;
  no_doc_gen       arinme.no_docu%type;
  cont_art_inv     Number;
  cont_art_inv_mas Number;
   
  dummy            varchar2(1);
  vprecio          arinda.preciobase%type;
  VFISICO          arinme.no_fisico%type;
  VSERIE           arinme.serie_fisico%type;   
  rmc              c_grupo_contable%rowtype; 
  msg_error_p      varchar2(5000);
  vno_docu         arinme.no_docu%type;
  vtipo_doc        arinme.tipo_doc%type;
  mto_entra        number:=0;
  mto_2           number:=0;
  vdocumento       varchar2(12);
  Error_Proceso    Exception;
  Ld_fecha     Date;
  Lv_centro_distribucion Arincd.centro%type;
  Lv_dummy         Varchar2(1);
  lv_transf        arinte.no_docu%type;
  
  Ln_linea         Arinml.linea%type;
  lv_error         varchar2(2000);
  
  ln_error         number;
  lv_proceso varchar2(200) := 'actualiza_desalmacenaje';
  pragma autonomous_transaction;
Begin
  ---
  Open C_fecha;
  Fetch C_fecha into Ld_fecha;
  Close C_fecha;
  ---
  vdocumento:=pn_no_docu;
  --- 
  Vno_docu     :=pn_no_docu;
  vtipo_doc    :=pv_tipodoc ;
  
  Open c_Cabdesalm (vno_docu, vtipo_doc);
  Fetch c_Cabdesalm into Lv_Centro_distribucion;
  If c_Cabdesalm%notfound Then
    Close c_Cabdesalm ;
    --msg_aviso('No existe centro de distribución para el documento: '||vtipo_doc||' '||vno_docu);
    lv_error := 'No existe centro de distribución para el documento: '||vtipo_doc||' '||vno_docu;
    raise Error_Proceso;
  else
    Close c_Cabdesalm ;
  end if;
  
  --valida los lotes si son iguales a las unidades de cada linea---
  If Not IMmovimiento_valido ( pv_no_cia,
                               vtipo_doc,
                               vno_docu,
                               msg_error_P ) Then
    --msg_aviso(msg_error_p);
    lv_error := msg_error_p;
    Raise Error_Proceso;
  Elsif pv_formulario is null then
    --msg_aviso('El documento: '||vtipo_doc ||'  Transa.'||vno_docu|| ' no tiene número físico y no tiene formulario asociado'||sqlerrm);
    lv_error := 'El documento: '||vtipo_doc ||'  Transa.'||vno_docu|| ' no tiene número físico y no tiene formulario asociado'||sqlerrm;
    raise Error_Proceso;
  Else
    vfisico:= Consecutivo.INV(pv_no_cia, 
                              anoproc, 
                              mesproc, 
                              Lv_centro_distribucion, 
                              vtipo_doc ,
                              'NUMERO');

    vserie := Consecutivo.INV(pv_no_cia,    
                              ANOPROC, 
                              MESPROC, 
                              Lv_centro_distribucion, 
                              vtipo_doc ,
                              'SERIE');
  End If;

  -- Obtiene el mes y ano en proceso de inventarios
  Open ano_mes (Lv_Centro_distribucion);
  Fetch ano_mes into anoproc, mesproc, diaproc,semaproc,indproc;
  encontro := ano_mes%Found;
  Close ano_mes;

  If Not encontro Then
    --msg_aviso('ERROR: al obtener el mes y periodo en proceso de la compañía y centro. Centro de distribución: '||Lv_centro_distribucion);
    lv_error := 'ERROR: al obtener el mes y periodo en proceso de la compañía y centro. Centro de distribución: '||Lv_centro_distribucion;
    Raise Error_Proceso;
  End If;

  If pn_ano_fis is null or pn_mes is null or anoproc is null or mesproc is null then
    --msg_aviso('El Periodo de Inventario o el de Importaciones esta en nulo .Verifique el año y mes de ambos sistemas. Centro de distribución: '||Lv_centro_distribucion);
    lv_error := 'El Periodo de Inventario o el de Importaciones esta en nulo .Verifique el año y mes de ambos sistemas. Centro de distribución: '||Lv_centro_distribucion;
    raise Error_Proceso;
  Elsif (pn_ano_fis||ltrim(to_char(pn_mes,'00')) )!=(anoproc||ltrim(to_char(mesproc,'00')) )   then
    --msg_aviso('El Período de Inventario es diferente  del período de  Importaciones. Centro de distribución: '||Lv_centro_distribucion);
    lv_error := 'El Período de Inventario es diferente  del período de  Importaciones. Centro de distribución: '||Lv_centro_distribucion;
    Raise Error_Proceso;
  Else
    -- Obtiene la cuenta contable de inventario de Mercaderías en Tránsito
    Open Cta_InvenMercTrans;
    Fetch Cta_InvenMercTrans into CtaInvMercTran,cta_imp;
    encontro := Cta_InvenMercTrans%Found;
    Close Cta_InvenMercTrans;
 
    If not encontro Then
      --message('No se ha definido la cuenta de Inventario de Mercadería en tránsito');
      lv_error := 'No se ha definido la cuenta de Inventario de Mercadería en tránsito';
      --message(' ', no_acknowledge);
      --synchronize;
      Raise Error_Proceso;
    End If;
  End If;

  If CtaInvMercTran is null Then
    --message('No se ha definido la cuenta de Inventario de Mercadería en tránsito');
    lv_error := 'No se ha definido la cuenta de Inventario de Mercadería en tránsito';
    --message(' ', no_acknowledge);
    --synchronize;
    Raise Error_Proceso;
  else
    contador :=0;
    Begin
      ---
      open provedor_docu;
      fetch provedor_docu into provedor_r, Lv_nombre_proveedor;
      close provedor_docu;
      ---
      Insert into arinme ( no_cia,          centro,                periodo, 
                           ruta,            tipo_doc,              no_docu, 
                           estado,          fecha,                 tipo_refe, 
                           no_refe,         conduce,               descuento,
                           imp_ventas,      mov_tot,               OBSERV1,
                           no_prove,        no_fisico,             serie_fisico, 
                           tipo_cambio,     fecha_ent,             hora_ent, 
                           moneda_refe_cxp, monto_digitado_compra, origen,
                           usuario,         Fecha_aplicacion)
                  values ( pv_no_cia,          Lv_Centro_distribucion, to_char(anoproc), 
                           '0000',               vtipo_doc,              vno_docu,
                           'D',                  diaproc,                null, 
                           null,                 null,                   0, 
                           0,                    1,                      substr('IMPORTACIÓN '||Lv_nombre_proveedor||' COMPRA GENERADA POR AUX.IMPORTACIONES EMBARQUE No.-'||pn_no_embarque,1,400),  --FEM 27-05-2009
                           nvl(provedor_r,null), vfisico,                vserie,
                           pn_tipo_cambio,     diaproc,                nvl(pd_hora_ent, sysdate),  --sysdate, FEM 
                           'P',                  0,                      'IM',
                           USER,                 ld_fecha);
    Exception
      When Others Then
        --Message('Error al crear el ingreso en Inventario '||SQLERRM);
        lv_error := 'Error al crear el ingreso en Inventario '||SQLERRM;
        --message(' ', no_acknowledge);
        --synchronize;
        raise Error_Proceso;
    End;
    
    --- Actualiza el no_fisico en el registro a Inventarios de Importaciones
    update arimencdoc
       set no_fisico = vfisico
     where no_cia  = pv_no_cia
       and no_docu = pn_no_docu; 
    
    contador   := 0;
    cont_art_inv  := 0;
   
    --Crea el documento en el histórico de encabezado de documento
    IMCrea_encabezado_h( mesproc, 
                         semaproc, 
                         indproc,
                         vno_docu,
                         vfisico,
                         vserie,
                         diaproc,
                         pn_no_embarque,
                         pv_no_cia,
                         ln_error,
                         lv_error);
     
    /**** procesa para el caso de que un articulo viene en una sola linea en la importacion ****/
    
    ---
    For LinDes in c_LineasDesalm(vno_docu, vtipo_doc) Loop
      ---
      If rmc.grupo is null or rmc.grupo != lindes.grupo then
        ---
        rmc.grupo := null;
        open c_grupo_contable(pv_no_cia, lindes.grupo);
        fetch c_grupo_contable into rmc;
        close c_grupo_contable;
        ---
        If rmc.grupo is null then
          --message('ERROR: No existe el grupo contable: '||lindes.grupo);
          lv_error := 'ERROR: No existe el grupo contable: '||lindes.grupo;
          Raise Error_Proceso;
        End If;
        ---
      End If;

      --- Obtiene la cuenta contable GRUPO CONTABLE
      Open cta_invent(lindes.grupo,lindes.bodega) ;
      Fetch cta_invent into ctaInventario, vcc_inven;
      Close cta_invent;
      ---
      If Ctainventario is null then
        --message('No se ha definido la cuenta del grupo de inventario '||lindes.GRUPO||' para la bodega '||lindes.bodega);
        lv_error := 'No se ha definido la cuenta del grupo de inventario '||lindes.GRUPO||' para la bodega '||lindes.bodega;
        --message(' ', no_acknowledge);
        --synchronize;
        Raise Error_Proceso;
      End If;
      
      If vcc_inven is null Then
        --msg_aviso ('Debe definir un centro de costos para la cuenta contable de Inventarios. Grupo: '||lindes.grupo||' Bodega: '||lindes.bodega );
        lv_error := 'Debe definir un centro de costos para la cuenta contable de Inventarios. Grupo: '||lindes.grupo||' Bodega: '||lindes.bodega;
        raise Error_Proceso;
      end if;   
      ---
      mto_entra    := round(nvl(mto_entra,0) + nvl(lindes.total_lin,0),2);
      mto_2        := round(nvl(mto_2,0) + nvl(lindes.monto2,0),2);
      cont_art_inv := cont_art_inv + 1;
      contador   := contador + 1;
      ---    
      Open C_Arinma (lindes.bodega, lindes.no_arti);
      Fetch C_Arinma into Lv_dummy;
      If C_Arinma%notfound Then
        Close C_Arinma;
        --Msg_aviso('Artículo no existe en Bodega: '||lindes.bodega||' Artículo: '||lindes.no_arti);
        lv_error := 'Artículo no existe en Bodega: '||lindes.bodega||' Artículo: '||lindes.no_arti;
        Raise Error_Proceso;      
      else
        Close C_Arinma;
      end if;
      
      Begin
        Insert Into arinml 
                  ( no_cia,       centro,      tipo_doc,
                    periodo,      ruta,        no_docu,
                    linea,        linea_ext,   bodega,
                    no_arti,      ind_iv,      unidades,
                    monto,        tipo_cambio, monto_dol,
                    precio_venta, monto2,      monto2_dol,
                    time_stamp)
            Values (pv_no_cia,             Lv_Centro_distribucion, vtipo_doc,
                    to_char(anoproc),        '0000',                 vno_docu,
                    lindes.linea,            lindes.linea_ext,       lindes.bodega,
                    lindes.no_arti,          'S',                    lindes.cantidad,
                    nvl(lindes.total_lin,0), lindes.tipo_cambio,     nvl(lindes.total_lin,0)/lindes.tipo_cambio,
                    nvl(lindes.pvp,0),       nvl(lindes.monto2,0),   nvl(lindes.monto2,0)/lindes.tipo_cambio,
                    Ld_fecha);
      Exception
        When Others Then
        --msg_aviso('Error al crear la línea en Inventario. Bodega: '||lindes.bodega||' Artículo: '||lindes.no_arti||' '||SQLERRM);
        lv_error := 'Error al crear la línea en Inventario. Bodega: '||lindes.bodega||' Artículo: '||lindes.no_arti||' '||SQLERRM;
        Raise Error_Proceso;
      End;
      
      -- llindao: procedimiento que replica numeros de series por codigo de articulo.
      INACT_NUMEROS_SERIES ( pv_no_cia,
                             vno_docu,
                             lindes.linea,
                             lindes.no_arti,
                             msg_error_p);
                             
      If msg_error_p Is Not Null Then
        --message(msg_error_p);
        lv_error := msg_error_p;
        Raise Error_Proceso;
      End If;
      
      /* REEMPLAZA POR PROCEDURE INACT_NUMERO_SERIE
      BEGIN
        INSERT INTO INV_DOCUMENTO_SERIE 
                  ( COMPANIA, ID_DOCUMENTO, LINEA,
                    SERIE,    USUARIO_CREA, FECHA_CREA)
             SELECT COMPANIA, NO_DOCUMENTO, lindes.linea,
                    SERIE,    USER,         SYSDATE
               FROM INV_PRE_INGRESO_NUMERO_SERIE
              WHERE NO_ARTICULO = lindes.no_arti
                AND NO_DOCUMENTO = vno_docu
                AND COMPANIA = pv_no_cia;
      EXCEPTION
        WHEN OTHERS THEN
          msg_aviso('Error al crear Números de Series. Bodega: '||lindes.bodega||' Artículo: '||lindes.no_arti||' '||SQLERRM);
          Raise Error_Proceso;
      END;
      */
      BEGIN   
        -- Inserta en ARINMN la línea que se esta procesando
        INinserta_mn( pv_no_cia,     Lv_Centro_distribucion, vtipo_doc ,
                      vno_docu,        to_char(anoproc),       mesproc,
                      semaproc,        indproc,                '0000',
                      lindes.linea,    lindes.bodega,          lindes.no_arti,  
                      diaproc,         lindes.cantidad,        lindes.TOTAL_LIN,
                      0,               null,                   null,
                      null,            lindes.costo_nomi,      to_date(to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'),
                      '000000000',     'N',                    lindes.pvp,
                      lindes.monto2,   lindes.monto2/lindes.cantidad); --- Va el costo2 ANR 09/02/2010
      Exception
        When Others Then
          --Msg_aviso('Error al crear la línea histórica en Inventario. Bodega: '||lindes.bodega||' Artículo: '||lindes.no_arti||' '||SQLERRM);
          lv_error := 'Error al crear la línea histórica en Inventario. Bodega: '||lindes.bodega||' Artículo: '||lindes.no_arti||' '||SQLERRM;
          Raise Error_Proceso;     
      END;
     
      /**** NOTA IMPORTANTE: El orden de los procedimientos siempre va a ser:
            INCOSTO_UNI (SI ES ENTRADA DE COMPRAS, ENTRADA REORDENAMIENTO, ENTRADA IMPORTACION)
            ACTUALIZAR STOCK ARTICULO (PARA TODOS LOS CASOS)
            INCOSTO_ACTUALIZA (PARA TODOS LOS CASOS)
            ANR 16/06/2010  
      ****/ 
     
      -- El costo unitario solamente se actualiza cuando se trata 
      -- de movimientos de entrada
      INcosto_Uni( pv_no_cia,
                   lindes.bodega,
                   lindes.no_arti,
                   lindes.cantidad,
                   round(lindes.total_lin/lindes.cantidad,6), 
                   round(lindes.monto2/lindes.cantidad,6), 
                   msg_error_p
                 );
     
      If msg_error_p Is Not Null Then
        --message('Errores en incosto_uni Articulo: '||lindes.no_arti||' Bodega: '||lindes.bodega||' Error: '||msg_error_p||' '||sqlerrm);
        lv_error := 'Errores en incosto_uni Articulo: '||lindes.no_arti||' Bodega: '||lindes.bodega||' Error: '||msg_error_p||' '||sqlerrm;
        Raise Error_Proceso;
      End If;
  
      -- Actualiza el monto de las compra en ARINMA (Maestro de artículos),
      -- el costo unitario del artículo y el último costo.
      UPDATE arinma
         SET comp_un    = nvl(comp_un,0)  + (lindes.cantidad),
             comp_mon   = nvl(comp_mon,0) + (lindes.total_lin),
             activo     = 'S',
             fec_u_comp = diaproc
       WHERE no_cia   = pv_no_cia
         AND bodega   = lindes.bodega
         AND no_arti  = lindes.no_arti;
     
      --- No debe actualizarse el costo unitario del articulo ANR 27/04/2009
      --- pero si debe actualizar el monto 2 y el saldo valuado para todas las bodegas

      INCOSTO_ACTUALIZA (pv_no_cia, lindes.no_arti);    

      -- Procesa lotes ANR 12/05/2009
      --
  
      For j in c_lotes(pv_no_cia, vtipo_doc, vno_docu, lindes.linea) LOOP
        --- Crea el registro en ARINMO
        INSERT INTO arinmo ( no_cia, centro, tipo_doc, periodo, ruta, no_docu, 
                             linea, no_lote, unidades, monto, descuento_l, imp_ventas_l,
                             ubicacion, fecha_vence)
                    Values ( pv_no_cia, Lv_Centro_distribucion, j.tipo_doc, j.periodo, j.ruta, j.no_docu, 
                             j.linea, j.no_lote, j.unidades, j.monto, 0, 0,
                             j.ubicacion, j.fecha_vence);
 
        UPDATE arinlo
           SET saldo_unidad   = nvl(saldo_unidad, 0) + (j.unidades ),
               saldo_contable = 0, --- En lotes solamente se llevan unidades ANR 12/05/2009
               saldo_monto    = 0
         WHERE no_cia  = pv_no_cia
           AND bodega  = lindes.bodega
           AND no_arti = lindes.no_arti
           AND no_lote = j.no_lote;
        --
        IF sql%rowcount = 0 THEN
          INSERT INTO arinlo
                    ( no_cia,      bodega,        no_arti,        no_lote,
                      ubicacion,   saldo_unidad,  saldo_contable, saldo_monto,
                      salida_pend, costo_lote,    proceso_toma,   exist_prep,
                      costo_prep,  fecha_entrada, fecha_vence,    fecha_fin_cuarentena )
              VALUES( pv_no_cia, lindes.bodega, lindes.no_arti, j.no_lote,
                      j.ubicacion, j.unidades,    j.unidades,     0,
                      0,           0,             'N',            null,
                      null,        Ld_fecha,      j.fecha_vence,  null);
        END IF;
        --
        -- Inserta en ARINMT la linea que se esta procesando
        Insert Into arinmt( no_cia,  centro,  tipo_doc, ano, 
                            ruta,    no_docu, no_linea, bodega,
                            no_arti, no_lote, unidades, venta, 
                            descuento )
                    values( pv_no_cia,    Lv_Centro_distribucion, j.tipo_doc, j.periodo, 
                            j.ruta,         j.no_docu,              j.linea,    lindes.bodega, 
                            lindes.no_arti, j.no_lote,              j.unidades, 0, 
                            0 );
      End Loop; -- lotes de las lineas
    End Loop; -- fin del proceso de las  lineas
    
    /**** procesa para el caso de que un articulo viene en mas de una linea en la importacion ****/
    cont_art_inv_mas := 0;

    For LinDes in c_LineasDesalm_varios_arti (vno_docu, vtipo_doc) Loop
      
      Open C_Linea_arti (vno_docu, vtipo_doc, LinDes.no_arti);
      Fetch C_Linea_arti into Ln_linea;
      If C_Linea_arti%notfound Then
        --message('Error al recuperar linea de articulo '||lindes.no_arti);
        lv_error := 'Error al recuperar linea de articulo '||lindes.no_arti;
        Raise Error_Proceso;
        Close C_Linea_arti;
      else
        Close C_Linea_arti;
      end if;
      ---
      If rmc.grupo is null or rmc.grupo != lindes.grupo then
        ---
        rmc.grupo := null;
        open c_grupo_contable(pv_no_cia, lindes.grupo);
        fetch c_grupo_contable into rmc;
        close c_grupo_contable;
        ---
        If rmc.grupo is null then
          --message('ERROR: No existe el grupo contable: '||lindes.grupo);
          lv_error := 'ERROR: No existe el grupo contable: '||lindes.grupo;
          Raise Error_Proceso;
        End If;
        ---
      End If;
      
      --- Obtiene la cuenta contable GRUPO CONTABLE
      Open cta_invent(lindes.grupo,lindes.bodega) ;
      Fetch cta_invent into ctaInventario, vcc_inven;
      Close cta_invent;
      ---
      If Ctainventario is null then
        --message('No se ha definido la cuenta del grupo de inventario '||lindes.GRUPO||' para la bodega '||lindes.bodega);
        lv_error := 'No se ha definido la cuenta del grupo de inventario '||lindes.GRUPO||' para la bodega '||lindes.bodega;
        --message(' ', no_acknowledge);
        --synchronize;
        Raise Error_Proceso;
      End If;
      ---
      
      If vcc_inven is null Then
        --msg_aviso ('Defina un centro de costos para la cuenta contable de Inventarios. Grupo: '||lindes.grupo||' Bodega: '||lindes.bodega );
        lv_error := 'Defina un centro de costos para la cuenta contable de Inventarios. Grupo: '||lindes.grupo||' Bodega: '||lindes.bodega;
        raise Error_Proceso;
      end if;   
  
      mto_entra    := round(nvl(mto_entra,0) + nvl(lindes.total_lin,0),2);
      mto_2        := round(nvl(mto_2,0) + nvl(lindes.monto2,0),2);
      cont_art_inv_mas := cont_art_inv_mas + 1;
      contador   := contador + 1;
      ---    
      Open C_Arinma (lindes.bodega, lindes.no_arti);
      Fetch C_Arinma into Lv_dummy;
      If C_Arinma%notfound Then
      Close C_Arinma;
        --Msg_aviso('Artículo no existe en Bodega: '||lindes.bodega||' Artículo: '||lindes.no_arti);
        lv_error := 'Artículo no existe en Bodega: '||lindes.bodega||' Artículo: '||lindes.no_arti;
        Raise Error_Proceso;      
      else
        Close C_Arinma;
      end if;
      --
      Begin
        Insert Into arinml 
                  ( no_cia, centro,      tipo_doc,  periodo,
                    ruta,   no_docu,     linea,     linea_ext,
                    bodega, no_arti,     ind_iv,    unidades,
                    monto,  tipo_cambio, monto_dol, precio_venta,
                    monto2, monto2_dol,  time_stamp)
           Values ( pv_no_cia,             Lv_Centro_distribucion, vtipo_doc, to_char(anoproc),
                    '0000',                  vno_docu,               Ln_linea,  Ln_linea,
                    lindes.bodega,           lindes.no_arti,         'S',       lindes.cantidad,
                    nvl(lindes.total_lin,0), lindes.tipo_cambio,     nvl(lindes.total_lin,0)/lindes.tipo_cambio, nvl(lindes.pvp,0),
                    nvl(lindes.monto2,0),    nvl(lindes.monto2,0)/lindes.tipo_cambio, Ld_fecha);
      Exception
        When Others Then
        --msg_aviso('Error al crear la línea en Inventario. Bodega: '||lindes.bodega||' Artículo: '||lindes.no_arti||' '||SQLERRM);
        lv_error := 'Error al crear la línea en Inventario. Bodega: '||lindes.bodega||' Artículo: '||lindes.no_arti||' '||SQLERRM;
        Raise Error_Proceso;
      End;

      -- llindao: procedimiento que replica numeros de series por codigo de articulo.
      INACT_NUMEROS_SERIES ( pv_no_cia,
                             vno_docu,
                             Ln_linea,-- para agrupaciones de articulos se genera linea nueva.
                             lindes.no_arti,
                             msg_error_p);
                             
      If msg_error_p Is Not Null Then
        --message(msg_error_p);
        lv_error := msg_error_p;
        Raise Error_Proceso;
      End If;

      
      /*
      BEGIN
        INSERT INTO INV_DOCUMENTO_SERIE 
                  ( COMPANIA, ID_DOCUMENTO, LINEA,
                    SERIE,    USUARIO_CREA, FECHA_CREA)
             SELECT COMPANIA, NO_DOCUMENTO, Ln_linea,
                    SERIE,    USER,         SYSDATE
               FROM INV_PRE_INGRESO_NUMERO_SERIE
              WHERE NO_ARTICULO = lindes.no_arti
                AND NO_DOCUMENTO = vno_docu
                AND COMPANIA = pv_no_cia;
      EXCEPTION
        WHEN OTHERS THEN
          msg_aviso('Error al crear Números de Series. Bodega: '||lindes.bodega||' Artículo: '||lindes.no_arti||' '||SQLERRM);
          Raise Error_Proceso;
      END;
      */
      
      BEGIN   
        -- Inserta en ARINMN la línea que se esta procesando
        INinserta_mn( pv_no_cia,     Lv_Centro_distribucion, vtipo_doc ,
                      vno_docu,        to_char(anoproc),       mesproc,
                      semaproc,        indproc,                '0000',
                      Ln_linea,        lindes.bodega,          lindes.no_arti,  
                      diaproc,         lindes.cantidad,        lindes.TOTAL_LIN,
                      0,               null,                   null,
                      null,            lindes.TOTAL_LIN/lindes.cantidad, to_date(to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'),--- costo unitario
                      '000000000','N', lindes.pvp,             lindes.monto2,
                      lindes.monto2/lindes.cantidad); --- Va el costo2 ANR 09/02/2010
      Exception
        When Others Then
          --Msg_aviso('Error al crear la línea histórica en Inventario. Bodega: '||lindes.bodega||' Artículo: '||lindes.no_arti||' '||SQLERRM);
          lv_error := 'Error al crear la línea histórica en Inventario. Bodega: '||lindes.bodega||' Artículo: '||lindes.no_arti||' '||SQLERRM;
          Raise Error_Proceso;     
      END;

      /**** NOTA IMPORTANTE: El orden de los procedimientos siempre va a ser:
         INCOSTO_UNI (SI ES ENTRADA DE COMPRAS, ENTRADA REORDENAMIENTO, ENTRADA IMPORTACION)
         ACTUALIZAR STOCK ARTICULO (PARA TODOS LOS CASOS)
         INCOSTO_ACTUALIZA (PARA TODOS LOS CASOS)
         ANR 16/06/2010  
      ****/ 
      
      -- El costo unitario solamente se actualiza cuando se trata 
      -- de movimientos de entrada
      INcosto_Uni( pv_no_cia,
                   lindes.bodega,
                   lindes.no_arti,
                   lindes.cantidad,
                   round(lindes.total_lin/lindes.cantidad,6), 
                   round(lindes.monto2/lindes.cantidad,6),   
                   msg_error_p);     
     
  
      If msg_error_p Is Not Null Then
        --message('Errores en incosto_uni '||msg_error_p||' '||sqlerrm);
        lv_error := 'Errores en incosto_uni '||msg_error_p||' '||sqlerrm;
        Raise Error_Proceso;
      End If;

      -- Actualiza el monto de las compra en ARINMA (Maestro de artículos),
      -- el costo unitario del artículo y el último costo.
      UPDATE arinma
         SET comp_un    = nvl(comp_un,0)  + (lindes.cantidad),
             comp_mon   = nvl(comp_mon,0) + (lindes.total_lin),
             activo     = 'S',
             fec_u_comp = diaproc
       WHERE no_cia   = pv_no_cia
         AND bodega   = lindes.bodega
         AND no_arti  = lindes.no_arti;

      --- No debe actualizarse el costo unitario del articulo ANR 27/04/2009
      --- pero si debe actualizar el monto 2 y el saldo valuado para todas las bodegas
  
      INCOSTO_ACTUALIZA (pv_no_cia, lindes.no_arti);    

      -- Procesa lotes ANR 12/05/2009
      --
  
      For j in c_lotes(pv_no_cia, vtipo_doc, vno_docu, Ln_linea) LOOP
        
        --- Crea el registro en ARINMO
        INSERT INTO arinmo 
                  ( no_cia,    centro,  tipo_doc,    periodo, 
                    ruta,      no_docu, linea,       no_lote, 
                    unidades,  monto,   descuento_l, imp_ventas_l,
                    ubicacion, fecha_vence)
           Values ( pv_no_cia, Lv_Centro_distribucion, j.tipo_doc, j.periodo,
                    j.ruta,      j.no_docu,              j.linea,    j.no_lote,
                    j.unidades,  j.monto,                0,          0,
                    j.ubicacion, j.fecha_vence);

        UPDATE arinlo
           SET saldo_unidad   = nvl(saldo_unidad, 0) + (j.unidades ),
               saldo_contable = 0, --- En lotes solamente se llevan unidades ANR 12/05/2009
               saldo_monto    = 0
         WHERE no_cia    = pv_no_cia
           AND bodega    = lindes.bodega
           AND no_arti   = lindes.no_arti
           AND no_lote   = j.no_lote;
        --
        IF sql%rowcount = 0 THEN
          INSERT INTO arinlo
                    ( no_cia,         bodega,        no_arti, 
                      no_lote,        ubicacion,     saldo_unidad,
                      saldo_contable, saldo_monto,   salida_pend,
                      costo_lote,     proceso_toma,  exist_prep,
                      costo_prep,     fecha_entrada, fecha_vence,
                      fecha_fin_cuarentena)
              VALUES( pv_no_cia, lindes.bodega, lindes.no_arti, 
                      j.no_lote,   j.ubicacion,   j.unidades,
                      j.unidades,  0,             0,
                      0,           'N',           null,
                      null,        Ld_fecha,      j.fecha_vence,
                      null);
        END IF;
        --
        -- Inserta en ARINMT la linea que se esta procesando
        Insert Into arinmt
                  ( no_cia,  centro,   tipo_doc, ano, 
                    ruta,    no_docu,  no_linea, bodega, 
                    no_arti, no_lote,  unidades, venta,  
                    descuento)
           values ( pv_no_cia,    Lv_Centro_distribucion, j.tipo_doc, j.periodo, 
                    j.ruta,         j.no_docu,              j.linea,    lindes.bodega,
                    lindes.no_arti, j.no_lote,              j.unidades, 0, 
                    0);
      End Loop; -- lotes de las lineas
    End Loop; -- fin del proceso de las  lineas
    
    
    If (nvl(cont_art_inv,0) + nvl(cont_art_inv_mas,0)) = 0  then
      -- si no inserto ninguna linea de detalle en ARINML, borra el encabezado ingresado
      Delete arinme
       Where no_Cia  = pv_no_cia 
         And no_docu = vno_docu;
    Else 
      If pn_no_embarque = '000000000000' Then
        update Arinme
           set imp_ventas    = 0,
               mov_tot       = nvl(mto_entra,0),
               monto_bienes  = nvl(mto_entra,0), 
               monto_digitado_compra = nvl(mto_entra,0),
               mov_tot2    = nvl(mto_2,0)
         where no_cia   = pv_no_cia 
           And no_docu  = vno_docu;
                     
        Update arinmeh 
           set mov_tot  = nvl(mto_entra,0),
               mov_tot2 = nvl(mto_2,0)
         Where no_cia  = pv_no_cia 
           And no_docu = Vno_docu; 
      Else
        Update arinme
           set mov_tot                 = nvl(mto_entra,0), 
               monto_importac          = nvl(mto_entra,0), 
               monto_digitado_compra   = nvl(mto_entra,0),
               mov_tot2         = nvl(mto_2,0)
         WHERE no_Cia   = pv_no_cia 
           AND no_docu  = Vno_docu; 
                     
        Update arinmeh 
           set mov_tot  = nvl(mto_entra,0),
               mov_tot2 = nvl(mto_2,0)
         where no_Cia   = pv_no_cia 
           And no_docu  = Vno_docu; 
      End If;
      -----distribucion contable----
      
      -- inicializa variables con el centro de costo asociado al centro de distribucion.
      IF NOT cuenta_contable.acepta_cc(pv_no_cia, Ctainventario) THEN
        -- si la cuenta contable no acepta centro de costo, no se usa el del centro de
        -- distribucion sino el 000-000-000, caso contrario toma el que viene asignado
        vcc_inven  := centro_costo.rellenad(pv_no_cia, '0');
      END IF;
       
      If vcc_inven is null Then
        --msg_aviso ('Debe definir un centro de costos para la cuenta contable de inventario');
        lv_error := 'Debe definir un centro de costos para la cuenta contable de inventario';
        raise Error_Proceso;
      end if;
      
      
      -- Genera un debito a la cuenta de inventario
      INinserta_conta( pv_no_cia,      Lv_Centro_distribucion, vtipo_doc ,
                       vno_docu,         'D',                    Ctainventario,
                       nvl(mto_entra,0), vcc_inven,              nvl(mto_entra,0)/pn_tipo_cambio,
                       pn_tipo_cambio, null,                   anoproc,
                       mesproc, ln_error, lv_error
                       );    
      
      -- inicializa variables con el centro de costo asociado al centro de distribucion.
      IF NOT cuenta_contable.acepta_cc(pv_no_cia, CtaInvMercTran) THEN
        -- si la cuenta contable no acepta centro de costo, no se usa el del centro de
        -- distribucion sino el 000-000-000
        vcc_contrap  := centro_costo.rellenad(pv_no_cia, '0');
      ELSE
        vcc_contrap  := vcc_inven;
      END IF;
       
      If vcc_contrap is null Then
        --msg_aviso ('Debe definir un centro de costos para la cuenta contable de de mercadería en tránsito');
        lv_error := 'Debe definir un centro de costos para la cuenta contable de de mercadería en tránsito';
        raise Error_Proceso;
      end if;
        
      ---genera el credito a la cuenta de mercaderia en transito de importaciones
      INinserta_conta( pv_no_cia,       Lv_Centro_distribucion, vtipo_doc ,
                       vno_docu,          'C',                    CtaInvMercTran,
                       nvl(mto_entra,0),  vcc_contrap,            nvl(mto_entra,0)/pn_tipo_cambio,
                       pn_tipo_cambio,  null,                   anoproc,
                       mesproc, ln_error, lv_error);
           
       
      -- se hizo un nuevo proveso para generar el asiento de liquidación e importacion
      -- y sólo se genera en importaciones
      borra_actualiza_tablas(vno_docu, diaproc, nvl(mto_entra,0),pv_no_cia,pv_centro,pn_no_embarque,pn_no_docu,pn_tipo_cambio,pv_ind_antipo,pv_ind_costeo, ln_error, lv_error);
    
    /*
    PROCEDURE borra_actualiza_tablas(vno_docu                         in                  varchar2, 
                                 Ld_dia_proceso                   in                  date,
                                 Ln_monto                         in                  number,
                                 pv_no_cia                        in                  varchar2,
                                 pv_centro                        in                  varchar2,
                                 pn_no_embarque                   in                  number,
                                 pn_no_docu                       in                  number,
                                 pn_tipo_cambio                   in                  number,
                                 pv_ind_antipo                    in                  varchar2,
                                 pv_ind_costeo                    in                  varchar2) IS
    */
    
      Open C_Arindc (vno_docu);
      Fetch C_Arindc into Lv_dummy;
      If C_Arindc%notfound Then
        Close C_Arindc;
        --msg_aviso ('No se ha generado el asiento contable para el documento: '||vno_docu);
        lv_error := 'No se ha generado el asiento contable para el documento: '||vno_docu;
        Raise Error_Proceso; 
      else
        Close C_Arindc;
      end if;
     
      /*
      proceso_concluido('El Número de Transacción Generado en Inventario es '||vno_docu||' Número Físico: '||vfisico);

      --:System.message_level := 5;
      commit;
      --:System.message_level := 0;

      genera_reporte2('Rinv226.rep', true, 'S','NO_FISICO',vfisico, Null, Null); 
       
      ------------------------------------------------------------------------------
      ---AGREGADO PARA GENERAR TRANSFERENCIA DE DISTRIBUCION FISICA DE MERCADERIA---
      ------------------------------------------------------------------------------
      pu_crea_transf(lv_transf);
      
      IF lv_transf is not null THEN
        proceso_concluido('El Número de Transferencia Generado por Distribucion Fisica de Mercadera es '||Lv_transf);
 
        :System.message_level := 5;
        commit;
        :System.message_level := 0;
      END IF;
      */
    End If;
  End If; 
  commit;
Exception
  When Error_Proceso Then
    --CLEAR_FORM(NO_COMMIT, FULL_ROLLBACK);
    --Raise form_trigger_failure;
    rollback;
    pn_error := 999;
    pv_error := lv_package||'.'||lv_proceso||'::'||lv_error;
  When Others Then
    /*
    Message('Errores actualizando desalmacenaje '||SQLERRM);
    Message(' ', no_acknowledge);
    Synchronize;
    CLEAR_FORM(NO_COMMIT, FULL_ROLLBACK);
    Raise form_trigger_failure;
    */
    rollback;
    pn_error := 999;
    lv_error := 'Error General '||sqlerrm;
    pv_error := lv_package||'.'||lv_proceso||'::'||lv_error;
End; -- DE ACTUALIZA_DESALMACENAJE




FUNCTION IMmovimiento_valido (
    pcia         in varchar2,
    ptipo_doc    in varchar2,
    pno_docu     in varchar2,
    msg_error_p  in out varchar2
) RETURN BOOLEAN
IS
  -- ---
  -- Esta funcion se encarga de revisar que el movimiento especificado por los parametros, sea
  -- valido, es decir, que cumpla las siguientes caracteristicas :
  --  1. En los articulos que manejan lotes, las unidades del articulo sean igual a la
  --         sumatoria de las unidades de los lotes en que se desgloza.
  --  2. El número de conduce no sea nulo (para despachos y recepciones)
  --
  vdummy    varchar2(9);
  vfound    BOOLEAN;
  --
  CURSOR mov_invalidos IS
     SELECT ml.no_arti
     FROM arimDETDOC ML, arinda DA
     WHERE ML.no_cia    = pcia
       AND ML.no_docu   = pno_docu
       AND DA.no_cia    = ML.no_cia
       AND DA.no_arti   = ML.no_arti
       AND DA.ind_lote  = 'L'
       AND ML.unidades <> (SELECT NVL(SUM(unidades), 0)
                           FROM arimLoTES MO
                           WHERE MO.no_cia   = ML.no_cia   and
                                 MO.no_docu  = ML.no_docu  and
                                 MO.linea    = ML.linea  )
       AND ROWNUM < 2;   
    lv_proceso varchar2(200) := 'IMmovimiento_valido';   
BEGIN

  OPEN mov_invalidos;
  FETCH mov_invalidos INTO vdummy;
  vfound := mov_invalidos%found;
  CLOSE mov_invalidos;
  --
  IF vfound then
     msg_error_p := 'El Documento: '|| ptipo_doc||' No.Transa: '||pno_docu||
                    ', presenta inconsistencias en las unidades del artículo '||vdummy||' con el total de unidades en el desglose de sus lotes';
     RETURN(FALSE);
  else
     RETURN(TRUE);
  end if;
EXCEPTION
  when others then
    msg_error_p := lv_package||'.'||lv_proceso||'::ERROR en Proc. movimiento_valido: '||sqlerrm;
    RETURN (FALSE);
END;



PROCEDURE Imcrea_encabezado_h(pmes         in number,
                              psemana      in number,
                              pind_sem     in varchar2,
                              vno_docu     in varchar2,
                              vfisico      in varchar2,
                              vserie       in varchar2,
                              dia_proceso  in date,
                              pn_no_embarque  in number,
                              pv_no_cia       in varchar2,
                              pn_error  out     number,
                              pv_error  out     varchar2) Is
    lv_error         varchar2(2000); 
    lv_proceso varchar2(200) := 'Imcrea_encabezado_h';   
Begin
   -- Graba el documento en el histórico de encabezado de documento
   Insert into arinmeh(no_cia, centro, tipo_doc, periodo, ruta, no_docu,
                       fecha,
                       no_fisico, serie_fisico, conduce,
                       no_prove, tipo_refe, no_refe, serie_refe,
                       imp_ventas, descuento, mov_tot,
                       tot_art_iv, observ1, tipo_cambio, no_docu_refe,
                       mes, semana, ind_sem, origen)
                SELECT no_cia, centro, tipo_doc, periodo, ruta, vno_docu,
                       dia_proceso,--to_date(to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'),  FEM
                       vfisico, vserie, conduce,
                       no_prove, tipo_refe, no_refe, serie_refe,
                       imp_ventas, descuento, mov_tot,
                       tot_art_iv, substr(observ1||' COMPRA GENERADA POR AUX.IMPORTACIONES EMBARQUE No.-'||pn_no_embarque,1,400), tipo_cambio, no_docu_refe,
                       pmes, psemana, pind_sem, 'IM'
                  FROM arimencdoc
                 WHERE no_cia     = pv_no_cia  
                   AND no_docu    = vno_docu;

EXCEPTION
  WHEN others THEN
       --msg_aviso('Errores grabando encabezado historico '||sqlerrm);
       lv_error := lv_package||'.'||lv_proceso||'::Errores grabando encabezado historico '||sqlerrm;
       rollback;
       --RAISE form_trigger_failure;
                 
END;


procedure INinserta_conta(
  cia_p     in varchar2,
  cen_p     in varchar2,      -- centro
  tip_p     in varchar2,      -- tipo documento
  doc_p     in varchar2,      -- num. transacción
  mov_p     in varchar2,      -- tipo de movimiento contable
  pcta      in varchar2,      -- cuenta contable
  tot_p     in number,        -- monto
  cc        in varchar2,
  tot_d     in number,        -- monto en dolares
  tipo_c    in number,
  tercero_p in varchar2 ,      -- Código de tercero
  pano      in NUMBER  , 
  pmes      in NUMBER,
  pn_error  out     number,
  pv_error  out     varchar2
) is
   -- Este procedimiento se encarga de alimentar la tabla ARINDC.
   -- Si el registro existe actualiza el monto, sino, lo inserta en la tabla.
   lv_proceso varchar2(200) := 'INinserta_conta';
   lv_error         varchar2(2000); 
BEGIN

  IF nvl(tot_p,0) != 0 or nvl(tot_d,0) != 0 THEN
     update arindc
     set   monto       = nvl(monto, 0) + nvl(tot_p, 0),
           monto_dol   = nvl(monto_dol,0) + nvl(tot_d,0),
           tipo_cambio = nvl(tipo_c,0)
     where no_cia                   = cia_p
     and   no_docu                  = doc_p
     and   centro                   = cen_p
     and   tipo_doc                 = tip_p
     and   tipo_mov                 = mov_p
     and   cuenta                   = pcta
     and   centro_costo             = cc
     and   nvl(codigo_tercero, 'A') = nvl(tercero_p, 'A');  -- Cuando el código de tercero es nulo
     --
     if (sql%rowcount = 0) then
        insert into arindc (no_cia,    centro,      tipo_doc,       no_docu,
                        tipo_mov,  cuenta,      monto,          centro_costo,
              monto_dol, tipo_cambio, codigo_tercero,ind_gen,ANO,MES)
               values (
                       cia_p,        cen_p,  tip_p,        doc_p,
             mov_p,        pcta,   nvl(tot_p,0), cc,
             nvl(tot_d,0), tipo_c, tercero_p,'N',PANO,PMES);
     end if;
  END IF;
  pn_error := 0;
  pv_error := null;
  exception
    when others then
    --message('Error creando el asiento en el modulo de Inventario'||sqlerrm);
    pn_error := 999;
    lv_error  := lv_package||'.'||lv_proceso||'::Error creando el asiento en el modulo de Inventario'||sqlerrm;
    pv_error := lv_error;
    --raise form_trigger_failure;
END;



PROCEDURE borra_actualiza_tablas(vno_docu                         in                  varchar2, 
                                 Ld_dia_proceso                   in                  date,
                                 Ln_monto                         in                  number,
                                 pv_no_cia                        in                  varchar2,
                                 pv_centro                        in                  varchar2,
                                 pn_no_embarque                   in                  number,
                                 pn_no_docu                       in                  number,
                                 pn_tipo_cambio                   in                  number,
                                 pv_ind_antipo                    in                  varchar2,
                                 pv_ind_costeo                    in                  varchar2,
                                 pn_error  out     number,
                                 pv_error  out     varchar2) IS

CURSOR C_ORDEN IS
 SELECT * FROM  arimdetfacturas a
  where no_cia=pv_no_cia and
       ((a.no_cia,a.num_fac) in(select b.no_cia,b.num_fac from arimfaccalculo b
           where b.ser_prove='P' AND b.NO_EMBARQUE=pn_no_embarque
           and b.num_fac in
                        (select b.num_fac  --- dependiendo las facturas guardadas por proveedor, guarda el historico ANR 24/08/2010
                         from   arimencdoc a, arimencfacturas b
                         where  a.no_cia = pv_no_cia
                         and    a.centro = pv_centro
                         and    a.no_embarque = pn_no_embarque
                         and    a.no_docu = pn_no_docu
                         and    a.no_cia = b.no_cia
                         and    a.no_embarque = b.no_embarque
                         and    a.no_prove = b.cod_proveedor)));

   lv_error         varchar2(2000);
   lv_proceso varchar2(200) := 'borra_actualiza_tablas';
BEGIN
  --guarda historia de factura de productos ---
  insert into arimhiscalculo( NO_CIA ,        
   NO_EMBARQUE,  NUM_FAC,SER_PROVE,TIPO_CAMBIO ,FECHA )
   select no_cia,no_embarque,num_fac,ser_prove,pn_tipo_cambio,sysdate
   from arimfaccalculo 
   where no_cia=pv_no_cia and no_embarque=pn_no_embarque and ser_prove = 'P' and num_fac in
    (select b.num_fac  --- dependiendo las facturas guardadas por proveedor, guarda el historico ANR 24/08/2010
     from   arimencdoc a, arimencfacturas b
     where  a.no_cia = pv_no_cia
     and    a.centro = pv_centro
     and    a.no_embarque = pn_no_embarque
     and    a.no_docu = pn_no_docu
     and    a.no_cia = b.no_cia
     and    a.no_embarque = b.no_embarque
     and    a.no_prove = b.cod_proveedor);       

  --guarda historia de factura de servicios ---
  insert into arimhiscalculo( NO_CIA ,        
   NO_EMBARQUE,  NUM_FAC,SER_PROVE,TIPO_CAMBIO ,FECHA )
   select a.no_cia,a.no_embarque,a.num_fac,a.ser_prove,pn_tipo_cambio,sysdate
   from arimfaccalculo a 
   where a.no_cia=pv_no_cia and a.no_embarque=pn_no_embarque and a.ser_prove = 'S'
   and not Exists
   (Select 'X' 
    from arimhiscalculo m
    where  m.no_cia = a.no_cia
    and    m.no_embarque = a.no_embarque
    and    m.num_fac = a.num_fac
    and    m.ser_prove = 'S'); --- para que no se grabe repetido el registro
      
  ----borra el seguimiento de la consulta---

  
  update arimencsegui
     set estado              = 'A',
         ind_anticipo        = nvl(pv_ind_antipo,'N'),
         fecha_llega_bodega  = nvl(fecha_llega_bodega,sysdate),
         fecha_act_calculo   = Sysdate,
         fingreso_inventario = Ld_dia_proceso    --FEM 16-04-2009
   where no_cia      = pv_no_cia       
     and no_embarque = pn_no_embarque;
         
            
    update arimencfacturas a
       set estado      = 'L' --liquidada---
     where no_cia      = pv_no_cia 
       and estado      = 'A' 
       and no_embarque = pn_no_embarque 
       and num_fac in
            (select b.num_fac  --- dependiendo las facturas guardadas por proveedor, guarda el historico ANR 24/08/2010
             from   arimencdoc a, arimencfacturas b
             where  a.no_cia = pv_no_cia
             and    a.centro = pv_centro
             and    a.no_embarque = pn_no_embarque
             and    a.no_docu = pn_no_docu
             and    a.no_cia = b.no_cia
             and    a.no_embarque = b.no_embarque
             and    a.no_prove = b.cod_proveedor)      
       and exists( select sum(nvl(cant_desalm,0)),sum(nvl(cant_fact,0))
                     from arimdetfacturas b
                    where b.no_cia  = a.no_cia 
                      and b.num_fac = b.num_fac
    having sum(nvl(cant_desalm,0)) = sum(nvl(cant_fact,0))  
       and sum(nvl(cant_desalm,0)) >0 );         
           
           
   --antualiza la cantidad liquidada de las las lineas  de las facturas --          
 update arimdetfacturas a
    set cant_liquida = nvl(cant_liquida,0) + nvl(cant_desalm,0)
  where no_cia = pv_no_cia 
    and ((a.no_cia,a.num_fac) in (select b.no_cia,b.num_fac 
                                    from arimfaccalculo b
                                   where b.ser_prove  = 'P' 
                                     and b.no_embarque = pn_no_embarque
                                     and b.num_fac in
                                                (select b.num_fac  --- dependiendo las facturas guardadas por proveedor, guarda el historico ANR 24/08/2010
                                                 from   arimencdoc a, arimencfacturas b
                                                 where  a.no_cia = pv_no_cia
                                                 and    a.centro = pv_centro
                                                 and    a.no_embarque = pn_no_embarque
                                                 and    a.no_docu = pn_no_docu
                                                 and    a.no_cia = b.no_cia
                                                 and    a.no_embarque = b.no_embarque
                                                 and    a.no_prove = b.cod_proveedor)));
                    
 
 For I in C_orden Loop
  update ARIMDETORDEN
     Set CANT_ENTRO_INV = nvl(cant_entro_inv,0) + nvl(I.CANTIDAD_pedida,0)
   Where NO_ORDEN       = I.NO_ORDEN  
     And NO_ARTI        = I.NO_ARTI   
     And NO_CIA         = I.NO_CIA    
     And nvl(cantidad_pedida,0) > 0;
 End Loop;
 
    update arimfo a
       set estado = 'L'
     where no_cia = pv_no_cia 
       and estado = 'A' 
       and no_embarque = pn_no_embarque 
       and a.no_embarque not in (select c.no_embarque 
                                    from arimencfacturas c
                                    where c.no_cia = pv_no_cia 
                                      and c.estado = 'A') 
       and ((a.no_cia,a.num_faco) in (select b.no_cia,b.num_fac 
                                         from arimfaccalculo b
                                         where ser_prove='S'));
  
     --tablas temporales usadas en el calculo de mercaderìa--
     delete from arimlingasto a
     where no_cia=pv_no_cia and
           ((a.no_cia,a.num_fac) in(select b.no_cia,b.num_fac from arimfaccalculo b
           where b.ser_prove='S' AND b.NO_EMBARQUE=pn_no_embarque
                                               and b.num_fac in
                                                (select b.num_fac  --- dependiendo las facturas guardadas por proveedor, guarda el historico ANR 24/08/2010
                                                 from   arimencdoc a, arimencfacturas b
                                                 where  a.no_cia = pv_no_cia
                                                 and    a.centro = pv_centro
                                                 and    a.no_embarque = pn_no_embarque
                                                 and    a.no_docu = pn_no_docu
                                                 and    a.no_cia = b.no_cia
                                                 and    a.no_embarque = b.no_embarque
                                                 and    a.no_prove = b.cod_proveedor)));
           
           
     delete from arimprovegasto a
     where no_cia=pv_no_cia and
           ((a.no_cia,a.num_fac) in(select b.no_cia,b.num_fac from arimfaccalculo b
           where b.ser_prove='S' AND b.NO_EMBARQUE=pn_no_embarque
                                               and b.num_fac in
                                                (select b.num_fac  --- dependiendo las facturas guardadas por proveedor, guarda el historico ANR 24/08/2010
                                                 from   arimencdoc a, arimencfacturas b
                                                 where  a.no_cia = pv_no_cia
                                                 and    a.centro = pv_centro
                                                 and    a.no_embarque = pn_no_embarque
                                                 and    a.no_docu = pn_no_docu
                                                 and    a.no_cia = b.no_cia
                                                 and    a.no_embarque = b.no_embarque
                                                 and    a.no_prove = b.cod_proveedor))); 
           
     
     delete from arimimpcalculo
     where no_cia=pv_no_cia and no_embarque=pn_no_embarque ;
    
     update arimencdoc
        set estado='A'
       where no_cia=pv_no_cia and no_docu=vno_docu;

  --Se agrega este control paraq que en el caso de que sea costeo parcial,
  --se actualice la tabla arimencsegui con el monto, fecha y usuario que realiza la importacion 
  --parcial FEM 16-04-2009

    
  If nvl(pv_ind_costeo,'X') = 'P' then
    ---
    ---
    update arimencsegui
       set monto_parcial   = Ln_monto,
           fecha_parcial   = sysdate, 
           usuario_parcial = user,
           fcosteo         = sysdate --- Se guarda la fecha de costeo
     where no_cia      = pv_no_cia       
       and no_embarque = pn_no_embarque;
  else
    update arimencsegui
       set recosteo_completo = 'S',
           fcosteo           = sysdate --- Se guarda la fecha de costeo
     where no_cia      = pv_no_cia       
       and no_embarque = pn_no_embarque;
           
  End If;
     
 Exception
        WHEN OTHERS THEN
        --MESSAGE('ERRORES Borrando tablas de calculo'||sqlerrm);
        lv_error := 'ERRORES Borrando tablas de calculo'||sqlerrm;
        rollback;
        --raise form_trigger_failure; 
END;



end PKG_IMPORT_APRUEBA_TRAMITE;
/
