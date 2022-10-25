/**
 * DEBE EJECUTARSE EN DB_COMERCIAL
 * Rollback de Terminos y Condiciones
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 07-07-2022 - Versión Inicial.
 */
SET SERVEROUTPUT ON ;
 
DECLARE
    bada clob:=' ';
BEGIN
DBMS_LOB.APPEND(bada, '<p class="paragraph" align="center" style="text-align:center;vertical-align:baseline">
<p class="paragraph" align="center" style="text-align:center;vertical-align:baseline">
  <span class="normaltextrun">
    <b>
      <span style="font-size:18.0pt;color:black">CONDICIONES DE USO PRODUCTO NETLIFE ASSISTANCE PRO</span>
    </b>
  </span>
  <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335551550'||chr(38)||'quot;:2,'||chr(38)||'quot;335551620'||chr(38)||'quot;:2,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">
    <span class="eop">
      <span style="font-size:18.0pt;color:black">'||chr(38)||'nbsp;</span>
    </span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="text-align:justify;vertical-align:baseline" paraid="886237179" paraeid="{ab5de48e-4df6-4bf1-9688-2898fba61d8b}{222}">
  <span data-contrast="auto" xml:lang="ES-EC">
    <span class="normaltextrun">
      <b>
        <span style="font-size:13.5pt;color:black">Netlife Assistance PRO</span>
      </b>
    </span>
  </span>
  <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">
    <span class="eop">
      <span style="font-size:13.5pt;color:black">'||chr(38)||'nbsp;</span>
    </span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="text-align:justify;vertical-align:baseline" paraid="851691" paraeid="{ab5de48e-4df6-4bf1-9688-2898fba61d8b}{238}">
  <span data-contrast="auto" xml:lang="ES-EC">
    <span class="normaltextrun">Netlife Assistance Pro es un servicio que brinda soluciones a los problemas técnicos e informáticos de un negocio para mejorar su operación, disponible para 5 usuarios. Para acceder a él es necesario ingresar dentro de la sección “Netlife Access” en la página web de Netlife o a store.netlife.net.ec</span>
  </span>
  <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">
    <span class="eop">'||chr(38)||'nbsp;</span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="text-align:justify;vertical-align:baseline" paraid="228338338" paraeid="{ab5de48e-4df6-4bf1-9688-2898fba61d8b}{250}">
  <span data-contrast="none" xml:lang="ES-EC">
    <span class="normaltextrun">
      <b>
        <span style="color:black">Este servicio incluye:</span>
      </b>
    </span>
  </span>
  <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">
    <span class="eop">
      <span style="color:black">'||chr(38)||'nbsp;</span>
    </span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l7 level1 lfo1;tab-stops:list 36.0pt;vertical-align:baseline" paraid="991703357" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{1}">
  <span data-contrast="auto" xml:lang="ES-EC">
    <!--[if !supportLists]-->
    <span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol">
      <span style="mso-list:Ignore">· <span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp; </span>
      </span>
    </span>
    <!--[endif]-->
    <span class="normaltextrun">Asistencia guiada de configuración, sincronización y conexión a red de software o hardware: PC, MAC.</span>
  </span>
  <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">
    <span class="eop">'||chr(38)||'nbsp;</span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l7 level1 lfo1;tab-stops:list 36.0pt;vertical-align:baseline" paraid="1134155004" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{8}">
  <span data-contrast="auto" xml:lang="ES-EC">
    <!--[if !supportLists]-->
    <span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol">
      <span style="mso-list:Ignore">· <span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp; </span>
      </span>
    </span>
    <!--[endif]-->
    <span class="normaltextrun">Revisión, análisis y mantenimiento del PC/MAC/LINUX/SmartTV/Smartphones/Tablets/Apple TV/Roku, etc.</span>
  </span>
  <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">
    <span class="eop">'||chr(38)||'nbsp;</span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l6 level1 lfo2;tab-stops:list 36.0pt;vertical-align:baseline" paraid="2139920235" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{23}">
  <span data-contrast="auto" xml:lang="ES-EC">
    <!--[if !supportLists]-->
    <span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol">
      <span style="mso-list:Ignore">· <span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp; </span>
      </span>
    </span>
    <!--[endif]-->
    <span class="normaltextrun">Asesoría técnica en línea las 24 horas vía telefónica o web por </span>
  </span>
  <a href="https://store.netlife.net.ec" target="_blank" style="color:inherit">
    <span class="normaltextrun">
      <span style="color:blue;text-decoration:none;text-underline:
none">
        <span data-contrast="none" xml:lang="ES-EC">store.netlife.net.ec.'||chr(38)||'nbsp;</span>
      </span>
    </span>
  </a>
  <span class="eop">
    <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">'||chr(38)||'nbsp;</span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l6 level1 lfo2;tab-stops:list 36.0pt;vertical-align:baseline" paraid="1335481814" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{33}">
  <span data-contrast="auto" xml:lang="ES-EC">
    <!--[if !supportLists]-->
    <span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol">
      <span style="mso-list:Ignore">· <span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp; </span>
      </span>
    </span>
    <!--[endif]-->
    <span class="normaltextrun">Un servicio de Help Desk con ingenieros especialistas.</span>
  </span>
  <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">
    <span class="eop">'||chr(38)||'nbsp;</span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l6 level1 lfo2;tab-stops:list 36.0pt;vertical-align:baseline" paraid="1538086712" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{48}">
  <span data-contrast="auto" xml:lang="ES-EC">
    <!--[if !supportLists]-->
    <span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol">
      <span style="mso-list:Ignore">· <span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp; </span>
      </span>
    </span>
    <!--[endif]-->
    <span class="normaltextrun">Se puede ayudar a reinstalar el Sistema Operativo del dispositivo del cliente, siempre y cuando se disponga de las licencias y medios de instalación originales correspondientes.</span>
  </span>
  <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">
    <span class="eop">'||chr(38)||'nbsp;</span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="text-align:justify;vertical-align:baseline" paraid="603451248" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{55}">
  <span data-contrast="none" xml:lang="ES-EC">
    <span class="normaltextrun">
      <b>
        <span style="color:black">Sistemas Operativos sobre los cuales se brinda soporte a incidencias son:'||chr(38)||'nbsp;</span>
      </b>
    </span>
  </span>
  <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">
    <span class="eop">
      <span style="color:black">'||chr(38)||'nbsp;</span>
    </span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l3 level1 lfo3;tab-stops:list 36.0pt;vertical-align:baseline" paraid="2041146197" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{61}">
  <span data-contrast="auto" xml:lang="ES-EC">
    <!--[if !supportLists]-->
    <span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol">
      <span style="mso-list:Ignore">· <span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp; </span>
      </span>
    </span>
    <!--[endif]-->
    <span class="normaltextrun">Windows: XP hasta 10, Windows Server: 2003 hasta 2019, MacOs: 10.6 (Snow Leopard) hasta 10.14 (Mojave), Linux: Ubuntu 19.04, Fedora 30, Open SUSE 15.1, Debian 10.0, Red Hat 8, CentOS 7, iOS: 7.1.2 a 12.3.2, Android: Ice Cream Sandwich 4.0 hasta Pie 9.0, Windows Phone OS: 8.0 hasta 10 Mobile</span>
  </span>
  <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">
    <span class="eop">'||chr(38)||'nbsp;</span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="text-align:justify;vertical-align:baseline" paraid="1938267981" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{92}">
  <span data-contrast="none" xml:lang="ES-EC">
    <span class="normaltextrun">
      <b>
        <span style="color:black">Asistencia Hardware:'||chr(38)||'nbsp;</span>
      </b>
    </span>
  </span>
  <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">
    <span class="eop">
      <span style="color:black">'||chr(38)||'nbsp;</span>
    </span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l5 level1 lfo4;tab-stops:list 36.0pt;vertical-align:baseline" paraid="888618468" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{98}">
  <span data-contrast="auto" xml:lang="ES-EC">
    <!--[if !supportLists]-->
    <span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol">
      <span style="mso-list:Ignore">· <span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp; </span>
      </span>
    </span>
    <!--[endif]-->
    <span class="normaltextrun">Los controladores o software necesarios para el funcionamiento del hardware son responsabilidad del usuario, sin embargo, se dará apoyo para obtenerlos en caso de ser necesario.</span>
  </span>
  <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">
    <span class="eop">'||chr(38)||'nbsp;</span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="text-align:justify;vertical-align:baseline" paraid="202253179" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{105}">
  <span data-contrast="none" xml:lang="ES-EC">
    <span class="normaltextrun">
      <b>
        <span style="color:black">Asistencia Software:</span>
      </b>
    </span>
  </span>
  <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">
    <span class="eop">
      <span style="color:black">'||chr(38)||'nbsp;</span>
    </span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l1 level1 lfo5;tab-stops:list 36.0pt;vertical-align:baseline" paraid="359914594" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{111}">
  <span data-contrast="auto" xml:lang="ES-EC">
    <!--[if !supportLists]-->
    <span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol">
      <span style="mso-list:Ignore">· <span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp; </span>
      </span>
    </span>
    <!--[endif]-->
    <span class="normaltextrun">No incluye capacitación en el uso del Software. Las licencias y medios de instalación son a cargo del usuario. Nunca se prestará ayuda sobre software ilegal.</span>
  </span>
  <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">
    <span class="eop">'||chr(38)||'nbsp;</span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l1 level1 lfo5;tab-stops:list 36.0pt;vertical-align:baseline" paraid="416966146" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{118}">
  <span data-contrast="auto" xml:lang="ES-EC">
    <!--[if !supportLists]-->
    <span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol">
      <span style="mso-list:Ignore">· <span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp; </span>
      </span>
    </span>
    <!--[endif]-->
    <span class="normaltextrun">No incluye capacitación en el uso del Sistema Operativo y software, únicamente se solucionarán incidencias puntuales.</span>
  </span>
  <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">
    <span class="eop">'||chr(38)||'nbsp;</span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="text-align:justify;vertical-align:baseline" paraid="227023966" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{125}">
  <span data-contrast="none" xml:lang="ES-EC">
    <span class="normaltextrun">
      <b>
        <span style="color:black">Para recibir asistencia se dispone de 3(TRES) canales de atención habilitados las 24(VEINTI CUATRO) horas del día:'||chr(38)||'nbsp;</span>
      </b>
    </span>
  </span>
  <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">
    <span class="eop">
      <span style="color:black">'||chr(38)||'nbsp;</span>
    </span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l8 level1 lfo6;tab-stops:list 36.0pt;vertical-align:baseline" paraid="968161823" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{131}">
  <span data-contrast="auto" xml:lang="ES-EC">
    <!--[if !supportLists]-->
    <span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol">
      <span style="mso-list:Ignore">· <span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp; </span>
      </span>
    </span>
    <!--[endif]-->
    <span class="normaltextrun">Chat, llamada telefónica y correo electrónico.</span>
  </span>
  <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">
    <span class="eop">'||chr(38)||'nbsp;</span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="text-align:justify;vertical-align:baseline" paraid="1860977929" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{138}">
  <span data-contrast="none" xml:lang="ES-EC">
    <span class="normaltextrun">
      <b>
        <span style="color:black">El tiempo de atención de los distintos canales son:</span>
      </b>
    </span>
  </span>
  <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">
    <span class="eop">
      <span style="color:black">'||chr(38)||'nbsp;</span>
    </span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l4 level1 lfo7;tab-stops:list 36.0pt;vertical-align:baseline" paraid="2032228591" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{144}">
  <span data-contrast="auto" xml:lang="ES-EC">
    <!--[if !supportLists]-->
    <span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol">
      <span style="mso-list:Ignore">· <span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp; </span>
      </span>
    </span>
    <!--[endif]-->
    <span class="normaltextrun">Chat 30(TREINTA) segundos, vía telefónica 60(SESENTA) segundos (3920000), y vía correo electrónico 20(VEINTE) minutos (</span>
  </span>
  <a href="mailto:soporte@store.netlife.net.ec" target="_blank" style="color:inherit">
    <span class="normaltextrun">
      <span style="color:blue;text-decoration:none;text-underline:
none">
        <span data-contrast="none" xml:lang="ES-EC">soporte@store.netlife.net.ec</span>
      </span>
    </span>
  </a>
  <span data-contrast="auto" xml:lang="ES-EC">
    <span class="normaltextrun">)</span>
  </span>
  <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">
    <span class="eop">'||chr(38)||'nbsp;</span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l4 level1 lfo7;tab-stops:list 36.0pt;vertical-align:baseline" paraid="257807352" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{156}">
  <span data-contrast="auto" xml:lang="ES-EC">
    <!--[if !supportLists]-->
    <span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol">
      <span style="mso-list:Ignore">· <span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp; </span>
      </span>
    </span>
    <!--[endif]-->
    <span class="normaltextrun">Se mantendrá en la plataforma durante 60(SESENTA) días, el 100% de las conversaciones chat levantadas vía web; a través de, </span>
  </span>
  <a href="https://store.netlife.net.ec" target="_blank" style="color:inherit">
    <span class="normaltextrun">
      <span style="color:blue;text-decoration:none;text-underline:
none">
        <span data-contrast="none" xml:lang="ES-EC">store.netlife.net.ec</span>
      </span>
    </span>
  </a>
  <span class="eop">
    <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">'||chr(38)||'nbsp;</span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="text-align:justify;vertical-align:baseline" paraid="496603241" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{166}">
  <span data-contrast="none" xml:lang="ES-EC">
    <span class="normaltextrun">
      <b>
        <span style="color:black">Netlife Assistance Pro como servicio adicional</span>
      </b>
    </span>
  </span>
  <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">
    <span class="eop">
      <span style="color:black">'||chr(38)||'nbsp;</span>
    </span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l0 level1 lfo8;tab-stops:list 36.0pt;vertical-align:baseline" paraid="658887239" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{178}">
  <span data-contrast="auto" xml:lang="ES-EC">
    <!--[if !supportLists]-->
    <span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol">
      <span style="mso-list:Ignore">· <span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp; </span>
      </span>
    </span>
    <!--[endif]-->
    <span class="normaltextrun">Tiene un precio de $2,99(DOS DÓLARES DE LOS ESTADOS UNIDOS DE AMÉRICA CON 99/100) más IVA mensual, que se añade a planes de Internet de Netlife.</span>
  </span>
  <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">
    <span class="eop">'||chr(38)||'nbsp;</span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l0 level1 lfo8;tab-stops:list 36.0pt;vertical-align:baseline" paraid="1684847273" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{195}">
  <span data-contrast="auto" xml:lang="ES-EC">
    <!--[if !supportLists]-->
    <span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol">
      <span style="mso-list:Ignore">· <span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp; </span>
      </span>
    </span>
    <!--[endif]-->
    <span class="normaltextrun">El primer mes de servicio, el cliente no pagará el valor total, sino el valor proporcional por el tiempo que haya recibido el servicio de acuerdo con su ciclo de facturación </span>
    <span data-contrast="auto" xml:lang="ES-EC">(Ciclo 1: Del 1 al 30 del mes, Ciclo 2: Del 15 al 14 del mes siguiente o Ciclo 3: Del 8 al 7 del mes siguiente).</span>
  </span>
  <span data-ccp-props="{'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">
    <span class="eop">'||chr(38)||'nbsp;</span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l0 level1 lfo8;tab-stops:list 36.0pt;vertical-align:baseline" paraid="940775022" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{204}">
  <span data-contrast="auto" xml:lang="ES-EC">
    <!--[if !supportLists]-->
    <span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol">
      <span style="mso-list:Ignore">· <span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp; </span>
      </span>
    </span>
    <!--[endif]-->
    <span class="normaltextrun">El servicio tiene un tiempo de permanencia mínima de 12(DOCE) meses. En caso de cancelación anticipada aplica el pago de los descuentos a los que haya accedido el cliente por promociones, tales como instalación, tarifas preferenciales, etc.</span>
  </span>
  <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335551550'||chr(38)||'quot;:6,'||chr(38)||'quot;335551620'||chr(38)||'quot;:6,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">
    <span class="eop">'||chr(38)||'nbsp;</span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l0 level1 lfo8;tab-stops:list 36.0pt;vertical-align:baseline" paraid="2133746300" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{213}">
  <span data-contrast="auto" xml:lang="ES-EC">
    <!--[if !supportLists]-->
    <span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol">
      <span style="mso-list:Ignore">· <span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp; </span>
      </span>
    </span>
    <!--[endif]-->
    <span class="normaltextrun">El servicio de Netlife Assistance Pro, no incluye visitas presenciales, pero si el cliente lo requiere podrá coordinar dichas visitas por un costo adicional de $30(TREINTA DÓLARES DE LOS ESTADOS UNIDOS DE AMÉRICA) más IVA en ciudad y $35(TREINTA DÓLARES DE LOS ESTADOS UNIDOS DE AMÉRICA) más IVA en zonas foráneas (aplica solo para Quito y Guayaquil).</span>
  </span>
  <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335551550'||chr(38)||'quot;:6,'||chr(38)||'quot;335551620'||chr(38)||'quot;:6,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">
    <span class="eop">'||chr(38)||'nbsp;</span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l2 level1 lfo9;tab-stops:list 36.0pt;vertical-align:baseline" paraid="830813234" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{226}">
  <span data-contrast="auto" xml:lang="ES-EC">
    <!--[if !supportLists]-->
    <span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol">
      <span style="mso-list:Ignore">· <span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp; </span>
      </span>
    </span>
    <!--[endif]-->
    <span class="normaltextrun">Costo de la hora adicional después de la primera hora de atención $10(DIEZ DÓLARES DE LOS ESTADOS UNIDOS DE AMÉRICA) más IVA.</span>
  </span>
  <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">
    <span class="eop">'||chr(38)||'nbsp;</span>
  </span>
  <o:p></o:p>
</p>
<p class="paragraph" style="margin-left:54.0pt;text-align:justify;text-indent:
0cm;mso-list:l2 level1 lfo9;tab-stops:list 36.0pt;vertical-align:baseline" paraid="812382011" paraeid="{3cbb4f36-4ec2-4655-96cf-1459f5ea7026}{233}">
  <span data-contrast="auto" xml:lang="ES-EC">
    <!--[if !supportLists]-->
    <span style="font-size:
10.0pt;mso-bidi-font-size:12.0pt;font-family:Symbol;mso-fareast-font-family:
Symbol;mso-bidi-font-family:Symbol">
      <span style="mso-list:Ignore">· <span style="font:7.0pt '||chr(38)||'quot;Times New Roman'||chr(38)||'quot;">'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp;'||chr(38)||'nbsp; </span>
      </span>
    </span>
    <!--[endif]-->
    <span class="normaltextrun">Todos los planes Pro y PYME (según la oferta establecida por Netlife), incluyen Netlife Assistance Pro, un servicio de asistencia especializada en problemas técnicos e informáticos, disponible para 5 (CINCO) usuarios. Para acceder a él es necesario ingresar dentro de la sección “Netlife Access” en la página web de Netlife o a store.netlife.net.ec.'||chr(38)||'nbsp;</span>
  </span>
  <span data-ccp-props="{'||chr(38)||'quot;134233117'||chr(38)||'quot;:true,'||chr(38)||'quot;134233118'||chr(38)||'quot;:true,'||chr(38)||'quot;201341983'||chr(38)||'quot;:0,'||chr(38)||'quot;335551550'||chr(38)||'quot;:6,'||chr(38)||'quot;335551620'||chr(38)||'quot;:6,'||chr(38)||'quot;335559739'||chr(38)||'quot;:160,'||chr(38)||'quot;335559740'||chr(38)||'quot;:240}">
    <span class="eop">'||chr(38)||'nbsp;</span>
  </span>
  <o:p></o:p>
</p>
<br>
</p>
');

UPDATE DB_COMERCIAL.ADMI_PRODUCTO
SET TERMINO_CONDICION=bada
WHERE ID_PRODUCTO=1262
 AND EMPRESA_COD=18 AND CODIGO_PRODUCTO='KO01';
 COMMIT;
 END;