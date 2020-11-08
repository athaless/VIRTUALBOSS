<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
 Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_PONTO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
 <!--#include file="../_database/athUtils.asp"--> 
<%
  Dim objConn, objRS, strSQL, strSqlFC, strClaus 
  Dim strNome,strEmp,strData,strStatus, arrFeriados, auxMAXENTER, strUserUF
  Dim strMes, strAno, staFirst, selNome, selAno, selMes, selStatus, strBGCOLOR, strCURSOR
  Dim strAcc, strAccPrev, strAccDif, strAccDesc, strTotal, strTotalAc, strAcPos, strAcNeg
  Dim PossoEditar, strAux, strAuxNew, AuxDiaSemana, AuxDiaFeriado, strLEGENDA, auxDifDay, i
  Dim auxCONT, auxDiaAtual, auxMesAtual, auxTOTALprevisto, auxTOTAL, auxOBS, auxCHECKDT, flagEMPRESA, flagDADOS_EXIBIDOS
  Dim strTotalDesc, strTotalSaldo, strDESCONTO
  Dim objRSDesc, auxDifHour
  Dim strCOLOR 

  Dim auxDirUpd
  auxDirUpd = VerificaDireito("|UPD_ALL_PONTO|", BuscaDireitosFromDB("modulo_PONTO", Request.Cookies("VBOSS")("ID_USUARIO")), false)
  
  AbreDBConn objConn, CFG_DB          

  '----------------------------------------------------------------------------
  'INIC: Área de funções ------------------------------------------------------		
  '----------------------------------------------------------------------------
  Function BuscaTotalPrevisto(prID_USUARIO, prDIA_SEMANA)
  	Dim objRSPrev

	If prID_USUARIO <> "" Then
	  	Set objRSPrev = objConn.Execute("SELECT TOTAL FROM USUARIO_HORARIO WHERE ID_USUARIO = '" & prID_USUARIO & "' AND DIA_SEMANA = '" & prDIA_SEMANA & "'")
		If Not objRSPrev.Eof Then
			BuscaTotalPrevisto = objRSPrev("TOTAL")
			strAccPrev = strAccPrev + TSec(objRSPrev("TOTAL"))
		Else
			BuscaTotalPrevisto = ""
		End If
		FechaRecordSet objRSPrev
	Else
		BuscaTotalPrevisto = ""
	End If
  End Function

  Function BuscaTotalDesconto(prID_USUARIO, prMES, prANO)
  	Dim objRSDesc, TotalDesc

	strSQL =          " SELECT TOTAL_HR, TOTAL_MIN "
	strSQL = strSQL & "   FROM PT_DESCONTO "
	strSQL = strSQL & "  WHERE ID_USUARIO = '" & prID_USUARIO & "' "
	If prMES <> "" Then strSQL = strSQL & " AND MES = " & prMES 
	strSQL = strSQL & " AND ANO = " & prANO 
	
	Set objRSDesc = objConn.Execute(strSQL) 
	
	TotalDesc = 0
	Do While Not objRSDesc.Eof
		If GetValue(objRSDesc, "TOTAL_HR") <> "" And GetValue(objRSDesc, "TOTAL_MIN") <> "" Then
			TotalDesc = TotalDesc + TSec(GetValue(objRSDesc, "TOTAL_HR") & ":" & GetValue(objRSDesc, "TOTAL_MIN"))
		End If
		
		objRSDesc.MoveNext
	Loop
	
	FechaRecordSet objRSDesc
	
	BuscaTotalDesconto = TotalDesc
  End Function

