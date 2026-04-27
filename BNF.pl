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
% Tema:      atomo del dominio | desconocido
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
%  NOMBRE LEGIBLE DE CARRERA
%
%  Traduce el atomo interno de BD.pl al nombre que se le
%  muestra al usuario al final de la conversacion.
% ============================================================

nombre_carrera(ingenieria_computadores, 'Ingenieria en Computadores').
nombre_carrera(medicina,                'Medicina').
nombre_carrera(derecho,                 'Derecho').
nombre_carrera(arquitectura,            'Arquitectura').
nombre_carrera(administracion_empresas, 'Administracion de Empresas').
nombre_carrera(contabilidad,            'Contabilidad').
nombre_carrera(psicologia,              'Psicologia').
nombre_carrera(veterinaria,             'Veterinaria').
nombre_carrera(turismo,                 'Turismo').
nombre_carrera(periodismo,              'Periodismo').

% ============================================================
%  MOTOR DE RECOMENDACION
%
%  Algoritmo:
%    Puntaje = (gustos del usuario en afinidades de la carrera)
%            - (rechazos del usuario en afinidades de la carrera)
%
%  Si el usuario rechaza algo que es afinidad de una carrera,
%  esa carrera pierde puntos. Se elige la de mayor puntaje.
% ============================================================

% contar_coincidencias(+ListaA, +ListaB, -Conteo)
% Cuenta cuantos elementos de ListaA estan en ListaB.
contar_coincidencias([], _, 0).
contar_coincidencias([H|T], Ref, N) :-
    (member(H, Ref) -> N1 = 1 ; N1 = 0),
    contar_coincidencias(T, Ref, N2),
    N is N1 + N2.

% max_par(+ListaDePares, -ParMaximo)
% Recorre lista de pares Puntaje-Carrera y retiene el mayor.
max_par([X], X).
max_par([P-N | T], Max) :-
    max_par(T, P2-N2),
    (P >= P2 -> Max = P-N ; Max = P2-N2).

% recomendar_carrera(+Gustos, +Rechazos, -Carrera)
% Puntua todas las carreras de BD.pl y retorna la mejor.
% Gustos y Rechazos son listas de atomos del dominio.
recomendar_carrera(Gustos, Rechazos, Carrera) :-
    findall(Puntaje-Nombre,
        (carrera(Nombre, Afinidades, _),
         contar_coincidencias(Gustos, Afinidades, Pos),
         contar_coincidencias(Rechazos, Afinidades, Neg),
         Puntaje is Pos - Neg),
        Pares),
    Pares \= [],
    max_par(Pares, _-Carrera).

% ============================================================
%  PREGUNTAS
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
% Rechaza si/no directo (Tema = desconocido).
% Pide repetir si interpretar no entiende la oracion.
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
% ============================================================

% actualizar_perfil(+Tema, +Intencion,
%                   +Gustos0, +Rechazos0,
%                   -Gustos1, -Rechazos1)
% Agrega el tema detectado a la lista correcta segun intencion.
actualizar_perfil(Tema, afirmativo, G0, R,  [Tema|G0], R).
actualizar_perfil(Tema, negativo,   G,  R0, G, [Tema|R0]).

% procesar_preguntas(+Preguntas,
%                    +Gustos0, +Rechazos0,
%                    -GusFinal, -RecFinal)
% Recorre preguntas, parsea respuesta y acumula perfil.
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
% Conversacion -> perfil -> recomendacion.
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
    (   recomendar_carrera(Gustos, Rechazos, CarreraAtomo)
    ->  nombre_carrera(CarreraAtomo, NombreLegible),
        writeln('OrientadorCE: Dadas tus preferencias te recomendaria'),
        format('              estudiar ~w.~n', [NombreLegible])
    ;   writeln('OrientadorCE: No pude determinar una carrera con tus respuestas.')
    ),
    nl.
