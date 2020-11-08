<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_BS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"--> 
<%
	Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
    Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"
	
	Dim strSQL, objRS, objRSAux1, objRSAux2, ObjConn
	Dim strCODIGO, strTAREFA
	Dim strArquivo,strArquivoAnexo, strDESCRICAO
	Dim strPREV_HORAS_HH, strPREV_HORAS_MM
	Dim arrBS_EQUIPE, strCLIENTE, strFECHA
	Dim strCITADOS

	' Variaveis usadas para visualizar Tarefas
	Dim strTDTITULO, strPREV_HORAS, auxHS
	Dim strGRUPO_USUARIO, strID_RESPONSAVEL, strCOOKIE_ID_USUARIO
	
	strCODIGO = GetParam("var_chavereg")
	strTAREFA = GetParam("var_todolist")
	
	strCOOKIE_ID_USUARIO = LCase(Request.Cookies("VBOSS")("ID_USUARIO"))
	strGRUPO_USUARIO  = UCase(Request.Cookies("VBOSS")("GRUPO_USUARIO"))	
	strCITADOS = LCase(strCOOKIE_ID_USUARIO)
	
	if strCODIGO<>"" then
		AbreDBConn objConn, CFG_DB 
		
		strSQL = "SELECT" 																		&_
					"	BS.COD_BOLETIM,"														&_
					"	BS.COD_CLIENTE,"														&_
					"	BS.COD_CATEGORIA,"														&_
					"	CAT.NOME,"																&_
					"	BS.ID_RESPONSAVEL,"														&_
					"	BS.TITULO,"																&_
					"	BS.DESCRICAO,"															&_
					"	BS.SITUACAO,"															&_
					"	BS.TIPO,"																&_
					"	BS.PRIORIDADE "															&_
					"FROM"																		&_
					"	BS_BOLETIM BS "															&_
					"INNER JOIN"																&_
					"	BS_CATEGORIA CAT ON (BS.COD_CATEGORIA=CAT.COD_CATEGORIA) "	&_
					"WHERE"	&_
					"	BS.COD_BOLETIM ="  & strCODIGO
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		
		if not objRS.eof then
			strCLIENTE 	= GetValue(objRS,"COD_CLIENTE")
			strDESCRICAO= GetValue(objRS,"DESCRICAO")
			strID_RESPONSAVEL = LCase(GetValue(objRS,"ID_RESPONSAVEL"))
			
			strSQL = "SELECT ID_USUARIO FROM BS_EQUIPE WHERE COD_BOLETIM=" & objRS("COD_BOLETIM") & " AND DT_INATIVO IS NULL ORDER BY ID_USUARIO"
			AbreRecordSet objRSAux1, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
			arrBS_EQUIPE = ""
			
			while not objRSAux1.eof 
				arrBS_EQUIPE = arrBS_EQUIPE & LCase(objRSAux1("ID_USUARIO"))
				objRSAux1.MoveNext
				if not objRSAux1.eof then arrBS_EQUIPE = arrBS_EQUIPE &  ";"
			wend 					
			strCITADOS = arrBS_EQUIPE		
			FechaRecordSet objRSAux1		
	
			strSQL =	"SELECT"																	&_
						"	TL.COD_TODOLIST,"														&_
						"	TL.ID_RESPONSAVEL,"														&_
						"	TL.ID_ULT_EXECUTOR,"													&_
						"	TL.TITULO,"																&_
						"	TL.PREV_DT_INI,"														&_
						"	TL.PREV_HR_INI,"														&_									
						"	TL.PREV_HORAS,"															&_
						"	TL.SITUACAO,"															&_
						"	COUNT(R.COD_TODOLIST) AS RESPOSTAS," 									&_
						"	(SELECT SUM(PREV_HORAS) FROM TL_TODOLIST WHERE COD_BOLETIM=" & strCODIGO & ")  AS TOTAL_PREV " &_				
						"FROM"																		&_
						"	TL_TODOLIST TL "														&_
						"LEFT OUTER JOIN "															&_
						"	TL_RESPOSTA R ON (R.COD_TODOLIST=TL.COD_TODOLIST) "						&_				
						"WHERE"																		&_
						"	TL.COD_BOLETIM = " 	& strCODIGO & " " 									&_
						"GROUP BY" 																	&_
						"	TL.COD_TODOLIST,"														&_
						"	TL.ID_RESPONSAVEL,"														&_
						"	TL.ID_ULT_EXECUTOR,"													&_
						"	TL.TITULO,"																&_
						"	TL.PREV_DT_INI,"														&_
						"	TL.PREV_HR_INI,"														&_									
						"	TL.PREV_HORAS,"															&_
						"	TL.SITUACAO "															&_
						"ORDER BY TL.PREV_DT_INI, TL.PREV_HR_INI "
			AbreRecordSet objRSAux1, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<!-- link rel="stylesheet" type="text/css" href="../_css/tablesort.css" -->
