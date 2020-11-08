<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!-- include file="../_scripts/scripts.js"-->
<%
  Dim objConn, objRS, strSQL 
  Dim strDIAS, strBGCELL, strVIEW
	
  Dim dbCurrentDate, strData
  
  dbCurrentDate = GetParam("dtAtual")
  strVIEW = GetParam("var_view")
  
  Dim arrMonth(12)
  arrMonth(1) = "Janeiro"
  arrMonth(2) = "Fevereiro"
  arrMonth(3) = "Março"
  arrMonth(4) = "Abril"
  arrMonth(5) = "Maio"
  arrMonth(6) = "Junho"
  arrMonth(7) = "Julho"
  arrMonth(8) = "Agosto"
  arrMonth(9) = "Setembro"
  arrMonth(10) = "Outubro"
  arrMonth(11) = "Novembro"
  arrMonth(12) = "Dezembro"


  Dim arrDiaSemana(7)
  arrDiaSemana(1) = "Domingo"
  arrDiaSemana(2) = "Segunda"
  arrDiaSemana(3) = "Terça"
  arrDiaSemana(4) = "Quarta"
  arrDiaSemana(5) = "Quinta"
  arrDiaSemana(6) = "Sexta"
  arrDiaSemana(7) = "Sábado"

  Dim arrDiaSemanaAbrev(7)
  arrDiaSemanaAbrev(1) = "D"'om"
  arrDiaSemanaAbrev(2) = "S"'eg"
  arrDiaSemanaAbrev(3) = "T"'er"
  arrDiaSemanaAbrev(4) = "Q"'ua"
  arrDiaSemanaAbrev(5) = "Q"'ui"
  arrDiaSemanaAbrev(6) = "S"'ex"
  arrDiaSemanaAbrev(7) = "S"'ab"


  if not IsDate(dbCurrentDate) then
    dbCurrentDate = Date()
  end If

  Dim EventDate

  if GetParam("dtAtual") <> "" then
	  EventDate = GetParam("dtAtual")
  else
     EventDate = GetParam("var_dia_selected") 'era date
  end if

  Dim CurrentMonth, CurrentMonthName, CurrentYear, FirstDayDate,FirstDay,CurrentDay
  Dim strID_USUARIO
  
  strID_USUARIO = Request.Cookies("VBOSS")("ID_USUARIO")
  
  CurrentMonth = Month(EventDate)
  CurrentMonthName = arrMonth(CurrentMonth)
  CurrentYear = Year(EventDate)

  FirstDayDate = DateSerial(CurrentYear, CurrentMonth, 1)
  FirstDay = WeekDay(FirstDayDate, 0)
  CurrentDay = FirstDayDate

  AbreDBConn objConn, CFG_DB
  
' CONSULTA ORIGINAL DE DATAS PARA ToDo's/TODOLIST (tarefas)
' Consulta somente os dias em que há tarefas onde o usuário 
' é responsável ou executor	
'
'  strSQL = " SELECT DISTINCT DatePart('D', PREV_DT_INI) AS DIA " &_
'		   "   FROM TL_TODOLIST WHERE SITUACAO <> 'FECHADO' " &_
'		   "    AND DatePart('M', PREV_DT_INI) = " & CurrentMonth &_
'		   "    AND DatePart('YYYY', PREV_DT_INI) = " & CurrentYear  &_
'		   "    AND (ID_ULT_EXECUTOR = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' OR ID_RESPONSAVEL = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "')"
'
' Consulta os dias em que há tarefas ou bs onde o usuário é 
' responsável, executor ou membro da equipe
  strSQL = 	"SELECT DISTINCT"										&_
				"	BS.ID_RESPONSAVEL AS BS_RESPONSAVEL,"		&_
				"	TL.ID_RESPONSAVEL,"								&_
				"	TL.SITUACAO,"										&_				
				"	Day(TL.PREV_DT_INI) AS DIA "		&_								
				"FROM"													&_
				"	TL_TODOLIST TL "									&_
				"LEFT OUTER JOIN"										&_
				"	BS_BOLETIM BS ON (BS.COD_BOLETIM=TL.COD_BOLETIM) "					&_
				"WHERE TL.SITUACAO<>'FECHADO' AND"											&_
				"	Month(TL.PREV_DT_INI)=" & CurrentMonth & " AND" 			&_
				"	Year(TL.PREV_DT_INI)=" & CurrentYear & " AND"		
if strVIEW="" then 
	strSQL = strSQL & "	(TL.ID_ULT_EXECUTOR='" & strID_USUARIO & "')"
else 
	strSQL = strSQL & "	(TL.ID_RESPONSAVEL='" & strID_USUARIO & "')" 
