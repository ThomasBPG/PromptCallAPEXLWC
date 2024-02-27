import { LightningElement,track,api } from 'lwc';
import generateResponse from "@salesforce/apex/PromptCall.generateResponse";
import { getRecord } from "lightning/uiRecordApi";

export default class PromptCall extends LightningElement {

    @api recordId;
    @track promptResponse;
    @track isLoading = false;

    callPrompt()
    {
        console.debug("Calling prompt...");
        this.isLoading = true;
        generateResponse({ messageId: this.recordId }).then((result) => {
            console.debug("Prompt result: " + result);
            this.promptResponse = result;
            this.isLoading = false;
        }).catch((error) => {
            console.debug("Prompt call error: " + JSON.stringify(error));
            this.isLoading = false;
        });

    }

}