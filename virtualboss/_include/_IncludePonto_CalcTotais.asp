<%
  '---------------------------------------------------------------------------------------------------
  'Recalcula o total de horas dia (PT_TOTAL_DIA)
  '---------------------------------------------------------------------------------------------------
  sub RecalculaTOTALDIA( prIDUSR, prDIA, prMES, prANO )
   Dim objRSCT, strSQLCT, strTOTALCT, strIN, strOUT, auxCOD, objRS
   
   strSQLCT = " SELECT HORA_IN, HORA_OUT FROM PT_PONTO " &_
              " WHERE ID_USUARIO LIKE '" & prIDUSR & "' AND DATA_DIA =" & prDIA & " AND DATA_MES = " & prMES & " AND DATA_ANO =" & prANO 

   set objRSCT = ObjConn.Execute(strSQLCT)
   strTOTALCT = "00:00:00"
   while not objRSCT.EOF
    strIN  = objRSCT("HORA_IN")
    strOUT = objRSCT("HORA_OUT")
    if (strOUT<>"") then 
	  If ( (TSec(strOUT)-TSec(strIN) ) >= 0) then strTOTALCT = THour( (TSec(strOUT)-TSec(strIN))+TSec(strTOTALCT) )
	End If
    objRSCT.movenext
   wend
   FechaRecordSet objRSCT

   strSQLCT = " SELECT COD_TOTAL_DIA FROM PT_TOTAL_DIA WHERE ID_USUARIO='" & prIDUSR & "' AND DATA_DIA =" & prDIA & " AND DATA_MES = " & prMES & " AND DATA_ANO =" & prANO
   set objRSCT = ObjConn.Execute(strSQLCT)
   if not objRSCT.EOF then auxCOD = objRSCT("COD_TOTAL_DIA") else auxCOD = "" end if
   FechaRecordSet objRSCT
 
   if (auxCOD <> "") then
    strSQLCT = "UPDATE PT_TOTAL_DIA SET TOTAL = '" & strTOTALCT & "' WHERE COD_TOTAL_DIA =" & auxCOD
   else
    strSQLCT = "INSERT INTO PT_TOTAL_DIA (ID_USUARIO, DATA_DIA, DATA_MES, DATA_ANO, TOTAL) VALUES ('" & prIDUSR & "'," & prDIA & "," & prMES & "," & prANO & ",'" & strTOTALCT & "')"
   end if 
    
	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	ObjConn.Execute(strSQLCT)
 
 	If Err.Number <> 0 Then
 	 	set objRS = objConn.Execute("rollback")
	  	Mensagem "_IncludePontoCalc.RecalculaTOTALDIA: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	else
 	 	set objRS = objConn.Execute("commit")
	End If
	  
  end sub

  '---------------------------------------------------------------------------------------------------
  'Recalcula o total de horas dia por empresa (PT_TOTAL_DIA_EMPRESA)
  '---------------------------------------------------------------------------------------------------
  sub RecalculaTOTALDIAEMPRESA( prEMPRESA, prIDUSR, prDIA, prMES, prANO )
   Dim objRSCT, strSQLCT, strTOTALCT, strIN, strOUT, auxCOD, objRS
   
   strSQLCT = " SELECT HORA_IN, HORA_OUT FROM PT_PONTO " &_
              "  WHERE ID_USUARIO= '" & prIDUSR & "' AND COD_EMPRESA = '" & prEMPRESA & "'" &_
			  "    AND DATA_DIA =" & prDIA & " AND DATA_MES = " & prMES & " AND DATA_ANO =" & prANO 

   set objRSCT = ObjConn.Execute(strSQLCT)
   strTOTALCT = "00:00:00"
   while not objRSCT.EOF
    strIN  = objRSCT("HORA_IN")
    strOUT = objRSCT("HORA_OUT")
    if (strOUT<>"") then 
	  If ( (TSec(strOUT)-TSec(strIN) ) >= 0) then strTOTALCT = THour( (TSec(strOUT)-TSec(strIN))+TSec(strTOTALCT) )
	End If
    objRSCT.movenext
   wend
   FechaRecordSet objRSCT
   
   strSQLCT = " SELECT COD_TOTAL_DIA_EMPRESA FROM PT_TOTAL_DIA_EMPRESA " &_
              "  WHERE ID_USUARIO='" & prIDUSR & "' AND COD_EMPRESA = '" & prEMPRESA & "'" &_
			  "    AND DATA_DIA =" & prDIA & " AND DATA_MES = " & prMES & " AND DATA_ANO =" & prANO
   
   set objRSCT = ObjConn.Execute(strSQLCT)
   if not objRSCT.EOF then auxCOD = objRSCT("COD_TOTAL_DIA_EMPRESA") else auxCOD = "" end if
   FechaRecordSet objRSCT
 
   if (auxCOD <> "") then
    strSQLCT = "UPDATE PT_TOTAL_DIA_EMPRESA SET TOTAL = '" & strTOTALCT & "' WHERE COD_TOTAL_DIA_EMPRESA =" & auxCOD
   else
    strSQLCT = "INSERT INTO PT_TOTAL_DIA_EMPRESA (ID_USUARIO, COD_EMPRESA, DATA_DIA, DATA_MES, DATA_ANO, TOTAL) VALUES ('" & prIDUSR & "','" & prEMPRESA & "'," & prDIA & "," & prMES & "," & prANO & ",'" & strTOTALCT & "')"
   end if 

	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	ObjConn.Execute(strSQLCT)
 
 	If Err.Number <> 0 Then
 	 	set objRS = objConn.Execute("rollback")
	  	Mensagem "_IncludePonto_CalcTotais.RecalculaTOTALDIAEMPRESA: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	else
 	 	set objRS = objConn.Execute("commit")
	End If

  end sub
  '---------------------------------------------------------------------------------------------------


  '---------------------------------------------------------------------------------------------------
  '
  '---------------------------------------------------------------------------------------------------
  function VerifyDATAConstrains (prIDUSR, prCOD, prDIA, prMES, prANO, prIN, prOUT)
  	Dim objRS, resp
  	resp = true
    ' monta consulta para pegar todos os horários deste dia deste user
	' pra cada tupla de IN/OUT compara com a prIN. prOUT e vê se é válido
	' válido retorna true senão mensagem e retorna false
	 strSQL = "SELECT COD_PONTO, HORA_IN, HORA_OUT " & _
			  "  FROM PT_PONTO" & _
			  " WHERE ID_USUARIO = '" & prIDUSR & "'"& _ 
			  "   AND DATA_DIA = " & prDIA & _
			  "   AND DATA_MES = " & prMES & _
			  "   AND DATA_ANO = " & prANO  

	AbreDBConn ObjConn, CFG_DB
	set objRS = ObjConn.Execute(strSQL)
	if Not objRS.EOF then

	  while Not objRS.EOF And resp
	   if CStr(objRS("COD_PONTO") & "") <> CStr(prCOD & "") then
	   		if TSec(replace(prIN,"'","")) > TSec(objRS("HORA_IN")) and TSec(replace(prIN,"'","")) < TSec(objRS("HORA_OUT")) then
		 		resp = false
			end if
			if prOUT <> "NULL" then
			 if  TSec(replace(prOUT,"'","")) >= TSec(objRS("HORA_IN")) and TSec(replace(prOUT,"'","")) <= TSec(objRS("HORA_OUT")) then
			  	 resp = false
			 end if
			end if
	    end if		
		objRS.MoveNext
	   Wend
	end if
	VerifyDATAConstrains = resp
	FechaRecordSet objRS
  end function
  '---------------------------------------------------------------------------------------------------

