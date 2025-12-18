# Ruby Rack API

API construida con Ruby y Rack puro.

## ¿Cómo levantar el proyecto?

Se puede levantar el proyecto con Docker o localmente.

### Requisitos

1. **Localmente**

    - Ruby 3.4.7

2. **Docker**

    - Docker
    - Docker Compose

### Levantar el proyecto localmente

1. Instalar Ruby en su versión 3.4.7
2. Instalar las dependencias con `bundle install`
3. Crear los archivos `.env.development` y `.env.test`

Los archivos `.env` deben contener una única variable llamada `SESSION_SECRET` cuyo valor debe ser un string de 64 caracteres como mínimo:

```
SESSION_SECRET=secret_key
```

En esta página se puede generar una `secret_key` con la longitud deseada: https://secretkeygen.vercel.app/

4. Levantar el servidor con `bundle exec falcon serve --bind http://0.0.0.0:3000` (o el puerto que desees)

La API estará disponible en `http://localhost:3000` (o el puerto que hayas especificado en el **paso 4**).

### Levantar el proyecto con Docker

1. Instalar Docker y Docker Compose
2. Crear los archivos `.env.development` y `.env.test` (mismo proceso que en local)
3. Ejecutar en la terminal `docker compose up --build --no-cache`
4. Ejecutar en la terminal `docker compose up`

La API estará disponible en `http://localhost:3000`. Si necesitas levantar el proyecto con otro puerto, puedes modificar el archivo `docker-compose.yml`

## Testing

### Local

Para ejecutar los tests, ejecuta el siguiente comando:

```
bundle exce ruby -Itest <test_directory>
```

Si deseas ejecutar un test específico, puedes usar la flag `-n`:

```
bundle exce ruby -Itest <test_directory> -n <test_name>
```

Si deseas ejecutar todos los tests:

```
bundle exce ruby -rminitest/autorun -e 'Dir["test/**/*_test.rb"].each { |f| require File.expand_path(f) }'
```

### Docker

Para ejecutar los tests con Docker:

1. Hacer build con `docker compose up --build`
2. Ejecutar los tests con `docker compose run api bundle exec ruby -rminitest/autorun -e 'Dir["test/**/*_test.rb"].each { |f| require File.expand_path(f) }'`

Si quieres ejecutar un solo test, puedes ejecutar el siguiente comando (también puedes usar la flag `-n`):

```
docker compose run api bundle exec ruby -Itest <test_directory> -n <test_name>
```

## Docs

Además de exponer estáticamente el archivo de documentación, también es posible acceder a la documentación de la API a través de la ruta `/docs`.

Este endpoint utiliza Scalar para generar una interfaz gráfica de la documentación de la API basada en SwaggerUI.