
drop table if exists cust1;
select distinct(CURL_OUT_KEY_FULL_ACCOUNT) as CURL_OUT_KEY_FULL_ACCOUNT,CURL_MMBR_SQNC_NR,curl_type_cd from cust_role
--where CURL_OUT_KEY_FULL_ACCOUNT[13,28]='5278691000901397'
--and CURL_MMBR_SQNC_NR='003'
into temp cust1;


--select distinct(CURL_MMBR_SQNC_NR) from cust1

drop table if exists cards0;
SELECT
case when cust1.CURL_MMBR_SQNC_NR in ('003','004','005','006','007','008','009') then cust1.CURL_MMBR_SQNC_NR||cust_seg.CHD_ACCOUNT_NUMBER[4,16] end as card_no,
cust_seg.CHD_ACCOUNT_NUMBER as primary_card_no,
cust_seg.CHD_ACCOUNT_NUMBER as bank_account_no,
--cust_seg.chd_short_name as ,
--cust_seg.chd_spouse_name,
cust_seg.chd_addr_line_1 as address1,
cust_seg.chd_addr_line_2 as address2,
cust_seg.chd_city as city,
cust_seg.chd_state as state,
cust_seg.chd_zip_code as zip_postal_code,
cust_seg.chd_addr_line_1 as bill_address1,
cust_seg.chd_addr_line_2 as bill_address2,
cust_seg.chd_city as bill_city,
cust_seg.chd_state as bill_state_code,
cust_seg.chd_zip_code as bill_zip_code,
cust_seg.chd_sex_code as gender,
--cust_seg.CHD_SOC_SECURITY_NO as ssn_nid_no,
add_names.cnm_altr_cust_id as ssn_nid_no,
cust_seg.CHD_TELEPHONE_NUMBER as mobile_no,
cust_seg.CHD_SECOND_TELEPHONE_NUMBER as home_phone_no,
--cust_seg.CHD_SECONDARY_SOC_SEC_NO,
--cust_seg.CHD_DATE_OF_BIRTH,
--cust_seg.CHD_SECONDARY_DATE_OF_BIRTH,
--add_names.cnm_account_no,
add_names.cnm_name as first_name1,
add_names.cnm_brth_dt date_of_birth
--add_names.cnm_altr_cust_id,
--cust1.curl_type_cd,
--cust1.CURL_OUT_KEY_FULL_ACCOUNT,
--cust1.CURL_MMBR_SQNC_NR
,base_seg.chd_open_date as created_on
,base_seg.chd_expiration_date as expiry_on
,base_seg.CHD_EXTERNAL_STATUS as card_status_atm
,base_seg.CHD_EXTERNAL_STATUS as card_status_pos
,base_seg.CHD_EXTERNAL_STATUS as card_detail_status
,base_seg.CHD_PIN_VERIFY_1 as pin_offset
-- ,base_seg2.chd_new_xref_no_2 as src_card_no
,case when cust1.CURL_MMBR_SQNC_NR in ('003','004','005','006','007','008','009') then cust1.CURL_MMBR_SQNC_NR||base_seg2.chd_new_xref_no_2[4,16] end as src_card_no
,base_seg4.chd_reis_strt_dt as last_reissue_on
FROM cust_seg,add_names, cust1,base_seg,base_seg2,base_seg3,base_seg4
where add_names.cnm_account_no = cust_seg.CHD_ACCOUNT_NUMBER
and cust_seg.CHD_ACCOUNT_NUMBER=cust1.CURL_OUT_KEY_FULL_ACCOUNT[13,28]
and add_names.cnm_account_no=cust1.CURL_OUT_KEY_FULL_ACCOUNT[13,28]
and (add_names.cnm_card_no[1]=cust1.CURL_MMBR_SQNC_NR[3]
--add_names.cnm_card_no[1,2]=cust1.CURL_MMBR_SQNC_NR[2,3]
)

and base_seg.CHD_ACCOUNT_NUMBER = cust_seg.CHD_ACCOUNT_NUMBER
and base_seg2.CHD_ACCOUNT_NUMBER = cust_seg.CHD_ACCOUNT_NUMBER
and base_seg3.CHD_ACCOUNT_NUMBER = cust_seg.CHD_ACCOUNT_NUMBER
and base_seg4.CHD_ACCOUNT_NUMBER = cust_seg.CHD_ACCOUNT_NUMBER

--and add_names.cnm_account_no='5278690000916579'
and cust1.CURL_MMBR_SQNC_NR in ('003','004','005','006','007','008','009') -- 003 1st suppl, 004 2nd, 005 3rd supple and so on till the number of suppl
and cust1.curl_type_cd='03' --01 will give primary, 02 joints and
into temp cards0
;



drop table if exists cards1 ;
select * from cards
where 1<>1
into temp cards1;


