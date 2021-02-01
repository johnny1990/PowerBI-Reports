SELECT o.OrderID,ct.ContactName as CustomerName,e.FirstName, o.OrderDate,c.CategoryName, p.ProductName, od.UnitPrice , od.Quantity, 
SUM(CASE  WHEN o.OrderId < 10700  THEN od.UnitPrice * od.Quantity ELSE od.UnitPrice * od.Quantity END) AS Total,
AVG(ISNULL(DATEDIFF(SECOND, o.RequiredDate, o.ShippedDate),0)) AS Difference_Date_Avg 
INTO 
    #temporary_table
from Orders o
inner join [Order Details] od on od.OrderID = o.OrderID
left join Products p on p.ProductID = od.ProductID
left join Categories c on c.CategoryID = p.CategoryID
left join Customers ct on ct.CustomerID = o.CustomerID
left join Employees e on e.EmployeeID = o.EmployeeID
WHERE od.UnitPrice > 5 AND ct.City LIKE '%Albuquerque%' OR ct.City LIKE '%Versailles%'  OR  ct.City LIKE '%Madrid%'
OR ct.City LIKE '%Rio de Janeiro%' OR ct.City LIKE '%México D.F.%' OR  ct.City LIKE '%Barcelona%' 
GROUP BY o.OrderID,ct.ContactName,e.FirstName, o.OrderDate, c.CategoryName, od.ProductID , p.ProductName, od.UnitPrice , od.Quantity 
HAVING SUM(od.UnitPrice * od.Quantity) < 100
ORDER BY o.OrderID desc, od.ProductID asc

select * from #temporary_table
drop table #temporary_table
