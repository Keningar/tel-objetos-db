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
DBMS_LOB.APPEND(bada, '  <div class="OutlineElement Ltr  BCX0 SCXW110872044" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; margin: 0px; padding: 0px; user-select: text; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent; overflow: visible; cursor: text; clear: both; position: relative; direction: ltr;" segoe="" ui",="" "segoe="" ui="" web" ,="" arial,="" verdana,="" sans-serif;"="">
   <p class="Paragraph SCXW110872044 BCX0" paraid="1042177221" paraeid="{4e9557a7-a79c-4c7c-8a86-fcd0a84cbc54}{53}" style="margin: 0px; padding: 0px; user-select: text; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent; overflow-wrap: break-word; vertical-align: baseline; font-kerning: none; text-align: center; text-indent: 24px;">
     <span data-contrast="none" xml:lang="ES-EC" class="TextRun SCXW110872044 BCX0" style="margin: 0px; padding: 0px; user-select: text; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent; background-color: transparent;    line-height: 40.5px; font-family: " times="" new="" roman",="" "times="" roman_embeddedfont" ,="" roman_msfontservice",="" serif;="" font-weight:="" bold;="" font-variant-ligatures:="" none="" !important;"="" lang="ES-EC">TÉRMINOS Y CONDICIONES EL CANAL DEL FÚTBOL</span>
     <span class="EOP SCXW110872044 BCX0" data-ccp-props="{" 201341983":0,"335551550":2,"335551620":2,"335559731":360,"335559739":160,"335559740":360}"="" style="margin: 0px; padding: 0px; user-select: text; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent;    line-height: 40.5px; font-family: " times="" new="" roman",="" "times="" roman_embeddedfont" ,="" roman_msfontservice",="" serif;"=""></span>
   </p>
 </div>
 <div class="OutlineElement Ltr  BCX0 SCXW110872044" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; margin: 0px; padding: 0px; user-select: text; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent; overflow: visible; cursor: text; clear: both; position: relative; direction: ltr;" segoe="" ui",="" "segoe="" ui="" web" ,="" arial,="" verdana,="" sans-serif;"="">
   <p class="Paragraph SCXW110872044 BCX0" paraid="433859129" paraeid="{4e9557a7-a79c-4c7c-8a86-fcd0a84cbc54}{59}" style="margin: 0px 0px 0px 48px; padding: 0px; user-select: text; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent; overflow-wrap: break-word; vertical-align: baseline; font-kerning: none; text-align: justify;">
     <span data-contrast="auto" xml:lang="ES-EC" class="TextRun SCXW110872044 BCX0" style="margin: 0px; padding: 0px; user-select: text; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent; font-variant-ligatures: none !important; background-color: transparent;    line-height: 19.425px; font-family: " times="" new="" roman",="" "times="" roman_embeddedfont" ,="" roman_msfontservice",="" serif;"="" lang="ES-EC">
       <span class="NormalTextRun SCXW110872044 BCX0" style="margin: 0px; padding: 0px; user-select: text; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent;"></span>
     </span>
     <span class="EOP SCXW110872044 BCX0" data-ccp-props="{" 134233279":true,"201341983":0,"335551550":6,"335551620":6,"335559685":720,"335559739":160,"335559740":259}"="" style="margin: 0px; padding: 0px; user-select: text; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent;    line-height: 19.425px; font-family: " times="" new="" roman",="" "times="" roman_embeddedfont" ,="" roman_msfontservice",="" serif;"=""></span>
   </p>
 </div>
 <div class="OutlineElement Ltr  BCX0 SCXW110872044" style="margin: 0px; padding: 0px; user-select: text; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent; overflow: visible; cursor: text; clear: both; position: relative; direction: ltr;" segoe="" ui",="" "segoe="" ui="" web" ,="" arial,="" verdana,="" sans-serif;"="">
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="1759835974" paraeid="{ed388f1c-ad67-49d7-b2c4-63cc7091b1cd}{165}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">1. INTRODUCCIÓN AL SERVICIO Y ACEPTACIÓN DE LAS CONDICIONES DE USO.</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="854535525" paraeid="{ed388f1c-ad67-49d7-b2c4-63cc7091b1cd}{173}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">1.1 Introducción</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="481117165" paraeid="{ed388f1c-ad67-49d7-b2c4-63cc7091b1cd}{179}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">
           <span class="NormalTextRun SCXW83834786 BCX2">Comparecen a la celebración del presente contrato, por una </span>
           <span class="NormalTextRun ContextualSpellingAndGrammarErrorV2 SCXW83834786 BCX2">parte</span>
           <span class="NormalTextRun SCXW83834786 BCX2"> la empresa MEGADATOS S.A., la empresa prestadora, SERVISKY empresa dueña del contenido y por otra parte el "CLIENTE"; quienes de mutuo acuerdo convienen en celebrar el presente contrato al tenor de las cláusulas que a continuación se detallan: </span>
         </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   
            ');
   DBMS_LOB.APPEND(bada, '
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="1041470072" paraeid="{ed388f1c-ad67-49d7-b2c4-63cc7091b1cd}{185}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">1.2 Aceptación de las Condiciones de Uso</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="266791002" paraeid="{ed388f1c-ad67-49d7-b2c4-63cc7091b1cd}{191}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">Para acceder y disfrutar el Servicio, debe aceptar y en todo momento seguir las disposiciones que se establecen en estos Términos. Al usar el Servicio, usted acepta cumplir con las Condiciones de Uso, por lo que le pedimos dedique un tiempo a revisarlas cuidadosamente, y si no está de acuerdo con las mismas, no debería utilizar el Servicio. </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="678201244" paraeid="{ed388f1c-ad67-49d7-b2c4-63cc7091b1cd}{197}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">
           <span class="NormalTextRun SCXW83834786 BCX2">Los términos de uso de la plataforma serán aquellos definidos por </span>
           <span class="NormalTextRun SCXW83834786 BCX2">El Canal del Fútbol</span>
           <span class="NormalTextRun SCXW83834786 BCX2">, detallados en el siguiente link </span>
           <span class="NormalTextRun SCXW83834786 BCX2">https://elcanaldelfutbol.com/terminos-y-condiciones</span>
         </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="1721444099" paraeid="{ed388f1c-ad67-49d7-b2c4-63cc7091b1cd}{209}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">1.3 Cuenta y Registro</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
            ');
   DBMS_LOB.APPEND(bada, '
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="1765054693" paraeid="{ed388f1c-ad67-49d7-b2c4-63cc7091b1cd}{215}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">
           <span class="NormalTextRun SCXW83834786 BCX2">MEGADATOS S.A. le entregará vía correo electrónico y/o </span>
           <span class="NormalTextRun SpellingErrorV2 SCXW83834786 BCX2">sms</span>
           <span class="NormalTextRun SCXW83834786 BCX2"> las credenciales para acceder al Servicio, las cuales son de carácter personal e intransferible. Toda la información de registro que proporcione debe ser exacta y actualizada. Mantenga la confidencialidad de su contraseña. Si revela a otros su contraseña o comparte su cuenta y/o dispositivos con otras personas, deberá asumir toda la responsabilidad derivada de las acciones de dichas personas. Usted es responsable de todo uso en su cuenta, incluyendo el uso no autorizado de terceros, por lo que le pedimos sea muy cuidadoso para proteger la seguridad de su contraseña. Notifíquenos inmediatamente si llega a saber o sospechar de usos no autorizados de su cuenta, al *611. Asimismo, asegúrese de mantener actualizada la información de registro (por ejemplo, dirección de correo electrónico).</span>
         </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="567967291" paraeid="{ed388f1c-ad67-49d7-b2c4-63cc7091b1cd}{221}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">
           <span class="NormalTextRun SCXW83834786 BCX2">El cliente acepta por la presente y entiende que es necesario proporcionar la información de su correo electrónico para acceder al servicio, por ello se limitará en generar reclamaciones futuras sobre el tratamiento de dichos datos, mismos que permitirán al cliente recibir un óptimo servicio. Este correo debe ser un correo electrónico válido. Es de absoluta responsabilidad del cliente verificar que el correo no se encuentre alojado en la carpeta de correo no deseado(spam) y en caso de requerirlo, podrá solicitar el reenvío de sus credenciales contactándose al 3920000</span>
           <span class="NormalTextRun SCXW83834786 BCX2">.</span>
         </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 134233279":true,"201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="924777799" paraeid="{ed388f1c-ad67-49d7-b2c4-63cc7091b1cd}{229}">
       <font face="arial">
         <span style="color: windowtext;    line-height: 18px;" data-contrast="auto" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">En caso de requerirlo, el cliente podrá recibir soporte respecto cuestiones técnicas relacionadas con la plataforma como reproducción de video, contenidos no disponibles, errores en las imágenes de los contenidos, entre otros, </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px; color: windowtext;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":0,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
            ');
   DBMS_LOB.APPEND(bada, '
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="988241681" paraeid="{ed388f1c-ad67-49d7-b2c4-63cc7091b1cd}{235}">
       <font face="arial">
         <span style="color: windowtext;    line-height: 18px;" data-contrast="auto" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">a través del chat en el sitio web o app; así como, vía correo electrónico en la opción de Contacto dentro de la página web de la plataforma (</span>
         <a class="Hyperlink SCXW83834786 BCX2" style="text-decoration-line: none;" href="https://elcanaldelfutbol.com/contactenos" target="_blank" rel="noreferrer noopener">
           <span style="color: windowtext;    line-height: 19px;" data-contrast="auto" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">https://elcanaldelfutbol.com/contactenos</span>
         </a>
         <span style="color: windowtext;    line-height: 18px;" data-contrast="auto" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">
           <span class="NormalTextRun SCXW83834786 BCX2" data-ccp-parastyle="Default">).</span>
           <span class="NormalTextRun SCXW83834786 BCX2" data-ccp-parastyle="Default"> También se pone a disposición del usuario la plataforma sus redes sociales para atender todas las preguntas que sean necesarias y acordes para solucionar cualquier duda e inconveniente.</span>
         </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px; color: windowtext;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":0,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="238640248" paraeid="{ed388f1c-ad67-49d7-b2c4-63cc7091b1cd}{248}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">La entrega de este producto no incluye el servicio de instalación de este en ningún dispositivo. El cliente es responsable de la instalación y configuración del producto en sus dispositivos y usuarios.</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 134233117":true,"134233118":true,"134233279":true,"201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="1235035228" paraeid="{ed388f1c-ad67-49d7-b2c4-63cc7091b1cd}{254}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">
           <span class="NormalTextRun SCXW83834786 BCX2"></span>
         </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="747160365" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{3}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">1.4 El Servicio</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
            ');
   DBMS_LOB.APPEND(bada, '
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="364143220" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{9}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">Una vez registrado ofrecemos el acceso al Canal Premium 24/7 de El Canal del Fútbol, todos los 90 partidos de eliminatorias sudamericanas, amistosos de la selección ecuatoriana y todos los partidos de la Copa Ecuador.</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="1144106008" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{15}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">
           <span class="NormalTextRun SCXW83834786 BCX2">El precio </span>
           <span class="NormalTextRun SCXW83834786 BCX2">de EL Canal del Fútbol</span>
           <span class="NormalTextRun SCXW83834786 BCX2"> como servicio adicional es de $</span>
           <span class="NormalTextRun SCXW83834786 BCX2">6</span>
           <span class="NormalTextRun SCXW83834786 BCX2">.</span>
           <span class="NormalTextRun SCXW83834786 BCX2">00</span>
           <span class="NormalTextRun SCXW83834786 BCX2">(DOS DÓLARES DE LOS ESTADOS UNIDOS</span>
           <span class="NormalTextRun SCXW83834786 BCX2">) mensual incluido IVA.</span>
         </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="1084487718" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{35}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">2. MODIFICACIÓN DE LAS CONDICIONES DE USO POR MEGADATOS S.A.</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="1836295441" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{41}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">
           <span class="NormalTextRun SCXW83834786 BCX2">MEGADATOS S.A. podrá modificar las Condiciones de Uso en cualquier momento como parte del cumplimiento normativo existente o debido a mejoras y optimización del servicio prestado, las cuales surtirán efectos en el momento en que se publiquen las Condiciones de Uso modificadas en nuestro Sitio. La versión más actual de las Condiciones de Uso dejará </span>
           <span class="NormalTextRun SpellingErrorV2 SCXW83834786 BCX2">insusbsistentes</span>
           <span class="NormalTextRun SCXW83834786 BCX2"> las versiones previas. </span>
         </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
            ');
   DBMS_LOB.APPEND(bada, '
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="143679529" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{47}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px; font-weight: bold;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">3. ACCESO Y USO DE LOS SERVICIOS</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="633714285" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{53}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">3.1 RESTRICCIONES DE EDAD</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="754198924" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{59}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">Usted debe tener 18 años o más para poder ser miembro del Servicio y hacer operaciones a través de los Servicios. Las personas menores de 18 años pueden utilizar el Servicio, pero solo con el consentimiento de los padres o el tutor, utilizando la cuenta de esta persona, por lo que se exime de responsabilidad total a MEGADATOS de dicho no autorizado o establecido con consentimiento de sus tutores o padres, y de acuerdo con las Condiciones de Uso y cualquier otro término publicado. </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="770355535" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{65}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">3.2 La Licencia</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="530638896" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{71}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">
           <span class="NormalTextRun SCXW83834786 BCX2">Por medio del presente, le otorgamos una licencia, no exclusiva, intransferible y limitada, para acceder al Servicio, vía </span>
           <span class="NormalTextRun SpellingErrorV2 SpellingErrorHighlight SCXW83834786 BCX2">streaming</span>
           <span class="NormalTextRun SCXW83834786 BCX2"> en línea por Internet a través del Reproductor de Video, para fines personales, no comerciales, como se establece en las Condiciones de Uso. Excepto por la licencia limitada referida en este párrafo, no se le transfieren derechos de propiedad o titularidad a usted. </span>
         </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
            ');
   DBMS_LOB.APPEND(bada, '
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="2063084969" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{77}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">
           <span class="NormalTextRun SCXW83834786 BCX2" data-ccp-parastyle="heading 2">3.</span>
           <span class="NormalTextRun SCXW83834786 BCX2" data-ccp-parastyle="heading 2">3</span>
           <span class="NormalTextRun SCXW83834786 BCX2" data-ccp-parastyle="heading 2"> El Contenido</span>
         </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="503094628" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{87}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">
           <span class="NormalTextRun SCXW83834786 BCX2">El dueño del contenido (SERVISKY) no promueve, aprueba o permite que se copien partidos entregados digitalmente, ni otras actividades delictivas. Usted no puede, ya sea directamente o con el uso de dispositivos, software, sitios de Internet, servicios basados en web, u otros medios: (i) retirar, alterar, eludir, evitar, o interferir avisos de derechos de autor, marcas u otro tipo de aviso de propiedad insertados en el Contenido, o mecanismos de administración de derechos digitales, dispositivos u otras protecciones de contenido o medidas de control de acceso del Contenido, incluyendo mecanismos de filtración geográfica; ni (</span>
           <span class="NormalTextRun SpellingErrorV2 SCXW83834786 BCX2">ii</span>
           <span class="NormalTextRun SCXW83834786 BCX2">) copiar, descargar, modificar, distribuir, transmitir, mostrar, efectuar, reproducir , exhibir, duplicar, publicar, licenciar, crear obras derivadas u ofrecer para venta el Contenido u otra información contenida u obtenida de o a través del Servicio, sin nuestro consentimiento expreso por escrito. No puede incorporar el Contenido, ni hacer </span>
           <span class="NormalTextRun SpellingErrorV2 SCXW83834786 BCX2">streaming</span>
           <span class="NormalTextRun SCXW83834786 BCX2"> o retransmitirlo, en aplicaciones de hardware o de software, ni ponerlo a disposición a través de enmarcados o vínculos en línea. Tampoco puede crear un negocio utilizando el Contenido, ya sea con fines de lucro o no. El Contenido al que aplican estas restricciones incluye, entre otros, textos, gráficos, configuraciones, interfaces, logotipos, fotografías, materiales de audio y video y fonogramas. Asimismo, se le prohíbe estrictamente crear obras derivadas o materiales que provengan o se basen en cualquier forma en el Contenido, incluyendo montajes, mezclas de música y videos similares, fondos de escritorio, protector de pantalla, tarjetas de saludos y mercancías. </span>
         </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   ');
   DBMS_LOB.APPEND(bada, ' 
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="2133767553" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{93}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">
           <span class="NormalTextRun SCXW83834786 BCX2" data-ccp-parastyle="heading 2">3.</span>
           <span class="NormalTextRun SCXW83834786 BCX2" data-ccp-parastyle="heading 2">4</span>
           <span class="NormalTextRun SCXW83834786 BCX2" data-ccp-parastyle="heading 2"> El Reproductor de Video</span>
         </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="1039535667" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{103}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">
           <span class="NormalTextRun SCXW83834786 BCX2">Usted no puede modificar, mejorar, retirar, interferir o de otra forma alterar alguna parte del Reproductor de Video, tecnología subyacente, software, mecanismos de administración de derechos digitales, dispositivos u otras protecciones de contenido o medidas de control de acceso incorporados en el Reproductor de Video. Esta restricción incluye, entre otros, inhabilitar, revertir la ingeniería, incorporar, modificar, interferir o de otra forma eludir el Reproductor de Video en cualquier forma que permita a los usuarios ver el Contenido sin: (i) mostrar de manera notoria tanto el Reproductor de Video como todos los elementos circundantes (incluyendo la interfaz gráfica de usuario, cualquier anuncio, avisos de derechos de autor y marcas) de la página web donde se ubica el Reproductor de Video; y (</span>
           <span class="NormalTextRun SpellingErrorV2 SCXW83834786 BCX2">ii</span>
           <span class="NormalTextRun SCXW83834786 BCX2">) tener acceso completo a todas las funcionalidades del Reproductor de Video, incluyendo, sin limitar a todas las funcionalidades de calidad y visualización del video, así como todas las funcionalidades interactivas, optativas o publicitarias haciendo un clic. Tampoco puede acceder a los Servicios a través de otro software de reproductor de video distinto al Reproductor de Video del Canal de Futbol. </span>
         </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="596347284" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{109}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">4. CÓMO FUNCIONA EL SERVICIO</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="992591474" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{115}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">4.1 Descripción General</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="1784509500" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{121}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">
           <span class="FindHit SCXW83834786 BCX2">Canal del Futbol</span>
           <span class="NormalTextRun SCXW83834786 BCX2"> es un servicio en línea que ofrece a sus usuarios acceso a Contenido que se transmite vía </span>
           <span class="NormalTextRun SpellingErrorV2 SCXW83834786 BCX2">streaming</span>
           <span class="NormalTextRun SCXW83834786 BCX2"> por Internet a ciertos dispositivos. Nos reservamos el derecho, a nuestra absoluta y exclusiva discreción, de hacer cambios en cualquier momento y sin notificación, sobre la forma en que manejamos el Servicio, por lo que las descripciones de cómo funciona el Servicio no deben considerarse como una declaración u obligación respecto a cómo funcionará siempre. </span>
         </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="507583567" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{127}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">
           <span class="NormalTextRun SCXW83834786 BCX2"></span>
         </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="1122481536" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{131}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">4.2 Disponibilidad</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="1311428399" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{137}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">
           <span class="NormalTextRun SCXW83834786 BCX2">La calidad de visualización de </span>
           <span class="NormalTextRun SpellingErrorV2 SCXW83834786 BCX2">streaming</span>
           <span class="NormalTextRun SCXW83834786 BCX2"> del Contenido puede variar de una computadora y/o dispositivo a otro, y diversos factores pueden afectarla, como el lugar donde usted se ubica, el ancho de banda disponible y/o la velocidad de su conexión de Internet. Usted debe estar conectado a Internet en todo momento para ver el Contenido. </span>
         </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="1532696112" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{143}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">4.3 Dispositivos</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="1349460135" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{149}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">
           <span class="NormalTextRun SCXW83834786 BCX2">SE LE PERMITIRÁ VER EL CONTENIDO EN UN DISPOSITIVO EN UN MOMENTO DETERMINADO, EL CUAL SOLO PERMITIRA UN STREAMING EN UN DISPOSITIVO A LA VEZ. El número de dispositivos y de </span>
           <span class="NormalTextRun SpellingErrorV2 SCXW83834786 BCX2">streamings</span>
           <span class="NormalTextRun SCXW83834786 BCX2"> simultáneos pueden cambiar sin notificación previa. </span>
         </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="1380225565" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{155}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">5. PROPIEDAD Y DERECHOS DE PROPIEDAD INTELECTUAL.</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="732319362" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{161}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">El Servicio, incluyendo todo el Contenido, software, interfaces de usuario, textos, gráficos, logotipos, diseños, fotografías, iconos de botones, imágenes, videoclips y audios, descargas digitales, compilaciones de datos y software que se incluyen en el Sitio y/o que se entregan a los usuarios como parte del Servicio, son bienes de SERVISKY o de sus licenciantes o clubes deportivos, y están protegidos derechos de autor </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="639541568" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{167}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">6. MEMBRESÍA Y FACTURACIÓN</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="1895883" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{173}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">6.1 Pruebas gratuitas</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="1893415563" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{179}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">
           <span class="NormalTextRun SCXW83834786 BCX2">De tiempo en tiempo podemos, mas no estamos obligados a, ofrecerle pruebas gratuitas, pero para hacer uso de estas ofertas, debe tener acceso a Internet </span>
           <span class="NormalTextRun ContextualSpellingAndGrammarErrorV2 SCXW83834786 BCX2">y</span>
           <span class="NormalTextRun SCXW83834786 BCX2"> además, puede requerirse que cuente con una forma de pago aceptada, válida y actual. Podemos comenzar a facturar el cargo mensual a través de la Forma de Pago al final del periodo de prueba gratuita o promoción. Usted acuerda que la Forma de Pago puede estar autorizada hasta por aproximadamente un mes de servicio inmediatamente de que se registre. Continuaremos facturando el cargo mensual a través de la Forma de Pago hasta que la cancele (ver la sección “Cancelación”). Las ofertas de pruebas gratuitas también pueden estar sujetas a términos y condiciones adicionales que se ponen a su disposición durante la inscripción. </span>
         </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="627167328" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{185}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">6.2 Facturación</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="881043379" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{191}">
       <font face="arial">
         <span style="   line-height: 18px;" data-contrast="none" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">Al iniciar su membresía, expresamente acuerda que nosotros estamos autorizados a realizar el cargo mensual (de acuerdo con su ciclo de facturación), de membresía a la tarifa que esté vigente, así como cualquier otro cargo en que pueda incurrir respecto al uso del Servicio, incluyendo los impuestos aplicables, a la Forma de Pago que usted proporcionó durante el registro. El cargo se incorporará en su factura y a partir de entonces cada mes (de acuerdo con su ciclo facturación), por un tiempo mínimo de permanencia sujeto a cambios y especificados en el momento de la contratación, a menos y hasta que usted cancele la membresía, y o la Forma de Pago venza o no proceda. </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":0,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
            ');
   DBMS_LOB.APPEND(bada, ' 
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="969234954" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{197}">
       <font face="arial" style="color: windowtext; font-family: tahoma, arial, verdana, sans-serif; font-size: 12px;">
         <span style="   line-height: 19.425px;" data-contrast="none" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">El primer mes de servicio, el cliente no pagará el valor total, sino el valor proporcional por el tiempo que haya recibido el servicio de acuerdo con su ciclo de facturación'||chr(38)||'nbsp;</span>
       </font>
       <font face="arial">
         <span style="font-size: 12px;">(Ciclo 1: Del 1 al 30 del mes, Ciclo 2: Del 15 al 14 del mes siguiente o Ciclo 3: Del 8 al 7 del mes siguiente).</span>
       </font>
       <span data-contrast="none" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC" style="color: windowtext; font-family: arial; font-size: 12px; background-color: transparent; line-height: 19.425px;">'||chr(38)||'nbsp;</span>
       <span data-contrast="auto" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC" style="color: windowtext; font-family: arial; font-size: 12px; background-color: transparent; line-height: 19.425px;">LOS PAGOS NO SON REEMBOLSABLES Y NO HABRÁ REEMBOLSOS O CRÉDITOS POR PERIODOS UTILIZADOS PARCIALMENTE. La suscripción permite ver los partidos de las Eliminatorias solamente dentro del territorio de Ecuador.</span>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="1662782865" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{205}">
       <font face="arial">
         <span style="   line-height: 19.425px;" data-contrast="none" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">
           <span class="NormalTextRun SCXW83834786 BCX2"></span>
         </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="1178693378" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{209}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">6.3 Reembolsos/Créditos</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="1464629457" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{215}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">
           <span class="NormalTextRun SCXW83834786 BCX2">El monto y la forma de los créditos, y la decisión de otorgarlos, son a nuestra absoluta y exclusiva discreción. El otorgamiento de créditos en un solo caso no </span>
           <span class="NormalTextRun ContextualSpellingAndGrammarErrorV2 SCXW83834786 BCX2">le</span>
           <span class="NormalTextRun SCXW83834786 BCX2"> da derecho a créditos en el futuro por casos similares, ni nos obliga a otorgar créditos en el futuro, bajo ninguna circunstancia. NO OTORGAMOS REEMBOLSOS O CRÉDITOS POR MEMBRESÍA DE MES PARCIAL NI POR PELÍCULAS O PROGRAMAS NO VISTOS. </span>
         </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="734249636" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{221}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">6.4 Cancelación</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="269412817" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{227}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">Su suscripción continuará vigente mes a mes, a menos y hasta que cancele la suscripción de acuerdo con las condiciones de uso, o la cuenta o el servicio se suspenda o descontinúe de otra forma conforme a las condiciones de uso. Para evitar la facturación del próximo mes, debe cancelar la suscripción del Servicio correspondiente antes de que se renueve su ciclo mensual. TOME EN CUENTA QUE NO OTORGAMOS REEMBOLSOS NI CRÉDITOS POR MEMBRESÍAS CANCELADAS A LA MITAD DEL MES CORRIENTE O POR PARTIDOS NO VISTOS O SUSPENSIÓN DE PARTIDOS. POR LO TANTO, USTED DEBE DE PAGAR EL MES COMPLETO DE SERVICIO CORRESPONDIENTE AL CICLO MENSUAL EN QUE CANCELO EL SERVICIO, Y DICHA CANCELACION SERA EFECTIVA EN EL ULTIMO DIA DE DICHO CICLO MENSUAL, PUDIENDO ACCESAR AL SERVICIO HASTA DICHA FECHA. </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="657244520" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{233}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">
           <span class="NormalTextRun SCXW83834786 BCX2">El cliente puede cancelar el servicio en cualquier momento. Se recomienda hacerlo luego de haber cumplido el período mínimo de permanencia del servicio (3 meses); a través, de nuestra </span>
           <span class="NormalTextRun SpellingErrorV2 SCXW83834786 BCX2">call</span>
           <span class="NormalTextRun SCXW83834786 BCX2"> center o centros de atención. En el caso de existir una cancelación anticipada el cliente acepta el cobro de los beneficios entregados al mismo (promoción/descuento/meses restantes para cumplir el tiempo mínimo de permanencia)</span>
         </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="2063891298" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{239}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">6.5 Suspensión/Descontinuación/Terminación</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
      ');
   DBMS_LOB.APPEND(bada, ' 
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="1979604781" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{245}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">Nos reservamos el derecho a terminar, suspender o restringir de inmediato su cuenta, el uso de los Servicios, o el acceso al Contenido, en cualquier momento, sin notificación o responsabilidad alguna, si MEGADATOS, a su absoluta discreción, determina que usted ha incumplido con las Condiciones de Uso, leyes, normas o reglamentos, ha participado en otras conductas inapropiadas, incluso si el uso de los Servicios o el acceso al Contenido por su parte impone una carga indebida en nuestras redes o servidores. </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
            ');
   DBMS_LOB.APPEND(bada, '
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="982922717" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{251}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">
           <span class="NormalTextRun SCXW83834786 BCX2"></span>
         </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="798827557" paraeid="{78572209-a773-453c-95a8-6700056fb1a7}{255}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">
           <span class="NormalTextRun SCXW83834786 BCX2" data-ccp-parastyle="heading 2">6.6 </span>
           <span class="NormalTextRun SCXW83834786 BCX2" data-ccp-parastyle="heading 2">Montos Adeudados</span>
         </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="981497474" paraeid="{d4256c3c-3218-471f-a683-a61d702dcef2}{8}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">Es importante que todos los usuarios del Servicio cumplan con las obligaciones de pago a las cuales han convenido; por tanto, nos reservamos el derecho a tomar las medidas necesarias para recuperar los montos relativos que haya dejado de pagar. Usted seguirá siendo responsable ante MEGADATOS de todos esos montos, así como de todos los gastos en que incurramos para su cobro, incluyendo, entre otros, honorarios de la agencia de cobranza, honorarios razonables de abogado, y costas legales. </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="1833907612" paraeid="{d4256c3c-3218-471f-a683-a61d702dcef2}{14}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">7. SITIOS WEB, PUBLICIDAD Y APLICACIONES DE TERCEROS</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
            ');
   DBMS_LOB.APPEND(bada, '
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="315138164" paraeid="{d4256c3c-3218-471f-a683-a61d702dcef2}{20}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">7.1 Destinos de Terceros</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="901792385" paraeid="{d4256c3c-3218-471f-a683-a61d702dcef2}{26}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">Destinos de Terceros. Si incluimos vínculos a otros sitios web, no deberá suponer o asumir que MEGADATOS opera, controla o que de otra manera está conectado con esos otros sitios web o destinos. Tenga cuidado al leer las Condiciones de Uso y la política de privacidad de cualquier otro sitio web antes de dar información personal o participar en operaciones. MEGADATOS no es responsable del contenido o de las prácticas de sitios web distintos al Sitio. Al usar el Servicio, reconoce y acuerda que MEGADATOS no es responsable ante usted de contenidos u otros materiales que se alberguen y se ubiquen en servidores de otros sitios web distintos al Sitio, y en todo caso sujeto a estas Condiciones de Uso. </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="734276052" paraeid="{d4256c3c-3218-471f-a683-a61d702dcef2}{32}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">7.2 Publicidad</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="528838944" paraeid="{d4256c3c-3218-471f-a683-a61d702dcef2}{38}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">MEGADATOS S.A. no asume ninguna responsabilidad de los anuncios o materiales de terceros publicados en el Sitio, ni tampoco de los productos o servicios que ofrecen los anunciantes. Los tratos que usted tenga con los anunciantes que se encuentran mientras se utilizan los Servicios son entre usted y el anunciante, y acuerda que MEGADATOS S.A. no es responsable de pérdidas o reclamaciones que pudiera tener contra un anunciante. </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="1565629071" paraeid="{d4256c3c-3218-471f-a683-a61d702dcef2}{44}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">8. DISPOSICIONES GENERALES</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
         ');
   DBMS_LOB.APPEND(bada, ' 
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="514021929" paraeid="{d4256c3c-3218-471f-a683-a61d702dcef2}{50}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">8.1 Comunicaciones Electrónicas</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="2076611631" paraeid="{d4256c3c-3218-471f-a683-a61d702dcef2}{56}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">
           <span class="NormalTextRun SCXW83834786 BCX2">Al utilizar el Servicio, usted aprueba recibir comunicaciones electrónicas de MEGADATOS, las cuales pueden incluir notificaciones acerca de su cuenta, correos electrónicos de confirmación e información de operaciones de otro tipo, así como información concerniente o relativa al Servicio, y puede incluir boletines y comunicaciones promocionales de nosotros si usted ha elegido recibirlas durante la subscripción y no han sido canceladas y notificadas. Usted acuerda que las notificaciones, acuerdos, divulgaciones u otras comunicaciones que le enviemos electrónicamente cumplirán con las disposiciones legales ecuatorianas vigentes sobre tratamiento de información </span>
           <span class="NormalTextRun ContextualSpellingAndGrammarErrorV2 SCXW83834786 BCX2">y sobre</span>
           <span class="NormalTextRun SCXW83834786 BCX2"> comunicaciones, incluso que sean por escrito; asimismo, acuerda en actualizar su información personal inmediatamente de que haya un cambio en la dirección de su correo electrónico. </span>
         </span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" role="heading" aria-level="2" style="font-weight: bold; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="204455743" paraeid="{d4256c3c-3218-471f-a683-a61d702dcef2}{62}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 18px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">8.2 Pruebas del Servicio</span>
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 18px;" data-ccp-props="{" 134233117":true,"134233118":true,"201341983":0,"335551550":6,"335551620":6,"335559740":240}"=""></span>
       </font>
     </p>
   </div>
            ');
   DBMS_LOB.APPEND(bada, '
   <div class="OutlineElement Ltr  BCX2 SCXW83834786" style="color: rgb(0, 0, 0); font-family: tahoma, arial, verdana, sans-serif; font-size: 12px; direction: ltr;">
     <p class="Paragraph SCXW83834786 BCX2" style="   font-family: tahoma, arial, verdana, sans-serif; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="516457528" paraeid="{d4256c3c-3218-471f-a683-a61d702dcef2}{68}">
       <font face="arial">
         <span data-contrast="auto" style="   line-height: 19.425px;" xml:lang="ES-EC" class="TextRun SCXW83834786 BCX2" lang="ES-EC">En cualquier momento, realizamos pruebas de diversos aspectos de nuestro servicio, incluyendo el sitio web, interfaces de usuario, niveles de servicio, planes, promociones, funciones, disponibilidad del contenido y precios, y nos reservamos el derecho a incluirlo o excluirlo de dichas pruebas sin notificación. </span>
       </font>
     </p>
     <p class="MsoNormal" style="margin-left: 36pt; text-align: justify; line-height: normal; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">
       <font face="arial">
         <o:p></o:p>
       </font>
     </p>
     <p class="Paragraph SCXW83834786 BCX2" style="vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="516457528" paraeid="{d4256c3c-3218-471f-a683-a61d702dcef2}{68}">
       <span style="background-color: transparent; color: windowtext;">
         <font style="" face="arial"></font>
       </span>
     </p>
     <p class="Paragraph SCXW83834786 BCX2" style="   font-family: tahoma, arial, verdana, sans-serif; vertical-align: baseline; background-color: transparent; color: windowtext; text-align: justify; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;" paraid="516457528" paraeid="{d4256c3c-3218-471f-a683-a61d702dcef2}{68}">
       <font face="arial">
         <span class="EOP SCXW83834786 BCX2" style="   line-height: 19.425px;" data-ccp-props="{" 201341983":0,"335551550":6,"335551620":6,"335559739":160,"335559740":259}"=""></span>
       </font>
     </p>
   </div>
 </div>');

UPDATE DB_COMERCIAL.ADMI_PRODUCTO
SET TERMINO_CONDICION=bada
WHERE ID_PRODUCTO=1404
 AND EMPRESA_COD=18 AND CODIGO_PRODUCTO='ECDF';
 COMMIT;
 END;