<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|PRINT|", BuscaDireitosFromDB("modulo_FIN_NF", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
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
Dim objRS1, objRS2, objRS3, objRS4, objRSCT
Dim objFSO, objText
Dim Cont1, Cont2, Cont3
Dim intCodNF, strMSG
Dim strDT_AGORA, strDT_VCTO, strUSUARIO, strDESCRICAO1, strDESCRICAO2
Dim strSAIDA1, strSAIDA2, strSAIDA3, strSAIDA4, strARQUIVO_LEITURA, strARQUIVO_ESCRITA1, strARQUIVO_ESCRITA2, strSEQUENCIA
Dim strVLR_REDUCAO_OUTROS, strALIQ_REDUCAO_OUTROS
Dim strNRO_FOLHA_ATUAL, strNRO_FOLHAS_NF, strNUM_LINHAS, strTAM_LINHA
Dim strNUM_NF, strNUM_NF_Frmt, strNUM_FORM, strNUM_FORM_Prim, strNUM_FORM_Ult
Dim arrItensCODIGO(), arrItensDESCRICAO(), arrItensVALOR(), arrItensQTDE()
Dim strEMISSOR_RAZAO_SOCIAL, strEMISSOR_ENDERECO, strEMISSOR_NUMERO, strEMISSOR_COMPLEMENTO, strEMISSOR_BAIRRO, strEMISSOR_CEP			
Dim	strEMISSOR_CIDADE, strEMISSOR_ESTADO, strEMISSOR_CNPJ, strEMISSOR_INSC_ESTADUAL, strEMISSOR_INSC_MUNICIPAL 
Dim strALIQ_IRRF, strALIQ_ISSQN, strVLR_IRRF, strVLR_ISSQN, strTOT_SERVICO, strTOT_NF, strVLR_COMISSAO

Function CalculaNumeroFolhas(prCOD_NF,prNRO_ITENS_FOLHA,prTAM_LINHA)
Dim strSQL, objRS
Dim strDESCRICAO, strTAM, strNUM_LINHAS, strNUM_FOLHAS

    strNUM_LINHAS = 0
	
	strSQL =          " SELECT TIT_SERVICO, DESC_SERVICO, DESC_EXTRA "
	strSQL = strSQL & " FROM NF_ITEM WHERE COD_NF = " & prCOD_NF 
	strSQL = strSQL & " ORDER BY TIT_SERVICO, DESC_EXTRA "
	
	Set objRS = objConn.execute(strSQL)
	Do While Not objRS.EOF
		'---------------------------------------------
		' Define texto do item
		'---------------------------------------------
		strDESCRICAO = GetValue(objRS, "TIT_SERVICO")
		If GetValue(objRS, "DESC_EXTRA") <> "" Then strDESCRICAO = strDESCRICAO & " - " & GetValue(objRS, "DESC_EXTRA")
		
		'---------------------------------------------
		' Define números de linhas que vai precisar
		'---------------------------------------------
		strTAM = Len(strDESCRICAO)
		strNUM_LINHAS = strNUM_LINHAS + (strTAM \ prTAM_LINHA) 'The \ operator divides two numbers and returns an integer (fixed-point)
		If strTAM Mod prTAM_LINHA > 0 Then strNUM_LINHAS = strNUM_LINHAS + 1
		
		objRS.MoveNext
	Loop
	FechaRecordSet objRS
	
	If prNRO_ITENS_FOLHA > 0 Then
		strNUM_FOLHAS = strNUM_LINHAS \ prNRO_ITENS_FOLHA 'The \ operator divides two numbers and returns an integer (fixed-point)
		If strNUM_LINHAS Mod prNRO_ITENS_FOLHA > 0 Then strNUM_FOLHAS = strNUM_FOLHAS + 1
	Else
		strNUM_FOLHAS = 1
	End If
	
	CalculaNumeroFolhas = strNUM_FOLHAS
End Function


intCodNF = GetParam("var_chavereg")

