# QCM - Terraform - IG2I

Questions pour évaluer la compréhension du cours et des travaux pratiques.

---

## Question 1 : Concept IaC

Qu'est-ce que l'Infrastructure as Code (IaC) ?

- [ ] A. Un langage de programmation pour créer des sites web
- [ ] B. Une méthode pour gérer et provisionner l'infrastructure via des fichiers de définition
- [ ] C. Un système d'exploitation pour serveurs cloud
- [ ] D. Un outil de monitoring d'infrastructure

**Réponse correcte : B**

---

## Question 2 : État Terraform

Quel est le rôle du fichier `terraform.tfstate` ?

- [ ] A. Stocker les variables de configuration
- [ ] B. Contenir la documentation du projet
- [ ] C. Suivre l'état actuel de l'infrastructure gérée par Terraform
- [ ] D. Définir les ressources à créer

**Réponse correcte : C**

---

## Question 3 : Workflow Terraform

Quelle est la séquence correcte des commandes Terraform pour déployer une nouvelle infrastructure ?

- [ ] A. `terraform apply` → `terraform init` → `terraform plan`
- [ ] B. `terraform init` → `terraform plan` → `terraform apply`
- [ ] C. `terraform plan` → `terraform init` → `terraform apply`
- [ ] D. `terraform validate` → `terraform apply` → `terraform init`

**Réponse correcte : B**

---

## Question 4 : Providers

Quel est le rôle d'un provider Terraform ?

- [ ] A. Gérer les variables d'environnement
- [ ] B. Fournir l'interface pour interagir avec les APIs de services (AWS, Azure, etc.)
- [ ] C. Compiler le code Terraform en binaire
- [ ] D. Créer des backups de l'infrastructure

**Réponse correcte : B**

---

## Question 5 : Différence Ansible vs Terraform

Quelle affirmation est correcte concernant Ansible et Terraform ?

- [ ] A. Ansible est idéal pour provisionner l'infrastructure cloud, Terraform pour configurer les logiciels
- [ ] B. Terraform est idéal pour provisionner l'infrastructure cloud, Ansible pour configurer les logiciels
- [ ] C. Ansible et Terraform font exactement la même chose
- [ ] D. Terraform ne peut pas être utilisé avec le cloud

**Réponse correcte : B**

---

## Question 6 : Variables vs Locals

Quelle est la différence principale entre `variables` et `locals` en Terraform ?

- [ ] A. Les variables sont pour les valeurs externes configurables, les locals pour les valeurs calculées internes
- [ ] B. Les variables sont obsolètes, il faut toujours utiliser locals
- [ ] C. Les locals sont pour les valeurs externes, les variables pour les valeurs internes
- [ ] D. Il n'y a aucune différence, ce sont des synonymes

**Réponse correcte : A**

---

## Question 7 : Idempotence

Que signifie l'idempotence dans le contexte de Terraform ?

- [ ] A. Terraform détruit toujours toute l'infrastructure avant de la recréer
- [ ] B. Terraform applique les changements uniquement si nécessaire pour atteindre l'état désiré
- [ ] C. Terraform ne peut être exécuté qu'une seule fois
- [ ] D. Terraform crée toujours de nouvelles ressources à chaque exécution

**Réponse correcte : B**

---

## Question 8 : Random Provider

Pourquoi utilise-t-on le provider `random` dans les exercices ?

- [ ] A. Pour chiffrer les données sensibles
- [ ] B. Pour générer des suffixes uniques et garantir l'unicité des noms de ressources
- [ ] C. Pour créer des mots de passe aléatoires pour les utilisateurs
- [ ] D. Pour simuler des pannes aléatoires

**Réponse correcte : B**

---

## Question 9 : Fichier terraform.tfvars

Pourquoi le fichier `terraform.tfvars` ne doit-il PAS être commité dans Git ?

- [ ] A. Parce qu'il est trop volumineux
- [ ] B. Parce qu'il contient souvent des valeurs sensibles (credentials, secrets)
- [ ] C. Parce qu'il est généré automatiquement
- [ ] D. Parce que Terraform l'interdit

**Réponse correcte : B**

---

## Question 10 : Commande terraform plan

