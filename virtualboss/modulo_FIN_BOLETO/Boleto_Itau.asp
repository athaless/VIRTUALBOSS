<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/BarCode25.asp"-->
<%
Const TOTWIDTH = 666

Dim strBOLETO_ACEITE, strBOLETO_AGENCIA
Dim strBOLETO_CARTEIRA, strBOLETO_CEDENTE_CODIGO, strBOLETO_CEDENTE_CODIGO_DV
Dim strBOLETO_CEDENTE_NOME, strBOLETO_CEDENTE_CNPJ, strBOLETO_CODIGO_BARRAS
Dim strBOLETO_COD_BANCO, strBOLETO_COD_BANCO_DV, strBOLETO_CONTA, strBOLETO_CONTA_DV
Dim strBOLETO_DT_VENCIMENTO, strBOLETO_ESPECIE, strBOLETO_IMG_LOGO, strBOLETO_INSTRUCOES
Dim strBOLETO_LINHA_DIGITAVEL, strBOLETO_LOCAL_PGTO, strBOLETO_NOSSO_NUMERO, strBOLETO_NOSSO_NUMERO_DV
Dim strBOLETO_NUM_DOCUMENTO, strBOLETO_VALOR, strBOLETO_IMG_PROMO, intCOD_CONTA_PAGAR_RECEBER

Dim strBOLETO_SACADO_BAIRRO, strBOLETO_SACADO_CEP, strBOLETO_SACADO_CIDADE
Dim strBOLETO_SACADO_ENDERECO, strBOLETO_SACADO_ESTADO, strNUM_IMPRESSOES
Dim strBOLETO_SACADO_IDENTIFICADOR, strBOLETO_SACADO_NOME, strBOLETO_SACADO_CNPJ

Dim strBOLETO_CEDENTE_ENDERECO

Dim intCOD_CONTA_PAGAR_RECEBERM, strFatorVencimento, strBOLETO_ESPECIE_DOC
Dim strDVGeral, strHTML, dblValorAux

Dim objConn, objRS, objRSCT, strSQL, strMSG
Dim objFileSystemObject, strFilePath, objArquivo, strUploadPath

'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'	***************	ITAU	 ***************
'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function MontarCodigoBarras(prAgencia, prCodBanco, prCarteira, prConta, prDvAgConta, prMoeda, prDvNossoNumero, prNossoNumero, prVencimento, prValor)
Dim strCodBar,strDv3

	strCodBar = prCodBanco & prMoeda & prVencimento & prValor & prCarteira & prNossoNumero & prDvNossoNumero & prAgencia & prConta & prDvAgConta & "000"	
	strDv3	 = CalcularDDV_Modulo11(strCodBar,9,0)
	
	strCodBar = prCodBanco & prMoeda & strDv3 & prVencimento & prValor & prCarteira & prNossoNumero & prDvNossoNumero & prAgencia & prConta & prDvAgConta & "000"
	
	MontarCodigoBarras = strCodBar
End Function

Function MontarLinhaDigitavel(prCodigoBarras)
Dim strCampoLivre
Dim strCampo1, strCampo2
Dim strCampo3, strCampo4, strCampo5

	strCampoLivre	= Mid(prCodigoBarras,20,25)
	
	strCampo1	= Left(prCodigoBarras,4) & mid(strCampoLivre,1,5)
	strCampo1	= strCampo1 & CalcularDDV_Modulo10(strCampo1)
	strCampo1	= Mid(strCampo1,1,5) & "." & mid(strCampo1,6,5)
	
	strCampo2	= Mid(strCampoLivre,6,10)
	strCampo2	= strCampo2 & CalcularDDV_Modulo10(strCampo2)
	strCampo2	= Mid(strCampo2,1,5) & "." & mid(strCampo2,6,6)
	
	strCampo3	= Mid(strCampoLivre,16,10)
	strCampo3	= strCampo3 & CalcularDDV_Modulo10(strCampo3)
	strCampo3	= Mid(strCampo3,1,5) & "." & mid(strCampo3,6,6)
		
	strCampo4	= Mid(prCodigoBarras,5,1)	
	strCampo5	= Int(Mid(prCodigoBarras,6,14))
	
	if strCampo5=0 then	strCampo5 = "000"
	
	MontarLinhaDigitavel = strCampo1 & "  " & strCampo2 & "  " & strCampo3 & "  " & strCampo4 &"  " & strCampo5	
End Function
'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function CalcularDDV_Modulo11(prNumero, prPesoMaior, prRetorno)
Dim dblTotal, dblValue, dblResto
Dim strBase, strRetorno
Dim intPos

	strBase = 1 + (Len(prNumero) mod (prPesoMaior-1))	
	if strBase=1 then	strBase = prPesoMaior	
	dblTotal=0
	
	for intPos = 1 to Len(prNumero)
		dblTotal = dblTotal + (Mid(prNumero,intPos,1) * strBase)
		strBase	= strBase - 1
		if strBase=1 then	strBase = prPesoMaior
	next
	
	dblResto = (dblTotal mod 11)
	if prRetorno<>1 then
		if dblResto=0 or dblResto=1 or dblResto=10 then	
			strRetorno = 1 
		else	
			strRetorno = 11 - dblResto
		end if
		CalcularDDV_Modulo11 = strRetorno
	else
		CalcularDDV_Modulo11 = dblResto
	end if
End Function
'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function CalcularDDV_Modulo10(prNumero)
Dim dblTotal, dblValue
Dim strBase, strRetorno
Dim intPos

	strBase = (Len(prNumero) mod 2) 
	strBase = strBase + 1
	dblTotal = 0

	for intPos = 1 to Len(prNumero)
		dblValue = Mid(prNumero,intPos,1) * strBase

		if dblValue>9 then	dblValue = Int(dblValue/10) + (dblValue mod 10)
		dblTotal = dblTotal + dblValue
		if strBase = 2 then strBase = 1 else strBase = 2
	next
	dblTotal = ((10 - (dblTotal mod 10)) mod 10 )
	
	CalcularDDV_Modulo10 = dblTotal
