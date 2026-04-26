% ============================================================
% BNF.pl  -  Parser DCG e Interfaz de Usuario
% Proyecto: OrientadorCE
% CE3104 Paradigmas de Programacion - TEC, I Semestre 2026
%
% Descripcion:
%   Este archivo implementa la interfaz conversacional del
%   sistema experto. Recibe oraciones en lenguaje natural,
%   las parsea mediante gramaticas libres de contexto (DCG/BNF)
%   e infiere la intencion del usuario (afirmativo/negativo).
%   Depende de BD.pl (base de datos) y Logic.pl (reglas).
%
% Uso:
%   $ swipl BNF.pl
%   ?- iniciar.
% ============================================================

:- use_module(library(lists)).

% ------------------------------------------------------------
% Dependencias externas (descomentar cuando esten disponibles)
% ------------------------------------------------------------
% :- consult('BD.pl').
% :- consult('Logic.pl').

% ============================================================
%  LEXICO - Terminales de la gramatica
% ============================================================

saludo --> [hola].
saludo --> [buenas].
saludo --> [hey].
saludo --> [saludos].

pronombre --> [yo].
pronombre --> [mi].

articulo --> [el].
articulo --> [la].
articulo --> [los].
articulo --> [las].
articulo --> [un].
articulo --> [una].

adv_afirmativo --> [claro].
adv_afirmativo --> [correcto].
adv_afirmativo --> [exacto].
adv_afirmativo --> [cierto].
adv_afirmativo --> [definitivamente].
adv_afirmativo --> [por, supuesto].
adv_afirmativo --> [mucho].
adv_afirmativo --> [bastante].

adv_negativo --> [no].
adv_negativo --> [nunca].
adv_negativo --> [jamas].
adv_negativo --> [tampoco].
adv_negativo --> [para, nada].
adv_negativo --> [poco].
adv_negativo --> [en, absoluto].

negacion --> [no].
negacion --> [nunca].
negacion --> [jamas].

clitico --> [me].
clitico --> [te].
clitico --> [le].
clitico --> [se].
clitico --> [].

verbo_afirmativo --> [amo].
verbo_afirmativo --> [adoro].
verbo_afirmativo --> [encanta].
verbo_afirmativo --> [encantan].
verbo_afirmativo --> [gusta].
verbo_afirmativo --> [gustan].
verbo_afirmativo --> [disfruto].
verbo_afirmativo --> [intereso].
verbo_afirmativo --> [interesa].
verbo_afirmativo --> [interesan].
verbo_afirmativo --> [apasiona].
verbo_afirmativo --> [fascina].
verbo_afirmativo --> [prefiero].
verbo_afirmativo --> [llama].
verbo_afirmativo --> [habil].

verbo_negativo --> [odio].
verbo_negativo --> [detesto].
verbo_negativo --> [aborrezco].
verbo_negativo --> [molesta].
verbo_negativo --> [molestan].
verbo_negativo --> [aburre].
verbo_negativo --> [aburren].
verbo_negativo --> [soporto].
verbo_negativo --> [podria].
verbo_negativo --> [puedo].

% ============================================================
%  GRAMATICA DCG - No terminales
% ============================================================

sintagma_nominal --> pronombre.
sintagma_nominal --> pronombre, articulo.
sintagma_nominal --> articulo.

sintagma_verbal_pos --> clitico, verbo_afirmativo.

sintagma_verbal_neg --> clitico, verbo_negativo.
sintagma_verbal_neg --> negacion, clitico, verbo_afirmativo.

complemento --> [].
complemento --> [_], complemento.

% ============================================================
%  REGLA RAIZ
%
%  BNF completo de la oracion:
%  <oracion> ::= <saludo> <complemento>
%              | <adv_afirmativo> <complemento>
%              | <adv_negativo> <complemento>
%              | <sn> <sv_pos> <complemento>
%              | <sn> <sv_neg> <complemento>
%              | <sv_pos> <complemento>
%              | <sv_neg> <complemento>
% ============================================================

oracion(afirmativo) --> saludo,             complemento.
oracion(afirmativo) --> adv_afirmativo,     complemento.
oracion(negativo)   --> adv_negativo,       complemento.
oracion(afirmativo) --> sintagma_nominal, sintagma_verbal_pos, complemento.
oracion(negativo)   --> sintagma_nominal, sintagma_verbal_neg, complemento.
oracion(afirmativo) --> sintagma_verbal_pos, complemento.
oracion(negativo)   --> sintagma_verbal_neg, complemento.

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

% parsear(+Texto, -Intencion)
% Aplica la gramatica al texto y retorna:
%   afirmativo | negativo | desconocido
parsear(Texto, Intencion) :-
    atomizar(Texto, Tokens),
    (   once(phrase(oracion(I), Tokens))
    ->  Intencion = I
    ;   Intencion = desconocido
    ).

