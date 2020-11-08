<%
Dim objRSQUICK, strTOTAL, objRSTOTAL
Dim strHoraIn, strSaida, strAction, strTipo, strHora1, strMinuto1
Dim strCod_Ponto, strCodEmpresa, i, strHorarioIn, strMinIn, strDia, strMes, strAno
Dim strMinuto, strReduzHora, strHora, strTOTALHORA, strTOTALMIN, strAumHora
 
if VerificaDireito ("|INS|", BuscaDireitosFromDB("modulo_PONTO", Request.Cookies("VBOSS")("ID_USUARIO")), false ) then
	strSQL =	"SELECT COD_PONTO, COD_EMPRESA, HORA_IN, HORA_OUT " & _
				" FROM PT_PONTO" & _
				" WHERE ID_USUARIO = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' AND DATA_DIA = " & Day(Date()) & " AND DATA_MES = " & Month(Date()) & " AND DATA_ANO = " & Year(Date()) &_
				" ORDER BY DATA_DIA, DATA_MES, DATA_ANO "
	
	Set objRSQUICK = ObjConn.Execute(strSQL)
	 
	strSQL = " SELECT TOTAL FROM PT_TOTAL_DIA  WHERE ID_USUARIO = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' " &_ 
	         " AND DATA_DIA = " & Day(Date()) & " AND DATA_MES = " & Month(Date()) & " AND DATA_ANO = " & Year(Date())
	
	Set objRSTOTAL = ObjConn.Execute(strSQL) 
	
	if Not objRSTOTAL.EOF then
		strTOTAL = objRSTOTAL("TOTAL")
	else
		strTOTAL = "00:00:00"
	end if
	FechaRecordSet(objRSTOTAL)
	 
	strSaida = false
	while not objRSQUICK.EOF and Not strSaida
		if objRSQUICK("HORA_OUT") <> "" then
			objRSQUICK.MoveNext
		else
			strSaida 		= true
			strHorarioIn	= objRSQUICK("HORA_IN")
			strCOD_PONTO  	= objRSQUICK("COD_PONTO")
			strCodEmpresa 	= objRSQUICK("COD_EMPRESA")
		end if
	wend
	
	strHora1 = Hour(Now())
	strHora1 = ATHFormataTamLeft(strHora1,2,"0")
	strMinuto1 = Fix(Minute(Now())/5)*5
	strMinuto1 = ATHFormataTamLeft(strMinuto1,2,"0")
	
	if strHorarioIn = "" then
		strAction = "insertquick_exec.asp"
		strTipo   = "Entrada"
		i = 1 
	else
		strAction = "updatequick_exec.asp"
		strTipo   = "Saída"
		i = 2
	  
		if Cint(strMinuto1) > Minute(strHorarioIn) then
			strMinuto 		= strMinuto1 - Minute(strHorarioIn)
			strReduzHora	= 0
		else
			strMinuto 		= 60 - Minute(strHorarioIn)
			strMinuto 		= strMinuto + strMinuto1
			strReduzHora 	= 1
		end if 
		
		strHora 		= strHora1 - Hour(strHorarioIn) - strReduzHora 
		strTOTALHORA	= Hour(strTOTAL) 	+ strHora
		strTOTALMIN		= Minute(strTOTAL)	+ strMinuto
		
		if strTOTALMIN >= 60 then
			strTOTALMIN = strTOTALMIN - 60
			strAumHora 	= 1
		end if
	  
		strTOTALHORA	= strTOTALHORA + strAumHora
		strTOTALHORA	= ATHFormataTamLeft(strTOTALHORA,2,"0")
		strTOTALMIN		= ATHFormataTamLeft(strTOTALMIN,2,"0")
		
		strTOTAL		= strTOTALHORA*60 + strTOTALMIN
		
		'Response.Write(strTOTALHORA*60 & "<br>" & strTOTALMIN)
		'Response.End()
		
		strHoraIn		= Hour(strHorarioIn)
		strHoraIn		= ATHFormataTamLeft(strHoraIn,2,"0")
		strMinIn		= Minute(strHorarioIn)
		strMinIn		= ATHFormataTamLeft(strMinIn,2,"0")
	end if
