###############################################################################
#                   Get_gazette_notice_contents

# - takes the id from the tidy_gazette_feed or search_gazette_Feed df 
# - Pastes that id into weblink 
# - Queries the Gazette  
# - Returns html object 
# - Extracts id, borough, date of publication and content CURRENTLY CONTENT IS A MESS – NEED TO PUT INTO ONE CELL 
# - Add these values into a df  DO WE WANT TO JOIN TO THE OTHER DATAFRAME FROM tidy_gazette_feed
# - Repeats for each id in the tidy_Gazette_feed df LOOP NOT DEVELOPED
# - # Limits queries to 1 per sec 
# -? TIdies df? - or ? Separate function  
# ? combine search


library(tidyverse)
library(rvest)

# this function gets the text body of the notice
get_notice_content1 = function(id){
  url = paget_notice_content5 = function(id, search_terms){
    url = paste0("https://www.thegazette.co.uk/notice/", id)
    u = read_html(url)
    content = str_to_lower(u %>% html_nodes("p") %>% html_text2())
    search = str_detect(content, paste(search_terms, collapse = "|")) 
    search_result = TRUE %in% search
    borough = u %>% html_node("span") %>% html_text2()  # gets borough
    pub_date = u %>% html_node("dd time") %>% html_text2() #    gets publication date
    notice_code = u %>% html_node("dd:nth-child(10)") %>% html_text2() # gets notice code
    notice = data.frame(notice_code, pub_date, borough, search_result) # creates a dataframe 
    notice = notice %>%
      mutate(pub_date = dmy(sub("\\,.*", "", pub_date))) %>%  # puts date in correct format
      mutate(borough = factor(borough))  # factors borough
  } # THIS WORKS
  ste0("https://www.thegazette.co.uk/notice/", id)
  u = read_html(url)
  u %>% html_nodes("p" ) %>% html_text2()  # gets body of notice content 
} # works

x1 = get_notice_content1(3487301)

# This gets the borough, publication date and notice code
get_notice_content2 = function(id){
  url = paste0("https://www.thegazette.co.uk/notice/", id)
  u = read_html(url)
  #content = u %>% html_nodes("p") %>% html_text2()
  borough = u %>% html_node("span") %>% html_text2()  # gets borough
  pub_date = u %>% html_node("dd time") %>% html_text2() #    gets publication date
  notice_code = u %>% html_node("dd:nth-child(10)") %>% html_text2() # gets notice code
  notice = data.frame(notice_code, pub_date, borough) # creates a dataframe 
  notice = notice %>%
    mutate(pub_date = dmy(sub("\\,.*", "", pub_date))) %>%  # puts date in correct format
    mutate(borough = factor(borough))  # factors borough
} # works

x2 = get_notice_content2(3487301)

# This tries to put the above two functions into one but it doesnt work
get_notice_content3 = function(id){
  url = paste0("https://www.thegazette.co.uk/notice/", id)
  u = read_html(url)
  #content = u %>% html_nodes("p") %>% html_text2()
  borough = u %>% html_node("span") %>% html_text2()  # gets borough
  pub_date = u %>% html_node("dd time") %>% html_text2() #    gets publication date
  notice_code = u %>% html_node("dd:nth-child(10)") %>% html_text2() # gets notice code
  content = u %>% html_nodes("p") %>% html_text2()  # gets body of notice content 
  notice = data.frame(notice_code, pub_date, borough, content) # creates a dataframe 
  notice = notice %>%
    mutate(pub_date = dmy(sub("\\,.*", "", pub_date))) %>%  # puts date in correct format
    mutate(borough = factor(borough))  # factors borough
} # THIS DOESNT WORK AS IT PUTS EACH TEXT LINE FROM THE CONTENT AS A NEW ROW IN THE DF 

x3 = get_notice_content3(3487301)


# This combines 

get_notice_content4 = function(id, search_terms){
  url = paste0("https://www.thegazette.co.uk/notice/", id)
  u = read_html(url)
  content = str_to_lower(u %>% html_nodes("p") %>% html_text2())
  search = str_detect(content, paste(search_terms, collapse = "|")) 
  search_result = TRUE %in% search
  borough = u %>% html_node("span") %>% html_text2()  # gets borough
  pub_date = u %>% html_node("dd time") %>% html_text2() #    gets publication date
  notice_code = u %>% html_node("dd:nth-child(10)") %>% html_text2() # gets notice code
  notice = data.frame(notice_code, pub_date, borough, search_result) # creates a dataframe 
  notice = notice %>%
    mutate(pub_date = dmy(sub("\\,.*", "", pub_date))) %>%  # puts date in correct format
    mutate(borough = factor(borough))  # factors borough
} # THIS WORKS

x4 = get_notice_content4(3487301, "contraflow")
x4b = get_notice_content4(3487301, search_terms = c("contraflow", "contra-flow"))
x4c = get_notice_content4(3487301, search_terms = c("cycling"))
x4d = get_notice_content4(3487301, search_terms = c("taxi"))
