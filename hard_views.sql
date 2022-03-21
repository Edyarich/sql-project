/* Создать 3 сложных представления.
Представления должны соединять несколько таблиц с целью получения осмысленной сводной таблицы,
   например статистика продаж, частота поставок на склад и т.п.
Вместе с кодом приложить описание представления.
*/

create schema hard_views;

-- 1. Общий счёт игроков в 5 турнире (количество побед, ничьих и поражений)
create or replace view hard_views.players_stats_in_t as
    with party_winners as (
        with tmp_tbl as (
            with t_parties as (
                select whiteplayerid, blackplayerid, score
                from final_project.party
                where tournamentid = 5
            )
            select pit.playerid, tp.*
            from final_project.playerintournament pit
                     join t_parties tp
                          on pit.playerid = tp.whiteplayerid or
                             pit.playerid = tp.blackplayerid
            where tournamentid = 5
        )
        select  tt.playerid,
                p.namesurname,
                case score
                    when 'W' then whiteplayerid
                    when 'B' then blackplayerid
                    else -1
                end as winnerid
        from tmp_tbl tt
        left join final_project.player p
            on p.playerid = tt.playerid
    )
    select  namesurname,
            count(case winnerid when playerid then winnerid end) as wins,
            count(case winnerid when -1 then winnerid end) as draws,
            count(case when winnerid != playerid then winnerid end) -
                count(case winnerid when -1 then winnerid end) as loses
    from party_winners
    group by playerid, namesurname;

-- 2. Статистика по игроку: % побед, % побед за белых/за черных, % ничьих
create or replace view hard_views.players_stat as
    with party_winners as (
        with tmp_tbl as (
            with parties as (
                select whiteplayerid, blackplayerid, score
                from final_project.party
            )
            select pl.playerid, pl.namesurname, p.*
            from final_project.player pl
                     join parties p
                          on pl.playerid = p.whiteplayerid or
                             pl.playerid = p.blackplayerid
        )
        select playerid, namesurname, score,
            case score
                when 'W' then whiteplayerid
                when 'B' then blackplayerid
                else -1
            end as winnerid
        from tmp_tbl
    )
    select  playerid, namesurname,
            count(winnerid) as games_cnt,
            round((count(case winnerid when playerid then winnerid end) *
                100::float / count(winnerid))::numeric, 2) as wins,
            round((count(case when winnerid = playerid and score = 'W' then winnerid end) *
                100::float / count(winnerid))::numeric, 2) as white_wins,
            round((count(case when winnerid = playerid and score = 'B' then winnerid end) *
                100::float / count(winnerid))::numeric, 2) as black_wins,
            round((count(case winnerid when -1 then winnerid end) *
                100::float / count(winnerid))::numeric, 2) as draws
    from party_winners
    group by playerid, namesurname
    order by wins desc, draws desc;

-- 3. Для каждого турнира посчитать средний рейтинг его участников
create or replace view hard_views.t_avg_rating as
    with rating_chronology as (
        with players_tournaments_times as (
            select t.tournamentid,
                   t.name as t_name,
                   pit.playerid,
                   t.datefrom
            from final_project.playerintournament pit
                     left join final_project.tournament t
                               on pit.tournamentid = t.tournamentid
        )
        select ptt.tournamentid,
               ptt.t_name,
               ptt.playerid,
               ph.rating,
               ptt.datefrom as tournament_date,
               ph.updatetime as date_from,
               lead(ph.updatetime, 1, date('infinity')) over
                   (partition by ptt.tournamentid, ptt.playerid
                   order by ph.updatetime) as date_to
        from players_tournaments_times ptt
                 left join final_project.playerhistory ph
                           on ph.playerid = ptt.playerid
    )
    select tournamentid,
           t_name,
           round(avg(rating)::numeric, 2) as mean_rating
    from rating_chronology
    where tournament_date between date_from and date_to
    group by tournamentid, t_name;

create or replace view hard_views.debuts as
    select *
    from final_project.moves

