<!--#include file="../_database/athdbConn.asp"--> <%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_IMPORTACAO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 ' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
 ' e o tamanho da coluna dos títulos dos inputs
 Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "dlg_info.gif:ATENÇÃO! Aqui texto para explicação da importacao de planilhas."' -------------------------------------------------------------------------------
  
  Dim objConn, objRS, strSQL
  Dim objFSO, strPath, objFolder, objItem, CAMPOS, VALORES, strLINHAS
  Dim bolAlreadyExists, strHyperLink, strMensagem 
  Dim strARQUIVO, strERRO
' Const adOpenStatic = 3
' Const adLockPessimistic = 2
  Dim cnnExcel
  Dim rstExcel, strCAMPOS, strACAO, strCAMPOS2, strCAMPOFIM, strCOLUNAS, arrCOLUNAS, n, arrCAMPOS, k, strCAMPOS3, strTIPOS, arrEXCEL, arrTABELA, arrTIPOS, strVALOR , strUPPER, arrUPPER, strSucesso
 
  Dim I, contador
  Dim iCols
  Dim conterro, contsucesso
  Dim strTABELA
  Dim strEXCLUIR, intExibeCampos
  Dim strMontaTabela
  
  strMontaTabela = "S"
  
	strARQUIVO = GetParam("var_arquivo")
	strTABELA = GetParam("var_tabela")
	strCAMPOS = GetParam("var_campos")
	strEXCLUIR = GetParam("var_exluir_dados")
  
  AbreDBConn objConn, CFG_DB
 
 		If strEXCLUIR = "S" Then
			strSQL = "DELETE FROM " & strTABELA
			objConn.Execute(strSQL)
		End If
 
'Função para ano/mes/dia hora:minuto:segundo
Public Function PrepDataIve(DateToConvert, FormatoDiaMes, DataHora)

   ' Declaração para variáveis para dois métodos
   Dim strDia
   Dim strMes
   Dim strAno
   Dim strHora
   Dim strMinuto
   Dim strSegundo

   If isDate(DateToConvert) Then
     strDia     = Day(DateToConvert)
     If strDia < 10 Then
       strDia = "0" & strDia
     End If
     strMes     = Month(DateToConvert)
     If strMes < 10 Then
       strMes = "0" & strMes
     End If   
     strAno     = Year(DateToConvert)
     strHora    = Hour(DateToConvert)
     If strHora < 10 Then
       strHora = "0" & strHora
     End If
     strMinuto  = Minute(DateToConvert)
     If strMinuto < 10 Then
       strMinuto = "0" & strMinuto
     End If
     strSegundo = Second(DateToConvert)
     If strSegundo < 10 Then
       strSegundo = "0" & strSegundo
     End If


     If FormatoDiaMes Then
       PrepDataIve = strAno & "/" & strMes & "/" & strDia
     Else
       PrepDataIve = strAno & "-" & strMes & "-" & strDia
     End If


     If DataHora Then
       PrepDataIve = PrepDataIve & " " & strHora & ":" & strMinuto & ":" & strSegundo
     End If
   Else
     PrepDataIve = ""
   End If

End Function 

Function FormataDouble(prValor,prCasas)
 Dim strValorLocal
	
  strValorLocal = FormatNumber(prValor,prCasas)
  strValorLocal = Replace(Replace(strValorLocal,".",""),",",".")
  FormataDouble = strValorLocal
End Function


