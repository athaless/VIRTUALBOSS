<!--#include file="../_database/athdbConn.asp"--><%' ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
 Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_CHAMADO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
 <!--#include file="../_database/athUtils.asp"-->
<%
 Dim objConn, objRS, strSQL, strSQLClause
 Dim strAviso, strCOLOR
 Dim strTITULO, strSITUACAO, strRESPONSAVEL, strPRIORIDADE, strCLIENTE, strSOLICITANTE, strCODCHAMADO, strCODTODOLIST, strEXTRA', strENT_CLI_REF
 Dim strCOD_CATEGORIA, strUSER_ID, strCH_RESP, strCH_EXEC, auxStr
 Dim strDT_INI, strDT_FIM, strDIA, strMES, strANO, strHORAS, strPREV_HORAS
 Dim bViewTODO, bUpdTODO, bInsRespTODO, bCopiaTODO, bUpdAllTODO
 Dim strArquivo
 Dim strEvalObs
 
 strAviso = "N�o h� dados para a consulta solicitada.<br>Verifique os par�metros de filtragem e tente novamente."
 
 strCOD_CATEGORIA	= GetParam("var_cod_categoria")
 strSITUACAO		= GetParam("var_situacao")
 strCLIENTE			= GetParam("var_cliente")
 strTITULO			= GetParam("var_titulo")
 strSOLICITANTE		= GetParam("var_solicitante")
 strCODCHAMADO		= GetParam("var_cod_chamado")
 strCODTODOLIST     = GetParam("var_cod_todolist")
 strEXTRA           = GetParam("var_extra")

 'strENT_CLI_REF     = GetParam("var_ent_ref_cli") PODE receber nesta variavel os c�digos dos clientes que o usu�rio pode ver chamados
 
 strUSER_ID = LCase(Request.Cookies("VBOSS")("ID_USUARIO"))
 
 bInsRespTODO = VerificaDireito("|INS_RESP|", BuscaDireitosFromDB("modulo_TODOLIST", strUSER_ID), false)
 
 AbreDBConn objConn, CFG_DB 
 
 strSQL =          " SELECT T1.COD_CHAMADO "
 strSQL = strSQL & "      , T1.TITULO "
 strSQL = strSQL & "      , T1.PRIORIDADE "
 strSQL = strSQL & "      , T1.SITUACAO "
 strSQL = strSQL & "      , T1.ARQUIVO_ANEXO "
 strSQL = strSQL & "      , T1.COD_TODOLIST "
 strSQL = strSQL & "      , T1.EXTRA "
 strSQL = strSQL & "      , T1.SYS_DTT_INS "
 strSQL = strSQL & "      , T1.SYS_ID_USUARIO_INS "
 strSQL = strSQL & "      , T1.SYS_DTT_UPD "
 strSQL = strSQL & "      , T1.SYS_ID_USUARIO_UPD "
 strSQL = strSQL & "      , T2.NOME AS CATEGORIA "
 strSQL = strSQL & "      , T3.PREV_DT_INI "
 strSQL = strSQL & "      , T3.SITUACAO AS TODO_SITUACAO "
 strSQL = strSQL & "      , T4.NOME_COMERCIAL AS CLIENTE "
 strSQL = strSQL & "      , T3.ID_RESPONSAVEL "
 strSQL = strSQL & "      , T3.ID_ULT_EXECUTOR "
 strSQL = strSQL & "      , T5.APELIDO AS APELIDO_RESPONSAVEL "
 strSQL = strSQL & "      , T6.APELIDO AS APELIDO_ULT_EXECUTOR "
 strSQL = strSQL & "      , T3.SYS_EVALUATE, T3.SYS_EVALUATE_OBS, T3.SYS_EVALUATE_ID_USUARIO "
 strSQL = strSQL & " FROM CH_CHAMADO T1 "
 strSQL = strSQL & " INNER JOIN CH_CATEGORIA T2 ON (T1.COD_CATEGORIA = T2.COD_CATEGORIA) "
 strSQL = strSQL & " LEFT OUTER JOIN TL_TODOLIST T3 ON (T1.COD_TODOLIST = T3.COD_TODOLIST) "
 strSQL = strSQL & " LEFT JOIN ENT_CLIENTE T4 ON (T1.COD_CLI = T4.COD_CLIENTE) "
 strSQL = strSQL & " LEFT JOIN USUARIO T5 ON (T3.ID_RESPONSAVEL = T5.ID_USUARIO) "
 strSQL = strSQL & " LEFT JOIN USUARIO T6 ON (T3.ID_ULT_EXECUTOR = T6.ID_USUARIO) "
 'strSQL = strSQL & " WHERE T1.COD_CHAMADO > 0 "
 
 If strCODCHAMADO <> "" Then
    If IsNumeric(strCODCHAMADO) Then
	   strSQL = strSQL & " WHERE T1.COD_CHAMADO = " & strCODCHAMADO
	Else
	   strSQL = strSQL & " WHERE T1.COD_CHAMADO = -1" 
	End If
 Else
    strSQL = strSQL & " WHERE T1.COD_CHAMADO > 0"	   
 End If

 If strCODTODOLIST <> "" Then
    If IsNumeric(strCODTODOLIST) Then
	   strSQL = strSQL & " AND T1.COD_TODOLIST = " & strCODTODOLIST
	Else
	   strSQL = strSQL & " AND T1.COD_TODOLIST = -1"
	End If   
 End If

 If Request.Cookies("VBOSS")("GRUPO_USUARIO") = "CLIENTE" Then
  	strSQL = strSQL & " AND T1.COD_CLI = " & Request.Cookies("VBOSS")("ENTIDADE_CODIGO")
 End If
 
