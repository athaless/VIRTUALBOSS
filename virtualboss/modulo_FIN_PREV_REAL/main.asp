<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FIN_PREV_REAL", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"--> 
<%
 Dim objConn, objRS, strSQL
 Dim strCOD_PREV_ORCA, strCOD_PLANO_CONTA
 Dim dblPERCENT, dblREALIZADO, dblDIF
 Dim arrTOTAL()
 Dim i, j
 Dim strCOLOR

 strCOLOR = "#DAEEFA"

 i = 0 'Conta os registros da primeira consulta
 j = 0 'Auxiliar p/ nomear ID's 

 strCOD_PREV_ORCA 	= GetParam("var_cod_prev_orca")
 strCOD_PLANO_CONTA	= GetParam("var_cod_plano_conta")

function RecursiveItens(prCodPai)
Dim LocalstrSQL, LocalObjRS, LocalAuxCont, LocalDblSUM
	LocalstrSQL =	"SELECT" 							&_
						"	T1.COD_PLANO_CONTA," 		&_
						"	T1.COD_PLANO_CONTA_PAI," 	&_
						"	T1.NOME," 					&_
						"	T1.NIVEL," 					&_
						"	T2.VALOR," 					&_
						"	T3.DT_PREV_INI,"			&_
						"	T3.DT_PREV_FIM,"			&_												
						"	T1.COD_REDUZIDO " 			&_
						"FROM ((" 						&_
						"	FIN_PLANO_CONTA T1 " 		&_
						"LEFT OUTER JOIN" 				&_
						"	FIN_PLANO_PREV_ORCA T2 ON (T1.COD_PLANO_CONTA=T2.COD_PLANO_CONTA))"	&_
						"LEFT OUTER JOIN" 	&_
						"	FIN_PREV_ORCA T3 ON (T2.COD_PREV_ORCA=T3.COD_PREV_ORCA)) "			&_						
						"WHERE T2.COD_PREV_ORCA = " & strCOD_PREV_ORCA & " AND" 				&_ 
						"	T1.COD_PLANO_CONTA_PAI=" & prCodPai & " " 							&_
						"ORDER BY T1.ORDEM, T1.NOME"
   AbreRecordSet LocalObjRS, LocalstrSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1

   while not LocalObjRS.eof
		strCOLOR = swapString (strCOLOR,"#F5FAFA","#FFFFFF")

		dblDIF = null
		dblREALIZADO = 0
		
		dblREALIZADO = dblREALIZADO + BuscaRealizado(GetValue(LocalObjRS,"COD_PLANO_CONTA"),GetValue(LocalObjRS,"DT_PREV_INI"),GetValue(LocalObjRS,"DT_PREV_FIM"),"RECEITA",0)
		dblREALIZADO = dblREALIZADO + BuscaRealizado(GetValue(LocalObjRS,"COD_PLANO_CONTA"),GetValue(LocalObjRS,"DT_PREV_INI"),GetValue(LocalObjRS,"DT_PREV_FIM"),"RECEBER",1)
		dblREALIZADO = dblREALIZADO - BuscaRealizado(GetValue(LocalObjRS,"COD_PLANO_CONTA"),GetValue(LocalObjRS,"DT_PREV_INI"),GetValue(LocalObjRS,"DT_PREV_FIM"),"DESPESA",0)
		dblREALIZADO = dblREALIZADO - BuscaRealizado(GetValue(LocalObjRS,"COD_PLANO_CONTA"),GetValue(LocalObjRS,"DT_PREV_INI"),GetValue(LocalObjRS,"DT_PREV_FIM"),"PAGAR",1)

		if GetValue(LocalObjRS,"VALOR")<>"" then 
			if	dblREALIZADO = 0 then dblDIF = null else dblDIF = FormataDecimal(dblREALIZADO-GetValue(LocalObjRS,"VALOR"),2)
		end if
		
		dblPERCENT = null
		if GetValue(LocalObjRS,"VALOR")<>"" and GetValue(LocalObjRS,"VALOR")<>0 then dblPERCENT = FormataDecimal(dblREALIZADO*100/GetValue(LocalObjRS,"VALOR"),2) & "%"

		if dblREALIZADO<>0 then 
			LocalDblSUM  = LocalDblSUM + dblREALIZADO
			dblREALIZADO = FormataDecimal(dblREALIZADO,2) 
		else 
			dblREALIZADO = null
			dblPERCENT	 = null
		end if

		'HTML dos filhos das contas
		with Response
			.Write("<tr bgcolor='"& strCOLOR &"'>")
			.Write("	<td>"& GetValue(LocalObjRS,"COD_REDUZIDO") &"</div></td>")
			.Write("	<td><img src='../img/Custos_Nivel"& GetValue(LocalObjRS,"NIVEL") &".gif' border='0'>"& GetValue(LocalObjRS,"NOME") &"</div></td>")
			.Write("	<td align='right' nowrap>" & dblREALIZADO & "</div></td>")
			.Write("	<td align='right' nowrap>" & FormataDecimal(GetValue(LocalObjRS,"VALOR"),2) & "</div></td>")
			.Write("	<td align='right' nowrap>" & dblDIF & "</div></td>")
			.Write("	<td align='right' nowrap>" & dblPERCENT  & "</div></td>")
			.Write("</tr>")
		end with
		
 	  	LocalDblSUM = LocalDblSUM + RecursiveItens(GetValue(LocalObjRS,"COD_PLANO_CONTA"))
		athMoveNext LocalObjRS, ContFlush, CFG_FLUSH_LIMIT		
   wend

   FechaRecordSet(LocalObjRS)
   RecursiveItens = LocalDblSUM
