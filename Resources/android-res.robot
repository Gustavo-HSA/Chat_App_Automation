*** Settings ***
Library             AppiumLibrary   run_on_failure=No Operation
Library             OperatingSystem
Resource            password.robot

*** Variables ***
#*** Test Variables ***
&{USER1-DETAILS}       email=g.henrique.test@gmail.com      password=${PASSWORD}   name=Gustavo Test2      message=Bom dia Gustavo Teste2!
&{USER2-DETAILS}       email=g.henrique.test2@gmail.com     password=${PASSWORD}   name=Gustavo Alcantara  message=Bom dia Gustavo Alcantara!
${APPIUM-PORT-DEVICE1}      4723
${APPIUM-PORT-DEVICE2}      4725

#*** Application Variables ***
${CHAT21-APPLICATION-ID}            chat21.android.demo
${CHAT21-APPLICATION-ACTIVITY}      chat21.android.demo.SplashActivity

#*** Login Page ***
${LOGIN-EMAIL-FIELD}            id=chat21.android.demo:id/email
${LOGIN-PASSWORD-FIELD}         id=chat21.android.demo:id/password
${LOGIN-SIGNIN-BUTTON}          id=chat21.android.demo:id/login

#*** Main Page ***
${MAIN-HOME-TAB}        //android.widget.TextView[@text="HOME"]
${MAIN-CHAT-TAB}        //android.widget.TextView[@text="CHAT"]
${MAIN-PROFILE-TAB}     //android.widget.TextView[@text="PROFILE"]

#*** Profile Page ***
${PROFILE-LOGOUT-BUTTON}                id=chat21.android.demo:id/logout

#*** Chat Page ***
${CHAT-NEWCONVERSATION-BUTTON}          id=${CHAT21-APPLICATION-ID}:id/button_new_conversation
${NEWCONVERSATION-CONTACTS-HEADER}      //android.view.ViewGroup[contains(@resource-id,'toolbar')]//android.widget.TextView[@text="CONTACTS"]
${NEWCONVERSATION-CONTACTS-HEADER-SEARCH-BUTTON}      id=${CHAT21-APPLICATION-ID}:id/action_search
${NEWCONVERSATION-CONTACTS-HEADER-SEARCH-FIELD}       id=${CHAT21-APPLICATION-ID}:id/search_src_text

#*** Conversation Window ***
${CONVERSATION-WINDOW-INPUT-FIELD}          id=${CHAT21-APPLICATION-ID}:id/main_activity_chat_bottom_message_edittext
${CONVERSATION-WINDOW-SEND-BUTTON}          id=${CHAT21-APPLICATION-ID}:id/main_activity_send

#*** Android 10 Variables ***
${PERMISSION-CONTINUE-BUTTON}           id=com.android.permissioncontroller:id/continue_button
${ANDROID10-OK-BUTTON}                  //android.widget.Button[@text="OK"]

*** Keywords ***

Open Chat21 Application
    [Arguments]         ${APPIUM-PORT}=${APPIUM-PORT-DEVICE1}
    Open Application    http://localhost:${APPIUM-PORT}/wd/hub    platformName=Android    appPackage=${CHAT21-APPLICATION-ID}    appActivity=${CHAT21-APPLICATION-ACTIVITY}    automationName=Uiautomator2
    ${ALERT}        Run Keyword And Return Status       Page Should Not Contain Element    ${PERMISSION-CONTINUE-BUTTON}
    Run Keyword If    "${ALERT}" == "False"      Bypass Android10 Allerts

Open Chat21 Application On First Device
    Open Chat21 Application                      ${APPIUM-PORT-DEVICE1}

Open Chat21 Application On Second Device
    Open Chat21 Application                     ${APPIUM-PORT-DEVICE2}

