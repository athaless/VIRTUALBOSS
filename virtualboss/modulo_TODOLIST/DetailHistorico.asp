<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%

 Const WMD_WIDTHTTITLES = 150

Dim strSQL, objRS, ObjConn
Dim strCODIGO, strRESPOSTA, aux, auxHS, acHORAS
Dim strTITULO,strSITUACAO,strCATEGORIA,strPRIORIDADE,strRESPONSAVEL
Dim strCODBOLETIM, strTITULOBOLETIM
Dim strEXECUTOR,strDESC,strPREV_DT_INI,strPREV_HR_INI,strPREV_HORAS,strDTT_INS, strCOD_CLI, strNOME_CLI
Dim strDT_REALIZADO,strFULLCATEGORIA,strARQUIVO_ANEXO,strCODTODOLIST, strCATEGORIA_CHAMADO
Dim strLinkDetail
Dim auxDIREITOS, bInsRespTODO

strCODIGO   = GetParam("var_chavereg")
strRESPOSTA = UCase(GetParam("var_resposta"))

auxDIREITOS  = BuscaDireitosFromDB("modulo_TODOLIST", Request.Cookies("VBOSS")("ID_USUARIO"))
bInsRespTODO = VerificaDireito("|INS_RESP|", auxDIREITOS, false)

if strCODIGO <> "" then
	AbreDBConn objConn, CFG_DB 
	
	strSQL =          "SELECT T1.COD_TODOLIST, T1.ARQUIVO_ANEXO, T1.ID_RESPONSAVEL, T1.ID_ULT_EXECUTOR, T1.TITULO "
	strSQL = strSQL & "     , T1.DESCRICAO, T1.SITUACAO, T1.PREV_DT_INI, T1.PREV_HR_INI, T1.PREV_HORAS, T1.DT_REALIZADO "
	strSQL = strSQL & "     , T1.PRIORIDADE, T2.COD_CATEGORIA, T2.NOME, T3.TITULO AS TIT_BOLETIM, T1.COD_BOLETIM, T1.SYS_DTT_INS, T1.COD_CLI, T4.NOME_FANTASIA  " 
	strSQL = strSQL & "  FROM TL_TODOLIST T1 "
	strSQL = strSQL & " INNER JOIN TL_CATEGORIA T2 ON (T1.COD_CATEGORIA = T2.COD_CATEGORIA) "
	strSQL = strSQL & "  LEFT JOIN BS_BOLETIM   T3 ON (T1.COD_BOLETIM   = T3.COD_BOLETIM) "
	strSQL = strSQL & "  LEFT JOIN ENT_CLIENTE  T4 ON (T1.COD_CLI = T4.COD_CLIENTE) "
	strSQL = strSQL & " WHERE T1.COD_TODOLIST = " & strCODIGO 
	strSQL = strSQL & " ORDER BY (T1.PREV_DT_INI), T1.SYS_DTT_INS, T1.SYS_DTT_ALT"	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	if not objRS.eof then 
		'Dados da tarefa
		strCODTODOLIST   = GetValue(objRS,"COD_TODOLIST")
		strTITULO        = GetValue(objRS,"TITULO")
		strCODBOLETIM    = GetValue(objRS,"COD_BOLETIM")
		strTITULOBOLETIM = GetValue(objRS,"TIT_BOLETIM")
		strSITUACAO      = GetValue(objRS,"SITUACAO")
		strCATEGORIA     = GetValue(objRS,"NOME")
		strPRIORIDADE    = GetValue(objRS,"PRIORIDADE")
		strRESPONSAVEL   = LCase(GetValue(objRS,"ID_RESPONSAVEL"))
		strEXECUTOR      = LCase(GetValue(objRS,"ID_ULT_EXECUTOR"))
		strDESC          = GetValue(objRS,"DESCRICAO")
		strPREV_DT_INI   = PrepData(GetValue(objRS,"PREV_DT_INI"),true,false)
		strPREV_HR_INI   = GetValue(objRS,"PREV_HR_INI")
		strPREV_HORAS    = FormataHoraNumToHHMM(GetValue(objRS, "PREV_HORAS"))
		strDT_REALIZADO  = PrepData(GetValue(objRS,"DT_REALIZADO"),true,false)
		strFULLCATEGORIA = GetValue(objRS,"COD_CATEGORIA") & " - " & strCATEGORIA
		strARQUIVO_ANEXO = GetValue(objRS,"ARQUIVO_ANEXO")
		strDTT_INS       = GetValue(objRS,"SYS_DTT_INS")
		strCOD_CLI       = GetValue(objRS,"COD_CLI")
		strNOME_CLI      = GetValue(objRS,"NOME_FANTASIA")
		
		FechaRecordSet objRS
		
		'Consulta dados da Categoria do CHAMADO
		strCATEGORIA_CHAMADO = ""
		strSQL =          " SELECT T2.NOME "
		strSQL = strSQL & " FROM CH_CHAMADO T1, CH_CATEGORIA T2 "
		strSQL = strSQL & " WHERE T1.COD_CATEGORIA = T2.COD_CATEGORIA "
		strSQL = strSQL & "   AND T1.COD_TODOLIST = " & strCODTODOLIST
		
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		if not objRS.eof then 
			strCATEGORIA_CHAMADO = GetValue(objRS,"NOME")
			
			if strCATEGORIA_CHAMADO <> "" then
				strCATEGORIA = strCATEGORIA & " (" & strCATEGORIA_CHAMADO & ")"
			end if
			FechaRecordSet objRS
		end if
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
		//****** Funções de ação dos botões - Início ******
		function ok2()       { document.form_upd_dt_prev.DEFAULT_LOCATION.value = ""; submeterForm2(); }
		function cancelar2() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
		function aplicar2()  { document.form_upd_dt_prev.JSCRIPT_ACTION.value = ""; submeterForm2(); }
		function submeterForm2() {
			var var_msg = '';
			//if (document.form_upd_dt_prev.var_motivo.value == '')    var_msg += '\nPara';
			//if (document.form_upd_dt_prev.var_resposta.value == '')  var_msg += '\nResposta';
			
			if (var_msg == '')
				document.form_upd_dt_prev.submit();
			else
				alert('Favor verificar campos obrigatórios:\n' + var_msg);
		}
		/****** Funções de ação dsos botões - Fim ******/
	</script>
