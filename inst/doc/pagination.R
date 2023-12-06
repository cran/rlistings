## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- message=FALSE-----------------------------------------------------------
library(rlistings)

## -----------------------------------------------------------------------------
adae <- ex_adae[1:100, ]

## -----------------------------------------------------------------------------
lsting <- as_listing(
  df = adae,
  key_cols = c("USUBJID", "ARM"),
  disp_cols = c("AETOXGR", "AEDECOD", "AESEV"),
  main_title = "Title",
  main_footer = "Footer"
)

head(lsting, 20)

## -----------------------------------------------------------------------------
paginate_listing(lsting)

## -----------------------------------------------------------------------------
paginate_listing(lsting, lpp = 50, cpp = NULL)

## -----------------------------------------------------------------------------
cat(export_as_txt(lsting))

## -----------------------------------------------------------------------------
split_listing_by_param <- function(lsting, param, page_prefix = param) {
  checkmate::assert_class(lsting, "listing_df")
  checkmate::assert_choice(param, names(lsting))

  lsting_by_param <- list()
  for (lvl in unique(lsting[[param]])) {
    param_desc <- paste0(page_prefix, ": ", lvl)
    lsting_by_param[[lvl]] <- lsting[lsting[[param]] == lvl, ]
    subtitles(lsting_by_param[[lvl]]) <- c(subtitles(lsting), param_desc)
  }
  unname(lsting_by_param)
}

## -----------------------------------------------------------------------------
lsting_by_arm <- lsting %>%
  split_listing_by_param("ARM", page_prefix = "Treatment Arm")

lsting_by_arm

## -----------------------------------------------------------------------------
paginate_lsting_by_param <- function(lsting, ...) {
  unlist(lapply(lsting, paginate_listing, ...), recursive = FALSE)
}

## -----------------------------------------------------------------------------
export_to_txt_lsting_by_param <- function(lsting, file = NULL, page_break = "\\s\\n", ...) {
  lst <- unlist(lapply(lsting, export_as_txt, page_break = page_break, ...), recursive = FALSE)
  res <- paste(lst, collapse = page_break)
  if (is.null(file)) res else cat(res, file = file)
}

## -----------------------------------------------------------------------------
cat(export_to_txt_lsting_by_param(lsting_by_arm))

