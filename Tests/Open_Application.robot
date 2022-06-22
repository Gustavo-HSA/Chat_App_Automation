*** Settings ***
Library             AppiumLibrary   run_on_failure=No Operation
Library             OperatingSystem

*** Variables ***
${LOGIN-SUBMIT-BUTTON1}     id=chat21.android.demo:id/login
${LOGIN-SUBMIT-BUTTON2}     //android.widget.Button[@text="Login"]
${LOGIN-SUBMIT-BUTTON3}     //android.widget.Button[contains(@text,"Login")]
${LOGIN-SUBMIT-BUTTON4}     //android.widget.Button[contains(@resource-id,"login")]
${LOGIN-SUBMIT-BUTTON5}     //android.widget.Button[@resource-id="chat21.android.demo:id/login"]
${LOGIN-SUBMIT-BUTTON6}     //android.widget.Button[@resource-id="chat21.android.demo:id/login" and @text="Login"]
${LOGIN-SUBMIT-BUTTON7}     //android.widget.LinearLayout//android.widget.Button[@text="Login"]

*** Test Cases ***
Open_Application
    Open Application    http://localhost:4723/wd/hub    platformName=Android    deviceName=192.168.56.101:5555    appPackage=chat21.android.demo    appActivity=chat21.android.demo.SplashActivity    automationName=Uiautomator2    newCommandTimeout=300
    Wait Until Page Contains Element    ${LOGIN-SUBMIT-BUTTON1}
    Wait Until Page Contains Element    ${LOGIN-SUBMIT-BUTTON2}
    Wait Until Page Contains Element    ${LOGIN-SUBMIT-BUTTON3}
    Wait Until Page Contains Element    ${LOGIN-SUBMIT-BUTTON4}
    Wait Until Page Contains Element    ${LOGIN-SUBMIT-BUTTON5}
    Wait Until Page Contains Element    ${LOGIN-SUBMIT-BUTTON6}
    Wait Until Page Contains Element    ${LOGIN-SUBMIT-BUTTON7}