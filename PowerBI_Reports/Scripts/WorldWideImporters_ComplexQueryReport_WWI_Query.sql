use WideWorldImporters
--Base select
select  si.InvoiceID,so.OrderID,si.InvoiceDate,so.OrderDate,sc.CustomerName, si.BillToCustomerID, si.ContactPersonID,
sbg.BuyingGroupName,si.TotalChillerItems,si.TotalDryItems, sct.TaxAmount as CustomerTransactionsAmount, sc.ValidFrom, 
sc.ValidTo, sil.UnitPrice, sil.Quantity,
CASE WHEN sil.Quantity < 5 THEN 'Low Stock'
     WHEN sil.Quantity BETWEEN 5 AND 50 THEN 'Sufficient Stock'
	 WHEN sil.UnitPrice > 50 THEN 'Full stock'
	 ELSE 'Over '
	 END AS Stock,
sil.UnitPrice * sil.Quantity as TotalPrice, avg(sil.UnitPrice * sil.Quantity/2) 
as AVGCompute,
CASE WHEN sil.UnitPrice > 200 THEN 'High Price'
     WHEN sil.UnitPrice BETWEEN 100 AND 200 THEN 'Mid Price'
	 WHEN sil.UnitPrice < 100 THEN 'Low Price'
	 END AS UnitTypePrice
INTO #temporary_table_1
from Sales.Invoices si 
inner join Sales.Orders so on si.OrderID = so.OrderID
inner join Sales.Customers sc on si.CustomerID = sc.CustomerID
inner join Sales.InvoiceLines sil on si.InvoiceID = sil.InvoiceID
left join  Sales.SpecialDeals ssd on ssd.CustomerID = sc.CustomerID
inner join Sales.CustomerTransactions sct on si.InvoiceID = sct.InvoiceID
inner join Sales.OrderLines sol on  so.OrderID = sol.OrderID
left join Sales.BuyingGroups sbg on sc.BuyingGroupID = sbg.BuyingGroupID
where so.OrderDate between '2013-01-01' and '2016-05-31' and sil.UnitPrice > 100 
and sbg.BuyingGroupID IS NOT NULL and si.TotalChillerItems+si.TotalDryItems > 2
group by si.InvoiceID,si.InvoiceDate, si.CustomerID,si.BillToCustomerID, si.ContactPersonID,so.OrderID,
so.OrderDate,sc.CustomerName, sc.ValidFrom, sc.ValidTo, sil.UnitPrice, sil.Quantity,sct.TaxAmount,
si.TotalChillerItems,si.TotalDryItems, sbg.BuyingGroupName
having avg(sil.UnitPrice * sil.Quantity)> 100 and count(si.TotalDryItems) BETWEEN 2 and 5
order by si.InvoiceDate asc, TotalPrice desc

--case 1
select InvoiceID,OrderID,InvoiceDate,OrderDate,CustomerName, BillToCustomerID, ContactPersonID,
BuyingGroupName,TotalChillerItems,TotalDryItems, CustomerTransactionsAmount, ValidFrom, 
ValidTo, UnitPrice, Quantity, UnitPrice * Quantity as TotalPrice, AVGCompute
	 into #temporary_table_2
	 from #temporary_table_1 
	 where Stock ='Low Stock'
	 
--case 2
select InvoiceID,OrderID,InvoiceDate,OrderDate,CustomerName, BillToCustomerID, ContactPersonID,
BuyingGroupName,TotalChillerItems,TotalDryItems, CustomerTransactionsAmount, ValidFrom, 
ValidTo, UnitPrice, Quantity, UnitPrice * Quantity as TotalPrice, AVGCompute
	 into #temporary_table_3
	 from #temporary_table_1
	 where Stock ='Sufficient Stock'
	 
--case 3
select InvoiceID,OrderID,InvoiceDate,OrderDate,CustomerName, BillToCustomerID, ContactPersonID,
BuyingGroupName,TotalChillerItems,TotalDryItems, CustomerTransactionsAmount, ValidFrom, 
ValidTo, UnitPrice, Quantity, UnitPrice * Quantity as TotalPrice, AVGCompute
	 into #temporary_table_4
	 from #temporary_table_1
	 where Stock ='Full stock'
	
	--create temp table final
	create table #temporary_table_final
	(InvoiceID int,
	OrderID int ,
	InvoiceDate date ,
	OrderDate date ,
	CustomerName nvarchar(max),
	BillToCustomerID int,
	ContactPersonID int,
	BuyingGroupName nvarchar(max),
	TotalChillerItems int ,
	TotalDryItems int ,
	CustomerTransactionsAmount decimal,
	ValidFrom datetime2, 
	ValidTo datetime2, 
	UnitPrice decimal, Quantity int ,
    TotalPrice decimal,
	AVGCompute int
	)

insert into #temporary_table_final 
select * from #temporary_table_2

insert into #temporary_table_final 
select * from #temporary_table_3

insert into #temporary_table_final 
select * from #temporary_table_4



select * from #temporary_table_final 
order by InvoiceID asc

--drop temp tables
drop table #temporary_table_1
drop table #temporary_table_2
drop table #temporary_table_3
drop table #temporary_table_4
drop table #temporary_table_final