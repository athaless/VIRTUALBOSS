<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_USUARIO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
    Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
    Const auxAVISO  = "<span class='texto_ajuda'></span>"

	Dim strSQL, objRS, objRSAuxChamado, ObjConn
	Dim strCODIGO, strData, strRESP, arrESTADOS, arrNOMES, i, boolCOD_COOKIE
	Dim boolAuxChamado
	Dim strCODUSER, strIDUSER, strNOME, strCLIREF
	
	strCODIGO = GetParam("var_chavereg")

	if strCODIGO<>"" then
		AbreDBConn objConn, CFG_DB 
		
		strSql = " SELECT COD_USUARIO, NOME, ID_USUARIO, ENT_CLIENTE_REF FROM USUARIO WHERE COD_USUARIO = " & strCODIGO
		Set objRS = objConn.Execute(strSQL)
		If Not objRS.Eof Then
			strCODUSER = GetValue(objRS,"COD_USUARIO")
			strIDUSER  = GetValue(objRS,"ID_USUARIO")
			strNOME    = GetValue(objRS,"NOME")
			strCLIREF  = GetValue(objRS,"ENT_CLIENTE_REF")

			'Passamos a trazer apenas os clientes que têm chamado (não fechados a 365 dias), pois trazer todos estava deixando a 
			'tela lenta. By Lumertz - 19/03/2013. Solicitado por Aless.
			'Para voltar a trazer todos os clientes, basta tirar a cláusula WHERE da consulta abaixo		
			'Comentado "WHERE" 19/09/2014 - A pedido da Tati (by Aless)
			 strSQL = "SELECT " 
			 strSQL = strSQL & " DISTINCT T2.COD_CLIENTE                                                                                   "
			 strSQL = strSQL & ",COALESCE(T2.NOME_COMERCIAL, T2.NOME_FANTASIA) AS NOME_COMERCIAL                                           "
			 strSQL = strSQL & ",CASE                                                                                                      "
			 strSQL = strSQL & "   WHEN (COALESCE((SELECT COUNT(T1.COD_CLI) FROM CH_CHAMADO T1 WHERE T1.COD_CLI = T2.COD_CLIENTE), 0) > 0) "
			 strSQL = strSQL & "     THEN 'T'                                                                                              "
			 strSQL = strSQL & "     ELSE 'F'                                                                                              "
			 strSQL = strSQL & " END AS TEM_CHAMADOS                                                                                       "
			 strSQL = strSQL & "FROM ENT_CLIENTE T2                                                                                        "
