*** Settings ***
Documentation   Orders robots on demo website based off csv
...             Saves the receipt into a PDF
...             Saves a screenshot of the robot
...             Places screenshot into PDF
...             Creates an archive of receipts and images.
Library    RPA.Browser.Playwright
Library    RPA.HTTP
Library    RPA.Robocloud.Secrets


*** Tasks ***
Order Robots on RobotSpareBin Website With Receipts
    Open Website for Orders
    Get Orders CSV

*** Keywords ***
Open Website for Orders
    Open Browser    url=https://robotsparebinindustries.com/#/    browser=Chromium
    # look at open context to see if rpa.http is actually necessary!

*** Keywords ***
Get Orders CSV
    RPA.HTTP.Download    https://robotsparebinindustries.com/orders.csv    overwrite=True

