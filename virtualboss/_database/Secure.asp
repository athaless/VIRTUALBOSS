<%
    Dim strUsernameTemp
    strUsernameTemp = Session("usuario")                                              
                                                                                  
    If strUsernameTemp = "" Then
      Response.Redirect("../login.asp")
    End If                                                                        
%>