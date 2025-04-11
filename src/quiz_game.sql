--create database
-- CREATE DATABASE quiz_game;

-- -- go into databse
-- \c quiz_game

-- create table topic
CREATE TABLE IF NOT EXISTS topics (
    topic_id SERIAL PRIMARY KEY,
    topic_name VARCHAR(50) NOT NULL UNIQUE,
    topic_description TEXT
);

-- create table module
CREATE TABLE IF NOT EXISTS modules (
    module_id SERIAL PRIMARY KEY,
    topic_id INTEGER NOT NULL,
    module_name VARCHAR(50) NOT NULL UNIQUE,
    module_description TEXT,

    CONSTRAINT fk_module_topic
        FOREIGN KEY (topic_id) 
        REFERENCES topics(topic_id)
        ON DELETE CASCADE
);
-- create table submodule
CREATE TABLE IF NOT EXISTS submodules (
    submodule_id SERIAL PRIMARY KEY,
    module_id INTEGER NOT NULL,
    submodule_name VARCHAR(50) NOT NULL UNIQUE,
    submodule_description TEXT,

    CONSTRAINT fk_submodule_module
        FOREIGN KEY (module_id) 
        REFERENCES modules(module_id)
        ON DELETE CASCADE
);

-- create type ENUM for the question difficulty
CREATE TYPE difficulty_level as ENUM('easy', 'medium', 'hard');

-- create table question
CREATE TABLE IF NOT EXISTS questions(
    question_id SERIAL PRIMARY KEY,
    submodule_id INTEGER, -- allow null values to create questions without a topic
    question_text TEXT NOT NULL,
    difficulty difficulty_level NOT NULL,
    explanation TEXT NOT NULL, --provide clarity and understanding regarding the correct answer.
    hint TEXT NOT NULL, -- hint for the user to get the right answer

    CONSTRAINT fk_questions_submmodule
        FOREIGN KEY (submodule_id)
        REFERENCES submodules(submodule_id)
        ON DELETE CASCADE
);

-- create table answers
CREATE TABLE IF NOT EXISTS answers(
    answer_id SERIAL PRIMARY KEY,
    question_id INTEGER NOT NULL,
    answer TEXT NOT NULL,
    right_answer BOOLEAN NOT NULL,

    CONSTRAINT fk_questions_answers
        FOREIGN KEY (question_id)
        REFERENCES questions(question_id)
        ON DELETE CASCADE

);

-- create table users
CREATE TABLE IF NOT EXISTS users(
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    total_score INTEGER DEFAULT 0, 
    last_score INTEGER DEFAULT 0,
    total_matchs INTEGER DEFAULT 0,
    logged BOOLEAN
);

-- enables the cryptographic functions in your PostgreSQL database.
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- create table user_log
CREATE TABLE IF NOT EXISTS user_log(
    user_id INT UNIQUE NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,

    CONSTRAINT fk_users_userlog
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE -- remove logs automatically if the user is deleted
);

-- Insert values into users table
INSERT INTO users (name) VALUES 
('admin'),
('hector');

-- Insert values into user_log table
INSERT INTO user_log (user_id,username, hashed_password) VALUES 
(1, 'admin', crypt('admin9!!', gen_salt('bf'))),
(2, 'hector', crypt('hbassas', gen_salt('bf')));

-- Insert values into topics table
INSERT INTO topics (topic_name, topic_description) VALUES
('Biology', 'The study of life and living organisms'),
('Physics', 'The science of matter, energy, space, and time'),
('Literature', 'Written works, especially those considered of superior or lasting artistic merit'),
('Computer Science', 'The study of computation and information'),
('Geography', 'The study of the Earth and its features, inhabitants, and phenomena');

-- Insert values into modules table for Biology
INSERT INTO modules (topic_id, module_name, module_description) VALUES
(1, 'Cell Biology', 'The study of cell structure and function'),
(1, 'Genetics', 'The study of heredity and variation'),
(1, 'Ecology', 'The study of organisms and their interactions with the environment');

-- Insert values into modules table for Physics
INSERT INTO modules (topic_id, module_name, module_description) VALUES
(2, 'Mechanics', 'The study of motion and forces'),
(2, 'Thermodynamics', 'The study of heat and its relation to other forms of energy'),
(2, 'Electromagnetism', 'The study of electric and magnetic fields');

-- Insert values into modules table for Literature
INSERT INTO modules (topic_id, module_name, module_description) VALUES
(3, 'Shakespearean Plays', 'Analysis of Shakespeares major works'),
(3, 'Modern Novels', 'Study of novels from the 20th and 21st centuries'),
(3, 'Poetry Analysis', 'Techniques and interpretation of poetry');

-- Insert values into modules table for Computer Science
INSERT INTO modules (topic_id, module_name, module_description) VALUES
(4, 'Algorithms', 'Study of efficient problem-solving methods'),
(4, 'Databases', 'Principles of database design and management'),
(4, 'Web Development', 'Fundamentals of building websites and web applications');

-- Insert values into modules table for Geography
INSERT INTO modules (topic_id, module_name, module_description) VALUES
(5, 'Physical Geography', 'Study of Earths natural features and processes'),
(5, 'Human Geography', 'Study of human societies and their interactions with the environment'),
(5, 'Cartography', 'The art and science of making maps');

-- Insert values into submodules table for Cell Biology
INSERT INTO submodules (module_id, submodule_name, submodule_description) VALUES
(1, 'Cell Membrane', 'Structure and function of the plasma membrane'),
(1, 'Organelles', 'Different types of organelles within a cell'),
(1, 'Cellular Respiration', 'The process of energy production in cells');

-- Insert values into submodules table for Genetics
INSERT INTO submodules (module_id, submodule_name, submodule_description) VALUES
(2, 'DNA Structure', 'The double helix and genetic code'),
(2, 'Mendelian Genetics', 'Principles of inheritance'),
(2, 'Mutations', 'Changes in DNA sequence and their effects');

-- Insert values into submodules table for Ecology
INSERT INTO submodules (module_id, submodule_name, submodule_description) VALUES
(3, 'Food Webs', 'Interconnected food chains in an ecosystem'),
(3, 'Biomes', 'Major types of ecosystems on Earth'),
(3, 'Population Dynamics', 'Factors affecting population size and growth');

-- Insert values into submodules table for Mechanics
INSERT INTO submodules (module_id, submodule_name, submodule_description) VALUES
(4, 'Newtons Laws of Motion', 'Fundamental principles of classical mechanics'),
(4, 'Work and Energy', 'Concepts of work, potential energy, and kinetic energy'),
(4, 'Projectile Motion', 'The motion of objects under gravity');

-- Insert values into submodules table for Thermodynamics
INSERT INTO submodules (module_id, submodule_name, submodule_description) VALUES
(5, 'Laws of Thermodynamics', 'Fundamental principles governing energy transfer'),
(5, 'Heat Transfer', 'Conduction, convection, and radiation'),
(5, 'Entropy', 'A measure of disorder in a system');

-- Insert values into submodules table for Electromagnetism
INSERT INTO submodules (module_id, submodule_name, submodule_description) VALUES
(6, 'Electric Fields', 'The region around an electric charge that exerts force'),
(6, 'Magnetic Fields', 'The region around a magnet or current-carrying wire that exerts force'),
(6, 'Electromagnetic Induction', 'The production of an electric current by changing magnetic fields');

-- Insert values into submodules table for Shakespearean Plays
INSERT INTO submodules (module_id, submodule_name, submodule_description) VALUES
(7, 'Hamlet', 'Analysis of the tragedy of Prince Hamlet'),
(7, 'Macbeth', 'Study of ambition and its consequences'),
(7, 'Romeo and Juliet', 'The classic tale of star-crossed lovers');

-- Insert values into submodules table for Modern Novels
INSERT INTO submodules (module_id, submodule_name, submodule_description) VALUES
(8, 'To Kill a Mockingbird', 'Themes of justice and prejudice'),
(8, '1984', 'Dystopian society and totalitarianism'),
(8, 'The Great Gatsby', 'The American Dream in the Jazz Age');

-- Insert values into submodules table for Poetry Analysis
INSERT INTO submodules (module_id, submodule_name, submodule_description) VALUES
(9, 'Imagery and Symbolism', 'Use of figurative language in poetry'),
(9, 'Poetic Forms', 'Different structures and styles of poetry'),
(9, 'Sound Devices', 'Rhyme, rhythm, and other auditory elements');

-- Insert values into submodules table for Algorithms
INSERT INTO submodules (module_id, submodule_name, submodule_description) VALUES
(10, 'Sorting Algorithms', 'Methods for arranging data in order'),
(10, 'Searching Algorithms', 'Techniques for finding specific data'),
(10, 'Big O Notation', 'Analyzing algorithm efficiency');

-- Insert values into submodules table for Databases
INSERT INTO submodules (module_id, submodule_name, submodule_description) VALUES
(11, 'Relational Databases', 'Structure and querying of relational data'),
(11, 'SQL Basics', 'Fundamental commands for database interaction'),
(11, 'Database Design', 'Principles of creating efficient database schemas');

-- Insert values into submodules table for Web Development
INSERT INTO submodules (module_id, submodule_name, submodule_description) VALUES
(12, 'HTML Fundamentals', 'Structure and content of web pages'),
(12, 'CSS Styling', 'Visual presentation and layout of web pages'),
(12, 'JavaScript Basics', 'Adding interactivity to web pages');

-- Insert values into submodules table for Physical Geography
INSERT INTO submodules (module_id, submodule_name, submodule_description) VALUES
(13, 'Plate Tectonics', 'Movement of Earths lithospheric plates'),
(13, 'Climate and Weather', 'Atmospheric conditions and patterns'),
(13, 'Landforms', 'Natural features of the Earths surface');

-- Insert values into submodules table for Human Geography
INSERT INTO submodules (module_id, submodule_name, submodule_description) VALUES
(14, 'Population Geography', 'Distribution, density, and migration of human populations'),
(14, 'Cultural Geography', 'The study of human cultures and their spatial organization'),
(14, 'Urban Geography', 'The study of cities and urbanization');

-- Insert values into submodules table for Cartography
INSERT INTO submodules (module_id, submodule_name, submodule_description) VALUES
(15, 'Map Projections', 'Methods of representing the Earths surface on a flat map'),
(15, 'Map Scales', 'The relationship between distances on a map and on the ground'),
(15, 'Thematic Mapping', 'Maps that focus on specific topics or themes');

-- Insert values into questions table for Cell Membrane
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(1, 'What is the primary function of the cell membrane?', 'easy', 'The cell membrane acts as a selective barrier, controlling what enters and exits the cell. It also helps maintain the cells shape and provides a surface for various cellular processes.', 'Think about the boundary of the cell.'),
(1, 'Which of the following is a major component of the cell membrane?', 'easy', 'The cell membrane is primarily composed of a phospholipid bilayer, with embedded proteins, carbohydrates, and cholesterol.', 'Consider the basic building blocks of the membrane.'),
(1, 'What does it mean for the cell membrane to be selectively permeable?', 'medium', 'Selectively permeable means that the cell membrane allows some substances to pass through easily, while others are restricted or require assistance.', 'Think about control over what moves in and out.'),
(1, 'How do large, polar molecules typically cross the cell membrane?', 'medium', 'Large, polar molecules usually require the help of transport proteins (channel or carrier proteins) to cross the hydrophobic interior of the cell membrane.', 'Consider molecules that dont easily mix with lipids.'),
(1, 'What role does cholesterol play in the cell membrane?', 'medium', 'Cholesterol helps to regulate the fluidity of the cell membrane, making it more stable at high temperatures and preventing it from solidifying at low temperatures.', 'Think about how temperature affects the membrane.'),
(1, 'What is the glycocalyx and what is its function?', 'hard', 'The glycocalyx is a carbohydrate layer on the outer surface of the cell membrane. It is involved in cell recognition, adhesion, and protection.', 'Consider the "sugar coating" on the cell.');

-- Insert values into questions table for Organelles
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(2, 'Which organelle is responsible for generating most of the cells ATP?', 'easy', 'The mitochondria are often referred to as the "powerhouses of the cell" because they are the primary site of cellular respiration, which produces ATP.', 'Think about energy production.'),
(2, 'What is the main function of the nucleus?', 'easy', 'The nucleus contains the cells genetic material (DNA) and controls the cells activities by regulating gene expression.', 'Consider the control center of the cell.'),
(2, 'Which organelle is involved in protein synthesis?', 'easy', 'Ribosomes are the sites of protein synthesis, where genetic information is translated into functional proteins.', 'Think about where proteins are made.'),
(2, 'What is the role of the endoplasmic reticulum (ER)?', 'medium', 'The ER is a network of membranes involved in protein and lipid synthesis, as well as detoxification. The rough ER has ribosomes and is involved in protein modification, while the smooth ER lacks ribosomes and is involved in lipid metabolism.', 'Consider a network involved in manufacturing.'),
(2, 'What is the function of the Golgi apparatus?', 'medium', 'The Golgi apparatus modifies, sorts, and packages proteins and lipids for secretion or delivery to other organelles.', 'Think about a cellular "post office".'),
(2, 'Lysosomes contain which type of enzymes?', 'medium', 'Lysosomes contain hydrolytic enzymes that break down waste materials and cellular debris.', 'Think about cellular digestion and recycling.');

-- Insert values into questions table for Cellular Respiration
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(3, 'What is the overall purpose of cellular respiration?', 'easy', 'The primary purpose of cellular respiration is to convert glucose and oxygen into ATP (adenosine triphosphate), which is the main energy currency of the cell.', 'Think about energy release from food.'),
(3, 'Which molecule is the primary fuel source for cellular respiration?', 'easy', 'Glucose is the main sugar molecule that is broken down during cellular respiration to produce ATP.', 'Consider the common sugar that provides energy.'),
(3, 'Where does glycolysis take place in the cell?', 'medium', 'Glycolysis occurs in the cytoplasm of the cell.', 'Think about the fluid-filled space within the cell.'),
(3, 'What are the end products of glycolysis?', 'medium', 'Glycolysis results in the production of two pyruvate molecules, two ATP molecules (net gain), and two NADH molecules.', 'Consider the molecules produced from glucose breakdown.'),
(3, 'Where does the Krebs cycle (citric acid cycle) occur in eukaryotic cells?', 'medium', 'The Krebs cycle takes place in the mitochondrial matrix.', 'Think about the inner compartment of the powerhouse organelle.'),
(3, 'What is the role of oxygen in aerobic respiration?', 'hard', 'Oxygen acts as the final electron acceptor in the electron transport chain, combining with electrons and hydrogen ions to form water. This allows the electron transport chain to continue generating the proton gradient necessary for ATP synthesis.', 'Consider the final step in energy production and what accepts the electrons.');

-- Insert values into questions table for DNA Structure
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(4, 'What are the building blocks of DNA?', 'easy', 'The building blocks of DNA are nucleotides, each consisting of a deoxyribose sugar, a phosphate group, and one of four nitrogenous bases: adenine (A), guanine (G), cytosine (C), and thymine (T).', 'Think about the basic units that make up the DNA molecule.'),
(4, 'Which nitrogenous base pairs with adenine (A) in DNA?', 'easy', 'In DNA, adenine (A) always pairs with thymine (T) through two hydrogen bonds.', 'Consider the specific pairings of the bases.'),
(4, 'What is the shape of a DNA molecule?', 'easy', 'A DNA molecule has a double helix structure, resembling a twisted ladder.', 'Think about the common visual representation of DNA.'),
(4, 'What type of bond holds the two strands of DNA together?', 'medium', 'The two strands of DNA are held together by hydrogen bonds between the nitrogenous bases.', 'Consider the weaker type of bond that allows for strand separation.'),
(4, 'What is the role of the phosphate group in the DNA backbone?', 'medium', 'The phosphate group forms part of the sugar-phosphate backbone of DNA, linking the 3 carbon of one deoxyribose sugar to the 5 carbon of the next.', 'Think about the structural component that connects the sugars.'),
(4, 'What is the central dogma of molecular biology?', 'hard', 'The central dogma of molecular biology describes the flow of genetic information: DNA -> RNA -> Protein. DNA is transcribed into RNA, which is then translated into protein.', 'Consider the main pathway of genetic information flow.');

-- Insert values into questions table for Mendelian Genetics
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(5, 'What is a gene?', 'easy', 'A gene is a unit of heredity that carries the instructions for a specific trait. It is a segment of DNA that codes for a functional product, such as a protein or RNA molecule.', 'Think about a unit of inheritance.'),
(5, 'What are alleles?', 'easy', 'Alleles are different versions of the same gene. For example, a gene for eye color might have alleles for blue eyes and brown eyes.', 'Consider different forms of a trait.'),
(5, 'What does it mean for an organism to be homozygous for a particular trait?', 'medium', 'An organism is homozygous for a trait if it has two identical alleles for that gene (e.g., BB or bb).', 'Think about having two of the same genetic variant.'),
(5, 'What does it mean for an organism to be heterozygous for a particular trait?', 'medium', 'An organism is heterozygous for a trait if it has two different alleles for that gene (e.g., Bb).', 'Think about having two different genetic variants.'),
(5, 'State Mendels Law of Segregation.', 'medium', 'The Law of Segregation states that during gamete formation, the two alleles for each gene separate so that each gamete carries only one allele for each gene.', 'Consider how alleles are passed on during reproduction.'),
(5, 'In a monohybrid cross between two heterozygous parents (Bb x Bb), what is the expected phenotypic ratio of the offspring if B is dominant over b?', 'hard', 'The expected phenotypic ratio is 3:1 (three offspring showing the dominant phenotype and one showing the recessive phenotype). This arises from the possible genotype combinations: BB, Bb, bB, and bb.', 'Use a Punnett square to visualize the allele combinations.');

-- Insert values into questions table for Mutations
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(6, 'What is a mutation?', 'easy', 'A mutation is a permanent change in the DNA sequence of an organism.', 'Think about a change in the genetic code.'),
(6, 'What is a point mutation?', 'easy', 'A point mutation is a change in a single nucleotide base in the DNA sequence.', 'Consider a change at a specific location.'),
(6, 'What is a frameshift mutation?', 'medium', 'A frameshift mutation occurs when the insertion or deletion of nucleotides is not a multiple of three, causing a shift in the reading frame of the genetic code and often leading to non-functional proteins.', 'Think about how the reading of codons is affected.'),
(6, 'What is a substitution mutation?', 'medium', 'A substitution mutation is a type of point mutation where one nucleotide base is replaced by another.', 'Consider one base being swapped for another.'),
(6, 'What are some potential causes of mutations?', 'medium', 'Mutations can arise spontaneously during DNA replication or can be induced by environmental factors called mutagens, such as radiation and certain chemicals.', 'Think about factors that can damage DNA.'),
(6, 'What are the possible effects of a mutation on an organism?', 'hard', 'The effects of mutations can range from no noticeable change to beneficial changes or harmful changes, including genetic disorders. The impact depends on the location and nature of the mutation and its effect on protein function.', 'Consider the spectrum of outcomes from a genetic change.');

-- Insert values into questions table for Food Webs
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(7, 'What is a food web?', 'easy', 'A food web is a complex network of interconnected food chains in an ecological community, showing the flow of energy between different organisms.', 'Think about a diagram showing "who eats whom".'),
(7, 'What is a producer in a food web?', 'easy', 'Producers are organisms that produce their own food, usually through photosynthesis (e.g., plants, algae). They form the base of the food web.', 'Consider organisms that make their own food.'),
(7, 'What are consumers in a food web?', 'easy', 'Consumers are organisms that obtain energy by feeding on other organisms. They can be herbivores (eat plants), carnivores (eat animals), or omnivores (eat both).', 'Think about organisms that need to eat.'),
(7, 'What is a decomposer in a food web?', 'medium', 'Decomposers (e.g., bacteria, fungi) break down dead organic matter, returning essential nutrients to the ecosystem.', 'Consider organisms that recycle nutrients.'),
(7, 'What is the role of arrows in a food web diagram?', 'medium', 'Arrows in a food web diagram indicate the direction of energy flow. They point from the organism being eaten to the organism that eats it.', 'Think about which way the energy is moving.'),
(7, 'What happens if a keystone species is removed from a food web?', 'hard', 'A keystone species has a disproportionately large effect on its environment relative to its abundance. Removing a keystone species can lead to significant changes in the food web structure and potentially cause ecosystem collapse.', 'Consider a species that holds the ecosystem together.');

-- Insert values into questions table for Biomes
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(8, 'What is a biome?', 'easy', 'A biome is a large-scale ecosystem characterized by specific climate conditions, vegetation types, and animal life.', 'Think about major types of environments on Earth.'),
(8, 'Which of the following is a major terrestrial biome?', 'easy', 'Major terrestrial biomes include forests (tropical, temperate, boreal), grasslands (savanna, temperate), deserts (hot, cold), tundra (arctic, alpine), and chaparral.', 'Consider broad categories of land environments.'),
(8, 'What are the defining characteristics of a tropical rainforest biome?', 'medium', 'Tropical rainforests are characterized by high temperatures, high rainfall, high biodiversity, and dense vegetation.', 'Think about hot, wet, and lush environments.'),
(8, 'What are the defining characteristics of a desert biome?', 'medium', 'Deserts are characterized by low precipitation, extreme temperature variations (hot during the day, cold at night in many), and sparse vegetation adapted to conserve water.', 'Think about dry environments.'),
(8, 'What is the difference between tundra and taiga (boreal forest)?', 'medium', 'Tundra is characterized by permafrost, low-growing vegetation (mosses, lichens, shrubs), and a short growing season. Taiga (boreal forest) has coniferous trees and a longer growing season than tundra.', 'Consider cold environments with different types of vegetation.'),
(8, 'How does altitude affect biome distribution?', 'hard', 'As altitude increases, temperature decreases, and precipitation patterns can change. This leads to a zonation of biomes on mountains, often mirroring the latitudinal distribution of biomes (e.g., base to peak: deciduous forest -> coniferous forest -> alpine tundra).', 'Think about how going up a mountain changes the environment.');

-- Insert values into questions table for Population Dynamics
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(9, 'What is population density?', 'easy', 'Population density is the number of individuals of a species per unit area or volume.', 'Think about how crowded a space is.'),
(9, 'What is carrying capacity?', 'easy', 'Carrying capacity is the maximum population size that an environment can sustainably support given the available resources.', 'Consider the limit of what the environment can handle.'),
(9, 'What are density-dependent limiting factors?', 'medium', 'Density-dependent limiting factors are factors that affect population growth more strongly as population density increases (e.g., competition for resources, predation, disease).', 'Think about factors that become more intense with more individuals.'),
(9, 'What are density-independent limiting factors?', 'medium', 'Density-independent limiting factors are factors that affect population growth regardless of population density (e.g., natural disasters, extreme weather).', 'Think about factors that affect everyone equally.'),
(9, 'What is exponential population growth?', 'medium', 'Exponential population growth occurs when a population increases at a constant rate, resulting in a J-shaped growth curve. This typically happens when resources are unlimited.', 'Think about rapid, unchecked growth.'),
(9, 'What is logistic population growth?', 'hard', 'Logistic population growth occurs when a populations growth rate slows as it approaches the carrying capacity, resulting in an S-shaped growth curve. It incorporates the effects of limiting factors.', 'Think about growth that levels off due to environmental limits.');

-- Insert values into questions table for Newtons Laws of Motion
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(10, 'What does Newtons First Law of Motion state?', 'easy', 'Newtons First Law (Law of Inertia) states that an object at rest stays at rest and an object in motion stays in motion with the same speed and in the same direction unless acted upon by an unbalanced force.', 'Think about objects resisting changes in their motion.'),
(10, 'What is inertia?', 'easy', 'Inertia is the tendency of an object to resist changes in its state of motion.', 'Think about an objects reluctance to start moving or stop moving.'),
(10, 'What does Newtons Second Law of Motion state?', 'easy', 'Newtons Second Law states that the acceleration of an object is directly proportional to the net force acting on the object and inversely proportional to its mass (F = ma).', 'Think about the relationship between force, mass, and acceleration.'),
(10, 'What are the units of force, mass, and acceleration in the SI system?', 'medium', 'Force is measured in Newtons (N), mass in kilograms (kg), and acceleration in meters per second squared (m/s²).', 'Consider the standard units used in physics.'),
(10, 'What does Newtons Third Law of Motion state?', 'medium', 'Newtons Third Law states that for every action, there is an equal and opposite reaction.', 'Think about forces acting in pairs.'),
(10, 'Explain the difference between mass and weight.', 'hard', 'Mass is a measure of the amount of matter in an object and is a scalar quantity. Weight is the force of gravity acting on an objects mass and is a vector quantity (weight = mass x acceleration due to gravity).', 'Consider the fundamental difference between the amount of "stuff" and the force acting on it.');

-- Insert values into questions table for Work and Energy
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(11, 'What is work in physics?', 'easy', 'In physics, work is done when a force acts on an object and causes a displacement in the direction of the force (Work = Force x displacement x cos(theta)).', 'Think about force causing movement.'),
(11, 'What is energy?', 'easy', 'Energy is the ability to do work.', 'Think about the capacity to cause change.'),
(11, 'What are the units of work and energy in the SI system?', 'easy', 'Both work and energy are measured in Joules (J).', 'Consider the standard unit for both concepts.'),
(11, 'What is potential energy?', 'medium', 'Potential energy is stored energy that an object possesses due to its position or configuration (e.g., gravitational potential energy, elastic potential energy).', 'Think about stored energy due to location or shape.'),
(11, 'What is kinetic energy?', 'medium', 'Kinetic energy is the energy of motion (Kinetic Energy = 1/2 x mass x velocity²).', 'Think about energy due to movement.'),
(11, 'State the work-energy theorem.', 'hard', 'The work-energy theorem states that the net work done on an object is equal to the change in its kinetic energy.', 'Consider the relationship between work and motion.');