End Function
'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function FatorVencimento(prDataVencimento)
Dim strDtVcto
Dim DT_BASE_CALC_FATOR_VCTO

	DT_BASE_CALC_FATOR_VCTO = "07/10/1997"
	strDtVcto = "0000"
	if Len(prDataVencimento)>7 then	strDtVcto = DateValue(prDataVencimento) - DateValue(DT_BASE_CALC_FATOR_VCTO)
	FatorVencimento = strDtVcto
End Function
'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
strUploadPath = "../upload/" & UCase(Request.Cookies("VBOSS")("CLINAME")) & "/"

intCOD_CONTA_PAGAR_RECEBER			= GetParam("var_chavereg")
strNUM_IMPRESSOES					= GetParam("var_boleto_num_impressoes")

strBOLETO_ACEITE					= GetParam("var_boleto_aceite")
strBOLETO_AGENCIA					= AthFormataTamLeft(GetParam("var_boleto_agencia"),4,"0")

strBOLETO_CARTEIRA					= GetParam("var_boleto_carteira")
'	strBOLETO_CEDENTE_CODIGO			= GetParam("var_boleto_cedente_codigo")
'	strBOLETO_CEDENTE_CODIGO_DV		= GetParam("var_boleto_cedente_codigo_dv")
strBOLETO_CEDENTE_NOME 				= GetParam("var_boleto_cedente_nome")
strBOLETO_CEDENTE_CNPJ				= GetParam("var_boleto_cedente_cnpj")
strBOLETO_COD_BANCO					= GetParam("var_boleto_cod_banco")
strBOLETO_COD_BANCO_DV				= GetParam("var_boleto_cod_banco_dv")
strBOLETO_CONTA						= AthFormataTamLeft(Left(GetParam("var_boleto_cedente_codigo"),5),5,"0")
strBOLETO_CONTA_DV					= GetParam("var_boleto_cedente_codigo_dv")
strBOLETO_ESPECIE_DOC				= GetParam("var_boleto_especie_doc")
strBOLETO_DT_VENCIMENTO				= GetParam("var_boleto_dt_vencimento")
strBOLETO_ESPECIE					= GetParam("var_boleto_especie")

strBOLETO_IMG_LOGO					= GetParam("var_boleto_img_logo")
strBOLETO_IMG_PROMO					= GetParam("var_boleto_img_promo")

strBOLETO_INSTRUCOES				= GetParam("var_boleto_instrucoes")
strBOLETO_LOCAL_PGTO				= GetParam("var_boleto_local_pgto")

strBOLETO_NOSSO_NUMERO				= AthFormataTamLeft(GetParam("var_boleto_nosso_numero"),8,"0")
strBOLETO_NUM_DOCUMENTO				= GetParam("var_boleto_num_documento")

strBOLETO_SACADO_BAIRRO				= GetParam("var_boleto_sacado_bairro")
strBOLETO_SACADO_CEP				= GetParam("var_boleto_sacado_cep")
strBOLETO_SACADO_CIDADE				= GetParam("var_boleto_sacado_cidade")
strBOLETO_SACADO_ENDERECO			= GetParam("var_boleto_sacado_endereco")
strBOLETO_SACADO_ESTADO				= GetParam("var_boleto_sacado_estado")
strBOLETO_SACADO_IDENTIFICADOR	    = GetParam("var_boleto_sacado_identificador")
strBOLETO_SACADO_NOME				= GetParam("var_boleto_sacado_nome")

' Novos dados mar/2012, pela mudança na legislação os boletos devem conter
' dados de endereço do CEDENTE e o CNPJ do SACADO deve ser incluído também
' ----------------------------------------------------------- by Aless ---
strBOLETO_SACADO_CNPJ				= GetParam("var_boleto_SACADO_CNPJ") 	  '"00.000.000.0000/00"
strBOLETO_CEDENTE_ENDERECO			= GetParam("var_boleto_CEDENTE_ENDERECO") '"Rua Cap. Arisoly Vargas, 55/707"
' --------------------------------------------------------- 15.03.2012 ---
strBOLETO_VALOR						= GetParam("var_boleto_valor")
'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
strBOLETO_NOSSO_NUMERO_DV			= CalcularDDV_Modulo10(strBOLETO_AGENCIA & strBOLETO_CONTA & strBOLETO_CARTEIRA & strBOLETO_NOSSO_NUMERO)
strBOLETO_CONTA_DV 					= CalcularDDV_Modulo10(strBOLETO_AGENCIA & strBOLETO_CONTA)


strFatorVencimento = FatorVencimento(strBOLETO_DT_VENCIMENTO)
if strFatorVencimento = "0000" then strFatorVencimento = "Contra Apresentação"	

dblValorAux	= ""
if strBOLETO_VALOR<>0 then
	dblValorAux = Replace(Replace(MoedaToFloat(strBOLETO_VALOR),",",""),".","")
	dblValorAux	= String((10 - CInt(Len(dblValorAux))),"0") & dblValorAux
end if

strBOLETO_CODIGO_BARRAS	  = MontarCodigoBarras(strBOLETO_AGENCIA, strBOLETO_COD_BANCO, strBOLETO_CARTEIRA, strBOLETO_CONTA, strBOLETO_CONTA_DV, 9, strBOLETO_NOSSO_NUMERO_DV, strBOLETO_NOSSO_NUMERO,	strFatorVencimento, dblValorAux)
strBOLETO_LINHA_DIGITAVEL = MontarLinhaDigitavel(strBOLETO_CODIGO_BARRAS)

