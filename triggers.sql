/* Создать 2 триггера на любые таблицы БД. Логика работы обговаривается с семинаристом. */
-- 1. Заполнение таблицы playerhistory при изменении рейтинга/страны одного из игроков
create or replace function update_playerhistory() returns trigger as $$
    begin
        insert into final_project.playerhistory values (new.playerid, now()::date,
                                                        new.country, new.rating);
        return new;
    end;
$$ language plpgsql;

create trigger update_player_info
    after update on final_project.player
    for each row
    when (old.rating is distinct from new.rating or
         old.country is distinct from new.country)
    execute procedure update_playerhistory();

update final_project.player set rating = 1935 where playerid = 2;

-- 2. Корректировка таблицы tournament при внесении изменений в таблицу playersintournament
create or replace function update_player_in_t() returns trigger as $$
    begin
        if (tg_op = 'insert') then
            update final_project.tournament set playerscount = playerscount + 1 and
                                                               prizepool = prizepool + new.cashprize
            where tournamentid = new.tournamentid;
            return new;
        elsif (tg_op = 'update') then
            update final_project.tournament set playerscount = playerscount - 1 and
                                                   prizepool = prizepool - old.cashprize
            where tournamentid = old.tournamentid;
            update final_project.tournament set playerscount = playerscount + 1 and
                                       prizepool = prizepool + new.cashprize
            where tournamentid = new.tournamentid;

            return new;
        elsif (tg_op = 'delete') then
            update final_project.tournament set playerscount = playerscount - 1 and
                                       prizepool = prizepool - old.cashprize
            where tournamentid = old.tournamentid;
            return old;
        end if;
    end;
$$ language plpgsql;

create trigger update_player_info
    after update or insert or delete on final_project.playerintournament
    for each row
    execute procedure update_playerhistory();

-- 3, Коррекстировка insert-ов в таблицу Tournament
create or replace function insert_tournament() returns trigger as $$
    begin
        new.prizepool = 0;
        new.playerscount = 0;
        return new;
    end;
$$ language plpgsql;

create trigger insert_tournament
    before insert on final_project.tournament
    execute procedure insert_tournament();