USE test;
GO;

CREATE OR ALTER PROCEDURE ProcToDelete @ItemName VARCHAR(100), @Price DECIMAL(7,2)
AS
UPDATE Items SET Price = @Price WHERE ItemName = @ItemName