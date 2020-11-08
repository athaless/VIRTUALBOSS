<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 ' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
 ' e o tamanho da coluna dos títulos dos inputs
 Dim WMD_WIDTH, WMD_WIDTHTTITLES
 WMD_WIDTH = 440
 WMD_WIDTHTTITLES = 100
 ' -------------------------------------------------------------------------------
 Dim arrESTADOS, arrNOMES, Cont

 sub MontaModeloRECADO_LIGACAO() 
   Response.write "<table width='300' cellpadding='0' cellspacing='1' border='1' bordercolor='#CCCCCC' style='font-family:arial;font-size:11px;'> " &_
                  " <TR><TD width='70' align='right' valign='top'>Sr(a):</TD><TD width='318' align='LEFT' valign='top'>&nbsp;</TD></TR> " &_
                  "  <TR><TD align='right' valign='top'>Empresa:</TD><TD align='LEFT' valign='top'>&nbsp;</TD></TR> " &_
                  "  <TR><TD align='right' valign='top'>Telefone:</TD><TD align='LEFT' valign='top'>&nbsp;</TD></TR> " &_
                  "  <TR> " &_
                  "    <TD align='right' valign='top'>&nbsp;</TD> " &_
                  "    <TD align='LEFT' valign='top'> " &_
                  "   <table width='100%' cellpadding='0' cellspacing='1' bordercolor='#999999' border='1' style='font-family:arial;font-size:11px;'> " &_
                  "        <tr><td width='20'>&nbsp;</td><td>&nbsp;Ligou</td><td width='20'>&nbsp;</td><td>&nbsp;Ligue de volta</td></tr> " &_
                  "       <tr><td width='20'>&nbsp;</td><td>&nbsp;Respondeu</td><td width='20'>&nbsp;</td><td>&nbsp;Ligará depois</td></tr> " &_
                  "       <tr><td width='20'>&nbsp;</td><td>&nbsp;Deixou Mensagem</td><td width='20'>&nbsp;</td><td>&nbsp;Quer vê-lo</td></tr> " &_
                  "       <tr><td width='20'>&nbsp;</td><td>&nbsp;Confirmou presença</td><td width='20'>&nbsp;</td><td>&nbsp;[outros]</td></tr> " &_
                  "   </table> " &_
                  " </TD> " &_
                  "  </TR> " &_
                  "  <TR><TD align='right' valign='top'>Mensagem:</TD><TD align='LEFT' valign='top' height='200'> </TD></TR> " &_
                  "  <TR><TD align='right' valign='top'>Data/Hora:</TD><TD align='LEFT' valign='top' nowrap> DD/MM/AAAA HH:MM:SS</TD></TR> " &_
                  " </table>"
  end sub
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
var moz = !(document.all);
var Editor = null;
var modeHTML = true;
function verificarBrowser(){
	if(moz){
	   Editor = document.getElementById("editor_basico").contentDocument;
	}
	else{
	   Editor = frames["editor_basico"].document;
	}
}

function ativarEditor(){
	  verificarBrowser();
	  Editor.designMode = "On";
	  Editor.write("<%MontaModeloRECADO_LIGACAO%>");
	  Editor.close();
	  Editor.onkeydown = _handleKeyDown;
}

function _handleKeyDown () { 
	var ev = this.parentWindow.event;
	if(ev.keyCode == 13) {
		ev.returnValue = false;
		frames["editor_basico"].focus();
		var sel = Editor.selection.createRange(); 
		sel.pasteHTML("<br>");
		sel.select();
    } 
}

function verpagina(){
	ver = window.open("", "ver", "popup,width=600,height=480")
	ver.document.open()
	ver.document.write(getIframeContent(1))
	ver.document.write("<br>") 
	ver.document.close()
}

function getIframeContent(type_desc){
     if(type_desc == 0 || type_desc == 1){
	 	if(type_desc == 0){ type_desc = "Text"; }
		else if(type_desc == 1){ type_desc = "HTML"; }	
		eval("return Editor.body.inner" + type_desc + ";");
	 }
}

function setIframeContent(iframe_id, pr_value){
  	if(moz){ document.getElementById(iframe_id).focus(); } else { frames[iframe_id].focus(); }
  	var ed = Editor.selection.createRange();
  	ed.pasteHTML(pr_value);
  	ed.select();
}

function aplicarFormat(what,opt) {  
	if (opt=="removeFormat") { 
	what=opt; 
	opt=null; 
	} 
	if (opt==null) Editor.execCommand(what); 
	else Editor.execCommand(what,"",opt); 
	Editor.focus();
}

function inverterModo(){
	if(modeHTML){
		Editor.body.innerText = Editor.body.innerHTML;
		document.getElementById("botaoHTML").innerText = 'Design';
	}
	else{
		Editor.body.innerHTML = Editor.body.innerText;
		document.getElementById("botaoHTML").innerText = 'HTML';
	}
	modeHTML = !modeHTML
}

function colocarTexto(){
	if(modeHTML){
		document.form_insert.DBVAR_STR_TEXTO.value = Editor.body.innerHTML;
	}
	else{
		document.form_insert.DBVAR_STR_TEXTO.value = Editor.body.innerText;
	}
}

