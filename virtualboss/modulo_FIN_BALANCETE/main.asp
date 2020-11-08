<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% 
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FIN_BALANCETE", Request.Cookies("VBOSS")("ID_USUARIO")), true 
%>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="_includeMontaSQLs.asp"--> 
<%
Dim objConn, objRS, objRSa, strSQL
Dim strMES, strANO, strTPCONS, strCOLOR, strAUX, strAUXDT, strENTIDADE
Dim auxIN, auxOUT, dblTotalIN, dblTotalOUT, dblSaldoAc, flag, dblTotalParcialIN, dblTotalParcialOUT

AbreDBConn objConn, CFG_DB 

strMES	  = GetParam("var_mes")
strANO	  = GetParam("var_ano")
strTPCONS = GetParam("var_tpcons")

If strMES <> "" And strANO <> "" Then
	const COD_REDUZIDO = 0
	const DESCRICAO    = 1
	const DATA         = 2
	const HISTORICO    = 3
	const VALOR        = 4
	const OPERACAO     = 5
	const TIPO         = 6
	const COD_ENTIDADE = 7
	const ORDEM        = 8
	
    dim matRS()
    dim intTAMlin, intTAMcol, intTamNew
    dim i,j,strUSUARIO

	intTAMlin = 10500
	intTAMcol = 9
	intTamNew = 0
 	redim matRS(intTAMcol,intTAMlin)
	
	strSQL = MontaSQLUnion_A(strMES, strANO, strTPCONS)
	'athDebug "<br>MontaSQLUnion_A: " & strSQL, False
	
	Function CalculaOrdem(prCOD_REDUZIDO, prDATA, prANO, prMES)
		Dim strORDEM
		
		strORDEM = 0
		If prCOD_REDUZIDO <> "" Then
			strORDEM = Replace(prCOD_REDUZIDO, ".", "")
			strORDEM = CDbl(strORDEM * 100)
		End If
		
		If IsDate(prDATA) And IsNumeric(prANO) And IsNumeric(prMES) Then
			strORDEM = strORDEM + DateDiff("D", DateSerial(prANO, prMES, 1), prDATA) 
		End If
		
		CalculaOrdem = strORDEM
	End Function
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
 	i = 0
 	Do While Not objRS.Eof
		matRS(COD_REDUZIDO,i) = GetValue(objRS, "COD_REDUZIDO")
		matRS(DESCRICAO,i)    = GetValue(objRS, "DESCRICAO")
		matRS(DATA,i)         = GetValue(objRS, "DATA")
		matRS(HISTORICO,i)    = GetValue(objRS, "HISTORICO")
		matRS(VALOR,i)        = GetValue(objRS, "VALOR")
		matRS(OPERACAO,i)     = GetValue(objRS, "OPERACAO")
		matRS(TIPO,i)         = GetValue(objRS, "TIPO")
		matRS(COD_ENTIDADE,i) = GetValue(objRS, "COD_ENTIDADE")
		matRS(ORDEM,i)        = CalculaOrdem(GetValue(objRS, "COD_REDUZIDO"), GetValue(objRS, "DATA"), strANO, strMES)
		
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
	
	strSQL = MontaSQLUnion_B(strMES, strANO, strTPCONS)
	'athDebug "<br>MontaSQLUnion_B: " & strSQL, False
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	Do While Not objRS.Eof
		matRS(COD_REDUZIDO,i) = GetValue(objRS, "COD_REDUZIDO")
		matRS(DESCRICAO,i)    = GetValue(objRS, "DESCRICAO")
		matRS(DATA,i)         = GetValue(objRS, "DATA")
		matRS(HISTORICO,i)    = GetValue(objRS, "HISTORICO")
		matRS(VALOR,i)        = GetValue(objRS, "VALOR")
		matRS(OPERACAO,i)     = GetValue(objRS, "OPERACAO")
		matRS(TIPO,i)         = GetValue(objRS, "TIPO")
		matRS(COD_ENTIDADE,i) = GetValue(objRS, "COD_ENTIDADE")
		matRS(ORDEM,i)        = CalculaOrdem(GetValue(objRS, "COD_REDUZIDO"), GetValue(objRS, "DATA"), strANO, strMES)
		
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
	
	QuickSortLctos matRS, 0, intTamNew-1, intTAMcol, 1, "ORDEM"
	
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
	'athDebug "</table>", false
	
	
	'Busca o SALDO ACUMULADO Do MÊS ANTERIOR -----------------------
	strSQL =          " SELECT SUM(VALOR) AS TOTAL "
	strSQL = strSQL & " FROM FIN_SALDO_AC "
	If strMES = 1 then 
		strSQL = strSQL & " WHERE MES= 12 AND ANO =" & strANO - 1
	else
		strSQL = strSQL & " WHERE MES = " & strMES - 1 & " AND ANO =" & strANO
	end if
	
	dblSaldoAc = 0
	Set objRs = objConn.Execute(strSQL) 
	If Not objRS.EOF Then dblSaldoAc = getValue(objRS,"TOTAL")   
	FechaRecordSet ObjRS
	' -------------------------------------------------------------
	
	if intTamNew > 0 then 
