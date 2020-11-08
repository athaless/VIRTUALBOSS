<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim objConn, objRS, objRSAux, strSQL, objRSTs
Dim strCOD_BOLETIM_ORIG 'Código do BOLETIM que será copiado
Dim strCOD_BOLETIM_NOVO 'Código do BOLETIM novo
Dim strCOD_CLIENTE,strID_USUARIO,strEQUIPE
Dim strCOD_TODOLIST, strID_RESPONSAVEL
Dim strID_ULT_EXECUTOR,strCOD_CATEGORIA 
Dim strTITULO,strDESCRICAO,strSITUACAO 
Dim strPRIORIDADE,strPREV_HORAS
Dim strPREV_DT_INI, strPREV_HR_INI 
Dim strARQUIVO_ANEXO, strREDIRECT, strTIPO
Dim strDT_BASE, strDT_NOVA, strDIAS_DIFER, strDT_INI, strDT_FIM
Dim strMes, i, strDT_AGORA
Dim strJSCRIPT_ACTION, strLOCATION

strMes = month(date)
if len(strMes) = 1 then	strMes = "0" & strMes

strCOD_BOLETIM_ORIG = GetParam("var_cod_boletim")
strREDIRECT = GetParam("var_update")
strDT_NOVA  = GetParam("var_date")
strJSCRIPT_ACTION = GetParam("var_jscript_action")
strLOCATION       = GetParam("var_location")

strDT_BASE = ""
strDIAS_DIFER = ""

