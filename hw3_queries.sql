use graph;

select * from node;
select * from edge;
select * from node_props;

-- What is the sum of all book prices?
-- select sum(num_value) from node_props
-- where propkey = 'price'; 
-- select * from edge join node_props;

-- Who does spencer know?
-- select string_value from node_props 
-- join edge on node_id = out_node
-- where type = 'knows'
-- and in_node = (select node_id from node_props 
-- 	where propkey = 'name'
-- 	and string_value = 'Spencer')

-- What books did Spencer buy?
-- select np_title.string_value as title, np_price.num_value as price from edge e
-- join node_props np on e.in_node = np.node_id 
-- join node_props np_title on e.out_node = np_title.node_id
-- join node_props np_price on e.out_node = np_price.node_id 
-- where np.propkey = 'name' and np.string_value = 'Spencer' and type = 'bought' 
-- and np_title.propkey = 'title' and np_price.propkey = 'price';

-- select * from node_props np
-- join edge e on node_id = in_node
-- where type = 'knows'

-- select e1.in_node as p1, e2.in_node as p2
-- FROM edge e1
-- JOIN edge e2 ON e1.in_node = e2.out_node AND e1.out_node = e2.in_node
-- where 

-- select * from edge
-- where in_node = out_node

-- Who knows each other? 
-- select
--   t1.p1 as person1,
--   t1.p2 as person2
-- from (select np1.string_value as p1, np2.string_value as p2
-- from edge e1
-- join edge e2 on e1.in_node = e2.out_node and e1.out_node = e2.in_node
-- join node_props np1 on e1.in_node = np1.node_id
-- join node_props np2 on e1.out_node = np2.node_id
-- where e2.type = 'knows') t1
-- left join (select np1.string_value as p1, np2.string_value as p2
-- from edge e1
-- join edge e2 on e1.in_node = e2.out_node and e1.out_node = e2.in_node
-- join node_props np1 on e1.in_node = np1.node_id
-- join node_props np2 on e1.out_node = np2.node_id
-- where e2.type = 'knows') t2
--   on t1.p2 = t2.p1
--   and t1.p1 = t2.p2
-- where t2.p1 is null
-- or t1.p1 < t2.p1;

-- What books were purchased by people who Spencer knows? Exclude books that Spencer already owns
-- select distinct string_value
-- FROM edge e1
-- JOIN edge e2 ON e1.in_node = e2.out_node 
-- JOIN node_props np ON np.node_id = e1.out_node
-- LEFT JOIN edge e3 ON e3.in_node = e1.out_node AND e3.out_node = (
--     SELECT node_id
--     FROM node_props
--     WHERE propkey = 'name' AND string_value = 'Spencer')
-- WHERE e1.type = 'bought' and string_value IS NOT NULL
-- EXCEPT
-- select string_value from node_props 
-- join edge on node_id = out_node
-- where type = 'bought' and string_value IS NOT NULL
-- and in_node = (select node_id from node_props 
-- 	where propkey = 'name'
-- 	and string_value = 'Spencer');
