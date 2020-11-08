<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_FIN_TITULOS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<%
Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
Const auxAVISO  = "dlg_warning.gif:ATENÇÃO!Você está prestes a remover o registro <br> acima visualizado.Para confirmar clique no botão [ok], para desistir clique em [cancelar]."

Dim objConn, objRS, objRSa, strSQL
Dim strCOD_LCTO_ORDINARIO 
Dim strENTIDADE
Dim strDEL_LCTO_NO_MES
Dim strMES_LCTO, strMES_HOJE, strANO_LCTO, strANO_HOJE

strDEL_LCTO_NO_MES = VerificaDireito("|DEL_NO_MES|", BuscaDireitosFromDB("modulo_FIN_TITULOS", Request.Cookies("VBOSS")("ID_USUARIO")), false)

strCOD_LCTO_ORDINARIO = GetParam("var_chavereg")

if strCOD_LCTO_ORDINARIO <> "" then
	AbreDBConn objConn, CFG_DB 
	
	strSQL =	"SELECT" 		&_	
				"	ORD.COD_LCTO_ORDINARIO," 	&_
				"	ORD.COD_CONTA_PAGAR_RECEBER," &_
				"	ORD.TIPO,"	&_
				"	ORD.CODIGO,"	&_
				"	ORD.COD_CONTA,"		&_
				"	CTA.NOME AS CONTA,"	&_
				"	ORD.COD_PLANO_CONTA,"&_
				"	PLN.NOME AS PLANO_CONTA,"	&_
				"	ORD.COD_CENTRO_CUSTO,"		&_
				"	CTO.NOME AS CENTRO_CUSTO,"	&_
				"	ORD.HISTORICO,"		&_
				"	ORD.NUM_LCTO,"			&_
				"	ORD.DT_LCTO,"			&_
				"	ORD.VLR_ORIG,"			&_
				"	ORD.VLR_MULTA,"		&_
				"	ORD.VLR_JUROS,"		&_
				"	ORD.VLR_DESC,"			&_
				"	ORD.VLR_LCTO,"			&_
				"	ORD.OBS "	&_
				"FROM "		&_
				"	FIN_LCTO_ORDINARIO ORD "	&_
				"INNER JOIN"	&_
				"	FIN_CONTA CTA ON (ORD.COD_CONTA=CTA.COD_CONTA) "	&_
				"INNER JOIN"	&_
				"	FIN_PLANO_CONTA PLN ON (ORD.COD_PLANO_CONTA=PLN.COD_PLANO_CONTA) "	&_
				"INNER JOIN"	&_
				"	FIN_CENTRO_CUSTO CTO ON (ORD.COD_CENTRO_CUSTO=CTO.COD_CENTRO_CUSTO) "	&_
				"WHERE"			&_
				"	ORD.COD_LCTO_ORDINARIO=" & strCOD_LCTO_ORDINARIO
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
	if not objRS.Eof then
		'Se direito DEL_LCTO_NO_MES estiver TRUE é porque só pode deletar lctos feitos no mês
		If strDEL_LCTO_NO_MES Then
			strMES_LCTO = CStr(Month(GetValue(objRS,"DT_LCTO")))
			strMES_HOJE = CStr(Month(Date))
			strANO_LCTO = CStr(Year(GetValue(objRS,"DT_LCTO")))
			strANO_HOJE = CStr(Year(Date))
			
			If ((strMES_LCTO <> strMES_HOJE) And (strANO_LCTO = strANO_HOJE)) Or (strANO_LCTO <> strANO_HOJE) Then
				Mensagem "Não é possível deletar este lançamento porque não é do mês corrente.", "Javascript:history.back();", "Voltar", 1
				Response.End()
			End If
		End If
		
		strSQL=""					 
		if GetValue(objRS,"TIPO") = "ENT_CLIENTE"     and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME_FANTASIA AS NOME FROM ENT_CLIENTE     WHERE COD_CLIENTE     = " & GetValue(objRS,"CODIGO")
		if GetValue(objRS,"TIPO") = "ENT_FORNECEDOR"  and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME_FANTASIA AS NOME FROM ENT_FORNECEDOR  WHERE COD_FORNECEDOR  = " & GetValue(objRS,"CODIGO")
		if GetValue(objRS,"TIPO") = "ENT_COLABORADOR" and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME                  FROM ENT_COLABORADOR WHERE COD_COLABORADOR = " & GetValue(objRS,"CODIGO")
		
		strENTIDADE=""
		if strSQL<>"" then
			AbreRecordSet objRSa, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
			if not objRSa.Eof then strENTIDADE = GetValue(objRSa, "NOME")
			FechaRecordSet objRSa
		end if
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok()       { document.form_delete.submit(); }
function cancelar() { document.location.href = "../modulo_FIN_TITULOS/Detail.asp?var_chavereg=<%=GetValue(objRS,"COD_CONTA_PAGAR_RECEBER")%>"; }
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog (WMD_WIDTH, "Lançamento Ordinário - Exclusão")%>
<form name="form_delete" action="../modulo_FIN_TITULOS/DeleteLcto_Exec.asp" method="post">
	<input name="var_chavereg"		type="hidden" value="<%=strCOD_LCTO_ORDINARIO%>">
	<input name="var_cod_conta"		type="hidden" value="<%=GetValue(objRS,"COD_CONTA_PAGAR_RECEBER")%>">
	<input name="JSCRIPT_ACTION"	type="hidden" value="">
	<input name="DEFAULT_LOCATION"  type="hidden" value='../modulo_FIN_TITULOS/Detail.asp?var_chavereg=<%=GetValue(objRS,"COD_CONTA_PAGAR_RECEBER")%>'>
	<div class="form_label">Código:</div><div class="form_bypass"><%=strCOD_LCTO_ORDINARIO%></div>
	<br><div class="form_label">Conta a Pagar e Receber:</div><div class="form_bypass"><%=GetValue(objRS,"COD_CONTA_PAGAR_RECEBER")%></div>
	<br><div class="form_label">Conta:</div><div class="form_bypass"><%=GetValue(objRS,"CONTA")%></div>
	<br><div class="form_label">Entidade:</div><div class="form_bypass"><%=strENTIDADE%></div>
	<br><div class="form_label">Plano de Conta:</div><div class="form_bypass"><%=GetValue(objRS,"PLANO_CONTA")%></div>
	<br><div class="form_label">Centro de Custo:</div><div class="form_bypass"><%=GetValue(objRS,"CENTRO_CUSTO")%></div>
	<br><div class="form_label">Histórico:</div><div class="form_bypass"><%=GetValue(objRS,"HISTORICO")%></div>
	<br><div class="form_label">Número:</div><div class="form_bypass"><%=GetValue(objRS,"NUM_LCTO")%></div>
	<br><div class="form_label">Data:</div><div class="form_bypass"><%=PrepData(GetValue(objRS,"DT_LCTO"), True, False)%></div>
	<br><div class="form_label">Valor Original:</div><div class="form_bypass"><%=FormataDecimal(GetValue(objRS,"VLR_ORIG"),2)%></div>
	<br><div class="form_label">Valor Multa:</div><div class="form_bypass"><%=FormataDecimal(GetValue(objRS,"VLR_MULTA"),2)%></div>
	<br><div class="form_label">Valor Juros:</div><div class="form_bypass"><%=FormataDecimal(GetValue(objRS,"VLR_JUROS"),2)%></div>
	<br><div class="form_label">Valor Desconto:</div><div class="form_bypass"><%=FormataDecimal(GetValue(objRS,"VLR_DESC"),2)%></div>
	<br><div class="form_label">Valor Lançamento:</div><div class="form_bypass"><%=FormataDecimal(GetValue(objRS,"VLR_LCTO"),2)%></div>
	<br><div class="form_label">Observação:</div><div class="form_bypass"><%=GetValue(objRS,"OBS")%></div>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok()", "../img/butxp_cancelar.gif", "cancelar();", "", "")%>
</body>
</html>
<%
	end if
	FechaRecordSet objRS
	FechaDBConn objConn
end if
%>