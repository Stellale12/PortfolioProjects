SELECT TOP (20) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [Portfolio Project].[dbo].[NashvilleHousing]
  
  --Populate Property Address Data
  Select *
  From [Portfolio Project]..[NashvilleHousing]
  --Where PropertyAddress is Null
  Order by ParcelID

  Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
  From [Portfolio Project]..[NashvilleHousing] a
  Join [Portfolio Project]..[NashvilleHousing] b
  on a.ParcelID = b.ParcelID
  and a.UniqueID <> b.UniqueID
    Where a.PropertyAddress is null

    --Interesting query for cleaning
Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project]..[NashvilleHousing] a
  Join [Portfolio Project]..[NashvilleHousing] b
  on a.ParcelID = b.ParcelID
  and a.UniqueID <> b.UniqueID
  Where a.PropertyAddress is null

  --Breaking out address into individual columns (address, city, state)
  Select PropertyAddress
  fROM [Portfolio Project]..[NashvilleHousing]

  SELECT *
FROM [Portfolio Project]..[NashvilleHousing]

  Select 
  SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) as Address,
  SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress)) as Address
  --Charindex (',',propertyaddress) -> result is number, where is ,)
  From [Portfolio Project]..[NashvilleHousing]


  Alter Table [Portfolio Project]..[NashvilleHousing]
  Add PropertySplitAddress Nvarchar(255)

  Update [Portfolio Project]..[NashvilleHousing]
  Set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1)
  
  Alter Table [Portfolio Project]..[NashvilleHousing]
  Add PropertySplitCity Nvarchar(255)

  Update [Portfolio Project]..[NashvilleHousing]
  Set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress))

  Select*
  From [Portfolio Project]..[NashvilleHousing]

  Select OwnerAddress
  From [Portfolio Project]..[NashvilleHousing]

  Select PARSENAME(replace(OwnerAddress,',','.'),3),
  PARSENAME(replace(OwnerAddress,',','.'),2),
  PARSENAME(replace(OwnerAddress,',','.'),1)
  From [Portfolio Project]..[NashvilleHousing]

   Alter Table [Portfolio Project]..[NashvilleHousing]
  Add OwnerSplitAddress Nvarchar(255)

  Update [Portfolio Project]..[NashvilleHousing]
  Set OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.'),3)

   Alter Table [Portfolio Project]..[NashvilleHousing]
  Add OwnerSplitCity Nvarchar(255)

  Update [Portfolio Project]..[NashvilleHousing]
  Set OwnerSplitCity = PARSENAME(replace(OwnerAddress,',','.'),2)

   Alter Table [Portfolio Project]..[NashvilleHousing]
  Add OwnerSplitState Nvarchar(255)

  Update [Portfolio Project]..[NashvilleHousing]
  Set OwnerSplitState = PARSENAME(replace(OwnerAddress,',','.'),1)

  Select*
  From [Portfolio Project]..[NashvilleHousing]

  --Change Y and N to Yes and No in 'Sold as vacant' field

  Select Distinct(soldasVacant), count(soldasvacant)
  From [Portfolio Project]..[NashvilleHousing]
  Group By SoldasVacant
  Order By 2

    Select soldasVacant,
    Case when SoldasVacant = 1 then 'Yes'
    when SoldasVacant = 0 then 'No'
    Else 'SoldasVacant'
    End
  From [Portfolio Project]..[NashvilleHousing]

  ALTER TABLE [Portfolio Project]..[NashvilleHousing]
ALTER COLUMN SoldasVacant VARCHAR(3);

  Update[Portfolio Project]..[NashvilleHousing]
  Set SoldasVacant = Case when SoldasVacant = 1 then 'Yes'
    when SoldasVacant = 0 then 'No'
    Else 'SoldasVacant'
    End
  
  --Remove duplicate
  With RownumCTE AS(
  Select*, ROW_NUMBER () Over(
  Partition By ParceLID,
  PropertyAddress,
  SalePrice,
  SaleDate,
  LegalReference
  Order BY
  UniqueID) As row_num
  fROM[Portfolio Project]..[NashvilleHousing]
  --Order By ParceLID
  )
  Select*
  --Delete
  From RownumCTE
  Where row_num>1
  --Order By PropertyAddress

  --Delete Unused Columns
  Select*
  From [Portfolio Project]..Nashvillehousing

  Alter Table [Portfolio Project]..Nashvillehousing
  Drop Column OwnerAddress, TaxDistrict, PropertyAddress

   Alter Table [Portfolio Project]..Nashvillehousing
  Drop Column SaleDate