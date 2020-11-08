<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<!--#include file="../_database/athEnviaAlert.asp"-->
<%
Session.LCID = 1046 

Dim strSQL, objRS, ObjConn
Dim strSITUACAO, strDT_INS, strINS_ID_USUARIO, strTITULO_NEW, strCOD_CONTRATO_COPY, strCOD_CONTRATO
Dim strJSCRIPT_ACTION, strLOCATION 

'INI: Dados da tela de cópia ------------------------------------------------------------------
strCOD_CONTRATO_COPY   = GetParam("var_cod_contrato")               
strTITULO_NEW          = GetParam("var_novo_tit"    )               
strDT_INS              = "'" & PrepDataBrToUni(Now, true) & "'"
strINS_ID_USUARIO      = Request.Cookies("VBOSS")("ID_USUARIO")
strJSCRIPT_ACTION      = GetParam("JSCRIPT_ACTION")
strLOCATION            = GetParam("DEFAULT_LOCATION")

'Novo contrato terá a situação aberto
strSITUACAO = "ABERTO"

'athDebug "COD_CONTRATO_COPY "& strCOD_CONTRATO_COPY & "<BR>", FALSE
'athDebug "TITULO_NEW "& strTITULO_NEW & "<BR>", FALSE
'athDebug "DT_INS "& strDT_INS & "<BR>", FALSE
'athDebug "INS_ID_USUARIO "& strINS_ID_USUARIO & "<BR>", FALSE
'athDebug " ", TRUE
'FIM: Dados da tela de cópia ------------------------------------------------------------------

'INI: Copia contrato ------------------------------------------------------------------
AbreDBConn objConn, CFG_DB
strSQL =          " INSERT INTO CONTRATO (TITULO                     "
strSQL = strSQL & "                     , CODIFICACAO                "
strSQL = strSQL & "                     , COD_CONTRATO_PAI           "
strSQL = strSQL & "                     , SITUACAO                   "
strSQL = strSQL & "                     , CODIGO                     "
strSQL = strSQL & "                     , TIPO                       "
strSQL = strSQL & "                     , OBS                        "
strSQL = strSQL & "                     , DT_INI                     "
strSQL = strSQL & "                     , DT_FIM                     "
strSQL = strSQL & "                     , DT_ASSINATURA              " 
strSQL = strSQL & "                     , DOC_CONTRATO               "
strSQL = strSQL & "                     , NUM_PARC                   "
strSQL = strSQL & "                     , VLR_TOTAL                  "
strSQL = strSQL & "                     , FREQUENCIA                 "
strSQL = strSQL & "                     , DT_BASE_VCTO               "
strSQL = strSQL & "                     , TP_RENOVACAO               "
strSQL = strSQL & "                     , TP_COBRANCA                "
strSQL = strSQL & "                     , SYS_DT_INSERCAO            "
strSQL = strSQL & "                     , SYS_INS_ID_USUARIO         "
strSQL = strSQL & "                     , ALIQ_ISSQN_SERVICO         "
strSQL = strSQL & "                     , DT_BASE_CONTRATO           "
strSQL = strSQL & "                     , VLR_PARCELA                "
strSQL = strSQL & "                     , TP_REAJUSTE)               "
strSQL = strSQL & "              SELECT  '" & strTITULO_NEW  & "'    " 
strSQL = strSQL & "                     , CODIFICACAO                "
strSQL = strSQL & "                     , COD_CONTRATO_PAI           "
strSQL = strSQL & "                     ,'" & strSITUACAO    & "'    "
strSQL = strSQL & "                     , CODIGO                     " 
strSQL = strSQL & "                     , TIPO                       "
strSQL = strSQL & "                     , OBS                        "
strSQL = strSQL & "                     , DT_INI                     "
strSQL = strSQL & "                     , DT_FIM                     "
strSQL = strSQL & "                     , DT_ASSINATURA              "
strSQL = strSQL & "                     , DOC_CONTRATO               "
strSQL = strSQL & "                     , NUM_PARC                   "
strSQL = strSQL & "                     , VLR_TOTAL                  "
strSQL = strSQL & "                     , FREQUENCIA                 "
strSQL = strSQL & "                     , DT_BASE_VCTO               "
strSQL = strSQL & "                     , TP_RENOVACAO               "
strSQL = strSQL & "                     , TP_COBRANCA                "
strSQL = strSQL & "                     ," & strDT_INS      
strSQL = strSQL & "                     ,'" & strINS_ID_USUARIO & "' " 
strSQL = strSQL & "                     , ALIQ_ISSQN_SERVICO         " 
strSQL = strSQL & "                     , DT_BASE_CONTRATO           "
strSQL = strSQL & "                     , VLR_PARCELA                "
strSQL = strSQL & "                     , TP_REAJUSTE                "
strSQL = strSQL & "           FROM CONTRATO WHERE COD_CONTRATO = " & strCOD_CONTRATO_COPY

'athDebug strSQL, true

set objRS  = objConn.Execute("start transaction")
set objRS  = objConn.Execute("set autocommit = 0")
objConn.Execute(strSQL) 
If Err.Number <> 0 Then
  set objRS = objConn.Execute("rollback")
  athSaveLog "INS", strINS_ID_USUARIO, "ROLLBACK COPIA_CONTRATO", strSQL
  Mensagem Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
else
  set objRS = objConn.Execute("commit")
  athSaveLog "INS", strINS_ID_USUARIO, "COMMIT COPIA_CONTRATO", strSQL
End If

