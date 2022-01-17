
# GazetteR

The purpose of this package is to facilitate the easy analysis of The
Gazette information in R.

It achieves this by enabling users to search the online Gazette and
identify notices that they are interested in obtaining. It then obtains
those notices and allows users to search the notice content to establish
if they are relevant. All this data is then available in R dataframes to
facilitate further analysis such as text analysis or linking to other
datasets such as OpenStreetMap or Official National Statistics.

## The Gazette - the Official Public Record in the UK

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

## GazetteR installation

You can install the developed version of CycleInfraLnd from
[Github](https://github.com/PublicHealthDataGeek/GazetteR) with:

``` r
install.packages("devtools")
devtools::install_github("PublicHealthDataGeek/GazetteR")
```

## Examples

These examples show

``` r
#library(GazetteR)
```

### Proposed functions

#### 1) Get_gazette_feed

Purpose

-   gets the search results and puts them in an R dataframe

Actions:

-   Queries the gazette notice feed -json

-   Specifies high level notice type and date range

-   Returns info and converts into text

-   Extract the useful info about the notices and puts it in a df

-   Reruns query until get to final page of info (notices$entry \<10)

-   Binds each df to the previous so get all the pages in one df

-   Limits the repeat queries to 1 per second – should be run outside
    working hours

Packages needed:

-   httr, stringr

Current status:

-   Working function but not limited to outside working hours

Validation/testing:

-   Need to check works from different notice types (currently only
    tested for 15)

-   Need to check date ranges - can it work for a single day? multiple
    years?

-   Compare results returned to the website search results

Advanced work for function:

-   What happens if user adds a non-valid notice type or incorrectly
    formatted date?

-   What happens if there are zero results?

-   ie need error responses

#### 2) Tidy_gazette_feed ? Can this be amalgamated into the get_gazette_feed function

Purpose:

-   tidies the gazette feed data frame

Actions:

-   Takes the noticefeed df

-   Deletes columns that we don’t need

-   Factors columns that need to be factored

-   Changes date to correct format

-   Renames columns to more sensibl e names

-   Creates the id column that can then be searched on

Current status:

-   have code working as a function I think

Packages needed:

-   tidyverse, lubridate

Validation/testing

-   Need to check works on different outputs of get_gazette_feed ???

Advanced work for function: - ? none

#### 3) Search_gazette_feed

Purpose: allows user to search the tidied gazette feed dataframe by
notice code and search terms.

Actions:

-   Takes the tidy_gazette_feed

-   Filters on notice_code (if given

-   Filters on strings detected in first few lines of the Notice

– Eg. Local Authority, Council, Borough or Transport for London

– User can give a list or search terms

– Can search using AND or OR

Current status: - Basic search function written but needs testing - More
advanced search function that allows search arguments to be options is
written but doesnt work.

Packages needed: - tidyverse, stringr

QUESTIONS:

-   How do I make an argument optional in a function? E.g. notice code
    and search terms?

-   If a user enters just one search term, how do I make search_type
    (&\|) not have to be completed?

-   Are there any other search options that need to be include?

-   Does it search the entire content or just the first few lines that
    are shown in the gazette feed?

Validation/testing: Advanced work for function:

#### 4) Get_gazette_notice_contents

Purpose: Takes the unique notice ids that have been returned by the
search_gazette_feed function and pulls down the notice content into R.

Actions:

-   Takes the id from the tidy_gazette_feed or search_gazette_Feed df

-   Pastes that id into weblink

-   Queries the Gazette

-   Returns html object

-   Extracts id, borough, date of publication and content CURRENTLY
    CONTENT IS A MESS – NEED TO PUT INTO ONE CELL

-   Add these values into a df - CURRENTLY 2 DF - need to be one - also
    need to join to gazette_feed df that has additional data

-   Repeats for each id in the tidy_Gazette_feed df - LOOP NOT DEVELOPED
    YET

-   Limits queries to 1 per sec

-   ? Tidies df? - or ? Separate function

Current status

– subfunctions developed for the content and the rest of the data but
cant get these into a single obs in a df

-   no loop written

Packages need:

-   rvest, tidyverse

Validation/testing: Advanced work for function:

-   ? include the search_gazette_notice_contents functionality in this
    function.

#### 5) Search_gazette_notice_contents ? should this be combined with the above

Purpose:

Actions: - takes the df returned from get_gazette_notice_contents

-   For each noticecode, searches the body of the content for specific
    search terms

-   Returns a new column that indicates whether those searchterms have
    been found or not

Current status:

-   can do it for one named noticecode, search terms are currently done
    in this manner:

contraflow_search_terms = c(“contraflow”, “CONTRAFLOW”, “contra-flow”,
“CONTRA-FLOW”)

stringr::str_detect(body_contra_test_notice_df,
paste(contraflow_search_terms, collapse = “\|”))

? More efficient way of doing it that allows user to enter any version
of contraflow cases and it searches for them

? Also have the collapse bit as an argument –presumably if change \| to
& then it will do an AND search rather than OR
