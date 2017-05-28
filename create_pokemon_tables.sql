CREATE TABLE type (
    type VARCHAR(10) PRIMARY KEY NOT NULL
);

INSERT INTO type 
    (type) 
VALUES 
    ("Normal"),
    ("Fighting"),
    ("Flying"),
    ("Poison"),
    ("Ground"),
    ("Rock"),
    ("Bug"),
    ("Ghost"),
    ("Steel"),
    ("Fire"),
    ("Water"),
    ("Grass"),
    ("Electric"),
    ("Psychic"),
    ("Ice"),
    ("Dragon"),
    ("Dark"),
    ("Fairy");

CREATE TABLE pokemon(
    pokedex_number INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    speed INT NOT NULL,
    special_defence INo NOT NULL,
    type
    special_attack INT NOT NULL,
    defence INT NOT NULL,
    attack INT NOT NULL,
    hp INT NOT NULL,
    primary_type VARCHAR(10) NOT NULL,
    secondary_type VARCHAR(10),
    UNIQUE(name),
    PRIMARY KEY (pokedex_number),
    FOREIGN KEY (primary_type) REFERENCES type(type),
    FOREIGN KEY (secondary_type) REFERENCES type(type)
);