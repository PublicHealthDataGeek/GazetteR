#' Get data from the Gazette API
#'
#' @param categorycode
#' @param start_publish_date
#' @param end_publish_date
#' @param base_url
#'
#' @return
#' @export
#'
#' @examples
#'
#' test_jan_2021 = get_gazette_feed(categorycode = 15,
#' start_publish_date = "01/01/2021",
#' end_publish_date = "31/01/2021") # works (jan 21) n = 198
get_gazette_feed = function(categorycode = 15,
                            start_publish_date = "01/01/1998",
                            end_publish_date = "31/12/1998",  # NB CANT BE SAME AS START DATE - they use diff URL which wont work
                            base_url = "https://www.thegazette.co.uk/"
) {
  # browser()
  u = httr::modify_url(
    base_url,
    path = "all-notices/notice/data.json",
    query = list(
      categorycode = categorycode,
      `start-publish-date` = start_publish_date,
      `end-publish-date` = end_publish_date)) # needs to be big long enough to get data back
  #put content in df
  notices = jsonlite::fromJSON(txt = u)  #
  total_notices = notices$`f:total` # get total number of notice returned by the search
  notices_entries = notices$entry  # get relevent data into df
  notices_entries$author = notices_entries$author$name # changes column that is a dataframe to an actual column
  notices_entries$category = notices_entries$category$`@term`  # changes column that is a dataframe to an actual column
  #notices_entries = subset(notices_entries, select = -c(link, `geo:Point`)) # drop columns
  notices_entries = subset(notices_entries, select = c(id, `f:status`, `f:notice-code`, title, author, updated, published, category, content)) # keep columns
  Sys.sleep(1) # pause for 1 sec
  i = 2
  while(nrow(notices_entries) != total_notices) {
    v = paste0(stringr::str_replace_all(notices$id, c("feed" = "json", "page=1" = paste0("page=", i))))
    notices_add = jsonlite::fromJSON(txt = v)
    notices_add_entries = notices_add$entry
    notices_add_entries$author = notices_add_entries$author$name # changes column that is a dataframe to an actual column
    notices_add_entries$category = notices_add_entries$category$`@term`  # changes column that is a dataframe to an actual column
    #notices_add_entries = subset(notices_add_entries, select = -c(link, `geo:Point`)) # drop columns
    notices_add_entries = subset(notices_add_entries, select = c(id, `f:status`, `f:notice-code`, title, author, updated, published, category, content)) # keep columns
    notices_entries = rbind(notices_entries, notices_add_entries)
    i = i + 1 # increment counter
  }
  return(notices_entries)
}
