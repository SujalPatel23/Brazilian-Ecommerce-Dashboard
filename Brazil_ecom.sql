select *
from orders
limit 10;


select *
from customers
limit 10;


select *
from items
limit 10;


select *
from payments
limit 10;


select *
from products
limit 10;


select *
from reviews
limit 10;


select *
from category_translation
limit 10;




select
count(*) as total_orders
from orders;




select
order_status,
count(*) as total_orders
from orders
group by order_status
order by total_orders desc;




select
count(distinct customer_id) as total_customers
from customers;




select
count(distinct product_id) as total_products
from products;




select
count(distinct seller_id) as total_sellers
from items;




select
round(sum(price + freight_value)::numeric, 2) as total_revenue
from items;




select
round(avg(price + freight_value)::numeric, 2) as avg_order_item_value
from items;




select
payment_type,
count(*) as total_payments
from payments
group by payment_type
order by total_payments desc;




select
payment_type,
round(sum(payment_value)::numeric, 2) as total_payment_value
from payments
group by payment_type
order by total_payment_value desc;




select
customer_state,
count(*) as total_customers
from customers
group by customer_state
order by total_customers desc;




select
customer_city,
count(*) as total_customers
from customers
group by customer_city
order by total_customers desc
limit 10;




select
product_category_name,
count(*) as total_products
from products
group by product_category_name
order by total_products desc;




select
review_score,
count(*) as total_reviews
from reviews
group by review_score
order by review_score;




select
o.order_status,
count(*) as total_orders
from orders o
group by o.order_status
order by total_orders desc;




select
date_trunc('month', order_purchase_timestamp::timestamp)::date as order_month,
count(*) as total_orders
from orders
group by date_trunc('month', order_purchase_timestamp::timestamp)::date
order by order_month;




select
date_trunc('month', o.order_purchase_timestamp::timestamp)::date as order_month,
round(sum(i.price + i.freight_value)::numeric, 2) as revenue
from orders o
join items i
on o.order_id = i.order_id
group by date_trunc('month', o.order_purchase_timestamp::timestamp)::date
order by order_month;




select
c.customer_state,
round(sum(i.price + i.freight_value)::numeric, 2) as revenue
from orders o
join customers c
on o.customer_id = c.customer_id
join items i
on o.order_id = i.order_id
group by c.customer_state
order by revenue desc;




select
c.customer_city,
round(sum(i.price + i.freight_value)::numeric, 2) as revenue
from orders o
join customers c
on o.customer_id = c.customer_id
join items i
on o.order_id = i.order_id
group by c.customer_city
order by revenue desc
limit 10;




select
coalesce(ct.product_category_name_english, p.product_category_name) as category,
round(sum(i.price + i.freight_value)::numeric, 2) as revenue
from items i
join products p
on i.product_id = p.product_id
left join category_translation ct
on p.product_category_name = ct.product_category_name
group by coalesce(ct.product_category_name_english, p.product_category_name)
order by revenue desc
limit 10;




select
coalesce(ct.product_category_name_english, p.product_category_name) as category,
count(distinct i.order_id) as total_orders
from items i
join products p
on i.product_id = p.product_id
left join category_translation ct
on p.product_category_name = ct.product_category_name
group by coalesce(ct.product_category_name_english, p.product_category_name)
order by total_orders desc
limit 10;




select
o.order_status,
round(sum(i.price + i.freight_value)::numeric, 2) as revenue
from orders o
join items i
on o.order_id = i.order_id
group by o.order_status
order by revenue desc;




select
r.review_score,
round(sum(i.price + i.freight_value)::numeric, 2) as revenue
from orders o
join items i
on o.order_id = i.order_id
join reviews r
on o.order_id = r.order_id
group by r.review_score
order by r.review_score;




select
r.review_score,
round(avg(i.price + i.freight_value)::numeric, 2) as avg_order_value
from orders o
join items i
on o.order_id = i.order_id
join reviews r
on o.order_id = r.order_id
group by r.review_score
order by r.review_score;