insert into cards1
(
card_no,
teleref_no,
primary_card_no,
address1,
address2,
city,
state_code,
zip_postal_code,
gender,
ssn_nid_no,
mobile_no,
home_phone_no,
first_name1,
last_name1,
date_of_birth,
created_on,
expiry_on,
card_status_atm,
card_status_pos,
src_card_no
,bill_address1
,bill_address2
,bill_city
,bill_state_code
,bill_zip_code
,bank_account_no
,last_reissue_on
,pin_offset
,card_detail_status
----------------------------------
,remarks, avs_status, ofac_status, ccv_status, dob_status, dl_status, phv_status, transit_flag,
card_batch_no, card_batch_flag, shipping_method, pin_length, badpin_ntries, track_batch_no, card_gen_mode, card_status,
fraud_info_flag,calc_avs_flag
,expiration_months  -- based on prg
,reissue_months  -- based on prg
,cacm_status,is_auth_partner,nlost_stolens
,nfee_reverals  --- need to check
,ofac_resp_code,avs_resp_code
,card_design
,card_logo
,ship_addr_options
--,card_srno
,card_prg_id
,stake_holder_id
,naccounts
,is_main_card
,card_category
,is_corporate_cust
,bill_country_code
,country_code
)
select
card_no,
card_no,
primary_card_no,
address1,
address2,
city,
state,
zip_postal_code,
gender,
ssn_nid_no,
mobile_no,
home_phone_no,
SUBSTR(first_name1, INSTR(first_name1, ',') + 1) AS first_name1,
SUBSTR(first_name1, 1, INSTR(first_name1, ',') - 1) AS last_name1,
SUBSTR(date_of_birth, 6, 2)||'/'||SUBSTR(date_of_birth, 9, 2)||'/'||SUBSTR(date_of_birth, 1, 4),
SUBSTR(created_on, 3, 2)||'/'||SUBSTR(created_on, 5, 2)||'/'||SUBSTR(created_on, 1, 2),
SUBSTR(expiry_on, 3, 2)||'/'||SUBSTR(expiry_on, 5, 2)||'/'||SUBSTR(expiry_on, 1, 2),
card_status_atm,
card_status_pos,
src_card_no
,bill_address1
,bill_address2
,bill_city
,bill_state_code
,bill_zip_code
,bank_account_no
,SUBSTR(last_reissue_on, 6, 2)||'/'||SUBSTR(last_reissue_on, 9, 2)||'/'||SUBSTR(last_reissue_on, 1, 4)
,pin_offset[2,5]
,card_detail_status
---------------------------------
,'Migrated Cards','G','G','G','G','G','G','N',
'1', 'A','4' ,'4','0','1','G', 'A' -- need to check
,0,0
,36  -- need to change according to card program
,24   -- need to change according to card program
,'A',0,0
,0      --- fee reversal --- need to check in transactions
,'G','G'
,'1005'   --- card design needs to be changed as per program
,'1'   --- card logo needs to be changed as per program
,'4'
--,1000
,'Card Program ID',
'Stake Holder ID',
'1',
'N',
'C',
'N',
'820',
'820'
from cards0;
------------------------------------------------------------
--Supple B

drop table if exists cards0;
SELECT
case when cust1.CURL_MMBR_SQNC_NR in ('010','011') then cust1.CURL_MMBR_SQNC_NR||cust_seg.CHD_ACCOUNT_NUMBER[4,16] end as card_no,
cust_seg.CHD_ACCOUNT_NUMBER as primary_card_no,
cust_seg.CHD_ACCOUNT_NUMBER as bank_account_no,
--cust_seg.chd_short_name as ,
--cust_seg.chd_spouse_name,
cust_seg.chd_addr_line_1 as address1,
cust_seg.chd_addr_line_2 as address2,
cust_seg.chd_city as city,
cust_seg.chd_state as state,
cust_seg.chd_zip_code as zip_postal_code,
cust_seg.chd_addr_line_1 as bill_address1,
cust_seg.chd_addr_line_2 as bill_address2,
cust_seg.chd_city as bill_city,
cust_seg.chd_state as bill_state_code,
cust_seg.chd_zip_code as bill_zip_code,
cust_seg.chd_sex_code as gender,
--cust_seg.CHD_SOC_SECURITY_NO as ssn_nid_no,
add_names.cnm_altr_cust_id as ssn_nid_no,
cust_seg.CHD_TELEPHONE_NUMBER as mobile_no,
cust_seg.CHD_SECOND_TELEPHONE_NUMBER as home_phone_no,
--cust_seg.CHD_SECONDARY_SOC_SEC_NO,
--cust_seg.CHD_DATE_OF_BIRTH,
--cust_seg.CHD_SECONDARY_DATE_OF_BIRTH,
--add_names.cnm_account_no,
add_names.cnm_name as first_name1,
add_names.cnm_brth_dt date_of_birth
--add_names.cnm_altr_cust_id,
--cust1.curl_type_cd,
--cust1.CURL_OUT_KEY_FULL_ACCOUNT,
--cust1.CURL_MMBR_SQNC_NR
,base_seg.chd_open_date as created_on
,base_seg.chd_expiration_date as expiry_on
,base_seg.CHD_EXTERNAL_STATUS as card_status_atm
,base_seg.CHD_EXTERNAL_STATUS as card_status_pos
,base_seg.CHD_EXTERNAL_STATUS as card_detail_status
,base_seg.CHD_PIN_VERIFY_1 as pin_offset
-- ,base_seg2.chd_new_xref_no_2 as src_card_no
,case when cust1.CURL_MMBR_SQNC_NR in ('010','011') then cust1.CURL_MMBR_SQNC_NR||base_seg2.chd_new_xref_no_2[4,16] end as src_card_no
,base_seg4.chd_reis_strt_dt as last_reissue_on
FROM cust_seg,add_names, cust1,base_seg,base_seg2,base_seg3,base_seg4
where add_names.cnm_account_no = cust_seg.CHD_ACCOUNT_NUMBER
and cust_seg.CHD_ACCOUNT_NUMBER=cust1.CURL_OUT_KEY_FULL_ACCOUNT[13,28]
and add_names.cnm_account_no=cust1.CURL_OUT_KEY_FULL_ACCOUNT[13,28]
--and (add_names.cnm_card_no[1]=cust1.CURL_MMBR_SQNC_NR[3]
and add_names.cnm_card_no[1,2]=cust1.CURL_MMBR_SQNC_NR[2,3]
--)

and base_seg.CHD_ACCOUNT_NUMBER = cust_seg.CHD_ACCOUNT_NUMBER
and base_seg2.CHD_ACCOUNT_NUMBER = cust_seg.CHD_ACCOUNT_NUMBER
and base_seg3.CHD_ACCOUNT_NUMBER = cust_seg.CHD_ACCOUNT_NUMBER
and base_seg4.CHD_ACCOUNT_NUMBER = cust_seg.CHD_ACCOUNT_NUMBER

