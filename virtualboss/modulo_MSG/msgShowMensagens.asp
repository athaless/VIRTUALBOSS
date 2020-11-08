<!--#include file="../_database/athdbConn.asp"--><!-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<!--#include file="ConfigMSG.asp"--> 
<%
Dim strSQL, objConn, objRS, objRSAux, i, strDestinatarios
Dim objRSAnexos, objRSPasta
Dim strPasta
Dim strSQLAux, strSQLTemp

strPasta = GetParam("var_pasta")

'Se houver pastas criadas pelo usuário
'if InStr(1, strPasta, "MOVER_", VBTextCompare) > 0 Then 
'	strPasta = Mid(strPasta, 7) 
'end if

if strPasta = "" then strPasta = CX_ENTRADA_Value

abreDBConn objConn, CFG_DB

'parte do SQL igual para as duas consultas
strSQLTemp  =  						  ", MSG_MENSAGEM.ASSUNTO "
strSQLTemp  =  strSQLTemp  &		  ", MSG_MENSAGEM.DT_ENVIO "
strSQLTemp  =  strSQLTemp  &       ", MSG_PASTA.DT_LIDO "
strSQLTemp  =  strSQLTemp  & "FROM	MSG_MENSAGEM "
strSQLTemp  =  strSQLTemp  & 	 	", MSG_PASTA "
strSQLTemp  =  strSQLTemp  & 	 	", MSG_DESTINATARIO "
strSQLTemp  =  strSQLTemp  & 	 	", MSG_REMETENTE "
strSQLTemp  =  strSQLTemp  & "WHERE	 MSG_MENSAGEM.COD_MENSAGEM = MSG_PASTA.COD_MENSAGEM "
strSQLTemp  =  strSQLTemp  &   "AND	 MSG_MENSAGEM.COD_MENSAGEM = MSG_DESTINATARIO.COD_MENSAGEM "
strSQLTemp  =  strSQLTemp  &   "AND	 MSG_MENSAGEM.COD_MENSAGEM = MSG_REMETENTE.COD_MENSAGEM "
strSQLTemp  =  strSQLTemp  &	 "AND	 MSG_PASTA.COD_USER LIKE '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' " 
strSQLTemp  =  strSQLTemp  &	 "AND	 MSG_PASTA.PASTA ='" & strPasta & "' "

if strPasta <> CX_SAIDA_Value then
	strSQL =  				"SELECT  DISTINCT MSG_MENSAGEM.COD_MENSAGEM "
	strSQL =  strSQL & 						", MSG_REMETENTE.COD_USER_REMETENTE " 
	strSQL =  strSQL & 						", MSG_DESTINATARIO.COD_USER_DESTINATARIO "
	strSQL =  strSQL & 	strSQLTemp
	strSQL =  strSQL & 	"AND	MSG_DESTINATARIO.COD_USER_DESTINATARIO='" & Request.Cookies("VBOSS")("ID_USUARIO") & "' " 		
	strSQL =  strSQL & 	"ORDER BY MSG_MENSAGEM.DT_ENVIO DESC "
else	
	strSQL = 			 	"SELECT  MSG_MENSAGEM.COD_MENSAGEM  "
	strSQL =  strSQL & 	strSQLTemp
	strSQL =  strSQL & 	"GROUP BY 	MSG_MENSAGEM.COD_MENSAGEM "
	strSQL =  strSQL &   	   	", MSG_MENSAGEM.ASSUNTO "
	strSQL =  strSQL &      		", MSG_MENSAGEM.DT_ENVIO "
	strSQL =  strSQL &        		", MSG_PASTA.DT_LIDO "
	strSQL =  strSQL & 	"ORDER BY MSG_MENSAGEM.DT_ENVIO DESC "					
