<%
if(Request.Cookies("VBOSS")("GRUPO_USUARIO") = "CLIENTE" And Request.Cookies("VBOSS")("ENTIDADE_TIPO") = "ENT_CLIENTE") then
	strEntCliRef = Request.Cookies("VBOSS")("ENTIDADE_CODIGO")
else
	'If VerificaDireito("|VIEW|", BuscaDireitosFromDB("modulo_CHAMADO", Request.Cookies("VBOSS")("ID_USUARIO")), False) Then
	'Buscamos no cadastro de usuario se deverá visualizar chamados de clientes especificos      
	strSQL = "SELECT ENT_CLIENTE_REF FROM USUARIO WHERE ID_USUARIO='" & Request.Cookies("VBOSS")("ID_USUARIO") & "'"
	Set objRS = objConn.Execute(strSQL)
	strEntCliRef = GetValue(objRS, "ENT_CLIENTE_REF")
	FechaRecordSet objRS
end if

'Monta o SQL que será usado no combo
if(strEntCliRef <> "") then
	strEntCliRef = Replace(strEntCliRef,";",",") 'trocamos o ponto-virgula por virgula para utilizar direto no sql	
    strSQLCombo = "SELECT DISTINCT T2.COD_CLIENTE, T2.NOME_COMERCIAL FROM CH_CHAMADO T1, ENT_CLIENTE T2 " & _
	              " WHERE T1.COD_CLI = T2.COD_CLIENTE " & _ 
	     		  "   AND T1.COD_CLI IN (" & strEntCliRef & ") " & _ 
				  " ORDER BY T2.NOME_COMERCIAL"
    'else
	'   strSQLCombo = "SELECT DISTINCT T2.COD_CLIENTE, T2.NOME_COMERCIAL FROM CH_CHAMADO T1, ENT_CLIENTE T2 WHERE T1.COD_CLI = T2.COD_CLIENTE ORDER BY T2.NOME_COMERCIAL"
	'end if	
	
	strSQL =          " SELECT COUNT(T1.COD_CHAMADO) AS TOTAL "
	strSQL = strSQL & " FROM CH_CHAMADO T1, ENT_CLIENTE T2 "
	strSQL = strSQL & " WHERE (T1.SITUACAO LIKE 'ABERTO' OR T1.SITUACAO LIKE 'BLOQUEADO') "
	strSQL = strSQL & " AND T1.COD_CLI = T2.COD_CLIENTE "
	'Quando usuário for de cliente só vê seus chamados
	If Request.Cookies("VBOSS")("GRUPO_USUARIO") = "CLIENTE" And Request.Cookies("VBOSS")("ENTIDADE_TIPO") = "ENT_CLIENTE" Then
		strSQL = strSQL & " AND T2.COD_CLIENTE = " & Request.Cookies("VBOSS")("ENTIDADE_CODIGO")
	End If
	
    'athdebug strSQL, true
	Set objRS = objConn.Execute(strSQL)
	
	strTELA = ""
	If Not objRS.EOF Then
		If CDbl(GetValue(objRS, "TOTAL")) > 0 Then
			strTELA = "COM"
		Else
			If Request.Cookies("VBOSS")("GRUPO_USUARIO") = "CLIENTE" Then
				strTELA = "SEM"
			End If
		End If
	Else
		If Request.Cookies("VBOSS")("GRUPO_USUARIO") = "CLIENTE" Then
			strTELA = "SEM"
		End If
	End If
	
	If strTELA = "COM" Then