select
payment_type,
round(avg(payment_value)::numeric, 2) as avg_payment_value
from payments
group by payment_type
order by avg_payment_value desc;




select
payment_installments,
count(*) as total_orders,
round(sum(payment_value)::numeric, 2) as total_value
from payments
group by payment_installments
order by total_value desc;




select
o.order_id,
o.order_status,
o.order_purchase_timestamp,
o.order_delivered_customer_date,
o.order_estimated_delivery_date
from orders o
where o.order_status = 'delivered'
limit 10;




select
order_id,
order_purchase_timestamp::timestamp as purchase_date,
order_delivered_customer_date::timestamp as delivered_date,
order_estimated_delivery_date::timestamp as estimated_date,
(order_delivered_customer_date::timestamp::date - order_purchase_timestamp::timestamp::date) as delivery_days
from orders
where order_status = 'delivered'
and order_delivered_customer_date is not null
limit 20;




select
round(avg(order_delivered_customer_date::timestamp::date - order_purchase_timestamp::timestamp::date)::numeric, 2) as avg_delivery_days
from orders
where order_status = 'delivered'
and order_delivered_customer_date is not null;




select
c.customer_state,
round(avg(o.order_delivered_customer_date::timestamp::date - o.order_purchase_timestamp::timestamp::date)::numeric, 2) as avg_delivery_days
from orders o
join customers c
on o.customer_id = c.customer_id
where o.order_status = 'delivered'
and o.order_delivered_customer_date is not null
group by c.customer_state
order by avg_delivery_days desc;




select
c.customer_state,
count(*) as total_delivered_orders,
sum(
case
when o.order_delivered_customer_date::timestamp::date > o.order_estimated_delivery_date::timestamp::date
then 1 else 0
end
) as delayed_orders
from orders o
join customers c
on o.customer_id = c.customer_id
where o.order_status = 'delivered'
and o.order_delivered_customer_date is not null
and o.order_estimated_delivery_date is not null
group by c.customer_state
order by delayed_orders desc;




select
c.customer_state,
count(*) as total_delivered_orders,
sum(
case
when o.order_delivered_customer_date::timestamp::date > o.order_estimated_delivery_date::timestamp::date
then 1 else 0
end
) as delayed_orders,
round(
sum(
case
when o.order_delivered_customer_date::timestamp::date > o.order_estimated_delivery_date::timestamp::date
then 1 else 0
end
) * 100.0 / count(*), 2
) as delay_percentage
from orders o
join customers c
on o.customer_id = c.customer_id
where o.order_status = 'delivered'
and o.order_delivered_customer_date is not null
and o.order_estimated_delivery_date is not null
group by c.customer_state
order by delay_percentage desc;




select
case
when order_delivered_customer_date::timestamp::date > order_estimated_delivery_date::timestamp::date
then 'delayed'
else 'on time'
end as delivery_status,
count(*) as total_orders
from orders
where order_status = 'delivered'
and order_delivered_customer_date is not null
and order_estimated_delivery_date is not null
group by
case
when order_delivered_customer_date::timestamp::date > order_estimated_delivery_date::timestamp::date
then 'delayed'
else 'on time'
end;




select
case
when order_delivered_customer_date::timestamp::date > order_estimated_delivery_date::timestamp::date
then 'delayed'
else 'on time'
end as delivery_status,
round(avg(order_delivered_customer_date::timestamp::date - order_purchase_timestamp::timestamp::date)::numeric, 2) as avg_delivery_days
from orders
where order_status = 'delivered'
and order_delivered_customer_date is not null
and order_estimated_delivery_date is not null
group by
case
when order_delivered_customer_date::timestamp::date > order_estimated_delivery_date::timestamp::date
then 'delayed'
else 'on time'
end;




select
coalesce(ct.product_category_name_english, p.product_category_name) as category,
round(avg(o.order_delivered_customer_date::timestamp::date - o.order_purchase_timestamp::timestamp::date)::numeric, 2) as avg_delivery_days
from orders o
join items i
on o.order_id = i.order_id
join products p
on i.product_id = p.product_id
left join category_translation ct
on p.product_category_name = ct.product_category_name
where o.order_status = 'delivered'
and o.order_delivered_customer_date is not null
group by coalesce(ct.product_category_name_english, p.product_category_name)
order by avg_delivery_days desc
limit 10;




