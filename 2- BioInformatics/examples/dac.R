#"character"
x = 'a'
x
class(x)
#"numeric"
x = 3
x
class(x)
#"integer"
x = 3L
x
class(x)
#Vektor
x = c(1, 2, 3)
x


mylist = list(1, 2, TRUE, 'a')
mylist


a <- 1:2
b <- 3:4
c <- 5:6

x = cbind.data.frame(a,b,c)
x



y = cbind(a,b,c)
y
rownames(y) = c('satir1','satir2')



a = c("elma", "muz", "elma", "armut", "muz")
a
class(a)


a = factor(c("elma", "muz", "elma", "armut", "muz"))
a
levels(a)


#Data frame
x = data.frame(id = c(1,2,3,4),
               isim = c('ali','veli','ayse','fatma'),
               ogrenci = c(T,T,F,T))
x
class(x)
x$isim[3]  # ayse sonucu doner