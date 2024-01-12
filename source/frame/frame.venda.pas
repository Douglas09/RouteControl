unit frame.venda;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, frame.pai,
  FMX.Layouts, FMX.Objects;

type
  TFrameVenda = class(TFramePai)
    Text1: TText;
    btnVoltar: TCircle;
    Rectangle14: TRectangle;
    Layout1: TLayout;
    btnClientes: TRectangle;
    Text2: TText;
    Rectangle2: TRectangle;
    Line1: TLine;
    Rectangle3: TRectangle;
    btnProduto: TRectangle;
    Text3: TText;
    Rectangle4: TRectangle;
    Line2: TLine;
    Rectangle5: TRectangle;
    procedure btnVoltarClick(Sender: TObject);
    procedure btnProdutoClick(Sender: TObject);
    procedure btnClientesClick(Sender: TObject);
    procedure FrameKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
  public
    /// <summary> Exibição do teclado em tela </summary>
    procedure KeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds : TRect); override;
    /// <summary> Fechamento do teclado em tela </summary>
    procedure KeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds : TRect); override;
  end;

var
  FrameVenda: TFrameVenda;

implementation

{$R *.fmx}

uses form.principal, route.controller;

procedure TFrameVenda.btnClientesClick(Sender: TObject);
begin
  inherited;
  FrmBackGround.route.Open(
    routeCliente,
    TRouteParams.new
      .AddPair('message', '182716 - Jucelino Roman'),
    TREffectType.etBottomToTop
  );
end;

procedure TFrameVenda.btnProdutoClick(Sender: TObject);
begin
  inherited;
  FrmBackGround.route.Open(
    routeProduto,
    TRouteParams.new
      .AddPair('message', '192871 - Produto teste'),
    TREffectType.etBottomToTop
  );
end;

procedure TFrameVenda.btnVoltarClick(Sender: TObject);
begin
  inherited;
  FrmBackGround.route.Back();
end;

procedure TFrameVenda.FrameKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  showMessage('O botão "'+ KeyChar +'" foi pressionado na tela de vendas.');

  if (Key = vkHardwareBack) then
    FrmBackGround.route.Back();
  key := 0;
end;

procedure TFrameVenda.KeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  inherited;
  showMessage('Escondeu o teclado');
end;

procedure TFrameVenda.KeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  inherited;
  showMessage('Exibiu o teclado');
end;

end.
