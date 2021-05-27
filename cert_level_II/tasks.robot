*** Settings ***
Documentation   Orders robots on demo website based off csv
...             Saves the receipt into a PDF
...             Saves a screenshot of the robot
...             Places screenshot into PDF
...             Creates an archive of receipts and images.
Library    RPA.Browser.Playwright
Library    RPA.HTTP
Library    RPA.Robocloud.Secrets
Library    RPA.Tables
Library    RPA.PDF
Library    RPA.Archive
Library    RPA.Dialogs



*** Tasks ***
Order Robots on RobotSpareBin Website With Receipts
    Open Website for Orders
    ${orders}=    Get Orders CSV From User
    FOR    ${order}    IN    @{orders}
        Sign Our Life Away
        Fill Out Form    ${order}
        Wait Until Keyword Succeeds    10x    0.1 sec    Preview And Submit Robot
        ${pdf}=    Store Receipt as PDF    ${order}
        ${screenshot}=    Screenshot Robot    ${order}
        Embed Screenshot in PDF Receipt    ${pdf}    ${screenshot}
        Order Another Robot
    END
    # log out of website
    Create a Zip File

*** Keywords ***
Open Website for Orders
    ${secret}=    Get Secret    website
    Open Browser    url=${secret}[url]    browser=Chromium

*** Keywords ***
Get Orders CSV From User
    #Add Icon
    #Add heading
    #Add Text Input    CSV URL    csv_url
    #Add Submit    Submit CSV    buttons=Yes,No    default=Yes
    RPA.HTTP.Download    https://robotsparebinindustries.com/orders.csv    overwrite=True
    ${orders_as_table}=    Read Table From Csv    orders.csv
    [Return]    ${orders_as_table}

*** Keywords ***
Sign Our Life Away
    Click    xpath=//*[@id="root"]/div/div[2]/div/div/div/div/div/button[3]    #clicks I guess so... on prompt

*** Keywords ***
Fill Out Form
    [Arguments]    ${order}
    Select Options By    xpath=//*[@id="head"]    value    ${order}[Head]  # chooses correct option for head 
    Click    css=#id-body-${order}[Body]    
    Fill Text    xpath=//*[@placeholder="Enter the part number for the legs"]    ${order}[Legs]
    Fill Text    xpath=//*[@id="address"]    ${order}[Address]

*** Keywords ***
Preview And Submit Robot
    Click    xpath=//*[@id="preview"]    # Preview robot for order
    Click    xpath=//*[@id="order"]    # click submit on order
    ${receipt_present}=    Wait For Elements State    xpath=//*[@id="receipt"]    Visible    .1s
    [Return]    ${receipt_present}
    # error message xpath is //*[@id="root"]/div/div[1]/div/div[1]/div

*** Keywords ***
Store Receipt as PDF
    [Arguments]    ${order}
    ${receipt_info}=    Get Property    xpath=//*[@id="receipt"]    outerHTML
    Log    ${receipt_info}
    Html To Pdf    ${receipt_info}    ${CURDIR}${/}output${/}receiptOrder${order}[Order number].pdf
    [Return]     ${CURDIR}${/}output${/}receiptOrder${order}[Order number].pdf

*** Keywords ***
Screenshot Robot
    [Arguments]    ${order}
    Wait For Elements State    xpath=//*[@id="robot-preview-image"]    visible
    Take Screenshot    ${CURDIR}${/}output${/}screenshot${order}[Order number].png    xpath=//*[@id="robot-preview-image"]    
    [Return]    ${CURDIR}${/}output${/}screenshot${order}[Order number].png    #filepath to screenshot

*** Keywords ***
Embed Screenshot in PDF Receipt
    [Arguments]    ${pdf}    ${screenshot}
    Open Pdf    ${pdf}
    Add Watermark Image To Pdf    ${screenshot}    ${pdf}
    Close Pdf

*** Keywords ***
Order Another Robot
    Click    xpath=//*[@id="order-another"]    # order another robot! 

*** Keywords ***
Create a Zip File
    Archive Folder With Zip    ${CURDIR}${/}output${/}    receipts.zip    include=*.pdf