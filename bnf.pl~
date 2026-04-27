% ==========================
% BNF.pl - Parser con DCG
% ==========================

% --------------------------------------------------
% oracion(-Resultado)
% Regla principal del parser.
% Analiza una lista de palabras y devuelve una
% estructura: intencion(Afirmacion, Tema).
% --------------------------------------------------

oracion(intencion(I, T)) -->
    sintagma_nominal,
    sintagma_verbal(I, T).

oracion(intencion(I, T)) -->
    sintagma_verbal(I, T).

% Respuestas cortas (sin estructura completa)
oracion(intencion(afirmativo, desconocido)) --> [si].
oracion(intencion(afirmativo, desconocido)) --> [si, mucho].
oracion(intencion(negativo, desconocido)) --> [no].
oracion(intencion(negativo, desconocido)) --> [no, mucho].

% Negaciones más naturales
oracion(intencion(negativo, T)) -->
    [no],
    sintagma_verbal(_, T).
