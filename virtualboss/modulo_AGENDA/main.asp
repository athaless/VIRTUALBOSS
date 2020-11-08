<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_AGENDA", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"--> 
<%
 Dim objConn, objRS, objRSAux, strSQL, strSQLClause
 Dim strTITULO, strCOD_CATEGORIA, strSITUACAO, strMES, strPRIORIDADE
 Dim strUSER_ID, strCH_RESP, strCH_CITADO
 Dim strINI, strFIM, strDIA, strANO, auxStr, strHORAS, strPREV_HORAS
 Dim strArquivo, strID_RESPONSAVEL, strCOD_AGENDA, strID_CITADOS
 Dim strGRUPOS, strGRUPO_USUARIO, strCOOKIE_ID_USUARIO
 Dim arrAG_RESPOSTAS, strCOLOR
 
 AbreDBConn objConn, CFG_DB 

 strCOOKIE_ID_USUARIO = LCase(Request.Cookies("VBOSS")("ID_USUARIO"))
 strGRUPO_USUARIO = UCase(Request.Cookies("VBOSS")("GRUPO_USUARIO"))
 strGRUPOS = "SU" 'Grupos a serem comparados

 strTITULO        = GetParam("var_titulo")
 strCOD_CATEGORIA = GetParam("var_categoria")
 strSITUACAO      = GetParam("var_situacao")
 strMES           = GetParam("var_mes")
 strANO           = GetParam("selAno")
 'strRESPONSAVEL   = UCase(GetParam("var_responsavel"))
 strPRIORIDADE    = GetParam("var_prioridade")
 strUSER_ID   	  = LCase(GetParam("var_executor"))
 strCH_RESP  	  = GetParam("var_checkresp")
 strCH_CITADO 	  = GetParam("var_checkcitado") 
	
 strSQL = "SELECT COD_AGENDA FROM AG_RESPOSTA"
 AbreRecordSet objRSAux, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
 while not objRSAux.Eof
	arrAG_RESPOSTAS = arrAG_RESPOSTAS & GetValue(objRSAux,"COD_AGENDA") & "; "
	athMoveNext objRSAux, ContFlush, CFG_FLUSH_LIMIT
 wend
 FechaRecordSet objRSAux
		
 strSQL = "SELECT"						&_
			"	T1.COD_AGENDA,"		&_
			"	T1.ARQUIVO_ANEXO,"	&_ 
			"	T1.ID_RESPONSAVEL,"	&_
			"	T1.ID_CITADOS,"		&_
			"	T1.SYS_DTT_ALT,"		&_
			"	T1.TITULO,"				&_
			"	T1.SITUACAO,"			&_
			"	T1.PREV_DT_INI,"		&_
			"	T1.PREV_HORAS,"		&_
			"	T1.PRIORIDADE,"		&_
			"	T2.NOME "				&_
			"FROM"						&_
			"	AG_AGENDA T1 "			&_
			"LEFT OUTER JOIN"			&_
			"	AG_CATEGORIA T2 ON (T1.COD_CATEGORIA = T2.COD_CATEGORIA) " &_
			"WHERE"						&_
			"	T1.COD_AGENDA=T1.COD_AGENDA"
	
if strUSER_ID <> "" then
	if (strCH_RESP = "true") and (strCH_CITADO = "true") then strSQL = strSQL & " AND (T1.ID_RESPONSAVEL = '"  & strUSER_ID & "' OR  T1.ID_CITADOS LIKE  '%;" & strUSER_ID & ";%') "
	if (strCH_RESP = "true") and (strCH_CITADO = "")     then strSQL = strSQL & " AND (T1.ID_RESPONSAVEL = '"  & strUSER_ID & "' AND T1.ID_CITADOS NOT LIKE '%;" & strUSER_ID & ";%') "
	if (strCH_RESP = "")     and (strCH_CITADO = "true") then strSQL = strSQL & " AND (T1.ID_RESPONSAVEL <>'"  & strUSER_ID & "' AND T1.ID_CITADOS LIKE '%;" & strUSER_ID & ";%') "
	if (InStr(strGRUPOS,strGRUPO_USUARIO)=0) and (strCH_RESP = "") and (strCH_CITADO = "") then 
		strSQL = strSQL & " AND COD_AGENDA IS NULL"
	elseif (strCH_RESP = "") and (strCH_CITADO = "") then
		strSQL = strSQL & " AND (T1.ID_RESPONSAVEL <>'" & strUSER_ID & "' AND T1.ID_CITADOS NOT LIKE '%;" & strUSER_ID & ";%') "
	end if
