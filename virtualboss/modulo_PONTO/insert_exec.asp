<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<!--#include file="../_include/_IncludePonto_CalcTotais.asp"--> 
<%
  Dim ObjConn, strSQL, objRSTs
  Dim strIN, strOUT, strHH1, strHH2, strMM1, strMM2
  Dim strCODIGO, strID_USUARIO, strDT_DIA, strDT_MES, strDT_ANO
  Dim strSTATUS, strOBS, strEMPRESA, strEMPRESA_OLD
  Dim strJSCRIPT_ACTION, strLOCATION
  
  strHH1			 = GetParam("var_hh1")
  strHH2			 = GetParam("var_hh2")
  strMM1			 = GetParam("var_mm1")
  strMM2			 = GetParam("var_mm2")
  strCODIGO			 = GetParam("var_chavereg")
  strID_USUARIO		 = GetParam("var_id_usuario")
  strDT_DIA			 = GetParam("var_dt_dia")
  strDT_MES			 = GetParam("var_dt_mes")
  strDT_ANO			 = GetParam("var_dt_ano")
  strSTATUS			 = GetParam("var_status")
  strOBS			 = GetParam("var_obs")
  strEMPRESA		 = GetParam("var_empresa")
  strEMPRESA_OLD	 = GetParam("var_empresa_old")
  strJSCRIPT_ACTION	 = GetParam("JSCRIPT_ACTION")
  strLOCATION		 = GetParam("DEFAULT_LOCATION")
  
  if strID_USUARIO <> "" then 
    strIN  = replace(strHH1 & ":" & strMM1 & ":00", "::00","")
    strOUT = replace(strHH2 & ":" & strMM2 & ":00", "::00","")
	
    if VerifyDATAConstrains (strID_USUARIO, -1, strDT_DIA, strDT_MES, strDT_ANO, strIN, strOUT) then 
	   AbreDBConn ObjConn, CFG_DB
	   if strIN = ""  then strIN  = "NULL" else strIN  = "'" & strIN & "'"
	   if strOUT = "" then strOUT = "NULL" else strOUT = "'" & strOUT & "'"
	   strSQL = "INSERT INTO PT_PONTO (ID_USUARIO, COD_EMPRESA, DATA_DIA, DATA_MES, DATA_ANO, HORA_IN, HORA_OUT, OBS, STATUS) " & _
			    "VALUES ('" & strID_USUARIO & "', '" & strEMPRESA & "'," & strDT_DIA & "," & strDT_MES & "," & strDT_ANO & _
				       "," & strIN & "," & strOUT & ",'" & strOBS & "'" & ",'" & strSTATUS & "')"
	   
	  'AQUI: NEW TRANSACTION
	   set objRSTs  = objConn.Execute("start transaction")
	   set objRSTs  = objConn.Execute("set autocommit = 0")
	   objConn.Execute(strSQL)
	   If Err.Number <> 0 Then
 		  set objRSTs = objConn.Execute("rollback")
		  Mensagem "modulo_PONTO.insert_exec: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		  Response.End()
	   else
		  set objRSTs = objConn.Execute("commit")
	   End If
	   
	   RecalculaTOTALDIA strID_USUARIO, strDT_DIA, strDT_MES, strDT_ANO 
	   RecalculaTOTALDIAEMPRESA strEMPRESA, strID_USUARIO, strDT_DIA, strDT_MES, strDT_ANO 
	   
	   FechaDBConn ObjConn

	   response.write "<script type='text/javascript' language='JavaScript'>" & vbCrlf 
	   if (strJSCRIPT_ACTION <> "") then response.write strJSCRIPT_ACTION & vbCrlf end if
	   if (strLOCATION <> "") then response.write "location.href='" & strLOCATION & "'" & vbCrlf end if
	   response.write "</script>"
   else
	   response.write("<script>alert('Erro, uma das datas está dentro de outro horário já estabelecido');" & vbCrlf)
	   response.write strJSCRIPT_ACTION & vbCrlf
	   response.write("</script>")
   end if
 end if
%>