--b) Explorar la tabla “menu items” para conocer los productos del menú.
SELECT * from menu_items;

--Encontrar el número de artículos en el menú: 32 artículos
SELECT COUNT (DISTINCT menu_item_id) FROM menu_items;

--¿Cuál es el artículo menos caro y el más caro en el menú?: Shrim Scampi
SELECT item_name, price FROM menu_items
ORDER BY price DESC
LIMIT 1;


--¿Cuántos platos americanos hay en el menú?: 6 platillos

SELECT category, item_name from menu_items
WHERE category='American';

--¿Cuál es el precio promedio de los platos?13.29
SELECT AVG(price) from menu_items

--REDONDEAMOS
SELECT ROUND(AVG(price),2) from menu_items

--CON ALIAS
SELECT ROUND(AVG(price),2) AS precio_promedio
from menu_items;

--COMPROBANDO 425.15 / 32 art
SELECT SUM(price) from menu_items;




--c) Explorar la tabla “order details” para conocer los datos que han sido recolectados.
SELECT * FROM order_details;

--1.- Realizar consultas para contestar las siguientes preguntas:

-- ¿Cuántos pedidos únicos se realizaron en total? 5,370
SELECT COUNT (DISTINCT order_id) FROM order_details AS total_pedidos;


--¿Cuáles son los 5 pedidos que tuvieron el mayor número de artículos?

SELECT order_id, COUNT(*) AS total_articulos
FROM order_details
GROUP BY order_id
ORDER BY total_articulos DESC
LIMIT 5;

-- COMPROBAMOS
SELECT order_id, COUNT(*) AS total_articulos
FROM order_details
GROUP BY order_id

SELECT * FROM order_details;

--¿Cuándo se realizó el primer pedido y el último pedido? 2023-01-01 y 2023-03-31 
SELECT MIN(order_date) AS PRIMER, MAX (order_date) AS ULTIMO  FROM order_details

-- En qué hora se realizó el primer pedido y el último pedido 10:50:46 y 23:05:24
SELECT MIN(order_time) AS PRIMER, MAX (order_time) AS ULTIMO  FROM order_details


--¿Cuántos pedidos se hicieron entre el '2023-01-01' y el '2023-01-05'? 702 PEDIDOS
SELECT order_details_id, order_date FROM order_details
WHERE order_date BETWEEN '2023-01-01' and '2023-01-05'
ORDER BY order_date;

--CUANTOS CLIENTES HUBO ENTRE ESAS FECHAS: 308 CLIENTES
SELECT DISTINCT(order_id), order_date FROM order_details
WHERE order_date BETWEEN '2023-01-01' and '2023-01-05'
ORDER BY order_date;


SELECT * FROM order_details
WHERE order_date BETWEEN '2023-01-01' and '2023-01-05'
ORDER BY order_date;





--d) Usar ambas tablas para conocer la reacción de los clientes respecto al menú.


--1.- Realizar un left join entre entre order_details y menu_items con el identificador

select * 
FROM order_details AS OD
LEFT JOIN menu_items AS ME
	ON OD.item_id=ME.menu_item_id



-- Cuánto se gastó por cliente (pedido)?

SELECT ord.order_id, SUM(mi.price) AS GASTO_CLIENTE
FROM order_details AS ord 
LEFT JOIN menu_items AS mi
	ON ord.item_id=mi.menu_item_id
GROUP BY 1
ORDER BY order_id ASC

-- EL CLIENTE QUE MÁS GASTÓ: EL CLIENTE DEL PEDIDO 440 GASTÓ $192.15
-- HALLAZGO: CONSECUTIVO= PROBABLES PEDIDOS CANCELADOS

SELECT ord.order_id, SUM(mi.price) AS GASTO_CLIENTE
FROM order_details AS ord 
LEFT JOIN menu_items AS mi
	ON ord.item_id=mi.menu_item_id
GROUP BY 1
ORDER BY GASTO_CLIENTE DESC

-- YA SABEMOS EL CLIENTE-PÉDIDO MÁS GRANDE, PERO CUÁL ES PRECIO PROMEDIO POR CLIENTE-PEDIDO
SELECT AVG(total_price) AS PROMEDIO_CONSUMO_CLIENTE
FROM (
    SELECT SUM(mi.price) AS total_price
    FROM order_details AS ord
    LEFT JOIN menu_items AS mi
        ON ord.item_id = mi.menu_item_id
    GROUP BY ord.order_id
) AS subquery;
	


--¿Cuál fueron los 10 platillos más vendido del menú? 1- hamburger 2-Edamame 3-Korean Beef Bowl 4-Cheeseburger
--5-French Fries 6-Tofu Pad Thai 7- Steak Torta 8- Spoaghetti & Meatballs 9-Mac&cheese 10-Chips&Salsa

SELECT item_name, COUNT(order_id) 
FROM order_details AS ord 
LEFT JOIN menu_items AS mi
	ON ord.item_id=mi.menu_item_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

