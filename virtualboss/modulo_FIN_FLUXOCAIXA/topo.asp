<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
Dim objConn, objRS, strSQL, Cont, BoolDIR_PAGAR, BoolDIR_RECEBER, strDIR
Dim strVAR_CODIGO, strVAR_TIPO

AbreDBConn objConn, CFG_DB

'Verifica se usuário tem direitos para manipular títulos a pagar ou receber
strDIR          = BuscaDireitosFromDB("modulo_FIN_FLUXOCAIXA", Request.Cookies("VBOSS")("ID_USUARIO"))
BoolDIR_PAGAR   = VerificaDireito("|PAGAR|"  , strDIR , False)
BoolDIR_RECEBER = VerificaDireito("|RECEBER|", strDIR , False)

'Se não possui os direitos específicos de PAGAR ou RECEBER consira que tem os dois. 
'Para não precisar mexer naqueles que precisam dos dois direitos.
If ((BoolDIR_PAGAR = False) and (BoolDIR_RECEBER = False)) Then
	BoolDIR_PAGAR   = True
	BoolDIR_RECEBER = True
End If
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script type="text/javascript" language="JavaScript">
function BuscaEntidade(valor) {	
	if (valor!='')
		AbreJanelaPAGE (
			'BuscaPorEntidade.asp' 		+
			'?var_form=form_principal' 	+
			'&var_input=var_codigo' 	+ 
			'&var_input_tipo=var_tipo' +
			'&var_tipo=' + document.form_principal.var_entidade.value, 
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
 	<td width="1%" class="top_menu" nowrap="nowrap" style="background-image:url(../img/Menu_TopBgLeft.jpg); vertical-align:top; padding:10px 0px 0px 10px;  border-collapse:collapse;">
		<b>Fluxo de Caixa</b>
	</td>
	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
		<div class="form_line">
			<form name="form_principal" id="form_principal" method="get" action="<%=CFG_MAIN_GRID%>" target="vbMainFrame">
				<input type="hidden" name="var_codigo" id="var_codigo" value="<%=strVAR_CODIGO%>" onMouseOver=""> 
				<input type="hidden" name="var_tipo"   id="var_tipo"   value="<%=strVAR_TIPO%>"> 
				<select name="var_periodo" class="edtext_combo" size="1" style="width:160px;">
					<option value="ATE_HOJE">Até hoje</option>
					<option value="ATE_AMANHA">Até amanhã</option>                    
					<option value="ATE_7D" selected>Até os Próximos 7 dias</option>
					<option value="ATE_15D">Até os Próximos 15 dias</option>
					<option value="ATE_MES_ATUAL">Até o Final do Mês</option>
					<option value="ATE_MES_SEGUINTE">Até o Final do Próximo Mês</option>
					<option value="APENAS_NESTE_MES">Apenas neste Mês</option>
					<option value="TODOS">TODOS (por Entidade)</option>
				</select>
				
				<select name="var_pr" class="edtext_combo" size="1" style="width:60px">
				<%'Monta combo de filtro PAGAR/RECEBER de acordo com direitos
				  If ((BoolDIR_PAGAR = True) and (BoolDIR_RECEBER = True)) Then %>				
					<option value="0" selected>[tipo]</option>
				<%End If					
				  If (BoolDIR_PAGAR = True) Then %>				
					<option value="1">Pagar</option>
				<%End If
				  If (BoolDIR_RECEBER = True) Then %>										
					<option value="2">Receber</option>											
				<%End If%>									
				</select>
                
				<select name="var_nf_recibo" class="edtext_combo" size="1" style="width:120px">
					<option value="" selected>[nf/recibo]</option>		
					<option value="A_GERAR">NF/Recibo a Gerar</option>						
					<option value="GERADO">NF/Recibo Gerado</option>																	
				</select>                
				
				<select name="var_fin_conta" class="edtext_combo" style="width:120px">
					<option value="" selected>[conta]</option>
					<%
					'Se contas pertencem a apenas um grupo financeiro não precisa 
					'fazer combo com grupo de opções
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
				<select name="var_entidade"  class="edtext_combo" size="1" onChange="JavaScript:BuscaEntidade(this.value);">
					<option value="" selected>[entidade]</option>										
					<%=MontaCombo("STR","SELECT TIPO, DESCRICAO FROM SYS_ENTIDADE ORDER BY DESCRICAO ","TIPO","DESCRICAO","")%>
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