select od.OrderID,p.ProductName, ct.CategoryName, s.CompanyName, o.ShipRegion,c.ContactName,
(od.Quantity * od.UnitPrice)- od.Discount/100 * (od.Quantity * od.UnitPrice) as Cost,
YEAR(o.OrderDate) as Year,FORMAT(o.OrderDate, 'MMMM')as Month

into #Temp
from [Order Details] od 

inner join Products p on p.ProductID = od.ProductID
inner join Categories ct on p.CategoryID = p.CategoryID
inner join Suppliers s on p.SupplierID = s.SupplierID
inner join Orders o on od.OrderID = o.OrderID
inner join Customers c on o.CustomerID = c.CustomerID

where
o.OrderDate = OrderDate
and ShipRegion IS NOT NULL
order by 
od.OrderID
--group by

select * from #Temp
drop table #Temp

