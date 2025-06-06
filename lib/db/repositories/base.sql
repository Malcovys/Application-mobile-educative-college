--- Base de donnée Global

create table Utilisateurs (
    id integer primary key autoincrement,
    nom_complet text not null,
    email text not null unique,
    mot_de_passe text not null,
    created_at datetime default current_timestamp,
    updated_at datetime default current_timestamp
);

create table Matieres (
    id integer primary key autoincrement,
    nom text not null,
    niveau text not null,
    description text,
    etat text not null,
    created_at datetime default current_timestamp,
    updated_at datetime default current_timestamp
);

create table Chapitres (
    id integer primary key autoincrement,
    matiere_id integer not null,
    nom text not null,
    etat text not null,
    description text,
    created_at datetime default current_timestamp,
    updated_at datetime default current_timestamp,
    foreign key (matiere_id) references Matieres(id) on delete cascade
);

create table Lecons (
    id integer primary key autoincrement,
    chapitre_id integer not null,
    titre text not null,
    etat text not null,
    contenu text,
    created_at datetime default current_timestamp,
    updated_at datetime default current_timestamp,
    foreign key (chapitre_id) references Chapitres(id) on delete cascade
);

create table Exercices (
    id integer primary key autoincrement,
    lecon_id integer not null,
    nom text not null,
    etat text not null,
    questions blob,
    created_at datetime default current_timestamp,
    updated_at datetime default current_timestamp,
    foreign key (lecon_id) references Lecons(id) on delete cascade
);

create table Simulations_examen (
    id integer primary key autoincrement,
    matiere_id integer not null,
    nom text not null,
    questions blob,
    etat text not null,
    duree integer,
    date_simulation datetime,
    created_at datetime default current_timestamp,
    updated_at datetime default current_timestamp,
    foreign key (matiere_id) references Matieres(id) on delete cascade
);

create table Simulations_examen_resultats (
    id integer primary key autoincrement,
    simulation_examen_id integer not null,
    etudiant_id integer not null,
    reponses blob not null,
    score integer not null,
    date_de_soumission datetime default current_timestamp,
    foreign key (etudiant_id) references Utilisateurs(id) on delete cascade,
    foreign key (simulation_examen_id) references Simulations_examen(id) on delete cascade
);

create table Exercices_resultats (
    id integer primary key autoincrement,
    exercice_id integer not null,
    etudiant_id integer not null,
    reponses blob not null,
    score integer not null,
    date_de_soumission datetime default current_timestamp,
    foreign key (etudiant_id) references Utilisateurs(id) on delete cascade,
    foreign key (exercice_id) references Exercices(id) on delete cascade
);

-- Recherche de chapitres par matière
CREATE INDEX idx_chapitres_matiere ON Chapitres(matiere_id);

-- Recherche de leçons par chapitre
CREATE INDEX idx_lecons_chapitre ON Lecons(chapitre_id);

-- Recherche d'exercices par leçon
CREATE INDEX idx_exercices_lecon ON Exercices(lecon_id);

-- Recherche de simulations par matière
CREATE INDEX idx_simulations_matiere ON Simulations_examen(matiere_id);