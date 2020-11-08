<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<!--#include file="../_database/athEnviaAlert.asp"-->
<%
Session.LCID = 1046 

Dim strSQL, objRS, lcObjRS ,objRSAux, ObjConn
Dim strSITUACAO, strDT_INS, strINS_ID_USUARIO, strTITULO, strCODIFICACAO, strCODIGO, strTIPO, strCOD_CONTRATO
Dim strALIQ_ISSQN, strDOC_CONTRATO, strOBS, strDT_INI, strDT_FIM, strDT_ASSINATURA, strVLR_TOTAL, strDT_BASE_CONTRATO
Dim strNUM_PARC, strFREQUENCIA, strDT_BASE_VCTO, strVLR_PARCELA, strTP_REAJUSTE, strFATOR_REAJUSTE, strTP_RENOVACAO
Dim strTP_COBRANCA, strDT_INATIVO, strJSCRIPT_ACTION, strLOCATION, strMSG, strDT_AGORA, strINTERVALO, strDTT_PROX_REAJUSTE, Desloc
Dim i, strQTDEINPUTSPARCELA, strQTDEINPUTSANEXOS, strQTDEINPUTSSERVICO  
Dim arrVlrParcela(), arrDtVencParcela(), arrAnexo(), arrAnexoDesc()
Dim arrCodServico(), arrQtdeServico(), arrVlrServico(), arrDescServico()

strSITUACAO            = GetParam("var_situacao"          )               
strDT_INS              = GetParam("var_sys_dt_insercao"   )    
strINS_ID_USUARIO      = GetParam("var_sys_ins_id_usuario")     
strTITULO              = GetParam("var_titulo"            )                
strCODIFICACAO         = GetParam("var_codificacao"       )            
strCODIGO              = GetParam("var_codigo"            )                 
strTIPO                = GetParam("var_tipo"              )	                 
strALIQ_ISSQN          = GetParam("var_aliq_issqn_servico")   
strDOC_CONTRATO        = GetParam("var_doc_contrato"      )           
strOBS                 = GetParam("var_obs"               )                    
strDT_INI              = GetParam("var_dt_ini"            )                
strDT_FIM              = GetParam("var_dt_fim"            )                
strDT_ASSINATURA       = GetParam("var_dt_assinatura"     )          
strVLR_TOTAL           = GetParam("var_vlr_total"         )            
strNUM_PARC            = GetParam("var_num_parcela_ref"   )               
strFREQUENCIA          = GetParam("var_frequencia"        )             
strDT_BASE_VCTO        = GetParam("var_dt_base_vcto"      )          
strVLR_PARCELA         = GetParam("var_vlr_parcela_ref"   )          
strTP_REAJUSTE         = GetParam("var_tp_reajuste"       )            
strTP_RENOVACAO        = GetParam("var_tp_renovacao"      )           
strTP_COBRANCA         = GetParam("var_tp_cobranca"       )            
strDT_INATIVO          = GetParam("var_dt_inativo"        )    
strQTDEINPUTSPARCELA    = GetParam("QTDE_INPUTS_PARCELA"  )         
strQTDEINPUTSANEXOS    = GetParam("QTDE_INPUTS_ANEXO"     )
strQTDEINPUTSSERVICO   = GetParam("QTDE_INPUTS_SERVICO"   )
strDT_BASE_CONTRATO    = GetParam("var_dt_base_contrato"  )
strJSCRIPT_ACTION      = GetParam("JSCRIPT_ACTION"        )                    
strLOCATION            = GetParam("DEFAULT_LOCATION"      )           
'strFATOR_REAJUSTE     = GetParam("var_fator_reajuste"     )             

