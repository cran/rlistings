testthat::test_that("Column labels are the same", {
  ## listings var labels don't get mucked up by topleft machinery #262
  lsting <- as_listing(anl, key_cols = c("USUBJID")) %>%
    add_listing_col("ARM")

  testthat::expect_identical(var_labels(anl), var_labels(lsting))

  matform <- matrix_form(lsting)

  testthat::expect_identical(
    matform$strings[1:3, 1, drop = TRUE],
    c("Unique", "Subject", "Identifier")
  )
  testthat::expect_identical(
    matform$strings[1:3, 2, drop = TRUE],
    c("Description", "Of", "Planned Arm")
  )
})


testthat::test_that("listings work well with different formats and attributes", {
  # (1) Error with NA values in numeric column when apply format
  anl_tmp <- anl
  var_labels(anl_tmp) <- var_labels(ex_adsl)[c("USUBJID", "ARM", "BMRKR1")]
  anl_tmp$BMRKR1[1:3] <- NA

  lsting <- as_listing(anl_tmp, key_cols = c("ARM", "USUBJID")) %>%
    add_listing_col("ARM") %>%
    add_listing_col("USUBJID") %>%
    add_listing_col("BMRKR1", format = "xx.xx")

  main_title(lsting) <- "main title"
  subtitles(lsting) <- c("sub", "titles")
  main_footer(lsting) <- "main footer"
  prov_footer(lsting) <- "provenance"

  mat <- matrix_form(lsting)
  testthat::expect_identical(
    unname(mat$strings[2, 3, drop = TRUE]),
    "NA"
  )

  ## this tests that the format is applied correctly
  testthat::expect_identical(
    unname(mat$strings[3, 3, drop = TRUE]),
    format_value(lsting$BMRKR1[2], "xx.xx")
  )

  testthat::expect_identical(main_title(lsting), "main title")
  testthat::expect_identical(main_title(lsting), main_title(mat))

  testthat::expect_identical(subtitles(lsting), c("sub", "titles"))
  testthat::expect_identical(subtitles(lsting), subtitles(mat))

  testthat::expect_identical(main_footer(lsting), "main footer")
  testthat::expect_identical(main_footer(lsting), main_footer(mat))

  testthat::expect_identical(prov_footer(lsting), "provenance")
  testthat::expect_identical(prov_footer(lsting), prov_footer(mat))

  testthat::expect_error(
    {
      main_title(lsting) <- 1L
    },
    "value for main_title .*class: integer$"
  )

  testthat::expect_error(
    {
      main_title(lsting) <- c("lol", "silly")
    },
    "value for main_title .*got vector of length 2"
  )

  testthat::expect_error(
    {
      subtitles(lsting) <- 1L
    },
    "value for subtitles .*class: integer$"
  )

  testthat::expect_error(
    {
      main_footer(lsting) <- 1L
    },
    "value for main_footer .*class: integer$"
  )

  testthat::expect_error(
    {
      prov_footer(lsting) <- 1L
    },
    "value for prov_footer .*class: integer$"
  )

  main_title(lsting) <- NULL
  testthat::expect_identical(main_title(lsting), character())
})

testthat::test_that("Content of listings supports newlines", {
  ## newline support #16

  mydf <- data.frame(col1 = c(1, 1, 2), col2 = c("hi\nthere", "what", "who"))
  var_labels(mydf) <- c("column\n1", "column 2")
  mylst <- as_listing(mydf, names(mydf), key_cols = "col1")

  mpf <- matrix_form(mylst)

  testthat::expect_identical(
    mpf$strings[1:2, 1, drop = TRUE],
    c("column", "1")
  )

  rdf <- make_row_df(mylst)

  testthat::expect_identical(
    rdf$self_extent,
    c(2L, 1L, 1L)
  )
})

testthat::test_that("regression test for keycols being lost due to `head()`", {
  ## causing #41
  rlst <- as_listing(mtcars,
    key_cols = c("gear", "carb"),
    disp_cols = "qsec"
  )

  testthat::expect_identical(
    dim(head(rlst, 5)),
    c(5L, ncol(mtcars))
  )
})


testthat::test_that("column inclusion and ordering stuff", {
  ## key columns must be left-most k columns (#36)
  lsting <- as_listing(
    df = ex_adae,
    disp_cols = c("USUBJID", "AGE", "SEX", "RACE", "ARM", "AEDECOD", "AESEV", "AETOXGR"),
    key_cols = c("ARM", "USUBJID", "AETOXGR")
  )

  mpfh <- matrix_form(head(lsting))
  exp <- mpfh$strings[1:4, 1:4]
  dimnames(exp) <- NULL
  testthat::expect_equal(
    exp,
    matrix(
      c(
        "Description of Planned Arm",
        "Unique Subject Identifier",
        "Analysis Toxicity Grade", "Age",
        "A: Drug X",
        "AB12345-BRA-1-id-134",
        "2", "47",
        "", "",
        "", "47",
        "", "",
        "3", "47"
      ),
      byrow = TRUE, nrow = 4
    )
  )
  ## key cols don't need to be repeated in disp_cols
  lsting2 <- as_listing(
    df = ex_adae,
    disp_cols = c("AGE", "SEX", "RACE", "AEDECOD", "AESEV"),
    key_cols = c("ARM", "USUBJID", "AETOXGR")
  )

  testthat::expect_true(identical(lsting, lsting2))

  ## display cols default to everything thats not a key col
  lsting3 <- as_listing(df = ex_adae, key_cols = c("USUBJID", "ARM"))
  testthat::expect_identical(
    listing_dispcols(lsting3),
    c("USUBJID", "ARM", setdiff(names(ex_adae), c("USUBJID", "ARM")))
  )

  ## non_disp_cols causes columns to be excluded
  lsting4 <- as_listing(
    df = ex_adae, key_cols = c("USUBJID", "ARM"),
    non_disp_cols = c("RACE", "AESEV")
  )
  testthat::expect_identical(
    listing_dispcols(lsting4),
    c("USUBJID", "ARM", setdiff(
      names(ex_adae),
      c("USUBJID", "ARM", "RACE", "AESEV")
    ))
  )
  testthat::expect_error(
    as_listing(
      df = ex_adae, key_cols = c("USUBJID", "ARM"),
      non_disp_cols = c("ARM", "RACE", "AESEV")
    ),
    "Key column also listed in non_disp_cols"
  )
  testthat::expect_error(
    as_listing(
      df = ex_adae, key_cols = c("USUBJID", "ARM"),
      disp_cols = c("AEDECOD", "AETOXGR"),
      non_disp_cols = c("RACE", "AESEV")
    ),
    "Got non-null values for both disp_cols and non_disp_cols"
  )

  ## no-keycols is supported #73
  lsting3 <- as_listing(
    df = ex_adae,
    key_cols = NULL
  )
  testthat::expect_silent({
    str <- toString(lsting3)
  })
})
