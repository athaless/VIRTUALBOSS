<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn 
                                                 %>
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
 Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_CONTRATO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
 <!--#include file="../_database/athUtils.asp"--> 
<%
 Dim objConn, objRS, strSQL
 Dim strCODIFICACAO, strTITULO, strSITUACAO, strTPCOBR, strDTSTATUS
 Dim strAviso, strCOLOR, strFilePath, bRenova, strDtFim
 
 strAviso = "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente."
 
 AbreDBConn objConn, CFG_DB 
 
 strCODIFICACAO = GetParam("var_codificacao")
 strTITULO 		= GetParam("var_titulo"     )
 strSITUACAO 	= GetParam("var_situacao"   )
 strTPCOBR 		= GetParam("var_tp_cobranca")
 strDTSTATUS    = GetParam("var_dtstatus"   )
 
 strSQL =          " SELECT T1.CODIGO                                                            "
 strSQL = strSQL & "      , T1.TIPO                                                              "
 strSQL = strSQL & "      , T1.TP_RENOVACAO                                                      " 
 strSQL = strSQL & "      , T1.COD_CONTRATO                                                      "
 strSQL = strSQL & "      , T1.CODIFICACAO                                                       " 
 strSQL = strSQL & "      , T1.TITULO                                                            "  
 strSQL = strSQL & "      , T1.DT_INI                                                            "   
 strSQL = strSQL & "      , T1.DT_FIM                                                            "  
 strSQL = strSQL & "      , T1.DT_ASSINATURA                                                     "    
 strSQL = strSQL & "      , T1.SITUACAO                                                          "     
 strSQL = strSQL & "      , T1.DOC_CONTRATO                                                      "
 strSQL = strSQL & "      , T1.OBS                                                               "
 strSQL = strSQL & "      , T1.FREQUENCIA                                                        "    
 strSQL = strSQL & "      , T1.NUM_PARC                                                          "      
 strSQL = strSQL & "      , T1.VLR_TOTAL                                                         "        
 strSQL = strSQL & "      , T1.DT_BASE_VCTO                                                      "
 strSQL = strSQL & "      , T1.DTT_PROX_REAJUSTE                                                 "    
 strSQL = strSQL & "      , T2.NOME_FANTASIA AS CLIENTE                                          "
 strSQL = strSQL & "      , T3.NOME_FANTASIA AS FORNECEDOR                                       "
 strSQL = strSQL & "      , T4.NOME AS COLABORADOR                                               "
 strSQL = strSQL & "      , T1.DT_INATIVO                                                        "
 strSQL = strSQL & " FROM CONTRATO T1                                                            "
 strSQL = strSQL & " LEFT OUTER JOIN ENT_CLIENTE     T2 ON (T1.CODIGO      = T2.COD_CLIENTE    ) "
 strSQL = strSQL & " LEFT OUTER JOIN ENT_FORNECEDOR  T3 ON (T1.CODIGO      = T3.COD_FORNECEDOR ) "
 strSQL = strSQL & " LEFT OUTER JOIN ENT_COLABORADOR T4 ON (T1.CODIGO      = T4.COD_COLABORADOR) "
 strSQL = strSQL & " WHERE T1.CODIGO = T1.CODIGO "
 
 if strCODIFICACAO <> "" then strSQL = strSQL & " AND T1.CODIFICACAO LIKE '" & strCODIFICACAO & "%' "
 if strTITULO      <> "" then strSQL = strSQL & " AND T1.TITULO LIKE '" & strTITULO & "%' "
 if strTPCOBR      <> "" then strSQL = strSQL & " AND T1.TP_COBRANCA LIKE '" & strTPCOBR & "' "

 if strSITUACAO<>"" then
	if mid(strSITUACAO,1,1)="_" then 
		strSQL = strSQL & " AND T1.SITUACAO NOT LIKE '"& mid(strSITUACAO,2) & "' "
	else
		strSQL = strSQL & " AND T1.SITUACAO LIKE '"& strSITUACAO &"'"
	end if
 end if

 if ucase(strDTSTATUS) = "INATIVO" then strSQL = strSQL & " AND T1.DT_INATIVO IS NOT NULL " 
 if ucase(strDTSTATUS) = "ATIVO"   then strSQL = strSQL & " AND T1.DT_INATIVO IS NULL "

 strSQL = strSQL & " ORDER BY T1.TITULO "
  'athDebug strSQL, false
 
 Set objRS = objConn.Execute(strSQL) 
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
	<th width="1%"></th>
	<th width="1%"></th>
	<th width="1%"></th>
	<th width="1%"></th>			
	<th width="1%" class="sortable">Cod</th>			
	<th width="25%" class="sortable">Entidade</th>
	<th width="26%" class="sortable">Título</th>
    <th width="14%" class="sortable" nowrap>Codificação</th>
    <th width="8%" class="sortable-date-dmy" nowrap>Dt Início</th>
    <th width="8%" class="sortable-date-dmy" nowrap>Dt Fim</th>
	<th width="10%" class="sortable-currency" nowrap>Valor</th>
    <th width="1%"></th>
    <th width="1%"></th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%
      While Not objRs.Eof
	    strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
 %>
 <tr bgcolor="<%=strCOLOR%>"> 
 
	
	<% 
		If ( (GetValue(objRS, "SITUACAO") = "ABERTO") OR (GetValue(objRS, "SITUACAO") = "AVULSO")  )Then 
		  Response.Write("<td title='REMOVER' alt='REMOVER'>" & MontaLinkGrade("modulo_CONTRATO","Delete.asp",GetValue(objRS, "COD_CONTRATO"),"IconAction_DEL.gif","REMOVER") & "</td>")
		ElseIf GetValue(objRS, "SITUACAO") <> "CANCELADO" Then  
		  Response.Write("<td title='CANCELAR' alt='CANCELAR'>" & MontaLinkGrade("modulo_CONTRATO","Delete.asp",GetValue(objRS, "COD_CONTRATO"),"IconAction_CANCEL.gif","CANCELAR") & "</td>")
		End IF  
	%>
	
	<td title="ALTERAR" alt="ALTERAR"><% If GetValue(objRS, "SITUACAO") = "ABERTO" Then Response.Write(MontaLinkGrade("modulo_CONTRATO","Update.asp",GetValue(objRS, "COD_CONTRATO"),"IconAction_EDIT.gif","ALTERAR")) End If %></td>
	<td title="VISUALIZAR" alt="VISUALIZAR"><%=MontaLinkGrade("modulo_CONTRATO","Detail.asp",GetValue(objRS, "COD_CONTRATO"),"IconAction_DETAIL.gif","VISUALIZAR")%></td>
	<td title="COPIAR" alt="COPIAR"><%=MontaLinkGrade("modulo_CONTRATO","Copia.asp",GetValue(objRS, "COD_CONTRATO"),"IconAction_COPY.gif","COPIAR")%></td>    
    <!-- Renovação de contrato fica disponível 20 dias antes do término do contrato. By Lumertz 14/12/2012 //-->	
	<td title="RENOVAR" alt="RENOVAR"><%	bRenova = False
	       	strDtFim = GetValue(objRS, "DT_FIM")
	       	If StrDtFim <> "" Then  
		   		strDtFim = DateAdd("D",-20, strDtFim) 
				bRenova = (Now>=strDtFim)
	    	End If
			If (GetValue(objRS, "SITUACAO") = "FATURADO" Or GetValue(objRS, "SITUACAO") = "AVULSO") And (GetValue(objRS, "TP_RENOVACAO") = "RENOVAVEL") And (bRenova) and (GetValue(objRS,"DT_INATIVO")="") Then Response.Write(MontaLinkGrade("modulo_CONTRATO","Pre_Renova.asp",GetValue(objRS, "COD_CONTRATO"),"IconAction_CONTRATO_RENOVA.gif","RENOVAR")) End If 
		%>
	</td> 
	<td title="PROCESSAR" alt="PROCESSAR"><% If ((GetValue(objRS,"SITUACAO")="ABERTO")   and (GetValue(objRS,"DT_INATIVO")="") ) Then Response.Write(MontaLinkGrade("modulo_CONTRATO","Processa.asp",GetValue(objRS, "COD_CONTRATO"),"IconAction_CONTRATO_PROCESSA.gif","PROCESSAR")) End If %></td>
	<td title="REAJUSTAR" alt="REAJUSTAR"><% If ((GetValue(objRS,"SITUACAO")="FATURADO") and (Now() >= GetValue(objRS,"DTT_PROX_REAJUSTE")) and (GetValue(objRS,"DT_INATIVO")="") ) Then Response.Write(MontaLinkGrade("modulo_CONTRATO","Reajusta.asp",GetValue(objRS,"COD_CONTRATO"),"IconAction_CONTRATO_REAJUSTA.gif","REAJUSTAR")) End If %></td>		
    <td style="text-align:left"><%=GetValue(objRS, "COD_CONTRATO")%></td>
    <td style="text-align:left"><%
		If GetValue(objRS, "TIPO") = "ENT_CLIENTE" Then Response.Write(GetValue(objRS, "CLIENTE"))
		If GetValue(objRS, "TIPO") = "ENT_FORNECEDOR" Then Response.Write(GetValue(objRS, "FORNECEDOR"))
		If GetValue(objRS, "TIPO") = "ENT_COLABORADOR" Then Response.Write(GetValue(objRS, "COLABORADOR"))
	%></td>
	<td style="text-align:left"><%=GetValue(objRS, "TITULO")%></td>
    <td style="text-align:left"><%=GetValue(objRS, "CODIFICACAO")%></td>
    <td style="text-align:right"><%=PrepData(GetValue(objRS, "DT_INI"), True, False)%></td>
    <td style="text-align:right"><%=PrepData(GetValue(objRS, "DT_FIM"), True, False)%></td>
	<td style="text-align:right"><%=FormataDecimal(GetValue(objRS, "VLR_TOTAL"), 2)%></td>
	<td style="background:url(../img/IconStatus_<%=GetValue(objRS, "SITUACAO")%>.gif) no-repeat center; width:21px;" title="<%=GetValue(objRS, "SITUACAO")%>"></td>
	<td><%
	If GetValue(objRS, "DOC_CONTRATO") <> "" Then
		strFilePath = "../upload/" & Request.Cookies("VBOSS")("CLINAME") & "/CONTRATOS/" & GetValue(objRS,"DOC_CONTRATO")
		Response.Write(MontaLinkPopup("modulo_CONTRATO", strFilePath, "", "Icon_CONTRATO.gif", "CONTRATO", "840", "550", "no"))
	End If
	%></td>
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
	Mensagem strAviso, "", "", true
 end if
 FechaRecordSet objRS
 FechaDBConn objConn
%>