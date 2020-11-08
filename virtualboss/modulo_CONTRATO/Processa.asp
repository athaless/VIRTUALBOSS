<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|PROCESSA|", BuscaDireitosFromDB("modulo_CONTRATO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "dlg_info.gif:Será gerado um ou mais títulos para o contrato. Para confirmar clique no botão [ok], para desistir clique em [cancelar]." '"<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

	Dim objConn, objRS, objRSAux, strSQL
	Dim strCODIGO, strNOME, strMSG, i
	
	AbreDBConn objConn, CFG_DB 
	
	strCODIGO = GetParam("var_chavereg")
	
	If strCODIGO <> "" Then
		strSQL =          " SELECT T1.CODIGO                                                            "
        strSQL = strSQL & "      , T1.TIPO		                                                        "
        strSQL = strSQL & "	     , T1.CODIFICACAO                                                       "		
		strSQL = strSQL & "      , T2.NOME_FANTASIA AS CLIENTE                                          "
		strSQL = strSQL & "      , T3.NOME_FANTASIA AS FORNECEDOR                                       "
		strSQL = strSQL & "      , T4.NOME AS COLABORADOR                                               "
        strSQL = strSQL & "		 , T1.COD_CONTRATO                                                      "		
        strSQL = strSQL & "		 , T1.TITULO                                                            "						
        strSQL = strSQL & "		 , T1.DT_INI                                                            "		
		strSQL = strSQL & "      , T1.DT_FIM                                                            "
        strSQL = strSQL & "		 , T1.DT_ASSINATURA                                                     "				
        strSQL = strSQL & "		 , T1.TP_RENOVACAO                                                      "								
        strSQL = strSQL & "		 , T1.TP_COBRANCA                                                       "				
        strSQL = strSQL & "		 , T1.SITUACAO                                                          "															
		strSQL = strSQL & "      , T1.DOC_CONTRATO                                                      "
        strSQL = strSQL & "		 , T1.OBS                                                               "				
        strSQL = strSQL & "		 , T1.FREQUENCIA                                                        "					
		strSQL = strSQL & "	     , T1.NUM_PARC                                                          "		
		strSQL = strSQL & "	     , T1.VLR_PARCELA                                                       "		
		strSQL = strSQL & "      , T1.VLR_TOTAL                                                         "
		strSQL = strSQL & "	     , T1.DT_BASE_VCTO                                                      "		
		strSQL = strSQL & "      , T1.ALIQ_ISSQN_SERVICO                                                "
		strSQL = strSQL & "	     , T1.SYS_DT_INSERCAO                                                   "		
		strSQL = strSQL & "	     , T1.SYS_INS_ID_USUARIO                                                "				
		strSQL = strSQL & "      , T1.DT_BASE_CONTRATO                                                  "
		strSQL = strSQL & " FROM CONTRATO                   T1                                          "
		strSQL = strSQL & " LEFT OUTER JOIN ENT_CLIENTE     T2 ON (T1.CODIGO      = T2.COD_CLIENTE    ) "
		strSQL = strSQL & " LEFT OUTER JOIN ENT_FORNECEDOR  T3 ON (T1.CODIGO      = T3.COD_FORNECEDOR ) "
		strSQL = strSQL & " LEFT OUTER JOIN ENT_COLABORADOR T4 ON (T1.CODIGO      = T4.COD_COLABORADOR) "
		strSQL = strSQL & " WHERE COD_CONTRATO = " & strCODIGO
		
		Set objRS = objConn.Execute(strSQL)
		
		If Not objRS.Eof Then
			If GetValue(objRS, "TIPO") = "ENT_CLIENTE"     Then strNOME = GetValue(objRS, "CLIENTE"    )
			If GetValue(objRS, "TIPO") = "ENT_FORNECEDOR"  Then strNOME = GetValue(objRS, "FORNECEDOR" )
			If GetValue(objRS, "TIPO") = "ENT_COLABORADOR" Then strNOME = GetValue(objRS, "COLABORADOR")		
			
		'------------------------------------------------------------------
		'Validação contrato - Ini -----------------------------------------
		'------------------------------------------------------------------
	    strMSG = ""
        If GetValue(objRS, "TITULO") = "" Then strMSG = strMSG & "Informar Título<br>"
        If GetValue(objRS, "CODIGO") = "" Then strMSG = strMSG & "Informar Entidade<br>"
		
		'------------------------------------------------------------------
		'Validação Serviços Contrato - Ini --------------------------------
		'------------------------------------------------------------------		
		strSQL = "SELECT COD_SERVICO, DESCRICAO, QTDE, VALOR FROM CONTRATO_SERVICO WHERE COD_CONTRATO = " & strCODIGO
		Set objRSAux = objConn.Execute(strSQL)				
		i = 0
		If Not objRSAux.Eof Then
			While Not objRSAux.Eof 	
				i = i + 1		
				If not IsNumeric(GetValue(objRSAux,"QTDE" )) Then strMSG = strMSG & "Informar Qtde. do serviço Código "& GetValue(objRSAux,"COD_SERVICO") &" <br>" 
				If not IsNumeric(GetValue(objRSAux,"VALOR")) Then strMSG = strMSG & "Informar Valor do serviço código "& GetValue(objRSAux,"COD_SERVICO") &" <br>" 			          
				athMoveNext objRSAUX, ContFlush, CFG_FLUSH_LIMIT
			WEnd
		End If
			
		If i = 0 Then 
			strMSG = strMSG & "O contrato deve ter ao menos um serviço<br>"
		End If
			
 		FechaRecordSet objRSAux						
		'------------------------------------------------------------------
		'Validação Serviços Contrato - Fim --------------------------------
		'------------------------------------------------------------------				
						
		If Not IsDate(GetValue(objRS,"DT_INI"))                                                  Then strMSG = strMSG & "Informar Dt Início<br>"
 		If Not IsDate(GetValue(objRS,"DT_FIM"))                                                  Then strMSG = strMSG & "Informar Dt Fim<br>"
		If not IsDate(GetValue(objRS,"DT_BASE_CONTRATO"))                                        Then strMSG = strMSG & "Informar Dt Base do Contrato<br>"
		If GetValue(objRS, "VLR_TOTAL"   ) = ""                                                  Then strMSG = strMSG & "Informar Vlr Total(Ref.)<br>"
		If GetValue(objRS, "VLR_PARCELA" ) = ""                                                  Then strMSG = strMSG & "Informar o valor da parcela(Ref.)<br>"
		If GetValue(objRS, "VLR_PARCELA" ) = "" or not isNumeric(GetValue(objRS, "VLR_PARCELA")) Then strMSG = strMSG & "Informar o valor da parcela(Ref.)<br>"	
		'------------------------------------------------------------------
		'Validação contrato - Fim -----------------------------------------
		'------------------------------------------------------------------
		
		'------------------------------------------------------------------		
		'Validação Parcelas Contrato - Ini --------------------------------
		'------------------------------------------------------------------
		strSQL = "SELECT VLR_PARCELA, DT_VENC FROM CONTRATO_PARCELA WHERE COD_CONTRATO = " & strCODIGO		
		Set objRSAux = objConn.Execute(strSQL)				
		i = 0
		If Not objRSAux.Eof Then
			While Not objRSAux.Eof 	
				i = i + 1		
				If not IsDate(GetValue(objRSAux,"DT_VENC"))        Then strMSG = strMSG & "Informar Dt Venc. da parcela "& i &" do Contrato<br>" 
				If not IsNumeric(GetValue(objRSAux,"VLR_PARCELA")) Then strMSG = strMSG & "Informar Valor da parcela "& i &" do Contrato<br>" 			          
				athMoveNext objRSAUX, ContFlush, CFG_FLUSH_LIMIT
			WEnd
		End If
		
		'athDebug "NUM_PARC "&GetValue(objRS, "NUM_PARC"), true
	
		If i = 0 Then 
			strMSG = strMSG & "Não foram geradas as parcelas para o contrato<br>"
		Else	
			if i <> GetValue(objRS, "NUM_PARC") Then strMSG = strMSG & "Número de parcelas(Ref.) e parcelas geradas não conferem<br>"
		End If
			
 		FechaRecordSet objRSAux	
		'------------------------------------------------------------------		
		'Validação Parcelas Contrato - Fim  -------------------------------
		'------------------------------------------------------------------		

		If strMSG <> "" Then
		    strMSG = "Não foi possível processar o contrato por causa das pendências abaixo:<br><br>" & strMSG
			Mensagem strMSG, "Javascript:history.back();", "Voltar", 1
			Response.End()
		End If	

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
	
	if (document.form_insert.var_chavereg.value         == '')                                                                var_msg += '\nParâmetro inválido para contrato';
	if ((document.form_insert.var_tipo.value == '')             || (document.form_insert.var_codigo.value == ''))             var_msg += '\nParâmetro inválido para entidade';
	if (document.form_insert.var_num_parc.value         == '')                                                                var_msg += '\nInformar número de parcelas';
	if (document.form_insert.var_dt_base_vcto.value     == '')                                                                var_msg += '\nInformar Dt Vcto 1ª Parcela';
	if ((document.form_insert.var_tp_cobranca.value != 'PAGAR') && (document.form_insert.var_tp_cobranca.value != 'RECEBER')) var_msg += '\nTipo de cobrança a ser gerado é indefinido';
	if (document.form_insert.var_cod_conta.value        == '')                                                                var_msg += '\nInformar conta bancária';
	if (document.form_insert.var_cod_plano_conta.value  == '')                                                                var_msg += '\nInformar plano de conta';
	if (document.form_insert.var_cod_centro_custo.value == '')                                                                var_msg += '\nInformar centro de custo';
	if (document.form_insert.var_historico.value        == '')                                                                var_msg += '\nInformar histórico'; 
	if (document.form_insert.var_num_documento.value    == '')                                                                var_msg += '\nInformar número do documento';
	
	if (var_msg == '') 
		document.form_insert.submit(); 
	else {
		alert('Verificar mensagens:\n' + var_msg);
	}
}
//****** Funções de ação dos botões - Fim ******

