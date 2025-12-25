# Parking Test API

Este é um projeto de estudo de uma API de estacionamento construída com Ruby, Grape e MongoDB.

## 🚀 Como Rodar o Projeto

### Opção 1: Usando Docker (Recomendado)

A maneira mais fácil de rodar a aplicação é utilizando o Docker Compose, que já configura o banco de dados e a aplicação automaticamente.

1.  Certifique-se de ter o Docker e o Docker Compose instalados.
2.  Execute o comando:

```bash
docker-compose up --build
```

A API estará disponível em `http://localhost:3000`.

### Opção 2: Rodando Localmente

Se preferir rodar sem Docker, você precisará ter o **Ruby** e o **MongoDB** instalados em sua máquina.

1.  Instale as dependências:

    ```bash
    bundle install
    ```

2.  Certifique-se de que o MongoDB está rodando localmente.

3.  Inicie o servidor:
    ```bash
    bundle exec rackup -p 3000
    ```

A API estará disponível em `http://localhost:3000`.

## 🧪 Rodando os Testes

Para executar a suíte de testes automatizados:

```bash
bundle exec rspec
```

Se estiver usando Docker:

```bash
docker-compose run --rm app bundle exec rspec
```