-- Insert values into questions table for Projectile Motion
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(12, 'What is a projectile?', 'easy', 'A projectile is any object that is thrown or launched into the air and is subject only to the force of gravity (ignoring air resistance).', 'Think about an object moving through the air under gravity.'),
(12, 'What is the trajectory of a projectile?', 'easy', 'The trajectory of a projectile is the path it follows through the air, which is typically a parabolic curve.', 'Think about the shape of the path an object takes when thrown.'),
(12, 'What are the horizontal and vertical components of a projectiles velocity?', 'medium', 'A projectiles velocity can be broken down into independent horizontal (constant velocity if air resistance is ignored) and vertical (affected by gravity) components.', 'Consider the motion in two separate directions.'),
(12, 'What is the effect of gravity on the vertical motion of a projectile?', 'medium', 'Gravity causes a constant downward acceleration on the vertical component of a projectiles velocity, causing it to decrease as the projectile moves upward and increase as it moves downward.', 'Think about the force pulling the object down.'),
(12, 'What remains constant during the horizontal motion of a projectile (ignoring air resistance)?', 'medium', 'The horizontal component of a projectiles velocity remains constant because there is no horizontal force acting on it (ignoring air resistance).', 'Think about the motion in the sideways direction.'),
(12, 'What is the angle of projection for maximum range of a projectile on level ground (ignoring air resistance)?', 'hard', 'The angle of projection for maximum range on level ground is 45 degrees.', 'Consider the angle that makes the object travel the farthest.');

-- Insert values into questions table for Laws of Thermodynamics
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(13, 'What is the Zeroth Law of Thermodynamics?', 'easy', 'The Zeroth Law states that if two thermodynamic systems are each in thermal equilibrium with a third, then they are in thermal equilibrium with each other.', 'Think about the concept of temperature and equilibrium.'),
(13, 'What is the First Law of Thermodynamics?', 'easy', 'The First Law (Law of Conservation of Energy) states that energy cannot be created or destroyed, only transferred or changed from one form to another (ΔU = Q - W).', 'Think about the conservation of energy.'),
(13, 'What is internal energy (U)?', 'easy', 'Internal energy is the total energy stored within a system, including the kinetic and potential energies of its molecules.', 'Think about the energy contained within a substance.'),
(13, 'What is heat (Q) in thermodynamics?', 'medium', 'Heat is the transfer of thermal energy between systems due to a temperature difference.', 'Think about energy transfer due to temperature differences.'),
(13, 'What is work (W) in thermodynamics?', 'medium', 'Work is energy transferred when a force causes a displacement.', 'Think about energy transfer through mechanical means.'),
(13, 'What is the Second Law of Thermodynamics?', 'hard', 'The Second Law states that the total entropy of an isolated system can only increase over time or remain constant in ideal cases. It implies that spontaneous processes tend to increase disorder.', 'Think about the direction of natural processes and increasing disorder.');

-- Insert values into questions table for Heat Transfer
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(14, 'What is conduction?', 'easy', 'Conduction is the transfer of heat through direct contact between particles of matter, without any bulk movement of the material.', 'Think about heat transfer through a solid object.'),
(14, 'What is convection?', 'easy', 'Convection is the transfer of heat through the movement of fluids (liquids or gases) due to differences in density caused by temperature variations.', 'Think about heat transfer through moving fluids.'),
(14, 'What is radiation?', 'easy', 'Radiation is the transfer of heat through electromagnetic waves. It does not require a medium and can occur through a vacuum.', 'Think about heat transfer through space.'),
(14, 'Give an example of heat transfer by conduction.', 'medium', 'An example of conduction is the heating of a metal spoon when one end is placed in hot soup.', 'Consider heat moving through a stationary object.'),
(14, 'Give an example of heat transfer by convection.', 'medium', 'An example of convection is the circulation of hot air in a room from a radiator or the boiling of water in a pot.', 'Consider heat moving with a fluid.'),
(14, 'Give an example of heat transfer by radiation.', 'medium', 'An example of radiation is the heat from the sun warming the Earth or the heat felt from a fireplace.', 'Consider heat traveling as waves.');

-- Insert values into questions table for Entropy
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(15, 'What is entropy?', 'easy', 'Entropy is often described as a measure of the disorder or randomness of a system. It can also be related to the number of possible microscopic arrangements (microstates) for a given macroscopic state.', 'Think about the degree of disorder.'),
(15, 'According to the Second Law of Thermodynamics, what happens to the entropy of an isolated system over time?', 'easy', 'According to the Second Law, the entropy of an isolated system tends to increase over time for spontaneous processes.', 'Think about the natural tendency towards disorder.'),
(15, 'Is entropy a state function or a path function?', 'medium', 'Entropy is a state function, meaning its value depends only on the current state of the system, not on the path taken to reach that state.', 'Consider if the history matters for the value.'),
(15, 'What happens to the entropy of the universe during a spontaneous process?', 'medium', 'During a spontaneous process, the total entropy of the universe (system + surroundings) always increases.', 'Think about the overall trend of disorder in the universe.'),
(15, 'Give an example of a process where entropy increases.', 'medium', 'Examples of processes where entropy increases include ice melting, a gas expanding into a vacuum, and the mixing of two different gases.', 'Consider processes that become more disordered naturally.'),
(15, 'How is entropy related to the availability of useful energy?', 'hard', 'Entropy is related to the degradation of energy. As entropy increases, the amount of energy available to do useful work decreases.', 'Think about the connection between disorder and usable energy.');

-- Insert values into questions table for Electric Fields
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(16, 'What is an electric field?', 'easy', 'An electric field is a region around an electrically charged object where a force would be exerted on other electrically charged objects.', 'Think about the influence of a charge on its surroundings.'),
(16, 'What is the direction of the electric field lines around a positive charge?', 'easy', 'Electric field lines point radially outward from a positive charge.', 'Consider the direction of the force on a positive test charge.'),
(16, 'What is the direction of the electric field lines around a negative charge?', 'easy', 'Electric field lines point radially inward towards a negative charge.', 'Consider the direction of the force on a positive test charge.'),
(16, 'What is the unit of electric field strength?', 'medium', 'The unit of electric field strength is Newtons per Coulomb (N/C) or Volts per meter (V/m).', 'Consider the force per unit charge.'),
(16, 'How does the strength of the electric field vary with distance from a point charge?', 'medium', 'The strength of the electric field due to a point charge is inversely proportional to the square of the distance from the charge (E ∝ 1/r²).', 'Think about how the field weakens with distance.'),
(16, 'What happens to electric field lines when they encounter a conductor in electrostatic equilibrium?', 'hard', 'Electric field lines are perpendicular to the surface of a conductor in electrostatic equilibrium and the electric field inside the conductor is zero.', 'Consider the behavior of charges in a conductor.');

-- Insert values into questions table for Magnetic Fields
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(17, 'What creates a magnetic field?', 'easy', 'Magnetic fields are created by moving electric charges (electric current) and by intrinsic magnetic moments of elementary particles like electrons.', 'Think about what causes magnetism.'),
(17, 'What are magnetic field lines?', 'easy', 'Magnetic field lines are imaginary lines that represent the direction and strength of a magnetic field. They form closed loops.', 'Think about a way to visualize a magnetic field.'),
(17, 'What is the direction of the magnetic field around a straight current-carrying wire?', 'medium', 'The direction of the magnetic field around a straight current-carrying wire is given by the right-hand rule: if you point your thumb in the direction of the current, your fingers curl in the direction of the magnetic field.', 'Consider the rule for finding the field direction.'),
(17, 'What is the unit of magnetic field strength (magnetic flux density)?', 'medium', 'The unit of magnetic field strength (magnetic flux density) is the Tesla (T).', 'Consider the standard unit for magnetic field strength.'),
(17, 'What is the force on a moving charged particle in a magnetic field?', 'medium', 'The force on a moving charged particle in a magnetic field is given by the Lorentz force law: F = q(v x B), where q is the charge, v is the velocity, and B is the magnetic field. The force is perpendicular to both the velocity and the magnetic field.', 'Think about the force on a moving charge in a magnetic field.');

-- Insert values into questions table for Electromagnetic Induction
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(18, 'What is electromagnetic induction?', 'easy', 'Electromagnetic induction is the production of an electromotive force (and thus an electric current) across an electrical conductor in a changing magnetic field.', 'Think about how magnetism can create electricity.'),
(18, 'Who is credited with the discovery of electromagnetic induction?', 'easy', 'Michael Faraday is generally credited with the discovery of electromagnetic induction in 1831.', 'Consider the famous scientist associated with this phenomenon.'),
(18, 'What is Faradays Law of Induction?', 'medium', 'Faradays Law states that the magnitude of the induced electromotive force (EMF) in any closed circuit is equal to the time rate of change of the magnetic flux through the circuit.', 'Think about the relationship between EMF and changing magnetic flux.'),
(18, 'What is magnetic flux?', 'medium', 'Magnetic flux is a measure of the total magnetic field that passes through a given area. It is proportional to the number of magnetic field lines that pass through that area.', 'Think about the amount of magnetic field passing through a surface.'),
(18, 'What is Lenzs Law?', 'medium', 'Lenzs Law states that the direction of the induced current in a closed loop is such that it opposes the change in magnetic flux that produced it.', 'Think about the direction of the induced current and its effect on the magnetic field.'),
(18, 'In which of the following devices is electromagnetic induction a fundamental principle of operation?', 'hard', 'Electromagnetic induction is a fundamental principle in the operation of electric generators, transformers, and induction motors.', 'Consider devices that generate electricity or change voltage using magnetism.');

-- Insert values into questions table for Hamlett
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(19, 'Who is the protagonist of Hamlet?', 'easy', 'Hamlet, Prince of Denmark, is the central character of the play.', 'Think of the title character.'),
(19, 'What is the ghosts primary demand of Hamlet?', 'easy', 'The ghost demands that Hamlet avenge his murder by killing Claudius.', 'Consider the ghosts reason for appearing.'),
(19, 'Who is Ophelia in relation to Hamlet?', 'easy', 'Ophelia is Hamlets lover.', 'Think of Hamlets romantic interest.'),
(19, 'How does Claudius die?', 'medium', 'Claudius is killed by Hamlet, who forces him to drink poison and then stabs him with a poisoned sword.', 'Consider the climax of the play.'),
(19, 'What is the famous "To be or not to be" soliloquy about?', 'medium', 'The soliloquy is a meditation on life and death, and the question of whether it is nobler to endure suffering or to take action against it.', 'Think of Hamlets contemplation of existence.'),
(19, 'What is the significance of the play within a play, "The Mousetrap"?', 'hard', '"The Mousetrap" is used by Hamlet to gauge Claudiuss guilt by observing his reaction to a reenactment of the murder.', 'Consider Hamlets strategy to confirm the ghosts story.');

-- Insert values into questions table for Macbeth
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(20, 'What are the prophecies given to Macbeth by the witches?', 'easy', 'The witches prophesy that Macbeth will become Thane of Glamis, Thane of Cawdor, and eventually King of Scotland.', 'Consider the witches initial predictions.'),
(20, 'Who is Duncan in the play?', 'easy', 'Duncan is the King of Scotland at the beginning of the play.', 'Think of the ruler Macbeth murders.'),
(20, 'Who encourages Macbeth to kill Duncan?', 'easy', 'Lady Macbeth strongly encourages Macbeth to kill Duncan.', 'Consider the ambitious wife.'),
(20, 'What vision does Macbeth see before killing Duncan?', 'medium', 'Macbeth sees a floating dagger pointing towards Duncans chamber.', 'Consider the supernatural hallucination.'),
(20, 'What is the significance of Banquos ghost?', 'medium', 'Banquos ghost haunts Macbeth, symbolizing his guilt and the consequences of his actions.', 'Consider the ghostly manifestation of Macbeths fear.'),
(20, 'How is Macbeth ultimately defeated?', 'hard', 'Macbeth is defeated and killed by Macduff, who was "untimely ripp" from his mothers womb and therefore not born of woman, fulfilling the witches prophecy.', 'Consider the final battle and the fulfillment of the prophecy.');

-- Insert values into questions table for Romeo and Juliet (assuming submodule_id = 21)
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(21, 'From which families do Romeo and Juliet come?', 'easy', 'Romeo is a Montague and Juliet is a Capulet.', 'Consider the feuding families.'),
(21, 'Where is the play primarily set?', 'easy', 'The play is set in Verona, Italy.', 'Think of the Italian city.'),
(21, 'Who is Mercutio?', 'easy', 'Mercutio is Romeos friend.', 'Consider the witty and fiery character.'),
(21, 'How do Romeo and Juliet meet?', 'medium', 'Romeo and Juliet meet at a Capulet feast.', 'Consider the setting of their first encounter.'),
(21, 'Why does Romeo kill Tybalt?', 'medium', 'Romeo kills Tybalt to avenge the death of Mercutio.', 'Consider the act that leads to Romeos banishment.'),
(21, 'How do Romeo and Juliet die?', 'hard', 'Romeo, believing Juliet is dead, drinks poison. Juliet, upon awakening and seeing Romeo dead, stabs herself with his dagger.', 'Consider the tragic ending.');

-- Insert values into questions table for To Kill a Mockingbird
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(22, 'Who is the narrator of "To Kill a Mockingbird"?', 'easy', 'Scout Finch is the narrator, telling the story from her childhood perspective.', 'Think about the young girl telling the story.'),
(22, 'What is Atticus Finchs profession?', 'easy', 'Atticus Finch is a lawyer.', 'Consider his role in the Tom Robinson case.'),
(22, 'Who is Tom Robinson accused of assaulting?', 'easy', 'Tom Robinson is accused of assaulting Mayella Ewell.', 'Think about the central legal case in the novel.'),
(22, 'What is Boo Radleys real first name?', 'medium', 'Boo Radleys real first name is Arthur.', 'Consider the mysterious neighbor.'),
(22, 'What does the mockingbird symbolize in the novel?', 'medium', 'The mockingbird symbolizes innocence and harmlessness.', 'Think about Atticuss warning about killing a mockingbird.'),
(22, 'What is the verdict in Tom Robinsons trial?', 'hard', 'Tom Robinson is found guilty by the jury.', 'Consider the outcome of the legal proceedings.');

-- Insert values into questions table for 1984 
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(23, 'Who is the protagonist of "1984"?', 'easy', 'Winston Smith is the protagonist, a member of the Outer Party.', 'Think about the main character rebelling against the system.'),
(23, 'Who is Big Brother?', 'easy', 'Big Brother is the enigmatic leader of the Party in Oceania.', 'Consider the symbol of totalitarian control.'),
(23, 'What is the Thought Police?', 'easy', 'The Thought Police are the secret police who detect and punish thoughtcrime.', 'Think about the enforcement of ideological conformity.'),
(23, 'What is Newspeak?', 'medium', 'Newspeak is the official language of Oceania, designed to limit thought by reducing vocabulary.', 'Consider the manipulation of language for control.'),
(23, 'What is Room 101?', 'medium', 'Room 101 is the place where the Party subjects prisoners to their worst fear.', 'Think about the ultimate form of torture.'),
(23, 'What happens to Winston at the end of the novel?', 'hard', 'Winston is broken by the Party and comes to love Big Brother.', 'Consider the tragic outcome of his rebellion.');

-- Insert values into questions table for The Great Gatsby 
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(24, 'Who is the narrator of "The Great Gatsby"?', 'easy', 'Nick Carraway is the narrator, a young Midwesterner who moves to West Egg.', 'Think about the observer of Gatsbys world.'),
(24, 'Who is Jay Gatsby in the novel?', 'easy', 'Jay Gatsby is a wealthy man living in West Egg, known for his lavish parties.', 'Consider the enigmatic millionaire.'),
(24, 'Who is Daisy Buchanan?', 'easy', 'Daisy Buchanan is Nicks cousin and the object of Gatsbys affection.', 'Think about the woman Gatsby is trying to win back.'),
(24, 'What is the "valley of ashes"?', 'medium', 'The valley of ashes is a desolate area between West Egg and New York City, representing the moral decay of society.', 'Consider the symbolic landscape of the novel.'),
(24, 'What does the green light at the end of Daisys dock symbolize for Gatsby?', 'medium', 'The green light symbolizes Gatsbys hopes and dreams, particularly his longing for Daisy.', 'Think about the object of Gatsbys desire.'),
(24, 'How does Gatsby die?', 'hard', 'Gatsby is shot and killed by George Wilson, who mistakenly believes Gatsby was responsible for Myrtles death.', 'Consider the tragic climax of the novel.');

-- Insert values into questions table for Imagery and Symbolism (assuming submodule_id = 25)
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(25, 'What is imagery in poetry?', 'easy', 'Imagery is descriptive language that appeals to the senses (sight, sound, touch, taste, smell) to create vivid pictures in the reader s mind.', 'Think about words that help you see or feel something.'),
(25, 'What is a symbol in poetry?', 'easy', 'A symbol is a word, object, or idea that represents something else, often something abstract.', 'Think about something that stands for more than itself.'),
(25, 'What is a metaphor?', 'medium', 'A metaphor is a figure of speech that directly compares two unlike things without using like or as.', 'Think of a direct comparison: Life is a journey.'),
(25, 'What is a simile?', 'medium', 'A simile is a figure of speech that compares two unlike things using like or as.', 'Think of a comparison using like or as: He is as strong as an ox.'),
(25, 'What is personification?', 'medium', 'Personification is giving human qualities or characteristics to inanimate objects or abstract ideas.', 'Think of giving human traits to non-human things: The wind whispered.'),
(25, 'How does imagery contribute to the overall meaning of a poem?', 'hard', 'Imagery can create mood, evoke emotion, establish setting, develop themes, and enhance the reader s understanding and experience of the poem.', 'Think about how sensory details affect the poem s impact.');

-- Insert values into questions table for Poetic Forms (assuming submodule_id = 26)
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(26, 'What is a sonnet?', 'easy', 'A sonnet is a 14-line poem with a specific rhyme scheme and meter.', 'Think of a short poem with a structured form.'),
(26, 'What is a haiku?', 'easy', 'A haiku is a Japanese form of poetry with three lines, typically with a 5-7-5 syllable structure.', 'Think of a very short poem often about nature.'),
(26, 'What is free verse poetry?', 'easy', 'Free verse poetry is poetry that does not adhere to a regular rhyme scheme or meter.', 'Think of poetry with no set rules for rhythm or rhyme.'),
(26, 'What is a ballad?', 'medium', 'A ballad is a narrative poem, often of folk origin, typically composed in quatrains with a simple rhyme scheme.', 'Think of a poem that tells a story, often song-like.'),
(26, 'What is an elegy?', 'medium', 'An elegy is a poem of serious reflection, typically a lament for the dead.', 'Think of a poem of mourning.'),
(26, 'How does poetic form influence the meaning and impact of a poem?', 'hard', 'Poetic form can constrain or liberate expression, emphasize certain ideas through structure, and create specific effects through rhythm and rhyme, shaping the reader s experience and interpretation.', 'Think about how the structure affects the message.');

-- Insert values into questions table for Sound Devices (assuming submodule_id = 27)
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(27, 'What is rhyme in poetry?', 'easy', 'Rhyme is the repetition of similar sounds, usually at the end of lines.', 'Think of words that sound alike.'),
(27, 'What is rhythm in poetry?', 'easy', 'Rhythm is the pattern of stressed and unstressed syllables in a line of poetry.', 'Think of the beat or flow of the poem.'),
(27, 'What is alliteration?', 'medium', 'Alliteration is the repetition of consonant sounds at the beginning of words in close proximity.', 'Think of repeated beginning sounds: Peter Piper picked...'),
(27, 'What is assonance?', 'medium', 'Assonance is the repetition of vowel sounds within words in close proximity.', 'Think of repeated vowel sounds: The cat sat on the mat.'),
(27, 'What is consonance?', 'medium', 'Consonance is the repetition of consonant sounds within or at the end of words in close proximity.', 'Think of repeated consonant sounds (not at the beginning): He struck a streak of bad luck.'),
(27, 'How do sound devices contribute to the overall effect of a poem?', 'hard', 'Sound devices can create musicality, emphasize certain words or ideas, establish mood, and enhance the emotional impact of the poem.', 'Think about how sounds affect the poem s feeling and memorability.');

-- Insert values into questions table for Sorting Algorithms (assuming submodule_id = 28)
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(28, 'What is the purpose of a sorting algorithm?', 'easy', 'The purpose of a sorting algorithm is to rearrange a collection of items into a specific order (e.g., ascending or descending).', 'Think about putting things in order.'),
(28, 'Which of the following is a comparison-based sorting algorithm?', 'easy', 'Comparison-based sorting algorithms compare elements to determine their relative order. Examples include bubble sort, insertion sort, and merge sort.', 'Consider algorithms that work by comparing items.'),
(28, 'What is the basic principle of bubble sort?', 'medium', 'Bubble sort repeatedly steps through the list, compares adjacent elements and swaps them if they are in the wrong order. The largest elements "bubble" to the end of the list.', 'Think about adjacent elements being compared and swapped.'),
(28, 'What is the time complexity of merge sort in the average case?', 'medium', 'Merge sort has a time complexity of O(n log n) in the average case, making it efficient for larger datasets.', 'Consider the efficiency of dividing and conquering.'),
(28, 'What is the advantage of quicksort over merge sort in some cases?', 'medium', 'Quicksort often has better average-case performance and can be implemented in-place (with minimal extra memory), unlike the typical implementation of merge sort.', 'Think about speed and memory usage.'),
(28, 'What is the difference between stable and unstable sorting algorithms?', 'hard', 'A stable sorting algorithm maintains the relative order of elements with equal values. An unstable sorting algorithm may change the relative order of equal elements.', 'Consider how equal items are handled during the sort.');

-- Insert values into questions table for Searching Algorithms (assuming submodule_id = 29)
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(29, 'What is the purpose of a searching algorithm?', 'easy', 'The purpose of a searching algorithm is to find a specific item within a collection of items.', 'Think about looking for something in a list.'),
(29, 'What is the basic principle of linear search?', 'easy', 'Linear search sequentially checks each element of the list until the target element is found or the end of the list is reached.', 'Think about checking one item at a time.'),
(29, 'What is the primary requirement for binary search to work efficiently?', 'medium', 'Binary search requires the collection of items to be sorted.', 'Consider the condition needed before you can use binary search.'),
(29, 'How does binary search work?', 'medium', 'Binary search repeatedly divides the search interval in half. If the middle element matches the target, the search is complete. Otherwise, the search continues in the half that could contain the target.', 'Think about repeatedly cutting the search space in half.'),
(29, 'What is the time complexity of binary search in the worst case?', 'medium', 'Binary search has a time complexity of O(log n) in the worst case, making it very efficient for searching sorted data.', 'Consider how quickly the search space is reduced.'),
(29, 'In what scenario would linear search be more appropriate than binary search?', 'hard', 'Linear search might be more appropriate for very small datasets or when the data is not sorted and sorting it would be more time-consuming than simply performing a linear search.', 'Think about situations where the overhead of sorting isnt worth it.');

-- Insert values into questions table for Big O Notation (assuming submodule_id = 30)
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(30, 'What does Big O notation describe?', 'easy', 'Big O notation describes the upper bound of the time or space complexity of an algorithm as the input size grows.', 'Think about how the algorithms performance scales.'),
(30, 'What does O(n) represent in Big O notation?', 'easy', 'O(n) represents linear time complexity, meaning the execution time grows directly proportional to the input size.', 'Consider an algorithm that processes each item once.'),
(30, 'What does O(1) represent in Big O notation?', 'easy', 'O(1) represents constant time complexity, meaning the execution time remains constant regardless of the input size.', 'Consider an algorithm that takes the same amount of time no matter the input.'),
(30, 'What does O(log n) represent in Big O notation?', 'medium', 'O(log n) represents logarithmic time complexity, meaning the execution time grows logarithmically with the input size (very efficient for large inputs).', 'Consider algorithms that repeatedly divide the problem size in half.'),
(30, 'What does O(n^2) represent in Big O notation?', 'medium', 'O(n^2) represents quadratic time complexity, meaning the execution time grows proportionally to the square of the input size (less efficient for large inputs).', 'Consider algorithms with nested loops iterating through all pairs of elements.'),
(30, 'When analyzing algorithm efficiency with Big O notation, what aspect is typically the primary focus?', 'hard', 'The primary focus is typically the asymptotic behavior, i.e., how the algorithms performance scales with very large input sizes, ignoring constant factors and lower-order terms.', 'Think about the performance for very large inputs.');

-- Insert values into questions table for Relational Databases (assuming submodule_id = 31)
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(31, 'What is a primary key in a relational database?', 'easy', 'A primary key is a column or set of columns that uniquely identifies each row in a table.', 'Think about the unique identifier for each record.'),
(31, 'What is a foreign key in a relational database?', 'easy', 'A foreign key is a column or set of columns in one table that refers to the primary key of another table, establishing a link between them.', 'Think about how tables are related.'),
(31, 'What is a relational database schema?', 'medium', 'A relational database schema is the structure of the database, including the tables, columns, relationships between tables, and constraints.', 'Think about the blueprint of the database.'),
(31, 'What is the purpose of normalization in relational databases?', 'medium', 'Normalization is the process of organizing data in a database to reduce redundancy and improve data integrity.', 'Think about organizing data efficiently and avoiding duplication.'),
(31, 'What is a one-to-many relationship between tables?', 'medium', 'In a one-to-many relationship, one record in the first table can be associated with multiple records in the second table, but a record in the second table can only be associated with one record in the first table.', 'Think about how one entity relates to several of another.'),
(31, 'What is a many-to-many relationship between tables and how is it typically implemented?', 'hard', 'A many-to-many relationship occurs when multiple records in one table can be associated with multiple records in another table. It is typically implemented using a junction table (or linking table) that has foreign keys referencing both tables.', 'Think about complex relationships and how to resolve them.');

