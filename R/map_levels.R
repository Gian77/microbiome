#' @title Map taxonomic levels
#' @description Map taxa between hierarchy levels.
#' @param taxa taxa to convert; if NULL then considering all taxa in the tax.table
#' @param from convert from taxonomic level 
#' @param to convert to taxonomic level
#' @param data Either a \code{\link{phyloseq}} object or its code{\link{taxonomyTable-class}} , see the \pkg{phyloseq} package.
#' @return mappings
#' @examples 
#'   tax.table <- get_hitchip_taxonomy('HITChip', 'filtered')
#'   map_levels('Akkermansia', 'L2', 'L1', tax.table)
#' @export
#' @references See citation('microbiome') 
#' @author Contact: Leo Lahti \email{microbiome-admin@@googlegroups.com}
#' @keywords utilities
map_levels <- function(taxa = NULL, from, to, data) {

  if (class(data) == "phyloseq") {
    data <- tax_table(data)
  }

  # If taxonomy table is from phyloseq, pick the data matrix separately	 
  if (class(data) == "taxonomyTable") {
    data <- tax_table(data)
  }
  
  df <- data
  
  if (from == to) {
    df <- list()
    df[[to]] <- factor(taxa)
    df <- as.data.frame(df)
    return(df)
  }

  if (is.null(taxa)) {
    taxa <- as.character(unique(df[, from]))
  }

  # From higher to lower level
  if (length(unique(df[, from])) <= length(unique(df[, to]))) {

    sl <- list()
    for (pt in taxa) {

      inds <- which(as.vector(as.character(df[, from])) == pt)
      pi <- df[inds, to]
      sl[[pt]] <- as.character(unique(na.omit(pi)))

    }
    
  } else {

    # From lower to higher level
    inds <- match(as.character(taxa), df[, from])
    omap <- df[inds, ]
    sl <- omap[,to]

  }
     
  as.vector(sl@.Data)
    
}

