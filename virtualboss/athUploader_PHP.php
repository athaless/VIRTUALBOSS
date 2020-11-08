<?php
 session_start();

 global $php_errormsg;
 ini_set('track_errors', true);
 echo "<br>".$var_formname 	  = $_REQUEST["var_formname"];
 echo "<br>".$var_fieldname	  = $_REQUEST["var_fieldname"];
 echo "<br>".$var_dir    	  = $_REQUEST["var_dir"];
 echo "<br>".$var_path   	  = $_REQUEST["var_path"];  
 /*Parâmetro que controla se deve ser colocado prefixo no nome do arquivo. By Lumertz - 29.04.2013.*/
 $var_file_prefix = $_REQUEST["var_file_prefix"];
 /*if((strtolower($var_file_prefix) == "false" )){
   $var_file_prefix = "false";
 }elseif(($var_file_prefix == "")or(strtolower($var_file_prefix) == "true")) {$var_file_prefix = "true";}*/

 $var_dir    	= str_replace("//","\\",$var_dir);
 $var_path   	= str_replace("//","\\",$var_path);
 $file1	    	= $_FILES["file1"]["tmp_name"];
 $file1_name 	= $_FILES["file1"]["name"];
 
  "file1 ".$file1."<br>";
  "file1_name ".$file1_name;
 
 //Removendo caracteres especiais no nome do arquivo 01/02/2017 by Aless
 function tiraAcento( $str ) { return strtr(utf8_decode($str),utf8_decode('ŠŒŽšœžŸ¥µÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýÿ'),'SOZsozYYuAAAAAAACEEEEIIIIDNOOOOOOUUUUYsaaaaaaaceeeeiiiionoooooouuuuyy'); }
 $file1_name = tiraAcento($file1_name);
 
 /*------------------------------------------------------
   Colocado no nome do arquivo data e hora pois estava 
   sobrescrevendo arquivos com mesmo nome 
   by Vini 25.01.2013
 --------------------------------------------------------*/
 if($var_file_prefix != "false"){
   //Estava dando erro abaixo na função "date()"
   //
   //"It is not safe to rely on the system's timezone settings. Please use the date.timezone setting, the TZ environment variable or 
   // the date_default_timezone_set() function. In case you used any of those methods and you are still getting this warning, you most 
   // likely misspelled the timezone identifier. We selected 'America/Sao_Paulo' for '-3.0/no DST' instead"
   
   date_default_timezone_set('America/Sao_Paulo');
   
   $file1_name 	= "{" . session_id() . "_" . date("dmy") . date("His") . "}_" . $file1_name;
 }
 
 $arq_path = $var_path . "\\" . $var_dir . "\\" . $file1_name;
 $file1;
 if (@copy($file1,$arq_path)) {
	 $var_func=2;
 } 
 else {
	 $var_func=1;
 }
 
 //header("Location:athUploader.asp?var_dir=".$_REQUEST["var_dir"]."&var_error=".$php_errormsg."&var_func=".$var_func."&var_formname=".$var_formname."&var_fieldname=".$var_fieldname."&var_file=".$file1_name."&var_file_prefix=".$var_file_prefix); 
?>
<script language="javascript" type="text/javascript">
	location.href = "athUploader.asp?var_dir=<?php echo($_REQUEST["var_dir"]);?>"+
					"&var_erro=<?php echo($php_errormsg);?>"+
					"&var_func=<?php echo($var_func);?>"+
					"&var_formname=<?php echo($var_formname);?>"+
					"&var_fieldname=<?php echo($var_fieldname);?>"+
					"&var_file=<?php echo($file1_name);?>"+
					"&var_file_prefix=<?php echo($var_file_prefix);?>";
</script>