--and add_names.cnm_account_no='5278691000905836'
and cust1.CURL_MMBR_SQNC_NR in ('010','011') -- 003 1st suppl, 004 2nd, 005 3rd supple and so on till the number of suppl
and cust1.curl_type_cd='03' --01 will give primary, 02 joints and
into temp cards0
;



insert into cards1
(
card_no,
teleref_no,
primary_card_no,
address1,
address2,
city,
state_code,
zip_postal_code,
gender,
ssn_nid_no,
mobile_no,
home_phone_no,
first_name1,
last_name1,
date_of_birth,
created_on,
expiry_on,
card_status_atm,
card_status_pos,
src_card_no
,bill_address1
,bill_address2
,bill_city
,bill_state_code
,bill_zip_code
,bank_account_no
,last_reissue_on
,pin_offset
,card_detail_status
----------------------------------
,remarks, avs_status, ofac_status, ccv_status, dob_status, dl_status, phv_status, transit_flag,
card_batch_no, card_batch_flag, shipping_method, pin_length, badpin_ntries, track_batch_no, card_gen_mode, card_status,
fraud_info_flag,calc_avs_flag
,expiration_months  -- based on prg
,reissue_months  -- based on prg
,cacm_status,is_auth_partner,nlost_stolens
,nfee_reverals  --- need to check
,ofac_resp_code,avs_resp_code
,card_design
,card_logo
,ship_addr_options
--,card_srno
,card_prg_id
,stake_holder_id
,naccounts
,is_main_card
,card_category
,is_corporate_cust
,bill_country_code
,country_code
)
select
card_no,
card_no,
primary_card_no,
address1,
address2,
city,
state,
zip_postal_code,
gender,
ssn_nid_no,
mobile_no,
home_phone_no,
SUBSTR(first_name1, INSTR(first_name1, ',') + 1) AS first_name1,
SUBSTR(first_name1, 1, INSTR(first_name1, ',') - 1) AS last_name1,
SUBSTR(date_of_birth, 6, 2)||'/'||SUBSTR(date_of_birth, 9, 2)||'/'||SUBSTR(date_of_birth, 1, 4),
SUBSTR(created_on, 3, 2)||'/'||SUBSTR(created_on, 5, 2)||'/'||SUBSTR(created_on, 1, 2),
SUBSTR(expiry_on, 3, 2)||'/'||SUBSTR(expiry_on, 5, 2)||'/'||SUBSTR(expiry_on, 1, 2),
card_status_atm,
card_status_pos,
src_card_no
,bill_address1
,bill_address2
,bill_city
,bill_state_code
,bill_zip_code
,bank_account_no
,SUBSTR(last_reissue_on, 6, 2)||'/'||SUBSTR(last_reissue_on, 9, 2)||'/'||SUBSTR(last_reissue_on, 1, 4)
,pin_offset[2,5]
,card_detail_status
---------------------------------
,'Migrated Cards','G','G','G','G','G','G','N',
'1', 'A','4' ,'4','0','1','G', 'A' -- need to check
,0,0
,36  -- need to change according to card program
,24   -- need to change according to card program
,'A',0,0
,0      --- fee reversal --- need to check in transactions
,'G','G'
,'1005'   --- card design needs to be changed as per program
,'1'   --- card logo needs to be changed as per program
,'4'
--,1000
,'Card Program ID',
'Stake Holder ID',
'1',
'N',
'C',
'N',
'820',
'820'
from cards0;



------------------------------

--Primary Cards


drop table if exists cards0;
SELECT
--case when cust1.CURL_MMBR_SQNC_NR in ('003','004','005','006','007','008','009') then cust1.CURL_MMBR_SQNC_NR||cust_seg.CHD_ACCOUNT_NUMBER[4,16] end as card_no,
case when cust1.curl_type_cd='01' then cust_seg.CHD_ACCOUNT_NUMBER[1,16] end as card_no,
cust_seg.CHD_ACCOUNT_NUMBER as primary_card_no,
cust_seg.CHD_ACCOUNT_NUMBER as bank_account_no,
cust_seg.chd_short_name as first_name1,
--cust_seg.chd_spouse_name,
cust_seg.chd_addr_line_1 as address1,
cust_seg.chd_addr_line_2 as address2,
cust_seg.chd_city as city,
cust_seg.chd_state as state,
cust_seg.chd_zip_code as zip_postal_code,
cust_seg.chd_addr_line_1 as bill_address1,
cust_seg.chd_addr_line_2 as bill_address2,
cust_seg.chd_city as bill_city,
cust_seg.chd_state as bill_state_code,
cust_seg.chd_zip_code as bill_zip_code,
cust_seg.chd_sex_code as gender,
cust_seg.CHD_SOC_SECURITY_NO as ssn_nid_no,
cust_seg.CHD_TELEPHONE_NUMBER as mobile_no,
cust_seg.CHD_SECOND_TELEPHONE_NUMBER as home_phone_no,
--cust_seg.CHD_SECONDARY_SOC_SEC_NO,
cust_seg.CHD_DATE_OF_BIRTH as date_of_birth
--cust_seg.CHD_SECONDARY_DATE_OF_BIRTH,
--add_names.cnm_account_no,
--add_names.cnm_name as first_name1,
--add_names.cnm_brth_dt date_of_birth
--add_names.cnm_altr_cust_id,
--cust1.curl_type_cd,
--cust1.CURL_OUT_KEY_FULL_ACCOUNT,
--cust1.CURL_MMBR_SQNC_NR
,base_seg.chd_open_date as created_on
,base_seg.chd_expiration_date as expiry_on
,base_seg.CHD_EXTERNAL_STATUS as card_status_atm
,base_seg.CHD_EXTERNAL_STATUS as card_status_pos
,base_seg.CHD_EXTERNAL_STATUS as card_detail_status
,base_seg.CHD_PIN_VERIFY_1 as pin_offset
,base_seg2.chd_new_xref_no_2 as src_card_no
,base_seg4.chd_reis_strt_dt as last_reissue_on
FROM cust_seg, cust1,base_seg,base_seg2,base_seg3,base_seg4
where cust_seg.CHD_ACCOUNT_NUMBER=cust1.CURL_OUT_KEY_FULL_ACCOUNT[13,28]
--and add_names.cnm_account_no=cust1.CURL_OUT_KEY_FULL_ACCOUNT[13,28]
--and (add_names.cnm_card_no[1]=cust1.CURL_MMBR_SQNC_NR[3]
--add_names.cnm_card_no[1,2]=cust1.CURL_MMBR_SQNC_NR[2,3]
--)

