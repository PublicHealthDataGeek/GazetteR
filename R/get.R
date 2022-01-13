#' Get data from the Gazette API
#'
#' @param categorycode
#' @param start_publish_date
#' @param end_publish_date
#' @param base_url
#' @param tidy Do you want tidy output? `TRUE` by default
#' @param return_content Get ids (warning: slower), `FALSE` by default
#'
#' @return
#' @export
#'
#' @examples
#' test_tidy = get_gazette_feed(
#'   categorycode = 15,
#'   start_publish_date = "01/01/2021",
#'   end_publish_date = "31/01/2021"
#' )
#' test_jan_2021 = get_gazette_feed(
#'   categorycode = 15,
#'   start_publish_date = "01/01/2021",
#'   end_publish_date = "31/01/2021",
#'   tidy = FALSE
#' )
get_gazette_feed = function(categorycode = 15,
                            start_publish_date = "01/01/1998",
                            end_publish_date = "31/12/1998",  # NB CANT BE SAME AS START DATE - they use diff URL which wont work
                            base_url = "https://www.thegazette.co.uk/",
                            tidy = TRUE
) {
  browser()
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
  if (tidy) {
    return(tidy_gazette_feed(notices_entries))
  } else {
    return(notices_entries)
  }
}

# Todo: make public
tidy_gazette_feed = function(df) {
  vars = c("author", "category")
  df %>%
    dplyr::select(!all_of(vars)) %>%
    dplyr::rename(notice_url = id,
           status = `f:status`,
           notice_code = `f:notice-code`,
           date_updated = `updated`,
           date_published = `published`) %>%
    dplyr::mutate(date_updated = lubridate::date(date_updated),
           date_published = lubridate::date(date_published),
           notice_url = stringr::str_remove(notice_url, "id/"),
           notice_id = stringr::str_remove(notice_url, "https://www.thegazette.co.uk/notice/"),
           content = stringr::str_to_lower(content)) %>%
    dplyr::mutate_at(c("status", "notice_code", "title"), factor)
}

#' Get notice content
#'
#' @param id
#' @param search_terms
#'
#' @return
#' @export
#'
#' @examples
#' # From URL: https://www.thegazette.co.uk/notice/3487301
#' x4 = get_notice_content(3487301, "contraflow")
#' x4b = get_notice_content4(3487301, search_terms = c("contraflow", "contra-flow"))
#' x4c = get_notice_content4(3487301, search_terms = c("cycling"))
#' x4d = get_notice_content4(3487301, search_terms = c("taxi"))
get_notice_content = function(id, search_terms){
  # browser()
  url = paste0("https://www.thegazette.co.uk/notice/", id)
  u = rvest::read_html(url)
  content = stringr::str_to_lower(u %>% rvest::html_nodes("p") %>% rvest::html_text2())
  search = stringr::str_detect(content, paste(search_terms, collapse = "|"))
  search_result = any(search)
  borough = u %>% rvest::html_node("span") %>% rvest::html_text2()  # gets borough
  pub_date = u %>% rvest::html_node("dd time") %>% rvest::html_text2() #    gets publication date
  notice_code = u %>% rvest::html_node("dd:nth-child(10)") %>% rvest::html_text2() # gets notice code
  # # process content
  # class(content)
  # length(content)
  content_pasted = paste(content, collapse = "\n")
  # length(content_pasted) # single output
  notice = data.frame(notice_code, pub_date, borough, search_result, content_pasted) # creates a dataframe
  notice = notice %>%
    dplyr::mutate(pub_date = lubridate::dmy(sub("\\,.*", "", pub_date))) %>%  # puts date in correct format
    dplyr::mutate(borough = factor(borough))  # factors borough
}

#' Get content associated with ids
#'
#' @param ids Notice IDs
#' @param search_terms Character of search terms
#'
#' @return
#' @export
#'
#' @examples
#' content = get_content(c(3487301, 3487301), search_terms = "contraflow")
#' dim(content)
get_content = function(ids, search_terms) {
  purrr::map_dfr(ids, get_notice_content, search_terms)
}

# # Test
# jsonlite::fromJSON("https://www.thegazette.co.uk/notice/3487301/data.rdfjson?view=linked-data")
# jsonpoint = sf::st_as_sf(data.frame(x = 0.047331, y = 51.507702), coords = c("x", "y"), crs = 4326)
# mapview::mapview(jsonpoint)
