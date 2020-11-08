<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
Session.LCID = 1046

Dim strSQL, objRS, objRSI, ObjConn, strBodyMsg, strDtAnt, auxTpMsg, auxSTR, strDestMail, objRSTs, objRSCT
Dim strCOD, strTITULO, strCODCLIENTE, strSITUACAO
Dim strCODCATEGORIA, strDESCCATEGORIA, strPRIORIDADE
Dim strRESPONSAVEL, strEQUIPE, strFECHA
Dim strDESCRICAO, strTIPO
Dim strArquivoAnexo, strRetArquivo, strArquivo
Dim strHORAS, strMINUTOS, strHORASeMINUTOS 
Dim objFSO
Dim Cont, i, arrID_USUARIO, strID_USUARIO, strEQUIPE_BS, strPOS, strUSUARIOS_COM_RESPOSTA
Dim strJSCRIPT_ACTION, strLOCATION

strCOD            = GetParam("var_cod_boletim")
strTITULO         = Replace(GetParam("var_titulo"),"'","")
strCODCLIENTE	  = GetParam("var_cod_cliente")
strSITUACAO       = GetParam("var_situacao")
strCODCATEGORIA   = GetParam("var_cod_e_desc_categoria")
strPRIORIDADE     = GetParam("var_prioridade")
strRESPONSAVEL    = LCase(GetParam("var_id_responsavel"))
strEQUIPE 		  = Replace(LCase(GetParam("var_equipe"))," ","")
strFECHA		  = Replace(GetParam("var_fecha")," ","")
strDESCRICAO      = Replace(GetParam("var_descricao"),"'","<ASLW_APOSTROFE>")
strTIPO           = GetParam("var_tipo")
strJSCRIPT_ACTION = GetParam("JSCRIPT_ACTION")
strLOCATION       = GetParam("DEFAULT_LOCATION")

