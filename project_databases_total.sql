drop database if exists press;
create database press;
use press;

DROP TABLE IF EXISTS article_submission;
DROP TABLE IF EXISTS pictures;
DROP TABLE IF EXISTS keywords;
DROP TABLE IF EXISTS article;
DROP TABLE IF EXISTS telephones;
DROP TABLE IF EXISTS publisher;
DROP TABLE IF EXISTS administrative;
DROP TABLE IF EXISTS journalist;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS credentials;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS paper;
DROP TABLE IF EXISTS newspaper;

DROP TABLE IF EXISTS newspaper;
CREATE TABLE IF NOT EXISTS newspaper(
name VARCHAR(50) PRIMARY KEY NOT NULL,
owner VARCHAR(30) DEFAULT 'unknown' NOT NULL,
frequency ENUM('daily','weekly','monthly') NOT NULL
);

INSERT INTO newspaper VALUES('ΒΗΜΑ','Ekdotopoulos','weekly');
INSERT INTO newspaper VALUES('ΝΕΑ','ΛΑΜΠΡΑΚΗΣ','daily');
INSERT INTO newspaper VALUES('ΠΑΡΑΠΟΛΙΤΙΚΑ','ΚΟΥΡΤΑΚΗΣ','monthly');

DROP TABLE IF EXISTS paper;
CREATE TABLE IF NOT EXISTS paper(
paper_id INT(4)  NOT NULL ,
newspaper_name VARCHAR(50) NOT NULL,
number_of_pages INT(4) NOT NULL DEFAULT 30 ,
remaining_pages INT(4) NOT NULL DEFAULT 30 ,
publish_date DATE ,
published INT(4) NOT NULL,
returned INT(4)  NOT NULL DEFAULT 0,
PRIMARY KEY(paper_id,newspaper_name),
FOREIGN KEY(newspaper_name) references newspaper(name) ON UPDATE CASCADE ON DELETE CASCADE
);


INSERT INTO paper VALUES(1,'ΒΗΜΑ', DEFAULT, default, null, 5000, default);
INSERT INTO paper VALUES(3,'ΝΕΑ', default, default, null, 4000, default);
INSERT INTO paper VALUES(5,'ΠΑΡΑΠΟΛΙΤΙΚΑ', default, default ,null, 2500, default);

DROP TABLE IF EXISTS employee;
CREATE TABLE IF NOT EXISTS employee(
email VARCHAR(30) NOT NULL ,
name VARCHAR(30) NOT NULL,
lastname VARCHAR(30) NOT NULL,
salary DECIMAL(10,2) ,
hire_date DATE NOT NULL,
newspaper_name VARCHAR(50) NOT NULL,
PRIMARY KEY (email),
FOREIGN KEY (newspaper_name) REFERENCES newspaper(name) ON DELETE CASCADE
);

INSERT INTO employee VALUES('takis@ceid.gr', 'takis', 'mpal', 5000, '1970-01-01', 'ΒΗΜΑ');
INSERT INTO employee VALUES('john@gmail.com','john','trip',650,'2019-10-10','ΒΗΜΑ');
INSERT INTO employee VALUES('jamesbond@mi6.com', 'James', 'Bond', 650, '1970-01-01', 'ΒΗΜΑ');
INSERT INTO employee VALUES('doctor@who.com', 'John', 'Smith', 650, '1970-01-01', 'ΒΗΜΑ');
INSERT INTO employee VALUES('bean@mail.co.uk', 'Mister', 'Bean', 5000, '1970-01-01', 'ΒΗΜΑ');
INSERT INTO employee VALUES('publisher@tovima.gr', 'Vagelis', 'Ekdotopoulos', 10000, '1970-01-01', 'ΒΗΜΑ');
INSERT INTO employee VALUES('root@db_project.ceid', 'Super', 'User', null, '1970-01-01', 'ΒΗΜΑ');

DROP TABLE IF EXISTS credentials;
CREATE TABLE IF NOT EXISTS credentials(
email VARCHAR(30) NOT NULL,
username VARCHAR(30) NOT NULL,
password VARCHAR(30) NOT NULL,
duty enum('superuser','journalist','chief','administrative','publisher'),
PRIMARY KEY(email),
FOREIGN KEY(email) REFERENCES employee(email) ON DELETE CASCADE
);

INSERT INTO credentials VALUES('takis@ceid.gr','takis_administrative','1234','administrative');
INSERT INTO credentials VALUES('jamesbond@mi6.com','jamesbond_journalist','007','journalist');
INSERT INTO credentials VALUES('doctor@who.com','doctorwho_chief','who','chief');
INSERT INTO credentials VALUES('bean@mail.co.uk','mrbean_administrative','1234','administrative');
INSERT INTO credentials VALUES('publisher@tovima.gr','publisher','iamceo','publisher');
INSERT INTO credentials VALUES('john@gmail.com','john_journalist','trip','journalist');
INSERT INTO credentials VALUES('root@db_project.ceid','root','toor','superuser');

