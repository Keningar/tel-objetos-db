CREATE OR REPLACE PACKAGE DB_GENERAL.GNKG_AS_XLSX IS

 /**
  * PAQUETE DE TERCEROS
  * PAQUETE CON PROCEDIMIENTOS Y FUNCIONES PARA GENERAR UN ARCHIVO XLSX
  *
  * Author  : Anton Scheffer
  * Date    : 19-02-2011
  * Website : http://technology.amis.nl/blog / https://technology.amis.nl/tag/as_xlsx/
  * See also: http://technology.amis.nl/blog/?p=10995
  *
  * Permission is hereby granted, free of charge, to any person obtaining a copy
  * of this software and associated documentation files (the "Software"), to deal
  * in the Software without restriction, including without limitation the rights
  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  * copies of the Software, and to permit persons to whom the Software is
  * furnished to do so, subject to the following conditions:
  *
  * The above copyright notice and this permission notice shall be included in
  * all copies or substantial portions of the Software.
  *
  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  * THE SOFTWARE.
  **/

  TYPE Tp_Alignment IS RECORD(
    Vertical   VARCHAR2(11),
    Horizontal VARCHAR2(16),
    Wraptext   BOOLEAN);

  PROCEDURE CLEAR_WORKBOOK;

  PROCEDURE NEW_SHEET(P_Sheetname VARCHAR2 := NULL,
                      P_Tabcolor  VARCHAR2 := NULL); -- this is a hex ALPHA Red Green Blue value

  FUNCTION ORAFMT2EXCEL(P_Format VARCHAR2 := NULL)
    RETURN VARCHAR2;

  FUNCTION GET_NUMFMT(P_Format VARCHAR2 := NULL)
    RETURN PLS_INTEGER;

  FUNCTION GET_FONT(P_Name      VARCHAR2,
                    P_Family    PLS_INTEGER := 2,
                    P_Fontsize  NUMBER      := 11,
                    P_Theme     PLS_INTEGER := 1,
                    P_Underline BOOLEAN     := FALSE,
                    P_Italic    BOOLEAN     := FALSE,
                    P_Bold      BOOLEAN     := FALSE,
                    P_Rgb       VARCHAR2    := NULL) -- this is a hex ALPHA Red Green Blue value
    RETURN PLS_INTEGER;

  FUNCTION GET_FILL(P_Patterntype VARCHAR2,
                    P_Fgrgb       VARCHAR2 := NULL) -- this is a hex ALPHA Red Green Blue value
    RETURN PLS_INTEGER;

  --none,thin,medium,dashed,dotted,thick,double,hair,mediumDashed,dashDot,mediumDashDot,
  --dashDotDot,mediumDashDotDot,slantDashDot
  FUNCTION GET_BORDER(P_Top    VARCHAR2 := 'thin',
                      P_Bottom VARCHAR2 := 'thin',
                      P_Left   VARCHAR2 := 'thin',
                      P_Right  VARCHAR2 := 'thin')
    RETURN PLS_INTEGER;

  --horizontal: center,centerContinuous,distributed,fill,general,justify,left,right
  --vertical: bottom,center,distributed,justify,top
  FUNCTION GET_ALIGNMENT(P_Vertical   VARCHAR2 := NULL,
                         P_Horizontal VARCHAR2 := NULL,
                         P_Wraptext   BOOLEAN  := NULL)
    RETURN Tp_Alignment;

  PROCEDURE CELL(P_Col       PLS_INTEGER,
                 P_Row       PLS_INTEGER,
                 P_Value     NUMBER,
                 P_Numfmtid  PLS_INTEGER  := NULL,
                 P_Fontid    PLS_INTEGER  := NULL,
                 P_Fillid    PLS_INTEGER  := NULL,
                 P_Borderid  PLS_INTEGER  := NULL,
                 P_Alignment Tp_Alignment := NULL,
                 P_Sheet     PLS_INTEGER  := NULL);

  PROCEDURE CELL(P_Col       PLS_INTEGER,
                 P_Row       PLS_INTEGER,
                 P_Value     VARCHAR2,
                 P_Numfmtid  PLS_INTEGER  := NULL,
                 P_Fontid    PLS_INTEGER  := NULL,
                 P_Fillid    PLS_INTEGER  := NULL,
                 P_Borderid  PLS_INTEGER  := NULL,
                 P_Alignment Tp_Alignment := NULL,
                 P_Sheet     PLS_INTEGER  := NULL);

  PROCEDURE CELL(P_Col       PLS_INTEGER,
                 P_Row       PLS_INTEGER,
                 P_Value     DATE,
                 P_Numfmtid  PLS_INTEGER  := NULL,
                 P_Fontid    PLS_INTEGER  := NULL,
                 P_Fillid    PLS_INTEGER  := NULL,
                 P_Borderid  PLS_INTEGER  := NULL,
                 P_Alignment Tp_Alignment := NULL,
                 P_Sheet     PLS_INTEGER  := NULL);

  PROCEDURE HYPERLINK(P_Col   PLS_INTEGER,
                      P_Row   PLS_INTEGER,
                      P_Url   VARCHAR2,
                      P_Value VARCHAR2 := NULL,
                      P_Sheet PLS_INTEGER := NULL);

  PROCEDURE COMMENT(P_Col    PLS_INTEGER,
                    P_Row    PLS_INTEGER,
                    P_Text   VARCHAR2,
                    P_Author VARCHAR2    := NULL,
                    P_Width  PLS_INTEGER := 150,  -- pixels
                    P_Height PLS_INTEGER := 100,  -- pixels
                    P_Sheet  PLS_INTEGER := NULL);

  PROCEDURE MERGECELLS(P_Tl_Col PLS_INTEGER, -- top left
                       P_Tl_Row PLS_INTEGER,
                       P_Br_Col PLS_INTEGER, -- bottom right
                       P_Br_Row PLS_INTEGER,
                       P_Sheet  PLS_INTEGER := NULL);

  PROCEDURE LIST_VALIDATION(P_Sqref_Col   PLS_INTEGER,
                            P_Sqref_Row   PLS_INTEGER,
                            P_Tl_Col      PLS_INTEGER, -- top left
                            P_Tl_Row      PLS_INTEGER,
                            P_Br_Col      PLS_INTEGER, -- bottom right
                            P_Br_Row      PLS_INTEGER,
                            P_Style       VARCHAR2    := 'stop', -- stop, warning, information
                            P_Title       VARCHAR2    := NULL,
                            P_Prompt      VARCHAR     := NULL,
                            P_Show_Error  BOOLEAN     := FALSE,
                            P_Error_Title VARCHAR2    := NULL,
                            P_Error_Txt   VARCHAR2    := NULL,
                            P_Sheet       PLS_INTEGER := NULL);
  
  PROCEDURE LIST_VALIDATION(P_Sqref_Col    PLS_INTEGER,
                            P_Sqref_Row    PLS_INTEGER,
                            P_Defined_Name VARCHAR2,
                            P_Style        VARCHAR2    := 'stop', -- stop, warning, information
                            P_Title        VARCHAR2    := NULL,
                            P_Prompt       VARCHAR     := NULL,
                            P_Show_Error   BOOLEAN     := FALSE,
                            P_Error_Title  VARCHAR2    := NULL,
                            P_Error_Txt    VARCHAR2    := NULL,
                            P_Sheet        PLS_INTEGER := NULL);

  PROCEDURE DEFINED_NAME(P_Tl_Col     PLS_INTEGER, -- top left
                         P_Tl_Row     PLS_INTEGER,
                         P_Br_Col     PLS_INTEGER, -- bottom right
                         P_Br_Row     PLS_INTEGER,
                         P_Name       VARCHAR2,
                         P_Sheet      PLS_INTEGER := NULL,
                         P_Localsheet PLS_INTEGER := NULL);

  PROCEDURE SET_COLUMN_WIDTH(P_Col   PLS_INTEGER,
                             P_Width NUMBER,
                             P_Sheet PLS_INTEGER := NULL);

  PROCEDURE SET_COLUMN(P_Col       PLS_INTEGER,
                       P_Numfmtid  PLS_INTEGER  := NULL,
                       P_Fontid    PLS_INTEGER  := NULL,
                       P_Fillid    PLS_INTEGER  := NULL,
                       P_Borderid  PLS_INTEGER  := NULL,
                       P_Alignment Tp_Alignment := NULL,
                       P_Sheet     PLS_INTEGER  := NULL);

  PROCEDURE SET_ROW(P_Row       PLS_INTEGER,
                    P_Numfmtid  PLS_INTEGER  := NULL,
                    P_Fontid    PLS_INTEGER  := NULL,
                    P_Fillid    PLS_INTEGER  := NULL,
                    P_Borderid  PLS_INTEGER  := NULL,
                    P_Alignment Tp_Alignment := NULL,
                    P_Sheet     PLS_INTEGER  := NULL,
                    P_Height    NUMBER       := NULL);

  PROCEDURE FREEZE_ROWS(P_Nr_Rows PLS_INTEGER := 1,
                        P_Sheet   PLS_INTEGER := NULL);

  PROCEDURE FREEZE_COLS(P_Nr_Cols PLS_INTEGER := 1,
                        P_Sheet   PLS_INTEGER := NULL);

  PROCEDURE FREEZE_PANE(P_Col   PLS_INTEGER,
                        P_Row   PLS_INTEGER,
                        P_Sheet PLS_INTEGER := NULL);

  PROCEDURE SET_AUTOFILTER(P_Column_Start PLS_INTEGER := NULL,
                           P_Column_End   PLS_INTEGER := NULL,
                           P_Row_Start    PLS_INTEGER := NULL,
                           P_Row_End      PLS_INTEGER := NULL,
                           P_Sheet        PLS_INTEGER := NULL);

  PROCEDURE SET_TABCOLOR(P_Tabcolor VARCHAR2, -- this is a hex ALPHA Red Green Blue value
                         P_Sheet    PLS_INTEGER := NULL);

  FUNCTION FINISH
    RETURN BLOB;

  PROCEDURE SAVE(P_Directory VARCHAR2,
                 P_Filename  VARCHAR2);

  PROCEDURE QUERY2SHEET(P_Sql            VARCHAR2,
                        P_Column_Headers BOOLEAN     := TRUE,
                        P_Directory      VARCHAR2    := NULL,
                        P_Filename       VARCHAR2    := NULL,
                        P_Sheet          PLS_INTEGER := NULL,
                        P_Usexf          BOOLEAN     := FALSE);

  PROCEDURE SETUSEXF(P_Val BOOLEAN := TRUE);

END GNKG_AS_XLSX;
/

CREATE OR REPLACE PACKAGE BODY DB_GENERAL.GNKG_AS_XLSX IS
----
----
  C_Local_File_Header        CONSTANT RAW(4) := Hextoraw( '504B0304' ); -- Local file header signature
  C_End_Of_Central_Directory CONSTANT RAW(4) := Hextoraw( '504B0506' ); -- End of central directory signature
----
----
  TYPE Tp_Xf_Fmt IS RECORD
    ( Numfmtid PLS_INTEGER
    , Fontid PLS_INTEGER
    , Fillid PLS_INTEGER
    , Borderid PLS_INTEGER
    , Alignment Tp_Alignment
    , Height NUMBER
    );
  TYPE Tp_Col_Fmts IS TABLE OF Tp_Xf_Fmt INDEX BY PLS_INTEGER;
  TYPE Tp_Row_Fmts IS TABLE OF Tp_Xf_Fmt INDEX BY PLS_INTEGER;
  TYPE Tp_Widths IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
  TYPE Tp_Cell IS RECORD
    ( Value NUMBER
    , Style VARCHAR2(50)
    );
  TYPE Tp_Cells IS TABLE OF Tp_Cell INDEX BY PLS_INTEGER;
  TYPE Tp_Rows IS TABLE OF Tp_Cells INDEX BY PLS_INTEGER;
  TYPE Tp_Autofilter IS RECORD
    ( Column_Start PLS_INTEGER
    , Column_End PLS_INTEGER
    , Row_Start PLS_INTEGER
    , Row_End PLS_INTEGER
    );
  TYPE Tp_Autofilters IS TABLE OF Tp_Autofilter INDEX BY PLS_INTEGER;
  TYPE Tp_Hyperlink IS RECORD
    ( Cell VARCHAR2(10)
    , Url  VARCHAR2(1000)
    );
  TYPE Tp_Hyperlinks IS TABLE OF Tp_Hyperlink INDEX BY PLS_INTEGER;
  SUBTYPE Tp_Author IS VARCHAR2(32767 CHAR);
  TYPE Tp_Authors IS TABLE OF PLS_INTEGER INDEX BY Tp_Author;
  Authors Tp_Authors;
  TYPE Tp_Comment IS RECORD
    ( Text VARCHAR2(32767 CHAR)
    , Author Tp_Author
    , Row PLS_INTEGER
    , Column PLS_INTEGER
    , Width PLS_INTEGER
    , Height PLS_INTEGER
    );
  TYPE Tp_Comments IS TABLE OF Tp_Comment INDEX BY PLS_INTEGER;
  TYPE Tp_Mergecells IS TABLE OF VARCHAR2(21) INDEX BY PLS_INTEGER;
  TYPE Tp_Validation IS RECORD
    ( Type VARCHAR2(10)
    , Errorstyle VARCHAR2(32)
    , Showinputmessage BOOLEAN
    , Prompt VARCHAR2(32767 CHAR)
    , Title VARCHAR2(32767 CHAR)
    , Error_Title VARCHAR2(32767 CHAR)
    , Error_Txt VARCHAR2(32767 CHAR)
    , Showerrormessage BOOLEAN
    , Formula1 VARCHAR2(32767 CHAR)
    , Formula2 VARCHAR2(32767 CHAR)
    , Allowblank BOOLEAN
    , Sqref VARCHAR2(32767 CHAR)
    );
  TYPE Tp_Validations IS TABLE OF Tp_Validation INDEX BY PLS_INTEGER;
  TYPE Tp_Sheet IS RECORD
    ( Rows Tp_Rows
    , Widths Tp_Widths
    , Name VARCHAR2(100)
    , Freeze_Rows PLS_INTEGER
    , Freeze_Cols PLS_INTEGER
    , Autofilters Tp_Autofilters
    , Hyperlinks Tp_Hyperlinks
    , Col_Fmts Tp_Col_Fmts
    , Row_Fmts Tp_Row_Fmts
    , Comments Tp_Comments
    , Mergecells Tp_Mergecells
    , Validations Tp_Validations
    , Tabcolor VARCHAR2(8)
    );
  TYPE Tp_Sheets IS TABLE OF Tp_Sheet INDEX BY PLS_INTEGER;
  TYPE Tp_Numfmt IS RECORD
    ( Numfmtid PLS_INTEGER
    , Formatcode VARCHAR2(100)
    );
  TYPE Tp_Numfmts IS TABLE OF Tp_Numfmt INDEX BY PLS_INTEGER;
  TYPE Tp_Fill IS RECORD
    ( Patterntype VARCHAR2(30)
    , Fgrgb VARCHAR2(8)
    );
  TYPE Tp_Fills IS TABLE OF Tp_Fill INDEX BY PLS_INTEGER;
  TYPE Tp_Cellxfs IS TABLE OF Tp_Xf_Fmt INDEX BY PLS_INTEGER;
  TYPE Tp_Font IS RECORD
    ( Name VARCHAR2(100)
    , Family PLS_INTEGER
    , Fontsize NUMBER
    , Theme PLS_INTEGER
    , Rgb VARCHAR2(8)
    , Underline BOOLEAN
    , Italic BOOLEAN
    , Bold BOOLEAN
    );
  TYPE Tp_Fonts IS TABLE OF Tp_Font INDEX BY PLS_INTEGER;
  TYPE Tp_Border IS RECORD
    ( Top VARCHAR2(17)
    , Bottom VARCHAR2(17)
    , Left VARCHAR2(17)
    , Right VARCHAR2(17)
    );
  TYPE Tp_Borders IS TABLE OF Tp_Border INDEX BY PLS_INTEGER;
  TYPE Tp_Numfmtindexes IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;
  TYPE Tp_Strings IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(32767 CHAR);
  TYPE Tp_Str_Ind IS TABLE OF VARCHAR2(32767 CHAR) INDEX BY PLS_INTEGER;
  TYPE Tp_Defined_Name IS RECORD
    ( Name VARCHAR2(32767 CHAR)
    , Ref VARCHAR2(32767 CHAR)
    , Sheet PLS_INTEGER
    );
  TYPE Tp_Defined_Names IS TABLE OF Tp_Defined_Name INDEX BY PLS_INTEGER;
  TYPE Tp_Book IS RECORD
    ( Sheets Tp_Sheets
    , Strings Tp_Strings
    , Str_Ind Tp_Str_Ind
    , Str_Cnt PLS_INTEGER := 0
    , Fonts Tp_Fonts
    , Fills Tp_Fills
    , Borders Tp_Borders
    , Numfmts Tp_Numfmts
    , Cellxfs Tp_Cellxfs
    , Numfmtindexes Tp_Numfmtindexes
    , Defined_Names Tp_Defined_Names
    );