Bypass Android10 Allerts
    Wait Until Page Contains Element            ${PERMISSION-CONTINUE-BUTTON}
    Click Element                               ${PERMISSION-CONTINUE-BUTTON}
    Wait Until Page Contains Element            ${ANDROID10-OK-BUTTON}
    Click Element                               ${ANDROID10-OK-BUTTON}

 Signin With User
    [Arguments]     ${EMAIL}    ${USERPASSWORD}
     Input User Email           ${EMAIL}
     Input User Password        ${USERPASSWORD}
     Submit Login
     Verify Login Is Sucessful

 Input User Email
    [Arguments]         ${EMAIL}
    Verify Login Email Field Is Displayed
    Input Text          ${LOGIN-EMAIL-FIELD}        ${EMAIL}

 Input User Password
    [Arguments]         ${USERPASSWORD}
    Input Password      ${LOGIN-PASSWORD-FIELD}     ${USERPASSWORD}

Submit Login
    Click Element       ${LOGIN-SIGNIN-BUTTON}
    
Verify Login Is Sucessful
    Wait Until Page Contains Element        ${MAIN-HOME-TAB}

Logout With User
    Go To Logout Page
    Click Logout Button
    Verify Login Email Field Is Displayed

Verify Login Email Field Is Displayed
    Wait Until Page Contains Element                ${LOGIN-EMAIL-FIELD}

Go To Logout Page
    Click Element       ${MAIN-PROFILE-TAB}
    Wait Until Page Contains Element                ${PROFILE-LOGOUT-BUTTON}

Click Logout Button
    Click Element       ${PROFILE-LOGOUT-BUTTON}

Go To Chat Page
    Click Element       ${MAIN-CHAT-TAB}
    Wait Until Page Contains Element                ${CHAT-NEWCONVERSATION-BUTTON}

#*** Chat Page ***
Start New Chat
    [Arguments]                         ${NAME}
    Click Element                       ${CHAT-NEWCONVERSATION-BUTTON}
    Wait Until Page Contains Element    ${NEWCONVERSATION-CONTACTS-HEADER-SEARCH-BUTTON}
    Search For Contact                  ${NAME}
    Click Element                       //android.widget.TextView[contains(@resource-id, 'fullname') and @text="${NAME}"]
    Wait Until Conversation Window Is Open    ${NAME}

Search For Contact
    [Arguments]         ${NAME}
    Click Element       ${NEWCONVERSATION-CONTACTS-HEADER-SEARCH-BUTTON}
    Wait Until Page Contains Element                ${NEWCONVERSATION-CONTACTS-HEADER-SEARCH-FIELD}
    Input Text          ${NEWCONVERSATION-CONTACTS-HEADER-SEARCH-FIELD}   ${NAME}
    Wait Until Page Contains Element    //android.widget.TextView[contains(@resource-id,'fullname') and @text="${NAME}"]

Wait Until Page Contains Conversation
    [Arguments]         ${NAME}
    Wait Until Page Contains Element    //android.widget.TextView[contains(@resource-id,'recipient_display_name') and @text="${NAME}"]

Open Conversation
    [Arguments]         ${NAME}
    Wait Until Page Contains Conversation       ${NAME}
    Click Element                               //android.widget.TextView[contains(@resource-id,'recipient_display_name') and @text="${NAME}"]
    Wait Until Conversation Window Is Open      ${NAME}

Wait Until Conversation Window Is Open
    [Arguments]         ${NAME}
    Wait Until Page Contains Element    //android.widget.TextView[contains(@resource-id,'toolbar_title') and @text="${NAME}"]

Send Message Inside Conversation Window
    [Arguments]         ${MESSAGE}
    Wait Until Page Contains Element    ${CONVERSATION-WINDOW-INPUT-FIELD}
    Input Text          ${CONVERSATION-WINDOW-INPUT-FIELD}    ${MESSAGE}
    Click Element       ${CONVERSATION-WINDOW-SEND-BUTTON}
    Wait Until Conversation Contains Message    ${MESSAGE}

Wait Until Conversation Contains Message
    [Arguments]         ${MESSAGE}
    Wait Until Page Contains Element    //android.widget.TextView[contains(@resource-id,'message') and @text="${MESSAGE}"]