'---------------------------------------------------------------
' "TheBugger" King
'---------------------------------------------------------------
'with Response
'	.Write("COD_BANCO: "										)
'	.Write(strBOLETO_COD_BANCO 	& "<br>Moeda: 9<br>Carteira: "  )
'	.Write(strBOLETO_CARTEIRA 		& "<br>Nosso Numero: "	    )
'	.Write(strBOLETO_NOSSO_NUMERO & "<br>Agencia: "				)
'	.Write(strBOLETO_AGENCIA 		& "<br>DV: "				)
'	.Write(strBOLETO_NOSSO_NUMERO_DV & "<br>Conta: "			)
'	.Write(strBOLETO_CONTA 			& "<br>DV: "				)
'	.Write(strBOLETO_CONTA_DV 		& "<br>Vcto: "				)
'	.Write(strFatorVencimento 		& "<br>Valor: "				)
'	.Write(dblValorAux & "<br><br>"								)
'	.End()
'end with
'---------------------------------------------------------------

strHTML = ""
strHTML = strHTML & vbCrlf &_
"<html><head>" & vbCrlf &_
"<title>VirtualBOSS</title>" & vbCrlf &_
"<style type=text/css>" & vbCrlf &_
"  .ct { font-size:9px;  font-family:arial;                   color: #444444; text-align:left;}"  & vbCrlf &_
"  .cp { font-size:9px;  font-family:arial; font-weight:bold; color: #000000; text-align:left;}"  & vbCrlf &_
"  .ti { font-size:9px;  font-family:arial;                   color: #000000; text-align:left;}"  & vbCrlf &_
"  .ld { font-size:15px; font-family:arial; font-weight:bold; color: #000000; text-align:right;}" & vbCrlf &_
"  .bc { font-size:22px; font-family:arial; font-weight:bold; color: #000000; text-align:center;}"  & vbCrlf &_
"</style></head>" & vbCrlf &_
"<body text='#000000' bgcolor='#FFFFFF' topmargin='0' rightmargin='0'>"

'----------------------------------------------------------------------------------------------------------------------------------
' INI: Cabeçalho instruçõe de impressão boleto
'----------------------------------------------------------------------------------------------------------------------------------
strHTML = strHTML & vbCrlf &_
"<table width='" & TOTWIDTH & "' cellspacing='0' cellpadding='0' border='0'>" & vbCrlf &_
" <tr><td valign='top' class='cp'><div align='center'>instruções de impressão</div></td></tr>" & vbCrlf &_
" <tr>" & vbCrlf &_
"  <td valign='top' class='ti' align='center' style='text-align:center;'>" & vbCrlf &_
"    imprimir em impressora jato de tinta (ink jet) ou laser em qualidade normal. (não use modo econômico).<br>"	& vbCrlf &_
"    utilize folha a4 (210 x 297 mm) ou carta (216 x 279 mm) - corte na linha indicada - v3<br>"	& vbCrlf &_
"  </td>"	& vbCrlf &_
" </tr>"  & vbCrlf &_
"</table>"  & vbCrlf &_
"<br>" 
strHTML = strHTML & vbCrlf &_
"<table width='" & TOTWIDTH & "' cellspacing='0' cellpadding='0' style='border-top:1px dashed #000000; padding:0px; margin:0px;'>" & vbCrlf &_
" <tr class='ct' valign='top'>" & vbCrlf &_
"  <td style='width:560px; height:12px;'>&nbsp;</td>" & vbCrlf &_
"  <td style='width:106px; height:12px; text-align:right;'>" & "Recibo do Sacado" & "</td>" & vbCrlf &_
" </tr>" & vbCrlf &_
"</table>" & vbCrlf &_
"<br>"

' Imagem personalizada no boleto --------------------------------------------------------------------------------------------------
if strBOLETO_IMG_PROMO<>"" then
 strBOLETO_IMG_PROMO = strUploadPath & strBOLETO_IMG_PROMO
 strHTML = strHTML & "<table width='" & TOTWIDTH & "' cellspacing='0' cellpadding='0' style='border-top:1px dashed #000000; padding:0px; margin:0px;'><tr><td style='padding-bottom:10px;'><img src='" & strBOLETO_IMG_PROMO & "' border='0'></td></tr></table>"
end if
'----------------------------------------------------------------------------------------------------------------------------------
' FIM: Cabeçalho instruçõe de impressão boleto
'----------------------------------------------------------------------------------------------------------------------------------

'----------------------------------------------------------------------------------------------------------------------------------
' INI: Cabeçalho LOGO, codbanco e linha digitável
'----------------------------------------------------------------------------------------------------------------------------------
strHTML = strHTML & vbCrlf &_
"<table width='" & TOTWIDTH & "' cellspacing='0' cellpadding='0' style='border-bottom:2px solid #000000; padding:0px; margin:0px;'>" & vbCrlf &_
" <tr>" & vbCrlf &_
"  <td width='138'><img src='../img/boleto_logo_" & strBOLETO_IMG_LOGO & ".gif' width='120'  hspace='0' vspace='0' border='0'></td>" 	& vbCrlf &_
"  <td width='003' valign='bottom'><img style='height:22px;' src='../img/boleto_3.gif' width='2'></td>" & vbCrlf &_
"  <td width='067' valign='bottom' align='center' class='bc'>" & strBOLETO_COD_BANCO & "-" & strBOLETO_COD_BANCO_DV & "</td>" & vbCrlf &_
"  <td width='003' valign='bottom'><img  style='height:22px;' src='../img/boleto_3.gif' width='2'></td>" & vbCrlf &_
"  <td width='455' valign='bottom' align='right' class='ld'>" & strBOLETO_LINHA_DIGITAVEL & "</td>" & vbCrlf &_
" </tr>" & vbCrlf &_
"</table>"
'----------------------------------------------------------------------------------------------------------------------------------
' FIM: Cabeçalho LOGO, codbanco e linha gigitável
'----------------------------------------------------------------------------------------------------------------------------------

