Pour utiliser ce programme, se placer dans le répertoire ./src

Utilisations basiques : 
I - Résolution et affichage de l'instance exemple :
julia
include("resolution.jl")
Tents()

II - Résolution et affichage d'une instance existante
julia
include("resolution.jl")
Tents("pathInstance")

---------------------------------------------------------------------------

Les autres utilisations possibles sont les suivantes :
I - Génération d'un jeu de données
julia
include("generation.jl")
generateDataSet()

II - Résolution du jeu de données
julia
include("resolution.jl")
solveDataSet()

III - Présentation des résultats sous la forme d'un diagramme de performances
julia
include("io.jl")
performanceDiagram("../res/diagramme.pdf")

IV - Présentation des résultats sous la forme d'un tableau
julia
include("io.jl")
resultsArray("../res/array.tex")