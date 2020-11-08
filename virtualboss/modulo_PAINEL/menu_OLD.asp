<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<%
 Dim objConn, strSQL, objRS, auxCont
 Dim strROTULOS, strFLAGS, strIDs
 Dim strGrpUser

 strGrpUser = ucase(Request.Cookies("VBOSS")("GRUPO_USUARIO"))

 AbreDBConn objConn, CFG_DB

 Public Function RecursiveSubMenus(pr_codmenu, prgrpusr)
 Dim objRSLocal,LocalauxCont,LocalstrSQL
  
   LocalstrSQL =               " SELECT COD_MENU, ROTULO, LINK, IMG FROM SYS_MENU"
   LocalstrSQL = LocalstrSQL & " WHERE COD_MENU_PAI = " & pr_codmenu 
   LocalstrSQL = LocalstrSQL & "   AND (GRP_USER LIKE '' OR GRP_USER IS NULL OR GRP_USER LIKE '" & prgrpusr & "') "
   LocalstrSQL = LocalstrSQL & "   AND DT_INATIVO IS NULL "
   LocalstrSQL = LocalstrSQL & " ORDER BY ORDEM, ROTULO "

   'athDebug LocalstrSQL,true  
   Set objRSLocal = objConn.Execute(LocalstrSQL)
   LocalauxCont = 0
   While not objRSLocal.EOF
	  Response.Write("<li>" & vbnewline)
	  Response.Write("<div style='padding-left:5px; padding-right:5px;'>" & vbnewline)
	  Response.Write("	<img src='../img/" & GetValue(objRSLocal,"IMG") & "' align='absmiddle' border='0'>" & vbnewline)
	  Response.Write("	<a href='" & GetValue(objRSLocal,"LINK") & "' target='vbNucleo'>" & GetValue(objRSLocal,"ROTULO") & "</a>" & vbnewline)
	  Response.Write(" </div>" & vbnewline)
	  Response.Write("</li>" & vbnewline)
  
	  RecursiveSubMenus GetValue(objRSLocal,"COD_MENU"), prgrpusr
	  	  
	  objRSLocal.MoveNext
      LocalauxCont = LocalauxCont + 1
   Wend
   
   FechaRecordSet(objRSLocal) 
 End function 

%>
<html>
<head>
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript">

menucolapsed = true;
function swapwidth()
{
 if(menucolapsed)
  { parent.document.getElementById("frprincipal").cols="200,*"; }
 else
  {	parent.document.getElementById("frprincipal").cols="10,*"; }
 menucolapsed = !menucolapsed
}
</script>
<script language="javascript" src="../_scripts/menuleft.js"></script>
<script language="javascript" src="../_scripts/jquery-1.3.2.min.js"></script>
<script>
	$(document).ready(function(){
		
		$('div[name=menu_acord]').next().hide();
		$('div[name=menu_acord]').click(function(){
			$('div[name=menu_acord]').children('img').attr('src','../img/arrow_down.gif');
			if($(this).next().is(':visible')){
				$(this).next().hide();
				$('div[name=menu_acord]').next(':visible').hide();
			}else{
				$('div[name=menu_acord]').next(':visible').hide();
				$(this).next().show();
				$(this).children('img').attr('src','../img/arrow_up_over.gif');
			}
		});
		
		$('div[name=menu_acord]').hover(
			function () {
				$(this).children('span').css('color','#215DE6');
				if($(this).next(':visible').is(':visible')){
					$(this).children('img').attr('src','../img/arrow_up_over.gif');
				}else{
					$(this).children('img').attr('src','../img/arrow_down_over.gif');
				}
			}, 
			function () {
				$(this).children('span').css('color','#4482AD');
				if($(this).next(':visible').is(':visible')){
					$(this).children('img').attr('src','../img/arrow_up.gif');
				}else{
					$(this).children('img').attr('src','../img/arrow_down.gif');
				}
			}
		);
		
	});
</script>
</head>
<body style="background:#EDF2F6;">
<%
	strSQL =          " SELECT COD_MENU, ROTULO, LINK, IMG FROM SYS_MENU "
	strSQL = strSQL & "  WHERE COD_MENU_PAI <= 0 "
	strSQL = strSQL & "    AND (GRP_USER LIKE '' OR GRP_USER IS NULL OR GRP_USER LIKE '" & strGrpUser & "') "
	strSQL = strSQL & "    AND DT_INATIVO IS NULL "
	strSQL = strSQL & "  ORDER BY ORDEM, ROTULO "
	
	'athDebug strSQL, True
	
	Set objRS = objConn.Execute(strSQL)
	
	If Not ObjRS.EOF Then
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="background:#EDF2F6;">
  <tr><td><img id="vboss_butsplit" name="vboss_butsplit" onClick="swapwidth();" src="../img/ButSplit.jpg" style="cursor:pointer" border="0"></td></tr>
</table>
<div class='painel_menu_acord' style='border:0px solid #000000; width:185px; '>
<%
		While not ObjRS.EOF
			Response.Write("<div style='float:inherit; display:block; margin-bottom:5px; border:0px solid #000000; '>")
			Response.Write("  <div name='menu_acord' class='titulo_menu_acord'>")
			Response.Write("    <span>" & GetValue(ObjRS,"ROTULO") & "</span><img src='../img/arrow_down.gif'>")
			Response.Write("  </div>")
			Response.Write("  <ul class='conteudo_menu_acord' style='padding-top:5px; padding-bottom:5px;'>")
			                     RecursiveSubMenus GetValue(ObjRS,"COD_MENU"), strGrpUser
			Response.Write("  </ul>")
			Response.Write("</div>")
			
			ObjRS.MoveNext
		Wend
%>
</div>
<%
	Else
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="background:#EDF2F6;">
  <tr><td><img id="vboss_butsplit" name="vboss_butsplit" src="../img/ButSplitClean.jpg" style="cursor:pointer" border="0"></td></tr>
</table>
<%
	End If
	FechaRecordSet objRS
%>
</body>
</html>
