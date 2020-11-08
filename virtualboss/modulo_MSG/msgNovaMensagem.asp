<!--#include file="../_database/athdbConn.asp"--><!-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --> 
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_MSG", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<%
Dim objRS, objConn, strSQL, objRSAux, strSQLAux
Dim strDESTINO, strLOCATION
Dim strASSUNTO, strBody, strDATA
Dim strANEXO, strPARAMS, strACTION, strFORM_FOCUS

 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

strDESTINO = GetParam("var_destino")

strFORM_FOCUS =	"var_destinatarios"

AbreDBConn objConn, CFG_DB 

if IsEmpty(strDESTINO) then
	strPARAMS = GetParam("var_params") 
	strACTION = GetParam("var_action") 
	
	if (strPARAMS <> "") and (strACTION <> "") then		
		strSQL = 	      " SELECT MSG_MENSAGEM.COD_MENSAGEM "
		strSQL = strSQL & "      , MSG_REMETENTE.COD_USER_REMETENTE "
		strSQL = strSQL & "      , MSG_DESTINATARIO.COD_USER_DESTINATARIO "
		strSQL = strSQL & "      , MSG_MENSAGEM.ASSUNTO, MSG_MENSAGEM.DT_ENVIO, MSG_PASTA.DT_LIDO, MSG_MENSAGEM.MENSAGEM "
		strSQL = strSQL & " FROM MSG_MENSAGEM, MSG_PASTA, MSG_DESTINATARIO, MSG_REMETENTE "
		strSQL = strSQL & " WHERE MSG_MENSAGEM.COD_MENSAGEM = " & strPARAMS
		strSQL = strSQL & " AND MSG_MENSAGEM.COD_MENSAGEM = MSG_PASTA.COD_MENSAGEM "
		strSQL = strSQL & " AND MSG_MENSAGEM.COD_MENSAGEM = MSG_DESTINATARIO.COD_MENSAGEM "
		strSQL = strSQL & " AND MSG_MENSAGEM.COD_MENSAGEM = MSG_REMETENTE.COD_MENSAGEM "
		Set objRS = objConn.execute(strSQL)
		
		strSQLAux = 				" SELECT DEST.COD_USER_DESTINATARIO AS DESTINATARIO"
		strSQLAux = strSQLAux &	" FROM  MSG_DESTINATARIO 	DEST,"
		strSQLAux =	strSQLAux &	" 		  MSG_MENSAGEM 	 	MENS,"
		strSQLAux =	strSQLAux &	" 		  MSG_REMETENTE 		REM"
		strSQLAux =	strSQLAux &	" WHERE DEST.COD_MENSAGEM	=" & strPARAMS
		strSQLAux =	strSQLAux &	"   AND REM.COD_MENSAGEM 	= DEST.COD_MENSAGEM"	
		strSQLAux =	strSQLAux &	"   AND REM.COD_MENSAGEM 	= MENS.COD_MENSAGEM"	
		strSQLAux =	strSQLAux &	" ORDER BY DEST.COD_USER_DESTINATARIO" 
		Set objRSAux = objConn.execute(strSQLAux)	
		
		if not objRSAux.Eof then
			do while (not objRSAux.Eof) 					  
				strDESTINO = strDESTINO & Trim(objRSAux("DESTINATARIO")) & "; "
				objRSAux.MoveNext	
			loop 
			if (InStr(strDESTINO,objRS("COD_USER_REMETENTE"))=0) then
				strDESTINO = strDESTINO & objRS("COD_USER_REMETENTE")
			end if
		end if			
		strFORM_FOCUS = "var_mensagem"
		
		if not objRS.Eof then
			if strACTION="ENCAMINHAR" then 
				strASSUNTO = "Fw: "   				
			else
				strASSUNTO = "Re: "
			end if
			
			if (StrComp(mid(objRS("ASSUNTO"),1,4),strASSUNTO)=0) then
				strASSUNTO = objRS("ASSUNTO")
			else
				strASSUNTO = strASSUNTO & objRS("ASSUNTO")
			end if
			
			strDATA = 	DiaSemana(WeekDay(objRS("DT_ENVIO"))) & ", " &_  
							DataExtenso(objRS("DT_ENVIO")) & ", "  &_
							ATHFormataTamLeft(DatePart("H", objRS("DT_ENVIO")), 2, "0") & ":"  &_
							ATHFormataTamLeft(DatePart("N", objRS("DT_ENVIO")), 2, "0")
			
			strBody = vbCrlf & vbCrlf & vbCrlf &_
						"<blockquote dir=""ltr"" style=""padding-right:0px; padding-left:5px; border-left:#000000 2px solid; margin-right:0px;"">" 		 & vbCrlf &_
						"	 <div style=""font: 11px arial;"">----- Original Message -----</div>" 								& vbCrlf &_
						"	 <div style=""background:#E4E4E4;font: 11px arial; color:#000000;""><b>De:&nbsp;</b>" & objRS("COD_USER_REMETENTE") & "</div>" & vbCrlf &_
						"	 <div style=""font: 11px arial;""><b>Para:&nbsp;&nbsp;</b>" 	& strDESTINO 		 & "</div>" & vbCrlf &_
						"	 <div style=""font: 11px arial;""><b>Enviado:&nbsp;&nbsp;</b>" & strDATA			 &	"</div>" & vbCrlf &_
						"	 <div style=""font: 11px arial;""><b>Assunto:&nbsp;&nbsp;</b>" & objRS("ASSUNTO") & "</div>" & vbCrlf &_
						"	 <div><br></div>" & vbCrlf &_
						"	 <div><font style=""font: 11px arial;"">" &  objRS("MENSAGEM") & "</font></div>"  & vbCrlf &_
						"</blockquote>"
			
			'Response.Write("<textarea rows=27 cols=65>" & strBody & "</textarea>")			
			'Response.End()
			
			if strACTION="RESPONDER" then 
				strDESTINO=objRS("COD_USER_REMETENTE")
			else 
				if strACTION="ENCAMINHAR" then 
					strDESTINO = ""
					strSQLAux  = "SELECT COD_MSG_ANEXO AS CODIGO, ARQUIVO, DESCRICAO FROM MSG_ANEXO WHERE COD_MENSAGEM =" & objRS("COD_MENSAGEM")
					strFORM_FOCUS	= "var_destinatarios"
					Set objRSAux = objConn.execute(strSQLAux)
					if not objRSAux.Eof then
						while not objRSAux.Eof
							strSQL = " INSERT INTO MSG_TEMP_ANEXO ([SESSION], ARQUIVO, DESCRICAO) " &_
									 " VALUES ('" & Session.SessionID & "', '" & objRSAux("ARQUIVO") & "', '" & objRSAux("DESCRICAO") & "')"
							objConn.Execute(strSQL)
							objRSAux.MoveNext
						wend
					end if											
					strANEXO = "var_cod_mensagem_re=" & objRS("COD_MENSAGEM")
				end if						
			end if
		end if		
	end if
