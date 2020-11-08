<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
<head>
	<script type="text/javascript" language="javascript">
		function imprimir(){
			if(parent.window.frames[2] == null){
				alert('Documento corrente NÃO está dentro da Estrutura de Frames Correta!');
				return(null);
			}
			else if(parent.window.frames[2].frames[1] == null){
				return(null);
			}
			else if(parent.window.frames[2].frames[1].frames[1].frames[1] == null){ 
				parent.window.frames[2].frames[1].focus();
				parent.window.frames[2].frames[1].print();
			} 
			else{
				parent.window.frames[2].frames[1].frames[1].frames[1].focus();
				parent.window.frames[2].frames[1].frames[1].frames[1].print();
			}
		}
		
		function getExport(prAction){
		   /* Esta função faz o export do CONTEÚDO 
			* que está no FRAME da direita, para um
			* tipo de documento informado como param. 
			* O conteúdo é coletado via javascript
			* e o formulário atual de export é atuali-
			* zado e aberto em pop-up, onde o conteú-
			* do é carregado.
			*/
			var objBODY;
			var objFORM;
			var objCONT;
			var objACAO;
			var objLINK;
			var strACAO;
					
			// PASSAGEM DE PARÂMETROS, INICIALIZACAO
			objACAO = document.getElementById("var_acao");
			objCONT = document.getElementById("var_content");
			objLINK = document.getElementById("var_link");
			objFORM = document.getElementById("formexport");
			strACAO = prAction;
			
			// TRATAMENTO CONTRA PARAMS NULL
			// var a = parent.window.frames[2].document.getElementsByTagName("html");
			// alert(a[0].innerHTML);
			if(parent.window.frames[2] == null){
				alert('Documento corrente NÃO está dentro da Estrutura de Frames Correta!');
				return(null);
			}
			else if(parent.window.frames[2].frames[1] == null){
				return(null);
			}
			else if(parent.window.frames[2].frames[1].frames[1].frames[1] == null){ 
				objBODY = parent.window.frames[2].frames[1].document.getElementsByTagName("body");
			} 
			else{
				objBODY = parent.window.frames[2].frames[1].frames[1].frames[1].document.getElementsByTagName("body");
			}
			
			
			// @DEBUG:
			// alert(objBODY[0].innerHTML);
			
			// ATUALIZAÇÃO DE VALUES, ETC
			objCONT.value = objBODY[0].innerHTML;
			objACAO.value = strACAO;
			objLINK.value = parent.window.frames[2].location.toString();
			objFORM.submit();
		}
	</script>
	<style>
		a         { font-size:10px; font-family:Tahoma; color:#333333; text-decoration:none; cursor:pointer; }
	  	a:hover   { font-size:10px; font-family:Tahoma; color:#999999; text-decoration:none; cursor:pointer; }
	</style>
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="formexport" id="formexport" action="export.php" target="_blank" method="post">
	<input type="hidden" name="var_content" id="var_content" value="" />
	<input type="hidden" name="var_acao"    id="var_acao"    value="" />
	<input type="hidden" name="var_link"    id="var_link"    value="" />
</form>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td width="1%" height="5" valign="top"><img src="../virtualboss/img/AbabottomLf.jpg" width="25" height="25"></td>
    <td width="99%" align="right" valign="top" background="../virtualboss/img/BgBottom.jpg" style="background-repeat:repeat-x">
	  <div style="width:100%;">
		<div style="display:inline; float:left; text-align:left; width:50%;">
	      &nbsp;
		</div>
	  	<div style="display:inline;float:left; text-align:right;width:50%;height:20px;">
			<a onClick='imprimir();' title="Imprimir"><img src="../virtualboss/img/MiniExpo_Print.jpg" border="0" alt=""></a>
			<a onClick="getExport('.doc');" title="Exportar para MSWord"><img src="../virtualboss/img/MiniExpo_Word.jpg" border="0" alt=""></a>
			<a onClick="getExport('.xls');" title="Exportar para MSExcel"><img src="../virtualboss/img/MiniExpo_Excel.jpg" border="0" alt=""></a>&nbsp;&nbsp;
			<a href="modulo_SYSHELP/default.htm" target='vbNucleo' title='Ajuda/Help'><img src='../virtualboss/img/MiniExpo_Help.jpg' border='0' alt=''></a>&nbsp;&nbsp;
		</div>
	  </div>
	</td>
    <td width="1%" height="1" valign="top"><img src="../virtualboss/img/AbabottomRg.jpg" width="25" height="25"></td>
  </tr>
</table>
</body>
</html>