Que fait la commande `terraform plan` ?

- [ ] A. Elle applique immédiatement les modifications à l'infrastructure
- [ ] B. Elle affiche un aperçu des modifications qui seront appliquées sans les exécuter
- [ ] C. Elle détruit l'infrastructure existante
- [ ] D. Elle crée un backup de l'état actuel

**Réponse correcte : B**

---

# Questions basées sur les exercices pratiques

---

## Question 11 : Exercice 01 - Random Provider

Dans l'exercice 01, quel type de ressource `random` avez-vous utilisé pour générer un suffixe unique ?

- [ ] A. `random_string`
- [ ] B. `random_id`
- [ ] C. `random_password`
- [ ] D. `random_uuid`

**Réponse correcte : B**

---

## Question 12 : Exercice 01 - État sans cloud

Quel est l'avantage principal d'utiliser le provider `random` dans l'exercice 01 ?

- [ ] A. Il est gratuit
- [ ] B. Il permet de comprendre le concept d'état Terraform sans avoir besoin de credentials cloud
- [ ] C. Il est plus rapide que les autres providers
- [ ] D. Il ne crée pas de fichier .tfstate

**Réponse correcte : B**

---

## Question 13 : Exercice 02 - Bucket S3

Dans l'exercice 02, pourquoi les noms de buckets S3 doivent-ils être globalement uniques ?

- [ ] A. C'est une limitation technique de Terraform
- [ ] B. Pour des raisons de sécurité AWS
- [ ] C. Les buckets S3 sont accessibles via des URL DNS qui doivent être uniques dans le monde entier
- [ ] D. Pour faciliter la facturation

**Réponse correcte : C**

---

## Question 14 : Exercice 02 - Référence de ressource

Comment référencer le suffixe hexadécimal d'une ressource `random_id` nommée `bucket_suffix` ?

- [ ] A. `random_id.bucket_suffix.value`
- [ ] B. `random_id.bucket_suffix.hex`
- [ ] C. `${bucket_suffix.hex}`
- [ ] D. `random_id.bucket_suffix.id`

**Réponse correcte : B**

---

## Question 15 : Exercice 03 - Organisation des fichiers

Dans l'exercice 03, quelle est l'organisation correcte des fichiers Terraform ?

- [ ] A. Tout dans un seul fichier `main.tf`
- [ ] B. `main.tf`, `variables.tf`, `outputs.tf` séparés
- [ ] C. Un fichier par ressource
- [ ] D. Uniquement `variables.tf` et `outputs.tf`

**Réponse correcte : B**

---

## Question 16 : Exercice 03 - Déclaration de variable

Quelle syntaxe est correcte pour déclarer une variable avec une valeur par défaut ?

- [ ] A. `var bucket_prefix = "my-bucket"`
- [ ] B. `variable "bucket_prefix" { default = "my-bucket" }`
- [ ] C. `variable bucket_prefix default "my-bucket"`
- [ ] D. `default variable "bucket_prefix" = "my-bucket"`

**Réponse correcte : B**

---

## Question 17 : Exercice 03 - Outputs

Quel est le but principal des `outputs` dans Terraform ?

- [ ] A. Afficher des valeurs importantes après l'exécution (IDs, URLs, etc.)
- [ ] B. Exporter l'infrastructure vers un autre outil
- [ ] C. Sauvegarder l'état dans un fichier
- [ ] D. Valider la syntaxe du code

**Réponse correcte : A**

---

## Question 18 : Exercice 04 - Locals

Dans l'exercice 04, quelle est la syntaxe correcte pour référencer une valeur `local` nommée `bucket_name` ?

- [ ] A. `var.bucket_name`
- [ ] B. `locals.bucket_name`
- [ ] C. `local.bucket_name`
- [ ] D. `${bucket_name}`

**Réponse correcte : C**

---

## Question 19 : Exercice 04 - Merge de tags

Quelle fonction Terraform permet de fusionner plusieurs maps de tags ?

- [ ] A. `concat()`
- [ ] B. `merge()`
- [ ] C. `join()`
- [ ] D. `combine()`

**Réponse correcte : B**

---

## Question 20 : Exercice 04 - Utilisation des locals

