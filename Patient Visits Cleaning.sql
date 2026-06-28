
/* Data Cleaning (Patient Visits Table)
Merge all yearly visit tables (2020-2025) into one consolidated PatientVisits table */

create table PatientVisits(
VisitID varchar(20),
PatientID varchar(20),
DoctorID varchar(20),
DepartmentID varchar(20),
DiagnosisID varchar(20),
TreatmentID varchar(20),
PaymentMethodID varchar(20),
VisitDate date,
VisitTime time(7),
DischargeDate date,
BillAmount decimal(18,2),
InsuranceAmount decimal(18,2),
SatisfactionScore int,
WaitTimeMinutes int
)

insert into PatientVisits(
VisitID ,
PatientID,
DoctorID,
DepartmentID,
DiagnosisID,
TreatmentID,
PaymentMethodID,
VisitDate,
VisitTime,
DischargeDate,
BillAmount,
InsuranceAmount,
SatisfactionScore,
WaitTimeMinutes)
select * from PatientVisits_2022_2023
Union ALL
select * from PatientVisits_2020_2021
Union ALL 
select * from PatientVisits_2024
Union All select * from PatientVisits_2025