<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim objConn, objRS, strSQL
Dim strNIVEL, strSUBNIVEL

AbreDBConn objConn, CFG_DB
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script type="text/javascript" language="JavaScript">
function ExecAcao(pr_form, pr_input) {
	var form = eval("document." + pr_form + "." + pr_input);
	if (form.value == "DESP")   { parent.frames["vbMainFrame"].document.location.href = "Insert.asp?var_tipo=DESP"; }
	if (form.value == "REC")    { parent.frames["vbMainFrame"].document.location.href = "Insert.asp?var_tipo=REC"; }
	if (form.value == "TRANSF") { parent.frames["vbMainFrame"].document.location.href = "InsertTransf.asp"; }
	form.value='';
}
</script>
<script type="text/javascript" language="javascript" src="../_scripts/checkbox.js"></script>
</head>
<body onLoad="javascript:init();document.form_principal.submit();">
<table class="top_table" style="width:100%; height:58px; border:0px; margin:0px; padding:0px; vertical-align:top; border-collapse:collapse; ">
<tr> 
 	<td width="1%" class="top_menu" style="background-image:url(../img/Menu_TopBgLeft.jpg);    vertical-align:top; padding:10px 0px 0px 10px;  border-collapse:collapse;">
		<b>Lctos em Conta</b>
		<%=montaMenuCombo("form_acoes","var_nome","width:120px","ExecAcao(this.form.name,this.name);","DESP:INSERIR DESP;REC:INSERIR REC;TRANSF:INSERIR TRANSF")%>
	</td>
	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
		<div class="form_line">
			<form name="form_principal" id="form_principal" method="get" action="<%=CFG_MAIN_GRID%>" target="vbMainFrame">
				<div class="form_label_nowidth">Período:</div><select name="var_periodo" class="edtext_combo" size="1" onChange="var_dt_ini.value=''; var_dt_fim.value='';">
					<option value="ULT_15D" selected>Últimos 15 dias</option>
					<option value="MES_ATUAL">Mês atual</option>
					<option value="MES_ANTERIOR">Mês anterior</option>
					<option value="INIC_ANO">Desde início do ano</option>
					<option value="ULT_60D">Últimos 60 dias</option>
					<option value="ULT_90D">Últimos 90 dias</option>
					<option value="ULT_12M">Últimos 12 meses</option>
					<option value="ESPECIFICO">Específico</option>
				</select>
				<div class="form_label_nowidth">De:</div><input name="var_dt_ini" class="edtext" value="" type="text" size='10' maxlength='10' style="width:70px;" 
											onkeyUp="Javascript:FormataInputData('form_principal', 'var_dt_ini'); return autoTab(this, 10, event);" 
											onFocus="this.value=''; var_dt_fim.value='';"
											onkeypress='validateNumKey();'> 
				<div class="form_label_nowidth"> - </div><input name="var_dt_fim" class="edtext" value="" type="text" size='10' maxlength='10' style="width:70px;" onkeyUp="Javascript:FormataInputData('form_principal', 'var_dt_fim');" onkeypress='validateNumKey();'> 
				<select name="var_fin_conta" class="edtext_combo" style="width:183px">
					<option value="" selected>[Conta]</option>
					<%
					strSQL =          " SELECT COD_CONTA, NOME FROM FIN_CONTA "
					strSQL = strSQL & " WHERE DT_INATIVO IS NULL "
					strSQL = strSQL & " ORDER BY NOME "
					Set objRS = objConn.Execute(strSQL)
					
					Do While Not objRS.Eof
						Response.Write("<option value='" & GetValue(objRS, "COD_CONTA") & "'>" & GetValue(objRS, "NOME") & "</option>")
						objRS.MoveNext
					Loop
					FechaRecordSet objRS
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
<% FechaDBConn objConn %>