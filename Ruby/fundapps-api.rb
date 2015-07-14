require 'RestClient'
require 'Oga'
require 'mime/types'
require 'colorize'

# FundApps Example Ruby API Integration
#
# Usage:
# ... (run 'bundle install' to restore gems from Gemfile) ...
#
# fundapps_api = FundAppsAPI.new endpoint: "http://rapptr.local:38727", username: 'jsimpson', password: 'newuser'
# fundapps_api.import_positions file: 'SamplePositions_Simple.zip'
# fundapps_api.import_positions_and_get_result file: 'Disclosure_US_1Day.zip'
# fundapps_api.import_index_data file: 'Indices.csv'
# fundapps_api.import_portfolios file: 'Portfolios.csv'

class FundAppsAPI
  def initialize (endpoint:, username:, password:)
    @endpoint_root = endpoint
    @username = username
    @password = password
  end

  def import_positions (file:) post "/v1/expost/check", file end
  def import_index_data (file:) post "/v1/indexdata/import", file end
  def import_portfolios (file:) post "/v1/portfolios/import", file end  

  private

  def post (endpoint, file)
    url = @endpoint_root + endpoint
    response = RestClient::Request.execute(:method => :post,
      :url => url,
      :user => @username,
      :password => @password,
      :payload => File.read(file),
      :headers => { :content_type => MIME::Types.type_for(File.extname(file)).first }
    )
    wait_for_expost_result(response)
    rescue RestClient::ExceptionWithResponse => e
      puts "Failed to send file to FundApps. Received a #{e.http_code} HTTP response from #{url}"
  end
  
  def get (endpoint)
    url = @endpoint_root + endpoint
    response = RestClient::Request.execute(:method => :get,
      :url => url,
      :user => @username,
      :password => @password
    )
    rescue RestClient::ExceptionWithResponse => e
      puts "Failed to make request. Received a #{e.http_code} HTTP response from #{url}"
  end
  
  def wait_for_expost_result (response)
    result_url = Oga.parse_xml(response).xpath('//links/result').first.text
    done = false
    result_status = {}
    while not done
      result_status = Oga.parse_xml(get(result_url))
      results_snapshot = result_status.xpath('/ResultsSnapshot').first
      results_snapshot.attributes.each do |attribute|
        result_status[attribute.name.to_sym] = attribute.value
      end
      done = true if result_status[:PipelineStage] == "Finished"
    end
    if result_status[:Status] == "ValidationFailed"
      puts response.colorize(:red)
  end
end