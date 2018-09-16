Bundler.require(:default)

get '/location' do
  container = Dry::Container.new
  container.register(:location) { Location.new(request.location) }
  container.resolve(:location).show
end

class Location
  attr_reader :ipaddr, :lat, :lon, :city, :region, :country

  def initialize(location)
    @ipaddr = location.data['ip']
    @lat, @len = location.data['loc']&.split(',')
    @city = location.data['city']
    @region = location.data['region']
    @country = location.data['country']
  end

  def show
    location = [city, region, country].compact.reject(&:empty?).join(', ')
    "#{ipaddr}: #{location}"
  end
end