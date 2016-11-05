/*
Task 2.
            	Магазин занимается продажей мобильных телефонов. Каждая модель телефона имеет название, описание, цену товара.
При совершении покупки клиентом формируется заказ, в котором описывается список купленных товаров, дата формирования заказа, а также общая сумма.
               
            	Создать таблицы согласно описанию.
Написать SQL запросы:
- выбрать все заказы за последнюю неделю с общем суммой заказа > $500
- выбрать заказы, в которых присутствуют телефоны модели "Samsung"

Поля таблицы EVENT_PHONES с телефонами 
ref			--Рефернс заказа
Clid			--ИД клеинта который купил телефон
NAME			--Название телефона
MODEL			--Модель телефона
DESCRIPTION		--Описание телефона
PRICE			--Цена товара
DATE_BOUTH		--Дата покупки товара
TOTAL_SUM		--Общая сумму покупки клиента
*/
--Создаем таблицу
--создаем временную таблицу нужной структуры
create table EVENT_PHONES (
ref char(50),
Clid int,
NAME varchar(255),
MODEL varchar(150),
DESCRIPTION varchar(255),
PRICE numeric(15,2),
DATE_BOUTH datetime
)
;
commit;
--загружаем данные с помощью load table
load table EVENT_PHONES( 
ref '|',
Clid '|',
NAME '|',
MODEL '|',
DESCRIPTION '|',
PRICE '|',
DATE_BOUTH '\x0d\x0a'
)
using client file 'D:\auto.txt'  -- прогружаемый файл c данными по данным о покупках c разделителем '|'
             quotes off
             escapes off
;
commit;

--Создана таблица EVENT_PHONES 

--выводим список покупок одного клиента
select distinct
ref,
Clid,
NAME,
MODEL,
DESCRIPTION,
PRICE,
DATE_BOUTH,
convert(numeric(15,2), null) as TOTAL_SUM
into #EVENT_PHONES 
from EVENT_PHONES
;

--вычесляем сумму покупок клиента
select distinct
Clid,
sum(PRICE) as TOTAL_SUM
into #sum
from #EVENT_PHONES
group by Clid


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
where trim(upper(NAME)) = 'SAMSUNG'
;commit;


В ЭТОГЕ У НАС В БАЗЕ ПОЛУЧАЕТСЯ 2 ТАБЛИЦЫ 
query1   --все заказы за последнюю неделю на сумму >500
query2   --заказы, в которых присутствуют телефоны модели "Samsung"