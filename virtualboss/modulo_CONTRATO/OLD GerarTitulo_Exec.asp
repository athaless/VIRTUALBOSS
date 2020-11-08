<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
	Dim strSQL, objRS, ObjConn, auxStr
	Dim strMSG, strDT_AGORA, strPAGAR_RECEBER, strDT_VCTO_Orig, strDT_VCTO, strCOD_GRUPO
	Dim strCOD_CONTRATO, strFREQUENCIA, strNUM_PARC, strVLR_PARC, strDT_BASE_VCTO
	Dim strCODIGO, strTIPO, strCOD_CONTA, strCOD_PLANO_CONTA, strCOD_CENTRO_CUSTO, strHISTORICO, strNUM_DOCUMENTO, strOBS, strTP_COBRANCA
	Dim strINTERVALO, Desloc, Cont
	
	strCOD_CONTRATO     = GetParam("var_chavereg")
	strFREQUENCIA       = GetParam("var_frequencia")
	strNUM_PARC         = GetParam("var_num_parc")
	strVLR_PARC         = GetParam("var_vlr_parc")
	strDT_BASE_VCTO     = GetParam("var_dt_base_vcto")
	strCODIGO           = GetParam("var_codigo")
	strTIPO             = GetParam("var_tipo")
	strCOD_CONTA        = GetParam("var_cod_conta")
	strCOD_PLANO_CONTA  = GetParam("var_cod_plano_conta")
	strCOD_CENTRO_CUSTO = GetParam("var_cod_centro_custo")
	strHISTORICO        = GetParam("var_historico")
	strNUM_DOCUMENTO    = GetParam("var_num_documento")
	strOBS              = GetParam("var_obs")
	strTP_COBRANCA      = GetParam("var_tp_cobranca")
	
	If Not IsNumeric(strCOD_CONTRATO) Then strCOD_CONTRATO = ""
	If Not IsNumeric(strNUM_PARC) Then strNUM_PARC = ""
	If Not IsNumeric(strVLR_PARC) Then strVLR_PARC = ""
	If Not IsDate(strDT_BASE_VCTO) Then strDT_BASE_VCTO = ""
	If Not IsNumeric(strCOD_CONTA) Then strCOD_CONTA = ""
	If Not IsNumeric(strCOD_PLANO_CONTA) Then strCOD_PLANO_CONTA = ""
	If Not IsNumeric(strCOD_CENTRO_CUSTO) Then strCOD_CENTRO_CUSTO = ""
	
	strMSG = ""
	If (strCOD_CONTRATO = "") Then     strMSG = strMSG & "Parâmetro inválido para contrato<br>"
	If (strFREQUENCIA = "") Then       strMSG = strMSG & "Informar freqüência<br>"
	If (strNUM_PARC = "") Then         strMSG = strMSG & "Informar número de parcelas<br>"
	If (strVLR_PARC = "") Then         strMSG = strMSG & "Informar valor da parcela<br>"
	If (strDT_BASE_VCTO = "") Then     strMSG = strMSG & "Informar data base de vencimento<br>"
	If (strCOD_CONTA = "") Then        strMSG = strMSG & "Informar conta bancária<br>"
	If (strCOD_PLANO_CONTA = "") Then  strMSG = strMSG & "Informar plano de conta<br>"
	If (strCOD_CENTRO_CUSTO = "") Then strMSG = strMSG & "Informar centro de custo<br>"
	If (strHISTORICO = "") Then        strMSG = strMSG & "Informar histórico<br>"
	If (strNUM_DOCUMENTO = "") Then    strMSG = strMSG & "Informar número do documento<br>"
	
	If ((strNUM_PARC = "1") And (strFREQUENCIA <> "UMA_VEZ")) Or _ 
	   ((strNUM_PARC <> "1") And (strFREQUENCIA = "UMA_VEZ")) Then strMSG = strMSG & "Número de parcelas e freqüência não conferem<br>"
	
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
	strDT_VCTO    = "'" & PrepDataBrToUni(strDT_BASE_VCTO, False) & "'"
	strDT_AGORA   = "'" & PrepDataBrToUni(Now, True) & "'"
	
	If strVLR_PARC <> 0 Then
		strVLR_PARC = FormatNumber(strVLR_PARC, 2) 
		strVLR_PARC = Replace(strVLR_PARC,".","")
		strVLR_PARC = Replace(strVLR_PARC,",",".")
	End If
	
	'--------------------------------------------------------
	'Gera código de agrupamento se existirão contas irmãs
	'--------------------------------------------------------
	strCOD_GRUPO = ""
	If (strFREQUENCIA <> "UMA_VEZ") Then strCOD_GRUPO = GerarSenha(5, 1)
	
	'-----------------------------
	'Insere dados da conta 
	'-----------------------------
	auxStr = ""
	if (cInt(strNUM_PARC) > 1) then
	  auxStr = " (parc 1/" & strNUM_PARC & ")"
	end if
	strSQL =          " INSERT INTO FIN_CONTA_PAGAR_RECEBER ( COD_CONTRATO, PAGAR_RECEBER, COD_GRUPO, TIPO, CODIGO, COD_CONTA, COD_PLANO_CONTA, COD_CENTRO_CUSTO "
	strSQL = strSQL & "                                     , HISTORICO, OBS, TIPO_DOCUMENTO, NUM_DOCUMENTO, DT_EMISSAO, DT_VCTO, VLR_CONTA "
	strSQL = strSQL & "                                     , SITUACAO, SYS_DT_CRIACAO, SYS_COD_USER_CRIACAO ) "
	strSQL = strSQL & " VALUES ( " & strCOD_CONTRATO & ", " & strPAGAR_RECEBER & ", '" & strCOD_GRUPO & "', '" & strTIPO & "', " & strCODIGO & ", " & strCOD_CONTA & ", " & strCOD_PLANO_CONTA & ", " & strCOD_CENTRO_CUSTO 
	strSQL = strSQL & "        , '" & strHISTORICO & "', '" & strOBS & "', 'BOLETO', '" & strNUM_DOCUMENTO & auxStr & "', " & strDT_AGORA & ", " & strDT_VCTO & ", " & strVLR_PARC 
	strSQL = strSQL & "        , 'ABERTA', " & strDT_AGORA & ", '" & Request.Cookies("VBOSS")("ID_USUARIO") & "') "
	
	objConn.Execute(strSQL)
	
	'--------------------------------------
	'Define parâmetros da periodicidade
	'--------------------------------------
	strINTERVALO = ""
	If strFREQUENCIA = "DIARIA"     Then strINTERVALO = "D"
	If strFREQUENCIA = "SEMANAL"    Then strINTERVALO = "WW"
	If strFREQUENCIA = "QUINZENAL"  Then strINTERVALO = "WW" 'WW x 2
	If strFREQUENCIA = "MENSAL"     Then strINTERVALO = "M"
	If strFREQUENCIA = "BIMESTRAL"  Then strINTERVALO = "M" 'M x 2
	If strFREQUENCIA = "TRIMESTRAL" Then strINTERVALO = "Q"
	If strFREQUENCIA = "SEMESTRAL"  Then strINTERVALO = "Q" 'Q x 2
	If strFREQUENCIA = "ANUAL"      Then strINTERVALO = "YYYY"
	
	Desloc = 1
	If strFREQUENCIA = "QUINZENAL"  Then Desloc = 2
	If strFREQUENCIA = "BIMESTRAL"  Then Desloc = 2
	If strFREQUENCIA = "SEMESTRAL"  Then Desloc = 2
	
	'-----------------------------
	'Insere demais contas 
	'-----------------------------
	For Cont = 1 To strNUM_PARC-1
	    auxStr = " (parc " & Cont+1 & "/" & strNUM_PARC & ")"
		
		strDT_VCTO = "'" & PrepDataBrToUni(DateAdd(strINTERVALO, Desloc * Cont, strDT_VCTO_Orig), False) & "'"
		
		strSQL =          " INSERT INTO FIN_CONTA_PAGAR_RECEBER ( COD_CONTRATO, PAGAR_RECEBER, COD_GRUPO, TIPO, CODIGO, COD_CONTA, COD_PLANO_CONTA, COD_CENTRO_CUSTO "
		strSQL = strSQL & "                                     , HISTORICO, OBS, TIPO_DOCUMENTO, NUM_DOCUMENTO, DT_EMISSAO, DT_VCTO, VLR_CONTA "
		strSQL = strSQL & "                                     , SITUACAO, SYS_DT_CRIACAO, SYS_COD_USER_CRIACAO ) "
		strSQL = strSQL & " VALUES ( " & strCOD_CONTRATO & ", " & strPAGAR_RECEBER & ", '" & strCOD_GRUPO & "', '" & strTIPO & "', " & strCODIGO & ", " & strCOD_CONTA & ", " & strCOD_PLANO_CONTA & ", " & strCOD_CENTRO_CUSTO 
		strSQL = strSQL & "        , '" & strHISTORICO & "', '" & strOBS & "', 'BOLETO', '" & strNUM_DOCUMENTO & auxStr & "', " & strDT_AGORA & ", " & strDT_VCTO & ", " & strVLR_PARC 
		strSQL = strSQL & "        , 'ABERTA', " & strDT_AGORA & ", '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' ) "
		
		'athDebug "<br><br>" & strSQL, False
		
		objConn.Execute(strSQL)
	Next
	
	strSQL = " UPDATE CONTRATO SET SITUACAO = 'FATURADO' WHERE COD_CONTRATO = " & strCOD_CONTRATO
	objConn.Execute(strSQL)
	
	FechaDBConn ObjConn
%>
<script>
	parent.frames["vbTopFrame"].document.form_principal.submit();
</script>