end if
'Response.Write(strSQL)				
'Response.End()
  Set objRS = objConn.Execute(strSQL)

  strDIAS = ","

	'OCULTO aparece SOMENTE para MANAGER, RESPONSAVEL pelo BS ou RESPONSAVEL pela TAREFA
	while (GetValue(objRS,"SITUACAO")="OCULTO" and GetValue(objRS,"BS_RESPONSAVEL")<>strID_USUARIO and GetValue(objRS,"ID_RESPONSAVEL")<>strID_USUARIO)
		objRS.MoveNext
	wend
	if not objRS.eof then
		while not objRS.eof
			if not objRS.eof then strDIAS = strDIAS & GetValue(objRS,"DIA") & ","
			objRS.MoveNext
			while (GetValue(objRS,"SITUACAO")="OCULTO" and GetValue(objRS,"BS_RESPONSAVEL")<>strID_USUARIO and GetValue(objRS,"ID_RESPONSAVEL")<>strID_USUARIO)
				objRS.MoveNext
			wend	
		wend
	end if
%>		
<html>
<head>
<title>vBoss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
</head>
<body bgcolor="#F7F7F7" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width=150 height="20" border="0" align="center" cellpadding="0" cellspacing="1">
  <tr>
    <td align="center" width="20"><a href="box_calendar.asp?dtAtual=<%= DateAdd("m",-1, EventDate)%>" class="calendario"><img src="../img/seta_prev.gif" border="0"></a></td>
	 <td align="center"><font><b><%= CurrentMonthName %>/<%= CurrentYear %></b></font></td>
    <td align="center" width="20"><a href="box_calendar.asp?dtAtual=<%= DateAdd("m",1,EventDate)%>" class="calendario"><img src="../img/seta_prox.gif" border="0"></a></td>
  </tr>
</table>
  
<table width=150 border="0" bordercolor="#CCCCCC" align="center" cellpadding="0" cellspacing="0" cols="7">
  <tr>
<% Dim DayLoop
   For DayLoop = 1 to 7%>    	 
    <td width="21" height="16" align="center" class="calendario"><%=arrDiaSemanaAbrev(Dayloop)%></td>
<% Next%>
  </tr>
  <tr bgcolor="#FFFFFF">
<%
   If FirstDay <> 1 Then
%>
     <td colspan="<%=FirstDay -1%>">
<%
   End if
   Dim DayCounter, CorrectMonth
   DayCounter = FirstDay
   CorrectMonth = True
   
   Do While CorrectMonth = True
     'response.write "," & CStr(DatePart("D", CurrentDay)) & ","

	 If InStr(strDIAS, "," & CStr(DatePart("D", CurrentDay)) & ",") > 0 Then
         if CDate(CurrentDay) < Date() Then
	       strBGCELL = "BGCell02.gif"
	     else 
           if CDate(CurrentDay) > Date() Then 
		     strBGCELL = "BGCell03.gif" 
		   else 
			 strBGCELL = "BGCell01.gif" 
		   end if
	     end if
	 %>
        <td height="16" align="right" background="../img/<%=strBGCELL%>">
		  <div style="padding-right:4px;">
		    <a href="painel.asp?var_dia_selected=<%=CurrentDay%>&var_view=<%=strVIEW%>" target="_parent" class="corpo_texto_peq"><%=Day(CurrentDay)%></a>
		  </div>
		</td>
     <%
     Else
       if CDate(CurrentDay) = Date() Then 
	 %>
        <td height="16" align="right" class="corpo_texto_peq" background="../img/BGCell00.gif">
		  <div style="padding-right:4px;">
		  <a href="painel.asp?var_dia_selected=<%=CurrentDay%>&var_view=<%=strVIEW%>" target="_parent" class="corpo_texto_peq"><%=Day(CurrentDay)%></a>
		  </div>
		</td>
     <%
	   else 
	 %>
        <td height="16" align="right" class="corpo_texto_peq"><div style="padding-right:4px;"><%=Day(CurrentDay)%></div></td>
     <%
	   end if

     End if
 	 DayCounter = DayCounter + 1
	 If DayCounter > 7 then
    	 DayCounter = 1
%>
	 </tr>
	 <tr bgcolor="#FFFFFF">
<%
      End if
   	  CurrentDay = DateAdd("d", 1, CurrentDay)

	  If (Month(CurrentDay) <> CurrentMonth) then CorrectMonth=False End if
   Loop
   IF DayCounter <> 1 Then
%>
     	 <td colspan="<%=8-DayCounter%>"> </td>
<%
    End if
%>
	</tr>
	<tr><td Colspan="7" align="right" class="texto_ajuda"><%=PrepData(GetParam("var_dia_selected"),true,false)%>&nbsp;&nbsp;</td></tr>
</table>
</body>
</html>
<%
	FechaDBConn objConn
%>