# Data Models: Initial App Setup and Authentication Baseline

## Phase 1: Data Model Design

We define two main entities in the system: `ResidentProfile` (user profile data) and `DeviceToken` (tracking device registrations for push notifications).

### 1. ResidentProfile Entity
Stored in Firestore at path: `/residents/{uid}`

| Field | Type | Description |
| :--- | :--- | :--- |
| `uid` | String | Unique Firebase Auth User ID |
| `name` | String | Full name of the resident |
| `email` | String | Registered email address |
| `housingUnit` | String | House number or address inside the private community |
| `role` | String | User role (e.g., `resident`, `admin`, `moderator`) |
| `createdAt` | Timestamp | Date the resident profile was created |
| `updatedAt` | Timestamp | Date of last profile update |
| `isActive` | Boolean | True if the resident account is active |

#### Firestore Schema Example
```json
{
  "uid": "Wv7p8x9K...",
  "name": "Jane Doe",
  "email": "janedoe@conventohueyapan.com",
  "housingUnit": "House 42",
  "role": "resident",
  "createdAt": "2026-05-29T12:00:00Z",
  "updatedAt": "2026-05-29T12:00:00Z",
  "isActive": true
}
```

---

### 2. DeviceToken Entity
Stored in Firestore as a subcollection under each resident: `/residents/{uid}/devices/{token_id}`
This subcollection maps devices registered for notifications (standard and critical).

| Field | Type | Description |
| :--- | :--- | :--- |
| `tokenId` | String | Unique identifier (hash of the FCM token) |
| `token` | String | Full Firebase Cloud Messaging (FCM) registration token |
| `platform` | String | Device operating system: `ios` or `android` |
| `updatedAt` | Timestamp | Timestamp when the token was registered or refreshed |
| `isActive` | Boolean | Status indicating if notifications should be sent to this token |

#### Firestore Schema Example
```json
{
  "tokenId": "sha256_hash_of_fcm_token...",
  "token": "d8xJpA9x...",
  "platform": "ios",
  "updatedAt": "2026-05-29T12:05:00Z",
  "isActive": true
}
```