'------------------------------------------------------------------
' FUNÇÕES PARA TRATAMENTO DOS FERIADOS
'------------------------------------------------------------------
  Public Function IndexOfFeriados(pr_array, pr_campo1, pr_campo2)
  Dim i
	IndexOfFeriados = CInt(-1)
	For i = 0 To UBound(pr_array)
		If (pr_array(i) = pr_campo1) or (pr_array(i) = pr_campo2) then
			IndexOfFeriados = CInt(i)
		End If	 
	Next
  End Function

  Function BuscaUfUser(prID_USUARIO)
	Dim	objRSLocal, strSQLLocal, strUserTlbCOD, strUserTlbNAME, strUserUF

	'INI: Busca UF do user (conforme o seu estado trará os seus respectivos feriados, mais abaixo) ----------------------------------
	strSQLLocal = " SELECT CODIGO, TIPO FROM USUARIO WHERE ID_USUARIO LIKE '" & prID_USUARIO & "' "
	set objRSLocal = objConn.Execute(strSQLLocal)
	If Not objRSLocal.Eof Then
		strUserTlbCOD  = GetValue(objRSLocal, "CODIGO")
		strUserTlbNAME = lcase(GetValue(objRSLocal, "TIPO"))
	End If
	FechaRecordSet objRSLocal

	strSQLLocal = " SELECT "
    if (strUserTlbNAME="ent_colaborador") then
	  strSQLLocal = strSQLLocal & " ESTADO as UF" 
	else 
	  strSQLLocal = strSQLLocal & " ENTR_ESTADO as UF"
	end if  
	strSQLLocal = strSQLLocal & "   FROM " & strUserTlbNAME
	strSQLLocal = strSQLLocal & "  WHERE COD_" & replace(strUserTlbNAME,"ent_","") & " = " & strUserTlbCOD
	set objRSLocal = objConn.Execute(strSQLLocal)
	If Not objRSLocal.Eof Then strUserUF = GetValue(objRSLocal, "UF")
	FechaRecordSet objRSLocal
	'FIM: Busca UF do user (conforme o seu estado trará os seus respectivos feriados, mais abaixo) ----------------------------------
	BuscaUfUser = strUserUF
  End Function

  Function BuscaFeriados(prUF_USUARIO)
  	Dim objRSFer, auxSTR, auxSQL

    auxSQL = "         SELECT DATA_DIA, DATA_MES, DATA_ANO, UF FROM PT_FERIADO "
	auxSQL = auxSQL & " WHERE ( (UF='"&prUF_USUARIO&"') OR (UF is NULL) OR (UF='') ) "
	auxSQL = auxSQL & "ORDER BY DATA_ANO, DATA_MES, DATA_DIA"
  	Set objRSFer = objConn.Execute(auxSQL)
	
	auxSTR = ""
	while Not objRSFer.Eof 
	  if (GetValue(objRSFer, "DATA_DIA") <> "") And (GetValue(objRSFer, "DATA_MES") <> "") And (GetValue(objRSFer, "DATA_ANO") <> "") Then
		auxSTR = auxSTR & Cint(GetValue(objRSFer, "DATA_DIA")) & "/" & Cint(GetValue(objRSFer, "DATA_MES")) & "/" & Cint(GetValue(objRSFer, "DATA_ANO")) & ","
	  end if
	  athMoveNext objRSFer, ContFlush, CFG_FLUSH_LIMIT
	Wend
	FechaRecordSet objRSFer
	BuscaFeriados = auxSTR
  End Function
  
  'Função que identifica se a data esta no array de feriados
  Function DiaDeFeriado(prARRAY, prDIA, prMES, prANO)
    Dim strDATA1, strDATA2
		
    strDATA1 = Cint(prDIA)&"/"&Cint(prMES)&"/0"
	strDATA2 = Cint(prDIA)&"/"&Cint(prMES)&"/"&Cint(prANO)