select
coalesce(ct.product_category_name_english, p.product_category_name) as category,
round(avg(r.review_score)::numeric, 2) as avg_review_score,
count(*) as total_reviews
from orders o
join items i
on o.order_id = i.order_id
join products p
on i.product_id = p.product_id
left join category_translation ct
on p.product_category_name = ct.product_category_name
join reviews r
on o.order_id = r.order_id
group by coalesce(ct.product_category_name_english, p.product_category_name)
order by avg_review_score desc;




select
coalesce(ct.product_category_name_english, p.product_category_name) as category,
round(avg(r.review_score)::numeric, 2) as avg_review_score,
count(*) as total_reviews
from orders o
join items i
on o.order_id = i.order_id
join products p
on i.product_id = p.product_id
left join category_translation ct
on p.product_category_name = ct.product_category_name
join reviews r
on o.order_id = r.order_id
group by coalesce(ct.product_category_name_english, p.product_category_name)
having count(*) > 100
order by avg_review_score desc;




select
c.customer_state,
round(avg(r.review_score)::numeric, 2) as avg_review_score,
count(*) as total_reviews
from orders o
join customers c
on o.customer_id = c.customer_id
join reviews r
on o.order_id = r.order_id
group by c.customer_state
order by avg_review_score desc;




select
date_trunc('month', o.order_purchase_timestamp::timestamp)::date as order_month,
round(sum(i.price + i.freight_value)::numeric, 2) as revenue,
count(distinct o.order_id) as total_orders
from orders o
join items i
on o.order_id = i.order_id
group by date_trunc('month', o.order_purchase_timestamp::timestamp)::date
order by order_month;




select
date_trunc('month', o.order_purchase_timestamp::timestamp)::date as order_month,
round(sum(i.price + i.freight_value)::numeric, 2) as revenue,
lag(round(sum(i.price + i.freight_value)::numeric, 2)) over(order by date_trunc('month', o.order_purchase_timestamp::timestamp)::date) as previous_month_revenue
from orders o
join items i
on o.order_id = i.order_id
group by date_trunc('month', o.order_purchase_timestamp::timestamp)::date
order by order_month;




with monthly_revenue as (
select
date_trunc('month', o.order_purchase_timestamp::timestamp)::date as order_month,
sum(i.price + i.freight_value) as revenue
from orders o
join items i
on o.order_id = i.order_id
group by date_trunc('month', o.order_purchase_timestamp::timestamp)::date
)

select
order_month,
round(revenue::numeric, 2) as revenue,
round(lag(revenue) over(order by order_month)::numeric, 2) as previous_month_revenue,
round(
((revenue - lag(revenue) over(order by order_month)) * 100.0
/ nullif(lag(revenue) over(order by order_month), 0))::numeric, 2
) as revenue_growth_percentage
from monthly_revenue
order by order_month;




with category_revenue as (
select
coalesce(ct.product_category_name_english, p.product_category_name) as category,
sum(i.price + i.freight_value) as revenue
from items i
join products p
on i.product_id = p.product_id
left join category_translation ct
on p.product_category_name = ct.product_category_name
group by coalesce(ct.product_category_name_english, p.product_category_name)
)

select
category,
round(revenue::numeric, 2) as revenue,
rank() over(order by revenue desc) as revenue_rank
from category_revenue;




with state_revenue as (
select
c.customer_state,
sum(i.price + i.freight_value) as revenue
from orders o
join customers c
on o.customer_id = c.customer_id
join items i
on o.order_id = i.order_id
group by c.customer_state
)

select
customer_state,
round(revenue::numeric, 2) as revenue,
rank() over(order by revenue desc) as state_rank
from state_revenue
order by state_rank;




with city_revenue as (
select
c.customer_state,
c.customer_city,
sum(i.price + i.freight_value) as revenue
from orders o
join customers c
on o.customer_id = c.customer_id
join items i
on o.order_id = i.order_id
group by c.customer_state, c.customer_city
)

