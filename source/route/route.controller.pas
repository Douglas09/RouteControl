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
    function AddPair(pKey : string; pValue : string) : IRouteParams; overload;
    function AddPair(pKey : string; pValue : integer) : IRouteParams; overload;
    function AddPair(pKey : string; pValue : double) : IRouteParams; overload;
    function AddPair(pKey : string; pValue : boolean) : IRouteParams; overload;
    function AddPair(pKey : string; pValue : TDate) : IRouteParams; overload;
    function AddPair(pKey : string; pValue : TDateTime) : IRouteParams; overload;
  end;

  TRouteParams = class(TInterfacedObject, IRouteParams)
  private
    FObj: TJSONObject;
    procedure SetObj(const Value: TJSONObject);
  public
    constructor Create;
    destructor Destroy; override;
    class function new : IRouteParams;

    property Obj : TJSONObject read FObj write SetObj;

    function AddPair(pKey : string; pValue : string) : IRouteParams; overload;
    function AddPair(pKey : string; pValue : integer) : IRouteParams; overload;
    function AddPair(pKey : string; pValue : double) : IRouteParams; overload;
    function AddPair(pKey : string; pValue : boolean) : IRouteParams; overload;
    function AddPair(pKey : string; pValue : TDate) : IRouteParams; overload;
    function AddPair(pKey : string; pValue : TDateTime) : IRouteParams; overload;
  end;

  IRouteObject = interface
    ['{7D3B9D4C-3E1D-415C-AD22-7B216C8788DC}']
    function setRoute(const value : string; const alias : string = '') : IRouteObject;
    function getRoute : string;
    function getAlias : string;
    function setClassType(const value : TComponentClass) : IRouteObject;
    function getClassType : TComponentClass;
    function setReference(const value : Pointer) : IRouteObject;
    function getReference : Pointer;
  end;

  TRouteObject = class(TInterfacedObject, IRouteObject)
  private
    FRoute : string;
    FAlias : string;
    FReference: Pointer;
    FClassType : TComponentClass;
  public
    constructor Create;
    destructor Destroy; override;
    class function new : IRouteObject;

    function setRoute(const value : string; const alias : string = '') : IRouteObject;
    function getRoute : string;
    function getAlias : string;
    function setClassType(const value : TComponentClass) : IRouteObject;
    function getClassType : TComponentClass;
    function setReference(const value : Pointer) : IRouteObject;
    function getReference : Pointer;
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

    property MainForm : TCommonCustomForm read FMainForm write SetMainForm;

    //KeyUp do frame ativo no momento
    property onFrameKeyUp : TKeyEvent read FonFrameKeyUp write SetonFrameKeyUp;
    //Ao exibir o teclado
    property onFrameVirtualKeyboardShown : TVirtualKeyboardEvent read FonFrameVirtualKeyboardShown write SetonFrameVirtualKeyboardShown;
    //Ao esconder o teclado
    property onFrameVirtualKeyboardHidden : TVirtualKeyboardEvent read FonFrameVirtualKeyboardHidden write SetonFrameVirtualKeyboardHidden;
  end;

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

    /// <summary> Mapeia todas as possíveis rotas dentro do controle </summary>
    procedure Add(route : IRouteObject);

    /// <summary> Carrega uma das rotas no layout principal </summary>
    procedure Open(route : string; params : IRouteParams = nil);
    /// <summary> Fecha e limpa da memória uma rota que foi carregada no layout principal </summary>
    procedure Clear(route : string; params : IRouteParams = nil);

    /// <summary> Volta para a rota anterior aberta, caso existir </summary>
    function Back(route : string = '') : boolean;
  end;

procedure MyFreeAndNil(const [ref] Obj: TObject);

implementation

uses frame.pai, System.SysUtils;

{ TRouteObject }

constructor TRouteObject.Create;
begin

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

function TRouteControl.Back(route: string): boolean;
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
    self.Open(item.getRoute);
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

        self.Open(item.getRoute);
        break;
      end;
    end;
  end;
