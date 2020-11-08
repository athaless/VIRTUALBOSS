<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 Response.Expires = 0
 Dim objConn, strSQL, objRS, msgAVISO, strLOCATION
 Dim strALL_PARAMS, strCOD_ENQUETE, strID_USUARIO
 Dim auxObjCODs, auxSubCODS, auxSubVALUES, arrItemLC, arrELLC, arrItemSub ,arrItemSubVal
 Dim i

 strCOD_ENQUETE = GetParam("var_cod_enquete")
 strID_USUARIO  = GetParam("var_id_usuario")
 strALL_PARAMS  = URLDecode(Request.Form)		
 strALL_PARAMS  = Replace(Replace(Replace(strALL_PARAMS,"|",""),"'",""),"""","")
 'athDEBUG strALL_PARAMS & "<br><br>", false

	
 AbreDBConn objConn, CFG_DB

 msgAVISO = ""
 strLOCATION = "javascript:window.close();"

 If ( (strCOD_ENQUETE="") OR (strID_USUARIO="") )then 
	msgAVISO = "Falha na autenticação ou identificação da enquete de código " & strCOD_ENQUETE
 END IF

 
 'TESTE SE o USER [RECEBIDO] JA NÂO PREENCHEU ESSA ENQUETTE
 strSQL = " SELECT COUNT(COD_LOG) as VOTOU FROM en_log WHERE en_log.cod_enquete = " & strCOD_ENQUETE & " AND id_usuario LIKE '" & strID_USUARIO & "' "  
 Set objRS = objConn.Execute(strSQL)
 If (NOT objRS.EOF) then 
   If (CInt(getValue(objRS,"VOTOU")) > 0) then 
	msgAVISO = "Obrigado, <br>" & strID_USUARIO & "<br><br>Você já participou dessa enquete e será redirecionando para a página de resultados.<br><br>[<a href=enquete_result.asp?var_chavereg=" & strCOD_ENQUETE & ">Clique aqui</a>]"
   End If
 END IF

 
 if (msgAVISO="") then

	 auxObjCODs = ""
	 auxSubCODS = "" 
	 for each arrItemLC in split(strALL_PARAMS,"&")
		arrELLC = split(arrItemLC,"=")
		If instr(arrELLC(0),"var_objetiva_") > 0 then
			auxObjCODs = auxObjCODs & "," & arrELLC(1)
		ElseIf instr(arrELLC(0),"var_subjetiva_") > 0 then
			auxSubCODS = auxSubCODS & "," &  Mid(arrELLC(0),15,len(arrELLC(0))) 
			auxSubVALUES = auxSubVALUES & "|" & arrELLC(1)
		End if
	 next
	 

	 'INI: OBJETIVAS - Atualiza as votações das questões OBJETIVAS
	 auxObjCODs = Mid(auxObjCODs,2,len(auxObjCODs))
	 if (auxObjCODs<>"") then
		 strSQL = "UPDATE en_alternativa SET num_votos = num_votos + 1 WHERE cod_alternativa IN (" & auxObjCODs & ") "
		 set objRS  = objConn.Execute("start transaction")
		 set objRS  = objConn.Execute("set autocommit = 0")
		 objConn.Execute(strSQL) 
		
		 If Err.Number <> 0 Then
		  set objRS = objConn.Execute("rollback")
		  athSaveLog "UPD", strID_USUARIO, "ROLLBACK EN_ALTERNATIVAS", strSQL
		  Mensagem Err.Number & " - "& Err.Description , strLOCATION, 1, True
		 Else
		  set objRS = objConn.Execute("commit")
		  athSaveLog "UPD", strID_USUARIO, "COMMIT EN_ALTERNATIVAS", strSQL
		 End If 
	 End if
	 'FIM: OBJETIVAS ---------------------------------------------
	
	
	
	 'INI: SUBJETIVAS - Atualiza as votações das questões OBJETIVAS
	 i=0 
	 auxSubCODS = Mid(auxSubCODS,2,len(auxSubCODS))
	 auxSubVALUES = Mid(auxSubVALUES,2,len(auxSubVALUES))
	 arrItemSubVal = split(auxSubVALUES,"|")
	 if (auxSubCODS<>"") then
		for each arrItemSub in split(auxSubCODS,",")
			strSQL = "UPDATE en_alternativa SET respostas = CONCAT(COALESCE(respostas,''),' | | ','" & stripHTML(arrItemSubVal(i)) & "') WHERE cod_alternativa = " & arrItemSub
			set objRS  = objConn.Execute("start transaction")
			set objRS  = objConn.Execute("set autocommit = 0")
			objConn.Execute(strSQL)
			if Err.Number <> 0 Then
			  set objRS = objConn.Execute("rollback")
			  athSaveLog "UPD", strID_USUARIO, "ROLLBACK EN_ALTERNATIVAS", strSQL
			  Mensagem Err.Number & " - "& Err.Description , strLOCATION, 1, True
			Else
			  set objRS = objConn.Execute("commit")
			  athSaveLog "UPD", strID_USUARIO, "COMMIT EN_ALTERNATIVAS", strSQL
			End If 

			i = i + 1
			'athDEBUG strSQL & "<br><br>", false
		 next

	 End if
	 'FIM: SUBJETIVAS ---------------------------------------------
	
	
	
	 'INI: LOG - Marca no LOG que o usuário logado preencheu essa enquete
	 strSQL = "INSERT INTO en_log (COD_ENQUETE, ID_USUARIO, IP, DATA) VALUES(" & strCOD_ENQUETE & ",'" & strID_USUARIO & "', '" & Request.ServerVariables("remote_addr") & "', NOW())"
	 set objRS  = objConn.Execute("start transaction")
	 set objRS  = objConn.Execute("set autocommit = 0")
	 objConn.Execute(strSQL) 
	
	 If Err.Number <> 0 Then
	  set objRS = objConn.Execute("rollback")
	  athSaveLog "INS", strID_USUARIO, "ROLLBACK EN_LOG", strSQL
	  Mensagem Err.Number & " - "& Err.Description , strLOCATION, 1, True
	 Else
	  set objRS = objConn.Execute("commit")
	  athSaveLog "INS", strID_USUARIO, "COMMIT EN_LOG", strSQL
	 End If 
	 'FIM: LOG ---------------------------------------------
	 
'Se não abortou em nenhum dos itens acima, monto a mensagem de sucesso
	 msgAVISO = "Obrigado, <br>" & strID_USUARIO & "<br><br>" &_
	 			"Agradecemos sua participação no processo e muito valorizamos a sua opinião." &_
				"<br><br>A percepção positiva da melhoria, nos procedimentos e serviços, é um incentivo e sinalizador do acerto nos projetos desenvolvidos. " &_
				"<br><br>*Relembrando que este sistema de enquete não armazena as respostas por usuário, apenas contabliliza totais,  " &_
				"a fim de garantir o total anonimato nas respostas objetivas, e nas respostas subjetivas os textos  " &_
				"são embaralhados. Não se preocupa e abuse de sinceridade, pois sua opinião e contribuições serão  " &_
				"muito importantes para o grupo. "
 
 End IF
%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="../_css/virtualboss.css">
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" style="margin:0px; padding:0px;">
<div style="width:100%; border:0px solid #0F0; text-align:left; margin-bottom:15px; ">
    <img src="../img/LogoEnquete.gif" align="top" border="0">
</div>
<div style="width:460px; border:0px solid #0F0; text-align:left; margin-left:10px;">
	<div style="width:460px; border:0px solid #0F0; text-align:left; margin-left:10px;">
	    <div style="padding: 0px 0px 0px 10px; border:0px solid #F00; text-align:left;">
			<h3><%=msgAVISO%></h3>
	    </div>
	</div>
	<div style="margin-top:20px; padding: 10px 0px 10px 10px; border:0px solid #F00; text-align:left; background-color:#666; height:24px;"></div><br>
</div>
</body>
</html>
<%
 FechaDBConn objConn
%>