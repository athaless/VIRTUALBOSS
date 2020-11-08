<!--#include file="_database/athDbConn.asp"-->
<!--#include file="_database/athUtils.asp"-->
<!--#include file="_database/athFileTools.asp"-->
<!--#include file="_database/object_functions.asp"-->
<!--#include file="_scripts/scripts.js"-->
<%
 Const WMD_WIDTH = 490 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Seja paciente, você não irá receber nenhuma notificação até que a transferência do arquivo seja concluída.</span>"

	Dim objUpload, strFUNC, strFORMNAME, strFIELDNAME, strFILE, strDIR_UPLOAD
	Dim strFILENAME, strERRO, strFilePrefix
	
	'Comentado a pedido do Aless. By Lumertz - 03/05/2013 
	'Sub TestaUploader
    ' if TestaDundas()		then response.write("formupload.upload_dundas.disabled = false;")
	' if TestaASPUpload()	then response.write("formupload.upload_aspupload.disabled = false;")
	' if TestaByteToByte()	then response.write("formupload.upload_bytebyte.disabled = false;")
    'End Sub
	
	strERRO			 = GetParam("var_erro")
	strFILENAME		 = GetParam("var_file")
	strFORMNAME		 = GetParam("var_formname")
	strFIELDNAME	 = GetParam("var_fieldname")
	strDIR_UPLOAD	 = Replace(GetParam("var_dir"), "\", "\\")
	strFUNC			 = GetParam("var_func")
	'Parâmetro que controla se deve ser colocado prefixo no nome do arquivo. By Lumertz - 29.04.2013.
	strFilePrefix = GetParam("var_file_prefix")

	If strFUNC= "" Then strFUNC = 1
	
	Select Case strFUNC
		Case 1
%>
			<html>
			<head>
				<title>Upload de Arquivo</title>
				<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
				<link href="_css/virtualboss.css" rel="stylesheet" type="text/css">
				<script language="javascript" type="text/javascript">
					function ok() {						
						/*Comentado a pedido do Aless. By Lumertz - 03/05/2013 
						for (i = 0; i < document.formupload.type_upload.length; i++)
						{
							if (eval('document.formupload.type_upload[' + i + '].checked'))
							{
								var valor = eval('document.formupload.type_upload[' + i + '].value');
								break;
							}
						}
						*/
						var valor = 'athUploader_PHP.php'
						document.formupload.action = valor + '?var_formname=<%=strFORMNAME%>&var_fieldname=<%=strFIELDNAME%>&var_dir=<%=strDIR_UPLOAD%>&var_file_prefix=<%=strFilePrefix%>';
						document.formupload.submit();
					}
					
					function cancelar() { window.close(); }
					/*Comentado a pedido do Aless. By Lumertz - 03/05/2013 */
					/*function TestaCheck()
					{
					 for(i = 0; i < document.formupload.type_upload.length; i++)
						{
							if(!eval('document.formupload.type_upload[' + i + '].disabled'))
							{
								var valor = eval('document.formupload.type_upload[' + i + '].checked = true');
								break;
							}
						}
					}*/
				</script>
			</head>
            <!--Comentado a pedido do Aless. By Lumertz - 03/05/2013 //-->
			<!--<body onLoad="<%'TestaUploader%>TestaCheck();">//-->
            <body>
			  <%=athBeginDialog(WMD_WIDTH, "Upload de Arquivo")%>
			  <form name="formupload" id="formupload" action="" method="post" enctype="multipart/form-data">
			  <input type="hidden" id="var_path" name="var_path" value="<%=FindUploadPath%>">
			  <div class="form_label"><strong>Instruções:</strong></div><div class="form_bypass">Para enviar o seu arquivo siga as instruções abaixo:</div>
			  <br><div class="form_label"></div><div class="form_bypass">1. Clique no bot&atilde;o PROCURAR/ESCOLHER ARQUIVO</div>
			  <br><div class="form_label"></div><div class="form_bypass">2. Selecione o arquivo no seu computador&nbsp;</div>
			  <br><div class="form_label"></div><div class="form_bypass">3. Clique no botão OK para enviar&nbsp;</div>
			  <br><div class="form_label">Caminho:</div><input name="file1" id="file1" type="file" style="width:250px; height:20px;">
			  <br><div class="form_label">Objeto Usado:	</div><input type="radio" name="type_upload" id="upload_php" checked class="inputclean'" disabled value="athUploader_PHP.php">&nbsp;PHP
              <!-- Comentado a pedido do Aless. By Lumertz - 03/05/2013 //-->
             
			  <!--br><div class="form_label">				</div><input type='radio' name='type_upload' id='upload_dundas'	 	class='inputclean' disabled value='athUploader_DUNDAS.asp'>&nbsp;Dundas<//-->
			  <!--br><div class="form_label">				</div><input type='radio' name='type_upload' id='upload_aspupload' 	class='inputclean' disabled value='athUploader_ASPUPLOAD.asp'>&nbsp;ASP Upload<//-->
			  <!--br><div class="form_label">				</div><input type='radio' name='type_upload' id='upload_bytebyte' 	class='inputclean' disabled value='athUploader_BYTEBYTE.asp'>&nbsp;Byte to Byte     <//-->         
              
			  </form>
			  <iframe borderframe="0" width="1" height="1" src="./_database/athTesteUploadPHP.php"></iframe>
			  <%=athEndDialog(auxAVISO, "img/butxp_ok.gif", "ok();", "img/butxp_cancelar.gif", "cancelar();", "", "")%>
			</body>
			</html>
<%
    Case 2
		If strERRO <> "" Then
%>
			<html>
			<head>
			<title>Upload de Arquivo</title>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
			<link href="_css/virtualboss.css" rel="stylesheet" type="text/css">
				<script language="javascript" type="text/javascript">				    					
					function ok()       { document.formuploaderror.submit(); }
					function cancelar() { window.close(); }
				</script>
			</head>
			<body>
			  <%=athBeginDialog(WMD_WIDTH, "Upload de Arquivo")%>
			  <form name="formuploaderror" action="athUploader.asp?var_formname=<%=strFORMNAME%>&var_fieldname=<%=strFIELDNAME%>&var_func=1" method="POST">
			  <div class="form_label"><strong>Mensagem:</strong></div><div class="form_bypass">Ocorreu um erro ao tentar enviar o seu arquivo</div>
			  <br><div class="form_label"><strong>Erro:</strong></div><div class="form_bypass"><%=strERRO%></div>
			  <br><br><div class="form_label"></div><div class="form_bypass">Clique no botão OK para tentar novamente o upload ou em CANCELAR para sair.</div>
			  </form>
			  <%=athEndDialog(auxAVISO, "img/butxp_ok.gif", "ok();", "img/butxp_cancelar.gif", "cancelar();", "", "")%>
			</body>
			</html>
<%
        Else
%>
			<html>
			<head>
			<title>Upload de Arquivo</title>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
			<link href="_css/virtualboss.css" rel="stylesheet" type="text/css">
				<script language="javascript" type="text/javascript">
				  <% If(LCase(strFilePrefix) = "false") Then %>
					function ok() { location.href="athUploader.asp?var_file_prefix=false&var_dir=//upload//<%=Request.Cookies("VBOSS")("CLINAME")%>";}  
				  <% Else %>
					function ok() { window.close(); }
				  <%End If%>
					function SetParentField () { window.opener.SetFormField('<%=strFORMNAME%>', '<%=strFIELDNAME%>', 'edit', '<%=strFILENAME%>'); }
				</script>
			</head>
			<body onUnload="SetParentField();">
			  <%=athBeginDialog(WMD_WIDTH, "Upload de Arquivo")%>
			  <div class="form_label"><strong>Mensagem:</strong></div><div class="form_bypass">Upload do arquivo efetuado com sucesso</div>
			  <br><div class="form_label">Arquivo:</div><div class="form_bypass"><%=strFILENAME%></div>
			  <br><br><div class="form_label"></div><div class="form_bypass">Clique no botão OK para sair ou simplesmente feche essa janela.</div>
			  <%=athEndDialog(auxAVISO, "img/butxp_ok.gif", "ok();", "", "", "", "")%>
			</body>
			</html>
<%
		End If
	End Select
%> 