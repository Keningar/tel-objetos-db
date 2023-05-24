CREATE OR REPLACE package NAF47_TNET.PLLIQUIDACION_EMP is

  -- Author  : Antonio Navarrete Ricaurte
  -- Created : 7/6/2010 4:34:56 PM
  -- Purpose :

  /*** El paquete sirve para hacer liquidaciones para empleados para rubros como:
       decimo tercero, decimo cuarto, vacaciones ***/

  /*** Recupera valor de ingresos historicos, provisiones, provisiones pagadas (adelanto de provisiones), para rubros
       como decimo tercero, decimo cuarto ***/

   PROCEDURE RUBROS_MES_ANIO   (pno_cia     in  arplme.no_cia%type,
                                pmes        in number,
                                panio       in number,
                                pno_emple   in  arplme.no_emple%type,
                                pparametro  in  Varchar2,
                                ptipo       in  Varchar2,
                                pmonto_hist out Number,
                                pmonto_prov out Number,
                                pmonto_pag  out Number,
                                pmonto_neto out Number);

  /*** Recupera valor de ingresos historicos, provisiones, provisiones pagadas (adelanto de vacaciones), para rubros
       como vacaciones ***/

   PROCEDURE RUBROS_MES_ANIO_VAC   (pno_cia      in  arplme.no_cia%type,
                                    pmes_ini     in number,
                                    panio_ini    in number,
                                    pmes_fin     in number,
                                    panio_fin    in number,
                                    pno_emple    in  arplme.no_emple%type,
                                    ptipo       in  Varchar2,
                                    pmonto_hist out Number,
                                    pmonto_prov  out Number,
                                    pmonto_pag   out Number,
                                    pmonto_neto  out Number);

  /*** Calcula el valor percibido en el ultimo mes de trabajo ***/

  PROCEDURE INGRESOS_MES (pno_cia    in  arplme.no_cia%type,
                          pcantidad  in  Number,
                          ptipo_emp  in  Varchar2,
                          pn_salbas  in  Number,
                          pmonto     out Number);



end PLLIQUIDACION_EMP;
/

