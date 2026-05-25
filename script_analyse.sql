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
    WHERE s.to_date = '9999-01-01'  -- Isoler le salaire ACTUEL
      AND de.to_date = '9999-01-01' -- Isoler le département ACTUEL
)
SELECT 
    Departement,
    Prenom,
    Nom,
    Salaire,
    Rang
FROM SalaireClasse
WHERE Rang <= 3
ORDER BY Departement ASC, Rang ASC;


WITH EvolutionSalaires AS (
    SELECT 
        YEAR(s.from_date) AS Annee,
        ROUND(AVG(s.salary), 2) AS Salaire_Moyen
    FROM salaries s
    GROUP BY YEAR(s.from_date)
)
SELECT 
    Annee,
    Salaire_Moyen,
    -- Récupère le salaire moyen de l'année précédente
    LAG(Salaire_Moyen, 1) OVER (ORDER BY Annee) AS Salaire_Moyen_Annee_Precedente,
    -- Calcule le pourcentage de croissance
    ROUND(
        ((Salaire_Moyen - LAG(Salaire_Moyen, 1) OVER (ORDER BY Annee)) 
        / LAG(Salaire_Moyen, 1) OVER (ORDER BY Annee)) * 100, 2
    ) AS Taux_Croissance_Pourcent
FROM EvolutionSalaires
ORDER BY Annee ASC;
