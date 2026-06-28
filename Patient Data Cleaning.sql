

/* Data Cleaning (Patient Table) */

create table dim_patient_clean(
PatientID varchar(20) primary key,
FullName varchar(120),
Gender varchar(10),
DOE date,
State varchar(50),
City varchar(50))

insert into dim_patient_clean (
PatientID,FullName,Gender,DOE,State,City)

select p.PatientID,
Upper(LEFT(LTRIM(RTRIM(p.FirstName)),1)) + Lower(SUBSTRING(LTRIM(RTRIM(p.FirstName)),2,LEN(LTRIM(RTRIM(p.FirstName))))) + ' ' +
Upper(LEFT(LTRIM(RTRIM(p.LastName)),1)) + Lower(SUBSTRING(LTRIM(RTRIM(p.LastName)),2,LEN(LTRIM(RTRIM(p.LastName))))) as FullName,
case when p.Gender = 'M' then 'Male'
when p.Gender = 'F' then 'Female'
else p.Gender
end as Gender,
p.DOB,
PARSENAME(replace(p.CityStateCountry,',','.'),3) as City,
PARSENAME(replace(p.CityStateCountry,',','.'),2) as State,
PARSENAME(replace(p.CityStateCountry,',','.'),1) as Country
from Dim_Patient p 
where p.FirstName is not NULL