<%
'Colocar declaração na página onde for incluído
'Dim cont, tbW, BgCor, DefaultCorA, DefaultCorB, strTopTipo, intTOP

intTOP =	GetParam("var_top")

if intTOP=1 then
	' TIPO: TODOLISTS (executor) ----------------------------------------------------------------------------------------------------
	auxSTR = "" 
	DefaultCorA = "#C00000"
	DefaultCorB = "#FF4949"
	strTopTipo  = "(tarefas - exec)"
	strSQL = "SELECT COUNT(COD_TODOLIST) AS TOTAL FROM TL_TODOLIST WHERE SITUACAO <> 'FECHADO' " 
	Set objRS = objConn.Execute(strSQL) 
	If Not objRS.EOF and Not objRS.BOF Then auxSTR = GetValue(objRS,"TOTAL")
	FechaRecordSet objRS
	strSQL = "SELECT DISTINCT(ID_ULT_EXECUTOR) as ROTULO, (COUNT(COD_TODOLIST)/" & Int(auxSTR) & ")*100 AS TOTAL FROM TL_TODOLIST WHERE SITUACAO <> 'FECHADO' GROUP BY ID_ULT_EXECUTOR ORDER BY 2 DESC"
	'--------------------------------------------------------------------------------------------------------------------------------
elseif intTOP=2 then
	' TIPO: TODOLISTS (responsável) -------------------------------------------------------------------------------------------------
	auxSTR = "" 
	DefaultCorA = "#93A2B9" '"#800080"
	DefaultCorB = "#7D8B9F" '"#C75EC8"
	strTopTipo  = "(tarefas - resp)"
	strSQL = "SELECT COUNT(COD_TODOLIST) AS TOTAL FROM TL_TODOLIST WHERE SITUACAO <> 'FECHADO' " 
	Set objRS = objConn.Execute(strSQL) 
	If Not objRS.EOF and Not objRS.BOF Then auxSTR = GetValue(objRS,"TOTAL")
	FechaRecordSet objRS
	strSQL = "SELECT DISTINCT(ID_RESPONSAVEL) as ROTULO, (COUNT(COD_TODOLIST)/" & Int(auxSTR) & ")*100 AS TOTAL FROM TL_TODOLIST WHERE SITUACAO <> 'FECHADO' GROUP BY ID_RESPONSAVEL ORDER BY 2 DESC"
	'--------------------------------------------------------------------------------------------------------------------------------
else
	' TIPO: CATEGORIA ---------------------------------------------------------------------------------------------------------------
	auxSTR = "" 
	DefaultCorA = "#008000"
	DefaultCorB = "#095D09" 
	strTopTipo  = "(categoria)"
	strSQL = "SELECT Count(TL_CATEGORIA.COD_CATEGORIA) AS TOTAL FROM TL_TODOLIST, TL_CATEGORIA WHERE TL_TODOLIST.COD_CATEGORIA =  TL_CATEGORIA.COD_CATEGORIA" 
	Set objRS = objConn.Execute(strSQL) 
	If Not objRS.EOF and Not objRS.BOF Then auxSTR = GetValue(objRS,"TOTAL") End If 
	FechaRecordSet objRS
	strSQL = "SELECT DISTINCT(TL_CATEGORIA.NOME) as ROTULO, Count(TL_CATEGORIA.COD_CATEGORIA)/" & Int(auxSTR) & "*100 AS TOTAL " &_
				"  FROM TL_TODOLIST, TL_CATEGORIA " &_
				" WHERE TL_TODOLIST.COD_CATEGORIA =  TL_CATEGORIA.COD_CATEGORIA " &_
				" GROUP BY TL_CATEGORIA.NOME " &_
				" ORDER BY 2 desc " 
	'--------------------------------------------------------------------------------------------------------------------------------
end if

'if intRandomNumber>=750 And intRandomNumber<800 then
'	' TIPO: HORAS ---------------------------------------------------------------------------------------------------------------
'	auxSTR = "" 
'	DefaultCorA = "#93A2B9"
'	DefaultCorB = "#7D8B9F"
'	strTopTipo  = "(horas)"
'	strSQL = "SELECT Sum(HORAS) AS TOTAL FROM TL_RESPOSTA" 
'	Set objRS = objConn.Execute(strSQL) 
'	If Not objRS.EOF and Not objRS.BOF Then auxSTR = GetValue(objRS,"TOTAL") End If 
'	FechaRecordSet objRS
'	strSQL = "SELECT ID_FROM as ROTULO, (Sum(HORAS)/" & Int(auxSTR) & ")*100 AS TOTAL FROM TL_RESPOSTA GROUP BY ID_FROM ORDER BY 2 DESC"
'--------------------------------------------------------------------------------------------------------------------------------
'end if 
Set objRS = objConn.Execute(strSQL) 
%>
<table width="170" align="center" cellpadding="0" cellspacing="0" border="0" style="border:1px solid <%=strBGCOLOR1%>">
<tr>
    <td width="170" bgcolor="<%=strBGCOLOR2%>" class="corpo_texto_mdo" valign="middle" align="left" height="22" style="border-bottom:1px solid <%=strBGCOLOR1%>">&nbsp;<b>Top 5</b></td>
	<td align="right" width="70%" bgcolor="<%=strBGCOLOR2%>" class="corpo_texto_mdo" style="border-bottom:1px solid <%=strBGCOLOR1%>">
		<select name="var_top" class="edtext" style="width:105px;" onChange="document.location='painel.asp?var_top='+this.value;">
			<option value="1" <%if intTOP=1 then Response.Write(" selected")%>>tarefas - exec</option> 
			<option value="2" <%if intTOP=2 then Response.Write(" selected")%>>tarefas - resp</option> 
			<option value=""  <%if intTOP="" then Response.Write(" selected")%>>categoria</option> 			
		</select>
	</td>
</tr>
<tr>
	<td colspan="2" width="150" height="135" align="center">

		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td align="center">
				<div style="padding-left:3px; padding-right:3px;">
				<% 
				cont=1
				while not objRS.EOF and cont<6
					BgCor = DefaultCorA
					
					tbW = Int(GetValue(objRS,"TOTAL"))
					if (tbW>100) then 
						tbW = 100
						BgCor = DefaultCorB
					end if
				%>
					<table width="150" height="20" cellpadding="0" cellspacing="0" border="0">
						<tr><td colspan="2" width="100%" height="10" class="texto_ajuda"><%=GetValue(objRS,"ROTULO")%></td></tr>
						<tr>
							<td width="<%=tbW%>%" height="10" bgcolor="<%=BgCor%>" title="<%=tbW%>%">
								<!-- <img id="imgA_<%=cont%>" src="../img/no-transparent.gif" width="100%" height="10" alt="<%=tbW%>%" border="0"> -->
							</td>
							<%' If GetValue(objRS,"TOTAL")<=100 then %>
							<td width='<%=(100-tbW)%>%' height="10" bgcolor='#FFFFFF' title="<%=tbW%>%">
								<!-- <img id="imgB_<%=cont%>" src='../img/no-transparent.gif' width='100%' height='10' alt='<%=tbW%>%' border='0'> -->
							</td>
							<%' end if %>
						</tr>
					</table>
				<%
					cont = cont + 1
					objRS.movenext
				wend
				%>
						</div>	 
					</td>
				</tr>
			</table>

	</td>
</tr>
</table>
<% FechaRecordSet objRS %>