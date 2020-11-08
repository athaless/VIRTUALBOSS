<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<%
	Dim objConn, objRS, strSQL
	Dim strCOD_MENU_PAI, strGRP_USER, strROTULO, strLINK, strID_APP, strIMG, strORDEM, strDT_INATIVO
	Dim strJSCRIPT_ACTION, strDEFAULT_LOCATION
	
	AbreDBConn objConn, CFG_DB
	
	strCOD_MENU_PAI = GetParam("var_cod_menu_pai")
	strGRP_USER     = GetParam("var_grp_user")
	strROTULO       = GetParam("var_rotulo")
	strLINK         = GetParam("var_link")
	strID_APP       = GetParam("var_id_app")
	strIMG          = GetParam("var_img")
	strORDEM        = GetParam("var_ordem")
	strDT_INATIVO   = GetParam("var_dt_inativo")
	strJSCRIPT_ACTION   = GetParam("JSCRIPT_ACTION")
	strDEFAULT_LOCATION = GetParam("DEFAULT_LOCATION")
	
	If strGRP_USER = "" Then strGRP_USER = "NULL" Else strGRP_USER = "'" & strGRP_USER & "'" End If
	If strID_APP = "" Then strID_APP = "NULL" Else strID_APP = "'" & strID_APP & "'" End If
	If strORDEM = "" Or Not IsNumeric(strORDEM) Then strORDEM = "NULL"
	If strDT_INATIVO <> "NULL" And IsDate(strDT_INATIVO) Then
		strDT_INATIVO = "'" & PrepDataBrToUni(strDT_INATIVO, false) & "'"
	Else
		strDT_INATIVO = "NULL"
	End If
	
	strSQL =          " INSERT INTO SYS_MENU (COD_MENU_PAI, GRP_USER, ROTULO, LINK, ID_APP, IMG, ORDEM, DT_INATIVO) "
	strSQL = strSQL & " VALUES ( " & strCOD_MENU_PAI & ", " & strGRP_USER & ", '" & strROTULO & "', '" & strLINK & "' "
	strSQL = strSQL & "        , " & strID_APP & ", '" & strIMG & "', " & strORDEM & ", " & strDT_INATIVO & ")"
	
	objConn.execute(strSQL)
	
	FechaDBConn objConn
	
	response.write "<script>" & vbCrlf 
	if (strJSCRIPT_ACTION <> "")   then response.write strJSCRIPT_ACTION & vbCrlf end if
	if (strDEFAULT_LOCATION <> "") then response.write "location.href='" & strDEFAULT_LOCATION & "'" & vbCrlf
	response.write "</script>"
%>