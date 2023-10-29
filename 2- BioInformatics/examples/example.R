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
saveRDS(exprmat, 'C:/Users/dgn/Desktop/deneme/data/expressionmatrix.rds')
saveRDS(featdata, 'C:/Users/dgn/Desktop/deneme/data/featuredat.rds')
saveRDS(metadata, 'C:/Users/dgn/Desktop/deneme/data/metadata.rds')

#.csv dosyasi olarak kaydetmek icin
write.csv(exprmat,'C:/Users/dgn/Desktop/deneme/data/expressionmatrix.csv')
write.csv(featdata,'C:/Users/dgn/Desktop/deneme/data/featuredat.csv')
write.csv(metadata,'C:/Users/dgn/Desktop/deneme/data/metadata.csv')



expr = read.csv(file = 'C:/Users/dgn/Desktop/deneme/data/expressionmatrix.csv',
                header = T,
                row.names = 1)

expr[1:6,1:4]
class(expr) # data.frame

#matrise dönüştürme işlemi yapıyoruz.

expr = as.matrix(expr)
class(expr)
expr[1:6, 1:4]


#matrisimizin boyutlarina bakalim

nrow(expr) # satir sayisi
ncol(expr) # sutun sayisi

dim(expr) # bu hem satır hem sutun birlikte gösterir dimensiondan gelir.
hist(expr)
class(expr)

library(ggplot2)

mydat = reshape2::melt(expr)
ggplot(mydat, aes(x = value)) + geom_histogram()

#TASARIM 1
ggplot(mydat, aes(x = value)) + geom_histogram(color = 'gray60', bins = 50) + xlab('Probeset Expression') +
  ylab('Count') +
  theme_bw()

#ilk birkac bireyin gen anlatim profillerine bakalim
boxplot(expr[,1:5])

#ilk bir kac gen icin cizmek isteyecek olursak :
boxplot(t(expr[1:10,]))

#Aynisini ggplot ile yapalim:
mydat = reshape2::melt(expr[,1:5])
head(mydat)

#TASARIM 2
ggplot(mydat,aes(x = Var2, y = value)) +
  geom_boxplot(outlier.size = 0.01, outlier.color = 'gray', color = 'darkred') +
  theme_bw() +
  xlab(NULL) + ylab('Probeset Expression Value')

mydat = reshape2::melt(expr[1:5,])
head(mydat)

#TASARIM 3
ggplot(mydat,aes(x = Var1, y = value)) +
  geom_boxplot(outlier.shape=NA, color = 'darkred') +
  geom_jitter(size = 0.5, width = 0.1) +
  theme_bw() +
  xlab(NULL) + ylab('Probeset Expression Value')


#---------------------ProbesetID - Gen eslestirmesi-------------------------

genedata = read.csv('C:/Users/dgn/Desktop/deneme/data/featuredat.csv')
genedata[1:3,]
class(genedata) #data.frame olarak geldi.
genedata$ID[1:10]

genedata$Gene_Symbol[1:10]


#ID isimlendirme örneği
x = setNames(c(1:3),c('bir','iki','uc'))
x
x[2]
x['uc']

#Bizim Gen tablomuzdaki düzenleme
genemap = setNames(genedata$Gene_Symbol,genedata$ID)
genemap[1:5]

head(genemap)

#Genmap'in yedeğini alıyoruz.
expr_yedek = expr