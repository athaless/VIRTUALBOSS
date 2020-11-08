<%
	Dim objRSCTMsLoc
	if strCODIGO <> "" then 
    	strSQL =          " UPDATE MSG_PASTA "
		strSQL = strSQL & " SET LIDO = 1, DT_LIDO = '" & PrepDataBrToUni(Date, True) & "' " 
		strSQL = strSQL & " WHERE COD_MENSAGEM = " & strCODIGO 
		strSQL = strSQL & " AND PASTA = '" & strPasta & "'" 
		strSQL = strSQL & " AND LIDO = 0 "
		strSQL = strSQL & " AND COD_USER='" & Request.Cookies("VBOSS")("ID_USUARIO") & "'"

		'AQUI: NEW TRANSACTION
		set objRSCTMsLoc  = objConn.Execute("start transaction")
		set objRSCTMsLoc  = objConn.Execute("set autocommit = 0")
		objConn.execute(strSQL)
		If Err.Number <> 0 Then
			set objRSCTMsLoc = objConn.Execute("rollback")
			Mensagem "_IncludeMsgAbre: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
			Response.End()
		else
			set objRSCTMsLoc = objConn.Execute("commit")
		End If
		
		strSQL = 	      " SELECT COUNT(MSG_ANEXO.COD_MSG_ANEXO) AS TOTAL " 
		strSQL = strSQL & " FROM MSG_ANEXO "
		strSQL = strSQL & " WHERE COD_MENSAGEM = " & strCODIGO		
		Set objRS = objConn.execute(strSQL)
		
		strANEXOS = "" 
		if not objRS.Eof then strANEXOS = GetValue(objRS, "TOTAL")

		FechaRecordSet objRS
		
		if not IsNumeric(strANEXOS) then strANEXOS = 0 
		
		strSQL = 	      " SELECT MSG_MENSAGEM.COD_MENSAGEM "
		strSQL = strSQL & "      , MSG_REMETENTE.COD_USER_REMETENTE "
		strSQL = strSQL & "      , MSG_DESTINATARIO.COD_USER_DESTINATARIO "
		strSQL = strSQL & "      , MSG_MENSAGEM.ASSUNTO, MSG_MENSAGEM.DT_ENVIO, MSG_PASTA.DT_LIDO, MSG_MENSAGEM.MENSAGEM "
		strSQL = strSQL & " FROM  MSG_MENSAGEM, MSG_PASTA, MSG_DESTINATARIO, MSG_REMETENTE "
		strSQL = strSQL & " WHERE MSG_MENSAGEM.COD_MENSAGEM = " & strCODIGO
		strSQL = strSQL & " AND MSG_MENSAGEM.COD_MENSAGEM = MSG_PASTA.COD_MENSAGEM "
		strSQL = strSQL & " AND MSG_MENSAGEM.COD_MENSAGEM = MSG_DESTINATARIO.COD_MENSAGEM "
		strSQL = strSQL & " AND MSG_MENSAGEM.COD_MENSAGEM = MSG_REMETENTE.COD_MENSAGEM "
		
		strSQLAux = 			" SELECT DEST.COD_USER_DESTINATARIO AS DESTINATARIO"
		strSQLAux = strSQLAux &	" FROM MSG_DESTINATARIO DEST "
		strSQLAux =	strSQLAux &	"    , MSG_MENSAGEM MENS "
		strSQLAux =	strSQLAux &	"    , MSG_REMETENTE REM "
		strSQLAux =	strSQLAux &	" WHERE DEST.COD_MENSAGEM = " & strCODIGO
		strSQLAux =	strSQLAux &	"   AND REM.COD_MENSAGEM = DEST.COD_MENSAGEM"	
		strSQLAux =	strSQLAux &	"   AND REM.COD_MENSAGEM = MENS.COD_MENSAGEM"	
		strSQLAux =	strSQLAux &	" ORDER BY DEST.COD_USER_DESTINATARIO "
		
		Set objRS 	 = objConn.execute(strSQL)
		Set objRSAux = objConn.execute(strSQLAux)
		
		If Not objRS.Eof Then
%>
<blockquote dir="ltr" style="padding-right:0px;  padding-left:5px;  border-left:#000000 2px solid;  margin-right:0px; ">
	 <div style="font: 11px arial; ">----- Original Message -----</div>
	 <div style="background:#E4E4E4; font: 11px arial;  color:#000000; "><b>De: </b><%=GetValue(objRS, "COD_USER_REMETENTE")%></div>
	 <div style="font: 11px arial; "><b>Para:  </b>
		<%  
		  do while (not objRSAux.Eof) 					  
			Response.Write Trim(objRSAux("DESTINATARIO"))
			objRSAux.MoveNext
			if not objRSAux.Eof then Response.Write "; "		
		  loop 
		%>
	 </div>
	 <div style="font: 11px arial; "><b>Enviado:</b><%=DiaSemana(WeekDay(GetValue(objRS, "DT_ENVIO"))) & ", " & DataExtenso(GetValue(objRS, "DT_ENVIO"))%>, <%=ATHFormataTamLeft(DatePart("H", GetValue(objRS, "DT_ENVIO")), 2, "0")%>:<%=ATHFormataTamLeft(DatePart("N", GetValue(objRS, "DT_ENVIO")), 2, "0")%>:<%=ATHFormataTamLeft(DatePart("S", GetValue(objRS, "DT_ENVIO")), 2, "0")%></div>
	 <div style="font: 11px arial; "><b>Assunto:</b><%=GetValue(objRS, "ASSUNTO")%></div>
	 <% if strANEXOS > 0 then %>
		<div style="font: 11px arial; "><b>Anexos:</b>
		<iframe name="iframeAnexos" src="msgShowAnexos.asp?var_cod_mensagem=<%=GetValue(objRS, "COD_MENSAGEM")%>" height="50" width="300" scrolling="auto" style="border:1px solid #999999;"></iframe>
		</div>
	 <% end if %>
	 <div><br></div>
	 <div style="font: 11px arial; ">
		<%
			auxStr = GetValue(objRS, "MENSAGEM")
			auxStr = Replace(auxStr,Chr(13),"<br>")
			auxStr = Replace(auxStr,";","; ")
			response.write auxStr
		%>	
	 </div>
</blockquote>
<%
	else
		Mensagem "Mensagem não foi encontrada", "",  "", True
	end if
		
	FechaRecordSet objRS
	FechaRecordSet objRSAux
 else
	Mensagem "Nenhuma mensagem selecionada", "",  "", True
 end if
%>