--¿Cuántos pedidos hubo por categoría? ASIAN-3470, ITALIAN-2948, MEXICAN-2945, AMERICAN-2734
SELECT category, COUNT (order_id) 
FROM order_details AS ord 
LEFT JOIN menu_items AS mi
	ON ord.item_id=mi.menu_item_id
GROUP BY 1
ORDER BY 2 DESC;


--Encontrar el número de artículos en el menú: 32
SELECT DISTINCT item_name FROM menu_items;

COMPROBAR

SELECT COUNT (DISTINCT menu_item_id) FROM menu_items;


--¿Cuántos platillos hay en el menú por cada categoria? 9 MEX, 9 ITALIAN, 8 ASIAN, 6 AMER

SELECT COUNT(item_name) as PLATILLOS, category 
FROM menu_items
GROUP BY category
ORDER BY PLATILLOS DESC;



--¿En cuántas ordenes pidieron comida de la categoria 'Asian' O 'Mexican'? (El pedido debe tener cualquiera de las dos categorias)
--5,679 ordenes

SELECT COUNT(order_details_id)
FROM order_details AS ord 
LEFT JOIN menu_items AS mi
	ON ord.item_id=mi.menu_item_id
WHERE category='American' OR category='Mexican';


-- EXPLORACION UNIR TABLA
SELECT mi.menu_item_id, mi.item_name, mi.category, mi.price, ord.order_details_id, ord.order_id, ord.order_date, ord.order_time, ord.item_id
FROM menu_items AS mi
LEFT JOIN order_details as ord
ON mi.menu_item_id = ord.item_id
ORDER BY PRICE DESC


-- VENTAS POR CATEGORIA 

SELECT mi.category, SUM(mi.price) AS ventas_totales
FROM menu_items AS mi
INNER JOIN order_details AS ord
ON mi.menu_item_id = ord.item_id
GROUP BY mi.category
ORDER BY ventas_totales DESC;

-- MAYOR PEDIDOS X CATEGORIA
SELECT mi.category, COUNT(ord.order_details_id) AS pedidos_totales
FROM menu_items AS mi
INNER JOIN order_details AS ord
ON mi.menu_item_id = ord.item_id
GROUP BY mi.category
ORDER BY pedidos_totales DESC;


--QUIERO HACER CATEGORIA POR HORARIO, COMIDA- DESAYUNO , CENA, PARA VER GANANCIAS POR HORARIO (10:50:46 y 23:05:24)

-- SI PERO NO QUIERO CATEGORIAS - pero suman 12,097 pedidos categorizados en 3 franjas horarias

SELECT 
    mi.category, 
    COUNT(ord.order_details_id) AS pedidos_totales,
    CASE 
	    WHEN ord.order_time BETWEEN '10:00:00' AND '13:59:59' THEN 'BRUNCH'
        WHEN ord.order_time BETWEEN '14:00:00' AND '18:59:59' THEN 'COMIDA'
        WHEN ord.order_time BETWEEN '19:00:00' AND '23:59:59' THEN 'CENA'
        ELSE 'OTRO'
    END AS HORARIO
FROM 
    menu_items AS mi
INNER JOIN 
    order_details AS ord
ON 
    mi.menu_item_id = ord.item_id
GROUP BY 
    mi.category, HORARIO
ORDER BY 
    mi.category;

	-- CATEGORIZAMOS POR HORARIO:
 -- HAY VALORES NULOS EN ALGUNOS HORARIOS, PRIMERO HAY QUE BORRAR LOS NULL DEL ITEM ID

 SELECT *
 FROM order_details is not null

 
SELECT 
   order_time, 
   CASE
        WHEN order_time BETWEEN '10:00:00' AND '13:59:59' THEN 'BRUNCH'
        WHEN order_time BETWEEN '14:00:00' AND '18:59:59' THEN 'COMIDA'
        WHEN order_time BETWEEN '19:00:00' AND '23:59:60' THEN 'CENA'
        ELSE 'OTRO'
    END AS HORARIO
FROM order_details;

-- sin los nulos muestrame
SELECT 
   order_time, 
   CASE
        WHEN order_time BETWEEN '10:00:00' AND '13:59:59' THEN 'BRUNCH'
        WHEN order_time BETWEEN '14:00:00' AND '18:59:59' THEN 'COMIDA'
        WHEN order_time BETWEEN '19:00:00' AND '23:59:60' THEN 'CENA'
        ELSE 'OTRO'
    END AS HORARIO
FROM order_details
where item_id is not NULL;



-- QUIERO SABER  EN QUÉ HORARIO HAY MÁS PEDIDOS: EN LA COMIDA HAY 5,450
SELECT 
    CASE
        WHEN order_time BETWEEN '10:00:00' AND '13:59:59' THEN 'BRUNCH'
        WHEN order_time BETWEEN '14:00:00' AND '18:59:59' THEN 'COMIDA'
        WHEN order_time BETWEEN '19:00:00' AND '23:59:59' THEN 'CENA'
        ELSE 'OTRO'
    END AS HORARIO,
    COUNT(order_time) AS PEDIDOS
FROM 
    order_details
