# Library Management System

#### This is a library management system design that enables users to search for, check out, and return books.

#### It is a coursework project for the Database Systems module implemented in SQL on Oracle Live SQL. 
#### Overview:
- Create TABLES.sql: Initialises tables like MEMBER, ITEM_INFO, etc.
- Create Triggers.sql: Automates library rules, e.g., updating borrowing counts, handling fines, and enforcing loan limits.
- Insert Sample data.sql: Populates tables with sample data.
- Create_Views.sql: Creates views for insights, such as Popularity_Ranking.
- Queries.sql: Contains SQL queries for common tasks like borrowing and member status checks.
#### Desciptions and Assumptions:
- Members can register as either students or staff, with different loan credits, and have accounts automatically created upon registration.
- Items in the library can be managed and their status ("In stock" or "Out on loan") is tracked.
- Members can borrow and return items, with automated updates to borrowing counts and item statuses.
- Overdue items result in automatic fine accumulation, with possible account suspension for excessive fines.
- Members have a borrowing limit based on their allocated loan credit.
- Some items are restricted to "in-library use only" and cannot be borrowed.
- A view is available to check the popularity ranking of items based on borrowing frequency.