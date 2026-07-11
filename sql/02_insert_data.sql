-- ============================================================
-- File: 02_insert_data.sql
-- Project: Sales Data Analytics
-- Description: DML - Insert sample data into all tables
-- Author: Dinesh
-- Date: 2024
-- ============================================================

USE superstore_db;

-- ============================================================
-- Disable FK checks during bulk load
-- ============================================================
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- INSERT: categories
-- ============================================================
INSERT IGNORE INTO categories (category_name, description) VALUES
    ('Furniture',        'Office and home furniture including chairs, tables, bookcases'),
    ('Office Supplies',  'Everyday office items including binders, paper, art supplies'),
    ('Technology',       'Electronics, phones, accessories, and machines');

-- ============================================================
-- INSERT: sub_categories
-- ============================================================
INSERT IGNORE INTO sub_categories (sub_category_name, category_id) VALUES
    -- Furniture (category_id = 1)
    ('Bookcases',   1),
    ('Chairs',      1),
    ('Furnishings', 1),
    ('Tables',      1),
    -- Office Supplies (category_id = 2)
    ('Appliances',  2),
    ('Art',         2),
    ('Binders',     2),
    ('Envelopes',   2),
    ('Fasteners',   2),
    ('Labels',      2),
    ('Paper',       2),
    ('Storage',     2),
    -- Technology (category_id = 3)
    ('Accessories', 3),
    ('Copiers',     3),
    ('Machines',    3),
    ('Phones',      3);

-- ============================================================
-- INSERT: customers (sample)
-- ============================================================
INSERT IGNORE INTO customers (customer_id, customer_name, segment, city, state, postal_code, region) VALUES
    ('CG-12520', 'Claire Gute',         'Consumer',   'Henderson',      'Kentucky',         '42420', 'South'),
    ('DV-13045', 'Darrin Van Huff',     'Corporate',  'Los Angeles',    'California',       '90036', 'West'),
    ('SO-20335', 'Sean O''Donnell',     'Consumer',   'Fort Lauderdale','Florida',          '33311', 'South'),
    ('BH-11710', 'Brosina Hoffman',     'Consumer',   'Los Angeles',    'California',       '90032', 'West'),
    ('HP-14815', 'Harold Pawlan',       'Home Office','Fort Worth',     'Texas',            '76106', 'Central'),
    ('PK-19075', 'Pete Kriz',           'Consumer',   'Madison',        'Wisconsin',        '53711', 'Central'),
    ('ZD-21925', 'Zuschuss Donatelli',  'Consumer',   'San Francisco',  'California',       '94109', 'West'),
    ('KB-16585', 'Karl Braun',          'Consumer',   'Philadelphia',   'Pennsylvania',     '19140', 'East'),
    ('JO-15145', 'Joseph Owens',        'Consumer',   'Atlanta',        'Georgia',          '30328', 'South'),
    ('JS-15865', 'Jim Sink',            'Corporate',  'Syracuse',       'New York',         '13209', 'East'),
    ('EB-13705', 'Eugene Barcus',       'Consumer',   'New York City',  'New York',         '10024', 'East'),
    ('RO-11695', 'Ruben Olson',         'Consumer',   'San Francisco',  'California',       '94122', 'West'),
    ('AA-10480', 'Andrew Allen',        'Consumer',   'Concord',        'North Carolina',   '28027', 'South'),
    ('IM-15070', 'Irene Maddox',        'Consumer',   'Seattle',        'Washington',       '98103', 'West'),
    ('SP-20770', 'Sanjit Patel',        'Corporate',  'Chicago',        'Illinois',         '60601', 'Central'),
    ('DB-13480', 'Dorothy Barnes',      'Consumer',   'Houston',        'Texas',            '77040', 'Central'),
    ('MR-18310', 'Maria Romero',        'Consumer',   'Philadelphia',   'Pennsylvania',     '19134', 'East'),
    ('AH-10690', 'Ann Hicks',           'Consumer',   'Houston',        'Texas',            '77070', 'Central'),
    ('GW-14605', 'Gary Wilkerson',      'Corporate',  'Burlington',     'Vermont',          '5401',  'East'),
    ('MA-17470', 'Mike Avery',          'Consumer',   'San Diego',      'California',       '92117', 'West');

