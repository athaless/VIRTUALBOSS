<!--#include file="../_database/athdbConn.asp"--><%' ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
 Dim ObjConn, strCOD_HORARIO, strID_USUARIO

 strID_USUARIO  = GetParam("ID_USUARIO")
 strCOD_HORARIO = GetParam("COD_HORARIO")

 if strCOD_HORARIO<>"" then   
    AbreDBConn ObjConn, CFG_DB
    objConn.Execute("DELETE FROM USUARIO_HORARIO WHERE COD_HORARIO = " & strCOD_HORARIO)	 
    FechaDBConn ObjConn
 end if
%>
<script>
   //ASSIM S� FUNCIONA NO IE (s� no IE): parent.vbTopFrame.form_principal.submit();
 
   //ASSIM FUNCIONA NO IE e no FIREFOX
   parent.frames["vbTopFrame"].document.form_principal.submit();
</script>