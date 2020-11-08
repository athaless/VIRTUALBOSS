<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 Const WMD_WIDTHTTITLES = 150
 
 Dim strSQL, objRS, ObjConn, auxDIREITOS
 Dim strCODIGO, strRESPOSTA, strTDTITULO, auxHS
 Dim auxSTRTITULO, auxSTRSITUACAO, auxSTRCATEGORIA 
 Dim auxSTRPRIORIDADE, auxSTRRESPONSAVEL, auxSTRDESC, auxSTRTIPO
 Dim auxSTRPREV_DT_INI, auxSTRPREV_HR_INI, auxSTRPREV_HORAS
 Dim auxSTRCLIENTE, auxSTRDT_REALIZADO, auxSTRFULLCATEGORIA
 Dim auxSTRCOD_BOLETIM, strGRUPOS, strGRUPO_USUARIO
 Dim strCOOKIE_ID_USUARIO, strID_RESPONSAVEL, arrBS_EQUIPE 
 Dim bUpdAllTODO, bCopiaTODO, bViewTODO, bUpdTODO, bInsRespTODO

 strCOOKIE_ID_USUARIO = LCase(Request.Cookies("VBOSS")("ID_USUARIO"))
 strGRUPO_USUARIO     = UCase(Request.Cookies("VBOSS")("GRUPO_USUARIO"))	
 strCODIGO            = GetParam("var_chavereg")
 strRESPOSTA          = UCase(GetParam("var_resposta"))

 if strRESPOSTA = "" then strRESPOSTA = false

 'Verificação de DIREITOS para o MODULO_TODOLIST - para detail
 auxDIREITOS   = BuscaDireitosFromDB("modulo_TODOLIST", Request.Cookies("VBOSS")("ID_USUARIO"))
 bCopiaTODO    = VerificaDireito("|INS|"			, auxDIREITOS, false)
 bUpdTODO      = VerificaDireito("|UPD|"            , auxDIREITOS, false)
 bUpdAllTODO   = VerificaDireito("|UPD_ALL_TODO|"	, auxDIREITOS, false)
 bViewTODO     = VerificaDireito("|VIEW|"           , auxDIREITOS, false)
 bCopiaTODO    = VerificaDireito("|COPY|"           , auxDIREITOS, false)
 bInsRespTODO  = VerificaDireito("|INS_RESP|"       , auxDIREITOS, false)
 
 if strCODIGO <> "" then
	AbreDBConn objConn, CFG_DB 
	
	strSQL = "SELECT" 																				&_
				"	BS.COD_BOLETIM,"																&_
				"	BS.COD_CLIENTE,"																&_
				"	CL.NOME_COMERCIAL,"																&_		
				"	BS.COD_CATEGORIA,"																&_
				"	CAT.NOME,"																		&_
				"	BS.ID_RESPONSAVEL,"																&_
				"	BS.TITULO,"																		&_
				"	BS.DESCRICAO,"																	&_
				"	BS.SITUACAO,"																	&_
				"	BS.PRIORIDADE, "																&_
				"	BS.TIPO "																		&_
				"FROM BS_BOLETIM BS "																&_
				"INNER JOIN BS_CATEGORIA CAT ON (BS.COD_CATEGORIA=CAT.COD_CATEGORIA) "				&_
				"INNER JOIN ENT_CLIENTE CL ON (BS.COD_CLIENTE=CL.COD_CLIENTE) " 					&_				
				"WHERE BS.COD_BOLETIM = " & strCODIGO
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1

	if not objRS.eof then 
		auxSTRCOD_BOLETIM   = GetValue(objRS,"COD_BOLETIM")
		auxSTRTITULO        = GetValue(objRS,"TITULO")
		auxSTRSITUACAO      = GetValue(objRS,"SITUACAO")
		auxSTRCATEGORIA     = GetValue(objRS,"NOME")
		auxSTRPRIORIDADE    = GetValue(objRS,"PRIORIDADE")
		auxSTRCLIENTE		= GetValue(objRS,"NOME_COMERCIAL")
		auxSTRRESPONSAVEL   = LCase(GetValue(objRS,"ID_RESPONSAVEL"))
		auxSTRDESC          = GetValue(objRS,"DESCRICAO")
		auxSTRFULLCATEGORIA = GetValue(objRS,"COD_CATEGORIA") & " - " & auxSTRCATEGORIA		
		auxSTRTIPO          = GetValue(objRS,"TIPO")
		
		strSQL =          " SELECT MIN(T1.PREV_DT_INI) AS INICIO "
		strSQL = strSQL & "      , SUM(T1.PREV_HORAS) AS HS "
		strSQL = strSQL & "      , (SELECT T5.DT "
		strSQL = strSQL & "         FROM (SELECT T2.COD_BOLETIM "
		strSQL = strSQL & "                     ,(if((SELECT COUNT(T3.SITUACAO) FROM TL_TODOLIST T3 WHERE T3.COD_BOLETIM = " & strCODIGO 
		strSQL = strSQL & "                           AND T3.SITUACAO = 'ABERTO')>0, NULL "
		strSQL = strSQL & "                          ,(SELECT MAX(T4.DT_REALIZADO) FROM TL_TODOLIST T4 WHERE T4.COD_BOLETIM = " & strCODIGO & ") "
		strSQL = strSQL & "                        ) "
		strSQL = strSQL & "                    ) AS DT  "
		strSQL = strSQL & "               FROM TL_TODOLIST T2 "
		strSQL = strSQL & "               WHERE T2.COD_BOLETIM = " & strCODIGO & "  "
		strSQL = strSQL & "               GROUP BY T2.COD_BOLETIM) AS T5 "
		strSQL = strSQL & "        ) AS DT_FECHADO  "
		strSQL = strSQL & " FROM TL_TODOLIST T1 WHERE T1.COD_BOLETIM = " & strCODIGO
		
		'athDebug strSQL, true
		
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		
		auxSTRPREV_DT_INI = PrepData(GetValue(objRS,"INICIO"),true,false)
		auxSTRPREV_HORAS = GetValue(objRS,"HS")
		auxSTRDT_REALIZADO = GetValue(objRS,"DT_FECHADO")
		
		strSQL = "SELECT ID_USUARIO FROM BS_EQUIPE WHERE COD_BOLETIM = " & strCODIGO  & " AND DT_INATIVO IS NULL ORDER BY ID_USUARIO"
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1		
		
		arrBS_EQUIPE = ""
		while not objRS.Eof 
			arrBS_EQUIPE = arrBS_EQUIPE & LCase(GetValue(objRS,"ID_USUARIO")) & "; "
			objRS.MoveNext
		wend 

		FechaRecordSet objRS
		  
		strSQL =	"SELECT"																	&_
					"	T1.COD_TODOLIST,"														&_
					"	T1.ID_RESPONSAVEL,"														&_
					"	T1.ID_ULT_EXECUTOR,"													&_
					"	T1.DESCRICAO,"															&_
					"	T1.PREV_DT_INI,"														&_
					"	T1.PREV_HR_INI,"														&_					
					"	T1.ID_ULT_EXECUTOR,"													&_					
					"	T1.SITUACAO,"															&_
					"	T1.TITULO,"																&_
					"	COUNT(T2.COD_TODOLIST) AS RESPOSTAS," 									&_
					"	T1.PREV_HORAS "															&_				
					"FROM"																		&_
					"	TL_TODOLIST T1 "														&_
					"LEFT OUTER JOIN"															&_
					"	TL_RESPOSTA T2 ON (T1.COD_TODOLIST=T2.COD_TODOLIST) "					&_				
					"WHERE"																		&_
					"	T1.COD_BOLETIM =" & strCODIGO	& " "									&_
					"GROUP BY" 																	&_
					"	T1.COD_TODOLIST,"														&_
					"	T1.ID_RESPONSAVEL,"														&_
					"	T1.ID_ULT_EXECUTOR,"													&_
					"	T1.PREV_DT_INI,"														&_
					"	T1.PREV_HR_INI,"														&_					
					"	T1.ID_ULT_EXECUTOR,"													&_					
					"	T1.SITUACAO,"															&_
					"	T1.TITULO,"																&_
					"	T1.SYS_DTT_INS,"														&_
					"	T1.SYS_DTT_ALT,"														&_				
					"	T1.PREV_HORAS"															&_				
					" ORDER BY T1.PREV_DT_INI, T1.TITULO"
					'" ORDER BY T1.PREV_DT_INI, T1.SYS_DTT_INS, T1.SYS_DTT_ALT"

		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1		
