--adı a ile başlayanlar
select * from Employees where FirstName LIKE 'a%'

--adı n ile bitenler
select * from Employees where FirstName LIKE '%n'

--soyadında t geçenler
select * from Employees where LastName LIKE '%t%'

---TOP n: en tepedeki n adet satırı alır
--ilk 3 kategori
select top 3 * from Categories
select top 3 CategoryID,CategoryName from Categories


--ORDER BY:Sıralamak
--ascending(asc): az dan çok a sıralar.Metinsel,tarihsel ya da sayısal olarak sıralar.
--descending(desc): çok dan az a sıralar.Metinsel,tarihsel ya da sayısal olarak sıralar.

--NOT: Deffaultta ASC olarak sıralanır.

---ürün fiyatlarını pahalıdan ucuza sırala.
select top 3 ProductID,ProductName,UnitPrice from Products 
order by UnitPrice desc

--aynı adda ama 3 farklı soyadda 3 kişi ekle

insert Employees(LastName,FirstName) values('Can','Burak')
insert Employees(LastName,FirstName) values('Mutlu','Burak')
insert Employees(LastName,FirstName) values('Tekin','Burak')

select EmployeeID,TitleOfCourtesy,HireDate,FirstName,BirthDate,LastName from Employees
order by 4,6 desc

select EmployeeID,TitleOfCourtesy,HireDate,FirstName,BirthDate,LastName from Employees
order by FirstName,LastName desc

--aggregate fonk.8toplam ffonk.,toplamalı fonk)
--count(*/kolon adı)
--nullable kolon vverilirse dogru sonuc elde edilmez
select * from Employees
select COUNT(*) elemansayısı from Employees
select COUNT(EmployeeID) elemansayısı from Employees
select COUNT(Region) elemansayısı from Employees

--sum(kolon adı): toplama işlemi yapabilleceğin bir kolon olmalı.Tarihsel yada metinsel kolonlarda çalışmaz.

select sum(EmployeeID) from Employees
select sum(LastName) from Employees ---hata verir,metin

--avg(kolon adı): ortalama işlem yapabileceğim birkollon olmalı.Tarihsel yada metinsel kolonlarda çalışmaz.
select avg(EmployeeID) from Employees
select avg(LastName) from Employees ---hata verir,metin

--min,max: enn küçük değer, enn büyük değer
--en pahalı ürünümün fiyatı

select max(UnitPrice) from Products

select * from Products where UnitPrice in(select max(UnitPrice) from Products)

select min(UnitPrice) from Products

--GROUP BY: kolonn ya da kolonlarına göre ilgili tabloyu gruplandırma.Group by işlemlerinde genelde aggregate fonk çalışırız
--Müşterilerimi ülkelerine göre gruplayınız,her ülkede kaç müşteri var çoktan aza sırala
select Country,count(*) [MüsteriSayisi] from Customers
group by Country
order by [MüsteriSayisi] desc

--birim fiyatı 40 üzerinde olan ürünleri categorylerine göre gruplayınız.

select CategoryID,count(*) [ürün sayisi] from Products
where UnitPrice > 40
group by CategoryID

--subquery: iç içe sorgu
--fiyatı,ortalama birim fiyatın üzerinde olan ürünlerim nelerdir
select * from Products
where UnitPrice > (select avg(UnitPrice) from Products)

--seafood kategorisindeki ürünlerimi hangi müşterilerime satmışın
select CategoryID from Categories where CategoryName = 'Seafood'

select ProductID from Products where CategoryID = (select CategoryID from Categories where CategoryName = 'Seafood')

select OrderID from [Order Details] where ProductID in(select ProductID from Products 
where CategoryID = (select CategoryID from Categories where CategoryName = 'Seafood'))

select CustomerID from Orders where OrderID in(select OrderID from [Order Details] where ProductID in(select ProductID from Products 
where CategoryID = (select CategoryID from Categories where CategoryName = 'Seafood')))

--SON HALİ
select DISTINCT(CompanyName) from Customers where CustomerID in(select CustomerID from Orders where OrderID in(select OrderID from [Order Details] where ProductID in(select ProductID from Products 
where CategoryID = (select CategoryID from Categories where CategoryName = 'Seafood'))))

--Romero y tomillo müşterime sipariş oluşturan çalışanların ad soyadı(orders-customers-ordersDetails)
select CustomerID from Customers where CompanyName ='Romero y tomillo'

