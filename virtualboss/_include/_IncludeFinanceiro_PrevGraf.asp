<%
 Dim lcstrVlr, lcstrAux
 Dim lcAcRec, lcAcPag, lcfilGraf, lcGrafConta, lcRec, lcPag, lcDtIni, lcDtFim

 lcGrafConta = GetParam("var_filGrafConta")
 if (lcGrafConta="") then 
   lcGrafConta = -1
 end if

 lcfilGraf   = GetParam("var_filGraf")
 if (lcfilGraf="") then 
   lcfilGraf = Year(Date())
 end if

 lcAcRec  = 0
 lcAcPag  = 0
 lcstrVlr = 0
 lcstrAux = ""

          strSQL = " SELECT CAST(YEAR(DT_VCTO ) AS CHAR(4)) AS ANO "		  
 strSQL = strSQL & "       ,CAST(MONTH(DT_VCTO) AS SIGNED ) AS MES "		  
 strSQL = strSQL & "       ,ROUND(COALESCE(SUM(CASE WHEN PAGAR_RECEBER = 0 THEN VLR_CONTA END), 0)) AS RECEBER "
 strSQL = strSQL & "       ,ROUND(COALESCE(SUM(CASE WHEN PAGAR_RECEBER = 1 THEN VLR_CONTA END), 0)) AS PAGAR   "
 strSQL = strSQL & "  FROM FIN_CONTA_PAGAR_RECEBER "
 
 if (CInt(lcfilGraf)=-1) then 
    lcDtIni = CDate("1" & "/" & Month(Now) & "/" & Year(Now)) 	
	lcDtFim = DateAdd("m", 25, lcDtIni)
	lcDtFim = DateAdd("d", -1, lcDtFim)
	strSQL = strSQL & " WHERE DT_VCTO BETWEEN CAST('" & Year(lcDtIni) & "-" & Month(lcDtIni) & "-" & Day(lcDtIni) & "' AS DATE) " 
	strSQL = strSQL & "   AND CAST('" & Year(lcDtFim) & "-" & Month(lcDtFim) & "-" & Day(lcDtFim) & "' AS DATE) "
 else
	strSQL = strSQL & " WHERE YEAR(DT_VCTO) = " & lcfilGraf
 end if 

 if (CInt(lcGrafConta)<>-1) then 
	strSQL = strSQL & "   AND COD_CONTA = " & lcGrafConta
 End If

 strSQL =  strSQL & " GROUP BY 1,2 "                          
 strSQL =  strSQL & " ORDER BY 1,2 "                         
		  
 Set objRS = objConn.Execute(strSQL)
 While Not objRS.Eof    
  lcRec = getValue(objRS,"RECEBER")
  lcPag = getValue(objRS,"PAGAR")
  
  lcAcRec = lcAcRec + lcRec
  lcAcPag = lcAcPag + lcPag
  
  lcstrAux = lcstrAux & ",['" & MesExtensoAbrev(CInt(getValue(objRS,"MES"))) & " " & getValue(objRS,"ANO")& "', " & Replace(lcRec,",",".") & "," & Replace(lcPag,",",".")& "]"
  
  athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
 Wend 
 
 'Se a consulta não trazer nada, mostra gráfico vazio.
 If lcstrAux = "" Then
   lcstrAux = ",['', 0, 0 ]"
 End IF  
   
 if ((lcAcRec - lcAcPag)>0) then 
   'lcstrVlr = round((lcAcRec + lcAcPag) / (lcAcRec - lcAcPag)) 
   lcstrVlr = round( ((lcAcRec - lcAcPag) * 100) / (lcAcRec + lcAcPag))
 end if
   
 'athDebug lcstrAux &" " & lcfilGraf & " " & lcstrVlr &" "& strSQL, false
