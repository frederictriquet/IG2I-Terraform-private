---
marp: true
theme: default
paginate: true
math: mathjax
---

# Cours d'introduction à Terraform

Formation Infrastructure as Code avec Terraform

---

## Table des matières

1. Introduction à l'Infrastructure en tant que Code
2. Qu'est-ce que Terraform ?
3. Approches traditionnelles vs Terraform
4. Terraform vs Ansible
5. Concepts fondamentaux

---

## Table des matières (suite)

6. Débuter avec AWS
7. Flux de travail Terraform
8. Concepts avancés
9. Outils alternatifs

---

# 1. Introduction à l'Infrastructure en tant que Code

---

## Qu'est-ce que l'IaC ?

L'Infrastructure en tant que Code est la pratique de gestion et d'approvisionnement de l'infrastructure via des fichiers de définition lisibles par machine.

---

## Avantages clés de l'IaC

- **Contrôle de version** : Suivre les modifications
- **Reproductibilité** : Environnements identiques
- **Automatisation** : Réduire les erreurs humaines
- **Documentation** : Le code est source de documentation
- **Collaboration** : Pratiques standard

---

## Évolution : Configuration manuelle

**Années 1990-2000**
- Pas de cloud
- Pas de virtualisation
- Pas de conteneurs
- Configuration manuelle via SSH/RDP
- Documentation dans des wikis
- Sujet à la dérive et l'incohérence

---

## Évolution : Gestion de configuration

**Années 2000-2010**
- Pas de cloud
- Début de la virtualisation
- Pas de conteneurs
- Outils : Puppet, Chef, Ansible
- Automatisation de la configuration
- Focus sur la configuration logicielle

---

## Évolution : Infrastructure as Code

**Années 2010-aujourd'hui**
- Début du cloud
- Début des conteneurs
- Outils : Terraform, CloudFormation
- Cycle de vie complet de l'infrastructure

---

# 2. Qu'est-ce que Terraform ?

---

## Vue d'ensemble

**Terraform** est un outil d'_Infrastructure as Code_ open-source créé par HashiCorp.

Il permet de définir des ressources cloud et on-premise dans des fichiers de configuration lisibles.

---

## Caractéristiques clés

- **Langage déclaratif** : Décrire ce que vous voulez
- **Agnostique du cloud** : AWS, Azure, GCP, etc.
- **Gestion d'état** : Suit l'état actuel de l'infrastructure
- **Planification** : Prévisualiser les modifications avant de les appliquer
- **Gestion des dépendances** : Résolution automatique

---

## Workflow Terraform

```
Code Terraform (.tf)
       ↓
terraform init
       ↓
terraform plan
       ↓
terraform apply
       ↓
Ressources réelles
```

---

# 3. Approches traditionnelles vs Terraform

---

## Approche 1 : Configuration manuelle

**Créer une instance EC2 manuellement :**
1. Se connecter à la console AWS
2. Naviguer vers EC2
3. Cliquer sur "Launch Instance"
4. Configurer AMI, type, stockage, tags
5. Lancer et sauvegarder la clé TODO vérifier ce que c'est

---

## Problèmes de l'approche manuelle

- ❌ Fastidieux (lourdeur des portails des cloud providers)
- ❌ Risque d'oubli d'un paramètre
- ❌ Difficile à reproduire
- ❌ Chronophage pour plusieurs ressources
- ❌ Pas de contrôle de version
- ❌ Connaissances dans la tête des gens
- ❌ Pas de piste d'audit

---

## Solution Terraform

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "WebServer"
  }
}
```

---

## Avantages Terraform

- ✅ Versionné dans Git
- ✅ Une commande : `terraform apply`
- ✅ Documenté dans le code
- ✅ Scalable (1 ou 100 instances)

---

## Approche 2 : Scripts shell

```bash
#!/bin/bash
# Créer VPC
VPC_ID=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 \
  --query 'Vpc.VpcId' --output text)

