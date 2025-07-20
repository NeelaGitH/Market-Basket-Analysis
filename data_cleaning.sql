create table trans_staging
like transactions;

insert into trans_staging
select * from transactions;

delete from trans_staging
where NumberOfItemPurchased < 1;

select * from trans_staging
where UserId < 1;
-- keeping the values with -1 userId as this might mean guest activity

select distinct TransactionId
from trans_staging
where TransactionId < 1;

delete from trans_staging
where CostPerltem = -15266;

select distinct CostPerltem from trans_staging
where CostPerltem < 1;
-- This might refer to free samples so keeping them

select distinct * from trans_staging
where ItemCode< 1;

delete from trans_staging
where ItemCode < 1;

alter table trans_staging
modify column ItemDescription varchar(100)
character set utf8mb4
collate utf8mb4_bin;

select distinct ItemDescription from trans_staging
where ItemDescription = lower(ItemDescription);

insert into errordata
select distinct ItemDescription from trans_staging
where ItemDescription = lower(ItemDescription);
-- desc in all lowercase are errors here

alter table trans_staging
modify column ItemDescription varchar(100)
collate utf8mb4_general_ci;

alter table errordata
modify column val varchar(100)
collate utf8mb4_general_ci;

-- we have already made a table errordata before while experimenting that contains all error data. Using that.
DELETE FROM trans_staging
WHERE ITEMDESCRIPTION IN (SELECT * FROM errordata);

select distinct ItemDescription
from trans_staging
order by ItemDescription;

-- will check for duplicate (transactionId - ItemDescription) pairs

select *, row_number() over (partition by TransactionID, ItemCode order by UserId, CostPerltem, NumberOfItemPurchased DESC) as rn
from trans_staging;

create table trans_staging_2
like trans_staging;

alter table trans_staging_2
add column row_num int;

insert into trans_staging_2
select *, row_number() over (partition by TransactionID, ItemCode order by UserId, CostPerltem, NumberOfItemPurchased DESC) as rn
from trans_staging;

delete from trans_staging_2
where row_num > 1;

alter table trans_staging_2
drop column row_num;

select * from trans_staging_2;

select * from trans_staging_2
where ItemDescription is null;

-- lets fix the date column now

select count(*) from trans_staging_2;

SELECT invoicedate, str_to_date(INVOICEDATE, '%d-%m-%Y %H:%i')
from retail_staging;

select distinct transactiontime from trans_staging_2;

select REPLACE(TransactionTime, ' IST', '')
from trans_staging_2;

update trans_staging_2
set transactionTime = REPLACE(TransactionTime, ' IST', '');

SELECT 
  STR_TO_DATE(transactionTime, '%a %b %d %H:%i:%s %Y') AS formatted_date
FROM 
  trans_staging_2;
  
update trans_staging_2
set transactionTime = STR_TO_DATE(transactionTime, '%a %b %d %H:%i:%s %Y');

alter table trans_staging_2
modify column TransactionTime datetime;

-- cleaned data phew!!







