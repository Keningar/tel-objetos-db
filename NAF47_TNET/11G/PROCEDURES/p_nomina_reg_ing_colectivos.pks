create or replace procedure p_nomina_reg_ing_colectivos( pv_no_cia              arplicp.no_cia%type,
                                                         pv_cod_pla             arplicp.cod_pla%type,
                                                         pv_ultima_planilla     varchar2,
                                                         pv_cod_h_extras        arplicp.no_ingre%type,
                                                         pv_cod_h_noct        arplicp.no_ingre%type,
                                                         pv_cod_h_dom_fer        arplicp.no_ingre%type,
                                                         pv_cod_ing_aju_redondeo        arplicp.no_ingre%type,
                                                         pv_tipo_emp                    arplme.tipo_emp%type,
                                                         pv_TIPLA                    arplme.estado%type,
                                                         pv_no_emple                    arplme.no_emple%type,
                                                         pd_hasta                       date,
                                                         pv_cod_h_ord                   arplmi.no_ingre%type,
                                                         pn_error                       out     number,
                                                         pv_error                       out     varchar2
) is
pv_proceso varchar2(100) := 'p_nomina_reg_ing_colectivos';

begin
  INSERT INTO arplppi(no_cia, cod_pla,
                       no_emple, no_ingre, ind_gen_auto)
        SELECT pv_no_cia, pv_cod_pla,
               e.no_emple, mi.no_ingre, 'I'
          FROM arplme e,
             (select i.no_ingre, i.aplica_a
              from arplicp icp, arplmi i
               where icp.no_cia   = pv_no_cia
                 and icp.cod_pla  = pv_cod_pla
                 and icp.no_cia   = i.no_cia
                 and icp.no_ingre = i.no_ingre
                 and i.estado     = 'A'
                 and indivi       = 'C'  --Solo Colectivos
                 and ((i.cuando_aplica = 'T')
                      OR (i.cuando_aplica = 'U' and pv_ultima_planilla = 'S')
                      OR (i.cuando_aplica = 'A' and pv_ultima_planilla = 'N'))
                 and i.no_ingre NOT IN (NVL(pv_cod_h_extras,'****'),
                                        NVL(pv_cod_h_noct,'****'),
                                        NVL(pv_cod_h_dom_fer,'****'),
                                        NVL(pv_cod_ing_aju_redondeo,'****'))) mi
         WHERE e.no_cia   = pv_no_cia
           AND e.tipo_emp = pv_tipo_emp
           AND e.estado   = DECODE(pv_TIPLA, 'LQ', 'I', 'A')
           AND e.no_emple = NVL(pv_no_emple, e.no_emple)
           AND NVL(e.f_reingreso, e.f_ingreso) <= pd_hasta
           AND (mi.aplica_a IS NULL OR
                mi.aplica_a IN (select clase_emp
                                  from arplecl
                                 where no_cia   = pv_no_cia
                                   and no_emple = e.no_emple))
           AND mi.no_ingre NOT IN (select no_ingre
                                     from arplppi
                                    where no_cia   = pv_no_cia
                                      and cod_pla  = pv_cod_pla
                                      and no_emple = e.no_emple)
           AND ( NVL(e.procesa_tarj,'N') = 'N' OR
                (NVL(e.procesa_tarj,'N') = 'S' AND
                 mi.no_ingre <> NVL(pv_cod_h_ord,'****')));
exception
  when others then
    pn_error := 999;
    pv_error := 'Error en '||pv_proceso||' '||substr(sqlerrm,1,200);
    rollback;
end p_nomina_reg_ing_colectivos;
