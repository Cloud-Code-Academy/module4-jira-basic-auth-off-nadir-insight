/**
 * Queueable class to make asynchronous callouts to Jira API
 */
public class JiraCalloutQueueable implements Queueable, Database.AllowsCallouts {
	// Simple constants instead of enum
	public static final String TYPE_PROJECT = 'PROJECT';
	public static final String TYPE_ISSUE = 'ISSUE';

	private String calloutType;
	private Id recordId;
	private JiraWrapper.ProjectWrapper projectWrapper;
	private JiraWrapper.IssueWrapper issueWrapper;

	/**
	 * Constructor for Jira Project callout
	 * @param recordId The Salesforce Jira Project record Id
	 * @param projectName The name of the project
	 * @param projectKey The unique key for the project
	 * @param description Project description
	 */
	public JiraCalloutQueueable(
		Id recordId,
		String projectName,
		String projectKey,
		String description
	) {
		this.calloutType = TYPE_PROJECT;
		this.recordId = recordId;
		this.projectWrapper = new JiraWrapper.ProjectWrapper(projectName, projectKey, description);
	}

	/**
	 * Constructor for Jira Issue callout
	 * @param recordId The Salesforce Jira Issue record Id
	 * @param projectKey The project key where the issue should be created
	 * @param summary The issue summary/title
	 * @param description Issue description
	 * @param issueType The type of issue
	 */
	public JiraCalloutQueueable(
		Id recordId,
		String projectKey,
		String summary,
		String description,
		String issueType
	) {
		this.calloutType = TYPE_ISSUE;
		this.recordId = recordId;
		this.issueWrapper = new JiraWrapper.IssueWrapper(
			projectKey,
			summary,
			description,
			issueType
		);
	}

	/**
	 * Execute the callout based on the callout type
	 *
	 * TODO: Implement this method to:
	 * 1. Check the callout type (TYPE_PROJECT or TYPE_ISSUE)
	 * 2. Call the appropriate JiraAPIService method
	 * 3. Update the corresponding Salesforce record with the Jira ID/Key
	 */
	public void execute(QueueableContext context) {
		// Your implementation goes here
        if (this.calloutType == TYPE_PROJECT) {
            String jiraProjectId = JiraAPIService.createProject(this.projectWrapper);
            updateJiraProject(jiraProjectId);
        } else if (this.calloutType == TYPE_ISSUE) {
            // process issue request
            String jiraIssueKey = JiraAPIService.createIssue(this.issueWrapper);
            updateJiraIssue(jiraIssueKey);
        }
	}

	/**
	 * Update the Jira Project record with the Jira project Id
	 *
	 * TODO: Implement this method to update the Jira_Project__c record
	 * with the Jira project ID returned from the API
	 */
	private void updateJiraProject(String jiraProjectId) {
		// Your implementation goes here
        Jira_Project__c jiraProjectToUpdate = new Jira_Project__c(Id = this.recordId);
        jiraProjectToUpdate.Project_ID__c = jiraProjectId;
        update jiraProjectToUpdate;
	}

	/**
	 * Update the Jira Issue record with the Jira issue key
	 *
	 * TODO: Implement this method to update the Jira_Issue__c record
	 * with the Jira issue key returned from the API
	 * Don't forget to update the Last_Updated__c field with the current time
	 */
	private void updateJiraIssue(String jiraIssueKey) {
		// Your implementation goes here
        Jira_Issue__c jiraIssueToUpdate = new Jira_Issue__c(Id = this.recordId);
        jiraIssueToUpdate.Last_Updated__c = System.now();
        jiraIssueToUpdate.Issue_Key__c = jiraIssueKey;

        update jiraIssueToUpdate;
	}
}
