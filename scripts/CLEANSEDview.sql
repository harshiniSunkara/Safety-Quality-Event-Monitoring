CREATE VIEW dbo.vw_SafetyEvents AS
SELECT
    ReportID,
    LTRIM(RTRIM(EventType)) AS EventType,
    LTRIM(RTRIM(City)) AS City,
    LTRIM(RTRIM(State)) AS State,
    LTRIM(RTRIM(Country)) AS Country,
    LTRIM(RTRIM(Mode)) AS Mode,
    LTRIM(RTRIM(ReportType)) AS ReportType,
    EventDate,
    TailNumber,
    SerialNumber,
    ISNULL(FatalInjuryCount,0) AS FatalInjuryCount,
    ISNULL(SeriousInjuryCount,0) AS SeriousInjuryCount,
    ISNULL(MinorInjuryCount,0) AS MinorInjuryCount,
    ISNULL(OnboardInjuryCount,0) AS OnboardInjuryCount,
    ISNULL(OnGroundInjuryCount,0) AS OnGroundInjuryCount,
    ISNULL(TotalInjuries,0) AS TotalInjuries,
    Narrative,
    Synopsis,
    Detector,
    [WhenDetected] as  DetectionTime,
    Result,
    ContributingFactors,
    PrimaryProblem,
    SubsystemAffected,
    PhaseOfFlight,
    ISNULL(SensorWarning,0) AS SensorWarning,
    ISNULL(HydraulicPressureDrop,0) AS HydraulicPressureDrop,
    ISNULL(EngineTempDeviation,0) AS EngineTempDeviation,
    ISNULL(ElectricalLoadSpike,0) AS ElectricalLoadSpike,
    RootCauseCategory,
    SeverityScore,
    CASE WHEN IsCriticalEvent IN ('Y','Yes','1','True') THEN 'Y' ELSE 'N' END AS IsCriticalEvent
FROM SafetyEvents;
 

 