DROP TABLE IF EXISTS category;
CREATE TABLE IF NOT EXISTS category(
id INT NOT NULL AUTO_INCREMENT,
name VARCHAR(30) NOT NULL unique,
description VARCHAR(30),
parent_id INT ,
PRIMARY KEY(id),
FOREIGN KEY(parent_id) REFERENCES category(id) ON DELETE CASCADE
);

INSERT INTO category VALUES(1,'Politics','National & Foreign Political Articles',NULL);
INSERT INTO category VALUES(2,'Economics','All about economics',NULL);
INSERT INTO category VALUES(3,'Society','How about our society',NULL);
INSERT INTO category VALUES(4,'Science and Technology','News from science and technology',NULL);
INSERT INTO category VALUES(5,'Culture','About Culture',NULL);
INSERT INTO category VALUES(6,'National Politics','Our National Politics',1);
INSERT INTO category VALUES(7,'Foreign Politics','Foreign Issues',1);
INSERT INTO category VALUES(8,'European Union','About EU',7);
INSERT INTO category VALUES(9,'Brexit','Britain in EU',8);

DROP TABLE IF EXISTS journalist;
CREATE TABLE IF NOT EXISTS journalist(
email VARCHAR(30) NOT NULL,
experience INT(4) NOT NULL,
bio VARCHAR(100) NOT NULL,
is_chief BOOLEAN NOT NULL,
category_id INT ,
PRIMARY KEY(email),
FOREIGN KEY(email)references employee(email) ON DELETE CASCADE,
FOREIGN KEY(category_id) references category(id)
);

INSERT INTO journalist VALUES('john@gmail.com',5,'δημοσιογράφος',FALSE,1);
INSERT INTO journalist VALUES('jamesbond@mi6.com',40,'δημοσιογράφος',FALSE,1);
INSERT INTO journalist VALUES('doctor@who.com',10,'I am the doctor! Allons-y!',TRUE,1);

DROP TABLE IF EXISTS administrative;
CREATE TABLE IF NOT EXISTS administrative (
email VARCHAR(30) NOT NULL,
duties ENUM ('secretary','logistics'),
city VARCHAR(30) NOT NULL,
street VARCHAR(30) NOT NULL,
num INT NOT NULL,
PRIMARY KEY(email),
FOREIGN KEY (email) REFERENCES employee(email)
);

INSERT INTO administrative VALUES('takis@ceid.gr','logistics','Athens','Stadiou',1);
INSERT INTO administrative VALUES('bean@mail.co.uk','secretary','Athens','Stadiou',1);

DROP TABLE IF EXISTS publisher;
CREATE TABLE IF NOT EXISTS publisher(
email VARCHAR(30) NOT NULL,
newspaper_name VARCHAR(50) NOT NULL,
chief_ID VARCHAR(30) NOT NULL,
PRIMARY KEY (email),
FOREIGN KEY (newspaper_name) references newspaper(name),
FOREIGN KEY(chief_ID) references employee(email)
);

INSERT INTO publisher VALUES('publisher@tovima.gr','ΒΗΜΑ','doctor@who.com');

DROP TABLE IF EXISTS telephones;
CREATE TABLE IF NOT EXISTS telephones(
email VARCHAR(30) NOT NULL,
telephone VARCHAR(10) NOT NULL,
PRIMARY KEY(email,telephone),
FOREIGN KEY(email) references administrative(email)
);

INSERT INTO telephones VALUES('takis@ceid.gr','12345');
INSERT INTO telephones VALUES('bean@mail.co.uk','54321');

