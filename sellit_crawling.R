SCRIPT_HOME <- Sys.getenv('SCRIPT_HOME')
DATA_HOME   <- Sys.getenv('DATA_HOME')

source( paste0(SCRIPT_HOME, 'packages.R') )

main_url <- 'https://www.withsellit.com'
url <- str_interp('${main_url}/search?query=%EB%A7%A5%EB%B6%81&buyable=buyable&categories=laptop_pc&used_states=used')

#binman::list_versions("chromedriver")
#remDr$server$stop()

remDr <- fn_start_driver(4442L)

init_page_to_crawl(remDr, url)

parsed_url <- get_detail_url(remDr)

length(parsed_url)

product_name        <- NULL
product_price       <- NULL
product_detail_icon <- list()
product_detail_text <- list()

for( i in 1:length(parsed_url) ){
  
  sub_url <- parsed_url[i]
  
  url <- str_interp('${main_url}${sub_url}')
  
  page_src <- get_page_src(remDr, url)
  
  product_name  <- c(product_name, get_product_name(page_src))
  
  product_price <- c(product_price, get_product_price(page_src))
  
  product_detail_icon[[i]] <- get_product_detail_icon(page_src)
  
  product_detail_text[[i]] <- get_product_detail_text(page_src)
  
  Sys.sleep( rexp(1, 1/3) )
  
}

result <- list(product_name,
               product_price,
               product_detail_icon,
               product_detail_text)

