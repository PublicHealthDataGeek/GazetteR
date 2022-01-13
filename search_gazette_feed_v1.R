################################################################################
#                           search_gazette_feed                                #
################################################################################

# Purpose: allows user to search the tidied gazette feed dataframe by notice code 
# and search terms.   
# 
# Actions: 
# - Takes the tidy_gazette_feed 
# - Filters on notice_code (if given 
# - Filters on strings detected in first few lines of the Notice 
#   -- Eg. Local Authority, Council, Borough or Transport for London 
#   -- User can give a list or search terms 
#   -- Can search using AND or OR 


library(tidyverse)
library(stringr)

search_gazette_feed = function(df, notice_code, search_terms, search_type){
  df %>%
    filter({{notice_code}} == notice_code) %>%  # can be as number or "notice_code"
    filter(str_detect(content, paste((str_to_lower(search_terms)), collapse = search_type))) # can now be any case 
}

# # search_terms needs to be a list format or can be an object of a list of values
# # search type needs to be "&" or "|" ie AND or OR

# ? how can I make notice_code, search_terms or search_type optional if there is just one search term?  Or do I just put a comment saying that it doesnt matter? 
# making arguments in functions optional. https://stackoverflow.com/questions/28370249/correct-way-to-specifiy-optional-arguments-in-r-functions

# Testing - Need to redo on a dataframe where I know what the outputs shoudl be
# test get_gazette_feed
test_get_gazette_feed = get_gazette_feed(categorycode = 15, start_publish_date = "2021-09-01", end_publish_date = "2021-09-07") # n = 30
test_tidy_gazette_feed = tidy_gazette_feed(test_get_gazette_feed) # n = 30

inner_london_search_terms = c("Transport for London", "TRANSPORT FOR LONDON",
                              "Traffic Director for London", "TRAFFIC DIRECTOR FOR LONDON",
                              "Camden", "CAMDEN", "Greenwich", "GREENWICH", "Hackney", "HACKNEY",
                              "Hammersmith", "HAMMERSMITH", "Isington", "ISLINGTON", "Kensington",
                              "KENSINGTON", "Lambeth", "LAMBETH", "Lewisham", "LEWISHAM", "Newham", "NEWHAM",
                              "Southwark", "SOUTHWARK", "Tower Hamlets", "TOWER HAMLETS", "Wandsworth", "WANDSWORTH",
                              "City of Westminster", "CITY OF WESTMINSTER", "Westminster City", "WESTMINSTER CITY",
                              "City of London", "CITY OF LONDON")

test_search_gazette_feed_1 = search_gazette_feed(df = test_tidy_gazette_feed, notice_code = "1501", 
                                                 search_terms = inner_london_search_terms, search_type = "|") # n= 10
test_search_gazette_feed_2 = search_gazette_feed(df = test_tidy_gazette_feed, notice_code = "1501", 
                                                 search_terms = c("London"), search_type = "|") # n= 15
test_search_gazette_feed_3_1 = search_gazette_feed(df = test_tidy_gazette_feed, notice_code = "1501", 
                                                   search_terms = c("London", "LONDON"), search_type = "|") # 15
test_search_gazette_feed_3_2 = search_gazette_feed(df = test_tidy_gazette_feed, notice_code = 1501, 
                                                   search_terms = c("London", "LONDON"), search_type = "|") # n= 15
test_search_gazette_feed_4_1 = search_gazette_feed(df = test_tidy_gazette_feed, notice_code = "1505", 
                                                   search_terms = c("London", "LONDON"), search_type = "|") # n = 4
test_search_gazette_feed_4_2 = search_gazette_feed(df = test_tidy_gazette_feed, notice_code = 1505, 
                                                   search_terms = c("London", "LONDON"), search_type = "|") # n = 4
test_search_gazette_feed_5 = search_gazette_feed(df = test_tidy_gazette_feed, notice_code = "1501", 
                                                 search_terms = c("Edinburgh"), search_type = "&") # n= 1
test_search_gazette_feed_6 = search_gazette_feed(df = test_tidy_gazette_feed, notice_code = "1501", 
                                                 search_terms = c("Edinburgh"), search_type = "|") # n = 1
test_search_gazette_feed_7 = search_gazette_feed(df = test_tidy_gazette_feed, notice_code = "1501", 
                                                 search_terms = inner_london_search_terms, search_type = "&") # n= 0
test_search_gazette_feed_8 = search_gazette_feed(df = test_tidy_gazette_feed, notice_code = "1501", 
                                                 search_terms = inner_london_search_terms, search_type = "|") # n = 10
test_search_gazette_feed_9 = search_gazette_feed(df = test_tidy_gazette_feed, notice_code = "1501", 
                                                 search_terms = c(inner_london_search_terms, "Brent"), search_type = "|") # n = 12 as now Brent is included

########################################################################################### 
# Developing next veresion of function where notice_code and search_terms are optional,
# search_type only has to be included in search terms are >1

# NOT WORKING PROPERLY - needs to have search_type added once working correctly

search_gazette_feed_advanced = function(df, notice_code=NULL, search_terms=NULL){
  if(!is.null(search_terms)) df %>%
    filter(str_detect(content, paste((str_to_lower(search_terms)))))
  else df %>%
    filter({{notice_code}} == notice_code)
  if(!is.null(notice_code)) df %>%
    filter({{notice_code}} == notice_code)
  else df %>%
    filter(str_detect(content, paste((str_to_lower(search_terms)))))
}  # CURRENTLY RETURNING BOTH -see edinburgh


test_gf_advanced = search_gazette_feed_advanced(test_tidy_gazette_feed, search_terms = c("LONDON")) # expect 6
test_gf_advanced2 = search_gazette_feed_advanced(test_tidy_gazette_feed, search_terms = c("LONDON"), notice_code = 1501) # 20
test_gf_advanced3 = search_gazette_feed_advanced(test_tidy_gazette_feed, notice_code = 1501) # 20
test_gf_advanced4 = search_gazette_feed_advanced(test_tidy_gazette_feed, search_terms = c("Edinburgh"))# 1
test_gf_advanced5 = search_gazette_feed_advanced(test_tidy_gazette_feed, search_terms = c("Edinburgh"), notice_code = 1501)# should return nothing but returns 20