-- Insert values into questions table for SQL Basics (assuming submodule_id = 32)
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(32, 'Which SQL command is used to retrieve data from a database?', 'easy', 'The SELECT command is used to query and retrieve data from one or more tables in a database.', 'Think about how you ask for data.'),
(32, 'Which SQL command is used to insert new data into a table?', 'easy', 'The INSERT INTO command is used to add new rows of data into a table.', 'Think about how you add new records.'),
(32, 'Which SQL command is used to modify existing data in a table?', 'easy', 'The UPDATE command is used to change the values of one or more columns in existing rows of a table.', 'Think about how you change existing records.'),
(32, 'Which SQL command is used to remove rows from a table?', 'medium', 'The DELETE FROM command is used to remove one or more rows from a table based on specified conditions.', 'Think about how you remove records.'),
(32, 'What is the purpose of the WHERE clause in a SQL SELECT statement?', 'medium', 'The WHERE clause is used to filter records, specifying conditions that rows must meet to be included in the result set.', 'Think about how you specify which data you want to see.'),
(32, 'What is the purpose of the ORDER BY clause in a SQL SELECT statement?', 'medium', 'The ORDER BY clause is used to sort the result set of a query based on one or more columns, in ascending (ASC) or descending (DESC) order.', 'Think about how you arrange the retrieved data.');

-- Insert values into questions table for Database Design (assuming submodule_id = 33)
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(33, 'What is the goal of good database design?', 'easy', 'The goal of good database design is to organize data efficiently, reduce redundancy, ensure data integrity, and make it easy to query and manage.', 'Think about the principles of a well-structured database.'),
(33, 'What is data redundancy and why is it a problem?', 'medium', 'Data redundancy is the duplication of data in multiple places in a database. It is a problem because it can lead to inconsistencies, increased storage requirements, and difficulties in updating data.', 'Think about the problems caused by having the same information in multiple places.'),
(33, 'What are database constraints and why are they important?', 'medium', 'Database constraints are rules enforced on data columns to limit the type of data that can be inserted. They are important for maintaining data integrity and accuracy.', 'Think about rules that ensure data quality.'),
(33, 'Explain the concept of atomicity in the context of database design.', 'hard', 'Atomicity in database design refers to the principle that a transaction should be treated as a single, indivisible unit of work. Either all operations within the transaction are successfully completed, or none are.', 'Think about transactions being all or nothing.'),
(33, 'Explain the concept of referential integrity in the context of database design.', 'hard', 'Referential integrity is a property of data stating that all its references are valid. In relational databases, it ensures that relationships between tables remain consistent, typically through foreign key constraints.', 'Think about maintaining valid links between tables.'),
(33, 'What are some common database design models?', 'medium', 'Common database design models include the relational model, the entity-relationship model (ER model), and NoSQL models (like document databases and key-value stores).', 'Think about different ways to structure a database.');

-- Insert values into questions table for HTML Fundamentals (assuming submodule_id = 34)
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(34, 'What is the root element of every HTML page?', 'easy', 'The `<html>` element is the root element that encloses all other HTML content.', 'Think about the very beginning of an HTML document.'),
(34, 'Which HTML tag is used to define the main content of a page?', 'easy', 'The `<body>` tag contains the visible content that will be displayed to the user.', 'Think about where the text and images go.'),
(34, 'Which HTML tag is used to define a heading?', 'easy', 'Heading tags (`<h1>` to `<h6>`) are used to structure content with different levels of headings.', 'Think about making text stand out as a title.'),
(34, 'Which HTML tag is used to create a hyperlink?', 'medium', 'The `<a>` tag (anchor tag) is used to create hyperlinks to other web pages or resources.', 'Think about creating clickable links.'),
(34, 'What is the purpose of the `<head>` section in an HTML document?', 'medium', 'The `<head>` section contains meta-information about the HTML document, such as the title, character set, and links to stylesheets.', 'Think about information about the page itself, not the visible content.'),
(34, 'What is the difference between block-level and inline elements in HTML?', 'hard', 'Block-level elements (e.g., `<div>`, `<p>`, `<h1>`) take up the full width available and start on a new line. Inline elements (e.g., `<span>`, `<a>`, `<img>`) only take up as much width as necessary and do not start on a new line.', 'Think about how elements flow and take up space.');

-- Insert values into questions table for CSS Styling (assuming submodule_id = 35)
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(35, 'What does CSS stand for?', 'easy', 'CSS stands for Cascading Style Sheets.', 'Think about what CSS is used for.'),
(35, 'What is the purpose of CSS?', 'easy', 'The purpose of CSS is to control the visual presentation and layout of HTML elements on a web page.', 'Think about how you make a website look good.'),
(35, 'How can you include CSS in an HTML document?', 'easy', 'CSS can be included inline (using the `style` attribute), internally (using the `<style>` tag in the `<head>`), or externally (linking to a `.css` file using the `<link>` tag).', 'Think about the different ways to add styles.'),
(35, 'What is a CSS selector?', 'medium', 'A CSS selector is a pattern used to select the HTML elements you want to style.', 'Think about how you target specific elements.'),
(35, 'What is the CSS box model?', 'medium', 'The CSS box model describes the rectangular boxes that are generated for elements in the document tree and consist of content, padding, border, and margin.', 'Think about the different layers around an HTML element.'),
(35, 'What is the difference between `id` and `class` selectors in CSS?', 'medium', 'An `id` selector (prefixed with `#`) is used to style a single, unique element on a page. A `class` selector (prefixed with `.`) can be used to style multiple elements that share a common style.', 'Think about styling one specific thing versus styling many similar things.');

-- Insert values into questions table for JavaScript Basics (assuming submodule_id = 36)
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(36, 'What is JavaScript primarily used for in web development?', 'easy', 'JavaScript is primarily used to add interactivity and dynamic behavior to web pages.', 'Think about making websites do things.'),
(36, 'Which keyword is used to declare a variable in JavaScript?', 'easy', 'The `var`, `let`, or `const` keywords are used to declare variables in JavaScript.', 'Think about how you create storage for data.'),
(36, 'What is a function in JavaScript?', 'easy', 'A function is a block of code designed to perform a specific task.', 'Think about reusable blocks of code.'),
(36, 'What is an event listener in JavaScript?', 'medium', 'An event listener is a procedure in JavaScript that waits for an event (like a mouse click or a key press) to occur on a specific HTML element and then executes a predefined function.', 'Think about making things happen when the user interacts.'),
(36, 'What are the basic data types in JavaScript?', 'medium', 'Basic data types in JavaScript include string, number, boolean, null, undefined, and symbol (as of ES6).', 'Think about the different kinds of information you can work with.'),
(36, 'What is the Document Object Model (DOM)?', 'hard', 'The DOM is a programming interface for web documents. It represents the page structure as a tree of objects, allowing JavaScript to interact with and manipulate the content, structure, and style of a web page.', 'Think about how JavaScript sees and interacts with the HTML.');

-- Insert values into questions table for Plate Tectonics (assuming submodule_id = 37)
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(37, 'What is the theory of plate tectonics?', 'easy', 'The theory of plate tectonics states that Earths outer shell (lithosphere) is divided into several plates that glide over the mantle, the rocky inner layer above the core.', 'Think about the Earths surface being made of moving pieces.'),
(37, 'What are the three main types of plate boundaries?', 'easy', 'The three main types of plate boundaries are convergent (plates collide), divergent (plates move apart), and transform (plates slide past each other).', 'Think about how plates interact at their edges.'),
(37, 'What geological features are commonly associated with convergent plate boundaries?', 'medium', 'Convergent plate boundaries are often associated with the formation of mountains, volcanoes, and ocean trenches.', 'Think about what happens when plates collide.'),
(37, 'What geological features are commonly associated with divergent plate boundaries?', 'medium', 'Divergent plate boundaries are often associated with the formation of mid-ocean ridges, rift valleys, and volcanic activity.', 'Think about what happens when plates move apart.'),
(37, 'What geological events are common at transform plate boundaries?', 'medium', 'Transform plate boundaries are commonly associated with earthquakes as the plates grind past each other.', 'Think about what happens when plates slide past each other.'),
(37, 'What is subduction?', 'hard', 'Subduction is a geological process where one tectonic plate moves under another and sinks into the mantle at a convergent plate boundary.', 'Think about one plate going beneath another.');

-- Insert values into questions table for Climate and Weather (assuming submodule_id = 38)
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(38, 'What is the difference between climate and weather?', 'easy', 'Weather refers to the short-term atmospheric conditions in a specific location, while climate describes the long-term average weather patterns in a region.', 'Think about short-term vs. long-term atmospheric conditions.'),
(38, 'What are the main factors that influence climate?', 'easy', 'The main factors that influence climate include latitude, altitude, proximity to water bodies, ocean currents, and prevailing winds.', 'Think about the large-scale controls on temperature and precipitation.'),
(38, 'What causes wind?', 'easy', 'Wind is caused by differences in air pressure, which are often due to uneven heating of the Earths surface.', 'Think about air moving from high to low pressure.'),
(38, 'What is the greenhouse effect?', 'medium', 'The greenhouse effect is the process by which certain gases in Earths atmosphere trap some of the outgoing infrared radiation, warming the planet.', 'Think about how the atmosphere retains heat.'),
(38, 'What are the different types of precipitation?', 'medium', 'The main types of precipitation include rain, snow, sleet, and hail.', 'Think about the different forms of water falling from the sky.'),
(38, 'What is a front in meteorology?', 'medium', 'A front is a boundary separating two masses of air with different densities (usually due to differences in temperature and humidity).', 'Think about the meeting place of different air masses.');

-- Insert values into questions table for Landforms (assuming submodule_id = 39)
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(39, 'What is a mountain?', 'easy', 'A mountain is a large natural elevation of the Earths surface rising abruptly from the surrounding level.', 'Think about a very tall hill.'),
(39, 'What is a valley?', 'easy', 'A valley is a low area between hills or mountains, typically with a river or stream flowing through it.', 'Think about the low ground between higher areas.'),
(39, 'What is a plain?', 'easy', 'A plain is a large area of flat or gently rolling land with few trees.', 'Think about a wide, flat area.'),
(39, 'How are river deltas formed?', 'medium', 'River deltas are formed by the deposition of sediment carried by a river as it enters a slower-moving or standing body of water such as an ocean, sea, or lake.', 'Think about sediment being dropped at the mouth of a river.'),
(39, 'What is erosion?', 'medium', 'Erosion is the process by which natural forces like wind, water, and ice wear away and transport soil and rock.', 'Think about the wearing down of the Earths surface.'),
(39, 'What is the difference between a plateau and a mesa?', 'medium', 'A plateau is a large area of flat land that is higher than the surrounding land. A mesa is a flat-topped hill with steep sides, typically smaller than a plateau.', 'Think about flat elevated land, large vs. small.');

-- Insert values into questions table for Population Geography (assuming submodule_id = 40)
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(40, 'What is population density?', 'easy', 'Population density is the number of individuals living in a specific area.', 'Think about how crowded a place is.'),
(40, 'What is birth rate?', 'easy', 'Birth rate is the number of live births per 1,000 people in a population per year.', 'Think about how many babies are born.'),
(40, 'What is migration?', 'easy', 'Migration is the movement of people from one place to another with the intent of settling permanently or temporarily.', 'Think about people moving to new locations.'),
(40, 'What are push factors in migration?', 'medium', 'Push factors are negative aspects of a persons current location that encourage them to leave.', 'Think about reasons why people want to move away.'),
(40, 'What are pull factors in migration?', 'medium', 'Pull factors are positive aspects of a new location that attract people to move there.', 'Think about reasons why people want to move to a specific place.'),
(40, 'What is the demographic transition model?', 'hard', 'The demographic transition model is a model that describes population change over time as countries industrialize, typically characterized by shifts in birth and death rates.', 'Think about how population patterns change with development.');

-- Insert values into questions table for Cultural Geography (assuming submodule_id = 41)
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(41, 'What is culture?', 'easy', 'Culture encompasses the shared beliefs, values, practices, behaviors, and technologies of a group of people.', 'Think about the way of life of a group.'),
(41, 'What is a cultural region?', 'easy', 'A cultural region is an area where people share common cultural characteristics.', 'Think about areas with similar traditions.'),
(41, 'What is cultural diffusion?', 'easy', 'Cultural diffusion is the spread of cultural traits from one group or place to another.', 'Think about how cultures spread.'),
(41, 'What is cultural assimilation?', 'medium', 'Cultural assimilation is the process by which individuals or groups adopt the cultural norms of a dominant group.', 'Think about losing ones original culture to fit in.'),
(41, 'What is cultural relativism?', 'medium', 'Cultural relativism is the principle that a persons beliefs and activities should be understood by others in terms of that individuals own culture, rather than judged against the criteria of another.', 'Think about understanding cultures on their own terms.'),
(41, 'What is the concept of a cultural landscape?', 'medium', 'A cultural landscape is the visible imprint of human activity and culture on the environment.', 'Think about how culture shapes the land.');

-- Insert values into questions table for Urban Geography (assuming submodule_id = 42)
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(42, 'What is urbanization?', 'easy', 'Urbanization is the process by which an increasing proportion of a countrys population lives in urban areas.', 'Think about the growth of cities.'),
(42, 'What is a city?', 'easy', 'A city is a large and densely populated urban area.', 'Think about a big town.'),
(42, 'What is urban sprawl?', 'easy', 'Urban sprawl is the expansion of low-density urban development outward from a city center.', 'Think about cities spreading out.'),
(42, 'What is the central business district (CBD) of a city?', 'medium', 'The CBD is the commercial and often geographic heart of a city, characterized by high-density land use.', 'Think about the downtown area.'),
(42, 'What are the different models of urban structure?', 'medium', 'Different models of urban structure include the concentric zone model, the sector model, and the multiple nuclei model, which describe the spatial organization of cities.', 'Think about different ways cities are arranged.'),
(42, 'What are some of the challenges associated with rapid urbanization?', 'medium', 'Challenges of rapid urbanization can include housing shortages, inadequate infrastructure, environmental degradation, and social inequalities.', 'Think about the problems that can come with fast city growth.');

-- Insert values into questions table for Map Projections (assuming submodule_id = 43)
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(43, 'What is the primary challenge of map projections?', 'easy', 'The primary challenge is representing the curved surface of the Earth on a flat map without distortion.', 'Think about flattening a sphere.'),
(43, 'What is a cylindrical map projection?', 'easy', 'A cylindrical projection transfers the Earths surface onto a cylinder. Meridians are vertical lines, and parallels are horizontal lines.', 'Think about wrapping a cylinder around the globe.'),
(43, 'What is a conical map projection?', 'easy', 'A conical projection transfers the Earths surface onto a cone. Meridians are straight lines radiating from the apex, and parallels are arcs of circles.', 'Think about placing a cone over the globe.'),
(43, 'What is a planar (azimuthal) map projection?', 'medium', 'A planar projection transfers the Earths surface onto a flat plane. Directions from the center point are accurate.', 'Think about touching the globe with a flat surface.'),
(43, 'What types of distortion are common in map projections?', 'medium', 'Common distortions include shape (conformal), area (equal-area), distance (equidistant), and direction (azimuthal). No flat map can perfectly preserve all of these.', 'Think about what gets stretched or squeezed when flattening the Earth.'),
(43, 'What is the Mercator projection known for?', 'medium', 'The Mercator projection is a cylindrical projection known for preserving angles (conformal), making it useful for navigation, but it greatly distorts area at higher latitudes.', 'Think about maps used by sailors and how they show shape and size.');

-- Insert values into questions table for Map Scales (assuming submodule_id = 44)
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(44, 'What is a map scale?', 'easy', 'A map scale is the ratio of a distance on the map to the corresponding distance on the ground.', 'Think about how much smaller the map is than reality.'),
(44, 'What does a representative fraction (e.g., 1:100,000) mean?', 'easy', 'A representative fraction of 1:100,000 means that one unit of measurement on the map represents 100,000 of the same units on the ground.', 'Think about the ratio of map distance to ground distance.'),
(44, 'What is a verbal scale?', 'easy', 'A verbal scale describes the relationship between map distance and ground distance in words (e.g., "One centimeter represents one kilometer").', 'Think about expressing the scale in a sentence.'),
(44, 'What is a graphic scale (bar scale)?', 'medium', 'A graphic scale is a line or bar drawn on the map that represents a specific distance on the ground.', 'Think about a visual representation of the scale.'),
(44, 'If a map has a scale of 1:50,000, and two points are 3 cm apart on the map, what is the actual distance between them on the ground?', 'medium', 'The actual distance is 150,000 cm, or 1.5 kilometers (3 cm * 50,000 cm/cm = 150,000 cm; 150,000 cm / 100,000 cm/km = 1.5 km).', 'Think about multiplying the map distance by the scale factor.'),
(44, 'Why is it important to understand map scale?', 'medium', 'Understanding map scale is crucial for accurately measuring distances, calculating areas, and interpreting the level of detail shown on a map.', 'Think about what you can and cant do with a map if you know its scale.');

-- Insert values into questions table for Thematic Mapping (assuming submodule_id = 45)
INSERT INTO questions (submodule_id, question_text, difficulty, explanation, hint) VALUES
(45, 'What is the primary purpose of a thematic map?', 'easy', 'The primary purpose of a thematic map is to illustrate the spatial distribution of one or more specific topics or themes.', 'Think about maps that show specific data.'),
(45, 'What is a choropleth map?', 'easy', 'A choropleth map uses different shades or colors within predefined areas (like countries or states) to represent the magnitude of a variable.', 'Think about maps with colored regions.'),
(45, 'What is a dot density map?', 'easy', 'A dot density map uses dots to represent the occurrence of a phenomenon, with each dot representing a specific quantity.', 'Think about maps with lots of dots.'),
(45, 'What is a proportional symbol map?', 'medium', 'A proportional symbol map uses symbols (like circles or squares) whose size varies in proportion to the magnitude of the variable being mapped.', 'Think about maps with different sized shapes.'),
(45, 'What is an isoline map?', 'medium', 'An isoline map uses lines to connect points of equal value (e.g., contour lines for elevation, isotherms for temperature).', 'Think about maps with lines connecting similar measurements.'),
(45, 'What are some examples of topics that can be effectively displayed on thematic maps?', 'medium', 'Examples include population density, income levels, disease prevalence, voting patterns, and climate data.', 'Think about specific types of information that vary geographically.');

-- ANSWERS

-- Insert values into answers table for 'What is the primary function of the cell membrane?' (assuming question_id starts at 1)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(1, 'To produce energy for the cell', FALSE),
(1, 'To store genetic information', FALSE),
(1, 'To control what enters and exits the cell', TRUE),
(1, 'To synthesize proteins', FALSE),
(1, 'To break down waste materials', FALSE),
(1, 'To provide structural support only', FALSE);

-- Insert values into answers table for 'Which of the following is a major component of the cell membrane?' (assuming question_id = 2)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(2, 'DNA', FALSE),
(2, 'RNA', FALSE),
(2, 'Phospholipid bilayer', TRUE),
(2, 'Glycogen', FALSE),
(2, 'Starch', FALSE),
(2, 'Cellulose', FALSE);

-- Insert values into answers table for 'What does it mean for the cell membrane to be selectively permeable?' (assuming question_id = 3)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(3, 'It allows all substances to pass freely', FALSE),
(3, 'It prevents all substances from passing', FALSE),
(3, 'It allows only water to pass through', FALSE),
(3, 'It allows some substances to pass easily, others are restricted', TRUE),
(3, 'It requires energy for all substances to pass', FALSE),
(3, 'It changes its permeability constantly', FALSE);

-- Insert values into answers table for 'How do large, polar molecules typically cross the cell membrane?' (assuming question_id = 4)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(4, 'By simple diffusion through the lipid bilayer', FALSE),
(4, 'By osmosis', FALSE),
(4, 'By active transport without protein assistance', FALSE),
(4, 'By facilitated diffusion or active transport via proteins', TRUE),
(4, 'By breaking down into smaller, nonpolar molecules', FALSE),
(4, 'They cannot cross the cell membrane', FALSE);

-- Insert values into answers table for 'What role does cholesterol play in the cell membrane?' (assuming question_id = 5)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(5, 'It provides energy to the membrane', FALSE),
(5, 'It helps in protein synthesis within the membrane', FALSE),
(5, 'It regulates membrane fluidity and stability', TRUE),
(5, 'It is the primary structural component', FALSE),
(5, 'It facilitates the transport of water-soluble molecules', FALSE),
(5, 'It is involved in cell-to-cell communication only', FALSE);

-- Insert values into answers table for 'What is the glycocalyx and what is its function?' (assuming question_id = 6)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(6, 'A protein layer involved in structural support', FALSE),
(6, 'A lipid layer that repels water', FALSE),
(6, 'A carbohydrate layer involved in cell recognition, adhesion, and protection', TRUE),
(6, 'A nucleic acid layer that stores genetic information', FALSE),
(6, 'An enzyme layer that breaks down toxins', FALSE),
(6, 'A pigment layer that gives the cell its color', FALSE);

-- Insert values into answers table for 'Which organelle is responsible for generating most of the cells ATP?' (assuming question_id starts at 7)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(7, 'Nucleus', FALSE),
(7, 'Endoplasmic reticulum', FALSE),
(7, 'Mitochondria', TRUE),
(7, 'Golgi apparatus', FALSE),
(7, 'Lysosomes', FALSE),
(7, 'Ribosomes', FALSE);

-- Insert values into answers table for 'What is the main function of the nucleus?' (assuming question_id = 8)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(8, 'Protein synthesis', FALSE),
(8, 'Lipid synthesis', FALSE),
(8, 'Energy production', FALSE),
(8, 'Contains DNA and controls cell activities', TRUE),
(8, 'Waste breakdown', FALSE),
(8, 'Storage of water and nutrients', FALSE);

-- Insert values into answers table for 'Which organelle is involved in protein synthesis?' (assuming question_id = 9)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(9, 'Mitochondria', FALSE),
(9, 'Lysosomes', FALSE),
(9, 'Golgi apparatus', FALSE),
(9, 'Ribosomes', TRUE),
(9, 'Smooth endoplasmic reticulum', FALSE),
(9, 'Nucleus', FALSE);

-- Insert values into answers table for 'What is the role of the endoplasmic reticulum (ER)?' (assuming question_id = 10)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(10, 'Primary site of ATP production', FALSE),
(10, 'Digestion of cellular waste', FALSE),
(10, 'Modification and packaging of proteins', FALSE),
(10, 'Protein and lipid synthesis, detoxification', TRUE),
(10, 'Storage of genetic material', FALSE),
(10, 'Control of cell division', FALSE);

-- Insert values into answers table for 'What is the function of the Golgi apparatus?' (assuming question_id = 11)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(11, 'Synthesis of lipids', FALSE),
(11, 'Breakdown of toxic substances', FALSE),
(11, 'Production of ATP', FALSE),
(11, 'Modifies, sorts, and packages proteins and lipids', TRUE),
(11, 'Synthesis of proteins', FALSE),
(11, 'Storage of water and ions', FALSE);

-- Insert values into answers table for 'Lysosomes contain which type of enzymes?' (assuming question_id = 12)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(12, 'Enzymes for protein synthesis', FALSE),
(12, 'Enzymes for DNA replication', FALSE),
(12, 'Enzymes for ATP synthesis', FALSE),
(12, 'Hydrolytic enzymes for breakdown', TRUE),
(12, 'Enzymes for lipid synthesis', FALSE),
(12, 'Enzymes for carbohydrate storage', FALSE);

-- Insert values into answers table for 'What is the overall purpose of cellular respiration?' (assuming question_id starts at 13)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(13, 'To synthesize glucose from carbon dioxide and water', FALSE),
(13, 'To store energy in the form of glycogen', FALSE),
(13, 'To convert glucose and oxygen into ATP', TRUE),
(13, 'To produce oxygen as a byproduct', FALSE),
(13, 'To break down proteins for amino acids', FALSE),
(13, 'To replicate the cells DNA', FALSE);

-- Insert values into answers table for 'Which molecule is the primary fuel source for cellular respiration?' (assuming question_id = 14)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(14, 'Carbon dioxide', FALSE),
(14, 'Water', FALSE),
(14, 'Oxygen', FALSE),
(14, 'Glucose', TRUE),
(14, 'Amino acids', FALSE),
(14, 'Fatty acids', FALSE);

-- Insert values into answers table for 'Where does glycolysis take place in the cell?' (assuming question_id = 15)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(15, 'Mitochondrial matrix', FALSE),
(15, 'Inner mitochondrial membrane', FALSE),
(15, 'Nucleus', FALSE),
(15, 'Cytoplasm', TRUE),
(15, 'Golgi apparatus', FALSE),
(15, 'Endoplasmic reticulum', FALSE);

-- Insert values into answers table for 'What are the end products of glycolysis?' (assuming question_id = 16)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(16, 'Glucose and oxygen', FALSE),
(16, 'Carbon dioxide and water', FALSE),
(16, 'Pyruvate, ATP (net), NADH', TRUE),
(16, 'Lactic acid and ATP', FALSE),
(16, 'Ethanol and carbon dioxide', FALSE),
(16, 'Acetyl-CoA and CO2', FALSE);

-- Insert values into answers table for 'Where does the Krebs cycle (citric acid cycle) occur in eukaryotic cells?' (assuming question_id = 17)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(17, 'Cytoplasm', FALSE),
(17, 'Inner mitochondrial membrane', FALSE),
(17, 'Outer mitochondrial membrane', FALSE),
(17, 'Mitochondrial matrix', TRUE),
(17, 'Nucleus', FALSE),
(17, 'Endoplasmic reticulum lumen', FALSE);