'----------------------------------------------------------------------------------------------------------------------------------
' INI: Linha CEDENTE, Agência, Espécie, Qtde e Nosso Núm.
'----------------------------------------------------------------------------------------------------------------------------------
strHTML = strHTML & vbCrlf &_
"<table width='" & TOTWIDTH & "' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #000000; padding:0px; margin:0px;'>" & vbCrlf &_
" <tr class='ct' valign='top'>" & vbCrlf &_
"  <td style='width:304px; height:12px; border-left:1px solid #FFFFFF;'>&nbsp;Cedente</td>" & vbCrlf &_
"  <td style='width:132px; height:12px; border-left:1px solid #000000;'>&nbsp;Agência/Código do Cedente</td>" & vbCrlf &_
"  <td style='width:040px; height:12px; border-left:1px solid #000000;'>&nbsp;Espécie</td>" & vbCrlf &_
"  <td style='width:059px; height:12px; border-left:1px solid #000000;'>&nbsp;Quantidade</td>" & vbCrlf &_
"  <td style='width:126px; height:12px; border-left:1px solid #000000;'>&nbsp;Nosso número</td>" & vbCrlf &_
" </tr>" & vbCrlf &_
" <tr class='cp' valign='top'>" & vbCrlf &_
"  <td style='width:304px; height:12px; border-left:1px solid #FFFFFF;'>&nbsp;" & strBOLETO_CEDENTE_NOME&  "</td>"& vbCrlf &_
"  <td style='width:132px; height:12px; border-left:1px solid #000000;'>&nbsp;" & strBOLETO_AGENCIA & "/" & strBOLETO_CONTA & "-" & strBOLETO_CONTA_DV & "</td>" & vbCrlf &_
"  <td style='width:040px; height:12px; border-left:1px solid #000000;'>&nbsp;" & strBOLETO_ESPECIE & "</td>" & vbCrlf &_
"  <td style='width:059px; height:12px; border-left:1px solid #000000;'>&nbsp;</td>" & vbCrlf &_
"  <td style='width:126px; height:12px; border-left:1px solid #000000; text-align:right;'>" & strBOLETO_CARTEIRA & "/" & strBOLETO_NOSSO_NUMERO & "-" & strBOLETO_NOSSO_NUMERO_DV & "</td>" & vbCrlf &_
" </tr>" & vbCrlf &_
"</table>"
'----------------------------------------------------------------------------------------------------------------------------------
' FIM: Linha CEDENTE, Agência, Espécie, Qtde e Nosso Núm.
'----------------------------------------------------------------------------------------------------------------------------------

'----------------------------------------------------------------------------------------------------------------------------------
' INI: Ender Cedente/Sacador Avalista
'----------------------------------------------------------------------------------------------------------------------------------
strHTML = strHTML & vbCrlf &_
"<table width='" & TOTWIDTH & "' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #000000; padding:0px; margin:0px;'>" & vbCrlf &_
" <tr class='ct' valign='top'><td style='height:12px;'>&nbsp;Endereço Cedente/Sacador Avalista</td></tr>" & vbCrlf &_
" <tr class='cp' valign='top'><td style='height:12px;'>&nbsp;" & strBOLETO_CEDENTE_ENDERECO & "</td></tr>" & vbCrlf &_
"</table>"
'----------------------------------------------------------------------------------------------------------------------------------
' FIM: EnderCedente/Sacador Avalista
'----------------------------------------------------------------------------------------------------------------------------------

'----------------------------------------------------------------------------------------------------------------------------------
' INI: Linha Núm doc, CPF/CNPJ, Vcto e Valor
'----------------------------------------------------------------------------------------------------------------------------------
strHTML = strHTML & vbCrlf &_
"<table width='" & TOTWIDTH & "' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #000000; padding:0px; margin:0px;'>" & vbCrlf &_
" <tr class='ct' valign='top'>" & vbCrlf &_
"  <td style='width:198px; height:12px; border-left:1px solid #FFFFFF;'>&nbsp;Número do documento</td>" & vbCrlf &_
"  <td style='width:138px; height:12px; border-left:1px solid #000000;'>&nbsp;CPF/CNPJ</td>" & vbCrlf &_
"  <td style='width:140px; height:12px; border-left:1px solid #000000;'>&nbsp;Vencimento</td>" & vbCrlf &_
"  <td style='width:186px; height:12px; border-left:1px solid #000000;'>&nbsp;Valor documento</td>" & vbCrlf &_
" </tr>" & vbCrlf &_
" <tr class='cp' valign='top'>" & vbCrlf &_
"  <td style='width:198px; height:12px; border-left:1px solid #FFFFFF;'>&nbsp;" & strBOLETO_NUM_DOCUMENTO & "</td>" & vbCrlf &_
"  <td style='width:138px; height:12px; border-left:1px solid #000000;'>&nbsp;" & strBOLETO_CEDENTE_CNPJ & "</td>" & vbCrlf &_
"  <td style='width:140px; height:12px; border-left:1px solid #000000;'>&nbsp;" & strBOLETO_DT_VENCIMENTO & "</td>" & vbCrlf &_
"  <td style='width:186px; height:12px; border-left:1px solid #000000; text-align:right;'>&nbsp;" & FormataDecimal(strBOLETO_VALOR,2)  & "</td>" & vbCrlf &_
" </tr>" & vbCrlf &_
"</table>"
'----------------------------------------------------------------------------------------------------------------------------------
' FIM: Linha Núm doc, CPF/CNPJ, Vcto e Valor
'----------------------------------------------------------------------------------------------------------------------------------

