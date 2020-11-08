<%
Session.LCID = 1046

Function FormataDouble(pr_VALOR)
  FormataDouble = Replace(Replace(pr_VALOR,".",""),",",".")
End Function

Function FormataDecimal(pr_VALOR,pr_NUM_CASAS)
  If not IsNumeric(pr_VALOR) Or IsNull(pr_VALOR) Then
    pr_VALOR = FormatNumber(0,pr_NUM_CASAS)
  End If
  FormataDecimal = FormatNumber(pr_VALOR,pr_NUM_CASAS)
End Function

'--------------------------------------------------------
' Substitui o n�mero do m�s pelo seu nome por extenso
'--------------------------------------------------------
Public Function MesExtenso(iMes)
	Select Case iMes
    	Case 1:	 MesExtenso = "Janeiro"
    	Case 2:	 MesExtenso = "Fevereiro"
    	Case 3:	 MesExtenso = "Mar�o"
    	Case 4:	 MesExtenso = "Abril"
    	Case 5:	 MesExtenso = "Maio"
    	Case 6:	 MesExtenso = "Junho"
    	Case 7:	 MesExtenso = "Julho"
    	Case 8:	 MesExtenso = "Agosto"
    	Case 9:	 MesExtenso = "Setembro"
    	Case 10: MesExtenso = "Outubro"
    	Case 11: MesExtenso = "Novembro"
    	Case 12: MesExtenso = "Dezembro"
    	Case Else: MesExtenso = "Indefinido"
	End Select	
End Function

'--------------------------------------------------------
' Substitui o n�mero do m�s pelo seu nome por extenso
'--------------------------------------------------------
Public Function MesExtensoAbrev(iMes)
	Select Case iMes
    	Case  1: MesExtensoAbrev = "Jan"
    	Case  2: MesExtensoAbrev = "Fev"
    	Case  3: MesExtensoAbrev = "Mar"
    	Case  4: MesExtensoAbrev = "Abr"
    	Case  5: MesExtensoAbrev = "Mai"
    	Case  6: MesExtensoAbrev = "Jun"
    	Case  7: MesExtensoAbrev = "Jul"
    	Case  8: MesExtensoAbrev = "Ago"
    	Case  9: MesExtensoAbrev = "Set"
    	Case 10: MesExtensoAbrev = "Out"
    	Case 11: MesExtensoAbrev = "Nov"
    	Case 12: MesExtensoAbrev = "Dez"
    	Case Else: MesExtensoAbrev = "Indefinido"
	End Select	
End Function

'------------------------------------------------------
' Troca o n�mero do dia pelo nome do dia por extenso
'------------------------------------------------------
Public Function DiaSemana(iDia)
  Select Case iDia
	Case 1:	DiaSemana = "Domingo"
	Case 2:	DiaSemana = "Segunda-feira"
	Case 3:	DiaSemana = "Ter�a-feira"
	Case 4:	DiaSemana = "Quarta-feira"
	Case 5:	DiaSemana = "Quinta-feira"
	Case 6:	DiaSemana = "Sexta-feira"
	Case 7:	DiaSemana = "S�bado"
  End Select	
End Function

Function DiaDaSemana(strDia,strMes,strAno)
	Dim Data
	
	Data = DateSerial(strAno, strMes, strDia)
    If IsDate(Data) Then
        Select Case Data
        Case 1 DiaDaSemana = "DOM"
        Case 2 DiaDaSemana = "SEG"
        Case 3 DiaDaSemana = "TER"
        Case 4 DiaDaSemana = "QUA"
        Case 5 DiaDaSemana = "QUI"
        Case 6 DiaDaSemana = "SEX"
        Case 7 DiaDaSemana = "SAB"
        End Select
    Else
        DiaDaSemana = "Data Inv�lida!"
    End If
End Function

'----------------------------------------
' Exibe a data enviada por extenso
'----------------------------------------
Public Function DataExtenso(strData)
  DataExtenso = Day(strData) & " de " & MesExtenso(Month(strData)) & " de " & Year(strData)
End Function


'-----------------------------------------------------------------------------
' Formata a Data em Dia/M�s ou M�s/Dia, e pode incluir a data e hora
'-----------------------------------------------------------------------------
Public Function PrepData(DateToConvert, FormatoDiaMes, DataHora)

   ' Declara��o para vari�veis para dois m�todos
   Dim strDia
   Dim strMes
   Dim strAno
   Dim strHora
   Dim strMinuto
   Dim strSegundo

	If isDate(DateToConvert) Then
    	strDia     = Day(DateToConvert)
    	If strDia < 10 Then	strDia = "0" & strDia

     	strMes     = Month(DateToConvert)
     	If strMes < 10 Then	strMes = "0" & strMes

     	strAno     = Year(DateToConvert)
     	strHora    = Hour(DateToConvert)
     	If strHora < 10 Then strHora = "0" & strHora

     	strMinuto  = Minute(DateToConvert)
     	If strMinuto < 10 Then strMinuto = "0" & strMinuto

     	strSegundo = Second(DateToConvert)
     	If strSegundo < 10 Then strSegundo = "0" & strSegundo
 
		If FormatoDiaMes Then
       	  PrepData = strDia & "/" & strMes & "/" & strAno
     	Else
          PrepData = strMes & "-" & strDia & "-" & strAno
     	End If

     	If DataHora Then
       		PrepData = PrepData & " " & strHora & ":" & strMinuto & ":" & strSegundo
     	End If
	Else
    	PrepData = ""
	End If

End Function

'-------------------------------
' Retorna o signo
'-------------------------------
Public Function GetSigno ( prData, prTp )
Dim auxDate, auxAno
Dim matSignos(),auxIdx

   redim matSignos(12,2)
   matSignos(0,0) = "aquario"
   matSignos(1,0) = "peixes"
   matSignos(2,0) = "aries"
   matSignos(3,0) = "touro"
   matSignos(4,0) = "gemeos"
   matSignos(5,0) = "cancer"
   matSignos(6,0) = "leao"
   matSignos(7,0) = "virgen"
   matSignos(8,0) = "libra"
   matSignos(9,0) = "escorpiao"
   matSignos(10,0) = "sagitario"
   matSignos(11,0) = "capricornio"

   matSignos(0,1) = "Aqu�rio"
   matSignos(1,1) = "Peixes"
   matSignos(2,1) = "�ries"
   matSignos(3,1) = "Touro"
   matSignos(4,1) = "G�meos"
   matSignos(5,1) = "C�ncer"
   matSignos(6,1) = "Le�o"
   matSignos(7,1) = "Virgem"
   matSignos(8,1) = "Libra"
   matSignos(9,1) = "Escorpi�o"
   matSignos(10,1) = "Sagit�rio"
   matSignos(11,1) = "Capric�rnio"

   auxDate = CDate(prData)
   auxAno  = Year(auxDate)
   auxIdx  = 0
   IF prTp THEN auxIdx=1 END IF
   
   IF auxDate >= CDate(auxANO & "-01-21") and auxDate <= CDate(auxANO & "-02-19") then GetSigno = matSignos(0,auxIdx) end if
   IF auxDate >= CDate(auxANO & "-02-20") and auxDate <= CDate(auxANO & "-03-20") then GetSigno = matSignos(1,auxIdx) end if
   IF auxDate >= CDate(auxANO & "-03-21") and auxDate <= CDate(auxANO & "-04-20") then GetSigno = matSignos(2,auxIdx) end if
   IF auxDate >= CDate(auxANO & "-04-21") and auxDate <= CDate(auxANO & "-05-20") then GetSigno = matSignos(3,auxIdx) end if
   IF auxDate >= CDate(auxANO & "-05-21") and auxDate <= CDate(auxANO & "-06-20") then GetSigno = matSignos(4,auxIdx) end if
   IF auxDate >= CDate(auxANO & "-06-21") and auxDate <= CDate(auxANO & "-07-21") then GetSigno = matSignos(5,auxIdx) end if
   IF auxDate >= CDate(auxANO & "-07-22") and auxDate <= CDate(auxANO & "-08-22") then GetSigno = matSignos(6,auxIdx) end if
   IF auxDate >= CDate(auxANO & "-08-23") and auxDate <= CDate(auxANO & "-09-22") then GetSigno = matSignos(7,auxIdx) end if
   IF auxDate >= CDate(auxANO & "-09-23") and auxDate <= CDate(auxANO & "-10-22") then GetSigno = matSignos(8,auxIdx) end if
   IF auxDate >= CDate(auxANO & "-10-23") and auxDate <= CDate(auxANO & "-11-21") then GetSigno = matSignos(9,auxIdx) end if
   IF auxDate >= CDate(auxANO & "-11-22") and auxDate <= CDate(auxANO & "-12-21") then GetSigno = matSignos(10,auxIdx) end if
   IF auxDate >= CDate(auxANO & "-12-22") and auxDate <= CDate(auxANO & "-12-31") then GetSigno = matSignos(11,auxIdx) end if
   IF auxDate >= CDate(auxANO & "-01-01") and auxDate <= CDate(auxANO & "-01-20") then GetSigno = matSignos(11,auxIdx) end if
End Function

'-------------------------------
' Formata a data para o SQL
'-------------------------------
Public Function FormatDateSQL ( olddate )
Dim arrDate
	If IsDate(olddate) Then
		arrDate = Split (olddate, "/")
		FormatDateSQL = arrDate(1) & "-" & arrDate(0) & "-" & arrDate(2)
	End If
End Function


Const EncC1  = 109  'aqui era 109
Const EncC2  = 191  'aqui era 191
Const EncKey = 161  'aqui era 161

Private Function AuxShr(Numero, BShr)
  AuxShr = Int(Numero / (2 ^ BShr))
End Function

'--------------------------------------------------------------------------
' Criptografa uma string  
'--------------------------------------------------------------- by Aless -
Public Function AthEncriptaStr(Texto)
 Dim TempStr, TempResult, TempNum, TempChar
 Dim TempKey
 Dim i
 TempStr = Texto
 TempResult = ""
 TempKey = ((EncKey * EncC1) + EncC2) Mod 65536
 For i = 1 To Len(TempStr)
  TempNum    = (Asc(Mid(TempStr, i, 1)) Xor (AuxShr(TempKey, 8))) Mod 256
  TempChar   = Chr(TempNum)
  TempKey    = (((Asc(TempChar) + TempKey) * EncC1) + EncC2) Mod 65536
  TempResult = TempResult & TempChar
 Next
 AthEncriptaStr = TempResult
End Function

'--------------------------------------------------------------------------
' Criptografa uma string (embaralhamento simples)   
'--------------------------------------------------------------- by Aless -
Public Function AthDecriptaStr(Texto)
 Dim TempStr, TempResult, TempNum, TempChar
 Dim TempKey
 Dim i
 TempStr = Texto
 TempResult = ""
 TempKey = ((EncKey * EncC1) + EncC2) Mod 65536
 For i = 1 To Len(TempStr)
  TempNum    = (Asc(Mid(TempStr, i, 1)) Xor (AuxShr(TempKey, 8))) Mod 256
  TempChar   = Chr(TempNum)
  TempKey    = (((Asc(Mid(TempStr, i, 1)) + TempKey) * EncC1) + EncC2) Mod 65536
  TempResult = TempResult & TempChar
 Next
 AthDecriptaStr = TempResult
End Function


'-----------------------------------------------------------------------------
' Criptografa uma string (embaralhamento simples)   
'-----------------------------------------------------------------------------
Public Function ATHCriptograf(senha)
Dim tam, i, strSenha
	tam = Len(senha)
	strSenha = ""
	i = 1
	while i <= tam 
     strSenha = strSenha & Mid(senha, i+1, 1) & Mid(senha, i, 1)
	 i=i+2
	Wend
	ATHCriptograf = strReverse(strSenha)
End Function

'-----------------------------------------------------------------------------
' Decriptografa uma string (embaralhamento simples) 
'-----------------------------------------------------------------------------
Public Function ATHDeCriptograf(senha)
Dim tam, i, strSenha
	tam = Len(senha)
	senha = strReverse (senha)
	strSenha = ""
	i = 1
	while i <= tam 
     strSenha = strSenha & Mid(senha, i+1, 1) & Mid(senha, i, 1)
	 i=i+2
	Wend
	ATHDeCriptograf = strSenha
End Function

'-----------------------------------------------------------------------------
' Faz formata��o de uma str pelo lado direito no tamanho especIficado         
'-----------------------------------------------------------------------------
Public Function ATHFormataTamRight(dado,tam,carac)
  While Len(dado) < tam
   dado = dado & carac
  Wend

  If Len(dado) > tam  Then dado = Mid(dado, 1, tam)
  ATHFormataTamRight = dado
End Function

'-----------------------------------------------------------------------------
' Faz formata��o de uma str pelo lado esquerdo no tamanho especificado
'------------------------------------------------------------ adapted by MAURO 
Public Function ATHFormataTamLeft(dado,tam,carac)

  While Len(dado) < tam 
    dado = carac & dado
  Wend

  If Len(dado) > tam Then dado = Mid(dado, 1, Len(dado) - tam)
  ATHFormataTamLeft = dado
End Function


Function LocalizaARQUIVO(strPath, prARQUIVO)
Dim objFSO
	Set objFSO = Server.CreateObject("Scripting.FileSystemObject")

	If objFSO.FileExists(strPath & prARQUIVO) Then 
	  LocalizaARQUIVO = True
	Else
	  LocalizaARQUIVO = False
	End If
	
	Set objFSO = NOThing
End Function

Function ArqExist(PR_ORIG, PR_IMAGE, PR_IMAGE_SUBST)
Dim objFSO, strPath
	Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
	strPath = Server.MapPath(PR_ORIG) & "\" & Replace(PR_IMAGE,"/","\")
	If objFSO.FileExists(strPath) Then
	  ArqExist = PR_ORIG & "/" &PR_IMAGE
	Else
	  ArqExist = PR_IMAGE_SUBST
	End If
	Set objFSO = NOThing
End Function

'**************************************************
' Verifica se num s� cont�m n�meros
'**************************************************
Function IsNumberDigit(pr_field)
 Dim bolNum
 
 bolNum = True
 For i = 1 To Len(pr_field)
	If NOT isNumeric(Mid(pr_field, i, 1)) = True Then
		bolNum = False
	End If
 Next
 IsNumberDigit = bolNum
End Function

'*************************************************
' Valida E-Mail
'*************************************************
Function Verifica_Email(StrMail)
	StrMail = trim(StrMail)
	' Se h� espa�o vazio, ent�o...
	If InStr(1, StrMail, " ") > 0 Then
		Verifica_Email = False
		Exit Function
	End If

	' Verifica tamanho da String, pois o menor endere�o v�lido � x@x.xx.
	If Len(StrMail) < 6 Then
		verifica_email = False
		Exit Function
	End If
	' Verifica se h� um "@" no endere�o.
	If InStr(StrMail, "@") = 0 Then
		verifica_email = False
		Exit Function
	End If
	' Verifica se h� um "." no endere�o.
	If InStr(StrMail, ".") = 0 Then
		verifica_email = False
		Exit Function
	End If
	' Verifica se h� a quantidade m�nima de caracteres � igual ou maior que 3.
	If Len(StrMail) - InStrRev(StrMail, ".") > 3 Then
		verifica_email = False
		Exit Function
	End If

	' Verifica se h� "_" ap�s o "@".
	If InStr(StrMail, "_") <> 0 And InStrRev(StrMail, "_") > InStrRev(StrMail, "@") Then
		verifica_email = False
		Exit Function
	Else
		Dim IntCounter
		Dim IntF
		IntCounter = 0
		For IntF = 1 To Len(StrMail)
			If Mid(StrMail, IntF, 1) = "@" Then
				IntCounter = IntCounter + 1
			End If
		Next
		If IntCounter > 1 Then
			verifica_email = True
		End If
		' Valida cada caracter do endere�o.
		IntF = 0
		For IntF = 1 To Len(StrMail)
			If IsNumeric(Mid(StrMail, IntF, 1)) = False And (LCase(Mid(StrMail, IntF, 1)) < "a" Or LCase(Mid(StrMail, IntF, 1)) > "z") And _
				Mid(StrMail, IntF, 1) <> "_" And Mid(StrMail, IntF, 1) <> "." And Mid(StrMail, IntF, 1) <> "-" Then
					verifica_email = True
			End If
		Next
	End If
End Function

