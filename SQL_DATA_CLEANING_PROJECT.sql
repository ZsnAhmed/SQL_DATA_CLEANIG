USE Portfoli_project;

--  CLEANING DATA IN SQL QUERIES  

SELECT * 
FROM Nashvillehousing;


SELECT CAST(SaleDate AS date)
FROM Nashvillehousing;

UPDATE Nashvillehousing
SET SaleDate = CONVERT(DATE, SaleDate) 

ALTER TABLE Nashvillehousing
ADD SaleDate2 date;

UPDATE Nashvillehousing
SET SaleDate2 = CONVERT(DATE, SaleDate) 

SELECT SaleDate, SaleDate2
FROM Nashvillehousing;

-- Popular property address data


SELECT PropertyAddress
FROM Nashvillehousing;

-- Checking null values 

--SELECT PropertyAddress
--FROM Nashvillehousing
--WHERE PropertyAddress is null

SELECT *
FROM Nashvillehousing
WHERE PropertyAddress is null

--SELECT *
--FROM Nashvillehousing
--ORDER BY ParcelID;




SELECT a.UniqueID , a.PropertyAddress, b.UniqueID , b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Nashvillehousing as a
join Nashvillehousing as b
on a.ParcelID = b.ParcelID
and a.UniqueID <>  b.UniqueID 
WHERE a.PropertyAddress is null;

-- Removing null values

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Nashvillehousing as a
join Nashvillehousing as b
on a.ParcelID = b.ParcelID
and a.UniqueID <>  b.UniqueID 
WHERE a.PropertyAddress is null;

-- Updation done 

-- Now breaking out address into Individual colomns (Adress, City, State)

-- Checking out the property address Column

SELECT PropertyAddress 
FROM Nashvillehousing;


-- Seperating address
SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 )
FROM Nashvillehousing


-- Seperating city 

SELECT SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1,len(propertyaddress))
FROM Nashvillehousing;

-- Altering and Updating the table 

Alter table Nashvillehousing
add propertyaddreSplit NVARCHAR(250)

UPDATE Nashvillehousing
SET propertyaddreSplit = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 )


Alter table Nashvillehousing
add propertyCitySplit NVARCHAR(250)

UPDATE Nashvillehousing
SET propertyCitySplit = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1,len(propertyaddress))


-- Checkin the ownerAddress

SELECT ownerAddress
FROM Nashvillehousing
order by ownerAddress desc;


-- Splitting the address

SELECT PARSENAME(REPLACE(OwnerAddress,',','.'),3),
 PARSENAME(REPLACE(OwnerAddress,',','.'),2)
, PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM Nashvillehousing

-- Altering the table and adding columns 

Alter table Nashvillehousing
add OwneraddreSplit NVARCHAR(250)

UPDATE Nashvillehousing
SET OwneraddreSplit = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter table Nashvillehousing
add OwnerSplitCity NVARCHAR(250)

UPDATE Nashvillehousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Alter table Nashvillehousing
add OwnerSplitState NVARCHAR(250)

UPDATE Nashvillehousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

-- Checking the data again 

SELECT *
FROM Nashvillehousing;


-- Checking the Sold as vacant column 

SELECT distinct(SoldasVacant), count(SoldAsVacant)
From Nashvillehousing
Group By SoldAsVacant
Order By 2;


-- Changing y and n to Yes and No in Sold as vacant column 

SELECT SoldAsVacant,
CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
	END
From Nashvillehousing

UPDATE Nashvillehousing
SET SoldAsVacant = CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
	END

--Removind duplicates

SELECT *,
ROW_NUMBER() OVER (PARTITION BY parcelID,
								PropertyAddress,
								SalePrice,
								SaleDate,
								LegalReference
								ORDER BY 
								uniqueID) as row_num
FROM Nashvillehousing;


-- By using CTE

WITH row_numCTE as (SELECT *,
ROW_NUMBER() OVER (PARTITION BY parcelID,
								PropertyAddress,
								SalePrice,
								SaleDate,
								LegalReference
								ORDER BY 
								uniqueID) as row_num
FROM Nashvillehousing
) 
select *
FROM row_numCTE
where row_num > 1
ORDER BY PropertyAddress;


--- Deleting Duplicates 


WITH row_numCTE as (SELECT *,
ROW_NUMBER() OVER (PARTITION BY parcelID,
								PropertyAddress,
								SalePrice,
								SaleDate,
								LegalReference
								ORDER BY 
								uniqueID) as row_num
FROM Nashvillehousing
) 
DELETE
FROM row_numCTE
where row_num > 1
;

-- Deleting Unused columns;

SELECT * 
FROM Nashvillehousing;

ALTER TABLE Nashvillehousing 
DROP COLUMN PropertyAddress, TaxDistrict,OwnerAddress;


ALTER TABLE Nashvillehousing 
DROP COLUMN SaleDate;





