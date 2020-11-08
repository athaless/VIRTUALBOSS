<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
 Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FIN_TITULOS_ENT", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
 <!--#include file="../_database/athUtils.asp"--> 
<%
 Dim objConn, objRS, strSQL, objRSa
 Dim strCOOKIE_ID_USUARIO, strGRUPO_USUARIO
 Dim strENTIDADE, strSALDO
 Dim strDT_INI, strDT_FIM, strPERIODO
 Dim strCONTA_PREVISTA, strCONTA_REALIZADA, strSITUACAO, strTIPO, strHISTORICO
 Dim strICON, strTITLE, strCODTIT
 Dim strCODIGO_ENT, strTIPO_ENT, strNUM_LCTOS, strCOD_CONTAS_LCTOS, strCONTAS_LCTOS, strCODCCUSTO
 Dim Selecionado
 Dim strCOLOR
 Dim strFilePath, strFileName
 Dim boolTIT, boolLCTO
 
 'Inicialização
 boolTIT  = True
 boolLCTO = True
 
 AbreDBConn objConn, CFG_DB 
 
 strCONTA_PREVISTA	  = GetParam("var_fin_conta_prevista")
 strCONTA_REALIZADA	  = GetParam("var_fin_conta_realizada")
 strTIPO			  = GetParam("var_pr")	
 strSITUACAO		  = GetParam("var_situacao")
 strCODIGO_ENT		  = GetParam("var_codigo")
 strTIPO_ENT		  = GetParam("var_tipo")
 strDT_INI			  = GetParam("var_dt_ini") 
 strDT_FIM			  = GetParam("var_dt_fim") 
 strCODTIT			  = GetParam("var_cod_tit") 
 strCODCCUSTO	      = GetParam("var_centro_custo") 
 strHISTORICO         = GetParam("var_historico")
 
 if not IsDate(strDT_INI) then strDT_INI = ""
 if not IsDate(strDT_FIM) then strDT_FIM = ""
  
 if (strCODIGO_ENT <> "") and (strTIPO_ENT <> "") Then
	strSQL = 	"SELECT T1.COD_CONTA_PAGAR_RECEBER " 								&_
				"	,	T1.TIPO " 													&_
				"	,	T1.CODIGO " 												&_
				"	,	T1.DT_EMISSAO " 											&_
				"	,	T1.HISTORICO " 												&_
				"	,	T1.TIPO_DOCUMENTO " 										&_
				"	,	T1.NUM_DOCUMENTO " 											&_
				"	,	T1.PAGAR_RECEBER " 											&_
				"	,	T1.NUM_IMPRESSOES "											&_
				"	,	T1.DT_VCTO " 												&_
				"	,	T1.VLR_CONTA " 												&_
				"	,	T2.NOME AS CONTA " 											&_
				"	,	T1.SITUACAO " 												&_
				"	,	T1.COD_NF "													&_
				"	,	T3.NOME AS PLANO_CONTA " 									&_
				"	,	T3.COD_PLANO_CONTA " 										&_
				"	,	T3.COD_REDUZIDO AS PLANO_CONTA_COD_REDUZIDO " 				&_
				"	,	T4.NOME AS CENTRO_CUSTO " 									&_
				"	,	T4.COD_REDUZIDO AS CENTRO_CUSTO_COD_REDUZIDO " 				&_
				"	,	T1.ARQUIVO_ANEXO " 											&_
				"	,	T1.MARCA_NFE " 												&_
				"FROM FIN_CONTA_PAGAR_RECEBER AS T1 " 								&_
				"LEFT OUTER JOIN FIN_CONTA AS T2 ON (T1.COD_CONTA=T2.COD_CONTA) "	&_
				"LEFT OUTER JOIN FIN_PLANO_CONTA AS T3 ON (T1.COD_PLANO_CONTA=T3.COD_PLANO_CONTA) "		&_
				"LEFT OUTER JOIN FIN_CENTRO_CUSTO AS T4 ON (T1.COD_CENTRO_CUSTO=T4.COD_CENTRO_CUSTO) " 	&_
				"WHERE T2.DT_INATIVO IS NULL "
	'strSQL = strSQL &	" AND 0=1 "

	If (strSITUACAO <> "") then 
		if mid(strSITUACAO,1,1)="_" then 
			strSQL = strSQL &	" AND T1.SITUACAO NOT LIKE '"& mid(strSITUACAO,2) &"' AND T1.SITUACAO NOT LIKE 'CANCELADA'"
		else
			strSQL = strSQL &	" AND T1.SITUACAO LIKE '"& strSITUACAO &"'"
		end if
	End If	
	
	'if strTIPO="PAGAR"   then  strSQL = strSQL & " AND T1.PAGAR_RECEBER <> 0 "
	'if strTIPO="RECEBER" then  strSQL = strSQL & " AND T1.PAGAR_RECEBER = 0 "
	
	if strCODIGO_ENT<>"" and strTIPO_ENT<>"" then strSQL = strSQL & " AND (T1.TIPO LIKE '"& strTIPO_ENT &"' AND T1.CODIGO LIKE '"& strCODIGO_ENT &"')"
	
	If(strHISTORICO <> "") Then
		strSQL = strSQL & " AND UPPER(T1.HISTORICO) LIKE '" & UCase(strHISTORICO) &"%'"	
	End If
	
	strSQL = strSQL & " ORDER BY T1.DT_VCTO, T1.COD_CONTA_PAGAR_RECEBER "
	
	'athDebug strSQL, true
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
%>
<html>
<head>
	<script type="text/javascript" src="../_scripts/tablesort.js"></script>
	<!--link rel="stylesheet" type="text/css" href="../_css/virtualboss.css"-->
	<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