Dans quel cas devriez-vous utiliser un `local` plutôt qu'une `variable` ?

- [ ] A. Pour des valeurs qui viennent de l'extérieur
- [ ] B. Pour des valeurs calculées à partir d'autres valeurs (variables ou ressources)
- [ ] C. Pour des valeurs secrètes
- [ ] D. Pour des valeurs qui changent à chaque exécution

**Réponse correcte : B**

---

# Questions avancées (Exercices 05, 06, 07)

---

## Question 21 : Exercice 05 - Outputs sensibles

Pourquoi marquer un output comme `sensitive = true` ?

- [ ] A. Pour le cacher dans les logs et l'output de terraform apply
- [ ] B. Pour chiffrer la valeur dans le fichier state
- [ ] C. Pour empêcher l'output d'être lu par d'autres modules
- [ ] D. Pour forcer une validation de la valeur

**Réponse correcte : A**

---

## Question 22 : Exercice 05 - Data sources

Quelle est la différence principale entre un `resource` et un `data` source ?

- [ ] A. Un resource est plus rapide qu'un data source
- [ ] B. Un resource crée/modifie des ressources, un data source les lit
- [ ] C. Un data source coûte plus cher en AWS
- [ ] D. Un resource ne peut pas être détruit

**Réponse correcte : B**

---

## Question 23 : Exercice 05 - Référence data source

Comment référencer l'account ID depuis un data source `aws_caller_identity` nommé "current" ?

- [ ] A. `aws_caller_identity.current.account_id`
- [ ] B. `data.aws_caller_identity.current.account_id`
- [ ] C. `data.current.account_id`
- [ ] D. `caller_identity.current.account_id`

**Réponse correcte : B**

---

## Question 24 : Exercice 05 - Utilisation des outputs

Dans quel cas les outputs sont-ils particulièrement utiles ?

- [ ] A. Pour réduire la taille du fichier state
- [ ] B. Pour partager des informations entre modules ou avec d'autres outils
- [ ] C. Pour accélérer terraform apply
- [ ] D. Pour valider la syntaxe du code

**Réponse correcte : B**

---

## Question 25 : Exercice 06 - Count vs For-Each

Quel est l'avantage principal de `for_each` par rapport à `count` ?

- [ ] A. for_each est plus rapide
- [ ] B. for_each permet de référencer par clé significative au lieu d'index numérique
- [ ] C. for_each consomme moins de ressources
- [ ] D. for_each est obligatoire pour AWS

**Réponse correcte : B**

---

## Question 26 : Exercice 06 - Référence avec count

Comment accéder au deuxième bucket S3 créé avec `count` (ressource nommée "multiple") ?

- [ ] A. `aws_s3_bucket.multiple.1`
- [ ] B. `aws_s3_bucket.multiple[1]`
- [ ] C. `aws_s3_bucket.multiple.second`
- [ ] D. `aws_s3_bucket.multiple["1"]`

**Réponse correcte : B**

---

## Question 27 : Exercice 06 - For-Each avec map

Quelle syntaxe utilise-t-on dans un `for_each` pour accéder à la clé et la valeur ?

- [ ] A. `key` et `value`
- [ ] B. `each.key` et `each.value`
- [ ] C. `this.key` et `this.value`
- [ ] D. `current.key` et `current.value`

**Réponse correcte : B**

---

## Question 28 : Exercice 06 - Splat expression

Que fait l'expression `aws_s3_bucket.multiple[*].id` ?

- [ ] A. Retourne l'ID du premier bucket
- [ ] B. Retourne une liste de tous les IDs des buckets
- [ ] C. Crée une copie de tous les buckets
- [ ] D. Détruit tous les buckets sauf le premier

**Réponse correcte : B**

---

## Question 29 : Exercice 07 - Ressource conditionnelle

Comment créer une ressource conditionnellement selon une variable booléenne `enable_feature` ?

- [ ] A. `if = var.enable_feature`
- [ ] B. `count = var.enable_feature`
- [ ] C. `count = var.enable_feature ? 1 : 0`
- [ ] D. `enabled = var.enable_feature`

**Réponse correcte : C**

---

## Question 30 : Exercice 07 - Expression ternaire