and base_seg.CHD_ACCOUNT_NUMBER = cust_seg.CHD_ACCOUNT_NUMBER
and base_seg2.CHD_ACCOUNT_NUMBER = cust_seg.CHD_ACCOUNT_NUMBER
and base_seg3.CHD_ACCOUNT_NUMBER = cust_seg.CHD_ACCOUNT_NUMBER
and base_seg4.CHD_ACCOUNT_NUMBER = cust_seg.CHD_ACCOUNT_NUMBER

    --and base_seg.CHD_ACCOUNT_NUMBER='5278690000916579'
--and cust1.CURL_MMBR_SQNC_NR in ('003','004','005','006','007','008','009') -- 003 1st suppl, 004 2nd, 005 3rd supple and so on till the number of suppl
and cust1.curl_type_cd='01' --01 will give primary, 02 joints and
into temp cards0
;


insert into cards1
(
card_no,
teleref_no,
primary_card_no,
address1,
address2,
city,
state_code,
zip_postal_code,
gender,
ssn_nid_no,
mobile_no,
home_phone_no,
first_name1,
last_name1,
date_of_birth,
created_on,
expiry_on,
card_status_atm,
card_status_pos,
src_card_no
,bill_address1
,bill_address2
,bill_city
,bill_state_code
,bill_zip_code
,bank_account_no
,last_reissue_on
,pin_offset
,card_detail_status
----------------------------------
,remarks, avs_status, ofac_status, ccv_status, dob_status, dl_status, phv_status, transit_flag,
card_batch_no, card_batch_flag, shipping_method, pin_length, badpin_ntries, track_batch_no, card_gen_mode, card_status,
fraud_info_flag,calc_avs_flag
,expiration_months  -- based on prg
,reissue_months  -- based on prg
,cacm_status,is_auth_partner,nlost_stolens
,nfee_reverals  --- need to check
,ofac_resp_code,avs_resp_code
,card_design
,card_logo
,ship_addr_options
--,card_srno
,card_prg_id
,stake_holder_id
,naccounts
,is_main_card
,card_category
,is_corporate_cust
,bill_country_code
,country_code
)
select
card_no,
card_no,
primary_card_no,
address1,
address2,
city,
state,
zip_postal_code,
gender,
ssn_nid_no,
mobile_no,
home_phone_no,
SUBSTR(first_name1, INSTR(first_name1, ',') + 1) AS first_name1,
SUBSTR(first_name1, 1, INSTR(first_name1, ',') - 1) AS last_name1,
SUBSTR(date_of_birth, 6, 2)||'/'||SUBSTR(date_of_birth, 9, 2)||'/'||SUBSTR(date_of_birth, 1, 4),
SUBSTR(created_on, 3, 2)||'/'||SUBSTR(created_on, 5, 2)||'/'||SUBSTR(created_on, 1, 2),
SUBSTR(expiry_on, 3, 2)||'/'||SUBSTR(expiry_on, 5, 2)||'/'||SUBSTR(expiry_on, 1, 2),
card_status_atm,
card_status_pos,
src_card_no
,bill_address1
,bill_address2
,bill_city
,bill_state_code
,bill_zip_code
,bank_account_no
,SUBSTR(last_reissue_on, 6, 2)||'/'||SUBSTR(last_reissue_on, 9, 2)||'/'||SUBSTR(last_reissue_on, 1, 4)
,pin_offset[2,5]
,card_detail_status
---------------------------------
,'Migrated Cards','G','G','G','G','G','G','N',
'1', 'A','4' ,'4','0','1','G', 'A' -- need to check
,0,0
,36  -- need to change according to card program
,24   -- need to change according to card program
,'A',0,0
,0      --- fee reversal --- need to check in transactions
,'G','G'
,'1005'   --- card design needs to be changed as per program
,'1'   --- card logo needs to be changed as per program
,'4'
--,1000
,'Card Program ID',
'Stake Holder ID',
'1',
'Y',
'C',
'N',
'820',
'820'
from cards0;



------------------------------

--Joint Cards



