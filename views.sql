/* Создать по 1 представлению на каждую таблицу.
Все представления должны храниться в отдельной схеме с представлениями.
В представлениях должен быть реализован механизм маскирования персональных данных
и скрытия технических полей (суррогатных ключей, полей версионности и т.п.). */

create schema views;

-- 2. Moves
create view views.long_parties as
    with long_parties as (
        select p.whiteplayerid,
               p.blackplayerid,
               m.moves,
               m.movescount,
               case p.score
                   when 'W' then '1:0'
                   when 'B' then '0:1'
                   when 'D' then '1/2:1/2'
                   end as score
        from final_project.moves m
                 left join final_project.party p on m.partyid = p.partyid
        where m.movescount >= 50
    )
    select wp.namesurname as WhitePlayer,
           bp.namesurname as BlackPlayer,
           lp.score, lp.movescount, lp.moves
    from long_parties lp
    left join final_project.player wp on wp.playerid = lp.whiteplayerid
    left join final_project.player bp on bp.playerid = lp.blackplayerid;


-- 3. Organizers
drop view if exists views.vip_organizers;
create or replace view views.vip_organizers as
    select name,
           totalspentsum,
            case email when '' then ''
               else left(email, 2) || '...' ||
                    right(email, length(email) - position('@' in email) + 1)
            end as ciphered_email
    from final_project.organizers
    where totalspentsum > 100000;

-- 4. Party
create or replace view views.black_sicilian_defense_parties as
    with correct_party_ids as (
        select partyid, whiteplayerid, blackplayerid, date
        from final_project.party
        where score = 'W'
    )
    select wp.namesurname as WhitePlayer,
           bp.namesurname as BlackPlayer,
           cpi.date as Date,
           m.moves as Moves
    from correct_party_ids cpi
    left join final_project.moves m on m.partyid = cpi.partyid
    left join final_project.player wp on wp.playerid = cpi.whiteplayerid
    left join final_project.player bp on bp.playerid = cpi.blackplayerid;

-- 5. Player
create or replace view views.young_masters as
    select namesurname,
           date_part('year', age(now()::date, datebirth)) as years,
           country,
           rating,
           left(passportnumber, 2) || repeat('*', length(passportnumber) - 2) as ciphered_password

    from final_project.player
    where date_part('year', age(now()::date, datebirth)) < 30 and
          rating >= 2000;

-- 6. PlayerHistory
create or replace view views.max_rating as
    with max_ratings as (
        select playerid, max(rating) as max_rating
        from final_project.playerhistory
        group by playerid
    )
    select p.namesurname, mr.max_rating
    from max_ratings mr
    left join final_project.player p on mr.playerid = p.playerid;

-- 7. PlayerInTournament
create or replace view views.prize_winners as
    with prize_winners as (
        select *
        from final_project.playerintournament
        where cashprize >= 40000
    )
    select p.namesurname as PlayerName,
           t.name as TournamentName,
           pw.cashprize as CashPrize
    from prize_winners pw
    left join final_project.player p on p.playerid = pw.playerid
    left join final_project.tournament t on t.tournamentid = pw.tournamentid;

-- 8. Tournament
create or replace view views.winners as
    with winners as (
        select name as TournamentName,
               winner as WinnerID
        from final_project.tournament
    )
    select tournamentname, namesurname
    from winners w
    join final_project.player p on w.WinnerID = p.playerid;

-- 9. Tournament Organizers
create or replace view views.philanthropists as
    with philantropists as (
        select organizerid, max(moneyspent) as max_spent
        from final_project.tournamentorganizers
        group by organizerid
        having max(moneyspent) > 60000
    )
    select o.name, p.max_spent
    from philantropists p
    join final_project.organizers o on p.organizerid = o.organizerid;
