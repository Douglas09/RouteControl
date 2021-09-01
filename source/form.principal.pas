unit form.principal;

interface

uses
  route.consts,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, frame.principal, frame.produto, frame.venda,
  frame.cliente;

type
  TFrmBackGround = class(TForm)
    lyScreen: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
  public
    route : TRouteControl;

    /// <summary> Rotina que mapeia todas as possíveis rotas que o projeto possui </summary>
    procedure LoadRoutes;
  end;

var
  FrmBackGround: TFrmBackGround;
  framePrincipal : TFrmPrincipal;
  frameProduto : TFrmProduto;
  frameVenda : TFrmVenda;
  frameCliente : TFrmCliente;

implementation

{$R *.fmx}

procedure TFrmBackGround.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {$IFDEF ANDROID}
    route.DisposeOf;
  {$ELSE}
    FreeAndNil(route);
  {$ENDIF}
end;

procedure TFrmBackGround.FormCreate(Sender: TObject);
begin
  {$IFDEF DEBUG}
    ReportMemoryLeaksOnShutdown := true;
  {$ENDIF}

  {$IFDEF MSWINDOWS}
  {$ELSE}
    lyScreen.Align := TAlignLayout.Client;
  {$ENDIF}
end;

procedure TFrmBackGround.FormShow(Sender: TObject);
begin
  route := TRouteControl.Create(lyScreen);
  LoadRoutes;

  route.Open(routePrincipal);
end;

procedure TFrmBackGround.LoadRoutes;
begin
  if (route = nil) then
    exit;

  route.Add(TRouteObject.new
    .setRoute(routePrincipal)
    .setClassType(TFrmPrincipal)
    .setReference(framePrincipal)
  );

  route.Add(TRouteObject.new
    .setRoute(routeProduto)
    .setClassType(TFrmProduto)
    .setReference(frameProduto)
  );

  route.Add(TRouteObject.new
    .setRoute(routeVenda)
    .setClassType(TFrmVenda)
    .setReference(frameVenda)
  );

  route.Add(TRouteObject.new
    .setRoute(routeCliente)
    .setClassType(TFrmCliente)
    .setReference(frameCliente)
  );
end;

end.
