/**
 * se debe ejecutar en DB_COMUNICACION 
 * Plantilla Correo Resumen Compra
 *Plantilla que se envia al cliente
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 06-06-2022 - Versión Inicial.
 */
SET SERVEROUTPUT ON;
DECLARE
    bada clob:='<!DOCTYPE html>';
BEGIN
DBMS_LOB.APPEND(bada, '<html style="margin:0;padding:0" data-lt-installed="true" lang="en"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><meta http-equiv="X-UA-Compatible" content="IE=edge"><meta name="format-detection" content="telephone=no"><title>Asunto</title><style type="text/css"> @media screen and (max-width: 480px) {
            .mailpoet_button {width:100% !important;}
        }
 @media screen and (max-width: 599px) {
            .mailpoet_header {
                padding: 10px 20px;
            }
            .mailpoet_button {
                width: 100% !important;
                padding: 5px 0 !important;
                box-sizing:border-box !important;
            }
            div, .mailpoet_cols-two, .mailpoet_cols-three {
                max-width: 100% !important;
            }
        }
</style><style>/* cyrillic-ext */
@font-face {
  font-family:  ''Montserrat'';
  font-style: normal;
  font-weight: 500;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/montserrat/v24/JTUHjIg1_i6t8kCHKm4532VJOt5-QNFgpCtZ6Hw0aXpsog.woff2) format( ''woff2'');
  unicode-range: U+0460-052F, U+1C80-1C88, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family:  ''Montserrat'';
  font-style: normal;
  font-weight: 500;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/montserrat/v24/JTUHjIg1_i6t8kCHKm4532VJOt5-QNFgpCtZ6Hw9aXpsog.woff2) format( ''woff2'');
  unicode-range: U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* vietnamese */
@font-face {
  font-family: ''Montserrat'';
  font-style: normal;
  font-weight: 500;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/montserrat/v24/JTUHjIg1_i6t8kCHKm4532VJOt5-QNFgpCtZ6Hw2aXpsog.woff2) format( ''woff2'');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family:  ''Montserrat'';
  font-style: normal;
  font-weight: 500;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/montserrat/v24/JTUHjIg1_i6t8kCHKm4532VJOt5-QNFgpCtZ6Hw3aXpsog.woff2) format( ''woff2'');
  unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family:  ''Montserrat'';
  font-style: normal;
  font-weight: 500;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/montserrat/v24/JTUHjIg1_i6t8kCHKm4532VJOt5-QNFgpCtZ6Hw5aXo.woff2) format( ''woff2'');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family:  ''Montserrat'';
  font-style: normal;
  font-weight: 600;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/montserrat/v24/JTUHjIg1_i6t8kCHKm4532VJOt5-QNFgpCu173w0aXpsog.woff2) format( ''woff2'');
  unicode-range: U+0460-052F, U+1C80-1C88, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family:  ''Montserrat'';
  font-style: normal;
  font-weight: 600;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/montserrat/v24/JTUHjIg1_i6t8kCHKm4532VJOt5-QNFgpCu173w9aXpsog.woff2) format( ''woff2'');
  unicode-range: U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* vietnamese */
@font-face {
  font-family:  ''Montserrat'';
  font-style: normal;
  font-weight: 600;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/montserrat/v24/JTUHjIg1_i6t8kCHKm4532VJOt5-QNFgpCu173w2aXpsog.woff2) format( ''woff2'');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family:  ''Montserrat'';
  font-style: normal;
  font-weight: 600;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/montserrat/v24/JTUHjIg1_i6t8kCHKm4532VJOt5-QNFgpCu173w3aXpsog.woff2) format( ''woff2'');
  unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family:  ''Montserrat'';
  font-style: normal;
  font-weight: 600;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/montserrat/v24/JTUHjIg1_i6t8kCHKm4532VJOt5-QNFgpCu173w5aXo.woff2) format( ''woff2'');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family:  ''Montserrat'';
  font-style: normal;
  font-weight: 700;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/montserrat/v24/JTUHjIg1_i6t8kCHKm4532VJOt5-QNFgpCuM73w0aXpsog.woff2) format( ''woff2'');
  unicode-range: U+0460-052F, U+1C80-1C88, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family:  ''Montserrat'';
  font-style: normal;
  font-weight: 700;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/montserrat/v24/JTUHjIg1_i6t8kCHKm4532VJOt5-QNFgpCuM73w9aXpsog.woff2) format( ''woff2'');
  unicode-range: U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* vietnamese */
