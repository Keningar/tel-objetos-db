CREATE OR REPLACE PACKAGE            PK_CALCULO_SUGERIDO IS

Ln_dias_requeridos NUMBER;
Pv_cia             VARCHAR2(2);


-- Public function and procedure declarations
FUNCTION Compras_transito_prov ( Pv_NoCia   IN VARCHAR2,
                                 Pv_Bodega  IN VARCHAR2,
                                 Pv_Centro  IN VARCHAR2,
                                 Pv_NoProve IN VARCHAR2,
                                 Pv_Error   OUT VARCHAR2
                               ) RETURN DATE;

FUNCTION Compras_transito ( Pv_NoCia      IN VARCHAR2,
                            Pv_bodega     IN VARCHAR2,
                            Pv_Centro     IN VARCHAR2,
                            Pv_Clase      IN VARCHAR2,
                            Pv_Categoria  IN VARCHAR2,
                            Pv_NoArti     IN VARCHAR2,
                            Pv_Prove      IN VARCHAR2,
                            Pv_Error     OUT VARCHAR2
                          ) RETURN NUMBER;

PROCEDURE Envia_Mail ( Pv_origen  IN VARCHAR2,
                       Pv_Destino IN VARCHAR2,
                       Pv_Subject IN VARCHAR2,
                       Pv_Mensaje IN VARCHAR2);

PROCEDURE Principal ( gpv_cia    VARCHAR2,
                      gpv_prove  VARCHAR2,
                      gpv_marca  VARCHAR2,
                      gpv_crit   VARCHAR2,
                      gpv_clasif VARCHAR2,
                      gpv_msg_error OUT VARCHAR2
                     );

PROCEDURE Principal ( gpv_cia           VARCHAR2,
                      gpv_prove         VARCHAR2,
                      gpv_marca         VARCHAR2,
                      gpv_crit          VARCHAR2,
                      gpv_division      VARCHAR2,
                      gpv_subdivision   VARCHAR2,
                      gpv_tproceso      VARCHAR2,
                      gpv_msg_error OUT VARCHAR2
                    );

PROCEDURE CONTROL;

END PK_CALCULO_SUGERIDO;
/


CREATE OR REPLACE package body            PK_CALCULO_SUGERIDO is

FUNCTION Compras_transito   ( Pv_NoCia      IN VARCHAR2,
                              Pv_bodega     IN VARCHAR2,
                              Pv_Centro     IN VARCHAR2,
                              Pv_Clase      IN VARCHAR2,
                              Pv_Categoria  IN VARCHAR2,
                              Pv_NoArti     IN VARCHAR2,
                              Pv_Prove      IN VARCHAR2,
                              Pv_Error     OUT VARCHAR2
                               )RETURN NUMBER IS

  CURSOR C_PedTransito( Cv_NoCia     VARCHAR2,
                        Cv_Bodega    VARCHAR2,
                        Cv_Centro    VARCHAR2,
                        Cv_Clase     VARCHAR2,
                        Cv_Categoria VARCHAR2,
                        Cv_NoArti    VARCHAR2,
                        Cv_Prove     VARCHAR2
                        ) IS
    SELECT DISTINCT c.no_pedido
      FROM arimencPEDIDO c, arimdetPEDIDO d
     WHERE c.no_cia     = Cv_NoCia
       AND c.no_cia     = d.no_cia
       AND c.nO_PEDIDO  = d.nO_PEDIDO
       AND d.no_arti    = Cv_NoArti
       AND C.ESTADO != 'X'
       AND (C.NO_EMBARQUE IS NULL
       OR c.no_embarque NOT IN (SELECT no_embarque FROM arimencdoc WHERE no_cia = Cv_NoCia));

  CURSOR C_CompTransito( Cv_NoCia     VARCHAR2,
                         Cv_Bodega    VARCHAR2,
                         Cv_Centro    VARCHAR2,
                         Cv_Clase     VARCHAR2,
                         Cv_Categoria VARCHAR2,
                         Cv_NoArti    VARCHAR2,
                         Cv_Prove     VARCHAR2,
                         Cv_Pedido    VARCHAR2
                        ) IS
    SELECT 400 ORIGEN, c.no_pedido, SUM(d.cantidad_pedida ) unid_trans
      FROM arimencPEDIDO c, arimdetPEDIDO d
     WHERE c.no_cia     = Cv_NoCia
       AND c.no_pedido  = cv_pedido
       AND c.no_cia     = d.no_cia
       AND c.nO_PEDIDO  = d.nO_PEDIDO
       AND d.no_arti    = Cv_NoArti
       AND C.ESTADO != 'X'
       AND (C.NO_EMBARQUE IS NULL
       OR c.no_embarque NOT IN (SELECT no_embarque FROM arimencdoc WHERE no_cia = Cv_NoCia))
       GROUP BY C.NO_PEDIDO
    UNION
    SELECT 300 ORIGEN, c.no_proforma, SUM(d.cantidad_pedida ) unid_trans
      FROM arimencPROFORMA c, arimdetPROFORMA d
     WHERE c.no_cia      = Cv_NoCia
       AND c.no_proforma = cv_pedido
       AND c.no_cia      = d.no_cia
       AND c.nO_PROFORMA = d.nO_PROFORMA
       AND d.no_arti     = Cv_NoArti
       AND C.ESTADO != 'X'
       AND (C.NO_EMBARQUE IS NULL
       OR c.no_embarque NOT IN (SELECT no_embarque FROM arimencdoc WHERE no_cia = Cv_NoCia))
       GROUP BY C.NO_PROFORMA
    UNION
    SELECT 200 ORIGEN, C.NO_ORDEN, SUM(d.cantidad_pedida ) unid_trans
      FROM arimencorden c, arimdetorden d
     WHERE c.no_cia     = Cv_NoCia
       AND c.no_orden   = cv_pedido
       AND c.no_cia     = d.no_cia
       AND c.no_orden   = d.no_orden
       AND d.no_arti    = Cv_NoArti
       AND C.ESTADO != 'X'
       AND (C.NO_EMBARQUE IS NULL
            OR c.no_embarque NOT IN (SELECT no_embarque FROM arimencdoc WHERE no_cia = Cv_NoCia))
      GROUP BY C.NO_ORDEN
    UNION
    SELECT 100 ORIGEN, C.NO_ORDEN, SUM(d.cantidad_pedida ) unid_trans
      FROM arimencfacturas c, arimdetfacturas d
     WHERE c.no_cia     = Cv_NoCia
       AND c.no_orden   = cv_pedido
       AND c.no_cia     = d.no_cia
       AND c.num_fac    = d.num_fac
       AND d.no_arti    = Cv_NoArti
       AND C.ESTADO != 'X'
       AND (C.NO_EMBARQUE IS NULL
       OR c.no_embarque NOT IN (SELECT no_embarque FROM arimencdoc WHERE no_cia = Cv_NoCia))
     GROUP BY C.NO_ORDEN
    ORDER BY 1;

  Ln_CompTransito NUMBER(12,2):=0;
  Ln_TotTransito  NUMBER(12,2):=0;
  Lv_PEDIDO       VARCHAR2(20);
  Ln_origen       NUMBER;

