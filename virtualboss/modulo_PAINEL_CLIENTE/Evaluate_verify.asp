<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<%' VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_CHAMADO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
Const WMD_WIDTH = 600 '520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
Const auxAVISO  = "<span class='texto_ajuda'><a href='Evaluate_verify.asp'>Clique aqui para </b>ATUALIZAR</b></a></span>"
Const QTDE_DIAS = 365 'Quantidade de "dias atrás" pra buscar chamados fechados e avaliados

Dim strSQL, objRS, ObjConn, Cont
Dim strCODIGO, strCOD_Chamado, strCOD_TodoList 
Dim strEvalNota,strEvalObs,strEvalUsr

strCODIGO = GetParam("var_chavereg")

AbreDBConn objConn, CFG_DB

'Pega OS chamados FECHADOS, do CARA LOGADO e que ainda não tem AVALIAÇÂO
'  obs.: para não trazer mutis chamados antigos aidna nãoi avaliados (antes dessa roptina ter sido criada) 
'  resolvi colocar a consideração de tempo
strSQL =          "SELECT t1.cod_chamado, t1.cod_todolist, t2.TITULO "
strSQL = strSQL & "     , t1.sys_id_usuario_ins , t2.id_responsavel " 'apenas pra debug
strSQL = strSQL & "     , DATEDIFF(now(),t1.sys_dtt_ins) " 'apenas pra debug
strSQL = strSQL & "  FROM CH_CHAMADO t1, TL_TODOLIST t2 "
strSQL = strSQL & " WHERE t1.cod_todolist = t2.cod_todolist "
strSQL = strSQL & "   and t2.situacao like 'FECHADO' "
strSQL = strSQL & "   and ( (t2.sys_evaluate is NULL) or (t2.sys_evaluate=0)) "
strSQL = strSQL & "   and t1.sys_id_usuario_ins like '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' "
strSQL = strSQL & "   and DATEDIFF(now(),t1.sys_dtt_ins) < " & QTDE_DIAS  'pega somente os do último ano
strSQL = strSQL & "   and YEAR(t1.sys_dtt_ins) >= 2017 " 'considera elementos apenas a partir 2017 (que foi quando essa feature de avaliação foi implementada

Set objRS = objConn.Execute(strSQL)
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
function cancelar() { 
 window.parent.document.getElementById('vboss_frVerifyEvaluate').height = '0px';  
 // window.close();
}
</script>
</head>
<body onLoad="MM_preloadimg('../img/button.gif','../img/button_down.gif','../img/button_yellow.gif')" link="#000000" vlink="#000000" alink="#000000">
<%=athBeginDialog(WMD_WIDTH, "Chamado/Tarefa - verificando avaliações...")%>
	<div style="line-height:16px; font-size:12px;"> 
      Chamados FECHADOS disponíveis para sua avaliação. <br><br>
      Sinta-se à vontade para avaliá-los neste momento, lembrando que chamados fechados em até 5<br>
      dias podem ter suas avaliações alteradas normalmente. <br><br>
      <div style="text-align:right; width:100%"><B>Obrigado!&nbsp;&nbsp;&nbsp;</B></div>
	</div><br>
	<div style="width:540px; height:200px; overflow:scroll;"> 
    <table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
      <thead>
        <tr>
          <th width="1%"></th>
          <th width="1%"></th>
          <th class="sortable-numeric">Cod</th>
          <th class="sortable">TÍtulo</th>
        </tr>
       </thead>
       <tbody style="text-align:left;">
       <%
	    Cont = 0
	    while not objRS.EOF  
	   %>
        <tr>
          <td align="center" valign="top">
              <% Response.Write(MontaLinkPopup("../virtualboss/modulo_CHAMADO","Evaluate.asp",GetValue(objRS,"cod_todolist"),"IconAction_EVALUATE.gif","Avaliar","640", "480", "yes")) %>
          </td>
          <td align="center" valign="top">
			  <% Response.Write(MontaLinkPopup("../virtualboss/modulo_CHAMADO","DetailHistorico.asp",GetValue(objRS,"COD_TODOLIST"),"IconAction_DETAIL.gif","VISUALIZAR","640", "480", "yes")) %>
          </td>
          <td align="center" valign="top" nowrap><%=GetValue(objRS,"cod_chamado") & "-" & GetValue(objRS,"cod_todolist") %></td>
          <td align="center" valign="top"><%=GetValue(objRS,"TITULO") %></td>
        </tr>
       <%
            athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
		    Cont = Cont + 1
        wend 
       %>
       </tbody>
    </table>
<%=athEndDialog(auxAVISO, "", "", "../img/butxp_cancelar.gif", "cancelar();", "", "") %>
</body>
</html>
<%
FechaRecordSet objRS
FechaDBConn objConn
If Cont <= 0 then
	Response.Write("<script language='javascript' type='text/javascript'>")
	Response.Write("cancelar();")
	Response.Write("</script>")
end If
%>