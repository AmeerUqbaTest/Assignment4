-- Task 1: Write DDL statements to create all tables listed above with their specified constraints
DROP TABLE IF EXISTS Loans;
DROP TABLE IF EXISTS BookCategories;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Borrowers;
DROP TABLE IF EXISTS Publishers;
DROP TABLE IF EXISTS Authors;

CREATE TABLE Authors (
    AuthorID INT IDENTITY(1,1) PRIMARY KEY,
    AuthorName NVARCHAR(100) NOT NULL,
    DateOfBirth DATE
);

CREATE TABLE Publishers (
    PublisherID INT IDENTITY(1,1) PRIMARY KEY,
    PublisherName NVARCHAR(100) NOT NULL,
    Address NVARCHAR(200)
);

CREATE TABLE Books (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    AuthorID INT NOT NULL,
    PublisherID INT NOT NULL,
    PublicationDate DATE,
    Price DECIMAL(10,2) DEFAULT 0,
    Genre NVARCHAR(500),
    ISBN CHAR(13),
    CONSTRAINT FK_Books_Authors FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID),
    CONSTRAINT FK_Books_Publishers FOREIGN KEY (PublisherID) REFERENCES Publishers(PublisherID)
);

CREATE TABLE Borrowers (
    BorrowerID INT IDENTITY(1,1) PRIMARY KEY,
    BorrowerName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100),
    Phone CHAR(10)
);

CREATE TABLE Loans (
    LoanID INT IDENTITY(1,1) PRIMARY KEY,
    BookID INT NOT NULL,
    BorrowerID INT NOT NULL,
    LoanDate DATE DEFAULT GETDATE(),
    ReturnDate DATE,
    CONSTRAINT FK_Loans_Books FOREIGN KEY (BookID) REFERENCES Books(BookID),
    CONSTRAINT FK_Loans_Borrowers FOREIGN KEY (BorrowerID) REFERENCES Borrowers(BorrowerID)
);

-- Task 2: Alter the Borrowers table to enforce that BorrowerName cannot be NULL
-- (Already enforced in CREATE TABLE statement above)

-- Task 3: Alter the Books table to enforce uniqueness on the ISBN column
ALTER TABLE Books ADD CONSTRAINT UQ_Books_ISBN UNIQUE (ISBN);

-- Task 4: Alter the Books table to add a CHECK constraint ensuring Price > 0
ALTER TABLE Books ADD CONSTRAINT CHK_Books_Price CHECK (Price > 0);

-- Task 5: Insert three sample records into the Authors table
INSERT INTO Authors (AuthorName, DateOfBirth) VALUES
('J.K. Rowling', '1965-07-31'),
('Stephen King', '1947-09-21'),
('Agatha Christie', '1890-09-15');

-- Task 6: Insert two sample records into the Publishers table
INSERT INTO Publishers (PublisherName, Address) VALUES
('Penguin Random House', '1745 Broadway, New York, NY 10019'),
('HarperCollins', '195 Broadway, New York, NY 10007');

-- Task 7: Insert five sample records into the Books table, ensuring each reference existing authors and publishers
INSERT INTO Books (Title, AuthorID, PublisherID, PublicationDate, Price, Genre, ISBN) VALUES
('Harry Potter and the Philosopher''s Stone', 1, 1, '1997-06-26', 25.99, 'Fantasy', '9780747532699'),
('The Shining', 2, 2, '1977-01-28', 18.50, 'Horror', '9780385121675'),
('Murder on the Orient Express', 3, 1, '1934-01-01', 15.99, 'Mystery', '9780062693662'),
('IT', 2, 2, '1986-09-15', 22.99, 'Horror', '9781501142970'),
('The ABC Murders', 3, 1, '1936-01-06', 14.50, 'Mystery', '9780008129552');

-- Task 8: Insert two sample records into the Borrowers table
INSERT INTO Borrowers (BorrowerName, Email, Phone) VALUES
('John Smith', 'john.smith@email.com', '5551234567'),
('Sarah Johnson', 'sarah.johnson@email.com', '5559876543');

-- Task 9: Insert three sample records into the Loans table, with at least one record having ReturnDate = NULL
INSERT INTO Loans (BookID, BorrowerID, LoanDate, ReturnDate) VALUES
(1, 1, '2024-01-15', '2024-02-15'),
(2, 2, '2024-02-01', NULL),
(3, 1, '2024-02-10', NULL);

-- Task 10: Retrieve all books with a price greater than 20
SELECT BookID, Title, Price, Genre
FROM Books
WHERE Price > 20;

-- Task 11: Retrieve the title of each book currently on loan and the name of the borrower
SELECT b.Title, br.BorrowerName, l.LoanDate
FROM Books b
INNER JOIN Loans l ON b.BookID = l.BookID
INNER JOIN Borrowers br ON l.BorrowerID = br.BorrowerID
WHERE l.ReturnDate IS NULL;

