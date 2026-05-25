# 📊 Analyse Massive de Données RH & Optimisation Budgétaire (SQL)

## 📌 Présentation du Projet
Ce projet consiste à analyser une base de données de plus de 300 000 employés et 4 millions de lignes de salaires (Base de données `Employees` de MySQL). L'objectif est d'extraire des insights stratégiques pour la direction des Ressources Humaines et d'identifier les dynamiques salariales de l'entreprise.

### 🛠️ Compétences Techniques Validées
* **SGBD :** MySQL (Environnement XAMPP)
* **Concepts avancés :** Common Table Expressions (CTE), Fonctions de fenêtrage (`DENSE_RANK`, `LAG`), Joignures multiples, Fonctions d'agrégation.

---

## 🔍 Études de Cas & Requêtes Clés

### 1. Classement des 3 plus gros salaires par Département
**Objectif :** Identifier les talents les mieux rémunérés au sein de chaque pôle actuel pour auditer la politique salariale.

```sql
WITH SalaireClasse AS (
    SELECT 
        d.dept_name AS Departement,
        e.first_name AS Prenom,
        e.last_name AS Nom,
        s.salary AS Salaire,
        DENSE_RANK() OVER (PARTITION BY d.dept_no ORDER BY s.salary DESC) AS Rang
    FROM employees e
    INNER JOIN dept_emp de ON e.emp_no = de.emp_no
    INNER JOIN departments d ON de.dept_no = d.dept_no
    INNER JOIN salaries s ON e.emp_no = s.emp_no
    WHERE s.to_date = '9999-01-01' AND de.to_date = '9999-01-01'
)
SELECT Departement, Prenom, Nom, Salaire, Rang
FROM SalaireClasse
WHERE Rang <= 3
ORDER BY Departement ASC, Rang ASC;

## resultat_requete_1.png

### 2. Analyse Temporelle et Croissance de la Masse Salariale
Objectif : Mesurer l'évolution du salaire moyen global année après année et calculer son taux de croissance.

WITH EvolutionSalaires AS (
    SELECT YEAR(s.from_date) AS Annee, ROUND(AVG(s.salary), 2) AS Salaire_Moyen
    FROM salaries s
    GROUP BY YEAR(s.from_date)
)
SELECT 
    Annee,
    Salaire_Moyen,
    LAG(Salaire_Moyen, 1) OVER (ORDER BY Annee) AS Salaire_Moyen_Annee_Precedente,
    ROUND(((Salaire_Moyen - LAG(Salaire_Moyen, 1) OVER (ORDER BY Annee)) / LAG(Salaire_Moyen, 1) OVER (ORDER BY Annee)) * 100, 2) AS Taux_Croissance_Pourcent
FROM EvolutionSalaires
ORDER BY Annee ASC;

## resultat_requete_2.png

## Grâce à cette analyse SQL sur grand volume de données, la direction dispose d'une cartographie claire des coûts RH. Ce projet démontre ma capacité à manipuler des millions de lignes pour transformer de la donnée brute en indicateurs d'aide à la décision.
