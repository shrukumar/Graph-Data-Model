use graph;

-- What is the sum of all book prices?
select sum(num_value) as sum_book_prices from node_props
where propkey = 'price'; 

-- Who does spencer know?
select string_value as name from node_props 
join edge on node_id = out_node
where type = 'knows'
and in_node = (select node_id from node_props 
	where propkey = 'name'
	and string_value = 'Spencer');

-- What books did Spencer buy?
select np_title.string_value as title, np_price.num_value as price from edge e
join node_props np on e.in_node = np.node_id 
join node_props np_title on e.out_node = np_title.node_id
join node_props np_price on e.out_node = np_price.node_id 
where np.propkey = 'name' and np.string_value = 'Spencer' and type = 'bought' 
and np_title.propkey = 'title' and np_price.propkey = 'price';

-- Who knows each other? 
select
  t1.p1 as person1,
  t1.p2 as person2
from (select np1.string_value as p1, np2.string_value as p2
from edge e1
join edge e2 on e1.in_node = e2.out_node and e1.out_node = e2.in_node
join node_props np1 on e1.in_node = np1.node_id
join node_props np2 on e1.out_node = np2.node_id
where e2.type = 'knows') t1
left join (select np1.string_value as p1, np2.string_value as p2
from edge e1
join edge e2 on e1.in_node = e2.out_node and e1.out_node = e2.in_node
join node_props np1 on e1.in_node = np1.node_id
join node_props np2 on e1.out_node = np2.node_id
where e2.type = 'knows') t2
  on t1.p2 = t2.p1
  and t1.p1 = t2.p2
where t2.p1 is null
or t1.p1 < t2.p1;

-- What books were purchased by people who Spencer knows? Exclude books that Spencer already owns
select distinct string_value as book_title
from edge e1
join edge e2 on e1.in_node = e2.out_node 
join node_props np on np.node_id = e1.out_node
left join edge e3 on e3.in_node = e1.out_node and e3.out_node = (
    select node_id
    from node_props
    where propkey = 'name' and string_value = 'Spencer')
where e1.type = 'bought' and string_value is not null
except
select string_value from node_props 
join edge on node_id = out_node
where type = 'bought' and string_value IS NOT NULL
and in_node = (select node_id from node_props 
	where propkey = 'name'
	and string_value = 'Spencer');
