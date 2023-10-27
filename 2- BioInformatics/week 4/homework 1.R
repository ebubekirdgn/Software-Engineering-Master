 library(Biobase)
 library(GEOquery)
 library(limma)
 
 
 gset1 <- getGEO("GSE10072" ,GSEMatrix = TRUE)
 gset2 <- getGEO("GSE7670",GSEMatrix = TRUE)
 

 esets = list(gset1,gset2)
 merging = merge(gset1,gset2)
 merging[1:15,1:15]

 