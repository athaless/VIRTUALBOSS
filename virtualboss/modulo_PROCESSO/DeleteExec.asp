<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_PROCESSO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<%
  Dim ObjConn, strCOD_PROCESSO, objRSCT, strSQL
  strCOD_PROCESSO = GetParam("var_chavereg")

  if strCOD_PROCESSO <> "" then 
    AbreDBConn ObjConn, CFG_DB

	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
    ObjConn.Execute("DELETE FROM PROCESSO_TAREFA WHERE COD_PROCESSO = " & strCOD_PROCESSO)
    ObjConn.Execute("DELETE FROM PROCESSO WHERE COD_PROCESSO = " & strCOD_PROCESSO)

	strSQL = "DELETE FROM PROCESSO_TAREFA WHERE COD_PROCESSO = " & strCOD_PROCESSO & vbnewline & vbnewline & "DELETE FROM PROCESSO WHERE COD_PROCESSO = " & strCOD_PROCESSO
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
	    athSaveLog "DEL", Request.Cookies("VBOSS")("ID_USUARIO"), "ROLLBACK PROCESSO_TAREFA e PROCESSO", strSQL

		Mensagem "modulo_PROCESSO.DeleteExec: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
		athSaveLog "DEL", Request.Cookies("VBOSS")("ID_USUARIO"), "COMMIT PROCESSO_TAREFA e PROCESSO", strSQL
	End If
	
    FechaDBConn ObjConn
  end if
%>
<script>
 parent.document.frames["vbTopFrame"].form_acoes.submit();
</script>