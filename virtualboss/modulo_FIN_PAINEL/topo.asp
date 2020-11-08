<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script type="text/javascript" language="javascript" src="../_scripts/checkbox.js"></script>
</head>
<body onLoad="javascript:init();document.form_principal.submit();">
<table width="100%" height="58" border="0" cellpadding="0" cellspacing="0">
	<tr> 
		<td width="100%" height="58" valign="top">
			<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="120" background="../img/Menu_TopBgLeft.jpg">
						<div style="padding-left:10px;padding-top:8px"><b>Painel Financeiro</b></div>
						<div style="padding-left:10px;padding-top:6px;padding-right:5px;"></div>
					</td>
					<td width="30" valign="top"><img src="../img/Menu_TopImgCenter.jpg" height="58"></td>
					<td align="right" background="../img/Menu_TopBgRight.jpg">
						<div style="padding-right:5px;padding-top:26px">
							<!-- espaço para tabela com formulário -->
						</div>								
					</td>	
					<td width="35" background="../img/Menu_TopBgRight.jpg" align="center" valign="middle">
						<div style="padding-top:27px;padding-right:10px;">
							<!--<a href="javascript:document.form_principal.submit();"><img src="../img/bt_search_mini.gif" alt="Atualizar consulta..."  border="0"></a>-->
						</div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<form name="form_principal" id="form_principal" method="get" action="main.asp" target="vbMainFrame">
</form>
</body>
</html>