@font-face {
  font-family:  ''Montserrat'';
  font-style: normal;
  font-weight: 700;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/montserrat/v24/JTUHjIg1_i6t8kCHKm4532VJOt5-QNFgpCuM73w2aXpsog.woff2) format( ''woff2'');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family:  ''Montserrat'';
  font-style: normal;
  font-weight: 700;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/montserrat/v24/JTUHjIg1_i6t8kCHKm4532VJOt5-QNFgpCuM73w3aXpsog.woff2) format( ''woff2'');
  unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family:  ''Montserrat'';
  font-style: normal;
  font-weight: 700;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/montserrat/v24/JTUHjIg1_i6t8kCHKm4532VJOt5-QNFgpCuM73w5aXo.woff2) format( ''woff2'');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family:  ''Roboto'';
  font-style: normal;
  font-weight: 400;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/roboto/v30/KFOmCnqEu92Fr1Mu72xKOzY.woff2) format( ''woff2'');
  unicode-range: U+0460-052F, U+1C80-1C88, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family:  ''Roboto'';
  font-style: normal;
  font-weight: 400;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/roboto/v30/KFOmCnqEu92Fr1Mu5mxKOzY.woff2) format( ''woff2'');
  unicode-range: U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family:  ''Roboto'';
  font-style: normal;
  font-weight: 400;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/roboto/v30/KFOmCnqEu92Fr1Mu7mxKOzY.woff2) format( ''woff2'');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family:  ''Roboto'';
  font-style: normal;
  font-weight: 400;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/roboto/v30/KFOmCnqEu92Fr1Mu4WxKOzY.woff2) format( ''woff2'');
  unicode-range: U+0370-03FF;
}
/* vietnamese */
@font-face {
  font-family:  ''Roboto'';
  font-style: normal;
  font-weight: 400;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/roboto/v30/KFOmCnqEu92Fr1Mu7WxKOzY.woff2) format( ''woff2'');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family:  ''Roboto'';
  font-style: normal;
  font-weight: 400;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/roboto/v30/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format( ''woff2'');
  unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family:  ''Roboto'';
  font-style: normal;
  font-weight: 400;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/roboto/v30/KFOmCnqEu92Fr1Mu4mxK.woff2) format( ''woff2'');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family:  ''Roboto'';
  font-style: normal;
  font-weight: 500;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/roboto/v30/KFOlCnqEu92Fr1MmEU9fCRc4EsA.woff2) format( ''woff2'');
  unicode-range: U+0460-052F, U+1C80-1C88, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family:  ''Roboto'';
  font-style: normal;
  font-weight: 500;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/roboto/v30/KFOlCnqEu92Fr1MmEU9fABc4EsA.woff2) format( ''woff2'');
  unicode-range: U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family:  ''Roboto'';
  font-style: normal;
  font-weight: 500;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/roboto/v30/KFOlCnqEu92Fr1MmEU9fCBc4EsA.woff2) format( ''woff2'');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family:  ''Roboto'';
  font-style: normal;
  font-weight: 500;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/roboto/v30/KFOlCnqEu92Fr1MmEU9fBxc4EsA.woff2) format( ''woff2'');
  unicode-range: U+0370-03FF;
}
/* vietnamese */
@font-face {
  font-family:  ''Roboto'';
  font-style: normal;
  font-weight: 500;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/roboto/v30/KFOlCnqEu92Fr1MmEU9fCxc4EsA.woff2) format( ''woff2'');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family:  ''Roboto'';
  font-style: normal;
  font-weight: 500;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/roboto/v30/KFOlCnqEu92Fr1MmEU9fChc4EsA.woff2) format( ''woff2'');
  unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family:  ''Roboto'';
  font-style: normal;
  font-weight: 500;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/roboto/v30/KFOlCnqEu92Fr1MmEU9fBBc4.woff2) format( ''woff2'');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family:  ''Roboto'';
  font-style: normal;
  font-weight: 700;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/roboto/v30/KFOlCnqEu92Fr1MmWUlfCRc4EsA.woff2) format( ''woff2'');
  unicode-range: U+0460-052F, U+1C80-1C88, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family:  ''Roboto'';
  font-style: normal;
  font-weight: 700;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/roboto/v30/KFOlCnqEu92Fr1MmWUlfABc4EsA.woff2) format( ''woff2'');
  unicode-range: U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family:  ''Roboto'';
  font-style: normal;
  font-weight: 700;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/roboto/v30/KFOlCnqEu92Fr1MmWUlfCBc4EsA.woff2) format( ''woff2'');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family:  ''Roboto'';
  font-style: normal;
  font-weight: 700;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/roboto/v30/KFOlCnqEu92Fr1MmWUlfBxc4EsA.woff2) format( ''woff2'');
  unicode-range: U+0370-03FF;
}
/* vietnamese */
@font-face {
  font-family:  ''Roboto'';
  font-style: normal;
  font-weight: 700;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/roboto/v30/KFOlCnqEu92Fr1MmWUlfCxc4EsA.woff2) format( ''woff2'');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family:  ''Roboto'';
  font-style: normal;
  font-weight: 700;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/roboto/v30/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format( ''woff2'');
  unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family:  ''Roboto'';
  font-style: normal;
  font-weight: 700;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/roboto/v30/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format( ''woff2'');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
