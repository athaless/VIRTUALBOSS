<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
 Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_TODOLIST", Request.Cookies("VBOSS")("ID_USUARIO")), true 
%>
<!--#include file="../_database/athUtils.asp"--> 
<%
 Dim objConn, objRS, objRSAux, strSQL, strSQLClause
 Dim strCODTODO, strTITULO, strSITUACAO, strRESPONSAVEL, strPRIORIDADE 
 Dim strCOD_CATEGORIA, strUSER_ID, strCH_RESP, strCH_EXEC, auxStr
 Dim strDT_INI, strDT_FIM, strDIA, strMES, strANO, strHORAS, strPREV_HORAS
 Dim bViewTODO, bUpdTODO, bInsRespTODO, bCopiaTODO, bUpdAllTODO
 Dim auxDIREITOS
 Dim strCOLOR, strArquivo, qtdeAnexos	
 
 AbreDBConn objConn, CFG_DB 
 
 strCODTODO       = GetParam("var_cod_todo")
 strTITULO        = GetParam("var_titulo")
 strCOD_CATEGORIA = GetParam("var_categoria")
 strSITUACAO      = GetParam("var_situacao")
 strDIA           = GetParam("var_dia")
 strMES           = GetParam("var_mes")
 strANO           = GetParam("selAno")
 strRESPONSAVEL   = LCase(GetParam("var_responsavel"))
 strPRIORIDADE    = GetParam("var_prioridade")
 
 strUSER_ID = LCase(GetParam("var_executor"))
 strCH_RESP = GetParam("var_checkresp")
 strCH_EXEC = GetParam("var_checkexec")

 auxDIREITOS   = BuscaDireitosFromDB("modulo_TODOLIST", Request.Cookies("VBOSS")("ID_USUARIO"))
 bViewTODO     = VerificaDireito("|VIEW|"           , auxDIREITOS, false)
 bUpdTODO      = VerificaDireito("|UPD|"            , auxDIREITOS, false)
 bCopiaTODO    = VerificaDireito("|COPY|"           , auxDIREITOS, false)
 bInsRespTODO  = VerificaDireito("|INS_RESP|"       , auxDIREITOS, false)
 bUpdAllTODO   = VerificaDireito("|UPD_ALL_TODO|"   , auxDIREITOS, false)
 
 strSQL = "SELECT" 													&_
			"	T1.COD_TODOLIST" 									&_
			",	T1.ARQUIVO_ANEXO" 									&_
			",	T1.ID_RESPONSAVEL" 									&_
			",	T1.ID_ULT_EXECUTOR" 								&_
			",	T1.TITULO" 											&_
			",	T1.SITUACAO" 										&_
			",	T1.PREV_DT_INI" 									&_
			",	T1.PREV_HR_INI" 									&_
			",	T1.PREV_HORAS" 										&_
			",	T1.PRIORIDADE" 										&_
			",	T1.COD_BOLETIM" 									&_
			",	T2.NOME AS CATEGORIA " 								&_
			",	T4.NOME_COMERCIAL" 									&_
			",	BS.TITULO AS BS_TITULO"								&_			
			",	BS.ID_RESPONSAVEL AS BS_RESPONSAVEL" 				&_
			",	BS.COD_CLIENTE" 									&_
			",	(SELECT COUNT(T3.COD_TL_RESPOSTA) FROM TL_RESPOSTA T3 WHERE T3.COD_TODOLIST = T1.COD_TODOLIST) AS TOTAL " &_
			",	(SELECT SUM(T5.HORAS) FROM TL_RESPOSTA T5 WHERE T5.COD_TODOLIST = T1.COD_TODOLIST) AS TOT_HORAS " &_
			",	(SELECT COUNT(TL_ANEXO.COD_ANEXO) FROM TL_ANEXO WHERE T1.COD_TODOLIST = TL_ANEXO.COD_TODOLIST) AS TOT_ANEXO " &_
			"FROM " 												&_
			"	TL_TODOLIST T1 " 									&_
			"	LEFT OUTER JOIN TL_CATEGORIA T2 ON (T1.COD_CATEGORIA = T2.COD_CATEGORIA) " &_
			"	LEFT OUTER JOIN BS_BOLETIM BS ON (T1.COD_BOLETIM = BS.COD_BOLETIM) " &_
			"	LEFT OUTER JOIN ENT_CLIENTE T4 ON (T4.COD_CLIENTE = BS.COD_CLIENTE) " &_ 
			"WHERE T1.COD_TODOLIST = T1.COD_TODOLIST " &_
			"AND (BS.MODELO=0 OR T1.COD_BOLETIM IS NULL OR T1.COD_BOLETIM=0)"

