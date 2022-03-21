create schema final_project;

create table temp (
    id INT,
    value VARCHAR(128)
);

insert into temp values (100, '566')
insert into temp values (101, '567')
insert into temp values (NULL, '596')
insert into temp values (104, NULL)

select *
from temp
where id in (100, NULL);

create table final_project.Debuts (
    DebutCode CHAR(3) PRIMARY KEY,
    Name VARCHAR(128),
    Description VARCHAR(256),

    CONSTRAINT CHECK_DebutCode CHECK (
        left(DebutCode, 1) BETWEEN 'A' AND 'E' AND
        right(DebutCode, 2)::INT BETWEEN 0 AND 99
    )
);

create table final_project.Party (
    PartyID SERIAL PRIMARY KEY,
    DebutCode CHAR(3),
    TournamentID INTEGER,
    WhitePlayerID INTEGER,
    BlackPlayerID INTEGER,
    Date DATE NOT NULL,
    Score CHAR(1),

    CONSTRAINT FK_DebutCode FOREIGN KEY (DebutCode)
        REFERENCES final_project.Debuts(DebutCode)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT CHECK_Score CHECK (
        Score in ('W', 'B', 'D')
    )
);

create table final_project.Player (
    PlayerID SERIAL PRIMARY KEY,
    NameSurname VARCHAR(256) NOT NULL,
    DateBirth DATE NOT NULL,
    Country VARCHAR(128) NOT NULL,
    PassportNumber VARCHAR(16) default '777777',
    Rating SMALLINT NOT NULL DEFAULT 0,

    CONSTRAINT CHECK_PassportNum CHECK (
        length(PassportNumber::text) >= 6
    )
);

/*alter table final_project.player add column PassportNumber varchar(16) default '777777';
alter table final_project.player add constraint CHECK_PassportNum CHECK (
        length(PassportNumber::text) >= 6
);*/

