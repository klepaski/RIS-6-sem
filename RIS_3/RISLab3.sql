--������� 2 ������������ + ����������
--system_connection
create user CJA1 identified by 12345678;
grant all privileges to CJA1; 

create user CJA2 identified by 12345678;
grant all privileges to CJA2;

--������� connection
--lab3_ris1 - CJA1(12345678)
--lab3_ris2 - CJA2(12345678)

--������� 2 ������� �� 2 ��������
--lab3_ris1
drop table XXX;
create table XXX(
  x int primary key
);

--lab3_ris2
drop table YYY;
create table YYY(
  y int primary key
);

--������� dblink ���� user1-user1 ����� ������� �� ������ �
--lab3_ris1
CREATE DATABASE LINK cja2_db 
   CONNECT TO CJA2
   IDENTIFIED BY "12345678"       -- � cja2
   USING 'localhost:1521/orcl.168.1.102';

Select * from YYY@cja2_db;

 
--insert - insert   
begin
   INSERT INTO YYY@cja2_db values(4);
   INSERT INTO XXX values(1);
   Commit;
end;
select * from XXX;
select * from YYY@cja2_db;

--insert-update   
begin
   insert into XXX values(3);
   update YYY@cja2_db SET y=5 where y=4;
   commit;
end;
select * from XXX;
select * from YYY@cja2_db;

--update-insert
begin
   insert into YYY@cja2_db values(3);
   update XXX set x=4 where x=1;
   commit;
end;
select * from XXX;
select * from YYY@cja2_db;


--��������� ������������ �� ��������� �������
begin
   insert into XXX values(5);   --
   insert into YYY@cja2_db values(3);
end;

--������������� � ����� ������� ������������ �������  
delete from YYY;                    --lab3_ris2
insert into YYY@cja2_db values (6);  --lab3_ris1

commit
--�������� �������   
begin
   delete XXX;
   delete YYY@cja2_db;
end;
select * from xxx;
select * from YYY@cja2_db;
