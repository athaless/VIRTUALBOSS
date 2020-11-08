<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn 
                                                 %>
<% VerificaDireito "|REAJUSTA|", BuscaDireitosFromDB("modulo_CONTRATO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "dlg_info.gif:Os títulos vinculados ao contrato serão reajustados conforme o percentual de reajuste. Para confirmar clique no botão [ok], para desistir clique em [cancelar]." '"<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

	Dim objConn, objRS, objRSAux, strSQL
	Dim strCODIGO, strNOME, strVLR_PARC, strVLR_PARC_REAJ, strFATOR_REAJUSTE
	
	AbreDBConn objConn, CFG_DB 
	
	strCODIGO = GetParam("var_chavereg")
	
	If strCODIGO <> "" Then
		strSQL =          " SELECT T1.CODIGO, T1.TIPO, T1.CODIFICACAO "
		strSQL = strSQL & "      , T2.NOME_FANTASIA AS CLIENTE "
		strSQL = strSQL & "      , T3.NOME_FANTASIA AS FORNECEDOR "
		strSQL = strSQL & "      , T4.NOME AS COLABORADOR "
		strSQL = strSQL & "      , T1.COD_CONTRATO, T1.CODIFICACAO, T1.TITULO, T1.DT_INI, T1.DT_FIM "
		strSQL = strSQL & "      , T1.DT_ASSINATURA, T1.TP_RENOVACAO, T1.TP_COBRANCA, T1.SITUACAO, T1.DOC_CONTRATO "
		strSQL = strSQL & "      , T1.OBS, T1.FREQUENCIA, T1.NUM_PARC, T1.VLR_TOTAL "
		strSQL = strSQL & "      , T1.DT_BASE_VCTO, T1.COD_SERVICO, T5.TITULO AS SERVICO, T1.ALIQ_ISSQN_SERVICO "
		strSQL = strSQL & "      , T1.SYS_DT_INSERCAO, T1.SYS_INS_ID_USUARIO, T1.TP_REAJUSTE, T1.FATOR_REAJUSTE, T1.DT_BASE_CONTRATO "
		strSQL = strSQL & " FROM CONTRATO T1 "
		strSQL = strSQL & " LEFT OUTER JOIN ENT_CLIENTE T2 ON (T1.CODIGO = T2.COD_CLIENTE) "
		strSQL = strSQL & " LEFT OUTER JOIN ENT_FORNECEDOR T3 ON (T1.CODIGO = T3.COD_FORNECEDOR) "
		strSQL = strSQL & " LEFT OUTER JOIN ENT_COLABORADOR T4 ON (T1.CODIGO = T4.COD_COLABORADOR) "
		strSQL = strSQL & " LEFT OUTER JOIN SV_SERVICO T5 ON (T1.COD_SERVICO = T5.COD_SERVICO) "
		strSQL = strSQL & " WHERE COD_CONTRATO = " & strCODIGO
		
		Set objRS = objConn.Execute(strSQL)
		
		strFATOR_REAJUSTE = GetValue(ObjRS, "FATOR_REAJUSTE")
		
		If Not objRS.Eof Then
			If GetValue(objRS, "TIPO") = "ENT_CLIENTE" Then strNOME = GetValue(objRS, "CLIENTE")
			If GetValue(objRS, "TIPO") = "ENT_FORNECEDOR" Then strNOME = GetValue(objRS, "FORNECEDOR")
			If GetValue(objRS, "TIPO") = "ENT_COLABORADOR" Then strNOME = GetValue(objRS, "COLABORADOR")
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok() 		{ submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { }
function submeterForm() { 
	var var_msg = '';
	if (document.form_reajusta.var_tp_reajuste.value == '') var_msg += '\nInformar tipo de reajuste';
	if (document.form_reajusta.var_fator_reajuste.value == '') var_msg += '\nInformar fator de reajuste';
	
	if (var_msg == '') 
		document.form_reajusta.submit(); 
	else {
		alert('Verificar mensagens:\n' + var_msg);
	}
}
//****** Funções de ação dos botões - Fim ******

var CIDInput=0, QtdeInput=0;

function addInput(prPai,prNomeElemento, prStyle, prAction){		
	var newFormObj;
	var ParentElem = document.getElementById(prPai);
	var auxElemName;
	var strDate;
	var auxDate;
	var auxDateParts;

	//Cria os inputs 
	newFormObj = document.createElement('input');
	newFormObj.setAttribute("id"	    ,prNomeElemento);
	newFormObj.setAttribute("name"		,prNomeElemento);
	newFormObj.setAttribute("type"		,'text'        );
	newFormObj.setAttribute("maxlength"	,250           );
	newFormObj.setAttribute("style"		,prStyle       );
	newFormObj.setAttribute("readonly"  ,'true'        );	  		
	ParentElem.appendChild(newFormObj);
	document.form_reajusta.QTDE_INPUTS.value = QtdeInput; 
}

function reajustaParc(){
    /*Mostra "prévia" como ficarão o valor das parcelas após reajuste.*/
	var fatReajuste = 0;
	if (document.getElementsByName('var_fator_reajuste')[0].value != ''){
		fatReajuste = document.getElementsByName('var_fator_reajuste')[0].value;
	} 

	fatReajuste = fatReajuste.toString().replace(".","");		
	fatReajuste = fatReajuste.toString().replace(",",".");			
	fatReajuste = parseFloat(fatReajuste).toFixed(3);		

	for(var Aux=1; Aux<=QtdeInput; Aux++){
		var vlrParcReaj;
		var vlrParcOrig = document.getElementsByName('var_vlr_parcela_orig_' + Aux)[0].value.replace(".","");
		vlrParcOrig = vlrParcOrig.toString().replace(",",".");		
		if (document.getElementById('var_checkbox_reajuste').checked) {
			vlrParcReaj = vlrParcOrig * (1 - (fatReajuste/100));
		} else {
			vlrParcReaj = vlrParcOrig * (1 + (fatReajuste/100));
		}
		vlrParcReaj = vlrParcReaj.toFixed(2);
		vlrParcReaj = vlrParcReaj.toString().replace(".",",");
		document.getElementsByName('var_vlr_parcela_reaj_' + Aux)[0].value = vlrParcReaj;
	}
}

</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Contrato - Reajuste") %>
<form name="form_reajusta" action="Reajusta_Exec.asp" method="post">
	<input type="hidden" name="var_chavereg" value="<%=strCODIGO%>">
 	<input type="hidden" name="QTDE_INPUTS" value='0'>	
	<input type="hidden" name="var_dt_base_contrato" value="<%=GetValue(objRS, "DT_BASE_CONTRATO")%>">	
	<div class="form_label">Cod:</div><div class="form_bypass"><%=strCODIGO%></div>
	<br><div class="form_label">Título:</div><div class="form_bypass"><%=GetValue(objRS, "TITULO")%></div>
	<br><div class="form_label">Entidade:</div><div class="form_bypass" style="width:300px; height:30px; border:1px solid #CCC;"><%=GetValue(objRS, "CODIGO")%> - <%=strNOME%></div>
	
	<!--<br><div class="form_label">Observação:</div><div class="form_bypass"><%'=GetValue(objRS, "OBS")%></div>//-->
	<br><div class="form_label">Observação:</div><textarea name="var_obs" rows="6" readonly="readonly" style="border:0px;background:#FFFFFF;"><%=GetValue(objRS, "OBS")%></textarea>	
	
	<br><div class="form_label">Vigência:</div><div class="form_bypass">de <%=PrepData(GetValue(objRS, "DT_INI"), True, False)%> a <%=PrepData(GetValue(objRS, "DT_FIM"), True, False)%></div>
	<br><div class="form_label">Vlr Total:</div><div class="form_bypass"><strong><% If GetValue(objRS, "VLR_TOTAL") <> "" Then Response.Write(FormatNumber(GetValue(objRS, "VLR_TOTAL"), 2)) %></strong></div>
	<br><div class="form_label">Quem inseriu:</div><div class="form_bypass">Por <%=GetValue(objRS, "SYS_INS_ID_USUARIO")%>, em <%=PrepData(GetValue(objRS, "SYS_DT_INSERCAO"), True, True)%></div>
	<br><div class="form_label">Tipo:</div><input name="var_checkbox_reajuste" id="var_checkbox_reajuste" type="checkbox" value="true" onChange="reajustaParc();">para redução de valor marque aqui

	<br><div class="form_label">Reajustar em:</div><input name="var_fator_reajuste" type="text" value="<% If strFATOR_REAJUSTE <> "" Then Response.Write(FormataDecimal(strFATOR_REAJUSTE, 2)) %>" maxlength="10" style="width:70px" onKeyPress="validateFloatKey();" onKeyUp="reajustaParc();">%	os títulos do contrato (apenas títulos em aberto)
	<br><div class="form_label"></div>Este percentual é aplicado de forma não acumulativa sobre o valor
	<br><div class="form_label"></div>de cada título em aberto.

	<div class="form_grupo_collapse" id="form_grupo_2">
		<div class="form_label"></div>
		<img src="../img/BulletMais.gif" id="form_collapse_2" border="0" onClick="ShowArea('form_grupo_2','form_collapse_2');" 
  		style="cursor:pointer;">
		<b>Títulos em Aberto do Contrato</b><br>			
												
		<br><div class="form_label" style="height:18px;"></div><span style="padding-left:5px;">Num.</span><span style="padding-left:25px;">Vlr Parc.</span><span style="padding-left:45px;">Vlr Parc. Reaj.</span><span style="padding-left:35px;">Dt. Venc.</span>
		<br><div class="form_label"></div><div class="form_line" style="padding-left:110px;"><table style="border:0px solid #CCCCCC;"><tr>
		<td><span id='eldin1'></span></td><td><span id='eldin2'></span></td><td><span id='eldin3'></span></td><td><span id='eldin4'></span></td><td><span id='eldin5'></span></td></tr></table></div>				

			<%
			'Monta consulta dos títulos do contrato
			strSQL = ""
			strSQL =          "SELECT ROUND(VLR_CONTA,2) AS VLR_CONTA, DT_VCTO "
			strSQL = strSQL & "  FROM FIN_CONTA_PAGAR_RECEBER "
			strSQL = strSQL & " WHERE COD_CONTRATO = "  & strCODIGO
			strSQL = strSQL & " ORDER BY DT_VCTO "
		
			AbreRecordSet ObjRSAux, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
						
			If Not ObjRSAux.Eof Then 
				response.write ("<script language='JavaScript'>" & vbNewLIne)
				do while not ObjRSAux.Eof		
					response.write (" CIDInput++; QtdeInput++;")
					response.write(" addInput('eldin1','var_num_parcela_'+CIDInput,'width:20px;', '', '');	" & vbNewLine)													
					response.write(" addInput('eldin2','var_vlr_parcela_orig_'+CIDInput,'width:80px;', 'validateFloatKey();', '" & FormataDecimal(GetValue(ObjRSAux, "VLR_CONTA"),2) & "'); " & vbNewLine)	
					
					strVLR_PARC = GetValue(ObjRSAux, "VLR_CONTA")
					
					If (strVLR_PARC <> "") and (strFATOR_REAJUSTE <> "") Then
						strVLR_PARC_REAJ = FormataDecimal(strVLR_PARC * (1+ (strFATOR_REAJUSTE/100)),2)
					Else 	
						strVLR_PARC_REAJ = FormataDecimal(0,2)				
					End If
					
					response.write(" addInput('eldin3','var_vlr_parcela_reaj_'+CIDInput,'width:80px;', 'validateFloatKey();', ''); " & vbNewLine)																	
					response.write(" addInput('eldin4','var_dt_venc_'+CIDInput,'width:90px;', 'validateNumKey();', '" & PrepData(GetValue(ObjRSAux, "DT_VCTO"), True, False) & "'); " & vbNewLine)													
					response.write(" addInput('eldin5','Svar_dt_venc_'+CIDInput,'width:40px;background-color:#ffffff;', '', ''); " & vbNewLine)													  			  
					'Seta os valores dos campos criados
					response.write(" eval('document.form_reajusta.var_num_parcela_' + CIDInput + '.value =  ' + CIDInput );"  & vbNewLine)				
					response.write(" eval('document.form_reajusta.var_vlr_parcela_orig_' + CIDInput + '.value =  ' + " & "'\'"& FormataDecimal(strVLR_PARC,2) & "\''" & "); " & vbNewLine)				
					response.write(" eval('document.form_reajusta.var_vlr_parcela_reaj_' + CIDInput + '.value =  ' + " & "'\'"& strVLR_PARC_REAJ  & "\''" & "); " & vbNewLine)														
					response.write(" eval('document.form_reajusta.var_dt_venc_' + CIDInput + '.value =  ' + " & "'\'"& PrepData(GetValue(ObjRSAux, "DT_VCTO"), True, False) & "\''" & "); " & vbNewLine)								
					athMoveNext ObjRSAux, ContFlush, CFG_FLUSH_LIMIT
				loop 
				response.write ("</script>" & vbNewLIne)
			End If
			FechaRecordSet ObjRSAux		
			%>
	</div>
	<br><div class="form_label">Tipo Reajuste:</div><select name="var_tp_reajuste" size="1" style="width:90px;" onChange="mostraDtReaj();">
													<option value=""           <% If GetValue(objRS, "TP_REAJUSTE") = ""           Then Response.Write("selected") %>>[selecione]</option>
													<option value="DIARIA"     <% If GetValue(objRS, "TP_REAJUSTE") = "DIARIA"     Then Response.Write("selected") %>>Diário</option>
													<option value="SEMANAL"    <% If GetValue(objRS, "TP_REAJUSTE") = "SEMANAL"    Then Response.Write("selected") %>>Semanal</option>
													<option value="QUINZENAL"  <% If GetValue(objRS, "TP_REAJUSTE") = "QUINZENAL"  Then Response.Write("selected") %>>Quinzenal</option>
													<option value="MENSAL"     <% If GetValue(objRS, "TP_REAJUSTE") = "MENSAL"     Then Response.Write("selected") %>>Mensal</option>
													<option value="BIMESTRAL"  <% If GetValue(objRS, "TP_REAJUSTE") = "BIMESTRAL"  Then Response.Write("selected") %>>Bimestral</option>
													<option value="TRIMESTRAL" <% If GetValue(objRS, "TP_REAJUSTE") = "TRIMESTRAL" Then Response.Write("selected") %>>Trimestral</option>
													<option value="SEMESTRAL"  <% If GetValue(objRS, "TP_REAJUSTE") = "SEMESTRAL"  Then Response.Write("selected") %>>Semestral</option>
													<option value="ANUAL"      <% If GetValue(objRS, "TP_REAJUSTE") = "ANUAL"      Then Response.Write("selected") %>>Anual</option>
													</select><input type="text" readonly="readonly" style="width:60px;background-color:#ffffff;" id='var_dt_reajuste' value="25/09/1983"> 
	<br><div class="form_label"></div>Você pode definir a próxima data de reajuste deste contrato, redefinindo a
	<br><div class="form_label"></div>frequência do tipo de reajuste																
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "", "")%>
</body>
</html>
<%
		End If
		FechaRecordSet objRS
	End If
	FechaDBConn objConn
%>
