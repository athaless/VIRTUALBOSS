<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.AddHeader "Content-Type","text/html; charset=iso-8859-1"
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FIN_LCTO_GERAIS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
 <!--#include file="../_database/athUtils.asp"--> 
 <!--#include file="_includeMontaSQLs.asp"--> 
<%
 Dim objConn, objRS, strSQL, objRSa, objRSb
 Dim strMES, strMES_NEXT, strANO 
 Dim strDT_INI, strDT_FIM, strPERIODO
 Dim strORIGEM, strDESTINO, strENTIDADE
 Dim strVLR_IN, strVLR_OUT, strVALOR
 Dim strICON, strTITLE, strMOSTRA_TOTAL
 Dim strTOTAL_ENTRADA, strTOTAL_SAIDA
 Dim strSALDO_ANTERIOR, strTR
 Dim strCOD_CONTA, strPREVISTA, strREALIZADA
 Dim strTIPO, strCODIGO
 Dim ExibirSaldo
 Dim strCOD_CENTRO_CUSTO, strCOD_PLANO_CONTA
 Dim strPARAM1, strPARAM2, strPARAM3, strPARAM4, strPARAM5, strPARAM6, strPARAM7, strPARAM8
 Dim strCOLOR
 
 AbreDBConn objConn, CFG_DB 

 strMES	             = GetParam("var_mes")
 strANO	             = GetParam("var_ano")
 strPERIODO          =  GetParam("var_periodo")
 strDT_INI           = GetParam("var_dt_ini")
 strDT_FIM           = GetParam("var_dt_fim")
 strCOD_CONTA        = GetParam("var_cod_conta")
 strTIPO             = GetParam("var_tipo")
 strCODIGO           = GetParam("var_codigo")
 strCOD_PLANO_CONTA  = GetParam("var_cod_plano_conta")
 strCOD_CENTRO_CUSTO = GetParam("var_cod_centro_custo")
 
	If strPERIODO = "FIXO" Then
		If IsEmpty(strANO) Then strANO = DatePart("YYYY", Date)
		
		if strMES="" then 
			strDT_INI = DateSerial(strANO,  1,  1)
			strDT_FIM = DateSerial(strANO, 12, 31)
		else
			strDT_INI = DateSerial(strANO, strMES, 1)
			strDT_FIM = DateAdd("D", -1, DateAdd("M", 1, strDT_INI))
		end if
	End If
	If strPERIODO = "LIVRE" Then
		If strDT_INI <> "" And strDT_FIM <> "" Then
			strMES = DatePart("M"   , strDT_INI)
			strANO = DatePart("YYYY", strDT_INI)
		End If
	End If
	If strPERIODO = "" Then
		strPERIODO = "LIVRE"
		
		strDT_INI = PrepData(DateAdd("D", -10, Date()), True, False)
		strDT_FIM = PrepData(Date(), True, False)
		strMES = DatePart("M"   , strDT_INI)
		strANO = DatePart("YYYY", strDT_INI)
	End If
	
 strSALDO_ANTERIOR = 0
 ExibirSaldo = False
 If (strCOD_CENTRO_CUSTO = "" And strCOD_PLANO_CONTA = "" And strCODIGO = "" And strTIPO = "") Then ExibirSaldo = True

 if (strANO <> "") and (strCOD_CONTA <> "") then
     '-------------------------------------------------------------------------
	' ATENÇAO
	' ------------------------------------------------------------------------
	' Union não funciona no MYSQL 4.1.18. Didivi a consulta em duas e coloquei 
	' os dados numa matriz, alimentada pelas duas consultas.
	' ------------------------------------------------------------------------
	const CODIGO          = 0
	const CONTA_PREVISTA  = 1
	const OPERACAO        = 2
	const MODULO          = 3
	const TIPO            = 4
	const COD_ENTIDADE    = 5
	const HISTORICO       = 6
	const VALOR           = 7
	const DATA            = 8
	const CONTA_REL       = 9
 
    dim matRS()
    dim intTAMlin, intTAMcol, intTamNew
    dim i,j,strUSUARIO

	intTAMlin = 10500
	intTAMcol = 10
	intTamNew = 0
 	redim matRS(intTAMcol,intTAMlin)

	'---------------------------------------------
	' Monta busca de lançamentos ordinários
	'---------------------------------------------
	strSQL = MontaSQLUnion_A(strCOD_CONTA, strDT_INI, strDT_FIM, strANO, strCODIGO, strTIPO, strCOD_CENTRO_CUSTO, strCOD_PLANO_CONTA )
 	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
 	i = 0
 	Do While Not objRS.Eof
		matRS(CODIGO,i)          = GetValue(objRS, "CODIGO")
		matRS(CONTA_PREVISTA ,i) = GetValue(objRS, "CONTA_PREVISTA")
		matRS(OPERACAO,i)        = GetValue(objRS, "OPERACAO")
		matRS(MODULO,i)          = GetValue(objRS, "MODULO")
		matRS(TIPO,i)            = GetValue(objRS, "TIPO")
		matRS(COD_ENTIDADE,i)    = GetValue(objRS, "COD_ENTIDADE")
		matRS(HISTORICO,i)       = GetValue(objRS, "HISTORICO")
		matRS(VALOR,i)           = GetValue(objRS, "VALOR")
		matRS(DATA,i)            = GetValue(objRS, "DATA")
		matRS(CONTA_REL,i)       = GetValue(objRS, "CONTA_REALIZADA")
		athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
		i = i + 1
		if (i > intTAMlin) then
 		  Mensagem "A Consulta ultrapassou o número máximo de registros a retornar ("&i&").<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
		  athDebug "", true
	    end if
	Loop
    intTamNew = i-1
    redim preserve matRS(intTAMcol,intTamNew) 
    FechaRecordSet objRS


    ' Abre espaço para o próximo SLQ
	intTamNew = intTamNew + intTAMlin
    redim preserve matRS(intTAMcol,intTamNew) 
	'---------------------------------------------
	' Monta busca de lançamentos em conta
	'---------------------------------------------
	strSQL = MontaSQLUnion_B(strCOD_CONTA, strDT_INI, strDT_FIM, strANO, strCODIGO, strTIPO, strCOD_CENTRO_CUSTO, strCOD_PLANO_CONTA )
 	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
 	Do While Not objRS.Eof
		matRS(CODIGO,i)          = GetValue(objRS, "CODIGO")
		matRS(CONTA_PREVISTA ,i) = GetValue(objRS, "CONTA_PREVISTA")
		matRS(OPERACAO,i)        = GetValue(objRS, "OPERACAO")
		matRS(MODULO,i)          = GetValue(objRS, "MODULO")
		matRS(TIPO,i)            = GetValue(objRS, "TIPO")
		matRS(COD_ENTIDADE,i)    = GetValue(objRS, "COD_ENTIDADE")
		matRS(HISTORICO,i)       = GetValue(objRS, "HISTORICO")
		matRS(VALOR,i)           = GetValue(objRS, "VALOR")
		matRS(DATA,i)            = GetValue(objRS, "DATA")
		matRS(CONTA_REL,i)       = GetValue(objRS, "CONTA_REALIZADA")
		athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
		i = i + 1
		if (i > intTAMlin) then
 		  Mensagem "A Consulta ultrapassou o número máximo de registros a retornar ("&i&").<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
		  athDebug "", true
	    end if
	Loop
    intTamNew = i-1
    redim preserve matRS(intTAMcol,intTamNew) 
    FechaRecordSet objRS


	'---------------------------------------------------------------------------------------------------------------------------
	' Monta busca para lançamentos de transferência
	' Se usuário selecionar algum dos filtros abaixo então NÃO deve trazer as transferências
	' 1) centro de custo
	' 2) plano de conta
	' 3) tipo e/ou entidade
	'---------------------------------------------------------------------------------------------------------------------------
	If (strDT_INI <> "" Or strDT_FIM <> "" Or strCOD_CONTA <> "") And strCODIGO = "" And strTIPO = "" Then 
	    ' Abre espaço para o próximo SLQ
		intTamNew = intTamNew + intTAMlin
   		redim preserve matRS(intTAMcol,intTamNew) 

		strSQL = MontaSQLUnion_C(strCOD_CONTA, strDT_INI, strDT_FIM, strANO )
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		Do While Not objRS.Eof
			matRS(CODIGO,i)          = GetValue(objRS, "CODIGO")
			matRS(CONTA_PREVISTA ,i) = GetValue(objRS, "CONTA_PREVISTA")
			matRS(OPERACAO,i)        = GetValue(objRS, "OPERACAO")
			matRS(MODULO,i)          = GetValue(objRS, "MODULO")
			matRS(TIPO,i)            = GetValue(objRS, "TIPO")
			matRS(COD_ENTIDADE,i)    = GetValue(objRS, "COD_ENTIDADE")
			matRS(HISTORICO,i)       = GetValue(objRS, "HISTORICO")
			matRS(VALOR,i)           = GetValue(objRS, "VALOR")
			matRS(DATA,i)            = GetValue(objRS, "DATA")
			matRS(CONTA_REL,i)       = GetValue(objRS, "CONTA_REALIZADA")
			athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
			i = i + 1
			if (i > intTAMlin) then
			  Mensagem "A Consulta ultrapassou o número máximo de registros a retornar ("&i&").<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
			  athDebug "", true
			end if
		Loop
		intTamNew = i-1
		redim preserve matRS(intTAMcol,intTamNew) 
		FechaRecordSet objRS


	    ' Abre espaço para o próximo SLQ
		intTamNew = intTamNew + intTAMlin
   		redim preserve matRS(intTAMcol,intTamNew) 

		strSQL = MontaSQLUnion_D(strCOD_CONTA, strDT_INI, strDT_FIM, strANO )
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		Do While Not objRS.Eof
			matRS(CODIGO,i)          = GetValue(objRS, "CODIGO")
			matRS(CONTA_PREVISTA ,i) = GetValue(objRS, "CONTA_PREVISTA")
			matRS(OPERACAO,i)        = GetValue(objRS, "OPERACAO")
			matRS(MODULO,i)          = GetValue(objRS, "MODULO")
			matRS(TIPO,i)            = GetValue(objRS, "TIPO")
			matRS(COD_ENTIDADE,i)    = GetValue(objRS, "COD_ENTIDADE")
			matRS(HISTORICO,i)       = GetValue(objRS, "HISTORICO")
			matRS(VALOR,i)           = GetValue(objRS, "VALOR")
			matRS(DATA,i)            = GetValue(objRS, "DATA")
			matRS(CONTA_REL,i)       = GetValue(objRS, "CONTA_REALIZADA")
			athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
			i = i + 1
			if (i > intTAMlin) then
			  Mensagem "A Consulta ultrapassou o número máximo de registros a retornar ("&i&").<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
			  athDebug "", true
			end if
		Loop
		intTamNew = i-1
		redim preserve matRS(intTAMcol,intTamNew) 
		FechaRecordSet objRS
    end if


    ' Debug da Matriz gerada...
	' -----------------------------------------------
	'athDebug "<table>", false
	'for i=0 to intTamNew
	'  athDebug "<tr>", false
	'  for j=0 to intTAMcol
	'    athDebug "<td>" & matRS(j,i) & "<td>", false
	'  next
	'  athDebug "</tr>", false
	'next  
	'athDebug "</table>", false



	if intTamNew > 0 then 
		'-------------------------------------------------------------------------------------
		' Busca saldo anterior
		' Se foi solicitada pesquisa por alguma conta, então não exibe informações de saldo
		'-------------------------------------------------------------------------------------
		If ExibirSaldo = False Then
			strSALDO_ANTERIOR = 0
			strTR = ""
		Else
			strSQL = "SELECT DISTINCT COD_CONTA FROM FIN_SALDO_AC "
			if (strCOD_CONTA <> "") then strSQL = strSQL & " WHERE COD_CONTA = " & strCOD_CONTA 
			
			AbreRecordSet objRSa, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
			if not objRSa.eof then
				while not objRSa.eof
					if strMES<>"" then 					
						strSQL =          " SELECT VALOR AS SALDO_ANTERIOR, STR_TO_DATE(CONCAT('01 ', MES, ' ', ANO),'%d %m %Y') AS DATA_AC "
						strSQL = strSQL & " FROM FIN_SALDO_AC WHERE STR_TO_DATE(CONCAT('01 ', MES, ' ', ANO),'%d %m %Y') "
						strSQL = strSQL & " < STR_TO_DATE(CONCAT('01 ', " & strMES & ", ' ', " & strANO & "),'%d %m %Y') "
						strSQL = strSQL & " AND COD_CONTA=" & GetValue(objRSa,"COD_CONTA") & " ORDER BY 2"			
					else
						strSQL =          " SELECT VALOR AS SALDO_ANTERIOR, STR_TO_DATE(CONCAT('01 ', MES, ' ', ANO),'%d %m %Y') AS DATA "
						strSQL = strSQL & " FROM FIN_SALDO_AC WHERE ANO<"& strANO &" AND COD_CONTA="& GetValue(objRSa,"COD_CONTA") & " ORDER BY 2"
					end if
					
					AbreRecordSet objRSb, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
					
					if not objRSb.eof then 
						objRSb.MoveLast
						if GetValue(objRSb,"SALDO_ANTERIOR")<>"" then strSALDO_ANTERIOR = strSALDO_ANTERIOR + CDbl(GetValue(objRSb,"SALDO_ANTERIOR"))
					else
						'strSQL = "SELECT VLR_SALDO_INI FROM FIN_CONTA WHERE COD_CONTA=" & GetValue(objRSa,"COD_CONTA")
						if strMES<>"" then 					
							strSQL = "SELECT VLR_SALDO_INI, STR_TO_DATE(CONCAT('01 ', Month(DT_CADASTRO), ' ', Year(DT_CADASTRO)),'%d %m %Y') AS DATA_AC "
							strSQL = strSQL & " FROM FIN_CONTA WHERE STR_TO_DATE(CONCAT('01 ', Month(DT_CADASTRO), ' ', Year(DT_CADASTRO)),'%d %m %Y') "
							strSQL = strSQL & "	< STR_TO_DATE(CONCAT('01 ', " &  strMES & ", ' ', " & strANO & "),'%d %m %Y') "
							strSQL = strSQL & " AND COD_CONTA=" & GetValue(objRSa,"COD_CONTA") & " ORDER BY 2 DESC"						
						else
							strSQL =          " SELECT VLR_SALDO_INI, STR_TO_DATE(CONCAT('01 ', Month(DT_CADASTRO), ' ', Year(DT_CADASTRO)), '%d %m %Y') AS DATA "
							strSQL = strSQL & " FROM FIN_CONTA WHERE Year(DT_CADASTRO)<"& strANO &" AND COD_CONTA="& GetValue(objRSa,"COD_CONTA")
							strSQL = strSQL & " ORDER BY 2 DESC"
						end if
						
						AbreRecordSet objRSb, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
						if not objRSb.eof then strSALDO_ANTERIOR = strSALDO_ANTERIOR + CDbl(GetValue(objRSb,"VLR_SALDO_INI"))				
					end if
					
					FechaRecordSet objRSb
					'objRSa.MoveNext
					athMoveNext objRSa, ContFlush, 0
				wend
			end if
			FechaRecordSet objRSa				
		End If
		
		If ExibirSaldo = True Then
			'--------------------------------------------------------
			'Exibe o saldo acumulado
			'--------------------------------------------------------
			strSALDO_ANTERIOR = FormataDecimal(strSALDO_ANTERIOR,2)
			strTR = "<tr bgcolor='" & strCOLOR & "' valign='middle'><td></td><td></td><td></td><td></td><td></td>"
			strTR = strTR & "<td height='16px'>Saldo Total Anterior</div></td>"
			if CDbl(strSALDO_ANTERIOR)>0 then
				strTOTAL_ENTRADA = CDbl(strSALDO_ANTERIOR)
				strTR = strTR & "<td align='right'>" & FormataDecimal(strSALDO_ANTERIOR,2) & "</div></td><td></td><td></td></tr>"
			else
				strTOTAL_SAIDA = CDbl(strSALDO_ANTERIOR) 
				strTR = strTR & "<td></div></td><td align='right'>" & FormataDecimal(strSALDO_ANTERIOR,2) & "</div></td><td></td></tr>"
			end if	
		End If				
