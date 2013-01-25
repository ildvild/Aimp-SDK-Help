unit AIMPVisualDemoSpectrum;

interface

uses
  Windows, Types, AIMPSDKCore, AIMPSDKVisual;

type

  { TAIMPVisualPlugin }

  TAIMPVisualPlugin = class(TInterfacedObject, IAIMPVisualPlugin3)
  private
    FDisplaySize: TSize;
    FIntervalBetweenValues: Integer;
    FLinePen: HPEN;
  public
    // IAIMPVisualPlugin3
    function GetPluginAuthor: PWideChar; stdcall;
    function GetPluginInfo: PWideChar; stdcall;
    function GetPluginName: PWideChar; stdcall;
    function GetPluginFlags: DWORD; stdcall; // See AIMP_VISUAL_FLAGS_XXX
    function Initialize(ACoreUnit: IAIMPCoreUnit): HRESULT; stdcall;
    function Finalize: HRESULT; stdcall;
    procedure DisplayClick(X, Y: Integer); stdcall;
    procedure DisplayRender(DC: HDC; AData: PAIMPVisualData); stdcall;
    procedure DisplayResize(AWidth, AHeight: Integer); stdcall;
    //
    property DisplaySize: TSize read FDisplaySize;
    property IntervalBetweenValues: Integer read FIntervalBetweenValues;
    property LinePen: HPEN read FLinePen;
  end;

implementation

{ TAIMPVisualPlugin }

function TAIMPVisualPlugin.Initialize(ACoreUnit: IAIMPCoreUnit): HRESULT;
begin
  FLinePen := CreatePen(PS_SOLID, 1, $FF0000); // White Pen
  Result := S_OK;
end;

function TAIMPVisualPlugin.Finalize: HRESULT;
begin
  DeleteObject(LinePen);
  Result := S_OK;
end;

procedure TAIMPVisualPlugin.DisplayClick(X, Y: Integer);
begin
  DeleteObject(LinePen);
  FLinePen := CreatePen(PS_SOLID, 1, random($FFFFF));
end;

procedure TAIMPVisualPlugin.DisplayRender(DC: HDC; AData: PAIMPVisualData);
var
  APrevObject: HGDIOBJ;
  ASaveIndex: Integer;
  I, ADisplayMiddleY: Integer;
begin
  FillRect(DC, Rect(0, 0, DisplaySize.cx, DisplaySize.cy),
    GetStockObject(BLACK_BRUSH));

  ASaveIndex := SaveDC(DC);
  try
    IntersectClipRect(DC, 0, 0, DisplaySize.cx, DisplaySize.cy);
    APrevObject := SelectObject(DC, LinePen);
    try
      // Draw Left Channel
      ADisplayMiddleY := DisplaySize.cy div 2;
      MoveToEx(DC, 0, ADisplayMiddleY, nil);
      for I := 0 to 255 do
      begin
        Rectangle(DC, // handle to DC
          I * IntervalBetweenValues, // x-coord of upper-left corner of rectangle
          ADisplayMiddleY, // y-coord of upper-left corner of rectangle
          (I + 1) * IntervalBetweenValues, // x-coord of lower-right corner of rectangle
          ADisplayMiddleY + AData^.Spectrum[0, I] // y-coord of lower-right corner of rectangle
          );
      end;

      MoveToEx(DC, 0, ADisplayMiddleY, nil);
      // Draw Right Channel
      for I := 0 to 255 do
      begin
        // Draw spectr
        Rectangle(DC, // handle to DC
          I * IntervalBetweenValues, // x-coord of upper-left corner of rectangle
          ADisplayMiddleY, // y-coord of upper-left corner of rectangle
          (I + 1) * IntervalBetweenValues, // x-coord of lower-right corner of rectangle
          ADisplayMiddleY - AData^.Spectrum[1, I] // y-coord of lower-right corner of rectangle
          );
      end;
    finally
      SelectObject(DC, APrevObject);
    end;
  finally
    RestoreDC(DC, ASaveIndex);
  end;
end;

procedure TAIMPVisualPlugin.DisplayResize(AWidth, AHeight: Integer);
begin
  FDisplaySize.cx := AWidth;
  FDisplaySize.cy := AHeight;
  FIntervalBetweenValues := Round(AWidth / 256 + 2);
end;

function TAIMPVisualPlugin.GetPluginAuthor: PWideChar;
begin
  Result := 'ildvild';
end;

function TAIMPVisualPlugin.GetPluginFlags: DWORD;
begin
  Result := AIMP_VISUAL_FLAGS_RQD_DATA_SPECTRUM;
end;

function TAIMPVisualPlugin.GetPluginInfo: PWideChar;
begin
  Result := 'Demo Spectrum';
end;

function TAIMPVisualPlugin.GetPluginName: PWideChar;
begin
  Result := 'The Visual Plugin Spectrum';
end;

end.
