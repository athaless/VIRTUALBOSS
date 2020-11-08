<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_BS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
 <!--#include file="../_database/athUtils.asp"--> 
<% 
Dim objConn, objRS, objRSII, strSQL, strSQLClause
Dim strTITULO, strCOD_CATEGORIA, strSITUACAO, strMES, strRESPONSAVEL
Dim strPRIORIDADE, strUSER_ID, strCH_RESP, strCH_EQP
Dim strINI, strFIM, strDIA, strANO, auxStr, strHORAS 
Dim strGRUPOS, strGRUPO_USUARIO, strCOOKIE_ID_USUARIO
Dim strID_RESPONSAVEL, arrBS_EQUIPE, strPREV_HORAS
Dim strTIPO, strCOD_BOLETIM
Dim bUpdAllBS, bCopiaTODO
Dim strCODIGOS
Dim strDT_INI, strDT_FIM, strTODO_ATRASO

AbreDBConn objConn, CFG_DB 
	
strCOOKIE_ID_USUARIO = LCase(Request.Cookies("VBOSS")("ID_USUARIO"))
strGRUPO_USUARIO     = UCase(Request.Cookies("VBOSS")("GRUPO_USUARIO"))
strGRUPOS            = "SU,MANAGER" 'Grupos a serem comparados

strCOD_BOLETIM		= GetParam("var_cod_boletim")		
strTITULO			= GetParam("var_titulo")
strSITUACAO		= GetParam("var_situacao")
'strMES				= GetParam("var_mes")
'strANO				= GetParam("selAno")	
strRESPONSAVEL		= LCase(GetParam("var_responsavel"))
strPRIORIDADE		= GetParam("var_prioridade")
strTIPO			= GetParam("var_tipo")
strCOD_CATEGORIA   = GetParam("var_cod_categoria")

strUSER_ID = LCase(GetParam("var_executor"))
strCH_RESP = GetParam("var_checkresp")
strCH_EQP  = GetParam("var_checkeqp")

bUpdAllBS = VerificaDireito("|UPD_ALL_BS|", BuscaDireitosFromDB("modulo_BS", Request.Cookies("VBOSS")("ID_USUARIO")), false)

strSQL =	"SELECT DISTINCT BS.COD_BOLETIM," 												&_
		"		BS.COD_PROJETO," 														&_
		"		BS.COD_CLIENTE," 														&_
		"		CL.NOME_COMERCIAL,"														&_			
		"		CAT.NOME," 																&_
		"		BS.ID_RESPONSAVEL," 													&_
		"		BS.TITULO,"																&_
		"		BS.DESCRICAO,"															&_
		"		BS.SITUACAO,"															&_
		"		BS.PRIORIDADE,"															&_
		"		MIN(TL.PREV_DT_INI) AS DT_INI,"											&_	
		"		MAX(TL.PREV_DT_INI) AS DT_FIM,"											&_
		"		SUM(TL.PREV_HORAS) AS TOT_PREV_HORAS, " 								&_
		"		(SELECT SUM(R.HORAS) FROM TL_RESPOSTA R " 								&_
		"         WHERE TL.COD_BOLETIM = BS.COD_BOLETIM AND TL.COD_TODOLIST = R.COD_TODOLIST) as TOT_HORAS, " &_
		"       ( SELECT COUNT(TL2.COD_TODOLIST) FROM TL_TODOLIST TL2 "					&_
		"          WHERE TL2.COD_BOLETIM = BS.COD_BOLETIM "								&_
		"			 AND TL2.PREV_DT_INI < CURRENT_DATE	"								&_
		"            AND TL2.SITUACAO <> 'FECHADO') as TOT_TODO_ATRASO  "				&_
		"FROM "	 																		&_
		"		BS_BOLETIM BS "															&_
		"INNER JOIN" 																	&_
		"		BS_CATEGORIA CAT ON (BS.COD_CATEGORIA=CAT.COD_CATEGORIA) "				&_
		"LEFT OUTER JOIN" 																&_
		"		TL_TODOLIST TL ON (BS.COD_BOLETIM=TL.COD_BOLETIM) " 					&_
		"LEFT OUTER JOIN" 																	&_
		"		ENT_CLIENTE CL ON (BS.COD_CLIENTE=CL.COD_CLIENTE) " 					&_			
		"WHERE 1=1 " 
