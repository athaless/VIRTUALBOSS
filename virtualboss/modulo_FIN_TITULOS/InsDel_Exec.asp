<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim strSQL, objRS, ObjConn
Dim strDT_AGORA, strMSG
Dim Cont, Desloc
Dim strRETORNO, strCODIGO, strTIPO, strTIPO_CONTA, strCOD_CONTA, strCOD_CENTRO_CUSTO, strCOD_PLANO_CONTA
Dim strNUM_DOCUMENTO, strVLR_DOCUMENTO, strTIPO_DOCUMENTO, strDT_EMISSAO, strDT_VCTO_Orig, strDT_VCTO
Dim strHISTORICO, strOBS, strFREQUENCIA, strPARCELAS, strCOD_GRUPO, strPAGAR_RECEBER, strINTERVALO
Dim strSYS_DT_CRIACAO, strTITLE
Dim strCOD_CONTA_PAGAR_RECEBER, strCOD_NF, strNUM_NF

if GetParam("var_cancel")<>"true" then
	strTIPO_CONTA = GetParam("var_tipo_conta")
	strCOD_CONTA = GetParam("var_cod_conta")
	strCODIGO = GetParam("var_codigo")
	strTIPO = GetParam("var_tipo")
	strCOD_CENTRO_CUSTO = GetParam("var_cod_centro_custo")
	strCOD_PLANO_CONTA = GetParam("var_cod_plano_conta")
	strTIPO_DOCUMENTO = GetParam("var_documento")
	strNUM_DOCUMENTO = GetParam("var_num_documento")
	strVLR_DOCUMENTO = GetParam("var_vlr_conta")
	strDT_EMISSAO = GetParam("var_dt_emissao")
	strDT_VCTO = GetParam("var_dt_vcto")
	strHISTORICO = GetParam("var_historico")
	strOBS = GetParam("var_obs")
	strFREQUENCIA = GetParam("var_frequencia")
	strPARCELAS = GetParam("var_parcelas")
	strCOD_NF = GetParam("var_cod_nf")
	strNUM_NF = GetParam("var_num_nf")
	
	
	If Not IsNumeric(strVLR_DOCUMENTO) Then strVLR_DOCUMENTO = ""
	If Not IsDate(strDT_EMISSAO) Then strDT_EMISSAO = ""
	If Not IsDate(strDT_VCTO) Then strDT_VCTO = ""
	If IsEmpty(strCOD_NF) Then strCOD_NF = "Null"
	If IsEmpty(strNUM_NF) Then strNUM_NF = ""
	
	strMSG = ""
	If (strTIPO_CONTA <> "PG") And (strTIPO_CONTA <> "RC") Then strMSG = strMSG & "Parâmetro inválido para tipo de conta<br>"
	If (strCOD_CONTA = "") Then 						strMSG = strMSG & "Parâmetro inválido para conta<br>"
	If (strCODIGO = "") Or (strTIPO = "") Then 	strMSG = strMSG & "Informar entidade<br>"
	If (strCOD_CENTRO_CUSTO = "") Then 				strMSG = strMSG & "Informar centro de custo<br>"
	If (strCOD_PLANO_CONTA = "") Then 				strMSG = strMSG & "Informar plano de conta<br>"
	If (strTIPO_DOCUMENTO = "") Then 				strMSG = strMSG & "Informar tipo do documento<br>"