# Créer Subnet
SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID \
  --cidr-block 10.0.1.0/24 --output text)

# Créer instance
aws ec2 run-instances --image-id ami-xxx \
  --instance-type t2.micro --subnet-id $SUBNET_ID
```

---

## Problèmes des scripts shell

- ❌ Impératif : spécifier chaque étape
- ❌ Pas de gestion d'état
- ❌ Ré-exécution crée des doublons
- ❌ Gestion d'erreurs complexe
- ❌ Pas de gestion des dépendances
- ❌ Pas de dry-run

---

## Solution Terraform (déclarative)

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
}
```

---

## Avantages de Terraform

- ✅ Déclaratif : décrire l'état souhaité
- ✅ Gestion d'état : il sait ce qui existe
- ✅ Idempotent : on peut l'exécuter plusieurs fois sans problème
- ✅ Résolution automatique des dépendances
- ✅ Mises à jour et suppressions faciles

---

## Approche 3 : Outils cloud-spécifiques

**CloudFormation (AWS), ARM Templates (Azure)**

**Problèmes :**
- ❌ Verrouillage fournisseur
- ❌ Limité à un seul cloud
- ❌ Syntaxe JSON/YAML complexe

---

# 4. Terraform vs Ansible

---

## Différences clés

| Aspect | Ansible | Terraform |
|--------|---------|-----------|
| **Objectif** | Configuration | Provisionnement |
| **Langage** | YAML | HCL (Hashicorp Configuration language) |
| **État** | Sans état | Avec état |
| **Approche** | Push (SSH) | API-based |
| **Meilleur pour** | Configuration de serveurs | Création d'infrastructure |

---

## Objectif : Ansible

**Gestion de configuration**
- "Comment configurer ces serveurs ?"
- Infrastructure mutable
- Ex: Installer Nginx, configurer firewall

---

## Objectif : Terraform

**Provisionnement d'infrastructure**
- "De quelle infrastructure ai-je besoin ?"
- Infrastructure immuable
- Ex: Créer VPC, EC2, load balancers, ...

---

## Gestion d'état : Ansible

```yaml
- name: Ensure Nginx is installed
  apt:
    name: nginx
    state: present
```

- Se connecte et vérifie à chaque fois
- Pas de fichier d'état persistant
- Peut être lent pour de grandes infrastructures

---

## Gestion d'état : Terraform

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```

- Maintient `terraform.tfstate`
- Sait exactement ce qui existe
- Planification rapide

---

## Exemple : Ansible

```yaml
- name: Provision EC2 instance
  hosts: localhost
  tasks:
    - name: Create EC2 instance
      ec2:
        key_name: mykey
        instance_type: t2.micro
        image: ami-0c55b159cbfafe1f0
        region: us-east-1
```

---

## Exemple : Terraform

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "mykey"

  tags = {
    Name = "WebServer"
  }
}

output "instance_ip" {
  value = aws_instance.web.public_ip
}
```

---

## Quand utiliser Ansible ?

- Configuration de logiciels sur serveurs existants
- Déploiement d'applications
- Commandes ad-hoc
- Gestion de fichiers de configuration
- Orchestration multi-étapes

---

## Quand utiliser Terraform ?

- Création d'infrastructure cloud
- Gestion du cycle de vie (créer, modifier, détruire) de ressources cloud
- Modules d'infrastructure réutilisables

---

## Utilisez les deux ensemble !

```
Terraform → Créer l'infrastructure
  ├─ Instances EC2
  ├─ RDS
  └─ Load balancer
     ↓
Ansible → Configurer l'infrastructure
  ├─ Installer logiciels
  ├─ Configurer applications
  └─ Déployer le code
```

---

## Workflow combiné

```bash
# 1. Créer l'infrastructure
terraform apply

# 2. Obtenir les IPs
terraform output -json > inventory.json

# 3. Configurer les serveurs
ansible-playbook -i inventory.json configure.yml
```

- ⚠️ les outputs doivent être adaptés ⚠️
- l'utilisation de l'inventaire automatique est quand même préférable

