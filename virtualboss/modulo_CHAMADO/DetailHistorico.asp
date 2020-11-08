<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
' e o tamanho da coluna dos títulos dos inputs
Dim WMD_WIDTH, WMD_WIDTHTTITLES
WMD_WIDTH = 520
WMD_WIDTHTTITLES = 120
' -------------------------------------------------------------------------------
Dim strSQL, objRS, ObjConn
Dim strCODIGO, aux, auxHS, acHORAS, strCODCHAMADO
Dim strTITULO, strRESPOSTA, strSITUACAO,strCATEGORIA,strPRIORIDADE,strRESPONSAVEL, strSYSUSRINS, strCOD_CLI, strNOME_CLI
Dim strEXECUTOR,strDESC,strPREV_DT_INI,strPREV_HR_INI,strPREV_HORAS
Dim strDT_REALIZADO,strFULLCATEGORIA,strARQUIVOANEXO,strCODTODOLIST, strEXTRA
Dim strArquivo
Dim i, auxStr
Dim strEvalNota,strEvalObs,strEvalUsr

strCODIGO 	  = GetParam("var_chavereg")

if strCODIGO <> "" then
	AbreDBConn objConn, CFG_DB 
	
	strSQL =          "SELECT T1.COD_TODOLIST, T1.ARQUIVO_ANEXO, T1.ID_RESPONSAVEL, T1.ID_ULT_EXECUTOR, T1.TITULO, T5.EXTRA "
	strSQL = strSQL & "     , T1.DESCRICAO, T1.SITUACAO, T1.PREV_DT_INI, T1.PREV_HR_INI, T1.PREV_HORAS, T1.DT_REALIZADO "
	strSQL = strSQL & "     , T1.PRIORIDADE, T2.COD_CATEGORIA, T2.NOME, T5.COD_CHAMADO, T5.SYS_ID_USUARIO_INS "
	strSQL = strSQL & "     , T3.APELIDO AS APELIDO_RESPONSAVEL, T4.APELIDO AS APELIDO_ULT_EXECUTOR " 
	strSQL = strSQL & "     , T1.SYS_EVALUATE,T1.SYS_EVALUATE_OBS,T1.SYS_EVALUATE_ID_USUARIO, T5.COD_CLI, T6.NOME_FANTASIA "
	strSQL = strSQL & "  FROM TL_TODOLIST T1, TL_CATEGORIA T2, USUARIO T3, USUARIO T4, CH_CHAMADO T5, ENT_CLIENTE T6 "
	strSQL = strSQL & " WHERE T1.COD_CATEGORIA	= T2.COD_CATEGORIA " 
	strSQL = strSQL & "   AND T1.COD_TODOLIST	= " & strCODIGO 
	strSQL = strSQL & "   AND T3.ID_USUARIO		= T1.ID_RESPONSAVEL "
	strSQL = strSQL & "   AND T4.ID_USUARIO		= T1.ID_ULT_EXECUTOR "
	strSQL = strSQL & "   AND T1.COD_TODOLIST	= T5.COD_TODOLIST "
	strSQL = strSQL & "   AND T5.COD_CLI		= T6.COD_CLIENTE "
	
	strSQL = strSQL & " ORDER BY T1.PREV_DT_INI, T1.SYS_DTT_INS, T1.SYS_DTT_ALT "	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	If not objRS.eof then 
		strCODTODOLIST   = GetValue(objRS,"COD_TODOLIST")
		strCODCHAMADO    = GetValue(objRS,"COD_CHAMADO")
		strTITULO        = GetValue(objRS,"TITULO")
		strSITUACAO      = GetValue(objRS,"SITUACAO")
		strCATEGORIA     = GetValue(objRS,"NOME")
		strPRIORIDADE    = GetValue(objRS,"PRIORIDADE")
		strRESPONSAVEL   = LCase(GetValue(objRS,"APELIDO_RESPONSAVEL"))
		strEXECUTOR      = LCase(GetValue(objRS,"APELIDO_ULT_EXECUTOR"))
		strDESC          = GetValue(objRS,"DESCRICAO")
		strPREV_DT_INI   = PrepData(GetValue(objRS,"PREV_DT_INI"),true,false)
		strPREV_HR_INI   = GetValue(objRS,"PREV_HR_INI")
		strPREV_HORAS    = FormataHoraNumToHHMM(GetValue(objRS, "PREV_HORAS"))
		strDT_REALIZADO  = PrepData(GetValue(objRS,"DT_REALIZADO"),true,false)
		strFULLCATEGORIA = GetValue(objRS,"COD_CATEGORIA") & " - " & strCATEGORIA
		strARQUIVOANEXO  = GetValue(objRS,"ARQUIVO_ANEXO")
		strEXTRA		 = GetValue(objRS,"EXTRA")
		strSYSUSRINS     = GetValue(objRS,"SYS_ID_USUARIO_INS")
		strCOD_CLI		 = GetValue(objRS,"COD_CLI")
		strNOME_CLI      = GetValue(objRS,"NOME_FANTASIA")
		
		strEvalObs		 = GetValue(objRS,"SYS_EVALUATE_OBS")
		strEvalUsr		 = GetValue(objRS,"SYS_EVALUATE_ID_USUARIO")
		strEvalNota		 = GetValue(objRS,"SYS_EVALUATE")
		
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
	<!-- estilo abaixo precisa ficar nesse arquivo porque é específico da página -->
	<!-- será usado para abrir e fechar uma área, se tiver mais de uma, cada uma terá de ter um nome -->
	<script type="text/javascript">
		/****** Funções de ação dos botões - Início ******/
		function ok()       { document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
		function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
		function aplicar()  { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
		function submeterForm() {
			var var_msg = '';
			if (document.form_insert.var_to.value == '')        var_msg += '\nPara';
			if (document.form_insert.var_resposta.value == '')  var_msg += '\nResposta';
			if (var_msg == ''){
				document.form_insert.submit();
			} else{
				alert('Favor verificar campos obrigatórios:\n' + var_msg);
			}
		}
		/****** Funções de ação dos botões - Fim ******/
	</script>
</head>
<body>
<%
	'Concatenamos o link corretamente para os casos
	'onde o redirect tenha sido informado ou não
	athBeginCssMenu()
		athCssMenuAddItem "#", "onClick=""displayArea('table_header');""", "_self", "CHAMADO <strong>" & strCODCHAMADO & "</strong> - " & strCODTODOLIST & " | " & strTITULO, "", 0
	athEndCssMenu("") 
%>
<!-- C6DBD6 -->
<div id="table_header" style="width:100%">
	<table border="0" cellpadding="0" cellspacing="1" class="tableheader">
		<tbody>
			<tr>
            	<td>&nbsp;</td>
                <td>
                	<%
						'Como histórico, no campo [sys_evaluate_obs], armazenamos o LOG - data/hora, user, nota e observação anterior). 
						'Nesta Details aqui [DetailHistórico.asp] devemos tratar o valor do campo observação para mostar somente a última observação.
						strEvalObs = Replace(strEvalObs,"<ASLW_APOSTROFE>","'")
						If strEvalObs<>"" then 
							strEvalObs = Mid(strEvalObs,1,instr(strEvalObs,"<!--LOG_EVALUATE ")-1)
						End if
					%>                
                    <div style="cursor:pointer" title="<%if (strEvalObs<>"") then response.write(strEvalUsr & " diz: " & strEvalObs) End if%>">
					<img src="../img/IconStatus_EVAL<%=strEvalNota%>.png" alt="nota <%=strEvalNota%>/10" title="nota <%=strEvalNota%>/10">
                    <!-- <img src='../img/Evaluate_Scale.gif' height="67"><br>
                    	<% for i = 1 to 10 
                        	auxStr = "<img src='../img/evaluate"
							If (i <= Cint(strEvalNota)) Then
								auxStr = auxStr & "_on"
							Else 
								auxStr = auxStr & "_off"
							End if	
							auxStr = auxStr & ".png' height='14'>"
							Response.write (auxStr)
                           next 
						%>  
                     //-->   
                    </div>
                </td>
            </tr>
			<tr><td>Situação:&nbsp;</td><td><%=strSITUACAO%>&nbsp;&nbsp;</td></tr>
			<tr><td>Categoria:&nbsp;</td><td><%=strCATEGORIA%></td></tr>
			<tr><td>Prioridade:&nbsp;</td><td><%=strPRIORIDADE%></td></tr>
			<tr><td>Responsável:&nbsp;</td><td><%=strRESPONSAVEL%> <%'IF (strSYSUSRINS<>strRESPONSAVEL) THEN RESPONSE.WRITE("&nbsp;<span title='Inserido por este usuário.' style='cursor:pointer'><small>(" & strSYSUSRINS & ")</small></span>") END IF%></td></tr>
			<tr><td>Últ Executor:&nbsp;</td><td><%=strEXECUTOR%></td></tr>
			<tr><td>Previsão:&nbsp;</td><td><%=strPREV_DT_INI%>&nbsp;&nbsp;<%=strPREV_HR_INI%>&nbsp;&nbsp;(&nbsp;<%=strPREV_HORAS%>&nbsp;)</td></tr>
			<tr><td>Data Realizado:&nbsp;</td><td><%=strDT_REALIZADO%></td></tr>
            <tr>
				<td>Cliente:&nbsp;</td>
				<td><%=strCOD_CLI%> - <%=strNOME_CLI%></td>
			</tr>

			<tr><td valign="top" style="vertical-align:top;">Tarefa:&nbsp;</td><td><%=Replace(Replace(strDESC,"<ASLW_APOSTROFE>","'"),CHR(13),"<br>")%></td></tr>
			<tr><td>Extra:&nbsp;</td><td><%=strEXTRA%></td></tr>
			<% if strARQUIVOANEXO <> "" then %>
			<tr>
				<td valign="top" style="vertical-align:top;">Documento:&nbsp;</td>
				<td><a href="../athdownloader.asp?var_cliente=<%=Request.Cookies("VBOSS")("CLINAME")%>&var_tipo=TODO_Anexos&var_arquivo=<%=strARQUIVOANEXO%>" style="cursor:hand;text-decoration:none;" target="_blank"><img src="../img/ico_clip.gif" border="0" title="Documento" alt="Documento">&nbsp;VISUALIZAR&nbsp;</a><small>&nbsp;&nbsp;<%=ucase(Replace(strARQUIVOANEXO,"}_","}_<b>")&"</b>")%></small>
				

			<% 
				'Response.Write("<a href='../upload/" & Request.Cookies("VBOSS")("CLINAME") & "/TODO_Anexos/" & strARQUIVOANEXO & "' style='cursor:hand;text-decoration:none;' target='new'>")
				'Response.Write("<img src='../img/ico_clip.gif' border='0' title='Anexo'>VISUALIZAR</a>")
				
				'strArquivo = Mid(strARQUIVOANEXO,inStr(1,strARQUIVOANEXO,"_")+1)
				'strArquivo = Mid(strArquivo,inStr(1,strArquivo,"_")+1)
				
				'Response.Write("&nbsp;(" & strArquivo & ")")
			%>				
				
				</td>
			</tr>
			<% end if %>
			<% 
			   ' Faz a busca dos arquivos anexos deste CHAMADO
			   ' Se tem algum anexo monta a estrutura
				strSQL = "SELECT COD_ANEXO, COD_CHAMADO, ARQUIVO, DESCRICAO FROM CH_ANEXO WHERE COD_CHAMADO = " & strCODCHAMADO & " ORDER BY SYS_DTT_INS " 
				AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
			
			   	if not objRS.eof then 
			%>
			<tr><td>&nbsp;</td><td><hr></td></tr>
			<tr>
				<td valign="top" style="vertical-align:top;">Anexos:&nbsp;</td>
				<td>
				 <%
				  do while not objRS.Eof
				 %>
				 <div style="margin-bottom:10px;">
					 <div>
						<a href="../athdownloader.asp?var_cliente=<%=Request.Cookies("VBOSS")("CLINAME")%>&var_tipo=TODO_Anexos&var_arquivo=<%=GetValue(objRS, "ARQUIVO")%>" style="cursor:hand;text-decoration:none;" target="_blank"><img src="../img/ico_clip.gif" border="0" title="Documento" alt="Documento">&nbsp;DOWNLOAD&nbsp;</a>&nbsp;&nbsp;<%=ucase(Replace(GetValue(objRS, "ARQUIVO"),"}_","}_<b>")&"</b>")%>	
					 </div>
					 <div>
						<%=GetValue(objRS, "DESCRICAO")%>
					 </div>
				 </div>
				<%
				 objRS.MoveNext
				 loop 
				%>
				</td>
			</tr>
			<%  end if %>
			<tr><td colspan="2" height="5"></td></tr>
		</tbody>
	</table>
</div>
<br>

<% 
		strSQL =          " SELECT T1.COD_TL_RESPOSTA, T1.SYS_ID_USUARIO_INS, T1.ID_FROM, T1.ID_TO "
		strSQL = strSQL & "      , T1.RESPOSTA, T1.SIGILOSO, T1.DTT_RESPOSTA, T1.HORAS "
		strSQL = strSQL & "      , T2.APELIDO AS APELIDO_FROM, T3.APELIDO AS APELIDO_TO, T1.ARQUIVO_ANEXO " 
		strSQL = strSQL & " FROM TL_RESPOSTA T1 "
		strSQL = strSQL & " INNER JOIN USUARIO T2 ON (T2.ID_USUARIO = T1.ID_FROM) "
		strSQL = strSQL & " INNER JOIN USUARIO T3 ON (T3.ID_USUARIO = T1.ID_TO) "
		strSQL = strSQL & " WHERE T1.COD_TODOLIST = " & strCODIGO 
		strSQL = strSQL & " ORDER BY T1.DTT_RESPOSTA DESC " 
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1

		'Montagem do MENU DETAIL
		athBeginCssMenu()
			athCssMenuAddItem "", "", "_self", "RESPOSTAS", "", 1
			athBeginCssSubMenu()
		    	athCssMenuAddItem "InsertResposta.asp?var_chavereg="& strCODIGO &"&var_ultexec="& strEXECUTOR, "", "_self", "Inserir Resposta", "div_modal", 0
			athEndCssSubMenu()
		athEndCssMenu("div_modal")
	
		if not objRS.eof then 
%>
<table style="width:100%;" border="0" align="center" cellpadding="0" cellspacing="1" class="tablesort">
	<thead>
		<tr>
			<th align='left' valign='top' nowrap width="10%"></th>
			<th align='left' valign='top' nowrap width="02%">Data</th>
			<th align='left' valign='top' width="04%">De</th>
			<th align='left' valign='top' width="04%">Para</th>
			<th align="left" valign="top" width="77%">Mensagem</th>
			<th align='left' valign='top' nowrap width="02%">Horas</th>
			<th align='left' valign='top' nowrap width="01%"></th>
		</tr>
	</thead>
	<tbody style="text-align:left">
<%
				aux = 0
				acHoras = 0
				do while not objRS.Eof 
					strRESPOSTA = GetValue(objRS,"RESPOSTA")
					if strRESPOSTA <> "" then
						strRESPOSTA = Replace(strRESPOSTA,"<ASLW_APOSTROFE>","'")
						strRESPOSTA = Replace(strRESPOSTA,CHR(13),"<br>")
					end if
					auxHS = 0
					if GetValue(objRS,"HORAS")<>"" then auxHS = GetValue(objRS,"HORAS")
%>
				<tr>
					<td></td>
					<td align='left' valign='top' width="02%" nowrap="nowrap"><div><%=PrepData(GetValue(objRS,"DTT_RESPOSTA"),true,true)%></div></td>
					<td align='left' valign='top' width="04%"><div style="color:#999999;"><% if GetValue(objRS,"SYS_ID_USUARIO_INS")<>"" then Response.Write LCase(GetValue(objRS,"APELIDO_FROM"))%></div></td>
					<td align='left' valign='top' width="04%"><div><b><%if GetValue(objRS,"SYS_ID_USUARIO_INS")<>"" then Response.Write LCase(GetValue(objRS,"APELIDO_TO"))%></b></div></td>
					<td align="left" valign="middle" width="78%"><div><%=strResposta%>
					<% If GetValue(objRS,"SIGILOSO") <> "" Then %>
						<% If strResposta <> "" Then %><br><br><% End If %> 
						<% If GetValue(objRS,"ID_FROM") = LCase(Request.Cookies("VBOSS")("ID_USUARIO")) Or GetValue(objRS,"ID_TO") = LCase(Request.Cookies("VBOSS")("ID_USUARIO")) Then %>
							<font color="#999999"><%=GetValue(objRS,"SIGILOSO")%></font>
						<% Else %>
							<font color="#999999">****************</font>
						<% End If %>
					<% End If %>
					</div></td>
					<td style="text-align:right;" valign="top" width="02%"><div><%=FormataHoraNumToHHMM(auxHS)%></div></td>
					<td style="text-align:center;" valign="top">
					<% If GetValue(objRS, "ARQUIVO_ANEXO") <> "" Then %>
						<a href="../athdownloader.asp?var_cliente=<%=Request.Cookies("VBOSS")("CLINAME")%>&var_tipo=RESPOSTA_Anexos&var_arquivo=<%=GetValue(objRS, "ARQUIVO_ANEXO")%>" target="_blank" style="cursor:hand;"><img src="../img/ico_clip.gif" border="0" title="Anexo"></a>
					<% End If %>
					</td>
				</tr>
<%
					aux = 1
					acHoras = (acHoras + auxHS)
					objRS.MoveNext
				loop 
%>
			</tbody>
            <tfoot>
				<tr><td style="text-align:right;"height="30px" colspan="7" width="100%" valign="middle"><div>Total: <%=FormataHoraNumToHHMM(acHORAS)%></div></td></tr>
			</tfoot>
			</table>
<%	end if %>
<br><br>
</body>
</html>
<%
	end if 
	FechaRecordSet objRS
	FechaDBConn objConn
end if
%>