</style></head><body style="margin:0;padding:0;background-color:#f2f2f2" topmargin="0" marginwidth="0" marginheight="0" leftmargin="0"><span id="warning-container"><i data-reactroot=""></i></span>
    <table class="mailpoet_template" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellspacing="0" cellpadding="0" border="0"><tbody><tr><td class="mailpoet_preheader" style="border-collapse:collapse;display:none;visibility:hidden;mso-hide:all;font-size:1px;color:#333333;line-height:1px;max-height:0;max-width:0;opacity:0;overflow:hidden;-webkit-text-size-adjust:none" height="1">

            </td>
        </tr><tr><td class="mailpoet-wrapper" style="border-collapse:collapse;background-color:#f2f2f2" valign="top" align="center"><!--[if mso]>
                <table align="center" border="0" cellspacing="0" cellpadding="0"
                       width="660">
                    <tr>
                        <td class="mailpoet_content-wrapper" align="center" valign="top" width="660">
                <![endif]--><table class="mailpoet_content-wrapper" style="border-collapse:collapse;background-color:#ffffff;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;max-width:660px;width:100%" width="660" cellspacing="0" cellpadding="0" border="0"><tbody><tr><td class="mailpoet_content" style="border-collapse:collapse;background-color:#ffffff!important" bgcolor="#ffffff" align="center">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellspacing="0" cellpadding="0" border="0"><tbody><tr><td style="border-collapse:collapse;padding-left:0;padding-right:0">
                  <table class="mailpoet_cols-one" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0" width="100%" cellspacing="0" cellpadding="0" border="0"><tbody><tr><td class="mailpoet_spacer" style="border-collapse:collapse" valign="top" height="20" bgcolor="#f2f2f2"></td>
      </tr><tr><td class="mailpoet_image " style="border-collapse:collapse" valign="top" align="center">
          <img src="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVw4MzEyOCR0PzAsMiRrZj8yMzgyMyRxa2VsY3Z3cGc/N2M1MzM7OzRnYTtjM2cwMWE1N2RjYWZkMzpgZDI6YTo2MWY7MWBhNSR2PzM0NzYwOjI2MTEkc2tmPzA3MUtJWjdoMjM3NjY2LzA3MUtJWjduMjM3NjY2JHBhcnY/JGE/NzAkamZuPzI='||chr(38)||'url=https%3a%2f%2fcdnnetlife.konibit.com.mx%2fPROD_ENV%2fimagenes%2fmailing%2fNETLIFEBANNERTODOS.jpg'||chr(38)||'fmlBlkTk" alt="Netlife - Somos mas que internet" style="height:auto;max-width:100%;-ms-interpolation-mode:bicubic;border:0;display:block;outline:none;text-align:center" width="660"></img></td>
      </tr></tbody></table></td>
              </tr></tbody></table></td>
      </tr><tr><td class="mailpoet_content" style="border-collapse:collapse;background-color:#ffffff!important" bgcolor="#ffffff" align="center">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellspacing="0" cellpadding="0" border="0"><tbody><tr><td style="border-collapse:collapse;padding-left:0;padding-right:0">
                  <table class="mailpoet_cols-one" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0" width="100%" cellspacing="0" cellpadding="0" border="0"><tbody><tr><td class="mailpoet_spacer" style="border-collapse:collapse" valign="top" height="25"></td>
      </tr></tbody></table></td>
              </tr></tbody></table></td>
      </tr><tr><td class="mailpoet_content" style="border-collapse:collapse" align="center">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellspacing="0" cellpadding="0" border="0"><tbody><tr><td style="border-collapse:collapse;padding-left:0;padding-right:0">
                  <table class="mailpoet_cols-one" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0" width="100%" cellspacing="0" cellpadding="0" border="0"><tbody><tr><td class="mailpoet_text mailpoet_padded_vertical mailpoet_padded_side" style="border-collapse:collapse;padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px;word-break:break-word;word-wrap:break-word" valign="top">
          <h2 style="margin:0 0 7.2px;mso-ansi-font-size:24px;color:#ff6600;font-family:Arial,&#39;Helvetica Neue&#39;,Helvetica,sans-serif;font-size:24px;line-height:38.4px;mso-line-height-alt:38px;margin-bottom:0;text-align:center;padding:0;font-style:normal;font-weight:normal"><span style="color: #34495e;"><strong>Hola, {{nombreCliente}} </strong></span></h2>
        </td>
      </tr><tr><td class="mailpoet_text mailpoet_padded_vertical mailpoet_padded_side" style="border-collapse:collapse;padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px;word-break:break-word;word-wrap:break-word" valign="top">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellpadding="0"><tbody><tr><td class="mailpoet_paragraph" style="border-collapse:collapse;mso-ansi-font-size:14px;color:#000000;font-family:Arial,&#39;Helvetica Neue&#39;,Helvetica,sans-serif;font-size:18px;line-height:22.4px;mso-line-height-alt:22px;word-break:break-word;word-wrap:break-word;text-align:center">
            <strong>Gracias por ser parte de<span style="color: #e67e23;"> Netlife.</span><br></strong>
          </td>
        </tr></tbody></table></td>
      </tr><tr><td class="mailpoet_divider" style="border-collapse:collapse;padding:13px 20px 13px 20px" valign="top">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellspacing="0" cellpadding="0" border="0"><tbody><tr><td class="mailpoet_divider-cell" style="border-collapse:collapse;border-top-width:1px;border-top-style:solid;border-top-color:#aaaaaa">
             </td>
            </tr></tbody></table></td>
      </tr><tr><td class="mailpoet_text mailpoet_padded_vertical mailpoet_padded_side" style="border-collapse:collapse;padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px;word-break:break-word;word-wrap:break-word" valign="top">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellpadding="0"><tbody><tr><td class="mailpoet_paragraph" style="border-collapse:collapse;mso-ansi-font-size:14px;color:#000000;font-family:Arial,&#39;Helvetica Neue&#39;,Helvetica,sans-serif;font-size:14px;line-height:22.4px;mso-line-height-alt:22px;word-break:break-word;word-wrap:break-word;text-align:center">
            <span style="color: #e67e23;"><span style="color: #000000; font-size: 14px; line-height: 20px;">Te informamos que en la fecha: {{fechaServicio}} realizaste la contratación del servicio {{nombreProducto}}, por un precio {{frecuencia}} de  {{totalServicio}}  + IVA mediante nuestro canal {{canalServicio}} <br></span></span>
          </td>
        </tr></tbody></table></td>
