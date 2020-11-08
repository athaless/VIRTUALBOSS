<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<!--#include file="../_database/athEnviaAlert.asp"--> 
<!--#include file="../_scripts/scripts.js"-->
<%
Session.LCID = 1046 

Dim strSQL, objRS, objRSCT, objRS1, objRS2, v3, ObjConn
Dim strBodyMsg, auxTpMsg, strARQUIVO_ANEXO
Dim auxSTR, strCOD_DADO, strCOD_BOLETIM, strTITULO, strPRIORIDADE, strRESPONSAVEL, strEXECUTOR
Dim strSITUACAO, strSITUACAO_BS, strDESCRICAO, strPREV_DT_INI, strPREV_HR_INI
Dim strCODCATEGORIA, strDESCCATEGORIA, strHORAS, strMINUTOS, strHORASeMINUTOS, strVINCULO_CHAMADO
Dim strDT_INI, strDtAnt_INI, strBodyBoletim, strBS_TIPO
Dim objFSO	
Dim strEMAILS_MANAGER, strEMAIL_EXECUTOR
Dim strJSCRIPT_ACTION, strLOCATION

Dim i, strQTDEINPUTS  
Dim arrAnexo(), arrAnexoDesc()

strCOD_DADO       = GetParam("var_cod_todolist")
strCOD_BOLETIM    = GetParam("var_cod_boletim")
strTITULO         = GetParam("var_titulo")
strRESPONSAVEL    = LCase(GetParam("var_id_responsavel"))
strEXECUTOR       = LCase(GetParam("var_id_ult_executor"))
strSITUACAO       = GetParam("var_situacao")
strPRIORIDADE     = GetParam("var_prioridade")
strDESCRICAO      = Replace(GetParam("var_descricao"),"'","<ASLW_APOSTROFE>")
strPREV_DT_INI    = GetParam("var_prev_dt_ini")
strPREV_HR_INI    = GetParam("var_prev_hr_ini_hora") & ":" & GetParam("var_prev_hr_ini_min")
strCODCATEGORIA   = GetParam("var_cod_e_desc_categoria")
strDESCCATEGORIA  = GetParam("var_cod_e_desc_categoria") 'Apenas para o e-mail
strDtAnt_INI      = GetParam("var_data_ini_ant")
strARQUIVO_ANEXO  = GetParam("var_arquivo_anexo")
strHORAS          = GetParam("var_prev_horas")
strMINUTOS        = GetParam("var_prev_minutos")
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
'for i=1 to Cint(strQTDEINPUTS) 
' response.write ("posicao "& i &" : "&arrAnexo(i)&" -- "&arrAnexoDesc(i)&"<br>")  
'next
'response.end
'FIM: ANEXOS ------------------------------------------------------------------

strDT_INI = strPREV_DT_INI

