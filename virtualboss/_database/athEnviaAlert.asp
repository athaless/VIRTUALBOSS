<%
function ConvTipoToIcon(prTipoImg)
 Dim auxStr, auxLogicalPath
 auxLogicalPath = FindLogicalPath()
 select case (prTipoImg)
   case 0: ConvTipoToIcon = auxLogicalPath & "/img/Alert_Caution01.gif" 'Alerta Geral
   case 1: ConvTipoToIcon = auxLogicalPath & "/img/Alert_Caution02.gif" 'Alerta Geral (Azul)
   case 2: ConvTipoToIcon = auxLogicalPath & "/img/Alert_Caution03.gif" 'Alerta Nova tarefra
   case 3: ConvTipoToIcon = auxLogicalPath & "/img/Alert_Note.gif"      'Play (resp de tarefa em andamento
   case 4: ConvTipoToIcon = auxLogicalPath & "/img/Alert_Stop.gif"      'Stop (tarefa finalizada)
   case 5: ConvTipoToIcon = auxLogicalPath & "/img/icoanexo.gif"        'Imagem do Anexo ("clips")
   case 6: ConvTipoToIcon = auxLogicalPath & "/img/LogoVBoss.gif"       'Logo VB
 case else
   ConvTipoToIcon = prTipoImg
 end select
end function 

