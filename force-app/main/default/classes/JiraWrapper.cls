/**
 * Wrapper classes for Jira entities (Project and Issue)
 */
public class JiraWrapper {
	private static final String LEAD_ACCOUNT_ID = '640fb1499796ea0a871624e9';
	private static final String PROJECT_TEMPLATE_KEY = 'com.pyxis.greenhopper.jira:basic-software-development-template';

	/**
	 * Wrapper for Jira Project
	 */
	public class ProjectWrapper {
		public String name;
		public String key;
		public String description;
		public String leadAccountId;
		public String projectTemplateKey;

		/**
		 * Constructor for ProjectWrapper
		 */
		public ProjectWrapper(String name, String key, String description) {
			this.name = name;
			this.key = key;
			this.description = description;
			this.leadAccountId = LEAD_ACCOUNT_ID;
			this.projectTemplateKey = PROJECT_TEMPLATE_KEY;
		}
	}

	/**
	 * Wrapper for Jira Issue
	 */
	public class IssueWrapper {
		public String name;
		public String key;
		public String description;
		public String projectKey;
		public String summary;
		public String issueType;

		/**
		 * Constructor for IssueWrapper
		 */
		public IssueWrapper(
			String projectKey,
			String summary,
			String description,
			String issueType
		) {
			this.projectKey = projectKey;
			this.summary = summary;
			this.description = description;
			this.issueType = (String.isNotBlank(issueType)) ? issueType : 'Task';
		}

		/**
		 * Convert IssueWrapper to a Map for serialization
		 *
		 * TODO: Implement this method to create a Map that represents
		 * the JSON payload needed for the Jira API. The Map should contain:
		 * - [x] fields object with project information (key)
		 * - [x] issuetype object with the issue type name
		 * - [x] summary field
		 * - [x] description field (formatted using formatDescription method)
		 * - Example:
		 */
		public Map<String, Object> generateIssuePayloadMap() {
			// Your implementation goes here
            Map<String, Object> fieldsMap = new Map<String, Object>();
            fieldsMap.put('project', new Map<String, Object>{'id' => this.projectKey});
            fieldsMap.put('issuetype', new Map<String, Object>{'id' => this.issueType});
            fieldsMap.put('summary', this.summary);
            fieldsMap.put('description', formatDescription(this.description));
            Map<String, Object> jsonPayload = new Map<String, Object>{
                'fields' => fieldsMap
            };
			return jsonPayload;
		}

		/**
		 * Format description as per Jira Cloud API requirements
		 *
		 * TODO: Implement this method to format the description text
		 * according to Jira Cloud API requirements.
		 * - Create a Map with type="doc" and version=1
		 * - Add content array with paragraph object
		 * - Add text object inside paragraph content with the description
		 * - Example:
		 *   {
		 *     "description": {
		 *       "type": "doc",
		 *       "version": 1,
		 *       "content": [
		 *         {
		 *           "type": "paragraph",
		 *           "content": [
		 *             {
		 *               "type": "text",
		 *               "text": "Order entry fails when selecting supplier."
		 *             }
		 *           ]
		 *         }
		 *       ]
		 *     }
		 *   }
		 */
		private Map<String, Object> formatDescription(String descText) {
			List<Object> textContentList = new List<Object>();
            Map<String, Object> textContent = new Map<String, Object> {
                'type' => 'text',
                'text' => descText
            };
            textContentList.add(textContent);
            Map<String, Object> paragraphContent = new Map<String, Object> {
                'type' => 'paragraph',
                'content' => textContentList
            };
            Map<String, Object> descriptionMap = new Map<String, Object>();
            descriptionMap.put('type', 'doc');
            descriptionMap.put('version', 1);
			descriptionMap.put('content', paragraphContent);
            Map<String, Object> description = new Map<String, Object>{
                'description' => descriptionMap
            };

            return description;
		}
	}
}
