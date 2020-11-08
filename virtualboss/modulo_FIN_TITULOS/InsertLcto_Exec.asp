<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim objConn, objRS, objRSCT, strSQL
Dim strCOD_DADO
Dim strCOD_CONTA, strTIPO_CONTA, strCODIGO, strTIPO, strCOD_CENTRO_CUSTO, strCOD_PLANO_CONTA
Dim strVLR_ORIG_A, strVLR_ORIG_B, strVLR_MULTA, strVLR_JUROS, strVLR_DESC, strVLR_LCTO_Norm, strVLR_LCTO_Frmt, strVLR_RESTANTE_DESC
Dim strHISTORICO, strOBS, strENTIDADE, strRETORNO, strSITUACAO, strMSG, strNUM_LCTO, strDT_LCTO_Norm, strDT_LCTO_Frmt, strDT_AGORA
Dim strVLR_TOTAL_LCTO, strVLR_TOTAL_DESC, strVLR_TOTAL_MULTA, strVLR_TOTAL_JUROS, strVLR_TOTAL
Dim strDOCUMENTO, strCHEQUE_NUMERO, strCARTAO_NUMERO, strCARTAO_VALIDADE, strCARTAO_PORTADOR
Dim strCOD_BANCO, strCONTA, strEXTRA
Dim strJSCRIPT_ACTION, strLOCATION

strCOD_DADO 			= GetParam("var_chavereg")
strRETORNO 				= GetParam("var_retorno")
strTIPO_CONTA 			= GetParam("var_tipo_conta")
strCOD_CONTA 			= GetParam("var_cod_conta")
strCODIGO 				= GetParam("var_codigo")
strTIPO 				= GetParam("var_tipo")
strCOD_CENTRO_CUSTO 	= GetParam("var_cod_centro_custo")
strCOD_PLANO_CONTA 		= GetParam("var_cod_plano_conta")
strVLR_ORIG_A 			= GetParam("var_vlr_orig")
strVLR_MULTA 			= GetParam("var_vlr_multa")
strVLR_JUROS		 	= GetParam("var_vlr_juros")
strVLR_DESC 			= GetParam("var_vlr_desc")
strVLR_LCTO_Norm 		= GetParam("var_vlr_lcto")
strVLR_RESTANTE_DESC	= GetParam("var_vlr_restante_desc")
strNUM_LCTO 			= GetParam("var_num_lcto")
strDT_LCTO_Norm			= GetParam("var_dt_lcto")
strHISTORICO 			= GetParam("var_historico")
strOBS					= GetParam("var_obs")
strDOCUMENTO 			= GetParam("var_documento")
strCHEQUE_NUMERO 		= GetParam("var_cheque_numero")
strCARTAO_NUMERO 		= GetParam("var_cartao_numero")
strCARTAO_VALIDADE 		= GetParam("var_cartao_validade")
strCARTAO_PORTADOR 		= GetParam("var_cartao_portador")
strJSCRIPT_ACTION 		= GetParam("JSCRIPT_ACTION")
strLOCATION 			= GetParam("DEFAULT_LOCATION")

if (strVLR_ORIG_A 		= "") then strVLR_ORIG_A 	= 0
if (strVLR_MULTA 		= "") then strVLR_MULTA  	= 0
if (strVLR_JUROS 		= "") then strVLR_JUROS  	= 0
if (strVLR_DESC 		= "") then strVLR_DESC  	= 0
if (strVLR_LCTO_Norm 	= "") then strVLR_LCTO_Norm	= 0

if (strVLR_RESTANTE_DESC = "") or (not IsNumeric(strVLR_RESTANTE_DESC)) then strVLR_RESTANTE_DESC = 0
if strVLR_RESTANTE_DESC < 0 then strVLR_RESTANTE_DESC = 0

strVLR_ORIG_B = strVLR_ORIG_A

