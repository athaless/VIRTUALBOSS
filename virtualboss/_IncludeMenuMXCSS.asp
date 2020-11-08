<script type="text/javascript" language="javascript">
 var mxMatrix = Array(   ["rotulo_menu_1", "modulo_AGENDA/Default.htm", "Agenda"]
						,["rotulo_menu_2", "modulo_NOTEPAD/default.htm", "Anotações"]
						,["rotulo_menu_3", "modulo_MENSAGENS/default.htm", "Mensagens"]
						,["rotulo_menu_4", "modulo_USUARIO/Update.asp", "Meus Dados"]
						,["rotulo_menu_5", "modulo_CATEGORIAS/default.htm", "Categorias"]
						,["rotulo_menu_6", "modulo_AVISO_CFG/Default.htm", "Config. Aviso"]
						,["rotulo_menu_7", "modulo_PONTO_FERIADO/Default.htm", "Feriados/Recessos"]
						,["rotulo_menu_8", "modulo_SYSINFO/systeminfo.aspx", "Info"]
						,["rotulo_menu_9", "modulo_SYSCOMP/objcheck.asp", "Components"]
						,["rotulo_menu_10", "modulo_DBManager/athdefault.asp", "DB Explorer"]
						,["rotulo_menu_11", "modulo_DBManager/athdefault.asp", "File Explorer"]
						,["rotulo_menu_12", "_database/AjustaSaldos.asp", "Ajusta Saldos"]
						,["rotulo_menu_13", "modulo_USUARIO/Default.htm", "Usuários"]
						,["rotulo_menu_14", "modulo_HORARIO/Default.htm", "Carga Horária"]
						,["rotulo_menu_15", "modulo_PONTO/Default.htm", "Registro de Horas"]
						,["rotulo_menu_16", "modulo_PONTO_DESCONTO/Default.htm", "Descontos de Horas"]
						,["rotulo_menu_17", "modulo_PONTO_FOLGA/Default.htm", "Folgas Agendadas"]
						,["rotulo_menu_18", "modulo_CLIENTE/Default.htm", "Clientes"]
						,["rotulo_menu_19", "modulo_FORNECEDOR/Default.htm", "Fornecedores"]
						,["rotulo_menu_20", "modulo_COLABORADOR/Default.htm", "Colaboradores"]
						,["rotulo_menu_21", "modulo_INVENTARIO/Default.htm", "Inventário"]
						,["rotulo_menu_22", "modulo_FIN_SERVICO/default.htm", "Serviços"]
						,["rotulo_menu_23", "modulo_MB_LIVRO/default.htm", "Livros"]
						,["rotulo_menu_24", "modulo_MB_REVISTA/default.htm", "Revistas"]
						,["rotulo_menu_25", "modulo_MB_MANUAL/default.htm", "Manuais"]
						,["rotulo_menu_26", "modulo_MB_DISCO/default.htm", "Discos"]
						,["rotulo_menu_27", "modulo_MB_VIDEO/default.htm", "Vídeos"]
						,["rotulo_menu_28", "modulo_MB_DADO/default.htm", "Dados"]
						,["rotulo_menu_29", "modulo_ACCOUNT/Default.htm", "Accounts"]
						,["rotulo_menu_30", "modulo_PROCESSO/default.htm", "Processos"]
						,["rotulo_menu_31", "modulo_ADM_CARGOS/Default.htm", "Cargos"]
						,["rotulo_menu_32", "modulo_ADM_CLASSES/Default.htm", "Classes"]
						,["rotulo_menu_33", "modulo_ADM_COMPETENCIAS/Default.htm", "Competências"]
						,["rotulo_menu_34", "modulo_PROJETO/default.htm", "Projetos/Project"]
						,["rotulo_menu_35", "modulo_BS/default.htm", "Atividades/BS"]
						,["rotulo_menu_36", "modulo_TODOLIST/default.htm", "Tarefas/ToDoList"]
						,["rotulo_menu_37", "modulo_CHAMADO/Default.htm", "Chamados"]
						,["rotulo_menu_38", "modulo_RESPOSTA/default.htm", "Respostas"]
						,["rotulo_menu_39", "modulo_FIN_TITULOS/default.asp", "Títulos (Geral)"]
						,["rotulo_menu_40", "modulo_FIN_TITULOS_ENT/default.asp", "Títulos (por Entidade)"]
						,["rotulo_menu_41", "modulo_FIN_FLUXOCAIXA/default.htm", "Fluxo de Caixa"]
						,["rotulo_menu_42", "modulo_FIN_LCTO_GERAIS/Default.htm", "Lctos Gerais"]
						,["rotulo_menu_43", "modulo_FIN_LCTOCONTA/default.htm", "Lctos em Conta"]
						,["rotulo_menu_44", "modulo_CONTRATO/default.htm", "Contratos"]
						,["rotulo_menu_45", "modulo_FIN_NF/default.htm", "NF/Recibo"]
						,["rotulo_menu_46", "modulo_FIN_BOLETO/default.htm", "Tipo Boleto"]
						,["rotulo_menu_47", "modulo_FIN_NF_CFG/default.htm", "Config. NF/Recibo"]
						,["rotulo_menu_48", "modulo_PEDIDO/default.htm", "(Pedidos)"]
						,["rotulo_menu_49", "modulo_FIN_CONTAS/default.htm", "Contas Banco"]
						,["rotulo_menu_50", "modulo_FIN_PCONTAS/default.htm", "Planos de Contas"]
						,["rotulo_menu_51", "modulo_FIN_CCUSTOS/default.htm", "Centros de Custos"]
						,["rotulo_menu_52", "modulo_RELAT_ASLW/ExecASLW.asp?var_chavereg=44", "Lançamentos Gerais"]
						,["rotulo_menu_53", "modulo_RELAT_ASLW/ExecASLW.asp?var_chavereg=35", "Lista Dados dos Clientes"]
						,["rotulo_menu_54", "modulo_RELAT_ASLW/ExecASLW.asp?var_chavereg=43", "Lista de EMAIL dos Clientes"]
						,["rotulo_menu_55", "modulo_RELAT_ASLW/ExecASLW.asp?var_chavereg=36", "Atendimentos dos Chamados"]
						,["rotulo_menu_56", "modulo_RELAT_ASLW/ExecASLW.asp?var_chavereg=38", "Atendimentos vs Desbloqueio"]
						,["rotulo_menu_57", "modulo_FIN_BALANCETE/default.htm", "Balancete"]
						,["rotulo_menu_58", "modulo_FIN_LIVRO_CX/Default.htm", "Livro Caixa"]
						,["rotulo_menu_59", "modulo_FIN_EXTRATO/Default.htm", "Extrato"]
				 );

 function SearchInMenuMX(prStr) {
 	var strAux = ""; //prStr;
	for (i=0; i < mxMatrix.length; i++) {	
  	    objStr = new String(mxMatrix[i][2]).toLowerCase()

		//strAux = strAux + "<div id='menu8'>";
		strAux = strAux + "  <ul>";

		if (objStr.toLowerCase().indexOf(prStr.toLowerCase())!=-1) {
		  strAux = strAux + "<li><a href='" + mxMatrix[i][1] + "'>";
		  strAux = strAux + mxMatrix[i][2]
		  strAux = strAux + "</a></li>";
		}
		strAux = strAux + "  </ul>";
		//strAux = strAux + "</div>";
		objStr.free;
	}		
	document.getElementById('LayerResultSearchMX').innerHTML = strAux;
 };
