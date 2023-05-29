{
 - Douglas Colombo
 - Since: 2021-08-13
}

unit route.controller;

interface

uses System.Classes, Generics.Collections, Json, FMX.Forms, FMX.Types, System.Types, FMX.Controls;

type
  IRouteParams = interface
    ['{F8DD53BF-4FD3-4A81-BEC7-DF2FE486ACFF}']
    function SetObj(const Value: TJSONObject) : IRouteParams;
    function AddPair(pKey : string; pValue : string) : IRouteParams; overload;
    function AddPair(pKey : string; pValue : integer) : IRouteParams; overload;
    function AddPair(pKey : string; pValue : double) : IRouteParams; overload;
    function AddPair(pKey : string; pValue : boolean) : IRouteParams; overload;
    function AddPair(pKey : string; pValue : TDate) : IRouteParams; overload;
    function AddPair(pKey : string; pValue : TDateTime) : IRouteParams; overload;
    function AddPair(pKey : string; pValue : TJSONValue) : IRouteParams; overload;
  end;

  TRouteParams = class(TInterfacedObject, IRouteParams)
  private
    FObj: TJSONObject;
  public
    constructor Create;
    destructor Destroy; override;
    class function new : IRouteParams;

    property Obj : TJSONObject read FObj;
    function SetObj(const Value: TJSONObject) : IRouteParams;

    function AddPair(pKey : string; pValue : string) : IRouteParams; overload;
    function AddPair(pKey : string; pValue : integer) : IRouteParams; overload;
    function AddPair(pKey : string; pValue : double) : IRouteParams; overload;
    function AddPair(pKey : string; pValue : boolean) : IRouteParams; overload;
    function AddPair(pKey : string; pValue : TDate) : IRouteParams; overload;
    function AddPair(pKey : string; pValue : TDateTime) : IRouteParams; overload;
    function AddPair(pKey : string; pValue : TJSONValue) : IRouteParams; overload;
  end;

  IRouteObject = interface
    ['{7D3B9D4C-3E1D-415C-AD22-7B216C8788DC}']
    function setMainForm(const value : boolean) : IRouteObject;
    function getMainForm : boolean;
    function setRoute(const value : string; const alias : string = '') : IRouteObject;
    function getRoute : string;
    function getAlias : string;
    function setClassType(const value : TComponentClass) : IRouteObject;
    function getClassType : TComponentClass;
    function setReference(const value : Pointer) : IRouteObject;
    function getReference : Pointer;
    function setOwner(const value : TComponent) : IRouteObject;
    function getOwner : TComponent;
  end;

  TRouteObject = class(TInterfacedObject, IRouteObject)
  private
    FMainForm : boolean;
    FRoute : string;
    FAlias : string;
    FReference: Pointer;
    FClassType : TComponentClass;
    FOwner : TComponent;
  public
    constructor Create;
    destructor Destroy; override;
    class function new : IRouteObject;

    function setMainForm(const value : boolean) : IRouteObject;
    function getMainForm : boolean;
    function setRoute(const value : string; const alias : string = '') : IRouteObject;
    function getRoute : string;
    function getAlias : string;
    function setClassType(const value : TComponentClass) : IRouteObject;
    function getClassType : TComponentClass;
    function setReference(const value : Pointer) : IRouteObject;
    function getReference : Pointer;
    function setOwner(const value : TComponent) : IRouteObject;
    function getOwner : TComponent;
  end;

  TMainForm = class
  private
    FOldOnKeyUp : TKeyEvent;
    FOldVirtualKeyboardShown : TVirtualKeyboardEvent;
    FOldVirtualKeyboardHidden : TVirtualKeyboardEvent;

    FMainForm: TCommonCustomForm;
    FonFrameKeyUp: TKeyEvent;
    FonFrameVirtualKeyboardHidden: TVirtualKeyboardEvent;
    FonFrameVirtualKeyboardShown: TVirtualKeyboardEvent;
    procedure SetMainForm(const Value: TCommonCustomForm);
    procedure SetonFrameKeyUp(const Value: TKeyEvent);
    procedure SetonFrameVirtualKeyboardHidden(const Value: TVirtualKeyboardEvent);
    procedure SetonFrameVirtualKeyboardShown(const Value: TVirtualKeyboardEvent);
  protected
    procedure OnKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure OnVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds : TRect);
    procedure OnVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds : TRect);
  public
    constructor Create;
    destructor Destroy; override;

    /// <summary> Formulário pai TForm </summary>
    property MainForm : TCommonCustomForm read FMainForm write SetMainForm;
    /// <summary> KeyUp do frame ativo no momento </summary>
    property onFrameKeyUp : TKeyEvent read FonFrameKeyUp write SetonFrameKeyUp;
    /// <summary> Ao exibir o teclado </summary>
    property onFrameVirtualKeyboardShown : TVirtualKeyboardEvent read FonFrameVirtualKeyboardShown write SetonFrameVirtualKeyboardShown;
    /// <summary> Ao esconder o teclado </summary>
    property onFrameVirtualKeyboardHidden : TVirtualKeyboardEvent read FonFrameVirtualKeyboardHidden write SetonFrameVirtualKeyboardHidden;
  end;

  TREffectType = (etNone, etRightToLeft, etBottomToTop, etCenterToSides);

  TRouteControl = class
  private
    FList : TList<IRouteObject>;
    FListBack : TList<IRouteObject>;

    FActive : TRouteObject;
    FOwner : TControl;
    FMainForm : TMainForm;
  public
    constructor Create(const Owner : TControl);
    destructor Destroy; override;

    /// <summary> Acessa as propriedades do frame que está sendo exibido em tela </summary>
    property ActiveFrame : TRouteObject read FActive;

    /// <summary> Mapeia todas as possíveis rotas dentro do controle </summary>
    procedure Add(route : IRouteObject);

    /// <summary> Carrega uma das rotas no layout principal </summary>
    procedure Open(route : string; params : IRouteParams = nil; effectType : TREffectType = etNone);

    /// <summary> Fecha e limpa da memória uma rota que foi carregada no layout principal </summary>
    procedure Clear(route : string; params : IRouteParams = nil; forceClose : boolean = false);

    /// <summary> Volta para a rota anterior aberta, caso existir </summary>
    function Back(route : string = ''; params : IRouteParams = nil) : boolean;
  end;

