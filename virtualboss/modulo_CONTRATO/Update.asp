<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn 
												  %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_CONTRATO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
	Const WMD_WIDTH = 540 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
	Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

	Dim objConn, objRS, lcObjRS, strSQL
	Dim strCODIGO, strNOME

	AbreDBConn objConn, CFG_DB 

	strCODIGO = GetParam("var_chavereg")
	
	If strCODIGO <> "" Then 
		strSQL =          " SELECT T1.CODIGO                                                        "
        strSQL = strSQL & "      , T1.TIPO                                                          "			
		strSQL = strSQL & "      , T2.NOME_FANTASIA AS CLIENTE                                      "
		strSQL = strSQL & "      , T3.NOME_FANTASIA AS FORNECEDOR                                   "
		strSQL = strSQL & "      , T4.NOME AS COLABORADOR                                           "
        strSQL = strSQL & "      , T1.CODIFICACAO                                                   "		
		strSQL = strSQL & "      , T1.COD_CONTRATO                                                  "
        strSQL = strSQL & "      , T1.TITULO                                                        "					
		strSQL = strSQL & "      , T1.DT_INI                                                        "
		strSQL = strSQL & "      , T1.DT_FIM                                                        "
        strSQL = strSQL & "      , T1.DT_ASSINATURA                                                 "				
        strSQL = strSQL & "      , T1.TP_RENOVACAO                                                  "
        strSQL = strSQL & "      , T1.TP_COBRANCA                                                   "
		strSQL = strSQL & "      , T1.SITUACAO                                                      "
		strSQL = strSQL & "      , T1.DOC_CONTRATO                                                  "
		strSQL = strSQL & "      , T1.OBS                                                           "		
		strSQL = strSQL & "      , T1.FREQUENCIA                                                    "
		strSQL = strSQL & "      , T1.NUM_PARC                                                      "		
		strSQL = strSQL & "      , T1.VLR_TOTAL                                                     "						
		strSQL = strSQL & "      , T1.DT_BASE_VCTO                                                  "		
        strSQL = strSQL & "      , T1.ALIQ_ISSQN_SERVICO                                            "						
		strSQL = strSQL & "      , T1.TP_REAJUSTE                                                   "
        strSQL = strSQL & "      , T1.FATOR_REAJUSTE                                                "
        strSQL = strSQL & "      , T1.VLR_PARCELA                                                   "		
        strSQL = strSQL & "      , T1.DT_BASE_CONTRATO                                              "
		strSQL = strSQL & " FROM CONTRATO T1                                                        "
		strSQL = strSQL & " LEFT OUTER JOIN ENT_CLIENTE     T2 ON (T1.CODIGO = T2.COD_CLIENTE     ) "
		strSQL = strSQL & " LEFT OUTER JOIN ENT_FORNECEDOR  T3 ON (T1.CODIGO = T3.COD_FORNECEDOR  ) "
		strSQL = strSQL & " LEFT OUTER JOIN ENT_COLABORADOR T4 ON (T1.CODIGO = T4.COD_COLABORADOR ) "
		strSQL = strSQL & " WHERE COD_CONTRATO = " & strCODIGO		
		'athDebug strSQL, False		
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1		
		If Not objRS.Eof Then
			If GetValue(objRS, "TIPO") = "ENT_CLIENTE"     Then strNOME = GetValue(objRS, "CLIENTE"    )
			If GetValue(objRS, "TIPO") = "ENT_FORNECEDOR"  Then strNOME = GetValue(objRS, "FORNECEDOR" )
			If GetValue(objRS, "TIPO") = "ENT_COLABORADOR" Then strNOME = GetValue(objRS, "COLABORADOR")			
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">