<script language="JavaScript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok()       { document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_update.var_titulo.value == '') var_msg += '\nTítulo';
	if (document.form_update.var_cod_cliente.value == '') var_msg += '\nCliente';
	if (document.form_update.var_situacao.value == '') var_msg += '\nSituação';
	if (document.form_update.var_cod_e_desc_categoria.value == '') var_msg += '\nCategoria';
	if (document.form_update.var_prioridade.value == '') var_msg += '\nPrioridade';
	if (document.form_update.var_id_responsavel.value == '') var_msg += '\nResponsável';
	if (document.form_update.var_descricao.value == '') var_msg += '\nTarefa';
	
	if (var_msg == '')
		document.form_update.submit();
	else
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Atividade/BS - Alteração")%>
<form name="form_update" action="update_exec.asp" method="post">
	<input type="hidden" name="var_cod_boletim" value="<%=strCODIGO%>">
	<input type="hidden" name="var_todolist" value="<%=strTAREFA%>">
	<input type="hidden" name="JSCRIPT_ACTION" value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_BS/Update.asp?var_chavereg=<%=strCODIGO%>'>
	<div class="form_label">*Título:</div><input name="var_titulo" type="text" style="width:300px" value="<%=GetValue(objRS,"TITULO")%>">
	<br><div class="form_label">*Cliente:</div><input name="var_cod_cliente" type="text" value="<%=strCLIENTE%>" size="5" onKeyPress="validateNumKey();">&nbsp;<a href="#" onClick="JavaScript:AbreJanelaPAGE('BuscaPorEntidade.asp?var_form=form_update', '600', '350');"><img src="../img/BtBuscar.gif" alt="Buscar entidade..." border="0" style="vertical-align:top; padding-top:2px" vspace="0" hspace="0"></a>
	<br><div class="form_label">*Situação:</div><select name="var_situacao" style="width:100px;">
				<option value="ABERTO"  	<% if GetValue(objRS,"SITUACAO")="ABERTO"    then Response.Write("selected")%>>ABERTO</option>
				<option value="FECHADO" 	<% if GetValue(objRS,"SITUACAO")="FECHADO"   then Response.Write("selected")%>>FECHADO</option>
				<option value="CANCELADO" 	<% if GetValue(objRS,"SITUACAO")="CANCELADO" then Response.Write("selected")%>>CANCELADO</option>							
			</select>
	<br><div class="form_label">*Categoria:</div><select name="var_cod_e_desc_categoria" style="width:100px;">
				<option value="">[selecione]</option>
				<%
				strSQL = " SELECT COD_CATEGORIA, NOME FROM BS_CATEGORIA WHERE DT_INATIVO IS NULL ORDER BY NOME "
				Set objRSAux2 = objConn.Execute(strSQL)
				
				Do While Not objRSAux2.Eof
					Response.Write("<option value='" & GetValue(objRSAux2,"COD_CATEGORIA") & " - " & GetValue(objRSAux2,"NOME") & "'")
					If CStr(GetValue(objRS,"COD_CATEGORIA")) = CStr(GetValue(objRSAux2,"COD_CATEGORIA")) Then Response.Write(" selected")
					Response.Write(">" & GetValue(objRSAux2,"NOME") & "</option>")
					
					objRSAux2.MoveNext
				Loop
				FechaRecordSet objRSAux2
				%>
			</select> 
	<br><div class="form_label">*Prioridade:</div><select name="var_prioridade" style="width:100px;">
				<option value="NORMAL" <% if GetValue(objRS,"PRIORIDADE") = "NORMAL" then Response.Write("selected='selected'")%>>NORMAL</option>
				<option value="BAIXA"  <% if GetValue(objRS,"PRIORIDADE") = "BAIXA"  then Response.Write("selected='selected'")%>>BAIXA</option>
				<option value="MEDIA"  <% if GetValue(objRS,"PRIORIDADE") = "MEDIA"  then Response.Write("selected='selected'")%>>MÉDIA</option>
				<option value="ALTA"   <% if GetValue(objRS,"PRIORIDADE") = "ALTA"   then Response.Write("selected='selected'")%>>ALTA</option>
			</select>
	<br><div class="form_label">*Responsável:</div><select name="var_id_responsavel" style="width:100px;">
				<option value="">[selecione]</option>
				<%=montaCombo("STR","SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL ORDER BY ID_USUARIO","ID_USUARIO","ID_USUARIO",LCase(GetValue(objRS,"ID_RESPONSAVEL")))%>
			</select>
	<br><div class="form_label">Equipe:</div><input name="var_equipe" type="text" value="<%=strCITADOS%>" style="width:300px;">&nbsp;<a href="#" onClick="JavaScript:AbreJanelaPAGE('BuscaPorUsuario.asp?var_form=form_update', '600', '350');"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:top; padding-top:2px" vspace="0" hspace="0"></a>
	<br><div class="form_label">*Tarefa:</div><textarea name="var_descricao" style="width:350px; height:160px;"><%=Replace(strDESCRICAO,"<ASLW_APOSTROFE>","'")%></textarea>
	<br><div class="form_label">Tipo:</div><select name="var_tipo" style="width:100px;">
			<option value="MODELO" <% if GetValue(objRS,"TIPO")="MODELO" then Response.Write("selected='selected'")%>>MODELO</option>
			<option value="NORMAL" <% if GetValue(objRS,"TIPO")="NORMAL" then Response.Write("selected='selected'")%>>NORMAL</option>
		</select>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<% if strTAREFA="TRUE" then %>		
<table border="0" align="center" cellpadding="3" cellspacing="0" width="100%" height="100%">
	<tr>
		<td align="center" width="100%" height="100%" valign="top">
			<iframe name="ifrm_td" style="" src="Insert_ToDo.asp?var_chavereg=<%=strCODIGO%>" width="530px" height="550px" frameborder="0" scrolling="no"></iframe>
		</td>
	</tr>
</table>
<%	end if %>
</body>
</html>
<%
	end if 
	FechaDBConn objConn
end if 
%>