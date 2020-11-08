<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/md5.asp"-->
<%
 Dim objConn, objRS, objRSAux, strSQL, objRSTs
 Dim strCodigo, strTitulo, strEntidade,  dtInicio, dtFim,intQuorum
 Dim intOrdem, strQuestao, intCodQuestaoNew, intCodQuestao, intCodEnqueteNew

 strCodigo   = GetParam("var_cod_enquete")
 strTitulo   = GetParam("var_novo_titulo")
 strEntidade = GetParam("var_nova_entidade")
 intQuorum   = GetParam("var_novo_quorum")
 dtInicio    = GetParam("var_novo_dt_ini")
 dtFim       = GetParam("var_novo_dt_fim")

 AbreDBConn objConn, CFG_DB 
 
 'AQUI: NEW TRANSACTION
 set objRSTs  = objConn.Execute("start transaction")
 set objRSTs  = objConn.Execute("set autocommit = 0") 


    '-------------------------------------------------
    '1.Insere a duplicação da enquete
    '-------------------------------------------------
	strSQL = "INSERT INTO en_enquete (TITULO, TIPO_ENTIDADE, DT_INI, DT_FIM, QUORUM) VALUES('" & strTitulo & "','" & strEntidade & "','" & PrepDataBrToUni(dtInicio,true) & "','" & PrepDataBrToUni(dtFim,true) & "'," & intQuorum & ")"
    'response.Write("<strong>ENQUETE:</strong> <BR>"&strSQL &"<BR><BR><BR>")
	objConn.Execute(strSQL)
 
	'-----------------------------------------------
	'2.Busca o código da enquete recém criado
	'-----------------------------------------------
 	strSQL = "select max(cod_enquete) AS ULT_COD from en_enquete"	
	set objRS = objConn.Execute(strSQL)                                            
	intCodEnqueteNew = GetValue(objRS,"ULT_COD") 
	
	
	'-----------------------------------------------
	'2.Insere as questoes e suas alternativas
	'-----------------------------------------------
	strSQL = "SELECT cod_questao, ordem, questao FROM en_questao WHERE cod_enquete = " & strCodigo
	 '   response.Write("<strong>QUESTAO:</strong> <BR>"&strSQL &"<BR><BR><BR>")
	set objRS = objConn.Execute(strSQL)
	IF NOT objRS.eof THEN
		WHILE NOT objRS.eof 
			intOrdem = getValue(objRS,"ordem")
			strQuestao = getValue(objRS,"questao")
			intCodQuestao = getValue(objRS,"cod_questao")
	
			
			'insere a questao
			strSQL = "INSERT INTO en_questao (cod_enquete, ordem, questao)VALUES("&intCodEnqueteNew&","&intOrdem&",'"&strQuestao&"')"
		'	response.Write("<strong>QUESTAO NEW :</strong> <BR>"&strSQL &"<BR><BR><BR>")
			objConn.Execute(strSQL) 
	
			'busca codigo da ultima questao para associar as alternatinvas
			strSQL = "SELECT max(cod_questao) AS ULT_COD FROM en_questao"
			set objRSAux = objConn.Execute(strSQL)
			intCodQuestaoNew = getValue(objRSAux,"ULT_COD")

			'insere as alternativas
			strSQL = "INSERT INTO en_alternativa(COD_QUESTAO, ALTERNATIVA, TIPO, NUM_VOTOS, RESPOSTAS) (SELECT " & intCodQuestaoNew & ", ALTERNATIVA, TIPO, 0, '' FROM en_alternativa WHERE cod_questao = "&intCodQuestao&")"
		'	response.Write("<strong>ALTERNATIVA</strong> <BR>"&strSQL &"<BR><BR><BR>")
			objConn.Execute(strSQL)
			
			objRS.movenext
		WEND
	END IF

 
 set objRSTs = objConn.Execute("commit")
 'athSaveLog "COPY", Request.Cookies("VBOSS")("ID_USUARIO"), strID & " para " & strNOVO_ID, strAuxSQL

 response.write "<script>"  & vbCrlf 
 if (GetParam("JSCRIPT_ACTION") <> "")   then response.write  GetParam("JSCRIPT_ACTION") & vbCrlf end if
 if (GetParam("DEFAULT_LOCATION") <> "") then response.write "location.href='" & GetParam("DEFAULT_LOCATION") & "'" & vbCrlf
 response.write "</script>"
%>