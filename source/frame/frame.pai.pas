unit frame.pai;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, Json,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Objects,
  FMX.Layouts, FMX.WebBrowser;

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
    /// <summary> Procedimento para carregar as cores dos componentes </summary>
    procedure LoadLayout; virtual;
  end;

implementation

{$R *.fmx}

uses System.UIConsts;

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

procedure TFrmPai.LoadLayout;
var x : integer;
begin
  //fundo do formulário
//  rcFundo.Fill.Color := TAlphaColorRec.Black;

  //Se for GOLD = Pixapay, então não faz nada pois o sistema de cores já está configurado para o pixapay
//  if (AnsiUpperCase(Dm.sistema.corPrimariaOriginal) = '#FED700') or
//    (AnsiUpperCase(Dm.sistema.corPrimariaOriginal) = 'GOLD') then
//    exit;

//  for x := 0 to self.ComponentCount - 1 do
//  begin
//    if (self.Components[x] is TComponent) then
//      if (TComponent(self.Components[x]).Tag = 80) then //Componentes que alteram a cor de fundo com a cor desejada
//      begin
//        if (self.Components[x] is TShape) then
//        begin
//          TShape(self.Components[x]).Fill.Color := StringToAlphaColor(Dm.sistema.corPrimaria);
//          TShape(self.Components[x]).Stroke.Color := StringToAlphaColor(Dm.sistema.corPrimaria);
//        end
//        else if (self.Components[x] is TText) then
//          TText(self.Components[x]).TextSettings.FontColor := StringToAlphaColor(Dm.sistema.corPrimaria);
//      end;
//
//      if (TComponent(self.Components[x]).Tag = 90) then //Componentes que alteram o texto para a cor desejada
//      begin
//
//
//      end;
//  end;
end;

procedure TFrmPai.rcBtnClickMouseEnter(Sender: TObject);
begin
  if (Sender is TShape) then
    TShape(Sender).Opacity := 0.6
  else if (Sender is TControl) then
    TControl(Sender).Opacity := 0.6
  else if (Sender is TText) then
    TRectangle(TText(Sender).Parent).Opacity := 0.6
  else if (Sender is TLine) then
    TRectangle(TLine(Sender).Parent).Opacity := 0.6;
end;

procedure TFrmPai.rcBtnClickMouseLeave(Sender: TObject);
begin
  if (Sender is TShape) then
    TShape(Sender).Opacity := 1
  else if (Sender is TControl) then
    TControl(Sender).Opacity := 1
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
