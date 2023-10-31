library(GEOquery)
library(ggplot2)
library(limma)
gse1009 <- getGEO("GSE1009",GSEMatrix = TRUE,getGPL = FALSE)
gse1010 <- getGEO("GSE1010",GSEMatrix = TRUE,getGPL = FALSE)

gen1 <- exprs(gse1009[[1]])
gen2 <- exprs(gse1010[[1]])

common_gene <- intersect(rownames(gen1),rownames(gen2))

common_data_gse1 <- gen1[common_gene,]
common_data_gse2 <- gen2[common_gene,]


common_gene[[1]]


# İki veri setini birleştirin
merged_data <- merge(common_data_gse1, common_data_gse2)

dim(merged_data)




