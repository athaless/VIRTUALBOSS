<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<!--#include file="../_database/athUtils.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.AddHeader "Content-Type","text/html; charset=iso-8859-1"
 VerificaDireito "|RED_BUTTON|", BuscaDireitosFromDB("modulo_DBMANAGER", Request.Cookies("VBOSS")("ID_USUARIO")), true
 
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span style='float:left;vertical-align:bottom'><img src='../img/dlg_warning.gif' height='20'></span>ATENÇÃO! Este procedimento RECALCULARÁ e AJUSTARÁ TODAS as CONTAS BANCO Cadastradas no sistema. Para confirmar clique no botão [ok], para desistir clique em [cancelar]."
 Dim strACTION
 
 'Confirmação enviada pela DIALOG
 strACTION = GetParam("VAR_ACTION")
 
 If((strACTION = "") or (strACTION = null)) then
 	strACTION = "0"
 End If
 
 If(strACTION = "1")then
	Sub AjustaFinanceiro(pr_objConn, prCodConta)
		Dim objRS1_local, objRS2_local, strSQL_local, Cont_local
		Dim strCOD_CONTA, strMES, strANO, strDATA1, strDATA2, strOPERACAO
		Dim strVALOR, strSALDO1, strSALDO2
		
		Cont_local = 0
		
		'Limpa os saldos financeiros
		athDebug "<br>Deletando saldos...", False
		
		strSQL_local = " DELETE FROM FIN_SALDO_AC "
		If prCodConta <> "" Then strSQL_local = strSQL_local & " WHERE COD_CONTA = " & prCodConta
		pr_objConn.Execute(strSQL_local)
		
		'Varre todas as contas
		strSQL_local = " SELECT COD_CONTA, NOME, VLR_SALDO_INI, DT_CADASTRO FROM FIN_CONTA "
		If prCodConta <> "" Then strSQL_local = strSQL_local & " WHERE COD_CONTA = " & prCodConta
		Set objRS1_local = pr_objConn.Execute(strSQL_local)
		
		Do While Not objRS1_local.Eof
			athDebug "<br><br><br><strong>Ajustando conta " & GetValue(objRS1_local, "COD_CONTA") & " - " & GetValue(objRS1_local, "NOME") & "</strong>", False
			
			strCOD_CONTA = GetValue(objRS1_local, "COD_CONTA")
			strMES = DatePart("M", GetValue(objRS1_local, "DT_CADASTRO"))
			strANO = DatePart("YYYY", GetValue(objRS1_local, "DT_CADASTRO"))
			strVALOR = FormatNumber(GetValue(objRS1_local, "VLR_SALDO_INI"), 2)
			strVALOR = Replace(Replace(strVALOR,".",""),",",".")
			strSALDO1 = FormatNumber(GetValue(objRS1_local, "VLR_SALDO_INI"), 2)
			strSALDO1 = Replace(Replace(strSALDO1,".",""),",",".")
			
			'---------------------------------------------
			'Insere o saldo inicial
			'---------------------------------------------
			athDebug "<br>Inserindo saldo acumulado inicial para " & strMES & "/" & strANO & " com valor de " & strVALOR, False
			
			strSQL_local =                " INSERT INTO FIN_SALDO_AC (COD_CONTA, MES, ANO, VALOR, RECALCULADO, SYS_COD_USER_ULT_LCTO) "
			strSQL_local = strSQL_local & "	VALUES (" & strCOD_CONTA & ", " & strMES & ", " & strANO & ", " & strVALOR & ", -1, '" & Request.Cookies("VBOSS")("ID_USUARIO") & " (ajusta saldos)') "
			pr_objConn.Execute(strSQL_local)
			
			athDebug "<br>Inserindo outros saldos com zero até mês de hoje (" & DatePart("M", Date) & "/" & DatePart("YYYY", Date) & ")", False
			
			strDATA1 = DateAdd("M", 1, DateSerial(strANO, strMES, 1))
			strDATA2 = DateSerial(DatePart("YYYY", Date), DatePart("M", Date), 1)
			
			While (strDATA1 <= strDATA2)
				strSQL_local =                " INSERT INTO FIN_SALDO_AC (COD_CONTA, MES, ANO, VALOR, RECALCULADO, SYS_COD_USER_ULT_LCTO) "
				strSQL_local = strSQL_local & " VALUES (" & strCOD_CONTA & ", " & DatePart("M", strDATA1) & ", " & DatePart("YYYY", strDATA1) & ", 0, -1, '" & Request.Cookies("VBOSS")("ID_USUARIO") & " (ajusta saldos)') "
				
				strDATA1 = DateAdd("M", 1, strDATA1)
				
				pr_objConn.Execute(strSQL_local)
			WEnd
			
			'---------------------------------------------
			'Varre os lançamentos em conta
			'---------------------------------------------
			athDebug "<br>Varrendo lançamentos em conta:", False
			
			strSQL_local =                " SELECT OPERACAO, SUM(VLR_LCTO) AS VLR_TOTAL, Month(DT_LCTO) AS MES, Year(DT_LCTO) AS ANO "
			strSQL_local = strSQL_local & " FROM FIN_LCTO_EM_CONTA "
			strSQL_local = strSQL_local & " WHERE COD_CONTA = " & strCOD_CONTA 
			strSQL_local = strSQL_local & " GROUP BY OPERACAO, Month(DT_LCTO), Year(DT_LCTO) "
			strSQL_local = strSQL_local & " ORDER BY Year(DT_LCTO), Month(DT_LCTO) "
			
			Set objRS2_local = pr_objConn.Execute(strSQL_local)
			
			Do While Not objRS2_local.Eof
				strOPERACAO = GetValue(objRS2_local, "OPERACAO")
				strMES = GetValue(objRS2_local, "MES")
				strANO = GetValue(objRS2_local, "ANO")
				strVALOR = GetValue(objRS2_local, "VLR_TOTAL")
				strVALOR = FormatNumber(strVALOR, 2)
				strVALOR = Replace(Replace(strVALOR,".",""),",",".")
				
				If strOPERACAO = "RECEITA" Then strOPERACAO = "+"
				If strOPERACAO = "DESPESA" Then strOPERACAO = "-"
				
				athDebug "<br>&nbsp;&nbsp;&nbsp;&nbsp;Valor para " & strMES & "/" & strANO & " de " & strOPERACAO & strVALOR, False
				
				strSQL_local =                " UPDATE FIN_SALDO_AC " 
				strSQL_local = strSQL_local & " SET VALOR = VALOR " & strOPERACAO & strVALOR 
				strSQL_local = strSQL_local & " WHERE COD_CONTA = " & strCOD_CONTA 
				strSQL_local = strSQL_local & " AND MES = " & strMES 
				strSQL_local = strSQL_local & " AND ANO = " & strANO 
				
				pr_objConn.Execute(strSQL_local)
				
				athMoveNext objRS2_local, Cont_local, 40
			Loop
			FechaRecordSet objRS2_local
			
			'---------------------------------------------
			'Varre os lançamentos ordinários
			'---------------------------------------------
			athDebug "<br>Varrendo lançamentos ordinários de saída:", False
			
			strSQL_local =                " SELECT SUM(ORD.VLR_LCTO) AS VLR_TOTAL, Month(ORD.DT_LCTO) AS MES, Year(ORD.DT_LCTO) AS ANO "
			strSQL_local = strSQL_local & " FROM FIN_LCTO_ORDINARIO ORD "
			strSQL_local = strSQL_local & " INNER JOIN FIN_CONTA_PAGAR_RECEBER PR ON (ORD.COD_CONTA_PAGAR_RECEBER = PR.COD_CONTA_PAGAR_RECEBER) "
			strSQL_local = strSQL_local & " WHERE PR.SYS_DT_CANCEL IS NULL AND ORD.SYS_DT_CANCEL IS NULL "
			strSQL_local = strSQL_local & " AND PR.PAGAR_RECEBER <> 0 AND ORD.COD_CONTA = " & strCOD_CONTA
			strSQL_local = strSQL_local & " GROUP BY Month(ORD.DT_LCTO), Year(ORD.DT_LCTO) "
			strSQL_local = strSQL_local & " ORDER BY Year(ORD.DT_LCTO), Month(ORD.DT_LCTO) "
			
			Set objRS2_local = pr_objConn.Execute(strSQL_local)
			
			Do While Not objRS2_local.Eof
				strMES = GetValue(objRS2_local, "MES")
				strANO = GetValue(objRS2_local, "ANO")
				strVALOR = GetValue(objRS2_local, "VLR_TOTAL")
				strVALOR = FormatNumber(strVALOR, 2)
				strVALOR = Replace(Replace(strVALOR,".",""),",",".")
				
				strOPERACAO = "-"
				
				athDebug "<br>&nbsp;&nbsp;&nbsp;&nbsp;Valor para " & strMES & "/" & strANO & " de " & strOPERACAO & strVALOR, False
				
				strSQL_local =                " UPDATE FIN_SALDO_AC " 
				strSQL_local = strSQL_local & " SET VALOR = VALOR " & strOPERACAO & strVALOR 
				strSQL_local = strSQL_local & " WHERE COD_CONTA = " & strCOD_CONTA 
				strSQL_local = strSQL_local & " AND MES = " & strMES 
				strSQL_local = strSQL_local & " AND ANO = " & strANO 
				
				pr_objConn.Execute(strSQL_local)
				
				athMoveNext objRS2_local, Cont_local, 40
			Loop
			FechaRecordSet objRS2_local
			
			athDebug "<br>Varrendo lançamentos ordinários de entrada:", False
			
			strSQL_local =                " SELECT SUM(ORD.VLR_LCTO) AS VLR_TOTAL, Month(ORD.DT_LCTO) AS MES, Year(ORD.DT_LCTO) AS ANO "
			strSQL_local = strSQL_local & " FROM FIN_LCTO_ORDINARIO ORD "
			strSQL_local = strSQL_local & " INNER JOIN FIN_CONTA_PAGAR_RECEBER PR ON (ORD.COD_CONTA_PAGAR_RECEBER = PR.COD_CONTA_PAGAR_RECEBER) "
			strSQL_local = strSQL_local & " WHERE PR.SYS_DT_CANCEL IS NULL AND ORD.SYS_DT_CANCEL IS NULL "
			strSQL_local = strSQL_local & " AND PR.PAGAR_RECEBER = 0 AND ORD.COD_CONTA = " & strCOD_CONTA
			strSQL_local = strSQL_local & " GROUP BY Month(ORD.DT_LCTO), Year(ORD.DT_LCTO) "
			strSQL_local = strSQL_local & " ORDER BY Year(ORD.DT_LCTO), Month(ORD.DT_LCTO) "
			
			Set objRS2_local = pr_objConn.Execute(strSQL_local)
			
			Do While Not objRS2_local.Eof
				strMES = GetValue(objRS2_local, "MES")
				strANO = GetValue(objRS2_local, "ANO")
				strVALOR = GetValue(objRS2_local, "VLR_TOTAL")
				strVALOR = FormatNumber(strVALOR, 2)
				strVALOR = Replace(Replace(strVALOR,".",""),",",".")
				
				strOPERACAO = "+"
				
				athDebug "<br>&nbsp;&nbsp;&nbsp;&nbsp;Valor para " & strMES & "/" & strANO & " de " & strOPERACAO & strVALOR, False
				
				strSQL_local =                " UPDATE FIN_SALDO_AC " 
				strSQL_local = strSQL_local & " SET VALOR = VALOR " & strOPERACAO & strVALOR 
				strSQL_local = strSQL_local & " WHERE COD_CONTA = " & strCOD_CONTA 
				strSQL_local = strSQL_local & " AND MES = " & strMES 
				strSQL_local = strSQL_local & " AND ANO = " & strANO 
				
				pr_objConn.Execute(strSQL_local)
				
				athMoveNext objRS2_local, Cont_local, 40
			Loop
			FechaRecordSet objRS2_local
			
			'---------------------------------------------
			'Varre os lançamentos de transferência
			'---------------------------------------------
			athDebug "<br>Varrendo lançamentos de transferência de saída:", False
			
			strSQL_local =                " SELECT SUM(VLR_LCTO) AS VLR_TOTAL, Month(DT_LCTO) AS MES, Year(DT_LCTO) AS ANO "
			strSQL_local = strSQL_local & " FROM FIN_LCTO_TRANSF WHERE COD_CONTA_ORIG = " & strCOD_CONTA
			strSQL_local = strSQL_local & " GROUP BY Month(DT_LCTO), Year(DT_LCTO) "
			strSQL_local = strSQL_local & " ORDER BY Year(DT_LCTO), Month(DT_LCTO) "
			
			Set objRS2_local = pr_objConn.Execute(strSQL_local)
			
			Do While Not objRS2_local.Eof
				strMES = GetValue(objRS2_local, "MES")
				strANO = GetValue(objRS2_local, "ANO")
				strVALOR = GetValue(objRS2_local, "VLR_TOTAL")
				strVALOR = FormatNumber(strVALOR, 2)
				strVALOR = Replace(Replace(strVALOR,".",""),",",".")
				
				strOPERACAO = "-"
				
				athDebug "<br>&nbsp;&nbsp;&nbsp;&nbsp;Valor para " & strMES & "/" & strANO & " de " & strOPERACAO & strVALOR, False
				
				strSQL_local =                " UPDATE FIN_SALDO_AC " 
				strSQL_local = strSQL_local & " SET VALOR = VALOR " & strOPERACAO & strVALOR 
				strSQL_local = strSQL_local & " WHERE COD_CONTA = " & strCOD_CONTA 
				strSQL_local = strSQL_local & " AND MES = " & strMES 
				strSQL_local = strSQL_local & " AND ANO = " & strANO 
				
				pr_objConn.Execute(strSQL_local)
				
				athMoveNext objRS2_local, Cont_local, 40
			Loop
			FechaRecordSet objRS2_local
			
			athDebug "<br>Varrendo lançamentos de transferência de entrada:", False
			
			strSQL_local =                " SELECT SUM(VLR_LCTO) AS VLR_TOTAL, Month(DT_LCTO) AS MES, Year(DT_LCTO) AS ANO "
			strSQL_local = strSQL_local & " FROM FIN_LCTO_TRANSF WHERE COD_CONTA_DEST = " & strCOD_CONTA
			strSQL_local = strSQL_local & " GROUP BY Month(DT_LCTO), Year(DT_LCTO) "
			strSQL_local = strSQL_local & " ORDER BY Year(DT_LCTO), Month(DT_LCTO) "
			
			Set objRS2_local = pr_objConn.Execute(strSQL_local)
			
			Do While Not objRS2_local.Eof
				strMES = GetValue(objRS2_local, "MES")
				strANO = GetValue(objRS2_local, "ANO")
				strVALOR = GetValue(objRS2_local, "VLR_TOTAL")
				strVALOR = FormatNumber(GetValue(objRS2_local, "VLR_TOTAL"), 2)
				strVALOR = Replace(Replace(strVALOR,".",""),",",".")
				
				strOPERACAO = "+"
				
				athDebug "<br>&nbsp;&nbsp;&nbsp;&nbsp;Valor para " & strMES & "/" & strANO & " de " & strOPERACAO & strVALOR, False
				
				strSQL_local =                " UPDATE FIN_SALDO_AC " 
				strSQL_local = strSQL_local & " SET VALOR = VALOR " & strOPERACAO & strVALOR
				strSQL_local = strSQL_local & " WHERE COD_CONTA = " & strCOD_CONTA 
				strSQL_local = strSQL_local & " AND MES = " & strMES 
				strSQL_local = strSQL_local & " AND ANO = " & strANO 
				
				pr_objConn.Execute(strSQL_local)
				
				athMoveNext objRS2_local, Cont_local, 40
			Loop
			FechaRecordSet objRS2_local
			
			'---------------------------------------------
			'Exibe os saldos acumulados
			'---------------------------------------------
			athDebug "<br><br>Exibindo acumulados:", False
			
			strSQL_local =                " SELECT VALOR, MES, ANO "
			strSQL_local = strSQL_local & " FROM FIN_SALDO_AC "
			strSQL_local = strSQL_local & " WHERE COD_CONTA = " & strCOD_CONTA
			strSQL_local = strSQL_local & " ORDER BY ANO, MES "
			
			Set objRS2_local = pr_objConn.Execute(strSQL_local)
			
			strSALDO1 = 0
			Do While Not objRS2_local.Eof
				strMES = GetValue(objRS2_local, "MES")
				strANO = GetValue(objRS2_local, "ANO")
				strVALOR = GetValue(objRS2_local, "VALOR")
				
				strSALDO1 = strSALDO1 + CDbl(strVALOR)
				
				strVALOR = FormatNumber(strVALOR, 2)
				strVALOR = Replace(Replace(strVALOR,".",""),",",".")
				
				strSALDO2 = FormatNumber(strSALDO1, 2)
				strSALDO2 = Replace(Replace(strSALDO2,".",""),",",".")
				
				athDebug "<br>&nbsp;&nbsp;&nbsp;&nbsp;Acumulado parcial em " & strMES & "/" & strANO & " de " & strVALOR & ", atualizando para " & strSALDO2, False
				
				strSQL_local =                " UPDATE FIN_SALDO_AC "
				strSQL_local = strSQL_local & " SET VALOR = " & strSALDO2
				strSQL_local = strSQL_local & " WHERE COD_CONTA = " & strCOD_CONTA
				strSQL_local = strSQL_local & " AND MES = " & strMES
				strSQL_local = strSQL_local & " AND ANO = " & strANO
				
				pr_objConn.Execute(strSQL_local)
				
				athMoveNext objRS2_local, Cont_local, 40
			Loop
			FechaRecordSet objRS2_local
			
			'---------------------------------------------
			'Atualiza o saldo da conta
			'---------------------------------------------
			strSALDO1 = FormatNumber(strSALDO1, 2)
			strSALDO1 = Replace(Replace(strSALDO1,".",""),",",".")
			
			athDebug "<br><br>Saldo total: " & strSALDO1, False
			
			strSQL_local =                " UPDATE FIN_CONTA "
			strSQL_local = strSQL_local & " SET VLR_SALDO = " & strSALDO1
			strSQL_local = strSQL_local & " WHERE COD_CONTA = " & strCOD_CONTA
			
			pr_objConn.Execute(strSQL_local)
			
			athMoveNext objRS1_local, Cont_local, 40
		Loop
		FechaRecordSet objRS1_local
	End Sub
 End If
 Dim strSQL, objRS, ObjConn
 AbreDBConn objConn, CFG_DB 
