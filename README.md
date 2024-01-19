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
  route := TRouteControl.Create(Self);
```

6 - Em um dos eventos de abertura do form, instancie a variável criada passando de parâmetro um componente visual que herda do TComponent (TLayout/TRectangle) ou o único formulário do projeto (Self):

![image](https://user-images.githubusercontent.com/17827174/131702822-90eb31c4-6d89-4792-a414-1bcdc812667b.png)

7 - Crie um novo frame herdando o FramePai, como por exemplo "FrameCliente";

8 - Adicione o nome da uses do novo frame criado no form;

9 - Declare uma constante do tipo string com o nome da rota que será utilizada para abrir o frame recém criado de qualquer tela dentro do sistema:

![image](https://github.com/Douglas09/RouteControl/assets/17827174/4bb107d4-8d4a-4438-8654-506bc333476a)

10 - Adicione o TFrame criado juntamente com a constante que você declarou como sendo o nome da rota dentro da variável "route":

![image](https://github.com/Douglas09/RouteControl/assets/17827174/21d212c2-72d1-4ef4-88ae-6761fc36edb0)

```
  route.Add(routeCliente, TFrmCliente);
```

Cada novo frame criado dentro do projeto que você desejar utiliza-lo como tela de exibição de conteúdo, você precisará repetir os passos "7, 8, 9 e 10".

Este é o processo de declaração e instanciação deste recurso.



### Eventos disponíveis e disparados do frame



***Eventos padrões do frame***
- **OnEnter** -> Este evento do frame é disparado ao ser exibido o frame;
 - **OnExit** -> Este evento do frame é disparado antes de outro frame sobrepor o frame atual sobre a tela;
 - **OnKeyUp** -> Este evento do frame é disparado quando algum botão é pressionado;
 
***Eventos implementados: Eles precisam ser sobreescritos nos frames filhos que desejam utiliza-los*** 
- **OnKeyboardShown** -> Este evento é disparado apenas quando o teclado virtual é exibido sobre a aplicação (utilizado no mobile);
- **OnKeyboardHidden** -> Este evento é disparado apenas quando o teclado virtual estava visível e foi escondido (utilizado no mobile);
- **SetParams** -> Este evento é disparado caso for passado algum parâmetro no procedimento **Open**, **Back** e **Clear** da classe TRouteControl;
- **OnReturn** -> Este evento é disparado somente na situação:
````
  Frame1 está aberto;
  Frame1 abriu o Frame2;
  Frame2 executou todo seu fluxo;
  Frame2 fechou e voltou para o Frame1 retornando parâmetros na propriedade IRouteParams;
  Frame1 executará o evento "onReturn" independente do status atual da propriedade "FrameState" do frame1;
````


### Transações entre telas



#### Exibir um frame na tela (Equivalente ao form.show ou form.showModal)

Ao utilizar este recurso da classe "TRouteControl", você estará carregando um frame para ser exibido dentro do componente herdado do TControl que está dentro de seu form.

Procedure: **Open()**;

Parâmetros: 
  
  - **route** -> Nome da rota que foi definida no item "11" acima. *Parâmetro obrigatório*
  
  - **params** -> Um objeto onde você adicionará parâmetros que serão repassados para o frame executar alguma ação específica, como abrir um determinado registro, exibir uma determinada informação na tela. Você pode passar quantos parâmetros achar necessário. O evento utilizado para leitura destes parâmetros é o **setParams()**. *Parâmetro opcional*
  - **effectType** -> Este parâmetro é responsável pelo efeito de apresentação do frame em tela. | **etNone** = Nenhum efeito | **etRightToLeft** = O frame inicia a apresentação da direita para a esquerda | **etBottomToTop** = O frame inicia a apresentação de baixo para cima | *Parâmetro opcional*
```
  route.Open(
    'ROUTE/CLIENTE',
    TRouteParams.new
      .AddPair('codigo', 192817)
      .AddPair('nome', 'Jucelino Roman')
      .AddPair('somenteLeitura', true)
  );
``` 

#### Fechar a tela atual e volta para a anterior ou qualquer outra que já esteja aberta

Este recurso serve para voltar para a última tela exibida ou para uma determinada rota que já tenha sido aberta anteriormente.

Procedure: **Back()**;

Parâmetros:

   - **route** -> Nome da rota que foi definida no item "11" acima e que você deseja voltar para ela. Caso este parâmetro for passado em branco '', por padrão sempre voltará para a penúltima tela que foi aberta.

```
  route.Back('');
``` 

#### Fecha o frame exibido em tela e apaga seu ponto de referência da memória

Este recurso é utilizado para esconder e destruir um frame que já tenha sido exibido em seu aplicativo durante a utilização.

Procedure: **Clear()**;

Parâmetros:

  - **route** -> Nome da rota que foi definida no item "11" acima. *Parâmetro obrigatório*
  
  - **params** -> Um objeto onde você adicionará parâmetros que serão repassados para o frame executar alguma ação específica, como abrir um determinado registro, exibir uma determinada informação na tela. Você pode passar quantos parâmetros achar necessário. O evento utilizado para leitura destes parâmetros é o **setParams()**. *Parâmetro opcional*

```
  route.Clear(
    'ROUTE/CLIENTE',
    TRouteParams.new
      .AddPair('deleteCustomer', 12312)
  );
``` 


![image](https://user-images.githubusercontent.com/17827174/131731506-dec4da4d-fa1a-40f6-a590-40f43b809498.png)
