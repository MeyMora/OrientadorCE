% ============================================================
% BNF.pl  -  Parser DCG e Interfaz de Usuario
% Proyecto: OrientadorCE
% CE3104 Paradigmas de Programacion - TEC, I Semestre 2026
%
% Descripcion:
%   Interfaz conversacional del sistema experto OrientadorCE.
%   Recibe oraciones en lenguaje natural, las envia a reglas.pl
%   para parsear e infiere intencion y tema del usuario.
%   Usa BD.pl para recomendar la carrera mas afin al perfil.
%
% Uso:
%   $ swipl BNF.pl
%   ?- iniciar.
%
% Dependencias:
%   reglas.pl  -> interpretar/2, extrae intencion(I, Tema)
%   BD.pl      -> carrera/3, base de datos de carreras
% ============================================================

:- use_module(library(lists)).

% ------------------------------------------------------------
% Dependencias externas
% ------------------------------------------------------------
:- consult('Base_datos.pl').
:- consult('reglas.pl').

% ============================================================
%  PARSER
%
%  atomizar/2 convierte el texto libre del usuario en una
%  lista de atomos en minuscula, que reglas.pl puede procesar.
%
%  parsear/3 envuelve interpretar/2 de reglas.pl y separa
%  la intencion del tema para uso en el flujo conversacional.
% ============================================================

% atomizar(+Texto, -Tokens)
% Normaliza el texto a minusculas y lo divide en atomos.
% Elimina signos de puntuacion y tokens vacios.
atomizar(Texto, Tokens) :-
    string_lower(Texto, Lower),
    split_string(Lower, " ,!?.;:()", " ", Partes),
    exclude([P]>>(P = ""), Partes, Limpias),
    maplist([S, A]>>(atom_string(A, S)), Limpias, Tokens).

% parsear(+Texto, -Intencion, -Tema)
% Tokeniza el texto y llama a interpretar/2 de reglas.pl.
% Intencion: afirmativo | negativo | no_entendido
% Tema:      atomo del dominio (matematicas, tecnologia...) | desconocido
parsear(Texto, Intencion, Tema) :-
    atomizar(Texto, Tokens),
    interpretar(Tokens, Resultado),
    (   Resultado = intencion(I, T)
    ->  Intencion = I,
        Tema = T
    ;   Intencion = no_entendido,
        Tema = desconocido
    ).

% ============================================================
%  PREGUNTAS
%
%  Lista de preguntas guia para la conversacion.
%  Ya no se mapean a rasgos fijos porque reglas.pl extrae
%  el tema directamente de la respuesta del usuario.
% ============================================================

preguntas([
    'Que temas o materias te gustan?',
    'Te interesa la tecnologia y la programacion?',
    'Te gusta la ciencia o la biologia?',
    'Te gusta trabajar con personas?',
    'Te gustan los animales y su cuidado?',
    'Te gusta el dibujo, el diseno o la creatividad?',
    'Te interesan los negocios y el liderazgo?',
    'Te gustan los numeros y las finanzas?',
    'Te gusta leer, escribir o debatir?',
    'Te interesa viajar y conocer otras culturas?'
]).

% ============================================================
%  LECTURA DE ENTRADA
% ============================================================

% leer_entrada(-Texto)
% Lee una linea completa desde la entrada estandar.
leer_entrada(Texto) :-
    write('Usuario: '),
    read_line_to_string(user_input, Texto).

% leer_con_reintento(-Intencion, -Tema)
% Parsea la respuesta del usuario con reglas.pl.
% Rechaza respuestas con tema desconocido (si/no directo).
% Pide repetir si interpretar retorna no_entendido.
leer_con_reintento(Intencion, Tema) :-
    leer_entrada(Texto),
    parsear(Texto, I, T),
    (   I = no_entendido
    ->  nl,
        writeln('OrientadorCE: Me puedes repetir, no entendi.'),
        nl,
        leer_con_reintento(Intencion, Tema)
    ;   T = desconocido
    ->  nl,
        writeln('OrientadorCE: El sistema no acepta si/no directamente.'),
        writeln('              Por favor responde con una oracion completa.'),
        nl,
        leer_con_reintento(Intencion, Tema)
    ;   Intencion = I,
        Tema = T
    ).

% ============================================================
%  FLUJO DE CONVERSACION
%
%  El perfil se construye con dos listas separadas:
%    Gustos   -> temas con intencion afirmativa
%    Rechazos -> temas con intencion negativa
%
%  Estas listas se usan luego para puntuar las carreras
%  de la base de datos.
% ============================================================

% actualizar_perfil(+Tema, +Intencion,
%                   +Gustos0, +Rechazos0,
%                   -Gustos1, -Rechazos1)
% Agrega el tema a la lista correcta segun la intencion.
actualizar_perfil(Tema, afirmativo, G0, R,  [Tema|G0], R).
actualizar_perfil(Tema, negativo,   G,  R0, G, [Tema|R0]).

% procesar_preguntas(+Preguntas,
%                    +Gustos0, +Rechazos0,
%                    -GusFinal, -RecFinal)
% Recorre la lista de preguntas, parsea cada respuesta
% y acumula el perfil del usuario.
procesar_preguntas([], G, R, G, R).
procesar_preguntas([Q|Resto], G0, R0, GF, RF) :-
    nl,
    format('OrientadorCE: ~w~n', [Q]),
    leer_con_reintento(Intencion, Tema),
    actualizar_perfil(Tema, Intencion, G0, R0, G1, R1),
    procesar_preguntas(Resto, G1, R1, GF, RF).

% ============================================================
%  PUNTO DE ENTRADA
% ============================================================

% iniciar/0
% Inicia la sesion del orientador vocacional.
iniciar :-
    nl,
    writeln('==================================================='),
    writeln('  OrientadorCE - Orientador Vocacional - TEC       '),
    writeln('==================================================='),
    nl,
    writeln('OrientadorCE: Hola, se que la tarea de buscar una'),
    writeln('              carrera es dificil. Estamos aqui para'),
    writeln('              ayudarte! Dime que te gusta.'),
    nl,
    leer_entrada(_),
    nl,
    preguntas(ListaPreguntas),
    procesar_preguntas(ListaPreguntas, [], [], Gustos, Rechazos),
    nl,
    % --- STUB: se reemplaza en proximo commit ---
    format('OrientadorCE: [STUB] Gustos:   ~w~n', [Gustos]),
    format('OrientadorCE: [STUB] Rechazos: ~w~n', [Rechazos]),
    nl.
