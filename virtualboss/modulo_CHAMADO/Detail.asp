<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_CHAMADO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
' e o tamanho da coluna dos títulos dos inputs
Dim WMD_WIDTH, WMD_WIDTHTTITLES
WMD_WIDTH = 520
WMD_WIDTHTTITLES = 100
' -------------------------------------------------------------------------------

Dim strSQL, objRS, ObjConn, Cont
Dim strCODIGO, strRESP 
Dim strDESCRICAO, strSIGILOSO, strDESBLOQUEIO, strDESBLOQUEIO_SIGI, strSYSUSRINS, strARQUIVOANEXO
Dim strCFG_TD, aux, auxHS, acHORAS, strResposta, bFechar

strCODIGO = GetParam("var_chavereg")

strCFG_TD = "align='left' valign='top' nowrap"

AbreDBConn objConn, CFG_DB

strSQL =          " SELECT T1.TITULO, T2.NOME AS CATEGORIA, T1.PRIORIDADE, T1.DESCRICAO, T1.SIGILOSO, T1.ARQUIVO_ANEXO, T1.EXTRA "
strSQL = strSQL & "      , T1.SYS_DTT_DESBLOQUEIO, T1.SYS_ID_USUARIO_DESBLOQUEIO, T1.DESBLOQUEIO, T1.DESBLOQUEIO_SIGI, T3.APELIDO AS APELIDO_DESBLOQUEIO "
strSQL = strSQL & "      , T1.SYS_ID_USUARIO_INS, T1.SYS_DTT_INS, T1.SYS_ID_USUARIO_UPD, T1.SYS_DTT_UPD "
strSQL = strSQL & " FROM CH_CHAMADO T1 "
strSQL = strSQL & " INNER JOIN CH_CATEGORIA T2 ON (T1.COD_CATEGORIA = T2.COD_CATEGORIA) "
strSQL = strSQL & " LEFT OUTER JOIN USUARIO T3 ON (T1.SYS_ID_USUARIO_DESBLOQUEIO = T3.ID_USUARIO) "
strSQL = strSQL & " WHERE T1.COD_CHAMADO = " & strCODIGO

Set objRS = objConn.Execute(strSQL)

