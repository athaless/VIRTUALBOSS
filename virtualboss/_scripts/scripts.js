<script language="JavaScript">
<!--
var winpopup_vboss=null;
var isNN = (navigator.appName.indexOf("Netscape")!=-1);


function createAjax(){
	var xmlHttp=null;
	// Firefox, Opera 8.0+, Safari 
	try{ 
		xmlHttp=new XMLHttpRequest(); 
	}
	// Internet Explorer
	catch(e){
		try{
	   		xmlHttp=new ActiveXObject("Msxml2.XMLHTTP"); 
		}
	   	catch(e){
			xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
		}
	}
	return(xmlHttp);
}


function AbreJanelaPAGE(prpage, prwidth, prheight) 
{ 
  var auxstr;
  auxstr  = 'width=' + prwidth;
  auxstr  = auxstr + ',height=' + prheight;
  auxstr  = auxstr + ',top=30,left=30,scrollbars=1,resizable=yes';
  if (winpopup_vboss != null) { winpopup_vboss.close(); }
  winpopup_vboss = window.open(prpage, '', auxstr);
}

function AbreJanelaPAGENew(prpage, prwidth, prheight, prscroll, prnewwindow) 
{ 
  var auxstr;
  auxstr  = 'width=' + prwidth;
  auxstr  = auxstr + ',height=' + prheight;
  auxstr  = auxstr + ',top=30,left=30,scrollbars=' + prscroll + ',resizable=yes';

  if (winpopup_vboss != null) {	winpopup_vboss.close();	}
  if (prnewwindow == 'no') { winpopup_vboss = window.open(prpage, 'VBOSS_PAGE_DETAIL', auxstr); }
  else { winpopup_vboss = window.open(prpage, '', auxstr); }
}


// -------------------------------------------------------------------------------
// Func�o que efetua o RESIZE de um iFRAME de acordo com o tamanho do seu conte�do
// ------------------------------------------------------------------- by Aless -- 
function reSizeiFrame(prFrameBody, prFrameID, prFlagX, prFlagY)
{
 /* 
    ATEN��O - o par�metro prFrameBody deve ser passado da seguinte forma: MEUIFRAME.document.body

	OBSERVA��O:	at� 04/11/11 fun��o 
				- compat�vel com IExplorer, Safari e Chrome
				- n�o compat�vel com FireFox e Opera
 */
 var oFrame, oBody;
 try {	
		//oBody	 = iframe_chamados.document.body;
		//oFrame = document.all("iframe_chamados");
		oBody	= prFrameBody;
		//oFrame	= window.document.all(prFrameID);
		oFrame	= window.document.getElementById(prFrameID);
		if (prFlagX) {
			oFrame.style.width	= oBody.scrollWidth + (oBody.offsetWidth - oBody.clientWidth);
			oFrame.width		= oBody.scrollWidth + (oBody.offsetWidth - oBody.clientWidth);
		}

		if (prFlagY) {
			oFrame.style.height = oBody.scrollHeight + (oBody.offsetHeight - oBody.clientHeight);
			oFrame.height		= oBody.scrollHeight + (oBody.offsetHeight - oBody.clientHeight);
		}
	 }
	 catch(e) {	
		//An error is raised if the IFrame domain != its container's domain
	 	window.status =	'Error: ' + e.number + '; ' + e.description; 
		alert ('Error: ' + e.number + '; ' + e.description); 
	 }
}


// --------------------------------------------------------------------------------
// Func�o para efetuar o tab autom�tico entre inputs e outros objetos do tipo Form
// --------------------------------------------------------------------------------
function autoTab(input,len, e) 
{
   var keyCode = (isNN) ? e.which : e.keyCode; 
   var filter  = (isNN) ? [0,8,9] : [0,8,9,16,17,18,37,38,39,40,46];
   if(input.value.length >= len && !containsElement(filter,keyCode)) 
   {
     input.value = input.value.slice(0, len);
     input.form[(getIndex(input)+1) % input.form.length].focus();
   }
   function containsElement(arr, ele) 
   {
     var found = false, index = 0;
     while(!found && index < arr.length)
       if(arr[index] == ele)
         found = true;
       else
         index++;
     return found;
   }
   function getIndex(input) 
   {
     var index = -1, i = 0, found = false;
     while (i < input.form.length && index == -1)
     if (input.form[i] == input)
       index = i;
     else 
       i++;
     return index; 
   }
 return true;
}

function validateNumKey() {
 var inputKey = event.keyCode;
 var returnCode = true;
 
 // 0..9 (n�meros)
 if ( inputKey > 47 && inputKey < 58 )
 { return; }
 else {
  returnCode = false;
  event.keyCode = 0;
 }
 event.returnValue = returnCode;
}