</head>
<body>
<%
	'Concatenamos o link corretamente para os casos
	'onde o redirect tenha sido informado ou não
	athBeginCssMenu()
		athCssMenuAddItem "#", "onClick=""displayArea('table_header');""", "_self", "TAREFA <strong>" & strCODIGO & "</strong> - " & strTITULO, "", 0
	athEndCssMenu("")
%>
<!-- C6DBD6 -->
<div id="table_header" style="width:100%">
	<table border="0" cellpadding="0" cellspacing="1" class="tableheader">
		<tbody>
			<% If strCODBOLETIM<>"" then %>
			<tr>
				<td>ATIVIDADE/BS:&nbsp;</td>
				<td><%=strCODBOLETIM & " - " & strTITULOBOLETIM%></td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<% End If %>
			<tr>
				<td>Situação:&nbsp;</td>
				<td><%=strSITUACAO%></td>
			</tr>
			<tr>
				<td>Categoria:&nbsp;</td>
				<td><%=strCATEGORIA%></td>
			</tr>
			<tr>
				<td>Prioridade:&nbsp;</td>
				<td><%=strPRIORIDADE%></td>
			</tr>
			<tr>
				<td>Responsável:&nbsp;</td>
				<td><%=strRESPONSAVEL%></td>
			</tr>
			<tr>
				<td>Executor Atual:&nbsp;</td>
				<td><%=strEXECUTOR%></td>
			</tr>
			<tr>
				<td title="(ref. <%=strDTT_INS%>)">Previsão:&nbsp;</td>
				<td><%=strPREV_DT_INI%>&nbsp;&nbsp;<%=strPREV_HR_INI%>&nbsp;&nbsp;(&nbsp;<%=strPREV_HORAS%>&nbsp;)</td>
			</tr>
			<tr>
				<td>Data Realizado:&nbsp;</td>
				<td><%=strDT_REALIZADO%></td>
			</tr>
			<%If (strCOD_CLI<>"") then %>
            <tr>
				<td>Cliente:&nbsp;</td>
				<td><%=strCOD_CLI%> - <%=strNOME_CLI%></td>
			</tr>
            <%End if%>
			<tr id="tableheader_last_row">
				<td>Tarefa:&nbsp;</td>
				<td style="background-color:#E7EFF1;border:#E7EFF1;"><%=Replace(Replace(strDESC,"<ASLW_APOSTROFE>","'"),CHR(13),"<br>")%><br></td>
			</tr>
			<% if strARQUIVO_ANEXO <> "" then %>
			<tr>
				<td>Documento:&nbsp;</td>
				<td><a href="../athdownloader.asp?var_cliente=<%=Request.Cookies("VBOSS")("CLINAME")%>&var_tipo=TODO_Anexos&var_arquivo=<%=strARQUIVO_ANEXO%>" style="cursor:hand;text-decoration:none;" target="_blank"><img src="../img/ico_clip.gif" border="0" title="Documento" alt="Documento">&nbsp;DOWNLOAD&nbsp;</a><small>&nbsp;&nbsp;<%=ucase(Replace(strARQUIVO_ANEXO,"}_","}_<b>")&"</b>")%></small></td>
			</tr>
			<% end if %>
			<% 
			   ' Faz a busca dos arquivos anexos deste TODO
			   ' Se tem algum anexo monta a estrutura
				strSQL = "SELECT COD_ANEXO, COD_TODOLIST, ARQUIVO, DESCRICAO FROM TL_ANEXO WHERE COD_TODOLIST = " & strCODIGO & " ORDER BY SYS_DTT_INS " 
				'response.write strSQL
				AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
			
			   	if not objRS.eof then 
			%>
			<tr><td>&nbsp;</td><td><hr></td></tr>
			<tr>
				<td style="vertical-align:top;">Anexos:&nbsp;</td>
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
	end if 
	strSQL = "SELECT COD_TL_RESPOSTA, SYS_ID_USUARIO_INS, ID_FROM, ID_TO, RESPOSTA, SIGILOSO, DTT_RESPOSTA, HORAS, ARQUIVO_ANEXO FROM TL_RESPOSTA " 
	strSQL = strSQL & " WHERE COD_TODOLIST = " & strCODIGO & " ORDER BY DTT_RESPOSTA DESC " 
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1


	'Montagem do MENU DETAIL
    if (bInsRespTODO AND (LCase(strEXECUTOR) = LCase(Request.Cookies("VBOSS")("ID_USUARIO")) OR LCase(strRESPONSAVEL) = LCase(Request.Cookies("VBOSS")("ID_USUARIO")) OR Request.Cookies("VBOSS")("GRUPO_USUARIO") = "MANAGER")) then 
		athBeginCssMenu()
			athCssMenuAddItem "", "", "_self", "RESPOSTAS", "", 1
			athBeginCssSubMenu()
				athCssMenuAddItem "InsertResposta.asp?var_chavereg="& strCODIGO &"&var_ultexec="& strEXECUTOR, "", "_self", "Inserir Resposta", "div_modal", 0
				athCssMenuAddItem "Update_DataPrevista.asp?var_chavereg="& strCODIGO, "", "_self", "Alterar Data Prevista", "div_modal", 0
			athEndCssSubMenu()
		athEndCssMenu("div_modal")
	end if 

	if not objRS.eof then 