end if
	
strSQLClause=""
if (strTITULO<>"")        then strSQLClause = strSQLClause & " AND T1.TITULO LIKE '%" & strTITULO & "%'" 
if (strCOD_CATEGORIA<>"") then strSQLClause = strSQLClause & " AND T1.COD_CATEGORIA=" & strCOD_CATEGORIA 
	
if strSITUACAO<>"" then
	if InStr(1,strSITUACAO,"_")=1 then 
		auxStr = Replace(strSITUACAO,"_", " <> '",1) & "' " 	 
	else 
		auxStr = " = '" & strSITUACAO & "' " 
	end if
	strSQLClause = strSQLClause & " AND T1.SITUACAO " & auxStr 
end if
	
if strMES<>"" then
'	strANO = DatePart("YYYY", Date) 
	strINI = DateSerial(strANO, strMES, 1)
	strDIA = 31
	strFIM = DateSerial(strANO, strMES, strDIA)-1
	
	do while (not IsDate(strFIM))
	  strDIA = strDIA - 1 
	  strFIM = DateSerial(strANO, strMES, strDIA)-1
	loop 
	
	strFIM = DateAdd("d",strFIM,30) 'Exibe as tarefas agendas também para 30 dias a frente em relaçào a data e mês atual
	strSQLClause = strSQLClause & " AND ((T1.PREV_DT_INI IS NULL) OR " 
	strSQLClause = strSQLClause & "      (T1.PREV_DT_INI BETWEEN '" & PrepDataBrToUni(strINI,false) & "' AND '" & PrepDataBrToUni(strFIM,false) & "') OR " 
	strSQLClause = strSQLClause & "      (T1.PREV_DT_INI < '" & PrepDataBrToUni(strINI,false) & "' AND T1.SITUACAO <> 'FECHADO')) " 
end if

if (strSQLClause<>"") then strSQL = strSQL & strSQLClause 

strSQL = strSQL & " ORDER BY T1.PREV_DT_INI, T1.TITULO "
AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
if not objRS.Eof then	
%>
<html>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <!-- Possibilidades de tipo de sort...
  class="sortable-date-dmy"
  class="sortable-currency"
  class="sortable-numeric"
  class="sortable"
 -->
 <thead>
  <tr> 
    <th width="1%"></th>
    <th width="1%"></th>
    <th width="1%"></th>
	<!--th width="1%"></th-->
    <th width="1%"  class="sortable-date-dmy" nowrap>Prev Ini</th>
	<th width="1%"  class="sortable" nowrap>Prev Hr</th>
    <th width="1%"  class="sortable">Categoria</th>
    <th width="50%" class="sortable">Título</th>
	<th width="1%"  class="sortable">Resp</th>
    <th width="39%" class="sortable">Citados</th>
	<th width="1%"></th>
	<th width="1%"></th>
	<th width="1%"></th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%			
		while not objRS.Eof
	        strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
			
			strID_RESPONSAVEL = LCase(objRS("ID_RESPONSAVEL"))
			strID_CITADOS = LCase(GetValue(objRS,"ID_CITADOS"))
			strCOD_AGENDA = GetValue(objRS,"COD_AGENDA")
			
			if mid(strID_CITADOS,1,1)=";" then
				strID_CITADOS = mid(strID_CITADOS,2)
			end if
			
			strCOLOR   = "#DAEEFA"
			strArquivo = GetValue(objRS,"ARQUIVO_ANEXO")

			if (GetValue(objRS,"PREV_DT_INI")<now) and (GetValue(objRS,"SITUACAO")<>"FECHADO") then strCOLOR = "#FFF0F0"
		
			if (GetValue(objRS,"PREV_DT_INI")="") then 
				strCOLOR = "#FFFFFF"
			else
				if (GetValue(objRS,"PREV_DT_INI")>=Date) then
					if ((GetValue(objRS,"PREV_DT_INI")-Date)<2) and (GetValue(objRS,"SITUACAO")<>"FECHADO") then strCOLOR = "#FFFFF0"
				end if
			end if		  