function MontaHeaderMail(prTipo,prPARAM)
  Dim auxStr
  auxStr = "<html><head><title>VirtualBOSS</title><meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'></head>" & vbcrLF &_
   "<body>" & vbcrLF &_
    "<table width=100% cellspacing=0 cellpadding=1 border=0 >" & vbcrLF &_
    "<tr>" & vbcrLF &_
      "<td align=left><img src=" & ConvTipoToIcon(6) & "></td>" & vbcrLF &_
      "<td width=75% ></td>" & vbcrLF &_
	  "<td align=right><img src=""" & ConvTipoToIcon(prTipo)& """></td>" & vbcrLF &_
	"</tr>" & vbcrLF &_
	"<tr><td colspan=3 height=1 bgcolor=#c9c9c9 ></td></tr>" & vbcrLF &_
	"<tr><td colspan=3 align=right style=""font-family:Tahoma; font-size:11;"" >" & vbcrLF &_
	"<div style=""padding-right:5px;"" ><font color=#999999 >"
  
  If prPARAM = "TODOLIST" Then auxStr = auxStr & "Todo List"
  If prPARAM = "AGENDA"   Then auxStr = auxStr & "Agenda"
  If prPARAM = "CHAMADO"  Then auxStr = auxStr & "Chamado"
  
  auxStr = auxStr & "</font></div></td></tr></table>" 
  
  MontaHeaderMail = auxStr
end function

function MontaHeaderToDo(prTitMsg,prTipo,prCOD,prTITULO,prSITUACAO,prCATEGORIA,prPRIORIDADE,prRESPONSAVEL,prEXECUTOR,prPREV_DT_INI,prDT_REALIZADO,prDESC,prBS,prPARAM,prVINCULO_CHAMADO, byref varObjConn)
 Dim auxStr, strARQUIVO_ANEXO, strLogicalPath, strNomeArquivo, strMsgUser, bTemAnexo
 Dim strSQL, objRS
 
 'Busca o diretório principal. Colocada em uma variável para executar a função apenas uma vez.
 strLogicalPath = FindLogicalPath()
 
 
 If prPARAM = "TODOLIST" Then
	 auxStr = "<table width='100%' border='0' cellpadding='1' cellspacing='0' style='font-family:Tahoma, Verdana; font-size:11;'>" & VbCrlf &_ 
				"	<tr><td>&nbsp</td><td><b>" & prTitMsg & "</b></td></tr>" & VbCrlf &_
				"	<tr><td colspan='2' height='10'></td></tr>" & VbCrlf
	 if prBS<>"" then auxStr = auxStr & prBS
				
	 auxStr = auxStr & "<tr><td align='right' valign='top' width='10%' nowrap>Título:&nbsp;   </td><td width='90%'>" 
	 If prCOD <> "" Then auxStr = auxStr & prCOD & " - " 
	 auxStr = auxStr & prTITULO & "</td></tr>" & VbCrlf &_
					"<tr><td align='right' valign='top' width='10%' nowrap>Situação:&nbsp; </td><td width='90%'><b>" & prSITUACAO  & "</b></td></tr>" & VbCrlf &_
					"<tr><td align='right' valign='top' width='10%' nowrap>Categoria:&nbsp;</td><td width='90%'>" & prCATEGORIA & "</td></tr>" & VbCrlf
	 
	 if prTipo="FULL" then
		auxStr = auxStr &_
			"<tr><td align=right valign='top' nowrap>Prioridade:&nbsp;</td><td width='90%'>" & prPRIORIDADE & "</td></tr>" & vbcrLF &_
			"<tr><td align=right valign='top' width='10%' nowrap>Responsável:&nbsp;    </td><td width='90%'>" & prRESPONSAVEL  & "</td></tr>" & vbcrLF
		If prVINCULO_CHAMADO = "" Then
			auxStr = auxStr & "<tr><td align='right' valign='top' width='10%' nowrap>Executor Atual:&nbsp; </td><td width='90%'>" & prEXECUTOR & "</td></tr>" & vbcrLF
		End If
		auxStr = auxStr & "<tr><td align='right' valign='top' width='10%' nowrap>Previsão:&nbsp;       </td><td width='90%'>" & prPREV_DT_INI  & "</td></tr>" & vbcrLF &_
						  "<tr><td align='right' valign='top' width='10%' nowrap>Data Realizado:&nbsp; </td><td width='90%'>" & prDT_REALIZADO & "</td></tr>" & vbcrLF &_
						  "<tr><td align='right' valign='top' width='10%' nowrap><b>Tarefa:</b>&nbsp;  </td><td width='90%'>" & prDESC & "</td></tr>" & vbcrLF &_  
						  "<tr><td width='10%'>&nbsp;</td><td width='90%'>&nbsp;</td></tr>" 

		'auxStr = auxStr & "<tr><td align='right' valign='top' width='10%' nowrap></td>"
		'auxStr = auxStr & "<td width='90%'>"
		'auxStr = auxStr & "<form name='formInsRepFromEmail' action='http://virtualboss.proevento.com.br/virtualboss/modulo_TODOLIST/insertRespostaFromEmail.asp'  method='post' target='_blank'>"
		'auxStr = auxStr & "		<input type='hidden' name='var_dbselect'	value='" & CFG_DB & "')>"
		'auxStr = auxStr & "		<input type='hidden' name='var_chavereg'	value='" & prCOD & "')>"
		'auxStr = auxStr & "		<input type='hidden' name='var_userid'		value='" & prEXECUTOR & "')>"
		'auxStr = auxStr & "		<input type='hidden' name='var_senha'		value='" & "" & "')>"
		'auxStr = auxStr & "		<input type='hidden' name='var_cod_usuario'	value='" & "" & "')>"
		'auxStr = auxStr & "		<button type='submit'>RESPONDER</button>"
		'auxStr = auxStr & "</form>"
		'auxStr = auxStr & "</td></tr>" 
		
		' INI: PROVISÓRIO --------------------------------------------------------------------
		'Só coloca esse BOTÃO de acesso SAC/VBOSS se o usuário RESPONSÁVEL pelo chamado/tarefa 
		'for um tipo SAC (pvista) e para isso testamos se tem "_" no id_user 
		if ( instr(prRESPONSAVEL,"pvista_") > 0 ) then 
			auxStr = auxStr & "<tr>"
			auxStr = auxStr & " <td align='right' valign='top' width='10%' nowrap>&nbsp;</td>"
			auxStr = auxStr & " <td width='90%'>"
			auxStr = auxStr & "   <form id='formChamadoVBOSS' name='formChamadoVBOSS' action='http://virtualboss.proevento.com.br/proevento/default_LoginViasite.asp' target='_blank' method='post' style='display:none;'>"
			auxStr = auxStr & "    <input type='hidden' id='var_user'     name='var_user'     value='" & prRESPONSAVEL & "'>"
			auxStr = auxStr & "    <input type='hidden' id='var_password' name='var_password' value='" & "athroute" & "'>"
			auxStr = auxStr & "    <input type='hidden' id='var_db'       name='var_db'       value='" & Request.Cookies("VBOSS")("CLINAME") & "'>"
			auxStr = auxStr & "    <input type='hidden' id='var_title'    name='var_title'    value=''>"
			auxStr = auxStr & "    <input type='hidden' id='var_extra'    name='var_extra'    value='" & Request.Cookies("VBOSS")("EXTRA") & "'>"
			auxStr = auxStr & "    <input type='submit' value='SAC/VBOSS [" & prRESPONSAVEL & "]'>&nbsp;&nbsp;"
			auxStr = auxStr & "	   <a href='#' onclick='javascript:document.formChamadoVBOSS.submit(); return false;'>SAC/VBOSS [" & prRESPONSAVEL & "]</a>" 
			auxStr = auxStr & "   </form>"
			auxStr = auxStr & " </td>"
			auxStr = auxStr & "</tr>" 
		end if		
		' FIM: PROVISÓRIO ------------------------------------------------------- 13/06/2016 -
		
		
		' INI: Anexos ------------------------------------------------------------------------
		' Adicionada exibição de anexos ------------------------------------------------------
		' ------------------------------------------------------------- by Aless 08/05/12 ----<br />
		if Not(varObjConn is nothing) Then 
			'Busca anexo principal
			If prCOD <> "" Then 
				strSQL = "SELECT ARQUIVO_ANEXO FROM TL_TODOLIST WHERE COD_TODOLIST = " & prCOD
				AbreRecordSet objRS, strSQL, varObjConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
				strNomeArquivo = GetValue(objRS, "ARQUIVO_ANEXO")
				'strARQUIVO_ANEXO = strLogicalPath & "/upload/" & Request.Cookies("VBOSS")("CLINAME") & "/TODO_Anexos/" & strNomeArquivo
				strARQUIVO_ANEXO = strLogicalPath & "/athDownloader.asp?var_cliente=" & Request.Cookies("VBOSS")("CLINAME") & "&var_tipo=TODO_Anexos&var_arquivo=" & strNomeArquivo
				FechaRecordSet objRS
			End If	
			
			bTemAnexo = False
			'strARQUIVO_ANEXO = "{393D8E01-D97F-46C4-9CA0-863C13443BF}_RotinaEmManutencao.tmp"
			if strNomeArquivo <> "" then
			    bTemAnexo = True
				auxStr = auxStr & "<tr><td align=right valign=top width=10% nowrap>Documento:&nbsp;</td><td width='90%'>"
				auxStr = auxStr & "<a href='" & strARQUIVO_ANEXO & "' "
				auxStr = auxStr & " style='cursor:hand;text-decoration:none;' target='_blank'><img src='" & ConvTipoToIcon(5) & "' border='0' title='Documento' alt='Documento'>&nbsp;DOWNLOAD&nbsp;</a><small>"
				auxStr = auxStr & "&nbsp;&nbsp;" & Replace(strNomeArquivo,"}_","}_<b>") & "</b></small></td></tr>"
			End If
	
			' Faz a busca dos arquivos anexos deste TODO, se tem algum anexo monta a estrutura
			If prCOD <> "" Then 
				strSQL = "SELECT COD_ANEXO, COD_TODOLIST, ARQUIVO, DESCRICAO FROM TL_ANEXO WHERE COD_TODOLIST = " & prCOD & " ORDER BY SYS_DTT_INS " 
				'response.Write(strSQL)
				'response.End()
				AbreRecordSet objRS, strSQL, varObjConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
				if not objRS.eof then 
    			    bTemAnexo = True
					auxStr = auxStr & "<tr><td>&nbsp;</td><td><hr></td></tr>"
					auxStr = auxStr & "<tr><td align='right' valign='top'>Anexos:&nbsp;</td>"
					auxStr = auxStr & "<td>"
					do while not objRS.Eof
					
						auxStr = auxStr & "<div style='margin-bottom:10px;'><div>"
						'auxStr = auxStr & "<a href='" & strLogicalPath & "/upload/" & Request.Cookies("VBOSS")("CLINAME") & "/TODO_Anexos/" & GetValue(objRS, "ARQUIVO") & "' " 
						auxStr = auxStr & "<a href='" & strLogicalPath &"/athDownloader.asp?var_cliente=" & Request.Cookies("VBOSS")("CLINAME") & "&var_tipo=TODO_Anexos" & "&var_arquivo=" & GetValue(objRS, "ARQUIVO") & "' " 
						auxStr = auxStr & " style='cursor:hand;text-decoration:none;' target='_blank'>"
						auxStr = auxStr & "	<img src='" & ConvTipoToIcon(5) &"' border='0' title='Documento' alt='Documento'>&nbsp;DOWNLOAD&nbsp;</a><small>&nbsp;&nbsp; "
						auxStr = auxStr & Replace(GetValue(objRS, "ARQUIVO"),"}_","}_<b>") & "</b></small></div> "
						auxStr = auxStr & " <div>" & GetValue(objRS, "DESCRICAO") & "</div></div>"	
					objRS.MoveNext
					loop 
					auxStr = auxStr & "</td></tr>"
				end if 
				FechaRecordSet objRS			
		    End If	
		End If
			if (bTemAnexo) Then
				 'Mensagem que instrui o usuário a buscar os arquivos diretamene no VBOSS, caso não consiga visualizá-los ou baixá-los.
				 strMsgUser = "<i>ATENÇÃO: Caso não consiga realizar o download, acesse o arquivo diretamente no VirtualBOSS.</i>"
				 auxStr = auxStr & "<tr height='10px'><td></td><td></td></tr>" & vbcrLF & "<tr><td align='right' valign='top' width='10%' nowrap>&nbsp;</td><td width='90%'>" & strMsgUser  & "</td></tr>" & vbcrLF
			End If			
		' FIM: Anexos ------------------------------------------------------------------------
	 End if
	 auxStr = auxStr &  "</table><br>"
 End If
 
 If prPARAM = "AGENDA" Then
	 auxStr = "<table width=100% border=0 cellpadding=1 cellspacing=0 style=""font-family:Tahoma, Verdana; font-size:11;"">" & vbcrLF &_ 
			"<tr><td>&nbsp</td><td><b>" & prTitMsg & "</b></td></tr>" & vbcrLF &_
			"<tr><td colspan=2 height=10></td></tr>" & vbcrLF &_
			"<tr><td align=right valign=top width=10% nowrap >Título:&nbsp;   </td><td width='90%'>" & prTITULO    & "</td></tr>" & vbcrLF &_
			"<tr><td align=right valign=top width=10% nowrap >Situação:&nbsp; </td><td width='90%'><b>" & prSITUACAO  & "</b></td></tr>" & vbcrLF &_
			"<tr><td align=right valign=top width=10% nowrap >Categoria:&nbsp;</td><td width='90%'>" & prCATEGORIA & "</td></tr>" 
	 if prTipo="FULL" then
	 auxStr = auxStr &_
			"<tr><td align=right valign=top nowrap>Prioridade:&nbsp;</td><td width='90%'>" & prPRIORIDADE & "</td></tr>" & vbcrLF &_
			"<tr><td align=right valign=top width=10% nowrap>Responsável:&nbsp;    </td><td width='90%'>" & prRESPONSAVEL  & "</td></tr>" & vbcrLF &_
			"<tr><td align=right valign=top width=10% nowrap>Citados:&nbsp;        </td><td width='90%'>" & prEXECUTOR     & "</td></tr>" & vbcrLF &_
			"<tr><td align=right valign=top width=10% nowrap>Previsão:&nbsp;       </td><td width='90%'>" & prPREV_DT_INI  & "</td></tr>" & vbcrLF &_
			"<tr><td align=right valign=top width=10% nowrap>Data Realizado:&nbsp; </td><td width='90%'>" & prDT_REALIZADO & "</td></tr>" & vbcrLF &_
			"<tr><td align=right valign=top width=10% nowrap><b>Tarefa:</b>&nbsp;  </td><td width='90%'>" & prDESC & "</td></tr>" 
	 end if
	 auxStr = auxStr &  "</table><br>"
 End If
 
 If prPARAM = "CHAMADO" Then
	 auxStr = "<table width=100% border=0 cellpadding=1 cellspacing=0 style=""font-family:Tahoma, Verdana; font-size:11;"">" & VbCrlf &_ 
				"	<tr><td>&nbsp</td><td><b>" & prTitMsg & "</b></td></tr>" & VbCrlf &_
				"	<tr><td colspan=2 height=10></td></tr>" & VbCrlf &_
				"	<tr><td align=right valign=top width=10% nowrap >Título:&nbsp;   </td><td width='90%'>" 
	 If prCOD <> "" Then auxStr = auxStr & prCOD & " - " 
	 auxStr = auxStr & prTITULO & "</td></tr>" & VbCrlf &_
				"	<tr><td align=right valign=top width=10% nowrap >Situação:&nbsp; </td><td width='90%'><b>" & prSITUACAO  & "</b></td></tr>" & VbCrlf &_
				"	<tr><td align=right valign=top width=10% nowrap >Categoria:&nbsp;</td><td width='90%'>" & prCATEGORIA & "</td></tr>" & VbCrlf
	 
	 if prTipo="FULL" then
	 auxStr = auxStr &_
			"<tr><td align=right valign=top nowrap>Prioridade:&nbsp;</td><td width='90%'>" & prPRIORIDADE & "</td></tr>" & vbcrLF &_
			"<tr><td align=right valign=top width=10% nowrap>Quem inseriu:&nbsp;    </td><td width='90%'>" & prRESPONSAVEL & "</td></tr>" & vbcrLF &_
			"<tr><td align=right valign=top width=10% nowrap>Quem desbloqueou:&nbsp; </td><td width='90%'>" & prEXECUTOR & "</td></tr>" & vbcrLF &_
			"<tr><td align=right valign=top width=10% nowrap><b>Chamado:</b>&nbsp;  </td><td width='90%'>" & prDESC & "</td></tr>" 
	 end if
	 auxStr = auxStr &  "</table><br>"
 End If
 MontaHeaderToDo = auxStr
end function

function MontaBodyLinhaHeader(prVINCULO_CHAMADO)
 If prVINCULO_CHAMADO = "T" Then
	 MontaBodyLinhaHeader = "<tr>" & vbcrLF &_ 
	   "<td align=left width=2%  ><div style=""padding-left:3px; padding-right:3px;"" >Data</div></td>" & vbcrLF &_
	   "<td align=left width=96% colspan=3 ><div style=""padding-left:3px; padding-right:3px;"" >Mensagem</div></td>" & vbcrLF &_
	   "<td align=left width=2%  ><div style=""padding-left:3px; padding-right:3px;"" >Anexo</div></td>" & vbcrLF &_	   	   
	   "</tr>" 
 Else
	 MontaBodyLinhaHeader = "<tr>" & vbcrLF &_ 
	   "<td align=left width=2%  ><div style=""padding-left:3px; padding-right:3px;"" >Data</div></td>" & vbcrLF &_
	   "<td align=left width=4%  ><div style=""padding-left:3px; padding-right:3px;"" >De</div></td>" & vbcrLF &_
	   "<td align=left width=4%  ><div style=""padding-left:3px; padding-right:3px;"" >Para</div></td>" & vbcrLF &_
	   "<td align=left width=88% ><div style=""padding-left:3px; padding-right:3px;"" >Mensagem</div></td>" & vbcrLF &_
	   "<td align=left width=2%  ><div style=""padding-left:3px; padding-right:3px;"" >Anexo</div></td>" & vbcrLF &_	   
	   "</tr>" 
 End If
end function

function MontaBodyLinhaContent(prDTT, prEXECUTOR_FROM, prEXECUTOR_TO, prRESPOSTA, prANEXO)
 If prEXECUTOR_FROM <> "" Or prEXECUTOR_TO <> "" Then
	 MontaBodyLinhaContent = "<tr>" & vbcrLF &_
	   "<td align=left width=2%  valign=top nowrap ><div style=""padding-left:3px; padding-right:3px;"" >"& prDTT &"</div></td>" & vbcrLF &_
	   "<td align=left width=4%  valign=top nowrap ><div style=""padding-left:3px; padding-right:3px;"" ><font color=#999999 >"& prEXECUTOR_FROM &"</font></div></td>" & vbcrLF &_
	   "<td align=left width=4%  valign=top nowrap ><div style=""padding-left:3px; padding-right:3px;"" >"& prEXECUTOR_TO &"</div></td>" & vbcrLF &_
  	   "<td align=left width=88% valign=top ><div style=""padding-left:3px; padding-right:3px;"" >"& prRESPOSTA &"</div></td>" & vbcrLF
	 'athDebug MontaBodyLinhaContent, True		 
 Else
	 MontaBodyLinhaContent = "<tr>" & vbcrLF &_
	   "<td align=left width=2%  valign=top nowrap ><div style=""padding-left:3px; padding-right:3px;"" >"& prDTT &"</div></td>" & vbcrLF &_
   "<td align=left width=98% colspan=3 valign=top><div style=""padding-left:3px; padding-right:3px;"" >"& prRESPOSTA &"</div></td>" & vbcrLF
 End If
 'Coloca o anexo da resposta, caso exista.
 if(prANEXO <> "") Then 			
   MontaBodyLinhaContent = MontaBodyLinhaContent & "<td align=center width=2%  valign=top nowrap ><div style='padding-left:3px; padding-right:3px;'><a href='" & FindLogicalPath() & "/athDownloader.asp?var_cliente=" & Request.Cookies("VBOSS")("CLINAME") & "&var_tipo=RESPOSTA_Anexos&var_arquivo=" & prANEXO & "'><img src='" & ConvTipoToIcon(5) & "' alt='Anexo' title='Anexo' border='0'></a></div></td>" & vbcrLF
  End If	  
 MontaBodyLinhaContent = MontaBodyLinhaContent & "</tr>"   
end function

function MontaBodyLinhaContentSimples(prDTT, prRESPOSTA)
 MontaBodyLinhaContentSimples = "<tr>MontaBodyLinhaContentSimples" & vbcrLF &_
   "<td align=left width=2%  valign=top nowrap ><div style=""padding-left:3px; padding-right:3px;"" >"& prDTT &"</div></td>" & vbcrLF &_
   "<td align=left width=98% colspan=3 valign=top><div style=""padding-left:3px; padding-right:3px;"" >"& prRESPOSTA &"</div></td>" & vbcrLF &_ 
 "</tr>" 
end function


function MontaFooterMail
  dim auxstr
  
  auxstr = "<table width=100% cellspacing=0 cellpadding=1 border=0>" & vbcrLF
  auxstr = auxstr & "<tr><td height=1 bgcolor=#c9c9c9 ></td></tr>" & vbcrLF
  auxstr = auxstr & "<tr>" & VbCrLf 
  auxstr = auxstr & "	<td>" & VbCrLf
  auxstr = auxstr & "		<table width='100%' style='font-family:Tahoma, Verdana; font-size:9;'>" & VbCrLf 
  auxstr = auxstr & "        	<tr>" & VbCrLf 
  auxstr = auxstr & "            	<td align='left' style='width:100%; padding-left:5px;text-align:left; color:#999999;' >" & VbCrLf 
  auxstr = auxstr & "               	<font style='color:#999999;'>Mensagem enviada automaticamente, NÃO RESPONDER DIRETAMENTE ESTE EMAIL, para responder acesse o VirtualBOSS.</font> " & VbCrLf 
  auxstr = auxstr & "            	</td>" & VbCrLf  
 'auxstr = auxstr & "            	<td align='right' style='width:50% padding-right:5px;text-align:right; color:#999999;;'>" & VbCrLf 
 'auxstr = auxstr & "                    VIRTUAL BOSS - desenvolvido por" & VbCrLf 
 'auxstr = auxstr & "                    <a href='http://www.proevento.com.br' target='_blank' style='color:#006699; font:none 11px; text-decoration:none;'>PROEVENTO <span style='font-size=8px; font-family: Arial color: #006699; text-decoration: none; letter-spacing:2px;'>TECNOLOGIA</span></a>." 
 'auxstr = auxstr & "           	 </td>" & VbCrLf 
  auxstr = auxstr &	"       	 </tr>" & VbCrLf 
  auxstr = auxstr & "		</table>" & VbCrLf 
  auxstr = auxstr & "	</td>" & VbCrLf 
  auxstr = auxstr & "</tr>" & vbcrLF 
  auxstr = auxstr & "</table>" & vbcrLF 
  auxstr = auxstr & "</body></html>"   

  MontaFooterMail = auxstr
end function


function MontaBody(byref varBody,prTipo,prTitMsg,prCOD,prTITULO,prSITUACAO,prCATEGORIA,prPRIORIDADE,prRESPONSAVEL,prEXECUTOR,prPREV_DT_INI,prDT_REALIZADO,prDESC,prBS,prPARAM,prVINCULO_CHAMADO)
Dim strAuxTabela
  strAuxTabela = varBody
  varBody = MontaHeaderMail(prTipo,prPARAM) 
  varBody = varBody & MontaHeaderToDo(prTitMsg,"FULL",prCOD,prTITULO,prSITUACAO,prCATEGORIA,prPRIORIDADE,prRESPONSAVEL,prEXECUTOR,prPREV_DT_INI,prDT_REALIZADO,prDESC,prBS,prPARAM,prVINCULO_CHAMADO, nothing)
  if (strAuxTabela <> "") Then
    varBody = varBody & strAuxTabela
  End If	
  varBody = varBody & MontaFooterMail
end function

function MontaBodyFull(byref varBody,prTipo,prTitMsg,prCOD,prTITULO,prSITUACAO,prCATEGORIA,prPRIORIDADE,prRESPONSAVEL,prEXECUTOR,prPREV_DT_INI,prDT_REALIZADO,prDESC,prBS,prPARAM,prVINCULO_CHAMADO)
  Dim auxObjRS, auxStrSQL, auxObjConn, auxID_FROM, auxID_TO
  
  AbreDBConn auxObjConn, CFG_DB 
  
  varBody = MontaHeaderMail(prTipo,prPARAM)
  
  If prPARAM = "TODOLIST" Then
	  varBody = varBody & MontaHeaderToDo(prTitMsg,"FULL",prCOD,prTITULO,prSITUACAO,prCATEGORIA,prPRIORIDADE,prRESPONSAVEL,prEXECUTOR,prPREV_DT_INI,prDT_REALIZADO,prDESC,prBS,prPARAM,prVINCULO_CHAMADO, auxObjConn) 
	  varBody = varBody &_
			"<table width=100% align=center border=0 cellpadding=3 cellspacing=0 style=""font-family:Tahoma; font-size:11;"" >" & vbcrLF &_
			"<tr><td><b>Respostas</b><br></td></tr>" & vbcrLF &_ 
			"<tr><td align=center>"  
	  varBody = varBody & "  <table width=100% border=0 cellpadding=1 cellspacing=0 style=""font-family:Tahoma; font-size:11;"" >" & vbcrLF
	  varBody = varBody & MontaBodyLinhaHeader(prVINCULO_CHAMADO)
	  
	  If prVINCULO_CHAMADO = "T" Then
		  auxStrSQL = "SELECT DTT_RESPOSTA, RESPOSTA, ARQUIVO_ANEXO FROM TL_RESPOSTA WHERE COD_TODOLIST = " & prCOD & " ORDER BY DTT_RESPOSTA DESC"
		  set auxObjRS = objConn.Execute(auxStrSQL)
		  While Not auxObjRS.EOF
			varBody = varBody & "<tr><td align=left width=100% height=1 colspan=5 bgcolor=#999999 ></td></tr>" & vbcrLF
			varBody = varBody & MontaBodyLinhaContent(GetValue(auxObjRS,"DTT_RESPOSTA"),"","",GetValue(auxObjRS,"RESPOSTA"),GetValue(auxObjRS,"ARQUIVO_ANEXO"))
			auxObjRS.MoveNext 
		  Wend 
	  Else
		  auxStrSQL = "SELECT DTT_RESPOSTA, ID_FROM, ID_TO, RESPOSTA, ARQUIVO_ANEXO FROM TL_RESPOSTA WHERE COD_TODOLIST = " & prCOD & " ORDER BY DTT_RESPOSTA DESC"
		  set auxObjRS = objConn.Execute(auxStrSQL)
		  While Not auxObjRS.EOF
			varBody = varBody & "<tr><td align=left width=100% height=1 colspan=5 bgcolor=#999999 ></td></tr>" & vbcrLF
			varBody = varBody & MontaBodyLinhaContent(GetValue(auxObjRS,"DTT_RESPOSTA"),GetValue(auxObjRS,"ID_FROM"),GetValue(auxObjRS,"ID_TO"),GetValue(auxObjRS,"RESPOSTA"),GetValue(auxObjRS,"ARQUIVO_ANEXO"))
			auxObjRS.MoveNext 
		  Wend 
	  End If 
	  
	  varBody = varBody & "  </table>"
	  varBody = varBody & "</td></tr></table><br>" & vbcrLF
  End If
  
  If prPARAM = "AGENDA" Then
	  varBody = varBody & MontaHeaderToDo(prTitMsg,"FULL","",prTITULO,prSITUACAO,prCATEGORIA,prPRIORIDADE,prRESPONSAVEL,prEXECUTOR,prPREV_DT_INI,prDT_REALIZADO,prDESC,prBS,prPARAM,prVINCULO_CHAMADO, auxObjConn) 
	  varBody = varBody &_
			"<table width=100% align=center border=0 cellpadding=3 cellspacing=0 style=""font-family:Tahoma; font-size:11;"" >" & vbcrLF &_
			"<tr><td><b>Respostas</b><br></td></tr>" & vbcrLF &_ 
			"<tr><td align=center>"  
	  varBody = varBody & "  <table width=100% border=0 cellpadding=1 cellspacing=0 style=""font-family:Tahoma; font-size:11;"" >" & vbcrLF
	  varBody = varBody & MontaBodyLinhaHeader(prVINCULO_CHAMADO)
	  
	  auxStrSQL = "SELECT DTT_RESPOSTA, ID_FROM, ID_TO, RESPOSTA FROM AG_RESPOSTA WHERE COD_AGENDA = " & prCOD & " ORDER BY DTT_RESPOSTA DESC"
	  set auxObjRS = objConn.Execute(auxStrSQL)
	  While Not auxObjRS.EOF
		auxID_FROM = LCase(GetValue(auxObjRS,"ID_FROM"))
		if mid(auxID_FROM,1,1)=";" then auxID_FROM = mid(auxID_FROM,2)
		
		auxID_TO = LCase(GetValue(auxObjRS,"ID_TO"))
		if mid(auxID_TO,1,1)=";" then auxID_TO = mid(auxID_TO,2)
		if auxID_TO <> "" then 
			if mid(auxID_TO,Len(auxID_TO))<>";" then auxID_TO = auxID_TO & ";"
		end if
		
		varBody = varBody & "<tr><td align=left width=100% height=1 colspan=5 bgcolor=#999999 ></td></tr>" & vbcrLF
		varBody = varBody & MontaBodyLinhaContent(PrepData(GetValue(auxObjRS,"DTT_RESPOSTA"),true,false),auxID_FROM,auxID_TO,GetValue(auxObjRS,"RESPOSTA"),"")
		auxObjRS.MoveNext 
	  Wend 
	  varBody = varBody & "  </table>"
	  varBody = varBody & "</td></tr></table><br>" & vbcrLF
	  
	  FechaRecordSet auxObjRS
  End If
  
  varBody = varBody & MontaFooterMail
  
  FechaDBConn auxObjConn
end function

%>