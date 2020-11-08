<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 Session.LCID = 1046 

 Dim strSQL, objRS, objRSCT, ObjConn, strBodyMsg, strDtAnt, auxTpMsg, auxSTR   
 Dim strCODIGO, strNOME, strAUTORES, strDESCRICAO, strIDPROCESSO, strHOMOLOGACAO, strCOD_CATEGORIA, strDATA, strNOW
 Dim strJSCRIPT_ACTION, strLOCATION
 
 strCODIGO         = GetParam("var_chavereg")
 strNOME           = GetParam("var_nome")
 strAUTORES        = GetParam("var_autores")
 strDESCRICAO      = GetParam("var_descricao")
 strDATA           = GetParam("var_data")
 strIDPROCESSO     = GetParam("var_id_processo")
 strHOMOLOGACAO    = GetParam("var_dt_homologacao")
 strCOD_CATEGORIA  = GetParam("var_cod_categoria")
 strJSCRIPT_ACTION = GetParam("JSCRIPT_ACTION")
 strLOCATION       = GetParam("DEFAULT_LOCATION")

 if not isDate(strDATA)  then strDATA  = "Null" else strDATA  = "'" & PrepDataBrToUni(strDATA,false) & "'"
 if not isDate(strHOMOLOGACAO)  then strHOMOLOGACAO  = "Null" else strHOMOLOGACAO  = "'" & PrepDataBrToUni(strHOMOLOGACAO,true) & "'"
 strNOW  = "'" & PrepDataBrToUni(Now,true) & "'"

 AbreDBConn ObjConn, CFG_DB
 
 strSQL = "UPDATE PROCESSO SET " &_ 
		 "  ID_PROCESSO = '"         & strIDPROCESSO   & "'" & " , NOME = '"   & strNOME  & "', AUTORES = '" & strAUTORES & "'"& _
		 " , DESCRICAO = '"          & strDESCRICAO    & "'" & " , DATA = "    & strDATA   & _
		 " , DT_HOMOLOGACAO = "      & strHOMOLOGACAO  & "       , SYS_DT_ALTERACAO = " & strNOW & _
		 " , SYS_ALT_ID_USUARIO = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "'" & _
		 " , COD_CATEGORIA = "       & strCOD_CATEGORIA & _
		 " WHERE COD_PROCESSO = " 	 & strCODIGO

 'AQUI: NEW TRANSACTION
 set objRSCT = objConn.Execute("start transaction")
 set objRSCT = objConn.Execute("set autocommit = 0")
 ObjConn.Execute(strSQL) 
 if Err.Number<>0 then 
   set objRSCT= objConn.Execute("rollback")
   athSaveLog "UPD", Request.Cookies("VBOSS")("ID_USUARIO"), "ROLBACK PROCESSO", strSQL

   Mensagem "modulo_PROCESSO.update_exec: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
   Response.End()
 else	  
   set objRSCT= objConn.Execute("commit")
   athSaveLog "UPD", Request.Cookies("VBOSS")("ID_USUARIO"), "COMMMIT PROCESSO", strSQL
 End If
 
 FechaDBConn ObjConn
 
 response.write "<script>"
 If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'") & ";"
 If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "';"
 response.write "</script>"
%>