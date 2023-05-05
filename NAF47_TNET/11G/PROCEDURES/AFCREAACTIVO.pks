create or replace procedure            AFCREAACTIVO(Pv_cia       IN Varchar2,
                                         Pv_centro    IN Varchar2,
                                         Pv_solicitud IN Varchar2,
                                         Pv_linea     IN Varchar2,
                                         Pv_arti      IN Varchar2,
                                         Pv_serie     IN Varchar2,
                                         Pn_costo     IN Number,
                                         Pv_acti      OUT Varchar2,
                                         Pv_error     OUT Varchar2) is


/**** Procedimiento usado para la creacion del activo fijo
      Recupera parametros en base a la solicitud de requisiciones de inventarios
      Para el valor original ingresa al costo del inventario
      ANR 26/11/2010 ***/

Cursor C_Arafma (Lv_tipo Varchar2, Lv_grupo Varchar2, Lv_subgrupo Varchar2) Is
 select no_acti
 from arafma
 where no_cia = Pv_cia
 and serie = Pv_serie
 and tipo = Lv_tipo
 and grupo = Lv_grupo
 and subgrupo = Lv_subgrupo
 and no_arti = Pv_arti;


Cursor C_Arincd Is
  select dia_proceso
  from   arincd
  where  no_cia = Pv_cia
  and    centro = Pv_centro;

--- Recupero los datos del articulo

Cursor C_Articulo Is
 select descripcion, modelo
 from   arinda
 where  no_cia = Pv_cia
 and    no_arti = Pv_arti;

--- Recupero datos de la solicitud de requisicion
Cursor C_Solic_requisicion Is
 select no_cia_responsable, usuario_aprobacion, fecha, a.centro_costo
 from   inv_cab_solicitud_requisicion a
 where  no_cia = Pv_cia
 and    centro = Pv_centro
 and    numero_solicitud = Pv_solicitud;

Cursor C_solic_inv_act Is
 select tipo, grupo, subgrupo, marca
 from   INV_SOLICREQUI_ARTI_ACTI
 where  no_cia = Pv_cia
 and    centro = Pv_centro
 and    numero_solicitud = Pv_solicitud
 and    numero_linea = Pv_linea
 and    no_arti = Pv_arti
 and    serie = Pv_serie;

--- Recupero datos del empleado

Cursor C_Empleado (Cv_NoCia Varchar2, Cv_NoEmple Varchar2) Is
 select area, depto--, centro_costo
 from   arplme
 where  no_cia = Cv_NoCia
 and    no_emple = Cv_NoEmple;

--- Recupero los datos de una orden de compra
--- esta informacion es una referencia
Cursor C_Compra Is
  select a.no_fisico, a.serie_fisico, a.no_prove, a.orden_compra,  a.no_docu
  from   arinme a, arinvtm b, arinml c
  where  a.no_cia = Pv_cia
  and    a.centro   = Pv_centro
  and    b.movimi = 'E'
  and    b.compra = 'S'
  and    c.no_arti = Pv_arti
  and    a.no_cia = b.no_cia
  and    a.tipo_doc = b.tipo_m
  and    a.no_cia = c.no_cia
  and    a.no_docu = c.no_docu;

 Cursor C_Proveedor (Lv_prove Varchar2) Is
  select nombre
  from   arcpmp
  where  no_cia = Pv_cia
  and    no_prove   = Lv_prove;

--- Datos de tipo de activo
Cursor C_tipo_activo (Lv_tipo Varchar2) Is
 select ctavo, ctadavo, ctagavo
 from   arafmt
 where  no_cia = Pv_cia
 and    tipo = Lv_tipo;

