<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<!--#include file="../_database/athEnviaAlert.asp"-->
<%
Session.LCID = 1046

Dim WMD_WIDTH, WMD_WIDTHTTITLES
WMD_WIDTH = 500
WMD_WIDTHTTITLES = 100

abreDBConn objConn, CFG_DB

Dim strSQL, objRS, ObjConn, strBodyMsg, strArquivoAnexo, strDestMail   
Dim strTITULO, strPRIORIDADE, strRESPONSAVEL, strCITADOS, strSITUACAO, strDESCRICAO 
Dim strPREV_DT_INI, strPREV_DT_FIM, strCODCATEGORIA, strDESCCATEGORIA
Dim strDtIni, strMes, strDiaSem, strDiaNum, strWeekday, strMonth, strResult
Dim strHORAS, strMINUTOS, strHORASeMINUTOS
Dim strDtFim, strDT_HORA_INI, strHORA, arrDATAS, strDADOS
Dim i, aux, strColor

strTITULO        = GetParam("var_titulo")
strRESPONSAVEL   = LCase(GetParam("var_id_responsavel"))
strCITADOS	     = LCase(GetParam("var_id_citados")) & ";"
strSITUACAO      = GetParam("var_situacao")
strPRIORIDADE    = GetParam("var_prioridade")
strDESCRICAO     = Replace(GetParam("var_DESCRICAO"),"'","<ASLW_APOSTROFE>")
strCODCATEGORIA  = GetParam("var_cod_e_desc_categoria")
strDESCCATEGORIA = GetParam("var_cod_e_desc_categoria")
strHORA			  = " " & GetParam("var_hh") & ":" & GetParam("var_mm") & ":00"
strDT_HORA_INI   = GetParam("datainicio")
strDtIni         = GetParam("datainicio") & strHORA
strDtFim         = GetParam("datafim")
strMes           = GetParam("mes")
strDiaSem        = GetParam("diasem")
strDiaNum        = GetParam("dianum")
strHORAS         = GetParam("var_prev_horas")
strMINUTOS       = GetParam("var_prev_minutos")

if strMes="" or (strDiaSem="" and strDiaNum="") or strRESPONSAVEL="" or strTITULO="" or strCODCATEGORIA="" or strSITUACAO="" or strPRIORIDADE="" or strDESCRICAO="" or strDtIni="" or strDtFim="" then
	Mensagem "Preencha todos os campos obrigatórios","javascript:history.go(-1);", "Voltar", false
	Response.End()
end if

if IsDate(strDtIni) then
	strDtIni = CDate(Prepdata(CDate(strDtIni),false,true))