---

# 5. Concepts fondamentaux

---

## Providers (Fournisseurs)

Les providers sont des plugins permettant à Terraform d'interagir avec les APIs.

```hcl
provider "aws" {
  region = "us-east-1"
}

provider "google" {
  project = "my-gcp-project"
  region  = "us-central1"
}
```

---

## Providers populaires

- **Cloud** : AWS, Azure, Google Cloud
- **Containers** : Kubernetes, Docker
- **DevOps** : GitHub, GitLab
- **Monitoring** : Datadog, PagerDuty
- **Et plus de 2000 autres !**

---

## Resources (Ressources)

Les ressources sont l'élément central de Terraform.
Elles sont fournies par les providers.
1 ressource $\approx$ 1 élément d'infrastructure
**Syntaxe :**
```hcl
resource "TYPE_RESSOURCE" "NOM" {
  argument1 = valeur1
  argument2 = valeur2
}
```

---

## Exemple de ressource

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "MyWebServer"
  }
}

# Référencer une autre ressource
resource "aws_eip" "web_ip" {
  instance = aws_instance.web.id
}
```

---

## Data Sources

Récupérer des informations sur des ressources existantes.

```hcl
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}
```

---

## Utiliser une Data Source

```hcl
resource "aws_instance" "web" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
}
```

---

## Variables

Rendre les configurations réutilisables.

```hcl
variable "instance_type" {
  description = "Type d'instance EC2"
  type        = string
  default     = "t2.micro"
}

variable "environment" {
  description = "Nom de l'environnement"
  type        = string
}
```

---

## Utilisation des variables

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type

  tags = {
    Name        = "web-${var.environment}"
    Environment = var.environment
  }
}
```

---

## Passer des variables

**Ligne de commande :**
```bash
terraform apply \
  -var="instance_type=t2.small" \
  -var="environment=prod"
```

**Fichier terraform.tfvars :**
```hcl
instance_type = "t2.small"
environment   = "prod"
```

---

## Outputs (Sorties)

Afficher des informations après l'exécution.

```hcl
output "instance_ip" {
  description = "IP publique"
  value       = aws_instance.web.public_ip
}

output "instance_id" {
  value = aws_instance.web.id
}
```

---

## Utilisation des outputs

```bash
$ terraform output
instance_ip = "54.123.45.67"
instance_id = "i-0abcd1234efgh5678"
```

---

## State (État)

Le fichier `terraform.tfstate` est la base de données de Terraform.

**Contient :**
- IDs des ressources
- Configuration actuelle
- Métadonnées et dépendances

---

## Emplacements du State

- **Local** : Sur votre machine (défaut)
- **Distant** : S3, Terraform Cloud (recommandé)

```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
  }
}
```

---

## Sécurité du State

⚠️ **Considérations importantes :**
- Contient des données sensibles - sécurisez-le !
- Ne jamais éditer manuellement
- Utiliser l'état distant pour la collaboration
- Activer le verrouillage d'état

---

## Idempotence

Exécuter plusieurs fois `terraform apply` → même résultat

```bash
$ terraform apply  # Crée 1 instance
$ terraform apply  # Aucun changement
$ terraform apply  # Aucun changement
```

**Comment :**
1. Lire l'état souhaité (`.tf`)
2. Lire l'état actuel (`.tfstate`)
3. Appliquer uniquement les différences

---

## Modules

Conteneurs pour plusieurs ressources utilisées ensemble.

**Structure :**
```
modules/
  └── vpc/
      ├── main.tf
      ├── variables.tf
      └── outputs.tf
```

---

## Définition de module

```hcl
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr
}
```

---

## Utilisation du module

```hcl
module "vpc" {
  source = "./modules/vpc"

  vpc_name           = "production-vpc"
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
}

resource "aws_instance" "web" {
  subnet_id = module.vpc.public_subnet_id
}
```

---

## Avantages des modules