'----------------------------------------------------------------------------------------------------------------------------------
' INI: Linha Desconto, Abatimentos, Mora, Outros e Valor Cobrado
'----------------------------------------------------------------------------------------------------------------------------------
strHTML = strHTML & vbCrlf &_
"<table width='" & TOTWIDTH & "' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #000000; padding:0px; margin:0px;'>" & vbCrlf &_
" <tr class='ct' valign='top'>" & vbCrlf &_
"  <td style='width:119px; height:12px; border-left:1px solid #FFFFFF;'>&nbsp;(-) Desconto / Abatimentos</td>" & vbCrlf &_
"  <td style='width:118px; height:12px; border-left:1px solid #000000;'>&nbsp;(-) Outras deduções</td>" & vbCrlf &_
"  <td style='width:119px; height:12px; border-left:1px solid #000000;'>&nbsp;(+) Mora / Multa</td>" & vbCrlf &_
"  <td style='width:119px; height:12px; border-left:1px solid #000000;'>&nbsp;(+) Outros acréscimos</td>" & vbCrlf &_
"  <td style='width:186px; height:12px; border-left:1px solid #000000;'>&nbsp;(=) Valor cobrado</td>" & vbCrlf &_
" </tr>" & vbCrlf &_
" <tr class='cp' valign='top'>" & vbCrlf &_
"  <td style='width:119px; height:12px; border-left:1px solid #FFFFFF;'>&nbsp;</td>" & vbCrlf &_
"  <td style='width:118px; height:12px; border-left:1px solid #000000;'>&nbsp;</td>" & vbCrlf &_
"  <td style='width:119px; height:12px; border-left:1px solid #000000;'>&nbsp;</td>" & vbCrlf &_
"  <td style='width:119px; height:12px; border-left:1px solid #000000;'>&nbsp;</td>" & vbCrlf &_
"  <td style='width:186px; height:12px; border-left:1px solid #000000;'>&nbsp;</td>" & vbCrlf &_
" </tr>" & vbCrlf &_
"</table>"
'----------------------------------------------------------------------------------------------------------------------------------
' FIM: Linha Desconto, Abatimentos, Mora, Outros e Valor Cobrado
'----------------------------------------------------------------------------------------------------------------------------------

'----------------------------------------------------------------------------------------------------------------------------------
' INI: Linha SACADO
'----------------------------------------------------------------------------------------------------------------------------------
strHTML = strHTML & vbCrlf &_
"<table width='" & TOTWIDTH & "' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #000000; padding:0px; margin:0px;'>" & vbCrlf &_
" <tr class='ct' valign='top'><td style='height:12px;'>&nbsp;Sacado</td></tr>" & vbCrlf &_
" <tr class='cp' valign='top'><td style='height:12px;'>&nbsp;" & strBOLETO_SACADO_NOME & "</td></tr>" & vbCrlf &_
"</table>"
'----------------------------------------------------------------------------------------------------------------------------------
' FIM: Linha SACADO
'----------------------------------------------------------------------------------------------------------------------------------

'----------------------------------------------------------------------------------------------------------------------------------
' INI: Linha Intruções, Autenticação mecanica
'----------------------------------------------------------------------------------------------------------------------------------
strHTML = strHTML & vbCrlf &_
"<table width='" & TOTWIDTH & "' cellspacing='0' cellpadding='0' style='border-bottom:1px dashed #000000; padding:0px; margin:0px;'>" & vbCrlf &_
" <tr class='ct' valign='top'>" & vbCrlf &_
"  <td style='width:560px; height:12px;'>&nbsp;Instruções</td>" & vbCrlf &_
"  <td style='width:106px; height:12px; text-align:right;'>Autenticação mecânica</td>" & vbCrlf &_
" </tr>" & vbCrlf &_
" <tr class='cp' valign='top'>" & vbCrlf &_
"  <td style='width:560px; height:12px;'>" & strBOLETO_INSTRUCOES & "</td>" & vbCrlf &_
"  <td style='width:106px; height:12px;'>&nbsp;</td>" & vbCrlf &_
" </tr>" & vbCrlf &_
" <tr class='ct' valign='top'>" & vbCrlf &_
"  <td style='width:560px; height:12px;'>&nbsp;</td>" & vbCrlf &_
"  <td style='width:106px; height:12px; text-align:right;'>Corte na linha pontilhada</td>" & vbCrlf &_
" </tr>" & vbCrlf &_
"</table>" & vbCrlf &_
"<br><br>"
'----------------------------------------------------------------------------------------------------------------------------------
' FIM: Linha Intruções, Autenticação mecanica
'----------------------------------------------------------------------------------------------------------------------------------

'----------------------------------------------------------------------------------------------------------------------------------
' INI: Cabeçalho LOGO, codbanco e linha digitável
'----------------------------------------------------------------------------------------------------------------------------------
strHTML = strHTML & vbCrlf &_
"<table width='" & TOTWIDTH & "' cellspacing='0' cellpadding='0' style='border-bottom:2px solid #000000; padding:0px; margin:0px;'>" & vbCrlf &_
" <tr>" & vbCrlf &_
"  <td width='138'><img src='../img/boleto_logo_" & strBOLETO_IMG_LOGO & ".gif' width='120'  hspace='0' vspace='0' border='0'></td>" 	& vbCrlf &_
"  <td width='003' valign='bottom'><img style='height:22px;' src='../img/boleto_3.gif' width='2'></td>" & vbCrlf &_                  
"  <td width='067' valign='bottom' align='center' class='bc'>" & strBOLETO_COD_BANCO & "-" & strBOLETO_COD_BANCO_DV & "</td>" & vbCrlf &_
"  <td width='003' valign='bottom'><img  style='height:22px;' src='../img/boleto_3.gif' width='2'></td>" & vbCrlf &_
"  <td width='455' valign='bottom' align='right'  class='ld'>" & strBOLETO_LINHA_DIGITAVEL & "</td>" & vbCrlf &_
" </tr>" & vbCrlf &_
"</table>"
'----------------------------------------------------------------------------------------------------------------------------------
' FIM: Cabeçalho LOGO, codbanco e linha gigitável
'----------------------------------------------------------------------------------------------------------------------------------

