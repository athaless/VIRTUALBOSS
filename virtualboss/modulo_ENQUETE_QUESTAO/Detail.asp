<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
	Dim strSQL, objRS, ObjConn
	Dim strCODIGO
	Dim strTEMPO_CASA, strTEMPO_ANOS, strTEMPO_MESES, strIDADE
	
	strCODIGO   = GetParam("var_chavereg")
	
	If strCODIGO <> "" Then
		AbreDBConn objConn, CFG_DB 

		strSQL =          "SELECT T1.COD_COLABORADOR, T1.NOME, T1.CPF, T1.RG, T1.FONE_1, T1.FONE_2, T1.CELULAR, T1.EMAIL, T1.EMAIL_EXTRA "
		strSQL = strSQL & "     , T1.ENDERECO, T1.NUMERO, T1.COMPLEMENTO, T1.CEP, T1.BAIRRO, T1.CIDADE, T1.ESTADO, T1.PAIS, T1.DT_CADASTRO, T1.DT_INATIVO "
		strSQL = strSQL & "     , T1.ORGAO_EXPEDITOR, T1.MSN_MESSENGER, T1.FOTO, T1.DT_NASC, T1.FILIAL_VINCULADA, T1.DT_CONTRATACAO "
		strSQL = strSQL & "     , T1.DT_DESLIGAMENTO, T1.SETOR, T1.REMUNERACAO_MENSAL, T1.REGIME, T1.DT_ASSIN_CARTEIRA, T1.UTILIZA_VT, T1.VLR_VT_UNIT "
		strSQL = strSQL & "     , T1.QTDE_VT_DIA, T1.UTILIZA_VRVA, T1.VLR_VRVA, T1.AUXILIO_ESTUDO, T1.COD_BANCO, T1.AGENCIA, T1.CONTA, T1.FORMA_PGTO, T1.FOTO "
		strSQL = strSQL & "     , T2.NOME AS BANCO, T1.FILIACAO_PAI, T1.FILIACAO_MAE "
		strSQL = strSQL & " FROM ENT_COLABORADOR T1 "
		strSQL = strSQL & " LEFT OUTER JOIN FIN_BANCO T2 ON (T1.COD_BANCO = T2.COD_BANCO) "
		strSQL = strSQL & " WHERE T1.COD_COLABORADOR = " & strCODIGO 
		
		Set objRS = objConn.Execute(strSQL)
		
		If Not objRS.Eof Then 
