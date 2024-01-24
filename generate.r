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
library(stringr)

make_slug <- function(s, max_words = 10) {
  sapply(s, function(ss){
    x <- gsub("[^[:alnum:] ]", "", ss) %>%
    tolower() %>%
    str_split(" ", n = max_words + 1) %>%
    unlist()
    if(length(x) > max_words) x <- x[1:max_words]
    x <- paste0(x, collapse = "_")
    return(x)
  }, USE.NAMES = FALSE)
}

# organise_categories <- function(dat) {
#   o <- Map(
#     c,
#     strsplit(dat$`What data types can the method be used with?\r\n`,
#              split = ";"),
#     strsplit(dat$`Analytical contexts?`, split = ";"),
#     strsplit(dat$`Specific scientific context (if any)?`, split = ";"),
#     strsplit(dat$`This method is primarily concerned with`, split = ";")
#   )
#   
#   lapply(o, \(x) x[!is.na(x)])
#   
#   # dat$`What data types can the method be used with?\r\n`
#   # dat$`Analytical contexts?`
#   # dat$`Specific scientific context (if any)?`
#   # dat$`These guidelines address`
#   # dat$`This method is primarily concerned with`
#   # dat$`How are instruments selected?`
# }

generate_posts <- function(i, dat, template) {
  # write yaml
  # append yaml to template
  l <- list()
  l$title <- dat$title[i]
  l$author <- dat$author[i]
  l$date <- dat$pubdate[i]
  l$comments <-
    list(utterances = list(repo = "open-mr-project/siteComments"))
  # d <- format_data(dat[i,])
  #l$categories <- dat$categories[i]
  l$data <- dat[i, ]
  dir.create(here("entries", dat$slug[i]))
  c("---",
    as.yaml(l) %>% gsub("\\n$", "", .),
    "---",
    "",
    readLines(template),
    "") %>%
    writeLines(con = here("entries", dat$slug[i], "index.qmd"))
  return(NULL)
}

fix_doi <- function(doi) {
  ind <- grepl("^doi.org/", doi)
  doi[ind] <- paste0("https://", doi[ind])
  ind <- !grepl("^https://doi.org/", doi)
  doi[ind] <- paste0("https://doi.org/", doi[ind])
  doi
}

make_color_var <- function(d, ref_field, ref_string, out_name, on_color = "#00796B", off_color = "#808080"){
  d[[out_name]] <- off_color
  i <- which(str_detect(d[[ref_field]], fixed(ref_string)))
  d[[out_name]][i] <- on_color
  return(d)
}

