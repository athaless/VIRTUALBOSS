<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
Dim objConn, objRS, strSQL
Dim strCOD_CONTA, strSALDO_INI, strSALDO, strCOLOR
		
strCOD_CONTA = GetParam("var_chavereg")
	
if strCOD_CONTA<>"" then
	AbreDBConn objConn, CFG_DB 
	
	strSQL =	" SELECT" 					&_	
				"	CTA.NOME,"				&_
				"	CTA.DESCRICAO,"			&_
				"	CTA.TIPO,"				&_
				"	CTA.COD_BANCO,"			&_				
				"	BCO.NOME AS NOME_BCO,"	&_								
				"	CTA.AGENCIA,"		&_			
				"	CTA.CONTA,"			&_
				"	CTA.DT_CADASTRO," 	&_								
				"	CTA.VLR_SALDO_INI,"	&_								
				"	CTA.VLR_SALDO,"		&_
				"	CTA.ORDEM,"			&_				
				"	CTA.DT_INATIVO"		&_				
				" FROM"					&_
				"	FIN_CONTA CTA "		&_
				" LEFT OUTER JOIN "		&_
				"	FIN_BANCO BCO ON (BCO.COD_BANCO=CTA.COD_BANCO)" &_				
				" WHERE CTA.COD_CONTA=" & strCOD_CONTA 
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
	
	if not objRS.eof then				 
		if GetValue(objRS,"VLR_SALDO_INI")<>"" then strSALDO_INI= FormataDecimal(GetValue(objRS,"VLR_SALDO_INI"),2)
		if GetValue(objRS,"VLR_SALDO")<>"" then strSALDO = FormataDecimal(GetValue(objRS,"VLR_SALDO"),2)
%>
<html>
	<script type="text/javascript" src="../_scripts/tablesort.js"></script>
	<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
	<link rel="stylesheet" type="text/css" href="../_css/menupure.css">
</head>
<body>
<%
	'Concatenamos o link corretamente para os casos
	'onde o redirect tenha sido informado ou não
	'Descomente se quiser utilizar o estilo menu css + tableheader
	'athBeginCssMenu()
	'	athCssMenuAddItem "#", "onClick=""displayArea('table_header');""", "_self", "CONTA <strong>" & strCOD_CONTA & "</strong> - " & GetValue(objRS,"NOME"), "", 0
	'athEndCssMenu("")
%>
<div id="table_header">
	<table align="center" cellpadding="0" cellspacing="1" class="tablesort">
	 <!-- Possibilidades de tipo de sort...
	  class="sortable-date-dmy"
	  class="sortable-currency"
	  class="sortable-numeric"
	  class="sortable"
	 -->
	 <thead>
	   <tr> 
		  <th width="150"></th>
		  <th>Conta Banco</th>
		</tr>
	  </thead>
	 <tbody style="text-align:left;">
	 	<tr><td align="right">Cod Conta Banco:&nbsp;</td><td><%=strCOD_CONTA%></td></tr>
	 	<tr><td align="right">Nome Conta:&nbsp;</td><td><%=GetValue(objRS,"NOME")%></td></tr>
		<tr><td align="right">Tipo:&nbsp;</td><td><%=GetValue(objRS,"TIPO")%></td></tr>
		<tr><td align="right">Cod Banco:&nbsp;</td><td><%=GetValue(objRS,"NOME_BCO")%></td></tr>
		<tr><td align="right">Agência:&nbsp;</td><td><%=GetValue(objRS,"AGENCIA")%></td></tr>
		<tr><td align="right">Conta:&nbsp;</td><td><%=GetValue(objRS,"CONTA")%></td></tr>  
		<tr><td align="right">Data Cadastro:&nbsp;</td><td><%=PrepData(GetValue(objRS,"DT_CADASTRO"),true,false)%></td></tr>
		<tr><td align="right">Data Inativo:&nbsp;</td><td><%=PrepData(GetValue(objRS,"DT_INATIVO"),true,true)%></td></tr>
		<tr><td align="right">Ordem:&nbsp;</td><td><%=GetValue(objRS,"ORDEM")%></td></tr>
		<tr><td align="right">Saldo Inicial:&nbsp;</td><td><%=strSALDO_INI%></td></tr>
		<tr><td align="right">Saldo:&nbsp;</td><td><%=strSALDO%></td></tr>
		<tr id="tableheader_last_row"><td align="right">Descrição:&nbsp;</td><td><%=GetValue(objRS,"DESCRICAO")%></td></tr>
	 </tbody>
	</table>
</div>
<br/>
<%
	end if 
	FechaRecordSet objRS
	
	strSQL = "SELECT COD_SALDO_AC,MES,ANO,VALOR,RECALCULADO,SYS_COD_USER_ULT_LCTO FROM FIN_SALDO_AC WHERE COD_CONTA=" & strCOD_CONTA & " ORDER BY ANO,MES"
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	if not objRS.Eof then
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
		<th width="1%"  class="sortable"  nowrap>Cod</th>
		<th width="10%" class="sortable-date-dmy" nowrap>Data</th>
		<th width="20%" class="sortable-numeric" nowrap>Mês</th>		
		<th width="30%" class="sortable-numeric" nowrap>Saldo</th>
		<th width="1%"  nowrap>Recalculado</th>
		<th width="30%" class="sortable-date-dmy" nowrap>Últ. Lcto</th>		
	</tr>
 </thead>
 <tbody style="text-align:left;">
<% 
      While Not objRs.Eof
		strCOLOR = swapString (strCOLOR,"#F5FAFA","#FFFFFF")
	%>
	<!--tr bgcolor=<%=strCOLOR%>-->
	<tr>
		<td align="right"><%=GetValue(objRS,"COD_SALDO_AC")%></td>
		<td><%=ATHFormataTamLeft(GetValue(objRS,"MES"),2,"0")%>/<%=GetValue(objRS,"ANO")%></td>
		<td><%=MesExtenso(GetValue(objRS,"MES"))%></td>	
		<td align="right"><%=FormataDecimal(GetValue(objRS,"VALOR"),2)%></div></td>
		<td align="center"><input type="checkbox" <%if GetValue(objRS,"RECALCULADO") then Response.Write("checked")%> disabled readonly></td>
		<td><%=GetValue(objRS,"SYS_COD_USER_ULT_LCTO")%></td>		
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
	end if 
	FechaRecordSet objRS
	FechaDBConn objConn
end if 
%>