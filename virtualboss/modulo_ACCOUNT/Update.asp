<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_ACCOUNT", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
	Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
	Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"
	
	Dim objConn, objRS, strSQL, strCODIGO
	
	strCODIGO = GetParam("var_chavereg")
	
	If strCODIGO <> "" Then
		AbreDBConn objConn, CFG_DB
		
		strSQL = " SELECT GRUPO, FORNECEDOR, TIPO, CONTA_USR, CONTA_SENHA, CONTA_EXTRA1, CONTA_EXTRA2 " &_
				 "      , CONTA_EXTRA3, ENDER_URL, OBS, ORDEM, DT_INATIVO " &_
		         "  FROM ACCOUNT_SERVICE " &_
				 "  WHERE COD_ACCOUNT_SERVICE = " & strCODIGO
		
		Set objRS = objConn.execute(strSQL)
		
		If Not objRS.EOF then  
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok() { document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar() { document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() { document.form_update.submit(); }
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Account Service - Alteração")%>
<form name="form_update" action="../_database/athUpdateToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="ACCOUNT_SERVICE">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_ACCOUNT_SERVICE">
	<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODIGO%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_ACCOUNT/Update.asp?var_chavereg=<%=strCODIGO%>'>
	<input type="hidden" name="DBVAR_DATE_SYS_DT_UPD" value="<%=PrepDataBrToUni(Now, False)%>">
	<input type="hidden" name="DBVAR_STR_SYS_USR_UPD" value="<%=Request.Cookies("VBOSS")("ID_USUARIO")%>">
    <div class="form_label">Cod.:</div><div class="form_bypass"><%=strCODIGO%></div>
	<br><div class="form_label">Grupo:</div><input name="DBVAR_STR_GRUPO" type="text"  style="width:120px" maxlength="80" value="<%=GetValue(objRS, "GRUPO")%>">
	<br><div class="form_label">Fornecedor:</div><input name="DBVAR_STR_FORNECEDOR" type="text"  style="width:150px" maxlength="80" value="<%=GetValue(objRS, "FORNECEDOR")%>">
	<br><div class="form_label">*Tipo:</div><select name="DBVAR_STR_TIPOô"  style="width:60px">
		  <option value="">[tipo]</option>
          <option value="ftp"		<%if GetValue(objRS, "TIPO") = "ftp" then%>selected<%end if%>>ftp</option>
          <option value="e-mail"	<%if GetValue(objRS, "TIPO") = "e-mail" then%>selected<%end if%>>e-mail</option>
          <option value="vnc"		<%if GetValue(objRS, "TIPO") = "vnc" then%>selected<%end if%>>vnc</option>
          <option value="csm" 		<%if GetValue(objRS, "TIPO") = "csm" then%>selected<%end if%>>csm</option>
          <option value="arest" 	<%if GetValue(objRS, "TIPO") = "arest" then%>selected<%end if%>>arest</option>
          <option value="wsys" 		<%if GetValue(objRS, "TIPO") = "wsys" then%>selected<%end if%>>wsys</option>
          <option value="odbc" 		<%if GetValue(objRS, "TIPO") = "odbc" then%>selected<%end if%>>odbc</option>
          <option value="telnet" 	<%if GetValue(objRS, "TIPO") = "telnet" then%>selected<%end if%>>telnet</option>
          <option value="painel" 	<%if GetValue(objRS, "TIPO") = "painel" then%>selected<%end if%>>painel</option>
          <option value="plesk" 	<%if GetValue(objRS, "TIPO") = "plesk" then%>selected<%end if%>>plesk</option>
          <option value="helpdesk"	<%if GetValue(objRS, "TIPO") = "helpdesk" then%>selected<%end if%>>helpdesk</option>
          <option value="adsl"		<%if GetValue(objRS, "TIPO") = "adsl" then%>selected<%end if%>>adsl</option>
          <option value="ssl"		<%if GetValue(objRS, "TIPO") = "ssl" then%>selected<%end if%>>ssl</option>
          <option value="msn"		<%if GetValue(objRS, "TIPO") = "msn" then%>selected<%end if%>>msn</option>
          <option value="icq"		<%if GetValue(objRS, "TIPO") = "icq" then%>selected<%end if%>>icq</option>
          <option value="skype"		<%if GetValue(objRS, "TIPO") = "skype" then%>selected<%end if%>>skype</option>
          <option value="orkut"		<%if GetValue(objRS, "TIPO") = "orkut" then%>selected<%end if%>>orkut</option>
          <option value="gazzag"	<%if GetValue(objRS, "TIPO") = "gazzag" then%>selected<%end if%>>gazzag</option>
          <option value="facebook"	<%if GetValue(objRS, "TIPO") = "facebook" then%>selected<%end if%>>facebook</option>
          <option value="twitter"	<%if GetValue(objRS, "TIPO") = "twitter" then%>selected<%end if%>>twitter</option>
          <option value="bank"		<%if GetValue(objRS, "TIPO") = "bank" then%>selected<%end if%>>bank</option>
          <option value="card"		<%if GetValue(objRS, "TIPO") = "card" then%>selected<%end if%>>card</option>
          <option value="db"		<%if GetValue(objRS, "TIPO") = "db" then%>selected<%end if%>>db</option>
          <option value="stat"		<%if GetValue(objRS, "TIPO") = "stat" then%>selected<%end if%>>stat</option>
          <option value="outros"	<%if GetValue(objRS, "TIPO") = "outros" then%>selected<%end if%>>outros</option>
        </select>
	<br><div class="form_label">Nome/Usr:</div><input name="DBVAR_STR_CONTA_USR" type="text" style="width:220px" maxlength="250" value="<%=GetValue(objRS, "CONTA_USR")%>">
	<br><div class="form_label">Senha:</div><input name="DBVAR_CRIPTO_CONTA_SENHA" type="password" style="width:100px" maxlength="50" value="<%=GetValue(objRS,"CONTA_SENHA")%>">
	<br><div class="form_label">Info Extra1:</div><input name="DBVAR_STR_CONTA_EXTRA1" type="text" style="width:250px" maxlength="50" value="<%=GetValue(objRS, "CONTA_EXTRA1")%>">
	<br><div class="form_label">Info Extra2:</div><input name="DBVAR_STR_CONTA_EXTRA2" type="text" style="width:250px" maxlength="50" value="<%=GetValue(objRS, "CONTA_EXTRA2")%>">
	<br><div class="form_label">Info Extra3:</div><input name="DBVAR_STR_CONTA_EXTRA3" type="text" style="width:250px" maxlength="50" value="<%=GetValue(objRS, "CONTA_EXTRA3")%>">
	<br><div class="form_label">Ender/URL:</div><input name="DBVAR_STR_ENDER_URL" type="text" style="width:200px" maxlength="250" value="<%=GetValue(objRS, "ENDER_URL")%>">
	<br><div class="form_label">Obs.:</div><textarea name="DBVAR_STR_OBS" rows="5" cols="60"><%=GetValue(objRS, "OBS")%></textarea>
	<br><div class="form_label">Ordem:</div><input name="DBVAR_NUM_ORDEM" type="text" style="width:30px" value="<%=GetValue(objRS, "ORDEM")%>">
	<br><div class="form_label">Status:</div> 
		<%
	    If GetValue(objRS,"DT_INATIVO") = "" Then
           Response.Write("<input type='radio' class='inputclean' name='DBVAR_DATE_DT_INATIVO' value='NULL' checked>Ativo")
           Response.Write("<input type='radio' class='inputclean' name='DBVAR_DATE_DT_INATIVO' value='" & PrepDataBrToUni(Date, False) & "'>Inativo")
        Else
           Response.Write("<input type='radio' class='inputclean' name='DBVAR_DATE_DT_INATIVO' value='NULL'>Ativo")
           Response.Write("<input type='radio' class='inputclean' name='DBVAR_DATE_DT_INATIVO' value='" & PrepDataBrToUni(Date, False) & "' checked>Inativo")
        End If
		%>
</form>
<%=athEndDialog("", "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
</body>
</html>
<%
		End If 
		FechaRecordSet objRS
		FechaDBConn objConn
	End If
%>
