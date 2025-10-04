# Hệ thống Core Multitenant

Đây là repository chứa hệ thống core multitenant, được thiết kế để dễ dàng mở rộng, tích hợp với nhiều dự án khác nhau, đảm bảo hiệu suất, bảo mật và khả năng quản lý linh hoạt.

## 📚 Kiến trúc hệ thống

Vui lòng xem chi tiết kiến trúc, công nghệ sử dụng và các thành phần của hệ thống tại file [docs/architechture.md](docs/architechture.md).

## 🚀 Tính năng nổi bật

- Quản lý đa tenant hiệu quả
- Dễ dàng mở rộng và tích hợp
- Sử dụng các công nghệ hiện đại: NestJS, React, Kubernetes, Google Cloud, v.v.
- Hỗ trợ CI/CD, giám sát, logging, autoscaling

## 🛠️ Hướng dẫn cài đặt

1. **Clone repository:**
   ```bash
   git clone <repo-url>
   ```

2. **Cài đặt các phụ thuộc:**
   ```bash
   cd app_core/backend
   npm install
   cd ../frontend
   npm install
   ```

3. **Cấu hình biến môi trường:**  
   Tạo file `.env` theo mẫu `.env.example` trong từng thư mục.

4. **Chạy hệ thống bằng Docker:**
   ```bash
   docker-compose up --build
   ```

## 📂 Cấu trúc thư mục

- `app_core/backend`: Source code backend (NestJS)
- `app_core/frontend`: Source code frontend (React)
- `docs/`: Tài liệu kiến trúc, hướng dẫn

## 📝 Đóng góp

Mọi đóng góp, báo lỗi hoặc đề xuất vui lòng tạo issue hoặc pull request.

## 📄 Giấy phép

MIT License.

## Tác giả

- [tudacoding](https://github.com/tudacoding)