'INI: ANEXOS ------------------------------------------------------------------
' Busca anexos colocando-as em respectivos arrays 
' obs. o que determina se vai ser gravado ou não é o campo referente ao arquivo
i = 1
redim arrAnexo(strQTDEINPUTSANEXOS)
redim arrAnexoDesc(strQTDEINPUTSANEXOS)
While (i<=Cint(strQTDEINPUTSANEXOS))  
  arrAnexo(i)     = GetParam("var_anexo_" & i)
  arrAnexoDesc(i) = GetParam("var_anexodesc_" & i)
  
  'athDebug arrAnexo(i) & " " & arrAnexoDesc(i) & "<br>", false
  i = i + 1
WEnd

'athDebug "", true
'DEBUG
'for i=1 to Cint(strQTDEINPUTSANEXOS) 
'  response.write ("posicao "& i &" : "&arrAnexo(i)&" -- "&arrAnexoDesc(i)&"<br>")  
'next
'response.end
'FIM: ANEXOS ------------------------------------------------------------------

'INI: PARCELAS ------------------------------------------------------------------
' Busca imagens/descrições anexas colocando-as em respectivos arrays 
' obs. o que determina se vai ser gravado ou não é o campo referente ao arquivo
i = 1
redim arrVlrParcela(strQTDEINPUTSPARCELA)
redim arrDtVencParcela(strQTDEINPUTSPARCELA)
While (i<=Cint(strQTDEINPUTSPARCELA))  
  arrVlrParcela(i)	  = GetParam("var_vlr_parcela_" & i)
  arrDtVencParcela(i) = GetParam("var_dt_venc_parcela_" & i)
  i = i + 1
WEnd

'DEBUG
'for i=1 to Cint(strQTDEINPUTSPARCELA) 
'  response.write ("posicao "& i &" : "&arrVlrParcela(i)&" -- "&arrDtVencParcela(i)&"<br>")  
' next
'response.end
'FIM: PARCELAS ------------------------------------------------------------------

'INI: SERVICOS ------------------------------------------------------------------
' Busca serviços colocando-os em respectivos arrays 
' obs. o que determina se vai ser gravado ou não é o código do serviço
i = 1

redim arrCodServico (strQTDEINPUTSSERVICO)
redim arrDescServico(strQTDEINPUTSSERVICO)
redim arrQtdeServico(strQTDEINPUTSSERVICO)
redim arrVlrServico (strQTDEINPUTSSERVICO)

While (i<=Cint(strQTDEINPUTSSERVICO))  
	arrCodServico (i) = GetParam("var_servicocod_"  & i)
	arrDescServico(i) = GetParam("var_servicodesc_" & i)
	arrQtdeServico(i) = GetParam("var_servicoqtde_" & i)
	arrVlrServico (i) = GetParam("var_servicovlr_"  & i)
	
	'athDebug arrCodServico (i)& "<br>", false
	'athDebug arrDescServico(i)& "<br>", false	
	'athDebug arrQtdeServico(i)& "<br>", false
	'athDebug arrVlrServico (i)& "<br>", false	
	
  i = i + 1
WEnd

'athDebug "<br>", true	
'DEBUG
'for i=1 to Cint(strQTDEINPUTSPARCELA) 
'  response.write ("posicao "& i &" : "&arrVlrParcela(i)&" -- "&arrDtVencParcela(i)&"<br>")  
' next
'response.end
'FIM: SERVIÇOS ------------------------------------------------------------------

If Not IsDate(strDT_INI          ) Then strDT_INI           = "" 
If Not IsDate(strDT_FIM          ) Then strDT_FIM           = "" 
If not IsDate(strDT_BASE_CONTRATO) Then strDT_BASE_CONTRATO = ""

strMSG = ""
If strTITULO = "" Then strMSG = strMSG & "Informar Título<br>"
If strCODIGO = "" Then strMSG = strMSG & "Informar Entidade<br>"

