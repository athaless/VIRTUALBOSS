<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
	Dim strSQL, objRS, objRSCT, ObjConn, auxStr
	Dim strMSG, strDT_AGORA, strPAGAR_RECEBER, strDT_VCTO_Orig, strDT_VCTO, strCOD_GRUPO
	Dim strCOD_CONTRATO, strCODIFICACAO, strFREQUENCIA, strVLR_TOTAL, strNUM_PARC, strDT_BASE_VCTO, strVLR_PARCELA
	Dim strCODIGO, strTIPO, strCOD_CONTA, strCOD_PLANO_CONTA, strCOD_CENTRO_CUSTO
	Dim strHISTORICO, strNUM_DOCUMENTO, strOBS, strTP_COBRANCA
	Dim strINTERVALO, Cont
	
	Dim strCOD_NF, strDT_EMISSAO, strVLR_CONTA, strCOD_SERVICO
	Dim strCLI_NOME, strCLI_NUM_DOC, strCLI_INSC_ESTADUAL, strCLI_ENDER, strCLI_NUMERO
	Dim strCLI_COMPLEMENTO, strCLI_BAIRRO, strCLI_CIDADE, strCLI_ESTADO, strCLI_CEP, strCLI_FONE
	
	
	strCOD_CONTRATO     = GetParam("var_chavereg")
	strCODIFICACAO      = GetParam("var_codificacao")
	strCODIGO           = GetParam("var_codigo")
	strTIPO             = GetParam("var_tipo")
	strVLR_TOTAL        = GetParam("var_vlr_total")
	strNUM_PARC         = GetParam("var_num_parc")
	strFREQUENCIA       = GetParam("var_frequencia")
	strDT_BASE_VCTO     = GetParam("var_dt_base_vcto")
	strTP_COBRANCA      = GetParam("var_tp_cobranca")
	strCOD_CONTA        = GetParam("var_cod_conta")
	strCOD_PLANO_CONTA  = GetParam("var_cod_plano_conta")
	strCOD_CENTRO_CUSTO = GetParam("var_cod_centro_custo")
	strHISTORICO        = GetParam("var_historico")
	strNUM_DOCUMENTO    = GetParam("var_num_documento")
	strOBS              = GetParam("var_obs")
	
	If Not IsNumeric(strCOD_CONTRATO    ) Then strCOD_CONTRATO     = ""
	If Not IsNumeric(strNUM_PARC        ) Then strNUM_PARC         = ""
	If Not IsNumeric(strVLR_TOTAL       ) Then strVLR_TOTAL        = ""
	If Not IsNumeric(strVLR_TOTAL       ) Then strVLR_TOTAL        = ""
	If Not IsDate(strDT_BASE_VCTO       ) Then strDT_BASE_VCTO     = ""
	If Not IsNumeric(strCOD_CONTA       ) Then strCOD_CONTA        = ""
	If Not IsNumeric(strCOD_PLANO_CONTA ) Then strCOD_PLANO_CONTA  = ""
	If Not IsNumeric(strCOD_CENTRO_CUSTO) Then strCOD_CENTRO_CUSTO = ""
	
	strMSG = ""
	If strCOD_CONTRATO = ""     Then strMSG = strMSG & "Parâmetro inválido para contrato<br>"
	If strNUM_PARC = ""         Then strMSG = strMSG & "Informar número de parcelas<br>"
	If strVLR_TOTAL = ""        Then strMSG = strMSG & "Informar Vlr. Total(Ref.)<br>"
	If strDT_BASE_VCTO = ""     Then strMSG = strMSG & "Informar Dt Vcto 1ª Parcela<br>"
	If strCOD_CONTA = ""        Then strMSG = strMSG & "Informar conta bancária<br>"
	If strCOD_PLANO_CONTA = ""  Then strMSG = strMSG & "Informar plano de conta<br>"
	If strCOD_CENTRO_CUSTO = "" Then strMSG = strMSG & "Informar centro de custo<br>"
	If strHISTORICO = ""        Then strMSG = strMSG & "Informar histórico<br>"
	If strNUM_DOCUMENTO = ""    Then strMSG = strMSG & "Informar número do documento<br>"
	
	'If ((strNUM_PARC = "1") And (strFREQUENCIA <> "")) Or _ 
	'   ((strNUM_PARC <> "1") And (strFREQUENCIA = "")) Then strMSG = strMSG & "Número de parcelas e freqüência não conferem<br>"
	If strTP_COBRANCA <> "PAGAR" And strTP_COBRANCA <> "RECEBER" Then strMSG = strMSG & "Tipo de cobrança a ser gerado é indefinido<br>"
	
	If strMSG <> "" Then 
		Mensagem strMSG, "Javascript:history.back();", "Voltar", 1
		Response.End()
	End If
	
	AbreDBConn objConn, CFG_DB 
	
	'-----------------------------
	'Inicializações
	'-----------------------------
	If strTP_COBRANCA = "PAGAR" Then strPAGAR_RECEBER = "1"
	If strTP_COBRANCA = "RECEBER" Then strPAGAR_RECEBER = "0"
	
	strDT_VCTO_Orig = strDT_BASE_VCTO
	'strDT_VCTO = "'" & PrepDataBrToUni(strDT_BASE_VCTO, False) & "'"
	strDT_AGORA = "'" & PrepDataBrToUni(Now, True) & "'"
	strDT_EMISSAO = "'" & PrepDataBrToUni(Date, False) & "'"
	
	strCOD_NF = "NULL"
	
	'--------------------------------------------------------
	'Gera código de agrupamento se existirão contas irmãs
	'--------------------------------------------------------
	strCOD_GRUPO = ""
	If strFREQUENCIA <> "" Then strCOD_GRUPO = GerarSenha(5, 1)
	
	'---------------------------------------------
	'Busca as parcelas geradas para o contrato
	'---------------------------------------------	
	strSQL =          " SELECT ROUND(VLR_PARCELA,2) AS VLR_PARCELA "
    strSQL = strSQL & " 	  ,DT_VENC "
    strSQL = strSQL & "   FROM CONTRATO_PARCELA "
    strSQL = strSQL & "  WHERE COD_CONTRATO = " & strCOD_CONTRATO
	'strSQL = strSQL & "	 AND COALESCE(VLR_PARCELA,0) > 0"
    strSQL = strSQL & "  ORDER BY DT_VENC " 
	
	'athDebug strSQL, true
 
	Set objRS = objConn.Execute(strSQL) 			
	
	If Not objRS.EOF Then
		While Not objRs.Eof 	
			'-----------------------------
			'Insere dados da conta a pagar ou receber 
			'-----------------------------
			Cont = Cont + 1
			auxStr = " (parc " & Cont & "/" & strNUM_PARC & ")"
			strVLR_PARCELA = GetValue(objRS, "VLR_PARCELA")
			
			If (strVLR_PARCELA  = "") Then 
				strVLR_PARCELA = "NULL"
			ElseIf (strVLR_PARCELA <> "0") Then	
				strVLR_PARCELA = FormatNumber(strVLR_PARCELA, 2) 
				strVLR_PARCELA = Replace(strVLR_PARCELA,".","")
				strVLR_PARCELA = Replace(strVLR_PARCELA,",",".")					
			End If 
						
			strDT_VCTO = "'" & PrepDataBrToUni(GetValue(objRS, "DT_VENC"), False) & "'"	
			
			'Solicitado por Aless, não processar parcela com valor zero. By Lumertz 13/02/2013			
			If(strVLR_PARCELA > 0) Then		
				strSQL =          " INSERT INTO FIN_CONTA_PAGAR_RECEBER ( COD_CONTRATO, COD_NF, PAGAR_RECEBER, COD_GRUPO, TIPO, CODIGO, COD_CONTA "
				strSQL = strSQL & "                                     , COD_PLANO_CONTA, COD_CENTRO_CUSTO, HISTORICO, OBS, TIPO_DOCUMENTO, NUM_DOCUMENTO "
				strSQL = strSQL & "                                     , DT_EMISSAO, DT_VCTO, VLR_CONTA, SITUACAO, SYS_DT_CRIACAO, SYS_COD_USER_CRIACAO ) "
				strSQL = strSQL & " VALUES ( " & strCOD_CONTRATO & ", " & strCOD_NF & ", " & strPAGAR_RECEBER & ", '" & strCOD_GRUPO & "', '" & strTIPO & "', " & strCODIGO & ", " & strCOD_CONTA 
				strSQL = strSQL & "        , " & strCOD_PLANO_CONTA & ", " & strCOD_CENTRO_CUSTO & ", '" & strHISTORICO & "', '" & strOBS & "', 'BOLETO', '" & strNUM_DOCUMENTO & auxStr & "' "
				strSQL = strSQL & "        , " & strDT_EMISSAO & ", " & strDT_VCTO & ", " & strVLR_PARCELA & ", 'ABERTA', " & strDT_AGORA & ", '" & Request.Cookies("VBOSS")("ID_USUARIO") & "') "
				
				'athDebug strSQL, True
				
				'AQUI: NEW TRANSACTION
				set objRSCT  = objConn.Execute("start transaction")
				set objRSCT  = objConn.Execute("set autocommit = 0")
				objConn.Execute(strSQL)
				If Err.Number <> 0 Then
					set objRSCT = objConn.Execute("rollback")
					Mensagem "modulo_CONTRATO.processa_exec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
					Response.End()
				else
					set objRSCT = objConn.Execute("commit")
				End If				
			End If
	
			athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
		Wend
	End If	
	'-----------------------------
	'Atualiza Status do Contrato
	'-----------------------------			
	strSQL = " UPDATE CONTRATO SET SITUACAO = 'FATURADO' WHERE COD_CONTRATO = " & strCOD_CONTRATO

	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_CONTRATO.processa_exec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
	End If	
	
	FechaRecordSet objRS	
	
	FechaDBConn ObjConn
%>
<script>
	parent.frames["vbTopFrame"].document.form_principal.submit();
</script>