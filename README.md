🎓 OrientadorCE – Sistema Experto en Prolog
📌 Descripción del Proyecto

OrientadorCE es un sistema experto desarrollado en Prolog que recomienda una carrera profesional a partir de las preferencias del usuario.

El sistema interactúa mediante lenguaje natural, interpreta las respuestas usando un parser basado en gramáticas BNF y genera una recomendación utilizando reglas lógicas.

Este proyecto fue desarrollado como parte del curso Paradigmas de Programación (CE3104) del Instituto Tecnológico de Costa Rica.

🎯 Objetivos
Aplicar el paradigma de programación lógica con Prolog
Implementar un sistema experto
Procesar lenguaje natural mediante gramáticas BNF
Utilizar listas como estructura de datos principal

------¿Cómo funciona?-----------------------------------

El sistema sigue el siguiente flujo:

El usuario escribe una oración en lenguaje natural
El sistema analiza la oración con el parser (BNF)
Se identifican intenciones (gustos / disgustos)
Se comparan con la base de conocimientos
Se genera una recomendación de carrera
🏗️ Estructura del Proyecto
OrientadorCE/
├── README.md
├── BD.pl        # Base de conocimientos (profesiones, afinidades)
├── BNF.pl       # Parser de lenguaje natural (gramática)
├── Logic.pl     # Motor de inferencia y flujo del sistema
👥 Integrantes del Proyecto
Nombre	Rol
Integrante 1	Base de conocimientos (BD.pl)
Integrante 2	Parser y gramática (BNF.pl)
Integrante 3	Motor lógico e integración (Logic.pl)
⚙️ Requisitos
SWI-Prolog (recomendado)
▶️ Cómo ejecutar el proyecto
Abrir SWI-Prolog
Cargar los archivos:
consult('BD.pl').
consult('BNF.pl').
consult('Logic.pl').
Ejecutar el sistema:
inicio.
💬 Ejemplo de uso
Usuario: Hola
Sistema: Hola, sé que la tarea de buscar una carrera es difícil. ¡Estamos aquí para ayudarte!

Usuario: Me gustan las matemáticas
Sistema: ¿Te gusta la tecnología?

Usuario: Sí, me encanta la tecnología
Sistema: ¿Te interesa trabajar con personas?

Usuario: No mucho
Sistema: Dadas tus preferencias te recomendaría estudiar Ingeniería en Computadores
🧩 Componentes principales
📘 Base de conocimientos (BD.pl)

Contiene:

Profesiones
Afinidades
Antagonías

Ejemplo:

profesion(ingenieria_computadores,
          [matematicas, tecnologia, problemas],
          [social]).
🧾 Parser (BNF.pl)
Define gramáticas BNF
Interpreta oraciones en lenguaje natural
Detecta afirmaciones y negaciones

Ejemplo:

gusto(tecnologia).
no_gusto(personas).
⚙️ Motor lógico (Logic.pl)
Procesa las intenciones del usuario
Aplica reglas de inferencia
Genera recomendaciones
📄 Documentación

El proyecto incluye:

Código fuente comentado
Manual de usuario
Documentación técnica:
Reglas implementadas
Estructuras de datos
Algoritmos
Problemas encontrados
Bitácora de trabajo
⚠️ Consideraciones importantes
El sistema NO utiliza respuestas tipo sí/no directamente
El usuario debe escribir en lenguaje natural
El sistema infiere la intención del usuario
Todas las funcionalidades deben estar integradas
🧪 Pruebas

Se recomienda probar:

Diferentes formas de expresar gustos
Frases negativas
Casos donde el sistema no entiende
📊 Evaluación

El proyecto será evaluado en:

Código funcional (70%)
Documentación (20%)
Defensa (10%)
🚀 Mejoras futuras
Soporte para más profesiones
Parser más robusto
Respuestas más naturales
Mejor manejo de ambigüedad