'----------------------------------------------------------------------------------------------------------------------------------
' INI: Local pagamento, Vencimento
'----------------------------------------------------------------------------------------------------------------------------------
strHTML = strHTML & vbCrlf &_
"<table width='" & TOTWIDTH & "' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #000000; padding:0px; margin:0px;'>" & vbCrlf &_
" <tr class='ct' valign='top'>" & vbCrlf &_
"  <td style='width:478px; height:12px; border-left:1px solid #FFFFFF;'>&nbsp;Local de pagamento</td>" & vbCrlf &_
"  <td style='width:186px; height:12px; border-left:1px solid #000000;'>&nbsp;Vencimento</td>" & vbCrlf &_
" </tr>" & vbCrlf &_
" <tr class='cp' valign='top'>" & vbCrlf &_
"  <td style='width:478px; height:12px; border-left:1px solid #FFFFFF;'>" & strBOLETO_LOCAL_PGTO & "</td>"& vbCrlf &_
"  <td style='width:186px; height:12px; border-left:1px solid #000000; text-align:right; vertical-align:bottom;'>&nbsp;" & strBOLETO_DT_VENCIMENTO & "</td>" & vbCrlf &_
" </tr>" & vbCrlf &_
"</table>"
'----------------------------------------------------------------------------------------------------------------------------------
' FIM: Local pagamento, Vencimento
'----------------------------------------------------------------------------------------------------------------------------------

'----------------------------------------------------------------------------------------------------------------------------------
' INI: Cedente, Agencia/Código cedente
'----------------------------------------------------------------------------------------------------------------------------------
strHTML = strHTML & vbCrlf &_
"<table width='" & TOTWIDTH & "' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #000000; padding:0px; margin:0px;'>" & vbCrlf &_
" <tr class='ct' valign='top'>" & vbCrlf &_
"  <td style='width:478px; height:12px; border-left:1px solid #FFFFFF;'>&nbsp;Cedente</td>" & vbCrlf &_
"  <td style='width:186px; height:12px; border-left:1px solid #000000;'>&nbsp;Agência/Código cedente</td>" & vbCrlf &_
" </tr>" & vbCrlf &_
" <tr class='cp' valign='top'>" & vbCrlf &_
"  <td style='width:478px; height:12px; border-left:1px solid #FFFFFF;'>&nbsp;" & strBOLETO_CEDENTE_NOME & "&nbsp;&nbsp;-&nbsp;CNPJ:" & strBOLETO_CEDENTE_CNPJ & "</td>"& vbCrlf &_
"  <td style='width:186px; height:12px; border-left:1px solid #000000; text-align:right;'>&nbsp;" & strBOLETO_AGENCIA & "/" & strBOLETO_CONTA & "-" & strBOLETO_CONTA_DV & "</td>" & vbCrlf &_
" </tr>" & vbCrlf &_
"</table>"
'----------------------------------------------------------------------------------------------------------------------------------
' FIM: Cedente, Agencia/Código cedente
'----------------------------------------------------------------------------------------------------------------------------------

'----------------------------------------------------------------------------------------------------------------------------------
' INI: Data documento, Numero doc, especie doc ...
'----------------------------------------------------------------------------------------------------------------------------------
strHTML = strHTML & vbCrlf &_
"<table width='" & TOTWIDTH & "' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #000000; padding:0px; margin:0px;'>" & vbCrlf &_
" <tr class='ct' valign='top'>" & vbCrlf &_
"  <td style='width:119px; height:12px; border-left:1px solid #FFFFFF;'>&nbsp;Data do documento</td>" & vbCrlf &_
"  <td style='width:169px; height:12px; border-left:1px solid #000000;'>&nbsp;N<u>o</u> documento</td>" & vbCrlf &_
"  <td style='width:068px; height:12px; border-left:1px solid #000000;'>&nbsp;Espécie doc.</td>" & vbCrlf &_
"  <td style='width:040px; height:12px; border-left:1px solid #000000;'>&nbsp;Aceite</td>" & vbCrlf &_
"  <td style='width:078px; height:12px; border-left:1px solid #000000;'>&nbsp;Processamento</td>" & vbCrlf &_
"  <td style='width:186px; height:12px; border-left:1px solid #000000;'>&nbsp;Nosso número</td>" & vbCrlf &_
" </tr>" & vbCrlf &_
" <tr class='cp' valign='top'>" & vbCrlf &_
"  <td style='width:119px; height:12px; border-left:1px solid #FFFFFF;'>&nbsp;" & PrepData(Date,true,false) & "</td>" & vbCrlf &_
"  <td style='width:169px; height:12px; border-left:1px solid #000000;'>&nbsp;" & strBOLETO_NUM_DOCUMENTO 	& "</td>" & vbCrlf &_
"  <td style='width:068px; height:12px; border-left:1px solid #000000; text-align:center;'>" & strBOLETO_ESPECIE_DOC  & "</td>" & vbCrlf &_
"  <td style='width:040px; height:12px; border-left:1px solid #000000; text-align:center;'>" & strBOLETO_ACEITE & "</td>" & vbCrlf &_
"  <td style='width:078px; height:12px; border-left:1px solid #000000;'>&nbsp;</td>" & vbCrlf &_
"  <td style='width:186px; height:12px; border-left:1px solid #000000; text-align:right;'>" & strBOLETO_CARTEIRA & "/" & strBOLETO_NOSSO_NUMERO & "-" & strBOLETO_NOSSO_NUMERO_DV & "</td>" & vbCrlf &_
" </tr>" & vbCrlf &_
"</table>"
'----------------------------------------------------------------------------------------------------------------------------------
' FIM: Data documento, Numero doc, especie doc ...
'----------------------------------------------------------------------------------------------------------------------------------