BEGIN
  Ln_TotTransito := 0;
  FOR reg in C_PedTransito(Pv_NoCia, Pv_bodega, Pv_Centro, Pv_Clase, Pv_Categoria, Pv_NoArti, Pv_Prove) LOOP

      OPEN  C_CompTransito(Pv_NoCia, Pv_bodega, Pv_Centro, Pv_Clase, Pv_Categoria, Pv_NoArti, Pv_Prove, Reg.NO_PEDIDO);
      FETCH C_CompTransito INTO Ln_origen, Lv_pedido, Ln_CompTransito;
      CLOSE C_CompTransito;

      Ln_TotTransito := Ln_TotTransito + NVL(Ln_CompTransito,0);

  END LOOP;

  RETURN(NVL(Ln_TOTTransito,0));

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Error := 'Error al Recuperar Compras en Transito '||SQLERRM;
      RETURN(0);
END;


FUNCTION Compras_transito_prov ( Pv_NoCia    IN VARCHAR2,
                                 Pv_Bodega   IN VARCHAR2,
                                 Pv_Centro   IN VARCHAR2,
                                 Pv_NoProve  IN VARCHAR2,
                                 Pv_Error    OUT VARCHAR2
                               ) RETURN DATE IS

  CURSOR C_CompTransito_prov(Cv_NoCia VARCHAR2, Cv_bodega VARCHAR2,Cv_NoProve VARCHAR2) IS
    SELECT min(c.fecha) fecha
      FROM arimencPEDIDO c, arimdetPEDIDO d
     WHERE c.no_cia        = Cv_NoCia
       AND c.NO_prove = Cv_NoProve
       AND c.no_cia        = d.no_cia
       AND c.nO_PEDIDO       = d.nO_PEDIDO
       AND (C.NO_EMBARQUE IS NULL
       OR c.no_embarque NOT IN (SELECT no_embarque FROM arimencdoc WHERE no_cia = Cv_NoCia));

  Ln_CompTransito Date;

BEGIN
  OPEN  C_CompTransito_prov(Pv_NoCia, Pv_bodega, Pv_NoProve);
  FETCH C_CompTransito_prov INTO Ln_CompTransito;
  CLOSE C_CompTransito_prov;

  RETURN(Ln_CompTransito);

  EXCEPTION
    WHEN OTHERS THEN
         Pv_Error := 'Error al Recuperar Compras en Transito '||SQLERRM;
         RETURN(NULL);
END;

