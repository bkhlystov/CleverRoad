/*
Task 2.
            	������� ���������� �������� ��������� ���������. ������ ������ �������� ����� ��������, ��������, ���� ������.
��� ���������� ������� �������� ����������� �����, � ������� ����������� ������ ��������� �������, ���� ������������ ������, � ����� ����� �����.
               
            	������� ������� �������� ��������.
�������� SQL �������:
- ������� ��� ������ �� ��������� ������ � ����� ������ ������ > $500
- ������� ������, � ������� ������������ �������� ������ "Samsung"


--������� �1 ��������  EVENT_CLIENT
Clid   --ID �������
NAME   --��� �������
MAIL	 --����� �������


--������� �2 ��������� EVENT_PHONES
Clid_phone      --ID ��������
NAME			--�������� ��������
MODEL			--������ ��������
DESCRIPTION		--�������� ��������
PRICE			--���� ������


--������� �3 ������� EVENT_BUY
ref			--������� ������
Clid   		--ID ������� ����������
Clid_phone	--ID ��������
DATE_BOUTH 	--����� �������
PRICE		--���� ������

*/


--������� ������� �1 EVENT_CLIENT 
--������� ��������� ������� ������ ���������
create table EVENT_CLIENT (
Clid int,
NAME varchar(255),
MAIL varchar(150)
)
;
commit;
--��������� ������ � ������� load table
load table EVENT_CLIENT( 
Clid '|',
NAME '|',
MAIL '\x0d\x0a'
)
using client file 'D:\EVENT_CLIENT.txt'  -- ������������ ���� c ������� �� ������ � �������� c ������������ '|'
             quotes off
             escapes off
;
commit;


--������� ������� �2 EVENT_PHONES
--������� ��������� ������� ������ ���������
create table EVENT_PHONES (
Clid_phone int,
NAME varchar(255),
MODEL varchar(150),
DESCRIPTION varchar(255),
PRICE numeric(15,2)
)
;
commit;
--��������� ������ � ������� load table
load table EVENT_PHONES( 
Clid '|',
NAME '|',
MODEL '|',
DESCRIPTION '|',
PRICE '\x0d\x0a'
)
using client file 'D:\EVENT_PHONES.txt'  -- ������������ ���� c ������� �� ������ � �������� c ������������ '|'
             quotes off
             escapes off
;
commit;


--������� ������� �3 EVENT_BUY
--������� ��������� ������� ������ ���������
create table EVENT_BUY (
ref char(50),
Clid int,
Clid_phone int,
PRICE numeric(15,2),
DATE_BOUTH datetime
)
;
commit;
--��������� ������ � ������� load table
load table EVENT_BUY( 
ref '|',
Clid '|'
Clid_phone '|',
PRICE '|',
DATE_BOUTH '\x0d\x0a'
)
using client file 'D:\EVENT_BUY.txt'  -- ������������ ���� c ������� �� ������ � �������� c ������������ '|'
             quotes off
             escapes off
;
commit;

															/*�������*/

--������� ������ ������� ������ �������
/*

--������� �1 ��������  EVENT_CLIENT
Clid   --ID �������
NAME   --��� �������
MAIL   --����� �������


--������� �2 ��������� EVENT_PHONES
Clid_phone      --ID ��������
NAME			--�������� ��������
MODEL			--������ ��������
DESCRIPTION		--�������� ��������
PRICE			--���� ������


--������� �3 ������� EVENT_BUY
ref			--������� ������
Clid   		--ID ������� ����������
Clid_phone	--ID ��������
DATE_BOUTH 	--����� �������
PRICE			--���� ������
*/


select distinct
t1.ref,										--������� ������
t1.DATE_BOUTH, 								--����� �������
t1.PRICE,									--���� ������
t2.Clid,   									--ID �������
t2.NAME as Name_cli,    					--��� �������
t2.MAIL,   									--����� �������
t3.NAME as name_phone,						--�������� ��������
t3.MODEL,			    					--������ ��������
t3.DESCRIPTION,		    					--�������� ��������
convert(numeric(15,2), null) as TOTAL_SUM	--����� ����� �������
into #EVENT_PHONES 
from EVENT_BUY  as t1 left join EVENT_CLIENT as t2 on t1.Clid=t2.Clid
						left join EVENT_PHONES as t3 on t1.Clid_phone=t2.Clid_phone
;

--��������� ����� ������� �������
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




--��� ������ �� ��������� ������ �� ����� >500

select distinct
ref,
Clid,
TOTAL_SUM
into query1
from #EVENT_PHONES
where DATE_BOUTH between dateadd(day,-7, DATE_BOUTH) and getdate()
	and convert(int,TOTAL_SUM)>500
;

--������� ������, � ������� ������������ �������� ������ "Samsung"
select distinct
ref,
Clid,
TOTAL_SUM
into query2
from #EVENT_PHONES
where trim(upper(name_phone)) = 'SAMSUNG'
;commit;


--� ����� � ��� � ���� ���������� 2 ������� 
query1   --��� ������ �� ��������� ������ �� ����� >500
query2   --������, � ������� ������������ �������� ������ "Samsung"