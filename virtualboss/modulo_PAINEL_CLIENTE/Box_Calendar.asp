<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!-- include file="../_scripts/scripts.js"-->
<%
  Dim objConn, objRS, strSQL 
  Dim strDIAS, strBGCELL
  Dim strUserExec, strGRUPO_USUARIO
  
  'strUserExec = GetParam("var_exec")
  'strGRUPO_USUARIO = Request.Cookies("VBOSS")("GRUPO_USUARIO")
  
  Dim dbCurrentDate, strData
  
  dbCurrentDate = GetParam("dtAtual")
  
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



  If not IsDate(dbCurrentDate) Then
    dbCurrentDate = Date()
  End If

  Dim EventDate
	
  If GetParam("dtAtual") <> "" Then
	EventDate = GetParam("dtAtual")
  ElseIf GetParam("var_dia_selected") <> "" Then
	EventDate = GetParam("var_dia_selected") 'era date
  Else
    EventDate = Date()
  End if
  
  Dim CurrentMonth, CurrentMonthName, CurrentYear, FirstDayDate,FirstDay,CurrentDay

  CurrentMonth = Month(EventDate)
  CurrentMonthName = arrMonth(CurrentMonth)
  CurrentYear = Year(EventDate)

  FirstDayDate = DateSerial(CurrentYear, CurrentMonth, 1)
  FirstDay = WeekDay(FirstDayDate, 0)
  CurrentDay = FirstDayDate
%>		
<html>
<head>
<title>vBoss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
</head>
<body>
<table width=150 height="20" border="0" align="center" cellpadding="0" cellspacing="1">
  <tr>
    <td align="center" width="20"><a href="Box_Calendar.asp?dtAtual=<%= DateAdd("m",-1, EventDate)%>" class="calendario"><img src="../img/seta_prev.gif" border="0"></a></td>
	<td align="center"><font><b><%= CurrentMonthName %>/<%= CurrentYear %></b></font></td>
    <td align="center" width="20"><a href="Box_Calendar.asp?dtAtual=<%= DateAdd("m",1,EventDate)%>" class="calendario"><img src="../img/seta_prox.gif" border="0"></a></td>
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
     <td Colspan="<%=FirstDay -1%>">
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
		    <a href="painel.asp?var_dia_agenda_selected=<%=CurrentDay%>" target="_parent" class="corpo_texto_peq"><%=Day(CurrentDay)%></a>
		  </div>
		</td>
     <%
     Else
       if CDate(CurrentDay) = Date() Then 
	 %>
        <td height="16" align="right" class="corpo_texto_peq" background="../img/BGCell00.gif">
			<div style="padding-right:4px;"><%=Day(CurrentDay)%></div>
		</td>
     <%
	   else 
	 %>
        <td height="16" align="right" class="corpo_texto_peq">
			<div style="padding-right:4px;"><%=Day(CurrentDay)%></div>
		</td>
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
     	 <td colspan="<%=8-DayCounter%>"></td>
<%
    End if
%>
	</tr>
	<tr>
    <td colspan="7" align="right" class="texto_ajuda"><%=PrepData(GetParam("var_dia_selected"),true,false)%>&nbsp;&nbsp;</td>
  </tr>
</table>
</body>
</html>
