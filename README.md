# ShopMan – phiên bản JSP – DAO – Model 

## Công nghệ
- JDK 21, Maven
- JSP, HTML, CSS, JavaScript
- JDBC, MySQL 8, MySQL Connector/J 9.2
- Apache Tomcat 10.1.61
- Visual Studio Code

## Cấu trúc
```
src/main/java/vn/shopman/
  dao/       # Toàn bộ SQL và xử lý nghiệp vụ dữ liệu
  model/     # Các lớp dữ liệu
  util/      # Kết nối MySQL, mã hóa SHA-256 cho tài khoản demo
src/main/webapp/
  index.jsp  # Đăng nhập
  home.jsp   # Điều hướng theo role
  logout.jsp
  customer/ # Tra cứu, lịch sử tìm kiếm, chi tiết sản phẩm
  manager/  # Báo cáo doanh thu khách hàng, lịch sử hóa đơn
  WEB-INF/   # JSP include và web.xml
```

## Phạm vi hoạt động
- Đăng nhập bằng `UserDAO`, session lưu tài khoản và điều hướng theo role MANAGER hoặc CUSTOMER. SALES hiện chưa được triển khai và không đăng nhập được.
- Các trang trong từng thư mục kiểm tra role trước khi hiển thị; truy cập trái quyền trả về HTTP 403.
- CUSTOMER: tìm sản phẩm theo tên/mã, ghi và xem lịch sử tìm kiếm, xem chi tiết sản phẩm, sản phẩm cùng danh mục và đánh giá.
- MANAGER: thống kê khách hàng theo doanh thu theo khoảng ngày, xem hóa đơn của khách hàng và chi tiết hóa đơn.
- Các màn hình báo cáo khác được ghi rõ là chưa triển khai truy vấn, không dùng dữ liệu giả.

## Cài đặt trên Windows
1. Cài JDK 21, Maven, MySQL 8 và Tomcat 10.1.61.
2. Mở MySQL Workbench, chạy toàn bộ file `database/shopman.sql` để tạo database `ShopMan` và dữ liệu mẫu. **Script sẽ xóa và tạo lại các bảng cùng dữ liệu mẫu; không chạy trên database đang có dữ liệu cần giữ.**
3. Cấu hình biến môi trường trong PowerShell (đổi mật khẩu MySQL theo máy của bạn):
   ```powershell
   $env:SHOPMAN_DB_URL="jdbc:mysql://localhost:3306/ShopMan?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh"
   $env:SHOPMAN_DB_USER="root"
   $env:SHOPMAN_DB_PASSWORD="MAT_KHAU_MYSQL_CUA_BAN"
   ```
4. Mở thư mục `ShopMan` bằng VS Code, mở Terminal và chạy:
   ```powershell
   mvn clean package
   ```
5. Chép file `target\ShopMan.war` vào thư mục `D:\apache-tomcat-10.1.61\webapps\` rồi khởi động Tomcat:
   ```powershell
   & "D:\apache-tomcat-10.1.61\bin\startup.bat"
   ```
6. Mở `http://localhost:8080/ShopMan/`.

## Tài khoản demo
| Vai trò | Username | Password |
|---|---|---|
| MANAGER | manager | Manager@123 |
| CUSTOMER | customer | Customer@123 |

## Lưu ý kiến trúc
- JSP chỉ tiếp nhận tham số, gọi DAO và hiển thị Model; không viết câu lệnh SQL trong JSP.
- Các thao tác truy vấn và tính toán doanh thu nằm trong DAO.
- Vì không dùng Servlet nên JSP đảm nhiệm việc nhận POST/GET và điều hướng trang. Session login/logout được thao tác tại JSP do đây là cơ chế web session của container.
- Đây là phiên bản JSP trực tiếp gọi DAO theo đúng yêu cầu không Servlet; nếu triển khai dự án lớn, nên cân nhắc Controller riêng, nhưng phiên bản này không thêm Controller/Servlet.
- Schema SQL là bản triển khai tối giản dựa trên mô tả nghiệp vụ và giả định đã ghi trong bản trước; cần đối chiếu ERD gốc nếu giảng viên yêu cầu khớp tuyệt đối từng cột.
- Chưa xác nhận build/runtime trên máy Windows/Tomcat/MySQL của bạn. Hãy chạy `mvn clean package` và thử đăng nhập sau khi cấu hình database.
