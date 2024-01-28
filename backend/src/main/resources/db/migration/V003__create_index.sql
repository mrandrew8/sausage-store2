create index product_id_index on product(id);
create index product_price_index on product(price);
create index orders_id_index on orders(id);
create index orders_date_created_index on orders(date_created);
create index order_product_quantity_index on order_product(quantity);
create index order_product_product_id_index on order_product(product_id);
create index order_product_order_id_index on order_product(order_id);