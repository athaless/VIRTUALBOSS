<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_FIN_PREV_ORCA", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<%
Dim WMD_WIDTH, WMD_WIDTHTTITLES
WMD_WIDTH = 650
WMD_WIDTHTTITLES = 100

Dim objConn, objRS, objRSa, strSQL
Dim strCONTA, strSITUACAO
Dim strIFRAME_SRC, strIFRAME_COD
Dim strCOD_PREV_ORCA, strRW, strCLASS, i

AbreDBConn objConn, CFG_DB 

strCOD_PREV_ORCA = GetParam("var_chavereg")

function RecursiveItens(prCodPai, pr_FormPai, pr_nivel)
Dim LocalstrSQL, LocalObjRS, LocalAuxCont, i
	LocalstrSQL =	"SELECT" 							&_
						"	ORCA.COD_PLANO_PREV_ORCA,"	&_	
						"	ORCA.COD_PLANO_CONTA,"		&_
						"	ORCA.COD_REDUZIDO,"			&_
						"	PLAN.NOME,"						&_
						"	PLAN.COD_PLANO_CONTA_PAI,"	&_
						"	PLAN.NIVEL," 					&_
						"	ORCA.VALOR "					&_
						"FROM"								&_
						"	FIN_PLANO_PREV_ORCA ORCA " &_
						"LEFT OUTER JOIN " 				&_
						"	FIN_PLANO_CONTA PLAN ON (PLAN.COD_PLANO_CONTA=ORCA.COD_PLANO_CONTA) " &_
						"WHERE"								&_
						"	ORCA.COD_PREV_ORCA=" & strCOD_PREV_ORCA &_
						"	AND COD_PLANO_CONTA_PAI="  & prCodPai 	 &_
						" ORDER BY " 						&_
						"	PLAN.ORDEM," 					&_
						"	PLAN.NOME"
	AbreRecordSet LocalObjRS, LocalstrSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	i=0
	while not LocalObjRS.eof
		i=i+1		
		strSQL = "SELECT ORCA.COD_PLANO_CONTA FROM FIN_PLANO_PREV_ORCA ORCA " &_
					"LEFT OUTER JOIN FIN_PLANO_CONTA PLAN ON (PLAN.COD_PLANO_CONTA=ORCA.COD_PLANO_CONTA) " &_
					"WHERE COD_PLANO_CONTA_PAI=" & GetValue(LocalObjRS,"COD_PLANO_CONTA")
		AbreRecordSet objRSa, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		strRW=""
		strCLASS="edtext"
		if not objRSa.eof then 
			strRW="readonly"
			strCLASS="edtext"
		end if
		FechaRecordSet objRSa

		with Response
			.Write("<tr class='arial11' valign='middle'>" & vbNewLine																									)
			.Write("		<td height='16'>" & GetValue(LocalObjRS,"COD_PLANO_CONTA") & "</div></td>" & vbNewLine										)
			.Write("		<td nowrap>" & GetValue(LocalObjRS,"COD_REDUZIDO") & "</div></td>" & vbNewLine													) '"fr" & pr_FormPai & "_" & pr_nivel & i 
			.Write("		<td nowrap><img src='../img/Custos_Nivel"& GetValue(LocalObjRS,"NIVEL") &".gif' border='0'>"& GetValue(LocalObjRS,"NOME") &"</div></td>"& vbNewLine)
			.Write("		<form name='fr"& pr_FormPai &"_"& pr_nivel & i &"' id='fr"& pr_FormPai &"_"& pr_nivel & i &"' action='InsertPrev_Exec.asp' method='post' target='VBossIframeSave_"& GetValue(LocalObjRS,"COD_PLANO_PREV_ORCA") &"'>"& vbNewLine)
			.Write("		<input type='hidden' name='var_cod_plano_prev' value='" & GetValue(LocalObjRS,"COD_PLANO_PREV_ORCA") & "'>" & vbNewLine	)
			.Write("		<input type='hidden' name='var_cod_plano_pai' value='" & prCodPai & "'>" & vbNewLine												)
			.Write("		<input type='hidden' name='var_vlr_conta' value='' OnChange='alert(this.value);'>" & vbNewLine									)
			.Write("		<td><input class='"& strCLASS &"' name='ib"& pr_FormPai &"_" & pr_nivel & i &"' style='width:80px' title='"& FormataDecimal(GetValue(LocalObjRS,"VALOR"),2) &"' type='text' value='"& FormataDecimal(GetValue(LocalObjRS,"VALOR"),2) &"' onKeyPress='validateFloatKey();' onChange='fr"& pr_FormPai &"_"& pr_nivel & i &".var_vlr_conta.value=this.value;' onBlur=""JavaScript:reCalc('"& pr_FormPai &"_','"& pr_nivel & i &"',this.value); this.title=this.value;"""& strRW &"></div></td>" & vbNewLine)
	  		.Write("		</form>" & vbNewLine																																		)
			.Write("		<td><iframe id='VBossIframeSave_"& GetValue(LocalObjRS,"COD_PLANO_PREV_ORCA") &"' frameborder='0' width='16' height='16' name='VBossIframeSave_"& GetValue(LocalObjRS,"COD_PLANO_PREV_ORCA") & "' scrolling='no'></iframe></div></td>" & vbNewLine)
			.Write("</tr>" & vbNewLine																																				)			
		end with
		RecursiveItens GetValue(LocalObjRS,"COD_PLANO_CONTA"), pr_FormPai, pr_nivel & Cstr(i) & "_"
		LocalObjRS.MoveNext
   wend
   FechaRecordSet LocalObjRS