i = 1
While (i<=Cint(strQTDEINPUTSSERVICO))  
	if not isNumeric(arrCodServico (i)) Then strMSG = strMSG & "Informar código do Serviço "            &"<br>"
	if not isNumeric(arrQtdeServico(i)) Then strMSG = strMSG & "Informar quantidade do Serviço código " & arrCodServico(i) & "<br>"	
	if not isNumeric(arrVlrServico (i)) Then strMSG = strMSG & "Informar valor do Serviço código "      & arrCodServico(i) & "<br>"		  
	i = i + 1
WEnd


If strDT_INI               = ""                          Then strMSG = strMSG & "Informar Dt Início<br>"
If strDT_FIM               = ""                          Then strMSG = strMSG & "Informar Dt Fim<br>"
If strDT_BASE_CONTRATO     = ""                          Then strMSG = strMSG & "Informar Dt Base do Contrato<br>"
If strVLR_TOTAL            = ""                          Then strMSG = strMSG & "Informar Vlr Total(Ref.)<br>"
If strNUM_PARC             <> strQTDEINPUTSPARCELA       Then strMSG = strMSG & "Número de parcelas(Ref.) e parcelas geradas não conferem <br> | " & strNUM_PARC & " * " & strQTDEINPUTSPARCELA
If strVLR_PARCELA = "" or not isNumeric(strVLR_PARCELA)  Then strMSG = strMSG & "Informar o valor da parcela(Ref.)<br>"

i = 1
While (i<=Cint(strQTDEINPUTSPARCELA))  
  if not isDate(arrDtVencParcela(i)) Then strMSG = strMSG & "Informar Dt. Venc. da Parcela " & i &"<br>"
  i = i + 1
WEnd

If strMSG <> "" Then
	Mensagem strMSG, "Javascript:history.back();", "Voltar", 1
	Response.End()
End If

'--------------------------------------
'Define parâmetros da periodicidade
'--------------------------------------
strINTERVALO = ""
If strTP_REAJUSTE = "DIARIA"     Then strINTERVALO = "D"
If strTP_REAJUSTE = "SEMANAL"    Then strINTERVALO = "WW"
If strTP_REAJUSTE = "QUINZENAL"  Then strINTERVALO = "WW" 'WW x 2
If strTP_REAJUSTE = "MENSAL"     Then strINTERVALO = "M"
If strTP_REAJUSTE = "BIMESTRAL"  Then strINTERVALO = "M" 'M x 2
If strTP_REAJUSTE = "TRIMESTRAL" Then strINTERVALO = "Q"
If strTP_REAJUSTE = "SEMESTRAL"  Then strINTERVALO = "Q" 'Q x 2
If strTP_REAJUSTE = "ANUAL"      Then strINTERVALO = "YYYY"

Desloc = 1
If strTP_REAJUSTE = "QUINZENAL" Then Desloc = 2
If strTP_REAJUSTE = "BIMESTRAL" Then Desloc = 2
If strTP_REAJUSTE = "SEMESTRAL" Then Desloc = 2

'If ((IsDate(strDT_BASE_CONTRATO)) and (strINTERVALO <> "")) Then
	'Aless pediu pque a data base para emitir o alerta de reajuste seja a Dt Ini do contrato. By Lumertz 08.01.2013
	'strDTT_PROX_REAJUSTE = "'" & PrepDataBrToUni(DateAdd(strINTERVALO, Desloc, strDT_BASE_CONTRATO), False) & "'"
'Aless pediu pque a data base para emitir o alerta de reajuste seja a Dt Ini do contrato. By Lumertz 08.01.2013		
If ((IsDate(strDT_INI)) and (strINTERVALO <> "")) Then		
	strDTT_PROX_REAJUSTE = "'" & PrepDataBrToUni(DateAdd(strINTERVALO, Desloc, strDT_INI), False) & "'"
Else 
	strDTT_PROX_REAJUSTE = "NULL"	
End If	


'athDebug strDTT_PROX_REAJUSTE & " "&strTP_REAJUSTE & " "&strINTERVALO , true

