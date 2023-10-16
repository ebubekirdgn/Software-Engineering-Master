# GPL,GSM,GSE ve GDS 

#GPL ; platform kaydı,platform üretici,teknoloji türü, platform tanımı gibi bilgileri barındırır.
#GSM ; tek bir örnekle ilgili bilgileri bünyesinde barındırmaktadır.
#GSE ; veri seti kaydı olarak ifade edilir.Tüm örneklerin veri kümesi olarak ifade edilir.
#GDS ; veri kayıtlarının ve platform kayıtlarının içerdiği bilgilerden oluşan kümedir.
#GEO ; verileri çekmek içim  BiocManager::(install) kütüphanesi kurulmalıdır.
  
library(GEOquery)
bladder_cancer=getGEO("GDS183")

#GetGEO ; fonksiyonu söz konusu veri kümesini bilgisayarda gecici olarak bir alana yerleştirmekte ve aynı 
# zamanda bladder_cancer isimli bir değişken oluşturulmasına imkan sağlamaktadır.

#contents=bladder_cancer[[1]]
#show(contents)


eset= GDS2eSet(bladder_cancer,do,log2 = TRUE)