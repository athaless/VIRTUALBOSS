<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_PONTO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html;">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/javascript">
/*------------------------------------------------------------------------------------
	Validação de horários para inserção correta, os totalizadores dependem disto!

	VerifyRangeHHMM(vlr_hhmm, op)-> Intervalos dos horários
	VerifyValuesHHMM(vlr_hh1, vlr_hh2, vlr_mm1, vlr_mm2) -> Testa o conteúdo
	VerifyCampos()	->  Nos campos de horários
------------------------------------------------------------------------------------*/
function VerifyRangeHHMM(vlr_hhmm, op)
{
	if (!isNaN(vlr_hhmm))
	{
		 if (op=='HH')
		 { 
		   if ( (parseInt(vlr_hhmm) >= 0) && (parseInt(vlr_hhmm) <24) ) 
			{ return true; }
		   else
			{ return false; }
		 }
		 else
		 { 
		   if ( (parseInt(vlr_hhmm) >= 0) && (parseInt(vlr_hhmm) <60) ) 
			{ return true; }
		   else
			{ return false; }
		 }
	}
	else
	{
		if (vlr_hhmm==null)	{ return true; }
		event.keyCode = 0;
	}
}

function VerifyValuesHHMM(vlr_hh1, vlr_hh2, vlr_mm1, vlr_mm2)
{
   if (  ( (parseInt(vlr_hh1) == 0) && (parseInt(vlr_hh2) == 0) && (parseInt(vlr_mm1) == 0) && (parseInt(vlr_mm2) == 0) ) 
	   ||( (parseInt(vlr_hh1) != 0) && (parseInt(vlr_hh2) == 0) && (parseInt(vlr_mm2) == 0) && (parseInt(vlr_hh2) <= parseInt(vlr_hh1)) ) ) 
    { return true; }
	else
   	if (parseInt(vlr_hh1) > parseInt(vlr_hh2))
    { 
     return false;
    }
   	else 
     	if (parseInt(vlr_hh1) == parseInt(vlr_hh2)) 
      	{
        	if (parseInt(vlr_mm1) > parseInt(vlr_mm2)) 
         	{ 
			 return false;	
			}
			else return true;
       }
	    else return true;
}
/* FINAL DA VALIDAÇÃO --------------------------- */

//****** Funções de ação dos botões - Início ******
function ok()       { document.form_insert.DEFAULT_LOCATION.value=""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_insert.JSCRIPT_ACTION.value="";   submeterForm(); }
function submeterForm() {
 var FlagErro=false;

 if ( VerifyRangeHHMM(document.form_insert.var_hh1.value, 'HH') && VerifyRangeHHMM(document.form_insert.var_hh2.value, 'HH') &&
      VerifyRangeHHMM(document.form_insert.var_mm1.value, 'MM') && VerifyRangeHHMM(document.form_insert.var_mm2.value, 'MM') ) { 
   FlagErro=false;
 }

 if (FlagErro) 
   { 
     alert ('Verifique se você inseriu horários exatamente iguais e/ou imcompatíveis, favor efetuar a(s) correção(ões) do(s) intervalo(s) de tempo trabalhado corretamente! O Total dos Horários depende deste(s) acerto(s).'); 
   } 
 else 
   {
     if ( VerifyValuesHHMM(document.form_insert.var_hh1.value, document.form_insert.var_hh2.value, document.form_insert.var_mm1.value, document.form_insert.var_mm2.value) ) 
       { FlagErro = false; } 
     else 
       { FlagErro = true; } 
   }	 

 if (FlagErro) 
   { 
     alert ('Verifique se você inseriu horários exatamente iguais e/ou imcompatíveis (fora de ordem), pois ainda existe(m) algum(uns) horário(s) incorreto(s), favor efetuar a(s) correção(ões)!'); 
   } 
 else 
   { 
     if (parseInt(form_insert.var_dt_dia.value) > 31 || parseInt(form_insert.var_dt_mes.value )> 12) { FlagErro = true; }
     if (FlagErro) 
       { alert ('Verifique se você alterou a DATA com valores inválidos e/ou imcompatíveis, pois ainda existe(m) algum(uns) campos(s) incorreto(s), favor efetuar a(s) correção(ões)!'); } 
     else 
       { 
	    document.form_insert.submit(); 
	   }
   }
}
//****** Funções de ação dos botões - Fim ******


</script>
</head>
<body onLoad="document.form_insert.var_hh1.focus();">
<%=athBeginDialog(WMD_WIDTH, "Reg. Horas - Inserção")%>
<form name="form_insert"  id="form_insert" action="insert_exec.asp" method="get">
	<input type="hidden" value="restrito" name="var_reffer">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='insert.asp'>
	<div class="form_label">Usuário:</div><select name="var_id_usuario" class="texto_chamada_peq" style="width:100px" >
			 								<option value="Todos" 
											<%if GetParam("selNome") = "Todos" then response.write("selected")%>>
												[usuários]
											</option>
			 								<%=montaCombo("STR", "SELECT Distinct(ID_USUARIO) FROM USUARIO WHERE DT_INATIVO is NULL", "ID_USUARIO", "ID_USUARIO", Request.Cookies("VBOSS")("ID_USUARIO"))%> 
										  </select>
	<br><div class="form_label">Empresa:</div><select name="var_empresa" class="texto_chamada_peq" style="width: 180px" 
											   onChange="document.form_insert.var_hh1.focus();">
		  									  <%=montaCombo("STR", "SELECT SIGLA_PONTO, NOME_COMERCIAL FROM ENT_CLIENTE WHERE DT_INATIVO IS NULL AND SIGLA_PONTO IS NOT NULL ORDER BY NOME_COMERCIAL", "SIGLA_PONTO", "NOME_COMERCIAL", Request.Cookies("VBOSS")("DEFAULT_EMP"))%> 
		 	 								  <option value="EXT">Extra/Outros</option>
											  </select>
	<br><div class="form_label">Data:</div><input type="text" name="var_dt_dia" maxlength="2" style="width:20px;" 
											onKeyUp="return autoTab(this, 2, event);" value="<%=Day(Date)%>">
											<b>/</b><input type="text" name="var_dt_mes" maxlength="2" style="width:20px;" 
													 onKeyUp="return autoTab(this, 2, event);" value="<%=Month(Date)%>">
											<b>/</b><input type="text" name="var_dt_ano" maxlength="4" style="width:40px;" 
													 onKeyUp="return autoTab(this, 4, event);" value="<%=Year(Date)%>">
	<br><div class="form_label">Status:</div><select name="var_status" class="texto_chamada_peq" style="width: 111px" 
											  onChange="document.form_insert.var_hh1.focus();">
											  <option value="REALIZADO" selected>REALIZADO</option>
										 	 </select> 
	
	<br><div class="form_label">Entrada:</div><input type="text" name="var_hh1" maxlength="2" style="width:20px;" 
											   onKeyUp="return autoTab(this, 2, event); "><b>:</b>
											  <input type="text" name="var_mm1" maxlength="2" style="width:20px;" 
											   onKeyUp="return autoTab(this, 2, event);">:00
	<br><div class="form_label">Saída:</div><input type="text" name="var_hh2" maxlength="2" style="width:20px;" 
											 onKeyUp="return autoTab(this, 2, event);"><b>:</b>
											<input type="text" name="var_mm2" maxlength="2" style="width:20px;" 
											 onKeyUp="return autoTab(this, 2, event);">:00
	<br><div class="form_label">Observação:</div><textarea name="var_obs" cols="50" rows="4" style="width:180px;"></textarea>
  </form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>