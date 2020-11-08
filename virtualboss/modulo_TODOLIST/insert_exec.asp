<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<!--#include file="../_database/athEnviaAlert.asp"-->
<%
Session.LCID = 1046 

Dim strSQL, objRS, objRSAux, ObjConn
Dim strTITULO, strPRIORIDADE, strRESPONSAVEL, strEXECUTOR, strSITUACAO, strDESCRICAO, strPREV_DT_INI, strPREV_HR_INI
Dim strDT_REALIZADO, strCODCATEGORIA, strDESCCATEGORIA, strARQUIVO_ANEXO, strHORAS, strMINUTOS, strHORASeMINUTOS, strCOD_CLI
Dim strEMAILS_MANAGER, strEMAIL_EXECUTOR, strJSCRIPT_ACTION, strLOCATION, strCOD_BOLETIM, strDADOS_BOLETIM
Dim strBodyMsg, strBodyBoletim, strMSG, strDT_AGORA, strCOD_TODOLIST
Dim strAuxARQUIVO_ANEXO, auxStr, strLogicalPath, strMsgUser

Dim i, strQTDEINPUTS  
Dim arrAnexo(), arrAnexoDesc()

strCOD_BOLETIM	  = GetParam("var_boletim")
strTITULO         = GetParam("var_titulo")
strRESPONSAVEL    = LCase(GetParam("var_id_responsavel"))
strEXECUTOR       = LCase(GetParam("var_id_executor"))
strSITUACAO       = GetParam("var_situacao")
strPRIORIDADE     = GetParam("var_prioridade")
strDESCRICAO      = Replace(GetParam("var_descricao"),"'","<ASLW_APOSTROFE>")
strPREV_DT_INI    = GetParam("var_prev_dt_ini")
strPREV_HR_INI    = GetParam("var_prev_hr_ini_hora") & ":" & GetParam("var_prev_hr_ini_min")
strDT_REALIZADO   = GetParam("var_dt_realizado")
strCODCATEGORIA   = GetParam("var_cod_e_desc_categoria")
strDESCCATEGORIA  = GetParam("var_cod_e_desc_categoria") 'Apenas para o e-mail
strARQUIVO_ANEXO  = GetParam("var_arquivo_anexo")
strHORAS          = GetParam("var_prev_horas")
strMINUTOS        = GetParam("var_prev_minutos")
strCOD_CLI        = GetParam("var_cod_cli")
strJSCRIPT_ACTION = GetParam("JSCRIPT_ACTION")
strLOCATION       = GetParam("DEFAULT_LOCATION")

'INI: ANEXOS ------------------------------------------------------------------
' Busca imagens/descrições anexas colocando-as em respectivos arrays 
' obs. o que determina se vai ser gravado ou não é o campo referente ao arquivo
i = 1
strQTDEINPUTS = GetParam("QTDE_INPUTS")
redim arrAnexo(strQTDEINPUTS)
redim arrAnexoDesc(strQTDEINPUTS)
While (i<=Cint(strQTDEINPUTS))
  arrAnexo(i)	 = GetParam("var_anexo_" & i)
  arrAnexoDesc(i) = GetParam("var_anexodesc_" & i)
  i = i + 1
WEnd
'DEBUG
'for i=1 to Cint(strQTDEINPUTS) response.write ("posicao "& i &" : "&arrAnexo(i)&" -- "&arrAnexoDesc(i)&"<br>")  next
'response.end
'FIM: ANEXOS ------------------------------------------------------------------


strMSG = ""
If strRESPONSAVEL = ""  Then strMSG = strMSG & "<br>Informar responsável"
If strEXECUTOR = ""     Then strMSG = strMSG & "<br>Informar executor"
If strTITULO = ""       Then strMSG = strMSG & "<br>Informar título"
If strCODCATEGORIA = "" Then strMSG = strMSG & "<br>Informar categoria"
If strSITUACAO = ""     Then strMSG = strMSG & "<br>Informar situação"
If strPRIORIDADE = ""   Then strMSG = strMSG & "<br>Informar prioridade"
If strDESCRICAO = ""    Then strMSG = strMSG & "<br>Informar descrição"

If strMSG <> "" Then
	Response.write("Favor rever parâmetros" & strMSG)
	Response.End()
End If
strCODCATEGORIA = Mid(strCODCATEGORIA,1,InStr(strCODCATEGORIA," ")-1) 'Extrai apenas o Código da categoria da String

