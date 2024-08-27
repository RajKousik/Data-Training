# Student Database Setup with Triggers

## Overview

This project sets up a student database in SQL Server with two tables: `student_src` and `student_trgt`. The project includes procedures and triggers to manage data insertion, updates, and soft deletion in the target table whenever changes are made in the source table.

The project demonstrates how to use triggers to automatically maintain a historical log of changes and deletions while updating the target table with the latest data from the source table.

## Database Structure

### Tables

1. **student_src**

   - This is the source table where data is originally inserted, updated, or deleted.
   - Columns:
     - `id`: Primary key, unique identifier for students.
     - `firstname`: First name of the student.
     - `lastname`: Last name of the student.
     - `email`: Email address of the student.
     - `phone`: Contact number of the student.
     - `created_at`: Timestamp of when the record was created, defaulting to the current date and time.

2. **student_trgt**
   - This is the target table where historical records are maintained.
   - Columns:
     - `id`: Primary key, auto-incremented.
     - `student_id`: Foreign key linking to the `id` in `student_src`.
     - `firstname`: First name of the student.
     - `lastname`: Last name of the student.
     - `email`: Email address of the student.
     - `phone`: Contact number of the student.
     - `created_at`: Timestamp of when the record was initially created, defaulting to the current date and time.
     - `is_deleted`: A flag indicating if the record has been deleted (soft delete).

## Stored Procedures

1. **insert_into_student_trgt**

   - Inserts a new record into `student_trgt` whenever a new student is added to `student_src`.

2. **update_student_trgt**

   - Inserts a new record into `student_trgt` whenever a student record is updated in `student_src`, capturing the current timestamp to reflect the update time.

3. **soft_delete_student_trgt**
   - Marks a record as deleted in `student_trgt` by setting the `is_deleted` flag to `1` whenever a student record is deleted from `student_src`.

## Triggers

1. **trg_after_insert_student_src**

   - Trigger on the `student_src` table that activates after a new row is inserted. It calls the `insert_into_student_trgt` procedure to log the new student record in the `student_trgt` table.

2. **trg_after_update_student_src**

   - Trigger on the `student_src` table that activates after an update occurs. It calls the `update_student_trgt` procedure to log the updated student record in the `student_trgt` table with the current timestamp.

3. **trg_after_delete_student_src**
   - Trigger on the `student_src` table that activates after a row is deleted. It calls the `soft_delete_student_trgt` procedure to mark the corresponding record in `student_trgt` as deleted.

## Usage

### Step 1: Database Creation

Create the database and switch to it:

```sql
CREATE DATABASE student_db;
USE student_db;
```

### Step 2: Table Creation

Create the source (`student_src`) and target (`student_trgt`) tables.

### Step 3: Stored Procedures

Create the stored procedures for inserting, updating, and soft deleting records in the `student_trgt` table.

### Step 4: Triggers

Create the triggers on the `student_src` table to automatically log changes in the `student_trgt` table.

### Step 5: Testing

Test the triggers by inserting, updating, and deleting records in the `student_src` table, and verify that the `student_trgt` table is updated accordingly.

## Example Operations

1. **Insert a new student into `student_src`:**

   ```sql
   INSERT INTO student_src (id, firstname, lastname, email, phone)
   VALUES (2, 'Aegon', 'Targeryen', 'aegon@gmail.com', '982-456-7891');
   ```

2. **Update a student record in `student_src`:**

   ```sql
   UPDATE student_src SET firstname = 'Raaj' WHERE id = 1;
   ```

3. **Delete a student record from `student_src`:**

   ```sql
   DELETE FROM student_src WHERE id = 1;
   ```

4. **Check the results:**
   ```sql
   SELECT * FROM student_src;
   SELECT * FROM student_trgt;
   ```

## Conclusion

This setup provides a robust mechanism to track and manage data changes within a SQL database, ensuring that all insertions, updates, and deletions in the source table are properly recorded in the target table with corresponding timestamps and soft deletion flags. This can be particularly useful in scenarios where maintaining a history of changes is critical.
