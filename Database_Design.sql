

DROP DATABASE IF EXISTS admission_management_db_beginner_norm;
CREATE DATABASE admission_management_db_beginner_norm;
USE admission_management_db_beginner_norm;

-- Reference tables
CREATE TABLE Subjects (
    subject_id    INT AUTO_INCREMENT PRIMARY KEY,
    subject_code  VARCHAR(20) NOT NULL UNIQUE,
    subject_name  VARCHAR(150) NOT NULL,
    INDEX idx_code (subject_code)
);

CREATE TABLE Centers (
    center_id     INT AUTO_INCREMENT PRIMARY KEY,
    center_name   VARCHAR(150) NOT NULL,
    address_text  VARCHAR(500),
    district      VARCHAR(100),
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Exams (
    exam_id       INT AUTO_INCREMENT PRIMARY KEY,
    exam_name     VARCHAR(150) NOT NULL,          -- e.g. "Admission Test 2025-26"
    exam_date     DATE NOT NULL,
    shift         VARCHAR(50),                     -- Morning / Afternoon / Evening
    medium        VARCHAR(50),                     -- Bangla / English
    status        ENUM('upcoming','ongoing','completed') DEFAULT 'upcoming',
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Core
CREATE TABLE Students (
    student_id            INT AUTO_INCREMENT PRIMARY KEY,
    first_name            VARCHAR(100) NOT NULL,
    last_name             VARCHAR(100) NOT NULL,
    date_of_birth         DATE,
    gender                ENUM('Male','Female','Other'),
    nationality           VARCHAR(80) DEFAULT 'Bangladeshi',
    birth_reg_no          VARCHAR(50) UNIQUE,
    nid                   VARCHAR(20) UNIQUE,
    blood_group           VARCHAR(10),
    status                ENUM('applicant','admitted','rejected','withdrawn') DEFAULT 'applicant',
    created_at            DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at            DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE StudentContacts (
    contact_id     INT AUTO_INCREMENT PRIMARY KEY,
    student_id     INT NOT NULL,
    contact_type   ENUM('phone','email','whatsapp') NOT NULL,
    contact_value  VARCHAR(150) NOT NULL,
    is_primary     BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    UNIQUE KEY uq_contact (student_id, contact_type, contact_value)
);

CREATE TABLE Guardians (
    guardian_id    INT AUTO_INCREMENT PRIMARY KEY,
    full_name      VARCHAR(150) NOT NULL,
    nid            VARCHAR(20),
    phone          VARCHAR(20),
    occupation     VARCHAR(100),
    monthly_income DECIMAL(12,2),
    created_at     DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE StudentGuardians (
    student_id     INT NOT NULL,
    guardian_id    INT NOT NULL,
    relationship   ENUM('Father','Mother','Guardian','Other') NOT NULL,
    is_primary     BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (student_id, guardian_id),
    FOREIGN KEY (student_id)  REFERENCES Students(student_id)   ON DELETE CASCADE,
    FOREIGN KEY (guardian_id) REFERENCES Guardians(guardian_id) ON DELETE CASCADE
);

CREATE TABLE Addresses (
    address_id     INT AUTO_INCREMENT PRIMARY KEY,
    student_id     INT NOT NULL,
    address_type   ENUM('Permanent','Present') NOT NULL,
    division       VARCHAR(80),
    district       VARCHAR(80),
    upazila        VARCHAR(80),
    post_office    VARCHAR(80),
    postal_code    VARCHAR(20),
    address_line   VARCHAR(300),
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    UNIQUE KEY uq_address_type (student_id, address_type)
);

CREATE TABLE EducationRecords (
    edu_id         INT AUTO_INCREMENT PRIMARY KEY,
    student_id     INT NOT NULL,
    exam_level     ENUM('SSC','HSC','Equivalent') NOT NULL,
    board          VARCHAR(80),
    roll_no        VARCHAR(30),
    reg_no         VARCHAR(30),
    passing_year   SMALLINT,
    gpa            DECIMAL(4,2),
    institution    VARCHAR(150),
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    UNIQUE KEY uq_edu_level (student_id, exam_level)
);

-- Transactional / Process tables
CREATE TABLE Admissions (
    admit_id       INT AUTO_INCREMENT PRIMARY KEY,
    admit_number   VARCHAR(40) NOT NULL UNIQUE,
    student_id     INT NOT NULL,
    exam_id        INT NOT NULL,
    center_id      INT,
    exam_shift     VARCHAR(50),               -- can override exam shift if needed
    status         ENUM('applied','paid','confirmed','cancelled') DEFAULT 'applied',
    created_at     DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (exam_id)    REFERENCES Exams(exam_id),
    FOREIGN KEY (center_id)  REFERENCES Centers(center_id)
);

CREATE TABLE Payments (
    payment_id     INT AUTO_INCREMENT PRIMARY KEY,
    admit_id       INT NOT NULL,
    amount         DECIMAL(10,2) NOT NULL,
    payment_date   DATE NOT NULL,
    method         VARCHAR(50),               -- bKash, Nagad, Bank, Cash...
    transaction_id VARCHAR(80) UNIQUE,
    status         ENUM('PENDING','SUCCESS','FAILED','REFUNDED') DEFAULT 'PENDING',
    created_at     DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admit_id) REFERENCES Admissions(admit_id)
);

CREATE TABLE Results (
    result_id      INT AUTO_INCREMENT PRIMARY KEY,
    admit_id       INT NOT NULL UNIQUE,
    merit_position INT,
    total_marks    DECIMAL(6,2),
    status         ENUM('Passed','Failed','Waiting') DEFAULT 'Waiting',
    allotted_unit  VARCHAR(50),
    FOREIGN KEY (admit_id) REFERENCES Admissions(admit_id)
);

CREATE TABLE ResultDetails (
    result_id      INT NOT NULL,
    subject_id     INT NOT NULL,
    obtained_marks DECIMAL(5,2),
    PRIMARY KEY (result_id, subject_id),
    FOREIGN KEY (result_id)   REFERENCES Results(result_id),
    FOREIGN KEY (subject_id)  REFERENCES Subjects(subject_id)
);
