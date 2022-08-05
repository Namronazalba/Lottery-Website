class PhLocationService
  attr_reader :url

  def initialize
    @url = 'https://psgc.gitlab.io/api'
  end

  def get_regions
    response = RestClient.get("#{url}/regions")
    regions = JSON.parse(response.body)
    regions.each do |region|
      Region.find_or_create_by(code: region['code'], name: region['name'], region_name: region['regionName'])
    end
  end

  def get_provinces
    response = RestClient.get("#{url}/provinces")
    provinces = JSON.parse(response.body)
    provinces.each do |province|
      region = Region.find_by_code(province['regionCode'])
      Province.find_or_create_by(code: province['code'], name: province['name'], region: region)
    end
  end

  def get_districts
    response = RestClient.get("#{url}/districts")
    districts = JSON.parse(response.body)
    districts.each do |district|
      region = Region.find_by_code(district['regionCode'])
      District.find_or_create_by(code: district['code'], name: district['name'], region: region)
    end
  end

  def get_cities
    response = RestClient.get("#{url}/cities")
    cities = JSON.parse(response.body)
    cities.each do |city|
      district = District.find_by_code(city['districtCode'])
      City.find_or_create_by(code: city['code'], name: city['name'], district: district)
    end
  end

  def get_municipalities
    response = RestClient.get("#{url}/municipalities")
    municipalities = JSON.parse(response.body)
    municipalities.each do |municipality|
      province = Province.find_by_code(municipality['provinceCode'])
      Municipality.find_or_create_by(code: municipality['code'], name: municipality['name'], province: province)
    end
  end

  def get_barangays
    response = RestClient.get("#{url}/barangays")
    barangays = JSON.parse(response.body)
    barangays.each do |barangay|
      city = City.find_by_code(barangay['cityCode'])
      municipality = Municipality.find_by_code(barangay['municipalityCode'])
      Barangay.find_or_create_by(code: barangay['code'], name: barangay['name'], municipality: municipality,city: city)
    end
  end
end

# def get_barangays
#   response = RestClient.get("#{url}/barangays")
#   barangays = JSON.parse(response.body)
#   barangays.each do |barangay|
#     if barangay['municipalityCode']
#       municipality = Municipality.find_by_code(barangay['municipalityCode'])
#       Barangay.find_or_create_by(code: barangay['code'], name: barangay['name'], municipality: municipality)
#     else
#       city = City.find_by_code(barangay['cityCode'])
#       Barangay.find_or_create_by(code: barangay['code'], name: barangay['name'], city: city)
#     end
#   end
# end
