<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|IMPORT|", BuscaDireitosFromDB("modulo_MB_REVISTA", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Dim objConn, objRS, strSQL
 Dim objFSO, objARQ, strARQ, strPath, strValue
 Dim strAUX, strLINE, arrAUX, arrLINE
 Dim i, intCodCATEG

 'Campos dos arquivo BUFFER_LIVROS.MDB
 const COD		 = 0
 const NOME		 = 1
 const CAPA		 = 2
 const EDITORA	 = 3
 const EDICAO	 = 4
 const MES		 = 5
 const ANO		 = 6
 const CODBAR	 = 7
 const ISSN		 = 8
 const LOCAL	 = 9
 const PRAZO	 = 10
 const LOCADO	 = 11
 const IDIOMA	 = 12
 const AQUISICAO = 13
 const CATEGORIA = 14
 const ASSUNTO	 = 15
 const CLASSE	 = 16
 const VOLUME 	 = 17
 const EXTRA	 = 18
 const RESENHA	 = 19

 'Parâmetro com o nome e path do arquivo para importar	
 strARQ = GetParam("DBVAR_STR_ARQUIVO")

 'Para montagem do PATH+File local pra teste
 set objFSO  = Server.CreateObject("Scripting.FileSystemObject")
 strPath = Server.MapPath("..\upload\" & Request.Cookies("VBOSS")("CLINAME"))
 strARQ  = strPath & "\" & strARQ
 set objARQ  = objFSO.OpenTextFile(strARQ, 1)

 'Verifica se o arquivo é do formato esperado (como não temos outra indicação, testamos o cabeçalho inteiro do mesmo).
 strLine = objARQ.ReadLine 'ignora/pula a primeira linha
 'strLine = ATHMiniBiblioDeCripto(strLine)
 'athdebug strLine, true
 If ucase(strLine)<>"XLW|MLNV|XZKZ|VWRGLIZ|VWRXZL|NVH|ZML|XLWYZI|RHHM|OLXZO|KIZAL VNKI|OLXZWL|RWRLNZ|ZJFRHRXZL|XZGVTLIRZ|ZHHFMGL|XOZHHV|ELOFNV|VCGIZ|IVHVMSZ" then
   Mensagem "Formato de arquivo não reconhecido. Poderão ser importados somente arquivos de REVISTAS do MiniBiblio (buffer_revistas.dbb)", "", 1, True
   response.end
 End If  

 'Busca a categoria (por estring mesmo), se não existe insere e pega o codigo inserido (melhorar)
 function GetCodCateg(prStrCateg)
	  strSQL = "SELECT COD_CATEGORIA FROM mb_revista_categoria WHERE NOME like '" & prStrCateg & "'"
	  set objRS = objConn.Execute(strSQL)  
	  If Not objRS.EOF Then
		  GetCodCateg = GetValue(objRS,"COD_CATEGORIA")
	  Else  
		  strSQL = "INSERT INTO mb_revista_categoria (NOME) VALUES ('" & prStrCateg & "')"
		  set objRS = objConn.Execute(strSQL)  
	
		  strSQL = "SELECT COD_CATEGORIA FROM mb_revista_categoria WHERE NOME like '" & prStrCateg & "'"
		  set objRS = objConn.Execute(strSQL)  
		  If Not objRS.EOF Then
			GetCodCateg = GetValue(objRS,"COD_CATEGORIA")
		  End If
	  End If
 end function


 ' ------------------------------------------------------------------------------------------------------
 ' INI: Importação --------------------------------------------------------------------------------------
 ' ------------------------------------------------------------------------------------------------------
 AbreDBConn objConn, CFG_DB

 set objRS  = objConn.Execute("start transaction")
 set objRS  = objConn.Execute("set autocommit = 0")
 do while objARQ.AtEndOfStream = false
    strLine		= objARQ.ReadLine
	strLine		= ATHMiniBiblioDeCripto(strLine)
	strLine		= replace (strLine,"'","''")
	strLine		= replace (strLine,"""","''")
    arrLine		= split (strLine, "|")
	intCodCATEG = GetCodCateg(arrLine(CATEGORIA))

	'Debug ARRAY...
	'for i=0 to ubound(arrLine)
	' athDebug  "[" & i &  "-" &arrLine(i) & "]", false
	'next
	'athDebug  "<br><br>", false

    strSQL = "INSERT INTO mb_revista "
    strSQL = strSQL & "("
    strSQL = strSQL & "ID,"
    strSQL = strSQL & "NOME,"
    strSQL = strSQL & "CAPA,"
    strSQL = strSQL & "EDITORA,"
    strSQL = strSQL & "EDICAO,"
    strSQL = strSQL & "MES,"
    strSQL = strSQL & "ANO,"
    strSQL = strSQL & "CODBAR,"
    strSQL = strSQL & "ISSN,"
    strSQL = strSQL & "LOCALIZACAO,"
    strSQL = strSQL & "PRAZO_EMPR,"
    strSQL = strSQL & "IDIOMA,"
    strSQL = strSQL & "AQUISICAO," 
    strSQL = strSQL & "COD_CATEGORIA,"
    strSQL = strSQL & "ASSUNTO,"
    strSQL = strSQL & "CLASSE,"
    strSQL = strSQL & "VOLUME,"
    strSQL = strSQL & "EXTRA,"
    'strSQL = strSQL & "IMG_THUMB," 
    'strSQL = strSQL & "IMG," 
    strSQL = strSQL & "RESENHA," 
    strSQL = strSQL & "SYS_ID_USUARIO_INS,"
    strSQL = strSQL & "SYS_DTT_INS" 
	strSQL = strSQL & ") VALUES ("
    strSQL = strSQL & "'" & RetValue4SQl(mid(arrLine(COD)	,1,10),"")		& "',"	
    strSQL = strSQL & "'" & RetValue4SQl(mid(arrLine(NOME) ,1,250),"")		& "',"
    strSQL = strSQL & "'" & RetValue4SQl(mid(arrLine(CAPA) ,1,250),"")		& "',"
    strSQL = strSQL & "'" & RetValue4SQl(mid(arrLine(EDITORA),1,250),"")	& "',"
    strSQL = strSQL & "'" & RetValue4SQl(mid(arrLine(EDICAO) ,1,10),"")		& "',"	
    strSQL = strSQL & 		RetValue4SQl(mid(arrLine(MES),10),"NULL")		& ","	
    strSQL = strSQL & 		RetValue4SQl(mid(arrLine(ANO),10),"NULL")		& ","	
    strSQL = strSQL & "'" & RetValue4SQl(mid(arrLine(CODBAR) ,1,25),"")		& "',"	
    strSQL = strSQL & "'" & RetValue4SQl(mid(arrLine(ISSN)	,1,25),"")		& "',"	
    strSQL = strSQL & "'" & RetValue4SQl(mid(arrLine(LOCAL)	,1,20),"")		& "',"
    strSQL = strSQL & 		RetValue4SQl(arrLine(PRAZO),"NULL")				& ","
    strSQL = strSQL & "'" & RetValue4SQl(mid(arrLine(IDIOMA) ,1,20),"")		& "',"
    strSQL = strSQL & "'" & PrepDataBrToUni(arrLine(AQUISICAO),false) 		& "'," 
    strSQL = strSQL & 		RetValue4SQl(intCodCATEG,"NULL")	    		& ","
    strSQL = strSQL & "'" & RetValue4SQl(mid(arrLine(ASSUNTO),1,250),"")	& "',"
    strSQL = strSQL & "'" & RetValue4SQl(mid(arrLine(CLASSE) ,1,250),"")	& "',"
    strSQL = strSQL & "'" & RetValue4SQl(mid(arrLine(VOLUME) ,1,10),"")		& "',"
    strSQL = strSQL & "'" & RetValue4SQl(mid(arrLine(EXTRA)  ,1,50),"")		& "',"
    strSQL = strSQL & "'" & RetValue4SQl(arrLine(RESENHA),"") 				& "',"
    strSQL = strSQL & "'" & Request.Cookies("VBOSS")("ID_USUARIO") & "',"
    strSQL = strSQL & "'" & PrepDataBrToUni(Now(), true) & "'"
    strSQL = strSQL	& ")" 

    'Debug SQL
	'athDebug strSQL & "<br><br>" , false

    objConn.Execute(strSQL)  
    If Err.Number <> 0 Then
 	  set objRS = objConn.Execute("rollback")
	  Mensagem "Não foi possível realizar a importação. "  & Err.Number & " - "& Err.Description , "", 1, True
	  Response.End
	else
	  'response.write("[ok]<br>")
	  'for i=0 to ubound(arrLine)
	  '	 response.write("[" & arrLine(i) & "]")
	  'next
	  'response.write("<br><br>")
	  set objRS = objConn.Execute("commit")
	  response.write("<script type='text/javascript' language='javascript'>")
	  response.write("  alert(""Arquivo " & GetParam("DBVAR_STR_ARQUIVO") & " importado com sucesso!"");")
	  response.write("  parent.frames['vbTopFrame'].document.form_principal.submit();")
	  response.write("</script>")
	End If
 loop
 ' ------------------------------------------------------------------------------------------------------
 ' FIM: Importação --------------------------------------------------------------------------------------
 ' ------------------------------------------------------------------------------------------------------

 Set objFSO = NOTHING
 FechaDBConn objConn
%>