unit frame.pai;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, Json,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Objects,
  FMX.Layouts, FMX.WebBrowser;

type
  /// <summary>
  ///  Status do frame:
  ///  1- fsEnabledEvents = Habilia a execução dos eventos deste frame
  ///  2- fsDisabledEvents = Desabilita a execução dos eventos deste frame
  ///  3- fsDisabledEventsWithAutoReturn = Desabilita a execução dos eventos deste frame e ao reabri-lo, retorna o status para fsEnabledEvents automaticamente e começa a executar os eventos normalmente
  /// </summary>
  TFrEventsState = (fsEnabledEvents, fsDisabledEvents, fsDisabledEventsWithAutoReturn);

  TFramePai = class(TFrame)
    rcFundo: TRectangle;
    vsScroll: TVertScrollBox;
    rcBtnClick: TRectangle;
    procedure FrameEnter(Sender: TObject);
    procedure rcBtnClickMouseEnter(Sender: TObject);
    procedure rcBtnClickMouseLeave(Sender: TObject);
    procedure FrameKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
  private
    FFrameState: TFrEventsState;
    FKeyboardHidden: TVirtualKeyboardEvent;
    FKeyboardShown: TVirtualKeyboardEvent;
    FKeyboardVisible: boolean;
    FOnKeyboardHidden: TVirtualKeyboardEvent;
    FOnKeyboardShown: TVirtualKeyboardEvent;
    procedure SetKeyboardHidden(const Value: TVirtualKeyboardEvent);
    procedure SetKeyboardShown(const Value: TVirtualKeyboardEvent);
    procedure SetKeyboardVisible(const Value: boolean);
    procedure SetOnKeyboardHidden(const Value: TVirtualKeyboardEvent);
    procedure SetOnKeyboardShown(const Value: TVirtualKeyboardEvent);
  protected
    /// <summary> Seta o foco do teclado no controle recebido de parâmetro </summary>
    procedure SetFocused(control : IControl = nil);

    /// <summary> Exibição do teclado em tela </summary>
    procedure KeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds : TRect); virtual;
    /// <summary> Fechamento do teclado em tela </summary>
    procedure KeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds : TRect); virtual;
  public
    property FrameState : TFrEventsState read FFrameState write FFrameState;

    property KeyboardVisible : boolean read FKeyboardVisible write SetKeyboardVisible;
    property OnKeyboardShown : TVirtualKeyboardEvent read FOnKeyboardShown write SetOnKeyboardShown;
    property OnKeyboardHidden : TVirtualKeyboardEvent read FOnKeyboardHidden write SetOnKeyboardHidden;

    /// <summary> Parâmetros recebidos ao exibir ou esconder a tela </summary>
    procedure setParams(params : TJSonObject); virtual;
    /// <summary> Evênto disparado somente se houverem parâmetros ao: 1. Aberto o frame / 2. Ido para outro frame / 3. Voltado para este frame </summary>
    procedure SetOnReturn(params : TJSonObject); virtual;
    /// <summary> Procedimento para carregar as cores dos componentes </summary>
    procedure LoadLayout; virtual;
  end;

implementation

{$R *.fmx}

uses System.UIConsts;

{ TFrmPai }

procedure TFramePai.FrameEnter(Sender: TObject);
begin
  FFrameState := fsEnabledEvents;
  FOnKeyboardShown := KeyboardShown;
  FOnKeyboardHidden := KeyboardHidden;
  KeyboardVisible := false;
end;

procedure TFramePai.FrameKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if (Key = vkHardwareBack) then
    if (KeyboardVisible) then
      if (screen.ActiveForm <> nil) and (screen.ActiveForm.Focused <> nil) then
      begin
        SetFocused(nil);
        key := 0;
        exit;
      end;
end;

procedure TFramePai.KeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FKeyboardVisible := KeyboardVisible;
end;

procedure TFramePai.KeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FKeyboardVisible := KeyboardVisible;
end;

procedure TFramePai.LoadLayout;
begin

end;

procedure TFramePai.rcBtnClickMouseEnter(Sender: TObject);
begin
  if (Sender is TControl) then
    TControl(Sender).Opacity := 0.6
  else if (Sender is TText) then
    TRectangle(TText(Sender).Parent).Opacity := 0.6
  else if (Sender is TLine) then
    TRectangle(TLine(Sender).Parent).Opacity := 0.6;
end;

procedure TFramePai.rcBtnClickMouseLeave(Sender: TObject);
begin
  if (Sender is TControl) then
    TControl(Sender).Opacity := 1
  else if (Sender is TText) then
    TRectangle(TText(Sender).Parent).Opacity := 1
  else if (Sender is TLine) then
    TRectangle(TLine(Sender).Parent).Opacity := 1;
end;

procedure TFramePai.SetFocused(control : IControl = nil);
begin
  if (screen.ActiveForm <> nil) then
    screen.ActiveForm.Focused := control;
end;

procedure TFramePai.SetKeyboardHidden(const Value: TVirtualKeyboardEvent);
begin
  FKeyboardHidden := Value;
end;

procedure TFramePai.SetKeyboardShown(const Value: TVirtualKeyboardEvent);
begin
  FKeyboardShown := Value;
end;

procedure TFramePai.SetKeyboardVisible(const Value: boolean);
begin
  FKeyboardVisible := Value;
end;

procedure TFramePai.SetOnKeyboardHidden(const Value: TVirtualKeyboardEvent);
begin
  FOnKeyboardHidden := Value;
end;

procedure TFramePai.SetOnKeyboardShown(const Value: TVirtualKeyboardEvent);
begin
  FOnKeyboardShown := Value;
end;

procedure TFramePai.SetOnReturn(params: TJSonObject);
begin

end;

procedure TFramePai.setParams(params: TJSonObject);
begin

end;

end.
