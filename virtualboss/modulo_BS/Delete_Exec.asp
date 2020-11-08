<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
Dim ObjConn, objRS, strSQL
Dim strCODTL, strCODIGO, strTIPO, strMes

strCODTL  = GetParam("var_cod_todo")
strCODIGO = GetParam("var_cod_boletim")
strTIPO	  = "&var_todolist=" & GetParam("var_todolist")

strMes = month(date)
if len(strMes)=1 then strMes="0" & strMes

if GetParam("var_exclui_bs") and (strCODIGO<>"") then
	AbreDBConn ObjConn, CFG_DB
	
	'DELETE FROM TL_RESPOSTA WHERE COD_TL_RESPOSTA IN
	'(SELECT R.COD_TL_RESPOSTA FROM TL_RESPOSTA R, TL_TODOLIST T
	' WHERE R.COD_TODOLIST = T.COD_TODOLIST
	' AND T.COD_BOLETIM = XXX)
	'
	'Da forma acima não funciona no mySQL porque a tabela onde será feita a deleção está nos dois SQLs
	'You can't specify target table 'PageLog' for update in FROM clause
	'
	'Maiores informações em http://dev.mysql.com/doc/refman/5.1/en/update.html
	'
	'Com base na página acima reescrevi o SQL dessa forma
	'
	'DELETE FROM TL_RESPOSTA WHERE COD_TL_RESPOSTA IN 
	'(
	' SELECT CODIGO FROM 
	' (
	'  SELECT TL_RESPOSTA.COD_TL_RESPOSTA AS CODIGO 
	'  FROM TL_RESPOSTA, TL_TODOLIST 
	'  WHERE TL_RESPOSTA.COD_TODOLIST = TL_TODOLIST.COD_TODOLIST 
	'  AND TL_TODOLIST.COD_BOLETIM = XXX
	' ) AS TEMP
	')
	'
	'O SQL acima estava dando esse erro quando executado
	'Lock wait timeout exceeded
	'
	'http://lists.mysql.com/mysql/190026
	'http://support.microsoft.com/default.aspx?scid=kb;en-us;239924
	'
	'Então fiz da maneira mais "tosca" e simples
	
	strSQL =          " SELECT TL_RESPOSTA.COD_TL_RESPOSTA "
	strSQL = strSQL & "   FROM TL_RESPOSTA, TL_TODOLIST "
	strSQL = strSQL & "  WHERE TL_RESPOSTA.COD_TODOLIST = TL_TODOLIST.COD_TODOLIST "
	strSQL = strSQL & "    AND TL_TODOLIST.COD_BOLETIM = " & strCODIGO
	
	'Set objRS = objConn.Execute(strSQL)
	'Só que não pode rodar com objConn.Execute, tem que ser com AbreRecordSet
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	Do While Not objRS.Eof
		strSQL = " DELETE FROM TL_RESPOSTA WHERE COD_TL_RESPOSTA = " & GetValue(objRS, "COD_TL_RESPOSTA")
		objConn.Execute(strSQL)
		objRS.MoveNext
	Loop
	FechaRecordSet objRS
	
	strSQL = " DELETE FROM TL_TODOLIST WHERE COD_BOLETIM = " & strCODIGO
	objConn.Execute(strSQL)
	
	strSQL = " DELETE FROM BS_BOLETIM WHERE COD_BOLETIM = " & strCODIGO
	objConn.Execute(strSQL)

	FechaDBConn ObjConn
	%>
	<script>
		parent.frames["vbTopFrame"].document.form_principal.submit();
	</script>
	<%
	'Response.Redirect("main.asp?var_situacao=_FECHADO&var_mes="& strMes &"&var_modelo=_MODELO&var_executor="& Request.Cookies("VBOSS")("ID_USUARIO") &"&var_checkeqp=true&var_checkresp=true")
elseif strCODIGO <> "" then   
	AbreDBConn ObjConn, CFG_DB
	
	strSQL = " DELETE FROM TL_TODOLIST WHERE COD_TODOLIST = " & strCODTL
	objConn.Execute(strSQL)
	
	FechaDBConn ObjConn	
	Response.Redirect("Update.asp?var_chavereg=" & strCODIGO & strTIPO)
end if

%>