' Foi substituida pela nova função IndexOfFeriados que pega 2 parametros para teste	
'   If ArrayIndexOf(prARRAY, strDATA1) > -1 Then
    If IndexOfFeriados(prARRAY, strDATA1, strDATA2) > -1 Then
	  DiaDeFeriado = True
	Else
	  DiaDeFeriado = False
	End If
  End Function
  '----------------------------------------------------------------------------
  'FIM: Área de funções -------------------------------------------------------		
  '----------------------------------------------------------------------------
  
  staFirst = false
  strTotalAc = 0			 
  
  strNome     = GetParam("selNome")
  strEmp      = GetParam("selEmp")
  strStatus   = GetParam("selStatus")
  strMes      = GetParam("selMes")
  strAno      = GetParam("selAno")

  flagEMPRESA = ( len(strEmp) = 0 or strEmp = "Todos" )
  if len(strMes) <= 0 then
	strMes = month(date)
	if len(strMes) = 1 then
		strMes = "0" & strMes
		staFirst = true
	end if
  end if
  if len(strAno) <= 0 then strAno = Year(Date) end if


  strSql   = "SELECT PT_PONTO.COD_PONTO, PT_PONTO.ID_USUARIO, PT_PONTO.COD_EMPRESA" &_ 
             "      ,PT_PONTO.DATA_DIA, PT_PONTO.DATA_MES, PT_PONTO.DATA_ANO, PT_PONTO.HORA_IN, PT_PONTO.HORA_OUT " &_ 
			 "      ,PT_PONTO.STATUS, PT_TOT.TOTAL, PT_PONTO.OBS " 
  if flagEMPRESA then
    strSQL = strSQL & " FROM ( PT_PONTO LEFT JOIN PT_TOTAL_DIA as PT_TOT " &_ 
	                  "   ON ( PT_PONTO.ID_USUARIO = PT_TOT.ID_USUARIO " 
  else
    strSQL = strSQL & " FROM ( PT_PONTO LEFT JOIN PT_TOTAL_DIA_EMPRESA as PT_TOT " &_ 
	                  "   ON ( PT_PONTO.ID_USUARIO = PT_TOT.ID_USUARIO AND PT_PONTO.COD_EMPRESA = PT_TOT.COD_EMPRESA "
  end if
  strSQL = strSQL & " AND PT_PONTO.DATA_ANO = PT_TOT.DATA_ANO " &_
			        " AND PT_PONTO.DATA_MES = PT_TOT.DATA_MES " &_
			        " AND PT_PONTO.DATA_DIA = PT_TOT.DATA_DIA )  )"		 
  
  strSqlFC = "SELECT Count(COD_PONTO) as MAX_ENT_DIA FROM PT_PONTO " 
  
  strClaus = ""
  if strMes = "Todos" and strNome = "Todos" then staFirst = true
	if strMes = "Todos" then
		if len(strNome) =  0 or strNome = "Todos" then
			if len(strEmp) = 0 or strEmp = "Todos" then
				strClaus = strClaus & " WHERE PT_PONTO.DATA_ANO = " & strAno
				strNome = "Todos"
				strEmp = "Todos"
				strStatus = "Todos"				
			else
				strClaus = strClaus & " WHERE PT_PONTO.COD_EMPRESA = '" & strEmp & "' and PT_PONTO.DATA_ANO = " & strAno' & "' and status = " & strStatus
			end if
		else
			if len(strEmp) = 0 or strEmp = "Todos" then
				strClaus = strClaus & " WHERE PT_PONTO.ID_USUARIO = '" & strNome & "' and PT_PONTO.DATA_ANO = " & strAno
				strEmp = "Todos"
			else
				strClaus = strClaus & " WHERE PT_PONTO.ID_USUARIO = '" & strNome & "' and PT_PONTO.COD_EMPRESA = '" & strEmp & "' and PT_PONTO.Data_ano = " & strAno				
			end if
		end if
	else	
		if len(strNome) =  0 or strNome = "Todos" then
			if len(strEmp) = 0 or strEmp = "Todos" then
				strClaus = strClaus & " WHERE PT_PONTO.Data_mes = " & strMes & " and PT_PONTO.Data_ano = " & strAno
				strNome = "Todos"
				strEmp = "Todos"
				strStatus = "Todos"								
			else
				strClaus = strClaus & " WHERE PT_PONTO.COD_EMPRESA = '" & strEmp & "' and PT_PONTO.Data_mes = " & strMes & " and PT_PONTO.Data_ano = " & strAno '& " and status = " & strStatus
			end if
		else
			if len(strEmp) = 0 or strEmp = "Todos" then
				strClaus = strClaus & " WHERE PT_PONTO.ID_USUARIO = '" & strNome & "' and PT_PONTO.Data_mes = " & strMes & " and PT_PONTO.Data_ano = " & strAno
				strEmp = "Todos"
			else
				strClaus = strClaus & " WHERE PT_PONTO.ID_USUARIO = '" & strNome & "' and PT_PONTO.COD_EMPRESA = '" & strEmp & "' and PT_PONTO.Data_mes = " & strMes & " and PT_PONTO.Data_ano = " & strAno			
			end if
		end if
	end if

  strSql   = strSql   & strClaus & " ORDER BY PT_PONTO.ID_USUARIO, PT_PONTO.DATA_ANO, PT_PONTO.DATA_MES, PT_PONTO.DATA_DIA, PT_PONTO.HORA_IN"	
  strSqlFC = strSqlFC & strClaus & " GROUP BY DATA_DIA, DATA_MES, ID_USUARIO ORDER BY 1 DESC LIMIT 1 " 

  auxMAXENTER = 1
  'athdebug strSql & "<BR><BR>" & strSqlFC & "<BR><BR>", false
  set objRS = ObjConn.Execute (strSqlFC)
  if not objRS.EOF then auxMAXENTER = CInt(GetValue(objRS, "MAX_ENT_DIA"))
  FechaRecordSet objRS

  'athdebug strSql & "<BR><BR>" & strSqlFC & "<BR><BR>", false
  'athdebug auxMAXENTER, false
  
  If Not IsNumeric(auxMAXENTER) Then auxMAXENTER = 1
  
  flagDADOS_EXIBIDOS = False
  
  set objRS = ObjConn.Execute (strSQL)
