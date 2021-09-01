## Route Control ##

Este recurso foi desenvolvido para facilitar o controle, transação e gerenciamento das telas abertas dentro de seu aplicativo. 
Ele foi baseado no estilo e funcionamento das rotas utilizadas na linguagem ReactJS.

### Como utilizar ###

###### Declaração e instanciação

- Crie um projeto em branco com apenas um form;
- Importe em seu projeto a unit "route.controller.pas";
- Adicione nas uses do form a unit "route.controller";
- Adicione em seu projeto também o "frame.pai.pas". Ele será utilizado para criação das próximas telas de seu sistema com o recurso da herança.
- Declare uma variável do tipo "TRouteControl":
![image](https://user-images.githubusercontent.com/17827174/131702370-dfa53af9-146b-4b0f-b36b-d05b309cf3df.png)

- Em seu formulário adicione um componente que herde da classe TControl e que deseja utilizar como a tela de exibição do nosso projeto: TRectangle, TRect, TLayout, ...
- Em um dos eventos de abertura do form, instancie a variável criada passando de parâmetro o componente herdado do TControl:
![image](https://user-images.githubusercontent.com/17827174/131702822-90eb31c4-6d89-4792-a414-1bcdc812667b.png)
- 


```
  MyFreeAndNil(object);
```
