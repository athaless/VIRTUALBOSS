<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<!--#include file="../_database/athUtils.asp"--> 
<%
  Dim objConn, objRS, strSQL, i, numerr, abouterr, aviso
  Dim strBgColor, strBgColorHEADER, strBgColorINFO1, strBgColorINFO2, strBgColorSUBTOTAL
  Dim strCOD_REL, strACAO, strDESCRICAO, strSQLRel
  Dim strNOME, strCATEGORIA, strTEXTO

  strNOME      = GetParam("var_nome")
  strCATEGORIA = GetParam("var_categoria")
  strTEXTO	   = strNOME
  If strCATEGORIA <> "" Then strTEXTO = strTEXTO & "  ( " & strCATEGORIA & " )"  End If

  strACAO      = GetParam("var_acao")
  strSQLRel    = GetParam("var_strParam") ' A consulta deve chegar com as TAGs do tipo (<ASLW_APOSTROFE>, etc...) 
  strDESCRICAO = GetParam("var_descricao")

  'athDEBUG strSQLRel, false
  '-------------------------------------------------------
  strSQLRel = RemoveTagSQL(strSQLRel) 'Aqui fazemos DecodeASLW
  '-------------------------------------------------------
  'athDEBUG strSQLRel, false

  AbreDBConn ObjConn, CFG_DB

  Sub ExibeMsg(StrAviso, StrDesc)
	response.write ("<p align='center'><font face='Arial' size='2'><b>.:: AVISO ::.</b></font></p>")
	response.write ("<p align='center'><font face='Arial' size='2'>" & StrAviso & "<br><br></font></p><hr>")
	response.write ("<p align='center'><table width='600' border='0'><tr><td><font face='Arial' size='2'>" & StrDesc & "</font></td></tr></table></p><hr>")	
	response.write ("<p align='right'><a href='JavaScript:history.back();location.reload();' target='_parent'><img src='../img/IconAction_PLAY.gif' border='0' alt='para executar novamente clique aqui'></a></p>")
	response.End
  End Sub
  
  if strACAO = ".xls" Or strACAO = ".doc" then
	Response.AddHeader "Content-Type","application/x-msdownload"
	Response.AddHeader "Content-Disposition","attachment; filename=Relatorio_" & Session.SessionID & "_" & Replace(Time,":","") & strACAO
  end if
  
  strBgColorHEADER   = "#CCCCCC" '"#FFCC66"
  strBgColorINFO1    = "#DAEEFA" '"#FFE8B7"
  strBgColorINFO2    = "#DAEEFA" '"#FFFFFF"
  strBgColorSUBTOTAL = "#DAEEFA" '"#FFD988"

  If strSQLRel <> "" Then
	On Error Resume Next
      Set objRS = Server.CreateObject("ADODB.Recordset")
      
      objRS.CursorType = adOpenStatic
      objRS.PageSize = CInt(3)
      objRS.Open strSQLRel, objConn
	  
	  Set objRS = objConn.Execute(strSQLRel)
	  
	  If Not objRS.Eof And Not objRS.Bof Then
	      'objRS.AbsolutePage = 1
		  'Apresenta erro de bookmark com mySQL
	
	      'Err.Raise 6
    	  numerr = Err.number
	      abouterr = Err.description
    	  If numerr <> 0 Then
	        aviso = "Warning number " & numerr & "<br>" & abouterr & "<br><br>Tipo de dado no parâmetro pode não ser compatível. Verifique na descrição do relatório as instruções sobre preenchimento adequado dos parâmetros da consulta. Para executar novamente utilize o ícone logo abaixo.<br><br>" 
			ExibeMsg aviso & "<br><textarea rows='5' cols='60'>" & strSQLRel & "</textarea>", strDescricao

			response.End()
	      End If
	  Else
		aviso = "Consulta não encontrou dados.<br><br><br>Favor avaliar consulta e/ou parâmetros. Verifique na descrição do relatório as instruções sobre preenchimento adequado dos parâmetros da consulta. Para executar novamente utilize o ícone logo abaixo.<br><br>" 
		ExibeMsg aviso, strDescricao
	  End If
%>
<html>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<script language="JavaScript" type="text/JavaScript">
function Executa() {
  if (document.formASLAction.var_acao.value == 'printall') { print(); } else { document.formASLAction.submit(); }
}
</script>
<head>
<title></title>
<% if strACAO="" then %>
  <link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<% end if %>
</head>
<% if strACAO="" then %>
<!-- 
  COMO estav com problemas no funcionamento da exportação EXCEL/WORD, só fazia sentido ter ativa 
  a opção de imprimir, mas neste caso a impressão é exatametne a mesma co "Ctrl+P", log não faz 
  sentido ter essa opção também, por enquanto
  -----------------------------------------------------------------------------------------------
<div style="text-align:left; padding-left:10px;" align="left">
<form name="formASLAction" id="formASLAction" action="ResultASLW.asp" method="POST" target="_self">
	<input type="hidden" name="var_nome"	  id="var_nome"			value="<%=strNOME%>">
	<input type="hidden" name="var_categoria" id="var_categoria"	value="<%=strCATEGORIA%>">
	<input type="hidden" name="var_strParam"  id="var_strParam"		value="<%=strSQL%>">
	<input type="hidden" name="var_descricao" id="var_descricao"	value="<%=strDESCRICAO%>">
	<select name="var_acao" onChange="javascript:Executa();" class="edtext" style="height:20px;">
		<option value="" selected>Selecione...</option>
		<option value="printall">Imprimir</option>
		<option value=".xls">Exportar para Excel</option>
		<option value=".doc">Exportar para Word</option>
	</select>
</form>
</div 
//-->
<% end if %>
<div style=" text-align:left; padding-left:10px;padding-top:3px; margin-bottom:15px;"><b><%=strTEXTO%></b></div>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <thead>
  <tr>
	<%
	For i=0 to objRS.fields.count - 1
	  Response.Write("<th class='sortable'>" & objRS.Fields(i).Name & "</b></th>")
	Next
	%>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%	
    Dim strCOLOR
  	strCOLOR = "#FFFFFF"
	Do While Not objRS.EOF
        'if ((strCOLOR = "#FFFFFF")=0) then strCOLOR = "#F5FAFA" else strCOLOR = "#FFFFFF" end if
		'Response.Write("<tr bgcolor='" & strCOLOR & "' valign='top' align='left'>")
		'For i = 0 to objRS.fields.count - 1
	    '	Response.Write("<td bgcolor='" & strBgColor & "' class='inputclean'>" & Server.HTMLEncode(objRS.Fields(i).Value&"") & "</td>")
		'Next
		'Response.Write("</tr>")

		Response.Write("<tr>" & vbNewLine)
		For i=0 to objRS.fields.count - 1
	    	'Response.Write("<td class='inputclean'>" & Server.HTMLEncode(CStr(objRS.Fields(i).Value)) & "</td>")
			Response.Write("<td>" & Server.HTMLEncode(GetValue(objRS, objRS.Fields(i).Name)) & "</td>" & vbNewLine)
		Next
		Response.Write("</tr>" & vbNewLine)
		
	   	athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
	Loop
%>

 </tbody>  
</table>
</body>
</html>
<%
	End If
	FechaRecordSet ObjRS
 FechaDBConn ObjConn
%>
