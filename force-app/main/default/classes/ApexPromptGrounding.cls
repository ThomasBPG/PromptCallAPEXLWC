public class ApexPromptGrounding {
 
    @InvocableMethod(
      // Matches the API Name of the template
      CapabilityType='FlexTemplate://FlexMessage1')
    public static List<Response> getPrompt(List<Request> requests) {
        Request input = requests[0];
        List<Response> responses = new List<Response>();
        Response output = new Response();

        output.Prompt = '\n';

        Decimal threadId = input.MessageId.Thread__c;
        
        // Get all Messages
        List<Message__c> messages = [SELECT Author__c, Content__c FROM Message__c WHERE Thread__c= :threadId ORDER BY CreatedDate];

		for (Message__c message : messages)
        {
            output.Prompt += '\nAuthor of message: ' + message.Author__c;
            output.Prompt += '\nContent of message: ' + message.Content__c;
            output.Prompt += '\n';
        }
        responses.add(output);
        
        return responses;
    }
 
    // Type and API Name of all variables must match the template
    public class Request {
        @InvocableVariable(required=true)
        public Message__c MessageId;
    }

    public class Response {
        @InvocableVariable
        public String prompt;
    }
}