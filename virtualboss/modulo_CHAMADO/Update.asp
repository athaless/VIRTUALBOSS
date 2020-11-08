<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_CHAMADO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

Dim strSQL, objRS, ObjConn, Cont
Dim strCODIGO, strRESP 
Dim strArquivo,strArquivoAnexo, strDESCRICAO, strSIGILOSO
Dim strPREV_HORAS_HH, strPREV_HORAS_MM
Dim strCFG_TD, aux, auxHS, acHORAS, strResposta, bFechar
Dim strPREV_HR_INI, strPREV_HR_INI_hora, strPREV_HR_INI_min
Dim strVALOR, strCOD_CLI

strCODIGO = GetParam("var_chavereg")

strCFG_TD = "align='left' valign='top' nowrap"

AbreDBConn objConn, CFG_DB

strSQL =          " SELECT TITULO, COD_CATEGORIA, PRIORIDADE, DESCRICAO "
strSQL = strSQL & "      , SIGILOSO, ARQUIVO_ANEXO, SYS_ID_USUARIO_INS "
strSQL = strSQL & " FROM CH_CHAMADO WHERE COD_CHAMADO = " & strCODIGO

Set objRS = objConn.Execute(strSQL)

If Not objRS.Eof Then
	strDESCRICAO = Replace(GetValue(objRS, "DESCRICAO"),"<ASLW_APOSTROFE>","'")
	strSIGILOSO  = Replace(GetValue(objRS, "SIGILOSO"),"<ASLW_APOSTROFE>","'")
	
	strDESCRICAO = Replace(strDESCRICAO, "''", "'")
	strSIGILOSO  = Replace(strSIGILOSO, "''", "'")
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
function BuscaEntidade() {
	if ((document.form_update.var_cod_cli.value != '') && (document.form_update.var_cli_nome.value == ''))
		AbreJanelaPAGE('BuscaEntidadeUm.asp?var_chavereg=' + document.form_update.var_cod_cli.value + '&var_form=form_update&var_input1=var_cod_cli&var_input2=var_cli_nome','300','200');
	else
		AbreJanelaPAGE('BuscaPorEntidade.asp?var_form=form_update&var_input1=var_cod_cli&var_input2=var_cli_nome','640','390');
}

function LimparNome() {
	document.form_update.var_cli_nome.value = '';
}

//****** Funções de ação dos botões - Início ******
function ok() 		{ document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_update.var_titulo.value == '') var_msg += '\nTítulo';
	if (document.form_update.var_cod_categoria.value == '') var_msg += '\nCategoria';
	if (document.form_update.var_prioridade.value == '') var_msg += '\nPrioridade';
	if (document.form_update.var_descricao.value == '') var_msg += '\nDescrição';
	
	if (var_msg == ''){
		document.form_update.submit();
	} else{
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
	}
}
//****** Funções de ação dos botões - Fim ******
//****** Funções de inserção de anexos - Inicio ******
var CIDInputAnexo=0, QtdeInputAnexo=0;

function addInputAnexo(prPai,prNomeElemento,prTpElemento, prStyle, prAction, prValue) 
{		
  var newFormObj;
  var ParentElem = document.getElementById(prPai);

  if (prTpElemento=="image") {
    newFormObj = document.createElement('img');
	newFormObj.setAttribute("id"		,prNomeElemento);
  	newFormObj.setAttribute("name"		,prNomeElemento);
	newFormObj.setAttribute("src"		,"../img/IconAction_DEL.gif");
  	newFormObj.setAttribute("style"		,prStyle);
	newFormObj.setAttribute("vspace"	,"4");
	newFormObj.setAttribute("onclick"	,prAction);
  } else {
	newFormObj = document.createElement('input');
	newFormObj.setAttribute("id"		,prNomeElemento);
  	newFormObj.setAttribute("name"		,prNomeElemento);
  	
	if (prTpElemento=="text_readonly") {
	  newFormObj.setAttribute("type","text");
	  newFormObj.setAttribute("readonly","true");
	} 
	else {newFormObj.setAttribute("type",prTpElemento);}
		
  	newFormObj.setAttribute("maxlength"	,250);
  	newFormObj.setAttribute("style"		,prStyle);
	newFormObj.setAttribute("value"		,prValue);    
  }

  //DEBUG
  //newInput.setAttribute("value", prNomeElemento);
  ParentElem.appendChild(newFormObj);

  document.form_update.QTDE_INPUTS_ANEXO.value = QtdeInputAnexo;
  //alert(QtdeInputAnexo);  
}

