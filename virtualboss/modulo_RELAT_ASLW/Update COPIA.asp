<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_RELAT_ASLW", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"
 ' -------------------------------------------------------------------------------

  Dim strSQL, objRS, ObjConn
  Dim strCOD_RELATORIO

  AbreDBConn objConn, CFG_DB
	
  strCOD_RELATORIO = GetParam("var_chavereg")
	
  strSQL = " SELECT T1.COD_RELATORIO, T1.COD_CATEGORIA, T1.NOME, T1.DESCRICAO, T1.EXECUTOR, T1.PARAMETRO " & _ 
  		   "       ,T1.SYS_CRIA, T1.SYS_ALTERA, T1.DT_CRIACAO, T1.DT_INATIVO, T1.DT_ALTERACAO, T2.NOME AS CATEGORIA " &_
  		   "  FROM ASLW_RELATORIO T1 " &_
		   "  LEFT OUTER JOIN ASLW_CATEGORIA T2 ON (T1.COD_CATEGORIA = T2.COD_CATEGORIA) " & _
		   " WHERE T1.COD_RELATORIO = " & strCOD_RELATORIO
 
  Set objRS = objConn.Execute(strSQL)
  If Not objRS.Eof Then
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
<!--
function Grava() {
 var form = document.form_update;
 
 if (form.radExecDefault.checked) { 
 	form.DBVAR_STR_EXECUTOR.value = 'ExecASLW.asp'; 
 }
 else { 
 	form.DBVAR_STR_EXECUTOR.value = form.txtExecutor.value; 
 }
 
 form.submit();
}

function ExecRelASLW(prPagina, prCodigo) {
	var var_msg = '';
	
	if (prPagina == '') var_msg += 'Favor informar executor do relatório\n';
	if (prCodigo == '') var_msg += 'Favor informar código do relatório\n';
	
	if (var_msg == '') 
		AbreJanelaPAGE(prPagina + '?var_chavereg=' + prCodigo, '680', '460');
	else 
		alert(var_msg);
}

function ExecRelOutro() {
	if (document.form_update.txtExecutor.value != '<Digite seu executor de relatório>')
		AbreJanelaPAGE(document.form_update.txtExecutor.value+'?var_strParam='+document.form_update.DBVAR_STR_PARAMETRO.value, '680', '460');
	else
		alert('Favor informar executor do relatório');
}

