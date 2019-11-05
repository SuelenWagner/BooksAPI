*** Settings ***
Documentation       Documentação da API: https://fakerestapi.azurewebsites.net/swagger/ui/index#!/Books
Library             RequestsLibrary
Library             Collections


*** Variable ***
${URL_API}          https://fakerestapi.azurewebsites.net/api/


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

###Conferências
Conferir o status code
    [Arguments]         ${STATUSCODE}
    Should Be Equal As Strings      ${RESPONSE.status_code}       ${STATUSCODE}     

Conferir o reason
    [Arguments]         ${REASON}
    Should Be Equal As Strings      ${RESPONSE.reason}       ${REASON}     

Conferir se retorna uma lista com "${QTY_BOOKS}" livros
    Length Should Be    ${RESPONSE.json()}      ${QTY_BOOKS}