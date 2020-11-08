<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<!--#include file="../_database/athEnviaAlert.asp"--> 
<%
Session.LCID = 1046 

Dim strSQL, objRS, ObjConn, strBodyMsg, strDtAnt, auxTpMsg, auxSTR, strDestMail   
Dim strCOD, strTITULO, strPRIORIDADE, strRESPONSAVEL, strCITADOS, strSITUACAO, strDESCRICAO, strPREV_DT_INI, strPREV_DT_FIM, strDT_REALIZADO
Dim strCODCATEGORIA, strDESCCATEGORIA, strArquivoAnexo, strRetArquivo, strArquivo
Dim strHORAS, strMINUTOS, strHORASeMINUTOS, strDT_INI, strDTT_INI
Dim strJSCRIPT_ACTION, strLOCATION
Dim objFSO

strCOD           = GetParam("var_cod_agenda")
strTITULO        = GetParam("var_titulo")
strRESPONSAVEL   = LCase(GetParam("var_ID_RESPONSAVEL"))
strCITADOS 		  = LCase(Replace(GetParam("var_id_citados")," ",""))
strSITUACAO      = GetParam("var_SITUACAO")
strPRIORIDADE    = GetParam("var_prioridade")
strDESCRICAO     = Replace(GetParam("var_DESCRICAO"),"'","<ASLW_APOSTROFE>")
strDT_INI 		  = GetParam("VAR_PREV_DT_INI")
strPREV_DT_INI   = GetParam("VAR_PREV_DT_INI") & " " & GetParam("var_hh") & ":" & GetParam("var_mm") & ":00"
strDT_REALIZADO  = GetParam("VAR_DT_REALIZADO")
strCODCATEGORIA  = GetParam("var_cod_e_desc_categoria")
strDESCCATEGORIA = GetParam("var_cod_e_desc_categoria") 'Apenas para o e-mail
strDtAnt         = GetParam("var_data_ant")
strArquivoAnexo  = GetParam("var_arquivo_anexo")
strRetArquivo	  = GetParam("req_arquivo_anexo")
strHORAS         = GetParam("var_prev_horas")
strMINUTOS       = GetParam("var_prev_minutos")
strJSCRIPT_ACTION = GetParam("JSCRIPT_ACTION")
strLOCATION       = GetParam("DEFAULT_LOCATION")

