<!-- include file="../_database/athdbConn.asp"--> <!-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --> 
<% 
 ' não funciona com "Option Explicit" por isso não inclui a athDBCONN
 Response.AddHeader "Content-Type","text/html; charset=iso-8859-1"
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_SYSCOMP", Request.Cookies("VBOSS")("ID_USUARIO")), true 

 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 ' ASP Component Test
 ' Adapted by Aless, thanks to James Harris, All Rights Reserved
 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 on error resume next

 Dim cat, com, comID, comDetails, comCreate, comURL, comName, comCat, comCat2 
 Dim show, showCat, display, display2
 Dim installedCOMs, installed, onNum, a, b, i
 Dim lastUpdate, constAutor
 Dim strCOLOR

 installedCOMs = 0
 onNum         = 0
 lastUpdate    = "25/04/2010" '"1/8/2002"
 constAutor    = "Adapted by Athenas/Aless, thanks to James Harris"

 show    = request("var_status") 
 showCat = request("var_categ") 


 ' INI: Filtro status ------------------------
 if isnumeric(show) then 
   show = CInt(show) 
 else 
   show = 1
 end if
 if (show > 3) then show = 1
 ' FIM: Filtro status ------------------------


 ' INI: Filtro categoria ---------------------
 if isnumeric(showCat) then 
   showCat = CInt(showCat) 
 else 
   showCat = "all"
 end if
 ' FIM: Filtro categoria ---------------------



 ' COMPONENTES
 ' formatação: comObject|comURL|comName|comCategoria|comCategoria2
 com = "CDONTS.NewMail|http://www.microsoft.com|CDONTS (free)|1|"
 com = com & "|.|" & "SMTPsvg.Mailer|http://www.serverobjects.com|Server Objects - ASPMail|1|"
 com = com & "|.|" & "SMTPsvg.Mailer|http://www.serverobjects.com|Server Objects - ASPQMail|1|"
 com = com & "|.|" & "AspImage.Image|http://www.serverobjects.com|Server Objects - ASPImage|4|"
 com = com & "|.|" & "POP3svg.Mailer|http://www.serverobjects.com|Server Objects - ASPPop3|1|"
 com = com & "|.|" & "AspNNTP.Conn|http://www.serverobjects.com|Server Objects - AspNNTP|0|"
 com = com & "|.|" & "AspFile.FileObj|http://www.serverobjects.com|ServerObjects - AspFile|6|"
 com = com & "|.|" & "AspConv.Expert|http://www.serverobjects.com|ServerObjects - AspConv|0|"
 com = com & "|.|" & "AspHTTP.Conn|http://www.serverobjects.com|ServerObjects - AspHTTP|0|"
 com = com & "|.|" & "AspDNS.Lookup|http://www.serverobjects.com|ServerObjects - AspDNS|0|"
 com = com & "|.|" & "AspMX.Lookup|http://www.serverobjects.com|ServerObjects - AspMX|1|"
 com = com & "|.|" & "WaitFor.Comp|http://www.serverobjects.com|ServerObjects - Waitfor (free)|0|"
 com = com & "|.|" & "LastMod.FileObj|http://www.serverobjects.com|ServerObjects - Last Modified (free)|6|"
 com = com & "|.|" & "ImgSize.Check|http://www.serverobjects.com|ServerObjects - Image Size (free)|4|"
 com = com & "|.|" & "GuidMakr.GUID|http://www.serverobjects.com|ServerObjects - GUID Maker (free)|0|"
 com = com & "|.|" & "ASPsvg.Process|http://www.serverobjects.com|ServerObjects - AspProc (free)|0|"
 com = com & "|.|" & "AspPing.Conn|http://www.serverobjects.com|ServerObjects - AspPing (free)|0|"
 com = com & "|.|" & "AspInet.FTP|http://www.serverobjects.com|ServerObjects - AspInet (free)|0|"
 com = com & "|.|" & "ASPExec.Execute|http://www.serverobjects.com|ServerObjects - AspExec (free)|0|"
 com = com & "|.|" & "AspCrypt.Crypt|http://www.serverobjects.com|ServerObjects - AspCryp (free)|9|"
 com = com & "|.|" & "Bible.Lookup|http://www.serverobjects.com|ServerObjects - AspBible (free)|0|"
 com = com & "|.|" & "SoftArtisans.SAFile|http://www.softartisans.com|SoftArtisians Fileup|3|"
 com = com & "|.|" & "SoftArtisans.FileManager|http://www.softartisans.com|SoftArtisians FileManager|6|"
 com = com & "|.|" & "SoftArtisans.XFRequest|http://www.softartisans.com|SoftArtisians X-File|6|"
 com = com & "|.|" & "SoftArtisans.FileManagerTX|http://www.softartisans.com|SoftArtisians FileManagerTX|6|"
 com = com & "|.|" & "SoftArtisans.SASessionPro.1|http://www.softartisans.com|SoftArtisans SA-Session Pro|0|"
 com = com & "|.|" & "SMUM.XCheck.1|http://www.softartisans.com|SoftArtisians Check (form validator)|11|"
 com = com & "|.|" & "Softartisans.Archive|http://www.softartisans.com|SoftArtisans Archive|6|"
 com = com & "|.|" & "SoftArtisans.SMTPMail|http://www.softartisans.com|SoftArtisans SMTPmail|1|"
 com = com & "|.|" & "Softartisans.ExcelWriter|http://www.softartisans.com|SoftArtisans Excel Writer|5|"
 com = com & "|.|" & "SoftArtisans.Groups|http://www.softartisans.com|SoftArtisans.Groups (SA-Admin)|9|"
 com = com & "|.|" & "SoftArtisans.Performance|http://www.softartisans.com|SoftArtisians.Performance (SA-Admin)|9|"
 com = com & "|.|" & "SoftArtisans.RAS|http://www.softartisans.com|SoftArtisans.RAS (SA-Admin)|9|"
 com = com & "|.|" & "SoftArtisans.Shares|http://www.softartisans.com|SoftArtisans.Shares (SA-Admin)|9|"
 com = com & "|.|" & "SoftArtisans.User|http://www.softartisans.com|SoftArtisans.User (SA-Admin)|9|"
 com = com & "|.|" & "Jmail.smtpmail|http://www.dimac.net|w3 JMail|1|"
 com = com & "|.|" & "w3sitetree.tree|http://www.dimac.net|w3 Site Tree : www.dimac.net|0|"
 com = com & "|.|" & "w3.upload|http://www.dimac.net|w3 Upload|3|"
 com = com & "|.|" & "w3.netutils|http://www.dimac.net|w3 Utils|0|"
 com = com & "|.|" & "Socket.TCP|http://www.dimac.net|w3 Sockets|0|"
 com = com & "|.|" & "w3.netutils|http://www.dimac.net|w3 NetDebug|0|"
 com = com & "|.|" & "Persits.MailSender|http://www.persits.com|Persits - ASPEmail|1|"
 com = com & "|.|" & "Persits.Upload.1|http://www.persits.com|Persits - ASPUpload|3|"
 com = com & "|.|" & "Persits.Jpeg|http://www.persits.com|Persits - AspJpeg|4|"
 com = com & "|.|" & "Persits.Grid|http://www.persits.com|Persits - AspGrid|0|"
 com = com & "|.|" & "Persits.AspUser|http://www.persits.com|Persits - AspUser|9|"
 com = com & "|.|" & "Persits.CryptoManager|http://www.persits.com|Persits - AspEncrypt|9|"
 com = com & "|.|" & "ADISCON.SimpleMail.1|http://www.simplemail.adiscon.com/en|SimpleMail|1|"
 com = com & "|.|" & "CalendarCom.CalendarStuff|http://www.devguru.com|DevGuru - dgcalendar|0|"
 com = com & "|.|" & "dgEncrypt.Key|http://www.devguru.com|DevGuru - dgEncrypt|9|"
 com = com & "|.|" & "dgFileUpload.dgUpload|http://www.devguru.com|DevGuru - dgFileup|3|"
 com = com & "|.|" & "dgReport.Report|http://www.devguru.com|DevGuru - dgReport|0|"
 com = com & "|.|" & "dgSort.QuickSort|http://www.devguru.com|DevGuru - dgSort|0|"
 com = com & "|.|" & "dgTree.Tree|http://www.devguru.com|DevGuru - dgTree|0|"
 com = com & "|.|" & "Dundas.Mailer|http://www.dundas.com|Dundas - ASPMailer|1|"
 com = com & "|.|" & "Dundas.PieChartServer.2|http://www.dundas.com|Dundas - Pie Chart Server Control|7|" 
 com = com & "|.|" & "Dundas.Upload|http://www.dundas.com|Dundas - Upload|3|"
 com = com & "|.|" & "EasyMail.SMTP.5|http://www.quiksoft.com|Quicksoft - EasyMail (free)|1|"
 com = com & "|.|" & "AspPing.Conn|http://www.15seconds.com/component/pg000229.htm|ASP Ping|0|"
 com = com & "|.|" & "Dynu.CreditCard|http://www.dynu.com|Dynu CreditCard|10|11"
 com = com & "|.|" & "Dynu.DateTime|http://www.dynu.com|Dynu DateTime|0|"
 com = com & "|.|" & "Dynu.DNS|http://www.dynu.com|Dynu DNS|0|"
 com = com & "|.|" & "Dynu.Exec|http://www.dynu.com|Dynu Exec|0|"
 com = com & "|.|" & "Dynu.Email|http://www.dynu.com|Dynu Email|1|"
 com = com & "|.|" & "Dynu.Encrypt|http://www.dynu.com|Dynu Encrypt|9|"
 com = com & "|.|" & "Dynu.FileUtil|http://www.dynu.com|Dynu File|6|"
 com = com & "|.|" & "Dynu.FTP|http://www.dynu.com|Dynu FTP|0|6"
 com = com & "|.|" & "Dynu.HTTP|http://www.dynu.com|Dynu HTTP|0|"
 com = com & "|.|" & "Dynu.POP3|http://www.dynu.com|Dynu POP3|1|"
 com = com & "|.|" & "Dynu.Ping|http://www.dynu.com|Dynu Ping|0|"
 com = com & "|.|" & "Dynu.TCPSocket|http://www.dynu.com|Dynu TCPSocket|0|"
 com = com & "|.|" & "Dynu.StringUtil|http://www.dynu.com|Dynu String|0|"
 com = com & "|.|" & "Dynu.Upload|http://www.dynu.com|Dynu Upload|3|"
 com = com & "|.|" & "Dynu.Wait|http://www.dynu.com|Dynu Wait|0|"
 com = com & "|.|" & "Dynu.Whois|http://www.dynu.com|Dynu Whois|0|"
 com = com & "|.|" & "MP_Mikys_ASP.Password|http://www.mikys-asp.nykoping.net/Password|ASP Password|9|"
 com = com & "|.|" & "S3Weather.Current|http://www.softshell.net|S3 Weather Component (free)|0|"
 com = com & "|.|" & "AuthNetSSLConnect.SSLPost|http://www.authorize.net|Authorize.Net Transaction COM (free)|10|11"
 com = com & "|.|" & "HexValidEmail.Connection|http://www.hexillion.com|Hexillion - HexValidEmail|1|11"
 com = com & "|.|" & "Hexillion.HexIcmp|http://www.hexillion.com|Hexillion - HexIcmp|0|"
 com = com & "|.|" & "Hexillion.HexLookup|http://www.hexillion.com|Hexillion - HexLookup|0|"
 com = com & "|.|" & "Hexillion.HexTcpQuery|http://www.hexillion.com|Hexillion - HexTcpQuery|0|"
 com = com & "|.|" & "HexDns.Connection|http://www.hexillion.com|Hexillion - HexDSN|0|"
 com = com & "|.|" & "ocxQmail.ocxQmailCtrl.1|http://www.flicks.com|Flicks - ocxQmail|1|"
 com = com & "|.|" & "OCXHTTP.OCXHttpCtrl.1|http://www.flicks.com|Flicks - OCXHttp|0|"
 com = com & "|.|" & "ocxQmail.ocxQmailCtrl.1|http://www.flicks.com|Flicks - OCXQMail|1|"
 com = com & "|.|" & "VASPTV.ASPTreeView|http://www.visualasp.com|VisualASP - TreeView|0|"
 com = com & "|.|" & "VASPLV.ASPListView|http://www.visualasp.com|VisualASP - ListView|0|"
 com = com & "|.|" & "VASPMV.ASPMonthView|http://www.visualasp.com|VisualASP - MonthView|0|"
 com = com & "|.|" & "VASPTB.ASPTabView|http://www.visualasp.com|VisualASP - TabView|0|"
 com = com & "|.|" & "ASPWordToy.WordToy|http://www.asptoys.com|ASP Toys - WordToy (Word Converter)|6|"
 com = com & "|.|" & "ASPTabToy.TabToy|http://www.asptoys.com|ASP Toys - TabToy|0|"
 com = com & "|.|" & "aspZipCodeToy.ZipCodeToy|http://www.asptoys.com|ASP Toys - ASP ZipCodeToy|0|11"
 com = com & "|.|" & "ASPCryptToy.CryptToy|http://www.asptoys.com|ASP Toys - CryptToy|9|"
 com = com & "|.|" & "Convert.t2h|http://members.home.net/pjsteele/asp|CONVERT - string/html/text manipulation (free)|0|"
 com = com & "|.|" & "APDocConv.Object|http://www.activepdf.com|activePDF - DocConverter|5|"
 com = com & "|.|" & "APWebGrabber.Object|http://www.activepdf.com|activePDF - WebGrabber|5|"
 com = com & "|.|" & "APServer.Object|http://www.activepdf.com|activePDF - activePDF Server|5|"
 com = com & "|.|" & "APSpool.Object|http://www.activepdf.com|activePDF - Spooler|5|"
 com = com & "|.|" & "APToolkit.Object|http://www.activepdf.com|activePDF - Toolkit|5|"
 com = com & "|.|" & "shotgraph.image|http://www.shotgraph.com|Shot Graph|7|"
 com = com & "|.|" & "IntrChart.Chart|http://www.compsysaus.com.au|IntrChart|7|"
 com = com & "|.|" & "IntrSQL.Query|http://www.compsysaus.com.au|IntrSQL|0|"
 com = com & "|.|" & "IntrPWD.Validate|http://www.compsysaus.com.au|IntrPWD|9|"
 com = com & "|.|" & "IntrCard.Credit|http://www.compsysaus.com.au|IntrCard|0|11"
 com = com & "|.|" & "AspSmartImage.SmartImage|http://www.aspsmart.com|ASP Smart - aspSmartImage|4|"
 com = com & "|.|" & "AspSmartChat.SmartChat|http://www.aspsmart.com|ASP Smart - aspSmartChat|0|"
 com = com & "|.|" & "AspSmartFile.SmartFile|http://www.aspsmart.com|ASP Smart - aspSmartFile|6|"
 com = com & "|.|" & "aspSmartMenu.SmartMenuPopUp|http://www.aspsmart.com|ASP Smart - aspSmartMenu|0|"
 com = com & "|.|" & "AspSmartDate.SmartDate|http://www.aspsmart.com|ASP Smart - aspSmartDate|0|"
 com = com & "|.|" & "AspSmartUpload.SmartUpload|http://www.aspsmart.com|ASP Smart - aspSmartUpload|3|"
 com = com & "|.|" & "aspSmartMail.SmartMail|http://www.aspsmart.com|ASP Smart - aspSmartMail|1|"
 com = com & "|.|" & "aspSmartCache.SmartCache|http://www.aspsmart.com|ASP Smart - aspSmartCache|0|"
 com = com & "|.|" & "xAuthorize.Charge|http://www.xauthorize.com|xAuthorize CC|10|11"
 com = com & "|.|" & "acDesktop.Desktop|http://www.activecomponents.nu|acDesktop|0|"
 com = com & "|.|" & "acNetwork.DNS|http://www.activecomponents.nu|acNetwork|0|"
 com = com & "|.|" & "acSMTP.Smtp|http://www.activecomponents.nu|acSMTP SSL|9|"
 com = com & "|.|" & "Temperature.Conversion|http://asp.myscripting.com/activextemp.asp|Temperature Conversion|0|"
 com = com & "|.|" & "cyScape.browserObj|http://www.cyscape.com|BrowserHawk|2|11"
 com = com & "|.|" & "dkQmail.Qmail||dkQMail|1|"
 com = com & "|.|" & "Geocel.Mailer|http://www.geocel.com|GeoCel|1|"
 com = com & "|.|" & "iismail.iismail.1||IISMail|1|"
 com = com & "|.|" & "SmtpMail.SmtpMail.1||SMTP|1|"
 com = com & "|.|" & "OpenX2.Connection|http://www.openx.ca|OpenX|1|"
 com = com & "|.|" & "ABMailer.Mailman|http://www.absoftwarex.com/abmailer|ABMailer|1|"
 com = com & "|.|" & "c2geread.Message|http://www.componentstogo.com|C2GEread|1|"
 com = com & "|.|" & "C2G.SCM|http://www.componentstogo.com|C2GSCM|0|8"
 com = com & "|.|" & "C2GSCM.Service|http://www.componentstogo.com|C2GSCM|8|0"
 com = com & "|.|" & "C2G.SCAN|http://www.componentstogo.com|C2GSCAN|0|"
 com = com & "|.|" & "C2G.whois|http://www.componentstogo.com|C2GWHOIS |0|"
 com = com & "|.|" & "c2g.http|http://www.componentstogo.com|C2GHttp |0|"
 com = com & "|.|" & "C2G.Ping|http://www.componentstogo.com|C2GPing|0|"
 com = com & "|.|" & "C2G.Tracert|http://www.componentstogo.com|C2GTracert|0|"
 com = com & "|.|" & "ANUPLOAD.OBJ|http://www.adminsystem.net/webapp/popcom|ANPOP|1|"
 com = com & "|.|" & "ASPXP.Mail|http://aspxp.com/free_stuff/aspxpmail|ASPXPMail (free)|1|"
 com = com & "|.|" & "ActiveMessenger.Message|http://www.infomentum.com|ActiveMessenger|1|"
 com = com & "|.|" & "ActiveFile.Post|http://www.infomentum.com|ActiveFile|3|"
 com = com & "|.|" & "ActiveNavigator.Toolbar|http://www.infomentum.com|ActiveNavigator|0|"
 com = com & "|.|" & "ActiveProfile.Profile|http://www.infomentum.com|ActiveProfile|2|9"
 com = com & "|.|" & "DartZip.Zip.1|http://www.dart.com|Dart Zip Compression Tool|6|"
 com = com & "|.|" & "Dart.Ftp.1|http://www.dart.com|Dart FTP Tool|6|0"
 com = com & "|.|" & "Dart.Pop.1|http://www.dart.com|Dart POP Mail|1|"
 com = com & "|.|" & "Dart.Ping.1|http://www.dart.com|Dart Ping|0|"
 com = com & "|.|" & "Dart.Dns.1|http://www.dart.com|Dart DNS|0|"
 com = com & "|.|" & "Dart.Smtp.1|http://www.dart.com|Dart SMTP|1|"
 com = com & "|.|" & "Dart.Telnet.1|http://www.dart.com|Dart PowerTCP Telnet Tool|0|"
 com = com & "|.|" & "Dart.Http.1|http://www.dart.com|Dart HTTP|0|"
 com = com & "|.|" & "Dart.Tcp.1|http://www.dart.com|Dart TCP|0|"
 com = com & "|.|" & "Dart.WebPage.1|http://www.dart.com|Dart WebPage|0|"
 com = com & "|.|" & "Dart.WebASP.1|http://www.dart.com|Dart ASP|0|"
 com = com & "|.|" & "Dart.Message.1|http://www.dart.com|Dart Message|0|"
 com = com & "|.|" & "Dart.Manager.1|http://www.dart.com|Dart Manager|0|"
 com = com & "|.|" & "quicktab.quicktabs|http://www.webintel.net|Quicktab|0|"
 com = com & "|.|" & "waspzip.waspzip|http://www.webintel.net|Wasp Zip|6|5"
 com = com & "|.|" & "easyBarCode.aspBarCode|http://www.mitdata.com|aspEasyBarCode|7|0"
 com = com & "|.|" & "aspZip.EasyZIP|http://www.mitdata.com|aspEasyZIP|6|5"
 com = com & "|.|" & "aspPDF.EasyPDF|http://www.mitdata.com|aspEasyPDF|5|6"
 com = com & "|.|" & "aspCrypt.EasyCRYPT|http://www.mitdata.com|aspEasyCRYPT|9|"
 com = com & "|.|" & "objBarGraph.DrawChart|http://www.livesoup.com/bargraph.asp|BarGraph (free)|7|"
 com = com & "|.|" & "LyfUpload.UploadFile|http://www.21jsp.com|LyfUpload (free)|3|"
 com = com & "|.|" & "lyfimage.image|http://www.21jsp.com|LyfImage (free)|4|7"
 com = com & "|.|" & "ASPControlHost.Host|http://release-systems.8m.com/asphost.html|ASPControlHost|7|4"
 com = com & "|.|" & "GSServer.GSServerProp|http://www.graphicsserver.com|Graphics Server|4|7"
 com = com & "|.|" & "ASPPicture.Picture|http://www.unchanged.net|ASPPicture|4|"
 com = com & "|.|" & "COMobjectsNET.IconGrabber|http://www.comobjects.net|COMobjects.NET Icon Grabber|4|"
 com = com & "|.|" & "COMobjects.NET.PictureProcessor|http://www.comobjects.net|COMobjects.NET Picture Processor|4|"
 com = com & "|.|" & "COMobjectsNET.PictureGalleryPro|http://www.comobjects.net|COMobjects.NET Picture Gallery Pro|4|"
 com = com & "|.|" & "COMobjectsNET.Colorizer|http://www.comobjects.net|COMobjects.NET Colorizer|4|"
 com = com & "|.|" & "COMobjectsNET.PieChart|http://www.comobjects.net|COMobjects.NET 3D Pie Chart|7|4"
 com = com & "|.|" & "ChartDirector.API|http://www.advsofteng.com|ChartDirector|7|"
 com = com & "|.|" & "Stonebroom.ASPointer|http://www.stonebroom.com|Stonebroom.ASPointer|13|5"
 com = com & "|.|" & "Stonebroom.ASP2XML|http://www.stonebroom.com|Stonebroom.ASP2XML|13|5"
 com = com & "|.|" & "Stonebroom.RegEx|http://www.stonebroom.com|Stonebroom.RegEx|0|"
 com = com & "|.|" & "Stonebroom.RemoteZip|http://www.stonebroom.com|Stonebroom.RemoteZip|5|6"
 com = com & "|.|" & "Stonebroom.SaveForm|http://www.stonebroom.com|Stonebroom.SaveForm|12|"
 com = com & "|.|" & "Stonebroom.ServerZip|http://www.stonebroom.com|Stonebroom.ServerZip|5|6"
 com = com & "|.|" & "Stonebroom.XSLTransform|http://www.stonebroom.com|Stonebroom.XSLTransform|13|5"
 com = com & "|.|" & "OpenX.DBMail|http://www.openx.ca|OpenX DBMail|1|12"
 com = com & "|.|" & "com.comsoltech.CGI|http://www.comsoltech.com|com.comsoltech.CGI (free)|12|"
 com = com & "|.|" & "Datafun.FormBoy|http://www.datafun.net|FormBoy|12|10"
 com = com & "|.|" & "AddressTools.ZIPCheck|http://www.addresstools.com|AddressTools - ZIPCheck|11|12"
 com = com & "|.|" & "AddressTools.EmailCheck|http://www.addresstools.com|AddressTools - EmailCheck|11|12"
 com = com & "|.|" & "VisualSoft.Mail.1|http://www.visualmart.com|VisualSoft Mail|1|"
 com = com & "|.|" & "VisualSoft.BLOWFISHCrypt.1|http://www.visualmart.com|VisualSoft Crypt|9|"
 com = com & "|.|" & "VisualSoft.FTP.1|http://www.visualmart.com|VisualSoft FTP|6|0"
 com = com & "|.|" & "VisualSoft.HTTP.1|http://www.visualmart.com|VisualSoft HTTP|2|0"
 com = com & "|.|" & "VisualSoft.Chart.1|http://www.visualmart.com|VisualSoft Chart|7|"
 com = com & "|.|" & "VisualSoft.DMXML.1|http://www.visualmart.com|VisualSoft XMLPro|13|"
 com = com & "|.|" & "VisualSoft.DataAdmin.1|http://www.visualmart.com|VisualSoft DataAdmin|0|"
 com = com & "|.|" & "QwerkSoft.FormSlam|http://www.qwerksoft.com|Form Slam|12|11"
 com = com & "|.|" & "MSWC.NextLink|http://msdn.microsoft.com/library/en-us/iisref/html/psdk/asp/comp7pmc.asp|Microsoft Content Linking Component|0|"
 com = com & "|.|" & "MSWC.BrowserType|http://msdn.microsoft.com/library/default.asp?url=/library/en-us/iisref/html/psdk/asp/comp3xx0.asp|Microsoft Browser Capability|2|"
 com = com & "|.|" & "MSWC.ContentRotator|http://msdn.microsoft.com/library/en-us/iisref/html/psdk/asp/comp09dg.asp|Microsoft Content Rotator|0|"
 com = com & "|.|" & "MSWC.AdRotator|http://msdn.microsoft.com/library/en-us/iisref/html/psdk/asp/comp59f8.asp|Microsoft Ad Rotator|0|"
 com = com & "|.|" & "MSWC.PermissionChecker|http://msdn.microsoft.com/library/en-us/iisref/html/psdk/asp/comp3hf8.asp|Microsoft Permission Checker Component|0|"
 com = com & "|.|" & "MSWC.Status|http://msdn.microsoft.com/library/en-us/iisref/html/psdk/asp/comp1qt0.asp|Microsoft Status Component|0|"
 com = com & "|.|" & "MSWC.Tools|http://msdn.microsoft.com/library/en-us/iisref/html/psdk/asp/comp7g8k.asp|Microsoft Tools Component|0|"
 com = com & "|.|" & "MSWC.PageCounter|http://msdn.microsoft.com/library/en-us/iisref/html/psdk/asp/comp00vo.asp|Microsoft Page Counter Component|0|"
 com = com & "|.|" & "MSWC.IISLog|http://msdn.microsoft.com/library/en-us/iisref/html/psdk/asp/comp6i5w.asp|Microsoft Logging Utility Component|0|"
 com = com & "|.|" & "MSXML2.ServerXMLHTTP|http://msdn.microsoft.com/library/en-us/xmlsdk30/htm/xmobjxmldomserverxmlhttp_using_directly.asp|Microsoft ServerXMLHTTP|13|"
 com = com & "|.|" & "Microsoft.XMLDOM|http://www.microsoft.com|Microsoft XMLDOM Component|13|"
 com = com & "|.|" & "Microsoft.XMLHTTP|http://www.microsoft.com|Microsoft XMLHTTP Component|13|"
 com = com & "|.|" & "Scripting.FileSystemObject|http://www.microsoft.com|MicrosoftFileSystem Object|6|"
 com = com & "|.|" & "WScript.Shell|http://www.microsoft.com|Windows Script Shell|0|"
 com = com & "|.|" & "WScript.Network|http://www.microsoft.com|Windows Script Network|0|"
 com = com & "|.|" & "ADODB.Connection|http://www.microsoft.com|ADODB.Connection|0|"
 com = com & "|.|" & "ADODB.Command|http://www.microsoft.com|ADODB.Command|0|"
 com = com & "|.|" & "ADODB.Recordset|http://www.microsoft.com|ADODB.Recordset|0|"
 com = com & "|.|" & "Scripting.Dictionary|http://www.microsoft.com|Scripting.Dictionary|0|"
 com = com & "|.|" & "SiteAdmin.AdminTools|http://components.sitetown.com|SiteSecurity|9|"
 com = com & "|.|" & "SiteSecurity.Login|http://components.sitetown.com|SiteSecurity|9|"
 com = com & "|.|" & "FileDownload.Manager|http://components.sitetown.com|File Download|6|0"
 com = com & "|.|" & "EasyDb.Database|http://components.sitetown.com|Easy DB|0|"
 com = com & "|.|" & "AbsoluteHttp.Conn|http://www.speeq.com|AbsoluteHTTP|0|"
 com = com & "|.|" & "ASPCharge.CC|http://www.bluesquirrel.com|A$PCharge|10|11"
 com = com & "|.|" & "ProjectDisplay.Charts|http://www.aspkey.com|ASPkey ProjectDisplay|0|"
 com = com & "|.|" & "IPWorksASP.SOAP|http://www.nsoftware.com|IP Works Soap|13|"
 com = com & "|.|" & "IPWorksASP.FileMailer|http://www.nsoftware.com|IP Works FileMailer|1|6"
 com = com & "|.|" & "IPWorksASP.FTP|http://www.nsoftware.com|IP Works FTP|0|"
 com = com & "|.|" & "IPWorksASP.HTMLMailer|http://www.nsoftware.com|IP Works HTMLMailer|1|"
 com = com & "|.|" & "IPWorksASP.HTTP|http://www.nsoftware.com|IP Works HTTP|13|0"
 com = com & "|.|" & "IPWorksASP.ICMPPort|http://www.nsoftware.com|IP Works ICMPPort|0|"
 com = com & "|.|" & "IPWorksASP.IMAP|http://www.nsoftware.com|IP Works IMAP|0|"
 com = com & "|.|" & "IPWorksASP.IPInfo|http://www.nsoftware.com|IP Works IPInfo|0|"
 com = com & "|.|" & "IPWorksASP.IPPort|http://www.nsoftware.com|IP Works IPPort|0|"
 com = com & "|.|" & "IPWorksASP.LDAP|http://www.nsoftware.com|IP Works LDAP|0|"
 com = com & "|.|" & "IPWorksASP.MCast|http://www.nsoftware.com|IP Works MCast|0|"
 com = com & "|.|" & "IPWorksASP.MIME|http://www.nsoftware.com|IP Works MIME|1|"
 com = com & "|.|" & "IPWorksASP.MX|http://www.nsoftware.com|IP Works MX|1|"
 com = com & "|.|" & "IPWorksASP.NetClock|http://www.nsoftware.com|IP Works NetClock|0|"
 com = com & "|.|" & "IPWorksASP.NetCode|http://www.nsoftware.com|IP Works NetCode|0|"
 com = com & "|.|" & "IPWorksASP.NetDial|http://www.nsoftware.com|IP Works NetDial|0|"
 com = com & "|.|" & "IPWorksASP.NNTP|http://www.nsoftware.com|IP Works NNTP|0|"
 com = com & "|.|" & "IPWorksASP.Ping|http://www.nsoftware.com|IP Works Ping|0|"
 com = com & "|.|" & "IPWorksASP.POP|http://www.nsoftware.com|IP Works POP|1|"
 com = com & "|.|" & "IPWorksASP.RCP|http://www.nsoftware.com|IP Works RCP|6|0"
 com = com & "|.|" & "IPWorksASP.Rexec|http://www.nsoftware.com|IP Works Rexec|0|"
 com = com & "|.|" & "IPWorksASP.Rshell|http://www.nsoftware.com|IP Works Rshell|0|"
 com = com & "|.|" & "IPWorksASP.SMTP|http://www.nsoftware.com|IP Works SMTP|1|"
 com = com & "|.|" & "IPWorksASP.SNMP|http://www.nsoftware.com|IP Works SNMP|1|0"
 com = com & "|.|" & "IPWorksASP.SNPP|http://www.nsoftware.com|IP Works SNPP|13|0"
 com = com & "|.|" & "IPWorksASP.Telnet|http://www.nsoftware.com|IP Works Telnet|0|"
 com = com & "|.|" & "IPWorksASP.TFTP|http://www.nsoftware.com|IP Works TFTP|0|"
 com = com & "|.|" & "IPWorksASP.TraceRoute|http://www.nsoftware.com|IP Works TraceRoute|0|"
 com = com & "|.|" & "IPWorksASP.UDPPort|http://www.nsoftware.com|IP Works UDPPort|0|"
 com = com & "|.|" & "IPWorksASP.WebForm|http://www.nsoftware.com|IP Works WebForm|12|"
 com = com & "|.|" & "IPWorksASP.WebUpload|http://www.nsoftware.com|IP Works WebUpload|3|"
 com = com & "|.|" & "IPWorksASP.Whois|http://www.nsoftware.com|IP Works Whois|0|"
 com = com & "|.|" & "IPWorksASP.XMLp|http://www.nsoftware.com|IP Works XMLp|13|"
 'com = com & "|.|" & "||||"
 'com = com & "|.|" & "||||"
 com = Split(com, "|.|")

 cat = "Miscelanea"
 cat = cat & "|Email"
 cat = cat & "|Browser"
 cat = cat & "|Upload"
 cat = cat & "|Imagem"
 cat = cat & "|Documentação"
 cat = cat & "|Manipulação de Arquivos"
 cat = cat & "|Gráficos "
 cat = cat & "|Gerenciamento de Usuários"
 cat = cat & "|Usuários & Segurança"
 cat = cat & "|E-Commerce"
 cat = cat & "|Validação"
 cat = cat & "|Formulários"
 cat = cat & "|XML"
 cat = Split(cat, "|")

 if (showCat > UBound(cat)) then showCat = "all"

 ' INI: Functions ------------------------------------------------------
 function IsObjInstalled(strClassString)
 Dim testObj
 IsObjInstalled = false : Err = 0
	 Set testObj = Server.CreateObject(strClassString)
	 if (0 = Err) then IsObjInstalled = true else IsObjInstalled = false
	 Set testObj = nothing
 end function

 Class Program
	Public Description, ClsID, ProgID, Path, TypeLib, Version, DLLName
 End Class

 Class ProgIDInfo
	Private WshShell, sCVProgID, oFSO

	Private Sub Class_Initialize()
		On Error Resume Next
		set oFSO = CreateObject("Scripting.FileSystemObject")
		Set WshShell = CreateObject("WScript.Shell")
	End Sub

	Private Sub Class_Terminate()
		If IsObject(WshShell) Then Set WshShell = Nothing
		If IsObject(oFSO) Then set oFSO = Nothing
	End Sub

	Private Function IIf(byval conditions, byval trueval, byval falseval)
		if cbool(conditions) then IIf = trueval else IIf = falseval
	End Function

	Public Function LoadProgID(ByVal sProgramID)
		Dim sTmpProg, oTmp, sRegBase, sDesc, sClsID
		Dim sPath, sTypeLib, sProgID, sVers, sPathSpec
		If IsObject(WshShell) Then
			On Error Resume Next
			sCVProgID = WshShell.RegRead("HKCR\" & _
				sProgramID & "\CurVer\")
			sTmpProg = IIf(Err.Number = 0, sCVProgID, sProgramID)

			sRegBase = "HKCR\" & sTmpProg
			sDesc = WshShell.RegRead(sRegBase & "\")
			sClsID = WshShell.RegRead(sRegBase & "\clsid\")
			sRegBase = "HKCR\CLSID\" & sClsID
			sPath = WshShell.RegRead(sRegBase & "\InprocServer32\")
			sPath = WshShell.ExpandEnvironmentStrings(sPath)
			sTypeLib = WshShell.RegRead(sRegBase & "\TypeLib\")
			sProgID = WshShell.RegRead(sRegBase & "\ProgID\")
			sVers = oFSO.getFileVersion(sPath)
			sPathSpec = right(sPath, len(sPath) - _
				instrrev(sPath, "\"))

			Set oTmp = New Program
			oTmp.Description = sDesc
			oTmp.ClsID = IIf(sClsID <> "", sClsID, "undetermined")
			oTmp.Path = IIf(sPath <> "", sPath, "undetermined")
			oTmp.TypeLib = IIf(sTypeLib <> "", _
				sTypeLib, "undetermined")
			oTmp.ProgID = IIf(sProgID <> "", _
				sProgID, "undetermined")
			oTmp.DLLName = IIf(sPathSpec <> "", _
				sPathSpec, "undetermined")
			oTmp.Version = IIf(sVers <> "", sVers, "undetermined")
			Set LoadProgID = oTmp
		Else
			Set LoadProgID = Nothing
		End If
	End Function
 End Class

 function getHTML(strURL)
  dim objXMLHTTP, strReturn
  Set objXMLHTTP = SErver.CreateObject("Microsoft.XMLHTTP")
  objXMLHTTP.Open "GET", strURL, False
  objXMLHTTP.Send
  getHTML = objXMLHTTP.responseText
  Set objXMLHTTP = Nothing
 end function
 ' FIM: Functions ------------------------------------------------------
%>
<HTML>
<HEAD>
<TITLE>ASP Component Test  - http://www.pensaworks.com</TITLE>
<SCRIPT language=JavaScript>
<!--
function BringUpWindow(webpage) {
     var url = webpage;
     var hWnd = window.open(url,"VBoss_Mailer_Popup","width=425,height=325,resizable=yes,scrollbars=yes,status=yes");
	 if (window.focus) {hWnd.focus()}
     if (hWnd != null) {
	      if (hWnd.opener == null) {
		   hWnd.opener = self; window.name = "home"; 
		   hWnd.location.href=url; 
		   }
	 } else {		
    }
   }
// -->
</SCRIPT>
</HEAD>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body bgcolor="#ffffff" topmargin="0" bottommargin="0" leftmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
<%
if request("comID") <> "" then
 comID      = request("comID")
 comDetails = Split(com(comID), "|")
 comCreate  = comDetails(0)
 comURL     = comDetails(1)
 comName    = comDetails(2)
 comCat     = comDetails(3)
 comCat2    = comDetails(4)
%>
<table border="0" cellpadding="2" cellspacing="0" width="100%" class="tablesort">
  <thead>
  <tr>
    <th width="100"></th>
    <th>Dados</th>
  </tr>
  </thead>
  <tbody style="text-align:left;">
	<%
	Set b = New ProgIDInfo
	Set a = b.LoadProgID(comCreate)
	if a.Description <> "" then
	%>
		<tr><td style="text-align:right">Componente</td><td><%=comName%></td></tr>
		<tr><td style="text-align:right">Website</td><td><% if comURL <> "" then %><a href="<%=comURL%>" target="_blank"><%=comURL%></a><% end if %></td></tr>
		<tr><td style="text-align:right">Categoria(s)</td><td><%=cat(comCat)%><% if comCat2 <> "" then %> | <%=cat(comCat2)%><% end if %></td></tr>
		<tr><td style="text-align:right">Descrição</td><td><%= a.Description %></td></tr>
	    <tr><td style="text-align:right">Nome da DLL</td><td><%=a.DLLName%></td></tr>
		<tr><td style="text-align:right">ProgID</td><td><%=a.ProgID%></td></tr>
		<tr><td style="text-align:right">ClsID</td><td><%=a.ClsID%></td></tr>
		<tr><td style="text-align:right">Path</td><td><%=a.Path%></td></tr>
		<tr><td style="text-align:right">TypeLib</td><td><%=a.TypeLib%></td></tr>
		<tr><td style="text-align:right">Versão</td><td><%=a.Version%></td></tr>
    <% else %>
	<tr><td colspan="2"><b>Informação não Encontrada para o componente:</b> <%=comName%></td></tr>
    <% end if %>
  </tbody>
</table>
<% else %>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <thead>
  <tr>
    <th width="1%"></th>
    <th width="20%" class="sortable">Categoria</th>
    <th width="70%" class="sortable">Componente</th>
    <th width="10%" class="sortable">Detalhes</th>
    <th width="10%" class="sortable">Status</th>
  </tr>
  </thead>
  <tbody style="text-align:left;">
  <%
	for i = 0 to UBound(com)
		comDetails = split(com(i), "|")
		display    = false
		display2   = false
		comCreate  = comDetails(0)
		comURL     = comDetails(1)
		comName    = comDetails(2)
		comCat     = CInt(comDetails(3))
		if isNumeric(comDetails(4))  then
		  comCat2 = CInt(comDetails(4))
		else
		  comCat2 = comDetails(4)
		end if
		installed  = IsObjInstalled(comCreate)
			if show = 2 then
				if (NOT Installed) then display = false else display = true
			elseif show = 3 then
				if (NOT Installed) then display = true else diusplay = false
			else
				display = true
			end if
			if isnumeric(showCat) then
				if (comCat = showCat or comCat2 = showCat) then display2 = true else display2 = false
			else
				display2 = true
			end if

	if (display AND display2) then
	onNum = onNum + 1

    strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
  %>
  <tr bgcolor="<%=strCOLOR%>">
    <td><%=(onNum)%></td>
    <td><% if IsNumeric(showCat) then response.write cat(showCat) else response.write cat(comCat) end if %></td>
    <td><% if comURL <> "" then %><a href="<%=comURL%>" target="_blank"><%=comName%></a><% else %><%=comName%><% end if %></td>
    <td nowrap="nowrap"><% if NOT installed then  
	         response.write "Não Avaliado" 
		   else 
	    %>
          <a href="Javascript:BringUpWindow('<%=Mid(request.servervariables("SCRIPT_NAME"), InstrRev(request.servervariables("SCRIPT_NAME"), "/") + 1)%>?comID=<%=i%>')">COM Detalhes</a>
        <% end if %>
    </td>
    <td nowrap="nowrap"><% if NOT installed then 
			 response.write ("<font color='#FF0000'>Não Instalado</font>")
		   else
		     installedCOMs = installedComs + 1
		     response.write ("<font color='#009933'>Instalado</font>")
	       end if %>
    </td>
  </tr>
  <%
  end if
  installed = "" : comCreate = "" : comURL = "" : comName = "" : comCat = "" : comCat2 = ""
  next
  response.flush()
  %>
<% if onNum = 0 then %>
  <tr>
    <td colspan="5"><b>Não foi possível identificar componentes instalados.</b></td>
  </tr>
<% end if %>
</tbody>
<tfoot>
  <tr>
    <td colspan="5"> 
	  Você tem <b><%=installedCOMs%></b> COMs instalados num total de <b><%=onNum%></b> filtrados.
      Atualmente, este certificado verifica se há <b><%=(UBound(com) + 1)%></b> componentes diferentes
    </td>
  </tr>
</tfoot>
</table>
<% end if %>
</BODY>
</HTML>
