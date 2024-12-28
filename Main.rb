require 'mechanize'
require 'nokogiri'

class Main

    def getUserInput

        # ask user for input and make sure it is at least 3 charachters long
        puts "Enter some keyword(s) to search the OSU News site:" 
        puts " "
        category = gets.chomp
        
        # aks user for appropriate input if previous input was less than 3 characters
        while category.length < 3
            puts "Input must be at least 3 characters"
            puts "Enter some other word or phrase"
            category = gets.chomp
        end

        #return user's input
        return category
    end


    def scrapePage

        #run mechanize and grab the webpage
        mechanize = Mechanize.new
        category = getUserInput

        #format url to match OSU news search site
        url = "https://news.osu.edu/" + '?s=0&q=' + category
        page = mechanize.get(url)

        #use Nokogiri to fparse page
        html_page = Nokogiri::HTML(page.body)
        
        #Node for all articles in each page 
        articles = html_page.css('td>div.floatLeft')

        if articles.count > 0

            #array to add each article to
            articlesArray = []

            #number of articles per page excluding article descriptions
            articlesPerPage = articles.count / 2

            #number of articles related to a topic
            #shows up at top of OSU news search site for each keyword
            totalArticles = html_page.css('div.search_resultstitle>b').text.split[0].to_i

            #starting page number
            pageNum = 0

            #final page number
            finalPage = (totalArticles.to_f/articlesPerPage.to_f).round   

            # Dir.mkdir("search result")
            FileUtils.makedirs('search result/') unless File.exists?'search result/'
            FileUtils.rm_rf(Dir.glob('search result/*'))

            puts "Gathering article information... this may take a while depending on the number of articles."
            #loop runs for each page with about 10 articles each

            
            if totalArticles.to_i% 10 !=0 && totalArticles >10
                finalPage +=1
            end 

            while pageNum < finalPage
                f = File.new("search result/page#{pageNum}.html", "w+")
                f.puts "<!DOCTYPE html>"
                f.puts "<html lang=\"en\">"
                f.puts "<head>"
                f.puts "<title>"+"Search Results"+"</title>"
                f.puts "<meta charset=\"utf-8\">"
                f.puts "</head>"
                f.puts "<body>"
                f.puts "<h1>" + "Search Results" + "</h1>"
                f.puts"#{totalArticles} results found with keyword: #{category}"
                f.puts "<hr />"
                #vriable used to grab even indexes of articles variable to exclude article descriptions
                count = 0
                url = "https://news.osu.edu/?s=" + (pageNum*10).to_s + "&q=" + category
                f.puts "<br><a href=\""
                f.puts url
                f.puts "\">#{url}</a><br>"
                f.puts "<br>"

                #run this code again for each page
                page = mechanize.get(url)
                html_page = Nokogiri::HTML(page.body)
                articles= html_page.css('td>div.floatLeft')
                

                #loop collects article titles and links
                articles.each do |ele|
                    if count %2 ==0
                        articleTitle = ele.css('a').text
                        articleLink =  "https:" + ele.css('a')[0].attributes['href'].value
                        article = [articleTitle, articleLink] 
                        articlesArray<< article  
                        f.puts "#{articlesArray.size}: "  
                        f.puts " <a href=\"#{articleLink}\">#{articleTitle}</a>"
                        f.puts "<br>"
                    end
                    count +=1
                end
                f.puts "<br>"    

                if pageNum >0
                    f.puts " <a href=page#{pageNum-1}.html>previous page</a>"
                end
                pageNum +=1
                f.puts "Page #{pageNum} / #{finalPage}"
                if pageNum < finalPage
                    f.puts " <a href=page#{pageNum}.html>next page</a>"
                end
                f.puts "<br>"
                f.puts "</body>"
                f.puts "</html>"
                f.close()
                if pageNum==1
                    system("xdg-open", "search result/page0.html")
                end
            end
            puts "Finished processing #{articlesArray.size} articles associated with this topic."
        else 
            puts "No results for #{category}"
            puts "Try again"
            puts " "
            scrapePage
        end
    end
end

startScraping = Main.new
startScraping.scrapePage
