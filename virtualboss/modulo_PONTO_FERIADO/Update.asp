<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_PONTO_FERIADO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<%
 Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "dlg_warning.gif:ATENÇÃO!Você está prestes a remover o registro <br> acima visualizado. Para confirmar clique no botão [ok], para desistir clique em [cancelar]."

 Dim strSQL, objRS, ObjConn
 Dim strCODIGO, i

 strCODIGO = GetParam("var_chavereg")

 If strCODIGO <> "" Then
	AbreDBConn objConn, CFG_DB 
	
	strSql =          "SELECT COD_FERIADO, DATA_DIA, DATA_MES, DATA_ANO, DESCRICAO, UF"
	strSql = strSql & "  FROM PT_FERIADO"
	strSql = strSql & " WHERE COD_FERIADO = " & strCODIGO
	
	Set objRS = objConn.Execute(strSQL)
	
	If Not objRS.Eof Then
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok() 		{ document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar() 	{ document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() { document.form_update.submit(); }
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Feriado/Recesso - Alteração")%>
<form name="form_update" action="../_database/athUpdateToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="PT_FERIADO">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_FERIADO">
	<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODIGO%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_PONTO_FERIADO/Update.asp?var_chavereg=<%=strCODIGO%>'>
	<div class="form_label">Cod.:</div><div class="form_bypass"><%=strCODIGO%></div>
	<br><div class="form_label">Dia:</div><select name="DBVAR_NUM_DATA_DIA" style="width:40px">
		   								  <%
										     For i=1 To 31
										     response.write("<option value='" & i & "'")
		        							 if GetValue(objRS,"DATA_DIA")=i then response.write("selected='selected' ") end if 
											 response.write(">" & i & "</option>" & vbnewline)
											 next
										  %>
										  </select>
	<br><div class="form_label">Mês:</div><select name="DBVAR_NUM_DATA_MES" style="width:40px">
										  <%
										     For i=1 To 12
									 	     response.write("<option value='" & i & "'")
									         if GetValue(objRS,"DATA_MES")=i then response.write("selected='selected' ") end if 
										     response.write(">" & i & "</option>" & vbnewline)
											 next
										  %>
		 								  </select>
	<br><div class="form_label">Ano:</div><select name="DBVAR_NUM_DATA_ANO" style="width:60px">
										  <%
			    							 For i=2008 To 2020
											    response.write("<option value='" & i & "'")
										        if CStr(GetValue(objRS,"DATA_ANO")) = CStr(i) then response.write("selected='selected' ") end if 
											    response.write(">" & i & "</option>" & vbnewline)
											 Next
		  								  %>
								   		  <option value='' <% If GetValue(objRS,"DATA_ANO") = "" Then response.write("selected='selected' ") End If %>></option>
										  </select>
										  <span class="texto_ajuda">*VAZIO indica QUALQUER Ano</span>
	<br><div class="form_label">UF:</div><select name="DBVAR_STR_UF" style="width:150px">
											<option value=""   <%if (GetValue(objRS,"UF")="")   then response.write("selected='selected' ")%>></option>
											<option value="AC" <%if (GetValue(objRS,"UF")="AC") then response.write("selected='selected' ")%>>AC-Acre</option>
											<option value="AL" <%if (GetValue(objRS,"UF")="AL") then response.write("selected='selected' ")%>>AL-Alagoas</option>
											<option value="AP" <%if (GetValue(objRS,"UF")="AP") then response.write("selected='selected' ")%>>AP-Amapá</option>
											<option value="AM" <%if (GetValue(objRS,"UF")="AM") then response.write("selected='selected' ")%>>AM-Amazonas</option>
											<option value="BA" <%if (GetValue(objRS,"UF")="BA") then response.write("selected='selected' ")%>>BA-Bahia</option>
											<option value="CE" <%if (GetValue(objRS,"UF")="CE") then response.write("selected='selected' ")%>>CE-Ceará</option>
											<option value="DF" <%if (GetValue(objRS,"UF")="DF") then response.write("selected='selected' ")%>>DF-Distrito Federal</option>
											<option value="ES" <%if (GetValue(objRS,"UF")="ES") then response.write("selected='selected' ")%>>ES-Espirito Santo</option>
											<option value="GO" <%if (GetValue(objRS,"UF")="GO") then response.write("selected='selected' ")%>>GO-Goiás</option>
											<option value="MA" <%if (GetValue(objRS,"UF")="MA") then response.write("selected='selected' ")%>>MA-Maranhão</option>
											<option value="MT" <%if (GetValue(objRS,"UF")="MT") then response.write("selected='selected' ")%>>MT-Mato Grosso</option>
											<option value="MS" <%if (GetValue(objRS,"UF")="MS") then response.write("selected='selected' ")%>>MS-Mato Grosso do Sul</option>
											<option value="MG" <%if (GetValue(objRS,"UF")="MG") then response.write("selected='selected' ")%>>MG-Minas Gerais</option>
											<option value="PA" <%if (GetValue(objRS,"UF")="PA") then response.write("selected='selected' ")%>>PA-Pará</option>
											<option value="PB" <%if (GetValue(objRS,"UF")="PB") then response.write("selected='selected' ")%>>PB-Paraiba</option>
											<option value="PR" <%if (GetValue(objRS,"UF")="PR") then response.write("selected='selected' ")%>>PR-Paraná</option>
											<option value="PE" <%if (GetValue(objRS,"UF")="PE") then response.write("selected='selected' ")%>>PE-Pernambuco</option>
											<option value="PI" <%if (GetValue(objRS,"UF")="PI") then response.write("selected='selected' ")%>>PI-Piauí</option>
											<option value="RJ" <%if (GetValue(objRS,"UF")="RJ") then response.write("selected='selected' ")%>>RJ-Rio de Janeiro</option>
											<option value="RN" <%if (GetValue(objRS,"UF")="RN") then response.write("selected='selected' ")%>>RN-Rio Grande do Norte</option>
											<option value="RS" <%if (GetValue(objRS,"UF")="RS") then response.write("selected='selected' ")%>>RS-Rio Grande do Sul</option>
											<option value="RO" <%if (GetValue(objRS,"UF")="RO") then response.write("selected='selected' ")%>>RO-Rondônia</option>
											<option value="RR" <%if (GetValue(objRS,"UF")="RR") then response.write("selected='selected' ")%>>RR-Roraima</option>
											<option value="SC" <%if (GetValue(objRS,"UF")="SC") then response.write("selected='selected' ")%>>SC-Santa Catarina</option>
											<option value="SP" <%if (GetValue(objRS,"UF")="SP") then response.write("selected='selected' ")%>>SP-São Paulo</option>
											<option value="SE" <%if (GetValue(objRS,"UF")="SE") then response.write("selected='selected' ")%>>SE-Sergipe</option>
											<option value="TO" <%if (GetValue(objRS,"UF")="TO") then response.write("selected='selected' ")%>>TO-Tocantis</option>
										  </select>
										  <span class="texto_ajuda">*VAZIO indica todos estados</span>
										  
	<br><div class="form_label">Observa&ccedil;&atilde;o:</div><textarea name="DBVAR_STR_DESCRICAO" rows="5" style="width:280px;"><%=GetValue(objRS, "DESCRICAO")%></textarea>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
</body>
</html>
<%
		End If 
	    FechaRecordSet objRS
		FechaDBConn objConn
	End If 
%>