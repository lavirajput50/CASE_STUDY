use swiggy;
/* 1. find customer who have never ordered 
2. Average price/dish
3. find top restautant in terms of number of orders for a given month 
4. restaurants with montly sales>x for
5.show all orders with order details for a particular customer in a particular date range 
6. Find restaurants with max repeated customers
7. month over month revenue growth of swiggy.
8. customer -> fav food
*/
--- find customer who have never ordered 
SELECT NAME FROM [ USERS] WHERE USER_ID NOT IN (SELECT USER_ID FROM ORDERS);
---Average price/dish
SELECT FOOD.F_NAME AS FOOD_NAME,AVG(PRICE) AS AVERAGE_PRICE FROM MENU JOIN FOOD ON MENU.F_ID=FOOD.F_ID GROUP BY MENU.F_ID,FOOD.F_NAME;


---find top restautant in terms of number of orders for a given month
SELECT TOP 1 R.R_NAME,COUNT(MONTH(DATE)) AS 'ALL ORDER' FROM RESTAURANTS AS R JOIN ORDERS AS O ON R.R_ID=O.R_ID WHERE MONTH(DATE)=7   GROUP BY O.R_ID,R.R_NAME,MONTH(DATE) ORDER BY COUNT(*) DESC ;

 
 ---restaurants with montly sales>x for
SELECT R.R_NAME,COUNT(MONTH(DATE)) AS 'ALL ORDER',SUM(O.AMOUNT)AS TOTAL_SALES FROM RESTAURANTS AS R JOIN ORDERS AS O ON R.R_ID=O.R_ID WHERE MONTH(DATE)=7  GROUP BY O.R_ID,R.R_NAME,MONTH(DATE) HAVING SUM(O.AMOUNT)>500 ORDER BY COUNT(*) DESC  ;


---show all orders with order details for a particular customer in a particular date range 
SELECT*FROM ORDERS O JOIN RESTAURANTS R ON O.R_ID=R.R_ID WHERE USER_ID=(SELECT USER_ID FROM [ USERS]  WHERE NAME='ANKIT') AND (DATE >'2022-06-10' AND DATE < '2023-07-10');
---Find restaurants with max repeated customers
SELECT MAX(S.NAME) AS MOSTLY_ORDER,MAX(CNT) AS LOYAl_USER FROM (SELECT O.R_ID,R.R_NAME AS NAME,COUNT(USER_ID) AS CNT FROM RESTAURANTS R JOIN ORDERS O ON R.R_ID=O.R_ID GROUP BY O.R_ID,R.R_NAME,USER_ID) AS S;

--customer -> fav food
WITH TEM AS (
    SELECT O.USER_ID, O2.F_ID, COUNT(*) AS FREQUENCY 
    FROM ORDERS O 
    JOIN ORDER_DETAILS O2 ON O.ORDER_ID = O2.ORDER_ID 
    GROUP BY O.USER_ID, O2.F_ID
)
SELECT U.NAME,F.F_NAME,FREQUENCY  FROM TEM T1 JOIN [ USERS] U ON U.USER_ID=T1.USER_ID JOIN FOOD F ON F.F_ID =T1.F_ID WHERE T1.FREQUENCY=(SELECT MAX(FREQUENCY) FROM TEM T2 WHERE T1.USER_ID=T2.USER_ID);

