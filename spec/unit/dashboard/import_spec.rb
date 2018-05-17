require 'lkr/commands/dashboard/import'

RSpec.describe Lkr::Commands::Dashboard::Import do
  it "executes `import` command successfully" do
    require 'sawyer'
    me_response_doc = { :id=>1000, :first_name=>"John", :last_name=>"Jones", :email=>"jjones@example.com" }
    mock_me_response = double(Sawyer::Resource, me_response_doc)
    allow(mock_me_response).to receive(:to_attrs).and_return(me_response_doc)

    dash_response_doc = {
      :id=>555,
      :title=>"New Dash",
      :description=> "Description of the Dash",
      :dashboard_filters=>[],
      :dashboard_elements=>[],
      :dashboard_layouts=>[]
    }
    mock_dash_response = double(Sawyer::Resource, dash_response_doc)
    allow(mock_dash_response).to receive(:to_attrs).and_return(dash_response_doc)

    mock_sdk = Object.new
    mock_sdk.define_singleton_method(:authenticated?) { true }
    mock_sdk.define_singleton_method(:logout) { }
    mock_sdk.define_singleton_method(:me) do |req|
      return mock_me_response
    end
    mock_sdk.define_singleton_method(:search_dashboards) do |req|
      return []
    end
    mock_sdk.define_singleton_method(:operations) do 
      { "create_dashboard"=>
        {
          :info=>{
            :parameters=>[
              {
                :in=>"body",
                :schema=>{ :$ref=>"#/definitions/Dashboard" }
              }
            ]
          }
        }
      }
    end
    mock_sdk.define_singleton_method(:swagger) do 
      JSON.parse <<-SWAGGER, {:symbolize_names => true}
      { "definitions": {
        "Dashboard": {
            "properties": {
              "title": {
                "type": "string",
                "description": "Look Title",
                "x-looker-nullable": true
              },
              "description": {
                "type": "string",
                "description": "Description",
                "x-looker-nullable": true
              },
              "hidden": {
                "type": "boolean",
                "description": "Is Hidden",
                "x-looker-nullable": false
              },
              "refresh_interval": {
                "type": "string",
                "description": "Refresh Interval",
                "x-looker-nullable": true
              },
              "load_configuration": {
                "type": "string",
                "x-looker-nullable": true
              },
              "space_id": {
                "type": "string",
                "description": "Id of Space",
                "x-looker-nullable": true
              },
              "show_title": {
                "type": "boolean",
                "description": "Show title",
                "x-looker-nullable": false
              },
              "title_color": {
                "type": "string",
                "description": "Title color",
                "x-looker-nullable": true
              },
              "show_filters_bar": {
                "type": "boolean",
                "x-looker-nullable": false
              },
              "tile_background_color": {
                "type": "string",
                "description": "Tile background color",
                "x-looker-nullable": true
              },
              "tile_text_color": {
                "type": "string",
                "description": "Tile text color",
                "x-looker-nullable": true
              },
              "text_tile_text_color": {
                "type": "string",
                "description": "Color of text on text tiles",
                "x-looker-nullable": true
              },
              "deleted": {
                "type": "boolean",
                "description": "Whether or not a dashboard is deleted.",
                "x-looker-nullable": false
              },
              "query_timezone": {
                "type": "string",
                "description": "Timezone in which the Dashboard will run by default.",
                "x-looker-nullable": true
              }
            },
            "x-looker-status": "beta"
          }
        }
      }
      SWAGGER
    end

    mock_sdk.define_singleton_method(:create_dashboard) do |req|
      return mock_dash_response
    end
    output = StringIO.new
    options = {}
    command = Lkr::Commands::Dashboard::Import.new(StringIO.new('{ "id": "500", "title": "New Dash", "description": "Description of the Dash", "dashboard_filters": [], "dashboard_elements": [], "dashboard_layouts": [] }'), 1, options)

    command.instance_variable_set(:@sdk, mock_sdk)

    command.execute(output: output)

    expect(output.string).to eq("")
  end
end