//****** Vars que controlam a quantidade de elementos e o seu ID ******
var CIDInputParcela = 0, QtdeInputParcela = 0;
var CIDInputServico = 0, QtdeInputServico = 0;

//****** Recebe o Id do elemento que irá receber ao dia da semana abreviado, e a data(String) que deseja saber o dia da semana ****** 
function updDiaSemana(prIDElemTarget, prData){
	document.getElementById(prIDElemTarget).value = getDiaSemana(prData);
}

/*-------------------------------------------------------------------------------*/		
/* Validação Genérica para criar elementos - Ini --------------------------------*/
/*-------------------------------------------------------------------------------*/
function addElem(prPai, prIDNomeElemento, prTpElemento, prStyle, prReadOnly, prClickAction){		
	var newFormObj;
	var ParentElem = document.getElementById(prPai);
	
	if (prTpElemento=="image") {
		//Cria o botão de deletar.
		newFormObj = document.createElement('img');
		newFormObj.setAttribute('src'		,'../img/IconAction_DEL.gif');
		newFormObj.setAttribute('vspace'	,'4'                        );				
	}else if (prTpElemento=="input"){
		//Cria os inputs para valor e data de venc.
		newFormObj = document.createElement('input');
		newFormObj.setAttribute("type"		,"text");
		newFormObj.setAttribute("maxlength"	,250   );		
	}
	//Atributos comuns
	newFormObj.setAttribute('name'	,prIDNomeElemento);  
	newFormObj.setAttribute('style'	,prStyle         ); 
	newFormObj.setAttribute('id'	,prIDNomeElemento);  
	//Verifica se o componente é ReadOnly
	if (prReadOnly == true){
		newFormObj.setAttribute('readonly'	,'true');	
	}  
	//Seta Eventos
	//Campos de valor decimal
	if(prIDNomeElemento.indexOf('vlr') > -1){
		newFormObj.setAttribute('onkeypress','validateFloatKey();');	  	  
	//Campos de data	
	}else if(prIDNomeElemento.indexOf('dt') > -1){
		newFormObj.setAttribute('onkeypress','validateNumKey();');	  	  
		newFormObj.setAttribute('onkeyup','FormataInputData(this.form.name, this.name);');	  	  	
		newFormObj.setAttribute('onchange','updDiaSemana(\'var_dia_semana_parcela_' + String(CIDInputParcela) + '\',this.value);');	  	  	
	//campos de valor inteiro
	}else if(prIDNomeElemento.indexOf('qtde') > -1){
		newFormObj.setAttribute('onkeypress','validateNumKey();');	  	  				
	}
	//Ação de click
	if (prClickAction != ''){
		newFormObj.setAttribute("onclick"	,prClickAction);
	}	
	//Adiciona elemento ao pai  
	ParentElem.appendChild(newFormObj);
	//Atualiza qtde de inputs
	if (prIDNomeElemento.indexOf('parcela') > -1){
		document.form_insert.QTDE_INPUTS_PARCELA.value = QtdeInputParcela; 
	}else if (prIDNomeElemento.indexOf('servico') > -1){
		document.form_insert.QTDE_INPUTS_SERVICO.value = QtdeInputServico;
	}
}
/*-------------------------------------------------------------------------------*/		
/*'Validação Genérica para criar elementos - Fim --------------------------------*/
/*-------------------------------------------------------------------------------*/