'Fun��o que transforma os caracteres especiais no seu respectivo c�digo
Function ReturnCodigo(pr_string)

	pr_string = Replace(pr_string, "&", "&amp;")
	pr_string = Replace(pr_string, "�", "&Agrave;")
	pr_string = Replace(pr_string, "�", "&agrave;")
	pr_string = Replace(pr_string, "�", "&Aacute;")
	pr_string = Replace(pr_string, "�", "&aacute;")
	pr_string = Replace(pr_string, "�", "&Acirc;")
	pr_string = Replace(pr_string, "�", "&acirc;")
	pr_string = Replace(pr_string, "�", "&Atilde;")
	pr_string = Replace(pr_string, "�", "&atilde;")
	pr_string = Replace(pr_string, "�", "&Auml;")
	pr_string = Replace(pr_string, "�", "&auml;")

	pr_string = Replace(pr_string, "�", "&Ccedil;")
	pr_string = Replace(pr_string, "�", "&ccedil;")

	pr_string = Replace(pr_string, "�", "&Egrave;")
	pr_string = Replace(pr_string, "�", "&egrave;")
	pr_string = Replace(pr_string, "�", "&Eacute;")
	pr_string = Replace(pr_string, "�", "&eacute;")
	pr_string = Replace(pr_string, "�", "&Ecirc;")
	pr_string = Replace(pr_string, "�", "&ecirc;")
	pr_string = Replace(pr_string, "�", "&Euml;")
	pr_string = Replace(pr_string, "�", "&euml;")

	pr_string = Replace(pr_string, "�", "&Igrave;")
	pr_string = Replace(pr_string, "�", "&igrave;")
	pr_string = Replace(pr_string, "�", "&Iacute;")
	pr_string = Replace(pr_string, "�", "&iacute;")
	pr_string = Replace(pr_string, "�", "&Icirc;")
	pr_string = Replace(pr_string, "�", "&icirc;")
	pr_string = Replace(pr_string, "�", "&Iuml;")
	pr_string = Replace(pr_string, "�", "&iuml;")

	pr_string = Replace(pr_string, "�", "&Ntilde;")
	pr_string = Replace(pr_string, "�", "&ntilde;")

	pr_string = Replace(pr_string, "�", "&Ograve;")
	pr_string = Replace(pr_string, "�", "&ograve;")
	pr_string = Replace(pr_string, "�", "&Oacute;")
	pr_string = Replace(pr_string, "�", "&oacute;")
	pr_string = Replace(pr_string, "�", "&Ocirc;")
	pr_string = Replace(pr_string, "�", "&ocirc;")
	pr_string = Replace(pr_string, "�", "&Otilde;")
	pr_string = Replace(pr_string, "�", "&otilde;")
	pr_string = Replace(pr_string, "�", "&Ouml;")
	pr_string = Replace(pr_string, "�", "&Ouml;")
	
	pr_string = Replace(pr_string, "�", "&Ugrave;")
	pr_string = Replace(pr_string, "�", "&ugrave;")
	pr_string = Replace(pr_string, "�", "&Uacute;")
	pr_string = Replace(pr_string, "�", "&uacute;")
	pr_string = Replace(pr_string, "�", "&Ucirc;")
	pr_string = Replace(pr_string, "�", "&ucirc;")
	pr_string = Replace(pr_string, "�", "&Uuml;")
	pr_string = Replace(pr_string, "�", "&uuml;")

	pr_string = Replace(pr_string, "�", "&szlig;")
	pr_string = Replace(pr_string, "�", "&divide;")
	pr_string = Replace(pr_string, "�", "&yuml;")
	pr_string = Replace(pr_string, "<", "&lt;")
	pr_string = Replace(pr_string, ">", "&gt;")
	pr_string = Replace(pr_string, """", "&quot;")
	pr_string = Replace(pr_string, "'", "''")
	pr_string = Replace(pr_string, "�", "&deg;")

	ReturnCodigo = pr_string
End Function

'Fun��o que transforma o c�digo no seu respectivo caracter especial
Function ReturnCaracterEspecial(pr_string)

	pr_string = Replace(pr_string, "&amp;", "&")
	pr_string = Replace(pr_string, "&Agrave;", "�")
	pr_string = Replace(pr_string, "&agrave;", "�")
	pr_string = Replace(pr_string, "&Aacute;", "�")
	pr_string = Replace(pr_string, "&aacute;", "�")
	pr_string = Replace(pr_string, "&Acirc;", "�")
	pr_string = Replace(pr_string, "&acirc;", "�")
	pr_string = Replace(pr_string, "&Atilde;", "�")
	pr_string = Replace(pr_string, "&atilde;", "�")
	pr_string = Replace(pr_string, "&Auml;", "�")
	pr_string = Replace(pr_string, "&auml;", "�")

	pr_string = Replace(pr_string, "&Ccedil;", "�")
	pr_string = Replace(pr_string, "&ccedil;", "�")

	pr_string = Replace(pr_string, "&Egrave;", "�")
	pr_string = Replace(pr_string, "&egrave;", "�")
	pr_string = Replace(pr_string, "&Eacute;", "�")
	pr_string = Replace(pr_string, "&eacute;", "�")
	pr_string = Replace(pr_string, "&Ecirc;", "�")
	pr_string = Replace(pr_string, "&ecirc;", "�")
	pr_string = Replace(pr_string, "&Euml;", "�")
	pr_string = Replace(pr_string, "&euml;", "�")

	pr_string = Replace(pr_string, "&Igrave;", "�")
	pr_string = Replace(pr_string, "&igrave;", "�")
	pr_string = Replace(pr_string, "&Iacute;", "�")
	pr_string = Replace(pr_string, "&iacute;", "�")
	pr_string = Replace(pr_string, "&Icirc;", "�")
	pr_string = Replace(pr_string, "&icirc;", "�")
	pr_string = Replace(pr_string, "&Iuml;", "�")
	pr_string = Replace(pr_string, "&iuml;", "�")

	pr_string = Replace(pr_string, "&Ntilde;", "�")
	pr_string = Replace(pr_string, "&ntilde;", "�")

	pr_string = Replace(pr_string, "&Ograve;", "�")
	pr_string = Replace(pr_string, "&ograve;", "�")
	pr_string = Replace(pr_string, "&Oacute;", "�")
	pr_string = Replace(pr_string, "&oacute;", "�")
	pr_string = Replace(pr_string, "&Ocirc;", "�")
	pr_string = Replace(pr_string, "&ocirc;", "�")
	pr_string = Replace(pr_string, "&Otilde;", "�")
	pr_string = Replace(pr_string, "&otilde;", "�")
	pr_string = Replace(pr_string, "&Ouml;", "�")
	pr_string = Replace(pr_string, "&Ouml;", "�")
	
	pr_string = Replace(pr_string, "&Ugrave;", "�")
	pr_string = Replace(pr_string, "&ugrave;", "�")
	pr_string = Replace(pr_string, "&Uacute;", "�")
	pr_string = Replace(pr_string, "&uacute;", "�")
	pr_string = Replace(pr_string, "&Ucirc;", "�")
	pr_string = Replace(pr_string, "&ucirc;", "�")
	pr_string = Replace(pr_string, "&Uuml;", "�")
	pr_string = Replace(pr_string, "&uuml;", "�")

	pr_string = Replace(pr_string, "&szlig;", "�")
	pr_string = Replace(pr_string, "&divide;", "�")
	pr_string = Replace(pr_string, "&yuml;", "�")
	pr_string = Replace(pr_string, "&lt;", "<")
	pr_string = Replace(pr_string, "&gt;", ">")
	pr_string = Replace(pr_string, "&quot;", """")
	pr_string = Replace(pr_string, "''", "'")
	pr_string = Replace(pr_string, "&deg;", "�")

	ReturnCaracterEspecial = pr_string
End Function

'Efetua o swap de variari�veis
Sub Change(byRef a, byRef b)
   Dim aux

   aux = a
   a   = b
   b   = aux
End Sub


Function OrdenaArray(prArray, prArrayNome, prArrayBy, prMaior)
	Dim j, aux

	For i = 1 To UBound(prArray)
		For j = 1 To UBound(prArray)
			If prMaior Then 'Ordena pelo maior
				If CInt(prArray(j)) < CInt(prArray(i)) Then
					Change prArray(j), prArray(i) 'Array principal
					'Change prArrayNome(j), prArray(i) 'Nome dos campos
					'Change prArrayBy(j), prArray(i) 'ASC ou DESC

					aux = prArrayNome(j) 'Joga em vari�vel auxiliar
					prArrayNome(j) = prArrayNome(i) 'Troca pelo valor maior
					prArrayNome(i) = aux 'Joga a vari�vel auxiliar no outro valor do array

					aux = prArrayBy(j)
					prArrayBy(j) = prArrayBy(i)
					prArrayBy(i) = aux
				End If
			Else 'Ordena pelo menor
				If CInt(prArray(j)) > CInt(prArray(i)) Then
					Change prArray(i), prArray(j)

					aux = prArrayNome(i)
					prArrayNome(i) = prArrayNome(j)
					prArrayNome(j) = aux

					aux = prArrayBy(i)
					prArrayBy(i) = prArrayBy(j)
					prArrayBy(j) = aux
				End If
			End If
		Next
	Next
End Function


function ShowErrorDescription (pr_error, pr_errdesc)
	Select Case pr_error
		Case -2147467259 :	ShowErrorDescription = "O registro n�o pode ser removido por possuir registro(s) ""filho(s)"" relacionado(s)" 
			' The record cannot be deleted or changed because table 'NOTAS_ITENS' includes related records
		Case 3:	ShowErrorDescription = "Return sem GoSub"
		Case 5:	ShowErrorDescription = "Chamada de Procedimento Inv�lida"
		Case 6:	ShowErrorDescription = "Sobrecarga"
		Case 7:	ShowErrorDescription = "Sem Mem�ria"
		Case 9:	ShowErrorDescription = "SubScript fora de �rea"
		Case 10: ShowErrorDescription = "Este Array est� fixo ou temporariamente travado"
		Case 11: ShowErrorDescription = "Divis�o Por Zero"
		Case 13: ShowErrorDescription = "Tipos Incompat�veis"
		Case 14: ShowErrorDescription = "Fora de Espa�o de String"
		Case 16: ShowErrorDescription = "Express�o muito Complexa"
		Case 17: ShowErrorDescription = "N�o pode recuperar a opera��o"
		Case 18: ShowErrorDescription = "Interrup��o do usu�rio ocorrida"
		Case 20: ShowErrorDescription = "Resume Without Error"
		Case 28: ShowErrorDescription = "Fora de Espa�o de Pilha"
		Case 35: ShowErrorDescription = "Sub ou Function n�o Definida"
		Case 47: ShowErrorDescription = "Muitas DLL na aplica��o cliente"
		Case 48: ShowErrorDescription = "Erro carregando DLL"
		Case 49: ShowErrorDescription = "DLL com problemas de chamada"
		Case 51: ShowErrorDescription = "Erro Interno"
		Case 52: ShowErrorDescription = "Nome ou n�mero do arquivo errado"
		Case 53: ShowErrorDescription = "Arquivo n�o Encontrado"
		Case 54: ShowErrorDescription = "Modo de arquivo errado"
		Case 55: ShowErrorDescription = "Arquivo j� est� Aberto"
		Case 57: ShowErrorDescription = "Device I/O Error"
		Case 58: ShowErrorDescription = "Arquivo j� existente"
		Case 59: ShowErrorDescription = "Tamanho do registro errado"
		Case 61: ShowErrorDescription = "Disco Cheio"
		Case 62: ShowErrorDescription = "Entrada passa do final do arquivo"
		Case 63: ShowErrorDescription = "N�mero de registros errados"
		Case 67: ShowErrorDescription = "Muitos arquivos"
		Case 68: ShowErrorDescription = "Ferramenta n�o dispon�vel"
		Case 70: ShowErrorDescription = "Permiss�o Negada"
		Case 71: ShowErrorDescription = "Disco n�o Preparado"
		Case 74: ShowErrorDescription = "N�o posso renomear com discos diferentes"
		Case 75: ShowErrorDescription = "Caminho/Arquivos Erro de acesso"
		Case 76: ShowErrorDescription = "Caminho n�o encontrado"
		Case 91: ShowErrorDescription = "Vari�vel de objeto n�o definida"
		Case 92: ShowErrorDescription = "Loop For n�o foi inicializado"
		Case 94: ShowErrorDescription = "Uso inv�lido de Null"
		Case 322: ShowErrorDescription = "N�o posso criar Arquivos tempor�rios nescess�rios"
		Case 325: ShowErrorDescription = "Formato inv�lido no arquivo"
		Case 380: ShowErrorDescription = "Valor da propriedade inv�lida"
		Case 400: ShowErrorDescription = "ERRO HTTP 1.1 --- pedido ruim"
		Case 401.1: ShowErrorDescription = "ERRO HTTP 1.1 --- n�o autorizado: falha no logon"
		Case 401.2: ShowErrorDescription = "ERRO HTTP 1.1 --- n�o autorizado: falha no logon devido a configura��o do servidor"
		Case 401.3: ShowErrorDescription = "ERRO HTTP 1.1 --- n�o autorizado: n�o autorizado devido a ACL no recurso"
		Case 401.4: ShowErrorDescription = "ERRO HTTP 1.1 --- n�o autorizado: falha na autoriza��o pelo filtro"
		Case 401.5: ShowErrorDescription = "ERRO HTTP 1.1 --- n�o autorizado: falha na autoriza��o por ISAPI/CGI App"
		Case 403.1: ShowErrorDescription = "ERRO HTTP 1.1 --- proibido: acesso a execu��o proibido"
		Case 403.2: ShowErrorDescription = "ERRO HTTP 1.1 --- proibido: acesso de leitura proibido"
		Case 403.3: ShowErrorDescription = "ERRO HTTP 1.1 --- proibido: acesso de escrever proibido"
		Case 403.4: ShowErrorDescription = "ERRO HTTP 1.1 --- proibido: requer SSL"
		Case 403.5: ShowErrorDescription = "ERRO HTTP 1.1 --- proibido: requer SSL 128"
		Case 403.6: ShowErrorDescription = "ERRO HTTP 1.1 --- proibido: endere�o de IP rejeitado"
		Case 403.7: ShowErrorDescription = "ERRO HTTP 1.1 --- proibido: requer certifica��o do cliente"
		Case 403.8: ShowErrorDescription = "ERRO HTTP 1.1 --- proibido: acesso ao site negado"
		Case 403.9: ShowErrorDescription = "ERRO HTTP 1.1 --- acesso proibido: Muitos usu�rios est�o conectados"
		Case 403.10: ShowErrorDescription = "ERRO HTTP 1.1 --- acesso proibido: configura��o inv�lida"
		Case 403.11: ShowErrorDescription = "ERRO HTTP 1.1 --- acesso proibido: senha alterada"
		Case 403.12: ShowErrorDescription = "ERRO HTTP 1.1 --- acesso proibido: negado acesso ao mapa"
		Case 404: ShowErrorDescription = "ERRO HTTP 1.1 --- n�o encontrado"
		Case 405: ShowErrorDescription = "ERRO HTTP 1.1 --- m�todo n�o permitido"
		Case 406: ShowErrorDescription = "ERRO HTTP 1.1 --- n�o aceit�vel"
		Case 407: ShowErrorDescription = "ERRO HTTP 1.1 --- requer autentica��o do Proxy"
		Case 412: ShowErrorDescription = "ERRO HTTP 1.1 --- falha em pr� condi��es"
		Case 414: ShowErrorDescription = "ERRO HTTP 1.1 --- pedido - URI muito grande"
		Case 423: ShowErrorDescription = "Propriedade ou metodo n�o encontrado"
		Case 424: ShowErrorDescription = "Objeto Requerido"
		Case 429: ShowErrorDescription = "OLE Automation n�o pode ser criado no servidor"
		Case 430: ShowErrorDescription = "Classe n�o suportada pelo OLE Automation"
		Case 432: ShowErrorDescription = "Nome do arquivo ou de classe n� encontrado durante a opera��o OLE Automation"
		Case 438: ShowErrorDescription = "Objeto n�o suporta esta propriedade ou m�todo"
		Case 440: ShowErrorDescription = "Erro na OLE Automation"
		Case 442: ShowErrorDescription = "Connection to type library or object library for remote process has been lost. Press OK for dialog to remove reference"
		Case 443: ShowErrorDescription = "Objeto OLE Automation n�o cont�m um valor padr�o"
		Case 445: ShowErrorDescription = "Objeto n�o suporta esta a��o"
		Case 446: ShowErrorDescription = "Objeto n�o suporta o nome do argumento"
		Case 447: ShowErrorDescription = "Objeto n�o suporta a defini��o do local atual"
		Case 448: ShowErrorDescription = "Nome de argumentos n�o encontrados"
		Case 449: ShowErrorDescription = "Este argumento n�o � opcional"
		Case 450: ShowErrorDescription = "N�mero de argumentos errado ou defini��o de propriedade inv�lida"
		Case 451: ShowErrorDescription = "Objeto n�o � uma cole��o"
		Case 452: ShowErrorDescription = "N�mero ordinal inv�lido"
		Case 453: ShowErrorDescription = "Fun��o DLL especificada n�o foi encontrada"
		Case 454: ShowErrorDescription = "c�digo de origem n�o encontrado"
		Case 455: ShowErrorDescription = "Erro de trava no c�digo"
		Case 457: ShowErrorDescription = "Esta chave j� est� associada a um elemento desta cole��o"
		Case 458: ShowErrorDescription = "Tipos de vari�veis usadas na OLE Automation n�o s�o suportadas pelo Visual Basic"
		Case 462: ShowErrorDescription = "A m�quina do servidor remoto n�o existe ou n�o est� dispon�vel"
		Case 481: ShowErrorDescription = "Figura Inv�lida"
		Case 500: ShowErrorDescription = "Vari�vel n�o definida"
		Case 501: ShowErrorDescription = "Vari�vel n�o pode ser atribu�da"
		Case 502: ShowErrorDescription = "Objeto n�o � seguro para script"
		Case 503: ShowErrorDescription = "Objeto n�o � seguro para inicializa��o"
		Case 504: ShowErrorDescription = "Objeto n�o � seguro para cria��o"
		Case 505: ShowErrorDescription = "Refer�ncia inv�lida ou n�o qualificada"
		Case 506: ShowErrorDescription = "Classe n�o definida"
		Case 1001: ShowErrorDescription = "Sem mem�ria"
		Case 1002: ShowErrorDescription = "Erro de Sintaxe"
		Case 1003: ShowErrorDescription = "Esperado ':'"
		Case 1004: ShowErrorDescription = "Esperado ';'"
		Case 1005: ShowErrorDescription = "Esperado '('"
		Case 1006: ShowErrorDescription = "Esperado ')'"
		Case 1007: ShowErrorDescription = "Esperado ']'"
		Case 1008: ShowErrorDescription = "Esperado '{'"
		Case 1009: ShowErrorDescription = "Esperado '}'"
		Case 1010: ShowErrorDescription = "Esperado Identificador"
		Case 1011: ShowErrorDescription = "Esperado '='"
		Case 1012: ShowErrorDescription = "Esperado 'If'"
		Case 1013: ShowErrorDescription = "Esperado 'To'"
		Case 1014: ShowErrorDescription = "Esperado 'End'"
		Case 1015: ShowErrorDescription = "Esperado 'Function'"
		Case 1016: ShowErrorDescription = "Esperado 'Sub'"
		Case 1017: ShowErrorDescription = "Esperado 'Then'"
		Case 1018: ShowErrorDescription = "Esperado 'Wend'"
		Case 1019: ShowErrorDescription = "Esperado 'Loop'"
		Case 1020: ShowErrorDescription = "Esperado 'Next'"
		Case 1021: ShowErrorDescription = "Esperado 'Case'"
		Case 1022: ShowErrorDescription = "Esperado 'Select'"
		Case 1023: ShowErrorDescription = "Esperado express�o"
		Case 1024: ShowErrorDescription = "Esperado declara��o"
		Case 1025: ShowErrorDescription = "Esperado final da declara��o"
		Case 1026: ShowErrorDescription = "Esperado inteiro constante"
		Case 1027: ShowErrorDescription = "Esperado 'While' , 'Until'"
		Case 1028: ShowErrorDescription = "Esperado 'While' , 'Until' ou final de declara��o"
		Case 1029: ShowErrorDescription = "Esperado 'With'"
		Case 1030: ShowErrorDescription = "Identificador Muito Longo"
		Case 1031: ShowErrorDescription = "N�mero Inv�lido"
		Case 1032: ShowErrorDescription = "Caracter Inv�lido"
		Case 1033: ShowErrorDescription = "Constante de String n�o Terminada"
		Case 1034: ShowErrorDescription = "Coment�rio n�o Terminado"
		Case 1035: ShowErrorDescription = "Nested Comment"
		Case 1036: ShowErrorDescription = "'Me' n�o pode ser usado como sa�da de rotina"
		Case 1037: ShowErrorDescription = "Uso Inv�lido da Palavra Chave 'Me'"
		Case 1038: ShowErrorDescription = "'Loop' sem 'Do'"
		Case 1039: ShowErrorDescription = "Declara��o 'Exit' Inv�lida"
		Case 1040: ShowErrorDescription = "Vari�vel de Controle de Loop 'for' Inv�lida"
		Case 1041: ShowErrorDescription = "Vari�vel Redefinida"
		Case 1042: ShowErrorDescription = "Tem que ser a primeira declara��o da linha"
		Case 1043: ShowErrorDescription = "N�o pode atribuir non-By Val para um argumento"
		Case 1044: ShowErrorDescription = "N�o pode usar par�ntesis para chamar uma sub"
		Case 1045: ShowErrorDescription = "Esperada Constante Literal"
		Case 1046: ShowErrorDescription = "Esperado 'In'"
		Case 1047: ShowErrorDescription = "Esperado 'Class'"
		Case 1048: ShowErrorDescription = "Tem que ser definido dentro de uma Classe"
		Case 1049: ShowErrorDescription = "Esperado Let ou Set ou Get na declara��o de propriedade"
		Case 1050: ShowErrorDescription = "Esperado 'Property'"
		Case 1051: ShowErrorDescription = "N�mero de argumentos tem que ser consistente em especifica��es de propriedades"
		Case 1052: ShowErrorDescription = "N�o pode haver m�todo/ propriedade padr�o m�ltiplo em uma Classe"
		Case 1053: ShowErrorDescription = "Class initialize ou terminate n�o tem argumentos"
		Case 1054: ShowErrorDescription = "Propriedade Set ou Let tem que ter pelo menos um argumento"
		Case 1055: ShowErrorDescription = "'Next' inesperado"
		Case 1056: ShowErrorDescription = "'Default' pode ser especificado somente em 'Property' ou 'Function' ou 'Sub'"
		Case 1057: ShowErrorDescription = "Especifica��o 'Default' precisa especificar tamb�m 'Public'"
		Case 1058: ShowErrorDescription = "Especifica��o 'Default' s� pode estar em Property Get"
		Case 3000: ShowErrorDescription = "O provedor n�o concluiu a a��o pedida"
		Case 3001: ShowErrorDescription = "A aplica��o est� usando argumentos do tipo errado, est�o fora do �mbito aceit�vel ou em conflito com alguma outra aplica��o"
		Case 3002: ShowErrorDescription = "Ocorreu um erro durante a abertura do arquivo pedido"
		Case 3003: ShowErrorDescription = "Erro na leitura do arquivo especificado"
		Case 3004: ShowErrorDescription = "Erro ao escrever no arquivo"
		Case 3021: ShowErrorDescription = "BOF ou EOF � True ou o registro atual foi deletado. A opera��o pedido pela aplica��o requer um registro atual"
		Case 3219: ShowErrorDescription = "A opera��o pedida pela aplica��o n�o � permitida neste contexto"
		Case 3246: ShowErrorDescription = "A aplica��o n�o pode fechar explicitamente um objeto connection no meio de uma transa��o"
		Case 3251: ShowErrorDescription = "O provedor n�o oferece suporte a opera��o pedida pela aplica��o"
		Case 3265: ShowErrorDescription = "ADO n�o pode achar o objeto na cole��o"
		Case 3367: ShowErrorDescription = "N�o � anexar, objeto j� est� na cole��o"
		Case 3420: ShowErrorDescription = "O objeto referenciado pela aplica��o n�o aponta mais para um objeto v�lido"
		Case 3421: ShowErrorDescription = "A aplica��o est� usando um valor do tipo errado para a aplica��o atual"
		Case 3704: ShowErrorDescription = "A opera��o pedida pela aplica��o n�o � permitida se o objeto estiver fechado"
		Case 3705: ShowErrorDescription = "A opera��o pedida pela aplica��o n�o � permitida se o objeto estiver aberto"
		Case 3706: ShowErrorDescription = "ADO n�o pode achar o provedor especificado"
		Case 3707: ShowErrorDescription = "A aplica��o n�o pode alterar a propriedade ActiveConnect de um objeto Recordset com um objeto Command como fonte"
		Case 3708: ShowErrorDescription = "A aplica��o definiu de modo impr�prio um objeto Parameter"
		Case 3709: ShowErrorDescription = "A aplica��o pediu uma opera��o em um objeto com uma refer�ncia a um objeto Connection inv�lido ou fechado"
		Case 3710: ShowErrorDescription = "A opera��o n�o � reentrante"
		Case 3711: ShowErrorDescription = "A opera��o ainda est� executando"
		Case 3712: ShowErrorDescription = "Opera��o cancelada"
		Case 3713: ShowErrorDescription = "A opera��o ainda est� conectando"
		Case 3714: ShowErrorDescription = "A transa��o � inv�lida"
		Case 3715: ShowErrorDescription = "A opera��o n�o est� sendo executada"
		Case 3716: ShowErrorDescription = "A opera��o n�o � segura sob estas circunst�ncias"
		Case 3717: ShowErrorDescription = "A opera��o fez com que aparecesse uma caixa de di�logo"
		Case 3718: ShowErrorDescription = "A opera��o fez com que aparecesse um cabe�alho de caixa de di�logo"
		Case 3719: ShowErrorDescription = "A a��o falhou devido a uma viola��o na integridade dos dados"
		Case 3720: ShowErrorDescription = "O provedor n�o pode ser modificado"
		Case 3721: ShowErrorDescription = "Dados longos demais para o tipo de dados apresentados"
		Case 3722: ShowErrorDescription = "A��o causou uma viola��o do esquema"
		Case 3723: ShowErrorDescription = "A express�o continha sinais n�o coincidentes"
		Case 3724: ShowErrorDescription = "O valor n�o pode ser convertido"
		Case 3725: ShowErrorDescription = "O recurso n�o pode ser criado"
		Case 3726: ShowErrorDescription = "A coluna especificada n�o existe nesta fileira"
		Case 3727: ShowErrorDescription = "O URL n�o existe"
		Case 3728: ShowErrorDescription = "Voc� n�o tem permiss�o para ver a �rvore do diret�rio"
		Case 3729: ShowErrorDescription = "O URL apresentado � inv�lido"
		Case 3730: ShowErrorDescription = "Recurso travado"
		Case 3731: ShowErrorDescription = "Recurso j� existente"
		Case 3732: ShowErrorDescription = "A a��o n�o pode ser conclu�da"
		Case 3733: ShowErrorDescription = "O volume de arquivo n�o foi encontrado"
		Case 3734: ShowErrorDescription = "Falha na opera��o porque o servidor n�o pode obter espa�o suficiente para completar a opera��o"
		Case 3735: ShowErrorDescription = "Recurso fora de �mbito"
		Case 3736: ShowErrorDescription = "Comando n�o est� dispon�vel"
		Case 3737: ShowErrorDescription = "O URL na fileira identificada n�o existe"
		Case 3738: ShowErrorDescription = "O recurso n�o pode ser deletado porque est� fora do escopo permitido"
		Case 3739: ShowErrorDescription = "Esta propriedade � inv�lida para a coluna selecionada"
		Case 3740: ShowErrorDescription = "Voc� apresentou uma op��o inv�lida para esta propriedade"
		Case 3741: ShowErrorDescription = "Voc� apresentou um valor inv�lido para esta propriedade"
		Case 3742: ShowErrorDescription = "A defini��o desta propriedade causou um conflito com outras propriedades"
		Case 3743: ShowErrorDescription = "Nem todas as propriedades podem ser definidas"
		Case 3744: ShowErrorDescription = "A propriedade n�o foi definida"
		Case 3745: ShowErrorDescription = "A propriedade n�o pode ser definida"
		Case 3746: ShowErrorDescription = "A propriedade n�o tem suporte"
		Case 3747: ShowErrorDescription = "A a��o n�o pode ser conclu�da porque o cat�logo n�o est� definido"
		Case 3748: ShowErrorDescription = "A conex�o n�o pode ser alterada"
		Case 3749: ShowErrorDescription = "O m�todo Update da cole��o Fields falhou"
		Case 3750: ShowErrorDescription = "N�o � poss�vel definir permiss�o Deny porque o provedor n�o oferece suporte para tanto"
		Case 3751: ShowErrorDescription = "o provedor n�o oferece suporte ao tipo de pedido"
		Case 3751: ShowErrorDescription = "o provedor n�o oferece suporte ao tipo de pedido"
 		Case else: ShowErrorDescription = "ERRO:" & pr_errnum & " - "& pr_errdesc
    End Select
End Function

'---------------------------------------------
' Retira as tags HTML da string
'---------------------------------------------
Function stripHTML(strHTML)

	Dim objRegExp, strOutput
	Set objRegExp = New Regexp

	objRegExp.IgnoreCase = True
	objRegExp.Global = True
	objRegExp.Pattern = "<(.|\n)+?>"

	'Substitui todas as tags HTML encontradas com uma string em branco
	strOutput = objRegExp.Replace(strHTML, "")
  
	'Substitui todos < e > com &lt; e &gt;
	strOutput = Replace(strOutput, "<", "&lt;")
	strOutput = Replace(strOutput, ">", "&gt;")
  
	stripHTML = strOutput    'Retorna o valor de strOutput

	Set objRegExp = Nothing
End Function

' ------------------------------------------------------------------------
' Faz o DECODE de uma string que estiver Encoded:
' exemplo: aux = "http%3A%2F%2Fwww%2Eissi%2Enet "
'          URLDecode(Aux)
'          => aux ser� igual a "http://www.issi.net"
'-------------------------------------------------------------- by Aless -
Function URLDecode(S3Decode)
Dim S3Temp(1,1)
Dim S3In, S3Out, S3Pos, S3Len, S3i

 S3In  = S3Decode
 S3Out = ""
 S3In  = Replace(S3In, "+", " ")
 S3Pos = Instr(S3In, "%")
 Do While S3Pos
	S3Len = Len(S3In)
	If S3Pos > 1 Then S3Out = S3Out & Left(S3In, S3Pos - 1)
	S3Temp(0,0) = Mid(S3In, S3Pos + 1, 1)
	S3Temp(1,0) = Mid(S3In, S3Pos + 2, 1)
	For S3i = 0 to 1
		If Asc(S3Temp(S3i,0)) > 47 And Asc(S3Temp(S3i, 0)) < 58 Then
			S3Temp(S3i, 1) = Asc(S3Temp(S3i, 0)) - 48
		Else
			S3Temp(S3i, 1) = Asc(S3Temp(S3i, 0)) - 55
		End If
	Next
	S3Out = S3Out & Chr((S3Temp(0,1) * 16) + S3Temp(1,1))
	S3In  = Right(S3In, (S3Len - (S3Pos + 2)))
	S3Pos = Instr(S3In, "%")
 Loop
 URLDecode = S3Out & S3In
End Function

Public Function GetHorario(pr_SQL)
  Dim objRS_local, objConn_local
  Dim Acumul
  
  AbreDBConn objConn_local, CFG_DB_CSM 
  set objRS_local = objConn_local.execute(pr_SQL)	

  If not objRS_local.EOF Then
        Acumul = Acumul & objRS_local.fields(4)& "|" & objRS_local.fields(5)& "|" & objRS_local.fields(6)& "|" & objRS_local.fields(7)& "|" & objRS_local.fields(8)& "|" & objRS_local.fields(9)
       objRS_local.MoveNext
     Do While not objRS_local.EOF
        Acumul = Acumul & "|" & objRS_local.fields(4)& "|" & objRS_local.fields(5)& "|" & objRS_local.fields(6)& "|" & objRS_local.fields(7)& "|" & objRS_local.fields(8)& "|" & objRS_local.fields(9)
        objRS_local.MoveNext
     Loop
  End If

  GetHorario = Acumul
  FechaRecordSet objRS_local
  FechaDBConn objConn_local

End Function

Public Function GetCampo(pr_SQL, pr_campo)
  Dim objRS_local, objConn_local
  Dim Acc
 
  AbreDBConn objConn_local, CFG_DB_CSM 

  set objRS_local = objConn_local.execute(pr_SQL)	

	If not objRS_local.EOF then
		Acc = Acc & objRS_local(pr_Campo)
		objRS_local.MoveNext
		While not objRS_local.EOF 
			Acc = Acc & "|" & objRS_local(pr_Campo)
			objRS_local.MoveNext
		Wend
	End If
	GetCampo = Acc
  FechaRecordSet objRS_local
  FechaDBConn objConn_local

End Function

Function DiaDaSemana(strDia,strMes,strAno)

    If IsDate(strMes & "/" & strDia & "/" & strAno) Then
'        Select Case Weekday(strMes & "/" & strDia & "/" & strAno)
        Select Case Weekday(strDia & "/" & strMes  & "/" & strAno)
        Case 1 DiaDaSemana = "DOM"
        Case 2 DiaDaSemana = "SEG"
        Case 3 DiaDaSemana = "TER"
        Case 4 DiaDaSemana = "QUA"
        Case 5 DiaDaSemana = "QUI"
        Case 6 DiaDaSemana = "SEX"
        Case 7 DiaDaSemana = "SAB"
        End Select
    Else
        DiaDaSemana = "Data Inv�lida!"
    End If
End Function

Public Function GetItemTempo(pr_SQL, pr_campo)
  Dim objRS_local, objConn_local
  Dim Acc
 
  AbreDBConn objConn_local, CFG_DB_SITE 

  set objRS_local = objConn_local.execute(pr_SQL)	

	If not objRS_local.EOF then
		if isNull(objRS_local(pr_Campo)) then
			GetItemTempo = "::"	
		else
			GetItemTempo = objRS_local(pr_Campo)
		end if
	End If

  FechaRecordSet objRS_local
  FechaDBConn objConn_local

End Function

Function TSec(strTime)
	Dim strHH, strMM, strSS
	Dim vTime
	Dim Rst
'	response.write("|" & strTime & "|<br>")
'	response.end
	if strTime = "::" then
		TSec = 0 
		Exit Function
	end if
	if len(strTime) > 0 then
		vTime = split(strTime,":",-1,1)
		
		If UBound(vTime) > 0 Then
			strHH = vTime(0)
			strMM = vTime(1)
			'strSS = vTime(2)
		Else
			TSec = 0 
			Exit Function
		End If
	end if

	if isnumeric(strHH) then
		strHH = cint(strHH) * 3600
	else
		strHH = 0
		TSec = 0
	end if
	if isnumeric(strMM) then
		strMM = cint(strMM) * 60
	else
		strMM = 0
		TSec = 0
	end if
	if isnumeric(strSS) then
		strSS = cint(strSS)
	else
		strSS = 0
		TSec = 0
	end if
	Rst = (strHH) + (strMM) + (strSS)
	TSec = Rst
End Function

Function THour(strSS)
	Dim Rst
	Dim nHH
	Dim nMM, nMM2
	Dim nSS, nSS2
	
	If IsNumeric(strSS) Then
		nSS = strSS mod 60
		if nSS <> 0 then strSS = strSS - nSS
		if len(nSS) = 1 then nSS = "0" & nSS
		
		nMM = strSS mod 3600
		if nMM <> 0 then
			strSS = strSS - nMM	
			nMM = nMM / 60
			if len(nMM) = 1 then
				nMM = "0" & nMM
			end if		
		else
			nMM = "00"
		end if
		
		nHH = strSS
		if nHH <> 0 then
			nHH = nHH / 3600
			if len(nHH) = 1 then
				nHH = "0" & nHH
			end if
		else
			nHH = "00"
		end if
		THour = nHH & ":" & nMM & ":" & nSS
	Else
		THour = ""
	End If
End Function

Function IsHora(strTempo)

'	response.write(strTempo & "<br>")
	Dim strAux

	if len(strTempo) = 0 then
		IsHora = False
		Exit Function	
	end if
	strAux = split(strTempo,":",-1,1)
	if len(strAux(0)) = 0 and len(strAux(1)) = 0 and len(strAux(2)) = 0 then
		IsHora = True
		Exit Function
	end if
	if isnumeric(strAux(0)) then
		if isnumeric(strAux(1)) then
			if isnumeric(strAux(2)) then
				if (strAux(0) >= 0 and strAux(0) <= 23) then
					if (strAux(1) >= 0 and strAux(1) <= 59) then
						if (strAux(2) >= 0 and strAux(2) <= 59) then
							IsHora = True
							Exit Function
						end if
					end if
				end if
			end if
		end if
	end if
	IsHora = False
End Function


Function Validacao(var_Campo, var_Tipo1, var_Tipo2, var_Tipo3 )
	Dim ind, i
	Dim var_ret, var_resp
	Dim vet_tempo	
	if (len(var_Tipo1) > 0) = false and (isnumeric(var_Tipo1)) = false then
		var_Tipo1 = 0
	end if

	if (len(var_Tipo2) > 0) = false and (isnumeric(var_Tipo2)) = false then
		var_Tipo2 = 0
	end if

	if (len(var_Tipo3) > 0) = false and (isnumeric(var_Tipo3)) = false then
		var_Tipo3 = 0
	end if
	var_resp = Array(false, false, false) 
	var_ret = Array(var_Tipo1, var_Tipo2, var_Tipo3)

	for ind = 0 to UBound(var_ret)
		Select Case var_ret(ind)
		Case 1 'inteiro
			if isnumeric(var_campo) or len(Trim(var_campo)) = 0 then
				Validacao = True
			else
				Validacao = False
			end if
		Case 2 'somente letra
			Validacao = True	
			for i = 1 to len(var_campo)
				if isnumeric(Mid(var_campo, i, 1)) then
					Validacao = False
				end if			
			next
		Case 3 'date
			if isdate(var_campo) or len(Trim(var_campo)) = 0 then
				Validacao = True
			else
				Validacao = False
			end if
		Case 4 'tempo
			vet_tempo = split(var_campo,":",-1,1)
			if UBound(vet_tempo) <> 2 then
				Validacao = False
			else
				if isnumeric(vet_tempo(0)) and isnumeric(vet_tempo(1)) and isnumeric(vet_tempo(2)) then
					if (vet_tempo(0) >= 0) and _
					   (vet_tempo(1) >= 0 and vet_tempo(1) < 60) and _
					   (vet_tempo(2) >= 0 and vet_tempo(2) < 60) then
						Validacao = True
					else
							Validacao = False
					end if
				else
						if len(vet_tempo(0)) = 0 and _
						   len(vet_tempo(1)) = 0 and _
						   len(vet_tempo(2)) = 0 Then
							Validacao = True
						else	
							Validacao = False
						end if
				end if
			end if
		Case 5 'obrigat�rio
			if len(Trim(var_campo)) > 0 then
				Validacao = True	
			else
				Validacao = False
			end if
		Case 0
			Validacao = True
		End Select
		var_resp(ind) = Validacao
	next
	if var_resp(0) and var_resp(1) and var_resp(2) then
		Validacao = true
	else
		Validacao = false	
	end if

End Function 


Function GetCampoTime(strVal)		'verifica (Se campo for vazio retorna Null)
	if strVal =  "::00" then
		GetCampoTime = "null"
	else
		GetCampoTime = "'" & THour(TSec(strVal)) & "'"
	end if
End Function

function athBeginDialog(prWMD_WIDTH, prTitle)
 Dim auxStrBody
 auxStrBody = ""
 auxStrBody = auxStrBody & "<!-- INI: CONTAINER.DIALOG ***************************************************************** -->" & vbnewline
 auxStrBody = auxStrBody & "<table width='100%' height='100%' align='center' cellpadding='0' cellspacing='0' border='0'>" & vbnewline
 auxStrBody = auxStrBody & "<tr><td align='center' valign='middle' class='dialog_margin'>" & vbnewline 
 auxStrBody = auxStrBody & "<!-- INI: DIALOG ***************************************************************** -->" & vbnewline

 auxStrBody = auxStrBody & "<table width='" & prWMD_WIDTH & "' align='center' cellpadding='4' cellspacing='6' class='dialog_ext'>" & vbnewline
 auxStrBody = auxStrBody & "<tr height='20'>" & vbnewline
 auxStrBody = auxStrBody & "<td class='caption' id='modal_dialog_header'><span style='float:right' id='modal_img_close'></span><b>" & prTitle & "</b></td>" & vbnewline
 auxStrBody = auxStrBody & "</tr>" & vbnewline
 auxStrBody = auxStrBody & "<tr>" & vbnewline
 auxStrBody = auxStrBody & "<td class='dialog_int' id='modal_dialog_body'>" & vbnewline
 auxStrBody = auxStrBody & "<table cellspacing='0' cellpading='0' height='100%' style='display:inherit;'><tr><td>" & vbnewline
 auxStrBody = auxStrBody & "<!-- INI: FORMUL�RIO ********************************** -->" & vbnewline
 athBeginDialog = auxStrBody
end function

function athEndDialog(prAVISO, ImgBt1, LnkBt1, ImgBt2, LnkBt2, ImgBt3, LnkBt3)
 Dim auxStrBody, auxStrIco
 auxStrBody = ""
 auxStrBody = auxStrBody & "<!-- FIM: FORMUL�RIO ********************************** -->" & vbnewline
 auxStrBody = auxStrBody & "</td></tr></table></td>" & vbnewline
 auxStrBody = auxStrBody & "</tr>" & vbnewline
 auxStrBody = auxStrBody & "<tr>" & vbnewline
 auxStrBody = auxStrBody & "<td class='dialog_ext_buts' id='modal_dialog_footer'>" & vbnewline
 auxStrBody = auxStrBody & "<table width='100%' height='100%' cellpadding='0' cellspacing='0' border='0'  >" & vbnewline
 auxStrBody = auxStrBody & "<tr>" & vbnewline
 auxStrBody = auxStrBody & "<td style='text-align:right;' width='51%'>" & vbnewline
 auxStrBody = auxStrBody & "<table cellspacing='0' cellpadding='0' width='100%' border='0'><tr>" & vbnewline
 if prAVISO<>"" then
   'Provis�rio... s� aceita gifs e a marca��o na string esta fraca - por '.gif:'
   'o aviso deve fir neste formato: "dlg_warning.gif:voc�s esta prestes a deletar..."
   auxStrIco = ""
   if instr(prAVISO,".gif:")>0 then auxStrIco = mid(prAVISO,1,instr(prAVISO,".gif:")+4)
   if auxStrIco<>"" then auxStrBody = auxStrBody & "<td width='15%' style='text-align:right;padding-right:4px;'><img src='../img/" & replace(auxStrIco,":","") & "' style='padding-right:4px;'></td>" & vbnewline 

   auxStrBody = auxStrBody & "<td width='85%' style='text-align:left;'>" & replace(prAVISO,auxStrIco,"") & "</td>" & vbnewline
 end if
 
 'if prAVISO<>"" then
   'Provis�rio... s� aceita gifs e a marca��o na string esta fraca - por '.gif:'
   'o aviso deve fir neste formato: "dlg_warning.gif:voc�s esta prestes a deletar..."
 '  auxStrIco = ""
 '  if instr(prAVISO,".gif:")>0 then auxStrIco = mid(prAVISO,1,instr(prAVISO,".gif:")+4)
 '  if auxStrIco<>"" then auxStrBody = auxStrBody & "<div style='padding-left:5px; border:1px solid black; display:inline; float:left;'><img src='../img/" & replace(auxStrIco,":","") & "' style='padding-right:4px;'></div>" & vbnewline 

 '   auxStrBody = auxStrBody & "<div style='padding-left:5px;border:1px solid black;'>" & replace(prAVISO,auxStrIco,"") & "</div>" & vbnewline
 'end if
 
 auxStrBody = auxStrBody & "</tr></table>"
 auxStrBody = auxStrBody & "</td>" & vbnewline
 auxStrBody = auxStrBody & "<td width='49%' style='text-align:right; vertical-align:top;'>" & vbnewline
 if ImgBt1<>"" then auxStrBody = auxStrBody & "<img style='cursor:pointer;' src='" & ImgBt1 & "' hspace='3' border='0' onClick=""" & LnkBt1 & """>" & vbnewline
 if ImgBt2<>"" then auxStrBody = auxStrBody & "<img style='cursor:pointer;' src='" & ImgBt2 & "' hspace='3' border='0' onClick=""" & LnkBt2 & """>" & vbnewline
 if ImgBt3<>"" then auxStrBody = auxStrBody & "<img style='cursor:pointer;' src='" & ImgBt3 & "' hspace='3' border='0' onClick=""" & LnkBt3 & """>" & vbnewline
 auxStrBody = auxStrBody & "</td>" & vbnewline
 auxStrBody = auxStrBody & "</tr>" & vbnewline
 auxStrBody = auxStrBody & "</table>" & vbnewline
 auxStrBody = auxStrBody & "</td>" & vbnewline
 auxStrBody = auxStrBody & "</tr>" & vbnewline
 auxStrBody = auxStrBody & "</table>" & vbnewline
 auxStrBody = auxStrBody & "<!-- FIM: DIALOG ***************************************************************** -->" & vbnewline

 auxStrBody = auxStrBody & "    </td></tr>"  & vbnewline
 auxStrBody = auxStrBody & " </table>"  & vbnewline
 auxStrBody = auxStrBody & "<!-- FIM: CONTAINER.DIALOG ***************************************************************** -->" & vbnewline
 athEndDialog = auxStrBody
end function


'****************************************************************************************************'
' 					CONJUNTO DE FUN��ES PARA MENU CSS OVER TABLESORT - IN�CIO                        '
'****************************************************************************************************'
' Atualiza��es:
' 27/04/2010 - Conjunto de fun��es adaptadas para criar a chamada dos links de modo compat�vel com a
' constante CFG_DIALOG_DETAIL. � importante que a cria��o do ITEM possua o mesmo par�metro IDDIVEXEC
' que o informado no fechamento do menu CSS. A ID informada no item referencia a execu��o do link na
' div informado, deste que a CFG_DIALOG_DETAIL seja 'INCLUDE' ou 'MODAL', os dois tipos gerados em a-
' jax. O par�metro informado no fechamento do menu � o id que a div possuir�, e essa div ser� gerada
' com estilo default conforme o que estiver setado em CFG_DIALOG_DETAIL.
'
' Exemplo de montagem de MENU CSS:
' - MODAL: No arquivo athdbConn, a constante CFG_DIALOG_DETAIL deve estar setado como "MODAL"
' 	athBeginCssMenu()
'		athCssMenuAddItem "", "_self", "RESPOSTAS", "", 1
'		athBeginCssSubMenu()
'			athCssMenuAddItem "InsertResposta.asp", "_self", "Inserir Resposta", "div_modal", 0
' 		athEndCssSubMenu()
' 	athEndCssMenu("div_modal")
'
' - INCLUDE: No arquivo athdbConn, a constante CFG_DIALOG_DETAIL deve estar setado como "INCLUDE"
' 	athBeginCssMenu()
'		athCssMenuAddItem "", "_self", "RESPOSTAS", "", 1
'		athBeginCssSubMenu()
'			athCssMenuAddItem "InsertResposta.asp", "_self", "Inserir Resposta", "div_include", 0
' 		athEndCssSubMenu()
' 	athEndCssMenu("div_include")
'
' - NORMAL: No arquivo athdbConn, a constante CFG_DIALOG_DETAIL deve estar setado como "NORMAL"
' 	athBeginCssMenu()
'		athCssMenuAddItem "", "_self", "RESPOSTAS", "", 1
'		athBeginCssSubMenu()
'			athCssMenuAddItem "InsertResposta.asp", "_self", "Inserir Resposta", "", 0
' 		athEndCssSubMenu()
' 	athEndCssMenu("")
'
'****************************************************************************************************'
'****************************************************************************************************'
function athBeginCssMenu()
	' Descri��o: Esta fun��o inicializa o menu CSS, � 
	' extremamente importante necess�rio efetuar o fe-
	' chamento do menu com a fun��o athEndCssMenu("div_id").
	Response.Write(vbnewline & "<table cellpadding=""0"" cellspacing=""0"" style=""width:100%;"" class=""menu_css"" border=""0"">")
	Response.Write(vbnewline & "<tr>")
	Response.Write(vbnewline & "<td style=""text-align:left;border:none;padding:0px;"">")
	Response.Write(vbnewline & "<div class=""cssMenuDiv""><ul class=""cssMenu cssMenum"">")
end function


function athBeginCssSubMenu()
	' Descri��o: Esta fun��o inicializa um submenu CSS
	' utilizada ap�s a cria��o de um item, gerando um
	' submenu.
	Response.Write(vbnewline & "<ul class=""cssMenum"">")
end function


function athCssMenuAddItem(prLink,prJS,prTarget,prTitle,prIDDivExec,prNextIsSub)
	' Descri��o: Esta fun��o inicializa o item do menu CSS
	' o pen�ltimo par�metro � o ID da DIV onde o link ser� 
	' carregado, desde que a CFG_DIALOG_DETAIL esteja confi-
	' gurada como "MODAL" ou "INCLUDE".
	Dim strConstDialog, strLink, strJS
	
	'Coletando CFG PARA Teste
	strConstDialog = CFG_DIALOG_DETAIL
	strJS   	   = prJS
	
	'Tratamento contra envio inesperados ou vazios nos par�metros
	if((strConstDialog = null) or ((strConstDialog <> "MODAL") and (strConstDialog <> "INCLUDE") and (strConstDialog <> "NORMAL")) or (prLink = null) or (prLink = "") or (prLink = "#"))then
		strLink = "#"
	end if
	
	'Monta DIALOG MODAL
	if((strConstDialog = "MODAL") and (prLink <> "#" and prLink <> ""))then
		strLink = "#"" onClick=""ajaxLoadModalPAGE('" & prLink & "','" & prIDDivExec & "',1);"
	end if
	
	'Monta DIALOG INTERNA
	if((strConstDialog = "INCLUDE") and (prLink <> "#" and prLink <> ""))then
		strLink = "#"" onClick=""ajaxLoadModalPAGE('" & prLink & "','" & prIDDivExec & "');"
	end if
	
	'Monta DIALOG TIPO NORMAL, EXTERNA
	if((strConstDialog = "NORMAL") and (prLink <> ""))then
		strLink = prLink
	end if
	
	'Inicializa a linha do item	
	Response.Write(vbnewline & "<li class=""cssMenui""><a class=""cssMenui"" href=""" & strLink & """ target=""" & prTarget & """ " & strJS & ">")
	
	'Monta algumas modifica��es caso o par�metro prNextIsSub for igual a 1
	if(prNextIsSub  = 1)then Response.Write("<span>")  end if
	Response.Write("&nbsp;" & prTitle & "&nbsp;")
	if(prNextIsSub  = 1)then Response.Write("</span>") end if
	if(prNextIsSub  = 1)then Response.Write("<![if gt IE 6]></a><![endif]>") else Response.Write("</a>") end if
	if(prNextIsSub <> 1)then Response.Write("</li>") end if
end function


function athEndCssSubMenu()
	' Descri��o: Esta fun��o FINALIZA um submenu CSS
	' � importante a chamada dela quando � feita a
	' abertura, para preven��o de erros de html em
	' browsers.
	Response.Write(vbnewline & "</ul></li>")
end function


function athEndCssMenu(prIDDivExec)
	' Descri��o: Esta fun��o Finaliza um menu CSS.
	' como em sua constru��o est� o fechamento da div
	' superior, ent�o � poss�vel que a chamada construa
	' uma div contendo o id enviado por par�metro. Esse
	' ID, por indica��o, deve ser o mesmo ID informado
	' na cria��o do item.
	Dim strConstDialog
	
	Response.Write(vbnewline & "</ul></div>")
	Response.Write(vbnewline & "</td></tr></table>")
	
	'Coletando CFG_DIALOG_DETAIL
	strConstDialog = CFG_DIALOG_DETAIL
	
	'Tratamento contra ID VAZIO
	if(prIDDivExec = "") then prIDDivExec = "#" end if
	if(strConstDialog = "INCLUDE")then
		Response.Write(vbnewline & "<div id=""" & prIDDivExec & """ style=""display:none;width:auto;margin-bottom:20px;padding:10px;""></div>")
	end if
	if(strConstDialog = "MODAL"  )then
		Response.Write(vbnewline & "<div id=""" & prIDDivExec & """ style=""display:none;width:auto;position:absolute;top:30%;left:50%;margin-top:-6%;margin-left:-35%;margin-bottom:20px;padding:10px;""></div>")
	end if
end function
'****************************************************************************************************'
' 					   CONJUNTO DE FUN��ES PARA MENU CSS OVER TABLESORT - FIM                        '
'****************************************************************************************************'



'Menu pureCSS over TABLESORT
'function athBeginCssMenu()
'	Response.Write(vbnewline & "<table cellpadding=""0"" cellspacing=""0"" style=""width:100%;"" class=""menu_css"" border=""0"">")
'	Response.Write(vbnewline & "<tr>")
'	Response.Write(vbnewline & "<td style=""text-align:left;border:none;padding:0px;"">")
'	Response.Write(vbnewline & "<div class=""cssMenuDiv""><ul class=""cssMenu cssMenum"">")
'end function

'function athBeginCssSubMenu()
'	Response.Write(vbnewline & "<ul class=""cssMenum"">")
'end function

'function athCssMenuAddItem(prLink,prTarget,prTitle,prNextIsSub)
'	Dim strLink, strTarget, strTitle, intNextIsSub
'	strLink   	 = prLink
'	strTarget 	 = prTarget
'	strTitle  	 = prTitle
'	intNextIsSub = prNextIsSub
'	
'	if(strLink = "")then
'		strLink = "#"
'	end if
'		
'	Response.Write(vbnewline & "<li class=""cssMenui""><a class=""cssMenui"" href=""" & strLink & """ target=""" & strTarget & """>")
'	if(intNextIsSub = 1)then
'		Response.Write("<span>")
'	end if
'	Response.Write("&nbsp;" & strTitle & "&nbsp;")
'	if(intNextIsSub = 1)then
'		Response.Write("</span>")
'	end if
'	if(intNextIsSub = 1)then
'		Response.Write("<![if gt IE 6]></a><![endif]>")
'	else
'		Response.Write("</a>")
'	end if
'	if(intNextIsSub <> 1)then
'		Response.Write("</li>")
'	end if
'end function

'function athEndCssSubMenu()
'	Response.Write(vbnewline & "</ul></li>")
'end function

'function athEndCssMenu()
'	Response.Write(vbnewline & "</ul></div>")
'	
'	Response.Write(vbnewline & "</td></tr></table>")
'end function

function FormataHoraNumToHHMM(prHORAS)
Dim auxH, auxPFrac
 auxH = prHORAS
 if isNumeric(auxH) then 
   auxPFrac = auxH-FIX(auxH)
   if (auxPFrac > 0) then 
     auxH = FIX(auxH) & ":" & FIX(auxPFrac*60) 
    else
     auxH = auxH & ":00"
   end if
   if ( (auxH=":00") or (auxH="0:00") ) then auxH =""
 end if
 FormataHoraNumToHHMM = auxH
end function

'-----------------------------------------------------------------------------
'	Cria o combo com a partir do per�odo recebido.
'-----------------------------------------------------------------------------
function montaComboAno(pr_periodo)
Dim strOPTION, strPERIODO
Dim strDE, strATE, i
	strPERIODO = Cint(pr_periodo)
	if (Cint(strPERIODO) >= 0) then
	    ' Se o pr�odo digitado for Maior que zero ent�o os anos gerados 
		' s�o balanceados em rela��o ao ano atual (para mais e para menos)
		strDE  = Year(Date) - CInt(strPERIODO/2)
		strATE = Year(Date) + CInt(strPERIODO/2)
		if (strPERIODO mod 2) = 0 then strATE = strATE - 1
	else
	    ' Se o pr�odo digitado for MENOR que ZERO ent�o os anos gerados 
		' s�o inferiors ao atual inclusive
		strDE  = Year(Date) - Abs(strPERIODO)
		strATE = Year(Date)
	end if	

	for i=strDE to strATE
		strOPTION = "<option value='" & i & "' "		
		if i = Year(Date) then strOPTION = strOPTION & "selected"
		strOPTION = strOPTION & ">" & i & "</option>"
		Response.Write(strOPTION)
	next
end function

'-----------------------------------------------------------------------------
'	Cria o combo com meses. (pr_selected - mes selecionado 1..12 ou null)
'-----------------------------------------------------------------------------
function montaComboMes(pr_selected)
Dim strOPTION, i, strValue, strMes
	
	strMes = ""
	
	if (pr_selected <> "" and IsNumeric(pr_selected)) then strMes = pr_selected
	if len(strMes) = 1 then	strMes = "0" & strMes
	
	for i=1 to 12
		if i<10 then strOPTION = "<option value='0" & i & "'" else strOPTION = "<option value='" & i & "'" end if
		if CInt(strMes) = CInt(i) then strOPTION = strOPTION & " selected"		
		strOPTION = strOPTION & ">" & mid(MesExtenso(i),1,3) & "</option>"
		Response.Write(strOPTION)
	next
end function

'-----------------------------------------------------------------------------
'	Retorna o �ltimo dia do m�s informado
'	pr_ano/pr_mes = null (retorna baseado no ano/mes corrente)	
'	pr_return = true (retorna data dd/mm/aaaa como string)
'	pr_return = false (retorna somente o dia)
'-----------------------------------------------------------------------------
function UltimoDiaMes(pr_mes, pr_ano, pr_return)
Dim mes, meses30d, ano, ult_dia
	ano = pr_ano
	mes = pr_mes	
	meses30d = "04;06;09;11;" 
	ult_dia=31
	
	if IsNull(ano) then ano = year(Date)
	if IsNull(mes) then mes = month(Date)
	if Len(mes)<2 	then mes = "0" & mes
		
	if InStr(meses30d,mes)>0 then ult_dia=30
	
	if mes=2 then
		ult_dia=28
		if (pr_ano mod 4)=0 and (pr_ano mod 100)<>0 or (pr_ano mod 400)=0 then ult_dia=29
	end if
	
	UltimoDiaMes = ult_dia
	if (pr_return) then UltimoDiaMes = ult_dia & "/" & mes & "/" & ano
end function

function GerarSenha(maxnum, par1)
Dim var_valores, xArray, chave, num
	
	If par1 = 1 Then var_valores = "0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"
	If par1 = 2 Then var_valores = "0,1,2,3,4,5,6,7,8,9"
	If par1 = 3 Then var_valores = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"
	
	xArray = Split(var_valores,",")
	Randomize()
	
	Do While Len(chave) < maxnum
		num = xArray(Int(Ubound(xArray) * Rnd() ))
		chave = chave + num 
	Loop
	GerarSenha = Trim(chave)
End Function

function InsertTagSQL(prParam)
Dim strParam_SQL
 strParam_SQL = Replace(prParam,"%","<ASLW_PERCENT>")
 strParam_SQL = Replace(strParam_SQL,"#","<ASLW_SHARP>")
 strParam_SQL = Replace(strParam_SQL,"'","<ASLW_APOSTROFE>")
 strParam_SQL = Replace(strParam_SQL,"""","<ASLW_ASPAS>")
 strParam_SQL = Replace(strParam_SQL,"@","<ASLW_ARROBA>")
 strParam_SQL = Replace(strParam_SQL,"?","<ASLW_INTERROGACAO>")
 strParam_SQL = Replace(strParam_SQL,"&","<ASLW_ECOMERCIAL>")
 strParam_SQL = Replace(strParam_SQL,":","<ASLW_DOISPONTOS>")
InsertTagSQL = strParam_SQL
end function

function RemoveTagSQL(prParam)
Dim strParam_SQL
 strParam_SQL = Replace(prParam,"<ASLW_PERCENT>","%",1,-1,1)
 strParam_SQL = Replace(strParam_SQL,"<ASLW_SHARP>","#",1,-1,1)
 strParam_SQL = Replace(strParam_SQL,"<ASLW_APOSTROFE>","'",1,-1,1)
 strParam_SQL = Replace(strParam_SQL,"<ASLW_ASPAS>","""",1,-1,1)
 strParam_SQL = Replace(strParam_SQL,"<ASLW_ARROBA>","@",1,-1,1)
 strParam_SQL = Replace(strParam_SQL,"<ASLW_INTERROGACAO>","?",1,-1,1)
 strParam_SQL = Replace(strParam_SQL,"<ASLW_ECOMERCIAL>","&",1,-1,1)
 strParam_SQL = Replace(strParam_SQL,"<ASLW_DOISPONTOS>",":",1,-1,1)
RemoveTagSQL = strParam_SQL
end function

'-----------------------------------------------------------------------
' Fun��o que converte um valor digitado pelo usu�rio para float/double
' Existe uma correspondente em JavaScript em /_scripts/scripts.js
'
' exemplos: 
' a)   123,87   ->  123.87
' b) 1.445,9    -> 1445.9
' c)   206      ->  206.00
' d)   122,8966 ->  122.8966
'------------------------------------------------------------------------
Function MoedaToFloat(prValor)
	Dim Moeda, arrMoeda, Valor, i
	
	Valor = ""
	If prValor <> "" Then
		Moeda = prValor
		
		Moeda = Replace(Moeda, ",", ".")
		if (InStr(Moeda, ".")>0) then
			arrMoeda = Split(Moeda, ".")
			
			i = 0
			do while (i<UBound(arrMoeda))
				Valor = Valor & arrMoeda(i)	
				i = i + 1
			loop
			Valor = Valor & "." & arrMoeda(UBound(arrMoeda))	
		else
			Valor = Moeda & ".00"
		end if
	End If
	
	MoedaToFloat = Valor
End Function

'------------------------------------------------------------------------------------------
' Insere no HTML um INPUT para DATA j� com "m�scara" de formata��o para datas
' InputDate("var_alguma_coisa", "edit_css", "24/07/2007", true/false)
' Requer Scripts.js inclu�do na p�gina que chama a fun��o
'------------------------------------------------------------------------------------------
function InputDate(prName, prClass, prValue, prReadOnly)
Dim strInput, strDate
	strDate = ""
	if prValue<>"" then	strDate = PrepData(prValue,true,false)

	strInput = "<input name='" & prName & "' id='" & prName & "'"
	if prClass<>"" then strInput = strInput & " class='" & prClass & "'" end if
	strInput = strInput & " value='" & strDate & "'" 	
	strInput = strInput & " type='text' maxlength='10' style='width:70px;'"
	strInput = strInput & " onKeyPress='Javascript:validateNumKey();'"	
	strInput = strInput & " onKeyUp='Javascript:FormataInputData(this.form.name, this.name);'"
	
	if prReadOnly then strInput = strInput &  " readonly"

	strInput = strInput & ">"
		
	InputDate = strInput
end function
'------------------------------------------------------------------------------------------
'Capitalize (s� serve para 1 palavra)
'------------------------------------------------------------------------------------------
function Cap(prWord)
Dim strAux
	strAux	= UCase(Mid(prWord,1,1)) & LCase(Mid(prWord,2))
	Cap		= strAux
end function

'--------------------------------------------------------------------------------
' Formata uma DATA (dd/mm/aaaa) para foirmato universal (aaaa/mm/dd) para o MySQL
' Nova vers�o apra trabalahr com MYSQL -
' UPDATE "2009-12-05"                2009-12-05 00:00:00
' UPDATE "2009-12-05 00:00"          2009-12-05 00:00:00
' UPDATE "09-12-05"                  2009-12-05 00:00:00
' UPDATE "09-12-05 00:00"            2009-12-05 00:00:00
' ** MYSQL s� grava datas com string
'--------------------------------------------------------------- Aless & Madison --
Public Function PrepDataBrToUni(DateToConvert, DataHora)

   ' Declara��o para vari�veis para dois m�todos
   Dim strDia
   Dim strMes
   Dim strAno
   Dim strHora
   Dim strMinuto
   Dim strSegundo

	If isDate(DateToConvert) Then
    	strDia     = Day(DateToConvert)
    	If strDia < 10 Then
       		strDia = "0" & strDia
     	End If
     	strMes     = Month(DateToConvert)
     	If strMes < 10 Then
       		strMes = "0" & strMes
     	End If   
     	strAno     = Year(DateToConvert)
     	strHora    = Hour(DateToConvert)
     	If strHora < 10 Then
       		strHora = "0" & strHora
     	End If
     	strMinuto  = Minute(DateToConvert)
     	If strMinuto < 10 Then
       		strMinuto = "0" & strMinuto
     	End If
     	strSegundo = Second(DateToConvert)
     	If strSegundo < 10 Then
       		strSegundo = "0" & strSegundo
     	End If

       	PrepDataBrToUni = strAno & "-" & strMes & "-" & strDia


     	If DataHora Then
       		PrepDataBrToUni = PrepDataBrToUni & " " & strHora & ":" & strMinuto & ":" & strSegundo
     	End If
	Else
    	PrepDataBrToUni = ""
	End If

End Function

Function ShowLinkCalendario(prForm, prCampo, prHint)
	ShowLinkCalendario = "<a href='javascript:void(0)' " &_
						 "onClick=""if(self.gfPop)gfPop.fPopCalendar(document." & prForm & "." & prCampo & ");return false;"">" &_
						 "<img class='PopcalTrigger' src='../img/bullet_dataatual.gif' " &_
						 "border='0' style='cursor:hand; vertical-align:top; padding-top:2px;' vspace='0' hspace='0' alt='" & prHint & "' title='" & prHint & "'>" &_
						 "</a>"
End Function


function montaMenuCombo(prForm, prSelName, prStyle, prJScript, prOptions)
   Dim auxStr, auxItem, arrOP, arrOPs
   auxStr = "<div style='padding-top:5px;'>" & vbnewline
   auxStr = auxStr & "<form name='" & prForm & "' method='post' action=''>" & vbnewline
   auxStr = auxStr & "<select name='" & prSelName & "' style='border:1px dashed #BDC6D6; background-color:#EDF2F6; " & prStyle & "' onChange='" & prJScript & "'>" & vbnewline  
   auxStr = auxStr & "<option value='' selected></option>"

   arrOPs = split (prOptions, ";")
   for each auxItem in arrOPs 
     arrOP = split (trim(auxItem), ":")
	 if uBound(arrOP)>0 then auxStr = auxStr & "<option value='" & arrOP(0) & "'>" & arrOP(1)& "</option>"
   next
   auxStr = auxStr & "</select>" & vbnewline
   auxStr = auxStr & "</form>" & vbnewline
   auxStr = auxStr & "</div>" & vbnewline
   
   'athDebug auxStr, true
   montaMenuCombo = auxStr
end function

'Fun��o usada na parte financeira: main do Lctos Gerais, Livro Caixa e Balancete
Sub QuickSortLctos(ByRef vetor(), inicio, final, num_cols, iteracoes, ordenacao)
    Dim pivo
    Dim i, j, k
    iteracoes = iteracoes + 1
    If final > inicio Then
        i = inicio
        j = final
        
		If ordenacao = "DATA" Then
			pivo = vetor(DATA, Fix((inicio + final) / 2))
			
			While i <= j
				While vetor(DATA, i) < pivo
					i = i + 1
				Wend
				While pivo < vetor(DATA, j)
					j = j - 1
				Wend
				If i <= j Then
					For K = 0 To num_cols-1
						Call Troca(vetor(k, i), vetor(k, j))
					Next
					
					i = i + 1
					j = j - 1
				End If
			Wend
		End If
		
		If ordenacao = "ORDEM" Then
			pivo = vetor(ORDEM, Fix((inicio + final) / 2))
			
			While i <= j
				While vetor(ORDEM, i) < pivo
					i = i + 1
				Wend
				While pivo < vetor(ORDEM, j)
					j = j - 1
				Wend
				If i <= j Then
					For K = 0 To num_cols-1
						Call Troca(vetor(k, i), vetor(k, j))
					Next
					
					i = i + 1
					j = j - 1
				End If
			Wend
		End If
		
        Call QuickSortLctos(vetor, inicio, j, num_cols, iteracoes, ordenacao)
        Call QuickSortLctos(vetor, i, final, num_cols, iteracoes, ordenacao)
    End If
 
End Sub

'Fun��o usada pela QuickSortLctos
Sub Troca(ByRef val1, ByRef val2)
    Dim aux
    aux = val1
    val1 = val2
    val2 = aux
End Sub

'-----------------------------------------------------
'Funcao:    IsCartaoCredito(ByVal strNumeroCartao, strTipoCartao)
'Sinopse:    Verifica se o cart�o de cr�dito passado por parametro 
'            est� no formato correto e se o d�gito � correto. 
'            Formatos aceitos: 
'            Cart�o            Prefixo                    Tamanho
'             MASTERCARD         51-55                     16
'             VISA               4                         13 ou 16
'             AMEX               34 ou 37                  15
'             DINERSCLUB         300-305 ou 36 ou 38       14
'Parametro: strNumeroCartao: Numero do cart�o (somente n�mero)
'            strTipoCartao: Pode assumir os seguintes valores: 
'                           MASTERCARD, VISA, AMEX, DINERSCLUB
'Retorno: Booleano
'Autor: Gabriel Fr�es - www.codigofonte.com.br
'-----------------------------------------------------
Function IsCartaoCredito(ByVal strNumeroCartao, strTipoCartao)
    'Verificando se o valor passado � todo numerico
    If Not IsNumeric(strNumeroCartao) Then
        Retorno = False
    Else
        Retorno = True
    End If
    
    'Valor � num�rico
    If Retorno Then
        'Selecionando o prefixo do cart�o
        strTipoCartao    =    Ucase(strTipoCartao)
        Select Case strTipoCartao
            Case "MASTERCARD"
                strExpressaoRegular = "^5[1-5]\d{14}$"
            Case "VISA"
                strExpressaoRegular = "^4(\d{12}|\d{15})$"
            Case "AMEX"
                strExpressaoRegular = "^3(3|7)\d{14}$"
            Case "DINERSCLUB"
                strExpressaoRegular = "^3((6|8)\d{12})|(00|01|02|03|04|05)\d{11})$"
        End Select
            
        'Validando o formato do cart�o de cr�dito
        Set regEx = New RegExp                            ' Cria o Objeto Express�o
        regEx.Pattern = strExpressaoRegular                  ' Express�o Regular
        regEx.IgnoreCase = True                           ' Sensitivo ou n�o
        regEx.Global = True                               
        Retorno = RegEx.Test(strNumeroCartao)
        Set regEx = Nothing
        
        'Formato correto
        If Retorno Then
            '-----------------------------------------
            'Processo de valida��o do numero do cart�o    
            '-----------------------------------------
            intVerificaSoma        = 0
            blnFlagDigito        = False 
            For Cont = Len(strNumeroCartao) To 1 Step -1
                Digito = Asc(Mid(strNumeroCartao, Cont, 1))        'Isola o caracter da vez
                If (Digito > 47) And (Digito < 58) Then            'Somente se for inteiro
                    Digito = Digito - 48                        'Converte novamente para numero (-48)
                    If blnFlagDigito Then                  
                        Digito = Digito + Digito                'Primeiro duplica-o
                        If Digito > 9 Then                        'Verifica se o Digito � maior que 9
                            Digito = Digito - 9                    'For�a ser somente um n�mero
                        End If
                    End If
                    blnFlagDigito = Not blnFlagDigito      
                    intVerificaSoma = intVerificaSoma + Digito   
                    If intVerificaSoma > 9 Then                
                        intVerificaSoma = intVerificaSoma - 10   'Mesmo que MOD 10 s� que mais rapido
                    End If
                End If
            Next
            If intVerificaSoma <> 0 Then ' Deve totalizar zero
                Retorno = False
            Else
                Retorno = True
            End If
            '-----------------------------------------
        End If
    End If
    'Retornando a fun��o
    IsCartaoCredito = Retorno
End Function

Sub ReduzirImagem(pr_CAMINHO, pr_ARQUIVO, pr_ALTURA)
	Dim strCAMINHO
	Dim objJPEG
	
	strCAMINHO = Server.MapPath(pr_CAMINHO)
	
	On Error Resume Next
		Set objJPEG = Server.CreateObject("Persits.Jpeg") 
		
		objJPEG.Open strCAMINHO & "/" & pr_ARQUIVO
		If (objJPEG.OriginalHeight > pr_ALTURA) Then 
			objJPEG.Height = pr_ALTURA
			objJPEG.Width = Round((pr_ALTURA / objJPEG.OriginalHeight) * objJPEG.OriginalWidth, 0)
			
			objJPEG.Save strCAMINHO & "/" & pr_ARQUIVO
		End If
		
		Set objJPEG = Nothing 
	If err.Number <> 0 Then
		
	End If
End Sub 

function ATHMiniBiblioDeCripto(StrSrc)
 Dim i,posfromA, strLetra
 Dim arrS2()
 Redim arrS2(Len(StrSrc))

 for i=1 to Len(StrSrc)
    arrS2(i) = Mid(StrSrc,i,1)
 next	

 for i=1 to Len(StrSrc)
	  strLetra = Mid(StrSrc,i,1)
      if ( Asc(strLetra) >= Asc("A") AND Asc(strLetra) <= Asc("Z") ) then
          posfromA = Asc(strLetra) - Asc("A") 'Pega posicao em relacao a 'A'
          arrS2(i) = Chr(Asc("Z") - posfromA)
      else
        if ( (Asc(strLetra) >= Asc("a") AND Asc(strLetra) <= Asc("z")) ) then
          posfromA = Asc(strLetra) - Asc("a") 'Pega posicao em relacao a 'a'
          arrS2(i) = Chr(Asc("z") - posfromA)
		end if	
	  end if	
 next
 ATHMiniBiblioDeCripto = Join(arrS2,"")
end function


function RetValue4SQl(prDado,prRet)
 if ( (prDado="") or (isEmpty(prDado)) or (isNull(prDado)) ) then
   RetValue4SQl = prRet
 else
   RetValue4SQl = prDado
 end if
end function

'Faz o teste de express�o regular numa string (match) 
' ---------------------------------------- by Alan --
Function matchLine(prPattern, prSearch)
	Dim objRegExp
	
	Set objRegExp = New RegExp
		
	objRegExp.pattern    = prPattern
	objRegExp.ignoreCase = true
	objRegExp.global     = true
	
	matchLine = objRegExp.Test(prSearch)
End Function


'Retorna os elementos que batem com a express�o regular 
'em uma string �nica, separados pelo separador informado
' ------------------------------------------ by Aless --
Function mathLineRet(prPattern, prSearch, prSep)
	Dim objRegExp, Match, Matches, RetStr 

	Set objRegExp = New RegExp   

	objRegExp.pattern    = prPattern
	objRegExp.ignoreCase = true
	objRegExp.global     = true

	Set Matches	= objRegExp.Execute(prSearch)
	RetStr = ""
	For Each Match in Matches 
		'RetStr = RetStr & "Match position "
		'RetStr = RetStr & Match.FirstIndex & ". Match Value is '"
		'RetStr = RetStr & Match.Value & "'." & vbCRLF
		RetStr = RetStr & Match.Value & prSep
	Next
	mathLineRet = RetStr
End Function


'----------------------------------------------------------
' Remove todos caracteres especiais e acentua��o
'---------------------------------------------- by Aless --
Function getNormalString(prSTR)
    Dim strA, strB, Resultado, Cont
	
	strA = "�������������������������������������������������������������Rr ~^!@#$%�&*()=+/:;?<>,|�����������`" 
	strB = "AAAAAAACEEEEIIIIDNOOOOO0UUUUYbsaaaaaaaceeeeiiiidnoooooouuuybyRr___________________________________"  
    Cont = 0
    Resultado = prSTR
	athdebug Resultado & " - INICIO <br>", false
    Do While Cont < Len(strA)
		Cont = Cont + 1
		Resultado = Replace(Resultado, Mid(strA, Cont, 1), Mid(strB, Cont, 1))
		athdebug Resultado & "<br>", false
    Loop
    getNormalString = Resultado
End Function

'----------------------------------------------------------
' Remove apenas acentua��o e "�"
'---------------------------------------------- by Aless --
Function RemoveAcento(prSTR)
    Dim strA, strB, Resultado, Cont
	
	strA = "������������������������������������������������������"  
	strB = "AAAAAACEEEEIIIINOOOOOUUUUYaaaaaaceeeeiiiidnooooouuuyby" 
    Cont = 0
    Resultado = prSTR
    Do While Cont < Len(strA)
		Cont = Cont + 1
		Resultado = Replace(Resultado, Mid(strA, Cont, 1), Mid(strB, Cont, 1))
    Loop
    RemoveAcento = Resultado
End Function

Function ExibePROJETO(prCODIGO, prTITULO, prFASE_ATUAL, prSUFIXO)
	Dim strSAIDA
	
	strSAIDA =            "<table width='99%' height='20' bgcolor='#E9E9E9' cellpadding='2' cellspacing='0'>" & vbNewLine
	strSAIDA = strSAIDA & "	  <tr>" & vbNewLine
	strSAIDA = strSAIDA & "		<td width='16' align='center'><a href=""Javascript: ShowArea('prj_" & prCODIGO & "_" & prSUFIXO & "', 'icon_prj_" & prCODIGO & "_" & prSUFIXO & "');""><img src='../img/BulletMenos.gif' border='0' align='absmiddle' name='icon_prj_" & prCODIGO & "_" & prSUFIXO & "' id='icon_prj_" & prCODIGO & "_" & prSUFIXO & "'></a></td>" & vbNewLine
	If prCODIGO <> "" And prTITULO <> "" Then
		strSAIDA = strSAIDA & "<td>" & prTITULO & " - " & prFASE_ATUAL & "</td>" & vbNewLine
	Else
		strSAIDA = strSAIDA & "<td>PROJETO GERAL</td>" & vbNewLine
	End If
	strSAIDA = strSAIDA & "	  </tr>" & vbNewLine
	strSAIDA = strSAIDA & "</table>" & vbNewLine
	strSAIDA = strSAIDA & "<div id='prj_" & prCODIGO & "_" & prSUFIXO & "' style='padding:0px;'>" & vbNewLine
	
	ExibePROJETO = strSAIDA
End Function

Function ExibeBS(prCODIGO, prTITULO, prCOD_CLIENTE, prCLIENTE, prRESPONSAVEL, prSITUACAO, prDT_INI, prDT_FIM, prPREV_HORAS, prHORAS, prNA_EQUIPE, prSUFIXO)
	Dim strSAIDA, auxBgColor, strCOLOR, Ct
	
	auxBgColor = "#F2F2F2"
	If IsDate(prDT_FIM) Then
		if (prDT_FIM<Date) then auxBgColor = "#F9E9E9" 'vermelho
	End If

	If IsDate(prDT_INI) And IsDate(prDT_FIM) Then
		'if ((prDT_INI-Date)<2) and ((prDT_FIM-Date)>0) then auxBgColor = "#FEFFD3" 'amarelo
		if (prDT_INI=Date) then auxBgColor = "#FEFFD3" 'amarelo
	End If
	
	strSAIDA =            "<table width='99%' height='20' bgcolor='#F9F9F9' cellpadding='2' cellspacing='0' border='0'>" & vbNewLine
	strSAIDA = strSAIDA & "<tr bgcolor='" & auxBgColor & "'>" & vbNewLine
	strSAIDA = strSAIDA & " <td width='16' bgcolor='#FFFFFF'></td>"
	strSAIDA = strSAIDA & " <td width='16' align='center'><a href=""Javascript: ShowArea('ativ_" & prCODIGO & "_" & prSUFIXO & "', 'icon_ativ_" & prCODIGO & "_" & prSUFIXO & "');""><img src='../img/BulletMenos.gif' border='0' align='absmiddle' name='icon_ativ_" & prCODIGO & "_" & prSUFIXO & "' id='icon_ativ_" & prCODIGO & "_" & prSUFIXO & "'></a></td>" & vbNewLine
	
	If prCODIGO <> "" And prTITULO <> "" Then
		strSAIDA = strSAIDA & " <td width='16' valign='top' class='arial11'>"
		if strUSER_ID=LCase(prRESPONSAVEL) then
			strSAIDA = strSAIDA & "<a style='cursor:hand;' href='../modulo_BS/Update.asp?var_chavereg=" & prCODIGO & "'><img src='../img/IconAction_EDIT.gif' border='0' alt='ALTERAR' title='ALTERAR'></a>"
		else
			if prNA_EQUIPE <> "" or (InStr("MANAGER",strGRUPO_USUARIO)>0) then
				strSAIDA = strSAIDA & "<a style='cursor:hand;' href='../modulo_BS/DetailHistorico.asp?var_chavereg=" & prCODIGO & "'><img src='../img/IconAction_DETAIL.gif' border='0' alt='HIST�RICO APENAS' title='HIST�RICO APENAS'></a>"
			end if
		end if
		strSAIDA = strSAIDA & " </td>" & vbNewLine
		
		strSAIDA = strSAIDA & " <td width='16' align='center' valign='top' class='arial11'>"
		if prNA_EQUIPE <> "" then
			strSAIDA = strSAIDA & "<a style='cursor:hand;' href='../modulo_BS/DetailHistorico.asp?var_chavereg=" & prCODIGO & "&var_resposta=true'><img src='../img/IconAction_DETAILadd.gif' border='0' alt='HIST�RICO COM INSER��O' title='HIST�RICO COM INSER��O'></a>"
		end if
		strSAIDA = strSAIDA & " </td>" & vbNewLine
		
		strSAIDA = strSAIDA & " <td width='20' valign='top' class='arial11'>" & prCODIGO & "</td>" & vbNewLine
		strSAIDA = strSAIDA & " <td align='left' valign='top' class='arial11'>" & prTITULO & "</td>" & vbNewLine
		strSAIDA = strSAIDA & " <td width='160' style='text-align:right;' valign='top' class='arial11'>de " & prDT_INI & " a " & prDT_FIM & "</td>" & vbNewLine
		
		Ct = 1
		strCOLOR = "#DAEEFA"
		
		If IsDate(prDT_INI) Then
			if (CDate(prDT_INI)<Now) then
				strCOLOR = "#FFF0F0" '"#FFDDDD" 'vermelho
			end if
		End If
		
		Dim strPREV, strTOTAL, pCent
		Dim AUX1, AUX2
		Dim tbW, BgCor
		
		AUX1 = prHORAS
		AUX2 = prPREV_HORAS
		
		'Retorna o tempo gasto de horas para cada tarefa
		if prHORAS<>"" then prHORAS = FormataHoraNumToHHMM(prHORAS)
		'Retorna total de horas previstas para cada tarefa
		if prPREV_HORAS<>"" then prPREV_HORAS = FormataHoraNumToHHMM(prPREV_HORAS)
		
		strPREV = 0
		strTOTAL= 0
		pCent = 0 
		
		if AUX2<>"" and not IsNull(AUX2) then strPREV = AUX2*60
		if AUX1<>"" and not IsNull(AUX1) then strTOTAL = AUX1*60
		if strPREV>0 and strTOTAL>=0 then pCent = strTOTAL*100/strPREV
		if pCent=0 then strHORAS = "0:00"
		
		tbW = pCent
		BgCor = "#93A2B9"
		
		if (tbW>100) then
			tbW = 100
			BgCor = "#7D8B9F"					
			if prSITUACAO<>"FECHADO" then BgCor = "#C00000"					
		end if				
		
		strSAIDA = strSAIDA & " <td width='60' align='left' valign='middle' class='arial11'>" & vbNewLine
'		strSAIDA = strSAIDA & "	<div style='padding-left:3px; padding-right:3px;'>" & vbNewLine
'		strSAIDA = strSAIDA & "		<table width='50' height='12' cellpadding='0' cellspacing='0' bordercolor='" & BgCor & "' style='border:1px solid;'>" & vbNewLine
'		strSAIDA = strSAIDA & "			<tr>" & vbNewLine
'		If tbW = 100 Then
'			strSAIDA = strSAIDA & "<td width='100%' bgcolor='" & BgCor & "' title='"& Round(pCent,2) &"% - "& prHORAS &"Hs'></td>" & vbNewLine
'		ElseIf tbW = 0 Then
'			strSAIDA = strSAIDA & "<td width='100%' bgcolor='#FFFFFF' title='"& Round(pCent,2) &"% - "& prHORAS &"Hs'></td>" & vbNewLine
'		Else
'			strSAIDA = strSAIDA & "<td width='" & tbW & "%' bgcolor='" & BgCor & "' title='"& Round(pCent,2) &"% - "& prHORAS &"Hs'></td>" & vbNewLine
'			strSAIDA = strSAIDA & "<td width='"& (100-tbW) &"%' bgcolor='#FFFFFF' title='"& Round(pCent,2) &"% - "& prHORAS &"Hs'></td>" & vbNewLine
'		End If
'		strSAIDA = strSAIDA & "			</tr>" & vbNewLine
'		strSAIDA = strSAIDA & "		</table>" & vbNewLine
'		strSAIDA = strSAIDA & "	</div>" & vbNewLine
		strSAIDA = strSAIDA & " </td>" & vbNewLine
		strSAIDA = strSAIDA & " <td width='40' style='text-align:right' valign='top' class='arial11' title='Total de horas previstas'>"& prPREV_HORAS &"</td>" & vbNewLine
		strSAIDA = strSAIDA & " <td width='16' valign='top' class='arial11'><a href='../modulo_CLIENTE/Detail.asp?var_chavereg="& prCOD_CLIENTE &"'><img src='../img/IconStatus_Client.gif' border='0' title='CLIENTE: " & prCLIENTE &"'></a></td>" & vbNewLine
	Else
		strSAIDA = strSAIDA & "<td>ATIVIDADE GERAL</td>" & vbNewLine
	End If
	strSAIDA = strSAIDA & "</tr>" & vbNewLine
	strSAIDA = strSAIDA & "</table>" & vbNewLine
	strSAIDA = strSAIDA & "<div id='ativ_" & prCODIGO & "_" & prSUFIXO & "' style='padding:0px;'>" & vbNewLine
	
	ExibeBS = strSAIDA
End Function

Function ExibeTODOLIST(prCODIGO, prTITULO, prRESPONSAVEL, prEXECUTOR, prCATEGORIA, prDT_INI, prHR_INI, prHORAS, prSITUACAO, prPRIORIDADE, prCOD_BS, prTIPO_BS, prCABECALHO, prMARGEM, prSUFIXO)
	Dim strSAIDA, auxBgColor
	
	if prHORAS<>"" then prHORAS = FormataHoraNumToHHMM(prHORAS) else prHORAS = "&nbsp;" end if
	auxBgColor="#FFFFF0"
	if IsDate(prDT_INI) then
		if (prSITUACAO<>"FECHADO") then
			if (prDT_INI<Now) then auxBgColor = "#FFF0F0"
			if (prDT_INI=Date) then auxBgColor = "#FFFFF0"
		end if
	else
		auxBgColor = "#FFFFFF"
	end if
	
	If prCABECALHO Then
		strSAIDA =            "<table width='99%' height='20' bgcolor='#FFFFFF' cellpadding='2' cellspacing='1' border='0'>" & vbNewLine
		strSAIDA = strSAIDA & "<tr bgcolor='#EFEDED' class='arial11' valign='middle'>" & vbNewLine
		If prMARGEM = True Then
			strSAIDA = strSAIDA & "	<td colspan='2' width='32' bgcolor='#FFFFFF'></td>" & vbNewLine
		End If
		strSAIDA = strSAIDA & "	<td width='16'></td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='16'></td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='16'></td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='60' nowrap>Data</td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='15' nowrap></td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='40' align='right'>Cod</td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='70'>Categoria</td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td>T�tulo</td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='60'>Resp</td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='60'>Exec</td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='40' align='right'>Prev Hs</td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='16'></td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='16'></td>" & vbNewLine
		strSAIDA = strSAIDA & "</tr>" & vbNewLine
		
		'Linha fina e escura
		strSAIDA = strSAIDA & "<tr>" & vbNewLine
		If prMARGEM = True Then
			strSAIDA = strSAIDA & " <td colspan='2'></td>" & vbNewLine
		End If
		strSAIDA = strSAIDA & " <td colspan='13' height='1' bgcolor='#C9C9C9'></td>" & vbNewLine
		strSAIDA = strSAIDA & "</tr>" & vbNewLine
	End If
	
	strSAIDA = strSAIDA & "<tr bgcolor='" & auxBgColor & "' class='arial11' valign='middle'>" & vbNewLine
	If prMARGEM = True Then
		strSAIDA = strSAIDA & "	<td width='16' bgcolor='#FFFFFF'></td>" & vbNewLine
		strSAIDA = strSAIDA & "	<td width='16' bgcolor='#FFFFFF'></td>" & vbNewLine
	End If
	strSAIDA = strSAIDA & "	<td width='16' align='center' valign='top'>"
	If (bUpdTODO And (LCase(prRESPONSAVEL) = strUSER_ID And (prHORAS = "0" Or prHORAS = ""))) Then
		strSAIDA = strSAIDA & "<a style='cursor:hand;' href='../modulo_TODOLIST/Update.asp?var_chavereg=" & prCODIGO & "'><img src='../img/IconAction_EDIT.gif' border='0' title='ALTERAR'></a>"
	End If
	strSAIDA = strSAIDA & "	</td>" & vbNewLine
	
	strSAIDA = strSAIDA & "	<td width='16' align='center' valign='top'>"
	If (bInsRespTODO And (LCase(prRESPONSAVEL) = strUSER_ID Or LCase(prEXECUTOR) = strUSER_ID)) Then
		strSAIDA = strSAIDA & "<a style='cursor:hand;' href='../modulo_TODOLIST/DetailHistorico.asp?var_chavereg=" & prCODIGO & "&var_resposta=true'><img src='../img/IconAction_DETAILadd.gif' border='0' title='INSERIR ANDAMENTO'></a>"
	Else
		If (prTIPO_BS = "COLAB") Then
			strSAIDA = strSAIDA & "<a style='cursor:hand;' href='../modulo_TODOLIST/DetailHistorico.asp?var_chavereg=" & prCODIGO & "&var_resposta=true'><img src='../img/IconAction_DETAILaddColab.gif' border='0' title='INSERIR ANDAMENTO'></a>"
		End If
	End If
	strSAIDA = strSAIDA & "	</td>" & vbNewLine
	
	strSAIDA = strSAIDA & "	<td width='16' align='center' valign='top'>"
	If (bCloseTODO And (LCase(prRESPONSAVEL) = strUSER_ID Or LCase(prEXECUTOR) = strUSER_ID)) Then
		strSAIDA = strSAIDA & MontaLinkGrade("modulo_TODOLIST","Close.asp",prCODIGO & "&var_ultexec=" & strUSER_ID,"IconAction_QUICK_CLOSE.gif","FECHAR")
	End If
	strSAIDA = strSAIDA & "	</td>" & vbNewLine
	
	strSAIDA = strSAIDA & "	<td width='65' valign='top'>" & PrepData(prDT_INI,true,false) & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='15' valign='top'>" & prHR_INI & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='40' align='right' valign='top'>" & prCODIGO & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td valign='top'>" & prCATEGORIA & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td valign='top'>" & prTITULO & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='60' valign='top'>" & LCase(prRESPONSAVEL) & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='60' valign='top'>" & LCase(prEXECUTOR) & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='40' style='text-align:right' valign='top'>" & prHORAS & "</td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='16' align='center' valign='top'><img src='../img/IconStatus_" & prSITUACAO & ".gif'  title='SITUA��O: " & prSITUACAO & "'></td>" & vbNewLine
	strSAIDA = strSAIDA & "	<td width='16' align='center' valign='top'><img src='../img/IconPrio_" & prPRIORIDADE & ".gif' title='PRIORIDADE: " & prPRIORIDADE & "'></td>" & vbNewLine
	strSAIDA = strSAIDA & "</tr>" & vbNewLine
	
	'Final da tabela � por fora, quando se troca de BS/Projeto
	'strSAIDA = strSAIDA & "</table>" & vbNewLine
	
	ExibeTODOLIST = strSAIDA
End Function

' -----------------------------------------------------------------------------------------------
' INI: MontaSQLBuscaPAT -------------------------------------------------------------------------
'      Monta o SQL para busta do PAT ([P]rojetos, [A]tividades e [T]arefas do usu�rio), conforme
' a procedure sp_busca_pat faria, mas  no  MySQL 4.1.18  n�o temos procedure, ent�o por enquanto
' temos de fazer via sql mesmo, tentei deixar com estrutura o mais pr�xima da procedure poss�vel.
' -----------------------------------------------------------------------------------------------
Function MontaSQLBuscaPAT(prIN_DATA, prIN_ID_USUARIO, prIN_VIEW, prLIMIT)
    Dim auxSQL
	
	IF (lcase(prIN_VIEW) = "exec") THEN
		auxSQL =          "SELECT CL.COD_CLIENTE, CL.NOME_FANTASIA AS CLIENTE , PRJ.COD_PROJETO, PRJ.TITULO AS PRJ_TITULO, PRJ.ID_RESPONSAVEL AS PRJ_ID_RESPONSAVEL "
		auxSQL = auxSQL & ", PRJ.FASE_ATUAL AS PRJ_FASE_ATUAL, PRJ.PREV_TOT_HORAS AS PRJ_PREV_TOT_HORAS, PRJ.DT_INICIO AS PRJ_DT_INICIO "
		auxSQL = auxSQL & ", PRJ.DT_DEADLINE AS PRJ_DT_DEADLINE, BS.COD_BOLETIM, BS.TITULO AS BS_TITULO, BS.ID_RESPONSAVEL AS BS_ID_RESPONSAVEL "
		auxSQL = auxSQL & ", BS.SITUACAO AS BS_SITUACAO, BS.PRIORIDADE AS BS_PRIORIDADE, BS.TIPO AS BS_TIPO "
  		
		
'		auxSQL = auxSQL & ", CAST((SELECT MIN(T1.PREV_DT_INI) FROM TL_TODOLIST T1 WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS DATETIME) AS BS_DT_INI "
'		auxSQL = auxSQL & ", CAST((SELECT MAX(T1.PREV_DT_INI) FROM TL_TODOLIST T1 WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS DATETIME) AS BS_DT_FIM "
'		auxSQL = auxSQL & ", (SELECT SUM(T1.PREV_HORAS) FROM TL_TODOLIST T1 WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS BS_TOT_PREV_HORAS "
'		auxSQL = auxSQL & ", (SELECT SUM(T2.HORAS) FROM TL_TODOLIST T1 LEFT OUTER JOIN TL_RESPOSTA T2 ON (T1.COD_TODOLIST = T2.COD_TODOLIST) WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS BS_TOT_HORAS "
		auxSQL = auxSQL & ", NULL AS BS_DT_INI "
		auxSQL = auxSQL & ", NULL AS BS_DT_FIM "
		auxSQL = auxSQL & ", NULL AS BS_TOT_PREV_HORAS "
		auxSQL = auxSQL & ", NULL AS BS_TOT_HORAS "
		
		auxSQL = auxSQL & ", (SELECT DISTINCT ID_USUARIO FROM BS_EQUIPE WHERE COD_BOLETIM = TL.COD_BOLETIM AND ID_USUARIO = '" & prIN_ID_USUARIO & "' AND DT_INATIVO IS NULL) AS BS_NA_EQUIPE "
		auxSQL = auxSQL & ", TL.COD_TODOLIST, TL.TITULO AS TL_TITULO, TL.ID_RESPONSAVEL AS TL_ID_RESPONSAVEL, TL.ID_ULT_EXECUTOR AS TL_ID_ULT_EXECUTOR"
		auxSQL = auxSQL & ", TL.SITUACAO AS TL_SITUACAO, TL.PRIORIDADE AS TL_PRIORIDADE, TL.PREV_HORAS AS TL_PREV_HORAS, TL.PREV_DT_INI AS TL_PREV_DT_INI"
		auxSQL = auxSQL & ", TL.PREV_DT_FIM AS TL_PREV_DT_FIM, TL.PREV_HR_INI AS TL_PREV_HR_INI, TL.ARQUIVO_ANEXO AS TL_ARQUIVO_ANEXO, TLCAT.NOME AS TL_CATEGORIA "
		
		auxSQL = auxSQL & " FROM TL_TODOLIST TL "
		auxSQL = auxSQL & " LEFT OUTER JOIN BS_BOLETIM BS ON (TL.COD_BOLETIM = BS.COD_BOLETIM) "
		auxSQL = auxSQL & " LEFT OUTER JOIN ENT_CLIENTE CL ON (CL.COD_CLIENTE = BS.COD_CLIENTE) "
		auxSQL = auxSQL & " LEFT OUTER JOIN PRJ_PROJETO PRJ ON (BS.COD_PROJETO = PRJ.COD_PROJETO) "
		auxSQL = auxSQL & " LEFT OUTER JOIN TL_CATEGORIA TLCAT ON (TL.COD_CATEGORIA = TLCAT.COD_CATEGORIA) "
  		
		auxSQL = auxSQL & " WHERE TL.SITUACAO <> 'FECHADO' "
		auxSQL = auxSQL & " AND TL.PREV_DT_INI <= '" & prIN_DATA & "' " 
		auxSQL = auxSQL & " AND TL.ID_ULT_EXECUTOR = '" & prIN_ID_USUARIO & "' "
		auxSQL = auxSQL & " AND (BS.TIPO <> 'MODELO' OR BS.TIPO IS NULL) "
		
		auxSQL = auxSQL & " ORDER BY PRJ.TITULO, PRJ.COD_PROJETO, BS.TITULO, BS.COD_BOLETIM, TL.TITULO, TL.COD_TODOLIST "
		If prLIMIT <> "" Then auxSQL = auxSQL & " LIMIT " & prLIMIT 
    END IF

	IF (lcase(prIN_VIEW) = "resp") THEN
		auxSQL =          "SELECT CL.COD_CLIENTE, CL.NOME_FANTASIA AS CLIENTE , PRJ.COD_PROJETO, PRJ.TITULO AS PRJ_TITULO, PRJ.ID_RESPONSAVEL AS PRJ_ID_RESPONSAVEL "
		auxSQL = auxSQL & ", PRJ.FASE_ATUAL AS PRJ_FASE_ATUAL, PRJ.PREV_TOT_HORAS AS PRJ_PREV_TOT_HORAS, PRJ.DT_INICIO AS PRJ_DT_INICIO "
		auxSQL = auxSQL & ", PRJ.DT_DEADLINE AS PRJ_DT_DEADLINE, BS.COD_BOLETIM, BS.TITULO AS BS_TITULO, BS.ID_RESPONSAVEL AS BS_ID_RESPONSAVEL "
		auxSQL = auxSQL & ", BS.SITUACAO AS BS_SITUACAO, BS.PRIORIDADE AS BS_PRIORIDADE, BS.TIPO AS BS_TIPO "
  		
'		auxSQL = auxSQL & ", CAST((SELECT MIN(T1.PREV_DT_INI) FROM TL_TODOLIST T1 WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS DATETIME) AS BS_DT_INI "
'		auxSQL = auxSQL & ", CAST((SELECT MAX(T1.PREV_DT_INI) FROM TL_TODOLIST T1 WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS DATETIME) AS BS_DT_FIM "
'		auxSQL = auxSQL & ", (SELECT SUM(T1.PREV_HORAS) FROM TL_TODOLIST T1 WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS BS_TOT_PREV_HORAS "
'		auxSQL = auxSQL & ", (SELECT SUM(T2.HORAS) FROM TL_TODOLIST T1 LEFT OUTER JOIN TL_RESPOSTA T2 ON (T1.COD_TODOLIST = T2.COD_TODOLIST) WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS BS_TOT_HORAS " 
		auxSQL = auxSQL & ", NULL AS BS_DT_INI "
		auxSQL = auxSQL & ", NULL AS BS_DT_FIM "
		auxSQL = auxSQL & ", NULL AS BS_TOT_PREV_HORAS "
		auxSQL = auxSQL & ", NULL AS BS_TOT_HORAS "

		auxSQL = auxSQL & ", (SELECT DISTINCT ID_USUARIO FROM BS_EQUIPE WHERE COD_BOLETIM = TL.COD_BOLETIM AND ID_USUARIO = '" & prIN_ID_USUARIO & "' AND DT_INATIVO IS NULL) AS BS_NA_EQUIPE "
		auxSQL = auxSQL & ", TL.COD_TODOLIST, TL.TITULO AS TL_TITULO, TL.ID_RESPONSAVEL AS TL_ID_RESPONSAVEL, TL.ID_ULT_EXECUTOR AS TL_ID_ULT_EXECUTOR "
		auxSQL = auxSQL & ", TL.SITUACAO AS TL_SITUACAO, TL.PRIORIDADE AS TL_PRIORIDADE, TL.PREV_HORAS AS TL_PREV_HORAS, TL.PREV_DT_INI AS TL_PREV_DT_INI "
		auxSQL = auxSQL & ", TL.PREV_DT_FIM AS TL_PREV_DT_FIM, TL.PREV_HR_INI AS TL_PREV_HR_INI, TL.ARQUIVO_ANEXO AS TL_ARQUIVO_ANEXO, TLCAT.NOME AS TL_CATEGORIA "
		
		auxSQL = auxSQL & " FROM TL_TODOLIST TL "
		auxSQL = auxSQL & " LEFT OUTER JOIN BS_BOLETIM BS ON (TL.COD_BOLETIM = BS.COD_BOLETIM) "
		auxSQL = auxSQL & " LEFT OUTER JOIN ENT_CLIENTE CL ON (CL.COD_CLIENTE = BS.COD_CLIENTE) "
		auxSQL = auxSQL & " LEFT OUTER JOIN PRJ_PROJETO PRJ ON (BS.COD_PROJETO = PRJ.COD_PROJETO) "
		auxSQL = auxSQL & " LEFT OUTER JOIN TL_CATEGORIA TLCAT ON (TL.COD_CATEGORIA = TLCAT.COD_CATEGORIA) "
  		
		auxSQL = auxSQL & " WHERE TL.SITUACAO <> 'FECHADO' "
		auxSQL = auxSQL & " AND TL.PREV_DT_INI <= '" & prIN_DATA & "' " 
		auxSQL = auxSQL & " AND TL.ID_RESPONSAVEL = '" & prIN_ID_USUARIO & "' " 
		auxSQL = auxSQL & " AND (BS.TIPO <> 'MODELO' OR BS.TIPO IS NULL) "
		
		auxSQL = auxSQL & " ORDER BY PRJ.TITULO, PRJ.COD_PROJETO, BS.TITULO, BS.COD_BOLETIM, TL.TITULO, TL.COD_TODOLIST "
		If prLIMIT <> "" Then auxSQL = auxSQL & " LIMIT " & prLIMIT 
	END IF

	IF (lcase(prIN_VIEW) = "all") THEN
		auxSQL =          "SELECT CL.COD_CLIENTE, CL.NOME_FANTASIA AS CLIENTE , PRJ.COD_PROJETO, PRJ.TITULO AS PRJ_TITULO, PRJ.ID_RESPONSAVEL AS PRJ_ID_RESPONSAVEL "
		auxSQL = auxSQL & ", PRJ.FASE_ATUAL AS PRJ_FASE_ATUAL, PRJ.PREV_TOT_HORAS AS PRJ_PREV_TOT_HORAS, PRJ.DT_INICIO AS PRJ_DT_INICIO "
		auxSQL = auxSQL & ", PRJ.DT_DEADLINE AS PRJ_DT_DEADLINE, BS.COD_BOLETIM, BS.TITULO AS BS_TITULO, BS.ID_RESPONSAVEL AS BS_ID_RESPONSAVEL "
		auxSQL = auxSQL & ", BS.SITUACAO AS BS_SITUACAO, BS.PRIORIDADE AS BS_PRIORIDADE, BS.TIPO AS BS_TIPO "
  		
'		auxSQL = auxSQL & ", CAST((SELECT MIN(T1.PREV_DT_INI) FROM TL_TODOLIST T1 WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS DATETIME) AS BS_DT_INI "
'		auxSQL = auxSQL & ", CAST((SELECT MAX(T1.PREV_DT_INI) FROM TL_TODOLIST T1 WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS DATETIME) AS BS_DT_FIM "
'		auxSQL = auxSQL & ", (SELECT SUM(T1.PREV_HORAS) FROM TL_TODOLIST T1 WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS BS_TOT_PREV_HORAS "
'		auxSQL = auxSQL & ", (SELECT SUM(T2.HORAS) FROM TL_TODOLIST T1 LEFT OUTER JOIN TL_RESPOSTA T2 ON (T1.COD_TODOLIST = T2.COD_TODOLIST) WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS BS_TOT_HORAS "
		auxSQL = auxSQL & ", NULL AS BS_DT_INI "
		auxSQL = auxSQL & ", NULL AS BS_DT_FIM "
		auxSQL = auxSQL & ", NULL AS BS_TOT_PREV_HORAS "
		auxSQL = auxSQL & ", NULL AS BS_TOT_HORAS "

		auxSQL = auxSQL & ", (SELECT DISTINCT ID_USUARIO FROM BS_EQUIPE WHERE COD_BOLETIM = TL.COD_BOLETIM AND ID_USUARIO = '" & prIN_ID_USUARIO & "' AND DT_INATIVO IS NULL) AS BS_NA_EQUIPE "
		auxSQL = auxSQL & ", TL.COD_TODOLIST, TL.TITULO AS TL_TITULO, TL.ID_RESPONSAVEL AS TL_ID_RESPONSAVEL, TL.ID_ULT_EXECUTOR AS TL_ID_ULT_EXECUTOR "
		auxSQL = auxSQL & ", TL.SITUACAO AS TL_SITUACAO, TL.PRIORIDADE AS TL_PRIORIDADE, TL.PREV_HORAS AS TL_PREV_HORAS, TL.PREV_DT_INI AS TL_PREV_DT_INI "
		auxSQL = auxSQL & ", TL.PREV_DT_FIM AS TL_PREV_DT_FIM, TL.PREV_HR_INI AS TL_PREV_HR_INI, TL.ARQUIVO_ANEXO AS TL_ARQUIVO_ANEXO, TLCAT.NOME AS TL_CATEGORIA "
		
		auxSQL = auxSQL & " FROM TL_TODOLIST TL "
		auxSQL = auxSQL & " LEFT OUTER JOIN BS_BOLETIM BS ON (TL.COD_BOLETIM = BS.COD_BOLETIM) " 
		auxSQL = auxSQL & " LEFT OUTER JOIN ENT_CLIENTE CL ON (CL.COD_CLIENTE = BS.COD_CLIENTE) " 
		auxSQL = auxSQL & " LEFT OUTER JOIN PRJ_PROJETO PRJ ON (BS.COD_PROJETO = PRJ.COD_PROJETO) " 
		auxSQL = auxSQL & " LEFT OUTER JOIN TL_CATEGORIA TLCAT ON (TL.COD_CATEGORIA = TLCAT.COD_CATEGORIA) "
        
		auxSQL = auxSQL & " WHERE TL.SITUACAO <> 'FECHADO' "
		auxSQL = auxSQL & " AND TL.PREV_DT_INI <= '" & prIN_DATA & "' " 
		auxSQL = auxSQL & " AND (BS.TIPO <> 'MODELO' OR BS.TIPO IS NULL) "
		
		auxSQL = auxSQL & " ORDER BY PRJ.TITULO, PRJ.COD_PROJETO, BS.TITULO, BS.COD_BOLETIM, TL.TITULO, TL.COD_TODOLIST "
		If prLIMIT <> "" Then auxSQL = auxSQL & " LIMIT " & prLIMIT 
    END IF
	
	IF (lcase(prIN_VIEW) = "equipe") THEN
		auxSQL =          "SELECT CL.COD_CLIENTE, CL.NOME_FANTASIA AS CLIENTE , PRJ.COD_PROJETO, PRJ.TITULO AS PRJ_TITULO, PRJ.ID_RESPONSAVEL AS PRJ_ID_RESPONSAVEL "
		auxSQL = auxSQL & ", PRJ.FASE_ATUAL AS PRJ_FASE_ATUAL, PRJ.PREV_TOT_HORAS AS PRJ_PREV_TOT_HORAS, PRJ.DT_INICIO AS PRJ_DT_INICIO "
		auxSQL = auxSQL & ", PRJ.DT_DEADLINE AS PRJ_DT_DEADLINE, BS.COD_BOLETIM, BS.TITULO AS BS_TITULO, BS.ID_RESPONSAVEL AS BS_ID_RESPONSAVEL "
		auxSQL = auxSQL & ", BS.SITUACAO AS BS_SITUACAO, BS.PRIORIDADE AS BS_PRIORIDADE, BS.TIPO AS BS_TIPO "
  		
'		auxSQL = auxSQL & ", CAST((SELECT MIN(T1.PREV_DT_INI) FROM TL_TODOLIST T1 WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS DATETIME) AS BS_DT_INI "
'		auxSQL = auxSQL & ", CAST((SELECT MAX(T1.PREV_DT_INI) FROM TL_TODOLIST T1 WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS DATETIME) AS BS_DT_FIM "  
'		auxSQL = auxSQL & ", (SELECT SUM(T1.PREV_HORAS) FROM TL_TODOLIST T1 WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS BS_TOT_PREV_HORAS " 
'		auxSQL = auxSQL & ", (SELECT SUM(T2.HORAS) FROM TL_TODOLIST T1 LEFT OUTER JOIN TL_RESPOSTA T2 ON (T1.COD_TODOLIST = T2.COD_TODOLIST) WHERE T1.COD_BOLETIM = TL.COD_BOLETIM AND TL.COD_BOLETIM IS NOT NULL AND TL.COD_BOLETIM <> 0) AS BS_TOT_HORAS " 
		auxSQL = auxSQL & ", NULL AS BS_DT_INI "
		auxSQL = auxSQL & ", NULL AS BS_DT_FIM "
		auxSQL = auxSQL & ", NULL AS BS_TOT_PREV_HORAS "
		auxSQL = auxSQL & ", NULL AS BS_TOT_HORAS "

		auxSQL = auxSQL & ", (SELECT DISTINCT ID_USUARIO FROM BS_EQUIPE WHERE COD_BOLETIM = TL.COD_BOLETIM AND ID_USUARIO = '" & prIN_ID_USUARIO & "' AND DT_INATIVO IS NULL) AS BS_NA_EQUIPE "
		auxSQL = auxSQL & ", TL.COD_TODOLIST, TL.TITULO AS TL_TITULO, TL.ID_RESPONSAVEL AS TL_ID_RESPONSAVEL, TL.ID_ULT_EXECUTOR AS TL_ID_ULT_EXECUTOR "
		auxSQL = auxSQL & ", TL.SITUACAO AS TL_SITUACAO, TL.PRIORIDADE AS TL_PRIORIDADE, TL.PREV_HORAS AS TL_PREV_HORAS, TL.PREV_DT_INI AS TL_PREV_DT_INI "
		auxSQL = auxSQL & ", TL.PREV_DT_FIM AS TL_PREV_DT_FIM, TL.PREV_HR_INI AS TL_PREV_HR_INI, TL.ARQUIVO_ANEXO AS TL_ARQUIVO_ANEXO, TLCAT.NOME AS TL_CATEGORIA "
		
		auxSQL = auxSQL & " FROM TL_TODOLIST TL "
		auxSQL = auxSQL & " INNER JOIN BS_BOLETIM BS ON (TL.COD_BOLETIM = BS.COD_BOLETIM) "
		auxSQL = auxSQL & " LEFT OUTER JOIN ENT_CLIENTE CL ON (CL.COD_CLIENTE = BS.COD_CLIENTE) "
		auxSQL = auxSQL & " LEFT OUTER JOIN PRJ_PROJETO PRJ ON (BS.COD_PROJETO = PRJ.COD_PROJETO) "
		auxSQL = auxSQL & " LEFT OUTER JOIN TL_CATEGORIA TLCAT ON (TL.COD_CATEGORIA = TLCAT.COD_CATEGORIA) "
        
		auxSQL = auxSQL & " WHERE TL.SITUACAO <> 'FECHADO' "
		auxSQL = auxSQL & " AND TL.PREV_DT_INI <= '" & prIN_DATA & "' " 
		auxSQL = auxSQL & " AND BS.TIPO <> 'MODELO' "
		auxSQL = auxSQL & " AND TL.ID_ULT_EXECUTOR <> '" & prIN_ID_USUARIO & "' "
		auxSQL = auxSQL & " AND BS.COD_BOLETIM IN (SELECT DISTINCT COD_BOLETIM FROM BS_EQUIPE WHERE ID_USUARIO = '" & prIN_ID_USUARIO & "' ) "
		
		auxSQL = auxSQL & " ORDER BY PRJ.TITULO, PRJ.COD_PROJETO, BS.TITULO, BS.COD_BOLETIM, TL.TITULO, TL.COD_TODOLIST "
		If prLIMIT <> "" Then auxSQL = auxSQL & " LIMIT " & prLIMIT 
    END IF	
	
    MontaSQLBuscaPAT = auxSQL
End Function
' ---------------------------------------------------------------------------------------------
' FIM: MontaSQLBuscaPAT -------------------------------------------------------------------------
' ---------------------------------------------------------------------------------------------

%>