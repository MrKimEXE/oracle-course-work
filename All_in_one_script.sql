--Создание пользователя админа
CREATE USER RGR_admin IDENTIFIED BY NoviyParol
    DEFAULT TABLESPACE USERS
    temporary tablespace TEMP;
/
--Выдача прав для админа
GRANT CREATE SESSION TO RGR_admin with admin option
/

GRANT CREATE USER to RGR_admin with admin option
/
Grant drop user to RGR_admin with admin option
/
Grant alter user to RGR_admin with admin option
/

GRANT CREATE Profile to RGR_admin with admin option
/
GRANT Drop Profile to RGR_admin with admin option
/
Grant alter profile to RGR_admin with admin option
/
Grant Create role to RGR_admin with admin option
/
--

Grant create tablespace to RGR_admin with admin option
/
Grant drop tablespace to RGR_admin with admin option
/
Grant alter tablespace to RGR_admin with admin option
/

Grant create procedure to RGR_admin with admin option
/
--Grant delete procedure to RGR_admin with admin option
/

Grant create view to RGR_admin with admin option
/
--Grant delete view to RGR_admin with admin option
/

    Grant create sequence to RGR_admin with admin option
/
--Grant delete sequence to RGR_admin with admin option
/

Grant create table to RGR_admin with admin option
/
--Grant delete table to RGR_admin with admin option
/

Grant create trigger to RGR_admin with admin option
/
--Grant delete trigger to RGR_admin with admin option
/

Grant create view to RGR_admin with admin option
/
--Grant drop view to RGR_admin with admin option
/

commit;
/
--Подключение к базе из под ее админа RGR_admin
connect RGR_admin/NoviyParol@orcl;
/
--Создание табличного пространства RGR
create tablespace RGR1
    datafile '/u01/app/oracle/product/19.3.0/dbhome_1/data/wallet/rgr1.dbf'
    size 100M
    autoextend on next 50M
    maxsize unlimited
    logging
    online
    extent management local segment space management auto;
/
--Назначение табличного пространства по умолчанию и выделение безлимитной квоты пользователю
alter user RGR_admin default tablespace rgr1;
alter user RGR_admin quota unlimited on rgr1;
/
--Создание последовательности для таблицы UserLoginPassword
create sequence userloginpassword_id_numbering_seq
    increment by 1
    start with 1
    minvalue 0
    maxvalue 9999
    nocache
    nocycle;
/
--Создание последовательности для таблицы  Post
create sequence post_id_numbering_seq
    increment by 1
    start with 1
    minvalue 0
    maxvalue 9999
    nocache
    nocycle;
/
--Создание последовательности для таблицы  Community
create sequence community_id_numbering_seq
    increment by 1
    start with 1
    minvalue 0
    maxvalue 9999
    nocache
    nocycle;
/
--Создание последовательности для таблицы  Playlist
create sequence playlist_id_numbering_seq
    increment by 1
    start with 1
    minvalue 0
    maxvalue 9999
    nocache
    nocycle;
/
--Создание последовательности для таблицы Track
create sequence track_id_numbering_seq
    increment by 1
    start with 1
    minvalue 0
    maxvalue 9999
    nocache
    nocycle;
/
--Создание последовательности для таблицы Photoalbum
create sequence photoalbum_id_numbering_seq
    increment by 1
    start with 1
    minvalue 0
    maxvalue 9999
    nocache
    nocycle;
/
--Создание последовательности для таблицы Photo
create sequence photo_id_numbering_seq
    increment by 1
    start with 1
    minvalue 0
    maxvalue 9999
    nocache
    nocycle;
/
--Создание последовательности для таблицы DocumentFolder
create sequence documentfolder_id_numbering_seq
    increment by 1
    start with 1
    minvalue 0
    maxvalue 9999
    nocache
    nocycle;
/
--Создание последовательности для таблицы Doc
create sequence doc_id_numbering_seq
    increment by 1
    start with 1
    minvalue 0
    maxvalue 9999
    nocache
    nocycle;
/
--Создание последовательности для таблицы Dialogue
create sequence dialogue_id_numbering_seq
    increment by 1
    start with 1
    minvalue 0
    maxvalue 9999
    nocache
    nocycle;
/
--Создание последовательности для таблицы MessageInformation
create sequence messageinformation_id_numbering_seq
    increment by 1
    start with 1
    minvalue 0
    maxvalue 9999
    nocache
    nocycle;
/
--Создание таблицы UserLoginPassword
create table UserLoginPassword(
                                  user_id number not null primary key,
                                  user_login varchar2(50) not null,
                                  user_password varchar2(20) not null
);
/
--Создание таблицы UserInformation
create table UserInformation(
                                user_id number not null primary key Constraint FK_UserInformation_UserLoginPassword references UserLoginPassword (user_id) on delete cascade,
                                user_surname varchar2(60) not null,
                                user_name varchar2(60) not null,
                                user_sex nvarchar2(10) not null Check(user_sex = 'мужской' or user_sex = 'женский'),
                                user_birthdate date not null,
                                user_city nvarchar2(60) null
);
alter table UserInformation modify user_sex default 'мужской';
/
--Создание таблицы Post
create table Post(
                     post_id number not null primary key,
                     post_type varchar2(20) not null Check(post_type = 'user' or post_type = 'community'),
                     post_text nvarchar2(255) not null,
                     post_theme varchar2(20) null Check(post_theme in ('Другое', 'Арт', 'IT', 'Игры', 'Музыка', 'Фото', 'Наука', 'Спорт', 'Туризм', 'Кино', 'Юмор', 'Стиль')),
                     post_count_likes number(38, 0) null,
                     post_count_comments number(38, 0) null,
                     post_count_reposts number(38, 0) null
);
alter table Post modify post_type default 'user';
alter table Post modify post_theme default 'Другое';
/
--Создание таблицы UsersPosts
Create Table UsersPosts(
                           up_user_id number(38, 0) not null,
                           up_post_id number(38, 0) not null,
                           Constraint PK_UsersPosts Primary Key (up_user_id, up_post_id),
                           Constraint FK_UsersPosts_UserLoginPassword Foreign Key (up_user_id) References UserLoginPassword (user_id) on delete cascade,
                           Constraint FK_UsersPosts_Community Foreign Key (up_post_id) References Post (post_id) on delete cascade
);
/
--Создание таблицы Community
Create Table Community(
                          community_id number(38, 0) not null,
                          community_name nvarchar2(30) not null,
                          community_description nvarchar2(255) null,
                          community_author_id number not null,
                          community_type varchar2(60) not null Check(
                              community_type in ('Другое', 'Бизнес', 'Тематическое сообщество', 'Бренд или организация', 'Группа по интересам', 'Публичная страница', 'Мероприятие')
                              ),
                          community_count_of_users number(38, 0) not null,
                          community_theme varchar2(50) not null Check(
                              community_theme in ('Другое', 'Авто, мото', 'Города, страны', 'Дом, ремонт', 'Компьютер, интернет', 'Красота и здоровье', 'Музыка', 'Объединения, группы людей', 'Отношения, семья', 'Развлечения', 'Спорт', 'Увлечения и хобби')
                              ),
                          Constraint PK_Community Primary Key (community_id),
                          Constraint FK_Community_UserLoginPassword Foreign Key (community_author_id) References UserLoginPassword (user_id) on delete cascade
);
alter table Community modify community_type default 'Другое';
alter table Community modify community_theme default 'Другое';
/
--Создание таблицы CommunitiesMembers
Create Table CommunitiesMembers(
                                   cm_user_id number(38, 0) not null ,
                                   cm_community_id number(38, 0) not null,
                                   Constraint PK_CommunitiesMembers Primary Key (cm_user_id, cm_community_id),
                                   Constraint FK_CommunitiesMembers_UserLoginPassword Foreign Key (cm_user_id) References UserLoginPassword (user_id) on delete cascade,
                                   Constraint FK_CommunitiesMembers_Community Foreign Key (cm_community_id) References Community (community_id) on delete cascade
);
/
--Создание таблицы CommunitiesPosts
Create Table CommunitiesPosts(
                                 cp_community_id number(38, 0) not null ,
                                 cp_post_id number(38, 0) not null,
                                 Constraint PK_CommunitiesPosts Primary Key (cp_community_id, cp_post_id),
                                 Constraint FK_CommunitiesPosts_Community Foreign Key (cp_community_id) References Community (community_id) on delete cascade,
                                 Constraint FK_CommunitiesPosts_Post Foreign Key (cp_post_id) References Post (post_id) on delete cascade
);
/
--Создание таблицы Playlist
Create Table Playlist(
                         playlist_id number(38, 0) not null,
                         playlist_date_of_creation date not null,
                         playlist_tracks_count number(38, 0) not null,
                         playlist_count_of_learning number(38, 0) not null,
                         Constraint PK_Playlist Primary Key (playlist_id)
);
/
--Создание таблицы Track
Create Table Track(
                      track_id number(38, 0) not null,
                      track_name nvarchar2(50) not null,
                      track_author nvarchar2(50) not null,
                      track_cover bfile null,
                      track_file varchar2(100) not null,
                      track_time char(15) not null,
                      track_genre varchar2(20) not null Check(
                          track_genre in ('Другое', 'Rock', 'Pop', 'Rap and Hip-Hop', 'Easy Listening', 'Dance and House', 'Instrumental', 'Metal', 'Alternative', 'Dubstep', 'Jazz and Blues', 'Drum and Bass', 'Trance', 'Chanson', 'Ethnic', 'Acoustic and Vocal', 'Reggae', 'Classical', 'Indie Pop', 'Speech', 'Electropop and Disco')
                          ),
                      track_count_of_learning number(38, 0) not null,
                      Constraint PK_Track Primary Key (track_id)
);
alter table Track modify track_genre default 'Другое';
/
--Создание таблицы Photoalbum
Create Table Photoalbum(
                           photoalbum_id number(38, 0) not null,
                           photoalbum_name nvarchar2(50) not null,
                           photoalbum_date_of_creation date not null,
                           photoalbum_photos_count number(38, 0) not null,
                           Constraint PK_Photoalbum Primary Key (photoalbum_id)
);
/
--Создание таблицы Photo
Create Table Photo(
                      photo_id number(38, 0) not null,
                      photo_file varchar2(100) not null,
                      photo_date_of_creation date not null,
                      photo_geolocation nvarchar2(60) null,
                      Constraint PK_Photo Primary Key (photo_id)
);
/
--Создание таблицы DocumentFolder
Create Table DocumentFolder(
                               dfolder_id number(38, 0) not null,
                               dfolder_name nvarchar2(50) not null,
                               dfolder_date_of_creation date not null,
                               dfolder_documents_count number(38, 0) not null,
                               Constraint PK_DocumentFolder Primary Key (dfolder_id)
);
/
--Создание таблицы Doc
Create Table Doc(
                    document_id number(38, 0) not null,
                    document_name nvarchar2(50) not null,
                    document_file varchar2(100) not null,
                    document_date_of_creation date not null,
                    Constraint PK_Document Primary Key (document_id)
);
/
--Создание таблицы UsersMusic
Create Table UsersMusic(
                           um_user_id number(38, 0) not null ,
                           um_playlist_id number(38, 0) not null,
                           um_track_id number(38, 0) not null,
                           Constraint PK_UsersMusic Primary Key (um_user_id, um_playlist_id, um_track_id),
                           Constraint FK_UsersMusic_UserLoginPassword Foreign Key (um_user_id) References UserLoginPassword (user_id) on delete cascade,
                           Constraint FK_UsersMusic_Playlist Foreign Key (um_playlist_id) References Playlist (playlist_id) on delete cascade,
                           Constraint FK_UsersMusic_Track Foreign Key (um_track_id) References Track (track_id) on delete cascade
);
/
--Создание таблицы UsersPhotoAlbums
Create Table UsersPhotoAlbums(
                                 upa_user_id number(38, 0) not null ,
                                 upa_photoalbum_id number(38, 0) not null,
                                 upa_photo_id number(38, 0) not null,
                                 Constraint PK_UsersPhotos Primary Key (upa_user_id, upa_photoalbum_id, upa_photo_id),
                                 Constraint FK_UsersPhotos_UserLoginPassword Foreign Key (upa_user_id) References UserLoginPassword (user_id) on delete cascade,
                                 Constraint FK_UsersPhotos_Photoalbum Foreign Key (upa_photoalbum_id) References Photoalbum (photoalbum_id) on delete cascade,
                                 Constraint FK_UsersPhotos_Photo Foreign Key (upa_photo_id) References Photo (photo_id) on delete cascade
);
/
--Создание таблицы UsersDocuments
Create Table UsersDocuments(
                               ud_user_id number(38, 0) not null ,
                               ud_dfolder_id number(38, 0) not null,
                               ud_document_id number(38, 0) not null,
                               Constraint PK_UsersDocuments Primary Key (ud_user_id, ud_dfolder_id, ud_document_id),
                               Constraint FK_UsersDocuments_UserLoginPassword Foreign Key (ud_user_id) References UserLoginPassword (user_id) on delete cascade,
                               Constraint FK_UsersDocuments_DocumentFolder Foreign Key (ud_dfolder_id) References DocumentFolder (dfolder_id) on delete cascade,
                               Constraint FK_UsersDocuments_Doc Foreign Key (ud_document_id) References Doc (document_id) on delete cascade
);
/
--Создание таблицы Dialogue
Create Table Dialogue(
                         dialogue_id number(38, 0) not null,
                         user_id_first number(38, 0) not null,
                         user_id_second number(38, 0) not null,
                         messages_count number(38, 0) not null,
                         Constraint PK_Dialogue Primary Key (dialogue_id),
                         Constraint FK_Dialogue_First_UserLoginPassword Foreign Key (user_id_first) References UserLoginPassword (user_id) on delete cascade,
                         Constraint FK_Dialogue_Second_UserLoginPassword Foreign Key (user_id_second) References UserLoginPassword (user_id) on delete cascade
);
/
--Создание таблицы MessageInformation
Create Table MessageInformation(
                                   message_id number(38, 0) not null,
                                   message_text nvarchar2(255) not null,
                                   message_datetime date not null,
                                   message_status varchar2(20) not null Check(
                                       message_status in ('Отправлено', 'Получено', 'Прочитано')
                                       ),
                                   Constraint PK_MessageInformation Primary Key (message_id)
);
alter table MessageInformation modify message_status default 'Отправлено';
/
--Создание таблицы DialoguesMessages
Create Table DialoguesMessages(
                                  dm_dialogue_id number(38, 0) not null,
                                  dm_message_id number(38, 0) not null,
                                  Constraint PK_DialoguesMessages Primary Key (dm_dialogue_id, dm_message_id),
                                  Constraint FK_DialoguesMessages_Dialogue Foreign Key (dm_dialogue_id) References Dialogue (dialogue_id) on delete cascade,
                                  Constraint FK_DialoguesMessages_Message Foreign Key (dm_message_id) References MessageInformation (message_id) on delete cascade
);
/
commit;
/
--Создание обычного пользователя
CREATE USER RGR_user IDENTIFIED BY NoviyParol
    DEFAULT TABLESPACE RGR1
    temporary tablespace TEMP;