/// <summary> Limpa da memória a referência de um objeto </summary>
procedure MyFreeAndNil(const [ref] Obj: TObject);

implementation

uses frame.pai, System.SysUtils;

procedure MyFreeAndNil(const [ref] Obj: TObject);
begin
  if not (assigned(Obj)) or (Obj = nil) then
    exit;

  try
    {$IFDEF ANDROID}
      Obj.DisposeOf;
    {$ELSE}
      FreeAndNil(Obj);
    {$ENDIF}
  except
  end;
end;

{ TRouteObject }

constructor TRouteObject.Create;
begin
  FMainForm := false;
end;

destructor TRouteObject.Destroy;
begin

  inherited;
end;

function TRouteObject.getAlias: string;
begin
  result := FAlias;
end;

function TRouteObject.getClassType: TComponentClass;
begin
  result := FClassType;
end;

function TRouteObject.getMainForm: boolean;
begin
  result := FMainForm;
end;

function TRouteObject.getOwner: TComponent;
begin
  result := FOwner;
end;

function TRouteObject.getReference: Pointer;
begin
  result := FReference;
end;

function TRouteObject.getRoute: string;
begin
  result := FRoute;
end;

class function TRouteObject.new: IRouteObject;
begin
  result := TRouteObject.Create;
end;

function TRouteObject.setClassType(const value: TComponentClass): IRouteObject;
begin
  result := self;
  FClassType := value;
end;

function TRouteObject.setMainForm(const value: boolean): IRouteObject;
begin
  result := self;
  FMainForm := value;
end;

function TRouteObject.setOwner(const value: TComponent): IRouteObject;
begin
  result := self;
  FOwner := value;
end;

function TRouteObject.setReference(const value: Pointer): IRouteObject;
begin
  result := self;
  FReference := value;
end;

function TRouteObject.setRoute(const value : string; const alias : string = '') : IRouteObject;
begin
  result := self;
  FRoute := value;
  if (alias <> '') then
    FAlias := alias
  else
    FAlias := FRoute;
