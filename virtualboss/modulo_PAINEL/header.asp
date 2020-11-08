<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
<head>
<title></title>
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script type="text/javascript" language="javascript">
var tid = null;
function countdown(sec) {
 //document.getElementById( 'tel' ).firstChild.nodeValue = 'in ' + sec + ' second' + ( sec===1 ? '' : 's' );
 document.getElementById( 'tel' ).firstChild.nodeValue = sec + ( sec===1 ? '' : 's' );

 if( sec ) {
  tid = window.setTimeout( 'countdown(' + ( --sec ) + ');', 1000 );
 } else {
   stop();
   //ALARM ... if( document.getElementById( 'alarm' ).checked ) {
   document.body.style.backgroundColor = 'red';
   window.alert( 'Sua sessão expirou!' );
   ///}
 }
}

function stop() { window.clearTimeout( tid ); }
</script>
</head>
<body marginheight="0" marginwidth="0" leftmargin="0" topmargin="0" bottommargin="0" rightmargin="0"><!-- onLoad="countdown(2880)"-->
<table width="100%" height="57" cellspacing="0" cellpadding="0" border="0" background="../img/BgInterTop.jpg">
	<tr>
	  <td width="1%" align="center"><a href="nucleo.htm" target="vbNucleo" style='cursor:pointer; text-decoration:none; border:none; outline:none;'><img src="../img/LogoVBoss.gif" width="229" height="37" hspace="30" border="0"></a></td>
	  <td width="99%" align="right" valign="top">
		<table width="100%" height="57" cellpadding="0" cellspacing="0" border="0" background="../img/BgInterTop.jpg">
		  <tr>
			<%
			  Dim lcTdWidth
			  lcTdWidth = "99%"
			  If Request.Cookies("VBOSS")("FACEBOOK_USERNAME") <> "" Then
			    Response.Write "<td width='98%' height='21px' align='right' style='padding-right:5px; padding-bottom:18px;'><a border='0' href='http://www.facebook.com' target='_blank'><img style=""border:0px;border-width: 0px;""cursor:pointer;"" src='../img/butlogin_fb.png' align='right' height='21px' style='vertical-align:top; line-height:0px;' alt='Login executado via Facebook' title='Login executado via Facebook' ></a>&nbsp&nbsp</td>"
				lcTdWidth = "1%"
			  End If
			 %>		              
            <td align="right">
            <%'Teste simples de uso da TTS.Google  - by Aless
			 Dim tts_Nome, tts_Saudacao, tts_Frase
			 tts_Nome = Request.Cookies("VBOSS")("NOME_USUARIO") & " "
			 tts_Nome = mid(tts_Nome,1,InStr(tts_Nome," "))
			 
			 hora = hour(now)
			 if hora>=0  and hora<12 then tts_Saudacao = "bom dia, "
			 if hora>=12 and hora<18 then tts_Saudacao = "boa tarde, "
			 if hora>=18 and hora<24 then tts_Saudacao = "boa noite, "
			 tts_Frase = tts_Saudacao & "%20" & tts_Nome
			%>
             <!-- audio src="http://translate.google.com/translate_tts?tl=pt&q=<%=tts_Frase%>" controls autoplay //-->
             <iframe name="vboss_ttsframe" id="vboss_ttsframe" src="http://translate.google.com/translate_tts?tl=pt&q=<%=tts_Frase%>" width="2" height="2" frameborder="0" ></iframe>
            </td>
            <td width="<%=lcTdWidth%>" align="right" valign="top" style="text-align:right; padding-right:5px;" nowrap>
			  <%=Request.Cookies("VBOSS")("GRUPO_USUARIO")%><!--&nbsp;<small>(<span id='tel' alt='Session/Cookie' title='Session/Cookie'>..</span>)</small>-->
			  <br><b><%=Request.Cookies("VBOSS")("NOME_USUARIO")%></b>
			  <br><%="DB " & Replace(Request.Cookies("VBOSS")("DBNAME"), "vboss_", "") %>			  			 
			</td>
			<td width="1%" align="right" valign="top"><a href="../logout.asp" target="vbfr_pcenter" alt="Sair/Logout" title="Sair/Logout"><img src="../img/IcoLogout.gif" border="0"></a></td>
		   </tr>
		</table>
	  </td>
	</tr>
</table>
</body>
</html>