create or replace PROCEDURE            falibro_ventas (
  pNo_cia     IN     varchar2,
  pTipo_doc   IN     varchar2,
  pNo_docu    IN     varchar2,
  pError      IN OUT varchar2
) IS
  -- ---
  -- **
  -- NOTAS IMPORTANTES:
  --    1. El que llame a este procedimiento debe haber inicializado el PAQUETE MONEDA,
  --       pues se utiliza la funcion redondeo
  --    2. El libro de ventas se registra en NOMINAL
  --
  --
  CURSOR c_documentos (pCia  varchar2, pTipo varchar2, pDocu varchar2) IS
     SELECT mc.nombre, mc.codigo_tercero,
            fe.fecha, fe.moneda, fe.tipo_cambio,
            fe.monto_bienes, fe.monto_serv, fe.monto_exportac
       FROM arccmc mc, arfafe fe
      WHERE mc.no_cia      = pCia
        AND mc.no_cia      = fe.no_cia
        AND mc.grupo       = fe.grupo
        AND mc.no_cliente  = fe.no_cliente
        AND fe.tipo_doc    = pTipo
        AND fe.no_factu    = pDocu;
  --

  CURSOR c_Mtos_Doc (pCia varchar2, pTipo varchar2, pDocu varchar2) IS
     SELECT sum(decode(i_ven, 'S', (nvl(total,0) - nvl(descuento,0)), 0) ) gravado,
            sum(decode(i_ven, 'S', 0, (nvl(total,0) - nvl(descuento,0))) ) exento
       FROM Arfafl
      WHERE no_cia    = pCia
        AND tipo_doc  = pTipo
        AND no_factu  = pDocu;
  --
  CURSOR c_impuestos (pCia varchar2,  pTipo varchar2,  pDocu varchar2) IS
     SELECT sum(nvl(decode(columna, 1, monto_imp, 0), 0)) imp1,
            sum(nvl(decode(columna, 2, monto_imp, 0), 0)) imp2,
            sum(nvl(decode(columna, 3, monto_imp, 0), 0)) imp3,
            sum(nvl(decode(columna, 4, monto_imp, 0), 0)) imp4,
            sum(nvl(decode(columna, 5, monto_imp, 0), 0)) imp5,
            sum(nvl(decode(columna, 6, monto_imp, 0), 0)) imp6
       FROM arfafli
      WHERE no_cia    = pCia
        AND tipo_doc  = pTipo
        AND no_factu  = pDocu;
  --
  vReg_Imp         c_impuestos%rowtype;
  vReg_Doc         c_documentos%rowtype;
  vReg_Mto         c_Mtos_Doc%rowtype;
  error_proceso	   exception;
  vFound           boolean;
  --
BEGIN
  pError := NULL;
  OPEN  c_documentos (pNo_Cia, pTipo_Doc, pNo_Docu);
  FETCH c_documentos INTO vReg_Doc;
  vFound := c_documentos%FOUND;
  CLOSE c_documentos;
  --
  IF NOT vFound  THEN
    pError := 'ERROR AL INSERTAR EN LIBRO DE VENTAS : Documento No Encontrado ('||pTipo_doc||' '||pNo_docu||')';
    RAISE error_proceso;
  ELSE
    --
    OPEN  c_Mtos_Doc (pNo_Cia, pTipo_Doc, pNo_Docu);
    FETCH c_Mtos_Doc INTO vReg_Mto;
    vFound := c_Mtos_Doc%FOUND;
    CLOSE c_Mtos_Doc;
    --
    IF NOT vFound THEN
      pError := 'ERROR Libro de Ventas: Montos de Documento';
      RAISE error_proceso;
    ELSE
      OPEN  c_impuestos (pNo_Cia, pTipo_Doc, pNo_Docu);
      FETCH c_impuestos INTO vReg_Imp;
      CLOSE c_impuestos;
      --
      -- convierte montos a nominal antes de insertarlos en el libro.
      IF vReg_doc.moneda = 'D' THEN
        vReg_mto.gravado        := moneda.redondeo(vReg_mto.gravado * vReg_doc.tipo_cambio, 'P');
        vReg_mto.exento         := moneda.redondeo(vReg_mto.exento  * vReg_doc.tipo_cambio, 'P');
        vReg_doc.monto_bienes   := moneda.redondeo(vReg_doc.monto_bienes  * vReg_doc.tipo_cambio, 'P');
        vReg_doc.monto_serv     := moneda.redondeo(vReg_doc.monto_serv  * vReg_doc.tipo_cambio, 'P');
        vReg_doc.monto_exportac := moneda.redondeo(vReg_doc.monto_exportac * vReg_doc.tipo_cambio, 'P');
        vReg_imp.imp1           := moneda.redondeo(vReg_imp.imp1 * vReg_doc.tipo_cambio, 'P');
        vReg_imp.imp2           := moneda.redondeo(vReg_imp.imp2 * vReg_doc.tipo_cambio, 'P');
        vReg_imp.imp3           := moneda.redondeo(vReg_imp.imp3 * vReg_doc.tipo_cambio, 'P');
        vReg_imp.imp4           := moneda.redondeo(vReg_imp.imp4 * vReg_doc.tipo_cambio, 'P');
        vReg_imp.imp5           := moneda.redondeo(vReg_imp.imp5 * vReg_doc.tipo_cambio, 'P');
        vReg_imp.imp6           := moneda.redondeo(vReg_imp.imp6 * vReg_doc.tipo_cambio, 'P');
      END IF;
      --
      INSERT INTO ARCGLVE (No_cia,        codigo_tercero,
                           Tipo_Doc,      No_Docu,
                           Fecha,         Nombre,
                           Valor_Gravado, Valor_Exento,
                           monto_bienes,  monto_serv, monto_exportac,
                           Valor_Imp1,    Valor_Imp2,
                           Valor_Imp3,    Valor_Imp4,
                           Valor_Imp5,    Valor_Imp6,
                           Ano,           Mes,
                           Total)
                   VALUES (pNo_Cia, vReg_Doc.codigo_tercero,
                           pTipo_Doc, pNo_Docu,
                           vReg_Doc.fecha, vReg_Doc.nombre,
                           vReg_Mto.gravado, vReg_Mto.exento,
                           vReg_doc.monto_bienes, vReg_doc.monto_serv, vReg_doc.monto_exportac,
                           nvl(vReg_Imp.imp1,0),  nvl(vReg_Imp.imp2,0),
                           nvl(vReg_Imp.imp3,0),  nvl(vReg_Imp.imp4,0),
                           nvl(vReg_Imp.imp5,0),  nvl(vReg_Imp.imp6,0),
                           to_number(to_char(vReg_Doc.fecha, 'RRRR')),
                           to_number(to_char(vReg_Doc.fecha, 'MM')),
                           vReg_Mto.gravado + vReg_Mto.exento +
                           nvl(vReg_Imp.imp1,0) + nvl(vReg_Imp.imp2,0) + nvl(vReg_Imp.imp3,0) +
                           nvl(vReg_Imp.imp4,0) + nvl(vReg_Imp.imp5,0) + nvl(vReg_Imp.imp6,0));
    END IF;
  END IF;
EXCEPTION
  WHEN error_proceso THEN
       pError := 'FALIBRO_VENTAS : '||pError;
       return;
  WHEN others THEN
       pError := 'FALIBRO_VENTAS : '||sqlerrm;
       return;
END FALIBRO_VENTAS;