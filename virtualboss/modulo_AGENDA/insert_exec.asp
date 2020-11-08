<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<!--#include file="../_database/athEnviaAlert.asp"-->
<%
Session.LCID = 1046 

Dim strSQL, objRS, ObjConn, strBodyMsg, strDestMail   
Dim strTITULO, strPRIORIDADE, strRESPONSAVEL, strCITADOS, strSITUACAO, strDESCRICAO, strPREV_DT_INI
Dim strDT_REALIZADO, strCODCATEGORIA, strDESCCATEGORIA, strARQUIVO_ANEXO, strHORAS, strMINUTOS, strHORASeMINUTOS
Dim strDT_PREV
Dim strJSCRIPT_ACTION, strLOCATION

strTITULO        = GetParam("var_titulo")
strRESPONSAVEL   = LCase(GetParam("var_id_responsavel"))
strCITADOS       = LCase(Replace(GetParam("var_id_citados")," ","")) & ";"
strSITUACAO      = GetParam("var_situacao")
strPRIORIDADE    = GetParam("var_prioridade")
strDESCRICAO     = Replace(GetParam("var_descricao"),"'","<ASLW_APOSTROFE>")
strPREV_DT_INI   = GetParam("var_PREV_DT_INI") & " " & GetParam("var_hh") & ":" & GetParam("var_mm") & ":00"
strDT_REALIZADO  = GetParam("var_dt_realizado")
strCODCATEGORIA  = GetParam("var_cod_e_desc_categoria")
strDESCCATEGORIA = GetParam("var_cod_e_desc_categoria") 'Apenas para o e-mail
strARQUIVO_ANEXO = GetParam("var_arquivo_anexo")
strHORAS         = GetParam("var_prev_horas")
strMINUTOS       = GetParam("var_prev_minutos")
strJSCRIPT_ACTION = GetParam("JSCRIPT_ACTION")
strLOCATION       = GetParam("DEFAULT_LOCATION")

strDT_PREV = strPREV_DT_INI

If strRESPONSAVEL="" or strTITULO="" or strCODCATEGORIA="" or strSITUACAO="" or strPRIORIDADE="" or strDESCRICAO="" Then
	Response.Write("<p align='center'>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
	Response.Write("<br>" & strRESPONSAVEL & "<br>" &  strTITULO & "<br>" & strCODCATEGORIA & "<br>" & strSITUACAO & "<br>" & strPRIORIDADE & "<br>" & strDESCRICAO )
	Response.End()
End If

strCODCATEGORIA = Mid(CStr(strCODCATEGORIA),1,InStr(CStr(strCODCATEGORIA)," ")-1) 'Extrai apenas o Código da categoria da String

If strHORAS<>"" then
	If not IsNumeric(strHORAS) then
		Response.Write("<p align='center'>O valor de horas dispendidas deve ser numérico<br>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
		Response.End()
	Else
		strHORASeMINUTOS = strHoras & "." & strMinutos
	End If
Else
	if (CInt(strMinutos)>0) then  strHORASeMINUTOS = "0." & Cstr(strMinutos) Else strHORASeMINUTOS ="NULL" End If
End If
 
if mid(strCITADOS,1,1)<>";" then strCITADOS = ";" & strCITADOS 
if mid(strCITADOS,Len(strCITADOS))<>";" then strCITADOS = strCITADOS & ";"

AbreDBConn objConn, CFG_DB 

if strDT_REALIZADO = "" then strDT_REALIZADO = "Null" else	strDT_REALIZADO = "'" & PrepDataBrToUni(strDT_REALIZADO, true) & "'" 
if strPREV_DT_INI  = "" or not IsDate(strPREV_DT_INI) then strPREV_DT_INI  = "Null" else strPREV_DT_INI  = "'" & PrepDataBrToUni(strPREV_DT_INI,true) & "'" 
	
'Insere Agenda
strSQL =          " INSERT INTO AG_AGENDA (TITULO, SITUACAO, COD_CATEGORIA, PRIORIDADE, ID_RESPONSAVEL, ID_CITADOS,"
strSQL = strSQL & " PREV_DT_INI, PREV_HORAS, DT_REALIZADO, DESCRICAO, ARQUIVO_ANEXO, SYS_ID_USUARIO_INS, SYS_DTT_INS) " 
strSQL = strSQL & " VALUES ('" & strTITULO & "', '" & strSITUACAO & "', " & strCODCATEGORIA & ", '" & strPRIORIDADE & "', "  
strSQL = strSQL & "'" & strRESPONSAVEL & "','" & strCITADOS & "'," & strPREV_DT_INI & ", " & strHORASeMINUTOS & ", " & strDT_REALIZADO & ", "
strSQL = strSQL & "'" & strDESCRICAO & "','" & strARQUIVO_ANEXO & "','" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "','" & PrepDataBrToUni(now,true) &  "')" 
objConn.Execute(strSQL) 

if mid(strCITADOS,1,1)=";" then strCITADOS = mid(strCITADOS,2)	


'INIC: Envio de EMAIL -----------------------------------------------------------------------------------------------------------------------
if strCITADOS<>"" then
	MontaBody strBodyMsg,0				_
				,"Inclusão de Agenda"	_
				,"",strTITULO,strSITUACAO _
				,strDESCCATEGORIA			_
				,strPRIORIDADE				_
				,strRESPONSAVEL			_
				,strCITADOS,strDT_PREV	_
				,GetParam("var_dt_realizado") _
				,Replace(strDESCRICAO,"<ASLW_APOSTROFE>","'") _
				,"" _
				,"AGENDA"_
				,""
		 
	'-- Busca o email dos citados --------------------------------------------------
	strDestMail = Replace(strCITADOS," ","")
	strDestMail = "'" & Replace(strDestMail,";","','") & "'"
	
	strSQL = "SELECT EMAIL FROM USUARIO WHERE	ID_USUARIO IN (" & strDestMail & ")"	
	Set objRS = objConn.Execute(strSQL)

	strDestMail = ""	
	while not objRS.Eof
		strDestMail = strDestMail & objRS("EMAIL") & ";"
		objRS.MoveNext
	wend
	'-------------------------------------------------------------------------------

	AthEnviaMail strDestMail _
					,"virtualboss@virtualboss.com.br","" _
					,"ath.virtualboss@gmail.com" _
					,Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: Agenda" _
					,strBodyMsg,1,0,0,""
end if
'FIM: Envio de EMAIL ------------------------------------------------------------------------------------------------------------------------

FechaDBConn objConn

response.write "<script>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'")
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "'"
response.write "</script>"
%>