Que signifie l'expression `local.is_prod ? "Enabled" : "Disabled"` ?

- [ ] A. Retourne "Enabled" si is_prod est true, sinon "Disabled"
- [ ] B. Compare is_prod avec les chaînes "Enabled" et "Disabled"
- [ ] C. Crée une variable qui change entre Enabled et Disabled
- [ ] D. Valide que is_prod contient "Enabled" ou "Disabled"

**Réponse correcte : A**

---

## Question 31 : Exercice 07 - Bloc dynamic

À quoi servent les blocs `dynamic` dans Terraform ?

- [ ] A. À rendre l'infrastructure plus rapide
- [ ] B. À créer des blocs de configuration conditionnellement
- [ ] C. À chiffrer les données sensibles
- [ ] D. À générer des noms aléatoires

**Réponse correcte : B**

---

## Question 32 : Exercice 07 - Logique environnement

Dans l'exercice 07, pourquoi force-t-on le versioning en production ?

- [ ] A. C'est une exigence AWS
- [ ] B. Pour des raisons de conformité et protection des données
- [ ] C. Pour réduire les coûts
- [ ] D. Pour améliorer les performances

**Réponse correcte : B**

---

## Question 33 : Exercice 06 - Problème avec count

Que se passe-t-il si vous supprimez un élément au milieu d'une liste utilisée avec `count` ?

- [ ] A. Seul l'élément supprimé est détruit
- [ ] B. Tous les éléments après celui supprimé sont recréés
- [ ] C. Terraform refuse de supprimer l'élément
- [ ] D. Rien, Terraform gère automatiquement

**Réponse correcte : B**

---

## Question 34 : Exercice 05 - Commande terraform output

Comment afficher uniquement la valeur d'un output spécifique nommé "bucket_arn" ?

- [ ] A. `terraform show bucket_arn`
- [ ] B. `terraform output bucket_arn`
- [ ] C. `terraform get bucket_arn`
- [ ] D. `terraform display bucket_arn`

**Réponse correcte : B**

---

## Question 35 : Exercice 07 - For expression avec condition

Que fait cette expression : `[for k, v in var.configs : k if v.enabled]` ?

- [ ] A. Retourne tous les éléments de configs
- [ ] B. Retourne les clés des éléments où enabled est true
- [ ] C. Active tous les éléments de configs
- [ ] D. Valide que enabled est défini

**Réponse correcte : B**

---

## Barème

### Questions théoriques (1-10)
- 8-10/10 : Excellente compréhension théorique
- 6-7/10 : Bonne compréhension, quelques révisions recommandées
- < 6/10 : Revoyez les concepts du cours

### Questions pratiques de base (11-20)
- 8-10/10 : Excellente maîtrise des exercices de base
- 6-7/10 : Bonne maîtrise, refaites certains exercices
- < 6/10 : Refaites les exercices 01-04

### Questions pratiques avancées (21-35)
- 12-15/15 : Excellente maîtrise des concepts avancés
- 9-11/15 : Bonne maîtrise, revoyez les exercices 05-07
- < 9/15 : Refaites les exercices 05-07

### Score global (35 questions)
- 30-35/35 : Excellent ! Vous maîtrisez parfaitement Terraform
- 25-29/35 : Très bien ! Quelques révisions mineures recommandées
- 18-24/35 : Bien, mais revoyez les concepts avancés
- < 18/35 : Revoyez le cours et refaites tous les exercices

---

## Ressources pour révision

- [Documentation Terraform](https://developer.hashicorp.com/terraform/docs)
- [Terraform Registry](https://registry.terraform.io/)
- Slides du cours : [cours-slides.pdf](https://frederictriquet.github.io/IG2I-Terraform/cours-slides.pdf)
- Exercices pratiques dans ce repository :
  - Exercise 01 : Random provider
  - Exercise 02 : Premier déploiement AWS avec S3
  - Exercise 03 : Variables et terraform.tfvars
  - Exercise 04 : Locals et valeurs calculées
  - Exercise 05 : Outputs et Data Sources
  - Exercise 06 : Count et For-Each
  - Exercise 07 : Ressources conditionnelles et Dynamic Blocks
