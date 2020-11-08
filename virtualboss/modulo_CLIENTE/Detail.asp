<!--#include file="../_database/athdbConn.asp"--><!-- ATENÇÃO: language, option explicit, etc... estão no athDBConn -->
<!--#include file="../_database/athUtils.asp"-->
<%
	Dim strSQL, objRS, ObjConn
	Dim strCODIGO, auxSTRATIVO, auxSTRTIPODOC 
		
	strCODIGO   = GetParam("var_chavereg")
	
	If strCODIGO <> "" Then
		AbreDBConn objConn, CFG_DB 
	
		strSql =          "SELECT T1.RAZAO_SOCIAL, T1.NOME_FANTASIA, T1.NOME_COMERCIAL, T1.NUM_DOC, T1.TIPO_DOC, T1.INSC_ESTADUAL, T1.INSC_MUNICIPAL, T1.FONE_1, T1.FONE_2 "
		strSql = strSql & "      ,T1.FAX, T1.EMAIL, T1.SITE, T1.DT_INATIVO, T1.FATURA_ENDERECO, T1.FATURA_NUMERO, T1.FATURA_COMPLEMENTO, T1.SIGLA_PONTO "
		strSql = strSql & "      ,T1.FATURA_CEP, T1.FATURA_BAIRRO, T1.FATURA_CIDADE, T1.FATURA_ESTADO, T1.FATURA_PAIS, T1.CLASSE, T1.TIPO_CHAMADO "
		strSql = strSql & "      ,T1.COBR_ENDERECO, T1.COBR_NUMERO, T1.COBR_COMPLEMENTO "
		strSql = strSql & "      ,T1.COBR_CEP, T1.COBR_BAIRRO, T1.COBR_CIDADE, T1.COBR_ESTADO, T1.COBR_PAIS "
		strSql = strSql & "      ,T1.ENTR_ENDERECO, T1.ENTR_NUMERO, T1.ENTR_COMPLEMENTO "
		strSql = strSql & "      ,T1.ENTR_CEP, T1.ENTR_BAIRRO, T1.ENTR_CIDADE, T1.ENTR_ESTADO, T1.ENTR_PAIS "
		strSql = strSql & "  FROM ENT_CLIENTE T1"
		strSql = strSql & " WHERE T1.COD_CLIENTE = " & strCODIGO 
		
		Set objRS = objConn.Execute(strSQL)

		If Not objRS.Eof Then 
		  if GetValue(objRS,"DT_INATIVO") = "" then auxSTRATIVO = "Ativo" else auxSTRATIVO = "Inativo" end if
		  if GetValue(objRS,"TIPO_DOC") = "F" then auxSTRTIPODOC = "CPF" else auxSTRTIPODOC = "CNPJ" end if  
%>
<html>
<head>
	<script type="text/javascript" src="../_scripts/tablesort.js"></script>
	<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
</head>
<body>
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
      <th>Dados</th>
    </tr>
  </thead>
 <tbody style="text-align:left;">
