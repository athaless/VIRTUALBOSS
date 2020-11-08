<%
  Dim strDIAS, strBGCELL

  Dim dbCurrentDate, strData
  
  dbCurrentDate = GetParam("var_dt_atual")
  
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

  if GetParam("var_dt_atual") <> "" then
	  EventDate = GetParam("var_dt_atual")
  else
     EventDate = Date()'GetParam("var_dia_selected") 'era date
  end if

  Dim CurrentMonth, CurrentMonthName, CurrentYear, FirstDayDate,FirstDay,CurrentDay

  CurrentMonth = Month(EventDate)
  CurrentMonthName = arrMonth(CurrentMonth)
  CurrentYear = Year(EventDate)

  FirstDayDate = DateSerial(CurrentYear, CurrentMonth, 1)
  FirstDay = WeekDay(FirstDayDate, 0)
  CurrentDay = FirstDayDate

  AbreDBConn objConn, CFG_DB
	
  strSQL = " SELECT DISTINCT Day(T1.DT_VCTO) AS DIA " &_
		   "   FROM FIN_CONTA_PAGAR_RECEBER T1, FIN_CONTA T2 " &_
		   "  WHERE (T1.SITUACAO = 'ABERTA' OR T1.SITUACAO = 'LCTO_PARCIAL') " &_
		   "    AND Month(T1.DT_VCTO) = " & CurrentMonth &_
		   "    AND Year(T1.DT_VCTO) = " & CurrentYear &_
		   "    AND T1.SYS_DT_CANCEL IS NULL " &_
		   "    AND T1.COD_CONTA = T2.COD_CONTA " 

  Set objRS = objConn.Execute(strSQL)
	
  strDIAS = ","
  Do While Not objRS.Eof 
	 strDIAS = strDIAS & GetValue(objRS,"DIA") & "," 
	 objRS.MoveNext
  Loop
  'response.write strdias
%>		
<table width=150 height="20" border="0" align="center" cellpadding="0" cellspacing="1">
  <tr>
    <td align="center" width="20"></td>
	 <td align="center" valign="top"><font><b><%=CurrentMonthName%>/<%=CurrentYear%></b></font></td>
    <td align="center" width="20"></td>
  </tr>
</table>
<table width=130 border="0" bordercolor="<%=strGRADE_CORHEADER2%>" align="center" cellpadding="0" cellspacing="0" cols="7">
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
        <td height="16" align="right" background="../img/<%=strBGCELL%>" class="corpo_texto_peq">
		  <div style="padding-right:2px;">
		    <a href="../modulo_FIN_TITULOS/main.asp?var_situacao=_LCTO_TOTAL&var_dt_ini=<%=CurrentDay%>&var_dt_fim=<%=CurrentDay%>" target="_self" class="corpo_texto_peq"><%=Day(CurrentDay)%></a>
		  </div>
		</td>
     <%
     Else
       if CDate(CurrentDay) = Date() Then 
	 %>
        <td height="16" align="right" class="corpo_texto_peq" background="../img/BGCell00.gif">
		  <div style="padding-right:2px;">
		  <a href="../modulo_FIN_TITULOS/main.asp?var_situacao=_LCTO_TOTAL&var_dt_ini=<%=CurrentDay%>&var_dt_fim=<%=CurrentDay%>" target="_self" class="corpo_texto_peq"><%=Day(CurrentDay)%></a>
		  </div>
		</td>
     <%
	   else 
	 %>
        <td height="16" align="right" class="corpo_texto_peq"><div style="padding-right:2px;"><%=Day(CurrentDay)%></div></td>
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
	<tr><td colspan="7" align="right" class="texto_ajuda"><%=EventDate%>&nbsp;&nbsp;</td></tr>
</table>
<%
	'FechaDBConn objConn
%>