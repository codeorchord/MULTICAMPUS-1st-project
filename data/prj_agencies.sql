--------------------------------------------------------
--  파일이 생성됨 - 금요일-7월-26-2019   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table PRJ_AGENCIES
--------------------------------------------------------

  CREATE TABLE "HR"."PRJ_AGENCIES" 
   (	"AGENCY_NAME" VARCHAR2(30 BYTE), 
	"PHONE" VARCHAR2(15 BYTE), 
	"ADD_NEW" VARCHAR2(100 BYTE), 
	"ADD_OLD" VARCHAR2(100 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
REM INSERTING into HR.PRJ_AGENCIES
SET DEFINE OFF;
Insert into HR.PRJ_AGENCIES (AGENCY_NAME,PHONE,ADD_NEW,ADD_OLD) values ('서울특별시 강남구청','02-3423-6772',null,null);
Insert into HR.PRJ_AGENCIES (AGENCY_NAME,PHONE,ADD_NEW,ADD_OLD) values ('서울특별시 강동구청','02-3425-7090',null,null);
Insert into HR.PRJ_AGENCIES (AGENCY_NAME,PHONE,ADD_NEW,ADD_OLD) values ('서울특별시 강북구청','02-901-7266',null,null);
Insert into HR.PRJ_AGENCIES (AGENCY_NAME,PHONE,ADD_NEW,ADD_OLD) values ('서울특별시 강서구청','02-2600-1884',null,null);
Insert into HR.PRJ_AGENCIES (AGENCY_NAME,PHONE,ADD_NEW,ADD_OLD) values ('서울특별시 관악구청','02-879-5831',null,null);
Insert into HR.PRJ_AGENCIES (AGENCY_NAME,PHONE,ADD_NEW,ADD_OLD) values ('서울특별시 광진구청','02-450-7678',null,null);
Insert into HR.PRJ_AGENCIES (AGENCY_NAME,PHONE,ADD_NEW,ADD_OLD) values ('서울특별시 구로구청','02-860-2114',null,null);
Insert into HR.PRJ_AGENCIES (AGENCY_NAME,PHONE,ADD_NEW,ADD_OLD) values ('서울특별시 금천구청','02-2627-1904',null,null);
Insert into HR.PRJ_AGENCIES (AGENCY_NAME,PHONE,ADD_NEW,ADD_OLD) values ('서울특별시 노원구청','02-2116-4917',null,null);
Insert into HR.PRJ_AGENCIES (AGENCY_NAME,PHONE,ADD_NEW,ADD_OLD) values ('서울특별시 도봉구청','02-2091-4273',null,null);
Insert into HR.PRJ_AGENCIES (AGENCY_NAME,PHONE,ADD_NEW,ADD_OLD) values ('서울특별시 동대문구청','02-2127-4084',null,null);
Insert into HR.PRJ_AGENCIES (AGENCY_NAME,PHONE,ADD_NEW,ADD_OLD) values ('서울특별시 동작구청','02-820-1118 ',null,null);
Insert into HR.PRJ_AGENCIES (AGENCY_NAME,PHONE,ADD_NEW,ADD_OLD) values ('서울특별시 마포구청','02-3153-8432',null,null);
Insert into HR.PRJ_AGENCIES (AGENCY_NAME,PHONE,ADD_NEW,ADD_OLD) values ('서울특별시 서대문구청','02-330-1080',null,null);
Insert into HR.PRJ_AGENCIES (AGENCY_NAME,PHONE,ADD_NEW,ADD_OLD) values ('서울특별시 서초구청','02-2155-6098',null,null);
Insert into HR.PRJ_AGENCIES (AGENCY_NAME,PHONE,ADD_NEW,ADD_OLD) values ('서울특별시 성동구청','02-2286-5878',null,null);
Insert into HR.PRJ_AGENCIES (AGENCY_NAME,PHONE,ADD_NEW,ADD_OLD) values ('서울특별시 성북구청','02-2241-4562',null,null);
Insert into HR.PRJ_AGENCIES (AGENCY_NAME,PHONE,ADD_NEW,ADD_OLD) values ('서울특별시 송파구청','02-2147-3090',null,null);
Insert into HR.PRJ_AGENCIES (AGENCY_NAME,PHONE,ADD_NEW,ADD_OLD) values ('서울특별시 양천구청','02-2620-4793',null,null);
Insert into HR.PRJ_AGENCIES (AGENCY_NAME,PHONE,ADD_NEW,ADD_OLD) values ('서울특별시 영등포구청','02-2670-4069',null,null);
Insert into HR.PRJ_AGENCIES (AGENCY_NAME,PHONE,ADD_NEW,ADD_OLD) values ('서울특별시 용산구청','02-2199-6662',null,null);
Insert into HR.PRJ_AGENCIES (AGENCY_NAME,PHONE,ADD_NEW,ADD_OLD) values ('서울특별시 은평구청','02-351-8007',null,null);
Insert into HR.PRJ_AGENCIES (AGENCY_NAME,PHONE,ADD_NEW,ADD_OLD) values ('서울특별시 종로구청','02-2148-4301',null,null);
Insert into HR.PRJ_AGENCIES (AGENCY_NAME,PHONE,ADD_NEW,ADD_OLD) values ('서울특별시 중구청','02-3396-4744',null,null);
Insert into HR.PRJ_AGENCIES (AGENCY_NAME,PHONE,ADD_NEW,ADD_OLD) values ('서울특별시 중랑구청','02-2094-0284',null,null);
--------------------------------------------------------
--  DDL for Index SYS_C0011170
--------------------------------------------------------

  CREATE UNIQUE INDEX "HR"."SYS_C0011170" ON "HR"."PRJ_AGENCIES" ("AGENCY_NAME") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  Constraints for Table PRJ_AGENCIES
--------------------------------------------------------

  ALTER TABLE "HR"."PRJ_AGENCIES" ADD PRIMARY KEY ("AGENCY_NAME")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
