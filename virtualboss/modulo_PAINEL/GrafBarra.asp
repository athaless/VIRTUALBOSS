<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
Response.AddHeader "Content-Type","text/html; charset=iso-8859-1"
VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_PONTO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<%
 
 Dim objConn, strSQL, objRS
 Dim dateNow, datePrinc, dateArray
 Dim intOpcao, intCodigo, intData, intDiaSemana, intAux, i, intPerc, totalHoraArray, totalHoraPrevArray
 Dim arrDias, arrHoras, intHoras, intInfoPerc, arrHorasPrev, intPercPrev
 Dim strAccPrev, strMes, auxCod, auxData, difDATA, contDATA, auxUnidade, comparaDATA, AuxcomparaDATA
 
 Dim insereContData
 Const intAltura        = "200"
 Const intLarguraBarra  = "20"
 Const intLarguraTabela = "400"
 Const HoraMin			= "60"

  AbreDBConn objConn, CFG_DB   
'----------------------------------------------------------------------   
   Function DiaSemana(prDiaSemana)
	select case prDiaSemana
		case "1" DiaSemana = "dom"
		case "2" DiaSemana = "seg"
		case "3" DiaSemana = "ter"
		case "4" DiaSemana = "qua"
		case "5" DiaSemana = "qui"
		case "6" DiaSemana = "sex"
		case "7" DiaSemana = "sab"
		case else DiaSemana = ""
	end select
   End function
