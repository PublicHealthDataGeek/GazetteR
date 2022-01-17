
# GazetteR

The purpose of this package is to facilitate the easy analysis of The
Gazette information in R.

It achieves this by enabling users to search the online Gazette and
identify notices that they are interested in obtaining. It then obtains
those notices and allows users to search the notice content to establish
if they are relevant. All this data is then available in R dataframes to
facilitate further analysis such as text analysis or linking to other
datasets such as OpenStreetMap or Official National Statistics.

### The Gazette - the Official Public Record in the UK

The Gazette is the Official Public Record combining three publications:
The London Gazette, The Belfast Gazette and The Edinburgh Gazette. It
predominantly consists of statutory notices i.e. where a person or
organisation or company is legally required to advertise an event or
proposal in The Gazette. Notices can only be placed in The Gazette by:
registered and verified people, who are acting in an official capacity
and who have the authority to create an official record of fact
e.g. solicitors, executers of will.

It contains over 450 different types of notices. Key categories include:

-   Public notices - these are placed by local authorities, government
    agencies or public bodies when there is a legal requirement or they
    are in the public interest. These include transport and highways
    notices, planning applications, and notices relating to health,
    agriculture, environment and infrastructure, including public
    services.

-   State notices - state and parliamentary notices placed by the Crown
    and some government organisations.

-   Other public sector notices - ecclesiastical, public finance and
    unclaimed estate notices.

-   Insolvency notices - corporate and private insolvency notices.

-   Personal legal - notices that individuals or legal professionals may
    need to make publicly available e.g. changes or name, deceased
    estates

-   Other notices - contains all other notices that do not fall into the
    above categories e.g. companies regulation, partnerships and
    societies regulation

Information on the different types of notices can be found here
<https://www.thegazette.co.uk/noticecodes>.

The Gazette also publishes specific supplements that gather together
certain notices in a special edition. These include the Company Law
Supplement containing details of information notified to or by Companies
House such as Certificates of incorporation, company’s memorandum and
articles, company’s directors etc; and the Ministry of Defence
Supplement.

The Gazette provides an online search function to identify notices. This
search facility includes the ability to search by:

-   free text

-   notice type (1998 onwards)

-   notice code

-   location(s) - postcode or place with a certain number of miles OR
    local authority (drop-down list)

-   publication dates

-   Gazette edition (London, Edinburgh or Belfast)

The search facility returns a page of notices (defaulting to 10)
displaying the Publication Date, a title (wording depends on search
approach used but may be notice category, legal act etc), the first few
lines of the notice content and a link to viewing the full notice. Links
to additional pages of results are displayed at the bottom of the page
aswell as the total number of search results.

The Gazette has developed a API interface that allows authorised people
to place notices but also allows other users to view Gazette content.  
Details on the Data formats can be found here
<https://www.thegazette.co.uk/data/formats>. The Developer Documentation
for this interface is available at:
<https://github.com/TheGazette/DevDocs/blob/master/home.md>

### GazetteR installation

