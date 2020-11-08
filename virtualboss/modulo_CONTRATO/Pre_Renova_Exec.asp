<!--#include file="../_database/athdbConn.asp"-->
<%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->

<%
  Dim objConn, objRS, strSQL
  Dim strCODIGO, strLOCATION,  strACAO, strID_USUARIO 
  
  strCODIGO     = GetParam("var_cod_contrato")
  strACAO       = GetParam("acao_renova"     )  '(renovar,cancelar)
  strLOCATION   = GetParam("DEFAULT_LOCATION")  
  strID_USUARIO = Request.Cookies("VBOSS")("ID_USUARIO")
    
  
  If strACAO = "renovar" Then
    'Passa para a página de renovação de contrato
	Response.Redirect("Renova.asp?var_chavereg=" & strCODIGO)
  ElseIf strACAO = "cancelar" Then  
    'Desmarca flag RENOVAVEL
    AbreDBConn objConn, CFG_DB 	   
	'NEW TRANSACTION
	set objRS  = objConn.Execute("start transaction")
	set objRS  = objConn.Execute("set autocommit = 0")	
	strSQL = "UPDATE CONTRATO SET TP_RENOVACAO = 'NAO_RENOVAVEL' WHERE COD_CONTRATO = " & strCODIGO
    AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	If Err.Number <> 0 Then
		set objRS = objConn.Execute("rollback")
    	athSaveLog "UPD", strID_USUARIO, "ROLLBACK CANC REN CONTRATO", strSQL
		Mensagem "modulo_CONTRATO.renova_exec A: " & Err.Number & " - "& Err.Description , strLOCATION, 1, True
		Response.End()
	else
	    athSaveLog "UPD", strID_USUARIO, "COMMIT CANC REN CONTRATO", strSQL
		set objRS = objConn.Execute("commit")
	End If	
    FechaDBConn objConn
    %>		
	<script>
      parent.frames["vbTopFrame"].document.form_principal.submit();
    </script>
    <%
  End If
%>