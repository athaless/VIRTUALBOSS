<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim strSQL, objRS, ObjConn
Dim strCODIGO, strRESPOSTA, aux, auxHS, acHORAS
Dim auxSTRTITULO,auxSTRSITUACAO,auxSTRCATEGORIA,auxSTRPRIORIDADE,auxSTRRESPONSAVEL
Dim auxSTRCITADOS,auxSTRDESC,auxSTRPREV_DT_INI,auxSTRPREV_DT_FIM,auxSTRPREV_HORAS
Dim auxSTRDT_REALIZADO,auxSTRFULLCATEGORIA,auxSTRARQUIVOANEXO,auxSTRCODAGENDA, strID_TO
Dim strCFG_TD_DADOS

strCFG_TD_DADOS = "align='left' valign='middle'"

strCODIGO       = GetParam("var_chavereg")
strRESPOSTA     = UCase(GetParam("var_resposta"))

if strCODIGO <> "" then
	AbreDBConn objConn, CFG_DB 

	strSQL = "SELECT" 					&_
				"	T1.COD_AGENDA," 		&_
				"	T1.ARQUIVO_ANEXO," 	&_
				"	T1.ID_RESPONSAVEL," 	&_
				"	T1.ID_CITADOS," 		&_
				"	T1.TITULO," 			&_
				"	T1.DESCRICAO," 		&_
				"	T1.SITUACAO," 			&_
				"	T1.PREV_DT_INI," 		&_
				"	T1.PREV_HORAS," 		&_
				"	T1.DT_REALIZADO," 	&_
				"	T1.PRIORIDADE," 		&_
				"	T2.COD_CATEGORIA," 	&_
				"	T2.NOME " 				&_
				"FROM" 						&_
				"	AG_AGENDA T1," 		&_
				"	AG_CATEGORIA T2 "		&_
				"WHERE" 						&_
				"	T1.COD_CATEGORIA=T2.COD_CATEGORIA AND" &_
				"	T1.COD_AGENDA=" & strCODIGO 
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1				

	if not objRS.Eof then
		auxSTRCODAGENDA     = GetValue(objRS,"COD_AGENDA")
		auxSTRTITULO        = GetValue(objRS,"TITULO")
		auxSTRSITUACAO      = GetValue(objRS,"SITUACAO")
		auxSTRCATEGORIA     = GetValue(objRS,"NOME")
		auxSTRPRIORIDADE    = GetValue(objRS,"PRIORIDADE")
		auxSTRRESPONSAVEL   = LCase(GetValue(objRS,"ID_RESPONSAVEL"))
		auxSTRCITADOS       = LCase(GetValue(objRS,"ID_CITADOS"))
		auxSTRDESC          = GetValue(objRS,"DESCRICAO")
		auxSTRPREV_DT_INI   = PrepData(GetValue(objRS,"PREV_DT_INI"),true,false)
		'auxSTRPREV_DT_FIM   = GetValue(objRS,"PREV_DT_FIM")
		auxSTRPREV_HORAS    = FormataHoraNumToHHMM(GetValue(objRS,"PREV_HORAS"))
		auxSTRDT_REALIZADO  = PrepData(GetValue(objRS,"DT_REALIZADO"),true,false)
		auxSTRFULLCATEGORIA = GetValue(objRS,"COD_CATEGORIA") & " - " & auxSTRCATEGORIA
		auxSTRARQUIVOANEXO  = GetValue(objRS,"ARQUIVO_ANEXO")
		
		if mid(auxSTRCITADOS,1,1)=";" then auxSTRCITADOS = mid(auxSTRCITADOS,2) 		  	
		
		FechaRecordSet objRS