if strCOD_BOLETIM_ORIG<>"" then
	AbreDBConn objConn, CFG_DB 
	strSQL = "SELECT" &_
				"	BS.COD_CLIENTE,"	&_				
				"	BS.COD_CATEGORIA,"	&_
				"	BS.ID_RESPONSAVEL,"	&_
				"	BS.TITULO,"			&_
				"	BS.DESCRICAO,"		&_
				"	BS.SITUACAO,"		&_
				"	BS.TIPO,"			&_
				"	BS.PRIORIDADE "		&_
				"FROM "	&_
				"	BS_BOLETIM BS "		&_
				"INNER JOIN"			&_
				"	BS_CATEGORIA CAT ON (BS.COD_CATEGORIA=CAT.COD_CATEGORIA) " &_
				"WHERE"	&_
				"	BS.COD_BOLETIM = " & strCOD_BOLETIM_ORIG
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	if not objRS.Eof then
		strCOD_CLIENTE	 	= GetValue(objRS,"COD_CLIENTE")
		strCOD_CATEGORIA 	= GetValue(objRS,"COD_CATEGORIA")
		strID_RESPONSAVEL   = LCase(GetValue(objRS,"ID_RESPONSAVEL")) 
		strTITULO       	= GetValue(objRS,"TITULO")	
		strDESCRICAO    	= GetValue(objRS,"DESCRICAO")
		strSITUACAO     	= "ABERTO" 'Para não criar boletim fechado/executando
		strPRIORIDADE   	= GetValue(objRS,"PRIORIDADE")
		strTIPO  			= "NORMAL" 'GetValue(objRS,"TIPO")
	end if
	FechaRecordSet objRS
	
	'Pega a equipe do BS clonado (somente usuarios ativos)
	strSQL = "SELECT ID_USUARIO FROM BS_EQUIPE WHERE COD_BOLETIM=" & strCOD_BOLETIM_ORIG & " AND DT_INATIVO IS NULL ORDER BY ID_USUARIO "
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	strEQUIPE = ""
	while not objRS.Eof 
		strEQUIPE = strEQUIPE & LCase(GetValue(objRS,"ID_USUARIO")) & ";"
		objRS.MoveNext
	wend
	FechaRecordSet objRS
	
	'Insere um novo BS com os dados do boletim selecionado
	strDT_AGORA = "'" &	PrepDataBrToUni(Now, true) & "'"
	
	strSQL = "INSERT INTO"  	&_
				"	BS_BOLETIM (" 	&_ 
				"  	COD_CLIENTE,"	 	&_				
				"  	COD_CATEGORIA, " 	&_			
				"  	ID_RESPONSAVEL," 	&_			
				" 	TITULO,"        	&_		
				" 	DESCRICAO," 		&_
				" 	SITUACAO," 			&_
				" 	PRIORIDADE," 		&_
				"	TIPO,"			&_
				"	SYS_DTT_INS,"		&_
				"	SYS_ID_USUARIO_INS) " &_
				"VALUES ( " &_
					"'" & strCOD_CLIENTE	 	& "', " &_			
					"'" & strCOD_CATEGORIA 	& "', " &_	 			
					"'" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "', " &_				
					"'" & strTITULO       	& "', " &_
					"'" & strDESCRICAO  	 	& "', " &_
					"'" & strSITUACAO     	& "', " &_ 
					"'" & strPRIORIDADE 	 	& "', " &_ 
					"'" & strTIPO & "', " &_
					strDT_AGORA & ", " &_ 
					"'" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "') "

	'AQUI: NEW TRANSACTION
	set objRS  = objConn.Execute("start transaction")
	set objRS  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	If Err.Number <> 0 Then
	  set objRS = objConn.Execute("rollback")
	  Mensagem "modulo_BS.InsertCopia_Exec A: "& Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	  response.End()
	else
	  set objRS = objConn.Execute("commit")
	End If

	
	'Pega o código do boletim que foi criado
	strSQL =          " SELECT MAX(COD_BOLETIM) AS ULT_COD_BOLETIM "
	strSQL = strSQL & " FROM BS_BOLETIM WHERE SYS_DTT_INS = " & strDT_AGORA
	strSQL = strSQL & " AND SYS_ID_USUARIO_INS = '" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "' "
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	If Not objRS.Eof Then
		strCOD_BOLETIM_NOVO = GetValue(objRS,"ULT_COD_BOLETIM")
		
		'Insere os membros da equipe
		strEQUIPE = Split(strEQUIPE,";")	
		for i = 0 to UBound(strEQUIPE)
			strID_USUARIO = LCase(Trim(CStr(strEQUIPE(i))))
			if strID_USUARIO<>"" then		
				strSQL =          " INSERT INTO BS_EQUIPE (COD_BOLETIM, ID_USUARIO, SYS_DTT_INS, SYS_ID_USUARIO_INS) "
				strSQL = strSQL & " VALUES('" & strCOD_BOLETIM_NOVO & "','" & strID_USUARIO & "'," & strDT_AGORA & ",'" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "')"
				objConn.Execute(strSQL)
			end if
		next
		
		'Seleciona todas as tarefas do boletim clonado
		strSQL =	" SELECT" 	&_
					"	TL.ID_RESPONSAVEL,"	&_
					"	TL.ID_ULT_EXECUTOR,"&_
					"	TL.COD_CATEGORIA,"	&_
					"	TL.TITULO,"			&_
					"	TL.DESCRICAO,"		&_
					"	TL.SITUACAO,"		&_
					"	TL.PRIORIDADE,"		&_
					"	TL.PREV_HORAS,"		&_
					"	TL.PREV_DT_INI,"	&_
					"	TL.PREV_HR_INI,"	&_
					"	TL.ARQUIVO_ANEXO "	&_
 					" FROM"					&_
					"	TL_TODOLIST TL "	&_
					" WHERE"					&_
					" 	TL.COD_BOLETIM = " & strCOD_BOLETIM_ORIG &_
					" ORDER BY" 				&_		
					"	TL.PREV_DT_INI,"	&_
					"	TL.PREV_HR_INI"
					
		'athDebug strSQL, False
		
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
		
		'Insere/copia todas as tarefas do boletim clonado
		if not objRS.Eof then
			while not objRS.Eof 
				strID_RESPONSAVEL   = LCase(GetValue(objRS,"ID_RESPONSAVEL"))
				strID_ULT_EXECUTOR  = LCase(GetValue(objRS,"ID_ULT_EXECUTOR"))
				strCOD_CATEGORIA    = GetValue(objRS,"COD_CATEGORIA")
				strTITULO       	= GetValue(objRS,"TITULO")
				strDESCRICAO    	= GetValue(objRS,"DESCRICAO")
				strSITUACAO     	= "ABERTO"
				strPRIORIDADE   	= GetValue(objRS,"PRIORIDADE")
				strPREV_HORAS		= Replace(GetValue(objRS,"PREV_HORAS"),",",".")
				strPREV_DT_INI		= GetValue(objRS,"PREV_DT_INI")
				strPREV_HR_INI		= GetValue(objRS,"PREV_HR_INI")
				strARQUIVO_ANEXO	= GetValue(objRS,"ARQUIVO_ANEXO") 
				
				If strPREV_DT_INI <> "" And strDT_NOVA <> "" Then
					If strDT_BASE = "" Then strDT_BASE = strPREV_DT_INI
					If strDT_BASE <> "" Then
						'Multiplica por -1 porque diferença (dt prev - dt base) será negativa
						strDIAS_DIFER = DateDiff("D", strPREV_DT_INI, strDT_BASE) * -1
						strPREV_DT_INI = DateAdd("D", strDIAS_DIFER, strDT_NOVA)
					End If
				End If
				
				strSQL =	"INSERT INTO" 					&_
							"	TL_TODOLIST (" 				&_
							"		COD_BOLETIM,"			&_
							"		ID_RESPONSAVEL,"		&_
							"		ID_ULT_EXECUTOR,"		&_
							"		COD_CATEGORIA,"			&_
							"		TITULO,"				&_
							"		DESCRICAO,"				&_
							"		SITUACAO,"				&_
							"		PRIORIDADE,"
				
				if strPREV_HORAS <>"" then strSQL = strSQL &	"		PREV_HORAS,"
				if strPREV_DT_INI<>"" then strSQL = strSQL &	"		PREV_DT_INI,"
				if strPREV_HR_INI<>"" then strSQL = strSQL &	"		PREV_HR_INI,"
				
				strSQL = strSQL &	"		ARQUIVO_ANEXO,"	
				strSQL = strSQL &	"		SYS_DTT_INS,"
				strSQL = strSQL &	"		SYS_ID_USUARIO_INS) "
				strSQL = strSQL &	"VALUES (" 	
				strSQL = strSQL &		strCOD_BOLETIM_NOVO			& ", " 
				strSQL = strSQL &		"'" & strID_RESPONSAVEL	& "', " 
				strSQL = strSQL &		"'" & strID_ULT_EXECUTOR& "', " 
				strSQL = strSQL &		strCOD_CATEGORIA	 	& ", " 
				strSQL = strSQL &		"'" & strTITULO       	& "', " 
				strSQL = strSQL &		"'" & strDESCRICAO    	& "', " 
				strSQL = strSQL &		"'" & strSITUACAO     	& "', " 
				strSQL = strSQL &		"'" & strPRIORIDADE   	& "', " 
				
				if strPREV_HORAS <>"" then strSQL = strSQL & strPREV_HORAS & ", " 
				if strPREV_DT_INI<>"" then strSQL = strSQL & "'" & PrepDataBrToUni(strPREV_DT_INI, false) & "', " 
				if strPREV_HR_INI<>"" then strSQL = strSQL & "'" & strPREV_HR_INI & "', " 
				
				strSQL = strSQL &		"'" & strARQUIVO_ANEXO	& "', "
				strSQL = strSQL &		strDT_AGORA & ", "
				strSQL = strSQL &		"'" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "') "
				'athDebug "<br><br>" & strSQL, False
				
				'AQUI: NEW TRANSACTION
				set objRSTs  = objConn.Execute("start transaction")
				set objRSTs  = objConn.Execute("set autocommit = 0")
				objConn.Execute(strSQL)  
				If Err.Number <> 0 Then
				  set objRSTs = objConn.Execute("rollback")
				  Mensagem "modulo_BS.InsertCopia_Exec B: "& Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
				  response.End()
				else
				  set objRSTs = objConn.Execute("commit")
				End If
				
				strPREV_DT_INI = GetValue(objRS,"PREV_DT_INI")
				strPREV_HR_INI = GetValue(objRS,"PREV_HR_INI")
				
				objRS.MoveNext
			wend
		end if
	End If
	FechaRecordSet objRS
end if

'athDebug "<br><br>Update.asp?var_chavereg=" & strCOD_BOLETIM_NOVO, True

Response.Redirect("Update.asp?var_chavereg=" & strCOD_BOLETIM_NOVO)
%>