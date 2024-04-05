-- Всі завданні були виконані і протестовані у MySQL

-- 3. Найбільша книга за обсягом сторінок
SELECT name
FROM books 
WHERE pages = (SELECT MAX(pages) FROM books)
;

-- 4. Список студентів, що брали книгу name_1
SELECT DISTINCT o.name
FROM orders o
JOIN books b ON o.id_book = b.id
WHERE b.name = 'name_1'
;

-- 5. Кількість студентів, які брали книгу name_2 більше 3х разів
SELECT COUNT(DISTINCT o.name) AS students_count
FROM orders o
JOIN books b ON o.id_book = b.id
WHERE b.name = 'name_2'
GROUP BY o.name
HAVING COUNT(o.id_book) > 3
;

-- 6. ІД студента, який першим взяв книгу обсягом більше 500 сторінок
SELECT o.name
FROM orders o
JOIN books b ON o.id_book = b.id
WHERE b.pages > 500
ORDER BY o.date ASC
LIMIT 1
;

-- 7. Найдорожчі книги в кожному жанрі, виведені в алфавітному порядку
SELECT name, genre
FROM books b1
WHERE price = (SELECT MAX(price)
	       FROM books b2
	       WHERE b2.genre = b1.genre)
ORDER BY name ASC
;

-- 8. Дані по книгах, у назві яких є символ «%»
SELECT *
FROM books
WHERE name LIKE '%\%%'
;

-- 9. Імена останніх 3х студентів і книги, які вони колись брали (за весь час)
SELECT o.name AS student_name,
       GROUP_CONCAT(DISTINCT b.name SEPARATOR ', ') AS books
FROM orders o
JOIN books b ON o.id_book = b.id
JOIN (SELECT name AS student_name
      FROM orders
      GROUP BY name
      ORDER BY MAX(date) DESC
      LIMIT 3) AS last_students ON o.name = last_students.student_name
GROUP BY o.name
ORDER BY o.date DESC
;

-- 10. Книги, які студенти не брали протягом поточного місяця
SELECT name AS book_name
FROM books
WHERE id NOT IN (SELECT id_book 
                 FROM orders
                 WHERE CONCAT(MONTH(date), '-', YEAR(date)) = CONCAT(MONTH(SYSDATE()), '-', YEAR(SYSDATE())))
;
