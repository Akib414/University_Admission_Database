-- 1. Basic: all students with their primary phone
SELECT 
    s.first_name, s.last_name,
    c.contact_value AS primary_phone
FROM Students s
LEFT JOIN StudentContacts c ON s.student_id = c.student_id 
                           AND c.contact_type = 'phone' 
                           AND c.is_primary = TRUE;

-- 2. Students + guardian name + relation (multiple joins)
SELECT 
    s.first_name, s.last_name,
    g.full_name AS guardian_name,
    sg.relationship,
    sg.is_primary
FROM Students s
JOIN StudentGuardians sg ON sg.student_id = s.student_id
JOIN Guardians g       ON g.guardian_id = sg.guardian_id
WHERE sg.is_primary = TRUE;

-- 3. Regex example: students whose name starts with 'A' or contains 'fat' (case insensitive)
SELECT first_name, last_name
FROM Students
WHERE first_name REGEXP '^[Aa]' 
   OR first_name REGEXP '(?i)fat';

-- 4. Complex: Admit cards ready to print (with center, exam, payment status)
SELECT 
    a.admit_number,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    e.exam_name,
    e.exam_date,
    e.shift,
    c.center_name,
    p.status AS payment_status
FROM Admissions a
JOIN Students s          ON s.student_id = a.student_id
JOIN Exams e             ON e.exam_id    = a.exam_id
LEFT JOIN Centers c      ON c.center_id  = a.center_id
LEFT JOIN Payments p     ON p.admit_id   = a.admit_id
WHERE a.status IN ('paid','confirmed');

-- 5. Count applications per exam + payment completion rate
SELECT 
    e.exam_name,
    COUNT(a.admit_id) AS total_applications,
    SUM(CASE WHEN p.status = 'SUCCESS' THEN 1 ELSE 0 END) AS successful_payments,
    ROUND(SUM(CASE WHEN p.status = 'SUCCESS' THEN 1 ELSE 0 END) * 100.0 / COUNT(a.admit_id), 1) AS payment_completion_pct
FROM Exams e
LEFT JOIN Admissions a ON a.exam_id = e.exam_id
LEFT JOIN Payments p   ON p.admit_id = a.admit_id
GROUP BY e.exam_id
ORDER BY total_applications DESC;

-- 6. Students who applied but did NOT pay anything
SELECT 
    s.first_name, s.last_name,
    a.admit_number,
    e.exam_name
FROM Students s
JOIN Admissions a ON a.student_id = s.student_id
JOIN Exams e      ON e.exam_id    = a.exam_id
LEFT JOIN Payments p ON p.admit_id = a.admit_id
WHERE p.payment_id IS NULL
  AND a.status NOT IN ('cancelled');