function delInputAnexo(prCIDInput) {
  /*
  var ParentElem, newFormObj;
  
  ParentElem = document.getElementById('eldinanexo1');
  newFormObj = document.getElementById('var_ianexo_' + prCIDInput);
  ParentElem.removeChild(newFormObj);

  ParentElem = document.getElementById('eldinanexo2');
  newFormObj = document.getElementById('var_anexo_' + prCIDInput);
  ParentElem.removeChild(newFormObj);

  ParentElem = document.getElementById('eldinanexo3');
  newFormObj = document.getElementById('var_anexodesc_' + prCIDInput);
  ParentElem.removeChild(newFormObj);
  */
  
  /*Passamos a deixar os elementos invisíveis ao invés de apagá-los, 
  pois dependendo do elemento que fosse apagado ocorriam problemas ao salvar. 
  By Lumertz 14/02/2013.*/
  var newFormObj;
  newFormObj = document.getElementById('var_ianexo_' + prCIDInput);
  newFormObj.style.display = 'none';
  newFormObj = document.getElementById('var_anexo_' + prCIDInput);
  newFormObj.style.display = 'none';  
  newFormObj.value = '';
  newFormObj = document.getElementById('var_anexodesc_' + prCIDInput);
  newFormObj.style.display = 'none';  
  newFormObj.value = '';  
  
  //document.form_update.QTDE_INPUTS_ANEXO.value = QtdeInputAnexo;  
}
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Chamado - Altera&ccedil;&atilde;o")%>
<form name="form_update" action="update_exec.asp" method="post">
	<input name="var_chavereg" type="hidden" value="<%=strCODIGO%>">
	<input type="hidden" name="JSCRIPT_ACTION" value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value="Update.asp?var_chavereg=<%=strCODIGO%>">
    <input type="hidden" name="QTDE_INPUTS_ANEXO" value='0'>	
	<div class="form_label">Cod:</div><div class="form_bypass"><%=strCODIGO%></div>
	<br><div class="form_label">*Título:</div><input name="var_titulo" type="text" style="width:280px;" value="<%=GetValue(objRS, "TITULO")%>">
	<br><div class="form_label">*Categoria:</div><select name="var_cod_categoria" style="width:100px;">
		<option value="" selected="selected">[selecione]</option>
			<%=montaCombo("STR","SELECT COD_CATEGORIA, NOME FROM CH_CATEGORIA ORDER BY NOME ","COD_CATEGORIA","NOME",GetValue(objRS, "COD_CATEGORIA"))%>
		</select>
	<br><div class="form_label">*Prioridade:</div><select name="var_prioridade" style="width:100px;">
				<option value="NORMAL" <% If GetValue(objRS, "PRIORIDADE") = "NORMAL" Then Response.Write("selected='selected'") %>>NORMAL</option>
				<option value="BAIXA" <% If GetValue(objRS, "PRIORIDADE") = "BAIXA" Then Response.Write("selected='selected'") %>>BAIXA</option>
				<option value="MEDIA" <% If GetValue(objRS, "PRIORIDADE") = "MEDIA" Then Response.Write("selected='selected'") %>>MÉDIA</option>
				<option value="ALTA" <% If GetValue(objRS, "PRIORIDADE") = "ALTA" Then Response.Write("selected='selected'") %>>ALTA</option>
			</select>
	<br><div class="form_label">*Descrição:</div><textarea name="var_descricao" style="width:320px; height:140px;"><%=strDESCRICAO%></textarea>
	<br><div class="form_label">Sigiloso:</div><% If LCase(GetValue(objRS, "SYS_ID_USUARIO_INS")) = LCase(Request.Cookies("VBOSS")("ID_USUARIO")) Then %><textarea name="var_sigiloso" style="width:320px; height:80px;"><%=strSIGILOSO%></textarea>
			<div style="padding-left:110px;"><span class="texto_ajuda">Informe aqui dados sigilosos para o chamado.<br />Serão visualizados pela equipe que for atendê-lo.</span></div>
		<% Else %>
			<div class="form_bypass">**************</div>
		<% End If %>
	<br><div class="form_label">Anexo Principal:</div><input name="var_arquivo_anexo" type="text" readonly="readonly" maxlength="250" value="<%=GetValue(objRS, "ARQUIVO_ANEXO")%>" style="width:122px;"><a href="javascript:UploadArquivo('form_update','var_arquivo_anexo', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>//TODO_Anexos');"><img src="../img/BtUpload.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a><span class="texto_ajuda">&nbsp; Anexo principal do chamado.</span>
	<br><div class="form_label">Outros Anexos:</div><a href="javascript:CIDInputAnexo++; QtdeInputAnexo++;
								addInputAnexo('eldinanexo1','var_ianexo_'+CIDInputAnexo   ,'image'       ,'height:14px; border:0px; cursor:pointer;', 'delInputAnexo('+CIDInputAnexo+');'); 
								addInputAnexo('eldinanexo2','var_anexo_'+CIDInputAnexo    ,'text_readonly','width:110px;', '',''); 
								addInputAnexo('eldinanexo3','var_anexodesc_'+CIDInputAnexo,'text'     ,'width:200px;', '','');
								UploadArquivo('form_update','var_anexo_'+CIDInputAnexo, 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>//TODO_Anexos'); 
								"><img src="../img/BtUpload.gif" title="Buscar arquivo" alt="Buscar arquivo" border="0" style="vertical-align:top; padding-top:2px" vspace="0" hspace="0"></a><span class="texto_ajuda">&nbsp; Demais anexos do chamado.</span>
	<br><div class="form_label"></div>-----------------------------------------------------------------------------------
	<br><div class="form_label" style="height:18px;"></div><span style="padding-left:25px;">Arquivo</span><span style="padding-left:80px;">Descrição</span>
	<br><div class="form_label"></div><div class="form_line" style="padding-left:110px;"><table style="border:0px solid #CCCCCC;"><tr><td><span id='eldinanexo1'></span></td><td><span id='eldinanexo2'></span></td><td><span id='eldinanexo3'></span></td></tr></table></div>
<%			
		FechaRecordSet objRS
		strSQL = " SELECT ARQUIVO, DESCRICAO FROM CH_ANEXO WHERE COD_CHAMADO = " & strCODIGO 
	  	AbreRecordSet ObjRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1

		if not ObjRS.eof then 
			response.write ("<script language='javascript' type='text/javascript'>" & vbNewLIne)
			do while not ObjRS.Eof
			  response.write (" CIDInputAnexo++; QtdeInputAnexo++;")
			  response.write (" addInputAnexo('eldinanexo1','var_ianexo_'   +CIDInputAnexo ,'image','height:14px; border:0px; cursor:pointer;', ' delInputAnexo('+CIDInputAnexo+');', ''); " & vbNewLIne)
			  response.write (" addInputAnexo('eldinanexo2','var_anexo_'    +CIDInputAnexo ,'text_readonly' ,'width:110px;', '','"&GetValue(ObjRS, "ARQUIVO")&"');"	& vbNewLIne) 
			  response.write (" addInputAnexo('eldinanexo3','var_anexodesc_'+CIDInputAnexo ,'text' ,'width:200px;', '','" & replace(GetValue(ObjRS, "DESCRICAO"),vbNewLIne,"") & "');"	& vbNewLIne	& vbNewLIne)
			  athMoveNext ObjRS, ContFlush, CFG_FLUSH_LIMIT
			loop 
			  response.write ("</script>" & vbNewLIne)
		end if
%>			
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
</body>
</html>
<%
end if

FechaRecordSet objRS
FechaDBConn objConn
%>