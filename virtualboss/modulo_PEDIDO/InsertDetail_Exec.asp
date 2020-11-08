<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
 Dim strSQL, objRS, objRSCT, ObjConn
 Dim objRS1, objRS2
 Dim strCODIGO, strCOD_SERVICO, strTITULO, strDESCRICAO, strVALOR, strTOTAL
 
 strCODIGO        = GetParam("var_cod_pedido")
 strCOD_SERVICO   = GetParam("var_cod_servico")
 strTITULO        = GetParam("var_nome")
 strDESCRICAO     = GetParam("var_descricao")
 strVALOR	      = GetParam("var_valor")

 If strCODIGO = "" Or strCOD_SERVICO = "" then
   Response.write("<p align='center'>Favor rever parâmetros<br><a onClick='history.go(-1);' style='cursor:hand; font-face:Verdana;'>Voltar<a></p>")
   Response.End()
 End If

 AbreDBConn objConn, CFG_DB 
 
 If IsNumeric(strVALOR) Then strVALOR = CDbl("0" & strVALOR) Else strVALOR = 0 End If
 strVALOR = FormataDouble(FormataDecimal(strVALOR, 2))
 
 strSQL =          " INSERT INTO NF_ITEM (COD_NF, COD_SERVICO, TIT_SERVICO, DESC_SERVICO, VALOR) " 
 strSQL = strSQL & " VALUES (" & strCODIGO & ", " & strCOD_SERVICO & ", '" & strTITULO & "', '" & strDESCRICAO & "', " & strVALOR & ") " 
 
 'AQUI: NEW TRANSACTION
 set objRSCT  = objConn.Execute("start transaction")
 set objRSCT  = objConn.Execute("set autocommit = 0")
 objConn.Execute(strSQL) 
 If Err.Number <> 0 Then
	set objRSCT = objConn.Execute("rollback")
	Mensagem "modulo_PEDIDO.InsertDetail_Exec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	Response.End()
 else
	set objRSCT = objConn.Execute("commit")
 End If
 
 strSQL = " SELECT SUM(VALOR) AS TOTAL FROM NF_ITEM WHERE COD_NF = " & strCODIGO
 
 Set objRS = objConn.Execute(strSQL) 
 If Not objRS.Eof Then strTOTAL = CDbl("0" & GetValue(objRS, "TOTAL"))
 FechaRecordSet objRS
 
 If IsNumeric(strTOTAL) Then 
 	strTOTAL = FormataDouble(FormataDecimal(strTOTAL, 2))
 Else
 	strTOTAL = "Null"
 End If
 
 'strVALOR = FormataDouble(FormataDecimal(strVALOR, 2))
 
 strSQL = " UPDATE NF_NOTA SET TOT_SERVICO = " & strTOTAL & " WHERE COD_NF = " & strCODIGO 

 'AQUI: NEW TRANSACTION
 set objRSCT  = objConn.Execute("start transaction")
 set objRSCT  = objConn.Execute("set autocommit = 0")
 objConn.Execute(strSQL) 
 If Err.Number <> 0 Then
	set objRSCT = objConn.Execute("rollback")
	Mensagem "modulo_PEDIDO.InsertDetail_Exec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	Response.End()
 else
	set objRSCT = objConn.Execute("commit")
 End If
 
 FechaDBConn objConn
%>
<script language="JavaScript">
	parent.location ='<%="Detail.asp?var_chavereg=" & strCODIGO%>';
</script>
