Dans ce dépôt git, il y a des supports de cours et d'exercices.
Les exercices sont accompagnés de leurs corrections (répertoires `solution`).
Je veux conserver tout dans ce dépôt.
Je veux créer un autre dépôt SANS les corrections des exercices ("mirror"). Je veux un script qui:
- lit un fichier `.mirrorignore` dont le fonctionnement est le même que .gitignore, mais pour la fonctionnalité de mirroring : les chemins renseignés dans ce fichier sont ignorés de la recopie
- le fichier .gitignore est pris en compte aussi
- le dépôt mirroir sera configuré dans les variables de la CI de ce dépôt
- le script sera exécuté dans la CI github de ce dépôt pour la branche master uniquement