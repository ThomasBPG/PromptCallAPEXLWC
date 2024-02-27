public with sharing class PromptCall {

    @AuraEnabled(cacheable=false)
	public static String generateResponse(String messageId)
    {
        String returnResponse = null;
        // Create input
        ConnectApi.EinsteinPromptTemplateGenerationsInput promptGenerationsInput = new ConnectApi.EinsteinPromptTemplateGenerationsInput();
        promptGenerationsInput.isPreview = false;
        
        // Build input map and reference the parameter messageId
        Map<String,ConnectApi.WrappedValue> valueMap = new Map<String,ConnectApi.WrappedValue>();
        Map<String, String> relatedEntityRecordIdMap = new Map<String, String>();
        relatedEntityRecordIdMap.put('id', messageId);
        
        ConnectApi.WrappedValue relatedEntityWrappedValue = new ConnectApi.WrappedValue();
        relatedEntityWrappedValue.value = relatedEntityRecordIdMap;
        
        // Wrap value and set to the appropriate template input. You see this in Prompt Builder -> Template -> Settings -> Template Details
        valueMap.put('Input:Message__c', relatedEntityWrappedValue);
        
        // Finally set the input parameters in the prompt-input.
        promptGenerationsInput.inputParams = valueMap;
        
        // Set additional configuration values
        promptGenerationsInput.additionalConfig = new ConnectApi.EinsteinLlmAdditionalConfigInput();
        promptGenerationsInput.additionalConfig.applicationName = 'PromptTemplateGenerationsInvocable';
        
        // Call the service
        ConnectApi.EinsteinPromptTemplateGenerationsRepresentation generationsOutput = 
        ConnectApi.EinsteinLLM.generateMessagesForPromptTemplate('0hfao000000VBLlAAO', promptGenerationsInput); // Fetch the recordId in first param from the URL in Prompt Builder.

        // Unwrap the actual response...
        List<ConnectApi.EinsteinLlmGenerationItemOutput> promptResponses = generationsOutput.generations;
        System.debug('Num of responses: ' + promptResponses.size());

        if(promptResponses.size()>0)
        {
        	ConnectApi.EinsteinLLMGenerationItemOutput firstResponse = promptResponses.get(0);
            returnResponse = firstResponse.text;
        }
        else
            returnResponse = '';
        
        return returnResponse;
    }
}