%>
<html>
<head>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body>
	<!-- 
	 ****************************************************
	 INIC: Exibe grade de pontos...                     *
	 ****************************************************
	-->
	<% 	
	if not objRS.BOF and not objRS.EOF Then 
	 flagDADOS_EXIBIDOS = True
	 
	 strUserUF   = BuscaUFUser(strNome) 
	 arrFeriados = BuscaFeriados(strUserUF)
	 arrFeriados = split(arrFeriados,",")
	%>
        <table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
         <thead>
          <tr> 
            <th width="1%"></th>
            <th width="90%" class="sortable" nowrap>Usuário</th>
            <th width="1%" class="sortable-date-dmy" nowrap>Data</th>
            <th width="1%" class="sortable" nowrap>Dia</th>
			<% 
			for i=1 to auxMAXENTER 
			%>
              <th class="sortable" nowrap></th>
              <th nowrap>E<%=i%></th>
              <th nowrap>S<%=i%></th>
			<% 
			next
			%>
            <th class="sortable" nowrap><b>Total</b></th>
			<% if flagEMPRESA then response.write ("<th class='sortable' nowrap><b>Prev.Diária</b></th>") end if %>
            <th width="10"></th>
          </tr>
          </thead>
 		  <tbody style="text-align:left;">
			<%
			 i = 0 
			 strAcc = 0 
			 strAccPrev = 0 
			 strAccDif = 0 
			 strAccDesc = 0 
			%>
			<!-- 
			 ****************************************************
             INIC: Laço principal                               *
			 ****************************************************
			-->
			<%
			 while not objRS.EOF
			    strBGCOLOR = "#F5FAFA" ' "#CDD8EB"
				strLEGENDA = ""
				auxDifDay = Abs(DateDiff("D", Date, GetValue(objRS, "DATA_DIA")&"/"&GetValue(objRS, "DATA_MES")&"/"&GetValue(objRS, "DATA_ANO")))
			    PossoEditar = ((Request.Cookies("VBOSS")("ID_USUARIO") = GetValue(objRS, "ID_USUARIO")) AND (auxDifDay <= 4)) 
			    PossoEditar = PossoEditar OR (Request.Cookies("VBOSS")("GRUPO_USUARIO") = "SU") 
			    PossoEditar = PossoEditar OR (auxDirUpd)
				 
				AuxDiaSemana = DiaDaSemana(GetValue(objRS, "DATA_DIA"),GetValue(objRS, "DATA_MES"),GetValue(objRS, "DATA_ANO"))
				if AuxDiaSemana = "DOM" or AuxDiaSemana = "SAB" then 
				  strBGCOLOR = "#EAEDFD" 
				  strLEGENDA = "Final de Semana"
				end if
				'Nova função para verificar se o dia esta no array de feriados
				AuxDiaFeriado = DiaDeFeriado(arrFeriados,GetValue(objRS, "DATA_DIA"),GetValue(objRS, "DATA_MES"),GetValue(objRS, "DATA_ANO"))
				if AuxDiaFeriado then 
				  strBGCOLOR = "#99BBDD" 
				  strLEGENDA = "Feriado"
				end If
				If PossoEditar = True Then strCURSOR = "cursor:hand;height:20px" else strCURSOR = "cursor:arrow;height:20px" End If		 
	            if strNome = "Todos" and strMes <> "Todos" or staFirst then strAux = GetValue(objRS, "ID_USUARIO") else strAux = GetValue(objRS, "DATA_MES") end if 
          %>
          <tr style="<%=strCURSOR%>" onMouseOver="this.style.backgroundColor='#DEECEF';" onMouseOut="this.style.backgroundColor='';" bgcolor="<%=strBGCOLOR%>" title="<%=strLEGENDA%>"> 
            <td>
			<% 'If PossoEditar or (Request.Cookies("VBOSS")("GRUPO_USUARIO") = "SU") Then %>
			<% If PossoEditar Then %>
			  <%=MontaLinkGrade("modulo_PONTO", "delete.asp", GetValue(objRS, "ID_USUARIO") & "&var_dia=" & GetValue(objRS, "DATA_DIA") & "&var_mes=" & GetValue(objRS, "DATA_MES") & "&var_ano=" & GetValue(objRS, "DATA_ANO"), "IconAction_DEL.gif", "Remove um registro do dia")%>
			<% end if %>
			</td>
            <td class="texto_chamada_peq"><%=GetValue(objRS, "ID_USUARIO")%></td>
            <td class="texto_chamada_peq"><%=GetValue(objRS, "DATA_DIA")&"/"&GetValue(objRS, "DATA_MES")&"/"&Mid(GetValue(objRS, "DATA_ANO"), 3, 2)%></td>
            <td class="texto_chamada_peq" nowrap align="left">
			 <% if GetValue(objRS, "TOTAL") = "" then %>
			   <a href="tmpRCT.asp?var_empresa=<%=strEmp%>&var_id_usuario=<%=GetValue(objRS, "ID_USUARIO")%>&var_dt_dia=<%=GetValue(objRS, "DATA_DIA")%>&var_dt_mes=<%=GetValue(objRS, "DATA_MES")%>&var_dt_ano=<%=GetValue(objRS, "DATA_ANO")%>" title="Calcular">CT</a>&nbsp;
			 <% end if %>
			 <%=AuxDiaSemana%>
			</td>
			<!-- 
			 *******************************************************
             INIC: Laço interno ... repete essa parte por dia... 
			 *******************************************************
			-->
			<% 
			On Error resume Next
			auxCONT = 1
			auxOBS  = ""
			do 
			  auxDiaAtual = GetValue(objRS, "DATA_DIA") 
			  auxMesAtual = GetValue(objRS, "DATA_MES") 
			  
			%>
            <td <% If PossoEditar Then 
					If (Request.Cookies("VBOSS")("GRUPO_USUARIO") = "MANAGER") OR (auxDirUpd) Then 
						response.write ("style='cursor:pointer;' onClick=""window.location='update.asp?var_chavereg=" & GetValue(objRS, "COD_PONTO") & "'""") 
					Else
						response.write ("style='cursor:pointer;' onClick=""window.location='loginadmin.ASP?var_chavereg=" & GetValue(objRS, "COD_PONTO") & "&var_location=update_exec.asp'""") 
					End If
                    response.write ("style='cursor:pointer;' onClick=""window.location='update.asp?var_chavereg=" & GetValue(objRS, "COD_PONTO") & "'""") 
				   End If 
				%>>
				<% If PossoEditar Then Response.Write("<u>") end if %><%=GetValue(objRS, "COD_EMPRESA")%><% If PossoEditar Then Response.Write("</u>") end if %> 
			</td>
            <td><%if TSec(GetValue(objRS, "HORA_IN"))  <> 0 then Response.Write(Mid(GetValue(objRS, "HORA_IN"), 1, 5))%></td>
            <td><%if TSec(GetValue(objRS, "HORA_OUT")) <> 0 then Response.Write(Mid(GetValue(objRS, "HORA_OUT"), 1, 5))%></td>
            <% 
			  if (Cstr(GetValue(objRS, "OBS")&"")<>"") then auxOBS = auxObs + " Obs" & auxCONT & ": " + Cstr(GetValue(objRS, "OBS")&"") end if
			  auxCONT  = auxCONT + 1 
			  auxTOTAL = GetValue(objRS, "TOTAL")
			  'Teste para ver se NÃO É dia de feriado para contabilizar as horas de previsão do dia
			  If not AuxDiaFeriado Then
			    auxTotalprevisto = BuscaTotalPrevisto(GetValue(objRS, "ID_USUARIO"), AuxDiaSemana)		  
			  Else
			    auxTotalprevisto = "00:00:00"
			  End If
		  	  athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT

			  auxCHECKDT = false
			  if not objRS.EOF then auxCHECKDT = auxDiaAtual <> GetValue(objRS, "DATA_DIA")
			Loop Until ( (auxCHECKDT) or (objRS.EOF) or (auxCONT>auxMAXENTER) )
			
			for i=auxCONT to auxMAXENTER 'Completa as colunas que faltaram conforme o número máximo de entradas
              response.write ("<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>")
			next
			%>
			<!-- 
			*******************************************************
            FIM: Laço interno ...                                 *
			*******************************************************
			-->
           <td><%=auxTOTAL%></td>
           <% if flagEMPRESA then
		        response.write ("<td class='texto_chamada_peq'>")
			    'Teste para ver se NÃO É dia de feriado para exibir as horas de previsão do dia
				if not AuxDiaFeriado then response.write (auxTotalprevisto) else response.Write("&nbsp;") end if
				response.write ("</td>")
			  end if
		    %>
		   <td align="center">
		     <% If auxOBS <> "" Then 
		         Response.Write("<img src='../img/EsqSen.gif' border='0' alt='" & auxOBS & "' title='" & auxOBS & "'>") 
			    end if
			 %>
           </td>
            <%
			 strAcc    = strAcc    + TSec(auxTOTAL)
			 strAccDif = strAccDif + ( TSec(auxTOTAL) - TSec(auxTotalprevisto) )
			 strTotal  = strTotal  + TSec(auxTotalprevisto)
			%>
          </tr>
          <% 
            if (auxCONT<=1) then athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT 
			
            i = i + 1
            if not objRS.EOF Then
               if strNome = "Todos" and strMes <> "Todos" or staFirst then
                 strAuxNew = GetValue(objRS, "ID_USUARIO")
               else
                 strAuxNew = GetValue(objRS, "DATA_MES")
               end if 
            else
               strAuxNew = "ultimo"
            end if
            if strAux <> strAuxNew or strAuxNew = "ultimo" then
			
			if strNome <> "Todos" and strNome <> "" then
				strAccDesc = 0
				if strAno <> "Todos" and strAno <> "" then
					if auxMesAtual <> "" then
						strAccDesc = BuscaTotalDesconto(strNome, auxMesAtual, strAno)
					else
						strAccDesc = BuscaTotalDesconto(strNome, "", strAno)
					end if
				end if
				
				if (strAccDesc > 0) then
					strTotalDesc = strTotalDesc + strAccDesc
					strAccDif    = strAccDif - strAccDesc
          %>
          <tr bgcolor="#FFFFFF"> 
            <td colspan="<%=(3 + (auxMAXENTER*3))%>"></td>
            <td><b>Totais</b><br><b>Desconto</b></td>
            <td><b><%=THour(strAcc)%></b></td>
			<td align="right">
            <% 
					if flagEMPRESA then response.write ("<b>" & THour(strTotal) & "</b>")
					'Response.Write("<br><font color='#006699' face='sans-serif' size='0'>" & THour(Abs(strTotalDesc)) & "</font><br>")
				    Response.Write("<br><font color='#006699' face='sans-serif' size='0'>" & THour(Abs(strAccDesc)) & "</font><br>")
					
					strTotal = 0
					auxDifHour = strAccDif 'strAcc-strAccPrev
					if flagEMPRESA then 
					   if (auxDifHour < 0)  then response.write("<font color='#990000' face='sans-serif' size='0'>-") else response.write ("<font color='#009900' face='sans-serif' size='0' title='Banco: " & THour(Abs(auxDifHour)+(Abs(auxDifHour)*0.75))& "'>") end if
					   if (auxDifHour <> 0) then response.write(THour(Abs(auxDifHour)) & "</font>")
					end if
					
					if not IsNumeric(strMes) then 
						if (auxDifHour < 0) then 
							strAcNeg = strAcNeg + auxDifHour
						elseif (auxDifHour > 0) then 	
							strAcPos = strAcPos + auxDifHour
						end if
					end if
					
			%>
			</td>
			<td></td>
          </tr>
		  <% 
				else
          %>
          <tr bgcolor="#FFFFFF"> 
            <td colspan="<%=(3 + (auxMAXENTER*3))%>"></td>
            <td><b>Totais</b></td>
            <td><b><%=THour(strAcc)%></b></td>
			<td align="right">
            <% 
					if flagEMPRESA then response.write ("<b>" & THour(strTotal) & "</b>")
					Response.Write("<br>")
				    
					strTotal = 0
					auxDifHour = strAccDif 'strAcc-strAccPrev
					if flagEMPRESA then 
					   if (auxDifHour < 0)  then response.write ("<font color='#990000' face='sans-serif' size='0'>-") else response.write ("<font color='#009900' face='sans-serif' size='0' title='Banco: " & THour(Abs(auxDifHour)+(Abs(auxDifHour)*0.75)) & "'>") end if
					   if (auxDifHour <> 0) then response.write (THour(Abs(auxDifHour)) & "</font>")
					end if
					
					if not IsNumeric(strMes) then 
						if (auxDifHour < 0) then 
							strAcNeg = strAcNeg + auxDifHour
						elseif (auxDifHour > 0) then 	
							strAcPos = strAcPos + auxDifHour
						end if
					end if
			  %> 
			</td>
			<td></td>
          </tr>
		  <% 
				end if
			end if
			
		    strAcc     = 0 
		    strAccPrev = 0 
		    strAccDif  = 0
			strAccDesc = 0
           end if
          wend
		  %>
			<!-- 
			************************************************************
            FIM: Laço principal                                        *
			************************************************************
			-->
         </tbody>
        </table>
     <%	
	End If 
	FechaRecordSet objRS
	
	'strTotalSaldo = strAcPos - (strAcNeg * -1)
	'strTotalAc = strAcPos - (strAcNeg * -1)
	'strTotalAc = strTotalAc + strTotalDesc
	strTotalAc = strAcPos - (strAcNeg * -1) + strTotalDesc
	strTotalSaldo = strAcPos - (strAcNeg * -1)
	%>
    <!-- 
	*****************************************************************************************
    FIM: Exibe grade de pontos...  
	*****************************************************************************************
	-->