function validateFloatKey() {
 var inputKey = event.keyCode;
 var returnCode = true; 
 
 // 0..9 (n�meros)  . (ponto)   , (v�rgula); 
 if((inputKey>47 && inputKey<58) || (inputKey==46 || inputKey==44)) 
 { return; }
 else {
  returnCode = false;
  event.keyCode = 0;
 }
 event.returnValue = returnCode;
}

//-----------------------------------------------------------------------------
// Faz formata��o de input de Datas (ie. - 17/07/2007)
//-----------------------------------------------------------------------------'
function FormataInputData(formname, fieldname) {
var currValue, a, inputKey;

	currValue = eval('document.' + formname + '.' + fieldname + '.value;');
	a = currValue.split ("/").join("");
	inputKey = event.keyCode;

	if(inputKey!=8 && inputKey!=127 && inputKey!=39 && inputKey!=37) {
		if (a.length>3)
			if(a.substr(2,2)<13)
				eval('document.' + formname + '.' + fieldname + '.value = "' + a.substr(0,2) + '/' + a.substr(2,2) + '/' + a.substr(4) + '" ');
			else
				eval('document.' + formname + '.' + fieldname + '.value = "' + a.substr(0,2) + '/12/' + a.substr(4) + '" ');
		else if (a.length>1) 
				if(a.substr(0,2)<32)
					eval('document.' + formname + '.' + fieldname + '.value = "' + a.substr(0,2) + '/' + a.substr(2) + '" ');
				else
					eval('document.' + formname + '.' + fieldname + '.value = "31/' + a.substr(2) + '" ');
	}
}


//-----------------------------------------------------------------------------
// Faz formata��o de input de Hor�rios (ie. - 16:30:00)
//-----------------------------------------------------------------------------'
function FormataInputHora(formname, fieldname){
var currValue,inputKey, a;
	currValue = eval('document.'+formname+'.'+fieldname+'.value;');
	a = currValue.split (":").join("");
	inputKey = event.keyCode;

    // (inputKey<>backspace && inputKey<>: && inputKey<>setas do teclado)
	if(inputKey!=8 && inputKey!=191 && inputKey!=39 && inputKey!=37){ 
		if (a.length>3)
			if(a.substr(2,2)<60)
				eval('document.' + formname + '.' + fieldname + '.value="' + a.substr(0,2) + ':' + a.substr(2,2)+':00"');
			else
				eval('document.' + formname + '.' + fieldname + '.value="' + a.substr(0,2) + ':59:00"');
		else if(a.length==1 && a.substr(0,1)>2)
				eval('document.' + formname + '.' + fieldname + '.value="0'+ a.substr(0,1) + ':' + a.substr(2)+'"');
		else if (a.length>1)
			if(a.substr(0,2)>23)
				eval('document.' + formname + '.' + fieldname + '.value="00:' + a.substr(2)+'"');
			else
				eval('document.' + formname + '.' + fieldname + '.value="'+ a.substr(0,2) + ':' + a.substr(2)+'"');
	}
}

function roundNumber(prValor, prNumCasas) {
  var newnumber;
  newnumber = (Math.round(prValor * Math.pow(10, prNumCasas))) / Math.pow(10, prNumCasas);
  return newnumber;
}

function FloatToMoeda(prValue) {
var Float,Moeda;
	Float = prValue;
	if (Float%2==0 || Float%2==1) {
		Float = Float.toString() + '.00';
	}
	else {
		Float = Float.toString();
		if (Float.substr(Float.length-2,1)=='.') Float = Float + '0';
	}
	Moeda = Float
	return Moeda.toString();
}

function MoedaToFloat(prValue) {
var Float,Moeda, i;
	Float = '';
	Moeda = prValue;
	
	while(Moeda.indexOf(',')>0) Moeda = Moeda.replace(',','.');
	if(Moeda.indexOf('.')>0){
		Moeda = Moeda.split('.');
		for(i=0;i<Moeda.length-1;i++){
			Float += Moeda[i];	
		}
		Float+= '.' + Moeda[Moeda.length-1];	
	}
	else
		Float = Moeda + '.00';
	return parseFloat(Float);	
}

function UploadArquivo(formname, fieldname, dir_upload) {
 var strcaminho = '../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload;
 window.open(strcaminho,'Upload','width=560,height=350,top=50,left=50,scrollbars=1');
}