</script>

<style>
	.menu_tags{
		text-align:center;
		width:40px;
		border-right:1px solid #000000;
		border-top:1px solid #333333;
		border-bottom:1px solid #666666;
		border-left:1px solid #999999;
		background-color:#FFFFFF;
		font-family:Tahoma;
		font-size:10px;
		color:#000000;
		font-weight:bold;
		text-decoration:none;
		cursor:hand;
	}
	
	.menu_tags:hover{
		font-family:Tahoma;
		font-size:10px;
		color:#666666;
		background-color:#FFFFFF;
		border-right:1px solid #333333;
		border-top:1px solid #666666;
		border-bottom:1px solid #999999;
		border-left:1px solid #CCCCCC;
	}
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="ativarEditor();">
<form name="form_insert" action="../_database/athInsertToDB.asp" method="post">
  <input type="hidden" name="DEFAULT_TABLE"                value="RECADO">
  <input type="hidden" name="DEFAULT_DB"                   value="<%=CFG_DB%>">
  <input type="hidden" name="FIELD_PREFIX"                 value="DBVAR_">
  <input type="hidden" name="RECORD_KEY_NAME"              value="COD_RECADO">
  <input type="hidden" name="DEFAULT_LOCATION"             value="../modulo_RECADO/insert.asp">
  <input type="hidden" name="DBVAR_DATETIME_SYS_DTT_INS"   value="<%=Now()%>">
  <input type="hidden" name="DBVAR_STR_SYS_ID_USUARIO_INS" value="<%=Request.Cookies("VBOSS")("ID_USUARIO") %>">
<%
  athBeginDialog WMD_WIDTH, "Recado - Inserção"
%>     
  <!-- INIC: TABELA DE "MIOLO" Dialog (ITENS DO FORMULÁRIO) -->                    
  <table width="100%" border="0" cellpadding="1" cellspacing="0">
    <tr> 
      <td width="90" align="right" valign="top">Para:&nbsp;</td>
      <td width="350">
	    <select name="DBVAR_STR_ID_USUARIO_TO" class="edtext">
           <option value="">Selecione</option>
             <%=montaCombo("STR","SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL ORDER BY ID_USUARIO","ID_USUARIO","ID_USUARIO",Request.Cookies("VBOSS")("ID_USUARIO"))%> 
        </select>
      </td>
    </tr>
    <tr> 
      <td align="right" valign="top">
	    Texto:&nbsp;
	    <!--table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-top:20px;">
			<tr>
			 <td colspan="2" align="center"><small>Alternar para:</small></td>
			</tr>
			<tr>
			 <td colspan="2" align="center"><a href="#" id="botaoHTML" onClick="inverterModo();" class="menu_tags">HTML</a></td>
			</tr>
			<!--tr>
			 <td colspan="2" align="center"><small>Menu Editor</small></td>
			</tr>
			<tr>
			 <td colspan="2" height="10"></td>
			</tr>
			<tr>
			 <td><a href="#" onClick="aplicarFormat('bold')" class="menu_tags">B</a></td>
			 <td><a href="#" onClick="aplicarFormat('italic')" class="menu_tags"><i>I</i></a></td>
			</tr>
			<tr>
			 <td><a href="#" onClick="aplicarFormat('underline')" class="menu_tags"><u>U</u></a></td>
			 <td><a href="#" onClick="aplicarFormat('justifycenter')" class="menu_tags">center</a></td>
			</tr>
			<tr>
			 <td><a href="#" onClick="aplicarFormat('justifyleft')" class="menu_tags">left</a></td>
			 <td><a href="#" onClick="aplicarFormat('justifyright')" class="menu_tags">right</a></td>
			</tr>
			<tr>
			 <td><a href="#" onClick="aplicarFormat('insertorderedlist')" class="menu_tags">&bull;</a></td>
			 <td><a href="#" onClick="aplicarFormat('insertunorderedlist')" class="menu_tags">1.</a></td>
			</tr>
			<tr>
			 <td><a href="#" onClick="aplicarFormat('outdent')" class="menu_tags">R</a></td>
			 <td><a href="#" onClick="aplicarFormat('indent')" class="menu_tags">A</a></td>
			</tr>
	    </table-->
	  </td>
      <td>
	    <input type="hidden" name="DBVAR_STR_TEXTO" value="">
		<div id="editor">
		  <iframe id="editor_basico" width="340" height="435" frameborder="0"></iframe>
		</div>
	  </td>
    </tr>
	<tr>
		<td align="right" colspan="2">
			<table border="0" cellpadding="0" cellspacing="0" width="120">
				<tr>
				 <td align="center"><small>Alternar para:</small></td>
				 <td align="center"><a href="#" id="botaoHTML" onClick="inverterModo();" class="menu_tags">HTML</a></td>
				</tr>
			</table>
		</td>
	</tr>
  </table>
     <!-- FIM: TABELA DE "MIOLO" Dialog (ITENS DO FORMULÁRIO) -->

<%
  athEndDialog WMD_WIDTH, "../img/bt_save.gif", "colocarTexto();document.form_insert.submit();", "", "S", "", ""
%>
</form>
</body>
</html>