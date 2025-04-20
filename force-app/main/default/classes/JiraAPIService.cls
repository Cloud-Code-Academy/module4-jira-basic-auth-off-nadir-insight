/**
 * Service class for making callouts to the Jira API
 */
public with sharing class JiraAPIService {
	/**
	 * Creates a project in Jira
	 * @param projectWrapper The project wrapper object containing all necessary data
	 * @return String The Jira project ID
	 *
	 * TODO: Implement this method to make a callout to Jira API to create a project
	 * Reminder: Extract and return the project ID from the response
	 */
	public static String createProject(JiraWrapper.ProjectWrapper projectWrapper) {
		// Your implementation goes here 

        String endpoint = 'callout:jira/project';

        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);        
        request.setMethod('POST');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(JSON.serialize(projectWrapper));

        Http http = new Http();
        HttpResponse response = http.send(request);

        Map<String, Object> jsonBodyMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        Integer projectId = (Integer) jsonBodyMap.get('id');

		return String.valueOf(projectId);
	}

	/**
	 * Creates an issue in Jira
	 * @param issueWrapper The issue wrapper object containing all necessary data
	 * @return String The Jira issue key
	 *
	 * TODO: Implement this method to make a callout to Jira API to create an issue
	 * Reminder: Extract and return the issue key from the response
	 */
	public static String createIssue(JiraWrapper.IssueWrapper issueWrapper) {
		// Your implementation goes here

        String endpoint = 'callout:jira/issue';
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);        
        request.setMethod('POST');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(JSON.serialize(issueWrapper));

        Http http = new Http();
        HttpResponse response = http.send(request);

        Map<String, Object> jsonBodyMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        String issueKey = (String) jsonBodyMap.get('key');

		return issueKey;
	}
}