//Usada nas telas de edi��o/visualiza��o com elementos colocados dentro de "divs"
function ShowArea(prCodArea,prIDHtmlReplace){
	// @Descricao: esta fun��o recebe um prCodArea [ID]
	//             o qual ser� feito um collapse. Tamb�m
	//             recebe prIDHtmlReplace [ID] em que ser� 
	//             feito um replace do source [src];
	//             
	// @DEBUG      alert('Frietz Lang');
	if ((document.getElementById(prCodArea).style.height == '20px') ||
	   ((document.getElementById(prCodArea).style.height == "") && (document.getElementById(prIDHtmlReplace).src.indexOf("BulletMais.gif") != -1))){
		document.getElementById(prCodArea).style.height   = 'auto';
		document.getElementById(prCodArea).style.overflow = 'visible';
		// Muda a imagem para bullet Correto
		document.getElementById(prIDHtmlReplace).src = '../img/BulletMenos.gif';
	}else {
		document.getElementById(prCodArea).style.height   = '20px';
		document.getElementById(prCodArea).style.overflow = 'hidden';
		// Muda a imagem para bullet Correto
		document.getElementById(prIDHtmlReplace).src = '../img/BulletMais.gif';
	}
}

//Usada na parte frontal para exibir daods de chamdos, tarefas, projetos, etc
//Os elementos com os dados ficam dentro de "tables"
function MyShowArea(prCodigo1, prCodigo2)
{
	if (document.getElementById(prCodigo1).style.display == 'none') {
		document.getElementById(prCodigo1).style.display = 'block';
		document.getElementById(prCodigo2).src = '../img/BulletMenos.gif';
	}
	else { 
		document.getElementById(prCodigo1).style.display = 'none';
		document.getElementById(prCodigo2).src = '../img/BulletMais.gif';
	}
}

function displayArea(prIDArea){
	var objIDArea = prIDArea;
	if(objIDArea != null){
		if(document.getElementById(objIDArea).style.display == 'none'){
			document.getElementById(objIDArea).style.display = 'block';
		}else{
			document.getElementById(objIDArea).style.display = 'none';
		}
	}
}

function SetFormField(formname, fieldname, fieldtype, valor) {
var indice = 0;	
	if (fieldtype == 'edit') {
	  if ( (formname != "") && (fieldname != "") && (valor != "") ) 
	    eval("document." + formname + "." + fieldname + ".value = '" + valor + "';");
	}
	
	if (fieldtype == 'combo') {
	    eval('indice = document.' + formname + '.' + fieldname + '.length');
		for (i=0;i < indice ; i++)
			eval('if (document.' + formname + '.' + fieldname + '[i].value == "' + valor + '") document.' + formname + '.' + fieldname + '.selectedIndex = i;');
	}
}

/****************************************************************************************************/
/* CONJUNTO DE FUN��ES PARA CARREGAMENTO DE DIALOGS MODAIS E NO ESTILO 'INCLUDE', VIA AJAX - IN�CIO */
/****************************************************************************************************/
function ajaxLoadModalPAGE(prPage,prIDModal,prBoolDrag){
	// Descri��o: Esta fun��o carrega a p�gina encaminhada
	// em prPage via ajax e coloca o conte�do gerado em 
	// prIDModal. O �ltimo par�metro � utilizado para o
	// tornar o conteiner 'draggable'.
	// Ex. Chamada:
	// -> Com Draggable ajaxLoadModalPAGE(page.asp,'modal_div_id',1);
	// -> Sem Draggable ajaxLoadModalPAGE(page.asp,'modal_div_id');
	var objAjax, strReturnValue;
	var objElement = document.getElementById(prIDModal);
	if(objElement == null || prPage == null || prPage == ""){ return; }
	objAjax = createAjax();
	objAjax.onreadystatechange = function() {
		if(objAjax.readyState == 4) {
			if(objAjax.status == 200) {
				// Processa a p�gina encaminhada como par�metro e joga
				// o retorno para dentro da vari�vel strReturnValue.
				// Logo em seguida substitui o conte�do da div vazia
				// encaminhada como par�metro por uma div que ir� conter
				// o resultado do processamento ajax - Esta div � que
				// ser� 'redimension�vel'.
				strReturnValue 		 = objAjax.responseText;
				objElement.innerHTML = "<div id='modal_dialog_content'>"+strReturnValue+"</div>";
				
				// A cria��o da DIALOG possui um span escondido o qual
				// neste ponto substituimos seu conte�do por uma imagem
				// de um bot�o de FECHAR, que esconde a div inteira.
				document.getElementById('modal_img_close').innerHTML = "<img src='../img/icon_min_window_modal.gif' style='cursor:pointer;padding-right:4px;' onclick=\"javascript:document.getElementById('modal_dialog_body').style.display = 'none';document.getElementById('modal_dialog_footer').style.display = 'none';\"/><img src='../img/icon_max_window_modal.gif' style='cursor:pointer;padding-right:4px;' onclick=\"javascript:document.getElementById('modal_dialog_body').style.display = 'block';document.getElementById('modal_dialog_footer').style.display = 'block';\"/><img src='../img/icon_close_window_modal.gif' onclick=\"document.getElementById(\'"+prIDModal+"\').style.display = 'none';\" style='cursor:pointer;'/>";
				objElement.style.display = 'block';
				
				// Primeiro Par�metro, �rea 'clic�vel para arraste', se-
				// gundo par�metro, �rea que ser� movida.
				if(prBoolDrag != null){ dragDrop('modal_dialog_header','modal_dialog_content'); }
				
				// Corre��o do BUG CSS que altera o padding quando a p�gina
				// ajax � solicitada. O arquivo CSS default do tablesort.css 
				// possui 5px de padding, e quando a p�gina da modal � pro-
				// cessada o arquivo virtualboss.css � carregado, desconjun-
				// tando o anterior. 
				document.body.style.padding = "5px";
				
				//Debbug AREA - alert(strReturnValue);
			}
			else {
				alert("Erro no processamento da p�gina: " + objAjax.status + "\n\n" + objAjax.responseText);
			}
		}
	}
	// Send da P�GINA PAR�METRO
	objAjax.open("GET",prPage,true); 
	objAjax.send(null); 
}

