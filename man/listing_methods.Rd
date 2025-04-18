% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rlistings_methods.R
\name{listing_methods}
\alias{listing_methods}
\alias{print.listing_df}
\alias{toString,listing_df-method}
\alias{[,listing_df-method}
\alias{main_title,listing_df-method}
\alias{subtitles,listing_df-method}
\alias{main_footer,listing_df-method}
\alias{prov_footer,listing_df-method}
\alias{main_title<-,listing_df-method}
\alias{subtitles<-,listing_df-method}
\alias{main_footer<-,listing_df-method}
\alias{prov_footer<-,listing_df-method}
\alias{num_rep_cols,listing_df-method}
\title{Methods for \code{listing_df} objects}
\usage{
\method{print}{listing_df}(
  x,
  widths = NULL,
  tf_wrap = FALSE,
  max_width = NULL,
  fontspec = NULL,
  col_gap = 3L,
  round_type = c("iec", "sas"),
  ...
)

\S4method{toString}{listing_df}(
  x,
  widths = NULL,
  fontspec = NULL,
  col_gap = 3L,
  round_type = c("iec", "sas"),
  ...
)

\S4method{[}{listing_df}(x, i, j, drop = FALSE)

\S4method{main_title}{listing_df}(obj)

\S4method{subtitles}{listing_df}(obj)

\S4method{main_footer}{listing_df}(obj)

\S4method{prov_footer}{listing_df}(obj)

\S4method{main_title}{listing_df}(obj) <- value

\S4method{subtitles}{listing_df}(obj) <- value

\S4method{main_footer}{listing_df}(obj) <- value

\S4method{prov_footer}{listing_df}(obj) <- value

\S4method{num_rep_cols}{listing_df}(obj)
}
\arguments{
\item{x}{(\code{listing_df})\cr the listing.}

\item{widths}{(\code{numeric} or  \code{NULL})\cr Proposed widths for the columns of \code{x}. The expected
length of this numeric vector can be retrieved with \code{ncol(x) + 1} as the column of row names
must also be considered.}

\item{tf_wrap}{(\code{flag})\cr whether the text for title, subtitles, and footnotes should be wrapped.}

\item{max_width}{(\code{integer(1)}, \code{string} or \code{NULL})\cr width that title and footer (including
footnotes) materials should be word-wrapped to. If \code{NULL}, it is set to the current print width of the
session (\code{getOption("width")}). If set to \code{"auto"}, the width of the table (plus any table inset) is
used. Parameter is ignored if \code{tf_wrap = FALSE}.}

\item{fontspec}{(\code{font_spec})\cr a font_spec object specifying the font information to use for
calculating string widths and heights, as returned by \code{\link[formatters:font_spec]{font_spec()}}.}

\item{col_gap}{(\code{numeric(1)})\cr space (in characters) between columns.}

\item{round_type}{(\code{"iec"} or \code{"sas"})\cr the type of rounding to perform. iec,
the default, peforms rounding compliant with IEC 60559 (see details), while
sas performs nearest-value rounding consistent with rounding within SAS.}

\item{...}{additional parameters passed to \code{\link[formatters:tostring]{formatters::toString()}}.}

\item{i}{(\code{any})\cr object passed to base \code{[} methods.}

\item{j}{(\code{any})\cr object passed to base \code{[} methods.}

\item{drop}{relevant for matrices and arrays.  If \code{TRUE} the result is
    coerced to the lowest possible dimension (see the examples).  This
    only works for extracting elements, not for the replacement.  See
    \code{\link[base]{drop}} for further details.
  }

\item{obj}{(\code{listing_df})\cr the listing.}

\item{value}{typically an array-like \R object of a similar class as
    \code{x}.}
}
\value{
\itemize{
\item Accessor methods return the value of the aspect of \code{obj}.
\item Setter methods return \code{obj} with the relevant element of the listing updated.
}
}
\description{
See core documentation in \link[formatters:formatters-package]{formatters::formatters-package} for descriptions of these functions.
}
\examples{
lsting <- as_listing(mtcars)
main_title(lsting) <- "Hi there"

main_title(lsting)

}