end function


function BuscaRealizado(prCOD_PLANO_CONTA,prDT_PREV_INI,prDT_PREV_FIM,prNOME,prTIPO)
Dim LocalstrSQL, LocalstrSQLClause
Dim LocalObjRS
Dim dblVALOR
	
	dblVALOR = 0
	
	if prCOD_PLANO_CONTA="" or prDT_PREV_INI="" or prDT_PREV_FIM="" or prNOME="" or prTIPO="" then 
		BuscaRealizado = CDbl(dblVALOR)
	end if
		
	LocalstrSQL ="SELECT SUM(VLR_LCTO) AS " & prNOME & " FROM"
	
	LocalstrSQLClause	= 	"	FIN_LCTO_EM_CONTA " 	&_
								"WHERE" 						&_
								"	OPERACAO='" & prNOME & "' AND" &_
								"	COD_PLANO_CONTA =" & prCOD_PLANO_CONTA & " AND " &_
								"	DT_LCTO "				
																
	if prTIPO = 1 then
		LocalstrSQLClause	= 	"	FIN_CONTA_PAGAR_RECEBER T1 "	&_
									"RIGHT OUTER JOIN" 					&_
									"	FIN_LCTO_ORDINARIO T2 ON (T1.COD_CONTA_PAGAR_RECEBER=T2.COD_CONTA_PAGAR_RECEBER) " &_
									"WHERE"									&_
									"	T1.PAGAR_RECEBER = "  & (prNOME="PAGAR")  & " AND"	&_
									"	T2.COD_PLANO_CONTA =" & prCOD_PLANO_CONTA & " AND"	&_
									"	T2.DT_LCTO "
	end if	
	LocalstrSQL = LocalstrSQL & LocalstrSQLClause 
	LocalstrSQL = LocalstrSQL & "BETWEEN '" & PrepDataBrToUni(prDT_PREV_INI,false) & "' AND '" & PrepDataBrToUni(prDT_PREV_FIM,false) & "'"
	
	AbreRecordSet LocalObjRS, LocalstrSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	if not LocalObjRS.eof and GetValue(LocalObjRS,prNOME)<>"" then dblVALOR = GetValue(LocalObjRS,prNOME)
    FechaRecordSet LocalObjRS
	
	BuscaRealizado = CDbl(dblVALOR)
end function


sub AtualizaValor(prRealizado, prDiferenca, prPercent, prNum)
	with Response
		.Write("<script>")	
		.Write("var novoValor = document.createTextNode('" & prRealizado & "');")
		.Write("document.getElementById('lin'+" & prNum & ").appendChild(novoValor);")

		.Write("novoValor = document.createTextNode('" & prDiferenca & "');")
		.Write("document.getElementById('lin'+" & prNum+1 & ").appendChild(novoValor);")

		.Write("novoValor = document.createTextNode('" & prPercent & "%');")
		.Write("document.getElementById('lin'+" & prNum+2 & ").appendChild(novoValor);")
		.Write("</script>")
	end with
end sub


