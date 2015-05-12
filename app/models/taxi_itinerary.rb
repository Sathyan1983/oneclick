class TaxiItinerary < Itinerary

  def self.get_taxi_itineraries(from, to, trip_datetime)

    itineraries = []

    taxi_mode = Mode.find_by_code("mode_taxi")
    taxi_services = Service.where("mode_id = ?", taxi_mode.id)

    user = User.find(1)

    api_key = Oneclick::Application.config.taxi_fare_finder_api_key

    taxi_services.each do |taxi_service|
      if (taxi_service.is_valid_for_trip_area(from, to) && taxi_service.can_provide_user_accommodations(user, taxi_service))
        city = taxi_service.taxi_fare_finder_city
        results = TaxiRestService.call_out_to_taxi_fare_finder(city, api_key, from, to)
        itineraries.push(Itinerary.new(results))
      end
    end
    
    return itineraries

  end

end