/
--Выдача прав для обычного пользователя
GRANT CREATE SESSION TO RGR_user
/
GRANT SELECT on UserInformation TO RGR_user
    /
    GRANT SELECT on Community TO RGR_user
    /
    GRANT SELECT on Track TO RGR_user
    /
    GRANT SELECT on Post TO RGR_user
    /

--Создание пользователя контент-мейкера
CREATE USER RGR_creator IDENTIFIED BY NoviyParol
    DEFAULT TABLESPACE RGR1
    temporary tablespace TEMP;
/
--Выдача прав для обычного пользователя
GRANT CREATE SESSION TO RGR_creator
/
GRANT SELECT on UserInformation TO RGR_creator
    /
    GRANT SELECT on Community TO RGR_creator
    /
    GRANT SELECT on Track TO RGR_creator
    /
    GRANT SELECT on Post TO RGR_creator
    /

    GRANT SELECT on Track TO RGR_creator
    /
    GRANT Insert on Track TO RGR_creator
              /
              GRANT Update on Track TO RGR_creator
                        /
                        GRANT Delete on Track TO RGR_creator
/
GRANT SELECT on Community TO RGR_creator
    /
    GRANT Insert on Community TO RGR_creator
                                               /
                                               GRANT Update on Community TO RGR_creator
                                                         /
                                                         GRANT Delete on Community TO RGR_creator
/
GRANT SELECT on Post TO RGR_creator
    /
    GRANT Insert on Post TO RGR_creator
                                                                                /
                                                                                GRANT Update on Post TO RGR_creator
                                                                                          /
                                                                                          GRANT Delete on Post TO RGR_creator
/

commit;

/
--Создание таблицы для аудита
create table rgr2_audit(
                           username varchar2(50),
                           modify_date date,
                           modify_time varchar2(50),
                           id_session number,
                           modify_table varchar2(100),
                           action varchar2(50),
                           old_data varchar2(1000),
                           new_data varchar2(1000)
);
/
--Триггер внесения изменений в таблицу UserLoginPassword
create or replace trigger trigger_ULP
    after insert or delete or update on UserLoginPassword
    for each row
begin
    if inserting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'UserLoginPassword', 'Insert', ' ', :new.user_id || ', ' || :new.user_login || ', ' || :new.user_password);
    elsif updating then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'UserLoginPassword', 'Update', :old.user_id || ', ' || :old.user_login || ', ' || :old.user_password, :new.user_id || ', ' || :new.user_login || ', ' || :new.user_password);
    elsif deleting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'UserLoginPassword', 'Delete', :old.user_id || ', ' || :old.user_login || ', ' || :old.user_password,  ' ');
end if;
end;
/
--Триггер внесения изменений в таблицу UserInformation
create or replace trigger trigger_UI
    after insert or delete or update on UserInformation
    for each row
begin
    if inserting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'UserInformation', 'Insert', ' ', :new.user_id || ', ' || :new.user_surname || ', ' || :new.user_name || ', ' || :new.user_sex || ', ' || :new.user_birthdate || ', ' || :new.user_city);
    elsif updating then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'UserInformation', 'Update', :old.user_id || ', ' || :old.user_surname || ', ' || :old.user_name || ', ' || :old.user_sex || ', ' || :old.user_birthdate || ', ' || :old.user_city, :new.user_id || ', ' || :new.user_surname || ', ' || :new.user_name || ', ' || :new.user_sex || ', ' || :new.user_birthdate || ', ' || :new.user_city);
    elsif deleting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'UserInformation', 'Delete', :old.user_id || ', ' || :old.user_surname || ', ' || :old.user_name || ', ' || :old.user_sex || ', ' || :old.user_birthdate || ', ' || :old.user_city,  ' ');
end if;
end;
/
--Триггер внесения изменений в таблицу Post
create or replace trigger trigger_post
    after insert or delete or update on Post
    for each row
begin
    if inserting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'Post', 'Insert', ' ', :new.post_id || ', ' || :new.post_type || ', ' || :new.post_text || ', ' || :new.post_theme || ', ' || :new.post_count_likes || ', ' || :new.post_count_comments || ', ' || :new.post_count_reposts);
    elsif updating then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'Post', 'Update', :old.post_id || ', ' || :old.post_type || ', ' || :old.post_text || ', ' || :old.post_theme || ', ' || :old.post_count_likes || ', ' || :old.post_count_comments || ', ' || :old.post_count_reposts, :new.post_id || ', ' || :new.post_type || ', ' || :new.post_text || ', ' || :new.post_theme || :new.post_count_likes || ', ' || :new.post_count_comments || ', ' || :new.post_count_reposts);
    elsif deleting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'Post', 'Delete', :old.post_id || ', ' || :old.post_type || ', ' || :old.post_text || ', ' || :old.post_theme || ', ' || :old.post_count_likes || ', ' || :old.post_count_comments || ', ' || :old.post_count_reposts,  ' ');
end if;
end;
/
--Триггер внесения изменений в таблицу UsersPosts
create or replace trigger trigger_UP
    after insert or delete or update on UsersPosts
    for each row
begin
    if inserting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'UsersPosts', 'Insert', ' ', :new.up_user_id || ', ' || :new.up_post_id);
    elsif updating then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'UsersPosts', 'Update',  :old.up_user_id || ', ' || :old.up_post_id,  :new.up_user_id || ', ' || :new.up_post_id);
    elsif deleting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'UsersPosts', 'Delete',  :old.up_user_id || ', ' || :old.up_post_id,  ' ');
end if;
end;
/
--Триггер внесения изменений в таблицу Community
create or replace trigger trigger_community
    after insert or delete or update on Community
    for each row
begin
    if inserting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'Community', 'Insert', ' ', :new.community_id || ', ' || :new.community_name || ', ' || :new.community_description || ', ' || :new.community_author_id || ', ' || :new.community_type || ', ' || :new.community_count_of_users || ', ' || :new.community_theme);
    elsif updating then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'Community', 'Update', :old.community_id || ', ' || :old.community_name || ', ' || :old.community_description || ', ' || :old.community_author_id || ', ' || :old.community_type || ', ' || :old.community_count_of_users || ', ' || :old.community_theme, :new.community_id || ', ' || :new.community_name || ', ' || :new.community_description || ', ' || :new.community_author_id || ', ' || :new.community_type || ', ' || :new.community_count_of_users || ', ' || :new.community_theme);
    elsif deleting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'Community', 'Delete', :old.community_id || ', ' || :old.community_name || ', ' || :old.community_description || ', ' || :old.community_author_id || ', ' || :old.community_type || ', ' || :old.community_count_of_users || ', ' || :old.community_theme,  ' ');
end if;
end;
/
--Триггер внесения изменений в таблицу CommunititesMembers
create or replace trigger trigger_CM
    after insert or delete or update on CommunitiesMembers
    for each row
begin
    if inserting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'CommunitiesMembers', 'Insert', ' ', :new.cm_user_id || ', ' || :new.cm_community_id);
    elsif updating then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'CommunitiesMembers', 'Update', :old.cm_user_id || ', ' || :old.cm_community_id, :new.cm_user_id || ', ' || :new.cm_community_id);
    elsif deleting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'CommunitiesMembers', 'Delete', :old.cm_user_id || ', ' || :old.cm_community_id,  ' ');
end if;
end;
/
--Триггер внесения изменений в таблицу CommunititesPosts
create or replace trigger trigger_CP
    after insert or delete or update on CommunitiesPosts
    for each row
begin
    if inserting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'CommunitiesPosts', 'Insert', ' ', :new.cp_community_id || ', ' || :new.cp_post_id);
    elsif updating then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'CommunitiesPosts', 'Update', :old.cp_community_id || ', ' || :old.cp_post_id, :new.cp_community_id || ', ' || :new.cp_post_id);
    elsif deleting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'CommunitiesPosts', 'Delete', :old.cp_community_id || ', ' || :old.cp_post_id,  ' ');
end if;
end;
/
--Триггер внесения изменений в таблицу Playlist
create or replace trigger trigger_pl
    after insert or delete or update on Playlist
    for each row
begin
    if inserting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'Playlist', 'Insert', ' ', :new.playlist_id || ', ' || :new.playlist_date_of_creation || ', ' || :new.playlist_tracks_count || ', ' || :new.playlist_count_of_learning);
    elsif updating then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'Playlist', 'Update', :old.playlist_id || ', ' || :old.playlist_date_of_creation || ', ' || :old.playlist_tracks_count || ', ' || :old.playlist_count_of_learning, :new.playlist_id || ', ' || :new.playlist_date_of_creation || ', ' || :new.playlist_tracks_count || ', ' || :new.playlist_count_of_learning);
    elsif deleting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'Playlist', 'Delete', :old.playlist_id || ', ' || :old.playlist_date_of_creation || ', ' || :old.playlist_tracks_count || ', ' || :old.playlist_count_of_learning,  ' ');
end if;
end;
/
--Триггер внесения изменений в таблицу Track
create or replace trigger trigger_t
    after insert or delete or update on Track
    for each row
