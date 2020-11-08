<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 Response.Expires = 0
 Dim objConn, strSQL, objRS

 Dim strCOD_ENQUETE, strCOD_QUESTAO, strCOD_ALTERNATIVA, auxQUESTAO
 Dim auxNUM_VOTOS , auxTOT_VOTOS , strID_USUARIO
 Dim i, msgERRO, aux
 msgERRO = ""
 
 strCOD_ENQUETE = Request("var_chavereg")
 strID_USUARIO  = Request.Cookies("VBOSS")("ID_USUARIO")

 AbreDBConn objConn, CFG_DB

 If ( (strCOD_ENQUETE="") OR (strID_USUARIO="") )then 
	msgERRO = "Falha na autenticação ou identificação da enquete de código " & strCOD_ENQUETE
 END IF

 'TESTE SE o USER LOGADO JA NÃO PREENCHEU ESSA ENQUETTE
 strSQL = " SELECT COUNT(COD_LOG) as VOTOU FROM en_log  WHERE en_log.cod_enquete =  "& strCOD_ENQUETE & " AND id_usuario LIKE '" & strID_USUARIO & "' "  
 'athDEBUG strSQL, false
 Set objRS = objConn.Execute(strSQL)
 If (NOT objRS.EOF) then 
   If (CInt(getValue(objRS,"VOTOU")) > 0) then 
	msgERRO = "Obrigado, <br>" & strID_USUARIO & "<br><br>Você já participou dessa enquete e será redirecionando para a página de resultados.<br><br>[<a href=enquete_result.asp?var_chavereg=" & strCOD_ENQUETE & ">Clique aqui</a>]"
   End If
 END IF



 strSQL = " SELECT  t3.cod_enquete     , t3.titulo, t3.tipo_entidade " &_
 		  "		  , t2.cod_questao     , t2.questao " &_
		  "		  , t1.cod_alternativa , t1.alternativa "&_
		  "		  , t1.tipo "&_
		  "		  , t1.num_votos "&_
		  "		  ,(SELECT SUM(en_alternativa.num_votos) FROM en_alternativa WHERE cod_questao = t1.cod_questao) AS tot_votos "&_
		  "		  ,(SELECT COUNT(cod_log) FROM en_log WHERE COD_ENQUETE = "& strCOD_ENQUETE & " AND ID_USUARIO <> '" & strID_USUARIO & "')  AS QTDE_VOTANTES "&_
		  "		  ,(SELECT COUNT(COD_USUARIO) FROM usuario WHERE DT_INATIVO IS NULL AND TIPO like t3.TIPO_ENTIDADE)  AS QTDE_USUARIOS "&_
		  "	  FROM en_enquete AS t3 "&_
		  "	   LEFT JOIN en_questao AS t2 ON (t3.cod_enquete = t2.cod_enquete AND t3.cod_enquete = "& strCOD_ENQUETE & ") "&_
		  "	   LEFT JOIN en_alternativa as t1 ON (t2.cod_questao = t1.cod_questao)  "&_
		  "    WHERE t2.questao IS NOT NULL AND t1.alternativa IS NOT NULL "&_
		  "	 ORDER BY t2.ORDEM "

 'athDEBUG strSQL, false
 Set objRS = objConn.Execute(strSQL)
%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="../_css/virtualboss.css">
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<script type="text/jscript" language="javascript">
<!--
function MyStripTags(prElem) {
  var tmp = document.createElement("DIV");
  tmp.innerHTML = prElem.value;
  prElem.value = tmp.textContent || tmp.innerText;
  return prElem.value;
}

function validacampos() {
 var strQuest="";
 var arrQuest=[];
 var i=0,j=-1;
 var x=document.getElementById("formenquete");

 for (i=0; i < x.length; i++) {
	 if (x.elements[i].type == "radio") {
		if (strQuest == x.elements[i].name) {
			arrQuest[j] = arrQuest[j] || x.elements[i].checked; 
		} else {
			j++;
			arrQuest[j] = false || x.elements[i].checked; 
			strQuest = x.elements[i].name;
		}
		//alert(x.elements[i].name + " - " + x.elements[i].value + " - " + x.elements[i].checked );
	 }
 }
 
 strQuest="";
 for (i=0; i < arrQuest.length; i++) {
	if  (!arrQuest[i]) {
		if (strQuest=="") {
			strQuest = eval(i+1)	;
		} else {
			strQuest = strQuest + ", " + eval(i+1);	
		}
	   // alert ("questao " + eval(i+1) + ":  " + arrQuest[i]);
	}
 }

 if (strQuest!="") {
   alert ("Atenção! Todas as questões objetivas são obrigatórias. \nVerifique sua resposta para questões:\n " + strQuest + ".");
 } else {
  document.formenquete.action = "enquete_form_exec.asp";
  document.formenquete.submit();
 }
}

