## Sql Scripts

$013_api_attributevalueint_push = "
INSERT INTO
    racktables_django.api_attributevalueint (parentobject_id, attributemap_id, value)
    SELECT
         parentobject.id
        ,attributemap.attrmap_id
        ,uint_value
    FROM
        racktables.AttributeValue
        LEFT JOIN racktables_django.api_object as parentobject on object_id = parentobject.oldid
        LEFT JOIN (
            SELECT 
                 objecttype.oldid as objecttype_oldid
                ,attribute.oldid as attr_oldid
                ,attributemap.id as attrmap_id
                ,attribute.attribute_type as attribute_type
            FROM
                racktables_django.api_attributemap as attributemap
                LEFT JOIN racktables_django.api_objecttype as objecttype on objecttype_id = objecttype.id
                LEFT JOIN racktables_django.api_attribute as attribute on attribute_id = attribute.id 
        ) AS attributemap ON attr_oldid = attr_id AND object_tid = objecttype_oldid
    WHERE
        concat(object_id,'-',attr_id) not in (
            SELECT concat(object.oldid,'-',attribute.oldid)
            FROM racktables_django.api_attributevalueint as AVI
                LEFT JOIN racktables_django.api_attributemap AS attrmap ON attributemap_id = attrmap.id
                LEFT JOIN racktables_django.api_attribute AS attribute ON attrmap.attribute_id = attribute.id
                LEFT JOIN racktables_django.api_object AS object ON AVI.parentobject_id = object.id
        )
        AND attribute_type = 2
"

## Hashtable

@{
    "013_api_attributevalueint" = @{
        "type" = "basic"
        "push" = $013_api_attributevalueint_push
    }
}