select
customer_state,
customer_city,
round(revenue::numeric, 2) as revenue,
rank() over(partition by customer_state order by revenue desc) as city_rank
from city_revenue
order by customer_state, city_rank;




with city_revenue as (
select
c.customer_state,
c.customer_city,
sum(i.price + i.freight_value) as revenue
from orders o
join customers c
on o.customer_id = c.customer_id
join items i
on o.order_id = i.order_id
group by c.customer_state, c.customer_city
)

select *
from (
select
customer_state,
customer_city,
round(revenue::numeric, 2) as revenue,
rank() over(partition by customer_state order by revenue desc) as city_rank
from city_revenue
) x
where city_rank <= 3
order by customer_state, city_rank;




with customer_orders as (
select
c.customer_unique_id,
count(distinct o.order_id) as total_orders,
sum(i.price + i.freight_value) as revenue
from orders o
join customers c
on o.customer_id = c.customer_id
join items i
on o.order_id = i.order_id
group by c.customer_unique_id
)

select
customer_unique_id,
total_orders,
round(revenue::numeric, 2) as revenue
from customer_orders
order by revenue desc
limit 10;




select
case
when order_delivered_customer_date is null then 'missing delivery date'
else 'available delivery date'
end as delivery_date_status,
count(*) as total_orders
from orders
group by
case
when order_delivered_customer_date is null then 'missing delivery date'
else 'available delivery date'
end;




select
case
when product_category_name is null then 'missing category'
else 'available category'
end as category_status,
count(*) as total_products
from products
group by
case
when product_category_name is null then 'missing category'
else 'available category'
end;




select
order_id,
count(*) as total_items
from items
group by order_id
having count(*) > 1
order by total_items desc
limit 10;




select
o.order_id,
count(i.product_id) as total_items,
round(sum(i.price + i.freight_value)::numeric, 2) as order_value
from orders o
join items i
on o.order_id = i.order_id
group by o.order_id
order by order_value desc
limit 10;




select
seller_id,
round(sum(price + freight_value)::numeric, 2) as revenue,
count(distinct order_id) as total_orders
from items
group by seller_id
order by revenue desc
limit 10;




select
p.product_category_name,
count(distinct i.seller_id) as total_sellers
from items i
join products p
on i.product_id = p.product_id
group by p.product_category_name
order by total_sellers desc;




select
coalesce(ct.product_category_name_english, p.product_category_name) as category,
round(sum(i.freight_value)::numeric, 2) as total_freight,
round(avg(i.freight_value)::numeric, 2) as avg_freight
from items i
join products p
on i.product_id = p.product_id
left join category_translation ct
on p.product_category_name = ct.product_category_name
group by coalesce(ct.product_category_name_english, p.product_category_name)
order by avg_freight desc;




select
c.customer_state,
round(sum(i.freight_value)::numeric, 2) as total_freight,
round(avg(i.freight_value)::numeric, 2) as avg_freight
from orders o
join customers c
on o.customer_id = c.customer_id
join items i
on o.order_id = i.order_id
group by c.customer_state
order by avg_freight desc;




drop view if exists v_order_sales;

create view v_order_sales as
select
o.order_id,
o.order_purchase_timestamp,
o.order_status,
(o.order_delivered_customer_date::timestamp::date - o.order_purchase_timestamp::timestamp::date) as delivery_days,
case
when o.order_delivered_customer_date::timestamp::date > o.order_estimated_delivery_date::timestamp::date
then 'delayed'
else 'on time'
end as delay_status,
c.customer_state,
i.product_id,
i.price,
i.freight_value,
i.price + i.freight_value as total_value
from orders o
join customers c
on o.customer_id = c.customer_id
join items i
on o.order_id = i.order_id;




select *
from v_order_sales
limit 20;




select
order_status,
count(*) as total_orders,
round(sum(total_value)::numeric, 2) as revenue
from v_order_sales
group by order_status
order by revenue desc;




select
customer_state,
round(sum(total_value)::numeric, 2) as revenue
from v_order_sales
group by customer_state
order by revenue desc;




