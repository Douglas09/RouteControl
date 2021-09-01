unit frame.pai;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, Json,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Objects,
  FMX.Layouts;

type
  TFrmPai = class(TFrame)
    rcFundo: TRectangle;
    vsScroll: TVertScrollBox;
    rcBtnClick: TRectangle;
    procedure FrameEnter(Sender: TObject);
    procedure rcBtnClickMouseEnter(Sender: TObject);
    procedure rcBtnClickMouseLeave(Sender: TObject);
    procedure FrameKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
  private
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
    property KeyboardVisible : boolean read FKeyboardVisible write SetKeyboardVisible;
    property OnKeyboardShown : TVirtualKeyboardEvent read FOnKeyboardShown write SetOnKeyboardShown;
    property OnKeyboardHidden : TVirtualKeyboardEvent read FOnKeyboardHidden write SetOnKeyboardHidden;

    /// <summary> Parâmetros recebidos ao exibir ou esconder a tela </summary>
    procedure setParams(params : TJSonObject); virtual;
  end;

implementation

{$R *.fmx}

{ TFrmPai }

procedure TFrmPai.FrameEnter(Sender: TObject);
begin
  FOnKeyboardShown := KeyboardShown;
  FOnKeyboardHidden := KeyboardHidden;
  KeyboardVisible := false;
end;

procedure TFrmPai.FrameKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
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

procedure TFrmPai.KeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FKeyboardVisible := KeyboardVisible;
end;

procedure TFrmPai.KeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FKeyboardVisible := KeyboardVisible;
end;

procedure TFrmPai.rcBtnClickMouseEnter(Sender: TObject);
begin
  if (Sender is TRectangle) then
    TRectangle(Sender).Opacity := 0.6
  else if (Sender is TCircle) then
    TCircle(Sender).Opacity := 0.6
  else if (Sender is TLayout) then
    TLayout(Sender).Opacity := 0.6
  else if (Sender is TText) then
    TRectangle(TText(Sender).Parent).Opacity := 0.6
  else if (Sender is TLine) then
    TRectangle(TLine(Sender).Parent).Opacity := 0.6;
end;

procedure TFrmPai.rcBtnClickMouseLeave(Sender: TObject);
begin
  if (Sender is TRectangle) then
    TRectangle(Sender).Opacity := 1
  else if (Sender is TCircle) then
    TCircle(Sender).Opacity := 1
  else if (Sender is TLayout) then
    TLayout(Sender).Opacity := 1
  else if (Sender is TText) then
    TRectangle(TText(Sender).Parent).Opacity := 1
  else if (Sender is TLine) then
    TRectangle(TLine(Sender).Parent).Opacity := 1;
end;

procedure TFrmPai.SetFocused(control : IControl = nil);
begin
  if (screen.ActiveForm <> nil) then
    screen.ActiveForm.Focused := control;
end;

procedure TFrmPai.SetKeyboardHidden(const Value: TVirtualKeyboardEvent);
begin
  FKeyboardHidden := Value;
end;

procedure TFrmPai.SetKeyboardShown(const Value: TVirtualKeyboardEvent);
begin
  FKeyboardShown := Value;
end;

procedure TFrmPai.SetKeyboardVisible(const Value: boolean);
begin
  FKeyboardVisible := Value;
end;

procedure TFrmPai.SetOnKeyboardHidden(const Value: TVirtualKeyboardEvent);
begin
  FOnKeyboardHidden := Value;
end;

procedure TFrmPai.SetOnKeyboardShown(const Value: TVirtualKeyboardEvent);
begin
  FOnKeyboardShown := Value;
end;

procedure TFrmPai.setParams(params: TJSonObject);
begin

end;

end.
