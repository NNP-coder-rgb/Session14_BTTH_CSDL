CREATE DATABASE RikkeiClinicDB;
USE RikkeiClinicDB;
-- PHẦN 1: KHỞI TẠO CẤU TRÚC BẢNG 

-- 1. Bảng Bệnh nhân (Patients)
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    date_of_birth DATE
);

-- 2. Bảng Nhân sự / Bác sĩ (Employees)
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    position VARCHAR(50) NOT NULL,
    salary DECIMAL(18,2) NOT NULL
);

-- 3. Bảng Khoa (Departments)
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

-- 4. Bảng Giường bệnh (Beds)
CREATE TABLE Beds (
    bed_id INT PRIMARY KEY,
    dept_id INT NOT NULL,
    patient_id INT DEFAULT NULL, -- NULL nghĩa là giường trống
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- 5. Bảng Lịch khám (Appointments)
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending', -- 'Pending', 'Completed', 'Cancelled'
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Employees(employee_id)
);

-- 6. Bảng Kho Vật tư Y tế (Inventory)
CREATE TABLE Inventory (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0
);

-- 7. Bảng Kho Thuốc (Medicines)
CREATE TABLE Medicines (
    medicine_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0
);

-- 8. Bảng Công nợ Bệnh nhân (Patient_Invoices)
CREATE TABLE Patient_Invoices (
    patient_id INT PRIMARY KEY,
    total_due DECIMAL(18,2) NOT NULL DEFAULT 0,
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- 9. Bảng Sản phẩm (Products)
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0
);

-- 10. Bảng Dịch vụ khám (Services) 
CREATE TABLE Services (
    service_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(18,2) NOT NULL
);

