<!--#include file="../_database/athdbConn.asp"--> <%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
	Dim strSQL, objRS, ObjConn, objRSTs, objRSCT
	Dim strSYS_DT_CRIACAO, strSYS_COD_USER_CRIACAO
	Dim strCOD_CONTA_ORIG, strCOD_CONTA_DEST
	Dim strNUM_LCTO, strVLR_LCTO, strDT_LCTO, strMSG
	Dim strHISTORICO, strOBS, strNOVO_SALDO, strVLR_SALDO
	Dim strJSCRIPT_ACTION, strLOCATION
	
	strCOD_CONTA_ORIG = GetParam("var_cod_conta_orig")
	strCOD_CONTA_DEST = GetParam("var_cod_conta_dest")
	strNUM_LCTO = GetParam("var_num_lcto")
	strVLR_LCTO = Replace(GetParam("var_vlr_lcto"),".","")
	strDT_LCTO = GetParam("var_dt_lcto")
	strHISTORICO = GetParam("var_historico")
	strOBS = GetParam("var_obs")
	strJSCRIPT_ACTION 		= GetParam("JSCRIPT_ACTION")
	strLOCATION 			= GetParam("DEFAULT_LOCATION")
	
	strSYS_DT_CRIACAO		= Now()
	strSYS_COD_USER_CRIACAO = Request.Cookies("VBOSS")("ID_USUARIO")
	
	AbreDBConn objConn, CFG_DB 
	
	strMSG = ""
	if strCOD_CONTA_ORIG="" then	strMSG = strMSG & "Parâmetro inválido para conta origem<br>"
	if strCOD_CONTA_DEST="" then	strMSG = strMSG & "Parâmetro inválido para conta destino<br>"	
	if strNUM_LCTO=""	 then	strMSG = strMSG & "Informar número do lançamento<br>"
	if strVLR_LCTO=""  then strMSG = strMSG & "Informar valor do lançamento<br>"	
	if strDT_LCTO=""	 then	strMSG = strMSG & "Informar data do lançamento<br>"							
	if strHISTORICO="" then	strMSG = strMSG & "Informar histórico<br>"
	if not IsDate(strDT_LCTO) then 
		strDT_LCTO = Date
	else
		if CDate(strDT_LCTO) > Date then strMSG = strMSG & "Não é permitido lançamento com data futura (" & strDT_LCTO & ")<br>"
	end if
	
	if strCOD_CONTA_ORIG<>"" and strCOD_CONTA_DEST<>"" then
			strSQL = "SELECT NOME, DT_CADASTRO FROM FIN_CONTA WHERE COD_CONTA=" & strCOD_CONTA_ORIG &_
					" UNION " &_
					"SELECT NOME, DT_CADASTRO FROM FIN_CONTA WHERE COD_CONTA=" & strCOD_CONTA_DEST
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
		if not objRS.eof then	
			while not objRS.eof
				if CDate(strDT_LCTO) < CDate(GetValue(objRS,"DT_CADASTRO")) then 
					strMSG = strMSG & "Data do lançamento (" & strDT_LCTO & ") não corresponde com a criação da conta "
					strMSG = strMSG & GetValue(objRS,"NOME") & " (" & GetValue(objRS,"DT_CADASTRO") & ")<br>"	
				end if
				objRS.MoveNext		
			wend
		end if
	end if
		
	if strMSG <> "" then 
		Mensagem strMSG, "Javascript:history.go(-1);", "Voltar", 1
		Response.End()
	end if

	'Insere os dados e valores da nova transferência
	strSQL = "INSERT INTO FIN_LCTO_TRANSF"	&_
				"	(	COD_CONTA_ORIG,"	&_
				"		COD_CONTA_DEST,"	&_
				"		NUM_LCTO,"	&_
				"		VLR_LCTO,"	&_
				"		DT_LCTO,"	&_
				"		HISTORICO,"	&_
				"		OBS,"	&_
				"		SYS_DT_CRIACAO,"	&_
				"		SYS_COD_USER_CRIACAO"	&_
				"	) "		&_
				"VALUES"		&_
				"	('"& 	strCOD_CONTA_ORIG	& "'," &_
				"	'" &	strCOD_CONTA_DEST	& "'," &_
				"	'" &	strNUM_LCTO 		& "'," &_
				"	 " &	Replace(strVLR_LCTO,",",".") & "," &_
				"	'" &	PrepDataBrToUni(strDT_LCTO,false) & "'," &_ 
				"	'"	& 	strHISTORICO		& "'," &_ 
				"	'"	&	strOBS				& "'," &_ 
				"	'"	&	PrepDataBrToUni(strSYS_DT_CRIACAO,true) & "'," &_ 
				"	'"	&	strSYS_COD_USER_CRIACAO & "'" &_ 
				"	)"
	'Response.Write(strSQL & "<br><br>")

	'AQUI: NEW TRANSACTION
	set objRSTs  = objConn.Execute("start transaction")
	set objRSTs  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)  
	If Err.Number <> 0 Then
	  set objRSTs = objConn.Execute("rollback")
	  Mensagem "modulo_FIN_LCTOCONTA.InsertTransf_Exec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
 	  Response.End()
	else
	  set objRSTs = objConn.Execute("commit")
	End If

	'Insere novo saldo na conta de ORIGEM
	strSQL = "SELECT VLR_SALDO FROM FIN_CONTA WHERE COD_CONTA=" & strCOD_CONTA_ORIG
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	if GetValue(objRS,"VLR_SALDO")<>"" then
		strVLR_SALDO = GetValue(objRS,"VLR_SALDO")
	else
		strVLR_SALDO = "0,00"
	end if
	strNOVO_SALDO = strVLR_SALDO - strVLR_LCTO
	strNOVO_SALDO = FormataDecimal(strNOVO_SALDO, 2)
	strNOVO_SALDO = FormataDouble(strNOVO_SALDO)
	
	'AQUI: NEW TRANSACTION
	set objRSCT = objConn.Execute("start transaction")
	set objRSCT = objConn.Execute("set autocommit = 0")
	strSQL = "UPDATE FIN_CONTA SET VLR_SALDO=" & strNOVO_SALDO & " WHERE COD_CONTA=" & strCOD_CONTA_ORIG
	objConn.Execute(strSQL)
	if Err.Number<>0 then 
	  set objRSCT= objConn.Execute("rollback")
	  Mensagem "modulo_FIN_LCTOCONTA.InsertTransf_Exec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
 	  Response.End()
	else	  
	  set objRSCT= objConn.Execute("commit")
	End If
	
	AcumulaSaldoNovo objConn, strCOD_CONTA_ORIG, strDT_LCTO, -strVLR_LCTO 
	
	'Insere novo saldo na conta DESTINO
	strSQL = "SELECT VLR_SALDO FROM FIN_CONTA WHERE COD_CONTA=" & strCOD_CONTA_DEST
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
	if GetValue(objRS,"VLR_SALDO")<>"" then
		strVLR_SALDO = GetValue(objRS,"VLR_SALDO")
	else
		strVLR_SALDO = "0,00"
	end if
	
	strNOVO_SALDO = strVLR_SALDO + strVLR_LCTO
	strNOVO_SALDO = FormataDecimal(strNOVO_SALDO, 2)
	strNOVO_SALDO = FormataDouble(strNOVO_SALDO)
	
	'AQUI: NEW TRANSACTION
	set objRSCT = objConn.Execute("start transaction")
	set objRSCT = objConn.Execute("set autocommit = 0")
	strSQL = "UPDATE FIN_CONTA SET VLR_SALDO=" & strNOVO_SALDO & " WHERE COD_CONTA=" & strCOD_CONTA_DEST
	objConn.Execute(strSQL)	
	if Err.Number<>0 then 
	  set objRSCT= objConn.Execute("rollback")
	  Mensagem "modulo_FIN_LCTOCONTA.InsertTransf_Exec C: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
 	  Response.End()
	else	  
	  set objRSCT= objConn.Execute("commit")
	End If
	
	AcumulaSaldoNovo objConn, strCOD_CONTA_DEST, strDT_LCTO, strVLR_LCTO
	
	FechaDBConn objConn	
	
response.write "<script>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'")
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "'"
response.write "</script>"
%>