PROCEDURE Envia_Mail ( Pv_origen  IN VARCHAR2,
                       Pv_Destino IN VARCHAR2,
                       Pv_Subject IN VARCHAR2,
                       Pv_Mensaje IN VARCHAR2)  IS

  smtp_server    VARCHAR2(100)    := '192.168.2.1';
  x_mail_to      VARCHAR2(255)    := 'prueba@yoveri.com';
  x_mail_from    VARCHAR2(100)    := 'prueba@yoveri.com';
  x_mail_subject VARCHAR2(255)    := 'Generacion Automatica de Sugeridos';
  x_mail_body    VARCHAR2(2000);
  l_mail_conn    utl_smtp.connection;
  Error_proceso  EXCEPTION;

BEGIN
  -- Mensaje del mail
  x_mail_body := UTL_TCP.CRLF;
  x_mail_body := x_mail_body || 'Estimado(a),' || UTL_TCP.CRLF;
  x_mail_body := x_mail_body || UTL_TCP.CRLF;
  x_mail_body := x_mail_body || 'Se procedio a Generaron los siguientes Sugeridos' || UTL_TCP.CRLF;
  --
  If Pv_Mensaje IS NOT NULL then
    x_mail_body := x_mail_body || UTL_TCP.CRLF;
    x_mail_body := x_mail_body || Pv_Mensaje || UTL_TCP.CRLF;
  End if;
  --
  x_mail_body := x_mail_body || UTL_TCP.CRLF;
  x_mail_body := x_mail_body || UTL_TCP.CRLF;
  x_mail_body := x_mail_body || UTL_TCP.CRLF;
  x_mail_body := x_mail_body || 'Cordialmente.' || UTL_TCP.CRLF;
  x_mail_body := x_mail_body || UTL_TCP.CRLF;
  x_mail_body := x_mail_body || 'Departamento de Sistemas' || UTL_TCP.CRLF;
  x_mail_body := x_mail_body || 'L. Henriques S.A.' || UTL_TCP.CRLF;

  -- Envio del mail
  x_mail_to   := NVL(Pv_Destino,'manuel.yuquilima@lhenriques.com');
  x_mail_from := NVL(Pv_origen,'manuel.yuquilima@lhenriques.com');
  x_mail_subject := NVL(Pv_Subject, x_mail_subject);
  l_mail_conn := utl_smtp.open_connection(smtp_server, 25);
  --
  utl_smtp.helo(l_mail_conn, smtp_server);
  utl_smtp.mail(l_mail_conn, x_mail_from);
  utl_smtp.rcpt(l_mail_conn, x_mail_to);
  utl_smtp.open_data(l_mail_conn );
  UTL_SMTP.WRITE_DATA(l_mail_conn, 'From' || ': ' || x_mail_from || UTL_TCP.CRLF);
  UTL_SMTP.WRITE_DATA(l_mail_conn, 'To' || ': ' || x_mail_to || UTL_TCP.CRLF);
  --UTL_SMTP.WRITE_DATA(l_mail_conn, 'CC' || ': ' || x_mail_cc || UTL_TCP.CRLF);
  UTL_SMTP.WRITE_DATA(l_mail_conn, 'Subject' || ': ' || NVL(x_mail_subject,'(no subject)') || UTL_TCP.CRLF);
  utl_smtp.write_data(l_mail_conn, x_mail_body);
  utl_smtp.close_data(l_mail_conn );
  utl_smtp.quit(l_mail_conn);
  --

  EXCEPTION
    WHEN OTHERS THEN
       INSERT INTO email_error VALUES ('ERROR AL ENVIAR MAIL DE GENERACION DE SUGERIDO', SYSDATE);

END;

--------------------------------------------------
---PROCEDIMIENTO PARA PROCESAR CON CLASIFICADOR---
--------------------------------------------------
PROCEDURE Principal ( gpv_cia    VARCHAR2,
                      gpv_prove  VARCHAR2,
                      gpv_marca  VARCHAR2,
                      gpv_crit   VARCHAR2,
                      gpv_clasIF VARCHAR2,
                      gpv_msg_error OUT VARCHAR2) IS

CURSOR c_prove IS
  SELECT no_prove, ind_nacional, clasificacion
    FROM arcpmp
   WHERE no_cia   = gpv_cia
     AND no_prove = nvl(gpv_prove,no_prove)
     AND NVL(bloqueado,'N')='N'
     AND NVL(clase,'99')='01'
     AND NVL(ind_nacional,'N') = 'N';