Function tipoCAMPO(strCAMPO,strTIPO,strUPPER)


	Select case Int(strTIPO)
		Case  3, 19 :'Inteiro

				if strCAMPO <>"" And IsNumeric(strCAMPO) Then
					tipoCAMPO = clng(strCAMPO)
				else
					tipoCAMPO ="NULL"
				End If
				
		Case 135 :'DataTime
				
				if strCAMPO <>"" Then
					tipoCAMPO = "'"&PrepDataIve(strCAMPO, true,true)&"'"
				else
					tipoCAMPO = "NULL"
				End If
				
		Case 16 :'boleano

				if strCAMPO <>"" Then
					tipoCAMPO = strCAMPO
				else
					tipoCAMPO = "NULL"
				End If

		Case 5 :'DOUBLE
				if strCAMPO <>"" Then
					tipoCAMPO = FormataDouble(strCAMPO,2)
				else
					tipoCAMPO = "NULL"
				End If	
					
		Case 200, 202, 203 :'Text
				if strCAMPO <>"" Then
				    If strUPPER = "S" Then
					  strCAMPO = UCase(strCAMPO)
					End If
					tipoCAMPO = "'"&Replace(Trim(strCAMPO),"'","''")&"'"
				else
					tipoCAMPO = "NULL"
				End If		
	End Select	
	
End Function

Sub GravaCadastro(CAMPOS, VALORES)

strCOLUNAS = Left(Replace(CAMPOS,"|",","), len(CAMPOS)-1)
strLINHAS  = Left(Replace(VALORES,"|",","), len(VALORES)-1)

  On Error Resume Next

	strSQL = "INSERT INTO "&strTABELA&" ("&strCOLUNAS&") VALUES ("&strLINHAS&")"
	'Response.Write(strSQL & "<BR><BR>")
	objConn.Execute(strSQL)

 If Err.Number <> 0 Then  
   strERRO = strERRO & "<li>Erro: <b>" & strLINHAS & "</b> (" & err.Description & ")<BR>"
   conterro = conterro + 1
 Else 
   strSucesso = strSucesso & "<li>Sucesso: <b>" & strLINHAS & "</b><BR>" 
   contsucesso = contsucesso + 1
 End If

End Sub
		
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" type="text/css" href="../_css/virtualboss.css">
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<link rel="stylesheet" type="text/css" href="../_css/menupure.css">
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
/*function ok() { document.form_principal.DEFAULT_LOCATION.value = ""; document.form_principal.submit(); }
function cancelar() { document.location.href = document.form_principal.DEFAULT_LOCATION.value; }
function aplicar() { document.form_insert.JSCRIPT_ACTION.value = "";	document.form_principal.submit(); }*/
</script>
</head>
<body>
	<%
	'Concatenamos o link corretamente para os casos
	'onde o redirect tenha sido informado ou não
	athBeginCssMenu()
		athCssMenuAddItem "#", "onClick=""displayArea('table_header0');""", "_self", "Resultado Importação dos Dados", "", 0
	athEndCssMenu("")
