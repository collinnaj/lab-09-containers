# 1. Base image: Python 3.13, small "slim" variant
FROM python:3.13-slim

# 2. Standard labels describing the image
LABEL org.opencontainers.image.title="book-analysis" \
      org.opencontainers.image.description="Lab 07 book analysis packaged with Docker" \
      org.opencontainers.image.source="https://github.com/collinnaj/lab-09-containers"

# 3. Copy the uv program (fixed version) from the official uv image
COPY --from=ghcr.io/astral-sh/uv:0.12.18 /uv /bin/uv

# 4. Create an ordinary (non-root) user
RUN useradd --create-home app

# 5. Working directory
WORKDIR /app

# 6. Copy only the dependency files first (for build caching)
COPY pyproject.toml uv.lock ./

# 7. Install exactly the packages from uv.lock into /app/.venv
RUN uv sync --frozen --no-dev --no-install-project --no-cache

# 8. Copy the code after the install
COPY src/ ./src/

# 9. Use the venv's Python, and let Python find the book_analysis package
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONPATH=/app/src

# 10. Run as the non-root user (after the install, which needed root)
USER app

# 11. Program to run when the container starts
ENTRYPOINT ["python", "-m", "book_analysis.analyze"]

# 12. Default argument: show help if no arguments are given
CMD ["--help"]
