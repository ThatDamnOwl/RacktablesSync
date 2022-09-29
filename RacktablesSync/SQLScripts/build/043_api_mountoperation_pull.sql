DROP FUNCTION IF EXISTS racktables_django.043_api_mountoperation_pull;

DELIMITER $$
CREATE FUNCTION racktables_django.043_api_mountoperation_pull (ignored BIGINT)
RETURNS INT
NOT DETERMINISTIC
BEGIN
    DECLARE inserted INT;
    SET inserted = (SELECT count(id) FROM racktables_django.api_mountoperation);
    INSERT INTO 
        racktables_django.api_mountoperation (oldid,changedtime,comment,changedobject_id,new_molecule_id,old_molecule_id,user_id) 
        SELECT 
               MO.id
              ,MO.ctime
              ,MO.comment
              ,apiobj.id
              ,oapimol.id
              ,napimol.id
              ,user.id
        FROM 
             racktables.MountOperation as MO
             LEFT JOIN racktables_django.api_object as apiobj on apiobj.oldid = MO.object_id
             LEFT JOIN racktables_django.api_molecule as oapimol on oapimol.oldid = MO.old_molecule_id
             LEFT JOIN racktables_django.api_molecule as napimol on napimol.oldid = MO.new_molecule_id
             LEFT JOIN racktables_django.api_useraccount as user on user.username = MO.user_name 
        WHERE 
            id NOT IN (SELECT oldid FROM racktables_django.api_mountoperation);
    SET inserted = (SELECT count(id) FROM racktables_django.api_mountoperation) - inserted;
    RETURN inserted;
END;
$$ 
DELIMITER ;