<%	'if not IsNumeric(strMes) and (strTotalSaldo <> 0) then 
    if not IsNumeric(strMes) then 	
		flagDADOS_EXIBIDOS = True
%>
<table width="100%" style="border:1px solid; border-color:#006699;" class="tablesort">
<tbody>
  <tr>
	<td width="99%">&nbsp;</td>
	<td width="210" align="right" valign="middle" nowrap>
		<b>Total no Período&nbsp;&nbsp;
		<%
		if strTotalAc > 0 then
			response.write("<font color='#009900' face='sans-serif' size='0' title='Banco: " & THour(Abs(strTotalAc)+(Abs(strTotalAc)*0.75)) & "'>" & THour(Abs(strTotalAc)) & "</font>")
		else
			response.write("<font color='#990000' face='sans-serif' size='0'>-" & THour(Abs(strTotalAc)) & "</font>") 
		end if
		%>
		</b>
	</td>
  </tr>
  <%
  if (strTotalDesc > 0) then
  %>
  <tr>
	<td width="99%">&nbsp;</td>
	<td width="210" align="right" nowrap>
		<b>Desconto&nbsp;&nbsp;<font color='#006699' face='sans-serif' size='0'><%=THour(Abs(strTotalDesc))%></font></b>
	</td>
  </tr>
  <tr>
	<td width="99%">&nbsp;</td>
	<td width="210" align="right" nowrap>
		<b>Saldo&nbsp;&nbsp;<%
				if (strTotalSaldo < 0) then 
					response.write("<font color='#990000' face='sans-serif' size='0'>-") 
				else 
					response.write("<font color='#009900' face='sans-serif' size='0' title='Banco: " & THour(Abs(strTotalSaldo)+(Abs(strTotalSaldo)*0.75)) & "'>") 
				end if
				'if (strTotalSaldo<>0) then 
				response.write(THour(Abs(strTotalSaldo)) & "</font>")
			%>
		</b>
	</td>
  </tr>
  <%
  end if
  %>
