<%
	If  Request.Cookies("VBOSS")("GRUPO_USUARIO") = "CLIENTE" THEN
		strTIPO_ENTIDADE  = "ENT_CLIENTE"
	Else
		strTIPO_ENTIDADE  = "ENT_COLABORADOR"
	END IF
	
strSQL = "SELECT enqu.COD_ENQUETE "	&_
		 "		, enqu.TITULO "	&_
		 "		, enqu.DT_INI "	&_
		 "		, enqu.DT_FIM "	&_
		 "		, (SELECT COUNT(COD_LOG) FROM en_log WHERE en_log.cod_enquete = enqu.COD_ENQUETE AND id_usuario = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' ) AS FLAG_RESP "&_ 
		 "	 FROM EN_ENQUETE AS enqu "	&_
		 "	WHERE Now() BETWEEN DT_INI AND DATE_ADD(DT_FIM,INTERVAL 30 DAY) "	&_
		 "     AND TIPO_ENTIDADE = '" & strTIPO_ENTIDADE & "' " &_
		 "	GROUP BY COD_ENQUETE, TITULO, DT_INI, DT_FIM "	&_ 
		 "	ORDER BY DT_INI DESC "

'AthDebug strSQL, true 

AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
if not objRS.eof and not objRS.bof then 
%>
<table width="170" align="center" cellpadding="0" cellspacing="0" border="0" style="border:1px solid <%=strBGCOLOR1%>; margin-bottom:10px;">
	<tr>
		<td width="170" bgcolor="<%=strBGCOLOR2%>" class="corpo_texto_mdo" valign="middle" align="left" height="22" style="border-bottom:1px solid <%=strBGCOLOR1%>">
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td align="left" width="1%" nowrap><div style="padding-left:3px; padding-right:3px;"><b>Enquetes</b></div></td>
				<td width="99%" style="text-align:right"></td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td width="164" align="center" valign="top">
			<table width="160" cellpadding="0" cellspacing="2" border="0">
				<tr><td colspan="2" style="height:3px;"></td></tr>
			<%  strEXIBE_ENQUETE = "sim"
				while not objRS.eof
					strDT_ENVIO = PrepData(GetValue(objRS,"DT_FIM"),true,false) 					
					IF (CInt(getValue(objRS,"FLAG_RESP")) = 0) THEN
						strVAL1 = "../img/niver_today.png"
						auxSTR = "enquete_form.asp"
					ELSE
						strVAL1 = "../img/niver_info.png"
						auxSTR = "enquete_result.asp"
					END IF	
						
					if (cdate(strDT_ENVIO) < now()) AND (CInt(getValue(objRS,"FLAG_RESP")) = 0) Then
						strEXIBE_ENQUETE = false
					else 
						strEXIBE_ENQUETE = true
					end if
					if strEXIBE_ENQUETE then
			%>      
                    <tr style='cursor:pointer;' 
                        onClick="JavaScript:AbreJanelaPAGENew('../modulo_ENQUETE/<%=auxSTR%>?var_chavereg=<%=GetValue(objRS,"COD_ENQUETE")%>', '500', '640', 'yes', 'yes');" 
                        title="<%=GetValue(objRS,"TITULO")%>" 
                        valign="top">
                        <td width='040' height='30px' style='background:URL(<%=strVAL1%>); background-repeat:no-repeat; background-position:top;'></td>
                        <td width="124"><%=ucase(GetValue(objRS,"TITULO"))%>&nbsp;<small>(até <%=strDT_ENVIO%>)</small></td>
                    </tr>
                    <tr><td colspan="2" style="height:3px;"></td></tr>
              <%      
					end if
					athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
				wend
			%>
			</table>
		</td>
	</tr>
</table>
<% 
 end if 
 FechaRecordSet objRS 
%>


