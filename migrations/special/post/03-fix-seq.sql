/*
Fixes sequences that are not in sync with the max value of the column.
From https://stackoverflow.com/a/62076666
*/

with sequences as (
  select *
  from (
    select table_schema,
           table_name,
           column_name,
           replace(replace(replace(column_default, '::regclass)', ''), '''', ''), 'nextval(', 'public.') as col_sequence
    from information_schema.columns
    where table_schema not in ('pg_catalog', 'information_schema') and column_default ILIKE 'nextval(%'
  ) t
  where col_sequence is not null
), maxvals as (
  select table_schema, table_name, column_name, col_sequence,
          (xpath('/row/max/text()',
             query_to_xml(format('select max(%I) from %I.%I', column_name, table_schema, table_name), true, true, ''))
          )[1]::text::bigint as max_val
  from sequences
) 
select table_schema, 
       table_name, 
       column_name, 
       col_sequence,
       coalesce(max_val, 0) as max_val,
       setval(col_sequence, coalesce(max_val, 1)) --<< this will change the sequence
from maxvals where max_val > 0;