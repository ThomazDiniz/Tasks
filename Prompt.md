# Task Management API — Ruby on Rails 7
Basic Prompt:

## Initial Task

**Task:**  
Generate a RESTful JSON API (Ruby on Rails 7) for a task management system.

### Requirements
- Implement CRUD operations for **Task** (create, read, update, delete).  
- Each **Task** has:  
  - `title` *(string)*  
  - `description` *(text)*  
  - `status` *(string or enum — e.g., "pending", "in_progress", "done")*  
  - `due_date` *(date)*  
- Each **Task** is associated with a **User** (assume a basic User model exists with authentication).  
- Include authentication using **Devise JWT** or token-based authentication — only authenticated users can access their tasks.  
- Add model validations:  
  - `title` and `status` are required  
  - `due_date` must not be in the past  
- Implement appropriate error handling:  
  - `404` for not found  
  - `422` for validation errors  
- Include **RSpec tests** for the Task model and controller, covering:  
  - Validations  
  - API endpoints  
- The project should be runnable through a **Docker container**.  
- Provide a **Postman collection file** for testing all API operations.

### Output
Provide the Rails code for:
- Models  
- Controllers  
- Routes  
- Sample RSpec tests  

Use idiomatic **Rails 7** best practices and a clean, RESTful architecture.  
Include documentation for:
- API usage  
- Postman testing  
- Running the project (with or without Docker)

---

## Secondary Task

### Objective
Run the already containerized project in Docker and verify that it works correctly.  
If any issue or error appears during the process, fix it and repeat the corresponding step until everything runs successfully.

### Instructions
1. Build and start the container using either `docker compose up -d` or a direct `docker run` command.  
2. Check the container’s status and logs to confirm it started without errors.  
   - If any failure or crash occurs, identify the cause, fix it, rebuild, and rerun.  
3. Access the exposed endpoint (default: [http://localhost:8080](http://localhost:8080) or `/health`) and verify it returns a valid response (HTTP 200).  
   - If not, troubleshoot the configuration or application logs and retry.  
4. Optionally run tests or health checks inside the container to ensure full functionality.  
   - Apply any required fixes before continuing.  
5. Stop and clean up the containers once functionality and responses are confirmed.  
6. Throughout the process, document each correction made so that future runs can reproduce a clean, working environment.

### Deliverables
- The exact commands executed.  
- Console output snippets confirming successful build and startup.  
- Confirmation message showing that the service responds correctly and passes health checks after any necessary corrections.  



--- 

# Presentation

# How I Validated, Corrected and Assessed the AI-Generated Rails API

## How I validated the AI's suggestions

I used Cursor as the GenAI coding tool and started from the complete prompt describing the Rails 7 JSON API, authentication with Devise JWT, model validations, Docker containerization, RSpec tests, and the Postman collection.

I validated the output in four stages:

### 1. Static review
I inspected the generated models, controllers, routes and specs to verify that they followed idiomatic Rails 7 patterns.
I confirmed the correctness of REST structures, `before_action` filters, strong parameters, enum usage, and the Devise JWT setup (middleware, Warden hooks, token encoding/decoding).

### 2. Running tests
I executed the full RSpec suite to check model validations, controller behavior and authentication.
Whenever tests failed due to outdated or incomplete syntax, I corrected the specs until everything passed.

### 3. Manual API testing
Using the generated Postman collection, I manually tested each endpoint: signup/signin, JWT retrieval, CRUD actions, and error scenarios.
I verified that each endpoint returned the correct HTTP codes (`200`, `201`, `204`, `401`, `403`, `404`, `422`) and consistent JSON error messages.

### 4. Docker and runtime validation
I built and ran the service using Docker, confirming that migrations executed correctly and that the Rails server booted without errors.
I hit the health endpoint and task routes to ensure behavior matched the local environment.

---

## How I corrected or improved the AI output

The initial draft served as a good foundation, but I applied several refinements:

### 1. Controller and routing improvements
I organized everything under `api/v1` and used `resources :tasks`.
I added `before_action :set_task` and always scoped queries as `current_user.tasks`.

### 2. Model improvements and validations
I replaced a raw string `status` with an enum backed by integers.
I tightened validations for `title`, `status` and `due_date`, providing clearer JSON error messages.

### 3. Error handling
I centralized JSON error handling in `ApplicationController` for `404` and `422` responses.
I replaced verbose or inconsistent error bodies with a standard structure containing an `errors` array.

### 4. Docker fixes
I reviewed the Dockerfile and docker-compose configuration to ensure correct dependencies, Ruby version, environment variables and database settings.
I rebuilt the image multiple times until everything booted cleanly.

---

## How I handled edge cases, authentication and validations

### Authentication
All endpoints required JWT authentication via `before_action :authenticate_user!`.
Every query was restricted to `current_user.tasks`, preventing unauthorized access—users cannot read or modify other users’ tasks even if they know an ID.
Invalid or expired tokens returned properly structured `401 Unauthorized` responses.

### Validations and input edge cases
I enforced:
- `title` and `status` as required fields
- `due_date` cannot be in the past
- invalid status values return `422`
- nonexistent tasks return `404`
- malformed bodies never crash the server

### Runtime edge cases
I validated the health endpoint, tested CRUD inside Docker, and documented fixes for missing deps, migration issues or boot errors.

---

## How I assessed performance and idiomatic Rails quality

### Idiomatic Rails review
I checked for consistency with Rails 7 API norms: clean REST controllers, strong params, enum usage, API versioning, and proper structure in `routes.rb`.
I ensured tests were structured clearly and followed RSpec best practices.

### Performance considerations
For this small API, I confirmed that queries were efficient and scoped by user.
I avoided unnecessary eager loading and ensured JSON responses remained lightweight.

### Overall assessment
The AI produced a solid foundation, but the final result required human intervention: reviewing code, correcting details, ensuring spec consistency, tightening validations, validating JWT behavior and testing inside Docker.
After those iterations, the project resulted in an idiomatic, reliable and maintainable Rails 7 API with full CRUD, authentication, validations, error handling, RSpec coverage and Docker support.
