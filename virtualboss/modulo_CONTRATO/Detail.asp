<!--#include file="../_database/athdbConn.asp"--><% ' ATENÇÃO: language, option explicit, etc... estão no athDBConn 
                                                  %>
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_CONTRATO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 	Const WMD_WIDTH = 150 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 

	Dim objConn, objRS, objRSAux, strSQL
	Dim strCODIGO, Idx, strCOD_CONTRATO_PAI, strCOLOR, num_PARCELA, strAuxCAMPO, strAux, booTemAcessoViewTit
	Dim strAuxArquivo
	
	AbreDBConn objConn, CFG_DB 
	
	strCODIGO = GetParam("var_chavereg")
	
	If strCODIGO <> "" Then
		strSQL = " SELECT * FROM CONTRATO WHERE COD_CONTRATO = " & strCODIGO
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		
		If Not objRS.Eof Then
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/tablesort.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">

//****** Funções de ação dos botões - Início ******
function ok() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
//****** Funções de ação dos botões - Fim ******

</script>
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
      <th width="25%"></th>
      <th width="75%">Dados</th>
    </tr>
  </thead>
  <tbody style="text-align:left;">
        <% for Idx = 0 to objRS.fields.count - 1 'NÃO TRAZER TODOS OS DADOS %> 
        <tr> 
          <td width="<%=WMD_WIDTH%>" style="text-align:right"><%=objRS.Fields(Idx).name%>:&nbsp;</td>
          <%
		  if(UCase(objRS.Fields(Idx).name) = "DOC_CONTRATO") Then 
            'Utilizamos a athDownloader.asp pois ela obriga que seja feito o download do arquivo.. não abre no browser
			strAuxCAMPO = "../athDownloader.asp?var_cliente=" & Request.Cookies("VBOSS")("CLINAME")
			strAuxCAMPO = strAuxCAMPO & "&var_tipo=CONTRATOS&var_arquivo=" & Replace(Replace(GetValue(objRS, objRS.Fields(Idx).name),"<ASLW_APOSTROFE>","'"),CHR(13),"<br>") 
            strAuxCAMPO = "<a target='blank' href='" & strAuxCAMPO & "'>" & GetValue(objRS, objRS.Fields(Idx).name) & "</a>"
	      %>
		    <td><%=strAuxCAMPO%></td>
		  <% else %>
            <td><%=Replace(Replace(GetValue(objRS, objRS.Fields(Idx).name),"<ASLW_APOSTROFE>","'"),CHR(13),"<br>")%>&nbsp;</td>		  
	      <% end if %>
        </tr>
        <% next %>
		<tr>
		  <td width="<%=WMD_WIDTH%>" style="text-align:right">Anexos:&nbsp;</td>
          <%
			strSQL =          " SELECT COD_ANEXO, ARQUIVO "
			strSQL = strSQL & " FROM CONTRATO_ANEXO WHERE COD_CONTRATO = " & strCODIGO
			
			AbreRecordSet objRSAux, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
			strAuxArquivo = ""
			strAuxCAMPO = ""
   		    While not objRSAux.Eof
			  strAuxArquivo = GetValue(objRSAux, "ARQUIVO")
			  if strAuxArquivo <> "" then
				  if strAuxCAMPO <> "" then
					strAuxCAMPO = strAuxCAMPO & "<br>"
				  end if
				  'monta o link para o anexo 
				  strAuxCAMPO = strAuxCAMPO & "<a target='blank' href='../athDownloader.asp?var_cliente=" & Request.Cookies("VBOSS")("CLINAME") &_
											  "&var_tipo=CONTRATOS_Anexos&var_arquivo=" & Replace(Replace(GetValue(objRSAux, "ARQUIVO"),"<ASLW_APOSTROFE>","'"),CHR(13),"<br>") &_
											  "'>" & GetValue(objRSAux, "ARQUIVO") & "</a>"
				  'strAuxCAMPO = "<a href='" & strAuxCAMPO & "'>" & GetValue(objRSAux, "ARQUIVO") & "</a>"
			  end if
  			  athMoveNext objRSAux, ContFlush, CFG_FLUSH_LIMIT
			wend 
  		    FechaRecordSet objRSAux			
		  %>		  
		  <td><%=strAuxCAMPO%></td>
		</tr>
  </tbody>
