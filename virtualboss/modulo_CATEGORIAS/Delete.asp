<!--#include file="../_database/athdbConn.asp"--><%'-- ATEN��O: language, option explicit, etc... est�o no athDBConn --%>
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_CATEGORIAS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<%
Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os �tens de formul�rio 
Const auxAVISO  = "dlg_warning.gif:ATEN��O!Voc� est� prestes a remover o registro <br> acima visualizado. Para confirmar clique no bot�o [ok], para desistir clique em [cancelar]."
' -------------------------------------------------------------------------------

   Dim ObjConn, objRS, strSQL
   Dim strCODIGO, strTABELA, strCATEGORIA_NAME
   
   strCODIGO = GetParam("var_chavereg")
   strTABELA = GetParam("var_table")

if strCODIGO<> "" and strTABELA<>"" then
	
	select case strTABELA	
		case "AG_" 			strCATEGORIA_NAME = "Agenda"
		case "CH_"          strCATEGORIA_NAME = "Chamados"
		case "PROCESSO_"	strCATEGORIA_NAME = "Processos"		
		case "ASLW_"		strCATEGORIA_NAME = "Relat�rios"		
		case "SV_"			strCATEGORIA_NAME = "Servi�os"
		case "PT_FOLGA_"	strCATEGORIA_NAME = "Folgas"
		case "TL_"			strCATEGORIA_NAME = "Tarefas"
		case "BS_"			strCATEGORIA_NAME = "Atividades"		
		case "PRJ_"			strCATEGORIA_NAME = "Projetos"
		case "MB_LIVRO_"	strCATEGORIA_NAME = "Livros"
		case "MB_REVISTA_"	strCATEGORIA_NAME = "Revistas"
		case "MB_MANUAL_"	strCATEGORIA_NAME = "Manuais"
		case "MB_VIDEO_"	strCATEGORIA_NAME = "V�deos"
		case "MB_DISCO_"	strCATEGORIA_NAME = "Discos"
		case "MB_DADO_"	    strCATEGORIA_NAME = "Dados"
	end select

	AbreDBConn objConn, CFG_DB 
	strSQL = "SELECT NOME, DESCRICAO FROM " & strTABELA & "CATEGORIA WHERE COD_CATEGORIA=" & strCODIGO
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
	if not objRS.eof then
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
</head>
<script language="javascript" type="text/javascript">
//****** Fun��es de a��o dos bot�es - In�cio ******
function ok()       { document.form_delete.submit(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
//****** Fun��es de a��o dos bot�es - Fim ******
</script>
<body>
<%=athBeginDialog(WMD_WIDTH, "Categoria " & strCATEGORIA_NAME & " - Exclus�o")%>
      <div class="form_label">Cod:</div><div class="form_bypass"><%=strCODIGO%></div>
  <br><div class="form_label">Categoria:</div><div class="form_bypass"><%=GetValue(objRS,"NOME")%></div>
  <br><div class="form_label">Descri��o:</div><div class="form_bypass"><%=GetValue(objRS,"DESCRICAO")%></div>
  <form name="form_delete" action="../_database/athDeleteToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="<%=strTABELA%>CATEGORIA">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_CATEGORIA">
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