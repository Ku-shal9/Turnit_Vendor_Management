CREATE database turnit;

USE turnit;

CREATE TABLE Address(
AddressID INT AUTO_INCREMENT PRIMARY KEY,
Country VARCHAR (255),
ZipCode INT,
Province VARCHAR(255),
City VARCHAR (255)
);

CREATE TABLE Vendor(
VendorID INT AUTO_INCREMENT PRIMARY KEY,
Name VARCHAR (255),
Email VARCHAR (255),
HiredDate DATE,
StatusVendor VARCHAR (255),
AddressID INT, 
FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
);

CREATE TABLE Property(
PropertyID INT AUTO_INCREMENT PRIMARY KEY,
OwnerName VARCHAR(255)
);

CREATE TABLE Jobs(
JobID INT AUTO_INCREMENT PRIMARY KEY,
VendorID INT,
JobType VARCHAR (255),
StatusJob VARCHAR(255),
PropertyID INT,
StartDate DATE,
EndDate DATE,
FOREIGN KEY (VendorID) REFERENCES Vendor(VendorID),
FOREIGN KEY (PropertyID) REFERENCES Property (PropertyID)
);
CREATE TABLE PaymentMethod (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    JobID INT UNIQUE,  -- one-to-one relationship
    AmountPaid  DECIMAL(10, 2),
    PaymentStatus BOOL,
    PaymentDate DATE,
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID)
);
CREATE TABLE Price (
    JobID INT AUTO_INCREMENT PRIMARY KEY,  -- one-to-one relationship
    HourlyRate DECIMAL(10, 2),
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID)
);

CREATE TABLE Feedback (
    FeedbackID INT AUTO_INCREMENT PRIMARY KEY,
    JobID INT,
    Rating FLOAT,
    Timeliness BOOLEAN,
    PropertyID INT,
    TimeStamp DATETIME,
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID),
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID)
);

CREATE TABLE Complaints (
    TagID INT AUTO_INCREMENT PRIMARY KEY,
    FeedbackID INT,
    ComplaintTags VARCHAR(255),
    FOREIGN KEY (FeedbackID) REFERENCES Feedback(FeedbackID)
);

DROP VIEW VendorPerformance;
CREATE VIEW ScoreCard AS
SELECT
    v.VendorID, v.Name,
    -- Average Rating
    ROUND(AVG(f.Rating), 2) AS AverageRating,
    -- Count of Tags for all complaints related to this vendor's jobs
    COUNT(c.TagID) AS TagsCount,
    -- Timeliness Percentage (only for completed jobs)
    100.0 * SUM(CASE WHEN f.Timeliness = 1 THEN 1 ELSE 0 END) / 
        NULLIF(COUNT(f.Timeliness), 0) AS TimelinessPercentage,
    -- Total working period in months across all completed jobs
    ROUND(SUM(DATEDIFF(j.EndDate, j.StartDate) / 30.0), 2) AS TotalWorkingPeriod
FROM Vendor v
-- Join only completed Jobs to Vendor
LEFT JOIN Jobs j ON v.VendorID = j.VendorID AND j.StatusJob = 'Completed'
-- Join Feedback to Jobs
LEFT JOIN Feedback f ON j.JobID = f.JobID
-- Join Complaints to Feedback
LEFT JOIN Complaints c ON f.FeedbackID = c.FeedbackID
GROUP BY v.VendorID;

CREATE VIEW StatusofJob AS
SELECT v.VendorID, v.Name, j.StatusJob, 
j.JobType, j.PropertyID FROM Vendor v
JOIN Jobs j ON v.VendorID = j.VendorID
WHERE StatusJob = "Completed";

-- CRUD OPEARTIONS
-- CREATE:
INSERT INTO
    Address (Country, ZipCode, Province, City)
VALUES
    ('Nepal', 44700, 'Lumbini', 'Butwal');

-- Insert into Vendor 
INSERT INTO
    Vendor (Name, Email, HiredDate, StatusVendor, AddressID)
VALUES
    ('Krishna Thapa', 'krishna@build.com', '2025-06-20', 'Active', 31);
-- Insert into Property
INSERT INTO
    Property (OwnerName)
VALUES
    ('Binita Karki');
-- Insert into Jobs 
INSERT INTO
    Jobs ( VendorID, JobType, StatusJob, PropertyID, StartDate, EndDate)
VALUES
    (31, 'Painting', 'In Progress', 31, '2025-06-10', '2025-06-12' );
-- Insert into PaymentMethod 
INSERT INTO
    PaymentMethod (JobID, AmountPaid, PaymentStatus, PaymentDate)
VALUES
    (31, 1800.00, 1, '2025-06-13');
-- Insert into Price
INSERT INTO
    Price (JobID, HourlyRate)
VALUES
    (31, 250.00);
-- Insert into Feedback 
INSERT INTO
    Feedback (JobID, Rating, Timeliness, PropertyID, TimeStamp)
VALUES
    (31, 4.7, 1, 31, NOW());
-- Insert into Complaints 
INSERT INTO
    Complaints (FeedbackID, ComplaintTags)
VALUES
    (31, NULL);
-- READ
-- Seeing information of Vendor with VendorID 9
SELECT * FROM vendor_with_vendorid_9;
-- Seeing this Vendor's Information on Job and the person he is hired by

SELECT * FROM vendor_with_vendorid_9_further_information;

-- Selecting Vendors who have completed the assigned job
SELECT * FROM statusofjob;
SELECT * FROM ScoreCard;
-- Updating
-- If VendorID 9 completes his job
UPDATE Jobs SET
    StatusJob = 'Inactive'
WHERE
    JobID = 10;

UPDATE paymentmethod SET
    PaymentStatus = 1
WHERE
    PaymentID = 10;

-- Seeing the Changes
SELECT
    j.StatusJob,
    p.PaymentStatus
FROM
    Jobs j
    JOIN PaymentMethod p ON j.JobID = p.JobID
WHERE
    j.JobID = 10;

-- Deleting
-- Delete complaint for FeedbackID = 12
DELETE FROM
    Complaints
WHERE
    FeedbackID = 11;

-- Delete feedback (only after deleting complaints)
DELETE FROM
    Feedback
WHERE
    FeedbackID = 11;

SELECT
    f.Rating,
    c.ComplaintTags
FROM
    feedback f
    JOIN complaints c ON f.FeedbackID = c.FeedbackID
WHERE
    f.FeedbackID = 12;