%>
 <!--Load the AJAX API-->
 <script type="text/javascript" src="https://www.google.com/jsapi"></script>
 <script type="text/javascript">

 <!-- INI: montagem do GAUGE -------------------------------------------------- //-->
 // Load the Visualization API and the piechart package.
 google.load('visualization', '1', {'packages':['gauge']});
 // Set a callback to run when the Google Visualization API is loaded.
 google.setOnLoadCallback(drawChartGAUGE);
 function drawChartGAUGE() {
    var data = google.visualization.arrayToDataTable([
	  ['Label', 'Value'],
 	  ['profit', <%=lcstrVlr%>]
    ]);

    var options = {
	    width: 300, height: 160,
	    redFrom: 0, redTo: 5,
	    yellowFrom:6, yellowTo: 12,
	    minorTicks: 20
  };

  var chart = new google.visualization.Gauge(document.getElementById('googleGaugeView'));
	  chart.draw(data, options);	  	 
 }
 <!-- FIM: montagem do GAUGE -------------------------------------------------- //-->

 <!-- FIM: montagem do GBARRA -------------------------------------------------- //-->
 // Load the Visualization API and the piechart package.
 google.load('visualization', '1', {'packages':['corechart']});
 // Set a callback to run when the Google Visualization API is loaded.
 google.setOnLoadCallback(drawChartBARRA);
 function drawChartBARRA() {
 	// Create and populate the data table.
	var data = google.visualization.arrayToDataTable([
		['MÊS', 'Receber', 'Pagar'] <%=lcstrAux%>    
	]);
	// Create and draw the visualization.
	new google.visualization.ColumnChart(document.getElementById('googleBarView')).
    draw(data,
        {title:"",
         width:580, height:200,
         hAxis: {title: ""}}
    );
 <!-- FIM: montagem do GBARRA -------------------------------------------------- //-->

}
</script>
<table width="100%" height="100%" border="1" bordercolor="#C9C9C9" cellpadding="0" cellspacing="0">
<tr valign="top">
	<td width="100%">
		<!-- corpo INIC -->
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr> 
            <form name="formgraf" action="main.asp" method="get">
			<td height="22" background="../img/BgBoxTit.gif" style="color:#3C6BC0;">
			    <div style="padding-left:10px">
				<b>Previsões</b>
				<%
				 Dim intCont, intAno
				 intAno = Year(Date())
			     For intCont = (intAno-1) To (intAno+2)
					 response.write ("[")
					 response.write ("<a href=main.asp?var_filGraf=" & intCont & " target='_self' style='color:#3C6BC0;'><span ")
					 if (Cint(lcfilGraf) = intCont) then response.write (" style='text-decoration:underline;' ") end if
					 response.write (">" & intCont & "</span></a>")
					 response.write ("]&nbsp;")
			     Next
				 response.write ("[")
				 response.write ("<a href=main.asp?var_filGraf=" & -1 & " target='_self' style='color:#3C6BC0;'><span ")
				 if (Cint(lcfilGraf) = -1) then response.write (" style='text-decoration:underline;' ") end if
				 response.write (">TODAY UP 24MONTHs")
 				 response.write ("</a>")
				 response.write ("]&nbsp;")
				%> 
                    <input name="var_filGraf" id="var_filGraf"  type="hidden" value="<%=Cint(lcfilGraf)%>" />
                    <select name="var_filGrafConta" id="var_filGrafConta" style="width:120px;" onchange="JavaScript:formgraf.submit(); return false;">
                     <option value="">[conta]</option>
                     <%
                        strSQL = "SELECT COD_CONTA, NOME FROM FIN_CONTA ORDER BY DT_INATIVO, ORDEM, NOME " 
                        Set objRS = objConn.Execute(strSQL) 
                        Do While Not objRS.Eof 
                         response.write("<option value='" & GetValue(objRS,"COD_CONTA") & "' " )
						 if (Cint(GetValue(objRS,"COD_CONTA")) = Cint(lcGrafConta)) then 
						  response.write (" selected='selected' ")
						 end if
						 response.write("'>" & GetValue(objRS,"NOME") & "</option>")
                         objRS.MoveNext
                        Loop
                     %>
                    </select>
				</div>
			</td>
            </form>
		</tr>
		<tr> 
			<td valign="top">
				<table width="100%" border="0" align="left" cellpadding="0" cellspacing="0">
				<tr> 
					<td width="99%" align="left"   id="googleBarView" name="googleBarView"></td>
					<td width="1%"  align="right"  id="googleGaugeView" name="googleGaugeView" style="padding-right:5px;"></td>
				</tr>
				</table>
			</td>
		</tr>
		</table>
		<!-- corpo FIM -->
	</td>
</tr>
</table>