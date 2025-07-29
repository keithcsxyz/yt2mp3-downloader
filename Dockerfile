FROM php:8.1-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    ffmpeg \
    wget \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install yt-dlp using virtual environment
RUN python3 -m venv /opt/yt-dlp-venv
RUN /opt/yt-dlp-venv/bin/pip install --upgrade pip
RUN /opt/yt-dlp-venv/bin/pip install yt-dlp

# Create symlink for easy access
RUN ln -s /opt/yt-dlp-venv/bin/yt-dlp /usr/local/bin/yt-dlp

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . /var/www/html/

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Create downloads directory with proper permissions
RUN mkdir -p /var/www/html/downloads \
    && chown -R www-data:www-data /var/www/html/downloads \
    && chmod -R 777 /var/www/html/downloads

# Configure Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Expose port
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
