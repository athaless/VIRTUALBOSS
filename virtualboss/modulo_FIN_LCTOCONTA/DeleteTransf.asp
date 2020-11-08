<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_FIN_LCTOCONTA", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<%
' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
' e o tamanho da coluna dos títulos dos inputs
Dim WMD_WIDTH, WMD_WIDTHTTITLES
WMD_WIDTH = 580
WMD_WIDTHTTITLES = 100
' -------------------------------------------------------------------------------

Dim objConn, objRS, strSQL, strSQLClause, auxAVISO
Dim strCOD_LCTO_TRANSF, strVLR_LCTO 
		
auxAVISO  = "dlg_warning.gif:ATENÇÃO!Você está prestes a remover o registro <br> acima visualizado." &_ 
            "Para confirmar clique no botão [ok], para desistir clique em [cancelar]."
		
strCOD_LCTO_TRANSF   = GetParam("var_chavereg")
	
if strCOD_LCTO_TRANSF <> "" then
	AbreDBConn objConn, CFG_DB 
	
	strSQL =	"SELECT" &_	
				"	COD_LCTO_TRANSF,"	&_
				"	COD_CONTA_ORIG,"	&_
				"	COD_CONTA_DEST,"	&_
				"	T2.NOME AS CONTA_ORIG," &_
				"	T3.NOME AS CONTA_DEST," &_
				"	HISTORICO,"	&_
				"	OBS,"	&_
				"	NUM_LCTO,"	&_
				"	VLR_LCTO,"	&_
				"	DT_LCTO "	&_
				"FROM" 	&_
				"	FIN_LCTO_TRANSF," &_
				"	FIN_CONTA AS T2," &_
				"	FIN_CONTA AS T3 "	&_
				"WHERE" 	&_	
				"	COD_CONTA_ORIG = T2.COD_CONTA AND COD_CONTA_DEST = T3.COD_CONTA AND"	&_
				"	COD_LCTO_TRANSF=" & strCOD_LCTO_TRANSF
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
	if not objRS.Eof then				 
		if GetValue(objRS,"VLR_LCTO")<>"" then strVLR_LCTO = FormataDecimal(GetValue(objRS,"VLR_LCTO"),2)

%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok()       { document.form_deleteTransf.submit(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Transferência - Exclus&atilde;o") %>
  <table width="100%" border="0" cellpadding="1" cellspacing="0" align="center">
    <tr><td width=<%=WMD_WIDTHTTITLES%>></td><td></td></tr>
    <tr><td align="right">Cod:&nbsp;</td><td><%=strCOD_LCTO_TRANSF%></td></tr>
    <tr><td align="right">Origem:&nbsp;</td><td><%=GetValue(objRS,"CONTA_ORIG")%></td></tr>
    <tr><td align="right">Destino:&nbsp;</td><td><%=GetValue(objRS,"CONTA_DEST")%></td></tr>
    <tr><td align="right">Histórico:&nbsp;</td><td><%=GetValue(objRS,"HISTORICO")%></td></tr>
    <tr><td align="right">Número:&nbsp;</td><td><%=GetValue(objRS,"NUM_LCTO")%></td></tr>  
    <tr><td align="right">Valor:&nbsp;</td><td><%=strVLR_LCTO%></td></tr>
    <tr><td align="right">Observação:&nbsp;</td><td><%=GetValue(objRS,"OBS")%></td></tr>
  </table>
  <form name="form_deleteTransf" action="DeleteTransf_Exec.asp" method="post">
	<input name="var_chavereg"    type="hidden" value="<%=strCOD_LCTO_TRANSF%>">
	<input name="var_conta_orig"  type="hidden" value="<%=GetValue(objRS,"COD_CONTA_ORIG")%>">
	<input name="var_conta_dest"  type="hidden" value="<%=GetValue(objRS,"COD_CONTA_DEST")%>">
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