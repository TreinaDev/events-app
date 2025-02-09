# Documentação da API

## Índice

- [Eventos](#eventos)
- [Palestrantes](#palestrantes)
- [Lotes de Ingressos](#lotes)
- [Comunicados](#comunicados)

## Eventos

#### GET /api/v1/events

```json
{
  "events": [
    {
      "id": 1,
      "name": "Evento 1",
      "description": "\u003Ch1\u003EDescrição do evento 1\u003C/h1\u003E",
      "event_type": "inperson",
      "address": "Rua dos Computadores, 125",
      "logo_url": "https://www.example.com/logo1.png",
      "banner_url": "https://www.example.com/banner1.png",
      "participants_limit": 100,
      "event_owner": "João",
      "start_date": "2025-02-21T00:07:00.827-03:00",
      "end_date": "2025-02-28T00:07:00.827-03:00"
    }
  ]
}
```

#### GET /api/v1/events/:code

```json
{
  "code": "OUZ73W3S",
  "name": "Conferencia JS",
  "description": "Um evento maneiro de Java escrito",
  "event_type": "inperson",
  "address": "Rua dos Computadores, 125",
  "logo_url": "http://logo.png",
  "banner_url": "http://banner.png",
  "participants_limit": 30,
  "event_owner": "Joao",
  "start_date": "2025-02-21T00:07:00.827-03:00",
  "end_date": "2025-02-28T00:07:00.827-03:00",
  "ticket_batches": [
    {
      "id": 2,
      "name": "Primeiro Lote - Inteira",
      "tickets_limit": 10,
      "start_date": "2025-02-06",
      "end_date": "2025-02-21",
      "ticket_price": "109.99",
      "discount_option": "no_discount",
      "event_id": 2,
      "created_at": "2025-02-07T00:07:21.119-03:00",
      "updated_at": "2025-02-07T00:07:21.119-03:00",
      "code": "BXTU46AO"
    }
  ],
  "schedules": [
    {
      "date": "2025-02-21",
      "schedule_items": [
        {
          "code": "VI0PQFHV",
          "name": "Paletra sobre NodeJS",
          "description": "Palestra sobre tudo de NodeJS.",
          "start_time": "2025-02-08T09:00:00.000-03:00",
          "end_time": "2025-02-08T10:00:00.000-03:00",
          "responsible_name": "José",
          "responsible_email": "jose@email.com",
          "schedule_type": "activity"
        }
      ]
    }
  ]
}
```

## Palestrantes

### POST /api/v1/speakers

Exemplo de corpo da requisição:

```json
{
  "email": "palestrante@example.com"
}
```

Resposta:

```json:
{
  "code": "SPEAKER123"
}
```

### GET /api/v1/speakers/:code/events

```json
{
  "events": [
    {
      "code": "EVENT123",
      "name": "Conferencia JS",
      "event_type": "online",
      "description": "<h1>Um evento maneiro de Java escrito</h1>",
      "address": "Rua dos Computadores, 125",
      "logo_url": "http://logo.png",
      "banner_url": "http://banner.png",
      "participants_limit": 30,
      "event_owner": "Joao",
      "start_date": "2025-02-21T00:07:00.827-03:00",
      "end_date": "2025-02-28T00:07:00.827-03:00"
    }
  ]
}
```

### /api/v1/speakers/:code/event/:event_code

```json
{
  "code": "EVENT123",
  "name": "Conferencia JS",
  "event_type": "online",
  "description": "<h1>Um evento maneiro de Java escrito</h1>",
  "address": "Rua dos Computadores, 125",
  "logo_url": "http://logo.png",
  "banner_url": "http://banner.png",
  "participants_limit": 30,
  "event_owner": "Joao",
  "start_date": "2025-02-21T00:07:00.827-03:00",
  "end_date": "2025-02-28T00:07:00.827-03:00"
}
```

### GET /api/v1/speakers/:code/schedules/:event_code

```json
{
  "schedules": [
    {
      "date": "2025-02-21",
      "schedule_items": [
        {
          "code": "VI0PQFHV",
          "name": "Paletra sobre NodeJS",
          "description": "Palestra sobre tudo de NodeJS.",
          "start_time": "2025-02-08T09:00:00.000-03:00",
          "end_time": "2025-02-08T10:00:00.000-03:00",
          "responsible_name": "José",
          "responsible_email": "jose@email.com",
          "schedule_type": "activity"
        }
      ]
    }
  ]
}
```

### GET /api/v1/speakers/:code/schedule_item/:schedule_item_code

```json
{
  "code": "VI0PQFHV",
  "name": "Paletra sobre NodeJS",
  "description": "Palestra sobre tudo de NodeJS.",
  "start_time": "2025-02-08T09:00:00.000-03:00",
  "end_time": "2025-02-08T10:00:00.000-03:00",
  "responsible_name": "José",
  "responsible_email": "jose@email.com",
  "schedule_type": "activity",
  "event": {
    "code": "ABCD1234",
    "start_date": "2025-02-21T00:07:00.827-03:00",
    "end_date": "2025-02-28T00:07:00.827-03:00"
  }
}
```

## Lotes

### GET /api/v1/events/:event_code/ticket_batches

```json
{
  "ticket_batches": [
    {
      "name": "Primeiro Lote",
      "tickets_limit": 15,
      "start_date": "2023-10-01",
      "end_date": "2023-10-15",
      "ticket_price": "500.0",
      "discount_option": "student",
      "event_id": 1,
      "code": "ABC123"
    }
  ]
}
```

### GET /api/v1/events/:event_code/ticket_batches/:code

```json
{
  "ticket_batch": {
    "name": "Primeiro Lote",
    "tickets_limit": 15,
    "start_date": "2023-10-01",
    "end_date": "2023-10-15",
    "ticket_price": "500.0",
    "discount_option": "student",
    "event_id": 1,
    "code": "ABC123"
  }
}
```

## Comunicados

### GET /api/v1/events/:event_code/announcements

```json
{
  "announcements": [
    {
      "title": "Título do Comunicado",
      "description": "<p>Descrição do comunicado</p>",
      "created_at": "2023-10-01T12:00:00Z",
      "code": "ABC123"
    }
  ]
}
```

### GET /api/v1/events/:event_code/announcements/:code

```json
{
  "announcement": {
    "title": "Título do Comunicado",
    "description": "<p>Descrição do comunicado</p>",
    "created_at": "2023-10-01T12:00:00Z",
    "code": "ABC123"
  }
}
```