</head>
<body>
<%
	If not objRS.Eof Then 
		boolTIT = false
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
    <th width="01%"></th>
    <th width="01%"></th>
    <th width="01%"></th>
    <th width="01%"></th>	
    <th width="01%"></th>
    <th width="01%"></th>			
    <th width="2%"  class="sortable">Cód.</th>
    <th width="25%" class="sortable">Entidade</th>
    <th width="10%" class="sortable" nowrap>C.Prev</th>
    <th width="10%" class="sortable" nowrap>C.Lcto</th>
    <th width="13%" class="sortable" nowrap>Plano de Conta</th>
	<th width="13%" class="sortable" nowrap>Centro de Custo</th>
    <th width="8%"  class="sortable" nowrap>Num.DOC</th>
    <th width="01%" class="sortable-date-dmy" nowrap>Dt Emissão</th>
    <th width="01%" class="sortable-date-dmy" nowrap>Dt Vcto</th>
    <th width="05%" class="sortable-numeric" nowrap>Vlr Conta</th>
    <th width="01%"></th>
    <th width="01%"></th>
	<th width="01%"></th>
 </tr>
 </thead>
 <tbody style="text-align:left;">
<%
	End If	
	While Not objRs.Eof
		strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
		
		Selecionado = True
		
		strSQL =          "SELECT DISTINCT T2.COD_CONTA, T2.NOME "
		strSQL = strSQL & "  FROM FIN_LCTO_ORDINARIO T1, FIN_CONTA T2 "
		strSQL = strSQL & " WHERE T1.COD_CONTA = T2.COD_CONTA "
		strSQL = strSQL & "   AND T1.SYS_DT_CANCEL IS NULL "
		strSQL = strSQL & "   AND T1.COD_CONTA_PAGAR_RECEBER = " & GetValue(objRS,"COD_CONTA_PAGAR_RECEBER")
		strSQL = strSQL & " ORDER BY T2.NOME "
		
		AbreRecordSet objRSa, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		
		strCONTAS_LCTOS = ""
		strCOD_CONTAS_LCTOS = ""
		Do While Not objRSa.Eof
			strCONTAS_LCTOS = strCONTAS_LCTOS & ", " & GetValue(objRSa,"NOME")
			strCOD_CONTAS_LCTOS = strCOD_CONTAS_LCTOS & "," & GetValue(objRSa,"COD_CONTA")
			athMoveNext objRSa, ContFlush, CFG_FLUSH_LIMIT
		Loop
		strCONTAS_LCTOS = Mid(strCONTAS_LCTOS, 3)
		strCOD_CONTAS_LCTOS = strCOD_CONTAS_LCTOS & ","
		FechaRecordSet objRSa
		
		If strCONTA_REALIZADA <> "" Then
			Selecionado = False
			If InStr(strCOD_CONTAS_LCTOS, "," & CStr(strCONTA_REALIZADA) & ",") > 0 Then Selecionado = True
		End If
		
		If Selecionado = True Then
			if GetValue(objRS,"VLR_CONTA")<>"" then strSALDO = FormataDecimal(GetValue(objRS, "VLR_CONTA"),2) else strSALDO = "0,00"
			
			strSQL=""					 
			if GetValue(objRS,"TIPO")="ENT_CLIENTE"	    and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME_COMERCIAL AS NOME FROM ENT_CLIENTE		WHERE COD_CLIENTE     ="& GetValue(objRS,"CODIGO")
			if GetValue(objRS,"TIPO")="ENT_FORNECEDOR"  and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME_COMERCIAL AS NOME FROM ENT_FORNECEDOR	WHERE COD_FORNECEDOR  ="& GetValue(objRS,"CODIGO")
			if GetValue(objRS,"TIPO")="ENT_COLABORADOR" and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME                   FROM ENT_COLABORADOR WHERE COD_COLABORADOR ="& GetValue(objRS,"CODIGO")
			
			strENTIDADE=""
			if strSQL <> "" then 
				AbreRecordSet objRSa, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1			
				if not objRSa.eof then strENTIDADE = GetValue(objRSa, "NOME")
				FechaRecordSet objRSa
			end if 			
			
			strSQL = " SELECT COUNT(COD_CONTA_PAGAR_RECEBER) AS LCTOS FROM FIN_LCTO_ORDINARIO WHERE COD_CONTA_PAGAR_RECEBER=" & GetValue(objRS,"COD_CONTA_PAGAR_RECEBER")
			AbreRecordSet objRSa, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
			strNUM_LCTOS = 0
			If Not objRSa.Eof Then strNUM_LCTOS = GetValue(objRSa,"LCTOS")
			FechaRecordSet objRSa
