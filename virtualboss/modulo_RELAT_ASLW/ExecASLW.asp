<!--#include file="../_database/athdbConn.asp"--><% 'ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<% VerificaDireito "|EXEC|", BuscaDireitosFromDB("modulo_RELAT_ASLW", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<%
 Dim objConn, objRS, strSQL
 Dim strSQLRel, auxStrSQLRel, strNOME, strCOD_REL, strCATEGORIA, strDESCRICAO, strMSG, str, pos
 Dim strInicParam, strFimParam
 Dim strParamNomes, flagSubmit
 
 '--------------------------------------------------------
 strInicParam = "["
 strFimParam = "]"
 '--------------------------------------------------------
  
 strMSG = ""
 
 strCOD_REL   = GetParam("var_chavereg")
 strSQLRel    = " " & GetParam("var_strParam") & " " ' A consulta deve chegar com as TAGs do tipo (<ASLW_APOSTROFE>, etc...)
 strNOME      = GetParam("var_nome")
 strCATEGORIA = GetParam("var_categoria")
 strDESCRICAO = GetParam("var_descricao")

 '-----------------------------------------------------------------------------
 ' Deve verificar primeiro se veio o C�DIGO do Relat�rio. Se sim � porque o 
 ' relat�rio j� est� no banco e quem chamou sabe disso e apenas passa o c�digo.
 ' Se n�o veio C�DIGO do Relat�rio � porque quem chamou est� apenas testanto 
 ' uma consulta que n�o foi pro banco ainda.
 '-----------------------------------------------------------------------------
 If strCOD_REL <> "" Then
	 AbreDBConn objConn, CFG_DB 
	 
	 strSQL = " SELECT T1.NOME, T1.DESCRICAO, T1.EXECUTOR, T1.PARAMETRO " & _ 
	          "      , T1.DT_INATIVO, T2.NOME AS CATEGORIA " & _ 
	          "   FROM ASLW_RELATORIO T1  " & _
		 	  "   LEFT OUTER JOIN ASLW_CATEGORIA T2 ON (T1.COD_CATEGORIA = T2.COD_CATEGORIA) " & _
	          "  WHERE T1.COD_RELATORIO = " & strCOD_REL 
	 set objRS = objConn.Execute(strSQL)
 	 
	 If Not objRS.Eof Then
		 strSQLRel = " " & GetValue(ObjRS,"PARAMETRO") & " "
		 strNOME   = GetValue(ObjRS,"NOME")
		 strCATEGORIA = GetValue(ObjRS,"CATEGORIA")
		 strDESCRICAO = GetValue(ObjRS,"DESCRICAO")
	 End If

	 If Not objRS.Eof Then
 		'Verifica se est� ativo
	 	If GetValue(ObjRS,"DT_INATIVO") <> "" Then
			strMSG = strMSG & "<br>Relat�rio foi inativado em " & GetValue(ObjRS,"DT_INATIVO") & "."
		End If
	
		'Verifica se existe algum executor
		If GetValue(ObjRS,"EXECUTOR") = "" Then
			strMSG = strMSG & "<br>N�o foi definido um executor para consulta."
		End If

		'Verifica se existe alguma consulta
		If (UCase(GetValue(ObjRS,"EXECUTOR")) = "EXECASLW.ASP") And (Trim(strSQLRel) = "") Then
			strMSG = strMSG & "<br>Consulta vazia. Cl�usula SQL n�o encontrada."
		End If
	 Else
	 	strMSG = strMSG & "<br>Relat�rio n�o encontrado."
	 End If

	 FechaRecordSet ObjRS
 	 FechaDBConn ObjConn
 Else
	 If Trim(strSQLRel) = "" Then
		strMSG = strMSG & "<br>Consulta vazia. Cl�usula SQL n�o encontrada."
	 End If
 End If

 'Neste ponto o que estiver colocado entre { } ser� substitu�do por valores correspondentes
 'de vari�veis ambientes na SESSION ou em COOKIE
 'ex.: 	SELECT * FROM usuario WHERE id_usuario like '{ID_USUARIO}%'  AND cod_usuario > [mincoduser]
 '	 	se o evento 112 estiver logado, ser� substitu�do por:
 '		SELECT * FROM TBL_INSCRICAO WHERE COD_EVENTO = 112
 '-----------------------------------------------------------------------------------------
 strSQLRel = replaceParametersSessionCokie(strSQLRel)
 
 'Aux�lio de digita��o, ajusta sintaxe 
 'Faz as seguintes altera��es: " por ', 
 '	e '[ por [', [% por %[, [# por #[, 
 '	e ]' por '], %] por ]%, #] por ]#
 '-------------------------------------------------------------------------------
 auxStrSQLRel = replace(strSQLRel, """", "'")
 auxStrSQLRel = replace(auxStrSQLRel, "'" & strInicParam, strInicParam & "'")
 auxStrSQLRel = replace(auxStrSQLRel, strFimParam & "'", "'" & strFimParam)

 auxStrSQLRel = replace(auxStrSQLRel, strInicParam & "<ASLW_PERCENT>", "<ASLW_PERCENT>" & strInicParam)
 auxStrSQLRel = replace(auxStrSQLRel, "<ASLW_PERCENT>" & strFimParam, strFimParam & "<ASLW_PERCENT>")

 auxStrSQLRel = replace(auxStrSQLRel, strInicParam & "<ASLW_SHARP>", "<ASLW_SHARP>" & strInicParam)
 auxStrSQLRel = replace(auxStrSQLRel, "<ASLW_SHARP>" & strFimParam, strFimParam & "<ASLW_SHARP>")

 auxStrSQLRel = replace(auxStrSQLRel, VbCrLf, " ")
 '-------------------------------------------------------------------------------
 'Response.Write(auxStrSQLRel & "<br>")
 'Response.End()

 ' Por enquanto n�o permitimos as opera��es listadas abaixo. Depois 
 ' poderemos permitir se usu�rio for "superusu�rio", "ADMIN", etc
 If InStr(1, strSQLRel, " INSERT ", vbTextCompare) > 0 Then strMSG = strMSG & "<br>Instru��o INSERT n�o � permitida."
 If InStr(1, strSQLRel, " UPDATE ", vbTextCompare) > 0 Then strMSG = strMSG & "<br>Instru��o UPDATE n�o � permitida."
 If InStr(1, strSQLRel, " DELETE ", vbTextCompare) > 0 Then strMSG = strMSG & "<br>Instru��o DELETE n�o � permitida."
 If InStr(1, strSQLRel, " DROP ", vbTextCompare) > 0   Then strMSG = strMSG & "<br>Instru��o DROP n�o � permitida."
 If InStr(1, strSQLRel, " RENAME ", vbTextCompare) > 0 Then strMSG = strMSG & "<br>Instru��o RENAME n�o � permitida."
 If InStr(1, strSQLRel, " ALTER ", vbTextCompare) > 0  Then strMSG = strMSG & "<br>Instru��o ALTER n�o � permitida."
 If InStr(1, strSQLRel, " CREATE ", vbTextCompare) > 0 Then strMSG = strMSG & "<br>Instru��o CREATE n�o � permitida."

 
 If strMSG <> "" Then
 	Mensagem strMSG, "JavaScript:window.close()", "Fechar", True
 Else
%>
<html>
<head>
<title></title>
<link rel="stylesheet" href="../_css/csm.css" type="text/css">
<!--link rel="stylesheet" href="../_css/virtualboss.css" type="text/css"-->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style>
	body{
		font-family: "Trebuchet MS",Verdana, Tahoma, Arial;
		font-size: 12px;
		font-weight:bold;
	}
</style>
<script language="JavaScript">
<!--
function SetParamToSQL () 
{
  var myStrSQL, cont;
 
  myStrSQL = document.FormPrSQL.sqlBUFFER.value;
  alert("sqlBUFFER: " + document.FormPrSQL.sqlBUFFER.value);

  cont = 0;
  while ( document.FormPrSQL.elements[cont].name != '' ) 
    {
	  while (myStrSQL.indexOf(document.FormPrSQL.elements[cont].name) > 0) {
	  	myStrSQL = myStrSQL.replace(document.FormPrSQL.elements[cont].name,document.FormPrSQL.elements[cont].value);
	  }
      cont = cont + 1;
    }
  alert("SQL to Send:" + myStrSQL);
  document.FormPrSQL.sqlBUFFER.value 	= myStrSQL; //????
  document.FormPrSQL.var_strParam.value = myStrSQL;
  document.FormPrSQL.submit();
}
-->
</script>
</head>
<body>
<table id="tblForm" width="100%" height="100%" cellpadding="0" cellspacing="0" border="0" style="visibility:hidden;">
<tr>
  <td align="center" valign="middle">
	<!-- form name="FormPrSQL" action="JavaScript:SetParamToSQL();" method="post" //-->
	<form name="FormPrSQL" action="ResultASLW.asp" method="post">
	<table cellpadding="0" cellspacing="2" border="0">
		<%
		   flagSubmit = true
		   
		   'auxStrSQLRel = UCase(auxStrSQLRel) 'N�o fazer UpperCase pois pode afetar os par�metros de fun��es como STR_TO_DATE
		   pos=InSTR(auxStrSQLRel,strInicParam)
		   
		   if (pos>0) then
  		     flagSubmit = false
			 strParamNomes = ""
			 while pos>0
			   str=Mid(auxStrSQLRel, pos+1 , InSTR(pos,auxStrSQLRel,strFimParam)-(pos+1))
			   str=replace(str, """","") 
			   str=replace(str, "'","") 
			   If InStr(strParamNomes, "|" & str & "|") = 0 Then
				   response.write ("<tr>" & vbnewLine)
				   response.write (" <td>"& str &"&nbsp;</td>" & vbnewLine)
				   response.write (" <td><input name='"&str&"' id='"&str&"' type='text' value=''></td>" & vbnewLine)
				   response.write ("</tr>" & vbnewLine)
				   strParamNomes = strParamNomes & "|" & str & "|"
			   End If
			   auxStrSQLRel=replace(auxStrSQLRel, strInicParam, "", 1, 1) 
			   auxStrSQLRel=replace(auxStrSQLRel, strFimParam, "", 1, 1) 
			   pos=InSTR(auxStrSQLRel,strInicParam)
			 wend
		   end if
		%>
		 <tr>
		   <td colspan="2">
			 <input name="descBUFFER"	 id="descBUFFER"	type="hidden" value="<%=strDESCRICAO%>">
			 <input name="sqlBUFFER"	 id="sqlBUFFER"		type="hidden" value="<%=auxStrSQLRel%>">
			 <input name="var_nome"		 id="var_nome"		type="hidden" value="<%=strNOME%>">
			 <input name="var_categoria" id="var_categoria"	type="hidden" value="<%=strCATEGORIA%>">
			 <input name="var_strParam"	 id="var_strParam"	type="hidden" value="<%=auxStrSQLRel%>">
		   </td>
		 </tr>
		<tr><td colspan="2"><hr></td></tr>
		<tr><td height="20" colspan="2"></td></tr>
		<tr>
		  <td></td>
		  <td align="right">
		   <input type="button" onClick="javascript:SetParamToSQL(); return false;" value="EXECUTAR">
		  </td>
		</tr>
		</table>
		</form>
  </td>
</tr>
</table>
<script language="JavaScript">
<% 
 if (flagSubmit) then 
   response.Write("document.FormPrSQL.submit();")
 else 
   response.Write("document.getElementById('tblForm').style.visibility='visible';")  
 end if
%>
</script>
</body>
</html>
<%
 End If
%>
