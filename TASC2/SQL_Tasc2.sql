/*
Task 2.
            	Магазин занимается продажей мобильных телефонов. Каждая модель телефона имеет название, описание, цену товара.
При совершении покупки клиентом формируется заказ, в котором описывается список купленных товаров, дата формирования заказа, а также общая сумма.
               
            	Создать таблицы согласно описанию.
Написать SQL запросы:
- выбрать все заказы за последнюю неделю с общем суммой заказа > $500
- выбрать заказы, в которых присутствуют телефоны модели "Samsung"


--таблица №1 клиентов  EVENT_CLIENT
Clid   --ID клиента
NAME   --ФИО КЛИЕНТА
MAIL	 --ИМЕЙЛ КЛИЕНТА


--таблица №2 телефонов EVENT_PHONES
Clid_phone      --ID телефона
NAME			--Название телефона
MODEL			--Модель телефона
DESCRIPTION		--Описание телефона
PRICE			--Цена товара


--таблица №3 покупок EVENT_BUY
ref			--Рефернс заказа
Clid   		--ID клиента покупателя
Clid_phone	--ID телефона
DATE_BOUTH 	--Время покупки
PRICE		--Цена товара

*/


--Создаем таблицу №1 EVENT_CLIENT 
--создаем временную таблицу нужной структуры
create table EVENT_CLIENT (
Clid int,
NAME varchar(255),
MAIL varchar(150)
)
;
commit;
--загружаем данные с помощью load table
load table EVENT_CLIENT( 
Clid '|',
NAME '|',
MAIL '\x0d\x0a'
)
using client file 'D:\EVENT_CLIENT.txt'  -- прогружаемый файл c данными по данным о покупках c разделителем '|'
             quotes off
             escapes off
;
commit;


--Создаем таблицу №2 EVENT_PHONES
--создаем временную таблицу нужной структуры
create table EVENT_PHONES (
Clid_phone int,
NAME varchar(255),
MODEL varchar(150),
DESCRIPTION varchar(255),
PRICE numeric(15,2)
)
;
commit;
--загружаем данные с помощью load table
load table EVENT_PHONES( 
Clid '|',
NAME '|',
MODEL '|',
DESCRIPTION '|',
PRICE '\x0d\x0a'
)
using client file 'D:\EVENT_PHONES.txt'  -- прогружаемый файл c данными по данным о покупках c разделителем '|'
             quotes off
             escapes off
;
commit;


--Создаем таблицу №3 EVENT_BUY
--создаем временную таблицу нужной структуры
create table EVENT_BUY (
ref char(50),
Clid int,
Clid_phone int,
PRICE numeric(15,2),
DATE_BOUTH datetime
)
;
commit;
--загружаем данные с помощью load table
load table EVENT_BUY( 
ref '|',
Clid '|'
Clid_phone '|',
PRICE '|',
DATE_BOUTH '\x0d\x0a'
)
using client file 'D:\EVENT_BUY.txt'  -- прогружаемый файл c данными по данным о покупках c разделителем '|'
             quotes off
             escapes off
;
commit;

															/*Решение*/

--выводим список покупок одного клиента
/*

--таблица №1 клиентов  EVENT_CLIENT
Clid   --ID клиента
NAME   --ФИО КЛИЕНТА
MAIL   --ИМЕЙЛ КЛИЕНТА


--таблица №2 телефонов EVENT_PHONES
Clid_phone      --ID телефона
NAME			--Название телефона
MODEL			--Модель телефона
DESCRIPTION		--Описание телефона
PRICE			--Цена товара


--таблица №3 покупок EVENT_BUY
ref			--Рефернс заказа
Clid   		--ID клиента покупателя
Clid_phone	--ID телефона
DATE_BOUTH 	--Время покупки
PRICE			--Цена товара
*/


select distinct
t1.ref,										--Рефернс заказа
t1.DATE_BOUTH, 								--Время покупки
t1.PRICE,									--Цена товара
t2.Clid,   									--ID клиента
t2.NAME as Name_cli,    					--ФИО КЛИЕНТА
t2.MAIL,   									--ИМЕЙЛ КЛИЕНТА
t3.NAME as name_phone,						--Название телефона
t3.MODEL,			    					--Модель телефона
t3.DESCRIPTION,		    					--Описание телефона
convert(numeric(15,2), null) as TOTAL_SUM	--Общая сумма покупки
into #EVENT_PHONES 
from EVENT_BUY  as t1 left join EVENT_CLIENT as t2 on t1.Clid=t2.Clid
						left join EVENT_PHONES as t3 on t1.Clid_phone=t2.Clid_phone
;

--вычесляем сумму покупок клиента
select
Clid,
sum(PRICE) as TOTAL_SUM
into #sum
from #EVENT_PHONES
group by Clid
;


update #EVENT_PHONES
set t1.TOTAL_SUM=t2.TOTAL_SUM
from #EVENT_PHONES as t1 left join #sum as t2 on t1.Clid=t2.Clid
where t1.TOTAL_SUM is null;




--все заказы за последнюю неделю на сумму >500

select distinct
ref,
Clid,
TOTAL_SUM
into query1
from #EVENT_PHONES
where DATE_BOUTH between dateadd(day,-7, DATE_BOUTH) and getdate()
	and convert(int,TOTAL_SUM)>500
;

--выбрать заказы, в которых присутствуют телефоны модели "Samsung"
select distinct
ref,
Clid,
TOTAL_SUM
into query2
from #EVENT_PHONES
where trim(upper(name_phone)) = 'SAMSUNG'
;commit;


--В ЭТОГЕ У НАС В БАЗЕ ПОЛУЧАЕТСЯ 2 ТАБЛИЦЫ 
query1   --все заказы за последнюю неделю на сумму >500
query2   --заказы, в которых присутствуют телефоны модели "Samsung"