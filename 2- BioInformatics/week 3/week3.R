# GPL,GSM,GSE ve GDS 

#GPL ; platform kaydı,platform üretici,teknoloji türü, platform tanımı gibi bilgileri barındırır.
#GSM ; tek bir örnekle ilgili bilgileri bünyesinde barındırmaktadır.
#GSE ; veri seti kaydı olarak ifade edilir.Tüm örneklerin veri kümesi olarak ifade edilir.
#GDS ; veri kayıtlarının ve platform kayıtlarının içerdiği bilgilerden oluşan kümedir.
#GEO ; verileri çekmek içim  BiocManager::(install) kütüphanesi kurulmalıdır.

library(GEOquery)
bladder_cancer=getGEO("GDS4950")

#GetGEO ; fonksiyonu söz konusu veri kümesini bilgisayarda gecici olarak bir alana yerleştirmekte ve aynı 
# zamanda bladder_cancer isimli bir değişken oluşturulmasına imkan sağlamaktadır.

eset= GDS2eSet(bladder_cancer,do.log2 = TRUE)

eset
dim(eset)

data = exprs(eset)
head(data)
data[1:5,1:5]

kayip = nrow(which(is.na(exprs(eset)),arr.ind = TRUE))
show(kayip) # sadece boşluk sayısını görmek icin kullanılır.
veri = t(exprs(eset))
veri[1:5,1:5]
 
which(is.na(veri),arr.ind = TRUE)
veri[11,7]

modelpca = prcomp(veri)
summary(modelpca)
plot(modelpca,type="1",main="Temel Bileşenler")
 







