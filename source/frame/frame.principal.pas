unit frame.principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, frame.pai,
  FMX.Objects, FMX.Layouts;

type
  TFramePrincipal = class(TFramePai)
    rcFundoImagem: TRectangle;
    btnPedidos: TRectangle;
    Text9: TText;
    Rectangle7: TRectangle;
    Line3: TLine;
    Rectangle12: TRectangle;
    Layout1: TLayout;
    btnClientes: TRectangle;
    Text1: TText;
    Rectangle2: TRectangle;
    Line1: TLine;
    Rectangle3: TRectangle;
    btnProduto: TRectangle;
    Text2: TText;
    Rectangle4: TRectangle;
    Line2: TLine;
    Rectangle5: TRectangle;
    Rectangle1: TRectangle;
    Text3: TText;
    Text4: TText;
    Text5: TText;
    procedure FrameEnter(Sender: TObject);
    procedure btnProdutoClick(Sender: TObject);
    procedure btnPedidosClick(Sender: TObject);
    procedure btnClientesClick(Sender: TObject);
    procedure FrameKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
  private
  public

  end;

var
  FramePrincipal: TFramePrincipal;

implementation

{$R *.fmx}

uses form.principal, route.controller;

procedure TFramePrincipal.btnClientesClick(Sender: TObject);
begin
  inherited;
  FrmBackGround.route.Open(
    routeCliente,
    TRouteParams.new
      .AddPair('message', 'TELA PRINCIPAL'),
    TREffectType.etBottomToTop
  );
end;

procedure TFramePrincipal.btnPedidosClick(Sender: TObject);
begin
  inherited;
  FrmBackGround.route.Open(
    routeVenda,
    nil,
    TREffectType.etBottomToTop
  );
end;

procedure TFramePrincipal.btnProdutoClick(Sender: TObject);
begin
  inherited;
  FrmBackGround.route.Open(
    routeProduto,
    TRouteParams.new
      .AddPair('message', 'TELA PRINCIPAL'),
    TREffectType.etBottomToTop
  );
end;

procedure TFramePrincipal.FrameEnter(Sender: TObject);
begin
  inherited;
  rcFundoImagem.SendToBack;
end;

procedure TFramePrincipal.FrameKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  showMessage('O botão "'+ KeyChar +'" foi pressionado na tela PRINCIPAL.');

  if (Key = vkHardwareBack) then
    FrmBackGround.route.Back();
  key := 0;
end;

end.
