<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
  Dim objConn, objRS_A, objRS_C, strSQL, strSQLINS, objRSTs
  Dim auxQTDE, auxSTR

  AbreDBConn objConn, getParam("VAR_db")
 
  set objRS_A = objConn.Execute("SELECT ID_USUARIO FROM USUARIO")

  While not objRS_A.EOF
    strSQL= "SELECT count(COD_PAINEL) as QTDE FROM SYS_painel WHERE IMG = 'ICO_VBOSS_01.gif' AND ID_USUARIO = '" & objRS_A("ID_USUARIO") & "'"
    set objRS_C = objConn.Execute(strSQL)
    auxQTDE = objRS_C("QTDE")
    'FechaRecorset(objRS_C)

    response.write(objRS_A("ID_USUARIO") & ": <BR>")
    If cInt(auxQTDE)<=0 then 
      strSQLINS = "INSERT INTO SYS_PAINEL (ROTULO,DESCRICAO,IMG,LINK,TARGET,ORDEM,ID_USUARIO) VALUES ('Agenda','Agenda','ICO_VBOSS_01.gif','../modulo_AGENDA/Default.htm','vbNucleo',10,'" & objRS_A("ID_USUARIO") & "')"
		'AQUI: NEW TRANSACTION
		set objRSTs  = objConn.Execute("start transaction")
		set objRSTs  = objConn.Execute("set autocommit = 0")
		objConn.Execute(strSQLINS)  
		If Err.Number <> 0 Then
		  set objRSTs = objConn.Execute("rollback")
		  Mensagem "modulo_PAINEL.InsereICONPONTO: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		  Response.End()
		else
		  set objRSTs = objConn.Execute("commit")
		End If

      response.write(strSQLINS & "<BR>")
    end  if
   objRS_A.movenext
  wend

  'FechaRecordSet(objRS_A) 
  FechaDBConn objConn
%>