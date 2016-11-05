/*
Task 2.
            	������� ���������� �������� ��������� ���������. ������ ������ �������� ����� ��������, ��������, ���� ������.
��� ���������� ������� �������� ����������� �����, � ������� ����������� ������ ��������� �������, ���� ������������ ������, � ����� ����� �����.
               
            	������� ������� �������� ��������.
�������� SQL �������:
- ������� ��� ������ �� ��������� ������ � ����� ������ ������ > $500
- ������� ������, � ������� ������������ �������� ������ "Samsung"

���� ������� EVENT_PHONES � ���������� 
ref			--������� ������
Clid			--�� ������� ������� ����� �������
NAME			--�������� ��������
MODEL			--������ ��������
DESCRIPTION		--�������� ��������
PRICE			--���� ������
DATE_BOUTH		--���� ������� ������
TOTAL_SUM		--����� ����� ������� �������
*/
--������� �������
--������� ��������� ������� ������ ���������
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
--��������� ������ � ������� load table
load table EVENT_PHONES( 
ref '|',
Clid '|',
NAME '|',
MODEL '|',
DESCRIPTION '|',
PRICE '|',
DATE_BOUTH '\x0d\x0a'
)
using client file 'D:\auto.txt'  -- ������������ ���� c ������� �� ������ � �������� c ������������ '|'
             quotes off
             escapes off
;
commit;

--������� ������� EVENT_PHONES 

--������� ������ ������� ������ �������
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

--��������� ����� ������� �������
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
where trim(upper(NAME)) = 'SAMSUNG'
;commit;


� ����� � ��� � ���� ���������� 2 ������� 
query1   --��� ������ �� ��������� ������ �� ����� >500
query2   --������, � ������� ������������ �������� ������ "Samsung"