strSQLClause = " "

if (strTITULO<>"")        then strSQLClause = strSQLClause & " AND T1.TITULO LIKE '%" & strTITULO & "%' "
if (strCOD_CATEGORIA<>"") then strSQLClause = strSQLClause & " AND T1.COD_CATEGORIA = "  & strCOD_CATEGORIA 
if (strEXTRA<>"")         then strSQLClause = strSQLClause & " AND T1.EXTRA LIKE '" & strEXTRA & "' "

if (strCLIENTE <> "") then 
  'strSQLClause = strSQLClause & " AND (T4.RAZAO_SOCIAL LIKE '%" & strCLIENTE & "%' OR T4.NOME_FANTASIA LIKE '%" & strCLIENTE & "%' OR T4.NOME_COMERCIAL LIKE '%" & strCLIENTE & "%') "
  'Quando mudou na TOP.ASP de um "input" para um "combo", o strCLIENTE passou a vir com o c�digo en�o mais a struing pra buscar na razao, nomefan etc...
   strSQLClause = strSQLClause & " AND (T4.COD_CLIENTE = " & strCLIENTE & ") "
end if  

if (strSOLICITANTE <> "") then strSQLClause = strSQLClause & " AND T1.SYS_ID_USUARIO_INS LIKE '" & strSOLICITANTE & "' "

if strSITUACAO <> "" then
	if InStr(strSITUACAO,"_") = 1 then 
		auxStr = Replace(strSITUACAO,"_", " <> '",1) & "' " 	 
	else 
		auxStr = " = '" & strSITUACAO & "' " 
	end if
	strSQLClause = strSQLClause & " AND T1.SITUACAO " & auxStr 
end if

if (strSQLClause<>"") then strSQL = strSQL & strSQLClause 

If Request.Cookies("VBOSS")("GRUPO_USUARIO") = "CLIENTE" Then
	strSQL = strSQL & " ORDER BY T1.TITULO "
Else
	strSQL = strSQL & " ORDER BY T4.NOME_FANTASIA, T1.TITULO "
End If

'athDebug strSQL, False

AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1

