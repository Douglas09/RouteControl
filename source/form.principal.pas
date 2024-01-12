unit form.principal;

interface

uses
  route.consts,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TFrmBackGround = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
  public
    route : TRouteControl;
    /// <summary> Rotina que mapeia todas as possíveis rotas que o projeto possui e inicia o componente </summary>
    procedure LoadRoutes;
  end;

var
  FrmBackGround: TFrmBackGround;

implementation

uses frame.principal, frame.produto, frame.venda, frame.cliente;

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
end;

procedure TFrmBackGround.FormShow(Sender: TObject);
begin
  LoadRoutes;
end;

procedure TFrmBackGround.LoadRoutes;
begin
  route := TRouteControl.Create(self);
  route.Add(routePrincipal, TFrmPrincipal);
  route.Add(routeProduto, TFrmProduto);
  route.Add(routeVenda, TFrmVenda);
  route.Add(routeCliente, TFrmCliente);

  route.Open(
    routePrincipal,
    nil,
    TREffectType.etBottomToTop
  );
end;

end.
