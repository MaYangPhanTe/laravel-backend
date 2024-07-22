# เลือก image พื้นฐานของ PHP
FROM php:8.2-fpm

# ติดตั้ง dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libicu-dev

# ติดตั้ง PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd intl

# ติดตั้ง Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# ตั้งค่าการทำงานใน /var/www
WORKDIR /var/www

# คัดลอกไฟล์จากเครื่อง host ไปยัง container
COPY . .

# ติดตั้ง dependencies ของ Laravel
RUN composer install

# ตั้งค่า permissions
RUN chown -R www-data:www-data /var/www
RUN chmod -R 755 /var/www

# เรียกใช้งาน php-fpm
CMD ["php-fpm"]

EXPOSE 9000