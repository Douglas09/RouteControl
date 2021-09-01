## Route Control ##

Este recurso foi desenvolvido para facilitar o controle, transação e gerenciamento das telas abertas dentro de seu aplicativo. 
Ele foi baseado no estilo e funcionamento das rotas utilizadas na linguagem ReactJS.

### Como utilizar ###

###### Novo projeto

- Crie um projeto em branco com apenas um form;
- Importe em seu projeto a unit "route.controller.pas";
- Adicione nas uses do form a unit "route.controller";
- Adicione em seu projeto também o "frame.pai.pas". Ele será utilizado para criação das próximas telas de seu sistema com o recurso da herança.
- Declare uma variável do tipo "TRouteControl":

![image](https://user-images.githubusercontent.com/17827174/131702370-dfa53af9-146b-4b0f-b36b-d05b309cf3df.png)

- Em seu formulário adicione um componente que herde da classe TControl e que deseja utilizar como a tela de exibição do nosso projeto: TRectangle, TRect, TLayout, ...
- Em um dos eventos de abertura do form, instancie a variável criada passando de parâmetro o componente herdado do TControl:

![image](https://user-images.githubusercontent.com/17827174/131702822-90eb31c4-6d89-4792-a414-1bcdc812667b.png)

- Crie um novo frame herdando o FrmPai, como por exemplo "FrmCliente";
- Adicione o nome da uses do novo frame criado no form;
- Declare uma variável no escopo superior do form:

![image](https://user-images.githubusercontent.com/17827174/131703612-3945ed86-0bb8-43b5-b83d-2d7ae8263c9c.png)

```
  route := TRouteControl.Create(lyScreen);
```

- Mapeie este novo frame que você acabou de criar dentro do componente de rotas após logo após a instanciação da variável de rotas:

![image](https://user-images.githubusercontent.com/17827174/131703847-94c714e3-d274-4d18-bbcb-2066b917ca8f.png)

```
  route.Add(TRouteObject.new
    .setRoute(routeCliente)
    .setClassType(TFrmCliente)
    .setReference(frameCliente)
  );
```


