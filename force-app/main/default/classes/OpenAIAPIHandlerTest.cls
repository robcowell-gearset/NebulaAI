@isTest
private class OpenAIAPIHandlerTest {
    
    // Mock HTTP Response Class
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"id":"chatcmpl-123","object":"chat.completion","created":1677652288,"model":"gpt-3.5-turbo","choices":[{"message":{"role":"assistant","content":"Hello, how can I assist you today?"},"finish_reason":"stop"}]}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    @isTest
    static void testOpenAIAPIHandler() {
        // Insert test data for OpenAIKey__mdt
        OpenAIKey__mdt key = [SELECT Label, KeyValue__c FROM OpenAIKey__mdt WHERE Label = 'OpenAI30Jul'];
                
        OpenAIAPIHandler handler = new OpenAIAPIHandler();
        
        // Test the completionRequest method
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Test.startTest();
        String response = handler.completionRequest('Hello');
        Test.stopTest();
        
        System.assert(response.contains('Hello, how can I assist you today?'), 'Response should contain the expected message');
    }
}