if strUSER_ID <> "" then
	if (strCH_RESP = "true") and (strCH_EXEC = "true") then strSQL = strSQL & " AND (T1.ID_RESPONSAVEL = '"  & strUSER_ID & "' OR T1.ID_ULT_EXECUTOR = '" & strUSER_ID & "') " 
	if (strCH_RESP = "true") and (strCH_EXEC = "")     then strSQL = strSQL & " AND (T1.ID_RESPONSAVEL = '"  & strUSER_ID & "') " 
	if (strCH_RESP = "")     and (strCH_EXEC = "true") then strSQL = strSQL & " AND (T1.ID_ULT_EXECUTOR = '" & strUSER_ID & "') " 
	if (strCH_RESP = "")     and (strCH_EXEC = "")     then strSQL = strSQL & " AND (T1.ID_RESPONSAVEL <> '" & strUSER_ID & "' AND T1.ID_ULT_EXECUTOR <> '" & strUSER_ID & "') " 
else 
	strUSER_ID = LCase(Request.Cookies("VBOSS")("ID_USUARIO"))
end if

strSQLClause = ""

if (strCODTODO<>"")       then strSQLClause = strSQLClause & " AND T1.COD_TODOLIST LIKE '" & strCODTODO & "%' "
if (strTITULO<>"")        then strSQLClause = strSQLClause & " AND (T1.TITULO LIKE '" & strTITULO & "%' OR T4.NOME_COMERCIAL LIKE '" & strTITULO & "%')"
if (strPRIORIDADE<>"")    then strSQLClause = strSQLClause & " AND T1.PRIORIDADE LIKE '" & strPRIORIDADE & "'" 
if (strCOD_CATEGORIA<>"") then strSQLClause = strSQLClause & " AND T1.COD_CATEGORIA = "  & strCOD_CATEGORIA 

if strSITUACAO <> "" then
	if InStr(strSITUACAO,"_") = 1 then 
		auxStr = Replace(strSITUACAO,"_", " <> '",1) & "' " 	 
	else 
		auxStr = " = '" & strSITUACAO & "' " 
	end if
	strSQLClause = strSQLClause & " AND T1.SITUACAO " & auxStr 
end if

if (strMES = "") And (strANO <> "") then
	strDT_INI = DateSerial(strANO, 1, 1)
	strDT_FIM = DateSerial(strANO, 12, 31)
	
	strSQLClause = strSQLClause & " AND ((T1.PREV_DT_INI IS NULL) OR " 
	strSQLClause = strSQLClause & "      (T1.PREV_DT_INI BETWEEN '" & PrepDataBrToUni(strDT_INI,false) & "' AND '" & PrepDataBrToUni(strDT_FIM,false) & "'))" 
end if

if (strMES <> "") And (strANO = "") then
	strANO = DatePart("YYYY", Date)
	
	if strDIA = "" then
		strDT_INI = DateSerial(strANO, strMES, 1)
		strDT_FIM = DateAdd("M", 1, strDT_INI)
		strDT_FIM = DateAdd("D", -1, strDT_FIM)
	else
		strDT_INI = DateSerial(strANO, strMES, strDIA)
		strDT_FIM = strDT_INI
	end if
	
	strSQLClause = strSQLClause & " AND ((T1.PREV_DT_INI IS NULL) OR " 
	strSQLClause = strSQLClause & "      (T1.PREV_DT_INI BETWEEN '" & PrepDataBrToUni(strDT_INI,false) & "' AND '" & PrepDataBrToUni(strDT_FIM,false) & "'))" 
end if

