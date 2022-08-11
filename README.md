# Internal Assessment
fork this repository to start working in your own implementation

## Objective
Understand your current programming level in a practical assessment with the idea of understanding better where you are in your career path, what is needed to become a better professional and how The Ksquare Group can help you to get there.

## Considerations
* The solution will be used to understand the current team level. Do your best and take it as seriously as possible.

* The feedback is for statistics purposes and to see where we need to improve as a practice. It will not have an impact in the appraisal or any other employee evaluation.
    
* It is important that you track the approximate time that you used to implement the solution.
    
* It is not allowed to share code or ask for help between colleagues.

## Practice Assessment

### Pre-requisites
1. Create a new Developer Org o Yourname@assesmentksquaregroup.com / Force.com1
2. Create a GitHub account with your Ksquare email.
3. In your Org enable Contact to multiple Accounts Features


### Submitting Assessment
When complete, perform the following steps

* Create a new user
    * Role: CEO
    * Profile: System Administrator
    * Email: TBD
* Create a new field within the User Object
    * Name: Assessment Complete
    * Type: Checkbox
* Create an automated process that when the “Assessment Complete” checkbox is set to true, sends and e-mail notification to the corresponding user.
    * The email should contain the User’s username in the body as well as your name and date of completion and the time used to build the entire solution. It should also contain the GitHub repository URL.

### Important Notes
Make sure to include everything in the repository (code, fields, templates, etc.), if it is not in GitHub, it would not be considered as part of the solution.
Your solution must be ready to be deployed to Production, so please consider everything needed for this.

- - - -

# Back-end Practice Assessment
A technical requirement for a client is to update all related contacts once its parent account is updated. However, if the total count of contacts to update in a transaction is greater than 200 records the update should happen asynchronously in the following manner:

* If 1000 <= total contact count > 200, use a one-time process to update the records.
* If total contact count > 1000, the records must be updated in smaller chunks of ideally 150 records per chunk
* In the case of total contact count <= 200, update contacts synchronously.
* The field to consider on the parent Account is a new custom field called PushToVendor__c, this is picklist field containing the values “Yes” and “no”.
* Any time this field is set to “Yes”, all related contacts for the account should be updated to have Push_Date__c = Today’s Date
    * Push_Date__c is a date/time field on the Contact Object.

* Any time this fied is set to “No”, all related contacts for the account should be updated to have Push_Date__c = null
- - - -
# Front-end Practice Assessment

The client has requested a new Lightning Web Component that can be launched for an Account record.
The Component must display a list of all Contact directly or indirectly related to the account and allow the user to search using a type-ahead functionality among the Account’s contacts sorting by Name. Consider using “Lazy loading” for better performance.

If the user clicks on one of the names in the list, a section with the contact details must appear at the right. This section must display a contact photo, the name, role, phone, and email. When the user clicks on the photo it is redirected to the Contact details page.

Additionally, the client wants the ability to create and associate a new contact for the account.

The client has provided the following mock-up:

![Alt text](contact-search.png?raw=true "Optional Title")

Also, the client provided the following user story or Acceptance test:
* I Go to an account detail page
* I’m able to view and click the “Contact Search” button
* The new Component is displayed
* I can search by Name
* As I type, when the character count is equal to 3 or more the system performs a search and display any contact that begins with the string I typed.
* I continue to type the full name of the contact, I can either press the “Search” button or hit Enter to execute the search
* The results are displayed in a table showing the following data points:
    * Name
    * Email [Hyperlink to launch email app]
    * Phone Number

