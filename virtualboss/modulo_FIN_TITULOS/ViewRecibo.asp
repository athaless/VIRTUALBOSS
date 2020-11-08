<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FIN_TITULOS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<%
	Response.CacheControl = "no-cache"
	Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
	'Response.Buffer = False
%>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/Extenso.asp"-->
<%	
Dim objConn, strSQL
Dim objRS1, objRS2
Dim objFSO, objText
Dim strCOD_DADO, strMSG
Dim strDT_AGORA, strUSUARIO
Dim strSAIDA, strARQUIVO_LEITURA
Dim strVLR_REDUCAO, strALIQ_REDUCAO
Dim strEMISSOR_RAZAO_SOCIAL, strEMISSOR_ENDERECO, strEMISSOR_NUMERO, strEMISSOR_COMPLEMENTO, strEMISSOR_BAIRRO, strEMISSOR_CEP			
Dim	strEMISSOR_CIDADE, strEMISSOR_ESTADO, strEMISSOR_CNPJ, strEMISSOR_INSC_ESTADUAL, strEMISSOR_INSC_MUNICIPAL 
Dim strALIQ_IRRF, strALIQ_ISSQN, strVLR_IRRF, strVLR_ISSQN, strTOT_SERVICO, strVLR_BASE, strVLR_FINAL
'Dim strCOD_SERVICO, strSERV_TITULO, strSERV_DESC, strSERV_VLR
Dim strIMPR_MODELO_HTML, strIMPR_COD_FORNEC, strIMPR_NUM_LINHAS, strIMPR_TAM_LINHA
Dim arrItensCODIGO(), arrItensDESCRICAO(), arrItensVALOR(), arrItensQTDE()
Dim strDESCRICAO1, strDESCRICAO2, Cont1, Cont2

strCOD_DADO = GetParam("var_chavereg")