create table final_project.Tournament (
    TournamentID SERIAL PRIMARY KEY,
    Name VARCHAR(256),
    DateFrom DATE,
    DateTo DATE,
    Country VARCHAR(128),
    PlayersCount SMALLINT,
    PrizePool INTEGER DEFAULT 0,
    Winner INTEGER,

    CONSTRAINT CHECK_PlayersCnt CHECK (
        PlayersCount > 1
    ),
    CONSTRAINT CHECK_PrizePool CHECK (
        PrizePool >= 0
    ),
    CONSTRAINT CHECK_Dates CHECK (
        DateFrom <= DateTo
    ),
    CONSTRAINT FK_Winner FOREIGN KEY (Winner)
        REFERENCES final_project.Player(PlayerID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

/*alter table final_project.Tournament drop constraint FK_Winner;
alter table final_project.Tournament add constraint FK_Winner FOREIGN KEY (Winner)
        REFERENCES final_project.Player(PlayerID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE;*/

create table final_project.Organizers (
    OrganizerID SERIAL PRIMARY KEY,
    Name VARCHAR(128) NOT NULL,
    TotalSpentSum INTEGER DEFAULT 1,
    EMail VARCHAR(320) DEFAULT '',

    Constraint CHECK_Sum CHECK (
        TotalSpentSum > 0
    )
);

/*alter table final_project.Organizers drop column description;
alter table final_project.Organizers add column EMail varchar(320) default ''; */

create table final_project.Moves (
    PartyID INTEGER PRIMARY KEY,
    Moves TEXT NOT NULL,
    MovesCount SMALLINT,

    CONSTRAINT FK_PartyMoves FOREIGN KEY(PartyID)
        REFERENCES final_project.Party(PartyID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT CHECK_MovesCnt CHECK (
        MovesCount >= 0
    )
);

create table final_project.PlayerHistory (
    PlayerID INTEGER,
    UpdateTime DATE NOT NULL,
    Country VARCHAR(128) NOT NULL,
    Rating SMALLINT NOT NULL DEFAULT 0,

    CONSTRAINT FK_PlayerHist FOREIGN KEY(PlayerID)
        REFERENCES final_project.Player(PlayerID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT PK_IdTime PRIMARY KEY (PlayerID, UpdateTime)
);

create table final_project.PlayerInTournament (
    PlayerID INTEGER,
    TournamentID INTEGER,
    CashPrize INTEGER DEFAULT 0,

    CONSTRAINT FK_PlayerID FOREIGN KEY(PlayerID)
        REFERENCES final_project.Player(PlayerID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT FK_TournamentAndPlayer FOREIGN KEY(TournamentID)
        REFERENCES final_project.Tournament(TournamentID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT CHECK_Prize CHECK (
        CashPrize >= 0
    ),
    CONSTRAINT PK_PlayerTournament PRIMARY KEY (PlayerID, TournamentID)
);

create table final_project.TournamentOrganizers (
    TournamentID INTEGER,
    OrganizerID INTEGER,
    MoneySpent INTEGER DEFAULT 1,

    CONSTRAINT FK_TournamentID FOREIGN KEY(TournamentID)
        REFERENCES final_project.Tournament(Tournamentid)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_OrganizerID FOREIGN KEY(OrganizerID)
        REFERENCES final_project.Organizers(OrganizerID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT PK_TournamentOrganizer PRIMARY KEY (TournamentID, OrganizerID),
    CONSTRAINT CHECK_Money CHECK (
        MoneySpent > 0
    )
);

--alter table final_project.tournamentorganizers add column MoneySpent INTEGER default 1;
--alter table final_project.tournamentorganizers add constraint CHECK_Money CHECK (MoneySpent > 0);

INSERT INTO final_project.Debuts VALUES ('A04', 'Староиндийская атака. Дебют Рети', '1.Nf3');
INSERT INTO final_project.Debuts VALUES ('A15', 'Английское начало. Английская система Индийской защиты',
                                         '1.c4 Nf6');
INSERT INTO final_project.Debuts VALUES ('D37', 'Ферзевый гамбит. Отказанный вариант, 4.Nf3',
                                         '1.d4 d5 2.c4 e6 3.Nc3 Nf6 4.Nf3');
INSERT INTO final_project.Debuts VALUES ('E20', 'Защита Нимцовича',
                                         '1.d4 Nf6 2.c4 e6 3.Nc3 Bb4');
INSERT INTO final_project.Debuts VALUES ('E91', 'Староиндийская защита, 6. Be2',
                                         '1.d4 Nf6 2.c4 g6 3.Nc3 Bg7 4.e4 d6 5.Nf3 O-O 6.Be2');
INSERT INTO final_project.Debuts VALUES ('D98', 'Защита Грюнфельда. Русский вариант, вариант Смыслова',
                                         '1.d4 Nf6 2.c4 g6 3.Nc3 d5 4.Nf3 Bg7 5.Qb3 dxc4 6.Qxc4 O-O 7.e4 Bg4');
INSERT INTO final_project.Debuts VALUES ('B52', 'Сицилианская защита. Вариант Каналя-Соколовского, 3...Bd7',
                                         '1.e4 c5 2.Nf3 d6 3.Bb5 Bd7');
INSERT INTO final_project.Debuts VALUES ('B13', 'Защита Каро–Канн. Разменный вариант', '1.e4 c6 2.d4 d5 3.exd5');
INSERT INTO final_project.Debuts VALUES ('C37', 'Королевский гамбит. Принятый вариант, гамбит Квааде',
                                         '1.e4 e5 2.f4 exf4 3.Nf3 g5 4.Nc3');
INSERT INTO final_project.Debuts VALUES ('C14', 'Французская защита. Классический вариант, вариант Тарраша',
                                         '1.e4 e6 2.d4 d5 3.Nc3 Nf6 4.Bg5 Be7 5.e5 Nfd7 6.Bxe7 Qxe7 7.Bd3');


INSERT INTO final_project.Player VALUES (1, 'Magnus Carlson', '30/10/1990', 'Norway', 'C5857541', 2847);
INSERT INTO final_project.Player VALUES (2, 'Fabiano Caruana', '30/07/1992', 'USA',	'789152538', 1923);
INSERT INTO final_project.Player VALUES (3, 'Garry Kasparov', '13/04/1963', 'Russia', '158156845', 1834);
INSERT INTO final_project.Player VALUES (4, 'Anatoly Karpov', '23/05/1951', 'Russia', '592523459', 2617);
INSERT INTO final_project.Player VALUES (5, 'Ian Nepomniachtchi', '14/07/1990', 'Russia', '157809532', 2784);
INSERT INTO final_project.Player VALUES (6, 'Levon Aronian', '6/10/1982', 'Armenia', 'CC8731432', 1696);
INSERT INTO final_project.Player VALUES (7, 'Wesley So', '9/10/1993', 'USA', '183580315', 1608);
INSERT INTO final_project.Player VALUES (8, 'Anish Giri', '28/6/1994', 'Netherlands', 'C8157576', 2549);
INSERT INTO final_project.Player VALUES (9, 'Viswanathan Anand', '11/12/1969', 'India', '91235615', 2353);
INSERT INTO final_project.Player VALUES (10, 'Jan-Krzysztof Duda', '26/4/1998', 'Poland', '34503254', 1654);
INSERT INTO final_project.Player VALUES (11, 'Shakhriyar Mamedyarov', '12/4/1985', 'Azerbaijan', 'CC4234871', 1953);
INSERT INTO final_project.Player VALUES (12, 'Hikaru Nakamura', '9/12/1987', 'USA', '912554125', 1702);
INSERT INTO final_project.Player VALUES (13, 'Sergey Karjakin', '12/1/1990', 'Russia', '905154587', 2491);
INSERT INTO final_project.Player VALUES (14, 'Etienne Bacrot', '22/1/1983', 'France', '921525054', 2000);
INSERT INTO final_project.Player VALUES (15, 'Michael Adams', '17/11/1967', 'England', 'D49714842', 1387);

INSERT INTO final_project.Tournament VALUES (1, 'Challenger Chess Tournaments',
                                             '12/1/2020', '15/1/2020', 'Russia', 8, 250000, 1);
INSERT INTO final_project.Tournament VALUES (2, 'USSR International Championship',
                                             '21/8/1990', '22/8/1990', 'USSR', 4, 0, 3);
INSERT INTO final_project.Tournament VALUES (3, 'EagleMinds Grand',
                                             '30/5/2015', '1/6/2015', 'USA', 6, 100000, 12);
INSERT INTO final_project.Tournament VALUES (4, '1st Sharjah Masters international Chess Championship',
                                             '7/12/2012', '9/12/2012', 'India', 6, 70000, 9);
INSERT INTO final_project.Tournament VALUES (5, 'British Chess Championship',
                                             '15/10/2018', '18/10/2018', 'UK', 8, 400000, 2);


INSERT INTO final_project.PlayerInTournament VALUES (3, 2, 0);
INSERT INTO final_project.PlayerInTournament VALUES (4, 2, 0);
INSERT INTO final_project.PlayerInTournament VALUES (9, 2, 0);
INSERT INTO final_project.PlayerInTournament VALUES (15, 2, 0);

INSERT INTO final_project.PlayerInTournament VALUES (1, 4, 10000);
INSERT INTO final_project.PlayerInTournament VALUES (4, 4, 20000);
INSERT INTO final_project.PlayerInTournament VALUES (6, 4, 0);
INSERT INTO final_project.PlayerInTournament VALUES (7, 4, 0);
INSERT INTO final_project.PlayerInTournament VALUES (9, 4, 40000);
INSERT INTO final_project.PlayerInTournament VALUES (11, 4, 0);

INSERT INTO final_project.PlayerInTournament VALUES (2, 3, 0);
INSERT INTO final_project.PlayerInTournament VALUES (6, 3, 0);
INSERT INTO final_project.PlayerInTournament VALUES (7, 3, 20000);
INSERT INTO final_project.PlayerInTournament VALUES (10, 3, 0);
INSERT INTO final_project.PlayerInTournament VALUES (12, 3, 50000);
INSERT INTO final_project.PlayerInTournament VALUES (15, 3, 30000);

INSERT INTO final_project.PlayerInTournament VALUES (1, 5, 0);
INSERT INTO final_project.PlayerInTournament VALUES (2, 5, 200000);
INSERT INTO final_project.PlayerInTournament VALUES (4, 5, 0);
INSERT INTO final_project.PlayerInTournament VALUES (6, 5, 60000);
INSERT INTO final_project.PlayerInTournament VALUES (8, 5, 0);
INSERT INTO final_project.PlayerInTournament VALUES (10, 5, 100000);
INSERT INTO final_project.PlayerInTournament VALUES (14, 5, 40000);
INSERT INTO final_project.PlayerInTournament VALUES (15, 5, 0);

INSERT INTO final_project.PlayerInTournament VALUES (2, 1, 0);
INSERT INTO final_project.PlayerInTournament VALUES (3, 1, 60000);
INSERT INTO final_project.PlayerInTournament VALUES (5, 1, 30000);
INSERT INTO final_project.PlayerInTournament VALUES (6, 1, 0);
INSERT INTO final_project.PlayerInTournament VALUES (9, 1, 0);
INSERT INTO final_project.PlayerInTournament VALUES (1, 1, 120000);
INSERT INTO final_project.PlayerInTournament VALUES (11, 1, 40000);
INSERT INTO final_project.PlayerInTournament VALUES (15, 1, 0);

INSERT INTO final_project.Organizers VALUES (1, 'International Chess Federation', 376232, 'chess_federation@gmail.com');
INSERT INTO final_project.Organizers VALUES (2, 'Universal Event Promotion', 312412, 'event_promotion231@mail.com');
INSERT INTO final_project.Organizers VALUES (3, 'Luis Renter Suarez', 151168, '');
INSERT INTO final_project.Organizers VALUES (4, 'Joop van Oosterom', 67125, '');
INSERT INTO final_project.Organizers VALUES (5, 'USSR Chess Federation', 7000, '');
INSERT INTO final_project.Organizers VALUES (6, 'USA Chess Federation', 25205, 'usa_federation@mail.ru');
INSERT INTO final_project.Organizers VALUES (7, 'Agon', 434426, 'agon42342@gmail.com');
INSERT INTO final_project.Organizers VALUES (8, 'The Sharjah Chess & Culture Club', 35321, 'sharjah4134@gmail.com');

INSERT INTO final_project.TournamentOrganizers VALUES (2, 5, 7000);
INSERT INTO final_project.TournamentOrganizers VALUES (2, 6, 6000);

INSERT INTO final_project.TournamentOrganizers VALUES (4, 4, 21834);
INSERT INTO final_project.TournamentOrganizers VALUES (4, 8, 35321);
INSERT INTO final_project.TournamentOrganizers VALUES (4, 2, 12121);
INSERT INTO final_project.TournamentOrganizers VALUES (4, 1, 23000);

INSERT INTO final_project.TournamentOrganizers VALUES (3, 4, 45291);
INSERT INTO final_project.TournamentOrganizers VALUES (3, 3, 61024);
INSERT INTO final_project.TournamentOrganizers VALUES (3, 6, 19205);
INSERT INTO final_project.TournamentOrganizers VALUES (3, 2, 21941);

INSERT INTO final_project.TournamentOrganizers VALUES (5, 7, 120414);
INSERT INTO final_project.TournamentOrganizers VALUES (5, 3, 90144);
INSERT INTO final_project.TournamentOrganizers VALUES (5, 1, 103232);

INSERT INTO final_project.TournamentOrganizers VALUES (1, 1, 250000);
INSERT INTO final_project.TournamentOrganizers VALUES (1, 2, 32141);
INSERT INTO final_project.TournamentOrganizers VALUES (1, 7, 314012);

INSERT INTO final_project.Party VALUES (1, 'B13', 2, 3, 9, '21/8/1990', 'W');
INSERT INTO final_project.Party VALUES (2, 'E20', 2, 4, 15, '21/8/1990', 'W');
INSERT INTO final_project.Party VALUES (3, 'D98', 2, 15, 9, '22/8/1990', 'D');
INSERT INTO final_project.Party VALUES (4, 'B52', 2, 4, 3, '22/8/1990', 'B');

INSERT INTO final_project.Party VALUES (5, 'C14', 4, 1, 6, '7/12/2012', 'W');
INSERT INTO final_project.Party VALUES (6, 'A15', 4, 6, 4, '7/12/2012', 'B');
INSERT INTO final_project.Party VALUES (7, 'C37', 4, 4, 1, '7/12/2012', 'D');
INSERT INTO final_project.Party VALUES (8, 'D37', 4, 7, 9, '8/12/2012', 'B');
INSERT INTO final_project.Party VALUES (9, 'C37', 4, 9, 11, '8/12/2012', 'W');
INSERT INTO final_project.Party VALUES (10, 'E91', 4, 11, 7, '8/12/2012', 'D');
INSERT INTO final_project.Party VALUES (11, 'C37', 4, 1, 9, '9/12/2012', 'B');
INSERT INTO final_project.Party VALUES (12, 'E20', 4, 4, 9, '9/12/2012', 'B');
INSERT INTO final_project.Party VALUES (13, 'C37', 4, 1, 4, '9/12/2012', 'B');

INSERT INTO final_project.Party VALUES (14, 'A04', 3, 2, 6, '30/5/2015', 'D');
INSERT INTO final_project.Party VALUES (15, 'B52', 3, 6, 7, '30/5/2015', 'B');
INSERT INTO final_project.Party VALUES (16, 'C14', 3, 7, 2, '30/5/2015', 'W');
INSERT INTO final_project.Party VALUES (17, 'A15', 3, 10, 12, '31/5/2015', 'B');
INSERT INTO final_project.Party VALUES (18, 'D37', 3, 12, 15, '31/5/2015', 'D');
INSERT INTO final_project.Party VALUES (19, 'A04', 3, 10, 15, '31/5/2015', 'B');
INSERT INTO final_project.Party VALUES (20, 'C37', 3, 7, 12, '1/6/2015', 'B');
INSERT INTO final_project.Party VALUES (21, 'B13', 3, 15, 12, '1/6/2015', 'B');
INSERT INTO final_project.Party VALUES (22, 'E20', 3, 15, 7, '1/6/2015', 'W');

INSERT INTO final_project.Party VALUES (23, 'D98', 5, 1, 4, '15/10/2018', 'W');
INSERT INTO final_project.Party VALUES (24, 'B52', 5, 2, 6, '15/10/2018', 'B');
INSERT INTO final_project.Party VALUES (25, 'C14', 5, 1, 6, '15/10/2018', 'B');
INSERT INTO final_project.Party VALUES (26, 'A15', 5, 2, 4, '15/10/2018', 'W');
INSERT INTO final_project.Party VALUES (27, 'E91', 5, 15, 14, '16/10/2018', 'B');
INSERT INTO final_project.Party VALUES (28, 'D37', 5, 10, 8, '16/10/2018', 'W');
INSERT INTO final_project.Party VALUES (29, 'A04', 5, 15, 10, '16/10/2018', 'B');
INSERT INTO final_project.Party VALUES (30, 'C37', 5, 14, 8, '16/10/2018', 'W');
INSERT INTO final_project.Party VALUES (31, 'B13', 5, 2, 10, '17/10/2018', 'W');
INSERT INTO final_project.Party VALUES (32, 'E20', 5, 6, 14, '17/10/2018', 'W');
INSERT INTO final_project.Party VALUES (33, 'D98', 5, 2, 14, '17/10/2018', 'W');
INSERT INTO final_project.Party VALUES (34, 'B52', 5, 6, 10, '17/10/2018', 'B');
INSERT INTO final_project.Party VALUES (35, 'C14', 5, 6, 10, '17/10/2018', 'D');
INSERT INTO final_project.Party VALUES (36, 'A04', 5, 6, 10, '17/10/2018', 'B');
INSERT INTO final_project.Party VALUES (37, 'A15', 5, 2, 10, '18/10/2018', 'W');

INSERT INTO final_project.Party VALUES (38, 'A04', 1, 2, 3, '12/1/2020', 'D');
INSERT INTO final_project.Party VALUES (39, 'D37', 1, 5, 6, '12/1/2020', 'D');
INSERT INTO final_project.Party VALUES (40, 'E91', 1, 2, 5, '12/1/2020', 'B');
INSERT INTO final_project.Party VALUES (41, 'B13', 1, 6, 3, '12/1/2020', 'B');
INSERT INTO final_project.Party VALUES (42, 'E20', 1, 9, 1, '13/1/2020', 'B');
INSERT INTO final_project.Party VALUES (43, 'D98', 1, 11, 15, '13/1/2020', 'W');
INSERT INTO final_project.Party VALUES (44, 'B52', 1, 1, 15, '13/1/2020', 'W');
INSERT INTO final_project.Party VALUES (45, 'C14', 1, 9, 11, '13/1/2020', 'B');
INSERT INTO final_project.Party VALUES (46, 'A15', 1, 3, 11, '14/1/2020', 'W');
INSERT INTO final_project.Party VALUES (47, 'E91', 1, 5, 1, '14/1/2020', 'B');
INSERT INTO final_project.Party VALUES (48, 'D37', 1, 3, 5, '14/1/2020', 'W');
INSERT INTO final_project.Party VALUES (49, 'D98', 1, 1, 11, '14/1/2020', 'W');
INSERT INTO final_project.Party VALUES (50, 'E91', 1, 5, 11, '15/1/2020', 'B');
INSERT INTO final_project.Party VALUES (51, 'B13', 1, 1, 3, '15/1/2020', 'W');

INSERT INTO final_project.Moves VALUES (14, '1. Nf3 Nf6 2. g3 e6 3. Bg2 d5 4. O-O Be7 5. b3 O-O 6. Bb2 c6 7. d3 b6 8. c4 Nbd7 9. Nbd2 Bb7 10. Qc2 c5 11. e4 d4 12. Rae1 Qc7 13. Bh3 e5 14. Nh4 g6 15. Ng2 Nh5 16. f4 exf4 17. gxf4 Rae8 18. Qd1 Bd6 19. Qg4 f5', 19);
INSERT INTO final_project.Moves VALUES (19, '1. Nf3 Nf6 2. g3 d5 3. Bg2 e6 4. O-O Be7 5. d3 b6 6. e4 dxe4 7. dxe4 Qxd1 8. Rxd1 Bb7 9. Nc3 Nxe4 10. Ne5 Nc5 11. Nb5 Nba6 12. Nc6 Bf6 13. c3 e5 14. b4 e4 15. Nbd4 Na4 16. Re1 Nxc3 17. Bd2 O-O 18. a3 Nb5 19. Bxe4 Nxd4 20. Ne7+ Bxe7 21. Bxb7 Bf6 22. Rac1 Rad8 23. Bxa6 Nf3+ 24. Kg2 Nxe1+ 25. Bxe1 Rfe8 26. Kf1 Re7 27. a4 Bd4 28. b5 Bc5 29. Bb7 Rd4 30. a5 Bb4 31. Bxb4 Rxb4 32. Rd1 g6 33. a6 Rxb5 34. Rd8+ Kg7 35. Ra8 Ra5 36. Rxa7 c5 37. Ra8 Ra1+ 38. Kg2 Rc7 39. Rd8 c4 40. Rd2 c3 41. Rc2 b5 42. Kf3 b4', 42); --B
INSERT INTO final_project.Moves VALUES (38, '1. Nf3 Nf6 2. g3 d5 3. Bg2 e6 4. O-O Be7 5. d3 O-O 6. c4 c5', 6); --D
INSERT INTO final_project.Moves VALUES (36, '1. Nf3 d6 2. g3 e5 3. d3 g6 4. Bg2 Bg7 5. O-O Ne7 6. Bd2 f5 7. Qc1 h6 8. e4 g5 9. exf5 Nxf5 10. Nc3 Nc6 11. Nd5 O-O 12. c3 Be6 13. Ne1 Qd7 14. Nc2 Rae8 15. Qd1 Nd8 16. c4 Nd4 17. Nc3 N8c6 18. Nxd4 exd4 19. Ne4 Ne5 20. f4 gxf4 21. Bxf4 Ng4 22. Qd2 b5 23. cxb5 Qxb5 24. Bf3 Ne3 25. Rfc1 Qb6 26. b4 Kh8 27. a4 Re7 28. b5 Bd5 29. Rab1 Ref7 30. Bh5 Rf5 31. Bg6 Rxf4 32. gxf4 Rxf4 33. Ng3 Be5 34. Be4 Bxe4 35. dxe4 Qb8 36. Rb3 Qg8 37. Rxe3 dxe3 38. Qxe3 Qg7 39. Kh1 Rh4 40. Kg2 Bf4 41. Qc3 Be5 42. Qf3 Bxg3 43. hxg3 Qb2+ 44. Qf2 Rh2+', 44); --B

INSERT INTO final_project.Moves VALUES (7, '1. e4 e5 2. f4 exf4 3. Nf3 g5 4. Bc4 Bg7 5. O-O d6 6. d4 h6 7. h4 g4 8. Ne1 f3 9. gxf3 Qxh4 10. Ng2 Qh3 11. Nf4 Qg3+ 12. Ng2 Qh3 13. Nf4 Qg3+ 14. Ng2 Qh3 15. Nf4', 15); --D
INSERT INTO final_project.Moves VALUES (9, '1. e4 e5 2. f4 exf4 3. Nf3 g5 4. Bc4 Bg7 5. d4 d6 6. O-O Be6 7. Bxe6 fxe6 8. c3 h6 9. Qb3 Qc8 10. h4 g4 11. Nh2 e5 12. Bxf4 Nc6 13. Bxe5', 13); --W
INSERT INTO final_project.Moves VALUES (11, '1. e4 e5 2. f4 exf4 3. Nf3 g5 4. Bc4 Bg7 5. d4 d6 6. h4 h6 7. hxg5 hxg5 8. Rxh8 Bxh8 9. g3 g4 10. Nh4 fxg3', 10); --B
INSERT INTO final_project.Moves VALUES (13, '1. e4 e5 2. f4 exf4 3. Nf3 g5 4. Bc4 Bg7 5. d4 d6 6. O-O h6 7. c3 Ne7 8. Nbd2 O-O 9. Re1 Nbc6 10. h3 Ng6 11. b4 a6 12. a4 Kh8 13. Bb2 f5 14. Bd3 g4 15. exf5 gxf3 16. fxg6 fxg2 17. b5 Ne7 18. Qh5 Nf5 19. Nf3 Ng3 20. Qd5 Bxh3 21. Re6 axb5 22. Rae1 c6 23. Qxd6 Bxe6 24. Qxe6 Re8 25. Qxe8+ Qxe8 26. Rxe8+ Rxe8 27. axb5 Re3 28. Bc4 Rxf3', 28); --B
INSERT INTO final_project.Moves VALUES (20, '1. e4 e5 2. f4 exf4 3. Nf3 g5 4. Bc4 Bg7 5. d4 d6 6. O-O Nc6 7. c3 h6 8. b4 Nge7 9. h4 d5 10. exd5 Nxd5 11. Qe2+ Be6 12. b5 Nxc3 13. Nxc3 Nxd4 14. Qe4 Nxf3+ 15. Qxf3 Qd4+ 16. Be3 Qxc4 ', 16); --B
INSERT INTO final_project.Moves VALUES (30, '1. e4 e5 2. f4 exf4 3. Nf3 g5 4. Bc4 Bg7 5. d4 d6 6. g3 g4 7. Nh4 f3 8. Be3 Bf6 9. Nc3 Ne7 10. Qd2 Ng6 11. Nf5 Bxf5 12. exf5 Ne7 13. Bd3 d5 14. O-O-O Nd7 15. Rde1 c5 16. Bb5 O-O 17. dxc5 Ne5 18. Bg5 N7c6 19. Bxf6 Qxf6 20. Qf4 f2 21. Re2 Nc4 22. Bxc4 dxc4 23. Rxf2 Kh8 24. Qxg4 Ne5 25. Qf4 Rfe8 26. Rd1 Qc6 27. Rd5 f6 28. Rfd2 Nf7 29. Qxc4 Re1+ 30. Rd1 Ne5 31. Qd4 Rxd1+ 32. Qxd1 Qc8 33. g4 b6 34. Ne4 Qc6 35. g5 Nc4 36. Rd8+', 36); --W

INSERT INTO final_project.Moves VALUES (1, '1. e4 c6 2. d4 d5 3. exd5 cxd5 4. Bd3 Nc6 5. c3 Nf6 6. Bf4 Bg4 7. Qb3 Qd7 8. Nd2 e6 9. Ngf3 Bxf3 10. Nxf3 Bd6 11. Bxd6 Qxd6 12. O-O O-O 13. Rae1 Rab8 14. Ne5 Qc7 15. f4 Ne7 16. g4 b5 17. g5 Ne4 18. Bxe4 dxe4 19. Rxe4 b4 20. c4 Rfd8 21. Rd1 Rd6 22. c5 Rd5 23. Nc4 Nf5 24. Ne3 Nxe3 25. Qxe3 Rbd8 26. Re5 Qd7 27. Rxd5 Qxd5 28. b3 f6 29. gxf6 gxf6 30. Kf2 Kf7 31. Qf3 Ke7 32. Qxd5 Rxd5 33. Ke3 Rh5 34. Rg1 Kf7 35. Rg2 Rh3+ 36. Ke4 Rc3 37. f5 e5 38. Rd2 Rc1 39. dxe5 fxe5 40. Rd7+ Kf6 41. Rd6+ Kf7 42. Kd5 e4 43. c6 Rd1+ 44. Ke5 Rxd6 45. Kxd6 e3 46. c7 ', 46); --WBWBW
INSERT INTO final_project.Moves VALUES (21, '1. e4 c6 2. d4 d5 3. exd5 cxd5 4. Bd3 Nc6 5. c3 Nf6 6. h3 g6 7. Nf3 Bf5 8. Be2 Bg7 9. O-O Qc7 10. Be3 O-O 11. Nbd2 Rad8 12. Re1 Ne4 13. Rc1 h6 14. g4 Bc8 15. Nxe4 dxe4 16. Nh4 Kh7 17. Qc2 f5 18. gxf5 gxf5 19. Bh5 Bf6 20. Bg6+ Kg7 21. Nxf5+ Kxg6 22. Nxh6 Nxd4 23. Qxe4+ Nf5 24. h4 Bg7 25. Ng4 Qc6 26. Qxc6+ bxc6 27. Bg5 Rh8 28. Ne5+ Bxe5 29. Rxe5 Nxh4 30. Bxh4 Rxh4 31. Rxe7 ', 31);
INSERT INTO final_project.Moves VALUES (31, '1. e4 c6 2. d4 d5 3. exd5 cxd5 4. Bd3 Nc6 5. c3 Qc7 6. h3 Nf6 7. Nf3 g6 8. O-O Bg7 9. Re1 O-O 10. Qc2 Nh5 11. Be3 e5 12. dxe5 Nxe5 13. Nxe5 Bxe5 14. Nd2 Nf4 15. Nf3 Bg7 16. Qd2 Nxd3 17. Qxd3 Qc4 18. Qd2 Be6 19. Bd4 Rfe8 20. Bxg7 Kxg7 21. Nd4 Bd7 22. h4 Qc7 23. h5 h6 24. hxg6 fxg6 25. Nf3 Qc5 26. b4 Qc6 27. Ne5 Qd6 28. Qd4 Kh7 29. c4 Be6 30. c5 Qc7 31. Rac1 Rac8 32. b5 b6 33. c6 Re7 34. Rc3 Rce8 35. Nxg6 Kxg6 36. Rg3+ Kh7 37. Qd3+ Kh8 38. Qg6 ', 38);
INSERT INTO final_project.Moves VALUES (41, '1. e4 c6 2. d4 d5 3. exd5 cxd5 4. Bd3 Nc6 5. c3 Qc7 6. h3 g6 7. Ne2 Bf5 8. Bxf5 gxf5 9. Bf4 Qd7 10. Nd2 Nf6 11. Nf3 Ne4 12. Ne5 Nxe5 13. dxe5 e6 14. Nd4 h5 15. h4 Be7 16. Qe2 Rc8 17. f3 Nc5 18. O-O-O Na4 19. Bd2 Rg8 20. Rdg1 Rc4 21. g4 fxg4 22. fxg4 Bc5 23. gxh5 Rh8 24. Qg4 Rf8 25. Bh6 Bxd4 26. Qg8 Be3+ 27. Bxe3 Qb5 28. Rh2 Rxg8 29. Rxg8+ Kd7 30. Rf2 f5 31. exf6 e.p. Nxc3 32. f7 Nxa2+ 33. Kd1 Qb3+ 34. Ke2 Rc2+ 35. Kf3 d4 36. f8=Q Qxe3+ 37. Kg4 Rxf2 38. Qc8+ Kd6 39. Rd8+ Ke5 40. Qc7+ Ke4 41. Qxb7+ Kd3 42. Qb5+ Kc2 43. Qa4+ Kb1 44. Qd1+ Nc1 45. h6 Rg2+ ', 45);
INSERT INTO final_project.Moves VALUES (51, '1. e4 c6 2. d4 d5 3. exd5 cxd5 4. c4 Nf6 5. Nc3 Nc6 6. Nf3 Bg4 7. cxd5 Nxd5 8. Qb3 Bxf3 9. gxf3 Nb6 10. d5 Nd4 11. Qd1 e5 12. dxe6 e.p. Nxe6 13. Bb5+ Nd7 14. Qe2 Bc5 15. Be3 Bxe3 16. Rd1 O-O 17. Rxd7 Qc8 18. Qxe3 Re8 19. Rd1 Rf8 20. Bd7 Qc4 21. Bxe6 fxe6 22. Rd4 Qc6 23. Qe4 Qb6 24. Rb4 Qa6 25. Qxb7 ', 25);

INSERT INTO final_project.Moves VALUES (2, '1. d4 Nf6 2. c4 e6 3. Nc3 Bb4 4. Bd2 O-O 5. e3 d5 6. Nf3 dxc4 7. Bxc4 b6 8. O-O Bb7 9. a3 Be7 10. Qe2 Nbd7 11. e4 Re8 12. Rfd1 a6 13. Rac1 b5 14. Ba2 Nf8 15. Bb1 Rc8 16. Be3 N6d7 17. Ne5 Bd6 18. Nd3 Ng6 19. f4 Kh8 20. g3 Bf8 21. b4 c6 22. Nc5 Nxc5 23. dxc5 Qc7 24. e5 Ne7 25. Ne4 Nd5 26. Bd4 Be7 27. Qd3 g6 28. h4 a5 29. Nd6 Rf8 30. h5 Kg7 31. Kf2 f5 32. exf6 e.p.+ Bxf6 33. Re1 Qd7 34. hxg6 h6 35. Bxf6+ Rxf6 36. Qd4 Rf8 37. Kg2 Bc8 38. Re5 axb4 39. axb4 Qa7 40. Qb2 Qa4 41. Re4 e5 42. Bc2 ', 42); --WBWWB
INSERT INTO final_project.Moves VALUES (12, '1. d4 Nf6 2. c4 e6 3. Nc3 Bb4 4. f3 c5 5. d5 b5 6. e4 d6 7. Bd2 a6 8. a4 bxc4 9. Bxc4 Nbd7 10. dxe6 fxe6 11. Bxe6 Ne5 12. Bxc8 Qxc8 13. Bf4 c4 14. Bxe5 dxe5 15. Nh3 Qc5 16. Qe2 O-O-O 17. Nf2 Rd4 18. O-O Rhd8 19. Rfd1 Bxc3 20. bxc3 Rxd1+ 21. Rxd1 Rxd1+ 22. Qxd1 Qe3 23. Qa1 Nd7 24. Kf1 Nc5 25. Qe1 Qh6 26. Qd1 Qc6 27. Ng4 Nd3 28. Ne3 Qb6 29. Ke2 Nf4+ 30. Kd2 Qd6+ 31. Kc2 Qc6 32. g3 Qxa4+ 33. Kd2 Qd7+ 34. Ke1 Nd3+ 35. Ke2 Qb5 36. Qd2 a5 37. Nxc4 Nf4+ 38. gxf4 Qxc4+ 39. Ke3 exf4+ 40. Kxf4 a4 41. Qc1 Qb3 42. Qe3 a3 43. Qc5+ Kb7 44. Qe7+ Ka8 45. e5 Qc4+ 46. Kg3 a2 47. Qd8+ Kb7 48. Qd7+ Ka6 49. Qd6+ Ka5 50. Qa3+ Kb5 51. Qa8 Qe6 52. c4+ Qxc4 53. Qb7+ Ka4 54. Qa7+ Kb3 55. Qb6+ Qb4 56. Qe3+ Qc3 57. Qb6+ Kc2 58. Qf2+ Qd2 59. Qc5+ Kd1 60. Qa3 Ke2 61. Qa6+ Ke1 62. Qa7 Kf1 63. e6 Qe1+ 64. Kh3 Qxe6+ 65. Kg3 Qe1+ 66. Kh3 a1=Q 67. Qf7 Qe2 ', 67);
INSERT INTO final_project.Moves VALUES (22, '1. d4 Nf6 2. c4 e6 3. Nc3 Bb4 4. f3 c5 5. d5 O-O 6. e4 d6 7. Ne2 Re8 8. Bf4 exd5 9. cxd5 Nh5 10. Bd2 f5 11. Qc2 fxe4 12. O-O-O e3 13. Be1 Nd7 14. g4 Nhf6 15. Nf4 Ne5 16. Be2 Qe7 17. Bh4 Bxc3 18. Qxc3 Ne4 19. Qxe3 Qxh4 20. Qxe4 Qh6 21. Kb1 Bd7 22. Ne6 Bxe6 23. dxe6 Qxe6 24. f4 Nf7 25. Qxe6 Rxe6 26. Bc4 Re4 27. Bd5 Re7 28. g5 Kf8 29. h4 Rae8 30. h5 h6 31. Rhg1 Re2 32. g6 Nd8 33. f5 Rf2 34. Bc4 Rxf5 35. Rxd6 Nc6 36. Rd7 Ne5 37. Rd5 b6 38. Bb5 Ra8 39. Re1 a6 40. Bd3 Rxh5 41. Rdxe5 Rxe5 42. Rxe5 Re8 43. Rf5+', 43);
INSERT INTO final_project.Moves VALUES (32, '1. d4 Nf6 2. c4 e6 3. Nc3 Bb4 4. f3 c5 5. d5 b5 6. e4 d6 7. Bd2 bxc4 8. Bxc4 O-O 9. Nge2 Ba6 10. Bxa6 Nxa6 11. dxe6 fxe6 12. Nf4 Bxc3 13. bxc3 Nc7 14. O-O d5 15. Be3 Qe7 16. Nd3 Nd7 17. Qa4 c4 18. Nf2 a6 19. Qa5 Qd6 20. Rfd1 Rab8 21. Qa4 Nb5 22. Qc2 Qa3 23. exd5 Qxc3 24. Qe4 exd5 25. Qxd5+ Rf7 26. Ng4 Qb4 27. Qg5 Kh8 28. a4 Nc3 29. Rd2 Qb1+ 30. Rd1 Nxd1 31. Rxb1 Rxb1 32. Bc1 Nc3 33. Kf1 Na2 34. Ne5 Rxc1+ 35. Kf2 Rf8 36. Nxd7 Re8 37. Ne5 h6 38. Nf7+ Kh7 39. Qf5+ Kg8 40. Qg6 Kf8 41. Nd6 Re7 42. Qh7 Rd7 43. Nf5 c3 44. Qh8+ Kf7 45. Qxg7+ Ke6 46. Qg6+ Kd5 47. Qg8+ Kc6 48. Qc8+ Rc7 49. Qe6+ Kb7 50. Qxa2 Rf1+ 51. Kxf1 c2 52. Qb2+', 52);
INSERT INTO final_project.Moves VALUES (42, '1. d4 Nf6 2. c4 e6 3. Nc3 Bb4 4. f3 d5 5. a3 Bd6 6. c5 Be7 7. Bg5 h6 8. Bh4 O-O 9. e3 b6 10. b4 a5 11. Bd3 c6 12. Nge2 Ba6 13. O-O Nbd7 14. f4 Ng4 15. Bxe7 Qxe7 16. Bxa6 Nxe3 17. Qc1 Nxf1 18. Bb7 axb4 19. Bxa8 bxc3 20. Bxc6 Nd2 21. Bxd7 Qxd7 22. Qxc3 Ne4 23. Qb4 bxc5 24. dxc5 Rc8 25. Rc1 Rxc5 26. Rxc5 Qa7 27. Nd4 Qxc5 28. Qxc5 Nxc5 29. Kf2 Kf8 30. Nc6 Ke8 31. Ke3 Kd7 32. Ne5+ Ke7 33. Kd4 Nd7 34. Nc6+ Kd6 35. Nd8 f6 36. Nb7+ Kc7 37. Na5 Kb6 38. Nb3 Nb8 39. a4 Nc6+ 40. Kc3 e5 41. fxe5 fxe5 42. Kd3 Na5 43. Na1 Kc5 44. Nc2 Nc4 45. g4 Nb2+ 46. Ke2 Nxa4 47. Ne3 g6 48. h4 d4 49. Nf1 Nc3+ 50. Kd3 e4+ 51. Kd2 Kc4 52. h5 g5', 52);

INSERT INTO final_project.Moves VALUES (3, '1. Nf3 Nf6 2. c4 g6 3. Nc3 d5 4. Qa4+ Bd7 5. Qb3 dxc4 6. Qxc4 Bg7 7. d4 O-O 8. e4 Bg4 9. Be3 Nfd7 10. Be2 Nb6 11. Qd3 Nc6 12. Rd1 Bxf3 13. Bxf3 e5 14. d5 Nd4 15. Bxd4 exd4 16. Ne2 c5 17. dxc6 e.p. bxc6 18. O-O c5 19. b3 Nd7 20. Nf4 Bh6 21. Nd5 Ne5 22. Qc2 Nxf3+ 23. gxf3 Qd6 24. Qc4 Rae8 25. b4 Re5 26. Qxc5 Rg5+ 27. Kh1 Qxh2+ 28. Kxh2 Rh5+ 29. Kg2 Rg5+ 30. Kh3 Rh5+ 31. Kg2 Rg5+ ', 31); --DWWWW
INSERT INTO final_project.Moves VALUES (23, '1. d4 Nf6 2. c4 g6 3. Nc3 d5 4. Nf3 Bg7 5. Qb3 dxc4 6. Qxc4 O-O 7. e4 Bg4 8. Be3 Nfd7 9. Nd2 Nb6 10. Qc5 e5 11. d5 c6 12. f3 Bc8 13. Rd1 cxd5 14. exd5 f5 15. Be2 Na6 16. Bxa6 bxa6 17. Nb3 Bd7 18. Na5 Rc8 19. Qb4 e4 20. O-O f4 21. Bc5 e3 22. Bxf8 Bxc3 23. bxc3 e2 24. Bh6 exf1=Q+ 25. Kxf1 Bb5+ 26. Kg1 Nc4 27. Nxc4 Rxc4 28. Qa3 Qf6 29. d6 Rxc3 30. Qb4 Rc4 31. Qb3 Qe6 32. Qb2 Qe3+ 33. Kh1 Qc3 34. Qe2 ', 34);
INSERT INTO final_project.Moves VALUES (33, '1. Nf3 Nf6 2. c4 g6 3. Nc3 d5 4. d4 Bg7 5. Qb3 dxc4 6. Qxc4 O-O 7. e4 Bg4 8. Be3 Nfd7 9. Nd2 Nb6 10. Qc5 e5 11. d5 Re8 12. h3 Bd7 13. Be2 Bf8 14. Qa5 Nc4 15. Nxc4 b6 16. Qa3 Bxa3 17. Nxa3 a5 18. h4 h5 19. Rd1 Qe7 20. g3 Qb4 21. Rd2 Na6 22. O-O Nc5 23. Nc4 Bg4 24. f3 Bh3 25. Rc1 Nb7 26. d6 Nxd6 27. Nd5 Nxc4 28. Nxb4 Nxd2 29. Nd5 Red8 30. Bxd2 Be6 31. Bg5 Rd6 32. Be7 Rd7 33. Nf6+ ', 33);
INSERT INTO final_project.Moves VALUES (43, '1. d4 Nf6 2. c4 g6 3. Nc3 d5 4. Nf3 Bg7 5. Qb3 dxc4 6. Qxc4 O-O 7. e4 Bg4 8. Be3 Nfd7 9. Nd2 Nb6 10. Qc5 e5 11. dxe5 N8d7 12. Qa3 Nxe5 13. h3 Qh4 14. Rg1 Be6 15. g3 Qf6 16. f4 Nec4 17. Nxc4 Bxc4 18. O-O-O Bxf1 19. Bd4 Qe6 20. Bxg7 Kxg7 21. Rdxf1 Qxh3 22. Qc5 Rad8 23. f5 Rd6 24. Qxc7 Qh6+ 25. Kb1 Rd2 26. Rh1 Rh2 27. Rxh2 Qxh2 28. f6+ Kg8 29. Rd1 h5 30. Rd8 Qg1+ 31. Kc2 Qf2+ 32. Kb3 Qxf6 33. Rxf8+ Kxf8 34. Qxb7 Qe6+ 35. Kc2 a5 36. Qc7 Kg7 37. b3 Qf6 38. Ne2 Qf2 39. Kd3 Qf3+ 40. Kd2 Qf6 41. Ke1 Qa1+ 42. Kf2 Qf6+ 43. Kg2 Qe6 44. Nc3 a4 45. b4 Qf6 46. Qc5 Nd7 47. Qe3 h4 48. gxh4 Qxh4 49. Qd4+ Nf6 50. b5 Kh7 51. Qe5 Nh5 52. Kf3 f6 53. Qc7+ Kh6 54. b6 Qh3+ 55. Ke2 Ng3+ 56. Kd3 f5 57. Kd4 Qh2 58. Kc4 Qb2 59. b7 Nxe4 60. Nxe4 Qxa2+ 61. Kd4 Qb2+ 62. Nc3 Qf2+ 63. Kc4 Qf1+ 64. Kb4 Qf4+ 65. Qxf4+ ', 65);
INSERT INTO final_project.Moves VALUES (49, '1. d4 Nf6 2. c4 g6 3. Nc3 d5 4. Nf3 Bg7 5. Qb3 dxc4 6. Qxc4 O-O 7. e4 Bg4 8. Be3 Nfd7 9. Rd1 Nb6 10. Qb3 e6 11. Be2 Nc6 12. e5 Qd7 13. h3 Bxf3 14. Bxf3 Na5 15. Qc2 Nbc4 16. Ne4 Nxe3 17. fxe3 b6 18. b4 Nb7 19. Rc1 Rac8 20. Qc6 Qxc6 21. Rxc6 f5 22. exf6 e.p. Bxf6 23. Bg4 Nd8 24. Rxe6 Nxe6 25. Bxe6+ Kg7 26. Bxc8 Rxc8 27. Ke2 Be7 28. b5 Kf7 29. Rc1 Ke6 30. Kd3 Kd7 31. Rf1 Ke8 32. Nc3 a6 33. a4 axb5 34. axb5 Ra8 35. Kc4 h5 36. e4 h4 37. e5 g5 38. e6 Bd6 39. Rf7 Ra1 40. Nd5 Re1 41. Nf6+ Kd8 42. Rd7+ Kc8 43. Kd5 Ba3 44. Rg7 Rb1 45. e7 Bxe7 46. Rxe7 Kb7 47. Re5 ', 47);
--BBBBW
INSERT INTO final_project.Moves VALUES (4, '1. e4 c5 2. Nf3 d6 3. Bb5+ Bd7 4. a4 Nc6 5. O-O Nf6 6. Re1 a6 7. Bf1 g6 8. c3 Bg7 9. h3 e5 10. d4 cxd4 11. cxd4 exd4 12. Nxd4 O-O 13. Nc3 Nxd4 14. Qxd4 Nxe4 15. Qb4 Nxc3 16. bxc3 a5 17. Qxd6 Bxc3 18. Bh6 Bxa4 19. Qf4 Re8 20. Rec1 Bxa1 21. Rxa1 Bb3 22. Rc1 Qe7 23. Qg3 a4 24. Rc7 Qe5 25. Bf4 Qe1 26. Rc1 Qe4 27. Bh6 Qe5 28. Bf4 Qb2 29. Bb5 Rac8 30. Bxe8 Rxc1+ 31. Kh2 Re1 32. Bb5 Re4 33. Bd6 h5 34. Qg5 Qxf2 35. Bd3 Qe3 36. Qd8+ Re8 37. Qd7 Qe6 38. Qc7 Bd5 39. Bf4 Bxg2 40. Kxg2 Qd5+', 40);
INSERT INTO final_project.Moves VALUES (15, '1. e4 c5 2. Nf3 d6 3. Bb5+ Bd7 4. Bxd7+ Qxd7 5. c4 Nf6 6. Nc3 g6 7. d4 cxd4 8. Nxd4 Bg7 9. f3 O-O 10. Be3 Nc6 11. Nde2 a6 12. b3 b5 13. cxb5 axb5 14. O-O Qb7 15. Rc1 Rfd8 16. Nd4 Nxd4 17. Bxd4 e5 18. Be3 d5 19. exd5 b4 20. Na4 Nxd5 21. Qe2 e4 22. Rc4 Nxe3 23. Qxe3 exf3 24. Rxf3 Re8 25. Qf4 Be5 26. Qc1 Rad8 27. Rf1 Bd4+ 28. Kh1 Re2 29. Rc6 Rd6 30. Qc4 Rd2 31. Qc1 Rxg2 32. Rc8+ Kg7 33. Rxf7+ Qxf7 34. Rc7 Rg1+ ', 34);
INSERT INTO final_project.Moves VALUES (24, '1. e4 c5 2. Nf3 d6 3. Bb5+ Bd7 4. Bxd7+ Qxd7 5. c4 Nf6 6. Nc3 g6 7. d4 cxd4 8. Nxd4 Bg7 9. f3 O-O 10. Be3 Rc8 11. b3 Nc6 12. O-O a6 13. a4 e6 14. Rc1 Qe7 15. Qd2 Nd7 16. Nxc6 bxc6 17. Bg5 Qf8 18. Rfd1 Nc5 19. Rb1 d5 20. b4 d4 21. Ne2 Nxa4 22. Nxd4 c5 23. Ne2 cxb4 24. Qxb4 Qxb4 25. Rxb4 Nb2 26. Rd2 Nxc4 27. Rc2 Ne5 28. Ra2 Nd3 29. Rb3 Nc5 30. Rba3 Bf8 31. Kf2 Ra7 32. Kg3 Rd7 33. Be3 Bd6+ 34. Kh3 Nxe4 35. fxe4 Bxa3 36. Rxa3 Rc4 37. Ng3 Kg7 38. Bf4 f6 39. Rxa6 e5 40. Be3 Rc3 41. Bf2 h5 42. Kh4 Rc2 43. Be3 Rxg2 44. Kh3 Rc2 45. Ra3 Rdc7 46. Bb6 Rb7 47. Be3 Rcb2 48. Ra6 R2b3 49. Bf2 Rc7 50. Ra2 Rcb7 51. Ra6 Rb2 52. Be3 Rc2 53. Ra1 Rb3 54. Ra7+ Kg8 55. Ra8+ Kf7 56. Ra7+ Ke8 57. Ra8+ Kd7 58. Ra7+ Kc8 59. Bg1 Rb1 60. Ra8+ Kb7 61. Ra7+ Kb8 62. Rf7 Rxg1 63. Rxf6 Rgg2 64. Nf1 Rgf2 65. Rb6+ Kc7 66. Rb1 g5 67. Kg3 Rf4 68. Re1 Rcf2 ', 68);
INSERT INTO final_project.Moves VALUES (34, '1. e4 c5 2. Nf3 d6 3. Bb5+ Bd7 4. Bxd7+ Nxd7 5. O-O Ngf6 6. Qe2 e6 7. b3 g6 8. Bb2 Bg7 9. d4 cxd4 10. Bxd4 O-O 11. Nbd2 Qc7 12. c4 Rfd8 13. Rfd1 b6 14. h3 e5 15. Be3 Qb7 16. Ne1 Nf8 17. Bg5 Ne6 18. Bxf6 Bxf6 19. Nc2 Bg7 20. Ne3 Rf8 21. a4 f5 22. a5 Nd4 23. Qd3 Bh6 24. axb6 axb6 25. Rxa8 Qxa8 26. exf5 gxf5 27. Nd5 Bg7 28. Nxb6 Qe8 29. Nd5 Qh5 30. Re1 Kh8 31. b4 Rg8 32. Nb3 e4 33. Qe3 Nf3+ 34. Kf1 Nh2+ 35. Kg1 Be5 36. Nf6 Nf3+ 37. Kf1 Qxh3 38. Qxf3 Qh1+ ', 38);
INSERT INTO final_project.Moves VALUES (44, '1. e4 c5 2. Nf3 d6 3. Bb5+ Bd7 4. Bxd7+ Qxd7 5. O-O Nf6 6. Re1 Nc6 7. c3 e6 8. d4 cxd4 9. cxd4 d5 10. e5 Ne4 11. Nbd2 Nxd2 12. Bxd2 Be7 13. Rc1 O-O 14. a3 Rfc8 15. Rc3 Qd8 16. Rd3 Rc7 17. h4 h6 18. Nh2 Kh8 19. Qg4 Qg8 20. Rf3 Bf8 21. Nf1 Qh7 22. Ng3 a5 23. Nh5 b5 24. Rc1 Rac8 25. Rxc6 Rxc6 26. Rxf7 Qg8 27. Qg6 R8c7 28. Rf3 b4 29. axb4 axb4 30. Nf4 Rf7 31. Qd3 Rxf4 32. Rxf4 Rc8 33. Qg6 b3 34. Rf7 Ra8 35. Rb7 Qh7 36. h5 Qxg6 37. hxg6 Kg8 38. Rxb3 Ra4 39. Bc3 Ra8 40. Rb6 Be7 41. Rxe6 Kf8 42. f4', 42);
--WWBDB
INSERT INTO final_project.Moves VALUES (5, '1. e4 c5 2. Nf3 d6 3. Bb5+ Bd7 4. Bxd7+ Qxd7 5. O-O Nf6 6. Re1 Nc6 7. c3 e6 8. d4 cxd4 9. cxd4 d5 10. e5 Ne4 11. Nbd2 Nxd2 12. Bxd2 Be7 13. Rc1 O-O 14. a3 Rfc8 15. Rc3 Qd8 16. Rd3 Rc7 17. h4 h6 18. Nh2 Kh8 19. Qg4 Qg8 20. Rf3 Bf8 21. Nf1 Qh7 22. Ng3 a5 23. Nh5 b5 24. Rc1 Rac8 25. Rxc6 Rxc6 26. Rxf7 Qg8 27. Qg6 R8c7 28. Rf3 b4 29. axb4 axb4 30. Nf4 Rf7 31. Qd3 Rxf4 32. Rxf4 Rc8 33. Qg6 b3 34. Rf7 Ra8 35. Rb7 Qh7 36. h5 Qxg6 37. hxg6 Kg8 38. Rxb3 Ra4 39. Bc3 Ra8 40. Rb6 Be7 41. Rxe6 Kf8 42. f4 ', 42);
INSERT INTO final_project.Moves VALUES (16, '1. e4 c5 2. Nf3 d6 3. Bb5+ Bd7 4. Bxd7+ Qxd7 5. O-O Nf6 6. Re1 Nc6 7. c3 e6 8. d4 cxd4 9. cxd4 d5 10. e5 Ne4 11. a3 Be7 12. Qd3 O-O 13. Nbd2 Nxd2 14. Bxd2 f6 15. Bf4 Rac8 16. Re2 fxe5 17. Bxe5 Nxe5 18. Nxe5 Qd6 19. Rae1 Bf6 20. Nf3 Rfe8 21. h4 Re7 22. g3 Rc6 23. Kg2 Qc7 24. Qd2 Qc8 25. Qf4 Rf7 26. Qg4 Re7 27. h5 Qe8 28. Ne5 Bxe5 29. Rxe5 h6 30. R1e2 Qd8 31. Kh3 Qe8 32. f4 Qf7 33. Qg6 Qxg6 34. hxg6 Kf8 35. f5 Ke8 36. g4 Kd7 37. Kh4 Re8 38. g5 hxg5+ 39. Kxg5 Rc1 40. Rxe6 Rg1+ 41. Kf4 Rf1+ 42. Ke5 Rf8 43. Rd6+ Kc7 44. Kxd5 R8xf5+ 45. Re5 Rxe5+ 46. dxe5 Rg1 47. Ke4 Rf1 48. Rd2 Kc6 49. Rd8 ', 49);
INSERT INTO final_project.Moves VALUES (25, '1. e4 c5 2. Nf3 d6 3. Bb5+ Bd7 4. a4 Nc6 5. O-O Nf6 6. Re1 a6 7. Bf1 g6 8. c3 Bg7 9. h3 e5 10. d4 cxd4 11. cxd4 exd4 12. Nxd4 O-O 13. Nc3 Nxd4 14. Qxd4 Nxe4 15. Qb4 Nxc3 16. bxc3 a5 17. Qxd6 Bxc3 18. Bh6 Bxa4 19. Qf4 Re8 20. Rec1 Bxa1 21. Rxa1 Bb3 22. Rc1 Qe7 23. Qg3 a4 24. Rc7 Qe5 25. Bf4 Qe1 26. Rc1 Qe4 27. Bh6 Qe5 28. Bf4 Qb2 29. Bb5 Rac8 30. Bxe8 Rxc1+ 31. Kh2 Re1 32. Bb5 Re4 33. Bd6 h5 34. Qg5 Qxf2 35. Bd3 Qe3 36. Qd8+ Re8 37. Qd7 Qe6 38. Qc7 Bd5 39. Bf4 Bxg2 40. Kxg2 Qd5+ ', 40);
INSERT INTO final_project.Moves VALUES (35, '1. e4 c5 2. Nf3 d6 3. Bb5+ Bd7 4. Bxd7+ Qxd7 5. O-O Nc6 6. Qe2 Nf6 7. Rd1 e6 8. d4 cxd4 9. Nxd4 Rc8 10. c4 a6 11. Nc3 Qc7 12. b3 Be7 13. Bb2 O-O 14. Rac1 Qb8 15. Nxc6 Rxc6 16. f4 Rd8 17. Kh1 Bf8 18. e5 Ne8 19. Ne4 Qc8 20. Ng5 h6 21. Nf3 d5 22. cxd5 Rxd5 23. Rxd5 Rxc1+ 24. Bxc1 exd5 25. Be3 Qf5 26. Kg1 Nc7 27. Nd4 Qb1+ 28. Kf2 Bb4 29. Qc2 Qe1+ 30. Kf3 Qf1+ 31. Bf2 Ne6 32. Nxe6 fxe6 33. Qg6 d4 34. Qxe6+ Kh7 35. Qf5+ Kg8 36. Qc8+ Kh7 37. Qf5+ Kg8 38. Qe4 d3 39. Qc4+ Kh8 40. Qxb4 Qe2+ 41. Kg3 d2 42. Qf8+ Kh7 43. Qf5+ Kh8 44. Qf8+ Kh7 45. Qf5+ Kh8 46. Qf8+ ', 46);
INSERT INTO final_project.Moves VALUES (45, '1. e4 c5 2. Nf3 d6 3. Bb5+ Bd7 4. Bxd7+ Qxd7 5. c4 Nf6 6. Nc3 g6 7. d4 cxd4 8. Nxd4 Bg7 9. f3 O-O 10. Be3 Nc6 11. Nde2 a6 12. b3 b5 13. cxb5 axb5 14. O-O Qb7 15. Rc1 Rfd8 16. Nd4 Nxd4 17. Bxd4 e5 18. Be3 d5 19. exd5 b4 20. Na4 Nxd5 21. Qe2 e4 22. Rc4 Nxe3 23. Qxe3 exf3 24. Rxf3 Re8 25. Qf4 Be5 26. Qc1 Rad8 27. Rf1 Bd4+ 28. Kh1 Re2 29. Rc6 Rd6 30. Qc4 Rd2 31. Qc1 Rxg2 32. Rc8+ Kg7 33. Rxf7+ Qxf7 34. Rc7 Rg1+ ', 34);
--BBWWW
INSERT INTO final_project.Moves VALUES (6, '1. Nf3 Nf6 2. c4 b6 3. g3 Bb7 4. Bg2 c5 5. O-O g6 6. Nc3 Bg7 7. d4 cxd4 8. Qxd4 O-O 9. Qh4 d6 10. Bh6 Nbd7 11. b3 Rc8 12. Rac1 Rc5 13. Ng5 Bxg2 14. Kxg2 Re8 15. Rfd1 Bh8 16. b4 Qa8+ 17. Kg1 Rcc8 18. Nf3 a5 19. b5 Rc5 20. Nd5 Nxd5 21. Rxd5 Bf6 22. Qg4 Rc7 23. Rdd1 Rec8 24. Qf4 Rc5 25. h4 R8c7 26. Nd2 Rh5 27. Ne4 Rf5 28. Nxf6+ Nxf6 29. Qd4 Qb7 30. e4 Qxe4 31. Qxb6 Rfc5 32. Qa6 Ng4 33. Re1 Qf3 34. Be3 Re5 35. b6 Rxe3 36. Rf1 Rb7 37. Qxa5 Re2 38. Rc3 Qc6 39. Rb3 Ne5 40. a4 Kg7 41. Qb4 Ra2 42. a5 Qxc4 ', 42);
INSERT INTO final_project.Moves VALUES (17, '1. Nf3 Nf6 2. c4 b6 3. g3 Bb7 4. Bg2 g6 5. d4 Bg7 6. O-O O-O 7. Re1 e6 8. Bf4 ', 8);
INSERT INTO final_project.Moves VALUES (26, '1. Nf3 Nf6 2. c4 g6 3. Nc3 d5 4. cxd5 Nxd5 5. d3 Nxc3 6. bxc3 Bg7 7. Qc2 c5 8. g3 b6 9. Bg2 Bb7 10. O-O O-O 11. Rb1 Nc6 12. Rd1 Rc8 13. Bf4 Qd7 14. Qd2 Rfd8 15. Bh6 Qf5 16. Bxg7 Kxg7 17. c4 Qf6 18. Qb2 Qxb2 19. Rxb2 Na5 20. Rdb1 h6 21. h4 Bc6 22. Kh2 e6 23. g4 Rc7 24. Rg1 Re7 25. Kg3 e5 26. Nd2 Bxg2 27. Rxg2 e4 28. Nxe4 Nxc4 29. Rc2 Ne5 30. f3 Nc6 31. Kf2 Nd4 32. Rc4 Rde8 33. h5 g5 34. e3 Nc6 35. Nd6 Rd8 36. Nf5+ Kf8 37. Nxe7 Kxe7 38. Ke2 Kd6 39. f4 b5 40. Re4 gxf4 41. Rxf4 Ke6 42. Rgf2 Ne5 43. d4 cxd4 44. exd4 Nc4 45. Kd3 Nd6 46. Rf6+ Kd5 47. Rc2 Nc4 48. Rxh6 Rg8 49. Rf2 Nd6 50. Rff6 ', 50);
INSERT INTO final_project.Moves VALUES (37, '1. c4 Nf6 2. Nf3 c6 3. Nc3 d5 4. e3 e6 5. b3 Bd6 6. Bb2 O-O 7. Be2 e5 8. cxd5 cxd5 9. Nb5 e4 10. Nfd4 Be5 11. Rc1 a6 12. Na3 Bxd4 13. Bxd4 Nc6 14. Nc2 Nxd4 15. Nxd4 Qd6 16. O-O Bd7 17. d3 Rac8 18. h3 Rxc1 19. Qxc1 Rc8 20. Qb2 Qc5 21. Rd1 h6 22. dxe4 dxe4 23. Bf1 Qg5 24. Kh1 Qh4 25. Rd2 Rc5 26. Qa3 b6 27. b4 Rg5 28. Qxa6 Rg6 29. Qxb6 Kh7 30. Qc7 Ng4 31. g3 Nxf2+ 32. Rxf2 Rxg3 33. Qxd7 Rg6 34. Re2 Qg3 35. Bg2 Rf6 36. Qg4 Rf1+ 37. Bxf1 Qg2+ 38. Bxg2 ', 38);
INSERT INTO final_project.Moves VALUES (46, '1. Nf3 Nf6 2. c4 g6 3. Nc3 d5 4. cxd5 Nxd5 5. h4 Bg7 6. e4 Nxc3 7. dxc3 Qxd1+ 8. Kxd1 Bg4 9. Kc2 Nd7 10. Nd4 a6 11. h5 e5 12. Nb3 O-O-O 13. h6 Bf8 14. Na5 Be6 15. Bc4 Bxc4 16. Nxc4 f6 17. b4 c5 18. a3 b5 19. Na5 c4 20. Nc6 Re8 21. a4 Bd6 22. axb5 axb5 23. Na7+ Kb7 24. Rd1 Bb8 25. Rxd7+ Kb6 26. Be3# ', 26);
--BDWDW
INSERT INTO final_project.Moves VALUES (8, '1. d4 Nf6 2. c4 e6 3. Nf3 d5 4. Nc3 Nbd7 5. cxd5 exd5 6. Bg5 Be7 7. Qc2 O-O 8. e3 c5 9. Bd3 c4 10. Bf5 g6 11. Bxd7 Qxd7 12. O-O Qd8 13. b3 Bf5 14. Qb2 b6 15. Ne5 Rc8 16. bxc4 dxc4 17. Rfd1 Ne4 18. Bxe7 Qxe7 19. Nxe4 Bxe4 20. Rac1 Bd5 21. e4 Bxe4 22. Re1 c3 23. Rxc3 Bd5 24. Rce3 Qg5 25. Rg3 Qf5 26. Ng4 Rfe8 27. Rxe8+ Rxe8 28. h3 Re1+ 29. Kh2 Qf4 30. Ne3 Bb7 31. d5 h5 32. Qd2 Rb1 33. d6 Bc6 34. Nc4 Qxc4 35. d7 Bxd7 36. Qxd7 Qf4 37. Qd3 Rb2 38. h4 Qxh4+ 39. Kg1 Qf6 40. Rf3 Qg5 41. Qc4 Rb1+ 42. Kh2 Qe7 43. Re3 Qd6+ 44. f4 Rb4 45. Re8+ Kg7 46. Qc3+ Qd4 47. Qe1 Qxf4+ 48. g3 Rb2+ 49. Kg1 Qd4+ 50. Kh1 Qd5+ ', 50);
INSERT INTO final_project.Moves VALUES (18, '1. d4 d5 2. c4 e6 3. Nc3 Nf6 4. Nf3 Be7 5. cxd5 exd5 6. Bg5 O-O 7. e3 Re8 8. Qc2 h6 9. Bh4 c6 10. Bd3 ', 10);
INSERT INTO final_project.Moves VALUES (28, '1. d4 Nf6 2. c4 e6 3. Nf3 d5 4. Nc3 Be7 5. Bf4 O-O 6. Rc1 a6 7. cxd5 exd5 8. e3 Bd6 9. Bxd6 Qxd6 10. Bd3 Nc6 11. h3 Re8 12. O-O Ne4 13. Bxe4 dxe4 14. Nd2 Qg6 15. Nd5 Qd6 16. Nc3 Qg6 17. Ne2 Bd7 18. Nf4 Qd6 19. d5 Nb4 20. Nc4 Qh6 21. a3 g5 22. axb4 gxf4 23. exf4 Qxf4 24. Qd4 Bb5 25. Rc3 Bxc4 26. Qxc4 Rad8 27. Rg3+ Kf8 28. Re1 Qe5 29. Qc1 Rd6 30. Rg5 Qe7 31. Rg4 Rg6 32. Rgxe4 Qxe4 33. Rxe4 Rxe4 34. Qxc7 Re7 35. Qc3 Kg8 36. h4 h5 37. Qc8+ Kg7 38. Qf5 Re1+ 39. Kh2 Re2 40. Qf3 Rc2 41. Qd1 Rc4 42. d6 Rc8 43. Qd4+ Kg8 44. d7 Rd8 45. Qe5 Kf8 46. Qc5+ ', 46);
INSERT INTO final_project.Moves VALUES (39, '1. Nf3 Nf6 2. c4 e6 3. Nc3 d5 4. d4 Be7 5. Bf4 O-O 6. e3 b6 7. Bd3 Bb7 8. Rc1 dxc4 9. Bxc4 ', 9);
INSERT INTO final_project.Moves VALUES (48, '1. d4 Nf6 2. c4 e6 3. Nf3 d5 4. Nc3 Nbd7 5. cxd5 exd5 6. Bg5 c6 7. e3 Be7 8. Bd3 Nh5 9. Bxe7 Qxe7 10. O-O g6 11. Rb1 O-O 12. b4 Nhf6 13. Qb3 a6 14. a4 Ne4 15. Bxe4 dxe4 16. Nd2 Nf6 17. Qc4 Bf5 18. Qc5 Qe6 19. Qe5 Qxe5 20. dxe5 Nd7 21. e6 Bxe6 22. Ndxe4 b5 23. Rfd1 Ra7 24. Rd6 bxa4 25. Nxa4 a5 26. bxa5 Rxa5 27. Nac3 Ne5 28. h3 Rc8 29. Rb7 Bf5 30. g4 Bxe4 31. Nxe4 Ra4 32. Nc5 Ra1+ 33. Kg2 Ra2 34. Kg3 h5 35. Re7 Nc4 36. Rdd7 h4+ 37. Kg2 Rf8 38. Rc7 Rc2 39. Ne6 ', 39);
--DBBBB
INSERT INTO final_project.Moves VALUES (10, '1. Nf3 Nf6 2. c4 g6 3. Nc3 Bg7 4. e4 d6 5. d4 O-O 6. Be2 Na6 7. Bf4 e5 8. dxe5 dxe5 9. Bxe5 ', 9);
INSERT INTO final_project.Moves VALUES (27, '1. d4 Nf6 2. c4 g6 3. Nc3 Bg7 4. e4 O-O 5. Nf3 d6 6. Be2 c5 7. O-O Nc6 8. d5 Na5 9. Qc2 e5 10. dxe6 e.p. Bxe6 11. Rd1 Qe7 12. Bf4 Rfd8 13. b3 Nc6 14. Rac1 Bg4 15. Bg5 Bxf3 16. Bxf3 Qe5 17. Bh4 Nd4 18. Qd3 Bh6 19. Rb1 Bg5 20. Bxg5 Qxg5 21. Qe3 Qe5 22. g3 Re8 23. Bg2 a6 24. f4 Qe6 25. Rxd4 cxd4 26. Qxd4 b5 27. cxb5 axb5 28. Nxb5 Rxa2 29. Nc7 Qc8 30. Nxe8 Nxe8 31. Qc4 Qb8 32. Qd4 Qc7 33. Ra1 Qc5', 33);
INSERT INTO final_project.Moves VALUES (40, '1. d4 Nf6 2. c4 d6 3. Nc3 g6 4. e4 Bg7 5. Be2 Na6 6. Nf3 O-O 7. O-O c6 8. Be3 Nc7 9. Nd2 e5 10. d5 c5 11. a3 b6 12. b4 Nfe8 13. Nb5 f5 14. f3 Rf7 15. Qb1 f4 16. Bf2 h5 17. Nxc7 Qxc7 18. Bd1 Bd7 19. Bb3 g5 20. Qc2 Bf6 21. Ba4 Rg7 22. Bxd7 Qxd7 23. Kh1 g4 24. Be1 Rc8 25. Qd3 Bg5 26. bxc5 bxc5 27. Rb1 Nf6 28. Nb3 Kh7 29. Na5 Rcg8 30. Nc6 Qf7 31. Ba5 Qg6 32. Bd8 Nd7 33. Ba5 gxf3 34. Qxf3 Nf6 35. Rfe1 Ng4 36. Bd2 Bh4 37. Re2 Nf2+ 38. Rxf2 Bxf2 39. Qxf2 Qxg2+ 40. Qxg2 Rxg2 41. Rd1 f3 42. Ne7 R8g4 43. Nf5 f2 44. Ng3 Rg1+ ', 44);
INSERT INTO final_project.Moves VALUES (47, '1. d4 Nf6 2. c4 g6 3. Nc3 Bg7 4. e4 d6 5. Nf3 O-O 6. Be2 Bg4 7. O-O Nfd7 8. h3 Bxf3 9. Bxf3 c5 10. e5 cxd4 11. Bxb7 dxc3 12. Bxa8 Nxe5 13. bxc3 Nxc4 14. Rb1 Nd7 15. Bd5 Ncb6 16. Bg5 h6 17. Be3 Qc7 18. Bb3 Nc5 19. Qf3 e6 20. c4 a5 21. Rfc1 Nbd7 22. Bc2 Ne5 23. Qe2 Nc6 24. a3 h5 25. Rd1 Rd8 26. f4 Bf6 27. Kh1 h4 28. Qf3 Kg7 29. Bf2 a4 30. Qg4 Rh8 31. Qe2 Na5 32. Rb5 Nab3 33. Qg4 Qe7 34. Rb6 Rd8 35. Qf3 Na5 36. Rb4 Rc8 37. Qe2 Nc6 38. Rb6 Qc7 39. Rb5 Na7 40. Rbb1 Nc6 41. Bxc5 dxc5 42. Qe4 Kf8 43. Bxa4 Nd4 44. Rb7 Qa5 45. Bd7 Rc7 46. Rxc7 Qxc7 47. Bb5 Nf5 48. Qf3 Bd4 49. a4 Be3 50. Rd7 Qb8 51. Rb7 Qd8 52. Kh2 Qd4 53. Rd7 Bxf4+ ', 53);
INSERT INTO final_project.Moves VALUES (50, '1. Nf3 Nf6 2. c4 g6 3. Nc3 Bg7 4. e4 O-O 5. d4 d6 6. Be2 Nbd7 7. Be3 e5 8. d5 Ng4 9. Bd2 f5 10. h3 Nxf2 11. Kxf2 fxe4 12. Nxe4 Qh4+ 13. Kg1 Qxe4 14. Kh2 Nc5 15. b4 Nd3 16. Ng5 Qd4 17. Bxd3 Qxd3 18. Rc1 Rf2 ', 18);

INSERT INTO final_project.PlayerHistory VALUES (3, '22/8/1990', 'USSR', 1830);
INSERT INTO final_project.PlayerHistory VALUES (4, '22/8/1990', 'USSR', 2605);
INSERT INTO final_project.PlayerHistory VALUES (3, '26/12/1991', 'Russia', 1834);
INSERT INTO final_project.PlayerHistory VALUES (4, '26/12/1991', 'Russia', 2617);
INSERT INTO final_project.PlayerHistory VALUES (2, '23/5/2015', 'USA', 1900);
INSERT INTO final_project.PlayerHistory VALUES (2, '24/6/2014', 'Italy', 1900);
INSERT INTO final_project.PlayerHistory VALUES (2, '18/10/2018', 'USA', 1923);
INSERT INTO final_project.PlayerHistory VALUES (1, '23/03/2021', 'Norway', 2847);
INSERT INTO final_project.PlayerHistory VALUES (5, '14/04/2021', 'Russia', 2784);
INSERT INTO final_project.PlayerHistory VALUES (6, '6/03/2021', 'Armenia', 1696);
INSERT INTO final_project.PlayerHistory VALUES (7, '9/02/2021', 'USA', 1608);
INSERT INTO final_project.PlayerHistory VALUES (8, '28/04/2021', 'Netherlands', 2549);
INSERT INTO final_project.PlayerHistory VALUES (9, '12/11/2020', 'India', 2353);
INSERT INTO final_project.PlayerHistory VALUES (10, '26/2/2021', 'Poland', 1654);
INSERT INTO final_project.PlayerHistory VALUES (11, '12/4/2021', 'Azerbaijan', 1953);
INSERT INTO final_project.PlayerHistory VALUES (12, '1/5/2021', 'USA', 1702);
INSERT INTO final_project.PlayerHistory VALUES (13, '17/3/2021', 'Russia', 2491);
INSERT INTO final_project.PlayerHistory VALUES (14, '22/1/2021', 'France', 2000);
INSERT INTO final_project.PlayerHistory VALUES (15, '9/04/2008', 'England', 1387);

insert into final_project.playerhistory values (5, '26/5/2019', 'Russia', 2735);
insert into final_project.playerhistory values (5, '12/11/2019', 'Russia', 2700);
insert into final_project.playerhistory values (5, '3/2/2020', 'Russia', 2658);
insert into final_project.playerhistory values (5, '6/7/2020', 'Russia', 2712);
insert into final_project.playerhistory values (5, '21/10/2020', 'Russia', 2724);
insert into final_project.playerhistory values (5, '26/1/2021', 'Russia', 2746);

-- 3, 4, 9, 15
insert into final_project.playerhistory values (3, '21/3/1987', 'USSR', 1904);
insert into final_project.playerhistory values (4, '26/9/1987', 'USSR', 2630);
insert into final_project.playerhistory values (9, '1/6/1987', 'India', 2145);
insert into final_project.playerhistory values (12, '21/2/1987', 'USA', 1943);
-- 1, 2, 4, 6, 8, 10, 14, 15
insert into final_project.playerhistory values (1, '21/3/2017', 'Norway', 2743);
insert into final_project.playerhistory values (2, '21/3/2017', 'USA', 2021);
insert into final_project.playerhistory values (4, '21/3/2017', 'Russia', 2600);
insert into final_project.playerhistory values (6, '21/3/2017', 'Armenia', 1700);
insert into final_project.playerhistory values (8, '21/3/2017', 'Netherlands', 2100);
insert into final_project.playerhistory values (10, '21/3/2017', 'Poland', 1643);
insert into final_project.playerhistory values (14, '21/3/2017', 'France', 2056);
insert into final_project.playerhistory values (15, '21/3/2017', 'England', 1432);
-- 1, 4, 6, 7, 9, 11
insert into final_project.playerhistory values (1, '28/6/2012', 'Norway', 2741);
insert into final_project.playerhistory values (4, '28/6/2012', 'Russia', 2641);
insert into final_project.playerhistory values (6, '28/6/2012', 'Armenia', 1715);
insert into final_project.playerhistory values (7, '28/6/2012', 'USA', 1643);
insert into final_project.playerhistory values (9, '28/6/2012', 'India', 2319);
insert into final_project.playerhistory values (11, '28/6/2012', 'Azerbaijan', 1964);
-- 2, 6, 7, 10, 12, 15
insert into final_project.playerhistory values (2, '28/2/2015', 'Italy', 1844);
insert into final_project.playerhistory values (6, '28/2/2015', 'Armenia', 1709);
insert into final_project.playerhistory values (7, '28/2/2015', 'USA', 1714);
insert into final_project.playerhistory values (10, '28/2/2015', 'Poland', 1632);
insert into final_project.playerhistory values (12, '28/2/2015', 'USA', 1687);
insert into final_project.playerhistory values (15, '28/2/2015', 'England', 1743);
-- 1, 2, 3, 5, 6, 9, 11, 15
insert into final_project.playerhistory values (1, '4/11/2019', 'Italy', 2732);
insert into final_project.playerhistory values (2, '4/11/2019', 'USA', 1964);
insert into final_project.playerhistory values (3, '4/11/2019', 'Russia', 1874);
insert into final_project.playerhistory values (5, '4/11/2019', 'Russia', 2741);
insert into final_project.playerhistory values (6, '4/11/2019', 'Armenia', 1684);
insert into final_project.playerhistory values (9, '4/11/2019', 'India', 2364);
insert into final_project.playerhistory values (11, '4/11/2019', 'Azerbaijan', 1913);
insert into final_project.playerhistory values (15, '4/11/2019', 'England', 1745);

-- DDL
alter table final_project.Party drop column DebutCode;
truncate final_project.debuts;

ALTER TABLE final_project.Party ADD CONSTRAINT FK_WPlayerParty FOREIGN KEY(WhitePlayerID, TournamentID)
        REFERENCES final_project.PlayerInTournament(PlayerID, TournamentID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE;
ALTER TABLE final_project.Party ADD CONSTRAINT FK_BPlayerParty FOREIGN KEY(BlackPlayerID, TournamentID)
        REFERENCES final_project.PlayerInTournament(PlayerID, TournamentID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE;


-- Написать CRUD-запросы (INSERT, SELECT, UPDATE, DELETE) к каждой таблице БД.
-- 2. Moves
SELECT PartyID, MovesCount
FROM final_project.Moves
WHERE MovesCount > 50;
-- 3. Organizers
DELETE FROM final_project.Organizers WHERE name = 'Universal Event Promotion';
-- 4. Party
UPDATE final_project.Party SET PartyID = 1024 WHERE PartyID = 3;
-- 5. Player
SELECT namesurname
FROM final_project.Player
WHERE Country = 'Russia';
-- 6. PlayerHistory
INSERT INTO final_project.PlayerHistory VALUES (10, '25/1/2018', 'Pakistan', 2380);
UPDATE final_project.PlayerHistory SET Country = 'India' WHERE PlayerID = 10 AND UpdateTime = '25/1/2018';
-- 7. PlayerInTournament
CREATE TABLE public.new_tournament_info as
    SELECT tournamentid, count(PlayerID) as players_count, sum(cashprize) as prizepool
    FROM final_project.PlayerInTournament
    GROUP BY tournamentid;
-- 8. Tournament
UPDATE final_project.Tournament SET Country = 'Mexico' WHERE Name = 'EagleMinds Grand';
-- 9. Tournament Organizers
SELECT Name
FROM final_project.TournamentOrganizers t1
JOIN final_project.Tournament t2
ON t1.TournamentID = t2.TournamentID
WHERE t1.OrganizerId = 1;

SELECT organizerid, sum(moneyspent) as TournamentCost
FROM final_project.tournamentorganizers
GROUP BY organizerid;