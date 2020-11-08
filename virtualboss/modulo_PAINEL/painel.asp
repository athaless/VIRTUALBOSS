<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
 Response.Expires = -1
 
 Dim objConn, strSQL, strEntCliRef, strSQLCombo, objRS
 Dim auxCont, auxSTR
 Dim strBGCOLOR1, strBGCOLOR2, strBGCOLOR3, strBGCOLOR4, strBGCOLOR5, strBGCOLOR6 
 Dim strUSER_ID, strDIA_SEL1, strDIA_SEL2, strVIEW, strPARAMS
 Dim intTamNew
 Dim bUpdTODO, bInsRespTODO
 Dim strGRUPOS, strGRUPO_USUARIO, strCOOKIE_ID_USUARIO
 Dim strDT_INI, strHORAS, strWeekDay
 Dim strDT_ENVIO, strTELA, strSEMANA
 Dim datePrinc, dateArray, intDiaSemana, intAux, totalHoraArray
 Dim arrDias, arrHoras, arrHorasPrev, arrEmpresasPrev
 Dim strVAL1, strVAL2, strVAL3
 Dim strEMPRESA
 Dim strESCALA_FATOR, strESCALA_REGUA, strFOTO
 Dim strTPNote, strIDADE
 Dim strULTIMAS
 Dim strCOD_PROJETO, strCOD_PROJETO_Old
 Dim strCOD_BS, strCOD_BS_Old
 Dim strCOD_TODOLIST
 Dim matRS()
 Dim intTAMlin, intTAMcol
 Dim i,strUSUARIO, strEXIBE_ENQUETE, strTIPO_ENTIDADE
 
 strBGCOLOR1 = "#DADCD9" 'Borda da linha da tabela 
 strBGCOLOR2 = "#F7F7F7" 'Fundo do cabeçalho 
 strBGCOLOR3 = "#F7F7F7" 'Fundo das linhas 
 strBGCOLOR4 = "#FFFFFF" 'Fundo das linhas 
 strBGCOLOR5 = "#E7E7E7" 
 strBGCOLOR6 = "#000000" 
 
 const PRJ_COD  = 0
 const PRJ_TIT  = 1
 const PRJ_FASE = 2
 
 const ATIV_COD        = 3
 const ATIV_TIT        = 4
 const ATIV_COD_CLI    = 5
 const ATIV_CLI        = 6
 const ATIV_RESP       = 7
 const ATIV_SIT        = 8
 const ATIV_DT_INI     = 9
 const ATIV_DT_FIM     = 10
 const ATIV_PREV_HORAS = 11
 const ATIV_HORAS      = 12
 const ATIV_NA_EQUIPE  = 13
 const ATIV_TIPO       = 14
 
 const TASK_COD    = 15
 const TASK_TIT    = 16
 const TASK_RESP   = 17
 const TASK_EXEC   = 18
 const TASK_CATEG  = 19
 const TASK_DT_INI = 20
 const TASK_HR_INI = 21
 const TASK_HORAS  = 22
 const TASK_SIT    = 23
 const TASK_PRIO   = 24
 
 AbreDBConn objConn, CFG_DB
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script>
function ReloadPage() {
  document.form_painel.submit();
}
function ReloadChamados(prObj) {
  var myform,myinput;
  
  myform=document.getElementById("form_chamados");
  myform.var_cod_cli.value = prObj.value;
  myform.submit();
}

</script>
</head>
<body>
	<div style="padding-top:4px;">
	<form name="form_chamados" id="form_chamados" target="iframe_chamados" action="../modulo_CHAMADO/chamados.asp">
		<input type="hidden" name="var_cod_cli" id="var_cod_cli" value="">
	</form>
	<form name="form_painel" method="post" action="painel.asp">
		<input type="hidden" name="var_dia_selected" id="var_dia_selected" value="<%=strDIA_SEL1%>">
		<table width="99%" align="center" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td width="5" height="100%">&nbsp;</td>
				<td width="164" height="100%" valign="top">
					<!--#include file="../_include/_IncludePainel_Enquete.asp"-->
					<!--#include file="../_include/_IncludePainel_Mensagens.asp"-->
					<!--#include file="../_include/_IncludePainel_Alerts.asp"-->
					<!--#include file="../_include/_IncludePainel_Aniversarios.asp"-->
					<% strTPNote = "LEFT" 'Filtra as notas exibidas no painel abaixo %>
					<!--#include file="../_include/_IncludePainel_Notepad.asp"-->
					<!--#include file="../_include/_IncludePainel_TodoOcupacao.asp"-->
					<!--#include file="../_include/_IncludePainel_TodoFechados.asp"-->
					<!--#include file="../_include/_IncludePainel_ToDoEvaluated.asp"-->
				</td>
				<td width="5" height="100%">&nbsp;</td>
				<td width="96%" height="100%" valign="top">
					<% strTPNote = "TOP" 'Filtra as notas exibidas no painel abaixo %>
					<!--#include file="../_include/_IncludePainel_Notepad.asp"-->
					<!--#include file="../_include/_IncludePainel_Contratos.asp"-->
					<!--#include file="../_include/_IncludePainel_ChamadosAbertos.asp"-->
					<!--#include file="../_include/_IncludePainel_ManagerList.asp"-->
					<!--#include file="../_include/_IncludePainel_GrafOcupacao.asp"--><br>
					<% strTPNote = "BOTTOM" 'Filtra as notas exibidas no painel abaixo %>
					<!--#include file="../_include/_IncludePainel_Notepad.asp"-->
				  </td></tr>
				</td>
				<td width="5" height="100%">&nbsp;</td>
			</tr>
		</table>
	</form>
	</div>
</body>
</html>
<%
  FechaDBConn objConn
%>