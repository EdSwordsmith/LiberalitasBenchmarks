include("mop.jl")

PokemonType = make(Class, name=:PokemonType)
Fire = make(Class, name=:Fire, dsupers=(PokemonType,))
Water = make(Class, name=:Water, dsupers=(PokemonType,))
Grass = make(Class, name=:Grass, dsupers=(PokemonType,))
Electric = make(Class, name=:Electric, dsupers=(PokemonType,))
Normal = make(Class, name=:Normal, dsupers=(PokemonType,))
Ice = make(Class, name=:Ice, dsupers=(PokemonType,))
Fighting = make(Class, name=:Fighting, dsupers=(PokemonType,))
Poison = make(Class, name=:Poison, dsupers=(PokemonType,))
Ground = make(Class, name=:Ground, dsupers=(PokemonType,))
Flying = make(Class, name=:Flying, dsupers=(PokemonType,))
Psychic = make(Class, name=:Psychic, dsupers=(PokemonType,))
Bug = make(Class, name=:Bug, dsupers=(PokemonType,))
Rock = make(Class, name=:Rock, dsupers=(PokemonType,))
Ghost = make(Class, name=:Ghost, dsupers=(PokemonType,))
Dragon = make(Class, name=:Dragon, dsupers=(PokemonType,))

Pokemon = make(Class, name=:Pokemon)
Lotad = make(Class, name=:Lotad, dsupers=(Pokemon, Water, Grass))
Charmander = make(Class, name=:Charmander, dsupers=(Pokemon, Fire))
Gastly = make(Class, name=:Gastly, dsupers=(Pokemon, Ghost))

@generic attack_mult
@method attack_mult(attack_type::PokemonType, defender::Pokemon) = 1

# Normal attacks
@method attack_mult(attack_type::Normal, defender::Rock) = 0.5 * next()
@method attack_mult(attack_type::Normal, defender::Ghost) = 0

# Fire attacks
@method attack_mult(attack_type::Fire, defender::Fire) = 0.5 * next()
@method attack_mult(attack_type::Fire, defender::Water) = 0.5 * next()
@method attack_mult(attack_type::Fire, defender::Grass) = 2 * next()
@method attack_mult(attack_type::Fire, defender::Ice) = 2 * next()
@method attack_mult(attack_type::Fire, defender::Bug) = 2 * next()
@method attack_mult(attack_type::Fire, defender::Rock) = 0.5 * next()
@method attack_mult(attack_type::Fire, defender::Dragon) = 0.5 * next()

# Water attacks
@method attack_mult(attack_type::Water, defender::Fire) = 2 * next()
@method attack_mult(attack_type::Water, defender::Water) = 0.5 * next()
@method attack_mult(attack_type::Water, defender::Grass) = 0.5 * next()
@method attack_mult(attack_type::Water, defender::Ground) = 2 * next()
@method attack_mult(attack_type::Water, defender::Rock) = 2 * next()
@method attack_mult(attack_type::Water, defender::Dragon) = 0.5 * next()

# Electric attacks
@method attack_mult(attack_type::Electric, defender::Water) = 2 * next()
@method attack_mult(attack_type::Electric, defender::Electric) = 0.5 * next()
@method attack_mult(attack_type::Electric, defender::Grass) = 0.5 * next()
@method attack_mult(attack_type::Electric, defender::Ground) = 0
@method attack_mult(attack_type::Electric, defender::Flying) = 2 * next()
@method attack_mult(attack_type::Electric, defender::Dragon) = 0.5 * next()

# Grass attacks
@method attack_mult(attack_type::Grass, defender::Fire) = 0.5 * next()
@method attack_mult(attack_type::Grass, defender::Water) = 2 * next()
@method attack_mult(attack_type::Grass, defender::Grass) = 0.5 * next()
@method attack_mult(attack_type::Grass, defender::Poison) = 0.5 * next()
@method attack_mult(attack_type::Grass, defender::Ground) = 2 * next()
@method attack_mult(attack_type::Grass, defender::Flying) = 0.5 * next()
@method attack_mult(attack_type::Grass, defender::Bug) = 0.5 * next()
@method attack_mult(attack_type::Grass, defender::Rock) = 2 * next()
@method attack_mult(attack_type::Grass, defender::Dragon) = 0.5 * next()

