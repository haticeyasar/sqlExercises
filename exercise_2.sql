--INNER JOIN
---Her ürünün adını ve hangi tedarikçiye (supplier) ait olduğunu listele.
select p.ProductName,s.CompanyName from Products p 
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID 

select * from Suppliers
select * from Products

---Her siparişi alan çalışanın adı soyadıyla birlikte sipariş ID’sini getir.

select o.OrderID,e.FirstName+' '+e.LastName as calisanAdSSoyad from Orders o
inner join Employees e ON o.EmployeeID = e.EmployeeID

select * from Orders
select * from Employees

--LEFT JOIN
--Tüm çalışanları ve varsa aldıkları siparişleri göster (çalışan adı + sipariş ID)
select o.OrderID,e.FirstName+' '+e.LastName as calisanAdSSoyad from Employees e
left join Orders o ON e.EmployeeID = o.EmployeeID


--Sipariş vermemiş müşterilerin adlarını (CompanyName) listele.

SELECT c.CompanyName  FROM Customers c 
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
where o.OrderID is null

--Tüm ürünleri ve varsa kaç siparişte kullanıldıklarını getir.

SELECT p.ProductName,count(od.OrderID) as siparisSayisi from Products p
LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
group by ProductName

--RGHT JOIN
--Tüm siparişleri ve varsa müşteri bilgilerini getir.(left joın sağladı)

SELECT o.OrderID,c.CompanyName FROM Orders o
RIGHT JOIN Customers c ON o.CustomerID = c.CustomerID

SELECT o.OrderID, c.CompanyName 
FROM Orders o
LEFT JOIN Customers c ON o.CustomerID = c.CustomerID

-- FULL OUTER JOIN
--Hem LEFT JOIN, hem RIGHT JOIN’in birleşimidir.
--Her iki tablonun da tüm verileri gelir, eşleşme yoksa NULL.
--Tüm müşterileri ve tüm siparişleri (eşleşse de eşleşmese de) getir.

SELECT o.OrderID,c.CompanyName 
FROM Customers c 
FULL OUTER JOIN Orders o ON c.CustomerID = o.CustomerID

-- Kendi Kendine JOIN (Self Join)
--Her çalışanın bağlı olduğu yöneticinin ad-soyadını göster.

SELECT e1.FirstName+' '+e1.LastName as calisan,
       e2.FirstName+' '+e2.LastName as yonetici 
FROM Employees e1
LEFT JOIN Employees e2 ON e1.ReportsTo = e2.EmployeeID

select * from Employees

--Her ürünün adı ve ait olduğu kategori adını getir.

select p.ProductName,c.CategoryName from Products p
LEFT JOIN Categories c ON p.CategoryID = c.CategoryID

--Sipariş detaylarında geçen her ürünün adıyla birlikte sipariş ID’sini listele.

SELECT od.OrderID,p.ProductName FROM Products p
LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID

--Her sipariş detayını ve eşleşen ürün adını listele 

SELECT od.OrderID,p.ProductName FROM [Order Details] od
LEFT JOIN Products p ON od.ProductID = p.ProductID

--EXISTS, içindeki alt sorgu en az bir satır döndürüyorsa TRUE, yoksa FALSE döner.
---Siparişi olan müşterileri getir.

SELECT CompanyName 
FROM Customers c
WHERE EXISTS (
    SELECT 1 FROM Orders o 
    WHERE o.CustomerID = c.CustomerID )

--Siparişi olmayan müşterileri NOT EXISTS kullanarak getir.

SELECT CompanyName
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1 FROM Orders o 
    WHERE o.CustomerID = c.CustomerID )

--Kategori adı 'Beverages' olan ürünlerden en az birini sipariş etmiş müşterilerin şirket adını getir.

SELECT CompanyName
FROM Customers c 
WHERE EXISTS(
    SELECT 1 FROM Orders o
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    JOIN Categories cd ON p.CategoryID = cd.CategoryID
    WHERE o.CustomerID = c.CustomerID
    and cd.CategoryName='Beverages'
)

--Siparişi olan çalışanların ad ve soyadını getir.

SELECT FirstName,LastName
FROM Employees e
WHERE EXISTS(
    SELECT 1 FROM Orders o
    WHERE o.EmployeeID = e.EmployeeID
)

--Ürünlerinden en az biri sipariş edilmiş tedarikçilerin şirket adlarını getir.

SELECT CompanyName
FROM Suppliers s
WHERE EXISTS(
    SELECT 1 FROM Products p
    JOIN [Order Details] od ON p.ProductID = od.ProductID
    WHERE p.SupplierID = s.SupplierID 
)

--Hiçbir ürünü sipariş edilmemiş tedarikçilerin şirket adını getir.

SELECT CompanyName
FROM Suppliers s 
WHERE NOT EXISTS(
    SELECT 1 FROM Products p
     JOIN [Order Details] od ON p.ProductID = od.ProductID
     WHERE p.SupplierID = s.SupplierID
)

--En az bir ürünü bulunan kategorilerin adını getir.

SELECT CategoryName
FROM Categories c
WHERE EXISTS(
    SELECT 1 FROM Products p
    WHERE p.CategoryID = c.CategoryID
)

