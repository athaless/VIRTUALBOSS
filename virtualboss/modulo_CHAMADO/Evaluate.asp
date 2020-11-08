<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<%' VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_CHAMADO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

Dim strSQL, objRS, ObjConn, Cont
Dim strCODIGO, strCFG_TD
Dim strCOD_Chamado, strCOD_TodoList 
Dim strEvalNota,strEvalObs,strEvalUsr

strCODIGO = GetParam("var_chavereg")
strCFG_TD = "align='left' valign='top' nowrap"

AbreDBConn objConn, CFG_DB

strSQL =          "SELECT t1.cod_chamado "
strSQL = strSQL & "     , t1.cod_todolist "
strSQL = strSQL & "     , t2.TITULO "
strSQL = strSQL & "     , t2.sys_evaluate "
strSQL = strSQL & "     , t2.sys_evaluate_obs "
strSQL = strSQL & "     , t2.sys_evaluate_id_usuario "
strSQL = strSQL & "  FROM CH_CHAMADO t1, TL_TODOLIST t2 "
strSQL = strSQL & " WHERE t1.cod_todolist = t2.cod_todolist "
'strSQL = strSQL & "   AND t1.cod_chamado = " & strCODIGO
strSQL = strSQL & "   AND t2.cod_todolist = " & strCODIGO

Set objRS = objConn.Execute(strSQL)

If Not objRS.Eof Then
    strCOD_Chamado  = GetValue(objRS,"cod_chamado")
	strCOD_TodoList = GetValue(objRS,"cod_todolist") 
	strEvalNota		= GetValue(objRS,"sys_evaluate") 
	strEvalObs		= GetValue(objRS,"sys_evaluate_obs") 
	strEvalUsr		= GetValue(objRS,"sys_evaluate_id_usuario") 
end if
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
// INI Funções de ação dos botões -----------------------------------------------------------
function ok() 			{ document.form_evaluate.JSCRIPT_ACTION.value = "window.close()"; submeterForm(); }
function cancelar()		{ window.close(); /* parent.frames["vbTopFrame"].document.form_principal.submit(); */ }
function aplicar()	  	{ document.form_evaluate.DEFAULT_LOCATION.value = "Evaluate.asp?var_chavereg=<%=strCODIGO%>"; submeterForm(); }
function submeterForm() { document.form_evaluate.submit(); }
// FIM: Funções de ação dos botões ----------------------------------------------------------