end;

{ TRouteControl }

procedure TRouteControl.Add(route : IRouteObject);
begin
  if not (assigned(route)) then
    exit;

  FList.Add(route);
end;

function TRouteControl.Back(route : string = ''; params : IRouteParams = nil) : boolean;
var item : IRouteObject;
    x, i, count : integer;
    routes : string;
begin
  result := false;
  if (FListBack.Count <= 1) then
    exit;

  if (Trim(route) = '') then //retorna para a penúltima tela aberta
  begin
    item := FListBack.items[FListBack.Count - 2];
    FListBack.Delete(FListBack.Count - 1);
    self.Open(item.getRoute, params);
  end
  else
  begin
    for x := FListBack.Count - 1 downto 0 do
    begin
      item := FListBack.Items[x];

      routes := item.getRoute;
      if (routes = route) then
      begin
        //esconde todas as telas após a rota desejada
        i := x + 1;
        for count := i to FListBack.Count - 1 do
          FListBack.Delete(count);

        self.Open(item.getRoute, params);
        break;
      end;
    end;
  end;
end;

procedure TRouteControl.Clear(route : string; params : IRouteParams = nil; forceClose : boolean = false);
var item : IRouteObject;
    parameters : TRouteParams;
    routers : string;
    p : pointer;
    success : boolean;
begin
  success := false;
  if (trim(route) = '') then
    exit;

  //valida se está tentando excluir o layout aberto em tela agora
  routers := FActive.getRoute;
  if (routers = route) and not (forceClose) then
    exit;

  parameters := nil;
  if (assigned(params)) then
    parameters := TRouteParams(params);

  for item in FListBack do
  begin
    routers := item.getRoute;

    if (route = routers) then
    begin
      p := item.getReference;

      if (p <> nil) then
      begin
        if (assigned(TFrame(p).OnExit)) then
        begin
          if (TFrame(p) is TFrmPai) and (parameters <> nil) then
            TFrmPai(p).setParams(parameters.Obj);
          TFrame(p).OnExit(TFrame(p));
        end;

        TFrame(p).Visible := false;
        TFrame(p).Parent := nil;
      end;

      item.setReference(nil);
      MyFreeAndNil(p);

      FListBack.Remove(item);
      success := true;
      
      break;
    end;
  end;

  if not (success) and (forceClose) then
  begin
    p := FActive.getReference;

    if (p <> nil) and (assigned(TFrame(p).OnExit)) then
    begin
      if (TFrame(p) is TFrmPai) and (parameters <> nil) then
        TFrmPai(p).setParams(parameters.Obj);
      TFrame(p).OnExit(TFrame(p));

      TFrame(p).Visible := false;
      TFrame(p).Parent := nil;
    end;

    item.setReference(nil);
    FListBack.Remove(item);
  end;

  if (routers = route) then
    FActive := nil;
end;

constructor TRouteControl.Create(const Owner : TControl);
begin
  FOwner := Owner;
  FList := TList<IRouteObject>.Create;
  FListBack := TList<IRouteObject>.Create;

  FMainForm := TMainForm.Create;
  if (screen.ActiveForm = nil) and (FOwner.Parent is TCommonCustomForm) then
    FMainForm.MainForm := TCommonCustomForm(FOwner.Parent);
end;

destructor TRouteControl.Destroy;
var currentPointer : Pointer;
begin
  MyFreeAndNil(FMainForm);

  if (FActive <> nil) then //executa o onExit do último frame aberto
  begin
    currentPointer := FActive.getReference;
    if assigned(TFrame(currentPointer).OnExit) then
      TFrame(currentPointer).OnExit(TFrame(currentPointer));
  end;

  if (FList <> nil) then
  begin
    while (FList.Count > 0) do
      FList.Delete(0);
    MyFreeAndNil(FList);
  end;

  if (FListBack <> nil) then
  begin
    while (FListBack.Count > 0) do
    begin
      //executa o onExit de todos frames abertos até limpar todos
      if assigned(TFrame(FListBack.Items[0].getReference).OnExit) then
        TFrame(FListBack.Items[0].getReference).OnExit(FListBack.Items[0].getReference);

      FListBack.Delete(0);
    end;
    MyFreeAndNil(FListBack);
  end;

  FOwner := nil;
  FActive := nil;
  inherited;
