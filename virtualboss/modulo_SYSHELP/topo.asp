<!--#include file="../_database/athdbConn.asp"--> <!--ATENÇÃO: language, option explicit, etc... estão no athDBConn-->
<!--#include file="../_database/athUtils.asp"-->

<%
Dim StrMENUOld, StrMENUNew, objRS, strSQL, objConn, strIDApp, strLink

AbreDBConn objConn, CFG_DB

%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script type="text/javascript" language="JavaScript">
function ExecAcao(pr_form, pr_input) {        
	var form = eval('document.' + pr_form + '.' + pr_input);  	
	if(form.value != ''){
	  parent.frames["vbMainFrame"].document.location.href = form.value;
	  if (pr_input == 'var_edtext_combohist'){document.getElementsByName("var_edtext_combohelp")[0].value='';}
	  else {document.getElementsByName("var_edtext_combohist")[0].value='';}	  
	}else {parent.document.location.href = '../modulo_SYSHELP/default.htm'}	
	form = '';
}
</script>
</head>
<body>
<table class="top_table" style="width:100%; height:58px; border:0px; margin:0px; padding:0px; vertical-align:top; border-collapse:collapse; ">
<tr> 
 	<td width="1%" class="top_menu" style="background-image:url(../img/Menu_TopBgLeft.jpg); vertical-align:top; padding:10px 0px 0px 10px;  border-collapse:collapse;" nowrap="nowrap">
	 <b>VBOSS v12</b>	   
		<%=montaMenuCombo("form_acoes","var_edtext_combohist","width:100px","ExecAcao(this.form.name,this.name);","verHistory.htm:Version History")%>
	</td>
	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
		<div class="form_line">
			<form method="get" name="form_principal" id="form_principal" action="<%=CFG_MAIN_GRID%>" target="vbMainFrame">
			   <select name="var_edtext_combohelp" class="edtext_combo" style="width:150px" id="edtext_combohelp">
				  <option value='' selected="selected">[módulo]</option>
					<%
					'Separa as aplicações por menu.					
					strSQL = "SELECT (SELECT SM2.ROTULO FROM SYS_MENU SM2 WHERE SM2.COD_MENU = SM1.COD_MENU_PAI)AS ROTULO_MENU_PAI, "& _
							 "REPLACE(LOWER(SM1.LINK),'default','Help') AS LINK, "& _		
							 "SM1.LINK MODULO "& _
							 "FROM SYS_MENU SM1 "& _
							 "WHERE SM1.COD_MENU_PAI IS NOT NULL "& _
							 "AND SM1.LINK IS NOT NULL "& _
							 "AND SM1.GRP_USER IS NULL "& _
							 "AND ((POSITION('DEFAULT' IN UCASE(SM1.LINK))> 0) OR "& _
							 "(POSITION('RELAT_ASLW' IN UCASE(SM1.LINK))> 0)) "& _        
							 "ORDER BY SM1.ORDEM "                           					
					Set objRS = objConn.Execute(strSQL)						 							
					StrMENUOld = ""
					StrMENUNew = ""
					Do While Not objRS.Eof
					  strIDApp   = GetValue(objRS,"MODULO")
                      'Pega o link do módulo sem o início (../)					  
					  strIDApp   = mid(strIDApp, 4, len(strIDApp))
					  StrMENUNew = GetValue(objRS,"ROTULO_MENU_PAI")							
					  strLink    = GetValue(objRS,"LINK")			
					  'Retira do link apenas o nome do módulo
					  if InStr(strIDAPP,"/") > 0 Then
						strIDApp = mid(strIDApp,1,InStr(strIDApp, "/") -1)			  							 
					  End If	
					  if StrMENUOld <> StrMENUNew Then
					   	 if StrMENUOld <> "" then
					      Response.write("</optgroup>")
					     End If  
					 	 Response.write("<optgroup label = '" & StrMENUNew & "'>")
						 StrMENUOld = StrMENUNew						 
					  End If		  
					  Response.write("<option value= '" & strLink & "'>" & strIDApp & "</option>")	  								  			                                           
					  objRS.MoveNext
					Loop
					FechaRecordSet objRS
					FechaDBConn objConn		
					%>					  
		       </select>
				<!-- Para diminuir ou eliminar a ocorrência de cache passamso um parâmetro DUMMY com um número diferente 
				a cada execução. Isso força o navegador a interpretar como um request diferente a página, evitando cache - by Aless 06/10/10 -->
				<input type="hidden" id="rndrequest" name="rndrequest" value="">
				<div onClick="document.form_principal.rndrequest.value=(new Date()).valueOf(); ExecAcao(document.form_principal.id, document.form_principal.edtext_combohelp.id);" class="btsearch"></div>
			</form>
		</div>
	</td>
</tr>
</table>
</body>
</html>
