<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
 Dim strSQL, objRS, objRSCT, ObjConn
 Dim objRS1, objRS2
 Dim strCODIGO, strCOD_PEDIDO, strTOTAL
 
 strCODIGO = GetParam("var_chavereg")
 strCOD_PEDIDO = GetParam("var_cod_pedido")

 If strCODIGO = "" Or strCOD_PEDIDO = "" then
   Response.write("<p align='center'>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
   Response.End()
 End If

 AbreDBConn objConn, CFG_DB 
 
 strSQL = " DELETE FROM NF_ITEM WHERE COD_NF_ITEM = " & strCODIGO

 'AQUI: NEW TRANSACTION
 set objRSCT  = objConn.Execute("start transaction")
 set objRSCT  = objConn.Execute("set autocommit = 0")
 objConn.Execute(strSQL) 
 If Err.Number <> 0 Then
	set objRSCT = objConn.Execute("rollback")
	Mensagem "modulo_PEDIDO_OLD.DeleteItem_Exec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	Response.End()
 else
	set objRSCT = objConn.Execute("commit")
 End If
 
 strSQL = " SELECT SUM(VALOR) AS TOTAL FROM NF_ITEM WHERE COD_NF = " & strCOD_PEDIDO
 
 Set objRS = objConn.Execute(strSQL) 
 If Not objRS.Eof Then strTOTAL = CDbl("0" & GetValue(objRS, "TOTAL"))
 FechaRecordSet objRS
 
 If IsNumeric(strTOTAL) Then 
 	strTOTAL = FormataDouble(FormataDecimal(strTOTAL, 2))
 Else
 	strTOTAL = "Null"
 End If
 
 strSQL = " UPDATE NF_NOTA SET TOT_SERVICO = " & strTOTAL & " WHERE COD_NF = " & strCOD_PEDIDO 
 
 'AQUI: NEW TRANSACTION
 set objRSCT  = objConn.Execute("start transaction")
 set objRSCT  = objConn.Execute("set autocommit = 0")
 objConn.Execute(strSQL) 
 If Err.Number <> 0 Then
	set objRSCT = objConn.Execute("rollback")
	Mensagem "modulo_PEDIDO_OLD.DeleteItem_Exec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	Response.End()
 else
	set objRSCT = objConn.Execute("commit")
 End If
 
 FechaDBConn objConn
%>
<script language="JavaScript">
	parent.location ='<%="Detail.asp?var_chavereg=" & strCOD_PEDIDO %>';
</script>
