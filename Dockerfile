# Use an official Python 3.11 image based on Ubuntu
FROM python:3.11-slim

# Install build tools and system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    build-essential \
    curl \
    wget \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libdrm2 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libxkbcommon0 \
    libxss1 \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /smart-ai-tester

# Copy the project files (needed for building the local package)
COPY . /smart-ai-tester

# Install UV
RUN pip install uv

# Install dependencies (no dev dependencies)
RUN uv sync --frozen --no-dev

# Install Playwright browsers (without system deps - they'll be installed at runtime if needed)
RUN uv run playwright install

# Make entrypoint executable
RUN chmod +x /smart-ai-tester/entrypoint.sh

# Define the entrypoint
ENTRYPOINT ["/smart-ai-tester/entrypoint.sh"]
