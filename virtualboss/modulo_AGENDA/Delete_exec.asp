<!--#include file="../_database/athdbConn.asp"--><% 'ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
  Dim ObjConn, strCODIGO
  Dim strJSCRIPT_ACTION, strLOCATION
  
  strCODIGO         = GetParam("var_chavereg")
  strJSCRIPT_ACTION = GetParam("var_jscript_action")
  strLOCATION       = GetParam("var_location")

  if strCODIGO <> "" then   
    AbreDBConn ObjConn, CFG_DB
    objConn.Execute("DELETE FROM AG_AGENDA WHERE COD_AGENDA = " & strCODIGO)
    FechaDBConn ObjConn
  end if
  
response.write "<script>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'")
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "'"
response.write "</script>"
%>