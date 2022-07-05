--Это вторая часть, она делается из под админа РГРки

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
        insert into rgr2_audit values (user, to_char(sysdate, 'DD.MM.YY'), to_char(sysdate, 'HH24:MI:SS'), (select sys_context('userenv','sessionid') Session_ID from dual), 'Track', 'Update', :old.track_id || ', ' || :old.track_name || ', ' || :old.track_author || ', ' || :old.track_file || ', ' || :old.track_time || ', ' || :old.track_genre || ', ' || :old.track_count_of_learning, :new.track_id || ', ' || :new.track_name || ', ' || :new.track_author || ', ' || :new.track_file || ', ' || :new.track_time || ', ' || :new.track_genre || ', ' || :new.track_count_of_learning);
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
set serveroutput on;
/
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