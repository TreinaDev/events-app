# DIAGRAMA
````mermaid
erDiagram
    User ||--o{ Event : "organizes"
    User {
        int id PK
        string name
        string family_name
        string email
        string password
        string registration_number
        int verification_status
        int role
    }

    Event ||--o{ TicketBatch : "has"
    Event ||--|| Schedule : "has one"
    Event ||--o{ EventCategory : "has"
    Event {
        int id PK
        string name
        string url
        string type
        string address
        int participants_limit
        int status
        int user_id FK
    }

    Category ||--o{ EventCategory : "has"
    Category ||--o{ Tag : "has"
    Category {
        int id PK
        string name
    }

    EventCategory {
        int event_id FK
        int category_id FK
    }

    Tag {
        int id PK
        string name
        int category_id
    }

    Schedule ||--o{ ScheduleItem : "has many"
    Schedule {
        int id PK
        date start_date
        date end_date
        int event_id FK
    }

    ScheduleItem {
        int id PK
        string title
        string start_time
        string end_time
        text description
        int schedule_id FK
    }

    TicketBatch ||--o{ Ticket : "contains"
    TicketBatch {
        int id PK
        string name
        decimal price
        int quantity
        date start_date
        date end_date
        int event_id PK
    }

    Ticket {
        int id PK
        string code
        string status
        date purchase_date
        int batch_id
    }
````