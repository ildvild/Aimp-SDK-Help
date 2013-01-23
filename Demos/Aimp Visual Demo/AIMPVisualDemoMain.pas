unit AIMPVisualDemoMain;

interface

uses
  Windows, Types, AIMPSDKCore, AIMPSDKVisual;

type

  { TAIMPVisualPlugin }

  TAIMPVisualPlugin = class(TInterfacedObject, IAIMPVisualPlugin3)
  private
    FDisplaySize: TSize;
    FIntervalBetweenValues: Integer;
    FWaveLinePen: HPEN;
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
    property WaveLinePen: HPEN read FWaveLinePen;
  end;

implementation

{ TAIMPVisualPlugin }

function TAIMPVisualPlugin.Initialize(ACoreUnit: IAIMPCoreUnit): HRESULT;
begin
  FWaveLinePen := CreatePen(PS_SOLID, 1, $FFFFFF); // White Pen
  Result := S_OK;
end;

function TAIMPVisualPlugin.Finalize: HRESULT;
begin
  DeleteObject(WaveLinePen);
  Result := S_OK;
end;

procedure TAIMPVisualPlugin.DisplayClick(X, Y: Integer);
begin
DeleteObject(WaveLinePen);
FWaveLinePen := CreatePen(PS_SOLID, 1, random($fffff));
end;

procedure TAIMPVisualPlugin.DisplayRender(DC: HDC; AData: PAIMPVisualData);
var
  APrevObject: HGDIOBJ;
  ASaveIndex: Integer;
  I, ADisplayMiddleY, AChannelHeight: Integer;
begin
  FillRect(DC, Rect(0, 0, DisplaySize.cx, DisplaySize.cy), GetStockObject(BLACK_BRUSH));

  ASaveIndex := SaveDC(DC);
  try
    IntersectClipRect(DC, 0, 0, DisplaySize.cx, DisplaySize.cy);
    APrevObject := SelectObject(DC, WaveLinePen);
    try
      AChannelHeight := DisplaySize.cy div 4;

      // Draw Left Channel
      ADisplayMiddleY := DisplaySize.cy div 4;
      MoveToEx(DC, -IntervalBetweenValues, ADisplayMiddleY, nil);
      for I := 0 to 511 do
      begin
        LineTo(DC, I * IntervalBetweenValues, ADisplayMiddleY +
          MulDiv(AData^.WaveForm[0, I], AChannelHeight, MAXCHAR {127}));
      end;

      // Draw Right Channel
      ADisplayMiddleY := MulDiv(DisplaySize.cy, 3, 4);
      MoveToEx(DC, -IntervalBetweenValues, ADisplayMiddleY, nil);
      for I := 0 to 511 do
      begin
        LineTo(DC, I * IntervalBetweenValues, ADisplayMiddleY +
          MulDiv(AData^.WaveForm[1, I], AChannelHeight, MAXCHAR {127}));
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
  FIntervalBetweenValues := Round(AWidth / 512 + 0.5); // 512 Wave Points, refer to TWaveForm structure declared in AIMPSDKVisual
end;

function TAIMPVisualPlugin.GetPluginAuthor: PWideChar;
begin
  Result := 'Artem Izmaylov';
end;

function TAIMPVisualPlugin.GetPluginFlags: DWORD;
begin
  Result := AIMP_VISUAL_FLAGS_RQD_DATA_WAVE;
end;

function TAIMPVisualPlugin.GetPluginInfo: PWideChar;
begin
  Result := 'Demo';
end;

function TAIMPVisualPlugin.GetPluginName: PWideChar;
begin
  Result := 'The Visual Plugin';
end;

end.
