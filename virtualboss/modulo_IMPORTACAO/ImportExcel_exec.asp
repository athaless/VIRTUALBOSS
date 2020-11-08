<!--#include file="../_database/athdbConn.asp"--> <%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_IMPORTACAO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 ' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
 ' e o tamanho da coluna dos títulos dos inputs
 Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 


 Dim objConn, objRS, objRSAux, strSQL
 Dim strTabela, strArquivo
 Dim arrCOLUNAS, i, n, strCampos, auxAVISO
 Dim cnnExcel, rstExcel, iCols, strCOLUNAS
  strArquivo = "upload\" & Request.Cookies("VBOSS")("CLINAME") & "\" & GetParam("var_arquivo_excel")
  strTabela = GetParam("var_tabela")

  auxAVISO  = "dlg_info.gif:ATENÇÃO! Importação do arquivo " & GetParam("var_arquivo_excel") & "."' -------------------------------------------------------------------------------
 
 AbreDBConn objConn, CFG_DB 

	strSQL="show tables "
 
 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
 
 If Not objRS.Eof Then
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok() { document.form_principal.DEFAULT_LOCATION.value = ""; document.form_principal.submit(); }
function cancelar() { document.location.href = document.form_principal.DEFAULT_LOCATION.value; }
function aplicar() { document.form_principal.JSCRIPT_ACTION.value = "";	document.form_principal.submit(); }
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Importação Planilhas Excel") %>
	<form name="form_principal" action="ImportExcel_exec2.asp" method="post">
	    <input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
   		<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_PAINEL/principal.htm'>
        <input type="hidden" name="var_arquivo" value="<%=strArquivo%>">
		<input type="hidden" name="var_tabela" value="<%=strTABELA%>">    
     		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="texto_corpo_mdo">
                    <tr>
                        <td colspan="2" height="10"></td>
                    </tr>
                    
                    <tr>
                        <td style="text-align:left;">Tabela:&nbsp;</td>
                        <td height="10"><b><%=strTABELA%></b></td>
                    </tr>
                    <tr>
                        <td colspan="2" height="10"></td>
                    </tr>
                    <tr>
                        <td style="text-align:left;">Relação dos campos:</td>
                        <td height="10"><hr></td>
                    </tr>
                    <tr>
                        <td colspan="2" height="10"></td>
                    </tr>
<%						
							Set cnnExcel = Server.CreateObject("ADODB.Connection")
					  		cnnExcel.Open "DRIVER={Microsoft Excel Driver (*.xls)}; DBQ=" & Server.MapPath("..") & "\" & strArquivo
 
					  		Set rstExcel = Server.CreateObject("ADODB.Recordset")
					  		rstExcel.Open "SELECT * FROM [PLAN1$]",cnnExcel,adOpenStatic,adLockPessimistic
  							iCols = rstExcel.Fields.Count
							strCOLUNAS=""
							For I = 0 To iCols - 1
								If Trim(rstExcel.Fields.Item(I).Name)<>"" Then
									strCOLUNAS = strCOLUNAS &"|"&Trim(rstExcel.Fields.Item(I).Name)
								End If	
							Next		
					
							arrCOLUNAS=Split(strColunas,"|")
				
							strSQL="SELECT * FROM " & strTABELA
							set objRS = Server.CreateObject("ADODB.Recordset")
							objRS.Open strSQL, objConn

						For i = 0 to objRS.fields.count - 1
							strCAMPOS=strCAMPOS&objRS.Fields(i).Name&"|"
%>												
                    <tr> 
                        <td align="left"><%=objRS.Fields(i).Name%>:&nbsp;</td>
                        <td>
							<input type="hidden" name="var_tipo_<%=objRS.Fields(i).Name%>" value="<%=objRS.Fields(i).type%>">
                            <select name="var_<%=objRS.Fields(i).Name%>" class="textbox180">								
                            	<option value="" selected>Selecione o campo</option>
                                <%for n=0 to Ubound(arrCOLUNAS)	%>
                                <option value="<%=arrCOLUNAS(n)%>" <% If UCase(objRS.Fields(i).Name) = UCase(arrCOLUNAS(n)) Then Response.Write("selected") End If %>><%=arrCOLUNAS(n)%></option>
                                <%Next%>	
                            </select>
						<%If objRS.Fields(i).type = 200 or  objRS.Fields(i).type = 202 or objRS.Fields(i).type = 203 Then%>
                            <input type="radio" name="var_upper_<%=objRS.Fields(i).Name%>" value="S" > Maiúsculo
                            <input type="radio" name="var_upper_<%=objRS.Fields(i).Name%>" value="N" checked > Padrão
                        <%Else%>
                            <input type="hidden" name="var_upper_<%=objRS.Fields(i).Name%>" value="">
                        <%End If%>
                        </td>
                    </tr>
					  <%Next%>
							<input type="hidden" name="var_campos" value="<%=strCAMPOS%>">
                    <tr>
                        <td colspan="2" height="10"></td>
                    </tr>
                    <tr>
                        <td style="text-align:left;">Excluir dados existentes:</td>
                        <td>Sim<input type="radio" name="var_exluir_dados" id="var_exluir_dados" value="S" >&nbsp;Não<input type="radio" name="var_apaga_dados" value="N" checked ></td>
                    </tr>
                    <tr>
                        <td colspan="2" height="10"></td>
                    </tr>
     		</table>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();","","") %>
</body>
</html>
<%
 End If
 
 FechaRecordSet objRS
 FechaDBConn objConn
%>	