--Удаление админстратора базы
drop user rgr_admin cascade;
/
--Удаление обычного пользователя
drop user rgr_user cascade;
/
--Удаление контент-мейкера
drop user rgr_creator cascade;
/
--Удаления файлов связанных с табличным пространством базы
drop tablespace RGR1 including contents and datafiles;
/