end function

strSQL =	"SELECT" 							&_
			"	ORCA.COD_PLANO_PREV_ORCA,"	&_
			"	ORCA.COD_PLANO_CONTA,"		&_
			"	ORCA.COD_REDUZIDO,"			&_
			"	PLAN.NOME,"						&_
			"	PLAN.COD_PLANO_CONTA_PAI,"	&_
			"	PLAN.NIVEL," 					&_
			"	ORCA.VALOR "					&_
			"FROM"								&_
			"	FIN_PLANO_PREV_ORCA ORCA " &_
			"LEFT OUTER JOIN" 				&_
			"	FIN_PLANO_CONTA PLAN ON (PLAN.COD_PLANO_CONTA=ORCA.COD_PLANO_CONTA) " &_
			"WHERE"								&_
			"	ORCA.COD_PREV_ORCA=" & strCOD_PREV_ORCA &_
			" 	AND PLAN.COD_PLANO_CONTA_PAI IS NULL "  &_						
			"ORDER BY " 						&_
			"	PLAN.ORDEM," 					&_
			"	PLAN.NOME"
AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
%>
<html>
<link rel="stylesheet" href="../_css/virtualboss.css" type="text/css">
<script>
var i=0;

function Grava() {
	if (i<document.forms.length) 
		document.forms[i].submit();
	else { 
		i=0;
		setTimeout("document.location.reload()",1000); 
	}
}

function SomaIGrava() {
	i++;
	Grava();
}

function reCalc(prOffset, prInic, prVlrFilho) {
var j, aux, vlrAtual, vlrOrig, OffsetPai;
	// Compara o valor digitado com o valor anterior e retorna a diferença calculada
	eval("document.fr" + prOffset + prInic + ".var_vlr_conta.value=" + "prVlrFilho.replace('.',',')");
	if (prVlrFilho!=eval("document.fr" + prOffset + prInic + ".ib" + prOffset + prInic + ".title")){
		if (MoedaToFloat(prVlrFilho)>MoedaToFloat(eval("document.fr" + prOffset + prInic + ".ib" + prOffset + prInic + ".title")))
			prVlrFilho =  MoedaToFloat(prVlrFilho) - MoedaToFloat(eval("document.fr" + prOffset + prInic + ".ib" + prOffset + prInic + ".title"));
		else
			prVlrFilho =  (MoedaToFloat(eval("document.fr" + prOffset + prInic + ".ib" + prOffset + prInic + ".title")) - MoedaToFloat(prVlrFilho))*-1;		
		prVlrFilho = FloatToMoeda(prVlrFilho);
	}
	else 
		prVlrFilho = FloatToMoeda(0.00);
	
	// Atualiza níveis acima	
	for (j=prInic.lastIndexOf('_');j>=0;j-=2) {
		vlrOrig  = eval("document.fr" + prOffset + prInic.substr(0,j) + ".ib" + prOffset + prInic.substr(0,j) + ".title");	
		vlrAtual = eval("document.fr" + prOffset + prInic.substr(0,j) + ".ib" + prOffset + prInic.substr(0,j) + ".value");	
		
		aux = parseFloat(MoedaToFloat(vlrOrig) + MoedaToFloat(prVlrFilho));				
		aux = FloatToMoeda(roundNumber(aux,2));
		
		eval("document.fr" + prOffset + prInic.substr(0,j) + ".ib" + prOffset + prInic.substr(0,j) + ".value = " + "aux.replace('.',',')");
		eval("document.fr" + prOffset + prInic.substr(0,j) + ".ib" + prOffset + prInic.substr(0,j) + ".title = " + "aux.replace('.',',')");
		eval("document.fr" + prOffset + prInic.substr(0,j) + ".var_vlr_conta.value=" + "aux.replace('.',',')");
	}
}
</script>
<style type="text/css">div{ padding-left:3px; padding-right:3px; }</style>
<body bgcolor="#ffffff" topmargin="0" leftmargin="3" rightmargin="0" bottommargin="0">
<% athBeginDialog WMD_WIDTH, "Previsão Orçamentária - Contas" %>
<table align="center" cellpadding="0" cellspacing="1" width="90%">
	<tr><td height="2" colspan="5"></td></tr>
	<tr class="arial11Bold" >
		<td width="01%" height="16">Código</div></td>
		<td width="01%">Cod Reduzido</div></td>
		<td width="55%">Nome</div></td>								
		<td width="30%">Valor</div></td>
		<td width="10%"></td>
	</tr>