CURSOR C_items ( pv_prove VARCHAR2,
                 pv_nac   VARCHAR2 ) IS
  SELECT b.no_Cia,b.clase, b.categoria, b.no_Arti,
         a.ind_clasif,
         a.minimo, a.maximo, a.reorden reorden,
         NVL(a.pack,1) factor,
         SUM(nvl(b.sal_ant_un,0)+nvl(b.comp_un,0)+nvl(b.otrs_un,0)-nvl(b.cons_un,0)-nvl(b.vent_un,0)) stock
    FROM arinda a, arinma b, arinbo c, arincc cc, grupos g
   WHERE b.no_cia  = gpv_cia
     AND a.no_cia  = b.no_Cia
     AND a.no_Arti = b.no_Arti
     AND b.no_cia  = c.no_cia
     AND b.bodega  = c.codigo
    /* Grupo Contable no debe ser de Requision*/
     AND c.no_cia  = cc.no_cia
     AND c.codigo  = cc.bodega
     AND cc.no_cia = g.no_cia
     AND cc.grupo = g.grupo
     AND NVL(g.requisicion,'N') ='N'
    /* Se considera stock de estas tipo de bodegas*/
     AND (c.principal='S' or c.stand_by='S' or c.consignacion='S' or c.reserva='S' or c.devoluciones='S')
    /* Marca */
     AND a.marca = nvl(gpv_marca, marca)
     AND a.ind_clasIF = nvl(gpv_crit, a.ind_clasif)
    /* Clasificador */
     AND ( gpv_clasIF IS NULL OR
           ( gpv_clasIF IS NOT NULL
             AND EXISTS
                 ( SELECT NULL FROM arincl t
                    WHERE t.no_cia  = a.no_cia
                      AND t.no_arti = a.no_arti
                      AND t.tipo_clasIF = nvl(gpv_clasif, t.tipo_clasif)
                 )
           )
         )
          /* Proveedor */
     AND ( ( pv_nac = 'N' AND EXISTS
             ( SELECT NULL FROM arimprodu t
                WHERE t.no_cia = a.no_cia
                  AND t.no_arti = a.no_arti
                  AND t.no_prove = pv_prove
             )
           )
           OR
           ( pv_nac ='S' AND EXISTS
             ( SELECT NULL FROM tapprodu t
                WHERE t.no_cia = a.no_cia
                  AND t.no_arti = a.no_arti
                  AND NVL(p_principal,'N')='S'
                  AND t.no_prove = pv_prove
             )
           )
         )
   GROUP BY b.no_Cia, b.clase, b.categoria, b.no_Arti,
            a.ind_clasif,
            a.minimo, a.maximo, a.reorden, NVL(a.pack,1)
   ORDER BY B.no_Arti;

CURSOR C_bodega_principal IS
  SELECT codigo bodega, centro
    FROM arinbo b, arincc cc, grupos g
   WHERE b.no_cia    = gpv_cia
     AND b.centro    = '01'
     AND b.principal = 'S'
     AND b.no_cia  = cc.no_cia
     AND b.codigo  = cc.bodega
     AND cc.no_cia = g.no_cia
     AND cc.grupo = g.grupo
     AND NVL(g.requisicion,'N') ='N';

  Lc_bodega        C_bodega_principal%rowtype;
  Lb_Existe        boolean;
  Le_error         EXCEPTION;
  Lv_mensaje       VARCHAR2(200);
  Ln_Transito      NUMBER:=0;
  Ld_Transito_prov DATE;
  Ln_inventario    NUMBER:=0;
  Ln_pedido        NUMBER:=0;
  Ln_docu          NUMBER:=0;

  PROCEDURE grabar_cabebecera (cv_prove VARCHAR2) IS
  BEGIN
    SELECT arinenc_sugerid_seq.NEXTVAL@GPOETNET INTO Ln_docu FROM dual;

    INSERT INTO arinenc_sugerid
      (
        no_cia,
        no_docu,
        fecha,
        no_prove,
        estado
      )
    VALUES
      (
       gpv_cia,
       Ln_Docu,
       TRUNC(SYSDATE),
       cv_prove,
       'S'
      );
  END;

