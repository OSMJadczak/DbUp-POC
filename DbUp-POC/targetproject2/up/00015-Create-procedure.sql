CREATE OR ALTER PROCEDURE CreatedProc @ItemName VARCHAR(100), @Price DECIMAL(7,2)
AS
UPDATE Items SET Price = @Price WHERE ItemName = @ItemName
GO