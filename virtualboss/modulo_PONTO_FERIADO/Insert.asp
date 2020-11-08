<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_PONTO_FERIADO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok()			{ document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar()		{ parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()      { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() { document.form_insert.submit(); }
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Feriado/Recesso - Inserção") %>
<form name="form_insert" action="../_database/athInsertToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"		value="PT_FERIADO">
	<input type="hidden" name="DEFAULT_DB"			value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"		value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"		value="COD_FERIADO">
	<input type="hidden" name="JSCRIPT_ACTION"   	value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" 	value='../modulo_PONTO_FERIADO/insert.asp'>
	<div class="form_label">Dia:</div><select name="DBVAR_NUM_DATA_DIA" style="width:40px">
									  	<option value="1">01</option>
									    <option value="2">02</option>
									    <option value="3">03</option>
									    <option value="4">04</option>
									    <option value="5">05</option>
										<option value="6">06</option>
										<option value="7">07</option>
										<option value="8">08</option>
										<option value="9">09</option>
										<option value="10">10</option>
										<option value="11">11</option>
										<option value="12">12</option>
										<option value="13">12</option>
										<option value="14">14</option>
										<option value="15">15</option>
										<option value="16">16</option>
										<option value="17">17</option>
										<option value="18">18</option>
										<option value="19">19</option>
										<option value="20">20</option>
										<option value="21">21</option>
										<option value="22">22</option>
										<option value="23">23</option>
										<option value="24">24</option>
										<option value="25">25</option>
										<option value="26">26</option>
										<option value="27">27</option>
										<option value="28">28</option>
										<option value="29">29</option>
										<option value="30">30</option>
										<option value="31">31</option>
									  </select>
	<br><div class="form_label">Mês:</div><select name="DBVAR_NUM_DATA_MES" style="width:40px">
										    <option value="1">01</option>
										    <option value="2">02</option>
										    <option value="3">03</option>
											<option value="4">04</option>
											<option value="5">05</option>
											<option value="6">06</option>
											<option value="7">07</option>
											<option value="8">08</option>
											<option value="9">09</option>
											<option value="10">10</option>
											<option value="11">11</option>
											<option value="12">12</option>
										  </select>
	<br><div class="form_label">Ano:</div><select name="DBVAR_NUM_DATA_ANO" style="width: 60px" >
										    <%=montaComboAno(4)%>
							 		    	<option value="" selected="selected"></option>
									      </select>	
										  <span class="texto_ajuda">*VAZIO indica QUALQUER Ano</span>					
	<br><div class="form_label">UF:</div><select name="DBVAR_STR_UF" style="width:150px">
											<option></option>
											<option value="AC">AC-Acre</option>
											<option value="AL">AL-Alagoas</option>
											<option value="AP">AP-Amapá</option>
											<option value="AM">AM-Amazonas</option>
											<option value="BA">BA-Bahia</option>
											<option value="CE">CE-Ceará</option>
											<option value="DF">DF-Distrito Federal</option>
											<option value="ES">ES-Espirito Santo</option>
											<option value="GO">GO-Goiás</option>
											<option value="MA">MA-Maranhão</option>
											<option value="MT">MT-Mato Grosso</option>
											<option value="MS">MS-Mato Grosso do Sul</option>
											<option value="MG">MG-Minas Gerais</option>
											<option value="PA">PA-Pará</option>
											<option value="PB">PB-Paraiba</option>
											<option value="PR">PR-Paraná</option>
											<option value="PE">PE-Pernambuco</option>
											<option value="PI">PI-Piauí</option>
											<option value="RJ">RJ-Rio de Janeiro</option>
											<option value="RN">RN-Rio Grande do Norte</option>
											<option value="RS">RS-Rio Grande do Sul</option>
											<option value="RO">RO-Rondônia</option>
											<option value="RR">RR-Roraima</option>
											<option value="SC">SC-Santa Catarina</option>
											<option value="SP">SP-São Paulo</option>
											<option value="SE">SE-Sergipe</option>
											<option value="TO">TO-Tocantis</option>
										  </select>
										  <span class="texto_ajuda">*VAZIO indica todos estados</span>
	<br><div class="form_label">Observa&ccedil;&atilde;o:</div><textarea name="DBVAR_STR_DESCRICAO" rows="5" cols="5" style="width:280px"></textarea>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>