select OrderID from Orders where CustomerID = (select CustomerID from Customers where CompanyName ='Romero y tomillo')

select EmployeeID from Orders where OrderID in (select OrderID from Orders 
where CustomerID = (select CustomerID from Customers where CompanyName ='Romero y tomillo'))

select FirstName,LastName from Employees where EmployeeID in (select EmployeeID from Orders where OrderID in (select OrderID from Orders 
where CustomerID = (select CustomerID from Customers where CompanyName ='Romero y tomillo')))

--HAVING: aggregate fonk. bağlı olarak bir filtreleme söz konuysa having kullanıllır.
---Eğer aggregate baglı eleme yoksa where ile having aynı islemi yapmıs gibi olur.

-- toplam tutar bilgisi 2500 ile 3000 arasında olan siparislerimi coktan aza sıralama

select OrderID,sum(UnitPrice*Quantity*(1-Discount)) as kazanc 
from [Order Details]
group by OrderID
having sum(UnitPrice*Quantity*(1-Discount)) between 2500 and 3000
order by kazanc desc

--her kategorideki ürün sayısı dikkate alındığında 5 ya da 6 olanları getirin(Products)
select CategoryID,count(*) adet from Products
group by CategoryID
having count(*) in(5,6)

---her siparişteki toplam sipariş adet miktarı 100 den fazla olanları getiriniz.

select OrderID,sum(Quantity) as toplamSiparis from [Order Details]
group by OrderID
having sum(Quantity)> 100

--anne,margaret,robert tarafından onaylanan ve madrid de kargolanan siparişllerim hangi müşterilerime aittir

select CustomerID from Orders
where ShipCity ='Madrid'
and EmployeeID in(select EmployeeID from Employees where FirstName in('Anne','Margaret','Robert'))

--Brezilyalı müşterilerimden siparişi en yüksek tutara ulaşan sipariş ne kadar tutmuştur ve id bilgisi nedir

select top 1 OrderID,sum(UnitPrice*Quantity*(1-Discount)) as kazanc from [Order Details]
where OrderID in (select OrderID from Orders where CustomerID in(select CustomerID from Customers where Country = 'Brazil'))
group by OrderID
order by kazanc desc

--en uzun süredir çalışan ilk 3 çalışan

select top 3 FirstName,LastName  from Employees
where Hiredate is not NULL
order by Hiredate asc

--japoncayı akıcı konuşan çalışann kimdir

select FirstName+' '+LastName as calisanAdi from Employees where Notes LIKE '%japan%'

--her kadın çallışanın kaç adet sipariş oluşturduğunu bulunuz.

select EmployeeID,count(OrderID) as siparisSayisi from Orders where EmployeeID in(select EmployeeID from Employees where TitleOfCourtesy = 'Mrs.' or TitleOfCourtesy = 'Ms.' )
group by EmployeeID

----fiyatı,ortalama birim fiyatın altında kalan ürünlerimi satmadıgım müsterilerim kimdir product-orderdetail-order-customer
select CustomerID from Customers where CustomerID not in(select distinct CustomerID from Orders 
where OrderID in(select OrderID from [Order Details] where UnitPrice < (select avg(UnitPrice) from [Order Details])))

--şişede bulunan ürünlerimin ad,id,fiyat bilgillerini getirin
select ProductName,ProductID,UnitPrice from Products
where QuantityPerUnit LIKE '%bottle%'

--ingiliz ve kadın calisanlarim kimlerdir 
select FirstName,LastName from Employees 
where Country='UK' and (TitleOfCourtesy='Mrs.' or TitleOfCourtesy='Ms.')

---calisanlarimi ülkelerine gruplayiniz
select country,count(*) as calisanSayisi from Employees
group by country


--rapor veren calisanlarim kimlerdir?, ad,soyad ve rapor verdiği kişinin ad,soyad bilgisini getiriniz.

SELECT  e1.FirstName + ' ' + e1.LastName AS RaporVeren,
    (SELECT e2.FirstName + ' ' + e2.LastName 
     FROM Employees e2 
     WHERE e2.EmployeeID = e1.ReportsTo) AS RaporAlici
FROM  Employees e1
WHERE   e1.ReportsTo IS NOT NULL;

--1)Doğum tarihi 1960’tan önce olan çalışanlarının ad soyad bilgilerini getir.
select FirstName,LastName from Employees where YEAR(BirthDate) < '1960'

