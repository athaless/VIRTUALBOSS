<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
	Dim objConn, strSQL, objRS, strEntCliRef
	
	AbreDBConn objConn, CFG_DB 
	
    'Buscamos no cadastro de usuario se deverá visualizar chamados de clientes especificos      
	'strSQL = "SELECT ENT_CLIENTE_REF FROM USUARIO WHERE ID_USUARIO='" & Request.Cookies("VBOSS")("ID_USUARIO") & "'"
	'Set objRS = objConn.Execute(strSQL)
	'strEntCliRef = GetValue(objRS, "ENT_CLIENTE_REF")
	'FechaRecordSet objRS

	'Monta o SQL que será usado no combo
	'if(strEntCliRef <> "") then
 	'	strEntCliRef = Replace(strEntCliRef,";",",") 'trocamos o ponto-virgula por virgula para utilizar direto no sql	
	'	strSQL =          " SELECT distinct T2.NOME_COMERCIAL AS CLIENTE"
	'	strSQL = strSQL & "   FROM CH_CHAMADO T1, ENT_CLIENTE T2 "
	'	strSQL = strSQL & "  WHERE T1.COD_CLI = T2.COD_CLIENTE "
	'	strSQL = strSQL & "   AND T1.COD_CLI IN (" & strEntCliRef & ") "
	'	strSQL = strSQL & "  ORDER BY T2 .NOME_COMERCIAL "					  
    'else
		strSQL =          " SELECT distinct T2.NOME_COMERCIAL AS CLIENTE, T2.COD_CLIENTE"
		strSQL = strSQL & "   FROM CH_CHAMADO T1, ENT_CLIENTE T2 "
		strSQL = strSQL & "  WHERE T1.COD_CLI = T2.COD_CLIENTE "
		strSQL = strSQL & "  ORDER BY T2 .NOME_COMERCIAL "
	'end if	
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script type="text/javascript" language="JavaScript">
function ExecAcao(pr_form, pr_input) {
	var form = eval('document.' + pr_form + '.' + pr_input);
	if (form.value=='INSERIR') { parent.frames["vbMainFrame"].document.location.href = "Insert.asp"; }
	form.value='';
}


function ajax_BuscaExtras() {
  var auxCodCli, auxSit, auxUGrp, strReturnValue;
  var objAjax=null;

  auxCodCli = document.getElementById("form_principal").var_cliente.value;
  auxSit    = document.getElementById("form_principal").var_situacao.value;
  auxUGrp   = "<%=Request.Cookies("VBOSS")("GRUPO_USUARIO")%>";

  //alert("Debug: ajax_returnextra.asp?var_cod_cli=" + auxCodCli + "&var_situacao=" + auxSit + "&var_usrgrp=" + auxUGrp);
  //document.getElementById("ajax_comboextra").innerHTML = "<img src='../img/anim_preload.gif' style='height:15px; border:0px; vertical-align:middle;'>";
  objAjax = createAjax();
  objAjax.onreadystatechange = function() {
		if(objAjax.readyState == 4) {
			if(objAjax.status == 200) {
				//strReturnValue = objAjax.responseText.replace(/^\s*|\s*$/,"");
				strReturnValue = objAjax.responseText
				document.getElementById("ajax_comboextra").innerHTML = strReturnValue;
			} else {
				alert("Erro no processamento da página: " + objAjax.status + "\n\n" + objAjax.responseText);
			}
		}
  }
  
  //objAjax.open("GET","ajax_returnextra.asp?var_cod_cli=" + auxCodCli + "&var_situacao=" + auxSit + "&var_usrgrp=" + auxUGrp,true);
  //objAjax.send();

  objAjax.open("POST","ajax_returnextra.asp?",true);
  objAjax.setRequestHeader("Content-type","application/x-www-form-urlencoded");
  objAjax.send("var_cod_cli=" + auxCodCli + "&var_situacao=" + auxSit + "&var_usrgrp=" + auxUGrp);
}