--- Anio y mes de proceso de activos fijos
   Cursor C_Mes_Anio_Af Is
    SELECT ANO, MES
       FROM ARAFMC
      WHERE NO_CIA = Pv_cia;

  Lv_acti         Arafma.no_acti%type;
  Lv_desc_activo  Arafma.descri%type;

  Lv_desc         Arinda.descripcion%type;
  Lv_modelo       Arinda.modelo%type;

  Lv_NoEmpResp    Arplme.no_emple%type;
  Lv_NoCiaResp    Arplme.no_cia%type;
  Lv_area         Arplme.area%type;
  Lv_depto        Arplme.depto%type;
  Lv_centro_costo Arplme.centro_costo%type;

  Lv_fisico       Arinme.no_fisico%type;
  Lv_serie_fisico Arinme.serie_fisico%type;
  Lv_prove        Arinme.no_prove%type;
  Lv_oc           Arinme.orden_compra%type;
  Lv_docu         Arinme.no_docu%type;

  Lv_desc_prove   Arcpmp.nombre%type;

  Lv_ctavo        Arcgms.cuenta%type;
  Lv_ctadavo      Arcgms.cuenta%type;
  Lv_ctagavo      Arcgms.cuenta%type;

  Lv_tipo         Arafma.tipo%type;
  Lv_grupo        Arafma.grupo%type;
  Lv_subgrupo     Arafma.subgrupo%type;
  Ln_marca        Arafma.cod_marca%type;

  Ld_fecha        date;

  Ld_dia_proce    Arincd.dia_proceso%type;

  Ln_ano_af       Arafmc.ano%type;
  Ln_mes_af       Arafmc.mes%type;

  Lv_docu_activo  Arafmm.no_docu%type;

  Lv_error        Varchar2(500);
  Error_proceso   Exception;

begin

  Open C_Arincd;
  fetch C_Arincd into Ld_dia_proce;
  If C_Arincd%notfound Then
   Close C_Arincd;
    Lv_error := 'No existe el centro de distribucion: '||Pv_centro;
    raise error_proceso;
  else
   Close C_Arincd;
  end if;

Open C_Articulo;
Fetch C_Articulo into Lv_desc, Lv_modelo;
If C_Articulo%notfound then
  Close C_Articulo;
  Lv_error := 'No existe el articulo: '||Pv_arti;
  raise error_proceso;
else
  Close C_Articulo;
end if;

Lv_desc_activo := Lv_desc;

Open C_Solic_requisicion;
Fetch C_Solic_requisicion  into Lv_NoCiaResp, Lv_NoEmpResp, Ld_fecha, Lv_centro_costo;
If C_Solic_requisicion %notfound then
 Close C_Solic_requisicion ;
  Lv_error := 'No existe solicitud: '||Pv_solicitud;
  raise error_proceso;
else
 Close C_Solic_requisicion ;
end if;

If Lv_NoEmpResp is null then
  Lv_error := 'En la solicitud: '||Pv_solicitud||' no existe el responsable';
  raise error_proceso;
end if;

Open C_Empleado (Lv_NoCiaResp, Lv_NoEmpResp);
Fetch C_Empleado into Lv_area, Lv_depto;--, Lv_centro_costo;
--If C_Empleado%notfound then
 Close C_Empleado;
--  Lv_error := 'Empleado encargado no existe: '||Lv_emple;
--  raise error_proceso;
--else
-- Close C_Empleado;
--end if;

Open C_Compra;
Fetch C_Compra into Lv_fisico, Lv_serie_fisico, Lv_prove, Lv_oc, Lv_docu;
If C_Compra%notfound then
 Close C_Compra;
else
 Close C_Compra;
end if;

If Lv_prove is not null Then

  Open C_Proveedor (Lv_prove);
  Fetch C_Proveedor into Lv_desc_prove;
  If C_Proveedor%notfound then
   Close C_Proveedor;
  else
   Close C_Proveedor;
  end if;

