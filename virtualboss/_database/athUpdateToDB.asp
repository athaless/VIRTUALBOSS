<!--#include file="athDbConn.asp"-->
<!--#include file="athUtils.asp"--> 
<!--#include file="athSendMail.asp"-->
<%
  '*************************************
  '      VERSÃO 1.9 (MSQL-transaction) *
  '      01/02/2009                    *
  '*************************************

  '********************************* Nome de Campos de Formulários *************************************************************
  '*****************************************************************************************************************************
  ' 1° - Crie um prefixo - ex: DBVAR_
  ' 2° - Escolha o tipo de dados que a tabela recebe para este campo:
  ' STR - Texto e Memo
  ' EMAIL - Texto usado para e-mails
  ' LINK - Texto usado para links web
  ' NUM - Número
  ' AUTODATE - Data/Hora (obs: o valor para este campo deve ser vazio)
  ' BOOL - Sim/Não
  ' DATE - Data
  ' DATETIME - Data e hora
  ' MOEDA - Valores
  ' MOEDA4CD - Valores que requerem 4 casas decimais
  ' 3° - Escreva o nome do campo na tabela
  ' 4° - Se o campo for requerido adicione "ô" ao final de seu nome
  '
  'Obs: Sempre adicione _ após o Prefixo e o Tipo_campo_tabela
  '
  ' Ex:  Prefixo   Tipo_campo_Tabela    Nome_campo_Tabela   Nome_campo_formulário  É Requerido
  '       DBVAR_          STR_               TEXTO             DBVAR_STR_TEXTO         Não
  '       VAR_            NUM_               CODIGO            VAR_NUM_CODIGOô         Sim
  '
  ' Exemplo prático ...
  ' <form name="form_insert" action="_database/athInsertToDB.asp" method="POST">
  '	 <input type="hidden" name="DEFAULT_TABLE" value="RV_REVISTA">
  '	 <input type="hidden" name="DEFAULT_DB" value="[database.mdb]">
  '  <input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
  '	 <input type="hidden" name="RECORD_KEY_NAME" value="COD_REVISTA">
  '	 <input type="hidden" name="DEFAULT_LOCATION" value="../_athcsm/revista/update.asp">
  '	 <input type="hidden" name="DBVAR_AUTODATE_DT_CRIACAO" value="">
  ' ...	
  '
  ' **** LEGENDA ***
  ' Esta página precisa receber os seguintes valores do formulário que a chama:
  ' DEFAULT_TABLE = Tabela a ser feita a deleção
  ' DEFAULT_DB = Variável do banco de dados incluso no arquivo ConfigINC.asp (CFG_DB_SITE ou CFG_DB_CSM)
  ' FIELD_PREFIX = Prefixo do nome do campo do formulário (ex: nome: DBVAR_NUM_COD_CLI prefixo: DBVAR_)
  ' RECORD_KEY_NAME = Nome do campo chave da tabela a ser inserido o registro (usado para redirecionar para o último registro)
  ' DEFAULT_LOCATION = Página e parâmetros para o redirecionamento
  ' JSCRIPT_ACTION = Script a ser rodado antes de redirecionar a página
  ' Obs: DEFAULT_LOCATION irá redirecionar para a página que está em seu value, para continuar na mesma página,
  ' insira o link da própria página em que está
  '*****************************************************************************************************************************
   
  Response.Expires = 0
  Dim strSQL, objRS, ObjConn
  Dim strCODIGO
 'Variáveis para montar a cláusula SQL
  Dim ArrayParam, Param, MyTbFields, MyTbValues, MyFRequired, AuxField, AuxValue, AuxType, AuxStr, FlagOk, StrAviso, MyTbSetFields
  'Variáveis passadas pelo formulário
  Dim DEFAULT_LOCATION, JSCRIPT_ACTION, DEFAULT_TABLE, FIELD_PREFIX, RECORD_KEY_NAME, RECORD_KEY_VALUE, DEFAULT_DB, BOOL_EXIBE_MENSAGEM
  Dim TIPO_TRIGGER
  
  Dim strPARAM
  Dim auxPARAM
  
  
  '=============================================================================
  ' Parte 1: Lê parâmetros
  '=============================================================================
  DEFAULT_TABLE       = GetParam("DEFAULT_TABLE")
  DEFAULT_DB   	      = GetParam("DEFAULT_DB")
  FIELD_PREFIX        = GetParam("FIELD_PREFIX")
  RECORD_KEY_NAME     = GetParam("RECORD_KEY_NAME")
  RECORD_KEY_VALUE    = GetParam("RECORD_KEY_VALUE")
  DEFAULT_LOCATION    = GetParam("DEFAULT_LOCATION")
  JSCRIPT_ACTION      = GetParam("JSCRIPT_ACTION")
  BOOL_EXIBE_MENSAGEM = GetParam("EXIBE_MENSAGEM")

  AuxStr = Request.QueryString
  If AuxStr = "" Then
  	AuxStr = Request.Form
  End If


  '=============================================================================
  ' Parte 2: Monta variáveis
  '=============================================================================
  AuxStr = Mid(AuxStr,InStr(AuxStr,FIELD_PREFIX) + Len(FIELD_PREFIX) + 1)
 'Debug dos "fields" e seus respectivos "values" e "types" recebidos 
  'Response.Write "<BR>DEFAULT_TABLE: " & DEFAULT_TABLE
  'Response.Write "<BR>FIELD_PREFIX: " & FIELD_PREFIX
  'Response.Write "<BR><BR>AUXSTR: " &  Auxstr & "<BR><BR>"

  ArrayParam = Split(AuxStr,"&")

  MyTbFields    = ""
  MyTbValues    = ""
  MyTbSetFields = ""
  For Each Param in ArrayParam 
	Param = Replace(Param,"'","''")
	If InStr(Param,FIELD_PREFIX)>0 then
      Param = Replace(Param,FIELD_PREFIX,"")
      AuxField = Mid(Param,1,InStr(Param,"=")-1)
	  AuxValue = URLDecode(Mid(Param,InStr(Param,"=")+1))
	  AuxType  = Mid(AuxField,1,InStr(Param,"_")-1)
      AuxField = URLDecode(Mid(AuxField,InStr(Param,"_")+1,InStr(Param,"=")-1))

	  If Instr(AuxField,"ô")>0 then 
		AuxField = Replace(AuxField,"ô","")
	    MyFRequired = MyFRequired & "(GetParam(""" & FIELD_PREFIX & AuxType & "_" & AuxField & "ô"")="""")or"
	  End If
	  'Substitui todos os caracteres especiais pelo respectivo código HTML
	  'AuxValue = ReturnCodigo(AuxValue)
	  AuxValue = Replace(AuxValue, "'", "''")
	  
      select case ucase(AuxType)
        case "NUM"       If ((AuxValue = "") or (NOT isNumeric(AuxValue))) then
                           AuxValue = "NULL"
						 Else
						   AuxValue = ("'" & AuxValue & "'")
                         End If
        case "STR"	     If (AuxValue = "") then
                           AuxValue = "NULL"
                 	     Else
                           AuxValue = ("'" & AuxValue & "'")
                         End If
        case "CRIPTO"    If (AuxValue = "") then
                           AuxValue = "NULL"
                 	     Else
                           AuxValue = ("'" & AuxValue & "'")
                         End if
        case "EMAIL"     If (AuxValue = "") then
                           AuxValue = "NULL"
                 	     Else
                           AuxValue = ("'" & AuxValue & "'")
                         End If
        case "LINK"	     If (AuxValue = "") then
                           AuxValue = "NULL"
                 	     Else
                           AuxValue = ("'" & AuxValue & "'")
                         End If
        case "ARQUIVO"   If (AuxValue = "") then
                           AuxValue = "NULL"
                 	     Else
                           AuxValue = ("'" & AuxValue & "'")
                         End If
        case "AUTODATE"  If (AuxValue = "") then
                           AuxValue = ("'" & PrepDataBrToUni(NOW, true) & "'") 
                         End If
        case "DATETIME"  If AuxValue = "" Then
						   AuxValue = "NULL"
						 Else
						   If IsDate(AuxValue) Then
						   		AuxValue = ("'" & PrepDataBrToUni(AuxValue, true) & "'")
						   Else
								AuxValue = "NULL"
						   End If
						 End If
        case "DATE"      If AuxValue = "" Then
						   AuxValue = "NULL"
						 Else
						   If IsDate(AuxValue) Then
						   		AuxValue = ("'" & PrepDataBrToUni(AuxValue, false) & "'")
						   Else
								AuxValue = "NULL"
						   End If
						 End If
        case "BOOL"      If (AuxValue = "") then
                           AuxValue = ("FALSE")
                         End If
		case "MOEDA"     If ((AuxValue = "") or (NOT isNumeric(AuxValue))) then
                           AuxValue = "NULL"
						 Else
						   AuxValue=FormatNumber(AuxValue,2)
						   AuxValue=replace(AuxValue,".","")
						   AuxValue=replace(AuxValue,",",".")
                         End If
		case "MOEDA4CD"  If ((AuxValue = "") or (NOT isNumeric(AuxValue))) then
                           AuxValue = "NULL"
						 Else
						   AuxValue=FormatNumber(AuxValue,4)
						   AuxValue=replace(AuxValue,".","")
						   AuxValue=replace(AuxValue,",",".")
                         End If
      End select

	  'Caso especial porque na continuação tem o parâmetro do Session
	  If InStr(1, AuxType, "AUTOSESSION") > 0 Then
	  		'Response.Write("AuxType: " & AuxType & "<br>")
			'AuxType = Replace(AuxType, "AUTOSESSION", "")
			'AuxType = URLDecode(AuxType)
			'AuxType = replace(AuxType,"+","_") 
			'AuxType = replace(AuxType,"[","") 
			'AuxType = replace(AuxType,"]","") 
			'AuxValue = "'" & Session(AuxType) & "'"
			
			'AUTOSESSION[STR+COD+USER]

			AuxParam = Replace(AuxType, "AUTOSESSION", "")
			AuxParam = URLDecode(AuxParam)
	  		'Response.Write("AuxParam: " & AuxParam & "<br>")
			AuxParam = replace(AuxParam,"+","_") 
			AuxParam = replace(AuxParam,"[","") 
			AuxParam = replace(AuxParam,"]","") 
	  		'Response.Write("AuxParam: " & AuxParam & "<br>")
			
			AuxType = Mid(AuxParam, 1, InStr(1, AuxParam, "_"))
			AuxParam = Replace(AuxParam, AuxType, "")
			AuxType = Replace(AuxType, "_", "")
	  		'Response.Write("AuxType: " & AuxType & "<br>")
			
			AuxValue = Session(AuxParam)
	  		'Response.Write("AuxValue: " & AuxValue & "<br>")
			'Response.End()
	      select case ucase(AuxType)
	        case "NUM"       If ((AuxValue = "") or (NOT isNumeric(AuxValue))) then
    	                       AuxValue = "NULL"
							 Else
							   AuxValue = ("'" & AuxValue & "'")
                	         End If
	        case "STR"	     If (AuxValue = "") then
    	                       AuxValue = "NULL"
        	         	     Else
            	               AuxValue = ("'" & AuxValue & "'")
                	         End If
            case "CRIPTO"    If (AuxValue = "") then
                               AuxValue = "NULL"
                 	         Else
                               AuxValue = ("'" & AuxValue & "'")
                             End if
	        case "EMAIL"     If (AuxValue = "") then
    	                       AuxValue = "NULL"
        	         	     Else
            	               AuxValue = ("'" & AuxValue & "'")
                	         End If
	        case "LINK"	     If (AuxValue = "") then
    	                       AuxValue = "NULL"
        	         	     Else
            	               AuxValue = ("'" & AuxValue & "'")
                	         End If
            case "ARQUIVO"   If (AuxValue = "") then
                               AuxValue = "NULL"
                     	     Else
                               AuxValue = ("'" & AuxValue & "'")
                             End If
	        case "AUTODATE"  If (AuxValue = "") then
    	                       AuxValue = ("'" & PrepDataBrToUni(NOW, true) & "'") 
            	             End If
	        case "DATETIME"  If AuxValue = "" Then
							   AuxValue = "NULL"
							 Else
							   If IsDate(AuxValue) Then
							   		AuxValue = ("'" & PrepDataBrToUni(AuxValue, true) & "'")
							   Else
									AuxValue = "NULL"
							   End If
							 End If
	        case "DATE"      If AuxValue = "" Then
							   AuxValue = "NULL"
							 Else
							   If IsDate(AuxValue) Then
							   		AuxValue = ("'" & PrepDataBrToUni(AuxValue, false) & "'")
							   Else
									AuxValue = "NULL"
							   End If
							 End If
	        case "BOOL"      If (AuxValue = "") then
    	                       AuxValue = ("FALSE")
        	                 End If
			case "MOEDA"     If ((AuxValue = "") or (NOT isNumeric(AuxValue))) then
    	                       AuxValue = "NULL"
							 Else
							   AuxValue=FormatNumber(AuxValue,2)
							   AuxValue=replace(AuxValue,".","")
							   AuxValue=replace(AuxValue,",",".")
	                         End If
			case "MOEDA4CD"  If ((AuxValue = "") or (NOT isNumeric(AuxValue))) then
                    	       AuxValue = "NULL"
							 Else
							   AuxValue=FormatNumber(AuxValue,4)
							   AuxValue=replace(AuxValue,".","")
							   AuxValue=replace(AuxValue,",",".")
	                         End If
	      End Select	
	  End If

      'Debug dos "fields" e seus respectivos "values" e "types" recebidos 
      'Response.Write "TYPE: "  & AuxType & "<br>"
      'Response.Write "FIELD: " & AuxField & "<br>"
      'Response.Write "VALUE: " & AuxValue & "<br>"
  	  MyTbFields = MyTbFields & AuxField & ","
      MyTbValues = MyTbValues & AuxValue & ","
	  MyTbSetFields = MyTbSetFields & "," & (AuxField & "=" & AuxValue)
	End If
  Next

  StrAviso = ""
  MyFRequired = MyFRequired &")"
  MyFRequired = Replace(MyFRequired,"or)","")
  MyFRequired = Replace(MyFRequired,"==","=")
  'Response.Write "DEBUG: Campos requeridos <BR><BR>" & (MyFRequired) & "<br><br>"
  
  FlagOk = (MyFRequired=")") 'Significa que não tem campos requeridos
  If NOT FlagOk then 
    If Eval(MyFRequired) then
 	  Mensagem "Você tem que preencher todos os campos obrigatórios.", "Javascript:history.back()", "Voltar", True
	  FlagOk = False
    Else 
	  FlagOk = True
    End If
  End If
 
  AbreDBConn objConn, DEFAULT_DB


  '=============================================================================
  ' Parte 3: Executa SQL
  '=============================================================================
  If FlagOk then
    strSQL = "UPDATE " & DEFAULT_TABLE & " SET " & MyTbSetFields & " WHERE " &  RECORD_KEY_NAME & "="
	'--------------------------------------------------------------------------
 	'Modificação da Versão 1.0 para versão 1.1
	'--------------------------------------------------------------------------
    If NOT isNumeric(RECORD_KEY_VALUE) Then	
		strSQL = strSQL & "'" & RECORD_KEY_VALUE & "'" 
	Else 
		strSQL = strSQL & RECORD_KEY_VALUE	
	End If 
    '--------------------------------------------------------------------------
	'Fim da Modificação 
	'--------------------------------------------------------------------------
	strSQL = Trim(Replace(strSQL,"SET ,","SET "))

	set objRS  = objConn.Execute("start transaction")
    set objRS  = objConn.Execute("set autocommit = 0")
    objConn.Execute(strSQL)

	If Err.Number<>0 then 
 	  set objRS = objConn.Execute("rollback")
      athSaveLog "UPD", Request.Cookies("VBOSS")("ID_USUARIO"), "ROLLBACK " &  DEFAULT_TABLE, strSQL

	  Mensagem Err.Number & " - " & Err.Description , DEFAULT_LOCATION, 1, True
	  FlagOk = False
    else	  
	  set objRS = objConn.Execute("commit")
      athSaveLog "UPD", Request.Cookies("VBOSS")("ID_USUARIO"), "COMMIT " &  DEFAULT_TABLE, strSQL
	End If
  End If


  '=============================================================================
  ' Parte 4: Define quem foi atualizado
  '=============================================================================
  strCODIGO = RECORD_KEY_VALUE 


  '=============================================================================
  ' Parte 5: Executa processos automáticos após operação
  '=============================================================================
  'If FlagOk Then
  '  TIPO_TRIGGER = "AfterUpd"
  '	  <!-- include virtual="/ACMEsistema/_triggers/include_Processos.asp"-->
  'End If


  '=============================================================================
  ' Parte 6: Dispara o retorno
  '=============================================================================
  If FlagOk Then
      If BOOL_EXIBE_MENSAGEM <> 0 Then
	  	Mensagem "Seu cadastro foi alterado com sucesso", DEFAULT_LOCATION, 1, True
	  Else
	  	'Response.Redirect(DEFAULT_LOCATION)
        response.write "<script>"  & vbCrlf 
	    if (JSCRIPT_ACTION <> "")   then response.write  replace(JSCRIPT_ACTION,"''","'") & vbCrlf end if
	    'if (DEFAULT_LOCATION <> "") then response.write "location.href='" & DEFAULT_LOCATION & "'" & vbCrlf end if
		if (DEFAULT_LOCATION <> "") then
          If InStr(1, DEFAULT_LOCATION, "?") > 0 Then
		    If InStr(1, DEFAULT_LOCATION, "var_chavereg")Then
		  	  response.write "location.href='" & DEFAULT_LOCATION & "'"
		    Else
			  response.write "location.href='" & DEFAULT_LOCATION & "&var_chavereg=" &  strCODIGO & "'" & vbCrlf 
		    End If
	      Else
	  	    response.write "location.href='" & DEFAULT_LOCATION & "?var_chavereg=" &  strCODIGO & "'" & vbCrlf 
 	      End If
        End If
        response.write "</script>"
	  End If
  End If 

  FechaDBConn ObjConn
%>