drop table if exists cards0;
SELECT
--case when cust1.CURL_MMBR_SQNC_NR in ('003','004','005','006','007','008','009') then cust1.CURL_MMBR_SQNC_NR||cust_seg.CHD_ACCOUNT_NUMBER[4,16] end as card_no,
case when cust1.curl_type_cd='02' then cust1.CURL_MMBR_SQNC_NR||cust_seg.CHD_ACCOUNT_NUMBER[4,16] end as card_no,
cust_seg.CHD_ACCOUNT_NUMBER as primary_card_no,
cust_seg.CHD_ACCOUNT_NUMBER as bank_account_no,
--cust_seg.chd_short_name as first_name1,
cust_seg.chd_spouse_name as first_name1,
cust_seg.chd_addr_line_1 as address1,
cust_seg.chd_addr_line_2 as address2,
cust_seg.chd_city as city,
cust_seg.chd_state as state,
cust_seg.chd_zip_code as zip_postal_code,
cust_seg.chd_addr_line_1 as bill_address1,
cust_seg.chd_addr_line_2 as bill_address2,
cust_seg.chd_city as bill_city,
cust_seg.chd_state as bill_state_code,
cust_seg.chd_zip_code as bill_zip_code,
cust_seg.chd_sex_code as gender,
--cust_seg.CHD_SOC_SECURITY_NO as ssn_nid_no,
cust_seg.CHD_TELEPHONE_NUMBER as mobile_no,
cust_seg.CHD_SECOND_TELEPHONE_NUMBER as home_phone_no,
cust_seg.CHD_SECONDARY_SOC_SEC_NO as ssn_nid_no,
--cust_seg.CHD_DATE_OF_BIRTH as date_of_birth
cust_seg.CHD_SECONDARY_DATE_OF_BIRTH as date_of_birth
--add_names.cnm_account_no,
--add_names.cnm_name as first_name1,
--add_names.cnm_brth_dt date_of_birth
--add_names.cnm_altr_cust_id,
--cust1.curl_type_cd,
--cust1.CURL_OUT_KEY_FULL_ACCOUNT,
--cust1.CURL_MMBR_SQNC_NR
,base_seg.chd_open_date as created_on
,base_seg.chd_expiration_date as expiry_on
,base_seg.CHD_EXTERNAL_STATUS as card_status_atm
,base_seg.CHD_EXTERNAL_STATUS as card_status_pos
,base_seg.CHD_EXTERNAL_STATUS as card_detail_status
,base_seg.CHD_PIN_VERIFY_1 as pin_offset
,case when cust1.curl_type_cd='02' then cust1.CURL_MMBR_SQNC_NR||base_seg2.chd_new_xref_no_2[4,16] end as src_card_no
,base_seg4.chd_reis_strt_dt as last_reissue_on
FROM cust_seg, cust1,base_seg,base_seg2,base_seg3,base_seg4
where cust_seg.CHD_ACCOUNT_NUMBER=cust1.CURL_OUT_KEY_FULL_ACCOUNT[13,28]
--and add_names.cnm_account_no=cust1.CURL_OUT_KEY_FULL_ACCOUNT[13,28]
--and (add_names.cnm_card_no[1]=cust1.CURL_MMBR_SQNC_NR[3]
--add_names.cnm_card_no[1,2]=cust1.CURL_MMBR_SQNC_NR[2,3]
--)

and base_seg.CHD_ACCOUNT_NUMBER = cust_seg.CHD_ACCOUNT_NUMBER
and base_seg2.CHD_ACCOUNT_NUMBER = cust_seg.CHD_ACCOUNT_NUMBER
and base_seg3.CHD_ACCOUNT_NUMBER = cust_seg.CHD_ACCOUNT_NUMBER
and base_seg4.CHD_ACCOUNT_NUMBER = cust_seg.CHD_ACCOUNT_NUMBER

        --and base_seg.CHD_ACCOUNT_NUMBER='5278690000916579'
--and cust1.CURL_MMBR_SQNC_NR in ('003','004','005','006','007','008','009') -- 003 1st suppl, 004 2nd, 005 3rd supple and so on till the number of suppl
and cust1.curl_type_cd='02' --01 will give primary, 02 joints and
into temp cards0
;


insert into cards1
(
card_no,
teleref_no,
primary_card_no,
address1,
address2,
city,
state_code,
zip_postal_code,
gender,
ssn_nid_no,
mobile_no,
home_phone_no,
first_name1,
last_name1,
date_of_birth,
created_on,
expiry_on,
card_status_atm,
card_status_pos,
src_card_no
,bill_address1
,bill_address2
,bill_city
,bill_state_code
,bill_zip_code
,bank_account_no
,last_reissue_on
,pin_offset
,card_detail_status
----------------------------------
,remarks, avs_status, ofac_status, ccv_status, dob_status, dl_status, phv_status, transit_flag,
card_batch_no, card_batch_flag, shipping_method, pin_length, badpin_ntries, track_batch_no, card_gen_mode, card_status,
fraud_info_flag,calc_avs_flag
,expiration_months  -- based on prg
,reissue_months  -- based on prg
,cacm_status,is_auth_partner,nlost_stolens
,nfee_reverals  --- need to check
,ofac_resp_code,avs_resp_code
,card_design
,card_logo
,ship_addr_options
--,card_srno
,card_prg_id
,stake_holder_id
,naccounts
,is_main_card
,card_category
,is_corporate_cust
,bill_country_code
,country_code
)
select
card_no,
card_no,
primary_card_no,
address1,
address2,
city,
state,
zip_postal_code,
gender,
ssn_nid_no,
mobile_no,
home_phone_no,
SUBSTR(first_name1, INSTR(first_name1, ',') + 1) AS first_name1,
SUBSTR(first_name1, 1, INSTR(first_name1, ',') - 1) AS last_name1,
SUBSTR(date_of_birth, 6, 2)||'/'||SUBSTR(date_of_birth, 9, 2)||'/'||SUBSTR(date_of_birth, 1, 4),
SUBSTR(created_on, 3, 2)||'/'||SUBSTR(created_on, 5, 2)||'/'||SUBSTR(created_on, 1, 2),
SUBSTR(expiry_on, 3, 2)||'/'||SUBSTR(expiry_on, 5, 2)||'/'||SUBSTR(expiry_on, 1, 2),
card_status_atm,
card_status_pos,
src_card_no
,bill_address1
,bill_address2
,bill_city
,bill_state_code
,bill_zip_code
,bank_account_no
,SUBSTR(last_reissue_on, 6, 2)||'/'||SUBSTR(last_reissue_on, 9, 2)||'/'||SUBSTR(last_reissue_on, 1, 4)
,pin_offset[2,5]
,card_detail_status
---------------------------------
,'Migrated Cards','G','G','G','G','G','G','N',
'1', 'A','4' ,'4','0','1','G', 'A' -- need to check
,0,0
,36  -- need to change according to card program
,24   -- need to change according to card program
,'A',0,0
,0      --- fee reversal --- need to check in transactions
,'G','G'
,'1005'   --- card design needs to be changed as per program
,'1'   --- card logo needs to be changed as per program
,'4'
--,1000
,'Card Program ID',
'Stake Holder ID',
'1',
'N',
'C',
'N',
'820',
'820'
from cards0;


