unit route.consts;

interface

uses route.controller;

type
  IRouteParams = route.controller.IRouteParams;
  TRouteParams = route.controller.TRouteParams;
  IRouteObject = route.controller.IRouteObject;
  TRouteObject = route.controller.TRouteObject;
  TRouteControl = route.controller.TRouteControl;
  TREffectType = route.controller.TREffectType;

const
  routePrincipal = 'ROUTE/PRINCIPAL';
  routeVenda = 'ROUTE/VENDA';
  routeProduto = 'ROUTE/PRODUTO';
  routeCliente = 'ROUTE/CLIENTE';

implementation

end.