BEGIN
  OPEN  C_bodega_principal;
  FETCH C_bodega_principal INTO Lc_bodega;
  Lb_Existe := C_bodega_principal%FOUND;
  CLOSE C_bodega_principal;

  IF NOT Lb_Existe THEN
     Lv_Mensaje := 'No se ha encontrado Bodega principal';
     RAISE le_error;
  END IF;
  FOR reg IN C_PROVE LOOP
      BEGIN
        DELETE FROM arindet_sugerid a
         WHERE no_cia = gpv_cia
           AND EXISTS ( SELECT null
                          FROM arinenc_sugerid b
                         WHERE b.no_cia  = a.no_cia
                           AND b.no_docu = a.no_docu
                           AND b.no_prove = reg.no_prove
                           AND TRUNC(fecha) = TRUNC(SYSDATE)
                           AND b.estado = 'S'
                       );

        DELETE FROM arinenc_sugerid b
         WHERE no_cia   = gpv_cia
           AND no_prove = reg.no_prove
           AND fecha    = TRUNC(SYSDATE)
           AND estado   = 'S';
        EXCEPTION
          WHEN OTHERS THEN
               NULL;
      END;
      Lb_Existe := FALSE;
      FOR i IN C_items(reg.no_prove, reg.ind_nacional) LOOP

          Ld_Transito_Prov := pk_calculo_sugerido.compras_Transito_prov( gpv_cia,
                                                                         Lc_Bodega.bodega,
                                                                         '01',
                                                                         reg.No_Prove,
                                                                         Lv_Mensaje);

          IF Lv_mensaje IS NOT NULL THEN
             RAISE Le_Error;
          END IF;

          Ln_Transito:= pk_calculo_sugerido.compras_Transito( gpv_cia,
                                                              Lc_Bodega.bodega,
                                                              '01',
                                                              i.clase,
                                                              i.Categoria,
                                                              i.No_Arti,
                                                              reg.no_prove,
                                                              Lv_mensaje);

          IF Lv_mensaje IS NOT NULL THEN
             RAISE Le_Error;
          END IF;

          Ln_Inventario := NVL(Ln_Transito,0) + i.stock;

          IF (reg.clasificacion||i.ind_clasif) in ('AA','AB','AC','BA') THEN

             IF Ln_inventario <= i.reorden  THEN

                Ln_pedido:= (NVL(i.maximo,0)-Ln_inventario);

                IF Ln_pedido > 0 THEN
                   BEGIN
                     IF NOT Lb_Existe THEN
                        ---
                        ---Crea Cabecera
                        ---
                        grabar_cabebecera (reg.no_prove);
                        Lb_Existe := True;
                     END IF;

                     ----------------------------------
                     --Ajustando Cantidad Pedida a   --
                     --Unidades de Empaque Proveedor --
                     ----------------------------------
                     IF MOD(Ln_Pedido,i.factor)<> 0 THEN
                        Ln_Pedido := Ln_Pedido + (i.factor - MOD(Ln_Pedido,i.factor));
                     END IF;

                     INSERT INTO arindet_sugerid
                       (no_cia,
                        no_docu,
                        no_arti,
                        bodega,
                        sugerido,
                        confirmado)
                     VALUES
                       (gpv_cia,
                        Ln_docu,
                        i.no_Arti,
                        Lc_Bodega.bodega,
                        Ln_Pedido,
                        Ln_Pedido);

                     Lb_Existe := TRUE;
                     COMMIT;

                     EXCEPTION
                       WHEN OTHERS THEN
                            Lv_mensaje:= 'Error al crear detalle en arindet_sugerid ' || i.no_Arti || ' ' || sqlerrm;
                            raise Le_error;
                   END;
                END IF;
             END IF;
          ELSE
             Ln_pedido:= (nvl(i.maximo,0)-Ln_inventario);
             IF Ln_pedido > 0 THEN
                BEGIN
                  IF NOT Lb_Existe THEN
                     ---
                     ---Crea Cabecera
                     ---
                     grabar_cabebecera (reg.no_prove);
                     Lb_Existe := True;
                  END IF;
                  ----------------------------------
                  --Ajustando Cantidad Pedida a   --
                  --Unidades de Empaque Proveedor --
                  ----------------------------------
                  IF MOD(Ln_Pedido,i.factor)<> 0 THEN
                     Ln_Pedido := Ln_Pedido + (i.factor - MOD(Ln_Pedido,i.factor));
                  END IF;

                  INSERT INTO arindet_sugerid
                    (no_cia,
                     no_docu,
                     no_arti,
                     bodega,
                     sugerido,
                     confirmado)
                  VALUES
                    (gpv_cia,
                     Ln_docu,
                     i.no_Arti,
                     Lc_Bodega.bodega,
                     Ln_pedido,
                     Ln_pedido);

                  COMMIT;
                  Lb_Existe := TRUE;

                  EXCEPTION
                    WHEN OTHERS THEN
                         Lv_mensaje:= 'Error al crear detalle en arindet_sugerido ' || i.no_Arti || ' ' || sqlerrm;
                         RAISE Le_error;
                END;
             END IF;
          END IF;
      END LOOP;
      UPDATE arcpmp
         SET fecha_ult_rev  = TRUNC(SYSDATE),
             fecha_revision = TRUNC(SYSDATE) + (NVL(periodo_revision,1)*7)
       WHERE no_cia   = gpv_cia
         AND no_prove = reg.no_prove;

  END LOOP;
  EXCEPTION
    WHEN Le_Error THEN
         gpv_msg_error:= Lv_mensaje;
    WHEN OTHERS THEN
         gpv_msg_error := 'Error en Proceso Calculo Sugerido  ' || SQLERRM;
END Principal;


------------------------------------------------------------
---PROCEDIMIENTO PARA PROCESAR CON DIVISION Y SUBDIVISION---
------------------------------------------------------------
PROCEDURE Principal ( gpv_cia           VARCHAR2,
                      gpv_prove         VARCHAR2,
                      gpv_marca         VARCHAR2,
                      gpv_crit          VARCHAR2,
                      gpv_division      VARCHAR2,
                      gpv_subdivision   VARCHAR2,
                      gpv_tproceso      VARCHAR2,
                      gpv_msg_error OUT VARCHAR2) IS