%>
<table width="100%" cellpadding="0" cellspacing="0" border="0" style="margin-bottom:10px;">
<tr>
	<td width="100%" height="30%">
	<!-- Moldura INIC -->
	<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center" bordercolor="<%=strBGCOLOR1%>" style="border:1px solid <%=strBGCOLOR1%>">
	<tr>
		<td style="border-bottom:1px solid <%=strBGCOLOR1%>" colspan="2" bgcolor="<%=strBGCOLOR2%>" class="corpo_texto_mdo" valign="middle" align="left" height="22">
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td align="left" width="1%" nowrap><div style="padding-left:3px; padding-right:3px;">
				<a href='javascript:reSizeiFrame(iframe_chamados.document.body,"iframe_chamados", false, true);'>
				<img src="../img/BulletExpand.gif" border="0"></a>&nbsp;<a href="../modulo_CHAMADO/default.htm" target="vbNucleo">
				<%
				If Request.Cookies("VBOSS")("GRUPO_USUARIO") = "CLIENTE" Then
					Response.Write("<b>Chamados em aberto</b>")
				Else
					Response.Write("<b>Chamados</b>")
				End If
				%></a></div></td>
				<td align="right" width="99%" style="text-align:right">
				<%
				If Request.Cookies("VBOSS")("GRUPO_USUARIO") <> "CLIENTE" Then
					Response.Write("Chamados em aberto por ")
					Response.Write("<select name='buffer_cod_cli' id='buffer_cod_cli' class='edtext_combo' style='width:140px;' onchange='ReloadChamados(this); return false;'><option value='" & strEntCliRef & "'>[clientes]</option>")
					
					'Response.Write(montaCombo("STR", " SELECT DISTINCT T2.COD_CLIENTE, T2.NOME_COMERCIAL FROM CH_CHAMADO T1, ENT_CLIENTE T2 WHERE (T1.SITUACAO LIKE 'ABERTO' OR T1.SITUACAO LIKE 'BLOQUEADO') AND T1.COD_CLI = T2.COD_CLIENTE ORDER BY T2.NOME_COMERCIAL ", "COD_CLIENTE", "NOME_COMERCIAL", "")
					Response.Write(montaCombo("STR", strSQLCombo, "COD_CLIENTE", "NOME_COMERCIAL", CStr(Request.Cookies("VBOSS")("PREF_FITLRO_CHAMADOS"))))
					Response.Write("</select>")
				End If %>
				&nbsp;&nbsp;</td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align="left" bgcolor="<%=strBGCOLOR2%>">
		<div style="padding-top:4px; padding-bottom:4px;">
			<% If Request.Cookies("VBOSS")("GRUPO_USUARIO") <> "CLIENTE" Then %>
			     <iframe name="iframe_chamados" id="iframe_chamados" src="../modulo_CHAMADO/chamados.asp" height="174" width="99%" frameborder="0" scrolling="yes"></iframe>
				<script language="javascript" type="text/javascript">
				  //carrega o iframe de chamados com o cliente(s) selecionado no combo			 
				  ReloadChamados(document.getElementById("buffer_cod_cli"));
				</script>				 
		    <% else %>		 
			     <iframe name="iframe_chamados" id="iframe_chamados" src="../modulo_CHAMADO/chamados.asp?var_cod_cli=<%=strEntCliRef%>" height="174" width="99%" frameborder="0" scrolling="yes"></iframe>
			<% End if %>	 
		</div>
		</td>
	</tr>
	</table>
	<!-- Moldura FIM -->
	</td>
</tr>
</table>
<%
	End If
	
	If strTELA = "SEM" Then
%>
<table width="100%" cellpadding="0" cellspacing="0" border="0" style="margin-bottom:10px;">
<tr>
	<td width="100%" height="30%">
	<!-- Moldura INIC -->
	<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center" bordercolor="<%=strBGCOLOR1%>" style="border:1px solid <%=strBGCOLOR1%>">
	<tr>
		<td style="border-bottom:1px solid <%=strBGCOLOR1%>" colspan="2" bgcolor="<%=strBGCOLOR2%>" class="corpo_texto_mdo" valign="middle" align="left" height="22">
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td align="left" width="1%" nowrap><div style="padding-left:3px; padding-right:3px;"><b><a href="../modulo_CHAMADO/default.htm" target="vbNucleo">Chamados em aberto</a></b></div></td>
				<td align="right" width="99%" style="text-align:right"></td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align="left" bgcolor="<%=strBGCOLOR2%>" height="174">
		<div style="text-align:center; padding-top:10px;">Não existem chamados</div>
		</td>
	</tr>
	</table>
	<!-- Moldura FIM -->
	</td>
</tr>
</table>
<%
	End If
	FechaRecordSet objRS	
End If %>