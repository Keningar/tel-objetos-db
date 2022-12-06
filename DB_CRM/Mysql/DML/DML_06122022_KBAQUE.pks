    select
        ac.name                                   as nombre_del_cliente,
        ac_c.ruc_c                                as identificacion,
        case
            when ac_c.tipo_negocio_c = '1'  then
                'Financiero'
            when ac_c.tipo_negocio_c = '2'  then
                'Servicios'
            when ac_c.tipo_negocio_c = '3'  then
                'Social'
            when ac_c.tipo_negocio_c = '4'  then
                'Educación'
            when ac_c.tipo_negocio_c = '5'  then
                'Salud'
            when ac_c.tipo_negocio_c = '6'  then
                'Transporte'
            when ac_c.tipo_negocio_c = '7'  then
                'Hotelería'
            when ac_c.tipo_negocio_c = '8'  then
                'Restauración'
            when ac_c.tipo_negocio_c = '9'  then
                'Retail'
            when ac_c.tipo_negocio_c = '10' then
                'Gobierno'
            when ac_c.tipo_negocio_c = '11' then
                'Construcción'
            when ac_c.tipo_negocio_c = '12' then
                'Industria'
            when ac_c.tipo_negocio_c = '13' then
                'Energía y Petróleo'
            when ac_c.tipo_negocio_c = '14' then
                'Agroindustria'
            when ac_c.tipo_negocio_c = '15' then
                'Telecomm'
            when ac_c.tipo_negocio_c = '16' then
                'Residencial'
            when ac_c.tipo_negocio_c = '17' then
                'Empresa Relacionada'
            when ac_c.tipo_negocio_c = '18' then
                'Empresa'
            when ac_c.tipo_negocio_c = '19' then
                'Negocio'
            else
                ''
        end                                       as tipo_de_negocio,
        case
            when ac.account_type = 'prospect'   then
                'Prospecto'
            when ac.account_type = 'customer'   then
                'Cliente'
            when ac.account_type = 'competitor' then
                'Competidor'
            else
                ''
        end                                       as tipo_de_cuenta,
        op.name                                   as nombre_de_propuesta,
        le_c.lead_name_c                          as nombre_oportunidad,
        op_c.competitor_c                         as competidor,
        case
            when op.sales_stage = 'Prospecting'          then
                '01 - Calificación'
            when op.sales_stage = 'Qualification'        then
                '02 - Oportunidad'
            when op.sales_stage = 'Value Proposition'    then
                '03 - Desarrollo de la visión'
            when op.sales_stage = 'Perception Analysis'  then
                '04 - Presentación'
            when op.sales_stage = 'Proposal/Price Quote' then
                '05 - Acuerdo'
            when op.sales_stage = 'Negotiation/Review'   then
                '06 - Negociación'
            when op.sales_stage = 'Closed Won'           then
                '07 - Cerrado'
            else
                ''
        end                                       as etapa_de_ventas,
        case
            when op_c.status_c = 'open'   then
                'Abierta'
            when op_c.status_c = 'noSale' then
                'Expirada'
            when op_c.status_c = 'lost'   then
                'Perdida'
            when op_c.status_c = 'won'    then
                'Ganada'
            else
                ''
        end                                       as estado,
        case
            when op_c.strategy_c = 'Servicios_Competencia' then
                'Servicios Competencia'
            when op_c.strategy_c = 'Proveedores_Telconet'  then
                'Proveedores Telconet'
            when op_c.strategy_c = 'Clientes_Nuevos'       then
                'Clientes Nuevos'
            when op_c.strategy_c = 'Oracle'                then
                'Cloud Oracle'
            when op_c.strategy_c = 'Cloud_Sap_Nutanix'     then
                'Cloud Sap/Nutanix'
            when op_c.strategy_c = 'Educacion'             then
                'Educación'
            when op_c.strategy_c = 'Forecast_Tradicional'  then
                'Forecast Tradicional'
            when op_c.strategy_c = 'Gobierno'              then
                'Gobierno'
            when op_c.strategy_c = 'ISP'                   then
                'ISP'
            when op_c.strategy_c = 'Multicloud'            then
                'Multicloud'
            when op_c.strategy_c = 'Nuevos_Telcos'         then
                'Nuevos Telcos'
            when op_c.strategy_c = 'Security'              then
                'Security'
            else
                ''
        end                                       as estrategia,
        case
            when op_c.reasonwinloss_c = 'Customer not ready'                                then
                'El cliente no está preparado'
            when op_c.reasonwinloss_c = 'Good lead'                                         then
                'Buena Oportunidad Potencial'
            when op_c.reasonwinloss_c = 'Install base'                                      then
                'Base instalada'
            when op_c.reasonwinloss_c = 'Lost to competition'                               then
                'Perdida por competencia'
            when op_c.reasonwinloss_c = 'Lost to internal development'                      then
                'Perdida por desarrollo interno'
            when op_c.reasonwinloss_c = 'Lost no decision'                                  then
                'Perdida por falta de decisión'
            when op_c.reasonwinloss_c = 'No bandwidth'                                      then
                'Sin Cobertura o Excedentes'
            when op_c.reasonwinloss_c = 'No budget'                                         then
                'Sin presupuesto'
            when op_c.reasonwinloss_c = 'Price'                                             then
                'Precio'
            when op_c.reasonwinloss_c = 'Product'                                           then
                'Producto'
            when op_c.reasonwinloss_c = 'Relationship'                                      then
                'Relación'
            when op_c.reasonwinloss_c = 'Track record'                                      then
                'Registro de seguimiento'
            when op_c.reasonwinloss_c = 'Delays in the quotation or implementation process' then
                'Retrasos en proceso de cotización o implementación'
            when op_c.reasonwinloss_c = 'Disqualification'                                  then
                'Descalificación'
            when op_c.reasonwinloss_c = 'Prefer Current Provider'                           then
                'Prefiere Proveedor Actual'
            when op_c.reasonwinloss_c = 'High delivery time'                                then
                'Tiempo de entrega elevado'
            else
                ''
        end                                       as razon_ganado_perdido,
        op_c.observation_c                        as observacion,
        op_c.is_project_c                         as es_proyecto,
        case
            when op_c.source_c = 'Cold Call'         then
                'Llamada en Frío'
            when op_c.source_c = 'Existing Customer' then
                'Cliente Existente'
            when op_c.source_c = 'Self Generated'    then
                'Auto Generado'
            when op_c.source_c = 'Employee'          then
                'Empleado'
            when op_c.source_c = 'Partner'           then
                'Socio'
            when op_c.source_c = 'Public Relations'  then
                'Relaciones Públicas'
            when op_c.source_c = 'Direct Mail'       then
                'Correo Directo'
            when op_c.source_c = 'Conference'        then
                'Conferencia'
            when op_c.source_c = 'Trade Show'        then
                'Exposición'
            when op_c.source_c = 'Web Site'          then
                'Sitio Web o Correo Institucional'
            when op_c.source_c = 'Word of mouth'     then
                'Recomendación'
            when op_c.source_c = 'Email'             then
                'Email'
            when op_c.source_c = 'Campaign'          then
                'Campaña'
            when op_c.source_c = 'Telco_Talks'       then
                'Telco Talks'
            when op_c.source_c = 'Social_Networks'   then
                'Redes Sociales'
            else
                ''
        end                                       as origen_de_propuesta,
        date_format(op.date_entered, '%Y-%m-%d')  as fecha_de_creacion_propuesta,
        date_format(le.date_entered, '%Y-%m-%d')  as fecha_de_creacion_oportunidad,
        case
            when le.status = 'New'         then
                'Nueva'
            when le.status = 'Unqualified' then
                'No calificada'
            when le.status = 'Qualify'     then
                'Calificada'
            when le.status = 'Converted'   then
                'Convertida'
            else
                ''
        end                                       as estado_oportunidad,
        case
            when le_c.rank_c = 'cold' then
                'Inferior'
            when le_c.rank_c = 'warm' then
                'No Intermedia'
            when le_c.rank_c = 'hot'  then
                'Superior'
            else
                ''
        end                                       as clasificacion_oportunidad,
        (
            select
                min(mee.date_start)
            from
                bitnami_suitecrm.meetings_leads mee_le
                left join bitnami_suitecrm.meetings       mee on mee.id = mee_le.meeting_id
                                                           and mee.deleted = 0
            where
                mee_le.lead_id = le.id
        )                                         as primera_fecha_actividades,
        (
            select
                max(date_end)
            from
                bitnami_suitecrm.meetings_leads mee_le
                left join bitnami_suitecrm.meetings       mee on mee.id = mee_le.meeting_id
                                                           and mee.deleted = 0
            where
                mee_le.lead_id = le.id
        )                                         as ultima_fecha_actividades,
        date_format(op.date_modified, '%Y-%m-%d') as fecha_de_modificacion,
        date_format(op.date_closed, '%Y-%m-%d')   as fecha_de_cierre,
        op_c.life_time_c                          as tiempo_transcurrido_en_dias,
        case
            when op_c.assigned_telcos_c = 'NO' then
                'No'
            when op_c.assigned_telcos_c = 'SI' then
                'Si'
            else
                ''
        end                                       as asignado_en_telcos,
        replace(op_c.login_c, ';', ', ')          as login_en_telcos,
        apc.name                                  as categoria_de_producto,
        apq.name                                  as nombre_de_producto,
        op_c.number_contract_c                    as meses_contrato,
        format(op_c.total_contract_amount_c, 2)   as monto_total_contrato,
        format(apq.product_total_price, 2)        as mrc,
        format(apq.vat_amt, 2)                    as iva_mrc,
        format(apq.nrc, 2)                        as nrc,
        format(apq.iva_nrc, 2)                    as iva_nrc,
        vendedor.user_name                        as vendedor,
        concat(vendedor.first_name,
               concat(' ', vendedor.last_name))   as nombre_vendedor,
        subgerente.user_name                      as subgerente,
        concat(subgerente.first_name,
               concat(' ', subgerente.last_name)) as nombre_subgerente,
        le.id as id_oportunidad,
        op.id as id_propuesta
    from
             bitnami_suitecrm.opportunities op
        join bitnami_suitecrm.opportunities_cstm     op_c on op.id = op_c.id_c
        join bitnami_suitecrm.aos_line_item_groups   alig on alig.parent_id = op.id
                                                           and alig.deleted = 0
        join bitnami_suitecrm.aos_products_quotes    apq on apq.group_id = alig.id
                                                         and apq.deleted = 0
                                                         and apq.parent_type = 'Opportunity'
        join bitnami_suitecrm.aos_products           ap on apq.product_id = ap.id
        join bitnami_suitecrm.aos_product_categories apc on apc.id = ap.aos_product_category_id
        join bitnami_suitecrm.accounts_opportunities ac_op on ac_op.opportunity_id = op.id
                                                              and ac_op.deleted = 0
        join bitnami_suitecrm.accounts               ac on ac.id = ac_op.account_id
                                             and ac.deleted = 0
        join bitnami_suitecrm.accounts_cstm          ac_c on ac_c.id_c = ac.id
                                                    and ac_c.ruc_c != ''
        join bitnami_suitecrm.users                  vendedor on vendedor.id = op.assigned_user_id
                                                and vendedor.deleted = 0
        left join bitnami_suitecrm.users                  subgerente on vendedor.reports_to_id = subgerente.id
        left join bitnami_suitecrm.leads                  le on le.opportunity_id = op.id
                                               and le.deleted = 0
        left join bitnami_suitecrm.leads_cstm             le_c on le_c.id_c = le.id
    where
            op.deleted = 0
        and op.assigned_user_id in (
            select
                u.id
            from
                     bitnami_suitecrm.securitygroups su
                join bitnami_suitecrm.securitygroups_users sgu on sgu.securitygroup_id = su.id
                                                                  and sgu.deleted = '0'
                join bitnami_suitecrm.users                u on u.id = sgu.user_id
                                                 and u.deleted = '0'
            where
                    su.deleted = '0'
                and su.name in (
                    select
                        sg.name
                    from
                             bitnami_suitecrm.securitygroups sg
                        join bitnami_suitecrm.securitygroups_acl_roles sgar on sg.id = sgar.securitygroup_id
                                                                               and sgar.deleted = 0
                        join bitnami_suitecrm.acl_roles                acr on acr.id = sgar.role_id
                                                               and acr.deleted = 0
                    where
                            sg.deleted = 0
                        and acr.name in ( 'ROL_SUBGERENTE_COMERCIAL', 'ROL_GERENTE_COMERCIAL' )
                )
        )
