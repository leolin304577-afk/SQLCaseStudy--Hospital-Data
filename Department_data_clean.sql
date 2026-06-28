

/* Data Cleaning Department Table */

CREATE TABLE dim_department_clean (
    DepartmentID VARCHAR(20) PRIMARY KEY,
    DepartmentName VARCHAR(100),
    DepartmentCategory VARCHAR(100),
    Specialization VARCHAR(100),
    HOD VARCHAR(30)
);

INSERT INTO dim_department_clean (
    DepartmentID,
    DepartmentName,
    DepartmentCategory,
    Specialization,
    HOD
)
SELECT
    DepartmentID,
    DepartmentName,
    DepartmentCategory,
    Specialization,
    HOD
FROM Dim_Department d
WHERE d.DepartmentCategory IS NOT NULL;

select * from dim_department_clean
