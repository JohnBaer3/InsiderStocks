# Insider Stocks

### Week 3, 4 of "An App A Week" Challenge - Displaying Insider trading info!

Accesses, parses through, and displays the SEC's form-4s to show the latest stock trades done by company insiders in an easily-accessible format. Additionally displays the stock's current trading prices.

### Goals:

To work with APIs that aren't developer-friendly, and to make insider-trading info more accessible to the average stock-trader


### Technical write-up 

<img src="https://github.com/JohnBaer3/InsiderStocks/blob/main/IMG_6959.PNG" width="200" height="400">

1. The initial screen displays the 20 most recent insider trades reported to the SEC with their trading volume, price, total stock ownership change, and total $$ of stocks bought or sold. To get this data, I used the sec-api.io API. From this API I can get the most recent Form-4 filings, which gives a http link to a xml of the forms that have the actual monetary data, which we parse, a 2-step process (App -> sec-api -> find xml link -> access xml -> parse xml). We then parse the data, and populate the table.

<img src="https://github.com/JohnBaer3/InsiderStocks/blob/main/IMG_6960.PNG" width="200" height="400">

2. 


<img src="https://github.com/JohnBaer3/InsiderStocks/blob/main/IMG_6961.PNG" width="200" height="400">

2. The initial screen displays the 20 most recent insider trades reported to the SEC with their trading volume, price, total stock ownership change, and total $$ of stocks bought or sold. To get this data, I used the sec-api.io API. From this API I can get the most recent Form-4 filings, which gives a http link to a xml of the forms that have the actual monetary data, which we parse, a 2-step process (App -> sec-api -> find xml link -> access xml -> parse xml). We then parse the data, and populate the table.



### Challenges

Finding the data and parsing government data

A lot of stock prices being in footnotes


## App in action:
https://vimeo.com/508664061
