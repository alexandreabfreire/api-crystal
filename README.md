# API Rest - Crystal/Kemal - Docker - MySql - Integração entre APIs

**Api Plano de Viagem**

Esta é uma simples API para criação de planos de viagem no universo Rick and Morty em https://rickandmortyapi.com que é outra API que armazena dados de vários personagens que participam de episódios em diferentes localidades os quais são vistos por residentes. Estes dados são consumidos aqui para exibição dos planos de viagem. 

Os planos de viagem são armazenados em banco de dados MySql, instalado em container docker, e para cada requisição *http* feita, o plano de viagem é identificado e os dados das localidades contidas no plano são obtidos na API Rick e Morty via consulta Graphql e armazenados temporariamente no mesmo banco de dados para a realização dos cálculos de popularidade daquelas localidades.

Cada localidade obtida na API Rick and Morty representa uma parada no plano de viagem e a API Plano de Viagem calcula a popularidade das localidades para exibir os planos de viagem ordenados em base a popularidade. A popularidade de uma localidade é a soma da quantidade de episódios que cada residente daquela localidade visitou, ou seja, (popularidade = episódios x residentes) para cada localidade.

As localidades estão classificadas por dimensões e os resultados *json* das requisições *http* são ordenados de forma ascendente pela média de popularidade da dimensão seguida do nome da dimensão e, para cada dimensão, a popularidade da localidade e o nome dela. O valor de uma dimensão é a média do somatório da popularidade de todas as localidades que pertencem à dimensão.

A API Plano de Viagem apresenta um código simples para estudos de aplicabilidade da linguagem Crystal com Kemal em container Docker para construção de API Rest e também com o uso de http/client pra integração com outra API hospedada em site sem restrição CORS (Cross-Origin Resource Sharing).

**Exemplo do cálculo da popularidade para ordenação**

Para as seguintes paradas (localidades) de um plano de viagem:

*json*
```
[
  {
    "id": "2",
    "name": "Abadango",
    "dimension": "unknown",
    "residents": [
      { "episode": [...1 item], ... }
    ]
  },
  {
    "id": "7",
    "name": "Immortality Field Resort",
    "dimension": "unknown",
    "residents": [
      { "episode": [...5 items], ... },
      { "episode": [...1 item], ... },
      { "episode": [...1 item], ... }
    ]
  },
  {
    "id": "9",
    "name": "Purge Planet",
    "dimension": "Replacement Dimension",
    "residents": [
      { "episode": [...1 item], ... },
      { "episode": [...1 item], ... },
      { "episode": [...1 item], ... },
      { "episode": [...1 item], ... }
    ]
  },
  {
    "id": "11",
    "name": "Bepis 9",
    "dimension": "unknown",
    "residents": [
      { "episode": [...4 items], ... }
    ]
  },
  {
    "id": "19",
    "name": "Gromflom Prime",
    "dimension": "Replacement Dimension",
    "residents": []
  }
]
```
A popularidade de cada localização é:
- Abadango (ID 2): 1
- Immortality Field Resort (ID 7): 7
- Purge Planet (ID 9): 4
- Bepis 9 (ID 11): 4
- Gromflom Prime (ID 19): 0

E a de cada dimensão é:
- unknown: 4.0
- Replacement Dimension: 2.0

Portanto o resultado esperado para uma query com *optimize* e sem *expand* é:

*json*
```
{
  "id": id do travel plan,
  "travel_stops":[19,9,2,11,7]
}
```

### Instalação para desenvolvimento

**Ubuntu**

Versão 22.04.2

**Crystal Language**

https://crystal-lang.org 

O compilador utilizado foi na versão 1.8.2

**Docker**

https://www.docker.com 

Utilizada a versão 24.0.2

**MySql**

Utilizada a imagem na versão 5.7.42

**Visual Studio Code**

https://code.visualstudio.com

Instalar as extensões Crystal language e Docker.

### Executar a Api Plano de Viagem

Para executar a api digite **docker-compose up -d**

Dois containers serão instanciados, a Api e o MySql, uma rede privada também será criada para comunicação entre os containers.

Para executar os testes digite **crystal spec**

**Acesso**

*http://localhost:3000/travel_plans*

*http://localhost:3000/travel_plans/{id}*

Parâmetros:

- *expand* (boolean) define quais serão os dados de retorno, se igual a "true", serão exibidas as propriedades da localidade.

- *optimize* (boolean) define a ordenação dos dados de retorno, se igual a "true", as localidades serão exibidos em ordem ascendente por média de popularidade da dimensão (calculado) , nome da dimensão (dimension), popularidade da localidade (calculado) e nome da localidade (name).

Implementados os métodos GET, POST, PUT e DELETE

### Exemplos de uso

**Criar um plano de viagem**

**Método**

*POST*

**Url** 

*http://localhost:3000/travel_plans*

**Headers** 

*Content-Type: application/json*

**Body**

```
{"travel_stops": [2,7,9,11,19]}
```

**Response status 201**

```
    {
      "id": 1,
      "travel_stops": [2,7,9,11,19]
    }
```

**Consultar um plano de viagem**

**Método**

*GET*

**Url**

*http://localhost:3000/travel_plans/1*

**Headers** 

*Content-Type: application/json*

**Response status 200**

```
    {
      "id": 1,
      "travel_stops": [2,7,9,11,19]
    }
```

**Consultar um plano de viagem não expandido e otimizado**

**Método**

*GET*

**Url**

*http://localhost:3000/travel_plans/1?expand=false&optimize=true*

**Headers** 

*Content-Type: application/json*

**Response status 200**

```
    {
      "id": 1,
      "travel_stops": [19,9,2,11,7]
    }
```

**Modificar um plano de viagem**

**Método**

*PUT*

**Url**

*http://localhost:3000/travel_plans/1*

**Headers** 

*Content-Type: application/json*

**Body**

```
{"travel_stops": [2,7,9,11]}
```

**Response status 200**

```
    {
      "id": 1,
      "travel_stops": [2,7,9,11]
    }
```

**Remover um plano de viagem**

**Método**

*DELETE*

**Url**

*http://localhost:3000/travel_plans/1*

**Headers** 

*Content-Type: application/json*

**Response status 204**

*Sem corpo*

### Nota

**Os dados do plano de viagem não são persistidos**

Não é realizado mapeamento de volume do container.