//****** Funções de ação dos botões - Início ******
function ok() 		{ document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	var i;
    var auxData = document.form_update.var_dt_ini.value.split("/");  	
	var dtIni = new Date(auxData[2], auxData[1]-1, auxData[0]);//pega data inicio do contrato
    auxData = document.form_update.var_dt_fim.value.split("/");  	
	var dtFim = new Date(auxData[2], auxData[1]-1, auxData[0]);//pega data fim do contrato
	var bTemServico = false;

	if (document.form_update.var_titulo.value == '') var_msg += '\nTítulo';
	if (document.form_update.var_codigo.value == '') var_msg += '\nEntidade';		
	
	//Valida serviços inseridos.
	for(i=1;i<=CIDInputServico;i++){
		auxCod = document.getElementById('var_servicocod_' + i).value
		if(auxCod != '' && auxCod != null) { 				
		    bTemServico = true;
			if (isInt(eval('document.form_update.var_servicoqtde_' + i + '.value'))==false){
				var_msg += '\nQuantidade do servico código' + auxCod;				  
			}				  
			if (isFloat(eval('document.form_update.var_servicovlr_' + i + '.value'))==false){
				var_msg += '\nValor do servico código ' + auxCod;				  
			}	 
		}
	}		
	
	if (bTemServico == false) var_msg += '\nContrato deve ter pelo menos um serviço';		 
	
	if ((document.form_update.var_dt_ini.value == '') || (checkDate(document.form_update.var_dt_ini.value)==false)) var_msg += '\nDt. Início';		
	if ((document.form_update.var_dt_fim.value == '') || (checkDate(document.form_update.var_dt_fim.value)==false)) var_msg += '\nDt. Fim.';					
    //se a data de inicio e fim estiverem preenchidas, verificamos se a data de fim não está menor que a data de inicio
	if ((document.form_update.var_dt_ini.value != '') && (document.form_update.var_dt_fim.value != '')) {
  	  if (+dtFim <= +dtIni){
	    var_msg += '\nDt. Fim deve ser maior que a Dt. Inicio';
	  } //verifica se a data fim não é menor que data de inicio	
	}	
	if ((document.form_update.var_dt_base_contrato.value == '') || (checkDate(document.form_update.var_dt_base_contrato.value)==false))var_msg += '\nDt. Base Contrato';				
	if ((document.form_update.var_vlr_total.value == '')        || (isFloat  (document.form_update.var_vlr_total.value)==false))       var_msg += '\nValor total(Ref.)';	
	if ((document.form_update.var_dt_base_vcto.value == '')     || (checkDate(document.form_update.var_dt_base_contrato.value)==false))var_msg += '\nDt. Venc 1ª parcela';		
	if ((document.form_update.var_vlr_parcela_ref.value == '')  || (isFloat  (document.form_update.var_vlr_parcela_ref.value)==false)) var_msg += '\nValor da parcela(Ref.)';	
	if  (document.form_update.var_num_parcela_ref.value != QtdeInputParcela )                                                          var_msg += '\nNúmero de parcelas(Ref.) e parcelas geradas não conferem';
	
	// Valida a data de vencimento e valor das parcelas do contrato.
    if (QtdeInputParcela < 1) var_msg += '\nParcelas não geradas';	
	for(i=1;i<=CIDInputParcela;i++){
	  if (checkDate(eval('document.form_update.var_dt_venc_parcela_'+ i + '.value'))==false){
	    var_msg += '\nDt de Venc. da parcela ' + i;			
	  }
	  if (isFloat(eval('document.form_update.var_vlr_parcela_' + i + '.value'))==false){
	    var_msg += '\nValor da parcela ' + i;				  
	  }	  
	}
	
	if (var_msg == ''){
		document.form_update.submit();
	} else{
		alert('Favor verificar campos:\n' + var_msg);
	}
}
//****** Funções de ação dos botões - Fim ******

function BuscaEntidade() {	
	AbreJanelaPAGE('BuscaPorEntidade.asp?var_form=form_update&var_input=var_codigo&var_input_tipo=var_tipo&var_tipo=' + document.form_update.var_tipo.value,'640','390');
}

function LimparCampo(prForm, prCampo) {
	eval("document." + prForm + "." + prCampo + ".value = '';");
}

//****** Vars que controlam a quantidade de elementos e o seu ID ******
var CIDInputParcela = 0, QtdeInputParcela = 0;
var CIDInputAnexo   = 0, QtdeInputAnexo   = 0;
var CIDInputServico = 0, QtdeInputServico = 0;

//******Recebe o Id do elemento que irá receber ao dia da semana abreviado, e a data(String) que deseja saber o dia da semana ******
function updDiaSemana(prElemTarget, prData){
	document.getElementById(prElemTarget).value = getDiaSemana(prData);
}

//****** Adiciona as parcelas ao clicar no botão de gerar. ******
function addInputsParcela(prQtdeInputs){ 
    var var_msg = '';
	var auxDate;
    var auxFreq = document.getElementsByName('var_frequencia')[0].value;	
    //Verifica se as parcelas podem ser geradas.
	if ((document.form_update.var_frequencia.value    == '') && (document.form_update.var_num_parcela_ref.value > 1)) var_msg += '\nFreq. de Venc. das parcelas';
	if ((document.form_update.var_dt_base_vcto.value == '') || (checkDate(document.form_update.var_dt_base_vcto.value)==false)) var_msg += '\nDt. Base Venc.';			
	if (document.form_update.var_vlr_parcela_ref.value == '') var_msg += '\nValor da parcela(Ref.)';	
	if ((document.form_update.var_num_parcela_ref.value == '0') || (document.form_update.var_num_parcela_ref.value == '')) var_msg += '\nNúmero de parcelas';

	if (var_msg != ''){
		alert('Não foi possível gerar as parcelas. Favor verificar:\n' + var_msg);
	} else{	
		//Apaga os inputs.
		for(; QtdeInputParcela>0;){	 
			QtdeInputParcela--;	  
			delElem(QtdeInputParcela+1,'parcela'); 	
			CIDInputParcela--;
		}
		//Constrói os inputs com base no número de parcelas digitado.	  
		for(Aux=0; Aux<prQtdeInputs; Aux++){
			CIDInputParcela++; QtdeInputParcela++;
			//Deixei comentado o botão que apaga a parcela.
			//addElem('eldinparcela1','var_del_anexo_'+CIDInputParcela,'image','height:14px; border:0px; cursor:pointer;', 'QtdeInputParcela--; delElem('+CIDInputParcela+'\'parcela\');',false,''); 
			addElem('eldinparcela2','var_num_parcela_'        +CIDInputParcela ,'input' ,'width:40px;'                         ,true ,'');														
			addElem('eldinparcela3','var_vlr_parcela_'        +CIDInputParcela ,'input' ,'width:170px;'                        ,false,''); 
			addElem('eldinparcela4','var_dt_venc_parcela_'    +CIDInputParcela ,'input' ,'width:90px;'                         ,false,'');   
			addElem('eldinparcela5','var_dia_semana_parcela_' +CIDInputParcela ,'input' ,'width:40px;background-color:#ffffff;',true ,'');   
			//Valores dos elementos
			//Num da parcela
			document.getElementById('var_num_parcela_' + String(CIDInputParcela)).value = QtdeInputParcela; 			  
			//Valor
			document.getElementById('var_vlr_parcela_' + String(CIDInputParcela)).value = document.getElementsByName('var_vlr_parcela_ref')[0].value;			
			//Data vcto 
			if(CIDInputParcela==1){
				auxDate = document.getElementsByName('var_dt_base_vcto')[0].value;
			//Nas outras datas, acrescenta o período conforme a peridiocidade.	
			} else if(CIDInputParcela>1){	    
				auxDate = IncDate(document.getElementsByName('var_dt_venc_parcela_'+ String(CIDInputParcela-1))[0].value ,auxFreq);	
			}
			document.getElementById('var_dt_venc_parcela_' + String(CIDInputParcela)).value = auxDate;			
			//Recebe o dia da semana de acordo com a data inserida.						
			document.getElementById('var_dia_semana_parcela_' + String(CIDInputParcela)).value = getDiaSemana(document.getElementById('var_dt_venc_parcela_'+ String(CIDInputParcela)).value);
		}
	}
}

