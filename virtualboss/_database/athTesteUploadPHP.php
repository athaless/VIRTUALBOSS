<?php
 /**
   athTesteUploadPHP by Alan (15/03/2007) ******
   Este c�digo serve para testar se o PHP est� insalado no servidor.
   
   Funcionamento:
   Ela habilita a op��o do PHP via javascript dentro do c�digo abaixo.
   Como o javascript est� dentro do PHP, ele s� vai ser rodado se o PHP
   estiver instalado no server.
   
   ------------------------------------------------------------------
   ATEN��O!!!!!! Ela serve apenas para a athUploader por enaquanto.
   ------------------------------------------------------------------ 
 */
 echo("<script language='javascript' type='text/javascript'>");
 echo(" parent.document.formupload.upload_php.disabled = false;");
 echo("</script>");
?>