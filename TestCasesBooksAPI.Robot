*** Settings ***
Documentation       Documentação da API: https://fakerestapi.azurewebsites.net/swagger/ui/index#!/Books
Resource            ResourceAPI.Robot
Suite Setup         Conectar a minha API


*** Test Case ***
Buscar a listagem de todos os livros (GET em todos os livros)
    Requisitar todos os livros
    Conferir o status code  200  
    Conferir o reason   OK                  ##pode-se dar o espaçamento para inserir uma variável na keyword ou
    Conferir se retorna uma lista com "200" livros   ## pode-se inserir a variável entre aspas duplas

Buscar um livro especifico (GET em um livro especifico)
    Requisitar o livro "15"
    Conferir o status code  200
    Conferir o reason   OK
    Conferir se retorna todos os dados corretos do livro 15

Cadastrar um novo livro (POST)
    Cadastrar um novo livro
    Conferir o status code  200
    Conferir o reason   OK
    Conferir se retorna todos os dados corretos do novo livro

Alterar um livro existente (PUT)
    Alterar os dados do livro "150"
#    Conferir o status code  200
#    Conferir o reason   OK
#   Conferir se retorna todos os dados alterados do livro

#Conferir se deleta o livro 200 (Delete)
