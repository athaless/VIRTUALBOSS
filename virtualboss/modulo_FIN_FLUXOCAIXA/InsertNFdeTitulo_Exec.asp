<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
	Dim strSQL, objRS, objRSCT, objConn
	Dim intCodNF, intCodCfgNF, intCodCliente, strClienteNome, strObservacao, strDataEmissao, strPrzVcto, strSERIE
	Dim strMSG, strDT_AGORA, strCODCONTRATO, strCODCONTAPR, strCODSERVICO, strDESCSERVICO, dblValorContaPR, strOBSCONTAPR, dblVlrOrigServ

	strCODCONTAPR   = GetParam("var_cod_conta_pag_rec")
	intCodCliente	= GetParam("var_cod_cli")
	strClienteNome	= GetParam("var_cli_nome")
	strCODCONTRATO  = GetParam("var_cod_contrato")
	dblValorContaPR = GetParam("var_vlr_conta_pag_rec")
	strOBSCONTAPR   = GetParam("var_num_doc")
	intCodCfgNF		= GetParam("var_cod_cfg_nf")
	strObservacao	= GetParam("var_obs_nf")
	strDataEmissao	= GetParam("var_dt_emissao")
	strPrzVcto      = GetParam("var_prz_vcto")

	AbreDBConn objConn, CFG_DB 

	strCODSERVICO = ""
	strDESCSERVICO = ""
	dblVlrOrigServ = Cdbl(0)
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
	
	if strCODCONTRATO = ""  then
	  strCODCONTRATO = "NULL"
	end if
	
	if strCODCONTAPR = "" then
	  strCODCONTAPR = "NULL"
	end if
	
	if strCODCONTRATO <> "NULL" then
		'--------------------------------------------------------
		' Busca o serviço do contrato para inserir na NF
		'--------------------------------------------------------
		strSQL = " SELECT CT.COD_SERVICO, SV.DESCRICAO, SV.VALOR FROM CONTRATO CT JOIN SV_SERVICO SV ON (CT.COD_SERVICO = SV.COD_SERVICO) WHERE CT.COD_CONTRATO=" & strCODCONTRATO
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		
		if not objRS.eof then 
  		  strCODSERVICO  = GetValue(objRS,"COD_SERVICO")
		  strDESCSERVICO = GetValue(objRS,"DESCRICAO")
		  dblVlrOrigServ = GetValue(objRS,"VALOR")
		end if
		
		FechaRecordSet objRS
	end if
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
	'caso venha de contrato adicionamos na obs o campo numero da conta_pagar_receber
	if strOBSCONTAPR <> "" then
	  if strObservacao <> "" then strObservacao = strObservacao & vbCrlf
	  strObservacao = strObservacao & strOBSCONTAPR
	end if
	strSQL =          " INSERT INTO NF_NOTA (COD_CLI, CLI_NOME, SITUACAO, COD_CFG_NF, SERIE, DT_EMISSAO, PRZ_VCTO, OBS_NF, COD_CONTRATO, COD_CONTA_PAGAR_RECEBER, SYS_ID_USUARIO_INS, SYS_DTT_INS) " 
	strSQL = strSQL & "	VALUES (" & intCodCliente & ", '" & strClienteNome & "', 'NAO_EMITIDA', " & intCodCfgNF & ", '" & strSERIE & "', " & strDataEmissao & ", '" & strPrzVcto & "', '" & strObservacao & "', " & strCODCONTRATO & ", " & strCODCONTAPR & ", '" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "', " & strDT_AGORA & ") "
	
'athDebug strSQL, true
	
	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_FIN_FLUXOCAIXA.InsertNFdeTitulo_Exec: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
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
	
    if strCODSERVICO <> "" then 
	  '--------------------------------------------------------
	  ' Caso a nota exista um contrato relacionado inserimos 
	  ' o serviço do contrato na nf.
	  '--------------------------------------------------------
	  dblVlrOrigServ = FormataDouble(FormataDecimal(dblVlrOrigServ, 2))
	  dblValorContaPR = FormataDouble(FormataDecimal(dblValorContaPR, 2))
	  
	  strSQL = " INSERT INTO NF_ITEM     "
	  strSQL = strSQL & " (COD_NF,       "
	  strSQL = strSQL & "  COD_SERVICO,  "
	  strSQL = strSQL & "  TIT_SERVICO,  "
	  strSQL = strSQL & "  DESC_SERVICO, "
	  strSQL = strSQL & "  VALOR_ORIG,   "
	  strSQL = strSQL & "  VALOR)        "
	  strSQL = strSQL & "VALUES ("	
	  strSQL = strSQL & intCodNF & ", "
	  strSQL = strSQL & strCODSERVICO & ", "
	  strSQL = strSQL & "'" & strDESCSERVICO & "', "
	  strSQL = strSQL & "'" & strDESCSERVICO & "', "
	  strSQL = strSQL & dblVlrOrigServ & ", "
	  strSQL = strSQL & dblValorContaPR & ")"
	  
      'athDebug strSQL, true
	  
	  'AQUI: NEW TRANSACTION
	  set objRSCT  = objConn.Execute("start transaction")
	  set objRSCT  = objConn.Execute("set autocommit = 0")
	  objConn.Execute(strSQL)
	  If Err.Number <> 0 Then
		  set objRSCT = objConn.Execute("rollback")
		  Mensagem "modulo_FIN_FLUXOCAIXA.InsertNFdeTitulo_Exec: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		  Response.End()
	  else
	  	  set objRSCT = objConn.Execute("commit")
	  End If
	end if
	'------------------------------------------------------------------------
	' Atualiza na FIN_CONTA_PAGAR_RECEBER o Numero da NF gerada para o titulo
	'------------------------------------------------------------------------
	strSQL = " UPDATE FIN_CONTA_PAGAR_RECEBER SET COD_NF =" & intCodNF & " WHERE COD_CONTA_PAGAR_RECEBER =" & strCODCONTAPR
	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_FIN_FLUXOCAIXA.InsertNFdeTitulo_Exec: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
	End If	

	FechaDBConn objConn
	
	'----------------------------
	'Melhorar isso mais tarde
	'----------------------------
	Response.Redirect("../modulo_FIN_NF/Update.asp?var_chavereg=" & intCodNF)
%>