'			 strSQL = strSQL & "WHERE (COALESCE((SELECT COUNT(T1.COD_CLI) FROM CH_CHAMADO T1 WHERE T1.COD_CLI = T2.COD_CLIENTE AND SITUACAO NOT LIKE 'FECHADO' AND DATEDIFF(NOW(),SYS_DTT_INS) < 365), 0) > 0)   "
			 strSQL = strSQL & "WHERE (COALESCE((SELECT COUNT(T1.COD_CLI) FROM CH_CHAMADO T1 WHERE T1.COD_CLI = T2.COD_CLIENTE), 0) > 0)   "
			  strSQL = strSQL & "AND (COALESCE((SELECT COUNT(T1.CODIGO) FROM USUARIO T1 WHERE T1.CODIGO = T2.COD_CLIENTE AND T1.DT_INATIVO IS NULL), 0) > 0)   "
			 strSQL = strSQL & "ORDER BY 3 DESC,2 "		
			Set objRSAuxChamado = objConn.Execute(strSQL) 	
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok()       { document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() { BuscaCods(); document.form_update.submit(); }
//****** Funções de ação dos botões - Fim ******

function BuscaCods() 
{
 var codigos = '';
 var i = 0;

 while ( (eval("document.forms[0].msguid_" + i) != null) )
  {
    if (eval("document.forms[0].msguid_" + i) != null) 
	{
      if (eval("document.forms[0].msguid_" + i).checked) 
       {
	    if (codigos != '') { codigos = codigos + ';' + eval("document.forms[0].msguid_" + i).value; }
	    else { codigos = eval("document.forms[0].msguid_" + i).value; }
      }
    }
    i = i + 1;
  }
 document.forms[0].var_cod_cli_chamado_filtro.value = codigos;
}

function MarcaCods() {
 var i,j; 
 var codigos	 = '';
 var strAux		 = document.forms[0].var_cod_cli_chamado_filtro.value;
 var strToSearch = "";
 var arrCods = new Array();
 arrCods = strAux.split(";");

 i=0;
 while ( (eval("document.forms[0].msguid_" + i) != null) )
  {
    if (eval("document.forms[0].msguid_" + i) != null) 
	{
	   strToSearch = eval("document.forms[0].msguid_" + i).value;
	   for(j=0; j<arrCods.length; j++){
		 if(arrCods[j] == strToSearch){	     
		   eval("document.forms[0].msguid_" + i).checked = true;
		   break;
		 }
	   }
    }
    i = i + 1;
  }
}

function MarcaDesmarcaTodos(prBoolMarcar){
 var i = 0; 

 if(prBoolMarcar == null) { prBoolMarcar = false; }  
   
 while((eval("document.forms[0].msguid_" + i) != null))
 {
   eval("document.forms[0].msguid_" + i).checked = prBoolMarcar;
   i = i + 1;
 } 
}

</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Usuário - Capturar Chamados") %>
  <form name="form_update" action="UpdateVerChamados_exec.asp" method="post">
  <input type="hidden" name="var_chavereg"       value="<%=strCODIGO%>">
  <input type="hidden" name="JSCRIPT_ACTION"     value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
  <input type="hidden" name="var_apelido2"       value="<%=strIDUSER%>">
  <input type="hidden" name="DEFAULT_LOCATION" value='UpdateVerChamados.asp?var_chavereg=<%=strCODIGO%>'>
  <input type="hidden" name="var_retorno"      value="UpdateVerChamados.asp?var_chavereg=<%=strCODIGO%>">
		<div class='form_label'>Cod:</div><div class="form_bypass"><%=strCODUSER%></div>
	<br><div class='form_label'>Nome:</div><div class="form_bypass"><%=strNOME%></div>
  	<br><div class='form_label'>ID Usuário:</div><div class="form_bypass"><%=strIDUSER%></div>
    <br><div class='form_label'>Capturar de:</div><div class="form_label" style="background:#E8EEFA; text-align:left; overflow:scroll; white-space:nowrap; width:340px; height:360px; padding-left:5px; margin-left:0px;"> 
                                                            <%
															  boolAuxChamado = true  
                                                              i = 0                                                            
                                                              While Not objRSAuxChamado.Eof
															    if((i = 0) and (GetValue(objRSAuxChamado, "TEM_CHAMADOS") = "T")) then
																  Response.Write("<br>&nbsp;<b>[Clientes que já realizaram chamado]</b></br></br>")
																else
															      if((boolAuxChamado = true) and (GetValue(objRSAuxChamado, "TEM_CHAMADOS") = "F")) then
																    Response.Write("</br></br></br>&nbsp;<b>Clientes que ainda não realizaram chamados</b></br></br>")
																	boolAuxChamado = false
																  end if
																end if  
                                                            %>
                                                                &nbsp;&nbsp;<input style="border:0px; vertical-align:middle"; type='checkbox' 
                                                                name='msguid_<%Response.Write(i)%>' id='msguid_<%Response.Write(i)%>' 
                                                                value='<%=GetValue(objRSAuxChamado, "COD_CLIENTE")%>'/>&nbsp;<%=ATHFormataTamLeft(GetValue(objRSAuxChamado, "COD_CLIENTE"), 5, "0") & " - " & mid(GetValue(objRSAuxChamado, "NOME_COMERCIAL"),1,40) & "..." %><br />
                                                            <%  
																i = i+1
                                                                'objRSAuxChamado.MoveNext
																athMoveNext objRSAuxChamado, ContFlush, CFG_FLUSH_LIMIT
                                                              Wend
                                                            %>
                                                           </div></br>
	<!--														   
    <br><div class='form_label'></div><a  title="Marcar todos" href="javascript:MarcaDesmarcaTodos(true);"><img src="../img/true.png" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
	                                  <a title="Desmarcar todos" href="javascript:MarcaDesmarcaTodos(false);"><img src="../img/false.png" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a></br> 
    //-->

    <br><div class='form_label'></div><input name='var_cod_cli_chamado_filtro' type='hidden' value='<%=strCLIREF%>'>
  </form>
<%
   response.write athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")
%>
 <script language="javascript" type="text/javascript">MarcaCods();</script>
</body>
</html>
<%
			FechaRecordSet objRSAuxChamado
		End If
		FechaRecordSet objRS 
		FechaDBConn objConn
	End If 
%>