delete from cards1 where ssn_nid_no = '0';


drop table if exists t1;
with tmp as (
select count(*) cnt, primary_card_no from cards1 group by 2 having count(*) = 1)
select card_no
from cards1 c1
inner join tmp on tmp.primary_card_no=c1.card_no
into temp t1;


--For Only joint cards.
drop table if exists t2;
select card_no from cards1
where primary_card_no in (select primary_card_no from cards1 where card_no[1,3]='002')
into temp t2;

update cards1
set remarks='Migrated-1-ind', is_main_card='Y', card_prg_id='LrMainPrg', card_link_type=NULL
where card_no in (select card_no from t1);

update cards1
set remarks='Migrated-joint', is_main_card='N',
card_prg_id=(case card_no[1,3] when '527' then 'LrJointPrg' when '002' then 'LrJointPrg' else 'LrJointSuppPrg' end),
card_link_type=(case card_no[1,3] when '527' then 'M' when '002' then 'M' else 'N' end)
where card_no in (select card_no from t2);

--For Only Supplementary cards.

update cards1
set remarks='Migrated-Sup', card_prg_id=(case card_no[1,3] when '527' then 'LrMainPrg' else 'LrSuppPrg' end),
card_link_type=(case card_no[1,3] when '527' then NULL else 'S' end)
where card_no not in (select card_no from t1 union all select card_no from t2);

update cards1
set src_card_no = NULL
where src_card_no <> '0'
and src_card_no not in (select card_no from cards1);

update cards1
set src_card_no = NULL
where src_card_no = '0';


--select * from cards1 where card_prg_id is NULL;

--------------------


--
-- drop table if exists t1_start;
-- select card_no[1,16], ssn_nid_no[1,10], primary_card_no[1,16], src_card_no[1,16],card_prg_id,level
-- ,connect_by_root bank_account_no as root
-- from cards1
-- start with src_card_no IS NULL and teleref_no[1,3] = '527'
-- connect by nocycle src_card_no = prior card_no
-- INTO TEMP t1_start;
--
--
-- drop table if exists reissue_cards;
-- select distinct * from t1_start
-- where 1=1
-- order by root
-- into temp reissue_cards;
--
--
-- unload to t1_start_7.unl
-- select * from reissue_cards;

drop table if exists reissue_cards;
select card_no[1,16], ssn_nid_no[1,10], primary_card_no[1,16], src_card_no[1,16],card_prg_id,0 as level
,connect_by_root bank_account_no as root
from cards1
where 1=0
into temp reissue_cards;

load from t1_start_6.unl
insert into reissue_cards;


update cards1 c1
set c1.bank_account_no = rc.root, bank_account_dgt = rc.level
from reissue_cards rc
where rc.card_no = c1.card_no;


--------------------

drop table if exists tkn_card;
select card_no, card_no tokenized_card from cards where 1=0 into temp tkn_card;

load from Output.unl
insert into tkn_card;

update cards1 c1
set c1.card_no=tc.tokenized_card
from tkn_card tc
where c1.card_no=tc.card_no;

update cards1 c1
set c1.primary_card_no=tc.tokenized_card
from tkn_card tc
where c1.primary_card_no=tc.card_no;

update cards1 c1
set c1.src_card_no=tc.tokenized_card
from tkn_card tc
where c1.src_card_no=tc.card_no;

update cards1 c1
set c1.bank_account_no=tc.tokenized_card
from tkn_card tc
where c1.bank_account_no=tc.card_no;

--------------------

drop table if exists pri_map;
select tmp.sr,tmp.bank_account_no,pri.card_no primary_card_no
from
(select distinct bank_account_no, dense_rank() over (order by bank_account_no) sr from cards1
where card_prg_id='LrJointPrg'
and teleref_no[1,3]='527') as tmp,
(select card_no, row_number() over (order by card_no) sr from cards
where card_prg_id ='LrAccPrg'
and remarks is NULL) as pri
where tmp.sr=pri.sr
into temp pri_map;


update cards1 c1
set c1.primary_card_no=pm.primary_card_no
from pri_map pm
where pm.bank_account_no=c1.bank_account_no
and c1.card_prg_id in ('LrJointPrg','LrJointSuppPrg');


update cards1
set primary_card_no=NULL
where card_prg_id='LrMainPrg';


update cards1 set track_batch_no = '-1' where 1=1;

update cards1 set card_status_atm=(
    case when card_status_atm is NULL then 'B'
    when card_status_atm='A' then 'I'
    when card_status_atm='B' then 'F'
    when card_status_atm='C' then 'F'
    -- when card_status_atm='F' then 'F'
    when card_status_atm='L' then 'C'
    when card_status_atm='U' then 'D'
    when card_status_atm='Z' then 'F'
    when card_status_atm='E' then 'B'  -- Needs to be confirmed by the client
    when card_status_atm='I' then 'B'  -- Needs to be confirmed by the client
    end)
where 1=1;
update cards1 set card_status_pos=card_status_atm where 1=1;

-- Card Detail Status: Missing

--------------------
-- Validation
--------------------


--------------- Cards Merge

