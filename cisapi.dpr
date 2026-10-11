library cisapi;

uses
  SysUtils,
  Classes,
  Windows,
  Messages,
  ComObj,
  HTTPAppModify in 'HTTPAppModify.pas',
  Isapi2 in 'Isapi2.pas',
  IsapiReqRes in 'IsapiReqRes.pas',
  hmls in 'hmls.pas';

{$R *.res}

var
  Title: string;
  ISapiHandleException: procedure (Sender: TObject) of object = nil;

function GetExtensionVersion(var Ver: THSE_VERSION_INFO): Boolean; stdcall;
begin
  try
    Ver.dwExtensionVersion := MakeLong(HSE_VERSION_MINOR, HSE_VERSION_MAJOR);
    StrLCopy(Ver.lpszExtensionDesc, PChar(Title), HSE_MAX_EXT_DLL_NAME_LEN);
    Result:= Boolean(1);
  except
    Result := False;
  end;
end;

function GetArgs(E:PEXTENSION_CONTROL_BLOCK):String;
const CR = '<br>';
Begin
  Result:=
    Format('CommandLine : <br><div style="background:#dbdbdb;padding:5px;margin:2px;"><code>%s</code></div>', [GetCommandLine]) +CR+CR+
    Format('%s: %s', ['size of this struct', FormatCurr('#,###', E^.cbSize)]) +CR+
    Format('%s: %d.%d', ['Version info of this spec', LoWord(E^.dwVersion), HiWord(E^.dwVersion)]) +CR+
    Format('%s: 0x%x', ['Context number not to be modified', E^.ConnID])+CR+
    Format('%s: %d', ['HTTP Status code', E^.dwHttpStatusCode])+CR+
    'null terminated log info specific to this Extension DLL'+CR+
    Format('%s: %s', ['LogData', PChar(@E^.lpszLogData)])+CR+
    Format('%s: %s', ['REQUEST_METHOD', E^.lpszMethod])+CR+
    Format('%s: %s', ['QUERY_STRING', HTTPDecode(E^.lpszQueryString)])+CR+
    Format('%s: %s', ['PATH_INFO', E^.lpszPathInfo])+CR+
    Format('%s: %s', ['PATH_TRANSLATED', E^.lpszPathTranslated])+CR+
    Format('%s: %s', ['Total bytes indicated from client', FormatCurr('#,###', E^.cbTotalBytes)])+CR+
    Format('%s: %s', ['Available number of bytes', FormatCurr('#,###', E^.cbAvailable)])+CR+
    Format('%s: %s', ['pointer to cbAvailable bytes', PChar(@E^.lpbData)])+CR+
    Format('%s: %s', ['Content type of client data', E^.lpszContentType])+CR;
End;

function SampleForm:String;
const CR = '<br>';
Begin
  Result:=
    '<form id="test" method="post" action="/cgi-win7/cisapi.dll?page=upload" enctype="multipart/form-data">' +CR+
    '<input type="text" id="edName" value="Isapi Post"/>'+CR+
    '<input type="file" id="edFile"/>'+CR+
    '<input type="submit" value="KIRIM"/>'+CR+
    '</form>'+CR;

End;

function InternalGetServerVariable(ECB:TEXTENSION_CONTROL_BLOCK): string;
//var
//  Buffer: array[0..4095] of Char;
//  Size: DWORD;
begin
  Result := '';      
  (*Size := SizeOf(Buffer);
  if ECB.GetServerVariable(ECB.ConnID, PChar(Name), @Buffer, Size) or
     ECB.GetServerVariable(ECB.ConnID, PChar('HTTP_' + Name), @Buffer, Size) then  { do not localize }
  begin
    if Size > 0 then Dec(Size);
    SetString(Result, Buffer, Size);
  end else Result := '';
  *)
end;

function GetServerVariables(Req: TISAPIRequest):String;
var i:integer; a,b:String;
Begin
  Result:= '<div class="serverVar">';
  for i:=0 to 28 do
  Begin           
    a:= ServerVariables[i];
    b:= Req.StringVariable[i];
    if (a<>'')And(b<>'') Then
    Result:= Result + Format('<code>%s: %s</code><br>', [a, b]);
  End;

  Result:= Result + '<div>';
End;

function HandleRequest(Req: TISAPIRequest; Res: TISAPIResponse):Boolean;
var
  WebAppServices : TDefaultWebAppServices;
Begin
  Result:= False;
  try
    WebAppServices := TDefaultWebAppServices.Create;
    try
      try
        Res.ContentType:= 'text/html';
        Res.StatusCode := 200;
        Res.Content    := Html +'<br><br>'+
        '<div style="margin-left:5px"><b>Module : </b><code>'+
        Format('Module: %s<br>', [GetModuleName(HInstance)])+
        '</code></div><br>'+
        '<div style="margin-left:5px"><b>ServerVariable:</b><br>'+
        GetServerVariables(Req)+
        '</div>';
        
        {'<b>ISAPI Module</b><hr>'+
        Format('%s: %s<br>', [ParamStr(0), ParamStr(1)])+
        Format('Module: %s<br>', [GetModuleName(HInstance)])+
        '<code>Loaded...</code><br>'+
        GetArgs(Req.FECB)+'<br>'+
        SampleForm;}

        Res.ContentLength:= Length(Res.Content);
        Res.SendResponse;
        Result := true;
        //Result := WebAppServices.HandleRequest;
      except on e:Exception Do
      Begin
        Res.Content    := 'HandleRequest1.Exception: '+e.Message;
        Res.SendResponse;
      End;
      end;
    finally
      WebAppServices.FinishContext;
    end;
    if Result and not Res.Sent then
    Begin
      Res.SendResponse;
    End;
  except on e:exception do
    Begin
      Res.Content    := 'HandleRequest0.Exception: '+e.Message;
      Res.SendResponse;
    end;
  end;
End;

function HttpExtensionProc(var ECB: TEXTENSION_CONTROL_BLOCK): DWORD; stdcall;
var
  Request : TISAPIRequest;
  Response: TISAPIResponse;
begin
  try
    Request := TISAPIRequest.Create(@ECB);
    try
      Response := TISAPIResponse.Create(Request);
      try
        if HandleRequest(Request, Response) then
          Result := HSE_STATUS_SUCCESS
        else Result := HSE_STATUS_ERROR;
      finally
        Response.Free;
      end;
    finally
      Request.Free;
    end;
  except
    //HandleServerException(ExceptObject, ECB);
    Result := HSE_STATUS_ERROR;
  end;
end;

function TerminateExtension(dwFlags: DWORD): Boolean; stdcall;
const
  HSE_TERM_ADVISORY_UNLOAD = $00000001;
  //HSE_TERM_MUST_UNLOAD     = $00000002;
begin
  Result:= Boolean(HSE_TERM_ADVISORY_UNLOAD);
end;


Procedure DLL_Main(reason: Integer);
const COINIT_MULTITHREADED = 0;
Begin
  case reason Of
    DLL_PROCESS_ATTACH:
    Begin
      ComObj.CoInitFlags := COINIT_MULTITHREADED;
      Title:= 'ISAPI Web Server Application';
    End;

    DLL_PROCESS_DETACH:
    Begin
      //
    End;
  End;
End;

Exports
  GetExtensionVersion,
  HttpExtensionProc,
  TerminateExtension;

begin
  DllProc:= @DLL_Main;
  DLL_Main( DLL_PROCESS_ATTACH );
end.
