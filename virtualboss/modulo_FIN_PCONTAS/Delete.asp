<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_FIN_PCONTAS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<%
 Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "dlg_warning.gif:ATENÇÃO!Você está prestes a remover o registro <br> acima visualizado. Para confirmar clique no botão [ok], para desistir clique em [cancelar]."

   Dim ObjConn, objRS, strSQL
   Dim strCODIGO, Idx
   
   strCODIGO = GetParam("var_chavereg")
   
	If strCODIGO <> "" Then
		AbreDBConn objConn, CFG_DB 
		
		strSQL = "SELECT"							&_
					"	T1.COD_PLANO_CONTA," 		&_
					"	T1.COD_PLANO_CONTA_PAI," 	&_
					"	T1.COD_REDUZIDO,"			&_			
					"	T1.NOME,"					&_
					"	T2.NOME AS NOME_PAI,"		&_			
					"	T1.ORDEM,"					&_
					"	T1.DESCRICAO,"				&_			
					"	T1.DT_INATIVO "				&_
					"FROM"							&_
					"	FIN_PLANO_CONTA T1 "		&_
					"LEFT OUTER JOIN"				&_
					"	FIN_PLANO_CONTA T2 ON (T1.COD_PLANO_CONTA_PAI = T2.COD_PLANO_CONTA) "		&_
					"WHERE"							&_
					"	T1.COD_PLANO_CONTA=" &	strCODIGO
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		if not objRS.eof then
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
<%=athBeginDialog(WMD_WIDTH, "Planos de Contas - Dele&ccedil;&atilde;o")%>
<% for Idx = 0 to objRS.fields.count - 1  'NÃO QUIZ EXIBIR TODOS OS DADOS... %>
<br><div class="form_label"><%=objRS.Fields(Idx).name%>:</div><div class="form_bypass"><%=GetValue(objRS, objRS.Fields(Idx).name)%></div>
<% next %>
<form name="form_delete" action="../_database/athDeleteToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="FIN_PLANO_CONTA">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_PLANO_CONTA">
	<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODIGO%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value="parent.frames['vbTopFrame'].document.form_principal.submit();">
	<input type="hidden" name="DEFAULT_LOCATION" value=''>
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