// Drag n Drop de DIV ---------------------------------------------------------------------------------------
// Original by tmferreira - http://www.webly.com.br/tutorial/javascript-e-ajax/7045/drag-and-drop.htm
// Corrigida 30/01/2008 por Micox - http://forum.ievolutionweb.com/index.php?s=&showtopic=7045&view=findpost&p=139679
// Adapted  by Leandro - http://www.athenas.com.br / http://www.proevento.com.br
var objSelecionado = null;
var mouseOffset    = null;
function addEvent(obj, evType, fn) {
	//Fun��o adaptada da original de Christian Heilmann, em
	//http://www.onlinetools.org/articles/unobtrusivejavascript/chapter4.html
	if (typeof obj == "string") {
  		if (null == (obj = document.getElementById(obj))) {
   			throw new Error("Elemento HTML n�o encontrado. N�o foi poss�vel adicionar o evento.");
  		}
	}
	if (obj.attachEvent) {
  		return obj.attachEvent(("on" + evType), fn);
	} else if (obj.addEventListener) {
  		return obj.addEventListener(evType, fn, true);
	} else {
  		throw new Error("Seu browser n�o suporta adi��o de eventos. Senta, chora e pega um navegador mais recente.");
	}
}

function mouseCoords(ev){    
	if(typeof(ev.pageX)!=="undefined"){
		return {x:ev.pageX, y:ev.pageY};
	}else{
		return {
			x:ev.clientX + document.body.scrollLeft - document.body.clientLeft,
		  	y:ev.clientY + document.body.scrollTop  - document.body.clientTop
		};
	}
}

function getPosition(e, ev){
	var ev = ev || window.event;
	if(e.constructor==String){ e = document.getElementById(e);}
	var left = 0, top  = 0;    
	var coords = mouseCoords(ev);    
	while (e.offsetParent){
		left += e.offsetLeft;
	  	top  += e.offsetTop;
	  	e     = e.offsetParent;
	}
	left += e.offsetLeft;
	top  += e.offsetTop;
	return {x: coords.x - left, y: coords.y - top};
}

function dragDrop(local_click, caixa_movida) {
	//Local click indica quem � o cara que quando movido, move o caixa_movida
	if(local_click.constructor==String) { local_click  = document.getElementById(local_click);}
	if(caixa_movida.constructor==String){ caixa_movida = document.getElementById(caixa_movida);}
	
	local_click.style.cursor = 'move';
	if(!caixa_movida.style.position || caixa_movida.style.position=='static'){
		caixa_movida.style.position='relative'
	}
	local_click.onmousedown = function(ev) {
		objSelecionado = caixa_movida;        
		mouseOffset = getPosition(objSelecionado, ev);
	};
	document.onmouseup = function() {
		objSelecionado = null;
	}
	document.onmousemove = function(ev) {
		if (objSelecionado) {
			var ev = ev || window.event;
			var mousePos = mouseCoords(ev);
			var pai = objSelecionado.parentNode;
			objSelecionado.style.left = (mousePos.x - mouseOffset.x - pai.offsetLeft) + 'px';
			objSelecionado.style.top = (mousePos.y - mouseOffset.y - pai.offsetTop) + 'px';
			objSelecionado.style.margin = '0px';
			return false;
		}
	}
}