# Ice attacks
@method attack_mult(attack_type::Ice, defender::Water) = 0.5 * next()
@method attack_mult(attack_type::Ice, defender::Grass) = 2 * next()
@method attack_mult(attack_type::Ice, defender::Ice) = 0.5 * next()
@method attack_mult(attack_type::Ice, defender::Ground) = 2 * next()
@method attack_mult(attack_type::Ice, defender::Flying) = 2 * next()
@method attack_mult(attack_type::Ice, defender::Dragon) = 2 * next()

# Fighting attacks
@method attack_mult(attack_type::Fighting, defender::Normal) = 2 * next()
@method attack_mult(attack_type::Fighting, defender::Ice) = 2 * next()
@method attack_mult(attack_type::Fighting, defender::Poison) = 0.5 * next()
@method attack_mult(attack_type::Fighting, defender::Flying) = 0.5 * next()
@method attack_mult(attack_type::Fighting, defender::Psychic) = 0.5 * next()
@method attack_mult(attack_type::Fighting, defender::Bug) = 0.5 * next()
@method attack_mult(attack_type::Fighting, defender::Rock) = 2 * next()
@method attack_mult(attack_type::Fighting, defender::Ghost) = 0

# Poison attacks
@method attack_mult(attack_type::Poison, defender::Grass) = 2 * next()
@method attack_mult(attack_type::Poison, defender::Poison) = 0.5 * next()
@method attack_mult(attack_type::Poison, defender::Ground) = 0.5 * next()
@method attack_mult(attack_type::Poison, defender::Bug) = 2 * next()
@method attack_mult(attack_type::Poison, defender::Rock) = 0.5 * next()
@method attack_mult(attack_type::Poison, defender::Ghost) = 0.5 * next()

# Ground attacks
@method attack_mult(attack_type::Ground, defender::Fire) = 2 * next()
@method attack_mult(attack_type::Ground, defender::Electric) = 2 * next()
@method attack_mult(attack_type::Ground, defender::Grass) = 0.5 * next()
@method attack_mult(attack_type::Ground, defender::Poison) = 2 * next()
@method attack_mult(attack_type::Ground, defender::Flying) = 0
@method attack_mult(attack_type::Ground, defender::Bug) = 0.5 * next()
@method attack_mult(attack_type::Ground, defender::Rock) = 2 * next()

# Flying attacks
@method attack_mult(attack_type::Flying, defender::Electric) = 0.5 * next()
@method attack_mult(attack_type::Flying, defender::Grass) = 2 * next()
@method attack_mult(attack_type::Flying, defender::Fighting) = 2 * next()
@method attack_mult(attack_type::Flying, defender::Bug) = 2 * next()
@method attack_mult(attack_type::Flying, defender::Rock) = 0.5 * next()

# Psychic attacks
@method attack_mult(attack_type::Psychic, defender::Fighting) = 2 * next()
@method attack_mult(attack_type::Psychic, defender::Poison) = 2 * next()
@method attack_mult(attack_type::Psychic, defender::Psychic) = 0.5 * next()

# Bug attacks
@method attack_mult(attack_type::Bug, defender::Fire) = 0.5 * next()
@method attack_mult(attack_type::Bug, defender::Grass) = 2 * next()
@method attack_mult(attack_type::Bug, defender::Fighting) = 0.5 * next()
@method attack_mult(attack_type::Bug, defender::Poison) = 2 * next()
@method attack_mult(attack_type::Bug, defender::Flying) = 0.5 * next()
@method attack_mult(attack_type::Bug, defender::Psychic) = 2 * next()
@method attack_mult(attack_type::Bug, defender::Ghost) = 0.5 * next()

# Rock attacks
@method attack_mult(attack_type::Rock, defender::Fire) = 2 * next()
@method attack_mult(attack_type::Rock, defender::Ice) = 2 * next()
@method attack_mult(attack_type::Rock, defender::Fighting) = 0.5 * next()
@method attack_mult(attack_type::Rock, defender::Ground) = 0.5 * next()
@method attack_mult(attack_type::Rock, defender::Flying) = 2 * next()
@method attack_mult(attack_type::Rock, defender::Bug) = 2 * next()

# Ghost attacks
@method attack_mult(attack_type::Ghost, defender::Normal) = 0
@method attack_mult(attack_type::Ghost, defender::Psychic) = 0
@method attack_mult(attack_type::Ghost, defender::Ghost) = 2 * next()

# Dragon attacks
@method attack_mult(attack_type::Dragon, defender::Dragon) = 2 * next()
