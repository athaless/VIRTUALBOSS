<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<!--#include file="../_database/athUtils.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.AddHeader "Content-Type","text/html; charset=iso-8859-1"
' VerificaDireito "|RED_BUTTON|", BuscaDireitosFromDB("modulo_DBMANAGER", Request.Cookies("VBOSS")("ID_USUARIO")), true
 
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
  
 Dim objConn, objRS, objRSAux, strSQL
 Dim auxStr
 Dim strDtInicio, strDtFim, strRespAtual, strSituacao

 strDtInicio = GetParam("var_data_inicio")
 strDtFim    = GetParam("var_data_fim")
 strSituacao = GetParam("var_situacao")
 strRespAtual = GetParam("var_resp_atual")
 'response.Write("resp: " & strRespAtual & " / sit: " & strSituacao & " / ini: " &  strDtInicio & " / fim: " & strDtFim)

if strRespAtual = "" Then
	response.End()
else 
	 AbreDBConn objConn, CFG_DB 
end if

 strSQL = "SELECT" 													&_
			"	T1.COD_TODOLIST" 									&_			
			",	T1.TITULO" 											&_			
			" FROM " 												&_
			"	TL_TODOLIST T1 " 									&_			
			"WHERE T1.ID_RESPONSAVEL = '"  & strRespAtual & "' "    			
			
if strSITUACAO <> "" then
	if InStr(strSITUACAO,"_") = 1 then 
		auxStr = Replace(strSITUACAO,"_", " <> '",1) & "' " 	 
	else 
		auxStr = " = '" & strSITUACAO & "' " 
	end if
	strSQL = strSQL & " AND T1.SITUACAO " & auxStr 
end if
if strDtInicio <> "" AND strDtFim <> "" then
	strSQL = strSQL & " AND (T1.PREV_DT_INI BETWEEN '" & PrepDataBrToUni(strDtInicio,false) & "' AND '" & PrepDataBrToUni(strDtFim,false) & "')"
end if	
'response.write(strSQL)
AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1

%>
	<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tableheader">
 	<!-- 
		Possibilidades de tipo de sort...
  		class="sortable-date-dmy"
  		class="sortable-currency"
  		class="sortable-numeric"
  		class="sortable"
 	-->
 		<!--thead>
   			<tr> 
      			<th>Dados</th>
		    </tr>
  		</thead-->
 		<tbody style="text-align:left;">
	 		<tr>				
				<td style="font-family:'Courier New', Courier, monospace; font-size:11px " nowrap>
				<% 
				if not objRS.eof then
				  while not objRS.eof
				   	response.Write("[00" & getValue(objRS,"COD_TODOLIST") & " - " & getValue(objRS,"TITULO") & "]<br>")
				   	athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
				  wend
				%>
				</td>
			 </tr>
		 </tbody>
	</table>
<% End If %>
</body>
</html>
<% FechaDBConn objConn %>