begin
    if inserting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'Track', 'Insert', ' ', :new.track_id || ', ' || :new.track_name || ', ' || :new.track_author || ', ' || :new.track_file || ', ' || :new.track_time || ', ' || :new.track_genre || ', ' || :new.track_count_of_learning);
    elsif updating then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'Track', 'Update', :old.track_id || ', ' || :old.track_name || ', ' || :old.track_author || ', ' || :old.track_file || ', ' || :old.track_time || ', ' || :old.track_genre || ', ' || :old.track_count_of_learning, :new.track_id || ', ' || :new.track_name || ', ' ||
                                                                                                                                                                                                                                                                                                                                                                                                 :new.track_author || ', ' || :new.track_file || ', ' || :new.track_time || ', ' || :new.track_genre || ', ' || :new.track_count_of_learning);
    elsif deleting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'Track', 'Delete', :old.track_id || ', ' || :old.track_name || ', ' || :old.track_author || ', ' || :old.track_file || ', ' || :old.track_time || ', ' || :old.track_genre || ', ' || :old.track_count_of_learning,  ' ');
end if;
end;
/
--Триггер внесения изменений в таблицу Photoalbum
create or replace trigger trigger_pa
    after insert or delete or update on Photoalbum
    for each row
begin
    if inserting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'Photoalbum', 'Insert', ' ', :new.photoalbum_id || ', ' || :new.photoalbum_name || ', ' || :new.photoalbum_date_of_creation || ', ' || :new.photoalbum_photos_count);
    elsif updating then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'Photoalbum', 'Update', :old.photoalbum_id || ', ' || :old.photoalbum_name || ', ' || :old.photoalbum_date_of_creation || ', ' || :old.photoalbum_photos_count, :new.photoalbum_id || ', ' || :new.photoalbum_name || ', ' || :new.photoalbum_date_of_creation || ', ' || :new.photoalbum_photos_count);
    elsif deleting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'Photoalbum', 'Delete', :old.photoalbum_id || ', ' || :old.photoalbum_name || ', ' || :old.photoalbum_date_of_creation || ', ' || :old.photoalbum_photos_count,  ' ');
end if;
end;
/
--Триггер внесения изменений в таблицу Photo
create or replace trigger trigger_ph
    after insert or delete or update on Photo
    for each row
begin
    if inserting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'Photo', 'Insert', ' ', :new.photo_id || ', ' || :new.photo_file || ', ' || :new.photo_date_of_creation || ', ' || :new.photo_geolocation);
    elsif updating then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'Photo', 'Update', :old.photo_id || ', ' || :old.photo_file || ', ' || :old.photo_date_of_creation || ', ' || :old.photo_geolocation, :new.photo_id || ', ' || :new.photo_file || ', ' || :new.photo_date_of_creation || ', ' || :new.photo_geolocation);
    elsif deleting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'Photo', 'Delete', :old.photo_id || ', ' || :old.photo_file || ', ' || :old.photo_date_of_creation || ', ' || :old.photo_geolocation,  ' ');
end if;
end;
/
--Триггер внесения изменений в таблицу DocumentFolder
create or replace trigger trigger_df
    after insert or delete or update on DocumentFolder
    for each row
begin
    if inserting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'DocumentFolder', 'Insert', ' ', :new.dfolder_id || ', ' || :new.dfolder_name || ', ' || :new.dfolder_date_of_creation || ', ' || :new.dfolder_documents_count);
    elsif updating then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'DocumentFolder', 'Update', :old.dfolder_id || ', ' || :old.dfolder_name || ', ' || :old.dfolder_date_of_creation || ', ' || :old.dfolder_documents_count, :new.dfolder_id || ', ' || :new.dfolder_name || ', ' || :new.dfolder_date_of_creation || ', ' || :new.dfolder_documents_count);
    elsif deleting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'DocumentFolder', 'Delete', :old.dfolder_id || ', ' || :old.dfolder_name || ', ' || :old.dfolder_date_of_creation || ', ' || :old.dfolder_documents_count,  ' ');
end if;
end;
/
--Триггер внесения изменений в таблицу Doc
create or replace trigger trigger_d
    after insert or delete or update on Doc
    for each row
begin
    if inserting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'Doc', 'Insert', ' ', :new.document_id || ', ' || :new.document_name || ', ' || :new.document_file || ', ' || :new.document_date_of_creation);
    elsif updating then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'Doc', 'Update', :old.document_id || ', ' || :old.document_name || ', ' || :old.document_file || ', ' || :old.document_date_of_creation, :new.document_id || ', ' || :new.document_name || ', ' || :new.document_file || ', ' || :new.document_date_of_creation);
    elsif deleting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'Doc', 'Delete', :old.document_id || ', ' || :old.document_name || ', ' || :old.document_file || ', ' || :old.document_date_of_creation,  ' ');
end if;
end;
/
--Триггер внесения изменений в таблицу UsersMusic
create or replace trigger trigger_um
    after insert or delete or update on UsersMusic
    for each row
begin
    if inserting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'UsersMusic', 'Insert', ' ', :new.um_user_id || ', ' || :new.um_playlist_id || ', ' || :new.um_track_id);
    elsif updating then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'UsersMusic', 'Update', :old.um_user_id || ', ' || :old.um_playlist_id || ', ' || :old.um_track_id, :new.um_user_id || ', ' || :new.um_playlist_id || ', ' || :new.um_track_id);
    elsif deleting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'UsersMusic', 'Delete', :old.um_user_id || ', ' || :old.um_playlist_id || ', ' || :old.um_track_id,  ' ');
end if;
end;
/
--Триггер внесения изменений в таблицу UsersPhotoAlbums
create or replace trigger trigger_upa
    after insert or delete or update on UsersPhotoAlbums
    for each row
begin
    if inserting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'UsersPhotoAlbums', 'Insert', ' ', :new.upa_user_id || ', ' || :new.upa_photoalbum_id || ', ' || :new.upa_photo_id);
    elsif updating then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'UsersPhotoAlbums', 'Update', :old.upa_user_id || ', ' || :old.upa_photoalbum_id || ', ' || :old.upa_photo_id, :new.upa_user_id || ', ' || :new.upa_photoalbum_id || ', ' || :new.upa_photo_id);
    elsif deleting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'UsersPhotoAlbums', 'Delete', :old.upa_user_id || ', ' || :old.upa_photoalbum_id || ', ' || :old.upa_photo_id,  ' ');
end if;
end;
/
--Триггер внесения изменений в таблицу UsersDocuments
create or replace trigger trigger_ud
    after insert or delete or update on UsersDocuments
    for each row
begin
    if inserting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'UsersDocuments', 'Insert', ' ', :new.ud_user_id || ', ' || :new.ud_dfolder_id || ', ' || :new.ud_document_id);
    elsif updating then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'UsersDocuments', 'Update', :old.ud_user_id || ', ' || :old.ud_dfolder_id || ', ' || :old.ud_document_id, :new.ud_user_id || ', ' || :new.ud_dfolder_id || ', ' || :new.ud_document_id);
    elsif deleting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'UsersDocuments', 'Delete', :old.ud_user_id || ', ' || :old.ud_dfolder_id || ', ' || :old.ud_document_id,  ' ');
end if;
end;
/
--Триггер внесения изменений в таблицу Dialogue
create or replace trigger trigger_di
    after insert or delete or update on Dialogue
    for each row
begin
    if inserting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'Dialogue', 'Insert', ' ', :new.dialogue_id || ', ' || :new.user_id_first || ', ' || :new.user_id_second || ', ' || :new.messages_count);
    elsif updating then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'Dialogue', 'Update', :old.dialogue_id || ', ' || :old.user_id_first || ', ' || :old.user_id_second || ', ' || :old.messages_count, :new.dialogue_id || ', ' || :new.user_id_first || ', ' || :new.user_id_second || ', ' || :new.messages_count);
    elsif deleting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'Dialogue', 'Delete', :old.dialogue_id || ', ' || :old.user_id_first || ', ' || :old.user_id_second || ', ' || :old.messages_count,  ' ');
end if;
end;
/
--Триггер внесения изменений в таблицу MessageInformation
create or replace trigger trigger_m
    after insert or delete or update on MessageInformation
    for each row
begin
    if inserting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'MessageInformation', 'Insert', ' ', :new.message_id || ', ' || :new.message_text || ', ' || :new.message_datetime || ', ' || :new.message_status);
    elsif updating then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'MessageInformation', 'Update', :old.message_id || ', ' || :old.message_text || ', ' || :old.message_datetime || ', ' || :old.message_status, :new.message_id || ', ' || :new.message_text || ', ' || :new.message_datetime || ', ' || :new.message_status);
    elsif deleting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'MessageInformation', 'Delete', :old.message_id || ', ' || :old.message_text || ', ' || :old.message_datetime || ', ' || :old.message_status,  ' ');
end if;
end;
/
--Триггер внесения изменений в таблицу DialoguesMessages
create or replace trigger trigger_dm
    after insert or delete or update on DialoguesMessages
    for each row
begin
    if inserting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'DialoguesMessages', 'Insert', ' ', :new.dm_dialogue_id || ', ' || :new.dm_message_id);
    elsif updating then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'DialoguesMessages', 'Update', :old.dm_dialogue_id || ', ' || :old.dm_message_id, :new.dm_dialogue_id || ', ' || :new.dm_message_id);
    elsif deleting then
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'DialoguesMessages', 'Delete', :old.dm_dialogue_id || ', ' || :old.dm_message_id,  ' ');
end if;
end;
/
commit;
/
--Функция на сокращение имени и фамилии пользователя
create or replace function user_fi (u_lname UserInformation.user_surname%type,
                                    u_name UserInformation.user_name%type)
    return varchar2 is
    output varchar2(150);
begin
    if u_lname is null or u_name is null then
        output := '#################';
else
select substr(u_lname, 1, 1) || '. ' || u_name
into output
From dual;
end if;
    return output;
end;
/
--Функция на высчитывание возраста пользователя
create or replace function user_age (u_id UserInformation.user_id%type)
    return number is
    output number;
begin
select floor(months_between(sysdate, user_birthdate)/12)
into output
from UserInformation
where user_id = u_id;
return output;
end;
/
--Функция на изменение статуса сообщения
create or replace function message_status_next
(m_id MessageInformation.message_id%type)
    return varchar2 is
    output varchar2(20);
begin
select message_status
into output
from MessageInformation
where message_id = m_id;
if output = 'Отправлено' then
        output := 'Получено';
    elsif output = 'Получено' then
        output := 'Прочитано';
    elsif output = 'Прочитано' then
        output := 'Отправлено';
end if;
    return output;
end;
/
commit;
/

--Триггер на внесение записей в таблицу UsersMusic
Create or replace trigger insert_um
    before insert on UsersMusic
    for each row
Declare
pl_tracks_count number;
cursor cursor_um is
Select um_playlist_id
From UsersMusic
where um_user_id != :new.um_user_id;
begin
for um_row in cursor_um loop
            If :new.um_playlist_id = um_row.um_playlist_id then
                raise_application_error(-20205, '(Добавление)Музыкальный плейлист не может быть у нескольких пользователей!');
end if;
end loop;
Select playlist_tracks_count
into pl_tracks_count
From Playlist
where playlist_id = :new.um_playlist_id;
pl_tracks_count := pl_tracks_count + 1;
Update Playlist set playlist_tracks_count = pl_tracks_count where playlist_id = :new.um_playlist_id;
end;
/
--insert into UsersMusic values (2, 1, 2);

--Триггер на внесение записей в таблицу UsersPhotoAlbums
Create or replace Trigger insert_upa
    before insert on UsersPhotoAlbums
    for each row
Declare
pp_photos_count number;
cursor cursor_upa is
Select upa_photoalbum_id, upa_photo_id
From UsersPhotoAlbums
where upa_user_id != :new.upa_user_id;
begin
for upa_row in cursor_upa loop
            If :new.upa_photoalbum_id = upa_row.upa_photoalbum_id or :new.upa_photo_id = upa_row.upa_photo_id then
                raise_application_error(-20205, '(Добавление)Фотоальбом или фото не может быть у нескольких пользователей!');
end if;
end loop;
Select photoalbum_photos_count
into pp_photos_count
From Photoalbum
where photoalbum_id = :new.upa_photoalbum_id;
pp_photos_count := pp_photos_count + 1;
Update Photoalbum set photoalbum_photos_count = pp_photos_count where photoalbum_id = :new.upa_photoalbum_id;
end;
/
--insert into UsersMusic values (, , );

