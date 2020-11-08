<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_TODOLIST", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

 Dim strSQL, objRS, objRSAux, ObjConn
 Dim Cont, strVALOR, strCODIGO, strEMPRESAOld, strEMPRESANew
 
 strCODIGO = GetParam("var_chavereg")

 AbreDBConn objConn, CFG_DB
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script>
//****** Funções de ação dos botões - Início ******
function ok()			{ document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar()		{ parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()      { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_insert.var_titulo.value == '') var_msg += '\nTítulo';
	if (document.form_insert.var_situacao.value == '') var_msg += '\nSituação';
	if (document.form_insert.var_cod_e_desc_categoria.value == '') var_msg += '\nCategoria';
	if (document.form_insert.var_prioridade.value == '') var_msg += '\nPrioridade';
	if ((document.form_insert.var_id_responsavel.value == 'selecione') || (document.form_insert.var_id_responsavel.value == '')) var_msg += '\nResponsável';
	if ((document.form_insert.var_id_executor.value == 'selecione') || (document.form_insert.var_id_executor.value == '')) var_msg += '\nExecutor';
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
	document.form_insert.var_cli_nome.value = '';
}

var CIDInput=0, QtdeInput=0;

function addInput(prPai,prNomeElemento,prTpElemento, prStyle, prAction) 
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
  	newFormObj.setAttribute("type"		,prTpElemento);
  	newFormObj.setAttribute("maxlength"	,250);
  	newFormObj.setAttribute("style"		,prStyle);
  }

  //DEBUG
  //newInput.setAttribute("value", prNomeElemento);
  ParentElem.appendChild(newFormObj);

  document.form_insert.QTDE_INPUTS.value = QtdeInput;
}

function delInput(prCIDInput) {
  var ParentElem, newFormObj;
  
  ParentElem = document.getElementById('eldin1');
  newFormObj = document.getElementById('var_ianexo_' + prCIDInput);
  ParentElem.removeChild(newFormObj);

  ParentElem = document.getElementById('eldin2');
  newFormObj = document.getElementById('var_anexo_' + prCIDInput);
  ParentElem.removeChild(newFormObj);

  ParentElem = document.getElementById('eldin3');
  newFormObj = document.getElementById('var_anexodesc_' + prCIDInput);
  ParentElem.removeChild(newFormObj);
  
  document.form_insert.QTDE_INPUTS.value = QtdeInput;
}

