# Домашнее задание к лекции #4 «Группировки, выборки из нескольких таблиц»
# Написать SELECT-запросы, которые выведут информацию согласно инструкциям ниже.
# Внимание! Результаты запросов не должны быть пустыми (при необходимости добавьте данные в таблицы).
#
import sqlalchemy
from pprint import pprint

if __name__ == '__main__':
    db = 'postgresql://postgres:admin@localhost:5432/py49db'
    engine = sqlalchemy.create_engine(db)
    connection = engine.connect()

    # 1. количество исполнителей в каждом жанре;
    sel = connection.execute("""
    SELECT g.genre_name, count(a.artist_id) FROM genre g JOIN artistgenre a 
    ON g.id = a.genre_id
    GROUP BY g.genre_name;
    """).fetchall()
    print(f'1. Количество исполнителей в каждом жанре:')
    pprint(sel)

    # 2. количество треков, вошедших в альбомы 2019-2020 годов;
    sel = connection.execute("""
    SELECT count(1) FROM album a JOIN track t ON a.id = t.album_id 
    WHERE a.album_year BETWEEN '2019' AND '2020'
    """).fetchall()
    print(f'\n2. Количество треков, вошедших в альбомы 2019-2020 годов:\n{sel}')

    # 3. средняя продолжительность треков по каждому альбому;
    sel = connection.execute("""
    SELECT a.album_name, to_char(concat(avg(t.track_time))::interval,'MI:SS') 
    FROM album a JOIN track t ON a.id = t.album_id 
    GROUP BY a.id
    ORDER BY a.id
    """).fetchall()
    print(f'\n3. Cредняя продолжительность треков по каждому альбому:')
    pprint(sel)

    # 4. все исполнители, которые не выпустили альбомы в 2020 году;
    sel = connection.execute("""
    SELECT a.name 
    FROM artist a JOIN artistalbum a2 ON a.id = a2.artist_id JOIN album a3 ON a3.id = a2.album_id
    WHERE a3.album_year != '2020' -- Кроме Бетховена
    """).fetchall()
    print(f'\n4. Все исполнители, которые не выпустили альбомы в 2020 году:')
    pprint(sel)

    # 5. названия сборников, в которых присутствует конкретный исполнитель (Sting);
    sel = connection.execute("""
    SELECT a.album_name
    FROM album a JOIN artistalbum a2 ON a.id = a2.album_id JOIN artist a3 ON a3.id = a2.artist_id
    WHERE a3.name = 'Sting'
    """).fetchall()
    print(f'\n5. Названия сборников, в которых присутствует конкретный исполнитель (по выбору):')
    pprint(sel)

    # 6. название альбомов, в которых присутствуют исполнители более 1 жанра;
    sel = connection.execute("""
    SELECT a.album_name,a.album_year, a3.name
    FROM album a JOIN artistalbum a2 ON a.id = a2.album_id 
                 JOIN artist a3 ON a3.id = a2.artist_id
                 JOIN artistgenre a4 ON a3.id = a4.artist_id
    GROUP BY a.album_name,a.album_year, a3.name
    HAVING count(1) > 1
    """).fetchall()
    print(f'\n6. Название альбомов, в которых присутствуют исполнители более 1 жанра:')
    pprint(sel)

    # 7. наименование треков, которые не входят в сборники; -- 6 трек не входит в сборники
    sel = connection.execute("""
    SELECT a.track_name, to_char(concat(track_time)::interval,'MI:SS') 
    FROM track a LEFT JOIN trackcollection t ON a.id = t.track_id
    WHERE t.track_id IS NULL
    
    """).fetchall()
    print(f'\n7. Наименование треков, которые не входят в сборники:')
    pprint(sel)

    # 8. Исполнитель(и), написавшего самый короткий по продолжительности трек
    # (теоретически таких треков может быть несколько);
    sel = connection.execute("""
    SELECT a.name, a3.album_name, t.track_name, t.track_time, to_char(concat(t.track_time)::interval,'MI:SS')
    FROM artist a JOIN artistalbum a2 ON a.id = a2.artist_id JOIN album a3 ON a3.id = a2.album_id 
    JOIN track t ON a3.id = t.album_id
    WHERE t.track_time = (select min(track_time) from track) 
    """).fetchall()
    print(f'\n8. исполнителя(-ей), написавшего самый короткий трек:')
    pprint(sel)

    # 9. название альбомов, содержащих наименьшее количество треков.
    sel = connection.execute("""
    SELECT a.album_name, count(t.id)
    FROM album a JOIN track t on a.id = t.album_id 
    GROUP BY a.id
    HAVING count(t.id) = (SELECT count(1) FROM track tt GROUP BY tt.album_id ORDER BY 1 LIMIT 1)
    """).fetchall()
    print(f'\n9. название альбомов, содержащих наименьшее количество треков:')
    pprint(sel)
