<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FIN_CONTAS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"--> 
<%
 Dim objConn, objRS, objRSa, strSQL, strSQLClause
 Dim strCOOKIE_ID_USUARIO, strGRUPO_USUARIO
 Dim strSITUACAO, strSALDO
 Dim strDEL, strCOLOR

 AbreDBConn objConn, CFG_DB 

 strSITUACAO = GetParam("var_situacao")

 strCOOKIE_ID_USUARIO = LCase(Request.Cookies("VBOSS")("ID_USUARIO"))
 strGRUPO_USUARIO     = UCase(Request.Cookies("VBOSS")("GRUPO_USUARIO"))
 
 strCOLOR = "#DAEEFA"
 
 strSQL =          " SELECT COD_CONTA, NOME, DESCRICAO, TIPO, VLR_SALDO "
 strSQL = strSQL & " FROM FIN_CONTA "
 if strSITUACAO="ATIVO" then	
   strSQL = strSQL & " WHERE DT_INATIVO IS NULL "
 else
   strSQL = strSQL & " WHERE DT_INATIVO IS NOT NULL "
 end if
 strSQL = strSQL & " ORDER BY NOME "
 
 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1 
 
 if not objRS.Eof then				 
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
	<th width="01%"></th>
	<th width="01%"></th>
	<th width="01%"></th>
	<!-- th width="01%"></th -->
	<!-- th width="01%"></th -->
	<!-- th width="01%"></th -->
	<th width="01%" class="sortable-numeric" nowrap>Cod</th>
	<th width="30%" class="sortable">Nome</th>
	<th width="40%" class="sortable">Descriçao</th>
	<th width="25%" class="sortable">Tipo</th>
	<th width="01%" class="sortable-currency" nowrap>Saldo (R$)</th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%	
	while not objRS.Eof
 	    strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")

		strSALDO = "0,00"
		if GetValue(objRS,"VLR_SALDO")<>"" then strSALDO = FormataDecimal(GetValue(objRS,"VLR_SALDO"),2)
	
		strSQL = " SELECT (SELECT Count(COD_LCTO_EM_CONTA) FROM FIN_LCTO_EM_CONTA WHERE COD_CONTA=" & GetValue(objRS,"COD_CONTA") & ") AS CT1 "	&_
				 "      , (SELECT Count(COD_CONTA_PAGAR_RECEBER) FROM FIN_CONTA_PAGAR_RECEBER WHERE COD_CONTA=" & GetValue(objRS,"COD_CONTA") & ") AS CT2 " &_		
				 "      , Count(COD_LCTO_TRANSF) AS CT3 " &_
				 " FROM FIN_LCTO_TRANSF " &_
				 " WHERE COD_CONTA_ORIG=" & GetValue(objRS,"COD_CONTA") &_
				 " OR	COD_CONTA_DEST=" & GetValue(objRS,"COD_CONTA")
		
		AbreRecordSet objRSa, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1 
		
		strDEL = (CInt(GetValue(objRSa,"CT1"))<1 and CInt(GetValue(objRSa,"CT2"))<1 and CInt(GetValue(objRSa,"CT3"))<1)
		FechaRecordSet objRSa
%>
	<tr bgcolor="<%=strCOLOR%>" valign="middle">
		<td>
		<% if strDEL then %>		
			<%=MontaLinkGrade("modulo_FIN_CONTAS","Delete.asp",GetValue(objRS,"COD_CONTA"),"IconAction_DEL.gif","REMOVER")%>
		<% end if %>	
		</td>
		<td><%=MontaLinkGrade("modulo_FIN_CONTAS","Update.asp",GetValue(objRS,"COD_CONTA"),"IconAction_EDIT.gif","ALTERAR")%></td>
		<td><%=MontaLinkGrade("modulo_FIN_CONTAS","Detail.asp",GetValue(objRS,"COD_CONTA"),"IconAction_DETAIL.gif","DETALHES")%></td>		
		<!-- td><%'=MontaLinkGrade("modulo_FIN_LCTOCONTA","Insert.asp",GetValue(objRS,"COD_CONTA")&"&var_tipo=DESP","IconAction_LCTOout.gif","INSERIR DESPESA")%></td -->		
		<!-- td><%'=MontaLinkGrade("modulo_FIN_LCTOCONTA","Insert.asp",GetValue(objRS,"COD_CONTA")&"&var_tipo=REC","IconAction_LCTOin.gif","INSERIR RECEITA")%></td -->		
		<!-- td><%'=MontaLinkGrade("modulo_FIN_LCTOCONTA","InsertTransf.asp",GetValue(objRS,"COD_CONTA"),"IconAction_TRANSF.gif","INSERIR TRANSFERÊNCIA")%></td -->		
		<td nowrap><%=GetValue(objRS,"COD_CONTA")%></td>
		<td nowrap><%=GetValue(objRS,"NOME")%></td>
		<td><%=GetValue(objRS,"DESCRICAO")%></td>
		<td nowrap><%=GetValue(objRS,"TIPO")%></td>
		<td align="right" nowrap><%=strSALDO%></td>
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
   Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
 end if
 FechaRecordSet objRS
 FechaDBConn objConn
%>