-- Insert values into answers table for 'What is the role of oxygen in aerobic respiration?' (assuming question_id = 18)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(18, 'It directly phosphorylates ADP to ATP', FALSE),
(18, 'It is a reactant in the Krebs cycle', FALSE),
(18, 'It binds to glucose to initiate breakdown', FALSE),
(18, 'It is the final electron acceptor in the electron transport chain', TRUE),
(18, 'It helps transport pyruvate into the mitochondria', FALSE),
(18, 'It regulates the activity of glycolytic enzymes', FALSE);

-- Insert values into answers table for 'What are the building blocks of DNA?' (assuming question_id starts at 19)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(19, 'Amino acids', FALSE),
(19, 'Fatty acids', FALSE),
(19, 'Nucleotides', TRUE),
(19, 'Monosaccharides', FALSE),
(19, 'Glycerol', FALSE),
(19, 'Ions', FALSE);

-- Insert values into answers table for 'Which nitrogenous base pairs with adenine (A) in DNA?' (assuming question_id = 20)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(20, 'Guanine (G)', FALSE),
(20, 'Cytosine (C)', FALSE),
(20, 'Uracil (U)', FALSE),
(20, 'Thymine (T)', TRUE),
(20, 'Adenine (A)', FALSE),
(20, 'Any base', FALSE);

-- Insert values into answers table for 'What is the shape of a DNA molecule?' (assuming question_id = 21)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(21, 'Single helix', FALSE),
(21, 'Triple helix', FALSE),
(21, 'Double helix', TRUE),
(21, 'Linear chain', FALSE),
(21, 'Circular loop', FALSE),
(21, 'Branched structure', FALSE);

-- Insert values into answers table for 'What type of bond holds the two strands of DNA together?' (assuming question_id = 22)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(22, 'Covalent bonds', FALSE),
(22, 'Ionic bonds', FALSE),
(22, 'Peptide bonds', FALSE),
(22, 'Hydrogen bonds', TRUE),
(22, 'Phosphodiester bonds', FALSE),
(22, 'Van der Waals forces', FALSE);

-- Insert values into answers table for 'What is the role of the phosphate group in the DNA backbone?' (assuming question_id = 23)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(23, 'It carries the genetic information', FALSE),
(23, 'It forms the hydrogen bonds between bases', FALSE),
(23, 'It provides the energy for replication', FALSE),
(23, 'It links the sugars in the backbone', TRUE),
(23, 'It determines the shape of the bases', FALSE),
(23, 'It initiates transcription', FALSE);

-- Insert values into answers table for 'What is the central dogma of molecular biology?' (assuming question_id = 24)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(24, 'Protein -> RNA -> DNA', FALSE),
(24, 'RNA -> DNA -> Protein', FALSE),
(24, 'DNA -> Protein -> RNA', FALSE),
(24, 'DNA -> RNA -> Protein', TRUE),
(24, 'Protein -> DNA -> RNA', FALSE),
(24, 'RNA -> Protein -> DNA', FALSE);

-- Insert values into answers table for 'What is a gene?' (assuming question_id starts at 25)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(25, 'A type of protein', FALSE),
(25, 'A structural component of the cell', FALSE),
(25, 'A unit of heredity carrying instructions for a trait', TRUE),
(25, 'A type of carbohydrate', FALSE),
(25, 'A lipid molecule', FALSE),
(25, 'A type of cell', FALSE);

-- Insert values into answers table for 'What are alleles?' (assuming question_id = 26)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(26, 'Different genes for different traits', FALSE),
(26, 'The building blocks of DNA', FALSE),
(26, 'Different versions of the same gene', TRUE),
(26, 'The physical expression of a trait', FALSE),
(26, 'The process of cell division', FALSE),
(26, 'The location of a gene on a chromosome', FALSE);

-- Insert values into answers table for 'What does it mean for an organism to be homozygous for a particular trait?' (assuming question_id = 27)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(27, 'Having two different alleles', FALSE),
(27, 'Having only one allele', FALSE),
(27, 'Having two identical alleles', TRUE),
(27, 'Having no alleles for that trait', FALSE),
(27, 'Having a dominant and a recessive allele', FALSE),
(27, 'Having multiple alleles', FALSE);

-- Insert values into answers table for 'What does it mean for an organism to be heterozygous for a particular trait?' (assuming question_id = 28)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(28, 'Having two identical alleles', FALSE),
(28, 'Having multiple identical alleles', FALSE),
(28, 'Having two different alleles', TRUE),
(28, 'Having no alleles for that trait', FALSE),
(28, 'Having only the dominant allele', FALSE),
(28, 'Having only the recessive allele', FALSE);

-- Insert values into answers table for 'State Mendels Law of Segregation.' (assuming question_id = 29)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(29, 'Alleles of different genes assort independently during gamete formation', FALSE),
(29, 'The dominant allele masks the effect of the recessive allele', FALSE),
(29, 'During gamete formation, two alleles for each gene separate so each gamete carries one allele', TRUE),
(29, 'Traits are inherited in discrete units', FALSE),
(29, 'Offspring inherit a blend of their parents traits', FALSE),
(29, 'Genes are located on chromosomes', FALSE);

-- Insert values into answers table for 'In a monohybrid cross between two heterozygous parents (Bb x Bb), what is the expected phenotypic ratio of the offspring if B is dominant over b?' (assuming question_id = 30)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(30, '1:1', FALSE),
(30, '1:2:1', FALSE),
(30, '2:1', FALSE),
(30, '3:1', TRUE),
(30, '4:0', FALSE),
(30, '1:3', FALSE);

-- Insert values into answers table for 'What is a mutation?' (assuming question_id starts at 31)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(31, 'A temporary change in RNA', FALSE),
(31, 'A change in protein structure due to environment', FALSE),
(31, 'A permanent change in the DNA sequence', TRUE),
(31, 'The normal process of gene expression', FALSE),
(31, 'The replication of DNA', FALSE),
(31, 'The movement of genes between chromosomes', FALSE);

-- Insert values into answers table for 'What is a point mutation?' (assuming question_id = 32)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(32, 'A change involving large segments of a chromosome', FALSE),
(32, 'The loss of an entire chromosome', FALSE),
(32, 'The addition of an entire chromosome', FALSE),
(32, 'A change in a single nucleotide base', TRUE),
(32, 'The inversion of a sequence of genes', FALSE),
(32, 'The duplication of a sequence of genes', FALSE);

-- Insert values into answers table for 'What is a frameshift mutation?' (assuming question_id = 33)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(33, 'A substitution of one nucleotide for another', FALSE),
(33, 'An insertion or deletion of a multiple of three nucleotides', FALSE),
(33, 'An inversion of a short DNA sequence', FALSE),
(33, 'Insertion or deletion of nucleotides not a multiple of three, shifting the reading frame', TRUE),
(33, 'The replacement of a purine with a pyrimidine', FALSE),
(33, 'The replacement of a pyrimidine with a purine', FALSE);

-- Insert values into answers table for 'What is a substitution mutation?' (assuming question_id = 34)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(34, 'The insertion of extra nucleotides', FALSE),
(34, 'The deletion of nucleotides', FALSE),
(34, 'The shifting of the reading frame', FALSE),
(34, 'One nucleotide base is replaced by another', TRUE),
(34, 'The duplication of a gene sequence', FALSE),
(34, 'The inversion of a gene sequence', FALSE);

-- Insert values into answers table for 'What are some potential causes of mutations?' (assuming question_id = 35)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(35, 'Normal metabolic processes only', FALSE),
(35, 'Changes in atmospheric pressure', FALSE),
(35, 'Spontaneous errors during DNA replication and environmental mutagens', TRUE),
(35, 'Changes in an organisms diet', FALSE),
(35, 'Exposure to normal levels of sunlight', FALSE),
(35, 'The aging process of cells only', FALSE);

-- Insert values into answers table for 'What are the possible effects of a mutation on an organism?' (assuming question_id = 36)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(36, 'Always harmful and lead to genetic disorders', FALSE),
(36, 'Always beneficial, leading to improved traits', FALSE),
(36, 'Always result in no noticeable change', FALSE),
(36, 'Range from no effect to beneficial or harmful effects depending on the mutation', TRUE),
(36, 'Only affect the physical appearance of the organism', FALSE),
(36, 'Only affect the reproductive capabilities of the organism', FALSE);

-- Insert values into answers table for 'What is a food web?' (assuming question_id starts at 37)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(37, 'A linear sequence of organisms where each is eaten by the next', FALSE),
(37, 'A diagram showing the physical environment of a habitat', FALSE),
(37, 'A complex network of interconnected food chains showing energy flow', TRUE),
(37, 'A list of all the species in an ecosystem', FALSE),
(37, 'The cycling of nutrients within an ecosystem', FALSE),
(37, 'A measure of biodiversity in an area', FALSE);

-- Insert values into answers table for 'What is a producer in a food web?' (assuming question_id = 38)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(38, 'An organism that hunts and kills other organisms', FALSE),
(38, 'An organism that breaks down dead organic matter', FALSE),
(38, 'An organism that produces its own food', TRUE),
(38, 'An organism that eats both plants and animals', FALSE),
(38, 'A primary consumer that eats producers', FALSE),
(38, 'A secondary consumer that eats primary consumers', FALSE);

-- Insert values into answers table for 'What are consumers in a food web?' (assuming question_id = 39)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(39, 'Organisms that produce their own energy', FALSE),
(39, 'Non-living components of the ecosystem', FALSE),
(39, 'Organisms that obtain energy by feeding on other organisms', TRUE),
(39, 'Organisms that recycle nutrients from dead matter', FALSE),
(39, 'The abiotic factors in an environment', FALSE),
(39, 'The total biomass of an ecosystem', FALSE);

-- Insert values into answers table for 'What is a decomposer in a food web?' (assuming question_id = 40)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(40, 'An organism that eats producers', FALSE),
(40, 'An organism that is eaten by other organisms', FALSE),
(40, 'An organism that hunts live prey', FALSE),
(40, 'An organism that breaks down dead organic matter', TRUE),
(40, 'An organism that produces its own food using sunlight', FALSE),
(40, 'A top predator in the food web', FALSE);

-- Insert values into answers table for 'What is the role of arrows in a food web diagram?' (assuming question_id = 41)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(41, 'To indicate the flow of water', FALSE),
(41, 'To show the direction of nutrient cycling', FALSE),
(41, 'To represent the movement of organisms', FALSE),
(41, 'To indicate the direction of energy flow', TRUE),
(41, 'To show the territorial boundaries of species', FALSE),
(41, 'To indicate predator-prey relationships, pointing from predator to prey', FALSE);

-- Insert values into answers table for 'What happens if a keystone species is removed from a food web?' (assuming question_id = 42)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(42, 'The food web remains largely unaffected', FALSE),
(42, 'The populations of all other species will increase', FALSE),
(42, 'There will be a slight increase in biodiversity', FALSE),
(42, 'Significant changes in the food web structure and potential ecosystem collapse', TRUE),
(42, 'Only the populations of its direct predators will decrease', FALSE),
(42, 'The decomposer population will drastically decline', FALSE);

-- Insert values into answers table for 'What is a biome?' (assuming question_id starts at 43)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(43, 'A small, localized habitat', FALSE),
(43, 'A single population of organisms', FALSE),
(43, 'A large-scale ecosystem with specific climate and life', TRUE),
(43, 'The non-living components of an ecosystem', FALSE),
(43, 'The total number of species in an area', FALSE),
(43, 'The chemical composition of the soil', FALSE);

-- Insert values into answers table for 'Which of the following is a major terrestrial biome?' (assuming question_id = 44)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(44, 'Coral reef', FALSE),
(44, 'Estuary', FALSE),
(44, 'Temperate grassland', TRUE),
(44, 'Deep sea vent', FALSE),
(44, 'Freshwater lake', FALSE),
(44, 'Intertidal zone', FALSE);

-- Insert values into answers table for 'What are the defining characteristics of a tropical rainforest biome?' (assuming question_id = 45)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(45, 'Low temperatures, high precipitation, low biodiversity', FALSE),
(45, 'High temperatures, low precipitation, sparse vegetation', FALSE),
(45, 'Moderate temperatures, seasonal rainfall, deciduous trees', FALSE),
(45, 'High temperatures, high rainfall, high biodiversity, dense vegetation', TRUE),
(45, 'Cold temperatures, low precipitation, permafrost', FALSE),
(45, 'Moderate temperatures, high winds, grasses', FALSE);

-- Insert values into answers table for 'What are the defining characteristics of a desert biome?' (assuming question_id = 46)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(46, 'High rainfall, dense forests, consistent temperatures', FALSE),
(46, 'Low temperatures, abundant snow, coniferous trees', FALSE),
(46, 'Moderate rainfall, fertile soil, diverse animal life', FALSE),
(46, 'Low precipitation, extreme temperature variations, sparse vegetation', TRUE),
(46, 'High humidity, coastal location, salt-tolerant plants', FALSE),
(46, 'Constant cold temperatures, icy conditions, minimal life', FALSE);

-- Insert values into answers table for 'What is the difference between tundra and taiga (boreal forest)?' (assuming question_id = 47)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(47, 'Tundra has tall trees, while taiga has only grasses', FALSE),
(47, 'Taiga has permafrost, while tundra does not', FALSE),
(47, 'Tundra has low-growing vegetation and permafrost, taiga has coniferous trees', TRUE),
(47, 'Taiga is warmer and has higher biodiversity than tundra', FALSE),
(47, 'Tundra receives more precipitation than taiga', FALSE),
(47, 'They are the same biome with different names', FALSE);

-- Insert values into answers table for 'How does altitude affect biome distribution?' (assuming question_id = 48)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(48, 'Altitude has no significant impact on biome distribution', FALSE),
(48, 'Higher altitude leads to warmer temperatures and increased rainfall', FALSE),
(48, 'Altitude creates a zonation of biomes mirroring latitudinal distribution due to temperature changes', TRUE),
(48, 'Higher altitude always results in desert biomes', FALSE),
(48, 'Altitude only affects the types of animals found, not vegetation', FALSE),
(48, 'Higher altitude leads to more tropical biomes', FALSE);

-- Insert values into answers table for 'What is population density?' (assuming question_id starts at 49)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(49, 'The total number of individuals in a habitat', FALSE),
(49, 'The rate at which a population is growing', FALSE),
(49, 'The number of individuals per unit area or volume', TRUE),
(49, 'The distribution pattern of individuals in a space', FALSE),
(49, 'The age structure of a population', FALSE),
(49, 'The genetic diversity within a population', FALSE);

-- Insert values into answers table for 'What is carrying capacity?' (assuming question_id = 50)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(50, 'The minimum population size for survival', FALSE),
(50, 'The actual size of a population at a given time', FALSE),
(50, 'The maximum population size an environment can sustainably support', TRUE),
(50, 'The ideal population size for reproduction', FALSE),
(50, 'The rate at which resources are consumed by a population', FALSE),
(50, 'The average lifespan of individuals in a population', FALSE);

-- Insert values into answers table for 'What are density-dependent limiting factors?' (assuming question_id = 51)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(51, 'Factors that have the same effect regardless of population size', FALSE),
(51, 'Natural disasters like floods and fires', FALSE),
(51, 'Extreme weather events like droughts or heatwaves', FALSE),
(51, 'Factors affecting growth more strongly as density increases (e.g., competition, predation)', TRUE),
(51, 'Changes in climate patterns', FALSE),
(51, 'Pollution events that affect all individuals equally', FALSE);

-- Insert values into answers table for 'What are density-independent limiting factors?' (assuming question_id = 52)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(52, 'Competition for limited resources', FALSE),
(52, 'The spread of infectious diseases', FALSE),
(52, 'Predation rates increasing with prey density', FALSE),
(52, 'Factors affecting growth regardless of density (e.g., natural disasters, weather)', TRUE),
(52, 'The accumulation of waste products', FALSE),
(52, 'Stress caused by overcrowding', FALSE);

-- Insert values into answers table for 'What is exponential population growth?' (assuming question_id = 53)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(53, 'Population growth that levels off over time', FALSE),
(53, 'Population decrease at a constant rate', FALSE),
(53, 'Population growth at a constant rate, resulting in a J-shaped curve', TRUE),
(53, 'Population growth influenced by carrying capacity', FALSE),
(53, 'Random fluctuations in population size', FALSE),
(53, 'A stable population size over time', FALSE);

-- Insert values into answers table for 'What is logistic population growth?' (assuming question_id = 54)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(54, 'Unrestricted growth at a constant rate', FALSE),
(54, 'Population decline due to limited resources', FALSE),
(54, 'Growth that slows as it approaches carrying capacity, resulting in an S-shaped curve', TRUE),
(54, 'Population size fluctuating wildly above and below carrying capacity', FALSE),
(54, 'A population that grows and then suddenly crashes', FALSE),
(54, 'Growth that is independent of environmental limitations', FALSE);

-- Insert values into answers table for 'What does Newtons First Law of Motion state?' (assuming question_id starts at 55)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(55, 'Energy cannot be created or destroyed', FALSE),
(55, 'For every action, there is an equal and opposite reaction', FALSE),
(55, 'The acceleration of an object is proportional to the force on it', FALSE),
(55, 'An object at rest stays at rest, and an object in motion stays in motion unless acted upon by a force', TRUE),
(55, 'Objects fall to the ground at a constant acceleration', FALSE),
(55, 'Momentum is always conserved in a closed system', FALSE);

-- Insert values into answers table for 'What is inertia?' (assuming question_id = 56)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(56, 'The force of gravity on an object', FALSE),
(56, 'The energy an object possesses due to its motion', FALSE),
(56, 'The tendency of an object to resist changes in its motion', TRUE),
(56, 'The rate at which an object changes its velocity', FALSE),
(56, 'The measure of the amount of matter in an object', FALSE),
(56, 'The force required to stop a moving object', FALSE);

-- Insert values into answers table for 'What does Newtons Second Law of Motion state?' (assuming question_id = 57)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(57, 'For every action, there is an equal and opposite reaction', FALSE),
(57, 'An object at rest stays at rest', FALSE),
(57, 'Force equals mass times velocity (F = mv)', FALSE),
(57, 'Acceleration is proportional to net force and inversely proportional to mass (F = ma)', TRUE),
(57, 'Energy is conserved', FALSE),
(57, 'Momentum is conserved', FALSE);

-- Insert values into answers table for 'What are the units of force, mass, and acceleration in the SI system?' (assuming question_id = 58)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(58, 'Force in kg, mass in N, acceleration in m/s²', FALSE),
(58, 'Force in N, mass in kg, acceleration in m/s²', TRUE),
(58, 'Force in Joules, mass in kg, acceleration in m/s²', FALSE),
(58, 'Force in Watts, mass in grams, acceleration in cm/s²', FALSE),
(58, 'Force in N, mass in grams, acceleration in m/s²', FALSE),
(58, 'Force in kg*m/s, mass in kg, acceleration in m/s²', FALSE);

-- Insert values into answers table for 'What does Newtons Third Law of Motion state?' (assuming question_id = 59)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(59, 'Objects move in straight lines at constant speeds', FALSE),
(59, 'Force equals mass times acceleration', FALSE),
(59, 'Energy is conserved', FALSE),
(59, 'For every action, there is an equal and opposite reaction', TRUE),
(59, 'Momentum is conserved', FALSE),
(59, 'Objects resist changes in their motion', FALSE);

-- Insert values into answers table for 'Explain the difference between mass and weight.' (assuming question_id = 60)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(60, 'Mass is a force, weight is the amount of matter', FALSE),
(60, 'Mass depends on gravity, weight does not', FALSE),
(60, 'Mass is scalar amount of matter, weight is the force of gravity on mass', TRUE),
(60, 'Mass is measured in Newtons, weight is measured in kilograms', FALSE),
(60, 'Mass is a vector, weight is a scalar', FALSE),
(60, 'Mass and weight are always equal in magnitude', FALSE);

-- Insert values into answers table for 'What is work in physics?' (assuming question_id starts at 61)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(61, 'The rate of energy transfer', FALSE),
(61, 'The force applied to an object', FALSE),
(61, 'Force causing displacement in the direction of the force', TRUE),
(61, 'The power used over a period of time', FALSE),
(61, 'The momentum of a moving object', FALSE),
(61, 'The change in an objects velocity', FALSE);

-- Insert values into answers table for 'What is energy?' (assuming question_id = 62)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(62, 'The rate at which work is done', FALSE),
(62, 'The force acting on an object', FALSE),
(62, 'The displacement of an object', FALSE),
(62, 'The ability to do work', TRUE),
(62, 'The mass of an object in motion', FALSE),
(62, 'The acceleration of an object', FALSE);

-- Insert values into answers table for 'What are the units of work and energy in the SI system?' (assuming question_id = 63)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(63, 'Work in Watts, energy in Joules', FALSE),
(63, 'Work in Newtons, energy in Joules', FALSE),
(63, 'Work in Joules, energy in Newtons', FALSE),
(63, 'Both work and energy in Joules', TRUE),
(63, 'Both work and energy in Watts', FALSE),
(63, 'Work in Joules, energy in Watts', FALSE);

-- Insert values into answers table for 'What is potential energy?' (assuming question_id = 64)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(64, 'Energy of motion', FALSE),
(64, 'Energy released as heat', FALSE),
(64, 'Stored energy due to position or configuration', TRUE),
(64, 'Energy transferred by a force', FALSE),
(64, 'Energy in the form of light', FALSE),
(64, 'Energy associated with electric charges in motion', FALSE);

-- Insert values into answers table for 'What is kinetic energy?' (assuming question_id = 65)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(65, 'Stored energy due to height', FALSE),
(65, 'Energy stored in chemical bonds', FALSE),
(65, 'Energy transferred by waves', FALSE),
(65, 'Energy of motion', TRUE),
(65, 'Energy due to an objects temperature', FALSE),
(65, 'Energy associated with the position of an object in a field', FALSE);

-- Insert values into answers table for 'State the work-energy theorem.' (assuming question_id = 66)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(66, 'Work done equals the change in potential energy', FALSE),
(66, 'Energy is always conserved in a closed system', FALSE),
(66, 'Power is the rate at which energy is transferred', FALSE),
(66, 'Net work done on an object equals the change in its kinetic energy', TRUE),
(66, 'Force equals mass times acceleration', FALSE),
(66, 'Momentum is conserved in the absence of external forces', FALSE);

-- Insert values into answers table for 'What is a projectile?' (assuming question_id starts at 67)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(67, 'An object moving at a constant velocity', FALSE),
(67, 'An object held stationary in the air', FALSE),
(67, 'Any object thrown or launched, subject only to gravity', TRUE),
(67, 'An object propelled by a continuous force', FALSE),
(67, 'A rocket moving through space', FALSE),
(67, 'An object falling straight down at terminal velocity', FALSE);

-- Insert values into answers table for 'What is the trajectory of a projectile?' (assuming question_id = 68)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(68, 'A straight line', FALSE),
(68, 'A circle', FALSE),
(68, 'A hyperbola', FALSE),
(68, 'A parabolic curve', TRUE),
(68, 'An irregular, unpredictable path', FALSE),
(68, 'A vertical line straight down', FALSE);

-- Insert values into answers table for 'What are the horizontal and vertical components of a projectiles velocity?' (assuming question_id = 69)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(69, 'Speed and direction', FALSE),
(69, 'Magnitude and angle', FALSE),
(69, 'Initial and final velocity', FALSE),
(69, 'Independent horizontal (constant velocity) and vertical (affected by gravity) components', TRUE),
(69, 'Acceleration and displacement', FALSE),
(69, 'Force and momentum', FALSE);

-- Insert values into answers table for 'What is the effect of gravity on the vertical motion of a projectile?' (assuming question_id = 70)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(70, 'It causes a constant upward acceleration', FALSE),
(70, 'It has no effect on the vertical motion', FALSE),
(70, 'It causes a constant horizontal acceleration', FALSE),
(70, 'It causes a constant downward acceleration', TRUE),
(70, 'It causes a velocity that remains constant', FALSE),
(70, 'It causes a decreasing downward acceleration', FALSE);

-- Insert values into answers table for 'What remains constant during the horizontal motion of a projectile (ignoring air resistance)?' (assuming question_id = 71)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(71, 'The speed', FALSE),
(71, 'The acceleration', FALSE),
(71, 'The force acting on it', FALSE),
(71, 'The horizontal component of its velocity', TRUE),
(71, 'The vertical component of its velocity', FALSE),
(71, 'The total energy of the projectile', FALSE);

-- Insert values into answers table for 'What is the angle of projection for maximum range of a projectile on level ground (ignoring air resistance)?' (assuming question_id = 72)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(72, '0 degrees', FALSE),
(72, '30 degrees', FALSE),
(72, '60 degrees', FALSE),
(72, '45 degrees', TRUE),
(72, '90 degrees', FALSE),
(72, '75 degrees', FALSE);

-- Insert values into answers table for 'What is the Zeroth Law of Thermodynamics?' (assuming question_id starts at 73)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(73, 'Energy cannot be created or destroyed', FALSE),
(73, 'Entropy always increases in an isolated system', FALSE),
(73, 'If two systems are in thermal equilibrium with a third, they are in equilibrium with each other', TRUE),
(73, 'The total energy of an isolated system is constant', FALSE),
(73, 'Absolute zero cannot be reached', FALSE),
(73, 'Heat flows spontaneously from hotter to colder objects', FALSE);