%>
		<tr bgcolor=<%=strCOLOR%> valign="middle">
	 		<td width="1%">
			<% 'Responsável ou grupo SU podem excluir se não há respostas
			 if ((strID_RESPONSAVEL=strCOOKIE_ID_USUARIO) or (InStr(strGRUPOS,strGRUPO_USUARIO)>0)) and (InStr(arrAG_RESPOSTAS,strCOD_AGENDA)=0) then
			   response.write (MontaLinkGrade ("modulo_AGENDA","Delete.asp",strCOD_AGENDA,"IconAction_DEL.gif","REMOVER") )
			 end if
			%>
			</td>
			<td width="1%">
			<% 'Responsável ou grupo SU podem fazer alterações somente em "abertas"
			 if ((strID_RESPONSAVEL=strCOOKIE_ID_USUARIO) or (InStr(strGRUPOS,strGRUPO_USUARIO)>0)) and (GetValue(objRS,"SITUACAO")<>"FECHADO") then
			   response.write (MontaLinkGrade ("modulo_AGENDA","Update.asp",strCOD_AGENDA,"IconAction_EDIT.gif","ALTERAR") )
			 end if
			%>
			</td>
			<!--td width="1%">
			<% 'Usuários ou Responsável citados podem visualizar 
			  'if (InStr(LCase(strID_CITADOS),strCOOKIE_ID_USUARIO)>0) or (strID_RESPONSAVEL=strCOOKIE_ID_USUARIO) then
			  ' response.write (MontaLinkGrade ("modulo_AGENDA","Detail.asp",strCOD_AGENDA,"IconAction_DETAIL.gif","VISUALIZAR") )
			  'end if
			%>
			</td-->
			<td align="center">
			<% 'Usuários ou Responsável citados podem inserir respostas 
			  if (InStr(LCase(strID_CITADOS),strCOOKIE_ID_USUARIO)>0) or (strID_RESPONSAVEL=strCOOKIE_ID_USUARIO) then
				response.write (MontaLinkGrade ("modulo_AGENDA","DetailHistorico.asp",strCOD_AGENDA & "&var_resposta=true","IconAction_DETAILadd.gif","VISUALIZAR e INSERIR") )
			  end if
			%>
			</td>
			<td nowrap><%=PrepData(GetValue(objRS,"PREV_DT_INI"),true,false)%></td>
			<td align="right"><%=FormataHoraNumToHHMM(GetValue(objRS,"PREV_HORAS"))%></td>
			<td><%=GetValue(objRS,"NOME")%></td>
			<td><%=GetValue(objRS,"TITULO")%></td>
			<td><%=LCase(strID_RESPONSAVEL)%></td>
			<td><%=Replace(strID_CITADOS, ";", "; ")%></td>
			<td align="center"><div style="background:url(../img/IconStatus_<%=GetValue(objRS,"SITUACAO")%>.gif)   no-repeat center; width:21px;" title="SITUAÇÃO: <%=GetValue(objRS,"SITUACAO")%>"></div></td>
			<td align="center"><div style="background:url(../img/IconPrio_<%=GetValue(objRS,"PRIORIDADE")%>.gif) no-repeat center; width:21px;" title="PRIORIDADE: <%=GetValue(objRS,"PRIORIDADE")%>"></div></td>
			<td align="center">
			<%'	Arquivos em anexo não estão disponíveis 		
			  '	<%if strArquivo<>"" then><a href="../upload/<%=strArquivo>" target="_blank" style="cursor:hand;"><img src="../img/ico_clip.gif" border="0" title="Anexo"></a><%end if>
			%>
			</td>
		</tr>
	<%
			athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
		wend
	%>
	</tbody>
</table>
</body>
</html>
<%
else
	Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
end if
FechaRecordSet ObjRS
FechaDBConn objConn
%>