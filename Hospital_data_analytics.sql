
/* For each doctor, count how many distinct patients they have treated */


select pv.DoctorID,
dd.FirstName + ' ' + dd.LastName as DoctorName,
count(distinct(dp.PatientID)) as num_distinct_patients
 from PatientVisits pv
join Dim_Patient dp on pv.PatientID = dp.PatientID
join Dim_Doctor dd on pv.DoctorID = dd.DoctorID
group by pv.DoctorID,dd.FirstName,dd.LastName
order by num_distinct_patients desc

/* show the revenue split by each payment method, along with total visits */

select PaymentMethod,SUM(pv.BillAmount) as total_rev, count(*) as total_visits
from PatientVisits pv
join Dim_PaymentMethod pm on pv.PaymentMethodID = pm.PaymentMethodID
group by pm.PaymentMethod;


/* Group patients by age and calculate average bill amount for each age band */

with Agegroup as (
select pv.VisitID, pv.BillAmount,
case 
when DATEDIFF(year,dp.DOB,PV.VisitDate) < 18 THEN '0-17'
when DATEDIFF(year,dp.DOB,PV.VisitDate) between 18 and 35 THEN '18-35'
when DATEDIFF(year,dp.DOB,PV.VisitDate) between 36 and 55 THEN '36-55'
else '56+'
end as AgeGroup
from PatientVisits pv 
join Dim_Patient dp on pv.PatientID = dp.PatientID)

select Agegroup.agegroup,
count(*) as total_visits,
AVG(AgeGroup.BillAmount) as average_bill_amount from Agegroup
group by agegroup
order by agegroup asc

/* Find Total Revenue and number of visits for each department */

select dd.DepartmentName,
SUM(pv.BillAmount) as Total_Revenue,
count(*) as Total_Visits
from PatientVisits pv 
join dim_department_clean dd on pv.DepartmentID = dd.DepartmentID
group by dd.DepartmentName
order by Total_Revenue desc, Total_Visits desc


/* Rank departments based on their total revenue within each department category */

select DD.DepartmentCategory,dd.DepartmentName,
SUM(pv.BillAmount) as Total_Revenue,
RANK() over ( partition by dd.DepartmentCategory order by SUM(pv.BillAmount) desc) as Ranking
from PatientVisits pv 
join dim_department_clean dd on pv.DepartmentID = dd.DepartmentID
group by dd.DepartmentCategory,dd.DepartmentName

/* for each department, find average satisfication score and average wait time */

select d.DepartmentName,
cast(AVG(p.SatisfactionScore) as decimal(10,2))as AverageSatisficationScore,
cast(AVG(p.WaitTimeMinutes) as decimal(10,2)) as AverageWaitTime
from PatientVisits p 
join Dim_Department d on p.DepartmentID = d.DepartmentID
group by d.DepartmentName

/* Compare Total number of hospital vists during weekdays and weekends */

Set DateFirst 7;
with weekday_table as (
select * ,
CASE 
           WHEN DATEPART(weekday, VisitDate) IN (1, 7) THEN 'Weekend'
           ELSE 'Weekday'
       END AS DayType
from PatientVisits)

select DayType,
count(*) as TotalVisits
from weekday_table
group by DayType
order by DayType desc

/* For each month, calculate total visits and cumulative total of visits */
with TotalVisitsTable as(
select Year(VisitDate)as VisitYear, 
Month(VisitDate)as VisitMonth,
count(*) as TotalVisits
from PatientVisits
group by Year(VisitDate), Month(VisitDate)
)

select *,
SUM(TotalVisits) over(order by VisitYear asc,VisitMonth asc rows between unbounded preceding and current row) as CumulativeVisits
from TotalVisitsTable

/* Find the doctors with the highest average satisfaction score (minimum 100 visits) */

select d.DoctorID,
d.FirstName + ' ' + d.LastName as DoctorName,
count(*) as TotalVisit ,
cast(AVG(p.SatisfactionScore) as decimal(10,2)) as AverageSatisfactionScore
from PatientVisits p 
join Dim_Doctor d on p.DoctorID = d.DoctorID
group by d.DoctorID,d.FirstName + ' ' + d.LastName
having count(*) >= 100

/* Identify the most commonly prescribed treatment for each diagnosis */

with TreatmentDiagnosis as(
select D.DiagnosisName,
DT.TreatmentName,
count(*) as TreatmentCount,
RANK() OVER (PARTITION BY DT.TreatmentName order by count(*) desc) as Ranking
from PatientVisits p
join Dim_Diagnosis d on p.DiagnosisID = d.DiagnosisID
join Dim_Treatment dt on p.TreatmentID = dt.TreatmentID
group by d.DiagnosisName, DT.TreatmentName)

select * from TreatmentDiagnosis
where Ranking = 1
order by DiagnosisName asc