end;

procedure TRouteControl.Open(route : string; params : IRouteParams = nil; effectType : TREffectType = etNone);
var item : IRouteObject;
    routeName : string;
    p, currentPointer : pointer;
    parameters : TRouteParams;
    eventsExecute : boolean;
begin
  if (trim(route) = '') then
    exit;
  if (FActive <> nil) and (FActive.getRoute = route) then
  begin
    //Caso está com a tela desejada aberta, executa somente o evento "setParams"
    p := FActive.getReference;
    if (assigned(params)) and (TFrame(p) is TFrmPai) then
      if ((TFrame(p) is TFrmPai) and (TFrmPai(p).FrameState = fsEnabledEvents)) or not (TFrame(p) is TFrmPai) then
        TFrmPai(p).setParams(TRouteParams(params).Obj);

    exit;
  end;

  parameters := nil;
  if (assigned(params)) then
    parameters := TRouteParams(params);

  for item in FList do
  begin
    routeName := item.getRoute;
    if (routeName = route) then
    begin
      eventsExecute := true;

      if (item.getMainForm) then //se for o formPrincipal só executa se o objeto não estiver criado ainda na memória
        eventsExecute := false;

      p := item.getReference;
      if not (assigned(item.getReference)) then
      begin
        eventsExecute := true;

        if (item.getOwner <> nil) then
          p := item.getClassType.Create(item.getOwner)
        else
          Application.CreateForm(item.getClassType, p);

        item.setReference(p);
      end;

      if (parameters <> nil) and (parameters.Obj <> nil) then
      begin
        if (eventsExecute) and (TFrame(p) is TFrmPai) and (parameters <> nil) then
          if ((TFrame(p) is TFrmPai) and (TFrmPai(p).FrameState = fsEnabledEvents)) or not (TFrame(p) is TFrmPai) then
            TFrmPai(p).setParams(parameters.Obj);
      end;

      if (eventsExecute) and (TFrame(p) is TFrmPai) then //Executa a rotina de manipulação visual
        TFrmPai(p).LoadLayout;

      TFrame(p).Width := FOwner.Width;
      TFrame(p).Height := FOwner.Height;
      TFrame(p).Parent := FOwner;

      if (effectType = etRightToLeft) then
      begin
        TFrame(p).Align := TAlignLayout.None;
        TFrame(p).Position.Y := 0;
        TFrame(p).Position.X := TFrame(p).Width;
        TFrame(p).BringToFront;
        TFrame(p).AnimateFloat(
          'Position.X',
          0,
          0.4,
          TAnimationType.Out,
          TInterpolationType.Back
        );
      end
      else if (effectType = etBottomToTop) then
      begin
        TFrame(p).Align := TAlignLayout.None;
        TFrame(p).Position.X := 0;
        TFrame(p).Position.Y := TFrame(p).Height;
        TFrame(p).BringToFront;
        TFrame(p).AnimateFloat(
          'Position.Y',
          0,
          0.4,
          TAnimationType.Out,
          TInterpolationType.Back
        );
      end
      else if (effectType = etCenterToSides) then //efeito do centro para as bordas
      begin
        TFrame(p).Align := TAlignLayout.None;
        TFrame(p).Height := 50;
        TFrame(p).Width := 50;
        TFrame(p).Position.X := Trunc((FOwner.Width / 2) - (TFrame(p).Width));
        TFrame(p).Position.Y := Trunc((FOwner.Height / 2) - (TFrame(p).Height));
        TFrame(p).BringToFront;

        TFrame(p).AnimateFloat(
          'Position.Y',
          0,
          0.4,
          TAnimationType.Out,
          TInterpolationType.Back
        );
        TFrame(p).AnimateFloat(
          'Position.X',
          0,
          0.4,
          TAnimationType.Out,
          TInterpolationType.Back
        );
        TFrame(p).AnimateFloat(
          'Width',
          FOwner.Width,
          0.4,
          TAnimationType.Out,
          TInterpolationType.Back
        );
        TFrame(p).AnimateFloat(
          'Height',
          FOwner.Height,
          0.4,
          TAnimationType.Out,
          TInterpolationType.Back
        );
      end;

      TThread.CreateAnonymousThread(procedure
        begin
          if (effectType <> etNone) then
            sleep(450);

          TThread.Synchronize(nil, procedure
            begin
              TFrame(p).Align := TAlignLayout.Client;

              //esconde o frameAtual
              if (FActive <> nil) then
              begin
                currentPointer := FActive.getReference;

                //só executa o "exit" se não for o mainFrame
                if not (FActive.getMainForm) and (TFrame(currentPointer) <> nil) and (assigned(TFrame(currentPointer).OnExit)) then
                  if ((TFrame(currentPointer) is TFrmPai) and (TFrmPai(currentPointer).FrameState = fsEnabledEvents)) or not (TFrame(currentPointer) is TFrmPai) then
                    TFrame(currentPointer).OnExit(TFrame(currentPointer));

                if (TFrame(currentPointer) <> nil) then
                  TFrame(currentPointer).Parent := nil;
              end;

              FActive := TRouteObject(item);

              try
                if (eventsExecute) and (assigned(TFrame(p).OnEnter)) then
                  if ((TFrame(p) is TFrmPai) and (TFrmPai(p).FrameState = fsEnabledEvents)) or not (TFrame(p) is TFrmPai) then
                    TFrame(p).OnEnter(TFrame(p));
              except
                //Para continuar o fluxo caso causar erro no onEnter do Frame
              end;

              //junta os eventos do formulário com os do frame ativo
              if (assigned(TFrame(p).OnKeyUp)) then
                FMainForm.onFrameKeyUp := TFrame(p).OnKeyUp;
              if (TFrame(p) is TFrmPai) then
              begin
                if (assigned(TFrmPai(p).OnKeyboardShown)) then
                  FMainForm.onFrameVirtualKeyboardShown := TFrmPai(p).OnKeyboardShown;
                if (assigned(TFrmPai(p).OnKeyboardHidden)) then
                  FMainForm.onFrameVirtualKeyboardHidden := TFrmPai(p).OnKeyboardHidden;

                //Caso o frame que está novamente sendo aberto estava aguardando
                //a reabertura, seta o status do frame como normal novamente
                if (TFrmPai(p).FrameState = fsDisabledEventsWithAutoReturn) then
                  TFrmPai(p).FrameState := fsEnabledEvents;
              end;

              //lista de formulários abertos
              if (FListBack.Count > 0) then
              begin
                if (FListBack.Items[FListBack.Count - 1].getRoute <> FActive.getRoute) then
                  FListBack.Add(FActive);
              end
              else
                FListBack.Add(FActive);
            end)
        end).Start;

      break;
    end;
  end;
  parameters := nil;