'----------------------------------------------------------------------------------------------------------------------------------
' INI: Uso Banco, carteira, Especie e etc...
'----------------------------------------------------------------------------------------------------------------------------------
strHTML = strHTML & vbCrlf &_
"<table width='" & TOTWIDTH & "' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #000000; padding:0px; margin:0px;'>" & vbCrlf &_
" <tr class='ct' valign='top'>" & vbCrlf &_
"  <td style='width:119px; height:12px; border-left:1px solid #FFFFFF;'>&nbsp;Uso do banco</td>" & vbCrlf &_
"  <td style='width:089px; height:12px; border-left:1px solid #000000;'>&nbsp;Carteira</td>" & vbCrlf &_
"  <td style='width:059px; height:12px; border-left:1px solid #000000;'>&nbsp;Espécie</td>" & vbCrlf &_
"  <td style='width:129px; height:12px; border-left:1px solid #000000;'>&nbsp;Quantidade</td>" & vbCrlf &_
"  <td style='width:078px; height:12px; border-left:1px solid #000000;'>&nbsp;Valor</td>" & vbCrlf &_
"  <td style='width:186px; height:12px; border-left:1px solid #000000;'>&nbsp;(=) Valor documento</td>" & vbCrlf &_
" </tr>" & vbCrlf &_
" <tr class='cp' valign='top'>" & vbCrlf &_
"  <td style='width:119px; height:12px; border-left:1px solid #FFFFFF;'>&nbsp;</td>" & vbCrlf &_
"  <td style='width:089px; height:12px; border-left:1px solid #000000;'>&nbsp;" & strBOLETO_CARTEIRA & "</td>" & vbCrlf &_
"  <td style='width:059px; height:12px; border-left:1px solid #000000;'>&nbsp;" & strBOLETO_ESPECIE & "</td>" & vbCrlf &_
"  <td style='width:129px; height:12px; border-left:1px solid #000000;'>&nbsp;</td>" & vbCrlf &_
"  <td style='width:078px; height:12px; border-left:1px solid #000000;'>&nbsp;</td>" & vbCrlf &_
"  <td style='width:186px; height:12px; border-left:1px solid #000000; text-align:right;'>&nbsp;" & FormataDecimal(strBOLETO_VALOR,2)  & "</td>" & vbCrlf &_
" </tr>" & vbCrlf &_
"</table>"
'----------------------------------------------------------------------------------------------------------------------------------
' FIM: Uso Banco, carteira, Especie e etc...
'----------------------------------------------------------------------------------------------------------------------------------

'----------------------------------------------------------------------------------------------------------------------------------
' INI: Instruções (texto de responsabilidade do cedente), Descontos, Abatimentos e etc...
'----------------------------------------------------------------------------------------------------------------------------------
strHTML = strHTML & vbCrlf &_
"<table width='" & TOTWIDTH & "' heigth='300' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #000000; padding:0px; margin:0px;'>" & vbCrlf &_
" <tr class='ct' valign='top'>" & vbCrlf &_
"  <td style='width:478px; height:12px; border-left:1px solid #FFFFFF;'>" & vbCrlf &_
"    <table width='470' cellspacing='0' cellpadding='0' style='padding:0px; margin:0px;'>" & vbCrlf &_
"      <tr class='ct' valign='top'><td style='height:12px;'>&nbsp;Instruções (texto de responsabilidade do cedente)</td></tr>" & vbCrlf &_
"      <tr class='cp' valign='top'><td style='height:12px; padding-left:5px;'>" & strBOLETO_INSTRUCOES & "</td></tr>" & vbCrlf &_
"    </table>"  & vbCrlf &_
"  </td>" & vbCrlf &_
"  <td style='width:186px; height:12px; border-left:1px solid #000000;'>" & vbCrlf &_
"    <table width='186' cellspacing='0' cellpadding='0' style='padding:0px; margin:0px;'>" & vbCrlf &_
"      <tr class='ct' valign='top'><td style='height:12px;'>&nbsp;(-) Desconto / Abatimentos</td></tr>" & vbCrlf &_
"      <tr class='cp' valign='top'><td style='height:12px; border-bottom:1px solid #000000;'></td></tr>" & vbCrlf &_
"      <tr class='ct' valign='top'><td style='height:12px;'>&nbsp;(-) Outras deduções</td></tr>" & vbCrlf &_
"      <tr class='cp' valign='top'><td style='height:12px; border-bottom:1px solid #000000;'></td></tr>" & vbCrlf &_
"      <tr class='ct' valign='top'><td style='height:12px;'>&nbsp;(+) Mora / Multa</td></tr>" & vbCrlf &_
"      <tr class='cp' valign='top'><td style='height:12px; border-bottom:1px solid #000000;'></td></tr>" & vbCrlf &_
"      <tr class='ct' valign='top'><td style='height:12px;'>&nbsp;(+) Outros acréscimos</td></tr>" & vbCrlf &_
"      <tr class='cp' valign='top'><td style='height:12px; border-bottom:1px solid #000000;'></td></tr>" & vbCrlf &_
"      <tr class='ct' valign='top'><td style='height:12px;'>&nbsp;(=) Valor cobrado</td></tr>" & vbCrlf &_
"      <tr class='cp' valign='top'><td style='height:12px;'></td></tr>" & vbCrlf &_
"    </table>"  & vbCrlf &_
"  </td>" & vbCrlf &_
" </tr>" & vbCrlf &_
"</table>"
'----------------------------------------------------------------------------------------------------------------------------------
' FIM: Instruções (texto de responsabilidade do cedente), Descontos, Abatimentos e etc...
'----------------------------------------------------------------------------------------------------------------------------------