%>
<html>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%">
 <thead>
  <tr> 
    <th WIDTH="01%"></th>		
    <th WIDTH="01%">Data</th>		
    <th WIDTH="20%">Entidade</th>
    <th WIDTH="25%">Prevista</th>
    <th WIDTH="25%">Realizada</th>								
    <th WIDTH="25%">Histórico</th>
    <th WIDTH="01%" nowrap>Vlr Entrada</th>
    <th WIDTH="01%" nowrap>Vlr Saída</th>								
    <th WIDTH="01%"></th>		
  </TR>
  </thead>
 <tbody style="text-align:left;">
<%	
        i=0
	    strMES = month(matRS(DATA,i))
  		while i< intTamNew
			strCOLOR = swapString (strCOLOR,"#F5FAFA","#FFFFFF")
			strVALOR = "0,00"	
			if matRS(VALOR,i)<>"" then	strVALOR = FormataDecimal(matRS(VALOR,i),2)
			
			strSQL=""
			if matRS(TIPO,i)="ENT_CLIENTE"	   and IsNumeric(GetValue(objRS,"COD_ENTIDADE")) then strSQL = "SELECT NOME_COMERCIAL AS NOME FROM ENT_CLIENTE		WHERE COD_CLIENTE     =" & matRS(COD_ENTIDADE,i)
			if matRS(TIPO,i)="ENT_FORNECEDOR"  and IsNumeric(GetValue(objRS,"COD_ENTIDADE")) then strSQL = "SELECT NOME_COMERCIAL AS NOME FROM ENT_FORNECEDOR	WHERE COD_FORNECEDOR  =" & matRS(COD_ENTIDADE,i)
			if matRS(TIPO,i)="ENT_COLABORADOR" and IsNumeric(GetValue(objRS,"COD_ENTIDADE")) then strSQL = "SELECT NOME                   FROM ENT_COLABORADOR WHERE COD_COLABORADOR ="  & matRS(COD_ENTIDADE,i)
			
			strENTIDADE=""
			if strSQL<>"" then 
				AbreRecordSet objRSa, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
				strENTIDADE=""
				if not objRSa.Eof then strENTIDADE = GetValue(objRSa,"NOME")
				FechaRecordSet objRSa
			end if 
			
			strVLR_IN = ""
			strVLR_OUT = ""
			
			strPREVISTA  = matRS(CONTA_PREVISTA ,i)
			strREALIZADA = matRS(CONTA_REL ,i)
			
			if GetValue(objRS,"OPERACAO")<>"ENTRADA" then
				strVLR_OUT        = strVALOR
				strTOTAL_SAIDA    = strTOTAL_SAIDA + CDbl(strVLR_OUT)
				strSALDO_ANTERIOR = strSALDO_ANTERIOR - CDbl(strVLR_OUT)
				
				strICON  = "Pagar"
				strTITLE = "SAIDA"					
			else
				strVLR_IN = strVALOR
				strTOTAL_ENTRADA  = strTOTAL_ENTRADA + CDbl(strVLR_IN)
				strSALDO_ANTERIOR = strSALDO_ANTERIOR + CDbl(strVLR_IN)
				
				strICON  = "Receber"
				strTITLE = "ENTRADA"
			end if
			
			Response.Write(strTR)
			strTR=""