get_metadata <- function(d, on_color = "#00796B", off_color = "#808080", 
                         on_symbol = "&check;", off_symbol = "&cross;"){
  
  names(d) <- make_slug(names(d))
  
  d <- d %>% 
    rename(method_website = documentation_or_website_url_optional,
           code_language = software_language_eg_python_r_etc, 
           other_url = other_relevant_urls_eg_cran_link, 
           brief_description = provide_a_brief_text_description_of_the_method_less_than) %>% 
    mutate(title = case_when(is.na(abbreviated_method_name) ~ method_name, 
                                                   TRUE ~ abbreviated_method_name), 
            author = primary_entry_contact,
            method_website = case_when(!is.na(method_website) ~ method_website, 
                                       .default = "none"),
           other_url = case_when(!is.na(other_url) ~ other_url, 
                                      .default = "none"),
            primary_method_contact = case_when(!is.na(primary_method_contact) ~ primary_method_contact, 
                                               .default = "none"),
            primary_method_contact_email_address = case_when(!is.na(primary_method_contact_email_address) ~ primary_method_contact_email_address, 
                                                     .default = "none"),
            slug = make_slug(title)) 
   
  d$publication_doi <- fix_doi(d$publication_doi)
  d$pubdate <-
    sapply(d$publication_doi, \(x) Diderot::get_date_from_doi(x, TRUE))
  d$pubdate[d$pubdate == d$publication_doi] <- ""
  
  analysis_var <- "which_analysis_types_is_the_method_used_for"
  data_types_var <- "what_data_types_can_the_method_be_used_with"
  ex_data_var <- "what_types_of_exposure_variables_can_be_used_if_network"
  out_data_var <- "what_types_of_outcome_variables_can_be_used_if_network"
  assumptions_var <- "which_mr_conditions__assumptions_are_requiredrelaxed_by_the_method"
  d <- d %>% make_color_var(., analysis_var, "Univariable MR (one exposure, one outcome)", "uvmr_color", on_color, off_color) %>% 
    make_color_var(., analysis_var, "Multivariable MR (multiple exposures, one outcome)", "mvmr_color", on_color, off_color) %>% 
    make_color_var(., analysis_var, "Bi-directional MR", "bidirectional_color", on_color, off_color) %>% 
    make_color_var(., analysis_var, "Non-linear effect estimation", "nonlinear_color", on_color, off_color) %>% 
    make_color_var(., analysis_var, "Network MR (forming a causal DAG containing multiple traits)", "network_color", on_color, off_color) %>%
    make_color_var(., data_types_var, "Individual level data for both exposure(s) and outcome(s) (or all traits if Network MR)", 
                   "ii_color", on_color, off_color) %>%
    make_color_var(., data_types_var, "GWAS summary statistics for both exposure(s) and outcome(s) (or all traits if Network MR)", 
                   "ss_color", on_color, off_color) %>%
    make_color_var(., data_types_var, "Individual level family data (siblings, trios, twins, etc.) for either exposure(s) or outcome(s) or both.", 
                   "fam_color", on_color, off_color) %>%
    make_color_var(., data_types_var, "Individual level data for exposure(s), summary statistics for outcome(s)", 
                   "is_color", on_color, off_color) %>%
    make_color_var(., data_types_var, "Summary statistics for exposure(s), individual level for outcome(s)", 
                   "si_color", on_color, off_color) %>%
    make_color_var(., ex_data_var, 
                   "Quantitative/continuous", 
                   "exquant_color", on_color, off_color) %>%
    make_color_var(., ex_data_var, 
                   "Binary", 
                   "exbin_color", on_color, off_color) %>%
    make_color_var(., ex_data_var, 
                   "Survival/Time-to-event", 
                   "extte_color", on_color, off_color) %>%
    make_color_var(., out_data_var, 
                   "Quantitative/continuous", 
                   "outquant_color", on_color, off_color) %>%
    make_color_var(., out_data_var, 
                   "Binary", 
                   "outbin_color", on_color, off_color) %>%
    make_color_var(., out_data_var, 
                   "Survival/Time-to-event", 
                   "outtte_color", on_color, off_color) %>%
    make_color_var(., assumptions_var, 
                   "The method is robust to weak instruments or reduces weak instrument bias",
                   "weak_inst_symbol", on_symbol, off_symbol) %>%
    make_color_var(., assumptions_var, 
                   "The method accounts for winner's curse bias due to in-sample variant selection.",
                   "winners_curse_symbol", on_symbol, off_symbol) %>%
    make_color_var(.,assumptions_var, 
                   "Bias due to sample overlap",
                   "sample_overlap_symbol", on_symbol, off_symbol) %>%
    make_color_var(.,assumptions_var, 
                   "The method accounts for population stratification",
                   "confounding_symbol", on_symbol, off_symbol) %>%
    make_color_var(., assumptions_var, 
                   "The method accounts for effects of assortative mating",
                   "assortative_mating_symbol", on_symbol, off_symbol) %>%
    make_color_var(., assumptions_var, 
                   "The method accounts for balanced (uncorrelated) ",
                   "uhp_symbol", on_symbol, off_symbol) %>%
    make_color_var(.,assumptions_var, 
                   "The method accounts for unbalanced (correlated)",
                   "chp_symbol", on_symbol, off_symbol) %>%
    make_color_var(., assumptions_var, 
                   "The method accounts for index-event bias or bias due to conditioning on a heritable trait.",
                   "colliding_symbol", on_symbol, off_symbol) %>%
    make_color_var(., assumptions_var, 
                   "The method accounts for ancestry differences between exposure and outcome samples.",
                   "anc_diff_symbol", on_symbol, off_symbol)
  return(d)
}

dat <- read_xlsx(here("data", "openMR.xlsx"))

dat_methods <- get_metadata(dat) 

unlink(list.files(here("entries"), full.names = TRUE), recursive = TRUE)
dir.create(here("entries"),
           recursive = TRUE,
           showWarning = FALSE)

lapply(seq_len(nrow(dat_methods)),
       \(i) {
         message(i)
         generate_posts(i, dat_methods, here("data", "template"))
       })

saveRDS(dat_methods, file = here("data", "openmr.RDS"))