if strCOD_PREV_ORCA<>"" then
	AbreDBConn objConn, CFG_DB 
	
	strSQL =	"SELECT" 						&_
				"	T1.COD_PLANO_CONTA," 		&_
				"	T1.COD_PLANO_CONTA_PAI," 	&_
				"	T1.NOME," 					&_
				"	T1.NIVEL," 					&_
				"	T1.DT_INATIVO," 			&_
				"	T2.VALOR," 					&_
				"	T3.DT_PREV_INI,"			&_
				"	T3.DT_PREV_FIM,"			&_												
				"	T1.COD_REDUZIDO " 			&_
				"FROM (("						&_
				"	FIN_PLANO_CONTA T1 " 		&_
				"LEFT OUTER JOIN" 				&_
				"	FIN_PLANO_PREV_ORCA T2 ON (T1.COD_PLANO_CONTA=T2.COD_PLANO_CONTA)) " &_
				"LEFT OUTER JOIN" 				&_
				"	FIN_PREV_ORCA T3 ON (T2.COD_PREV_ORCA=T3.COD_PREV_ORCA)) " 			&_
				"WHERE T2.COD_PREV_ORCA="  & strCOD_PREV_ORCA & " AND "
	if	strCOD_PLANO_CONTA="" then 
		strSQL = strSQL & "T1.COD_PLANO_CONTA_PAI IS NULL " 
	else 
		strSQL = strSQL & "T1.COD_PLANO_CONTA=" & strCOD_PLANO_CONTA & " "
	end if
	strSQL = strSQL &	"ORDER BY T1.ORDEM,	T1.NOME"
														
	AbreRecordSet objRS, strSQL, objConn, adOpenStatic 'adOpenStatic - retorna valor do RecordCount
	if not objRS.eof then	
	   if objRS.RecordCount-1 > 0 then 
	     reDim arrTOTAL(objRS.RecordCount-1) 
	   else	 
	     reDim arrTOTAL(10) 
	   end if
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
    <th width="01%" class="sortable" nowrap>Cod Reduzido</th>
    <th width="79%" class="sortable">Nome</th>
    <th width="05%">Realizado</th>
    <th width="05%">Previsto</th>
    <th width="05%">Diferença</th>
    <th width="05%">%</th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%	
		while not objRS.Eof 		
			dblREALIZADO = 0
			dblDIF = ""
'			dblREALIZADO = dblREALIZADO + BuscaRealizado(GetValue(objRS,"COD_PLANO_CONTA"),GetValue(objRS,"DT_PREV_INI"),GetValue(objRS,"DT_PREV_FIM"),"RECEITA",0)
'			dblREALIZADO = dblREALIZADO + BuscaRealizado(GetValue(objRS,"COD_PLANO_CONTA"),GetValue(objRS,"DT_PREV_INI"),GetValue(objRS,"DT_PREV_FIM"),"RECEBER",1)
'			dblREALIZADO = dblREALIZADO - BuscaRealizado(GetValue(objRS,"COD_PLANO_CONTA"),GetValue(objRS,"DT_PREV_INI"),GetValue(objRS,"DT_PREV_FIM"),"DESPESA",0)
'			dblREALIZADO = dblREALIZADO - BuscaRealizado(GetValue(objRS,"COD_PLANO_CONTA"),GetValue(objRS,"DT_PREV_INI"),GetValue(objRS,"DT_PREV_FIM"),"PAGAR",1)
			j=j+1
	%>	
	<tr>
		<td><%=GetValue(objRS,"COD_REDUZIDO")%></div></td>
		<td><img src="../img/Custos_Nivel<%=GetValue(objRS,"NIVEL")%>.gif" border="0"><%=GetValue(objRS,"NOME")%></td>
		<td align="right" nowrap><div id="lin<%=i+j%>"></div></td>
		<td align="right" nowrap><%=FormataDecimal(GetValue(objRS,"VALOR"),2)%></div></td>
		<td align="right" nowrap><div id="lin<%=i+j+1%>"></div></td>
		<td align="right" nowrap><div id="lin<%=i+j+2%>"></div></td>
	</tr>
	<%	
			arrTOTAL(i) = RecursiveItens(GetValue(ObjRS,"COD_PLANO_CONTA"))
	
			if GetValue(objRS,"VALOR")<>"" then 
				if	dblREALIZADO = 0 then 
					dblDIF = FormataDecimal(GetValue(objRS,"VALOR"),2) 
				else 
					dblDIF = FormataDecimal(arrTOTAL(i)-CDbl(GetValue(objRS,"VALOR")),2)
				end if
			end if
	
			dblPERCENT = "" '"-"
			if GetValue(objRS,"VALOR")<>"" and GetValue(objRS,"VALOR")<>0 then dblPERCENT = FormataDecimal(arrTOTAL(i)*100/CDbl(GetValue(objRS,"VALOR")),2)
			AtualizaValor FormataDecimal(arrTOTAL(i),2), dblDIF, dblPERCENT, i+j
			i=i+1
			j=j+1
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
else
	Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
end if

FechaRecordSet objRS
FechaDBConn objConn
%>