----
----
  Workbook              Tp_Book;
  G_Usexf               BOOLEAN := True;
  G_Addtxt2utf8blob_Tmp VARCHAR2(32767);
----
----
  PROCEDURE Addtxt2utf8blob_Init( P_Blob IN OUT NOCOPY BLOB )
  IS
  BEGIN
    G_Addtxt2utf8blob_Tmp := NULL;
    Dbms_Lob.Createtemporary( P_Blob, True );
  END;
----
----
  PROCEDURE Addtxt2utf8blob_Finish( P_Blob IN OUT NOCOPY BLOB )
  IS
    T_Raw RAW(32767);
  BEGIN
    T_Raw := Utl_I18n.String_To_Raw( G_Addtxt2utf8blob_Tmp, 'AL32UTF8' );
    Dbms_Lob.Writeappend( P_Blob, Utl_Raw.Length( T_Raw ), T_Raw );
  EXCEPTION
    WHEN Value_Error
    THEN
      T_Raw := Utl_I18n.String_To_Raw( Substr( G_Addtxt2utf8blob_Tmp, 1, 16381 ), 'AL32UTF8' );
      Dbms_Lob.Writeappend( P_Blob, Utl_Raw.Length( T_Raw ), T_Raw );
      T_Raw := Utl_I18n.String_To_Raw( Substr( G_Addtxt2utf8blob_Tmp, 16382 ), 'AL32UTF8' );
      Dbms_Lob.Writeappend( P_Blob, Utl_Raw.Length( T_Raw ), T_Raw );
  END;
----
----
  PROCEDURE Addtxt2utf8blob( P_Txt VARCHAR2, P_Blob IN OUT NOCOPY BLOB )
  IS
  BEGIN
    G_Addtxt2utf8blob_Tmp := G_Addtxt2utf8blob_Tmp || P_Txt;
  EXCEPTION
    WHEN Value_Error
    THEN
      Addtxt2utf8blob_Finish( P_Blob );
      G_Addtxt2utf8blob_Tmp := P_Txt;
  END;
----
----
  PROCEDURE Blob2file
    ( P_Blob BLOB
    , P_Directory VARCHAR2 := 'MY_DIR'
    , P_Filename VARCHAR2 := 'my.xlsx'
    )
  IS
    T_Fh Utl_File.File_Type;
    T_Len PLS_INTEGER := 32767;
  BEGIN
    T_Fh := Utl_File.Fopen( P_Directory
                          , P_Filename
                          , 'wb'
                          );
    FOR I IN 0 .. Trunc( ( Dbms_Lob.Getlength( P_Blob ) - 1 ) / T_Len )
    LOOP
      Utl_File.Put_Raw( T_Fh
                      , Dbms_Lob.Substr( P_Blob
                                       , T_Len
                                       , I * T_Len + 1
                                       )
                      );
    END LOOP;
    Utl_File.Fclose( T_Fh );
  END;
----
----
  FUNCTION Raw2num( P_Raw RAW, P_Len INTEGER, P_Pos INTEGER )
  RETURN NUMBER
  IS
  BEGIN
    RETURN Utl_Raw.Cast_To_Binary_Integer( Utl_Raw.Substr( P_Raw, P_Pos, P_Len ), Utl_Raw.Little_Endian );
  END;
----
----
  FUNCTION Little_Endian( P_Big NUMBER, P_Bytes PLS_INTEGER := 4 )
  RETURN RAW
  IS
  BEGIN
    RETURN Utl_Raw.Substr( Utl_Raw.Cast_From_Binary_Integer( P_Big, Utl_Raw.Little_Endian ), 1, P_Bytes );
  END;
----
----
  FUNCTION Blob2num( P_Blob BLOB, P_Len INTEGER, P_Pos INTEGER )
  RETURN NUMBER
  IS
  BEGIN
    RETURN Utl_Raw.Cast_To_Binary_Integer( Dbms_Lob.Substr( P_Blob, P_Len, P_Pos ), Utl_Raw.Little_Endian );
  END;
----
----
  PROCEDURE Add1file
    ( P_Zipped_Blob IN OUT BLOB
    , P_Name VARCHAR2
    , P_Content BLOB
    )
  IS
    T_Now DATE;
    T_Blob BLOB;
    T_Len INTEGER;
    T_Clen INTEGER;
    T_Crc32 RAW(4) := Hextoraw( '00000000' );
    T_Compressed BOOLEAN := False;
    T_Name RAW(32767);
  BEGIN
    T_Now := Sysdate;
    T_Len := Nvl( Dbms_Lob.Getlength( P_Content ), 0 );
    IF T_Len > 0
    THEN
      T_Blob := Utl_Compress.Lz_Compress( P_Content );
      T_Clen := Dbms_Lob.Getlength( T_Blob ) - 18;
      T_Compressed := T_Clen < T_Len;
      T_Crc32 := Dbms_Lob.Substr( T_Blob, 4, T_Clen + 11 );
    END IF;
    IF NOT T_Compressed
    THEN
      T_Clen := T_Len;
      T_Blob := P_Content;
    END IF;
    IF P_Zipped_Blob IS NULL
    THEN
      Dbms_Lob.Createtemporary( P_Zipped_Blob, True );
    END IF;
    T_Name := Utl_I18n.String_To_Raw( P_Name, 'AL32UTF8' );
    Dbms_Lob.Append( P_Zipped_Blob
                   , Utl_Raw.Concat( C_Local_File_Header -- Local file header signature
                                   , Hextoraw( '1400' )  -- version 2.0
                                   , CASE WHEN T_Name = Utl_I18n.String_To_Raw( P_Name, 'US8PC437' )
                                       THEN Hextoraw( '0000' ) -- no General purpose bits
                                       ELSE Hextoraw( '0008' ) -- set Language encoding flag (EFS)
                                     END
                                   , CASE WHEN T_Compressed
                                        THEN Hextoraw( '0800' ) -- deflate
                                        ELSE Hextoraw( '0000' ) -- stored
                                     END
                                   , Little_Endian( To_Number( To_Char( T_Now, 'ss' ) ) / 2
                                                  + To_Number( To_Char( T_Now, 'mi' ) ) * 32
                                                  + To_Number( To_Char( T_Now, 'hh24' ) ) * 2048
                                                  , 2
                                                  ) -- File last modification time
                                   , Little_Endian( To_Number( To_Char( T_Now, 'dd' ) )
                                                  + To_Number( To_Char( T_Now, 'mm' ) ) * 32
                                                  + ( To_Number( To_Char( T_Now, 'yyyy' ) ) - 1980 ) * 512
                                                  , 2
                                                  ) -- File last modification date
                                   , T_Crc32 -- CRC-32
                                   , Little_Endian( T_Clen )                      -- compressed size
                                   , Little_Endian( T_Len )                       -- uncompressed size
                                   , Little_Endian( Utl_Raw.Length( T_Name ), 2 ) -- File name length
                                   , Hextoraw( '0000' )                           -- Extra field length
                                   , T_Name                                       -- File name
                                   )
                   );
    IF T_Compressed
    THEN
      Dbms_Lob.Copy( P_Zipped_Blob, T_Blob, T_Clen, Dbms_Lob.Getlength( P_Zipped_Blob ) + 1, 11 ); -- compressed content
    ELSIF T_Clen > 0
    THEN
      Dbms_Lob.Copy( P_Zipped_Blob, T_Blob, T_Clen, Dbms_Lob.Getlength( P_Zipped_Blob ) + 1, 1 ); --  content
    END IF;
    IF Dbms_Lob.Istemporary( T_Blob ) = 1
    THEN
      Dbms_Lob.Freetemporary( T_Blob );
    END IF;
  END;
----
----
  PROCEDURE Finish_Zip( P_Zipped_Blob IN OUT BLOB )
  IS
    T_Cnt PLS_INTEGER := 0;
    T_Offs INTEGER;
    T_Offs_Dir_Header INTEGER;
    T_Offs_End_Header INTEGER;
    T_Comment RAW(32767) := Utl_Raw.Cast_To_Raw( 'Implementation by Anton Scheffer, GNKG_AS_XLSX18' );
  BEGIN
    T_Offs_Dir_Header := Dbms_Lob.Getlength( P_Zipped_Blob );
    T_Offs := 1;
    WHILE Dbms_Lob.Substr( P_Zipped_Blob, Utl_Raw.Length( C_Local_File_Header ), T_Offs ) = C_Local_File_Header
    LOOP
      T_Cnt := T_Cnt + 1;
      Dbms_Lob.Append( P_Zipped_Blob
                     , Utl_Raw.Concat( Hextoraw( '504B0102' )      -- Central directory file header signature
                                     , Hextoraw( '1400' )          -- version 2.0
                                     , Dbms_Lob.Substr( P_Zipped_Blob, 26, T_Offs + 4 )
                                     , Hextoraw( '0000' )          -- File comment length
                                     , Hextoraw( '0000' )          -- Disk number where file starts
                                     , Hextoraw( '0000' )          -- Internal file attributes =>
                                                                   --     0000 binary file
                                                                   --     0100 (ascii)text file
                                     , CASE
                                         WHEN Dbms_Lob.Substr( P_Zipped_Blob
                                                             , 1
                                                             , T_Offs + 30 + Blob2num( P_Zipped_Blob, 2, T_Offs + 26 ) - 1
                                                             ) IN ( Hextoraw( '2F' ) -- /
                                                                  , Hextoraw( '5C' ) -- \
                                                                  )
                                         THEN Hextoraw( '10000000' ) -- a directory/folder
                                         ELSE Hextoraw( '2000B681' ) -- a file
                                       END                         -- External file attributes
                                     , Little_Endian( T_Offs - 1 ) -- Relative offset of local file header
                                     , Dbms_Lob.Substr( P_Zipped_Blob
                                                      , Blob2num( P_Zipped_Blob, 2, T_Offs + 26 )
                                                      , T_Offs + 30
                                                      )            -- File name
                                     )
                     );
      T_Offs := T_Offs + 30 + Blob2num( P_Zipped_Blob, 4, T_Offs + 18 )  -- compressed size
                            + Blob2num( P_Zipped_Blob, 2, T_Offs + 26 )  -- File name length
                            + Blob2num( P_Zipped_Blob, 2, T_Offs + 28 ); -- Extra field length
    END LOOP;
    T_Offs_End_Header := Dbms_Lob.Getlength( P_Zipped_Blob );
    Dbms_Lob.Append( P_Zipped_Blob
                   , Utl_Raw.Concat( C_End_Of_Central_Directory                                -- End of central directory signature
                                   , Hextoraw( '0000' )                                        -- Number of this disk
                                   , Hextoraw( '0000' )                                        -- Disk where central directory starts
                                   , Little_Endian( T_Cnt, 2 )                                 -- Number of central directory records on this disk
                                   , Little_Endian( T_Cnt, 2 )                                 -- Total number of central directory records
                                   , Little_Endian( T_Offs_End_Header - T_Offs_Dir_Header )    -- Size of central directory
                                   , Little_Endian( T_Offs_Dir_Header )                        -- Offset of start of central directory, relative to start of archive
                                   , Little_Endian( Nvl( Utl_Raw.Length( T_Comment ), 0 ), 2 ) -- ZIP file comment length
                                   , T_Comment
                                   )
                   );
  END;