<tr><td style="text-align:right;">Razão Social:&nbsp;</td>  			  <td><%=GetValue(objRS,"RAZAO_SOCIAL")%></td></tr>
  <tr><td style="text-align:right;">Nome Fantasia:&nbsp;</td>             <td><%=GetValue(objRS,"NOME_FANTASIA")%></td></tr> 
  <tr><td style="text-align:right;">Nome Comercial:&nbsp;</td>            <td><%=GetValue(objRS,"NOME_COMERCIAL")%></td></tr>
  <tr><td style="text-align:right;">Sigla Ponto:&nbsp;</td>               <td><%=GetValue(objRS,"SIGLA_PONTO")%></td></tr>
  <tr><td style="text-align:right;"><%=auxSTRTIPODOC%>:&nbsp;</td>        <td><%=GetValue(objRS,"NUM_DOC")%></td></tr>
  <tr><td style="text-align:right;">Inscrição Estadual:&nbsp;</td>        <td><%=GetValue(objRS,"INSC_ESTADUAL")%></td></tr>
  <tr><td style="text-align:right;">Inscrição Municipal:&nbsp;</td>       <td><%=GetValue(objRS,"INSC_MUNICIPAL")%></td></tr>
  <tr><td style="text-align:right;">Fone 1:&nbsp;</td>                    <td><%=GetValue(objRS,"FONE_1")%></td></tr>
  <tr><td style="text-align:right;">Fone 2:&nbsp;</td>                    <td><%=GetValue(objRS,"FONE_2")%></td></tr>
  <tr><td style="text-align:right;">Fax:&nbsp;</td>                       <td><%=GetValue(objRS,"FAX")%></td></tr>
  <tr><td style="text-align:right;">E-mail:&nbsp;</td>                    <td><%=GetValue(objRS,"EMAIL")%></td></tr>
  <tr><td style="text-align:right;">Site:&nbsp;</td>                      <td><%=GetValue(objRS,"SITE")%></td></tr>
  <tr><td style="text-align:right;">Classe:&nbsp;</td>                    <td><%=GetValue(objRS,"CLASSE")%></td></tr> 
  <tr><td style="text-align:right;">Tipo do Chamado:&nbsp;</td>           <td><%=GetValue(objRS,"TIPO_CHAMADO")%></td></tr> 
  <tr><td style="text-align:right;">Status:&nbsp;</td>                    <td><%=auxSTRATIVO%></td></tr>
  <tr><td colspan="2" height="10"></td></tr>
  <tr><td style="text-align:right;"><b>Endereço de Fatura</b></td><td></td></tr>
  <tr><td style="text-align:right;">Endereço:&nbsp;</td>                   <td><%=GetValue(objRS,"FATURA_ENDERECO")%></td></tr>
  <tr><td style="text-align:right;">Numero / Complemento:&nbsp;</td>      <td><%=GetValue(objRS,"FATURA_NUMERO") & " / " & GetValue(objRS,"FATURA_COMPLEMENTO")%></td></tr>
  <tr><td style="text-align:right;">CEP:&nbsp;</td>                       <td><%=GetValue(objRS,"FATURA_CEP")%></td></tr>
  <tr><td style="text-align:right;">Bairro:&nbsp;</td>                    <td><%=GetValue(objRS,"FATURA_BAIRRO")%></td></tr>
  <tr><td style="text-align:right;">Cidade:&nbsp;</td>                    <td><%=GetValue(objRS,"FATURA_CIDADE")%></td></tr>
  <tr><td style="text-align:right;">Estado:&nbsp;</td>                    <td><%=GetValue(objRS,"FATURA_ESTADO")%></td></tr>
  <tr><td style="text-align:right;">Pais:&nbsp;</td>                      <td><%=GetValue(objRS,"FATURA_PAIS")%></td></tr>
  <tr><td colspan="2" height="10"></td></tr>
  <tr><td style="text-align:right;"><b>Endereço de Cobrança</b></td><td></td></tr>
  <tr><td style="text-align:right;">Endereço:&nbsp;</td>                  <td><%=GetValue(objRS,"COBR_ENDERECO")%></td></tr>
  <tr><td style="text-align:right;">Numero / Complemento:&nbsp;</td>      <td><%=GetValue(objRS,"COBR_NUMERO") & " / " & GetValue(objRS,"COBR_COMPLEMENTO")%></td></tr>
  <tr><td style="text-align:right;">CEP:&nbsp;</td>                       <td><%=GetValue(objRS,"COBR_CEP")%></td></tr>
  <tr><td style="text-align:right;">Bairro:&nbsp;</td>                    <td><%=GetValue(objRS,"COBR_BAIRRO")%></td></tr>
  <tr><td style="text-align:right;">Cidade:&nbsp;</td>                    <td><%=GetValue(objRS,"COBR_CIDADE")%></td></tr>
  <tr><td style="text-align:right;">Estado:&nbsp;</td>                    <td><%=GetValue(objRS,"COBR_ESTADO")%></td></tr>
  <tr><td style="text-align:right;">Pais:&nbsp;</td>                      <td><%=GetValue(objRS,"COBR_PAIS")%></td></tr>
  <tr><td colspan="2" height="10"></td></tr>
  <tr><td style="text-align:right;"><b>Endereço de Entrega</b></td><td></td></tr>
  <tr><td style="text-align:right;">Endereço:&nbsp;</td>                  <td><%=GetValue(objRS,"ENTR_ENDERECO")%></td></tr>
  <tr><td style="text-align:right;">Numero / Complemento:&nbsp;</td>      <td><%=GetValue(objRS,"ENTR_NUMERO") & " / " & GetValue(objRS,"ENTR_COMPLEMENTO")%></td></tr>
  <tr><td style="text-align:right;">CEP:&nbsp;</td>                       <td><%=GetValue(objRS,"ENTR_CEP")%></td></tr>
  <tr><td style="text-align:right;">Bairro:&nbsp;</td>                    <td><%=GetValue(objRS,"ENTR_BAIRRO")%></td></tr>
  <tr><td style="text-align:right;">Cidade:&nbsp;</td>                    <td><%=GetValue(objRS,"ENTR_CIDADE")%></td></tr>
  <tr><td style="text-align:right;">Estado:&nbsp;</td>                    <td><%=GetValue(objRS,"ENTR_ESTADO")%></td></tr>
  <tr id="tableheader_last_row"><td style="text-align:right;">Pais:&nbsp;</td><td><%=GetValue(objRS,"ENTR_PAIS")%></td></tr>
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