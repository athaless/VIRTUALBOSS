<!--#include file="../_database/athdbConn.asp"--><%' ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_ADM_CARGOS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 150 'Tamanho(largura) da Dialog gerada para conter os �tens de formul�rio 

	Dim objConn, objRS, strSQL
	Dim strCODIGO, Idx
	
	AbreDBConn objConn, CFG_DB 
	
	strCODIGO = GetParam("var_chavereg")
	
	If strCODIGO <> "" Then
		strSQL = " SELECT * FROM ADM_CARGO WHERE COD_CARGO = " & strCODIGO
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		
		If Not objRS.Eof Then
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/tablesort.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Fun��es de a��o dos bot�es - In�cio ******
function ok() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
//****** Fun��es de a��o dos bot�es - Fim ******
</script>
</head>
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
        <% for Idx = 0 to objRS.fields.count - 6 'N�O TRAZER TODOS OS DADOS %> 
        <tr> 
          <td width="<%=WMD_WIDTH%>" style="text-align:right"><%=objRS.Fields(Idx).name%>:&nbsp;</td>
          <td><%=Replace(Replace(GetValue(objRS, objRS.Fields(Idx).name),"<ASLW_APOSTROFE>","'"),CHR(13),"<br>")%>&nbsp;</td>
        </tr>
        <% next %>
  </tbody>
</table>
</body>
</html>
<%
		End If
		FechaRecordSet objRS
	End If
	FechaDBConn objConn
%>
