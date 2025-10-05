## Kiến trúc hệ thống core Multitenant

Hệ thống core multitenant được thiết kế để dễ dàng mở rộng (scaling) và tích hợp với nhiều dự án khác nhau, đảm bảo hiệu suất, bảo mật và khả năng quản lý linh hoạt.

---

### 🛠️ Tech Stack

#### Backend

- **Containerization:** Docker
- **Cloud Provider:** Google Cloud
- **Database:** PostgreSQL, Cloud SQL, TimescaleDB
- **Cache & Message Broker:** Redis, Kafka (Queue)
- **Framework:** NestJS
- **Autoscaling:** Kubernetes (K8s), Horizontal Pod Autoscaler (HPA)
- **Monitoring & Logging:** Sentry
- **API:** GraphQL Codegen
- **Infrastructure as Code:** Terraform, Tanka
- **CI/CD:** Github Actions
- **Repository Structure:** MonoRepo
- **Job Scheduler:** Job
- **Quản lý môi trường:** env
- **Xác thực:** OAuth
- **chuyển đổi YAML/JSON** yq

#### Frontend

- **Ngôn ngữ:** TypeScript
- **Framework:** React
- **Build Tool:** Vite
- **UI Library:** MUI
- **Storybook:** Library Storybook
- **Code Quality:** ESLint, Prettier
- **Rich Text Editor:** Lexical (dự kiến)