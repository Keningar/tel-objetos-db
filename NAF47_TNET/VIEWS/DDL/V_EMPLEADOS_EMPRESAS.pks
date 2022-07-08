/**
 * DEBE EJECUTARSE EN NAF47_TNET.
 * Actualizacion de Vista Empleados Empresa para obtencion de data proyecto Anti Phishing
 * @author William Sánchez <wdsanchez@telconet.ec>
 * @version 1.0 01-03-2022 - Versión Inicial.
 */
CREATE OR REPLACE  VIEW NAF47_TNET.V_EMPLEADOS_EMPRESAS  
as 
SELECT arplme.no_cia,
       arplme.no_emple,
       arplme.nombre_pila,
       arplme.nombre_segundo,
       arplme.ape_pat,
       arplme.ape_mat,
       arplme.nombre,
       arplme.mail,
       arplme.Mail_Cia,
       arplme.cedula,
       arplme.sexo,
       arplme.e_civil,
       arplme.f_nacimi,
       arplme.estado,
       arplme.f_ingreso,
       arplme.f_egreso,
       arplme.tipo_emp, -- nuevo campo agregado por llindao - pedidos

       arplme.id_provincia,

       (select argepro.descripcion
          from NAF47_TNET.argepro
         where argepro.provincia = arplme.id_provincia
           AND argepro.pais = '313') nombre_provincia,

       arplme.id_region_patronal canton,

       (select argecan.descripcion
          from NAF47_TNET.argecan
         where argecan.canton = arplme.id_region_patronal
           AND argecan.provincia = arplme.id_provincia
           AND argecan.pais = '313') nombre_canton,

       arplme.area,

       (select arplar.descri
          from NAF47_TNET.arplar
         where arplar.area = arplme.area
           and arplar.no_cia = arplme.no_cia) nombre_area,
       arplme.depto,

       (select arpldp.descri
          from NAF47_TNET.arpldp
         where arpldp.depa = arplme.depto
           and arpldp.area = arplme.area
           and arpldp.no_cia = arplme.no_cia ) nombre_depto,
       arplme.puesto,
       
       (select arplmp.descri
          from NAF47_TNET.arplmp
         where arplmp.puesto = arplme.puesto
           and arplmp.no_cia = arplme.no_cia) descripcion_cargo,
       
       (select arplmp.jefe
          from NAF47_TNET.arplmp
         where arplmp.puesto = arplme.puesto
           and arplmp.no_cia = arplme.no_cia) autoriza_compras,
arplme.categoria,
       
       (select arplcat.descripcion
          from NAF47_TNET.arplcat
         where arplcat.categoria = arplme.categoria
           and arplcat.no_cia = arplme.no_cia) nombre_categoria,
       
       (select arplcat.ind_jefe
          from NAF47_TNET.arplcat
         where arplcat.categoria = arplme.categoria
           and arplcat.no_cia = arplme.no_cia) jefe_departamental,
           
       arplme.titulo,
       
      (select descripcion
         from NAF47_TNET.arpltit
        where arplme.titulo = arpltit.titulo) descripcion_titulo,
       arplme.id_cta,
       arplme.ind_liquidacion,
       arplme.ind_region,
       arplme.ind_fdo_res,
       arplme.ind_decimos,
       arplme.ind_aplica_935,
       arplme.ind_imp_renta,
       arplme.cobra_utilidades,
       arplme.id_jefe,
       arplme.no_cia_jefe,
       (select x.nombre
         from NAF47_TNET.arplme x
        where x.no_emple = arplme.id_jefe
          and x.no_cia = arplme.no_cia) nombre_jefe,
       arplme.oficina,
       
       ( SELECT
            c.nombre_canton
        FROM
            db_comercial.info_oficina_grupo    iof,
            db_general.admi_canton             c
        WHERE
                iof.canton_id = c.id_canton
            AND iof.id_oficina = arplme.oficina
            AND iof.estado = 'Activo'
            AND c.estado = 'Activo'
        ) OFICINA_CANTON,
       
       ( SELECT
            p.nombre_provincia
        FROM
            db_comercial.info_oficina_grupo    iof,
            db_general.admi_canton             c,
            db_general.admi_provincia          p
        WHERE
                iof.canton_id = c.id_canton
            AND c.provincia_id = p.id_provincia
            AND iof.id_oficina = arplme.oficina
            AND iof.estado = 'Activo'
            AND c.estado = 'Activo' 
            and p.estado = 'Activo') OFICINA_PROVINCIA,
       
    LOGIN_EMPLEADO.LOGIN LOGIN_EMPLE, 
    arplme.celular celular --- nuevo campo wdsanchez -  phishing 28042022
     FROM NAF47_TNET.arplme, NAF47_TNET.LOGIN_EMPLEADO
     WHERE arplme.No_Cia = LOGIN_EMPLEADO.NO_CIA(+)
       AND ARPLME.NO_EMPLE = LOGIN_EMPLEADO.NO_EMPLE(+);