---Hiç ürünü olmayan kategorilerin adını getir.
SELECT CategoryName
FROM Categories c
WHERE NOT EXISTS(
    SELECT 1 FROM Products p
    WHERE p.CategoryID = c.CategoryID
)

--JOIN örnek

--Her ürünün adını ve tedarikçi şirket adını getir.

SELECT p.ProductName,s.CompanyName FROM Products p
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID

--Her siparişin ID’si ve siparişi veren müşterinin adı

SELECT o.OrderID,c.ContactName FROM Orders o
LEFT JOIN Customers c ON o.CustomerID = c.CustomerID

--Her siparişi alan çalışanın adı ve sipariş tarih

SELECT e.FirstName+' '+e.LastName as calisanAdSSoyad ,O.OrderDate FROM Orders o 
LEFT JOIN Employees e ON o.EmployeeID = e.EmployeeID

--Her sipariş detayındaki ürünün adı ve miktarı

SELECT p.ProductName,od.Quantity FROM [Order Details] od 
LEFT JOIN Products p ON od.ProductID = p.ProductID

--Her çalışanın adı ve bağlı olduğu yöneticisinin adını getir.

SELECT e1.FirstName+' '+e1.LastName as calisanAdSoyadi,
       e2.FirstName+' '+e2.LastName as yonetici
       FROM Employees e1
       LEFT JOIN Employees e2 ON e1.ReportsTo = e2.EmployeeID

--Her çalışanın aldığı toplam sipariş sayısını ve adını göster

SELECT count(o.OrderID) as siparisSayisi,e.FirstName+' '+e.LastName as calisanAdSoyadi
FROM Employees e
LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.FirstName,e.LastName

--Siparişlerin toplam tutarını ve müşterinin adını göster

SELECT o.OrderID,c.CompanyName
,SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))AS ToplamTutar FROM Orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
INNER JOIN Customers c ON c.CustomerID = o.CustomerID
group by o.OrderID,c.CompanyName

--Her çalışanın, yöneticisinin adını ve kaç kişiye bağlı olduğunu göster

SELECT e2.FirstName+' '+e2.LastName as yonetici,
count(e1.EmployeeID) as calisanSayisi
FROM Employees e1
LEFT JOIN Employees e2 ON e1.ReportsTo = e2.EmployeeID
GROUP BY e2.EmployeeID,e2.FirstName,e2.LastName

--Her kategorideki ürün sayısını listele.

SELECT c.CategoryName,COUNT(p.ProductID) as ürünSayisi
FROM Categories c
INNER JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName

--group  by + having + joın
--Yalnızca 10’dan fazla ürünü olan kategorileri getir.

select c.CategoryName,count(p.ProductID) as urunSayisi
FROM Categories c
INNER JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY (c.CategoryName)
HAVING count(p.ProductID) >10

--Fiyat ortalaması 40’tan fazla olan kategorileri getir.

select c.CategoryName,avg(p.Unitprice) as ortalama
FROM Products p
INNER JOIN Categories c ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName
HAVING  avg(p.UnitPrice)> 40

--JOIN + GROUP BY + HAVING + SUM
--Her çalışanın aldığı siparişlerin toplam tutarı 10.000'den büyükse, o çalışanı listele.

select e.EmployeeID,sum(od.UnitPrice*od.Quantity*(1-od.Discount)) as toplamTutar
FROM [Order Details] od
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
GROUP BY e.EmployeeID
HAVING sum(od.UnitPrice*od.Quantity*(1-od.Discount)) > 10000

--Yalnızca 5’ten fazla sipariş almış çalışanların ad, soyad ve sipariş sayısını getir.

select e.FirstName,e.LastName,count(o.OrderID) as siparisSayisi
FROM Employees e 
INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID,e.FirstName,e.LastName
HAVING count(o.OrderID) > 5

--Toplam tutarı 2000’den fazla olan müşterilerin adını ve toplam harcamasını getir.

SELECT c.CompanyName,SUM(od.UnitPrice*od.Quantity*(1-od.Discount)) as toplamTutar
FROM [Order Details] od
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Customers c ON c.CustomerID = o.CustomerID
GROUP BY CompanyName
HAVING SUM(od.UnitPrice*od.Quantity*(1-od.Discount)) > 2000

--Her siparişte geçen ürünlerin adı ve ait olduğu kategori adı

SELECT p.ProductName,c.CategoryName,count(distinct od.OrderID) as siparisSayisi
FROM Products p 
INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
INNER JOIN Categories c ON c.CategoryID = p.CategoryID
GROUP BY p.ProductName,c.CategoryName


--Fiyat ortalaması 50’nin üzerinde olan tedarikçilerin adını ve ortalama fiyatı getir.
--products-supplier

SELECT s.CompanyName,avg(p.UnitPrice) AS ortalama
FROM Products p
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
GROUP BY s.CompanyName
HAVING avg(p.UnitPrice) > 50

--Toplam ürün sayısı 7’den az olan kategorileri ve ürün sayısını getir.
SELECT c.CategoryName, count(distinct p.ProductID) as ürünSayisi
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
HAVING count(distinct p.ProductID) < 7