if (strCOD="" or strTITULO="" or strCODCLIENTE="" or strSITUACAO="" or strCODCATEGORIA="" or strPRIORIDADE="" or strEQUIPE="") then
	Response.Write("<p align='center'>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
	Response.End()
end if

strEQUIPE = ";" & strEQUIPE & ";"
strCODCATEGORIA = Mid(strCODCATEGORIA,1,InStr(strCODCATEGORIA," ")-1) 'Extrai apenas o código da categoria da string

AbreDBConn ObjConn, CFG_DB

strSQL =	" UPDATE BS_BOLETIM " &_ 
			" SET COD_CLIENTE        = " & strCODCLIENTE   &_
			"   , COD_CATEGORIA      = " & strCODCATEGORIA &_ 
			"   , ID_RESPONSAVEL     = '" & strRESPONSAVEL  & "' " &_
			"   , TITULO             = '" & strTITULO       & "' " &_
			"   , DESCRICAO          = '" & strDESCRICAO    & "' " & _
			"   , SITUACAO           = '" & strSITUACAO     & "' " &_
			"   , PRIORIDADE         = '" & strPRIORIDADE   & "' " & _
			"   , TIPO               = '" & strTIPO         & "' " & _
			"   , SYS_ID_USUARIO_ALT = '" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "' " &_
			"   , SYS_DTT_ALT        = '" & PrepDataBrToUni(Now, true) & "' " &_
			" WHERE COD_BOLETIM = " & strCOD

set objRSTs  = objConn.Execute("start transaction")
set objRSTs  = objConn.Execute("set autocommit = 0")
ObjConn.Execute(strSQL)  
If Err.Number <> 0 Then
  set objRSTs = objConn.Execute("rollback")
  Mensagem "modulo_BS.Update_Exec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
  response.End()
else
  set objRSTs = objConn.Execute("commit")
End If

'-------------------------------------------------------------------
' Busca os usuários que já participaram das tarefas da atividade
'-------------------------------------------------------------------
strSQL = " SELECT ID_RESPONSAVEL AS ID_USUARIO FROM TL_TODOLIST WHERE COD_BOLETIM = " & strCOD &_
		 " UNION " &_
		 " SELECT ID_ULT_EXECUTOR FROM TL_TODOLIST WHERE COD_BOLETIM = " & strCOD
AbreRecordSet objRSI, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
if not objRSI.Eof then
	strUSUARIOS_COM_RESPOSTA = ";"
	while not objRSI.Eof 
		strUSUARIOS_COM_RESPOSTA = strUSUARIOS_COM_RESPOSTA & LCase(GetValue(objRSI, "ID_USUARIO")) & ";"
		objRSI.MoveNext
	wend
end if
FechaRecordSet objRSI

strSQL = "SELECT ID_USUARIO, DT_INATIVO FROM BS_EQUIPE WHERE COD_BOLETIM = " & strCOD
AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1			
while not objRS.Eof	
	strID_USUARIO = LCase(GetValue(objRS, "ID_USUARIO"))
	
	'-------------------------------------------------------------------------------------
	' Se usuário faz parte da equipe verifica se está INATIVO, se estiver então o ATIVA
	'-------------------------------------------------------------------------------------
	if InStr(strEQUIPE, ";" & strID_USUARIO & ";")>0 then
		if GetValue(objRS, "DT_INATIVO")<>"" then
			strSQL = "UPDATE BS_EQUIPE SET DT_INATIVO = NULL WHERE ID_USUARIO = '" & strID_USUARIO & "' AND COD_BOLETIM = " & strCOD
			
			set objRSCT = objConn.Execute("start transaction")
			set objRSCT = objConn.Execute("set autocommit = 0")
			ObjConn.Execute(strSQL)
			if Err.Number<>0 then 
			  set objRSCT= objConn.Execute("rollback")
			  Mensagem "modulo_BS.Update_Exec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
			  response.end
			else	  
			  set objRSCT= objConn.Execute("commit")
			End If
		end if
	else 
		'---------------------------------------------------------------------------------
		' Se usuário NÃO faz parte da equipe verifica se está ATIVO
		' Se estiver ativo e NÃO tiver PARTICIPAÇÃO nas tarefas então INATIVA o usuário
		' Se tiver PARTICIPAÇÃO apenas dá aviso de que não pode ser "retirado"
		'---------------------------------------------------------------------------------
		if GetValue(objRS, "DT_INATIVO")="" then
			if InStr(strUSUARIOS_COM_RESPOSTA, ";" & strID_USUARIO & ";")=0 then
				strSQL = "UPDATE BS_EQUIPE SET DT_INATIVO = '" & PrepDataBrToUni(Date, False) & "' WHERE ID_USUARIO = '" & LCase(GetValue(objRS, "ID_USUARIO")) & "' AND COD_BOLETIM = " & strCOD
				
				set objRSCT = objConn.Execute("start transaction")
				set objRSCT = objConn.Execute("set autocommit = 0")
				ObjConn.Execute(strSQL)
				if Err.Number<>0 then 
				  set objRSCT= objConn.Execute("rollback")
				  Mensagem "modulo_BS.Update_Exec C: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
				  response.end
				end if
			else
				Response.Write("<p align='center'>Não é possível retirar " & strID_USUARIO & " da equipe.<br><a onClick=""location.href='Update.asp?var_chavereg=" & strCOD & "';"" style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
				Response.End()
			end if	
		end if
	end if
	objRS.MoveNext	
wend
FechaRecordSet objRS

'---------------------------------------------------------------------------------------------------------
' Busca os usuários ativos do BS para ver qual dos usuários INFORMADO no CAMPO EQUIPE deve ser inserido
'---------------------------------------------------------------------------------------------------------
strSQL = "SELECT ID_USUARIO FROM BS_EQUIPE WHERE COD_BOLETIM = " & strCOD & " AND DT_INATIVO IS NULL"
AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
if not objRS.Eof then
	strEQUIPE_BS = ";"
	while not objRS.Eof 
		strEQUIPE_BS = strEQUIPE_BS & LCase(GetValue(objRS, "ID_USUARIO")) & ";"
		objRS.MoveNext
	wend
end if
FechaRecordSet objRS

arrID_USUARIO = Split(strEQUIPE, ";")
for each strID_USUARIO in arrID_USUARIO
	if (strID_USUARIO <> "") and (InStr(strEQUIPE_BS,";" & strID_USUARIO & ";")=0) then
		strSQL =          " INSERT INTO BS_EQUIPE (COD_BOLETIM, ID_USUARIO, SYS_DTT_INS, SYS_ID_USUARIO_INS) "
		strSQL = strSQL & " VALUES(" & strCOD & ", '" & strID_USUARIO & "', '" & PrepDataBrToUni(Now, true) & "', '" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "') "
		
		set objRSTs  = objConn.Execute("start transaction")
		set objRSTs  = objConn.Execute("set autocommit = 0")
		ObjConn.Execute(strSQL)  
		If Err.Number <> 0 Then
		  set objRSTs = objConn.Execute("rollback")
		  Mensagem Err.Number & " - "& Err.Description, DEFAULT_LOCATION, 1, True
		Else
		  set objRSTs = objConn.Execute("commit")
		End If		
	end if
next

FechaDBConn objConn

response.write "<script>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'") & ";"
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "';"
response.write "</script>"
%>