</table>

<%			
'******-------------------------------------------------******
'******-----------------INICIO SERVIÇOS-----------------******
'******-------------------------------------------------******
strSQL =          " SELECT  COD_SERVICO, DESCRICAO, QTDE, VALOR "
strSQL = strSQL & " FROM CONTRATO_SERVICO T1 "
strSQL = strSQL & " WHERE T1.COD_CONTRATO = " & strCODIGO
		
Set objRSAux = objConn.Execute(strSQL)
	
If Not objRSAux.Eof Then
%>
<div style="text-align:center;line-height:30px;">Serviços cadastrados para o Contrato</div>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <!-- Possibilidades de tipo de sort...
  class="sortable-date-dmy"
  class="sortable-currency"
  class="sortable-numeric"
  class="sortable"
 -->
 <thead>
	<tr>
		<th width="10%" class="sortable-numeric">Cod. Serviço</th>
  		<th width="70%" class="sortable">Descrição</th>
		<th width="10%" class="sortable-numeric" nowrap>Qtde.</th>
		<th width="10%" class="sortable-numeric" nowrap>Valor</th>        
	</tr>
 </thead>
 <tbody style="text-align:left;">
<%
					Do While Not objRSAux.Eof
						strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
	%>			
	<tr bgcolor="<%=strCOLOR%>">
		<td><%=GetValue(objRSAux, "COD_SERVICO")%></td>
   		<td><%=GetValue(objRSAux, "DESCRICAO")%></td>
   		<td><%=GetValue(objRSAux, "QTDE")%></td>
		<td style="text-align:right"><%=FormatNumber(GetValue(objRSAux, "VALOR"), 2)%></td>
	</tr>
	<%
						objRSAux.MoveNext
					Loop
'fim					
%>
 </tbody>
</table>
<%
				End If 'If Not objRSAux.Eof Then
				FechaRecordSet objRSAux

'******-------------------------------------------------******
'******--------------------FIM SERVIÇOS-----------------******
'******-------------------------------------------------******

'******-------------------------------------------------******
'******--------------------INI CONTRATO PAI-------------******
'******-------------------------------------------------******
			If GetValue(objRS, "COD_CONTRATO_PAI") <> "" Then
				strCOD_CONTRATO_PAI = GetValue(objRS, "COD_CONTRATO_PAI")
%>
<div style="text-align:center;line-height:30px;">Contratos anteriores</div>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <!-- Possibilidades de tipo de sort...
  class="sortable-date-dmy"
  class="sortable-currency"
  class="sortable-numeric"
  class="sortable"
 -->
 <thead>
	<tr>
		<th width="1%" nowrap></th>
		<th width="1%" class="sortable-numeric" nowrap>Cod</th>
		<th width="1%" class="sortable-numeric" nowrap>Cod Pai</th>
		<th width="25%" class="sortable" nowrap>Codificação</th>
		<th width="32%" class="sortable" nowrap>Título</th>
		<th width="10%" class="sortable-date-dmy" nowrap>Dt Ini</th>
		<th width="10%" class="sortable-date-dmy" nowrap>Dt Fim</th>
		<th width="10%" class="sortable-numeric" nowrap>Parcelas</th>
		<th width="10%" class="sortable-currency" nowrap>Vlr Total</th>
	</tr>
 </thead>
 <tbody style="text-align:left;">
