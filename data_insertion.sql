-- Subjects
INSERT INTO Subjects (subject_code, subject_name) VALUES
('BAN','Bangla'), ('ENG','English'), ('PHY','Physics'),
('CHEM','Chemistry'), ('MATH','Mathematics');

-- Centers
INSERT INTO Centers (center_name, district, address_text) VALUES
('Dhaka College Center', 'Dhaka', 'New Market, Dhaka-1205'),
('Viqarunnisa Center',   'Dhaka', 'Bailey Road'),
('Rajuk Uttara Model College', 'Dhaka', 'Sector 6, Uttara'),
('Notre Dame College',   'Dhaka', 'Motijheel'),
('Holy Cross College',   'Dhaka', 'Tejgaon');

-- Exams
INSERT INTO Exams (exam_name, exam_date, shift, medium) VALUES
('Unit A Admission 2025', '2025-11-15', 'Morning', 'Bangla'),
('Unit B Admission 2025', '2025-11-16', 'Afternoon','English'),
('Unit C Admission 2025', '2025-11-22', 'Morning', 'Bangla'),
('Unit D Admission 2025', '2025-11-23', 'Morning', 'Bangla'),
('Special Quota Test',    '2025-12-01', 'Evening', 'English');

-- Students (5)
INSERT INTO Students (first_name, last_name, date_of_birth, gender, birth_reg_no, status) VALUES
('Rahim','Khan','2007-03-12','Male','2007031200012','applicant'),
('Fatima','Begum','2006-11-25','Female','2006112500897','applicant'),
('Samiul','Islam','2007-08-19','Male','2007081903345','applicant'),
('Nusrat','Jahan','2006-05-30','Female','2006053001123','applicant'),
('Arif','Hossain','2007-01-08','Male','2007010805678','applicant');

-- StudentContacts (few examples)
INSERT INTO StudentContacts (student_id, contact_type, contact_value, is_primary) VALUES
(1,'phone','+8801712345678',true),
(1,'email','rahim.khan07@gmail.com',true),
(2,'phone','+8801844556677',true),
(3,'phone','+8801966778899',true),
(4,'email','nusrat.jahan06@yahoo.com',true);

-- Guardians (5)
INSERT INTO Guardians (full_name, phone, occupation, monthly_income) VALUES
('Md. Abdul Karim','+8801711112222','Business',85000),
('Mrs. Salma Akter','+8801812345678','Teacher',45000),
('Md. Rafiqul Islam','+8801912349876','Service',72000),
('Mrs. Rina Begum','+8801719876543','Housewife',0),
('Md. Shahjahan','+8801710001111','Farmer',28000);

-- StudentGuardians (linking)
INSERT INTO StudentGuardians (student_id, guardian_id, relationship, is_primary) VALUES
(1,1,'Father',true),
(2,2,'Mother',true),
(3,3,'Father',true),
(4,4,'Mother',true),
(5,5,'Father',true);

-- Addresses (Permanent only - 5)
INSERT INTO Addresses (student_id, address_type, district, upazila, address_line) VALUES
(1,'Permanent','Dhaka','Mirpur','House #12, Road #5, Section 10'),
(2,'Permanent','Chattogram','Pahartali','Lane 3, Block B'),
(3,'Permanent','Rajshahi','Paba','Vill: Gopalpur'),
(4,'Permanent','Khulna','Sonadanga','Road 7, House 45'),
(5,'Permanent','Sylhet','Beanibazar','Ward 4');

-- EducationRecords (SSC only for simplicity)
INSERT INTO EducationRecords (student_id, exam_level, board, roll_no, passing_year, gpa, institution) VALUES
(1,'SSC','Dhaka','112233','2023',5.00,'Mirpur Cantonment Public School'),
(2,'SSC','Chattogram','445566','2023',5.00,'Chattogram Govt Girls High School'),
(3,'SSC','Rajshahi','778899','2023',4.89,'Rajshahi Collegiate School'),
(4,'SSC','Khulna','990011','2023',5.00,'Khulna Zilla School'),
(5,'SSC','Sylhet','223344','2023',4.67,'Blue Bird School');

-- Admissions (5)
INSERT INTO Admissions (admit_number, student_id, exam_id, center_id, status) VALUES
('ADM-2025-A-0001',1,1,1,'paid'),
('ADM-2025-B-0002',2,2,2,'confirmed'),
('ADM-2025-A-0003',3,1,3,'applied'),
('ADM-2025-C-0004',4,3,4,'paid'),
('ADM-2025-D-0005',5,4,5,'paid');

-- Payments (some)
INSERT INTO Payments (admit_id, amount, payment_date, method, transaction_id, status) VALUES
(1,1125,'2025-10-10','bKash','TXN987654321','SUCCESS'),
(2,1125,'2025-10-12','Nagad','NGD-456789123','SUCCESS'),
(4,1125,'2025-10-15','Bank','BK20251015','SUCCESS'),
(5,1125,'2025-10-16','bKash','TXN123987456','SUCCESS');