//-->
</script>
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" style="margin:0px; padding:0px;">
<div style="width:100%; border:0px solid #0F0; text-align:left; margin-bottom:15px; ">
    <img src="../img/LogoEnquete.gif" align="top" border="0">
</div>
<div style="width:460px; border:0px solid #0F0; text-align:left; margin-left:10px;">
<%
If (msgERRO="") Then 
%>
    <div style="padding: 0px 0px 0px 10px; border:0px solid #F00; text-align:left;">
		<h3><%=getValue(objRS,"Titulo")%></h3>
        <small>Este sistema de enquete não armazena as respostas por usuário, apenas contabliliza totais, 
        a fim de garantir o total anonimato nas respostas objetivas, e nas respostas subjetivas os textos 
        são embaralhados. Não se preocupe e abuse de sinceridade, pois sua opinião e contribuições serão 
        muito importantes para o grupo. Esta pesquisa esta direcionada somente a <b><%=replace(getValue(objRS,"TIPO_ENTIDADE"),"ENT_","")%></b>.</small>
    </div>
    <hr>
	<!-- ............................................................................ -->
	<!-- INIC: Exibe alternativas ................................................... -->
	<form name="formenquete" id="formenquete" action="" method="post">
	<input type="hidden" name="var_cod_enquete" id="var_cod_enquete" value="<%=strCOD_ENQUETE%>" //-->
	<input type="hidden" name="var_id_usuario" id="var_id_usuario" value="<%=strID_USUARIO%>" //-->
	<%
    auxQUESTAO = ""		
	i = 1		
    Do While NOT objRS.EOF
		IF auxQUESTAO <> getValue(objRS,"QUESTAO") THEN
			%>
			<div style="margin-top:20px; padding: 10px 0px 10px 10px; border:0px solid #F00; text-align:left; background-color:#EEEEEE">
			<img src="../img/BulletBusca.gif">&nbsp;<b><%=i & "." & getValue(objRS,"QUESTAO")%></b>
			</div>
	<%  	i=i+1
		END IF  %>
            <div style="padding-top:5px; padding-left:20px; border:0px solid #F9C; text-align:left;">
			  <div>
              	<% If (ucase(getValue(objRS,"TIPO")) = "OBJETIVA") then	%>
	                <input type="radio" name="var_objetiva_<%=i%>" id="var_objetiva_<%=i%>" value="<%=getValue(objRS,"COD_ALTERNATIVA")%>">&nbsp;<%=getValue(objRS,"ALTERNATIVA") %>
              	<% Else	%>
	                <%=getValue(objRS,"ALTERNATIVA")%>&nbsp;<small>("tags html" serão descartadas)</small><BR>
                    <textarea name="var_subjetiva_<%=getValue(objRS,"COD_ALTERNATIVA")%>" style="width:420px; height:60px" onBlur="MyStripTags(this); return false;"></textarea>
              	<% End If %>
               </div> 
            </div>
		<%
		auxQUESTAO = getValue(objRS,"QUESTAO")
		athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT 				
    Loop
    FechaRecordset(objRS)
%>
    <hr>
    <input type="button" title="ENVIAR" value="ENVIAR" onClick="javascript:validacampos(); return false;" style="width:100px; height:35px;"><br>
	</form>
	<!-- FIM: Exibe alternativas ............................................ -->
	<!-- .................................................................... -->
<%
 Else
%>
	<div style="width:460px; border:0px solid #0F0; text-align:left; margin-left:10px;">
	    <div style="padding: 0px 0px 0px 10px; border:0px solid #F00; text-align:left;">
			<h3><%=msgERRO%></h3>
	    </div>
	</div>
<%
 End If
%>
	<div style="margin-top:20px; padding: 10px 0px 10px 10px; border:0px solid #F00; text-align:left; background-color:#666; height:15px;"></div>
    <br>
</div>
</body>
</html>
<%
 FechaDBConn objConn
%>