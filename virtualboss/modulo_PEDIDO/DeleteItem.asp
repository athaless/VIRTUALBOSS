<!--#include file="../_database/athdbConn.asp"--><% 'ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_PEDIDO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<%
Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os �tens de formul�rio 
Const auxAVISO  = "dlg_warning.gif:ATEN��O!Voc� est� prestes a remover o registro <br> acima visualizado. Para confirmar clique no bot�o [ok], para desistir clique em [cancelar]."
' -------------------------------------------------------------------------------
	
	Dim objConn, objRS, strSQL
	Dim strCODIGO, strCOD_PEDIDO, Idx
	
	strCODIGO = GetParam("var_chavereg")
	strCOD_PEDIDO = GetParam("var_cod_pedido")
	
	If strCODIGO <> "" Then
	  AbreDBConn objConn, CFG_DB 
	  
	  strSQL = " SELECT * FROM NF_ITEM WHERE COD_NF_ITEM = " & strCODIGO
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
<%=athBeginDialog(WMD_WIDTH, "Pedido - Dele&ccedil;&atilde;o")%>
<% for Idx = 0 to objRS.fields.count - 1 'N�O TRAZER TODOS OS DADOS %> 
	<br><div class="form_label"><%=objRS.Fields(Idx).name%>:</div>
	<div class="form_bypass"><%=GetValue(objRS, objRS.Fields(Idx).name)%></div>
<% next %>
<form name="form_delete" action="DeleteItem_Exec.asp" method="post">
    <input type="hidden" name="var_chavereg" value="<%=strCODIGO%>">
	<input type="hidden" name="var_cod_pedido" value="<%=strCOD_PEDIDO%>">
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