If Not objRS.Eof Then
	strDESCRICAO		= Replace(GetValue(objRS, "DESCRICAO"),"<ASLW_APOSTROFE>","'")
	strSIGILOSO			= Replace(GetValue(objRS, "SIGILOSO"),"<ASLW_APOSTROFE>","'")
	strDESBLOQUEIO		= Replace(GetValue(objRS, "DESBLOQUEIO"),"<ASLW_APOSTROFE>","'")
	strDESBLOQUEIO_SIGI = Replace(GetValue(objRS, "DESBLOQUEIO_SIGI"),"<ASLW_APOSTROFE>","'")
	
	strDESCRICAO		= Replace(strDESCRICAO, "''", "'")
	strSIGILOSO			= Replace(strSIGILOSO, "''", "'")
	strDESBLOQUEIO		= Replace(strDESBLOQUEIO, "''", "'")
	strDESBLOQUEIO_SIGI = Replace(strDESBLOQUEIO_SIGI, "''", "'")
	
	strDESCRICAO		= Replace(strDESCRICAO,Chr(13),"<br>")
	strSIGILOSO			= Replace(strSIGILOSO,Chr(13),"<br>")
	strDESBLOQUEIO		= Replace(strDESBLOQUEIO,Chr(13),"<br>")
	strDESBLOQUEIO_SIGI = Replace(strDESBLOQUEIO_SIGI,Chr(13),"<br>")
	
	strSYSUSRINS    	= GetValue(objRS,"SYS_ID_USUARIO_INS")
	
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
	<tr> 
		<td align="right">Cod:&nbsp;</td>
		<td><%=strCODIGO%></td>
	</tr>
	<tr> 
		<td align="right">Título:&nbsp;</td>
		<td><%=GetValue(objRS, "TITULO")%></td>
	</tr>
	<tr>
		<td align="right">Categoria:&nbsp;</td>
		<td><%=GetValue(objRS, "CATEGORIA")%></td>
	</tr>
	<tr> 
		<td align="right">Prioridade:&nbsp;</td>
		<td><%=GetValue(objRS, "PRIORIDADE")%></td>
	</tr>
	<tr> 
		<td align="right">Descrição:&nbsp;</td>
		<td><%=strDESCRICAO%></td>
	</tr>
	<tr> 
		<td align="right">Sigiloso:&nbsp;</td>
		<td>
		<%
		If LCase(GetValue(objRS, "SYS_ID_USUARIO_INS")) = LCase(Request.Cookies("VBOSS")("ID_USUARIO")) Then
			Response.Write(strSIGILOSO)
		Else
			If GetValue(objRS, "SIGILOSO") <> "" Then
				Response.Write("**************")
			End If
		End If
		%>
		</td>
	</tr>
	<tr> 
		<td align="right">Solicitação:&nbsp;</td>
		<td>Por <%=GetValue(objRS, "SYS_ID_USUARIO_INS")%>
			,&nbsp;em&nbsp;<%=PrepData(GetValue(objRS, "SYS_DTT_INS"), True, True)%>
		</td>
	</tr>
	<tr> 
		<td align="right">Alteração:&nbsp;</td>
		<td>
		<%
		If GetValue(objRS, "SYS_ID_USUARIO_UPD") <> "" Then Response.Write("Por " & GetValue(objRS, "SYS_ID_USUARIO_UPD"))
		If GetValue(objRS, "SYS_DTT_UPD") <> "" Then Response.Write(",&nbsp;em&nbsp;" & PrepData(GetValue(objRS, "SYS_DTT_UPD"), True, True))
		%>
		</td>
	</tr>
	<% If GetValue(objRS, "SYS_ID_USUARIO_DESBLOQUEIO") <> "" Then %>
		<tr> 
			<td align="right">Desbloqueado:&nbsp;</td>
			<td>Por <%=GetValue(objRS, "APELIDO_DESBLOQUEIO")%>,&nbsp;em&nbsp;<%=PrepData(GetValue(objRS, "SYS_DTT_DESBLOQUEIO"), True, True)%></td>
		</tr>
		<tr> 
			<td align="right">Comentário:&nbsp;</td>
			<td><%=strDESBLOQUEIO%></td>
		</tr>
		<% If UCase(CStr(Request.Cookies("VBOSS")("ID_USUARIO"))) = UCase(CStr(GetValue(objRS, "SYS_ID_USUARIO_DESBLOQUEIO"))) Then %>
			<tr> 
				<td align="right">Comentário Sigiloso:&nbsp;</td>
				<td><%=strDESBLOQUEIO_SIGI%></td>
			</tr>
		<% End If %>
	<% End If %>
	<tr> 
		<td align="right">Extra:&nbsp;</td>
		<td><%=GetValue(objRS, "EXTRA")%></td>
	</tr>

	<!-- tr><td>&nbsp;</td><td><hr></td></tr //-->

	<% 
	  strARQUIVOANEXO = GetValue(objRS,"ARQUIVO_ANEXO")
	  if strARQUIVOANEXO <> "" then
	%>
	<tr>
		<td>Documento:&nbsp;</td>
		<td><a href="../athdownloader.asp?var_cliente=<%=Request.Cookies("VBOSS")("CLINAME")%>&var_tipo=TODO_Anexos&var_arquivo=<%=strARQUIVOANEXO%>" style="cursor:hand;text-decoration:none;" target="_blank"><img src="../img/ico_clip.gif" border="0" title="Documento" alt="Documento">&nbsp;DOWNLOAD&nbsp;</a><small>&nbsp;&nbsp;<%=ucase(Replace(strARQUIVOANEXO,"}_","}_<b>")&"</b>")%></small></td>
	</tr>
	<% End If %>
	<% 
	   ' Faz a busca dos arquivos anexos deste CHAMADO
	   ' Se tem algum anexo monta a estrutura
		strSQL = "SELECT COD_ANEXO, COD_CHAMADO, ARQUIVO, DESCRICAO FROM CH_ANEXO WHERE COD_CHAMADO = " & strCODIGO & " ORDER BY SYS_DTT_INS " 
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	   	if not objRS.eof then 
	%>
	<tr>
		<td style="vertical-align:top;">Anexos:&nbsp;</td>
		<td>
		 <%
		  do while not objRS.Eof
		 %>
		 <div style="margin-bottom:10px;">
			 <div>
				<a href="../athdownloader.asp?var_cliente=<%=Request.Cookies("VBOSS")("CLINAME")%>&var_tipo=TODO_Anexos&var_arquivo=<%=GetValue(objRS, "ARQUIVO")%>" style="cursor:hand;text-decoration:none;" target="_blank"><img src="../img/ico_clip.gif" border="0" title="Documento" alt="Documento">&nbsp;DOWNLOAD&nbsp;</a><small>&nbsp;&nbsp;<%=ucase(Replace(GetValue(objRS, "ARQUIVO"),"}_","}_<b>")&"</b>")%></small>	
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


 </tbody>
</table>
</body>
</html>
<%
End If

FechaRecordSet objRS
FechaDBConn objConn
%>
