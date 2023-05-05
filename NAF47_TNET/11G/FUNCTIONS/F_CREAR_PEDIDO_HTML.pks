create or replace function            F_CREAR_PEDIDO_HTML(pCia IN VARCHAR2, pPedido NUMBER) return varchar2 is


  CURSOR C_CABECERA IS
SELECT B.NOMBRE_LARGO, A.OBSERVACIONES, To_Char(SYSDATE, 'YYYY/MM/DD')
FROM ARIMENCPEDIDO A, ARCPMP B
WHERE A.NO_CIA = B.NO_CIA
      AND A.NO_PROVE = B.NO_PROVE
      AND A.NO_CIA = pCia
      AND A.NO_PEDIDO = pPedido;

CURSOR C_DETALLE IS
SELECT A.NO_ARTI, Nvl(B.COD_ART_PROV, ' ') COD_ART_PROV, d.NOMBRE, A.CANTIDAD_PEDIDA
FROM ARIMDETPEDIDO A, ARIMPRODU B, ARIMENCPEDIDO C, arcpmp d
WHERE A.NO_CIA = B.NO_CIA
      AND B.NO_CIA = C.NO_CIA
      AND C.NO_PROVE = B.NO_PROVE
      AND A.NO_ARTI = B.NO_ARTI
      AND A.NO_CIA = C.NO_CIA
      AND A.NO_PEDIDO = C.NO_PEDIDO
      AND b.no_cia = d.no_cia
      AND b.no_prove = d.no_prove
      AND A.NO_CIA = pCia
      AND A.NO_PEDIDO = pPedido;

vFecha  VARCHAR2(10);
vNombre  ARCPMP.NOMBRE_LARGO%TYPE;
vObservaciones  ARIMENCPEDIDO.OBSERVACIONES%TYPE;
vHTML VARCHAR2(3000);
vTotal NUMBER;
BEGIN
  vHTML := '<table border=1 width=500px heigth= 100%>
<tr><td ALIGN = "CENTER" VALIGN="CENTER"><img align="absmiddle" WIDTH=120 HEIGHT=50 src="q:/comun/logo/logo.jpg"/>
</td><td WIDTH=350><h4>PROVEEDOR:</h4>';
  OPEN C_CABECERA;
  FETCH C_CABECERA INTO vNombre, vObservaciones, vFecha;
  IF C_CABECERA%NOTFOUND THEN
    RETURN NULL;
  END IF;
  CLOSE C_CABECERA;
  vHTML := vHTML||vNombre||'</td>
    <td WIDTH=100><h4>FECHA DE ENVIO:</h4>'||vFecha||'</td>
    </tr>
    <tr>
    <td WIDTH=500 colspan=3>
    <h4>OBSERVACIONES:</h4>'||vObservaciones||'</td>
    </tr>
    <tr>
    <th>ARTICULO</th>
    <th>DESRIPCION</th>
    <th>CANTIDAD</th>
    </tr>
  ';
  vTotal := 0;
  FOR I IN C_DETALLE LOOP
       vHTML:=vHTML||'<TR><TD>'||I.COD_ART_PROV||'</TD><TD>'||I.NOMBRE||'</TD><TD>'||I.CANTIDAD_PEDIDA||'</TD></TR>';
       vTotal:=vTotal + I.CANTIDAD_PEDIDA;
  END LOOP;
vHTML:=vHTML||'<TR>
<td></td>
<td ALINGN = "CENTER"><H4>TOTAL:</H4></td>
<td><h4>'||vTotal||'</h4></td>
</TR>
</table>';
RETURN vHTML;

end F_CREAR_PEDIDO_HTML;