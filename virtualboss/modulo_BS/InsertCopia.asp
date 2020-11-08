<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|COPY|", BuscaDireitosFromDB("modulo_BS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "dlg_info.gif:ATEN&Ccedil;&Atilde;O! Voc&ecirc; est&aacute; prestes a fazer uma c&oacute;pia da Atividade que est&aacute; sendo visualizada e de suas tarefas. Para confirmar clique no bot&atilde;o [ok], para desistir clique em [cancelar]"

 Dim objConn, objRS, objRSAux, strSQL
 Dim strCODIGO, arrBS_EQUIPE, strAVISO

 strCODIGO = GetParam("var_chavereg")

 strAVISO = "ATEN&Ccedil;&Atilde;O! Voc&ecirc; est&aacute; prestes a fazer uma c&oacute;pia da Atividade "
 strAVISO = strAVISO & "que est&aacute; sendo visualizada e de suas tarefas. Para confirmar clique no "
 strAVISO = strAVISO & "bot&atilde;o [ok], para desistir clique em [cancelar] " 

 if strCODIGO <> "" then
	AbreDBConn objConn, CFG_DB 
	strSQL = "SELECT" &_
				"	BS.COD_BOLETIM,"	&_
				"	BS.COD_CLIENTE,"	&_
				"	CL.NOME_COMERCIAL,"	&_							
				"	BS.COD_CATEGORIA,"	&_
				"	CAT.NOME,"			&_
				"	BS.ID_RESPONSAVEL,"	&_
				"	BS.TITULO,"			&_
				"	BS.DESCRICAO,"		&_
				"	BS.SITUACAO,"		&_
				"	BS.PRIORIDADE "		&_
				"FROM "	&_
				"	BS_BOLETIM BS "		&_
				"INNER JOIN"			&_
				"	BS_CATEGORIA CAT ON (BS.COD_CATEGORIA=CAT.COD_CATEGORIA) "	&_
				"INNER JOIN" &_
				"	ENT_CLIENTE CL ON (BS.COD_CLIENTE=CL.COD_CLIENTE) " &_			
				"WHERE"	&_
				"	BS.COD_BOLETIM ="  & strCODIGO		
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	if not objRS.Eof then
		strSQL = "SELECT ID_USUARIO FROM BS_EQUIPE WHERE COD_BOLETIM=" & objRS("COD_BOLETIM") & " AND DT_INATIVO IS NULL ORDER BY ID_USUARIO"
		AbreRecordSet objRSAux, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1

		arrBS_EQUIPE = ""
		while not objRSAux.Eof 
			arrBS_EQUIPE = arrBS_EQUIPE & LCase(objRSAux("ID_USUARIO"))
			objRSAux.MoveNext
			if not objRSAux.Eof then arrBS_EQUIPE = arrBS_EQUIPE & ";"
		wend 			
		FechaRecordSet objRSAux
	end if	
	
	if not objRS.Eof then 
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok() 		{ document.formcopia.JSCRIPT_ACTION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar() 	{  }
function submeterForm() { document.formcopia.submit(); }
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Atividade/BS - Cópia")%>
<form name="formcopia" action="InsertCopia_exec.asp" method="post">
	<input type="hidden" name="var_cod_boletim"  value="<%=GetValue(objRS,"COD_BOLETIM")%>">
	<input type="hidden" name="JSCRIPT_ACTION" 	 value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_BS/Update.asp'>
	<div class="form_label">Título:</div><div class="form_bypass"><%=GetValue(objRS,"TITULO")%></div>
	<br><div class="form_label">Cliente:</div><div class="form_bypass"><%=GetValue(objRS,"NOME_COMERCIAL")%></div>
	<br><div class="form_label">Situação:</div><div class="form_bypass"><%=GetValue(objRS,"SITUACAO")%></div>
	<br><div class="form_label">Categoria:</div><div class="form_bypass"><%=GetValue(objRS,"NOME")%></div>
	<br><div class="form_label">Prioridade:</div><div class="form_bypass"><%=GetValue(objRS,"PRIORIDADE")%></div>
	<br><div class="form_label">Responsável:</div><div class="form_bypass"><%=LCase(GetValue(objRS,"ID_RESPONSAVEL"))%></div>
	<br><div class="form_label">Equipe:</div><div class="form_bypass_multiline"><%=arrBS_EQUIPE%></div>
	<br><div class="form_label">Tarefa:</div><div class="form_bypass"><%=GetValue(objRS,"DESCRICAO")%></div>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "", "")%>
</body>
</html>
<%
	end if 
	FechaRecordSet objRS
	FechaDBConn objConn
end if 
%>