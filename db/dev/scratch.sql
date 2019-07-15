select * 
from giant_data.company
where name = 'Electric Purple'
;

select distinct
  c.name
  ,count(*)
from giant_data.company c
join giant_data.product p on p.company_id = c.id
GROUP BY 
  c.name
order by
  count desc
  ;