-- 11. Bảng Ví điện tử (Wallets) 
CREATE TABLE Wallets (
    patient_id INT PRIMARY KEY,
    balance DECIMAL(18,2) NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'Active', -- 'Active', 'Inactive'
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- 12. Bảng Lịch sử sử dụng dịch vụ (Service_Usages) 
CREATE TABLE Service_Usages (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    service_id INT NOT NULL,
    actual_price DECIMAL(18,2) DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (service_id) REFERENCES Services(service_id)
);

-- PHẦN 2: CHÈN DỮ LIỆU MẪU (TEST CASES)
-- Chèn Bệnh nhân
INSERT INTO Patients (patient_id, full_name, phone, date_of_birth) VALUES
(1, 'Nguyen Van An', '0901111222', '1990-05-15'),
(2, 'Tran Thi Binh', '0912222333', '1985-08-20'),
(3, 'Le Hoang Cuong', '0923333444', '2000-12-01');

-- Chèn Nhân sự 
INSERT INTO Employees (employee_id, full_name, position, salary) VALUES
(101, 'Dr. Hoang Minh', 'Doctor', 20000.00),
(102, 'Dr. Lan Anh', 'Doctor', 25000.00),
(103, 'Nurse Thu Ha', 'Nurse', 12000.00);

-- Chèn Khoa
INSERT INTO Departments (dept_id, dept_name) VALUES
(1, 'Khoa Ngoai'),
(2, 'Khoa Noi'),
(3, 'Khoa ICU');

-- Chèn Giường bệnh
INSERT INTO Beds (bed_id, dept_id, patient_id) VALUES
(101, 1, 1),    -- Bệnh nhân 1 đang nằm giường 101 Khoa Ngoại
(201, 2, NULL), -- Giường 201 Khoa Nội đang trống
(301, 3, 2);    -- Bệnh nhân 2 đang nằm ICU

-- Chèn Lịch khám 
INSERT INTO Appointments (appointment_id, patient_id, doctor_id, appointment_date, status) VALUES
(104, 1, 101, '2026-06-10 08:30:00', 'Pending'),
(105, 2, 102, '2026-05-01 09:00:00', 'Completed'),
(106, 3, 101, '2026-05-02 10:00:00', 'Cancelled');

-- Chèn Vật tư 
INSERT INTO Inventory (item_id, item_name, stock_quantity) VALUES
(10, 'Khau trang y te N95', 1000),
(11, 'Gang tay vo trung', 500),
(12, 'Dung dich sat khuan', 200);

-- Chèn Thuốc
INSERT INTO Medicines (medicine_id, name, price, stock) VALUES
(1, 'Amoxicillin 500mg', 15000, 100),  -- Tồn kho nhiều
(2, 'Panadol Extra', 5000, 5);         -- Tồn kho ít

-- Chèn Công nợ Bệnh nhân
INSERT INTO Patient_Invoices (patient_id, total_due) VALUES
(1, 1500000.00), -- Đã sửa: Nợ 1.5tr để test bài Giải phóng giường bệnh
(2, 0),
(3, 0);

-- Chèn Sản phẩm E-commerce 
INSERT INTO Products (name, price, stock) VALUES
('May do huyet ap Omron', 850000.00, 20),
('May do duong huyet', 450000.00, 15);

-- Chèn Dịch vụ
INSERT INTO Services (service_id, name, price) VALUES
(1, 'Sieu am o bung', 200000.00),
(2, 'Xet nghiem mau', 150000.00),
(3, 'Chup X-Quang', 250000.00);

-- Chèn Ví điện tử
INSERT INTO Wallets (patient_id, balance, status) VALUES
(1, 500000.00, 'Active'),    -- Test Case 1: Đủ tiền thanh toán
(2, 50000.00, 'Active'),     -- Test Case 3: Cháy ví (Chỉ có 50k, không đủ khám 200k)
(3, 1000000.00, 'Inactive'); -- Test Case 2: Nhiều tiền nhưng thẻ bị khóa

-- hướng làm
-- tạo 1 procedure 
-- b2: truyền các tham số cho proocedure 
-- in :Mã bệnh nhân int , Mã sản phẩm int  và Số lượng int .
-- out : mesage varchar(255)
create procedure ProcessEquipmentPurchase (
in v_patient_id int,
in v_product_id int,
in v_quantity int,
out message varchar(255)
)
-- b3: khai báo biến cần thiết 
-- tạo 3 biến :
-- số lượng sẩn phẩmt trong kho : v_stock_product int
-- số dư trong ví : v_balance_user decimal(10,2)

-- trạng thái của ví : wallet_status varchar(20) 

-- b4: viết các câu lệch select lấy dữ liệu từ các bảng và cập nhật cho các biến cục bộ 
-- lấy số lượng sp theo id của products và gán cho stock_of_product
-- lấy ra số dư của ng dùng theo id ng dùng và gán cho biến balance_of_user 
-- lấy ra trạng thái của ví theo id user vaf gán cho biến wallet_status

-- b5 : tạo giao dịch 
-- 5.1: viết câu lệch sql dùng để  trừ số lượng sp trong kho
-- viết sql để trừ tiền của user 
-- viết sql kiểm tra trạng thái ví

-- 5.2 kiểm tra ràng buộc theo yêu câuf 
-- Trừ số lượng mua tương ứng trong bảng thiết bị (Products).
-- Tính Thành tiền = Số lượng * Đơn giá.
-- Trừ Thành tiền vào số dư ví (Wallets) của bệnh nhân.
-- Nếu không có lỗi, lưu thay đổi và trả về thông báo: "Thành công: Đã xử lý đơn hàng".

-- nếu yêu cầu không thỏa mãn thì rollback và tra về thông báo 
-- nếu đúng hết thì commit và trả về thông báo thành công 
-- b6:
-- goi procedure + truyền vào các test case (4)

DELIMITER //

CREATE PROCEDURE ProcessEquipmentPurchase (
    IN v_patient_id INT,
    IN v_product_id INT,
    IN v_quantity INT,
    OUT message VARCHAR(255)
)
BEGIN
    -- B3: Khai báo biến cần thiết
    DECLARE v_stock_product INT;
    DECLARE v_product_price DECIMAL(18,2);
    DECLARE v_total_cost DECIMAL(18,2);
    DECLARE v_balance_user DECIMAL(18,2);
    DECLARE v_wallet_status VARCHAR(20);
    
    -- Biến bắt lỗi để Rollback
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SET message = 'Lỗi hệ thống: Giao dịch thất bại và đã được hoàn tác.';
    END;

    -- B4: Lấy dữ liệu và gán vào biến
    -- Lấy thông tin sản phẩm
    SELECT stock, price INTO v_stock_product, v_product_price 
    FROM Products WHERE product_id = v_product_id;
    
    -- Lấy thông tin ví của bệnh nhân
    SELECT balance, status INTO v_balance_user, v_wallet_status 
    FROM Wallets WHERE patient_id = v_patient_id;

    -- B5: Kiểm tra ràng buộc và xử lý Giao dịch
    START TRANSACTION;

    -- Kiểm tra 1: Sản phẩm có tồn tại không?
    IF v_stock_product IS NULL THEN
        SET message = 'Thất bại: Sản phẩm không tồn tại.';
        ROLLBACK;
    -- Kiểm tra 2: Ví có tồn tại không?
    ELSEIF v_wallet_status IS NULL THEN
        SET message = 'Thất bại: Bệnh nhân chưa có ví điện tử.';
        ROLLBACK;
    -- Kiểm tra 3: Trạng thái ví
    ELSEIF v_wallet_status != 'Active' THEN
        SET message = 'Thất bại: Ví điện tử đang bị khóa.';
        ROLLBACK;
    -- Kiểm tra 4: Số lượng tồn kho
    ELSEIF v_stock_product < v_quantity THEN
        SET message = 'Thất bại: Số lượng hàng trong kho không đủ.';
        ROLLBACK;
    ELSE
        -- Tính toán tổng tiền
        SET v_total_cost = v_product_price * v_quantity;

        -- Kiểm tra 5: Số dư tài khoản
        IF v_balance_user < v_total_cost THEN
            SET message = CONCAT('Thất bại: Số dư không đủ (Thiếu ', (v_total_cost - v_balance_user), ').');
            ROLLBACK;
        ELSE
            -- Thực hiện cập nhật dữ liệu
            -- 1. Trừ kho
            UPDATE Products 
            SET stock = stock - v_quantity 
            WHERE product_id = v_product_id;

            -- 2. Trừ tiền ví
            UPDATE Wallets 
            SET balance = balance - v_total_cost 
            WHERE patient_id = v_patient_id;

            -- Hoàn tất thành công
            COMMIT;
            SET message = CONCAT('Thành công: Đã xử lý đơn hàng. Tổng tiền: ', v_total_cost);
        END IF;
    END IF;
END //

DELIMITER ;