end if
Set objRS = objConn.execute(strSQL)	
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/javascript">
function ToggleCheckAll() {
var i = 0;
 	while (eval("document.forms[0].msguid_" + i) != null ) {
   	eval("document.forms[0].msguid_" + i).checked = ! eval("document.forms[0].msguid_" + i).checked;
   	i = i + 1;
  	}
}
</script>
</head>
<body>
<form name="formacao" method="post" action="">
<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td height="80" valign="top">
			<table border="0" width="100%" cellpadding="0" cellspacing="1">
				<tr>
				   <td width="1%"><input type="checkbox" class="inputclean" name="var_todas" title="Seleciona todas" onClick="ToggleCheckAll();" style="border:1px dashed #CCCCCC;"></td>
				   <td width="1%"><img src="../img/msg_icoenv.gif" hspace="6"></td>
				   <td width="1%"><img src="../img/ico_clip.gif" hspace="6"></td>
				   <td width="20%">
						<strong><% if strPasta = CX_SAIDA_Value then Response.Write("Para") else Response.Write("De") %></strong>
				   </td>
				   <td width="52%"><strong>Assunto</strong></td>
				   <td width="25%"><strong>Data</strong></td>
				</tr>
				<tr><td colspan="6" height="2" bgcolor="#CCCCCC"></td></tr>
				<%
					if not objRS.Eof then
						i = 0
						while not objRS.Eof 
							strSQL = " SELECT COUNT(ARQUIVO) as ANEXOS FROM MSG_ANEXO WHERE COD_MENSAGEM = " & GetValue(objRS, "COD_MENSAGEM")
							Set objRSAnexos = objConn.execute(strSQL)
				%>
				<tr valign="top">
					<td><input type="checkbox" class="inputclean" name="var_cod_mensagem" id="msguid_<%=i%>" value="<%=GetValue(objRS, "COD_MENSAGEM")%>" style="border:1px dashed #CCCCCC;"></td>
					<td valign="middle"><div align="center">
						<% if GetValue(objRS, "DT_LIDO") = "" then %><img src="../img/msg_icoenv.gif" id="icoenv_<%=i%>"><% else %><img src="../img/transparent.gif" id="icoenv_<%=i%>"><% end if %>
					</div></td>
					<td valign="middle"><div align="center">
						<% if Cint(GetValue(objRSAnexos,"ANEXOS")) > 0 then %><img src="../img/ico_clip.gif"><% else %><img src="../img/transparent.gif"><% end if %>
					</div></td>
					<td>
						<a href="msgAbreMensagem.asp?var_chavereg=<%=GetValue(objRS, "COD_MENSAGEM")%>&var_pasta=<%=strPasta%>" target="msg_bottom_right">
						<%	
						if strPasta = CX_SAIDA_Value then
							'Busca os Destinatários ds mensagem atual e armazena em strDestinatarios									
							strSQLAux =             " SELECT DISTINCT COD_USER_DESTINATARIO "
							strSQLAux =	strSQLAux &	" FROM MSG_DESTINATARIO "
							strSQLAux =	strSQLAux &	" WHERE COD_MENSAGEM = " & GetValue(objRS, "COD_MENSAGEM")
							strSQLAux =	strSQLAux &	" ORDER BY COD_USER_DESTINATARIO "
							
							Set objRSAux = objConn.execute(strSQLAux)
							
							strDestinatarios = ""
							
							while not objRSAux.Eof									
								strDestinatarios = strDestinatarios & trim(objRSAux("COD_USER_DESTINATARIO"))
								objRSAux.MoveNext
								if not objRSAux.Eof then strDestinatarios = strDestinatarios & "; "										
							wend
							
							'Quando há muitos destinatários
							Response.Write mid(strDestinatarios,1,40)									
							if len(strDestinatarios)>40 then Response.Write "..."
							
							FechaRecordSet(objRSAux)
						else										
							Response.Write(GetValue(objRS, "COD_USER_REMETENTE")) 
						end if 
						%>
						</a>
					</td>
					<td>
						<a href="msgAbreMensagem.asp?var_chavereg=<%=GetValue(objRS, "COD_MENSAGEM")%>&var_pasta=<%=strPasta%>" target="msg_bottom_right">
						<%
						Response.Write mid(GetValue(objRS, "ASSUNTO"),1,45) 
						if len(GetValue(objRS, "ASSUNTO")) > 45 then Response.Write "..." 
						%>
						</a>
					</td>
					<td nowrap><%=PrepData(GetValue(objRS, "DT_ENVIO"), True, True)%></td>
				</tr>						   
					<% 
								i = i + 1
								FechaRecordSet(objRSAnexos)						   
								objRS.MoveNext 
							wend
						else
					%>
				<tr>
					<td style="text-align:center" class="text_corpo_peq" colspan="6"><b>Não foi encontrada nenhuma mensagem</b></td>
				</tr>
					<%	end if %> 
			</table>					
		</td>
	</tr>
</table>
</form>
</body>
</html>
<%
	FechaRecordSet(objRS)	
	FechaDBConn objConn
%>
