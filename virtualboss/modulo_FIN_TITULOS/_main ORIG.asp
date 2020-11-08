<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.AddHeader "Content-Type","text/html; charset=iso-8859-1"
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FIN_TITULOS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
 <!--include file="../_database/athUtils.asp"--> 
<%
 Dim objConn, objRS, strSQL, objRSa
 Dim strCOOKIE_ID_USUARIO, strGRUPO_USUARIO
 Dim strENTIDADE, strSALDO
 Dim strDT_INI, strDT_FIM, strPERIODO
 Dim strCONTA_PREVISTA, strCONTA_REALIZADA, strSITUACAO, strTIPO
 Dim strICON, strTITLE
 Dim strCODIGO_ENT, strTIPO_ENT, strNUM_LCTOS, strCOD_CONTAS_LCTOS, strCONTAS_LCTOS
 Dim Selecionado
 Dim strCOLOR

 AbreDBConn objConn, CFG_DB 

 strCOOKIE_ID_USUARIO = LCase(Request.Cookies("VBOSS")("ID_USUARIO"))
 strGRUPO_USUARIO 	  = UCase(Request.Cookies("VBOSS")("GRUPO_USUARIO"))

 strCONTA_PREVISTA	  = GetParam("var_fin_conta_prevista")
 strCONTA_REALIZADA	  = GetParam("var_fin_conta_realizada")
 strTIPO			  = GetParam("var_pr")	
 strSITUACAO		  = GetParam("var_situacao")
 strCODIGO_ENT		  = GetParam("var_codigo")
 strTIPO_ENT		  = GetParam("var_tipo")
 strDT_INI			  = GetParam("var_dt_ini") 
 strDT_FIM			  = GetParam("var_dt_fim") 
 
 if not IsDate(strDT_INI) then strDT_INI = ""
 if not IsDate(strDT_FIM) then strDT_FIM = ""
 
 if strSITUACAO<>"" then 
	strSQL = "SELECT" 															&_
				"	T1.COD_CONTA_PAGAR_RECEBER," 								&_
				"	T1.TIPO," 													&_
				"	T1.CODIGO," 												&_
				"	T1.DT_EMISSAO," 											&_
				"	T1.HISTORICO," 												&_
				"	T1.TIPO_DOCUMENTO," 										&_
				"	T1.NUM_DOCUMENTO," 											&_
				"	T1.PAGAR_RECEBER," 											&_
				"	T1.NUM_IMPRESSOES,"											&_
				"	T1.DT_VCTO," 												&_
				"	T1.VLR_CONTA," 												&_
				"	T2.NOME AS CONTA," 											&_
				"	T1.SITUACAO," 												&_
				"   T1.COD_NF,"													&_
				"	T3.NOME AS PLANO_CONTA," 									&_
				"	T3.COD_PLANO_CONTA," 										&_
				"	T3.COD_REDUZIDO AS PLANO_CONTA_COD_REDUZIDO," 				&_
				"	T4.NOME AS CENTRO_CUSTO," 									&_
				"	T4.COD_REDUZIDO AS CENTRO_CUSTO_COD_REDUZIDO " 				&_
				"FROM FIN_CONTA_PAGAR_RECEBER AS T1 " 							&_
				"LEFT OUTER JOIN FIN_CONTA AS T2 ON (T1.COD_CONTA=T2.COD_CONTA) "	&_
				"LEFT OUTER JOIN FIN_PLANO_CONTA AS T3 ON (T1.COD_PLANO_CONTA=T3.COD_PLANO_CONTA) "		&_
				"LEFT OUTER JOIN FIN_CENTRO_CUSTO AS T4 ON (T1.COD_CENTRO_CUSTO=T4.COD_CENTRO_CUSTO) " 	&_
				"WHERE T1.COD_CONTA_PAGAR_RECEBER > 0  AND T2.DT_INATIVO IS NULL "
	if strDT_INI<>"" and strDT_FIM<>"" then strSQL = strSQL & "	AND T1.DT_VCTO BETWEEN '"& PrepDataBrToUni(strDT_INI,false) &"' AND '"& PrepDataBrToUni(strDT_FIM,false) &"'"
	
	if mid(strSITUACAO,1,1)="_" then 
		strSQL = strSQL &	" AND T1.SITUACAO NOT LIKE '"& mid(strSITUACAO,2) &"' AND T1.SITUACAO NOT LIKE 'CANCELADA'"
	else
		strSQL = strSQL &	" AND T1.SITUACAO LIKE '"& strSITUACAO &"'"
	end if
	
	if strTIPO="PAGAR" then  strSQL = strSQL & " AND T1.PAGAR_RECEBER <> 0 "
	if strTIPO="RECEBER" then  strSQL = strSQL & " AND T1.PAGAR_RECEBER = 0 "
	
	if strCONTA_PREVISTA<>"" then strSQL = strSQL &	" AND (T2.COD_CONTA ="& strCONTA_PREVISTA &") "
	
	if strCODIGO_ENT<>"" and strTIPO_ENT<>"" then strSQL = strSQL & " AND (T1.TIPO LIKE '"& strTIPO_ENT &"' AND T1.CODIGO LIKE '"& strCODIGO_ENT &"')"
	
	strSQL = strSQL & " ORDER BY T1.DT_VCTO, T1.COD_CONTA_PAGAR_RECEBER "
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	if not objRS.Eof then 
%>
<html>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%">
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
    <th width="30%" class="sortable">Entidade</th>
    <th width="10%" class="sortable" nowrap>C.Prev</th>
    <th width="10%" class="sortable" nowrap>C.Lcto</th>
    <th width="35%" class="sortable" nowrap>Plano de Conta</th>
    <th width="12%" class="sortable" nowrap>Num.DOC</th>
    <th width="01%" class="sortable-date-dmy" nowrap>Dt Emissão</th>
    <th width="01%" class="sortable-date-dmy" nowrap>Dt Vcto</th>
    <th width="05%" class="sortable-numeric" nowrap>Vlr Conta</th>
    <th width="01%"></th>
    <th width="01%"></th>
  </thead>
 <tbody style="text-align:left;">
