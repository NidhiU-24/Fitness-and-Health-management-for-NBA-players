use nba;

#1.	Simple query: Basic information about players

SELECT Player_ID, Player_Name, Height, Weight, Position
FROM Players;

#2.	Aggregate: Calculate the Total Number of Games Played by Position

SELECT Position, SUM(Games_Played) AS Total_Games_Played
FROM Players
GROUP BY Position;

#3. Join: List physios and the total number of treatments they've provided, ordered by the number of treatments in descending order

SELECT Physio.Name AS Physio_Name, COUNT(Physio_Treatment.Player_ID) AS Total_Treatments
FROM Physio
RIGHT JOIN Physio_Treatment ON Physio.Physio_ID = Physio_Treatment.Physio_ID
GROUP BY Physio.Name
HAVING Total_Treatments IS NOT NULL
ORDER BY Total_Treatments DESC
LIMIT 15;

#4.	Nested query: Identify players who have consulted with a doctor and retrieves their names.

SELECT Player_Name
FROM Players
WHERE Player_ID IN (
    SELECT DISTINCT Player_ID
    FROM Doctor_Consultation);

#5.	Correlated: Identify players who have performed above the average for their specific position

SELECT Player_ID, Player_Name, Goals_Scored, Position
FROM Players p1
WHERE Goals_Scored > (
    SELECT AVG(Goals_Scored)
    FROM Players p2
    WHERE p2.Position = p1.Position);


#6.	Exist: Players who have both a diet plan and a workout plan
SELECT Player_Name
FROM Players
WHERE EXISTS (
 SELECT 1
 FROM Dietitian
 WHERE Dietitian.Player_ID = Players.Player_ID
) AND EXISTS (
 SELECT 1
 FROM Players
 WHERE Workout_Plan IS NOT NULL
)LIMIT 15;

#7.	Set operations union: Retrieve Player Names and Doctor Names with a Common Prefix

SELECT CONCAT('Player: ', Player_Name) AS Name
FROM Players
UNION
SELECT CONCAT('Doctor: ', Name)
FROM Doctors;


#8.	Subqueries in select clause: Retrieve Player Names along with the Average Goals Scored to give the goals percentage


SELECT Player_ID, Player_Name, Goals_Scored, (Goals_Scored / (SELECT AVG(Games_Played) FROM Players)) * 100 AS GoalsPercentage
FROM Players;

#9.	ANY: Retrieve Players with Goals Scored Greater Than the Highest Average Goals in Any Position

SELECT Player_ID, Player_Name, Goals_Scored
FROM Players
WHERE Goals_Scored > ANY (
    SELECT MAX(AvgGoalsPerPosition)
    FROM (
        SELECT AVG(Goals_Scored) AS AvgGoalsPerPosition
        FROM Players
        GROUP BY Position
    ) subquery
);

#10.	Create View: View to show doctors and players they have consulted with

CREATE VIEW DoctorConsultationView AS
SELECT Doctors.Name AS Doctor_Name, Players.Player_Name
FROM Doctors
INNER JOIN Doctor_Consultation ON Doctors.Doctor_ID = Doctor_Consultation.Doctor_ID
INNER JOIN Players ON Doctor_Consultation.Player_ID = Players.Player_ID;

SELECT * FROM DoctorConsultationView LIMIT 25;

