// All functions and the SessionToken Query must be within EACH query as when publishing to PowerBI Online you will receive and unable to access data source.
let
    // ************************************* SessionToken *************************************
    SessionToken =
        let
            TokenUri = "https://login.microsoftonline.com/",
            ResourceId = "https://graph.microsoft.com",
            TokenResponse = Json.Document(
                Web.Contents(
                    TokenUri,
                    [
                        Content = Text.ToBinary(
                            Uri.BuildQueryString(
                                [
                                    client_id = "XXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
                                    resource = ResourceId,
                                    grant_type = "client_credentials",
                                    client_secret = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                                ]
                            )
                        ),
                        Headers = [Accept = "application/json"],
                        ManualStatusHandling = {400},
                        RelativePath = "XXXXX-TENANT_ID-XXXXX" & "/oauth2/token"
                    ]
                )
            ),
            AzureAccessToken = TokenResponse[access_token]
        in
            AzureAccessToken,
    // ************************************* SessionToken *************************************
    // ************************************* LogicAppCall *************************************
    MSGraphLA =
        let
            Source = (#"GraphURL" as any) =>
                let
                    Url = "https://prod-XX.westus.logic.azure.com:443/workflows/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
                    body = "{""accesstoken"":""" & SessionToken & """, ""URL"":""" & #"GraphURL" & """}",
                    Source = Json.Document(
                        Web.Contents(
                            Url, [
                                Headers = [#"Content-Type" = "application/json"],
                                Content = Text.ToBinary(body)
                            ]
                        )
                    )
                in
                    Source
        in
            Source,
    // ************************************* LogicAppCall *************************************
    // ************************************* MS Graph Call *************************************
    GraphCall =
        let
            Source = (#"GraphURL" as any) =>
                let
                    Source = Json.Document(
                        Web.Contents(
                            "https://graph.microsoft.com/beta/",
                            [
                                RelativePath = #"GraphURL",
                                Headers = [
                                    Authorization = "Bearer " & #"SessionToken",
                                    Accept = "application/json"
                                ]
                            ]
                        )
                    )
                in
                    Source
        in
            Source,
    // ************************************* MS Graph Call *************************************
    Source = #"MSGraphLA"("https://graph.microsoft.com/beta/deviceManagement/managedDevices?$select=id"),
    // ************************************* MS Graph Call *************************************
    Source1 = Source{0},
    #"Converted to Table" = Record.ToTable(Source1),
    Value = #"Converted to Table"{2}[Value],
    #"Converted to Table1" = Table.FromList(Value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    ShowIDs = Table.ExpandRecordColumn(#"Converted to Table1", "Column1", {"id"}, {"id"})
in
    ShowIDs
