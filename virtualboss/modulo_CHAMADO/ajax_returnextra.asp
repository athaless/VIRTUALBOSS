<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<%
 Dim objConn, strSQL, objRS 
 Dim strCOD_CLI, strSITUACAO, strUSER_GRP
 Dim auxStr, StrEMPRESAOld, StrEMPRESANew

 strCOD_CLI		= GetParam("var_cod_cli")
 strSITUACAO	= GetParam("var_situacao")
 strUSER_GRP	= GetParam("var_usrgrp")

 'athDebug "Debug: codepage." & Response.CodePage, true

 if strSITUACAO <> "" then
	if InStr(strSITUACAO,"_") = 1 then 
		auxStr = Replace(strSITUACAO,"_", " <> '",1) & "' " 	 
	else 
		auxStr = " = '" & strSITUACAO & "' " 
	end if
	strSITUACAO = " AND CC.SITUACAO " & auxStr 
 end if

 StrEMPRESAOld = ""
 StrEMPRESANew = ""

 AbreDBConn objConn, CFG_DB 
 
 response.write "<select name='var_extra' id='var_extra' class='edtext_combo' style='width:120px;'>"
 response.write "<option value='' selected>[extra/evento]</option>"
 If strUSER_GRP <> "CLIENTE" Then 
		strSQL = " SELECT 		   DISTINCT CC.EXTRA " 
		strSQL = strSQL &  "      ,ET.COD_CLIENTE " 
		strSQL = strSQL &  "      ,ET.NOME_COMERCIAL " 
		strSQL = strSQL &  "  FROM CH_CHAMADO CC,USUARIO US, ENT_CLIENTE ET " 
		strSQL = strSQL &  " WHERE US.TIPO = 'ENT_CLIENTE' " 
		strSQL = strSQL &  "   AND US.CODIGO = ET.COD_CLIENTE " 
		strSQL = strSQL &  "   AND US.ID_USUARIO = CC.SYS_ID_USUARIO_INS " 
		strSQL = strSQL &  "   AND CC.EXTRA NOT LIKE '' " 
		strSQL = strSQL &  strSITUACAO 
		If (strCOD_CLI<>"") then 
		   strSQL = strSQL & " AND US.CODIGO = " & strCOD_CLI  
		End If
		strSQL = strSQL & " ORDER BY ET.NOME_COMERCIAL, CC.EXTRA " 
	
		Set objRS = objConn.Execute(strSQL)
		Do While Not objRS.Eof
		  StrEMPRESANew = GetValue(objRS,"COD_CLIENTE")							
		  if StrEMPRESAOld <> StrEMPRESANew Then
			 if StrEMPRESAOld <> "" then
			   Response.write("</optgroup>")
			 End If  
			 Response.write("<optgroup label='" & GetValue(objRS,"NOME_COMERCIAL") & "." & StrEMPRESANew & "'>")
			 StrEMPRESAOld = StrEMPRESANew
		  End If		  
		  Response.Write("<option value='" & GetValue(objRS, "EXTRA") & "'>" & GetValue(objRS, "EXTRA") & "</option>" & vbnewline)
		  objRS.MoveNext
		Loop
		FechaRecordSet objRS
 Else 
		strSQL = "SELECT DISTINCT CC.EXTRA " &_
				 "  FROM CH_CHAMADO CC, USUARIO US  " &_
				 " WHERE US.CODIGO = " & strCOD_CLI &_
				 "   AND US.TIPO = 'ENT_CLIENTE'  " &_
				 "   AND US.ID_USUARIO = CC.SYS_ID_USUARIO_INS  " &_
				 "   AND CC.EXTRA NOT LIKE ''  " &_
				 "   AND " & strSITUACAO &_
				 " ORDER BY EXTRA "
		response.write montaCombo("STR",strSQL, "EXTRA", "EXTRA", "") 
 End If 

 response.write "</select>"
 FechaDBConn objConn
%>