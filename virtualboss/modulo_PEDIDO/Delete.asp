<!--#include file="../_database/athdbConn.asp"--><% 'ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_PEDIDO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<%
Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os �tens de formul�rio 
Const auxAVISO  = "dlg_warning.gif:ATEN��O!Voc� est� prestes a remover o registro <br> acima visualizado. Para confirmar clique no bot�o [ok], para desistir clique em [cancelar]."
' -------------------------------------------------------------------------------
	
	Dim objConn, objRS, strSQL
	Dim strCODIGO, Idx, strMSG
	
	strCODIGO = GetParam("var_chavereg")
	
	If strCODIGO <> "" Then
	  AbreDBConn objConn, CFG_DB 
	  
	  strSQL = " SELECT * FROM NF_NOTA WHERE COD_NF = " & strCODIGO
      Set objRS = objConn.Execute(strSQL)
	  
      If Not objRS.Eof Then 
		strMSG = ""
		If GetValue(objRS, "SITUACAO") <> "ABERTO" Then strMSG = strMSG & "Pedido em situa��o diferente de aberto"
		
		If strMSG <> "" Then
			Mensagem strMSG, "Javascript:history.back();", "Voltar", 1
			Response.End()
		End If
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
<% for Idx = 0 to objRS.fields.count - 24 'N�O TRAZER TODOS OS DADOS %> 
	<br><div class="form_label"><%=objRS.Fields(Idx).name%>:</div>
	<div class="form_bypass"><%=GetValue(objRS, objRS.Fields(Idx).name)%></div>
<% next %>
<form name="form_delete" action="../_database/athDeleteToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="NF_NOTA">
    <input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
    <input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
    <input type="hidden" name="RECORD_KEY_NAME"  value="COD_NF">
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