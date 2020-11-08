<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_PONTO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<%
 Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "dlg_warning.gif:ATENÇÃO! Para deletar um registro, clique no ícone de lixeira do respectivo registro ou, para desistir clique em [cancelar]."
 ' -------------------------------------------------------------------------------

 Dim objConn, objRS, strSQL, strCOD_USUARIO, strCOD_DIA, strCOD_MES, strCOD_ANO, cont

 strCOD_USUARIO = GetParam("var_chavereg")
 strCOD_DIA	  	= GetParam("var_dia")
 strCOD_MES	  	= GetParam("var_mes")
 strCOD_ANO	  	= GetParam("var_ano")

 strSQL = "SELECT COD_PONTO, ID_USUARIO, DATA_DIA, DATA_MES, DATA_ANO, COD_EMPRESA, HORA_IN, HORA_OUT, OBS, STATUS" & _
		  " FROM PT_PONTO" & _
		  " WHERE ID_USUARIO = '" & strCOD_USUARIO & "'"& _ 
		  " AND DATA_DIA = " & strCOD_DIA & _
		  " AND DATA_MES = " & strCOD_MES & _
		  " AND DATA_ANO = " & strCOD_ANO  

 AbreDBConn ObjConn, CFG_DB

 set objRS = ObjConn.Execute(strSQL)

 if not objRS.EOF then 
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Reg. Horas - Deleção")%>

<!-- 
 - monta consulta para pegar todos os horários deste dia deste user
 - exibe os horários com lixo do lado
 - no lixo é um link para a delete_exec
-->
<%
cont = 1
while Not objRS.EOF 
%>
	<br><div class="form_label"><a href="delete_exec.asp?var_chavereg=<%=GetValue(objRS, "COD_PONTO")%>&var_empresa=<%=GetValue(objRS, "COD_EMPRESA")%>&var_dt_dia=<%=GetValue(objRS, "DATA_DIA")%>&var_dt_mes=<%=GetValue(objRS, "DATA_MES")%>&var_dt_ano=<%=GetValue(objRS, "DATA_ANO")%>&var_id_usuario=<%=GetValue(objRS, "ID_USUARIO")%>"><img src='../img/icolixo.gif' border='0' alt='remove o último registro inserido no dia'></a></div>
	<div class="form_bypass"><b>E/S <%=cont%> :&nbsp;</b></div><%=GetValue(objRS, "HORA_IN")%> - <%=GetValue(objRS, "HORA_OUT")%>
<%
	cont = cont + 1
	objRS.MoveNext
Wend 
%>
<%=athEndDialog(auxAVISO, "", "", "../img/butxp_cancelar.gif", "parent.frames['vbTopFrame'].document.form_principal.submit();", "", "")%>
</body>
</html>
<%
end if
 FechaRecordSet objRs
 FechaDBConn ObjConn
%>
