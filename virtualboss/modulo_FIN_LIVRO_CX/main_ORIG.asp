<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FIN_LIVRO_CX", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="_includeMontaSQLs.asp"--> 
<%
 Dim objConn, objRS, strSQL, objRSAux
 Dim strMES, strMES_NEXT, strANO 
 Dim strDT_INI, strDT_FIM
 Dim strORIGEM, strDESTINO, strENTIDADE
 Dim strVALOR, strMOSTRA_TOTAL
 Dim strTOTAL_ENTRADA, strTOTAL_SAIDA
 Dim strSALDO_ANTERIOR, strSALDO_PARCIAL
 Dim strPREVISTA, strREALIZADA, strPLANOCONTA
 Dim strPARAM1, strPARAM2, strPARAM3, strPARAM4, strPARAM5
 Dim strCOLOR

 AbreDBConn objConn, CFG_DB 

 strMES	= GetParam("var_mes")
 strANO	= GetParam("var_ano")
 
 'athDebug "<br>mes: " & strMES, false
 'athDebug "<br>ano: " & strANO, false

 strSALDO_ANTERIOR = 0
 if strMES="" then 
	strDT_INI = DateSerial(strANO, 1, 1)
	strDT_FIM = DateSerial(strANO, 12, 31)
 else
	strDT_INI = DateSerial(strANO, strMES, 1)
	strDT_FIM = DateAdd("D", -1, DateAdd("M", 1, strDT_INI))
 end if
 'athDebug "<br>strDT_INI: " & PrepDataBrToUni(strDT_INI, false) & "<br>strDT_FIM: " & PrepDataBrToUni(strDT_FIM, false), false

 if strANO<>"" then
    '-------------------------------------------------------------------------
	' ATENÇAO
	' ------------------------------------------------------------------------
	' Union não funciona no MYSQL 4.1.18. Didivi a consulta em duas e coloquei 
	' os dados numa matriz, alimentada pelas duas consultas.
	' ------------------------------------------------------------------------
	const CODIGO           = 0
	const CONTA_PREVISTA   = 1
	const OPERACAO         = 2
	const MODULO           = 3
	const TIPO             = 4
	const COD_ENTIDADE     = 5
	const HISTORICO        = 6
	const VALOR            = 7
	const DATA             = 8
	const CONTA_REL        = 9
	const COD_PLANO_CONTA  = 10
	const COD_REDUZIDO     = 11
	const NOME_PLANO_CONTA = 12
	
    dim matRS()
    dim intTAMlin, intTAMcol, intTamNew
    dim i,j,strUSUARIO

	intTAMlin = 10500
	intTAMcol = 13
	intTamNew = 0
 	redim matRS(intTAMcol,intTAMlin)
	
	strSQL = MontaSQLUnion_A(strDT_INI, strDT_FIM, strANO)
	''athDebug "<br>MontaSQLUnion_A: " & strSQL, False

	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
 	i = 0
 	Do While Not objRS.Eof
		matRS(CODIGO,i)           = GetValue(objRS, "CODIGO")
		matRS(CONTA_PREVISTA,i)   = GetValue(objRS, "CONTA_PREVISTA")
		matRS(OPERACAO,i)         = GetValue(objRS, "OPERACAO")
		matRS(MODULO,i)           = GetValue(objRS, "MODULO")
		matRS(TIPO,i)             = GetValue(objRS, "TIPO")
		matRS(COD_ENTIDADE,i)     = GetValue(objRS, "COD_ENTIDADE")
		matRS(HISTORICO,i)        = GetValue(objRS, "HISTORICO")
		matRS(VALOR,i)            = GetValue(objRS, "VALOR")
		matRS(DATA,i)             = GetValue(objRS, "DATA")
		matRS(CONTA_REL,i)        = GetValue(objRS, "CONTA_REALIZADA")
		matRS(COD_PLANO_CONTA,i)  = GetValue(objRS, "COD_PLANO_CONTA")
		matRS(COD_REDUZIDO,i)     = GetValue(objRS, "COD_REDUZIDO")
		matRS(NOME_PLANO_CONTA,i) = GetValue(objRS, "NOME_PLANO_CONTA")
		
		'athDebug "<br>cons a " & GetValue(objRS, "CODIGO"), false
		
		athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
		i = i + 1
		if (i > intTAMlin) then
 		  Mensagem "A Consulta ultrapassou o número máximo de registros a retornar ("&i&").<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
		  Response.End()
	    end if
	Loop
	
    intTamNew = i 'i-1
    redim preserve matRS(intTAMcol,intTamNew) 
    FechaRecordSet objRS
	
    ' Abre espaço para o próximo SQL
	intTamNew = intTamNew + intTAMlin
    redim preserve matRS(intTAMcol,intTamNew) 
	
	strSQL = MontaSQLUnion_B(strDT_INI, strDT_FIM, strANO)
	''athDebug "<br>MontaSQLUnion_B: " & strSQL, False
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	Do While Not objRS.Eof
		matRS(CODIGO,i)           = GetValue(objRS, "CODIGO")
		matRS(CONTA_PREVISTA,i)   = GetValue(objRS, "CONTA_PREVISTA")
		matRS(OPERACAO,i)         = GetValue(objRS, "OPERACAO")
		matRS(MODULO,i)           = GetValue(objRS, "MODULO")
		matRS(TIPO,i)             = GetValue(objRS, "TIPO")
		matRS(COD_ENTIDADE,i)     = GetValue(objRS, "COD_ENTIDADE")
		matRS(HISTORICO,i)        = GetValue(objRS, "HISTORICO")
		matRS(VALOR,i)            = GetValue(objRS, "VALOR")
		matRS(DATA,i)             = GetValue(objRS, "DATA")
		matRS(CONTA_REL,i)        = GetValue(objRS, "CONTA_REALIZADA")
		matRS(COD_PLANO_CONTA,i)  = GetValue(objRS, "COD_PLANO_CONTA")
		matRS(COD_REDUZIDO,i)     = GetValue(objRS, "COD_REDUZIDO")
		matRS(NOME_PLANO_CONTA,i) = GetValue(objRS, "NOME_PLANO_CONTA")
		
		'athDebug "<br>cons b " & GetValue(objRS, "CODIGO"), false
		
		athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
		i = i + 1
		if ((i-intTAMlin) > intTAMlin) then
			Mensagem "A Consulta ultrapassou o número máximo de registros a retornar.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
			Response.End()
		end if
	Loop
	
    intTamNew = i 'i-1
    redim preserve matRS(intTAMcol,intTamNew) 
    FechaRecordSet objRS
	
    ' Debug da Matriz gerada...
	' -----------------------------------------------
	'athDebug "<br>intTamNew" & intTamNew, false
	'athDebug "<table>", false
	'for i=0 to intTamNew
	'  athDebug "<tr>", false
	'  for j=0 to intTAMcol
	'    athDebug "<td><small>" & matRS(j,i) & "</small><td>", false
	'  next
	'  athDebug "</tr>", false
	'next  
	'athDebug "</table>", false
	
	QuickSortLctos matRS, 0, intTamNew-1, intTAMcol, 1, "DATA"
	
	'athDebug "<br><br>intTamNew " & intTamNew, False
	
	'athDebug "<br>intTamNew" & intTamNew, false
	'athDebug "<table>", false
	'for i=0 to intTamNew-1
	'  athDebug "<tr>", false
	'  for j=0 to intTAMcol
	'    athDebug "<td><small>" & matRS(j,i) & "</small><td>", false
	'  next
	'  athDebug "</tr>", false
	'next  
	'athDebug "</table>", true

	Function BuscaSaldo(prMES, prANO)
		Dim strSQLlocal, objRSlocal1, objRSlocal2
		Dim strSALDO, strVALOR
		
		strSALDO = 0
		
		strSQLlocal = " SELECT COD_CONTA FROM FIN_CONTA "
		
		AbreRecordSet objRSlocal1, strSQLlocal, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		if not objRSlocal1.eof then
			while not objRSlocal1.eof
				if prMES <> "" then 					
					strSQLlocal =               " SELECT VALOR AS SALDO_ANTERIOR, STR_TO_DATE(CONCAT('01 ', MES, ' ', ANO),'%d %m %Y') AS DATA_AC "													
					strSQLlocal = strSQLlocal & " FROM FIN_SALDO_AC WHERE STR_TO_DATE(CONCAT('01 ', MES, ' ', ANO),'%d %m %Y') "
					strSQLlocal = strSQLlocal & "                       < STR_TO_DATE(CONCAT('01 ', " & prMES & ", ' ', " & prANO & "),'%d %m %Y') "
					strSQLlocal = strSQLlocal & " AND COD_CONTA=" & GetValue(objRSlocal1,"COD_CONTA") & " ORDER BY 2 DESC LIMIT 1 "