-- ============================================================
-- INSERT: products (sample)
-- ============================================================
INSERT IGNORE INTO products (product_id, product_name, sub_category_id) VALUES
    ('FUR-BO-10001798', 'Bush Somerset Collection Bookcase',                    1),
    ('FUR-CH-10000454', 'Hon Deluxe Fabric Upholstered Stacking Chairs',        2),
    ('FUR-TA-10000577', 'Bretford CR4500 Series Slim Rectangular Table',        4),
    ('FUR-FU-10001487', 'Eldon Expressions Wood and Plastic Desk Accessories',  3),
    ('OFF-LA-10000240', 'Self-Adhesive Address Labels for Typewriters',          10),
    ('OFF-ST-10000760', 'Eldon Fold N Roll Cart System',                        12),
    ('OFF-AR-10002833', 'Newell 322',                                            6),
    ('TEC-PH-10002275', 'Mitel 5320 IP Phone VoIP phone',                       16),
    ('OFF-BI-10003910', 'DXL Angle-View Binders with Locking Rings by Samsill', 7),
    ('OFF-AP-10002892', 'Belkin F5C206VTEL 6 Outlet Surge',                     5),
    ('TEC-PH-10001949', 'Plantronics CS510 Wireless Headset System',            16),
    ('TEC-AC-10001715', 'Apple AirPods Pro',                                    13),
    ('TEC-PH-10004977', 'Samsung Galaxy S21',                                   16),
    ('TEC-MA-10004125', 'Canon imageCLASS MF743Cdw',                            15),
    ('TEC-AC-10002867', 'Logitech MX Master 3S Mouse',                          13),
    ('OFF-PA-10001795', 'Avery 507',                                             11),
    ('TEC-PH-10001952', 'Apple iPhone 14',                                      16),
    ('TEC-MA-10002931', 'Lexmark 20R1285 X6650 Wireless All-in-One Printer',    15),
    ('FUR-CH-10002774', 'Global Leather High-Back Manager Chair',                2),
    ('FUR-BO-10002933', 'Sauder Inglewood Library Bookcases',                   1);

-- ============================================================
-- INSERT: orders (sample)
-- ============================================================
INSERT IGNORE INTO orders (order_id, order_date, ship_date, ship_mode, customer_id) VALUES
    ('CA-2016-152156', '2016-11-08', '2016-11-11', 'Second Class',   'CG-12520'),
    ('CA-2016-138688', '2016-06-12', '2016-06-16', 'Second Class',   'DV-13045'),
    ('US-2015-108966', '2015-10-11', '2015-10-18', 'Standard Class', 'SO-20335'),
    ('CA-2014-115812', '2014-06-09', '2014-06-14', 'Standard Class', 'BH-11710'),
    ('US-2016-118983', '2016-11-22', '2016-11-26', 'Standard Class', 'HP-14815'),
    ('CA-2015-105893', '2015-11-11', '2015-11-18', 'Second Class',   'PK-19075'),
    ('CA-2015-167164', '2015-05-13', '2015-05-15', 'First Class',    'ZD-21925'),
    ('CA-2016-143336', '2016-08-27', '2016-09-01', 'Second Class',   'KB-16585'),
    ('CA-2014-135545', '2014-09-28', '2014-10-03', 'Second Class',   'JO-15145'),
    ('CA-2014-157650', '2014-12-05', '2014-12-10', 'Standard Class', 'JS-15865'),
    ('CA-2014-105136', '2014-05-07', '2014-05-12', 'Standard Class', 'EB-13705'),
    ('CA-2015-118568', '2015-08-09', '2015-08-13', 'First Class',    'RO-11695'),
    ('CA-2017-114412', '2017-04-15', '2017-04-20', 'Standard Class', 'AA-10480'),
    ('CA-2017-161389', '2017-12-05', '2017-12-10', 'Standard Class', 'IM-15070'),
    ('CA-2014-166709', '2014-09-07', '2014-09-12', 'Second Class',   'SP-20770'),
    ('CA-2016-121755', '2016-09-18', '2016-09-22', 'Standard Class', 'DB-13480'),
    ('CA-2015-110756', '2015-03-11', '2015-03-13', 'First Class',    'MR-18310'),
    ('CA-2014-117590', '2014-10-28', '2014-10-30', 'First Class',    'AH-10690'),
    ('CA-2014-100811', '2014-12-01', '2014-12-06', 'Standard Class', 'GW-14605'),
    ('CA-2014-108966', '2014-11-09', '2014-11-11', 'First Class',    'MA-17470');