select
delay_status,
count(*) as total_orders,
round(avg(delivery_days)::numeric, 2) as avg_delivery_days
from v_order_sales
where order_status = 'delivered'
group by delay_status;




drop view if exists v_master;

create view v_master as
select
o.order_id,
o.customer_id,
o.order_status,
o.order_purchase_timestamp::timestamp::date as order_date,
date_trunc('month', o.order_purchase_timestamp::timestamp)::date as order_month,

i.product_id,
i.seller_id,
i.price,
i.freight_value,
i.price + i.freight_value as order_value,

p.payment_value,
p.payment_type,
p.payment_installments,

pr.product_category_name,
coalesce(ct.product_category_name_english, pr.product_category_name) as category,

c.customer_state,
c.customer_city,

r.review_score,

o.order_delivered_customer_date::timestamp::date as delivered_date,
o.order_estimated_delivery_date::timestamp::date as estimated_delivery_date,

case
when o.order_delivered_customer_date is not null
then o.order_delivered_customer_date::timestamp::date - o.order_purchase_timestamp::timestamp::date
else null
end as delivery_days,

case
when o.order_delivered_customer_date::timestamp::date > o.order_estimated_delivery_date::timestamp::date
then 'delayed'
when o.order_delivered_customer_date is null
then 'not delivered'
else 'on time'
end as delivery_status,

case
when o.order_delivered_customer_date::timestamp::date > o.order_estimated_delivery_date::timestamp::date
then o.order_delivered_customer_date::timestamp::date - o.order_estimated_delivery_date::timestamp::date
else 0
end as delivery_delay_days

from orders o
join customers c
on o.customer_id = c.customer_id

join items i
on o.order_id = i.order_id

left join payments p
on o.order_id = p.order_id

left join products pr
on i.product_id = pr.product_id

left join category_translation ct
on pr.product_category_name = ct.product_category_name

left join reviews r
on o.order_id = r.order_id;




select *
from v_master
limit 20;




select
count(*) as total_rows
from v_master;




select
round(sum(order_value)::numeric, 2) as total_revenue
from v_master;




select
count(distinct order_id) as total_orders,
count(distinct customer_id) as total_customers,
count(distinct product_id) as total_products,
count(distinct seller_id) as total_sellers
from v_master;




select
order_month,
round(sum(order_value)::numeric, 2) as revenue,
count(distinct order_id) as total_orders
from v_master
group by order_month
order by order_month;




select
category,
round(sum(order_value)::numeric, 2) as revenue,
count(distinct order_id) as total_orders
from v_master
group by category
order by revenue desc
limit 10;




select
customer_state,
round(sum(order_value)::numeric, 2) as revenue,
count(distinct order_id) as total_orders
from v_master
group by customer_state
order by revenue desc;




select
customer_city,
round(sum(order_value)::numeric, 2) as revenue,
count(distinct order_id) as total_orders
from v_master
group by customer_city
order by revenue desc
limit 10;




select
payment_type,
round(sum(payment_value)::numeric, 2) as total_payment_value,
count(*) as total_payments
from v_master
group by payment_type
order by total_payment_value desc;




select
review_score,
count(distinct order_id) as total_orders,
round(sum(order_value)::numeric, 2) as revenue
from v_master
group by review_score
order by review_score;




select
delivery_status,
count(distinct order_id) as total_orders
from v_master
group by delivery_status
order by total_orders desc;




select
customer_state,
count(distinct order_id) as total_orders,
round(avg(delivery_days)::numeric, 2) as avg_delivery_days
from v_master
where order_status = 'delivered'
group by customer_state
order by avg_delivery_days desc;




select
customer_state,
count(distinct order_id) as total_orders,
count(distinct case when delivery_status = 'delayed' then order_id end) as delayed_orders,
round(
count(distinct case when delivery_status = 'delayed' then order_id end) * 100.0
/ count(distinct order_id), 2
) as delay_percentage
from v_master
where order_status = 'delivered'
group by customer_state
order by delay_percentage desc;




