<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
 Session.LCID = 1046 

 Dim strSQL, objRS, ObjConn, strBodyMsg, strDtAnt, auxTpMsg, auxSTR, objRSCT   
 Dim strCOD, strNOME, strAUTORES, strDESCRICAO, strIDPROCESSO, strHOMOLOGACAO, strCODCATEGORIA, strDATA, strNOW
 Dim strJSCRIPT_ACTION, strLOCATION
	
 strNOME           = GetParam("var_nome")
 strAUTORES        = GetParam("var_autores")
 strDESCRICAO      = GetParam("var_descricao")
 strDATA           = GetParam("var_data")
 strIDPROCESSO     = GetParam("var_id_processo")
 strHOMOLOGACAO    = GetParam("var_dt_homologacao")
 strCODCATEGORIA   = GetParam("var_cod_categoria")
 strJSCRIPT_ACTION = GetParam("JSCRIPT_ACTION")
 strLOCATION       = GetParam("DEFAULT_LOCATION")
 
 'Formata as datas para serem inseridas no registro
 if not isDate(strDATA) then strDATA  = "Null" else strDATA = "'" & PrepDataBrToUni(strDATA,false) & "'"
 if not isDate(strHOMOLOGACAO) then strHOMOLOGACAO = "Null" else strHOMOLOGACAO = "'" & PrepDataBrToUni(strHOMOLOGACAO,true) & "'"
 
 AbreDBConn ObjConn, CFG_DB
 
 'Executa a atualização do registro no banco
 strSQL = "INSERT INTO PROCESSO (ID_PROCESSO, NOME, AUTORES, DESCRICAO, DATA, COD_CATEGORIA, DT_HOMOLOGACAO, SYS_DT_CRIACAO, SYS_INS_ID_USUARIO) VALUES " &_ 
		  "('" & strIDPROCESSO & "','" & strNOME & "','" & strAUTORES & "','" & strDESCRICAO & "'," & strDATA & _
		  "," & strCODCATEGORIA & "," & strHOMOLOGACAO & ",'" & PrepDataBrToUni(Now,true) & "', '" & Request.Cookies("VBOSS")("ID_USUARIO") & "')"

 'AQUI: NEW TRANSACTION
 set objRSCT  = objConn.Execute("start transaction")
 set objRSCT  = objConn.Execute("set autocommit = 0")
 objConn.Execute(strSQL)
 If Err.Number <> 0 Then
	set objRSCT = objConn.Execute("rollback")
    athSaveLog "INS", Request.Cookies("VBOSS")("ID_USUARIO"), "ROLLBACK PROCESSO", strSQL

	Mensagem "modulo_PROCESSO.DeleteExec: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	Response.End()
 else
	set objRSCT = objConn.Execute("commit")
	athSaveLog "INS", Request.Cookies("VBOSS")("ID_USUARIO"), "COMMIT PROCESSO", strSQL
 End If

 
 FechaDBConn(objConn)
 
 response.write "<script>"
 If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'") & ";"
 If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "';"
 response.write "</script>"
%>