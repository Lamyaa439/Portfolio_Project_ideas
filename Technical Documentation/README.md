# Technical Documentation

# Design System Architecture

<img width="6458" height="3563" alt="Payment Processing Flow in-2026-04-23-090142" src="https://github.com/user-attachments/assets/bfd0e88e-2b3c-4fa7-9853-5916f5b27e5e" />

# Classes, and Database Design

## 1. Classes
<img width="8192" height="8135" alt="LOVEN Mobile App Payment-2026-04-23-084136" src="https://github.com/user-attachments/assets/08167734-75d6-4663-a80d-34cb2de49c17" />

## 2. Database Design
<img width="7600" height="8192" alt="LOVEN mobile App ED" src="https://github.com/user-attachments/assets/3471af10-5c4e-4127-873a-fa658445ed26" />


# LOVEN — API Documentation



## 1. External APIs

The LOVEN backend integrates with the following third-party services to offload specialized tasks and maintain architectural efficiency.

| Service | Purpose | Reason for Selection |
| :--- | :--- | :--- |
| **Moyasar API** | Payment Processing | Securely handles Mada, Visa, and Apple Pay. Ensures PCI compliance without storing sensitive card data on our servers. |
| **Firebase Storage** | Media Hosting | Offloads binary image data (artworks/profiles). Improves database performance by storing only lightweight URLs in PostgreSQL. |
| **Firebase Cloud Messaging (FCM)** | Push Notifications | Essential for real-time order updates. Provides a reliable delivery system for the `fcm_token` stored in the User model. |

---

## 2. Internal API Specification

### General Configuration
- **Base URL:** 
- **Content-Type:** `application/json`
- **Authentication:** All protected endpoints require a `Bearer <token>` in the HTTP `Authorization` header.
- **Identifiers:** All resource IDs are secure, non-sequential **UUIDs**.

## Authentication & Identity Layer

| Method | Endpoint | Input Format | Output Format | Description |
| :--- | :--- | :--- | :--- | :--- |
| `POST` | `/auth/register` | JSON (name, email, password) | User Object + Token | تسجيل مستخدم جديد (مشتري/فنان). |
| `POST` | `/auth/login` | JSON (email, password) | Auth Token | التحقق من الهوية واستلام توكن الدخول. |
| `PATCH` | `/users/me/fcm-token` | JSON (fcm_token) | Success Message | **مهم:** تحديث عنوان الجهاز لإرسال التنبيهات. |
| `GET` | `/users/me` | None (Auth Header) | User Object | جلب بيانات البروفايل للمستخدم الحالي. |
| `PUT` | `/users/me` | JSON (name, lang, city) | Updated User Object | تحديث البيانات الشخصية. |
| `DELETE` | `/users/me` | None (Auth Header) | Success Message | تنفيذ الحذف المنطقي (Soft Delete). |

---

## Artist & Verification Layer

| Method | Endpoint | Input Format | Output Format | Description |
| :--- | :--- | :--- | :--- | :--- |
| `POST` | `/artists` | JSON (display_name, bio) | Artist Object | إنشاء بروفايل فنان لمستخدم مسجل. |
| `GET` | `/artists/{id}` | Path Param | Artist + Artworks | العرض العام لبروفايل الفنان وأعماله. |
| `PUT` | `/artists/me` | JSON (bio, city, policy) | Updated Artist | تحديث بيانات الفنان المهنية. |
| `POST` | `/artists/me/verify`| JSON (doc_type, doc_no, inst) | Verification Object | تقديم طلب التوثيق الرسمي للإدارة. |

---

## Artwork Marketplace (Catalog)

| Method | Endpoint | Input Format | Output Format | Description |
| :--- | :--- | :--- | :--- | :--- |
| `GET` | `/artworks` | Query (`search, category, page`) | Paginated Array | تصفح المتجر مع دعم البحث والتقسيم (Pagination). |
| `GET` | `/artworks/{id}` | Path Param | Artwork Object | عرض تفاصيل العمل الفني والكمية المتوفرة. |
| `POST` | `/artworks` | JSON (title, price, stock, images)| Created Artwork | إضافة عمل فني جديد (خاص بالفنانين فقط). |
| `PUT` | `/artworks/{id}` | JSON (updatable fields) | Updated Artwork | تعديل بيانات العمل الفني. |
| `DELETE` | `/artworks/{id}` | Path Param | Success Message | أرشفة العمل الفني (Soft Delete). |

---

## Cart & Favorites (Interactions)

| Method | Endpoint | Input Format | Output Format | Description |
| :--- | :--- | :--- | :--- | :--- |
| `GET` | `/cart` | None (Auth Header) | Cart Items + Total | جلب محتويات السلة الحالية. |
| `POST` | `/cart/items` | JSON (artwork_id, qty) | Updated Cart | إضافة أو تحديث كمية منتج في السلة. |
| `DELETE` | `/cart/items/{id}`| Path Param | Updated Cart | حذف منتج معين من السلة. |
| `GET` | `/favorites` | None (Auth Header) | Array (Artworks) | عرض قائمة المفضلات للمستخدم. |
| `POST` | `/favorites/toggle`| JSON (artwork_id) | `{ status: "added/removed" }`| **Toggle:** إضافة أو حذف من المفضلات بطلب واحد. |

---

## Orders & Financial Transactions

| Method | Endpoint | Input Format | Output Format | Description |
| :--- | :--- | :--- | :--- | :--- |
| `POST` | `/orders` | JSON (payment_method) | Order Object | تحويل السلة إلى طلب والبدء في عملية الدفع. |
| `GET` | `/orders` | Query (`?role=buyer/seller`) | Array (Orders) | عرض سجل الطلبات حسب دور المستخدم. |
| `GET` | `/orders/{id}` | Path Param | Order Detailed Obj | تفاصيل الطلب، الفاتورة، وبيانات الشحن. |
| `PATCH` | `/orders/{id}/status` | JSON (status) | Updated Order | تحديث حالة الطلب (Cancelled, Delivered). |
| `PATCH` | `/orders/{id}/shipment`| JSON (company, tracking_no) | Updated Order | **للفنانين:** إضافة بيانات الشحن وإطلاق تنبيه FCM. |

---

## System Governance (Support)

| Method | Endpoint | Input Format | Output Format | Description |
| :--- | :--- | :--- | :--- | :--- |
| `POST` | `/reports` | JSON (artwork_id, reason, text) | Success Message | الإبلاغ عن محتوى مخالف. |
| `POST` | `/feedback` | JSON (subject, message) | Success Message | إرسال مقترح أو ملاحظة للإدارة. |

---
