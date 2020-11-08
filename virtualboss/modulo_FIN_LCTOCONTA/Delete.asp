<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_FIN_LCTOCONTA", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<%
Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
Const auxAVISO  = "dlg_warning.gif:ATENÇÃO!Você está prestes a remover o registro <br> acima visualizado.Para confirmar clique no botão [ok], para desistir clique em [cancelar]."

Dim objConn, objRS, objRSa, strSQL
Dim strCOD_LCTO_EM_CONTA, strVLR_LCTO
Dim strENTIDADE
Dim strDEL_LCTO_NO_MES
Dim strMES_LCTO, strMES_HOJE, strANO_LCTO, strANO_HOJE

strDEL_LCTO_NO_MES = VerificaDireito("|DEL_NO_MES|", BuscaDireitosFromDB("modulo_FIN_LCTOCONTA", Request.Cookies("VBOSS")("ID_USUARIO")), false)

strCOD_LCTO_EM_CONTA = GetParam("var_chavereg")

if strCOD_LCTO_EM_CONTA <> "" then
	AbreDBConn objConn, CFG_DB 
	
	strSQL =	"SELECT" 						&_	
				"	LCTO.COD_LCTO_EM_CONTA,"	&_	
				"	LCTO.COD_CONTA,"			&_
				"	LCTO.OPERACAO,"				&_					
				"	LCTO.CODIGO,"				&_	
				"	LCTO.TIPO,"					&_	
				"	PLAN.COD_REDUZIDO,"			&_
				"	CTA.NOME,"					&_
				"	PLAN.NOME AS PLANO_CONTA,"	&_	
				"	CUST.NOME AS CENTRO_CUSTO,"	&_	
				"	LCTO.HISTORICO,"			&_
				"	LCTO.OBS,"					&_					
				"	LCTO.NUM_LCTO,"				&_	
				"	LCTO.VLR_LCTO,"				&_		
				"	LCTO.DT_LCTO "				&_	
				"FROM "							&_	
				"	FIN_LCTO_EM_CONTA LCTO "	&_	
				"LEFT OUTER JOIN"				&_	
				"	FIN_PLANO_CONTA PLAN ON (PLAN.COD_PLANO_CONTA=LCTO.COD_PLANO_CONTA) "		&_	
				"LEFT OUTER JOIN"				&_	
				"	FIN_CENTRO_CUSTO CUST ON (CUST.COD_CENTRO_CUSTO=LCTO.COD_CENTRO_CUSTO) "	&_	
				"LEFT OUTER JOIN"				&_	
				"	FIN_CONTA CTA ON (LCTO.COD_CONTA=CTA.COD_CONTA) "	&_	
				"WHERE"							&_	
				"	LCTO.COD_LCTO_EM_CONTA = " & strCOD_LCTO_EM_CONTA
	
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
		if GetValue(objRS, "TIPO")="ENT_CLIENTE"     and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME_COMERCIAL AS NOME FROM ENT_CLIENTE     WHERE COD_CLIENTE     = " & GetValue(objRS,"CODIGO")
		if GetValue(objRS, "TIPO")="ENT_FORNECEDOR"  and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME_COMERCIAL AS NOME FROM ENT_FORNECEDOR  WHERE COD_FORNECEDOR  = " & GetValue(objRS,"CODIGO")
		if GetValue(objRS, "TIPO")="ENT_COLABORADOR" and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME                   FROM ENT_COLABORADOR WHERE COD_COLABORADOR = " & GetValue(objRS,"CODIGO")
		
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
</head>
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok()       { document.form_delete.submit(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Lançamentos - Exclus&atilde;o") %>
  <table width="100%" border="0" cellpadding="1" cellspacing="0" align="center">
	<tr><td style="text-align:right;" width="130px">Cod:&nbsp;</td><td><%=strCOD_LCTO_EM_CONTA%></td></tr>
	<tr><td style="text-align:right;">Operação:&nbsp;</td><td><%=GetValue(objRS,"OPERACAO")%></td></tr>
	<tr><td style="text-align:right;">Entidade:&nbsp;</td><td><%=strENTIDADE%></td></tr>
	<tr><td style="text-align:right;">Histórico:&nbsp;</td><td><%=GetValue(objRS,"HISTORICO")%></td></tr>
	<tr><td style="text-align:right;">Conta:&nbsp;</td><td><%=GetValue(objRS,"NOME")%></td></tr>    
	<tr><td style="text-align:right;">Plano de Conta:&nbsp;</td><td><%=GetValue(objRS,"COD_REDUZIDO")%>&nbsp;&nbsp;<%=GetValue(objRS,"PLANO_CONTA")%></td></tr>
	<tr><td style="text-align:right;">Centro de Custo:&nbsp;</td><td><%=GetValue(objRS,"CENTRO_CUSTO")%></td></tr>    
	<tr><td style="text-align:right;">Número:&nbsp;</td><td><%=GetValue(objRS,"NUM_LCTO")%></td></tr>  
	<tr><td style="text-align:right;">Valor:&nbsp;</td><td><%=FormataDecimal(GetValue(objRS,"VLR_LCTO"),2)%></td></tr>
	<tr><td style="text-align:right;">Data:&nbsp;</td><td><%=PrepData(GetValue(objRS,"DT_LCTO"),true,false)%></td></tr>
	<tr><td style="text-align:right;">Observação:&nbsp;</td><td><%=GetValue(objRS,"OBS")%></td></tr>
  </table>
  <form name="form_delete" action="Delete_Exec.asp" method="post">
	<input name="var_chavereg"    type="hidden" value="<%=strCOD_LCTO_EM_CONTA%>">
	<input name="var_conta"       type="hidden" value="<%=GetValue(objRS,"COD_CONTA")%>">
	<input name="var_op"          type="hidden" value="<%=GetValue(objRS,"OPERACAO")%>">
	<input name="var_vlr"         type="hidden" value="<%=GetValue(objRS,"VLR_LCTO")%>">	
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