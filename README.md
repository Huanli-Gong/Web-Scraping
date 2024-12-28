# Web Scraping For OSU CSE3901

>## To Run:
        Requires: "gem install mechanize"
        Requires: "bundle install"
        To Scrape: "ruby Main.rb"

>## How to Scrape:
        After entering the command "ruby Main.rb, the console will prompt the user to enter keyword(s) to look up.
        The program will use those keywords and search through the "https://news.osu.edu/" website. After entering the keyword(s),
        the console will print out a warning stating that gathering the articles might take a while. After which it prints out the total
        number of articles found relating to the selected keyword. The program stores the list of all the articles in sets of 10s in another
        folder called search result. The first html page is automatically opened and from there the user can then navigate through the
        pages by using the previous and next page buttons. The user can also click on the title of the article they wish to see, doing so 
        will take them to the article's website.

>## Note:
        Using multiple keywords in one search or using common words can result in many articles being found.
        As a result, the articles will take a while to be scraped. However the user is still able to search through the html pages 
        as soon as the first html page loads.