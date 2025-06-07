--- Les données locales

--- Stocke les matières corréspondant au niveau de l'étudiant
create table Matieres (
    id integer primary key autoincrement,
    nom text not null,
    niveau text not null,
    description text,
    created_at datetime default current_timestamp,
    updated_at datetime default current_timestamp
);

--- Stocke les chapitres des matières dans la table Matieres
create table Chapitres (
    id integer primary key autoincrement,
    matiere_id integer not null,
    nom text not null,
    description text,
    created_at datetime default current_timestamp,
    updated_at datetime default current_timestamp,
    foreign key (matiere_id) references Matieres(id) on delete cascade
);

--- Stocke les leçons des matières dans la table Chapitres
create table Lecons (
    id integer primary key autoincrement,
    chapitre_id integer not null,
    titre text not null,
    contenu text,
    created_at datetime default current_timestamp,
    updated_at datetime default current_timestamp,
    foreign key (chapitre_id) references Chapitres(id) on delete cascade
);

--- Stocke les exercices des leçons dans la table Lecons
create table Exercices (
    id integer primary key autoincrement,
    lecon_id integer not null,
    nom text not null,
    questions blob,
    created_at datetime default current_timestamp,
    updated_at datetime default current_timestamp,
    foreign key (lecon_id) references Lecons(id) on delete cascade
);

--- Stocke le résultat des exercices dans la table Exercices
--- réaliser par l'étudiant
create table Exercices_resultats (
    id integer primary key autoincrement,
    exercice_id integer not null,
    reponses blob not null,
    score integer not null,
    etat text not null,
    date_de_soumission datetime default current_timestamp,
    foreign key (exercice_id) references Exercices(id) on delete cascade
);

-- Recherche de chapitres par matière
CREATE INDEX idx_chapitres_matiere ON Chapitres(matiere_id);

-- Recherche de leçons par chapitre
CREATE INDEX idx_lecons_chapitre ON Lecons(chapitre_id);

-- Recherche d'exercices par leçon
CREATE INDEX idx_exercices_lecon ON Exercices(lecon_id);