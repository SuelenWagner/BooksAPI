*** Settings ***
Documentation       Documentação da API: https://fakerestapi.azurewebsites.net/swagger/ui/index#!/Books
Library             RequestsLibrary
Library             Collections


*** Variable ***
${URL_API}          https://fakerestapi.azurewebsites.net/api/

&{BOOK_15}          ID=15                      #  quando criar dictionaries, não deixar espaços ex: ID= 15
...                 Title=Book 15
...                 PageCount=1500

&{BOOK_3333}        ID=3333
...                 Title=teste1
...                 Description=teste2
...                 PageCount=190
...                 Excerpt=teste3
...                 PublishDate=2019-11-13T12:35:23.788Z


&{BOOK_150}         ID=150
...                 Title=teste1
...                 Description=teste2
...                 PageCount=190
...                 Excerpt=teste3
...                 PublishDate=2019-06-16T14:02:07.7167833+00:00


*** Keywords ***
###SETUP E TEARDOWN###
Conectar a minha API
    Create Session      fakeAPI         ${URL_API}

### Ações
Requisitar todos os livros
    ${RESPONSE}         Get Request     fakeAPI     Books
    Log                 ${RESPONSE.text}
    Set Test Variable   ${RESPONSE}

Requisitar o livro "${BOOK_ID}"
    ${RESPONSE}         Get Request     fakeAPI     Books/${BOOK_ID}
    Log                 ${RESPONSE.text}
    Set Test Variable   ${RESPONSE}     

Cadastrar o novo livro "${BOOK_ID}"
    ${HEADERS}          Create Dictionary   content-type=application/json
    ${RESPONSE}         Post Request        fakeAPI     Books
    ...                 data={"ID": 3333,"Title": "teste1","Description": "teste2","PageCount": 190,"Excerpt": "teste3","PublishDate": "2019-11-13T12:35:23.788Z"}   #data é = a body
    ...                 headers=${HEADERS}
    Log                 ${RESPONSE.text}
    Set Test Variable   ${RESPONSE}

Alterar os dados do livro "${BOOK_ID}"
    ${HEADERS}          Create Dictionary   content-type=application/json
    ${RESPONSE}         Put Request        fakeAPI     Books/${BOOK_ID}
    ...                 data={"ID": 150,"Title": "teste1","Description": "teste2","PageCount": 190,"Excerpt": "teste3","PublishDate": "2019-06-16T14:02:07.7167833+00:00"}   #data é = a body
    ...                 headers=${HEADERS}
    Log                 ${RESPONSE.text}
    Set Test Variable   ${RESPONSE}

Deletar o livro "${BOOK_ID}"
    ${RESPONSE}         Delete Request        fakeAPI     Books/${BOOK_ID}
    Log                 ${RESPONSE}
    Log                 CONTENT: ${RESPONSE.content}
    Set Test Variable   ${RESPONSE}

###Conferências
Conferir o status code "${STATUSCODE}"
    Should Be Equal As Strings      ${RESPONSE.status_code}       ${STATUSCODE}     

Conferir o reason "${REASON}"
#    [Arguments]         ${REASON}     são utilizados quando a varável no teste é inserida com espaçamento
    Should Be Equal As Strings      ${RESPONSE.reason}       ${REASON}     

Conferir se retorna uma lista com "${QTY_BOOKS}" livros
    Length Should Be    ${RESPONSE.json()}      ${QTY_BOOKS}   #verifica a quantidade de livros

Conferir se retorna todos os dados corretos do livro "${BOOK_ID}"
    Dictionary Should Contain Item      ${RESPONSE.json()}      ID            ${BOOK_15.ID}
    Dictionary Should Contain Item      ${RESPONSE.json()}      Title         ${BOOK_15.Title}
    Dictionary Should Contain Item      ${RESPONSE.json()}      PageCount     ${BOOK_15.PageCount}
    Should Not Be Empty                 ${RESPONSE.json()["Description"]}     #solução para atributos random
    Should Not Be Empty                 ${RESPONSE.json()["Excerpt"]}
    Should Not Be Empty                 ${RESPONSE.json()["PublishDate"]}


Conferir se retorna todos os dados corretos do novo livro "${BOOK_ID}"
    Conferir livro          ${BOOK_ID}

Conferir se retorna todos os dados alterados do livro "${BOOK_ID}"
    Conferir livro          ${BOOK_ID}   

Conferir livro
    [Arguments]     ${BOOK_ID}
    Dictionary Should Contain Item    ${RESPONSE.json()}    ID              ${BOOK_${BOOK_ID}.ID}
    Dictionary Should Contain Item    ${RESPONSE.json()}    Title           ${BOOK_${BOOK_ID}.Title}
    Dictionary Should Contain Item    ${RESPONSE.json()}    Description     ${BOOK_${BOOK_ID}.Description}
    Dictionary Should Contain Item    ${RESPONSE.json()}    PageCount       ${BOOK_${BOOK_ID}.PageCount}
    Dictionary Should Contain Item    ${RESPONSE.json()}    Excerpt         ${BOOK_${BOOK_ID}.Excerpt}
    Dictionary Should Contain Item    ${RESPONSE.json()}    PublishDate     ${BOOK_${BOOK_ID}.PublishDate}

Conferir se o livro "${BOOK_ID}" foi deletado
    Should Be Empty     ${RESPONSE.content}
