<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<!--#include file="../_include/_IncludePonto_CalcTotais.asp"--> 
<%
  Dim ObjConn, strSQL, objRSTs
  Dim strIN, strOUT
  
  if (GetParam("var_id_usuario")<>"") then 
	strIN  = replace(GetParam("txtHH1") & ":" & GetParam("txtMM1") + ":00", "::00","")
	strOUT = replace(GetParam("txtHH2") & ":" & GetParam("txtMM2") + ":00", "::00","")

    if VerifyDATAConstrains (GetParam("var_id_usuario"), -1, GetParam("var_dt_dia"),GetParam("var_dt_mes"),GetParam("var_dt_ano"),strIN, strOUT) then 
       AbreDBConn ObjConn, CFG_DB
	   if (strIN = "")  then strIN  = "NULL" else strIN  = ("'" & strIN & "'")
	   if (strOUT = "") then strOUT = "NULL" else strOUT = ("'" & strOUT & "'")
       strSQL = "INSERT INTO PT_PONTO (  ID_USUARIO, COD_EMPRESA " & _
									   ",DATA_DIA, DATA_MES, DATA_ANO" &_
									   ",HORA_IN, HORA_OUT" & _
									   ",OBS" & _
									   ",STATUS) " & _
					          "VALUES ('" & GetParam("var_id_usuario") & "', '" & GetParam("var_empresa") & "' " & _
							  	      ","  & GetParam("var_dt_dia") & "," & GetParam("var_dt_mes") & "," & GetParam("var_dt_ano") & _
								      ","  &  strIN & "," & strOUT & _
								      ",'" & GetParam("txtObs") & "'" &_
								      ",'" & GetParam("var_status") & "')"	
       'Response.Write(strSQL)
       'Response.End()
 
 		'AQUI: NEW TRANSACTION
		set objRSTs  = objConn.Execute("start transaction")
		set objRSTs  = objConn.Execute("set autocommit = 0")
		objConn.Execute(strSQL)  
		If Err.Number <> 0 Then
		  set objRSTs = objConn.Execute("rollback")
		  Mensagem "modulo_PONTO.insertquick_exec: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		  Response.End()
		else
		  set objRSTs = objConn.Execute("commit")
		End If
	   
	   RecalculaTOTALDIA GetParam("var_id_usuario"), GetParam("var_dt_dia"), GetParam("var_dt_mes"), GetParam("var_dt_ano") 
	   RecalculaTOTALDIAEMPRESA GetParam("var_empresa"), GetParam("var_id_usuario"), GetParam("var_dt_dia"), GetParam("var_dt_mes"), GetParam("var_dt_ano") 
       FechaDBConn ObjConn
	else
		response.write("<script>alert('Erro, uma das datas está dentro de outro horário já estabelecido');")
		response.write("window.close()</script>")
	end if
  end if
%>
<script>
  location.href = "../modulo_PAINEL/painel.asp"
</script>