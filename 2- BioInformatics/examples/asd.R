library(GEOquery)
gse <- getGEO('GSE30272',GSEMatrix=TRUE)
gse
class(gse)

#Buradan bireylere ait metadata, gen ekspresyon matrisi, ve gen-probeset eslesmesini
#bulabilecegimiz bir feature verisi olusturalim:

metadata = pData(gse$GSE30272_series_matrix.txt.gz)
exprmat = exprs(gse$GSE30272_series_matrix.txt.gz)
featdata = fData(gse$GSE30272_series_matrix.txt.gz)

#Bazi bilgileri kullanmayacagiz, bu yuzden verisetinin sadece belli sutunlarini aliyorum:

metadata = metadata[,c(1,2,10:17)]
featdata = featdata[,c(1,6,7,8)]


#.rds objesi olarak kaydetmek icin:
saveRDS(exprmat, 'C:/Users/dgn/Desktop/deneme/data/data/expressionmatrix.rds')
saveRDS(featdata, 'C:/Users/dgn/Desktop/deneme/data/data/featuredat.rds')
saveRDS(metadata, 'C:/Users/dgn/Desktop/deneme/data/data/metadata.rds')

#.csv dosyasi olarak kaydetmek icin
write.csv(exprmat,'C:/Users/dgn/Desktop/deneme/data/expressionmatrix.csv')
write.csv(featdata,'C:/Users/dgn/Desktop/deneme/data/featuredat.csv')
write.csv(metadata,'C:/Users/dgn/Desktop/deneme/data/metadata.csv')