create or replace PROCEDURE            CgACTUALIZA_plan
 IS
  vfound          boolean;
  vProcesados     number;
  vTipo_mov       arcctd.tipo_mov%type;
  vcks_dev        arcctd.cks_dev%type;
  vtot_ref        number;
  vSaldo_doc      arccmd.saldo%type;
  vano_proce_cxc  arincd.ano_proce_cxc%type;
  vmes_proce_cxc  arincd.mes_proce_cxc%type;
  --
  vcod_Estado     arccte.cod_estado%TYPE;
  vLibro          Arcctd.Afecta_Libro%Type;
  vFactura        arcctd.factura%type;
  pError          varchar2(100);
  --
  error_proceso   EXCEPTION;
  --

  --
  cursor c_referencias is
  select cuenta, descri, ind_mov, permiso_con, PERMISO_CHE,	PERMISO_CXP,
       PERMISO_PLA,	PERMISO_AFIJO,	PERMISO_INV,	PERMISO_APROV,
       PERMISO_FACT,	PERMISO_CXC,	PERMISO_CCH,	ACEPTA_CC,
       USADO_EN,	COMPARTIDO,	NIVEL,	NATURALEZA
   from cuenta;

-- PL/SQL Block
BEGIN
  pError      := NULL;
  vProcesados := 0;
  --
  --
    for j in c_referencias loop
      update arcgms
          set  cuenta  =j.cuenta,
               descri  =j.descri,
               ind_mov =j.ind_mov,
               permiso_con =j.permiso_con,
               PERMISO_CHE =j.permiso_che,
               PERMISO_CXP =j.permiso_cxp,
               PERMISO_PLA =j.permiso_pla,
               PERMISO_AFIJO = j.permiso_afijo,
               PERMISO_INV	 = j.permiso_inv,
               PERMISO_APROV = j.permiso_aprov,
               PERMISO_FACT  = j.permiso_fact,
               PERMISO_CXC   = j.permiso_cxC,
               PERMISO_CCH   = j.permiso_cCh,
               ACEPTA_CC     = j.acepta_cc,
               USADO_EN      = j.usado_en,
               COMPARTIDO    = j.compartido,
               NIVEL         = j.nivel,
               NATURALEZA    = j.naturaleza
          where no_cia  = '01'
            and cuenta = j.cuenta;
       --
    end loop;
EXCEPTION
  WHEN others THEN
     pError := nvl(sqlerrm, 'Exception en CC_ACTUALIZA');
END CgACTUALIZA_plan;