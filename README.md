# Application de Recettes

## Description
L'Application de Recettes est une application Flutter qui permet aux utilisateurs d'explorer des recettes par catégorie ou par pays. Les utilisateurs peuvent rechercher des recettes, consulter des informations détaillées et enregistrer leurs recettes préférées pour un accès rapide. L'application offre une navigation fluide et une interface utilisateur claire, garantissant une expérience intuitive.

---

## Pré-requis
- **Version de Flutter :** 3.24.0 ou supérieure
- **Version de Dart :** 3.5.4 ou supérieure

---

## Fonctionnalités
### Tableau de Bord
- **Vue Catégories :**
  - Affiche une liste des catégories de recettes.
  - Permet de naviguer vers une liste de recettes dans une catégorie sélectionnée.
  - Barre de recherche pour filtrer les recettes par mot-clé.
- **Vue Pays :**
  - Affiche une liste de pays.
  - Permet de naviguer vers des recettes spécifiques à un pays sélectionné.
  - Barre de recherche pour filtrer les recettes par mot-clé.

### Détails des Recettes
- Vue détaillée d'une recette, comprenant :
  - Catégorie
  - Pays
  - Ingrédients avec images (si disponibles)
  - Instructions de préparation
  - Image du plat (si disponibles)
  - Option pour ajouter/supprimer la recette des favoris.

### Favoris
- Affiche une liste de toutes les recettes ajoutées aux favoris.
- Barre de recherche pour filtrer les recettes favorites par mot-clé.

### Barre de Navigation
- **Accueil :** Retour au tableau de bord.
- **Favoris :** Accès à la liste des favoris.

---

## API
- **API Utilisée :** [TheMealDB API](https://www.themealdb.com/)
  - Endpoints utilisés :
    - `https://www.themealdb.com/api/json/v1/1/categories.php` - Récupérer les catégories de recettes.
    - `https://www.themealdb.com/api/json/v1/1/filter.php?c={CATEGORY}` - Récupérer les recettes par catégorie.
    - `https://www.themealdb.com/api/json/v1/1/filter.php?a={AREA}` - Récupérer les recettes par pays.
    - `https://www.themealdb.com/api/json/v1/1/lookup.php?i={ID}` - Récupérer les détails d'une recette.
    - `https://www.themealdb.com/api/json/v1/1/list.php?a=list` - Récupérer la liste des pays.

---

## Installation
1. Clonez le dépôt :
   ```bash
   git clone <repository_url>
   ```
2. Accédez au répertoire du projet :
   ```bash
   cd recipe_app
   ```
3. Récupérez les dépendances :
   ```bash
   flutter pub get
   ```
4. Préparez l'environnement d'exécution :
   - **Téléphone Android :** Activez le mode développeur et autorisez le débogage USB.
   - **Émulateur :** Configurez un émulateur Android ou iOS dans votre IDE Flutter (Android Studio ou VS Code).
5. Lancez l'application :
   ```bash
   flutter run
   ```

---