CURSOR c_prove IS
  SELECT no_prove, ind_nacional, clasificacion
    FROM arcpmp
   WHERE no_cia   = gpv_cia
     AND no_prove = nvl(gpv_prove,no_prove)
     AND NVL(bloqueado,'N')='N'
     AND NVL(clase,'99')='01'
     AND NVL(ind_nacional,'N') = 'N'
     AND (gpv_tproceso='A' or NVL(fecha_ult_rev,to_date('01012008','ddmmyyyy')) + (nvl(periodo_revision,1)*7)<=trunc(sysdate));

CURSOR C_items ( pv_prove VARCHAR2,
                 pv_nac   VARCHAR2 ) IS
  SELECT b.no_Cia,b.clase, b.categoria, b.no_Arti,
         a.ind_clasif,
         a.minimo, a.maximo, a.reorden reorden,
         NVL(a.pack,1) factor,
         SUM(nvl(b.sal_ant_un,0)+nvl(b.comp_un,0)+nvl(b.otrs_un,0)-nvl(b.cons_un,0)-nvl(b.vent_un,0)) stock
    FROM arinda a, arinma b, arinbo c, arincc cc, grupos g
   WHERE b.no_cia  = gpv_cia
     AND a.no_cia  = b.no_Cia
     AND a.no_Arti = b.no_Arti
     AND b.no_cia  = c.no_cia
     AND b.bodega  = c.codigo
     AND a.tipo_asterisco NOT IN ('X','E','H')
    /* Grupo Contable no debe ser de Requision*/
     AND c.no_cia  = cc.no_cia
     AND c.codigo  = cc.bodega
     AND a.grupo   = cc.grupo
     AND cc.no_cia = g.no_cia
     AND cc.grupo = g.grupo
     AND NVL(g.requisicion,'N') ='N'
    /* Se considera stock de estas tipo de bodegas*/
      AND (c.principal='S' or c.stand_by='S' or c.consignacion='S' or c.reserva='S' or c.devoluciones='S' or c.transito='S')
    /* Marca */
     AND a.marca = nvl(gpv_marca, marca)
     AND a.ind_clasIF = nvl(gpv_crit, a.ind_clasif)
    /* Division y subdivision */
     AND a.division    = nvl(gpv_division,a.division)
     AND a.subdivision = nvl(gpv_subdivision,a.subdivision)

          /* Proveedor */
     AND ( ( pv_nac = 'N' AND EXISTS
             ( SELECT NULL FROM arimprodu t
                WHERE t.no_cia = a.no_cia
                  AND t.no_arti = a.no_arti
                  AND t.no_prove = pv_prove
             )
           )
           OR
           ( pv_nac ='S' AND EXISTS
             ( SELECT NULL FROM tapprodu t
                WHERE t.no_cia = a.no_cia
                  AND t.no_arti = a.no_arti
                  AND NVL(p_principal,'N')='S'
                  AND t.no_prove = pv_prove
             )
           )
         )
   GROUP BY b.no_Cia, b.clase, b.categoria, b.no_Arti,
            a.ind_clasif,
            a.minimo, a.maximo, a.reorden, NVL(a.pack,1)
   ORDER BY 5,4;

CURSOR C_bodega_principal IS
  SELECT codigo bodega, centro
    FROM arinbo b, arincc cc, grupos g
   WHERE b.no_cia    = gpv_cia
     AND b.centro    = '01'
     AND b.principal = 'S'
     AND b.no_cia  = cc.no_cia
     AND b.codigo  = cc.bodega
     AND cc.no_cia = g.no_cia
     AND cc.grupo = g.grupo
     AND NVL(g.requisicion,'N') ='N';

  Lc_bodega        C_bodega_principal%rowtype;
  Lb_Existe        boolean;
  Le_error         EXCEPTION;
  Lv_mensaje       VARCHAR2(200);
  Ln_Transito      NUMBER:=0;
  Ld_Transito_prov DATE;
  Ln_inventario    NUMBER:=0;
  Ln_pedido        NUMBER:=0;
  Ln_docu          NUMBER:=0;
  ln_Linea         NUMBER:=0;

  PROCEDURE grabar_cabebecera (cv_prove VARCHAR2) IS
  BEGIN
    SELECT arinenc_sugerid_seq.NEXTVAL@GPOETNET INTO Ln_docu FROM dual;

    INSERT INTO arinenc_sugerid
      (
        no_cia,
        no_docu,
        fecha,
        no_prove,
        estado
      )
    VALUES
      (
       gpv_cia,
       Ln_Docu,
       TRUNC(SYSDATE),
       cv_prove,
       'S'
      );
  END;

  PROCEDURE grabar_detalle (cv_docu VARCHAR2,
                            cn_linea NUMBER,
                            cv_arti VARCHAR2,
                            cv_criti VARCHAR2,
                            cv_bodega VARCHAR2,
                            cn_pedido NUMBER) IS
  BEGIN

    INSERT INTO arindet_sugerid
      (
        no_cia,
        no_docu,
        no_linea,
        no_arti,
        criticidad,
        bodega,
        sugerido,
        confirmado
      )
    VALUES
      (
        gpv_cia,
        cv_docu,
        cn_linea,
        cv_Arti,
        cv_criti,
        cv_bodega,
        cn_Pedido,
        cn_Pedido
      );
  END;


