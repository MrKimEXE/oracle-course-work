--��� ������ �����, ��� �������� �� ��� ������ ����

--�������� ������������� ����
drop user rgr_admin cascade;
/
--�������� �������� ������������
drop user rgr_user cascade;
/
--�������� �������-�������
drop user rgr_creator cascade;
/
--�������� ������ ��������� � ��������� ������������� ����
drop tablespace RGR1 including contents and datafiles;
/

--�������� ������������ ������
CREATE USER RGR_admin IDENTIFIED BY NoviyParol 
DEFAULT TABLESPACE USERS
temporary tablespace TEMP;
/
--������ ���� ��� ������
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