'athDebug "<br><br>SQL 1 " & strSQLlocal, False
				else
					strSQLlocal =               " SELECT VALOR AS SALDO_ANTERIOR, STR_TO_DATE(CONCAT('01 ', MES, ' ', ANO),'%d %m %Y') AS DATA "
					strSQLlocal = strSQLlocal & " FROM FIN_SALDO_AC WHERE ANO < "& prANO &" AND COD_CONTA="& GetValue(objRSlocal1,"COD_CONTA") 
					strSQLlocal = strSQLlocal & " ORDER BY 2 DESC LIMIT 1 "
'athDebug "<br><br>SQL 2 " & strSQLlocal, False
				end if
				
				AbreRecordSet objRSlocal2, strSQLlocal, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
				
				strVALOR = ""
				if not objRSlocal2.eof then strVALOR = GetValue(objRSlocal2,"SALDO_ANTERIOR")
				
				if CStr(strVALOR) <> "" then 
					strSALDO = strSALDO + CDbl(strVALOR)
				else
					strSQLlocal = "SELECT VLR_SALDO_INI FROM FIN_CONTA WHERE COD_CONTA=" & GetValue(objRSlocal1,"COD_CONTA")
'athDebug "<br><br>SQL 3 " & strSQLlocal, False
					AbreRecordSet objRSlocal2, strSQLlocal, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
					if not objRSlocal2.eof then strSALDO = strSALDO + CDbl(GetValue(objRSlocal2,"VLR_SALDO_INI"))				
				end if
				
				FechaRecordSet objRSlocal2
				athMoveNext objRSlocal1, ContFlush, 0
			wend
		end if
		FechaRecordSet objRSlocal1
		
		BuscaSaldo = strSALDO
	End Function
	
	if intTamNew > 0 then 
