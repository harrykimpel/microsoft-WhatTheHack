var suffix = uniqueString('${subscription().subscriptionId}-${resourceGroup().name}')

#disable-next-line no-loc-expr-outside-params
var location = resourceGroup().location

param openAILocation string
param documentIntelligenceLocation string
param modelName string = 'gpt-4o'
param modelVersion string = '2024-11-20'
param embeddingModel string = 'text-embedding-ada-002'
param embeddingModelVersion string = '2'

module openai 'modules/openai.bicep' = {
  name: 'openAIDeployment'
  params: {
    #disable-next-line no-hardcoded-location
    location: openAILocation
    name: 'openai-${suffix}'
    deployments: [
      { name: modelName, version: modelVersion }
      { name: embeddingModel, version: embeddingModelVersion }
    ]
  }
}

output openAIKey string = openai.outputs.key1
output openAIEndpoint string = openai.outputs.endpoint
output modelName string = modelName
output modelVersion string = modelVersion
output embeddingModel string = embeddingModel
output embeddingModelVersion string = embeddingModelVersion

module search 'modules/search.bicep' = {
  name: 'searchDeployment'
  params: {
    name: 'search-${suffix}'
    location: location
  }
}

output searchKey string = search.outputs.primaryKey
output searchEndpoint string = search.outputs.endpoint
output searchName string = search.outputs.name
