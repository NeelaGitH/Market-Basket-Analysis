CREATE TABLE TRANSACTIONS (
UserId INT,
TransactionId INT,
TransactionTime varchar(100),
ItemCode INT,
ItemDescription VARCHAR(100),
NumberOfItemPurchased INT,
CostPerltem INT,
Country VARCHAR(100)
);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\transaction_data.csv'
INTO TABLE affinity_analysis.transactions
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from transactions;

select count(distinct TransactionId)
from transactions;

-- Creating a duplicate table

CREATE TABLE staging
like transactions;

INSERT INTO STAGING
SELECT * FROM TRANSACTIONS;

ALTER TABLE STAGING
DROP column UserId,
DROP column TransactionTime,
DROP column ItemCode,
DROP column NumberOfItemPurchased,
DROP column CostPerltem,
DROP column Country;

select * from staging;

SELECT t1.TransactionId, GROUP_CONCAT(t1.ItemDescription) AS items
FROM transactions t1
GROUP BY t1.TransactionId;


select * from staging 
order by TransactionId;

create table final
like staging;

insert final
select * from staging 
order by TransactionId;

select distinct TransactionId, ItemDescription from final;

-- Deleting Duplicates records

create table final2
like final;

alter table final2
add column row_num int;

insert into final2
select *, row_number() over (partition by TransactionID, ItemDescription Order by TransactionID) as rn
from final;


select * from final2;

delete from final2
where row_num > 1;

select * from final2;

alter table final2
drop column row_num;

ALTER TABLE FINAL RENAME TO STAGING2;

ALTER TABLE FINAL2 RENAME TO STAGING3;
-- DATA CLEANING

CREATE TABLE STAGING4
LIKE STAGING3;

INSERT INTO STAGING4
SELECT * FROM STAGING3;

SELECT distinct ITEMDESCRIPTION 
FROM STAGING4;

-- AS WE CAN SEE THE ERROR DATA IS MOSTLY IN LOWERCASE. WE NEED TO REMOVE SUCH ENTRIES

alter table staging4
modify column ItemDescription varchar(100)
character set utf8mb4
collate utf8mb4_bin;

select distinct ItemDescription from staging4
where ItemDescription = lower(ItemDescription);

delete from staging4
where ItemDescription = lower(ItemDescription);
-- deleted the obvious errors

-- let us find the common errors and delete them
select distinct ItemDescription from staging4
where ItemDescription regexp '[a-z]';

CREATE TABLE errordata(
val varchar(100)
);


INSERT INTO errordata (val)
VALUES
("Discount"),
("Manual"),
("Bank Charges"),
("Dotcom sales"),
("Dotcomgiftshop Gift Voucher £40.00"),
("Found"),
("Dotcomgiftshop Gift Voucher £50.00"),
("Dotcomgiftshop Gift Voucher £20.00"),
("Dotcomgiftshop Gift Voucher £30.00"),
("Given away"),
("Dotcom"),
("Adjustment"),
("Dotcomgiftshop Gift Voucher £10.00"),
("Dotcom set"),
("Amazon sold sets"),
("Thrown away."),
("Dotcom sold in 6's"),
("Damaged"),
("mystery! Only ever imported 1800"),
("Display"),
("Missing"),
("damages/credits from ASOS."),
("Not rcvd in 10/11/2010 delivery"),
("Thrown away-rusty"),
("incorrectly credited C550456 see 47"),
("Next Day Carriage"),
("Water damaged"),
("Printing smudges/thrown away"),
("Show Samples"),
("Damages/samples"),
("Dotcomgiftshop Gift Voucher £100.00"),
("Sold as 1 on dotcom"),
("Adjust bad debt"),
("CRUK Commission"),
("Crushed"),
("Amazon"),
("OOPS ! adjustment"),
("Found in w/hse"),
("Dagamed"),
("Lighthouse Trading zero invc incorr"),
("Incorrect stock entry."),
("Wet pallet-thrown away"),
("Had been put aside."),
("Sale error"),
("High Resolution Image"),
("Amazon Adjustment"),
("Breakages"),
("Marked as 23343"),
("Found by jackie"),
("Damages"),
("Unsaleable, destroyed."),
("Wrongly mrked had 85123a in box"),
("John Lewis");


SELECT DISTINCT ITEMDESCRIPTION FROM STAGING4
WHERE ITEMDESCRIPTION IN (SELECT * FROM errordata);

DELETE FROM STAGING4
WHERE ITEMDESCRIPTION IN (SELECT * FROM errordata);

select distinct itemdescription
from staging4;