if (strMES <> "") And (strANO <> "") then
	if strDIA = "" then
		strDT_INI = DateSerial(strANO, strMES, 1)
		strDT_FIM = DateAdd("M", 1, strDT_INI)
		strDT_FIM = DateAdd("D", -1, strDT_FIM)
	else
		strDT_INI = DateSerial(strANO, strMES, strDIA)
		strDT_FIM = strDT_INI
	end if
	
	strSQLClause = strSQLClause & " AND ((T1.PREV_DT_INI IS NULL) OR " 
	strSQLClause = strSQLClause & "      (T1.PREV_DT_INI BETWEEN '" & PrepDataBrToUni(strDT_INI,false) & "' AND '" & PrepDataBrToUni(strDT_FIM,false) & "'))" 
end if

if (strMES = "") And (strANO = "") then
	if strDIA <> "" then
		strMES = DatePart("M", Date)
		strANO = DatePart("YYYY", Date)
		strDT_INI = DateSerial(strANO, strMES, strDIA)
		strDT_FIM = strDT_INI
	end if
	
	strSQLClause = strSQLClause & " AND ((T1.PREV_DT_INI IS NULL) OR " 
	strSQLClause = strSQLClause & "      (T1.PREV_DT_INI BETWEEN '" & PrepDataBrToUni(strDT_INI,false) & "' AND '" & PrepDataBrToUni(strDT_FIM,false) & "'))" 
end if

if (strSQLClause<>"") then strSql = strSql & strSQLClause 

strSQL = strSQL &" GROUP BY" 
strSQL = strSQL & "		T1.COD_TODOLIST"
strSQL = strSQL & ",	T1.ID_RESPONSAVEL" 
strSQL = strSQL & ",	T1.ID_ULT_EXECUTOR" 
strSQL = strSQL & ",	T1.TITULO"
strSQL = strSQL & ",	T1.ARQUIVO_ANEXO"
strSQL = strSQL & ",	T1.SITUACAO"
strSQL = strSQL & ",	T1.PREV_DT_INI"
strSQL = strSQL & ",	T1.PREV_HR_INI"
strSQL = strSQL & ",	T1.PREV_HORAS"
strSQL = strSQL & ",	T1.PRIORIDADE"
strSQL = strSQL & ",	T1.COD_BOLETIM"
strSQL = strSQL & ",	T2.NOME"
strSQL = strSQL & ",	T4.NOME_COMERCIAL"
strSQL = strSQL & ",	BS.TITULO" 
strSQL = strSQL & ",	BS.ID_RESPONSAVEL" 
strSQL = strSQL & ",	BS.COD_CLIENTE "
strSQL = strSQL & "ORDER BY"
strSQL = strSQL & "	T1.PREV_DT_INI, T1.PREV_HR_INI, T1.TITULO"

'athDebug strSQL, False

AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1

if not objRS.eof then				 
	'OCULTO aparece SOMENTE para MANAGER, RESPONSAVEL pelo BS ou TAREFA
	while (GetValue(objRS,"SITUACAO")="OCULTO" and Request.Cookies("VBOSS")("GRUPO_USUARIO")<>"MANAGER" and LCase(GetValue(objRS,"BS_RESPONSAVEL"))<>strUSER_ID and LCase(GetValue(objRS,"ID_RESPONSAVEL"))<>strUSER_ID)
		athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
	wend
	if not objRS.eof then	
%>
<html>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<!--link rel="stylesheet" type="text/css" href="../_css/virtualboss.css"-->
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
  <thead>
    <tr>
      <th width="01%"></th>
      <th width="01%"></th>
      <th width="01%"></th>
      <th width="01%" class="sortable-numeric" nowrap="nowrap">Cód.</th>
      <th width="07%" class="sortable">Resp</th>
      <th width="07%" class="sortable">Exec</th>
      <th width="05%" class="sortable-date-dmy" nowrap="nowrap">Data</th>
      <th width="05%" class="sortable-numeric" nowrap="nowrap">Hora</th>
      <th width="10%" class="sortable">Categoria</th>
      <th width="22%" class="sortable">Atividade/BS</th>
      <th width="22%" class="sortable">Título</th>
      <th width="07%" class="sortable" nowrap="nowrap">Prev Hs</th>
      <th width="07%" class="sortable">Hs</th>
      <th width="01%"></th>
      <th width="01%"></th>
      <th width="01%"></th>
      <th width="01%"></th>
    </tr>
   </thead>
 <tbody style="text-align:left;">