%>
<html>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body>
<strong>Balancete do exercício - periodo: <%=MesExtensoAbrev(strMES)%>/<%=strANO%></strong>
<br><br>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%;" class="tablesort">
 <thead>
  <tr> 
	<th width="2%">Cod.R</th>
    <th width="15%">P.Conta/C.Custo</th>
	<th width="8%">Data</th>
	<th width="20%">Entidade</th>
	<th width="42%">Histórico</th>
    <th width="1%">ENTRADA</th>
    <th width="1%">SAIDA</th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%
 strAUX = "-1"
 strAUXDT = ""
 dblTotalIN  = 0
 dblTotalOUT = 0
 dblTotalParcialIN  = 0
 dblTotalParcialOUT = 0
 flag = 0
 i=0
 while i < intTamNew
	strCOLOR = SwapString(strCOLOR,"#FFFFFF","#F5FAFA")
	
	strSQL=""
	if matRS(TIPO,i)="ENT_CLIENTE"	   then strSQL = "SELECT NOME_COMERCIAL AS NOME FROM ENT_CLIENTE     WHERE COD_CLIENTE     = " & matRS(COD_ENTIDADE,i)
	if matRS(TIPO,i)="ENT_FORNECEDOR"  then strSQL = "SELECT NOME_COMERCIAL AS NOME FROM ENT_FORNECEDOR  WHERE COD_FORNECEDOR  = " & matRS(COD_ENTIDADE,i)
	if matRS(TIPO,i)="ENT_COLABORADOR" then strSQL = "SELECT NOME                   FROM ENT_COLABORADOR WHERE COD_COLABORADOR = " & matRS(COD_ENTIDADE,i)
	
	strENTIDADE=""
	if strSQL<>"" then 
		AbreRecordSet objRSa, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		strENTIDADE=""
		if not objRSa.Eof then strENTIDADE = GetValue(objRSa,"NOME")
		FechaRecordSet objRSa
	end if
 %>
	<% IF strAUX <> matRS(COD_REDUZIDO,i) then %>
		<% IF flag=0 then %>
		<tr bgcolor='#C1DAD7'>
		  <td style='text-align:right;background-image:none;background-color:#C1DAD7;'></td>
		  <td colspan="4" style="text-align:right"><b>SALDO ANTERIOR: <%=FormataDecimal(dblSaldoAc, 2)%></b></td>
		  <%
		     'response.write "<td style='text-align:right' nowrap='nowrap' colspan='2'>" & FormataDecimal(dblSaldoAc, 2) & "</td>" 
		     response.write "<td colspan='2'></td>" 
		     flag=1
		  %>
		</tr>
		<% ELSE %>
		<tr bgcolor='#F1F1F1'> <!-- #C1DAD7 -->
		  <td colspan="5" style='text-align:right;background-image:none;background-color:#FFFFFF;'>SUBTOTAIS</td>
		  <% response.write "<td style='text-align:right' nowrap='nowrap'>" & FormataDecimal(dblTotalParcialIN, 2) & "</td><td style='text-align:right' nowrap='nowrap'>" & FormataDecimal(dblTotalParcialOUT, 2) & "</td>" %>
		</tr>
		<%
			dblTotalParcialIN  = 0
			dblTotalParcialOUT = 0
		%>
		<% END IF %>
	<% 
	    'strCOLOR = SwapString(strCOLOR,"#FFFFFF","#F5FAFA")
	   END IF 
	%>
	<tr bgcolor=<%=strCOLOR%>> 
		<% 
		 IF strAUX <> matRS(COD_REDUZIDO,i) then
			strAUX = matRS(COD_REDUZIDO,i)
			strAUXDT = ""
			response.write "<td style='text-align:right;background-image:none;background-color:"&strCOLOR&";' nowrap='nowrap'>" & strAUX & "</td><td>" & matRS(DESCRICAO,i) & "</td>"
		 ELSE	
			response.write "<td style='text-align:right;background-image:none;background-color:"&strCOLOR&";'></td><td></td>"
		 END IF 

		 IF strAUXDT <> matRS(DATA,i) then
			strAUXDT = matRS(DATA,i)
			response.write "<td style='text-align:right' nowrap='nowrap'>" & PrepData(matRS(DATA,i), True, False) & "</td>"
		 ELSE	
			response.write "<td></td>"
		 END IF 
		%>
		<td><%=strENTIDADE%></td>
		<td><%=matRS(HISTORICO,i)%></td>
		<%
		 auxIN  = ""
		 auxOUT = ""
		 IF (ucase(matRS(OPERACAO,i)) = "RECEITA") then 
		   auxIN=matRS(VALOR,i)
		   dblTotalIN = dblTotalIN + auxIN
		   dblTotalParcialIN = dblTotalParcialIN + auxIN
		 ELSE
		   auxOUT=matRS(VALOR,i)
		   dblTotalOUT = dblTotalOUT + auxOUT
		   dblTotalParcialOUT = dblTotalParcialOUT + auxOUT
		 END IF
		%>
		<td style="text-align:right" nowrap="nowrap"><% If auxIN <> "" Then Response.Write(FormataDecimal(auxIN,2)) %></td>
		<td style="text-align:right" nowrap="nowrap"><% If auxOUT <> "" Then Response.Write(FormataDecimal(auxOUT,2)) %></td>
	</tr>
 <%
    i = i + 1
 Wend

 If dblTotalIN <> 0 Or dblTotalOUT <> 0 Then
 %>
		<tr bgcolor='#F1F1F1'> <!-- #C1DAD7 -->
		  <td colspan="5"  style='text-align:right;background-image:none;background-color:#FFFFFF;'>SUBTOTAIS</td>
		  <% response.write "<td style='text-align:right' nowrap='nowrap'>" & FormataDecimal(dblTotalParcialIN, 2) & "</td><td style='text-align:right' nowrap='nowrap'>" & FormataDecimal(dblTotalParcialOUT, 2) & "</td>" %>
		</tr>
		<%
			dblTotalParcialIN  = 0
			dblTotalParcialOUT = 0
		%>
 <%
 End If
 
 If dblTotalIN >= 0 And dblTotalOUT >= 0 Then
 %>
		<tr bgcolor='#F1F1F1'> <!-- #C1DAD7 -->
		  <td colspan="5" style='text-align:right;background-image:none;background-color:#FFFFFF;'>TOTAIS</td>
		  <% 
		    response.write "<td style='text-align:right' nowrap='nowrap'>" & FormataDecimal(dblTotalIN, 2) & "</td>"
		    response.write "<td style='text-align:right' nowrap='nowrap'>" & FormataDecimal(dblTotalOUT, 2) & "</td>" 
		  %>
		</tr>
		<tr bgcolor='#C1DAD7'> <!-- #C1DAD7 -->
		  <td colspan="5" style='text-align:right;background-image:none;background-color:#C1DAD7;'>SALDO FINAL: <%=FormataDecimal(dblSaldoAc + dblTotalIN - dblTotalOUT, 2) %></td>
		  <% 
		    'response.write "<td style='text-align:right' nowrap='nowrap' colspan='2'>" & FormataDecimal(dblSaldoAc + dblTotalIN - dblTotalOUT, 2) & "</td>"
		    response.write "<td colspan='2'></td>" 
          %>
		</tr>
 <%
 End If
 %>
  </tbody>  
</table>
</body>
</html>
<%
	else
		Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
	end if
End If
FechaDBConn objConn
%>