SET SERVEROUTPUT ON ;
DECLARE
    bada clob:=' ';
BEGIN
DBMS_LOB.APPEND(bada,' 
<!--[if gte mso 9]><xml> <o:OfficeDocumentSettings>  <o:RelyOnVML/>  <o:AllowPNG/> </o:OfficeDocumentSettings></xml><![endif]--><!--[if gte mso 9]><xml> <w:WordDocument>  <w:View>Normal</w:View>  <w:Zoom>0</w:Zoom>  <w:TrackMoves/>  <w:TrackFormatting/>  <w:HyphenationZone>21</w:HyphenationZone>  <w:PunctuationKerning/>  <w:ValidateAgainstSchemas/>  <w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid>  <w:IgnoreMixedContent>false</w:IgnoreMixedContent>  <w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlaceholderText>  <w:DoNotPromoteQF/>  <w:LidThemeOther>ES-EC</w:LidThemeOther>  <w:LidThemeAsian>JA</w:LidThemeAsian>  <w:LidThemeComplexScript>AR-SA</w:LidThemeComplexScript>  <w:Compatibility>   <w:BreakWrappedTables/>   <w:SnapToGridInCell/>   <w:WrapTextWithPunct/>   <w:UseAsianBreakRules/>   <w:DontGrowAutofit/>   <w:SplitPgBreakAndParaMark/>   <w:EnableOpenTypeKerning/>   <w:DontFlipMirrorIndents/>   <w:OverrideTableStyleHps/>  </w:Compatibility>  <m:mathPr>   <m:mathFont m:val="Cambria Math"/>   <m:brkBin m:val="before"/>   <m:brkBinSub m:val="&#45;-"/>   <m:smallFrac m:val="off"/>   <m:dispDef/>   <m:lMargin m:val="0"/>   <m:rMargin m:val="0"/>   <m:defJc m:val="centerGroup"/>   <m:wrapIndent m:val="1440"/>   <m:intLim m:val="subSup"/>   <m:naryLim m:val="undOvr"/>  </m:mathPr></w:WordDocument></xml><![endif]--><!--[if gte mso 9]><xml> <w:LatentStyles DefLockedState="false" DefUnhideWhenUsed="false"  DefSemiHidden="false" DefQFormat="false" DefPriority="99"  LatentStyleCount="376">  <w:LsdException Locked="false" Priority="0" QFormat="true" Name="Normal"/>  <w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 1"/>  <w:LsdException Locked="false" Priority="9" SemiHidden="true"   UnhideWhenUsed="true" QFormat="true" Name="heading 2"/>  <w:LsdException Locked="false" Priority="9" SemiHidden="true"   UnhideWhenUsed="true" QFormat="true" Name="heading 3"/>  <w:LsdException Locked="false" Priority="9" SemiHidden="true"   UnhideWhenUsed="true" QFormat="true" Name="heading 4"/>  <w:LsdException Locked="false" Priority="9" SemiHidden="true"   UnhideWhenUsed="true" QFormat="true" Name="heading 5"/>  <w:LsdException Locked="false" Priority="9" SemiHidden="true"   UnhideWhenUsed="true" QFormat="true" Name="heading 6"/>  <w:LsdException Locked="false" Priority="9" SemiHidden="true"   UnhideWhenUsed="true" QFormat="true" Name="heading 7"/>  <w:LsdException Locked="false" Priority="9" SemiHidden="true"   UnhideWhenUsed="true" QFormat="true" Name="heading 8"/>  <w:LsdException Locked="false" Priority="9" SemiHidden="true"   UnhideWhenUsed="true" QFormat="true" Name="heading 9"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="index 1"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="index 2"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="index 3"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="index 4"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="index 5"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="index 6"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="index 7"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="index 8"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="index 9"/>  <w:LsdException Locked="false" Priority="39" SemiHidden="true"   UnhideWhenUsed="true" Name="toc 1"/>  <w:LsdException Locked="false" Priority="39" SemiHidden="true"   UnhideWhenUsed="true" Name="toc 2"/>  <w:LsdException Locked="false" Priority="39" SemiHidden="true"   UnhideWhenUsed="true" Name="toc 3"/>  <w:LsdException Locked="false" Priority="39" SemiHidden="true"   UnhideWhenUsed="true" Name="toc 4"/>  <w:LsdException Locked="false" Priority="39" SemiHidden="true"   UnhideWhenUsed="true" Name="toc 5"/>  <w:LsdException Locked="false" Priority="39" SemiHidden="true"   UnhideWhenUsed="true" Name="toc 6"/>  <w:LsdException Locked="false" Priority="39" SemiHidden="true"   UnhideWhenUsed="true" Name="toc 7"/>  <w:LsdException Locked="false" Priority="39" SemiHidden="true"   UnhideWhenUsed="true" Name="toc 8"/>  <w:LsdException Locked="false" Priority="39" SemiHidden="true"   UnhideWhenUsed="true" Name="toc 9"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Normal Indent"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="footnote text"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="annotation text"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="header"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="footer"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="index heading"/>  <w:LsdException Locked="false" Priority="35" SemiHidden="true"   UnhideWhenUsed="true" QFormat="true" Name="caption"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="table of figures"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="envelope address"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="envelope return"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="footnote reference"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="annotation reference"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="line number"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="page number"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="endnote reference"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="endnote text"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="table of authorities"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="macro"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="toa heading"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="List"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="List Bullet"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="List Number"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="List 2"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="List 3"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="List 4"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="List 5"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="List Bullet 2"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="List Bullet 3"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="List Bullet 4"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="List Bullet 5"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="List Number 2"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="List Number 3"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="List Number 4"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="List Number 5"/>  <w:LsdException Locked="false" Priority="10" QFormat="true" Name="Title"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Closing"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Signature"/>  <w:LsdException Locked="false" Priority="1" SemiHidden="true"   UnhideWhenUsed="true" Name="Default Paragraph Font"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Body Text"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Body Text Indent"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="List Continue"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="List Continue 2"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="List Continue 3"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="List Continue 4"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="List Continue 5"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Message Header"/>  <w:LsdException Locked="false" Priority="11" QFormat="true" Name="Subtitle"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Salutation"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Date"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Body Text First Indent"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Body Text First Indent 2"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Note Heading"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Body Text 2"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Body Text 3"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Body Text Indent 2"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Body Text Indent 3"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Block Text"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Hyperlink"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="FollowedHyperlink"/>  <w:LsdException Locked="false" Priority="22" QFormat="true" Name="Strong"/>  <w:LsdException Locked="false" Priority="20" QFormat="true" Name="Emphasis"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Document Map"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Plain Text"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="E-mail Signature"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="HTML Top of Form"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="HTML Bottom of Form"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Normal (Web)"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="HTML Acronym"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="HTML Address"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="HTML Cite"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="HTML Code"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="HTML Definition"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="HTML Keyboard"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="HTML Preformatted"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="HTML Sample"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="HTML Typewriter"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="HTML Variable"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Normal Table"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="annotation subject"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="No List"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Outline List 1"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Outline List 2"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Outline List 3"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Simple 1"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Simple 2"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Simple 3"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Classic 1"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Classic 2"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Classic 3"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Classic 4"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Colorful 1"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Colorful 2"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Colorful 3"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Columns 1"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Columns 2"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Columns 3"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Columns 4"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Columns 5"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Grid 1"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Grid 2"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Grid 3"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Grid 4"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Grid 5"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Grid 6"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Grid 7"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Grid 8"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table List 1"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table List 2"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table List 3"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table List 4"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table List 5"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table List 6"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table List 7"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table List 8"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table 3D effects 1"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table 3D effects 2"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table 3D effects 3"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Contemporary"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Elegant"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Professional"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Subtle 1"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Subtle 2"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Web 1"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Web 2"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Web 3"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Balloon Text"/>  <w:LsdException Locked="false" Priority="39" Name="Table Grid"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Table Theme"/>  <w:LsdException Locked="false" SemiHidden="true" Name="Placeholder Text"/>  <w:LsdException Locked="false" Priority="1" QFormat="true" Name="No Spacing"/>  <w:LsdException Locked="false" Priority="60" Name="Light Shading"/>  <w:LsdException Locked="false" Priority="61" Name="Light List"/>  <w:LsdException Locked="false" Priority="62" Name="Light Grid"/>  <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1"/>  <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2"/>  <w:LsdException Locked="false" Priority="65" Name="Medium List 1"/>  <w:LsdException Locked="false" Priority="66" Name="Medium List 2"/>  <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1"/>  <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2"/>  <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3"/>  <w:LsdException Locked="false" Priority="70" Name="Dark List"/>  <w:LsdException Locked="false" Priority="71" Name="Colorful Shading"/>  <w:LsdException Locked="false" Priority="72" Name="Colorful List"/>  <w:LsdException Locked="false" Priority="73" Name="Colorful Grid"/>  <w:LsdException Locked="false" Priority="60" Name="Light Shading Accent 1"/>  <w:LsdException Locked="false" Priority="61" Name="Light List Accent 1"/>  <w:LsdException Locked="false" Priority="62" Name="Light Grid Accent 1"/>  <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1 Accent 1"/>  <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2 Accent 1"/>  <w:LsdException Locked="false" Priority="65" Name="Medium List 1 Accent 1"/>  <w:LsdException Locked="false" SemiHidden="true" Name="Revision"/>  <w:LsdException Locked="false" Priority="34" QFormat="true"   Name="List Paragraph"/>  <w:LsdException Locked="false" Priority="29" QFormat="true" Name="Quote"/>  <w:LsdException Locked="false" Priority="30" QFormat="true"   Name="Intense Quote"/>  <w:LsdException Locked="false" Priority="66" Name="Medium List 2 Accent 1"/>  <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1 Accent 1"/>  <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2 Accent 1"/>  <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3 Accent 1"/>  <w:LsdException Locked="false" Priority="70" Name="Dark List Accent 1"/>  <w:LsdException Locked="false" Priority="71" Name="Colorful Shading Accent 1"/>  <w:LsdException Locked="false" Priority="72" Name="Colorful List Accent 1"/>  <w:LsdException Locked="false" Priority="73" Name="Colorful Grid Accent 1"/>  <w:LsdException Locked="false" Priority="60" Name="Light Shading Accent 2"/>  <w:LsdException Locked="false" Priority="61" Name="Light List Accent 2"/>  <w:LsdException Locked="false" Priority="62" Name="Light Grid Accent 2"/>  <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1 Accent 2"/>  <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2 Accent 2"/>  <w:LsdException Locked="false" Priority="65" Name="Medium List 1 Accent 2"/>  <w:LsdException Locked="false" Priority="66" Name="Medium List 2 Accent 2"/>  <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1 Accent 2"/>  <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2 Accent 2"/>  <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3 Accent 2"/>  <w:LsdException Locked="false" Priority="70" Name="Dark List Accent 2"/>  <w:LsdException Locked="false" Priority="71" Name="Colorful Shading Accent 2"/>  <w:LsdException Locked="false" Priority="72" Name="Colorful List Accent 2"/>  <w:LsdException Locked="false" Priority="73" Name="Colorful Grid Accent 2"/>  <w:LsdException Locked="false" Priority="60" Name="Light Shading Accent 3"/>  <w:LsdException Locked="false" Priority="61" Name="Light List Accent 3"/>  <w:LsdException Locked="false" Priority="62" Name="Light Grid Accent 3"/>  <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1 Accent 3"/>  <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2 Accent 3"/>  <w:LsdException Locked="false" Priority="65" Name="Medium List 1 Accent 3"/>  <w:LsdException Locked="false" Priority="66" Name="Medium List 2 Accent 3"/>  <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1 Accent 3"/>  <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2 Accent 3"/>  <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3 Accent 3"/>  <w:LsdException Locked="false" Priority="70" Name="Dark List Accent 3"/>  <w:LsdException Locked="false" Priority="71" Name="Colorful Shading Accent 3"/>  <w:LsdException Locked="false" Priority="72" Name="Colorful List Accent 3"/>  <w:LsdException Locked="false" Priority="73" Name="Colorful Grid Accent 3"/>  <w:LsdException Locked="false" Priority="60" Name="Light Shading Accent 4"/>  <w:LsdException Locked="false" Priority="61" Name="Light List Accent 4"/>  <w:LsdException Locked="false" Priority="62" Name="Light Grid Accent 4"/>  <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1 Accent 4"/>  <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2 Accent 4"/>  <w:LsdException Locked="false" Priority="65" Name="Medium List 1 Accent 4"/>  <w:LsdException Locked="false" Priority="66" Name="Medium List 2 Accent 4"/>  <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1 Accent 4"/>  <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2 Accent 4"/>  <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3 Accent 4"/>  <w:LsdException Locked="false" Priority="70" Name="Dark List Accent 4"/>  <w:LsdException Locked="false" Priority="71" Name="Colorful Shading Accent 4"/>  <w:LsdException Locked="false" Priority="72" Name="Colorful List Accent 4"/>  <w:LsdException Locked="false" Priority="73" Name="Colorful Grid Accent 4"/>  <w:LsdException Locked="false" Priority="60" Name="Light Shading Accent 5"/>  <w:LsdException Locked="false" Priority="61" Name="Light List Accent 5"/>  <w:LsdException Locked="false" Priority="62" Name="Light Grid Accent 5"/>  <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1 Accent 5"/>  <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2 Accent 5"/>  <w:LsdException Locked="false" Priority="65" Name="Medium List 1 Accent 5"/>  <w:LsdException Locked="false" Priority="66" Name="Medium List 2 Accent 5"/>  <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1 Accent 5"/>  <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2 Accent 5"/>  <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3 Accent 5"/>  <w:LsdException Locked="false" Priority="70" Name="Dark List Accent 5"/>  <w:LsdException Locked="false" Priority="71" Name="Colorful Shading Accent 5"/>  <w:LsdException Locked="false" Priority="72" Name="Colorful List Accent 5"/>  <w:LsdException Locked="false" Priority="73" Name="Colorful Grid Accent 5"/>  <w:LsdException Locked="false" Priority="60" Name="Light Shading Accent 6"/>  <w:LsdException Locked="false" Priority="61" Name="Light List Accent 6"/>  <w:LsdException Locked="false" Priority="62" Name="Light Grid Accent 6"/>  <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1 Accent 6"/>  <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2 Accent 6"/>  <w:LsdException Locked="false" Priority="65" Name="Medium List 1 Accent 6"/>  <w:LsdException Locked="false" Priority="66" Name="Medium List 2 Accent 6"/>  <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1 Accent 6"/>  <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2 Accent 6"/>  <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3 Accent 6"/>  <w:LsdException Locked="false" Priority="70" Name="Dark List Accent 6"/>  <w:LsdException Locked="false" Priority="71" Name="Colorful Shading Accent 6"/>  <w:LsdException Locked="false" Priority="72" Name="Colorful List Accent 6"/>  <w:LsdException Locked="false" Priority="73" Name="Colorful Grid Accent 6"/>  <w:LsdException Locked="false" Priority="19" QFormat="true"   Name="Subtle Emphasis"/>  <w:LsdException Locked="false" Priority="21" QFormat="true"   Name="Intense Emphasis"/>  <w:LsdException Locked="false" Priority="31" QFormat="true"   Name="Subtle Reference"/>  <w:LsdException Locked="false" Priority="32" QFormat="true"   Name="Intense Reference"/>  <w:LsdException Locked="false" Priority="33" QFormat="true" Name="Book Title"/>  <w:LsdException Locked="false" Priority="37" SemiHidden="true"   UnhideWhenUsed="true" Name="Bibliography"/>  <w:LsdException Locked="false" Priority="39" SemiHidden="true"   UnhideWhenUsed="true" QFormat="true" Name="TOC Heading"/>  <w:LsdException Locked="false" Priority="41" Name="Plain Table 1"/>  <w:LsdException Locked="false" Priority="42" Name="Plain Table 2"/>  <w:LsdException Locked="false" Priority="43" Name="Plain Table 3"/>  <w:LsdException Locked="false" Priority="44" Name="Plain Table 4"/>  <w:LsdException Locked="false" Priority="45" Name="Plain Table 5"/>  <w:LsdException Locked="false" Priority="40" Name="Grid Table Light"/>  <w:LsdException Locked="false" Priority="46" Name="Grid Table 1 Light"/>  <w:LsdException Locked="false" Priority="47" Name="Grid Table 2"/>  <w:LsdException Locked="false" Priority="48" Name="Grid Table 3"/>  <w:LsdException Locked="false" Priority="49" Name="Grid Table 4"/>  <w:LsdException Locked="false" Priority="50" Name="Grid Table 5 Dark"/>  <w:LsdException Locked="false" Priority="51" Name="Grid Table 6 Colorful"/>  <w:LsdException Locked="false" Priority="52" Name="Grid Table 7 Colorful"/>  <w:LsdException Locked="false" Priority="46"   Name="Grid Table 1 Light Accent 1"/>  <w:LsdException Locked="false" Priority="47" Name="Grid Table 2 Accent 1"/>  <w:LsdException Locked="false" Priority="48" Name="Grid Table 3 Accent 1"/>  <w:LsdException Locked="false" Priority="49" Name="Grid Table 4 Accent 1"/>  <w:LsdException Locked="false" Priority="50" Name="Grid Table 5 Dark Accent 1"/>  <w:LsdException Locked="false" Priority="51"   Name="Grid Table 6 Colorful Accent 1"/>  <w:LsdException Locked="false" Priority="52"   Name="Grid Table 7 Colorful Accent 1"/>  <w:LsdException Locked="false" Priority="46"   Name="Grid Table 1 Light Accent 2"/>  <w:LsdException Locked="false" Priority="47" Name="Grid Table 2 Accent 2"/>  <w:LsdException Locked="false" Priority="48" Name="Grid Table 3 Accent 2"/>  <w:LsdException Locked="false" Priority="49" Name="Grid Table 4 Accent 2"/>  <w:LsdException Locked="false" Priority="50" Name="Grid Table 5 Dark Accent 2"/>  <w:LsdException Locked="false" Priority="51"   Name="Grid Table 6 Colorful Accent 2"/>  <w:LsdException Locked="false" Priority="52"   Name="Grid Table 7 Colorful Accent 2"/>  <w:LsdException Locked="false" Priority="46"   Name="Grid Table 1 Light Accent 3"/>  <w:LsdException Locked="false" Priority="47" Name="Grid Table 2 Accent 3"/>  <w:LsdException Locked="false" Priority="48" Name="Grid Table 3 Accent 3"/>  <w:LsdException Locked="false" Priority="49" Name="Grid Table 4 Accent 3"/>  <w:LsdException Locked="false" Priority="50" Name="Grid Table 5 Dark Accent 3"/>  <w:LsdException Locked="false" Priority="51"   Name="Grid Table 6 Colorful Accent 3"/>  <w:LsdException Locked="false" Priority="52"   Name="Grid Table 7 Colorful Accent 3"/>  <w:LsdException Locked="false" Priority="46"   Name="Grid Table 1 Light Accent 4"/>  <w:LsdException Locked="false" Priority="47" Name="Grid Table 2 Accent 4"/>  <w:LsdException Locked="false" Priority="48" Name="Grid Table 3 Accent 4"/>  <w:LsdException Locked="false" Priority="49" Name="Grid Table 4 Accent 4"/>  <w:LsdException Locked="false" Priority="50" Name="Grid Table 5 Dark Accent 4"/>  <w:LsdException Locked="false" Priority="51"   Name="Grid Table 6 Colorful Accent 4"/>  <w:LsdException Locked="false" Priority="52"   Name="Grid Table 7 Colorful Accent 4"/>  <w:LsdException Locked="false" Priority="46"   Name="Grid Table 1 Light Accent 5"/>  <w:LsdException Locked="false" Priority="47" Name="Grid Table 2 Accent 5"/>  <w:LsdException Locked="false" Priority="48" Name="Grid Table 3 Accent 5"/>  <w:LsdException Locked="false" Priority="49" Name="Grid Table 4 Accent 5"/>  <w:LsdException Locked="false" Priority="50" Name="Grid Table 5 Dark Accent 5"/>  <w:LsdException Locked="false" Priority="51"   Name="Grid Table 6 Colorful Accent 5"/>  <w:LsdException Locked="false" Priority="52"   Name="Grid Table 7 Colorful Accent 5"/>  <w:LsdException Locked="false" Priority="46"   Name="Grid Table 1 Light Accent 6"/>  <w:LsdException Locked="false" Priority="47" Name="Grid Table 2 Accent 6"/>  <w:LsdException Locked="false" Priority="48" Name="Grid Table 3 Accent 6"/>  <w:LsdException Locked="false" Priority="49" Name="Grid Table 4 Accent 6"/>  <w:LsdException Locked="false" Priority="50" Name="Grid Table 5 Dark Accent 6"/>  <w:LsdException Locked="false" Priority="51"   Name="Grid Table 6 Colorful Accent 6"/>  <w:LsdException Locked="false" Priority="52"   Name="Grid Table 7 Colorful Accent 6"/>  <w:LsdException Locked="false" Priority="46" Name="List Table 1 Light"/>  <w:LsdException Locked="false" Priority="47" Name="List Table 2"/>  <w:LsdException Locked="false" Priority="48" Name="List Table 3"/>  <w:LsdException Locked="false" Priority="49" Name="List Table 4"/>  <w:LsdException Locked="false" Priority="50" Name="List Table 5 Dark"/>  <w:LsdException Locked="false" Priority="51" Name="List Table 6 Colorful"/>  <w:LsdException Locked="false" Priority="52" Name="List Table 7 Colorful"/>  <w:LsdException Locked="false" Priority="46"   Name="List Table 1 Light Accent 1"/>  <w:LsdException Locked="false" Priority="47" Name="List Table 2 Accent 1"/>  <w:LsdException Locked="false" Priority="48" Name="List Table 3 Accent 1"/>  <w:LsdException Locked="false" Priority="49" Name="List Table 4 Accent 1"/>  <w:LsdException Locked="false" Priority="50" Name="List Table 5 Dark Accent 1"/>  <w:LsdException Locked="false" Priority="51"   Name="List Table 6 Colorful Accent 1"/>  <w:LsdException Locked="false" Priority="52"   Name="List Table 7 Colorful Accent 1"/>  <w:LsdException Locked="false" Priority="46"   Name="List Table 1 Light Accent 2"/>  <w:LsdException Locked="false" Priority="47" Name="List Table 2 Accent 2"/>  <w:LsdException Locked="false" Priority="48" Name="List Table 3 Accent 2"/>  <w:LsdException Locked="false" Priority="49" Name="List Table 4 Accent 2"/>  <w:LsdException Locked="false" Priority="50" Name="List Table 5 Dark Accent 2"/>  <w:LsdException Locked="false" Priority="51"   Name="List Table 6 Colorful Accent 2"/>  <w:LsdException Locked="false" Priority="52"   Name="List Table 7 Colorful Accent 2"/>  <w:LsdException Locked="false" Priority="46"   Name="List Table 1 Light Accent 3"/>  <w:LsdException Locked="false" Priority="47" Name="List Table 2 Accent 3"/>  <w:LsdException Locked="false" Priority="48" Name="List Table 3 Accent 3"/>  <w:LsdException Locked="false" Priority="49" Name="List Table 4 Accent 3"/>  <w:LsdException Locked="false" Priority="50" Name="List Table 5 Dark Accent 3"/>  <w:LsdException Locked="false" Priority="51"   Name="List Table 6 Colorful Accent 3"/>  <w:LsdException Locked="false" Priority="52"   Name="List Table 7 Colorful Accent 3"/>  <w:LsdException Locked="false" Priority="46"   Name="List Table 1 Light Accent 4"/>  <w:LsdException Locked="false" Priority="47" Name="List Table 2 Accent 4"/>  <w:LsdException Locked="false" Priority="48" Name="List Table 3 Accent 4"/>  <w:LsdException Locked="false" Priority="49" Name="List Table 4 Accent 4"/>  <w:LsdException Locked="false" Priority="50" Name="List Table 5 Dark Accent 4"/>  <w:LsdException Locked="false" Priority="51"   Name="List Table 6 Colorful Accent 4"/>  <w:LsdException Locked="false" Priority="52"   Name="List Table 7 Colorful Accent 4"/>  <w:LsdException Locked="false" Priority="46"   Name="List Table 1 Light Accent 5"/>  <w:LsdException Locked="false" Priority="47" Name="List Table 2 Accent 5"/>  <w:LsdException Locked="false" Priority="48" Name="List Table 3 Accent 5"/>  <w:LsdException Locked="false" Priority="49" Name="List Table 4 Accent 5"/>  <w:LsdException Locked="false" Priority="50" Name="List Table 5 Dark Accent 5"/>  <w:LsdException Locked="false" Priority="51"   Name="List Table 6 Colorful Accent 5"/>  <w:LsdException Locked="false" Priority="52"   Name="List Table 7 Colorful Accent 5"/>  <w:LsdException Locked="false" Priority="46"   Name="List Table 1 Light Accent 6"/>  <w:LsdException Locked="false" Priority="47" Name="List Table 2 Accent 6"/>  <w:LsdException Locked="false" Priority="48" Name="List Table 3 Accent 6"/>  <w:LsdException Locked="false" Priority="49" Name="List Table 4 Accent 6"/>  <w:LsdException Locked="false" Priority="50" Name="List Table 5 Dark Accent 6"/>  <w:LsdException Locked="false" Priority="51"   Name="List Table 6 Colorful Accent 6"/>  <w:LsdException Locked="false" Priority="52"   Name="List Table 7 Colorful Accent 6"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Mention"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Smart Hyperlink"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Hashtag"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Unresolved Mention"/>  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"   Name="Smart Link"/> </w:LatentStyles></xml><![endif]--><!--[if gte mso 10]><style> /* Style Definitions */ table.MsoNormalTable	{mso-style-name:"Tabla normal";	mso-tstyle-rowband-size:0;	mso-tstyle-colband-size:0;	mso-style-noshow:yes;	mso-style-priority:99;	mso-style-parent:"";	mso-padding-alt:0cm 5.4pt 0cm 5.4pt;	mso-para-margin:0cm;	mso-pagination:widow-orphan;	font-size:10.0pt;	font-family:"Times New Roman",serif;}</style><![endif]--><b><span style="font-size:10.0pt;font-family:" times="" new="" roman",serif;mso-ansi-language:es-uy;mso-fareast-language:es-ec"="" lang="ES-UY"><strong> TÉRMINOS Y CONDICIONES DE GOLTV PLAY</strong></span></b><p class="MsoNormal" style="margin-top:13.7pt;margin-right:0cm;margin-bottom:13.7pt;margin-left:0cm"><p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">MEGADATOS está feliz de darle la bienvenida a “Gol Tv
Play”, plataforma operada por Gol Tv Latinamerica S.A. (“GolTv”). Los presentes
Términos y Condiciones de Uso (en adelante “Términos y Condiciones”) describen
los términos que rigen el uso que el usuario haga de los Productos de GolTv
(como se define más adelante). Los presentes Términos y Condiciones se aplican
a los sitios web de entretenimiento de http://play.goltv.tv (“Sitio de GolTv”),
sitios móviles, aplicaciones (“apps”) tales como “GOLTV PLAY” y widgets. Estos
Términos y Condiciones rigen el uso que el usuario haga del Sitio de GolTv
relacionado con su entretenimiento, programación original, sitios móviles,
aplicaciones (“apps”) tales como “GOLTV PLAY”, widgets, Productos de GolTv
(como se define más adelante) y otros contenidos y servicios vinculados con los
presentes Términos y Condiciones (denominados en forma colectiva, los
“Productos de GolTv”). <o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">AL USAR EL SERVICIO, USTED ACEPTA CUMPLIR CON LAS
CONDICIONES DE USO, POR LO QUE LE PEDIMOS DEDIQUE UN TIEMPO A REVISARLAS
CUIDADOSAMENTE, Y SI NO ESTÁ DE ACUERDO CON LAS MISMAS, NO DEBERÍA UTILIZAR EL
SERVICIO. <o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">LOS TÉRMINOS DE USO DE LA PLATAFORMA SERÁN AQUELLOS
DEFINIDOS POR GOLTV, DETALLADOS EN EL SIGUIENTE LINK
HTTPS://PLAY.GOLTV.TV/TERMS<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Para poder acceder a los Productos de GolTv, el
usuario debe ser un abonado con una cuenta vigente de un proveedor de servicios
autorizado por GolTv para distribuir los Productos de GolTv (requisito de
elegibilidad), en este caso MEGADATOS (en adelante “El Distribuidor")<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">MEGADATOS puede modificar los presentes Términos y
Condiciones en cualquier momento, y dichas modificaciones serán efectiva al
momento de su publicación en su página web
(https://www.netlife.ec/terminos-y-condiciones/#serviciosAdicionales). Su
continuación del uso de los Productos de GolTv después de cualquier
modificación constituye la aceptación de su voluntad de obligarse en virtud de
los presentes Términos y Condiciones con sus modificaciones. <o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Mediante el uso de los Productos de GolTv y el aporte
de sus datos personales, el usuario acepta irrevocablemente que MEGADATOS
utilice los mismos para la comunicación de noticias e información, ofertas
especiales y cualquier otra información que, a juicio de MEGADATOS, pueda
resultar de interés del cliente, de conformidad a lo previsto Ley Orgánica de
Protección de Datos Personales.<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Asimismo, el usuario acepta que MEGADATOS utilice sus
datos para formular estadísticas de uso interno, ofrecer un servicio
personalizado, brindar sugerencias y recomendaciones al cliente basadas en sus
hábitos de consumo, mejorar el soporte técnico o de facturación al cliente,
mejorar y ampliar la oferta de contenidos, entre otros fines relacionados con
la optimización de los Productos de GolTv.<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><b><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">02- Suscripción<o:p></o:p></span></b></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Para acceder a ciertos Productos de GolTv el usuario
deberá seleccionar su Distribuidor (Netlife) y será re-dirigido a la página de
registro del sitio web de su Distribuidor (Netlife) donde deberá registrarse
directamente con su Distribuidor (en adelante el “Sitio del Distribuidor”). El
Sitio del Distribuidor es alojado y administrado por su Distribuidor
(MEGADATOS), encontrándose por tanto en esta instancia el usuario bajo los
términos de contratación establecidos por el Distribuidor (MEGADATOS).<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Además de tener una Cuenta de Distribuidor, algunos de
los Productos de GolTv requieren que el usuario cree un perfil de Productos de
GolTv (el que puede requerir la creación de un nombre de usuario y enviar su
correo electrónico a GolTv) para participar o reservar ciertos Servicios
adicionales de GolTv, comprar Productos en el Sitio de GolTv adicionales, y
suscribirse a boletines específicos de los Productos de GolTv (en adelante el “Perfil
de Productos de GolTv”).<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">MEGADATOS S.A. le entregará vía correo electrónico y/o
sms las credenciales para acceder al Servicio, las cuales son de carácter
personal e intransferible. Toda la información de registro que proporcione debe
ser exacta y actualizada. Mantenga la confidencialidad de su contraseña. Si
revela a otros su contraseña o comparte su cuenta y/o dispositivos con otras
personas, deberá asumir toda la responsabilidad derivada de las acciones de
dichas personas. Usted es responsable de todo uso en su cuenta, incluyendo el
uso no autorizado de terceros, por lo que le pedimos sea muy cuidadoso para
proteger la seguridad de su contraseña. Notifíquenos inmediatamente si llega a
saber o sospechar de usos no autorizados de su cuenta, al 3920000 o mediante
correo electrónico a play@goltv.tv<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">En caso de requerirlo, el usuario podrá recibir
soporte respecto el reenvío de sus credenciales y cuestiones técnicas
relacionadas con la plataforma como reproducción de video, contenidos no
disponibles, errores en las imágenes de los contenidos, entre otros, a través
de correo electrónico a play@goltv.tv o llamando al 3920000. <o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">La entrega de este producto no incluye el servicio de
instalación de este en ningún dispositivo. El usuario es responsable de la
instalación y configuración del producto en sus dispositivos.<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">El usuario es responsable de todas las actividades que
ocurran bajo su Cuenta de Distribuidor y Perfil de Productos GolTv, debiendo
mantener la confidencialidad de la información de su cuenta. El usuario se
compromete a: (i) notificar inmediatamente a su Distribuidor (MEGADATOS)
cualquier uso no autorizado de la información de su Cuenta de Distribuidor;
(ii) asegurarse de que el usuario o bien cualquier tercero autorizado al
ingreso de las cuentas utilice las mismas con la debida prudencia y resguardo
de los datos y claves de acceso. MEGADATOS no se hace responsable de cualquier
pérdida o daño causado por su uso o mal uso de su Cuenta de Distribuidor, de su
Perfil de Productos de GolTv, o por el incumplimiento de los requisitos de
registro. Es una condición de uso de los Productos de GolTv y MEGADATOS que
todos los datos que el usuario proporcione sean correctos, actuales y completos
y que no violen ninguna Ley Aplicable. En caso de que GolTv, sus Compañías
Afiliadas, o algún Distribuidor (MEGADATOS), considere que la información no es
correcta, actual o completa, o que el usuario ha violado de cualquier otra
forma los presentes Términos y Condiciones o cualquier Ley Aplicable, MEGADATOS
se reserva el derecho de suspender o cancelar su Cuenta de Distribuidor, o
impedir su acceso a los Productos de GolTv. Se encuentra terminantemente
prohibido: (i) utilizar la cuenta, el nombre de usuario, la dirección de correo
electrónico, la contraseña o el código de verificación de otra persona en
ningún momento, o (ii) utilizar un nombre de usuario como un nombre sujeto a
los derechos de otra persona sin la autorización apropiada. <o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><b><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">0.3 El Servicio<o:p></o:p></span></b></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Una vez registrado ofrecemos el acceso a los partidos
de la LIGA PRO ecuatoriana, además de programación lineal 24 horas de GOLTV
Ecuador con comentaristas deportivos.<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">El precio de GOLTV Play como servicio adicional es de
$9.99(NUEVE DÓLARES DE LOS ESTADOS UNIDOS CON 99/100) mensual incluido IVA.<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">La calidad de visualización de streaming del Contenido
puede variar de una computadora y/o dispositivo a otro, y diversos factores
pueden afectarla, como el lugar donde usted se ubica, el ancho de banda
disponible y/o la velocidad de su conexión de Internet. Usted debe estar
conectado a Internet en todo momento para ver el Contenido. <o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">SE LE PERMITIRÁ VER EL CONTENIDO EN DOS DISPOSITIVOS
AL MISMO TIEMPO POR CUENTA DE USUARIO. El número de dispositivos y de
streamings simultáneos pueden cambiar sin notificación previa. <o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX"><o:p> </o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><b><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">04- Declaraciones<o:p></o:p></span></b></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Al acceder o usufructuar de cualquier otra forma los
Productos de GolTv en cualquier forma, el usuario declara y garantiza ser
residente del Territorio Autorizado para utilizar dicho Producto de GolTv; que
ha cumplido con el requisito de elegibilidad; que tiene capacidad legal para
aceptar los presentes Términos y Condiciones (es decir, que tiene por lo menos
dieciocho (18) años de edad o la edad suficiente para ser considerado mayor de
edad en su país de residencia y que posee la capacidad mental suficiente y que
está de cualquier otra forma capacitado para contraer obligaciones
contractuales); y que se compromete a respetar todas las Leyes Aplicables. El
usuario declara haber leído y aceptar cumplir los presentes Términos y
Condiciones.<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><b><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">05- Licencia<o:p></o:p></span></b></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">El usuario contrata a través de MEGADATOS una licencia
limitada, revocable, no exclusiva y no transferible para acceder y usufructuar
en forma privada los Productos de GolTv exclusivamente en la forma dispuesta en
los presentes Términos y Condiciones sólo para su usufructo personal, no
comercial, y siempre y cuando el usuario continúe cumpliendo con el requisito
de elegibilidad y que no incumpla los presentes Términos y Condiciones. Tenga
en cuenta que para acceder a los Productos de GolTv, el dispositivo del usuario
debe estar conectado a internet, y será el usuario el único responsable del
costo y mantenimiento de dicha conexión a internet. Es responsabilidad
exclusiva del usuario asegurarse de que tiene acceso a las plataformas
adecuadas requeridas para acceder a los Productos de GolTv. <o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Dicha licencia le permite al usuario acceder,
usufructuar, ver por streaming y acceder a video, audio, gráficos, fotos,
texto, características especiales, software, obras de autor, aplicaciones,
sonidos y/o mensajes (en forma colectiva el "Contenido") a través de
los Productos de GolTv, de acuerdo con los términos de los presentes Términos y
Condiciones durante el período en el usuario cumpla con el requisito de
elegibilidad y por la duración que el elemento de contenido solicitado sea
accesible a través de los Productos de GolTv, Cualquier copia de los Productos
de GolTv, el Contenido o cualquier parte del mismo constituirá una violación de
los derechos de autor. <o:p></o:p></span></p>

');

DBMS_LOB.APPEND(bada,'
<p class="MsoNormal" style="text-align:justify"><b><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">06- Contenido y limitaciones de contenido<o:p></o:p></span></b></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">El Contenido, incluidos entre otros, video, audio,
gráficos, fotos, texto, características especiales, software y mensajes pueden
ser puestos a disposición a través de streaming o de cualquier otro medio. <o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">MEGADATOS y GolTv se reservan el derecho, a su total
discreción, de bloquear el acceso a cualquier Contenido en cualquier momento,
independientemente de los Tiempos de Acceso de Contenido o de sus horarios de
programación.<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">El acceso a determinados Contenidos puede depender de
la ubicación del usuario, de que el usuario sea capaz de tener una conexión a
Internet, ancho de banda disponible y del equipo utilizado para acceder a los
Productos de GolTv. No existirá ningún tipo de transferencia de propiedad de
cualquier parte del Contenido como resultado de cualquier acceso que se le
conceda al usuario a los Productos de GolTv.<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Los Productos de GolTv contienen información, texto,
archivos, imágenes, video, sonido, obras musicales, obras de autor, materiales,
aplicaciones, software, nombres de productos, nombre de compañías, marcas
comerciales, logos, diseños y otros materiales o contenidos (colectivamente
denominados, el “Contenido”) de GolTv, sus matrices, subsidiarias o afiliadas de
GolTv (“Compañías Afiliadas”) y sus licenciatarios y cedentes (“Contenido de
GolTv”), así como material y Contenido suministrado por usuarios (“Contenido de
Usuarios”) u otros terceros. El Contenido de GolTv ubicado en los Productos de
GolTv está protegido por derechos de autor, marca comercial, patente, secreto
comercial y otras leyes y, entre el usuario y GolTv, GolTv, sus licenciatarios
o sus cedentes, poseen y retienen todos los derechos sobre el Contenido de
GolTv y los Productos de GolTv. Los Productos de GolTv pueden también contener
Contenido de Usuarios. Excepto por lo provisto en los presentes Términos y
Condiciones, el usuario no podrá copiar, descargar, capturar por streaming,
reproducir, duplicar, archivar, subir, modificar, traducir, publicar,
transmitir, retransmitir, distribuir, ejecutar, exhibir, vender, enmarcar o
crear un enlace, hacer disponible o usar de cualquier otra forma ningún
Contenido de los Productos de GolTv.<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">El usuario no podrá, ya sea en forma directa o través
del uso de cualquier dispositivo, Software, sitio de Internet, servicio web o
cualquier otro medio, eliminar, alterar, eludir, evitar, interferir o burlar
ninguna obra protegida por derechos de autor, marca comercial u otro derecho de
propiedad intelectual marcado en el Contenido de GolTv ubicado en los Productos
de GolTv o cualquier otro mecanismo de control de derechos digitales,
dispositivo u otra protección de contenido, control de copia o acceso a medidas
de control asociadas con el Contenido de GolTv, incluido los mecanismos de geo
bloqueo.<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">El usuario no podrá intentar obtener acceso no
autorizado a los Productos de GolTv a través de la piratería, extracción de
contraseñas o cualquier otro medio. MEGADATOS, se reserva el derecho a
terminar, suspender o restringir de inmediato su cuenta, el uso de los
Servicios, o el acceso al Contenido, en cualquier momento, sin notificación o
responsabilidad alguna, si MEGADATOS, a su absoluta discreción, determina que
usted ha incumplido con las Condiciones de Uso, leyes, normas o reglamentos, ha
participado en otras conductas inapropiadas, incluso si el uso de los Servicios
o el acceso al Contenido por su parte impone una carga indebida en nuestras
redes o servidores. <o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><b><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">07- Actualizaciones de servicio y software<o:p></o:p></span></b></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">GolTv podrá poner a disposición actualizaciones,
corrección de errores u otros cambios o mejoras a los Productos de GolTv
(denominados en forma colectiva, "Actualizaciones del Producto"). Las
Actualizaciones del Producto pueden ser: (i) automáticas, como las relacionadas
con los cambios generales del sitio web y funciones adicionales o
actualizaciones de los datos requeridos por los Productos de GolTv; y (ii)
obligatorias, en cuyo caso se le solicitará su consentimiento para la
Actualización del Producto o instalar o actualizar un plug-in de terceros si
desea mantener el acceso ininterrumpido a los Productos de GolTv. Para poder
disfrutar de la mejor experiencia y acceso al Contenido disponible es necesario
que actualice sus dispositivos a la última versión disponible.<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><b><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">08- Cancelación<o:p></o:p></span></b></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Estos Términos y Condiciones se mantienen vigentes y
en efecto, a menos que MEGADATOS y GolTv lo rescindan a su total discreción en
caso de que GolTv deje de ostentar los derechos de transmisión de los Productos
de GolTv, mientras que el usuario usufructe los Productos de GolTv, debiendo
GolTv y MEGADATOS informar en dicho caso al usuario las razones de dicha
rescisión. El usuario puede cancelar su cuenta en cualquier momento, por
cualquier razón, de las siguientes formas: (i) para cancelar su Perfil de
Productos de GolTv por favor enviar un correo electrónico a play@goltv.tv. Para
cancelar su Cuenta con MEGADATOS, la cual incluye su suscripción de los
Productos de GolTv, debe contactarse al 3920000 o acercarse a las oficinas de
atención de MEGADATOS a nivel nacional. En el caso de existir una cancelación
anticipada el usuario acepta el cobro de los beneficios entregados al mismo
como promociones, descuentos, valores de meses restantes para cumplir un tiempo
mínimo de permanencia acordado.<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Posteriormente a que el usuario de MEGADATOS cancele
la suscripción y/o acceso a los Productos de GolTv, los presentes Términos y
Condiciones continuarán vigentes y en efecto con respecto al uso pasado o
futuro de los Productos de GolTv. El Perfil de Productos de GolTv, la Cuenta de
Distribuidor (Cuenta usuario MEGADATOS) y/o suscripción de cada usuario no es
transferible. <o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">La suscripción de Distribuidor con MEGADATOS, a los
Productos de GolTv, continuará vigente mes a mes, a menos y hasta que el
usuario cancele la suscripción, o la cuenta o el servicio se suspenda o
descontinúe de otra forma conforme a las condiciones de uso. Para evitar la
facturación del próximo mes, debe cancelar la suscripción a los Productos de
GolTv antes de que se renueve su ciclo mensual. TOME EN CUENTA QUE NO OTORGAMOS
REEMBOLSOS NI CRÉDITOS POR MEMBRESÍAS CANCELADAS A LA MITAD DEL MES CORRIENTE O
POR PARTIDOS NO VISTOS O SUSPENSIÓN DE PARTIDOS. POR LO TANTO, USTED DEBE DE
PAGAR EL MES COMPLETO DE SERVICIO CORRESPONDIENTE AL CICLO MENSUAL EN QUE
CANCELO EL SERVICIO, Y DICHA CANCELACION SERA EFECTIVA EN EL ULTIMO DIA DE
DICHO CICLO MENSUAL, PUDIENDO ACCESAR AL SERVICIO HASTA DICHA FECHA. <o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><b><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">09- Tarifas<o:p></o:p></span></b></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">MEGADATOS se reserva el derecho a cobrar una tarifa
por los Productos de GolTv. El usuario al iniciar su membresía con MEGADATOS,
expresamente acuerda que nosotros estamos autorizados a realizar el cargo
mensual (de acuerdo con su ciclo de facturación), de membresía a la tarifa que
esté vigente, así como cualquier otro cargo en que pueda incurrir respecto al
uso del Servicio, incluyendo los impuestos aplicables, a la Forma de Pago que
usted proporcionó durante el registro. El cargo se incorporará en su factura y
a partir de entonces cada mes (de acuerdo con su ciclo facturación), por un
tiempo mínimo de permanencia sujeto a cambios y especificados en el momento de
la contratación, a menos y hasta que usted cancele la membresía, y o la Forma
de Pago venza o no proceda. <o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">El primer mes de servicio, el usuario no pagará el
valor total, sino el valor proporcional por el tiempo que haya recibido el
servicio de acuerdo con su ciclo de facturación (Ciclo 1: Del 1 al 30 del mes o
Ciclo 2: Del 15 al 14 del mes siguiente). LOS PAGOS NO SON REEMBOLSABLES Y NO
HABRÁ REEMBOLSOS O CRÉDITOS POR PERIODOS UTILIZADOS PARCIALMENTE. La
suscripción permite ver los partidos de la Liga Pro ecuatoriana y programación
lineal 24 horas de GOLTV Ecuador<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">El monto y la forma de los créditos, y la decisión de
otorgarlos, son a nuestra absoluta y exclusiva discreción. El otorgamiento de créditos
en un solo caso no le da derecho a créditos en el futuro por casos similares,
ni nos obliga a otorgar créditos en el futuro, bajo ninguna circunstancia. NO
OTORGAMOS REEMBOLSOS O CRÉDITOS POR MEMBRESÍA DE MES PARCIAL NI POR PARTIDOS O
PROGRAMAS NO VISTOS<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Es importante que todos los usuarios del Servicio
cumplan con las obligaciones de pago a las cuales han convenido; por tanto, nos
reservamos el derecho a tomar las medidas necesarias para recuperar los montos
relativos que haya dejado de pagar. Usted seguirá siendo responsable ante
MEGADATOS de todos esos montos, así como de todos los gastos en que incurramos
para su cobro, incluyendo, entre otros, honorarios de la agencia de cobranza,
honorarios razonables de abogado, y costas legales. <o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">De tiempo en tiempo podemos, mas no estamos obligados
a, ofrecerle pruebas gratuitas, pero para hacer uso de estas ofertas, debe
tener acceso a Internet y además, puede requerirse que cuente con una forma de
pago aceptada, válida y actual. Podemos comenzar a facturar el cargo mensual a
través de la Forma de Pago al final del periodo de prueba gratuita o promoción.
Usted acuerda que la Forma de Pago puede estar autorizada hasta por
aproximadamente un mes de servicio inmediatamente de que se registre.
Continuaremos facturando el cargo mensual a través de la Forma de Pago hasta
que la cancele (ver la sección “Cancelación”). Las ofertas de pruebas gratuitas
también pueden estar sujetas a términos y condiciones adicionales que se ponen
a su disposición durante la inscripción. <o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><b><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">10- Uso de los Productos de GolTv<o:p></o:p></span></b></p>

');
 
DBMS_LOB.APPEND(bada, '
<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">MEGADATOS y GolTv se reservan el derecho de eliminar
Contenido comercial o Contenido de Usuario a su total discreción. El usuario
entiende que es responsable por todo el Contenido de Usuario que publique,
suba, transmita, envíe por correo electrónico o haga disponible a través o en
conexión con los Productos de GolTv. El usuario entiende que MEGADATOS y GolTv
no tiene control sobre el Contenido de Usuarios publicado por los usuarios a
través de los Productos de GolTv y, como tal, entiende que puede estar expuesto
a contenido ofensivo, indecente, inexacto u objetable de cualquier otra forma.
MEGADATOS y GolTv no asume ninguna responsabilidad por este tipo de contenido. <o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">MEGADATOS no asume ninguna responsabilidad por el control
de los Productos de GolTv de Contenido o conducta inapropiada; así como,
ninguna obligación de modificar o eliminar ningún Contenido inapropiado, ni
responsabilidad por la conducta de cualquier usuario o visitante.<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">El usuario se compromete a no utilizar los Productos
de GolTv para:<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Publicar, cargar, o de cualquier otra forma transmitir
o crear un enlace a contenido que sea: ilegal; amenazante; nocivo; abusivo;
pornográfico o que incluya desnudos; ofensivo; de acoso, excesivamente
violento, tortuoso; difamatorio, invasivo de la privacidad, publicidad,
derechos de autor, marcas, patentes, secreto comercial, contrato u otros
derechos de terceros, falso o engañoso, obsceno, vulgar, difamatorio, que
fomente el odio o discriminatorio;<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Violar derechos de terceros, incluidos los de
patentes, marcas comerciales, secretos comerciales, derechos de autor,
privacidad, publicidad u otros derechos de propiedad;<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Acosar o causar daño a otra persona;<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Explotar o poner en peligro a un menor de edad;<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Hacerse pasar o intentar hacerse pasar por cualquier
otra persona o entidad;<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Introducir o participar en actividades que impliquen
la utilización de virus, robots, gusanos o cualquier otro código informático,
archivos o programas que interrumpan, destruyan o limiten la funcionalidad de
cualquier software o hardware o equipo de telecomunicaciones, o permita de
cualquier otra manera la utilización no autorizada o el acceso a un ordenador o
una red informática;<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Interferir, dañar, deshabilitar, perturbar,
perjudicar, crear una carga excesiva, o permitir el acceso no autorizado a los
Productos de GolTv, incluidos a los servidores, redes o cuentas de GolTv o
MEGADATOS;<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Cubrir, quitar, desactivar, bloquear, u ocultar
anuncios publicitarios u otras partes de los Productos de GolTv;<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Eliminar o revisar cualquier información proporcionada
por o perteneciente a cualquier otro usuario de los Productos de GolTv;<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Utilizar tecnología o cualquier otro sistema
automatizado, como scripts o robots para obtener nombres de usuario,
contraseñas, direcciones de correo electrónico u otros datos de los Productos
de GolTv, o para evadir o modificar cualquier tecnología de seguridad o
software que sea parte de los Productos de GolTv;<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Enviar o provocar el envío (en forma directa o
indirecta) de mensajes masivos no solicitados u otras comunicaciones masivas no
solicitadas de cualquier tipo a través de los Productos de GolTv. <o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Solicitar, recoger o requerir cualquier información
personal con fines comerciales o ilegales;<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Enviar, cargar o transmitir de cualquier forma una
imagen o vídeo de otra persona sin el consentimiento de esa persona;<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Participar en actividad comercial (incluyendo, entre
otros, publicidad o solicitud de, negocios, ventas, concursos, sorteos; crear,
recrear, distribuir o anunciar un índice con parte significativa del Contenido
de GolTv; o desarrollar un negocio usando el Contenido de GolTv) sin el previo
consentimiento por escrito de GolTv, usando tecnología u otros medios de
acceso, índice, marco o enlace a los Productos de GolTv (incluido el Contenido)
que no esté autorizado por GolTv (incluidos entre otros, la eliminación de la
desactivación o eludir cualquier protección de contenido o acceso a los
mecanismos de control destinados a evitar la descarga no autorizada, la captura
de stream, vinculación, encuadre, reproducción, acceso o distribución del
Contenido de GolTv);<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Acceder a los Productos de GolTv (incluido el
Contenido) a través de formas automatizadas, como “robots”, “arañas” o
“lectores fuera de línea” (que no sea por medio de búsquedas realizadas
individualmente en motores de búsqueda de acceso público con el único propósito
y solamente en la medida necesaria para la creación de índices de búsqueda
disponibles al público, pero no cachés o archivos, de los Productos de GolTv y
excluyendo aquellos motores de búsqueda o índices que hospedan, promueven o se
enlazan en forma primara a contenido violatorio o no autorizado.<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Utilizar los Productos de GolTv para publicitar o
promocionar servicios de la competencia;<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Utilizar los Productos de GolTv de una forma
incompatible con cualquier Ley Aplicable;<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Intentar, facilitar o estimular a otras personas a
realizar cualquiera de las acciones anteriores.<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">MEGADATOS y GolTv se reservan el derecho, pero no
asume ninguna obligación o responsabilidad de eliminar el Contenido de Usuario
que viole los presentes Términos y Condiciones, según lo determine GolTv a su
total discreción y sin necesidad de notificarle. El usuario reconoce que GolTv
se reserva el derecho a investigar y tomar las medidas legales pertinentes
contra cualquier persona que, a total discreción de MEGADATOS y GolTv, viole
los presentes Términos y Condiciones como por ejemplo desactivar su cuenta de
usuario y/o informar sobre el Contenido del Usuario, conducta o actividad a las
autoridades policiales y judiciales pertinentes.<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">El usuario acepta y acuerda que MEGADATOS puede
acceder, conservar o revelar información que el usuario proporcione a o a
través de los Productos de GolTv o que hayamos recopilado del usuario, incluido
el Contenido de Usuario, cuando MEGADATOS y GolTv crean de buena fe que dicho
acceso, conservación o revelación es necesaria para: (i) proteger o defender
los derechos legales o los bienes de MEGADATOS, GolTv y sus compañías matrices,
subsidiarias o afiliadas ("Compañías Afiliadas"), o sus empleados,
agentes y contratistas (incluso el cumplimiento de sus contratos); (ii)
proteger la seguridad de los Usuarios de los Productos de GolTv o miembros del
público, incluso en circunstancias urgentes, (iii) proteger contra el fraude o
con fines de gestión de riesgo, (iv) cumplir con la Ley Orgánica de Protección
de Datos Personales, o cualquier proceso legal; o (v) responder a solicitudes
de autoridades públicas y gubernamentales, respecto del tratamiento que se
garantiza se realiza por parte de MEGADATOS.. <o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><b><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">11- Derechos de autor y otros derechos de propiedad
intelectual<o:p></o:p></span></b></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">El usuario no puede cargar, integrar, publicar, enviar
por correo electrónico, transmitir o poner a disposición de cualquier otra
forma material que infrinja los derechos de autor, patentes, marcas, secretos
comerciales u otros derechos de propiedad de cualquier persona o entidad.
MEGADATOS y GolTv adoptan la política de cancelar el acceso a infractores
reincidentes a los Productos de GolTv cuando lo considere apropiado.<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><b><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">12- Renuncias<o:p></o:p></span></b></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">Los productos de GolTv se proveen “como son” y “como
están disponibles” y MEGADATOS no garantiza ni promete ningún resultado
específico del uso o la disponibilidad continua de los Productos de GolTv.
MEGADATOS no garantiza que el uso de los Productos de GolTv será
ininterrumpido, oportuno, seguro o libre de errores, que los defectos serán
corregidos, que los Productos de GolTv o los servidores donde estén disponibles
estarán libres de virus u otro componente dañino, o que la información obtenida
por el usuario, en, a través o en conexión con los Productos de GolTv o los
Servicios de Terceros (incluidos, entre otros, a través de contenido de usuario
o anuncios de terceros) será exacta, confiable, oportuna o completa. Bajo
ninguna circunstancia, MEGADATOS será responsable por ninguna pérdida o daño
(incluidos, entre otros pérdida de datos, daño material, lesión personal o
muerte) como resultado del uso de los Productos de GolTv, problemas o fallas
técnicas en relación con el uso de los Productos de GolTv, asistencia a un
evento de GolTv, cualquier material descargado u obtenido en conexión con los
Productos de GolTv, cualquier contenido de usuario, anuncio de terceros o
Servicios de terceros transmitidos en, a través o en conexión con los Productos
de GolTv, o conducta de un usuario de los Productos de GolTv, sea online u
offline. El uso que el usuario haga del contenido de usuario, anuncio de
tercero o Servicio de Tercero o los bienes y servicios proporcionados por
cualquier terceros son de su entera responsabilidad y a su propio riesgo.<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify"><span lang="ES-MX" style="font-size:12.0pt;line-height:107%;font-family:Arial,sans-serif;
mso-ansi-language:ES-MX">El usuario reconoce y acepta que el uso de los
Productos de GolTv y cualquier información transmitida o recibida en relación
con ella, puede no ser segura, puede ser interceptada por partes no
autorizadas. El usuario asume la responsabilidad por el costo total de
mantenimiento, reparación o corrección de su sistema de computadora u otra
propiedad, o recuperación o reconstrucción de los datos perdidos por el uso de
los Productos de GolTv.<o:p></o:p></span></p><br></p>
');

UPDATE db_comercial.admi_producto
SET TERMINO_CONDICION=EMPTY_CLOB()
where ID_PRODUCTO=1407 AND EMPRESA_COD=18 AND CODIGO_PRODUCTO='GTV1';

UPDATE db_comercial.admi_producto
SET TERMINO_CONDICION= bada
where ID_PRODUCTO=1407 AND EMPRESA_COD=18 AND CODIGO_PRODUCTO='GTV1';

COMMIT;
end;