<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
 Response.Expires = -1
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
 Dim strSALDO, strTR
 Dim strCOD_CONTA, strPREVISTA, strREALIZADA, strCODLCTO
 Dim strTIPO, strCODIGO
 Dim strCOD_CENTRO_CUSTO, strCOD_PLANO_CONTA
 Dim strPARAM1, strPARAM2, strPARAM3, strPARAM4, strPARAM5, strPARAM6, strPARAM7, strPARAM8
 Dim strCOLOR
 
 AbreDBConn objConn, CFG_DB 

 strMES	             = GetParam("var_mes")
 strANO	             = GetParam("var_ano")
 strPERIODO          = GetParam("var_periodo")
 strDT_INI           = GetParam("var_dt_ini")
 strDT_FIM           = GetParam("var_dt_fim")
 strCOD_CONTA        = GetParam("var_cod_conta")
 strTIPO             = GetParam("var_tipo")
 strCODIGO           = GetParam("var_codigo")
 strCOD_PLANO_CONTA  = GetParam("var_cod_plano_conta")
 strCOD_CENTRO_CUSTO = GetParam("var_cod_centro_custo")
 strCODLCTO          = GetParam("var_cod_lcto")
 
 If strDT_INI <> "" And strDT_FIM <> "" Then
	strMES = DatePart("M"   , strDT_INI)
	strANO = DatePart("YYYY", strDT_INI)
 Else
	strDT_INI = PrepData(DateAdd("D", -10, Date()), True, False)
	strDT_FIM = PrepData(Date(), True, False)
	strMES = DatePart("M"   , strDT_INI)
	strANO = DatePart("YYYY", strDT_INI)
 End If

 'athDebug "<br>strDT_INI " & strDT_INI, False
 'athDebug "<br>strDT_FIM " & strDT_FIM, False
 'athDebug "<br>strMES " & strMES, False
 'athDebug "<br>strANO " & strANO, False
 'athDebug "<br>strCOD_CONTA " & strCOD_CONTA, False
 
 
 strSALDO = 0

 if (strANO <> "") and (strCOD_CONTA <> "") then
     '-------------------------------------------------------------------------
	' ATENÇAO
	' ------------------------------------------------------------------------
	' Union não funciona no MYSQL 4.1.18. Didivi a consulta em duas e coloquei 
	' os dados numa matriz, alimentada pelas duas consultas.
	' ------------------------------------------------------------------------
	const CODIGO          = 0
	const CODIGO_LCTO     = 1
	const CONTA_PREVISTA  = 2
	const OPERACAO        = 3
	const MODULO          = 4
	const TIPO            = 5
	const COD_ENTIDADE    = 6
	const HISTORICO       = 7
	const VALOR           = 8
	const DATA            = 9
	const CONTA_REL       = 10
	const NUM_LCTO        = 11
	
    dim matRS()
    dim intTAMlin, intTAMcol, intTamNew
    dim i,j,strUSUARIO
	
	intTAMlin = 10500
	intTAMcol = 12
	intTamNew = 0
 	redim matRS(intTAMcol,intTAMlin)
	
	'---------------------------------------------
	' Monta busca de lançamentos ordinários
	'---------------------------------------------
	strSQL = MontaSQLUnion_A(strCOD_CONTA, strDT_INI, strDT_FIM, strANO, strCODIGO, strTIPO, strCOD_CENTRO_CUSTO, strCOD_PLANO_CONTA, strCODLCTO )
 	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
 	i = 0
 	Do While Not objRS.Eof
		matRS(CODIGO,i)          = GetValue(objRS, "CODIGO")
		matRS(CODIGO_LCTO,i)     = GetValue(objRS, "CODIGO_LCTO")
		matRS(CONTA_PREVISTA ,i) = GetValue(objRS, "CONTA_PREVISTA")
		matRS(OPERACAO,i)        = GetValue(objRS, "OPERACAO")
		matRS(MODULO,i)          = GetValue(objRS, "MODULO")
		matRS(TIPO,i)            = GetValue(objRS, "TIPO")
		matRS(COD_ENTIDADE,i)    = GetValue(objRS, "COD_ENTIDADE")
		matRS(HISTORICO,i)       = GetValue(objRS, "HISTORICO")
		matRS(VALOR,i)           = GetValue(objRS, "VALOR")
		matRS(DATA,i)            = GetValue(objRS, "DATA")
		matRS(CONTA_REL,i)       = GetValue(objRS, "CONTA_REALIZADA")
		matRS(NUM_LCTO,i)        = GetValue(objRS, "NUM_LCTO")
		athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
		i = i + 1
		if (i > intTAMlin) then
 		  Mensagem "A Consulta ultrapassou o número máximo de registros a retornar ("&i&").<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
		  athDebug "", true
	    end if
	Loop
    intTamNew = i 'i-1
    redim preserve matRS(intTAMcol,intTamNew) 
    FechaRecordSet objRS
	
    ' Abre espaço para o próximo SLQ
	intTamNew = intTamNew + intTAMlin
    redim preserve matRS(intTAMcol,intTamNew) 
	'---------------------------------------------
	' Monta busca de lançamentos em conta
	'---------------------------------------------
	strSQL = MontaSQLUnion_B(strCOD_CONTA, strDT_INI, strDT_FIM, strANO, strCODIGO, strTIPO, strCOD_CENTRO_CUSTO, strCOD_PLANO_CONTA, strCODLCTO )
 	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
 	Do While Not objRS.Eof
		matRS(CODIGO,i)          = GetValue(objRS, "CODIGO")
		matRS(CODIGO_LCTO,i)     = GetValue(objRS, "CODIGO_LCTO")
		matRS(CONTA_PREVISTA ,i) = GetValue(objRS, "CONTA_PREVISTA")
		matRS(OPERACAO,i)        = GetValue(objRS, "OPERACAO")
		matRS(MODULO,i)          = GetValue(objRS, "MODULO")
		matRS(TIPO,i)            = GetValue(objRS, "TIPO")
		matRS(COD_ENTIDADE,i)    = GetValue(objRS, "COD_ENTIDADE")
		matRS(HISTORICO,i)       = GetValue(objRS, "HISTORICO")
		matRS(VALOR,i)           = GetValue(objRS, "VALOR")
		matRS(DATA,i)            = GetValue(objRS, "DATA")
		matRS(CONTA_REL,i)       = GetValue(objRS, "CONTA_REALIZADA")
		matRS(NUM_LCTO,i)        = GetValue(objRS, "NUM_LCTO")		
		athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
		i = i + 1
		if (i > intTAMlin) then
 		  Mensagem "A Consulta ultrapassou o número máximo de registros a retornar ("&i&").<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
		  athDebug "", true
	    end if
	Loop
    intTamNew = i 'i-1
    redim preserve matRS(intTAMcol,intTamNew) 
    FechaRecordSet objRS
	
	'---------------------------------------------------------------------------------------------------------------------------
	' Monta busca para lançamentos de transferência
	' Se usuário selecionar algum dos filtros abaixo então NÃO deve trazer as transferências
	' 1) centro de custo
	' 2) plano de conta
	' 3) tipo e/ou entidade
	'---------------------------------------------------------------------------------------------------------------------------
	If (strDT_INI <> "" Or strDT_FIM <> "" Or strCOD_CONTA <> "") And strCODIGO = "" And strTIPO = "" And strCOD_CENTRO_CUSTO = "" And strCOD_PLANO_CONTA = "" Then 
	    ' Abre espaço para o próximo SLQ
		intTamNew = intTamNew + intTAMlin
   		redim preserve matRS(intTAMcol,intTamNew) 
		
		strSQL = MontaSQLUnion_C(strCOD_CONTA, strDT_INI, strDT_FIM, strANO, strCODLCTO )
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		Do While Not objRS.Eof
			matRS(CODIGO,i)          = GetValue(objRS, "CODIGO")
			matRS(CODIGO_LCTO,i)     = GetValue(objRS, "CODIGO_LCTO")
			matRS(CONTA_PREVISTA ,i) = GetValue(objRS, "CONTA_PREVISTA")
			matRS(OPERACAO,i)        = GetValue(objRS, "OPERACAO")
			matRS(MODULO,i)          = GetValue(objRS, "MODULO")
			matRS(TIPO,i)            = GetValue(objRS, "TIPO")
			matRS(COD_ENTIDADE,i)    = GetValue(objRS, "COD_ENTIDADE")
			matRS(HISTORICO,i)       = GetValue(objRS, "HISTORICO")
			matRS(VALOR,i)           = GetValue(objRS, "VALOR")
			matRS(DATA,i)            = GetValue(objRS, "DATA")
			matRS(CONTA_REL,i)       = GetValue(objRS, "CONTA_REALIZADA")
			matRS(NUM_LCTO,i)        = GetValue(objRS, "NUM_LCTO")			
			athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
			i = i + 1
			if (i > intTAMlin) then
			  Mensagem "A Consulta ultrapassou o número máximo de registros a retornar ("&i&").<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
			  athDebug "", true
			end if
		Loop
		intTamNew = i 'i-1
		redim preserve matRS(intTAMcol,intTamNew) 
		FechaRecordSet objRS
		
	    ' Abre espaço para o próximo SLQ
		intTamNew = intTamNew + intTAMlin
   		redim preserve matRS(intTAMcol,intTamNew) 
		
		strSQL = MontaSQLUnion_D(strCOD_CONTA, strDT_INI, strDT_FIM, strANO, strCODLCTO )
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		Do While Not objRS.Eof
			matRS(CODIGO,i)          = GetValue(objRS, "CODIGO")
			matRS(CODIGO_LCTO,i)     = GetValue(objRS, "CODIGO_LCTO")
			matRS(CONTA_PREVISTA ,i) = GetValue(objRS, "CONTA_PREVISTA")
			matRS(OPERACAO,i)        = GetValue(objRS, "OPERACAO")
			matRS(MODULO,i)          = GetValue(objRS, "MODULO")
			matRS(TIPO,i)            = GetValue(objRS, "TIPO")
			matRS(COD_ENTIDADE,i)    = GetValue(objRS, "COD_ENTIDADE")
			matRS(HISTORICO,i)       = GetValue(objRS, "HISTORICO")
			matRS(VALOR,i)           = GetValue(objRS, "VALOR")
			matRS(DATA,i)            = GetValue(objRS, "DATA")
			matRS(CONTA_REL,i)       = GetValue(objRS, "CONTA_REALIZADA")
			matRS(NUM_LCTO,i)        = GetValue(objRS, "NUM_LCTO")			
			athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
			i = i + 1
			if (i > intTAMlin) then
			  Mensagem "A Consulta ultrapassou o número máximo de registros a retornar ("&i&").<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
			  athDebug "", true
			end if
		Loop
		intTamNew = i 'i-1
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
	
	QuickSortLctos matRS, 0, intTamNew-1, intTAMcol, 1, "DATA"
	
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
		strTOTAL_ENTRADA = 0
		strTOTAL_SAIDA = 0