end if
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/javascript">
/*-------------------------------------------------------------------------------------------------------------------------------------*/
function Ok() {
	if (Verifica()) {	
		document.formeditor.var_retorno.value = '';		
		document.formeditor.submit();
	}
}

function Verifica() {
	var var_msg = '';
	with(document.formeditor) {	
		if (var_destinatarios.value == '') { var_msg = var_msg + '\ndestinatário'; }
		if (var_assunto.value  == '')      { var_msg = var_msg + '\nassunto'; }
		if (var_mensagem.value == '')      { var_msg = var_msg + '\nmensagem'; }
	}
	
	if (var_msg == '') {	
		return true;	
	}
	else {
		alert('Favor informar:' + var_msg);
		return false;
	}
}

function Aplicar() {
	if (Verifica()) {
		document.formeditor.var_retorno.value = 'msgNovaMensagem.asp';
		document.formeditor.submit();		
	}
}

function Cancelar() {
	window.close();
}
/*-------------------------------------------------------------------------------------------------------------------------------------*/
function InsereTodos(prExec) {
	document.formeditor.action="BuscaTodosUsuarios.asp?var_exec=" + prExec + "&var_grupo=" + document.formeditor.var_grupo.value + "&var_form=formeditor&var_campo=var_destinatarios&var_pagina=msgInsMensagem.asp";
	document.formeditor.target="ins_todos";
	document.formeditor.submit();
}
</script>
</head>
<body onLoad="document.formeditor.<%=strFORM_FOCUS%>.focus();">
<%=athBeginDialog(WMD_WIDTH, "Mensagens - Envio")%>
<form name="formeditor" action="msgInsMensagem.asp" method="post">
	<input name="var_remetente" type="hidden" value="<%=Request.Cookies("VBOSS")("ID_USUARIO")%>">
	<input name="var_retorno"   type="hidden" value="">
		<div class="form_label">Hoje:&nbsp;</div><div class="form_bypass"><%=DiaSemana(WeekDay(Date()))%>, <%=DataExtenso(Date())%>, <%=THour(TSec(Time))%></div>
	<br><div class="form_label">De:&nbsp;</div><div class="form_bypass"><%=Request.Cookies("VBOSS")("ID_USUARIO")%></div>
