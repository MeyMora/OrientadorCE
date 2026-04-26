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
% Convierte el texto del usuario a lista de atomos en minuscula.
% Elimina signos de puntuacion y espacios extra.
atomizar(Texto, Tokens) :-
    string_lower(Texto, Lower),
    split_string(Lower, " ,!?.;:()", " ", Partes),
    exclude([P]>>(P = ""), Partes, Limpias),
    maplist([S, A]>>(atom_string(A, S)), Limpias, Tokens).

% parsear(+Texto, -Intencion)
% Aplica la gramatica DCG al texto del usuario.
% Intencion unifica con: afirmativo | negativo | desconocido
parsear(Texto, Intencion) :-
    atomizar(Texto, Tokens),
    (   once(phrase(oracion(I), Tokens))
    ->  Intencion = I
    ;   Intencion = desconocido
    ).
