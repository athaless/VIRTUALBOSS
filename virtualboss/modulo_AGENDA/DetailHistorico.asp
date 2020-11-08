<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
' e o tamanho da coluna dos títulos dos inputs
Dim WMD_WIDTH, WMD_WIDTHTTITLES
WMD_WIDTH = "95%"
WMD_WIDTHTTITLES = 120
' -------------------------------------------------------------------------------

Dim strSQL, objRS, ObjConn
Dim strCODIGO, strRESPOSTA, aux, auxHS, acHORAS
Dim auxSTRTITULO,auxSTRSITUACAO,auxSTRCATEGORIA,auxSTRPRIORIDADE,auxSTRRESPONSAVEL
Dim auxSTRCITADOS,auxSTRDESC,auxSTRPREV_DT_INI,auxSTRPREV_DT_FIM,auxSTRPREV_HORAS
Dim auxSTRDT_REALIZADO,auxSTRFULLCATEGORIA,auxSTRARQUIVOANEXO,auxSTRCODAGENDA, strID_TO

strCODIGO   = GetParam("var_chavereg")
strRESPOSTA = Replace(UCase(GetParam("var_resposta")),"'","''")

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
<title>vboss</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="../_css/virtualboss.css">
	<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
	<link rel="stylesheet" type="text/css" href="../_css/menupure.css">
	<script type="text/javascript" src="../_scripts/tablesort.js"></script>
	<script type="text/javascript">
		//****** Funções de ação dos botões - Início ******
		function ok()			{  }
		function cancelar()		{  }
		function aplicar()      { submeterForm(); }
		function submeterForm() { document.form_insert.submit(); }
		//****** Funções de ação dos botões - Fim ******
	</script>
</head>
<body>
<%
	'Menu Display/Block TABLEHEADER
	athBeginCssMenu()
		athCssMenuAddItem "#", "onClick=""displayArea('table_header');""", "_self", "AGENDA <strong> " & strCODIGO & " </strong> - " & auxSTRTITULO, "", 1
	athEndCssMenu("")
%>
<div id="table_header">
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tableheader">
	<!--thead>
   		<tr> 
      		<th width="150"></th>
      		<th>Dados</th>
    	</tr>
  	</thead-->
	<tbody style="text-align:left;">
		<tr><td align="right">Situação:&nbsp;</td><td><%=auxSTRSITUACAO%></td></tr>
		<tr><td align="right">Categoria:&nbsp;</td><td><%=auxSTRCATEGORIA%></td></tr>
		<tr><td align="right">Prioridade:&nbsp;</td><td><%=auxSTRPRIORIDADE%></td></tr>
		<tr><td align="right">Responsável:&nbsp;</td><td><%=auxSTRRESPONSAVEL%></td></tr>
		<tr><td align="right" style="vertical-align:top;">Citados:&nbsp;</td><td><%=LCase(Replace(auxSTRCITADOS,";","; "))%></td></tr>
		<tr><td align="right">Previsão:&nbsp;</td><td><%=auxSTRPREV_DT_INI%> <%'=auxSTRPREV_DT_FIM%>( <%=auxSTRPREV_HORAS%> )</td></tr>
		<tr><td align="right">Data Realizado:&nbsp;</td><td><%=auxSTRDT_REALIZADO%></td></tr>
		<tr id="tableheader_last_row">
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
</div>
<br />
<%
	strSQL = "SELECT COD_AG_RESPOSTA, SYS_ID_USUARIO_INS, ID_FROM, ID_TO, RESPOSTA, DTT_RESPOSTA, HORAS FROM AG_RESPOSTA " &_
	 		 "WHERE COD_AGENDA = " & strCODIGO & " ORDER BY DTT_RESPOSTA DESC" 
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	
	athBeginCssMenu()
		athCssMenuAddItem "#", "", "_self", "RESPOSTAS", "", 1
		athBeginCssSubMenu()
			athCssMenuAddItem "InsertResposta.asp?var_chavereg=" & strCODIGO & "&var_ultexec=" & auxSTRCITADOS,"", "_self", "Inserir Resposta", "div_modal", 0
		athEndCssSubMenu()
	athEndCssMenu("div_modal")
	
	if CStr(strRESPOSTA)="TRUE" then
	'Coloca-se IFRAME AQUI DENTRO
	end if

	if not objRS.Eof then 
%>
<table width="100%" border="0" align="center" cellpadding="3" cellspacing="0" class="tablesort">
	<thead>
		<tr>
			<th align="left" valign="top" width="10%"></div></th>
			<th align='left' valign='middle' width="02%" nowrap>Data</div></th>
			<th align='left' valign='middle' width="04%" nowrap>De</div></th>
			<th align='left' valign='middle' width="04%" nowrap>Para</div></th>
			<th align='left' valign='middle' width="78%">Mensagem</div></th>
			<th align='left' valign='middle' width="02%">Horas</div></th>
		</tr>
	</thead>
	<tbody>
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
				<% if objRS("SYS_ID_USUARIO_INS")<>"" and LCase(objRS("ID_FROM"))= LCase(Request.Cookies("VBOSS")("ID_USUARIO")) and aux=0 then%>
					<td align='left' valign='middle'  width="10%" height="18">
						
							<a style="cursor:hand;" onClick="window.open('delete_resp.asp?var_chavereg=<%=objRS("COD_AG_RESPOSTA")%>','','popup,width=10,height=10');">
								<img src='../img/IconAction_DEL.gif' border='0'>
							</a>
						</div>
					</td>
				<% else %>
					<td align='left' valign='middle' width="10%" nowrap height="18"></div></td>
				<% end if  %> 
					<td align='left' valign='middle' width="02%" nowrap><%=PrepData(objRS("DTT_RESPOSTA"),true,true)%></div></td>
					<td align='left' valign='middle' width="04%" nowrap><font color="#999999"><%=LCase(GetValue(objRS,"ID_FROM"))%></font></div></td>
					<td align='left' valign='middle' width="04%" nowrap><b><%=strID_TO%></b></div></td>
					<td align='left' valign='middle' width="78%"><%=strResposta%></div></td>
					<td align='left' valign='middle' width="02%"><%=FormataHoraNumToHHMM(auxHS)%></div></td>
				</tr>
			<%
				aux = 1
				acHoras = (acHoras+auxHS)
				objRS.MoveNext
			loop 
			%>
		<tr> 
			<td width="100%" height="30" colspan="6" style="text-align:right;" valign="middle">
				Total: <%=FormataHoraNumToHHMM(acHORAS)%></div>
			</td>
		</tr>
	</tbody>		
</table>
<%	
		end if 
%>
<br><br>
</body>
</html>
<%
	end if
	FechaRecordSet objRS
	FechaDBConn objConn
end if
%>