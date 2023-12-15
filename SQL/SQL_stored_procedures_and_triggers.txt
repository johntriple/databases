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