----
----
  FUNCTION Alfan_Col( P_Col PLS_INTEGER )
  RETURN VARCHAR2
  IS
  BEGIN
    RETURN
      CASE
        WHEN P_Col > 702 THEN Chr( 64 + Trunc( ( P_Col - 27 ) / 676 ) ) ||
                              Chr( 65 + MOD( Trunc( ( P_Col - 1 ) / 26 ) - 1, 26 ) ) ||
                              Chr( 65 + MOD( P_Col - 1, 26 ) )
        WHEN P_Col > 26  THEN Chr( 64 + Trunc( ( P_Col - 1 ) / 26 ) ) || Chr( 65 + MOD( P_Col - 1, 26 ) )
        ELSE Chr( 64 + P_Col )
      END;
  END;
----
----
  FUNCTION Col_Alfan( P_Col VARCHAR2 )
  RETURN PLS_INTEGER
  IS
  BEGIN
    RETURN Ascii( Substr( P_Col, -1 ) ) - 64
         + Nvl( ( Ascii( Substr( P_Col, -2, 1 ) ) - 64 ) * 26, 0 )
         + Nvl( ( Ascii( Substr( P_Col, -3, 1 ) ) - 64 ) * 676, 0 );
  END;
----
----
  PROCEDURE Clear_Workbook
  IS
    S PLS_INTEGER;
    T_Row_Ind PLS_INTEGER;
  BEGIN
    S := Workbook.Sheets.First;
    WHILE S IS NOT NULL
    LOOP
      T_Row_Ind := Workbook.Sheets( S ).Rows.First();
      WHILE T_Row_Ind IS NOT NULL
      LOOP
        Workbook.Sheets( S ).Rows( T_Row_Ind ).DELETE();
        T_Row_Ind := Workbook.Sheets( S ).Rows.Next( T_Row_Ind );
      END LOOP;
      Workbook.Sheets( S ).Rows.DELETE();
      Workbook.Sheets( S ).Widths.DELETE();
      Workbook.Sheets( S ).Autofilters.DELETE();
      Workbook.Sheets( S ).Hyperlinks.DELETE();
      Workbook.Sheets( S ).Col_Fmts.DELETE();
      Workbook.Sheets( S ).Row_Fmts.DELETE();
      Workbook.Sheets( S ).Comments.DELETE();
      Workbook.Sheets( S ).Mergecells.DELETE();
      Workbook.Sheets( S ).Validations.DELETE();
      S := Workbook.Sheets.Next( S );
    END LOOP;
    Workbook.Strings.DELETE();
    Workbook.Str_Ind.DELETE();
    Workbook.Fonts.DELETE();
    Workbook.Fills.DELETE();
    Workbook.Borders.DELETE();
    Workbook.Numfmts.DELETE();
    Workbook.Cellxfs.DELETE();
    Workbook.Defined_Names.DELETE();
    Workbook := NULL;
  END;
----
----
  PROCEDURE Set_Tabcolor
    ( P_Tabcolor VARCHAR2 -- this is a hex ALPHA Red Green Blue value
    , P_Sheet PLS_INTEGER := NULL
    )
  IS
    T_Sheet PLS_INTEGER := Nvl( P_Sheet, Workbook.Sheets.Count() );
  BEGIN
    Workbook.Sheets( T_Sheet ).Tabcolor := Substr( P_Tabcolor, 1, 8 );
  END;
----
----
  PROCEDURE New_Sheet
    ( P_Sheetname VARCHAR2 := NULL
    , P_Tabcolor VARCHAR2 := NULL -- this is a hex ALPHA Red Green Blue value
    )
  IS
    T_Nr PLS_INTEGER := Workbook.Sheets.Count() + 1;
    T_Ind PLS_INTEGER;
  BEGIN
    Workbook.Sheets( T_Nr ).Name := Nvl( Dbms_Xmlgen.Convert( Translate( P_Sheetname, 'a/\[]*:?', 'a' ) ), 'Sheet' || T_Nr );
    IF Workbook.Strings.Count() = 0
    THEN
     Workbook.Str_Cnt := 0;
    END IF;
    IF Workbook.Fonts.Count() = 0
    THEN
      T_Ind := Get_Font( 'Calibri' );
    END IF;
    IF Workbook.Fills.Count() = 0
    THEN
      T_Ind := Get_Fill( 'none' );
      T_Ind := Get_Fill( 'gray125' );
    END IF;
    IF Workbook.Borders.Count() = 0
    THEN
      T_Ind := Get_Border( '', '', '', '' );
    END IF;
    Set_Tabcolor( P_Tabcolor, T_Nr );
  END;
----
----
  PROCEDURE Set_Col_Width
    ( P_Sheet PLS_INTEGER
    , P_Col PLS_INTEGER
    , P_Format VARCHAR2
    )
  IS
    T_Width NUMBER;
    T_Nr_Chr PLS_INTEGER;
  BEGIN
    IF P_Format IS NULL
    THEN
      Return;
    END IF;
    IF Instr( P_Format, ';' ) > 0
    THEN
      T_Nr_Chr := Length( Translate( Substr( P_Format, 1, Instr( P_Format, ';' ) - 1 ), 'a\"', 'a' ) );
    ELSE
      T_Nr_Chr := Length( Translate( P_Format, 'a\"', 'a' ) );
    END IF;
    T_Width := Trunc( ( T_Nr_Chr * 7 + 5 ) / 7 * 256 ) / 256; -- assume default 11 point Calibri
    IF Workbook.Sheets( P_Sheet ).Widths.EXISTS( P_Col )
    THEN
      Workbook.Sheets( P_Sheet ).Widths( P_Col ) :=
        Greatest( Workbook.Sheets( P_Sheet ).Widths( P_Col )
                , T_Width
                );
    ELSE
      Workbook.Sheets( P_Sheet ).Widths( P_Col ) := Greatest( T_Width, 8.43 );
    END IF;
  END;
----
----
  FUNCTION Orafmt2excel( P_Format VARCHAR2 := NULL )
  RETURN VARCHAR2
  IS
    T_Format VARCHAR2(1000) := Substr( P_Format, 1, 1000 );
  BEGIN
    T_Format := Replace( Replace( T_Format, 'hh24', 'hh' ), 'hh12', 'hh' );
    T_Format := Replace( T_Format, 'mi', 'mm' );
    T_Format := Replace( Replace( Replace( T_Format, 'AM', '~~' ), 'PM', '~~' ), '~~', 'AM/PM' );
    T_Format := Replace( Replace( Replace( T_Format, 'am', '~~' ), 'pm', '~~' ), '~~', 'AM/PM' );
    T_Format := Replace( Replace( T_Format, 'day', 'DAY' ), 'DAY', 'dddd' );
    T_Format := Replace( Replace( T_Format, 'dy', 'DY' ), 'DAY', 'ddd' );
    T_Format := Replace( Replace( T_Format, 'RR', 'RR' ), 'RR', 'YY' );
    T_Format := Replace( Replace( T_Format, 'month', 'MONTH' ), 'MONTH', 'mmmm' );
    T_Format := Replace( Replace( T_Format, 'mon', 'MON' ), 'MON', 'mmm' );
    T_Format := Replace( T_Format, '9', '#' );
    T_Format := Replace( T_Format, 'D', '.' );
    T_Format := Replace( T_Format, 'G', ',' );
    RETURN T_Format;
  END;
----
----
  FUNCTION Get_Numfmt( P_Format VARCHAR2 := NULL )
  RETURN PLS_INTEGER
  IS
    T_Cnt PLS_INTEGER;
    T_Numfmtid PLS_INTEGER;
  BEGIN
    IF P_Format IS NULL
    THEN
      RETURN 0;
    END IF;
    T_Cnt := Workbook.Numfmts.Count();
    FOR I IN 1 .. T_Cnt
    LOOP
      IF Workbook.Numfmts( I ).Formatcode = P_Format
      THEN
        T_Numfmtid := Workbook.Numfmts( I ).Numfmtid;
        EXIT;
      END IF;
    END LOOP;
    IF T_Numfmtid IS NULL
    THEN
      T_Numfmtid := CASE WHEN T_Cnt = 0 THEN 164 ELSE Workbook.Numfmts( T_Cnt ).Numfmtid + 1 END;
      T_Cnt := T_Cnt + 1;
      Workbook.Numfmts( T_Cnt ).Numfmtid := T_Numfmtid;
      Workbook.Numfmts( T_Cnt ).Formatcode := P_Format;
      Workbook.Numfmtindexes( T_Numfmtid ) := T_Cnt;
    END IF;
    RETURN T_Numfmtid;
  END;
----
----
  FUNCTION Get_Font
    ( P_Name VARCHAR2
    , P_Family PLS_INTEGER := 2
    , P_Fontsize NUMBER := 11
    , P_Theme PLS_INTEGER := 1
    , P_Underline BOOLEAN := False
    , P_Italic BOOLEAN := False
    , P_Bold BOOLEAN := False
    , P_Rgb VARCHAR2 := NULL -- this is a hex ALPHA Red Green Blue value
    )
  RETURN PLS_INTEGER
  IS
    T_Ind PLS_INTEGER;
  BEGIN
    IF Workbook.Fonts.Count() > 0
    THEN
      FOR F IN 0 .. Workbook.Fonts.Count() - 1
      LOOP
        IF (   Workbook.Fonts( F ).Name = P_Name
           AND Workbook.Fonts( F ).Family = P_Family
           AND Workbook.Fonts( F ).Fontsize = P_Fontsize
           AND Workbook.Fonts( F ).Theme = P_Theme
           AND Workbook.Fonts( F ).Underline = P_Underline
           AND Workbook.Fonts( F ).Italic = P_Italic
           AND Workbook.Fonts( F ).Bold = P_Bold
           AND ( Workbook.Fonts( F ).Rgb = P_Rgb
               OR ( Workbook.Fonts( F ).Rgb IS NULL AND P_Rgb IS NULL )
               )
           )
        THEN
          RETURN F;
        END IF;
      END LOOP;
    END IF;
    T_Ind := Workbook.Fonts.Count();
    Workbook.Fonts( T_Ind ).Name := P_Name;
    Workbook.Fonts( T_Ind ).Family := P_Family;
    Workbook.Fonts( T_Ind ).Fontsize := P_Fontsize;
    Workbook.Fonts( T_Ind ).Theme := P_Theme;
    Workbook.Fonts( T_Ind ).Underline := P_Underline;
    Workbook.Fonts( T_Ind ).Italic := P_Italic;
    Workbook.Fonts( T_Ind ).Bold := P_Bold;
    Workbook.Fonts( T_Ind ).Rgb := P_Rgb;
    RETURN T_Ind;
  END;
----
----
  FUNCTION Get_Fill
    ( P_Patterntype VARCHAR2
    , P_Fgrgb VARCHAR2 := NULL
    )
  RETURN PLS_INTEGER
  IS
    T_Ind PLS_INTEGER;
  BEGIN
    IF Workbook.Fills.Count() > 0
    THEN
      FOR F IN 0 .. Workbook.Fills.Count() - 1
      LOOP
        IF (   Workbook.Fills( F ).Patterntype = P_Patterntype
           AND Nvl( Workbook.Fills( F ).Fgrgb, 'x' ) = Nvl( Upper( P_Fgrgb ), 'x' )
           )
        THEN
          RETURN F;
        END IF;
      END LOOP;
    END IF;
    T_Ind := Workbook.Fills.Count();
    Workbook.Fills( T_Ind ).Patterntype := P_Patterntype;
    Workbook.Fills( T_Ind ).Fgrgb := Upper( P_Fgrgb );
    RETURN T_Ind;
  END;
----
----
  FUNCTION Get_Border
    ( P_Top VARCHAR2 := 'thin'
    , P_Bottom VARCHAR2 := 'thin'
    , P_Left VARCHAR2 := 'thin'
    , P_Right VARCHAR2 := 'thin'
    )
  RETURN PLS_INTEGER
  IS
    T_Ind PLS_INTEGER;
  BEGIN
    IF Workbook.Borders.Count() > 0
    THEN
      FOR B IN 0 .. Workbook.Borders.Count() - 1
      LOOP
        IF (   Nvl( Workbook.Borders( B ).Top, 'x' ) = Nvl( P_Top, 'x' )
           AND Nvl( Workbook.Borders( B ).Bottom, 'x' ) = Nvl( P_Bottom, 'x' )
           AND Nvl( Workbook.Borders( B ).Left, 'x' ) = Nvl( P_Left, 'x' )
           AND Nvl( Workbook.Borders( B ).Right, 'x' ) = Nvl( P_Right, 'x' )
           )
        THEN
          RETURN B;
        END IF;
      END LOOP;
    END IF;
    T_Ind := Workbook.Borders.Count();
    Workbook.Borders( T_Ind ).Top := P_Top;
    Workbook.Borders( T_Ind ).Bottom := P_Bottom;
    Workbook.Borders( T_Ind ).Left := P_Left;
    Workbook.Borders( T_Ind ).Right := P_Right;
    RETURN T_Ind;
  END;
----
----
  FUNCTION Get_Alignment
    ( P_Vertical VARCHAR2 := NULL
    , P_Horizontal VARCHAR2 := NULL
    , P_Wraptext BOOLEAN := NULL
    )
  RETURN Tp_Alignment
  IS
    T_Rv Tp_Alignment;
  BEGIN
    T_Rv.Vertical := P_Vertical;
    T_Rv.Horizontal := P_Horizontal;
    T_Rv.Wraptext := P_Wraptext;
    RETURN T_Rv;
  END;
