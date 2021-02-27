use NORTHWIND

SELECT  p.ProductName,  c.CategoryName as Category,s.CompanyName as Supplier,p.UnitPrice as Price,
p.UnitsInStock, o.OrderID, (e.FirstName +' '+e.LastName) as Employee, o.ShippedDate
into #Temp
from Products p 
left join Categories c on c.CategoryID = p.ProductID
left join Suppliers s on s.SupplierID = p.SupplierID
left join [Order Details] od on od.ProductID =p.ProductID
inner join Orders o on o.OrderID = od.OrderID
inner join Employees e on o.EmployeeID = e.EmployeeID
where c.CategoryName is not null
and o.ShippedDate is not null
and p.UnitsInStock > 0
order by o.OrderID 

select * from #Temp
drop table #Temp