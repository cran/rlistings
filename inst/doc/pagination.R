## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----message=FALSE------------------------------------------------------------
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
lsting_by_arm <- lsting %>%
  split_into_pages_by_var("ARM", page_prefix = "Treatment Arm")

lsting_by_arm

## -----------------------------------------------------------------------------
cat(export_as_txt(lsting_by_arm))

