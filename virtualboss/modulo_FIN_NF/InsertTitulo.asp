<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%	
Dim objConn, objRS, strSQL 
Dim intCodNF, strNUM_NF, strCOD_CLI, strTOT_NF
Dim strCOD_CONTA, strCOD_CENTRO_CUSTO, strCOD_PLANO_CONTA

intCodNF = GetParam("var_chavereg")

If intCodNF <> "" Then
	AbreDBConn objConn, CFG_DB 
	
	'------------------------------------
	' Busca os dados da nota
	'------------------------------------
	strSQL = "SELECT NUM_NF, COD_CLI, TOT_NF FROM NF_NOTA WHERE COD_NF = " & intCodNF
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1

	strNUM_NF  = ""
	strCOD_CLI = ""
	strTOT_NF  = ""
	if not objRS.eof then
		strNUM_NF  = GetValue(objRS, "NUM_NF")
		strCOD_CLI = GetValue(objRS, "COD_CLI")
		strTOT_NF  = GetValue(objRS, "TOT_NF")
	end if
	FechaRecordSet objRS
	
	'------------------------------------
	' Busca os últimos utilizados
	'------------------------------------
	strSQL =          " SELECT COD_CONTA, COD_CENTRO_CUSTO, COD_PLANO_CONTA "
	strSQL = strSQL & " FROM FIN_CONTA_PAGAR_RECEBER "
	strSQL = strSQL & " WHERE TIPO_DOCUMENTO LIKE 'NOTA_FISCAL' "
	strSQL = strSQL & " AND PAGAR_RECEBER = 0 "
	strSQL = strSQL & " ORDER BY SYS_DT_CRIACAO DESC "
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	strCOD_CONTA        = ""
	strCOD_CENTRO_CUSTO = ""
	strCOD_PLANO_CONTA  = ""
	if not objRS.eof then
		strCOD_CONTA        = GetValue(objRS, "COD_CONTA")
		strCOD_CENTRO_CUSTO = GetValue(objRS, "COD_CENTRO_CUSTO")
		strCOD_PLANO_CONTA  = GetValue(objRS, "COD_PLANO_CONTA")
	end if
	FechaRecordSet objRS
	
	FechaDBConn objConn
	%>
	<script language="JavaScript">
		location='../modulo_FIN_TITULOS/Insert.asp?var_cod_nf=<%=intCodNF%>' +
												'&var_num_nf=<%=strNUM_NF%>' +
												'&var_tipo=RC' +
												'&var_codigo=<%=strCOD_CLI%>' +
												'&var_tipo_entidade=ENT_CLIENTE' +
												'&var_documento=NOTA_FISCAL' +
												'&var_num_documento=NF-<%=strNUM_NF%>' +
												'&var_vlr_conta=<%=strTOT_NF%>' +
												'&var_chavereg=<%=strCOD_CONTA%>' +
												'&var_centro_custo=<%=strCOD_CENTRO_CUSTO%>' +
												'&var_plano_conta=<%=strCOD_PLANO_CONTA%>';
	</script>
	<%
End If
%>