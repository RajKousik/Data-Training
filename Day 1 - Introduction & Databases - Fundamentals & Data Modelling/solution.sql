-- Create the database
CREATE DATABASE student_db;

-- Switch to the database
USE student_db;

-- Create the student_src table
CREATE TABLE student_src (
    id INT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(15),
    created_at DATETIME DEFAULT GETDATE()
);

-- Drop the existing student_trgt table
DROP TABLE IF EXISTS student_trgt;

-- Create the student_trgt table 
CREATE TABLE student_trgt (
    id INT PRIMARY KEY IDENTITY(1,1),
    student_id INT,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(15),
    created_at DATETIME DEFAULT GETDATE(),
    is_deleted BIT DEFAULT 0
);

/* TESTING */

-- Insert a new row into the student_src table
INSERT INTO student_src (id, firstname, lastname, email, phone)
VALUES (2, 'Aegon', 'Targeryen', 'aegon@gmail.com', '982-456-7891');

-- Update a row in the student_src table
UPDATE student_src SET firstname = 'Raaj' WHERE id = 1;

-- Delete a row from the student_src table
DELETE FROM student_src WHERE id = 1;

-- results
SELECT * FROM student_src;
SELECT * FROM student_trgt;

/* ------------------------------------------ */


/* INSERT PROCEDURE */ 
CREATE OR ALTER PROCEDURE insert_into_student_trgt 
@student_id INT,
@firstname VARCHAR(50),
@lastname VARCHAR(50),
@email VARCHAR(100),
@phone VARCHAR(15),
@created_at DATETIME
AS
BEGIN
    INSERT INTO student_trgt (student_id, firstname, lastname, email, phone, created_at)
    VALUES (@student_id, @firstname, @lastname, @email, @phone, @created_at);
END


/* UPDATE PROCEDURE */
CREATE OR ALTER PROCEDURE update_student_trgt 
@student_id INT,
@firstname VARCHAR(50),
@lastname VARCHAR(50),
@email VARCHAR(100),
@phone VARCHAR(15)
AS
BEGIN
    INSERT INTO student_trgt (student_id, firstname, lastname, email, phone, created_at)
    VALUES (@student_id, @firstname, @lastname, @email, @phone, GETDATE());
END


/* DELETE PROCEDURE */
CREATE OR ALTER PROCEDURE soft_delete_student_trgt 
@student_id INT
AS
BEGIN
    UPDATE student_trgt
    SET is_deleted = 1
    WHERE student_id = @student_id;
END


/* INSERT TRIGGER */
CREATE OR ALTER TRIGGER trg_after_insert_student_src
ON student_src
AFTER INSERT
AS
BEGIN
    DECLARE @student_id INT, @firstname VARCHAR(50), @lastname VARCHAR(50), @email VARCHAR(100), @phone VARCHAR(15), @created_at DATETIME;
    SELECT @student_id = id, @firstname = firstname, @lastname = lastname, @email = email, @phone = phone, @created_at = created_at FROM inserted;

    EXEC insert_into_student_trgt @student_id, @firstname, @lastname, @email, @phone, @created_at;
END


/* UPDATE TRIGGER */
CREATE OR ALTER TRIGGER trg_after_update_student_src
ON student_src
AFTER UPDATE
AS
BEGIN
    DECLARE @student_id INT, @firstname VARCHAR(50), @lastname VARCHAR(50), @email VARCHAR(100), @phone VARCHAR(15);
    
    -- Get the updated data from the inserted pseudo-table
    SELECT @student_id = id, @firstname = firstname, @lastname = lastname, @email = email, @phone = phone FROM inserted;
    -- Execute the update_student_trgt procedure with the current date and time
    EXEC update_student_trgt @student_id, @firstname, @lastname, @email, @phone;
END


/* DELETE TRIGGER */
CREATE OR ALTER TRIGGER trg_after_delete_student_src
ON student_src
AFTER DELETE
AS
BEGIN
    DECLARE @student_id INT;
    SELECT @student_id = id FROM deleted;

    EXEC soft_delete_student_trgt @student_id;
END