MERGE INTO cards c
USING cards1 cc
ON c.card_no = cc.card_no
WHEN MATCHED THEN UPDATE
SET
c.address1 = cc.address1
,c.address2 = cc.address2
,c.address3 = cc.address3
,c.city = cc.city
,c.teleref_no = cc.teleref_no
,c.atm_ol_withd_limit=cc.atm_ol_withd_limit
,c.atm_of_withd_limit=cc.atm_of_withd_limit
,c.pos_ol_withd_limit=cc.pos_ol_withd_limit
,c.pos_of_withd_limit=cc.pos_of_withd_limit
,c.cr_ol_withd_limit =cc.cr_ol_withd_limit
,c.member_id = cc.member_id
,c.first_name2 = cc.first_name2
,c.state_code = cc.state_code
,c.zip_postal_code = cc.zip_postal_code
,c.country_code = cc.country_code
,c.pin_offset = cc.pin_offset
,c.card_access_code = cc.card_access_code
,c.home_phone_no = cc.home_phone_no
,c.work_phone_no = cc.work_phone_no
,c.mobile_no = cc.mobile_no
,c.card_status_atm = cc.card_status_atm
,c.card_status_pos = cc.card_status_pos
,c.last_sts_chg_on = cc.last_sts_chg_on
,c.type_of_card = cc.type_of_card
,c.date_of_birth = cc.date_of_birth
,c.primary_card_no = cc.primary_card_no
,c.expiry_on = cc.expiry_on
,c.first_issue_on = cc.first_issue_on
,c.last_reissue_on = cc.last_reissue_on
,c.src_card_no = cc.src_card_no
,c.email = cc.email
,c.reload2_open_at = cc.reload2_open_at
,c.gender = cc.gender
,c.extra_embossing = cc.extra_embossing
,c.source = cc.source
,c.ch_auth_id_doc = cc.ch_auth_id_doc
,c.bank_account_dgt = cc.bank_account_dgt
,c.bill_address1 = cc.bill_address1
,c.bill_address2 = cc.bill_address2
,c.bill_city = cc.bill_city
,c.bill_state_code = cc.bill_state_code
,c.bill_zip_code = cc.bill_zip_code
,c.bill_country_code = cc.bill_country_code
,c.reload1_phone = cc.reload1_phone
,c.reload1_addr1 = cc.reload1_addr1
,c.reload1_company = cc.reload1_company
,c.reload2_city = cc.reload2_city
,c.reload2_company = cc.reload2_company
,c.reload1_city = cc.reload1_city
,c.reload1_addr2 = cc.reload1_addr2
,c.bank_account_no = cc.bank_account_no
,c.employment_status = cc.employment_status
,c.occupation = cc.occupation
,c.forgn_id_state_cod = cc.forgn_id_state_cod
,c.last_act_on = cc.last_act_on
,c.first_inact_on = cc.first_inact_on
,c.is_main_card = cc.is_main_card
,c.card_detail_status = cc.card_detail_status
,c.delivery = cc.delivery
,c.remarks = cc.remarks
,c.avs_status = cc.avs_status
,c.ofac_status = cc.ofac_status
,c.ccv_status = cc.ccv_status
,c.dob_status = cc.dob_status
,c.dl_status = cc.dl_status
,c.phv_status = cc.phv_status
,c.transit_flag = cc.transit_flag
,c.card_batch_no = cc.card_batch_no
,c.card_batch_flag = cc.card_batch_flag
,c.shipping_method = cc.shipping_method
,c.pin_length = cc.pin_length
,c.badpin_ntries = cc.badpin_ntries
,c.track_batch_no = cc.track_batch_no
,c.card_gen_mode = cc.card_gen_mode
,c.card_status = cc.card_status
,c.fraud_info_flag = cc.fraud_info_flag
,c.calc_avs_flag = cc.calc_avs_flag
,c.expiration_months = cc.expiration_months
,c.reissue_months = cc.reissue_months
,c.cacm_status = cc.cacm_status
,c.is_auth_partner = cc.is_auth_partner
,c.nlost_stolens = cc.nlost_stolens
,c.nfee_reverals = cc.nfee_reverals
,c.ofac_resp_code = cc.ofac_resp_code
,c.avs_resp_code = cc.avs_resp_code
,c.card_design = cc.card_design
,c.card_logo = cc.card_logo
,c.ship_addr_options = cc.ship_addr_options
,c.card_category = cc.card_category
,c.service_id = cc.service_id
,c.last_cycle_on = cc.last_cycle_on
,c.last_monthly_chg_on = cc.last_monthly_chg_on
WHEN NOT MATCHED THEN INSERT (
c.card_no
  ,c.card_prg_id
  ,c.first_name1
  ,c.first_name2
  ,c.last_name1
  ,c.address1
  ,c.address2
  ,c.address3
  ,c.member_id
  ,c.city
  ,c.state_code
  ,c.zip_postal_code
  ,c.country_code
  ,c.pin_offset
  ,c.card_access_code
  ,c.home_phone_no
  ,c.work_phone_no
  ,c.mobile_no
  ,c.card_status_atm
  ,c.card_status_pos
  ,c.last_sts_chg_on
  ,c.created_on
  ,c.first_act_on
  ,c.type_of_card
  ,c.date_of_birth
  ,c.primary_card_no
  ,c.expiry_on
  ,c.first_issue_on
  ,c.last_reissue_on
  ,c.src_card_no
  ,c.email
  ,c.reload2_open_at
  ,c.ssn_nid_no
  ,c.gender
  ,c.extra_embossing
  ,c.source
  ,c.ch_auth_id_doc
  ,c.foreign_id
  ,c.bank_account_dgt
  ,c.bill_address1
  ,c.bill_address2
  ,c.bill_city
  ,c.bill_state_code
  ,c.bill_zip_code
  ,c.bill_country_code
  ,c.reload1_phone
  ,c.reload1_addr1
  ,c.reload1_company
  ,c.reload2_city
  ,c.reload2_company
  ,c.reload1_city
  ,c.reload1_addr2
  ,c.bank_account_no
  ,c.employment_status
  ,c.is_corporate_cust
  ,c.occupation
  ,c.forgn_id_state_cod
  ,c.last_act_on
  ,c.first_inact_on
  ,c.is_main_card
  ,c.card_detail_status
  ,c.delivery
  ,c.remarks
  ,c.avs_status
  ,c.ofac_status
  ,c.ccv_status
  ,c.dob_status
  ,c.dl_status
  ,c.phv_status
  ,c.transit_flag
  ,c.card_batch_no
  ,c.card_batch_flag
  ,c.shipping_method
  ,c.pin_length
  ,c.badpin_ntries
  ,c.track_batch_no
  ,c.card_gen_mode
  ,c.card_status
  ,c.fraud_info_flag
  ,c.calc_avs_flag
  ,c.expiration_months
  ,c.reissue_months
  ,c.cacm_status
  ,c.is_auth_partner
  ,c.nlost_stolens
  ,c.nfee_reverals
  ,c.ofac_resp_code
  ,c.avs_resp_code
  ,c.card_design
  ,c.card_logo
  ,c.ship_addr_options
  ,c.atm_ol_withd_limit
  ,c.atm_of_withd_limit
  ,c.pos_ol_withd_limit
  ,c.pos_of_withd_limit
  ,c.cr_ol_withd_limit
  ,c.teleref_no
  ,c.card_category
  ,c.service_id
  ,c.last_cycle_on
  ,c.last_monthly_chg_on
)
VALUES (cc.card_no
,cc.card_prg_id
,cc.first_name1
,cc.first_name2
,cc.last_name1
,cc.address1
,cc.address2
,cc.address3
,cc.member_id
,cc.city
,cc.state_code
,cc.zip_postal_code
,cc.country_code
,cc.pin_offset
,cc.card_access_code
,cc.home_phone_no
,cc.work_phone_no
,cc.mobile_no
,cc.card_status_atm
,cc.card_status_pos
,cc.last_sts_chg_on
,cc.created_on
,cc.first_act_on
,cc.type_of_card
,cc.date_of_birth
,cc.primary_card_no
,cc.expiry_on
,cc.first_issue_on
,cc.last_reissue_on
,cc.src_card_no
,cc.email
,cc.reload2_open_at
,cc.ssn_nid_no
,cc.gender
,cc.extra_embossing
,cc.source
,cc.ch_auth_id_doc
,cc.foreign_id
,cc.bank_account_dgt
,cc.bill_address1
,cc.bill_address2
,cc.bill_city
,cc.bill_state_code
,cc.bill_zip_code
,cc.bill_country_code
,cc.reload1_phone
,cc.reload1_addr1
,cc.reload1_company
,cc.reload2_city
,cc.reload2_company
,cc.reload1_city
,cc.reload1_addr2
,cc.bank_account_no
,cc.employment_status
,cc.is_corporate_cust
,cc.occupation
,cc.forgn_id_state_cod
,cc.last_act_on
,cc.first_inact_on
,cc.is_main_card
,cc.card_detail_status
,cc.delivery
,cc.remarks
,cc.avs_status
,cc.ofac_status
,cc.ccv_status
,cc.dob_status
,cc.dl_status
,cc.phv_status
,cc.transit_flag
,cc.card_batch_no
,cc.card_batch_flag
,cc.shipping_method
,cc.pin_length
,cc.badpin_ntries
,cc.track_batch_no
,cc.card_gen_mode
,cc.card_status
,cc.fraud_info_flag
,cc.calc_avs_flag
,cc.expiration_months
,cc.reissue_months
,cc.cacm_status
,cc.is_auth_partner
,cc.nlost_stolens
,cc.nfee_reverals
,cc.ofac_resp_code
,cc.avs_resp_code
,cc.card_design
,cc.card_logo
,cc.ship_addr_options
,cc.atm_ol_withd_limit
,cc.atm_of_withd_limit
,cc.pos_ol_withd_limit
,cc.pos_of_withd_limit
,cc.cr_ol_withd_limit
,cc.teleref_no
,cc.card_category
,cc.service_id
,cc.last_cycle_on
,cc.last_monthly_chg_on
);