//-->
</script>
</head>
<body bgcolor="#FFFFFF" background="../img/bg_dialog.gif" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%=athBeginDialog(WMD_WIDTH, "Alteração de Relatório") %>
<!-- INIC: TABELA DE "MIOLO" Dialog (ITENS DO FORMULÁRIO) -->                    
<table width="387" border="0" cellpadding="0" cellspacing="0" align="center">
  <form name="form_update" action="Update_exec.asp" method="POST">
                      <input type="hidden" name="RECORD_KEY_VALUE" value="<%=GetValue(ObjRS,"COD_RELATORIO")%>">
                      <tr> 
                        <td width="88" align="right">C&oacute;digo:&nbsp;</td>
                        <td colspan="3"><b><%=GetValue(ObjRS,"COD_RELATORIO")%></b></td>
                      </tr>
                      <tr> 
                        <td width="88" align="right">Categoria:&nbsp;</td>
                        <td colspan="3">
						  <select name="DBVAR_NUM_COD_CATEGORIA">
                            <option value="">Selecione...</option>
                            <% montaCombo "INT", " SELECT COD_CATEGORIA, NOME FROM ASLW_CATEGORIA ORDER BY NOME ", "COD_CATEGORIA", "NOME", GetValue(ObjRS,"COD_CATEGORIA")&"" %>
                          </select></td>
                      </tr>
                      <tr> 
                        <td width="88" align="right">Nome:&nbsp;</td>
                        <td colspan="3"><input name="DBVAR_STR_NOME" type="text" value="<%=GetValue(ObjRS,"NOME")%>" size="50"></td>
                      </tr>
                      <tr> 
                        <td width="88" align="right" valign="top">Descrição:&nbsp;</td>
                        <td colspan="3"><textarea name="DBVAR_STR_DESCRICAO" cols="40" rows="6"><%=GetValue(ObjRS,"DESCRICAO")%></textarea></td>
                      </tr>
                      <input type="hidden" name="DBVAR_STR_EXECUTOR" value="">
                      <tr valign="middle"> 
                        <td align="right">Executor:&nbsp;</td>
                        <td width="37"  nowrap><input type="radio" name="radExec" id="radExecOutro" value="" 
												<% If UCase(GetValue(ObjRS,"EXECUTOR")) <> "EXECASLW.ASP" Then Response.Write(" checked") %>>Outro</td>
                        <td width="175"><input name="txtExecutor" type="text" size="35" value="<% 
						If GetValue(ObjRS,"EXECUTOR") = "" Then 
							Response.Write("<Digite seu executor de relatório>") 
						Else
							If UCase(GetValue(ObjRS,"EXECUTOR")) <> "EXECASLW.ASP" Then 
								Response.Write(GetValue(ObjRS,"EXECUTOR")) 
							Else
							    Response.Write("<Digite seu executor de relatório>") 
							End If 
						End If 
						%>"></td>
                        <td width="87" valign="middle"><a href="Javascript:ExecRelOutro();"><img src="../img/bt_execSQL.gif" alt="Testar" width="13" height="17" border="0" hspace="7"></a></td>
                      </tr>
                      <tr valign="middle"> 
                        <td align="right">&nbsp;</td>
                        <td width="37" nowrap><input type="radio" name="radExec" id="radExecDefault" value="" <% If UCase(GetValue(ObjRS,"EXECUTOR")) = "EXECASLW.ASP" Then Response.Write(" checked") %>>Default</td>
                        <td colspan="2" valign="middle"><input name="txtExecutorASLW" type="text" size="35" readonly="" value="ExecASLW.asp"><a href="Javascript:ExecRelASLW(document.form_update.txtExecutorASLW.value, '<%=GetValue(ObjRS,"COD_RELATORIO")%>');"><img src="../img/bt_execSQL.gif" alt="Testar SQL" width="13" height="17" border="0" hspace="7"></a></td>
                      </tr>
                      <tr> 
                        <td align="right" valign="top">Parâmetro:&nbsp;</td>
                        <td colspan="3"><textarea name="DBVAR_STR_PARAMETRO" cols="40" rows="6"><%=RemoveTagSQL(GetValue(ObjRS,"PARAMETRO"))%></textarea> 
                        </td>
                      </tr>
                      <tr> 
                        <td align="right">Criação:&nbsp;</td>
                        <td colspan="3"><%=PrepData(GetValue(ObjRS,"DT_CRIACAO"), True, False)%>&nbsp;&nbsp;(&nbsp;<%=GetValue(ObjRS,"SYS_CRIA")%>&nbsp;)</td>
                      </tr>
                      <tr> 
                        <td align="right" nowrap>&Uacute;ltima Alteração:&nbsp;</td>
                        <td colspan="3"> 
                        <% 
						If GetValue(ObjRS,"DT_ALTERACAO") <> "" Then
							Response.Write(PrepData(GetValue(ObjRS,"DT_ALTERACAO"), True, False) & "&nbsp;&nbsp;(&nbsp;" & GetValue(ObjRS,"SYS_ALTERA") & "&nbsp;)")
						End If
						%>
						<input name="DBVAR_AUTODATE_DT_ALTERACAO" type="hidden" value="<%=Now()%>"> 
                        <input name="DBVAR_STR_SYS_ALTERA" type="hidden" value="<%=Request.Cookies("VBOSS")("ID_USUARIO")%>"> 
                        </td>
                      </tr>
                      <tr> 
	                      <td align="right">Status:&nbsp;</td>
    	                  <td nowrap> 
        	              <%
							If GetValue(objRS,"DT_INATIVO") = "" Then
		                      Response.Write("<input type='radio' class='inputclean' name='DBVAR_DATE_DT_INATIVO' value='NULL' checked>Ativo")
        		              Response.Write("<input type='radio' class='inputclean' name='DBVAR_DATE_DT_INATIVO' value='" & Date() & "'>Inativo")
                      		Else
                		      Response.Write("<input type='radio' class='inputclean' name='DBVAR_DATE_DT_INATIVO' value='NULL'>Ativo")
		                      Response.Write("<input type='radio' class='inputclean' name='DBVAR_DATE_DT_INATIVO' value='" & Date() & "' checked>Inativo")
        		            End If
    	                  %>
    	                  </td>
                      </tr>
                    </form>
                  </table>
     <!-- FIM: TABELA DE "MIOLO" Dialog (ITENS DO FORMULÁRIO) -->

<%
  response.write athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")
  'athEndDialog WMD_WIDTH, "../img/bt_save.gif", "javascript:Grava();", "", "", "", ""
%>
</body>
</html>
<%
	  FechaRecordSet ObjRS
  End If
  FechaDBConn ObjConn
%>