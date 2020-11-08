<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<!--#include file="ConfigMSG.asp"--> 
<%
Dim objRS, objConn, strSQL

abreDBConn objConn, CFG_DB
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script type="text/javascript" language="JavaScript">
function ExecAcao(){
	if (document.form_acoes.var_nome.value == 'INSERIR')
		AbreJanelaPAGENew('msgNovaMensagem.asp', '590', '380', 'no', 'yes');
	document.form_acoes.var_nome.value = '';
}

</script>
</head>
<body onLoad="document.form_principal.submit();">
<table class="top_table" style="width:100%; height:58px; border:0px; margin:0px; padding:0px; vertical-align:top; border-collapse:collapse; ">
<tr> 
 	<td width="1%" class="top_menu" style="background-image:url(../img/Menu_TopBgLeft.jpg); vertical-align:top; padding:10px 0px 0px 10px;  border-collapse:collapse;">
	    <b>Mensagens</b>
		<%=montaMenuCombo("form_acoes","var_nome","width:120px","ExecAcao(this.form.name,this.name);","INSERIR:ENVIAR")%>
	</td>
	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
		<!div class="form_line">
			<form name="form_principal" id="form_principal" method="get" action="main.asp" target="vbMainFrame">
				<div class="form_label_nowidth">Pasta:</div>
				<select name="var_pasta" class="edtext_combo" style="width:120px;">
					<option value="<%=CX_ENTRADA_Value%>" selected><%=CX_ENTRADA_Caption%></option>
					<option value="<%=CX_SAIDA_Value%>"><%=CX_SAIDA_Caption%></option>
					<option value="<%=CX_EXCLUIDOS_Value%>"><%=CX_EXCLUIDOS_Caption%></option>
					<%
					strSQL =          " SELECT DISTINCT(PASTA) FROM MSG_PASTA " 
					strSQL = strSQL & " WHERE PASTA NOT LIKE '" & CX_ENTRADA_Value & "' " 
					strSQL = strSQL & "   AND PASTA NOT LIKE '" & CX_SAIDA_Value & "' " 
					strSQL = strSQL & "   AND PASTA NOT LIKE '" & CX_EXCLUIDOS_Value & "' " 
					strSQL = strSQL & "   AND COD_USER = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "'"
					strSQL = strSQL & " ORDER BY PASTA " 
		  
					Set objRS = objConn.Execute(strSQL)
			  
					do while not objRS.Eof 
						%>
						<option value="<%=objRS("PASTA")%>"><%=objRS("PASTA")%></option>
						<%
						objRS.MoveNext
					loop 					  
					FechaRecordSet(objRS)	
					%>
				</select>
				<!-- Para diminuir ou eliminar a ocorrência de cahce passamso um parâmetro DUMMY com um número diferente 
				a cada execução. Isso força o navegador a interpretar como um request diferente a página,m evitando cache - by Aless 06/10/10 -->
				<input type="hidden" id="rndrequest" name="rndrequest" value="">
				<div onClick="document.form_principal.rndrequest.value=(new Date()).valueOf(); document.form_principal.submit();" class="btsearch"></div>
			</form>
		</div>
	</td>
</tr>
</table>
</body>
</html>