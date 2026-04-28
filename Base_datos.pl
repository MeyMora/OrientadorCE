% ==========================
% Base de datos OrientadorCE
% ==========================

% carrera(NombreCarrera, Afinidades, Antagonias).
% Cada carrera contiene una lista de afinidades y una lista de
% antagonias

carrera(ingenieria_computadores,
    [matematicas, tecnologia, programacion, logica, resolver_problemas],
    [rechazo_tecnologia, rechazo_matematicas, no_resuelve_problemas]).

carrera(medicina,
    [ciencia, biologia, ayudar, salud, personas],
    [rechazo_personas, poca_paciencia, rechazo_sangre]).

carrera(derecho,
    [lectura, argumentacion, debate, justicia, comunicacion, analisis],
    [rechazo_lectura, rechazo_debate, poca_comunicacion, desinteres_justicia]).

carrera(arquitectura,
    [dibujo, diseno, espacios, creatividad, matematica_basica],
    [rechazo_dibujo, poca_creatividad, rechazo_diseno, rechazo_espacios]).

carrera(administracion_empresas,
    [liderazgo, negocios, organizacion, comunicacion, estrategia],
    [desinteres_negocios, poca_organizacion, rechazo_liderazgo, poca_comunicacion]).

carrera(contabilidad,
    [numeros, orden, finanzas, detalle, analisis],
    [rechazo_numeros, desorden, desinteres_finanzas]).

carrera(psicologia,
    [personas, escuchar, ayudar, empatia, comunicacion],
    [rechazo_personas, poca_paciencia, poca_empatia, poca_comunicacion]).

carrera(veterinaria,
    [animales, ciencia, cuidado, responsabilidad, paciencia, salud],
    [rechazo_animales, poca_paciencia, desinteres_ciencia]).

carrera(turismo,
    [viajar, idiomas, personas, cultura, comunicacion],
    [rechazo_viajar, rechazo_personas, desinteres_cultura]).

carrera(periodismo,
    [comunicacion, investigacion, escritura, actualidad, curiosidad],
    [desinteres_investigacion, rechazo_escritura, poca_curiosidad, poca_comunicacion]).
