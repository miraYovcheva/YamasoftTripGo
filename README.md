# TripGo – Rails JSON API for Trip Discovery

TripGo is a Ruby on Rails 8 JSON API backend for browsing and managing travel trips. It provides endpoints for listing, filtering, sorting, paginating, and creating trips, with robust validation, error handling, and background processing.

---

## Features

- **Trips API**
  - List trips with **filtering** (name, rating) via Ransack
  - **Sorting** (default by name, optional by rating)
  - **Pagination** via Kaminari, with meta info in the response
  - Show a single trip with detailed information
  - Create trips with strong parameters and validations

- **Validation & Error Handling**
  - Model validations:
    - `name`: required, unique
    - `rating`: required, integer between 1 and 5
  - Consistent JSON error responses (422 for validation errors, 404 for missing records, 500 for unexpected errors)
  - `ErrorsSerializer` for structured error payloads

- **Search & Sorting**
  - **Name search** using Ransack (`q[name_cont]`, `q[name_cont_cs]`)
    - `name_cont`: case-insensitive contains
    - `name_cont_cs`: case-sensitive contains
  - **Rating filters** with `q[rating_gteq]`
  - Ransack sort param `q[s]` (e.g. `q[s]=rating+asc`)

- **Pagination Meta**
  - `meta` object on index responses includes:
    - `current_page`, `per_page`, `total_pages`, `total_count`, `next_page`, `prev_page`

- **Authorization (Pundit-ready)**
  - Pundit integrated in the API base controller
  - `Api::V1::TripPolicy` defined (currently allows index/show/create)
  - Hooks in place to start using `authorize` / `policy_scope` when needed

- **Background Jobs**
  - `TripsRatingSummaryJob` (Active Job + Sidekiq)
    - Uses `Trip.generate_rating_summary` to compute:
      - total trips
      - average rating
      - counts per rating
      - top-rated trips
    - Logs the summary as JSON
  - Scheduled nightly via `sidekiq-cron` (2:00 AM)

- **Infrastructure**
  - **PostgreSQL** as the primary database
  - **Redis + Sidekiq** for background processing and cron
  - **CORS** enabled (via `rack-cors`) for frontend clients
  - Rails 8.0.4, Puma as app server

- **Testing**
  - RSpec for models, controllers, and jobs
  - FactoryBot for test data
  - Shoulda Matchers for concise validation specs

---

## Tech Stack

- **Language**: Ruby 3.3
- **Framework**: Rails 8.0.4
- **Database**: PostgreSQL
- **Background jobs**: Sidekiq, sidekiq-cron, Redis
- **Search & filtering**: Ransack
- **Pagination**: Kaminari
- **Serialization**: ActiveModelSerializers
- **Authorization**: Pundit
- **Testing**: RSpec, FactoryBot, Shoulda Matchers

---

## Getting Started

### Prerequisites

- Ruby 3.3 (via rbenv/RVM)
- PostgreSQL
- Redis (for Sidekiq)
- Bundler

### Setup

# Install Ruby gems
bundle install

# Set up the database
bin/rails db:create db:migrate db:seed
