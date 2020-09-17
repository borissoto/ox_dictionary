require 'ostruct'

class DictionaryController < ApplicationController
    def index
    end

    def search
        terms = find_term(params[:term])           
        if terms['status'] != 'OK'
            # puts terms['response']
            flash[:alert] = terms['response']
            return render action: :index                  
        else
            # puts terms['response']['word']
            word = terms['response']['word']
            definition = terms['response']['results'][0]['lexicalEntries'][0]['entries'][0]['senses'][0]['definitions'][0]            
            @word = word
            @term = definition
        end 
        
    end

    private 
    def status_code(status)
        message = ''
        case status
        when 400
            message = '400 BAD REQUEST: The filters provided are unknown, the source and target languages in the translation endpoint are the same, or a numeric parameter such as offset and limit in the wordlist endpoint cannot be evaluated as a number.'
        when 403
            message = '403 AUTHENTICATION FAILED: Please check that the app_id and app_key are correct, and that the URL you are trying to access is correct, or upgrade your account.'
        when 404
            message = '404 NOT FOUND: The headword could not be found, a region or domain identifier do not exist, or the headword does not contain any attribute that match the filters in the request. It may also be the case that the URL is misspelled or incomplete.'            
        when 414
            message = '414 REQUEST URI TO LONG: Your word_id exceeds the maximum 128 characters.'        
        when 500
            message = '500 INTERNAL SERVER ERROR: Something is broken. Please contact us so the Oxford Dictionaries API team can investigate.'
        when 502
            message = '502 BAD GATEWAY: Oxford Dictionaries API is down or being upgraded.'
        when 503
            message = '503 SERVICE UNAVALIABLE: The Oxford Dictionaries API servers are up, but overloaded with requests. Please try again later.'
        when 504
            message = '504 GATEWAY TIMEOUT: The Oxford Dictionaries API servers are up, but the request couldn’t be serviced due to some failure within our stack. Please try again later.'
        else
            message = 'Service unavaliable: '
        end
        data = {:status => 'error', :response => message}
        return response_obj = OpenStruct.new(data) 
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
    #   return nil if response.status != 200
      case response.status      
      when 400
        status_code(400)
      when 403
        status_code(403) 
      when 404
        status_code(404)       
      when 414
        status_code(414) 
      when 500
        status_code(500)
      when 502
        status_code(502) 
      when 503
        status_code(503) 
      when 504
        status_code(504)
      else
        data = {:status => 'OK', :response => JSON.parse(response.body)}
        return response_obj = OpenStruct.new(data)   
    end               
      
    end

    def find_term(term)
      request_api(
        "https://od-api.oxforddictionaries.com/api/v2/entries/en-us/#{term.downcase}"
    )
    end

   
end