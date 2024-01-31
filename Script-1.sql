-- Задача 1. Создать схему базы данных: students, exams, course.

CREATE DATABASE POST1;
CREATE ROLE user_post1 SUPERUSER CREATEDB LOGIN PASSWORD 'user_post1';
GRANT ALL PRIVILEGES ON DATABASE POST1 TO user_post1;

CREATE SCHEMA EDU;

-- Создание таблицы students
CREATE TABLE EDU.students
( 
  student_id int4 PRIMARY KEY, 
  number_test_book varchar(255),
  first_name varchar(255) not null,
  last_name varchar(255) not null
);

-- Создание таблицы course
CREATE TABLE EDU.course
( 
  course_id int4 primary key,
  nane varchar(255) not null,
  speciality varchar(255) not null,
  semester int4,
  lectures int4,
  lab_works int4
);

-- Создание таблицы exams
CREATE TABLE EDU.exams
(
   student_id int4,
   course_id int4,
   grade int2 not null,
   PRIMARY KEY (student_id, course_id),
   FOREIGN KEY (student_id) REFERENCES EDU.students(student_id),
   FOREIGN KEY (course_id) REFERENCES EDU.course(course_id)
);



-- Задача 2. Добавить в схему EDU таблицу Teachers. Установить связь между таб-лицами Course и Teachers, которая должна обеспечивать выполнение следующего правила: каждый преподаватель может вести занятия по нескольким дисципли-нам, а занятия по каждой дисциплине ведет только один преподаватель.
-- Создание таблицы Teachers

CREATE TABLE EDU.teachers
( 
  teacher_id int4 PRIMARY KEY, 
  first_name varchar(255) not null,
  last_name varchar(255) not null
);

-- добавляем в course столбец для связи с teachers
ALTER TABLE EDU.course
ADD COLUMN teacher_id int4,
ADD CONSTRAINT Course_Teacher_FK
-- каждой строке ставим своего преподавателя, причем один и тот же преподаватель может повторяться в нескольких строках
FOREIGN KEY (teacher_id) REFERENCES EDU.teachers(teacher_id);



-- Задача 3. Схема EDU предполагает, что каждый студент по каждой дисциплине сдает экзамен один раз. Внести в схему изменения, которые позволят хранить для каждого студента данные о нескольких экзаменах по каждой дисциплине. После этих изменений создать E-R диаграмму схемы.
-- Чтобы студент мог сдавать несколько экзаменов по одной дисциплине, необходимо удалить
-- Прежние primary keys и добавить к ним ещё один - новый - номер экзамена
-- если хотя бы одно значение из списка primary key отличается, то
-- данные сохраняются. Т.о. мы и будем хранить данные о нескольких экзаменах по одному предмету

-- удаляем предыдущие ограничения
ALTER TABLE EDU.exams
DROP CONSTRAINT exams_pkey;

-- добавляем новый столбец
ALTER TABLE EDU.exams
ADD COLUMN exam_number int4;

--Создаём новые первичные ключи
ALTER TABLE EDU.exams
ADD PRIMARY KEY (student_id, course_id, exam_number);

--Добавим данные в таблицу students
INSERT INTO EDU.students (student_id, number_test_book, first_name, last_name)
VALUES
  (1, 'ABC123', 'Ivan', 'Ivanov'),
  (2, 'DEF456', 'Petr', 'Petrov'),
  (3, 'GHI789', 'Alexei', 'Alexeev'),
  (4, 'JKL012', 'Maria', 'Marieva'),
  (5, 'MNO345', 'Elena', 'Elenova'),
  (6, 'PQR678', 'Andrei', 'Andreev'),
  (7, 'STU901', 'Olga', 'Olgina'),
  (8, 'VWX234', 'Anna', 'Annova'),
  (9, 'YZA567', 'Dmitriy', 'Dmitriev'),
  (10, 'BCD890', 'Natalia', 'Natalieva');
 
 --Добавим данные в таблицу teachers
INSERT INTO EDU.teachers (teacher_id, first_name, last_name)
VALUES
  (1, 'Alexandr', 'Smirnov'),
  (2, 'Ekaterina', 'Ivanova'),
  (3, 'Mihail', 'Petrov'),
  (4, 'Olga', 'Sidorova'),
  (5, 'Ivan', 'Kuznetsov');
 
 --Добавим данные в таблицу course
INSERT INTO EDU.course (course_id, nane, speciality, semester, lectures, lab_works, teacher_id)
VALUES
  (1, 'Maths', 'Maths and Computer Science', 1, 20, 10, 1),
  (2, 'Physics', 'Physics and Astronomy', 2, 30, 15, 2),
  (3, 'History', 'Faculty of History', 1, 15, 5, 3),
  (4, 'Biology', 'Faculty of Biology', 2, 25, 12, 2),
  (5, 'English', 'Faculty of Foreign Languages', 1, 40, 3, 4),
  (6, 'Programming', 'Faculty of Computer Science', 2, 35, 4, 1),
  (7, 'Economics', 'Faculty of Economics', 1, 30, 10, 3),
  (8, 'Chemistry', 'Faculty of Chemistry', 2, 20, 12, 5),
  (9, 'Geography', 'Faculty of Geography', 1, 25, 5, 4),
  (10, 'Literature', 'Faculty of Philology', 2, 15, 6, 3);

 --Добавим данные в таблицу exams
INSERT INTO EDU.exams (student_id, course_id, grade, exam_number)
VALUES
  (1, 1, 85, 1),
  (1, 1, 90, 2),
  (1, 2, 78, 1),
  (2, 1, 90, 1),
  (2, 3, 92, 1),
  (2, 9, 60, 1),
  (2, 9, 93, 2),
  (3, 6, 86, 1),
  (4, 4, 79, 1),
  (4, 4, 82, 2),
  (4, 8, 90, 1),
  (5, 2, 88, 1),
  (5, 5, 91, 1),
  (6, 6, 94, 1),
  (6, 5, 70, 1),
  (6, 5, 73, 2),
  (7, 3, 82, 1),
  (8, 7, 53, 1),
  (8, 2, 43, 1),
  (9, 7, 91, 1),
  (9, 2, 34, 1),
  (9, 2, 67, 2),
  (10, 1, 78, 1);
 

 
-- Задача 4. Создать представление, которое возвращает данные о студентах и среднем бале каждого студента.
 
CREATE OR REPLACE VIEW EDU.student_grades AS
SELECT s.student_id, s.first_name, s.last_name, AVG(max_grade) AS average_grade
FROM EDU.students s
JOIN (
    SELECT e.student_id, e.course_id, MAX(e.grade) AS max_grade
    FROM (
        SELECT student_id, course_id, exam_number, MAX(grade) AS grade
        FROM EDU.exams
        GROUP BY student_id, course_id, exam_number
    ) e
    GROUP BY e.student_id, e.course_id
) e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name;


SELECT * FROM EDU.student_grades
order by student_id;



-- Задача 5. Создать представление, которое возвращает значения столбцов first_name, last_name преподавателя и среднее значение отметок по каждой дисциплине, которые он вел.

CREATE OR REPLACE VIEW EDU.teacher_grades AS
SELECT t.first_name, t.last_name, c.nane AS course_name, AVG(e.grade) AS average_grade
FROM EDU.teachers t
JOIN EDU.course c ON t.teacher_id = c.teacher_id
JOIN EDU.exams e ON c.course_id = e.course_id
GROUP BY t.first_name, t.last_name, c.nane;


SELECT * FROM EDU.teacher_grades
order by first_name;




