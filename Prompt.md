# Task Management API — Ruby on Rails 7

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