/*-------------------------------------------------------------------------------*/		
/* Validação Genérica para criar elementos - Ini --------------------------------*/
/*-------------------------------------------------------------------------------*/
function addElem(prPai, prNomeElemento, prTpElemento, prStyle, prReadOnly, prClickAction){		
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
	newFormObj.setAttribute('name'	,prNomeElemento);  
	newFormObj.setAttribute('style'	,prStyle       ); 
	newFormObj.setAttribute('id'	,prNomeElemento);  
	//Verifica se o componente é ReadOnly
	if (prReadOnly == true){
		newFormObj.setAttribute('readonly'	,'true');	
	}  
	//Seta Eventos
	//Campos de valor decimal
	if(prNomeElemento.indexOf('vlr') > -1){
		newFormObj.setAttribute('onkeypress','validateFloatKey();');	  	  
	//Campos de data	
	}else if(prNomeElemento.indexOf('dt') > -1){
		newFormObj.setAttribute('onkeypress','validateNumKey();');	  	  
		newFormObj.setAttribute('onkeyup','FormataInputData(this.form.name, this.name);');	  	  	
		newFormObj.setAttribute('onchange','updDiaSemana(\'var_dia_semana_parcela_' + String(CIDInputParcela) + '\',this.value);');	  	  	
	//campos de valor inteiro
	}else if(prNomeElemento.indexOf('qtde') > -1){
		newFormObj.setAttribute('onkeypress','validateNumKey();');	  	  				
	}
	//Ação de click
	if (prClickAction != ''){
		newFormObj.setAttribute("onclick"	,prClickAction);
	}	
	//Adiciona elemento ao pai  
	ParentElem.appendChild(newFormObj);
	//Atualiza qtde de inputs
	if (prNomeElemento.indexOf('parcela') > -1){
		document.form_update.QTDE_INPUTS_PARCELA.value = QtdeInputParcela; 
	}else if (prNomeElemento.indexOf('anexo') > -1){
		document.form_update.QTDE_INPUTS_ANEXO.value = QtdeInputAnexo;
	}else if (prNomeElemento.indexOf('servico') > -1){
		document.form_update.QTDE_INPUTS_SERVICO.value = QtdeInputServico;
	}
}
/*-------------------------------------------------------------------------------*/		
/* Validação Genérica para criar elementos - Fim --------------------------------*/
/*-------------------------------------------------------------------------------*/

/*-------------------------------------------------------------------------------*/		
/* Validação Genérica para apagar elementos - Ini -------------------------------*/
/*-------------------------------------------------------------------------------*/
function delElem(prCIDInput, prTipoElem) {
  var ParentElem, newFormObj;
  
  if (prTipoElem == 'parcela'){
		ParentElem = document.getElementById('eldinparcela2');
		newFormObj = document.getElementById('var_num_parcela_' + prCIDInput);
		ParentElem.removeChild(newFormObj);  
		
		ParentElem = document.getElementById('eldinparcela3');
		newFormObj = document.getElementById('var_vlr_parcela_' + prCIDInput);
		ParentElem.removeChild(newFormObj);
		
		ParentElem = document.getElementById('eldinparcela4');
		newFormObj = document.getElementById('var_dt_venc_parcela_' + prCIDInput);
		ParentElem.removeChild(newFormObj);
		
		ParentElem = document.getElementById('eldinparcela5');
		newFormObj = document.getElementById('var_dia_semana_parcela_' + prCIDInput);
		ParentElem.removeChild(newFormObj);
		
		document.form_update.QTDE_INPUTS_PARCELA.value = QtdeInputParcela;
		
	}else if (prTipoElem == 'anexo'){
		/*Deixa os elementos invisíveis, para podermos pegar seus valores na Exec.
		  Os que estiverem sem valor não serão gravados.*/
		document.getElementById('var_ianexo_'    + prCIDInput).style.display = "none";				  		
		document.getElementById('var_anexo_'     + prCIDInput).value = '';
    	document.getElementById('var_anexodesc_' + prCIDInput).value = '';			
        document.getElementById('var_anexo_'     + prCIDInput).style.display = "none";
     	document.getElementById('var_anexodesc_' + prCIDInput).style.display = "none"; 
		//document.form_update.QTDE_INPUTS_ANEXO.value = QtdeInputAnexo;	  
	}else if (prTipoElem == 'servico'){
		/*Deixa os elementos invisíveis, para podermos pegar seus valores na Exec.
		  Os que estiverem sem valor não serão gravados.*/        
		document.getElementById('var_servicodel_'  + prCIDInput).style.display = "none";
		document.getElementById('var_servicocod_'  + prCIDInput).value = '';		
		document.getElementById('var_servicocod_'  + prCIDInput).style.display = "none";
		document.getElementById('var_servicodesc_' + prCIDInput).value = '';
		document.getElementById('var_servicodesc_' + prCIDInput).style.display = "none";
		document.getElementById('var_servicoqtde_' + prCIDInput).value = '';		
		document.getElementById('var_servicoqtde_' + prCIDInput).style.display = "none";
		document.getElementById('var_servicovlr_'  + prCIDInput).value = '';		
		document.getElementById('var_servicovlr_'  + prCIDInput).style.display = "none";	  
		//document.form_update.QTDE_INPUTS_SERVICO.value = QtdeInputServico;
	}  
}
/*-------------------------------------------------------------------------------*/		
/* Validação Genérica para apagar elementos - Fim -------------------------------*/
/*-------------------------------------------------------------------------------*/