<%
	i=0	
	while not objRS.eof 
	i=i+1
%>	
	<tr valign="middle">
	<form name="fr<%=GetValue(objRS,"COD_PLANO_PREV_ORCA")%>_<%=i%>" 
		id="fr<%=GetValue(objRS,"COD_PLANO_PREV_ORCA")%>_<%=i%>" action="InsertPrev_Exec.asp" method="post" target="VBossIframeSave_<%=GetValue(objRS,"COD_PLANO_PREV_ORCA")%>">
		<input type="hidden" name="var_cod_plano_prev" value="<%=GetValue(objRS,"COD_PLANO_PREV_ORCA")%>" title="<%=i%>">
		<input type="hidden" name="var_vlr_conta" value="<%=FormataDecimal(GetValue(objRS,"VALOR"),2)%>">
		<td height="16"><%=GetValue(objRS,"COD_PLANO_CONTA")%></div></td>
		<td nowrap><%=GetValue(objRS,"COD_REDUZIDO")%></div></td><%'fr<%=GetValue(objRS,"COD_PLANO_PREV_ORCA")_%=i%>
		<td nowrap><img src="../img/Custos_Nivel<%=GetValue(objRS,"NIVEL")%>.gif" border="0"><%=GetValue(objRS,"NOME")%></div>
		</td>						
		<td nowrap>
			
				<input class="edtext" name="ib<%=GetValue(objRS,"COD_PLANO_PREV_ORCA")%>_<%=i%>" id="ib<%=GetValue(objRS,"COD_PLANO_PREV_ORCA")%>_<%=i%>" 
				style="width:80px" type="text" onChange="fr<%=GetValue(objRS,"COD_PLANO_PREV_ORCA")%>_<%=i%>.var_vlr_conta.value=this.value;"
				title="<%=FormataDecimal(GetValue(objRS,"VALOR"),2)%>" value="<%=FormataDecimal(GetValue(objRS,"VALOR"),2)%>" readonly>
			</div>
		</td>
		<td><iframe id="VBossIframeSave_<%=GetValue(objRS,"COD_PLANO_PREV_ORCA")%>" frameborder="0" width="16" height="16" name="VBossIframeSave_<%=GetValue(objRS,"COD_PLANO_PREV_ORCA")%>" scrolling="no"></iframe></div></td>
	</form>
	</tr>
<%
      RecursiveItens GetValue(ObjRS,"COD_PLANO_CONTA"), GetValue(objRS,"COD_PLANO_PREV_ORCA"), Cstr(i) & "_"
		objRS.MoveNext
	wend
%>
</table>
<% athEndDialog WMD_WIDTH, "../img/bt_save.gif", "javascript:Grava();", "", "", "", "" %>
</body>
</html>
<%
FechaRecordSet objRS
FechaDBConn objConn
%>