if strCOD_DADO="" or strRESPONSAVEL="" or strTITULO="" or strCODCATEGORIA="" or strSITUACAO="" or strPRIORIDADE=""  then
	Response.Write("<p align='center'>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
	Response.End()
end if

strCODCATEGORIA = mid(strCODCATEGORIA,1,InStr(strCODCATEGORIA," ")-1) 'Extrai apenas o Código da categoria da String

if not IsDate(strPREV_DT_INI) then strPREV_DT_INI = "Null" else strPREV_DT_INI = "'" & PrepDataBrToUni(strPREV_DT_INI,true) & "'"

If strPREV_HR_INI = ":" Then 
	strPREV_HR_INI = ""
Else
	If InStr(strPREV_HR_INI, ":") = 1                   Then strPREV_HR_INI = "00" & strPREV_HR_INI
	If InStr(strPREV_HR_INI, ":") = Len(strPREV_HR_INI) Then strPREV_HR_INI = strPREV_HR_INI & "00"
End If

if strHORAS<>"" then
	if not IsNumeric(strHORAS) then
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

strSQL = "UPDATE TL_TODOLIST SET " &_ 
			"  ID_RESPONSAVEL = '"   & strRESPONSAVEL  & "'" & " ,ID_ULT_EXECUTOR= '" & strEXECUTOR     & "',ARQUIVO_ANEXO = '" & strARQUIVO_ANEXO & "'"& _
			" ,TITULO = '"           & strTITULO       & "'" & " ,DESCRICAO = '"      & strDESCRICAO    & "'" & _
			" ,SITUACAO = '"         & strSITUACAO     & "'" & " ,PRIORIDADE = '"     & strPRIORIDADE   & "'" & _
			" ,COD_CATEGORIA = "     & strCODCATEGORIA &_ 
			" ,PREV_DT_INI = "       & strPREV_DT_INI  & "       ,PREV_HR_INI = '"    & strPREV_HR_INI  & "' ,PREV_HORAS = "    & strHORASeMINUTOS &_ 
			" WHERE COD_TODOLIST = " & strCOD_DADO
'AQUI: NEW TRANSACTION
set objRSCT = objConn.Execute("start transaction")
set objRSCT = objConn.Execute("set autocommit = 0")
objConn.Execute(strSQL) 
if Err.Number<>0 then 
  set objRSCT= objConn.Execute("rollback")
  athSaveLog "UPD", Request.Cookies("VBOSS")("ID_USUARIO"), "ROLLBACK TL_TODOLIST", strSQL
  Mensagem "modulo_TOTOLIST.update_exec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
  Response.End()
else	  
  set objRSCT= objConn.Execute("commit")
  athSaveLog "UPD", Request.Cookies("VBOSS")("ID_USUARIO"), "COMMIT TL_TODOLIST", strSQL
End If

'INI: Insere anexos --------------------------------------
strSQL = " DELETE FROM TL_ANEXO WHERE COD_TODOLIST = " & strCOD_DADO
set objRS  = objConn.Execute("start transaction")
set objRS  = objConn.Execute("set autocommit = 0")
objConn.Execute(strSQL) 
If Err.Number <> 0 Then
  set objRS = objConn.Execute("rollback")
  athSaveLog "DEL", Request.Cookies("VBOSS")("ID_USUARIO"), "ROLLBACK TL_ANEXO", strSQL
  Mensagem Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
else
  set objRS = objConn.Execute("commit")
  athSaveLog "DEL", Request.Cookies("VBOSS")("ID_USUARIO"), "COMMIT TL_ANEXO", strSQL
End If

for i=1 to Cint(strQTDEINPUTS)
  if arrAnexo(i)<>"" then
	strSQL = " INSERT INTO TL_ANEXO (COD_TODOLIST, ARQUIVO, DESCRICAO, SYS_DTT_INS, SYS_ID_USUARIO_INS) "
	strSQL = strSQL & " VALUES (" & strCOD_DADO & ",'" & arrAnexo(i) & "','" & arrAnexoDesc(i) & "','" & PrepDataBrToUni(Now, True) & "','" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "' )"
	set objRS  = objConn.Execute("start transaction")
	set objRS  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL) 
	If Err.Number <> 0 Then
	  set objRS = objConn.Execute("rollback")
	  athSaveLog "INS", Request.Cookies("VBOSS")("ID_USUARIO"), "ROLLBACK TL_ANEXO", strSQL
	  Mensagem Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	else
	  set objRS = objConn.Execute("commit")
	  athSaveLog "INS", Request.Cookies("VBOSS")("ID_USUARIO"), "COMMIT TL_ANEXO", strSQL
	End If
  end if 
next
'FIM: Insere anexos --------------------------------------


'Se trocou a Data de Agendamento então grava uma resposta (de sistema) para "log" desta operação
if (strDtAnt_INI<>strDT_INI) then
	strSQL = " INSERT INTO TL_RESPOSTA (COD_TODOLIST, ID_FROM, ID_TO, RESPOSTA, DTT_RESPOSTA) VALUES ( " &_
			" " & strCOD_DADO & ",'" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "','" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "'," &_
			" '" & "MENSAGEM DO SISTEMA - Data prevista alterada de " & strDtAnt_INI & " para " & strDT_INI & "', '" & PrepDataBrToUni(Now, True) & "')"
	'AQUI: NEW TRANSACTION
	set objRSCT = objConn.Execute("start transaction")
	set objRSCT = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	if Err.Number<>0 then 
	  set objRSCT= objConn.Execute("rollback")
	  Mensagem "modulo_TOTOLIST.update_exec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	  Response.End()
	else	  
	  set objRSCT= objConn.Execute("commit")
	End If
end if

