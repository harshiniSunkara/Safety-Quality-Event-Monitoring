

BULK INSERT dbo.SafetyEvents
FROM 'C:\Users\harsh\Downloads\source_file.csv'
WITH (
    FORMAT='CSV',
    FIRSTROW=2,
    TABLOCK
);








