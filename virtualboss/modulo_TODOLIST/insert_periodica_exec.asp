<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<!--#include file="../_database/athEnviaAlert.asp"-->
<%
Session.LCID = 1046

Dim WMD_WIDTH, WMD_WIDTHTTITLES
WMD_WIDTH = 415
WMD_WIDTHTTITLES = 100

abreDBConn objConn, CFG_DB

Dim strSQL, objRS, objRSCT, ObjConn, strBodyMsg, strArquivoAnexo, strAuxSQL
Dim strTITULO, strPRIORIDADE, strRESPONSAVEL, strEXECUTOR, strSITUACAO, strDESCRICAO 
Dim strPREV_DT_INI, strPREV_HR_INI, strCODCATEGORIA, strDESCCATEGORIA
Dim strDtIni, strDtFim, strMes, strDiaSem, strDiaNum, strWeekday, strMonth, strResult
Dim strHORAS, strMINUTOS, strHORASeMINUTOS, strDT_INI, strDADOS, strColor, arrDATAS, aux, i
Dim strDT_REALIZADO, strMSG
Dim strJSCRIPT_ACTION, strLOCATION
Dim strEMAIL_RESPONSAVEL, strEMAIL_EXECUTOR, strEMAILS_MANAGER

strTITULO         = GetParam("var_titulo")
strRESPONSAVEL    = LCase(GetParam("var_id_responsavel"))
strEXECUTOR       = LCase(GetParam("var_id_executor"))
strSITUACAO       = GetParam("var_situacao")
strPRIORIDADE     = GetParam("var_prioridade")
strDESCRICAO      = Replace(GetParam("var_descricao"),"'","<ASLW_APOSTROFE>")
strCODCATEGORIA   = GetParam("var_cod_e_desc_categoria")
strDESCCATEGORIA  = GetParam("var_cod_e_desc_categoria")
strDT_INI		  = GetParam("var_data_inicio")	
strDtIni          = GetParam("var_data_inicio")
strDtFim          = GetParam("var_data_fim")
strMes            = GetParam("var_mes")
strDiaSem         = GetParam("var_diasem")
strDiaNum         = GetParam("var_dianum")
strHORAS          = GetParam("var_prev_horas")
strMINUTOS        = GetParam("var_prev_minutos")
strPREV_HR_INI    = GetParam("var_prev_hr_ini_hora") & ":" & GetParam("var_prev_hr_ini_min")
strDT_REALIZADO   = GetParam("var_dt_realizado")
strJSCRIPT_ACTION = GetParam("JSCRIPT_ACTION")
strLOCATION       = GetParam("DEFAULT_LOCATION")

if strMes="" or (strDiaSem="" and strDiaNum="") or strRESPONSAVEL="" or strTITULO="" or strCODCATEGORIA="" or strSITUACAO="" or strPRIORIDADE="" or strDESCRICAO="" or strDtIni="" or strDtFim="" then
	Mensagem "Preencha todos os campos obrigatórios","javascript:history.go(-1);", "Voltar", false
	Response.End()
end if

strCODCATEGORIA = mid(strCODCATEGORIA,1,InStr(strCODCATEGORIA," ")-1)

if IsDate(strDtIni) then
	strDtIni = CDate(Prepdata(CDate(strDtIni),true,false))
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
 
if strHORAS<>"" then
	if not isNumeric(strHORAS) then
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

If strPREV_HR_INI = ":" Then 
	strPREV_HR_INI = ""
Else
	If InStr(strPREV_HR_INI, ":") = 1                   Then strPREV_HR_INI = "00" & strPREV_HR_INI
	If InStr(strPREV_HR_INI, ":") = Len(strPREV_HR_INI) Then strPREV_HR_INI = strPREV_HR_INI & "00"
End If