'Busca Codigo do contrato que acabou de ser inserido
strSQL =          " SELECT MAX(COD_CONTRATO) AS CODIGO FROM CONTRATO "
strSQL = strSQL & "  WHERE TITULO LIKE '" & strTITULO_NEW & "' "
strSQL = strSQL & "    AND SYS_INS_ID_USUARIO LIKE '" & LCase(strINS_ID_USUARIO) & "' "
strSQL = strSQL & "    AND SYS_DT_INSERCAO = " & strDT_INS
Set objRS = objConn.Execute(strSQL)
strCOD_CONTRATO = ""
If Not objRS.Eof Then
	If GetValue(objRS, "CODIGO") <> "" Then strCOD_CONTRATO = GetValue(objRS, "CODIGO")
End If
'FIM: Copia contrato ------------------------------------------------------------------

'INI: Copia serviços ------------------------------------------------------------------

strSQL =          "INSERT INTO CONTRATO_SERVICO (COD_CONTRATO "
strSQL = strSQL & "                            , COD_SERVICO "
strSQL = strSQL & "                            , QTDE "
strSQL = strSQL & "                            , VALOR "
strSQL = strSQL & "                            , DESCRICAO) "
strSQL = strSQL & "                     SELECT " & strCOD_CONTRATO 
strSQL = strSQL & "                            , COD_SERVICO "
strSQL = strSQL & "                            , QTDE "
strSQL = strSQL & "                            , VALOR "
strSQL = strSQL & "                            , DESCRICAO "
strSQL = strSQL & "                    FROM CONTRATO_SERVICO WHERE COD_CONTRATO = " & strCOD_CONTRATO_COPY
'athDebug strSQL & "<br>", false

set ObjRS  = objConn.Execute("start transaction")
set ObjRS  = objConn.Execute("set autocommit = 0")
objConn.Execute(strSQL) 
If Err.Number <> 0 Then
  set ObjRS = objConn.Execute("rollback")
  athSaveLog "INS", strINS_ID_USUARIO, "ROLLBACK COPIA_CONTR_SRV", strSQL
  Mensagem Err.Number & " - "& Err.Description , strLOCATION, 1, True		  
Else
  set ObjRS = objConn.Execute("commit")
  athSaveLog "INS", strINS_ID_USUARIO, "COMMIT COPIA_CONTR_SRV", strSQL
End If 
			  
'FIM: Copia serviços ------------------------------------------------------------------			  
			  			  

'INI: Copia parcelas ------------------------------------------------------------------

strSQL =          "  INSERT INTO CONTRATO_PARCELA (COD_CONTRATO      "
strSQL = strSQL & "                              , VLR_PARCELA       "
strSQL = strSQL & "                              , DT_VENC)          "
strSQL = strSQL & "                       SELECT " & strCOD_CONTRATO 
strSQL = strSQL & "                              ,VLR_PARCELA        "
strSQL = strSQL & "                              ,DT_VENC            " 	
strSQL = strSQL & "                        FROM CONTRATO_PARCELA WHERE COD_CONTRATO = "	& strCOD_CONTRATO_COPY	

'athDebug strSQL, true

set ObjRS  = objConn.Execute("start transaction")
set ObjRS  = objConn.Execute("set autocommit = 0")
objConn.Execute(strSQL) 
If Err.Number <> 0 Then
  set ObjRS = objConn.Execute("rollback")
  athSaveLog "INS", strINS_ID_USUARIO, "ROLLBACK COPIA_CONTR_PARC", strSQL
  Mensagem Err.Number & " - "& Err.Description , strLOCATION, 1, True		  
else
  set ObjRS = objConn.Execute("commit")
  athSaveLog "INS", strINS_ID_USUARIO, "COMMIT COPIA_CONTR_PARC", strSQL
End If			  			  
'FIM: Copia parcelas ------------------------------------------------------------------

'INI: Copia anexos ------------------------------------------------------------------
strSQL =          " INSERT INTO CONTRATO_ANEXO(COD_CONTRATO                "
strSQL = strSQL & "                           ,ARQUIVO                     "
strSQL = strSQL & "                           ,DESCRICAO                   "
strSQL = strSQL & "                           ,SYS_DTT_INS                 "
strSQL = strSQL & "                           ,SYS_ID_USUARIO_INS)         "
strSQL = strSQL & "                    SELECT " & strCOD_CONTRATO 
strSQL = strSQL & "                           ,ARQUIVO                     "
strSQL = strSQL & "                           ,DESCRICAO                   "
strSQL = strSQL & "                           ," & strDT_INS 
strSQL = strSQL & "                           ,'" & strINS_ID_USUARIO & "' "
strSQL = strSQL & "            FROM CONTRATO_ANEXO WHERE COD_CONTRATO = " & strCOD_CONTRATO_COPY	

'athDebug strSQL, true

set ObjRS = objConn.Execute("start transaction")
set ObjRS = objConn.Execute("set autocommit = 0")
objConn.Execute(strSQL) 
If Err.Number <> 0 Then
  set ObjRS = objConn.Execute("rollback")
  athSaveLog "INS", Request.Cookies("VBOSS")("ID_USUARIO"), "ROLLBACK COPIA_CONTRATO_ANEXO", strSQL
  Mensagem Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
else
  set ObjRS = objConn.Execute("commit")
  athSaveLog "INS", Request.Cookies("VBOSS")("ID_USUARIO"), "COMMIT COPIA_CONTRATO_ANEXO", strSQL
End If
'FIM: Copia anexos ------------------------------------------------------------------		

FechaDBConn objConn

response.write "<script>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'")
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "'"
response.write "</script>"
%>