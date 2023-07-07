## API Rest - Crystal/Kemal - Docker - MySql - Integração entre Api 

**Api Plano de Viagem**

Esta é uma simples Api para registro de planos de viagem no universo Rick and Morty em https://rickandmortyapi.com que é outra Api que possui dados de vários personagens que participam de episódios em diferentes localidades dos quais são assistidos por residentes e que será consumida por esta Api para obtensão das localidades para os planos de viagem. 

Esta Api Plano de Viagem armazena em banco de dados MySql, em container docker, todos os planos de viagem criados nela e, para cada requisição feita, os dados das localidades são obtidos na Api Rick e Morty e armazenados temporariamente para realização dos cálculos de popularidade das localidades.

Uma localidade obtida via Api Rick and Morty representa uma parada no plano de viagem. O objetivo da Api Plano de Viagem é calcular a popularidade das localidades para auxiliar na escolha de planos de viagem. A popularidade de uma localidade é a soma da quantidade de episódios que cada residente daquela localidade assistiu, ou seja, (popularidade = episódios x residentes) para cada localidade.

As localidades estão agrupadas por dimensões e os resultados de consultas são ordenados de acordo com a média de popularidade de cada dimensão e, para cada dimensão, as localidades com menor popularidade. O valor da dimensão é a média do somatório da popularidade de todas as localidades de uma mesma dimensão e as dimensões com menor média serão exibidas primeiro seguidas das localidades de menor popularidade.

O propósito desta Api é demonstrar um código simples para estudos de aplicação da linguagem Crystal em container Docker e também com o uso de http/client pra integração com outra Api hospedada em site sem restrição CORS (Cross-Origin Resource Sharing).

**Exemplo da regra de negócio**
Para as seguintes paradas de um plano de viagem:
json
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

A popularidade de cada localização é:
- Abadango (ID 2): 1
- Immortality Field Resort (ID 7): 7
- Purge Planet (ID 9): 4
- Bepis 9 (ID 11): 4
- Gromflom Prime (ID 19): 0

E a de cada dimensão é:
- unknown: 4.0
- Replacement Dimension: 2.0

Portanto o resultado esperado para uma query com **optimize* e sem **expand* é:
json
{
  "id": id do travel plan,
  "travel_stops":[19,9,2,11,7]
}

### Instalação para desenvolvimento

**Crystal Language** 
Instalação do compilador. 
Acesse https://crystal-lang.org 
Versão utilizada 1.8.2

**Docker**
Instalação do Docker. 
Acesse https://www.docker.com
Versão utilizada 24.0.2

**Visual Studio Code**
Instalação do VSCODE. 
Acesse https://code.visualstudio.com

**MySQl** 
Utilizado imagem docker na versão 5.7.42

### Executar a Api Plano de Viagem

Para executar a api, na pasta raiz do código, digite **docker-compose up -d**
Dois containers serão instanciados, a Api e o MySql, uma rede privada também será criada para acesso comunicação entre os containers.

Para executar os testes, na pasta raiz do código, digite **crystal spec**

**Os dados não são persistidos**
O volume criado para o banco de dados MySql é temporário, não é realizado o mapeamento do volume do container.

**Uso de ORM (Object-Relational Mapping) e demais técnicas de programação**
Os métodos de acesso a banco de dados não utilizam ORM e nem tratam aspectos de isolamento de rede ou transações atômicas para integridade de dados ou tratamento de exceções.

**Acesso**
http://localhost:3000/travel_plans
http://localhost:3000/travel_plans/{id}

Parâmetros: expand e optimize (boolean)

Implementados os métodos GET, POST, PUT e DELETE

### Exemplos de uso

**Criar um plano de viagem**
**Método** 
POST
**Url** 
http://localhost:3000/travel_plans
**Headers** 
Content-Type: application/json
**Body**
{"travel_stops": [2,7,9,11,19]}
**Response status 201**
    {
      "id": 1,
      "travel_stops": [2,7,9,11,19]
    }


**Consultar um plano de viagem**
**Método**
GET 
**Url**
http://localhost:3000/travel_plans/1
**Headers** 
Content-Type: application/json
**Response status 200**
    {
      "id": 1,
      "travel_stops": [2,7,9,11,19]
    }


**Consultar um plano de viagem não expandido e otimizado**
**Método**
GET 
**Url**
http://localhost:3000/travel_plans/1?expand=false&optimize=true
**Headers** 
Content-Type: application/json
**Response status 200**
    {
      "id": 1,
      "travel_stops": [19,9,2,11,7]
    }


**Modificar um plano de viagem**
**Método**
PUT 
**Url**
http://localhost:3000/travel_plans/1
**Headers** 
Content-Type: application/json
**Body**
{"travel_stops": [2,7,9,11]}
**Response status 200**
    {
      "id": 1,
      "travel_stops": [2,7,9,11]
    }


**Remover um plano de viagem**
**Método**
DELETE 
**Url**
http://localhost:3000/travel_plans/1
**Headers** 
Content-Type: application/json
**Response status 204**
Sem corpo