strAuxSQL = ""
while strDtIni <= strDtFim
	strMonth = Month(strDtIni)
	if strMonth < 10 then strMonth = "0" & strMonth

	if strDiaNum <> "" then
		if CInt(Day(strDtIni)) = CInt(strDiaNum) and InStr(1,strMes,strMonth) then	
			arrDATAS = arrDATAS & PrepData(strDtIni,true,false) & " - " & DiaSemana(WeekDay(strDtIni)) & ";"
			
			strPREV_DT_INI = "'" & PrepDataBrToUni(strDtIni,false) & "'"
			
			strSQL =          " INSERT INTO TL_TODOLIST (TITULO, SITUACAO, COD_CATEGORIA, PRIORIDADE, ID_RESPONSAVEL, ID_ULT_EXECUTOR,"
			strSQL = strSQL & " PREV_DT_INI, PREV_HR_INI, PREV_HORAS, DESCRICAO, SYS_ID_USUARIO_INS, SYS_DTT_INS) "
			strSQL = strSQL & " VALUES ('" & strTITULO & "', '" & strSITUACAO & "', " & strCODCATEGORIA & ", '" & strPRIORIDADE & "',"
			strSQL = strSQL & " '" & strRESPONSAVEL & "', '" & strEXECUTOR & "', " & strPREV_DT_INI & ", '" & strPREV_HR_INI & "', " & strHORASeMINUTOS & ","
			strSQL = strSQL & " '" & strDESCRICAO & "', '" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "', '" & PrepDataBrToUni(Now,true) & "')"
			strAuxSQL = strAuxSQL & vbnewline & vbnewline & strSQL

			'AQUI: NEW TRANSACTION
			set objRSCT  = objConn.Execute("start transaction")
			set objRSCT  = objConn.Execute("set autocommit = 0")
			objConn.execute(strSQL)
			If Err.Number <> 0 Then
				set objRSCT = objConn.Execute("rollback")
				Mensagem Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
				Response.End()
			else
				set objRSCT = objConn.Execute("commit")
			End If
			
			'strResult = strResult & "<tr><td>" & PrepData(strDtIni,true,false) & "</td>"
			'strResult = strResult & "    <td>" & DiaSemana(WeekDay(strDtIni)) & "</td>"
			'strResult = strResult & "    <td>" & strRESPONSAVEL & "</td>"
			'strResult = strResult & "    <td>" & strEXECUTOR & "</td>"
			'strResult = strResult & "</tr>"
		end if
	else
		strWeekday = Weekday(strDtIni)
		if InStr(1,strMes,strMonth) then
			if InStr(1,strDiaSem,strWeekday) then
				arrDATAS = arrDATAS & PrepData(strDtIni,true,false) & " - " & DiaSemana(WeekDay(strDtIni)) & ";"
				
				strPREV_DT_INI = "'" & PrepDataBrToUni(strDtIni,false) & "'"
				
				strSQL =          " INSERT INTO TL_TODOLIST (TITULO, SITUACAO, COD_CATEGORIA, PRIORIDADE, ID_RESPONSAVEL, ID_ULT_EXECUTOR,"
				strSQL = strSQL & " PREV_DT_INI, PREV_HR_INI, PREV_HORAS, DESCRICAO, SYS_ID_USUARIO_INS, SYS_DTT_INS) "
				strSQL = strSQL & " VALUES ('" & strTITULO & "', '" & strSITUACAO & "', " & strCODCATEGORIA & ", '" & strPRIORIDADE & "',"
				strSQL = strSQL & " '" & strRESPONSAVEL & "', '" & strEXECUTOR & "', " & strPREV_DT_INI & ", '" & strPREV_HR_INI & "', " & strHORASeMINUTOS & ","
				strSQL = strSQL & " '" & strDESCRICAO & "', '" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "', '" & PrepDataBrToUni(Now,true) & "')"
				strAuxSQL = strAuxSQL & vbnewline & vbnewline & strSQL
				
				'AQUI: NEW TRANSACTION
				set objRSCT  = objConn.Execute("start transaction")
				set objRSCT  = objConn.Execute("set autocommit = 0")
				objConn.execute(strSQL)
				If Err.Number <> 0 Then
					set objRSCT = objConn.Execute("rollback")
					Mensagem Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
					Response.End()
				else
					set objRSCT = objConn.Execute("commit")
				End If

				'strResult = strResult & "<tr><td>" & PrepData(strDtIni,true,false) & "</td>"
				'strResult = strResult & "    <td>" & DiaSemana(WeekDay(strDtIni)) & "</td>"
				'strResult = strResult & "    <td>" & strRESPONSAVEL & "</td>"
				'strResult = strResult & "    <td>" & strEXECUTOR & "</td>"
				'strResult = strResult & "</tr>"
			end if
		end if
	end if
	strDtIni = strDtIni + 1
Wend

athSaveLog "INS", Request.Cookies("VBOSS")("ID_USUARIO"), "TL_TODOLIST - periodica", strAuxSQL

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


'INIC: Envio de EMAIL -------------------------------------------------------
if strEXECUTOR<>"" then
	MontaBody strBodyMsg,0			 _
				,"Inclusão de Tarefa"_
				,"",strTITULO		 _
				,strSITUACAO 		 _
				,strDESCCATEGORIA 	 _
				,strPRIORIDADE 		 _
				,strRESPONSAVEL 	 _
				,strEXECUTOR 		 _
				,strDT_INI & " " & strPREV_HR_INI _
				,strDT_REALIZADO _
				,Replace(strDESCRICAO,"<ASLW_APOSTROFE>","'") & "<br><br><div style='font-weight:bold;'>nas datas: </div>" & strDADOS _
				,"" _
				,"TODOLIST"_
				,""
	
	strEMAIL_RESPONSAVEL = BuscaUserEMAIL(ObjConn, strRESPONSAVEL)
	strEMAIL_EXECUTOR    = BuscaUserEMAIL(ObjConn, strEXECUTOR)
	strEMAILS_MANAGER    = BuscaManagerEMAILS(ObjConn, "|" & strEMAIL_RESPONSAVEL & "|" & strEMAIL_EXECUTOR & "|")
	
	AthEnviaMail strEMAIL_RESPONSAVEL,"virtualboss@virtualboss.com.br",strEMAIL_EXECUTOR & ";" & strEMAILS_MANAGER,"ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList (" & strEXECUTOR & ")",strBodyMsg,1, 0, 0,""
end if
'FIM: Envio de EMAIL --------------------------------------------------------

response.write "<script>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'")
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "'"
response.write "</script>"
%>