BEGIN
  OPEN  C_bodega_principal;
  FETCH C_bodega_principal INTO Lc_bodega;
  Lb_Existe := C_bodega_principal%FOUND;
  CLOSE C_bodega_principal;

  IF NOT Lb_Existe THEN
     Lv_Mensaje := 'No se ha encontrado Bodega principal';
     RAISE le_error;
  END IF;
  FOR reg IN C_PROVE LOOP
      BEGIN
        DELETE FROM arindet_sugerid a
         WHERE no_cia = gpv_cia
           AND EXISTS ( SELECT null
                          FROM arinenc_sugerid b
                         WHERE b.no_cia  = a.no_cia
                           AND b.no_docu = a.no_docu
                           AND b.no_prove = reg.no_prove
                           AND TRUNC(fecha) = TRUNC(SYSDATE)
                           AND b.estado = 'S'
                       );

        DELETE FROM arinenc_sugerid b
         WHERE no_cia   = gpv_cia
           AND no_prove = reg.no_prove
           AND fecha    = TRUNC(SYSDATE)
           AND estado   = 'S';
        EXCEPTION
          WHEN OTHERS THEN
               NULL;
      END;
      BEGIN
        UPDATE arinenc_sugerid b
           SET estado = 'X', fecha_no_revisado=sysdate
         WHERE no_cia   = gpv_cia
           AND no_prove = reg.no_prove
           AND fecha    < TRUNC(SYSDATE)
           AND estado   = 'S';
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
               NULL;
          WHEN OTHERS THEN
               NULL;

      END;
      Lb_Existe := FALSE;
      ln_linea  := 0;

      FOR i IN C_items(reg.no_prove, reg.ind_nacional) LOOP
          BEGIN
            IF NOT Lb_Existe THEN
               ---
               ---Crea Cabecera
               ---
               grabar_cabebecera (reg.no_prove);
               Lb_Existe := True;
            END IF;
          END;


          Ld_Transito_Prov := pk_calculo_sugerido.compras_Transito_prov( gpv_cia,
                                                                         Lc_Bodega.bodega,
                                                                         '01',
                                                                         reg.No_Prove,
                                                                         Lv_Mensaje);

          IF Lv_mensaje IS NOT NULL THEN
             RAISE Le_Error;
          END IF;

          Ln_Transito:= pk_calculo_sugerido.compras_Transito( gpv_cia,
                                                              Lc_Bodega.bodega,
                                                              '01',
                                                              i.clase,
                                                              i.Categoria,
                                                              i.No_Arti,
                                                              reg.no_prove,
                                                              Lv_mensaje);

          IF Lv_mensaje IS NOT NULL THEN
             RAISE Le_Error;
          END IF;

          Ln_Inventario := NVL(Ln_Transito,0) + i.stock;

          IF (reg.clasificacion||i.ind_clasif) in ('AA','AB','BA') THEN

             IF Ln_inventario <= i.reorden  THEN

                Ln_pedido:= (NVL(i.maximo,0)-Ln_inventario);

                IF Ln_pedido > 0 THEN
                   BEGIN
                     ------------------------------------
                     ---Ajustando Cantidad Pedida a   ---
                     ---Unidades de Empaque Proveedor ---
                     ------------------------------------
                     ---Comentado el 6 de agosto del 2009
                     ---Las unidades se ajustaran en la
                     ---pantalla de revision de sugeridos

                     ln_linea := ln_linea + 1;
                     grabar_detalle (Ln_docu,
                                     Ln_linea,
                                     i.no_Arti,
                                     (reg.clasificacion||i.ind_clasif),
                                     Lc_Bodega.bodega,
                                     Ln_Pedido);

                     Lb_Existe := TRUE;
                     COMMIT;

                     EXCEPTION
                       WHEN OTHERS THEN
                            Lv_mensaje:= 'Error al crear detalle en arindet_sugerid ' || i.no_Arti || ' ' || sqlerrm;
                            raise Le_error;
                   END;
                END IF;
             END IF;
          ELSE
             Ln_pedido:= (nvl(i.maximo,0)-Ln_inventario);
             IF Ln_pedido > 0 THEN
                BEGIN
                  IF NOT Lb_Existe THEN
                     ---
                     ---Crea Cabecera
                     ---
                     grabar_cabebecera (reg.no_prove);
                     Lb_Existe := True;
                  END IF;
                  ----------------------------------
                  --Ajustando Cantidad Pedida a   --
                  --Unidades de Empaque Proveedor --
                  ----------------------------------
                  ---Comentado el 6 de agosto del 2009
                  ---Las unidades se ajustaran en la
                  ---pantalla de revision de sugeridos

                  ln_linea := ln_linea + 1;
                  grabar_detalle (Ln_docu,
                                  ln_Linea,
                                  i.no_Arti,
                                  (reg.clasificacion||i.ind_clasif),
                                  Lc_Bodega.bodega,
                                  Ln_Pedido);

                  COMMIT;
                  Lb_Existe := TRUE;

                  EXCEPTION
                    WHEN OTHERS THEN
                         Lv_mensaje:= 'Error al crear detalle en arindet_sugerido ' || i.no_Arti || ' ' || sqlerrm;
                         RAISE Le_error;
                END;
             END IF;
          END IF;
      END LOOP;

         UPDATE arcpmp
            SET fecha_ult_rev  = TRUNC(SYSDATE),
                fecha_revision = TRUNC(SYSDATE) + (NVL(periodo_revision,1)*7)
          WHERE no_cia   = gpv_cia
            AND no_prove = reg.no_prove;

  END LOOP;
  EXCEPTION
    WHEN Le_Error THEN
         gpv_msg_error:= Lv_mensaje;
    WHEN OTHERS THEN
         gpv_msg_error := 'Error en Proceso Calculo Sugerido  ' || SQLERRM;
