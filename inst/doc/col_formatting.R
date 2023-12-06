## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- message=FALSE-----------------------------------------------------------
library(rlistings)

## -----------------------------------------------------------------------------
adae <- ex_adae[1:15, ]

set.seed(1)
adae <- as.data.frame(lapply(adae, function(x) replace(x, sample(length(x), 0.1 * length(x)), NA)))

adae <- adae %>% dplyr::arrange(USUBJID, AGE, TRTSDTM)

## -----------------------------------------------------------------------------
lsting_1 <- as_listing(
  df = adae,
  key_cols = c("USUBJID", "AGE", "TRTSDTM"),
  disp_cols = c("BMRKR1", "ASEQ", "AESEV"),
)

lsting_1

## -----------------------------------------------------------------------------
default_fmt <- list(
  all = fmt_config(na_str = "<No data>", align = "left")
)

lsting_2 <- as_listing(
  df = adae,
  key_cols = c("USUBJID", "AGE", "TRTSDTM"),
  disp_cols = c("BMRKR1", "ASEQ", "AESEV"),
  default_formatting = default_fmt
)

lsting_2

## -----------------------------------------------------------------------------
default_fmt <- list(
  all = fmt_config(na_str = "<No data>", align = "left"),
  numeric = fmt_config(format = "xx.xx", na_str = "<No data>", align = "decimal")
)

lsting_3 <- as_listing(
  df = adae,
  key_cols = c("USUBJID", "AGE", "TRTSDTM"),
  disp_cols = c("BMRKR1", "ASEQ", "AESEV"),
  default_formatting = default_fmt
)

lsting_3

## -----------------------------------------------------------------------------
# Custom format function - takes date format as input
date_fmt <- function(fmt) {
  function(x, ...) do.call(format, list(x = x, fmt))
}

default_fmt <- list(
  all = fmt_config(na_str = "<No data>", align = "left"),
  numeric = fmt_config(format = "xx.xx", na_str = "<No data>", align = "decimal"),
  POSIXt = fmt_config(format = date_fmt("%B %d, %Y @ %I:%M %p %Z"), na_str = "<No data>")
)

lsting_4 <- as_listing(
  df = adae,
  key_cols = c("USUBJID", "AGE", "TRTSDTM"),
  disp_cols = c("BMRKR1", "ASEQ", "AESEV"),
  default_formatting = default_fmt
)

lsting_4

## -----------------------------------------------------------------------------
lsting_4

## -----------------------------------------------------------------------------
default_fmt <- list(
  all = fmt_config(na_str = "<No data>", align = "left"),
  numeric = fmt_config(format = "xx", na_str = "<No data>", align = "right"),
  POSIXt = fmt_config(format = date_fmt("%B %d, %Y @ %I:%M %p %Z"), na_str = "<No data>")
)

col_fmt <- list(
  BMRKR1 = fmt_config(format = "xx.xx", na_str = "<No data>", align = "decimal")
)

lsting_5 <- as_listing(
  df = adae,
  key_cols = c("USUBJID", "AGE", "TRTSDTM"),
  disp_cols = c("BMRKR1", "ASEQ", "AESEV"),
  default_formatting = default_fmt,
  col_formatting = col_fmt
)

lsting_5

## -----------------------------------------------------------------------------
lsting_6 <- lsting_5 %>%
  add_listing_col(
    name = "Length of\nAnalysis",
    fun = function(df) df$AENDY - df$ASTDY,
    format = "xx.x",
    na_str = "NE",
    align = "center"
  )

lsting_6