'---------------------------------------------------------------------- 
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
%>
<html>
	<head>
		<style>
			.td      { font-family:Tahoma,Arial; font-size:11px; background-color:#CDD8EB; vertical-align:bottom; }
			.barra   { width:10px; font-size:0px; background-color:#FFFFFF;}
			.barra2  { width:10px; font-size:0px; }
		</style>
	</head>
	<body>
	<form name="form_principal" id="form_principal" method="get" action="GrafBarra.asp" target="vbMainFrame">

		<table cellpadding="0" cellspacing="0" border="0" align="center">
			<tr><td width="456" align="right"><h3><font face="Arial, Helvetica, sans-serif"> Gráfico de Barras - tarefas diárias / Horário Previsto </font></h3></td></tr>  
			<tr>
				<td align="center">
					<div style="padding-right:5px;padding-top:26px">
						  <table border="0" cellpadding="0" cellspacing="0" align="center" width="<%=intLarguraTabela%>">						
							  <%
							  '----------------------------------------------------------------------
								 auxCod  = Request.QueryString("selNome")
								 auxData = Request("selMes")
								 
								 'Response.Write("Nome do usuário: " & auxCod & "<br>")							 
								 'Response.Write("Periodo: " & auxData & "<br><br>")
								 
								 ' Recebe ID_USER de referência (VEM DE UMA COMBO) 
								 If (auxCod = "") Then
									intCodigo = Request.Cookies("VBOSS")("ID_USUARIO")
								 Else
									intCodigo = auxCod
								 End If
								 Response.Write("Nome do usuário: " & intCodigo & "<br>")
								 
								'----------------------------------------------------------------------   
								 ' Recebe DATA de referência (VEM DE UMA COMBO)
								 If (auxData = "") Then
								  intData = 0
								 Else
								  intData = auxData
								 End If
								 'Inserção de uma data chave
								  dateNow = Date()
								'----------------------------------------------------------------------  
								 ' Recebe o número de semanas a adicionar
								 intOpcao  = intData
								'----------------------------------------------------------------------
								 ' Montagem dos dias da semana
								 if intOpcao <> "" and isNumeric(intOpcao) then
									datePrinc = DateAdd("w", Cint(intOpcao)*7, dateNow)
									intDiaSemana = Weekday(datePrinc)
									
									'Response.Write(datePrinc)
									'Response.End()
									
									ReDim arrDias(6)
									ReDim arrHoras(6)
									ReDim arrHorasPrev(6) 
									
									for i = 0 To 6
										'BUSCA A DATA PARA MOSTRÁ-LA
										intAux = i - intDiaSemana + 2 'aqui está 2 para tirar a diferença do índice e fazer a semana começar na segunda
										dateArray = DateAdd("d",intAux,datePrinc)
										arrDias(i) = dateArray
										
										'BUSCA O HORARIO de trabalho DIARIO DO USUARIO
										totalHoraArray = BuscaTotalPrevisto(intCodigo, DiaSemana(intAux)) 'DiaSemana - chama a Function que retorna o dia da semana	
										arrHoras(i) = Left(totalHoraArray,2) '& "," & Right(Left(totalHoraArray,5),2)  MINUTOS
									next
								'----------------------------------------------------------------------	
									'BUSCA O HORARIO TOTAL DE TAREFAS PARA AQUELA DATA
									strSQL = " SELECT COD_TODOLIST, PREV_DT_INI, PREV_DT_FIM, PREV_HORAS "  &_
											 "FROM TL_TODOLIST " 									   		&_ 
											 "WHERE ID_ULT_EXECUTOR='" & intCodigo 					   		&_
											 "' AND (PREV_DT_INI>=#" & FormatDateSQL(arrDias(0)) 	   		&_
											 "# AND PREV_DT_INI<=#" & FormatDateSQL(arrDias(6))        		&_
											 "#) AND (PREV_DT_FIM>=#" & FormatDateSQL(arrDias(0))      		&_
											 "# AND PREV_DT_FIM<=#" & FormatDateSQL(arrDias(6)) & "#)" 		&_
											 "ORDER BY PREV_DT_INI, COD_TODOLIST"
											 
									'Response.Write("<BR>" & strSQL & "<br><br>")
									'Response.End()
									
									AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
									Set ObjRS = ObjConn.Execute(strSQL) 
									
									i=0
									difDATA = 0
									totalHoraPrevArray = 0
									comparaDATA = ""
									AuxcomparaDATA = 0
									contDATA = 0
									insereContData = False
									
									While (not ObjRS.BOF) AND (not ObjRS.EOF)
										Response.Write(arrDias(i) & " - " & objRS("COD_TODOLIST") & "&nbsp;&nbsp;" & objRS("PREV_DT_INI") & "&nbsp;&nbsp;" & objRS("PREV_DT_FIM") & "&nbsp;&nbsp;" & objRS("PREV_HORAS") & "<br><br>")	
										If (arrDias(i) = objRS("PREV_DT_INI")) OR (arrDias(i) = objRS("PREV_DT_FIM")) Then	
											totalHoraPrevArray = objRS("PREV_HORAS")
											'VAR CRIADA PARA ARMAZENAR A ULTIMA DATA INI AFIM DE COMPARAÇAO COM A PROXIMA 'PREV_DT_INI'
											If (objRS("PREV_DT_INI") = objRS("PREV_DT_FIM")) Then 'Verifica se a TODOLIST INICIA E TERMINA no mesmo dia
												'Verifica se a data INI é igual a data INI do registro anterior 
												If (objRS("PREV_DT_INI") = comparaDATA) Then 
													i = i + 1
													If (insereContData = False) Then
														arrHorasPrev(i-1) = arrHorasPrev(i-1) + totalHoraPrevArray	+ contDATA
														insereContData = True
													Else
														arrHorasPrev(i-1) = arrHorasPrev(i-1) + totalHoraPrevArray
													End If
													difDATA = difDATA - 1
													Response.Write(difDATA)
												Else
													arrHorasPrev(i) = arrHorasPrev(i) + totalHoraPrevArray + contDATA
													difDATA = difDATA - 1
												End If
											Else 'SE A TODOLIST TEM DURAÇAO SUPERIOR A UM DIA...
												if (difDATA = 0) Then 	
													difDATA = objRS("PREV_DT_FIM") - objRS("PREV_DT_INI")
													contDATA = contDATA + (objRS("PREV_HORAS") / difDATA)
													If (contDATA < 0) Then
														contDATA = 0
													End If
													insereContData = False								
												Else
													arrHorasPrev(i-1) = arrHorasPrev(i-1) + contDATA
													difDATA = difDATA - 1		
												End If
											End If	
										Else
											arrHorasPrev(i) = "0,1"
										End If	
										
										i = i + 1
										comparaDATA  = objRS("PREV_DT_INI")
										ObjRS.movenext
									wend
									
									'for i = 0 To 6
									'	Response.Write("  <" & arrHoras(i)     & ">  ")
									'	Response.Write("  |" & arrHorasPrev(i) & "|" & DiaSemana(i) & "<br>")
									'Next
								 end if
							 '----------------------------------------------------------------------
  						   %>
							<tr>
								<td width="5">&nbsp;</td>
								<td height="20" bgcolor="#FFFFFF" align="center" valign="middle">
								  <select name="selNome" class="edtext" style="width:100px" >
									 <!--option value="Todos" <%'if GetParam("selNome") = "Todos" then response.write("selected")%>>[usuários]</option-->
									 <%=montaCombo("STR","SELECT Distinct(ID_USUARIO) FROM USUARIO WHERE DT_INATIVO is NULL", "ID_USUARIO", "ID_USUARIO", intCodigo)%> 
								  </select>
								</td>
								<td width="5">&nbsp;</td>
								<td height="20" bgcolor="#FFFFFF" align="center" valign="middle">
								  <select name="selMes" class="edtext" style="width: 145px" >
									<option value="0" <%  if auxData = "0"  then response.write("selected")%>>[Atual]</option>
									<option value="-1" <% if auxData = "-1" then response.write("selected")%>>Semana Anterior</option>
									<option value="1" <%  if auxData = "1"  then response.write("selected")%>>Próxima semana</option>
									<option value="2" <%  if auxData = "2"  then response.write("selected")%>>Daqui há 2 semanas</option>
									<option value="3" <%  if auxData = "3"  then response.write("selected")%>>Daqui há 3 semanas</option>
								  </select>						
								</td>
								<td>
									<div style="padding-top:5px; padding-Left:10px;"> 
										<a href="javascript:document.form_principal.submit();"> 
											<img src="../img/bt_search_mini.gif" alt="Atualizar consulta..."  border="0"> 
										</a> 
									</div>
								</td>
							</tr>
						  </table>
					</div>
				</td>
			</tr>
		</table>
		<table border="0" width="<%=intLarguraTabela%>" height="<%=intAltura%>" align="center">
			<tr>
				<%
				'escreve os dias acima das barras
				for i = 0 To Ubound(arrDias)%>
				<td height='1%' align='center' class='td'>
				<%
					Response.Write(DiaSemana(Weekday(arrDias(i))) &  "<br>" & arrDias(i))
				%>
				</td>
				<%
				    Response.Write(VbNewLine)
				next
				%>
			</tr>
			<tr>
			    <%
				for i = 0 To Ubound(arrDias)
				%>
				<td width="14%" bgcolor="#FFFFFF">
					<table cellpadding="0" cellspacing="3" height="100%" border="0">
						<tr>
							<%
							 intAux = 0
							 While intAux < 1 ' Not objRS.EOF
								If ((arrHoras(i)="") Or (arrHorasPrev(i)="")) Then
									intPerc = 100 & "%"
									intPercPrev = 1 & "px"
								Else
									intPerc = Cint( arrHoras(i) * 100)/arrHoras(i) & "%"
									intPercPrev = arrHorasPrev(i) * 100/arrHoras(i) & "%"
								End If
							%>
							<td>
								<table cellpadding="0" cellspacing="0" width="<%=intLarguraBarra%>" height="100%">
									<tr>
										<td class="barra">&nbsp;</td>
									</tr>
									<tr>
										<td class="barra2" height="<%=intPerc %>" title="<%=intPerc & " - " & FormataHoraNumToHHMM(arrHoras(i))%>h(s)" style="background-color:#C9FF4D"></td>
									</tr>
								</table>
							</td>
							<td>
								<table cellpadding="0" cellspacing="0" width="<%=intLarguraBarra%>" height="100%">
									<tr>
										<td class="barra">&nbsp;</td>
									</tr>
									<tr>
										<td class="barra2" height="<%=intPercPrev %>" title="<%=intPercPrev & " - " & FormataHoraNumToHHMM(arrHorasPrev(i))%>h(s)" style="background-color:#C9FFB4"></td>
									</tr>
								</table>
							</td>							
							<%
								intAux = intAux + 1 'objRS.MoveNext
							 Wend
							%>
						</tr>
					</table>
				</td>
				<% next %>
			</tr>
		</table>
	</form>
	</body>
</html>
