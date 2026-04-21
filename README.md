# 🎓 OrientadorCE – Sistema Experto en Prolog

## 📌 Descripción del Proyecto
**OrientadorCE** es un sistema experto desarrollado en Prolog que recomienda una carrera profesional a partir de las preferencias del usuario.

El sistema interactúa mediante lenguaje natural, interpreta las respuestas usando un parser basado en gramáticas BNF y genera una recomendación utilizando reglas lógicas.

Este proyecto fue desarrollado como parte del curso **Paradigmas de Programación (CE3104)** del Instituto Tecnológico de Costa Rica.

---

## 🎯 Objetivos
- Aplicar el paradigma de programación lógica con Prolog
- Implementar un sistema experto
- Procesar lenguaje natural mediante gramáticas BNF
- Utilizar listas como estructura de datos principal

---

## 🧠 ¿Cómo funciona?

El sistema sigue el siguiente flujo:

1. El usuario escribe una oración en lenguaje natural  
2. El sistema analiza la oración con el parser (BNF)  
3. Se identifican intenciones (gustos / disgustos)  
4. Se comparan con la base de conocimientos  
5. Se genera una recomendación de carrera  

---

## 🏗️ Estructura del Proyecto

```
OrientadorCE/
├── README.md
├── BD.pl
├── BNF.pl
└── Logic.pl
```

## ⚙️ Requisitos

- SWI-Prolog

## ▶️ Cómo ejecutar el proyecto

1. Abrir SWI-Prolog  
2. Cargar los archivos:

```prolog
consult('BD.pl').
consult('BNF.pl').
consult('Logic.pl').

3. Ejecutar el sistema:
inicio.
```


## Ejemplo de uso 

---
```
Usuario: Hola
Sistema: Hola, sé que la tarea de buscar una carrera es difícil. ¡Estamos aquí para ayudarte!

Usuario: Me gustan las matemáticas
Sistema: ¿Te gusta la tecnología?

Usuario: Sí, me encanta la tecnología
Sistema: ¿Te interesa trabajar con personas?

Usuario: No mucho
Sistema: Dadas tus preferencias te recomendaría estudiar Ingeniería en Computadores
```
---
