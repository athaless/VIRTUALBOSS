<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_CHAMADO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%

Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

Dim objConn , objRS, strSQL
Dim strCOD_CLI, strCLI_NOME, strTIPO_CHAMADO, strEXTRA
Dim strEMPRESAOld, strEMPRESANew, StrID_USUARIO

AbreDBConn objConn, CFG_DB

strEXTRA = Mid(CStr(Request.Cookies("VBOSS")("EXTRA") & ""),1,25)

strSQL =          " SELECT T2.COD_CLIENTE, T2.NOME_FANTASIA, T2.TIPO_CHAMADO "
strSQL = strSQL & " FROM USUARIO T1, ENT_CLIENTE T2 "
strSQL = strSQL & " WHERE T1.TIPO LIKE 'ENT_CLIENTE' "
strSQL = strSQL & " AND T1.ID_USUARIO LIKE '" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "' "
strSQL = strSQL & " AND T1.CODIGO = T2.COD_CLIENTE "

strCOD_CLI = ""
strCLI_NOME = ""
strTIPO_CHAMADO = "LIVRE"
Set objRS = objConn.Execute(strSQL)
If Not objRS.Eof Then
	strCOD_CLI = GetValue(objRS, "COD_CLIENTE")
	strCLI_NOME = GetValue(objRS, "NOME_FANTASIA")
	strTIPO_CHAMADO = GetValue(objRS, "TIPO_CHAMADO")
End If
FechaRecordSet objRS

'Depois teremos de colocar um COMBO de clientes, ou EDIT com botão de pesquisa
'para poder escolher o cliente. Esse recurso será usado por usuários MANAGER/SU

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
function submeterForm() {
	var var_msg = '';
	
	if (document.form_insert.var_solicitante.value == '') var_msg += '\nSolicitante';
	if (document.form_insert.var_cod_cli.value == '') var_msg += '\nCliente';
	if (document.form_insert.var_titulo.value == '') var_msg += '\nTítulo';
	if (document.form_insert.var_cod_categoria.value == '') var_msg += '\nCategoria';
	if (document.form_insert.var_prioridade.value == '') var_msg += '\nPrioridade';
	if (document.form_insert.var_descricao.value == '') var_msg += '\nDescrição';
	
	if (var_msg == ''){
		document.form_insert.submit();
	} else{
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
	}
}
//****** Funções de ação dos botões - Fim ******
function BuscaEntidade() {
	if ((document.form_insert.var_cod_cli.value != '') && (document.form_insert.var_cli_nome.value == ''))
		AbreJanelaPAGE('BuscaEntidadeUm.asp?var_chavereg=' + document.form_insert.var_cod_cli.value + '&var_form=form_insert&var_input1=var_cod_cli&var_input2=var_cli_nome','300','200');
	else
		AbreJanelaPAGE('BuscaPorEntidade.asp?var_form=form_insert&var_input1=var_cod_cli&var_input2=var_cli_nome','640','390');
}

function LimparNome() {
	document.form_update.var_cli_nome.value = '';
}


var CIDInput=0, QtdeInput=0;

function addInput(prPai,prNomeElemento,prTpElemento, prStyle, prAction) 
{		
  var newFormObj;
  var ParentElem = document.getElementById(prPai);

  if (prTpElemento=="image") {
    newFormObj = document.createElement('img');
	newFormObj.setAttribute("src"		,"../img/IconAction_DEL.gif");
	newFormObj.setAttribute("vspace"	,"4");
	newFormObj.setAttribute("onclick"	,prAction);
  }	else {
	newFormObj = document.createElement('input');
	if (prTpElemento=="text_readonly") {
		newFormObj.setAttribute("type","text");
		newFormObj.setAttribute("readonly","true");
  	}else{	newFormObj.setAttribute("type",prTpElemento);}	  
  	newFormObj.setAttribute("maxlength"	,250);
  }
  
  newFormObj.setAttribute("id"	  ,prNomeElemento);  
  newFormObj.setAttribute("name"  ,prNomeElemento);	
  newFormObj.setAttribute("style" ,prStyle);	

  //DEBUG
  //newInput.setAttribute("value", prNomeElemento);
  ParentElem.appendChild(newFormObj);

  document.form_insert.QTDE_INPUTS.value = QtdeInput;
}