%>
	<div id="table_header0" style="width:100%">
        <table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tableheader">
        <!-- 
            Possibilidades de tipo de sort...
            class="sortable-date-dmy"
            class="sortable-currency"
            class="sortable-numeric"
            class="sortable"
        -->
            <!--thead>
                <tr> 
                    <th>Dados</th>
                </tr>
            </thead-->
            <tbody style="text-align:left;">
                
                <%			
                    arrCAMPOS = split(strCAMPOS,"|")
                    for k=0 to ubound(arrCAMPOS)-1
                        strCAMPOS2=Request.Form("var_"&arrCAMPOS(k))
                        If strCAMPOS2<>"" then
                            strCAMPOFIM=strCAMPOFIM&arrCAMPOS(k)&"|"
                            strCAMPOS3=strCAMPOS3&strCAMPOS2&"|"
                            strTIPOS = strTIPOS&Request.Form("var_tipo_"&arrCAMPOS(k))&"|"
                            strUPPER = strUPPER&Request.Form("var_upper_"&arrCAMPOS(k))&"|"
                        End If	
                    Next	
                        
                    arrEXCEL  = Split(strCAMPOS3,"|")
                    arrTABELA =	Split(strCAMPOFIM,"|")
                    arrTIPOS  = Split(strTIPOS,"|")
                    arrUPPER  = Split(strUPPER,"|")
            
                    Set cnnExcel = Server.CreateObject("ADODB.Connection")
                    cnnExcel.Open "DRIVER={Microsoft Excel Driver (*.xls)}; DBQ=" & Server.MapPath("..") & "\" & strARQUIVO 
                    Set rstExcel = Server.CreateObject("ADODB.Recordset")
                    rstExcel.Open "SELECT * FROM [PLAN1$]",cnnExcel,adOpenStatic,adLockPessimistic  		
                    iCols = rstExcel.Fields.Count
                    If not rstExcel.EOF Then
                        rstExcel.MoveFirst
                        While Not rstExcel.EOF
                            strVALOR=""
                            For k=0 to Ubound(arrEXCEL)-1
                                For I = 0 To iCols - 1
                                    If Trim(rstExcel.Fields.Item(I).Name) = arrEXCEL(K) Then									
                                        strVALOR =strVALOR&tipoCAMPO(rstExcel.Fields.Item(I).Value, arrTIPOS(k), arrUPPER(k))&"|"
                                    End If
                                Next
                             Next
                            GravaCadastro strCAMPOFIM, strVALOR						
                            contador = contador + 1
                            rstExcel.MoveNext
                            If contador mod 100 = 0 Then
                              If strMontaTabela = "S" Then
                                  Response.Write("<tr><td style='width:100px;'></td><td>Registros processados:<br>")
                                  strMontaTabela = "F"
                              End If
                              Response.Write( contador & " / ")
                              Response.Flush()
                            End If
                        Wend
                            If strMontaTabela = "F" Then
                                Response.Write("</td></tr>")
                            End If
                    End If
                    rstExcel.Close
                
                Set rstExcel = Nothing
                cnnExcel.Close
                Set cnnExcel = Nothing			
                %>
                
                
                <tr>
                    <td style="width:100px;"></td> 
                    <td>
                    <% 
                        Response.write(strSucesso)
                        Response.Write(strErro)
                        if conterro > 0 then
                            Response.Write("<br><br>*** Erro(s) = " & conterro & " registros não inseridos***")
                        end if
                        if contsucesso > 0 then
                            Response.Write("<br><br>*** Sucesso(s) = " & contsucesso & " registros Inseridos***")
                        end if					
                        Response.Write("<br><br>*** TOTAL = " & contador & " registros ***<br><br>")	
                    %>
                    </td>
                 </tr>
             </tbody>
        </table>    
    </div>
    <br />
    <%
	'Concatenamos o link corretamente para os casos
	'onde o redirect tenha sido informado ou não
	athBeginCssMenu()
		athCssMenuAddItem "#", "onClick=""displayArea('table_header');""", "_self", "Últimos 100 registros da tabela <strong>" & strTABELA & "</strong>", "", 0
	athEndCssMenu("")
%>
<%		strSQL="SELECT * FROM " & strTABELA & " ORDER BY 1 DESC LIMIT 100"
		
		set objRS = Server.CreateObject("ADODB.Recordset")
		objRS.Open strSQL, objConn
'		If objRS.fields.count - 1 < 3 THEN
'			intExibeCampos = 3
'		Else 
'			intExibeCampos = objRS.fields.count - 1
'		End If			

%>
	<div id="table_header" style="width:100%">
        <table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
            <thead>
                <tr>
            <% For i = 0 to objRS.fields.count - 1	%>
                    <th <% If i = 0 Then %> width="1%"<%End If%>><%=objRS.Fields(i).Name%></th>
            <% Next %>								
                </tr> 
            </thead>
            <tbody>
                <%While Not objRS.EOF%>
                    <tr>
                    <% For i = 0 to objRS.fields.count - 1	%>
                        <td><%=objRS.Fields(i).Value%></td>
                    <% Next %>
                    </tr>
                   <% athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT								            
                Wend%>
            </tbody>        
        </table>
    </div>
</body>
</html>
