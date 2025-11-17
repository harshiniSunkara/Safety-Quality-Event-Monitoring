CREATE TABLE SafetyEvents (
    ReportID VARCHAR(50),
    EventType VARCHAR(100),
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100),
    Mode VARCHAR(100),
    ReportType VARCHAR(100),
    EventDate DATETIME2,
    TailNumber VARCHAR(50),
    SerialNumber VARCHAR(100),
    FatalInjuryCount FLOAT,
    SeriousInjuryCount FLOAT,
    MinorInjuryCount FLOAT,
    OnboardInjuryCount FLOAT,
    OnGroundInjuryCount FLOAT,
    TotalInjuries FLOAT,
    Narrative NVARCHAR(MAX),
    Synopsis NVARCHAR(MAX),
    Detector VARCHAR(200),
    WhenDetected VARCHAR(200),
    Result VARCHAR(200),
    ContributingFactors NVARCHAR(MAX),
    PrimaryProblem VARCHAR(200),
    SubsystemAffected VARCHAR(200),
    PhaseOfFlight VARCHAR(200),
    SensorWarning INT,
    HydraulicPressureDrop FLOAT,
    EngineTempDeviation FLOAT,
    ElectricalLoadSpike FLOAT,
    RootCauseCategory VARCHAR(200),
    SeverityScore FLOAT,
    IsCriticalEvent VARCHAR(10)
);




ALTER TABLE SafetyEvents ALTER COLUMN RootCauseCategory NVARCHAR(MAX);
ALTER TABLE SafetyEvents ALTER COLUMN PrimaryProblem NVARCHAR(MAX);
ALTER TABLE SafetyEvents ALTER COLUMN ContributingFactors NVARCHAR(MAX);
ALTER TABLE SafetyEvents ALTER COLUMN Detector NVARCHAR(MAX);
ALTER TABLE SafetyEvents ALTER COLUMN WhenDetected NVARCHAR(MAX);
ALTER TABLE SafetyEvents ALTER COLUMN Result NVARCHAR(MAX);
