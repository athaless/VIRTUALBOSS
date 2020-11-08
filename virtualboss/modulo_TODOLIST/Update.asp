<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_TODOLIST", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
	function MontaSQLCombo
		Dim strSQL
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
        MontaSQLCombo = StrSQL				  		   
	end function
%>	

<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"
 'Constantes das colunas do SQL de montagem dos combos de responsável e executor.
 Const ID_USUARIO = 0
 Const EMPRESA    = 1
 
 Dim strSQL, objRS, objRSAux, objRSAuxCombo, ObjConn, Cont 
 Dim strCODIGO, strRESP 
 Dim strArquivo,strArquivoAnexo, strDESCRICAO
 Dim strPREV_HORAS_HH, strPREV_HORAS_MM
 Dim strCFG_TD, aux, auxHS, acHORAS, strResposta, bFechar
 Dim strPREV_HR_INI, strPREV_HR_INI_hora, strPREV_HR_INI_min
 Dim strVALOR
 Dim matRS()' Matriz com o conteúdo dos combos
 Dim StrEMPRESANew, StrEMPRESAOld
 Dim intTAMlin, intTAMcol, intTamNew, i 
 Dim StrAuxResponsavel, StrAuxExecutor
 
 strCODIGO = GetParam("var_chavereg")

 If strCODIGO <> "" Then
	AbreDBConn objConn, CFG_DB 
	
	strSQL =          "SELECT T1.COD_TODOLIST, T1.COD_BOLETIM, T1.ARQUIVO_ANEXO, T1.ID_RESPONSAVEL, T1.ID_ULT_EXECUTOR, T1.TITULO, T1.DESCRICAO "
	strSQL = strSQL & "     , T1.SITUACAO, T1.PRIORIDADE, T1.COD_CATEGORIA, T1.PREV_DT_INI, T1.PREV_HR_INI, T1.PREV_HORAS, T1.ARQUIVO_ANEXO "
	strSQL = strSQL & "     , T1.DT_REALIZADO, T1.DESCRICAO, C1.NOME "
	strSQL = strSQL & "  FROM TL_TODOLIST T1, TL_CATEGORIA C1"
	strSQL = strSQL & " WHERE T1.COD_TODOLIST = " & strCODIGO
	strSQL = strSQL & "   AND T1.COD_CATEGORIA = C1.COD_CATEGORIA"
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1

	if not objRS.Eof then
	  strDESCRICAO  = GetValue(objRS,"DESCRICAO")
	  
	  strPREV_HORAS_HH = FormataHoraNumToHHMM(GetValue(objRS,"PREV_HORAS"))
	  strPREV_HORAS_MM = strPREV_HORAS_HH
	  if strPREV_HORAS_HH <> "" then 
		  strPREV_HORAS_HH = Mid(strPREV_HORAS_HH, 1, InStr(strPREV_HORAS_HH, ":")-1)
		  strPREV_HORAS_MM = Mid(strPREV_HORAS_MM, InStr(strPREV_HORAS_MM, ":")+1, 2) 
	  end if 
	  
	  strPREV_HR_INI = GetValue(objRS,"PREV_HR_INI")
	  If strPREV_HR_INI <> "" Then
		  strPREV_HR_INI_hora = Mid(strPREV_HR_INI, 1, InStr(strPREV_HR_INI, ":")-1)
		  strPREV_HR_INI_min = Mid(strPREV_HR_INI, InStr(strPREV_HR_INI, ":")+1, 2) 
	  End If
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
//****** Funções de ação dos botões - Início ******
function ok() 		{ document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar() 	{ document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_update.var_titulo.value == '') var_msg += '\nTítulo';
	if (document.form_update.var_situacao.value == '') var_msg += '\nSituação';
	if (document.form_update.var_cod_e_desc_categoria.value == '') var_msg += '\nCategoria';
	if (document.form_update.var_prioridade.value == '') var_msg += '\nPrioridade';
	if ((document.form_update.var_id_responsavel.value == 'selecione') || (document.form_update.var_id_responsavel.value == '')) var_msg += '\nResponsável';
	if (document.form_update.var_descricao.value == '') var_msg += '\nDescrição';
	if (var_msg == ''){
		document.form_update.submit();
	} else{
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
	}
}
//****** Funções de ação dos botões - Fim ******

var CIDInput=0, QtdeInput=0;

