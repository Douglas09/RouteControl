program RouteControlExample;

uses
  System.StartUpCopy,
  FMX.Forms,
  form.principal in '..\source\form.principal.pas' {FrmBackGround},
  frame.pai in '..\source\frame\frame.pai.pas' {FramePai: TFrame},
  route.controller in '..\source\route\route.controller.pas',
  frame.principal in '..\source\frame\frame.principal.pas' {FramePrincipal: TFrame},
  frame.produto in '..\source\frame\frame.produto.pas' {FrameProduto: TFrame},
  frame.venda in '..\source\frame\frame.venda.pas' {FrameVenda: TFrame},
  frame.cliente in '..\source\frame\frame.cliente.pas' {FrameCliente: TFrame};

{$R *.res}

begin
  {$IFDEF DEBUG}
    ReportMemoryLeaksOnShutdown := true;
  {$ENDIF}

  Application.Initialize;
  Application.CreateForm(TFrmBackGround, FrmBackGround);
  Application.Run;
end.
