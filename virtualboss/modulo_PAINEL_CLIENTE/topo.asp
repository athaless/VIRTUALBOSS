<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 Dim objConn, strSQL, objRS
 Dim auxCont, auxSTR, strUSER_ID

 strUSER_ID = LCase(Request.Cookies("VBOSS")("ID_USUARIO"))

 AbreDBConn objConn, CFG_DB
 strSQL = " SELECT ROTULO, LINK, IMG, TARGET FROM SYS_PAINEL WHERE DT_INATIVO IS NULL AND ID_USUARIO='" & strUSER_ID & "' ORDER BY ORDEM "
 Set objRS = objConn.execute(strSQL)
%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style>
BODY {
	SCROLLBAR-FACE-COLOR: #e3e2dc; 
	SCROLLBAR-HIGHLIGHT-COLOR: #eae9e5; 
	SCROLLBAR-SHADOW-COLOR: #aaa9a5; COLOR: #766d5b; 
	SCROLLBAR-3DLIGHT-COLOR: #f1f1ee; 
	SCROLLBAR-ARROW-COLOR: #000000; 
	SCROLLBAR-TRACK-COLOR: #e9e8e3; 
	SCROLLBAR-DARKSHADOW-COLOR: #71716e
}
</style>
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
</head>
<body>
<table width="100%" height="55" border="0" cellpadding="0" cellspacing="0">
  <tr> 
	<td height="55" valign="top" background="../img/BgTitle.jpg">
	  <table width="100%" height="55" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td>
		   <div style="padding-left:5px">
		    <table border="0" cellpadding="0" cellspacing="0">
			 <tr>
			 	<!--
				<td align="center" valign="middle"> 
					 <a href="../modulo_CHAMADO/insert.asp"  target="vbMainFrame" style='cursor:pointer; text-decoration:none; border:none; outline:none;'><img src="../img/AddAtalho_A.gif" alt="Adicionar atalho" title"Adicionar atalho" border="0"></a><br>
					 <a href="../modulo_CHAMADO/default.htm" target="vbNucleo" style='cursor:pointer; text-decoration:none; border:none; outline:none;'><img src="../img/AddAtalho_B.gif" alt="Editar atalhos" title"Editar atalhos" border="0"></a>
				</td>
				-->
				<td align="center" valign="middle" nowrap="nowrap"><a href="../modulo_USUARIO/UpdateClient.asp" target="vbMainFrame" style="cursor:pointer; text-decoration:none; border:none; outline:none;"><img src="../img/IconFixed_meusdados.gif" alt="Meus dados" title"Meus dados" border="0"></a></td>
				<td width="10" align="center"></td>
				<td align="center" valign="middle" nowrap="nowrap"><a href="../modulo_MSG/default.htm" target="vbNucleo" style="cursor:pointer; text-decoration:none; border:none; outline:none;"><img src="../img/IconFixed_msg.gif" alt="Mensagens" title"Mensagens" border="0"></a></td>
				<td width="10" align="center"></td>
				<td align="center" valign="middle" nowrap="nowrap"><a href="../modulo_CHAMADO/default.htm" target="vbNucleo" style="cursor:pointer; text-decoration:none; border:none; outline:none;"><img src="../img/IconFixed_chamado.gif" alt="Chamados" title"Chamados" border="0"></a></td>
				<td width="10" align="center"></td>
				<td align="center" valign="middle" nowrap="nowrap"><a href="../modulo_CHAMADO/insert.asp" target="vbMainFrame" style="cursor:pointer; text-decoration:none; border:none; outline:none;"><img src="../img/IconFixed_inschamado.gif" alt="Inserir Chamado" title"Inserir Chamado" border="0"></a></td>
				<td width="10" align="center"></td>
			  <%
			    While Not objRS.EOF
			  %>
			     <td style="cursor:hand;">
				    <a href="<%=GetValue(objRS,"LINK")%>" target="<%=GetValue(objRS,"TARGET")%>">
				      <img src="../img/<%=GetValue(objRS,"IMG")%>" alt="<%=GetValue(objRS,"ROTULO")%>" title"<%=GetValue(objRS,"ROTULO")%>" border="0">
				    </a>
				 </td>
			     <td width="10" align="center"></td>
			  <%
			     objRS.MoveNext
			    Wend
			  %>
			 <tr>
			</table>
		   </div>
		  </td>
          <td width="1%" align="right"><img src="../img/LogoCli_<%=Request.Cookies("VBOSS")("CLINAME")%>.gif"></td>
        </tr>
      </table>
	</td>
  </tr>
</table>
<div class="form_line">
	<form name="form_principal" id="form_principal" method="get" action="painel.asp" target="vbMainFrame">
		<div class="form_label_nowidth"></div><input type="hidden" name="dummy" size="20" class="edtext">

		<!-- Para diminuir ou eliminar a ocorrência de cahce passamso um parâmetro DUMMY com um número diferente 
		a cada execução. Isso força o navegador a interpretar como um request diferente a página,m evitando cache - by Aless 06/10/10 -->
		<input type="hidden" id="rndrequest" name="rndrequest" value="">
		<div onClick="document.form_principal.rndrequest.value=(new Date()).valueOf(); document.form_principal.submit();" class="btsearch" style="display:none;"></div>
	</form>
</div>
</body>
</html>
<%
 FechaRecordSet(objRS)
 FechaDBConn objConn
%>