/****************************************************************************************************/
/* CONJUNTO DE FUN��ES PARA CARREGAMENTO DE DIALOGS MODAIS E NO ESTILO 'INCLUDE', VIA AJAX - IN�CIO */
/****************************************************************************************************/
function ajaxLoadModalPAGE(prPage,prIDModal,prBoolDrag){
	// Descri��o: Esta fun��o carrega a p�gina encaminhada
	// em prPage via ajax e coloca o conte�do gerado em 
	// prIDModal. O �ltimo par�metro � utilizado para o
	// tornar o conteiner 'draggable'.
	// Ex. Chamada:
	// -> Com Draggable ajaxLoadModalPAGE(page.asp,'modal_div_id',1);
	// -> Sem Draggable ajaxLoadModalPAGE(page.asp,'modal_div_id');
	var objAjax, strReturnValue;
	var objElement = document.getElementById(prIDModal);
	if(objElement == null || prPage == null || prPage == ""){ return; }
	objAjax = createAjax();
	objAjax.onreadystatechange = function() {
		if(objAjax.readyState == 4) {
			if(objAjax.status == 200) {
				// Processa a p�gina encaminhada como par�metro e joga
				// o retorno para dentro da vari�vel strReturnValue.
				// Logo em seguida substitui o conte�do da div vazia
				// encaminhada como par�metro por uma div que ir� conter
				// o resultado do processamento ajax - Esta div � que
				// ser� 'redimension�vel'.
				strReturnValue 		 = objAjax.responseText;
				objElement.innerHTML = "<div id='modal_dialog_content'>"+strReturnValue+"</div>";
				
				// A cria��o da DIALOG possui um span escondido o qual
				// neste ponto substituimos seu conte�do por uma imagem
				// de um bot�o de FECHAR, que esconde a div inteira.
				if(document.getElementById('modal_img_close') != null){  
					document.getElementById('modal_img_close').innerHTML = "<img src='../img/icon_min_window_modal.gif' style='cursor:pointer;padding-right:4px;' onclick=\"javascript:document.getElementById('modal_dialog_body').style.display = 'none';document.getElementById('modal_dialog_footer').style.display = 'none';\"/><img src='../img/icon_max_window_modal.gif' style='cursor:pointer;padding-right:4px;' onclick=\"javascript:document.getElementById('modal_dialog_body').style.display = 'block';document.getElementById('modal_dialog_footer').style.display = 'block';\"/><img src='../img/icon_close_window_modal.gif' onclick=\"document.getElementById(\'"+prIDModal+"\').style.display = 'none';\" style='cursor:pointer;'/>";
				} else{
					objElement.innerHTML   = "<table id='modal_dialog_content' align='center' cellpadding='0' cellspacing='0' border='0' width='520'><tr><td><div style='background-color:#FFF;border:1px solid #CCC;padding:5px;left:60%;'><div id='modal_dialog_header' style='height:20px;background-color:SteelBlue'><span id='modal_img_close' style='float:right;vertical-align:middle;padding-right:3px;padding-top:2px;'></span></div>"+objElement.innerHTML+"</div></td></tr></table>";
					objElement.style.left  = "50%";
					objElement.style.width = "auto";
					document.getElementById('modal_img_close').innerHTML = "<img src='../img/icon_close_window_modal.gif' onclick=\"document.getElementById(\'modal_dialog_content\').style.display = 'none';\" style='cursor:pointer;'/>";
				}
				objElement.style.display = 'block';
				
				// Primeiro Par�metro, �rea 'clic�vel para arraste', se-
				// gundo par�metro, �rea que ser� movida.
				if((prBoolDrag != null) && (document.getElementById('modal_dialog_header') != null)){ dragDrop('modal_dialog_header','modal_dialog_content'); }
				
				// Corre��o do BUG CSS que altera o padding quando a p�gina
				// ajax � solicitada. O arquivo CSS default do tablesort.css 
				// possui 5px de padding, e quando a p�gina da modal � pro-
				// cessada o arquivo virtualboss.css � carregado, desconjun-
				// tando o anterior. 
				document.body.style.padding = "5px";
				
				//Debbug AREA - alert(strReturnValue);
			}
			else {
				alert("Erro no processamento da p�gina: " + objAjax.status + "\n\n" + objAjax.responseText);
			}
		}
	}
	// Send da P�GINA PAR�METRO
	objAjax.open("GET",prPage,true); 
	objAjax.send(null); 
}