%>
<html>
<head>
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
      <th width="150"></th>
      <th>Dados</th>
    </tr>
  </thead>
 <tbody style="text-align:left;">
    <tr><td align="right">Título:&nbsp;</td><td><%=auxSTRTITULO%></td></tr>
	<tr><td align="right">Situação:&nbsp;</td><td><%=auxSTRSITUACAO%></td></tr>
	<tr><td align="right">Categoria:&nbsp;</td><td><%=auxSTRCATEGORIA%></td></tr>
	<tr><td align="right">Prioridade:&nbsp;</td><td><%=auxSTRPRIORIDADE%></td></tr>
	<tr><td align="right">Responsável:&nbsp;</td><td><%=auxSTRRESPONSAVEL%></td></tr>
	<tr><td align="right" style="vertical-align:top;">Citados:&nbsp;</td><td><%=LCase(Replace(auxSTRCITADOS,";","; ")%></td></tr>
	<tr><td align="right">Previsão:&nbsp;</td><td><%=auxSTRPREV_DT_INI%> <%'=auxSTRPREV_DT_FIM%> ( <%=auxSTRPREV_HORAS%> )</td></tr>
	<tr><td align="right">Data Realizado:&nbsp;</td><td><%=auxSTRDT_REALIZADO%></td></tr>
	<tr>
		<td align="right">Tarefa:&nbsp;</td>
		<td>
			<%=Replace(auxSTRDESC,"<ASLW_APOSTROFE>","'")%>
			<br><br>
			<% if auxSTRARQUIVOANEXO<>"" then%>
			<a href="../upload/<%=auxSTRARQUIVOANEXO%>" style="cursor:hand;text-decoration:none;" target="new">
				<img src="../img/ico_clip.gif" border="0" title="Anexo">Ver Anexo
			</a> 
			<%
			Dim strArquivo
			strArquivo = Mid(auxSTRARQUIVOANEXO,inStr(1,auxSTRARQUIVOANEXO,"_")+1)
			strArquivo = Mid(strArquivo,inStr(1,strArquivo,"_")+1)
			%>
				(<%=strArquivo%>) 
 			<% end if %>
		</td>
	</tr>
  </tbody>
</table>
<%
 strSQL = "SELECT COD_AG_RESPOSTA, SYS_ID_USUARIO_INS, ID_FROM, ID_TO, RESPOSTA, DTT_RESPOSTA, HORAS FROM AG_RESPOSTA " &_
		 " WHERE COD_AGENDA = " & strCODIGO & " ORDER BY DTT_RESPOSTA DESC" 

 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1

  if CStr(strRESPOSTA)="TRUE" then
%>
<br>
Respostas
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <!-- Possibilidades de tipo de sort...
  class="sortable-date-dmy"
  class="sortable-currency"
  class="sortable-numeric"
  class="sortable"
 -->
 <thead>
   <tr> 
		<th width="10%"></th>
		<th width="02%" class="sortable-date-dmy" nowrap>Data</th>
		<th width="04%" class="sortable" nowrap>De</th>
		<th width="04%" class="sortable" nowrap>Para</th>
		<th width="78%" class="sortable">Mensagem</th>
		<th width="02%">Horas</th>
   </tr>
  </thead>
 <tbody style="text-align:left;">
<%
 aux = 0
 acHoras = 0			
 do while not objRS.Eof	
	strResposta = objRS("RESPOSTA")
	strID_TO = LCase(objRS("ID_FROM"))

	if mid(strID_TO,1,1)=";" then strID_TO = mid(strID_TO,2)
	if strResposta<>"" then strResposta = Replace(strResposta,"<ASLW_APOSTROFE>","'")
	if objRS("HORAS")<>"" then auxHS = objRS("HORAS")
 %>
	<tr>
		<td width="10%" height="18">
			<% if objRS("SYS_ID_USUARIO_INS")<>"" and LCase(objRS("ID_FROM"))= LCase(Request.Cookies("VBOSS")("ID_USUARIO")) and aux=0 then%>
				<a style="cursor:hand;" onClick="window.open('delete_resp.asp?var_chavereg=<%=objRS("COD_AG_RESPOSTA")%>','','popup,width=10,height=10');">
					<img src='../img/IconAction_DEL.gif' border='0'>
				</a>
			<% end if %> 
		</td>
		<td width="02%" nowrap><%=PrepData(objRS("DTT_RESPOSTA"),true,true)%></td>
		<td width="04%" nowrap><font color="#999999"><%=LCase(GetValue(objRS,"ID_FROM"))%></font></td>
		<td width="04%" nowrap><b><%=strID_TO%></b></td>
		<td width="78%"><%=strResposta%></td>
		<td width="02%"><%=FormataHoraNumToHHMM(auxHS)%></td>
	</tr>
 <%
	aux = 1
	acHoras = (acHoras+auxHS)
	objRS.MoveNext
 loop 
 %>
  </tbody>
  <tfoot>
	<tr><td colspan="6" align="right">Total: <%=FormataHoraNumToHHMM(acHORAS)%></td></tr>
  </tfoot>	
</table>
<%
	end if
%>
</body>
</html>
<%
	end if
	FechaRecordSet objRS
	FechaDBConn objConn
end if
%>