%>
<html>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <thead>
  <tr> 
    <th WIDTH="01%"></th>		
    <th WIDTH="01%">Cód.</th>		
    <th WIDTH="05%">Data</th>		
    <th WIDTH="25%">Entidade</th>
    <th WIDTH="10%">Prevista</th>
    <th WIDTH="10%">Realizada</th>								
	<th WIDTH="10%">Num. Lcto</th>									
    <th WIDTH="35%">Histórico</th>
    <th WIDTH="01%" nowrap>Entrada</th>
    <th WIDTH="01%" nowrap>Saída</th>								
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
			
			strVLR_IN = ""
			strVLR_OUT = ""
			
			strPREVISTA  = matRS(CONTA_PREVISTA ,i)
			strREALIZADA = matRS(CONTA_REL ,i)
			
			if matRS(OPERACAO,i)<>"ENTRADA" then
				strVLR_OUT     = strVALOR
				strTOTAL_SAIDA = strTOTAL_SAIDA + CDbl(strVLR_OUT)
				strSALDO       = strSALDO - CDbl(strVLR_OUT)
				
				strICON  = "Pagar"
				strTITLE = "SAIDA"					
			else
				strVLR_IN         = strVALOR
				strTOTAL_ENTRADA  = strTOTAL_ENTRADA + CDbl(strVLR_IN)
				strSALDO          = strSALDO + CDbl(strVLR_IN)
				
				strICON  = "Receber"
				strTITLE = "ENTRADA"
			end if
			
			Response.Write(strTR)
			strTR=""
