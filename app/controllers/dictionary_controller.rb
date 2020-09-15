class DictionaryController < ApplicationController
    def index
    end

    def search
        terms = find_term(params[:term])
        unless terms
          flash[:alert] = 'Term not found'
          return render action: :index
        end        
    end

    private
    def request_api(url)
      response = Excon.get(
        url,
        headers: {
          'app_id' => '',
          'app_key' => ''
        }
      )
      return nil if response.status != 200
      JSON.parse(response.body)
    end

    def find_term(term)
      request_api(
        "https://od-api.oxforddictionaries.com/api/v2/entries/en-us/#{term}"
    )
    end

   
end