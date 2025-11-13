# Tasks Management API

A RESTful JSON API built with Ruby on Rails 7 for managing tasks with user authentication.

## Features

- User authentication with JWT tokens
- CRUD operations for tasks
- Task status management (pending, in_progress, done)
- Due date validation
- User-specific task access
- Comprehensive test coverage with RSpec
- Docker support for easy deployment

## Prerequisites

### For Docker (Recommended)
- Docker (version 20.10 or higher)
- Docker Compose (version 2.0 or higher)

### For Local Development
- Ruby 3.2.0
- Rails 7.0.0
- PostgreSQL 15+ (or SQLite3 for development)
- Bundler

## Getting Started

### Option 1: Running with Docker (Recommended)

#### Step 1: Clone the repository
```bash
git clone <repository-url>
cd Tasks
```

#### Step 2: Build and start the containers
```bash
docker-compose up --build
```

This command will:
- Build the Docker images
- Start PostgreSQL database
- Create and migrate the database
- Start the Rails server on port 3000

#### Step 3: Access the API
The API will be available at: `http://localhost:3000`

#### Additional Docker Commands

**Stop the containers:**
```bash
docker-compose down
```

**Stop and remove volumes (clean slate):**
```bash
docker-compose down -v
```

**View logs:**
```bash
docker-compose logs -f web
```

**Run commands in the container:**
```bash
docker-compose exec web bundle exec rails console
docker-compose exec web bundle exec rails db:migrate
```

**Using Makefile (if available):**
```bash
make build    # Build the images
make up       # Start the services
make down     # Stop the services
make test     # Run tests in Docker
make clean    # Stop and remove volumes
```

### Option 2: Running without Docker

#### Step 1: Install dependencies
```bash
bundle install
```

#### Step 2: Setup database

**With PostgreSQL:**
```bash
# Create database
rails db:create

# Run migrations
rails db:migrate
```

**With SQLite (default for development):**
```bash
# Run migrations (creates SQLite database automatically)
rails db:migrate
```

#### Step 3: Start the server
```bash
rails server
```

The API will be available at: `http://localhost:3000`

## API Documentation

### Base URL
```
http://localhost:3000/api/v1
```

### Authentication

All task endpoints require authentication. Include the JWT token in the Authorization header:
```
Authorization: Bearer <your_token>
```

### Endpoints

#### Authentication

##### Register User
```http
POST /api/v1/auth/register
Content-Type: application/json

{
  "user": {
    "email": "user@example.com",
    "password": "password123",
    "password_confirmation": "password123"
  }
}
```

**Response (201 Created):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "email": "user@example.com"
  }
}
```

##### Login
```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "email": "user@example.com"
  }
}
```

**Error Response (401 Unauthorized):**
```json
{
  "error": "Invalid credentials"
}
```

#### Tasks

##### Get All Tasks
```http
GET /api/v1/tasks
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
[
  {
    "id": 1,
    "title": "Complete project documentation",
    "description": "Write comprehensive documentation",
    "status": "pending",
    "due_date": "2024-12-31",
    "user_id": 1,
    "created_at": "2024-01-01T10:00:00.000Z",
    "updated_at": "2024-01-01T10:00:00.000Z"
  }
]
```

##### Get Task by ID
```http
GET /api/v1/tasks/:id
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
{
  "id": 1,
  "title": "Complete project documentation",
  "description": "Write comprehensive documentation",
  "status": "pending",
  "due_date": "2024-12-31",
  "user_id": 1,
  "created_at": "2024-01-01T10:00:00.000Z",
  "updated_at": "2024-01-01T10:00:00.000Z"
}
```

**Error Response (404 Not Found):**
```json
{
  "error": "Not found"
}
```

##### Create Task
```http
POST /api/v1/tasks
Authorization: Bearer <token>
Content-Type: application/json

