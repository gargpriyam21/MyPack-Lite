# MyPack Lite: Student Enrollment System

A ruby on rails full stack web application for the class and subject enrollment system for students and instructors.

Technologies and Tools:
- Ruby
- Ruby on Rails
- HTML
- SQLIte Database
- Object Oriented Programming

## Admin credentials
* email : admin@ncsu.edu
* password : 12345

## Setting up

* Clone this repository
```
git clone https://github.com/gargpriyam21/MyPack-Lite.git
```
* Go to the directory
```
cd MyPack-Lite
```
* Install required gems
```
bundle install
```
* Run database migration on your system
```
rails db:migrate
```
* Run seed for the setting up required data
```
rails db:seed
```
* Finally, run the rails server
```
rails server
```

## Components

### 1. Student
* Required Attributes:
    * Name
    * Student ID (unique)
    * Email (needs validation)
    * Password
    * Date of birth
    * Phone number
    * Major

#### Functionality

* A student should be able to
    * Register and Login using his email and password
    * View the list of courses
    * Enroll in a course
    * Drop a course
    * Get added to a waitlist if the course is in WAITLIST status
    * Drop from a waitlist
    * View the list of courses enrolled in
    * View the list of waitlisted courses

* A student should NOT be able to
    * Access the profile of any other student/instructor/admin
    * View the enrolled students for any course
    * View the waitlisted students for any course

### 2. Instructor

* Required Attributes:
    * ID
    * Name
    * Email (needs validation)
    * Password
    * Department

#### Functionality

* An instructor should be able to
    * Register and Log in with their email/password
    * Create a course
    * Remove a course (only the ones they have created) (Note: If an instructor is deleted by an admin, then the course is also deleted, and all enrolled and waitlist students are unenrolled).
    * View the students enrolled in the course (only for their course)
    * Enroll a student in the course (if course is in OPEN status) or [EC] to the waitlist if the course has a WAITLIST. Instructor can’t add a student if course is CLOSED
    * Remove a student from the course (either from class or waitlist)
    * View the list of enrolled students for a course.
    * View the list of waitlist students for a course.

### 3. Admin

* Required Attributes:
    * ID
    * Password
    * Name
    * Email (needs validation)
    * Phone number

#### Functionality

* An admin should be able to
    * Log in with an email and password.
    * Edit her/his own profile - should not be able to update ID, email, and password.
    * Admin should not be able to delete the admin account
    * Admin can create/read/update/delete instructors accounts. Note: while creating instructor accounts, admin has to follow the validation rules.
    * Admin can create/read/update/delete students
    * Admin can create/read/update/delete any course.
    * It should not be possible to create more admin users.
    * An admin should also be capable of performing all operations performed by all user types

### 4. Courses

* Required Attributes:
    * Name
    * Description*
    * Instructor name
    * Weekdays (possible values: MON/TUE/WED/THU/FRI)
        * Weekday One
        * Weekday Two (can be NIL if only single day class)
            * Note: Both weekday one and two cannot be the same. You need to validate the user's input.’
            * Example 1: CSC540 is scheduled on Tuesday and Thursday, so for this class, Weekday one = TUE, Weekday two = THU
            * Example 2: CSC517 is scheduled only on Friday, so for this class, Weekday one = FRI, weekday two = NIL
    * Start time:
        * String in the following format: “HH:MM” which represents 24-hour clock
    * End time:
        * String in the following format: “HH:MM” which represents a 24-hour clock (the end time needs to be after the start time) i
    * Course code:
        * (needs to be unique among all courses) (format: 3 letters followed by 3 digits, e.g. ECE123, CSA090)
    * Capacity: The number of students that can be enrolled in the class. Represented by an integer
    * Waitlist capacity: The number of students that can be added to the waitlist for this course.
    * Status (OPEN/CLOSED/(EC)WAITLIST)* - Represents the current status of the course
        * For example, given that capacity is 40,
            * If 30 students are enrolled, then status is OPEN
            * If 40 students are  enrolled, then status is CLOSED if waitlists are not provided, or WAITLIST if the waitlist feature is implemented.
            * If waitlist capacity is 10, and there are 10 students on the waitlist for the course, then course status is CLOSED
            * A waitlist capacity of 0 indicates that a waitlist is not being used for this class.
    * Room - String for a room location, e.g., 1231 EB3, 02214 EB1, etc [Make sure it is not an empty string]


### 5. Enrollment

* Required Attributes:
    * Student ID
    * Course ID

#### Functionality

* This table keeps track of the enrollment status for a student, for a given course.

### 6. Waitlist

* Required Attributes:
    * Student ID
    * Course ID
    * Enrollment time: the date/time when a student was added to the WAITLIST

#### Functionality
* If the waitlist for a course has students, and if one of the ENROLLED students drops the class, then the earliest student (based on Enrollment time) on the waitlist should automatically be enrolled into the course.

### 7. Bonus

* No user should be able to access any private content associated with another user/admin's account. For example, a student should not have the access to edit any course information.
* No other users should be able to access each other’s profile; student 1 should not be able to access student 2’s profile, surely not instructor 1’s as well just by changing URL
* User Info Header:
    * Ensure that the name and role (Admin/Instructor/Student) is present on each webpage at the top.
        * If the role is admin, it should show: “Role: <u>Admin</u>” (underline)
        * If the role is instructor, it should show: “Role: ___Instructor___” (bold with italics)
        * If the role is student, it should show: “Role: **Student**” (bold)
    * *Note the formatting used.*

### 8. Test Cases

* Courses Controller Tests
  * Should not create course with null values.
  * Should not create course with negative capacity.
  * Should not create course with null name only.
  * Should not create course with null description only.
  * Should not create course with null course code only.
  * Should not create course with null room only.
  * Should not create course with invalid course_code.
  * Should not create course with weekday1 equal to weekday2.
  * Should not create course with end_time less than start_time only.
  * Should not create course with negative waitlist_capacity only.
* Instructors Controller Tests
  * Should not create instructor with null values.
  * Should not create instructor with invalid email.
  * Should not create instructor with invalid date of birth.
  * Should not create instructor with invalid phone_number.
* Students Controller Tests
  * Should not create student with null values.
  * Should not create student with invalid email.
  * Should not create student with invalid date of birth.
  * Should not create student with invalid phone_number.

### 9. Instructors
We would like to thank Dr. Edward Gehringer for helping us understand the process of building a good Object Oriented project.
