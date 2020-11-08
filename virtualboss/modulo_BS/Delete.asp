<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_BS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"--> 
<%
Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 

Dim objConn, objRS, strSQL, Idx
Dim strCODIGO, strTIPO, strCOD_BOLETIM
Dim strTITULO, strAVISO, strEXCLUI_BS

strCODIGO      = GetParam("var_chavereg")
strTIPO	       = GetParam("var_todolist")
strCOD_BOLETIM = GetParam("var_cod_boletim")

AbreDBConn objConn, CFG_DB 

if strCOD_BOLETIM<>"" then
	strTITULO = "Atividade/BS"
	strEXCLUI_BS = "true"
	strAVISO = "dlg_warning.gif:ATEN&Ccedil;&Atilde;O! Voc&ecirc; est&aacute; prestes a remover a atividade/BS " 
	strAVISO = strAVISO & "que est&aacute; sendo visualizado e suas tarefas. Para confirmar essa dele&ccedil;&atilde;o "
	strAVISO = strAVISO & "clique no bot&atilde;o [ok], para<br>desistir clique em [cancelar] "
		
	strSQL =          " SELECT T1.COD_BOLETIM, T1.TITULO, T1.SITUACAO, T1.COD_BOLETIM, T2.NOME "
	strSQL = strSQL & "       ,T1.PRIORIDADE, T1.ID_RESPONSAVEL, T1.DESCRICAO "
	strSQL = strSQL & "       ,(SELECT COUNT(R.COD_TODOLIST) FROM TL_RESPOSTA R "
	strSQL = strSQL & "           INNER JOIN TL_TODOLIST T ON (R.COD_TODOLIST=T.COD_TODOLIST) "
	strSQL = strSQL & "           WHERE T.COD_BOLETIM=" & strCOD_BOLETIM & ") AS RESPOSTAS"
	strSQL = strSQL & " FROM BS_BOLETIM T1 LEFT OUTER JOIN BS_CATEGORIA T2 ON (T1.COD_CATEGORIA = T2.COD_CATEGORIA)" 
	strSQL = strSQL & " WHERE T1.COD_BOLETIM = " & strCOD_BOLETIM 
	
	'athDebug strSQL, false
	
	Set objRS = objConn.Execute(strSQL)
	
	if CInt("0" & GetValue(objRS,"RESPOSTAS"))>0 then
		strAVISO =            "dlg_warning.gif:ATEN&Ccedil;&Atilde;O! Voc&ecirc; est&aacute; prestes a remover a atividade/BS " 
		strAVISO = strAVISO & "que est&aacute; sendo visualizado, suas tarefas e respostas. Para confirmar essa dele&ccedil;&atilde;o "
		strAVISO = strAVISO & "clique no bot&atilde;o [ok], <br>para desistir clique em [cancelar] "
	end if	
elseif strCODIGO <> "" then
	strTITULO = "ToDo List"
	
	strAVISO =            "dlg_warning.gif:ATEN&Ccedil;&Atilde;O! Voc&ecirc; est&aacute; prestes a remover o registro " 
	strAVISO = strAVISO & "que est&aacute; sendo visualizado. Para confirmar essa dele&ccedil;&atilde;o "
	strAVISO = strAVISO & "clique no bot&atilde;o [ok], para<br>desistir clique em [cancelar] "	
	
	strSQL =          " SELECT T1.COD_TODOLIST,T1.TITULO,T1.SITUACAO,T1.COD_BOLETIM "
	strSQL = strSQL & "       ,T2.NOME,T1.PRIORIDADE,T1.ID_RESPONSAVEL,T1.DESCRICAO "
	strSQL = strSQL & " FROM TL_TODOLIST T1 LEFT OUTER JOIN TL_CATEGORIA T2 ON (T1.COD_CATEGORIA = T2.COD_CATEGORIA)" 
	strSQL = strSQL & " WHERE T1.COD_TODOLIST = " & strCODIGO 
	
	Set objRS = objConn.Execute(strSQL)
end if

if strSQL <> "" then
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok()       { document.form_delete.submit(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, strTITULO & " - Exclus&atilde;o")%>
<% for Idx = 0 to objRS.fields.count - 3  'NÃO QUIS EXIBIR TODOS OS DADOS... %> 
	<div class='form_label'><%=objRS.Fields(Idx).name%>:</div><div class="form_bypass"><%=GetValue(objRS, objRS.Fields(Idx).name)%></div><br>
<% next %>
<form name="form_delete" action="Delete_exec.asp" method="post">
	<input type="hidden" name="var_cod_todo"    value="<%=strCODIGO%>">
	<input type="hidden" name="var_cod_boletim" value="<%=GetValue(objRS,"COD_BOLETIM")%>">
	<input type="hidden" name="var_todolist"    value="<%=strTIPO%>">
	<input type="hidden" name="var_exclui_bs"   value="<%=strEXCLUI_BS%>">
</form>
<%=athEndDialog(strAVISO, "../img/butxp_ok.gif", "document.form_delete.submit();", "../img/butxp_cancelar.gif", "cancelar();", "", "")%>
</body>
</html>
<%
	FechaRecordSet objRS
end if
FechaDBConn objConn
%>