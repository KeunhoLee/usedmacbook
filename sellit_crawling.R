SCRIPT_HOME <- Sys.getenv('SCRIPT_HOME')
DATA_HOME   <- Sys.getenv('DATA_HOME')

print(paste0( 'SCRIPT_HOME : ', SCRIPT_HOME) )
print(paste0( 'DATA_HOME : ', DATA_HOME) )

source( paste0(SCRIPT_HOME, 'packages.R'), encoding = 'utf-8' )
source( paste0(SCRIPT_HOME, 'tools_sellit.R'), encoding = 'utf-8' )

basic_info <- readRDS('basic_info.rds')
id_record <- basic_info$product_id

main_url <- 'https://www.withsellit.com'
url <- str_interp('${main_url}/search?query=%EB%A7%A5%EB%B6%81&buyable=buyable&categories=laptop_pc&used_states=used')

#binman::list_versions("chromedriver")
#remDr$server$stop()

remDr <- fn_start_driver(4442L)

init_page_to_crawl(remDr, url)

parsed_url <- get_detail_url(remDr)

#length(parsed_url)

product_id          <- NULL
product_name        <- NULL
product_price       <- NULL
product_detail_icon <- list()
product_detail_text <- list()

for( i in 1:length(parsed_url) ){
  
  print( paste0(i, '/', length(parsed_url)))
  
  sub_url <- parsed_url[i]
  
  url <- str_interp('${main_url}${sub_url}')
  
  page_src <- get_page_src(remDr, url)
  
  tmp_id <- get_product_id(page_src)
  
  if( tmp_id %in% id_record ){
    
    Sys.sleep( rexp(1, 1/3) )
    
    next
    
  }
  
  product_id    <- c(product_id, tmp_id)
  
  product_name  <- c(product_name, get_product_name(page_src))
  
  product_price <- c(product_price, get_product_price(page_src))
  
  product_detail_icon[[i]] <- get_product_detail_icon(page_src)
  
  product_detail_text[[i]] <- get_product_detail_text(page_src)
  
  Sys.sleep( rexp(1, 1/3) )
  
}

remDr$server$stop()

result <- list(product_id,
               product_name,
               product_price,
               product_detail_icon,
               product_detail_text)

print( paste0( 'Result cases : ', length(result[[2]]) ) )

if( length(result[[1]]) != 0 ) {
  
  result_df <- as.data.frame( result[1:3], stringsAsFactors = FALSE )
  names(df) <- c('product_id', 'product_name', 'product_price')
  
  tstamp <- Sys.time()
  tstamp <- gsub(' ', '-', tstamp)
  tstamp <- gsub(':', '', tstamp)
  tstamp <- gsub('-', '', tstamp)
  
  result_df$timestamp <- tstamp
  
  basic_info <- rbind(basic_info, result_df)
  
  saveRDS(result_df, 'basic_info.rds')
  saveRDS(result, str_interp('${DATA_HOME}data_${tstamp}.rds'))  
  
} 

print( 'Done.')