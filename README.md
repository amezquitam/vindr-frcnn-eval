
# Vindr-FRCNN-Eval

Este proyecto permite realizar la evaluación del modelo **Faster R-CNN** usando el dataset **Vindr**. A continuación, se describe cómo clonar, compilar y ejecutar el proyecto utilizando Docker.

## Requisitos previos

- **Docker**: Asegúrate de tener **Docker** y **Docker Compose** instalados en tu sistema.
  - Si no tienes Docker instalado, puedes seguir las instrucciones en la [documentación oficial](https://docs.docker.com/get-docker/).
  - También necesitas **Docker Compose**, que se puede instalar siguiendo las instrucciones de la [guía oficial](https://docs.docker.com/compose/install/).

## Clonar el repositorio

Para comenzar, clona el repositorio utilizando Git. Asegúrate de usar la opción `--recursive` para obtener todos los submódulos necesarios.

1. Abre una terminal.
2. Ejecuta el siguiente comando para clonar el repositorio:

```bash
git clone --recursive https://github.com/amezquitam/vindr-frcnn-eval.git
cd vindr-frcnn-eval
docker-compose up --build
```