%>
	<tr bgcolor="<%=strCOLOR%>">
		<td>
<% 
			If Cint("0" & strNUM_LCTOS)<1 then 
				Response.Write(MontaLinkGrade("modulo_FIN_TITULOS","Delete.asp",GetValue(objRS,"COD_CONTA_PAGAR_RECEBER"),"IconAction_DEL.gif","REMOVER"))
			End If 
%>
		</td>
		<td><%=MontaLinkGrade("modulo_FIN_TITULOS","Update.asp",GetValue(objRS,"COD_CONTA_PAGAR_RECEBER"),"IconAction_EDIT.gif","ALTERAR")%></td>
		<td><%=MontaLinkGrade("modulo_FIN_TITULOS","Detail.asp",GetValue(objRS,"COD_CONTA_PAGAR_RECEBER"),"IconAction_DETAILADD.gif","DETALHE COM INSERÇÃO DE LCTO")%></td>		
		
		<td align="center" title="GERAR BOLETO">
<% 
			If GetValue(objRS,"PAGAR_RECEBER") = "0" then 
				response.write(MontaLinkGrade("modulo_FIN_BOLETO","ShowBoleto.asp",GetValue(objRS,"COD_CONTA_PAGAR_RECEBER"),"IconAction_BOLETO.gif","GERAR BOLETO"))
			End if 
%>
		</td>	
		
		<td align="center" title="GERAR NOTA FISCAL">
<% 
			 if (GetValue(objRS,"PAGAR_RECEBER") = "0") and (GetValue(objRS,"TIPO")= "ENT_CLIENTE") and (GetValue(objRS,"SITUACAO") <> "CANCELADA") and (GetValue(objRS,"COD_NF") = "") then 				   
				response.write(MontaLinkGrade("modulo_FIN_FLUXOCAIXA","InsertNFdeTitulo.asp",GetValue(objRS,"COD_CONTA_PAGAR_RECEBER"),"IconAction_GERARNF.gif","GERAR NOTA FISCAL"))
			end if 
%>
		</td> 				
		
		<td title="VISUALIZAR RECIBO">
<%
			If GetValue(objRS,"MARCA_NFE") = "COM_NFE" Then 
				Response.Write(MontaLinkPopup("modulo_FIN_TITULOS","ViewRecibo.asp",GetValue(objRS,"COD_CONTA_PAGAR_RECEBER"),"IconAction_PREVIEW.gif","VISUALIZAR RECIBO","830","500","yes"))
			End If
