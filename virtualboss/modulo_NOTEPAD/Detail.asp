<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_CHAMADO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
' e o tamanho da coluna dos títulos dos inputs
Dim WMD_WIDTH, WMD_WIDTHTTITLES
WMD_WIDTH = 520
WMD_WIDTHTTITLES = 100
' -------------------------------------------------------------------------------

Dim strSQL, objRS, ObjConn, Cont
Dim strCODIGO, strTITULO, strTEXTO, strDATA, strSYSUSRINS 

strCODIGO = GetParam("var_chavereg")

AbreDBConn objConn, CFG_DB

strSql =          "SELECT COD_NOTEPAD, ID_USUARIO, TITULO, TEXTO, TIPO, SYS_DTT_INS "
strSql = strSql & "  FROM NOTEPAD"
strSql = strSql & " WHERE COD_NOTEPAD = " & strCODIGO

Set objRS = objConn.Execute(strSQL)

If Not objRS.Eof Then
	strTITULO		= Replace(GetValue(objRS, "TITULO"),"<ASLW_APOSTROFE>","'")
	strTEXTO		= Replace(GetValue(objRS, "TEXTO"),"<ASLW_APOSTROFE>","'")
	strDATA 		= GetValue(objRS,"SYS_DTT_INS")
	strDATA 		= (UCase(WeekDayName(WeekDay(strDATA),1)) & " - " ) & (PrepData(strDATA, True, False) & " " & DatePart("h",CDate(strDATA)) & ":" & DatePart("n",CDate(strDATA)))

	strSYSUSRINS   	= GetValue(objRS,"ID_USUARIO")

	strTITULO		= Replace(strTITULO, "''", "'")
	strTEXTO		= Replace(strTEXTO, "''", "'")
	
	strTITULO		= Replace(strTITULO,Chr(13),"<br>")
	strTEXTO		= Replace(strTEXTO,Chr(13),"<br>")
%>
<html>
<head>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <!-- Possibilidades de tipo de sort...
  class="sortable-date-dmy"
  class="sortable-currency"
  class="sortable-numeric"
  class="sortable"
 -->
 <thead>
   <tr> 
      <th width="150"></th>
      <th>Dados</th>
    </tr>
  </thead>
 <tbody style="text-align:left;">
	<tr> 
		<td align="right">Cod:&nbsp;</td>
		<td><%=strCODIGO%></td>
	</tr>
	<tr> 
		<td align="right">Título:&nbsp;</td>
		<td><%=strTITULO%></td>
	</tr>
	<tr> 
		<td align="right">Descrição:&nbsp;</td>
		<td><%=strTEXTO%></td>
	</tr>
	<tr> 
		<td align="right">Usuário:&nbsp;</td>
		<td><b><%=ucase(strSYSUSRINS)%></b><%="&nbsp;&nbsp;" & strDATA%></td>
	</tr>
 </tbody>
</table>
</body>
</html>
<%
End If

FechaRecordSet objRS
FechaDBConn objConn
%>