</script>
<ul id="menu">
	<li><a href="#" class="drop">Home</a><!-- Begin Home Item -->
		<div class="dropdown_3columns"><!-- Begin 2 columns container -->
			<div class="col_3"><h2>Virtual<b>BOSS</b></h2></div>
			<div class="col_3">
				<p>Olá, bem-vindo ao <b>vBOSS</b>! Esta é uma ferramenta inovadora 
				e completa para gestão de sua empresa, projetos e muito mais.</p>             
			</div>
			<div class="col_1">
				<h3>Pessoal</h3>
				<ul class="greybox">
					<li><a href="modulo_AGENDA/Default.htm">Agenda</a></li>
					<li><a href="modulo_NOTEPAD/default.htm">Anotações</a></li>
					<li><a href="modulo_MENSAGENS/default.htm">Mensagens</a></li>
					<li><a href="modulo_USUARIO/Update.asp">Meus Dados</a></li>
				</ul>   
			</div>
			<div class="col_1">
				<h3>Configurações</h3>
				<ul class="greybox">
					<li><a href="modulo_CATEGORIAS/default.htm">Categorias</a></li>
					<li><a href="modulo_AVISO_CFG/Default.htm">Config. Aviso</a></li>
					<li><a href="modulo_PONTO_FERIADO/Default.htm">Feriados/Recessos</a></li>
				</ul>   
			</div>
			<div class="col_1">
				<h3>System</h3>
				<ul class="greybox">
					<li><a href="modulo_SYSINFO/systeminfo.aspx">Info</a></li>
					<li><a href="modulo_SYSCOMP/objcheck.asp">Components</a></li>
					<li><a href="modulo_DBManager/athdefault.asp">DB Explorer</a></li>
					<li><a href="modulo_DBManager/athdefault.asp">File Explorer</a></li>
					<li><a href="_database/AjustaSaldos.asp">Ajusta Saldos</a></li>					
				</ul>   
			</div>
			<div class="col_3"><h2>Browser Support</h2></div>
			<div class="col_1"><img src="img/menupurecss_browsers.png" width="125" height="48" alt="" /></div>
			<div class="col_2"><p>This software has been tested in all major browsers.</p></div>
		</div><!-- End 2 columns container -->
	</li><!-- End Home Item -->


	<li><a href="#" class="drop">Cadastros</a><!-- Begin Cadastros -->
		<div class="dropdown_3columns"><!-- Begin Cadastros container -->
			<div class="col_1">
				<h3>Usuários</h3>
				<ul>
					<li><a href="modulo_USUARIO/Default.htm">Usuários</a></li>
					<li><a href="modulo_HORARIO/Default.htm">Carga Horária</a></li>
					<li><a href="modulo_PONTO/Default.htm">Registro de Horas</a></li>
					<li><a href="modulo_PONTO_DESCONTO/Default.htm">Descontos de Horas</a></li>
					<li><a href="modulo_PONTO_FOLGA/Default.htm">Folgas Agendadas</a></li>
				</ul>   
			</div>
			<div class="col_1">
				<h3>Entidades</h3>
				<ul>
					<li><a href="modulo_CLIENTE/Default.htm">Clientes</a></li>
					<li><a href="modulo_FORNECEDOR/Default.htm">Fornecedores</a></li>
					<li><a href="modulo_COLABORADOR/Default.htm">Colaboradores</a></li>
					<li><a href="modulo_INVENTARIO/Default.htm">Inventário</a></li>
					<li><a href="modulo_FIN_SERVICO/default.htm">Serviços</a></li>

				</ul>   
			</div>
			<div class="col_1">
				<h3>Biblioteca</h3>
				<ul>
					<li><a href="modulo_MB_LIVRO/default.htm">Livros</a></li>
					<li><a href="modulo_MB_REVISTA/default.htm">Revistas</a></li>
					<li><a href="modulo_MB_MANUAL/default.htm">Manuais</a></li>
					<li><a href="modulo_MB_DISCO/default.htm">Discos</a></li>
					<li><a href="modulo_MB_VIDEO/default.htm">Vídeos</a></li>
					<li><a href="modulo_MB_DADO/default.htm">Dados</a></li>
				</ul>   
			</div>

			<div class="col_1">
				<h3>Administrativo</h3>
				<ul>
					<li><a href="modulo_ACCOUNT/Default.htm">Accounts</a></li>
					<li><a href="modulo_PROCESSO/default.htm">Processos</a></li>
					<li><a href="modulo_ADM_CARGOS/Default.htm">Cargos</a></li>
					<li><a href="modulo_ADM_CLASSES/Default.htm">Classes</a></li>
					<li><a href="modulo_ADM_COMPETENCIAS/Default.htm">Competências</a></li>
				</ul>   
			</div>
			<div class="col_1">
				<h3>Projetos</h3>
				<ul>
					<li><a href="modulo_PROJETO/default.htm">Projetos/Project</a></li>
					<li><a href="modulo_BS/default.htm">Atividades/BS</a></li>
					<li><a href="modulo_TODOLIST/default.htm">Tarefas/ToDoList</a></li>
					<li><a href="modulo_CHAMADO/Default.htm">Chamados</a></li>
					<li><a href="modulo_RESPOSTA/default.htm">Respostas</a></li>
				</ul>   
			</div>
			<div class="col_1">
				<h3>Complementares</h3>
				<ul>
					<li>Backlog</li>
					<li>Diagramas(prj)</li>
					<li>Metas</li>
					<li>Documentos</li>
					<li>...</li>
				</ul>   
			</div>

		</div><!-- End Cadastros container -->
	</li><!-- End Cadastros Item -->


	<li><a href="#" class="drop">Financeiro</a><!-- Begin Financeiro Item -->
		<div class="dropdown_3columns"><!-- Begin Financeiro container -->
			<div class="col_1">
				<h3>Finanças</h3>
				<ul>
					<li><a href="modulo_FIN_TITULOS/default.asp">Títulos (Geral)</a></li>
					<li><a href="modulo_FIN_TITULOS_ENT/default.asp">Títulos (por Entidade)</a></li>
					<li><a href="modulo_FIN_FLUXOCAIXA/default.htm">Fluxo de Caixa</a></li>
					<li><a href="modulo_FIN_LCTO_GERAIS/Default.htm">Lctos Gerais</a></li>
					<li><a href="modulo_FIN_LCTOCONTA/default.htm">Lctos em Conta</a></li>
				</ul>   
			</div>
			<div class="col_1">
				<h3>Módulos</h3>
				<ul>
					<li><a href="modulo_CONTRATO/default.htm">Contratos</a></li>
					<li><a href="modulo_FIN_NF/default.htm">NF/Recibo</a></li>
					<li><a href="modulo_FIN_BOLETO/default.htm">Tipo Boleto</a></li>   
					<li><a href="modulo_FIN_NF_CFG/default.htm">Config. NF/Recibo</a></li>   
					<li><a href="modulo_PEDIDO/default.htm">(Pedidos)</a></li>
				</ul>   
			</div>
			<div class="col_1">
				<h3>Classificações</h3>
				<ul>
					<li><a href="modulo_FIN_CONTAS/default.htm">Contas Banco</a></li>   
					<li><a href="modulo_FIN_PCONTAS/default.htm">Planos de Contas</a></li>
					<li><a href="modulo_FIN_CCUSTOS/default.htm">Centros de Custos</a></li>
					<li>&nbsp;</li> 
					<li>&nbsp;</li> 
				</ul>   
			</div>
		</div><!-- End Financeiro container -->
	</li><!-- End Financeiro Item -->


	<li class="menu_right"><a href="#" class="drop">Atalhos</a>
		<div class="dropdown_1column align_right">
				<div class="col_1">
					<h2>Meus Atalhos</h2>
					<ul class="simple">
					<%
					strSQL = " SELECT ROTULO, LINK, IMG, TARGET FROM SYS_PAINEL WHERE DT_INATIVO IS NULL AND ID_USUARIO='" & strUSER_ID & "' ORDER BY ORDEM "
					Set objRS = objConn.execute(strSQL)
					
					While Not objRS.EOF
						Response.Write("<li><a href='" & GetValue(objRS,"LINK") & "'>")
						Response.Write("<img src='img/" & GetValue(objRS,"IMG") & "' alt='" & GetValue(objRS,"ROTULO") & "' title='" & GetValue(objRS,"ROTULO") & "' border='0' align='absmiddle' width='25'>")
						Response.Write("&nbsp;" & GetValue(objRS,"ROTULO") & "</a></li>")
						
						objRS.MoveNext
					Wend
					
					FechaRecordSet objRS
					%>
					</ul>
					<ul class="greybox">
						<li><a href="modulo_ICONPAINEL/insert.asp"  target="_blank"><!-- img src="img/AddAtalho_A.gif" title"Adicionar atalho" border="0" //-->Adicionar</a></li>
						<li><a href="modulo_ICONPAINEL/default.htm" target="_blank"><!-- img src="img/AddAtalho_B.gif" title"Editar atalhos" border="0"//-->Editar</a></li>
					</ul>   
				</div>
		</div>
	</li>
	<li class="menu_right"><a href="#" class="drop">Relatórios</a><!-- Begin 3 columns Item -->
		<div class="dropdown_3columns align_right"><!-- Begin 3 columns container -->
			<div class="col_3">
				<h2>Relatórios ASLW</h2>
			</div>
			<div class="col_1">
				<h3>Geral</h3>
				<ul class="greybox">
					<li><a href="modulo_RELAT_ASLW/ExecASLW.asp?var_chavereg=44">Lançamentos Gerais</a></li>
					<li><a href="modulo_RELAT_ASLW/ExecASLW.asp?var_chavereg=35">Lista Dados dos Clientes</a></li>
					<li><a href="modulo_RELAT_ASLW/ExecASLW.asp?var_chavereg=43">Lista de EMAIL dos Clientes</a></li>
				</ul>   
			</div>
			<div class="col_1">
				<h3>&nbsp;</h3>
				<ul class="greybox">
					<li><a href="modulo_RELAT_ASLW/ExecASLW.asp?var_chavereg=36">Atendimentos dos Chamados</a></li>
					<li><a href="modulo_RELAT_ASLW/ExecASLW.asp?var_chavereg=38">Atendimentos vs Desbloqueio</a></li>
					<li>&nbsp;</li>  
				</ul>   
			</div>

			<div class="col_1">
				<h3>Modulares</h3>
				<ul class="greybox">
					<li><a href="modulo_FIN_BALANCETE/default.htm">Balancete</a></li>   
					<li><a href="modulo_FIN_LIVRO_CX/Default.htm">Livro Caixa</a></li>  
					<li><a href="modulo_FIN_EXTRATO/Default.htm">Extrato</a></li>  
				</ul>   
			</div>
			<div class="col_3">
				<h2>Here are some image examples</h2>
			</div>
			<div class="col_3">
				<img src="img/menupurecss_02.jpg" width="70" height="70" class="img_left imgshadow" alt="" />
				<p>Maecenas eget eros lorem, nec pellentesque lacus. Aenean dui orci, rhoncus sit amet tristique eu, tristique sed odio. Praesent ut interdum elit. Maecenas imperdiet, nibh vitae rutrum vulputate, lorem sem condimentum.<a href="#">Read more...</a></p>
				<img src="img/menupurecss_01.jpg" width="70" height="70" class="img_left imgshadow" alt="" />
				<p>Aliquam elementum felis quis felis consequat scelerisque. Fusce sed lectus at arcu mollis accumsan at nec nisi. Aliquam pretium mollis fringilla. Vestibulum tempor facilisis malesuada. <a href="#">Read more...</a></p>
			</div>
		</div><!-- End 3 columns container -->
	</li><!-- End 3 columns Item -->
</ul>