----
----
  FUNCTION Get_Xfid
    ( P_Sheet PLS_INTEGER
    , P_Col PLS_INTEGER
    , P_Row PLS_INTEGER
    , P_Numfmtid PLS_INTEGER := NULL
    , P_Fontid PLS_INTEGER := NULL
    , P_Fillid PLS_INTEGER := NULL
    , P_Borderid PLS_INTEGER := NULL
    , P_Alignment Tp_Alignment := NULL
    )
  RETURN VARCHAR2
  IS
    T_Cnt PLS_INTEGER;
    T_Xfid PLS_INTEGER;
    T_Xf Tp_Xf_Fmt;
    T_Col_Xf Tp_Xf_Fmt;
    T_Row_Xf Tp_Xf_Fmt;
  BEGIN
    IF NOT G_Usexf
    THEN
      RETURN '';
    END IF;
    IF Workbook.Sheets( P_Sheet ).Col_Fmts.EXISTS( P_Col )
    THEN
      T_Col_Xf := Workbook.Sheets( P_Sheet ).Col_Fmts( P_Col );
    END IF;
    IF Workbook.Sheets( P_Sheet ).Row_Fmts.EXISTS( P_Row )
    THEN
      T_Row_Xf := Workbook.Sheets( P_Sheet ).Row_Fmts( P_Row );
    END IF;
    T_Xf.Numfmtid := Coalesce( P_Numfmtid, T_Col_Xf.Numfmtid, T_Row_Xf.Numfmtid, 0 );
    T_Xf.Fontid := Coalesce( P_Fontid, T_Col_Xf.Fontid, T_Row_Xf.Fontid, 0 );
    T_Xf.Fillid := Coalesce( P_Fillid, T_Col_Xf.Fillid, T_Row_Xf.Fillid, 0 );
    T_Xf.Borderid := Coalesce( P_Borderid, T_Col_Xf.Borderid, T_Row_Xf.Borderid, 0 );
    T_Xf.Alignment := Get_Alignment
                        ( Coalesce( P_Alignment.Vertical, T_Col_Xf.Alignment.Vertical, T_Row_Xf.Alignment.Vertical )
                        , Coalesce( P_Alignment.Horizontal, T_Col_Xf.Alignment.Horizontal, T_Row_Xf.Alignment.Horizontal )
                        , Coalesce( P_Alignment.Wraptext, T_Col_Xf.Alignment.Wraptext, T_Row_Xf.Alignment.Wraptext )
                        );
    IF (   T_Xf.Numfmtid + T_Xf.Fontid + T_Xf.Fillid + T_Xf.Borderid = 0
       AND T_Xf.Alignment.Vertical IS NULL
       AND T_Xf.Alignment.Horizontal IS NULL
       AND NOT Nvl( T_Xf.Alignment.Wraptext, False )
       )
    THEN
      RETURN '';
    END IF;
    IF T_Xf.Numfmtid > 0
    THEN
      Set_Col_Width( P_Sheet, P_Col, Workbook.Numfmts( Workbook.Numfmtindexes( T_Xf.Numfmtid ) ).Formatcode );
    END IF;
    T_Cnt := Workbook.Cellxfs.Count();
    FOR I IN 1 .. T_Cnt
    LOOP
      IF (   Workbook.Cellxfs( I ).Numfmtid = T_Xf.Numfmtid
         AND Workbook.Cellxfs( I ).Fontid = T_Xf.Fontid
         AND Workbook.Cellxfs( I ).Fillid = T_Xf.Fillid
         AND Workbook.Cellxfs( I ).Borderid = T_Xf.Borderid
         AND Nvl( Workbook.Cellxfs( I ).Alignment.Vertical, 'x' ) = Nvl( T_Xf.Alignment.Vertical, 'x' )
         AND Nvl( Workbook.Cellxfs( I ).Alignment.Horizontal, 'x' ) = Nvl( T_Xf.Alignment.Horizontal, 'x' )
         AND Nvl( Workbook.Cellxfs( I ).Alignment.Wraptext, False ) = Nvl( T_Xf.Alignment.Wraptext, False )
         )
      THEN
        T_Xfid := I;
        EXIT;
      END IF;
    END LOOP;
    IF T_Xfid IS NULL
    THEN
      T_Cnt := T_Cnt + 1;
      T_Xfid := T_Cnt;
      Workbook.Cellxfs( T_Cnt ) := T_Xf;
    END IF;
    RETURN 's="' || T_Xfid || '"';
  END;
----
----
  PROCEDURE Cell
    ( P_Col PLS_INTEGER
    , P_Row PLS_INTEGER
    , P_Value NUMBER
    , P_Numfmtid PLS_INTEGER := NULL
    , P_Fontid PLS_INTEGER := NULL
    , P_Fillid PLS_INTEGER := NULL
    , P_Borderid PLS_INTEGER := NULL
    , P_Alignment Tp_Alignment := NULL
    , P_Sheet PLS_INTEGER := NULL
    )
  IS
    T_Sheet PLS_INTEGER := Nvl( P_Sheet, Workbook.Sheets.Count() );
  BEGIN
    Workbook.Sheets( T_Sheet ).Rows( P_Row )( P_Col ).Value := P_Value;
    Workbook.Sheets( T_Sheet ).Rows( P_Row )( P_Col ).Style := NULL;
    Workbook.Sheets( T_Sheet ).Rows( P_Row )( P_Col ).Style := Get_Xfid( T_Sheet, P_Col, P_Row, 
      P_Numfmtid, P_Fontid, P_Fillid, P_Borderid, P_Alignment );
  END;
----
----
  FUNCTION Add_String( P_String VARCHAR2 )
  RETURN PLS_INTEGER
  IS
    T_Cnt PLS_INTEGER;
  BEGIN
    IF Workbook.Strings.EXISTS( Nvl( P_String, '' ) )
    THEN
      T_Cnt := Workbook.Strings( Nvl( P_String, '' ) );
    ELSE
      T_Cnt := Workbook.Strings.Count();
      Workbook.Str_Ind( T_Cnt ) := P_String;
      Workbook.Strings( Nvl( P_String, '' ) ) := T_Cnt;
    END IF;
    Workbook.Str_Cnt := Workbook.Str_Cnt + 1;
    RETURN T_Cnt;
  END;
----
----
  PROCEDURE Cell
    ( P_Col PLS_INTEGER
    , P_Row PLS_INTEGER
    , P_Value VARCHAR2
    , P_Numfmtid PLS_INTEGER := NULL
    , P_Fontid PLS_INTEGER := NULL
    , P_Fillid PLS_INTEGER := NULL
    , P_Borderid PLS_INTEGER := NULL
    , P_Alignment Tp_Alignment := NULL
    , P_Sheet PLS_INTEGER := NULL
    )
  IS
    T_Sheet PLS_INTEGER := Nvl( P_Sheet, Workbook.Sheets.Count() );
    T_Alignment Tp_Alignment := P_Alignment;
  BEGIN
    Workbook.Sheets( T_Sheet ).Rows( P_Row )( P_Col ).Value := Add_String( P_Value );
    IF T_Alignment.Wraptext IS NULL AND Instr( P_Value, Chr(13) ) > 0
    THEN
      T_Alignment.Wraptext := True;
    END IF;
    Workbook.Sheets( T_Sheet ).Rows( P_Row )( P_Col ).Style := 't="s" ' || Get_Xfid( T_Sheet, P_Col, 
      P_Row, P_Numfmtid, P_Fontid, P_Fillid, P_Borderid, T_Alignment );
  END;
----
----
  PROCEDURE Cell
    ( P_Col PLS_INTEGER
    , P_Row PLS_INTEGER
    , P_Value DATE
    , P_Numfmtid PLS_INTEGER := NULL
    , P_Fontid PLS_INTEGER := NULL
    , P_Fillid PLS_INTEGER := NULL
    , P_Borderid PLS_INTEGER := NULL
    , P_Alignment Tp_Alignment := NULL
    , P_Sheet PLS_INTEGER := NULL
    )
  IS
    T_Numfmtid PLS_INTEGER := P_Numfmtid;
    T_Sheet PLS_INTEGER := Nvl( P_Sheet, Workbook.Sheets.Count() );
  BEGIN
    Workbook.Sheets( T_Sheet ).Rows( P_Row )( P_Col ).Value := P_Value - TO_DATE('01-01-1904','DD-MM-YYYY');
    IF T_Numfmtid IS NULL
       AND NOT (   Workbook.Sheets( T_Sheet ).Col_Fmts.EXISTS( P_Col )
               AND Workbook.Sheets( T_Sheet ).Col_Fmts( P_Col ).Numfmtid IS NOT NULL
               )
       AND NOT (   Workbook.Sheets( T_Sheet ).Row_Fmts.EXISTS( P_Row )
               AND Workbook.Sheets( T_Sheet ).Row_Fmts( P_Row ).Numfmtid IS NOT NULL
               )
    THEN
      T_Numfmtid := Get_Numfmt( 'dd/mm/yyyy' );
    END IF;
    Workbook.Sheets( T_Sheet ).Rows( P_Row )( P_Col ).Style := Get_Xfid( T_Sheet, P_Col, P_Row, 
      T_Numfmtid, P_Fontid, P_Fillid, P_Borderid, P_Alignment );
  END;
----
----
  PROCEDURE Hyperlink
    ( P_Col PLS_INTEGER
    , P_Row PLS_INTEGER
    , P_Url VARCHAR2
    , P_Value VARCHAR2 := NULL
    , P_Sheet PLS_INTEGER := NULL
    )
  IS
    T_Ind PLS_INTEGER;
    T_Sheet PLS_INTEGER := Nvl( P_Sheet, Workbook.Sheets.Count() );
  BEGIN
    Workbook.Sheets( T_Sheet ).Rows( P_Row )( P_Col ).Value := Add_String( Nvl( P_Value, P_Url ) );
    Workbook.Sheets( T_Sheet ).Rows( P_Row )( P_Col ).Style := 't="s" ' 
      || Get_Xfid( T_Sheet, P_Col, P_Row, '', Get_Font( 'Calibri', P_Theme => 10, P_Underline => True ) );
    T_Ind := Workbook.Sheets( T_Sheet ).Hyperlinks.Count() + 1;
    Workbook.Sheets( T_Sheet ).Hyperlinks( T_Ind ).Cell := Alfan_Col( P_Col ) || P_Row;
    Workbook.Sheets( T_Sheet ).Hyperlinks( T_Ind ).Url := P_Url;
  END;
----
----
  PROCEDURE Comment
    ( P_Col    PLS_INTEGER
    , P_Row    PLS_INTEGER
    , P_Text   VARCHAR2
    , P_Author VARCHAR2 := NULL
    , P_Width  PLS_INTEGER := 150
    , P_Height PLS_INTEGER := 100
    , P_Sheet  PLS_INTEGER := NULL
    )
  IS
    T_Ind PLS_INTEGER;
    T_Sheet PLS_INTEGER := Nvl( P_Sheet, Workbook.Sheets.Count() );
  BEGIN
    T_Ind := Workbook.Sheets( T_Sheet ).Comments.Count() + 1;
    Workbook.Sheets( T_Sheet ).Comments( T_Ind ).Row := P_Row;
    Workbook.Sheets( T_Sheet ).Comments( T_Ind ).Column := P_Col;
    Workbook.Sheets( T_Sheet ).Comments( T_Ind ).Text := Dbms_Xmlgen.Convert( P_Text );
    Workbook.Sheets( T_Sheet ).Comments( T_Ind ).Author := Dbms_Xmlgen.Convert( P_Author );
    Workbook.Sheets( T_Sheet ).Comments( T_Ind ).Width := P_Width;
    Workbook.Sheets( T_Sheet ).Comments( T_Ind ).Height := P_Height;
  END;
----
----
  PROCEDURE Mergecells
    ( P_Tl_Col PLS_INTEGER -- top left
    , P_Tl_Row PLS_INTEGER
    , P_Br_Col PLS_INTEGER -- bottom right
    , P_Br_Row PLS_INTEGER
    , P_Sheet PLS_INTEGER := NULL
    )
  IS
    T_Ind PLS_INTEGER;
    T_Sheet PLS_INTEGER := Nvl( P_Sheet, Workbook.Sheets.Count() );
  BEGIN
    T_Ind := Workbook.Sheets( T_Sheet ).Mergecells.Count() + 1;
    Workbook.Sheets( T_Sheet ).Mergecells( T_Ind ) := Alfan_Col( P_Tl_Col ) || P_Tl_Row || ':' || Alfan_Col( P_Br_Col ) || P_Br_Row;
  END;
----
----
  PROCEDURE Add_Validation
    ( P_Type VARCHAR2
    , P_Sqref VARCHAR2
    , P_Style VARCHAR2 := 'stop' -- stop, warning, information
    , P_Formula1 VARCHAR2 := NULL
    , P_Formula2 VARCHAR2 := NULL
    , P_Title VARCHAR2 := NULL
    , P_Prompt VARCHAR := NULL
    , P_Show_Error BOOLEAN := False
    , P_Error_Title VARCHAR2 := NULL
    , P_Error_Txt VARCHAR2 := NULL
    , P_Sheet PLS_INTEGER := NULL
    )
  IS
    T_Ind PLS_INTEGER;
    T_Sheet PLS_INTEGER := Nvl( P_Sheet, Workbook.Sheets.Count() );
  BEGIN
    T_Ind := Workbook.Sheets( T_Sheet ).Validations.Count() + 1;
    Workbook.Sheets( T_Sheet ).Validations( T_Ind ).Type := P_Type;
    Workbook.Sheets( T_Sheet ).Validations( T_Ind ).Errorstyle := P_Style;
    Workbook.Sheets( T_Sheet ).Validations( T_Ind ).Sqref := P_Sqref;
    Workbook.Sheets( T_Sheet ).Validations( T_Ind ).Formula1 := P_Formula1;
    Workbook.Sheets( T_Sheet ).Validations( T_Ind ).Error_Title := P_Error_Title;
    Workbook.Sheets( T_Sheet ).Validations( T_Ind ).Error_Txt := P_Error_Txt;
    Workbook.Sheets( T_Sheet ).Validations( T_Ind ).Title := P_Title;
    Workbook.Sheets( T_Sheet ).Validations( T_Ind ).Prompt := P_Prompt;
    Workbook.Sheets( T_Sheet ).Validations( T_Ind ).Showerrormessage := P_Show_Error;
  END;
----
----
  PROCEDURE List_Validation
    ( P_Sqref_Col PLS_INTEGER
    , P_Sqref_Row PLS_INTEGER
    , P_Tl_Col PLS_INTEGER -- top left
    , P_Tl_Row PLS_INTEGER
    , P_Br_Col PLS_INTEGER -- bottom right
    , P_Br_Row PLS_INTEGER
    , P_Style VARCHAR2 := 'stop' -- stop, warning, information
    , P_Title VARCHAR2 := NULL
    , P_Prompt VARCHAR := NULL
    , P_Show_Error BOOLEAN := False
    , P_Error_Title VARCHAR2 := NULL
    , P_Error_Txt VARCHAR2 := NULL
    , P_Sheet PLS_INTEGER := NULL
    )
  IS
  BEGIN
    Add_Validation( 'list'
                  , Alfan_Col( P_Sqref_Col ) || P_Sqref_Row
                  , P_Style => Lower( P_Style )
                  , P_Formula1 => '$' || Alfan_Col( P_Tl_Col ) || '$' ||  P_Tl_Row || ':$' || Alfan_Col( P_Br_Col ) || '$' || P_Br_Row
                  , P_Title => P_Title
                  , P_Prompt => P_Prompt
                  , P_Show_Error => P_Show_Error
                  , P_Error_Title => P_Error_Title
                  , P_Error_Txt => P_Error_Txt
                  , P_Sheet => P_Sheet
                  );
  END;