- ✅ Réutilisabilité du code
- ✅ Organisation
- ✅ Encapsulation
- ✅ Contrôle de version des composants

---

## Un point sur l'organisation des fichiers

- Seule l'extension est vraiment importante (`.tf`)
- Il n'y a pas d'ordre à respecter (puisque c'est **déclaratif**)
- Terraform lit tous les fichiers du répertoire courant, retrouve les providers déclarés, les définitions de variables, les `locals`, les ressources, les outputs, et construit un arbre de dépendances pour savoir dans quel ordre il faut procéder
- **Conclusion:** on peut tout écrire dans 1 seul fichier `.tf`, **mais** on préférera répartir les éléments dans des fichiers avec des noms qui ont du sens
---

# 6. Débuter avec AWS

---

## Prérequis

1. **Compte AWS** : aws.amazon.com
2. **AWS CLI** : Installer et configurer
3. **Terraform** : Télécharger depuis terraform.io
4. **Éditeur** : VS Code recommandé

---

## Extension VS Code : HashiCorp Terraform

**Fonctionnalités :**
- Coloration syntaxique
- IntelliSense et auto-complétion
- Intégration des commandes
- Formatage automatique

```bash
code --install-extension hashicorp.terraform
```

---

## Autres extensions utiles

```bash
# Terraform Autocomplete
code --install-extension erd0s.terraform-autocomplete

# AWS Toolkit
code --install-extension amazonwebservices.aws-toolkit-vscode

# Infracost (estimation coûts)
code --install-extension Infracost.infracost
```

---

## Configuration VS Code

```json
{
  "[terraform]": {
    "editor.defaultFormatter": "hashicorp.terraform",
    "editor.formatOnSave": true
  },
  "terraform.languageServer": {
    "enabled": true
  }
}
```

---

## Configuration AWS : Option 1

**AWS CLI :**
```bash
aws configure
```

Entrer :
- AWS Access Key ID
- AWS Secret Access Key
- Région (ex: eu-west-3)
- Format de sortie (json)

---

## Configuration AWS : Option 2

**Variables d'environnement :**
```bash
export AWS_ACCESS_KEY_ID="votre-access-key"
export AWS_SECRET_ACCESS_KEY="votre-secret-key"
export AWS_DEFAULT_REGION="eu-west-3"
```

---

## Première configuration Terraform

```hcl
provider "aws" {
  region = "eu-west-3"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-terraform-bucket-12345"

  tags = {
    Name        = "My Terraform Bucket"
    Environment = "Learning"
  }
}
```

---

## Output du bucket

```hcl
output "bucket_name" {
  value = aws_s3_bucket.my_bucket.id
}
```

---

## Commandes de base

```bash
terraform init      # Initialiser
terraform fmt       # Formater
terraform validate  # Valider
terraform plan      # Voir changements
terraform apply     # Appliquer
terraform output    # Voir outputs
terraform destroy   # Détruire
```

---

# 7. Flux de travail Terraform

---

## Le flux principal

```
Écrire → Init → Plan → Apply → Destroy
```

---

## terraform init

Initialise un répertoire de travail, installe les providers et modules.

```bash
terraform init
```

**Quand l'exécuter :**
- Première fois dans un projet
- Après ajout de providers/modules

---

## terraform plan

Crée un plan d'exécution.

```bash
terraform plan
```

**Symboles :**
- `+` : Ressource créée
- `-` : Ressource détruite
- `~` : Ressource modifiée
- `-/+` : Ressource remplacée

---

## Exemple de sortie plan

```
Terraform will perform the following actions:

  # aws_instance.web will be created
  + resource "aws_instance" "web" {
      + ami           = "ami-0c55b159cbfafe1f0"
      + instance_type = "t2.micro"
      + id            = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

---

## terraform apply

Applique les changements.

```bash
terraform apply

# Auto-approuver
terraform apply -auto-approve

# Avec variables
terraform apply -var="instance_type=t2.small"
```

---

## terraform destroy

Détruit toutes les ressources gérées.

```bash
terraform destroy

# Détruire une ressource spécifique
terraform destroy -target=aws_instance.web
```

---

## terraform fmt

Formater le code.

```bash
terraform fmt              # Formater
terraform fmt -check       # Vérifier
terraform fmt -recursive   # Récursif
```

---

## terraform validate

Valider la syntaxe.

```bash
terraform validate
```

---

## Commandes d'état

```bash
# Lister les ressources
terraform state list

# Afficher une ressource
terraform state show aws_instance.web

# Retirer de l'état
terraform state rm aws_instance.web

# Renommer
terraform state mv aws_instance.old aws_instance.new
```

---

## Autres commandes utiles

```bash
# Afficher l'état actuel
terraform show

# Sync avec l'infra réelle
terraform refresh

# Créer un graphe
terraform graph | dot -Tpng > graph.png
```

---

# 8. Concepts avancés

---

## Locals

Valeurs locales pour la réutilisation.

```hcl
locals {
  common_tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
  instance_name = "${var.project}-${var.env}-web"
}

resource "aws_instance" "web" {
  tags = merge(local.common_tags, {
    Name = local.instance_name
  })
}
```

---

## Count

```hcl
resource "aws_instance" "server" {
  count         = 3
  ami           = var.ami_id
  instance_type = "t2.micro"

  tags = {
    Name = "server-${count.index}"
  }
}
```

---

## for_each (préféré)

```hcl
variable "instances" {
  default = {
    web = { instance_type = "t2.micro" }
    api = { instance_type = "t2.small" }
  }
}

resource "aws_instance" "server" {
  for_each      = var.instances
  ami           = var.ami_id
  instance_type = each.value.instance_type

  tags = { Name = each.key }
}
```

---

## Expressions conditionnelles

```hcl
resource "aws_instance" "web" {
  ami = var.ami_id
  instance_type = var.environment == "production" ? \
                  "t2.large" : "t2.micro"

  tags = {
    Name = var.environment == "production" ? \
           "prod-web" : "dev-web"
  }
}
```

---

## Blocs dynamiques : Variable

```hcl
variable "ingress_rules" {
  type = list(object({
    port        = number
    cidr_blocks = list(string)
  }))
  default = [
    { port = 80,  cidr_blocks = ["0.0.0.0/0"] },
    { port = 443, cidr_blocks = ["0.0.0.0/0"] }
  ]
}
```

---

## Blocs dynamiques : Utilisation

```hcl
resource "aws_security_group" "web" {
  name = "web-sg"

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}
```

---

## Workspaces : Commandes

Gérer plusieurs environnements.

```bash
# Lister
terraform workspace list

# Créer et basculer
terraform workspace new dev
terraform workspace new prod

# Basculer
terraform workspace select dev
```

---

## Workspaces : Utilisation

```hcl
resource "aws_instance" "web" {
  ami = var.ami_id
  instance_type = terraform.workspace == "prod" ? \
                  "t2.large" : "t2.micro"

  tags = {
    Name        = "web-${terraform.workspace}"
    Environment = terraform.workspace
  }
}
```

---

## Remote State Data Source

Partager outputs entre configurations.

**Projet A :**
```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}
```

---

## Remote State : Consommation

**Projet B :**
```hcl
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "my-terraform-state"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

# Utiliser
resource "aws_instance" "web" {
  subnet_id = data.terraform_remote_state.vpc.outputs.subnet_id
}
```

---

# 9. Outils alternatifs

---

## OpenTofu

Fork open-source de Terraform créé suite au changement de licence de Terraform.

**Points clés :**
- 100% compatible avec Terraform
- Même syntaxe HCL
- Géré par la communauté
- Vraiment open source

---

## Ressources

- **Documentation** : terraform.io/docs
- **Terraform Registry** : registry.terraform.io
- **Provider AWS** : registry.terraform.io/providers/hashicorp/aws
- **HashiCorp Learn** : learn.hashicorp.com
- **Communauté** : discuss.hashicorp.com