--Триггер на внесение и обновление записей в таблице Dialogue
Create or replace Trigger insert_and_update_dialogue
    before insert or update on Dialogue
                                for each row
begin
    If :new.user_id_first = :new.user_id_second then
        raise_application_error(-20205, '(Добавление и обновление)Пользователь не может общаться сам с собой!');
end if;
end;
/
--insert into Dialogue values (10, 1, 1, 0);

--Триггер на внесение записей в таблицу DialoguesMessages
Create or replace Trigger insert_dm
    before insert on DialoguesMessages
    for each row
declare
m_count number;
cursor cursor_dm is
Select dm_message_id
From DialoguesMessages
where dm_dialogue_id != :new.dm_dialogue_id;
begin
for dm_row in cursor_dm loop
            If :new.dm_message_id = dm_row.dm_message_id then
                raise_application_error(-20205, '(Добавление)Сообщение может быть только в одном диалоге!');
end if;
end loop;
Select messages_count
into m_count
From Dialogue
where dialogue_id = :new.dm_dialogue_id;
m_count := m_count + 1;
Update Dialogue set messages_count = m_count where dialogue_id = :new.dm_dialogue_id;
end;
/
--insert into DialoguesMessages values (2, 1);

--Триггер на счет количества подписчиков в сообществе
create or replace trigger community_count_users
    for insert or delete on CommunitiesMembers
    compound trigger
    u_count number;
before each row is
begin
    if inserting then
select community_count_of_users
into u_count
from Community
where community_id = :new.cm_community_id;
u_count := u_count + 1;
    elsif deleting then
select community_count_of_users
into u_count
from Community
where community_id = :old.cm_community_id;
u_count := u_count - 1;
end if;
end before each row;
    after each row is
begin
        if inserting then
update Community set community_count_of_users = u_count where community_id = :new.cm_community_id;
elsif deleting then
update Community set community_count_of_users = u_count where community_id = :old.cm_community_id;
end if;
end after each row;
end community_count_users;
/
--Триггер на счет количества сообщений в диалогах
create or replace trigger dialogue_count_messages
    for insert or delete on DialoguesMessages
    compound trigger
    m_count number;
before each row is
begin
    if inserting then
select messages_count
into m_count
from Dialogue
where dialogue_id = :new.dm_dialogue_id;
m_count := m_count + 1;
    elsif deleting then
select messages_count
into m_count
from Dialogue
where dialogue_id = :old.dm_dialogue_id;
m_count := m_count - 1;
end if;
end before each row;
    after each row is
begin
        if inserting then
update Dialogue set messages_count = m_count where dialogue_id = :new.dm_dialogue_id;
elsif deleting then
update Dialogue set messages_count = m_count where dialogue_id = :old.dm_dialogue_id;
end if;
end after each row;
end dialogue_count_messages;
/
--Триггер на счет количества документов в папках
create or replace trigger dfolder_count_documents
    for insert or delete on UsersDocuments
    compound trigger
    d_count number;
before each row is
begin
    if inserting then
select dfolder_documents_count
into d_count
from DocumentFolder
where dfolder_id = :new.ud_dfolder_id;
d_count := d_count + 1;
    elsif deleting then
select dfolder_documents_count
into d_count
from DocumentFolder
where dfolder_id = :old.ud_dfolder_id;
d_count := d_count - 1;
end if;
end before each row;
    after each row is
begin
        if inserting then
update DocumentFolder set dfolder_documents_count = d_count where dfolder_id = :new.ud_dfolder_id;
elsif deleting then
update DocumentFolder set dfolder_documents_count = d_count where dfolder_id = :old.ud_dfolder_id;
end if;
end after each row;
end dfolder_count_documents;
/
--Триггер на счет количества фотографий в фотоальбоме
create or replace trigger photoalbum_count_photos
    for insert or delete on UsersPhotoAlbums
    compound trigger
    p_count number;
before each row is
begin
    if inserting then
select photoalbum_photos_count
into p_count
from Photoalbum
where photoalbum_id = :new.upa_photoalbum_id;
p_count := p_count + 1;
    elsif deleting then
select photoalbum_photos_count
into p_count
from Photoalbum
where photoalbum_id = :old.upa_photoalbum_id;
p_count := p_count - 1;
end if;
end before each row;
    after each row is
begin
        if inserting then
update Photoalbum set photoalbum_photos_count = p_count where photoalbum_id = :new.upa_photoalbum_id;
elsif deleting then
update Photoalbum set photoalbum_photos_count = p_count where photoalbum_id = :old.upa_photoalbum_id;
end if;
end after each row;
end photoalbum_count_photos;
/
--Триггер на счет количества аудиозаписей в музыке пользователя
create or replace trigger playlist_count_tracks
    for insert or delete on UsersMusic
    compound trigger
    p_count number;
before each row is
begin
    if inserting then
select playlist_tracks_count
into p_count
from Playlist
where playlist_id = :new.um_playlist_id;
p_count := p_count + 1;
    elsif deleting then
select playlist_tracks_count
into p_count
from Playlist
where playlist_id = :old.um_playlist_id;
p_count := p_count - 1;
end if;
end before each row;
    after each row is
begin
        if inserting then
update Playlist set playlist_tracks_count = p_count where playlist_id = :new.um_playlist_id;
elsif deleting then
update Playlist set playlist_tracks_count = p_count where playlist_id = :old.um_playlist_id;
end if;
end after each row;
end playlist_count_tracks;
/
commit;
/