%>
	<TR bgcolor=<%=strCOLOR%>>		
		<TD><%
		If matRS(MODULO,i) = "TITULOS"   Then Response.Write(MontaLinkGrade("modulo_FIN_TITULOS","Detail.asp",matRS(CODIGO,i),"IconAction_DETAIL.gif","DETALHE"))
		If matRS(MODULO,i) = "LCTOCONTA" Then Response.Write(MontaLinkGrade("modulo_FIN_LCTOCONTA","Detail.asp",matRS(CODIGO,i),"IconAction_DETAIL.gif","DETALHE"))
		If matRS(MODULO,i) = "TRANSF"    Then Response.Write(MontaLinkGrade("modulo_FIN_LCTOCONTA","DetailTransf.asp",matRS(CODIGO,i),"IconAction_DETAIL.gif","DETALHE"))
		%></TD>
		<TD><%
		If matRS(MODULO,i) = "TITULOS"   Then Response.Write("O.")
		If matRS(MODULO,i) = "LCTOCONTA" Then Response.Write("C.")
		If matRS(MODULO,i) = "TRANSF"    Then Response.Write("T.")
		%><%=matRS(CODIGO_LCTO,i)%>
		</TD>
		<TD nowrap><%=PrepData(matRS(DATA,i),true,false)%></TD>
		<TD><%=strENTIDADE%></TD>
		<TD nowrap><%=strPREVISTA%></TD>
		<TD nowrap><%=strREALIZADA%></TD>
		<TD><%=matRS(NUM_LCTO,i)%></TD>		
		<TD><%=matRS(HISTORICO,i)%></TD>
		<TD ALIGN="right"><%=strVLR_IN%></TD>
		<TD ALIGN="right"><%=strVLR_OUT%></TD>
		<TD nowrap><img src="../img/icon_FinConta<%=strICON%>.gif" align="middle" center width:"21px" TITLE="<%=strTITLE%>"></TD></TR>
	</TR>
