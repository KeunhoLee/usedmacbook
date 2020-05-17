print(' tools_sellit : ')
# selenium ----------------------------------------------------------------

fn_start_driver <- function(port = 4445L, browser = "chrome", chromever = "81.0.4044.69"){
  
  eCaps <- list(chromeOptions = list(
    args = c('--headless', '--disable-gpu', '--window-size=1280,800')
  ))
  
  remDr <- rsDriver(port = port, browser = browser, chromever = chromever, extraCapabilities = eCaps)
  
  return(remDr)
}

init_page_to_crawl <- function(remDr, url){
  
  remDr$client$navigate(url)
  Sys.sleep(1) # wait 1 sec to load page
  remDr$client$executeScript('window.scrollTo(0, document.body.scrollHeight);') # scroll down to bottom
  Sys.sleep(1) # wait 1 sec to load page
  remDr$client$executeScript('window.scrollTo(0, document.body.scrollHeight);') # scroll down to bottom
  Sys.sleep(1) # wait 1 sec to load page 
  remDr$client$executeScript('window.scrollTo(0, 0);') # return to top
  
}

get_detail_url <- function(remDr){
  
  page_src <- remDr$client$getPageSource() # get page source
  items <- read_html(page_src[[1]]) %>% html_nodes(xpath = '//*[@ng-repeat="item in orders"]') # get items from page source
  url_to_detail <- items %>% html_nodes(xpath = '//*[@class="gdidx-good-info"]') %>% html_attrs()
  url_to_detail <- sapply(url_to_detail, function(x) x['href'])
  
  return(url_to_detail)
  
}

# In page
get_page_src <- function(remDr, url){
  
  remDr$client$navigate( url )
  page_src <- remDr$client$getPageSource() 
  
  return(page_src)
  
}

get_product_id <- function(page_src){
  
  result <- read_html(page_src[[1]]) %>% 
    html_nodes(xpath = '//*[@class="gdshw-product-id ng-binding"]') %>%
    html_text() %>% gsub('[^0-9]', '', .)
  
  return(result)
  
}

get_product_name <- function(page_src){

  result <- read_html(page_src[[1]]) %>% 
  html_nodes(xpath = '//*[@class="gdshw-product-name ng-binding"]') %>%
  html_text()
  
  return(result)
  
}

get_product_price <- function(page_src){
  
  result <- read_html(page_src[[1]]) %>% 
    html_nodes(xpath = '//*[@class="gdshw-price ng-scope ng-binding"]') %>% 
    html_text() %>% gsub('원', '', .) %>% gsub(',', '', .)
  
  return(result)

}

get_product_detail_icon <- function(page_src){
  
  result <- read_html(page_src[[1]]) %>%
    html_nodes(xpath = '//*[@class="gdshw-summary-label ng-binding"]') %>%
    html_text() 
  
  return(result)
}

get_product_detail_text <- function(page_src){
  
  # Detail text content
  result <- read_html(page_src[[1]]) %>% 
    html_nodes(xpath = '//*[@class="gdshw-detail-content ng-binding"]') %>%
    html_text()
  
  # Detail text label
  names(result) <- read_html(page_src[[1]]) %>%
    html_nodes(xpath = '//*[@class="gdshw-detail-label ng-binding"]') %>%
    html_text()

  return(result)
  
}

# merge

# code test ---------------------------------------------------------------
#remDr$server$stop()

# source(paste0(SCRIPT_HOME, 'packages.R'))
# main_url <- 'https://www.withsellit.com'
# url <- str_interp('${main_url}/search?query=%EB%A7%A5%EB%B6%81&buyable=buyable&categories=laptop_pc&used_states=used')
# 
# #binman::list_versions("chromedriver")
# 
# remDr <- fn_start_driver(4442L)
# 
# init_page_to_crawl(remDr, url)
# 
# parsed_url <- get_detail_url(remDr)
# 
# product_id          <- NULL 
# product_name        <- NULL
# product_price       <- NULL
# product_detail_icon <- list()
# product_detail_text <- list()
# 
# for( i in 1:length(parsed_url) ){
# 
#   sub_url <- parsed_url[i]
# 
#   url <- str_interp('${main_url}${sub_url}')
# 
#   page_src <- get_page_src(remDr, url)
# 
#   product_id    <- c(product_id, get_product_id(page_src))
# 
#   product_name  <- c(product_name, get_product_name(page_src))
# 
#   product_price <- c(product_price, get_product_price(page_src))
# 
#   product_detail_icon[[i]] <- get_product_detail_icon(page_src)
# 
#   product_detail_text[[i]] <- get_product_detail_text(page_src)
# 
#   Sys.sleep( rexp(1, 1/3) )
# 
# }
# 
# result <- list(product_id,
#                product_name,
#                product_price,
#                product_detail_icon,
#                product_detail_text)