strMSG = ""
if (strCOD_DADO = "") then strMSG = strMSG & "Parâmetro inválido para conta pagar e receber<br>"
if (strTIPO_CONTA <> "PAGAR") and (strTIPO_CONTA <> "RECEBER") then strMSG = strMSG & "Parâmetro inválido para tipo de conta<br>"
if (strCOD_CONTA = "") then strMSG = strMSG & "Parâmetro inválido para conta<br>"
if (strCODIGO = "") or (strTIPO = "") then strMSG = strMSG & "Informar entidade<br>"
if (strCOD_CENTRO_CUSTO = "") then strMSG = strMSG & "Informar centro de custo<br>"
if (strCOD_PLANO_CONTA = "") then strMSG = strMSG & "Informar plano de conta<br>"
if (strNUM_LCTO = "") then strMSG = strMSG & "Informar número do lançamento<br>"
if (strHISTORICO = "") then strMSG = strMSG & "Informar histórico<br>"
If (strDOCUMENTO <> "DINHEIRO") And (strDOCUMENTO <> "CHEQUE") And (strDOCUMENTO <> "CARTAO_CREDITO") Then strMSG = strMSG & "Informar documento do lançamento<br>"
If (strDOCUMENTO = "CHEQUE") And (strCHEQUE_NUMERO = "") Then strMSG = strMSG & "Informar número do cheque<br>"
If (strDOCUMENTO = "CARTAO_CREDITO") And ((strCARTAO_NUMERO = "") Or (strCARTAO_VALIDADE = "") Or (strCARTAO_PORTADOR = "")) Then strMSG = strMSG & "Informar todos os dados do cartão de crédito<br>"
if not IsDate(strDT_LCTO_Norm) then 
	strDT_LCTO_Norm = Date
else
	if (CDate(strDT_LCTO_Norm) > Date) then strMSG = strMSG & "Não é permitido lançamento com data futura (" & strDT_LCTO_Norm & ")<br>"
end if

if (not IsNumeric(strVLR_ORIG_A))    or (strVLR_ORIG_A <= 0)   then strMSG = strMSG & "Parâmetro inválido para o valor original<br>"
if (not IsNumeric(strVLR_MULTA))     or (strVLR_MULTA < 0)     then strMSG = strMSG & "Informar valor válido para multa<br>"
if (not IsNumeric(strVLR_JUROS))     or (strVLR_JUROS < 0)     then strMSG = strMSG & "Informar valor válido para juros<br>"
if (not IsNumeric(strVLR_DESC))      or (strVLR_DESC < 0)      then strMSG = strMSG & "Informar valor válido para desconto<br>"
'if (not IsNumeric(strVLR_LCTO_Norm)) or (strVLR_LCTO_Norm <=0) then strMSG = strMSG & "Informar valor do lançamento<br>"
'Passamos a permitir zero no VLR_LCTO do título. By Lumertz 09/11/2012.
if (not IsNumeric(strVLR_LCTO_Norm)) or (strVLR_LCTO_Norm <0) then strMSG = strMSG & "Informar valor do lançamento<br>"

AbreDBConn objConn, CFG_DB 

if strCOD_CONTA<>"" then
	strSQL = "SELECT NOME, DT_CADASTRO FROM FIN_CONTA WHERE COD_CONTA=" & strCOD_CONTA
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	if not objRS.eof then	
		while not objRS.eof
			if CDate(strDT_LCTO_Norm) < CDate(GetValue(objRS,"DT_CADASTRO")) then
				strMSG = strMSG & "A data do lançamento (" & strDT_LCTO_Norm & ") não corresponde com a data de criação da conta "
				strMSG = strMSG & GetValue(objRS,"NOME") & " (" & GetValue(objRS,"DT_CADASTRO") & ").<br>"	
			end if
			objRS.MoveNext		
		wend
	end if
end if

if strMSG <> "" then 
	Mensagem strMSG, "Javascript:history.go(-1);", "Voltar", 1
	Response.End()
end if

'----------------------------------------------
'Verifica se lança a diferença como desconto 
'----------------------------------------------
if strVLR_RESTANTE_DESC > 0 then strVLR_DESC = strVLR_DESC + strVLR_RESTANTE_DESC

'-----------------------------
'Inicializações
'-----------------------------
strDT_AGORA = "'" & PrepDataBrToUni(Now, True) & "'"
strDT_LCTO_Frmt  = "'" & PrepDataBrToUni(strDT_LCTO_Norm, False) & "'"
strVLR_LCTO_Frmt = strVLR_LCTO_Norm

if strVLR_ORIG_A <> 0    then strVLR_ORIG_A    = FormataDouble(FormataDecimal(strVLR_ORIG_A, 2))
if strVLR_MULTA <> 0     then strVLR_MULTA     = FormataDouble(FormataDecimal(strVLR_MULTA, 2))
if strVLR_JUROS <> 0     then strVLR_JUROS     = FormataDouble(FormataDecimal(strVLR_JUROS, 2))
if strVLR_DESC <> 0      then strVLR_DESC      = FormataDouble(FormataDecimal(strVLR_DESC, 2))
if strVLR_LCTO_Frmt <> 0 then strVLR_LCTO_Frmt = FormataDouble(FormataDecimal(strVLR_LCTO_Frmt, 2))

