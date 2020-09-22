--создать 2 пользователя + привилегии
--system_connection
create user CJA1 identified by 12345678;
grant all privileges to CJA1; 

create user CJA2 identified by 12345678;
grant all privileges to CJA2;

--создаем connection
--lab3_ris1 - CJA1(12345678)
--lab3_ris2 - CJA2(12345678)

--создать 2 таблицы на 2 серверах
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

--создать dblink типа user1-user1 между юзерами на разных С
--lab3_ris1
CREATE DATABASE LINK cja2_db 
   CONNECT TO CJA2
   IDENTIFIED BY "12345678"       -- у cja2
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


--нарушение уникальности на удаленном сервере
begin
   insert into XXX values(5);   --
   insert into YYY@cja2_db values(3);
end;

--заблокируется и будет ожидать освобождения ресурса  
delete from YYY;                    --lab3_ris2
insert into YYY@cja2_db values (6);  --lab3_ris1

commit
--очистить таблицы   
begin
   delete XXX;
   delete YYY@cja2_db;
end;
select * from xxx;
select * from YYY@cja2_db;