%>
<table width="164" cellpadding="0" cellspacing="0" border="1" bordercolor="<%=strBGCOLOR1%>" align="center">
<form name="FrmInsertPonto" action="../modulo_PONTO/<%=strAction%>" method="get">
	<input type="hidden" name="var_chavereg" value="<%=strCod_Ponto%>">
	<input type="hidden" name="var_id_usuario" value="<%=Request.Cookies("VBOSS")("ID_USUARIO")%>">
	<input type="hidden" name="var_status" value="REALIZADO">
	<input type="hidden" name="var_dt_dia" value="<%=Day(Date)%>">
	<input type="hidden" name="var_dt_mes" value="<%=Month(Date)%>">
	<input type="hidden" name="var_dt_ano" value="<%=Year(Date)%>">
<% if strTipo = "Saída" then %>
	<input type="hidden" name="var_empresa_old" value="<%=strCodEmpresa%>">
	<input type="hidden" name="txtHH1" value="<%=strHoraIn%>">
	<input type="hidden" name="txtMM1" value="<%=strMinIn%>">
<% end if %>

<script>
function atualiza() {
	data = new Date();
	minutes = data.getMinutes();
	minutes = Math.floor(minutes/5)*5;
	FrmInsertPonto.txtHH<%=i%>.value = data.getHours();
	FrmInsertPonto.txtMM<%=i%>.value = minutes;
}
</script>

	<tr>
		<td bgcolor="<%=strBGCOLOR2%>" class="corpo_texto_mdo" valign="middle" align="left" height="22">
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td width="77%" align="left"><div style="padding-left:3px; padding-right:3px;"><b>Registro Horas</b></div></td>
					<td width="23%" align="right"><a href="javascript:document.FrmInsertPonto.submit();"><img src="../img/IconAction_NotepadSave.gif" border="0"></a>&nbsp;&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr><td colspan="2" height="15"></td></tr>
				<tr>
					<td width="29%" align="right"><div style="padding-left:3px">Emp.:&nbsp;</div></td>
					<td width="71%" align="left">
						<select name="var_empresa" class="texto_chamada_peq" style="width: 105px">
							<%=montaCombo("STR", "SELECT SIGLA_PONTO, NOME_COMERCIAL FROM ENT_CLIENTE WHERE DT_INATIVO IS NULL AND SIGLA_PONTO IS NOT NULL ORDER BY NOME_COMERCIAL", "SIGLA_PONTO", "NOME_COMERCIAL", Request.Cookies("VBOSS")("DEFAULT_EMP"))%> 
							<option value="EXT">Extra/Outros</option>
						</select>
					</td>
				</tr>
				<tr><td colspan="2" height="5"></td></tr>
				<tr>
					<td align="right"><div style="padding-left:3px">Data:&nbsp;</div></td>
					<td><%=Date()%></td>
				</tr>
				<tr><td colspan="2" height="5"></td></tr>
				<tr>
					<td align="right"><div style="padding-left:3px">Horas:&nbsp;</div></td>
					<td><%=FormataHoraNumToHHMM(strTOTAL)%>&nbsp;<small>(hoje)</small></td>
				</tr>
				<tr><td colspan="2" height="5"></td></tr>
				<tr>
					<td align="right"><div style="padding-left:3px"><%=strTipo%>:&nbsp;</div></td>
					<td>
						<table width="100%" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td width="99%">
									<input type="text" readonly name="txtHH<%=i%>" size="1" maxlength="2" value="<%=strHora1%>">&nbsp;<b>:</b>
									<input type="text" readonly name="txtMM<%=i%>" size="1" value="<%=strMinuto1%>">&nbsp;<b>:</b>&nbsp;00
								</td>
								<td><!--img src="../img/IconAction_Refresh.gif" hspace="2" onClick="atualiza();" style="cursor:hand"--></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td colspan="2" height="5"></td></tr>
			</table>
		</td>
	</tr>
</form>
</table>
<% end if %>