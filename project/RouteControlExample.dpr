program RouteControlExample;

uses
  System.StartUpCopy,
  FMX.Forms,
  form.principal in '..\source\form.principal.pas' {FrmBackGround},
  frame.pai in '..\source\frame\frame.pai.pas' {FrmPai: TFrame},
  route.controller in '..\source\route\route.controller.pas',
  frame.principal in '..\source\frame\frame.principal.pas' {FrmPrincipal: TFrame},
  route.consts in '..\source\route\route.consts.pas',
  frame.produto in '..\source\frame\frame.produto.pas' {FrmProduto: TFrame},
  frame.venda in '..\source\frame\frame.venda.pas' {FrmVenda: TFrame},
  frame.cliente in '..\source\frame\frame.cliente.pas' {FrmCliente: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmBackGround, FrmBackGround);
  Application.Run;
end.