end;

procedure TRouteControl.Clear(route: string; params: IRouteParams);
var item : IRouteObject;
    parameters : TRouteParams;
    routers : string;
    p : pointer;
begin
  if (trim(route) = '') then
    exit;

  //valida se está tentando excluir o layout aberto em tela agora
  routers := FActive.getRoute;
  if (routers = route) then
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

      if (p <> nil) and (assigned(TFrame(p).OnExit)) then
      begin
        if (TFrame(p) is TFrmPai) then
          TFrmPai(p).setParams(parameters.Obj);
        TFrame(p).OnExit(TFrame(p));
      end;

      item.setReference(nil);
      FListBack.Remove(item);
      break;
    end;
  end;
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
  if (FMainForm <> nil) then
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
    MyFreeAndNil(FListBack);

  FOwner := nil;
  FActive := nil;
  inherited;
end;

procedure TRouteControl.Open(route : string; params : IRouteParams = nil);
var item : IRouteObject;
    routeName : string;
    p, currentPointer : pointer;
    parameters : TRouteParams;
begin
  if (trim(route) = '') then
    exit;
  if (FActive <> nil) and (FActive.getRoute = route) then
    exit;

  parameters := nil;
  if (assigned(params)) then
    parameters := TRouteParams(params);

  for item in FList do
  begin
    routeName := item.getRoute;
    if (routeName = route) then
    begin
      p := item.getReference;
      if not (assigned(item.getReference)) then
      begin
        Application.CreateForm(item.getClassType, p);
        item.setReference(p);
      end;

      //esconde o frameAtual
      if (FActive <> nil) then
      begin
        currentPointer := FActive.getReference;
        if assigned(TFrame(currentPointer).OnExit) then
          TFrame(currentPointer).OnExit(TFrame(currentPointer));

        TFrame(currentPointer).Parent := nil;
      end;

      FActive := TRouteObject(item);

      if (parameters <> nil) and (parameters.Obj <> nil) then
      begin
        if (TFrame(p) is TFrmPai) then
          TFrmPai(p).setParams(parameters.Obj);
      end;

      TFrame(p).Width := FOwner.Width;
      TFrame(p).Height := FOwner.Height;
      TFrame(p).Parent := FOwner;


      if assigned(TFrame(p).OnEnter) then
        TFrame(p).OnEnter(TFrame(p));

      //junta os eventos do formulário com os do frame ativo
      if (assigned(TFrame(p).OnKeyUp)) then
        FMainForm.onFrameKeyUp := TFrame(p).OnKeyUp;
      if (TFrame(p) is TFrmPai) then
      begin
        if (assigned(TFrmPai(p).OnKeyboardShown)) then
          FMainForm.onFrameVirtualKeyboardShown := TFrmPai(p).OnKeyboardShown;
        if (assigned(TFrmPai(p).OnKeyboardHidden)) then
          FMainForm.onFrameVirtualKeyboardHidden := TFrmPai(p).OnKeyboardHidden;
      end;

      //lista de formulários abertos
      if (FListBack.Count > 0) then
      begin
        if (FListBack.Items[FListBack.Count - 1].getRoute <> FActive.getRoute) then
          FListBack.Add(FActive);
      end
      else
        FListBack.Add(FActive);

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

procedure TRouteParams.SetObj(const Value: TJSONObject);
begin
  if (FObj <> nil) and (Value <> nil) then
    MyFreeAndNil(FObj);

  FObj := Value;
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

procedure MyFreeAndNil(const [ref] Obj: TObject);
begin
  if not (assigned(Obj)) or (Obj = nil) then
    exit;

  {$IFDEF ANDROID}
    Obj.DisposeOf;
  {$ELSE}
    {$IF CompilerVersion >= 34.0}
      FreeAndNil(Obj);
    {$ELSE}
      Obj.Free;
    {$ENDIF}
  {$ENDIF}
end;


end.
