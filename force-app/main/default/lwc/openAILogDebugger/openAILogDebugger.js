import { LightningElement, track, wire, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getCompletion from '@salesforce/apex/OpenAIAPIHandler.getCompletion';

// Specify the fields to fetch
const FIELDS = ['LogEntry__c.Message__c', 'LogEntry__c.StackTrace__c'];

export default class LogAnalysis extends LightningElement {
    @track log = '';
    @track analysis = '';
    @track isLoading = false;
    @api recordId;

    // Fetch the LogEntry__c.Message__c field from the record
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    loadLog({ error, data }) {
        if (data) {
            this.log = 'Message:\n' + data.fields.Message__c.value + '\nStack trace:\n' + data.fields.StackTrace__c.value;
        } else if (error) {
            this.log = 'Error loading log data';
        }
    }

    handleLogChange(event) {
        this.log = event.target.value;
    }

    analyzeLog() {
        this.isLoading = true; // Show spinner
        const prompt = 'Please analyze the following log and suggest fixes for any issues found: ' + this.log;
        
        getCompletion({ prompt })
            .then(result => {
                const parsedResult = JSON.parse(result);
                this.analysis = parsedResult.choices[0].message.content;
            })
            .catch(error => {
                this.analysis = 'Error analyzing log: ' + error.body.message;
            })
            .finally(() => {
                this.isLoading = false; // Hide spinner when done
            });
    }
}