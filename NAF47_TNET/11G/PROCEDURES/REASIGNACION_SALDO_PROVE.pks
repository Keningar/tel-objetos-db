create or replace procedure            REASIGNACION_SALDO_PROVE(P_CIA VARCHAR2, 
                                                     P_GRUPO VARCHAR2,
                                                     msg_error_p  in out varchar2)  IS

  -- Cursor qur obtiene grupo de proveedores
  CURSOR C_PROVE (P_CIA VARCHAR2,P_GRUPO VARCHAR2) IS
    SELECT NO_PROVE, MONEDA_LIMITE  FROM ARCPMP WHERE NO_CIA = P_CIA AND GRUPO = P_GRUPO
    AND NO_PROVE = '000007';

  -- Cursor qur obtiene grupo de proveedores
  CURSOR C_Inicio_Debito (P_CIA VARCHAR2, P_prove VARCHAR2) IS
    Select to_number(min(to_char(trunc(md.fecha),'yyyymm'))) --, to_number(min(to_char(trunc(md.fecha),'mm')))
    From arcpmd md, arcptd td
    Where md.no_cia = P_CIA and md.no_prove = P_prove
    and md.ind_act <> 'P'  and  nvl(md.anulado,'N') = 'N'
    and md.no_cia = td.no_cia and md.tipo_doc = td.tipo_doc
    and td.tipo_mov = 'C' and td.documento <> 'R';

  -- Cursor qur obtiene grupo de proveedores
  CURSOR C_Inicio_Credito (P_CIA VARCHAR2,P_prove VARCHAR2) IS
    Select to_number(min(to_char(trunc(md.fecha),'yyyymm')))  --, to_number(min(to_char(trunc(md.fecha),'mm')))
    From arcpmd md, arcptd td
    Where md.no_cia = P_CIA and md.no_prove = P_prove
    and md.ind_act <> 'P'  and  nvl(md.anulado,'N') = 'N'
    and md.no_cia = td.no_cia and md.tipo_doc = td.tipo_doc
    and td.tipo_mov = 'D' /*and td.documento <> 'K'*/;

  -- Cursor que obtiene los docuemntos de debito
  CURSOR C_DEBITO  IS
    SELECT tipo_doc FROM ARCPTD WHERE NO_CIA = P_CIA AND TIPO_MOV = 'C' AND DOCUMENTO <> 'R';

  -- Cursor que obtiene los docuemntos de credito
  CURSOR C_CREDITO IS
    SELECT tipo_doc FROM ARCPTD WHERE NO_CIA = P_CIA AND TIPO_MOV = 'D' /*AND DOCUMENTO <> 'K'*/;

-- Cursor que obtiene debitos y creditos por proveedor a?o y mes
  CURSOR C_Total_tipo_mes(P_CIA VARCHAR2,  P_prove VARCHAR2,
                          P_tipo VARCHAR2, P_ano_mes number) IS
    Select sum(monto)  From arcpmd md
    Where md.no_cia = P_CIA and no_prove = P_prove and tipo_doc = P_tipo  and  ind_act <> 'P'
    and nvl(anulado,'N') = 'N' and to_number(to_number(to_char(fecha,'yyyymm'))) = P_ano_mes;

 CURSOR C_PROC_ARCPSA(P_CIA VARCHAR2,  P_prove VARCHAR2, P_ano_mes number) IS
   Select max((sa.ano*100)+sa.mes) fecha, sa.saldo  From proc_arcpsa sa
    Where sa.no_cia = P_CIA and sa.no_prove = P_prove --AND ROWNUM = 1
    group by sa.saldo ORDER BY max((sa.ano*100)+sa.mes) DESC ; 
 
 /*
   Select max(sa.ano||sa.mes) fecha,sa.saldo  From proc_arcpsa sa
    Where sa.no_cia = P_CIA and sa.no_prove = P_prove
    group by sa.saldo;   */

-- Variables
  vn_ano_mes_inicio  number;
  vn_ano_mes_debito  number;
  vn_ano_mes_credito number;
  vn_ano_inicio     number;
  vn_mes_inicio     number;
  vn_ano_mes_fin    number;
  vn_ano_mes_buscar number;
   vn_ano_mes_max number;
  --
  vn_mes_tipo_debito  number;
  vn_mes_tipo_credito number;
  --
  vn_total_debito  number;
  vn_total_credito number;
  vn_saldo_mes     number;
  vn_saldo_mes_anterior number;
  --
  error_proceso   EXCEPTION;
  --  
  --
