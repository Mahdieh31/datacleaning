/*
Cleaning data in SQL queries

*/
select *
from PortfolioProject.dbo.NashwilHousing

-- standardize date format

select saledateconverted2, CONVERT(date,saledate)
from PortfolioProject..NashwilHousing

Alter table NashwilHousing
add saledateconverted2 date;

update NashwilHousing
set saledateconverted2=CONVERT(date,saledate)
 

 -------------------------------------------------------------------------------------------------

 -- populated property address data

 select *
 from PortfolioProject..NashwilHousing
 where PropertyAddress is null
 order by ParcelID;

 select a.ParcelID, a. PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a. PropertyAddress,b.PropertyAddress)
 from PortfolioProject..NashwilHousing as a
 join PortfolioProject..NashwilHousing as b
 on a.ParcelID=b.ParcelID 
 and a.[UniqueID ]<>b.[UniqueID ]
 where a.PropertyAddress is null;


 update a
 set a.PropertyAddress=isnull(a. PropertyAddress,b.PropertyAddress)
  from PortfolioProject..NashwilHousing as a
 join PortfolioProject..NashwilHousing as b
 on a.ParcelID=b.ParcelID 
 and a.[UniqueID ]<>b.[UniqueID ]
 where a.PropertyAddress is null;

 -------------------------------------------

 --breaking out address into individual columns(address, city, state)

 select PropertyAddress
 from PortfolioProject..NashwilHousing;


 select
 SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address,
  SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(propertyaddress)) as city
 from PortfolioProject..NashwilHousing

 Alter table NashwilHousing
 add propertyaddresssplit nvarchar(255);

 update NashwilHousing
 set  propertyaddresssplit=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1);

 
 Alter table NashwilHousing
 add propertycitysplit nvarchar(255);

 update NashwilHousing
 set  propertycitysplit=SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(propertyaddress));

 select *
 from PortfolioProject..NashwilHousing;


  select OwnerAddress
 from PortfolioProject..NashwilHousing;

 select
 PARSENAME(replace(owneraddress,',','.'),1) as state,
 PARSENAME(replace(owneraddress,',','.'),2) as city,
 PARSENAME(replace(owneraddress,',','.'),3) as address
 from PortfolioProject..NashwilHousing;

 Alter table NashwilHousing
 add owneraddresssplit nvarchar(255);

  update NashwilHousing
 set owneraddresssplit=PARSENAME(replace(owneraddress,',','.'),3) 

  Alter table NashwilHousing
 add ownercitysplit2 nvarchar(255);
  update NashwilHousing
 set ownercitysplit2=PARSENAME(replace(owneraddress,',','.'),2)

 Alter table NashwilHousing
 add ownerstatesplit nvarchar(255);
  update NashwilHousing
 set ownerstatesplit=PARSENAME(replace(owneraddress,',','.'),1)

  select *
 from PortfolioProject..NashwilHousing;

------------------------------------------------------------------------------------------------------------------------------
--change Y and N to yes and No in "sold as vacant" field

select distinct soldasvacant,COUNT(soldasvacant)
 from PortfolioProject..NashwilHousing
 group by SoldAsVacant
 order by 2;

 select SoldAsVacant,
 case
	when SoldAsVacant='N' then 'No'
	when SoldAsVacant='Y' then 'Yes'
	else SoldAsVacant
end
 from PortfolioProject..NashwilHousing;

 update NashwilHousing
 set SoldAsVacant=case
	when SoldAsVacant='N' then 'No'
	when SoldAsVacant='Y' then 'Yes'
	else SoldAsVacant
end;



----------------------------------------------------------------
-- Remove Duplicates
with rownumCTE as(
select *, ROW_NUMBER() over (partition by parcelid, propertyaddress, saleprice,saledate,legalreference order by uniqueid) as row_num 
 from PortfolioProject..NashwilHousing)
select*
 from rownumCTE
 where row_num>1


 ---------------------------------------------------------------
 -- Remove Unused Columns

 ALTER TABLE PortfolioProject..NashwilHousing
 DROP COLUMN owneraddress,taxdistrict, propertyaddress,saledate
 
 select *
 from PortfolioProject..NashwilHousing;