'Envio de EMAIL
If strCOD_BOLETIM <> "" Then
	'Altera situação da atividade
	MudaSituacaoBS objConn, strCOD_BOLETIM
	
	' Informações do boletim no email
	strBodyBoletim = ""
	strSQL = " SELECT T1.TITULO, T1.ID_RESPONSAVEL, T1.MODELO, T2.COD_CATEGORIA, T2.NOME AS CATEGORIA, T3.NOME_COMERCIAL AS CLIENTE " &_
			 " FROM BS_BOLETIM T1 " &_
			 " LEFT OUTER JOIN BS_CATEGORIA T2 ON (T1.COD_CATEGORIA=T2.COD_CATEGORIA) " &_
			 " LEFT OUTER JOIN ENT_CLIENTE T3 ON (T1.COD_CLIENTE=T3.COD_CLIENTE) " &_
			 " WHERE COD_BOLETIM =" & strCOD_BOLETIM
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1		
	
	strBS_TIPO = ""
	if not objRS.Eof then
		strBS_TIPO = GetValue(objRS,"MODELO")
		strBodyBoletim = strBodyBoletim &_
		"<tr><td align='right' valign='top' width='10%' nowrap>Boletim:&nbsp;</td><td width='90%'>"		& strCOD_BOLETIM & "&nbsp;-&nbsp;" & GetValue(objRS,"TITULO") &	"</td></tr>" & VbCrlf &_
		"<tr><td align='right' valign='top' width='10%' nowrap>Categoria:&nbsp;</td><td width='90%'>"	& GetValue(objRS,"COD_CATEGORIA") & "&nbsp;-&nbsp;" & GetValue(objRS,"CATEGORIA") & "</td></tr>" & VbCrlf &_
		"<tr><td align='right' valign='top' width='10%' nowrap>Cliente:&nbsp;</td><td width='90%'>"		& GetValue(objRS,"CLIENTE") & "</td></tr>" & VbCrlf &_
		"<tr><td align='right' valign='top' width='10%' nowrap>Responsável:&nbsp;</td><td width='90%'>"	& GetValue(objRS,"ID_RESPONSAVEL") & "</td></tr>" & VbCrlf &_
		"<tr><td height='16px'></td></tr>" & VbCrlf &_
		"<tr><td colspan='2'><table width='90%' align='center' cellspacing='0' cellpadding='1' border='0'><tr><td height='1' bgcolor='#C9C9C9'></td></tr></table></tr>" & VbCrlf &_
		"<tr><td height='16px'></td></tr>" & VbCrlf
	end if
	FechaRecordSet objRS
	
	if strEXECUTOR<>"" and strBS_TIPO<>"MODELO" then
		auxTpMsg = 1
		auxSTR = "Alteração da Tarefa"
		'if strSITUACAO="FECHADO" then 
		'	auxTpMsg = 4 
		'	auxSTR = "Fechamento de Tarefa"
		'end if
		
		strEMAIL_EXECUTOR = BuscaUserEMAIL(ObjConn, Replace(strEXECUTOR,"'",""))
		strEMAILS_MANAGER = BuscaManagerEMAILS(ObjConn, "|" & strEMAIL_EXECUTOR & "|")
		
		MontaBody strBodyMsg _
					,auxTpMsg _
					,auxSTR _
					,"" _
					,strTITULO,strSITUACAO _
					,strDESCCATEGORIA _
					,strPRIORIDADE 	_
					,strRESPONSAVEL _
					,strEXECUTOR _
					,GetParam("var_prev_dt_ini") & " " & strPREV_HR_INI _
					,GetParam("var_dt_realizado") _
					,Replace(strDESCRICAO,"<ASLW_APOSTROFE>","'") _
					,strBodyBoletim _
					,"TODOLIST" _
					,""
		
		AthEnviaMail strEMAIL_EXECUTOR,"virtualboss@virtualboss.com.br",strEMAILS_MANAGER,"ath.virtualboss@gmail.com",Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList (" & strEXECUTOR & ")",strBodyMsg,1, 0, 0,""
	end if
Else
	if strEXECUTOR<>"" and strSITUACAO<>"OCULTO" then
		'Verifica se ToDo está relacionado a um chamado, se tiver deve afetar o conteúdo do email de aviso
		strVINCULO_CHAMADO = VerificaVinculoChamado(objConn, strCOD_DADO)

		auxTpMsg = 1
		auxSTR = "Alteração da Tarefa"
		
		strEMAIL_EXECUTOR = BuscaUserEMAIL(ObjConn, Replace(strEXECUTOR,"'",""))
		strEMAILS_MANAGER = BuscaManagerEMAILS(ObjConn, "|" & strEMAIL_EXECUTOR & "|")
		
		MontaBody strBodyMsg _
					,auxTpMsg _
					,auxSTR _
					,"" _
					,strTITULO _
					,strSITUACAO _
					,strDESCCATEGORIA _
					,strPRIORIDADE _
					,strRESPONSAVEL	_
					,strEXECUTOR _
					,strDT_INI & " " & strPREV_HR_INI _
					,"" _
					,Replace(strDESCRICAO,"<ASLW_APOSTROFE>","'") _
					,"" _
					,"TODOLIST" _
					,strVINCULO_CHAMADO
		
		If strVINCULO_CHAMADO = "T" Then
			AthEnviaMail strEMAIL_EXECUTOR, "virtualboss@virtualboss.com.br", strEMAILS_MANAGER, "ath.virtualboss@gmail.com", Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList", strBodyMsg,1,0,0,""
		Else
			AthEnviaMail strEMAIL_EXECUTOR, "virtualboss@virtualboss.com.br", strEMAILS_MANAGER, "ath.virtualboss@gmail.com", Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: ToDoList (" & strEXECUTOR & ")", strBodyMsg,1,0,0,""
		End If
	end if
End If

FechaDBConn objConn

response.write "<script>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'")
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "'"
response.write "</script>"
%>