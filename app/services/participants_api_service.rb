class ParticipantsApiService
  BASE_URL = "http://localhost:3000/api/v1/events"


  def self.get_feedbacks_by_event_code(event_code)
    self.request("#{BASE_URL}/#{event_code}/feedbacks", :get)
  end

  def self.request(url, method)
    conn = Faraday.new do |faraday|
      faraday.response :raise_error
    end
    JSON.parse(conn.send(method, url).body, symbolize_names: true)
  rescue Faraday::Error => e
    raise e
  end
end
