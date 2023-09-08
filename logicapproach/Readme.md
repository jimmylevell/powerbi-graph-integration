# Using Logic Apps to load Graph Data into Power BI
## Pre-requisites
### Azure AD
- Create a new Azure AD App Registration
- Assign the required application permission as application

### Logic App
- Create a new Logic App
- Add the logic app code from [logicapp.json](logicapp.json) within Logic app code view
- Within the Logic app designer extract the URL for the HTTP Request trigger

### Power BI
- Create a new Power BI report
- Add a new data source from a blank query
- Rename the query to `Get-GraphData`
- Add the power bi code from [powerbi.pq](powerbi.pq) within the advanced editor
- Within the power bi code change the following values
  - `tenantid` - Azure AD tenant id
  - `clientid` - Azure AD app registration client id
  - `logicappurl` - Logic app URL from the HTTP Request trigger
- A yellow banner will appear stating Information is required about data privacy, click Continue
- Select Ignore Privacy (as per below screenshot), Alternatively, change the data sources to private, then click Save

## References
- [Microsoft Graph and PowerBI](https://euc365.com/microsoft-graph-and-powerbi/)