</tbody>
</table>
<%	end if %>
<%	
	strSQL =          " SELECT T1.DT_INI, T1.DT_FIM, T1.OBS, T2.NOME AS CATEGORIA "
	strSQL = strSQL & "   FROM PT_FOLGA T1, PT_FOLGA_CATEGORIA T2 "
	strSQL = strSQL & "  WHERE T1.COD_CATEGORIA = T2.COD_CATEGORIA "
	strSQL = strSQL & "    AND T1.ID_USUARIO LIKE '" & strNome & "' "
	strSQL = strSQL & "    AND (Year(T1.DT_INI) = " & strAno & " OR Year(T1.DT_FIM) = " & strAno & ") "
	strSQL = strSQL & "  ORDER BY T1.DT_INI, T1.DT_FIM "
	
	Set objRS = objConn.Execute(strSQL)
	
	If Not objRS.Eof Then
		flagDADOS_EXIBIDOS = True
%>
REGISTRO DE LICENÇAS:<br><br>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <thead>
	<tr>
	   <th width="1%" class="sortable-date-dmy" nowrap>Dt Início</th>
	   <th width="1%" class="sortable-date-dmy" nowrap>Dt Fim</th>
	   <th width="1%" class="sortable" nowrap>Categoria</th>
	   <th width="97%" class="sortable">Obs</th>
	</tr>
  </thead>
 <tbody style="text-align:left;">
