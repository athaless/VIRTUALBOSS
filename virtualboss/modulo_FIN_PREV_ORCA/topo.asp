<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script type="text/javascript" language="JavaScript">
function ExecAcao(){
var form;
	form = document.form_acoes;
	if (form.selNome!='')	
		window.open("Insert.asp","","width=500, height=350, left=30, top=30, scrollbars=1, status=0");
	form.selNome.value = '';
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
					
					<td width="140" background="../img/Menu_TopBgLeft.jpg">
						<div style="padding-left:10px;padding-top:8px"><b>Prev. Orçamentária</b></div>
						<div style="padding-left:10px;padding-top:6px;padding-right:5px;">
						    <form name="form_acoes" method="post" action=""> 
							<select name="selNome" class="edtext" style="width:120px;" onChange="ExecAcao();">
								<option value="" selected></option>
								<option value="INSERIR">INSERIR PREVISÃO</option>
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
									<!--td width="5">&nbsp;</td>     						
									<td height="20" bgcolor="#FFFFFF" align="center" valign="middle"> 
										<select name="var_mes" class="edtext" style="width:65px;" >
											<option value="">[mês]</option>
											<%'=montaComboMes(null)%>
										</select>
									</td-->
									<td width="5">Previsão:&nbsp;</td>																							
									<td height="20" bgcolor="#FFFFFF" align="center" valign="middle">
										<select name="var_situacao" class="edtext">
											<option value="VIGENTES" selected>Vigente</option>
											<option value="_VIGENTES">Não Vigente</option>
											<option value="">Todos</option>																						
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