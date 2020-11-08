<!--#include file="_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="_database/athUtils.asp"-->
<!--#include file="_scripts/scripts.js"-->
<%
 CONST MAPA_WIDTH = 240
 CONST GRIP_WIDTH = 10
 CONST HEADER_HEIGHT = 82
 CONST FOOTER_HEIGHT = 50

 Dim objConn, strSQL, objRS
 Dim strUSER_ID 'auxCont, auxSTR, 
 
 strUSER_ID = LCase(Request.Cookies("VBOSS")("ID_USUARIO"))

 AbreDBConn objConn, CFG_DB
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link rel="stylesheet" href="_css/menupurecss.css" type="text/css" media="screen" />
<title>vBOSS</title>
<style>
 html  { width:100%; height:100%; }
 body  { width:100%; height:100%;
 		 margin:0px; padding:0px; 
 		 background-color:#FFFFFF; /* background:url(__bgfake.jpg); background-repeat:no-repeat; overflow:hidden; */ 
		 overflow:hidden; 
		 /*
		 min-width:1024px;         / * suppose you want minimun width of 1000px * /
		 width: auto !important;  / * Firefox will set width as auto  * /
		 */
 }

 #css_header  { position:fixed; top:0; left:0;/* Fixa o MENU paqra não rolar com a scroll */
				height:<%=HEADER_HEIGHT%>px; min-height:<%=HEADER_HEIGHT%>px; /* Altura do header 82px */
				width: auto; 
				min-width: 100%; /* Ocupar toda largura da página */
				background:url(img/menupurecss_bgsearch.jpg);  /*bg LOGO/Procurar */
				background-repeat:no-repeat;
				background-color:#FFA500;
 				border:0px solid #00FF00;
				vertical-align:top;
				display:inline-block;
				margin:0px; 
				padding:0px;
				z-index: 9998;
 }

 /* --------------------------------------------- */
 /* Para o IE */
 * html #css_main { height:100%; }
 /* --------------------------------------------- */
 
 #LayerResultSearchMX {
	position:absolute;	
	width:260px; height:220px;
	left:55px; top:70px;
	margin-top:0px; padding:5px;
	display:none;
	background:#FFFFFF;
	border-bottom:1px solid #8B8B89; 
	overflow:hidden;
	z-index: 9999;
	
	
	box-shadow: 3px 3px 3px #888888;
	-webkit-border-radius: 3px;
	-moz-border-radius: 3px;
	border-radius:10px;
	
 }

 a:link, a:visited	 { text-decoration: none; color:#999999; }
 a:hover			 { text-decoration: none; color:#333333; }
 a:active			 { text-decoration: none; }
</style>
<script type="text/javascript">
 function MyResizeDivs() {
 
  if (document.body.clientWidth<800) {
  	document.getElementById("css_header").style.display		= 'none';
  	document.getElementById("tbl_mapa").style.display		= 'none';
  	document.getElementById("tbl_grip").style.display		= 'none';
  	document.getElementById("tbl_content").style.display	= 'none';
  	document.getElementById("tbl_footer").style.display		= 'none';
  } else {
  	document.getElementById("css_header").style.display		= 'block';
  	//document.getElementById("tbl_mapa").style.display		= 'block';
  	document.getElementById("tbl_grip").style.display		= 'block';
  	document.getElementById("tbl_content").style.display	= 'block';
  	document.getElementById("tbl_footer").style.display		= 'block';
  }
  // document.body.clientHeight
 
  document.getElementById("tbl_grip").style.width		= "<%=GRIP_WIDTH%>px";
  document.getElementById("tbl_grip").style.height		= (document.body.clientHeight - <%=HEADER_HEIGHT+FOOTER_HEIGHT%>) + "px";
  document.getElementById("tbl_content").style.height	= (document.body.clientHeight - <%=HEADER_HEIGHT+FOOTER_HEIGHT%>) + "px";
  document.getElementById("tbl_footer").style.width		= document.body.clientWidth + "px";
  document.getElementById("tbl_footer").style.height	= "<%=FOOTER_HEIGHT%>px";
  if (document.getElementById('tbl_mapa').style.display=='none') {
	  document.getElementById('tbl_grip').style.left		= '0px';
	  document.getElementById('tbl_content').style.left		= '<%=GRIP_WIDTH%>px';
	  document.getElementById('tbl_content').style.width	= (document.body.clientWidth - <%=GRIP_WIDTH%>) + 'px';
	  
  } else {
    document.getElementById("tbl_mapa").style.width		= "<%=MAPA_WIDTH%>px";
    document.getElementById("tbl_mapa").style.height	= (document.body.clientHeight - <%=HEADER_HEIGHT+FOOTER_HEIGHT%>) + "px";
  
	document.getElementById('tbl_grip').style.left		= '<%=MAPA_WIDTH%>px';
	document.getElementById('tbl_content').style.left	= '<%=MAPA_WIDTH+GRIP_WIDTH%>px';
	document.getElementById('tbl_content').style.width	= (document.body.clientWidth - <%=MAPA_WIDTH+GRIP_WIDTH%>) + 'px';
  }
 } 
</script>
</head>
<body onResize="MyResizeDivs();" onLoad="MyResizeDivs();">
<div id="LayerResultSearchMX">
 <!-- Resultado da pesquisa JScript no MENU vai aqui //-->
</div>

<!-- INI: HEADER --------------------------------------------------------------------------------------------- //-->
<div id="css_header">
	<div style="width:250px; height:82px; float:left; display:inline-block;
				background:url(img/menupurecss_bgsearch.jpg); 
				background-repeat:no-repeat;
				vertical-align:top; 
				border:0px; 
				margin:0px; 
				padding:0px;"> 
				 <form>
				   <input type="text" value="O que procura?" maxlength="20" style="margin-top:33px; margin-left:98px; padding-left:3px; width:108px; border:0px;" 
						  onFocus="if(this.value=='O que procura?') { this.value=''; }" 
						  onBlur="if(this.value=='') { this.value='O que procura?';  document.getElementById('LayerResultSearchMX').style.display='none'; }"
						  onKeyUp="if(this.value.length>1) 
						  			{ document.getElementById('LayerResultSearchMX').style.display='block'; 
									  SearchInMenuMX(this.value);
									} 
								  else 
								  	{ document.getElementById('LayerResultSearchMX').style.display='none'; }"
						  autocomplet="off" />
				 </form> 
	</div>
	<div style="width:99%;"> 
		<!--#include file="_IncludeMenuMXCSS.asp"-->
	</div>
</div>
<!-- FIM: HEADER --------------------------------------------------------------------------------------------- //-->


<!-- INI: FULCONTENT ----------------------------------------------------------------------------------------- //-->
<div id="tbl_mapa" style="position:absolute; left:0px; top:<%=HEADER_HEIGHT%>px; background-color:#888888; display:none; margin:0px; padding:0px;">
	<!-- iframe id="pstudio_ifrmmapa" width="100%" height="100%" frameborder="0" scrolling="auto" src="menu_vboss.asp"></iframe //-->
</div>
<div id="tbl_grip" style="position:absolute; left:<%=MAPA_WIDTH%>px; top:<%=HEADER_HEIGHT%>px; background-color:#F0F0F0; padding-top:12%; vertical-align:middle; text-align:center; overflow:hidden;">
	<img src="img/menupurecss_grip.png" style="border:0; cursor:pointer;" 
		 onClick="if (document.getElementById('tbl_mapa').style.display=='block') {
					document.getElementById('tbl_mapa').style.display	= 'none'; 
					document.getElementById('tbl_grip').style.left		= '0px';
					document.getElementById('tbl_content').style.left	= '<%=GRIP_WIDTH%>px';
					document.getElementById('tbl_content').style.width	= (document.body.clientWidth - <%=GRIP_WIDTH%>) + 'px';
				  } else {
					document.getElementById('tbl_mapa').style.display	= 'block'; 
					document.getElementById('tbl_grip').style.left		= '<%=MAPA_WIDTH%>px';
					document.getElementById('tbl_content').style.left	= '<%=MAPA_WIDTH+GRIP_WIDTH%>px';
					document.getElementById('tbl_content').style.width	= (document.body.clientWidth - <%=MAPA_WIDTH+GRIP_WIDTH%>) + 'px';
				  }
				 ">
</div>
<div id="tbl_content" style="position:absolute; left:<%=MAPA_WIDTH+GRIP_WIDTH%>px; top:<%=HEADER_HEIGHT%>px; background-color:#FFFFFF; vertical-align:middle; text-align:center; overflow:hidden;">
	<iframe id="vbNucleo" name="vbNucleo" width="100%" height="100%" frameborder="0" scrolling="auto" src="modulo_PAINEL_CLIENTE/nucleo.htm"></iframe>
</div>
<!-- FIM: FULCONTENT ----------------------------------------------------------------------------------------- //-->


<!-- INI: FOOTER --------------------------------------------------------------------------------------------- //-->
<div id="tbl_footer" style="position:fixed; left:0px; bottom:0px; background-color:#FFA500;">
	DDD
</div>
<!-- FIM: FOOTER --------------------------------------------------------------------------------------------- //-->

</body>
</html>
<%
 FechaDBConn objConn
%>