<% If Request.Cookies("VBOSS")("GRUPO_USUARIO") <> "CLIENTE" Then %>
	<br><div class="form_label">Para:&nbsp;</div>
	<a href="#2" onClick="JavaScript:InsereTodos('T');"><img src="../img/BtBuscarTodos.gif" border="0" style="vertical-align:bottom; padding-bottom:2px;" vspace="0" hspace="0"></a><iframe name="ins_todos" width="0" height="0" src="BuscaTodosUsuarios.asp" frameborder="0"></iframe>
	<select name="var_grupo" style="width:180px;">
		<option value="ENT_COLABORADOR">Colaboradores</option>
		<% montaCombo "STR", " SELECT DISTINCT T2.COD_CLIENTE, T2.NOME_COMERCIAL FROM USUARIO T1, ENT_CLIENTE T2 WHERE T1.DT_INATIVO IS NULL AND T1.CODIGO = T2.COD_CLIENTE AND T1.TIPO = 'ENT_CLIENTE' ORDER BY T2.NOME_COMERCIAL ", "COD_CLIENTE", "NOME_COMERCIAL", "" %>
	</select>
	<br><div class="form_label">&nbsp;</div>
<% Else %>
	<br><div class="form_label">Para:&nbsp;</div>
<% End If %>
<textarea name="var_destinatarios" rows="3" style="width:260px;"><%=strDESTINO%></textarea>
<% If Request.Cookies("VBOSS")("GRUPO_USUARIO") <> "CLIENTE" Then %>
<a href="#1" onClick="JavaScript:AbreJanelaPAGE('BuscaPorUsuario.asp', '600', '350');"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:bottom; padding-bottom:4px;" vspace="0" hspace="0"></a>
<% End If %>	
<div class="form_ajuda">Informe usuário do sistema, como <b><%=Request.Cookies("VBOSS")("ID_USUARIO")%></b> por exemplo, e use ponto e vírgula como separador se digitar mais de um</div>
	<br><div class="form_label">Assunto:&nbsp;</div><input name="var_assunto" type="text" size="50" value="<%=strASSUNTO%>">
	<br><div class="form_label">Mensagem:&nbsp;</div><textarea name="var_mensagem" rows="5" cols="85"></textarea><textarea name="var_historico" rows="9" cols="85" style="display:none"><%=strBody%></textarea>
</form>
<% If strBody <> "" Then %>
	<div class="form_grupo_collapse" id="form_grupo">
		<div class="form_label"></div>
		<img src="../img/BulletMais.gif" id="form_collapse" border="0" onClick="ShowArea('form_grupo','form_collapse');" 
  		style="cursor:pointer;">
		<b>Histórico</b><br>
		<div><%=strBody%></div>
	</div>
<% End If %>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "Ok();", "../img/butxp_cancelar.gif", "Cancelar();", "../img/butxp_aplicar.gif", "Aplicar()")%>
</body>
</html>
<%	FechaDBConn objConn %>