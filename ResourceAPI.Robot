*** Settings ***
Documentation       Documentação da API: https://fakerestapi.azurewebsites.net/swagger/ui/index#!/Books
Library             RequestsLibrary
Library             Collections


*** Variable ***
${URL_API}          https://fakerestapi.azurewebsites.net/api/    ##URl da api a ser testada
&{BOOK_15}          ID=15                           #  quando criar dictionaries, não deixar espaços ex: ID= 15
...                 Title=Book 15
...                 PageCount=1500

&{BOOK_3333}        ID=3333
...                 Title=teste1
...                 Description=teste2
...                 PageCount=190
...                 Excerpt=teste3
...                 PublishDate=2019-11-13T12:35:23.788Z


&{BOOK_150}         ID=150
...                 Title=Book 150
...                 Description=Lorem lorem lorem. Lorem lorem lorem. Lorem lorem lorem.\r\n
...                 PageCount=15000
...                 Excerpt=Lorem lorem lorem. Lorem lorem lorem. Lorem lorem lorem.\r\nLorem lorem lorem. Lorem lorem lorem. Lorem lorem lorem.\r\nLorem lorem lorem. Lorem lorem lorem. Lorem lorem lorem.\r\nLorem lorem lorem. Lorem lorem lorem. Lorem lorem lorem.\r\nLorem lorem lorem. Lorem lorem lorem. Lorem lorem lorem.\r\n
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

Cadastrar um novo livro
    ${HEADERS}          Create Dictionary   content-type=application/json
    ${RESPONSE}         Post Request        fakeAPI     Books
    ...                 data={"ID": 3333,"Title": "teste1","Description": "teste2","PageCount": 190,"Excerpt": "teste3","PublishDate": "2019-11-13T12:35:23.788Z"}   #data é = a body
    ...                 headers=${HEADERS}
    Log                 ${RESPONSE.text}
    Set Test Variable   ${RESPONSE}

Alterar os dados do livro "${BOOK_150}"
    ${HEADERS}          Create Dictionary   content-type=application/json
    ${RESPONSE}         Put Request        fakeAPI     Books
    ...                 data={"ID": 150,"Title": "teste1","Description": "teste2","PageCount": 190,"Excerpt": "teste3","PublishDate": "2019-06-16T14:02:07.7167833+00:00"}   #data é = a body
    ...                 headers=${HEADERS}
    Log                 ${RESPONSE.text}
    Set Test Variable   ${RESPONSE}

###Conferências
Conferir o status code
    [Arguments]         ${STATUSCODE}
    Should Be Equal As Strings      ${RESPONSE.status_code}       ${STATUSCODE}     

Conferir o reason
    [Arguments]         ${REASON}
    Should Be Equal As Strings      ${RESPONSE.reason}       ${REASON}     

Conferir se retorna uma lista com "${QTY_BOOKS}" livros
    Length Should Be    ${RESPONSE.json()}      ${QTY_BOOKS}

Conferir se retorna todos os dados corretos do livro 15
    Dictionary Should Contain Item      ${RESPONSE.json()}      ID            ${BOOK_15.ID}
    Dictionary Should Contain Item      ${RESPONSE.json()}      Title         ${BOOK_15.Title}
    Dictionary Should Contain Item      ${RESPONSE.json()}      PageCount     ${BOOK_15.PageCount}
    Should Not Be Empty                 ${RESPONSE.json()["Description"]}     #solução para atributos random
    Should Not Be Empty                 ${RESPONSE.json()["Excerpt"]}
    Should Not Be Empty                 ${RESPONSE.json()["PublishDate"]}


Conferir se retorna todos os dados corretos do novo livro
    Dictionary Should Contain Item      ${RESPONSE.json()}      ID            ${BOOK_3333.ID}
    Dictionary Should Contain Item      ${RESPONSE.json()}      Title         ${BOOK_3333.Title}
    Dictionary Should Contain Item      ${RESPONSE.json()}      Description   ${BOOK_3333.Description}
    Dictionary Should Contain Item      ${RESPONSE.json()}      PageCount     ${BOOK_3333.PageCount}
    Dictionary Should Contain Item      ${RESPONSE.json()}      Excerpt       ${BOOK_3333.Excerpt}
    Dictionary Should Contain Item      ${RESPONSE.json()}      PublishDate   ${BOOK_3333.PublishDate}