');
DBMS_LOB.APPEND(bada,'
      </tr></tbody></table></td>
              </tr></tbody></table></td>
      </tr><tr><td class="mailpoet_content-cols-three" style="border-collapse:collapse" align="left">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellspacing="0" cellpadding="0" border="0"><tbody><tr><td style="border-collapse:collapse;font-size:0" align="center"><!--[if mso]>
                  <table border="0" width="100%" cellpadding="0" cellspacing="0">
                    <tbody>
                      <tr>
      <td width="220" valign="top">
        <![endif]--><div style="display:inline-block; max-width:220px; vertical-align:top; width:100%;">
          <table class="mailpoet_cols-three" style="border-collapse:collapse;width:100%;max-width:50px;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0" width="220" cellspacing="0" cellpadding="0" border="0" align="right"><tbody></tbody></table></div><!--[if mso]>
      </td>
      <td width="220" valign="top">
        <![endif]--><div style="display:inline-block; max-width:450px; vertical-align:top; width:100%;background-color: #eaeae8;">
          <table class="mailpoet_cols-three" style="border-collapse:collapse;width:100%;max-width:450px;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0" width="220" cellspacing="0" cellpadding="0" border="0" align="right"><tbody><tr><td class="mailpoet_text mailpoet_padded_vertical mailpoet_padded_side" style="border-collapse:collapse;padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px;word-break:break-word;word-wrap:break-word;text-align: center;" valign="top">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;text-align: center;" width="100%" cellpadding="0"><tbody><tr><td class="mailpoet_paragraph" style="border-collapse:collapse;mso-ansi-font-size:14px;color:#000000;font-family:Arial,&#39;Helvetica Neue&#39;,Helvetica,sans-serif;font-size:14px;line-height:22.4px;mso-line-height-alt:22px;word-break:break-word;word-wrap:break-word;text-align:center;">
            <strong>Dirección de contratación: </strong> {{direccion}}<br><strong>Forma de Pago:</strong>  {{formaPago}} 
          </td>
        </tr></tbody></table><table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellpadding="0"><tbody><tr><td class="mailpoet_paragraph" style="border-collapse:collapse;mso-ansi-font-size:14px;color:#000000;font-family:Arial,&#39;Helvetica Neue&#39;,Helvetica,sans-serif;font-size:14px;line-height:22.4px;mso-line-height-alt:22px;word-break:break-word;word-wrap:break-word;text-align:center;">
            <strong>Permanencia mínima de contratación: </strong> {{nombreProducto}} leer términos y condiciones del adendum del servicio adjunto.
          </td>
        </tr></tbody></table><table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellpadding="0"><tbody><tr><td class="mailpoet_paragraph" style="border-collapse:collapse;mso-ansi-font-size:14px;color:#000000;font-family:Arial,&#39;Helvetica Neue&#39;,Helvetica,sans-serif;font-size:14px;line-height:22.4px;mso-line-height-alt:22px;word-break:break-word;word-wrap:break-word;text-align:center;">
            <strong>Promoción: </strong> {{Promocion}}<br><br></td>
        </tr></tbody></table></td>
      </tr></tbody></table></div><!--[if mso]>
      </td>
      <td width="220" valign="top">
        <![endif]--><div style="display:inline-block; max-width:220px; vertical-align:top; width:100%;">
          <table class="mailpoet_cols-three" style="border-collapse:collapse;width:100%;max-width:220px;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0" width="220" cellspacing="0" cellpadding="0" border="0" align="right"><tbody></tbody></table></div><!--[if mso]>
      </td>
                  </tr>
                </tbody>
              </table>
            <![endif]--></td>
            </tr></tbody></table></td>
    </tr><tr><td class="mailpoet_content" style="border-collapse:collapse" align="center">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellspacing="0" cellpadding="0" border="0"><tbody><tr><td style="border-collapse:collapse;padding-left:0;padding-right:0">
                  <table class="mailpoet_cols-one" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0" width="100%" cellspacing="0" cellpadding="0" border="0"><tbody><tr><td class="mailpoet_text mailpoet_padded_vertical mailpoet_padded_side" style="border-collapse:collapse;padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px;word-break:break-word;word-wrap:break-word" valign="top">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellpadding="0">
          <tbody>
          <tr>
          <td class="mailpoet_paragraph" style="border-collapse:collapse;mso-ansi-font-size:14px;color:#000000;font-family:Arial,&#39;Helvetica Neue&#39;,Helvetica,sans-serif;font-size:14px;line-height:22.4px;mso-line-height-alt:22px;word-break:break-word;word-wrap:break-word;text-align:center">
            
          </td>
        </tr>
        </tbody>
        </table>
        </td>
      </tr></tbody></table></td>
              </tr></tbody></table></td>
      </tr><tr><td class="mailpoet_content" style="border-collapse:collapse" align="center">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellspacing="0" cellpadding="0" border="0"><tbody><tr><td style="border-collapse:collapse;padding-left:0;padding-right:0">
                  <table class="mailpoet_cols-one" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0" width="100%" cellspacing="0" cellpadding="0" border="0"><tbody><tr><td class="mailpoet_text mailpoet_padded_vertical mailpoet_padded_side" style="border-collapse:collapse;padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px;word-break:break-word;word-wrap:break-word" valign="top">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellpadding="0"><tbody><tr><td class="mailpoet_paragraph" style="border-collapse:collapse;mso-ansi-font-size:14px;color:#000000;font-family:Arial,&#39;Helvetica Neue&#39;,Helvetica,sans-serif;font-size:14px;line-height:22.4px;mso-line-height-alt:22px;word-break:break-word;word-wrap:break-word;text-align:center">
            <strong>A continuación puedes revisar nuestros términos y condiciones, además de nuestra política de privacidad:</strong>
          </td>
        </tr></tbody></table></td>
      </tr></tbody></table></td>
              </tr></tbody></table></td>
      </tr><tr><td class="mailpoet_content-cols-two" style="border-collapse:collapse" align="left">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellspacing="0" cellpadding="0" border="0"><tbody><tr><td style="border-collapse:collapse;font-size:0" align="center"><!--[if mso]>
                  <table border="0" width="100%" cellpadding="0" cellspacing="0">
                    <tbody>
                      <tr>
      <td width="330" valign="top">
        <![endif]--><div style="display:inline-block; max-width:330px; vertical-align:top; width:100%;">
          <table class="mailpoet_cols-two" style="border-collapse:collapse;width:100%;max-width:330px;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0" width="330" cellspacing="0" cellpadding="0" border="0" align="left"><tbody><tr><td class="mailpoet_text mailpoet_padded_vertical mailpoet_padded_side" style="border-collapse:collapse;padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px;word-break:break-word;word-wrap:break-word" valign="top">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellpadding="0"><tbody><tr><td class="mailpoet_paragraph" style="border-collapse:collapse;mso-ansi-font-size:14px;color:#FFFF;font-family:Arial,&#39;Helvetica Neue&#39;,Helvetica,sans-serif;font-size:14px;line-height:22.4px;mso-line-height-alt:22px;word-break:break-word;word-wrap:break-word;text-align:center;background-color: #000;">
            <strong style="font-size: 14px;">Términos y Condiciones<span style="color: #ef7a1c; font-size: 14px;"> <br>Revisar documento adjunto<br><br></span></strong>
          </td>
        </tr></tbody></table></td>
      </tr></tbody></table></div><!--[if mso]>
      </td>
      <td width="330" valign="top">
        <![endif]--><div style="display:inline-block; max-width:330px; vertical-align:top; width:100%;">
          <table class="mailpoet_cols-two" style="border-collapse:collapse;width:100%;max-width:330px;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0" width="330" cellspacing="0" cellpadding="0" border="0" align="left"><tbody><tr><td class="mailpoet_text mailpoet_padded_vertical mailpoet_padded_side" style="border-collapse:collapse;padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px;word-break:break-word;word-wrap:break-word" valign="top">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellpadding="0"><tbody><tr><td class="mailpoet_paragraph" style="border-collapse:collapse;mso-ansi-font-size:14px;color:#FFFFFF;font-family:Arial,&#39;Helvetica Neue&#39;,Helvetica,sans-serif;font-size:14px;line-height:22.4px;mso-line-height-alt:22px;word-break:break-word;word-wrap:break-word;text-align:center;background-color: #000000;">
            <strong style="font-size: 14px;">Política de Privacidad<br><span style="color: #ef7a1c; font-size: 14px;">https://www.netlife.ec/politica-privacidad/<br><br></span></strong>
          </td>

        </tr></tbody></table></td>
      </tr></tbody></table></div><!--[if mso]>
      </td>
                  </tr>
                </tbody>
              </table>
            <![endif]--></td>
            </tr></tbody></table></td>
    </tr><tr><td class="mailpoet_content" style="border-collapse:collapse" align="center">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellspacing="0" cellpadding="0" border="0"><tbody><tr><td style="border-collapse:collapse;padding-left:0;padding-right:0">
                  <table class="mailpoet_cols-one" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0" width="100%" cellspacing="0" cellpadding="0" border="0"><tbody><tr><td class="mailpoet_image " style="border-collapse:collapse" valign="top" align="center">
          <img src="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVw4MzEyOCR0PzAsMiRrZj8yMzgyMyRxa2VsY3Z3cGc/MDs2YDExOmBnMDM0MDY6NWMyNWYwMGA1NWRjNGY3MWM0M2dkOmM2OyR2PzM0NzYwOjI2MTEkc2tmPzA3MUtJWjdoMjM3NjY2LzA3MUtJWjduMjM3NjY2JHBhcnY/JGE/NzAkamZuPzI='||chr(38)||'url=http%3a%2f%2fwww.netlife.ec%2fwp-content%2fuploads%2f2022%2f06%2fara-y-access.jpg'||chr(38)||'fmlBlkTk" alt="Acces y Ara" style="height:auto;max-width:100%;-ms-interpolation-mode:bicubic;border:0;display:block;outline:none;text-align:center" width="660"></img></td>
      </tr></tbody></table></td>
              </tr></tbody></table></td>
      </tr><tr><td class="mailpoet_content" style="border-collapse:collapse" align="center">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellspacing="0" cellpadding="0" border="0"><tbody><tr><td style="border-collapse:collapse;padding-left:0;padding-right:0">
                  <table class="mailpoet_cols-one" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0" width="100%" cellspacing="0" cellpadding="0" border="0"><tbody><tr><td class="mailpoet_spacer" style="border-collapse:collapse" valign="top" height="40" bgcolor="#f2f2f2"></td>
      </tr></tbody></table></td>
              </tr></tbody></table></td>
      </tr><tr><td class="mailpoet_content" style="border-collapse:collapse" align="center">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellspacing="0" cellpadding="0" border="0"><tbody><tr><td style="border-collapse:collapse;padding-left:0;padding-right:0">
                  <table class="mailpoet_cols-one" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0" width="100%" cellspacing="0" cellpadding="0" border="0"><tbody><tr><td class="mailpoet_spacer" style="border-collapse:collapse" valign="top" height="40" bgcolor="#f2f2f2"></td>
      </tr></tbody></table></td>
              </tr></tbody></table></td>
      </tr></tbody></table><!--[if mso]>
                </td>
                </tr>
                </table>
                <![endif]--></td>
        </tr></tbody></table><div id="wot-new-assistant-container"><div data-reactroot=""></div></div></body></html>');
INSERT INTO DB_COMUNICACION.ADMI_PLANTILLA
VALUES(DB_COMUNICACION.SEQ_ADMI_PLANTILLA.nextval,'Correo Resumen Compra','CRESUCOMPRA','COMERCIAL',bada,'Activo',sysdate,'jbroncano','','','18');

COMMIT;
END;
/
