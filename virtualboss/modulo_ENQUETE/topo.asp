<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
  Dim objConn, objRS, strSQL
  Dim strNome, strData, strStatus, strMes, strAno, staFirst
 
  AbreDBConn objConn, CFG_DB          
	
  strMes = month(date)
  if len(strMes) = 1 then
	strMes = "0" & strMes
	staFirst = true
  end if
  staFirst  = false
  strStatus = "REALIZADO"
  strAno    = Year(Date)
  strNome   = Request.Cookies("VBOSS")("ID_USUARIO")
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script type="text/javascript" language="JavaScript">
function ExecAcao(pr_form, pr_input) {
var form = eval('document.' + pr_form + '.' + pr_input);
	if (form.value=='INSERIR')  
	  {  parent.frames["vbMainFrame"].document.location.href = "Insert.asp";
		//window.open("Insert.asp","","width=600, height=425, left=30, top=30, scrollbars=1, status=0");
	  }else if (form.value=='QUESTAO'){
		 if (form.value=="QUESTAO") { document.form_alternativa.submit(); } 
	  }
		else
	  {  parent.frames["vbMainFrame"].document.location.href = "InsertCopia.asp?var_tipo=" + form.value;
		//window.open("InsertCopia.asp?var_tipo=" + form.value ,"","width=400,height=200,left=30,top=30,scrollbars=1,status=0"); 
	  }
	form.value='';
}
</script>
<script type="text/javascript" language="javascript" src="../_scripts/checkbox.js"></script>
</head>
<body onLoad="javascript:init();document.form_principal.submit();">
<form name="form_alternativa" method="get" target="vbNucleo" action="../modulo_ENQUETE_QUESTAO/default.htm"></form>
<table class="top_table" style="width:100%; height:58px; border:0px; margin:0px; padding:0px; vertical-align:top; border-collapse:collapse; ">
<tr> 
 	<td width="1%" class="top_menu" style="background-image:url(../img/Menu_TopBgLeft.jpg); vertical-align:top; padding:10px 0px 0px 10px;  border-collapse:collapse;">
	    <b><a href="Help.htm" target="vbMainFrame" title="sobre este módulo...">[?]&nbsp;</a><b>Enquetes</b>
		<%=montaMenuCombo("form_acoes","selNome","width:100px","ExecAcao(this.form.name,this.name);","INSERIR:INSERIR;QUESTAO:QUESTAO")%>
	</td>
	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
		<div class="form_line">
			<form name="form_principal" id="form_principal" method="get" action="<%=CFG_MAIN_GRID%>" target="vbMainFrame">
				<div class="form_label_nowidth">Título:</div><input name="var_titulo" type="text" size="20" class="edtext">
				<!-- Para diminuir ou eliminar a ocorrência de cahce passamso um parâmetro DUMMY com um número diferente 
				a cada execução. Isso força o navegador a interpretar como um request diferente a página,m evitando cache - by Aless 06/10/10 -->
				<input type="hidden" id="rndrequest" name="rndrequest" value="">
				<div onClick="document.form_principal.rndrequest.value=(new Date()).valueOf(); document.form_principal.submit();" class="btsearch"></div>
			</form>
	   </div>
	</td>
</tr>
</table>
</body>
</html>
<%
  FechaDBConn objConn 
%>