%>
<html>
<head>
	<title>vboss</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<script type="text/javascript" src="../_scripts/tablesort.js"></script>
	<link rel="stylesheet" type="text/css" href="../_css/virtualboss.css">
	<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
	<link rel="stylesheet" type="text/css" href="../_css/menupure.css">
	<script type="text/javascript">
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
			if (document.form_insert.var_id_responsavel.value == '') var_msg += '\nResponsável';
			if (document.form_insert.var_id_executor.value == '') var_msg += '\nExecutor';
			if (document.form_insert.var_descricao.value == '') var_msg += '\nDescrição';
			
			if (var_msg == ''){
				document.form_insert.submit();
			} else{
				alert('Favor verificar campos obrigatórios:\n' + var_msg);
			}
		}
	//****** Funções de ação dos botões - Fim ******
	
	//******Variáveis e funções para o botão de upload de anexos da tarefa - Início.
	//ATENÇÃO: ISTO DEVE SER MELHORADO.	
	//Funções estão copiadas aqui porque na inserção de tarefa através da Atividade, a inserção
	//de Tarefa é chamada através de AJAX, e o JS desta página não é carregado. 
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
		//******Variáveis e funções para o botão de upload de anexos da tarefa - Fim.	
	</script>
</head>
<body>
<%
	'Concatenamos o link corretamente para os casos
	'onde o redirect tenha sido informado ou não
	athBeginCssMenu()
		athCssMenuAddItem "#", "onClick=""displayArea('table_header');""", "_self", "ATIVIDADE <strong>" & auxSTRCOD_BOLETIM & "</strong> - " & auxSTRTITULO, "", 1
	athEndCssMenu("")
	%>