select
category,
round(avg(review_score)::numeric, 2) as avg_review_score,
count(distinct order_id) as total_orders
from v_master
where review_score is not null
group by category
having count(distinct order_id) > 100
order by avg_review_score desc;




select
category,
round(avg(delivery_days)::numeric, 2) as avg_delivery_days,
count(distinct order_id) as total_orders
from v_master
where order_status = 'delivered'
group by category
having count(distinct order_id) > 100
order by avg_delivery_days desc;




with monthly as (
select
order_month,
sum(order_value) as revenue
from v_master
group by order_month
)

select
order_month,
round(revenue::numeric, 2) as revenue,
round(lag(revenue) over(order by order_month)::numeric, 2) as last_month_revenue,
round(
((revenue - lag(revenue) over(order by order_month)) * 100.0
/ nullif(lag(revenue) over(order by order_month), 0))::numeric, 2
) as revenue_growth_percentage
from monthly
order by order_month;




with category_sales as (
select
category,
sum(order_value) as revenue
from v_master
group by category
)

select
category,
round(revenue::numeric, 2) as revenue,
rank() over(order by revenue desc) as category_rank
from category_sales
order by category_rank;




with state_sales as (
select
customer_state,
sum(order_value) as revenue
from v_master
group by customer_state
)

select
customer_state,
round(revenue::numeric, 2) as revenue,
rank() over(order by revenue desc) as state_rank
from state_sales
order by state_rank;




with customer_sales as (
select
customer_id,
customer_state,
customer_city,
sum(order_value) as revenue,
count(distinct order_id) as total_orders
from v_master
group by customer_id, customer_state, customer_city
)

select
customer_id,
customer_state,
customer_city,
round(revenue::numeric, 2) as revenue,
total_orders
from customer_sales
order by revenue desc
limit 10;




select
order_status,
round(avg(delivery_days)::numeric, 2) as avg_delivery_days
from v_master
where delivery_days is not null
group by order_status
order by avg_delivery_days desc;




select
category,
round(sum(order_value)::numeric, 2) as revenue,
round(sum(freight_value)::numeric, 2) as freight_cost,
round(avg(freight_value)::numeric, 2) as avg_freight
from v_master
group by category
order by avg_freight desc;




select
customer_state,
round(sum(order_value)::numeric, 2) as revenue,
round(sum(freight_value)::numeric, 2) as freight_cost,
round(avg(freight_value)::numeric, 2) as avg_freight
from v_master
group by customer_state
order by avg_freight desc;




select
category,
count(distinct order_id) as total_orders,
round(sum(order_value)::numeric, 2) as revenue,
round(avg(review_score)::numeric, 2) as avg_review_score,
round(avg(delivery_days)::numeric, 2) as avg_delivery_days
from v_master
group by category
order by revenue desc;




select
customer_state,
count(distinct order_id) as total_orders,
round(sum(order_value)::numeric, 2) as revenue,
round(avg(review_score)::numeric, 2) as avg_review_score,
round(avg(delivery_days)::numeric, 2) as avg_delivery_days
from v_master
group by customer_state
order by revenue desc;




select
case
when order_value >= 1000 then 'high value'
when order_value >= 300 then 'medium value'
else 'low value'
end as order_value_segment,
count(*) as total_items,
round(sum(order_value)::numeric, 2) as revenue
from v_master
group by
case
when order_value >= 1000 then 'high value'
when order_value >= 300 then 'medium value'
else 'low value'
end
order by revenue desc;




select
case
when review_score >= 4 then 'good review'
when review_score = 3 then 'average review'
when review_score <= 2 then 'bad review'
else 'no review'
end as review_group,
count(distinct order_id) as total_orders,
round(sum(order_value)::numeric, 2) as revenue
from v_master
group by
case
when review_score >= 4 then 'good review'
when review_score = 3 then 'average review'
when review_score <= 2 then 'bad review'
else 'no review'
end
order by total_orders desc;