%>
<html>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <thead>
  <tr> 
    <th WIDTH="01%"></th>		
    <th WIDTH="01%">Data</th>		
    <th WIDTH="20%">Entidade</th>
    <th WIDTH="10%">Prevista</th>
    <th WIDTH="20%">Realizada</th>								
    <th WIDTH="20%">Plano de COnta</th>								
    <th WIDTH="25%">Histórico</th>
    <th WIDTH="01%" nowrap>Vlr Entrada</th>
    <th WIDTH="01%" nowrap>Vlr Saída</th>								
    <th WIDTH="01%"></th>		
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%	
		strTOTAL_ENTRADA = 0
		strTOTAL_SAIDA = 0
		strSALDO_ANTERIOR = 0
		
        i=0
	    strMES = month(matRS(DATA,i))
  		while i < intTamNew
			If i = 0 Then
				strSALDO_ANTERIOR = BuscaSaldo(strMES, strANO)
				
				Response.Write "<tr bgcolor='" & strCOLOR & "' valign='middle' class='arial11'>"
				Response.Write "<td height='16px' colspan='7' align='right'><b>Saldo Total Anterior:</b></td>"
				Response.Write "<td align='right'><b>" & FormataDecimal(strSALDO_ANTERIOR,2) & "</b></td><td></td><td></td></tr>"
			End If
			
		    strCOLOR = swapString (strCOLOR,"#F5FAFA","#FFFFFF")
			strVALOR = 0
			if matRS(VALOR,i)<>"" then strVALOR = FormataDecimal(matRS(VALOR,i),2)
			
			strSQL=""
			if matRS(TIPO,i)="ENT_CLIENTE"	   and IsNumeric(matRS(COD_ENTIDADE,i)) then strSQL = "SELECT NOME_COMERCIAL AS NOME FROM ENT_CLIENTE     WHERE COD_CLIENTE     =" & matRS(COD_ENTIDADE,i)
			if matRS(TIPO,i)="ENT_FORNECEDOR"  and IsNumeric(matRS(COD_ENTIDADE,i)) then strSQL = "SELECT NOME_COMERCIAL AS NOME FROM ENT_FORNECEDOR  WHERE COD_FORNECEDOR  =" & matRS(COD_ENTIDADE,i)
			if matRS(TIPO,i)="ENT_COLABORADOR" and IsNumeric(matRS(COD_ENTIDADE,i)) then strSQL = "SELECT NOME                   FROM ENT_COLABORADOR WHERE COD_COLABORADOR =" & matRS(COD_ENTIDADE,i)
			
			strENTIDADE=""
			if strSQL<>"" then 
				AbreRecordSet objRSAux, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
				strENTIDADE=""
				if not objRSAux.Eof then strENTIDADE = GetValue(objRSAux,"NOME")
				FechaRecordSet objRSAux
			end if 
			
			strPREVISTA  = matRS(CONTA_PREVISTA,i)
			strREALIZADA = matRS(CONTA_REL,i)
			
			if matRS(OPERACAO,i) = "SAIDA" then
				strTOTAL_SAIDA = strTOTAL_SAIDA + CDbl(strVALOR)
			else
				strTOTAL_ENTRADA = strTOTAL_ENTRADA + CDbl(strVALOR)
			end if
			
			strSALDO_PARCIAL = strTOTAL_ENTRADA - strTOTAL_SAIDA
			
			strPLANOCONTA = matRS(NOME_PLANO_CONTA ,i) & "&nbsp;(" & matRS(COD_PLANO_CONTA ,i) & ")"
			IF matRS(COD_REDUZIDO ,i)<>"" then strPLANOCONTA =  matRS(COD_REDUZIDO ,i) & " - " & strPLANOCONTA
