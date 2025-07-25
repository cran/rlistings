testthat::test_that("matrix_form keeps relevant information and structure about the listing", {
  skip_if_not_installed("dplyr")
  require("dplyr", quietly = TRUE)

  my_iris <- iris %>%
    slice(c(16, 3)) %>%
    mutate("fake_rownames" = c("mean", "mean"))

  lsting <- as_listing(my_iris,
    key_cols = c("fake_rownames", "Petal.Width"),
    disp_cols = c("Petal.Length")
  )
  mat <- matrix_form(lsting) ## to match basic_listing_mfb

  # IMPORTANT: the following is coming directly from spoof matrix form for rlistings coming from {formatters}
  mat_rebuilt <- basic_listing_mf(my_iris[c("fake_rownames", "Petal.Width", "Petal.Length")],
    keycols = c("fake_rownames", "Petal.Width"), add_decoration = FALSE, fontspec = NULL
  )

  testthat::expect_equal(names(mat_rebuilt), names(mat))

  mat_rebuilt$row_info$pos_in_siblings <- mat$row_info$pos_in_siblings # not relevant in listings
  mat_rebuilt$row_info$n_siblings <- mat$row_info$n_siblings # not relevant in listings
  testthat::expect_equal(mf_rinfo(mat_rebuilt), mf_rinfo(mat))

  mat_rebuilt["page_titles"] <- list(NULL)

  testthat::expect_equal(mat, mat_rebuilt)

  testthat::expect_equal(toString(mat), toString(mat_rebuilt))


  # The same but with rownames
  lmf <- basic_listing_mf(mtcars)
  testthat::expect_equal(ncol(lmf), length(lmf$col_widths))
  testthat::expect_equal(ncol(lmf), ncol(lmf$strings))
  testthat::expect_false(mf_has_rlabels(lmf))

  rlmf <- as_listing(mtcars) %>% matrix_form() # rownames are always ignored!!!
  testthat::expect_equal(ncol(rlmf), length(rlmf$col_widths))
  testthat::expect_equal(ncol(rlmf), ncol(rlmf$strings))
  testthat::expect_false(mf_has_rlabels(rlmf))
})

test_that("matrix_form detects { or } in labels and sends meaningful error message", {
  dat <- ex_adae[1:10, ]
  dat$AENDY[3:6] <- "something {haha} something"
  lsting <- as_listing(
    dat,
    key_cols = c("USUBJID"),
    disp_cols = c("STUDYID", "AENDY")
  )
  expect_error(
    matrix_form(lsting),
    "Labels cannot contain"
  )

  # Workaround for ref_fnotes works
  levels(dat$ARM)[1] <- "A: Drug X(1)"

  # Generate listing
  lsting <- as_listing(
    df = dat,
    key_cols = c("ARM"),
    disp_cols = c("BMRKR1"),
    main_footer = "(1) adasdasd"
  )

  expect_true(grepl(toString(lsting), pattern = "\\(1\\) adasdasd"))
  expect_true(grepl(toString(lsting), pattern = "A: Drug X\\(1\\)"))
})

test_that("align_colnames can change alignment for column titles", {
  dat <- ex_adae[1:3, ]
  attr(dat$STUDYID, "label") <- "A" # For clearer alignment

  lsting <- as_listing(dat,
    key_cols = "USUBJID",
    disp_cols = "STUDYID",
    col_formatting = c("STUDYID" = fmt_config(align = "left")),
    align_colnames = TRUE
  )

  # same alignment
  mat <- matrix_form(lsting)
  expect_equal(mat$aligns[, 2], rep("left", 4))

  # post-processing changes
  align_colnames(lsting) <- FALSE
  mat <- matrix_form(lsting)
  expect_equal(mat$aligns[1, 2], "center")

  # pagination
  align_colnames(lsting) <- FALSE
  out <- paginate_listing(lsting, lpp = 4, print_pages = FALSE)
  expect_snapshot(cat(toString(out[[2]])))

  # pagination
  align_colnames(lsting) <- TRUE
  out <- paginate_listing(lsting, lpp = 4, print_pages = FALSE)
  expect_snapshot(cat(toString(out[[2]])))
})