-- Insert values into answers table for 'What is the First Law of Thermodynamics?' (assuming question_id = 74)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(74, 'Entropy always increases', FALSE),
(74, 'Heat flows from cold to hot spontaneously', FALSE),
(74, 'Energy is conserved; ΔU = Q - W', TRUE),
(74, 'Two systems in thermal equilibrium have the same temperature', FALSE),
(74, 'Absolute zero cannot be reached', FALSE),
(74, 'Work done is independent of the path taken', FALSE);

-- Insert values into answers table for 'What is internal energy (U)?' (assuming question_id = 75)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(75, 'Energy transferred due to temperature difference', FALSE),
(75, 'Energy transferred when a force causes displacement', FALSE),
(75, 'The energy of motion of an object as a whole', FALSE),
(75, 'Total energy stored within a system at the molecular level', TRUE),
(75, 'The rate at which energy is transferred', FALSE),
(75, 'The disorder of a system', FALSE);

-- Insert values into answers table for 'What is heat (Q) in thermodynamics?' (assuming question_id = 76)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(76, 'The total energy of a system', FALSE),
(76, 'Energy transferred when a force causes displacement', FALSE),
(76, 'The rate of energy transfer', FALSE),
(76, 'Transfer of thermal energy due to temperature difference', TRUE),
(76, 'The disorder of a system', FALSE),
(76, 'The energy of motion of molecules', FALSE);

-- Insert values into answers table for 'What is work (W) in thermodynamics?' (assuming question_id = 77)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(77, 'The total energy of a system', FALSE),
(77, 'Transfer of thermal energy', FALSE),
(77, 'The rate of energy transfer', FALSE),
(77, 'Energy transferred by a force causing displacement', TRUE),
(77, 'The disorder of a system', FALSE),
(77, 'The average kinetic energy of molecules', FALSE);

-- Insert values into answers table for 'What is the Second Law of Thermodynamics?' (assuming question_id = 78)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(78, 'Energy is always conserved', FALSE),
(78, 'Heat flows from cold to hot spontaneously', FALSE),
(78, 'The total entropy of an isolated system increases or remains constant', TRUE),
(78, 'Absolute zero can be reached', FALSE),
(78, 'The internal energy of a system is constant', FALSE),
(78, 'Work done is independent of the path taken', FALSE);

-- Insert values into answers table for 'What is conduction?' (assuming question_id starts at 79)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(79, 'Heat transfer through electromagnetic waves', FALSE),
(79, 'Heat transfer through the movement of fluids', FALSE),
(79, 'Heat transfer by direct contact between particles', TRUE),
(79, 'Heat transfer in a vacuum', FALSE),
(79, 'The process of heating a fluid from below', FALSE),
(79, 'The emission of energy as infrared radiation', FALSE);

-- Insert values into answers table for 'What is convection?' (assuming question_id = 80)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(80, 'Heat transfer by direct contact', FALSE),
(80, 'Heat transfer through electromagnetic waves', FALSE),
(80, 'Heat transfer through the movement of fluids due to density differences', TRUE),
(80, 'Heat transfer in solids', FALSE),
(80, 'The process of heat transfer through a vacuum', FALSE),
(80, 'The absorption of thermal energy', FALSE);

-- Insert values into answers table for 'What is radiation?' (assuming question_id = 81)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(81, 'Heat transfer through direct physical contact', FALSE),
(81, 'Heat transfer through the movement of liquids only', FALSE),
(81, 'Heat transfer through the movement of gases only', FALSE),
(81, 'Heat transfer through electromagnetic waves', TRUE),
(81, 'Heat transfer that only occurs in solids', FALSE),
(81, 'Heat transfer that requires a dense medium', FALSE);

-- Insert values into answers table for 'Give an example of heat transfer by conduction.' (assuming question_id = 82)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(82, 'Sun warming the Earth', FALSE),
(82, 'Boiling water in a pot', FALSE),
(82, 'Heating of a metal spoon in hot soup', TRUE),
(82, 'Warm air rising from a heater', FALSE),
(82, 'Microwave oven heating food', FALSE),
(82, 'Feeling the warmth of a campfire from a distance', FALSE);

-- Insert values into answers table for 'Give an example of heat transfer by convection.' (assuming question_id = 83)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(83, 'Heat traveling from the sun to Earth', FALSE),
(83, 'A metal rod heating up at the end you touch to a flame', FALSE),
(83, 'Circulation of hot air in a room from a radiator', TRUE),
(83, 'Feeling the warmth of a lightbulb', FALSE),
(83, 'Ice melting in your hand', FALSE),
(83, 'The ground warming up on a sunny day', FALSE);

-- Insert values into answers table for 'Give an example of heat transfer by radiation.' (assuming question_id = 84)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(84, 'Heating water on a stove', FALSE),
(84, 'Feeling the warmth when touching a hot pan', FALSE),
(84, 'The movement of hot air balloons', FALSE),
(84, 'Heat from the sun warming the Earth', TRUE),
(84, 'A spoon getting hot in hot coffee', FALSE),
(84, 'The cooling of a room by an air conditioner', FALSE);

-- Insert values into answers table for 'What is entropy?' (assuming question_id starts at 85)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(85, 'The total energy of a system', FALSE),
(85, 'The heat content of a system', FALSE),
(85, 'A measure of the disorder or randomness of a system', TRUE),
(85, 'The capacity to do work', FALSE),
(85, 'The rate of energy transfer', FALSE),
(85, 'The average kinetic energy of molecules', FALSE);

-- Insert values into answers table for 'According to the Second Law of Thermodynamics, what happens to the entropy of an isolated system over time?' (assuming question_id = 86)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(86, 'It tends to decrease', FALSE),
(86, 'It remains constant', FALSE),
(86, 'It tends to increase', TRUE),
(86, 'It fluctuates randomly', FALSE),
(86, 'It cycles up and down', FALSE),
(86, 'It reaches a minimum value', FALSE);

-- Insert values into answers table for 'Is entropy a state function or a path function?' (assuming question_id = 87)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(87, 'Neither', FALSE),
(87, 'Both', FALSE),
(87, 'A path function', FALSE),
(87, 'A state function', TRUE),
(87, 'Depends on the process', FALSE),
(87, 'Related to work done', FALSE);

-- Insert values into answers table for 'What happens to the entropy of the universe during a spontaneous process?' (assuming question_id = 88)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(88, 'It decreases', FALSE),
(88, 'It remains constant', FALSE),
(88, 'It always increases', TRUE),
(88, 'It may increase or decrease depending on the process', FALSE),
(88, 'It fluctuates around zero', FALSE),
(88, 'It approaches a minimum value', FALSE);

-- Insert values into answers table for 'Give an example of a process where entropy increases.' (assuming question_id = 89)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(89, 'Water freezing into ice', FALSE),
(89, 'A gas being compressed', FALSE),
(89, 'Two different gases mixing', TRUE),
(89, 'Salt crystallizing out of a solution', FALSE),
(89, 'A plant growing from a seed', FALSE),
(89, 'A protein folding into its functional shape', FALSE);

-- Insert values into answers table for 'How is entropy related to the availability of useful energy?' (assuming question_id = 90)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(90, 'Entropy is directly proportional to the availability of useful energy', FALSE),
(90, 'Entropy is inversely proportional to the rate of energy transfer', FALSE),
(90, 'As entropy increases, the availability of useful energy decreases', TRUE),
(90, 'Entropy has no direct relationship with the availability of useful energy', FALSE),
(90, 'High entropy systems have more useful energy', FALSE),
(90, 'Entropy measures the total amount of energy in a system', FALSE);

-- Insert values into answers table for 'What is an electric field?' (assuming question_id starts at 91)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(91, 'The flow of electric charge', FALSE),
(91, 'A region where magnetic forces are exerted', FALSE),
(91, 'A region where a force acts on electric charges', TRUE),
(91, 'The energy stored in a charged object', FALSE),
(91, 'The rate of change of electric potential', FALSE),
(91, 'The path followed by an electric charge', FALSE);

-- Insert values into answers table for 'What is the direction of the electric field lines around a positive charge?' (assuming question_id = 92)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(92, 'Circling the charge clockwise', FALSE),
(92, 'Circling the charge counterclockwise', FALSE),
(92, 'Radially inward towards the charge', FALSE),
(92, 'Radially outward from the charge', TRUE),
(92, 'Parallel to the surface of the charge', FALSE),
(92, 'Randomly oriented', FALSE);

-- Insert values into answers table for 'What is the direction of the electric field lines around a negative charge?' (assuming question_id = 93)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(93, 'Radially outward from the charge', FALSE),
(93, 'Parallel to the surface of the charge', FALSE),
(93, 'Randomly oriented', FALSE),
(93, 'Radially inward towards the charge', TRUE),
(93, 'Circling the charge clockwise', FALSE),
(93, 'Circling the charge counterclockwise', FALSE);

-- Insert values into answers table for 'What is the unit of electric field strength?' (assuming question_id = 94)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(94, 'Joules (J)', FALSE),
(94, 'Amperes (A)', FALSE),
(94, 'Volts (V)', FALSE),
(94, 'Newtons per Coulomb (N/C)', TRUE),
(94, 'Ohms (Ω)', FALSE),
(94, 'Farads (F)', FALSE);

-- Insert values into answers table for 'How does the strength of the electric field vary with distance from a point charge?' (assuming question_id = 95)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(95, 'Directly proportional to the distance (E ∝ r)', FALSE),
(95, 'Directly proportional to the square of the distance (E ∝ r²)', FALSE),
(95, 'Inversely proportional to the distance (E ∝ 1/r)', FALSE),
(95, 'Inversely proportional to the square of the distance (E ∝ 1/r²)', TRUE),
(95, 'It remains constant with distance', FALSE),
(95, 'It varies linearly with the inverse of the distance (E ∝ -r)', FALSE);

-- Insert values into answers table for 'What happens to electric field lines when they encounter a conductor in electrostatic equilibrium?' (assuming question_id = 96)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(96, 'They run parallel to the surface of the conductor', FALSE),
(96, 'They pass through the conductor unchanged', FALSE),
(96, 'They are perpendicular to the surface and the field inside is zero', TRUE),
(96, 'They are absorbed by the conductor', FALSE),
(96, 'They increase in strength inside the conductor', FALSE),
(96, 'They curve away from the conductor', FALSE);

-- Insert values into answers table for 'What creates a magnetic field?' (assuming question_id starts at 97)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(97, 'Stationary electric charges only', FALSE),
(97, 'Constant electric fields only', FALSE),
(97, 'Moving electric charges and intrinsic magnetic moments', TRUE),
(97, 'Gravitational fields', FALSE),
(97, 'Pressure differences', FALSE),
(97, 'Sound waves', FALSE);

-- Insert values into answers table for 'What are magnetic field lines?' (assuming question_id = 98)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(98, 'Lines representing the path of moving charges', FALSE),
(98, 'Physical lines of magnetic force', FALSE),
(98, 'Imaginary lines showing direction and strength of a magnetic field, forming closed loops', TRUE),
(98, 'Lines indicating the flow of electric current', FALSE),
(98, 'Lines that start on north poles and end on south poles outside a magnet', FALSE),
(98, 'Lines that always point away from a magnet', FALSE);

-- Insert values into answers table for 'What is the direction of the magnetic field around a straight current-carrying wire?' (assuming question_id = 99)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(99, 'Parallel to the wire in the direction of the current', FALSE),
(99, 'Parallel to the wire opposite to the direction of the current', FALSE),
(99, 'Radially outward from the wire', FALSE),
(99, 'Circular loops around the wire, determined by the right-hand rule', TRUE),
(99, 'Pointing directly towards the wire', FALSE),
(99, 'Random and unpredictable', FALSE);

-- Insert values into answers table for 'What is the unit of magnetic field strength (magnetic flux density)?' (assuming question_id = 100)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(100, 'Ampere (A)', FALSE),
(100, 'Volt (V)', FALSE),
(100, 'Ohm (Ω)', FALSE),
(100, 'Tesla (T)', TRUE),
(100, 'Weber (Wb)', FALSE),
(100, 'Farad (F)', FALSE);

-- Insert values into answers table for 'What is the force on a moving charged particle in a magnetic field?' (assuming question_id = 101)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(101, 'Parallel to both velocity and magnetic field', FALSE),
(101, 'In the direction of the magnetic field', FALSE),
(101, 'In the direction of the velocity', FALSE),
(101, 'Perpendicular to both velocity and magnetic field', TRUE),
(101, 'In the opposite direction to the velocity', FALSE),
(101, 'In the opposite direction to the magnetic field', FALSE);

-- Insert values into answers table for 'What is electromagnetic induction?' (assuming question_id starts at 102)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(102, 'The creation of a magnetic field by an electric current', FALSE),
(102, 'The force between two stationary electric charges', FALSE),
(102, 'The production of EMF across a conductor in a changing magnetic field', TRUE),
(102, 'The heating of a conductor by an electric current', FALSE),
(102, 'The alignment of magnetic domains in a material', FALSE),
(102, 'The generation of light by an electric current', FALSE);

-- Insert values into answers table for 'Who is credited with the discovery of electromagnetic induction?' (assuming question_id = 103)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(103, 'Isaac Newton', FALSE),
(103, 'Albert Einstein', FALSE),
(103, 'Benjamin Franklin', FALSE),
(103, 'Michael Faraday', TRUE),
(103, 'Alessandro Volta', FALSE),
(103, 'André-Marie Ampère', FALSE);

-- Insert values into answers table for 'What is Faraday\'s Law of Induction?' (assuming question_id = 104)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(104, 'The force on a moving charge in a magnetic field', FALSE),
(104, 'The magnetic field created by a current', FALSE),
(104, 'Induced EMF is proportional to the rate of change of magnetic flux', TRUE),
(104, 'The direction of induced current opposes the change in magnetic flux', FALSE),
(104, 'Electric field is the negative gradient of electric potential', FALSE),
(104, 'Current is proportional to voltage', FALSE);

-- Insert values into answers table for 'What is magnetic flux?' (assuming question_id = 105)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(105, 'The strength of a magnetic field', FALSE),
(105, 'The current flowing through a wire', FALSE),
(105, 'The area enclosed by a magnetic field line', FALSE),
(105, 'The total magnetic field passing through a given area', TRUE),
(105, 'The force exerted by a magnetic field on a moving charge', FALSE),
(105, 'The energy stored in a magnetic field', FALSE);

-- Insert values into answers table for 'What is Lenz\'s Law?' (assuming question_id = 106)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(106, 'Induced EMF is proportional to the rate of change of magnetic flux', FALSE),
(106, 'The force on a current-carrying wire in a magnetic field', FALSE),
(106, 'The magnetic field created by a current', FALSE),
(106, 'The direction of induced current opposes the change in magnetic flux', TRUE),
(106, 'The force between two magnetic poles', FALSE),
(106, 'Magnetic field lines form closed loops', FALSE);

-- Insert values into answers table for 'In which of the following devices is electromagnetic induction a fundamental principle of operation?' (assuming question_id = 107)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(107, 'Electric motors (DC)', FALSE),
(107, 'Light-emitting diodes (LEDs)', FALSE),
(107, 'Resistors', FALSE),
(107, 'Electric generators', TRUE),
(107, 'Capacitors', FALSE),
(107, 'Simple circuits with batteries and wires', FALSE);

-- Insert values into answers table for 'Who is the protagonist of Hamlet?' (assuming question_id starts at 108)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(108, 'Claudius', FALSE),
(108, 'Polonius', FALSE),
(108, 'Hamlet', TRUE),
(108, 'Laertes', FALSE),
(108, 'Horatio', FALSE),
(108, 'The Ghost', FALSE);

-- Insert values into answers table for 'What is the ghosts primary demand of Hamlet?' (assuming question_id = 109)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(109, 'To marry Ophelia', FALSE),
(109, 'To leave Denmark', FALSE),
(109, 'To avenge his murder by killing Claudius', TRUE),
(109, 'To become the next king', FALSE),
(109, 'To protect Gertrude', FALSE),
(109, 'To reveal the secrets of the afterlife', FALSE);

-- Insert values into answers table for 'Who is Ophelia in relation to Hamlet?' (assuming question_id = 110)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(110, 'His sister', FALSE),
(110, 'His mother', FALSE),
(110, 'His aunt', FALSE),
(110, 'His lover', TRUE),
(110, 'His cousin', FALSE),
(110, 'His stepdaughter', FALSE);

-- Insert values into answers table for 'How does Claudius die?' (assuming question_id = 111)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(111, 'He is killed in a duel with Laertes', FALSE),
(111, 'He dies of natural causes', FALSE),
(111, 'He commits suicide out of guilt', FALSE),
(111, 'Hamlet forces him to drink poison and stabs him with a poisoned sword', TRUE),
(111, 'He is killed by the ghost of King Hamlet', FALSE),
(111, 'He is overthrown by Fortinbras', FALSE);

-- Insert values into answers table for 'What is the famous "To be or not to be" soliloquy about?' (assuming question_id = 112)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(112, 'His love for Ophelia', FALSE),
(112, 'His ambition to become king', FALSE),
(112, 'His plans for revenge', FALSE),
(112, 'A meditation on life and death, and the question of enduring suffering or taking action', TRUE),
(112, 'His distrust of Rosencrantz and Guildenstern', FALSE),
(112, 'His longing to return to Wittenberg', FALSE);

-- Insert values into answers table for 'What is the significance of the play within a play, "The Mousetrap"?' (assuming question_id = 113)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(113, 'It is a form of entertainment for the court', FALSE),
(113, 'It reveals Hamlets madness to Ophelia', FALSE),
(113, 'It provides comic relief in the tragedy', FALSE),
(113, 'It is used by Hamlet to gauge Claudiuss guilt', TRUE),
(113, 'It foreshadows the deaths of Rosencrantz and Guildenstern', FALSE),
(113, 'It is a play written by Hamlet himself', FALSE);

-- Insert values into answers table for 'What are the prophecies given to Macbeth by the witches?' (assuming question_id starts at 114)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(114, 'He will be banished from Scotland', FALSE),
(114, 'He will have no children', FALSE),
(114, 'He will die in battle', FALSE),
(114, 'He will be Thane of Glamis, Thane of Cawdor, and King of Scotland', TRUE),
(114, 'He will be a great warrior but never a king', FALSE),
(114, 'He will be haunted by Banquos ghost', FALSE);

-- Insert values into answers table for 'Who is Duncan in the play?' (assuming question_id = 115)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(115, 'Macbeths best friend', FALSE),
(115, 'A traitor to Scotland', FALSE),
(115, 'The King of England', FALSE),
(115, 'The King of Scotland', TRUE),
(115, 'One of the witches', FALSE),
(115, 'Macbeths father', FALSE);

-- Insert values into answers table for 'Who encourages Macbeth to kill Duncan?' (assuming question_id = 116)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(116, 'Banquo', FALSE),
(116, 'Malcolm', FALSE),
(116, 'Ross', FALSE),
(116, 'Lady Macbeth', TRUE),
(116, 'The witches', FALSE),
(116, 'Macduff', FALSE);

-- Insert values into answers table for 'What vision does Macbeth see before killing Duncan?' (assuming question_id = 117)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(117, 'The ghost of Banquo', FALSE),
(117, 'A bloody child', FALSE),
(117, 'A crown floating in the air', FALSE),
(117, 'A floating dagger pointing towards Duncans chamber', TRUE),
(117, 'The three witches dancing', FALSE),
(117, 'His own grave', FALSE);

-- Insert values into answers table for 'What is the significance of Banquos ghost?' (assuming question_id = 118)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(118, 'It warns Macbeth of future dangers', FALSE),
(118, 'It reveals the witches true identities', FALSE),
(118, 'It encourages Macbeth to seek forgiveness', FALSE),
(118, 'It symbolizes Macbeths guilt and the consequences of his actions', TRUE),
(118, 'It foretells the arrival of Macduff', FALSE),
(118, 'It represents Macbeths lost honor', FALSE);

-- Insert values into answers table for 'How is Macbeth ultimately defeated?' (assuming question_id = 119)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(119, 'He dies in a duel with Malcolm', FALSE),
(119, 'He is killed by the witches prophecies coming true', FALSE),
(119, 'He commits suicide out of despair', FALSE),
(119, 'He is killed by Macduff, who was not born of woman', TRUE),
(119, 'His own soldiers turn against him', FALSE),
(119, 'He is defeated by an invading English army', FALSE);

-- Insert values into answers table for 'From which families do Romeo and Juliet come?' (assuming question_id starts at 120)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(120, 'Both are Montagues', FALSE),
(120, 'Both are Capulets', FALSE),
(120, 'Romeo is a Capulet, Juliet is a Montague', FALSE),
(120, 'Romeo is a Montague and Juliet is a Capulet', TRUE),
(120, 'They are from neutral families', FALSE),
(120, 'Their families are allies', FALSE);

-- Insert values into answers table for 'Where is the play primarily set?' (assuming question_id = 121)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(121, 'London, England', FALSE),
(121, 'Paris, France', FALSE),
(121, 'Rome, Italy', FALSE),
(121, 'Verona, Italy', TRUE),
(121, 'Mantua, Italy', FALSE),
(121, 'Florence, Italy', FALSE);

-- Insert values into answers table for 'Who is Mercutio?' (assuming question_id = 122)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(122, 'Juliets cousin', FALSE),
(122, 'Romeos enemy', FALSE),
(122, 'The Prince of Verona', FALSE),
(122, 'Romeos friend', TRUE),
(122, 'Juliets suitor', FALSE),
(122, 'A Capulet servant', FALSE);

-- Insert values into answers table for 'How do Romeo and Juliet meet?' (assuming question_id = 123)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(123, 'At a public market', FALSE),
(123, 'At a church service', FALSE),
(123, 'At Romeos house', FALSE),
(123, 'At a Capulet feast', TRUE),
(123, 'In the street during a fight', FALSE),
(123, 'Through a mutual friend', FALSE);

-- Insert values into answers table for 'Why does Romeo kill Tybalt?' (assuming question_id = 124)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(124, 'Out of hatred for the Capulets', FALSE),
(124, 'To win Juliets affection', FALSE),
(124, 'In self-defense', FALSE),
(124, 'To avenge the death of Mercutio', TRUE),
(124, 'Because Tybalt attacked Juliet', FALSE),
(124, 'On the orders of the Prince', FALSE);

-- Insert values into answers table for 'How do Romeo and Juliet die?' (assuming question_id = 125)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(125, 'They are killed by the feuding families', FALSE),
(125, 'They die in a fire', FALSE),
(125, 'They are banished and die of grief', FALSE),
(125, 'Romeo drinks poison believing Juliet is dead; Juliet stabs herself seeing Romeo dead', TRUE),
(125, 'They die of a plague', FALSE),
(125, 'They are executed by the Prince', FALSE);

-- Insert values into answers table for 'Who is the narrator of "To Kill a Mockingbird"?' (assuming question_id starts at 126)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(126, 'Atticus Finch', FALSE),
(126, 'Jem Finch', FALSE),
(126, 'Boo Radley', FALSE),
(126, 'Scout Finch', TRUE),
(126, 'Tom Robinson', FALSE),
(126, 'Miss Maudie Atkinson', FALSE);

-- Insert values into answers table for 'What is Atticus Finchs profession?' (assuming question_id = 127)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(127, 'Doctor', FALSE),
(127, 'Teacher', FALSE),
(127, 'Sheriff', FALSE),
(127, 'Lawyer', TRUE),
(127, 'Farmer', FALSE),
(127, 'Preacher', FALSE);

-- Insert values into answers table for 'Who is Tom Robinson accused of assaulting?' (assuming question_id = 128)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(128, 'Stephanie Crawford', FALSE),
(128, 'Miss Maudie Atkinson', FALSE),
(128, 'Calpurnia', FALSE),
(128, 'Mayella Ewell', TRUE),
(128, 'Scout Finch', FALSE),
(128, 'Dill Harris', FALSE);

-- Insert values into answers table for 'What is Boo Radleys real first name?' (assuming question_id = 129)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(129, 'Nathan', FALSE),
(129, 'Jeremy', FALSE),
(129, 'Charles', FALSE),
(129, 'Arthur', TRUE),
(129, 'Robert', FALSE),
(129, 'John', FALSE);

-- Insert values into answers table for 'What does the mockingbird symbolize in the novel?' (assuming question_id = 130)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(130, 'Courage', FALSE),
(130, 'Prejudice', FALSE),
(130, 'Justice', FALSE),
(130, 'Innocence and harmlessness', TRUE),
(130, 'Fear', FALSE),
(130, 'Hypocrisy', FALSE);

-- Insert values into answers table for 'What is the verdict in Tom Robinsons trial?' (assuming question_id = 131)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(131, 'Not guilty', FALSE),
(131, 'The jury was hung', FALSE),
(131, 'Guilty', TRUE),
(131, 'The case was dismissed', FALSE),
(131, 'He was sentenced to life in prison', FALSE),
(131, 'He was acquitted on appeal', FALSE);

-- Insert values into answers table for 'Who is the protagonist of "1984"?' (assuming question_id starts at 132)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(132, 'Big Brother', FALSE),
(132, 'O Brien', FALSE),
(132, 'Julia', FALSE),
(132, 'Winston Smith', TRUE),
(132, 'Syme', FALSE),
(132, 'Parsons', FALSE);

-- Insert values into answers table for 'Who is Big Brother?' (assuming question_id = 133)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(133, 'A former leader overthrown by the Party', FALSE),
(133, 'Winston Smiths secret identity', FALSE),
(133, 'The embodiment of freedom and rebellion', FALSE),
(133, 'The enigmatic leader of the Party in Oceania', TRUE),
(133, 'The head of the Thought Police', FALSE),
(133, 'A mythical figure used to scare citizens', FALSE);