end if;

  Open C_solic_inv_act;
  Fetch C_solic_inv_act into Lv_tipo, Lv_grupo, Lv_subgrupo, Ln_marca;
  If C_solic_inv_act%notfound Then
   Close C_solic_inv_act;
      Lv_error := 'No existe detalle. Solicitud: '||Pv_solicitud||' linea: '||Pv_linea||' Articulo: '||Pv_arti||' serie: '||Pv_serie;
      raise error_proceso;
  else
   Close C_solic_inv_act;
  end if;

  If Lv_tipo is not null Then

    Open C_tipo_activo (Lv_tipo);
    Fetch C_tipo_activo into Lv_ctavo, Lv_ctadavo, Lv_ctagavo;
    If C_tipo_activo%notfound Then
     Close C_tipo_activo;
      Lv_error := 'El tipo de activo es obligatorio';
      raise error_proceso;
    else
     Close C_tipo_activo;
    end if;

  end if;

Open C_Arafma (Lv_tipo, Lv_grupo, Lv_subgrupo);
Fetch C_Arafma into Lv_acti;
If C_Arafma%notfound Then
  Close C_Arafma; --- si no existe el activo con las mismas caracteristicas lo crea

  --- Crea la secuencia

   begin
    select  SECUENCIA into Lv_acti
      from ARAFMC
         where NO_CIA = Pv_cia;
   exception
   when no_data_found then
     Lv_error := 'No existe secuencia para activo';
     raise error_proceso;
   when others then
     Lv_error := 'Error al crear secuencia: '||sqlerrm;
     raise error_proceso;
   end;

     update  ARAFMC
     set secuencia = Lv_acti + 1
     where no_cia = Pv_cia;


--- Crea el registro del activo fijo
Begin
Insert into ARAFMA (no_cia, no_acti, descri, descri1, area, no_depa,
                    no_emple, serie, modelo, tipo, grupo, subgrupo,
                    f_ingre, duracion, no_prove, proveedor,
                    no_fisico, serie_fisico, no_refe, ord_comp,
                    f_depre, desecho, ctavo, ctadavo, ctagavo,
                    centro_costo, fecha_cambio, tipo_cambio, t_camb_c_v,
                    indice, metodo_dep, fecha_inicio_dep, vida_util_residual,
                    val_original, mejoras,
                    depacum_valorig_ant, depacum_mejoras_ant, depacum_revtecs_ant,
                    depacum_valorig, depacum_mejoras, depacum_revtecs,
                    depre_ejer_vo_ant, depre_ejer_vo, depre_ejer_mej_ant,
                    depre_ejer_mej, depre_ejer_revtec_ant, depre_ejer_revtec,
                    val_original_dol, depacum_valorig_ant_dol, depacum_mejoras_ant_dol,
                    depacum_revtecs_ant_dol, depacum_valorig_dol, depacum_mejoras_dol,
                    depacum_revtecs_dol, depre_ejer_vo_ant_dol, depre_ejer_vo_dol,
                    depre_ejer_mej_ant_dol, depre_ejer_mej_dol,
                    depre_ejer_revtec_ant_dol, depre_ejer_revtec_dol,
                    ult_ano_cierre, ult_mes_cierre, estado, cod_barra, cod_etiqueta,
                    tipo_adquisicion, cod_int_activo, cod_marca, depacum_vo_inicial,
                    no_arti, No_Cia_Custodio)
           Values   (Pv_cia, Lv_acti, Lv_desc_activo, Lv_desc, substr(Lv_area,1,2), substr(Lv_depto,1,5),
                     Lv_NoEmpResp, Pv_serie, Lv_modelo, Lv_tipo, Lv_grupo, Lv_subgrupo,
                     Ld_fecha, 0,lv_prove, Lv_desc_prove,
                     Lv_fisico, Lv_serie_fisico, Lv_docu, Lv_oc,
                     Ld_dia_proce, 0, Lv_ctavo, Lv_ctadavo, Lv_ctagavo,
                     Lv_centro_costo, trunc(sysdate), 1, 'C',
                     1, 'L', add_months(trunc(sysdate),1), --- siempre es un mes despues que inicia a depreciarse
                     null,
                     Pn_costo, 0,
                     0, 0, 0,
                     0, 0, 0,
                     0, 0, 0,
                     0, 0, 0,
                     0, 0, 0,
                     0, 0, 0,
                     0, 0, 0,
                     0, 0,
                     0, 0,
                     null, null, 'B', Pv_cia||'-'||Lv_tipo||'-'||Lv_grupo
                                      ||'-'||Lv_subgrupo||'-'||Lv_acti
                                      ||'-'||substr(Lv_centro_costo,4,6),null,
                     'C', Pv_cia||'-'||Lv_tipo||'-'||Lv_grupo
                          ||'-'||Lv_subgrupo||'-'||Lv_acti
                          ||'-'||substr(Lv_centro_costo,4,6), Ln_marca, 0, Pv_arti, Lv_NoCiaResp);
