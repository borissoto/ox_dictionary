class DictionaryController < ApplicationController
    def index
    end

    def search
        terms = find_term(params[:term])
        puts terms
        unless terms
          flash[:alert] = 'Term not found'
          return render action: :index
        end  
        @term = terms
    end

    private
    def request_api(url)
      response = Excon.get(
        url,
        headers: {
          'app_id' => 'e53bf98b',
          'app_key' => '94ce74f763ee75b7331c9b61fc18d8b1'
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