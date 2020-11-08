<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<!--#include file="../_include/_IncludePonto_CalcTotais.asp"--> 
<%
  Dim ObjConn, strSQL, auxSTR

  AbreDBConn ObjConn, CFG_DB
  
  auxSTR = GetParam("var_empresa")
  RecalculaTOTALDIA GetParam("var_id_usuario"), GetParam("var_dt_dia"), GetParam("var_dt_mes"), GetParam("var_dt_ano") 
  if ( (len(auxSTR) <> 0) and (auxSTR <> "Todos") )then
    RecalculaTOTALDIAEMPRESA auxSTR, GetParam("var_id_usuario"), GetParam("var_dt_dia"), GetParam("var_dt_mes"), GetParam("var_dt_ano") 
  end if	
  FechaDBConn ObjConn
%>
<script>
  parent.vbTopFrame.document.form_principal.submit();
  window.close();
</script>