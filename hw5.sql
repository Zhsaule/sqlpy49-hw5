-- Домашнее задание к лекции #5 «Группировки, выборки из нескольких таблиц»

drop table if exists Track cascade ;
drop table if exists Album cascade ;
drop table if exists Artist cascade ;
drop table if exists Collection cascade ;
drop table if exists Genre cascade ;
drop table if exists ArtistGenre cascade ;
drop table if exists ArtistAlbum cascade ;
drop table if exists TrackCollection cascade ;

-- 1 блок CREATE запросы:
create table if not exists Genre (
    id serial primary key,
    genre_name varchar(100) not null unique
);

create table if not exists Artist (
    id serial primary key,
    name varchar(100) not null unique
);

create table if not exists ArtistGenre (
    artist_id integer references Artist(id),
    genre_id integer references Genre(id),
    constraint pk_ArtistGenre primary key (artist_id, genre_id)
);

create table if not exists Album (
    id serial primary key,
    album_name varchar(100) not null,
    album_year integer not null check (album_year > 0)
);

create table if not exists ArtistAlbum (
    artist_id integer not null references Artist(id),
    album_id integer not null references Album(id),
    constraint pk_ArtistAlbum primary key (artist_id, album_id)
);

create table if not exists Track (
    id serial primary key,
    track_name varchar(100) not null,
--     track_time interval minute to second not null,
    track_time numeric(6,2) not null check ( track_time > 0 ),
    album_id integer not null references Album(id)
);

create table if not exists Collection (
    id serial primary key,
    collection_name varchar(100) not null,
    collection_year numeric(6,2) not null check ( collection_year > 0 )
);

create table if not exists TrackCollection (
    track_id integer not null references Track(id),
    collection_id integer not null references Collection(id),
    constraint pk_TrackCollection primary key (track_id, collection_id)
);


-- 2 блок с INSERT запросами
-- не менее 5 жанров;
INSERT INTO Genre(genre_name) VALUES
    ('Jazz'), ('Pop Music'), ('Rock'),('Classic'), ('Blues');
-- не менее 8 исполнителей;
INSERT INTO Artist(name) VALUES
    ('Sting'),
    ('Ed Sheeran'),
    ('Ella Fitzgerald'),
    ('Ludwig van Beethoven'),
    ('B.B. King'),
    ('Janis Lyn Joplin'),
    ('Louis Daniel Armstrong'),
    ('Led Zeppelin');

INSERT INTO ArtistGenre(artist_id, genre_id) VALUES (1, 3),(1, 2),
                                                    (2, 2),(2, 3),(2, 5),
                                                    (3, 1),
                                                    (4, 4),
                                                    (5, 5),
                                                    (6, 3),
                                                    (7, 1),
                                                    (8, 3);
-- не менее 8 альбомов;
INSERT INTO Album(album_name, album_year) VALUES
    ('Mercury Falling', 1996),
    ('No.6 Collaborations Project', 2019),
    ('Ella Fitzgerald Sings the George and Ira Gershwin Songbook', 1959),
    ('Beethoven: Complete Piano Sonatas',2020),
    ('Live at the Regal', 1964),
    ('Cheap Thrills', 1968),
    ('Hello, Dolly! (Louis Armstrong album)', 1964),
    ('Led Zeppelin III', 1970);

INSERT INTO ArtistAlbum(artist_id, album_id) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5),
    (6, 6),
    (7, 7),
    (8, 8);


-- не менее 15 треков; Track
INSERT INTO Track(track_name, track_time, album_id)  VALUES
    ('The Hounds of Winter', 327, 1), ('I Hung My Head', 280, 1), --1 2
    ('Beautiful People', 197, 2), ('Cross Me (при участии Chance the Rapper и PnB Rock)', 204, 2), --3 4
    ('Promenade (Walking the Dog)', 151, 3), --5
    ('March of the Swiss Soldiers (Ambulatory Suite)', 124, 3), --6
    ('Piano Sonata No. 29 in B-Flat Major, Op. 106, Hammerklavier: II. Scherzo', 153, 4), --7
    ('It''s My Own Fault', 119, 5), ('Please Love Me', 181,5), -- 8 9
    ('Summertime', 240,6), ('Piece of My Heart', 255,6), --10 11
    ('Hello, Dolly!', 147, 7), ('"It''s Been a Long, Long Time"', 142, 7), -- 12 13
    ('Immigrant Song', 143,8), ('Friends', 234,8); --14 15

-- не менее 8 сборников.
INSERT INTO Collection(collection_name, collection_year) VALUES
    ('Сборник №1 Jazz', 2015),
    ('Сборник №2 Blues&Jazz', 2016),
    ('Сборник №3 Rock', 2017),
    ('Сборник №4 Beethoven', 2018),
    ('Сборник №5 Pop Music', 2019),
    ('Сборник №6 Pop&Rock', 2020),
    ('Сборник №7 Music', 2021),
    ('Сборник №8 All music', 2022);

INSERT INTO trackcollection(track_id, collection_id)  VALUES
    (5,1),(12,1),(13,1),
    (5,2),(12,2),(13,2),(8,2),(9,2),
    (1,3),(2,3),(14,3),(15,3),(10,3),(11,3),
    (7,4),
    (3,5),(4,5),
    (1,6),(2,6),(3,6),(4,6),(10,6),(11,6),(14,6), (15,6),
    (1,7),(2,7),(3,7),(10,7),(14,7),(15,7),(11,7),
    (1,8),(2,8),(3,8),(4,8),(5,8),(7,8),(8,8),(9,8),(10,8),(11,8),(12,8),(13,8),(14,8),(15,8);