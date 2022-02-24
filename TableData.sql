USE DonoraDB
GO

-- INSERT Location Codes
-- DEPENDECIES: LocationCodes
INSERT INTO LocationCodes(codeID, [description]) VALUES('BDRIVE', 'A Rare Popup Blood Drive Location')
INSERT INTO LocationCodes(codeID, [description]) VALUES('DONORA', 'A Fixed Blood Donora Donor Location')
INSERT INTO LocationCodes(codeID, [description]) VALUES('CLINIC', 'A Private/Public Clinic That Accepts Donations')
INSERT INTO LocationCodes(codeID, [description]) VALUES('HOSPITAL', 'A Private/Public Hospital That Accepts Donations')
INSERT INTO LocationCodes(codeID, [description]) VALUES('ORG', 'A School/Office With Regular Blood Drives')
GO

-- INSERT Locations
-- DEPENDECIES: LocationCodes
INSERT INTO Locations(locationName, codeID, city) VALUES('BBD JHB Office', 'ORG', 'Killarney')
INSERT INTO Locations(locationName, codeID, city) VALUES('Nelson Mandela Square', 'BDRIVE', 'Sandton')
INSERT INTO Locations(locationName, codeID, city) VALUES('Chris Hani Baragwanath Academic Hospital', 'HOSPITAL', 'Soweto')
INSERT INTO Locations(locationName, codeID, city) VALUES('Musgrave Donor Centre', 'SANBS', 'Durban')
INSERT INTO Locations(locationName, codeID, city) VALUES('Claremont Clinic', 'CLINIC', 'Claremont')
INSERT INTO Locations(locationName, codeID, city) VALUES('Booth Memorial Hospital', 'HOSPITAL', 'Oranjezicht')
INSERT INTO Locations(locationName, codeID, city) VALUES('Levai Mbatha Community Health Center', 'CLINIC', 'Evaton')
INSERT INTO Locations(locationName, codeID, city) VALUES('Zola Clinic', 'CLINIC', 'Soweto')
INSERT INTO Locations(locationName, codeID, city) VALUES('Netcare Christaan Barnard Memorial Hospital', 'HOSPITAL', 'Foreshore')
INSERT INTO Locations(locationName, codeID, city) VALUES('Sebokeng Hospital', 'HOSPITAL', 'Sebokeng')
GO

-- INSERT Requests
-- DEPENDENCIES: Locations
INSERT INTO Request(locationID, bloodTypeRequested, amountRequestedML) VALUES(6, 'A+', 470)
INSERT INTO Request(locationID, bloodTypeRequested, amountRequestedML) VALUES(3, 'O+', 400)
INSERT INTO Request(locationID, bloodTypeRequested, amountRequestedML) VALUES(7, 'AB+', 12)
INSERT INTO Request(locationID, bloodTypeRequested, amountRequestedML) VALUES(5, 'B+', 99)
INSERT INTO Request(locationID, bloodTypeRequested, amountRequestedML) VALUES(4, 'A-', 3090)
INSERT INTO Request(locationID, bloodTypeRequested, amountRequestedML) VALUES(3, 'O-', 31)
INSERT INTO Request(locationID, bloodTypeRequested, amountRequestedML) VALUES(5, 'B-', 99)
INSERT INTO Request(locationID, bloodTypeRequested, amountRequestedML) VALUES(6, 'AB-', 3090)
INSERT INTO Request(locationID, bloodTypeRequested, amountRequestedML, dateReceived) VALUES(4, 'A-', 345, '2021-01-19')
GO

-- INSERT Inventory
-- DEPENDENCIES: BloodBag, Locations
INSERT INTO Inventory(bloodBagID, locationID, available) VALUES(1, 3, 1)
INSERT INTO Inventory(bloodBagID, locationID, available) VALUES(2, 9, 1)
INSERT INTO Inventory(bloodBagID, locationID, available) VALUES(3, 11, 1)
INSERT INTO Inventory(bloodBagID, locationID, available) VALUES(4, 5, 1)
INSERT INTO Inventory(bloodBagID, locationID, available) VALUES(5, 5, 1)
INSERT INTO Inventory(bloodBagID, locationID, available) VALUES(6, 5, 1)
INSERT INTO Inventory(bloodBagID, locationID, available) VALUES(7, 10, 1)
INSERT INTO Inventory(bloodBagID, locationID, available) VALUES(8, 4, 1)
INSERT INTO Inventory(bloodBagID, locationID, available) VALUES(9, 6, 1)
INSERT INTO Inventory(bloodBagID, locationID, available) VALUES(10, 6, 1)
INSERT INTO Inventory(bloodBagID, locationID, available) VALUES(11, 12, 1)
INSERT INTO Inventory(bloodBagID, locationID, available) VALUES(12, 3, 1)
INSERT INTO Inventory(bloodBagID, locationID, available) VALUES(13, 11, 1)
INSERT INTO Inventory(bloodBagID, locationID, available) VALUES(14, 10, 1)
INSERT INTO Inventory(bloodBagID, locationID, available) VALUES(15, 12, 1)
INSERT INTO Inventory(bloodBagID, locationID, available) VALUES(16, 8, 1)
INSERT INTO Inventory(bloodBagID, locationID, available) VALUES(17, 12, 1)
INSERT INTO Inventory(bloodBagID, locationID, available) VALUES(18, 7, 1)
INSERT INTO Inventory(bloodBagID, locationID, available) VALUES(19, 12, 1)
INSERT INTO Inventory(bloodBagID, locationID, available) VALUES(20, 9, 1)
GO