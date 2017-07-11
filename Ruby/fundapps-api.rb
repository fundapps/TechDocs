require 'RestClient'
require 'Oga'
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
# puts fundapps_api.xsd

class FundAppsAPI
  def initialize(endpoint:, username:, password:)
    @endpoint_root = endpoint
    @username = username
    @password = password
    @content_types = {
      '.csv' => 'text/csv',
      '.xls' => 'application/vnd.ms-excel',
      '.xlsx' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      '.xml' => 'application/xml',
      '.zip' => 'application/zip'
    }
  end

  def import_positions(file:)
    post '/v1/expost/check', file
  end

  def import_index_data(file:)
    post '/v1/indexdata/import', file
  end

  def import_portfolios(file:)
    post '/v1/portfolios/import', file
  end

  def xsd
    get '/v1/expost/xsd'
  end

  private

  def post(endpoint, file)
    url = @endpoint_root + endpoint
    extension = File.extname(file)
    puts 'Unrecognized file type' unless @content_types.include?(extension)

    response = RestClient::Request.execute(method: :post,
                                           url: url,
                                           user: @username,
                                           password: @password,
                                           payload: File.read(file),
                                           headers: { :content_type => @content_types[extension], :'x-contentname' => File.basename(file) })
    wait_for_expost_result(response) if endpoint == '/v1/expost/check'
  rescue RestClient::ExceptionWithResponse => e
    puts e
    puts "Failed to send file to FundApps. Received a #{e.http_code} HTTP response from #{url}"
  end

  def get(endpoint)
    url = @endpoint_root + endpoint
    response = RestClient::Request.execute(method: :get,
                                           url: url,
                                           user: @username,
                                           password: @password)
  rescue RestClient::ExceptionWithResponse => e
    puts "Failed to make request. Received a #{e.http_code} HTTP response from #{url}"
  end

  def wait_for_expost_result(response)
    result_url = Oga.parse_xml(response).xpath('//links/result').first.text
    done = false
    result_status = {}
    until done
      result_status = Oga.parse_xml(get(result_url))
      results_snapshot = result_status.xpath('/ResultsSnapshot').first
      results_snapshot.attributes.each do |attribute|
        result_status[attribute.name.to_sym] = attribute.value
      end
      done = true if result_status[:PipelineStage] == 'Finished'
    end
    puts response.colorize(:red) if result_status[:Status] == 'ValidationFailed'
  end
end