END Principal;


PROCEDURE CONTROL is

  Lv_msg_Error VARCHAR2(1000);
  Le_error     EXCEPTION ;
  gpv_Cia      VARCHAR2(2);
  Lv_detalle   VARCHAR2(1000);

CURSOR C_EMPL_PROV IS
  SELECT DISTINCT u.no_emple, e.mail correo
    FROM arcpmp_usuarios u, arplme e, arinenc_sugerid s
   WHERE u.no_cia   = e.no_cia
     AND u.no_emple = e.no_emple
     AND u.no_cia   = s.no_cia
     AND u.no_prove = s.no_prove
     AND s.fecha    = TRUNC(SYSDATE)
     AND s.estado   = 'S'
     AND u.no_cia   = gpv_Cia
     AND u.ind_principal = 'S';

CURSOR C_PED_EMPL ( Pv_Emple VARCHAR2) IS
  SELECT s.no_docu, s.no_prove, p.nombre
    FROM arcpmp_usuarios u, arinenc_sugerid s, arcpmp p
   WHERE u.no_cia   = s.no_cia
     AND u.no_prove = s.no_prove
     AND s.no_cia   = p.no_cia
     AND s.no_prove = p.no_prove
     AND s.fecha    = TRUNC(SYSDATE)
     AND s.estado   = 'S'
     AND u.no_cia   = gpv_Cia
     AND u.no_emple = Pv_Emple
     AND u.ind_principal = 'S';

BEGIN
  gpv_cia:='01';
  pk_calculo_sugerido.principal(gpv_cia,null,null,null,null,null,'T',Lv_msg_error);

  IF Lv_msg_error IS NOT NULL THEN
     RAISE Le_error;
  END IF;

  COMMIT;

  -----------------------------------------------------------
  ---Enviando Correo de Notificacion de Sugerido Gewnerado---
  -----------------------------------------------------------
  Lv_Detalle := ' ';
  FOR reg IN C_EMPL_PROV LOOP
      Lv_Detalle := Null;
      FOR dat IN C_PED_EMPL(reg.no_emple) LOOP
          Lv_Detalle := Lv_detalle || 'Doc: '||dat.no_docu||', Prove: '|| dat.no_prove||'-'||dat.nombre||UTL_TCP.CRLF;
      END LOOP;

      Envia_Mail ( Pv_origen  => 'manuel.yuquilima@lhenriques.com',
                   Pv_Destino => reg.correo,
                   Pv_Subject => 'Modelo de Inventario - Generacion Automatica de Sugerido',
                   Pv_Mensaje => Lv_detalle);

      Envia_Mail ( Pv_origen  => reg.correo,
                   Pv_Destino => 'manuel.yuquilima@lhenriques.com',
                   Pv_Subject => 'Modelo de Inventario - Generacion Automatica de Sugerido',
                   Pv_Mensaje => Lv_detalle);

  END LOOP;

  COMMIT;

  EXCEPTION
    when Le_error THEN
         ROLLBACK;
         Lv_msg_error := 'ERROR ' || Lv_msg_error;
    when others THEN
         ROLLBACK;
         Lv_msg_error := 'ERROR EN PROCESO CONTROL ' || SQLERRM;
END;

end PK_CALCULO_SUGERIDO;
/
