*** Settings ***
Library             AppiumLibrary   run_on_failure=No Operation
Library             OperatingSystem
Resource            ../Resources/android-res.robot

*** Test Cases ***
Login
    Open Chat21 Application On First Device
    Signin With User        ${USER1-DETAILS}[email]     ${USER1-DETAILS}[password]
    Open Chat21 Application On Second Device
    Signin With User        ${USER2-DETAILS}[email]     ${USER2-DETAILS}[password]
    Switch Application      1
    Go To Chat Page
    Start New Chat          ${USER2-DETAILS}[name]
    Send Message Inside Conversation Window     ${USER1-DETAILS}[message]
    Switch Application      2
    Wait Until Page Contains Conversation       ${USER1-DETAILS}[name]
    Open Conversation                           ${USER1-DETAILS}[name]
    Wait Until Conversation Contains Message    ${USER1-DETAILS}[message]
    Send Message Inside Conversation Window     ${USER2-DETAILS}[message]
    Switch Application      1
    Wait Until Conversation Contains Message    ${USER2-DETAILS}[message]