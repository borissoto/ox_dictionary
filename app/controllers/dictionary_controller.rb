class DictionaryController < ApplicationController
    def index
    end

    def search
        terms = find_term(params[:term])        
        # if !terms
        #     puts 'no existe'
        # end    
        if !terms
            flash[:alert] = 'No entry found matching supplied source_lang, word and provided filters'
            return render action: :index                  
        else
            word = terms['word']
            definition = terms['results'][0]['lexicalEntries'][0]['entries'][0]['senses'][0]['definitions'][0]            
            @word = word
            @term = definition
        end 
        
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
        "https://od-api.oxforddictionaries.com/api/v2/entries/en-us/#{term.downcase}"
    )
    end

   
end