-- ============================================================
-- INSERT: order_items (sample)
-- ============================================================
INSERT IGNORE INTO order_items (order_id, product_id, sales, quantity, discount, profit) VALUES
    ('CA-2016-152156', 'FUR-BO-10001798', 261.96,  2, 0.00,  41.9136),
    ('CA-2016-152156', 'FUR-CH-10000454', 731.94,  3, 0.00,  219.582),
    ('CA-2016-138688', 'OFF-LA-10000240', 14.62,   2, 0.00,  6.8714),
    ('US-2015-108966', 'FUR-TA-10000577', 957.58,  5, 0.45, -383.031),
    ('US-2015-108966', 'OFF-ST-10000760', 22.37,   2, 0.20,  2.5164),
    ('CA-2014-115812', 'FUR-FU-10001487', 48.86,   7, 0.00,  14.1694),
    ('CA-2014-115812', 'OFF-AR-10002833', 7.28,    4, 0.00,  1.9656),
    ('CA-2014-115812', 'TEC-PH-10002275', 907.15,  6, 0.20,  90.7152),
    ('CA-2014-115812', 'OFF-BI-10003910', 18.50,   3, 0.20,  5.7825),
    ('CA-2014-115812', 'OFF-AP-10002892', 114.90,  5, 0.00,  34.47),
    ('CA-2014-105136', 'TEC-PH-10001949', 1299.38, 4, 0.20,  62.13),
    ('CA-2015-118568', 'TEC-PH-10001949', 1035.46, 5, 0.10,  130.185),
    ('CA-2014-117590', 'FUR-TA-10000577', 2647.62, 3, 0.40, -882.54),
    ('CA-2014-100811', 'FUR-CH-10002774', 750.58,  3, 0.20,  101.394),
    ('CA-2014-100811', 'FUR-BO-10001798', 284.35,  4, 0.20,  28.1502),
    ('CA-2014-166709', 'FUR-CH-10002774', 1000.77, 4, 0.20,  135.192),
    ('CA-2016-121755', 'FUR-TA-10000577', 1138.19, 5, 0.35, -370.385),
    ('CA-2015-110756', 'TEC-AC-10001715', 249.99,  2, 0.00,  62.4975),
    ('CA-2014-108966', 'TEC-AC-10002867', 89.99,   2, 0.00,  26.997),
    ('CA-2016-143336', 'TEC-AC-10002867', 58.32,   3, 0.20,  17.496);

-- ============================================================
-- Re-enable FK checks
-- ============================================================
SET FOREIGN_KEY_CHECKS = 1;

-- Verify row counts
SELECT 'customers'    AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'products',      COUNT(*) FROM products
UNION ALL
SELECT 'orders',        COUNT(*) FROM orders
UNION ALL
SELECT 'order_items',   COUNT(*) FROM order_items;