<%
      While Not objRs.Eof
	       strCOLOR = swapString(strCOLOR, "#FFFFFF", "#F5FAFA")
			%>
			<tr style="cursor:arrow;height:20px" onMouseOver="this.style.backgroundColor='#DEECEF';" onMouseOut="this.style.backgroundColor='';" bgcolor="<%=strCOLOR%>">
				<td nowrap><%=PrepData(GetValue(objRS, "DT_INI"), True, False)%></td>
				<td nowrap><%=PrepData(GetValue(objRS, "DT_FIM"), True, False)%></td>
				<td nowrap><%=GetValue(objRS, "CATEGORIA")%></td>
				<td ><%=GetValue(objRS, "OBS")%></td>
			</tr>
			<%
			athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
		WEnd
%>
  </tbody>  
</table>
	<!-- tabela com dados FIM -->
<%
	End If
	FechaRecordSet objRS
	
	If strNome <> "" And strNome <> "Todos" And strAno <> "" And strAno <> "Todos" Then
		strSQL =          " SELECT MES, ANO, TOTAL_HR, TOTAL_MIN, OBS "
		strSQL = strSQL & " FROM PT_DESCONTO "
		strSQL = strSQL & " WHERE ID_USUARIO = '" & strNome & "' "
		If strMes <> "" And strMes <> "Todos" Then strSQL = strSQL & " AND MES = " & strMes
		strSQL = strSQL & " AND ANO = " & strAno
		strSQL = strSQL & " ORDER BY MES, ANO "
		
		Set objRS = objConn.Execute(strSQL)
		
		If Not objRS.Eof Then
			flagDADOS_EXIBIDOS = True
