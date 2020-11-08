<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"
	
	Dim objConn, objRS, strSQL
	Dim queryType, criteria, strTABLE, i, rsSchema, auxStr, strMarcaPK
	
	AbreDBConn objConn, CFG_DB 	
	
	strTABLE = GetParam("var_tables")
	
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">

</head>
<body style="background-color:#E8EEFA;">

<div style="background-color:#E8EEFA; padding-top:3px;">
	<%
       if (strTABLE<>"") then
  	     strSQL = "SHOW COLUMNS FROM " & strTABLE
		 'response.write strSQL
       
         set objRS = objConn.Execute(strSQL)
	     
		 if not objRS.EOF then	       
            While Not objRS.Eof  
			  If getValue(objRS,"Key") = "PRI" Then strMarcaPK = "font-weight:bold;" Else strMarcaPK = "" End If
			  Response.Write("<span style='font-family:Tahoma; background:#E8EEFA; border:0px solid #FFF; margin:0px; font-size:11px; color:#111111; padding-left:4px; height:16px; " & strMarcaPK & "'>" & getValue(objRS,"Field") & " (" & getValue(objRS,"Type") & ")</span><br>") 
			  athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
            Wend			 
         end if
       end if	   
    %>
</div>

</body>
</html>
<%
'FechaDBConn ObjConn
%>

