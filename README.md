# SQL Database Assignment - Library Management System

This project contains a comprehensive SQL database assignment implementing a library management system for Azure MS SQL Server.

## Project Structure

```
sql/
├── scripts/
│   ├── 01_DDL_CreateTables.sql      # Table creation with constraints
│   ├── 02_DML_InsertData.sql        # Sample data insertion
│   ├── 03_Queries_Select.sql        # SELECT queries and reports
│   ├── 04_DML_UpdateDelete.sql      # UPDATE and DELETE operations
│   └── 05_DDL_Modifications.sql     # Table alterations and new tables
├── docs/
│   └── answers.txt                  # Complete answers and theory explanations
└── README.md                        # This file
```

## Database Schema

The library management system consists of five main entities:

### Authors
- **AuthorID** (Primary Key, Identity)
- **AuthorName** (NVARCHAR(100), NOT NULL)
- **DateOfBirth** (DATE)

### Publishers
- **PublisherID** (Primary Key, Identity)
- **PublisherName** (NVARCHAR(100), NOT NULL)
- **Address** (NVARCHAR(200))

### Books
- **BookID** (Primary Key, Identity)
- **Title** (NVARCHAR(200), NOT NULL)
- **AuthorID** (Foreign Key → Authors)
- **PublisherID** (Foreign Key → Publishers)
- **PublicationDate** (DATE)
- **Price** (DECIMAL(10,2), Default: 0, CHECK: > 0)
- **Genre** (NVARCHAR(500))
- **ISBN** (CHAR(13), UNIQUE)

### Borrowers
- **BorrowerID** (Primary Key, Identity)
- **BorrowerName** (NVARCHAR(100), NOT NULL)
- **Email** (NVARCHAR(100), UNIQUE)
- **Phone** (CHAR(10))

### Loans
- **LoanID** (Primary Key, Identity)
- **BookID** (Foreign Key → Books)
- **BorrowerID** (Foreign Key → Borrowers)
- **LoanDate** (DATE, Default: GETDATE())
- **ReturnDate** (DATE)

### BookCategories
- **BookID** (Foreign Key → Books)
- **Category** (NVARCHAR(100))
- **Composite Primary Key**: (BookID, Category)

## Assignment Tasks Covered

### DDL Operations (Tasks 1-4, 22-25)
1. ✅ Create all tables with specified constraints
2. ✅ Alter Borrowers table (BorrowerName NOT NULL)
3. ✅ Add UNIQUE constraint on Books.ISBN
4. ✅ Add CHECK constraint on Books.Price > 0
22. ✅ Remove Address column from Publishers
23. ✅ Drop Loans table (commented for safety)
25. ✅ Create BookCategories with composite primary key

### DML Operations (Tasks 5-9, 18-21, 24, 27-28)
5. ✅ Insert 3 Authors
6. ✅ Insert 2 Publishers
7. ✅ Insert 5 Books
8. ✅ Insert 2 Borrowers
9. ✅ Insert 3 Loans (with one NULL ReturnDate)
18. ✅ Update ReturnDate for specific loan
19. ✅ Increase price by 10% for books before 2010
20. ✅ Delete borrowers with no loans
21. ✅ Delete books priced less than 5
24. ✅ Insert loan without LoanDate (uses default)
27. ✅ Update NULL genres to "Unknown"
28. ✅ Delete loans older than one year

### Query Operations (Tasks 10-17, 26)
10. ✅ Books with price > 20
11. ✅ Currently loaned books with borrower names
12. ✅ Authors with more than 2 books
13. ✅ All books with current borrowers (LEFT JOIN)
14. ✅ All publishers with their books (LEFT JOIN)
15. ✅ Unique genres
16. ✅ Books starting with "The" or containing "SQL"
17. ✅ Five most recent loans
26. ✅ Loan count per borrower

### Database Theory (Task 29)
29. ✅ Normalization analysis (1NF, 2NF, 3NF violations and BCNF decomposition)

## Additional Theory Topics Covered

- **Self Joins**: Definition, differences from other joins, internal workings, use cases
- **Super Keys**: Definition, differences from candidate/primary/foreign keys
- **Indexing**: Purpose, functionality, clustered vs non-clustered indexes
- **Integer Primary Keys**: Why use integers instead of natural keys
- **BCNF**: Definition, differences from 3NF, when to use, examples

## How to Use

1. **Setup Database**: Run `01_DDL_CreateTables.sql` to create the schema
2. **Insert Sample Data**: Run `02_DML_InsertData.sql` to populate tables
3. **Execute Queries**: Run `03_Queries_Select.sql` to see various reports
4. **Modify Data**: Run `04_DML_UpdateDelete.sql` for data modifications
5. **Schema Changes**: Run `05_DDL_Modifications.sql` for structural changes

## Target Platform

- **Database**: Azure MS SQL Server (T-SQL)
- **Compatibility**: SQL Server 2016+
- **Features Used**: 
  - IDENTITY columns
  - DEFAULT constraints
  - CHECK constraints
  - UNIQUE constraints
  - Foreign key relationships
  - Various JOIN types
  - Aggregate functions
  - Date functions (GETDATE, DATEADD)

## Notes

- All scripts include proper error handling and informational messages
- Foreign key constraints ensure referential integrity
- Sample data is realistic and demonstrates various scenarios
- Queries cover different complexity levels from basic to advanced
- All theoretical concepts include practical examples

## Author

Created for SQL Database Design and Development coursework, demonstrating comprehensive understanding of relational database concepts, SQL DDL/DML operations, and database normalization principles.
