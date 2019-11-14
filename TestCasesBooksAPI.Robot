*** Settings ***
Documentation       Documentação da API: https://fakerestapi.azurewebsites.net/swagger/ui/index#!/Books
Resource            ResourceAPI.Robot
Suite Setup         Conectar a minha API


*** Test Case ***
Buscar a listagem de todos os livros (GET em todos os livros)
    Requisitar todos os livros
    Conferir o status code "200"  
    Conferir o reason "OK"           ##pode-se dar o espaçamento para inserir uma variável na keyword ou entre aspas
    Conferir se retorna uma lista com "200" livros

Buscar um livro especifico (GET em um livro especifico)
    Requisitar o livro "15"
    Conferir o status code "200"
    Conferir o reason "OK"
    Conferir se retorna todos os dados corretos do livro "15"

Cadastrar um novo livro (POST)
    Cadastrar o novo livro "3333"
    Conferir o status code "200"
    Conferir o reason "OK"
    Conferir se retorna todos os dados corretos do novo livro "3333"

Alterar um livro existente (PUT)
    Alterar os dados do livro "150"
    Conferir o status code "200"
    Conferir o reason "OK"
    Conferir se retorna todos os dados alterados do livro "150"

Deletar um livro existente (DELETE)
    Deletar o livro "100"
    Conferir o status code "200"
    Conferir o reason "OK"
    Conferir se o livro "100" foi deletado