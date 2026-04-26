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
% Cubren casos como "claro que si", "por supuesto", "mucho"
adv_afirmativo --> [claro].
adv_afirmativo --> [correcto].
adv_afirmativo --> [exacto].
adv_afirmativo --> [cierto].
adv_afirmativo --> [definitivamente].
adv_afirmativo --> [por, supuesto].
adv_afirmativo --> [mucho].
adv_afirmativo --> [bastante].

% --- Adverbios de negacion directa ---
% Cubren casos como "no mucho", "para nada", "nunca"
adv_negativo --> [no].
adv_negativo --> [nunca].
adv_negativo --> [jamas].
adv_negativo --> [tampoco].
adv_negativo --> [para, nada].
adv_negativo --> [poco].
adv_negativo --> [en, absoluto].

% --- Marcador de negacion preverbal ---
% Se usa para construir sv_neg: "no me gusta", "nunca podria"
negacion --> [no].
negacion --> [nunca].
negacion --> [jamas].
