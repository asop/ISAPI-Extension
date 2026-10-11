unit hmls;

interface

Const
  crlf = #13#10;
  html =
'<!DOCTYPE html>'+CRLF+
'<html lang="en">'+CRLF+
'  <head>'+CRLF+
'    <meta charset="utf-8">'+CRLF+
'    <meta name="description" content="" >'+CRLF+
'    <meta name="author" content="">'+CRLF+
'    <meta name="keywords" content="">'+CRLF+
'    <meta http-equiv="X-UA-Compatible" content="IE=edge">'+CRLF+
'    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">'+CRLF+
'    <link rel="icon" href="favicon.ico" type="image/x-icon">'+CRLF+
'	<title>Internet Server API (ISAPI)</title>'+CRLF+
'	<style>'+CRLF+
'		html,body{font-family:fangsong;margin: 0px;}'+CRLF+
'		h2{margin:0;}hr{opacity: 0.3;}'+CRLF+
'		.header{background:#e9e9e9;color:#020202;padding:10px;height:50px;}'+CRLF+
'		.body{font-family:sans-serif;padding:10px;padding-top:0px;}'+CRLF+
'   .serverVar{font-family:monospace;font-size:12px;}'+CRLF+
'	</style>'+CRLF+
' </head>'+CRLF+
' <body>'+CRLF+
'  <div class="header"><h2>Internet Server API (ISAPI)</h2>'+CRLF+
'  <code>Internet Application Programming Interface (ISAPI)</code></div><hr>'+CRLF+
'  <div class="body">'+CRLF+
'	<p>The Microsoft Internet Application Programming Interface (ISAPI) is a '+
'high-performance alternative to Common Gateway Interface (CGI) executable files.'+CRLF+
'</div>'+CRLF+
'</body>'+CRLF+
'</html>'+CRLF;

implementation

end.