// Drag n Drop de DIV ---------------------------------------------------------------------------------------
// Original by tmferreira - http://www.webly.com.br/tutorial/javascript-e-ajax/7045/drag-and-drop.htm
// Corrigida 30/01/2008 por Micox - http://forum.ievolutionweb.com/index.php?s=&showtopic=7045&view=findpost&p=139679
// Adapted  by Leandro - http://www.athenas.com.br / http://www.proevento.com.br
var objSelecionado = null;
var mouseOffset    = null;
function addEvent(obj, evType, fn) {
	//Fun��o adaptada da original de Christian Heilmann, em
	//http://www.onlinetools.org/articles/unobtrusivejavascript/chapter4.html
	if (typeof obj == "string") {
  		if (null == (obj = document.getElementById(obj))) {
   			throw new Error("Elemento HTML n�o encontrado. N�o foi poss�vel adicionar o evento.");
  		}
	}
	if (obj.attachEvent) {
  		return obj.attachEvent(("on" + evType), fn);
	} else if (obj.addEventListener) {
  		return obj.addEventListener(evType, fn, true);
	} else {
  		throw new Error("Seu browser n�o suporta adi��o de eventos. Senta, chora e pega um navegador mais recente.");
	}
}

function mouseCoords(ev){    
	if(typeof(ev.pageX)!=="undefined"){
		return {x:ev.pageX, y:ev.pageY};
	}else{
		return {
			x:ev.clientX + document.body.scrollLeft - document.body.clientLeft,
		  	y:ev.clientY + document.body.scrollTop  - document.body.clientTop
		};
	}
}

function getPosition(e, ev){
	var ev = ev || window.event;
	if(e.constructor==String){ e = document.getElementById(e);}
	var left = 0, top  = 0;    
	var coords = mouseCoords(ev);    
	while (e.offsetParent){
		left += e.offsetLeft;
	  	top  += e.offsetTop;
	  	e     = e.offsetParent;
	}
	left += e.offsetLeft;
	top  += e.offsetTop;
	return {x: coords.x - left, y: coords.y - top};
}

function dragDrop(local_click, caixa_movida) {
	//Local click indica quem � o cara que quando movido, move o caixa_movida
	if(local_click.constructor==String) { local_click  = document.getElementById(local_click);}
	if(caixa_movida.constructor==String){ caixa_movida = document.getElementById(caixa_movida);}
	
	local_click.style.cursor = 'move';
	if(!caixa_movida.style.position || caixa_movida.style.position=='static'){
		caixa_movida.style.position='relative'
	}
	local_click.onmousedown = function(ev) {
		objSelecionado = caixa_movida;        
		mouseOffset = getPosition(objSelecionado, ev);
	};
	document.onmouseup = function() {
		objSelecionado = null;
	}
	document.onmousemove = function(ev) {
		if (objSelecionado) {
			var ev = ev || window.event;
			var mousePos = mouseCoords(ev);
			var pai = objSelecionado.parentNode;
			objSelecionado.style.left = (mousePos.x - mouseOffset.x - pai.offsetLeft) + 'px';
			objSelecionado.style.top = (mousePos.y - mouseOffset.y - pai.offsetTop) + 'px';
			objSelecionado.style.margin = '0px';
			return false;
		}
	}
}
/****************************************************************************************************/
/* FIM : CONJUNTO DE FUN��ES PARA CARREGAMENTO DE DIALOGS MODAIS E NO ESTILO 'INCLUDE', VIA AJAX    */
/****************************************************************************************************/


/* ------------------------------------------------------------------------------------------------ */
/* INI : Pesquisa texto na p�gina (highlight)                                                       */
/* ------------------------------------------------------------------------------------------------ */
/*
 Como usar: 

 Criar o FORM conforme exemplo:
 	<form id="form_busca" name="form_busca">
			<!-- phrase--><input type="hidden" class="inputclean" id="phrase" name="phrase" style="width:10px; height:10px;" />
			<!-- cases --><input type="hidden" class="inputclean" id="cases"  name="cases"  style="width:10px; height:10px;" />
			<!-- regex --><input type="hidden" class="inputclean" id="regex"  name="regex"  style="width:10px; height:10px;" />&nbsp;&nbsp;&nbsp;

			<input type="text" name="result" id="result" size="10" readonly="readonly" onclick="unhighlight(this.value.substring(this.value.indexOf('x ')+1))"/>
			<label for="query" title=" Alt+Q ">Busca: <input type="text" id="query" name="query" size="15" accesskey="q" class="edtext" /></label>

			<div onClick="return hi( document.getElementById('form_busca'), 'query', 'result' );" class="btsearch"></div>
		</form>
		
 - os 3� primeiros inputs s�o op��es de pesquisa. Caso deseje usar basta 
   trocar o tipo deles de "hidden" para "checkbox"

 - o 4� inpuit diz respeito ao retorno da quantidade de ocorr�ncias da 
   string pesquisada. Serve tamb�m para fazer o UN-highlight das  
   strings clicando sobre ele

 - por fim. o "bot�o" para chamada da fun��o hi(prform, prfieldsearch, prfiedlresult) 
   onde:
      prform - o form de pesquisa em si
	  prfieldsearch - o NOME do campo onde esta o valor a ser pesquisado	
	  prfiedlresult - o NOME do campo onde deve ser colocada aquajntidade de ocorr�ncias encontrada	
*/
/* ----------------------------------------------------------------------- 07/05/10 - Leandro/Aless */