function addInput(prPai,prNomeElemento,prTpElemento, prStyle, prAction, prvalue) 
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
  	newFormObj.setAttribute("value"		,prvalue);
  	newFormObj.setAttribute("style"		,prStyle);
  }
 
  //DEBUG - newFormObj.setAttribute("value", prNomeElemento);
  ParentElem.appendChild(newFormObj);
  
  document.form_update.QTDE_INPUTS.value = QtdeInput;
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
  
  document.form_update.QTDE_INPUTS.value = QtdeInput;
}

</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "ToDo List - Alteração")%>
<form name="form_update" id="form_update" action="update_exec.asp" method="post">
	<input type="hidden" name="var_cod_todolist"	value="<%=strCODIGO%>">
	<input type="hidden" name="var_cod_boletim" 	value="<%=GetValue(objRS,"COD_BOLETIM")%>">
	<input type="hidden" name="var_data_ini_ant"	value="<%=PrepData(GetValue(objRS,"PREV_DT_INI"),true,false)%>">
	<input type="hidden" name="JSCRIPT_ACTION"  	value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION"	value='../modulo_TODOLIST/Update.asp?var_chavereg=<%=strCODIGO%>'>
	<input type="hidden" name="QTDE_INPUTS"			value='0'>

	<div class="form_label">*Título:</div><input name="var_titulo" type="text" style="width:300px;" value="<%=GetValue(objRS,"TITULO")%>">
	<br><div class="form_label">*Situação:</div><select name="var_situacao" style="width:100px;">
				<option value="ABERTO" <% If GetValue(objRS,"SITUACAO") = "ABERTO" Then Response.Write("selected") %>>ABERTO</option>
				<option value="OCULTO" <% If GetValue(objRS,"OCULTO") = "OCULTO" Then Response.Write("selected") %>>OCULTO</option>
			</select>
	<br><div class="form_label">*Categoria:</div><select name="var_cod_e_desc_categoria" style="width:100px;">
				<option value="">[selecione]</option>
				<%
				strSQL = " SELECT COD_CATEGORIA, NOME FROM TL_CATEGORIA WHERE DT_INATIVO IS NULL ORDER BY NOME "
				Set objRSAux = objConn.Execute(strSQL)
				
				Do While Not objRSAux.Eof
					Response.Write("<option value='" & GetValue(objRSAux,"COD_CATEGORIA") & " - " & GetValue(objRSAux,"NOME") & "'")
					If (GetValue(objRS,"COD_CATEGORIA") = GetValue(objRSAux,"COD_CATEGORIA")) Then Response.Write(" selected")
					Response.Write(">" & GetValue(objRSAux,"NOME") & "</option>")
					
					objRSAux.MoveNext
				Loop
				FechaRecordSet objRSAux
				%>
			</select>
	<br><div class="form_label">*Prioridade:</div><select name="var_prioridade" style="width:100px;">
				<option value="NORMAL" <% If GetValue(objRS,"PRIORIDADE") = "NORMAL" Then Response.Write("selected")%>>NORMAL</option>
				<option value="BAIXA"  <% If GetValue(objRS,"PRIORIDADE") = "BAIXA"  Then Response.Write("selected")%>>BAIXA</option>
				<option value="MEDIA"  <% If GetValue(objRS,"PRIORIDADE") = "MEDIA"  Then Response.Write("selected")%>>MÉDIA</option>
				<option value="ALTA"   <% If GetValue(objRS,"PRIORIDADE") = "ALTA"   Then Response.Write("selected")%>>ALTA</option>
			</select> 			
	<%
    intTAMlin = 10500
	intTAMcol = 2
	intTamNew = 0
	redim matRS(intTAMcol,intTAMlin) 	
    strSQL = MontaSQLCombo

	AbreRecordSet objRSAuxCombo, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
 	i = 0	
 	While Not objRSAuxCombo.Eof	
		matRS(ID_USUARIO,i) = GetValue(objRSAuxCombo, "ID_USUARIO")
		matRS(EMPRESA   ,i) = GetValue(objRSAuxCombo, "EMPRESA"   )
		athMoveNext objRSAuxCombo, ContFlush, CFG_FLUSH_LIMIT
		i = i + 1
	Wend
	
    intTamNew = i 'i-1
    redim preserve matRS(intTAMcol,intTamNew) 
    FechaRecordSet objRSAuxCombo		
	%>				
	<br><div class="form_label">*Responsável:</div><select name="var_id_responsavel" style="width:100px;">
				<option value="">Selecione</option>
				<%
				StrEMPRESAOld = ""
     			StrEMPRESANew = ""
                i = 0	
				StrAuxResponsavel = LCase(GetValue(objRS,"ID_RESPONSAVEL"))    
          		While i < intTamNew
			      StrEMPRESANew = matRS(EMPRESA,i)							
				  if StrEMPRESAOld <> StrEMPRESANew Then
				     if StrEMPRESAOld <> "" then
   				       Response.write("</optgroup>")
					 End If  
			 
				     Response.write("<optgroup label = '" & StrEMPRESANew & "'>")
					 StrEMPRESAOld = StrEMPRESANew
				  End If		  
				  If matRS(ID_USUARIO,i) = StrAuxResponsavel Then
					Response.write("<option value= '"& matRS(ID_USUARIO,i) & "' selected>" & matRS(ID_USUARIO,i) & "</option>")	  									   
				  Else 				  
					Response.write("<option value= '"& matRS(ID_USUARIO,i) & "'>" & matRS(ID_USUARIO,i) & "</option>")	  									   
				  End If 
				  i = i + 1 
				Wend
				%>
			</select>
	<br><div class="form_label">Executor:</div><select name="var_ID_ULT_EXECUTOR" size="1" style="width:100px;">
				<option value="">Selecione</option>
				<%
				StrEMPRESAOld = ""
     			StrEMPRESANew = ""
                i=0	       
				StrAuxExecutor = LCase(GetValue(objRS,"ID_ULT_EXECUTOR"))
          		while i < intTamNew
			      StrEMPRESANew = matRS(EMPRESA,i)							
				  if StrEMPRESAOld <> StrEMPRESANew Then
				     if StrEMPRESAOld <> "" then
   				       Response.write("</optgroup>")
					 End If  
			 
				     Response.write("<optgroup label = '" & StrEMPRESANew & "'>")
					 StrEMPRESAOld = StrEMPRESANew
				  End If		  
				  If matRS(ID_USUARIO,i) = StrAuxExecutor Then
					Response.write("<option value= '"& matRS(ID_USUARIO,i) & "' selected>" & matRS(ID_USUARIO,i) & "</option>")	  									   
				  Else 				  
					Response.write("<option value= '"& matRS(ID_USUARIO,i) & "'>" & matRS(ID_USUARIO,i) & "</option>")	  									   
				  End If 
				  i = i + 1 				   
				Wend
				%>
			</select>
	<br><div class="form_label">Prev. In&iacute;cio:</div><%=InputDate("VAR_PREV_DT_INI","",PrepData(GetValue(objRS,"PREV_DT_INI"),true,false),false)%>&nbsp;<%=ShowLinkCalendario("form_update", "VAR_PREV_DT_INI", "ver calendário")%>
			<select name="var_prev_hr_ini_hora" size="1" style="width:40px">
				<option value="" <% If CStr(strPREV_HR_INI_hora) = "" Then Response.Write(" selected='selected'") End If %>></option>
				<% 
				For Cont = 0 to 23
					If Cont < 10 Then strVALOR = CStr("0" & Cont) Else strVALOR = CStr(Cont) End If
					Response.Write("<option value='" & strVALOR & "'")
					If CStr(strPREV_HR_INI_hora) = strVALOR Then Response.Write(" selected='selected'")
					Response.Write(">" & strVALOR & "</option>")
				Next
				%>
			</select>
			<select name="var_prev_hr_ini_min" size="1" style="width:60px">
				<option value="" <% If CStr(strPREV_HR_INI_min) = "" Then Response.Write(" selected='selected'") End If %>></option>
				<%
				Cont = 0
				Do While (Cont <= 55)
					If Cont < 10 Then strVALOR = CStr("0" & Cont) Else strVALOR = CStr(Cont) End If
					Response.Write("<option value='" & strVALOR & "'")
					If CStr(strPREV_HR_INI_min) = strVALOR Then Response.Write(" selected='selected'")
					Response.Write(">" & strVALOR & " min</option>")
					Cont = Cont + 5
				Loop
				%>
			</select>&nbsp;<span class="texto_ajuda">&nbsp;<i>dd/mm/aaaa hh:mm</i></span>
	<br><div class="form_label">Prev. Horas:</div><input name="var_prev_horas" type="text" style="width:40px;" maxlength="5" value="<%=strPREV_HORAS_HH%>" onKeyPress="validateNumKey();">&nbsp;h&nbsp;
						<select name="var_prev_minutos" style="width:70px;">
							<option value="00" <% If strPREV_HORAS_MM =  "0" Then Response.Write(" selected") End If %>>00 min</option>
							<option value="25" <% If strPREV_HORAS_MM = "15" Then Response.Write(" selected") End If %>>15 min</option>
							<option value="50" <% If strPREV_HORAS_MM = "30" Then Response.Write(" selected") End If %>>30 min</option>
							<option value="75" <% If strPREV_HORAS_MM = "45" Then Response.Write(" selected") End If %>>45 min</option>
						</select>
	<br><div class="form_label">Documento:</div><input name="var_arquivo_anexo" type="text" maxlength="250" value="<%=GetValue(objRS, "ARQUIVO_ANEXO")%>" style="width:300px;"><a href="javascript:UploadArquivo('form_update','var_arquivo_anexo', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>//TODO_Anexos');"><img src="../img/BtUpload.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
	<br><div class="form_label">*Descrição:</div><textarea name="var_descricao" style="width:350px; height:140px;"><%=Replace(strDESCRICAO,"<ASLW_APOSTROFE>","'")%></textarea>
	
	<br><div class="form_label">Anexos:</div><a href="javascript:CIDInput++; QtdeInput++;
									addInput('eldin1','var_ianexo_'+CIDInput,'image','height:14px; border:0px; cursor:pointer;', 'QtdeInput--; delInput('+CIDInput+');', ''); 
									addInput('eldin2','var_anexo_'+CIDInput,'text','width:110px;', '', ''); 
									addInput('eldin3','var_anexodesc_'+CIDInput,'text','width:200px;', '', '');
									UploadArquivo('form_update','var_anexo_'+CIDInput, 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>//TODO_Anexos'); 
								"><img src="../img/BtUpload.gif" title="Buscar arquivo" alt="Buscar arquivo" border="0" style="vertical-align:top; padding-top:2px" vspace="0" hspace="0"></a>
	<br><div class="form_label"></div>-----------------------------------------------------------------------------------
	<br><div class="form_label" style="height:18px;"></div><span style="padding-left:25px;">Arquivo</span><span style="padding-left:80px;">Descrição</span>
	<br><div class="form_label"></div><div class="form_line" style="padding-left:110px;"><table style="border:0px solid #CCCCCC;"><tr><td><span id='eldin1'></span></td><td><span id='eldin2'></span></td><td><span id='eldin3'></span></td></tr></table></div>	

	<%
	   ' Faz a busca dos arquivos anexos deste TODO...
		strSQL = "SELECT COD_ANEXO, COD_TODOLIST, ARQUIVO, DESCRICAO FROM TL_ANEXO WHERE COD_TODOLIST = " & strCODIGO & " ORDER BY SYS_DTT_INS " 
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
		if not objRS.eof then 
			response.write ("<script language='JavaScript'>" & vbNewLIne)
			do while not objRS.Eof
			  response.write (" CIDInput++; QtdeInput++;")
			  response.write (" addInput('eldin1','var_ianexo_'+CIDInput   ,'image','height:14px; border:0px; cursor:pointer;', 'QtdeInput--; delInput('+CIDInput+');', ''); " & vbNewLIne)
			  response.write (" addInput('eldin2','var_anexo_'+CIDInput    ,'text' ,'width:110px;', '','"&GetValue(objRS, "ARQUIVO")&"');"	& vbNewLIne) 
			  response.write (" addInput('eldin3','var_anexodesc_'+CIDInput,'text' ,'width:200px;', '','" & replace(GetValue(objRS, "DESCRICAO"),vbNewLIne,"") & "');"	& vbNewLIne	& vbNewLIne)
			  objRS.MoveNext
			loop 
			response.write ("</script>" & vbNewLIne)
		end if
	%>
</td>	
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
<!--#include file="../_calendar/frCalendar.htm" -->
</body>
</html>
<%
	end if 
	FechaRecordSet objRS
	FechaDBConn objConn
end if
%>
