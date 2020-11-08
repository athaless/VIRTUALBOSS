<!--#include file="../_database/athdbConn.asp"--> <%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim strSQL, objRS, ObjConn, objRSTs
Dim strID_USUARIO, strCOD_EMPRESA
Dim strIN_1, strOUT_1, strIN_2, strOUT_2, strIN_3, strOUT_3
Dim strOBS, strDIA_SEMANA, strDIA, strTOTAL, strDIAS_SELECTED
Dim i
Dim strJSCRIPT_ACTION, strLOCATION

AbreDBConn objConn, CFG_DB 

strID_USUARIO	= GetParam("var_id_usuario")
strCOD_EMPRESA	= GetParam("var_cod_empresa") 
strIN_1  		= GetParam("var_in_1")
strOUT_1		= GetParam("var_out_1")
strIN_2			= GetParam("var_in_2")
strOUT_2		= GetParam("var_out_2")
strIN_3			= GetParam("var_in_3")
strOUT_3		= GetParam("var_out_3")
strTOTAL		= GetParam("var_total") 
strOBS			= GetParam("var_obs")
strJSCRIPT_ACTION = GetParam("JSCRIPT_ACTION")
strLOCATION       = GetParam("DEFAULT_LOCATION")

strDIAS_SELECTED = ""
for i=1 to 7
	strDIAS_SELECTED = strDIAS_SELECTED & GetParam("var_dia_semana_" & i) & "|"
next

for i=1 to 7
	strDIA = UCase(WeekDayName(i,1,1))

	if instr(strDIAS_SELECTED,strDIA)>0 then

		strSQL = "INSERT INTO USUARIO_HORARIO (ID_USUARIO, COD_EMPRESA, DIA_SEMANA, IN_1, OUT_1, IN_2, OUT_2, IN_3, OUT_3, TOTAL, OBS) "
		strSQL = strSQL & " VALUES ( "	&_
						  "'" & strID_USUARIO	& "', " &_
						  "'" & strCOD_EMPRESA	& "', " &_											
						  "'" & strDIA			& "', "
		if strIN_1  = "00:00:00" then strSQL=strSQL & "NULL, " else strSQL=strSQL & "'" & strIN_1  & "', " end if
		if strOUT_1 = "00:00:00" then strSQL=strSQL & "NULL, " else strSQL=strSQL & "'" & strOUT_1 & "', " end if
		if strIN_2  = "00:00:00" then strSQL=strSQL & "NULL, " else strSQL=strSQL & "'" & strIN_2  & "', " end if
		if strOUT_2 = "00:00:00" then strSQL=strSQL & "NULL, " else strSQL=strSQL & "'" & strOUT_2 & "', " end if
		if strIN_3  = "00:00:00" then strSQL=strSQL & "NULL, " else strSQL=strSQL & "'" & strIN_3  & "', " end if
		if strOUT_3 = "00:00:00" then strSQL=strSQL & "NULL, " else strSQL=strSQL & "'" & strOUT_3 & "', " end if
		strSQL = strSQL & "'" & strTOTAL	& "', "
		if strOBS="" then  strSQL=strSQL & "NULL)" else strSQL=strSQL &	"'" & strOBS & "')"	end if
		
		'AQUI: NEW TRANSACTION
		set objRSTs  = objConn.Execute("start transaction")
		set objRSTs  = objConn.Execute("set autocommit = 0")
		objConn.Execute(strSQL)  
		If Err.Number <> 0 Then
		  set objRSTs = objConn.Execute("rollback")
		  Mensagem "modulo_HORARIO.Insert_Exec: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		  Response.End()
		else
		  set objRSTs = objConn.Execute("commit")
		End If
		
	end if
next
FechaDBConn objConn

response.write "<script>" & vbCrlf 
if (strJSCRIPT_ACTION <> "") then response.write strJSCRIPT_ACTION & vbCrlf end if
if (strLOCATION <> "") then response.write "location.href='" & strLOCATION & "'" & vbCrlf
response.write "</script>"
%>