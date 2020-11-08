<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_FIN_TITULOS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<%
 Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "dlg_warning.gif:ATENÇÃO!Você está prestes a remover o registro <br> acima visualizado. Para confirmar clique no botão [ok], para desistir clique em [cancelar]."

 Dim ObjConn, objRS, strSQL 
 Dim strCODIGO, Idx
   
 strCODIGO = GetParam("var_chavereg")

 if strCODIGO <> "" then
	AbreDBConn objConn, CFG_DB 
	
	strSQL =	"SELECT" 		&_	
				"	T1.COD_CONTA_PAGAR_RECEBER," &_	
				"	T1.TIPO," 	&_
				"	T1.CODIGO," &_
				"	T1.DT_EMISSAO," 		&_
				"	T1.HISTORICO,"			&_
				"	T1.TIPO_DOCUMENTO,"	&_
				"	T1.NUM_DOCUMENTO," 	&_
				"	T1.PAGAR_RECEBER," 	&_
				"	T1.DT_VCTO,"	 		&_
				"	T1.VLR_CONTA," 	 	&_
				"	T2.NOME AS CONTA," 	&_
				"	T1.SITUACAO,"			&_
				"	T1.OBS,"			&_				
				"	T3.NOME AS PLANO_CONTA," 	&_
				"	T4.NOME AS CENTRO_CUSTO," 	&_
				"	T3.COD_PLANO_CONTA," &_
				"	T3.COD_REDUZIDO AS PLANO_CONTA_COD_REDUZIDO," 	&_
				"	T4.COD_REDUZIDO AS CENTRO_CUSTO_COD_REDUZIDO " 	&_
				"FROM" 	&_
				"	FIN_CONTA_PAGAR_RECEBER AS T1," &_
				"	FIN_CONTA AS T2," 	&_
				"	FIN_PLANO_CONTA AS T3,"		&_
				"	FIN_CENTRO_CUSTO AS T4 " 	&_
				"WHERE"	 &_
				"	T1.COD_CONTA = T2.COD_CONTA AND"	 &_
				"	T1.COD_PLANO_CONTA = T3.COD_PLANO_CONTA AND"	 	&_
				"	T1.COD_CENTRO_CUSTO = T4.COD_CENTRO_CUSTO AND" 	&_
				"	T1.COD_CONTA_PAGAR_RECEBER=" &  strCODIGO
	'athDebug strSQL, true

	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
	if not objRS.Eof then				 
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok()       { document.form_delete.submit(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Título - Dele&ccedil;&atilde;o")%>     
<% for Idx = 0 to objRS.fields.count - 4  'NÃO QUIZ EXIBIR TODOS OS DADOS... %>
<br><div class="form_label"><%=objRS.Fields(Idx).name%>:</div><div class="form_bypass"><%=GetValue (objRS, objRS.Fields(Idx).name)%></div>
<% next %>
	<form name="form_delete" action="../_database/athDeleteToDB.asp" method="post">
       <input type="hidden" name="DEFAULT_TABLE"    value="FIN_CONTA_PAGAR_RECEBER">
       <input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
       <input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
       <input type="hidden" name="RECORD_KEY_NAME"  value="COD_CONTA_PAGAR_RECEBER">
       <input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODIGO%>">
       <input type="hidden" name="JSCRIPT_ACTION"   value="parent.frames['vbTopFrame'].document.form_principal.submit();">
	   <input type="hidden" name="DEFAULT_LOCATION" value=''>
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