GROUP BY 
    CASE
        WHEN order_time BETWEEN '10:00:00' AND '13:59:59' THEN 'BRUNCH'
        WHEN order_time BETWEEN '14:00:00' AND '18:59:59' THEN 'COMIDA'
        WHEN order_time BETWEEN '19:00:00' AND '23:59:59' THEN 'CENA'
        ELSE 'OTRO'
    END
	ORDER BY PEDIDOS DESC;


	-- AHORA SIN NULOS
SELECT 
    CASE
        WHEN order_time BETWEEN '10:00:00' AND '13:59:59' THEN 'BRUNCH'
        WHEN order_time BETWEEN '14:00:00' AND '18:59:59' THEN 'COMIDA'
        WHEN order_time BETWEEN '19:00:00' AND '23:59:59' THEN 'CENA'
        ELSE 'OTRO'
    END AS HORARIO,
    COUNT(order_time) AS PEDIDOS
FROM 
    order_details
WHERE item_id is not NULL
GROUP BY 
    CASE
        WHEN order_time BETWEEN '10:00:00' AND '13:59:59' THEN 'BRUNCH'
        WHEN order_time BETWEEN '14:00:00' AND '18:59:59' THEN 'COMIDA'
        WHEN order_time BETWEEN '19:00:00' AND '23:59:59' THEN 'CENA'
        ELSE 'OTRO'
    END
	ORDER BY PEDIDOS DESC;


	

--ALGO MAL: 137 ORDENES NO CONTINEN PLATILLOS
SELECT COUNT(*) AS Null_Values
FROM order_details
WHERE item_id IS NULL;



SELECT DISTINCT order_time
FROM order_details;


-- COMPRUEBO TOTAL  ORDENES SON 12,234 PERO 137 NO TRAEN PLATILLOS
SELECT COUNT(order_details_id) FROM order_details


SELECT *
FROM order_details
WHERE item_id IS NULL OR item_id = '';

-- MAYOR GANANCIA X CATEGORIA BRUNCH (TOP 1 EN EL BRUNCH =ITALIAN)
SELECT 
    M.category, 
    CASE
        WHEN O.order_time BETWEEN '10:00:00' AND '13:59:59' THEN 'BRUNCH'
        ELSE 'OTRO'
    END AS HORARIO,
    SUM(M.price) AS GANANCIA
FROM 
    menu_items AS M
INNER JOIN 
    order_details AS O
ON 
    M.menu_item_id = O.item_id
WHERE
    O.order_time BETWEEN '10:00:00' AND '13:59:59'
GROUP BY 
    M.category, 
    CASE
        WHEN O.order_time BETWEEN '10:00:00' AND '13:59:59' THEN 'BRUNCH'
        ELSE 'OTRO'
    END
	ORDER BY ganancia DESC;



-- QUE COMIDA TIENE MAYORES GANANCIAS Y CUAL MAYORES PEDIDOS. GANCIAS LA ITALIANA Y PEDIDOS LA ASIÁTICA

SELECT M.category, SUM(M.price) AS PRECIO_TOTAL, COUNT(O.order_details_id) TOTAL_ORDEN
FROM 
    menu_items AS M
INNER JOIN 
    order_details AS O
ON 
    M.menu_item_id = O.item_id
GROUP BY M.category
ORDER BY PRECIO_TOTAL DESC



-- DENTRO DE LA COMIDA ITALIANA CUÁL ES EL PLATILLO QUE MÁS GANANCIAS NOS DA: SPAGHETTI & MEATBALLAS


SELECT M.item_name, SUM(M.price) AS GANANCIA
FROM menu_items AS M
INNER JOIN order_details AS O
    ON M.menu_item_id = O.item_id
WHERE M.category = 'Italian'
GROUP BY M.item_name  -- Solo agrupamos por item_name
ORDER BY GANANCIA DESC;




--CUANTOS PEDIDOS HAY DURANTE EL BRUNCH: 3,882
SELECT 
    COUNT(order_details_id) AS TOTAL_PEDIDOS
FROM 
    order_details
WHERE 
    order_time BETWEEN '10:00:00' AND '13:59:59';






-- EXPLORANDO LAS ORDENES PARA SACAR LOS PEDIDOS X CATEGORIA
SELECT mi.category,
       COUNT(ord.order_details_id) AS TOTAL_ORDEN
FROM menu_items AS mi
INNER JOIN order_details AS ord
  ON mi.menu_item_id = ord.item_id
GROUP BY mi.category

--venta ordenes x dia x categoria
SELECT mi.category, ord.order_date,
       COUNT(ord.order_details_id) AS TOTAL_ORDEN
FROM menu_items AS mi
INNER JOIN order_details AS ord
  ON mi.menu_item_id = ord.item_id
GROUP BY mi.category, ord.order_date
ORDER BY order_date asc

--PEDIDOS x categoria solo un día
SELECT mi.category, ord.order_date,
       COUNT(ord.order_details_id) AS TOTAL_ORDEN
FROM menu_items AS mi
INNER JOIN order_details AS ord
  ON mi.menu_item_id = ord.item_id
 WHERE order_date='2023-01-01'
GROUP BY mi.category, ord.order_date
ORDER BY order_date asc



