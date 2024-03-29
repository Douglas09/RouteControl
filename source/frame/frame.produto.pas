unit frame.produto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, Json,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, frame.pai,
  FMX.Layouts, FMX.Objects;

type
  TFrameProduto = class(TFramePai)
    btnVoltar: TCircle;
    Rectangle14: TRectangle;
    Text1: TText;
    txParams: TText;
    procedure btnVoltarClick(Sender: TObject);
    procedure FrameKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
  private
    { Private declarations }
  public
    /// <summary> Par�metros recebidos ao exibir ou esconder a tela </summary>
    procedure setParams(params : TJSonObject); override;
  end;

var
  FrameProduto: TFrameProduto;

implementation

{$R *.fmx}

uses form.principal;

procedure TFrameProduto.btnVoltarClick(Sender: TObject);
begin
  inherited;
  FrmBackGround.route.Back();
end;

procedure TFrameProduto.FrameKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  inherited;
  showMessage('O bot�o "'+ KeyChar +'" foi pressionado na tela de PRODUTOS.');

  if (Key = vkHardwareBack) then
    FrmBackGround.route.Back();
  key := 0;
end;

procedure TFrameProduto.setParams(params: TJSonObject);
var msg : string;
begin
  inherited;
  if (params = nil) then
    exit;

  params.TryGetValue<string>('message', msg);
  txParams.Text := 'Par�metro recebido: '+ msg;
end;

end.