BEGIN
  --
   vn_ano_mes_fin  := to_number(to_char(trunc(sysdate),'yyyymm'));
  --For de Proveedores
  For PROV IN C_PROVE(P_CIA, P_GRUPO) LOOP
    --
 --   vn_saldo_mes_anterior := 0;
    --
    Open  C_Inicio_Debito(p_cia,prov.no_prove);
    Fetch C_Inicio_Debito  into vn_ano_mes_debito;  --, vn_mes_debito;
    Close C_Inicio_Debito;
    --
    Open  C_Inicio_Credito(p_cia,prov.no_prove);
    Fetch C_Inicio_Credito into vn_ano_mes_credito; --, vn_mes_credito;
    Close C_Inicio_Credito;
    --
    If (nvl(vn_ano_mes_debito,0) <> 0)  and --(nvl(vn_mes_debito,0) <> 0) and
       (nvl(vn_ano_mes_credito,0)<> 0)  then  --and (nvl(vn_mes_credito,0)<> 0)  Then
       --
          If (vn_ano_mes_debito) > (vn_ano_mes_credito) THEN
               vn_ano_mes_inicio  := vn_ano_mes_credito;
               
             ELSE
               vn_ano_mes_inicio  := vn_ano_mes_debito;

          End if;
          --
          While  vn_ano_mes_inicio  <=  vn_ano_mes_fin  Loop
            -- For para los debitos
            vn_mes_tipo_debito := 0;
            vn_total_debito    := 0;
            vn_mes_tipo_credito := 0;
            vn_total_credito    := 0;
            vn_ano_mes_buscar := vn_ano_mes_inicio;
            --
            For td  in C_DEBITO  Loop
               Open  C_Total_tipo_mes(p_cia,prov.no_prove, td.tipo_doc, vn_ano_mes_buscar);
               Fetch C_Total_tipo_mes into vn_mes_tipo_debito;
               Close C_Total_tipo_mes;
               --
               vn_total_debito := nvl(vn_total_debito,0) + nvl(vn_mes_tipo_debito,0);
            end loop;

            -- For para los creditos
            For tc  in C_CREDITO  Loop
               Open  C_Total_tipo_mes(p_cia,prov.no_prove, tc.tipo_doc, vn_ano_mes_buscar);
               Fetch C_Total_tipo_mes into vn_mes_tipo_credito;
               Close C_Total_tipo_mes;
               --
               vn_total_credito := nvl(vn_total_credito,0) + nvl(vn_mes_tipo_credito,0);
            end loop;

              Open  C_PROC_ARCPSA(p_cia,prov.no_prove, (vn_ano_mes_buscar-1));
               Fetch C_PROC_ARCPSA into   vn_ano_mes_max, vn_saldo_mes_anterior;
               if C_PROC_ARCPSA%notfound then
                  vn_saldo_mes_anterior :=0;
               End if;
               Close C_PROC_ARCPSA;

           vn_saldo_mes :=  nvl(vn_saldo_mes_anterior,0)+vn_total_debito + (vn_total_credito * -1);

          INSERT INTO PROC_ARCPSA (NO_CIA,                         NO_PROVE,            ANO,
                                   MES,                            MONEDA,              SALDO,  
                                   DEBITOS,                        CREDITOS,            SALDO_ANT )
                           VALUES (p_Cia,                          prov.no_prove,       substr(vn_ano_mes_inicio,1,4),
                                   substr(vn_ano_mes_inicio,5,6),  PROV.Moneda_Limite,  vn_saldo_mes,
                                   vn_total_debito,                vn_total_credito,    vn_saldo_mes_anterior);
     BEGIN
          INSERT INTO ARCPSA      (NO_CIA,                         NO_PROVE,            ANO,
                                   MES,                            MONEDA,              SALDO,  
                                   DEBITOS,                        CREDITOS,            SALDO_ANT )
                           VALUES (p_Cia,                          prov.no_prove,       substr(vn_ano_mes_inicio,1,4),
                                   substr(vn_ano_mes_inicio,5,6),  PROV.Moneda_Limite,  vn_saldo_mes,
                                   vn_total_debito,                vn_total_credito,    vn_saldo_mes_anterior);
  Exception
  When Others Then
      msg_error_p:='Error al crear registro '||prov.no_prove||' - '||vn_ano_mes_inicio||' - '||sqlerrm;
      RAISE error_proceso;
  End;

         COMMIT;
         
          IF Substr(vn_ano_mes_inicio,5,6) = 12 THEN
              vn_ano_inicio := substr(vn_ano_mes_inicio,1,4) + 1;
              vn_mes_inicio := 1;
              vn_ano_mes_inicio := (vn_ano_inicio * 100) + vn_mes_inicio;
            ELSE
              vn_ano_mes_inicio := vn_ano_mes_inicio + 1;
          END IF;
          --

          --
       End Loop;   -- Fecha
    End if;
    --
  	UPDATE arcpms
	     SET saldo_actual = vn_saldo_mes
     WHERE no_cia   = p_Cia
       AND no_prove = prov.no_prove;
--       AND moneda   = PROV.Moneda_Limite; */
    --
End Loop;   -- Proveedor
--end REASIGNACION_SALDO_PROVE;

EXCEPTION
  WHEN error_proceso THEN
       msg_error_p := nvl(msg_error_p, 'ERROR: En reproceso');
       return;
  WHEN others THEN
       msg_error_p := 'reproceso: '||SQLERRM(SQLCODE);
       return;
END;