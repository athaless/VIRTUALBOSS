<!--#include file="../_database/athdbConn.asp"--><% 'ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<!--#include file="../_include/_IncludePonto_CalcTotais.asp"--> 
<%
  Dim ObjConn, strCOD_PONTO
  
  strCOD_PONTO = GetParam("var_chavereg")

  if strCOD_PONTO <> "" then 
    AbreDBConn ObjConn, CFG_DB
    ObjConn.Execute("DELETE FROM PT_PONTO WHERE COD_PONTO = " & strCOD_PONTO)
	
	RecalculaTOTALDIA GetParam("var_id_usuario"), GetParam("var_dt_dia"), GetParam("var_dt_mes"), GetParam("var_dt_ano") 
    RecalculaTOTALDIAEMPRESA GetParam("var_empresa"), GetParam("var_id_usuario"), GetParam("var_dt_dia"), GetParam("var_dt_mes"), GetParam("var_dt_ano") 

    FechaDBConn ObjConn
  end if
%>
<script>
   //ASSIM S� FUNCIONA NO IE (s� no IE): parent.vbTopFrame.form_principal.submit();
 
   //ASSIM FUNCIONA NO IE e no FIREFOX
   parent.frames["vbTopFrame"].document.form_principal.submit();
</script>