%>
	
<table style="width:100%;" border="0" align="center" cellpadding="0" cellspacing="1" class="tablesort">
	<thead>
		<tr>
			<th align='left' valign='top' nowrap width="1%"></th>
			<th align='left' valign='top' nowrap width="9%">Data</th>
			<th align='left' valign='top' width="4%">De</th>
			<th align='left' valign='top' width="4%">Para</th>
			<th align="left" valign="top" width="78%">Mensagem</th>
			<th align='left' valign='top' nowrap width="3%">Horas</th>
			<th align='left' valign='top' nowrap width="2%"></th>
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
	<b>
		<tr>
			<td align='left' valign='top'>
			<% if GetValue(objRS,"SYS_ID_USUARIO_INS")<>"" and LCase(GetValue(objRS,"ID_FROM"))=LCase(Request.Cookies("VBOSS")("ID_USUARIO")) and aux=0 then %>	
				<a style="cursor:hand;" 
				   onClick="window.open('delete_resp.asp?var_chavereg=<%=GetValue(objRS,"COD_TL_RESPOSTA")%>','','popup,width=10,height=10');">
					<img src='../img/IconAction_DEL.gif' border='0'>
				</a>
			<% end if %>
			</td>
			<td align='left' valign='top' nowrap="nowrap"><%=PrepData(GetValue(objRS,"DTT_RESPOSTA"),true,true)%></td>
			<td align='left' valign='top' style="color:#999999;"><%=GetValue(objRS,"ID_FROM")%></td>
			<td align='left' valign='top'><b><%=GetValue(objRS,"ID_TO")%></b></td>
			<td align="left" valign="middle"><%=strRESPOSTA%>
			<% If GetValue(objRS,"SIGILOSO") <> "" Then %>
				<% If strResposta <> "" Then %><br><br><% End If %> 
				<% If GetValue(objRS,"ID_FROM") = LCase(Request.Cookies("VBOSS")("ID_USUARIO")) Or GetValue(objRS,"ID_TO") = LCase(Request.Cookies("VBOSS")("ID_USUARIO")) Then %>
					<font color="#999999"><%=GetValue(objRS,"SIGILOSO")%></font>
				<% Else %>
					<font color="#999999">****************</font>
				<% End If %>
			<% End If %>
			</td>
			<td style="text-align:right;" valign="top"><%=FormataHoraNumToHHMM(auxHS)%></td>
			<td style="text-align:center;" valign="top">
			<% If GetValue(objRS, "ARQUIVO_ANEXO") <> "" Then %>
				<a href="../athdownloader.asp?var_cliente=<%=Request.Cookies("VBOSS")("CLINAME")%>&var_tipo=RESPOSTA_Anexos&var_arquivo=<%=GetValue(objRS, "ARQUIVO_ANEXO")%>" target="_blank" style="cursor:hand;"><img src="../img/ico_clip.gif" border="0" title="Anexo"></a>
			<% End If %>
			</td>
		</tr>
		</b>
		<%
			aux = 1
			acHoras = (acHoras + auxHS)
			objRS.MoveNext
			loop 
		%>
		<tr>
			<td style="text-align:right;" height="30px" colspan="7" valign="middle">Total: <%=FormataHoraNumToHHMM(acHORAS)%></td>
		</tr>
	</tbody>
</table>
<br/>
<%	end if %>
</body>
</html>
<%

	FechaRecordSet objRS
	FechaDBConn objConn
	end if
%>