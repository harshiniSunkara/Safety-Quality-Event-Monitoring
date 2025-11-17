CREATE VIEW dbo.vw_EventTrend AS
SELECT
    CAST(EventDate AS DATE) AS EventDay,
    DATEPART(MONTH, EventDate) AS MonthNumber,
    DATENAME(MONTH, EventDate) AS MonthName,
    DATEPART(YEAR, EventDate) AS EventYear,
    COUNT(*) AS TotalEvents,
    SUM(CASE WHEN IsCriticalEvent = 'Y' THEN 1 ELSE 0 END) AS CriticalEvents
FROM vw_SafetyEvents
GROUP BY CAST(EventDate AS DATE),
         DATEPART(MONTH, EventDate),
         DATENAME(MONTH, EventDate),
         DATEPART(YEAR, EventDate);

         go
CREATE VIEW dbo.vw_RootCause AS
SELECT
    RootCauseCategory,
    SubsystemAffected,
    COUNT(*) AS EventCount
FROM vw_SafetyEvents
GROUP BY RootCauseCategory, SubsystemAffected;


go
CREATE VIEW dbo.vw_PhaseRisk AS
SELECT
    PhaseOfFlight,
    COUNT(*) AS EventCount,
    SUM(CASE WHEN IsCriticalEvent='Y' THEN 1 ELSE 0 END) AS CriticalEvents
FROM vw_SafetyEvents
GROUP BY PhaseOfFlight;