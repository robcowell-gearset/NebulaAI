public class BatchCreateTestAccounts implements Database.Batchable<Integer> {
    
    // Number of records to create per batch execution
    private static final Integer BATCH_SIZE = 200;
    private static final Integer TOTAL_RECORDS = 2000;

    // This method generates the list of integers for our batch scope
    public Iterable<Integer> start(Database.BatchableContext BC) {
        List<Integer> scope = new List<Integer>();
        for (Integer i = 0; i < TOTAL_RECORDS; i++) {
            scope.add(i);
        }
        return scope;
    }

    // The execute method processes the current batch of integers to create Account records
    public void execute(Database.BatchableContext BC, List<Integer> scope) {
        List<Account> accountsToCreate = new List<Account>();
        
        for (Integer i : scope) {
            Account acc = new Account();
            acc.Name = 'Test Account ' + String.valueOf(Math.floor(Math.random() * 1000000));
            acc.Industry = 'Technology';
            acc.BillingCity = 'San Francisco';
            acc.BillingState = 'CA';
            acc.BillingCountry = 'USA';
            accountsToCreate.add(acc);
        }

        // Insert the batch of Accounts
        if (accountsToCreate.size() > 0) {
            try {
                insert accountsToCreate;
            } catch (DmlException e) {
                // Handle exception (Optional)
                //System.debug('Error inserting Accounts: ' + e.getMessage());
                Logger.error(e.getMessage());
                Logger.saveLog();
            }
        }
    }

    // This method is called after all the batches are processed
    public void finish(Database.BatchableContext BC) {
        System.debug('Batch Job complete.');
    }
    
    // Method to start the batch job
    public static void executeBatch() {
        Database.executeBatch(new BatchCreateTestAccounts(), BATCH_SIZE);
    }
}
