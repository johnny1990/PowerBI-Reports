use NORTHWIND

select o.OrderId,o.CustomerID,o.OrderDate,p.ProductName, o.ShippedDate ,o.ShipName, o.Freight, avg(od.UnitPrice * od.Quantity) as AverageCostPerProduct --,s.ShipperID
from Orders o 
inner join [Order Details] od on od.OrderID =o.OrderID
inner join Shippers s on s.ShipperID= o.ShipVia
inner join Products p on p.ProductID = od.ProductID
inner join Customers c on c.CustomerID = o.CustomerID
where ShipperID = 1
and ShippedDate between '1996-09-03 00:00:00.000' and '1998-05-01 00:00:00.000'
group by O.OrderID,o.CustomerID,o.OrderDate,p.ProductName, o.ShippedDate ,o.ShipName, o.Freight
having avg(od.UnitPrice * od.Quantity) > 30
order by O.OrderID asc
limit 5 
--offset 2;


