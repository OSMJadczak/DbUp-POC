ALTER PROCEDURE [ProcToAlter] @ItemName VARCHAR(50), @Prc DECIMAL (9,2)
AS
UPDATE Items SET Price = @Prc WHERE ItemName = @ItemName
GO