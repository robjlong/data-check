USE DataCheck
GO
--------------------------------------------------------------------------------------------------
--	Yesterday's Invoiced Dollar Amount Check
--	Single Metric
--------------------------------------------------------------------------------------------------
USE WorldWideImporters
GO	
SELECT SUM(invLn.ExtendedPrice) [Value]
FROM   [Sales].[Invoices] inv
       JOIN Sales.InvoiceLines invLn ON invLn.InvoiceID = inv.InvoiceID
WHERE  InvoiceDate = '2013-01-18';
GO

USE WorldWideImporters_PSE
GO	
SELECT SUM(invLn.ExtendedPrice) [Value]
FROM   [Sales].[Invoices] inv
       JOIN Sales.InvoiceLines invLn ON invLn.InvoiceID = inv.InvoiceID
WHERE  InvoiceDate = '2013-01-18';
GO

USE WorldWideImportersDW
GO	
SELECT SUM([Total Including Tax]) [Value]
FROM [Fact].[Sale]
WHERE [Invoice Date Key] = '2013-01-18';
GO

--------------------------------------------------------------------------------------------------
--	Total Transaction Amount By Transaction Type
--	Metric By Type [GroupName]
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
--	We've got to UNION both Supplier & Customer Transactions to tie out to the fact table
--------------------------------------------------------------------------------------------------
USE WorldWideImporters;
GO
SELECT   tye.TransactionTypeName [GroupName]
       , SUM(t.TransactionAmount) + 1 [Value]
FROM     Sales.CustomerTransactions t
         JOIN [Application].TransactionTypes tye ON tye.TransactionTypeID = t.TransactionTypeID
GROUP BY tye.TransactionTypeName
UNION
SELECT   tye.TransactionTypeName [GroupName]
       , SUM(t.TransactionAmount) [Value]
FROM     Purchasing.SupplierTransactions t
         JOIN [Application].TransactionTypes tye ON tye.TransactionTypeID = t.TransactionTypeID
GROUP BY tye.TransactionTypeName;


--------------------------------------------------------------------------------------------------
--	We've got to UNION both Supplier & Customer Transactions to tie out to the fact table
--------------------------------------------------------------------------------------------------
USE WorldWideImporters_PSE;
GO
SELECT   tye.TransactionTypeName [GroupName]
       , SUM(t.TransactionAmount) + 1 [Value]
FROM     Sales.CustomerTransactions t
         JOIN [Application].TransactionTypes tye ON tye.TransactionTypeID = t.TransactionTypeID
GROUP BY tye.TransactionTypeName
UNION
SELECT   tye.TransactionTypeName [GroupName]
       , SUM(t.TransactionAmount) [Value]
FROM     Purchasing.SupplierTransactions t
         JOIN [Application].TransactionTypes tye ON tye.TransactionTypeID = t.TransactionTypeID
GROUP BY tye.TransactionTypeName;
GO

USE WorldWideImportersDW;
GO
SELECT   typ.[Transaction Type] [GroupName]
       , SUM(t.[Total Including Tax]) [Value]
FROM     Fact.[Transaction] t
         JOIN Dimension.[Transaction Type] typ ON typ.[Transaction Type Key] = t.[Transaction Type Key]
GROUP BY typ.[Transaction Type];
GO
