<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
	Dim strSQL, objRS, objRSCT, ObjConn, auxStr, lcObjRS, strLOCATION
	Dim strMSG, strDT_AGORA
	Dim strCOD_CONTRATO, strTITULO, strCODIFICACAO, strCODIGO, strCOD_SERVICO, strDOC_CONTRATO, strSITUACAO, strDT_BASE_CONTRATO
	Dim strOBS, strDT_INI, strDT_FIM, strDT_ASSINATURA, strNUM_PARC, strVLR_PARC, strVLR_TOTAL, strFREQUENCIA, strTIPO
	Dim strDT_BASE_VCTO, strTP_RENOVACAO, strTP_COBRANCA, strALIQ_ISSQN, strTP_REAJUSTE, strQTDEINPUTSPARCELA, strDT_INS, strINS_ID_USUARIO
	Dim i, strINTERVALO, Desloc, strDTT_PROX_REAJUSTE , strQTDEINPUTSANEXOS, strQTDEINPUTSSERVICO
    Dim arrVlrParcela(), arrDtVencParcela(), arrAnexo(), arrAnexoDesc()
    Dim arrCodServico(), arrQtdeServico(), arrVlrServico(), arrDescServico()	
	Dim strCOD_CONTRATO_NEW
	
	strDT_INS           = GetParam("var_sys_dt_insercao"   )   
	strINS_ID_USUARIO   = GetParam("var_sys_ins_id_usuario")  	
	strCOD_CONTRATO     = GetParam("var_cod_contrato"      )
	strTITULO           = GetParam("var_titulo"            )
	strCODIFICACAO      = GetParam("var_codificacao"       )
	strCODIGO           = GetParam("var_codigo"            )
	strTIPO             = GetParam("var_tipo"              )
	strCOD_SERVICO      = GetParam("var_cod_servico"       )
	strALIQ_ISSQN       = GetParam("var_aliq_issqn"        )
	strDOC_CONTRATO     = GetParam("var_doc_contrato"      )
	strOBS              = GetParam("var_obs"               )
	strDT_INI           = GetParam("var_dt_ini"            )
	strDT_FIM           = GetParam("var_dt_fim"            )
	strDT_ASSINATURA    = GetParam("var_dt_assinatura"     )
	strNUM_PARC         = GetParam("var_num_parcela_ref"   )
	strVLR_PARC         = GetParam("var_vlr_parcela_ref"   )
	strVLR_TOTAL        = GetParam("var_vlr_total"         )
	strFREQUENCIA       = GetParam("var_frequencia"        )
	strDT_BASE_VCTO     = GetParam("var_dt_base_vcto"      )
	strTP_REAJUSTE      = GetParam("var_tp_reajuste"       )
	strTP_RENOVACAO     = GetParam("var_tp_renovacao"      )
	strTP_COBRANCA      = GetParam("var_tp_cobranca"       )
	strSITUACAO         = GetParam("var_situacao"          )
	strDT_BASE_CONTRATO = GetParam("var_dt_base_contrato"  )
    strQTDEINPUTSPARCELA= GetParam("QTDE_INPUTS_PARCELA"   )         
    strQTDEINPUTSANEXOS = GetParam("QTDE_INPUTS_ANEXO"     )
    strQTDEINPUTSSERVICO= GetParam("QTDE_INPUTS_SERVICO"   )
	strLOCATION         = GetParam("DEFAULT_LOCATION"      )   
   'strFATOR_REAJUSTE     = GetParam("var_fator_reajuste"   )             	  
   
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
	'FIM: PARCELAS ----------------------------------------------------------------
	
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
	
	If Not IsNumeric(strCOD_CONTRATO) Then strCOD_CONTRATO  = ""
	If Not IsNumeric(strCODIGO)       Then strCODIGO        = ""
	If Not IsNumeric(strCOD_SERVICO)  Then strCOD_SERVICO   = ""
	If Not IsNumeric(strALIQ_ISSQN)   Then strALIQ_ISSQN    = ""
	If Not IsDate(strDT_INI)          Then strDT_INI        = ""
	If Not IsDate(strDT_FIM)          Then strDT_FIM        = ""
	If Not IsDate(strDT_ASSINATURA)   Then strDT_ASSINATURA = ""
	If Not IsDate(strDT_BASE_VCTO)    Then strDT_BASE_VCTO  = ""	
	
	strMSG = ""
	If strCOD_CONTRATO     = ""                       Then strMSG = strMSG & "Parâmetro inválido para contrato<br>"	
	If strTITULO           = ""                       Then strMSG = strMSG & "Informar Título<br>"
	If strCODIGO           = ""                       Then strMSG = strMSG & "Informar Entidade<br>"
	i = 1
	While (i<=Cint(strQTDEINPUTSSERVICO))  
		if not isNumeric(arrCodServico (i)) Then strMSG = strMSG & "Informar código do Serviço "            &"<br>"
		if not isNumeric(arrQtdeServico(i)) Then strMSG = strMSG & "Informar quantidade do Serviço código " & arrCodServico(i) & "<br>"	
		if not isNumeric(arrVlrServico (i)) Then strMSG = strMSG & "Informar valor do Serviço código "      & arrCodServico(i) & "<br>"		  
		i = i + 1
	WEnd
	If strDT_INI           = ""                       Then strMSG = strMSG & "Informar Dt Início<br>"
	If strDT_FIM           = ""                       Then strMSG = strMSG & "Informar Dt Fim<br>"
	If strDT_BASE_CONTRATO = ""                       Then strMSG = strMSG & "Informar Dt Base do Contrato<br>"
	If strVLR_TOTAL        = ""                       Then strMSG = strMSG & "Informar Vlr Total(Ref.)<br>"
	If strNUM_PARC <> strQTDEINPUTSPARCELA            Then strMSG = strMSG & "Número de parcelas(Ref.) e parcelas geradas não conferem';<br>"
	If strVLR_PARC = "" or not isNumeric(strVLR_PARC) Then strMSG = strMSG & "Informar o valor da parcela(Ref.)<br>"	
	
	i = 1
	While (i<=Cint(strQTDEINPUTSPARCELA))  
	  if not isDate(arrDtVencParcela(i)) Then strMSG = strMSG & "Informar Dt. Venc. da Parcela " & i &"<br>"
	  i = i + 1
	WEnd	
	
	If strNUM_PARC     = "" Or Not IsNumeric(strNUM_PARC) Then strNUM_PARC = 0
	If strVLR_TOTAL    = "" Or Not IsNumeric(strVLR_TOTAL) Then strVLR_TOTAL = 0	
	If strTP_RENOVACAO = "" Then strTP_RENOVACAO = "RENOVAVEL"

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
	If strTP_REAJUSTE = "QUINZENAL"  Then Desloc = 2
	If strTP_REAJUSTE = "BIMESTRAL"  Then Desloc = 2
	If strTP_REAJUSTE = "SEMESTRAL"  Then Desloc = 2
	
	'If ((IsDate(strDT_BASE_CONTRATO)) and (strINTERVALO <> "")) Then
		'strDTT_PROX_REAJUSTE = "'" & PrepDataBrToUni(DateAdd(strINTERVALO, Desloc, strDT_BASE_CONTRATO), False) & "'"
	'Aless pediu para que a data base a emitir o alerta de reajuste seja a Dt Ini do contrato. By Lumertz 08.01.2013		
	If ((IsDate(strDT_INI)) and (strINTERVALO <> "")) Then		
		strDTT_PROX_REAJUSTE = "'" & PrepDataBrToUni(DateAdd(strINTERVALO, Desloc, strDT_INI), False) & "'"
	Else 
		strDTT_PROX_REAJUSTE = "NULL"	
	End If	
	
	'INCIO: FORMATAÇÃO CAMPOS PARA SQL ------------------------------------------------------------------
	
	If Not IsDate(strDT_INS           ) Then strDT_INS            = "" 
	If Not IsDate(strDT_ASSINATURA    ) Then strDT_ASSINATURA     = "" 
	If Not IsDate(strDT_BASE_VCTO     ) Then strDT_BASE_VCTO      = "" 
	
	if strDT_INI           = "" then strDT_INI           = "NULL" else strDT_INI           = "'" & PrepDataBrToUni(strDT_INI          , true) & "'" end if
	if strDT_FIM           = "" then strDT_FIM           = "NULL" else strDT_FIM           = "'" & PrepDataBrToUni(strDT_FIM          , true) & "'" end if
	if strDT_ASSINATURA    = "" then strDT_ASSINATURA    = "NULL" else strDT_ASSINATURA    = "'" & PrepDataBrToUni(strDT_ASSINATURA   , true) & "'" end if
	if strDT_INS           = "" then strDT_INS           = "NULL" else strDT_INS           = "'" & PrepDataBrToUni(strDT_INS          , true) & "'" end if	
	if strDT_BASE_VCTO     = "" then strDT_BASE_VCTO     = "NULL" else strDT_BASE_VCTO     = "'" & PrepDataBrToUni(strDT_BASE_VCTO    , true) & "'" end if
	if strDT_BASE_CONTRATO = "" then strDT_BASE_CONTRATO = "NULL" else strDT_BASE_CONTRATO = "'" & PrepDataBrToUni(strDT_BASE_CONTRATO, true) & "'" end if
	strDT_AGORA = "'" & PrepDataBrToUni(Now, true) & "'"
	
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
	
	If strVLR_PARC  = ""  Then 
		strVLR_PARc = "NULL"
	ElseIf (strVLR_PARC <> "0") Then
		strVLR_PARC = FormatNumber(strVLR_PARC, 2) 
		strVLR_PARC = Replace(strVLR_PARC,".","")
		strVLR_PARC = Replace(strVLR_PARC,",",".")								
	End If 	
	'FIM: FORMATAÇÃO CAMPOS PARA SQL ------------------------------------------------------------------
	
	
	AbreDBConn objConn, CFG_DB 

	'-----------------------------
	'Insere dados do contrato - INI
	'-----------------------------
	strSQL =          " INSERT INTO CONTRATO ( COD_CONTRATO_PAI  , TITULO         , CODIFICACAO,       "
	strSQL = strSQL & "                        TIPO              , CODIGO         , DT_BASE_CONTRATO,  "
	strSQL = strSQL & "                        ALIQ_ISSQN_SERVICO, DOC_CONTRATO   , OBS,               "
	strSQL = strSQL & "                        DT_INI            , DT_FIM         , DT_ASSINATURA,     "
	strSQL = strSQL & "                        NUM_PARC          , VLR_TOTAL      , FREQUENCIA   ,     "
	strSQL = strSQL & "                        DT_BASE_VCTO      , SITUACAO       , TP_RENOVACAO ,     "
	strSQL = strSQL & "                        TP_COBRANCA       , SYS_DT_INSERCAO, SYS_INS_ID_USUARIO,"
    strSQL = strSQL & "                        VLR_PARCELA       , TP_REAJUSTE    , DTT_PROX_REAJUSTE )"	
	strSQL = strSQL & "              VALUES  ( " & strCOD_CONTRATO     & ",'" & strTITULO       & "','" & strCODIFICACAO       & "',"
	strSQL = strSQL &                         "'"& strTIPO             &"',"  & strCODIGO       & ","   & strDT_BASE_CONTRATO  & "," 
	strSQL = strSQL &                              strALIQ_ISSQN       & ",'" & strDOC_CONTRATO & "','" & strOBS               & "',"
	strSQL = strSQL &                              strDT_INI           & ","  & strDT_FIM       & ","   & strDT_ASSINATURA     & "," 
	strSQL = strSQL &                              strNUM_PARC         & ","  & strVLR_TOTAL    & ",'"  & strFREQUENCIA        & "'," 
	strSQL = strSQL &                              strDT_BASE_VCTO     & ",'" & strSITUACAO     & "','" & strTP_RENOVACAO      & "','" 
    strSQL = strSQL	&                              strTP_COBRANCA      & "'," & strDT_INS       & ",'"  & strINS_ID_USUARIO    & "',"	
    strSQL = strSQL	&                              strVLR_PARC         & ",'" & strTP_REAJUSTE  & "',"  & strDTT_PROX_REAJUSTE & ")"
	
    'athDebug strSQL, true
	
	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
    	athSaveLog "INS", strINS_ID_USUARIO, "ROLLBACK CONTRATO", strSQL
		Mensagem "modulo_CONTRATO.renova_exec A: " & Err.Number & " - "& Err.Description , strLOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
		athSaveLog "INS", strINS_ID_USUARIO, "COMMIT CONTRATO", strSQL
	End If

	'-----------------------------
	'Insere dados do contrato - FIM
	'-----------------------------	
	
	strSQL =          " SELECT MAX(COD_CONTRATO) AS CODIGO FROM CONTRATO "
	strSQL = strSQL & "  WHERE TITULO LIKE '" & strTITULO & "' "
	strSQL = strSQL & "    AND SYS_INS_ID_USUARIO LIKE '" & strINS_ID_USUARIO & "' "
	strSQL = strSQL & "    AND SYS_DT_INSERCAO = " & strDT_INS

	Set objRS = objConn.Execute(strSQL)

	strCOD_CONTRATO_NEW = ""
	If Not objRS.Eof Then
		If GetValue(objRS, "CODIGO") <> "" Then strCOD_CONTRATO_NEW = GetValue(objRS, "CODIGO")
	End If
	
	'athDebug strCOD_CONTRATO_NEW, true
	
	FechaRecordSet objRS
	
	If strCOD_CONTRATO<>"" Then
		'INI: Insere Anexos ----------------------------------------
		for i=1 to Cint(strQTDEINPUTSANEXOS) 
		  if (arrAnexo(i)<>"") then	
			strSQL = " INSERT INTO contrato_anexo(COD_CONTRATO,ARQUIVO,DESCRICAO,SYS_DTT_INS,SYS_ID_USUARIO_INS)  "
			strSQL = strSQL & " VALUES (" & strCOD_CONTRATO_NEW & ",'" & arrAnexo(i) & "','" & arrAnexoDesc(i) & "'," & strDT_AGORA & ",'" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "' )"
			set lcObjRS = objConn.Execute("start transaction")
			set lcObjRS = objConn.Execute("set autocommit = 0")
			objConn.Execute(strSQL) 
			If Err.Number <> 0 Then
			  set lcObjRS = objConn.Execute("rollback")
			  athSaveLog "INS", Request.Cookies("VBOSS")("ID_USUARIO"), "ROLLBACK CONTRATO_ANEXO", strSQL
			  Mensagem Err.Number & " - "& Err.Description , strLOCATION, 1, True
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
    		  '	athDebug strSQL & "<br>",false
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
	end if

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
	
    'athDebug "", true
	

	'-----------------------------
	'Inativa o contrato anterior
	'-----------------------------
	strSQL = " UPDATE CONTRATO SET DT_INATIVO = " & strDT_AGORA & " WHERE COD_CONTRATO = " & strCOD_CONTRATO
	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_CONTRATO.renoca_exec B: " & Err.Number & " - "& Err.Description , strLOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
	End If
	
	FechaDBConn ObjConn
%>
<script>
	parent.frames["vbTopFrame"].document.form_principal.submit();
</script>