-- Insert values into answers table for 'What is the Thought Police?' (assuming question_id = 134)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(134, 'The military force of Oceania', FALSE),
(134, 'The department in charge of propaganda', FALSE),
(134, 'The secret police who punish thoughtcrime', TRUE),
(134, 'The organization that controls the food supply', FALSE),
(134, 'The group responsible for rewriting history', FALSE),
(134, 'The inner circle of the Party', FALSE);

-- Insert values into answers table for 'What is Newspeak?' (assuming question_id = 135)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(135, 'The language spoken by the proles', FALSE),
(135, 'The language used in the Ministry of Love', FALSE),
(135, 'The language of the Inner Party', FALSE),
(135, 'The official language of Oceania, designed to limit thought', TRUE),
(135, 'A secret code used by rebels', FALSE),
(135, 'The language of the past, being phased out', FALSE);

-- Insert values into answers table for 'What is Room 101?' (assuming question_id = 136)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(136, 'A meeting place for rebels', FALSE),
(136, 'Winstons apartment', FALSE),
(136, 'A place where history is rewritten', FALSE),
(136, 'The place where prisoners face their worst fear', TRUE),
(136, 'A center for Newspeak development', FALSE),
(136, 'A hospital for Party members', FALSE);

-- Insert values into answers table for 'What happens to Winston at the end of the novel?' (assuming question_id = 137)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(137, 'He escapes Oceania and joins the rebellion', FALSE),
(137, 'He is executed for his thoughtcrimes', FALSE),
(137, 'He manages to maintain his hatred for Big Brother', FALSE),
(137, 'He is broken by the Party and comes to love Big Brother', TRUE),
(137, 'He dies peacefully in his sleep', FALSE),
(137, 'He becomes a leader in the Inner Party', FALSE);

-- Insert values into answers table for 'Who is the narrator of "The Great Gatsby"?' (assuming question_id starts at 138)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(138, 'Jay Gatsby', FALSE),
(138, 'Daisy Buchanan', FALSE),
(138, 'Jordan Baker', FALSE),
(138, 'Nick Carraway', TRUE),
(138, 'Tom Buchanan', FALSE),
(138, 'Myrtle Wilson', FALSE);

-- Insert values into answers table for 'Who is Jay Gatsby in the novel?' (assuming question_id = 139)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(139, 'A poor farmer from the Midwest', FALSE),
(139, 'A long-lost relative of the Buchanans', FALSE),
(139, 'A wealthy man known for his lavish parties', TRUE),
(139, 'A detective investigating the wealthy elite', FALSE),
(139, 'Nicks college roommate', FALSE),
(139, 'A famous athlete living in West Egg', FALSE);

-- Insert values into answers table for 'Who is Daisy Buchanan?' (assuming question_id = 140)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(140, 'Gatsbys sister', FALSE),
(140, 'Nicks love interest', FALSE),
(140, 'Toms mistress', FALSE),
(140, 'Nicks cousin and Gatsbys object of affection', TRUE),
(140, 'A famous singer in West Egg', FALSE),
(140, 'Gatsbys business partner', FALSE);

-- Insert values into answers table for 'What is the "valley of ashes"?' (assuming question_id = 141)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(141, 'A wealthy suburb of New York City', FALSE),
(141, 'The location of Gatsbys mansion', FALSE),
(141, 'A beautiful park in West Egg', FALSE),
(141, 'A desolate area representing moral decay', TRUE),
(141, 'The bustling downtown of New York City', FALSE),
(141, 'A historic landmark in Long Island', FALSE);

-- Insert values into answers table for 'What does the green light at the end of Daisys dock symbolize for Gatsby?' (assuming question_id = 142)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(142, 'His wealth and success', FALSE),
(142, 'His connection to the natural world', FALSE),
(142, 'His envy of Tom Buchanans status', FALSE),
(142, 'His hopes and dreams, particularly for Daisy', TRUE),
(142, 'A warning of danger', FALSE),
(142, 'His longing for the past in general', FALSE);

-- Insert values into answers table for 'How does Gatsby die?' (assuming question_id = 143)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(143, 'He dies in a car accident', FALSE),
(143, 'He is murdered by Tom Buchanan', FALSE),
(143, 'He drowns in his swimming pool', FALSE),
(143, 'He is shot by George Wilson, who believes Gatsby killed Myrtle', TRUE),
(143, 'He dies of a broken heart', FALSE),
(143, 'He is killed in a duel', FALSE);

-- Insert values into answers table for 'What is imagery in poetry?' (assuming question_id starts at 144)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(144, 'The rhythm and meter of a poem', FALSE),
(144, 'The underlying message or theme of a poem', FALSE),
(144, 'Descriptive language appealing to the senses', TRUE),
(144, 'The use of figurative language like metaphors and similes', FALSE),
(144, 'The emotional tone or atmosphere of a poem', FALSE),
(144, 'The structure and organization of a poem', FALSE);

-- Insert values into answers table for 'What is a symbol in poetry?' (assuming question_id = 145)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(145, 'A comparison using like or as', FALSE),
(145, 'Giving human qualities to inanimate objects', FALSE),
(145, 'A direct comparison without using like or as', FALSE),
(145, 'A word, object, or idea representing something else', TRUE),
(145, 'An exaggeration for effect', FALSE),
(145, 'The repetition of consonant sounds', FALSE);

-- Insert values into answers table for 'What is a metaphor?' (assuming question_id = 146)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(146, 'A comparison using like or as', FALSE),
(146, 'Giving human qualities to inanimate objects', FALSE),
(146, 'A direct comparison of two unlike things', TRUE),
(146, 'A word or object that represents something else', FALSE),
(146, 'An exaggeration for effect', FALSE),
(146, 'The repetition of vowel sounds', FALSE);

-- Insert values into answers table for 'What is a simile?' (assuming question_id = 147)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(147, 'A direct comparison of two unlike things', FALSE),
(147, 'Giving human qualities to inanimate objects', FALSE),
(147, 'A word or object that represents something else', FALSE),
(147, 'A comparison of two unlike things using like or as', TRUE),
(147, 'An understatement for effect', FALSE),
(147, 'The repetition of initial consonant sounds', FALSE);

-- Insert values into answers table for 'What is personification?' (assuming question_id = 148)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(148, 'A comparison using like or as', FALSE),
(148, 'A direct comparison of two unlike things', FALSE),
(148, 'A word or object that represents something else', FALSE),
(148, 'Giving human qualities to non-human things', TRUE),
(148, 'An overstatement for effect', FALSE),
(148, 'The use of contradictory terms', FALSE);

-- Insert values into answers table for 'How does imagery contribute to the overall meaning of a poem?' (assuming question_id = 149)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(149, 'It primarily establishes the rhyme scheme', FALSE),
(149, 'It mainly dictates the poems meter', FALSE),
(149, 'It can create mood, evoke emotion, establish setting, develop themes, and enhance understanding', TRUE),
(149, 'It serves only to make the poem longer', FALSE),
(149, 'It is solely for decorative purposes', FALSE),
(149, 'It always clarifies the poems literal meaning', FALSE);

-- Insert values into answers table for 'What is a sonnet?' (assuming question_id starts at 150)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(150, 'A three-line poem with a 5-7-5 syllable structure', FALSE),
(150, 'A poem with no regular rhyme or meter', FALSE),
(150, 'A narrative poem often of folk origin', FALSE),
(150, 'A 14-line poem with a specific rhyme scheme and meter', TRUE),
(150, 'A poem of serious reflection, typically for the dead', FALSE),
(150, 'An eight-line poem', FALSE);

-- Insert values into answers table for 'What is a haiku?' (assuming question_id = 151)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(151, 'A 14-line poem with a specific rhyme scheme', FALSE),
(151, 'A poem with no regular rhyme or meter', FALSE),
(151, 'A narrative poem in quatrains', FALSE),
(151, 'A three-line poem with a 5-7-5 syllable structure', TRUE),
(151, 'A poem of lament for the dead', FALSE),
(151, 'A poem with rhyming couplets', FALSE);

-- Insert values into answers table for 'What is free verse poetry?' (assuming question_id = 152)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(152, 'A 14-line poem', FALSE),
(152, 'A three-line poem with a syllable count', FALSE),
(152, 'A narrative poem with a simple rhyme scheme', FALSE),
(152, 'Poetry that does not adhere to regular rhyme or meter', TRUE),
(152, 'A poem of mourning', FALSE),
(152, 'Poetry with a strict ABAB rhyme scheme', FALSE);

-- Insert values into answers table for 'What is a ballad?' (assuming question_id = 153)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(153, 'A short, lyrical poem', FALSE),
(153, 'A poem with no set rhyme or rhythm', FALSE),
(153, 'A 14-line love poem', FALSE),
(153, 'A narrative poem in quatrains with a simple rhyme scheme', TRUE),
(153, 'A poem expressing grief', FALSE),
(153, 'A poem celebrating a hero', FALSE);

-- Insert values into answers table for 'What is an elegy?' (assuming question_id = 154)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(154, 'A humorous poem', FALSE),
(154, 'A poem celebrating life', FALSE),
(154, 'A narrative poem', FALSE),
(154, 'A poem of serious reflection, typically a lament for the dead', TRUE),
(154, 'A poem with a strict syllable count', FALSE),
(154, 'A poem intended to be sung', FALSE);

-- Insert values into answers table for 'How does poetic form influence the meaning and impact of a poem?' (assuming question_id = 155)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(155, 'It primarily determines the poems length', FALSE),
(155, 'It mainly affects the poems vocabulary', FALSE),
(155, 'It can constrain or liberate expression, emphasize ideas through structure, and create specific effects', TRUE),
(155, 'It has little to no impact on the poems meaning', FALSE),
(155, 'It solely dictates the poems subject matter', FALSE),
(155, 'It only serves to make the poem more difficult to understand', FALSE);

-- Insert values into answers table for 'What is rhyme in poetry?' (assuming question_id starts at 156)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(156, 'The pattern of stressed and unstressed syllables', FALSE),
(156, 'The repetition of consonant sounds at the beginning of words', FALSE),
(156, 'The repetition of vowel sounds within words', FALSE),
(156, 'The repetition of similar sounds, usually at the end of lines', TRUE),
(156, 'The repetition of consonant sounds within or at the end of words', FALSE),
(156, 'The overall structure and organization of a poem', FALSE);

-- Insert values into answers table for 'What is rhythm in poetry?' (assuming question_id = 157)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(157, 'The repetition of similar ending sounds', FALSE),
(157, 'The repetition of beginning consonant sounds', FALSE),
(157, 'The repetition of vowel sounds within words', FALSE),
(157, 'The pattern of stressed and unstressed syllables', TRUE),
(157, 'The repetition of consonant sounds within or at the end of words', FALSE),
(157, 'The use of descriptive language', FALSE);

-- Insert values into answers table for 'What is alliteration?' (assuming question_id = 158)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(158, 'Repetition of similar ending sounds', FALSE),
(158, 'Repetition of vowel sounds within words', FALSE),
(158, 'Repetition of consonant sounds within or at the end of words', FALSE),
(158, 'Repetition of consonant sounds at the beginning of words in close proximity', TRUE),
(158, 'The beat and flow of the poem', FALSE),
(158, 'The use of words that imitate sounds', FALSE);

-- Insert values into answers table for 'What is assonance?' (assuming question_id = 159)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(159, 'Repetition of similar ending sounds', FALSE),
(159, 'Repetition of consonant sounds at the beginning of words', FALSE),
(159, 'Repetition of consonant sounds within or at the end of words', FALSE),
(159, 'Repetition of vowel sounds within words in close proximity', TRUE),
(159, 'The pattern of stressed and unstressed syllables', FALSE),
(159, 'The use of exaggerated statements', FALSE);

-- Insert values into answers table for 'What is consonance?' (assuming question_id = 160)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(160, 'Repetition of similar ending sounds', FALSE),
(160, 'Repetition of consonant sounds at the beginning of words', FALSE),
(160, 'Repetition of vowel sounds within words', FALSE),
(160, 'Repetition of consonant sounds within or at the end of words in close proximity', TRUE),
(160, 'The beat and flow of the poem', FALSE),
(160, 'The use of language that appeals to the senses', FALSE);

-- Insert values into answers table for 'How do sound devices contribute to the overall effect of a poem?' (assuming question_id = 161)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(161, 'They primarily determine the poems length', FALSE),
(161, 'They mainly dictate the poems subject matter', FALSE),
(161, 'They solely establish the poems rhyme scheme', FALSE),
(161, 'They can create musicality, emphasize ideas, establish mood, and enhance emotional impact', TRUE),
(161, 'They only serve to make the poem more complex', FALSE),
(161, 'They have little to no impact on the readers experience', FALSE);

-- Insert values into answers table for 'What is the purpose of a sorting algorithm?' (assuming question_id starts at 162)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(162, 'To find a specific item in a collection', FALSE),
(162, 'To count the number of items in a collection', FALSE),
(162, 'To rearrange items into a specific order', TRUE),
(162, 'To remove duplicate items from a collection', FALSE),
(162, 'To add new items to a collection', FALSE),
(162, 'To reverse the order of items in a collection', FALSE);

-- Insert values into answers table for 'Which of the following is a comparison-based sorting algorithm?' (assuming question_id = 163)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(163, 'Counting sort', FALSE),
(163, 'Radix sort', FALSE),
(163, 'Bucket sort', FALSE),
(163, 'Bubble sort', TRUE),
(163, 'Pigeonhole sort', FALSE),
(163, 'Bogo sort', FALSE);

-- Insert values into answers table for 'What is the basic principle of bubble sort?' (assuming question_id = 164)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(164, 'Dividing the list into smaller sublists and merging them', FALSE),
(164, 'Selecting the smallest element and moving it to the beginning', FALSE),
(164, 'Repeatedly stepping through the list, comparing adjacent elements and swapping if out of order', TRUE),
(164, 'Picking a pivot element and partitioning the list', FALSE),
(164, 'Distributing elements into a number of buckets', FALSE),
(164, 'Counting the occurrences of each unique element', FALSE);

-- Insert values into answers table for 'What is the time complexity of merge sort in the average case?' (assuming question_id = 165)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(165, 'O(n^2)', FALSE),
(165, 'O(n)', FALSE),
(165, 'O(log n)', FALSE),
(165, 'O(n log n)', TRUE),
(165, 'O(2^n)', FALSE),
(165, 'O(n!)', FALSE);

-- Insert values into answers table for 'What is the advantage of quicksort over merge sort in some cases?' (assuming question_id = 166)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(166, 'Guaranteed O(n log n) time complexity in all cases', FALSE),
(166, 'Better worst-case time complexity', FALSE),
(166, 'Often better average-case performance and in-place implementation', TRUE),
(166, 'Requires significantly more extra memory', FALSE),
(166, 'Simpler to implement and understand', FALSE),
(166, 'Always performs faster for large datasets', FALSE);

-- Insert values into answers table for 'What is the difference between stable and unstable sorting algorithms?' (assuming question_id = 167)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(167, 'Stable sorts are faster than unstable sorts', FALSE),
(167, 'Unstable sorts can only handle numerical data', FALSE),
(167, 'Stable sorts maintain the relative order of equal elements, unstable sorts may not', TRUE),
(167, 'Unstable sorts always have a better time complexity', FALSE),
(167, 'Stable sorts require less memory than unstable sorts', FALSE),
(167, 'The difference lies in whether they sort in ascending or descending order', FALSE);

-- Insert values into answers table for 'What is the purpose of a searching algorithm?' (assuming question_id starts at 168)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(168, 'To arrange items in a specific order', FALSE),
(168, 'To count the number of items', FALSE),
(168, 'To find a specific item in a collection', TRUE),
(168, 'To remove items from a collection', FALSE),
(168, 'To add items to a collection', FALSE),
(168, 'To determine the size of a collection', FALSE);

-- Insert values into answers table for 'What is the basic principle of linear search?' (assuming question_id = 169)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(169, 'Repeatedly dividing the search interval in half', FALSE),
(169, 'Examining elements based on their value', FALSE),
(169, 'Sequentially checking each element until the target is found', TRUE),
(169, 'Comparing the middle element to the target', FALSE),
(169, 'Using a hash function to locate the element', FALSE),
(169, 'Checking elements in a random order', FALSE);

-- Insert values into answers table for 'What is the primary requirement for binary search to work efficiently?' (assuming question_id = 170)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(170, 'The collection must have a specific data type', FALSE),
(170, 'The collection must be sorted', TRUE),
(170, 'The collection must not contain duplicate elements', FALSE),
(170, 'The size of the collection must be known', FALSE),
(170, 'The elements must be stored in a specific data structure (e.g., array)', FALSE),
(170, 'The target element must be at the beginning or end', FALSE);

-- Insert values into answers table for 'How does binary search work?' (assuming question_id = 171)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(171, 'It checks every element sequentially', FALSE),
(171, 'It randomly selects elements until the target is found', FALSE),
(171, 'It divides the search interval in half repeatedly, searching the relevant half', TRUE),
(171, 'It starts from the end of the list and moves backwards', FALSE),
(171, 'It compares adjacent elements and swaps them if needed', FALSE),
(171, 'It uses a key to directly access the element', FALSE);

-- Insert values into answers table for 'What is the time complexity of binary search in the worst case?' (assuming question_id = 172)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(172, 'O(n)', FALSE),
(172, 'O(n^2)', FALSE),
(172, 'O(1)', FALSE),
(172, 'O(log n)', TRUE),
(172, 'O(n log n)', FALSE),
(172, 'O(2^n)', FALSE);

-- Insert values into answers table for 'In what scenario would linear search be more appropriate than binary search?' (assuming question_id = 173)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(173, 'When the dataset is very large and sorted', FALSE),
(173, 'When the target element is likely to be in the middle of a large dataset', FALSE),
(173, 'For very small datasets or unsorted data where sorting is costly', TRUE),
(173, 'When searching for multiple elements in a sorted dataset', FALSE),
(173, 'When memory usage is a critical concern', FALSE),
(173, 'When the dataset is already processed with a hash function', FALSE);

-- Insert values into answers table for 'What does Big O notation describe?' (assuming question_id starts at 174)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(174, 'The exact execution time of an algorithm', FALSE),
(174, 'The amount of memory an algorithm uses for a specific input', FALSE),
(174, 'The lower bound of an algorithms complexity', FALSE),
(174, 'The upper bound of the time or space complexity as input size grows', TRUE),
(174, 'The average-case performance of an algorithm', FALSE),
(174, 'The best-case performance of an algorithm', FALSE);

-- Insert values into answers table for 'What does O(n) represent in Big O notation?' (assuming question_id = 175)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(175, 'Constant time complexity', FALSE),
(175, 'Logarithmic time complexity', FALSE),
(175, 'Quadratic time complexity', FALSE),
(175, 'Linear time complexity', TRUE),
(175, 'Exponential time complexity', FALSE),
(175, 'Factorial time complexity', FALSE);

-- Insert values into answers table for 'What does O(1) represent in Big O notation?' (assuming question_id = 176)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(176, 'Linear time complexity', FALSE),
(176, 'Logarithmic time complexity', FALSE),
(176, 'Quadratic time complexity', FALSE),
(176, 'Constant time complexity', TRUE),
(176, 'Exponential time complexity', FALSE),
(176, 'Factorial time complexity', FALSE);

-- Insert values into answers table for 'What does O(log n) represent in Big O notation?' (assuming question_id = 177)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(177, 'Linear time complexity', FALSE),
(177, 'Constant time complexity', FALSE),
(177, 'Quadratic time complexity', FALSE),
(177, 'Logarithmic time complexity', TRUE),
(177, 'Exponential time complexity', FALSE),
(177, 'Factorial time complexity', FALSE);

-- Insert values into answers table for 'What does O(n^2) represent in Big O notation?' (assuming question_id = 178)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(178, 'Linear time complexity', FALSE),
(178, 'Logarithmic time complexity', FALSE),
(178, 'Constant time complexity', FALSE),
(178, 'Quadratic time complexity', TRUE),
(178, 'Exponential time complexity', FALSE),
(178, 'Factorial time complexity', FALSE);

-- Insert values into answers table for 'When analyzing algorithm efficiency with Big O notation, what aspect is typically the primary focus?' (assuming question_id = 179)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(179, 'Performance on small datasets', FALSE),
(179, 'The exact number of operations', FALSE),
(179, 'The performance on average hardware', FALSE),
(179, 'The asymptotic behavior for very large input sizes', TRUE),
(179, 'The performance in the best-case scenario', FALSE),
(179, 'The constant factors affecting execution time', FALSE);

-- Insert values into answers table for 'What is a primary key in a relational database?' (assuming question_id starts at 180)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(180, 'A key used for sorting data', FALSE),
(180, 'A key that links to another table', FALSE),
(180, 'A column uniquely identifying each row', TRUE),
(180, 'A key used for indexing', FALSE),
(180, 'A key that can have duplicate values', FALSE),
(180, 'A key used for full-text search', FALSE);

-- Insert values into answers table for 'What is a foreign key in a relational database?' (assuming question_id = 181)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(181, 'The main identifier of a table', FALSE),
(181, 'A key used for mathematical operations', FALSE),
(181, 'A column referring to the primary key of another table', TRUE),
(181, 'A key used for faster searching within a table', FALSE),
(181, 'A key that determines the order of columns', FALSE),
(181, 'A backup key in case the primary key fails', FALSE);

-- Insert values into answers table for 'What is a relational database schema?' (assuming question_id = 182)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(182, 'The actual data stored in the database', FALSE),
(182, 'A set of SQL queries', FALSE),
(182, 'The structure of the database, including tables, columns, relationships, and constraints', TRUE),
(182, 'A tool for managing database users and permissions', FALSE),
(182, 'A backup copy of the database', FALSE),
(182, 'A report on the databases performance', FALSE);

-- Insert values into answers table for 'What is the purpose of normalization in relational databases?' (assuming question_id = 183)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(183, 'To speed up query execution', FALSE),
(183, 'To increase the size of the database', FALSE),
(183, 'To reduce redundancy and improve data integrity', TRUE),
(183, 'To make the database more complex', FALSE),
(183, 'To limit the number of tables in a database', FALSE),
(183, 'To encrypt the data stored in the database', FALSE);

-- Insert values into answers table for 'What is a one-to-many relationship between tables?' (assuming question_id = 184)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(184, 'Each record in both tables can be linked to multiple records in the other', FALSE),
(184, 'One record in the first table is linked to exactly one record in the second', FALSE),
(184, 'One record in the first table can link to multiple in the second, but each in the second links to only one in the first', TRUE),
(184, 'Multiple records in the first table can only link to one in the second', FALSE),
(184, 'There is no direct link between the records in the two tables', FALSE),
(184, 'The relationship is determined by the order of data entry', FALSE);

-- Insert values into answers table for 'What is a many-to-many relationship between tables and how is it typically implemented?' (assuming question_id = 185)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(185, 'Multiple records in one table link to only one in the other, using foreign keys directly', FALSE),
(185, 'It is implemented by directly linking the tables without any intermediary', FALSE),
(185, 'It occurs when tables have the same primary key and is implemented by merging them', FALSE),
(185, 'Multiple records in each table can link to multiple in the other, using a junction table with foreign keys to both', TRUE),
(185, 'It is avoided in relational database design due to its complexity', FALSE),
(185, 'It is implemented using complex SQL queries without altering the table structure', FALSE);

-- Insert values into answers table for 'Which SQL command is used to retrieve data from a database?' (assuming question_id starts at 186)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(186, 'UPDATE', FALSE),
(186, 'INSERT INTO', FALSE),
(186, 'DELETE FROM', FALSE),
(186, 'SELECT', TRUE),
(186, 'CREATE TABLE', FALSE),
(186, 'ALTER TABLE', FALSE);

-- Insert values into answers table for 'Which SQL command is used to insert new data into a table?' (assuming question_id = 187)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(187, 'SELECT', FALSE),
(187, 'UPDATE', FALSE),
(187, 'DELETE FROM', FALSE),
(187, 'INSERT INTO', TRUE),
(187, 'CREATE INDEX', FALSE),
(187, 'DROP TABLE', FALSE);

-- Insert values into answers table for 'Which SQL command is used to modify existing data in a table?' (assuming question_id = 188)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(188, 'SELECT', FALSE),
(188, 'INSERT INTO', FALSE),
(188, 'DELETE FROM', FALSE),
(188, 'UPDATE', TRUE),
(188, 'CREATE VIEW', FALSE),
(188, 'TRUNCATE TABLE', FALSE);

-- Insert values into answers table for 'Which SQL command is used to remove rows from a table?' (assuming question_id = 189)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(189, 'SELECT', FALSE),
(189, 'INSERT INTO', FALSE),
(189, 'UPDATE', FALSE),
(189, 'DELETE FROM', TRUE),
(189, 'CREATE DATABASE', FALSE),
(189, 'ALTER DATABASE', FALSE);

-- Insert values into answers table for 'What is the purpose of the WHERE clause in a SQL SELECT statement?' (assuming question_id = 190)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(190, 'To specify the columns to retrieve', FALSE),
(190, 'To sort the result set', FALSE),
(190, 'To group rows with the same values', FALSE),
(190, 'To filter records based on specified conditions', TRUE),
(190, 'To join data from multiple tables', FALSE),
(190, 'To limit the number of rows returned', FALSE);

-- Insert values into answers table for 'What is the purpose of the ORDER BY clause in a SQL SELECT statement?' (assuming question_id = 191)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(191, 'To select specific columns', FALSE),
(191, 'To filter rows based on conditions', FALSE),
(191, 'To group rows with similar values', FALSE),
(191, 'To sort the result set based on specified columns', TRUE),
(191, 'To combine rows from different tables', FALSE),
(191, 'To insert new rows into the table', FALSE);