select FirstName,LastName from Employees where BirthDate < '1960-01-01'

--2)‘USA’ ülkesindeki müşterilerin kaç farklı şehirde bulunduğunu bul.

select count(distinct(City)) from Customers
where Country = 'USA'

--3) Fiyatı, en pahalı ürünün yarısından düşük olan ürünlerin adını ve fiyatını getir.

select ProductName,UnitPrice from Products
where UnitPrice < (select (max(UnitPrice)/2) from Products)
order by UnitPrice desc

--4)Çalışanlar arasında doğum tarihi en eski olan çalışanın ad soyadını getir.
SELECT FirstName,LastName FROM Employees
WHERE Birthdate =( SELECT TOP 1 BirthDate FROM Employees ORDER BY BirthDate ASC )

SELECT FirstName, LastName 
FROM Employees
WHERE BirthDate = (SELECT MIN(BirthDate) FROM Employees)

SELECT FirstName, LastName 
FROM Employees
WHERE YEAR(BirthDate) = ( SELECT MIN(YEAR(BirthDate)) FROM Employees)

--5) Ürün adında ‘ch’ geçen ürünleri alfabetik sırayla yazdır.

SELECT * FROM Products WHERE ProductName LIKE '%ch%'
order by ProductName asc

--6)Müşterilerimden adı 'T' harfiyle başlayanların kaç tanesi Londra'da yaşıyor?
select COUNT(*) from Customers
where City  = 'London' and ContactName LIKE 'T%'

--7) Fiyatı 30 ile 50 arasında olan ürünlerden kaç tanesi "cans" (teneke) içeriyor?
select count(*) as adet from Products
where QuantityPerUnit LIKE '%cans%' 
and UnitPrice between 30 and 50

--8)Kategori adı 'Beverages' olan ürünlerimin ortalama fiyatı nedir
select avg(UnitPrice) as ortalama from Products where ProductID in 
(SELECT ProductID from Products WHERE CategoryID = (SELECT CategoryID FROM Categories WHERE CategoryName ='Beverages'))

select avg(UnitPrice) as ortalama from Products
 where CategoryID = (SELECT CategoryID FROM Categories WHERE CategoryName ='Beverages')

 --9)Sipariş tutarı (UnitPrice * Quantity * (1 - Discount)) 5000 TL'den büyük olan sipariş sayısı kaçtır?
select count(*) as SiparisSayisi from [Order Details]
where OrderID in
 (select OrderID from [Order Details]
 group by OrderID
 having sum(UnitPrice * Quantity * (1 - Discount))> 5000)

 --10)Soyadında 's' harfi geçen ve doğum tarihi 1960 sonrası olan çalışanlarının ad-soyad bilgilerini getir.

 SELECT FirstName,LastName from Employees 
 where LastName LIKE '%s%' and BirthDate >'1960-01-01'

 --11)Almanya'da yaşayan müşterilerimden adı "A" harfiyle başlayanların ad, şehir ve ülke bilgilerini getir.

 select ContactName,City,Country from Customers 
 where Country ='Germany' and ContactName LIKE 'A%'

 --12)Kategori adı 'Condiments' olan ürünlerin fiyatı 15'in üstündeyse, ad ve fiyat bilgisini getir.
select ProductName,UnitPrice from Products where CategoryID =
 (Select CategoryID from Categories where CategoryName = 'Condiments') and UnitPrice > 15
 
 --13)1994 yılında işe başlayan çalışanlarının ad, soyad ve işe başlama tarihini getir.
 select FirstName,LastName,HireDate from Employees
 where Year(HireDate) = '1994'

 --14)En az 10 adet ürün içeren siparişlerin ID'lerini getir.

 select OrderID from [Order Details] 
 group by OrderID
 having sum(Quantity) >= 10

 --15) Fiyatı ortalamanın üstünde olup 'boxes' içeren ürünlerin adını, fiyatını ve paket bilgisini getir.

 select ProductName,UnitPrice, QuantityPerUnit from Products
 where UnitPrice > (select avg(UnitPrice) from Products)
 and QuantityPerUnit LIKE '%boxes%'

 --16)Ortalama birim fiyatın altında olan ürünlerden hiç satın almamış müşterilerin adlarını getir.
 
 select ContactName from Customers where CustomerID not in(
 select CustomerID from Orders where OrderID in
 (select OrderID from [Order Details]
  where UnitPrice < (select avg(UnitPrice) from Products)))

  --17)En erken işe başlayan çalışanın ad-soyad bilgisi

  select top 1 FirstName,LastName from Employees
  order by HireDate asc

