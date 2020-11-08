<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_INVENTARIO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
 <!--#include file="../_database/athUtils.asp"--> 
<%
 Dim objConn, objRS, strSQL, strSQLClause
 Dim strNOME, strTIPO, strDIVISAO, strSITUACAO, strARQUIVOANEXO
 Dim TxDepDia, TxDepAno, QtdeDias, VlrOrig, VlrAtual
 Dim strCOLOR, strArquivo

 AbreDBConn objConn, CFG_DB 

 strNOME     = GetParam("var_nome")
 strTIPO     = GetParam("var_tipo")
 strDIVISAO  = GetParam("var_divisao")
 strSITUACAO = GetParam("var_situacao")

 strSQL =          " SELECT COD_INVENTARIO, ID_ITEM, NOME_ITEM, DESC_ITEM, DT_COMPRA, LOCAL_COMPRA, PRC_COMPRA, DT_GARANTIA "  
 strSQL = strSQL & "      , TIPO, MARCA, DIVISAO, OBS, ARQUIVO_ANEXO, DT_INATIVO, PROPRIEDADE "
 strSQL = strSQL & "      , SYS_DT_INS, SYS_USR_INS, SYS_DT_ALT, SYS_USR_ALT "
 strSQL = strSQL & " FROM INVENTARIO "
 strSQL = strSQL & " WHERE TRUE " 

 if strNOME <> ""           then strSQL = strSQL & " AND INVENTARIO.NOME_ITEM LIKE '" & strNOME & "%'"
 if strDIVISAO <> ""        then strSQL = strSQL & " AND INVENTARIO.DIVISAO LIKE '" & strDIVISAO & "%'" 
 if strTIPO <> ""           then strSQL = strSQL & " AND INVENTARIO.TIPO = '" & strTIPO & "'" 
 if strSITUACAO = "INATIVO" then strSQL = strSQL & " AND INVENTARIO.DT_INATIVO IS NOT NULL " 
 if strSITUACAO = "ATIVO"   then strSQL = strSQL & " AND INVENTARIO.DT_INATIVO IS NULL "
 
 strSQL = strSQL & " ORDER BY INVENTARIO.ID_ITEM, INVENTARIO.DIVISAO, INVENTARIO.TIPO"
 
 Set objRs = objConn.Execute(strSql) 
 If Not objRS.EOF Then
	
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
	<th width="4%"  class="sortable">ID</th>
    <th width="4%"  class="sortable">Nome</th>
	<th width="4%"  class="sortable" nowrap>Marca</th>
    <th width="39%" class="sortable">Descrição</th>
    <th width="10%" class="sortable" nowrap>Divisão</th>
	<th width="10%" class="sortable">Tipo</th>
	<th width="10%" class="sortable">Owner</th>
	<th width="5%"  class="sortable-currency" nowrap>Vlr Orig</th>
	<th width="5%"  class="sortable-currency" nowrap>Dep Dia %</th>
	<th width="5%"  class="sortable-currency" nowrap>Vlr Atl</th>
    <th width="1%"></th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%
      While Not objRs.Eof
		TxDepDia = ""
        VlrAtual = ""
		VlrOrig  = getValue(objRS,"PRC_COMPRA")
  	    strARQUIVOANEXO = GetValue(objRS,"ARQUIVO_ANEXO")
		
		strCOLOR = swapString(strCOLOR, "#FFFFFF", "#F5FAFA")
		
		if IsNumeric(VlrOrig) then
		 if getValue(objRS,"DT_COMPRA")<>"" then
		  if isdate(getValue(objRS,"DT_COMPRA")) then
			if ucase(getValue(objRS,"TIPO")) = "SOFTWARE" then TxDepAno = 1  '100/1
			if ucase(getValue(objRS,"TIPO")) = "VEÍCULO"  then TxDepAno = 20 '100/5
			if ucase(getValue(objRS,"TIPO")) = "MÓVEIS"   then TxDepAno = 10 '100/10
			if ucase(getValue(objRS,"TIPO")) = "HARDWARE" then TxDepAno = 10 '100/10
			if ucase(getValue(objRS,"TIPO")) = "IMÓVEL"   then TxDepAno = 4  '100/25
			if ucase(getValue(objRS,"TIPO")) = "OUTROS"   then TxDepAno = 0

			QtdeDias = date() - CDate(getValue(objRS,"DT_COMPRA"))
			TxDepDia = TxDepAno / 365
			VlrAtual = VlrOrig - ( (QtdeDias * TxDepDia) / 100) * VlrOrig
			VlrAtual = FormataDecimal(VlrAtual,2)
			TxDepDia = FormataDecimal(TxDepDia,8)
		  end if	
		 end if
		end if
		
		VlrOrig = FormataDecimal(VlrOrig,2)
	%>
  <tr bgcolor=<%=strCOLOR%>> 
	<td width="1%"><%=MontaLinkGrade("modulo_INVENTARIO","Delete.asp",GetValue(objRS,"COD_INVENTARIO"),"IconAction_DEL.gif","REMOVER")%></td>
	<td width="1%"><%=MontaLinkGrade("modulo_INVENTARIO","Update.asp",GetValue(objRS,"COD_INVENTARIO"),"IconAction_EDIT.gif","ALTERAR")%></td>
	<td width="1%"><%=MontaLinkGrade("modulo_INVENTARIO","Detail.asp",GetValue(objRS,"COD_INVENTARIO"),"IconAction_DETAIL.gif","VISUALIZAR")%></td>
	<td><%=getValue(objRS,"ID_ITEM")%></td>
    <td><%=getValue(objRS,"NOME_ITEM")%></td>
    <td><%=getValue(objRS,"MARCA")%></td>
    <td><%=getValue(objRS,"DESC_ITEM")%></td>
    <td><%=getValue(objRS,"DIVISAO")%></td>
    <td><%=getValue(objRS,"TIPO")%></td>
    <td><%=getValue(objRS,"PROPRIEDADE")%></td>
    <td align="right" nowrap><%=VlrOrig%></td>
    <td align="right" nowrap><%=TxDepDia%></td>
    <td align="right" nowrap><%=VlrAtual%></td>
    <td align="right" nowrap><% if strARQUIVOANEXO<>"" then %><a href="../athdownloader.asp?var_cliente=<%=Request.Cookies("VBOSS")("CLINAME")%>&var_tipo=INVENTARIO_Anexos&var_arquivo=<%=strARQUIVOANEXO%>" target="_blank" style="cursor:hand;"><img src="../img/ico_clip.gif" border="0" title="Anexo"></a></a><% end if%></td>

  </tr>
  <%
        athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
      Wend
  %>
  </tbody>  
</table>
</body>
</html>
<%
   FechaRecordSet ObjRS
 else
   Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
 end if
 FechaDBConn objConn
%>