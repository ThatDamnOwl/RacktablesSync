DROP FUNCTION IF EXISTS racktables_django.075_api_taglocation_pull;

DELIMITER $$
CREATE FUNCTION racktables_django.075_api_taglocation_pull (ignored BIGINT)
RETURNS INT
NOT DETERMINISTIC
BEGIN
    DECLARE inserted INT;
    SET inserted = (SELECT count(id) FROM racktables_django.api_taglocation);
    INSERT INTO 
        racktables_django.api_taglocation (date,location_id,tag_id,user_id) 
        SELECT 
             old.date
            ,obj.id
            ,tag.id
            ,user.id
        FROM 
             racktables.TagStorage as old
             LEFT JOIN racktables_django.api_location as obj on obj.oldid = old.entity_id
             LEFT JOIN racktables_django.api_tag as tag on tag.oldid = old.tag_id
             LEFT JOIN racktables_django.api_useraccount as user on user.oldid 
        WHERE
            old.entity_realm = 'location' AND
            concat(obj.id,'-',tag.id,'-',user.id) NOT IN (SELECT concat(location_id,'-',tag_id,'-',user_id) FROM racktables_django.api_taglocation);
    SET inserted = (SELECT count(id) FROM racktables_django.api_taglocation) - inserted;
    RETURN inserted;
END;
$$ 
DELIMITER ;
