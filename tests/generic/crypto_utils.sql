{% test assert_vali_btc_address(model, column_name) %}

    select *
    from {{ model }}
    where NOT (
    
    {{ column_name }} LIKE '1%' OR 
    {{ column_name }} LIKE '3%' OR 
    {{ column_name }} LIKE 'bc1%'
    )

{% endtest %}

-----we have to find the pattern in the data  here address starts with 1 , 3 or bc1 r bc1p, if return results it means tests failed , it returns everything , we are saying not