If strHORAS<>"" then
	if not isNumeric(strHORAS) then
	  Response.write("<p align='center'>O valor de horas dispendidas deve ser numérico<br>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
	  Response.End()
	else
	  strHORASeMINUTOS = strHoras & "." & strMinutos
	end if
Else
	if (CInt(strMinutos)>0) then  
		strHORASeMINUTOS = "0." & Cstr(strMinutos) 
	else 
		strHORASeMINUTOS ="NULL" 
	end if
End If


AbreDBConn objConn, CFG_DB
'response.write(objConn)
'response.end()




if strDT_REALIZADO = "" then strDT_REALIZADO = "NULL" else strDT_REALIZADO = "'" & PrepDataBrToUni(strDT_REALIZADO, true) & "'" end if
if strPREV_DT_INI = "" then strPREV_DT_INI = "NULL" else strPREV_DT_INI = "'" & PrepDataBrToUni(strPREV_DT_INI, true) & "'" end if
If strPREV_HR_INI = ":" Then 
	strPREV_HR_INI = ""
Else
	If InStr(strPREV_HR_INI, ":") = 1                   Then strPREV_HR_INI = "00" & strPREV_HR_INI
	If InStr(strPREV_HR_INI, ":") = Len(strPREV_HR_INI) Then strPREV_HR_INI = strPREV_HR_INI & "00"
End If

'Consistencia no COD_BOLETIM
if strCOD_BOLETIM = "" then strCOD_BOLETIM = "NULL"
if strCOD_CLI = "" then strCOD_CLI = "NULL"
strDT_AGORA = "'" & PrepDataBrToUni(Now, true) & "'"

'INI: Insere todolist ------------------------------------
strSQL =          " INSERT INTO TL_TODOLIST (COD_BOLETIM, TITULO, SITUACAO, COD_CATEGORIA, PRIORIDADE, ID_RESPONSAVEL, ID_ULT_EXECUTOR,"
strSQL = strSQL & " PREV_DT_INI, PREV_HR_INI, PREV_HORAS, DT_REALIZADO, DESCRICAO, ARQUIVO_ANEXO, SYS_ID_USUARIO_INS, SYS_DTT_INS, COD_CLI) " 
strSQL = strSQL & " VALUES (" & strCOD_BOLETIM & ", '" & strTITULO & "', '" & strSITUACAO & "', " & strCODCATEGORIA & ", '" & strPRIORIDADE & "', "  
strSQL = strSQL & "'" & strRESPONSAVEL & "','" & strEXECUTOR & "'," & strPREV_DT_INI & ", '" & strPREV_HR_INI & "', " & strHORASeMINUTOS & ", " & strDT_REALIZADO & ", "
strSQL = strSQL & "'" & strDESCRICAO & "','" & strARQUIVO_ANEXO & "','" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "', " & strDT_AGORA & "," & strCOD_CLI & ")" 
'response.write(strSQL)
set objRS  = objConn.Execute("start transaction")
set objRS  = objConn.Execute("set autocommit = 0")
objConn.Execute(strSQL) 

'response.end()
If Err.Number <> 0 Then
  set objRS = objConn.Execute("rollback")
  athSaveLog "INS", Request.Cookies("VBOSS")("ID_USUARIO"), "ROLLBACK TL_TODOLIST", strSQL
  Mensagem Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
else
  set objRS = objConn.Execute("commit")
  athSaveLog "INS", Request.Cookies("VBOSS")("ID_USUARIO"), "COMMIT TL_TODOLIST", strSQL
End If
'FIM: Insere todolist ------------------------------------

strSQL =          " SELECT MAX(COD_TODOLIST) AS CODIGO FROM TL_TODOLIST "
strSQL = strSQL & "  WHERE TITULO LIKE '" & strTITULO & "' "
strSQL = strSQL & "    AND SYS_ID_USUARIO_INS LIKE '" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "' "
strSQL = strSQL & "    AND SYS_DTT_INS = " & strDT_AGORA

Set objRS = objConn.Execute(strSQL)

strCOD_TODOLIST = ""
If Not objRS.Eof Then
	If GetValue(objRS, "CODIGO") <> "" Then strCOD_TODOLIST = GetValue(objRS, "CODIGO")
End If
FechaRecordSet objRS


If strCOD_TODOLIST<>"" Then
	'INI: Insere anexos --------------------------------------
	for i=1 to Cint(strQTDEINPUTS)
	  if arrAnexo(i)<>"" then
		strSQL = " INSERT INTO TL_ANEXO (COD_TODOLIST, ARQUIVO, DESCRICAO, SYS_DTT_INS, SYS_ID_USUARIO_INS) "
		strSQL = strSQL & " VALUES (" & strCOD_TODOLIST & ",'" & arrAnexo(i) & "','" & arrAnexoDesc(i) & "'," & strDT_AGORA & ",'" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "' )"
		'response.write strSQL
		'response.end

		set objRS  = objConn.Execute("start transaction")
		set objRS  = objConn.Execute("set autocommit = 0")
		objConn.Execute(strSQL) 
		If Err.Number <> 0 Then
		  set objRS = objConn.Execute("rollback")
		  athSaveLog "INS", Request.Cookies("VBOSS")("ID_USUARIO"), "ROLLBACK TL_ANEXO", strSQL
		  Mensagem Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		else
		 ' set objRS = objConn.Execute("commit")
		  athSaveLog "INS", Request.Cookies("VBOSS")("ID_USUARIO"), "COMMIT TL_ANEXO", strSQL
		End If
	  end if 
	next
	'FIM: Insere anexos --------------------------------------
end if

'INIC: Envio de EMAIL -----------------------------------------------------------------------------------------------------------------------
if strEXECUTOR<>"" then
	strBodyBoletim = ""
	strDADOS_BOLETIM = ""
	
	if strCOD_BOLETIM <> "NULL" and strCOD_BOLETIM <> "" then
		'Informações do boletim no email
		strSQL =          " SELECT T1.TITULO, T1.ID_RESPONSAVEL, T1.MODELO, T2.COD_CATEGORIA, T2.NOME AS CATEGORIA, T3.NOME_COMERCIAL AS CLIENTE "
		strSQL = strSQL & " FROM BS_BOLETIM T1 "
		strSQL = strSQL & " LEFT OUTER JOIN BS_CATEGORIA T2 ON (T1.COD_CATEGORIA = T2.COD_CATEGORIA) "
		strSQL = strSQL & " LEFT OUTER JOIN ENT_CLIENTE T3 ON (T1.COD_CLIENTE = T3.COD_CLIENTE) "
		strSQL = strSQL & " WHERE COD_BOLETIM = " & strCOD_BOLETIM
		
		AbreRecordSet objRSAux, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1		
		
		if not objRSAux.Eof then
			if GetValue(objRSAux,"MODELO") <> "MODELO" then
				strDADOS_BOLETIM = GetValue(objRSAux,"CLIENTE") & " - " & GetValue(objRSAux,"TITULO")
				
				strBodyBoletim = strBodyBoletim &_
				"<tr><td align='right' valign='top' width='10%' nowrap>Boletim:&nbsp;</td><td width='90%'>"     & strCOD_BOLETIM & "&nbsp;-&nbsp;" & GetValue(objRSAux,"TITULO") & "</td></tr>" & VbCrlf &_
				"<tr><td align='right' valign='top' width='10%' nowrap>Categoria:&nbsp;</td><td width='90%'>"   & GetValue(objRSAux,"COD_CATEGORIA") & "&nbsp;-&nbsp;" & GetValue(objRSAux,"CATEGORIA") & "</td></tr>" & VbCrlf &_
				"<tr><td align='right' valign='top' width='10%' nowrap>Cliente:&nbsp;</td><td width='90%'>"     & GetValue(objRSAux,"CLIENTE") & "</td></tr>" & VbCrlf &_
				"<tr><td align='right' valign='top' width='10%' nowrap>Responsável:&nbsp;</td><td width='90%'>" & GetValue(objRSAux,"ID_RESPONSAVEL") & "</td></tr>" & VbCrlf &_
				"<tr><td height='16px'></td></tr>" & VbCrlf &_
				"<tr><td colspan='2'><table width='90%' align='center' cellspacing='0' cellpadding='1' border='0'><tr><td height='1' bgcolor='#C9C9C9'></td></tr></table></tr>" & VbCrlf &_
				"<tr><td height='16px'></td></tr>" & VbCrlf
			end if
		end if
		FechaRecordSet objRSAux
	end if
	
	strEMAIL_EXECUTOR = BuscaUserEMAIL(ObjConn, strEXECUTOR)
	strEMAILS_MANAGER = BuscaManagerEMAILS(ObjConn, "|" & strEMAIL_EXECUTOR & "|")
	
	'Monta Tabela com anexos principal do ToDo (Documento).
	if ((strARQUIVO_ANEXO <> "") or (uBound(arrAnexo) > 0)) Then	
		strLogicalPath = FindLogicalPath()
		auxStr = "<table width='100%' border='0' cellpadding='1' cellspacing='0' style='font-family:Tahoma, Verdana; font-size:11;'>"
		auxStr = auxStr & "<tr><td align=right valign=top width=10% nowrap>Documento:&nbsp;</td><td width='90%'>"
		if (strARQUIVO_ANEXO <> "")	Then			
			strauxARQUIVO_ANEXO = strLogicalPath & "/athDownloader.asp?var_cliente="& Request.Cookies("VBOSS")("CLINAME") & "&var_tipo=TODO_Anexos&var_arquivo=" & strARQUIVO_ANEXO	
			auxStr = auxStr & "<a href='" & strauxARQUIVO_ANEXO & "' "
			auxStr = auxStr & " style='cursor:hand;text-decoration:none;' target='_blank'><img src='" & ConvTipoToIcon(5) & "' border='0' title='Documento' alt='Documento'>&nbsp;DOWNLOAD&nbsp;</a><small>"
			auxStr = auxStr & "&nbsp;&nbsp;" & Replace(strARQUIVO_ANEXO,"}_","}_<b>") & "</b></small></td></tr>"	
		Else 
			auxStr = auxStr & "</td></tr>"	
		End If		

    	'Monta demais anexos do ToDo
		if (uBound(arrAnexo) > 0) Then	
			auxStr = auxStr & "<tr><td>&nbsp;</td><td><hr></td></tr>"
			auxStr = auxStr & "<tr><td align='right' valign='top'>Anexos:&nbsp;</td>"
			auxStr = auxStr & "<td>"
			for i=1 to uBound(arrAnexo)
			    if (arrAnexo(i) <> "") Then 
					auxStr = auxStr & "<div style='margin-bottom:10px;'><div>"						
					auxStr = auxStr & "<a href='" & strLogicalPath & "/athDownloader.asp?var_cliente=" & Request.Cookies("VBOSS")("CLINAME") & "&var_tipo=TODO_Anexos&var_arquivo=" & arrAnexo(i) & "' " 
					auxStr = auxStr & " style='cursor:hand;text-decoration:none;' target='_blank'>"
					auxStr = auxStr & "	<img src='" & ConvTipoToIcon(5) &"' border='0' title='Documento' alt='Documento'>&nbsp;DOWNLOAD&nbsp;</a><small>&nbsp;&nbsp; "
					auxStr = auxStr & Replace(arrAnexo(i),"}_","}_<b>") & "</b></small></div> "
					auxStr = auxStr & " <div>" & arrAnexoDesc(i) & "</div></div>"	
				End If
			Next 
			auxStr = auxStr & "</td></tr>"	
     		'Mensagem que instrui o usuário a buscar os arquivos diretamene no VBOSS, caso não consiga visualizá-los ou baixá-los.
		    strMsgUser = "<i>ATENÇÃO: Caso não consiga realizar o download, acesse o arquivo diretamente no VirtualBOSS.</i>"
		    auxStr = auxStr & "<tr height='10px'><td></td><td></td></tr>" & vbcrLF & "<tr><td align='right' valign='top' width='10%' nowrap>&nbsp;</td><td width='90%'>" & strMsgUser  & "</td></tr>" & vbcrLF
			auxStr = auxStr & "</table><br>"
		End If			
	strBodyMsg =  auxStr	
	End If	
	
	MontaBody strBodyMsg _
				,0 _
				,"Inclusão da Tarefa" _
				,strCOD_TODOLIST _
				,strTITULO _
				,strSITUACAO _
				,strDESCCATEGORIA _
				,strPRIORIDADE _
				,strRESPONSAVEL _
				,strEXECUTOR _
				,GetParam("var_prev_dt_ini") & " " & strPREV_HR_INI _
				,GetParam("var_dt_realizado") _
				,Replace(strDESCRICAO,"<ASLW_APOSTROFE>","'") _
				,strBodyBoletim _
				,"TODOLIST"_
				,""
	If strDADOS_BOLETIM <> "" Then
		AthEnviaMail strEMAIL_EXECUTOR,"virtualboss@virtualboss.com.br",strEMAILS_MANAGER,"ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList (" & strEXECUTOR & ") Atividade (" & strDADOS_BOLETIM & ")",strBodyMsg,1,0,0,""
	Else
		AthEnviaMail strEMAIL_EXECUTOR,"virtualboss@virtualboss.com.br",strEMAILS_MANAGER,"ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList (" & strEXECUTOR & ")",strBodyMsg,1,0,0,""
	End If
end if
'FIM: Envio de EMAIL ------------------------------------------------------------------------------------------------------------------------

FechaDBConn objConn

response.write "<script>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'")
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "'"
response.write "</script>"
%>