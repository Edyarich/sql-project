-- Сформулировать 5 смысловых запросов к БД словами.
-- Запросы должны содержать
-- GROUP BY + HAVING
-- ORDER BY
-- Оконные функции с использованием partition by, partition by + order by, order by.

-- 1. Вывести список турниров, за первое место в которых дают больше 50000$
-- В результате выполнения запроса 1 будут получены имена турниров и их идентификаторы,
-- которые удовлетворяют требуемому условию
select tournamentid, name
from final_project.tournament
where tournamentid in (
    select tournamentid
    from final_project.playerintournament
    group by tournamentid
    having max(cashprize) > 50000
);

-- 2. Вывести список дебютов, отсортированный по частотности в порядке убывания
-- В рез-те выполнения запроса 2 будет получен отсортированный по частотности список дебютов
-- вместе с их именами
/*create table sorted_organizers as (
    select debutcode, count(debutcode)
    from final_project.party
    group by debutcode
    order by count(debutcode) desc
);
select t1.count, t1.debutcode, t2.name
from sorted_debuts t1
join final_project.debuts t2
on t1.debutcode = t2.debutcode;*/

-- 3. Вывести информацию по всем турнирам о том, сколько денег в процентном соотношении к призовому фонду турнира
-- получил игрок
-- В рез-те выполнения запроса 3 будет получена информация о том,
-- сколько процентов от призового фонда турнира составила награда игрока
select playerid, tournamentid, cashprize,
       (100 * cashprize)::float4 / sum(cashprize) over (partition by tournamentid) as prize_total_perc
from final_project.playerintournament
where cashprize > 0;

-- 4. Вывести средний рейтинг участников турниров
-- В рез-те выполнения Запроса 4 будет получен средний рейтинг по всем участникам турнира
create table rating_player_in_tour as (
    select t1.*, t2.rating
    from final_project.playerintournament t1
    join final_project.player t2
    on t1.playerid = t2.playerid
)

select tournamentid,
       avg(rating) over (order by tournamentid range current row)
from rating_player_in_tour;

-- 5. Вывести изменения рейтинга по датам у всех игроков
-- В рез-те выполнения Запроса 5 будут получены старый и новый рейтинг относительно каждой даты обновления
select playerid, updatetime,
       lag(rating, 1, null) over (partition by playerid order by updatetime) as prev_rating,
       rating as curr_rating
from final_project.playerhistory;