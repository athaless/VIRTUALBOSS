<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_FIN_NF", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
Dim objConn, objRS, strSQL
Dim strCOD_NF, strCOD_CONTA_RECEBER
Dim strTIPO, strCODIGO, strDT_EMISSAO, strVLR_CONTA
Dim strCLI_NOME, strCLI_NUM_DOC, strCLI_INSC_ESTADUAL, strCLI_ENDER, strCLI_NUMERO
Dim strCLI_COMPLEMENTO, strCLI_BAIRRO, strCLI_CIDADE, strCLI_ESTADO, strCLI_CEP, strCLI_FONE
Dim strMSG, strDT_AGORA

strMSG = ""

strCOD_CONTA_RECEBER = GetParam("var_chavereg")

If strCOD_CONTA_RECEBER <> "" Then
	AbreDBConn objConn, CFG_DB
	
	strDT_AGORA = "'" & PrepDataBrToUni(Now,true) & "'"
	
	strSQL = "SELECT DISTINCT COD_CFG_NF, SERIE FROM CFG_NF WHERE DT_INATIVO IS NULL"
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	if not objRS.eof then
		strSQL = "INSERT INTO" 									&_
					"	NF_NOTA" 								&_
					"		(" 									&_
					"		COD_CLI," 							&_
					"		COD_CFG_NF," 						&_
					"		SERIE," 							&_
					"		SITUACAO," 							&_
					"		SYS_DTT_INS," 						&_
					"		SYS_ID_USUARIO_INS" 				&_
					"		)"									&_
					"VALUES"									&_
					"		("									&_
					"		Null,"			 					&_
							GetValue(objRS,"COD_CFG_NF")		& ", '" &_
							GetValue(objRS,"SERIE") 			& "',"  &_
					"		'EM_EDICAO'," 						&_
					"		" & strDT_AGORA & ",'" 				&_
							LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "'" &_
					"		)"
		objConn.Execute(strSQL)
	else
		strMSG = strMSG & "Não foi possível encontrar um modelo de Nota Fiscal<br>"
	end if	
	
	If strMSG = "" Then
		strSQL =          " SELECT COD_NF AS CODIGO FROM NF_NOTA "
		strSQL = strSQL & " WHERE SITUACAO = 'EM_EDICAO' "
		strSQL = strSQL & " AND SYS_ID_USUARIO_INS = '" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "'"
		strSQL = strSQL & " AND SYS_DTT_INS = " & strDT_AGORA
		
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		if not objRS.eof then strCOD_NF = GetValue(objRS,"CODIGO")
		FechaRecordSet objRS
		
		If strCOD_NF <> "" Then
			strSQL =          " SELECT TIPO, CODIGO, DT_EMISSAO, VLR_CONTA "
			strSQL = strSQL & " FROM FIN_CONTA_PAGAR_RECEBER "
			strSQL = strSQL & " WHERE COD_CONTA_PAGAR_RECEBER = " & strCOD_CONTA_RECEBER
			strSQL = strSQL & " AND PAGAR_RECEBER = 0 "
			strSQL = strSQL & " AND SYS_DT_CANCEL IS NULL "
			
			AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
			if not objRS.eof then
				strTIPO       = GetValue(objRS, "TIPO")
				strCODIGO     = GetValue(objRS, "CODIGO")
				strDT_EMISSAO = GetValue(objRS, "DT_EMISSAO")
				strVLR_CONTA  = GetValue(objRS, "VLR_CONTA")
			end if
			FechaRecordSet objRS
		Else
			strMSG = strMSG & "Não foi possível encontrar a Nota Fiscal inserida<br>"
		End If
	End If
	
	If strMSG = "" Then
		strSQL = ""
		
		If strTIPO = "ENT_CLIENTE" Then 
			strSQL =          " SELECT RAZAO_SOCIAL AS CLI_NOME "
			strSQL = strSQL & "      , NUM_DOC AS CLI_NUM_DOC "
			strSQL = strSQL & "      , INSC_ESTADUAL AS CLI_INSC_ESTADUAL "
			strSQL = strSQL & "      , FATURA_ENDERECO AS CLI_ENDER "
			strSQL = strSQL & "      , FATURA_NUMERO AS CLI_NUMERO "
			strSQL = strSQL & "      , FATURA_COMPLEMENTO AS CLI_COMPLEMENTO "
			strSQL = strSQL & "      , FATURA_CEP AS CLI_CEP "
			strSQL = strSQL & "      , FATURA_BAIRRO AS CLI_BAIRRO "
			strSQL = strSQL & "      , FATURA_CIDADE AS CLI_CIDADE "
			strSQL = strSQL & "      , FATURA_ESTADO AS CLI_ESTADO "
			strSQL = strSQL & "      , FONE_1 AS CLI_FONE "
			strSQL = strSQL & " FROM ENT_CLIENTE "
			strSQL = strSQL & " WHERE COD_CLIENTE = " & strCODIGO
		End If
		
		'If strTIPO = "ENT_COLABORADOR" Then
		'	strSQL =          " SELECT NOME AS CLI_NOME "
		'	strSQL = strSQL & "      , CPF AS CLI_NUM_DOC "
		'	strSQL = strSQL & "      , INSC_ESTADUAL AS CLI_INSC_ESTADUAL "
		'	strSQL = strSQL & "      , ENDERECO AS CLI_ENDER "
		'	strSQL = strSQL & "      , NUMERO AS CLI_NUMERO "
		'	strSQL = strSQL & "      , COMPLEMENTO AS CLI_COMPLEMENTO "
		'	strSQL = strSQL & "      , CEP AS CLI_CEP "
		'	strSQL = strSQL & "      , BAIRRO AS CLI_BAIRRO "
		'	strSQL = strSQL & "      , CIDADE AS CLI_CIDADE "
		'	strSQL = strSQL & "      , ESTADO AS CLI_ESTADO "
		'	strSQL = strSQL & "      , FONE_1 AS CLI_FONE "
		'	strSQL = strSQL & " FROM ENT_COLABORADOR "
		'	strSQL = strSQL & " WHERE COD_COLABORADOR = " & strCODIGO
		'End If
		
		'If strTIPO = "ENT_FORNECEDOR" Then
		'	strSQL =          " SELECT RAZAO_SOCIAL AS CLI_NOME "
		'	strSQL = strSQL & "      , NUM_DOC AS CLI_NUM_DOC "
		'	strSQL = strSQL & "      , INSC_ESTADUAL AS CLI_INSC_ESTADUAL "
		'	strSQL = strSQL & "      , FATURA_ENDERECO AS CLI_ENDER "
		'	strSQL = strSQL & "      , FATURA_NUMERO AS CLI_NUMERO "
		'	strSQL = strSQL & "      , FATURA_COMPLEMENTO AS CLI_COMPLEMENTO "
		'	strSQL = strSQL & "      , FATURA_CEP AS CLI_CEP "
		'	strSQL = strSQL & "      , FATURA_BAIRRO AS CLI_BAIRRO "
		'	strSQL = strSQL & "      , FATURA_CIDADE AS CLI_CIDADE "
		'	strSQL = strSQL & "      , FATURA_ESTADO AS CLI_ESTADO "
		'	strSQL = strSQL & "      , FONE_1 AS CLI_FONE "
		'	strSQL = strSQL & " FROM ENT_FORNECEDOR "
		'	strSQL = strSQL & " WHERE COD_FORNECEDOR = " & strCODIGO
		'End If
		
		If strSQL <> "" Then
			AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
			if not objRS.eof then
				strCLI_NOME          = GetValue(objRS, "CLI_NOME")
				strCLI_NUM_DOC       = GetValue(objRS, "CLI_NUM_DOC")
				strCLI_INSC_ESTADUAL = GetValue(objRS, "CLI_INSC_ESTADUAL")
				strCLI_ENDER         = GetValue(objRS, "CLI_ENDER")
				strCLI_NUMERO        = GetValue(objRS, "CLI_NUMERO")
				strCLI_COMPLEMENTO   = GetValue(objRS, "CLI_COMPLEMENTO")
				strCLI_CEP           = GetValue(objRS, "CLI_CEP")
				strCLI_BAIRRO        = GetValue(objRS, "CLI_BAIRRO")
				strCLI_CIDADE        = GetValue(objRS, "CLI_CIDADE")
				strCLI_ESTADO        = GetValue(objRS, "CLI_ESTADO")
				strCLI_FONE          = GetValue(objRS, "CLI_FONE")
				
				If strCLI_NUMERO <> ""      Then strCLI_ENDER = strCLI_ENDER & ", " & strCLI_NUMERO
				If strCLI_COMPLEMENTO <> "" Then strCLI_ENDER = strCLI_ENDER & " / " & strCLI_COMPLEMENTO
			end if
			FechaRecordSet objRS
		Else
			strMSG = strMSG & "Não foi possível obter dados do cliente<br>"
		End If
	End If
	
	If strMSG = "" Then
		strSQL =          " UPDATE NF_NOTA "
		strSQL = strSQL & " SET DT_EMISSAO        = '" & PrepDataBrToUni(strDT_EMISSAO, False) & "' "
		strSQL = strSQL & "   , COD_CLI           = " & strCODIGO
		strSQL = strSQL & "   , CLI_NOME          = '" & strCLI_NOME & "'"
		strSQL = strSQL & "   , CLI_NUM_DOC       = '" & strCLI_NUM_DOC & "'"
		strSQL = strSQL & "   , CLI_INSC_ESTADUAL = '" & strCLI_INSC_ESTADUAL & "'"
		strSQL = strSQL & "   , CLI_ENDER         = '" & strCLI_ENDER & "'"
		strSQL = strSQL & "   , CLI_CEP           = '" & strCLI_CEP & "'"
		strSQL = strSQL & "   , CLI_BAIRRO        = '" & strCLI_BAIRRO & "'"
		strSQL = strSQL & "   , CLI_CIDADE        = '" & strCLI_CIDADE & "'"
		strSQL = strSQL & "   , CLI_ESTADO        = '" & strCLI_ESTADO & "'"
		strSQL = strSQL & "   , CLI_FONE          = '" & strCLI_FONE & "'"
		strSQL = strSQL & "   , SITUACAO          = 'NAO_EMITIDA'"
		strSQL = strSQL & "   , OBS_NF            = 'NF Gerada a partir de título de R$ " & FormatNumber(strVLR_CONTA) & "'"
		strSQL = strSQL & " WHERE COD_NF = " & strCOD_NF
		
		objConn.Execute(strSQL)
		
		strSQL =          " UPDATE FIN_CONTA_PAGAR_RECEBER "
		strSQL = strSQL & " SET COD_NF = " & strCOD_NF
		strSQL = strSQL & " WHERE COD_CONTA_PAGAR_RECEBER = " & strCOD_CONTA_RECEBER
		
		objConn.Execute(strSQL)
	End If
	
	FechaDBConn objConn
	%>
	<script language="JavaScript">location='../modulo_FIN_NF/Update.asp?var_chavereg=<%=strCOD_NF%>'</script>
	<%
End If
%>