if strArquivoAnexo="" and strRetArquivo<>"" then
	set objFSO = Server.CreateObject("Scripting.FileSystemObject") 
	if objFSO.FileExists(FindUploadPath & "\upload\" & GetParam("req_arquivo_anexo")) then 
		'response.write "oal"
		'response.end
		objFSO.DeleteFile FindUploadPath & "\upload\" & GetParam("req_arquivo_anexo")
		Set objFSO = Nothing
	end if 
end if
 
if strArquivoAnexo<>"" and strRetArquivo="" then
Dim strRetNewArquivo
	strRetNewArquivo = "AG_" & Day(now) & Month(now) & Year(now) & Hour(now) & Minute(now) & Second(now) & "_" & strArquivoAnexo
	set objFSO = Server.CreateObject("Scripting.FileSystemObject") 
	if objFSO.FileExists(FindUploadPath & "\upload\" & strArquivoAnexo) then
		'response.write strArquivoAnexo & " " & strRetArquivo
		'response.end 
		objFSO.MoveFile FindUploadPath & "\upload\" & strArquivoAnexo, FindUploadPath & "\upload\" & strRetNewArquivo
		strArquivoAnexo = strRetNewArquivo
		Set objFSO = Nothing
	end if 
end if
 
if not IsNull(strRetArquivo) or strRetArquivo<>"" then
	strArquivo = Mid(strRetArquivo,inStr(1,strRetArquivo,"_")+1)
	strArquivo = Mid(strArquivo,inStr(1,strArquivo,"_")+1)
end if
 
if strArquivoAnexo=strArquivo then
	strArquivoAnexo = strRetArquivo
else
	if strArquivoAnexo<>"" and strRetArquivo<>"" then
		' Deleta o arquivo já existente
		set objFSO = Server.CreateObject("Scripting.FileSystemObject") 
		if objFSO.FileExists(FindUploadPath & "\upload\" & strRetArquivo) then 
			'response.write "oal"
			'response.end
			objFSO.DeleteFile FindUploadPath & "\upload\" & strRetArquivo
		end if 

		' Renomeia o arquivo especificado na tela de update		
		strRetNewArquivo = "AG_" & Day(now) & Month(now) & Year(now) & Hour(now) & Minute(now) & Second(now) & "_" & strArquivoAnexo 
		
		if objFSO.FileExists(FindUploadPath & "\upload\" & strArquivoAnexo) then
			'response.write strArquivoAnexo & " " & strRetArquivo
			'response.end 
			objFSO.MoveFile FindUploadPath & "\upload\" & strArquivoAnexo, FindUploadPath & "\upload\" & strRetNewArquivo
			strArquivoAnexo = strRetNewArquivo
			Set objFSO = Nothing
		end If 
	end If 
end if

if mid(strCITADOS,1,1)<>";" then strCITADOS = ";" & strCITADOS 
if mid(strCITADOS,Len(strCITADOS))<>";" then strCITADOS = strCITADOS & ";"
 
if strCOD="" or strCITADOS="" or strTITULO="" or strCODCATEGORIA="" or strSITUACAO="" or strPRIORIDADE="" then
	Response.Write("<p align='center'>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
	Response.Write(strCOD & "<br>" & strCITADOS & "<br>" & strTITULO & "<br>" & strCODCATEGORIA & "<br>" & strSITUACAO & "<br>" & strPRIORIDADE)
	Response.End()
end if

strDTT_INI = strPREV_DT_INI
strCODCATEGORIA = mid(strCODCATEGORIA,1,InStr(strCODCATEGORIA," ")-1) 'Extrai aopenas o Código da cateroria da String

if not IsDate(strPREV_DT_INI)  then strPREV_DT_INI  = "Null" else strPREV_DT_INI  = "'" & PrepDataBrToUni(strPREV_DT_INI,true) & "'"
if not IsDate(strDT_REALIZADO) then strDT_REALIZADO = "Null" else strDT_REALIZADO = "'" & PrepDataBrToUni(strDT_REALIZADO,true) & "'"
if not IsDate(strDtAnt)        then strDtAnt = "Null"

if strHORAS<>"" then
	If not IsNumeric(strHORAS) then
		Response.Write("<p align='center'>O valor de horas dispendidas deve ser numérico<br>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
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

AbreDBConn objConn, CFG_DB

strSQL =  "	UPDATE AG_AGENDA SET " &_ 
			 "  ID_RESPONSAVEL = '"   & strRESPONSAVEL  & "'" & " ,ID_CITADOS	= '" 	& strCITADOS    & "',ARQUIVO_ANEXO = '" & strArquivoAnexo & "'"& _
			 " ,TITULO 	 = '"         & strTITULO       & "'" & " ,DESCRICAO 	= '"  & strDESCRICAO  & "'" & _
			 " ,SITUACAO = '"         & strSITUACAO     & "'" & " ,PRIORIDADE	= '"  & strPRIORIDADE & "'" & _
			 " ,COD_CATEGORIA = "     & strCODCATEGORIA &_ 
			 " ,PREV_DT_INI = "       & strPREV_DT_INI  & "  ,PREV_HORAS = "     & strHORASeMINUTOS &_ 
			 " ,DT_REALIZADO 	= "     & strDT_REALIZADO & _
			 " WHERE COD_AGENDA = "   & strCOD 
objConn.Execute(strSQL) 
 
'Se trocou a Data de Agendamento então grava uma resposta (de sistema) para "log" desta operação --------------------------------------------
if (strDtAnt<>strDT_INI) then
	strSQL = " INSERT INTO AG_RESPOSTA (COD_AGENDA, ID_FROM, ID_TO, RESPOSTA, DTT_RESPOSTA) VALUES ( " &_
				"'" & strCOD & "','" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "','" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "'," &_
				" '" & "MENSAGEM DO SISTEMA - Data de agendamento alterada de " & Replace(Replace(strDtAnt,"Null","vazio"),"'","") & " para " & Replace(Replace(strDT_INI,"Null","vazio"),"'","") & "', Now() )"
	objConn.Execute(strSQL)
end if
'--------------------------------------------------------------------------------------------------------------------------------------------

if mid(strCITADOS,1,1)=";" then strCITADOS = mid(strCITADOS,2)	


'INIC: Envio de EMAIL -----------------------------------------------------------------------------------------------------------------------
if strCITADOS<>"" then
	auxTpMsg = 1
	auxSTR = "Alteração de Agenda"

	if strSITUACAO="FECHADO" then 
		auxTpMsg = 4 
		auxSTR="Fechamento de Agenda"
	end if

	MontaBody strBodyMsg 	_
				,auxTpMsg 		_
				,auxSTR,""		_
				,strTITULO 		_
				,strSITUACAO 	_
				,strDESCCATEGORIA _
				,strPRIORIDADE 	_
				,strRESPONSAVEL 	_
				,strCITADOS 		_
				,strDTT_INI		 	_
				,GetParam("var_dt_realizado") _
				,Replace(strDESCRICAO,"<ASLW_APOSTROFE>","'") _
				,"" _
				,"AGENDA"_
				,""
	
	'-- Busca o email dos citados -------------------------------
	strDestMail = Replace(strCITADOS," ","")
	strDestMail = "'" & Replace(strDestMail,";","','") & "'"
	
	strSQL = "SELECT EMAIL FROM USUARIO WHERE	ID_USUARIO IN (" & strDestMail & ")"	
	Set objRS = objConn.Execute(strSQL)
	
	strDestMail = ""	
	while not objRS.Eof
		strDestMail = strDestMail & GetValue(objRS, "EMAIL") & ";"
		objRS.MoveNext
	wend
	'------------------------------------------------------------------			 
	AthEnviaMail strDestMail _
					,"virtualboss@virtualboss.com.br",""	_
					,"ath.virtualboss@gmail.com"		_
					,Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: Agenda"	_
					,strBodyMsg,1,0,0,""		 
end if
'FIM: Envio de EMAIL ------------------------------------------------------------------------------------------------------------------------

FechaDBConn objConn

response.write "<script>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'")
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "'"
response.write "</script>"
%>