'INICIO: FORMATAÇÃO CAMPOS PARA SQL ------------------------------------------------------------------
If Not IsDate(strDT_INS       ) Then strDT_INS        = "" 
If Not IsDate(strDT_ASSINATURA) Then strDT_ASSINATURA = "" 
If Not IsDate(strDT_BASE_VCTO ) Then strDT_BASE_VCTO  = "" 

strDT_AGORA = "'" & PrepDataBrToUni(Now, true) & "'"

if strDT_INI           = "" then strDT_INI           = "NULL" else strDT_INI           = "'" & PrepDataBrToUni(strDT_INI          , true) & "'" end if
if strDT_FIM           = "" then strDT_FIM           = "NULL" else strDT_FIM           = "'" & PrepDataBrToUni(strDT_FIM          , true) & "'" end if
if strDT_ASSINATURA    = "" then strDT_ASSINATURA    = "NULL" else strDT_ASSINATURA    = "'" & PrepDataBrToUni(strDT_ASSINATURA   , true) & "'" end if
if strDT_BASE_VCTO     = "" then strDT_BASE_VCTO     = "NULL" else strDT_BASE_VCTO     = "'" & PrepDataBrToUni(strDT_BASE_VCTO    , true) & "'" end if
if strDT_BASE_CONTRATO = "" then strDT_BASE_CONTRATO = "NULL" else strDT_BASE_CONTRATO = "'" & PrepDataBrToUni(strDT_BASE_CONTRATO, true) & "'" end if
if strDT_INATIVO  <> "NULL" then strDT_INATIVO = strDT_AGORA


If (strVLR_TOTAL  = "") Then 
	strVLR_TOTAL = "NULL"
ElseIf (strVLR_TOTAL <> "0") Then	
	strVLR_TOTAL = FormatNumber(strVLR_TOTAL, 2) 
	strVLR_TOTAL = Replace(strVLR_TOTAL,".","")
	strVLR_TOTAL = Replace(strVLR_TOTAL,",",".")					
End If 

If strALIQ_ISSQN  = ""  Then 
	strALIQ_ISSQN = "NULL"
ElseIf (strALIQ_ISSQN <> "0") Then
	strALIQ_ISSQN = FormatNumber(strALIQ_ISSQN, 2) 
	strALIQ_ISSQN = Replace(strALIQ_ISSQN,".","")
	strALIQ_ISSQN = Replace(strALIQ_ISSQN,",",".")						
End If 

If strVLR_PARCELA  = ""  Then 
	strVLR_PARCELA = "NULL"
ElseIf (strVLR_PARCELA <> "0") Then
	strVLR_PARCELA = FormatNumber(strVLR_PARCELA, 2) 
	strVLR_PARCELA = Replace(strVLR_PARCELA,".","")
	strVLR_PARCELA = Replace(strVLR_PARCELA,",",".")								
End If 
'FIM: FORMATAÇÃO CAMPOS PARA SQL ------------------------------------------------------------------

AbreDBConn objConn, CFG_DB

