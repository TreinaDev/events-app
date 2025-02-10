````mermaid
erDiagram
    User {
        string email
        string encrypted_password
        string name
        string family_name
        string registration_number
        integer role
        integer verification_status
        string confirmation_token
        datetime confirmed_at
        string phone_number
        string id_photo
        string address_proof
    }

    UserAddress {
        string street
        integer number
        string district
        string city
        string state
        string zip_code
        integer user_id
    }

    Event {
        string name
        integer user_id
        integer event_type
        integer participants_limit
        string url
        integer status
        datetime discarded_at
        string code
        datetime start_date
        datetime end_date
        integer event_place_id
    }

    EventPlace {
        string name
        string street
        string number
        string neighborhood
        string city
        string zip_code
        string state
        integer user_id
    }

    EventPlaceRecommendation {
        string name
        string full_address
        string phone
        integer event_place_id
    }

    Schedule {
        datetime date
        integer event_id
    }

    ScheduleItem {
        string name
        string description
        datetime start_time
        datetime end_time
        string responsible_name
        string responsible_email
        integer schedule_type
        integer schedule_id
        string code
        datetime discarded_at
    }

    Speaker {
        string name
        string email
        string code
    }

    TicketBatch {
        string name
        integer tickets_limit
        date start_date
        date end_date
        decimal ticket_price
        integer discount_option
        integer event_id
        string code
    }

    Category {
        string name
    }

    Keyword {
        string value
    }

    CategoryKeyword {
        integer category_id
        integer keyword_id
    }

    EventCategory {
        integer event_id
        integer category_id
    }

    Announcement {
        string title
        integer user_id
        integer event_id
        string code
    }

    Verification {
        integer user_id
        integer reviewed_by_id
        integer status
        text comment
    }

    User ||--o{ Event : "has many"
    User ||--o| UserAddress : "has one"
    User ||--o{ EventPlace : "has many"
    User ||--o{ Verification : "has many"
    User ||--o{ Announcement : "has many"

    Event ||--o{ Announcement : "has many"
    Event ||--o{ Schedule : "has many"
    Event ||--o{ TicketBatch : "has many"
    Event ||--o{ EventCategory : "has many"
    Event }|--|| EventPlace : "belongs to"

    EventPlace ||--o{ EventPlaceRecommendation : "has many"
    EventPlace }|--|| User : "belongs to"

    Schedule ||--o{ ScheduleItem : "has many"

    ScheduleItem }|--o| Speaker : "belongs to"

    Speaker ||--o{ ScheduleItem : "has many"

    Category ||--o{ EventCategory : "has many"
    Category ||--o{ CategoryKeyword : "has many"

    Keyword ||--o{ CategoryKeyword : "has many"

    Verification }|--|| User : "belongs to"
    Verification }|--o| User : "reviewed by"

    CategoryKeyword }|--|| Category : "belongs to"
    CategoryKeyword }|--|| Keyword : "belongs to"

    EventCategory }|--|| Event : "belongs to"
    EventCategory }|--|| Category : "belongs to"
````