CREATE OR REPLACE FUNCTION DB_SOPORTE.GET_AFECTADO_POR_CASO (
   Pn_IdCaso IN INFO_CASO.ID_CASO%TYPE)
   RETURN VARCHAR2
IS
   ---
   limit_in                 PLS_INTEGER := 5000;

   CURSOR C_GetAfectados (
      Cn_IdCaso INFO_CASO.ID_CASO%TYPE)
   IS
      SELECT D.AFECTADO_ID, D.TIPO_AFECTADO
        FROM INFO_CASO A,
             INFO_DETALLE_HIPOTESIS B,
             INFO_DETALLE C,
             INFO_PARTE_AFECTADA D
       WHERE     A.ID_CASO = B.CASO_ID
             AND B.ID_DETALLE_HIPOTESIS = C.DETALLE_HIPOTESIS_ID
             AND C.ID_DETALLE = D.DETALLE_ID
             AND A.ID_CASO = Cn_IdCaso;

   ---
   --
   CURSOR C_GetServicioId (
      Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE)
   IS
      SELECT ISR.ID_SERVICIO
        FROM INFO_SERVICIO ISR,
             INFO_SERVICIO_TECNICO SRT,
             ADMI_TIPO_MEDIO TM,
             INFO_PLAN_CAB IPC,
             INFO_PLAN_DET IPD,
             ADMI_PRODUCTO AP
       WHERE     ISR.PLAN_ID = IPC.ID_PLAN
             AND IPC.ID_PLAN = IPD.PLAN_ID
             AND IPD.PRODUCTO_ID = AP.ID_PRODUCTO
             AND AP.NOMBRE_TECNICO = 'INTERNET'
             AND ISR.ESTADO = 'Activo'
             AND ISR.PUNTO_ID = Cn_IdPunto
             AND ISR.ID_SERVICIO = SRT.SERVICIO_ID
             AND SRT.ULTIMA_MILLA_ID = TM.ID_TIPO_MEDIO;

   --
   CURSOR C_GetProductoServicioId (
      Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE)
   IS
      SELECT ISR.ID_SERVICIO
        FROM INFO_SERVICIO ISR,
             INFO_SERVICIO_TECNICO SRT,
             ADMI_TIPO_MEDIO TM,
             ADMI_PRODUCTO AP
       WHERE     ISR.PRODUCTO_ID = AP.ID_PRODUCTO
             AND AP.NOMBRE_TECNICO = 'INTERNET'
             AND AP.ESTADO = 'Activo'
             AND ISR.PUNTO_ID = Cn_IdPunto
             AND ISR.ID_SERVICIO = SRT.SERVICIO_ID
             AND SRT.ULTIMA_MILLA_ID = TM.ID_TIPO_MEDIO;

   --

   CURSOR C_GetElementoUltimaMilla (
      Cn_IdElemento    INFO_ELEMENTO.ID_ELEMENTO%TYPE,
      Cn_IdServicio    INFO_SERVICIO.ID_SERVICIO%TYPE)
   IS
      SELECT    NVL (C.NOMBRE_TIPO_ELEMENTO, 'TIPO ELEMENTO')
             || ':'
             || NVL (C.ID_TIPO_ELEMENTO, 0)
             || ':'
             || NVL (A.NOMBRE_ELEMENTO, 'ELEMENTO')
             || ':'
             || NVL (A.ID_ELEMENTO, 0)
        FROM INFO_ELEMENTO A, ADMI_MODELO_ELEMENTO B, ADMI_TIPO_ELEMENTO C
       WHERE     A.MODELO_ELEMENTO_ID = B.ID_MODELO_ELEMENTO
             AND B.TIPO_ELEMENTO_ID = C.ID_TIPO_ELEMENTO
             AND A.ID_ELEMENTO = NVL (Cn_IdElemento,
                                      (SELECT ELEMENTO_CLIENTE_ID
                                         FROM INFO_SERVICIO_TECNICO
                                        WHERE SERVICIO_ID = Cn_IdServicio));

   --


   Lv_StrSalidaElementoUM   VARCHAR2 (200) := NULL;
   Lv_IdServicio            NUMBER := NULL;

   TYPE t_cursorAfectados IS TABLE OF C_GetAfectados%ROWTYPE
                                INDEX BY PLS_INTEGER;

   CursorAfectados          t_cursorAfectados;

   Lv_tipoAfectado          VARCHAR2 (20) := 'Cliente'; --Por default se setea a cliente
   Lv_IdPuntoElemento       NUMBER := NULL;
--
BEGIN
   OPEN C_GetAfectados (Pn_IdCaso);

   FETCH C_GetAfectados
   BULK COLLECT INTO CursorAfectados
   LIMIT LIMIT_IN;

   FOR I IN 1 .. CursorAfectados.COUNT
   LOOP
      Lv_IdPuntoElemento := CursorAfectados (I).AFECTADO_ID;

      IF (CursorAfectados (I).TIPO_AFECTADO = 'Elemento')
      THEN
         Lv_tipoAfectado := 'Elemento';
         EXIT WHEN CursorAfectados (I).TIPO_AFECTADO = 'Elemento';
      END IF;
   END LOOP;

   IF Lv_tipoAfectado = 'Cliente'
   THEN
      IF C_GetServicioId%ISOPEN
      THEN
         --
         CLOSE C_GetServicioId;
      --
      END IF;

      --
      OPEN C_GetServicioId (Lv_IdPuntoElemento);

      --
      FETCH C_GetServicioId INTO Lv_IdServicio;

      --
      IF C_GetServicioId%NOTFOUND
      THEN
         --
         Lv_IdServicio := NULL;

         --
         IF C_GetProductoServicioId%ISOPEN
         THEN
            --
            CLOSE C_GetProductoServicioId;
         --
         END IF;

         --
         OPEN C_GetProductoServicioId (Lv_IdPuntoElemento);

         --
         FETCH C_GetProductoServicioId INTO Lv_IdServicio;

         --
         CLOSE C_GetProductoServicioId;
      --
      END IF;

      --
      CLOSE C_GetServicioId;

      --
      OPEN C_GetElementoUltimaMilla (NULL, Lv_IdServicio);

      FETCH C_GetElementoUltimaMilla INTO Lv_StrSalidaElementoUM;

      CLOSE C_GetElementoUltimaMilla;
   ELSE
      OPEN C_GetElementoUltimaMilla (Lv_IdPuntoElemento, NULL);

      FETCH C_GetElementoUltimaMilla INTO Lv_StrSalidaElementoUM;

      CLOSE C_GetElementoUltimaMilla;
   END IF;

   RETURN Lv_StrSalidaElementoUM;
END GET_AFECTADO_POR_CASO;
/
