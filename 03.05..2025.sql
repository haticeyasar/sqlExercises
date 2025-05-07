--ürünnllerimin kategori adını,ürün adını ve tedarikçi adını getiriniz

select p.ProductName,c.CategoryName,s.CompanyName from Products p
join Categories c ON p.CategoryID = c.CategoryID
join Suppliers s ON s.SupplierID = p.SupplierID

--speedy epress taraffından taşınan ve categoryıd si 3 olan ürün adları nedir
select distinct p.ProductName from Products p
join Categories c ON c.CategoryID = p.CategoryID
join [Order Details] od ON od.ProductID = p.ProductID
join Orders o ON o.OrderID = od.OrderID
join Shippers s ON o.ShipVia = s.ShipperID
where s.CompanyName = 'Speedy Express' and p.CategoryID='3'

select * from Shippers

--adında leka geçen tedarikçimden aldığım ürünlerden toplam ne kadar kazandım

select distinct s.CompanyName, sum(od.Quantity*od.UnitPrice*(1-od.Discount)) as ToplamTutar from Products p
join [Order Details] od ON p.ProductID = od.ProductID
join Suppliers s ON p.SupplierID = s.SupplierID
where s.CompanyName LIKE '%leka%'
group by s.CompanyName

--tüm çalışanlarımı ve varsa rapor verdikleri üstlerini getirinniz

select e1.FirstName+' '+e1.LastName as calisan,
e2.FirstName+' '+e2.LastName as yonetici
 from  Employees e1 
left join Employees e2 ON e1.ReportsTo = e2.EmployeeID

--categorylerine göre toplam stok miktarı nedir

select  c.CategoryName, sum(p.UnitsInStock) as stokMiktarı from Products p
join Categories c ON p.CategoryID = c.CategoryID
group by c.CategoryName

--çalışanlar kaç yaşında işe başaldı

select DATEDIFF(YEAR,BirthDate,HireDate)as YAS from Employees

--her bir kargo firması ille toplamda kaç sipariş taşınmıştır
select s.CompanyName,count(o.OrderID) as siparisSayisi from Orders o
join Shippers s ON s.ShipperID = o.ShipVia
group by s.CompanyName

--her çalışanım(ad soyad) toplamda ne kadarlık satış yapmıştır

select e.FirstName,e.LastName,sum(od.Quantity*od.UnitPrice*(1-od.Discount)) as toplamTutar from [Order Details] od
join Orders o ON od.OrderID = o.OrderID
join Employees e ON o.EmployeeID = e.EmployeeID
group by e.FirstName,e.LastName

--federal shipping tarafından taşınan ve nancy tarafından onaylanann siparişler nedir

select o.OrderID from Orders o
join Employees e ON e.EmployeeID = o.EmployeeID
join Shippers s ON o.ShipVia = s.ShipperID
where s.CompanyName = 'Federal Shipping' and e.FirstName = 'Nancy'

--adet olarak en çok sipariş verilen ürün adı nedir

select top 1 p.ProductName,sum(od.Quantity) as siparisSayisi from Products p
join [Order Details] od ON p.ProductID = od.ProductID
group by p.ProductName
order by  siparisSayisi desc

---speedy express ile taşınmış ürünnlerimden fiyatı max olan ürünün satıldığı siparişlerle hangi çallışanım ilgilenmiştir

select distinct e.FirstName from Products p
join [Order Details] od ON p.ProductID = od.ProductID
join Orders o ON o.OrderID = od.OrderID
join Shippers s ON s.ShipperID = o.ShipVia
join Employees e ON e.EmployeeID = o.EmployeeID
where s.CompanyName ='Speedy Express' and p.UnitPrice =(select max(UnitPrice) from Products)


--geciken siparişlerime ortalama ne kadar ödedim

select avg(od.Quantity*od.UnitPrice*(1-od.Discount)) as OrtalamaFiyat from [Order Details] od 
join Orders o ON od.OrderID = o.OrderID
where o.RequiredDate < o.ShippedDate

--sipariş sayısı 70 den ffazla olann çalışanlarımı sipariş sayılarına göre sıralayın

select e.FirstName,e.LastName ,count(o.OrderID)as siparisSayisi from Employees e 
join Orders o ON o.EmployeeID  = e.EmployeeID
group by e.FirstName,e.LastName 
having count(o.OrderID) > 70
order by siparisSayisi desc

--en yaşlı 3 çalışan tarafındann alınan siparişlerimn topllam tutarı

select sum(od.Quantity*od.UnitPrice*(1-od.Discount)) as toplamTutar from Employees e 
join Orders o ON o.EmployeeID = e.EmployeeID
join [Order Details] od ON od.OrderID = o.OrderID
where e.EmployeeID in(
    select top 3 EmployeeID from Employees
    where BirthDate is not null
    order by BirthDate
    )

--tedarikçisininn posta kodu 33007 olan,kategorisi seafood dışında kategoriler olan siparişlerimle hangi çalışanlarım ilgilenmiştir

select distinct e.FirstName,E.LastName from Employees e
join Orders o ON o.EmployeeID = e.EmployeeID
join [Order Details] od ON o.OrderID = od.OrderID
join Products p ON od.ProductID = p.ProductID
join Suppliers s ON p.SupplierID = s.SupplierID
join Categories c ON c.CategoryID = p.CategoryID
where c.CategoryName != 'Seafood' and s.PostalCode = '33007'