IF OBJECT_ID('dbo.DimDate') IS NOT NULL DROP TABLE dbo.DimDate;
CREATE TABLE dbo.DimDate (
    DateKey INT PRIMARY KEY,           
    FullDate DATE NOT NULL,
    DayOfMonth TINYINT NOT NULL,
    DayOfWeek TINYINT NOT NULL,
    WeekOfYear TINYINT NOT NULL,
    MonthNumber TINYINT NOT NULL,
    MonthName NVARCHAR(20) NOT NULL,
    Quarter TINYINT NOT NULL,
    YearNumber INT NOT NULL,
    IsWeekend BIT NOT NULL
);
GO

IF OBJECT_ID('dbo.DimLocation') IS NOT NULL DROP TABLE dbo.DimLocation;
CREATE TABLE dbo.DimLocation (
    LocationKey INT IDENTITY(1,1) PRIMARY KEY,
    City NVARCHAR(200) NULL,
    State NVARCHAR(200) NULL,
    Country NVARCHAR(200) NULL,
    UniqueCityStateCountry AS (
        COALESCE(City,'') + '|' + 
        COALESCE(State,'') + '|' + 
        COALESCE(Country,'')
    ) PERSISTED
);
CREATE INDEX IX_DimLocation_Unique ON dbo.DimLocation(UniqueCityStateCountry);
GO

IF OBJECT_ID('dbo.DimLocation') IS NOT NULL DROP TABLE dbo.DimLocation;
CREATE TABLE dbo.DimLocation (
    LocationKey INT IDENTITY(1,1) PRIMARY KEY,
    City NVARCHAR(200) NULL,
    State NVARCHAR(200) NULL,
    Country NVARCHAR(200) NULL,
    UniqueCityStateCountry AS (
        COALESCE(City,'') + '|' + 
        COALESCE(State,'') + '|' + 
        COALESCE(Country,'')
    ) PERSISTED
);
CREATE INDEX IX_DimLocation_Unique ON dbo.DimLocation(UniqueCityStateCountry);
GO
IF OBJECT_ID('dbo.DimEventType') IS NOT NULL DROP TABLE dbo.DimEventType;
CREATE TABLE dbo.DimEventType (
    EventTypeKey INT IDENTITY(1,1) PRIMARY KEY,
    EventType NVARCHAR(200) NULL
);
CREATE UNIQUE INDEX UX_DimEventType_EventType ON dbo.DimEventType(EventType);
GO
IF OBJECT_ID('dbo.DimPhaseOfFlight') IS NOT NULL DROP TABLE dbo.DimPhaseOfFlight;
CREATE TABLE dbo.DimPhaseOfFlight (
    PhaseKey INT IDENTITY(1,1) PRIMARY KEY,
    PhaseOfFlight NVARCHAR(200) NULL
);
CREATE UNIQUE INDEX UX_DimPhase_PhaseOfFlight ON dbo.DimPhaseOfFlight(PhaseOfFlight);
GO
IF OBJECT_ID('dbo.DimSubsystem') IS NOT NULL DROP TABLE dbo.DimSubsystem;
CREATE TABLE dbo.DimSubsystem (
    SubsystemKey INT IDENTITY(1,1) PRIMARY KEY,
    SubsystemAffected NVARCHAR(1000) NULL
);
CREATE UNIQUE INDEX UX_DimSubsystem ON dbo.DimSubsystem(SubsystemAffected);
GO
IF OBJECT_ID('dbo.DimRootCause') IS NOT NULL DROP TABLE dbo.DimRootCause;
CREATE TABLE dbo.DimRootCause (
    RootCauseKey INT IDENTITY(1,1) PRIMARY KEY,
    RootCauseCategory NVARCHAR(2000) NULL
);
CREATE UNIQUE INDEX UX_DimRootCause ON dbo.DimRootCause(RootCauseCategory);
GO
IF OBJECT_ID('dbo.DimEventSource') IS NOT NULL DROP TABLE dbo.DimEventSource;
CREATE TABLE dbo.DimEventSource (
    EventSourceKey INT IDENTITY(1,1) PRIMARY KEY,
    Detector NVARCHAR(500) NULL,
    ReportType NVARCHAR(200) NULL,
    Mode NVARCHAR(200) NULL,
    UniqueSource AS (
        COALESCE(Detector,'') + '|' + 
        COALESCE(ReportType,'') + '|' +
        COALESCE(Mode,'')
    ) PERSISTED
);
CREATE INDEX IX_DimEventSource_Unique ON dbo.DimEventSource(UniqueSource);
GO




IF OBJECT_ID('dbo.FactSafetyEvent') IS NOT NULL DROP TABLE dbo.FactSafetyEvent;
CREATE TABLE dbo.FactSafetyEvent (
    ReportID NVARCHAR(100) PRIMARY KEY,

    DateKey INT NOT NULL,
    EventTypeKey INT NULL,
    LocationKey INT NULL,
    PhaseKey INT NULL,
    SubsystemKey INT NULL,
    RootCauseKey INT NULL,
    EventSourceKey INT NULL,

    TailNumber NVARCHAR(100) NULL,
    SerialNumber NVARCHAR(200) NULL,

    FatalInjuryCount FLOAT NULL,
    SeriousInjuryCount FLOAT NULL,
    MinorInjuryCount FLOAT NULL,
    OnboardInjuryCount FLOAT NULL,
    OnGroundInjuryCount FLOAT NULL,
    TotalInjuries FLOAT NULL,

    SensorWarning INT NULL,
    HydraulicPressureDrop FLOAT NULL,
    EngineTempDeviation FLOAT NULL,
    ElectricalLoadSpike FLOAT NULL,
    SeverityScore FLOAT NULL,
    IsCriticalEvent CHAR(1) NULL,

    Narrative NVARCHAR(MAX) NULL,
    Synopsis NVARCHAR(MAX) NULL,
    ContributingFactors NVARCHAR(MAX) NULL,
    PrimaryProblem NVARCHAR(MAX) NULL,
    Result NVARCHAR(MAX) NULL,
    DetectionTime NVARCHAR(500) NULL,

    CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME()
);

-- Indexes
CREATE INDEX IX_Fact_DateKey ON dbo.FactSafetyEvent(DateKey);
CREATE INDEX IX_Fact_EventTypeKey ON dbo.FactSafetyEvent(EventTypeKey);
CREATE INDEX IX_Fact_LocationKey ON dbo.FactSafetyEvent(LocationKey);
CREATE INDEX IX_Fact_PhaseKey ON dbo.FactSafetyEvent(PhaseKey);
CREATE INDEX IX_Fact_SubsystemKey ON dbo.FactSafetyEvent(SubsystemKey);
GO


----etl

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
