## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----message=FALSE------------------------------------------------------------
library(rlistings)

## -----------------------------------------------------------------------------
adae <- ex_adae[1:30, ]

## -----------------------------------------------------------------------------
lsting <- as_listing(
  df = adae,
  key_cols = c("ARM", "USUBJID", "ASEQ", "ASTDY"),
  disp_cols = c("BMRKR1", "AESEV"),
)

lsting

## -----------------------------------------------------------------------------
ref_fns <- "*   ASEQ 1 or 2\n**  Analysis start date is imputed\n***  Records with ATOXGR = 5\n**** ID column"

## -----------------------------------------------------------------------------
# Save variable labels for your data to add back in after mutating dataset
df_lbls <- var_labels(adae)

# Mutate variable where referential footnotes are to be added according to your conditions
# Specify order of levels with new referential footnotes added
adae <- adae %>% dplyr::mutate(
  ARM = factor(
    ifelse(ARM == "A: Drug X" & ASEQ %in% 1:2, paste0(ARM, "*"), as.character(ARM)),
    levels = c(sapply(levels(adae$ARM), paste0, c("", "*")))
  )
)

# Add data variable labels back in
var_labels(adae) <- df_lbls

# Generate listing
lsting <- as_listing(
  df = adae,
  key_cols = c("ARM", "USUBJID", "ASEQ", "ASTDY"),
  disp_cols = c("BMRKR1", "AESEV"),
)

lsting

## -----------------------------------------------------------------------------
set.seed(1)

# Save variable labels for your data to add back in after mutating dataset
df_lbls <- var_labels(adae)

# Mutate variable where referential footnotes are to be added according to your conditions
# Specify order of levels with new referential footnotes added
adae <- adae %>%
  dplyr::mutate(ASTDTF = sample(c("Y", NA), nrow(.), replace = TRUE, prob = c(0.25, 0.75))) %>%
  dplyr::mutate(ASTDY = factor(
    ifelse(!is.na(ASTDTF), paste0(as.character(ASTDY), "**"), as.character(ASTDY)),
    levels = c(sapply(sort(unique(adae$ASTDY)), paste0, c("", "**")))
  )) %>%
  dplyr::select(-ASTDTF)

# Add data variable labels back in
var_labels(adae) <- df_lbls

# Generate listing
lsting <- as_listing(
  df = adae,
  key_cols = c("ARM", "USUBJID", "ASEQ", "ASTDY"),
  disp_cols = c("BMRKR1", "AESEV"),
)

lsting

## -----------------------------------------------------------------------------
# Save variable labels for your data to add back in after mutating dataset
df_lbls <- var_labels(adae)

# Mutate variable where referential footnotes are to be added according to your conditions
# Specify order of levels with new referential footnotes added
adae <- adae %>% dplyr::mutate(
  AESEV = factor(
    ifelse(AETOXGR == 5, paste0(AESEV, "***"), as.character(AESEV)),
    levels = c(sapply(levels(adae$AESEV), paste0, c("", "***")))
  )
)

# Add data variable labels back in
var_labels(adae) <- df_lbls

# Generate listing
lsting <- as_listing(
  df = adae,
  key_cols = c("ARM", "USUBJID", "ASEQ", "ASTDY"),
  disp_cols = c("BMRKR1", "AESEV"),
)

lsting

## -----------------------------------------------------------------------------
# Modify data variable label
adae <- adae %>% var_relabel(
  USUBJID = paste0(var_labels(adae)[["USUBJID"]], "****")
)

# Generate listing
lsting <- as_listing(
  df = adae,
  key_cols = c("ARM", "USUBJID", "ASTDY", "ASEQ"),
  disp_cols = c("BMRKR1", "AESEV")
)

lsting

## -----------------------------------------------------------------------------
# Generate listing
lsting <- as_listing(
  df = adae,
  key_cols = c("ARM", "USUBJID", "ASTDY", "ASEQ"),
  disp_cols = c("BMRKR1", "AESEV")
)

main_footer(lsting) <- c(main_footer(lsting), ref_fns)

lsting