-- Insert values into answers table for 'What is the goal of good database design?' (assuming question_id starts at 192)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(192, 'To maximize the number of tables', FALSE),
(192, 'To store all data in a single table', FALSE),
(192, 'To organize data efficiently, reduce redundancy, ensure integrity, and ease management', TRUE),
(192, 'To make querying data as complex as possible', FALSE),
(192, 'To prioritize speed over data accuracy', FALSE),
(192, 'To limit the types of data that can be stored', FALSE);

-- Insert values into answers table for 'What is data redundancy and why is it a problem?' (assuming question_id = 193)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(193, 'Storing data in a compressed format to save space; it can lead to data loss', FALSE),
(193, 'The organization of data in a structured way; it can make querying difficult', FALSE),
(193, 'The duplication of data; it can lead to inconsistencies, increased storage, and update difficulties', TRUE),
(193, 'The linking of tables through foreign keys; it can slow down data retrieval', FALSE),
(193, 'The process of ensuring data accuracy; it can increase development time', FALSE),
(193, 'The use of different data types across tables; it can cause conversion errors', FALSE);

-- Insert values into answers table for 'What are database constraints and why are they important?' (assuming question_id = 194)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(194, 'They are limitations on the size of the database; important for managing storage costs', FALSE),
(194, 'They are rules for naming tables and columns; important for database organization', FALSE),
(194, 'They are rules enforced on data columns to limit the type of data; important for maintaining data integrity', TRUE),
(194, 'They are performance optimization techniques; important for query speed', FALSE),
(194, 'They are security measures to restrict access to data; important for preventing unauthorized access', FALSE),
(194, 'They are guidelines for writing SQL queries; important for code readability', FALSE);

-- Insert values into answers table for 'Explain the concept of atomicity in the context of database design.' (assuming question_id = 195)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(195, 'It refers to the smallest unit of data that can be stored in a database', FALSE),
(195, 'It describes the relationships between different entities in a database', FALSE),
(195, 'It is the property that ensures data is consistent across all tables', FALSE),
(195, 'It means a transaction is treated as a single, indivisible unit: all operations succeed or none do', TRUE),
(195, 'It is a measure of how quickly data can be accessed from the database', FALSE),
(195, 'It defines the level of detail included in the database schema', FALSE);

-- Insert values into answers table for 'Explain the concept of referential integrity in the context of database design.' (assuming question_id = 196)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(196, 'It ensures that all data in a column is of the same data type', FALSE),
(196, 'It describes the physical storage of data on disk', FALSE),
(196, 'It is a measure of how well the database is normalized', FALSE),
(196, 'It ensures that all references between tables are valid, typically through foreign keys', TRUE),
(196, 'It refers to the ability of the database to handle concurrent transactions', FALSE),
(196, 'It defines the rules for backing up and restoring the database', FALSE);

-- Insert values into answers table for 'What are some common database design models?' (assuming question_id = 197)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(197, 'Waterfall model, Agile model, Spiral model', FALSE),
(197, 'Centralized model, Distributed model, Client-server model', FALSE),
(197, 'Flat model, Hierarchical model, Network model', FALSE),
(197, 'Relational model, Entity-Relationship model, NoSQL models', TRUE),
(197, 'Conceptual model, Logical model, Physical model', FALSE),
(197, 'Object-oriented model, Semantic model, Deductive model', FALSE);

-- Insert values into answers table for 'What is the root element of every HTML page?' (assuming question_id starts at 198)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(198, '<head>', FALSE),
(198, '<body>', FALSE),
(198, '<title>', FALSE),
(198, '<html>', TRUE),
(198, '<!DOCTYPE html>', FALSE),
(198, '<meta>', FALSE);

-- Insert values into answers table for 'Which HTML tag is used to define the main content of a page?' (assuming question_id = 199)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(199, '<head>', FALSE),
(199, '<title>', FALSE),
(199, '<html>', FALSE),
(199, '<body>', TRUE),
(199, '<nav>', FALSE),
(199, '<article>', FALSE);

-- Insert values into answers table for 'Which HTML tag is used to define a heading?' (assuming question_id = 200)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(200, '<p>', FALSE),
(200, '<span>', FALSE),
(200, '<div>', FALSE),
(200, '<h1> to <h6>', TRUE),
(200, '<a>', FALSE),
(200, '<li>', FALSE);

-- Insert values into answers table for 'Which HTML tag is used to create a hyperlink?' (assuming question_id = 201)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(201, '<p>', FALSE),
(201, '<h1>', FALSE),
(201, '<img>', FALSE),
(201, '<a>', TRUE),
(201, '<ul>', FALSE),
(201, '<form>', FALSE);

-- Insert values into answers table for 'What is the purpose of the `<head>` section in an HTML document?' (assuming question_id = 202)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(202, 'To display the main content of the page', FALSE),
(202, 'To define the structure of the visible content', FALSE),
(202, 'To contain meta-information about the HTML document', TRUE),
(202, 'To create interactive elements like buttons and forms', FALSE),
(202, 'To define the layout and styling of the page', FALSE),
(202, 'To embed multimedia content like videos and audio', FALSE);

-- Insert values into answers table for 'What is the difference between block-level and inline elements in HTML?' (assuming question_id = 203)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(203, 'Block-level elements are only for text, inline are for images', FALSE),
(203, 'Inline elements create boxes, block-level elements do not', FALSE),
(203, 'Block-level take full width and start new lines; inline take necessary width and do not start new lines', TRUE),
(203, 'Inline elements are styled with CSS, block-level are not', FALSE),
(203, 'Block-level elements are deprecated in HTML5', FALSE),
(203, 'There is no significant difference between them', FALSE);

-- Insert values into answers table for 'What does CSS stand for?' (assuming question_id starts at 204)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(204, 'Creative Style Sheets', FALSE),
(204, 'Computer Style Syntax', FALSE),
(204, 'Cascading Style Sheets', TRUE),
(204, 'Colorful Styling System', FALSE),
(204, 'Content Styling Standard', FALSE),
(204, 'Central Style Server', FALSE);

-- Insert values into answers table for 'What is the purpose of CSS?' (assuming question_id = 205)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(205, 'To define the structure of HTML documents', FALSE),
(205, 'To add interactivity to web pages', FALSE),
(205, 'To manage server-side operations', FALSE),
(205, 'To control the visual presentation and layout of HTML elements', TRUE),
(205, 'To handle database interactions', FALSE),
(205, 'To create animations and complex graphics', FALSE);

-- Insert values into answers table for 'How can you include CSS in an HTML document?' (assuming question_id = 206)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(206, 'Only in a separate .css file', FALSE),
(206, 'Only within the `<head>` tag', FALSE),
(206, 'Only using inline styles', FALSE),
(206, 'Inline (style attribute), internal (`<style>` tag), or external (`<link>` tag)', TRUE),
(206, 'Only by importing CSS from a JavaScript file', FALSE),
(206, 'Only through browser settings', FALSE);

-- Insert values into answers table for 'What is a CSS selector?' (assuming question_id = 207)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(207, 'A rule that defines how elements should be styled', FALSE),
(207, 'A property that controls the appearance of an element', FALSE),
(207, 'A value assigned to a CSS property', FALSE),
(207, 'A pattern used to select the HTML elements you want to style', TRUE),
(207, 'A function that dynamically changes styles', FALSE),
(207, 'A unit of measurement in CSS', FALSE);

-- Insert values into answers table for 'What is the CSS box model?' (assuming question_id = 208)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(208, 'A model for creating 3D effects in CSS', FALSE),
(208, 'A system for organizing CSS rules', FALSE),
(208, 'A description of how elements are positioned on a page', FALSE),
(208, 'A model describing the content, padding, border, and margin of HTML elements', TRUE),
(208, 'A way to define responsive layouts', FALSE),
(208, 'A tool for debugging CSS styles', FALSE);

-- Insert values into answers table for 'What is the difference between `id` and `class` selectors in CSS?' (assuming question_id = 209)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(209, '`id` is for multiple elements, `class` is for a single element', FALSE),
(209, '`id` has lower specificity than `class`', FALSE),
(209, '`id` is prefixed with `.`, `class` is prefixed with `#`', FALSE),
(209, '`id` is for a single unique element, `class` can style multiple elements', TRUE),
(209, 'There is no functional difference between them', FALSE),
(209, '`class` selectors override `id` selectors', FALSE);

-- Insert values into answers table for 'What is JavaScript primarily used for in web development?' (assuming question_id starts at 210)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(210, 'Styling web pages', FALSE),
(210, 'Defining the structure of web pages', FALSE),
(210, 'Managing server-side databases', FALSE),
(210, 'Adding interactivity and dynamic behavior to web pages', TRUE),
(210, 'Handling network requests', FALSE),
(210, 'Optimizing website performance', FALSE);

-- Insert values into answers table for 'Which keyword is used to declare a variable in JavaScript?' (assuming question_id = 211)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(211, 'function', FALSE),
(211, 'if', FALSE),
(211, 'class', FALSE),
(211, 'var, let, or const', TRUE),
(211, 'element', FALSE),
(211, 'style', FALSE);

-- Insert values into answers table for 'What is a function in JavaScript?' (assuming question_id = 212)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(212, 'A type of HTML element', FALSE),
(212, 'A way to define CSS styles', FALSE),
(212, 'A value assigned to a variable', FALSE),
(212, 'A block of code designed to perform a specific task', TRUE),
(212, 'An event that occurs on a web page', FALSE),
(212, 'A method for accessing HTML elements', FALSE);

-- Insert values into answers table for 'What is an event listener in JavaScript?' (assuming question_id = 213)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(213, 'A CSS rule that applies styles on user interaction', FALSE),
(213, 'An HTML attribute that triggers an action', FALSE),
(213, 'A JavaScript function that defines the structure of an HTML element', FALSE),
(213, 'A procedure that waits for an event on an HTML element and executes a function', TRUE),
(213, 'A way to store data in JavaScript', FALSE),
(213, 'A method for creating animations in JavaScript', FALSE);

-- Insert values into answers table for 'What are the basic data types in JavaScript?' (assuming question_id = 214)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(214, 'integer, float, character, boolean', FALSE),
(214, 'element, attribute, node, text', FALSE),
(214, 'color, font, size, layout', FALSE),
(214, 'string, number, boolean, null, undefined, symbol', TRUE),
(214, 'array, object, list, tuple', FALSE),
(214, 'function, event, promise, callback', FALSE);

-- Insert values into answers table for 'What is the Document Object Model (DOM)?' (assuming question_id = 215)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(215, 'A language for styling web pages', FALSE),
(215, 'A way to structure HTML documents', FALSE),
(215, 'A database for storing web content', FALSE),
(215, 'A programming interface for web documents, representing page structure as a tree of objects', TRUE),
(215, 'A set of rules for web communication', FALSE),
(215, 'A tool for creating web animations', FALSE);

-- Insert values into answers table for 'What is the theory of plate tectonics?' (assuming question_id starts at 216)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(216, 'The theory that mountains are formed by vertical uplift of the Earths crust.', FALSE),
(216, 'The belief that the continents have always been in their current positions.', FALSE),
(216, 'The idea that Earths climate is controlled by the movement of large air masses.', FALSE),
(216, 'Earths outer shell is divided into plates that glide over the mantle.', TRUE),
(216, 'The concept that volcanic activity is random and unpredictable.', FALSE),
(216, 'The study of how rocks change over time due to heat and pressure.', FALSE);

-- Insert values into answers table for 'What are the three main types of plate boundaries?' (assuming question_id = 217)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(217, 'Folding, faulting, and volcanism', FALSE),
(217, 'Erosion, deposition, and weathering', FALSE),
(217, 'Hotspots, rifts, and trenches', FALSE),
(217, 'Convergent, divergent, and transform', TRUE),
(217, 'Oceanic, continental, and mantle', FALSE),
(217, 'Primary, secondary, and tertiary', FALSE);

-- Insert values into answers table for 'What geological features are commonly associated with convergent plate boundaries?' (assuming question_id = 218)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(218, 'Mid-ocean ridges and rift valleys', FALSE),
(218, 'Shield volcanoes and lava plateaus', FALSE),
(218, 'Earthquakes and strike-slip faults', FALSE),
(218, 'Mountains, volcanoes, and ocean trenches', TRUE),
(218, 'Continental shelves and abyssal plains', FALSE),
(218, 'Cinder cones and calderas', FALSE);

-- Insert values into answers table for 'What geological features are commonly associated with divergent plate boundaries?' (assuming question_id = 219)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(219, 'Fold mountains and island arcs', FALSE),
(219, 'Ocean trenches and subduction zones', FALSE),
(219, 'Earthquakes along fault lines', FALSE),
(219, 'Mid-ocean ridges, rift valleys, and volcanic activity', TRUE),
(219, 'Composite volcanoes and volcanic domes', FALSE),
(219, 'Horsts and grabens', FALSE);

-- Insert values into answers table for 'What geological events are common at transform plate boundaries?' (assuming question_id = 220)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(220, 'Formation of new crust', FALSE),
(220, 'Destruction of old crust', FALSE),
(220, 'Formation of large mountain ranges', FALSE),
(220, 'Earthquakes as the plates grind past each other', TRUE),
(220, 'Widespread volcanic eruptions', FALSE),
(220, 'The creation of deep ocean trenches', FALSE);

-- Insert values into answers table for 'What is subduction?' (assuming question_id = 221)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(221, 'The process of two continental plates colliding and forming mountains.', FALSE),
(221, 'The upwelling of magma at a divergent plate boundary.', FALSE),
(221, 'The sliding of two plates past each other at a transform boundary.', FALSE),
(221, 'One tectonic plate moving under another and sinking into the mantle.', TRUE),
(221, 'The fracturing of the Earths crust due to stress.', FALSE),
(221, 'The gradual wearing away of the Earths surface by wind and water.', FALSE);

-- Insert values into answers table for 'What is the difference between climate and weather?' (assuming question_id starts at 222)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(222, 'Climate is measured in Celsius, weather in Fahrenheit.', FALSE),
(222, 'Weather is the study of the atmosphere, climate is the study of oceans.', FALSE),
(222, 'Weather is long-term, climate is short-term.', FALSE),
(222, 'Weather is short-term atmospheric conditions, climate is long-term average patterns.', TRUE),
(222, 'Climate includes only temperature, weather includes precipitation.', FALSE),
(222, 'There is no significant difference between them.', FALSE);

-- Insert values into answers table for 'What are the main factors that influence climate?' (assuming question_id = 223)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(223, 'Soil type, rock composition, and mineral content.', FALSE),
(223, 'Animal migration patterns and vegetation density.', FALSE),
(223, 'Latitude, altitude, proximity to water, ocean currents, and prevailing winds.', TRUE),
(223, 'The phases of the moon and the position of the stars.', FALSE),
(223, 'Human population density and industrial output.', FALSE),
(223, 'The Earths magnetic field and gravitational pull.', FALSE);

-- Insert values into answers table for 'What causes wind?' (assuming question_id = 224)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(224, 'The rotation of the Earth.', FALSE),
(224, 'Ocean tides.', FALSE),
(224, 'Differences in air pressure due to uneven heating.', TRUE),
(224, 'The gravitational pull of the moon.', FALSE),
(224, 'Volcanic eruptions releasing gases.', FALSE),
(224, 'The movement of tectonic plates.', FALSE);

-- Insert values into answers table for 'What is the greenhouse effect?' (assuming question_id = 225)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(225, 'The cooling of the Earths atmosphere due to dust particles.', FALSE),
(225, 'The process by which clouds reflect sunlight back into space.', FALSE),
(225, 'The warming of the Earths surface due to geothermal energy.', FALSE),
(225, 'The trapping of outgoing infrared radiation by atmospheric gases, warming the planet.', TRUE),
(225, 'The absorption of ultraviolet radiation by the ozone layer.', FALSE),
(225, 'The transfer of heat through air movement.', FALSE);

-- Insert values into answers table for 'What are the different types of precipitation?' (assuming question_id = 226)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(226, 'Fog, mist, dew, frost.', FALSE),
(226, 'Clouds, smog, haze, steam.', FALSE),
(226, 'Thunder, lightning, tornadoes, hurricanes.', FALSE),
(226, 'Rain, snow, sleet, and hail.', TRUE),
(226, 'Wind, humidity, pressure, temperature.', FALSE),
(226, 'Cirrus, cumulus, stratus, nimbus.', FALSE);

-- Insert values into answers table for 'What is a front in meteorology?' (assuming question_id = 227)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(227, 'A measure of atmospheric pressure.', FALSE),
(227, 'The leading edge of a warm air mass.', FALSE),
(227, 'A boundary separating air masses with different densities.', TRUE),
(227, 'A type of cloud formation.', FALSE),
(227, 'A period of prolonged dry weather.', FALSE),
(227, 'The center of a high-pressure system.', FALSE);

-- Insert values into answers table for 'What is a mountain?' (assuming question_id starts at 228)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(228, 'A small hill', FALSE),
(228, 'A flat area of land', FALSE),
(228, 'A body of saltwater', FALSE),
(228, 'A large natural elevation rising abruptly', TRUE),
(228, 'A deep depression in the Earths surface', FALSE),
(228, 'A collection of sand dunes', FALSE);

-- Insert values into answers table for 'What is a valley?' (assuming question_id = 229)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(229, 'The peak of a mountain', FALSE),
(229, 'A flat, treeless area', FALSE),
(229, 'A large body of standing water', FALSE),
(229, 'A low area between hills or mountains, often with a river', TRUE),
(229, 'A steep cliff face', FALSE),
(229, 'An opening in the Earths crust where lava erupts', FALSE);

-- Insert values into answers table for 'What is a plain?' (assuming question_id = 230)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(230, 'A high, flat area of land', FALSE),
(230, 'A steep-sided hill', FALSE),
(230, 'A narrow body of water connecting two larger ones', FALSE),
(230, 'A large area of flat or gently rolling land with few trees', TRUE),
(230, 'A deep ocean trench', FALSE),
(230, 'A volcanic mountain', FALSE);

-- Insert values into answers table for 'How are river deltas formed?' (assuming question_id = 231)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(231, 'By the collision of tectonic plates', FALSE),
(231, 'By the erosion of coastal cliffs', FALSE),
(231, 'By the accumulation of sand dunes at a river mouth', FALSE),
(231, 'By the deposition of sediment as a river enters a body of water', TRUE),
(231, 'By volcanic activity near the coast', FALSE),
(231, 'By the melting of glaciers entering the sea', FALSE);

-- Insert values into answers table for 'What is erosion?' (assuming question_id = 232)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(232, 'The process of rocks solidifying from molten lava', FALSE),
(232, 'The breakdown of rocks into smaller pieces by chemical reactions', FALSE),
(232, 'The movement of tectonic plates', FALSE),
(232, 'The wearing away and transport of soil and rock by natural forces', TRUE),
(232, 'The deposition of sediment to form new landforms', FALSE),
(232, 'The growth of plants on the Earths surface', FALSE);

-- Insert values into answers table for 'What is the difference between a plateau and a mesa?' (assuming question_id = 233)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(233, 'A plateau is formed by volcanic activity, a mesa by folding', FALSE),
(233, 'A mesa is always higher than a plateau', FALSE),
(233, 'A plateau is flat elevated land, a mesa is a smaller flat-topped hill', TRUE),
(233, 'A plateau has steep sides, a mesa has gently sloping sides', FALSE),
(233, 'A mesa is found near the coast, a plateau inland', FALSE),
(233, 'There is no significant difference between them', FALSE);

-- Insert values into answers table for 'What is population density?' (assuming question_id starts at 234)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(234, 'The total number of people in a region', FALSE),
(234, 'The rate at which a population grows', FALSE),
(234, 'The average age of the population', FALSE),
(234, 'The number of individuals living in a specific area', TRUE),
(234, 'The distribution of people across a region', FALSE),
(234, 'The number of males compared to females in a population', FALSE);

-- Insert values into answers table for 'What is birth rate?' (assuming question_id = 235)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(235, 'The total number of births in a year', FALSE),
(235, 'The number of deaths per 1,000 people per year', FALSE),
(235, 'The number of live births per 1,000 people per year', TRUE),
(235, 'The percentage increase in population per year', FALSE),
(235, 'The average number of children a woman will have', FALSE),
(235, 'The number of births minus the number of deaths', FALSE);

-- Insert values into answers table for 'What is migration?' (assuming question_id = 236)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(236, 'The seasonal movement of animals', FALSE),
(236, 'The growth of cities', FALSE),
(236, 'The movement of people with the intent of settling', TRUE),
(236, 'The spread of ideas and culture', FALSE),
(236, 'Changes in population due to births and deaths', FALSE),
(236, 'The movement of goods and services', FALSE);

-- Insert values into answers table for 'What are push factors in migration?' (assuming question_id = 237)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(237, 'Positive aspects of a new location', FALSE),
(237, 'Economic opportunities in a new area', FALSE),
(237, 'Political stability in a new country', FALSE),
(237, 'Negative aspects of a current location that encourage leaving', TRUE),
(237, 'Cultural attractions of a new city', FALSE),
(237, 'Better educational opportunities elsewhere', FALSE);

-- Insert values into answers table for 'What are pull factors in migration?' (assuming question_id = 238)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(238, 'Negative aspects of a persons current home', FALSE),
(238, 'Reasons why people are forced to leave an area', FALSE),
(238, 'Environmental disasters in the current location', FALSE),
(238, 'Positive aspects of a new location that attract people', TRUE),
(238, 'Lack of job opportunities in the current area', FALSE),
(238, 'Political unrest in the current country', FALSE);

-- Insert values into answers table for 'What is the demographic transition model?' (assuming question_id = 239)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(239, 'A model showing the movement of people from rural to urban areas', FALSE),
(239, 'A model predicting future population growth based on current trends', FALSE),
(239, 'A model describing changes in birth and death rates as countries industrialize', TRUE),
(239, 'A model illustrating the impact of migration on population size', FALSE),
(239, 'A model explaining the distribution of different age groups in a population', FALSE),
(239, 'A model detailing the effects of disease on population numbers', FALSE);

-- Insert values into answers table for 'What is culture?' (assuming question_id starts at 240)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(240, 'The genetic traits of a population', FALSE),
(240, 'The natural landscape of a region', FALSE),
(240, 'The political system of a country', FALSE),
(240, 'The shared beliefs, values, practices, behaviors, and technologies of a group', TRUE),
(240, 'The economic activities of a society', FALSE),
(240, 'The artistic expressions of individuals', FALSE);

-- Insert values into answers table for 'What is a cultural region?' (assuming question_id = 241)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(241, 'A political division with defined borders', FALSE),
(241, 'An area with a uniform climate', FALSE),
(241, 'An area where people share common cultural characteristics', TRUE),
(241, 'An economic zone with similar industries', FALSE),
(241, 'A geographical area with a specific ecosystem', FALSE),
(241, 'A linguistic area where everyone speaks the same language', FALSE);

-- Insert values into answers table for 'What is cultural diffusion?' (assuming question_id = 242)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(242, 'The process of cultural groups becoming isolated', FALSE),
(242, 'The decline of traditional cultural practices', FALSE),
(242, 'The spread of cultural traits from one group or place to another', TRUE),
(242, 'The preservation of cultural heritage', FALSE),
(242, 'The forced adoption of a new culture', FALSE),
(242, 'The blending of different cultures into a new one', FALSE);

-- Insert values into answers table for 'What is cultural assimilation?' (assuming question_id = 243)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(243, 'The coexistence of multiple cultures in one society', FALSE),
(243, 'The resistance to adopting new cultural norms', FALSE),
(243, 'The process by which a minority culture influences the dominant culture', FALSE),
(243, 'The adoption of the cultural norms of a dominant group by individuals or groups', TRUE),
(243, 'The celebration of cultural diversity', FALSE),
(243, 'The separation of different cultural groups within a society', FALSE);

-- Insert values into answers table for 'What is cultural relativism?' (assuming question_id = 244)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(244, 'The belief that ones own culture is superior to others', FALSE),
(244, 'The judgment of other cultures based on ones own cultural standards', FALSE),
(244, 'The principle that all cultures are equally valid', FALSE),
(244, 'Understanding a persons beliefs and activities in terms of their own culture', TRUE),
(244, 'The attempt to impose ones cultural values on others', FALSE),
(244, 'The study of the origins of different cultures', FALSE);

-- Insert values into answers table for 'What is the concept of a cultural landscape?' (assuming question_id = 245)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(245, 'A natural environment untouched by human activity', FALSE),
(245, 'A landscape defined solely by its physical features', FALSE),
(245, 'The artistic representation of a culture', FALSE),
(245, 'The visible imprint of human activity and culture on the environment', TRUE),
(245, 'A region characterized by a specific type of agriculture', FALSE),
(245, 'The study of how climate affects cultural development', FALSE);

-- Insert values into answers table for 'What is urbanization?' (assuming question_id starts at 246)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(246, 'The growth of rural populations', FALSE),
(246, 'The decline of agricultural industries', FALSE),
(246, 'The process of suburban development', FALSE),
(246, 'An increasing proportion of a countrys population living in urban areas', TRUE),
(246, 'The migration of people from cities to rural areas', FALSE),
(246, 'The development of transportation networks', FALSE);

-- Insert values into answers table for 'What is a city?' (assuming question_id = 247)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(247, 'A small, sparsely populated area', FALSE),
(247, 'A rural settlement focused on agriculture', FALSE),
(247, 'A large and densely populated urban area', TRUE),
(247, 'A political division with a small population', FALSE),
(247, 'A region characterized by its natural environment', FALSE),
(247, 'A temporary settlement for seasonal workers', FALSE);

-- Insert values into answers table for 'What is urban sprawl?' (assuming question_id = 248)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(248, 'The concentration of population in city centers', FALSE),
(248, 'The development of high-rise buildings in urban areas', FALSE),
(248, 'The growth of public transportation within cities', FALSE),
(248, 'The expansion of low-density urban development outward from a city center', TRUE),
(248, 'The revitalization of inner-city neighborhoods', FALSE),
(248, 'The creation of green spaces within urban areas', FALSE);