</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "ToDo List - Inser&ccedil;&atilde;o")%>
<form name="form_insert" id="form_insert" action="../modulo_TODOLIST/insert_exec.asp" method="post">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
		<input type="hidden" name="QTDE_INPUTS" value='0'>
	<% if(strCODIGO <> "") then %>
		<input type="hidden" name="DEFAULT_LOCATION" value='insert.asp?var_chavereg=<%=strCODIGO%>'>
	<% else %>
		<input type="hidden" name="DEFAULT_LOCATION" value='insert.asp'>
	<% end if %>
	<% if(strCODIGO <> "") then %>
		<input type="hidden" name="var_boletim"  value="<%=strCODIGO%>" />
	<% end if %>
	<% if(strCODIGO <> "") then %>
	<div class="form_label">Cod. Boletim:</div><div class="form_bypass"><%=strCODIGO%></div><br>
	<% end if %>
	<div class="form_label">*Título:</div><input name="var_titulo" type="text" style="width:300px;">
	<br><div class="form_label">*Situação:</div><select name="var_situacao" style="width:100px;">
				<option value="ABERTO" selected>ABERTO</option>
				<option value="OCULTO">OCULTO</option>
			</select>
	<br><div class="form_label">*Categoria:</div><select name="var_cod_e_desc_categoria" style="width:100px;">
				<option value="" selected>[selecione]</option>
				<%
				strSQL = " SELECT COD_CATEGORIA, NOME FROM TL_CATEGORIA WHERE DT_INATIVO IS NULL AND NOME <> 'CHAMADO' ORDER BY NOME "
				Set objRSAux = objConn.Execute(strSQL)
				
				Do While Not objRSAux.Eof
					Response.Write("<option value='" & GetValue(objRSAux,"COD_CATEGORIA") & " - " & GetValue(objRSAux,"NOME") & "'>")
					Response.Write(GetValue(objRSAux,"NOME") & "</option>")
					
					objRSAux.MoveNext
				Loop
				FechaRecordSet objRSAux
				%>
				</select>
	<br><div class="form_label">*Prioridade:</div><select name="var_prioridade" style="width:100px;">
				<option value="NORMAL" selected>NORMAL</option>
				<option value="BAIXA">BAIXA</option>
				<option value="MEDIA">MÉDIA</option>
				<option value="ALTA">ALTA</option>
			</select>
	<%
    'Traz apenas os usuários da mesma entidade do usuário logado.
	strSQL = " SELECT TIPO,CODIGO FROM USUARIO WHERE ID_USUARIO = '" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "'" 

	Set objRS = objConn.Execute(strSQL)
	
	if GetValue(objRS,"TIPO") = "ENT_COLABORADOR" Then
	    strSQL = "SELECT US.ID_USUARIO FROM USUARIO US WHERE US.TIPO = 'ENT_COLABORADOR' AND US.DT_INATIVO IS NULL  ORDER BY US.ID_USUARIO"	
    else
		strSQL = "SELECT US.ID_USUARIO FROM USUARIO US ," & _
						 GetValue(objRS,"TIPO") & " ENT " & _
				  "WHERE US.CODIGO = ENT.COD_" & Mid(GetValue(objRS,"TIPO"), 5, (Len(GetValue(objRS,"TIPO")) -4)) & _
				  " AND US.CODIGO = " & GetValue(objRS,"CODIGO") & _
				  "	AND US.DT_INATIVO IS NULL" & _ 
				  " ORDER BY US.ID_USUARIO"
	End If			

	FechaRecordSet objRS	
	%>		
	<br><div class="form_label">*Responsável:</div><select name="var_id_responsavel" style="width:100px;">
				<option value="">[selecione]</option>
				<%=montaCombo("STR",strSQL,"ID_USUARIO","ID_USUARIO",LCase(Request.Cookies("VBOSS")("ID_USUARIO")))%> 				
			</select>
	<br><div class="form_label">*Executor:</div><select name="var_id_executor" size="1" style="width:100px;">
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
				  if StrEMPRESAOld <> StrEMPRESANew Then
				     if StrEMPRESAOld <> "" then
   				       Response.write("</optgroup>")
					 End If  
				     Response.write("<optgroup label = '" & StrEMPRESANew & "'>")
					 StrEMPRESAOld = StrEMPRESANew
				  End If		  
    	  		  Response.write("<option value= '"& GetValue(objRS,"ID_USUARIO") & "'>" & GetValue(objRS,"ID_USUARIO") & "</option>")	  				
				  				
				  objRS.MoveNext
				Loop
				FechaRecordSet objRS
				%>				
			</select> 
	<br><div class="form_label">Prev. In&iacute;cio:</div><%=InputDate("VAR_PREV_DT_INI","",Day(NOW)&"/"&Month(NOW)&"/"&Year(NOW),false)%>&nbsp;<%=ShowLinkCalendario("form_insert", "VAR_PREV_DT_INI", "ver calendário")%><select name="var_prev_hr_ini_hora" size="1" style="width:40px">
				<option value="" selected="selected"></option>
				<% 
				For Cont = 0 to 23
					If Cont < 10 Then strVALOR = CStr("0" & Cont) Else strVALOR = CStr(Cont) End If
					Response.Write("<option value='" & strVALOR & "'>" & strVALOR & "</option>")
				Next
				%>
			</select>
			<select name="var_prev_hr_ini_min" size="1" style="width:60px;">
				<option value="" selected="selected"></option>
				<%
				Cont = 0
				Do While (Cont <= 55)
					If Cont < 10 Then strVALOR = CStr("0" & Cont) Else strVALOR = CStr(Cont) End If
					Response.Write("<option value='" & strVALOR & "'>" & strVALOR & " min</option>")
					Cont = Cont + 5
				Loop
				%>
			</select>&nbsp;<span class="texto_ajuda">&nbsp;<i>dd/mm/aaaa hh:mm</i></span>
		<br><div class="form_label">Prev. Horas:</div><input name="var_prev_horas" type="text" style="width:40px;" maxlength="5" value="" onKeyPress="validateNumKey();">&nbsp;h&nbsp;
			<select name="var_prev_minutos" style="width:70px;">
				<option value="00" selected>00 min</option>
				<option value="25">15 min</option>
				<option value="50">30 min</option>
				<option value="75">45 min</option>
			</select>&nbsp;Documento:<input name="var_arquivo_anexo" type="text" maxlength="250" value="" style="width:110px;"><a href="javascript:UploadArquivo('form_insert','var_arquivo_anexo', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>//TODO_Anexos');"><img src="../img/BtUpload.gif" title="Buscar arquivo" alt="Buscar arquivo" border="0" style="vertical-align:top; padding-top:2px" vspace="0" hspace="0"></a>
		<br><div class="form_label">*Descrição:</div><textarea name="var_descricao" style="width:350px; height:160px;"></textarea>
		<div class="form_label">Cliente:</div><input name="var_cod_cli" type="text" style="width:30px;" value="" onChange="LimparNome();" onKeyPress="validateNumKey();" maxlength="5"><input name="var_cli_nome" type="text" style="width:240px;" value="" readonly><a href="Javascript:void(0);" onClick="Javascript:BuscaEntidade();"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
		<div style="padding-left:110px;"><span class="texto_ajuda"><i>Permite associar um CLIENTE a esta TAREFA.</i></span></div>
		<br><div class="form_label">Anexos:</div><a href="javascript:CIDInput++; QtdeInput++;
									addInput('eldin1','var_ianexo_'+CIDInput,'image','height:14px; border:0px; cursor:pointer;', 'QtdeInput--; delInput('+CIDInput+');'); 
									addInput('eldin2','var_anexo_'+CIDInput,'text','width:110px;', ''); 
									addInput('eldin3','var_anexodesc_'+CIDInput,'text','width:200px;', '');
									UploadArquivo('form_insert','var_anexo_'+CIDInput, 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>//TODO_Anexos'); 
									"><img src="../img/BtUpload.gif" title="Buscar arquivo" alt="Buscar arquivo" border="0" style="vertical-align:top; padding-top:2px" vspace="0" hspace="0"></a>
		<br><div class="form_label"></div>-----------------------------------------------------------------------------------
		<br><div class="form_label" style="height:18px;"></div><span style="padding-left:25px;">Arquivo</span><span style="padding-left:80px;">Descrição</span>
		<br><div class="form_label"></div><div class="form_line" style="padding-left:110px;"><table style="border:0px solid #CCCCCC;"><tr><td><span id='eldin1'></span></td><td><span id='eldin2'></span></td><td><span id='eldin3'></span></td></tr></table></div>	
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>
<%
FechaDBConn objConn
%>