if strCOD_BOLETIM="" then
	if strUSER_ID <> "" then
		if (strCH_RESP="true") and (strCH_EQP="") then strSQL = strSQL & " AND (BS.ID_RESPONSAVEL='"  & strUSER_ID & "') "
		if (strCH_RESP="") and (strCH_EQP="true") then strSQL = strSQL & " AND (BS.COD_BOLETIM IN (SELECT DISTINCT COD_BOLETIM FROM BS_EQUIPE WHERE ID_USUARIO='" & strUSER_ID & "' AND DT_INATIVO IS NULL)) "
		if (strCH_RESP="true") and (strCH_EQP="true") then strSQL = strSQL & " AND ((BS.ID_RESPONSAVEL='"  & strUSER_ID & "') OR (BS.COD_BOLETIM IN (SELECT DISTINCT COD_BOLETIM FROM BS_EQUIPE WHERE ID_USUARIO='" & strUSER_ID & "' AND DT_INATIVO IS NULL))) "
		if (InStr(strGRUPOS,strGRUPO_USUARIO)=0) and (strCH_RESP="") and (strCH_EQP="") then 
			strSQL = strSQL & " AND BS.COD_BOLETIM IS NULL" 'Não retorna nenhum resultado
		elseif (strCH_RESP="") and (strCH_EQP="") then 'Só MANAGER/SU pode ver atividades em que não está na equipe ou como responsável
			strSQL = strSQL & " AND (BS.ID_RESPONSAVEL<>'"  & strUSER_ID & "' AND BS.COD_BOLETIM NOT IN (SELECT DISTINCT COD_BOLETIM FROM BS_EQUIPE WHERE (ID_USUARIO='"  & strUSER_ID & "') AND DT_INATIVO IS NULL)) " 
		end if
	end if
	
	strSQLClause = ""
	if (strTITULO<>"") then strSQLClause = strSQLClause & " AND (BS.TITULO LIKE '%" & strTITULO & "%' OR CL.NOME_COMERCIAL LIKE '%" &  strTITULO & "%')"
	if (strCOD_CATEGORIA<>"") then strSQLClause = strSQLClause & " AND BS.COD_CATEGORIA = " & strCOD_CATEGORIA
	
	if strSITUACAO="_FECHADO" then  
		strSITUACAO=""
		auxStr = "<>'FECHADO' AND BS.SITUACAO<>'CANCELADO'"
		strSQLClause = strSQLClause & " AND BS.SITUACAO " & auxStr
	elseif strSITUACAO<>"" then
		if InStr(1,strSITUACAO,"_")=1 then
	
			auxStr = Replace(strSITUACAO,"_", " <> '",1) & "' "
		else
			auxStr = " = '" & strSITUACAO & "' "
		end if
		strSQLClause = strSQLClause & " AND BS.SITUACAO " & auxStr
	end if
	
	if strTIPO<>"" then
		if strTIPO<>"TODOS" then 
		   strSQLClause = strSQLClause & " AND TIPO = '" & strTIPO & "'"
		end if
	end if
else
	strSQLClause = " AND BS.COD_BOLETIM=" & strCOD_BOLETIM
end if

'Removendo pesquisa por datas porque dá problema com BS sem TAREFAS
'if strMES <> "" and strANO <> "" then
'	strINI = DateSerial(strANO, strMES, 1)
'	strFIM = DateAdd("D", -1, DateAdd("M", 1, strINI))
'	
'	strSQLClause = strSQLClause & " AND (TL.PREV_DT_INI >= '" & PrepDataBrToUni(strINI,false) & "' AND TL.PREV_DT_INI <= '" & PrepDataBrToUni(strFIM,false) & "') "
'end if

'Com problemas de pesquisa com mais de um mês
'if strMES = "" and strANO <> "" then
'	strINI = DateSerial(strANO, 1, 1)
'	strFIM = DateSerial(strANO, 12, 31)
'	
'	strSQLClause = strSQLClause & " AND (TL.PREV_DT_INI >= '" & PrepDataBrToUni(strINI,false) & "' AND TL.PREV_DT_INI <= " & PrepDataBrToUni(strFIM,false) & "') "
'end if

if (strSQLClause<>"") then strSQL = strSQL & strSQLClause

strSQL = strSQL &  " GROUP BY"   &_
						 "    BS.COD_BOLETIM," 		&_
						 "    BS.COD_PROJETO," 		&_
						 "    BS.COD_CLIENTE," 		&_
						 "    CL.NOME_COMERCIAL," 	&_						 
						 "    CAT.NOME,"  			&_
						 "    BS.ID_RESPONSAVEL,"	&_
						 "    BS.TITULO,"			&_
						 "    BS.DESCRICAO,"		&_
						 "    BS.SITUACAO,"			&_
						 "    BS.PRIORIDADE " 
strSQL = strSQL & " ORDER BY 11 "

