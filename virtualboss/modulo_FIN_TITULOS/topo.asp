<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
Dim objConn, objRS, strSQL, strDIR, BoolDIR_PAGAR, BoolDIR_RECEBER, strAUX
Dim strDT_INI, strDT_FIM
Dim strTIPO, strSITUACAO

AbreDBConn objConn, CFG_DB 

strDT_INI = DateSerial(Year(Date), Month(Date), 1)
strDT_FIM = DateAdd("D", -1, DateAdd("M", 1, strDT_INI))

strTIPO		= GetParam("var_pr")	
strSITUACAO	= GetParam("var_situacao")

'Verifica se usuário tem direitos para manipular títulos a pagar ou receber
strDIR          = BuscaDireitosFromDB("modulo_FIN_TITULOS", Request.Cookies("VBOSS")("ID_USUARIO"))
BoolDIR_PAGAR   = VerificaDireito("|PAGAR|"  , strDIR , False)
BoolDIR_RECEBER = VerificaDireito("|RECEBER|", strDIR , False)

'Se não possui os direitos específicos de PAGAR ou RECEBER consira que tem os dois. 
'Para não precisar mexer naqueles que precisam dos dois direitos.
If ((BoolDIR_PAGAR = False) and (BoolDIR_RECEBER = False)) Then
	BoolDIR_PAGAR = True
	BoolDIR_RECEBER = True
End If

'Modifica o parâmetro recebido se o usuário só tiver direito de PAGAR ou RECEBER
If ((BoolDIR_PAGAR = True) and (BoolDIR_RECEBER = False))Then
  strTIPO = "PAGAR"
End If 

If ((BoolDIR_PAGAR = False) and (BoolDIR_RECEBER = True))Then
	strTIPO = "RECEBER"
End If 

%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script type="text/javascript" language="JavaScript">
function ExecAcao(pr_form, pr_input){
	var form = eval('document.' + pr_form + '.' + pr_input);
	if (form.value=='PG') { parent.frames["vbMainFrame"].document.location.href = "Insert.asp?var_tipo=PG"; }
	if (form.value=='RC') { parent.frames["vbMainFrame"].document.location.href = "Insert.asp?var_tipo=RC"; }
	form.value='';
}