{
  "task": {
    "title": "Complete project documentation",
    "description": "Write comprehensive documentation for the API",
    "status": "pending",
    "due_date": "2024-12-31"
  }
}
```

**Response (201 Created):**
```json
{
  "id": 1,
  "title": "Complete project documentation",
  "description": "Write comprehensive documentation for the API",
  "status": "pending",
  "due_date": "2024-12-31",
  "user_id": 1,
  "created_at": "2024-01-01T10:00:00.000Z",
  "updated_at": "2024-01-01T10:00:00.000Z"
}
```

**Error Response (422 Unprocessable Entity):**
```json
{
  "errors": [
    "Title can't be blank",
    "Due date cannot be in the past"
  ]
}
```

##### Update Task
```http
PUT /api/v1/tasks/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "task": {
    "title": "Updated task title",
    "status": "in_progress",
    "due_date": "2024-12-30"
  }
}
```

**Response (200 OK):**
```json
{
  "id": 1,
  "title": "Updated task title",
  "description": "Write comprehensive documentation for the API",
  "status": "in_progress",
  "due_date": "2024-12-30",
  "user_id": 1,
  "created_at": "2024-01-01T10:00:00.000Z",
  "updated_at": "2024-01-01T11:00:00.000Z"
}
```

**Error Response (422 Unprocessable Entity):**
```json
{
  "errors": [
    "Title can't be blank"
  ]
}
```

##### Delete Task
```http
DELETE /api/v1/tasks/:id
Authorization: Bearer <token>
```

**Response (204 No Content)**

**Error Response (404 Not Found):**
```json
{
  "error": "Not found"
}
```

### Task Model

#### Fields
- `title` (string, required) - Task title
- `description` (text, optional) - Task description
- `status` (string, required) - Task status: `"pending"`, `"in_progress"`, or `"done"`
- `due_date` (date, optional) - Due date (cannot be in the past)
- `user_id` (integer, required) - Associated user ID

#### Validations
- `title` must be present
- `status` must be present and one of: `pending`, `in_progress`, `done`
- `due_date` cannot be in the past

### Error Responses

#### 401 Unauthorized
```json
{
  "error": "Unauthorized"
}
```

#### 404 Not Found
```json
{
  "error": "Not found"
}
```

#### 422 Unprocessable Entity
```json
{
  "errors": [
    "Title can't be blank",
    "Status can't be blank",
    "Due date cannot be in the past"
  ]
}
```

## Testing

### Running Tests with Docker

```bash
docker-compose -f docker-compose.test.yml up --abort-on-container-exit
```

Or using Makefile:
```bash
make test
```

### Running Tests Locally

```bash
# Setup test database
RAILS_ENV=test rails db:create db:migrate

# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/task_spec.rb
bundle exec rspec spec/requests/api/v1/tasks_spec.rb

# Run with documentation format
bundle exec rspec --format documentation
```

### Test Coverage

The test suite includes:

**Model Tests (`spec/models/task_spec.rb`):**
- Association validations
- Presence validations for title and status
- Due date validation (cannot be in the past)
- Status enum validation

**Controller Tests (`spec/requests/api/v1/tasks_spec.rb`):**
- GET /api/v1/tasks - List all tasks for authenticated user
- GET /api/v1/tasks/:id - Get specific task
- POST /api/v1/tasks - Create new task
- PUT /api/v1/tasks/:id - Update task
- DELETE /api/v1/tasks/:id - Delete task
- Authentication requirements
- Error handling (404, 422, 401)
- User isolation (users can only access their own tasks)

## Testing with Postman

### Import Collection and Environment

Follow these detailed steps to import the Postman collection and environment:

#### Step 1: Open Postman Import Dialog

1. Open Postman application (Desktop or Web)
2. Click the **"Import"** button in the top-left corner of Postman
   - Alternatively, you can use the keyboard shortcut: `Ctrl+O` (Windows/Linux) or `Cmd+O` (Mac)
   - Or go to **File → Import** from the menu

#### Step 2: Import the Collection File

1. In the Import dialog, click **"Upload Files"** or **"Choose Files"**
2. Navigate to the project directory and select:
   - `postman_collection.json`
3. Click **"Open"** or **"Import"**
4. You should see a confirmation message: "Tasks Management API" collection imported successfully

#### Step 3: Import the Environment File

1. Click **"Import"** again (or if the dialog is still open, click **"Upload Files"**)
2. Navigate to the project directory and select:
   - `postman_environment.json`
3. Click **"Open"** or **"Import"**
4. You should see a confirmation message: "Tasks API - Local" environment imported successfully

#### Step 4: Activate the Environment

1. In the top-right corner of Postman, click the environment dropdown (it may show "No Environment" or another environment)
2. Select **"Tasks API - Local"** from the dropdown
3. The environment is now active and ready to use

#### Alternative: Import Both Files at Once

You can also import both files simultaneously:

1. Click **"Import"** button
2. Click **"Upload Files"** or drag and drop both files:
   - `postman_collection.json`
   - `postman_environment.json`
3. Both files will appear in the import preview
4. Click **"Import"** to import both
5. Activate the "Tasks API - Local" environment from the dropdown

#### Verify Import

After importing, you should see:

- **Collections** (left sidebar):
  - "Tasks Management API" collection with folders:
    - Authentication (Register, Login)
    - Tasks (all CRUD operations)
    - Error Cases (validation and error scenarios)

- **Environments** (top-right dropdown):
  - "Tasks API - Local" environment available for selection

#### Troubleshooting Import Issues

**If the import fails:**
- Ensure both JSON files are valid JSON format
- Check that file paths are correct
- Try importing files one at a time
- Restart Postman and try again

**If environment variables don't work:**
- Verify the environment is selected in the dropdown
- Check that variable names match: `base_url` and `auth_token`
- Manually set `base_url` to `http://localhost:3000` if needed

