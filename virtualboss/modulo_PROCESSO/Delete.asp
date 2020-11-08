<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_PROCESSO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<%
Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
Const auxAVISO  = "dlg_warning.gif:ATENÇÃO!Você está prestes a remover o registro <br> acima visualizado. Para confirmar clique no botão [ok], para desistir clique em [cancelar]."
' -------------------------------------------------------------------------------
Dim objConn, objRS, strSQL
Dim strCODIGO, Idx
   
   strCODIGO = GetParam("var_chavereg")
	
   If strCODIGO <> "" Then
	  AbreDBConn objConn, CFG_DB 
	  
	  strSql =          "SELECT T1.COD_PROCESSO, T1.ID_PROCESSO, T1.NOME, T1.DESCRICAO, T1.AUTORES, T1.DATA, T1.DT_HOMOLOGACAO, T1.COD_CATEGORIA, T2.NOME AS CATEGORIA "
	  strSql = strSql & "      ,T1.SYS_DT_CRIACAO, T1.SYS_INS_ID_USUARIO, T1.SYS_DT_ALTERACAO, T1.SYS_ALT_ID_USUARIO " 
	  strSql = strSql & "  FROM PROCESSO T1, TL_CATEGORIA T2 "
	  strSql = strSql & " WHERE T1.COD_CATEGORIA = T2.COD_CATEGORIA " 
	  strSql = strSql & "   AND T1.COD_PROCESSO = " & strCODIGO 
	  
	  AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	

      If Not objRS.Eof Then 
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
<%=athBeginDialog(WMD_WIDTH, "Processos - Dele&ccedil;&atilde;o")%>
<% for Idx = 0 to objRS.fields.count - 7  'NÃO QUIS EXIBIR TODOS OS DADOS... %> 
	<div class='form_label'><%=objRS.Fields(Idx).name%>:</div><div class="form_bypass"><%=GetValue(objRS, objRS.Fields(Idx).name)%></div><br>
<% next %>     
<form name="form_delete" action="../modulo_PROCESSO/DeleteExec.asp" method="post">
	<input type="hidden" name="var_chavereg" value="<%=strCODIGO%>">
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