Concatenate
    select
        ''                                        as nombre_del_cliente,
        ''                                        as identificacion,
        ''                                        as tipo_de_negocio,
        ''                                        as tipo_de_cuenta,
        ''                                        as nombre_de_propuesta,
        le_c.lead_name_c                          as nombre_oportunidad,
        ''                                        as competidor,
        ''                                        as etapa_de_ventas,
        ''                                        as estado,
        ''                                        as estrategia,
        ''                                        as razon_ganado_perdido,
        ''                                        as observacion,
        ''                                        as es_proyecto,
        ''                                        as origen_de_propuesta,
        ''                                        as fecha_de_creacion_propuesta,
        date_format(le.date_entered,'%Y-%m-%d')  as fecha_de_creacion_oportunidad,
        case
            when le.status = 'New'         then  'Nueva'
            when le.status = 'Unqualified' then  'No calificada'
            when le.status = 'Qualify'     then  'Calificada'
            when le.status = 'Converted'   then  'Convertida'
            else ''
        end  									  as estado_oportunidad,
        case
            when le_c.rank_c = 'cold' then 'Inferior'
            when le_c.rank_c = 'warm' then 'No Intermedia'
            when le_c.rank_c = 'hot'  then 'Superior'
            else ''
        end 									  as clasificacion_oportunidad,
        (
            select
                min(mee.date_start)
            from
                bitnami_suitecrm.meetings_leads mee_le
                left join bitnami_suitecrm.meetings       mee on mee.id = mee_le.meeting_id
                                                           and mee.deleted = 0
            where
                mee_le.lead_id = le.id
        )                                         as primera_fecha_actividades,
        (
            select
                max(date_end)
            from
                bitnami_suitecrm.meetings_leads mee_le
                left join bitnami_suitecrm.meetings       mee on mee.id = mee_le.meeting_id
                                                           and mee.deleted = 0
            where
                mee_le.lead_id = le.id
        )                                         as ultima_fecha_actividades,
        ''                                        as fecha_de_modificacion,
        ''                                        as fecha_de_cierre,
        ''                                        as tiempo_transcurrido_en_dias,
        ''                                        as asignado_en_telcos,
        ''                                        as login_en_telcos,
        ''                                        as categoria_de_producto,
        ''                                        as nombre_de_producto,
        ''                                        as meses_contrato,
        ''                                        as monto_total_contrato,
        ''                                        as mrc,
        ''                                        as iva_mrc,
        ''                                        as nrc,
        ''                                        as iva_nrc,
        vendedor.user_name                        as vendedor,
        concat(vendedor.first_name,
               concat(' ', vendedor.last_name))   as nombre_vendedor,
        subgerente.user_name                      as subgerente,
        concat(subgerente.first_name,
               concat(' ', subgerente.last_name)) as nombre_subgerente,
        le.id as id_oportunidad,
        le.opportunity_id as id_propuesta
    from
             bitnami_suitecrm.leads le
        join bitnami_suitecrm.leads_cstm le_c on le_c.id_c = le.id
                                and le.deleted = 0
        join bitnami_suitecrm.users      vendedor on vendedor.id = le.assigned_user_id
                               and vendedor.deleted = 0
        left join bitnami_suitecrm.users      subgerente on vendedor.reports_to_id = subgerente.id
    where
        le.assigned_user_id in (
            select
                u.id
            from
                     bitnami_suitecrm.securitygroups su
                join bitnami_suitecrm.securitygroups_users sgu on sgu.securitygroup_id = su.id
                                                 and sgu.deleted = '0'
                join bitnami_suitecrm.users                u on u.id = sgu.user_id
                                and u.deleted = '0'
            where
                    su.deleted = '0'
                and su.name in (
                    select
                        sg.name
                    from
                             bitnami_suitecrm.securitygroups sg
                        join bitnami_suitecrm.securitygroups_acl_roles sgar on sg.id = sgar.securitygroup_id
                                                              and sgar.deleted = 0
                        join bitnami_suitecrm.acl_roles                acr on acr.id = sgar.role_id
                                              and acr.deleted = 0
                    where
                            sg.deleted = 0
                        and acr.name in ( 'ROL_SUBGERENTE_COMERCIAL', 'ROL_GERENTE_COMERCIAL' )
                )
        )

        and (le.opportunity_id is null || le.opportunity_id = '');