<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FIN_LCTOCONTA", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
 <!--#include file="../_database/athUtils.asp"--> 
<%
 Dim objConn, objRS, strSQL, objRSa
 Dim strCOOKIE_ID_USUARIO, strGRUPO_USUARIO
 Dim strENTIDADE, strSALDO
 Dim strDT_INI, strDT_FIM
 Dim strCONTA, strPERIODO
 Dim strIO, strTITLE, boolLCTO, boolTRANSF
 Dim strCOLOR

 AbreDBConn objConn, CFG_DB 

 boolLCTO   = true
 boolTRANSF = true
 
 strCOOKIE_ID_USUARIO = LCase(Request.Cookies("VBOSS")("ID_USUARIO"))
 strGRUPO_USUARIO = UCase(Request.Cookies("VBOSS")("GRUPO_USUARIO"))

 strCONTA	   = GetParam("var_fin_conta")
 strPERIODO	   = GetParam("var_periodo")
 
 strCOLOR = "#DAEEFA"
 if strPERIODO = "" then strPERIODO = "ULT_15D"

 strDT_FIM = Date()
 if strPERIODO = "ULT_15D"   then strDT_INI = DateAdd("D", -15, Date)
 if strPERIODO = "MES_ATUAL" then strDT_INI = DateSerial(DatePart("YYYY", Date), DatePart("M", Date), 1)
 if strPERIODO = "INIC_ANO"  then strDT_INI = DateSerial(DatePart("YYYY", Date), 1, 1)
 if strPERIODO = "ULT_60D"   then strDT_INI = DateAdd("D", -60, Date)
 if strPERIODO = "ULT_90D"   then strDT_INI = DateAdd("D", -90, Date)
 if strPERIODO = "ULT_12M"   then strDT_INI = DateAdd("M", -12, Date)
 if strPERIODO = "MES_ANTERIOR" then 
	strDT_INI = DateSerial(DatePart("YYYY", DateAdd("M", -1, Date)), DatePart("M", DateAdd("M", -1, Date)), 1)
	strDT_FIM = DateAdd("D", -1, DateSerial(DatePart("YYYY", Date), DatePart("M", Date), 1))
 end if

 if strPERIODO = "ESPECIFICO" then
	strDT_INI = GetParam("var_dt_ini") 
	strDT_FIM = GetParam("var_dt_fim") 
	
	if not IsDate(strDT_INI) then strDT_INI = ""
	if not IsDate(strDT_FIM) then strDT_FIM = ""
 end If

 strSQL = "SELECT"	&_
			"	LCTO.COD_LCTO_EM_CONTA,"		&_
			"	LCTO.OPERACAO,"	&_
			"	LCTO.CODIGO,"		&_	
			"	LCTO.TIPO,"			&_
			"	PLAN.COD_REDUZIDO," 	&_
			"	PLAN.NOME AS PLANO_CONTA,"		&_
			"	CUST.NOME AS CENTRO_CUSTO," 	&_
			"	LCTO.HISTORICO,"	&_
			"	LCTO.NUM_LCTO,"	&_
			"	LCTO.VLR_LCTO,"	&_
			"	LCTO.DT_LCTO "		&_
			"FROM FIN_LCTO_EM_CONTA LCTO "		&_
			"LEFT OUTER JOIN FIN_PLANO_CONTA PLAN ON (PLAN.COD_PLANO_CONTA = LCTO.COD_PLANO_CONTA) " 	 &_
			"LEFT OUTER JOIN FIN_CENTRO_CUSTO CUST ON (CUST.COD_CENTRO_CUSTO = LCTO.COD_CENTRO_CUSTO) " &_
			"LEFT OUTER JOIN FIN_CONTA CTA ON (LCTO.COD_CONTA = CTA.COD_CONTA) " &_
			"WHERE LCTO.COD_LCTO_EM_CONTA > 0 "
	if strDT_INI<>"" and strDT_FIM<>"" then 
		strSQL = strSQL & " AND LCTO.DT_LCTO BETWEEN '" & PrepDataBrToUni(strDT_INI,false) & "' AND '" & PrepDataBrToUni(strDT_FIM,false) & "' "
	end if
	if strCONTA<>"" then strSQL = strSQL & " AND (LCTO.COD_CONTA =" & strCONTA & ") "
	strSQL = strSQL & " ORDER BY DT_LCTO DESC "
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
%>
<html>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body>
<%	
 if not objRS.Eof then 
	boolLCTO = false
