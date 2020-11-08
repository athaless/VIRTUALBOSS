<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
Dim objConn, objRS, strSQL
Dim strCODIGO, strTIPO
Dim strDT_INI, strDT_FIM, strAUX

strDT_INI = DateSerial(DatePart("YYYY", Date), DatePart("M", Date), 1)
strDT_FIM = DateAdd("D", -1, DateAdd("M", 1, strDT_INI))

AbreDBConn objConn, CFG_DB
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script>
function ExecAcao(pr_form, pr_input) {
	var form = eval("document." + pr_form + "." + pr_input);
	if (form.value == "IMPRIMIR")   { 
		parent.frames["vbMainFrame"].focus();
		parent.frames["vbMainFrame"].print();
	}
	form.value='';
}

function SelecionaOpcao(prTipo) {
	if (prTipo == 'fixo')  document.form_principal.var_periodo_fixo.checked = true;
	if (prTipo == 'livre') document.form_principal.var_periodo_livre.checked = true;
}

</script>
<script type="text/javascript" language="javascript" src="../_scripts/checkbox.js"></script>
</head>
<body onLoad="javascript:init();document.form_principal.submit();">
<table class="top_table" style="width:100%; height:58px; border:0px; margin:0px; padding:0px; vertical-align:top; border-collapse:collapse; ">
<tr> 
 	<td width="1%" class="top_menu" style="background-image:url(../img/Menu_TopBgLeft.jpg);    vertical-align:top; padding:10px 0px 0px 10px;  border-collapse:collapse;">
		<b>Lctos Gerais</b>
		<%=montaMenuCombo("form_acoes","var_nome","width:120px","ExecAcao(this.form.name,this.name);","IMPRIMIR:IMPRIMIR")%>
	</td>
	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
		<div class="form_line">
			<form name="form_principal" id="form_principal" method="get" action="<%=CFG_MAIN_GRID%>" target="vbMainFrame">
				<div class="form_label_nowidth">Cód.</div><input name="var_cod_lcto" id="var_cod_lcto" type="text" style="width:40px;" class="edtext" maxlength="10" value=""> 
				<input type="hidden" class="inputclean" name="var_periodo" id="var_periodo_livre" value="LIVRE" checked="checked">
				<div class="form_label_nowidth">De:</div><input name='var_dt_ini' id='var_dt_ini' class='edtext' value='<%=PrepData(strDT_INI, True, False)%>' type='text' maxlength='10' style='width:60px;' onKeyUp="Javascript:FormataInputData('form_principal', 'var_dt_ini');" onKeyPress="Javascript:validateNumKey(); SelecionaOpcao('livre');">			
				<div class="form_label_nowidth">-</div><input name='var_dt_fim' id='var_dt_fim' class='edtext' value='<%=PrepData(strDT_FIM, True, False)%>' type='text' maxlength='10' style='width:60px;' onKeyUp="Javascript:FormataInputData('form_principal', 'var_dt_fim');" onKeyPress="Javascript:validateNumKey(); SelecionaOpcao('livre');">			
				<!-- conforme informado pelo aless não é mais necessário
				<div class="form_label_nowidth"><a href="Javascript://;" onClick="Javascript:AbreJanelaPAGE('BuscaPlanoConta.asp?var_form=form_principal&var_retorno1=var_cod_plano_conta', '640', '365');">[?]</a></div>
				//-->
				<% 
				strSQL =          " SELECT T1.COD_PLANO_CONTA, T1.COD_REDUZIDO, T1.NOME "
				strSQL = strSQL & " FROM FIN_PLANO_CONTA T1 "
				strSQL = strSQL & " WHERE T1.DT_INATIVO IS NULL "
				strSQL = strSQL & "	ORDER BY T1.COD_REDUZIDO, T1.NOME "
				%>
				<select name="var_cod_plano_conta" class="edtext_combo" style="width:180px;">
					<option value="">[Plano de Conta]</option>
					<%
					Set objRS = objConn.Execute(strSQL)
					Do While Not objRS.Eof
						Response.Write("<option value='" & GetValue(objRS, "COD_PLANO_CONTA") & "'>")
						If GetValue(objRS, "COD_REDUZIDO") <> "" Then Response.Write(GetValue(objRS, "COD_REDUZIDO") & " ")
						Response.Write(GetValue(objRS, "NOME") & "</option>")
						
						objRS.MoveNext
					Loop
					FechaRecordSet objRS
					%>
				</select>
				<!-- conforme informado pelo aless não é mais necessário
				<div class="form_label_nowidth"><a href="Javascript://;" onClick="Javascript:AbreJanelaPAGE('BuscaCentroCusto.asp?var_form=form_principal&var_retorno1=var_cod_centro_custo', '640', '365');">[?]</a></div>
				//-->
				<% 
                'ToDo 14959 - Aless pediu para incluir filtro por centro de custos - By Vini 07.11.2012
				
				strSQL =          " SELECT T1.COD_CENTRO_CUSTO, T1.COD_REDUZIDO, T1.NOME "
				strSQL = strSQL & " FROM FIN_CENTRO_CUSTO T1 "
				strSQL = strSQL & " WHERE T1.DT_INATIVO IS NULL "
				strSQL = strSQL & "	ORDER BY T1.COD_REDUZIDO, T1.NOME "
				%>
				<select name="var_cod_centro_custo" class="edtext_combo" style="width:180px;">
					<option value="">[Centro de Custo]</option>
					<%
					Set objRS = objConn.Execute(strSQL)
					Do While Not objRS.Eof
						Response.Write("<option value='" & GetValue(objRS, "COD_CENTRO_CUSTO") & "'>")
						If GetValue(objRS, "COD_REDUZIDO") <> "" Then Response.Write(GetValue(objRS, "COD_REDUZIDO") & " ")
						Response.Write(GetValue(objRS, "NOME") & "</option>")
						
						objRS.MoveNext
					Loop
					FechaRecordSet objRS
					%>
				</select>
				<select name="var_cod_conta" class="edtext_combo" style="width:135px;">
				<!-- como parâmetro é obrigatório não pode passar vazio -->
				<!-- <option value='' selected>[Conta]</option> -->
				<%
				strSQL =          " SELECT COD_CONTA, NOME, DT_INATIVO FROM FIN_CONTA "
				strSQL = strSQL & " ORDER BY DT_INATIVO, ORDEM, NOME "
				
				Set objRS = objConn.Execute(strSQL)
				
				strAUX = ""
				Do While Not objRS.Eof
					If GetValue(objRS, "DT_INATIVO") <> "" And strAUX = "" Then
						strAUX = "<optgroup label='Inativas'>"
						Response.Write(strAUX)
					End If
					Response.Write("<option value='" & GetValue(objRS, "COD_CONTA") & "'>")
					Response.Write(GetValue(objRS, "NOME") & "</option>")
					
					objRS.MoveNext
				Loop
				If strAUX <> "" Then Response.Write("</optgroup>")
				
				FechaRecordSet objRS
				%>
				</select>
				<input type="hidden" name="var_codigo" id="var_codigo" value="<%=strCODIGO%>">
				<input type="hidden" name="var_tipo"   id="var_tipo"   value="<%=strTIPO%>">
				<select name="var_entidade" class="edtext_combo" size="1" style="width:145px;" 
					onChange="if (this.value!='') AbreJanelaPAGE('BuscaPorEntidade.asp?var_form=form_principal&var_input=var_codigo&var_input_tipo=var_tipo&var_tipo=' + this.value, '640', '390');
							  document.form_principal.var_tipo.value='';
							  document.form_principal.var_codigo.value='';">
					<option value="" selected>[Entidade]</option>
					<%=MontaCombo("STR","SELECT TIPO, DESCRICAO FROM SYS_ENTIDADE ORDER BY DESCRICAO ","TIPO","DESCRICAO","")%>
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
<%
FechaDBConn objConn
%>