### Environment Variables

The collection uses these environment variables:
- `base_url`: `http://localhost:3000` (default)
- `auth_token`: Automatically set after login/register

### Using the Imported Requests

Once imported, you can use the requests as follows:

1. **Navigate to a Request**:
   - In the left sidebar, expand the "Tasks Management API" collection
   - Expand folders (Authentication, Tasks, Error Cases) to see individual requests
   - Click on any request to open it

2. **Send a Request**:
   - Click the **"Send"** button in the request panel
   - Or use keyboard shortcut: `Ctrl+Enter` (Windows/Linux) or `Cmd+Enter` (Mac)
   - View the response in the bottom panel

3. **View Response**:
   - Response status code appears at the top (e.g., 200 OK, 201 Created, 422 Unprocessable Entity)
   - Response body shows JSON data
   - Response time and size are displayed

4. **Edit Requests**:
   - Modify request body, headers, or URL parameters as needed
   - Changes are saved automatically to the collection

### Testing Workflow

1. **Register or Login**: 
   - Run "Register" or "Login" request
   - Token is automatically saved to `auth_token` variable

2. **Create Tasks**:
   - Use "Create Task" requests with different statuses
   - Test validation errors with "Create Task - Missing Title" or "Create Task - Past Due Date"

3. **List Tasks**:
   - Use "Get All Tasks" to see all your tasks

4. **Update Task**:
   - Use "Update Task" with the task ID from previous responses

5. **Delete Task**:
   - Use "Delete Task" with the task ID

6. **Test Error Cases**:
   - Try accessing tasks without token (Unauthorized)
   - Try accessing non-existent task (Not Found)
   - Try creating invalid tasks (Validation errors)

## Database

### Migrations

```bash
# Run migrations
rails db:migrate

# Rollback last migration
rails db:rollback

# Check migration status
rails db:migrate:status
```

### Database Schema

**Users Table:**
- `id` (integer, primary key)
- `email` (string, unique, indexed)
- `password_digest` (string)
- `created_at` (datetime)
- `updated_at` (datetime)

**Tasks Table:**
- `id` (integer, primary key)
- `user_id` (integer, foreign key, indexed)
- `title` (string, required)
- `description` (text)
- `status` (string, required, indexed)
- `due_date` (date)
- `created_at` (datetime)
- `updated_at` (datetime)

## Project Structure

```
Tasks/
├── app/
│   ├── controllers/
│   │   ├── api/v1/
│   │   │   ├── authentication_controller.rb
│   │   │   └── tasks_controller.rb
│   │   ├── concerns/
│   │   │   └── authentication_helper.rb
│   │   └── application_controller.rb
│   └── models/
│       ├── user.rb
│       └── task.rb
├── config/
│   ├── routes.rb
│   ├── database.yml
│   └── initializers/
│       └── cors.rb
├── db/
│   ├── migrate/
│   └── schema.rb
├── spec/
│   ├── models/
│   │   └── task_spec.rb
│   ├── requests/
│   │   └── api/v1/
│   │       └── tasks_spec.rb
│   └── factories/
│       ├── users.rb
│       └── tasks.rb
├── Dockerfile
├── docker-compose.yml
├── docker-compose.test.yml
├── postman_collection.json
├── postman_environment.json
└── README.md
```

## Troubleshooting

### Docker Issues

**Port already in use:**
```bash
# Change port in docker-compose.yml
ports:
  - "3001:3000"  # Use port 3001 instead
```

**Database connection errors:**
```bash
# Rebuild containers
docker-compose down -v
docker-compose up --build
```

**Permission issues:**
```bash
# On Linux/Mac, you may need to fix permissions
sudo chown -R $USER:$USER .
```

### Local Development Issues

**Bundle install fails:**
```bash
# Update bundler
gem update bundler
bundle update --bundler
```

**Database migration errors:**
```bash
# Reset database (WARNING: deletes all data)
rails db:drop db:create db:migrate
```

**Test database issues:**
```bash
RAILS_ENV=test rails db:drop db:create db:migrate
```

## License

This project is provided as-is for educational purposes.