else
	Response.Write("<p align='center'>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
	Response.End()
end if
 
if IsDate(strDtFim) then
	strDtFim = CDate(Prepdata(CDate(strDtFim),true,false))
else
	Response.Write("<p align='center'>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
	Response.End()
end if  
 
strCODCATEGORIA = mid(strCODCATEGORIA,1,InStr(strCODCATEGORIA," ")-1)

if strHORAS<>"" then
	if not IsNumeric(strHORAS) then
		Response.write("<p align='center'>O valor de horas dispendidas deve ser numérico<br>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
		Response.End()
	else
		strHORASeMINUTOS = strHoras & "." & strMinutos
	end if
else
	if (CInt(strMinutos)>0) then 
		strHORASeMINUTOS = "0." & Cstr(strMinutos) 
	else 
		strHORASeMINUTOS ="NULL" 
	end if
end if

while strDtIni <= strDtFim
	strMonth = Month(strDtIni)
	if strMonth < 10 then strMonth = "0" & strMonth
	
	if strDiaNum <> "" then
		if CInt(Day(strDtIni)) = CInt(strDiaNum) and InStr(1,strMes,strMonth) then
			arrDATAS = arrDATAS & PrepData(strDtIni,true,false) & " - " & DiaSemana(WeekDay(strDtIni)) & ";"

			strPREV_DT_INI = "'" & PrepDataBrToUni(strDtIni,true) & "'" 
			
			strSQL =          " INSERT INTO AG_AGENDA (TITULO, SITUACAO, COD_CATEGORIA, PRIORIDADE, ID_RESPONSAVEL, ID_CITADOS,"
			strSQL = strSQL & " PREV_DT_INI, PREV_HORAS, DESCRICAO, SYS_ID_USUARIO_INS, SYS_DTT_INS) " 
			strSQL = strSQL & " VALUES ('" & strTITULO & "', '" & strSITUACAO & "', " & strCODCATEGORIA & ", '" & strPRIORIDADE & "', "  
			strSQL = strSQL & "'" & strRESPONSAVEL & "','" & strCITADOS & "'," & strPREV_DT_INI & ", " & strHORASeMINUTOS & ","
			strSQL = strSQL & "'" & strDESCRICAO & "', '" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "','" & PrepDataBrToUni(now,true) & "')" 
			
			objConn.Execute(strSQL)
			
			strResult = strResult & "<tr><td></td><td>" & strDtIni & "</td><td>" & DiaSemana(WeekDay(strDtIni)) & "</td><td>" & strRESPONSAVEL & "</td><td>" & strCITADOS & "</td></tr>"
		end if
	else
		strWeekday = Weekday(strDtIni)
		if InStr(1,strMes,strMonth) then
			if InStr(1,strDiaSem,strWeekday) then
				arrDATAS = arrDATAS & PrepData(strDtIni,true,false) & " - " & DiaSemana(WeekDay(strDtIni)) & ";"
				
				strPREV_DT_INI = "'" & PrepDataBrToUni(strDtIni,true) & "'" 
				
				strSQL =          " INSERT INTO AG_AGENDA (TITULO, SITUACAO, COD_CATEGORIA, PRIORIDADE, ID_RESPONSAVEL, ID_CITADOS,"
				strSQL = strSQL & " PREV_DT_INI, PREV_HORAS, DESCRICAO, SYS_ID_USUARIO_INS, SYS_DTT_INS) " 
				strSQL = strSQL & " VALUES ('" & strTITULO & "', '" & strSITUACAO & "', " & strCODCATEGORIA & ", '" & strPRIORIDADE & "', "  
				strSQL = strSQL & "'" & strRESPONSAVEL & "','" & strCITADOS & "'," & strPREV_DT_INI & ", " & strHORASeMINUTOS & ","
				strSQL = strSQL & "'" & strDESCRICAO & "', '" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "','" & PrepDataBrToUni(now,true) & "')"
				
				objConn.Execute(strSQL)
				
				strResult = strResult & "<tr><td></td><td>" & PrepData(strDtIni,true,false) & "</td><td>" & DiaSemana(WeekDay(strDtIni)) & "</td><td>" & strRESPONSAVEL & "</td><td>" & strCITADOS & "</td></tr>"
			end if
		end if
	end if
	strDtIni = strDtIni + 1
Wend

arrDATAS = Split(arrDATAS,";")
aux = false

strDADOS = "<table width='550px' border='0px' cellpadding='0px' cellspacing='0px'>" & vbCrlf &_ 
				"<tr bgcolor='#FFFFFF' style='font-size:10px;'>" & vbCrlf

for i=1 to UBound(arrDATAS)
	aux = not aux
	strColor = "#FFFFFF"
	if aux then strColor="#E7E7E7"
	strDADOS = strDADOS & "<td height='12px'>&nbsp;&middot; " & arrDATAS(i-1) & "</td>" & vbCrlf
	if (i mod 3)=0 then strDADOS = strDADOS & "</tr>" & vbCrlf & "<tr bgcolor='" & strColor & "' style='font-size:10px;'>"
next

i = UBound(arrDATAS)

if (i mod 3)<>0 then
	do
		strDADOS = strDADOS & "<td></td>"
		i = i + 1
	loop until (i mod 3)=0
end if

strDADOS = strDADOS & "</tr>" & vbCrlf & "</table>"

if mid(strCITADOS,1,1)=";" then strCITADOS = mid(strCITADOS,2)	


'INIC: Envio de EMAIL -----------------------------------------------------------------------------------------------------------------------
if strCITADOS<>"" then
	MontaBody strBodyMsg,0			 _
				,"Inclusão de Agenda" _
				,"",strTITULO			 _
				,strSITUACAO 			 _
				,strDESCCATEGORIA 	 _
				,strPRIORIDADE 		 _
				,strRESPONSAVEL 		 _
				,strCITADOS 			 _
				,strDT_HORA_INI & " - " & PrepData(strDtFim,true,false) _
				,GetParam("var_dt_realizado") _
				,Replace(strDESCRICAO,"<ASLW_APOSTROFE>","'") & "<br><br><div style='font-weight:bold;'>nas datas: </div>" & strDADOS _
				,""_
				,"AGENDA"_
				,""
		
	'-- Busca o email dos citados -----------------------------------------------------
	strDestMail = Replace(strCITADOS," ","")
	strDestMail = "'" & Replace(strDestMail,";","','") & "'"
	
	strSQL = "SELECT EMAIL FROM USUARIO WHERE	ID_USUARIO IN (" & strDestMail & ")"
	Set objRS = objConn.Execute(strSQL)
	
	strDestMail = ""	
	while not objRS.eof
		strDestMail = strDestMail & objRS("EMAIL") & ";"
		objRS.MoveNext
	wend
	'----------------------------------------------------------------------------------
	AthEnviaMail strDestMail _
					,"virtualboss@virtualboss.com.br",""	_
					,"ath.virtualboss@gmail.com"		_
					,Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: Agenda"	_
					,strBodyMsg,1,0,0,""
end if
'FIM: Envio de EMAIL ------------------------------------------------------------------------------------------------------------------------
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
</head>
<body>
<%	athBeginDialog WMD_WIDTH, "Tarefas Inseridas" %>
<table width="490px" cellpadding="0" cellspacing="2" align="center" background="../img/BGLeftMenu.jpg">
	<tr>
		<td></td>
		<td><strong>Data</strong></td>
		<td><strong>Dia da Semana</strong></td>
		<td><strong>Responsavel</strong></td>
		<td nowrap><strong>Citados</strong></td>
	</tr>
	<tr><td colspan="5" height="5"><hr size="2"></td></tr>
   <%=strResult%>
</table>
<%	athEndDialog WMD_WIDTH, "../img/bt_voltar.gif", "JavaScript:location.href='insert_periodica.asp';", "", "", "", "" %>
</body>
</html>