<div id="table_header" style="width:100%">
<table border="0" cellpadding="1" cellspacing="0" class="tableheader">
	<tbody style="text-align:left">
		<tr>
			<td>Situação:&nbsp;</td>
			<td><%=auxSTRSITUACAO%></td>
		</tr>
		<tr>
			<td>Categoria:&nbsp;</td>
			<td><%=auxSTRCATEGORIA%></td>
		</tr>
		<tr>
			<td>Prioridade:&nbsp;</td>
			<td><%=auxSTRPRIORIDADE%></td>
		</tr>
		<tr>
			<td>Cliente:&nbsp;</td>
			<td><%=auxSTRCLIENTE%></td>
		</tr>		
		<tr>
			<td>Responsável:&nbsp;</td>
			<td><%=auxSTRRESPONSAVEL%></td>
		</tr>
		<tr>
			<td>Equipe:&nbsp;</td>
			<td><%=arrBS_EQUIPE%></td>
		</tr>
		<tr>
			<td>Previsão:&nbsp;</td>
			<td><%=auxSTRPREV_DT_INI%> (<%=FormataHoraNumToHHMM(auxSTRPREV_HORAS)%>)</td>
		</tr>
		<tr>
			<td>Data Realizado:&nbsp;</td>
			<td><%=auxSTRDT_REALIZADO%></td></tr>
		<tr id="tableheader_last_row">
			<td>Tarefa:&nbsp;</td>
			<td><%=Replace(Replace(auxSTRDESC,"<ASLW_APOSTROFE>","'"),CHR(13),"<br>")%><br><br></td>
		</tr>
	</tbody>
</table>
</div>
<br>	

<%
	end if 
	'Concatenamos o link corretamente para os casos
	'onde o redirect tenha sido informado ou não
	athBeginCssMenu()
		athCssMenuAddItem "", "", "_self", "TAREFAS","", 1
		athBeginCssSubMenu()
			athCssMenuAddItem "../modulo_TODOLIST/Insert.asp?var_chavereg="& strCODIGO,"", "_self", "Inserir Tarefa", "div_modal", 0
		athEndCssSubMenu()
	athEndCssMenu("div_modal")
	
	if not objRS.Eof then
		'OCULTO aparece SOMENTE para MANAGER, RESPONSAVEL pelo BS ou RESPONSAVEL pela TAREFA
		while (GetValue(objRS,"SITUACAO")="OCULTO" and Request.Cookies("VBOSS")("GRUPO_USUARIO")<>"MANAGER" and auxSTRRESPONSAVEL<>strCOOKIE_ID_USUARIO and LCase(GetValue(objRS,"ID_RESPONSAVEL"))<>strCOOKIE_ID_USUARIO)
			objRS.MoveNext
		wend
		if not objRS.eof then					