end;

{ TRouteParams }

function TRouteParams.AddPair(pKey: string; pValue: double): IRouteParams;
begin
  result := self;
  FObj.AddPair(pKey, TJSONNumber.Create(pValue));
end;

function TRouteParams.AddPair(pKey: string; pValue: integer): IRouteParams;
begin
  result := self;
  FObj.AddPair(pKey, TJSONNumber.Create(pValue));
end;

function TRouteParams.AddPair(pKey, pValue: string): IRouteParams;
begin
  result := self;
  FObj.AddPair(pKey, pValue);
end;

function TRouteParams.AddPair(pKey: string; pValue: TDateTime): IRouteParams;
begin
  result := self;
  FObj.AddPair(pKey, DateTimeToStr(pValue));
end;

function TRouteParams.AddPair(pKey: string; pValue: TDate): IRouteParams;
begin
  result := self;
  FObj.AddPair(pKey, DateToStr(pValue));
end;

function TRouteParams.AddPair(pKey: string; pValue: boolean): IRouteParams;
begin
  result := self;
  FObj.AddPair(pKey, TJSONBool.Create(pValue));
end;

constructor TRouteParams.Create;
begin
  FObj := TJSONObject.Create;
end;

destructor TRouteParams.Destroy;
begin
  if (FObj <> nil) then
    MyFreeAndNil(FObj);

  inherited;