</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Contrato - Processamento") %>
<form name="form_insert" action="Processa_Exec.asp" method="post">
	<input type="hidden" name="QTDE_INPUTS_PARCELA" value='0'>	
    <input type="hidden" name="QTDE_INPUTS_SERVICO" value='0'>	    
	<input type="hidden" name="var_chavereg"        value="<%=strCODIGO%>">
	<input type="hidden" name="var_codificacao"     value="<%=GetValue(objRS, "CODIFICACAO" )%>">
	<input type="hidden" name="var_vlr_total"       value="<%=GetValue(objRS, "VLR_TOTAL"   )%>">
	<input type="hidden" name="var_num_parc"        value="<%=GetValue(objRS, "NUM_PARC"    )%>">
	<input type="hidden" name="var_frequencia"      value="<%=GetValue(objRS, "FREQUENCIA"  )%>">
	<input type="hidden" name="var_dt_base_vcto"    value="<%=GetValue(objRS, "DT_BASE_VCTO")%>">
	<input type="hidden" name="var_codigo"          value="<%=GetValue(objRS, "CODIGO"      )%>">
	<input type="hidden" name="var_tipo"            value="<%=GetValue(objRS, "TIPO"        )%>">
	<input type="hidden" name="var_tp_cobranca"     value="<%=GetValue(objRS, "TP_COBRANCA" )%>">
	<div class="form_label">Cod:</div><div class="form_bypass"><%=strCODIGO%></div>
	<br><div class="form_label">Título:     </div><div class="form_bypass"><%=GetValue(objRS, "TITULO"     )%></div>
	<br><div class="form_label">Codificação:</div><div class="form_bypass"><%=GetValue(objRS, "CODIFICACAO")%></div>
	<br><div class="form_label">Entidade:   </div><div class="form_bypass"><%=GetValue(objRS, "CODIGO"     )%> - <%=strNOME%></div>          
	<div class="form_grupo" id="form_grupo_3">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_3" border="0" onClick="ShowArea('form_grupo_3','form_collapse_3');" 
  		style="cursor:pointer;">
		<b>Serviços do Contrato</b><br>        
		<br><div class="form_label" style="height:18px;"></div><span style="padding-left:10px;">Cod.</span><span style="padding-left:20px;">Descrição</span><span style="padding-left:140px;">Qtde.</span><span style="padding-left:20px;">Valor</span>
		<br><div class="form_label"></div><div class="form_line" style="padding-left:110px;"><table style="border:0px solid #CCCCCC;"><tr><td><span id='eldinservico1'></span></td><td><span id='eldinservico2'></span></td><td><span id='eldinservico3'></span></td><td><span id='eldinservico4'></span></td></tr></table></div>                
    </div>
       
	<%
	  'Busca serviços do contrato
      strSQL = " SELECT COD_SERVICO, DESCRICAO, QTDE, VALOR FROM CONTRATO_SERVICO WHERE COD_CONTRATO = " & strCODIGO
	  AbreRecordSet objRSAux, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
      if not objRSAux.eof then 
	    response.write ("<script language='javascript' type='text/javascript'>" & vbNewLIne)
	    do while not objRSAux.Eof
          'Cria os elementos		
		  response.write (" CIDInputServico++; QtdeInputServico++;")
		  response.write (" addElem('eldinservico1','var_servicocod_' +CIDInputServico ,'input','width:20px;' ,true,''); " & vbNewLine) 
		  response.write (" addElem('eldinservico2','var_servicodesc_'+CIDInputServico ,'input','width:180px;',true,''); " & vbNewLine) 		
		  response.write (" addElem('eldinservico3','var_servicoqtde_'+CIDInputServico ,'input','width:30px;' ,true,''); " & vbNewLine) 				    
		  response.write (" addElem('eldinservico4','var_servicovlr_' +CIDInputServico ,'input','width:60px;' ,true,''); " & vbNewLine	& vbNewLine)
		  'Adiciona os valores
		  response.write(" document.getElementById('var_servicocod_' +CIDInputServico).value = "  & GetValue(objRSAux, "COD_SERVICO") & " ;")
		  response.write(" document.getElementById('var_servicodesc_'+CIDInputServico).value = '" & GetValue(objRSAux, "DESCRICAO"  ) & "';")		  
		  response.write(" document.getElementById('var_servicoqtde_'+CIDInputServico).value = "  & GetValue(objRSAux, "QTDE"       ) & " ;")		  
		  response.write(" document.getElementById('var_servicovlr_' +CIDInputServico).value = '" & FormataDecimal(GetValue(objRSAux, "VALOR"), 2) & "' ;")		  		  		  
          athMoveNext objRSAux, ContFlush, CFG_FLUSH_LIMIT
		loop 
		response.write ("</script>" & vbNewLIne)
      end if
	%>            
	<br><div class="form_label">Alíquota ISSQN:</div><div class="form_bypass"><% If GetValue(objRS, "ALIQ_ISSQN_SERVICO") <> "" Then Response.Write(FormatNumber(GetValue(objRS, "ALIQ_ISSQN_SERVICO"), 2)) %></div>
	<br><div class="form_label">Documento:     </div><div class="form_bypass"><%
	If GetValue(objRS,"DOC_CONTRATO") <> "" Then
		Response.Write("<a href='../upload/" & Request.Cookies("VBOSS")("CLINAME") & "/CONTRATOS/" & GetValue(objRS,"DOC_CONTRATO") & "' target='_blank'>" & GetValue(objRS,"DOC_CONTRATO") & "</a>")
	End If
	%></div>
	<br><div class="form_label">Observação:     </div><div class="form_bypass_multiline"><%=GetValue(objRS, "OBS")%></div>
	<br><div class="form_label">Vigência:       </div><div class="form_bypass">de <%=PrepData(GetValue(objRS, "DT_INI"), True, False)%> a <%=PrepData(GetValue(objRS, "DT_FIM"), True, False)%></div>
	<br><div class="form_label">Dt. Base:       </div><div class="form_bypass"><%=PrepData(GetValue(objRS, "DT_BASE_CONTRATO"), True, False)%></div>	
	<br><div class="form_label">Assinatura:     </div><div class="form_bypass"><%=PrepData(GetValue(objRS, "DT_ASSINATURA"   ), True, False)%></div>
	<br><div class="form_label">Vlr Total(Ref.):</div><div class="form_bypass"><strong><% If GetValue(objRS, "VLR_TOTAL"     ) <> "" Then Response.Write(FormatNumber(GetValue(objRS, "VLR_TOTAL"), 2)) %></strong></div>
	<br><div class="form_label">Parcelas:       </div><div class="form_bypass"><strong><%=GetValue(objRS, "NUM_PARC")%></strong></div>
	<br><div class="form_label">Freqüência:     </div><div class="form_bypass"><% 
	If GetValue(objRS, "FREQUENCIA") = ""           Then Response.Write("")
	If GetValue(objRS, "FREQUENCIA") = "DIARIA"     Then Response.Write("Diária"    )
	If GetValue(objRS, "FREQUENCIA") = "SEMANAL"    Then Response.Write("Semanal"   )
	If GetValue(objRS, "FREQUENCIA") = "QUINZENAL"  Then Response.Write("Quinzenal" )
	If GetValue(objRS, "FREQUENCIA") = "MENSAL"     Then Response.Write("Mensal"    )
	If GetValue(objRS, "FREQUENCIA") = "BIMESTRAL"  Then Response.Write("Bimestral" )
	If GetValue(objRS, "FREQUENCIA") = "TRIMESTRAL" Then Response.Write("Trimestral")
	If GetValue(objRS, "FREQUENCIA") = "SEMESTRAL"  Then Response.Write("Semestral" )
	If GetValue(objRS, "FREQUENCIA") = "ANUAL"      Then Response.Write("Anual"     )
	%></div>
	<br><div class="form_label">Dt Vcto 1ª Parcela:</div><div class="form_bypass"><%=PrepData(GetValue(objRS, "DT_BASE_VCTO"), True, False)%></div>
	<br><div class="form_label">Gerar Cobrança:</div><div class="form_bypass"><% 
	If GetValue(objRS, "TP_COBRANCA") = "PAGAR"   Then Response.Write("A Pagar"  )
	If GetValue(objRS, "TP_COBRANCA") = "RECEBER" Then Response.Write("A Receber")
	%></div>
	<br><div class="form_label">Quem inseriu:</div><div class="form_bypass">Por <%=GetValue(objRS, "SYS_INS_ID_USUARIO")%>, em <%=PrepData(GetValue(objRS, "SYS_DT_INSERCAO"), True, True)%></div>
	
	<br>
	<div class="form_grupo_collapse" id="form_grupo_2">
		<div class="form_label"></div>
		<img src="../img/BulletMais.gif" id="form_collapse_2" border="0" onClick="ShowArea('form_grupo_2','form_collapse_2');" 
  		style="cursor:pointer;">
		<b>Parcelas do Contrato</b><br>		
		<!-- <br><br><div class="form_label"></div>--------------------------------------------------------------------------------------------- //-->
		<br><div class="form_label" style="height:18px;"></div><span style="padding-left:5px;">Num. Parc.</span><span style="padding-left:15px;">Valor. Parcela</span><span style="padding-left:110px;">Dt. Venc.</span>
		<br><div class="form_label"></div><div class="form_line" style="padding-left:110px;"><table style="border:0px solid #CCCCCC;"><tr>
		<td><span id='eldinparcela1'></span></td><td><span id='eldinparcela2'></span></td><td><span id='eldinparcela3'></span></td><td><span id='eldinparcela4'></span></td><td><span id='eldinparcela5'></span></td></tr></table></div>			
			<%
				'Monta consulta das parcelas do contrato
				strSQL = ""
				strSQL =          "SELECT VLR_PARCELA, DT_VENC FROM CONTRATO_PARCELA  WHERE COD_CONTRATO = " & strCODIGO & " ORDER BY DT_VENC "		
				'Monta as parcelas
				AbreRecordSet ObjRSAux, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1				
				'athDebug strSQL false								
				If Not ObjRSAux.Eof Then 
					response.write ("<script language='JavaScript'>" & vbNewLIne)
					do while not ObjRSAux.Eof		
						response.write (" CIDInputParcela++; QtdeInputParcela++;")				
						response.write(" addElem('eldinparcela2','var_num_parcela_'        +CIDInputParcela ,'input' ,'width:40px;'                         ,true,''); ")														
						response.write(" addElem('eldinparcela3','var_vlr_parcela_'        +CIDInputParcela ,'input' ,'width:170px;'                        ,true,''); ")
						response.write(" addElem('eldinparcela4','var_dt_venc_parcela_'    +CIDInputParcela ,'input' ,'width:90px;'                         ,true,''); ") 
						response.write(" addElem('eldinparcela5','var_dia_semana_parcela_' +CIDInputParcela ,'input' ,'width:40px;background-color:#ffffff;',true,''); ") 								
		
						'Seta os valores dos campos criados
						response.write(" document.getElementById('var_num_parcela_' + String(CIDInputParcela)).value = QtdeInputParcela; ") 			  				
						response.write(" eval('document.form_insert.var_vlr_parcela_' + CIDInputParcela + '.value =  ' + " & "'\'"& FormataDecimal(GetValue(objRSAux, "VLR_PARCELA"),2) & "\''" & "); " & vbNewLine)				
						response.write(" eval('document.form_insert.var_dt_venc_parcela_' + CIDInputParcela + '.value =  ' + " & "'\'"& PrepData(GetValue(objRSAux, "DT_VENC"), True, False) & "\''" & "); " & vbNewLine)								
						response.write(" updDiaSemana('var_dia_semana_parcela_' + CIDInputParcela, document.getElementById('var_dt_venc_parcela_' + CIDInputParcela).value);")  	  	
						athMoveNext ObjRSAux, ContFlush, CFG_FLUSH_LIMIT
					loop 
					response.write ("</script>" & vbNewLIne)
				End If
				FechaRecordSet ObjRSAux		
			%>		
		<div class="form_label"></div>OBS: As Parcelas com valor zero não irão gerar Título no processamento.				
	</div>	
	<br>	
	<div class="form_grupo" id="form_grupo_1">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_1" border="0" onClick="ShowArea('form_grupo_1','form_collapse_1');" 
  		style="cursor:pointer;">
		<b>Dados para os Títulos</b><br>
		<br><div class="form_label">*Conta:</div><select name="var_cod_conta" style="width:230px;"><%
					strSQL =          " SELECT COD_CONTA, NOME FROM FIN_CONTA WHERE DT_INATIVO IS NULL ORDER BY  NOME "					
					Set objRSAux = objConn.Execute(strSQL)					
					Do While Not objRSAux.Eof
						Response.Write("<option value='" & GetValue(objRSAux, "COD_CONTA") & "'>")
						Response.Write(GetValue(objRSAux, "NOME") & "</option>")					
						objRSAux.MoveNext
					Loop					
					FechaRecordSet objRSAux
					%>
				</select>
		<br><div class="form_label">*Plano de Conta:</div><select name="var_cod_plano_conta" style="width:307px;"><%
								strSQL = " SELECT DISTINCT T1.COD_PLANO_CONTA                                                    "  &_
								         "               , T1.COD_REDUZIDO                                                       "  &_
								         "               , T1.NOME                                                               "  &_										 							 
										 " FROM FIN_PLANO_CONTA T1                                                               "	&_
										 " LEFT OUTER JOIN FIN_CONTA_PAGAR_RECEBER T2 ON (T1.COD_PLANO_CONTA=T2.COD_PLANO_CONTA) " 	&_
										 " WHERE T1.DT_INATIVO IS NULL AND T2.DT_EMISSAO>DATE_SUB(CURDATE(), INTERVAL 60 DAY)    " 	&_
										 " ORDER BY 2                                                                            "
								Set objRSAux = objConn.Execute(stRSQL)
								
								Do While Not objRSAux.Eof
									Response.Write("<option value='" & GetValue(objRSAux, "COD_PLANO_CONTA") & "'>")
									If GetValue(objRSAux, "COD_REDUZIDO") <> "" Then Response.Write(GetValue(objRSAux, "COD_REDUZIDO") & " ")
									Response.Write(GetValue(objRSAux, "NOME") & "</option>")									
									objRSAux.MoveNext
								Loop
								FechaRecordSet objRSAux
								%>
							</select><a href="Javascript://;" onClick="Javascript:AbreJanelaPAGE('BuscaPlanoConta.asp?var_form=form_insert&var_retorno1=var_cod_plano_conta', '640', '390');"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
		<br><div class="form_label">*Centro de Custo:</div>
		<%
			strSQL = " SELECT DISTINCT T1.COD_CENTRO_CUSTO                                                     " &_
			         "               , T1.NOME                                                                 " &_
					 " FROM FIN_CENTRO_CUSTO T1                                                                " &_
					 " LEFT OUTER JOIN FIN_CONTA_PAGAR_RECEBER T2 ON (T1.COD_CENTRO_CUSTO=T2.COD_CENTRO_CUSTO) " &_
					 " WHERE T1.DT_INATIVO IS NULL AND T2.DT_EMISSAO>DATE_SUB(CURDATE(), INTERVAL 60 DAY)      " &_
					 " ORDER BY 2                                                                              "
		%>
		<select name="var_cod_centro_custo" style="width:230px;">
				<%=montaCombo("STR",strSQL,"COD_CENTRO_CUSTO","NOME","")%>
			</select><a href="Javascript://;" onClick="Javascript:AbreJanelaPAGE('BuscaCentroCusto.asp?var_form=form_insert&var_retorno1=var_cod_centro_custo', '640', '365');"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
		<br><div class="form_label">*Histórico:</div><input name="var_historico" type="text" maxlength="250" style="width:300px;" value="Contrato <%=GetValue(objRS, "CODIFICACAO")%>">
		<br><div class="form_label">*Número:   </div><input name="var_num_documento" type="text" style="width:115;" value="<%=GetValue(objRS, "CODIFICACAO")%>">
		<br><div class="form_label">Observação:</div><textarea name="var_obs" rows="6" style="width:305px;"></textarea>
	</div>
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