If intCodNF <> "" Then
	AbreDBConn objConn, CFG_DB 
	
	'---------------------------------------
	' 1) Inicializações
	'---------------------------------------
	strMSG = ""
	strDT_AGORA = "'" & PrepDataBrToUni(Now, True) & "'"
	strUSUARIO = "'" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "'"
	strNUM_NF = ""
	strNUM_FORM = ""
	strNRO_FOLHA_ATUAL = ""
	strNRO_FOLHAS_NF = ""
	
	'---------------------------------------
	' 2) Busca dados da Nota
	'---------------------------------------
	strSQL =          " SELECT COD_CFG_NF, SITUACAO, DT_EMISSAO, OBS_NF " 
	strSQL = strSQL & "      , COD_CLI, CLI_NOME, CLI_ENDER, CLI_NUM_DOC, CLI_INSC_ESTADUAL, CLI_CEP "
	strSQL = strSQL & "      , CLI_BAIRRO, CLI_CIDADE, CLI_ESTADO, CLI_FONE "
	strSQL = strSQL & "      , TOT_SERVICO, TOT_NF, TOT_IMPOSTO, TOT_IMPOSTO_CLI "
	strSQL = strSQL & "      , VLR_ISSQN, VLR_IRPJ, VLR_PIS, VLR_COFINS, VLR_CSOCIAL, VLR_IRRF "
	strSQL = strSQL & "      , VLR_COMISSAO, PRZ_VCTO "
	strSQL = strSQL & " FROM NF_NOTA WHERE COD_NF = " & intCodNF
	strSQL = strSQL & " AND SITUACAO = 'NAO_EMITIDA' "
	
	AbreRecordSet objRS1, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	'-------------------------------------------------------------------
	' 3) Busca dados do modelo da Nota necessários à impressão
	'-------------------------------------------------------------------
	If Not objRS1.eof Then
		strSQL =          " SELECT MODELO_HTML, TIPO, ULT_NUM_NF, ULT_NUM_FORM, NUM_LINHAS, TAM_LINHA " 
		strSQL = strSQL & "      , ALIQ_ISSQN, ALIQ_IRRF, ALIQ_PIS, ALIQ_COFINS, ALIQ_CSOCIAL, COD_FORNEC " 
		strSQL = strSQL & " FROM CFG_NF WHERE COD_CFG_NF = " & GetValue(objRS1, "COD_CFG_NF")
		
		AbreRecordSet objRS2, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		
		If Not objRS2.eof Then
			If ((GetValue(objRS2, "TIPO") = "PADRAO") Or (GetValue(objRS2, "TIPO") = "EXTENDIDO")) And (GetValue(objRS2, "MODELO_HTML") <> "") And (GetValue(objRS2, "ULT_NUM_NF") <> "") And (GetValue(objRS2, "ULT_NUM_FORM") <> "") And (GetValue(objRS2, "NUM_LINHAS") <> "") And (GetValue(objRS2, "TAM_LINHA") <> "") Then
				strNRO_FOLHA_ATUAL = 1
				strNRO_FOLHAS_NF = CalculaNumeroFolhas(intCodNF, GetValue(objRS2, "NUM_LINHAS"), GetValue(objRS2, "TAM_LINHA"))
				
				If GetValue(objRS2, "TIPO") = "PADRAO" And strNRO_FOLHAS_NF > 1 Then
					strMSG = strMSG & "A Nota Fiscal possui muitos itens. A impressão não caberá no formulário.<br>"
				End If
			Else
				strMSG = strMSG & "Dados do Modelo estão incorretos!<br>[" & GetValue(objRS2, "MODELO_HTML") & "][" & GetValue(objRS2, "TIPO") & "][" & GetValue(objRS2, "ULT_NUM_NF") & "][" & GetValue(objRS2, "ULT_NUM_FORM") & "][" & GetValue(objRS2, "NUM_LINHAS") & "][" & GetValue(objRS2, "TAM_LINHA") & "]"
			End If
		Else
			strMSG = strMSG & "Dados do Modelo não foram encontrados.<br>"
		End If
		
		'---------------------------------------
		' 4) Busca dados do emissor
		'---------------------------------------
		strSQL =          " SELECT RAZAO_SOCIAL, FATURA_ENDERECO, FATURA_NUMERO, FATURA_COMPLEMENTO, FATURA_BAIRRO " 
		strSQL = strSQL & "      , FATURA_CEP, FATURA_ESTADO, FATURA_CIDADE, NUM_DOC, INSC_ESTADUAL, INSC_MUNICIPAL "
		strSQL = strSQL & " FROM ENT_FORNECEDOR WHERE COD_FORNECEDOR = " & GetValue(objRS2, "COD_FORNEC")
		
		AbreRecordSet objRS4, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		
		If Not objRS4.EOF Then	
			strEMISSOR_RAZAO_SOCIAL   = GetValue(objRS4, "RAZAO_SOCIAL")
			strEMISSOR_ENDERECO		  = GetValue(objRS4, "FATURA_ENDERECO")
			strEMISSOR_NUMERO		  = GetValue(objRS4, "FATURA_NUMERO")
			strEMISSOR_COMPLEMENTO	  = GetValue(objRS4, "FATURA_COMPLEMENTO")
			strEMISSOR_BAIRRO 		  = GetValue(objRS4, "FATURA_BAIRRO")
			strEMISSOR_CEP			  = GetValue(objRS4, "FATURA_CEP")
			strEMISSOR_CIDADE		  = GetValue(objRS4, "FATURA_CIDADE")
			strEMISSOR_ESTADO		  = GetValue(objRS4, "FATURA_ESTADO")
			strEMISSOR_CNPJ 		  = GetValue(objRS4, "NUM_DOC")
			strEMISSOR_INSC_ESTADUAL  = GetValue(objRS4, "INSC_ESTADUAL")
			strEMISSOR_INSC_MUNICIPAL = GetValue(objRS4, "INSC_MUNICIPAL")
		End If
		FechaRecordSet objRS4
		
		'-----------------------------------
		' 5) Prepara valores
		'-----------------------------------
		strNUM_FORM = CInt(GetValue(objRS2, "ULT_NUM_FORM")) + 1
		
		strNUM_NF = CInt(GetValue(objRS2, "ULT_NUM_NF")) + 1
		strNUM_NF_Frmt = strNUM_NF
		strNUM_NF_Frmt = ATHFormataTamLeft(strNUM_NF_Frmt, 5, "0")
		
		strVLR_REDUCAO_OUTROS  = CDbl("0" & GetValue(objRS1, "VLR_PIS"))  + CDbl("0" & GetValue(objRS1, "VLR_COFINS"))  + CDbl("0" & GetValue(objRS1, "VLR_CSOCIAL"))
		strALIQ_REDUCAO_OUTROS = CDbl("0" & GetValue(objRS2, "ALIQ_PIS")) + CDbl("0" & GetValue(objRS2, "ALIQ_COFINS")) + CDbl("0" & GetValue(objRS2, "ALIQ_CSOCIAL"))
		
		strNUM_LINHAS = GetValue(objRS2, "NUM_LINHAS")
		strTAM_LINHA = GetValue(objRS2, "TAM_LINHA")
		
		If IsDate(GetValue(objRS1, "DT_EMISSAO")) And IsNumeric(GetValue(objRS1, "PRZ_VCTO")) Then
			strDT_VCTO = DateAdd("D", GetValue(objRS1, "PRZ_VCTO"), GetValue(objRS1, "DT_EMISSAO"))
			strDT_VCTO = PrepData(strDT_VCTO, True, False)
		End If
		
		'---------------------------------
		' 6) Abre arquivo de modelo
		'---------------------------------
		If strMSG = "" Then
			strSAIDA1 = ""
			strARQUIVO_LEITURA = Server.MapPath("..\upload\" & Request.Cookies("VBOSS")("CLINAME") & "\_modelos\" & GetValue(objRS2, "MODELO_HTML")) 
			Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
			If objFSO.FileExists(strARQUIVO_LEITURA) Then
				Set objFSO = objFSO.OpenTextFile(strARQUIVO_LEITURA, 1, True)
				
				Do While NOT objFSO.AtEndOfStream
					strSAIDA1 = strSAIDA1 & objFSO.ReadLine & vbCrLf
				Loop
				objFSO.Close
			Else
				strMSG = strMSG & "Não foi possível ler arquivo de modelo de Nota Fiscal<br>"
			End If
			
			Set objFSO = Nothing
			Set objText = Nothing
		End If
		
		'-----------------------------------------------
		' 7) Busca os itens da Nota e põe nos arrays
		'-----------------------------------------------
		If strMSG = "" Then
			strSQL =          " SELECT COD_SERVICO, TIT_SERVICO, DESC_SERVICO, DESC_EXTRA, OBS_SERVICO, VALOR, 1 AS QTDE "
			strSQL = strSQL & " FROM NF_ITEM WHERE COD_NF = " & intCodNF
			strSQL = strSQL & " ORDER BY TIT_SERVICO, DESC_EXTRA "
			
			AbreRecordSet objRS3, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
			
			If Not objRS3.eof Then
				ReDim arrItensCODIGO   (strNRO_FOLHAS_NF * strNUM_LINHAS)
				ReDim arrItensDESCRICAO(strNRO_FOLHAS_NF * strNUM_LINHAS)
				ReDim arrItensVALOR    (strNRO_FOLHAS_NF * strNUM_LINHAS)
				ReDim arrItensQTDE     (strNRO_FOLHAS_NF * strNUM_LINHAS)
				
				Cont1 = 0
				Do While Not objRS3.Eof
					strDESCRICAO1 = GetValue(objRS3, "TIT_SERVICO")
					If GetValue(objRS3, "DESC_EXTRA") <> "" Then strDESCRICAO1 = strDESCRICAO1 & " - " & GetValue(objRS3, "DESC_EXTRA")
					
					If Len(strDESCRICAO1) <= strTAM_LINHA Then
						Cont1 = Cont1 + 1
						
						arrItensCODIGO   (Cont1) = ATHFormataTamLeft(GetValue(objRS3, "COD_SERVICO"), 4, "0") & " =>"
						arrItensDESCRICAO(Cont1) = strDESCRICAO1
						arrItensVALOR    (Cont1) = FormataDecimal(GetValue(objRS3, "VALOR"), 2)
						arrItensQTDE     (Cont1) = FormataDecimal(GetValue(objRS3, "QTDE"), 2)
					Else
						Cont2 = 1
						Do
							strDESCRICAO2 = Mid(strDESCRICAO1, Cont2, strTAM_LINHA)
							If strDESCRICAO2 <> "" Then
								Cont1 = Cont1 + 1
								arrItensDESCRICAO(Cont1) = strDESCRICAO2
								If Cont2 = 1 Then
									arrItensCODIGO(Cont1) = ATHFormataTamLeft(GetValue(objRS3, "COD_SERVICO"), 4, "0") & " =>"
									arrItensVALOR (Cont1) = FormataDecimal(GetValue(objRS3, "VALOR"), 2)
									arrItensQTDE  (Cont1) = FormataDecimal(GetValue(objRS3, "QTDE"), 2)
								Else
									arrItensCODIGO(Cont1) = ""
									arrItensVALOR (Cont1) = ""
									arrItensQTDE  (Cont1) = ""
								End If
								
								Cont2 = Cont2 + strTAM_LINHA
							End If
						Loop While strDESCRICAO2 <> ""
					End If
					
					objRS3.MoveNext
				Loop
			Else
				strMSG = strMSG & "Nota Fiscal não possui itens!<br>"
			End If
			
			FechaRecordSet objRS3
		End If
		
		'-----------------------------------
		' 8) Monta página a ser impressa
		'-----------------------------------
		If strMSG = "" Then
			strSAIDA3 = ""
			strNUM_FORM_Prim = strNUM_FORM
			Cont2 = 1
			
			For strNRO_FOLHA_ATUAL = 1 To strNRO_FOLHAS_NF
				strSAIDA2 = strSAIDA1
				
				If strNRO_FOLHAS_NF > 1 Then strSAIDA2 = Replace(strSAIDA2, "<TAG_FOLHA>", "(Fl " & strNRO_FOLHA_ATUAL & "/" & strNRO_FOLHAS_NF & ")")
				
				'Na montagem que é enviada à impressora não sai o numero da NF
				'Não saia impresso o numero da NF, agora sai porque estamos emitindo NFe
				strSAIDA2 = Replace(strSAIDA2, "<TAG_NUM_NFsf>"			, strNUM_NF)
				strSAIDA2 = Replace(strSAIDA2, "<TAG_NUM_NFcf>"			, strNUM_NF_Frmt)
				strSAIDA2 = Replace(strSAIDA2, "<TAG_CAMINHO>"			, FindLogicalPath() & "/upload/" & Request.Cookies("VBOSS")("CLINAME") & "/_img")
				strSAIDA2 = Replace(strSAIDA2, "<TAG_DT_EMISSAO>"		, PrepData(GetValue(objRS1, "DT_EMISSAO"), True, False))
				strSAIDA2 = Replace(strSAIDA2, "<TAG_MES_EMISSAO>"		, UCase(MesExtenso(DatePart("M", GetValue(objRS1, "DT_EMISSAO")))) & "/" & DatePart("YYYY", GetValue(objRS1, "DT_EMISSAO")))
				strSAIDA2 = Replace(strSAIDA2, "<TAG_DT_VCTO>"			, strDT_VCTO)
				strSAIDA2 = Replace(strSAIDA2, "<TAG_OBS>"				, GetValue(objRS1, "OBS_NF"))
				
				'Dados do cliente para quem a nota está sendo emitida
				strSAIDA2 = Replace(strSAIDA2, "<TAG_CLI_NOME>"			, "(" & ATHFormataTamLeft(GetValue(objRS1, "COD_CLI"), 5, "0") & ") " & GetValue(objRS1, "CLI_NOME"))
				strSAIDA2 = Replace(strSAIDA2, "<TAG_CLI_NUM_DOC>"		, GetValue(objRS1, "CLI_NUM_DOC"))
				strSAIDA2 = Replace(strSAIDA2, "<TAG_CLI_INSC_ESTADUAL>", GetValue(objRS1, "CLI_INSC_ESTADUAL"))
				strSAIDA2 = Replace(strSAIDA2, "<TAG_CLI_ENDER>"		, GetValue(objRS1, "CLI_ENDER"))
				strSAIDA2 = Replace(strSAIDA2, "<TAG_CLI_CEP>"			, GetValue(objRS1, "CLI_CEP"))
				strSAIDA2 = Replace(strSAIDA2, "<TAG_CLI_BAIRRO>"		, GetValue(objRS1, "CLI_BAIRRO"))
				strSAIDA2 = Replace(strSAIDA2, "<TAG_CLI_CIDADE>"		, GetValue(objRS1, "CLI_CIDADE"))
				strSAIDA2 = Replace(strSAIDA2, "<TAG_CLI_ESTADO>"		, GetValue(objRS1, "CLI_ESTADO"))
				strSAIDA2 = Replace(strSAIDA2, "<TAG_CLI_FONE>"			, GetValue(objRS1, "CLI_FONE"))
				
				'Dados do cliente que emite a nota
				strSAIDA2 = Replace(strSAIDA2, "<TAG_EMISSOR_RAZAO_SOCIAL>" 	, strEMISSOR_RAZAO_SOCIAL)
				strSAIDA2 = Replace(strSAIDA2, "<TAG_EMISSOR_ENDERECO>" 		, strEMISSOR_ENDERECO)
				strSAIDA2 = Replace(strSAIDA2, "<TAG_EMISSOR_NUMERO>" 			, strEMISSOR_NUMERO)
				strSAIDA2 = Replace(strSAIDA2, "<TAG_EMISSOR_COMPLEMENTO>" 		, strEMISSOR_COMPLEMENTO)
				strSAIDA2 = Replace(strSAIDA2, "<TAG_EMISSOR_BAIRRO>" 			, strEMISSOR_BAIRRO)
				strSAIDA2 = Replace(strSAIDA2, "<TAG_EMISSOR_CEP>" 				, strEMISSOR_CEP)
				strSAIDA2 = Replace(strSAIDA2, "<TAG_EMISSOR_CIDADE>" 			, strEMISSOR_CIDADE)
				strSAIDA2 = Replace(strSAIDA2, "<TAG_EMISSOR_ESTADO>" 			, strEMISSOR_ESTADO)
				strSAIDA2 = Replace(strSAIDA2, "<TAG_EMISSOR_CNPJ>" 			, strEMISSOR_CNPJ)
				strSAIDA2 = Replace(strSAIDA2, "<TAG_EMISSOR_INSC_ESTADUAL>"	, strEMISSOR_INSC_ESTADUAL)
				strSAIDA2 = Replace(strSAIDA2, "<TAG_EMISSOR_INSC_MUNICIPAL>"	, strEMISSOR_INSC_MUNICIPAL)
				
				Cont3 = 1
				Do While (Cont2 <= Cont1) And (Cont3 <= strNUM_LINHAS)
					strSAIDA2 = Replace(strSAIDA2, "<TAG_ITEM_CODIGO_"    & Cont3 & ">", arrItensCODIGO   (Cont2))
					strSAIDA2 = Replace(strSAIDA2, "<TAG_ITEM_DESCRICAO_" & Cont3 & ">", arrItensDESCRICAO(Cont2))
					strSAIDA2 = Replace(strSAIDA2, "<TAG_ITEM_VALOR_"     & Cont3 & ">", arrItensVALOR    (Cont2))
					strSAIDA2 = Replace(strSAIDA2, "<TAG_ITEM_QTDE_"      & Cont3 & ">", arrItensQTDE     (Cont2))
					
					Cont2 = Cont2 + 1
					Cont3 = Cont3 + 1
				Loop
				
				strALIQ_IRRF    = CDbl("0" & GetValue(objRS2, "ALIQ_IRRF"))
				strALIQ_ISSQN   = CDbl("0" & GetValue(objRS2, "ALIQ_ISSQN"))
				strVLR_IRRF     = CDbl("0" & GetValue(objRS1, "VLR_IRRF"))
				strVLR_ISSQN    = CDbl("0" & GetValue(objRS1, "VLR_ISSQN"))
				strTOT_SERVICO  = CDbl("0" & GetValue(objRS1, "TOT_SERVICO"))
				strTOT_NF       = CDbl("0" & GetValue(objRS1, "TOT_NF"))
				strVLR_COMISSAO = CDbl("0" & GetValue(objRS1, "VLR_COMISSAO"))
				strTOT_SERVICO  = CDbl("0" & GetValue(objRS1, "TOT_SERVICO"))
				
				If strNRO_FOLHA_ATUAL < strNRO_FOLHAS_NF Then
					strSAIDA2 = Replace(strSAIDA2, "<TAG_TOT_NF>", "XXXX")
				Else
					If strVLR_IRRF > 0 Then
						'strSAIDA2 = Replace(strSAIDA2, "<TAG_IRRF_DESCRICAO>", "IRRF (" & FormataDecimal(strALIQ_IRRF, 2) & "%)")
						strSAIDA2 = Replace(strSAIDA2, "<TAG_IRRF_DESCRICAO>", "(" & FormataDecimal(strALIQ_IRRF, 2) & "%)")
						strSAIDA2 = Replace(strSAIDA2, "<TAG_IRRF_VALOR>"    , FormataDecimal(strVLR_IRRF, 2))
					ELSE
						strSAIDA2 = Replace(strSAIDA2, "<TAG_IRRF_DESCRICAO>", "-")
						strSAIDA2 = Replace(strSAIDA2, "<TAG_IRRF_VALOR>"    , "-")
					End If
					
					If strVLR_REDUCAO_OUTROS > 0 Then
						'strSAIDA2 = Replace(strSAIDA2, "<TAG_REDUCAO_OUTROS_DESCRICAO>", "COFINS, PIS, C.S. (" & FormataDecimal(strALIQ_REDUCAO_OUTROS, 2) & "%)")
						strSAIDA2 = Replace(strSAIDA2, "<TAG_REDUCAO_OUTROS_DESCRICAO>", "(" & FormataDecimal(strALIQ_REDUCAO_OUTROS, 2) & "%)")
						strSAIDA2 = Replace(strSAIDA2, "<TAG_REDUCAO_OUTROS_VALOR>"    , FormataDecimal(strVLR_REDUCAO_OUTROS, 2))
					ELSE
						strSAIDA2 = Replace(strSAIDA2, "<TAG_REDUCAO_OUTROS_DESCRICAO>", "-")
						strSAIDA2 = Replace(strSAIDA2, "<TAG_REDUCAO_OUTROS_VALOR>"    , "-")
					End If
					
					strSAIDA2 = Replace(strSAIDA2, "<TAG_ISSQN>" , "(" & FormataDecimal(strALIQ_ISSQN, 2) & "%) " & FormataDecimal(strVLR_ISSQN, 2))
					strSAIDA2 = Replace(strSAIDA2, "<TAG_TOT_SERVICO>", FormataDecimal(strTOT_SERVICO, 2))
					strSAIDA2 = Replace(strSAIDA2, "<TAG_TOT_NF>", FormataDecimal(strTOT_NF, 2))
					strSAIDA2 = Replace(strSAIDA2, "<TAG_VLR_COMISSAO>", FormataDecimal(strVLR_COMISSAO, 2))
					strSAIDA2 = Replace(strSAIDA2, "<TAG_VALOR_EXTENSO>", Extenso(strTOT_SERVICO))
				End If
				
				If strNRO_FOLHA_ATUAL < strNRO_FOLHAS_NF Then strSAIDA2 = strSAIDA2 & vbNewLine & "<br style='page-break-before:always;'>"
				strSAIDA3 = strSAIDA3 & strSAIDA2 & vbNewLine
				
				If strNRO_FOLHA_ATUAL < strNRO_FOLHAS_NF Then strNUM_FORM = strNUM_FORM + 1
			Next
			strNUM_FORM_Ult = strNUM_FORM
			
			If strSAIDA3 = "" Then strMSG = strMSG & "Arquivo final não pôde ser gerado!<br>"
		End If
		
		'----------------------------------------------------------------
		' 8) Na montagem que é gravada em arquivo sai o numero da NF
		'----------------------------------------------------------------
		If strMSG = "" Then
			strSAIDA4 = Replace(strSAIDA3, "<TAG_NUM_NFcf>", strNUM_NF_Frmt)
		End If
		
		'----------------------------------------------------------
		' 10) Grava arquivo da nota gerado a partir do modelo
		'----------------------------------------------------------
		If strMSG = "" Then
			strSEQUENCIA = ATHFormataTamLeft(DatePart("YYYY", GetValue(objRS1, "DT_EMISSAO")), 4, "0") &_ 
						   ATHFormataTamLeft(DatePart("M", GetValue(objRS1, "DT_EMISSAO")), 2, "0") &_ 
						   ATHFormataTamLeft(DatePart("D", GetValue(objRS1, "DT_EMISSAO")), 2, "0")
			strARQUIVO_ESCRITA1 = "NFiscal" & intCodNF & "_" & strNUM_NF & "_" & strSEQUENCIA & ".htm"
			strARQUIVO_ESCRITA2 = Server.MapPath("..\upload\" & Request.Cookies("VBOSS")("CLINAME") & "\FIN_Notas") & "\" & strARQUIVO_ESCRITA1 
			
			Set objFSO = Server.CreateObject("Scripting.FileSystemObject") 
			Set objText = objFSO.CreateTextFile(strARQUIVO_ESCRITA2, True) 
			
			If objFSO.FileExists(strARQUIVO_ESCRITA2) Then 
				objText.WriteLine(strSAIDA4) 
			Else
				strMSG = strMSG & "Não foi possível gravar arquivo gerado a partir do modelo de Nota Fiscal<br>"
			End If 
			
			objText.Close 
			
			Set objFSO = Nothing
			Set objText = Nothing
		End If
		
		'----------------------------------------
		' 11) Atualiza tabelas no BD
		'----------------------------------------
		If strMSG = "" Then
			strSQL =          " UPDATE NF_NOTA "
			strSQL = strSQL & " SET NUM_NF = '" & strNUM_NF & "' "
			strSQL = strSQL & "   , SITUACAO = 'EMITIDA' "
			strSQL = strSQL & "   , SYS_DTT_EMISSAO = " & strDT_AGORA 
			strSQL = strSQL & "   , SYS_ID_USUARIO_EMISSAO = " & strUSUARIO 
			strSQL = strSQL & "   , ARQUIVO = '" & strARQUIVO_ESCRITA1 & "' "
			strSQL = strSQL & " WHERE COD_NF = " & intCodNF
			
			'AQUI: NEW TRANSACTION
			set objRSCT  = objConn.Execute("start transaction")
			set objRSCT  = objConn.Execute("set autocommit = 0")
			objConn.Execute(strSQL)
			If Err.Number <> 0 Then
				set objRSCT = objConn.Execute("rollback")
				Mensagem "modulo_FIN_NF.Print A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
				Response.End()
			else
				set objRSCT = objConn.Execute("commit")
			End If
			
			For strNUM_FORM = strNUM_FORM_Prim To strNUM_FORM_Ult
				strSQL = " INSERT INTO NF_NOTA_FORM (NUM_NF, NUM_FORM) VALUES ('" & strNUM_NF & "', '" & strNUM_FORM & "') " 
				'AQUI: NEW TRANSACTION
				set objRSCT  = objConn.Execute("start transaction")
				set objRSCT  = objConn.Execute("set autocommit = 0")
				objConn.Execute(strSQL)
				If Err.Number <> 0 Then
					set objRSCT = objConn.Execute("rollback")
					Mensagem "modulo_FIN_NF.Print B" & strNUM_NF & ": " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
					Response.End()
				else
					set objRSCT = objConn.Execute("commit")
				End If
			Next
			
			strSQL =          " UPDATE CFG_NF "
			strSQL = strSQL & " SET ULT_NUM_NF = '" & strNUM_NF & "' "
			strSQL = strSQL & "   , ULT_NUM_FORM = '" & strNUM_FORM_Ult & "' "
			strSQL = strSQL & " WHERE COD_CFG_NF = " & GetValue(objRS1, "COD_CFG_NF")
			
			'AQUI: NEW TRANSACTION
			set objRSCT  = objConn.Execute("start transaction")
			set objRSCT  = objConn.Execute("set autocommit = 0")
			objConn.Execute(strSQL)
			If Err.Number <> 0 Then
				set objRSCT = objConn.Execute("rollback")
				Mensagem "modulo_FIN_NF.Print C: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
				Response.End()
			else
				set objRSCT = objConn.Execute("commit")
			End If
			
			strSQL =          " UPDATE FIN_CONTA_PAGAR_RECEBER "
			strSQL = strSQL & " SET NUM_NF = '" & strNUM_NF & "'" 
			strSQL = strSQL & " WHERE PAGAR_RECEBER = False "
			strSQL = strSQL & " AND COD_NF = " & intCodNF
			
			'AQUI: NEW TRANSACTION
			set objRSCT  = objConn.Execute("start transaction")
			set objRSCT  = objConn.Execute("set autocommit = 0")
			objConn.Execute(strSQL)
			If Err.Number <> 0 Then
				set objRSCT = objConn.Execute("rollback")
				Mensagem "modulo_FIN_NF.Print D: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
				Response.End()
			else
				set objRSCT = objConn.Execute("commit")
			End If

		End If
		FechaRecordSet objRS2
	Else
		strMSG = strMSG & "Nota Fiscal não foi encontrada!<br>"
	End If
	FechaRecordSet objRS1
	
	If strMSG <> "" Then
		Mensagem strMSG, "Javascript:window.close();", "Fechar", 1
	Else
		Response.Write(strSAIDA3)
		%>
		<script type="text/javascript" language="JavaScript">
			window.print();
		</script>
		<%
	End If
	
	FechaDBConn objConn
End If
%>