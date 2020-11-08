<!--#include file="../_database/athdbConn.asp"--><%' ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_CONTRATO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os �tens de formul�rio 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * s�o obrigat�rios.</span>"

	Dim objConn, objRS, strSQL, lcObjRS
	Dim strCODIGO
	
	AbreDBConn objConn, CFG_DB 
	
	strCODIGO = GetParam("var_chavereg")
	
	If strCODIGO <> "" Then
		strSQL =          " SELECT T1.COD_CONTRATO                                          "
        strSQL = strSQL & "      , T1.CODIFICACAO                                           "
        strSQL = strSQL & "      , T1.TITULO                                                "
        strSQL = strSQL & "      , T1.DT_INI                                                "
        strSQL = strSQL & "      , T1.DT_FIM                                                "
        strSQL = strSQL & "      , T1.DT_ASSINATURA                                         "
        strSQL = strSQL & "      , T1.TP_RENOVACAO                                          "
        strSQL = strSQL & "      , T1.TP_COBRANCA                                           "		
		strSQL = strSQL & "      , T1.SITUACAO                                              "
		strSQL = strSQL & "      , T1.DOC_CONTRATO                                          "
		strSQL = strSQL & "      , T1.OBS                                                   "		
		strSQL = strSQL & "      , T1.FREQUENCIA                                            "
		strSQL = strSQL & "      , T1.NUM_PARC                                              "				
		strSQL = strSQL & "      , T1.VLR_TOTAL                                             "
		strSQL = strSQL & "      , T1.DT_BASE_VCTO                                          "						
		strSQL = strSQL & "      , T1.CODIGO, T2.NOME_FANTASIA AS CLIENTE                   "
        strSQL = strSQL & "		 , T1.ALIQ_ISSQN_SERVICO,VLR_PARCELA                        "
		strSQL = strSQL & " FROM CONTRATO T1                                                "
		strSQL = strSQL & " LEFT OUTER JOIN ENT_CLIENTE T2 ON (T1.CODIGO = T2.COD_CLIENTE ) "
		strSQL = strSQL & " WHERE COD_CONTRATO = " & strCODIGO
		
		Set objRS = objConn.Execute(strSQL)
		
		If Not objRS.Eof Then
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Fun��es de a��o dos bot�es - In�cio ******
function ok() 		{ submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { }
function submeterForm() {
	var var_msg = '';
    var i = 1;
	
	if (document.form_insert.var_titulo.value      == '') var_msg += '\nT�tulo';
	if (document.form_insert.var_codigo.value      == '') var_msg += '\nEntidade';
	//Valida servi�os inseridos.
	for(i=1;i<=CIDInputServico;i++){
		auxCod = document.getElementById('var_servicocod_' + i).value
		if(auxCod != '' && auxCod != null) { 				
		    bTemServico = true;
			if (isInt(eval('document.form_insert.var_servicoqtde_' + i + '.value'))==false){
				var_msg += '\nQuantidade do servico c�digo' + auxCod;				  
			}				  
			if (isFloat(eval('document.form_insert.var_servicovlr_' + i + '.value'))==false){
				var_msg += '\nValor do servico c�digo ' + auxCod;				  
			}	 
		}
	}				
	if ((document.form_insert.var_dt_ini.value == '')           || (checkDate(document.form_insert.var_dt_ini.value)==false))           var_msg += '\nDt. In�cio';		
	if ((document.form_insert.var_dt_fim.value == '')           || (checkDate(document.form_insert.var_dt_fim.value)==false))           var_msg += '\nDt. Fim.';						
	if ((document.form_insert.var_dt_base_contrato.value == '') || (checkDate(document.form_insert.var_dt_base_contrato.value)==false)) var_msg += '\nDt. Base Contrato';					
	if ((document.form_insert.var_vlr_total.value == '')        || (isFloat(document.form_insert.var_vlr_total.value)==false))          var_msg += '\nValor total(Ref.)';	
	if ((document.form_insert.var_dt_base_vcto.value == '')     || (checkDate(document.form_insert.var_dt_base_vcto.value)==false))     var_msg += '\nDt Vcto 1� Parcela';		
	if ((document.form_insert.var_vlr_parcela_ref.value == '')  || (isFloat(document.form_insert.var_vlr_parcela_ref.value)==false))    var_msg += '\nValor da parcela(Ref.)';	
    if ((document.form_insert.var_num_parcela_ref.value == '' ) || (document.form_insert.var_num_parcela_ref.value == '0' ))            var_msg += '\nN�mero de parcelas(Ref.)';		
	if (document.form_insert.var_num_parcela_ref.value != QtdeInputParcela )                                                                   var_msg += '\nN�mero de parcelas(Ref.) e parcelas geradas n�o conferem';	
	
	// Valida a data de vencimento e valor das parcelas do contrato.
    if (QtdeInputParcela < 1) var_msg += '\nParcelas n�o geradas';	
	for(;i<=CIDInputParcela;i++){
	  if (checkDate(eval('document.form_insert.var_dt_venc_parcela_'+ i + '.value'))==false){
	    var_msg += '\nDt de Venc. da parcela ' + i;			
	  }
	  if (isFloat(eval('document.form_insert.var_vlr_parcela_' + i + '.value'))==false){
	    var_msg += '\nValor da parcela ' + i;				  
	  }	  
	}	
	
	if (var_msg == ''){
		document.form_insert.submit();
	} else{
		alert('Favor verificar campos obrigat�rios:\n' + var_msg);
	}
}
//****** Fun��es de a��o dos bot�es - Fim ******

function BuscaEntidade() {	
	AbreJanelaPAGE('BuscaPorEntidade.asp?var_form=form_insert&var_input=var_codigo&var_input_tipo=var_tipo&var_tipo=' + document.form_insert.var_tipo.value,'640','390');
}

function LimparCampo(prForm, prCampo) {
	eval("document." + prForm + "." + prCampo + ".value = '';");
}

function LimparCampo(prForm, prCampo) {
	eval("document." + prForm + "." + prCampo + ".value = '';");
}

//****** Vars que controlam a quantidade de elementos e o seu ID ******
var CIDInputParcela = 0, QtdeInputParcela = 0;
var CIDInputServico = 0, QtdeInputServico = 0;
var CIDInputAnexo   = 0, QtdeInputAnexo   = 0;

//******Recebe o Id do elemento que ir� receber ao dia da semana abreviado, e a data(String) que deseja saber o dia da semana ******
function updDiaSemana(prIDElemTarget, prData){
	document.getElementById(prIDElemTarget).value = getDiaSemana(prData);
}

//****** Adiciona as parcelas. ******
function addInputsParcela(prQtdeInputs){ 
    var var_msg = '';
	var auxDate;
    var auxFreq = document.getElementsByName('var_frequencia')[0].value;	
    //Verifica se as parcelas podem ser geradas.
	if ((document.form_insert.var_frequencia.value      == '' ) && (document.form_insert.var_num_parcela_ref.value > 1))            var_msg += '\nFreq. de Venc. das parcelas';
	if ((document.form_insert.var_dt_base_vcto.value    == '' ) || (checkDate(document.form_insert.var_dt_base_vcto.value)==false)) var_msg += '\nDt. Base Venc.';			
	if  (document.form_insert.var_vlr_parcela_ref.value == '' )                                                                     var_msg += '\nValor da parcela(Ref.)';	
	if ((document.form_insert.var_num_parcela_ref.value == '0') || (document.form_insert.var_num_parcela_ref.value == ''))          var_msg += '\nN�mero de parcelas';

	if (var_msg != ''){
		alert('N�o foi poss�vel gerar as parcelas. Favor verificar:\n' + var_msg);
	} else{	
		//Apaga os inputs.
		for(; QtdeInputParcela>0;){	 
			QtdeInputParcela--;	  
			delElem(QtdeInputParcela+1,'parcela'); 	
			CIDInputParcela--;
		}
		//Constr�i os inputs com base no n�mero de parcelas digitado.	  
		for(Aux=0; Aux<prQtdeInputs; Aux++){
			CIDInputParcela++; QtdeInputParcela++;
			//Deixei comentado o bot�o que apaga a parcela.
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
			//Nas outras datas, acrescenta o per�odo conforme a peridiocidade.	
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
/* Valida��o Gen�rica para criar elementos - Ini --------------------------------*/
/*-------------------------------------------------------------------------------*/
function addElem(prPai, prNomeElemento, prTpElemento, prStyle, prReadOnly, prClickAction){		
	var newFormObj;
	var ParentElem = document.getElementById(prPai);
	
	if (prTpElemento=="image") {
		//Cria o bot�o de deletar.
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
	//Verifica se o componente � ReadOnly
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
		newFormObj.setAttribute('onkeyup'   ,'FormataInputData(this.form.name, this.name);');	  	  	
		newFormObj.setAttribute('onchange'  ,'updDiaSemana(\'var_dia_semana_parcela_' + String(CIDInputParcela) + '\',this.value);');	  	  	
	//campos de valor inteiro
	}else if(prNomeElemento.indexOf('qtde') > -1){
		newFormObj.setAttribute('onkeypress','validateNumKey();');	  	  				
	}
	//A��o de click
	if (prClickAction != ''){
		newFormObj.setAttribute("onclick"	,prClickAction);
	}	
	//Adiciona elemento ao pai  
	ParentElem.appendChild(newFormObj);
	//Atualiza qtde de inputs
	if (prNomeElemento.indexOf('parcela') > -1){
		document.form_insert.QTDE_INPUTS_PARCELA.value = QtdeInputParcela; 
	}else if (prNomeElemento.indexOf('anexo') > -1){
		document.form_insert.QTDE_INPUTS_ANEXO.value = QtdeInputAnexo;
	}else if (prNomeElemento.indexOf('servico') > -1){
		document.form_insert.QTDE_INPUTS_SERVICO.value = QtdeInputServico;
	}
}
/*-------------------------------------------------------------------------------*/		
/* Valida��o Gen�rica para criar elementos - Fim --------------------------------*/
/*-------------------------------------------------------------------------------*/

/*-------------------------------------------------------------------------------*/		
/* Valida��o Gen�rica para apagar elementos - Ini -------------------------------*/
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
		
		document.form_insert.QTDE_INPUTS_PARCELA.value = QtdeInputParcela;
		
	}else if (prTipoElem == 'anexo'){
		/*Deixa os elementos invis�veis, para podermos pegar seus valores na Exec.
		  Os que estiverem sem valor n�o ser�o gravados.*/
		document.getElementById('var_ianexo_'    + prCIDInput).style.display = "none";				  		
		document.getElementById('var_anexo_'     + prCIDInput).value = '';
    	document.getElementById('var_anexodesc_' + prCIDInput).value = '';			
        document.getElementById('var_anexo_'     + prCIDInput).style.display = "none";
     	document.getElementById('var_anexodesc_' + prCIDInput).style.display = "none"; 
		//document.form_insert.QTDE_INPUTS_ANEXO.value = QtdeInputAnexo;	  
	}else if (prTipoElem == 'servico'){
		/*Deixa os elementos invis�veis, para podermos pegar seus valores na Exec.
		  Os que estiverem sem valor n�o ser�o gravados.*/        
		document.getElementById('var_servicodel_'  + prCIDInput).style.display = "none";
		document.getElementById('var_servicocod_'  + prCIDInput).value = '';		
		document.getElementById('var_servicocod_'  + prCIDInput).style.display = "none";
		document.getElementById('var_servicodesc_' + prCIDInput).value = '';
		document.getElementById('var_servicodesc_' + prCIDInput).style.display = "none";
		document.getElementById('var_servicoqtde_' + prCIDInput).value = '';		
		document.getElementById('var_servicoqtde_' + prCIDInput).style.display = "none";
		document.getElementById('var_servicovlr_'  + prCIDInput).value = '';		
		document.getElementById('var_servicovlr_'  + prCIDInput).style.display = "none";	  
		//document.form_insert.QTDE_INPUTS_SERVICO.value = QtdeInputServico;
	}  
}
/*-------------------------------------------------------------------------------*/		
/* Valida��o Gen�rica para apagar elementos - Ini -------------------------------*/
/*-------------------------------------------------------------------------------*/

//****** Quebra as inforrma��es do servi�o e popula os campos. ******
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
<%=athBeginDialog(WMD_WIDTH, "Contrato - Renova��o") %>
<form name="form_insert" action="Renova_exec.asp" method="post">
	<input type="hidden" name="var_cod_contrato" value="<%=strCODIGO%>">
	<input type="hidden" name="var_tp_cobranca" value="<%=GetValue(objRS, "TP_COBRANCA")%>">
	<input type="hidden" name="QTDE_INPUTS_PARCELA" value='0'>
    <input type="hidden" name="QTDE_INPUTS_ANEXO"   value='0'>	
    <input type="hidden" name="QTDE_INPUTS_SERVICO" value='0'>	    
	<input type="hidden" name="var_situacao" value="ABERTO">
	<input type="hidden" name="var_sys_dt_insercao" value="<%=now()%>">
	<input type="hidden" name="var_sys_ins_id_usuario" value="<%=Request.Cookies("VBOSS")("ID_USUARIO")%>">		
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_CONTRATO/insert.asp'>	
	<br><div class="form_label">Gerar Cobran�a:</div><div class="form_bypass"><%
		If GetValue(objRS, "TP_COBRANCA") = "PAGAR" Then Response.Write("A Pagar") 
		If GetValue(objRS, "TP_COBRANCA") = "RECEBER" Then Response.Write("A Receber") 
	%></div>    
	<br><div class="form_label">*T�tulo:</div><input name="var_titulo" type="text" value="<%=GetValue(objRS, "TITULO")%>" maxlength="250" style="width:250px;">
	<br><div class="form_label">Codifica��o:</div><input name="var_codificacao" type="text" value="" maxlength="100" style="width:120px; text-transform:uppercase;">
	<br><div class="form_label">*Entidade:</div><input name="var_codigo" type="text" maxlength="10" value="<%=GetValue(objRS, "CODIGO")%>" onKeyPress="validateNumKey();" style="vertical-align:bottom; width:40px;"><select name="var_tipo" size="1" style="width:185px;"><%
		 MontaCombo "STR", "SELECT TIPO, DESCRICAO FROM SYS_ENTIDADE ORDER BY DESCRICAO ", "TIPO", "DESCRICAO", ""%></select><a href="Javascript://;" onClick="Javascript:BuscaEntidade();"><img src="../img/BtBuscar.gif" border="0" style='vertical-align:top; padding-top:2px;' vspace='0' hspace='0'></a>
         <%					  
		     'Busca servi�os
			 strSQL = " SELECT CONCAT_WS(' - ',CAST(COD_SERVICO AS CHAR),COALESCE(TITULO,DESCRICAO),REPLACE(CAST(ROUND(COALESCE(VALOR,0),2) AS CHAR),'.',',')) AS ROTULO, " &_ 
				      "        CONCAT_WS('|'  ,CAST(COD_SERVICO AS CHAR),COALESCE(TITULO,DESCRICAO),REPLACE(CAST(ROUND(COALESCE(VALOR,0),2) AS CHAR),'.',',')) AS VALOR   " &_ 
                  	  " FROM SV_SERVICO WHERE DT_INATIVO IS NULL "					  
			 'athDebug strSQL, true		 
		 %>         
	<br><div class="form_label">*Servi�o:</div><select name="var_servico" size="1" style="width:250px;"><% MontaCombo "STR", strSQL, "VALOR", "ROTULO","" %></select>
                  <img  src="../img/Bt_add.gif" border="0" style="vertical-align:top; padding-top:0px;" height="18" width="18" vspace="0" hspace="0" 
                   onClick="javascript:CIDInputServico++; QtdeInputServico++;
							addElem('eldinservico1','var_servicodel_' +CIDInputServico ,'image','height:14px; border:0px; cursor:pointer;',false,'delElem('+CIDInputServico+',\'servico\');'); 
							addElem('eldinservico2','var_servicocod_' +CIDInputServico ,'input','width:20px;' ,true ,''); 
							addElem('eldinservico3','var_servicodesc_'+CIDInputServico ,'input','width:180px;',true ,'');
							addElem('eldinservico4','var_servicoqtde_'+CIDInputServico ,'input','width:30px;' ,false,'');                                
							addElem('eldinservico5','var_servicovlr_' +CIDInputServico ,'input','width:60px;' ,false,''); setVlrServico(document.getElementsByName('var_servico')[0].value);">           
	<br><div class="form_label"></div>-----------------------------------------------------------------------------------
	<br><div class="form_label" style="height:18px;"></div><span style="padding-left:25px;">Cod.</span><span style="padding-left:20px;">Descri��o</span><span style="padding-left:140px;">Qtde.</span><span style="padding-left:20px;">Valor</span>
	<br><div class="form_label"></div><div class="form_line" style="padding-left:110px;"><table style="border:0px solid #CCCCCC;"><tr><td><span id='eldinservico1'></span></td><td><span id='eldinservico2'></span></td><td><span id='eldinservico3'></span></td><td><span id='eldinservico4'></span></td><td><span id='eldinservico5'></span></td></tr></table></div>                   
	<%
	  'Busca servi�os do contrato anterior
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
	<br><div class="form_label">Al�quota ISSQN:</div><input name="var_aliq_issqn" type="text" value="<%=GetValue(objRS, "ALIQ_ISSQN_SERVICO")%>" maxlength="10" style="width:70px" onKeyPress="validateFloatKey();">
	<br><div class="form_label">Documento:</div><input name="var_doc_contrato" type="text" value="<%=GetValue(objRS, "DOC_CONTRATO")%>" maxlength="250" style="width:210px;"><a href="javascript:UploadArquivo('form_insert', 'var_doc_contrato', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>//CONTRATOS');"><img src="../img/BtUpload.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
	<br><div class="form_label">Obs:</div><textarea name="var_obs" rows="6"></textarea>
	<br><div class="form_label">*Dt In�cio:</div><input name="var_dt_ini" value="<%=PrepData(DateAdd("D", 1, GetValue(objRS, "DT_FIM")), True, False)%>" type="text" maxlength="10" style="width:70px;" onKeyPress="Javascript:validateNumKey();" onKeyUp="Javascript:FormataInputData(this.form.name, this.name);">&nbsp;<%=ShowLinkCalendario("form_insert", "var_dt_ini", "ver calend�rio")%>&nbsp;<span class="texto_ajuda">dd/mm/aaaa</span>
	<br><div class="form_label">*Dt Fim:</div><input name="var_dt_fim" value="" type="text" maxlength="10" style="width:70px;" onKeyPress="Javascript:validateNumKey();" onKeyUp="Javascript:FormataInputData(this.form.name, this.name);">&nbsp;<%=ShowLinkCalendario("form_insert", "var_dt_fim", "ver calend�rio")%>&nbsp;<span class="texto_ajuda">dd/mm/aaaa</span>
	<br><div class="form_label">*Dt Base do Contrato:</div><input name="var_dt_base_contrato" value="" type="text" maxlength="10" style="width:70px;" onKeyPress="Javascript:validateNumKey();" onKeyUp="Javascript:FormataInputData(this.form.name, this.name);">&nbsp;<%=ShowLinkCalendario("form_insert", "var_dt_base_contrato", "ver calend�rio")%>&nbsp;<span class="texto_ajuda">dd/mm/aaaa</span>			
	<br><div class="form_label">Dt Assinatura:</div><input name="var_dt_assinatura" value="" type="text" maxlength="10" style="width:70px;" onKeyPress="Javascript:validateNumKey();" onKeyUp="Javascript:FormataInputData(this.form.name, this.name);">&nbsp;<%=ShowLinkCalendario("form_insert", "var_dt_assinatura", "ver calend�rio")%>&nbsp;<span class="texto_ajuda">dd/mm/aaaa</span>
	<br><div class="form_label">*Vlr Total(Ref.):</div><input name="var_vlr_total" type="text" value="<%=FormataDecimal(GetValue(objRS, "VLR_TOTAL"),2)%>" maxlength="10" style="width:70px" onKeyPress="validateFloatKey();"><span class="texto_ajuda">N�o corresponde necess�riamente a soma das parcelas</span>
    <br>
	<br><div class="form_label">Anexos:</div><a href="javascript:CIDInputAnexo++; QtdeInputAnexo++;
								addElem('eldinanexo1','var_ianexo_'+CIDInputAnexo,'image','height:14px; border:0px; cursor:pointer;',false,'/*QtdeInputAnexo--*/; delElem('+CIDInputAnexo+',\'anexo\');'); 
								addElem('eldinanexo2','var_anexo_'+CIDInputAnexo    ,'input','width:110px;',true ,''); 
								addElem('eldinanexo3','var_anexodesc_'+CIDInputAnexo,'input','width:200px;',false,'');
								UploadArquivo('form_insert','var_anexo_'+CIDInputAnexo, 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>//CONTRATOS_Anexos');
								"><img src="../img/BtUpload.gif" title="Buscar arquivo" alt="Buscar arquivo" border="0" style="vertical-align:top; padding-top:2px" vspace="0" hspace="0"></a>		
	<br><div class="form_label"></div>-----------------------------------------------------------------------------------
	<br><div class="form_label" style="height:18px;"></div><span style="padding-left:25px;">Arquivo</span><span style="padding-left:80px;">Descri��o</span>
	<br><div class="form_label"></div><div class="form_line" style="padding-left:110px;"><table style="border:0px solid #CCCCCC;"><tr><td><span id='eldinanexo1'></span></td><td><span id='eldinanexo2'></span></td><td><span id='eldinanexo3'></span></td></tr></table></div>   
	<%
	  'Busca anexos do contrato anterior
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
		<b>Parcelas do Contrato</b><br>	
		<br><div class="form_label">Freq. de Vcto.:</div><select name="var_frequencia" size="1" style="width:90px;">
														<option value=""           <% If GetValue(objRS, "FREQUENCIA") = ""           Then Response.Write("selected") %>>[selecione]</option>
														<option value="DIARIA"     <% If GetValue(objRS, "FREQUENCIA") = "DIARIA"     Then Response.Write("selected") %>>Di�ria     </option>
														<option value="SEMANAL"    <% If GetValue(objRS, "FREQUENCIA") = "SEMANAL"    Then Response.Write("selected") %>>Semanal    </option>
														<option value="QUINZENAL"  <% If GetValue(objRS, "FREQUENCIA") = "QUINZENAL"  Then Response.Write("selected") %>>Quinzenal  </option>
														<option value="MENSAL"     <% If GetValue(objRS, "FREQUENCIA") = "MENSAL"     Then Response.Write("selected") %>>Mensal     </option>
														<option value="BIMESTRAL"  <% If GetValue(objRS, "FREQUENCIA") = "BIMESTRAL"  Then Response.Write("selected") %>>Bimestral  </option>
														<option value="TRIMESTRAL" <% If GetValue(objRS, "FREQUENCIA") = "TRIMESTRAL" Then Response.Write("selected") %>>Trimestral </option>
														<option value="SEMESTRAL"  <% If GetValue(objRS, "FREQUENCIA") = "SEMESTRAL"  Then Response.Write("selected") %>>Semestral  </option>
														<option value="ANUAL"      <% If GetValue(objRS, "FREQUENCIA") = "ANUAL"      Then Response.Write("selected") %>>Anual      </option>
													</select>
		<br><div class="form_label">*Dt Vcto 1� Parcela:</div><input name="var_dt_base_vcto" value="" type="text" maxlength="10" style="width:70px;" onKeyPress="Javascript:validateNumKey();" onKeyUp="Javascript:FormataInputData(this.form.name, this.name); " onBlur="Javascript:addInputsParcela(document.getElementsByName('var_num_parcela_ref')[0].value);">&nbsp;<%=ShowLinkCalendario("form_insert", "var_dt_base_vcto", "ver calend�rio")%>&nbsp;<span class="texto_ajuda">dd/mm/aaaa</span>
			<br><div class="form_label">*Valor Parcela(Ref.):</div><input name="var_vlr_parcela_ref" value="<%=FormataDecimal(GetValue(objRS, "VLR_PARCELA"),2)%>" type="text" maxlength="10" style="width:70px;" onKeyPress="validateFloatKey();">		
			<br><div class="form_label">*Num. de Parcelas:</div><input name="var_num_parcela_ref" type="text" value="<%=GetValue(objRS, "NUM_PARC")%>" maxlength="10" style="width:70px;" onKeyPress="validateFloatKey();"><a href="Javascript:addInputsParcela(document.getElementsByName('var_num_parcela_ref')[0].value);"><img src="../img/BtGerarParcelas.gif" title="Gerar parcelas" alt="Gerar parcelas" border="0" style="vertical-align:top; padding-top:4px" vspace="0" hspace="0"></a>&nbsp;<span class="texto_ajuda">Obrigat�rio gerar pelo menos uma parcela</span>
	</div>		

	<br><div class="form_label"></div>---------------------------------------------------------------------------------------------
	<br><div class="form_label" style="height:18px;"></div><span style="padding-left:5px;">Num. Parc.</span><span style="padding-left:15px;">Valor. Parcela</span><span style="padding-left:110px;">Dt. Venc.</span>
	<br><div class="form_label"></div><div class="form_line" style="padding-left:110px;"><table style="border:0px solid #CCCCCC;"><tr><td><span id='eldinparcela1'></span></td><td><span id='eldinparcela2'></span></td><td><span id='eldinparcela3'></span></td><td><span id='eldinparcela4'></span></td><td><span id='eldinparcela5'></span></td></tr></table></div>			
	<div class="form_label"></div>OBS: As Parcelas com valor zero n�o ir�o gerar T�tulo no processamento.	
	<br>	
	<%
	    'Monta as parcelas, baseadas no contrato anterior
		strSQL = ""
		strSQL =          "SELECT VLR_PARCELA, DT_VENC "
		strSQL = strSQL & "  FROM CONTRATO_PARCELA "
		strSQL = strSQL & " WHERE COD_CONTRATO = "  & strCODIGO
		strSQL = strSQL & " ORDER BY DT_VENC "	
		
		'athDebug strSQL false		
				
		AbreRecordSet lcObjRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1				
						
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
				response.write(" eval('document.form_insert.var_vlr_parcela_' + CIDInputParcela + '.value =  ' + " & "'\'"& FormataDecimal(GetValue(lcObjRS, "VLR_PARCELA"),2) & "\''" & "); " & vbNewLine)				
				response.write(" eval('document.form_insert.var_dt_venc_parcela_' + CIDInputParcela + '.value =  ' + " & "'\'"& PrepData(GetValue(lcObjRS, "DT_VENC"), True, False) & "\''" & "); " & vbNewLine)								
				response.write(" updDiaSemana('var_dia_semana_parcela_' + CIDInputParcela, document.getElementById('var_dt_venc_parcela_' + CIDInputParcela).value);")  	  	
     		    athMoveNext lcObjRS, ContFlush, CFG_FLUSH_LIMIT
			loop 
			response.write ("</script>" & vbNewLIne)
		End If
		FechaRecordSet lcObjRS		
	%>		
	
	<br><div class="form_label">Tipo Reajuste:</div><select name="var_tp_reajuste" size="1" style="width:100px;">
														<option value="" selected>[selecione]</option>
														<option value="DIARIA"    >Di�rio    </option>
														<option value="SEMANAL"   >Semanal   </option>
														<option value="QUINZENAL" >Quinzenal </option>
														<option value="MENSAL"    >Mensal    </option>
														<option value="BIMESTRAL" >Bimestral </option>
														<option value="TRIMESTRAL">Trimestral</option>
														<option value="SEMESTRAL" >Semestral </option>
														<option value="ANUAL"     >Anual     </option>
													</select>	
	<span class="texto_ajuda">Alerta de Reajuste de acordo com a Dt Ini do Contrato</span>														
	
	<br><div class="form_label">Tipo:</div><select name="var_tp_renovacao" size="1" style="width:120px;">
												<option value="RENOVAVEL"    selected>Renov�vel</option>
												<option value="NAO_RENOVAVEL">N�o Renov�vel</option>
											</select>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "", "")%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>
<%
		End If
		FechaRecordSet objRS
	End If
	FechaDBConn objConn
%>
