<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!-- include file="../_scripts/scripts.js"-->
<%
  Dim objConn, objRS, strSQL 
  Dim strDIAS, strBGCELL
  Dim strUserExec
  Dim DayLoop
  Dim DayCounter, CorrectMonth
  Dim dbCurrentDate, strData
  Dim EventDate
  Dim CurrentMonth, CurrentMonthName, CurrentYear, FirstDayDate,FirstDay,CurrentDay
  
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
  arrDiaSemanaAbrev(1) = "Dom"
  arrDiaSemanaAbrev(2) = "Seg"
  arrDiaSemanaAbrev(3) = "Ter"
  arrDiaSemanaAbrev(4) = "Qua"
  arrDiaSemanaAbrev(5) = "Qui"
  arrDiaSemanaAbrev(6) = "Sex"
  arrDiaSemanaAbrev(7) = "Sab"
  
  strUserExec   = GetParam("var_exec")
  dbCurrentDate = GetParam("dtAtual")

  If not IsDate(dbCurrentDate) Then
    dbCurrentDate = Date()
  End If
	
  If dbCurrentDate <> "" Then
	EventDate = dbCurrentDate
  Else
	EventDate = GetParam("var_dia_selected") 'era date
  End if

  CurrentMonth     = Month(EventDate)
  CurrentMonthName = arrMonth(CurrentMonth)
  CurrentYear      = Year(EventDate)

  FirstDayDate = DateSerial(CurrentYear, CurrentMonth, 1)
  FirstDay     = WeekDay(FirstDayDate, 0)
  CurrentDay   = FirstDayDate

%>		
<html>
<head>
<title>vBoss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
</head>
<body bgcolor="#FFFFFF" style="margin:10px;">
<!-- table height="20" border="0" align="center" cellpadding="0" cellspacing="1">
  <tr>
    <td align="center" width="20"><a href="Box_CalendarBig.asp?dtAtual=<%= DateAdd("m",-1, EventDate)%>&var_exec=<%=strUserExec%>" class="calendario"><img src="../img/seta_prev.gif" border="0"></a></td>
	 <td align="center"><font><b><%= CurrentMonthName %>/<%= CurrentYear %></b></font></td>
    <td align="center" width="20"><a href="Box_CalendarBig.asp?dtAtual=<%= DateAdd("m",1,EventDate)%>&var_exec=<%=strUserExec%>" class="calendario"><img src="../img/seta_prox.gif" border="0"></a></td>
  </tr>
</table -->  


<table width='100%' height="100%" cellpadding="0" cellspacing="0" style="border:0px solid #C3D9FF;">
<tr>
<td height="16">
	<table width='100%' cellpadding="0" cellspacing="0" style="border:1px solid #C3D9FF;">
	  <tr height="16" class="calendario" bgcolor="#C3D9FF">
		<% For DayLoop = 1 to 7 %>    	 
		<td align="center"><%=arrDiaSemanaAbrev(Dayloop)%></td>
		<% Next %>
	  </tr>
	  <tr height="2"><td colspan="7"></td></tr>
	</table>
</td>
</tr>
<tr>
<td height="99%">  
	<table width='100%' height="100%" cellpadding="0" cellspacing="0" style="border-left:1px solid #C3D9FF;">
	  <tr bgcolor="#FFFFFF" height="14%">
		<%
	   If FirstDay <> 1 Then
		%>
		 <td Colspan='<%=FirstDay -1%>' style="border-right:1px solid #C3D9FF;border-bottom:1px solid #C3D9FF;">&nbsp;
		<%
	   End if
	   
	   DayCounter = FirstDay
	   CorrectMonth = True
	   
	   Do While CorrectMonth = True
			 strBGCELL = "0px solid #FFFFFF;"
			 if CDate(CurrentDay) = Date() Then
			   strBGCELL = "1px solid #003366;"
			 end if
	
		 %>
			<td width="14%" align="right" valign="top" class="corpo_texto_peq" style="border-right:1px solid #C3D9FF;border-bottom:1px solid #C3D9FF;">
			  <div style="padding-right:4px; background-color:#E8EEF7; border:<%=strBGCELL%>"><%=Day(CurrentDay)%></div>
			  <div style="width:100%; height:100%">
				
				  <% if Day(CurrentDay)=17 then response.Write("[KERNELPS - Financeiro]<br>[REUNIÃO - Equipes de Produção]") %> 
		
			  </div>
			</td>
		 <%
		 DayCounter = DayCounter + 1
		 If DayCounter > 7 then
			 DayCounter = 1
		%>
		 </tr>
		 <tr bgcolor="#FFFFFF" height="14%">
		<%
		  End if
		  CurrentDay = DateAdd("d", 1, CurrentDay)
	
		  If (Month(CurrentDay) <> CurrentMonth) then CorrectMonth=False End if
	   Loop
	   %>
		</tr>
	  </tr>
	</table>
</td>
</tr>
</table>
</body>
</html>