--Вставка значений в таблицу UserLoginPassword
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'mrkim_exe', 'DefaultPassword');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'trymon', 'jALZUtAz');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'aleksencev01', '3AKHKzxm');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'bluepooph', 'jT6LqKBm');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'dzhanibek_02', '4H4y3Nap');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'idlashyn_109', 'WLpCZWjB');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'zhdinka', 'xDuWcy2N');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, '389481064', 'TFCF2D92');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, '208579420', '37NFfQAT');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'tweekt', 'n8HZnmc8');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'deathcomerightnow', 'GwaeJ4mH');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'deadinsaid2', '4mBYJwAN');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'zcherdantsev', 'heHDprwt');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'nalestnice', 'yTNrMQTf');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'ligirfanova', 'S3XELXbk');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'gr1nbags', 'vLXNFrnV');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'v.kanametova1', 'pTZ2w2Xw');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 't_beknur', 'vyC9b2Ga');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'dddjjjjooowoo', 'C7PVcMvW');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'marmeladze_v', 'wgvMBByw');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'zabavqa', 'StudyHUB');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'invalidassjackass', 'hCzrHypE');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, '123703284', 'jFsqKFrP');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, '457975295', '2LDa7vem');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'alex_sindria', 'ZbDupjES');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'mila.nikolaenok', 'aCKFq2Me');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'kkst1488', 'A6CHf8ku');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'motya_ks', '3eNVRpTA');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'bulgucheva1', '8Fp6tLGx');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'revengeofuchixxxa', 'Ycqr6MLx');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, '294876284','9WUKYENt');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'tomas_shellby','dDqrsfKL');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, '154905768', 'XxTGT2YX');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'aisultansa', '25qcYrSW');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'keksikeva', 'NVMpqFpR');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'appolinariya_kostrova', 'krrhKnaF');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'bodenova2000', 'NyDWJSzf');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, '282379068', 'u6Lgf6pb');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'harryaugust', 'xSx6waZh');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'baaaldeej', 'gQTE7q8s');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'zh4n1k', 'M5TnGmP9');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'yarik2000lav', 'W8a5VTfH');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, '404110572', 'K8cX5WSB');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, '456328768', 'kgJcdrcf');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'tsuyumkulov', 'CSZD6E6D');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'ersaralov', 'qV4KbqrU');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'arti_vip777', '8Mje9Eva');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'timaakhriev', '8URBVaXf');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'mo_o_onlight', 'kN9YP7ct');
Insert into UserLoginPassword values (userloginpassword_id_numbering_seq.nextval, 'blacknation1', 't22zGCmC');
/
--Вставка значений в таблицу UserInformation
Insert into UserInformation values (1, 'Ким', 'Константин', 'мужской', '25-05-2001', 'Алматы');
Insert into UserInformation values (2, 'Зальцман', 'Марк', 'мужской', '27-10-1999', 'Алматы');
Insert into UserInformation values (3, 'Алексенцев', 'Илья', 'мужской', '22-12-2001', 'Алматы');
Insert into UserInformation values (4, 'Забровский', 'Дмитрий', 'мужской', '22-09-2001', 'Алматы');
Insert into UserInformation values (5, 'Сарымсаков', 'Джанибек', 'мужской', '18-05-2002', 'Алматы');
Insert into UserInformation values (6, 'Атабай', 'Айбек', 'мужской', '25-05-2001', 'Алматы');
Insert into UserInformation values (7, 'Жаркынбек', 'Динара', 'женский', '31-10-1998', 'Алматы');
Insert into UserInformation values (8, 'Куырдак', 'Жансен', 'мужской', '05-01-1993', 'Алматы');
Insert into UserInformation values (9, 'Кимская', 'Кристина', 'женский', '24-09-1991', 'Тараз');
Insert into UserInformation values (10, 'Donovan', 'Clyde', 'мужской', '27-08-2000', 'Алматы');
Insert into UserInformation values (11, 'Пономарёв', 'Эмиль', 'мужской', '22-06-2001', 'Алматы');
Insert into UserInformation values (12, 'Антипов', 'Артём', 'мужской', '18-10-2003', 'Санкт-Петербург');
Insert into UserInformation values (13, 'Черданцев', 'Женя', 'мужской', '18-10-2001', 'Алматы');
Insert into UserInformation values (14, 'Кузембаев', 'Димаш', 'мужской', '27-08-2000', 'Алматы');
Insert into UserInformation values (15, 'Гимазетдинова', 'Лианна', 'женский', '29-05-2001', 'Алматы');
Insert into UserInformation values (16, 'Гринчеко', 'Богдан', 'мужской', '05-01-2001', 'Алматы');
Insert into UserInformation values (17, 'Канаметова', 'Виктория', 'женский', '05-09-2000', 'Нур-Султан');
Insert into UserInformation values (18, 'Нурсултан', 'Бекнур', 'мужской', '20-09-1998', 'Алматы');
Insert into UserInformation values (19, 'Ким', 'Толик', 'мужской', '25-05-2001', 'Алматы');
Insert into UserInformation values (20, 'Мумладзе', 'Вано', 'мужской', '07-01-2003', 'Алматы');
Insert into UserInformation values (21, 'Бровин', 'Артур', 'мужской', '25-05-2000', 'Алматы');
Insert into UserInformation values (22, 'Ким', 'Илья', 'мужской', '04-04-2001', 'Алматы');
Insert into UserInformation values (23, 'Тюрин', 'Илюша', 'мужской', '02-10-1996', 'Алматы');
Insert into UserInformation values (24, 'Забровская', 'Ксения', 'женский', '08-02-2002', 'Алматы');
Insert into UserInformation values (25, 'Бретцель', 'Саша', 'женский', '13-11-2001', 'Варшава');
Insert into UserInformation values (26, 'Николаёнок', 'Людмила', 'женский', '17-10-2001', 'Алматы');
Insert into UserInformation values (27, 'Ким', 'Константин', 'мужской', '01-01-2001', 'Алматы');
Insert into UserInformation values (28, 'Горбатенко', 'Матвей', 'мужской', '24-12-2001', 'Санкт-Петербург');
Insert into UserInformation values (29, 'Булгучева', 'Тома', 'женский', '05-11-2001', 'Алматы');
Insert into UserInformation values (30, 'Armstrong', 'Rina', 'женский', '01-06-2001', 'Алматы');
Insert into UserInformation values (31, 'Бауыржанулы', 'Арман', 'мужской', '03-09-1999', 'Алматы');
Insert into UserInformation values (32, 'Констанинопольский', 'Томас', 'мужской', '13-08-2001', 'Алматы');
Insert into UserInformation values (33, 'Александров', 'Павел', 'мужской', '15-02-1997', 'Алматы');
Insert into UserInformation values (34, 'Саулебаев', 'Айсултан', 'мужской', '07-09-2000', 'Алматы');
Insert into UserInformation values (35, 'Бретцель', 'Ева', 'женский', '29-05-2002', 'Варшава');
Insert into UserInformation values (36, 'Кострова', 'Апполинария', 'женский', '18-03-2002', 'Алматы');
Insert into UserInformation values (37, 'Боденова', 'Aruzhan', 'женский', '08-03-2004', 'Алматы');
Insert into UserInformation values (38, 'Исаева', 'Инкара', 'женский', '18-12-2002', 'Алматы');
Insert into UserInformation values (39, 'Sabdaliyeva', 'Dilya', 'женский', '31-07-2001', 'Алматы');
Insert into UserInformation values (40, 'Шин', 'Ирина', 'женский', '15-02-2001', 'Алматы');
Insert into UserInformation values (41, 'Ыскаков', 'Жанибек', 'мужской', '28-10-2004', 'Алматы');
Insert into UserInformation values (42, 'Лавров', 'Ярослав', 'мужской', '05-09-2000', 'Алматы');
Insert into UserInformation values (43, 'Сойдере', 'Назерке', 'мужской', '22-05-2001', 'Алматы');
Insert into UserInformation values (44, 'Харитонова', 'Маргарита', 'женский', '29-07-2001', 'Алматы');
Insert into UserInformation values (45, 'Суюмкулов', 'Тимур', 'мужской', '13-08-2001', 'Алматы');
Insert into UserInformation values (46, 'Аралов', 'Ерасыл', 'мужской', '21-10-2002', 'Алматы');
Insert into UserInformation values (47, 'Ашыков', 'Юрий', 'мужской', '06-08-1998', 'Алматы');
Insert into UserInformation values (48, 'Ахриев', 'Тимур', 'мужской', '09-03-2001', 'Алматы');
Insert into UserInformation values (49, 'Иламдунов', 'Ильяр', 'мужской', '23-06-2000', 'Алматы');
Insert into UserInformation values (50, 'Болдаев', 'Даурен', 'мужской', '14-02-2001', 'Алматы');
/
--Вставка значений в таблицу Post
Insert into Post values (post_id_numbering_seq.nextval, 'community', 'Уважаемые студенты! Открыт прием заявок на конкурс бизнес-идей NewGeneration, научно-технических разработок и прототипов среди обучающихся АУЭС', 'IT', 0, 0, 0);
Insert into Post values (post_id_numbering_seq.nextval, 'community', 'Вниманию магистрантов АУЭС!Объявляется прием документов для участия в конкурсе на обучение в Университете прикладных наук Анхальта (Германия) по программе Эразмус+ в осеннем семестре 2021/2022 учебного года для магистрантов АУЭС.', 'Наука', 0, 0, 0);
Insert into Post values (post_id_numbering_seq.nextval, 'community', 'Поздравляем прошедших на следующий этап. Спасибо всем участникам за проявленную инициативу и креатив!Со списком счастливчиков, прошедших в III этап, можно ознакомиться по ссылке: https://aues.edu.kz/ru/post/one?id=838 index_page=1', 'IT', 0, 0, 0);
Insert into Post values (post_id_numbering_seq.nextval, 'user', 'Привет всем! Классная социальная сеть!', 'Юмор', 0, 0, 0);
Insert into Post values (post_id_numbering_seq.nextval, 'user', 'Сегодня очень холодно, надеюсь завтра потеплеет', 'Стиль', 0, 0, 0);
Insert into Post values (post_id_numbering_seq.nextval, 'user', 'Научный проект готовлю, не беспокоить, пожалуйста!', 'Наука', 0, 0, 0);
Insert into Post values (post_id_numbering_seq.nextval, 'user', 'Грустно', 'Арт', 0, 0, 0);
Insert into Post values (post_id_numbering_seq.nextval, 'community', 'Скоро...', 'Другое', 0, 0, 0);
/
--Вставка значений в таблицу UsersPosts
Insert into UsersPosts values (1, 4);
Insert into UsersPosts values (44, 6);
Insert into UsersPosts values (22, 7);
Insert into UsersPosts values (11, 5);
/
--Вставка значений в таблицу Community
Insert into Community values (community_id_numbering_seq.nextval, 'StudyHUB', 'Скоро...', 1,'Бренд или организация', 0, 'Объединения, группы людей');
Insert into Community values (community_id_numbering_seq.nextval, 'AUPET', 'About AUPET', 21,'Публичная страница', 0, 'Объединения, группы людей');
Insert into Community values (community_id_numbering_seq.nextval, 'Школа-лицей №48/2019', 'Выпуск 2019, готовимся к ЕНТ!', 39, 'Мероприятие', 0, 'Отношения, семья');
/
--Вставка значений в таблицу CommunitiesMembers
Insert into CommunitiesMembers values (1, 1);
Insert into CommunitiesMembers values (21, 1);
Insert into CommunitiesMembers values (1, 2);
Insert into CommunitiesMembers values (3, 2);
Insert into CommunitiesMembers values (4, 2);
Insert into CommunitiesMembers values (5, 2);
Insert into CommunitiesMembers values (6, 2);
Insert into CommunitiesMembers values (7, 2);
Insert into CommunitiesMembers values (8, 2);
Insert into CommunitiesMembers values (11, 2);
Insert into CommunitiesMembers values (14, 2);
Insert into CommunitiesMembers values (18, 2);
Insert into CommunitiesMembers values (21, 2);
Insert into CommunitiesMembers values (34, 2);
Insert into CommunitiesMembers values (45, 2);
Insert into CommunitiesMembers values (46, 2);
Insert into CommunitiesMembers values (49, 2);
Insert into CommunitiesMembers values (50, 2);
Insert into CommunitiesMembers values (1, 3);
Insert into CommunitiesMembers values (2, 3);
Insert into CommunitiesMembers values (20, 3);
Insert into CommunitiesMembers values (22, 3);
Insert into CommunitiesMembers values (25, 3);
Insert into CommunitiesMembers values (26, 3);
Insert into CommunitiesMembers values (28, 3);
Insert into CommunitiesMembers values (29, 3);
Insert into CommunitiesMembers values (30, 3);
Insert into CommunitiesMembers values (32, 3);
Insert into CommunitiesMembers values (35, 3);
Insert into CommunitiesMembers values (37, 3);
Insert into CommunitiesMembers values (38, 3);
Insert into CommunitiesMembers values (39, 3);
Insert into CommunitiesMembers values (40, 3);
Insert into CommunitiesMembers values (41, 3);
Insert into CommunitiesMembers values (42, 3);
Insert into CommunitiesMembers values (44, 3);
Insert into CommunitiesMembers values (47, 3);
Insert into CommunitiesMembers values (48, 3);
/
--Вставка значений в таблицу CommunitiesPosts
Insert into CommunitiesPosts values (1, 8);
Insert into CommunitiesPosts values (2, 1);
Insert into CommunitiesPosts values (2, 2);
Insert into CommunitiesPosts values (2, 3);
/
--Вставка значений в таблицу Playlist
Insert into Playlist values (playlist_id_numbering_seq.nextval, '25-05-2020', 0, 0);
Insert into Playlist values (playlist_id_numbering_seq.nextval, '27-10-2021', 0, 0);
/
--Вставка значений в таблицу Track
Insert into Track values (track_id_numbering_seq.nextval, 'Хоп-механика', 'Oxxxymiron', null, 'D:\Учеба\АУЭС\ПБД\RGR2\Track\Oxxxymiron - Хоп-механика.mp3', '00:02:18', 'Rap and Hip-Hop', 0);
Insert into Track values (track_id_numbering_seq.nextval, 'Агент', 'Oxxxymiron', null, 'D:\Учеба\АУЭС\ПБД\RGR2\Track\Oxxxymiron - Агент.mp3', '00:03:35', 'Rap and Hip-Hop', 0);
Insert into Track values (track_id_numbering_seq.nextval, 'Красота и Уродство', 'Oxxxymiron', null, 'D:\Учеба\АУЭС\ПБД\RGR2\Track\Oxxxymiron - Красота и Уродство.mp3', '00:02:39', 'Rap and Hip-Hop', 0);
Insert into Track values (track_id_numbering_seq.nextval, 'Нон-фикшн', 'Oxxxymiron', null, 'D:\Учеба\АУЭС\ПБД\RGR2\Track\Oxxxymiron - Нон-фикшн.mp3', '00:03:35', 'Rap and Hip-Hop', 0);
Insert into Track values (track_id_numbering_seq.nextval, 'Рашн Роуд Рейдж', 'Oxxxymiron', null, 'D:\Учеба\АУЭС\ПБД\RGR2\Track\Oxxxymiron - Рашн Роуд Рейдж.mp3', '00:02:38', 'Rap and Hip-Hop', 0);
Insert into Track values (track_id_numbering_seq.nextval, 'Мы все умрем', 'Oxxxymiron', null, 'D:\Учеба\АУЭС\ПБД\RGR2\Track\Oxxxymiron - Мы все умрем.mp3', '00:02:34', 'Rap and Hip-Hop', 0);
Insert into Track values (track_id_numbering_seq.nextval, 'Чувствую', 'Oxxxymiron', null, 'D:\Учеба\АУЭС\ПБД\RGR2\Track\Oxxxymiron - Чувствую.mp3', '00:03:35', 'Rap and Hip-Hop', 0);
Insert into Track values (track_id_numbering_seq.nextval, 'Окно в Париж', 'Oxxxymiron', null, 'D:\Учеба\АУЭС\ПБД\RGR2\Track\Oxxxymiron - Окно в Париж.mp3', '00:03:14', 'Rap and Hip-Hop', 0);
Insert into Track values (track_id_numbering_seq.nextval, 'Партизанское радио', 'Oxxxymiron', null, 'D:\Учеба\АУЭС\ПБД\RGR2\Track\Oxxxymiron - Партизанское радио.mp3', '00:02:46', 'Rap and Hip-Hop', 0);
Insert into Track values (track_id_numbering_seq.nextval, 'Непрожитая жизнь', 'Oxxxymiron', null, 'D:\Учеба\АУЭС\ПБД\RGR2\Track\Oxxxymiron - Непрожитая жизнь.mp3', '00:03:55', 'Rap and Hip-Hop', 0);
Insert into Track values (track_id_numbering_seq.nextval, 'Празднуй', 'Oxxxymiron', null, 'D:\Учеба\АУЭС\ПБД\RGR2\Track\Oxxxymiron - Празднуй.mp3', '00:04:56', 'Rap and Hip-Hop', 0);
Insert into Track values (track_id_numbering_seq.nextval, 'Намешано', 'Oxxxymiron', null, 'D:\Учеба\АУЭС\ПБД\RGR2\Track\Oxxxymiron - Намешано.mp3', '00:03:52', 'Rap and Hip-Hop', 0);
Insert into Track values (track_id_numbering_seq.nextval, 'Эспрессо Тоник', 'Oxxxymiron', null, 'D:\Учеба\АУЭС\ПБД\RGR2\Track\Oxxxymiron - Эспрессо Тоник.mp3', '00:01:55', 'Rap and Hip-Hop', 0);
Insert into Track values (track_id_numbering_seq.nextval, 'Пантеллерия', 'Oxxxymiron', null, 'D:\Учеба\АУЭС\ПБД\RGR2\Track\Oxxxymiron - Пантеллерия.mp3', '00:02:53', 'Rap and Hip-Hop', 0);
Insert into Track values (track_id_numbering_seq.nextval, 'Лифт', 'Oxxxymiron', null, 'D:\Учеба\АУЭС\ПБД\RGR2\Track\Oxxxymiron - Лифт.mp3', '00:04:35', 'Rap and Hip-Hop', 0);
Insert into Track values (track_id_numbering_seq.nextval, 'Грязь', 'Oxxxymiron', null, 'D:\Учеба\АУЭС\ПБД\RGR2\Track\Oxxxymiron - Грязь.mp3', '00:03:32', 'Rap and Hip-Hop', 0);
Insert into Track values (track_id_numbering_seq.nextval, 'Улет', 'Oxxxymiron', null, 'D:\Учеба\АУЭС\ПБД\RGR2\Track\Oxxxymiron - Улет.mp3', '00:02:31', 'Rap and Hip-Hop', 0);
Insert into Track values (track_id_numbering_seq.nextval, 'Эминем', 'Oxxxymiron', null, 'D:\Учеба\АУЭС\ПБД\RGR2\Track\Oxxxymiron - Эминем.mp3', '00:02:49', 'Rap and Hip-Hop', 0);
Insert into Track values (track_id_numbering_seq.nextval, 'Рецензия', 'Oxxxymiron', null, 'D:\Учеба\АУЭС\ПБД\RGR2\Track\Oxxxymiron - Рецензия.mp3', '00:01:08', 'Rap and Hip-Hop', 0);
Insert into Track values (track_id_numbering_seq.nextval, 'Африканские бусы', 'Oxxxymiron', null, 'D:\Учеба\АУЭС\ПБД\RGR2\Track\Oxxxymiron - Африканские бусы.mp3', '00:02:27', 'Rap and Hip-Hop', 0);
Insert into Track values (track_id_numbering_seq.nextval, 'Тень', 'Oxxxymiron', null, 'D:\Учеба\АУЭС\ПБД\RGR2\Track\Oxxxymiron - Тень.mp3', '00:03:04', 'Rap and Hip-Hop', 0);
Insert into Track values (track_id_numbering_seq.nextval, 'Дрейдл', 'Oxxxymiron', null, 'D:\Учеба\АУЭС\ПБД\RGR2\Track\Oxxxymiron - Дрейдл.mp3', '00:02:26', 'Rap and Hip-Hop', 0);
/
--Вставка значений в таблицу Photoalbum
Insert into Photoalbum values (photoalbum_id_numbering_seq.nextval, 'Фотографии на моей странице', '25-05-2020', 0);
Insert into Photoalbum values (photoalbum_id_numbering_seq.nextval, 'Фотографии на моей странице', '25-05-2020', 0);
Insert into Photoalbum values (photoalbum_id_numbering_seq.nextval, 'Фотографии на моей странице', '25-05-2020', 0);
Insert into Photoalbum values (photoalbum_id_numbering_seq.nextval, 'Фотографии на моей странице', '25-05-2020', 0);
Insert into Photoalbum values (photoalbum_id_numbering_seq.nextval, 'Фотографии на моей странице', '25-05-2020', 0);
Insert into Photoalbum values (photoalbum_id_numbering_seq.nextval, 'Фотографии на моей странице', '25-05-2020', 0);
Insert into Photoalbum values (photoalbum_id_numbering_seq.nextval, 'Фотографии на моей странице', '25-05-2020', 0);
Insert into Photoalbum values (photoalbum_id_numbering_seq.nextval, 'Фотографии на моей странице', '25-05-2020', 0);
Insert into Photoalbum values (photoalbum_id_numbering_seq.nextval, 'Фотографии на моей странице', '25-05-2020', 0);
Insert into Photoalbum values (photoalbum_id_numbering_seq.nextval, 'Фотографии на моей странице', '25-05-2020', 0);
Insert into Photoalbum values (photoalbum_id_numbering_seq.nextval, 'Фотографии на моей странице', '25-05-2020', 0);
Insert into Photoalbum values (photoalbum_id_numbering_seq.nextval, 'Фотографии на моей странице', '25-05-2020', 0);
Insert into Photoalbum values (photoalbum_id_numbering_seq.nextval, 'Фотографии на моей странице', '25-05-2020', 0);
Insert into Photoalbum values (photoalbum_id_numbering_seq.nextval, 'Фотографии на моей странице', '25-05-2020', 0);
/
--Вставка значений в таблицу Photo
Insert into Photo values (photo_id_numbering_seq.nextval, 'D:\Учеба\АУЭС\ПБД\RGR2\Photo\wallhaven-48dep2_1920x1080.png', '25-05-2020', null);
Insert into Photo values (photo_id_numbering_seq.nextval, 'D:\Учеба\АУЭС\ПБД\RGR2\Photo\wallhaven-57zje5_1920x1080.png', '25-05-2020', null);
Insert into Photo values (photo_id_numbering_seq.nextval, 'D:\Учеба\АУЭС\ПБД\RGR2\Photo\wallhaven-73wk3y_1920x1080.png', '25-05-2020', null);
Insert into Photo values (photo_id_numbering_seq.nextval, 'D:\Учеба\АУЭС\ПБД\RGR2\Photo\wallhaven-96g9yd_1920x1080.png', '25-05-2020', null);
Insert into Photo values (photo_id_numbering_seq.nextval, 'D:\Учеба\АУЭС\ПБД\RGR2\Photo\wallhaven-137x79_1920x1080.png', '25-05-2020', null);
Insert into Photo values (photo_id_numbering_seq.nextval, 'D:\Учеба\АУЭС\ПБД\RGR2\Photo\wallhaven-481p92.png', '25-05-2020', null);
Insert into Photo values (photo_id_numbering_seq.nextval, 'D:\Учеба\АУЭС\ПБД\RGR2\Photo\wallhaven-731dxy_1920x1080.png', '25-05-2020', null);
Insert into Photo values (photo_id_numbering_seq.nextval, 'D:\Учеба\АУЭС\ПБД\RGR2\Photo\wallhaven-dgkkq3_1920x1080.png', '25-05-2020', null);
Insert into Photo values (photo_id_numbering_seq.nextval, 'D:\Учеба\АУЭС\ПБД\RGR2\Photo\wallhaven-e73g6o_1920x1080.png', '25-05-2020', null);
Insert into Photo values (photo_id_numbering_seq.nextval, 'D:\Учеба\АУЭС\ПБД\RGR2\Photo\wallhaven-e78kjw_1920x1080.png', '25-05-2020', null);
Insert into Photo values (photo_id_numbering_seq.nextval, 'D:\Учеба\АУЭС\ПБД\RGR2\Photo\wallhaven-eorrd8_1920x1080.png', '25-05-2020', null);
Insert into Photo values (photo_id_numbering_seq.nextval, 'D:\Учеба\АУЭС\ПБД\RGR2\Photo\wallhaven-ey3jkw_1920x1080.png', '25-05-2020', null);
Insert into Photo values (photo_id_numbering_seq.nextval, 'D:\Учеба\АУЭС\ПБД\RGR2\Photo\wallhaven-gjjrml_1920x1080.png', '25-05-2020', null);
Insert into Photo values (photo_id_numbering_seq.nextval, 'D:\Учеба\АУЭС\ПБД\RGR2\Photo\wallhaven-13x79v_3840x2160.png', '25-05-2020', null);
/
--Вставка значений в таблицу DocumentFolder
Insert into DocumentFolder values (documentfolder_id_numbering_seq.nextval, 'Отчеты', '25-05-2020', 0);
/
--Вставка значений в таблицу Doc
Insert into Doc values (doc_id_numbering_seq.nextval, 'Ким К. В. ЛР№1 по ПБД', 'D:\Учеба\АУЭС\ПБД\RGR2\Document\Ким К. В. ЛР№1 по ПБД.docx', '25-05-2020');
Insert into Doc values (doc_id_numbering_seq.nextval, 'Ким К. В. ЛР№2 по ПБД', 'D:\Учеба\АУЭС\ПБД\RGR2\Document\Ким К. В. ЛР№2 по ПБД.docx', '25-05-2020');
Insert into Doc values (doc_id_numbering_seq.nextval, 'Ким К. В. ЛР№3 по ПБД', 'D:\Учеба\АУЭС\ПБД\RGR2\Document\Ким К. В. ЛР№3 по ПБД.docx', '25-05-2020');
Insert into Doc values (doc_id_numbering_seq.nextval, 'Ким К. В. ЛР№4 по ПБД', 'D:\Учеба\АУЭС\ПБД\RGR2\Document\Ким К. В. ЛР№4 по ПБД.docx', '25-05-2020');
Insert into Doc values (doc_id_numbering_seq.nextval, 'Ким К. В. ЛР№5 по ПБД', 'D:\Учеба\АУЭС\ПБД\RGR2\Document\Ким К. В. ЛР№5 по ПБД.docx', '25-05-2020');
Insert into Doc values (doc_id_numbering_seq.nextval, 'Ким К. В. ЛР№6 по ПБД', 'D:\Учеба\АУЭС\ПБД\RGR2\Document\Ким К. В. ЛР№6 по ПБД.docx', '25-05-2020');
Insert into Doc values (doc_id_numbering_seq.nextval, 'Ким К. В. ЛР№7 по ПБД', 'D:\Учеба\АУЭС\ПБД\RGR2\Document\Ким К. В. ЛР№7 по ПБД.docx', '25-05-2020');
Insert into Doc values (doc_id_numbering_seq.nextval, 'Ким К. В. ЛР№8 по ПБД', 'D:\Учеба\АУЭС\ПБД\RGR2\Document\Ким К. В. ЛР№8 по ПБД.docx', '25-05-2020');
Insert into Doc values (doc_id_numbering_seq.nextval, 'Ким К. В. ЛР№9 по ПБД', 'D:\Учеба\АУЭС\ПБД\RGR2\Document\Ким К. В. ЛР№9 по ПБД.docx', '25-05-2020');
Insert into Doc values (doc_id_numbering_seq.nextval, 'Ким К. В. РГР№1 по ПБД', 'D:\Учеба\АУЭС\ПБД\RGR2\Document\Ким К. В. РГР№1 по ПБД.docx', '25-05-2020');
/
--Вставка значений в таблицу UsersMusic
Insert into UsersMusic values (4, 1, 1);
Insert into UsersMusic values (4, 1, 2);
Insert into UsersMusic values (4, 1, 3);
Insert into UsersMusic values (4, 1, 4);
Insert into UsersMusic values (4, 1, 5);
Insert into UsersMusic values (4, 1, 6);
Insert into UsersMusic values (4, 1, 7);
Insert into UsersMusic values (4, 1, 8);
Insert into UsersMusic values (4, 1, 9);
Insert into UsersMusic values (4, 1, 10);
Insert into UsersMusic values (4, 1, 11);
Insert into UsersMusic values (4, 1, 12);
Insert into UsersMusic values (4, 1, 13);
Insert into UsersMusic values (4, 1, 14);
Insert into UsersMusic values (4, 1, 15);
Insert into UsersMusic values (4, 1, 16);
Insert into UsersMusic values (4, 1, 17);
Insert into UsersMusic values (4, 1, 18);
Insert into UsersMusic values (4, 1, 19);
Insert into UsersMusic values (4, 1, 20);
Insert into UsersMusic values (4, 1, 21);
Insert into UsersMusic values (4, 1, 22);
Insert into UsersMusic values (1, 2, 1);
Insert into UsersMusic values (1, 2, 18);
Insert into UsersMusic values (1, 2, 4);
Insert into UsersMusic values (1, 2, 9);
Insert into UsersMusic values (1, 2, 12);
Insert into UsersMusic values (1, 2, 22);
Insert into UsersMusic values (1, 2, 2);
/
--Вставка значений в таблицу UsersPhotoAlbums
Insert into  UsersPhotoAlbums values (1, 1, 1);
Insert into  UsersPhotoAlbums values (30, 2, 2);
Insert into  UsersPhotoAlbums values (23, 3, 3);
Insert into  UsersPhotoAlbums values (21, 4, 4);
Insert into  UsersPhotoAlbums values (42, 5, 5);
Insert into  UsersPhotoAlbums values (7, 6, 6);
Insert into  UsersPhotoAlbums values (33, 7, 7);
Insert into  UsersPhotoAlbums values (16, 8, 8);
Insert into  UsersPhotoAlbums values (29, 9, 9);
Insert into  UsersPhotoAlbums values (3, 10, 10);
Insert into  UsersPhotoAlbums values (20, 11, 11);
Insert into  UsersPhotoAlbums values (45, 12, 12);
Insert into  UsersPhotoAlbums values (37, 13, 13);
Insert into  UsersPhotoAlbums values (25, 14, 14);
/
--Вставка значений в таблицу UsersDocuments
Insert into UsersDocuments values (1, 1, 1);
Insert into UsersDocuments values (1, 1, 2);
Insert into UsersDocuments values (1, 1, 3);
Insert into UsersDocuments values (1, 1, 4);
Insert into UsersDocuments values (1, 1, 5);
Insert into UsersDocuments values (1, 1, 6);
Insert into UsersDocuments values (1, 1, 7);
Insert into UsersDocuments values (1, 1, 8);
Insert into UsersDocuments values (1, 1, 9);
Insert into UsersDocuments values (1, 1, 10);
/
--Вставка значений в таблицу Dialogue
Insert into Dialogue values (dialogue_id_numbering_seq.nextval, 1, 4, 0);
Insert into Dialogue values (dialogue_id_numbering_seq.nextval, 1, 21, 0);
Insert into Dialogue values (dialogue_id_numbering_seq.nextval, 35, 1, 0);
/
--Вставка значений в таблицу MessageInformation
Insert into MessageInformation values (messageinformation_id_numbering_seq.nextval, 'Привет, послушал новый альбом?', '25-05-2020', default);
Insert into MessageInformation values (messageinformation_id_numbering_seq.nextval, 'Да, интересная работа получилась', '25-05-2020', default);
Insert into MessageInformation values (messageinformation_id_numbering_seq.nextval, 'КОГДА ЗАПУСК?', '25-05-2020', default);
Insert into MessageInformation values (messageinformation_id_numbering_seq.nextval, 'Хола, давно не переписывались, где ты как ты сейчас?', '25-05-2020', default);
Insert into MessageInformation values (messageinformation_id_numbering_seq.nextval, 'Привеееет, и правда! У меня ничего нового, лучше сама расскажи что у тебя', '25-05-2020', default);
Insert into MessageInformation values (messageinformation_id_numbering_seq.nextval, 'Живу в Варшаве, пошла по специальности, картины рисую и Саша со мной', '25-05-2020', default);
Insert into MessageInformation values (messageinformation_id_numbering_seq.nextval, 'Здорово! Я в АУЭС поступил, эту базу данных пишу, рад жизни', '25-05-2020', default);
/
--Вставка значений в таблицу DialoguesMessages
Insert into DialoguesMessages values (1, 1);
Insert into DialoguesMessages values (1, 2);
Insert into DialoguesMessages values (2, 3);
Insert into DialoguesMessages values (3, 4);
Insert into DialoguesMessages values (3, 5);
Insert into DialoguesMessages values (3, 6);
Insert into DialoguesMessages values (3, 7);
/
commit;
/
--Вывод общей информации о пользователях
create view all_users_baseinformation as
select ULP.user_id as "Номер",
       ULP.user_login as "Логин",
       ULP.user_password as "Пароль",
       user_fi(UI.user_surname, UI.user_name) as "Фамилия и имя",
       user_sex as "Пол",
       user_birthdate as "Дата рождения",
       user_age(ULP.user_id) as "Возраст",
       (select count(*)
        From UsersMusic UM
        where UM.um_user_id = ULP.user_id) as "Кол-во аудиозаписей",
       (select count(*)
        From UsersPhotoAlbums UPA
        where UPA.upa_user_id = ULP.user_id) as "Кол-во фотографий",
       (select count(*)
        From UsersDocuments UD
        where UD.ud_user_id = ULP.user_id) as "Кол-во документов",
       (select count(*)
        From UsersPosts UP
        where UP.up_user_id = ULP.user_id) as "Кол-во постов"
