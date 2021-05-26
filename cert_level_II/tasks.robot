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
Library    String


*** Tasks ***
Order Robots on RobotSpareBin Website With Receipts
    #Open Website for Orders
    #Login to Website
    ${orders}=    Get Orders CSV
    FOR    ${order}    IN    @{orders}
        # do stuff
        
    END
    # log out of website
    # create a zip

*** Keywords ***
Open Website for Orders
    Open Browser    url=https://robotsparebinindustries.com/#/    browser=Chromium
    # look at open context to see if rpa.http is actually necessary!

*** Keywords ***
Login to Website
    ${secret}=    Get Secret    credentials
    Fill Text    id=username    ${secret}[username]
    Fill Secret    id=password    ${secret}[password]
    Click    xpath=//*[@id="root"]/div/div/div/div[1]/form/button

*** Keywords ***
Get Orders CSV
    RPA.HTTP.Download    https://robotsparebinindustries.com/orders.csv    overwrite=True
    ${orders_as_table}=    Read Table From Csv    orders.csv
    [Return]    ${orders_as_table}