Exception
When others then
      Lv_error := Lv_centro_costo||'-'||'Error al crear activo. Articulo: '||Pv_arti||' Serie: '||Pv_serie||' Solicitud: '||Pv_solicitud||' Linea: '||Pv_linea||' '||sqlerrm;
      raise error_proceso;
End;
--- Actualiza el codigo de activo fijo en la tabla de control de requisiciones
Begin
 Update INV_SOLICREQUI_ARTI_ACTI
 set    no_acti = Lv_acti
 where  no_cia = Pv_cia
 and    centro = Pv_centro
 and    numero_solicitud = Pv_solicitud
 and    numero_linea = Pv_linea
 and    no_arti = Pv_arti
 and    serie = Pv_serie;
Exception
When others then
      Lv_error := 'Error al actualizar solicitud articulo - activo. Articulo: '||Pv_arti||' Serie: '||Pv_serie||' Solicitud: '||Pv_solicitud||' Linea: '||Pv_linea||' '||sqlerrm;
      raise error_proceso;
End;

---- Crea el registro de transaccion por adquisicion de activo fijo

    Lv_docu_activo := transa_id.af(Pv_cia);

    Open C_Mes_Anio_Af;
    Fetch C_Mes_Anio_Af into Ln_ano_af, Ln_mes_af;
    If C_Mes_Anio_Af%notfound Then
    Close C_Mes_Anio_Af;
      Lv_error := 'No existe registre de compa?ia en activos fijos';
      raise error_proceso;
    else
    Close C_Mes_Anio_Af;
    end if;

    BEGIN
    INSERT INTO ARAFMM( no_cia,
                        no_docu,
                        no_acti,
                        fecha,
                        hora,
                        tipo_m,
                        area_a,
                        no_depa_a,
                        no_empl_a,
                        monto,
                        estado,
                        cc_act,
                        tipo_cambio,
                        ano,
                        mes           )
     VALUES(            Pv_cia,
                        Lv_docu_activo,
                        Lv_acti,
                        Ld_fecha,
                        TO_NUMBER(TO_CHAR(sysdate,'HH24MI')),
                        'A',
                         substr(Lv_area,1,2),
                         substr(Lv_depto,1,5),
                        Lv_NoEmpResp,
                        Pn_costo,'P',
                        Lv_centro_costo,
                        1,
                        Ln_ano_af,
                        Ln_mes_af);
 EXCEPTION
 WHEN OTHERS THEN
      Lv_error := 'Error al crear transaccion de ingreso para activo fijo: '||lv_acti||' '||sqlerrm;
      raise error_proceso;
 END;


else
  Close C_Arafma;
end if;

Pv_acti := Lv_acti; --- Recupera el codigo de activo fijo


EXCEPTION
  WHEN error_proceso THEN
     pv_error:= Lv_error;
     ROLLBACK;
     RETURN;

  WHEN OTHERS THEN
     pv_error := 'AFCREAACTIVO :'||sqlerrm;
     ROLLBACK;
     RETURN;

end AFCREAACTIVO;