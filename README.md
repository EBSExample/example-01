# Example 01

A Python package example using Django, managed with `uv` and containerized with Docker.

## Project Structure

This repository contains a Python package called `example` that is managed using `uv`. The project follows a standard Python package structure with Django integration.

### Initial Setup

1. Initialize the project:
   ```bash
   uv init --package --name=example .
   ```
   This creates `pyproject.toml` and sets up the package in `src-layout`.

2. Add Django as a dependency:
   ```bash
   uv add django
   ```

3. Initialize Django:
   - Remove the `example` folder from `src`
   - Navigate to `src` directory
   - Run: `uv django-admin startproject example .`

### Package Configuration

1. Copy `manage.py` to the project's root directory and rename it to `__main__.py` in the `example` folder. This enables running the project using:
   ```bash
   python -m example runserver
   ```

2. Move `manage.py` to the root directory and modify it to import the `main` function from `example.__main__`. This allows using familiar Django commands:
   ```bash
   python manage.py migrate
   ```

3. Update `pyproject.toml` to fix the package entrypoint:
   ```toml
   [project.scripts]
   example = "example.__main__:main"
   ```
   This enables shorter command execution:
   ```bash
   example migrate
   example runserver 0.0.0.0:8000
   ```

### Static Files Configuration

To prevent static files from being collected into the `site-packages` directory when the package is installed in a virtual environment, modify `settings.py`:

```python
BASE_DIR = Path(os.getcwd())
```

## Docker Configuration

The project is containerized using Docker. The `Dockerfile` follows a multi-stage build process:

1. Base stage:
   - Uses Python base image
   - Copies necessary files for `uv`
   - Copies source code and project files into image
   - Runs `uv sync --locked --no-editable` to create a virtual environment and install dependencies

2. Final stage:
   - Copies the virtual environment
   - Updates `PATH` to point to the virtual environment's `bin` directory
   - Contains `python` and `example` entrypoints with virtual environment context

To start the project in Docker:
```bash
example runserver 0.0.0.0:8000
```