%>
		</td>		
		<td><%=GetValue(objRS,"COD_CONTA_PAGAR_RECEBER")%></td>
		<td><%=strENTIDADE%></td>
		<td nowrap><%=GetValue(objRS,"CONTA")%></td>
		<td nowrap><%=strCONTAS_LCTOS%></td>
		<td nowrap><%=GetValue(objRS,"PLANO_CONTA_COD_REDUZIDO")%>&nbsp;<%=GetValue(objRS,"PLANO_CONTA")%></td>
		<td nowrap><%=GetValue(objRS,"CENTRO_CUSTO_COD_REDUZIDO")%>&nbsp;<%=GetValue(objRS,"CENTRO_CUSTO")%></td>		
		<td nowrap><%=GetValue(objRS,"NUM_DOCUMENTO")%></td>
		<td align="right"><%=PrepData(GetValue(objRS,"DT_EMISSAO"),true,false)%></td>
		<td align="right"><%=PrepData(GetValue(objRS,"DT_VCTO"),true,false)%></td>
		<td align="right"><%=strSALDO%></td>
<%
			If CInt(GetValue(objRS,"PAGAR_RECEBER")) <> 0 Then 
				strICON  = "icon_FinContaPagar"
				strTITLE = "Conta a Pagar"					
			Else
				strICON  = "icon_FinContaReceber"
				strTITLE = "Conta a Receber"
			End if
%>
		<td style="background:url(../img/<%=strICON%>.gif) no-repeat top; width:21px;" title="<%=strTITLE%>"></td>
		<td>
<% 
			If GetValue(objRS,"NUM_IMPRESSOES")<>"" and CInt("0" & GetValue(objRS,"NUM_IMPRESSOES"))>0 Then
				strFilePath = "upload/" & UCase(Request.Cookies("VBOSS")("CLINAME")) & "/FIN_Boletos"
				strFileName	= "Boleto_" & GetValue(objRS,"COD_CONTA_PAGAR_RECEBER") & "_" & GetValue(objRS,"NUM_IMPRESSOES") & ".htm"
				response.write(MontaLinkPopup(strFilePath, strFileName, "", "Icon_BOLETO.gif", "BOLETO", "700", "500", "yes"))
			End if 
%>
		</td>	
		<td>
<% 
			If GetValue(objRS,"ARQUIVO_ANEXO")<>"" Then
				strFilePath = "upload/" & UCase(Request.Cookies("VBOSS")("CLINAME")) & "/FIN_Titulos"
				strFileName	= GetValue(objRS,"ARQUIVO_ANEXO")
				response.write(MontaLinkPopup(strFilePath, strFileName, "", "ico_clip.gif", "ANEXO", "700", "500", "yes"))
			End if 
%>
		</td>	
	</tr>
<%
		End If
		athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
	Wend
	FechaRecordSet objRS	
			
%>
 </tbody>
</table>


