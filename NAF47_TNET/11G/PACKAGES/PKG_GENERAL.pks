CREATE OR REPLACE PACKAGE            pkg_general IS
   -- Author  : Ivan Vega S.
   -- Created : 26/05/2009 12:46:22
   -- Purpose : Procesos de uso general

   --Variable Record ARGEPARAM
   SUBTYPE r_argeparam_rg    IS argeparam%ROWTYPE;

   --------------------------------------------------------------------------------------------
   --Funcion para obtener el VALOR DE UN PARAMETRO.
   FUNCTION f_obtiene_reg_argeparam(pa_no_cia IN arcgmc.no_cia%TYPE,
                                    pa_modulo IN argemod.modulo%TYPE,
                                    pa_parametro IN argeparam.no_parametro%TYPE)
   RETURN r_argeparam_rg;

end pkg_general;
/


CREATE OR REPLACE PACKAGE BODY            pkg_general IS
   --Funcion para obtener el VALOR DE UN PARAMETRO.
   FUNCTION f_obtiene_reg_argeparam(pa_no_cia IN arcgmc.no_cia%TYPE,
                                    pa_modulo IN argemod.modulo%TYPE,
                                    pa_parametro IN argeparam.no_parametro%TYPE)
   RETURN r_argeparam_rg
   IS
      v_argeparam_rg r_argeparam_rg;
   BEGIN
      SELECT    *
      INTO      v_argeparam_rg
      FROM      argeparam a
      WHERE     a.no_parametro = pa_parametro
      AND       a.modulo = pa_modulo
      AND       a.no_cia = pa_no_cia;
      RETURN v_argeparam_rg;
   EXCEPTION
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20000, SQLERRM);
   END f_obtiene_reg_argeparam;
END pkg_general;
/