//****** Quebra as inforrmações do serviço e popula os campos. ******
function setVlrServico(prArrVlr){
  	var auxArray;
	auxArray = prArrVlr.split("|");
	document.getElementById('var_servicocod_' +CIDInputServico).value = auxArray[0];
	document.getElementById('var_servicodesc_' +CIDInputServico).value = auxArray[1];
	document.getElementById('var_servicoqtde_' +CIDInputServico).value = '1';
	document.getElementById('var_servicovlr_' +CIDInputServico).value = auxArray[2];
}

</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Contrato - Altera&ccedil;&atilde;o") %>
<form name="form_update" action="./update_exec.asp" method="post">
	<input type="hidden" name="QTDE_INPUTS_PARCELA" value='0'>
    <input type="hidden" name="QTDE_INPUTS_ANEXO"   value='0'>	
    <input type="hidden" name="QTDE_INPUTS_SERVICO" value='0'>	    
	<input type="hidden" name="DEFAULT_TABLE"       value="CONTRATO">
	<input type="hidden" name="DEFAULT_DB"          value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"        value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"     value="COD_CONTRATO">
	<input type="hidden" name="var_cod_contrato"    value="<%=strCODIGO%>">
	<input type="hidden" name="JSCRIPT_ACTION"      value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION"    value="../modulo_CONTRATO/Update.asp?var_chavereg=<%=strCODIGO%>">
	<input type="hidden" name="var_situacao"        value="ABERTO">
	<input type="hidden" name="DBVAR_DATETIME_SYS_DT_ALTERACAO" value="<%=now()%>">
	<input type="hidden" name="var_sys_alt_id_usuario" value="<%=Request.Cookies("VBOSS")("ID_USUARIO")%>">
	<div class="form_label">Cod:</div><div class="form_bypass"><%=strCODIGO%></div>    
	<br><div class="form_label">Gerar Cobrança:</div><select name="var_tp_cobranca" size="1" style="width:90px;">
													<option value="PAGAR"   <% If GetValue(objRS, "TP_COBRANCA") = "PAGAR"   Then Response.Write("selected") %>>A Pagar</option>
													<option value="RECEBER" <% If GetValue(objRS, "TP_COBRANCA") = "RECEBER" Then Response.Write("selected") %>>A Receber</option>												
												</select>        
	<br><div class="form_label">*Título:</div><input name="var_titulo" type="text" value="<%=GetValue(objRS, "TITULO")%>" maxlength="250" style="width:250px;">
	<br><div class="form_label">Codificação:</div><input name="var_codificacao" type="text" value="<%=GetValue(objRS, "CODIFICACAO")%>" maxlength="100" style="width:120px; text-transform:uppercase;">
	<br><div class="form_label">*Entidade:</div><input name="var_codigo" type="text" maxlength="10" value="<%=GetValue(objRS, "CODIGO")%>" onKeyPress="validateNumKey();" style="vertical-align:bottom; width:40px;"><select name="var_tipo" size="1" style="width:185px;"><% MontaCombo "STR", "SELECT TIPO, DESCRICAO FROM SYS_ENTIDADE ORDER BY DESCRICAO ", "TIPO", "DESCRICAO", GetValue(objRS, "TIPO")%></select><a href="Javascript://;" onClick="Javascript:BuscaEntidade();"><img src="../img/BtBuscar.gif" border="0" style='vertical-align:top; padding-top:2px;' vspace='0' hspace='0'></a>

         <%					  
			 strSQL = " SELECT CONCAT_WS(' - ',CAST(COD_SERVICO AS CHAR),COALESCE(TITULO,DESCRICAO),REPLACE(CAST(ROUND(COALESCE(VALOR,0),2) AS CHAR),'.',',')) AS ROTULO, " &_ 
				      "        CONCAT_WS('|'  ,CAST(COD_SERVICO AS CHAR),COALESCE(TITULO,DESCRICAO),REPLACE(CAST(ROUND(COALESCE(VALOR,0),2) AS CHAR),'.',',')) AS VALOR   " &_ 
                  	  " FROM SV_SERVICO WHERE DT_INATIVO IS NULL "					  
			 'athDebug strSQL, true		 
		 %>
         
	<br><div class="form_label">*Serviço:</div><select name="var_servico" size="1" style="width:250px;"><% MontaCombo "STR", strSQL, "VALOR", "ROTULO","" %></select>
                               <img  src="../img/Bt_add.gif" border="0" style="vertical-align:top; padding-top:0px;" height="18" width="18" vspace="0" hspace="0" onClick="
                                javascript:CIDInputServico++; QtdeInputServico++;
								addElem('eldinservico1','var_servicodel_' +CIDInputServico ,'image','height:14px; border:0px; cursor:pointer;',false,'/*QtdeInputServico--*/; delElem('+CIDInputServico+',\'servico\');'); 
								addElem('eldinservico2','var_servicocod_' +CIDInputServico ,'input','width:20px;' ,true ,''); 
								addElem('eldinservico3','var_servicodesc_'+CIDInputServico ,'input','width:180px;',true ,'');
								addElem('eldinservico4','var_servicoqtde_'+CIDInputServico ,'input','width:30px;' ,false,'');                                
								addElem('eldinservico5','var_servicovlr_' +CIDInputServico ,'input','width:60px;' ,false,''); setVlrServico(document.getElementsByName('var_servico')[0].value);">           
	<br><div class="form_label"></div>-----------------------------------------------------------------------------------
	<br><div class="form_label" style="height:18px;"></div><span style="padding-left:25px;">Cod.</span><span style="padding-left:20px;">Descrição</span><span style="padding-left:140px;">Qtde.</span><span style="padding-left:20px;">Valor</span>
	<br><div class="form_label"></div><div class="form_line" style="padding-left:110px;"><table style="border:0px solid #CCCCCC;"><tr><td><span id='eldinservico1'></span></td><td><span id='eldinservico2'></span></td><td><span id='eldinservico3'></span></td><td><span id='eldinservico4'></span></td><td><span id='eldinservico5'></span></td></tr></table></div>        
    
	<%
	  'Busca serviços do contrato
      strSQL = " SELECT COD_SERVICO, DESCRICAO, QTDE, VALOR FROM CONTRATO_SERVICO WHERE COD_CONTRATO = " & strCODIGO
	  AbreRecordSet lcObjRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1

      if not lcObjRS.eof then 
	    response.write ("<script language='javascript' type='text/javascript'>" & vbNewLIne)
	    do while not lcObjRS.Eof
          'Cria os elementos		
		  response.write (" CIDInputServico++; QtdeInputServico++;")
		  response.write (" addElem('eldinservico1','var_servicodel_' +CIDInputServico ,'image','height:14px; border:0px; cursor:pointer;',false,'delElem('+CIDInputServico+',\'servico\');');  "  & vbNewLIne)
		  response.write (" addElem('eldinservico2','var_servicocod_' +CIDInputServico ,'input','width:20px;' ,true ,''); "	& vbNewLine) 
		  response.write (" addElem('eldinservico3','var_servicodesc_'+CIDInputServico ,'input','width:180px;',true ,''); "	& vbNewLine) 		
		  response.write (" addElem('eldinservico4','var_servicoqtde_'+CIDInputServico ,'input','width:30px;' ,false,''); "	& vbNewLine) 				    
		  response.write (" addElem('eldinservico5','var_servicovlr_' +CIDInputServico ,'input','width:60px;' ,false,''); setVlrServico(document.getElementsByName('var_servico')[0].value); "	& vbNewLine	& vbNewLine)
		  'Adiciona os valores
		  response.write(" document.getElementById('var_servicocod_' +CIDInputServico).value = "  & GetValue(lcObjRS, "COD_SERVICO") & " ;")
		  response.write(" document.getElementById('var_servicodesc_'+CIDInputServico).value = '" & GetValue(lcObjRS, "DESCRICAO"  ) & "';")		  
		  response.write(" document.getElementById('var_servicoqtde_'+CIDInputServico).value = "  & GetValue(lcObjRS, "QTDE"       ) & " ;")		  
		  response.write(" document.getElementById('var_servicovlr_' +CIDInputServico).value = '" & FormataDecimal(GetValue(lcObjRS, "VALOR"), 2) & "' ;")		  		  		  
          athMoveNext lcObjRS, ContFlush, CFG_FLUSH_LIMIT
		loop 
		  response.write ("</script>" & vbNewLIne)
      end if
	%>    
        
	<br><div class="form_label">Alíquota ISSQN:</div><input name="var_aliq_issqn_servico" type="text" value="<% If GetValue(objRS, "ALIQ_ISSQN_SERVICO") <> "" Then Response.Write(FormataDecimal(GetValue(objRS, "ALIQ_ISSQN_SERVICO"), 2)) %>" maxlength="10" style="width:70px" onKeyPress="validateFloatKey();">
	<br><div class="form_label">Documento:</div><input name="var_doc_contrato" type="text" value="<%=GetValue(objRS, "DOC_CONTRATO")%>" maxlength="250" style="width:210px;"><a href="javascript:UploadArquivo('form_update', 'var_doc_contrato', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>//CONTRATOS');"><img src="../img/BtUpload.gif" border="0" style="vertical-align:top; padding-top:4px;" vspace="0" hspace="0"></a>
	<br><div class="form_label">Observação:</div><textarea name="var_obs" rows="6"><%=GetValue(objRS, "OBS")%></textarea>
	<br><div class="form_label">*Dt Início:</div><input name="var_dt_ini" value="<%=PrepData(GetValue(objRS, "DT_INI"), True, False)%>" type="text" maxlength="10" style="width:70px;" onKeyPress="Javascript:validateNumKey();" onKeyUp="Javascript:FormataInputData(this.form.name, this.name);">&nbsp;<%=ShowLinkCalendario("form_update", "var_dt_ini", "ver calendário")%>
	<br><div class="form_label">*Dt Fim:</div><input name="var_dt_fim" value="<%=PrepData(GetValue(objRS, "DT_FIM"), True, False)%>" type="text" maxlength="10" style="width:70px;" onKeyPress="Javascript:validateNumKey();" onKeyUp="Javascript:FormataInputData(this.form.name, this.name);">&nbsp;<%=ShowLinkCalendario("form_update", "var_dt_fim", "ver calendário")%>
	<br><div class="form_label">*Dt Base do Contrato:</div><input name="var_dt_base_contrato" value="<%=PrepData(GetValue(objRS, "DT_BASE_CONTRATO"), True, False)%>" type="text" maxlength="10" style="width:70px;" onKeyPress="Javascript:validateNumKey();" onKeyUp="Javascript:FormataInputData(this.form.name, this.name);">&nbsp;<%=ShowLinkCalendario("form_update", "var_dt_base_contrato", "ver calendário")%>&nbsp;<span class="texto_ajuda">dd/mm/aaaa</span>		
	<br><div class="form_label"></div>Data de base para pesquisa dos títulos em aberto deste contrato para reajuste
	<br>
	<br><div class="form_label">Dt Assinatura:</div><input name="var_dt_assinatura" value="<%=PrepData(GetValue(objRS, "DT_ASSINATURA"), True, False)%>" type="text" maxlength="10" style="width:70px;" onKeyPress="Javascript:validateNumKey();" onKeyUp="Javascript:FormataInputData(this.form.name, this.name);">&nbsp;<%=ShowLinkCalendario("form_update", "var_dt_assinatura", "ver calendário")%>
	<br><div class="form_label">*Vlr Total(Ref.):</div><input name="var_vlr_total" type="text" value="<%=FormataDecimal(GetValue(objRS, "VLR_TOTAL"), 2)%>" maxlength="10" style="width:70px" onKeyPress="validateFloatKey();"><span class="texto_ajuda">Não corresponde necessáriamente a soma das parcelas</span>
    <br>
	<br><div class="form_label">Anexos:</div><a href="javascript:CIDInputAnexo++; QtdeInputAnexo++;
								addElem('eldinanexo1','var_ianexo_'     +CIDInputAnexo,'image','height:14px; border:0px; cursor:pointer;',false,'delElem('+CIDInputAnexo+',\'anexo\');'); 
								addElem('eldinanexo2','var_anexo_'      +CIDInputAnexo,'input','width:110px;'                            ,true ,''); 
								addElem('eldinanexo3','var_anexodesc_'  +CIDInputAnexo,'input','width:200px;'                            ,false,'');
								UploadArquivo('form_update','var_anexo_'+CIDInputAnexo, 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>//CONTRATOS_Anexos');
								"><img src="../img/BtUpload.gif" title="Buscar arquivo" alt="Buscar arquivo" border="0" style="vertical-align:top; padding-top:2px" vspace="0" hspace="0"></a>		
	<br><div class="form_label"></div>-----------------------------------------------------------------------------------
	<br><div class="form_label" style="height:18px;"></div><span style="padding-left:25px;">Arquivo</span><span style="padding-left:80px;">Descrição</span>
	<br><div class="form_label"></div><div class="form_line" style="padding-left:110px;"><table style="border:0px solid #CCCCCC;"><tr><td><span id='eldinanexo1'></span></td><td><span id='eldinanexo2'></span></td><td><span id='eldinanexo3'></span></td></tr></table></div>

	<%
	  'Busca anexos do contrato
      strSQL = " SELECT COD_ANEXO, COD_CONTRATO, ARQUIVO, DESCRICAO, SYS_DTT_INS, SYS_ID_USUARIO_INS FROM CONTRATO_ANEXO WHERE COD_CONTRATO =" & strCODIGO
	  AbreRecordSet lcObjRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1

      if not lcObjRS.eof then 
	    response.write ("<script language='javascript' type='text/javascript'>" & vbNewLIne)
	    do while not lcObjRS.Eof
          'Cria os elementos		
		  response.write (" CIDInputAnexo++; QtdeInputAnexo++;")
		  response.write (" addElem('eldinanexo1','var_ianexo_'+CIDInputAnexo   ,'image','height:14px; border:0px; cursor:pointer;',false,'/*QtdeInputAnexo--*/; delElem('+CIDInputAnexo+',\'anexo\');'); " & vbNewLIne)
		  response.write (" addElem('eldinanexo2','var_anexo_'+CIDInputAnexo    ,'input','width:110px;'                            ,true ,''); "	& vbNewLine) 
		  response.write (" addElem('eldinanexo3','var_anexodesc_'+CIDInputAnexo,'input','width:200px;'                            ,false,'');"	& vbNewLine	& vbNewLine)
		  'Adiciona os valores
		  response.write(" document.getElementById('var_anexo_'    +CIDInputAnexo).value = '" & GetValue(lcObjRS, "ARQUIVO"  ) & "';")
		  response.write(" document.getElementById('var_anexodesc_'+CIDInputAnexo).value = '" & GetValue(lcObjRS, "DESCRICAO") & "';")		  
          athMoveNext lcObjRS, ContFlush, CFG_FLUSH_LIMIT
		loop 
		  response.write ("</script>" & vbNewLIne)
      end if
	%>
	
	<div class="form_grupo" id="form_grupo_1">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_1" border="0" onClick="ShowArea('form_grupo_1','form_collapse_1');" 										  
  		style="cursor:pointer;">
		<b>Gerador de Parcelas do Contrato</b><br>	
		<br><div class="form_label">Freq. de Vcto.</div><select name="var_frequencia" size="1" style="width:90px;">
														<option value=""           <% If GetValue(objRS, "FREQUENCIA") = ""           Then Response.Write("selected") %>>[selecione]</option>
														<option value="DIARIA"     <% If GetValue(objRS, "FREQUENCIA") = "DIARIA"     Then Response.Write("selected") %>>Diária     </option>
														<option value="SEMANAL"    <% If GetValue(objRS, "FREQUENCIA") = "SEMANAL"    Then Response.Write("selected") %>>Semanal    </option>
														<option value="QUINZENAL"  <% If GetValue(objRS, "FREQUENCIA") = "QUINZENAL"  Then Response.Write("selected") %>>Quinzenal  </option>
														<option value="MENSAL"     <% If GetValue(objRS, "FREQUENCIA") = "MENSAL"     Then Response.Write("selected") %>>Mensal     </option>
														<option value="BIMESTRAL"  <% If GetValue(objRS, "FREQUENCIA") = "BIMESTRAL"  Then Response.Write("selected") %>>Bimestral  </option>
														<option value="TRIMESTRAL" <% If GetValue(objRS, "FREQUENCIA") = "TRIMESTRAL" Then Response.Write("selected") %>>Trimestral </option>
														<option value="SEMESTRAL"  <% If GetValue(objRS, "FREQUENCIA") = "SEMESTRAL"  Then Response.Write("selected") %>>Semestral  </option>
														<option value="ANUAL"      <% If GetValue(objRS, "FREQUENCIA") = "ANUAL"      Then Response.Write("selected") %>>Anual      </option>
													</select>	
		<br>
		<div class="form_label">*Dt Vcto 1&ordf; Parcela:</div>
		<input name="var_dt_base_vcto" value="<%=PrepData(GetValue(objRS, "DT_BASE_VCTO"), True, False)%>" type="text" maxlength="10" style="width:70px;" onKeyPress="Javascript:validateNumKey();" onKeyUp="Javascript:FormataInputData(this.form.name, this.name);">&nbsp;<%=ShowLinkCalendario("form_update", "var_dt_base_vcto", "ver calendário")%>
		<br><div class="form_label">*Valor Parcela(Ref.):</div><input name="var_vlr_parcela_ref" value="<% If GetValue(objRS, "VLR_PARCELA") <> "" Then Response.Write(FormataDecimal(GetValue(objRS, "VLR_PARCELA"), 2)) %>" type="text" maxlength="10" style="width:70px;" onKeyPress="validateFloatKey();">	
		<br><div class="form_label">Num. de Parcelas:</div><input name="var_num_parcela_ref" type="text" value="<%=GetValue(objRS, "NUM_PARC")%>" maxlength="10" style="width:50px;" onKeyPress="validateFloatKey();"><a href="Javascript:addInputsParcela(document.getElementsByName('var_num_parcela_ref')[0].value);"><img src="../img/BtGerarParcelas.gif" title="Gerar parcelas" alt="Gerar parcelas" border="0" style="vertical-align:top; padding-top:4px" vspace="0" hspace="0"></a>
	</div>		
	<br><div class="form_label"></div>---------------------------------------------------------------------------------------------
	<br><div class="form_label" style="height:18px;"></div><span style="padding-left:5px;">Num. Parc.</span><span style="padding-left:15px;">Valor. Parcela</span><span style="padding-left:110px;">Dt. Venc.</span>
	<br><div class="form_label"></div><div class="form_line" style="padding-left:110px;"><table style="border:0px solid #CCCCCC;"><tr>
	<td><span id='eldin1parcela1'></span></td><td><span id='eldinparcela2'></span></td><td><span id='eldinparcela3'></span></td><td><span id='eldinparcela4'></span></td><td><span id='eldinparcela5'></span></td></tr></table></div>			
	<%
		'Monta consulta das parcelas do contrato
		strSQL = ""
		strSQL =          "SELECT VLR_PARCELA, DT_VENC FROM CONTRATO_PARCELA WHERE COD_CONTRATO = "  & strCODIGO & " ORDER BY DT_VENC "		
		AbreRecordSet lcObjRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1		
		'athDebug strSQL false						
		If Not lcObjRS.Eof Then 
			response.write ("<script language='JavaScript'>" & vbNewLIne)
			do while not lcObjRS.Eof											
				response.write (" CIDInputParcela++; QtdeInputParcela++;")				
				response.write(" addElem('eldinparcela2','var_num_parcela_'        +CIDInputParcela ,'input' ,'width:40px;'                         ,true ,''); ")														
				response.write(" addElem('eldinparcela3','var_vlr_parcela_'        +CIDInputParcela ,'input' ,'width:170px;'                        ,false,''); ")
     			response.write(" addElem('eldinparcela4','var_dt_venc_parcela_'    +CIDInputParcela ,'input' ,'width:90px;'                         ,false,''); ") 
     			response.write(" addElem('eldinparcela5','var_dia_semana_parcela_' +CIDInputParcela ,'input' ,'width:40px;background-color:#ffffff;',true ,''); ") 								
				'Seta os valores dos campos criados
				response.write(" document.getElementById('var_num_parcela_' + String(CIDInputParcela)).value = QtdeInputParcela; ") 			  				
				response.write(" eval('document.form_update.var_vlr_parcela_' + CIDInputParcela + '.value =  ' + " & "'\'"& FormataDecimal(GetValue(lcObjRS, "VLR_PARCELA"),2) & "\''" & "); " & vbNewLine)				
				response.write(" eval('document.form_update.var_dt_venc_parcela_' + CIDInputParcela + '.value =  ' + " & "'\'"& PrepData(GetValue(lcObjRS, "DT_VENC"), True, False) & "\''" & "); " & vbNewLine)								
				response.write(" updDiaSemana('var_dia_semana_parcela_' + CIDInputParcela, document.getElementById('var_dt_venc_parcela_' + CIDInputParcela).value);")  	  	
     		    athMoveNext lcObjRS, ContFlush, CFG_FLUSH_LIMIT
			loop 
			response.write ("</script>" & vbNewLIne)
		End If
		FechaRecordSet lcObjRS		
	%>		
	<div class="form_label"></div>OBS: As Parcelas com valor zero não irão gerar Título no processamento.	
	<br>
	<br><div class="form_label">Tipo Reajuste:</div><select name="var_tp_reajuste" size="1" style="width:90px;">
													<option value=""           <% If GetValue(objRS, "TP_REAJUSTE") = ""           Then Response.Write("selected") %>>[selecione]</option>
													<option value="DIARIA"     <% If GetValue(objRS, "TP_REAJUSTE") = "DIARIA"     Then Response.Write("selected") %>>Diário     </option>
													<option value="SEMANAL"    <% If GetValue(objRS, "TP_REAJUSTE") = "SEMANAL"    Then Response.Write("selected") %>>Semanal    </option>
													<option value="QUINZENAL"  <% If GetValue(objRS, "TP_REAJUSTE") = "QUINZENAL"  Then Response.Write("selected") %>>Quinzenal  </option>
													<option value="MENSAL"     <% If GetValue(objRS, "TP_REAJUSTE") = "MENSAL"     Then Response.Write("selected") %>>Mensal     </option>
													<option value="BIMESTRAL"  <% If GetValue(objRS, "TP_REAJUSTE") = "BIMESTRAL"  Then Response.Write("selected") %>>Bimestral  </option>
													<option value="TRIMESTRAL" <% If GetValue(objRS, "TP_REAJUSTE") = "TRIMESTRAL" Then Response.Write("selected") %>>Trimestral </option>
													<option value="SEMESTRAL"  <% If GetValue(objRS, "TP_REAJUSTE") = "SEMESTRAL"  Then Response.Write("selected") %>>Semestral  </option>
													<option value="ANUAL"      <% If GetValue(objRS, "TP_REAJUSTE") = "ANUAL"      Then Response.Write("selected") %>>Anual      </option>
													</select>	
	<span class="texto_ajuda">Alerta de Reajuste de acordo com a Dt Início do Contrato</span>																										
	<!--Retirado a pedido do Aless. By Lumertz 18.12.2012 -->												
	<!--<br><div class="form_label">Fator Reajuste:</div><input name="var_fator_reajuste" type="text" value="<% If GetValue(objRS, "FATOR_REAJUSTE") <> "" Then Response.Write(FormataDecimal(GetValue(objRS, "FATOR_REAJUSTE"), 2)) %>" maxlength="10" style="width:70px" onKeyPress="validateFloatKey();">-->													
	<br><div class="form_label">Tipo:</div><select name="var_tp_renovacao" size="1" style="width:90px;">
												<option value="RENOVAVEL"     <% If GetValue(objRS, "TP_RENOVACAO") = "RENOVAVEL"     Then Response.Write("selected") %>>Renovável</option>
												<option value="NAO_RENOVAVEL" <% If GetValue(objRS, "TP_RENOVACAO") = "NAO_RENOVAVEL" Then Response.Write("selected") %>>Não Renovável</option>
											</select><span class="texto_ajuda">Alerta de Renovação de acordo com a Dt Fim do Contrato</span>
	<br><div class="form_label">Status:</div><input name="var_dt_inativo" type="radio" class='inputclean' value="NULL" checked>Ativo
	&nbsp;&nbsp;<div class="form_label_nowidth"><input name="var_dt_inativo" type="radio" class='inputclean' value="">Inativo</div>                                            
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>
<%
		End If
		FechaRecordSet objRS
	End If
	FechaDBConn objConn
%>