<%
				Do While strCOD_CONTRATO_PAI <> ""
					strSQL =          " SELECT COD_CONTRATO, COD_CONTRATO_PAI, TITULO, CODIFICACAO "
					strSQL = strSQL & "      , DT_INI, DT_FIM, NUM_PARC, VLR_TOTAL "
					strSQL = strSQL & " FROM CONTRATO WHERE COD_CONTRATO = " & strCOD_CONTRATO_PAI
					
					AbreRecordSet objRSAux, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
					
					if not objRSAux.Eof then
						strCOD_CONTRATO_PAI = GetValue(objRSAux, "COD_CONTRATO_PAI")
						strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
	%>			
	<tr bgcolor="<%=strCOLOR%>">
		<td style="text-align:right"><%=MontaLinkGrade("modulo_CONTRATO","Detail.asp",GetValue(objRSAux,"COD_CONTRATO"),"IconAction_DETAIL.gif","VISUALIZAR")%></td>
		<td style="text-align:right"><%=GetValue(objRSAux, "COD_CONTRATO")%></td>
		<td style="text-align:right"><%=GetValue(objRSAux, "COD_CONTRATO_PAI")%></td>
		<td><%=GetValue(objRSAux, "CODIFICACAO")%></td>
		<td><%=GetValue(objRSAux, "TITULO")%></td>
		<td><%=PrepData(GetValue(objRSAux, "DT_INI"), True, False)%></td>
		<td><%=PrepData(GetValue(objRSAux, "DT_FIM"), True, False)%></td>
		<td style="text-align:right"><%=GetValue(objRSAux, "NUM_PARC")%></td>
		<td style="text-align:right"><%=FormatNumber(GetValue(objRSAux, "VLR_TOTAL"), 2)%></td>
	</tr>
	<%
					End If
					FechaRecordSet objRSAux
				Loop
%>
 </tbody>
</table>
<%
			End If 'If GetValue(objRS, "COD_CONTRATO_PAI") <> "" Then
'******-------------------------------------------------******
'******--------------------FIM CONTRATO PAI-------------******
'******-------------------------------------------------******	
%>
<%			
'******-------------------------------------------------******
'******------------INI PARCELAS DO CONTRATO-------------******
'******-------------------------------------------------******
			'Else			
			    num_PARCELA = 0
				strSQL =          " SELECT  VLR_PARCELA, DT_VENC"
				strSQL = strSQL & " FROM CONTRATO_PARCELA T1 "
				strSQL = strSQL & " WHERE T1.COD_CONTRATO = " & strCODIGO
				strSQL = strSQL & " ORDER BY T1.DT_VENC "
				
				Set objRSAux = objConn.Execute(strSQL)
				
				If Not objRSAux.Eof Then
%>
<div style="text-align:center;line-height:30px;">Parcelas cadastradas para o Contrato</div>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <!-- Possibilidades de tipo de sort...
  class="sortable-date-dmy"
  class="sortable-currency"
  class="sortable-numeric"
  class="sortable"
 -->
 <thead>
	<tr>
		<th width="1%" nowrap></th>	
		<th width="10%" class="sortable">Num Parcela</th>
		<th width="40%" class="sortable-date-dmy" nowrap>Dt Vcto</th>
		<th width="49%" class="sortable-numeric" nowrap>Vlr Parcela</th>
	</tr>
 </thead>
 <tbody style="text-align:left;">
<%
					Do While Not objRSAux.Eof
						strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
						num_PARCELA = num_PARCELA + 1
	%>			
	<tr bgcolor="<%=strCOLOR%>">
        <td style="text-align:right"></td>
		<td><%=num_PARCELA%></td>
		<td><%=PrepData(GetValue(objRSAux, "DT_VENC"), True, False)%></td>
		<td style="text-align:right"><%=FormatNumber(GetValue(objRSAux, "VLR_PARCELA"), 2)%></td>
	</tr>
	<%
						objRSAux.MoveNext
					Loop
'fim					
%>
 </tbody>
</table>
<%
				End If 'If Not objRSAux.Eof Then
				FechaRecordSet objRSAux
'******-------------------------------------------------******
'******------------FIM PARCELAS DO CONTRATO-------------******
'******-------------------------------------------------******