%>
	<TR bgcolor=<%=strCOLOR%>>		
		<TD>
		<%
		If GetValue(objRS,"MODULO") <> "" Then
			Response.Write(MontaLinkGrade("modulo_FIN_"& matRS(MODULO,i),"Detail.asp",matRS(CODIGO,i),"IconAction_DETAIL.gif","DETALHE"))
		End If
		%>
		</TD>
		<TD nowrap><%=PrepData(matRS(DATA,i),true,false)%></TD>
		<TD nowrap><%=strENTIDADE%></TD>
		<TD nowrap><%=strPREVISTA%></TD>
		<TD nowrap><%=strREALIZADA%></TD>
		<TD><%=matRS(HISTORICO,i)%></TD>
		<TD ALIGN="right"><%=strVLR_IN%></TD>
		<TD ALIGN="right"><%=strVLR_OUT%></TD>
		<TD nowrap><DIV STYLE="background: url(../img/icon_FinConta<%=strICON%>.gif) no-repeat center; width:21px;" TITLE="<%=strTITLE%>"></DIV></TD></TR>
	</TR>
<%
		strMES = Month(matRS(DATA,i))
		
		'athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
		'strMOSTRA_TOTAL = objRS.eof
		'if not objRS.eof then strMES_NEXT = month(GetValue(objRS,"DATA"))

		i = i + 1
		strMOSTRA_TOTAL = (i>=intTamNew)
		if i<intTamNew then strMES_NEXT = month(matRS(DATA,i)) end if
		if (strMES<>strMES_NEXT) or strMOSTRA_TOTAL then
		