function MM_preloadimg() { //v3.0
  var d=document; if(d.img){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadimg.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && document.getElementById) x=document.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function MM_callJS(jsStr) { //v2.0
  return eval(jsStr)
}

function choiceZeroTen(image) {
    imageName	= image.name;
    radical		= imageName.substring(0,imageName.indexOf('_'));
    tail		= imageName.substring(imageName.indexOf('_')+1,imageName.length);
    subAsk		= tail.substring(0,tail.indexOf('_'));
    numImg		= parseInt(tail.substring(tail.indexOf('_')+1,tail.length));
    for(i=1;i<numImg;i++)
        MM_swapImage(radical + '_' + subAsk + '_' + i,'','../img/button_yellow.gif',1);
    MM_swapImage(radical + '_' + subAsk + '_' + numImg,'','../img/button_down.gif',1);
    for(i=numImg+1;i<=10;i++)
        MM_swapImage(radical + '_' + subAsk + '_' + i,'','../img/button.gif',1);
    eval('document.form_evaluate.' + radical + '' + subAsk + '.value = "' + numImg + '"');
}


function choiceSet(image, content) {
    imageName = image.name;
    radical = imageName.substring(0,imageName.indexOf('_'));
    tail = imageName.substring(imageName.indexOf('_')+1,imageName.length);
    subAsk = tail.substring(0,tail.indexOf('_'));
    eval('document.form_evaluate.' + radical + '' + subAsk + '.value = "' + content + '"');
}

function checkUncheck(image) {
    imageName	= image.name;
    imageFile	= image.src.substring(image.src.indexOf('button'),image.src.length);
    imageExt	= imageFile.substring(imageFile.indexOf('.'),imageFile.length);
    imageFile	= imageFile.substring(0, imageFile.length-4);
    if(imageFile.indexOf('_down') > -1) 
	{
        MM_swapImage(imageName,'','../img/' + imageFile.substring(0,imageFile.length-5) + '' + imageExt,1);
        choiceSet(image, '');
        return false;
    }
    else MM_swapImage(imageName,'','../img/' + imageFile + '_down' + imageExt,1);
}

function xCheckUncheck(image, total, content) 
{
    imageName	= image.name;
    radical		= imageName.substring(0,imageName.indexOf('_'));
    tail		= imageName.substring(imageName.indexOf('_')+1,imageName.length);
    subAsk		= tail.substring(0,tail.indexOf('_'));
    imageFile	= image.src.substring(image.src.indexOf('button'),image.src.length);
    imageExt	= imageFile.substring(imageFile.indexOf('.'),imageFile.length);
    imageFile	= imageFile.substring(0, imageFile.length-4);
    if(imageFile.indexOf('_down') > -1)
      eval('document.' + radical + '' + subAsk.charAt(0) + '.value = ""');
    else {
        MM_swapImage(imageName,'','../img/' + imageFile + '_down' + imageExt,1);
        for(i=1;i<subAsk.substring(1,subAsk.length); i++) {
            MM_swapImage(radical + '_' + subAsk.charAt(0) + '' + i + '' + tail.substring(tail.indexOf('_'), tail.length),'','../img/' + imageFile + '' + imageExt,1);
        }
        for(i=parseInt(subAsk.substring(1,subAsk.length))+1; i<=total; i++) {
            MM_swapImage(radical + '_' + subAsk.charAt(0) + '' + i + tail.substring(tail.indexOf('_'), tail.length),'','../img/' + imageFile + '' + imageExt,1);
        }
    }
    eval('document.form_evaluate.' + radical + '' + subAsk.charAt(0) + '.value = "' + content + '"');
}
allRight = "";

function setFalseAllRight(alertString, alertValue) 
{
  allRight = false;
  if(alertValue) alert(alertString);
}
</script>
</head>
<body onLoad="MM_preloadimg('../img/button.gif','../img/button_down.gif','../img/button_yellow.gif')" link="#000000" vlink="#000000" alink="#000000">
<%=athBeginDialog(WMD_WIDTH, "Chamado/Tarefa - Avaliação")%>
<form name="form_evaluate" id="form_evaluate" action="evaluate_exec.asp" method="post">
  	<input type="hidden" name="JSCRIPT_ACTION"	 id="JSCRIPT_ACTION"	value="">
  	<input type="hidden" name="DEFAULT_LOCATION" id="DEFAULT_LOCATION"	value="">
  	<input type="hidden" name="var_chavereg" 	 id="var_chavereg"		value="<%=strCODIGO%>">
    <input type="hidden" name="var_obs_orig"	 id="var_obs_orig" 		value="<%=Replace(strEvalObs,"<ASLW_APOSTROFE>","'")%>">
    <input type="hidden" name="p11"				 id="p11" 				value="<%=strEvalNota%>"><!-- Preenchida por JavaScript com a nota dada //-->

	<div class="form_label">Chamado:</div><div class="form_bypass"><%=strCOD_Chamado & " - " & strCOD_TodoList %></div>

	<br><div class="form_label">Título:</div><div class="form_bypass"><%=GetValue(objRS,"TITULO")%></div>

	<br><div class="form_label">&nbsp;</div><div class="form_bypass" style="height:55px;">Como você avalia a conclusão deste chamado e/ou seu próprio
    <br>andamento? Sua avaliação e sugestões serão de grande ajuda
    <br>para melhoria de nossos serviços. Obrigado!</div>

	<br><div class="form_label">Avaliação:</div><img src='../img/Evaluate_Scale.gif' height="60">

	<br><div class="form_label">&nbsp;</div><div class="form_bypass" style="padding-top:5px;">
            <img class="mouseHand" onMouseDown="choiceZeroTen(this)" src="../img/button.gif" width="29" border="0" vspace="0" hspace="0" name="p1_1_10" id="p1_1_10">
            <img class="mouseHand" onMouseDown="choiceZeroTen(this)" src="../img/button.gif" width="29" border="0" vspace="0" hspace="1" name="p1_1_9"  id="p1_1_9">
            <img class="mouseHand" onMouseDown="choiceZeroTen(this)" src="../img/button.gif" width="29" border="0" vspace="0" hspace="1" name="p1_1_8"  id="p1_1_8">
            <img class="mouseHand" onMouseDown="choiceZeroTen(this)" src="../img/button.gif" width="29" border="0" vspace="0" hspace="1" name="p1_1_7"  id="p1_1_7">
            <img class="mouseHand" onMouseDown="choiceZeroTen(this)" src="../img/button.gif" width="29" border="0" vspace="0" hspace="1" name="p1_1_6"  id="p1_1_6">
            <img class="mouseHand" onMouseDown="choiceZeroTen(this)" src="../img/button.gif" width="29" border="0" vspace="0" hspace="1" name="p1_1_5"  id="p1_1_5">
            <img class="mouseHand" onMouseDown="choiceZeroTen(this)" src="../img/button.gif" width="29" border="0" vspace="0" hspace="1" name="p1_1_4"  id="p1_1_4">
            <img class="mouseHand" onMouseDown="choiceZeroTen(this)" src="../img/button.gif" width="29" border="0" vspace="0" hspace="1" name="p1_1_3"  id="p1_1_3">
            <img class="mouseHand" onMouseDown="choiceZeroTen(this)" src="../img/button.gif" width="29" border="0" vspace="0" hspace="0" name="p1_1_2"  id="p1_1_2">
            <img class="mouseHand" onMouseDown="choiceZeroTen(this)" src="../img/button.gif" width="29" border="0" vspace="0" hspace="0" name="p1_1_1"  id="p1_1_1">
    </div>
	<%
		'Como histórico, no campo [sys_evaluate_obs], armazenamos o LOG - data/hora, user, nota e observação anterior). 
		'Nesta DIALOG aqui [Evaluate.asp] devemos tratar o valor do campo observação para mostar somente a última observação.
		strEvalObs = Replace(strEvalObs,"<ASLW_APOSTROFE>","'")
		If strEvalObs<>"" then 
			strEvalObs = Mid(strEvalObs,1,instr(strEvalObs,"<!--LOG_EVALUATE ")-1)
		End if
	%>
	<br><div class="form_label">Sugestão / Observação:</div><textarea name="var_obs" id="var_obs" style="width:330px; height:80px;"><%=strEvalObs%></textarea>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
<script type="application/javascript" language="javascript">
<% 
  'Se já tinha nota gravada deve setar (desenhar) os botões até o valor correspondente
  if (strEvalNota > 0) then 
	response.write ("choiceZeroTen(document.getElementById('p1_1_" & strEvalNota & "'));")
  end if	
%>
</script>
</body>
</html>
<%
FechaRecordSet objRS
FechaDBConn objConn
%>