'----------------------------------------------------------------------------------------------------------------------------------
' INI: Linha SACADO
'----------------------------------------------------------------------------------------------------------------------------------
strHTML = strHTML & vbCrlf &_
"<table width='" & TOTWIDTH & "' cellspacing='0' cellpadding='0' style='border-bottom:1px solid #000000; padding:0px; margin:0px;'>" & vbCrlf &_
" <tr class='ct' valign='top'>" & vbCrlf &_
"  <td style='width:479px; height:12px;'>&nbsp;Sacado</td>" & vbCrlf &_
"  <td style='width:186px; height:12px; text-align:right'>&nbsp;Cód. baixa</td>" & vbCrlf &_
" </tr>" & vbCrlf &_
" <tr class='cp' valign='top'>" & vbCrlf   &_
"  <td style='width:479px; height:12px; padding:0px 0px 10px 5px'>" &_
      strBOLETO_SACADO_NOME & "&nbsp;&nbsp;CNPJ: " & strBOLETO_SACADO_CNPJ & "<br>"  &_
	  strBOLETO_SACADO_ENDERECO & "&nbsp;-&nbsp;" & strBOLETO_SACADO_BAIRRO & "<br>" &_ 
	  strBOLETO_SACADO_CEP & "&nbsp;-&nbsp;" & strBOLETO_SACADO_CIDADE & "&nbsp;-&nbsp;" & strBOLETO_SACADO_ESTADO  &_
"  </td>" & vbCrlf &_
"  <td style='width:187px; height:12px;'>&nbsp;</td>" & vbCrlf &_
" </tr>" & vbCrlf &_
"</table>"
'----------------------------------------------------------------------------------------------------------------------------------
' FIM: Linha SACADO
'----------------------------------------------------------------------------------------------------------------------------------

'----------------------------------------------------------------------------------------------------------------------------------
' INI: Linha Intruções, Autenticação mecanica
'----------------------------------------------------------------------------------------------------------------------------------
strHTML = strHTML & vbCrlf &_
"<table width='" & TOTWIDTH & "' cellspacing='0' cellpadding='0' style='border-bottom:1px dashed #000000; padding:0px; margin:0px;'>" & vbCrlf &_
" <tr class='ct' valign='top'>" & vbCrlf &_
"  <td style='width:466px; height:12px;'>&nbsp;Sacador/Avalista</td>" & vbCrlf &_
"  <td style='width:200px; height:12px; text-align:right;'>Autentic. mecânica - Ficha de Compensação</td>" & vbCrlf &_
" </tr>" & vbCrlf &_
" <tr class='cp' valign='top'>" & vbCrlf &_
"  <td style='width:466px; height:12px; padding-left:10px'>" & BarCode25(strBOLETO_CODIGO_BARRAS) & "</td>" & vbCrlf &_
"  <td style='width:200px; height:12px;'>&nbsp;</td>" & vbCrlf &_
" </tr>" & vbCrlf &_
" <tr class='ct' valign='top'>" & vbCrlf &_
"  <td style='width:466px; height:12px;'>&nbsp;</td>" & vbCrlf &_
"  <td style='width:200px; height:12px; text-align:right;'>Corte na linha pontilhada</td>" & vbCrlf &_
" </tr>" & vbCrlf &_
"</table>"
'----------------------------------------------------------------------------------------------------------------------------------
' FIM: Linha Intruções, Autenticação mecanica
'----------------------------------------------------------------------------------------------------------------------------------
strHTML = strHTML & vbCrlf & "</body></html>"

set objFileSystemObject = CreateObject("Scripting.FileSystemObject")
'------------------------------------------------------------------------------------------------------------
' Salva arquivo do boleto na pasta FIN_Boletos, que encontra-se dentro da pasta upload do cliente, 
' no seguinte formato: "codigo da conta a pagar/receber"_"numero de impressoes do boleto".htm
'------------------------------------------------------------------------------------------------------------
strFilePath = Server.MapPath(strUploadPath & "FIN_Boletos/Boleto_" & intCOD_CONTA_PAGAR_RECEBER & "_" & CInt("0" & strNUM_IMPRESSOES)+1 & ".htm")
set objArquivo = objFileSystemObject.CreateTextFile(strFilePath, true)   

strHTML = Replace(Replace(strHTML,"src='../img/","src='../../../img/"),"src='../upload/" & Request.Cookies("VBOSS")("CLINAME") & "/","src='../")

objArquivo.Write(strHTML)
objArquivo.Close

set objArquivo = Nothing
'------------------------------------------------------------------------------------------------------------
' Faz a leitura dos dados no arquivo gravado anteriormente
'------------------------------------------------------------------------------------------------------------
set objArquivo = objFileSystemObject.OpenTextFile(strFilePath)

strHTML = objArquivo.ReadAll
objArquivo.Close

set objArquivo 			= Nothing
set objFileSystemObject = Nothing

'------------------------------------------------------------------------------------------------------------
' Altera o caminho das imagens para poder exibir corretamente a partir do modulo atual
'------------------------------------------------------------------------------------------------------------
strHTML = Replace(strHTML,"src='../../../img/", "src='./img/")
strHTML = Replace(strHTML,"src='../"			 , "src='../upload/" & Request.Cookies("VBOSS")("CLINAME") & "/")
strHTML = Replace(strHTML,"src='./img/"		 , "src='../img/")
'------------------------------------------------------------------------------------------------------------

if Err.Number <> 0 then
	strMSG = "Não foi possível exibir boleto.<br>"
	strMSG = strMSG & Err.Number & " - " & Err.Description
	Mensagem strMSG, "", 1 
elseif intCOD_CONTA_PAGAR_RECEBER<>"" and IsNumeric(intCOD_CONTA_PAGAR_RECEBER) then
	AbreDBConn objConn, CFG_DB
	'AQUI: NEW TRANSACTION
	set objRSCT = objConn.Execute("start transaction")
	set objRSCT = objConn.Execute("set autocommit = 0")
	objConn.Execute("UPDATE FIN_CONTA_PAGAR_RECEBER SET NUM_IMPRESSOES=NUM_IMPRESSOES+1 WHERE COD_CONTA_PAGAR_RECEBER=" & intCOD_CONTA_PAGAR_RECEBER)
	if Err.Number<>0 then 
	  set objRSCT= objConn.Execute("rollback")
	  Mensagem "modulo_FIN_BOLETO.Boleto_Itau: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
 	  Response.End()
	else	  
	  set objRSCT= objConn.Execute("commit")
	End If

	FechaDBConn objConn
end if

Response.Write(strHTML)
%>