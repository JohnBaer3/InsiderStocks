# Insider Stocks

### Week 3, 4 of "An App A Week" Challenge - Displaying Insider trading info!

Accesses, parses through, and displays the SEC's form-4s to show the latest stock trades done by company insiders in an easily-accessible format. Additionally displays the stock's current trading prices.

### Goals:

To work with APIs that aren't developer-friendly, and to make insider-trading info more accessible to the average stock-trader


### Technical write-up 

<img src="https://github.com/JohnBaer3/InsiderStocks/blob/main/IMG_6959.PNG" width="200" height="400">

1. The initial screen displays the 20 most recent insider trades reported to the SEC with their trading volume, price, total stock ownership change, and total $$ of stocks bought or sold. To get this data, I used the sec-api.io API. From this API I can get the most recent Form-4 filings, which gives a http link to a xml of the forms that have the actual monetary data, which we parse, a 2-step process (App -> sec-api -> find xml link -> access xml -> parse xml). I then parse the xml data using SwiftyXMLParser, and populate the table. Although a lot of the data was nested deeply, the parsing was mainly trivial. 

<img src="https://github.com/JohnBaer3/InsiderStocks/blob/main/IMG_6960.PNG" width="200" height="400">

2. By modifying the payload of the GET requests to the sec-api, I can fetch different data from the API, such as different time-ranges an user is interested in (weekly, monthly, yearly), as well as filtering to show trades only for a specific company. 

<img src="https://github.com/JohnBaer3/InsiderStocks/blob/main/IMG_6961.PNG" width="200" height="400">

3. When clicking into a specific table cell, I display the data from the previous screen in bigger detail, as well as displaying how that company's stock is performing currently. For the stock graph I used AlphaVantageAPI. I send a GET request filtered for the stock ticker that the user clicked on the previous screen, and display the result in a price:time line graph. 


### Challenges

An unexpected failure was that inside of the xml's transactionPricePerShare-value tags, sometimes the value wasn't inputted, but instead a footnote that linked to another section of the document that further led to a paragraph of text explaining the price of the share, instead of a simple numerical value. This led to not being able to display the price of the trade or the share. A trivial solution would have been to parse through the paragraph, and if there is a singular word that has a dollar-sign followed by numbers we can reaonably assume that that would be the price we are looking for. Other implementations could have involved a look-up of the price the stock at the time the trade was processed, or even intent classification of the paragraph using ML, but would have been too time-consuming given the time-constraints, but could have been interesting to explore. 


## App in action:
https://vimeo.com/508664061
