 library(Biobase)
 library(GEOquery)
 library(limma)
 
 
 gset1 <- getGEO("GSE10072" ,GSEMatrix = TRUE)
 gset2 <- getGEO("GSE7670",GSEMatrix = TRUE)
 
class(gset1)
 esets = list(gset1,gset2)
 class(esets)#list
 merging = merge(gset1,gset2)
 class(merging) #data frame
 merging[1:15,1:15]

 