%>
	<tr bgcolor="<%=strCOLOR%>">
		<td><%=MontaLinkGrade("modulo_FIN_"& matRS(MODULO,i),"Detail.asp",matRS(CODIGO,i),"IconAction_DETAIL.gif","DETALHE COM INSERÇÃO DE LCTO")%></td>
		<td nowrap><%=PrepData(matRS(DATA,i),true,false)%></td>
		<td><%=strENTIDADE%></td>
		<td><%=strPREVISTA%></td>
		<td><%=strREALIZADA%></td>
		<td nowrap><%=strPLANOCONTA%></td>
		<td><%=matRS(HISTORICO,i)%></td>
		<td ALIGN="right"><% if matRS(OPERACAO,i) = "ENTRADA" then Response.Write(strVALOR) %></td>
		<td ALIGN="right"><% if matRS(OPERACAO,i) = "SAIDA" then Response.Write(strVALOR) %></td>
		<td nowrap><img src="../img/<% if matRS(OPERACAO,i) = "SAIDA" then Response.Write("icon_FinContaPagar.gif") Else Response.Write("icon_FinContaReceber.gif") end if %>" align="middle" center width:"21px" title="<%=matRS(OPERACAO,i)%>" alt="<%=matRS(OPERACAO,i)%>"></td></tr>
	</tr>
<%
		strMES = Month(matRS(DATA,i))
		
		i = i + 1
		strMOSTRA_TOTAL = (i>=intTamNew)
		if i<intTamNew then strMES_NEXT = month(matRS(DATA,i)) end if
		if (strMES<>strMES_NEXT) or strMOSTRA_TOTAL then
			strSALDO_ANTERIOR = strSALDO_ANTERIOR + strSALDO_PARCIAL
%>
	<TR>
		<TD COLSPAN="7" align="right" WIDTH="98%">Valor Total:</TD>
		<TD WIDTH="01%" align="right"><b><%=FormataDecimal(strTOTAL_ENTRADA,2)%></b></TD>
		<TD WIDTH="01%" align="right"><b><%=FormataDecimal(strTOTAL_SAIDA,2)%></b></TD>
		<TD>&nbsp;</TD>
	</TR>
	<TR ALIGN="right">
		<TD COLSPAN="7" align="right">Saldo Parcial:</TD>
		<TD>&nbsp;</TD>
		<TD nowrap align="right"><b><%=FormataDecimal(strSALDO_PARCIAL,2)%></b></TD>
		<TD>&nbsp;</TD>		
	</TR>
	<TR ALIGN="right">
		<TD COLSPAN="7" align="right">Saldo no Período:</TD>
		<TD>&nbsp;</TD>
		<TD nowrap align="right"><b><%=FormataDecimal(strSALDO_ANTERIOR,2)%></b></TD>
		<TD>&nbsp;</TD>		
	</TR>
<%
			strTOTAL_ENTRADA = 0
			strTOTAL_SAIDA   = 0
			
			if i<intTamNew then
				Response.Write "<tr><td colspan='10' width='100%' style='border-bottom:1px solid #333333;'></td></tr>"
				Response.Write "<tr bgcolor='#FFFFFF' valign='middle' class='arial11'>"
				Response.Write "<td height='16px' colspan='7' align='right'>Saldo Total Anterior:</div></td>"
				Response.Write "<td align='right'><b>" & FormataDecimal(strSALDO_ANTERIOR,2) & "</b></td><td></td><td></td></tr>"
			end if
		end if
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
	FechaDBConn objConn
end if
%>