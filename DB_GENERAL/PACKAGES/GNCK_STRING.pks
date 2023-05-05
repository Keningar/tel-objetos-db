CREATE EDITIONABLE PACKAGE            GNCK_STRING AS
    /**
    * Encripta un string
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.0 20-10-2018
    **/
    FUNCTION ENCRYPT_STR (
        F_Text IN   VARCHAR2
    ) RETURN RAW;

    /**
    * Desencripta un string
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.0 20-10-2018
    **/

    FUNCTION DECRYPT_STR (
        P_Raw IN   RAW
    ) RETURN VARCHAR2;

END GNCK_STRING;
/

CREATE EDITIONABLE PACKAGE BODY            GNCK_STRING AS

    Lv_Key   RAW(255) := UTL_RAW.CAST_TO_RAW('TOKEN_ENCRYPT');

    FUNCTION ENCRYPT_STR (
        F_Text IN   VARCHAR2
    ) RETURN RAW AS
        Lv_Text      VARCHAR2(32767) := F_Text;
        Lv_RawText   RAW(32767);
    BEGIN
        Lv_Text := RPAD(Lv_Text,(TRUNC(LENGTH(Lv_Text) / 8) + 1) * 8, CHR(0));

        DBMS_OBFUSCATION_TOOLKIT.DESENCRYPT(INPUT => UTL_RAW.cast_to_raw(Lv_Text), KEY => Lv_Key, ENCRYPTED_DATA => Lv_RawText);

        RETURN Lv_RawText;
    END ENCRYPT_STR;

    FUNCTION DECRYPT_STR (
        P_Raw IN   RAW
    ) RETURN VARCHAR2 AS
        Lv_Decrypted         VARCHAR2(32767);
        Lv_ResultDecrypted   VARCHAR2(32767);
    BEGIN
        DBMS_OBFUSCATION_TOOLKIT.DESDECRYPT(INPUT => P_Raw, KEY => Lv_Key, DECRYPTED_DATA => Lv_Decrypted);

        Lv_ResultDecrypted := UTL_RAW.CAST_TO_VARCHAR2(Lv_Decrypted);
        RETURN RTRIM(Lv_ResultDecrypted, CHR(0));
    END DECRYPT_STR;

END GNCK_STRING;
/