strEXTRA = ""
if strDOCUMENTO = "CHEQUE" then strEXTRA = strDOCUMENTO & " Núm: " & strCHEQUE_NUMERO
if strDOCUMENTO = "CARTAO_CREDITO" then strEXTRA = strDOCUMENTO & " Núm: " & strCARTAO_NUMERO & " / Validade: " & strCARTAO_VALIDADE & " / Portador: " & strCARTAO_PORTADOR

'----------------------------
'Insere dados do lançamento 
'----------------------------
strSQL =          " INSERT INTO FIN_LCTO_ORDINARIO ( COD_CONTA_PAGAR_RECEBER, TIPO, CODIGO, COD_CONTA, COD_PLANO_CONTA, COD_CENTRO_CUSTO "
strSQL = strSQL & "                                , HISTORICO, OBS, EXTRA, NUM_LCTO, DT_LCTO, VLR_ORIG, VLR_MULTA, VLR_JUROS, VLR_DESC, VLR_LCTO "
strSQL = strSQL & "                                , SYS_DT_CRIACAO, SYS_COD_USER_CRIACAO ) "
strSQL = strSQL & " VALUES ( " 	& strCOD_DADO 	& ", '"	& strTIPO & "', "  & strCODIGO   & ", " & strCOD_CONTA & ", " & strCOD_PLANO_CONTA & ", " & strCOD_CENTRO_CUSTO 
strSQL = strSQL & "        , '"	& strHISTORICO & "', '" & strOBS & "', '" & strEXTRA & "', '" & strNUM_LCTO & "', " & strDT_LCTO_Frmt & ", " & strVLR_ORIG_A & ", " & strVLR_MULTA & ", " & strVLR_JUROS & ", " & strVLR_DESC & ", " & strVLR_LCTO_Frmt 
strSQL = strSQL & "        , " 	& strDT_AGORA 	& ", '"	& Request.Cookies("VBOSS")("ID_USUARIO") & "' ) "

'AQUI: NEW TRANSACTION
set objRSCT  = objConn.Execute("start transaction")
set objRSCT  = objConn.Execute("set autocommit = 0")
objConn.Execute(strSQL)
If Err.Number <> 0 Then
	set objRSCT = objConn.Execute("rollback")
	Mensagem "modulo_FIN_TITULOS.InsertLcto_Exec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	Response.End()
else
	set objRSCT = objConn.Execute("commit")
End If

'----------------------------------------------------------------
'Atualiza conta-caixa, debitando ou creditando o valor lançado
'----------------------------------------------------------------
if strTIPO_CONTA = "PAGAR"   then strSQL = "UPDATE FIN_CONTA SET VLR_SALDO = VLR_SALDO - " & strVLR_LCTO_Frmt & " WHERE COD_CONTA = " & strCOD_CONTA
if strTIPO_CONTA = "RECEBER" then strSQL = "UPDATE FIN_CONTA SET VLR_SALDO = VLR_SALDO + " & strVLR_LCTO_Frmt & " WHERE COD_CONTA = " & strCOD_CONTA

'AQUI: NEW TRANSACTION
set objRSCT  = objConn.Execute("start transaction")
set objRSCT  = objConn.Execute("set autocommit = 0")
objConn.Execute(strSQL)
If Err.Number <> 0 Then
	set objRSCT = objConn.Execute("rollback")
	Mensagem "modulo_FIN_TITULOS.InsertLcto_Exec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	Response.End()
else
	set objRSCT = objConn.Execute("commit")
End If

'--------------------------------------------------------------
'Busca os totais já lançados para avaliar situação da conta
'--------------------------------------------------------------
strSQL =          " SELECT SUM(VLR_LCTO)  AS VLR_TOTAL_LCTO "
strSQL = strSQL & "      , SUM(VLR_DESC)  AS VLR_TOTAL_DESC "
strSQL = strSQL & "      , SUM(VLR_MULTA) AS VLR_TOTAL_MULTA "
strSQL = strSQL & "      , SUM(VLR_JUROS) AS VLR_TOTAL_JUROS "
strSQL = strSQL & " FROM FIN_LCTO_ORDINARIO "
strSQL = strSQL & " WHERE COD_CONTA_PAGAR_RECEBER = " & strCOD_DADO
strSQL = strSQL & " AND SYS_DT_CANCEL IS NULL "