<%
		while not objRS.eof		
			strCOLOR = swapString (strCOLOR, "#FFFFFF", "#F5FAFA")
			strArquivo = GetValue(objRS,"ARQUIVO_ANEXO")
			qtdeAnexos = GetValue(objRS,"TOT_ANEXO")
			
			if (GetValue(objRS,"PREV_DT_INI")<Now)  and (GetValue(objRS,"SITUACAO")<>"FECHADO") then strCOLOR = "#FFF0F0"
			if (GetValue(objRS,"PREV_DT_INI")=Date) and (GetValue(objRS,"SITUACAO")<>"FECHADO") then strCOLOR = "#FFFFF0" '"#FFFFE6" 'amarelo
			if (GetValue(objRS,"PREV_DT_INI")="") then strCOLOR = "#FFFFFF"
			
			strHORAS = GetValue(objRS,"TOT_HORAS")
			
			'strHORAS = "" 
			'strSQL = " SELECT SUM(HORAS) AS TOT_HORAS FROM TL_RESPOSTA WHERE COD_TODOLIST = " & GetValue(objRS,"COD_TODOLIST") 
			'AbreRecordSet objRSAux, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
			'if not objRSAux.eof and not objRSAux.bof then strHORAS = GetValue(objRSAux,"TOT_HORAS")
			'FechaRecordSet objRSAux
		%>
    <tr bgcolor="<%=strCOLOR%>">
      <td>
	  <% 
	   if (bUpdTODO and ((GetValue(objRS,"SITUACAO")<>"FECHADO") and ( LCase(GetValue(objRS,"ID_RESPONSAVEL"))=LCase(Request.Cookies("VBOSS")("ID_USUARIO"))))) then
			response.write MontaLinkGrade("modulo_TODOLIST","Update.asp",GetValue(objRS,"COD_TODOLIST"),"IconAction_EDIT.gif","ALTERAR")
	   elseif (bUpdTODO and ((UCase(GetValue(objRS,"CATEGORIA")) = "CHAMADO") and (LCase(GetValue(objRS,"ID_ULT_EXECUTOR"))=LCase(Request.Cookies("VBOSS")("ID_USUARIO"))))) then
	   		response.write MontaLinkGrade("modulo_TODOLIST","Update.asp",GetValue(objRS,"COD_TODOLIST"),"IconAction_EDIT.gif","ALTERAR CH")
	   elseif (bUpdAllTODO) then
	  		' TAVA ASSIM: 22/01/2010 - ELSEIF (bUpdAllTODO AND (GetValue(objRS,"SITUACAO")="ABERTO" OR GetValue(objRS,"SITUACAO")="OCULTO")) then 
			' Mudado devido a consideração de suprepacia do direto UPDATE ALL, se o cara tem isso ele edita qualqeur tarfa não importando o estado
			response.write MontaLinkGrade("modulo_TODOLIST","Update.asp",GetValue(objRS,"COD_TODOLIST"),"IconAction_EDITInterv.gif","ALTERAR")
       end if
	  %>
      </td>
      <td>
	  <%
       'if (bInsRespTODO And ( LCase(GetValue(objRS,"ID_ULT_EXECUTOR")) = LCase(Request.Cookies("VBOSS")("ID_USUARIO")) Or LCase(GetValue(objRS,"ID_RESPONSAVEL")) = LCase(Request.Cookies("VBOSS")("ID_USUARIO")) Or Request.Cookies("VBOSS")("GRUPO_USUARIO") = "MANAGER")) then 
	   '	if (Request.Cookies("VBOSS")("GRUPO_USUARIO") = "MANAGER") then 
	   '		response.write (MontaLinkGrade("modulo_TODOLIST","DetailHistorico.asp",GetValue(objRS,"COD_TODOLIST"),"IconAction_DETAILaddInterv.gif","VER ANDAMENTOS"))
	   '	else
				response.write (MontaLinkGrade("modulo_TODOLIST","DetailHistorico.asp",GetValue(objRS,"COD_TODOLIST"),"IconAction_DETAILadd.gif","VER ANDAMENTOS"))
	   '    end if 
	   'end if 
	  %>
	  </td>
      <td nowrap="nowrap">
      <% if bCopiaTODO then %>
			<%=MontaLinkGrade("modulo_TODOLIST","Copia.asp",GetValue(objRS,"COD_TODOLIST"),"IconAction_COPY.gif","CÓPIA")%>
      <% end if %>
      </td>
      <td nowrap="nowrap"><%=GetValue(objRS,"COD_TODOLIST")%></td>
      <td nowrap="nowrap"><%=LCase(GetValue(objRS,"ID_RESPONSAVEL"))%></td>
      <td nowrap="nowrap"><%=LCase(GetValue(objRS,"ID_ULT_EXECUTOR"))%></td>
      <td align="right" nowrap="nowrap"><%=PrepData(GetValue(objRS,"PREV_DT_INI"),true,false)%></td>
      <td align="right" nowrap="nowrap"><%=GetValue(objRS,"PREV_HR_INI")%></td>
      <td nowrap="nowrap"><div><%=UCase(GetValue(objRS,"CATEGORIA"))%></div></td>
      <td>
	   <% if GetValue(objRS,"COD_BOLETIM") <> "" and GetValue(objRS,"COD_BOLETIM") <> "0" then %>
	     <%=GetValue(objRS,"COD_BOLETIM")%> - <%=GetValue(objRS,"BS_TITULO")%>
       <% end if %>
	  </td>
      <td><%=GetValue(objRS,"TITULO")%></td>
      <td align="right" nowrap="nowrap"><%=FormataHoraNumToHHMM(getValue(objRS,"PREV_HORAS"))%></td>
      <td align="right" nowrap="nowrap"><%=FormataHoraNumToHHMM(strHORAS)%></td>
      <td><img src="../img/IconStatus_<%=GetValue(objRS,"SITUACAO")%>.gif" title="SITUAÇÃO:<%=GetValue(objRS,"SITUACAO")%>"></td>
      <td><img src="../img/IconPrio_<%=GetValue(objRS,"PRIORIDADE")%>.gif" title="PRIORIDADE:<%=GetValue(objRS,"PRIORIDADE")%>"></td>
      <td><% if GetValue(objRS,"COD_BOLETIM") <> "" and GetValue(objRS,"COD_BOLETIM") <> "0" then %>
    	      <img src="../img/IconStatus_BS.gif" alt="BS: <%=GetValue(objRS,"COD_BOLETIM")%> (<%=GetValue(objRS,"NOME_COMERCIAL")%>)" title="BS: <%=GetValue(objRS,"COD_BOLETIM")%> (<%=GetValue(objRS,"NOME_COMERCIAL")%>)">
          <% end if %>
		  <% if UCase(GetValue(objRS,"CATEGORIA")) = "CHAMADO" then %>
    	      <img src="../img/IconStatus_Chamado.gif" alt="Chamado" title="Chamado">
          <% end if %>
      </td>
      <td>
		<% 
		 if ( (strArquivo<>"") or (CInt(qtdeAnexos)>0) )then 
			  response.write ("<img src='../img/ico_clip.gif' border='0' title='Documento/Anexos: " & strArquivo & " / " & qtdeAnexos & "'>")
		 end if 
		%>
	  </td>
    </tr>
		<%
            athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
			
			while (GetValue(objRS,"SITUACAO")="OCULTO" and Request.Cookies("VBOSS")("GRUPO_USUARIO")<>"MANAGER" and LCase(GetValue(objRS,"BS_RESPONSAVEL"))<>strUSER_ID and LCase(GetValue(objRS,"ID_RESPONSAVEL"))<>strUSER_ID)
				athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
			wend			
		wend
		%>
  </tbody>
</table>
</body>
</html>
<%
		FechaRecordSet objRS
	else
		Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
		FechaDBConn objConn
	end if
else
	Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
	FechaDBConn objConn
end if
%>