# Contributing to feda_flutter

Merci de votre intérêt pour contribuer à feda_flutter ! Ce guide explique comment contribuer (issues, PR, conventions de commits, tests, style).

## Règles générales

- Ouvrez une issue si vous trouvez un bug ou souhaitez une fonctionnalité.
- Avant d'implémenter une fonctionnalité majeure, ouvrez d'abord une issue pour discussion.
- Respectez le `CODE_OF_CONDUCT.md` du projet.

## Workflow

1. Forkez le dépôt et créez une branche à partir de `dev` :

```bash
git checkout -b feat/short-description
```

2. Faites de petits commits clairs (voir Convention plus bas).
3. Assurez-vous que `flutter analyze` et `flutter test` passent.
4. Ouvrez une Pull Request vers la branche `dev` (base = `dev`).

## Convention de commits

Utilisez la convention "Conventional Commits" (ou proche) :

- feat: ajout d'une fonctionnalité
- fix: correction d'un bug
- docs: documentation
- refactor: refactorisation
- test: ajout/modification de tests
- chore: tâches d'outillage ou dépendances

Exemple :
```
feat(payouts): add PayoutsRepository with create/get
```

## Tests et qualité

- Écrivez des tests unitaires pour toute logique non triviale.
- Exécutez `flutter analyze` et `flutter test` avant de soumettre.
- Formatez le code avec `flutter format .`.

## Pull Requests

- Base de PR : branche `dev`.
- Décrivez le changement, ajoutez des captures d'écran si nécessaire.
- Ajoutez des tests pour les nouveaux comportements.
- Les PR doivent passer les checks CI (analyse + tests) avant d'être mergées.

## Revue

Les mainteneurs garderont les droits de merge. Les PR peuvent demander des modifications — merci d'y répondre rapidement.

## Traduction / documentation

Les docs peuvent être en anglais ou français; privilégiez l'anglais pour un public large, mais fournissez une section FR si utile.
