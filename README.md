# bookstore
bookstore
Esta é a API de uma livraria construída com Django e Django Rest Framework. O projeto permite o gerenciamento de produtos, categorias e pedidos de usuários.

Funcionalidades
A API inclui as seguintes funcionalidades:

Produtos:

Gerenciar produtos com título, descrição, preço, status de ativo e uma ou mais categorias.

Categorias:

Gerenciar categorias de produtos com título, slug, descrição e status de ativo.

Pedidos:

Gerenciar pedidos feitos por um usuário. Cada pedido está associado a um usuário e pode conter múltiplos produtos.

Cálculo automático do preço total do pedido.

Tecnologias
O projeto utiliza as seguintes tecnologias e dependências:

Django (v5.2.1): Um framework web de alto nível para Python.

Django Rest Framework (v3.16.0): Um conjunto de ferramentas para construir APIs web.

pytest (v8.3.5): Um framework de teste para Python.

factory-boy (v3.3.3): Uma biblioteca de fábrica de fixtures para testes.

Como Executar o Projeto
Siga os passos abaixo para configurar e executar o projeto em seu ambiente local.

Pré-requisitos
Certifique-se de ter o Python (versão 3.10 ou superior) e o Poetry instalados.

1. Clonar o Repositório
Bash

git clone https://github.com/joaovbonifacio/bookstore.git
cd bookstore
2. Instalar as Dependências
Este projeto usa Poetry para gerenciar as dependências.

Bash

poetry install
3. Executar as Migrações do Banco de Dados
Bash

python manage.py migrate
4. Executar o Servidor
Bash

python manage.py runserver
O servidor da API estará disponível em http://127.0.0.1:8000/.

Testes
O projeto utiliza pytest para testes de unidade e integração.

Para executar os testes, use o seguinte comando:

Bash

pytest