Set objRS = objConn.Execute(strSQL)

strVLR_TOTAL_LCTO  = 0 
strVLR_TOTAL_DESC  = 0 
strVLR_TOTAL_MULTA = 0 
strVLR_TOTAL_JUROS = 0 

if Not objRS.Eof then
	strVLR_TOTAL_LCTO  = GetValue(objRS, "VLR_TOTAL_LCTO")
	strVLR_TOTAL_DESC  = GetValue(objRS, "VLR_TOTAL_DESC")
	strVLR_TOTAL_MULTA = GetValue(objRS, "VLR_TOTAL_MULTA")
	strVLR_TOTAL_JUROS = GetValue(objRS, "VLR_TOTAL_JUROS")
end if 
FechaRecordSet objRS

if strVLR_TOTAL_LCTO  = "" or not IsNumeric(strVLR_TOTAL_LCTO)  then strVLR_TOTAL_LCTO  = 0
if strVLR_TOTAL_DESC  = "" or not IsNumeric(strVLR_TOTAL_DESC)  then strVLR_TOTAL_DESC  = 0
if strVLR_TOTAL_MULTA = "" or not IsNumeric(strVLR_TOTAL_MULTA) then strVLR_TOTAL_MULTA = 0
if strVLR_TOTAL_JUROS = "" or not IsNumeric(strVLR_TOTAL_JUROS) then strVLR_TOTAL_JUROS = 0

strVLR_TOTAL = strVLR_TOTAL_LCTO + strVLR_TOTAL_DESC - strVLR_TOTAL_MULTA - strVLR_TOTAL_JUROS
if strVLR_TOTAL < 0 then strVLR_TOTAL = 0

'Formatando valores para as comparações abaixo. Um título (cód 710, banco proevento) teve 
'problemas na comparação e ficou como 'lcto_parcial' mas devia ter ficado como 'lcto_total'
strVLR_TOTAL = FormataDecimal(strVLR_TOTAL, 2)
strVLR_ORIG_B = FormataDecimal(strVLR_ORIG_B, 2)
strVLR_TOTAL = CDbl("0" & strVLR_TOTAL)
strVLR_ORIG_B = CDbl("0" & strVLR_ORIG_B)

strSITUACAO = "ABERTA"
if (strVLR_TOTAL = 0) then strSITUACAO = "ABERTA" 
if (strVLR_TOTAL > 0) and (strVLR_TOTAL < strVLR_ORIG_B) then strSITUACAO = "LCTO_PARCIAL" 
if (strVLR_TOTAL >= strVLR_ORIG_B) then strSITUACAO = "LCTO_TOTAL" 

'-----------------------------------------
'Atualiza situação e demais informações
'-----------------------------------------
strSQL =          " UPDATE FIN_CONTA_PAGAR_RECEBER "
strSQL = strSQL & " SET SYS_DT_ULT_LCTO = " & strDT_AGORA
strSQL = strSQL & "   , SYS_COD_USER_ULT_LCTO = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "'" 
strSQL = strSQL & "   , SITUACAO = '" & strSITUACAO & "'" 
strSQL = strSQL & " WHERE COD_CONTA_PAGAR_RECEBER = " & strCOD_DADO

'AQUI: NEW TRANSACTION
set objRSCT  = objConn.Execute("start transaction")
set objRSCT  = objConn.Execute("set autocommit = 0")
objConn.Execute(strSQL)
If Err.Number <> 0 Then
	set objRSCT = objConn.Execute("rollback")
	Mensagem "modulo_FIN_TITULOS.InsertLcto_Exec C: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	Response.End()
else
	set objRSCT = objConn.Execute("commit")
End If

if strTIPO_CONTA = "PAGAR" then
	AcumulaSaldoNovo objConn, strCOD_CONTA, strDT_LCTO_Norm, -strVLR_LCTO_Norm
else
	AcumulaSaldoNovo objConn, strCOD_CONTA, strDT_LCTO_Norm, strVLR_LCTO_Norm
end if

FechaDBConn ObjConn

response.write "<script>" & vbCrlf
if strJSCRIPT_ACTION <> "" then response.write strJSCRIPT_ACTION & vbCrlf end if
if strLOCATION <> "" then response.write "location.href='" & strLOCATION & "'" & vbCrlf end if
response.write "</script>" & vbCrlf
%>
