<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|TRANS|", BuscaDireitosFromDB("modulo_TODOLIST", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"
 Dim i

 Dim strSQL, objRS, objRSAux, ObjConn
 Dim Cont, strVALOR

 AbreDBConn objConn, CFG_DB
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
//****** Funções de ação dos botões - Início ******
function ok()       { document.form_2.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_2.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() { document.form_2.submit(); }
//****** Funções de ação dos botões - Fim ******

function atualizaFrame(){
	
		document.getElementById("var_dt_ini").value            = document.getElementById("var_data_inicio").value; 
		document.getElementById("var_dt_fim").value            = document.getElementById("var_data_fim").value; 
		document.getElementById("var_sit").value               = document.getElementById("var_situacao").value; 
		document.getElementById("var_responsavel_atual").value = document.getElementById("var_resp_atual").value;  
		document.form_1.submit();
}
</script>
</head>
<body Onload="selecionaop();">
<%=athBeginDialog(WMD_WIDTH, "ToDo List - Tranferência de Respons&aacute;vel")%>

	<div class="form_label" style="float:left;"></div><div class="form_bypass_multiline" style="display:block;" >
	    Este formul&aacute;rio permite a transfer&ecirc;ncia de respons&aacute;vel de tarefas.<br>
        Informe o período e o responsável atual das tarefas a serem transferidas, e após o novo responsável.
    </div>	
	
<form name="form_1" action="ifr_TransfereResponsavel.asp" method="post" target="ifr_listatarefa">			
		<br><div class="form_label"><b>Per&iacute;odo&nbsp;</b>* Início:</div><%=InputDate("var_data_inicio","edtext",PrepData(Date,true,false),false)%>&nbsp;<%=ShowLinkCalendario("form_1", "var_data_inicio", "ver calendário")%>&nbsp;<span class="texto_ajuda"><i>dd/mm/aaaa</i></span>
		<br><div class="form_label">* Fim:</div><%=InputDate("var_data_fim","edtext",PrepData(Date,true,false),false)%>&nbsp;<%=ShowLinkCalendario("form_1", "var_data_fim", "ver calendário")%>&nbsp;<span class="texto_ajuda"><i>dd/mm/aaaa</i></span>
        <br><div class="form_label">Situa&ccedil;&atilde;o:</div><select name="var_situacao" id="var_situacao" class="edtext_combo" style="width:115px;">					
					<option value="ABERTO">Aberto</option>
					<!--option value="EXECUTANDO">Executando</option>
					<option value="CANCELADO">Cancelado</option//-->
					<option value="FECHADO">Fechado</option>
					<!--option value="OCULTO">Oculto</option>
					<option value="_ABERTO">Não aberto</option>
					<option value="_EXECUTANDO">Não Executando</option>
					<option value="_CANCELADO" selected>Não Cancelado</option>
					<option value="_FECHADO" selected>Não Fechado</option//-->
				</select>
       	<br><div class="form_label">* Resp. Atual:</div><select name="var_resp_atual" id="var_resp_atual" class="edtext_combo" style="width:80px;" onChange="javascript:atualizaFrame();return false;" >
				<option value=""></option>
					<%=montaCombo("STR","SELECT concat(ID_USUARIO, if(dt_inativo is null,'','(i)')) AS LABEL, ID_USUARIO FROM USUARIO WHERE tipo='ENT_COLABORADOR' and ID_USUARIO NOT IN('_athenas','_admin') ORDER BY dt_inativo, ID_USUARIO", "ID_USUARIO", "LABEL", "")%>
				</select>
        <br><div class="form_label"></div><div align="right"> <span onClick="javascript:atualizaFrame();return false;" style="cursor:pointer; font-family:'Courier New', Courier, monospace;">[atualizar]</span></div>
		<div class="form_label"></div><iframe src="ifr_TransfereResponsavel.asp" width="355px" height="150px" name="ifr_listatarefa" id="ifr_listatarefa" frameborder="0" style="border:1px #777777 solid;"></iframe>
</form>
 <div class="form_grupo" id="form_grupo_2"> 
 	<form name="form_2" action="TransfereTarefa_exec.asp" method="post" >	
        <input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
		<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_TODOLIST/TransfereTarefa.asp'>
        <input type="hidden" id="var_dt_ini" name="var_dt_ini" value="">
        <input type="hidden" id="var_dt_fim" name="var_dt_fim" value="">
        <input type="hidden" id="var_responsavel_atual" name="var_responsavel_atual" value="">
        <input type="hidden" id="var_sit" name="var_sit" value="">   
		<br><br><div class="form_label">* Resp. Novo:</div><select name="var_responsavel_novo" id="var_responsavel_novo"  style="width:80px;" >
				<option value=""></option>
					<%=montaCombo("STR","SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL AND tipo='ENT_COLABORADOR' and ID_USUARIO NOT IN('_athenas','_admin') ORDER BY TIPO DESC, ID_USUARIO", "ID_USUARIO", "ID_USUARIO", "")%>
				</select>
    
	</form>
  </div>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>
<%
FechaDBConn objConn
%>