var times = 0;

function hex(n)  { 
 return ( n<16 ? '0' : '' ) + n.toString(16); 
}

function hi( prform, prfieldsearch, prfiedlresult ) {
 var s = eval("prform." + prfieldsearch + ".value");
 var r = eval("prform." + prfiedlresult);

 r.value = highlight( prform , s  ) + 'x ' + s;
 return false;
}

function highlight( prform, s, o ) {
  if( !s ) { return 0; }
  var d = window.document;
  var f = prform.elements; //f = d.forms.f.elements;

  if( !f.regex.checked ) { s = s.replace( /([\\|^$()[\]{}.*+?])/g, '\\$1' ); }
  if( /^\s*$/.test( s ) ) { return 0; }
  if( !f.phrase.checked ) { s = s.split( /\s+/ ).join( '|' ); }
  o = [ o || d.documentElement || d.body ];
  var r = new RegExp( s, f.cases.checked ? 'g' : 'gi' );  
  var h = d.createElement( 'span' ), i = 0, j, k, l, m, n=0, t;

  h.style.color = '#000';
  h.style.backgroundColor = '#'+( times%2 ? ''+hex(((times+1)%5)*51)+'ff' : 'ff'+hex((times%5)*51)+'' )+'00';
  times++;
  do {
    m = o[i];
    if( m.nodeType===3 ) {
      r.lastIndex = 0;
      l = r.exec(m.nodeValue);
      if( l !== null ) {
        k = l[0].length;
        if( r.lastIndex > k ) {
          m.splitText( r.lastIndex - k );
          m = m.nextSibling;
        }
        if( m.nodeValue.length > k ) {
          m.splitText(k);
          o[i++] = m.nextSibling;
        }
        t = h.cloneNode( true );
        t.appendChild( d.createTextNode( l[0] ) );n++;
        m.parentNode.replaceChild( t, m );
      }
    } else {
      j = m.childNodes.length;
      while ( j ) { o[i++] = m.childNodes.item( --j ); }
    }
  } while( i-- );
  return n;
}


function unhighlight( s, o ) {
 var j, d = window.document;
 s = s.replace(/([\\|^$()[\]{}.*+?])/g, '\\$1').split( /\s+/ ).join( '|' );
 o = o || d.documentElement || d.body;
 var a = o.getElementsByTagName( 'span' );
 var i = a.length;
 var re = new RegExp( '^' + s + '$', 'i' );
 while( i-- ) {
  j = a[i].firstChild;
  if( j ) {
   if( j.nodeType===3 && re.test( j.nodeValue ) ) {
    a[i].parentNode.replaceChild( d.createTextNode( j.nodeValue ), a[i] );
   }
  }
 }
 return false;
}
/* ------------------------------------------------------------------------------------------------ */
/* FIM : Pesquisa texto na p�gina (highlight)                                                       */
/* ------------------------------------------------------------------------------------------------ */

//-->

/* ------------------------------------------------------------------------------------------------ */
/* INI : Devolve dia da semana. Par�metro data: dd/mm/aaaa
/* ------------------------------------------------------------------------------------------------ */
function getDiaSemana(prDate){
	var auxDateParts = new Array();
	auxDateParts = prDate.split('/');		
	var auxDate = new Date(parseInt(auxDateParts[2]), parseInt(auxDateParts[1]-1,10), parseInt(auxDateParts[0],10));		
	switch (auxDate.getDay()){
		case 0:
			return 'Dom';
			break;
		case 1:
			return 'Seg';
			break;
		case 2:
			return 'Ter';
			break;
		case 3:
			return 'Qua';
			break;
		case 4:
			return 'Qui';
			break;
		case 5:
			return 'Sex';
			break;
		case 6:
			return 'Sab';
			break;
		default: 
            return '';	
	 }		  
}
/* ------------------------------------------------------------------------------------------------ */
/* FIM : Devolve dia da semana.
/* ------------------------------------------------------------------------------------------------ */

//-->

