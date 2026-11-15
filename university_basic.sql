CREATE DATABASE IF NOT EXISTS university CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE university;

DROP TABLE IF EXISTS course_assignments;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS instructors;
DROP TABLE IF EXISTS students;

CREATE TABLE students (
    student_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female') NOT NULL,
    major VARCHAR(100) NOT NULL,
    enrollment_year YEAR NOT NULL,
    CONSTRAINT uq_students_email UNIQUE (email)
) ENGINE=InnoDB;

CREATE TABLE courses (
    course_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    course_code VARCHAR(10) NOT NULL,
    credits TINYINT UNSIGNED NOT NULL,
    department VARCHAR(100) NOT NULL,
    CONSTRAINT uq_courses_code UNIQUE (course_code)
) ENGINE=InnoDB;

CREATE TABLE instructors (
    instructor_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    hire_date DATE NOT NULL,
    department VARCHAR(100) NOT NULL,
    CONSTRAINT uq_instructors_email UNIQUE (email)
) ENGINE=InnoDB;

CREATE TABLE enrollments (
    enrollment_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    student_id INT UNSIGNED NOT NULL,
    course_id INT UNSIGNED NOT NULL,
    grade ENUM('A', 'B', 'C', 'D', 'F') NULL,
    CONSTRAINT uq_enrollment UNIQUE (student_id, course_id),
    CONSTRAINT fk_enrollments_student FOREIGN KEY (student_id) REFERENCES students (student_id) ON DELETE CASCADE,
    CONSTRAINT fk_enrollments_course FOREIGN KEY (course_id) REFERENCES courses (course_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE course_assignments (
    assignment_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    instructor_id INT UNSIGNED NOT NULL,
    course_id INT UNSIGNED NOT NULL,
    semester ENUM('Fall', 'Spring', 'Summer') NOT NULL,
    year YEAR NOT NULL,
    CONSTRAINT uq_assignment UNIQUE (instructor_id, course_id, semester, year),
    CONSTRAINT fk_assignments_instructor FOREIGN KEY (instructor_id) REFERENCES instructors (instructor_id) ON DELETE CASCADE,
    CONSTRAINT fk_assignments_course FOREIGN KEY (course_id) REFERENCES courses (course_id) ON DELETE CASCADE
) ENGINE=InnoDB;

INSERT INTO students (first_name, last_name, email, date_of_birth, gender, major, enrollment_year) VALUES
('Omar', 'Haddad', 'omar.haddad@example.com', '2004-03-12', 'Male', 'Computer Science', 2023),
('Lina', 'Khalil', 'lina.khalil@example.com', '2003-11-05', 'Female', 'Mathematics', 2022),
('Yazan', 'Nasser', 'yazan.nasser@example.com', '2004-07-21', 'Male', 'Computer Science', 2023),
('Rana', 'Saleh', 'rana.saleh@example.com', '2005-01-30', 'Female', 'Mathematics', 2024),
('Khaled', 'Mansour', 'khaled.mansour@example.com', '2003-09-14', 'Male', 'Physics', 2022),
('Dana', 'Awad', 'dana.awad@example.com', '2004-05-02', 'Female', 'Computer Science', 2023),
('Tariq', 'Zoubi', 'tariq.zoubi@example.com', '2002-12-18', 'Male', 'Physics', 2021),
('Hala', 'Barakat', 'hala.barakat@example.com', '2005-04-09', 'Female', 'Physics', 2024),
('Sami', 'Qasem', 'sami.qasem@example.com', '2003-02-25', 'Male', 'Computer Science', 2022),
('Noor', 'Abdallah', 'noor.abdallah@example.com', '2004-08-16', 'Female', 'Mathematics', 2023);

INSERT INTO instructors (first_name, last_name, email, hire_date, department) VALUES
('Ahmad', 'Fakhouri', 'ahmad.fakhouri@university.edu', '2015-09-01', 'Computer Science'),
('Salma', 'Rifai', 'salma.rifai@university.edu', '2018-02-15', 'Computer Science'),
('Fadi', 'Masri', 'fadi.masri@university.edu', '2012-09-01', 'Mathematics'),
('Maha', 'Tamimi', 'maha.tamimi@university.edu', '2020-01-10', 'Mathematics'),
('Jamal', 'Shami', 'jamal.shami@university.edu', '2010-09-01', 'Physics');

INSERT INTO courses (course_name, course_code, credits, department) VALUES
('Introduction to Programming', 'CS101', 3, 'Computer Science'),
('Database Systems', 'CS201', 3, 'Computer Science'),
('Calculus I', 'MATH101', 4, 'Mathematics'),
('Linear Algebra', 'MATH201', 3, 'Mathematics'),
('General Physics', 'PHYS101', 4, 'Physics');

INSERT INTO course_assignments (instructor_id, course_id, semester, year) VALUES
(1, 1, 'Fall', 2026),
(2, 2, 'Fall', 2026),
(3, 3, 'Fall', 2026),
(4, 4, 'Fall', 2026),
(5, 5, 'Fall', 2026);

INSERT INTO enrollments (student_id, course_id, grade) VALUES
(1, 1, 'A'), (1, 2, 'B'), (1, 3, 'A'),
(2, 1, 'B'), (2, 3, 'C'),
(3, 1, 'A'), (3, 2, 'A'), (3, 4, 'B'),
(4, 3, 'B'), (4, 4, 'A'),
(5, 5, 'A'), (5, 3, 'B'),
(6, 2, 'C'), (6, 1, NULL),
(7, 4, 'B'), (7, 5, NULL),
(8, 1, 'D'), (8, 5, 'C'),
(9, 2, 'A'), (9, 4, 'A'), (9, 5, 'B'),
(10, 1, 'B'), (10, 2, NULL);

SELECT * FROM students;

SELECT COUNT(*) AS total_courses FROM courses;

SET @course_code = 'CS101';
SELECT s.first_name, s.last_name
FROM students AS s
INNER JOIN enrollments AS e ON e.student_id = s.student_id
INNER JOIN courses AS c ON c.course_id = e.course_id
WHERE c.course_code = @course_code
ORDER BY s.last_name, s.first_name;

SET @department = 'Computer Science';
SELECT email
FROM instructors
WHERE department = @department
ORDER BY email;