from UserLoginPassword ULP
         Inner join UserInformation UI on ULP.user_id = UI.user_id;
/
--Вывод общей информации о сообществе
create view all_communities_baseinformation as
select C.community_id as "Номер",
       C.community_name as "Название",
       (select user_fi(UI.user_surname, UI.user_name)
        From UserInformation UI
        where C.community_author_id = UI.user_id) as "Администратор",
       C.community_type as "Тип",
       C.community_theme as "Тема",
       C.community_count_of_users as "Кол-во подписчиков",
       (select count(*)
        From CommunitiesPosts CP
        where CP.cp_community_id = C.community_id) as "Количество постов"
From Community C;
/
--Вывод общей информации о музыке
create view all_usersmusic as
select user_fi(UI.user_surname, UI.user_name) as "Фамилия и имя",
       UM.um_playlist_id as "Номер плейлиста",
       Pl.playlist_tracks_count as "Кол-во треков в плейлийсте",
       Tr.track_name as "Название трека",
       Tr.track_author as "Автор трека",
       Tr.track_time as "Время"
From UsersMusic UM
         inner join UserInformation UI on UI.user_id = UM.um_user_id
         inner join Playlist Pl on Pl.playlist_id = UM.um_playlist_id
         inner join Track Tr on Tr.track_id = UM.um_track_id;
