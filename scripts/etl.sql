
INSERT INTO dbo.DimDate (
    DateKey, FullDate, DayOfMonth, DayOfWeek, WeekOfYear,
    MonthNumber, MonthName, Quarter, YearNumber, IsWeekend
)
SELECT DISTINCT
    CONVERT(INT, FORMAT(EventDate, 'yyyyMMdd')),
    CAST(EventDate AS DATE),
    DAY(EventDate),
    DATEPART(WEEKDAY, EventDate),
    DATEPART(WEEK, EventDate),
    MONTH(EventDate),
    DATENAME(MONTH, EventDate),
    DATEPART(QUARTER, EventDate),
    YEAR(EventDate),
    CASE WHEN DATEPART(WEEKDAY, EventDate) IN (1,7) THEN 1 ELSE 0 END
FROM dbo.SafetyEvents
WHERE EventDate IS NOT NULL;

go

select * from dbo.DimDate;


INSERT INTO dbo.DimLocation (City, State, Country)
SELECT DISTINCT
    City, State, Country
FROM dbo.SafetyEvents
WHERE City IS NOT NULL OR State IS NOT NULL OR Country IS NOT NULL;


select * from dbo.DimLocation;


INSERT INTO dbo.DimEventType (EventType)
SELECT DISTINCT EventType
FROM dbo.SafetyEvents
WHERE EventType IS NOT NULL;


INSERT INTO dbo.DimPhaseOfFlight (PhaseOfFlight)
SELECT DISTINCT PhaseOfFlight
FROM dbo.SafetyEvents
WHERE PhaseOfFlight IS NOT NULL;


INSERT INTO dbo.DimSubsystem (SubsystemAffected)
SELECT DISTINCT SubsystemAffected
FROM dbo.SafetyEvents
WHERE SubsystemAffected IS NOT NULL;



INSERT INTO dbo.DimRootCause (RootCauseCategory)
SELECT DISTINCT RootCauseCategory
FROM dbo.SafetyEvents
WHERE RootCauseCategory IS NOT NULL;

INSERT INTO dbo.DimEventSource (Detector, ReportType, Mode)
SELECT DISTINCT
    Detector,
    ReportType,
    Mode
FROM dbo.SafetyEvents
WHERE Detector IS NOT NULL
   OR ReportType IS NOT NULL
   OR Mode IS NOT NULL;



  INSERT INTO dbo.FactSafetyEvent (
    ReportID,
    DateKey,
    EventTypeKey,
    LocationKey,
    PhaseKey,
    SubsystemKey,
    RootCauseKey,
    EventSourceKey,
    TailNumber,
    SerialNumber,
    FatalInjuryCount,
    SeriousInjuryCount,
    MinorInjuryCount,
    OnboardInjuryCount,
    OnGroundInjuryCount,
    TotalInjuries,
    SensorWarning,
    HydraulicPressureDrop,
    EngineTempDeviation,
    ElectricalLoadSpike,
    SeverityScore,
    IsCriticalEvent,
    Narrative,
    Synopsis,
    ContributingFactors,
    PrimaryProblem,
    Result,
    DetectionTime
)
SELECT
    s.ReportID,
    CONVERT(INT, FORMAT(s.EventDate, 'yyyyMMdd')) AS DateKey,

    et.EventTypeKey,
    l.LocationKey,
    p.PhaseKey,
    ss.SubsystemKey,
    rc.RootCauseKey,
    es.EventSourceKey,

    s.TailNumber,
    s.SerialNumber,
    s.FatalInjuryCount,
    s.SeriousInjuryCount,
    s.MinorInjuryCount,
    s.OnboardInjuryCount,
    s.OnGroundInjuryCount,
    s.TotalInjuries,
    s.SensorWarning,
    s.HydraulicPressureDrop,
    s.EngineTempDeviation,
    s.ElectricalLoadSpike,
    s.SeverityScore,

    LTRIM(RTRIM(s.IsCriticalEvent)),

    s.Narrative,
    s.Synopsis,
    s.ContributingFactors,
    s.PrimaryProblem,
    s.Result,
    s.WhenDetected
FROM dbo.SafetyEvents s
LEFT JOIN dbo.DimEventType et ON s.EventType = et.EventType
LEFT JOIN dbo.DimLocation l ON s.City = l.City AND s.State = l.State AND s.Country = l.Country
LEFT JOIN dbo.DimPhaseOfFlight p ON s.PhaseOfFlight = p.PhaseOfFlight
LEFT JOIN dbo.DimSubsystem ss ON s.SubsystemAffected = ss.SubsystemAffected
LEFT JOIN dbo.DimRootCause rc ON s.RootCauseCategory = rc.RootCauseCategory
LEFT JOIN dbo.DimEventSource es ON s.Detector = es.Detector AND s.ReportType = es.ReportType AND s.Mode = es.Mode
WHERE 
    s.ReportID IS NOT NULL 
    AND LTRIM(RTRIM(s.ReportID)) <> '';


ALTER TABLE dbo.FactSafetyEvent
ALTER COLUMN IsCriticalEvent VARCHAR(10) NULL;
