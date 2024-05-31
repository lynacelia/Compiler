Compilateur Flex/Bison
Ce projet est un compilateur complet implémenté à l'aide des outils Flex et Bison. Il réalise une analyse lexicale, syntaxique et sémantique, génère des quadruplets, effectue une optimisation, puis génère du code objet.

Fonctionnalités
Analyse Lexicale et Syntaxique : Utilisation de Flex pour l'analyse lexicale et de Bison pour l'analyse syntaxique afin de décomposer le code source en tokens et d'en construire un arbre syntaxique.
Analyse Sémantique : Vérification de la cohérence sémantique du code en effectuant des analyses telles que la vérification des types et la gestion des portées.
Génération de Quadruplets : Construction de quadruplets représentant des opérations intermédiaires pour le code source.
Optimisation : Application de techniques d'optimisation pour améliorer l'efficacité du code généré, telles que la réduction de la complexité des expressions ou la suppression de code mort.
Génération de Code Objet : Transformation des quadruplets optimisés en code assembleur ou en code machine pour la plate-forme cible.