if not objRS.eof then				 
%>
<html>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
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
      <th width="1%"></th>
      <th width="1%"></th>
      <th width="1%"></th>
      <th class="sortable-numeric">C�d.</th>
	  <th class="sortable">Extra</th>
	<% If Request.Cookies("VBOSS")("GRUPO_USUARIO") <> "CLIENTE" Then %>
      <th class="sortable">Cliente</th>
	<% End If %>
      <th class="sortable">T�tulo</th>
      <th class="sortable">Categoria</th>
	  <th class="sortable">Usr</th>
	  <th class="sortable-date-dmy">Solic.</th>
	<!-- Retirado de visualiza��o por um tempo, pois parece n�o ser necess�rio MAI/2013
      <th class="sortable">Usr</th>
	  <th class="sortable-date-dmy">Alter.</th>
    //-->
	  <th class="sortable-date-dmy">Tarefa</th>
	  <th class="sortable">Executor</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
   </thead>
 <tbody style="text-align:left;">
	<%
		while not objRS.eof	
			strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")	
	%>
    <tr bgcolor="<%=strCOLOR%>">
	  <td align="center" valign="top">
	  <% If (GetValue(objRS,"SITUACAO") = "ABERTO") And (GetValue(objRS,"SYS_ID_USUARIO_INS") = strUSER_ID) Then %>
		  <% Response.Write(MontaLinkGrade("modulo_CHAMADO","Delete.asp",GetValue(objRS,"COD_CHAMADO"),"IconAction_DEL.gif","REMOVER")) %>
	  <% End If %>
	  </td>
	  <td width="16" align="center" valign="top">
	  <% If (GetValue(objRS,"SITUACAO") = "ABERTO") And (GetValue(objRS,"SYS_ID_USUARIO_INS") = strUSER_ID) Then %>
		  <% Response.Write(MontaLinkGrade("modulo_CHAMADO","Update.asp",GetValue(objRS,"COD_CHAMADO"),"IconAction_EDIT.gif","ALTERAR")) %>
	  <% End If %>
	  </td>
      <td width="16" align="center" valign="top">
	  <% If GetValue(objRS,"COD_TODOLIST") <> "" Then %>
		  <% Response.Write(MontaLinkGrade("modulo_CHAMADO","DetailHistorico.asp",GetValue(objRS,"COD_TODOLIST"),"IconAction_DETAIL.gif","VISUALIZAR")) %>
	  <% Else %>
		  <% Response.Write(MontaLinkGrade("modulo_CHAMADO","Detail.asp",GetValue(objRS,"COD_CHAMADO"),"IconAction_DETAIL.gif","VISUALIZAR")) %>
	  <% End If %>
	  </td>
	  <!--
	  <td width="16" align="center" valign="top">
	  <% 'If (bInsRespTODO And _
	  		' (GetValue(objRS,"SITUACAO") = "EXECUTANDO" Or GetValue(objRS,"SITUACAO") = "FECHADO") And _
			' (LCase(GetValue(objRS,"ID_RESPONSAVEL")) = strUSER_ID Or LCase(GetValue(objRS,"ID_ULT_EXECUTOR")) = strUSER_ID)) Then %>
	  	<% 'Response.Write(MontaLinkGrade("modulo_TODOLIST","DetailHistorico.asp",GetValue(objRS,"COD_TODOLIST") & "&var_resposta=true","IconAction_DETAILadd.gif","INSERIR ANDAMENTO")) %>
	  <% 'End If %>
	  </td>
	  -->
      <td width="20"><%=GetValue(objRS,"COD_CHAMADO")%>.<%=GetValue(objRS,"COD_TODOLIST")%></td>
	  <td width="70" align="left" valign="top" nowrap="nowrap"><%=GetValue(objRS,"EXTRA")%></td>
	<% If Request.Cookies("VBOSS")("GRUPO_USUARIO") <> "CLIENTE" Then %>
      <td width="120"><%=GetValue(objRS,"CLIENTE")%></td>
	<% End If %>
      <td><%=GetValue(objRS,"TITULO")%></td>
      <td width="100" align="left" valign="top"><%=GetValue(objRS,"CATEGORIA")%></td>
	  <td width="70" align="left" valign="top"><%=GetValue(objRS,"SYS_ID_USUARIO_INS")%></td>
	  <td width="70" align="left" valign="top" nowrap="nowrap"><%=PrepData(GetValue(objRS,"SYS_DTT_INS"), True, True)%></td>
	  <!-- 
      <td width="70" align="left" valign="top"><%'=GetValue(objRS,"SYS_ID_USUARIO_UPD")%></td>
	  <td width="70" align="left" valign="top" nowrap="nowrap"><%'=PrepData(GetValue(objRS,"SYS_DTT_UPD"), True, True)%></td> 
      //-->
	  <td width="90" align="left" valign="top"><%=PrepData(GetValue(objRS,"PREV_DT_INI"), True, False)%></td>
	  <td width="70" align="left" valign="top"><%=GetValue(objRS,"APELIDO_ULT_EXECUTOR")%></td>

      <td width="16" align="center" valign="top">
        <% strEvalObs = GetValue(objRS,"SYS_EVALUATE_OBS") 
		  'Como hist�rico, no campo [sys_evaluate_obs], armazenamos o LOG - data/hora, user, nota e observa��o anterior). 
		  'Nesta grade aqui [Main.asp] devemos tratar o valor do campo observa��o para mostar somente a �ltima observa��o.
	  	  strEvalObs = Replace(strEvalObs,"<ASLW_APOSTROFE>","'")
		  If strEvalObs<>"" then 
			strEvalObs = Mid(strEvalObs,1,instr(strEvalObs,"<!--LOG_EVALUATE ")-1)
		  End if
		%>
		<div style="cursor:pointer" title="(<%=GetValue(objRS,"SYS_EVALUATE")%>) <%if (strEvalObs<>"") then response.write(GetValue(objRS,"SYS_EVALUATE_ID_USUARIO") & " diz: " & strEvalObs) End if%>">
			<img src="../img/IconStatus_EVAL<%=GetValue(objRS,"SYS_EVALUATE")%>.png" height="14">
		</div>            
      </td>
      
      <td width="16" align="center" valign="top"><img src="../img/IconStatus_<%=GetValue(objRS,"SITUACAO")%>.gif" title="SITUA��O:<%=GetValue(objRS,"SITUACAO")%>"></td>
      <td width="16" align="center" valign="top"><img src="../img/IconPrio_<%=GetValue(objRS,"PRIORIDADE")%>.gif" title="PRIORIDADE:<%=GetValue(objRS,"PRIORIDADE")%>"></td>
      <td width="16" align="center" valign="top"><% if GetValue(objRS,"ARQUIVO_ANEXO")<>"" then %><a href="../athdownloader.asp?var_cliente=<%=Request.Cookies("VBOSS")("CLINAME")%>&var_tipo=TODO_Anexos&var_arquivo=<%=GetValue(objRS,"ARQUIVO_ANEXO")%>" target="_blank" style="cursor:hand;"><img src="../img/ico_clip.gif" border="0" title="Anexo"></a><% end if %></td>
    </tr>
    <%
            athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
		wend
		%>
  </tbody>
</table>
</body>
</html>
<%
else
	Mensagem strAviso, "", "", true
end if

FechaRecordSet objRS
FechaDBConn objConn
%>