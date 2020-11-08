<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_PONTO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 
 Dim strSQL, objRS, objConn, strHoraIn, strSaida, strAction, strTipo, strHora1, strMinuto1
 Dim strCod_Ponto, strCodEmpresa, i, strHorarioIn, strMinIn, strDia, strMes, strAno, auxAVISO
 
 AbreDBConn ObjConn, CFG_DB

 strSQL = " SELECT COD_PONTO, ID_USUARIO, DATA_DIA, DATA_MES, DATA_ANO " &_
 		  "      , COD_EMPRESA, HORA_IN, HORA_OUT, OBS, STATUS" & _
		  " FROM PT_PONTO" & _
		  " WHERE ID_USUARIO = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' " &_
		  " AND DATA_DIA = " & Day(Date()) & _ 
		  " AND DATA_MES = " & Month(Date()) & _ 
		  " AND DATA_ANO = " & Year(Date()) &_
		  " ORDER BY DATA_DIA, DATA_MES, DATA_ANO "

 set objRS = ObjConn.Execute(strSQL)
 
strSaida = false
while not objRS.EOF and Not strSaida
 if GetValue(objRS, "HORA_OUT") <> "" then
  objRS.MoveNext
 else
  strSaida = true
  strHorarioIn  = GetValue(objRS, "HORA_IN")
  strCOD_PONTO  = GetValue(objRS, "COD_PONTO")
  strCodEmpresa = GetValue(objRS, "COD_EMPRESA")
 end if
wend

if strCodEmpresa = "" then strCodEmpresa = Request.Cookies("VBOSS")("DEFAULT_EMP")

strHora1 = Hour(Now())
if strHora1 < 10 then strHora1 = "0" & Hour(Now())
'strMinuto1 = Fix(Minute(Now())/5)*5
strMinuto1 = Minute(Now())
if strMinuto1 < 10 then strMinuto1 = "0" & strMinuto1

if strHorarioIn = "" then
   strAction = "insert_exec.asp"
   strTipo   = "Entrada"
   i = 1 
   strDia = Day(Date())
   strMes = Month(Date())
   strAno = Year(Date())
else
   strAction = "update_exec.asp"
   strTipo   = "Saída"
   i = 2
   strHoraIn = Hour(strHorarioIn)
   if strHoraIn < 10 then strHoraIn = "0" & strHoraIn
   strMinIn = Minute(strHorarioIn)
   if strMinIn < 10 then strMinIn = "0" & strMinIn
   strDia = GetValue(objRS, "DATA_DIA")
   strMes = GetValue(objRS, "DATA_MES")
   strAno = GetValue(objRS, "DATA_ANO")
end if
FechaRecordSet objRS

auxAVISO = "dlg_pwd.gif:<a href='loginadmin.asp?var_chavereg=" & strCod_Ponto & "&var_location=" & strAction & "' style='cursor:pointer'>Alterações efetuando login de Administrador</>"

%>
<html>
<head>
<title>vBoss</title>
<meta http-equiv="Content-Type" content="text/html;">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script type="text/javascript" language="JavaScript">
function ok()       { document.form_ponto.DEFAULT_LOCATION.value=""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_ponto.JSCRIPT_ACTION.value="";   submeterForm(); }
function submeterForm() {
  document.form_ponto.submit();
}

</script>
</head>
<body onLoad="document.form_ponto.var_obs.focus();">
<%=athBeginDialog(WMD_WIDTH, "Reg. Horas - Inserção (padrão)")%> 
<form name="form_ponto" action="<%=strAction%>" method="get">
	<input type="hidden" name="var_chavereg"     value="<%=strCod_Ponto%>">
	<input type="hidden" name="var_dt_dia_old"   value="<%=strDia%>">
	<input type="hidden" name="var_dt_mes_old"   value="<%=strMes%>">
	<input type="hidden" name="var_dt_ano_old"   value="<%=strAno%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='ins_upd.asp'>
	<% if strTipo = "Saída" then %>
	  <input type="hidden" name="var_empresa_old" value="<%=strCodEmpresa%>">
	  <input type="hidden" name="var_hh1" value="<%=strHoraIn%>">
	  <input type="hidden" name="var_mm1" value="<%=strMinIn%>">
	<% end if %>
	<div class="form_label">Usuário:</div><% 
		  'Se for ADMIM ou SU, deixa marcar ponto pros outros
		   If ( (Request.Cookies("VBOSS")("GRUPO_USUARIO") = "SU") or (Request.Cookies("VBOSS")("GRUPO_USUARIO") = "ADMIN") ) Then 
		%><select name="var_id_usuario" class="texto_chamada_peq" style="width:100px" >
			 <option value="Todos" <%if GetParam("selNome") = "Todos" then response.write("selected")%>>[usuários]</option>
			 <%=montaCombo("STR", "SELECT Distinct(ID_USUARIO) FROM USUARIO WHERE DT_INATIVO is NULL", "ID_USUARIO", "ID_USUARIO", Request.Cookies("VBOSS")("ID_USUARIO"))%> 
		  </select><% else  %><input type='text' name='var_id_usuario' class="texto_chamada_peq" 
		   value='<%=Request.Cookies("VBOSS")("ID_USUARIO")%>' readonly>
		<% end if %>
	<br><div class="form_label">Empresa:</div><select name="var_empresa" class="texto_chamada_peq" style="width: 180px" onChange="document.form_ponto.var_hh<%=i%>.focus();">
			  <%=montaCombo("STR", "SELECT SIGLA_PONTO, NOME_COMERCIAL FROM ENT_CLIENTE WHERE DT_INATIVO IS NULL AND SIGLA_PONTO IS NOT NULL ORDER BY NOME_COMERCIAL", "SIGLA_PONTO", "NOME_COMERCIAL", strCodEmpresa)%> 
			  <option value="EXT">Extra/Outros</option>
			</select>
	<br><div class="form_label">Data:</div><input type="text" name="var_dt_dia" size="2" maxlength="2" style="width:20px;" readonly onKeyUp="return autoTab(this, 2, event);" value="<%=strDia%>"> 
			&nbsp;<b>/</b> <input type="text" name="var_dt_mes" readonly style="width:20px;"  maxlength="2" onKeyUp="return autoTab(this, 2, event);" value="<%=strMes%>">
			&nbsp;<b>/</b> <input type="text" name="var_dt_ano" readonly style="width:40px;"  maxlength="4" onKeyUp="return autoTab(this, 4, event);" value="<%=strAno%>"> 
	<br><div class="form_label">Status:</div><select name="var_status" class="texto_chamada_peq" style="width: 111px" onChange="document.form_ponto.var_hh1.focus();">
			  <option value="REALIZADO" selected>REALIZADO</option>
			</select>
	<br><div class="form_label"><%=strTipo%>:</div><input type="text" readonly name="var_hh<%=i%>" style="width:20px;" maxlength="2" value="<%=strHora1%>"><b>:</b><input type="text" readonly name="var_mm<%=i%>" style="width:20px;" value="<%=strMinuto1%>">&nbsp;:00&nbsp;&nbsp;			  
	<br><div class="form_label">Observação:</div><textarea name="var_obs" rows="4" style="width:180px;"></textarea>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>