function delInput(prCIDInput) {
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
  document.form_update.QTDE_INPUTS_ANEXO.value = QtdeInputAnexo;    
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
}

</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Chamado - Inser&ccedil;&atilde;o") %>
<form name="form_insert" action="Insert_Exec.asp" method="post">
	<input name="var_solicitante" type="hidden" value="<%=LCase(Request.Cookies("VBOSS")("ID_USUARIO"))%>" />
	<input type="hidden" name="JSCRIPT_ACTION" value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_CHAMADO/insert.asp'>
	<input type="hidden" name="QTDE_INPUTS" value='0'>
	<% If strCOD_CLI <> "" Then %>
		<input name="var_cod_cli" type="hidden" value="<%=strCOD_CLI%>" /><input name="var_cli_nome" type="hidden" value="<%=strCLI_NOME%>" />
		<input name="var_tipo_chamado" type="hidden" value="<%=strTIPO_CHAMADO%>">
		<div class="form_label">Cliente:</div><div class="form_bypass"><%=strCOD_CLI%> - <%=strCLI_NOME%></div>
	<% Else %>
		<div class="form_label">*Cliente:</div><input name="var_cod_cli" type="text" style="width:30px;" value="<%=strCOD_CLI%>" onChange="LimparNome();" onKeyPress="validateNumKey();" maxlength="5"><input name="var_cli_nome" type="text" style="width:240px;" value="<%=strCLI_NOME%>" readonly><a href="Javascript:void(0);" onClick="Javascript:BuscaEntidade();"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
	<% End If %>
	<br><div class="form_label">*Título:</div><input name="var_titulo" type="text" style="width:310px;" value="">
	<br><div class="form_label">*Categoria:</div><select name="var_cod_categoria" style="width:100px;">
		<%
		strSQL = " SELECT COD_CATEGORIA, NOME FROM CH_CATEGORIA ORDER BY NOME "
		Set objRS = objConn.Execute(strSQL)
		
		Do While Not objRS.Eof 
			Response.Write("<option value='" & GetValue(objRS, "COD_CATEGORIA") & "'")
			If UCase(GetValue(objRS, "NOME")) = "GERAL" Then Response.Write(" selected='selected'")
			Response.Write(">" & GetValue(objRS, "NOME") & "</option>")
			
			objRS.MoveNext
		Loop
		FechaRecordSet objRS
		%>
		</select>
	<br><div class="form_label">Prioridade:</div><select name="var_prioridade" style="width:100px;">
		<option value="NORMAL" selected>NORMAL</option>
		<option value="BAIXA">BAIXA</option>
		<option value="MEDIA">MÉDIA</option>
		<option value="ALTA">ALTA</option>
	</select> 
	<br><div class="form_label">*Descrição:</div><textarea name="var_descricao" rows="10" style="width:340px;"></textarea>
	<br><div class="form_label">Sigiloso:</div><textarea name="var_sigiloso" rows="4" style="width:340px;"></textarea>
	<div style="padding-left:110px;"><span class="texto_ajuda"><i>Informe aqui dados sigilosos para o chamado.<br />Serão visualizados apenas pela equipe que for atendê-lo.</i></span></div>
	<br><div class="form_label"></div><input name="var_extra" type="text" style="width:120px;" value="<%=strEXTRA%>" readonly="readonly" maxlength="25"><span class="texto_ajuda">Identificação externa (sistema).</span>
	<% If(Request.Cookies("VBOSS")("GRUPO_USUARIO") <> "CLIENTE") Then %>

		<br><div class="form_label">Solicitante:</div><select name="var_id_resp" size="1" style="width:100px;">
					<option value="">[selecione]</option>
					<%
					'Separa os clientes dos colaboradores, mas os mantêm ordenados por nome.
					strSQL = "SELECT US.ID_USUARIO " & _
							 "      ,CAST((COALESCE((SELECT CONCAT(NOME_FANTASIA,' (',COD_CLIENTE,')')    FROM ENT_CLIENTE    WHERE COD_CLIENTE    = US.CODIGO)  " & _
							 "                     ,(SELECT CONCAT(NOME_FANTASIA,' (',COD_FORNECEDOR,')') FROM ENT_FORNECEDOR WHERE COD_FORNECEDOR = US.CODIGO)) " & _
							 "             ) AS CHAR(260)) AS EMPRESA " & _
							 "      ,1 " & _
							 " FROM USUARIO US " & _
							 "WHERE US.DT_INATIVO IS NULL " & _
							 "  AND US.TIPO <> 'ENT_COLABORADOR' " & _    
							 "UNION " & _
							 "SELECT ID_USUARIO " & _
							 "      ,CAST('COLABORADOR' AS CHAR(260)) " & _
							 "	    ,2 " & _
							 " FROM USUARIO " & _
							 "WHERE DT_INATIVO IS NULL " & _
							 "  AND TIPO = 'ENT_COLABORADOR' " & _        
							 "ORDER BY 3,2,1 " 						 
					Set objRS = objConn.Execute(strSQL)						 							
					StrEMPRESAOld = ""
					StrEMPRESANew = ""
					Do While Not objRS.Eof
					  StrEMPRESANew = GetValue(objRS,"EMPRESA")							
					  StrID_USUARIO = GetValue(objRS,"ID_USUARIO") 				  
					  if StrEMPRESAOld <> StrEMPRESANew Then
						 if StrEMPRESAOld <> "" then
						   Response.write("</optgroup>")
						 End If  
						 Response.write("<optgroup label = '" & StrEMPRESANew & "'>")
						 StrEMPRESAOld = StrEMPRESANew
					  End If		  
					  
					  If (LCase(Request.Cookies("VBOSS")("ID_USUARIO")) = StrID_USUARIO) Then
						Response.write("<option value= '"& StrID_USUARIO & "'selected>" & StrID_USUARIO & "</option>")	  								  
					  Else 
						Response.write("<option value= '"& StrID_USUARIO & "'>" & StrID_USUARIO & "</option>")	  				
					  End If	
									
					  objRS.MoveNext
					Loop
					FechaRecordSet objRS
					%>				
				</select><span class="texto_ajuda">Usuário de Inserção do Chamado.</span> 	
	<%End If%>	
	<br><div class="form_label">Anexo Principal:</div><input name="var_arquivo_anexo" type="text" readonly="readonly" maxlength="250" value="" style="width:160px;"><a href="javascript:UploadArquivo('form_insert','var_arquivo_anexo', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>//TODO_Anexos');"><img src="../img/BtUpload.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a><span class="texto_ajuda">&nbsp; Anexo principal do chamado.</span>		
	<br><div class="form_label">Outros Anexos:</div><a href="javascript:CIDInput++; QtdeInput++;
								addInput('eldinanexo1','var_ianexo_'+CIDInput,'image'       ,'height:14px; border:0px; cursor:pointer;', 'delInput('+CIDInput+');'); 
								addInput('eldinanexo2','var_anexo_'+CIDInput,'text_readonly','width:110px;', ''); 
								addInput('eldinanexo3','var_anexodesc_'+CIDInput            ,'text','width:200px;', '');
								UploadArquivo('form_insert','var_anexo_'+CIDInput, 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>//TODO_Anexos'); 
								"><img src="../img/BtUpload.gif" title="Buscar arquivo" alt="Buscar arquivo" border="0" style="vertical-align:top; padding-top:2px" vspace="0" hspace="0"></a><span class="texto_ajuda">&nbsp; Demais anexos do chamado.</span>
	<br><div class="form_label"></div>-----------------------------------------------------------------------------------
	<br><div class="form_label" style="height:18px;"></div><span style="padding-left:25px;">Arquivo</span><span style="padding-left:80px;">Descrição</span>
	<br><div class="form_label"></div><div class="form_line" style="padding-left:110px;"><table style="border:0px solid #CCCCCC;"><tr><td><span id='eldinanexo1'></span></td><td><span id='eldinanexo2'></span></td><td><span id='eldinanexo3'></span></td></tr></table></div>	
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>
<%
FechaDBConn objConn
%>
