<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_PONTO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

 Dim objConn, objRS, strSQL, strCOD_PONTO, auxStr

 strCOD_PONTO = GetParam("var_chavereg")

 strSQL = "SELECT ID_USUARIO, DATA_DIA, DATA_MES, DATA_ANO, COD_EMPRESA, HORA_IN, HORA_OUT, OBS, STATUS" & _
		  " FROM PT_PONTO" & _
		  " WHERE COD_PONTO = " & strCOD_PONTO 

 AbreDBConn ObjConn, CFG_DB

 set objRS = ObjConn.Execute(strSQL)

 if not objRS.EOF then 
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
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
function ok()       { document.form_update.DEFAULT_LOCATION.value=""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_update.JSCRIPT_ACTION.value="";   submeterForm(); }
function submeterForm() {
 var FlagErro=false;

 if ( VerifyRangeHHMM(document.form_update.var_hh1.value, 'HH') && VerifyRangeHHMM(document.form_update.var_hh2.value, 'HH') &&
      VerifyRangeHHMM(document.form_update.var_mm1.value, 'MM') && VerifyRangeHHMM(document.form_update.var_mm2.value, 'MM') ) { 
   FlagErro=false;
 }

 if (FlagErro) 
   { 
     alert ('Verifique se você inseriu horários exatamente iguais e/ou imcompatíveis, favor efetuar a(s) correção(ões) do(s) intervalo(s) de tempo trabalhado corretamente! O Total dos Horários depende deste(s) acerto(s).'); 
   } 
 else 
   {
     if ( VerifyValuesHHMM(document.form_update.var_hh1.value, document.form_update.var_hh2.value, document.form_update.var_mm1.value, document.form_update.var_mm2.value) ) 
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
     if (parseInt(form_update.var_dt_dia.value) > 31 || parseInt(form_update.var_dt_mes.value )> 12) { FlagErro = true; }
     if (FlagErro) 
       { alert ('Verifique se você alterou a DATA com valores inválidos e/ou imcompatíveis, pois ainda existe(m) algum(uns) campos(s) incorreto(s), favor efetuar a(s) correção(ões)!'); } 
     else 
       { 
	    document.form_update.submit(); 
	   }
   }
}
//****** Funções de ação dos botões - Fim ******


</script>
</head>
<body bgcolor="#ffffff" topmargin="13" leftmargin="0" onLoad="document.form_update.var_hh1.focus();">
<%=athBeginDialog(WMD_WIDTH, "Reg. Horas - Alteração")%>
<form name="form_update" action="update_exec.asp" method="post">
	<input type="hidden" name="var_chavereg" value="<%=strCOD_PONTO%>">
	<input type="hidden" name="var_empresa_old" value="<%=GetValue(objRS, "COD_EMPRESA")%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='update.asp?var_chavereg=<%=strCOD_PONTO%>'>
	    <div class="form_label">Cod.:</div><input type="text" class="inputclean" value="<%=strCOD_PONTO%>" readonly="readony">
	<br><div class="form_label">Usuário:</div><select name="var_id_usuario" class="texto_chamada_peq" style="width:100px" >
			 								<option value="Todos" 
											<%if GetParam("selNome") = "Todos" then response.write("selected")%>>
												[usuários]
											</option>
			 								<%'=montaCombo("STR","SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO is NULL", "ID_USUARIO", "ID_USUARIO", GetValue(objRS,"ID_USUARIO"))%> 
											<%=montaCombo("STR","SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL AND TIPO LIKE 'ENT_COLABORADOR' ORDER BY ID_USUARIO ", "ID_USUARIO", "ID_USUARIO", GetValue(objRS,"ID_USUARIO"))%> 
                                            
                                            
										  </select>
	<br><div class="form_label">Empresa:</div><select name="var_empresa" class="texto_chamada_peq" style="width: 180px" 
											   onChange="document.form_insert.var_hh1.focus();">
		  									    <%
												 auxStr = GetValue(objRS, "COD_EMPRESA")
												 response.write montaCombo("STR", "SELECT SIGLA_PONTO, NOME_COMERCIAL FROM ENT_CLIENTE WHERE DT_INATIVO IS NULL AND SIGLA_PONTO IS NOT NULL ORDER BY NOME_COMERCIAL", "SIGLA_PONTO", "NOME_COMERCIAL", auxSTR)
												%> 
		 	 								   <option value="EXT" <%if auxStr="EXT" then response.write("selected='selected'") end if %>>Extra/Outros</option>
											  </select>
	<br><div class="form_label">Data:</div><input type="text" name="var_dt_dia" maxlength="2" style="width:20px;" 
											onKeyUp="return autoTab(this, 2, event);" value="<%=GetValue(objRS, "DATA_DIA")%>">
											<b>/</b><input type="text" name="var_dt_mes" maxlength="2" style="width:20px;" 
													 onKeyUp="return autoTab(this, 2, event);" value="<%=GetValue(objRS, "DATA_MES")%>">
											<b>/</b><input type="text" name="var_dt_ano" maxlength="4" style="width:40px;" 
													 onKeyUp="return autoTab(this, 4, event);" value="<%=GetValue(objRS, "DATA_ANO")%>">
	<br><div class="form_label">Status:</div><select name="var_status" class="texto_chamada_peq" style="width: 111px" 
											  onChange="document.form_insert.var_hh1.focus();">
											  <option value="REALIZADO" selected>REALIZADO</option>
										 	 </select> 
	<br><div class="form_label">Entrada:</div><input type="text" name="var_hh1" maxlength="2" style="width:20px;" 
											   onKeyUp="return autoTab(this, 2, event);"
											   value="<%=mid(GetValue(objRS, "HORA_IN") & "",1,2)%>"><b>:</b>
											  <input type="text" name="var_mm1" maxlength="2" style="width:20px;" 
											   onKeyUp="return autoTab(this, 2, event);"
											   value="<%=mid(GetValue(objRS, "HORA_IN") & "",4,2)%>">:00
	<br><div class="form_label">Saída:</div><input type="text" name="var_hh2" maxlength="2" style="width:20px;" 
											 onKeyUp="return autoTab(this, 2, event);"
											 value="<%=mid(GetValue(objRS, "HORA_OUT") & "",1,2)%>"><b>:</b>
											<input type="text" name="var_mm2" maxlength="2" style="width:20px;" 
											 onKeyUp="return autoTab(this, 2, event);"
											 value="<%=mid(GetValue(objRS, "HORA_OUT") & "",4,2)%>">:00
	<br><div class="form_label">Observação:</div><textarea name="var_obs" cols="50" rows="4" style="width:180px;"><%=GetValue(objRS, "OBS")%></textarea>
  </form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>
<%
 else
%>
  <script>
   self.opener.document.form_update.submit();
   window.close();
  </script>
<%
 end if
 FechaRecordSet objRS
 FechaDBConn objConn
%>