'---------------------------------------------------------------------------------------------------
' Faz marcação das entradas que faltam
'---------------------------------------------------------------------------------------------------
Sub MarcacaoFolga(prID_USUARIO)
	Dim strDATA, strDT_INI, strDT_FIM, strDIA, strMES, strANO
	Dim strFOLGAS, strFERIADOS, arrFOLGAS, arrFERIADOS, strDIAS_TRABALHO
	Dim Cont, DiaNormal
	Dim objRSLocal, strSQLLocal, objRSCT_local

	Dim	strUserTlbCOD, strUserTlbNAME, strUserUF

	'INI: Busca UF do user (conforme o seu estado trará os seus respectivos feriados, mais abaixo) ----------------------------------
	strSQLLocal = " SELECT CODIGO, TIPO FROM USUARIO WHERE ID_USUARIO LIKE '" & prID_USUARIO & "' "
	set objRSLocal = objConn.Execute(strSQLLocal)
	If Not objRSLocal.Eof Then
		strUserTlbCOD  = GetValue(objRSLocal, "CODIGO")
		strUserTlbNAME = lcase(GetValue(objRSLocal, "TIPO"))
	End If
	FechaRecordSet objRSLocal


	strSQLLocal = " SELECT "
    if (strUserTlbNAME="ent_colaborador") then
	  strSQLLocal = strSQLLocal & " ESTADO as UF" 
	else 
	  strSQLLocal = strSQLLocal & " ENTR_ESTADO as UF"
	end if  
	strSQLLocal = strSQLLocal & "   FROM " & strUserTlbNAME
	strSQLLocal = strSQLLocal & "  WHERE COD_" & replace(strUserTlbNAME,"ent_","") & " = " & strUserTlbCOD
	set objRSLocal = objConn.Execute(strSQLLocal)
	If Not objRSLocal.Eof Then	strUserUF = GetValue(objRSLocal, "UF")
	FechaRecordSet objRSLocal
	'FIM: Busca UF do user (conforme o seu estado trará os seus respectivos feriados, mais abaixo) ----------------------------------


	'-------------------------------------------
	' Busca a última data que teve marcação
	'-------------------------------------------
	'strSQLLocal =               " SELECT DATA_DIA, DATA_MES, DATA_ANO FROM PT_PONTO " 
	'strSQLLocal = strSQLLocal & " WHERE COD_PONTO IN  "
	'strSQLLocal = strSQLLocal & " ( SELECT MAX(COD_PONTO) AS CODIGO FROM PT_PONTO "
	'strSQLLocal = strSQLLocal & "   WHERE ID_USUARIO LIKE '" & prID_USUARIO & "' "
	'strSQLLocal = strSQLLocal & "   AND STATUS LIKE 'REALIZADO' "
	'strSQLLocal = strSQLLocal & " ) "
	
	'SQL mudou porque estava gerando timeout na página que executava
	strSQLLocal =               " SELECT COD_PONTO, DATA_DIA, DATA_MES, DATA_ANO " 
	strSQLLocal = strSQLLocal & "   FROM PT_PONTO "
	strSQLLocal = strSQLLocal & "  WHERE ID_USUARIO LIKE '" & prID_USUARIO & "' "
	strSQLLocal = strSQLLocal & "    AND STATUS LIKE 'REALIZADO' "
	strSQLLocal = strSQLLocal & "  ORDER BY COD_PONTO DESC  "
	strSQLLocal = strSQLLocal & "  LIMIT 1 "
	
	Set objRSLocal = objConn.Execute(strSQLLocal)
	strDT_INI = ""
	If Not objRSLocal.Eof Then
		strDT_INI = DateSerial(GetValue(objRSLocal, "DATA_ANO"), GetValue(objRSLocal, "DATA_MES"), GetValue(objRSLocal, "DATA_DIA"))
		strDT_INI = DateAdd("D", 1, strDT_INI)
	End If
	FechaRecordSet objRSLocal
	
	If IsDate(strDT_INI) Then
		'strDT_FIM = DateAdd("D", -2, Date) 'Faz a marcação até anteontem
		'Agora vai até ontem porque no código anterior um dia ficava sem marcação
		strDT_FIM = DateAdd("D", -1, Date)
		
		'--------------------------
		'Busca as folgas
		'--------------------------
		strSQLLocal =               " SELECT DT_INI, DT_FIM FROM PT_FOLGA "
		strSQLLocal = strSQLLocal & " WHERE ID_USUARIO LIKE '" & prID_USUARIO & "'"
		strSQLLocal = strSQLLocal & " AND ((DT_INI BETWEEN '" & PrepDataBrToUni(strDT_INI, False) & "' AND '" & PrepDataBrToUni(strDT_FIM, False) & "') OR "
		strSQLLocal = strSQLLocal & "      (DT_FIM BETWEEN '" & PrepDataBrToUni(strDT_INI, False) & "' AND '" & PrepDataBrToUni(strDT_FIM, False) & "') OR "
		strSQLLocal = strSQLLocal & "      (DT_INI < '" & PrepDataBrToUni(strDT_INI, False) & "' AND DT_FIM > '" & PrepDataBrToUni(strDT_FIM, False) & "')) "
		
		Set objRSLocal = objConn.Execute(strSQLLocal)
		strFOLGAS = ""
		Do While Not objRSLocal.Eof
			If GetValue(objRSLocal, "DT_INI") <> "" And GetValue(objRSLocal, "DT_FIM") <> "" Then
				strFOLGAS = strFOLGAS & GetValue(objRSLocal, "DT_INI") & "|" & GetValue(objRSLocal, "DT_FIM") & "|"
			End If
			objRSLocal.MoveNext
		Loop
		FechaRecordSet objRSLocal
		
		If strFOLGAS <> "" Then strFOLGAS = Left(strFOLGAS, Len(strFOLGAS)-1)
		arrFOLGAS = Split(strFOLGAS, "|")
		
		'-------------------------------------------------------------------------------------------
		'Busca os feriados. Era uma consulta com UNION, teve que ser separada por causa do mySQL
		'-------------------------------------------------------------------------------------------
		strFERIADOS = ""
		strSQLLocal = " SELECT DATA_DIA, DATA_MES, DATA_ANO, UF FROM PT_FERIADO WHERE ( (DATA_ANO IS NULL) OR (DATA_ANO=0) ) AND ( (UF='"&strUserUF&"') OR (UF is NULL) OR (UF='') )"
		Set objRSLocal = objConn.Execute(strSQLLocal)
		Do While Not objRSLocal.Eof
			strFERIADOS = strFERIADOS & GetValue(objRSLocal, "DATA_DIA") & "|" & GetValue(objRSLocal, "DATA_MES") & "|" & GetValue(objRSLocal, "DATA_ANO") & "|"
			objRSLocal.MoveNext
		Loop
		FechaRecordSet objRSLocal
		
		strSQLLocal = " SELECT DATA_DIA, DATA_MES, DATA_ANO, UF FROM PT_FERIADO WHERE ( (DATA_ANO BETWEEN " & DatePart("YYYY", strDT_INI) & " AND " & DatePart("YYYY", strDT_FIM) & ") AND ((UF='"&strUserUF&"') OR (UF is NULL) OR (UF='')) )"
		Set objRSLocal = objConn.Execute(strSQLLocal)
		Do While Not objRSLocal.Eof
			strFERIADOS = strFERIADOS & GetValue(objRSLocal, "DATA_DIA") & "|" & GetValue(objRSLocal, "DATA_MES") & "|" & GetValue(objRSLocal, "DATA_ANO") & "|"
			objRSLocal.MoveNext
		Loop
		FechaRecordSet objRSLocal
		
		If strFERIADOS <> "" Then strFERIADOS = Left(strFERIADOS, Len(strFERIADOS)-1)
		arrFERIADOS = Split(strFERIADOS, "|")
		
		'--------------------------------------
		'Busca os dias que deve trabalhar
		'--------------------------------------
		strSQLLocal = " SELECT DIA_SEMANA FROM USUARIO_HORARIO WHERE ID_USUARIO LIKE '" & prID_USUARIO & "' AND TOTAL <> '' "
		
		Set objRSLocal = objConn.Execute(strSQLLocal)
		
		strDIAS_TRABALHO = ""
		Do While Not objRSLocal.Eof
			strDIAS_TRABALHO = strDIAS_TRABALHO & GetValue(objRSLocal, "DIA_SEMANA") & " "
			objRSLocal.MoveNext
		Loop
		FechaRecordSet objRSLocal
		
		'--------------------------
		'Faz o laço para marcar
		'--------------------------
		strDATA = strDT_INI
		Do While strDATA <= strDT_FIM
			DiaNormal = True 'Em princípio, é dia normal de trabalho
			
			strDIA = DatePart("D", strDATA)
			strMES = DatePart("M", strDATA)
			strANO = DatePart("YYYY", strDATA)
			
			If DiaNormal Then
				If (DatePart("W", strDATA) = VBSunday)    And (InStr(strDIAS_TRABALHO, "DOM") = 0) Then DiaNormal = False
				If (DatePart("W", strDATA) = VBMonday)    And (InStr(strDIAS_TRABALHO, "SEG") = 0) Then DiaNormal = False
				If (DatePart("W", strDATA) = VBTuesday)   And (InStr(strDIAS_TRABALHO, "TER") = 0) Then DiaNormal = False
				If (DatePart("W", strDATA) = VBWednesday) And (InStr(strDIAS_TRABALHO, "QUA") = 0) Then DiaNormal = False
				If (DatePart("W", strDATA) = VBThursday)  And (InStr(strDIAS_TRABALHO, "QUI") = 0) Then DiaNormal = False
				If (DatePart("W", strDATA) = VBFriday)    And (InStr(strDIAS_TRABALHO, "SEX") = 0) Then DiaNormal = False
				If (DatePart("W", strDATA) = VBSaturday)  And (InStr(strDIAS_TRABALHO, "SAB") = 0) Then DiaNormal = False
			End If
			
			If DiaNormal Then
				Cont = 0
				Do While ((Cont <= UBound(arrFOLGAS)) And DiaNormal)
					If (CDate(strDATA) >= CDate(arrFOLGAS(Cont))) And (CDate(strDATA) <= CDate(arrFOLGAS(Cont + 1))) Then DiaNormal = False
					Cont = Cont + 2
				Loop
			End If
			
			If DiaNormal Then
				Cont = 0
				Do While ((Cont <= UBound(arrFERIADOS)) And DiaNormal)
					If (arrFERIADOS(Cont + 2) = "0") Or (arrFERIADOS(Cont + 2) = "") Then
						If (CStr(strDIA) = CStr(arrFERIADOS(Cont))) And (CStr(strMES) = CStr(arrFERIADOS(Cont + 1))) Then DiaNormal = False
					Else
						If (CStr(strDIA) = CStr(arrFERIADOS(Cont))) And (CStr(strMES) = CStr(arrFERIADOS(Cont + 1))) And (CStr(strANO) = CStr(arrFERIADOS(Cont + 2))) Then DiaNormal = False
					End If
					Cont = Cont + 3
				Loop
			End If
			
			If DiaNormal Then
				strSQLLocal =               " SELECT COD_PONTO FROM PT_PONTO "
				strSQLLocal = strSQLLocal & "  WHERE ID_USUARIO LIKE '" & prID_USUARIO & "' "
				strSQLLocal = strSQLLocal & "    AND DATA_DIA = " & strDIA
				strSQLLocal = strSQLLocal & "    AND DATA_MES = " & strMES
				strSQLLocal = strSQLLocal & "    AND DATA_ANO = " & strANO
				strSQLLocal = strSQLLocal & "    AND STATUS LIKE 'REALIZADO' "
				
				Set objRSLocal = objConn.Execute(strSQLLocal)
				
				If objRSLocal.Eof Then
					'Como não existe marcação no dia, pode inserir ponto
					strSQLLocal =               " INSERT INTO PT_PONTO (ID_USUARIO, DATA_DIA, DATA_MES, DATA_ANO, STATUS, OBS) "
					strSQLLocal = strSQLLocal & " VALUES ('" & prID_USUARIO & "', " & strDIA & ", " & strMES & ", " & strANO
					strSQLLocal = strSQLLocal & "        ,'REALIZADO', 'Falta: Inserção automática pelo sistema') "
					
					'AQUI: NEW TRANSACTION
					set objRSCT_local = objConn.Execute("start transaction")
					set objRSCT_local = objConn.Execute("set autocommit = 0")
					objConn.Execute(strSQLLocal)
					If Err.Number <> 0 Then
						set objRSCT_local = objConn.Execute("rollback")
						Mensagem  "_IncludePonto_CalcTotais.MarcacaoFolga: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
						Response.End()
					else
						set objRSCT_local = objConn.Execute("commit")
					End If
					
					'Chama função para contabilizar na tabela de totais do dia
					RecalculaTOTALDIA prID_USUARIO, strDIA, strMES, strANO
				End If
				
				FechaRecordSet objRSLocal
			End If
			strDATA = DateAdd("D", 1, strDATA)
		Loop
	End If
End Sub
  
%>
