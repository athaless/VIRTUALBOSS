<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 Response.Expires = 0
 Dim objConn, strSQL, objRS

 Dim strCOD_ENQUETE, strCOD_QUESTAO, strCOD_ALTERNATIVA, auxQUESTAO
 Dim auxNUM_VOTOS , auxTOT_VOTOS 
 Dim i, msgERRO, aux

 strCOD_ENQUETE = Request("var_chavereg")

 AbreDBConn objConn, CFG_DB

 strSQL = " SELECT   t3.titulo "&_
 		  "		  , t2.questao "&_
		  "		  , t1.alternativa "&_
		  "		  , t1.num_votos "&_
		  "		  ,(SELECT SUM(en_alternativa.num_votos) FROM en_alternativa WHERE cod_questao = t1.cod_questao) AS tot_votos "&_
		  "		  ,(SELECT COUNT(cod_log) FROM en_log WHERE COD_ENQUETE = "& strCOD_ENQUETE & " AND ID_USUARIO <> '" & Request.Cookies("VBOSS")("ID_USUARIO") & "')  AS QTDE_VOTANTES "&_
		  "		  ,(SELECT COUNT(COD_USUARIO) FROM usuario WHERE DT_INATIVO IS NULL AND TIPO like t3.TIPO_ENTIDADE)  AS QTDE_USUARIOS "&_
		  "	  FROM en_enquete AS t3 "&_
		  "	   LEFT JOIN en_questao AS t2 ON (t3.cod_enquete = t2.cod_enquete AND t3.cod_enquete = "& strCOD_ENQUETE & ") "&_
		  "	   LEFT JOIN en_alternativa as t1 ON (t2.cod_questao = t1.cod_questao AND UCASE(t1.tipo) = 'OBJETIVA') "&_
		  "    WHERE t2.questao IS NOT NULL AND t1.alternativa IS NOT NULL "&_
		  "	 ORDER BY t2.ORDEM "

 'athDEBUG strSQL, false
 Set objRS = objConn.Execute(strSQL)
%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="../_css/virtualboss.css">
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" style="margin:0px; padding:0px;">
<div style="width:100%; border:0px solid #0F0; text-align:left; margin-bottom:15px; ">
    <img src="../img/LogoEnquete.gif" align="top" border="0">
</div>
<%
msgERRO = ""
If (NOT objRS.EOF) then 
 'INI: Testa exibe Respostas - por convenção, para exibir os resultados PARCIAIS, 
 'exigimos que pelo menos que 1% de usuarios ativos (fora o logado) tenham preenchido a enquete
 aux = ( CInt(getValue(objRS,"QTDE_VOTANTES")) / CInt(getValue(objRS,"QTDE_USUARIOS")) )

 IF (aux < 0.1)  THEN
	 msgERRO = "Não há quantidade de respostas suficientas para exibição das parciais <small>(" & aux & " menor que 1%)</small>."
 End If
 'FIM: Tessta exibe Respostas -------------------------------------------------------------------------- 
Else 
   msgERRO = "Enquete [" & strCOD_ENQUETE & "] e suas respostas não estão disponíveis."
End If


If (msgERRO="") Then 
%>
<div style="width:460px; border:0px solid #0F0; text-align:left; margin-left:10px;">
    <div style="padding: 0px 0px 0px 10px; border:0px solid #F00; text-align:left;">
		<h3><%=getValue(objRS,"Titulo")%></h3>
    </div>
    <hr>
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
			
            <div style="padding: 10px 0px 5px 20px; border:0px solid #F9C; text-align:left;">
                <%=getValue(objRS,"ALTERNATIVA")%>
            </div>
            <div style="padding: 0px 0px 0px 30px; border:0px solid #C90; text-align:left;">
                <% 
                auxNUM_VOTOS = Cint(getValue(objRS,"NUM_VOTOS"))
                auxTOT_VOTOS = Cint(getValue(objRS,"TOT_VOTOS"))
                If auxTOT_VOTOS > 0 Then
                %>
                <img src='../img/barra_enquete.jpg' width="<%=FormatNumber((auxNUM_VOTOS/auxTOT_VOTOS) * 150,0)%>" height='7'>
                &nbsp;<%=FormatNumber((auxNUM_VOTOS/auxTOT_VOTOS) * 100, 2)%>%
                <%  End If %>
           </div>		
				
		<%
		auxQUESTAO = getValue(objRS,"QUESTAO")
		athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT 				
    Loop
    FechaRecordset(objRS)
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
	<div style="margin-top:20px; padding: 10px 0px 10px 10px; border:0px solid #F00; text-align:left; background-color:#666; height:24px;"></div>
    <br>
</div>
</body>
</html>
<%
 FechaDBConn objConn
%>