--
  PROCEDURE List_Validation
    ( P_Sqref_Col PLS_INTEGER
    , P_Sqref_Row PLS_INTEGER
    , P_Defined_Name VARCHAR2
    , P_Style VARCHAR2 := 'stop' -- stop, warning, information
    , P_Title VARCHAR2 := NULL
    , P_Prompt VARCHAR := NULL
    , P_Show_Error BOOLEAN := False
    , P_Error_Title VARCHAR2 := NULL
    , P_Error_Txt VARCHAR2 := NULL
    , P_Sheet PLS_INTEGER := NULL
    )
  IS
  BEGIN
    Add_Validation( 'list'
                  , Alfan_Col( P_Sqref_Col ) || P_Sqref_Row
                  , P_Style => Lower( P_Style )
                  , P_Formula1 => P_Defined_Name
                  , P_Title => P_Title
                  , P_Prompt => P_Prompt
                  , P_Show_Error => P_Show_Error
                  , P_Error_Title => P_Error_Title
                  , P_Error_Txt => P_Error_Txt
                  , P_Sheet => P_Sheet
                  );
  END;
--
  PROCEDURE Defined_Name
    ( P_Tl_Col PLS_INTEGER -- top left
    , P_Tl_Row PLS_INTEGER
    , P_Br_Col PLS_INTEGER -- bottom right
    , P_Br_Row PLS_INTEGER
    , P_Name VARCHAR2
    , P_Sheet PLS_INTEGER := NULL
    , P_Localsheet PLS_INTEGER := NULL
    )
  IS
    T_Ind PLS_INTEGER;
    T_Sheet PLS_INTEGER := Nvl( P_Sheet, Workbook.Sheets.Count() );
  BEGIN
    T_Ind := Workbook.Defined_Names.Count() + 1;
    Workbook.Defined_Names( T_Ind ).Name := P_Name;
    Workbook.Defined_Names( T_Ind ).Ref := 'Sheet' || T_Sheet || '!$' || Alfan_Col( P_Tl_Col ) 
      || '$' ||  P_Tl_Row || ':$' || Alfan_Col( P_Br_Col ) || '$' || P_Br_Row;
    Workbook.Defined_Names( T_Ind ).Sheet := P_Localsheet;
  END;
--
  PROCEDURE Set_Column_Width
    ( P_Col PLS_INTEGER
    , P_Width NUMBER
    , P_Sheet PLS_INTEGER := NULL
    )
  IS
  BEGIN
    Workbook.Sheets( Nvl( P_Sheet, Workbook.Sheets.Count() ) ).Widths( P_Col ) := P_Width;
  END;
--
  PROCEDURE Set_Column
    ( P_Col PLS_INTEGER
    , P_Numfmtid PLS_INTEGER := NULL
    , P_Fontid PLS_INTEGER := NULL
    , P_Fillid PLS_INTEGER := NULL
    , P_Borderid PLS_INTEGER := NULL
    , P_Alignment Tp_Alignment := NULL
    , P_Sheet PLS_INTEGER := NULL
    )
  IS
    T_Sheet PLS_INTEGER := Nvl( P_Sheet, Workbook.Sheets.Count() );
  BEGIN
    Workbook.Sheets( T_Sheet ).Col_Fmts( P_Col ).Numfmtid := P_Numfmtid;
    Workbook.Sheets( T_Sheet ).Col_Fmts( P_Col ).Fontid := P_Fontid;
    Workbook.Sheets( T_Sheet ).Col_Fmts( P_Col ).Fillid := P_Fillid;
    Workbook.Sheets( T_Sheet ).Col_Fmts( P_Col ).Borderid := P_Borderid;
    Workbook.Sheets( T_Sheet ).Col_Fmts( P_Col ).Alignment := P_Alignment;
  END;
--
  PROCEDURE Set_Row
    ( P_Row PLS_INTEGER
    , P_Numfmtid PLS_INTEGER := NULL
    , P_Fontid PLS_INTEGER := NULL
    , P_Fillid PLS_INTEGER := NULL
    , P_Borderid PLS_INTEGER := NULL
    , P_Alignment Tp_Alignment := NULL
    , P_Sheet PLS_INTEGER := NULL
    , P_Height NUMBER := NULL
    )
  IS
    T_Sheet PLS_INTEGER := Nvl( P_Sheet, Workbook.Sheets.Count() );
  BEGIN
    Workbook.Sheets( T_Sheet ).Row_Fmts( P_Row ).Numfmtid := P_Numfmtid;
    Workbook.Sheets( T_Sheet ).Row_Fmts( P_Row ).Fontid := P_Fontid;
    Workbook.Sheets( T_Sheet ).Row_Fmts( P_Row ).Fillid := P_Fillid;
    Workbook.Sheets( T_Sheet ).Row_Fmts( P_Row ).Borderid := P_Borderid;
    Workbook.Sheets( T_Sheet ).Row_Fmts( P_Row ).Alignment := P_Alignment;
    Workbook.Sheets( T_Sheet ).Row_Fmts( P_Row ).Height := P_Height;
  END;
--
  PROCEDURE Freeze_Rows
    ( P_Nr_Rows PLS_INTEGER := 1
    , P_Sheet PLS_INTEGER := NULL
    )
  IS
    T_Sheet PLS_INTEGER := Nvl( P_Sheet, Workbook.Sheets.Count() );
  BEGIN
    Workbook.Sheets( T_Sheet ).Freeze_Cols := NULL;
    Workbook.Sheets( T_Sheet ).Freeze_Rows := P_Nr_Rows;
  END;
--
  PROCEDURE Freeze_Cols
    ( P_Nr_Cols PLS_INTEGER := 1
    , P_Sheet PLS_INTEGER := NULL
    )
  IS
    T_Sheet PLS_INTEGER := Nvl( P_Sheet, Workbook.Sheets.Count() );
  BEGIN
    Workbook.Sheets( T_Sheet ).Freeze_Rows := NULL;
    Workbook.Sheets( T_Sheet ).Freeze_Cols := P_Nr_Cols;
  END;
--
  PROCEDURE Freeze_Pane
    ( P_Col PLS_INTEGER
    , P_Row PLS_INTEGER
    , P_Sheet PLS_INTEGER := NULL
    )
  IS
    T_Sheet PLS_INTEGER := Nvl( P_Sheet, Workbook.Sheets.Count() );
  BEGIN
    Workbook.Sheets( T_Sheet ).Freeze_Rows := P_Row;
    Workbook.Sheets( T_Sheet ).Freeze_Cols := P_Col;
  END;
--
  PROCEDURE Set_Autofilter
    ( P_Column_Start PLS_INTEGER := NULL
    , P_Column_End PLS_INTEGER := NULL
    , P_Row_Start PLS_INTEGER := NULL
    , P_Row_End PLS_INTEGER := NULL
    , P_Sheet PLS_INTEGER := NULL
    )
  IS
    T_Ind PLS_INTEGER;
    T_Sheet PLS_INTEGER := Nvl( P_Sheet, Workbook.Sheets.Count() );
  BEGIN
    T_Ind := 1;
    Workbook.Sheets( T_Sheet ).Autofilters( T_Ind ).Column_Start := P_Column_Start;
    Workbook.Sheets( T_Sheet ).Autofilters( T_Ind ).Column_End := P_Column_End;
    Workbook.Sheets( T_Sheet ).Autofilters( T_Ind ).Row_Start := P_Row_Start;
    Workbook.Sheets( T_Sheet ).Autofilters( T_Ind ).Row_End := P_Row_End;
    Defined_Name
      ( P_Column_Start
      , P_Row_Start
      , P_Column_End
      , P_Row_End
      , '_xlnm._FilterDatabase'
      , T_Sheet
      , T_Sheet - 1
      );
  END;
--
--
  PROCEDURE Add1xml
    ( P_Excel IN OUT NOCOPY BLOB
    , P_Filename VARCHAR2
    , P_Xml CLOB)
  IS
    T_Tmp        BLOB;
    Dest_Offset  INTEGER := 1;
    Src_Offset   INTEGER := 1;
    Lang_Context INTEGER;
    Warning      INTEGER;
  BEGIN
    Lang_Context := Dbms_Lob.Default_Lang_Ctx;
    Dbms_Lob.Createtemporary(T_Tmp,True);
    Dbms_Lob.Converttoblob(T_Tmp,
                           P_Xml,
                           Dbms_Lob.Lobmaxsize,
                           Dest_Offset,
                           Src_Offset,
                           Nls_Charset_Id( 'AL32UTF8'  ),
                           Lang_Context,
                           Warning);
    Add1file(P_Excel,P_Filename,T_Tmp);
    Dbms_Lob.Freetemporary(T_Tmp);
  END;
----
----
  FUNCTION Finish
  RETURN BLOB
  IS
    T_Excel BLOB;
    T_Yyy BLOB;
    T_Xxx CLOB;
    T_Tmp VARCHAR2(32767 CHAR);
    T_Str VARCHAR2(32767 CHAR);
    T_C NUMBER;
    T_H NUMBER;
    T_W NUMBER;
    T_Cw NUMBER;
    S PLS_INTEGER;
    T_Row_Ind PLS_INTEGER;
    T_Col_Min PLS_INTEGER;
    T_Col_Max PLS_INTEGER;
    T_Col_Ind PLS_INTEGER;
    T_Len PLS_INTEGER;
  BEGIN
    Dbms_Lob.Createtemporary( T_Excel, True );
    T_Xxx := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