/
--Вывод общей информации о фотоальбомах
create view all_usersphotoalbums as
select user_fi(UI.user_surname, UI.user_name) as "Фамилия и имя",
       UPA.upa_photoalbum_id as "Номер фотоальбома",
       Ph.photoalbum_name as "Название фотоальбома",
       P.photo_file as "Расположение файла",
       P.photo_date_of_creation as "Дата создания"
From UsersPhotoAlbums UPA
         inner join UserInformation UI on UI.user_id = UPA.upa_user_id
         inner join Photoalbum Ph on Ph.photoalbum_id = UPA.upa_photoalbum_id
         inner join Photo P on P.photo_id = UPA.upa_photo_id;
/
--Вывод общей информации о документах
create view all_usersdocuments as
select user_fi(UI.user_surname, UI.user_name) as "Фамилия и имя",
       DF.dfolder_id as "Номер папки документов",
       DF.dfolder_name as "Название папки документов",
       D.document_name as "Название документа",
       D.document_file as "Расположение документа",
       D.document_date_of_creation as "Дата создания"
From UsersDocuments UD
         inner join UserInformation UI on UI.user_id = UD.ud_user_id
         inner join DocumentFolder DF on DF.dfolder_id = UD.ud_dfolder_id
         inner join Doc D on D.document_id = UD.ud_document_id;
/
--Вывод общей информации о постах пользователей
create view all_usersposts as
select user_fi(UI.user_surname, UI.user_name) as "Фамилия и имя",
       P.post_id as "Номер поста",
       P.post_text as "Содержимое",
       P.post_theme as "Тематика поста"
From UsersPosts UP
         inner join UserInformation UI on UI.user_id = UP.up_user_id
         inner join Post P on P.post_id = UP.up_post_id;
/
--Вывод общей информации о постах сообщества
create view all_communititesposts as
select C.community_id as "Номер сообщества",
       C.community_name as "Название сообщества",
       P.post_id as "Номер поста",
       P.post_text as "Содержимое",
       P.post_theme as "Тематика поста"
From CommunitiesPosts CP
         inner join Community C on C.community_id = CP.cp_community_id
         inner join Post P on P.post_id = CP.cp_post_id;
/
commit;
/
--Включение отображения вывода в консоль
--set serveroutput on;
--/
--Процедура выводящая информацию о диалоге двух пользователей
create or replace procedure dialogue_info (u_1 Dialogue.user_id_first%type,
                                           u_2 Dialogue.user_id_second%type) is
    d_id Dialogue.dialogue_id%type;
    m_count Dialogue.messages_count%type;
    m_text MessageInformation.message_text%type;
    m_time MessageInformation.message_datetime%type;
    m_status MessageInformation.message_status%type;
cursor dialogue_check (u_1 Dialogue.user_id_first%type,
        u_2 Dialogue.user_id_second%type) is
select dialogue_id, messages_count
from Dialogue
where user_id_first = u_1 and user_id_second = u_2;
cursor dialogue_info (u_1 Dialogue.user_id_first%type,
        u_2 Dialogue.user_id_second%type) is
select message_text, message_datetime, message_status
from Dialogue
         inner join DialoguesMessages
                    on dm_dialogue_id = dialogue_id
         inner join MessageInformation
                    on message_id = dm_message_id
where user_id_first = u_1 and user_id_second = u_2;
begin
open dialogue_check (u_1, u_2);
fetch dialogue_check into d_id, m_count;
if dialogue_check%notfound then
        dbms_output.put_line('Данного диалога не существует');
else
        dbms_output.put_line('Номер диалога: ' || d_id || ' ' ||
                             'Количество сообщений: ' || m_count);
open dialogue_info (u_1, u_2);
loop
fetch dialogue_info into m_text, m_time, m_status;
            exit when dialogue_info%notfound;
            dbms_output.put_line('Время: ' || m_time || ' '
                || 'Текст: ' || m_text || ' '
                || 'Статус: '|| m_status);
end loop;
close dialogue_info;
end if;
close dialogue_check;
end;
/
--begin
--    dialogue_info(1, 4);
--end;

--Процедура выводящая информацию о музыке пользователя
create or replace procedure user_music_info (u_id UserLoginPassword.user_id%type) is
    u_lname UserInformation.user_surname%type;
    u_name UserInformation.user_name%type;
cursor user_playlists (u_id UsersMusic.um_user_id%type) is
select distinct playlist_id, playlist_date_of_creation, playlist_tracks_count, playlist_count_of_learning
from Playlist
         inner join UsersMusic
                    on um_playlist_id = playlist_id
where um_user_id = u_id;
cursor user_tracks (p_id UsersMusic.um_playlist_id%type) is
select track_id, track_name, track_author, track_time
from Track
         inner join UsersMusic on um_user_id = u_id and um_playlist_id = p_id and um_track_id = track_id;
begin
select user_surname, user_name
into u_lname, u_name
From UserInformation
where user_id = u_id;
dbms_output.put_line('Музыка пользователя ' || user_fi(u_lname, u_name));
for playlist_info in user_playlists(u_id) loop
            dbms_output.put_line('   Номер плейлиста - ' || playlist_info.playlist_id
                || ' ' || 'Дата создания - '
                || playlist_info.playlist_date_of_creation
                || ' ' || 'Количество треков - '
                || playlist_info.playlist_tracks_count
                || ' ' || 'Количество прослушиваний - '
                || playlist_info.playlist_count_of_learning);
for track_info in user_tracks(playlist_info.playlist_id) loop
                    dbms_output.put_line('      Номер трека - ' || track_info.track_id
                        || ' ' || 'Название трека - '
                        || track_info.track_name
                        || ' ' || 'Автор трека - '
                        || track_info.track_author
                        || ' ' || 'Время - '
                        || track_info.track_time);
end loop;
end loop;
end;
/
--begin
--    user_music_info(1);
--end;
--Процедура выводящая информацию о фото пользователя
create or replace procedure user_photoalbums_info(u_id UserLoginPassword.user_id%type) is
    u_lname UserInformation.user_surname%type;
    u_name UserInformation.user_name%type;
cursor user_photoalbums (u_id UsersPhotoAlbums.upa_user_id%type) is
select distinct photoalbum_id, photoalbum_name, photoalbum_date_of_creation, photoalbum_photos_count
from Photoalbum
         inner join UsersPhotoalbums
                    on upa_photoalbum_id = photoalbum_id
where upa_user_id = u_id;
cursor user_photos (p_id UsersPhotoAlbums.upa_photoalbum_id%type) is
select photo_id, photo_date_of_creation
from Photo
         inner join UsersPhotoalbums on upa_user_id = u_id and upa_photoalbum_id = p_id and upa_photo_id = photo_id;
begin
select user_surname, user_name
into u_lname, u_name
From UserInformation
where user_id = u_id;
dbms_output.put_line('Фотографии пользователя ' || user_fi(u_lname, u_name));
for photoalbum_info in user_photoalbums(u_id) loop
            dbms_output.put_line('   Номер фотоальбома - ' || photoalbum_info.photoalbum_id
                || ' ' || 'Название - '
                || photoalbum_info.photoalbum_name
                || ' ' || 'Дата создания - '
                || photoalbum_info.photoalbum_date_of_creation
                || ' ' || 'Количество фото - '
                || photoalbum_info.photoalbum_photos_count);
for photo_info in user_photos(photoalbum_info.photoalbum_id) loop
                    dbms_output.put_line('      Номер фото - ' || photo_info.photo_id
                        || ' ' || 'Дата создания - '
                        || photo_info.photo_date_of_creation);
end loop;
end loop;
end;
/
--begin
--    user_photoalbums_info(1);
--end;
--Процедура выводящая информацию о документах пользователя
create or replace procedure user_documents_info(u_id UserLoginPassword.user_id%type) is
    u_lname UserInformation.user_surname%type;
    u_name UserInformation.user_name%type;
