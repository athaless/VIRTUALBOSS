<?php
 /**
   athTesteUploadPHP by Alan (15/03/2007) ******
   Este código serve para testar se o PHP está insalado no servidor.
   
   Funcionamento:
   Ela habilita a opção do PHP via javascript dentro do código abaixo.
   Como o javascript está dentro do PHP, ele só vai ser rodado se o PHP
   estiver instalado no server.
   
   ------------------------------------------------------------------
   ATENÇÃO!!!!!! Ela serve apenas para a athUploader por enaquanto.
   ------------------------------------------------------------------ 
 */
 echo("<script language='javascript' type='text/javascript'>");
 echo(" parent.document.formupload.upload_php.disabled = false;");
 echo("</script>");
?>