<!-- Lctos em conta - somente para colaboradores e fornecedores//-->
<%
	If (strTIPO_ENT<>"ENT_CLIENTE") and (strTIPO_ENT<>"") Then
		strSQL = "SELECT"	                              &_
				"	LCTO.COD_LCTO_EM_CONTA,"		
		If (strTIPO_ENT = "ENT_FORNECEDOR")Then				
			strSQL = strSQL & " FORNEC.NOME_COMERCIAL AS NOME, "
		Else				
			strSQL = strSQL & " COLAB.NOME AS NOME,  "
		End If													
		strSQL = strSQL                                      &_					
				"	CTA.NOME AS CONTA, " 			         &_			
				"	PLAN.COD_REDUZIDO AS COD_RED_PLAN, "     &_					
				"	PLAN.NOME AS PLANO_CONTA,"		         &_
				"	CUST.COD_REDUZIDO AS COD_RED_CUST, "     &_										
				"	CUST.NOME AS CENTRO_CUSTO,"      	     &_					
				"	LCTO.NUM_LCTO,"	                         &_					
				"	LCTO.DT_LCTO, "		                     &_					
				"	COALESCE(LCTO.VLR_LCTO,0) AS VLR_LCTO, " &_					
				"	LCTO.OPERACAO "	                         &_					
				"FROM FIN_LCTO_EM_CONTA LCTO "	    	     &_
				"LEFT OUTER JOIN FIN_PLANO_CONTA PLAN ON (PLAN.COD_PLANO_CONTA = LCTO.COD_PLANO_CONTA) " 	 &_
				"LEFT OUTER JOIN FIN_CENTRO_CUSTO CUST ON (CUST.COD_CENTRO_CUSTO = LCTO.COD_CENTRO_CUSTO) "  &_
				"LEFT OUTER JOIN FIN_CONTA CTA ON (LCTO.COD_CONTA = CTA.COD_CONTA) " 
		If (strTIPO_ENT = "ENT_FORNECEDOR")Then
			strSQL = strSQL & "LEFT OUTER JOIN ENT_FORNECEDOR FORNEC ON (LCTO.CODIGO = FORNEC.COD_FORNECEDOR) "			
			strSQL = strSQL & "WHERE FORNEC.COD_FORNECEDOR = " & strCODIGO_ENT & " "
		Else
			strSQL = strSQL & "LEFT OUTER JOIN ENT_COLABORADOR COLAB ON (LCTO.CODIGO = COLAB.COD_COLABORADOR) "
			strSQL = strSQL & "WHERE COLAB.COD_COLABORADOR = " & strCODIGO_ENT  & " "
		End If								
		strSQL = strSQL &	"AND LCTO.COD_LCTO_EM_CONTA > 0 "		
		'strSQL = strSQL &	"AND 0=1 "		

		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		If not objRS.Eof Then 
			boolLCTO = false 
%>					
LANÇAMENTOS EM CONTA:<br><br>			
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <!-- Possibilidades de tipo de sort...
  class="sortable-date-dmy"
  class="sortable-currency"
  class="sortable-numeric"
  class="sortable"
 -->
	<thead>
		<tr>
			<th width="8%"  class="sortable">Cod. Lcto.</th>
			<th width="25%" class="sortable">Entidade</th>						
			<th width="7%" class="sortable">C. Lcto.</th>									
			<th width="17%" class="sortable" nowrap>Plano de Conta</th>
			<th width="17%" class="sortable" nowrap>Centro de Custo</th>			
			<th width="5%"  class="sortable-numeric">Número</th>				
			<th width="10%"  class="sortable-date-dmy">Data</th>					
			<th width="10%"  class="sortable-currency" nowrap>Valor (R$)</th>			
			<th width="1%" class="sortable"></th>						
		</tr>
	</thead>
	<tbody style="text-align:left;">
<%
		'athDebug strSQL, true
		End if
		While not objRS.Eof	
%>
		<tr bgcolor=<%=strCOLOR%>> 
			<td><%=GetValue(objRS,"COD_LCTO_EM_CONTA")%></td>		
			<td nowrap><%=GetValue(objRS,"NOME")%></td>			
			<td nowrap><%=GetValue(objRS,"CONTA")%></td>						
			<td nowrap><%=GetValue(objRS,"COD_RED_PLAN")%>&nbsp;&nbsp;<%=GetValue(objRS,"PLANO_CONTA")%></td>			
			<td nowrap><%=GetValue(objRS,"COD_RED_CUST")%>&nbsp;&nbsp;<%=GetValue(objRS,"CENTRO_CUSTO")%></td>			
			<td nowrap><%=GetValue(objRS,"NUM_LCTO")%></td>			
			<td align="right"><%=PrepData(GetValue(objRS,"DT_LCTO"),true,false)%></td>			
			<td align="right"><%=FormataDecimal(GetValue(objRS,"VLR_LCTO"),2)%></td>			
<%
			If GetValue(objRS,"OPERACAO") = "DESPESA" Then 
				strICON  = "icon_FinContaPagar"
				strTITLE = "Despesa"					
			Else
				strICON  = "icon_FinContaReceber"
				strTITLE = "Receita"
			End If
%>
		<td style="background:url(../img/<%=strICON%>.gif) no-repeat top; width:21px;" title="<%=strTITLE%>"></td>			
	  	</tr>			
<%	
			athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT			
		Wend
			FechaRecordSet objRS					
	End If
%>
	<tbody>  
</table>

<%
	If boolLCTO and boolTIT Then Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
End If
%>

</body>
</html>

<%
FechaDBConn objConn
%>