cursor user_dfolders (u_id UsersDocuments.ud_user_id%type) is
select distinct dfolder_id, dfolder_name, dfolder_date_of_creation, dfolder_documents_count
from DocumentFolder
         inner join UsersDocuments
                    on ud_dfolder_id = dfolder_id
where ud_user_id = u_id;
cursor user_documents (d_id UsersDocuments.ud_dfolder_id%type) is
select document_id, document_name, document_date_of_creation
from Doc
         inner join UsersDocuments on ud_user_id = u_id and ud_dfolder_id = d_id and ud_document_id = document_id;
begin
select user_surname, user_name
into u_lname, u_name
From UserInformation
where user_id = u_id;
dbms_output.put_line('Документы пользователя ' || user_fi(u_lname, u_name));
for dfolder_info in user_dfolders(u_id) loop
            dbms_output.put_line('   Номер папки документов - ' || dfolder_info.dfolder_id
                || ' ' || 'Название - '
                || dfolder_info.dfolder_name
                || ' ' || 'Дата создания - '
                || dfolder_info.dfolder_date_of_creation
                || ' ' || 'Количество документов - '
                || dfolder_info.dfolder_documents_count);
for document_info in user_documents(dfolder_info.dfolder_id ) loop
                    dbms_output.put_line('      Номер документа - ' || document_info.document_id
                        || ' ' || 'Название документа '
                        || document_info.document_name
                        || ' ' || 'Дата создания - '
                        || document_info.document_date_of_creation);
end loop;
end loop;
end;
/
--begin
--    user_documents_info(1);
--end;

--Процедура выводящая информацию о подписчиках сообщества
create or replace procedure community_follows(c_id CommunitiesMembers.cm_community_id%type) is
    c_name Community.community_name%type;
    u_id UserInformation.user_id%type;
    u_name UserInformation.user_name%type;
    u_surname UserInformation.user_surname%type;
cursor community_follows(c_id CommunitiesMembers.cm_community_id%type) is
select cm_user_id
from CommunitiesMembers CM
where CM.cm_community_id = c_id;
cursor user_info(u_id UserInformation.user_id%type) is
select user_name, user_surname
from UserInformation
where user_id = u_id;
begin
select community_name
into c_name
From Community
where community_id = c_id;
open community_follows(c_id);
dbms_output.put_line('Подписчики сообщества ' || c_name || ':');
    loop
fetch community_follows into u_id;
        exit when community_follows%notfound;
open user_info(u_id);
fetch user_info into u_name, u_surname;
exit when user_info%notfound;
        dbms_output.put_line('   ' || user_fi(u_surname, u_name));
close user_info;
end loop;
close community_follows;
end;
/
--begin
--    community_follows(1);
--end;
commit;
/

--Создание пакета rgr_package
create or replace package rgr_package as
    c_name Community.community_name%type;
    u_id UserInformation.user_id%type;
    u_name UserInformation.user_name%type;
    u_surname UserInformation.user_surname%type;
cursor community_follows(c_id CommunitiesMembers.cm_community_id%type) is
select cm_user_id
from CommunitiesMembers CM
where CM.cm_community_id = c_id;
cursor user_info(u_id UserInformation.user_id%type) is
select user_name, user_surname
from UserInformation
where user_id = u_id;

d_id Dialogue.dialogue_id%type;
    m_count Dialogue.messages_count%type;
    m_text MessageInformation.message_text%type;
    m_time MessageInformation.message_datetime%type;
    m_status MessageInformation.message_status%type;
cursor dialogue_check (u_1 Dialogue.user_id_first%type,
        u_2 Dialogue.user_id_second%type) is
select dialogue_id, messages_count
from Dialogue
where user_id_first = u_1 and user_id_second = u_2;
cursor dialogue_info (u_1 Dialogue.user_id_first%type,
        u_2 Dialogue.user_id_second%type) is
select message_text, message_datetime, message_status
from Dialogue
         inner join DialoguesMessages
                    on dm_dialogue_id = dialogue_id
         inner join MessageInformation
                    on message_id = dm_message_id
where user_id_first = u_1 and user_id_second = u_2;

u_lname UserInformation.user_surname%type;
    --u_name UserInformation.user_name%type;
cursor user_dfolders (u_id UsersDocuments.ud_user_id%type) is
select distinct dfolder_id, dfolder_name, dfolder_date_of_creation, dfolder_documents_count
from DocumentFolder
         inner join UsersDocuments
                    on ud_dfolder_id = dfolder_id
where ud_user_id = u_id;
cursor user_documents (d_id UsersDocuments.ud_dfolder_id%type) is
select document_id, document_name, document_date_of_creation
from Doc
         inner join UsersDocuments on ud_user_id = u_id and ud_dfolder_id = d_id and ud_document_id = document_id;

--u_lname UserInformation.user_surname%type;
--u_name UserInformation.user_name%type;
cursor user_playlists (u_id UsersMusic.um_user_id%type) is
select distinct playlist_id, playlist_date_of_creation, playlist_tracks_count, playlist_count_of_learning
from Playlist
         inner join UsersMusic
                    on um_playlist_id = playlist_id
where um_user_id = u_id;
cursor user_tracks (p_id UsersMusic.um_playlist_id%type) is
select track_id, track_name, track_author, track_time
from Track
         inner join UsersMusic on um_user_id = u_id and um_playlist_id = p_id and um_track_id = track_id;

--u_lname UserInformation.user_surname%type;
--u_name UserInformation.user_name%type;
cursor user_photoalbums (u_id UsersPhotoAlbums.upa_user_id%type) is
select distinct photoalbum_id, photoalbum_name, photoalbum_date_of_creation, photoalbum_photos_count
from Photoalbum
         inner join UsersPhotoalbums
                    on upa_photoalbum_id = photoalbum_id
where upa_user_id = u_id;
cursor user_photos (p_id UsersPhotoAlbums.upa_photoalbum_id%type) is
select photo_id, photo_date_of_creation
from Photo
         inner join UsersPhotoalbums on upa_user_id = u_id and upa_photoalbum_id = p_id and upa_photo_id = photo_id;

procedure p_community_follows(c_id CommunitiesMembers.cm_community_id%type);
procedure p_dialogue_info(u_1 Dialogue.user_id_first%type,
u_2 Dialogue.user_id_second%type);
procedure user_documents_info(u_id UserLoginPassword.user_id%type);
procedure user_music_info(u_id UserLoginPassword.user_id%type);
procedure user_photoalbums_info(u_id UserLoginPassword.user_id%type);
end rgr_package;
/
create or replace package body rgr_package as
    function user_fi (u_lname UserInformation.user_surname%type,
                      u_name UserInformation.user_name%type)
        return varchar2 is
        output varchar2(150);
begin
        if u_lname is null or u_name is null then
            output := '#################';
else
select substr(u_lname, 1, 1) || '. ' || u_name
into output
From dual;
end if;
        return output;
end user_fi;
    procedure p_community_follows(c_id CommunitiesMembers.cm_community_id%type) is
begin
select community_name
into c_name
From Community
where community_id = c_id;
open community_follows(c_id);
dbms_output.put_line('Подписчики сообщества ' || c_name || ':');
        loop
fetch community_follows into u_id;
            exit when community_follows%notfound;
open user_info(u_id);
fetch user_info into u_name, u_surname;
exit when user_info%notfound;
            dbms_output.put_line('   ' || user_fi(u_surname, u_name));
close user_info;
end loop;
close community_follows;
end p_community_follows;

    procedure p_dialogue_info (u_1 Dialogue.user_id_first%type,
                               u_2 Dialogue.user_id_second%type) is
begin
open dialogue_check (u_1, u_2);
fetch dialogue_check into d_id, m_count;
if dialogue_check%notfound then
            dbms_output.put_line('Данного диалога не существует');
else
            dbms_output.put_line('Номер диалога: ' || d_id || ' ' ||
                                 'Количество сообщений: ' || m_count);
open dialogue_info (u_1, u_2);
loop
fetch dialogue_info into m_text, m_time, m_status;
                exit when dialogue_info%notfound;
                dbms_output.put_line('Время: ' || m_time || ' '
                    || 'Текст: ' || m_text || ' '
                    || 'Статус: '|| m_status);
end loop;
close dialogue_info;
end if;
close dialogue_check;
end p_dialogue_info;

    procedure user_documents_info(u_id UserLoginPassword.user_id%type) is
begin
select user_surname, user_name
into u_lname, u_name
From UserInformation
where user_id = u_id;
dbms_output.put_line('Документы пользователя ' || user_fi(u_lname, u_name));
for dfolder_info in user_dfolders(u_id) loop
                dbms_output.put_line('   Номер папки документов - ' || dfolder_info.dfolder_id
                    || ' ' || 'Название - '
                    || dfolder_info.dfolder_name
                    || ' ' || 'Дата создания - '
                    || dfolder_info.dfolder_date_of_creation
                    || ' ' || 'Количество документов - '
                    || dfolder_info.dfolder_documents_count);
for document_info in user_documents(dfolder_info.dfolder_id ) loop
                        dbms_output.put_line('      Номер документа - ' || document_info.document_id
                            || ' ' || 'Название документа '
                            || document_info.document_name
                            || ' ' || 'Дата создания - '
                            || document_info.document_date_of_creation);
end loop;
end loop;
end user_documents_info;

    procedure user_music_info (u_id UserLoginPassword.user_id%type) is
        u_lname UserInformation.user_surname%type;
        u_name UserInformation.user_name%type;
cursor user_playlists (u_id UsersMusic.um_user_id%type) is
select distinct playlist_id, playlist_date_of_creation, playlist_tracks_count, playlist_count_of_learning
from Playlist
         inner join UsersMusic
                    on um_playlist_id = playlist_id
where um_user_id = u_id;
cursor user_tracks (p_id UsersMusic.um_playlist_id%type) is
select track_id, track_name, track_author, track_time
from Track
         inner join UsersMusic on um_user_id = u_id and um_playlist_id = p_id and um_track_id = track_id;
begin
select user_surname, user_name
into u_lname, u_name
From UserInformation
where user_id = u_id;
dbms_output.put_line('Музыка пользователя ' || user_fi(u_lname, u_name));
for playlist_info in user_playlists(u_id) loop
                dbms_output.put_line('   Номер плейлиста - ' || playlist_info.playlist_id
                    || ' ' || 'Дата создания - '
                    || playlist_info.playlist_date_of_creation
                    || ' ' || 'Количество треков - '
                    || playlist_info.playlist_tracks_count
                    || ' ' || 'Количество прослушиваний - '
                    || playlist_info.playlist_count_of_learning);
for track_info in user_tracks(playlist_info.playlist_id) loop
                        dbms_output.put_line('      Номер трека - ' || track_info.track_id
                            || ' ' || 'Название трека - '
                            || track_info.track_name
                            || ' ' || 'Автор трека - '
                            || track_info.track_author
                            || ' ' || 'Время - '
                            || track_info.track_time);
end loop;
end loop;
end user_music_info;

    procedure user_photoalbums_info(u_id UserLoginPassword.user_id%type) is
begin
select user_surname, user_name
into u_lname, u_name
From UserInformation
where user_id = u_id;
dbms_output.put_line('Фотографии пользователя ' || user_fi(u_lname, u_name));
for photoalbum_info in user_photoalbums(u_id) loop
                dbms_output.put_line('   Номер фотоальбома - ' || photoalbum_info.photoalbum_id
                    || ' ' || 'Название - '
                    || photoalbum_info.photoalbum_name
                    || ' ' || 'Дата создания - '
                    || photoalbum_info.photoalbum_date_of_creation
                    || ' ' || 'Количество фото - '
                    || photoalbum_info.photoalbum_photos_count);
for photo_info in user_photos(photoalbum_info.photoalbum_id) loop
                        dbms_output.put_line('      Номер фото - ' || photo_info.photo_id
                            || ' ' || 'Дата создания - '
                            || photo_info.photo_date_of_creation);
end loop;
end loop;
end user_photoalbums_info;
end rgr_package;
/
commit;
/
begin
    rgr_package.p_dialogue_info(1, 4);
    rgr_package.user_music_info(1);
    rgr_package.user_photoalbums_info(1);
    rgr_package.user_documents_info(1);
    rgr_package.p_community_follows(1);
end;
/