%>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <!-- Possibilidades de tipo de sort...
  class="sortable-date-dmy"
  class="sortable-currency"
  class="sortable-numeric"
  class="sortable"
 -->
 <thead>
  <tr>
    <th width="1%" height="16"></th>
    <th width="1%"></th>
	<th width="1%"></th>
    <th width="1%"  class="sortable">Operação</th>
    <th width="15%" class="sortable">Entidade</th>						
    <th width="23%" class="sortable" nowrap>Plano de Conta</th>
    <th width="33%" class="sortable">Histórico</th>		
    <th width="1%"  class="sortable-numeric">Número</th>						
    <th width="1%"  class="sortable-currency" nowrap>Valor (R$)</th>
    <th width="1%"  class="sortable-date-dmy">Data</th>								
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%	
		while not objRS.Eof
			strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
			
			strSALDO = "0,00"
			if GetValue(objRS,"VLR_LCTO")<>"" then strSALDO =FormataDecimal(GetValue(objRS,"VLR_LCTO"),2)
			
			strSQL=""
			if GetValue(objRS, "TIPO")="ENT_CLIENTE"	 and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME_COMERCIAL AS NOME FROM ENT_CLIENTE		WHERE COD_CLIENTE     =" & GetValue(objRS,"CODIGO")
			if GetValue(objRS, "TIPO")="ENT_FORNECEDOR"  and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME_COMERCIAL AS NOME FROM ENT_FORNECEDOR	WHERE COD_FORNECEDOR  =" & GetValue(objRS,"CODIGO")
			if GetValue(objRS, "TIPO")="ENT_COLABORADOR" and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME FROM ENT_COLABORADOR WHERE COD_COLABORADOR =" & GetValue(objRS,"CODIGO")
	
			strENTIDADE=""
			if strSQL<>"" then 
				Set objRSa = objConn.Execute(strSQL)
				if not objRSa.Eof then strENTIDADE = GetValue(objRSa,"NOME")
				FechaRecordSet objRSa
			end if 
	%>
	  <tr bgcolor=<%=strCOLOR%>> 
        <td><%=MontaLinkGrade("modulo_FIN_LCTOCONTA","Delete.asp",GetValue(objRS,"COD_LCTO_EM_CONTA"),"IconAction_DEL.gif","REMOVER")%></td>
        <td><%=MontaLinkGrade("modulo_FIN_LCTOCONTA","Update.asp",GetValue(objRS,"COD_LCTO_EM_CONTA"),"IconAction_EDIT.gif","ALTERAR")%></td>
        <td><%=MontaLinkGrade("modulo_FIN_LCTOCONTA","Detail.asp",GetValue(objRS,"COD_LCTO_EM_CONTA"),"IconAction_DETAIL.gif","DETALHE")%></td>
        <td><%=GetValue(objRS,"OPERACAO")%></td>
        <td nowrap><%=strENTIDADE%></td>
        <td nowrap><%=GetValue(objRS,"COD_REDUZIDO")%>&nbsp;&nbsp;<%=GetValue(objRS,"PLANO_CONTA")%></td>
        <td><%=GetValue(objRS,"HISTORICO")%></td>
        <td nowrap><%=GetValue(objRS,"NUM_LCTO")%></td>
        <td align="right"><%=strSALDO%></td>
        <td align="right"><%=PrepData(GetValue(objRS,"DT_LCTO"),true,false)%></td>
	  </tr>
	<%
		athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
	wend
%>
 <tbody>  
</table>
<%
 end if
 
 strSQL = " SELECT T1.COD_LCTO_TRANSF, T1.COD_CONTA_ORIG, T2.NOME AS CONTA_ORIG, T1.COD_CONTA_DEST"	&_
			"     ,T3.NOME AS CONTA_DEST, T1.HISTORICO, T1.NUM_LCTO, T1.VLR_LCTO, T1.DT_LCTO " &_
			" FROM FIN_LCTO_TRANSF AS T1, FIN_CONTA AS T2, FIN_CONTA AS T3 " &_
			"WHERE T1.COD_CONTA_ORIG = T2.COD_CONTA AND T1.COD_CONTA_DEST = T3.COD_CONTA "

 if strDT_INI<>"" and strDT_FIM<>"" then strSQL = strSQL & " AND DT_LCTO BETWEEN '" & PrepDataBrToUni(strDT_INI,false) & "' AND '" & PrepDataBrToUni(strDT_FIM,false) & "'"
 if strCONTA<>"" then	strSQL = strSQL &	" AND (COD_CONTA_ORIG =" & strCONTA & " OR COD_CONTA_DEST =" & strCONTA & ")"
 strSQL = strSQL &	"ORDER BY DT_LCTO DESC "

 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
 if not objRS.Eof then 
	boolTRANSF = false
%>
TRANSFERÊNCIAS:<br><br>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <!-- Possibilidades de tipo de sort...
  class="sortable-date-dmy"
  class="sortable-currency"
  class="sortable-numeric"
  class="sortable"
 -->
 <thead>
   <tr>
		<th width="01%"></th>
	    <th width="35%" class="sortable">Origem</th>
	    <th width="35%" class="sortable">Destino</th>								
	    <th width="35%" class="sortable">Histórico</th>		
	    <th width="05%" class="sortable">Número</th>						
	    <th width="03%" class="sortable-currency" nowrap>Valor (R$)</th>
    	<th width="01%" class="sortable-date-dmy">Data</th>										
	</tr>
  </thead>
 <tbody style="text-align:left;">
<%	
	while not objRS.Eof
		strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")

		strSALDO = "0,00"
		if GetValue(objRS,"VLR_LCTO")<>"" then strSALDO = FormataDecimal(GetValue(objRS,"VLR_LCTO"),2)
%>
	<tr bgcolor=<%=strCOLOR%>>
		<td><%=MontaLinkGrade("modulo_FIN_LCTOCONTA","DetailTransf.asp",GetValue(objRS,"COD_LCTO_TRANSF"),"IconAction_DETAIL.gif","DETALHE")%></td>		
		<td nowrap><%=GetValue(objRS,"CONTA_ORIG")%></td>
		<td nowrap><%=GetValue(objRS,"CONTA_DEST")%></td>
		<td><%=GetValue(objRS,"HISTORICO")%></td>
		<td nowrap><%=GetValue(objRS,"NUM_LCTO")%></td>
		<td align="right"><%=strSALDO%></td>
		<td align="right"><%=PrepData(GetValue(objRS,"DT_LCTO"),true,false)%></td>
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
	FechaRecordSet objRS
end if

if boolLCTO and boolTRANSF then Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
FechaDBConn objConn
%>