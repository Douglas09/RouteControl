unit form.principal;

interface

uses
  route.controller,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TFrmBackGround = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
  public
    route : TRouteControl;
  end;

var
  FrmBackGround: TFrmBackGround;

const
  routePrincipal = 'ROUTE/PRINCIPAL';
  routeCliente = 'ROUTE/CLIENTE';
  routeVenda = 'ROUTE/VENDA';
  routeProduto = 'ROUTE/PRODUTO';

implementation

uses frame.principal, frame.produto, frame.venda, frame.cliente;

{$R *.fmx}

procedure TFrmBackGround.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MyFreeAndNil(route);
end;

procedure TFrmBackGround.FormShow(Sender: TObject);
begin
  //Instancia na memória o controle de rotas
  route := TRouteControl.Create(self);

  //Adiciona todas as possíveis rotas no controlador
  route.Add(routePrincipal, TFramePrincipal);
  route.Add(routeProduto, TFrameProduto);
  route.Add(routeVenda, TFrameVenda);
  route.Add(routeCliente, TFrameCliente);

  //Abre a primeira rota do aplicativo
  route.Open(
    routePrincipal,
    nil,
    TREffectType.etBottomToTop
  );
end;

end.
