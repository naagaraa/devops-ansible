
# Stage 1: Builder
# Use a PHP image with Composer and necessary extensions
FROM php:8.2-cli AS builder

# Install system dependencies
RUN apt-get update && apt-get install -y 
    git 
    unzip 
    libzip-dev 
    libpng-dev 
    jpeg-dev 
    libfreetype6-dev 
    acl 
    supervisor 
    procps 
    curl 
    libonig-dev 
    libxml2-dev 
    libssl-dev 
    zip 
    # Add any other system dependencies your app might need
    && docker-php-ext-configure gd --with-freetype --with-jpeg 
    && docker-php-ext-install gd pdo pdo_mysql mbstring zip exif pcntl bcmath opcache # Add other PHP extensions as needed 
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /app

# Copy composer files and install dependencies
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Copy the rest of the application code
COPY . .

# Copy .env.example and create .env
COPY .env.example .env

# Generate application key if not present
RUN php artisan key:generate --force

# Clear cache and optimize
RUN php artisan optimize:clear
RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:cache

# Ensure correct permissions for storage and bootstrap/cache
RUN chown -R www-data:www-data /app/storage /app/bootstrap/cache

# -- FrankenPHP specific setup (if using it directly, not via supervisor managing it) --
# If you are using FrankenPHP directly as the entrypoint:
# RUN curl -sLS https://github.com/dunglas/frankenphp/releases/latest/download/frankenphp -o /usr/local/bin/frankenphp 
#  && chmod +x /usr/local/bin/frankenphp

# Stage 2: Runtime
# Use a minimal image for runtime, like alpine or distroless
# For Laravel Octane with FrankenPHP, we can use the FrankenPHP image directly,
# or a lean image and copy the compiled binary.
# Let's use a minimal PHP image and copy Octane's binary if needed,
# or just rely on `php artisan octane:start` if it uses the CLI.

# For direct use of `php artisan octane:start`
FROM php:8.2-cli AS runtime

WORKDIR /app

# Copy compiled dependencies from builder stage
COPY --from=builder /usr/local/bin/composer /usr/local/bin/composer
COPY --from=builder /app /app

# Ensure permissions for storage and bootstrap/cache
RUN chown -R www-data:www-data /app/storage /app/bootstrap/cache

# Expose the port Octane will listen on (default is 8000 if not specified)
EXPOSE 8000

# Set environment variables
ENV APP_PORT=8000
ENV APP_ENV=production
ENV APP_LOG_LEVEL=warning
ENV APP_MAX_EXECUTION_TIME=600
ENV APP_MEMORY_LIMIT=512M

# Set the entrypoint to run Octane
# If FrankenPHP binary is used:
# COPY --from=builder /usr/local/bin/frankenphp /usr/local/bin/frankenphp
# ENTRYPOINT ["frankenphp", "artisan", "octane:start", "--server=frankenphp", "--host=0.0.0.0", "--port=8000"]

# If using `php artisan octane:start` directly from CLI:
ENTRYPOINT ["php", "artisan", "octane:start", "--server=frankenphp", "--host=0.0.0.0", "--port=8000"]

# Healthcheck: Use a simple curl command if curl is available in the runtime image.
# If using a distroless image, this would need adjustment or removal.
# The current base 'php:8.2-cli' includes curl.
HEALTHCHECK --interval=30s --timeout=5s --retries=3 --start-period=10s 
  CMD curl -f http://localhost:8000/ || exit 1
