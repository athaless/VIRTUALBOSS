<!--#include file="../_database/athdbConn.asp"--><% 'ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_RELAT_ASLW", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<%
	' Tamanho(largura) da moldura gerada ao redor da tabela dos �tens de formul�rio 
	' e o tamanho da coluna dos t�tulos dos inputs
	Dim WMD_WIDTH, WMD_WIDTHTTITLES
	WMD_WIDTH = 580
	WMD_WIDTHTTITLES = 150
	' -------------------------------------------------------------------------------
	
	Dim objConn, objRS, strSQL, auxAVISO
	Dim strCODIGO, Idx
	
	strCODIGO = GetParam("var_chavereg")
	auxAVISO  = "dlg_warning.gif:ATEN��O!Voc� est� prestes a remover o registro <br> acima visualizado." &_ 
				"Para confirmar clique no bot�o [ok], para desistir clique em [cancelar]."

   strCODIGO = GetParam("var_chavereg")
	
   If strCODIGO <> "" Then
	  AbreDBConn objConn, CFG_DB 
	  
	  strSQL = "SELECT * FROM ASLW_RELATORIO WHERE COD_RELATORIO = " & strCODIGO 
      Set objRS = objConn.Execute(strSQL)

      If Not objRS.Eof Then 
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Fun��es de a��o dos bot�es - In�cio ******
function ok()       { document.form_delete.submit(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
//****** Fun��es de a��o dos bot�es - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Cargos - Dele&ccedil;&atilde;o")%>
     <table width="100%" border="0" cellpadding="1" cellspacing="0" align="center">
        <% for Idx = 0 to objRS.fields.count - 6 'N�O TRAZER TODOS OS DADOS %> 
        <tr> 
          <td width=<%=WMD_WIDTHTTITLES%> style="text-align:right"><%=objRS.Fields(Idx).name%>:&nbsp;</td>
          <td><%=GetValue (objRS, objRS.Fields(Idx).name)%>&nbsp;</td>
        </tr>
        <% next %>
     </table>
	 <form name="form_delete" action="../_database/athDeleteToDB.asp" method="post">
       <input type="hidden" name="DEFAULT_TABLE"    value="ASLW_RELATORIO">
       <input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
       <input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
       <input type="hidden" name="RECORD_KEY_NAME"  value="COD_RELATORIO">
       <input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODIGO%>">
       <input type="hidden" name="JSCRIPT_ACTION"   value="parent.frames['vbTopFrame'].document.form_principal.submit();">
	   <input type="hidden" name="DEFAULT_LOCATION" value=''>
     </form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok()", "../img/butxp_cancelar.gif", "cancelar();", "", "")%>
</body>
</html>
<%
      End If 
      FechaRecordSet objRS
	  FechaDBConn objConn
   End If 
%>