If strCOD_DADO <> "" Then
	AbreDBConn objConn, CFG_DB 
	
	'---------------------------------------
	' 1) Inicializações
	'---------------------------------------
	strMSG = ""
	strDT_AGORA = "'" & PrepDataBrToUni(Now, True) & "'"
	strUSUARIO = "'" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "'"
	
	'---------------------------------------
	' 2) Busca dados da Nota
	'---------------------------------------
	strSQL =          " SELECT T1.SITUACAO, T1.DT_EMISSAO, T1.DT_VCTO, T1.CODIGO, T1.TIPO, T1.VLR_CONTA " 
	strSQL = strSQL & "      , T2.VLR_BASE, T2.VLR_FINAL, T2.TOTAL_IMPOSTOS, T2.TOTAL_ISSQN, T2.TOTAL_IRPJ "
	strSQL = strSQL & "      , T2.TOTAL_PIS, T2.TOTAL_COFINS, T2.TOTAL_CSOCIAL, T2.TOTAL_IRRF, T2.COD_CFG_NF "
	strSQL = strSQL & "      , T2.ALIQ_ISSQN, T2.ALIQ_IRRF, T2.ALIQ_PIS, T2.ALIQ_COFINS, T2.ALIQ_CSOCIAL "
	
	strSQL = strSQL & "      , T3.NOME_FANTASIA AS CLI_NOME, T4.NOME_FANTASIA AS FORNEC_NOME, T5.NOME AS COLAB_NOME "
	
	strSQL = strSQL & "      , T3.NUM_DOC AS CLI_NUM_DOC1, T3.INSC_ESTADUAL AS CLI_NUM_DOC2, T3.FONE_1 AS CLI_FONE "
	strSQL = strSQL & "      , T4.NUM_DOC AS FORNEC_NUM_DOC1, T4.INSC_ESTADUAL AS FORNEC_NUM_DOC2, T4.FONE_1 AS FORNEC_FONE "
	strSQL = strSQL & "      , T5.CPF AS COLAB_NUM_DOC1, T5.RG AS COLAB_NUM_DOC2, T5.FONE_1 AS COLAB_FONE "
	
	strSQL = strSQL & "      , T3.FATURA_ENDERECO AS CLI_ENDERECO, T3.FATURA_COMPLEMENTO AS CLI_COMPLEMENTO, T3.FATURA_NUMERO AS CLI_NUMERO "
	strSQL = strSQL & "      , T3.FATURA_CEP AS CLI_CEP, T3.FATURA_BAIRRO AS CLI_BAIRRO, T3.FATURA_CIDADE AS CLI_CIDADE, T3.FATURA_ESTADO AS CLI_ESTADO "
	strSQL = strSQL & "      , T4.FATURA_ENDERECO AS FORNEC_ENDERECO, T4.FATURA_COMPLEMENTO AS FORNEC_COMPLEMENTO, T4.FATURA_NUMERO AS FORNEC_NUMERO "
	strSQL = strSQL & "      , T4.FATURA_CEP AS FORNEC_CEP, T4.FATURA_BAIRRO AS FORNEC_BAIRRO, T4.FATURA_CIDADE AS FORNEC_CIDADE, T4.FATURA_ESTADO AS FORNEC_ESTADO "
	strSQL = strSQL & "      , T5.ENDERECO AS COLAB_ENDERECO, T5.COMPLEMENTO AS COLAB_COMPLEMENTO, T5.NUMERO AS COLAB_NUMERO "
	strSQL = strSQL & "      , T5.CEP AS COLAB_CEP, T5.BAIRRO AS COLAB_BAIRRO, T5.CIDADE AS COLAB_CIDADE, T5.ESTADO AS COLAB_ESTADO "
	strSQL = strSQL & " FROM FIN_CONTA_PAGAR_RECEBER T1 "
	strSQL = strSQL & " INNER JOIN FIN_CONTA_PAGAR_RECEBER_TAXAS T2 ON (T1.COD_CONTA_PAGAR_RECEBER = T2.COD_CONTA_PAGAR_RECEBER) "
	strSQL = strSQL & " LEFT OUTER JOIN ENT_CLIENTE T3 ON (T1.CODIGO = T3.COD_CLIENTE AND T1.TIPO LIKE 'ENT_CLIENTE') "
	strSQL = strSQL & " LEFT OUTER JOIN ENT_FORNECEDOR T4 ON (T1.CODIGO = T4.COD_FORNECEDOR AND T1.TIPO LIKE 'ENT_FORNECEDOR') "
	strSQL = strSQL & " LEFT OUTER JOIN ENT_COLABORADOR T5 ON (T1.CODIGO = T5.COD_COLABORADOR AND T1.TIPO LIKE 'ENT_COLABORADOR') "
	strSQL = strSQL & " WHERE T1.COD_CONTA_PAGAR_RECEBER = " & strCOD_DADO
	strSQL = strSQL & " AND T1.SITUACAO <> 'CANCELADA' "
	strSQL = strSQL & " AND T1.MARCA_NFE = 'COM_NFE' "
	
	'athDebug "<br><br>" & strSQL, False
	
	AbreRecordSet objRS1, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	If Not objRS1.eof Then
		'-------------------------------------------------------------------
		' 3) Busca dados do modelo do recibo necessários à impressão
		'-------------------------------------------------------------------
		strSQL = " SELECT MODELO_HTML, COD_FORNEC, NUM_LINHAS, TAM_LINHA FROM CFG_NF WHERE COD_CFG_NF = " & GetValue(objRS1, "COD_CFG_NF")
		
		'athDebug "<br><br>" & strSQL, False
		
		AbreRecordSet objRS2, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		
		If Not objRS2.eof Then
			strIMPR_MODELO_HTML = GetValue(objRS2, "MODELO_HTML")
			strIMPR_COD_FORNEC = GetValue(objRS2, "COD_FORNEC")
			strIMPR_NUM_LINHAS = GetValue(objRS2, "NUM_LINHAS")
			strIMPR_TAM_LINHA = GetValue(objRS2, "TAM_LINHA")
		Else
			strMSG = strMSG & "Dados do Modelo não foram encontrados.<br>"
		End If
		FechaRecordSet objRS2
		
		If strIMPR_MODELO_HTML = "" Then strMSG = strMSG & "Arquivo modelo para gerar arquivo HTML do Recibo não foi encontrado.<br>"
		If strIMPR_COD_FORNEC = "" Then strMSG = strMSG & "Não existe um emissor para o Recibo.<br>"
		If strIMPR_NUM_LINHAS = "" Then strMSG = strMSG & "Dados insuficientes para imprimir itens.<br>"
		If strIMPR_TAM_LINHA = "" Then strMSG = strMSG & "Dados insuficientes para imprimir itens.<br>"
		
		'---------------------------------------
		' 4) Busca dados do emissor
		'---------------------------------------
		If strMSG = "" Then
			strSQL =          " SELECT RAZAO_SOCIAL, FATURA_ENDERECO, FATURA_NUMERO, FATURA_COMPLEMENTO, FATURA_BAIRRO " 
			strSQL = strSQL & "      , FATURA_CEP, FATURA_ESTADO, FATURA_CIDADE, NUM_DOC, INSC_ESTADUAL, INSC_MUNICIPAL "
			strSQL = strSQL & " FROM ENT_FORNECEDOR WHERE COD_FORNECEDOR = " & strIMPR_COD_FORNEC
			
			'athDebug "<br><br>" & strSQL, False
			
			AbreRecordSet objRS2, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
			
			If Not objRS2.EOF Then	
				strEMISSOR_RAZAO_SOCIAL   = GetValue(objRS2, "RAZAO_SOCIAL")
				strEMISSOR_ENDERECO		  = GetValue(objRS2, "FATURA_ENDERECO")
				strEMISSOR_NUMERO		  = GetValue(objRS2, "FATURA_NUMERO")
				strEMISSOR_COMPLEMENTO	  = GetValue(objRS2, "FATURA_COMPLEMENTO")
				strEMISSOR_BAIRRO 		  = GetValue(objRS2, "FATURA_BAIRRO")
				strEMISSOR_CEP			  = GetValue(objRS2, "FATURA_CEP")
				strEMISSOR_CIDADE		  = GetValue(objRS2, "FATURA_CIDADE")
				strEMISSOR_ESTADO		  = GetValue(objRS2, "FATURA_ESTADO")
				strEMISSOR_CNPJ 		  = GetValue(objRS2, "NUM_DOC")
				strEMISSOR_INSC_ESTADUAL  = GetValue(objRS2, "INSC_ESTADUAL")
				strEMISSOR_INSC_MUNICIPAL = GetValue(objRS2, "INSC_MUNICIPAL")
			Else
				strMSG = strMSG & "Dados do Emissor não foram encontrados.<br>"
			End If
			FechaRecordSet objRS2
		End If
		
		'---------------------------------
		' 5) Abre arquivo de modelo
		'---------------------------------
		If strMSG = "" Then
			strSAIDA = ""
			strARQUIVO_LEITURA = Server.MapPath("..\upload\" & Request.Cookies("VBOSS")("CLINAME") & "\_modelos\" & strIMPR_MODELO_HTML)
			Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
			If objFSO.FileExists(strARQUIVO_LEITURA) Then
				Set objFSO = objFSO.OpenTextFile(strARQUIVO_LEITURA, 1, True)
				
				Do While NOT objFSO.AtEndOfStream
					strSAIDA = strSAIDA & objFSO.ReadLine & vbCrLf
				Loop
				objFSO.Close
			Else
				strMSG = strMSG & "Não foi possível ler arquivo de modelo de Recibo<br>"
			End If
			
			Set objFSO = Nothing
			Set objText = Nothing
		End If
		
		'-----------------------------------------------
		' 6) Busca o item de serviço
		'-----------------------------------------------
		If strMSG = "" Then
			strSQL =          " SELECT T3.COD_SERVICO, T3.TITULO, T3.DESCRICAO "
			strSQL = strSQL & " FROM FIN_CONTA_PAGAR_RECEBER T1, CONTRATO T2, SV_SERVICO T3 "
			strSQL = strSQL & " WHERE T1.COD_CONTA_PAGAR_RECEBER = " & strCOD_DADO
			strSQL = strSQL & " AND T1.COD_CONTRATO = T2.COD_CONTRATO "
			strSQL = strSQL & " AND T2.COD_SERVICO = T3.COD_SERVICO "
			
			'athDebug "<br><br>" & strSQL, False
			
			AbreRecordSet objRS2, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
			
			If Not objRS2.eof Then
				ReDim arrItensCODIGO   (strIMPR_NUM_LINHAS)
				ReDim arrItensDESCRICAO(strIMPR_NUM_LINHAS)
				ReDim arrItensVALOR    (strIMPR_NUM_LINHAS)
				ReDim arrItensQTDE     (strIMPR_NUM_LINHAS)
				
				Cont1 = 0
				Do While Not objRS2.Eof
					strDESCRICAO1 = GetValue(objRS2, "TITULO")
					If GetValue(objRS2, "DESCRICAO") <> "" Then strDESCRICAO1 = strDESCRICAO1 & " - " & GetValue(objRS2, "DESCRICAO")
					
					If Len(strDESCRICAO1) <= strIMPR_TAM_LINHA Then
						Cont1 = Cont1 + 1
						
						arrItensCODIGO   (Cont1) = ATHFormataTamLeft(GetValue(objRS2, "COD_SERVICO"), 4, "0") & " =>"
						arrItensDESCRICAO(Cont1) = strDESCRICAO1
						arrItensVALOR    (Cont1) = FormataDecimal(GetValue(objRS1, "VLR_CONTA"), 2)
						arrItensQTDE     (Cont1) = "1"
					Else
						Cont2 = 1
						Do
							strDESCRICAO2 = Mid(strDESCRICAO1, Cont2, strIMPR_TAM_LINHA)
							If strDESCRICAO2 <> "" Then
								Cont1 = Cont1 + 1
								arrItensDESCRICAO(Cont1) = strDESCRICAO2
								If Cont2 = 1 Then
									arrItensCODIGO(Cont1) = ATHFormataTamLeft(GetValue(objRS2, "COD_SERVICO"), 4, "0") & " =>"
									arrItensVALOR (Cont1) = FormataDecimal(GetValue(objRS1, "VLR_CONTA"), 2)
									arrItensQTDE  (Cont1) = "1"
								Else
									arrItensCODIGO(Cont1) = ""
									arrItensVALOR (Cont1) = ""
									arrItensQTDE  (Cont1) = ""
								End If
								
								Cont2 = Cont2 + strIMPR_TAM_LINHA
							End If
						Loop While strDESCRICAO2 <> ""
					End If
					
					objRS2.MoveNext
				Loop
			Else
				'strMSG = strMSG & "Não foi encontrado item de serviço!<br>"
			End If
			
			FechaRecordSet objRS2
		End If
		
		'-----------------------------------
		' 7) Monta página a ser impressa
		'-----------------------------------
		If strMSG = "" Then
			strSAIDA = Replace(strSAIDA, "<TAG_CAMINHO>"    , FindLogicalPath() & "/upload/" & Request.Cookies("VBOSS")("CLINAME") & "/_img")
			strSAIDA = Replace(strSAIDA, "<TAG_DT_EMISSAO>" , PrepData(GetValue(objRS1, "DT_EMISSAO"), True, False))
			strSAIDA = Replace(strSAIDA, "<TAG_MES_EMISSAO>", UCase(MesExtenso(DatePart("M", GetValue(objRS1, "DT_EMISSAO")))) & "/" & DatePart("YYYY", GetValue(objRS1, "DT_EMISSAO")))
			strSAIDA = Replace(strSAIDA, "<TAG_DT_VCTO>"    , PrepData(GetValue(objRS1, "DT_VCTO"), True, False))
			
			'Dados de quem emite o recibo
			strSAIDA = Replace(strSAIDA, "<TAG_EMISSOR_RAZAO_SOCIAL>"  , strEMISSOR_RAZAO_SOCIAL)
			strSAIDA = Replace(strSAIDA, "<TAG_EMISSOR_ENDERECO>"      , strEMISSOR_ENDERECO)
			strSAIDA = Replace(strSAIDA, "<TAG_EMISSOR_NUMERO>"        , strEMISSOR_NUMERO)
			strSAIDA = Replace(strSAIDA, "<TAG_EMISSOR_COMPLEMENTO>"   , strEMISSOR_COMPLEMENTO)
			strSAIDA = Replace(strSAIDA, "<TAG_EMISSOR_BAIRRO>"        , strEMISSOR_BAIRRO)
			strSAIDA = Replace(strSAIDA, "<TAG_EMISSOR_CEP>"           , strEMISSOR_CEP)
			strSAIDA = Replace(strSAIDA, "<TAG_EMISSOR_CIDADE>"        , strEMISSOR_CIDADE)
			strSAIDA = Replace(strSAIDA, "<TAG_EMISSOR_ESTADO>"        , strEMISSOR_ESTADO)
			strSAIDA = Replace(strSAIDA, "<TAG_EMISSOR_CNPJ>"          , strEMISSOR_CNPJ)
			strSAIDA = Replace(strSAIDA, "<TAG_EMISSOR_INSC_ESTADUAL>" , strEMISSOR_INSC_ESTADUAL)
			strSAIDA = Replace(strSAIDA, "<TAG_EMISSOR_INSC_MUNICIPAL>", strEMISSOR_INSC_MUNICIPAL)
			
			'Dados de quem vai receber o recibo
			If GetValue(objRS1, "TIPO") = "ENT_CLIENTE" Then
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_NOME>"         , "(" & ATHFormataTamLeft(GetValue(objRS1, "CODIGO"), 5, "0") & ") " & GetValue(objRS1, "CLI_NOME"))
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_NUM_DOC>"      , GetValue(objRS1, "CLI_NUM_DOC1"))
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_INSC_ESTADUAL>", GetValue(objRS1, "CLI_NUM_DOC2"))
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_ENDER>"        , GetValue(objRS1, "CLI_ENDERECO"))
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_CEP>"          , GetValue(objRS1, "CLI_CEP"))
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_BAIRRO>"       , GetValue(objRS1, "CLI_BAIRRO"))
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_CIDADE>"       , GetValue(objRS1, "CLI_CIDADE"))
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_ESTADO>"       , GetValue(objRS1, "CLI_ESTADO"))
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_FONE>"         , GetValue(objRS1, "CLI_FONE"))
			End If
			If GetValue(objRS1, "TIPO") = "ENT_FORNECEDOR" Then
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_NOME>"         , "(" & ATHFormataTamLeft(GetValue(objRS1, "CODIGO"), 5, "0") & ") " & GetValue(objRS1, "FORNEC_NOME"))
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_NUM_DOC>"      , GetValue(objRS1, "FORNEC_NUM_DOC1"))
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_INSC_ESTADUAL>", GetValue(objRS1, "FORNEC_NUM_DOC2"))
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_ENDER>"        , GetValue(objRS1, "FORNEC_ENDERECO"))
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_CEP>"          , GetValue(objRS1, "FORNEC_CEP"))
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_BAIRRO>"       , GetValue(objRS1, "FORNEC_BAIRRO"))
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_CIDADE>"       , GetValue(objRS1, "FORNEC_CIDADE"))
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_ESTADO>"       , GetValue(objRS1, "FORNEC_ESTADO"))
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_FONE>"         , GetValue(objRS1, "FORNEC_FONE"))
			End If
			If GetValue(objRS1, "TIPO") = "ENT_COLABORADOR" Then
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_NOME>"         , "(" & ATHFormataTamLeft(GetValue(objRS1, "CODIGO"), 5, "0") & ") " & GetValue(objRS1, "COLAB_NOME"))
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_NUM_DOC>"      , GetValue(objRS1, "COLAB_NUM_DOC1"))
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_INSC_ESTADUAL>", GetValue(objRS1, "COLAB_NUM_DOC2"))
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_ENDER>"        , GetValue(objRS1, "COLAB_ENDERECO"))
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_CEP>"          , GetValue(objRS1, "COLAB_CEP"))
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_BAIRRO>"       , GetValue(objRS1, "COLAB_BAIRRO"))
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_CIDADE>"       , GetValue(objRS1, "COLAB_CIDADE"))
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_ESTADO>"       , GetValue(objRS1, "COLAB_ESTADO"))
				strSAIDA = Replace(strSAIDA, "<TAG_CLI_FONE>"         , GetValue(objRS1, "COLAB_FONE"))
			End If
			
			Cont2 = 1
			Do While (Cont2 <= Cont1) And (Cont2 <= strIMPR_NUM_LINHAS)
				strSAIDA = Replace(strSAIDA, "<TAG_ITEM_CODIGO_"    & Cont2 & ">", arrItensCODIGO   (Cont2))
				strSAIDA = Replace(strSAIDA, "<TAG_ITEM_DESCRICAO_" & Cont2 & ">", arrItensDESCRICAO(Cont2))
				strSAIDA = Replace(strSAIDA, "<TAG_ITEM_VALOR_"     & Cont2 & ">", arrItensVALOR    (Cont2))
				strSAIDA = Replace(strSAIDA, "<TAG_ITEM_QTDE_"      & Cont2 & ">", arrItensQTDE     (Cont2))
				
				Cont2 = Cont2 + 1
			Loop
			
			strALIQ_IRRF    = CDbl("0" & GetValue(objRS1, "ALIQ_IRRF"))
			strALIQ_ISSQN   = CDbl("0" & GetValue(objRS1, "ALIQ_ISSQN"))
			strVLR_IRRF     = CDbl("0" & GetValue(objRS1, "TOTAL_IRRF"))
			strVLR_ISSQN    = CDbl("0" & GetValue(objRS1, "TOTAL_ISSQN"))
			strVLR_BASE     = CDbl("0" & GetValue(objRS1, "VLR_BASE"))
			strVLR_FINAL    = CDbl("0" & GetValue(objRS1, "VLR_FINAL"))
			strVLR_REDUCAO  = CDbl("0" & GetValue(objRS1, "TOTAL_PIS")) + CDbl("0" & GetValue(objRS1, "TOTAL_COFINS")) + CDbl("0" & GetValue(objRS1, "TOTAL_CSOCIAL"))
			strALIQ_REDUCAO = CDbl("0" & GetValue(objRS1, "ALIQ_PIS")) + CDbl("0" & GetValue(objRS1, "ALIQ_COFINS")) + CDbl("0" & GetValue(objRS1, "ALIQ_CSOCIAL"))
			
			If strVLR_IRRF > 0 Then
				strSAIDA = Replace(strSAIDA, "<TAG_IRRF_DESCRICAO>", "(" & FormataDecimal(strALIQ_IRRF, 2) & "%)")
				strSAIDA = Replace(strSAIDA, "<TAG_IRRF_VALOR>"    , FormataDecimal(strVLR_IRRF, 2))
			Else
				strSAIDA = Replace(strSAIDA, "<TAG_IRRF_DESCRICAO>", "-")
				strSAIDA = Replace(strSAIDA, "<TAG_IRRF_VALOR>"    , "-")
			End If
			
			If strVLR_REDUCAO > 0 Then
				strSAIDA = Replace(strSAIDA, "<TAG_REDUCAO_DESCRICAO>", "(" & FormataDecimal(strALIQ_REDUCAO, 2) & "%)")
				strSAIDA = Replace(strSAIDA, "<TAG_REDUCAO_VALOR>"    , FormataDecimal(strVLR_REDUCAO, 2))
			Else
				strSAIDA = Replace(strSAIDA, "<TAG_REDUCAO_DESCRICAO>", "-")
				strSAIDA = Replace(strSAIDA, "<TAG_REDUCAO_VALOR>"    , "-")
			End If
			
			strSAIDA = Replace(strSAIDA, "<TAG_ISSQN>"        , "(" & FormataDecimal(strALIQ_ISSQN, 2) & "%) " & FormataDecimal(strVLR_ISSQN, 2))
			strSAIDA = Replace(strSAIDA, "<TAG_VLR_BASE>"     , FormataDecimal(strVLR_BASE, 2))
			strSAIDA = Replace(strSAIDA, "<TAG_VLR_FINAL>"    , FormataDecimal(strVLR_FINAL, 2))
			strSAIDA = Replace(strSAIDA, "<TAG_VALOR_EXTENSO>", Extenso(strVLR_FINAL))
			
			If strSAIDA = "" Then strMSG = strMSG & "Arquivo final não pôde ser gerado!<br>"
		End If
	Else
		strMSG = strMSG & "Título não foi encontrado!<br>"
	End If
	FechaRecordSet objRS1
	
	If strMSG <> "" Then
		Mensagem strMSG, "Javascript:window.close();", "Fechar", 1
	Else
		Response.Write(strSAIDA)
		%>
		<script type="text/javascript" language="JavaScript">
			window.print();
		</script>
		<%
	End If
	
	FechaDBConn objConn
End If
%>