var x=0;
function BuscaEntidade(valor) {
	x=x+1;
	if (valor!='')
		AbreJanelaPAGE (
			'BuscaPorEntidade.asp' 		+
			'?var_form=form_principal' 	+
			'&var_input=var_codigo' 	+ 
			'&var_input_tipo=var_tipo' +
			'&var_tipo=' + document.form_principal.var_entidade.value+
			'&var_vezes='+ x, 
			'640', 
			'390'
		);
	document.form_principal.var_tipo.value='';
	document.form_principal.var_codigo.value='';	
}
</script>
<script type="text/javascript" language="javascript" src="../_scripts/checkbox.js"></script>
</head>
<body onLoad="javascript:init();document.form_principal.submit();">
<table class="top_table" style="width:100%; height:58px; border:0px; margin:0px; padding:0px; vertical-align:top; border-collapse:collapse; ">
<tr> 
 	<td width="1%" class="top_menu" style="background-image:url(../img/Menu_TopBgLeft.jpg); background-repeat:repeat-x; vertical-align:top; padding:10px 0px 0px 10px;  border-collapse:collapse;">
		<b>Títulos</b>
		<%	'Monta o combo de inserir PAGAR ou RECEBER de acordo com direitos		
		    strAUX = ""
			If(BoolDIR_PAGAR = True) Then 
				strAUX = "PG:INSERIR PAGAR" 
			End If	
			If(BoolDIR_RECEBER = True) Then
				If (strAUX <> "") Then 
					strAUX = strAUX & ";" 
				End If	
				strAUX = strAUX & "RC:INSERIR RECEBER"
			End If			
			Response.Write montaMenuCombo("form_acoes","var_nome","width:100px","ExecAcao(this.form.name,this.name);",strAUX)
		%>
	</td>
	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); background-repeat:repeat-x; vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); background-repeat:repeat-x; vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
		<div class="form_line" style="padding-top:28px;">
			<form name="form_principal" id="form_principal" method="get" action="<%=CFG_MAIN_GRID%>" target="vbMainFrame">
				<div class="form_label_nowidth">Cód.</div><input name="var_cod_tit" id="var_cod_tit" type="text" style="width:40px;" class="edtext" maxlength="10" value=""> 
				<div class="form_label_nowidth">Contrato:</div><input name="var_cod_contrato" id="var_cod_contrato" type="text" style="width:40px;" class="edtext" maxlength="10" value=""> 
				<div class="form_label_nowidth">Vcto:</div><%=InputDate("var_dt_ini","edtext",PrepData(strDT_INI,true,false),false)%>		
				<div class="form_label_nowidth"> - </div><%=InputDate("var_dt_fim","edtext",PrepData(strDT_FIM,true,false),false)%>			
				<select name="var_pr" class="edtext_combo" size="1" style="width:60px;" title="Pagar ou Receber">
				 	<%'Monta combo de filtro PAGAR/RECEBER de acordo com direitos
					  If ((BoolDIR_PAGAR = True) and (BoolDIR_RECEBER = True)) Then %>
					<option value="" <% If strTIPO="" Then Response.Write("selected")%>>[Tipo]</option>
					<%End If
					  If (BoolDIR_PAGAR = True) Then %>
					<option value="PAGAR" <% If strTIPO="PAGAR" Then Response.Write("selected")%>>Pagar</option>
					<%End If
					  If (BoolDIR_RECEBER = True) Then %>					
					<option value="RECEBER" <% If strTIPO="RECEBER" Then Response.Write("selected")%>>Receber</option>
					<%End If%>
				</select>
				<select name="var_situacao" class="edtext_combo" size="1" style="width:80px;" title="Situação">
					<option value="" <%if strSITUACAO="" then Response.Write("selected")%>>[Situação]</option>
					<option value="ABERTA"       <%if strSITUACAO="ABERTA"       then Response.Write("selected")%>>Aberta</option>
					<option value="LCTO_PARCIAL" <%if strSITUACAO="LCTO_PARCIAL" then Response.Write("selected")%>>Parcial</option>
					<option value="LCTO_TOTAL"   <%if strSITUACAO="LCTO_TOTAL"   then Response.Write("selected")%>>Quitada</option>
					<option value="CANCELADA"    <%if strSITUACAO="CANCELADA"    then Response.Write("selected")%>>Cancelada</option>											
					<option value="_ABERTA"      <%if strSITUACAO="_ABERTA"      then Response.Write("selected")%>>Não Aberta</option>											
					<option value="_LCTO_TOTAL"  <%if strSITUACAO="_LCTO_TOTAL"  then Response.Write("selected")%>>Não Quitada</option>																																	
				</select>
				<select name="var_fin_conta_prevista" class="edtext_combo" style="width:105px" title="Conta Banco (Prevista)">
					<option value="" selected>[Prevista]</option>
					<%
					strSQL =          " SELECT COD_CONTA, NOME FROM FIN_CONTA "
					strSQL = strSQL & " WHERE DT_INATIVO IS NULL "
					strSQL = strSQL & " ORDER BY NOME "
					
					Set objRS = objConn.Execute(strSQL)
					Do While Not objRS.Eof
						Response.Write("<option value='" & GetValue(objRS, "COD_CONTA") & "'>" & GetValue(objRS, "NOME") & "</option>")
						objRS.MoveNext
					Loop
					FechaRecordSet objRS
					%>
				</select>
				<!-- 
				<select name="var_fin_conta_realizada" class="edtext_combo" style="width:105px" title="Conta Banco (Realizada)">
					<option value="" selected>[Lctos]</option>
					<%
					'strSQL =          " SELECT COD_CONTA, NOME FROM FIN_CONTA "
					'strSQL = strSQL & " WHERE DT_INATIVO IS NULL "
					'strSQL = strSQL & " ORDER BY  NOME "
					
					'Set objRS = objConn.Execute(strSQL)
					'Do While Not objRS.Eof
					'	Response.Write("<option value='" & GetValue(objRS, "COD_CONTA") & "'>" & GetValue(objRS, "NOME") & "</option>")
					'	objRS.MoveNext
					'Loop
					'FechaRecordSet objRS
					%>
				</select>
				//-->
				<input name="var_codigo" id="var_codigo" type="hidden" value=""> 
				<input name="var_tipo" id="var_tipo" type="hidden" value=""> 
				<select name="var_centro_custo"  class="edtext_combo" size="1" title="Centro de Custo" style="width:130px;">
					<option value="" selected>[Centro de Custo]</option>										
					<% MontaCombo "INT", "SELECT COD_CENTRO_CUSTO, NOME, DESCRICAO FROM FIN_CENTRO_CUSTO WHERE DT_INATIVO IS NULL ORDER BY ORDEM ", "COD_CENTRO_CUSTO", "NOME", "" %>
				</select>
				<select name="var_entidade"  class="edtext_combo" size="1" title="Entidade" onChange="JavaScript:BuscaEntidade(this.value);">
					<option value="" selected>[Entidade]</option>										
					<% MontaCombo "STR", "SELECT TIPO, DESCRICAO FROM SYS_ENTIDADE ORDER BY DESCRICAO ", "TIPO", "DESCRICAO", "" %>
				</select>
				<!-- Para diminuir ou eliminar a ocorrência de cahce passamso um parâmetro DUMMY com um número diferente 
				a cada execução. Isso força o navegador a interpretar como um request diferente a página,m evitando cache - by Aless 06/10/10 -->
				<input type="hidden" id="rndrequest" name="rndrequest" value="">
				<div onClick="document.form_principal.rndrequest.value=(new Date()).valueOf(); document.form_principal.submit();" class="btsearch"></div>
			</form>
	   </div>
	</td>
</tr>
</table>
</body>
</html>
<%
FechaDBConn objConn
%>