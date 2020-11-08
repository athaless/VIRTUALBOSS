<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
	Dim strSQL, objRS, objRSCT, objConn
	Dim intCodNF, intCodCfgNF, intCodCliente, strClienteNome, strObservacao, strDataEmissao, strPrzVcto, strSERIE
	Dim strABERTURA, strMSG, strDT_AGORA
	
	'Dim strIdUsuario, strMsg, dblValorTotal
	'Dim dblValorIRRF, dblValorISSQN, dblValorIRPJ
	'Dim dblValorPIS, dblValorCOFINS, dblValorCSocial
	'Dim dblTotalImposto, dblTotalNota, dblValorReducaoOutros
	'Dim dblValorComissao
	'Dim strIRRF, strREDUCAO_OUTROS, 
	'Dim dblValorIRRF_Acum, strIRRF_Acum, strCOD_NFS_IRRF
	'Dim dblValorREDUCAO_Acum, strREDUCAO_Acum, strCOD_NFS_REDUCAO
	'Dim strSERIE
	
	intCodCfgNF		= GetParam("var_cod_cfg_nf")
	intCodCliente	= GetParam("var_cod_cli")
	strClienteNome	= GetParam("var_cli_nome")
	strObservacao	= GetParam("var_obs_nf")
	strDataEmissao	= GetParam("var_dt_emissao")
	strPrzVcto      = GetParam("var_prz_vcto")
	
	strABERTURA = UCase(GetParam("var_abertura"))
	
	AbreDBConn objConn, CFG_DB 
	
	strMSG = ""
	
	if intCodCliente = "" then strMSG = strMSG & "Informar cliente<br>"
	if intCodCfgNF = "" then strMSG = strMSG & "Parâmetro inválido para modelo de nota<br>"
	
	if strMSG<>"" then 
		Mensagem strMSG, "Javascript:history.back();", "Voltar", 1
		Response.End()
	end if
	
	strObservacao = Replace(strObservacao,"'","<ASLW_APOSTROFE>")
	
	If strDataEmissao <> "" Then
		strDataEmissao = "'" & PrepDataBrToUni(strDataEmissao,true) & "'"
	Else
		strDataEmissao = "NULL"
	End If
	
	strDT_AGORA = "'" & PrepDataBrToUni(Now,true) & "'"
	
	'--------------------------------------------------------
	' Busca série do modelo da nota para gravar na nota
	'--------------------------------------------------------
	strSQL = " SELECT SERIE FROM CFG_NF WHERE DT_INATIVO IS NULL AND COD_CFG_NF = " & intCodCfgNF
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	strSERIE = ""
	if not objRS.eof then strSERIE = GetValue(objRS,"SERIE")
	FechaRecordSet objRS
	
	'--------------------------------------------------------
	' Monta SQL de atualização
	'--------------------------------------------------------
	strSQL =          " INSERT INTO NF_NOTA (COD_CLI, CLI_NOME, SITUACAO, COD_CFG_NF, SERIE, DT_EMISSAO, PRZ_VCTO, OBS_NF, SYS_ID_USUARIO_INS, SYS_DTT_INS) "
	strSQL = strSQL & "	VALUES (" & intCodCliente & ", '" & strClienteNome & "', 'NAO_EMITIDA', " & intCodCfgNF & ", '" & strSERIE & "', " & strDataEmissao & ", '" & strPrzVcto & "', '" & strObservacao & "', '" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "', " & strDT_AGORA & ") "
	
'athDebug strSQL, true
	
	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_FIN_NF.Insert_Exec: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
	End If
	
	strSQL =          " SELECT COD_NF FROM NF_NOTA "
	strSQL = strSQL & " WHERE COD_CLI = " & intCodCliente
	strSQL = strSQL & " AND SITUACAO LIKE 'NAO_EMITIDA' "
	strSQL = strSQL & " AND COD_CFG_NF = " & intCodCfgNF 
	strSQL = strSQL & " AND SYS_ID_USUARIO_INS LIKE '" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "' "
	strSQL = strSQL & " AND SYS_DTT_INS = " & strDT_AGORA
	
	intCodNF = ""
	Set objRS = objConn.Execute(strSQL)
	If Not objRS.Eof Then intCodNF = GetValue(objRS, "COD_NF")
	FechaRecordSet objRS
	
	FechaDBConn objConn
	
	'----------------------------
	'Melhorar isso mais tarde
	'----------------------------
	If strABERTURA = "EXTERNA" Then 
		Response.Redirect("Insert.asp")
	Else
		Response.Redirect("Update.asp?var_chavereg=" & intCodNF)
	End If
%>