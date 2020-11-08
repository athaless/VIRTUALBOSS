<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
 Response.Expires = -1
 
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_HORARIO", Request.Cookies("VBOSS")("ID_USUARIO")), true
 
 Dim objConn, objRS, strSQL, strSQLClause
 Dim strEMPRESA, strDIA_SEMANA, strID_USUARIO
 Dim strCOOKIE_ID_USUARIO, strGRUPO_USUARIO
 Dim strCOLOR

 AbreDBConn objConn, CFG_DB 

 strCOOKIE_ID_USUARIO = LCase(Request.Cookies("VBOSS")("ID_USUARIO"))
 strGRUPO_USUARIO = UCase(Request.Cookies("VBOSS")("GRUPO_USUARIO"))
 
 strCOLOR  = "#DAEEFA"

 strEMPRESA    = GetParam("var_empresa")
 strDIA_SEMANA = GetParam("var_diasemana")
 strID_USUARIO = GetParam("var_id_usuario")

 strSQL =	"SELECT"		&_
			"	COD_HORARIO,"	&_
			"	COD_EMPRESA,"	&_			
			"	ID_USUARIO,"	&_
			"	DIA_SEMANA,"	&_
			"	IN_1,OUT_1,"	&_
			"	IN_2,OUT_2,"	&_
			"	IN_3,OUT_3,"	&_
			"	TOTAL,"	&_
			"	OBS "		&_
			"FROM "		&_
			"	USUARIO_HORARIO "	&_
			"WHERE TRUE"
 if strID_USUARIO<>""  then	strSQL = strSQL & " AND ID_USUARIO='" & strID_USUARIO & "'"
 if strDIA_SEMANA <>"" then strSQL = strSQL & " AND DIA_SEMANA='" & UCase(WeekDayName(strDIA_SEMANA,1,1)) & "'"
 'if strEMPRESA<>"" then 		strSQL = strSQL & " AND COD_EMPRESA='" & strEMPRESA & "'"
 strSQL = strSQL & " ORDER BY COD_HORARIO"
 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1

 if not objRS.Eof then				 
%>
<html>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <!-- Possibilidades de tipo de sort...
  class="sortable-date-dmy"
  class="sortable-currency"
  class="sortable-numeric"
  class="sortable"
 -->
 <thead>
  <tr> 
    <th width="1%"></th>
    <th width="1%"></th>
	<th width="20%" class="sortable">Usuário</th>
    <th width="1%" class="sortable">Dia</th>
	<th width="1%" class="sortable">E1</th>
    <th width="1%" class="sortable">S1</th>
	<th width="1%" class="sortable">E2</th>
    <th width="1%" class="sortable">S2</th>
	<th width="1%" class="sortable">E3</th>
    <th width="1%" class="sortable">S3</th>
    <th width="1%" class="sortable">Total</th>
	<th width="10%" class="sortable">Empresa</th>
	<th width="60%" class="sortable">Obs</th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%	
      While Not objRs.Eof
        strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
%>
	<tr bgcolor=<%=strCOLOR%> valign="middle">
		<td width="1%"><%=MontaLinkGrade("modulo_HORARIO","Delete.asp",GetValue(objRS,"COD_HORARIO"),"IconAction_DEL.gif","REMOVER")%></td>
		<td width="1%"><%=MontaLinkGrade("modulo_HORARIO","Update.asp",GetValue(objRS,"COD_HORARIO"),"IconAction_EDIT.gif","ALTERAR")%></td>
		<td nowrap><%=GetValue(objRS, "ID_USUARIO")%></td>
		<td><%=GetValue(objRS, "DIA_SEMANA")%></td>
		<td><%=GetValue(objRS, "IN_1")%></td>
		<td><%=GetValue(objRS, "OUT_1")%></td>
		<td><%=GetValue(objRS, "IN_2")%></td>
		<td><%=GetValue(objRS, "OUT_2")%></td>
		<td><%=GetValue(objRS, "IN_3")%></td>
		<td><%=GetValue(objRS, "OUT_3")%></td>		
		<td><%=GetValue(objRS, "TOTAL")%></td>
		<td nowrap><%=GetValue(objRS, "COD_EMPRESA")%></td>
		<td><%=GetValue(objRS, "OBS")%></td>		
	</tr>
<%
	   	athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
	wend
%>
  </tbody>  
</table>
</body>
</html>
<%
 end if
 
 FechaRecordSet objRS
 FechaDBConn objConn
%>