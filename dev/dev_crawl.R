source(paste0(SCRIPT_HOME, 'packages.R'))

url <- str_interp('https://www.withsellit.com/search?query=%EB%A7%A5%EB%B6%81&buyable=buyable&categories=laptop_pc&used_states=used')

tmp <- read_html(url) %>% html_nodes('.gdidx-price') %>% html_text()
tmp
print(read_html(url))
go_to_page <- read_html(url) %>% html_nodes(".num") %>% html_text() %>% as.numeric
'https://www.withsellit.com/search?query=%EB%A7%A5%EB%B6%81&categories=laptop_pc&used_states=used'

# 최초에 N개가 노출되고 스크롤을 내리면 추가 Item들이 추가 노출된다.
# 구매 가능한 상품만 체크해야한다.
#  

# selenium ----------------------------------------------------------------

fn_start_driver <- function(port = 4445L, browser = "chrome", chromever = "81.0.4044.69"){
  
  # eCaps <- list(chromeOptions = list(
  #   args = c('--headless', '--disable-gpu', '--window-size=1280,800')
  # ))
  
  remDr <- rsDriver(port = port, browser = browser, chromever = chromever)#, extraCapabilities = eCaps)$client
  
  return(remDr)
}



# code test ---------------------------------------------------------------

binman::list_versions("chromedriver")

remDr <- fn_start_driver(4442L)
remDr$server$stop()

# navigate to sellit & scroll down ----------------------------------------

remDr$client$navigate(url)
remDr$client$executeScript('window.scrollTo(0, document.body.scrollHeight);') # scroll down to bottom
remDr$client$executeScript('window.scrollTo(0, 0);') # return to top

page_src <- remDr$client$getPageSource()
read_html(page_src[[1]]) %>% html_nodes('.gdidx-price') %>% length