CREATE OR REPLACE package body NAF47_TNET.PLLIQUIDACION_EMP is

  /*** El paquete sirve para hacer liquidaciones para empleados para rubros como:
       decimo tercero, decimo cuarto, vacaciones ***/


   PROCEDURE RUBROS_MES_ANIO   (pno_cia     in  arplme.no_cia%type,
                                pmes        in number,
                                panio       in number,
                                pno_emple   in  arplme.no_emple%type,
                                pparametro  in  Varchar2,
                                ptipo       in  Varchar2,
                                pmonto_hist out Number,
                                pmonto_prov out Number,
                                pmonto_pag  out Number,
                                pmonto_neto out Number) IS

      --- Cursor para ingresos

      CURSOR  C_Sum_Ing_Hist IS
         SELECT  nvl(SUM(NVL(h.monto,0)),0) total
           FROM  ARPLHS h, arplcp x, arplme y
          WHERE  h.no_cia         = pno_cia
            and  h.no_emple       = pno_emple
            and  h.tipo_m         = 'I'
            and  h.cod_pla        IN (select dato_caracter
                                      from   arplpgd
                                      where  grupo_parametro = 'LIQ_EMP'
                                      and    parametro_id IN ('NP','NPQ'))--- planilla de pagos
            and  h.codigo         IN (select no_ingre
                                      from arplgid
                                      where  no_cia = pno_cia
                                      and    grupo_ing IN
                                      (select dato_caracter
                                       from   arplpgd
                                       where  grupo_parametro = 'LIQ_EMP'
                                       and    parametro_id = 'GI')) --- grupo de ingresos

            and  h.ano      = panio
            and  h.mes      = pmes
            and  h.no_cia   = x.no_cia
            and  h.cod_pla  = x.codpla
            and  x.no_cia   = y.no_cia
            and  x.tipo_emp = y.tipo_emp
            and  h.no_cia   = y.no_cia
            and  h.no_emple = y.no_emple;

    ---- Cursores para decimo tercero

      CURSOR  C_Sum_Prov_13 IS
         SELECT  nvl(SUM(NVL(h.monto,0)),0) total
           FROM  ARPLHS h
          WHERE  h.no_cia         = pno_cia
            and  h.no_emple       = pno_emple
            and  h.tipo_m         = 'D'
            and  h.codigo        IN (select rubro_13  --- provision decimo tercero
                                      from   arplpar
                                      where  no_cia = pno_cia)
            and  h.ano   = panio
            and  h.mes   = pmes;


      CURSOR  C_Sum_Ant_Pag_13 IS
         SELECT  nvl(SUM(NVL(h.monto,0)),0) total
           FROM  ARPLHS h
          WHERE  h.no_cia         = pno_cia
            and  h.no_emple       = pno_emple
            and  h.tipo_m        = 'I'
            and  h.codigo        IN  (select dato_caracter   --- pagos anticipados (13ro)
                                     from   arplpgd
                                     where  grupo_parametro = 'LIQ_EMP'
                                     and    parametro_id = 'A3')
            and  h.ano   = panio
            and  h.mes   = pmes;

      --- Cursores para decimo cuarto

      CURSOR  C_Sum_Prov_14 IS
         SELECT  nvl(SUM(NVL(h.monto,0)),0) total
           FROM  ARPLHS h
          WHERE  h.no_cia         = pno_cia
            and  h.no_emple       = pno_emple
             and  h.tipo_m        = 'D'
            and  h.codigo        IN (select rubro_14 --- provision decimo cuarto
                                      from  arplpar
                                      where no_cia = pno_cia)
            AND H.PROVIS_PAGADA = 'N'
            and  h.ano   = panio
            and  h.mes   = pmes;

      CURSOR  C_Sum_Ant_Pag_14 IS
         SELECT  nvl(SUM(NVL(h.monto,0)),0) total
           FROM  ARPLHS h
          WHERE  h.no_cia         = pno_cia
            and  h.no_emple       = pno_emple
            and  h.tipo_m        = 'I'
            and  h.codigo        IN (select dato_caracter   --- pagos anticipados (14to)
                                     from   arplpgd
                                     where  grupo_parametro = 'LIQ_EMP'
                                     and    parametro_id = 'A4')
            AND H.PROVIS_PAGADA = 'N'
            and  h.ano   = panio
            and  h.mes   = pmes;

      ---- Cursores para impuesto a la renta

    CURSOR  C_Sum_GrupoIng_Imprenta IS
       SELECT nvl(SUM(NVL(i.monto,0)),0) total
       FROM arplhs i, arplgid gi
       WHERE i.no_cia   = pno_cia
         AND i.no_emple = pno_emple
         AND i.tipo_m   = 'I'
         AND i.ano      = panio
         AND i.mes      = pmes
         AND i.no_cia   = gi.no_cia
         AND i.codigo   = gi.no_ingre
         AND gi.grupo_ing IN
         (select b.grupo_ing --- grupo de ingresos para impuesto a la renta
          from   arplpar a, arplmd b
          where  a.no_cia = pno_cia
          and    a.no_cia = b.no_cia
          and    a.cod_impsal = b.no_dedu); --- impuesto a la renta

      CURSOR  C_Sum_Prov_Imprenta IS
         SELECT  nvl(SUM(NVL(h.monto,0)),0) total
           FROM  ARPLHS h
          WHERE  h.no_cia         = pno_cia
            and  h.no_emple       = pno_emple
             and  h.tipo_m        = 'D'
            and  h.codigo        IN (select cod_impsal --- provision impuesto a la renta
                                     from   arplpar
                                     where  no_cia = pno_cia
                                      UNION
                                     select cod_ade_impsal
                                     from   arplpar
                                     where  no_cia = pno_cia)
            and  h.ano   = panio
            and  h.mes   = pmes;


      n_valor_hist    number := 0;
      n_valor_prov    number := 0;
      n_valor_pag_ant number := 0;
      n_valor_rec     number := 0;

   BEGIN

     If pparametro = '13' Then

        open C_Sum_Ing_Hist;
        fetch C_Sum_Ing_Hist into n_valor_hist;
        close C_Sum_Ing_Hist;

        open C_Sum_Prov_13;
        fetch C_Sum_Prov_13 into n_valor_prov;
        close C_Sum_Prov_13;

        open C_Sum_Ant_Pag_13;
        fetch C_Sum_Ant_Pag_13 into n_valor_pag_ant;
        close C_Sum_Ant_Pag_13;

        --- Si es tipo provision es valor de provision menos valor pagado de provision
        If ptipo = 'P' then
           n_valor_rec := n_valor_prov ; --- ANR 02/12/2010
        elsif ptipo = 'H' then
        --- Si es tipo de ingreso historico es ingreso historico menos valor pagado de provision
           n_valor_rec := n_valor_hist;--- ANR 02/12/2010
        end if;

        pmonto_hist := n_valor_hist;
        pmonto_prov := n_valor_prov;
        pmonto_pag  := n_valor_pag_ant;
        pmonto_neto := n_valor_rec;

     elsif pparametro = '14' Then

        open C_Sum_Prov_14;
        fetch C_Sum_Prov_14 into n_valor_prov;
        close C_Sum_Prov_14;

        open C_Sum_Ant_Pag_14;
        fetch C_Sum_Ant_Pag_14 into n_valor_pag_ant;
        close C_Sum_Ant_Pag_14;

        --- Decimo cuarto solo se genera en base a las provisiones
        n_valor_rec := n_valor_prov;

        pmonto_hist := n_valor_hist;
        pmonto_prov := n_valor_prov;
        pmonto_pag  :=  n_valor_pag_ant;
        pmonto_neto := n_valor_rec;

      elsif pparametro = 'IR' Then --- Impuesto a la renta

        open C_Sum_GrupoIng_Imprenta;
        fetch C_Sum_GrupoIng_Imprenta into n_valor_hist;
        close C_Sum_GrupoIng_Imprenta;

        open C_Sum_Prov_Imprenta;
        fetch C_Sum_Prov_Imprenta into n_valor_prov;
        close C_Sum_Prov_Imprenta;

        pmonto_hist := n_valor_hist;
        pmonto_prov := n_valor_prov;
        pmonto_pag  := 0;
        pmonto_neto := 0;


      end if;


   END;

   PROCEDURE RUBROS_MES_ANIO_VAC   (pno_cia      in  arplme.no_cia%type,
                                    pmes_ini     in number,
                                    panio_ini    in number,
                                    pmes_fin     in number,
                                    panio_fin    in number,
                                    pno_emple    in  arplme.no_emple%type,
                                    ptipo       in  Varchar2,
                                    pmonto_hist out Number,
                                    pmonto_prov  out Number,
                                    pmonto_pag   out Number,
                                    pmonto_neto  out Number) IS

      --- Vacaciones periodos son por anio

      CURSOR  C_Sum_Ing_Hist IS
         SELECT  nvl(SUM(NVL(h.monto,0)),0) total
           FROM  ARPLHS h
          WHERE  h.no_cia         = pno_cia
            and  h.no_emple       = pno_emple
            and  h.tipo_m         = 'I'
            and  h.cod_pla        IN (select dato_caracter
                                     from   arplpgd
                                     where  grupo_parametro = 'LIQ_EMP'
                                     and    parametro_id IN ('NP','NPQ')) -- nomina de pagos
            and  h.codigo         IN (select no_ingre
                                      from arplgid
                                      where  no_cia = pno_cia
                                      and    grupo_ing IN
                                      (select dato_caracter
                                       from   arplpgd
                                       where  grupo_parametro = 'LIQ_EMP'
                                       and    parametro_id = 'GI')) --- grupo de ingresos
            and  h.ano*100+h.mes between panio_ini*100+pmes_ini and panio_fin*100+pmes_fin;



      CURSOR  C_Sum_Prov_Vac IS
         SELECT  nvl(SUM(NVL(h.monto,0)),0) total
           FROM  ARPLHS h
          WHERE  h.no_cia         = pno_cia
            and  h.no_emple       = pno_emple
             and  h.tipo_m        = 'D'
            and  h.codigo        IN (select cod_provi_vac -- provision para vacaciones
                                     from   arplpar
                                     where  no_cia = pno_cia)
            and  h.ano*100+h.mes between panio_ini*100+pmes_ini and panio_fin*100+pmes_fin;

      CURSOR  C_Sum_Pag_Vac IS
         SELECT  nvl(SUM(NVL(h.monto,0)),0) total
           FROM  ARPLHS h
          WHERE  h.no_cia         = pno_cia
            and  h.no_emple       = pno_emple
             and  h.tipo_m        = 'I'
            and  h.codigo        IN (select rubro_vac -- rubro de ingreso o pago de vacaciones
                                     from   arplpar
                                     where  no_cia = pno_cia)
            and  h.ano*100+h.mes between panio_ini*100+pmes_ini and panio_fin*100+pmes_fin;

      CURSOR  C_Sum_Ant_Pag_Vac IS
         SELECT  nvl(SUM(NVL(h.monto,0)),0) total
           FROM  ARPLHS h
          WHERE  h.no_cia         = pno_cia
            and  h.no_emple       = pno_emple
            and  h.tipo_m        = 'I'
            and  h.codigo        IN (select dato_caracter   --- pagos anticipados (vacaciones)
                                     from   arplpgd
                                     where  grupo_parametro = 'LIQ_EMP'
                                     and    parametro_id = 'AV')
            and  h.ano*100+h.mes between panio_ini*100+pmes_ini and panio_fin*100+pmes_fin;


      n_valor_hist    number := 0;
      n_valor_prov    number:= 0;
      n_valor_pag     number:= 0;
      n_valor_pag_ant number := 0;
      n_valor_rec     number:= 0;

   BEGIN

        open C_Sum_Ing_Hist;
        fetch C_Sum_Ing_Hist into n_valor_hist;
        close C_Sum_Ing_Hist;

        open C_Sum_Prov_Vac;
        fetch C_Sum_Prov_Vac into n_valor_prov;
        close C_Sum_Prov_Vac;

        open C_Sum_Pag_Vac;
        fetch C_Sum_Pag_Vac into n_valor_pag;
        close C_Sum_Pag_Vac;

        open C_Sum_Ant_Pag_Vac;
        fetch C_Sum_Ant_Pag_Vac into n_valor_pag_ant;
        close C_Sum_Ant_Pag_Vac;

        If ptipo = 'P' then
        --- Si es en base a la provision es el valor de provision menos el valor pagado de provision de vacaciones
           n_valor_rec := n_valor_prov - n_valor_pag - n_valor_pag_ant;
        elsif ptipo = 'H' then
        --- Si es en base a los valores historicos es el valor historico menos el valor pagado de provisiones
          n_valor_rec := n_valor_hist - n_valor_pag - n_valor_pag_ant;
        end if;

        pmonto_hist := n_valor_hist;
        pmonto_prov := n_valor_prov;
        pmonto_pag  := n_valor_pag + n_valor_pag_ant;
        pmonto_neto := n_valor_rec;



   END;

   PROCEDURE INGRESOS_MES (pno_cia    in  arplme.no_cia%type,
                           pcantidad  in  Number,
                           ptipo_emp  in  Varchar2,
                           pn_salbas  in  Number,
                           pmonto     out Number) IS

    Cursor C_Tipo_empleado Is
        select dias_trab
        from   arplte
        where  no_cia = pno_cia
        and    tipo_emp = ptipo_emp;

      Ln_dias_mes  number:=0;

   BEGIN

  	Open C_Tipo_empleado;
  	Fetch C_Tipo_empleado into Ln_dias_mes;
  	If C_Tipo_empleado%notfound Then
  		Close C_Tipo_empleado;
      Ln_dias_mes := 0;
  	else
  		Close C_Tipo_empleado;
  	end if;

    --- Valor calculado del sueldo en base a los ultimos dias laborados

  	If Ln_dias_mes > 0 Then
         pmonto := pcantidad * (pn_salbas/Ln_dias_mes);
    else
        pmonto := 0;
  	end if;

   END;

end PLLIQUIDACION_EMP;
/