DROP TABLE IF EXISTS article;
CREATE TABLE IF NOT EXISTS article(
path VARCHAR(100) NOT NULL,
num_of_pages INT NOT NULL,
comment VARCHAR(100),
accept_date DATE,
summary VARCHAR(150) NOT NULL,
_order INT ,
status ENUM('accepted','rejected','to be revised') ,
title VARCHAR(30) NOT NULL,
start_page INT,
paper_num INT(4),
category_id INT NOT NULL,
PRIMARY KEY(path),
FOREIGN KEY(category_id) references category(id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY(paper_num) references paper(paper_id) ON UPDATE CASCADE ON DELETE CASCADE
);

insert into article values ('C:\\Users\\Journalist\\Articles\\Submitted\\test1.docx',1,null,null,'test',null, 'to be revised','Entitled Article',null,1,1);

DROP TABLE IF EXISTS keywords;
CREATE TABLE IF NOT EXISTS keywords(
path VARCHAR(100) NOT NULL,
word VARCHAR(20) NOT NULL,
PRIMARY KEY(path,word),
FOREIGN KEY (path) references article(path) ON UPDATE CASCADE ON DELETE CASCADE
);

insert into keywords value('C:\\Users\\Journalist\\Articles\\Submitted\\test1.docx','key');

DROP TABLE IF EXISTS pictures;
CREATE TABLE IF NOT EXISTS pictures(
path VARCHAR(100) NOT NULL,
picture_path VARCHAR(100),
PRIMARY KEY(path,picture_path),
FOREIGN KEY(path) references article(path) ON UPDATE CASCADE ON DELETE CASCADE
);

insert into pictures values('C:\\Users\\Journalist\\Articles\\Submitted\\test1.docx','C:\\Users\\Journalist\\Articles\\Submitted\\photo.png');

DROP TABLE IF EXISTS article_submission;
CREATE TABLE IF NOT EXISTS article_submission(
email VARCHAR(30) NOT NULL,
path VARCHAR(100) NOT NULL,
submission_Date DATE,
PRIMARY KEY(email,path),
FOREIGN KEY(email) references journalist(email) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY(path) references article(path) ON UPDATE CASCADE ON DELETE CASCADE
);

insert into article_submission values('jamesbond@mi6.com','C:\\Users\\Journalist\\Articles\\Submitted\\test1.docx','2020-01-01');

drop procedure if exists evaluatesalary;
delimiter $
create procedure evaluatesalary( _email varchar(30))
begin
	declare exp int;
    declare start_date date;
    select experience , hire_date
    into exp , start_date
    from employee inner join journalist on journalist.email = employee.email
    where journalist.email = _email;
    
    select 650 + 650 * 0.005 * exp * timestampdiff(month,start_date,curdate());
end $
delimiter ;

DROP TRIGGER IF EXISTS journalistsalary;
DELIMITER $
CREATE TRIGGER journalistsalary AFTER INSERT ON journalist
FOR EACH ROW 
BEGIN
update employee
	set employee.salary=650
	where new.email=employee.email;
END$
DELIMITER ;

DROP TRIGGER IF EXISTS administrativesalary;
DELIMITER $
CREATE TRIGGER administrativesalary BEFORE INSERT ON administrative
FOR EACH ROW 
BEGIN
update employee
	set employee.salary=5000
	where new.email=employee.email;
END$
DELIMITER ;

DROP TRIGGER IF EXISTS publishersalary;
DELIMITER $
CREATE TRIGGER publishersalary BEFORE INSERT ON publisher
FOR EACH ROW 
BEGIN
update employee
	set employee.salary=10000
	where new.email=employee.email;
END$
DELIMITER ;

DROP TRIGGER IF EXISTS chiefarticle;
DELIMITER $
CREATE TRIGGER chiefarticle after INSERT ON article_submission
FOR EACH ROW
BEGIN
DECLARE temp_is_chief BOOLEAN;

SELECT distinct is_chief 
INTO temp_is_chief 
FROM journalist INNER JOIN article_submission ON journalist.email=article_submission.email
WHERE NEW.email=journalist.email;

IF ( temp_is_chief = 1) THEN
	update article
	set article.status = 'accepted'
	where article.path = new.path;
END IF;
END $
DELIMITER ;

DROP TRIGGER IF EXISTS paperoverflow;
DELIMITER $
CREATE TRIGGER paperoverflow BEFORE update ON article
FOR EACH ROW 
BEGIN
declare temp_rem_pages INT(4);
declare _count int;

select paper.remaining_pages
into temp_rem_pages
from paper
where paper.paper_id = new.paper_num;

if( temp_rem_pages - new.num_of_pages >= 0 ) THEN
	UPDATE paper
	SET paper.remaining_pages = temp_rem_pages - new.num_of_pages
	WHERE paper.paper_id = new.paper_num;
    
ELSE 
	SIGNAL SQLSTATE VALUE'45000'
	SET MESSAGE_TEXT='not enough room in the paper';
END IF;
END$
DELIMITER ;

drop procedure if exists popinfo;
DELIMITER $
CREATE PROCEDURE popinfo(popid INT)
BEGIN
SELECT article.title,journalist.email,article_submition.sumbition_Date,article.start_page,article.num_of_pages
from article inner join article_submition on article.path=article_submition.path inner join journalist on article_submition.email=journalist.email
where article.path IN(SELECT article.path from paper inner join article on paper.paper_id=article.paper_num where popid=paper.paper_id)
ORDER BY article.start_page DESC;
SELECT remaining_pages into @remaining_pages FROM paper where popid=paper_id;
IF(@remaining_pages>0)THEN
SELECT CONCAT("There are ",@remaining_pages," pages left in the paper"),article.title,journalist.email,article_submition.sumbition_Date,article.start_page,article.num_of_pages
from article inner join article_submition on article.path=article_submition.path inner join journalist on article_submition.email=journalist.email
where article.path IN(SELECT article.path from paper inner join article on paper.paper_id=article.paper_num where popid=paper.paper_id)
ORDER BY article.start_page DESC;
END IF;
end$
delimiter ;