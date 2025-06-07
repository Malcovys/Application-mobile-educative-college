--- Les données locales

--- Stocke les matières corréspondant au niveau de l'étudiant
create table Matieres (
    id integer primary key,
    nom text not null,
    niveau text not null,
    description text,
    created_at datetime not null,
    updated_at datetime not null,
    unique(nom, niveau) -- Assure que le nom de la matière est unique pour chaque niveau
);

--- Stocke les chapitres des matières dans la table Matieres
create table Chapitres (
    id integer primary key,
    matiere_id integer not null,
    nom text not null,
    description text,
    created_at datetime not null,
    updated_at datetime not null,
    unique(nom, matiere_id), -- Assure que le nom du chapitre est unique pour chaque matière
    foreign key (matiere_id) references Matieres(id) on delete cascade
);

--- Stocke les leçons des matières dans la table Chapitres
create table Lecons (
    id integer primary key,
    chapitre_id integer not null,
    titre text not null,
    contenu text,
    created_at datetime not null,
    updated_at datetime not null,
    unique(titre, chapitre_id), -- Assure que le titre de la leçon est unique pour chaque chapitre
    foreign key (chapitre_id) references Chapitres(id) on delete cascade
);

--- Stocke les exercices des leçons dans la table Lecons
create table Exercices (
    id integer primary key,
    lecon_id integer not null,
    nom text not null,
    questions blob,
    created_at datetime not null,
    updated_at datetime not null,
    unique(nom, lecon_id), -- Assure que le nom de l'exercice est unique pour chaque leçon
    foreign key (lecon_id) references Lecons(id) on delete cascade
);

--- Stocke le résultat des exercices dans la table Exercices
--- réaliser par l'étudiant
create table Exercices_resultats (
    id integer primary key,
    exercice_id integer not null,
    reponses blob not null,
    score integer not null,
    etat text not null,
    date_de_soumission datetime not null default current_timestamp,
    foreign key (exercice_id) references Exercices(id) on delete cascade
);

-- Recherche de chapitres par matière
CREATE INDEX idx_chapitres_matiere ON Chapitres(matiere_id);

-- Recherche de leçons par chapitre
CREATE INDEX idx_lecons_chapitre ON Lecons(chapitre_id);

-- Recherche d'exercices par leçon
CREATE INDEX idx_exercices_lecon ON Exercices(lecon_id);