'******-------------------------------------------------******
'******-------------INI TITULOS DO CONTRATO-------------******
'******-------------------------------------------------******
			'Se o contrato está faturado mostra as parcelas faturadas, senão mostra as parcelas cadastradas na CONTRATO_PARCELA
			if (GetValue(objRS, "SITUACAO") <> "ABERTO") Then			
				strSQL =          " SELECT T1.COD_CONTA_PAGAR_RECEBER, T1.SITUACAO, T1.NUM_DOCUMENTO, T1.VLR_CONTA, T1.DT_VCTO, T1.PAGAR_RECEBER "
				strSQL = strSQL & "      , T2.NOME AS PLANO_CONTA, T2.COD_REDUZIDO AS PLANO_CONTA_COD_REDUZIDO "
				strSQL = strSQL & "      , T3.NOME AS CENTRO_CUSTO, T3.COD_REDUZIDO AS CENTRO_CUSTO_COD_REDUZIDO "
				strSQL = strSQL & " FROM FIN_CONTA_PAGAR_RECEBER T1 "
				strSQL = strSQL & " LEFT OUTER JOIN FIN_PLANO_CONTA AS T2 ON (T1.COD_PLANO_CONTA = T2.COD_PLANO_CONTA) "
				strSQL = strSQL & " LEFT OUTER JOIN FIN_CENTRO_CUSTO AS T3 ON (T1.COD_CENTRO_CUSTO = T3.COD_CENTRO_CUSTO) "
				strSQL = strSQL & " WHERE T1.COD_CONTRATO = " & strCODIGO
				strSQL = strSQL & " ORDER BY T1.DT_VCTO "
				
				Set objRSAux = objConn.Execute(strSQL)
				
				If Not objRSAux.Eof Then
%>
<div style="text-align:center;line-height:30px;">Títulos gerados para o Contrato</div>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <!-- Possibilidades de tipo de sort...
  class="sortable-date-dmy"
  class="sortable-currency"
  class="sortable-numeric"
  class="sortable"
 -->
 <thead>
	<tr>
		<th width="1%" nowrap></th>
		<th width="15%" class="sortable">Num Doc</th>
		<th width="30%" class="sortable">Plano de Conta</th>
		<th width="30%" class="sortable">Centro de Custo</th>
		<th width="10%" class="sortable-date-dmy" nowrap>Dt Vcto</th>
		<th width="05%" class="sortable-numeric" nowrap>Vlr Conta</th>
		<th width="10%" class="sortable" nowrap>Situação</th>
	</tr>
 </thead>
 <tbody style="text-align:left;">
<%
					booTemAcessoViewTit = VerificaDireito("|VIEW|", BuscaDireitosFromDB("modulo_FIN_TITULOS", Request.Cookies("VBOSS")("ID_USUARIO")), false)
					Do While Not objRSAux.Eof
						strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
	%>			
	<tr bgcolor="<%=strCOLOR%>">
		<td style="text-align:right"><% if booTemAcessoViewTit then Response.write(MontaLinkGrade("modulo_FIN_TITULOS","Detail.asp",GetValue(objRSAux,"COD_CONTA_PAGAR_RECEBER"),"IconAction_DETAILADD.gif","DETALHE COM INSERÇÃO DE LCTO")) end if%></td>
		<td><%=GetValue(objRSAux, "NUM_DOCUMENTO")%></td>
		<td><%=GetValue(objRSAux, "PLANO_CONTA")%></td>
		<td><%=GetValue(objRSAux, "CENTRO_CUSTO")%></td>
		<td><%=PrepData(GetValue(objRSAux, "DT_VCTO"), True, False)%></td>
		<td style="text-align:right"><%=FormatNumber(GetValue(objRSAux, "VLR_CONTA"), 2)%></td>
		<td><%=GetValue(objRSAux, "SITUACAO")%></td>
	</tr>
	<%
						objRSAux.MoveNext
					Loop
%>
 </tbody>
</table>
<%
				End If 'If Not objRSAux.Eof Then
				FechaRecordSet objRSAux
'******-------------------------------------------------******
'******-------------FIM TITULOS DO CONTRATO-------------******
'******-------------------------------------------------******						
			End If
%>
</body>
</html>
<%
			End If'If Not objRS.Eof Then
			FechaDBConn objConn
	End If 'If strCODIGO <> "" Then
%>
