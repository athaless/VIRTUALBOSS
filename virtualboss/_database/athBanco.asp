<!--#include file="BarCode25.asp"-->
<%
	Dim CFG_COD_UNIBANCO, CFG_COD_BB, CFG_COD_BANRISUL, CFG_COD_ITAU 
	Dim DT_BASE_CALC_FATOR_VCTO
	Dim strPARTE_FIXA, strPARTE_LIVRE, strCODIGO_BARRAS, strLINHA_DIGITAVEL
	
	CFG_COD_UNIBANCO = "409"
	CFG_COD_BB       = "1"
	CFG_COD_BANRISUL = "21"
	CFG_COD_ITAU     = "14"
	'etc ...
	
	DT_BASE_CALC_FATOR_VCTO = "07/10/1997"
	'Alguns bancos, como Unibanco, utilizam a data 03/02/2000 como fator base.
	'No fundo não difere da data acima, porque apenas o número final começará em 1000 
	
	
	
Function CalcularDDV_Modulo10(prNUMERO, PesoMenor, PesoMaior)
	Dim Base, Soma, Val, Cont, Resto
	Dim Retorno
	
	Base = PesoMaior
	Soma = 0
	For Cont = Len(prNUMERO) To 1 Step - 1
		Val = Mid(prNUMERO, Cont, 1) * Base
		If Val > 9 Then
			Soma = Soma + (Val - 9)
		Else
			Soma = Soma + Val
		End If
		If Base = PesoMaior Then
			Base = PesoMenor
		Else
			Base = PesoMaior
		End If
	Next
	
	Resto = Soma mod 10
	If CStr(Resto) = "10" Or CStr(Resto) = "0" Then
		Retorno = "0"
	Else
		Retorno = CStr(10 - Resto)
	End If
	
	CalcularDDV_Modulo10 = Retorno
End Function

Function CalcularDDV_Modulo11(prNUMERO, PesoMenor, PesoMaior, prCodBanco, prCaso)
	Dim Retorno
	'Response.Write("f1: " & prCodBanco & "<br>")
	'Response.Write("f2: " & prCaso & "<br><br>")
	
	Dim Base, Soma, Resto, Cont
	
	Base = PesoMenor
	Soma = 0
	
	For Cont = Len(prNUMERO) To 1 Step -1 
		Soma = Soma + (Mid(prNUMERO, Cont, 1) * Base)
		Base = Base + 1
		If Base > PesoMaior Then Base = PesoMenor
	Next
	
	If CStr(prCodBanco) = CStr(CFG_COD_UNIBANCO) Then Soma = Soma * 10 
	Resto = Soma Mod 11
	Retorno = CStr(Resto)
	
	If CStr(prCodBanco) = CStr(CFG_COD_UNIBANCO) Then
		'Response.Write("f3: aqui<br>")
		If prCaso = "DV_CODIGOBARRAS" Then
			If (Resto = 0) Or (Resto = 1) Or (Resto = 10) Then
				Retorno = "1"
				'Response.Write("f4: aqui " & Retorno & "<br>")
			End If
		End If
		
		If prCaso = "DV_NOSSONUMERO" Then
			If (Resto = 0) Or (Resto = 10) Then
				Retorno = "0"
				'Response.Write("f5: aqui " & Retorno & "<br>")
			End If
		End If
	End If 
	'Response.Write("f6: aqui " & Retorno & "<br>")
	
	CalcularDDV_Modulo11 = Retorno
End Function

Function CalcularDVGeral(prCODIGO_BARRAS, prCodBanco)
	CalcularDVGeral = CalcularDDV_Modulo11(prCODIGO_BARRAS, 2, 9, prCodBanco, "DV_CODIGOBARRAS")
End Function

Function MontarLinhaDigitavel(prCODIGO_BARRAS)
	Dim strPARTE1, strPARTE2, strPARTE3, strPARTE4, strPARTE5
	Dim strDIGITO
	
	'Campo 1
	strPARTE1 = Mid(prCODIGO_BARRAS, 1, 4) & Mid(prCODIGO_BARRAS, 20, 5)
	strDIGITO = CalcularDDV_Modulo10(strPARTE1, 1, 2)
	strPARTE1 = Mid(strPARTE1, 1, 5) & "." & Mid(strPARTE1, 6, 4) & strDIGITO
	'Campo 2
	strPARTE2 = Mid(prCODIGO_BARRAS, 25, 10) 
	strDIGITO = CalcularDDV_Modulo10(strPARTE2, 1, 2)
	strPARTE2 = Mid(strPARTE2, 1, 5) & "." & Mid(strPARTE2, 6, 5) & strDIGITO
	'Campo 3
	strPARTE3 = Mid(prCODIGO_BARRAS, 35, 10) 
	strDIGITO = CalcularDDV_Modulo10(strPARTE3, 1, 2)
	strPARTE3 = Mid(strPARTE3, 1, 5) & "." & Mid(strPARTE3, 6, 5) & strDIGITO
	'Campo 4	
	strPARTE4 = Mid(prCODIGO_BARRAS, 5, 1) 
	'Campo 5	
	strPARTE5 = Mid(prCODIGO_BARRAS, 6, 14) 
	
	MontarLinhaDigitavel = strPARTE1 & "  " & strPARTE2 & "  " & strPARTE3 & "  " & strPARTE4 & "  " & strPARTE5 
End Function 

Function MontarParteFixa(strPARAM1, strPARAM2, strPARAM3, strPARAM4)
Dim strValue, strDtVcto
	strValue =	strPARAM4
	strDtVcto = strPARAM3
	strPARAM1 = ATHFormataTamLeft(strPARAM1, 3, "0")  
	strPARAM2 = ATHFormataTamLeft(strPARAM2, 1, "0") 
	
	strDtVcto = DateValue(CStr(PrepData(strDtVcto, True, False) & "")) - DateValue(DT_BASE_CALC_FATOR_VCTO) 
	strDtVcto = ATHFormataTamLeft(strDtVcto, 4, "0") 
	
	strValue = FormatNumber(strValue, 2)
	strValue = Replace(Replace(strValue, ",", ""), ".", "")
	strValue = ATHFormataTamLeft(strValue, 10, "0") 
	
	
	MontarParteFixa = strPARAM1 & strPARAM2 & strDtVcto & strValue 
End Function 

Function MontarParteLivre_UNIBANCO(prCodCliente, prNossoNumero, prNossoNumeroDV)
Dim strPARAM1
	
	strPARAM1 = prCodCliente
	strPARAM1 = ATHFormataTamLeft(strPARAM1, 7, "0")
	MontarParteLivre_UNIBANCO = "5" & strPARAM1 & "00" & prNossoNumero & prNossoNumeroDV 
End Function 

'... para mais tarde
Function MontarParteLivre_BB
	MontarParteLivre_BB = "" 
End Function 

Function MontarParteLivre_BANRISUL
	MontarParteLivre_BANRISUL = "" 
End Function 

Function MontarParteLivre_ITAU
	MontarParteLivre_ITAU = "" 
End Function 

%>