%>
REGISTRO DE DESCONTOS:<br><br>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <thead>
	<tr>
	   <th width="1%" class="sortable" nowrap>Mês</th>
	   <th width="1%" class="sortable" nowrap>Ano</th>
	   <th width="1%" class="sortable" nowrap>Total</th>
	   <th width="97%" class="sortable">Obs</th>
	</tr>
  </thead>
 <tbody style="text-align:left;">
<%
    	  While Not objRs.Eof
	        strCOLOR = swapString(strCOLOR, "#FFFFFF", "#F5FAFA")
			%>
			<tr style="cursor:arrow;height:20px" onMouseOver="this.style.backgroundColor='#DEECEF';" onMouseOut="this.style.backgroundColor='';" bgcolor="<%=strCOLOR%>">
				<td nowrap><%=MesExtenso(GetValue(objRS, "MES"))%></td>
				<td nowrap><%=GetValue(objRS, "ANO")%></td>
				<td nowrap><%=GetValue(objRS, "TOTAL_HR") & ":" & GetValue(objRS, "TOTAL_MIN")%></td>
				<td><%=GetValue(objRS, "OBS")%></td>
			</tr>
			<%
	        athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
    	  WEnd
%>
  </tbody>  
</table>
	<!-- tabela com dados FIM -->
<%
		End If
		FechaRecordSet objRS
	End If
	
	If flagDADOS_EXIBIDOS = False Then
	  Response.Write("<br><br>")
      Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", 1
	End If
%>
<br>
</body>
</html>
<%
  FechaDBConn ObjConn
%>
