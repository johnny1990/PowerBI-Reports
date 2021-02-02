SELECT top 1000 ss.InvoiceID, sc.CustomerName, sc.BillToCustomerID,ss.InvoiceDate, so.OrderID, ss.ReturnedDeliveryData,
sil.Quantity, sil.UnitPrice, (sil.Quantity* sil.UnitPrice) as Price_Total, avg(sil.Quantity* sil.UnitPrice/2) as avgq from Sales.Invoices ss 

inner join Sales.Orders so on ss.OrderID = so.OrderID
inner join Sales.Customers sc on sc.CustomerID = sc.CustomerID
inner join Sales.InvoiceLines sil on ss.InvoiceID = sil.InvoiceID

where ss.InvoiceID < 100 
and (sil.Quantity* sil.UnitPrice) < 100
group by ss.InvoiceID, sc.CustomerName, sc.BillToCustomerID,ss.InvoiceDate, so.OrderID, ss.ReturnedDeliveryData,
sil.Quantity, sil.UnitPrice, (sil.Quantity* sil.UnitPrice) 
having avg(sil.Quantity* sil.UnitPrice/2) between 20 and  30
order by ss.InvoiceID asc
