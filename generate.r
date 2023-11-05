# Only run for quarto render
if (!nzchar(Sys.getenv("QUARTO_PROJECT_RENDER_ALL"))) {
  quit()
}

library(readxl)
library(here)
library(yaml)
library(dplyr)
library(lubridate)
library(Diderot)

make_slug <- function(s) {
    gsub("[^[:alnum:] ]", "", s) %>% 
        tolower() %>%
        gsub(" ", "_", .) %>%
        make.unique(sep="_")
}

organise_categories <- function(dat) {
    o <- Map(c,
        strsplit(dat$`What data types can the method be used with?\r\n`, split=";"),
        strsplit(dat$`Analytical contexts?`, split=";"),
        strsplit(dat$`Specific scientific context (if any)?`, split=";"),
        strsplit(dat$`This method is primarily concerned with`, split=";")
    )
   
    lapply(o, \(x) x[!is.na(x)])

    # dat$`What data types can the method be used with?\r\n`
    # dat$`Analytical contexts?`
    # dat$`Specific scientific context (if any)?`
    # dat$`These guidelines address`
    # dat$`This method is primarily concerned with`
    # dat$`How are instruments selected?`
}

generate_posts <- function(i, dat, template) {
    # write yaml
    # append yaml to template
    l <- list()
    l$title <- dat$title[i]
    l$author <- dat$author[i]
    l$date <- dat$pubdate[i]
    l$comments <- list(utterances = list(repo = "mr-methods-network/siteComments"))
    # d <- format_data(dat[i,])
    l$categories <- dat$categories[i]
    l$data <- dat[i,]
    dir.create(here("entries", dat$slug[i]))
    c(
        "---",
        as.yaml(l) %>% gsub("\\n$", "", .),
        "---",
        "",
        readLines(template),
        ""
    ) %>%
    writeLines(con = here("entries", dat$slug[i], "index.qmd"))
    return(NULL)
}


format_data <- function(d) {
    if(is.na(d$abbreviated_method_name)){
        d$abbreviated_method_name <- d$method_name
    }
    d$title <- d$abbreviated_method_name
    d$author <- d$primary_contact

    d$pubdate <- Diderot::get_date_from_doi(d$publication_doi, TRUE)
    return(d)
}

fix_doi <- function(doi) {
    ind <- grepl("^doi.org/", doi)
    doi[ind] <- paste0("https://", doi[ind])
    ind <- ! grepl("^https://doi.org/", doi)
    doi[ind] <- paste0("https://doi.org/", doi[ind])
    doi
}

dat <- read_xlsx(here("data", "mrmn.xlsx"))

dat$`Abbreviated method name`[is.na(dat$`Abbreviated method name`)] <- dat$`Method name`[is.na(dat$`Abbreviated method name`)]
dat$title <- dat$`Abbreviated method name`
dat$author <- dat$`Primary contact`
dat$`Publication DOI` <- fix_doi(dat$`Publication DOI`)
dat$pubdate <- sapply(dat$`Publication DOI`, \(x) Diderot::get_date_from_doi(x, TRUE))
dat$pubdate[dat$pubdate == dat$`Publication DOI`] <- ""
dat$slug <- make_slug(dat$`Abbreviated method name`)
dat$slug[is.na(dat$slug)] <- "NA"
dat$categories <- organise_categories(dat)

metadata <- tibble(
    names = names(dat),
    slugs = make_slug(names)
)

names(dat) <- metadata$slugs

unlink(list.files(here("entries"), full.names=TRUE), recursive=TRUE)
dir.create(here("entries"), recursive=TRUE, showWarning=FALSE)

dat_methods <- subset(dat, entry_type=="Analytical method")

lapply(1:nrow(dat_methods), 
\(i) {
    message(i)
    generate_posts(i, dat_methods, here("data", "template"))
})

save(dat, metadata, file=here("data", "mrmn.rdata"))
