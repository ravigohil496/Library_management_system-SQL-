SELECT * FROM issued_status;
SELECT * from books;
SELECT * FROM branch;
SELECT * from employee;
SELECT * from members;
SELECT * from return_status;


--Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books(isbn,book_title,category,rental_price,status,author,publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')

--Task 2: Update an Existing Member's Address

UPDATE members
set member_address='123 oak street'
where member_id='c103';

--Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
 

 DELETE from issued_status
 WHERE   issued_id =   'IS121';

 --Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

 SELECT * FROM issued_status
WHERE issued_emp_id = 'E101'

--Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

select issued_emp_id, count(*)
from issued_status
group by issued_emp_id
having count(issued_emp_id)>1

--Task 7. Retrieve All Books in a Specific Category:
SELECT * from books
where category='History';

--Task 8: Find Total Rental Income by Category:
select sum(b.rental_price),b.category,count(*)
from issued_status a join books b on b.isbn = a.issued_book_isbn
group by category;  

-- Task 9 List Members Who Registered in the Last 180 Days:

SELECT member_id
from members
where reg_date>=DATEADD(DAY, -180, CAST(GETDATE() AS DATE));

--Task 10: List Employees with Their Branch Manager's Name and their branch details::

SELECT 
e1.*,
b.*,e2.emp_id as manager
from employee e1 join branch b on e1.branch_id=b.branch_id
join employee e2 on e2.emp_id=b.manager_id;

--Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:
with price as(
select * 
from books
where rental_price>7

)
select * from price;

--Task 12: Retrieve the List of Books Not Yet Returned

SELECT * from issued_status a
left join return_status b
on a.issued_id=b.return_id
where b.return_id IS Null;


--Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

SELECT m.member_id , m.member_name ,
		b.book_title,
		i.issued_date,
		 DATEDIFF(DAY, i.issued_date, GETDATE()) AS over_dues_days

FROM issued_status i join members m ON i.issued_member_id=m.member_id
JOIN books b ON i.issued_book_isbn=b.isbn
LEFT JOIN 
    return_status AS rs
    ON rs.issued_id = i.issued_id
WHERE 
    rs.return_date IS NULL
    AND
    DATEDIFF(DAY, i.issued_date, GETDATE()) > 30
ORDER BY 1;