<%
		strMES = Month(matRS(DATA,i))
		
		i = i + 1
		strMOSTRA_TOTAL = (i>=intTamNew)
		if i<intTamNew then strMES_NEXT = month(matRS(DATA,i)) end if
		if (strMES<>strMES_NEXT) or strMOSTRA_TOTAL then
		
%>
	<TR>
		<TD COLSPAN="7" align="right" WIDTH="98%">Valor Total:</TD>
		<TD WIDTH="01%" align="right"><b><%=FormataDecimal(strTOTAL_ENTRADA,2)%></b></TD>
		<TD WIDTH="01%" align="right"><b><%=FormataDecimal(strTOTAL_SAIDA,2)%></b></TD>
		<TD>&nbsp;</TD>
	</TR>
	
	<TR ALIGN="right">
		<TD COLSPAN="7" align="right">Saldo:</TD>
		<TD>&nbsp;</TD>
		<TD nowrap align="right"><b><%=FormataDecimal(strSALDO,2)%></b></TD>
		<TD>&nbsp;</TD>		
	</TR>
<%
			strTOTAL_ENTRADA = 0
			strTOTAL_SAIDA   = 0
			strSALDO         = 0
			
			If strCOD_CONTA = "" Then
				if i<intTamNew  then  Response.Write(strTR)
			End If
			strTR=""
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