'athDebug strSQL & "<br><br>", False

AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1

if not objRS.Eof then				 
%>
<html>
	<head>
		<title>vboss</title>
		<script type="text/javascript" src="../_scripts/tablesort.js"></script>
		<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
	</head>
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
		<th width="1%"></th>
		<th width="1%"  class="sortable-date-dmy" nowrap>Dt Início</th>		
		<th width="1%"  class="sortable-date-dmy" nowrap>Dt Fim</th>
		<th width="30%" class="sortable" nowrap>Cliente</th>		
		<th width="0%"  class="sortable" nowrap>Categoria</th>
		<th width="50%" class="sortable" nowrap>Título</th>
		<th width="1%"  class="sortable" nowrap>Resp.</th>
		<th width="1%"  nowrap>Rendimento</th>
		<th width="1%"  class="sortable" nowrap>Prev Hs.</th>
		<th width="1%"></th>
		<th width="1%"></th>
	</tr>
 <thead>
 <tbody style="text-align:left;">	
<%
	Dim strCOLOR, strArquivo
	Dim pCent, strPREV, strTOTAL, tbW, BgCor
	
	'Com problemas com pesquisa por datas no mySQL 4
	strCODIGOS = ","
	while not objRS.Eof	
		If InStr(strCODIGOS, "," & GetValue(objRS, "COD_BOLETIM") & ",") = 0 Then
			strCODIGOS = strCODIGOS & GetValue(objRS, "COD_BOLETIM") & ","
			
			strHORAS		= 0
			strPREV_HORAS 	= 0
			strTODO_ATRASO	= 0
			
			strPREV  = 0
			strTOTAL = 0
			pCent 	 = 0 
	
			strHORAS          = GetValue(objRS, "TOT_HORAS")
			strPREV_HORAS     = GetValue(objRS, "TOT_PREV_HORAS")
			strID_RESPONSAVEL = LCase(GetValue(objRS, "ID_RESPONSAVEL"))
			strTODO_ATRASO    = CInt(GetValue(objRS, "TOT_TODO_ATRASO"))

			strDT_INI = GetValue(objRS, "DT_INI")
			strDT_FIM = GetValue(objRS, "DT_FIM")
			
			strCOLOR = "#FFFFFF"
			If IsDate(strDT_INI) And IsDate(strDT_FIM) Then
				strDT_INI = CDate(strDT_INI)
				strDT_FIM = CDate(strDT_FIM)
				if GetValue(objRS, "SITUACAO")<>"FECHADO" then
					if ((strDT_INI-Date)<2) and ((strDT_FIM-Date)>0) and (strTODO_ATRASO=0) then  
						strCOLOR = "#FFFFF0" '--> amarelo
					else
						if (strTODO_ATRASO>0) then strCOLOR = "#FFF0F0"	'--> vermelho
						'Antes marcava em vermelho o BS que tivesse sua PRIMEIRA TAREFA em atraso, 
						'agora marca em vermelho se dentro dele tiver uma ou mais tarefas em atraso.
						'if (strDT_INI<Now) then strCOLOR = "#FFF0F0" '--> vermelho
					end if	
				end if
			End If
			
			if strPREV_HORAS<>"" and not IsNull(strPREV_HORAS) then strPREV = strPREV_HORAS*60
			if strHORAS<>"" and not IsNull(strHORAS) then strTOTAL = strHORAS*60
			
			if strPREV>0 and strTOTAL>=0 then pCent = strTOTAL*100/strPREV
			if pCent=0 then strHORAS = "0:00"
	
			tbW = pCent		
			BgCor = "#93A2B9"
			
			if (tbW>100) then 
				tbW = 100
				BgCor = "#7D8B9F"
				if GetValue(objRS,"SITUACAO")<>"FECHADO" then BgCor = "#C00000"
			elseif (tbW<0) then 
				tbW = 100
			end if
			
			strSQL = "SELECT ID_USUARIO FROM BS_EQUIPE WHERE COD_BOLETIM=" & GetValue(objRS, "COD_BOLETIM") & " AND DT_INATIVO IS NULL ORDER BY ID_USUARIO"
			set objRSII = objConn.Execute(strSQL) 
			
			arrBS_EQUIPE = ""
			while not objRSII.Eof 
				arrBS_EQUIPE = arrBS_EQUIPE & LCase(objRSII("ID_USUARIO")) & "; "
				athMoveNext objRSII, ContFlush, CFG_FLUSH_LIMIT
			wend
			FechaRecordSet objRSII		
	%>
		<tr bgcolor="<%=strCOLOR%>">
			<td>
			<% 
			 if (strID_RESPONSAVEL = strCOOKIE_ID_USUARIO) and (GetValue(objRS,"SITUACAO") <> "FECHADO") then
				response.write ( MontaLinkGrade("modulo_BS","Delete.asp","&var_cod_boletim=" & GetValue(objRS,"COD_BOLETIM"),"IconAction_DEL.gif","REMOVER") )
			 end if
			%>
			</td>
			<td>
			<%
			if (strID_RESPONSAVEL = strCOOKIE_ID_USUARIO) and (GetValue(objRS,"SITUACAO") <> "FECHADO") then
				response.write ( MontaLinkGrade("modulo_BS","Update.asp",GetValue(objRS,"COD_BOLETIM"),"IconAction_EDIT.gif","ALTERAR"))
			elseif bUpdAllBS then
				response.write ( MontaLinkGrade("modulo_BS","Update.asp",GetValue(objRS,"COD_BOLETIM"),"IconAction_EDITInterv.gif","ALTERAR"))
			end if
			%>
			</td>
			<td>
			<%
			if (InStr(arrBS_EQUIPE,strCOOKIE_ID_USUARIO)>0) then
				response.write ( MontaLinkGrade("modulo_BS","DetailHistorico.asp",GetValue(objRS,"COD_BOLETIM") & "&var_resposta=true","IconAction_DETAILadd.gif","INSERIR ANDAMENTO") )
			end if
			%>
			</td>
			<td>
			<%
			 if (strID_RESPONSAVEL = strCOOKIE_ID_USUARIO) or (InStr(strGRUPOS,strGRUPO_USUARIO)>0) then
				response.write ( MontaLinkGrade("modulo_BS","InsertCopia.asp",GetValue(objRS,"COD_BOLETIM"),"IconAction_COPY.gif","DUPLICAR") )
			 end if
			%>
			</td>							
			<td align="right" nowrap><%=PrepData(GetValue(objRS,"DT_INI"),true,false)%></td>
			<td align="right" nowrap><%=PrepData(GetValue(objRS,"DT_FIM"),true,false)%></td>
			<td><%=GetValue(objRS,"NOME_COMERCIAL")%></td>			
			<td nowrap><%=UCase(GetValue(objRS,"NOME"))%></td>
			<td><%=GetValue(objRS,"TITULO")%></td>
			<td nowrap><%=LCase(GetValue(objRS,"ID_RESPONSAVEL"))%></td>
			<td align="center" style="vertical-align:middle;">
				<table style="width:100px; height:13px; padding:0px; margin:0px; border:1px solid #006699; background:none; background-image:none;">
					<tr>
					<% If tbW = 0 Then %>
						<td style="width:100px; border:none; background-color:#FFFFFF; background-image:none;" title="<%=Round(pCent,2)%>% - <%=FormataHoraNumToHHMM(strHORAS)%>Hs"></td>
					<% ElseIf tbW = 100 Then %>
						<td style="width:100px; border:none; background-color:<%=BgCor%>; background-image:none;" title="<%=Round(pCent,2)%>% - <%=FormataHoraNumToHHMM(strHORAS)%>Hs"></td>
					<% Else %>
						<td style="width:<%=Round(tbW)%>px; border:none; background-color:<%=BgCor%>; background-image:none;" title="<%=Round(pCent,2)%>% - <%=FormataHoraNumToHHMM(strHORAS)%>Hs"></td>
						<td style="width:<%=Round(100-tbW)%>px; border:none; background-color:#FFFFFF; background-image:none;"  title="<%=Round(pCent,2)%>% - <%=FormataHoraNumToHHMM(strHORAS)%>Hs"></td>
					<% End If %>
					</tr>
				</table>
			</td>
		  <td align="right" title="Total de horas previstas" style="cursor:default;"><%=FormataHoraNumToHHMM(strPREV_HORAS)%></div></td>
			<td align="center"><div style="background:url(../img/IconStatus_<%=GetValue(objRS,"SITUACAO")%>.gif) no-repeat center; width:21px;" title="SITUAÇÃO: <%=GetValue(objRS,"SITUACAO")%>"></div></td>
			<td align="center"><div style="background:url(../img/IconPrio_<%=GetValue(objRS,"PRIORIDADE")%>.gif) no-repeat center; width:21px;" title="PRIORIDADE: <%=GetValue(objRS,"PRIORIDADE")%>"></div></td>	
		</tr>
	<%
		End If
		athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
	wend
%>
 <tbody>	
</table>
</body>
</html>
<%
else
	Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
end if

FechaRecordSet objRS
FechaDBConn objConn
%>