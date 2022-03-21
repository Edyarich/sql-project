/* Создать 2 хранимых процедуры. Логика работы обговаривается с семинаристом. */
-- 1. Вывести ТОП-n шахматистов (по рейтингу) на момент t
create or replace function top_chess_players(t date, top_length int) returns
table(serial int, namesurname varchar(256), country varchar(128), rating smallint) as $$
    with ph_time_ranges as (
        select playerid,
               updatetime as date_from,
               country,
               rating,
               lead(updatetime, 1, 'infinity') over
                   (partition by playerid order by updatetime) as date_to
        from final_project.playerhistory
    )
    select ph.playerid,
           p.namesurname,
           ph.country,
           ph.rating
    from ph_time_ranges ph
    left join final_project.player p
        on ph.playerid = p.playerid
    where t between date_from and date_to
    order by rating desc
    limit top_length;
$$ language sql;
