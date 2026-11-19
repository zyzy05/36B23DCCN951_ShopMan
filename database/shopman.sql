CREATE DATABASE IF NOT EXISTS ShopMan CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ShopMan;
-- WARNING: this setup script drops and recreates the application tables and sample data.
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS InvoiceDetails;
DROP TABLE IF EXISTS Invoice;
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS SearchHistory;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS Supplier;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS User;
SET FOREIGN_KEY_CHECKS=1;

CREATE TABLE Customer(customer_id INT AUTO_INCREMENT PRIMARY KEY,customer_code VARCHAR(20) NOT NULL UNIQUE,full_name VARCHAR(120) NOT NULL,phone VARCHAR(20),email VARCHAR(150),address VARCHAR(255),created_at DATETIME DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE User(user_id INT AUTO_INCREMENT PRIMARY KEY,username VARCHAR(60) NOT NULL UNIQUE,password_hash CHAR(64) NOT NULL,role ENUM('MANAGER','SALES','CUSTOMER') NOT NULL,customer_id INT NULL,status ENUM('HOẠT ĐỘNG','ĐÃ KHÓA') NOT NULL DEFAULT 'HOẠT ĐỘNG',CONSTRAINT fk_user_customer FOREIGN KEY(customer_id) REFERENCES Customer(customer_id));
CREATE TABLE Category(category_id INT AUTO_INCREMENT PRIMARY KEY,category_name VARCHAR(100) NOT NULL UNIQUE);
CREATE TABLE Supplier(supplier_id INT AUTO_INCREMENT PRIMARY KEY,supplier_code VARCHAR(20) UNIQUE,supplier_name VARCHAR(150) NOT NULL,phone VARCHAR(20),email VARCHAR(150),address VARCHAR(255));
CREATE TABLE Product(product_id INT AUTO_INCREMENT PRIMARY KEY,product_code VARCHAR(30) NOT NULL UNIQUE,product_name VARCHAR(180) NOT NULL,brand VARCHAR(100),unit VARCHAR(30) NOT NULL,unit_price DECIMAL(14,2) NOT NULL DEFAULT 0,stock_quantity INT NOT NULL DEFAULT 0,description TEXT,category_id INT,supplier_id INT,image_url VARCHAR(500),status ENUM('ĐANG BÁN','NGỪNG BÁN') DEFAULT 'ĐANG BÁN',FOREIGN KEY(category_id) REFERENCES Category(category_id),FOREIGN KEY(supplier_id) REFERENCES Supplier(supplier_id),INDEX idx_product_name(product_name));
CREATE TABLE SearchHistory(search_history_id BIGINT AUTO_INCREMENT PRIMARY KEY,customer_id INT NOT NULL,keyword VARCHAR(180) NOT NULL,searched_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,FOREIGN KEY(customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE);
CREATE TABLE Review(review_id BIGINT AUTO_INCREMENT PRIMARY KEY,product_id INT NOT NULL,customer_id INT NOT NULL,rating TINYINT NOT NULL,comment VARCHAR(1000),created_at DATETIME DEFAULT CURRENT_TIMESTAMP,FOREIGN KEY(product_id) REFERENCES Product(product_id),FOREIGN KEY(customer_id) REFERENCES Customer(customer_id),CHECK(rating BETWEEN 1 AND 5));
CREATE TABLE Invoice(invoice_id INT AUTO_INCREMENT PRIMARY KEY,invoice_code VARCHAR(30) NOT NULL UNIQUE,customer_id INT NOT NULL,created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,status ENUM('MỚI','ĐANG ĐÓNG GÓI','ĐÃ BÀN GIAO','HOÀN THÀNH','ĐÃ HỦY') DEFAULT 'MỚI',total_amount DECIMAL(14,2) NOT NULL DEFAULT 0,shipping_fee DECIMAL(14,2) DEFAULT 0,FOREIGN KEY(customer_id) REFERENCES Customer(customer_id),INDEX idx_invoice_date(created_at));
CREATE TABLE InvoiceDetails(invoice_detail_id BIGINT AUTO_INCREMENT PRIMARY KEY,invoice_id INT NOT NULL,product_id INT NOT NULL,quantity INT NOT NULL,unit_price DECIMAL(14,2) NOT NULL,line_total DECIMAL(14,2) NOT NULL,FOREIGN KEY(invoice_id) REFERENCES Invoice(invoice_id) ON DELETE CASCADE,FOREIGN KEY(product_id) REFERENCES Product(product_id));

INSERT INTO Customer(customer_id,customer_code,full_name,phone,email,address) VALUES
(1,'KH001','Nguyễn Văn An','0901000001','an@example.com','Hà Nội'),
(2,'KH002','Trần Thị Bình','0901000002','binh@example.com','Hà Nội'),
(3,'KH003','Lê Minh Châu','0901000003','chau@example.com','Bắc Ninh'),
(4,'KH004','Phạm Minh Đức','0901000004','duc@example.com','Hải Phòng'),
(5,'KH005','Hoàng Thu Hà','0901000005','ha@example.com','Đà Nẵng'),
(6,'KH006','Vũ Quốc Huy','0901000006','huy@example.com','Cần Thơ'),
(7,'KH007','Đặng Ngọc Lan','0901000007','lan@example.com','Hà Nội'),
(8,'KH008','Bùi Thành Nam','0901000008','nam@example.com','Thành phố Hồ Chí Minh'),
(9,'KH009','Đỗ Mỹ Linh','0901000009','linh@example.com','Bắc Ninh'),
(10,'KH010','Ngô Gia Phúc','0901000010','phuc@example.com','Hải Dương');
-- Mật khẩu demo: Manager@123 và Customer@123 (SHA-256).
INSERT INTO User(username,password_hash,role,customer_id,status) VALUES
('manager',SHA2('Manager@123',256),'MANAGER',NULL,'HOẠT ĐỘNG'),
('customer',SHA2('Customer@123',256),'CUSTOMER',1,'HOẠT ĐỘNG'),
('customer2',SHA2('Customer@123',256),'CUSTOMER',2,'HOẠT ĐỘNG'),
('customer3',SHA2('Customer@123',256),'CUSTOMER',3,'HOẠT ĐỘNG'),
('customer4',SHA2('Customer@123',256),'CUSTOMER',4,'HOẠT ĐỘNG'),
('customer5',SHA2('Customer@123',256),'CUSTOMER',5,'HOẠT ĐỘNG'),
('customer6',SHA2('Customer@123',256),'CUSTOMER',6,'HOẠT ĐỘNG'),
('customer7',SHA2('Customer@123',256),'CUSTOMER',7,'HOẠT ĐỘNG'),
('customer8',SHA2('Customer@123',256),'CUSTOMER',8,'HOẠT ĐỘNG'),
('customer9',SHA2('Customer@123',256),'CUSTOMER',9,'HOẠT ĐỘNG'),
('customer10',SHA2('Customer@123',256),'CUSTOMER',10,'HOẠT ĐỘNG');
INSERT INTO Category(category_id,category_name) VALUES
(1,'Đồ uống'),(2,'Thực phẩm khô'),(3,'Sữa và chế phẩm'),(4,'Bánh kẹo'),(5,'Gia vị'),(6,'Đồ dùng gia đình');
INSERT INTO Supplier(supplier_id,supplier_code,supplier_name,phone,email,address) VALUES
(1,'NCC001','Công ty Cổ phần Sữa Việt Nam (Vinamilk)','028-3894-4860','lienhe@vinamilk.com.vn','Thành phố Hồ Chí Minh'),
(2,'NCC002','Công ty Cổ phần Acecook Việt Nam','028-3815-4064','info@acecookvietnam.com','Thành phố Hồ Chí Minh'),
(3,'NCC003','PepsiCo Việt Nam','028-3821-9437','contact@pepsico.com','Thành phố Hồ Chí Minh'),
(4,'NCC004','Công ty TNHH URC Việt Nam','0274-3755-888','info@urc.com.vn','Bình Dương'),
(5,'NCC005','Danish Speciality Foods APS','+45-3312-3400','info@danisa.com','Đan Mạch'),
(6,'NCC006','Unilever Việt Nam','028-5413-6868','contact@unilever.com','Thành phố Hồ Chí Minh'),
(7,'NCC007','Công ty Cổ phần Dầu thực vật Cái Lân','0203-3846-668','info@calofic.com.vn','Quảng Ninh'),
(8,'NCC008','New Toyo (Việt Nam) Paper Co., Ltd.','0274-3784-555','info@newtoyo.com.vn','Bình Dương'),
(9,'NCC009','Công ty Cổ phần Tập đoàn Trung Nguyên Legend','0262-3812-345','info@trungnguyenlegend.com','Đắk Lắk');

INSERT INTO Product(product_id,product_code,product_name,brand,unit,unit_price,stock_quantity,description,category_id,supplier_id,image_url,status) VALUES
(1,'SP001','Sữa tươi tiệt trùng không đường Vinamilk 1L','Vinamilk','Hộp',32000,80,'Sữa tươi tiệt trùng 100% sữa tươi, không đường, hộp 1 lít.',3,1,'https://cdn.tgdd.vn/Products/Images/2386/76888/bhx/sua-tuoi-tiet-trung-khong-duong-vinamilk-100-sua-tuoi-hop-1-lit-202403281355130532.jpg','ĐANG BÁN'),
(2,'SP002','Mì Hảo Hảo vị gà 74g','Hảo Hảo','Gói',4500,250,'Mì ăn liền vị gà, khối lượng tịnh 74g, dùng cho một khẩu phần.',2,2,'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&w=600&q=80','ĐANG BÁN'),
(3,'SP003','Nước uống tinh khiết Aquafina 500ml','Aquafina','Chai',6000,180,'Nước uống tinh khiết Aquafina đóng chai 500ml, phù hợp mang theo khi di chuyển.',1,3,'https://taphoavietsrilanka.com/thumbs/1024x768x2/upload/product/tra-xanh-c2-huong-chanh-455ml-202006191929206306-3380.jpg','ĐANG BÁN'),
(4,'SP004','Trà xanh C2 vị chanh 455ml','C2','Chai',10000,90,'Trà xanh đóng chai vị chanh, dung tích 455ml, dùng ngay sau khi mở nắp.',1,4,'https://taphoavietsrilanka.com/thumbs/1024x768x2/upload/product/tra-xanh-c2-huong-chanh-455ml-202006191929206306-3380.jpg','ĐANG BÁN'),
(5,'SP005','Sữa chua ăn có đường Vinamilk 100g','Vinamilk','Hũ',8500,70,'Sữa chua ăn có đường, hũ 100g, bảo quản lạnh và dùng trực tiếp.',3,1,'https://product.hstatic.net/200000868055/product/sua_chua_an_co_duong_vinamilk_100g_c1bab6cda1ef49cdbccddce1d162473a_grande.png','ĐANG BÁN'),
(6,'SP006','Bánh quy bơ Danisa 375g','Danisa','Hộp',78000,45,'Bánh quy bơ truyền thống Danisa, hộp thiếc 375g, thích hợp dùng cùng trà hoặc làm quà.',4,5,'https://asiangroceryuk.co.uk/cdn/shop/products/danisa-traditional-butter-cookies-mayora-375g-4327783.jpg?v=1766449271&width=1500','ĐANG BÁN'),
(7,'SP007','Nước rửa chén Sunlight chanh 750ml','Sunlight','Chai',26000,55,'Nước rửa chén hương chanh 750ml, công thức làm sạch dầu mỡ cho bát đĩa.',6,6,'https://thaothanh.com.vn/stogare/files/products/sunlight-dishwashing-liquid.jpg','ĐANG BÁN'),
(8,'SP008','Dầu ăn Neptune 1L','Neptune','Chai',63800,60,'Dầu ăn Neptune 1 lít, dùng để chiên, xào và chế biến món ăn gia đình.',5,7,'https://img.websosanh.vn/v2/users/root_product/images/dau-an-neptune-1l/LBmG0eCzdhfg.jpg','ĐANG BÁN'),
(9,'SP009','Khăn giấy hộp Pulppy 3 lớp 100 tờ','Pulppy','Hộp',18000,95,'Khăn giấy hộp 3 lớp, 100 tờ, không mùi, phù hợp sử dụng hằng ngày.',6,8,'https://images.unsplash.com/photo-1583947215259-38e31be8751f?auto=format&w=600&q=80','ĐANG BÁN'),
(10,'SP010','Cà phê hòa tan G7 3 trong 1 hộp 320g','G7','Hộp',89000,40,'Cà phê hòa tan G7 3 trong 1 gồm cà phê, đường và bột kem, hộp 20 gói tổng khối lượng 320g.',1,9,'https://looddl.ch/8444-Shopping/instant-coffee-g7-3-in-1-20pcs-320g.jpg','ĐANG BÁN');

-- Mỗi nhóm danh mục có ít nhất 6 mặt hàng để phần chi tiết luôn có 5 sản phẩm liên quan.
INSERT INTO Product(product_id,product_code,product_name,brand,unit,unit_price,stock_quantity,description,category_id,supplier_id,image_url,status) VALUES
(11,'SP011','Mì Hảo Hảo tôm chua cay 75g','Hảo Hảo','Gói',4500,300,'Mì ăn liền vị tôm chua cay, khối lượng tịnh 75g.',2,2,'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&w=600&q=80','ĐANG BÁN'),
(12,'SP012','Mì Omachi bò hầm 80g','Omachi','Gói',9000,120,'Mì khoai tây Omachi vị bò hầm, gói 80g.',2,2,'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?auto=format&w=600&q=80','ĐANG BÁN'),
(13,'SP013','Phở gà ăn liền Vifon 65g','Vifon','Gói',7000,100,'Phở ăn liền vị gà, gói 65g.',2,2,'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&w=600&q=80','ĐANG BÁN'),
(14,'SP014','Miến Phú Hương thịt bằm 58g','Phú Hương','Gói',8500,85,'Miến ăn liền vị thịt bằm, gói 58g.',2,2,'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&w=600&q=80','ĐANG BÁN'),
(15,'SP015','Bún bò Huế ăn liền 75g','Vifon','Gói',8000,90,'Bún bò Huế ăn liền, gói 75g.',2,2,'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&w=600&q=80','ĐANG BÁN'),
(16,'SP016','Sữa tươi có đường TH true MILK 1L','TH true MILK','Hộp',36000,65,'Sữa tươi tiệt trùng có đường, hộp 1 lít.',3,1,'https://cdn.tgdd.vn/Products/Images/2386/76888/bhx/sua-tuoi-tiet-trung-khong-duong-vinamilk-100-sua-tuoi-hop-1-lit-202403281355130532.jpg','ĐANG BÁN'),
(17,'SP017','Sữa đặc Ông Thọ đỏ 380g','Ông Thọ','Lon',28000,75,'Sữa đặc có đường, lon 380g.',3,1,'https://product.hstatic.net/200000868055/product/sua_chua_an_co_duong_vinamilk_100g_c1bab6cda1ef49cdbccddce1d162473a_grande.png','ĐANG BÁN'),
(18,'SP018','Sữa chua uống Probi 65ml','Vinamilk','Lốc',32000,50,'Lốc 5 chai sữa chua uống men sống, mỗi chai 65ml.',3,1,'https://product.hstatic.net/200000868055/product/sua_chua_an_co_duong_vinamilk_100g_c1bab6cda1ef49cdbccddce1d162473a_grande.png','ĐANG BÁN'),
(19,'SP019','Phô mai Con Bò Cười 120g','Con Bò Cười','Hộp',25000,40,'Phô mai tam giác, hộp 8 miếng tổng khối lượng 120g.',3,1,'https://images.unsplash.com/photo-1543255006-d6395b6f1171?auto=format&w=600&q=80','ĐANG BÁN'),
(20,'SP020','Bánh quy Oreo vị vani 133g','Oreo','Gói',18000,110,'Bánh quy cacao kẹp kem vani, gói 133g.',4,4,'https://images.unsplash.com/photo-1555507036-ab1f4038808a?auto=format&w=600&q=80','ĐANG BÁN'),
(21,'SP021','Bánh xốp KitKat 2 ngón 17g','KitKat','Thanh',9000,140,'Bánh xốp phủ sô-cô-la, thanh 17g.',4,4,'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&w=600&q=80','ĐANG BÁN'),
(22,'SP022','Bánh Choco-Pie Orion 6 chiếc','Choco-Pie','Hộp',42000,60,'Bánh phủ sô-cô-la nhân marshmallow, hộp 6 chiếc.',4,4,'https://asiangroceryuk.co.uk/cdn/shop/products/danisa-traditional-butter-cookies-mayora-375g-4327783.jpg?v=1766449271&width=1500','ĐANG BÁN'),
(23,'SP023','Kẹo dẻo trái cây Playmore 90g','Playmore','Gói',15000,80,'Kẹo dẻo nhiều hương vị trái cây, gói 90g.',4,4,'https://images.unsplash.com/photo-1543255006-d6395b6f1171?auto=format&w=600&q=80','ĐANG BÁN'),
(24,'SP024','Bánh quy mặn AFC vị rau 200g','AFC','Hộp',26000,70,'Bánh quy mặn vị rau, hộp 200g.',4,4,'https://images.unsplash.com/photo-1555507036-ab1f4038808a?auto=format&w=600&q=80','ĐANG BÁN'),
(25,'SP025','Nước mắm Nam Ngư 500ml','Nam Ngư','Chai',22000,65,'Nước mắm dùng làm gia vị và nước chấm, chai 500ml.',5,7,'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&w=600&q=80','ĐANG BÁN'),
(26,'SP026','Nước tương Maggi đậm đặc 500ml','Maggi','Chai',18000,55,'Nước tương đậm đặc, chai 500ml.',5,6,'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?auto=format&w=600&q=80','ĐANG BÁN'),
(27,'SP027','Muối i-ốt Bạc Liêu 500g','Bạc Liêu','Gói',6000,100,'Muối i-ốt tinh sấy, gói 500g.',5,7,'https://images.unsplash.com/photo-1543255006-d6395b6f1171?auto=format&w=600&q=80','ĐANG BÁN'),
(28,'SP028','Hạt nêm Knorr nấm hương 400g','Knorr','Gói',42000,50,'Hạt nêm vị nấm hương, gói 400g.',5,6,'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&w=600&q=80','ĐANG BÁN'),
(29,'SP029','Tương ớt Chinsu 250g','Chinsu','Chai',12000,90,'Tương ớt cay dịu, chai 250g.',5,6,'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&w=600&q=80','ĐANG BÁN'),
(30,'SP030','Nước giặt OMO Matic túi 2.4kg','OMO','Túi',125000,30,'Nước giặt dùng cho máy giặt cửa trên, túi 2.4kg.',6,6,'https://images.unsplash.com/photo-1556228720-195a672e8a03?auto=format&w=600&q=80','ĐANG BÁN'),
(31,'SP031','Giấy vệ sinh cuộn lớn Pulppy 10 cuộn','Pulppy','Lốc',68000,35,'Lốc 10 cuộn giấy vệ sinh 3 lớp.',6,8,'https://images.unsplash.com/photo-1583947215259-38e31be8751f?auto=format&w=600&q=80','ĐANG BÁN'),
(32,'SP032','Miếng rửa chén Scotch-Brite 3 miếng','Scotch-Brite','Lốc',24000,45,'Lốc 3 miếng rửa chén có lớp chà sạch.',6,6,'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?auto=format&w=600&q=80','ĐANG BÁN'),
(33,'SP033','Túi rác tự hủy sinh học 3 cuộn','Green Eco','Lốc',28000,50,'Túi rác tự hủy sinh học, lốc 3 cuộn.',6,8,'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?auto=format&w=600&q=80','ĐANG BÁN'),
(34,'SP034','Nước ngọt Coca-Cola lon 320ml','Coca-Cola','Lon',10500,150,'Nước giải khát có ga, lon 320ml.',1,3,'https://taphoavietsrilanka.com/thumbs/1024x768x2/upload/product/tra-xanh-c2-huong-chanh-455ml-202006191929206306-3380.jpg','ĐANG BÁN'),
(35,'SP035','Trà Oolong Tea+ Plus 455ml','Tea+','Chai',10000,100,'Trà ô long đóng chai, dung tích 455ml.',1,4,'https://taphoavietsrilanka.com/thumbs/1024x768x2/upload/product/tra-xanh-c2-huong-chanh-455ml-202006191929206306-3380.jpg','ĐANG BÁN'),
(36,'SP036','Nước tăng lực Number 1 330ml','Number 1','Lon',11000,90,'Nước tăng lực đóng lon 330ml.',1,3,'https://images.unsplash.com/photo-1543255006-d6395b6f1171?auto=format&w=600&q=80','ĐANG BÁN');

-- Sáu lượt tìm kiếm gần đây cho mỗi tài khoản khách hàng mẫu.
INSERT INTO SearchHistory(customer_id,keyword,searched_at)
SELECT c.customer_id,
       ELT(s.search_order + 1,'mì','sữa','nước','bánh','gia vị','Vinamilk'),
       DATE_SUB(NOW(), INTERVAL (c.customer_id * 6 + s.search_order) HOUR)
FROM Customer c
CROSS JOIN (
    SELECT 0 AS search_order UNION ALL SELECT 1 UNION ALL SELECT 2
    UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
) s;

-- Hai đánh giá cho mọi sản phẩm; ba đánh giá cho ba sản phẩm ban đầu để kiểm tra sắp xếp.
INSERT INTO Review(product_id,customer_id,rating,comment,created_at)
SELECT p.product_id,
       MOD(p.product_id + r.review_order,10) + 1,
       MOD(p.product_id + r.review_order,5) + 1,
       ELT(MOD(p.product_id + r.review_order,4) + 1,
           'Chất lượng tốt, đúng như mô tả.',
           'Đóng gói cẩn thận, giao hàng nhanh.',
           'Sản phẩm phù hợp, sẽ tiếp tục mua.',
           'Giá hợp lý, trải nghiệm sử dụng ổn.'),
       DATE_SUB(NOW(), INTERVAL (p.product_id * 3 + r.review_order) DAY)
FROM Product p
CROSS JOIN (SELECT 0 AS review_order UNION ALL SELECT 1 UNION ALL SELECT 2) r
WHERE r.review_order < CASE WHEN p.product_id <= 3 THEN 3 ELSE 2 END;

-- Hóa đơn mẫu bao phủ nhiều khách hàng, ngày lập và trạng thái để kiểm tra thống kê/lịch sử/chi tiết.
INSERT INTO Invoice(invoice_id,invoice_code,customer_id,created_at,status,total_amount,shipping_fee) VALUES
(1,'HD001',1,NOW()-INTERVAL 10 DAY,'HOÀN THÀNH',81000,0),
(2,'HD002',1,NOW()-INTERVAL 4 DAY,'HOÀN THÀNH',59000,0),
(3,'HD003',2,NOW()-INTERVAL 2 DAY,'ĐÃ BÀN GIAO',68000,0),
(4,'HD004',3,NOW()-INTERVAL 1 DAY,'HOÀN THÀNH',33000,0),
(5,'HD005',1,NOW()-INTERVAL 1 DAY,'ĐANG ĐÓNG GÓI',96000,0),
(6,'HD006',2,NOW()-INTERVAL 2 DAY,'MỚI',28500,0),
(7,'HD007',3,NOW()-INTERVAL 3 DAY,'ĐÃ BÀN GIAO',50000,0),
(8,'HD008',4,NOW()-INTERVAL 4 DAY,'HOÀN THÀNH',96000,0),
(9,'HD009',5,NOW()-INTERVAL 5 DAY,'ĐÃ HỦY',177000,0),
(10,'HD010',6,NOW()-INTERVAL 6 DAY,'HOÀN THÀNH',171600,0),
(11,'HD011',7,NOW()-INTERVAL 7 DAY,'HOÀN THÀNH',122000,0),
(12,'HD012',8,NOW()-INTERVAL 8 DAY,'ĐÃ BÀN GIAO',111000,0),
(13,'HD013',9,NOW()-INTERVAL 9 DAY,'HOÀN THÀNH',90000,0),
(14,'HD014',10,NOW()-INTERVAL 10 DAY,'ĐANG ĐÓNG GÓI',40000,0),
(15,'HD015',4,NOW()-INTERVAL 15 DAY,'HOÀN THÀNH',82000,0),
(16,'HD016',5,NOW()-INTERVAL 20 DAY,'ĐÃ HỦY',59500,0);

INSERT INTO InvoiceDetails(invoice_id,product_id,quantity,unit_price,line_total) VALUES
(1,1,2,32000,64000),(1,5,2,8500,17000),
(2,2,10,4500,45000),(2,13,2,7000,14000),
(3,1,1,32000,32000),(3,16,1,36000,36000),
(4,3,2,6000,12000),(4,34,2,10500,21000),
(5,11,2,4500,9000),(5,12,1,9000,9000),(5,6,1,78000,78000),
(6,2,5,4500,22500),(6,3,1,6000,6000),
(7,4,4,10000,40000),(7,35,1,10000,10000),
(8,6,1,78000,78000),(8,20,1,18000,18000),
(9,7,2,26000,52000),(9,30,1,125000,125000),
(10,8,2,63800,127600),(10,25,2,22000,44000),
(11,9,3,18000,54000),(11,31,1,68000,68000),
(12,10,1,89000,89000),(12,36,2,11000,22000),
(13,16,2,36000,72000),(13,17,1,18000,18000),
(14,25,1,22000,22000),(14,26,1,18000,18000),
(15,19,2,25000,50000),(15,18,1,32000,32000),
(16,34,3,10500,31500),(16,33,1,28000,28000);

