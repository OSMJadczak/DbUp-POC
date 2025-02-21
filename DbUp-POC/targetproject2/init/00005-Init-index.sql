USE test
GO

CREATE INDEX Idx1
ON Items ([Id], [ItemName])

CREATE INDEX [IndexToDrop]
ON [Items] ([Id], [ItemName])

CREATE INDEX [IndexToRename]
ON [Items] ([Id], [ItemName])