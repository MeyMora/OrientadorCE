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

% --- Saludos ---
saludo --> [hola].
saludo --> [buenas].
saludo --> [hey].
saludo --> [saludos].

% --- Pronombres personales ---
pronombre --> [yo].
pronombre --> [mi].

% --- Articulos ---
articulo --> [el].
articulo --> [la].
articulo --> [los].
articulo --> [las].
articulo --> [un].
articulo --> [una].

% --- Adverbios de afirmacion directa ---
adv_afirmativo --> [claro].
adv_afirmativo --> [correcto].
adv_afirmativo --> [exacto].
adv_afirmativo --> [cierto].
adv_afirmativo --> [definitivamente].
adv_afirmativo --> [por, supuesto].
adv_afirmativo --> [mucho].
adv_afirmativo --> [bastante].

% --- Adverbios de negacion directa ---
adv_negativo --> [no].
adv_negativo --> [nunca].
adv_negativo --> [jamas].
adv_negativo --> [tampoco].
adv_negativo --> [para, nada].
adv_negativo --> [poco].
adv_negativo --> [en, absoluto].

% --- Marcador de negacion preverbal ---
negacion --> [no].
negacion --> [nunca].
negacion --> [jamas].

% --- Clitico: pronombre atono, puede ser vacio (epsilon) ---
% Permite reconocer: "me gusta", "te encanta", o solo "gusta"
clitico --> [me].
clitico --> [te].
clitico --> [le].
clitico --> [se].
clitico --> [].

% --- Verbos con intencion afirmativa ---
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

% --- Verbos con intencion negativa ---
verbo_negativo --> [odio].
verbo_negativo --> [detesto].
verbo_negativo --> [aborrezco].
verbo_negativo --> [molesta].
verbo_negativo --> [molestan].
verbo_negativo --> [aburre].
verbo_negativo --> [aburren].
verbo_negativo --> [soporto].    % "no soporto"
verbo_negativo --> [podria].     % "no podria imaginarme..."
verbo_negativo --> [puedo].      % "no puedo con..."
