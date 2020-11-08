<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_RELAT_ASLW", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"
	
	Dim objConn, objRS, strSQL
	Dim queryType, criteria, strTABLE, i, rsSchema, auxStr
	
	AbreDBConn objConn, CFG_DB 
	
	strTABLE = GetParam("var_table")
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
//****** Funções de ação dos botões - Início ******
function ok()			{ document.form_tables.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar()		{ parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()      { document.form_tables.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_tables.var_table.value == '') var_msg += '\nNome';
	
	if (var_msg == ''){
		document.form_tables.submit();
	} else{
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
	}
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Relatório - Ver Tabelas") %>
<form name="form_tables" action="ViewTables.asp" method="post">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='ViewTables.asp'>
	<div class="form_label">Tabela:</div>
      <select name="var_table" class="edtext_combo" style="10">
      <%
	    ' UMA MANEIRA - ACESS/MDB e mySQL
		Set objRS = CreateObject("ADODB.Recordset")
		Set objRS = objConn.OpenSchema(adSchemaTables)

		Do Until objRS.EOF
    	  if (objRS.Fields.Item("TABLE_TYPE")="TABLE") then 
            auxStr = "<option value='" & objRS.Fields.Item("TABLE_NAME") & "'" 
			if (objRS(2)=strTABLE) then auxStr = auxStr & "selected"
    	    auxStr = auxStr & ">" & objRS.Fields.Item("TABLE_NAME") & "</option>"
            Response.Write (auxStr)
		  end if
		  objRS.MoveNext
		Loop
        response.write("<br>" & strTABLE)

	    ' UMA MANEIRA - SQLSERVER
        'queryType = adSchemaTables
        'criteria  = Array(CFG_DB,Empty,Empty,"TABLE")
        'set objRS = objConn.OpenSchema(queryType, criteria)
        'while not objRS.EOF
        '  auxStr = "<option value='" & objRS(2) & "'" 
    	'  if (objRS(2)=selTable) then auxStr = auxStr & "selected"
    	'  auxStr = auxStr & ">" & objRS(2) & "</option>"
        '  Response.Write (auxStr)
        '  objRS.movenext
        'wend
        'response.write("<br>" & selTable)
      %>
      </select>
	<br><div class="form_label">&nbsp;</div><div><%
       if (strTABLE<>"") then
  	     strSQL = "SELECT * FROM " & strTABLE
         FechaRecordSet objRS
         set objRS = objConn.Execute(strSQL)
	     if not objRS.EOF then
	        'response.write(objRS.fields(0).name & "<br>")
			Response.Write("SELECT " & "<br>") 
            for i = 0 to objRS.fields.count - 1
              Response.Write("&nbsp;&nbsp;&nbsp;")
			  if i>0 then Response.Write(",") 
			  Response.Write("<b>" & objRS.Fields(i).name & "</b><br>") 
            next
			Response.Write("FROM " & "<BR>&nbsp;&nbsp;&nbsp;" & strTABLE & "<br>") 
         end if
       end if	   
      %></div>
</form>
<%=athEndDialog(auxAVISO, "", "", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>
<%
FechaDBConn ObjConn
%>

