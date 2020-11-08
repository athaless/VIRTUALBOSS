<%
auxSTR = "" 

strSQL = "         SELECT DISTINCT tl.ID_ULT_EXECUTOR, COUNT(*) CTOTAL " 
strSQL = strSQL & "  FROM tl_todolist tl, usuario us " 
strSQL = strSQL & " WHERE tl.SITUACAO LIKE 'EXECUTANDO' " 
strSQL = strSQL & "   AND us.DT_INATIVO IS NULL " 
strSQL = strSQL & "   AND us.GRP_USER <> 'SU' " 
strSQL = strSQL & "   AND us.TIPO = '" & Request.Cookies("VBOSS")("ENTIDADE_TIPO") & "'" 
strSQL = strSQL & "   AND tl.ID_ULT_EXECUTOR = us.ID_USUARIO " 
strSQL = strSQL & " GROUP BY 1 " 
strSQL = strSQL & " ORDER BY 2 DESC " 
strSQL = strSQL & " LIMIT 10 "  'LIMIT 16  corresponde... "&chs=160x300"

AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
'set objRS = objConn.Execute(strSQL) 
if not objRS.eof and not objRS.bof then 

 'if Request.Cookies("VBOSS")("FACEBOOK_USERNAME")="" then 
 if True Then
%>
<table width="170" align="center" cellpadding="0" cellspacing="0" border="0" style="border:1px solid <%=strBGCOLOR1%>; margin-bottom:10px;">
	<tr>
		<td width="170" bgcolor="<%=strBGCOLOR2%>" class="corpo_texto_mdo" valign="middle" align="left" height="22" style="border-bottom:1px solid <%=strBGCOLOR1%>">
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td align="left" width="1%" nowrap><div style="padding-left:3px; padding-right:3px;"><b>Tarefas</b>&nbsp;(em execução)</div></td>
				<td width="99%" style="text-align:right"></td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td width="170" align="center" valign="top">
			<table width="170" cellpadding="0" cellspacing="2" border="0">
				<tr style='cursor:pointer;' valign='top'>
					<!-- td width='040px' height='30px' style='background:URL(<%=auxSTR%>); background-repeat:no-repeat; background-position:center;'></td>
					<td width="124px" //-->
					<td>
					
					<%
					response.Write("<img src='http://chart.apis.google.com/chart?cht=p")
					response.Write("&chs=160x190")
					response.Write("&chd=t:")
					auxSTR = "PRIMEIRO"				
					While (not ObjRS.BOF) AND (not ObjRS.EOF)
					    if (auxSTR="") then response.Write(",") end if
						auxSTR = ""
						response.Write(GetValue(objRS,"CTOTAL"))
						ObjRS.MoveNext
					WEnd

					ObjRS.MoveFirst
					auxSTR = "PRIMEIRO"				
					response.Write("&chdl=") 'response.Write("&chl=")
					While (not ObjRS.BOF) AND (not ObjRS.EOF)
					    if (auxSTR="") then response.Write("|") end if
						auxSTR = ""
						response.Write(GetValue(objRS,"ID_ULT_EXECUTOR") & " (" & GetValue(objRS,"CTOTAL") & ")")
						ObjRS.MoveNext
					WEnd
					response.Write("' />")
					%>
					<!-- 
					 EXEMPLO --------------------------------------------------------------------------------------------
					 Dica de uso no SITE:
					 http://www.toprated.com.br/crie-graficos-de-maneira-rapida-e-facil-com-o-google-chart-tools-parte-1
					 ----------------------------------------------------------------------------------------------------
				 	 <img src="http://chart.apis.google.com/chart?cht=p&chd=t:45,20,20,15&chs=160x110" />
					 <img src="http://chart.apis.google.com/chart?cht=p&chd=t:45,20,20,15&chs=160x110&chdl=Clevers|Aless|Gabriel|Lumertz" />
					//--> 
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<% else %>	
<%
 dim urlFACE 
 
 urlFACE = "./_IncludePanel_FeedFacebook.asp"
%>	  
	  
<script type="text/javascript" DEFER="DEFER">
var objAJAX;

onload = function LoadAjax(){
		  	ajaxCreate2();	
		 }


function ajaxCreate2() { 
	try	{ objAJAX=new XMLHttpRequest(); } 
	catch (e) 
	{ 
	  try  { objAJAX=new ActiveXObject("Msxml2.XMLHTTP"); }
	  catch (e) 
	  { 
        try	{ objAJAX=new ActiveXObject("Microsoft.XMLHTTP"); }
        catch (e)
	    { 
	     alert("AJAX is not suported!"); 
	    } 
	  } 
	}
  objAJAX.open("GET", "<%=urlFACE%>", true);
  objAJAX.onreadystatechange = athHandleAjaxResponse2;
  objAJAX.send(null);
}


function athHandleAjaxResponse2()
{
  if (objAJAX.readyState == 4) 
   { 
	 if ( (objAJAX.status == 200) || (objAJAX.status == 400) )
	 {
	   document.getElementById('ajaxContent2').innerHTML = objAJAX.responseText; 
	 } 
	 else 
	 { document.getElementById('ajaxContent2').innerHTML = 'Erro ao carregar Feed do Facebook.';} 
   } 
}

</script>	

<table width="170" align="center" cellpadding="0" cellspacing="0" border="0" style="border:1px solid <%=strBGCOLOR1%>; margin-bottom:10px;">
	<tr>
		<td class="corpo_texto_mdo" valign="middle" align="left">
			<table width="170" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td width="170" height="22" bgcolor="<%=strBGCOLOR2%>" style="border-bottom:1px solid <%=strBGCOLOR1%>;"><div style="padding-left:3px; padding-right:3px;"><b><span style="cursor:pointer;" onclick="javascript:ajaxCreate2();">Seu Mural do Facebook</span></b></div></td>
				</tr>	
				<tr>
					<td>
						<div id="ajaxContent2" style="width:180;height:250px;overflow:scroll;display:block;text-align:justify;">	
							<img style="margin:50% 0% 0% 25%;" src="../img/anim_preload_frame.gif">
						</div>  				
					</td>			
				</tr>
			</table>	
		</td>
	</tr>
</table>	



    <!-- LIKE BOX ------------------------------------------------------------
	Aponta para página da PROEVENTO no FBOOK - www.facebook.com/GrupoProevento
	-------------------------------------------------------------------------- //-->
	<!--
	
		<div id="fb-root"></div>
		<script>(function(d, s, id) {
		  var js, fjs = d.getElementsByTagName(s)[0];
		  if (d.getElementById(id)) return;
		  js = d.createElement(s); js.id = id;
		  js.src = "//connect.facebook.net/pt_BR/all.js#xfbml=1";
		  fjs.parentNode.insertBefore(js, fjs);
		}(document, 'script', 'facebook-jssdk'));</script>
		<div class="fb-like-box" data-href="https://www.facebook.com/grupoproevento" 
			 data-width="170" 
			 data-show-faces="true" 
			 data-stream="true" 
			 data-border-color="#ffffff" 
			 data-header="false"></div>
		 
	-->	 
<%
  end if	
end if 
FechaRecordSet objRS 
%>