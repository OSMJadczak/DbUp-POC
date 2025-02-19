ALTER PROCEDURE [ProcToAlter] @ItemName VARCHAR(100), @Price DECIMAL(7,2)
AS
UPDATE Items SET Price = @Price * 2 WHERE ItemName = @ItemName
GO