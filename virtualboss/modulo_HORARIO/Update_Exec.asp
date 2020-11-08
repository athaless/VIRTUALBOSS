<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<%
Dim objConn, objRS, objRSCT, strSQL, strSQLClause
Dim strE1, strS1, strE2, strS2, strE3, strS3, strTOTAL, strOBS
Dim strCOD_HORARIO, strID_USUARIO, strCOD_EMPRESA
Dim strJSCRIPT_ACTION, strDEFAULT_LOCATION

AbreDBConn objConn, CFG_DB 

strCOD_HORARIO = GetParam("var_chavereg")
strID_USUARIO = GetParam("var_id_usuario")
strCOD_EMPRESA = GetParam("var_cod_empresa") 
strE1 = GetParam("var_in_1")
strS1 = GetParam("var_out_1")
strE2 = GetParam("var_in_2")
strS2 = GetParam("var_out_2")
strE3 = GetParam("var_in_3")
strS3 = GetParam("var_out_3")
strTOTAL = GetParam("var_total")
strOBS = GetParam("var_obs")
strJSCRIPT_ACTION = GetParam("JSCRIPT_ACTION")
strDEFAULT_LOCATION = GetParam("DEFAULT_LOCATION")

strSQL = "UPDATE USUARIO_HORARIO SET COD_EMPRESA = '" & strCOD_EMPRESA & "' "
if strE1<>"" and strE1<>"00:00:00" then 
	strSQL = strSQL &	",	IN_1='" & strE1 & "'" 
else
	strSQL = strSQL &	",	IN_1=NULL"
end if

if strS1<>"" and strS1<>"00:00:00" then 
	strSQL = strSQL &	",	OUT_1='" & strS1 & "'" 
else
	strSQL = strSQL &	",	OUT_1=NULL"
end if

if strE2<>"" and strE2<>"00:00:00" then 
	strSQL = strSQL &	",	IN_2='" & strE2 & "'" 
else
	strSQL = strSQL &	",	IN_2=NULL"
end if

if strS2<>"" and strS2<>"00:00:00" then 
	strSQL = strSQL &	",	OUT_2='" & strS2 & "'" 
else
	strSQL = strSQL &	",	OUT_2 =NULL"
end if

if strE3<>"" and strE3<>"00:00:00" then 
	strSQL = strSQL &	",	IN_3='" & strE3 & "'" 
else
	strSQL = strSQL &	",	IN_3=NULL"
end if

if strS3<>"" and strS3<>"00:00:00" then 
	strSQL = strSQL &	",	OUT_3='" & strS3 & "'" 
else
	strSQL = strSQL &	",	OUT_3=NULL"
end if

if strTOTAL<>"" and strTOTAL<>"00:00:00" then 
	strSQL = strSQL & ", TOTAL='"& strTOTAL 	& "'"
else
	strSQL = strSQL & ", TOTAL=NULL"
end if

if strOBS<>"" then 
	strSQL = strSQL & ", OBS='"& strOBS & "' "
else			
	strSQL = strSQL & ", OBS= NULL "
end if
strSQL = strSQL & "WHERE COD_HORARIO = " & strCOD_HORARIO
'AQUI: NEW TRANSACTION
set objRSCT = objConn.Execute("start transaction")
set objRSCT = objConn.Execute("set autocommit = 0")
objConn.Execute(strSQL) 
if Err.Number<>0 then 
  set objRSCT= objConn.Execute("rollback")
  Mensagem "modulo_HORARIO.Update_Exec: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
  Response.End()
else	  
  set objRSCT= objConn.Execute("commit")
End If

response.write "<script>"  & vbCrlf 
if strJSCRIPT_ACTION <> "" then response.write strJSCRIPT_ACTION & vbCrlf end if
if strDEFAULT_LOCATION <> "" then response.write "location.href='" & strDEFAULT_LOCATION & "'" & vbCrlf
response.write "</script>"
%>