'INI: Insere Contrato ------------------------------------
strSQL =          " INSERT INTO CONTRATO (TITULO            , CODIFICACAO     , SITUACAO   , CODIGO         , TIPO              , "
strSQL = strSQL & "                       OBS               , DT_INI          , DT_FIM     , DT_ASSINATURA  , DTT_PROX_REAJUSTE , "
strSQL = strSQL & "                       DOC_CONTRATO      , NUM_PARC        , VLR_TOTAL  , FREQUENCIA     , DT_BASE_VCTO      , "
strSQL = strSQL & "                       TP_RENOVACAO      , TP_COBRANCA     , DT_INATIVO , SYS_DT_INSERCAO, SYS_INS_ID_USUARIO, "
strSQL = strSQL & "                       ALIQ_ISSQN_SERVICO, DT_BASE_CONTRATO, VLR_PARCELA, TP_REAJUSTE)  "
strSQL = strSQL & "               VALUES ('" &       strTITULO       & "','"  & strCODIFICACAO      & "','" & strSITUACAO    & "'," & strCODIGO        & ",'" & strTIPO              & "', '" 
strSQL = strSQL                              &       strOBS          & "',"   & strDT_INI           & ","   & strDT_FIM      & ","  & strDT_ASSINATURA & ","  & strDTT_PROX_REAJUSTE & " , "
strSQL = strSQL                              & "'" & strDOC_CONTRATO & "',"   & strNUM_PARC         & ","   & strVLR_TOTAL   & ",'" & strFREQUENCIA    & "'," & strDT_BASE_VCTO      & " , "
strSQL = strSQL                              & "'" & strTP_RENOVACAO & "','"  & strTP_COBRANCA      & "',"  & strDT_INATIVO  & ","  & strDT_AGORA      & ",'" & strINS_ID_USUARIO    & "', "
strSQL = strSQL                                    & strALIQ_ISSQN   &  ","   & strDT_BASE_CONTRATO & ","   & strVLR_PARCELA & ",'" & strTP_REAJUSTE   & "'"  & ")" 
'athDebug StrSQL, True

set objRS  = objConn.Execute("start transaction")
set objRS  = objConn.Execute("set autocommit = 0")
objConn.Execute(strSQL) 
If Err.Number <> 0 Then
  set objRS = objConn.Execute("rollback")
  athSaveLog "INS", strINS_ID_USUARIO, "ROLLBACK CONTRATO", strSQL
  Mensagem Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
else
  set objRS = objConn.Execute("commit")
  athSaveLog "INS", strINS_ID_USUARIO, "COMMIT CONTRATO", strSQL
End If
'FIM: Insere Contrato ------------------------------------

strSQL =          " SELECT MAX(COD_CONTRATO) AS CODIGO FROM CONTRATO "
strSQL = strSQL & "  WHERE TITULO LIKE '" & strTITULO & "' "
strSQL = strSQL & "    AND SYS_INS_ID_USUARIO LIKE '" & LCase(strINS_ID_USUARIO) & "' "
strSQL = strSQL & "    AND SYS_DT_INSERCAO = " & strDT_AGORA

Set objRS = objConn.Execute(strSQL)

strCOD_CONTRATO = ""
If Not objRS.Eof Then
	If GetValue(objRS, "CODIGO") <> "" Then strCOD_CONTRATO = GetValue(objRS, "CODIGO")
End If

FechaRecordSet objRS

