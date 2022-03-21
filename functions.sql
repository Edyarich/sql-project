/* Создать индексы для таблиц, аргументировав выбор поля, по которому будет создан индекс. */
create function hello_world() returns text as $$
    select 'Hello, world!'
$$ language sql;

create or replace function reverse_str(str text) returns text as $$
    declare
        result text := '';
        i int;
    begin
        for i in  1..length(str) by 2 loop
            result = substr(str, i + 1, 1) || substr(str, i , 1) || result;
        end loop;
        return result;
    end;
$$ language plpgsql;

create or replace function factorial(num int) returns int as $$
    begin
        if num = 0 or num = 1 then
            return 1;
        end if;
        return num * factorial(num - 1);
    end;
$$ language plpgsql;


select * from hello_world();

select * from reverse_str('Hello, world!');

select * from factorial(6);
