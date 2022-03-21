/* Создать индексы для таблиц, аргументировав выбор поля, по которому будет создан индекс. */
-- Создаём индексы по тем полям, по которым чаще будет проходить поиск/отбор строк

-- Party, Tournament
create index moves_cnt_ind on final_project.moves(movescount);
create index player_rating_ind on final_project.player(rating);
create index playerhist_rating_ind on final_project.playerhistory(rating);
create index playerintournament_prize_ind on final_project.playerintournament(cashprize) where cashprize > 0;
create index organizer_spentsum_ind on final_project.organizers(totalspentsum);
create index t_organizers_spentsum_ind on final_project.tournamentorganizers(moneyspent);