end;

class function TRouteParams.new: IRouteParams;
begin
  result := TRouteParams.Create;
end;

function TRouteParams.SetObj(const Value: TJSONObject) : IRouteParams;
begin
  result := self;
  if (FObj <> nil) and (Value <> nil) then
    MyFreeAndNil(FObj);

  FObj := Value;
end;

function TRouteParams.AddPair(pKey: string; pValue: TJSONValue): IRouteParams;
begin
  result := self;
  if (pValue = nil) then
    exit;

  FObj.AddPair(pKey, TJSONValue(pValue.Clone));
end;

{ TMainForm }

constructor TMainForm.Create;
begin
  FMainForm := nil;
  if (Screen.ActiveForm = nil) then
    exit;
  MainForm := Screen.ActiveForm;
end;

destructor TMainForm.Destroy;
begin
  if (FMainForm <> nil) then
  begin
    if assigned(FOldOnKeyUp) then
      FMainForm.OnKeyUp := FOldOnKeyUp;
    FOldOnKeyUp := nil;
  end;

  inherited;
end;

procedure TMainForm.OnKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if (assigned(FOldOnKeyUp)) then
    FOldOnKeyUp(Sender, Key, KeyChar, Shift);

  if (assigned(onFrameKeyUp)) then
    FonFrameKeyUp(Sender, Key, KeyChar, Shift);
end;

procedure TMainForm.OnVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  if (assigned(FOldVirtualKeyboardHidden)) then
    FOldVirtualKeyboardHidden(Sender, KeyboardVisible, Bounds);

  if (assigned(onFrameVirtualKeyboardHidden)) then
    FonFrameVirtualKeyboardHidden(Sender, KeyboardVisible, Bounds);
end;

procedure TMainForm.OnVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  if (assigned(FOldVirtualKeyboardShown)) then
    FOldVirtualKeyboardShown(Sender, KeyboardVisible, Bounds);

  if (assigned(onFrameVirtualKeyboardShown)) then
    FonFrameVirtualKeyboardShown(Sender, KeyboardVisible, Bounds);
end;

procedure TMainForm.SetMainForm(const Value: TCommonCustomForm);
begin
  if (FMainForm <> nil) then
  begin
    if assigned(FOldOnKeyUp) then
      FMainForm.OnKeyUp := FOldOnKeyUp;
    if assigned(FOldVirtualKeyboardShown) then
      FMainForm.OnVirtualKeyboardShown := FOldVirtualKeyboardShown;
    if assigned(FOldVirtualKeyboardHidden) then
      FMainForm.OnVirtualKeyboardHidden := FOldVirtualKeyboardHidden;

    FOldOnKeyUp := nil;
    FOldVirtualKeyboardShown := nil;
    FOldVirtualKeyboardHidden := nil;
  end;

  FMainForm := Value;
  if (assigned(FMainForm.OnKeyUp)) then
    FOldOnKeyUp := FMainForm.OnKeyUp;
  if (assigned(FMainForm.OnVirtualKeyboardShown)) then
    FOldVirtualKeyboardShown := FMainForm.OnVirtualKeyboardShown;
  if (assigned(FMainForm.OnVirtualKeyboardHidden)) then
    FOldVirtualKeyboardHidden := FMainForm.OnVirtualKeyboardHidden;

  FMainForm.OnKeyUp := OnKeyUp;
  FMainForm.OnVirtualKeyboardShown := OnVirtualKeyboardShown;
  FMainForm.OnVirtualKeyboardHidden := OnVirtualKeyboardHidden;
end;

procedure TMainForm.SetonFrameKeyUp(const Value: TKeyEvent);
begin
  FonFrameKeyUp := Value;
end;

procedure TMainForm.SetonFrameVirtualKeyboardHidden(const Value: TVirtualKeyboardEvent);
begin
  FonFrameVirtualKeyboardHidden := Value;
end;

procedure TMainForm.SetonFrameVirtualKeyboardShown(const Value: TVirtualKeyboardEvent);
begin
  FonFrameVirtualKeyboardShown := Value;
end;

end.
