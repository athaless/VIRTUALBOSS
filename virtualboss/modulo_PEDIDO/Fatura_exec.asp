<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
	Dim objConn, objRS, objRSCT, strSQL
	Dim strCOD_DADO, strCODIGO, strTIPO, strOBS, strTOTAL
	Dim strDT_AGORA, strDT_EMISSAO, strCOD_TITULO
	Dim strCOD_CONTA, strCOD_PLANO_CONTA, strCOD_CENTRO_CUSTO
	Dim strHISTORICO, strNUM_DOCUMENTO
	
	strCOD_DADO = GetParam("var_chavereg")
	strCODIGO = GetParam("var_codigo")
	strTIPO = GetParam("var_tipo")
	strDT_EMISSAO = GetParam("var_dt_emissao")
	strOBS = GetParam("var_obs")
	strTOTAL = GetParam("var_total")
	strCOD_CONTA = GetParam("var_cod_conta")
	strCOD_PLANO_CONTA = GetParam("var_cod_plano_conta")
	strCOD_CENTRO_CUSTO = GetParam("var_cod_centro_custo")
	strHISTORICO = GetParam("var_historico")
	strNUM_DOCUMENTO = GetParam("var_num_documento")
	
	AbreDBConn objConn, CFG_DB 
	
	'--------------------------------------------
	'Insere conta a receber
	'--------------------------------------------
	strTOTAL = CDbl("0" & strTOTAL)
	strTOTAL = FormataDouble(FormataDecimal(strTOTAL, 2))
	
	strDT_AGORA = "'" & PrepDataBrToUni(Now, True) & "'"
	strDT_EMISSAO = "'" & PrepDataBrToUni(strDT_EMISSAO, False) & "'"
	
	strSQL =          " INSERT INTO FIN_CONTA_PAGAR_RECEBER ( PAGAR_RECEBER, TIPO, CODIGO, DT_EMISSAO, DT_VCTO, VLR_CONTA, VLR_CONTA_ORIG "
	strSQL = strSQL & "                                     , OBS, SITUACAO, MARCA_NFE, COD_CONTA, COD_PLANO_CONTA, COD_CENTRO_CUSTO "
	strSQL = strSQL & "                                     , HISTORICO, NUM_DOCUMENTO, SYS_DT_CRIACAO, SYS_COD_USER_CRIACAO ) "
	strSQL = strSQL & " VALUES ( 0, '" & strTIPO & "', " & strCODIGO & ", " & strDT_EMISSAO & ", " & strDT_EMISSAO & ", " & strTOTAL & ", " & strTOTAL 
	strSQL = strSQL & "        , '" & strOBS & "', 'ABERTA', 'SEM_NFE', " & strCOD_CONTA & ", " & strCOD_PLANO_CONTA & ", " & strCOD_CENTRO_CUSTO 
	strSQL = strSQL & "        , '" & strHISTORICO & "', '" & strNUM_DOCUMENTO & "', " & strDT_AGORA & ", '" & Request.Cookies("VBOSS")("ID_USUARIO") & "') "
	
	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_PEDIDO.Fatura_Exec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
	End If
	
	'----------------------------------------------------------------------------------------
	'Busca conta recém inserida para colocar no pedido e carregar na próxima página
	'----------------------------------------------------------------------------------------
	strSQL =          " SELECT COD_CONTA_PAGAR_RECEBER AS COD_TITULO " 
	strSQL = strSQL & " FROM FIN_CONTA_PAGAR_RECEBER " 
	strSQL = strSQL & " WHERE PAGAR_RECEBER = 0 " 
	strSQL = strSQL & " AND TIPO = '" & strTIPO & "' " 
	strSQL = strSQL & " AND CODIGO = " & strCODIGO 
	strSQL = strSQL & " AND SYS_DT_CRIACAO = " & strDT_AGORA 
	strSQL = strSQL & " AND SYS_COD_USER_CRIACAO = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' " 
	
	Set objRS = objConn.Execute(strSQL)
	
	strCOD_TITULO = ""
	If objRS.Eof Then
		Mensagem "Título não encontrado", "Javascript:history.back();", "Voltar", 1
		Response.End()
	Else
		'---------------------------------------------------------------------------------
		'Atualiza pedido indicando que cobrança foi gerada e também vincula com a conta
		'---------------------------------------------------------------------------------
		strCOD_TITULO = GetValue(objRS, "COD_TITULO")
		
		strSQL =          " UPDATE NF_NOTA "
		strSQL = strSQL & " SET SITUACAO = 'FATURADO' "
		strSQL = strSQL & "   , COD_CONTA_PAGAR_RECEBER = " & strCOD_TITULO
		strSQL = strSQL & " WHERE COD_NF = " & strCOD_DADO
		
		'AQUI: NEW TRANSACTION
		set objRSCT  = objConn.Execute("start transaction")
		set objRSCT  = objConn.Execute("set autocommit = 0")
		objConn.Execute(strSQL)
		If Err.Number <> 0 Then
			set objRSCT = objConn.Execute("rollback")
			Mensagem "modulo_PEDIDO.Fatura_Exec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
			Response.End()
		else
			set objRSCT = objConn.Execute("commit")
		End If

	End If
	
	FechaRecordSet objRS
	FechaDBConn ObjConn
	
	If strCOD_TITULO <> "" Then Response.Redirect("../modulo_FIN_TITULOS/Update.asp?var_chavereg=" & strCOD_TITULO)
%>