%>
<% 'Response.Write("<tfoot>") %>
	<TR>
		<TD COLSPAN="6" align="right" WIDTH="98%">Valor Total:</TD>
		<TD WIDTH="01%" align="right"><b><%=FormataDecimal(strTOTAL_ENTRADA,2)%></b></TD>
		<TD WIDTH="01%" align="right"><b><%=FormataDecimal(strTOTAL_SAIDA,2)%></b></TD>
		<TD>&nbsp;</TD>
	</TR>
	<% If ExibirSaldo = True Then %>
	<TR ALIGN="right">
		<TD COLSPAN="6" align="right">Saldo no período:</TD>
		<TD>&nbsp;</TD>
		<TD nowrap align="right"><b><%=FormataDecimal(strSALDO_ANTERIOR,2)%></b></TD>
		<TD>&nbsp;</TD>		
	</TR>
    <% End If %>
<% 'Response.Write("</tfoot>") %>
<%
			strTOTAL_ENTRADA = "0,00"
			strTOTAL_SAIDA   = "0,00"
			
			If ExibirSaldo = True Then
				strTR = strTR & "<tr><td colspan='9' width='100%' style='border-bottom:1px solid #333333;'><span style='width:100%'></span></td></tr>"
				strTR = strTR & "<tr bgcolor='" & strCOLOR & "' valign='middle'><td></td><td></td><td></td><td></td><td></td>"
				strTR = strTR & "<td height='16px'>Saldo Total Anterior</div></td>"
				if CDbl(strSALDO_ANTERIOR)>0 then 
					strTOTAL_ENTRADA = CDbl(strSALDO_ANTERIOR)
					strTR = strTR & "<td align='right'>" & FormataDecimal(strSALDO_ANTERIOR,2) & "</div></td><td></td><td></td></tr>"
				else
					strTOTAL_SAIDA = CDbl(strSALDO_ANTERIOR) 
					strTR = strTR & "<td></div></td><td align='right'>" & FormataDecimal(strSALDO_ANTERIOR,2) & "</div></td><td></td></tr>"
				end if
				If strCOD_CONTA = "" Then
					if i<intTamNew  then  Response.Write(strTR)
				End If
				strTR=""
			End If
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