/* ------------------------------------------------------------------------------------------------------ */
/* INI : Incrementa data Par�metros: prDtIni(formato dd/mm/aaaa):String;prFreq('DIARIA,SEMANAL...'):String
/* Retorno: data (formato dd/mm/aaaa): String                                                           
/* ------------------------------------------------------------------------------------------------------ */
function IncDate(prDtIni, prFreq){
	var auxFreq = prFreq;
	var strDate;
	var auxDate;
	var auxDateParts;
	strDate = prDtIni;
	auxDateParts = new Array();
	auxDateParts = strDate.split('/');					
	auxDate = new Date(parseInt(auxDateParts[2]), parseInt(auxDateParts[1]-1,10), parseInt(auxDateParts[0],10));		
	switch (auxFreq){
		case 'DIARIA'       		   :auxDate.setDate (auxDate.getDate()     +  1);break;
		case 'SEMANAL'      		   :auxDate.setDate (auxDate.getDate()     +  7);break;
		case 'QUINZENAL'    		   :auxDate.setDate (auxDate.getDate()     + 15);break;
		case 'MENSAL'       		   :auxDate.setMonth(auxDate.getMonth()    +  1);break;
		case 'BIMESTRAL'    		   :auxDate.setMonth(auxDate.getMonth()    +  2);break;
		case 'TRIMESTRAL'   		   :auxDate.setMonth(auxDate.getMonth()    +  3);break;
		case 'QUADRIMESTRAL'		   :auxDate.setMonth(auxDate.getMonth()    +  4);break;		
		case 'SEMESTRAL' 			   :auxDate.setMonth(auxDate.getMonth()    +  6);break;
		case 'ANUAL'       			   :auxDate.setYear (auxDate.getFullYear() +  1);break;		   
		case 'BIANUAL','BIENAL'        :auxDate.setYear (auxDate.getFullYear() +  2);break;		   		
		case 'TRIANUAL' ,'TRIENAL'     :auxDate.setYear (auxDate.getFullYear() +  3);break;		   				
		case 'QUADRIANUAL','QUADRIENAL':auxDate.setYear (auxDate.getFullYear() +  4);break;		   						
	}		
	return ('0' + auxDate.getDate().toString()).slice(-2) + '/' + ('0' + (auxDate.getMonth() + 1).toString()).slice(-2) + '/' + auxDate.getFullYear().toString();
}

/* ------------------------------------------------------------------------------------------------ */
/* FIM : Incrementa data.
/* ------------------------------------------------------------------------------------------------ */

//-->

/* ------------------------------------------------------------------------------------------------ */
/* INI : Valida��o data com RegEx. Par�metro data: dd/mm/aaaa
/* ------------------------------------------------------------------------------------------------ */
//Cr�ditos - http://www.htmlstaff.org/ver.php?id=25285
function checkDate(data){
	var auxDateParts = new Array();
	auxDateParts = data.split('/');		
	var dia = (auxDateParts[0]);
	var mes = (auxDateParts[1]);
	var ano = (auxDateParts[2]);       
   	var dateRegExp =/^(19|20)\d\d-(0?[1-9]|1[012])-(0?[1-9]|[12][0-9]|3[01])$/;
	if (!dateRegExp.test(ano+"-"+mes+"-"+dia)) return false;  // formato inv�lido
	if (dia == 31 && ( /^0?[469]$/.test(mes) || mes == 11) ) {
		return false; // dia 31 de um mes de 30 dias
	}else if (dia >= 30 && mes == 2) {
		return false; // mais de 29 dias em fevereiro
	}else if (mes == 2 && dia == 29 && !(ano % 4 == 0 && (ano % 100 != 0 || ano % 400 == 0))) {
		return false; // dia 29 de fevereiro de um ano n�o bissexto
	}else {
		return true; // Data v�lida
	}
}
/* ------------------------------------------------------------------------------------------------ */
/* FIM : Valida��o data.
/* ------------------------------------------------------------------------------------------------ */

//-->

/* ------------------------------------------------------------------------------------------------ */
/* INI : Valida��o n�mero decimal. 
/* ------------------------------------------------------------------------------------------------ */
function isFloat(numero){
  return !(!/^[+-]?((\d+|\d{1,3}(\.\d{3})+)(\,\d*)?|\,\d+)$/.test(numero));
}
/* ------------------------------------------------------------------------------------------------ */
/* FIM : Valida��o n�mero decimal. 
/* ------------------------------------------------------------------------------------------------ */

//-->

/* ------------------------------------------------------------------------------------------------ */
/* INI : Valida��o n�mero inteiro. 
/* ------------------------------------------------------------------------------------------------ */
function isInt(numero){  
    try{
      var er = new RegExp(/^[0-9]{1,}$/); 
      return (er.test(numero));  
    }
    catch(err){
      return false;
    }
}  
/* ------------------------------------------------------------------------------------------------ */
/* FIM : Valida��o n�mero inteiro. 
/* ------------------------------------------------------------------------------------------------ */


//-->

</script>