################################################################################
#                                tidy_gazette_feed                             #
################################################################################

library(tidyverse)
library(lubridate)
tidy_gazette_feed = function(df) {
  vars = c("author", "category")
  df %>%
    select(!all_of(vars)) %>%
    rename(notice_url = id,
           status = 'f:status', 
           notice_code = 'f:notice-code', 
           date_updated = 'updated',
           date_published = "published") %>%
    mutate(date_updated = date(date_updated),
           date_published = date(date_published),
           notice_url = str_remove(notice_url, "id/"),
           notice_id = str_remove(notice_url, "https://www.thegazette.co.uk/notice/"),
           content = str_to_lower(content)) %>%
    mutate_at(c("status", "notice_code", "title"), factor)
}  

# Testing 
# load test dataset
# Load data
sample_gazette_feed = readRDS(file = "sample_gazette_feed.Rds")
names(sample_gazette_feed)
# [1] "id"            "f:status"      "f:notice-code" "title"        
# [5] "author"        "updated"       "published"     "category"     
# [9] "content"  

tidy_gazette_feed = tidy_gazette_feed_7(sample_gazette_feed) # THIS WORKS
#test_tidy_gazette_feed = tidy_gazette_feed(test_jan_2021)
#teset_tidy_gazette_feed = tidy_gazette_feed(test_2021)
