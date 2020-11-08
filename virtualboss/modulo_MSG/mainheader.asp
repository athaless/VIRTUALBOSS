<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<!--#include file="ConfigMSG.asp"--> 
<%
Dim objRS, objConn, strSQL
Dim strPASTA

strPASTA = GetParam("var_pasta")

abreDBConn objConn, CFG_DB
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
</head>
<script type="text/javascript" language="JavaScript">
function ExecAcao(){
	var codigos = '';
	var opcao = '';
	var i = 0;
	var form;
	
	while (eval("msg_top_right.document.forms[0].msguid_" + i) != null) {	
		if (eval("msg_top_right.document.forms[0].msguid_" + i) != null) {
			if (eval("msg_top_right.document.forms[0].msguid_" + i).checked) {	
				if (codigos != '')
					codigos = codigos + ',' + eval("msg_top_right.document.forms[0].msguid_" + i).value;
				else
					codigos = eval("msg_top_right.document.forms[0].msguid_" + i).value;
			}
		}
		i = i + 1;
	}
	
	if ((codigos != '') && (document.formacao.var_acao.value != '')) {
		form = document.formacao;
		if (form.var_acao.value == 'RESPONDER' || form.var_acao.value == 'RESPONDER_TODOS' || form.var_acao.value == 'ENCAMINHAR' ) { 
			if (codigos.indexOf(',')>0) 
				alert('Selecione apenas uma mensagem.');
			else {
				AbreJanelaPAGENew('msgNovaMensagem.asp?var_params='+ codigos +
								'&var_action=' + document.formacao.var_acao.value + 
								'&var_pasta_atual=' + document.formacao.var_pasta.value, '590', '380', 'no', 'yes');
			}
		}
		else {
			msg_top_right.location = 'msgExecAcao.asp?var_params='	+ codigos + 
			 						 '&var_action=' + document.formacao.var_acao.value + 
									 '&var_pasta_atual=' + document.formacao.var_pasta.value;
		}
	}
	
	document.formacao.var_acao.selectedIndex = "0";
	return false;
}

</script>
</head>
<body>
<table width="100%" align="center" border="0" cellpadding="0" cellspacing="3">
<form name="formacao" method="post" action="">
	<input type="hidden" name="var_pasta" value="<%=strPASTA%>"> 
	<tr>
		<td height="1%" style="padding-left:7px; border:1px solid #999999;">
		<iframe name="msg_top_right" width="100%" height="120" src="msgShowMensagens.asp?var_pasta=<%=strPASTA%>" frameborder="0"></iframe>
		</td>
	</tr>
  	<tr>
  	 	<td height="1%" valign="top"> 
			 <table align="right" border="0" width="100%" cellpadding="0" cellspacing="0">
				 <tr bgcolor="#F5F5F5">
				  	<td height="20" width="100%">
						<table width="100%" cellpadding="0" cellspacing="0" style="border:1px solid #F5F5F5;">
							<tr><td height="3" colspan="2"></td></tr>
							<tr>
								<td height="20" width="1%">
									<div style="padding-left:3px; padding-right:6px;"><img src="../img/msg_seta.gif"></div>
								</td>
								<td width="100%" nowrap>
								<div style="padding-left:6px; padding-right:3px;">
									<select name="var_acao" onChange="ExecAcao();">
										<option value="">Selecione...</option>
										<option value="MARCAR_LIDO">Marcar como lido</option>
										<option value="MARCAR_NAOLIDO">Marcar como não lido</option>
										<% If VerificaDireito("|DEL|", BuscaDireitosFromDB("modulo_MSG", Request.Cookies("VBOSS")("ID_USUARIO")), False) Then %>
											<option value="DELETAR">Deletar</option>
										<% End If %>
										<!-- 
										PROBLEMA NO DELETAR, como a mensagem tem um código único, mas foi pra ários, 
										se alguns dos destinatários remove ou move a mensagem isso afeta a visualização 
										da mesma por todos.
										
										Erro apontado pelo Kiko 10/07/2009.
										De qualquer forma não queremos que as mensagens sejam deletadas, então a opção foi retirada
										
										Problema resolvido, faltava colocar o usuário logado no SQL
										by Clv - 27/07/2009
										-->
										<option value="RESPONDER">Responder</option>
										<option value="RESPONDER_TODOS">Responder a todos</option>
										<option value="ENCAMINHAR">Encaminhar</option>
										<optgroup label="Mover para">
										<% If strPASTA <> CX_ENTRADA_Value Then %><option value="MOVER_<%=CX_ENTRADA_Value%>"><%=CX_ENTRADA_Caption%></option><% End If %>
										<% If strPASTA <> CX_SAIDA_Value Then %><option value="MOVER_<%=CX_SAIDA_Value%>"><%=CX_SAIDA_Caption%></option><% End If %>
										<% If strPASTA <> CX_EXCLUIDOS_Value Then %><option value="MOVER_<%=CX_EXCLUIDOS_Value%>"><%=CX_EXCLUIDOS_Caption%></option><% End If %>
										<%
										strSQL =          " SELECT DISTINCT(PASTA) FROM MSG_PASTA " 
										strSQL = strSQL & " WHERE PASTA NOT LIKE '" & CX_ENTRADA_Value & "' " 
										strSQL = strSQL & "   AND PASTA NOT LIKE '" & CX_SAIDA_Value & "' " 
										strSQL = strSQL & "   AND PASTA NOT LIKE '" & CX_EXCLUIDOS_Value & "' " 
										strSQL = strSQL & "   AND PASTA NOT LIKE '" & strPASTA & "' " 
										strSQL = strSQL & "   AND COD_USER = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "'"
										strSQL = strSQL & " ORDER BY PASTA " 
										
										Set objRS = objConn.Execute(strSQL)
										
										do while not objRS.Eof 
											%>
											<option value="MOVER_<%=GetValue(objRS, "PASTA")%>"><%=GetValue(objRS, "PASTA")%></option>
											<%
											objRS.MoveNext
										loop 
										
										FechaRecordSet(objRS)
										%>
										</optgroup>
									</select>
									</div>
								</td>
							</tr>
							<tr><td height="3" colspan="2"></td></tr>
						</table>			
				  	</td>
				 </tr>
			</table>
		</td>
  	</tr>
	<!--tr style="border:0px solid #999999;">
		<td height="400" valign="top" style="border:0px solid #999999;">
			<strong>&nbsp;&nbsp;Mensagem<br></strong><hr>
		</td>
	</tr-->
</form>
</table>
</body>
</html>
<%	FechaDBConn objConn %>