%>
<html>
<head>
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
      <th width="150"></th>
      <th colspan="2">Colaborador</th>
    </tr>
  </thead>
 <tbody style="text-align:left;">
  <tr><td align="right">Nome:&nbsp;</td>           <td><%=GetValue(objRS,"NOME")%></td>
  <% If GetValue(objRS,"FOTO") <> "" Then %>
	<td style="text-align:right"><div style='height:16px; position:relative; overflow:visible'><img src='../upload/<%=Request.Cookies("VBOSS")("CLINAME")%>/<%=GetValue(objRS,"FOTO")%>' height='140' /></div></td>
  <% Else %>
  	<td></td>
  <% End If %>
  </tr>
  <tr><td align="right">RG:&nbsp;</td>             <td colspan="2"><%=GetValue(objRS,"RG")%></td></tr>
  <tr><td align="right">CPF:&nbsp;</td>            <td colspan="2"><%=GetValue(objRS,"CPF")%></td></tr>
  <tr><td align="right">Fone 1:&nbsp;</td>         <td colspan="2"><%=GetValue(objRS,"FONE_1")%></td></tr>
  <tr><td align="right">Fone 2:&nbsp;</td>         <td colspan="2"><%=GetValue(objRS,"FONE_2")%></td></tr>
  <tr><td align="right">Celular:&nbsp;</td>        <td colspan="2"><%=GetValue(objRS,"CELULAR")%></td></tr>
  <tr><td align="right">Email:&nbsp;</td>          <td colspan="2"><%=GetValue(objRS,"EMAIL")%></td></tr>
  <tr><td align="right">Email Extra:&nbsp;</td>    <td colspan="2"><%=GetValue(objRS,"EMAIL_EXTRA")%></td></tr>
  <tr><td align="right">Data Nascimento:&nbsp;</td><td colspan="2"><%=PrepData(GetValue(objRS,"DT_NASC"), True, False)%></td></tr>
  <tr><td align="right">Idade:&nbsp;</td>          <td colspan="2">
  <%
  If IsDate(GetValue(objRS,"DT_NASC")) Then 
  	strIDADE = DateDiff("M", GetValue(objRS,"DT_NASC"), Date)
	If strIDADE > 0 Then strIDADE = Fix(strIDADE / 12)
	If strIDADE > 0 Then Response.Write(strIDADE & " anos")
  End If
  %>
  </td></tr>
  <tr><td align="right">Nome do Pai:&nbsp;</td>    <td colspan="2"><%=GetValue(objRS,"FILIACAO_PAI")%></td></tr>
  <tr><td align="right">Nome da Mãe:&nbsp;</td>    <td colspan="2"><%=GetValue(objRS,"FILIACAO_MAE")%></td></tr>
  <tr><td align="right">Status:&nbsp;</td>         <td colspan="2"><% if GetValue(objRS,"DT_INATIVO") = "" then Response.Write "Ativo" else Response.Write "Inativo" end if %></td></tr>
  <tr><td colspan="3" height="10"></td></tr>
  <tr><td align="right">Endereço:&nbsp;</td>    <td colspan="2"><%=GetValue(objRS,"ENDERECO")%></td></tr>
  <tr><td align="right">Num.:&nbsp;</td>        <td colspan="2"><%=GetValue(objRS,"NUMERO")%></td></tr>
  <tr><td align="right">Complemento:&nbsp;</td> <td colspan="2"><%=GetValue(objRS,"COMPLEMENTO")%></td></tr>
  <tr><td align="right">CEP:&nbsp;</td>         <td colspan="2"><%=GetValue(objRS,"CEP")%></td></tr>
  <tr><td align="right">Cidade:&nbsp;</td>      <td colspan="2"><%=GetValue(objRS,"CIDADE")%></td></tr>
  <tr><td align="right">Bairro:&nbsp;</td>      <td colspan="2"><%=GetValue(objRS,"BAIRRO")%></td></tr>
  <tr><td align="right">Estado:&nbsp;</td>      <td colspan="2"><%=GetValue(objRS,"ESTADO")%></td></tr>
  <tr><td align="right">País Extra:&nbsp;</td>  <td colspan="2"><%=GetValue(objRS,"PAIS")%></td></tr>
  <% If VerificaDireito("|DADOS_RH|", BuscaDireitosFromDB("modulo_COLABORADOR", Request.Cookies("VBOSS")("ID_USUARIO")), false) Then %>
	  <tr><td colspan="3" height="10"></td></tr>
	  <tr><td align="right">Filial Vinculada:&nbsp;</td>     <td colspan="2"><%=GetValue(objRS,"FILIAL_VINCULADA")%></td></tr>
	  <tr><td align="right">Data Contratação:&nbsp;</td>     <td colspan="2"><%=PrepData(GetValue(objRS,"DT_CONTRATACAO"),True,False)%></td></tr>
	  <tr><td align="right">Tempo de Casa:&nbsp;</td>        <td colspan="2">
	  <%
	  If IsDate(GetValue(objRS,"DT_CONTRATACAO")) Then 
	  	strTEMPO_ANOS = DateDiff("M", GetValue(objRS,"DT_CONTRATACAO"), Date)
		strTEMPO_MESES = DateDiff("M", GetValue(objRS,"DT_CONTRATACAO"), Date)
		
		If strTEMPO_ANOS > 0 Then strTEMPO_ANOS = Fix(strTEMPO_ANOS / 12)
		If strTEMPO_MESES > 0 Then strTEMPO_MESES = strTEMPO_MESES Mod 12
		
		strTEMPO_CASA = ""
		If strTEMPO_ANOS > 0 Then
			strTEMPO_CASA = strTEMPO_CASA & strTEMPO_ANOS
			If strTEMPO_ANOS = 1 Then 
				strTEMPO_CASA = strTEMPO_CASA & " ano "
			Else
				strTEMPO_CASA = strTEMPO_CASA & " anos "
			End If
		End If
		If strTEMPO_MESES > 0 Then
			strTEMPO_CASA = strTEMPO_CASA & strTEMPO_MESES
			If strTEMPO_MESES = 1 Then 
				strTEMPO_CASA = strTEMPO_CASA & " mês "
			Else
				strTEMPO_CASA = strTEMPO_CASA & " meses "
			End If
		End If
		If strTEMPO_CASA <> "" Then Response.Write("em torno de " & strTEMPO_CASA)
	  End If
	  %>
	  </td></tr>
	  <tr><td align="right">Data Assin. Carteira:&nbsp;</td> <td colspan="2"><%=PrepData(GetValue(objRS,"DT_ASSIN_CARTEIRA"),True,False)%></td></tr>
	  <tr><td align="right">Data Desligamento:&nbsp;</td>    <td colspan="2"><%=PrepData(GetValue(objRS,"DT_DESLIGAMENTO"),True,False)%></td></tr>
	  <tr><td align="right">Setor:&nbsp;</td>                <td colspan="2"><%=GetValue(objRS,"SETOR")%></td></tr>
	  <tr><td align="right">Remuneração Mensal:&nbsp;</td>   <td colspan="2"><%=FormataDecimal(GetValue(objRS,"REMUNERACAO_MENSAL"), 2)%></td></tr>
	  <tr><td align="right">Regime:&nbsp;</td>               <td colspan="2"><%=GetValue(objRS,"REGIME")%></td></tr>
	  <tr><td align="right">Auxílio Estudo:&nbsp;</td>       <td colspan="2"><%=GetValue(objRS,"AUXILIO_ESTUDO")%></td></tr>
	  <tr><td align="right">Forma de Pagamento:&nbsp;</td>   <td colspan="2"><%=GetValue(objRS,"FORMA_PGTO")%></td></tr>
	  <tr><td align="right">Vale Transporte:&nbsp;</td>      <td colspan="2"><% If GetValue(objRS,"UTILIZA_VT") = "VT" Then Response.Write("Sim") Else Response.Write("Não") End If %></td></tr>
	  <tr><td align="right">Valor Unitário:&nbsp;</td>       <td colspan="2"><%=FormataDecimal(GetValue(objRS,"VLR_VT_UNIT"), 2)%></td></tr>
	  <tr><td align="right">Qtde por Dia:&nbsp;</td>         <td colspan="2"><%=GetValue(objRS,"QTDE_VT_DIA")%></td></tr>
	  <tr><td align="right">Valor Total por Dia:&nbsp;</td>
	  <td colspan="2">
	  <%
	  If (GetValue(objRS,"UTILIZA_VT") = "VT") And (CDbl(0 & GetValue(objRS,"VLR_VT_UNIT")) > 0) And (CDbl(0 & GetValue(objRS,"QTDE_VT_DIA")) > 0) Then
	  	Response.Write(FormataDecimal(GetValue(objRS,"VLR_VT_UNIT") * GetValue(objRS,"QTDE_VT_DIA"), 2))
	  End If
	  %>
	  </td></tr>
	  <tr><td align="right">Vale Refeição/Alim.:&nbsp;</td>  
	  <td colspan="2">
	  <% 
		If GetValue(objRS,"UTILIZA_VRVA") = "VR" Then 
			Response.Write("Vale Refeição") 
		ElseIf GetValue(objRS,"UTILIZA_VRVA") = "VA" Then 	
			Response.Write("Vale Alimentação") 
		Else 
			Response.Write("Não") 
		End If
	  %>
	  </td></tr>
	  <tr><td align="right">Valor:&nbsp;</td>       <td colspan="2"><%=FormataDecimal(GetValue(objRS,"VLR_VRVA"), 2)%></td></tr>
	  <tr><td colspan="3" height="10"></td></tr>
	  <tr><td align="right">Banco:&nbsp;</td>       <td colspan="2"><%=GetValue(objRS,"BANCO")%></td></tr>
	  <tr><td align="right">Agênca:&nbsp;</td>      <td colspan="2"><%=GetValue(objRS,"AGENCIA")%></td></tr>
	  <tr><td align="right">Conta:&nbsp;</td>       <td colspan="2"><%=GetValue(objRS,"CONTA")%></td></tr>
  <% End If %>
 </tbody>
</table>
</body>
</html>
<%
		End If 
		FechaRecordSet objRS
		FechaDBConn objConn
	End If 
%>