</script>
<script type="text/javascript" language="javascript" src="../_scripts/checkbox.js"></script>
</head>
<body onLoad="javascript:init();document.form_principal.submit();">
<table class="top_table" style="width:100%; height:58px; border:0px; margin:0px; padding:0px; vertical-align:top; border-collapse:collapse;  ">
<tr> 
	<td width="1%" class="top_menu" style="background-image:url(../img/Menu_TopBgLeft.jpg); vertical-align:top; padding:10px 0px 0px 10px;  border-collapse:collapse;">
	    <b>Chamado</b>
		<%=montaMenuCombo("form_acoes","selNome","width:100px","ExecAcao(this.form.name,this.name);","INSERIR:INSERIR")%>
	</td>
	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
		<div class="form_line">
			<form name="form_principal" id="form_principal" method="get" action="<%=CFG_MAIN_GRID%>" target="vbMainFrame">
                <div class="form_label_nowidth">Cód.:</div><input name="var_cod_chamado" id="var_cod_chamado" type="text" class="edtext" style="width:35px;" maxlength="10" title="Cód. Chamado" alt="Cód. Chamado">
				<div class="form_label_nowidth">.</div><input name="var_cod_todolist" id="var_cod_todolist" type="text" class="edtext" style="width:35px;" maxlength="10" title="Cód. ToDo" alt="Cód. ToDo">
				<div class="form_label_nowidth">Título:</div><input name="var_titulo" id="var_titulo" type="text" class="edtext" style="width:80px;" maxlength="255">		
				<% If Request.Cookies("VBOSS")("GRUPO_USUARIO") <> "CLIENTE" Then %>
				<!--<div class="form_label_nowidth"></div><input name="var_ent_ref_cli" type="hidden" value="<%'=strEntCliRef%>">  enviamos os códigos dos clientes que o user pode ver chamado -->
				<select name='var_cliente' id='var_cliente' class='edtext_combo' style='width:120px;' onChange="javascript:ajax_BuscaExtras(); return false;">
					<option value=''>[cliente]</option>
						<%
						Set objRS = objConn.Execute(strSQL)
						
						Do While Not objRS.Eof
							If (GetValue(objRS,"CLIENTE") <> "") Then 
							  'Response.Write("<option value='" & UCase(GetValue(objRS, "CLIENTE")) & "'>")
							  Response.Write("<option value='" & GetValue(objRS, "COD_CLIENTE") & "'>")
							  Response.Write( GetValue(objRS, "CLIENTE") )
							  Response.Write("</option>")
							End If  
							objRS.MoveNext
						Loop
						FechaRecordSet objRS
						%>
				</select>
				<% End If %>
				<select name='var_solicitante' id='var_solicitante' class='edtext_combo' style='width:100px;'>
					<option value='' selected>[solicitante]</option>
					<% If Request.Cookies("VBOSS")("GRUPO_USUARIO") <> "CLIENTE" Then %>
						<%=montaCombo("STR","SELECT DISTINCT SYS_ID_USUARIO_INS FROM CH_CHAMADO ORDER BY SYS_ID_USUARIO_INS ", "SYS_ID_USUARIO_INS", "SYS_ID_USUARIO_INS", "") %>
					<% Else %>
						<%=montaCombo("STR","SELECT ID_USUARIO FROM USUARIO WHERE CODIGO = " & Request.Cookies("VBOSS")("ENTIDADE_CODIGO") & " AND TIPO = 'ENT_CLIENTE' ORDER BY ID_USUARIO ", "ID_USUARIO", "ID_USUARIO", "") %>
					<% End If %>
				</select>
				<select name='var_situacao' id='var_situacao' class='edtext_combo' style='width:100px;' onChange="javascript:ajax_BuscaExtras(); return false;">
					<option value=''>[situação]</option>
					<option value='ABERTO'>Aberto</option>
					<option value='EXECUTANDO'>Executando</option>
					<option value='ESPERA'>Em Espera</option>
					<option value='FECHADO'>Fechado</option>
					<option value='_ABERTO'>Não aberto</option>
					<option value='_EXECUTANDO'>Não Executando</option>
					<option value='_ESPERA'>Não Em Espera</option>
					<option value='_FECHADO' selected>Não Fechado</option>
				</select>
				<select name='var_cod_categoria' id='var_cod_categoria' class='edtext_combo' style='width:90px;'>
					<option value='' selected>[categoria]</option>
					<%=montaCombo("STR","SELECT COD_CATEGORIA, NOME FROM CH_CATEGORIA ORDER BY NOME ", "COD_CATEGORIA", "NOME", "") %>
				</select>
				<div id="ajax_comboextra" name="ajax_comboextra" style="display:inline-block; ">
				<select name='var_extra' id='var_extra' class='edtext_combo' style='width:120px;'>
					<option value='' selected>[extra/evento]</option>
					<% 
						If Request.Cookies("VBOSS")("GRUPO_USUARIO") <> "CLIENTE" Then 
							'Originalmente mostravapara users não clientes, todos os extras distintos juntos sem divisão por entidade
							'response.write montaCombo("STR","SELECT DISTINCT EXTRA FROM CH_CHAMADO WHERE EXTRA is NOT NULL ORDER BY EXTRA ", "EXTRA", "EXTRA", "") 

							Dim StrEMPRESAOld, StrEMPRESANew

							StrEMPRESAOld = ""
							StrEMPRESANew = ""
							strSQL = "SELECT DISTINCT CC.EXTRA " &_
									 "      ,ET.COD_CLIENTE " &_
									 "      ,ET.NOME_COMERCIAL " &_
									 "  FROM CH_CHAMADO CC,USUARIO US, ENT_CLIENTE ET " &_
									 " WHERE US.TIPO = 'ENT_CLIENTE' " &_
									 "   AND US.CODIGO = ET.COD_CLIENTE " &_
									 "   AND US.ID_USUARIO = CC.SYS_ID_USUARIO_INS " &_
									 "   AND CC.EXTRA NOT LIKE '' " &_
									 "   AND CC.SITUACAO <> 'FECHADO' " &_
									 " ORDER BY ET.NOME_COMERCIAL, CC.EXTRA " 

							Set objRS = objConn.Execute(strSQL)
							Do While Not objRS.Eof
							  StrEMPRESANew = GetValue(objRS,"COD_CLIENTE")							
							  if StrEMPRESAOld <> StrEMPRESANew Then
								 if StrEMPRESAOld <> "" then
								   Response.write("</optgroup>")
								 End If  
								 Response.write("<optgroup label='" & GetValue(objRS,"NOME_COMERCIAL") & "." & StrEMPRESANew & "'>")
								 StrEMPRESAOld = StrEMPRESANew
							  End If		  
							  Response.Write("<option value='" & GetValue(objRS, "EXTRA") & "'>" & GetValue(objRS, "EXTRA") & "</option>" & vbnewline)
							  objRS.MoveNext
							Loop
							FechaRecordSet objRS
						Else 
							strSQL = "SELECT DISTINCT CC.EXTRA " &_
									 "  FROM CH_CHAMADO CC,USUARIO US  " &_
									 " WHERE US.CODIGO = " & Request.Cookies("VBOSS")("ENTIDADE_CODIGO") &_
									 "   AND US.TIPO = 'ENT_CLIENTE'  " &_
									 "   AND US.ID_USUARIO = CC.SYS_ID_USUARIO_INS  " &_
									 "   AND CC.EXTRA NOT LIKE ''  " &_
									 " ORDER BY EXTRA "
							response.write montaCombo("STR",strSQL, "EXTRA", "EXTRA", "") 
						End If 
					%>
				</select>
				</div>
				<!-- Para diminuir ou eliminar a ocorrência de cache passamso um parâmetro DUMMY com um número diferente 
				a cada execução. Isso força o navegador a interpretar como um request diferente a página,m evitando cache - by Aless 06/10/10 -->
				<input type='hidden' id='rndrequest' name='rndrequest' value=''>
				<div onClick="document.form_principal.rndrequest.value=(new Date()).valueOf(); document.form_principal.submit();" class="btsearch"></div>
			</form>
	   </div>
	</td>
   
</tr>
</table>
</body>
</html>
<%
	FechaDBConn objConn
%>