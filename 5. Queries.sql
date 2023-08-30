--1.Students who have already borrowed their full credit try to borrow a new item.
 INSERT INTO LOAN_INFO
VALUES(1207202201,1210304263,1299002602,'The Renaissance',
TO_DATE('07-DEC-22','DD-MON-YYYY'),TO_DATE('21-DEC-2022','DD-MON-YYYY'), Null);
 
--2.List the members who borrowed item on 03/12/22.
 
SELECT LOAN_REC_NUM, MEMBER_ID,ITEM_NAME
FROM LOAN_INFO
WHERE LENDING_DATE='03-DEC-22'
ORDER BY LOAN_REC_NUM;
 
--3.List how many times “To Kill a Mockingbird” is borrowed.
 
SELECT ITEM_NAME,COUNT(*)
FROM LOAN_INFO
WHERE ITEM_NAME='To Kill a Mockingbird'
GROUP BY ITEM_NAME;
 
--4.A Member has returned the book on 07/12/22.
 
UPDATE LOAN_INFO
SET RETURN_DATE='07-DEC-22'
WHERE LOAN_REC_NUM=1201202202;
 
--5.Add a new account for student whose name is Gia Dvali.
 
INSERT INTO MEMBER
VALUES(1220322922, 'Gia Dvali', 'ec32922@qmul.ac.uk', 'Student', 5, 0);
 
--6.Show where the book “One Hundred Years of Solitude” located.
 
SELECT ITEM_NAME,FLOOR_NUM,SHELF_NUM,CLASS_NUM
FROM ITEM_LOC
WHERE ITEM_NAME='One Hundred Years of Solitude';
 
--7.List all items the member whose account is suspended need to be returned if he/she would like to activate the account again
 
SELECT ITEM_NAME,MEMBER_ID
FROM LOAN_INFO
WHERE RETURN_DATE IS NULL AND MEMBER_ID IN
(SELECT MEMBER_ID FROM ACCOUNT WHERE STATE='Suspended');
 
--8.List the name and id of items that were borrowed and expired
 
SELECT ITEM_NAME,ITEM_ID
FROM LOAN_INFO
WHERE LOAN_REC_NUM IN(SELECT LOAN_REC_NUM FROM EXP_INFO WHERE EXPIRED_DAYS!=0);
 
--9.List the ranking of the items which is most popular in staff
 
SELECT ITEM_NAME,COUNT(*)
FROM LOAN_INFO
WHERE MEMBER_ID IN (SELECT MEMBER_ID FROM MEMBER WHERE IDENTITY='Staff')
GROUP BY ITEM_NAME
ORDER BY COUNT(*) DESC;
 
--10.To check whether a member’s account is available when only name known
 
SELECT M.MEMBER_NAME,A.STATE,A.MEMBER_ID
FROM MEMBER M
JOIN ACCOUNT A ON M.MEMBER_ID=A.MEMBER_ID
WHERE M.MEMBER_NAME='Stephen Callaghan';
 
--11.To know the email address of the members who have submitted the reservation
 
SELECT M.EMAIL_ADD,M.MEMBER_ID,R.ITEM_NAME
FROM RESERV_INFO R
JOIN MEMBER M ON M.MEMBER_ID=R.MEMBER_ID
ORDER BY R.RESERVATION_DATE;
 
--12.Check when the book “To Kill a Mockingbird” is about to be available again
 
SELECT ITEM_NAME,DUE_DATE
FROM LOAN_INFO
WHERE ITEM_NAME='To Kill a Mockingbird' AND RETURN_DATE IS NULL
ORDER BY DUE_DATE;