If strCOD_CONTRATO<>"" Then
    'INI: Insere Anexos ----------------------------------------
	for i=1 to Cint(strQTDEINPUTSANEXOS) 
  	  if (arrAnexo(i)<>"") then	
	    strSQL = " INSERT INTO contrato_anexo(COD_CONTRATO,ARQUIVO,DESCRICAO,SYS_DTT_INS,SYS_ID_USUARIO_INS)  "
		strSQL = strSQL & " VALUES (" & strCOD_CONTRATO & ",'" & arrAnexo(i) & "','" & arrAnexoDesc(i) & "'," & strDT_AGORA & ",'" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "' )"
		set lcObjRS = objConn.Execute("start transaction")
		set lcObjRS = objConn.Execute("set autocommit = 0")
		objConn.Execute(strSQL) 
		If Err.Number <> 0 Then
		  set lcObjRS = objConn.Execute("rollback")
		  athSaveLog "INS", Request.Cookies("VBOSS")("ID_USUARIO"), "ROLLBACK CONTRATO_ANEXO", strSQL
		  Mensagem Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		else
		  set lcObjRS = objConn.Execute("commit")
		  athSaveLog "INS", Request.Cookies("VBOSS")("ID_USUARIO"), "COMMIT CONTRATO_ANEXO", strSQL
		End If
	  end if
	next
	'FIM: Insere Anexos ----------------------------------------

	'INI: Insere parcelas --------------------------------------
	for i=1 to Cint(strQTDEINPUTSPARCELA) 				
		if ((arrVlrParcela(i)<>"") or (arrDtVencParcela(i) <> "")) then	  
			If (arrVlrParcela(i) <> "0") Then
				arrVlrParcela(i) = FormatNumber(arrVlrParcela(i), 2) 
				arrVlrParcela(i) = Replace(arrVlrParcela(i),".","")
				arrVlrParcela(i) = Replace(arrVlrParcela(i),",",".")																		
			End If 	  
			
			if arrDtVencParcela(i) = "" then arrDtVencParcela(i) = "NULL" else arrDtVencParcela(i) = "'" & PrepDataBrToUni(arrDtVencParcela(i), true) & "'" end if
		  
			strSQL = " INSERT INTO CONTRATO_PARCELA (COD_CONTRATO, VLR_PARCELA, DT_VENC) "
			strSQL = strSQL & " VALUES (" & strCOD_CONTRATO & "," & arrVlrParcela(i) & "," & arrDtVencParcela(i) & ")" 			
			'response.write strSQL
			
			set lcObjRS  = objConn.Execute("start transaction")
			set lcObjRS  = objConn.Execute("set autocommit = 0")
			objConn.Execute(strSQL) 
			If Err.Number <> 0 Then
			  set lcObjRS = objConn.Execute("rollback")
			  athSaveLog "INS", strINS_ID_USUARIO, "ROLLBACK CONTR_PARC", strSQL
			  Mensagem Err.Number & " - "& Err.Description , strLOCATION, 1, True		  
			else
			  set lcObjRS = objConn.Execute("commit")
			  athSaveLog "INS", strINS_ID_USUARIO, "COMMIT CONTR_PARC", strSQL
			  			  
			End If
			
	    end if 
	next
	'FIM: Insere parcelas --------------------------------------
	
	'INI: Insere serviços --------------------------------------
	for i=1 to Cint(strQTDEINPUTSSERVICO) 			
		if ((arrCodServico(i)<>"") and (arrQtdeServico(i) <> "") and (arrVlrServico(i) <> "")) then	  
			If (arrVlrServico(i) <> "0") Then
				arrVlrServico(i) = FormatNumber(arrVlrServico(i), 2) 
				arrVlrServico(i) = Replace(arrVlrServico(i),".","")
				arrVlrServico(i) = Replace(arrVlrServico(i),",",".")																		
			End If 	  
	  
			strSQL = " INSERT INTO CONTRATO_SERVICO (COD_CONTRATO, COD_SERVICO, QTDE, VALOR, DESCRICAO)"
			strSQL = strSQL & " VALUES (" & strCOD_CONTRATO & "," & arrCodServico(i) & "," & arrQtdeServico(i) & "," & arrVlrServico(i) & ",'" & arrDescServico(i) & "'" & ")" 			
			'athDebug strSQL & "<br>", false
			
			set lcObjRS  = objConn.Execute("start transaction")
			set lcObjRS  = objConn.Execute("set autocommit = 0")
			objConn.Execute(strSQL) 
			If Err.Number <> 0 Then
			  set lcObjRS = objConn.Execute("rollback")
			  athSaveLog "INS", strINS_ID_USUARIO, "ROLLBACK CONTR_PARC", strSQL
			  Mensagem Err.Number & " - "& Err.Description , strLOCATION, 1, True		  
			else
			  set lcObjRS = objConn.Execute("commit")
			  athSaveLog "INS", strINS_ID_USUARIO, "COMMIT CONTR_PARC", strSQL
			  			  
			End If
			
	    end if 
	next
	'FIM: Insere serviços --------------------------------------	
end if
'athDebug "", true

FechaDBConn objConn

response.write "<script>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'")
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "'"
response.write "</script>"
%>