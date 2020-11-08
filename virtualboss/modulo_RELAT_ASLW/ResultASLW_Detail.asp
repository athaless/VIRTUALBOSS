<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<!--#include file="../_database/athUtils.asp"--> 
<%
  Dim objConn, objRS, strSQL, i, numerr, abouterr, aviso
  Dim strBgColor, strBgColorHEADER, strBgColorINFO1, strBgColorINFO2, strBgColorSUBTOTAL
  Dim strCOD_REL, strACAO, strDESCRICAO, strSQLRel
  
  strACAO      = GetParam("var_acao")
  strSQLRel    = GetParam("var_strParam") ' A consulta deve chegar com as TAGs do tipo (<ASLW_APOSTROFE>, etc...) 
  strDESCRICAO = GetParam("var_descricao")

  'Aqui fazemos DecodeASLW
  '-------------------------------------------------------
  strSQLRel = RemoveTagSQL(strSQLRel)
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
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<head>
<title></title>
<% if strACAO="" then %>
  <link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<% end if %>
</head>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <thead>
  <tr>
   <%
	For i = 0 to objRS.fields.count - 1
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
        if ((strCOLOR = "#FFFFFF")=0) then strCOLOR = "#F5FAFA" else strCOLOR = "#FFFFFF" end if
		
		Response.Write("<tr bgcolor='" & strCOLOR & "' valign='top' align='left'>")
		For i = 0 to objRS.fields.count - 1
			Response.Write("<td bgcolor='" & strBgColor & "' class='inputclean'>" & Server.HTMLEncode(objRS.Fields(i).Value&"") & "</td>")
		Next
		Response.Write("</tr>")
		
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