-- Task 12: Count the number of books written by each author; display only authors with more than two books
SELECT a.AuthorName, COUNT(b.BookID) as BookCount
FROM Authors a
INNER JOIN Books b ON a.AuthorID = b.AuthorID
GROUP BY a.AuthorID, a.AuthorName
HAVING COUNT(b.BookID) > 2;

-- Verification query to see all authors and their book counts
SELECT a.AuthorName, COUNT(b.BookID) as BookCount
FROM Authors a
INNER JOIN Books b ON a.AuthorID = b.AuthorID
GROUP BY a.AuthorID, a.AuthorName;

-- Task 13: List every book alongside its current borrower's name, showing NULL for books not on loan
SELECT b.Title, br.BorrowerName, l.LoanDate
FROM Books b
LEFT JOIN Loans l ON b.BookID = l.BookID AND l.ReturnDate IS NULL
LEFT JOIN Borrowers br ON l.BorrowerID = br.BorrowerID;

-- Task 14: List every publisher alongside any books they publish, showing NULL where there is no match
SELECT p.PublisherName, b.Title, b.PublicationDate
FROM Publishers p
LEFT JOIN Books b ON p.PublisherID = b.PublisherID
ORDER BY p.PublisherName, b.Title;

-- Task 15: List all unique genres found in the Books table
SELECT DISTINCT Genre
FROM Books
WHERE Genre IS NOT NULL
ORDER BY Genre;

-- Task 16: Retrieve all books with titles starting with "The" or containing "SQL"
SELECT BookID, Title, AuthorID, Price
FROM Books
WHERE Title LIKE 'The%' OR Title LIKE '%SQL%';

-- Task 17: Retrieve the five most recent loan records, ordered by LoanDate descending
SELECT TOP 5 l.LoanID, b.Title, br.BorrowerName, l.LoanDate, l.ReturnDate
FROM Loans l
INNER JOIN Books b ON l.BookID = b.BookID
INNER JOIN Borrowers br ON l.BorrowerID = br.BorrowerID
ORDER BY l.LoanDate DESC;

-- Task 18: Update the Loans table to set the ReturnDate to the current date for a specific LoanID of your choice
UPDATE Loans 
SET ReturnDate = GETDATE()
WHERE LoanID = 2;

-- Task 19: Increase the price of all books published before January 1, 2010 by 10%
UPDATE Books
SET Price = Price * 1.10
WHERE PublicationDate < '2010-01-01';

-- Task 20: Delete all borrowers who have never made a loan
DELETE FROM Borrowers
WHERE BorrowerID NOT IN (
    SELECT DISTINCT BorrowerID 
    FROM Loans 
    WHERE BorrowerID IS NOT NULL
);

-- Task 21: Delete all books priced less than 5
DELETE FROM Loans
WHERE BookID IN (SELECT BookID FROM Books WHERE Price < 5);

DELETE FROM Books
WHERE Price < 5;

-- Task 22: Remove the Address column from the Publishers table
ALTER TABLE Publishers
DROP COLUMN Address;

-- Task 23: Drop the entire Loans table
-- (Commented out to preserve data for other queries)
-- DROP TABLE Loans;

-- Task 24: Insert a new loan record without specifying LoanDate so that the default value is used
INSERT INTO Loans (BookID, BorrowerID, ReturnDate) VALUES
(4, 2, NULL);

-- Task 25: Create a new table named BookCategories with columns BookID and Category; use a composite primary key (BookID, Category) and a foreign key referencing Books
CREATE TABLE BookCategories (
    BookID INT NOT NULL,
    Category NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_BookCategories PRIMARY KEY (BookID, Category),
    CONSTRAINT FK_BookCategories_Books FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

INSERT INTO BookCategories (BookID, Category) VALUES
(1, 'Young Adult'),
(1, 'Fantasy'),
(2, 'Psychological Thriller'),
(2, 'Supernatural'),
(3, 'Classic Mystery'),
(3, 'Detective Fiction'),
(4, 'Horror'),
(4, 'Supernatural'),
(5, 'Classic Mystery'),
(5, 'Detective Fiction');

-- Task 26: For each borrower, count how many loans they have made and order the results by that count descending
SELECT br.BorrowerName, COUNT(l.LoanID) as LoanCount
FROM Borrowers br
LEFT JOIN Loans l ON br.BorrowerID = l.BorrowerID
GROUP BY br.BorrowerID, br.BorrowerName
ORDER BY LoanCount DESC;

-- Task 27: Update any book records with a NULL genre to set the genre to "Unknown"
UPDATE Books
SET Genre = 'Unknown'
WHERE Genre IS NULL;

-- Task 28: Delete all loan records where LoanDate is more than one year old
DELETE FROM Loans
WHERE LoanDate < DATEADD(YEAR, -1, GETDATE());

-- Task 29: Given a table LoanInfo(LoanID, BookTitle, BorrowerName, BorrowerAddress, LoanDate): identify violations of 1NF, 2NF, and 3NF, then decompose it into tables that satisfy 3NF with appropriate keys.
-- Answer: See docs/answers.txt for complete normalization analysis and decomposition