'	If (strNUM_DOCUMENTO = "") Then 					strMSG = strMSG & "Informar número do documento<br>"
	If (strVLR_DOCUMENTO = "") Or (strVLR_DOCUMENTO <= 0) Then strMSG = strMSG & "Informar valor do documento<br>"
	If (strDT_EMISSAO = "") Then 						strMSG = strMSG & "Informar data de emissão do documento<br>"
	If (strDT_VCTO = "") Then 							strMSG = strMSG & "Informar data de vencimento do documento<br>"
	If (strHISTORICO = "") Then 						strMSG = strMSG & "Informar histórico<br>"
	
	If strMSG <> "" Then 
		Mensagem strMSG, "Javascript:history.back();", "Voltar", 1
		Response.End()
	End If
	
	AbreDBConn objConn, CFG_DB 
	
	'-----------------------------
	'Inicializações
	'-----------------------------
	strPAGAR_RECEBER = "True"
	strTITLE = "Conta a Pagar "
	if strTIPO_CONTA = "RC" then 
		strPAGAR_RECEBER = "False" 
		strTITLE = "Conta a Receber "
	end if 

	
	strDT_VCTO_Orig = strDT_VCTO
	strDT_VCTO    = "'" & PrepDataBrToUni(strDT_VCTO, False) & "'"
	strDT_EMISSAO = "'" & PrepDataBrToUni(strDT_EMISSAO, False) & "'"
	strDT_AGORA   = "'" & PrepDataBrToUni(Now, True) & "'"
	
	If strVLR_DOCUMENTO <> 0 Then
		strVLR_DOCUMENTO = FormatNumber(strVLR_DOCUMENTO, 2) 
		strVLR_DOCUMENTO = Replace(strVLR_DOCUMENTO,".","")
		strVLR_DOCUMENTO = Replace(strVLR_DOCUMENTO,",",".")
	End If
	
	'--------------------------------------------------------
	'Gera código de agrupamento se existirão contas irmãs
	'--------------------------------------------------------
	strCOD_GRUPO = ""
	If (strFREQUENCIA <> "UMA_VEZ") Then strCOD_GRUPO = GerarSenha(5, 1)
	
	'-----------------------------
	'Insere dados da conta 
	'-----------------------------
	strSQL =          " INSERT INTO FIN_CONTA_PAGAR_RECEBER ( PAGAR_RECEBER, COD_GRUPO, TIPO, CODIGO, COD_CONTA, COD_PLANO_CONTA, COD_CENTRO_CUSTO "
	strSQL = strSQL & "                                     , HISTORICO, OBS, TIPO_DOCUMENTO, NUM_DOCUMENTO, DT_EMISSAO, DT_VCTO, VLR_CONTA "
	strSQL = strSQL & "                                     , SITUACAO, COD_NF, NUM_NF, SYS_DT_CRIACAO, SYS_COD_USER_CRIACAO ) "
	strSQL = strSQL & " VALUES ( " & strPAGAR_RECEBER & ", '" & strCOD_GRUPO & "', '" & strTIPO & "', " & strCODIGO & ", " & strCOD_CONTA & ", " & strCOD_PLANO_CONTA & ", " & strCOD_CENTRO_CUSTO 
	strSQL = strSQL & "        , '" & strHISTORICO & "', '" & strOBS & "', '" & strTIPO_DOCUMENTO & "', '" & strNUM_DOCUMENTO & "', " & strDT_EMISSAO & ", " & strDT_VCTO & ", " & strVLR_DOCUMENTO 
	strSQL = strSQL & "        , 'ABERTA', " & strCOD_NF & ", '" & strNUM_NF & "', " & strDT_AGORA & ", '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' ) "
	
	'Response.Write("<br><br>" & strSQL)
	'Response.End()
	
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
	For Cont = 1 To strPARCELAS-1
		strDT_VCTO = "'" & PrepDataBrToUni(DateAdd(strINTERVALO, Desloc * Cont, strDT_VCTO_Orig), False) & "'"
		
		strSQL =          " INSERT INTO FIN_CONTA_PAGAR_RECEBER ( PAGAR_RECEBER, COD_GRUPO, TIPO, CODIGO, COD_CONTA, COD_PLANO_CONTA, COD_CENTRO_CUSTO "
		strSQL = strSQL & "                                     , HISTORICO, OBS, TIPO_DOCUMENTO, NUM_DOCUMENTO, DT_EMISSAO, DT_VCTO, VLR_CONTA "
		strSQL = strSQL & "                                     , SITUACAO, COD_NF, SYS_DT_CRIACAO, SYS_COD_USER_CRIACAO ) "
		strSQL = strSQL & " VALUES ( " & strPAGAR_RECEBER & ", '" & strCOD_GRUPO & "', '" & strTIPO & "', " & strCODIGO & ", " & strCOD_CONTA & ", " & strCOD_PLANO_CONTA & ", " & strCOD_CENTRO_CUSTO 
		strSQL = strSQL & "        , '" & strHISTORICO & "', '" & strOBS & "', '" & strTIPO_DOCUMENTO & "', '" & strNUM_DOCUMENTO & "', " & strDT_EMISSAO & ", " & strDT_VCTO & ", " & strVLR_DOCUMENTO 
		strSQL = strSQL & "        , 'ABERTA', " & strCOD_NF & ", " & strDT_AGORA & ", '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' ) "
		
		'Response.Write("<br><br>" & strSQL)
		'Response.End()
		
		objConn.Execute(strSQL)
	Next
	
	If strCOD_NF = "Null" Then
		%>
		<script>
			location='Insert.asp?var_chavereg=<%=strCOD_CONTA%>&var_tipo=<%=strTIPO_CONTA%>&var_centro_custo=<%=strCOD_CENTRO_CUSTO%>&var_plano_conta=<%=strCOD_PLANO_CONTA%>';
		</script>
		<%
	Else
		%>
		<script>
			location='../modulo_FIN_NF/Default.htm';
		</script>
		<%
	End If
else
	if GetParam("var_chavereg")<>"" then 
		strCOD_CONTA_PAGAR_RECEBER = GetParam("var_chavereg")
		
		AbreDBConn objConn, CFG_DB 	
		strSQL = "DELETE FROM FIN_CONTA_PAGAR_RECEBER WHERE COD_CONTA_PAGAR_RECEBER = " & strCOD_CONTA_PAGAR_RECEBER 		
		objConn.Execute(strSQL)
	end if
%>
<script>
   //ASSIM SÓ FUNCIONA NO IE (só no IE): parent.vbTopFrame.FrmPrincipal.submit();
 
   //ASSIM FUNCIONA NO IE e no FIREFOX
   parent.frames["vbTopFrame"].document.FrmPrincipal.submit();
</script>
<%
end if
FechaDBConn ObjConn
%>