<!--#include file="../_database/athdbConn.asp"--><%' ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_AGENDA", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"--> 
<%
Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os �tens de formul�rio 
Const auxAVISO  = "dlg_warning.gif:ATEN��O!Voc� est� prestes a remover o registro <br> acima visualizado. Para confirmar clique no bot�o [ok], para desistir clique em [cancelar]."
' -------------------------------------------------------------------------------
   
Dim ObjConn, objRS, strSQL
Dim strCODIGO, Idx

strCODIGO = GetParam("var_chavereg")

if GetParam("var_chavereg") <> "" then
	AbreDBConn objConn, CFG_DB 
  
	strSQL = 			" SELECT T1.TITULO"
	strSQL = strSQL & "       ,T1.SITUACAO"
	strSQL = strSQL & "       ,T2.NOME"
	strSQL = strSQL & "       ,T1.PRIORIDADE"
	strSQL = strSQL & "       ,T1.ID_RESPONSAVEL"
	strSQL = strSQL & "       ,T1.PREV_DT_INI"
	strSQL = strSQL & "       ,T1.DT_REALIZADO"
	strSQL = strSQL & "       ,T1.DESCRICAO"
	strSQL = strSQL & " FROM AG_AGENDA T1 INNER JOIN AG_CATEGORIA T2 ON (T1.COD_CATEGORIA=T2.COD_CATEGORIA)" 
	strSQL = strSQL & " WHERE COD_AGENDA = " & strCODIGO 
	Set objRS = objConn.Execute(strSQL)

	if not objRS.Eof then 
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Fun��es de a��o dos bot�es - In�cio ******
function ok()       { document.form_delete.submit(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
//****** Fun��es de a��o dos bot�es - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Agenda - Dele&ccedil;&atilde;o")%>     
<% for Idx = 0 to objRS.fields.count - 1  'N�O QUIS EXIBIR TODOS OS DADOS... %> 
	<div class='form_label'><%=objRS.Fields(Idx).name%>:</div><div class="form_bypass"><%=GetValue(objRS, objRS.Fields(Idx).name)%></div><br>
<% next %>
<form name="form_delete" action="Delete_exec.asp" method="post">
	<input type="hidden" name="var_chavereg" value="<%=strCODIGO%>">
	<input name="var_jscript_action"	type="hidden" value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input name="var_location" 			type="hidden" value=''>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok()", "../img/butxp_cancelar.gif", "cancelar();", "", "")%>
</body>
</html>
<%
      End If 
      FechaRecordSet objRS
	  FechaDBConn objConn
   End If 
%>