<Default Extension="xml" ContentType="application/xml"/>
<Default Extension="vml" ContentType="application/vnd.openxmlformats-officedocument.vmlDrawing"/>
<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>';
    S := Workbook.Sheets.First;
    WHILE S IS NOT NULL
    LOOP
      T_Xxx := T_Xxx || ( '
<Override PartName="/xl/worksheets/sheet' || S || '.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>' );
      S := Workbook.Sheets.Next( S );
    END LOOP;
    T_Xxx := T_Xxx || '
<Override PartName="/xl/theme/theme1.xml" ContentType="application/vnd.openxmlformats-officedocument.theme+xml"/>
<Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>
<Override PartName="/xl/sharedStrings.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sharedStrings+xml"/>
<Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/>
<Override PartName="/docProps/app.xml" ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml"/>';
    S := Workbook.Sheets.First;
    WHILE S IS NOT NULL
    LOOP
      IF Workbook.Sheets( S ).Comments.Count() > 0
      THEN
        T_Xxx := T_Xxx || ( '
<Override PartName="/xl/comments' || S || '.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.comments+xml"/>' );
      END IF;
      S := Workbook.Sheets.Next( S );
    END LOOP;
    T_Xxx := T_Xxx || '
</Types>';
    Add1xml( T_Excel, '[Content_Types].xml', T_Xxx );
    T_Xxx := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcmitype="http://purl.org/dc/dcmitype/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<dc:creator>' || Sys_Context( 'userenv', 'os_user' ) || '</dc:creator>
<cp:lastModifiedBy>' || Sys_Context( 'userenv', 'os_user' ) || '</cp:lastModifiedBy>
<dcterms:created xsi:type="dcterms:W3CDTF">' || To_Char( Current_Timestamp, 'yyyy-mm-dd"T"hh24:mi:ssTZH:TZM' ) || '</dcterms:created>
<dcterms:modified xsi:type="dcterms:W3CDTF">' || To_Char( Current_Timestamp, 'yyyy-mm-dd"T"hh24:mi:ssTZH:TZM' ) || '</dcterms:modified>
</cp:coreProperties>';
    Add1xml( T_Excel, 'docProps/core.xml', T_Xxx );
    T_Xxx := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties" xmlns:vt="http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes">
<Application>Microsoft Excel</Application>
<DocSecurity>0</DocSecurity>
<ScaleCrop>false</ScaleCrop>
<HeadingPairs>
<vt:vector size="2" baseType="variant">
<vt:variant>
<vt:lpstr>Worksheets</vt:lpstr>
</vt:variant>
<vt:variant>
<vt:i4>' || Workbook.Sheets.Count() || '</vt:i4>
</vt:variant>
</vt:vector>
</HeadingPairs>
<TitlesOfParts>
<vt:vector size="' || Workbook.Sheets.Count() || '" baseType="lpstr">';
    S := Workbook.Sheets.First;
    WHILE S IS NOT NULL
    LOOP
      T_Xxx := T_Xxx || ( '
<vt:lpstr>' || Workbook.Sheets( S ).Name || '</vt:lpstr>' );
      S := Workbook.Sheets.Next( S );
    END LOOP;
    T_Xxx := T_Xxx || '</vt:vector>
</TitlesOfParts>
<LinksUpToDate>false</LinksUpToDate>
<SharedDoc>false</SharedDoc>
<HyperlinksChanged>false</HyperlinksChanged>
<AppVersion>14.0300</AppVersion>
</Properties>';
    Add1xml( T_Excel, 'docProps/app.xml', T_Xxx );
    T_Xxx := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties" Target="docProps/app.xml"/>
<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/>
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>
</Relationships>';
    Add1xml( T_Excel, '_rels/.rels', T_Xxx );
    T_Xxx := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac">';
    IF Workbook.Numfmts.Count() > 0
    THEN
      T_Xxx := T_Xxx || ( '<numFmts count="' || Workbook.Numfmts.Count() || '">' );
      FOR N IN 1 .. Workbook.Numfmts.Count()
      LOOP
        T_Xxx := T_Xxx || ( '<numFmt numFmtId="' || Workbook.Numfmts( N ).Numfmtid || '" formatCode="' || Workbook.Numfmts( N ).Formatcode || '"/>' );
      END LOOP;
      T_Xxx := T_Xxx || '</numFmts>';
    END IF;
    T_Xxx := T_Xxx || ( '<fonts count="' || Workbook.Fonts.Count() || '" x14ac:knownFonts="1">' );
    FOR F IN 0 .. Workbook.Fonts.Count() - 1
    LOOP
      T_Xxx := T_Xxx || ( '<font>' ||
        CASE WHEN Workbook.Fonts( F ).Bold THEN '<b/>' END ||
        CASE WHEN Workbook.Fonts( F ).Italic THEN '<i/>' END ||
        CASE WHEN Workbook.Fonts( F ).Underline THEN '<u/>' END ||
'<sz val="' || To_Char( Workbook.Fonts( F ).Fontsize, 'TM9', 'NLS_NUMERIC_CHARACTERS=.,' )  || '"/>
<color ' || CASE WHEN Workbook.Fonts( F ).Rgb IS NOT NULL
              THEN 'rgb="' || Workbook.Fonts( F ).Rgb
              ELSE 'theme="' || Workbook.Fonts( F ).Theme
            END || '"/>
<name val="' || Workbook.Fonts( F ).Name || '"/>
<family val="' || Workbook.Fonts( F ).Family || '"/>
<scheme val="none"/>
</font>' );
    END LOOP;
    T_Xxx := T_Xxx || ( '</fonts>
<fills count="' || Workbook.Fills.Count() || '">' );
    FOR F IN 0 .. Workbook.Fills.Count() - 1
    LOOP
      T_Xxx := T_Xxx || ( '<fill><patternFill patternType="' || Workbook.Fills( F ).Patterntype || '">' ||
         CASE WHEN Workbook.Fills( F ).Fgrgb IS NOT NULL THEN '<fgColor rgb="' || Workbook.Fills( F ).Fgrgb || '"/>' END ||
         '</patternFill></fill>' );
    END LOOP;
    T_Xxx := T_Xxx || ( '</fills>
<borders count="' || Workbook.Borders.Count() || '">' );
    FOR B IN 0 .. Workbook.Borders.Count() - 1
    LOOP
      T_Xxx := T_Xxx || ( '<border>' ||
         CASE WHEN Workbook.Borders( B ).Left   IS NULL THEN '<left/>'   ELSE '<left style="'   || Workbook.Borders( B ).Left   || '"/>' END ||
         CASE WHEN Workbook.Borders( B ).Right  IS NULL THEN '<right/>'  ELSE '<right style="'  || Workbook.Borders( B ).Right  || '"/>' END ||
         CASE WHEN Workbook.Borders( B ).Top    IS NULL THEN '<top/>'    ELSE '<top style="'    || Workbook.Borders( B ).Top    || '"/>' END ||
         CASE WHEN Workbook.Borders( B ).Bottom IS NULL THEN '<bottom/>' ELSE '<bottom style="' || Workbook.Borders( B ).Bottom || '"/>' END ||
         '</border>' );
    END LOOP;
    T_Xxx := T_Xxx || ( '</borders>
<cellStyleXfs count="1">
<xf numFmtId="0" fontId="0" fillId="0" borderId="0"/>
</cellStyleXfs>
<cellXfs count="' || ( Workbook.Cellxfs.Count() + 1 ) || '">
<xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/>' );
    FOR X IN 1 .. Workbook.Cellxfs.Count()
    LOOP
      T_Xxx := T_Xxx || ( '<xf numFmtId="' || Workbook.Cellxfs( X ).Numfmtid || '" fontId="' || Workbook.Cellxfs( X ).Fontid || '" fillId="' || Workbook.Cellxfs( X ).Fillid || '" borderId="' || Workbook.Cellxfs( X ).Borderid || '">' );
      IF (  Workbook.Cellxfs( X ).Alignment.Horizontal IS NOT NULL
         OR Workbook.Cellxfs( X ).Alignment.Vertical IS NOT NULL
         OR Workbook.Cellxfs( X ).Alignment.Wraptext
         )
      THEN
        T_Xxx := T_Xxx || ( '<alignment' ||
          CASE WHEN Workbook.Cellxfs( X ).Alignment.Horizontal IS NOT NULL THEN ' horizontal="' || Workbook.Cellxfs( X ).Alignment.Horizontal || '"' END ||
          CASE WHEN Workbook.Cellxfs( X ).Alignment.Vertical IS NOT NULL THEN ' vertical="' || Workbook.Cellxfs( X ).Alignment.Vertical || '"' END ||
          CASE WHEN Workbook.Cellxfs( X ).Alignment.Wraptext THEN ' wrapText="true"' END || '/>' );
      END IF;
      T_Xxx := T_Xxx || '</xf>';
    END LOOP;
    T_Xxx := T_Xxx || ( '</cellXfs>
<cellStyles count="1">
<cellStyle name="Normal" xfId="0" builtinId="0"/>
</cellStyles>
<dxfs count="0"/>
<tableStyles count="0" defaultTableStyle="TableStyleMedium2" defaultPivotStyle="PivotStyleLight16"/>
<extLst>
<ext uri="{EB79DEF2-80B8-43e5-95BD-54CBDDF9020C}" xmlns:x14="http://schemas.microsoft.com/office/spreadsheetml/2009/9/main">
<x14:slicerStyles defaultSlicerStyle="SlicerStyleLight1"/>
</ext>
</extLst>
</styleSheet>' );
    Add1xml( T_Excel, 'xl/styles.xml', T_Xxx );
    T_Xxx := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
<fileVersion appName="xl" lastEdited="5" lowestEdited="5" rupBuild="9302"/>
<workbookPr date1904="true" defaultThemeVersion="124226"/>
<bookViews>
<workbookView xWindow="120" yWindow="45" windowWidth="19155" windowHeight="4935"/>
</bookViews>
<sheets>';
    S := Workbook.Sheets.First;
    WHILE S IS NOT NULL
    LOOP
      T_Xxx := T_Xxx || ( '
<sheet name="' || Workbook.Sheets( S ).Name || '" sheetId="' || S || '" r:id="rId' || ( 9 + S ) || '"/>' );
      S := Workbook.Sheets.Next( S );
    END LOOP;
    T_Xxx := T_Xxx || '</sheets>';
    IF Workbook.Defined_Names.Count() > 0
    THEN
      T_Xxx := T_Xxx || '<definedNames>';
      FOR S IN 1 .. Workbook.Defined_Names.Count()
      LOOP
        T_Xxx := T_Xxx || ( '
<definedName name="' || Workbook.Defined_Names( S ).Name || '"' ||
            CASE WHEN Workbook.Defined_Names( S ).Sheet IS NOT NULL THEN ' localSheetId="' || To_Char( Workbook.Defined_Names( S ).Sheet ) || '"' END ||
            '>' || Workbook.Defined_Names( S ).Ref || '</definedName>' );
      END LOOP;
      T_Xxx := T_Xxx || '</definedNames>';
    END IF;
    T_Xxx := T_Xxx || '<calcPr calcId="144525"/></workbook>';
    Add1xml( T_Excel, 'xl/workbook.xml', T_Xxx );
    T_Xxx := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<a:theme xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" name="Office Theme">
<a:themeElements>
<a:clrScheme name="Office">
<a:dk1>
<a:sysClr val="windowText" lastClr="000000"/>
</a:dk1>
<a:lt1>
<a:sysClr val="window" lastClr="FFFFFF"/>
</a:lt1>
<a:dk2>
<a:srgbClr val="1F497D"/>
</a:dk2>
<a:lt2>
<a:srgbClr val="EEECE1"/>
</a:lt2>
<a:accent1>
<a:srgbClr val="4F81BD"/>
</a:accent1>
<a:accent2>
<a:srgbClr val="C0504D"/>
</a:accent2>
<a:accent3>
<a:srgbClr val="9BBB59"/>
</a:accent3>
<a:accent4>
<a:srgbClr val="8064A2"/>
</a:accent4>
<a:accent5>
<a:srgbClr val="4BACC6"/>
</a:accent5>
<a:accent6>
<a:srgbClr val="F79646"/>
</a:accent6>
<a:hlink>
<a:srgbClr val="0000FF"/>
</a:hlink>
<a:folHlink>
<a:srgbClr val="800080"/>
</a:folHlink>
</a:clrScheme>
<a:fontScheme name="Office">
<a:majorFont>
<a:latin typeface="Cambria"/>
<a:ea typeface=""/>
<a:cs typeface=""/>
<a:font script="Jpan" typeface="MS P????"/>
<a:font script="Hang" typeface="?? ??"/>
<a:font script="Hans" typeface="??"/>
<a:font script="Hant" typeface="????"/>
<a:font script="Arab" typeface="Times New Roman"/>
<a:font script="Hebr" typeface="Times New Roman"/>
<a:font script="Thai" typeface="Tahoma"/>
<a:font script="Ethi" typeface="Nyala"/>
<a:font script="Beng" typeface="Vrinda"/>
<a:font script="Gujr" typeface="Shruti"/>
<a:font script="Khmr" typeface="MoolBoran"/>
<a:font script="Knda" typeface="Tunga"/>
<a:font script="Guru" typeface="Raavi"/>
<a:font script="Cans" typeface="Euphemia"/>
<a:font script="Cher" typeface="Plantagenet Cherokee"/>
<a:font script="Yiii" typeface="Microsoft Yi Baiti"/>
<a:font script="Tibt" typeface="Microsoft Himalaya"/>
<a:font script="Thaa" typeface="MV Boli"/>
<a:font script="Deva" typeface="Mangal"/>
<a:font script="Telu" typeface="Gautami"/>
<a:font script="Taml" typeface="Latha"/>
<a:font script="Syrc" typeface="Estrangelo Edessa"/>
<a:font script="Orya" typeface="Kalinga"/>
<a:font script="Mlym" typeface="Kartika"/>
<a:font script="Laoo" typeface="DokChampa"/>
<a:font script="Sinh" typeface="Iskoola Pota"/>
<a:font script="Mong" typeface="Mongolian Baiti"/>
<a:font script="Viet" typeface="Times New Roman"/>
<a:font script="Uigh" typeface="Microsoft Uighur"/>
<a:font script="Geor" typeface="Sylfaen"/>
</a:majorFont>
<a:minorFont>
<a:latin typeface="Calibri"/>
<a:ea typeface=""/>
<a:cs typeface=""/>
<a:font script="Jpan" typeface="MS P????"/>
<a:font script="Hang" typeface="?? ??"/>
<a:font script="Hans" typeface="??"/>
<a:font script="Hant" typeface="????"/>
<a:font script="Arab" typeface="Arial"/>
<a:font script="Hebr" typeface="Arial"/>
<a:font script="Thai" typeface="Tahoma"/>
<a:font script="Ethi" typeface="Nyala"/>
<a:font script="Beng" typeface="Vrinda"/>
<a:font script="Gujr" typeface="Shruti"/>
<a:font script="Khmr" typeface="DaunPenh"/>
<a:font script="Knda" typeface="Tunga"/>
<a:font script="Guru" typeface="Raavi"/>
<a:font script="Cans" typeface="Euphemia"/>
<a:font script="Cher" typeface="Plantagenet Cherokee"/>
<a:font script="Yiii" typeface="Microsoft Yi Baiti"/>
<a:font script="Tibt" typeface="Microsoft Himalaya"/>
<a:font script="Thaa" typeface="MV Boli"/>
<a:font script="Deva" typeface="Mangal"/>
<a:font script="Telu" typeface="Gautami"/>
<a:font script="Taml" typeface="Latha"/>
<a:font script="Syrc" typeface="Estrangelo Edessa"/>
<a:font script="Orya" typeface="Kalinga"/>
<a:font script="Mlym" typeface="Kartika"/>
<a:font script="Laoo" typeface="DokChampa"/>
<a:font script="Sinh" typeface="Iskoola Pota"/>
<a:font script="Mong" typeface="Mongolian Baiti"/>
<a:font script="Viet" typeface="Arial"/>
<a:font script="Uigh" typeface="Microsoft Uighur"/>
<a:font script="Geor" typeface="Sylfaen"/>
</a:minorFont>
</a:fontScheme>
<a:fmtScheme name="Office">
<a:fillStyleLst>
<a:solidFill>
<a:schemeClr val="phClr"/>
</a:solidFill>
<a:gradFill rotWithShape="1">
<a:gsLst>
<a:gs pos="0">
<a:schemeClr val="phClr">
<a:tint val="50000"/>
<a:satMod val="300000"/>
</a:schemeClr>
</a:gs>
<a:gs pos="35000">
<a:schemeClr val="phClr">
<a:tint val="37000"/>
<a:satMod val="300000"/>
</a:schemeClr>
</a:gs>
<a:gs pos="100000">
<a:schemeClr val="phClr">
<a:tint val="15000"/>
<a:satMod val="350000"/>
</a:schemeClr>
</a:gs>
</a:gsLst>
<a:lin ang="16200000" scaled="1"/>
</a:gradFill>
<a:gradFill rotWithShape="1">
<a:gsLst>
<a:gs pos="0">
<a:schemeClr val="phClr">
<a:shade val="51000"/>
<a:satMod val="130000"/>
</a:schemeClr>
</a:gs>
<a:gs pos="80000">
<a:schemeClr val="phClr">
<a:shade val="93000"/>
<a:satMod val="130000"/>
</a:schemeClr>
</a:gs>
<a:gs pos="100000">
<a:schemeClr val="phClr">
<a:shade val="94000"/>
<a:satMod val="135000"/>
</a:schemeClr>
</a:gs>
</a:gsLst>
<a:lin ang="16200000" scaled="0"/>
</a:gradFill>
</a:fillStyleLst>
<a:lnStyleLst>
<a:ln w="9525" cap="flat" cmpd="sng" algn="ctr">
<a:solidFill>
<a:schemeClr val="phClr">
<a:shade val="95000"/>
<a:satMod val="105000"/>
</a:schemeClr>
</a:solidFill>
<a:prstDash val="solid"/>
</a:ln>
<a:ln w="25400" cap="flat" cmpd="sng" algn="ctr">
<a:solidFill>
<a:schemeClr val="phClr"/>
</a:solidFill>
<a:prstDash val="solid"/>
</a:ln>
<a:ln w="38100" cap="flat" cmpd="sng" algn="ctr">
<a:solidFill>
<a:schemeClr val="phClr"/>
</a:solidFill>
<a:prstDash val="solid"/>
</a:ln>
</a:lnStyleLst>
<a:effectStyleLst>
<a:effectStyle>
<a:effectLst>
<a:outerShdw blurRad="40000" dist="20000" dir="5400000" rotWithShape="0">
<a:srgbClr val="000000">
<a:alpha val="38000"/>
</a:srgbClr>
</a:outerShdw>
</a:effectLst>
</a:effectStyle>
<a:effectStyle>
<a:effectLst>
<a:outerShdw blurRad="40000" dist="23000" dir="5400000" rotWithShape="0">
<a:srgbClr val="000000">
<a:alpha val="35000"/>
</a:srgbClr>
</a:outerShdw>
</a:effectLst>
</a:effectStyle>
<a:effectStyle>
<a:effectLst>
<a:outerShdw blurRad="40000" dist="23000" dir="5400000" rotWithShape="0">
<a:srgbClr val="000000">
<a:alpha val="35000"/>
</a:srgbClr>
</a:outerShdw>
</a:effectLst>
<a:scene3d>
<a:camera prst="orthographicFront">
<a:rot lat="0" lon="0" rev="0"/>
</a:camera>
<a:lightRig rig="threePt" dir="t">
<a:rot lat="0" lon="0" rev="1200000"/>
</a:lightRig>
</a:scene3d>
<a:sp3d>
<a:bevelT w="63500" h="25400"/>
</a:sp3d>
</a:effectStyle>
</a:effectStyleLst>
<a:bgFillStyleLst>
<a:solidFill>
<a:schemeClr val="phClr"/>
</a:solidFill>
<a:gradFill rotWithShape="1">
<a:gsLst>
<a:gs pos="0">
<a:schemeClr val="phClr">
<a:tint val="40000"/>
<a:satMod val="350000"/>
</a:schemeClr>
</a:gs>
<a:gs pos="40000">
<a:schemeClr val="phClr">
<a:tint val="45000"/>
<a:shade val="99000"/>
<a:satMod val="350000"/>
</a:schemeClr>
</a:gs>
<a:gs pos="100000">
<a:schemeClr val="phClr">
<a:shade val="20000"/>
<a:satMod val="255000"/>
</a:schemeClr>
</a:gs>
</a:gsLst>
<a:path path="circle">
<a:fillToRect l="50000" t="-80000" r="50000" b="180000"/>
</a:path>
</a:gradFill>
<a:gradFill rotWithShape="1">
<a:gsLst>
<a:gs pos="0">
<a:schemeClr val="phClr">
<a:tint val="80000"/>
<a:satMod val="300000"/>
</a:schemeClr>
</a:gs>
<a:gs pos="100000">
<a:schemeClr val="phClr">
<a:shade val="30000"/>
<a:satMod val="200000"/>
</a:schemeClr>
</a:gs>
</a:gsLst>
<a:path path="circle">
<a:fillToRect l="50000" t="50000" r="50000" b="50000"/>
</a:path>
</a:gradFill>
</a:bgFillStyleLst>
</a:fmtScheme>
</a:themeElements>
<a:objectDefaults/>
<a:extraClrSchemeLst/>
</a:theme>';
    Add1xml( T_Excel, 'xl/theme/theme1.xml', T_Xxx );
    S := Workbook.Sheets.First;
    WHILE S IS NOT NULL
    LOOP
      T_Col_Min := 16384;
      T_Col_Max := 1;
      T_Row_Ind := Workbook.Sheets( S ).Rows.First();
      WHILE T_Row_Ind IS NOT NULL
      LOOP
        T_Col_Min := Least( T_Col_Min, Workbook.Sheets( S ).Rows( T_Row_Ind ).First() );
        T_Col_Max := Greatest( T_Col_Max, Workbook.Sheets( S ).Rows( T_Row_Ind ).Last() );
        T_Row_Ind := Workbook.Sheets( S ).Rows.Next( T_Row_Ind );
      END LOOP;
      Addtxt2utf8blob_Init( T_Yyy );
      Addtxt2utf8blob( '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:xdr="http://schemas.openxmlformats.org/drawingml/2006/spreadsheetDrawing" xmlns:x14="http://schemas.microsoft.com/office/spreadsheetml/2009/9/main" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac">' ||
CASE WHEN Workbook.Sheets( S ).Tabcolor IS NOT NULL THEN '<sheetPr><tabColor rgb="' || Workbook.Sheets( S ).Tabcolor || '"/></sheetPr>' END ||
'<dimension ref="' || Alfan_Col( T_Col_Min ) || Workbook.Sheets( S ).Rows.First() || ':' || Alfan_Col( T_Col_Max ) || Workbook.Sheets( S ).Rows.Last() || '"/>
<sheetViews>
<sheetView' || CASE WHEN S = 1 THEN ' tabSelected="1"' END || ' workbookViewId="0">'
                     , T_Yyy
                     );
      IF Workbook.Sheets( S ).Freeze_Rows > 0 AND Workbook.Sheets( S ).Freeze_Cols > 0
      THEN
        Addtxt2utf8blob( '<pane xSplit="' || Workbook.Sheets( S ).Freeze_Cols || '" '
                          || 'ySplit="' || Workbook.Sheets( S ).Freeze_Rows || '" '
                          || 'topLeftCell="' || Alfan_Col( Workbook.Sheets( S ).Freeze_Cols + 1 ) || ( Workbook.Sheets( S ).Freeze_Rows + 1 ) || '" '
                          || 'activePane="bottomLeft" state="frozen"/>'
                       , T_Yyy
                       );
      ELSE
        IF Workbook.Sheets( S ).Freeze_Rows > 0
        THEN
          Addtxt2utf8blob( '<pane ySplit="' || Workbook.Sheets( S ).Freeze_Rows || '" topLeftCell="A' || ( Workbook.Sheets( S ).Freeze_Rows + 1 ) || '" activePane="bottomLeft" state="frozen"/>'
                         , T_Yyy
                         );
        END IF;
        IF Workbook.Sheets( S ).Freeze_Cols > 0
        THEN
          Addtxt2utf8blob( '<pane xSplit="' || Workbook.Sheets( S ).Freeze_Cols || '" topLeftCell="' || Alfan_Col( Workbook.Sheets( S ).Freeze_Cols + 1 ) || '1" activePane="bottomLeft" state="frozen"/>'
                         , T_Yyy
                         );
        END IF;
      END IF;
      Addtxt2utf8blob( '</sheetView>
</sheetViews>
<sheetFormatPr defaultRowHeight="15" x14ac:dyDescent="0.25"/>'
                     , T_Yyy
                     );
      IF Workbook.Sheets( S ).Widths.Count() > 0
      THEN
        Addtxt2utf8blob( '<cols>', T_Yyy );
        T_Col_Ind := Workbook.Sheets( S ).Widths.First();
        WHILE T_Col_Ind IS NOT NULL
        LOOP
          Addtxt2utf8blob( '<col min="' || T_Col_Ind || '" max="' || T_Col_Ind || '" width="' || To_Char( Workbook.Sheets( S ).Widths( T_Col_Ind ), 'TM9', 'NLS_NUMERIC_CHARACTERS=.,' ) || '" customWidth="1"/>', T_Yyy );
          T_Col_Ind := Workbook.Sheets( S ).Widths.Next( T_Col_Ind );
        END LOOP;
        Addtxt2utf8blob( '</cols>', T_Yyy );
      END IF;
      Addtxt2utf8blob( '<sheetData>', T_Yyy );
      T_Row_Ind := Workbook.Sheets( S ).Rows.First();
      WHILE T_Row_Ind IS NOT NULL
      LOOP
        IF Workbook.Sheets( S ).Row_Fmts.EXISTS( T_Row_Ind ) AND Workbook.Sheets( S ).Row_Fmts( T_Row_Ind ).Height IS NOT NULL
        THEN
          Addtxt2utf8blob( '<row r="' || T_Row_Ind || '" spans="' || T_Col_Min || ':' || T_Col_Max || '" customHeight="1" ht="'
                         || To_Char( Workbook.Sheets( S ).Row_Fmts( T_Row_Ind ).Height, 'TM9', 'NLS_NUMERIC_CHARACTERS=.,' ) || '" >', T_Yyy );
        ELSE
          Addtxt2utf8blob( '<row r="' || T_Row_Ind || '" spans="' || T_Col_Min || ':' || T_Col_Max || '">', T_Yyy );
        END IF;
        T_Col_Ind := Workbook.Sheets( S ).Rows( T_Row_Ind ).First();
        WHILE T_Col_Ind IS NOT NULL
        LOOP
          Addtxt2utf8blob( '<c r="' || Alfan_Col( T_Col_Ind ) || T_Row_Ind || '"'
                 || ' ' || Workbook.Sheets( S ).Rows( T_Row_Ind )( T_Col_Ind ).Style
                 || '><v>'
                 || To_Char( Workbook.Sheets( S ).Rows( T_Row_Ind )( T_Col_Ind ).Value, 'TM9', 'NLS_NUMERIC_CHARACTERS=.,' )
                 || '</v></c>', T_Yyy );
          T_Col_Ind := Workbook.Sheets( S ).Rows( T_Row_Ind ).Next( T_Col_Ind );
        END LOOP;
        Addtxt2utf8blob( '</row>', T_Yyy );
        T_Row_Ind := Workbook.Sheets( S ).Rows.Next( T_Row_Ind );
      END LOOP;
      Addtxt2utf8blob( '</sheetData>', T_Yyy );
      FOR A IN 1 ..  Workbook.Sheets( S ).Autofilters.Count()
      LOOP
        Addtxt2utf8blob( '<autoFilter ref="' ||
            Alfan_Col( Nvl( Workbook.Sheets( S ).Autofilters( A ).Column_Start, T_Col_Min ) ) ||
            Nvl( Workbook.Sheets( S ).Autofilters( A ).Row_Start, Workbook.Sheets( S ).Rows.First() ) || ':' ||
            Alfan_Col( Coalesce( Workbook.Sheets( S ).Autofilters( A ).Column_End, Workbook.Sheets( S ).Autofilters( A ).Column_Start, T_Col_Max ) ) ||
            Nvl( Workbook.Sheets( S ).Autofilters( A ).Row_End, Workbook.Sheets( S ).Rows.Last() ) || '"/>', T_Yyy );
      END LOOP;
      IF Workbook.Sheets( S ).Mergecells.Count() > 0
      THEN
        Addtxt2utf8blob( '<mergeCells count="' || To_Char( Workbook.Sheets( S ).Mergecells.Count() ) || '">', T_Yyy );
        FOR M IN 1 ..  Workbook.Sheets( S ).Mergecells.Count()
        LOOP
          Addtxt2utf8blob( '<mergeCell ref="' || Workbook.Sheets( S ).Mergecells( M ) || '"/>', T_Yyy );
        END LOOP;
        Addtxt2utf8blob( '</mergeCells>', T_Yyy );
      END IF;
--
      IF Workbook.Sheets( S ).Validations.Count() > 0
      THEN
        Addtxt2utf8blob( '<dataValidations count="' || To_Char( Workbook.Sheets( S ).Validations.Count() ) || '">', T_Yyy );
        FOR M IN 1 ..  Workbook.Sheets( S ).Validations.Count()
        LOOP
          Addtxt2utf8blob( '<dataValidation' ||
              ' type="' || Workbook.Sheets( S ).Validations( M ).Type || '"' ||
              ' errorStyle="' || Workbook.Sheets( S ).Validations( M ).Errorstyle || '"' ||
              ' allowBlank="' || CASE WHEN Nvl( Workbook.Sheets( S ).Validations( M ).Allowblank, True ) THEN '1' ELSE '0' END || '"' ||
              ' sqref="' || Workbook.Sheets( S ).Validations( M ).Sqref || '"', T_Yyy );
          IF Workbook.Sheets( S ).Validations( M ).Prompt IS NOT NULL
          THEN
            Addtxt2utf8blob( ' showInputMessage="1" prompt="' || Workbook.Sheets( S ).Validations( M ).Prompt || '"', T_Yyy );
            IF Workbook.Sheets( S ).Validations( M ).Title IS NOT NULL
            THEN
              Addtxt2utf8blob( ' promptTitle="' || Workbook.Sheets( S ).Validations( M ).Title || '"', T_Yyy );
            END IF;
          END IF;
          IF Workbook.Sheets( S ).Validations( M ).Showerrormessage
          THEN
            Addtxt2utf8blob( ' showErrorMessage="1"', T_Yyy );
            IF Workbook.Sheets( S ).Validations( M ).Error_Title IS NOT NULL
            THEN
              Addtxt2utf8blob( ' errorTitle="' || Workbook.Sheets( S ).Validations( M ).Error_Title || '"', T_Yyy );
            END IF;
            IF Workbook.Sheets( S ).Validations( M ).Error_Txt IS NOT NULL
            THEN
              Addtxt2utf8blob( ' error="' || Workbook.Sheets( S ).Validations( M ).Error_Txt || '"', T_Yyy );
            END IF;
          END IF;
          Addtxt2utf8blob( '>', T_Yyy );
          IF Workbook.Sheets( S ).Validations( M ).Formula1 IS NOT NULL
          THEN
            Addtxt2utf8blob( '<formula1>' || Workbook.Sheets( S ).Validations( M ).Formula1 || '</formula1>', T_Yyy );
          END IF;
          IF Workbook.Sheets( S ).Validations( M ).Formula2 IS NOT NULL
          THEN
            Addtxt2utf8blob( '<formula2>' || Workbook.Sheets( S ).Validations( M ).Formula2 || '</formula2>', T_Yyy );
          END IF;
          Addtxt2utf8blob( '</dataValidation>', T_Yyy );
        END LOOP;
        Addtxt2utf8blob( '</dataValidations>', T_Yyy );
      END IF;
--
      IF Workbook.Sheets( S ).Hyperlinks.Count() > 0
      THEN
        Addtxt2utf8blob( '<hyperlinks>', T_Yyy );
        FOR H IN 1 ..  Workbook.Sheets( S ).Hyperlinks.Count()
        LOOP
          Addtxt2utf8blob( '<hyperlink ref="' || Workbook.Sheets( S ).Hyperlinks( H ).Cell || '" r:id="rId' || H || '"/>', T_Yyy );
        END LOOP;
        Addtxt2utf8blob( '</hyperlinks>', T_Yyy );
      END IF;
      Addtxt2utf8blob( '<pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/>', T_Yyy );
      IF Workbook.Sheets( S ).Comments.Count() > 0
      THEN
        Addtxt2utf8blob( '<legacyDrawing r:id="rId' || ( Workbook.Sheets( S ).Hyperlinks.Count() + 1 ) || '"/>', T_Yyy );
      END IF;
--
      Addtxt2utf8blob( '</worksheet>', T_Yyy );
      Addtxt2utf8blob_Finish( T_Yyy );
      Add1file( T_Excel, 'xl/worksheets/sheet' || S || '.xml', T_Yyy );
      IF Workbook.Sheets( S ).Hyperlinks.Count() > 0 OR Workbook.Sheets( S ).Comments.Count() > 0
      THEN
        T_Xxx := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">';
        IF Workbook.Sheets( S ).Comments.Count() > 0
        THEN
          T_Xxx := T_Xxx || ( '<Relationship Id="rId' || ( Workbook.Sheets( S ).Hyperlinks.Count() + 2 ) || '" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/comments" Target="../comments' || S || '.xml"/>' );
          T_Xxx := T_Xxx || ( '<Relationship Id="rId' || ( Workbook.Sheets( S ).Hyperlinks.Count() + 1 ) || '" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/vmlDrawing" Target="../drawings/vmlDrawing' || S || '.vml"/>' );
        END IF;
        FOR H IN 1 ..  Workbook.Sheets( S ).Hyperlinks.Count()
        LOOP
          T_Xxx := T_Xxx || ( '<Relationship Id="rId' || H || '" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink" Target="' || Workbook.Sheets( S ).Hyperlinks( H ).Url || '" TargetMode="External"/>' );
        END LOOP;
        T_Xxx := T_Xxx || '</Relationships>';
        Add1xml( T_Excel, 'xl/worksheets/_rels/sheet' || S || '.xml.rels', T_Xxx );
      END IF;
--
      IF Workbook.Sheets( S ).Comments.Count() > 0
      THEN
        DECLARE
          Cnt PLS_INTEGER;
          Author_Ind Tp_Author;
--          t_col_ind := workbook.sheets( s ).widths.next( t_col_ind );
        BEGIN
          Authors.DELETE();
          FOR C IN 1 .. Workbook.Sheets( S ).Comments.Count()
          LOOP
            Authors( Workbook.Sheets( S ).Comments( C ).Author ) := 0;
          END LOOP;
          T_Xxx := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<comments xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
<authors>';
          Cnt := 0;
          Author_Ind := Authors.First();
          WHILE Author_Ind IS NOT NULL OR Authors.Next( Author_Ind ) IS NOT NULL
          LOOP
            Authors( Author_Ind ) := Cnt;
            T_Xxx := T_Xxx || ( '<author>' || Author_Ind || '</author>' );
            Cnt := Cnt + 1;
            Author_Ind := Authors.Next( Author_Ind );
          END LOOP;
        END;
        T_Xxx := T_Xxx || '</authors><commentList>';
        FOR C IN 1 .. Workbook.Sheets( S ).Comments.Count()
        LOOP
          T_Xxx := T_Xxx || ( '<comment ref="' || Alfan_Col( Workbook.Sheets( S ).Comments( C ).Column ) ||
             To_Char( Workbook.Sheets( S ).Comments( C ).Row || '" authorId="' || Authors( Workbook.Sheets( S ).Comments( C ).Author ) ) || '">
<text>' );
          IF Workbook.Sheets( S ).Comments( C ).Author IS NOT NULL
          THEN
            T_Xxx := T_Xxx || ( '<r><rPr><b/><sz val="9"/><color indexed="81"/><rFont val="Tahoma"/><charset val="1"/></rPr><t xml:space="preserve">' ||
               Workbook.Sheets( S ).Comments( C ).Author || ':</t></r>' );
          END IF;
          T_Xxx := T_Xxx || ( '<r><rPr><sz val="9"/><color indexed="81"/><rFont val="Tahoma"/><charset val="1"/></rPr><t xml:space="preserve">' ||
             CASE WHEN Workbook.Sheets( S ).Comments( C ).Author IS NOT NULL THEN '
' END || Workbook.Sheets( S ).Comments( C ).Text || '</t></r></text></comment>' );
        END LOOP;
        T_Xxx := T_Xxx || '</commentList></comments>';
        Add1xml( T_Excel, 'xl/comments' || S || '.xml', T_Xxx );
        T_Xxx := '<xml xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel">
<o:shapelayout v:ext="edit"><o:idmap v:ext="edit" data="2"/></o:shapelayout>
<v:shapetype id="_x0000_t202" coordsize="21600,21600" o:spt="202" path="m,l,21600r21600,l21600,xe"><v:stroke joinstyle="miter"/><v:path gradientshapeok="t" o:connecttype="rect"/></v:shapetype>';
        FOR C IN 1 .. Workbook.Sheets( S ).Comments.Count()
        LOOP
          T_Xxx := T_Xxx || ( '<v:shape id="_x0000_s' || To_Char( C ) || '" type="#_x0000_t202"
style="position:absolute;margin-left:35.25pt;margin-top:3pt;z-index:' || To_Char( C ) || ';visibility:hidden;" fillcolor="#ffffe1" o:insetmode="auto">
<v:fill color2="#ffffe1"/><v:shadow on="t" color="black" obscured="t"/><v:path o:connecttype="none"/>
<v:textbox style="mso-direction-alt:auto"><div style="text-align:left"></div></v:textbox>
<x:ClientData ObjectType="Note"><x:MoveWithCells/><x:SizeWithCells/>' );
          T_W := Workbook.Sheets( S ).Comments( C ).Width;
          T_C := 1;
          LOOP
            IF Workbook.Sheets( S ).Widths.EXISTS( Workbook.Sheets( S ).Comments( C ).Column + T_C )
            THEN
              T_Cw := 256 * Workbook.Sheets( S ).Widths( Workbook.Sheets( S ).Comments( C ).Column + T_C );
              T_Cw := Trunc( ( T_Cw + 18 ) / 256 * 7); -- assume default 11 point Calibri
            ELSE
              T_Cw := 64;
            END IF;
            EXIT WHEN T_W < T_Cw;
            T_C := T_C + 1;
            T_W := T_W - T_Cw;
          END LOOP;
          T_H := Workbook.Sheets( S ).Comments( C ).Height;
          T_Xxx := T_Xxx || ( '<x:Anchor>' || Workbook.Sheets( S ).Comments( C ).Column || ',15,' ||
                     Workbook.Sheets( S ).Comments( C ).Row || ',30,' ||
                     ( Workbook.Sheets( S ).Comments( C ).Column + T_C - 1 ) || ',' || Round( T_W ) || ',' ||
                     ( Workbook.Sheets( S ).Comments( C ).Row + 1 + Trunc( T_H / 20 ) ) || ',' || MOD( T_H, 20 ) || '</x:Anchor>' );
          T_Xxx := T_Xxx || ( '<x:AutoFill>False</x:AutoFill><x:Row>' ||
            ( Workbook.Sheets( S ).Comments( C ).Row - 1 ) || '</x:Row><x:Column>' ||
            ( Workbook.Sheets( S ).Comments( C ).Column - 1 ) || '</x:Column></x:ClientData></v:shape>' );
        END LOOP;
        T_Xxx := T_Xxx || '</xml>';
        Add1xml( T_Excel, 'xl/drawings/vmlDrawing' || S || '.vml', T_Xxx );
      END IF;
--
      S := Workbook.Sheets.Next( S );
    END LOOP;
    T_Xxx := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/sharedStrings" Target="sharedStrings.xml"/>
<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
<Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme" Target="theme/theme1.xml"/>';
    S := Workbook.Sheets.First;
    WHILE S IS NOT NULL
    LOOP
      T_Xxx := T_Xxx || ( '
<Relationship Id="rId' || ( 9 + S ) || '" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet' || S || '.xml"/>' );
      S := Workbook.Sheets.Next( S );
    END LOOP;
    T_Xxx := T_Xxx || '</Relationships>';
    Add1xml( T_Excel, 'xl/_rels/workbook.xml.rels', T_Xxx );
    Addtxt2utf8blob_Init( T_Yyy );
    Addtxt2utf8blob( '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<sst xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" count="' || Workbook.Str_Cnt || '" uniqueCount="' || Workbook.Strings.Count() || '">'
                  , T_Yyy
                  );
    FOR I IN 0 .. Workbook.Str_Ind.Count() - 1
    LOOP
      Addtxt2utf8blob( '<si><t xml:space="preserve">' || Dbms_Xmlgen.Convert( Substr( Workbook.Str_Ind( I ), 1, 32000 ) ) || '</t></si>', T_Yyy );
    END LOOP;
    Addtxt2utf8blob( '</sst>', T_Yyy );
    Addtxt2utf8blob_Finish( T_Yyy );
    Add1file( T_Excel, 'xl/sharedStrings.xml', T_Yyy );
    Finish_Zip( T_Excel );
    Clear_Workbook;
    RETURN T_Excel;
  END;
--
  PROCEDURE Save
    ( P_Directory VARCHAR2
    , P_Filename VARCHAR2
    )
  IS
  BEGIN
    Blob2file( Finish, P_Directory, P_Filename );
  END;
--
  PROCEDURE Query2sheet
    ( P_Sql VARCHAR2
    , P_Column_Headers BOOLEAN := True
    , P_Directory VARCHAR2 := NULL
    , P_Filename VARCHAR2 := NULL
    , P_Sheet PLS_INTEGER := NULL
    , P_Usexf BOOLEAN := False
    )
  IS
    T_Sheet PLS_INTEGER;
    T_C INTEGER;
    T_Col_Cnt INTEGER;
    T_Desc_Tab Dbms_Sql.Desc_Tab2;
    D_Tab Dbms_Sql.Date_Table;
    N_Tab Dbms_Sql.Number_Table;
    V_Tab Dbms_Sql.Varchar2_Table;
    T_Bulk_Size PLS_INTEGER := 200;
    T_R INTEGER;
    T_Cur_Row PLS_INTEGER;
    T_Usexf BOOLEAN := G_Usexf;
  BEGIN
    Setusexf( P_Usexf );
    IF P_Sheet IS NULL
    THEN
      New_Sheet;
    END IF;
    T_C := Dbms_Sql.Open_Cursor;
    Dbms_Sql.Parse( T_C, P_Sql, Dbms_Sql.Native );
    Dbms_Sql.Describe_Columns2( T_C, T_Col_Cnt, T_Desc_Tab );
    FOR C IN 1 .. T_Col_Cnt
    LOOP
      IF P_Column_Headers
      THEN
        Cell( C, 1, T_Desc_Tab( C ).Col_Name, P_Sheet => T_Sheet );
      END IF;
      CASE
        WHEN T_Desc_Tab( C ).Col_Type IN ( 2, 100, 101 )
        THEN
          Dbms_Sql.Define_Array( T_C, C, N_Tab, T_Bulk_Size, 1 );
        WHEN T_Desc_Tab( C ).Col_Type IN ( 12, 178, 179, 180, 181 , 231 )
        THEN
          Dbms_Sql.Define_Array( T_C, C, D_Tab, T_Bulk_Size, 1 );
        WHEN T_Desc_Tab( C ).Col_Type IN ( 1, 8, 9, 96, 112 )
        THEN
          Dbms_Sql.Define_Array( T_C, C, V_Tab, T_Bulk_Size, 1 );
        ELSE
          NULL;
      END CASE;
    END LOOP;
--
    T_Cur_Row := CASE WHEN P_Column_Headers THEN 2 ELSE 1 END;
    T_Sheet := Nvl( P_Sheet, Workbook.Sheets.Count() );
--
    T_R := Dbms_Sql.Execute( T_C );
    LOOP
      T_R := Dbms_Sql.Fetch_Rows( T_C );
      IF T_R > 0
      THEN
        FOR C IN 1 .. T_Col_Cnt
        LOOP
          CASE
            WHEN T_Desc_Tab( C ).Col_Type IN ( 2, 100, 101 )
            THEN
              Dbms_Sql.Column_Value( T_C, C, N_Tab );
              FOR I IN 0 .. T_R - 1
              LOOP
                IF N_Tab( I + N_Tab.First() ) IS NOT NULL
                THEN
                  Cell( C, T_Cur_Row + I, N_Tab( I + N_Tab.First() ), P_Sheet => T_Sheet );
                END IF;
              END LOOP;
              N_Tab.DELETE;
            WHEN T_Desc_Tab( C ).Col_Type IN ( 12, 178, 179, 180, 181 , 231 )
            THEN
              Dbms_Sql.Column_Value( T_C, C, D_Tab );
              FOR I IN 0 .. T_R - 1
              LOOP
                IF D_Tab( I + D_Tab.First() ) IS NOT NULL
                THEN
                  Cell( C, T_Cur_Row + I, D_Tab( I + D_Tab.First() ), P_Sheet => T_Sheet );
                END IF;
              END LOOP;
              D_Tab.DELETE;
            WHEN T_Desc_Tab( C ).Col_Type IN ( 1, 8, 9, 96, 112 )
            THEN
              Dbms_Sql.Column_Value( T_C, C, V_Tab );
              FOR I IN 0 .. T_R - 1
              LOOP
                IF V_Tab( I + V_Tab.First() ) IS NOT NULL
                THEN
                  Cell( C, T_Cur_Row + I, V_Tab( I + V_Tab.First() ), P_Sheet => T_Sheet );
                END IF;
              END LOOP;
              V_Tab.DELETE;
            ELSE
              NULL;
          END CASE;
        END LOOP;
      END IF;
      EXIT WHEN T_R != T_Bulk_Size;
      T_Cur_Row := T_Cur_Row + T_R;
    END LOOP;
    Dbms_Sql.Close_Cursor( T_C );
    IF ( P_Directory IS NOT NULL AND  P_Filename IS NOT NULL )
    THEN
      Save( P_Directory, P_Filename );
    END IF;
    Setusexf( T_Usexf );
  EXCEPTION
    WHEN OTHERS
    THEN
      IF Dbms_Sql.Is_Open( T_C )
      THEN
        Dbms_Sql.Close_Cursor( T_C );
      END IF;
      Setusexf( T_Usexf );
  END;
--
  PROCEDURE Setusexf( P_Val BOOLEAN := True )
  IS
  BEGIN
    G_Usexf := P_Val;
  END;
--
END GNKG_AS_XLSX;
/