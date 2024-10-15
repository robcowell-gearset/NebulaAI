public with sharing class OpenAIAPIHandler {
    
    public string APIKey {get; set;}
    
    public OpenAIAPIHandler()
    {
        APIKey = [SELECT KeyValue__c from OpenAIKey__mdt where Label = 'OpenAIKey' LIMIT 1].KeyValue__c;
        System.debug('Key - ' + APIKey);
    }
    
    @AuraEnabled(cacheable=true)
    public static string getCompletion(string prompt)
    {
        OpenAIAPIHandler apiHandler = new OpenAIAPIHandler();
        return apiHandler.completionRequest(prompt);
    }

    public string completionRequest(string prompt)
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setTimeout(20000);
        HttpResponse response = new HttpResponse();

        request.setEndpoint('https://api.openai.com/v1/chat/completions');
        request.setMethod('POST');
        request.setHeader('Authorization','Bearer ' + APIKey);
        request.setHeader('Content-Type','application/json;charset=UTF-8');
        
        //build the content
        Map<String, Object> requestMap = new Map<String, Object>{
            'messages' => new List<Object>{
                new Map<String, String>{                
                    'content' => prompt,
                    'role' => 'user'
                }
            },
            'model' => 'gpt-4o-mini'
        };
        String requestJson = JSON.serialize(requestMap);
        request.setBody(requestJson);
        

        response = http.send(request);
        return response.getBody();
    }
}