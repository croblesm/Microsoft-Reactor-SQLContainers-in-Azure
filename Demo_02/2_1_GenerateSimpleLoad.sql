--------------------------------------------------------------------------------- 
-- Generate simple load with random data from master
---------------------------------------------------------------------------------

-- Random data
USE MASTER
GO
SELECT table_name, 1.0 + floor(14 * RAND(convert(varbinary, newid()))) magic_number 
    FROM information_schema.tables;
GO 1000