select
case
when delivery_days <= 7 then 'fast delivery'
when delivery_days <= 15 then 'normal delivery'
when delivery_days > 15 then 'slow delivery'
else 'not delivered'
end as delivery_speed,
count(distinct order_id) as total_orders,
round(avg(review_score)::numeric, 2) as avg_review_score
from v_master
group by
case
when delivery_days <= 7 then 'fast delivery'
when delivery_days <= 15 then 'normal delivery'
when delivery_days > 15 then 'slow delivery'
else 'not delivered'
end
order by total_orders desc;




select
category,
count(distinct order_id) as total_orders,
round(sum(order_value)::numeric, 2) as revenue
from v_master
where delivery_status = 'delayed'
group by category
order by revenue desc
limit 10;




select
customer_state,
count(distinct order_id) as delayed_orders,
round(sum(order_value)::numeric, 2) as delayed_order_revenue
from v_master
where delivery_status = 'delayed'
group by customer_state
order by delayed_orders desc;




select
payment_installments,
count(distinct order_id) as total_orders,
round(sum(payment_value)::numeric, 2) as total_payment_value
from v_master
group by payment_installments
order by payment_installments;




select
order_month,
payment_type,
round(sum(payment_value)::numeric, 2) as payment_value
from v_master
group by order_month, payment_type
order by order_month, payment_value desc;




select
order_month,
category,
round(sum(order_value)::numeric, 2) as revenue
from v_master
group by order_month, category
order by order_month, revenue desc;




with monthly_category as (
select
order_month,
category,
sum(order_value) as revenue
from v_master
group by order_month, category
)

select *
from (
select
order_month,
category,
round(revenue::numeric, 2) as revenue,
rank() over(partition by order_month order by revenue desc) as rank_in_month
from monthly_category
) x
where rank_in_month <= 5
order by order_month, rank_in_month;




select
seller_id,
count(distinct order_id) as total_orders,
round(sum(order_value)::numeric, 2) as revenue,
round(avg(review_score)::numeric, 2) as avg_review_score
from v_master
group by seller_id
order by revenue desc
limit 10;




select
seller_id,
round(avg(delivery_days)::numeric, 2) as avg_delivery_days,
count(distinct order_id) as total_orders
from v_master
where order_status = 'delivered'
group by seller_id
having count(distinct order_id) > 50
order by avg_delivery_days desc;




select
customer_state,
category,
round(sum(order_value)::numeric, 2) as revenue
from v_master
group by customer_state, category
order by customer_state, revenue desc;




with state_category as (
select
customer_state,
category,
sum(order_value) as revenue
from v_master
group by customer_state, category
)

select *
from (
select
customer_state,
category,
round(revenue::numeric, 2) as revenue,
rank() over(partition by customer_state order by revenue desc) as category_rank
from state_category
) x
where category_rank <= 3
order by customer_state, category_rank;




select
count(distinct order_id) as total_orders,
count(distinct case when order_status = 'delivered' then order_id end) as delivered_orders,
count(distinct case when order_status = 'canceled' then order_id end) as canceled_orders,
round(
count(distinct case when order_status = 'canceled' then order_id end) * 100.0
/ count(distinct order_id), 2
) as cancellation_percentage
from v_master;




select
customer_state,
count(distinct order_id) as total_orders,
count(distinct case when order_status = 'canceled' then order_id end) as canceled_orders,
round(
count(distinct case when order_status = 'canceled' then order_id end) * 100.0
/ count(distinct order_id), 2
) as cancellation_percentage
from v_master
group by customer_state
order by cancellation_percentage desc;




select
category,
count(distinct order_id) as total_orders,
count(distinct case when order_status = 'canceled' then order_id end) as canceled_orders,
round(
count(distinct case when order_status = 'canceled' then order_id end) * 100.0
/ count(distinct order_id), 2
) as cancellation_percentage
from v_master
group by category
having count(distinct order_id) > 100
order by cancellation_percentage desc;




select
order_month,
count(distinct order_id) as total_orders,
round(sum(order_value)::numeric, 2) as revenue,
round(avg(review_score)::numeric, 2) as avg_review_score,
round(avg(delivery_days)::numeric, 2) as avg_delivery_days
from v_master
group by order_month
order by order_month;