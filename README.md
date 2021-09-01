## Route Control ##

Este recurso foi desenvolvido para facilitar o controle, transação e gerenciamento das telas abertas dentro de seu aplicativo. 
Ele foi baseado no estilo e funcionamento das rotas de linguagens web.

### Novo projeto -> Como utilizar ###

##### Declaração e instanciação

1 - Crie um projeto em branco com apenas um form.

2 - Importe em seu projeto a unit "route.controller.pas".

3 - Adicione nas uses do form a unit "route.controller".
 
4 - Adicione em seu projeto também o "frame.pai.pas". Ele será utilizado para criação das próximas telas de seu sistema com o recurso da herança.

5 - Declare uma variável do tipo "TRouteControl":

![image](https://user-images.githubusercontent.com/17827174/131702370-dfa53af9-146b-4b0f-b36b-d05b309cf3df.png)

```
  route := TRouteControl.Create(lyScreen);
```

6 - Em seu formulário adicione um componente que herde da classe TControl e que deseja utilizar como a tela de exibição do nosso projeto: TRectangle, TRect, TLayout, ...

7 - Em um dos eventos de abertura do form, instancie a variável criada passando de parâmetro o componente herdado do TControl:

![image](https://user-images.githubusercontent.com/17827174/131702822-90eb31c4-6d89-4792-a414-1bcdc812667b.png)

8 - Crie um novo frame herdando o FrmPai, como por exemplo "FrmCliente";

9 - Adicione o nome da uses do novo frame criado no form;

10 - Declare uma variável no escopo superior do form:

![image](https://user-images.githubusercontent.com/17827174/131703612-3945ed86-0bb8-43b5-b83d-2d7ae8263c9c.png)

11 - Mapeie este novo frame que você acabou de criar dentro do componente de rotas após logo após a instanciação da variável de rotas e de um nome para a rota, como por exemplo "ROUTE/CLIENTE":

![image](https://user-images.githubusercontent.com/17827174/131704052-6f023ce2-2020-4ac9-be43-8689f62ea853.png)

```
  route.Add(TRouteObject.new
    .setRoute('ROUTE/CLIENTE')
    .setClassType(TFrmCliente)
    .setReference(frameCliente)
  );
```

Cada novo frame criado dentro do projeto que você desejar utiliza-lo como tela de exibição de conteúdo, você precisará repetir os passos "8, 9, 10 e 11".

Este é o processo de declaração e instanciação deste recurso.

##### Transações entre telas

###### Exibir um frame na tela (Equivalente ao form.show ou form.showModal)

- Ao utilizar este recurso da classe "TRouteControl", você estará carregando um frame para ser exibido dentro do componente herdado do TControl que está dentro de seu form.
Procedure: Open();

Parâmetros: 
  
  - "route" -> Nome da rota que foi definida no item "11" a cima. **Parâmetro obrigatório**
  
  - "params" -> Um objeto onde você adicionará parâmetros que serão repassados para o frame executar alguma ação específica, como abrir um determinado registro, exibir uma determinada informação na tela. Você pode passar quantos parâmetros achar necessário. **Parâmetro opcional**
    
```
  route.Open(
    'ROUTE/CLIENTE',
    TRouteParams.new
      .AddPair('codigo', 192817)
      .AddPair('nome', 'Jucelino Roman')
      .AddPair('somenteLeitura', true)
  );
``` 