You can install the developed version of CycleInfraLnd from
[Github](https://github.com/PublicHealthDataGeek/GazetteR) with:

``` r
install.packages("devtools")
devtools::install_github("PublicHealthDataGeek/GazetteR")
```

Please note that The Gazette requests that users perform activity in
non-business hours i.e. between 9pm and 7am.

### GazetteR functions

These examples show how to get data from The Gazette Search and return
it in a tidied or non-tided format.

``` r
library(GazetteR)
test_tidy = get_gazette_feed(
  categorycode = 15,
  start_publish_date = "01/01/2021",
  end_publish_date = "31/01/2021"
) # returns tidied data with column headings that make sense and dates in correct date format
names(test_tidy)
```

    ## [1] "notice_url"     "status"         "notice_code"    "title"         
    ## [5] "date_updated"   "date_published" "content"        "notice_id"

``` r
test_non_tidy = get_gazette_feed(
  categorycode = 15,
  start_publish_date = "01/01/2021",
  end_publish_date = "31/01/2021",
  tidy = FALSE
) # return non-tidied data with original column headings and all data as character data type
names(test_non_tidy)
```

    ## [1] "id"            "f:status"      "f:notice-code" "title"        
    ## [5] "author"        "updated"       "published"     "category"     
    ## [9] "content"

Other functions allow you to get more data including the full text
content of the notice. For example, `get_notice_content` allows you to
specify a particular notice and extract more data such as the full text
content of the notice and the borough. This function also lets you
search the content and returns a TRUE/FALSE column depending on whether
that terms is found in the content.

``` r
# From URL: https://www.thegazette.co.uk/notice/3487301
content_3725064 = get_notice_content(3725064, "contraflow")
names(content_3725064)
```

    ## [1] "notice_id"      "pub_date"       "borough"        "search_result" 
    ## [5] "content_pasted"

``` r
print(content_3725064$content_pasted)
```

    ## [1] "published by authority | est 1665\n1. transport for london, hereby gives notice that it intends to make the above named order under section 6 of the road traffic regulation act 1984.\n2. the general nature and effect of the order will be:\n1) transfer authority status to transport for london on morley road south-eastern side to between lewisham high street and a point 17 metres south-east of a point opposite the extended north-western building line of no. 221 lewisham high street (extension of 6 metres);\n2) extend the exiting 9 metre loading only bay on morley road south-eastern side to a length of 15 metres, and amend the hours of operation to no stopping at any time‘ except ‘loading 10am-4pm loading max 40 mins’;\n3) amend the 15 metre loading only bay on morley road south-eastern side to allow taxis to use the bay between 4pm and 10am.\n3. the road which would be affected by the order is the a21 gla side road – morley road in the london borough of lewisham.\n4. a copy of the order, a statement of transport for london’s reasons for the proposals, a map indicating the location and effect of the order and copies of any order revoked, suspended or varied by the order can be inspected by visiting our website at www.tfl.gov.uk/traffic-orders-2021 then select traffic order gla/2021/0010 copies of the documents may be requested via email at trafficordersection@tfl,gov.uk, or by post at the following address quoting reference np/regulation/stot/bs/tro, gla/2021/0010.\n• transport for london, streets traffic order team (np/regulation/stot), palestra, 197 blackfriars road, london, se1 8nj.\n5. all objections and other representations to the proposed order must be made in writing and must specify the grounds on which they are made. objections and representations must be sent to transport for london, streets traffic order team, palestra, 197 blackfriars road, london, se1 8nj or by emailing trafficordersection@tfl.gov.uk quoting reference np/regulation/stot/bs/tro, gla/2021/0010, to arrive before 19th february 2021. please note due to covid-19 access to post is restricted and requests for documents and confirmation of your objections or representations may be delayed. objections and other representations may be communicated to other persons who may be affected.\ndated this 29th day of january 2021\njennifer melbourne, performance & planning manager - south, transport for london, palestra, 197 blackfriars road, london, se1 8nj\nthink of a digital signature as an electronic, encrypted, stamp of authentication on digital information. this signature confirms that the information originated from the trusted signer and has not been altered.\nthe gazette is published by tso (the stationery office) under the superintendence of her majesty's stationery office (hmso), part of the national archives\nall content is available under the open government licence v3.0, except where otherwise stated. however, please note that this licence does not cover the re-use of personal data. if you are interested in linking to this website please read our linking policy."

The final function allows you to get the notice content for a list of
notices.

``` r
content = get_content(c(3725064, 3487301), search_terms = "contraflow")
dim(content)
```

    ## [1] 2 5

You can then join this data to the results of the `get_gazette_feed`.

``` r
notice_3725064 = dplyr::left_join(content_3725064, test_tidy, by = "notice_id")
names(notice_3725064)
```

    ##  [1] "notice_id"      "pub_date"       "borough"        "search_result" 
    ##  [5] "content_pasted" "notice_url"     "status"         "notice_code"   
    ##  [9] "title"          "date_updated"   "date_published" "content"

### The Gazette and GazetteR limitations

The GazetteR package reflects the limitations of The Gazette API and
website. For example, The Gazette API states is it possible to use both
categorycode and noticetype as parameters (categorycode being higher
level e.g. 15 for transport whilst noticetype is subcategories eg 1501
for Road Traffic Acts). However, we have not managed to get noticetype
to work so have had to stick with categorycode. NB Confusing the API
uses the terms categorycode and noticetype but The Gazette website
search facility calls these ‘Notice type’ for categorycode and ‘Notice
code’’ for noticetype.

The data returned by the `get_gazette_feed` function reflects the
limited content returned by The Gazette online search, namely a
publication date, title and a few lines of content plus additional data
such as the unique notice id, notice url and the 4 digit notice code
from the API.

This package was originally developed to look for notices that introduce
contraflow bike lanes in London Boroughs specifically for notices with a
category code of 15). So some of the column headings may be
inappropriate for other searches (for example I have spotted that notice
3723277 returns a ‘borough’ of Guildford that seems which seems to be
the location of a Highways England office!). This package hasnt been
tested with other Gazette category codes so the structure and content of
the data returned may not be quite right.

Please raise as issues or requests via the github issue page and I will
get to these as an when I can. If anyone is interested in collaborating
to improve the code or make it more robust for other searches then
please get in touch via <ugm4cjt@leeds.ac.uk>.
