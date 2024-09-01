# Library Management System

<b>CSC517 Fall 2019 [Project 2 (Ruby on Rails)](https://github.com/jayjagtap/Library-Management-System-on-Ruby-on-Rails)</b><br>

<b>Faculty:</b> [Prof. Edward F. Gehringer](mailto:efg@ncsu.edu)<br>
<b>Mentor:</b> [Akanksha Mohan](mailto:amohan7@ncsu.edu)<br>

<b>Team_469:</b>
[Rohan Pillai](mailto:rspillai@ncsu.edu),
[Omkar Kulkarni](mailto:oskulkar@ncsu.edu),
[Jay Jagtap](mailto:jjjagtap@ncsu.edu)<br>

rake db:test:prepare

# Para recriar o banco de dados de teste (drop + create + migrate)

rails db:reset RAILS_ENV=test

# ou

# Para carregar o schema do banco de dados do ambiente de desenvolvimento no ambiente de teste

rails db:schema:load RAILS_ENV=test

Ruby Version: 2.6.4 <br>
Rails Version: 6.0.0 <br>
Find details of other dependencies in the [Gemfile](../master/LibraryManagementSystem/Gemfile).<br>

#### Deployed Link: [Click Here](https://young-badlands-68256.herokuapp.com/)<br>

## Pre-configured Admin

There is only one pre-configured Administrator.<br>
Email: admin@admin.com <br>
Password: admin123<br>
<br>
<strong>Note:</strong> Please do not edit the profile of Admin. Even if you do, then please edit it back to the original credentials so that others can use it for their review.

## Pre-configured Librarian

Email: librarian@ncsu.edu <br>
Password: password <br>
<br>

## Pre-configured Student

Email: student@ncsu.edu <br>
Password: password <br>
<br>

## Work Flows

There are 3 different users to the application: Administrator, Librarian and Student. Each of them have a separate signup and login link. The available functionalities of each user is defined in a below section.

<b>Special Features:</b>

1. Librarian and Student cannot view each other's account or access any other restricted functionality by simply changing the URL.
2. Google OAuth has been implemented for Student. (However, this functionality is not available in the deployed link due to Heroku gem problems.)

### Addition of a new Librarian

You need to sign up using sign up librarian link and then need to approve the librarian request from Admin account.<br>
To approve librarian, use following steps:

1. Signup using Librarian Signup link.<br>
2. Login into Admin account.<br>
3. Go to View Librarian.<br>
4. Click the edit option present in front of the librarian you have created.<br>
5. Change the value of approved from No to Yes.<br>

## Details

There are 5 main components in the system:

- Library
- Book
- Admin
- Librarian
- Student

### Library

A library has the following attributes:

- Name (String)
- University (String)
- Location (String)
- Maximum number of days a book can be borrowed (Integer)
- Overdue fines for the books in the library (Float)

### Book

A book has the following attributes (https://catalog.lib.ncsu.edu/catalog/NCSU3343215):

- ISBN (unique) (String)
- Title (String)
- Author(s) (String)
- Language (String)
- Published (Date)
- Edition (String)
- Associated Library (String)
- Image of the front cover (PNG or JPEG files only)
- Subject of the book (String)
- Summary (String)
- Is Special Collection Item? (Yes/No) (Boolean)

### Admin

The system has a preconfigured admin with the following attributes:

- Email (unique for each account) (String)
- Name (String)
- Password (String)

An admin is capable of performing all operations performed by Librarian or Student, and admin account cannot be deleted.
Admin is able to:

- Log in with an email and password
- Edit profile
- Create/Modify Librarian or Student accounts
- Create/Modify/Delete Libraries and Books.
- View the list of users (students and librarians) and their profile details (except password)
- View the list of books, along with detailed information.
- View the list of book hold requests.
- View the list of Checked out books.
- View the list of students with books overdue (along with overdue fines).
- View the borrowing history of each book.
- Delete Student/Book/Librarian from the system

### Librarian

A librarian has the following attributes:

- Email (unique for each account) (String)
- Name (String)
- Password (String)
- Library (Choose from dropdown)

Anyone can sign up as a librarian using their email, name and password. After signing up, they must be approved by an admin before they can perform the following tasks:

- Log in with email and password.
- Edit their own profile to choose an existing library. Each librarian can only work for one library.
- Edit library attributes.
- Add/Remove books to/from a library.
- View & Edit book information.
- View all books.
- View hold requests for any book in the library he/she works in.
- For books in the special collection, accept or deny book hold request.
- View list of all the books that are checked out from their library.
- View the borrowing history of the books from their library.
- View the list of students with overdue books from their library along with overdue fine.

### Students

A student has the following attributes:

- Email (unique for each account) (String)
- Name (String)
- Password (String)
- Educational Level (Undergraduate/Graduate/PhD Student) (Choose from dropdown)
- University (String)
- Maximum number of books (**N**) that can be borrowed at any given time (It is based on their educational level. Undergraduate - 2, Masters - 4, PhD - 6). (Integer)

Anyone can sign up as a student using their email, name and password. After signing up, they can perform the following tasks:

- View the list of all the libraries
- Edit profile to modify email, name and password only.
- View all books
- Check out/Request/Return a book from any library associated with their University.
- Delete a reservation request, which has not been approved yet (pending).
- View/Edit their account attributes (including changing their password).
- Search through the books
  - Search by title
  - Search by author
  - Search by publication date
  - Search by subject
- Bookmark a book they are interested in.
- View their bookmarked books.
- At any given time, a student can borrow a max of '**N**' number of books based on their educational level.
- View the overdue fines for his/her account.
- Receive an email when any of their book request is successful.

#### Book Hold Request

- If the book is available, proceed to check out:
  - If the book is in Special Collection list, add this to Librarian's approval list and wait.
  - Otherwise, add the book to student's checked out list.
- If the book is unavailable or the student has checked out **N** books already,
  - Inform the student that the book is unavailable or max limit reached.
  - Create a book hold request if the student wants to continue requesting.
- Number of hold requests for a book is visible to every user.

#### Returning a book

- If there is no hold request for a book, return and increase the available count of the book.
- If there is a pending hold request,
  - Approve the hold request and add the book to the checked out list of the requested student.
  - Send a mail to the student that the book is checked out.
