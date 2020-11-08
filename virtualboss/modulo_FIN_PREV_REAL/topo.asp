<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
Dim objConn, objRS, strSQL
Dim strNIVEL, strSUBNIVEL
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script type="text/javascript" language="JavaScript">
function Imprime(prValue) {
	if (prValue==1) {
	//	Precisa do focus() para imprimir o frame certo
		parent.vbMainFrame.focus();
		parent.vbMainFrame.print();
	}
}
</script>
<script type="text/javascript" language="javascript" src="../_scripts/checkbox.js"></script>
</head>
<body onLoad="javascript:init();document.form_principal.submit();">
<table width="100%" height="58" border="0" cellpadding="0" cellspacing="0">
	<tr> 
		<td width="100%" height="58" valign="top">
			<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					
					<td width="130" background="../img/Menu_TopBgLeft.jpg">
						<div style="padding-left:10px;padding-top:8px"><b>Previsto X Realizado</b></div>
						<div style="padding-left:10px;padding-top:6px;padding-right:5px;">
						    <form name="form_acoes" method="post" action=""> 
							<select name="selNome" class="edtext" style="width:85;" onChange="JavaScript:Imprime(this.value);">
								<option value="" selected></option>
								<option value="1">IMPRIMIR</option>
							</select>
							</form>
						</div>
					</td>
					
					<td width="30" valign="top"><img src="../img/Menu_TopImgCenter.jpg" height="58"></td>
					<td align="right" background="../img/Menu_TopBgRight.jpg">
						<div style="padding-right:5px;padding-top:26px">
							<table border="0" cellpadding="0" cellspacing="0">
							<form name="form_principal" id="form_principal" method="get" action="<%=CFG_MAIN_GRID%>" target="vbMainFrame">
								<tr>
									<td width="5">&nbsp;</td>																																			
									<td> 
										<select name="var_cod_prev_orca" class="edtext" style="width:230px;">
											<option value="">[Previsão Orçamentária]</option>
											<%=montaCombo("STR","SELECT COD_PREV_ORCA, DESCRICAO FROM FIN_PREV_ORCA","COD_PREV_ORCA","DESCRICAO","")%>
										</select>
									</td>								
									<td width="5">&nbsp;</td>																																			
									<td> 
										<select name="var_cod_plano_conta" class="edtext" style="width:125px;">
											<option value="">[Plano de Conta]</option>
											<%=montaCombo("STR","SELECT COD_PLANO_CONTA, NOME FROM FIN_PLANO_CONTA WHERE COD_PLANO_CONTA_PAI IS NULL AND DT_INATIVO IS NULL ORDER BY 2","COD_PLANO_CONTA","NOME","")%>
										</select>
									</td>
								</tr>
							</form>	
							</table>
						</div>								
					</td>	
					<td width="35" background="../img/Menu_TopBgRight.jpg" align="center" valign="middle">
						<div style="padding-top:27px;padding-right:10px;">
							<a href="javascript:document.form_principal.submit();"><img src="../img/bt_search_mini.gif" title="Atualizar consulta..."  border="0"></a>
						</div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</body>
</html>