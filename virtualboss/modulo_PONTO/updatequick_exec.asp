<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<!--#include file="../_include/_IncludePonto_CalcTotais.asp"--> 
<%
  Dim ObjConn, strSQL,objRSCT
  Dim strIN, strOUT
  
  if (GetParam("var_id_usuario")<>"") then 
	strIN  = replace(GetParam("txtHH1") & ":" & GetParam("txtMM1") + ":00", "::00","")
	strOUT = replace(GetParam("txtHH2") & ":" & GetParam("txtMM2") + ":00", "::00","")
	if (strIN = "")  then strIN  = "NULL" else strIN  = ("'" & strIN & "'")
	if (strOUT = "") then strOUT = "NULL" else strOUT = ("'" & strOUT & "'")

    if VerifyDATAConstrains ( GetParam("var_id_usuario"), GetParam("var_chavereg"), GetParam("var_dt_dia"), GetParam("var_dt_mes"), GetParam("var_dt_ano"), strIN, strOUT ) then 
      AbreDBConn ObjConn, CFG_DB
	  strSQL = "UPDATE PT_PONTO SET " &_ 
			 "  ID_USUARIO = '"    & GetParam("var_id_usuario") & "'" & _
			 " ,COD_EMPRESA= '"    & GetParam("var_empresa") & "'"  & _
			 " ,DATA_DIA = "       & GetParam("var_dt_dia") & _
			 " ,DATA_MES = "       & GetParam("var_dt_mes") & _
			 " ,DATA_ANO = "       & GetParam("var_dt_ano") & _
			 " ,HORA_IN = "        & strIN & _
			 " ,HORA_OUT = "       & strOUT & _
			 " ,STATUS = '"        & GetParam("var_status") & "' " & _
			 " ,OBS = '"           & GetParam("txtObs") & "' " & _
			 " WHERE COD_PONTO = " & GetParam("var_chavereg")
      'Response.Write(strSQL)
      'Response.End()

	  'AQUI: NEW TRANSACTION
	  set objRSCT = objConn.Execute("start transaction")
	  set objRSCT = objConn.Execute("set autocommit = 0")
      ObjConn.Execute(strSQL)
	  if Err.Number<>0 then 
	    set objRSCT= objConn.Execute("rollback")
		Mensagem "modulo_PONTO.updatequick_exec: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	    Response.End()
	  else	  
	    set objRSCT= objConn.Execute("commit")
	  End If

	  RecalculaTOTALDIA GetParam("var_id_usuario"), GetParam("var_dt_dia"), GetParam("var_dt_mes"), GetParam("var_dt_ano") 

      RecalculaTOTALDIAEMPRESA GetParam("var_empresa"), GetParam("var_id_usuario"), GetParam("var_dt_dia"), GetParam("var_dt_mes"), GetParam("var_dt_ano") 
	  if GetParam("var_empresa") <> GetParam("var_empresa_old") then 
        RecalculaTOTALDIAEMPRESA GetParam("var_empresa_old"), GetParam("var_id_usuario"), GetParam("var_dt_dia"), GetParam("var_dt_mes"), GetParam("var_dt_ano") 
      end if
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