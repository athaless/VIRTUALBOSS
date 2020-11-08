<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<%
	Dim objRS, objConn, strSQL
	Dim i
	Dim strCOD_MENSAGEM, strCOD_MENSAGEM_RE, strSESSION, strTEXTO, strLINK 

	strCOD_MENSAGEM_RE = GetParam("var_cod_mensagem_re")
	strCOD_MENSAGEM = GetParam("var_cod_mensagem")  
	strSESSION = GetParam("var_session") 

	AbreDBConn objConn, CFG_DB
	
	if (strCOD_MENSAGEM<>"") or (strSESSION<>"") or (strCOD_MENSAGEM_RE<>"") then
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
</head>
<script language="JavaScript" type="text/javascript">
function DeleteSelect(pr_params){
var i = 0;
	codigos = '';
	while (eval("document.frmAnexos.chkAnexo_" + i) != null) {
		if (eval("document.frmAnexos.chkAnexo_" + i).checked) {
			if (codigos != ''){
				codigos = codigos + ',' + eval("document.frmAnexos.chkAnexo_" + i).value;
			}
			else {
				codigos = eval("document.frmAnexos.chkAnexo_" + i).value;
			}
		}
		i = i + 1;
	}
	if (codigos != '') {
		a = confirm("Você quer apagar definitivamente o(s) anexo(s) selecionado(s)?");
		if (a==true){
			document.location = 'msgDelAnexos.asp?var_params=' + codigos;
		}
	}
	return false;
}
</script>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<form name="frmAnexos" action="" method="post">
<%
	strSQL = "SELECT COD_MSG_ANEXO AS CODIGO, ARQUIVO, DESCRICAO FROM MSG_ANEXO WHERE COD_MENSAGEM = " 
	if (strCOD_MENSAGEM <> "") then	
		strSQL = strSQL & strCOD_MENSAGEM 
	else 
		if (strCOD_MENSAGEM_RE <> "") then strSQL = strSQL & strCOD_MENSAGEM_RE 
	end if		
	
	if (strSESSION <> "") then
		strSQL = "SELECT COD_MSG_TEMP_ANEXO AS CODIGO, ARQUIVO, DESCRICAO FROM MSG_TEMP_ANEXO WHERE [SESSION] LIKE '" & (strSESSION) & "'"  
	end If
	'Response.Write(strSQL)
	'Response.End()				
	Set objRS = objConn.Execute(strSQL)	
	'Response.Write(objRS.RecordCount)
	'Response.End()
	i=0
	do while not objRS.EOF
		strTEXTO = Trim(CStr(objRS("DESCRICAO") & ""))
		if strTEXTO = "" then strTEXTO = "<i>" & objRS("ARQUIVO") & "</i>" 
							
		strLINK = "<a href='../upload/" & Request.Cookies("VBOSS")("CLINAME") & "/MSG_Anexos/" & objRS("ARQUIVO") & "' target='_blank' style='color: #FC8902; text-decoration: underline; font-size:11px;  font-family:Tahoma;}' title='Clique para visualizar " & strTEXTO & "'>" & strTEXTO & "</a>" 
			
		if strSESSION <> "" or strCOD_MENSAGEM_RE<>"" then
%>
			<tr>
				<td width="1%"><input type='checkbox' name='chkAnexo_<%=i%>' value='<%=objRS("CODIGO")%>' <%if strCOD_MENSAGEM_RE<>"" then Response.Write("disabled")%>></td>
				<td width="99%" align="left"><%=strLINK%></td>
			</tr>
<%		else %>
			<tr>
				<td class="corpo_texto_mdo" colspan="2" align="left">
					<%=strLINK%>
				</td>
			</tr>
<%		end if
			i = i + 1
			objRS.MoveNext
	loop
		FechaRecordset(objRS)
%>
	<tr>
		<td colspan="2" height="5"></td>
	</tr>
	<% if (strSESSION<>"") or (strCOD_MENSAGEM_RE<>"") then %>
	<tr>
   	<td height="20" colspan="2" bgcolor="#CCCCCC">
			<div style="padding-left:20px;">
	    		<a OnMouseOver="window.status='Apagar Todos Selecionados';return true" OnClick="DeleteSelect(''); return false" href="#"> 
        			<img src="../img/IcoLixo.gif" alt="Apagar Anexos Selecionados" width="12" height="16" border="0">
				</a>
			</div>
		</td>
	</tr>
	<% end if %>
</form>
</table> 
</body>
</html>
<%
	end if 
	FechaDBConn(objConn)
%>