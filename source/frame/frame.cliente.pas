unit frame.cliente;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, Json,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, frame.pai,
  FMX.Layouts, FMX.Objects, FMX.Controls.Presentation, FMX.Edit;

type
  TFrameCliente = class(TFramePai)
    btnVoltar: TCircle;
    Rectangle14: TRectangle;
    Text1: TText;
    txParams: TText;
    procedure btnVoltarClick(Sender: TObject);
    procedure FrameKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
  private

  public
    /// <summary> Parâmetros recebidos ao exibir ou esconder a tela </summary>
    procedure setParams(params : TJSonObject); override;
  end;

var
  FrameCliente: TFrameCliente;

implementation

{$R *.fmx}

uses form.principal;

procedure TFrameCliente.btnVoltarClick(Sender: TObject);
begin
  inherited;
  FrmBackGround.route.Back();
end;

procedure TFrameCliente.FrameKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  inherited;
  showMessage('O botão "'+ KeyChar +'" foi pressionado na tela CLIENTES.');

  if (Key = vkHardwareBack) then
    FrmBackGround.route.Back();
  key := 0;
end;

procedure TFrameCliente.setParams(params: TJSonObject);
var msg : string;
begin
  inherited;
  if (params = nil) then
    exit;

  params.TryGetValue<string>('message', msg);
  txParams.Text := 'Parâmetro recebido: '+ msg;
end;

end.