<%
      While Not objRs.Eof
        strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
			
			Selecionado = True
			
			strSQL =          " SELECT T2.COD_CONTA, T2.NOME "
			strSQL = strSQL & " FROM FIN_LCTO_ORDINARIO T1, FIN_CONTA T2 "
			strSQL = strSQL & " WHERE T1.COD_CONTA = T2.COD_CONTA "
			strSQL = strSQL & " AND T1.SYS_DT_CANCEL IS NULL "
			strSQL = strSQL & " AND T1.COD_CONTA_PAGAR_RECEBER = " & GetValue(objRS,"COD_CONTA_PAGAR_RECEBER")
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
		<% if Cint("0" & strNUM_LCTOS)<1 then %>
			<%=MontaLinkGrade("modulo_FIN_TITULOS","Delete.asp",GetValue(objRS,"COD_CONTA_PAGAR_RECEBER"),"IconAction_DEL.gif","REMOVER")%>
		<% end if %>
		</td>
		<td>
		<%if GetValue(objRS,"SITUACAO")="ABERTA" then%>
			<%=MontaLinkGrade("modulo_FIN_TITULOS","Update.asp",GetValue(objRS,"COD_CONTA_PAGAR_RECEBER"),"IconAction_EDIT.gif","ALTERAR")%>
		<%end if%>
		</td>
		<td><%=MontaLinkGrade("modulo_FIN_TITULOS","Detail.asp",GetValue(objRS,"COD_CONTA_PAGAR_RECEBER"),"IconAction_DETAIL.gif","DETALHE")%></td>		
		<td>
		<%if GetValue(objRS,"SITUACAO")<>"LCTO_TOTAL" and GetValue(objRS,"SITUACAO")<>"CANCELADA" then%>
			<%=MontaLinkGrade("modulo_FIN_TITULOS","InsertLcto.asp",GetValue(objRS,"COD_CONTA_PAGAR_RECEBER"),"IconAction_DETAILADD.gif","INSERIR LANÇAMENTO")%>
		<%end if%>
		</td>
		<%
		'Não podemos mais gerar NFs a partir de títulos a receber porque nos casos de 
		'desconto (com redução) teríamos problema em calcular o valor sem desconto para a nota
		%>
		<td>
		<%'if GetValue(objRS,"PAGAR_RECEBER")="0" and GetValue(objRS,"COD_NF")="" and GetValue(objRS,"TIPO")="ENT_CLIENTE" and GetValue(objRS,"SITUACAO")<>"CANCELADA" then%>
			<%'=MontaLinkGrade("modulo_FIN_TITULOS","GerarNFdeTitulo.asp",GetValue(objRS,"COD_CONTA_PAGAR_RECEBER"),"IconAction_GERARNF.gif","GERAR NF")%>
		<%'end if%>
		</td>
		<td><%=strENTIDADE%></td>
		<td nowrap><%=GetValue(objRS,"CONTA")%></td>
		<td nowrap><%=strCONTAS_LCTOS%></td>
		<td nowrap><%=GetValue(objRS,"PLANO_CONTA_COD_REDUZIDO")%>&nbsp;<%=GetValue(objRS,"PLANO_CONTA")%></td>
		<td nowrap><%=GetValue(objRS,"NUM_DOCUMENTO")%></td>
		<td align="right"><%=PrepData(GetValue(objRS,"DT_EMISSAO"),true,false)%></td>
		<td align="right"><%=PrepData(GetValue(objRS,"DT_VCTO"),true,false)%></td>
		<td align="right"><%=strSALDO%></td>
		<%
			if CInt(GetValue(objRS,"PAGAR_RECEBER")) <> 0 then 
				strICON  = "icon_FinContaPagar"
				strTITLE = "Conta a Pagar"					
			else
				strICON  = "icon_FinContaReceber"
				strTITLE = "Conta a Receber"
			end if
		%>
		<td style="background:url(../img/<%=strICON%>.gif) no-repeat center; width:21px;" title="<%=strTITLE%>"></td>
		<td>
			<% 
				if GetValue(objRS,"NUM_IMPRESSOES")<>"" and CInt("0" & GetValue(objRS,"NUM_IMPRESSOES"))>0 then
					Dim strFilePath, strFileName
					strFilePath = "../upload/" & UCase(Request.Cookies("VBOSS")("CLINAME")) & "/FIN_Boletos/" 
					strFileName	= "Boleto_"    & GetValue(objRS,"COD_CONTA_PAGAR_RECEBER") & "_" & GetValue(objRS,"NUM_IMPRESSOES") & ".htm"
					strFilePath	= strFilePath  & strFileName					
            		
				    'response.write (MontaLinkGrade("modulo_FIN_FLUXOCAIXA",strFilePath,"","Icon_BOLETO.gif","BOLETO") )
				%>
					<a href="#" style='cursor:pointer; text-decoration:none; border:none; outline:none;' onClick="javascript:window.open('<%=strFilePath%>', '', 'width=700,height=500,top=30,left=30,scrollbars=1,resizable=yes');"><img src="../img/Icon_BOLETO.gif" border="0px"></a>
				<% end if %>
		</td>	
	</tr>
<%
			End If
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
end if
FechaDBConn objConn
%>