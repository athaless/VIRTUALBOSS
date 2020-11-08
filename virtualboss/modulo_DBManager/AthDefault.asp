<!--#include file="../_database/athDbConn.asp"--><!-- ATENÇÃO: language, option explicit, etc... estão no athDBConn -->
<% 
 Response.AddHeader "Content-Type","text/html; charset=iso-8859-1"
 VerificaDireito "|FULL|", BuscaDireitosFromDB("modulo_DBManager", Request.Cookies("VBOSS")("ID_USUARIO")), true 

  Dim auxStr

  'auxmappath = Trim("DRIVER={Microsoft Access Driver (*.mdb)};DBQ=" & FindBDPath & CFG_DB)
  'auxmappath = "DRIVER={" & CFG_DB_DRIVER & "};SERVER=localhost;PORT=3306;DATABASE=" & pr_StrDataBase & ";USER=" & CFG_DB_USER & ";PASSWORD=athroute66;OPTION=3;"

  auxStr = "DRIVER={" & CFG_DB_DRIVER & "};SERVER=localhost;PORT=3306;DATABASE=" & CFG_DB & ";uid=" & CFG_DB_USER & ";pwd=athroute66;OPTION=3;"
  auxStr = "FreeConnect.asp?Action=conectar&UseTreemenu=True&conectar=" & auxStr &"&user="& CFG_DB_USER & "&pass=athroute66"

  Call Response.Redirect (auxStr)
  'Call Response.Redirect ("FreeConnect.asp?Action=Connect&CONNECT=" & auxmappath)
  'Call Response.Redirect ("FreeConnect.asp")

  Response.End
%>