%>
<html>
<head>
	<script type="text/javascript" src="../_scripts/tablesort.js"></script>
	<script type="text/javascript">
	//****** Funções de ação dos botões - Início ******
		function ok()			{ document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
		function cancelar()		{ document.location.href = document.form_insert.DEFAULT_LOCATION.value; }
		
		function aplicar()      { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
		function submeterForm() { document.form_insert.submit(); }
	//****** Funções de ação dos botões - Fim ******
	</script>
	<link rel="stylesheet" type="text/css" href="../_css/virtualboss.css">
	<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
</head>
<body>
<% If(strACTION <> "1")then %>
	<%=athBeginDialog(WMD_WIDTH, "Ajuste de Saldos - Contas Banco")%>     
		<form name="form_insert" action="AjustaSaldos.asp" method="post">
			<input type="hidden" name="VAR_ACTION" value="1">
			<input type="hidden" name="DEFAULT_LOCATION" 	value='../modulo_PAINEL/principal.htm'>
			<div style="text-align:center;vertical-align:middle;font-family:'Trebuchet MS',Verdana,Tahoma,Arial;font-size:12px;font-weight:bold;"><%=auxAVISO%></div>
			<!--div class="form_label">Nome:</div><input name="DBVAR_STR_NOME" type="text" style="width:300px" value="" maxlength="250">
			<br><div class="form_label">RG:</div><input name="DBVAR_STR_RG" type="text" style="width:110px" value=""><div class="form_bypass">Órgão Expeditor:</div><input name="DBVAR_STR_ORGAO_EXPEDITOR" type="text" style="width:60px" maxlength="10" value="">
			<br><div class="form_label">CPF:</div><input name="DBVAR_STR_CPF" type="text" style="width:110px" value="">
			<br><div class="form_label">Fone:</div><input name="DBVAR_STR_FONE_1" type="text" style="width:100px" value="">
			<br><div class="form_label">Fone Extra:</div><input name="DBVAR_STR_FONE_2" type="text" style="width:100px" value=""-->
		</form>
	<%=athEndDialog("","../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "", "")%>
<% Else %>
	<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tableheader">
 	<!-- 
		Possibilidades de tipo de sort...
  		class="sortable-date-dmy"
  		class="sortable-currency"
  		class="sortable-numeric"
  		class="sortable"
 	-->
 		<!--thead>
   			<tr> 
      			<th>Dados</th>
		    </tr>
  		</thead-->
 		<tbody style="text-align:left;">
	 		<tr>
				<td style="width:100px;"></td> 
				<td>
				<% '---------------------------------------------------------------------------------
				   ' Faz ajuste das finanças: refaz os acumulados e atualiza saldo das contas
				   ' Segundo parâmetro é o código da conta, se não informado faz de todas as contas
				   '---------------------------------------------------------------------------------
				   AjustaFinanceiro objConn, ""
				%>
				</td>
			 </tr>
		 </tbody>
	</table>
<% End If %>
</body>
</html>
<% FechaDBConn objConn %>