-- To add cards in card_more_infos

merge INTO card_more_infos i USING cards c
ON (c.card_srno =i.card_srno)
WHEN
not matched
THEN
insert
(i.card_srno)
values
(c.card_srno);

----- Updates of card_more_infos -----------

-- update card_more_infos cmi
-- SET followme_card_srno = (select card_srno from cards c2 where c2.bank_account_no=c.bank_account_no and c2.bank_account_dgt=(c.bank_account_dgt+1))
-- from cards c
-- where c.card_srno = cmi.card_srno
-- and c.remarks like 'Migrated%' ;

update card_more_infos cmi
set followme_card_srno = card_link.new_srno
from (select c.card_srno, c2.card_srno new_srno
from cards c -- src card
left join cards c2 -- new cards
on c2.src_card_no = c.card_no
where c.remarks like 'Migrated%'
and c2.card_srno is not null) card_link
where card_link.card_srno = cmi.card_srno;


update carD_more_infos cmi
set curr_followme_card=curr_srno
from (SELECT c1.card_srno curr_srno, c2.card_srno
FROM cards c1 -- curr
JOIN cards c2
ON c1.bank_account_no =  c2.bank_account_no
where c1.carD_no NOT IN (SELECT src_card_no FROM cards WHERE src_card_no IS NOT NULL)
and c1.card_srno <> c2.card_srno and c1.remarks like 'Migrated%') curr_card
where curr_card.card_srno = cmi.card_srno;


 -- 2859 row(s) updated.

-----------------------------------------------

--- To make branch FIID and CH_ID

-- UPDATE cards
-- SET ch_id = NULL
-- WHERE remarks LIKE 'Migrated%';
  
update cards
set branch_fiid = nvl(getcardrefno(card_srno,0,12,2,'0'),'')
where branch_fiid is null;

update cards c
set ch_id =  nvl(getCardRefNo(curr_srno,card_batch_no,18,0,'0'),'')
from (SELECT c1.card_srno curr_srno, c2.card_srno
FROM cards c1 -- curr
JOIN cards c2
ON c1.bank_account_no =  c2.bank_account_no
where c1.carD_no NOT IN (SELECT src_card_no FROM cards WHERE src_card_no IS NOT NULL)
and c1.ch_id is null) curr_card
where curr_card.card_srno = c.card_srno;


-----------------------------------------------



select primary_card_no,card_no,src_card_no from cards
where primary_card_no not like '%T%'
or card_no not like '%T%'
or src_card_no not like '%T%';

-------------------------------------------------