--18)Kategori adı 'Seafood' olan ürünleri alan müşterilerim kimlerdir? (şirket adıyla göster)
select CompanyName from Customers where CustomerID in(
select CustomerID from Orders where OrderID in(
select OrderID from [Order Details] where ProductID in(
select ProductID  from Products where CategoryID in(
select CategoryID from Categories 
where CategoryName = 'Seafood'))))

--19) Ernst Handel’ müşterisine sipariş alan çalışanların ad ve soyadını getir.

select FirstName,LastName from Employees 
where EmployeeID in(
    select EmployeeID from Orders where CustomerID = (
    select CustomerID from Customers where CompanyName ='Ernst Handel'
))

select * from Customers

---20)Her kadın çalışanın kaç sipariş oluşturduğunu hesapla.
select EmployeeID as CalisanId,count(OrderID) as siparisSayisi from Orders where EmployeeID in(
select EmployeeID from Employees
where TitleOfCourtesy='Mrs.' or TitleOfCourtesy='Ms.')
group by EmployeeID

---21) Hiçbir siparişinde fiyatı ortalamanın üstünde ürün olmayan müşterilerin adlarını (ContactName) getir.

select ContactName from Customers 
where CustomerID in(
    select distinct CustomerID from Orders where OrderID not in(
        select OrderID from [Order Details] 
        where UnitPrice > (select avg(UnitPrice) from [Order Details])
    )
)
--22)‘France’ ülkesindeki müşterilere sipariş alan çalışanların ad ve soyad bilgilerini getir.

select FirstName,LastName from Employees
where EmployeeID in(
    select EmployeeID from Orders where OrderID in(
        select OrderID from Orders where CustomerID in(
            select CustomerID from Customers
            where Country ='France')
    )
)


--23)‘Confections’ kategorisindeki ürünleri almayan müşterilerin şirket adını getir.

select CompanyName from Customers Where CustomerID not in(
select CustomerID from Orders where OrderID in(
select OrderID from [Order Details] where ProductID in(
    Select ProductID from Products where CategoryID =(
select CategoryID from Categories
where CategoryName = 'Confections'))))

--24) Fiyatı ortalama birim fiyatın altında kalan ürünleri hiç almamış müşteriler

select ContactName from Customers Where CustomerID not in(
select CustomerID from Orders where OrderID in(
select OrderID from [Order Details] where ProductID in(
select ProductID from Products
where UnitPrice < (select avg(UnitPrice) from Products))))

--25)‘Seafood’ kategorisindeki ürünleri alan müşteriler

select CompanyName from Customers where CustomerID in(
select CustomerID from Orders where OrderID in(
select OrderID from [Order Details] where ProductID in( 
Select ProductID from Products where CategoryID =
(select CategoryID from Categories
where CategoryName ='Seafood'))))

---26)  'Romero y tomillo' müşterisine sipariş alan çalışanların adı soyadı

select FirstName,LastName from Employees
where EmployeeID in(
    select EmployeeID from Orders  where CustomerID in(
        select CustomerID from Customers
        where CompanyName ='Romero y tomillo'
    )
)

--27) Kadın çalışanların oluşturduğu sipariş sayısını, çalışan ad-soyadıyla birlikte göster
SELECT (Select FirstName +' '+LastName from Employees e
where e.EmployeeID = o.EmployeeID )as calisanAdSoyadi ,count(*) as siparisSayisi FROM Orders o
 where o.EmployeeID in(
select  EmployeeID from Employees 
where TitleOfCourtesy='Mrs.' or TitleOfCourtesy='Ms.'
)
group by o.EmployeeID

SELECT EmployeeID, COUNT(OrderID) AS siparisSayisi 
FROM Orders 
WHERE EmployeeID IN (
    SELECT EmployeeID 
    FROM Employees 
    WHERE TitleOfCourtesy = 'Mrs.' OR TitleOfCourtesy = 'Ms.'
)
--28)Fiyatı ortalamanın üstünde olan ürünleri hiç satın almamış müşterilerin şirket adını getir.
select CompanyName from Customers where CustomerID not in(
select CustomerID from Orders where OrderID  in(
select OrderID from [Order Details] where ProductID in(
select ProductID from Products 
where UnitPrice > (select avg(UnitPrice) from Products))))