%>
<table style="width:100%" border="0" align="center" cellpadding="3" cellspacing="0" class="tablesort">
	<thead>
		<tr> 
			<% if (auxSTRTIPO = "MODELO") then %>					
				<th width="01%"></th>
			<% end if %>
			<th width="01%"></th>
			<th width="01%"></th>
			<th width="01%"></th>
			<th width="05%">Tarefa</div></th>
			<th width="05%">Resp</div></th>
			<th width="05%">Exec</div></th>
			<th width="05%" nowrap>Data</div></th>
			<th width="05%" nowrap>Hora</div></th>
			<th width="66%">Título</div></th>
			<th width="05%" nowrap>Prev Hs</div></th>
			<th width="01%"></th>
		</tr>
	</thead>
	<tbody style="text-align:left">
	<%		
		while not objRS.Eof
			auxHS = ""
			strID_RESPONSAVEL=LCase(GetValue(objRS,"ID_RESPONSAVEL"))
			strTDTITULO= GetValue(objRS,"TITULO")
			
			if strTDTITULO<>"" then strTDTITULO = Replace(strTDTITULO,"<ASLW_APOSTROFE>","'")
			if GetValue(objRS,"PREV_HORAS")<>"" then auxHS = GetValue(objRS,"PREV_HORAS")
	%>
		<tr>
			<% if (auxSTRTIPO = "MODELO") then %>					
			<td align="center" height="18">
				<div style="cursor:hand;"><%=MontaLinkGrade("modulo_TODOLIST","Delete.asp",GetValue(objRS,"COD_TODOLIST"),"IconAction_DEL.gif","DELETAR")%></div>
			</td>
			<% end if %>
			<td align="center" height="18"><%'A consulta já está preparada para retornar se há resposta para a tarefa. %>
			<% if (strID_RESPONSAVEL = strCOOKIE_ID_USUARIO) and CBool(strRESPOSTA) then %>					
				<div style="cursor:hand;"><%=MontaLinkGrade("modulo_TODOLIST","Update.asp",GetValue(objRS,"COD_TODOLIST"),"IconAction_EDIT.gif","ALTERAR")%></div>
			<% elseif bUpdAllTODO then %>
				<div style="cursor:hand;"><%=MontaLinkGrade("modulo_TODOLIST","Update.asp",GetValue(objRS,"COD_TODOLIST"),"IconAction_EDITInterv.gif","ALTERAR")%></div>
			<% end if %>
			</td>
			<td align="center">
			<% if (InStr(arrBS_EQUIPE,strCOOKIE_ID_USUARIO)>0) or (strID_RESPONSAVEL=strCOOKIE_ID_USUARIO) then %>						
				<div style="cursor:hand;"><%=MontaLinkGrade("modulo_TODOLIST","DetailHistorico.asp",GetValue(objRS,"COD_TODOLIST"),"IconAction_DETAILadd.gif","VER ANDAMENTOS")%></div>
			<% end if %>
			</td>
			<td align="center">
		<% if bCopiaTODO then%>
			<div style="cursor:hand;">
				<%=MontaLinkGrade("modulo_TODOLIST","Copia.asp",GetValue(objRS,"COD_TODOLIST") & "&var_resposta=true&var_codigo=" & strCODIGO,"IconAction_COPY.gif","CÓPIA")%>
			</div>						
		<% end if %>
			</td>
			<td><%=objRS("COD_TODOLIST")%></td>
			<td><%=LCase(GetValue(objRS,"ID_RESPONSAVEL"))%></td>					
			<td><%=LCase(GetValue(objRS,"ID_ULT_EXECUTOR"))%></td>
			<td nowrap><%=PrepData(GetValue(objRS,"PREV_DT_INI"),true,false)%></td>
			<td nowrap><%=GetValue(objRS,"PREV_HR_INI")%></td>										
			<td>
				<b><%=strTDTITULO%></b><br>
				<%=GetValue(objRS,"DESCRICAO")%>
			</td>
			<td style="text-align:right;" nowrap><div style="padding-right:5px;"><%=FormataHoraNumToHHMM(auxHS)%></td>
			<td align="center"><img src="../img/IconStatus_<%=GetValue(objRS,"SITUACAO")%>.gif" title="SITUAÇÃO: <%=GetValue(objRS,"SITUACAO")%>"></td>
		</tr>
		<%
			objRS.MoveNext
			'OCULTO aparece SOMENTE para MANAGER, RESPONSAVEL pelo BS ou RESPONSAVEL pela TAREFA
			while (GetValue(objRS,"SITUACAO")="OCULTO" and Request.Cookies("VBOSS")("GRUPO_USUARIO")<>"MANAGER" and auxSTRRESPONSAVEL<>strCOOKIE_ID_USUARIO and LCase(GetValue(objRS,"ID_RESPONSAVEL"))<>strCOOKIE_ID_USUARIO)
				objRS.MoveNext
			wend						
		wend 
		%>
	</tbody>
	<tr>
		<td width="100%" height="30" colspan="11" style="text-align:right;" valign="middle">
			Total Prev:&nbsp;<%=FormataHoraNumToHHMM(auxSTRPREV_HORAS)%>
		</td>
		<td></td>
	</tr>
</table>
<%	
	end if 
%>
</body>
</html>
<%
	end if 
	FechaRecordSet objRS
	FechaDBConn objConn
end if 
%>