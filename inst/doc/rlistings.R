## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(rlistings)

## -----------------------------------------------------------------------------
adae <- ex_adae

## -----------------------------------------------------------------------------
lsting <- as_listing(
  df = adae,
  disp_cols = c("USUBJID", "AETOXGR", "ARM", "AGE", "SEX", "RACE", "AEDECOD", "AESEV"),
)

head(lsting, 15)

## -----------------------------------------------------------------------------
lsting <- as_listing(
  df = adae,
  non_disp_cols = tail(names(adae), 8)
)
head(lsting, 15)

## -----------------------------------------------------------------------------
lsting <- as_listing(
  df = adae,
  disp_cols = c("ARM", "AGE", "SEX", "RACE", "AEDECOD", "AESEV"),
  key_cols = c("USUBJID", "AETOXGR")
)

head(lsting, 15)

## -----------------------------------------------------------------------------
lsting <- as_listing(
  df = adae,
  disp_cols = c("ARM", "AGE", "SEX", "RACE", "AEDECOD", "AESEV"),
  key_cols = c("USUBJID", "AETOXGR"),
  main_title = "Main Title",
  subtitles = c("Subtitle A", "Subtitle B"),
  main_footer = c("Main Footer A", "Main Footer B", "Main Footer C"),
  prov_footer = c("Provenance Footer A", "Provenance Footer B")
)

head(lsting, 15)