-- Insert values into answers table for 'What is the central business district (CBD) of a city?' (assuming question_id = 249)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(249, 'The residential area surrounding a city', FALSE),
(249, 'The industrial outskirts of a city', FALSE),
(249, 'The historical center of a city', FALSE),
(249, 'The commercial and often geographic heart of a city', TRUE),
(249, 'A large park located in the center of a city', FALSE),
(249, 'The main transportation hub of a city', FALSE);

-- Insert values into answers table for 'What are the different models of urban structure?' (assuming question_id = 250)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(250, 'Linear model, radial model, grid model', FALSE),
(250, 'Agricultural model, industrial model, service model', FALSE),
(250, 'Core-periphery model, world-systems model, gravity model', FALSE),
(250, 'Concentric zone model, sector model, and multiple nuclei model', TRUE),
(250, 'Push-pull model, demographic transition model, migration model', FALSE),
(250, 'Federal model, unitary model, confederal model', FALSE);

-- Insert values into answers table for 'What are some of the challenges associated with rapid urbanization?' (assuming question_id = 251)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(251, 'Decreased crime rates and improved public health', FALSE),
(251, 'Increased availability of affordable housing', FALSE),
(251, 'Reduced strain on infrastructure and resources', FALSE),
(251, 'Housing shortages, inadequate infrastructure, environmental degradation, and social inequalities', TRUE),
(251, 'Greater social cohesion and reduced economic disparities', FALSE),
(251, 'Improved air and water quality', FALSE);

-- Insert values into answers table for 'What is the primary challenge of map projections?' (assuming question_id starts at 252)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(252, 'Choosing the right colors for the map', FALSE),
(252, 'Fitting all the necessary information onto the map', FALSE),
(252, 'Representing the curved Earth on a flat map without distortion', TRUE),
(252, 'Deciding on the map orientation (north up)', FALSE),
(252, 'Creating a clear and legible legend', FALSE),
(252, 'Determining the appropriate map scale', FALSE);

-- Insert values into answers table for 'What is a cylindrical map projection?' (assuming question_id = 253)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(253, 'Earths surface onto a flat plane, directions from the center are accurate', FALSE),
(253, 'Earths surface onto a cone, meridians radiate, parallels are arcs', FALSE),
(253, 'Earths surface onto a cylinder, meridians are vertical, parallels are horizontal', TRUE),
(253, 'A projection that preserves the true area of continents', FALSE),
(253, 'A projection that accurately shows distances from the center', FALSE),
(253, 'A projection used primarily for polar regions', FALSE);

-- Insert values into answers table for 'What is a conical map projection?' (assuming question_id = 254)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(254, 'Earths surface onto a flat plane, preserving directions', FALSE),
(254, 'Earths surface onto a cylinder, preserving angles', FALSE),
(254, 'Earths surface onto a cone, meridians radiate, parallels are arcs', TRUE),
(254, 'A projection that maintains the correct shape of landmasses', FALSE),
(254, 'A projection where all distances are proportional to ground distances', FALSE),
(254, 'A projection often used for equatorial regions', FALSE);

-- Insert values into answers table for 'What is a planar (azimuthal) map projection?' (assuming question_id = 255)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(255, 'Earths surface projected onto a cylinder, good for navigation', FALSE),
(255, 'Earths surface projected onto a cone, good for mid-latitudes', FALSE),
(255, 'Earths surface projected onto a flat plane, directions from the center are accurate', TRUE),
(255, 'A projection that shows accurate relative sizes of areas', FALSE),
(255, 'A projection where the scale is constant along all lines', FALSE),
(255, 'A projection primarily used for showing the entire world', FALSE);

-- Insert values into answers table for 'What types of distortion are common in map projections?' (assuming question_id = 256)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(256, 'Color, line weight, symbol size, and font', FALSE),
(256, 'Latitude, longitude, elevation, and population density', FALSE),
(256, 'Temperature, precipitation, wind speed, and humidity', FALSE),
(256, 'Shape (conformal), area (equal-area), distance (equidistant), and direction (azimuthal)', TRUE),
(256, 'Political boundaries, road networks, river systems, and city locations', FALSE),
(256, 'Magnetic declination, true north, grid north, and magnetic north', FALSE);

-- Insert values into answers table for 'What is the Mercator projection known for?' (assuming question_id = 257)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(257, 'Preserving the true area of all landmasses', FALSE),
(257, 'Showing all distances accurately from the center', FALSE),
(257, 'Having minimal distortion across the entire map', FALSE),
(257, 'Preserving angles (conformal) but distorting area at high latitudes', TRUE),
(257, 'Accurately representing the shapes of continents near the equator', FALSE),
(257, 'Being primarily used for thematic maps showing population density', FALSE);

-- Insert values into answers table for 'What is a map scale?' (assuming question_id starts at 258)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(258, 'The ratio of the maps width to its height', FALSE),
(258, 'The colors used to represent different features on the map', FALSE),
(258, 'The symbols used to indicate cities, rivers, and mountains', FALSE),
(258, 'The ratio of a distance on the map to the corresponding distance on the ground', TRUE),
(258, 'The projection used to flatten the Earths surface', FALSE),
(258, 'The level of detail shown on the map', FALSE);

-- Insert values into answers table for 'What does a representative fraction (e.g., 1:100,000) mean?' (assuming question_id = 259)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(259, 'One centimeter on the map represents 100,000 kilometers on the ground', FALSE),
(259, 'The map is 1/100,000th the size of the Earth', FALSE),
(259, 'One inch on the map represents 100,000 inches on the ground', FALSE),
(259, 'One unit on the map represents 100,000 of the same units on the ground', TRUE),
(259, 'The map shows an area of 100,000 square units', FALSE),
(259, 'The map has a precision of 1 part in 100,000', FALSE);

-- Insert values into answers table for 'What is a verbal scale?' (assuming question_id = 260)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(260, 'A numerical ratio showing map distance to ground distance', FALSE),
(260, 'A line or bar representing ground distance', FALSE),
(260, 'A description of the map projection used', FALSE),
(260, 'A description of the relationship between map and ground distance in words', TRUE),
(260, 'A list of symbols and their meanings', FALSE),
(260, 'A statement about the maps accuracy', FALSE);

-- Insert values into answers table for 'What is a graphic scale (bar scale)?' (assuming question_id = 261)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(261, 'A ratio expressed as a fraction (e.g., 1/50,000)', FALSE),
(261, 'A written statement of the scale (e.g., "1 inch equals 1 mile")', FALSE),
(261, 'A line or bar drawn on the map representing ground distance', TRUE),
(261, 'A description of the maps intended audience', FALSE),
(261, 'A measure of the maps level of generalization', FALSE),
(261, 'A grid system used for locating points on the map', FALSE);

-- Insert values into answers table for 'If a map has a scale of 1:50,000, and two points are 3 cm apart on the map, what is the actual distance between them on the ground?' (assuming question_id = 262)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(262, '15 km', FALSE),
(262, '150 m', FALSE),
(262, '1.5 km', TRUE),
(262, '15 m', FALSE),
(262, '0.15 km', FALSE),
(262, '150,000 km', FALSE);

-- Insert values into answers table for 'Why is it important to understand map scale?' (assuming question_id = 263)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(263, 'To determine the maps aesthetic appeal', FALSE),
(263, 'To identify the maps publisher and date', FALSE),
(263, 'To understand the maps color scheme', FALSE),
(263, 'For accurately measuring distances, calculating areas, and interpreting the level of detail', TRUE),
(263, 'To know the maps orientation relative to true north', FALSE),
(263, 'To decipher the meaning of the symbols used on the map', FALSE);

-- Insert values into answers table for 'What is the primary purpose of a thematic map?' (assuming question_id starts at 264)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(264, 'To show the locations of cities, rivers, and mountains', FALSE),
(264, 'To provide a general reference of geographic features', FALSE),
(264, 'To illustrate the spatial distribution of specific topics or themes', TRUE),
(264, 'To display the different types of map projections', FALSE),
(264, 'To indicate distances between different locations', FALSE),
(264, 'To represent the political boundaries of countries', FALSE);

-- Insert values into answers table for 'What is a choropleth map?' (assuming question_id = 265)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(265, 'A map using dots to represent the frequency of a phenomenon', FALSE),
(265, 'A map with symbols whose size varies with the mapped variable', FALSE),
(265, 'A map using lines to connect points of equal value', FALSE),
(265, 'A map using shades or colors within predefined areas to represent data magnitude', TRUE),
(265, 'A map showing the movement of people or goods with arrows', FALSE),
(265, 'A map with contour lines indicating elevation', FALSE);

-- Insert values into answers table for 'What is a dot density map?' (assuming question_id = 266)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(266, 'A map where color intensity indicates data values', FALSE),
(266, 'A map using proportional circles to show quantities', FALSE),
(266, 'A map with lines connecting areas of equal value', FALSE),
(266, 'A map using dots to represent the occurrence of a phenomenon', TRUE),
(266, 'A map showing flows or movements between locations', FALSE),
(266, 'A map where symbol size is inversely proportional to the data', FALSE);

-- Insert values into answers table for 'What is a proportional symbol map?' (assuming question_id = 267)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(267, 'A map where the density of shading represents data values', FALSE),
(267, 'A map using equally sized dots to show distribution', FALSE),
(267, 'A map with lines linking places with similar characteristics', FALSE),
(267, 'A map using symbols whose size varies with the magnitude of the mapped variable', TRUE),
(267, 'A map showing changes in data over time with different colors', FALSE),
(267, 'A map where symbol color indicates different categories', FALSE);

-- Insert values into answers table for 'What is an isoline map?' (assuming question_id = 268)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(268, 'A map using different patterns within areas to show data', FALSE),
(268, 'A map with dots representing specific counts of a feature', FALSE),
(268, 'A map where symbol size is fixed but color varies with data', FALSE),
(268, 'A map using lines to connect points of equal value', TRUE),
(268, 'A map showing directional movement with vectors', FALSE),
(268, 'A map where the background color represents a general category', FALSE);

-- Insert values into answers table for 'What are some examples of topics that can be effectively displayed on thematic maps?' (assuming question_id = 269)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(269, 'Locations of capital cities and major rivers', FALSE),
(269, 'Distances between major urban centers', FALSE),
(269, 'The different types of map projections used worldwide', FALSE),
(269, 'Population density, income levels, disease prevalence, voting patterns, and climate data', TRUE),
(269, 'The scale used on different types of maps', FALSE),
(269, 'The geological composition of different regions', FALSE);



-- General Knowledge easy questions (no submodule_id)
INSERT INTO questions (question_text, difficulty, explanation, hint) VALUES
('What is the capital city of Australia?', 'easy', 'Canberra is the capital, located in the Australian Capital Territory.', 'Think about the planned city that is the seat of government.'),
('Who painted the Mona Lisa?', 'easy', 'Leonardo da Vinci painted the Mona Lisa.', 'Consider a famous Renaissance artist.'),
('What is the chemical symbol for water?', 'easy', 'The chemical symbol for water is H₂O.', 'Think about the elements that make up water.'),
('What is the highest mountain in the world?', 'easy', 'Mount Everest is the highest mountain above sea level.', 'Consider the peak in the Himalayas.'),
('What year did World War II end?', 'easy', 'World War II officially ended in 1945.', 'Think about the mid-20th century global conflict.'),
('What is the currency of Japan?', 'easy', 'The currency of Japan is the Yen.', 'Consider the monetary unit used in Japan.');

-- Answers for 'What is the capital city of Australia?' (assuming question_id starts at 270)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(270, 'Sydney', FALSE),
(270, 'Melbourne', FALSE),
(270, 'Brisbane', FALSE),
(270, 'Canberra', TRUE),
(270, 'Perth', FALSE),
(270, 'Adelaide', FALSE);

-- Answers for 'Who painted the Mona Lisa?' (assuming question_id = 271)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(271, 'Vincent van Gogh', FALSE),
(271, 'Pablo Picasso', FALSE),
(271, 'Claude Monet', FALSE),
(271, 'Leonardo da Vinci', TRUE),
(271, 'Michelangelo', FALSE),
(271, 'Raphael', FALSE);

-- Answers for 'What is the chemical symbol for water?' (assuming question_id = 272)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(272, 'CO2', FALSE),
(272, 'O2', FALSE),
(272, 'N2', FALSE),
(272, 'H₂O', TRUE),
(272, 'NaCl', FALSE),
(272, 'CH4', FALSE);

-- Answers for 'What is the highest mountain in the world?' (assuming question_id = 273)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(273, 'K2', FALSE),
(273, 'Kangchenjunga', FALSE),
(273, 'Lhotse', FALSE),
(273, 'Mount Everest', TRUE),
(273, 'Makalu', FALSE),
(273, 'Cho Oyu', FALSE);

-- Answers for 'What year did World War II end?' (assuming question_id = 274)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(274, '1939', FALSE),
(274, '1941', FALSE),
(274, '1943', FALSE),
(274, '1945', TRUE),
(274, '1947', FALSE),
(274, '1950', FALSE);

-- Answers for 'What is the currency of Japan?' (assuming question_id = 275)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(275, 'Won', FALSE),
(275, 'Yuan', FALSE),
(275, 'Ringgit', FALSE),
(275, 'Yen', TRUE),
(275, 'Baht', FALSE),
(275, 'Rupee', FALSE);

-- General Knowledge medium questions (no submodule_id)
INSERT INTO questions (question_text, difficulty, explanation, hint) VALUES
('What is the largest planet in our solar system?', 'medium', 'Jupiter is the largest planet, known for its Great Red Spot.', 'Think about the gas giant with a famous storm.'),
('Who wrote the play "Hamlet"?', 'medium', 'William Shakespeare wrote the play "Hamlet".', 'Consider a renowned English playwright.'),
('What is the chemical formula for glucose?', 'medium', 'The chemical formula for glucose is C₆H₁₂O₆.', 'Think about a simple sugar crucial for energy.'),
('What is the deepest ocean trench in the world?', 'medium', 'The Mariana Trench is the deepest ocean trench.', 'Consider the trench located in the western Pacific Ocean.'),
('In what year did the Titanic sink?', 'medium', 'The Titanic sank in 1912.', 'Think about the early 20th century maritime disaster.'),
('What is the main component of Earths atmosphere?', 'medium', 'Nitrogen is the main component of Earths atmosphere.', 'Consider the gas that makes up the majority of the air we breathe.'),
('What is the speed of light in a vacuum?', 'medium', 'The speed of light in a vacuum is approximately 299,792,458 meters per second.', 'Think about the universal speed limit.'),
('Who developed the theory of relativity?', 'medium', 'Albert Einstein developed the theory of relativity.', 'Consider a famous physicist known for E=mc².'),
('What is the largest desert in the world?', 'medium', 'The Antarctic Desert is the largest desert in the world.', 'Think about a cold, dry expanse.'),
('What is the chemical symbol for gold?', 'medium', 'The chemical symbol for gold is Au.', 'Consider the Latin word for gold, "aurum".');


-- Answers for 'What is the largest planet in our solar system?' (assuming question_id starts at 276)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(276, 'Saturn', FALSE),
(276, 'Uranus', FALSE),
(276, 'Neptune', FALSE),
(276, 'Jupiter', TRUE),
(276, 'Mars', FALSE),
(276, 'Earth', FALSE);

-- Answers for 'Who wrote the play "Hamlet"?' (assuming question_id = 277)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(277, 'Christopher Marlowe', FALSE),
(277, 'Ben Jonson', FALSE),
(277, 'George Bernard Shaw', FALSE),
(277, 'William Shakespeare', TRUE),
(277, 'Oscar Wilde', FALSE),
(277, 'Arthur Miller', FALSE);

-- Answers for 'What is the chemical formula for glucose?' (assuming question_id = 278)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(278, 'H₂O', FALSE),
(278, 'NaCl', FALSE),
(278, 'CO₂', FALSE),
(278, 'C₆H₁₂O₆', TRUE),
(278, 'O₂', FALSE),
(278, 'CH₄', FALSE);

-- Answers for 'What is the deepest ocean trench in the world?' (assuming question_id = 279)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(279, 'Puerto Rico Trench', FALSE),
(279, 'Java Trench', FALSE),
(279, 'Aleutian Trench', FALSE),
(279, 'Mariana Trench', TRUE),
(279, 'South Sandwich Trench', FALSE),
(279, 'Kurile-Kamchatka Trench', FALSE);

-- Answers for 'In what year did the Titanic sink?' (assuming question_id = 280)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(280, '1907', FALSE),
(280, '1910', FALSE),
(280, '1911', FALSE),
(280, '1912', TRUE),
(280, '1915', FALSE),
(280, '1920', FALSE);

-- Answers for 'What is the main component of Earth\'s atmosphere?' (assuming question_id = 281)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(281, 'Oxygen', FALSE),
(281, 'Carbon Dioxide', FALSE),
(281, 'Argon', FALSE),
(281, 'Nitrogen', TRUE),
(281, 'Hydrogen', FALSE),
(281, 'Helium', FALSE);

INSERT INTO answers (question_id, answer, right_answer) VALUES
(282, '300,000 km/s', TRUE),  -- Approximate value often used
(282, '150,000 km/s', FALSE),
(282, '500,000 km/s', FALSE),
(282, '299,792,458 m/s', TRUE), -- More precise value
(282, '1,000,000 km/s', FALSE),
(282, '200,000,000 m/s', FALSE);

-- Answers for 'Who developed the theory of relativity?' (assuming question_id = 283)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(283, 'Isaac Newton', FALSE),
(283, 'Galileo Galilei', FALSE),
(283, 'Stephen Hawking', FALSE),
(283, 'Albert Einstein', TRUE),
(283, 'Niels Bohr', FALSE),
(283, 'Max Planck', FALSE);

-- Answers for 'What is the largest desert in the world?' (assuming question_id = 284)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(284, 'Sahara Desert', FALSE),
(284, 'Arabian Desert', FALSE),
(284, 'Gobi Desert', FALSE),
(284, 'Antarctic Desert', TRUE),
(284, 'Australian Desert', FALSE),
(284, 'Kalahari Desert', FALSE);

-- Answers for 'What is the chemical symbol for gold?' (assuming question_id = 285)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(285, 'Gd', FALSE),
(285, 'Gl', FALSE),
(285, 'Go', FALSE),
(285, 'Au', TRUE),
(285, 'Ag', FALSE),
(285, 'Fe', FALSE);

-- General Knowledge hard questions (no submodule_id)
INSERT INTO questions (question_text, difficulty, explanation, hint) VALUES
('What is the name of the international agreement that committed industrialized nations to limiting and reducing greenhouse gas emissions, but which the United States withdrew from in 2020?', 'hard', 'The Paris Agreement is an international treaty on climate change, adopted in 2015.', 'Think about a recent global effort to combat climate change.'),
('What is the philosophical problem of induction, famously articulated by David Hume?', 'hard', 'The problem of induction questions whether inductive reasoning leads to knowledge understood in the classic philosophical sense, highlighting that the future might not resemble the past.', 'Consider the limits of drawing general conclusions from specific observations.'),
('What is the name of the phenomenon where a spinning gyroscope or other rotating object precesses about a vertical axis when subjected to a torque?', 'hard', 'Precession is the change in the orientation of the rotational axis of a rotating body.', 'Think about the slow wobble of a spinning top.'),
('What is the approximate age of the universe according to the Lambda-CDM model?', 'hard', 'The Lambda-CDM model estimates the age of the universe to be approximately 13.8 billion years.', 'Consider the standard model of cosmology.'),
('What is the name of the theorem in mathematical logic that demonstrates that any sufficiently expressive formal system of arithmetic cannot prove all true statements about the natural numbers?', 'hard', 'Gödels incompleteness theorems are two theorems of mathematical logic that establish inherent limitations of all but the most trivial axiomatic systems capable of modeling basic arithmetic.', 'Think about the limits of formal proof in mathematics.'),
('What is the name of the economic concept describing a situation where the marginal benefit of producing one more unit of a good or service is equal to the marginal cost?', 'hard', 'Marginal cost equals marginal revenue is the condition for profit maximization in perfect competition and is related to allocative efficiency.', 'Consider the point of optimal production in economics.'),
('What is the name of the geological epoch that began after the Pleistocene and is characterized by human impact on the environment?', 'hard', 'The Holocene epoch is the current geological epoch.', 'Think about the most recent period in Earths history since the last major ice age.'),
('What is the name of the neurotransmitter that plays a key role in the brains reward system and is often associated with feelings of pleasure and motivation?', 'hard', 'Dopamine is a neurotransmitter that plays several important roles in the brain and body.', 'Consider a chemical messenger linked to reward and pleasure.'),
('What is the name of the literary device where a part of something is used to refer to the whole, or vice versa?', 'hard', 'Synecdoche is a figure of speech in which a part is made to represent the whole or vice versa.', 'Think about using "wheels" to refer to a car.'),
('What is the name of the principle in quantum mechanics that states that certain pairs of physical properties, such as position and momentum, cannot both be known to arbitrarily high precision?', 'hard', 'The Heisenberg uncertainty principle is a fundamental concept in quantum mechanics.', 'Consider the inherent limitations in measuring certain pairs of quantum properties simultaneously.');

-- Answers for 'What is the name of the international agreement that committed industrialized nations to limiting and reducing greenhouse gas emissions, but which the United States withdrew from in 2020?' (assuming question_id starts at 286)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(286, 'Kyoto Protocol', FALSE),
(286, 'Montreal Protocol', FALSE),
(286, 'Copenhagen Accord', FALSE),
(286, 'Paris Agreement', TRUE),
(286, 'Rio Declaration', FALSE),
(286, 'Bonn Challenge', FALSE);

-- Answers for 'What is the philosophical problem of induction, famously articulated by David Hume?' (assuming question_id = 287)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(287, 'The Gettier Problem', FALSE),
(287, 'The Problem of Evil', FALSE),
(287, 'The Sorites Paradox', FALSE),
(287, 'The Problem of Induction', TRUE),
(287, 'The Mind-Body Problem', FALSE),
(287, 'The Ship of Theseus', FALSE);

-- Answers for 'What is the name of the phenomenon where a spinning gyroscope or other rotating object precesses about a vertical axis when subjected to a torque?' (assuming question_id = 288)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(288, 'Nutation', FALSE),
(288, 'Inertia', FALSE),
(288, 'Centrifugation', FALSE),
(288, 'Precession', TRUE),
(288, 'Angular Momentum', FALSE),
(288, 'Torque', FALSE);

-- Answers for 'What is the approximate age of the universe according to the Lambda-CDM model?' (assuming question_id = 289)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(289, '4.5 billion years', FALSE),
(289, '10 billion years', FALSE),
(289, '15 billion years', FALSE),
(289, '13.8 billion years', TRUE),
(289, '20 billion years', FALSE),
(289, '8 billion years', FALSE);

-- Answers for 'What is the name of the theorem in mathematical logic that demonstrates that any sufficiently expressive formal system of arithmetic cannot prove all true statements about the natural numbers?' (assuming question_id = 290)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(290, 'Zermelo-Fraenkel axioms', FALSE),
(290, 'Peano axioms', FALSE),
(290, 'Russells paradox', FALSE),
(290, 'Gödels incompleteness theorems', TRUE),
(290, 'Cantors diagonal argument', FALSE),
(290, 'Turing completeness', FALSE);

-- Answers for 'What is the name of the economic concept describing a situation where the marginal benefit of producing one more unit of a good or service is equal to the marginal cost?' (assuming question_id = 291)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(291, 'Pareto efficiency', FALSE),
(291, 'Comparative advantage', FALSE),
(291, 'Economies of scale', FALSE),
(291, 'Marginal cost equals marginal benefit', TRUE),
(291, 'Law of diminishing returns', FALSE),
(291, 'Supply-side economics', FALSE);

-- Answers for 'What is the name of the geological epoch that began after the Pleistocene and is characterized by human impact on the environment?' (assuming question_id = 292)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(292, 'Miocene', FALSE),
(292, 'Pliocene', FALSE),
(292, 'Pleistocene', FALSE),
(292, 'Holocene', TRUE),
(292, 'Anthropocene', FALSE), -- Anthropocene is debated as a formal epoch
(292, 'Eocene', FALSE);

-- Answers for 'What is the name of the neurotransmitter that plays a key role in the brain\'s reward system and is often associated with feelings of pleasure and motivation?' (assuming question_id = 293)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(293, 'Serotonin', FALSE),
(293, 'Norepinephrine', FALSE),
(293, 'GABA', FALSE),
(293, 'Dopamine', TRUE),
(293, 'Acetylcholine', FALSE),
(293, 'Glutamate', FALSE);

-- Answers for 'What is the name of the literary device where a part of something is used to refer to the whole, or vice versa?' (assuming question_id = 294)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(294, 'Metaphor', FALSE),
(294, 'Simile', FALSE),
(294, 'Personification', FALSE),
(294, 'Synecdoche', TRUE),
(294, 'Metonymy', FALSE),
(294, 'Hyperbole', FALSE);

-- Answers for 'What is the name of the principle in quantum mechanics that states that certain pairs of physical properties, such as position and momentum, cannot both be known to arbitrarily high precision?' (assuming question_id = 295)
INSERT INTO answers (question_id, answer, right_answer) VALUES
(295, 'Pauli exclusion principle', FALSE),
(295, 'Superposition principle', FALSE),
(295, 'Quantum entanglement', FALSE),
(295, 'Heisenberg uncertainty principle', TRUE),
(295, 'Bohr model', FALSE),
(295, 'Schrödinger equation', FALSE);