% ============================================================
%  PREGUNTAS
%
%  pregunta(TextoPregunta, RasgosAfirmativos, RasgosNegativos)
%
%  Los rasgos corresponden exactamente a los atomos usados
%  en BD.pl dentro de las listas de afinidades y antagonias.
% ============================================================
preguntas([
    pregunta('Te gustan las matematicas y la logica?',
             [matematicas, logica],
             [rechazo_matematicas]),

    pregunta('Te gusta la tecnologia y la programacion?',
             [tecnologia, programacion],
             [rechazo_tecnologia]),

    pregunta('Te gusta resolver problemas complejos?',
             [resolver_problemas],
             [no_resuelve_problemas]),

    pregunta('Te interesa trabajar con personas?',
             [personas],
             [rechazo_personas]),

    pregunta('Te gusta la ciencia y la biologia?',
             [ciencia, biologia, salud],
             [desinteres_ciencia]),

    pregunta('Te gustan los animales y su cuidado?',
             [animales, cuidado, responsabilidad],
             [rechazo_animales]),

    pregunta('Te gusta leer, escribir y debatir ideas?',
             [lectura, escritura, argumentacion, debate],
             [rechazo_lectura, rechazo_debate]),

    pregunta('Te atrae el liderazgo y los negocios?',
             [liderazgo, negocios, estrategia, organizacion],
             [rechazo_liderazgo, desinteres_negocios]),

    pregunta('Te gusta el dibujo, el diseno y la creatividad?',
             [dibujo, diseno, creatividad, espacios],
             [rechazo_dibujo, poca_creatividad]),

    pregunta('Te gusta viajar y conocer otras culturas?',
             [viajar, cultura, idiomas],
             [rechazo_viajar]),

    pregunta('Te gustan los numeros y las finanzas?',
             [numeros, finanzas, orden, detalle],
             [rechazo_numeros, desinteres_finanzas]),

    pregunta('Te gusta comunicarte y escuchar a los demas?',
             [comunicacion, escuchar, empatia],
             [poca_comunicacion, poca_empatia])
]).

% ============================================================
%  LECTURA DE ENTRADA
% ============================================================

% leer_entrada(-Texto)
leer_entrada(Texto) :-
    write('Usuario: '),
    read_line_to_string(user_input, Texto).

% leer_con_reintento(-Intencion)
% Rechaza respuestas de una sola palabra (si/no directo).
% Pide repetir si la gramatica no reconoce la oracion.
leer_con_reintento(Intencion) :-
    leer_entrada(Texto),
    atomizar(Texto, Tokens),
    length(Tokens, L),
    (   L < 2
    ->  nl,
        writeln('OrientadorCE: El sistema no acepta si/no directamente.'),
        writeln('              Por favor responde con una oracion completa.'),
        nl,
        leer_con_reintento(Intencion)
    ;   parsear(Texto, I),
        (   I = desconocido
        ->  nl,
            writeln('OrientadorCE: Me puedes repetir, no entendi.'),
            nl,
            leer_con_reintento(Intencion)
        ;   Intencion = I
        )
    ).

% ============================================================
%  FLUJO DE CONVERSACION
% ============================================================

% actualizar_perfil(+RasgosAfirm, +RasgosNeg, +Intencion,
%                   +PerfilIn, -PerfilOut)
% Agrega los rasgos correctos al perfil segun la intencion
% detectada por el parser.
actualizar_perfil(RasgosAfirm, _, afirmativo, Perfil, NuevoPerfil) :-
    append(RasgosAfirm, Perfil, NuevoPerfil).
actualizar_perfil(_, RasgosNeg, negativo, Perfil, NuevoPerfil) :-
    append(RasgosNeg, Perfil, NuevoPerfil).

% procesar_preguntas(+Preguntas, +PerfilAcum, -PerfilFinal)
% Recorre la lista de preguntas, parsea cada respuesta
% y acumula el perfil del usuario.
procesar_preguntas([], Perfil, Perfil).
procesar_preguntas([pregunta(Q, Afirm, Neg) | Resto], Perfil0, PerfilFinal) :-
    nl,
    format('OrientadorCE: ~w~n', [Q]),
    leer_con_reintento(Intencion),
    actualizar_perfil(Afirm, Neg, Intencion, Perfil0, Perfil1),
    procesar_preguntas(Resto, Perfil1, PerfilFinal).

% ============================================================
%  PUNTO DE ENTRADA
% ============================================================

% iniciar/0
% Inicia la sesion del orientador vocacional.
% TODO: cuando Logic.pl este listo:
%   1. Descomentar los consult del inicio del archivo.
%   2. Reemplazar el stub de recomendacion por:
%      recomendar_carrera(Perfil, Carrera)
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
    procesar_preguntas(ListaPreguntas, [], Perfil),
    nl,
    % --- STUB: reemplazar con recomendar_carrera/2 de Logic.pl ---
    writeln('OrientadorCE: [STUB] Perfil acumulado:'),
    format('              ~w~n', [Perfil]),
    writeln('              (pendiente integracion con Logic.pl)'),
    nl.
